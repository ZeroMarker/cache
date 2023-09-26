///把epr.frames.csp中的部分消息逻辑代码抽离出来
;(function(){
	var isIE=(!!window.ActiveXObject||"ActiveXObject"in window);
	var engineLoaded=false;
	var g_showMessage=window.g_showMessage||false;  //定义一个是否显示消息按钮js变量
	var messageLastCountData; //最近一次查询到的消息数量数据
	var messageCountSearchTimes=0; //消息调用查询次数 20190822
	
	var ACTION_CFG;
	var messageLastDate=0,messageLastTime=0;
	var EnableMsgAudio = window.EnableMsgAudio||false;   // 开启消息提示音
	var msgJObj = "", findDHCMessageBtnCount = 10;;	//信息按钮jquery对象
	var msgTimeoutQhanlder = "";
	var newMsgAudioObj = document.getElementById("newMsgAudio");
	var MsgSearchInterval=3;
	var sessionUserId='';
	window.LevelTypeFlag = "D,V,I,G"; 
	var AudioOnNewOrAlert=0;
	
	///点击消息按钮,显示消息内容
	var msgBtnClickHandler = function(isAuto){
		if ($('#MessageWin-Marquee').length>0 && $('#MessageWin-Marquee').is(":visible")) return; //跑马灯消息弹出框  
		if (ACTION_CFG) ACTION_CFG.popupTime=(new Date()).getTime();
		if( $('#MessageWin').is(":visible")) return false;
		if (!isAuto) {
			window.LevelTypeFlag = "D,V,I,G";
			ShowDHCMessageCount(); //isAuto是不是自动弹 自动弹就不再查一遍了
		}else{
			window.LevelTypeFlag = "D,V";
		}
		/*var xy = $("#DHCMessageBtn").offset();
		var width = 1200;
		var height = 650;
		var left = xy.left-width+150;
		if (left<0) left = 0; */
		//$("#MessageWin").window("move",{left:left,top:xy.top+50}).window("open");
		$("#MessageWin").window("open");  //中心打开
		return false;
	} 
	function HideExecMsgWin (){
		$("#ExecMessageWin").window("close");
	};
	var ShowExecMsgWin = function(DetailsId,OtherJson){
		var ExecMsgWinJObj = $("#ExecMessageWin");
		if( ExecMsgWinJObj.is(":visible")) return false;
		var maxWidth=$(window).width();
		var maxHeight=$(window).height();
		var realHeight=0,realWidth=0;
		var dialogWidth=OtherJson.dialogWidth,dialogHeight=OtherJson.dialogHeight;
		var msgWinOpts=$("#MessageWin").window('options');
		
		if (dialogWidth=="100%"&&dialogHeight=="100%"){  //都是100% 
			realWidth=maxWidth;
			realHeight=maxHeight;
		}else if(parseInt(dialogWidth)=="0"&&parseInt(dialogHeight)=="0"){  //都是0px 按消息界面大小处理
			realWidth=msgWinOpts.width;
			realHeight=msgWinOpts.height;
		}else{  //其他 %计算百分比 px直接使用   上下左右 至少20px
			if (dialogWidth.indexOf("%")>-1){
				realWidth= parseInt(maxWidth*parseInt(dialogWidth)/100);
			}else{
				realWidth=parseInt(dialogWidth);
			}
			realWidth= realWidth>100?realWidth:msgWinOpts.width;  
			realWidth=realWidth+40>maxWidth?maxWidth-40:realWidth;
			//realWidth=realWidth+"px";
			
			if (dialogHeight.indexOf("%")>-1){
				realHeight= parseInt(realHeight*parseInt(dialogHeight)/100);
			}else{
				realHeight=parseInt(dialogHeight);
			}
			realHeight= realHeight>50?realHeight:msgWinOpts.height;  
			realHeight=realHeight+40>maxHeight?maxHeight-40:realHeight;
			//realHeight=realHeight+"px";
		}
		if (typeof OtherJson["target"]=="string" && OtherJson["target"]=="_blank"){
			var x=(typeof window.screenX=="number")?window.screenX:window.screenLeft; 
			var y=(typeof window.screenY=="number")?window.screenY:window.screenTop; 
			var blankLeft=x+(maxWidth-realWidth)/2;
			var blankTop=x+(maxHeight-realHeight)/2;

			window.open(OtherJson["link"],'blankExecMsgWin','width='+realWidth+',height='+realHeight+',left='+blankLeft+',top='+blankTop);
		}else{
			ExecMsgWinJObj.window("open");
 			ExecMsgWinJObj.window('resize',{width:realWidth,height:realHeight}).window('center');
			
			document.getElementById("dhcmessageexec").src = OtherJson["link"]; 
		}				

		return false;			
	}
	// 第一次登录与消息有变化时调用。  
	// 请求query,刷新消息数量
	var ForceShowDHCMessageCount = function(isNewMsg,forceQuery){
		$.ajaxRunServerMethod({ 
				ClassName:"websys.DHCMessageDetailsMgr",MethodName:"GetNotReadMsgCount",UserId:sessionUserId
				,ForceQuery:forceQuery?"1":"0"
				,LastMaxId:messageLastCountData?(messageLastCountData['MaxId']||''):''
				,LastMaxReplyId:messageLastCountData?(messageLastCountData['MaxReplyId']||''):''
			},function(rtn){
				if ("string" == typeof rtn ){ rtn = $.parseJSON(rtn);}
				if (rtn && rtn.Count>0){
		            if (isNewMsg  && EnableMsgAudio) {
			            //playBeepAudio2();
						//playTipAudio(rtn,true);
					}
					msgJObj.removeClass("nullMessage").addClass("hasMessage");
					if (rtn.Count>99){
						$("#DHCMessageBtn .messagecount").html("99+");
					}else{
						$("#DHCMessageBtn .messagecount").html(rtn.Count);
					}
					var isAlert=false;
					if (JudgeMsgNeedPopup(rtn) && (typeof rtn.AutoAlert=="undefined"||rtn.AutoAlert=="true")){
						//window.LevelTypeFlag = "D,V"  ; //{"D":true,"V":true};
						//if(!$('#MessageWin').is(":visible")) msgBtnClickHandler(true); //msgBtnClickHandler内部判断了是否已显示
						 msgBtnClickHandler(true); 
						//window.open("dhc.message.csp?LevelType=D","ImmedMessageWindow");
						isAlert=true;
					}else{
						//window.LevelTypeFlag = "D,V,I,G";  //设置重要性参数 改为在按钮事件那里
					}
					
					if(EnableMsgAudio && (isAlert||rtn.NCount>0||AudioOnNewOrAlert!='1')) {
						playTipAudio(rtn,true);
					}

					if (typeof rtn.MQCount!='undefined' && messageLastDate!=rtn.createDate && messageLastTime!= rtn.createTime){
						if (typeof reloadDHCMessageMarquee=='function'){
							reloadDHCMessageMarquee({sessionUserId:sessionUserId,searchInterval:0,mqCount:rtn.MQCount});
						}
					}

				}else if(rtn && rtn.Count==0){
					$("#DHCMessageBtn .messagecount").html(rtn.Count);
					msgJObj.removeClass("hasMessage").addClass("nullMessage");
				}
				if (rtn){
					messageLastDate = rtn.createDate;
					messageLastTime = rtn.createTime;
					messageLastCountData=rtn; //将查到的数据保存
				}
				if (typeof rtn=="object" && typeof childFrameOnMsgCount=="function"){ //允许公卫系统定义个函数，在每次轮询到消息数量调用
					childFrameOnMsgCount(rtn);	
				}
			})
	}
	
	var MsgActionTypeConfigLoaded=false;
	//显示消息数量
	var ShowDHCMessageCount = function(){
		if (!engineLoaded) {
			loadEngine(ShowDHCMessageCount);
			return;
		}
		
		if (findDHCMessageBtnCount<0) return ;
		clearTimeout(msgTimeoutQhanlder);
		msgJObj = $("#DHCMessageBtn");
		if (msgJObj.length>0 || window.g_showMessage) {
			//第一次查询加载 消息动作类型配置
			if (messageCountSearchTimes==0 && !MsgActionTypeConfigLoaded) {
				LoadMsgActionTypeConfig(ShowDHCMessageCount);
				return;
			}
			
			
			ForceShowDHCMessageCount(true,messageCountSearchTimes==0);
			messageCountSearchTimes++;
			msgTimeoutQhanlder = setTimeout(ShowDHCMessageCount,MsgSearchInterval*60*1000);
		}else{
			//没有找到元素,可能是ext没有render完成,所以得去再去查询,考虑可能是easyui的头菜单
			msgTimeoutQhanlder = setTimeout(ShowDHCMessageCount,1000);
			findDHCMessageBtnCount--;
		}
	}
	//data 后台拿到的数量
	var JudgeMsgNeedPopup=function(data){
		if (data.NDCount>0) return true;
		if (data.DCount>0 ){
			if (typeof data.CountList=="object" && ACTION_CFG) {
				var now=(new Date()).getTime(),flag=false;
				$.each(data.CountList,function(i,item){
					if (ACTION_CFG && ACTION_CFG[item.ID]){
						//紧急消息的未处理与新回复 非常重要消息的未处理且未读
						if ((ACTION_CFG[item.ID].LevelType=="D" && (item.UE+item.RPY>0)) || (ACTION_CFG[item.ID].LevelType=="V" && (item.UEUR>0))) {
							if (ACTION_CFG[item.ID].interval+ACTION_CFG.popupTime<=now){
								flag=true;
								return false;
							}
						}
					}
				})
				return flag;
			}else{
				return true;
			}
		}else{
			return false;	
		}
	}
	var LoadMsgActionTypeConfig=function(callback){
		$.ajaxRunServerMethod({ 
				ClassName:"websys.DHCMessageActionTypeMgr",MethodName:"OutActionTypeConfig",LevelType:'D,V,I,G'
			},function(rtn){
				rtn=$.parseJSON(rtn);
				var now=(new Date()).getTime();
				ACTION_CFG={};
				ACTION_CFG.popupTime=now;
				$.each(rtn,function(i,item){
					var interval=parseInt((parseFloat(item.PopupInterval)||5)*60*1000);
					item.interval=interval;
					item.AudioName=item.AudioName||'newmsg.wav';
					ACTION_CFG[item.ID]=item;
				})
				
				MsgActionTypeConfigLoaded=true;
				if (typeof callback=="function") callback();
			}
		)
	}
	
	var loadEngine=function(callback){
		$.ajaxRunServerMethod({ClassName:'websys.DHCMessageDetailsMgr',MethodName:'LoadMsgEngineCfg'},function(cfg){
			cfg=$.parseJSON(cfg);
			if (cfg.success=="1"){
				AudioOnNewOrAlert=cfg.AudioOnNewOrAlert||0;
				MsgSearchInterval=parseFloat(cfg.MsgSearchInterval)||3;
				EnableMsgAudio=cfg.EnableMsgAudio=="1";
				sessionUserId=cfg.UserId
				if ($('#MessageWin').length==0) {
					var $msgListWin=$('<div id="MessageWin" style="padding:0px;overflow:hidden;"></div>').appendTo('body');
					$msgListWin.window({
						title:'消息列表',iconCls:"icon-w-msg",
						isTopZindex:true,modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,width:1230,height:600,closable:true,
						content:"<iframe src=\"dhc.message.csp\" scrolling=no frameborder=0 style=\"width:100%;height:100%;\"></iframe>"
					});
				}
				if ($('#ExecMessageWin').length==0) {
					var $msgExecWin=$('<div id="ExecMessageWin" class="hisui-dialog" title="须处理" style="padding:0px;overflow:hidden;" ></div>').appendTo('body');
					$msgExecWin.dialog({
						title:'须处理',iconCls:"icon-w-list",
						modal:true,closed:true,collapsible:false,width:1100,height:500,closable:true,minimizable:false,maximizable:false,draggable:false,resizable:false,
						content:"<iframe name=\"dhcmessageexec\" id=\"dhcmessageexec\" scrolling=\"auto\" frameborder=0 style=\"width:100%;height:100%;\"></iframe>"
					});
				}
				
				if ($('#newMsgAudio').length==0) {
					$('<audio id="newMsgAudio" preload="preload"></audio>').appendTo('body');
					newMsgAudioObj=$('#newMsgAudio')[0];
					try {
						newMsgAudioObj.addEventListener("canplaythrough", function () {
				           	newMsgAudioObj.play();
				        }, false);
				        newMsgAudioObj.addEventListener("ended",function(){
				        	playTipAudio();
				        },false);
				        newMsgAudioObj.addEventListener("error",function(){
				        	playTipAudio();
				        },false);
					}catch(e){}

				}
				
				engineLoaded=true;
				if (typeof initDHCMessageMarquee=='function'){
					initDHCMessageMarquee({sessionUserId:sessionUserId,searchInterval:0,mqCount:0,dir:'horizontal'});
				}
				if (typeof callback=="function") callback();
			}else{
				
			}
		});
	}
	var audioQueueArray,audioQueueIndex=-1;
	function playTipAudio(data,isNewQueue){
		if (EnableMsgAudio){
			if (isNewQueue){
				var arr=[];
				if (data.CountList && ACTION_CFG){
					$.each(data.CountList,function(ind,item){
						if (ACTION_CFG[item.ID] && typeof ACTION_CFG[item.ID].AudioName=="string"){
							var AudioName=ACTION_CFG[item.ID].AudioName;
							if (isIE && AudioName.indexOf('.wav')>-1) AudioName=AudioName.replace('.wav','.mp3');
							if (AudioName!="NULL" && arr.indexOf(AudioName)==-1) arr.push(AudioName);
						}
					})
				}else{
					arr.push(isIE?'newmsg.mp3':'newmsg.wav');
				}
				audioQueueArray=arr;
				audioQueueIndex=-1;
			}
			
			try{
				audioQueueIndex++;
				if (audioQueueIndex>=0 && audioQueueArray && audioQueueArray[audioQueueIndex]){
			        newMsgAudioObj.src = "../audio/"+audioQueueArray[audioQueueIndex];
			        newMsgAudioObj.loop=false;
			        newMsgAudioObj.load();
				}
			}catch(e){}
		}
	}
	function playBeepAudio2(){
		try{
			websys_exec('"C:\\imedical\\beepexe.exe"');
		}catch(e){
			alert(e.message);	
		}
	}
	window.msgBtnClickHandler=msgBtnClickHandler;
	window.HideExecMsgWin=HideExecMsgWin;
	window.ShowExecMsgWin=ShowExecMsgWin;
	window.ShowDHCMessageCount=ShowDHCMessageCount;
})();

