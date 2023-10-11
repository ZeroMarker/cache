// 播放成功声音
function playSuccess() {	// IE放 背景音乐
	var snd_ie = document.getElementById('snd_ie');
	snd_ie.src = 'cssdmedia/success.mp3';
	snd_ie.play();
	// chrome
}
// 播放失败声音
function playWarn() {	// IE放 背景音乐
	var snd_ie = document.getElementById('snd_ie');
	snd_ie.src = 'cssdmedia/warn.mp3';
	snd_ie.play();
	// chrome
}
// 文字转语音目前仅支持chrome
function SpeakText(str) {
	var u = new SpeechSynthesisUtterance();
	u.text = str;
	speechSynthesis.speak(u);
}