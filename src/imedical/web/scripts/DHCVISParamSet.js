function BodyLoadHandler() {
	var obj=document.getElementById("BtnUpdate")
	if (obj) obj.onclick=UpdateHandler;
	var obj=document.getElementById("FtpPassword")
	if ((obj)&&(obj.value!="")) 
	obj.value="********";
}
function UpdateHandler()
{
	var obj=document.getElementById('AreaRefresh');
	var AreaRefresh=obj.value;
	if(AreaRefresh==" ") AreaRefresh=""
	
	var obj=document.getElementById('Waiting');
	var Waiting=obj.value;
	if(Waiting==" ") Waiting=""
	
	var obj=document.getElementById('TwoWaiter');
	var TwoWaiter=obj.value;
	if(TwoWaiter==" ") TwoWaiter=""

	var obj=document.getElementById('FtpServerIP');
	var FtpServerIP=obj.value;
	if(FtpServerIP==" ") FtpServerIP=""
	
	var obj=document.getElementById('FtpUser');
	var FtpUser=obj.value;
	if(FtpUser==" ") FtpUser=""

	var obj=document.getElementById('FtpPassword');
	var FtpPassword=obj.value;
	if(FtpPassword==" ") FtpPassword=""
	
	var obj=document.getElementById('FtpVoice');
	var FtpVoice=obj.value;
	if(FtpVoice==" ") FtpVoice=""
	
	var obj=document.getElementById('FtpLog');
	var FtpLog=obj.value;
	if(FtpLog==" ") FtpLog=""
	
	var obj=document.getElementById('FtpVoiceHeader');
	var FtpVoiceHeader=obj.value;
	if(FtpVoiceHeader==" ") FtpVoiceHeader=""

	var obj=document.getElementById('FtpVoiceMessage');
	var FtpVoiceMessage=obj.value;
	if(FtpVoiceMessage==" ") FtpVoiceMessage=""

	var obj=document.getElementById('Version');
	var Version=obj.value;
	if(Version==" ") Version=""

	var obj=document.getElementById('UpdateAddress');
	var UpdateAddress=obj.value;
	if(UpdateAddress==" ") UpdateAddress=""

	var obj=document.getElementById('BloodVisit');
	var BloodVisit=obj.value;
	if(BloodVisit==" ") BloodVisit=""
	
	var obj=document.getElementById('BloodWait');
	var BloodWait=obj.value;
	if(BloodWait==" ") BloodWait=""

	var obj=document.getElementById('VoiceRate');
	var VoiceRate=obj.value;
	if(VoiceRate==" ") VoiceRate=""
	
	var obj=document.getElementById('NoticePop');
	var NoticePop=obj.checked;
	if(NoticePop==" ") NoticePop=""
	
	var obj=document.getElementById('NamePrivacy');
	var NamePrivacy=obj.checked;
	if(NamePrivacy==" ") NamePrivacy=""

	var obj=document.getElementById('VoiceCount');
	var VoiceCount=obj.value;
	if(VoiceCount==" ") VoiceCount=""
	
	var obj=document.getElementById('VoiceSilence');
	var VoiceSilence=obj.value;
	if(VoiceSilence==" ") VoiceSilence=""
	
	var obj=document.getElementById('MaxshowNum');
	var MaxshowLine=obj.value;
	if(MaxshowLine==" ") MaxshowLine=""
	//ShowTime
	var obj=document.getElementById('ShowTime');
	var ShowTime=obj.value;
	if(ShowTime==" ") ShowTime=""
	
	var obj=document.getElementById('Broadcast');
	var Broadcast=obj.checked;
	if(Broadcast==" ") Broadcast=""
	
	var obj=document.getElementById('BroadcastTime');
	var BroadcastTime=obj.value;
	if(BroadcastTime==" ") BroadcastTime=""
	
	var obj=document.getElementById('chkWaitPaitList');
	var chkWaitPaitList=obj.checked;
	if(chkWaitPaitList==" ") chkWaitPaitList=""
	
	var obj=document.getElementById('MethodUpdate');
	if(obj)
	{
		var objUpdate=obj.value;
		//Bak var retStr=cspRunServerMethod(objUpdate,AreaRefresh,Waiting,TwoWaiter,FtpServerIP,FtpUser,FtpPassword,FtpVoice,FtpLog,FtpVoiceHeader,FtpVoiceMessage,Version,UpdateAddress,BloodVisit,BloodWait,VoiceRate,NoticePop,NamePrivacy,VoiceCount,VoiceSilence,MaxshowLine,ShowTime);
		var retStr=cspRunServerMethod(objUpdate,AreaRefresh,Waiting,TwoWaiter,FtpServerIP,FtpUser,FtpPassword,FtpVoice,FtpLog,FtpVoiceHeader,FtpVoiceMessage,Version,UpdateAddress,BloodVisit,BloodWait,VoiceRate,NoticePop,NamePrivacy,VoiceCount,VoiceSilence,MaxshowLine,ShowTime,Broadcast,BroadcastTime,chkWaitPaitList);
		if (retStr==0)
			alert("OK");
		else
			aler(retStr);
		BtnUpdate_click();
	}
	
}
window.document.body.onload=BodyLoadHandler;