//页面Event
function InitMessageWinEvent(obj){	

	obj.LoadEvent = function(arguments){
		
		//加载消息
		if (!DetailsId) {
			obj.MsgLoad(EpisodeDr);
		}else {
			$('#btnClose').hide();
			obj.HISReadMsg(EpisodeDr);
		}
		//阅读消息
		$('#btnRead').on('click', function(){
			obj.btnRead_click(EpisodeDr);
		});
		 //发送消息
		$('#btnSend').on('click', function(){
	     	obj.btnSend_click(EpisodeDr);
     	});
		//发送消息更多
		$('#btnMSend').on('click', function(){
	     	obj.btnMSend_click(EpisodeDr);
     	});
		
		//关闭
		$('#btnClose').on('click', function(){
	        websys_showModal('close');
		});

	}
    //阅读消息
	obj.btnRead_click = function (EpisodeID) {
		// MsgType 1院感、2临床

		var retval  = $m({
			ClassName:"DHCHAI.IRS.CCMessageSrv",
			MethodName:"ReadMessage",
			aEpisodeID:EpisodeID, 
			aUserID:$.LOGON.USERID, 
			aTypeCode:MsgType
		},false);
	
		if (parseInt(retval)>0){
			obj.MsgLoad(EpisodeID); //刷新单个患者消息
			$.messager.popover({msg: '消息阅读成功！',type:'success',timeout: 2000});
		}else if(parseInt(retval)==0) {
			$.messager.popover({msg: '无未读消息需阅读！',type:'info',timeout: 2000});
		}else  {
			$.messager.popover({msg: '消息失败！',type:'error',timeout: 2000});
		}	
	}
	
	//发送消息
	obj.btnSend_click = function (EpisodeID) {
		// MsgType 1院感、2临床
		var MsgTxt= $('#txtMessage').val().replace(/\^/g,"").replace(/\r?\n/g,"<br />");
		var retval = obj.Msg_Save("",EpisodeID,MsgType,MsgTxt,"0");	
		if (parseInt(retval)>0){
			obj.MsgLoad(EpisodeID); //刷新单个患者消息
			$('#txtMessage').val('');
			$.messager.popover({msg: '消息发送成功！',type:'success',timeout: 2000});
		} else if(retval!="-1"){
			$.messager.alert("提示", "消息发送失败！", "info");
		}
	}
	
	//发送消息更多
	obj.btnMSend_click = function (EpisodeID) {
		// MsgType 1院感、2临床	
		obj.MMsg = $cm({
				ClassName:'DHCHAI.BTS.DictionarySrv',
				QueryName:'QryDic',
				aTypeCode:"CCScreenMessage",
				aActive:1
		},false);
		
		var htmlMMsg='<div id="ulqMsg" style="text-align:right;">';
		for (var j=0;j<obj.MMsg.total;j++){
			var rd = obj.MMsg.rows[j];	
			var message=rd["DicDesc"];
			htmlMMsg += '<li style="list-style:none;" text="'+message+'"><a href="#" style="color:blue">'+message+'</a></li>';
		}
		htmlMMsg +='</div>';
		$('#btnMSend').popover({
			width:'300px',
			height:'200px',
			content:htmlMMsg,
			trigger:'hover',
			placement:'left',
			type:'html'
		});
		$('#btnMSend').popover('show');  

		$('#ulqMsg').delegate("li","click",function(e) {
			e.preventDefault();
			var MsgTxt = $(this).attr("text");
			var retval = obj.Msg_Save("",EpisodeID,MsgType,MsgTxt,"0");
			if (parseInt(retval)>0){					
				obj.MsgLoad(EpisodeID); //刷新单个患者消息
				$('#txtMessage').val('');
				$.messager.popover({msg: '消息发送成功！',type:'success',timeout: 2000});
			} else if(retval!="-1"){
				$.messager.alert("提示", "消息发送失败！", "info");
			}
			$('#btnMSend').popover('hide');
			$('#btnMSend').popover('destroy');  
		});
	}	
	
	//保存消息
	obj.Msg_Save=function(ID,EpisodeID,MsgType,MsgTxt,IsRead){	
		var CSEpisodeDr = EpisodeID;
		var CSMsgType   = MsgType;  // 1院感、2临床
		var CSMsgDate   = "";
		var CSMsgTime   = "";  //时间
		var CSMsgUserDr = $.LOGON.USERID;
		var CSMsgLocDr  = $.LOGON.LOCID;  
		var CSMessage   = MsgTxt;
		var CSIsRead    = IsRead;
		var CSReadDate  = "";
		var CSReadTime  = "";
		var CSReadUserDr = $.LOGON.USERID;		
		
		if (CSMessage == '') {
			$.messager.alert("提示", "消息内容不允许为空！", "info");
			return -1;
		}
		
		var InputStr = ID;
		InputStr += "^" + CSEpisodeDr;
		InputStr += "^" + CSMsgType;
		InputStr += "^" + CSMsgDate;
		InputStr += "^" + CSMsgTime;
		InputStr += "^" + CSMsgUserDr;
		InputStr += "^" + CSMsgLocDr;
		InputStr += "^" + CSMessage;
		InputStr += "^" + CSIsRead;
		InputStr += "^" + CSReadDate;
		InputStr += "^" + CSReadTime;
		InputStr += "^" + CSReadUserDr;
	
		var retval  = $m({
			ClassName:"DHCHAI.IR.CCMessage",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:'^'
		},false);
		return retval;
	};
 
}