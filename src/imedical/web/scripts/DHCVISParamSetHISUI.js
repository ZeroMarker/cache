var init = function(){
	var maxWidth=$(window).width()||1366;    //获取当前宽度
	var maxHeight=$(window).height()||550;   //获取当前高度
	$("#panelTop").panel("resize",{width:maxWidth-10})
	//debugger; 调试断点
	getMessage();
	function getMessage(){
		var Message=$.m({
			ClassName:"web.DHCVISParamSet",
			MethodName:"GetMessege"
		},function(txtData){
			var obj=$.parseJSON(txtData) 
			for(var i in obj){
				var t=$("#"+i)
				if(t.hasClass("textbox")){
					t.val(obj[i]); 
				}else{
					t.checkbox("setValue",obj[i]>0); 
				}

			}  

		})
	}
	//更新
	$("#Update").click(function(){
		var AreaRefresh=$("#AreaRefresh").val();
		var Waiting=$("#Waiting").val();
		var TwoWaiter=$("#TwoWaiter").val();
		var FtpServerIP=$("#FtpServerIP").val();
		var FtpUser=$("#FtpUser").val();  
		var FtpPassword=$("#FtpPassword").val();
		var FtpVoice=$("#FtpVoice").val();
	    var FtpLog=$("#FtpLog").val();
		var FtpVoiceHeader=$("#FtpVoiceHeader").val();
		var FtpVoiceMessage=$("#FtpVoiceMessage").val();
		var Version=$("#Version").val();      
		var UpdateAddress=$("#UpdateAddress").val();
		var BloodVisit=$("#BloodVisit").val();
		var BloodWait=$("#BloodWait").val();
		var VoiceRate=$("#VoiceRate").val();
		var VoiceCount=$("#VoiceCount").val();
		var VoiceSilence=$("#VoiceSilence").val();
		var MaxshowNum=$("#MaxshowNum").val();
		var ShowTime=$("#ShowTime").val();
		var BroadcastTime=$("#BroadcastTime").val();
		
		if($HUI.checkbox("#NoticePop").getValue()){
			  var NoticePop=1;
		}
		else{
			  var NoticePop=0;   
		}   
		if($HUI.checkbox("#NamePrivacy").getValue()){
			  var NamePrivacy=1;
		}
		else{
			  var NamePrivacy=0;   
		}   
		if($HUI.checkbox("#WaitPaitList").getValue()){
			  var WaitPaitList=1;
		}
		else{
			  var WaitPaitList=0;   
		}   
		if($HUI.checkbox("#Broadcast").getValue()){
			  var Broadcast=1;
		}
		else{
			  var Broadcast=0;   
		}   
	    
		$.m({
	    ClassName:"web.DHCVISParamSet",
	    MethodName:"MethodUpdate",
	    AreaRefresh:AreaRefresh,
		Waiting:Waiting,
		TwoWaiter:TwoWaiter,
		FtpServerIP:FtpServerIP,
		FtpUser:FtpUser,
		FtpPassword:FtpPassword,
		FtpVoice:FtpVoice,
	    FtpLog:FtpLog,
		FtpVoiceHeader:FtpVoiceHeader,
		FtpVoiceMessage:FtpVoiceMessage,
		Version:Version,     
		UpdateAddress:UpdateAddress,
		BloodVisit:BloodVisit,
		BloodWait:BloodWait,
		VoiceRate:VoiceRate,
		NoticePop:NoticePop,
		NamePrivacy:NamePrivacy,
		VoiceCount:VoiceCount,
		VoiceSilence:VoiceSilence,
		MaxshowNum:MaxshowNum,
		ShowTime:ShowTime,
		Broadcast:Broadcast,
		BroadcastTime:BroadcastTime,
		chkWaitPaitList:WaitPaitList
	    
         },function(txtData){
	        if(txtData==0){
		        $.messager.alert("提示信息","更新成功！");
		        getMessage();
		    }else{   
			     $.messager.alert("提示信息",txtData);   
			}     
	    
        });
		})
	
	


};
$(init);