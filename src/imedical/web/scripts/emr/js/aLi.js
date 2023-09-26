var alijk=null;
function ALICDSS(){
	this.sendData=function(data,paramJson,type){
		//门诊住院 公共传参
	var patientInfo = getPatinent();
	var object={
		"patientId":patientID,
		"patientName":patientInfo.name,
		"doctorId":userID,
		"hospitalId":hospitalID,
		"deptName":currentDeptName,
		"deptId":currentDeptId,
		"doctorName":mainDocName,
		"admissionTime":admDateTime,
		"gender":patientInfo.gender,
		"genderCd":patientInfo.genderType,
		"birthDate":patientInfo.birthday
	};
	if(caseType=="outhos"){
		object.clinicId=episodeID;
	}else{
		object.inHosId=episodeID;
	}
	if(type=="SAVE"){
		for(key in data[0]){
			object[key]=data[0][key];
		}
	}else if(type=="DELETE"){
		var progressType=getProgressType(paramJson);
		object.deleteProgressList=[{
			"progressId":paramJson.InstanceID,
			"progressType":progressType,
			"doctorId":userID,
			"recordTime":getCurrentDateTime()	
		}]	
	}
	
	if(alijk==null && cdssFlag){
	alijk = new AlijkAi({
  //非必填,新版本用户使用api版本入参
  version: "2.0.0",
  //必填，本地访问时可不使用，如需使用获取方式参考《三方鉴权接入文档》
  autherKey : paramHM.autherKey,
  // 必填，阿里健康提供
  iframeAddress: paramHM.iframeAddress,
  //非必填，面板宽度
  width: 100, 
  //非必填，面板高度
  height: 100, 
  //必填，接入方自定义
  patientId : patientID,
  //必填，接入方自定义
  doctorId : userID, 
  //必填，接入方自定义(门诊病例或住院病历唯一ID) 
  serialNumber : episodeID, 
  //必填，科室名称(如“妇产科”，“儿科”) 
  deptName : userLocName,
  //必填，科室唯一Id
  deptId : userLocID,
  //必填，医生名字
  doctorName : userName, 
  //必填，卫计委医疗机构唯一编码 
  hospitalId : hospitalID,
  //必填，卫计委医疗机构唯一编码 
  hospitalName : hospitalName,
  // 必填，病例类型(住院：inhos，门诊：outhos，护理：nurse)
  caseType: caseType, 
  // 主系统回显方法
  updateWindow: function(data) {
     //data的数据格式如下
     console.log(data);
     console.log(arguments);
  },
  // token过期回调
  expiresCallback: function() {
    console.log(arguments);
  },
  loadComplete:function(_this){
	  cdssFlag=false;
	  _this.sendAiRequest(object);
  }
	});
	}else if(!cdssFlag && alijk!=null){
		//console.log(JSON.stringify(object))
		alijk.sendAiRequest(object);
	}
},
this.getData=function(instanceId,commond,type){
	//取病历数据   调Ali接口
	_this=this;
	type=type.toUpperCase();
	var paramJson ={InstanceID:instanceId,DocID:commond.emrDocId}
	if(type=="DELETE"){
		_this.sendData("",paramJson,type);
	}else{
	jQuery.ajax({
			type: "get",
			url: "../EMRservice.Ajax.common.cls",
			async: true,
			data: {
				"OutputType":"Stream",
				"Class":"EMRservice.BL.BLCDSSAliService",
				"Method":"GetSectionInfo",			
				"p1":episodeID,
				"p2":commond.emrDocId,
				"p3":instanceId,
				"p4":caseType,
				"p5":userID
			},
			success: function(d){
				d = JSON.parse(d);
				_this.sendData(d,paramJson,type);
			},
			error: function(d){console.log(d);}
	});
	}	
}	
}
function getProgressType(param){
	var result = "";
	jQuery.ajax({
		url:"../EMRservice.Ajax.common.cls",
		async:false,
		data:{
			"OutputType":"text",
			"Class":"EMRservice.BL.BLCDSSAliService",
			"Method":"GetCDSSCode",
			"p1":param.DocID,
			"p2":param.InstanceID	
		},
		success:function(d){
			result=d;	
		},
		error:function(d){
			alert("GetCDSSCode error");	
		}
	})	
	return result
}
/**
* 浮窗打开，关闭命令
* @param object 
{
  "action":"（String）super-close  关闭  super-open 打开"
}
*/
//获取患者信息
function getPatinent()
{
	var result = "" 
	jQuery.ajax({
			type: "get",
			dataType: "json",
			url: "../EMRservice.Ajax.common.cls",
			async: false,
			data: {
				"OutputType":"Text",
				"Class":"EMRservice.BL.BLCDSSAliService",
				"Method":"GetPatientInfo",			
				"p1":episodeID
			},
			success: function(d){
				result = d;
			},
			error: function(d){alert("获取患者信息出错");}
	});
	
    return result;
}