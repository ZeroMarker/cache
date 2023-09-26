//页面Gui
function InitMessageWin(){
	
	var obj = new Object();	
	
	obj.HISReadMsg = function (aEpisodeID) {
		if (!DetailsId) return ;		
		//由基础平台需处理打开消息界面,处理该患者消息	
		var ret= tkMakeServerCall("DHCHAI.IO.FromHisSrv","ReadMsg","1011",DetailsId,Paadm,session['LOGON.USERID']);
		//由基础平台需处理打开消息界面,处理该患者该条消息
		//var ret= tkMakeServerCall("websys.DHCMessageInterface","ExecAll",DetailsId);
        //由基础平台需处理打开消息界面,打开界面即阅读对方消息
    	var retval  = $m({
			ClassName:"DHCHAI.IRS.CCMessageSrv",
			MethodName:"ReadMessage",
			aEpisodeID:aEpisodeID, 
			aUserID:$.LOGON.USERID, 
			aTypeCode:MsgType
		},false);
	
		if (parseInt(retval)>0){
			obj.MsgLoad(aEpisodeID); //刷新单个患者消息
			$.messager.popover({msg: '消息阅读成功！',type:'success',timeout: 1000});
		}else if(parseInt(retval)==0) {
			obj.MsgLoad(aEpisodeID);
		}else  {
			$.messager.popover({msg: '消息失败！',type:'error',timeout: 1000});
		}	
    }

	obj.MsgLoad = function(aEpisodeID){	
		var Msghtml="";
		obj.Msg = $cm({
			ClassName:'DHCHAI.IRS.CCMessageSrv',
			QueryName:'QryMsgByPaadm',
			aPaadm:aEpisodeID
		},false);
		
		if (obj.Msg.total>0) {
			$('#divMessage').empty();
		
			for (var i=0;i<obj.Msg.total;i++){
				var rd = obj.Msg.rows[i];	
				if ((rd.CSMsgType==1)||(rd.CSMsgType==3)) {
					Msghtml += ' <div id="patMsgType1" class="right_message">'
							+ ' 	<div class="MessTitle">'
							+ '     	<span>'+rd.MTitle+'</span>'
							+ '     </div>'
							+ '     <div class="MessDtl">'	
							+ '			<div>'+ ((rd.CSIsRead==0) ? '<div style="background-color:red;color:#fff;border-radius:10px;font-size:10px;padding:3px;width:25px;font-weight: 600;">未读</div>' :'')+'</div>'
							+ ' 		<div class="message">'
							+ '     	    <div class="left message-green">'
							+ '					<div class="message-arrow"></div>'				
							+ '     			<div class="message-inner">'+rd.CSMessage+'</div>'
							+ '     		</div>'
							+ '     	</div>'	
							+ ' 		<div style="display: inline-block;">'
							+ ' 			<div class="icon-doctor-green-pen" style="margin-top: 3px;width:25px;height:25px;border: 3px solid #16BBA2;border-radius: 15px;"></div>'
							+ '     	</div>'
							+ '     </div>'
							+ ' </div>'				
				}else {
					Msghtml += ' <div id="patMsgType2" class="left_message">'
							+ ' 	<div class="MessTitle">'
							+ '     	<span>'+rd.MTitle+'</span>'
							+ '     </div>'
							+ '     <div class="MessDtl">'
							+ ' 		<div style="display: inline-block;">'
							+ ' 			<div class="icon-person" style="margin-top: 3px;width:25px;height:25px;border: 3px solid #509DE1;border-radius: 15px;"></div>'									
							+ '     	</div>'
							+ ' 		<div class="message">'
							+ '     	    <div class="right message-blue">'
							+ '					<div class="message-arrow"></div>'				
							+ '     			<div class="message-inner">'+rd.CSMessage+'</div>'
							+ '     		</div>'
							+ '     	</div>'	
							+ ' 		<div>'+ ((rd.CSIsRead==0) ? '<div style="background-color:red;color:#fff;border-radius:10px;font-size:10px;padding:3px;width:25px;font-weight: 600;">未读</div>' :'')+'</div>'
							+ '     </div>'
							+ ' </div>'
				}
			}
		
			$('#divMessage').append(Msghtml);	
			return true;
		}			
	}
	
	InitMessageWinEvent(obj);	
	obj.LoadEvent(arguments);
	
	return obj;
}


