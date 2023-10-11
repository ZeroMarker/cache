/**
 *基于HISUI弹窗
 */
 
var _openedAuditPopProcess = false;	
//dom操作对象
var _ow=top //top.$HUI?top:window; //决定了弹出窗口的位置:top就是跨菜单的提示，window是离开当前界面就消失了
var jq = _ow.$;
var WEBSOCKET=true;
_ow._appDao = {
	ws:"",
	appAllData:[],
	appClosePanel:function(){
		jq("#appPanel").hide();
	},
	checkThis:function(_this){
		if(!jq(_this).hasClass("appListItmChecked")){
			jq(".appListItmChecked").length?jq(".appListItmChecked").removeClass("appListItmChecked"):"";
			jq(_this).addClass("appListItmChecked");
		}
	},
	appConfirm:function(){
		var _this=this;
		_ow.$cm({
			ClassName:"web.DHCPRESCAuditPopup",
			MethodName:"UpdDataReadStat",
			PARRowID:jq("#appPARRowID").val(),
			"dataType":"text"
		},function(ret){
			if(ret==0){
				jq.messager.alert("提示","修改状态成功!");
				_this._showSureAuditPop();	
			}else{
				jq.messager.alert("提示","修改状态失败!");
				return;
			}
		});
	},
	appReply:function(){
		var _this=this;
		if(!jq(".appListItmChecked").length){
			jq.messager.alert("提示","请选择一条记录!");
			return;	
		}
		var thisData=this.appAllData[jq(".appListItmChecked").attr("data-index")];
		var prescAuditResultId=thisData.PARRowID;
		var url = 'dhcpresc.reviewreply.csp?parRowID='+prescAuditResultId;
		websys_showModal({
			url: url,
			iconCls:"icon-w-paper",
			title: '审方处理',
			closed: true,
			modal:true,
			width:500,
			onClose:function(){
				_this._showSureAuditPop();	
			}
		});
	},
	appContact:function(){
		var _this=this;
		var auditId=arguments[0]||"";
		var thisData=this.appAllData[jq(".appListItmChecked").attr("data-index")];
		var url = "dhcpresc.newscontact.csp?userType="+_ow.userType+"&auditId="+auditId;
		if ('undefined'!==typeof websys_getMWToken){
			url += "&MWToken="+websys_getMWToken();
	}
		jq("#newsContact").attr("src",url);
		
		if(jq("#newsWin").hasClass("panel-body")){
			jq("#newsWin").window("open");
		}else{
			jq("#newsWin").window({
				width:800,
				height:700,
				iconCls:'icon-w-save',
				resizable:true,
				modal:false,
				isTopZindex:true
			});
		}
	},
	oepnWs:function(opt){
		var _this = this;
		var userType = _ow.userType
		//使用websoket通讯
		var wsUrl = ((window.location.protocol == "https:")?"wss:":"ws:")+"//"+window.location.host+
						"/imedical/web/web.DHCPRESCWebSocketServer.cls?userType="+userType+"&conType=UnRead"; //UnRead是标识未读数字的ws
		var ws = new WebSocket(wsUrl);
		_this.ws=ws;
		
		ws.onopen  = function(event) {
			console.log("连接成功建立!", event);
			_ow._appDao._showAuditPop();
			//_this._showAuditPop();
		};
		
		ws.onmessage = function(event) {
			console.log("WebSocket message received:", event);
			var data=event.data;
			var dataArr=data.split(String.fromCharCode(2));
			var dataType=dataArr[0];
			if(dataType=="number"){
				_this._setMsgNumber(dataArr[1]);
			}
			if(dataType!="number"){
				///消息沟通界面
				var newsWindow=jq("#newsContact")[0].contentWindow;
				if(dataType=="list"){
					var itmData=newsWindow.$.parseJSON(dataArr[1]);
					var auditId=itmData.AuditID;
					var userType=_ow.userType;
					var msgNum=(userType=="Audit"?itmData.DoctorCount:itmData.AuditCount);
					if(msgNum=="0") msgNum="";
					if(newsWindow.$(".listItm[data-auditid='"+auditId+"']").length){
						newsWindow.$(".listItm[data-auditid='"+auditId+"']").find("#listUnreadNumber").text(msgNum);
					}else{
						newsWindow.addListItm(itmData,"before");
					}
				}
				
				if(dataType=="msg"){
					var itmData=newsWindow.$.parseJSON(dataArr[1]);
					var itmHtml=newsWindow.thisHtml(itmData);
					newsWindow.$("#msgContent").append(itmHtml);
					newsWindow.scrollBottom();
				}
			}
			
			opt.callBak(itmData);
		};
		
		ws.onerror = function(event) {
			console.log("WebSocket error received:", event);
		};
		
		ws.onclose = function(event) {
			console.log("连接已经关闭!", event);
			//_this.oepnWs(); ///关闭连接自动开启连接
		};	
	},
	_showAuditPop:function(){
		this._showSureAuditPop();
	},
	_showSureAuditPop:function(){
		var lgHospID=session['LOGON.HOSPID'];
		var lgCtLocID=session['LOGON.CTLOCID'];
		var lgGroupID=session['LOGON.GROUPID'];
		var lgUserID=session['LOGON.USERID'];
		var lgParams=lgHospID+"^"+lgCtLocID+"^"+lgGroupID+"^"+lgUserID;
		var userType=_ow.userType;
		var params=userType+"^"+lgUserID;
		var _this=this;
		_ow.$cm({
			ClassName:"web.DHCPRESCAuditPopup",
			MethodName:"MainUnReadTextNew",
			"Params":params,
			"dataType":"text"
		},function(ret){
			_this._setMsgNumber(ret);
		});	
	},
	_setMsgNumber:function(ret){
		var retArr=ret.split("^");
		var auditNum=retArr[0];
		var allMsgNum=retArr[1];
		jq("#auditNum").html(auditNum);
		jq("#allMsgNum").html(allMsgNum);
		if(parseInt(auditNum)||parseInt(allMsgNum)){
			console.log(0)
			jq("#appPanel").show();
			return;
		}else{
			console.log(1)
			jq("#appPanel").hide();	
		}
	},
	_initPopProcessPage:function(){
		if(!jq("#appPanel").length){
			/*
			var _divHtml=""+
				"<style>"+
					".appItmTitle{font-weight: 600;}"+
					".appItmBtn{display: inline-block;width:50px;height:30px;background:#3eaae0;color:#fff;text-align:center;line-height:30px;cursor:pointer;}"+
					".appItmBtn:hover{background:#1280b7}"+
					".appListItm{height: 25px;line-height:25px;margin-top:1px;width:135px;border-bottom:1px solid #ccc;cursor:pointer;}"+
					".appListItm:hover{background:#DCF0FF}"+
					".appListItmChecked{background:#509DE1 !important}"+
				"</style>"+
				"<div id='appPanelDiv' style='position:absolute;right:10px;bottom:10px;width:400px;height:420px;border-radius:5px 5px 0px 0px;box-sizing:border-box;background:#fff;display:none;'>"+
					"<div style='background: #566982;height: 35px;line-height: 35px;border-radius: 5px 5px 0px 0px;'>"+
						"<span style='color: #fff;margin-left: 10px;'>审方中心通知</span>"+
						"<span style='color: #fff;position: absolute;right:10px;font-size:18px;font-weight:600;cursor:pointer;' onclick='_appDao.appClosePanel()'>×</span>"+
					"</div>"+
					"<div style='border: 1px solid #ccc;height: 385px;'>"+
						"<div id='appList' style='float:left;width:40%;'></div>"+
						"<div style='float:left;width:60%;'>"+
							"<div id='appAuditStatus' style='height: 30px;line-height: 30px;color: #328ef1;font-size: 16px;font-weight: 600;text-align: center;margin-top: 2px;'></div>"+
							"<div style='display:none;'><input id='appPARRowID'/></div>"+
							"<div><span class='appItmTitle'>姓名:</span><span id='appPatName'></span></div>"+
							"<div><span class='appItmTitle'>登记号:</span><span id='appPatNo'></span></div>"+
							"<div><span class='appItmTitle'>处方号:</span><span id='appPrescNo'></span></div>"+
							"<div><span class='appItmTitle'>提交时间:</span><span id='appSubDate'></span></div>"+
							"<div><span class='appItmTitle'>审核人:</span><span id='appUser'></span></div>"+
							"<div><span class='appItmTitle'>审核时间:</span><span id='appDate'></span></div>"+
							"<div><span class='appItmTitle'>审核原因:</span><span id='appReason'></span></div>"+
							"<div><span class='appItmTitle'>原因备注:</span></div>"+
							"<div><textarea id='appRemark' style='width: 98%;height: 115px;' disabled></textarea></div>"+
							"<div style='text-align:center;margin-top:5px;'>"+
								"<span id='sure' class='appItmBtn' onclick='_appDao.appConfirm()'>确定</span>"+
								"<span id='reply' class='appItmBtn' style='' onclick='_appDao.appReply()'>处理</span>"+
								"<span id='contact' class='appItmBtn' style='margin-left:10px;' onclick='_appDao.appContact()'>沟通</span>"+
							"</div>"+
						"</div>"+
					"</div>"+
				"</div>"
			*/
			var _divHtml=""+
				"<div id='appPanel' style='position:absolute;right:30px;bottom:175px;width:185px;height:75px;cursor:pointer;display:none;' onclick='_appDao.appContact()'>"+
					"<img style='position: absolute;' src='../scripts/dhcnewpro/dhcpresc/images/dhcpresc/bz4.png'/>"+
					"<div>"+
						"<span style='color: #4da2f1;font-weight: 600;font-size: 15px;position: absolute;left: 80px;top:16px;'>待处理</span>"+
						"<span id='auditNum' style='font-size: 16px;color: #0068c6;font-weight: 700;position: absolute;left: 140px;top:16px;'></span>"+
					"</div>"+
					"<div>"+
						"<span style='color: #b3b3b3;position: absolute;top: 43px;left: 80px;font-weight: 500;'>聊天消息</span>"+
						"<span id='allMsgNum' style='background: #ff5219;color: #fff;position: absolute;top: 43px;left: 144px;border-radius: 10px;font-size: 10px;width: 15px;line-height: 15px;text-align: center;'></span>"+
					"</div>"+
				"</div>"+
				"<div style='position: absolute;right: 29px;bottom: 7px;width: 175px;height: 175px;cursor: pointer;display:none;' onclick='_appDao.appContact()'>"+
					"<img style='position: absolute;width: 175px;z-index:-1;' src='../scripts/dhcnewpro/dhcpresc/images/dhcpresc/jxfk.png'/>"+
					"<div style='margin-top: 20px;margin-left: 20px;line-height: 25px;'>"+
						"<span style='width: 4px;height: 10px;display: inline-block;'></span>"+
						"<span style='margin-left: 10px;'>处理状态</span>"+
					"</div>"+
					"<div style='margin-left: 20px;line-height: 25px;'>"+
						"<span style='color:#bababa;font-size: 12px;font-weight: 500;'>姓名</span>"+
						"<span style='color:#757575;font-size: 12px;font-weight: 600;margin-left: 10px;'>张三</span>"+
					"</div>"+
					"<div style='margin-left: 20px;line-height: 25px;'>"+
						"<span style='color:#bababa;font-size: 12px;font-weight: 500;'>处方号</span>"+
						"<span style='color:#757575;font-size: 12px;font-weight: 600;margin-left: 10px;'>989789798</span>"+
					"</div>"+
					"<div style='margin-left: 20px;margin-right: 15px;color: #757575;height: 60px;font-size: 12px;overflow: hidden;text-overflow: ellipsis;'>"+
						"处方书写不合理处方书写不合理处方书写不合理处方书写不合理处方书写不合理"+
					"</div>"+
				"</div>"+
				"<div id='newsWin' class='hisui-window' title='消息沟通' style='overflow: hidden;'>"+
					"<iframe id='newsContact' name='newsContact' src='' style='width:100%;height:100%'></iframe>"+
				"</div>"
			jq("body").append(_divHtml);
			
		}
		return;
	}
}

function _openShowAuditPopProcess(options){
	
	var _dt = {
		userType:"",
		callBak:function(serverRetData){
			//console.log(serverRetData);
		}
	};
	var _opt=$.extend(_dt, options);
	
	if(!_ow._openedAuditPopProcess){
		_ow._openedAuditPopProcess=true;
		_ow.userType=options.userType;	///开启的类型
		_ow._appDao._initPopProcessPage();
		
		if(WEBSOCKET){
			_ow._appDao.oepnWs(_opt);	///开启ws
		}else{
			_ow._appDao._showAuditPop();
			_ow.setInterval("_appDao._showAuditPop()",5000);
		}
	}
	return;
}

///打开沟通界面
function _openMassTalkPage(auditId){
	_ow._appDao.appContact(auditId);
	return;
}
