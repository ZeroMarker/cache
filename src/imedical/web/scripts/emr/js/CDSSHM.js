var HMmayson = "";
var _globalCdssData = "";
var _paramNow = "";
var loadJSDKFlag = false;
function CDSSHM() {
	//初始化
	this.init = function (data) {
		var _this = this;
		_this.loadType = data.args.loadType;
		_this.cdssHMLoadEpisodeType = data.message.flag;
		var cdssData = data.message;
		if (parent.HMObj == undefined) {
			if (!loadJSDKFlag) {
				//加载JSDK
				var cdssHMUrl = data.args.cdssHMUrl;
				loadScript(cdssHMUrl, function () {
					initHM();
					loadJSDKFlag = true;
				})
			} else {
				initHM();
			}
		} else {
			HMObj = parent.HMObj;
			if (HMObj.Hm_mayson == undefined) {
				if (!loadJSDKFlag) {
					var cdssHMUrl = data.args.cdssHMUrl;
					loadScript(cdssHMUrl, function () {
						initHM();
						loadJSDKFlag = true;
					})
				} else {
					initHM();
				}
			} else {
				//惠每注册走医生站 医生站注册完了回调HMCDSSLoad()
				//loadEMR "Y" 病历初始化  "N" 其他方的初始化
				HMmayson = HMObj.Hm_mayson;
			}
		}
		function initHM() {
			try {
				if (_this.loadType === "m") {
					if (typeof HmCupid == "undefined") {
						HISAlert("HmCupid对象不存在，初始化失败，检查惠每服务", "提示信息");
						cdssLock = "N";
						return
					}
					//客户端对接
					HmCupid.connect(cdssData, function (conn) {
						_this.receiveData(conn);
						if (_globalCdssData != "" && _globalCdssData != undefined) {
							HmCupid.send(_globalCdssData);
							_globalCdssData = "";
						}
					})
				} else if (_this.loadType === "c") {
					if (typeof HM == "undefined") {
						HISAlert("HM对象不存在，初始化失败，检查惠每服务", "提示信息");
						cdssLock = "N";
						return
					}
					//浮窗对接方案
					HM.maysonLoader(cdssData, function (conn) {
						HMmayson = conn;
						//设置接入住院版浮窗对接方案
						conn.setDrMaysonConfig(cdssData.flag, cdssData.customEnv);

						// 回写监听
						conn.listenViewData = function (data) {
							_this.receiveData(data);
						};
						if (_globalCdssData != "" && _globalCdssData != undefined) {
							HMmayson.setMaysonBean(_globalCdssData);
							HMmayson.ai();
							_globalCdssData = "";
						}
					});
				}
			} catch (err) {
				cdssLock = "N";
				HISAlert("惠每CDSS初始化服务出错,检查CDSS配置，确认惠每服务是否正常？", "提示信息");
			}
		}
	},
		//调用第三方接口传数据
		this.sendData = function (maysonData) {
			try {
				if (this.loadType == "m") {
					if (typeof HmCupid == "undefined") {
						_globalCdssData = maysonData;
					} else {
						HmCupid.send(maysonData);
						_globalCdssData = "";
					}
				} else if (this.loadType == "c") {
					if (HMmayson == "" || typeof HMmayson == "undefined") {
						_globalCdssData = maysonData;
					} else {
						HMmayson.setDrMaysonConfig(this.cdssHMLoadEpisodeType, 1);
						HMmayson.setMaysonBean(maysonData);
						HMmayson.ai();
						_globalCdssData = "";
					}
				}
			} catch (err) {
				cdssLock = "N";
				HISAlert("惠每CDSS数据接口出错，确认惠每数据接口是否正常！", "提示信息");
			}

		},
		//病历操作取数据
		this.getData = function (param, actionType) {
			var _this = this;
			_paramNow = param;
			var action = actionType.toUpperCase();
			var instanceId = param.id;
			if (!instanceId) {
				return
			}
			var emrDocId = param.emrDocId
			if (!emrDocId) {
				emrDocId = ""
			}
			var paramter = "AEpisodeID:" + episodeID + ",AUserID:" + userID + ",ADocID:" + emrDocId + ",AInstanceID:" + instanceId + ",AAction:" + action + ",AType:" + episodeType + ",ACdssTool:CDSSHM"
			jQuery.ajax({
				type: "post",
				dataType: "text",
				url: '../EMRservice.BOCDSSService.cls',
				async: false,
				data: {
					"action": "GetCDSSData",
					"param": paramter
				},
				success: function (d) {
					data = JSON.parse(d);
					if (data.success == 1) {
						_this.sendData(data.message);
					} else {
						if (environment === "TEST") {
							HISAlert("取病历数据接口出错：" + data.message || d, "提示信息");
						}
					}
				},
				error: function (d) { HISAlert("取病历数据出错，检查病历数据接口", "提示信息"); }
			});

		},
		//回写数据
		this.receiveData = function (data) {
			var framRecord = "";
			if (window.frames["framRecord"]!=undefined)
			{
				if (!!window.ActiveXObject || "ActiveXObject" in window)
				{
					framRecord = window.frames["framRecord"];
				}
				else
				{
					framRecord = window.frames["framRecord"].contentWindow;
				}
			}	
			if (this.loadType == "m") {
				//客户端加载回写
				HmCupid.receive(function (data) {
					var entity = data;
					for (var i = 0; i < entity.entity.length; i++) {
						var str = "";
						if (entity.entity[i].items.length > 0) {
							for (var j = 0; j < entity.entity[i].items.length; j++) {
								str += entity.entity[i].items[j].text + ",";
							}
						}
						if (entity.entity[i].type == '11') {

							window.open(str, '_blank', 'width=90%,height=90%');
						}
						else {
							if (entity.entity[i].type == '6') {
								var path = getVtePath()
								if (path != "") {
									if (typeof focusSyncDocument == "function") {
										var res = focusSyncDocument(_paramNow.id, path, "Last");
										if (res.result == "OK") {
											framRecord.insertText(str + " ");
										}
									} else if (framRecord != undefined && framRecord.focusSyncDocument != undefined) {
										var res = framRecord.focusSyncDocument(_paramNow.id, path, "Last");
										if (res.result == "OK") {
											framRecord.insertText(str + " ");
										}
									}
								} else {
									if (typeof insertText != "undefined") {
										insertText(str);
									} else if (framRecord != undefined && framRecord.insertText != undefined) {
										framRecord.insertText(str + " ");
									}
								}
							} else {
								if (typeof insertText != "undefined") {
									insertText(str);
								} else if (framRecord != undefined && framRecord.insertText != undefined) {
									framRecord.insertText(str + " ");
								}
							}
						}
					}
				})
			} else if (this.loadType == "c") {
				
				if ((document.getElementById("framRecord") != undefined)&&(document.getElementById("framRecord") != null))
				{
					var editorcdss = document.getElementById("framRecord").contentWindow.document.getElementById("editor")
				}
				else
				{
					var editorcdss = document.getElementById("editor");
				}
				//浮窗回写
				for (var i = 0; i < data.length; i++) {
					var perData = data[i];
					var str = "";
					if (perData.type == 11)
					{
						//type=11:惠每文献，返回url路径
						if (perData.items) {
							for (var j = 0; j < perData.items.length; j++) {
								window.open(perData.items[j].text, '_blank');
							}
						}
					} 
					else if (perData.type == '22')
					{
						if (perData.items[0].type == "1")
						{
							
							if (editorcdss) editorcdss.style.visibility="hidden"; //隐藏插件
						}
						else
						{
							if (editorcdss) editorcdss.style.visibility="visible"; //显示插件
						}
					}
					else {
						//文献外的其他类型，直接做回显处理

						if (perData.items) {
							for (var j = 0; j < perData.items.length; j++) {
								str += perData.items[j].text + ",";
							}
						}
						if (perData.type == '6') {
							var path = getVtePath()
							if (path != "") {
								if (typeof focusSyncDocument == "function") {
									var res = focusSyncDocument(_paramNow.id, path, "Last");
									if (res.result == "OK") {
										framRecord.insertText(str + " ");
									}
								} else if (framRecord != undefined && framRecord.focusSyncDocument != undefined) {
									var res = framRecord.focusSyncDocument(_paramNow.id, path, "Last");
									if (res.result == "OK") {
										framRecord.insertText(str + " ");
									}
								}
							} else {
								if (typeof insertText != "undefined") {
									insertText(str);
								} else if (framRecord != undefined && framRecord.insertText != undefined) {
									framRecord.insertText(str + " ");
								}
							}
						} else {
							if (typeof insertText != "undefined") {
								insertText(str);
							} else if (framRecord != undefined && framRecord.insertText != undefined) {
								framRecord.insertText(str + " ");
							}
						}
					}
				}
			}
		}
}
//医生站初始化完成调用
function HMCDSSLoad() {
	cdssLock = "Y";
	HMmayson = parent.HMObj.Hm_mayson;
	HMmayson.listenViewData = function (data) {
		if (episodeType == "I" || episodeType == "E") {
			//住院走医生站回写
			var titleObj = parent.GetCurSelectedTab();
			if (titleObj.parentTitle == "病历文书") {
				cdssTool.receiveData(data);
			}
		} else {
			var titleName = parent.GetCurSelectedTab();
			//门诊走医生站回写
			if (titleName == "门诊病历") {
				cdssTool.receiveData(data);
			}
		}
	}
	if (typeof _paramNow != "undefined" && _paramNow != "" && typeof cdssTool != "undefined") {
		cdssTool.getData(_paramNow, "Save");
	}

}
//获取患者信息
function getVtePath() {
	var result = ""
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType": "Text",
			"Class": "EMRservice.BL.BLCDSSHMService",
			"Method": "GetVtePath",
			"p1": _paramNow.emrDocId,
			"p2": _paramNow.id
		},
		success: function (d) {
			result = d;
		},
		error: function (d) { HISAlert("获取VTE配置出错", "提示信息", "提示信息"); }
	});

	return result;
}
