///��epr.frames.csp�еĲ�����Ϣ�߼�����������
;(function(){
	var isIE=(!!window.ActiveXObject||"ActiveXObject"in window);
	var engineLoaded=false;
	var g_showMessage=window.g_showMessage||false;  //����һ���Ƿ���ʾ��Ϣ��ťjs����
	var messageLastCountData; //���һ�β�ѯ������Ϣ��������
	var messageCountSearchTimes=0; //��Ϣ���ò�ѯ���� 20190822
	
	var ACTION_CFG;
	var messageLastDate=0,messageLastTime=0;
	var EnableMsgAudio = window.EnableMsgAudio||false;   // ������Ϣ��ʾ��
	var msgJObj = "", findDHCMessageBtnCount = 10;;	//��Ϣ��ťjquery����
	var msgTimeoutQhanlder = "";
	var newMsgAudioObj = document.getElementById("newMsgAudio");
	var MsgSearchInterval=3;
	var sessionUserId='';
	window.LevelTypeFlag = "D,V,I,G"; 
	var AudioOnNewOrAlert=0;
	
	
	var MsgShowByCatgory='';  ///��������ʾ��Ϣ
	window.MsgListCatgory='' //��¼��ǰҪ�򿪵���Ϣ�б�Ĵ��� ;
	var noticeMsgJObj=''; //֪ͨ����Ϣ��ť
	
	var ReplyIsGeneral='';  //�»ظ���Ϣ������
	
	var msgTitleMap={'':'��Ϣ�б�','B':'ҵ����Ϣ�б�','N':'֪ͨ��Ϣ�б�'};
	
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
	
	///�����Ϣ��ť,��ʾ��Ϣ����
	var msgBtnClickHandler = function(isAuto,catgory,popReason){
		if ($('#MessageWin-Marquee').length>0 && $('#MessageWin-Marquee').is(":visible")) return; //�������Ϣ������  

		catgory=catgory||'';
		if (MsgShowByCatgory=='Y') {
			if (!catgory) catgory='B';   //������Ϣ������ʾ��Ϣʱ  ���catgory���Ŀ� ����B ҵ������Ϣ
		}


		if (ACTION_CFG) {
			var now=(new Date()).getTime();
			ACTION_CFG.popupTime=now;
			
			if(!ACTION_CFG.popupTimeMap) ACTION_CFG.popupTimeMap={};
			ACTION_CFG.popupTimeMap[catgory]=now;  //�������¼

		}
		
		if( $('#MessageWin').is(":visible")) return false;
		
		var title=msgTitleMap[catgory];
		window.MsgListCatgory=catgory;
		
		
		if (!isAuto) {
			window.LevelTypeFlag = "D,V,I,G";
			ShowDHCMessageCount(); //isAuto�ǲ����Զ��� �Զ����Ͳ��ٲ�һ����
		}else{
			if (popReason && popReason=='sss') {
				window.LevelTypeFlag = "D,V,I,G"; //������Ϣ����
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
		$("#MessageWin").window("open").window('setTitle',title);  //���Ĵ�
		return false;
	} 
	function HideExecMsgWin (){
		$("#ExecMessageWin").window("close");
	};
	var ShowExecMsgWin = function(DetailsId,OtherJson){
		var dialogTitle=OtherJson.dialogTitle||'�봦��';
		var ExecMsgWinJObj = $("#ExecMessageWin");
		if( ExecMsgWinJObj.is(":visible")) return false;
		var maxWidth=$(window).width();
		var maxHeight=$(window).height();
		var realHeight=0,realWidth=0;
		var dialogWidth=OtherJson.dialogWidth,dialogHeight=OtherJson.dialogHeight;
		var msgWinOpts=$("#MessageWin").window('options');
		
		if (dialogWidth=="100%"&&dialogHeight=="100%"){  //����100% 
			realWidth=maxWidth;
			realHeight=maxHeight;
		}else if(parseInt(dialogWidth)=="0"&&parseInt(dialogHeight)=="0"){  //����0px ����Ϣ�����С����
			realWidth=msgWinOpts.width;
			realHeight=msgWinOpts.height;
		}else{  //���� %����ٷֱ� pxֱ��ʹ��   �������� ����20px
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
			
			
			if(typeof cefbound == 'object') { //ҽΪ�����
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
	// ��һ�ε�¼����Ϣ�б仯ʱ���á�  
	// ����query,ˢ����Ϣ����
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
						if (MWToken){  /// ��ʱ���Զ�����
							if ('undefined'!==typeof lockScreenOpt && 'function'==typeof lockScreenOpt.lockScrn) lockScreenOpt.lockScrn();
						}else{
							$.messager.alert("��ʾ","ϵͳ�ѳ�ʱ,��رս���,���µ�¼!");
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
					
					var Count=parseInt(rtn.Count)||0;  //��Ϣ����
					var CountNotice=parseInt(rtn.CountNotice)||0;  //֪ͨ����Ϣ����
					var CountBusiness=Count-CountNotice; //ҵ������Ϣ����
					
					setMsgCountHtml(CountBusiness,CountNotice);

					var isAlert=false;
					if(MsgShowByCatgory=='Y') {  //��������
						if (judgeAndPopup(rtn,'N')) {  //֪ͨ���� �жϲ�����
							isAlert=true;
						}else if (judgeAndPopup(rtn,'B')){ //ҵ������ �жϲ�����
							isAlert=true;
						}
						
					}else{ //����������
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
					messageLastCountData=rtn; //���鵽�����ݱ���
					
					var SSSCount=parseInt(rtn.SSSCount)||0;  //��Ϣ����
					var SSSCountNotice=parseInt(rtn.SSSCountNotice)||0;  //֪ͨ����Ϣ����
					var SSSCountBusiness=SSSCount-SSSCountNotice; //ҵ������Ϣ����
					
					setMsgListStatus(SSSCountBusiness,SSSCountNotice);
					
				}
				if (typeof rtn=="object" && typeof childFrameOnMsgCount=="function"){ //������ϵͳ�������������ÿ����ѯ����Ϣ��������
					childFrameOnMsgCount(rtn);	
				}
				messageCountSearchTimes++;
				msgTimeoutQhanlder = setTimeout(ShowDHCMessageCount,MsgSearchInterval*60*1000);
			})
	}
	
	
	///�ж��Ƿ���Ҫ���� ��Ҫ�򵯴�  �����������true
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
			$('#MessageWin').window('setTitle',listTitle+'������Ҫ�ȴ���ǰ'+sCount+'����Ϣ���ܹرմ��ڣ�');
			
			if(typeof HISUIStyleCode=='string' && HISUIStyleCode=='lite'){ //���� title��Ϊ��ɫ����
				$('#MessageWin').window('window').find('>.panel-header>.panel-title').css('color','red');
			}else if (!$.hisui){  //easyui�汾 ��Ϊ��ɫ����
				$('#MessageWin').window('window').find('>.panel-header>.panel-title').css('color','red');
			}else{  //�Ųʸ�Ϊ��ɫ����
				$('#MessageWin').window('window').find('>.panel-header').css({backgroundColor:'red',borderColor:'red'});
				
			}
		}else{
			$('#MessageWin').window('window').find('>.panel-header>.panel-tool>.panel-tool-close').show();
			$('#MessageWin').window('setTitle',listTitle);
			if(typeof HISUIStyleCode=='string' && HISUIStyleCode=='lite'){ //���� title��Ϊ��ɫ����
				$('#MessageWin').window('window').find('>.panel-header>.panel-title').css('color','#000');
			}else if (!$.hisui){  //easyui�汾 ��Ϊԭɫ
				$('#MessageWin').window('window').find('>.panel-header>.panel-title').css('color','#0E2D5F');
			}else{  //�Ųʸ�Ϊ#556983����
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
	//��ʾ��Ϣ����
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
			//��һ�β�ѯ���� ��Ϣ������������
			if (messageCountSearchTimes==0 && !MsgActionTypeConfigLoaded) {
				LoadMsgActionTypeConfig(ShowDHCMessageCount);
				return;
			}
			ForceShowDHCMessageCount(true,messageCountSearchTimes==0);
		}else{
			//û���ҵ�Ԫ��,������extû��render���,���Ե�ȥ��ȥ��ѯ,���ǿ�����easyui��ͷ�˵�
			msgTimeoutQhanlder = setTimeout(ShowDHCMessageCount,1000);
			findDHCMessageBtnCount--;
		}
	}
	//data ��̨�õ�������
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

						//������Ϣ��δ�������»ظ�(�����ж������� ReplyIsGeneral �»ظ���Ϣ�Ƿ���������Ϣ�������� 20230110 ) �ǳ���Ҫ��Ϣ��δ������δ��
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
						title:'��Ϣ�б�',iconCls:"icon-w-msg",
						isTopZindex:true,modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,width:msgWinWidth,height:msgWinHeight,closable:true,
						content:'<iframe src="'+getTokenUrl("dhc.message.csp")+'" scrolling=no frameborder=0 style="width:100%;height:100%;"></iframe>'
						,onClose:function(){
							//֪ͨ����Ϣ�����رպ�  �ж���ҵ������Ϣ�Ƿ���Ҫ����  �����Ҫ��֮
							if(MsgShowByCatgory=='Y' &&  window.MsgListCatgory=='N' && messageLastCountData) {
								if(judgeAndPopup(messageLastCountData,'B')){  //ҵ������Ϣ��Ҫ��������
									ShowDHCMessageCount();  //����һ����Ϣ����
									
								}
			
							}
						}
					});
				}
				if ($('#ExecMessageWin').length==0) {
					var $msgExecWin=$('<div id="ExecMessageWin" class="hisui-dialog" title="�봦��" style="padding:0px;overflow:hidden;" ></div>').appendTo('body');
					$msgExecWin.dialog({
						title:'�봦��',iconCls:"icon-w-list",
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
							if (AudioName.substring(0,3)=='TTS') { //TTS: ��ͷ�ı�ʾʹ��tts�ʶ�
								var tmpl=AudioName.substring(4)||'${Content}' //TTS:��ͷ ʣ��Ϊ�Ķ�ģ��
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
				}else if(hasTTS && audioQueueIndex>=0 && audioQueueArray && audioQueueIndex>audioQueueArray.length-1){  //�̶���Ƶ���ŵ������ �Ķ���Ҫ�����ݵ���Ϣ
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
	
	/// Ϊ������Ʒ������ṩ������Ƶ�ļ�����
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
			
			playTipAudio(); //���ò���
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
	window.ForceShowDHCMessageCount=ForceShowDHCMessageCount; //2021-12-03 ��Ϣ����û������Ϣ��
	window.playAudioFiles=playAudioFiles; //2021-12-03 �ṩһ������audio�ļ���js����
})();


;(function(root){
	var voiceObj,voiceArr=[],voicesToken;
	function initVoiceObj(){
		if (voiceObj) return;
        try{
            voiceObj=new ActiveXObject("Sapi.SpVoice");
            voiceObj.Rate=0;  //����
            voiceObj.Volume=70;   //����
            
            voiceObj.AudioOutput=voiceObj.GetAudioOutputs().Item(0); //���
            
            //�����б�
            voicesToken = voiceObj.GetVoices();
            for(var i = 0; i < voicesToken.Count; i++) {
	            voiceArr.push(voicesToken.Item(i).GetDescription().toLowerCase());
            }
            voiceObj.Voice=voicesToken.Item(0); //����
        }catch(e){
            voiceObj=null;
            voicesToken=null;
            voiceArr=[];
        }
	}
	/**
	* text �ı�
	* rate ���� -10-10
	* volume ����
	* voice ���� ���� ģ��ƥ��
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
				if (voiceArr[i]==voice) { //��ȵ�ֱ��ʹ�� ���Ʋ����õ�
					voiceInd=i;
					break;
				}else if(voiceArr[i].indexOf(voice)>-1 && voiceInd==-1){  //��һ��ģ��ƥ���
					voiceInd=i;
				}
			}
		}
		if (voiceObj){
        	if(!isNaN(rate)) voiceObj.Rate=rate;  //����
			if(!isNaN(volume)) voiceObj.Volume=volume;   //����
			if(voiceInd>-1) voiceObj.Voice=voicesToken.Item(voiceInd); //����
			
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
