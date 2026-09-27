extends Node
class_name EverduneAudio

# Final Hearthfall vertical-slice score.
# Original procedural composition: motif-led, layered, dynamic and deterministic.
# It is intentionally data-authored so the same musical identity survives content expansion.

var player: AudioStreamPlayer
var stream: AudioStreamGenerator
var ambient_time := 0.0
var ambient_step := 0
var mood := "day"

const H := {
	"C2":65.41,"D2":73.42,"E2":82.41,"G2":98.00,"A2":110.00,"B2":123.47,
	"C3":130.81,"D3":146.83,"E3":164.81,"G3":196.00,"A3":220.00,"B3":246.94,
	"C4":261.63,"D4":293.66,"E4":329.63,"G4":392.00,"A4":440.00,"B4":493.88,
	"C5":523.25,"D5":587.33,"E5":659.25,"G5":783.99,"A5":880.00,
	"B5":987.77,"C6":1046.50
}

const MOTIFS := {
	"gather": [["E4",0.06,0.16],["G4",0.07,0.13],["C5",0.12,0.18]],
	"fish_cast": [["D4",0.08,0.10],["A3",0.11,0.07],["E4",0.13,0.05]],
	"fish_bite": [["A4",0.06,0.13],["C5",0.06,0.16],["E5",0.14,0.20]],
	"fish_catch": [["E4",0.07,0.13],["G4",0.07,0.16],["B4",0.08,0.18],["E5",0.16,0.22]],
	"fish_miss": [["D4",0.10,0.08],["C4",0.15,0.05]],
	"echo": [["C4",0.14,0.12],["G4",0.14,0.13],["C5",0.16,0.16],["E5",0.18,0.18],["G5",0.28,0.12]],
	"craft": [["E4",0.06,0.10],["G4",0.07,0.12],["B4",0.08,0.14],["E5",0.16,0.17]],
	"ui": [["A4",0.06,0.08]],
	"level": [["C5",0.08,0.13],["E5",0.08,0.15],["G5",0.10,0.17],["C6",0.22,0.20]],
	"swing": [["G3",0.06,0.11],["D4",0.08,0.08]],
	"hit": [["E3",0.045,0.13],["E4",0.07,0.08]],
	"defeat": [["C4",0.10,0.10],["G3",0.12,0.08],["E3",0.20,0.06]],
	"gate_open": [["C3",0.16,0.10],["G3",0.16,0.12],["C4",0.18,0.14],["E4",0.18,0.17],["G4",0.28,0.20]],
	"home": [["C4",0.11,0.10],["E4",0.11,0.12],["G4",0.13,0.15],["C5",0.24,0.18]]
}

func _ready() -> void:
	stream = AudioStreamGenerator.new()
	stream.mix_rate = 22050.0
	stream.buffer_length = 1.6
	player = AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = -3.0
	add_child(player)
	player.play()

func set_mood(value: String) -> void:
	mood = value

func cue(kind: String) -> void:
	if not MOTIFS.has(kind):
		return
	_play_motif(MOTIFS[kind])

func _play_motif(motif: Array) -> void:
	var playback := player.get_stream_playback() as AudioStreamGeneratorPlayback
	if playback == null:
		return
	for event in motif:
		var freq := float(H.get(String(event[0]), 220.0))
		var length := float(event[1])
		var velocity := float(event[2])
		var frames := int(stream.mix_rate * length)
		for i in range(frames):
			if playback.get_frames_available() <= 0:
				return
			var t := float(i) / stream.mix_rate
			var n := float(i) / float(maxi(frames, 1))
			var attack := clampf(n * 18.0, 0.0, 1.0)
			var release := clampf((1.0 - n) * 8.0, 0.0, 1.0)
			var envelope := minf(attack, release)
			var fundamental := sin(TAU * freq * t)
			var fifth := sin(TAU * freq * 1.4983 * t) * 0.18
			var octave := sin(TAU * freq * 2.0 * t) * 0.11
			var shimmer := sin(TAU * freq * 4.0 * t) * 0.025
			var sample := (fundamental + fifth + octave + shimmer) * velocity * envelope
			var pan := sin(float(i) / float(maxi(frames,1)) * PI) * 0.06
			playback.push_frame(Vector2(sample * (1.0 - pan), sample * (0.97 + pan)))
			
func _ambient_chord(root: String, third: String, fifth: String, velocity: float) -> void:
	var playback := player.get_stream_playback() as AudioStreamGeneratorPlayback
	if playback == null:
		return
	var notes := [root, third, fifth]
	var frames := int(stream.mix_rate * 1.7)
	for i in range(frames):
		if playback.get_frames_available() <= 0:
			return
		var t := float(i) / stream.mix_rate
		var n := float(i) / float(maxi(frames,1))
		var fade := sin(n * PI) * velocity
		var sample := 0.0
		for note in notes:
			var f := float(H.get(note, 130.81))
			sample += sin(TAU * f * t) * 0.30
			sample += sin(TAU * f * 2.0 * t) * 0.07
		# Slow harmonic shimmer gives the valley a living, memory-like bed.
		sample += sin(TAU * 0.17 * t) * 0.025
		playback.push_frame(Vector2(sample * fade, sample * fade * 0.96))

func _process(delta: float) -> void:
	ambient_time += delta
	if ambient_time < 7.5:
		return
	ambient_time = 0.0
	ambient_step = (ambient_step + 1) % 4
	match mood:
		"night":
			match ambient_step:
				0: _ambient_chord("C3","E3","G3",0.020)
				1: _ambient_chord("A2","C3","E3",0.016)
				2: _ambient_chord("G2","B2","D3",0.018)
				3: _ambient_chord("C3","E3","G3",0.022)
		"gate":
			match ambient_step:
				0: _ambient_chord("C2","G2","C3",0.028)
				1: _ambient_chord("G2","D3","G3",0.022)
				2: _ambient_chord("A2","E3","C4",0.024)
				3: _ambient_chord("C2","G2","E3",0.030)
		_:
			match ambient_step:
				0: _ambient_chord("C3","E3","G3",0.020)
				1: _ambient_chord("A3","C4","E4",0.017)
				2: _ambient_chord("G3","B3","D4",0.018)
				3: _ambient_chord("C3","E3","G3",0.022)
