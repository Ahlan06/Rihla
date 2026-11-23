extends Node3D

const HORSE = preload("res://Horse.glb")
const CAMP = Vector2(12, -66)
var mount := Node3D.new()
var camera := Camera3D.new()
var info := Label.new()
var animator: AnimationPlayer
var clips := {}
var speed := 0.0
var heading := 0.0
var arrived := false

func sand(x: float, z: float) -> float:
	return 2.5 * sin(z * .074 + .5 * sin(x * .11)) + 1.7 * cos(x * .09 + z * .03)

func shape(parent: Node3D, geo: PrimitiveMesh, color: Color, pos: Vector3, size: Vector3) -> MeshInstance3D:
	var item := MeshInstance3D.new()
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	item.mesh = geo
	item.material_override = material
	parent.add_child(item)
	item.position = pos
	item.scale = size
	return item

func terrain():
	var surface := SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	for z in range(-128, 129, 2):
		for x in range(-128, 129, 2):
			for corner in [Vector2i(0,0),Vector2i(2,0),Vector2i(0,2),Vector2i(2,0),Vector2i(2,2),Vector2i(0,2)]:
				var px: int = x + corner.x
				var pz: int = z + corner.y
				surface.add_vertex(Vector3(px,sand(px,pz),pz))
	surface.index()
	surface.generate_normals()
	var ground := MeshInstance3D.new()
	ground.mesh = surface.commit()
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color("#cf9766")
	ground.material_override = mat
	add_child(ground)

func ready_rider():
	add_child(mount)
	var horse := HORSE.instantiate() as Node3D
	mount.add_child(horse)
	horse.scale = Vector3.ONE * .52
	animator = horse.find_children("*", "AnimationPlayer", true, false)[0]
	for clip in animator.get_animation_list():
		var key := String(clip).get_slice("|",1)
		if key == "": key = String(clip).split("_")[-1]
		clips[key] = clip
		animator.get_animation(clip).loop_mode = Animation.LOOP_LINEAR
	for part in horse.find_children("*","MeshInstance3D",true,false):
		var dark := StandardMaterial3D.new()
		dark.albedo_color = Color("#382d30")
		part.material_override = dark
	var rider := Node3D.new()
	mount.add_child(rider)
	rider.position = Vector3(0,1.52,.08)
	var robe := CylinderMesh.new()
	robe.top_radius = .21
	robe.bottom_radius = .39
	robe.height = .88
	shape(rider,robe,Color.IVORY,Vector3(0,.23,0),Vector3.ONE)
	for side in [-1,1]:
		shape(rider,SphereMesh.new(),Color.IVORY,Vector3(side*.29,.32,-.12),Vector3(.20,.33,.2))
		shape(rider,SphereMesh.new(),Color("#54382b"),Vector3(side*.32,-.28,0),Vector3(.22,.35,.24))
	var head := shape(rider,SphereMesh.new(),Color.WHITE,Vector3(0,.83,0),Vector3(.4,.46,.4))
	var scarf := shape(rider,SphereMesh.new(),Color.WHITE,Vector3(0,.62,.09),Vector3(.48,.42,.33))
	var weave := Image.create(64,64,false,Image.FORMAT_RGB8)
	for y in 64:
		for x in 64:
			weave.set_pixel(x,y,Color("#292831") if (x+y)%12<3 or posmod(x-y,12)<3 else Color.IVORY)
	head.material_override.albedo_texture = ImageTexture.create_from_image(weave)
	scarf.material_override = head.material_override

func _ready():
	terrain()
	ready_rider()
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-30,-42,0)
	sun.light_color = Color("#ffdbc0")
	sun.shadow_enabled = true
	add_child(sun)
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color("#d4a6a0")
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color("#c1afc7")
	env.ambient_light_energy = .65
	env.fog_enabled = true
	env.fog_density = .003
	env.fog_light_color = Color("#ca9e91")
	camera.environment = env
	add_child(camera)
	camera.current = true
	for point in [Vector2(-42,-72),Vector2(30,-105),Vector2(53,-113)]:
		var pyramid := CylinderMesh.new()
		pyramid.radial_segments = 4
		pyramid.top_radius = 0
		pyramid.bottom_radius = 14
		pyramid.height = 17
		shape(self,pyramid,Color("#ba845c"),Vector3(point.x,sand(point.x,point.y)+7,point.y),Vector3.ONE)
	for dx in [-5,5]:
		var tent := PrismMesh.new()
		tent.size = Vector3(5,3,5)
		shape(self,tent,Color("#894940"),Vector3(CAMP.x+dx,sand(CAMP.x+dx,CAMP.y)+1.35,CAMP.y),Vector3.ONE)
	shape(self,CylinderMesh.new(),Color("#624735"),Vector3(CAMP.x,sand(CAMP.x,CAMP.y)+2,CAMP.y),Vector3(.12,2,.12))
	shape(self,BoxMesh.new(),Color.INDIGO,Vector3(CAMP.x+.85,sand(CAMP.x,CAMP.y)+3.7,CAMP.y),Vector3(1.7,.85,.06))
	add_child(info)
	info.position = Vector2(20,16)
	info.add_theme_constant_override("outline_size",4)
	info.add_theme_color_override("font_outline_color",Color("#322939"))
	_physics_process(0)

func _physics_process(dt: float):
	var drive := Input.get_axis("ui_down","ui_up")
	var turn := Input.get_axis("ui_right","ui_left")
	speed = move_toward(speed,drive*(11 if Input.is_key_pressed(KEY_SHIFT) else 5),dt*6)
	heading += turn * dt * 1.8
	var forward := Vector3(-sin(heading),0,-cos(heading))
	var p := mount.position + forward*speed*dt
	p.x = clampf(p.x,-120,120)
	p.z = clampf(p.z,-120,120)
	p.y = sand(p.x,p.z)
	mount.position = p
	mount.rotation.y = heading
	var slope := sand(p.x+forward.x,p.z+forward.z)-p.y
	mount.rotation.x = atan(slope)
	var gait := "Idle" if abs(speed)<.25 else ("Walk" if abs(speed)<6 else "Gallop")
	if clips.has(gait) and animator.current_animation != clips[gait]:
		animator.play(clips[gait],.25)
	var behind := p-forward*6
	behind.y = maxf(p.y+3.3,sand(behind.x,behind.z)+2.2)
	camera.position = behind if dt==0 else camera.position.lerp(behind,1-exp(-dt*7))
	camera.look_at(p+Vector3.UP*1.45+forward*1.8)
	var remaining := Vector2(p.x,p.z).distance_to(CAMP)
	arrived = arrived or remaining < 4
	info.text = ("Campement atteint · Exploration libre" if arrived else "Rejoins le fanion indigo · %d m" % roundi(remaining)) + "\nFlèches : avancer, reculer et tourner · Maj : galoper"
