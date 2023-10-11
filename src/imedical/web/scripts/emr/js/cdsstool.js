///CDSS 对接方案：基础平台完成与提供商对接工作
///电子病历通过调用基础平台提供的统一服务接口完成数据推送业务

var cdsstool;
var cdssService = [];

// 调用CDSS函数
(function(){
	if (typeof patInfo != "undefined") {
        if ((typeof envVar != "undefined")&&(envVar.versionID && (envVar.versionID != '3'))){
            userID = patInfo.userID;
            userLocID = patInfo.userLocID;
            patientID = patInfo.patientID;
            episodeID = patInfo.episodeID;
            userName = patInfo.userName;
            hospitalID = patInfo.hospitalID;
            admType = patInfo.admType
        }else{
            userID = patInfo.UserID;
            userLocID = patInfo.UserLocID;
            patientID = patInfo.PatientID;
            episodeID = patInfo.EpisodeID;
            userName = patInfo.UserName;
            hospitalID = patInfo.HospitalID;
            admType = patInfo.admType
        }
        if (episodeID == "") {
            var frm = top.document.forms['fEPRMENU'];
            episodeID = frm.EpisodeID.value;
            patientID = frm.PatientID.value;
        }
    }
    if (typeof setting != "undefined") {
        userID = setting.userId;
        userLocID = setting.userLocId;
        patientID = setting.patientId;
        episodeID = setting.episodeId;
        hospitalID = setting.hospitalID;
        admType = setting.admType;
    }
    
    cdsstool = new cdsstool();
	cdsstool.init();
})();


function cdsstool(){
	//获得当前开启的CDSS服务信息
	this.CDSSConfig = function (){
		//getWebsysCDSSConfig();
		//获取服务接口，与对接代码位置有关
		if (typeof getWebsysCDSSConfig =="function")
		{
			return getWebsysCDSSConfig();
		}
		else if(typeof parent.getWebsysCDSSConfig== "function")
		{
			return parent.getWebsysCDSSConfig();
		}
		else
		{
			win = websys_getMenuWin();
			return win.getWebsysCDSSConfig();
		}
		
	}

	this.getWebsysCDSS = function (type) {
		//获取服务接口，与对接代码位置有关
		if (typeof getWebsysCDSS =="function")
		{
			return getWebsysCDSS(type)
		}
		else if(typeof parent.getWebsysCDSS== "function")
		{
			return parent.getWebsysCDSS(type)
		}
		else
		{
			win = websys_getMenuWin();
			return win.getWebsysCDSS();
		}
	},
	this.getWebsysToCDSS = function (type) {
		//获取服务接口，与对接代码位置有关
		if (typeof getWebsysToCDSS =="function")
		{
			return getWebsysToCDSS(type)
		}
		else if(typeof parent.getWebsysToCDSS== "function")
		{
			return parent.getWebsysToCDSS(type)
		}
		else
		{
			win = websys_getMenuWin();
			return win.getWebsysToCDSS();
		}
	},
	
	this.init = function () {
		
		var cdssConfig = this.CDSSConfig();
		
		for (var i = 0; i < cdssConfig.length; i++) {
			type= cdssConfig[i].type
			version = cdssConfig[i].v
			//this.getWebsysToCDSS 仅CNKI 有用
			
			curCDSSServer = GetCDSSServer(this.getWebsysCDSS, type,this.getWebsysToCDSS)
		   
			curCDSSServer["type"]= type
			curCDSSServer["version"]= version
		   
		   cdssService.push(curCDSSServer);
		}
	},
	
	this.getData = function(param, type, eventType) 
	{
		for (var i = 0; i < cdssService.length; i++) {
			//逐项获取cdss服务待推送数据
			var send = cdssService[i].getdata(param, type);
			//调用当前cdssService中的senddata函数推送数据
			cdssService[i].senddata(send)
		}
	},
	
	this.receiveData = function(data) 
	{
		for (var i = 0; i < cdssService.length; i++) {
			cdssService[i].receiveData(data)
		}
	}
}


