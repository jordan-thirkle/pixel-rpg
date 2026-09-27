extends Node
class_name EverduneAudio

var player: AudioStreamPlayer
var stream: AudioStreamGenerator

func _ready() -> void:
	stream = AudioStreamGenerator.new()
	stream.mix_rate = 22050.0
	stream.buffer_length = 0.35
	player = AudioStreamPlayer.new()
	player.stream = stream
	add_child(player)
	player.play()

func cue(kind: String) -> void:
	match kind:
		"gather": _tone(440.0, 0.07, 0.12)
		"fish": _tone(620.0, 0.10, 0.12)
		"echo": _chord(392.0, 523.25, 0.24, 0.12)
		"craft": _chord(329.63, 493.88, 0.20, 0.12)
		"ui": _tone(740.0, 0.05, 0.08)
		"level": _chord(523.25, 783.99, 0.28, 0.13)

func _tone(freq: float, duration: float, volume: float) -> void:
	var playback := player.get_stream_playback() as AudioStreamGeneratorPlayback
	var frames := int(stream.mix_rate * duration)
	for i in range(frames):
		if playback.get_frames_available() <= 0:
			break
		var envelope := 1.0 - float(i) / float(maxi(frames,1))
		var sample := sin(TAU * freq * float(i) / stream.mix_rate) * volume * envelope
		playback.push_frame(Vector2(sample, sample))

func _chord(a: float, b: float, duration: float, volume: float) -> void:
	var playback := player.get_stream_playback() as AudioStreamGeneratorPlayback
	var frames := int(stream.mix_rate * duration)
	for i in range(frames):
		if playback.get_frames_available() <= 0:
			break
		var envelope := 1.0 - float(i) / float(maxi(frames,1))
		var t := float(i) / stream.mix_rate
		var sample := (sin(TAU * a * t) + sin(TAU * b * t)) * 0.5 * volume * envelope
		playback.push_frame(Vector2(sample, sample))
