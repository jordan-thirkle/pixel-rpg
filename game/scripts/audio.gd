extends Node
class_name EverduneAudio

# Authored procedural score for the vertical slice.
# Motifs are intentionally written as musical data rather than anonymous one-shot tones.
var player: AudioStreamPlayer
var stream: AudioStreamGenerator
var ambient_time := 0.0
var ambient_step := 0

const H := {
	"C3":130.81,"D3":146.83,"E3":164.81,"G3":196.00,"A3":220.00,
	"C4":261.63,"D4":293.66,"E4":329.63,"G4":392.00,"A4":440.00,
	"B4":493.88,"C5":523.25,"D5":587.33,"E5":659.25,"G5":783.99
}

func _ready() -> void:
	stream = AudioStreamGenerator.new()
	stream.mix_rate = 22050.0
	stream.buffer_length = 1.2
	player = AudioStreamPlayer.new()
	player.stream = stream
	add_child(player)
	player.play()

func cue(kind: String) -> void:
	match kind:
		"gather": _sequence(["E4","G4","C5"], 0.055, 0.10)
		"fish_cast": _sequence(["D4","A3"], 0.07, 0.07)
		"fish_bite": _sequence(["A4","C5","E5"], 0.075, 0.12)
		"fish_catch": _sequence(["E4","G4","B4","E5"], 0.06, 0.11)
		"fish_miss": _sequence(["D4","C4"], 0.11, 0.055)
		"echo": _sequence(["C4","G4","C5","E5","G5"], 0.13, 0.10)
		"craft": _sequence(["E4","G4","B4","E5"], 0.08, 0.10)
		"ui": _sequence(["A4"], 0.05, 0.06)
		"level": _sequence(["C5","E5","G5","C5"], 0.10, 0.12)
		"swing": _sequence(["G3","D4"], 0.055, 0.075)
		"hit": _sequence(["E3","E4"], 0.045, 0.10)
		"defeat": _sequence(["C4","G3","E3"], 0.09, 0.10)
		"gate_open": _sequence(["C3","G3","C4","E4","G4"], 0.18, 0.085)
		"home": _sequence(["C4","E4","G4","C5"], 0.12, 0.065)

func _sequence(notes: Array, note_length: float, volume: float) -> void:
	var playback := player.get_stream_playback() as AudioStreamGeneratorPlayback
	if playback == null:
		return
	for note in notes:
		var freq: float = float(H.get(String(note), 220.0))
		var frames := int(stream.mix_rate * note_length)
		for i in range(frames):
			if playback.get_frames_available() <= 0:
				return
			var t := float(i) / stream.mix_rate
			var envelope := 1.0 - float(i) / float(maxi(frames,1))
			var fundamental := sin(TAU * freq * t)
			var harmonic := sin(TAU * freq * 2.0 * t) * 0.23
			var upper := sin(TAU * freq * 3.0 * t) * 0.08
			var sample := (fundamental + harmonic + upper) * volume * envelope
			playback.push_frame(Vector2(sample, sample * 0.96))

func _process(delta: float) -> void:
	ambient_time += delta
	if ambient_time < 7.5:
		return
	ambient_time = 0.0
	ambient_step = (ambient_step + 1) % 4
	match ambient_step:
		0: _sequence(["C3","G3","E4"], 0.20, 0.018)
		1: _sequence(["A3","E4","C4"], 0.18, 0.015)
		2: _sequence(["G3","D4","B4"], 0.18, 0.016)
		3: _sequence(["C3","G3","C4"], 0.24, 0.014)
