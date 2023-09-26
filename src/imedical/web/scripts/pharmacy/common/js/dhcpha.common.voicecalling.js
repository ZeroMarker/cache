/*!
 *@description:	语音叫号
 *@creator:		hulihua
 *@createdate:	2017-12-01
 *@others:
 */

//其他JS调用语音函数

document.write('<object classid="clsid:CCAD9244-00E5-4DB6-89A1-C0ECBE99FF69" id="JTTS_ActiveX1" style="display:none">');
document.write('<param name="_Version" value="65536">');
document.write('<param name="_ExtentX" value="2646">');
document.write('<param name="_ExtentY" value="1323">');
document.write('<param name="_StockProps" value="0">');
document.write('</object>');

function SendVocie(ReadStr){
	JTTS_ActiveX1.playMode ="1";
	JTTS_ActiveX1.VoiceName = "ZhaQian";
	JTTS_ActiveX1.Speed = "5";
	JTTS_ActiveX1.Pitch = "5";
	JTTS_ActiveX1.Volume = "5";
	nRet=0 //JTTS_ActiveX1.Play(ReadStr);
}