function GetCDSSServer(getWebsysCDSS, type,getWebsysToCDSS)
{
	if (type == 'mediway')
	{
		cdssobj = getWebsysCDSS(type)
		
		getdatafunc = function(param,actionType){
			return getData(param,actionType,"CDSSDH")
		},
		sendfunc = function(data){
			return cdssobj.TriggerDHCDSS("SAVE_MEDICAL_RECORD_INFORMATION",data)
		},
		
		receivefunc = function(data){
			return insertTextToEMR(data)
			
		}
		cdssobj.MonitorWriteData = function(data){
			receivefunc(data);
		}
		
	}
	else if (type == 'mayson')
	{
		cdssobj = getWebsysCDSS(type)
		
		getdatafunc = function(param,actionType){
			return getData(param,actionType,"CDSSHM")
		},
		sendfunc = function(data){
			return cdssobj.ai(data, callback)
		},
		receivefunc = function(data){
			return insertTextToEMR(data)
		}
		//增加监听函数
		cdssobj.listenViewData = function(currentEntity){
			receivefunc(currentEntity);
		}

	}
	else if (type == 'baidu')
	{
		cdssobj = getWebsysCDSS(type)
		
		getdatafunc = function(param,actionType){
			getData(param,actionType,"CDSSBD")
		},
		sendfunc = function(data){
			return cdssobj.refresh(data);
		},
		receivefunc = function(data){
			return insertTextToEMR(data)
		}
	}
	
	else if (type == 'cnki')
	{
		//cnki 发送与接收是2个不同的对象
		cdssobjSend = getWebsysToCDSS(type)
		cdssobjListen = getWebsysCDSS(type)
		
		cdssobjListen.listen(function (msg){
		  // 得到cdss消息
		  	if (msg != undefined && msg != "" && msg != "undefined")
		  	{
				msg = JSONparse(msg);
				var type = msg.type;
				var value = JSONstringify(msg.jsonData);
			}
		})
  
		getdatafunc = function(param,actionType){
			return getData(param,actionType,"CDSSCNKI")
		},
		sendfunc = function(data,cnkitype ){
			//cnkitype :确认是否为保存 加载 删除 等
			objcase = { type: cnkitype, jsonData: data };
			return cdssobjSend.targets["CNKI_CDSS"].send(JSON.stringify(objcase));
		},
		receivefunc = function(data){
			return insertTextToEMR(data)
		}
	}
	
	return {"getdata":getdatafunc,"senddata":sendfunc , "receivedata": receivefunc}
	
}
///与服务器交互，获取各公司json数据
///此代码无变化
function getData(param,actionType,cdssCompany)
{
	var cdss_data="";
	var _this=this;
	var action=actionType.toUpperCase();
	if(action==="DELETE") return
	var docId = param.emrDocId    
	var instanceID = param.id
	
	if ((typeof envVar != "undefined")&&(envVar.versionID && (envVar.versionID != '3')))
	{
        	var docId = ""   
		var instanceID = param.documentID
    	}else{
        	var docId = param.emrDocId    
		var instanceID = param.id
    	}
        
	
	var param="AEpisodeID:"+episodeID+",AUserLocID:"+userLocID+",AUserID:"+userID+",AInstanceID:"+instanceID+",ADocID:"+docId+",AAction:"+action+",AType:"+ admType +",ACdssTool:"+cdssCompany+",AHospitalID:"+hospitalID
	
	jQuery.ajax({
		type: "get",
		dataType: "json",
		url: '../EMRservice.BOCDSSService.cls',
		async: false,
		data: {
			"action":"GetCDSSData",
			"param":param
		},
		success: function(d) {
			if(d.success==1){
				cdss_data=d.message;
			}
		},
		error : function(d) { 
			alert("CDSS GetData函数执行异常"+d);
		}
	});
	return cdss_data;
}

/////数据回写
//data数据格式需要转换为insertText规定的入参格式
function insertTextToEMR(data)
{
	
	/*
		[
		  [
			{text: '文本内容'},
			{text:'上标',sup:'true'},
			{text:'下标',sub:'true'},
			{text: '文本内容'}
			……
		  ], 
		  // 一个数组就表示一段文本内容，即段落
		  [
			{text: '文本内容'},
			{text:'上标',sup:'true'},
			{text:'下标',sub:'true'},
			{text: '文本内容'}
			……

		  ],
		  ……
		]
	*/
	if(typeof data === "undefined") return;
	 
	if(typeof insertText != "undefined")
	{
		insertText(data);
	}
	else if(window.frames["framRecord"] !=undefined && window.frames["framRecord"].contentWindow.insertText != undefined)
	{              
		window.frames["framRecord"].contentWindow.insertText(data);
	}            
}