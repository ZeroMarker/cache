// ���ųɹ�����
function playSuccess() {	// IE�� ��������
	var snd_ie = document.getElementById('snd_ie');
	snd_ie.src = 'cssdmedia/success.mp3';
	snd_ie.play();
	// chrome
}
// ����ʧ������
function playWarn() {	// IE�� ��������
	var snd_ie = document.getElementById('snd_ie');
	snd_ie.src = 'cssdmedia/warn.mp3';
	snd_ie.play();
	// chrome
}
// ����ת����Ŀǰ��֧��chrome
function SpeakText(str) {
	var u = new SpeechSynthesisUtterance();
	u.text = str;
	speechSynthesis.speak(u);
}