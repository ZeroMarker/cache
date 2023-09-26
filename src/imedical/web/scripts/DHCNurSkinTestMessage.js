//DHCNurSkinTestMessage.js

//右下角弹出消息
document.write('<style type="text/css">')
document.write('#winpop { width:200px; height:0px; background:#c9d3f3; position:absolute; right:0; bottom:0; border:1px solid #666; margin:0; padding:1px; overflow:hidden; display:none;}')
document.write('#winpop .title { width:100%; height:22px; line-height:20px; background:#FFCC00; font-weight:bold; text-align:center; font-size:12px;}')
document.write('#winpop .con { width:100%; height:90px; line-height:80px; font-weight:bold; font-size:12px; color:#FF0000; text-decoration:none; text-align:center}')
document.write('.close { position:absolute; right:4px; top:-1px; color:#FFF; cursor:pointer}')
document.write('</style>')
document.write('<div id="winpop">')
document.write('	<div class="title"><SPAN ID="blink" STYLE="color: #FFFFFF; behavior: url(#default#time2)" begin="0;blink.end+1" dur="1" timeaction="style">皮试观察时间到时病人</SPAN><span class="close" onclick="tips_pop()">X</span></div>')
document.write('	<div id="winpopmessage" class="con">1条未读信息(</div>')
document.write('</div>')

//消息声音提示
try
{
   var voice = new ActiveXObject("SAPI.SpVoice");
}
catch(oException){}
var IntervalTime=120000; //两分钟	//1000=1秒
//定时点刷新按钮
setTimeout(SkinTestMessageFn,IntervalTime);
SkinTestMessageFn();	//进入界面先刷新一下
function SkinTestMessageFn(){
	//var retStr=tkMakeServerCall("web.DHCMessage","GetNewMessage",paramStr);
	var SkinTestMessage=document.getElementById("SkinTestMessage");
	if (SkinTestMessage) {
		var TestLocDr=session['LOGON.CTLOCID'];
		var retStr=cspRunServerMethod(SkinTestMessage.value,TestLocDr);	
		//alert("TestLocDr="+TestLocDr+" retStr="+retStr)
		if (retStr!="") {
			SpeakIt(retStr);
			ShowPopMessage(retStr);
			/*//多次呼叫
			var tmpRetStr=retStr.split("^");
			for (var i=0;i<(tmpRetStr.length-1);i++){
				SpeakIt(tmpRetStr[i]);
				ShowPopMessage(tmpRetStr[i]);
			}
			*/			
		}
		//重设计时
		setTimeout(SkinTestMessageFn,IntervalTime);
	}
}
function SpeakIt(MessageText)
{
	try
	{
		if(voice)
		{
			// set voice to LH Michelle
			//voice.Voice = voice.GetVoices()(1);
			//voice.Rate   = 2;      // pretty fast
			//voice.Volume = 100;    // pretty loud
			//voice.Speak(MessageText, 1);
			voice.Speak("C:\\WINDOWS\\Media\\ringin.wav",15);
		}
	}
	catch(oException)
	{
	  	//alert(oException.message);
	}
}



function tips_pop(){
	var MsgPop=document.getElementById("winpop");
	var popH=parseInt(MsgPop.style.height);//将对象的高度转化为数字
	if (popH==0){
		MsgPop.style.display="block";//显示隐藏的窗口
		show=setInterval("changeH('up')",2);
	}
	else {
		hide=setInterval("changeH('down')",2);
	}
}
function changeH(str) {
	var MsgPop=document.getElementById("winpop");
	var popH=parseInt(MsgPop.style.height);
	if(str=="up"){
		if (popH<=100){
			MsgPop.style.height=(popH+4).toString()+"px";
		}
		else{  
			clearInterval(show);
		}
	}
	if(str=="down"){ 
		if (popH>=4){  
			MsgPop.style.height=(popH-4).toString()+"px";
		}
		else{ 
			clearInterval(hide);   
			MsgPop.style.display="none";  //隐藏DIV
		}
	}
}
function ShowPopMessage(Message) {
	document.getElementById('winpop').style.height='0px';
	var MessageStr="<table style='COLOR:#ff0000; FONT-SIZE:15px; FONT-WEIGHT:bold;'>"
	var tmpRetStr=Message.split("^");
	for (var i=0;i<(tmpRetStr.length-1);i++){
		if (tmpRetStr[i]=="") continue;
		var MessageStr=MessageStr+"<tr><td>"+tmpRetStr[i]+"</td></tr>";
	}
	var MessageStr=MessageStr+"</table>";
	document.getElementById('winpopmessage').innerHTML=MessageStr;
	tips_pop();
	//setTimeout("tips_pop()",1000);//3秒后调用tips_pop()这个函数
}

