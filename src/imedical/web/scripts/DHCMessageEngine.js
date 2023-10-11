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
	
	
	var MsgShowByCatgory='';  ///按类型显示消息
	window.MsgListCatgory='' //记录当前要打开的消息列表的大类 ;
	var noticeMsgJObj=''; //通知类消息按钮
	
	var ReplyIsGeneral='';  //新回复消息不弹出
	
	var msgTitleMap={'':'消息列表','B':'业务消息列表','N':'通知消息列表'};
	
	var getTokenUrl=function(url){
		
		if(typeof url=='string' && url.indexOf('.csp')>-1) {
			var token='';
			if(typeof websys_getMWToken=='function' ){
				token= websys_getMWToken();
			}
			
			var arr=url.split('#');
			arr[0]=arr[0]+(arr[0].indexOf('?')>-1?'&':'?')+'MWToken='+token; 
			url=arr.join('#');
		}
		return url;
	}
	
	///点击消息按钮,显示消息内容
	var msgBtnClickHandler = function(isAuto,catgory,popReason){
		if ($('#MessageWin-Marquee').length>0 && $('#MessageWin-Marquee').is(":visible")) return; //跑马灯消息弹出框  

		catgory=catgory||'';
		if (MsgShowByCatgory=='Y') {
			if (!catgory) catgory='B';   //当按消息类型显示消息时  如果catgory传的空 当作B 业务类消息
		}


		if (ACTION_CFG) {
			var now=(new Date()).getTime();
			ACTION_CFG.popupTime=now;
			
			if(!ACTION_CFG.popupTimeMap) ACTION_CFG.popupTimeMap={};
			ACTION_CFG.popupTimeMap[catgory]=now;  //按大类记录

		}
		
		if( $('#MessageWin').is(":visible")) return false;
		
		var title=msgTitleMap[catgory];
		window.MsgListCatgory=catgory;
		
		
		if (!isAuto) {
			window.LevelTypeFlag = "D,V,I,G";
			ShowDHCMessageCount(); //isAuto是不是自动弹 自动弹就不再查一遍了
		}else{
			if (popReason && popReason=='sss') {
				window.LevelTypeFlag = "D,V,I,G"; //霸屏消息弹框
			}else{
				window.LevelTypeFlag = "D,V";
			}
			
		}
		/*var xy = $("#DHCMessageBtn").offset();
		var width = 1200;
		var height = 650;
		var left = xy.left-width+150;
		if (left<0) left = 0; */
		//$("#MessageWin").window("move",{left:left,top:xy.top+50}).window("open");
		$("#MessageWin").window("open").window('setTitle',title);  //中心打开
		return false;
	} 
	function HideExecMsgWin (){
		$("#ExecMessageWin").window("close");
	};
	var ShowExecMsgWin = function(DetailsId,OtherJson){
		var dialogTitle=OtherJson.dialogTitle||'须处理';
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
				realHeight= parseInt(maxHeight*parseInt(dialogHeight)/100);
			}else{
				realHeight=parseInt(dialogHeight);
			}
			realHeight= realHeight>50?realHeight:msgWinOpts.height;  
			realHeight=realHeight+40>maxHeight?maxHeight-40:realHeight;
			//realHeight=realHeight+"px";
		}
		if (OtherJson['clientPath']){
			if (typeof websys_exec=='function') {
				websys_exec( '"'+OtherJson['clientPath']+'" "'+OtherJson["link"]+'"'  );
			}
		}else if (typeof OtherJson["target"]=="string" && OtherJson["target"]=="_blank"){
			var x=(typeof window.screenX=="number")?window.screenX:window.screenLeft; 
			var y=(typeof window.screenY=="number")?window.screenY:window.screenTop; 
			var blankLeft=x+(maxWidth-realWidth)/2;
			var blankTop=x+(maxHeight-realHeight)/2;
			
			
			if(typeof cefbound == 'object') { //医为浏览器
				blankLeft-=10;
				blankTop-=31;
				realWidth-=6;
				realHeight-=113;
			}
			
			OtherJson["link"]=getTokenUrl(OtherJson["link"]);
			
			window.open(OtherJson["link"],'blankExecMsgWin','width='+realWidth+',height='+realHeight+',left='+blankLeft+',top='+blankTop);
		}else{
			ExecMsgWinJObj.window("open");
 			ExecMsgWinJObj.window('resize',{width:realWidth,height:realHeight}).window('center').window('setTitle',dialogTitle);
			
			OtherJson["link"]=getTokenUrl(OtherJson["link"]);
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
				if ("string" == typeof rtn ){ 
					if (rtn.toLowerCase().indexOf("logon")>-1 || rtn.toLowerCase().indexOf("login")>-1){
						var MWToken = "";
						if ('function'==typeof websys_getMWToken) MWToken = websys_getMWToken();
						if (MWToken){  /// 超时后自动锁屏
							if ('undefined'!==typeof lockScreenOpt && 'function'==typeof lockScreenOpt.lockScrn) lockScreenOpt.lockScrn();
						}else{
							$.messager.alert("提示","系统已超时,请关闭界面,重新登录!");
						}
						return "";
					}
					rtn = $.parseJSON(rtn);
				}
				if (rtn && rtn.Count>0){
		            if (isNewMsg  && EnableMsgAudio) {
			            //playBeepAudio2();
						//playTipAudio(rtn,true);
					}
					
					var Count=parseInt(rtn.Count)||0;  //消息总量
					var CountNotice=parseInt(rtn.CountNotice)||0;  //通知类消息数量
					var CountBusiness=Count-CountNotice; //业务类消息数量
					
					setMsgCountHtml(CountBusiness,CountNotice);

					var isAlert=false;
					if(MsgShowByCatgory=='Y') {  //区分类型
						if (judgeAndPopup(rtn,'N')) {  //通知类型 判断并弹窗
							isAlert=true;
						}else if (judgeAndPopup(rtn,'B')){ //业务类型 判断并弹窗
							isAlert=true;
						}
						
					}else{ //不区分类型
						if (judgeAndPopup(rtn,'')) {
							isAlert=true;
						}
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
					setMsgCountHtml(0,0);

				}
				if (rtn){
					messageLastDate = rtn.createDate;
					messageLastTime = rtn.createTime;
					messageLastCountData=rtn; //将查到的数据保存
					
					var SSSCount=parseInt(rtn.SSSCount)||0;  //消息总量
					var SSSCountNotice=parseInt(rtn.SSSCountNotice)||0;  //通知类消息数量
					var SSSCountBusiness=SSSCount-SSSCountNotice; //业务类消息数量
					
					setMsgListStatus(SSSCountBusiness,SSSCountNotice);
					
				}
				if (typeof rtn=="object" && typeof childFrameOnMsgCount=="function"){ //允许公卫系统定义个函数，在每次轮询到消息数量调用
					childFrameOnMsgCount(rtn);	
				}
				messageCountSearchTimes++;
				msgTimeoutQhanlder = setTimeout(ShowDHCMessageCount,MsgSearchInterval*60*1000);
			})
	}
	
	
	///判定是否需要弹窗 需要则弹窗  如果弹窗返回true
	var judgeAndPopup=function(rtn,catgory){
		var needPop=false,popReason='';
		if (typeof rtn.AutoAlert=="undefined"||rtn.AutoAlert=="true"){
			var judge=JudgeMsgNeedPopup(rtn,catgory);
			if (judge===true) {
				needPop=true,popReason='';
			}else if(typeof judge=='object' && judge.flag===true){
				needPop=true,popReason=judge.reason;
			}
			if (needPop) {
				msgBtnClickHandler(true,catgory,popReason); 
			}
		}
		return needPop;
	}
	
	
	var setMsgListStatus=function(SSSCountBusiness,SSSCountNotice){
		
		var cat=window.MsgListCatgory;
		var sCount=(cat=='N'?SSSCountNotice:SSSCountBusiness);
		var listTitle=msgTitleMap[cat];
		if (sCount>0){
			$('#MessageWin').window('window').find('>.panel-header>.panel-tool>.panel-tool-close').hide();
			$('#MessageWin').window('setTitle',listTitle+'（您需要先处理前'+sCount+'条消息才能关闭窗口）');
			
			if(typeof HISUIStyleCode=='string' && HISUIStyleCode=='lite'){ //极简 title改为红色字体
				$('#MessageWin').window('window').find('>.panel-header>.panel-title').css('color','red');
			}else if (!$.hisui){  //easyui版本 改为红色字体
				$('#MessageWin').window('window').find('>.panel-header>.panel-title').css('color','red');
			}else{  //炫彩改为红色背景
				$('#MessageWin').window('window').find('>.panel-header').css({backgroundColor:'red',borderColor:'red'});
				
			}
		}else{
			$('#MessageWin').window('window').find('>.panel-header>.panel-tool>.panel-tool-close').show();
			$('#MessageWin').window('setTitle',listTitle);
			if(typeof HISUIStyleCode=='string' && HISUIStyleCode=='lite'){ //极简 title改为黑色字体
				$('#MessageWin').window('window').find('>.panel-header>.panel-title').css('color','#000');
			}else if (!$.hisui){  //easyui版本 改为原色
				$('#MessageWin').window('window').find('>.panel-header>.panel-title').css('color','#0E2D5F');
			}else{  //炫彩改为#556983背景
				$('#MessageWin').window('window').find('>.panel-header').css({backgroundColor:'#556983',borderColor:'#556983'});

			}
		}
		
	}
	
	var setMsgCountHtml=function(CountBusiness,CountNotice){
		if(CountBusiness>0) {
			msgJObj.removeClass("nullMessage").addClass("hasMessage");
			if (CountBusiness>99){
				msgJObj.find('.messagecount').html("99+");
			}else{
				msgJObj.find('.messagecount').html(CountBusiness);
			}
			
		}else{
			msgJObj.find('.messagecount').html(CountBusiness);
			msgJObj.removeClass("hasMessage").addClass("nullMessage");
					
		}
		
		if (noticeMsgJObj && noticeMsgJObj.length>0) {
			
			if(CountNotice>0) {
				noticeMsgJObj.removeClass("nullMessage").addClass("hasMessage");
				if (CountNotice>99){
					noticeMsgJObj.find('.messagecount').html("99+");
				}else{
					noticeMsgJObj.find('.messagecount').html(CountNotice);
				}
				
			}else{
				
				noticeMsgJObj.find('.messagecount').html(CountNotice);
				noticeMsgJObj.removeClass("hasMessage").addClass("nullMessage");
				
			}
		}
		
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
		noticeMsgJObj=$("#DHCMessageBtnNotice");
		if (msgJObj.length>0 || window.g_showMessage) {
			//第一次查询加载 消息动作类型配置
			if (messageCountSearchTimes==0 && !MsgActionTypeConfigLoaded) {
				LoadMsgActionTypeConfig(ShowDHCMessageCount);
				return;
			}
			ForceShowDHCMessageCount(true,messageCountSearchTimes==0);
		}else{
			//没有找到元素,可能是ext没有render完成,所以得去再去查询,考虑可能是easyui的头菜单
			msgTimeoutQhanlder = setTimeout(ShowDHCMessageCount,1000);
			findDHCMessageBtnCount--;
		}
	}
	//data 后台拿到的数量
	var JudgeMsgNeedPopup=function(data,catgory){
		catgory=catgory||'';

		var DCount=parseInt(data.DCount)||0,
			NDCount=parseInt(data.NDCount)||0,
			DCountNotice=parseInt(data.DCountNotice)||0,
			NDCountNotice=parseInt(data.NDCountNotice)||0,
			DCountBusiness=DCount-DCountNotice,
			NDCountBusiness=NDCount-NDCountNotice;
		var SSSCount=parseInt(data.SSSCount)||0,
			SSSCountNotice=parseInt(data.SSSCountNotice)||0,
			SSSCountBusiness=SSSCount-SSSCountNotice;
			
		var jDCount=catgory=='N'?DCountNotice:(catgory=='B'?DCountBusiness:DCount);
		var jNDCount=catgory=='N'?NDCountNotice:(catgory=='B'?NDCountBusiness:NDCount);
		var jSSSCount=catgory=='N'?SSSCountNotice:(catgory=='B'?SSSCountBusiness:SSSCount);
		
		if (jSSSCount>0) return {flag:true,reason:'sss',catgory:catgory};

		if (jNDCount>0) return {flag:true,reason:'new',catgory:catgory};
		if (jDCount>0 ){
			if (typeof data.CountList=="object" && ACTION_CFG) {

				var lastPopupTime=0;
				if (ACTION_CFG && ACTION_CFG.popupTimeMap && ACTION_CFG.popupTimeMap[catgory]) {
					lastPopupTime=ACTION_CFG.popupTimeMap[catgory];
				}else if(ACTION_CFG){
					lastPopupTime=ACTION_CFG.popupTime;
				}
				var now=(new Date()).getTime(),flag=false;
	

				$.each(data.CountList,function(i,item){
					if (ACTION_CFG && ACTION_CFG[item.ID] && (catgory=='' || catgory==ACTION_CFG[item.ID].Catgory) ){

						//紧急消息的未处理与新回复(增加判断配置项 ReplyIsGeneral 新回复消息是否当作紧急消息弹窗提醒 20230110 ) 非常重要消息的未处理且未读
						if ((ACTION_CFG[item.ID].LevelType=="D" && (item.UE+(ReplyIsGeneral=='Y'?0:item.RPY)>0)) || (ACTION_CFG[item.ID].LevelType=="V" && (item.UEUR>0))) {
							if (ACTION_CFG[item.ID].interval+lastPopupTime<=now){
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
				sessionUserId=cfg.UserId;
				MsgShowByCatgory=(cfg.ShowByCatgory=='Y'?'Y':'N');
				ReplyIsGeneral=(cfg.ReplyIsGeneral=='Y'?'Y':'N');
				if ($('#MessageWin').length==0) {
					var bestMsgWinHeight=cfg.ShowOneKeyRead=='Y'?630:600;
					var maxWidth=($(window).width()||1300)-20,maxHeight=($(window).height()||700)-20;
					var msgWinWidth=Math.min(1230,maxWidth),msgWinHeight=Math.min(bestMsgWinHeight,maxHeight);
					var $msgListWin=$('<div id="MessageWin" style="padding:0px;overflow:hidden;"></div>').appendTo('body');
					$msgListWin.window({
						title:'消息列表',iconCls:"icon-w-msg",
						isTopZindex:true,modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,width:msgWinWidth,height:msgWinHeight,closable:true,
						content:'<iframe src="'+getTokenUrl("dhc.message.csp")+'" scrolling=no frameborder=0 style="width:100%;height:100%;"></iframe>'
						,onClose:function(){
							//通知类消息弹窗关闭后  判断下业务类消息是否需要弹窗  如果需要则弹之
							if(MsgShowByCatgory=='Y' &&  window.MsgListCatgory=='N' && messageLastCountData) {
								if(judgeAndPopup(messageLastCountData,'B')){  //业务类消息需要并弹窗了
									ShowDHCMessageCount();  //调用一次消息数量
									
								}
			
							}
						}
					});
				}
				if ($('#ExecMessageWin').length==0) {
					var $msgExecWin=$('<div id="ExecMessageWin" class="hisui-dialog" title="须处理" style="padding:0px;overflow:hidden;" ></div>').appendTo('body');
					$msgExecWin.dialog({
						title:'须处理',iconCls:"icon-w-list",
						modal:true,closed:true,collapsible:false,width:1100,height:500,closable:true,minimizable:false,maximizable:false,draggable:false,resizable:false,
						content:"<iframe name=\"dhcmessageexec\" id=\"dhcmessageexec\" scrolling=\"auto\" frameborder=0 style=\"width:100%;height:100%;\"></iframe>",
						onClose:function(){
							$msgExecWin.find('iframe').attr('src','about:blank');
							ShowDHCMessageCount();
							var msgFrame=$('#MessageWin').find('iframe')[0];
							if (msgFrame){
								//try{
									if (msgFrame && msgFrame.contentWindow && msgFrame.contentWindow.onExecWindowClose){
										msgFrame.contentWindow.onExecWindowClose();
									}
								//}catch(e){}	
							}
						}
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
	var audioQueueArray,audioQueueIndex=-1,hasTTS=false,actionTTSTmplMap={};
	function playTipAudio(data,isNewQueue){
		if (EnableMsgAudio){
			if (isNewQueue){
				dhcsys_tts.stop();
				hasTTS=false,actionTTSTmplMap={};
				var arr=[];
				if (data.CountList && ACTION_CFG){
					$.each(data.CountList,function(ind,item){
						if (ACTION_CFG[item.ID] && typeof ACTION_CFG[item.ID].AudioName=="string"){
							var AudioName=ACTION_CFG[item.ID].AudioName;
							if (isIE && AudioName.indexOf('.wav')>-1) AudioName=AudioName.replace('.wav','.mp3');
							if (AudioName.substring(0,3)=='TTS') { //TTS: 开头的表示使用tts朗读
								var tmpl=AudioName.substring(4)||'${Content}' //TTS:开头 剩下为阅读模板
								actionTTSTmplMap[ACTION_CFG[item.ID].Code]=tmpl; 
								hasTTS=true;
								
							}else if (AudioName!="NULL" && arr.indexOf(AudioName)==-1){
								arr.push(AudioName);
							}
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
				}else if(hasTTS && audioQueueIndex>=0 && audioQueueArray && audioQueueIndex>audioQueueArray.length-1){  //固定音频播放到最后了 阅读需要读内容的消息
					$.q({ClassName:'websys.DHCMessageDetailsMgr',QueryName:'FindInfo',UserId:sessionUserId,ReadFlag:'N',OtherParams:'Y'},function(ret){
						
						if (ret && ret.rows && ret.rows.length>0) {
							var contentArr=[];
							for (var i=0,len=ret.rows.length;i<len;i++){
								var ttsText=parseTmpl( actionTTSTmplMap[ret.rows[i].ActionCode]||'' , ret.rows[i], true)
								contentArr.push(ttsText);
							}
							//console.log(contentArr);
							dhcsys_tts.speak(contentArr.join('  '));
						}
					})
				}
			}catch(e){}
		}
	}
	
	/// 为其它产品组界面提供播放音频文件功能
	function playAudioFiles(fileNames){
		if (typeof fileNames=='string'){
			fileNames=[fileNames];
		}
		var arr=[];
		if (fileNames.length>0) {
			for (var i=0,len=fileNames.length;i<len;i++) {
				var file=fileNames[i];
				if (isIE) file=file.replace('.wav','.mp3');
				arr.push(file);
			}
			audioQueueArray=arr;
			audioQueueIndex=-1;
			
			if (typeof hasTTS=='boolean') hasTTS=false;
			
			playTipAudio(); //调用播放
		}
		
	}

	
	
	function parseTmpl(template,data,removeTag){
		data=data||{}
		return template.replace(/\$\{(.+?)\}/ig,function(m,i,d){
				return removeTag?replaceHtml(data[i]||''):(data[i]||'');
		}) ;
	
	}
	function replaceHtml(str){
		return str.replace(/(<[^>]+>)|(&nbsp;)/ig,""); 
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
	window.ForceShowDHCMessageCount=ForceShowDHCMessageCount; //2021-12-03 消息读后没更新消息量
	window.playAudioFiles=playAudioFiles; //2021-12-03 提供一个播放audio文件的js方法
})();


;(function(root){
	var voiceObj,voiceArr=[],voicesToken;
	function initVoiceObj(){
		if (voiceObj) return;
        try{
            voiceObj=new ActiveXObject("Sapi.SpVoice");
            voiceObj.Rate=0;  //语速
            voiceObj.Volume=70;   //音量
            
            voiceObj.AudioOutput=voiceObj.GetAudioOutputs().Item(0); //输出
            
            //声音列表
            voicesToken = voiceObj.GetVoices();
            for(var i = 0; i < voicesToken.Count; i++) {
	            voiceArr.push(voicesToken.Item(i).GetDescription().toLowerCase());
            }
            voiceObj.Voice=voicesToken.Item(0); //声音
        }catch(e){
            voiceObj=null;
            voicesToken=null;
            voiceArr=[];
        }
	}
	/**
	* text 文本
	* rate 语速 -10-10
	* volume 音量
	* voice 声音 描述 模糊匹配
	*/
	function speak(text,rate,volume,voice){
		initVoiceObj();
		rate=parseInt(rate);
		volume=parseInt(volume);
		voice=voice||'Simplified';
		var voiceInd=-1;
		if (typeof voice=='string' && voice!=='') {
			voice=voice.toLowerCase();
			for (var i=0,len=voiceArr.length;i<len;i++){
				if (voiceArr[i]==voice) { //相等的直接使用 估计不会用到
					voiceInd=i;
					break;
				}else if(voiceArr[i].indexOf(voice)>-1 && voiceInd==-1){  //第一个模糊匹配的
					voiceInd=i;
				}
			}
		}
		if (voiceObj){
        	if(!isNaN(rate)) voiceObj.Rate=rate;  //语速
			if(!isNaN(volume)) voiceObj.Volume=volume;   //音量
			if(voiceInd>-1) voiceObj.Voice=voicesToken.Item(voiceInd); //声音
			
			voiceObj.Speak(text,1);
		}
		
	}
	function stop(){
		initVoiceObj();
		if (voiceObj){
			voiceObj.Speak("",2);
		}
	}
	
	root.dhcsys_tts={
		speak:speak,
		stop:stop	
	}
	
})(window);
