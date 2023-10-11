/**
* @creator: Huxt 2019-11-26
* @desc: 临床药学打印公共js
* @js: scripts/dhcpha/clinical/cpwprintcom.js
*/

/*
* @creator: Huxt 2019-11-26
* @desc: 医学首次查房记录打印
*/
function print_FirstMedRoundInf(medWardID){
	if(medWardID==""){
		alert("医学查房ID为空,请重试！");
		return;
	}
	PRINTCOM.jsRunServer(
	{
		ClassName: 'web.DHCPHCLIPATHOGRAPHY',
		MethodName: 'GetMedWardRecordPrint',
		PHCPRid: medWardID,
		adm: EpisodeID
	},
	function(retJson){
		PRINTCOM.XML({
			printBy: 'lodop',
			XMLTemplate: 'PHACPWMedwardFirst',
			data: retJson
		});
	})
}

/*
* @creator: Huxt 2019-11-26
* @desc: 医学日常查房记录打印
*/
function print_MedRoundInf(medWardID){
	if(medWardID==""){
		alert("医学查房ID为空,请选择查房记录后重试！");
		return;
	}
	PRINTCOM.jsRunServer(
	{
		ClassName: 'web.DHCPHCLIPATHOGRAPHY',
		MethodName: 'GetMedWardRecordPrint',
		PHCPRid: medWardID,
		adm: EpisodeID
	},
	function(retJson){
		PRINTCOM.XML({
			printBy: 'lodop',
			XMLTemplate: 'PHACPWMedward',
			data: retJson
		});
	})
	
}

/*
* @creator: Huxt 2019-11-26
* @desc: 新入院患者 药学查房记录打印
*/
function print_NewInPatPhaWardInfo(PhawardNewID){	
	if(PhawardNewID==""){
		alert("药学查房ID为空,请重试！");
		return;
	}
	PRINTCOM.jsRunServer(
	{
		ClassName: 'web.DHCSTPHCMWARDROUND',
		MethodName: 'GetWardRoundPrint',
		wardRoundID: PhawardNewID
		
	},
	function(retJson){
		//第一页
	    PRINTCOM.XML({
		XMLTemplate: 'PHACPWPhaWardNew1',
		data:retJson
		});
		//第二页
		PRINTCOM.XML({
		XMLTemplate: 'PHACPWPhaWardNew2',
		data:retJson
		});
	})
}

/*
* @creator: Huxt 2019-11-26
* @desc: 在院患者 药学查房记录打印
*/
function print_InPatPhaWardInfo(PhawardID){	
	if(PhawardID==""){
		alert("药学查房ID为空,请重试！");
		return;
	}
	PRINTCOM.jsRunServer(
	{
		ClassName: 'web.DHCSTPHCMWARDROUND',
		MethodName: 'GetWardRoundPrint',
		wardRoundID: PhawardID
	},
	function(retJson){
		PRINTCOM.XML({
			printBy: 'lodop',
			XMLTemplate: 'PHACPWPhaWardIn',
			data: retJson
		});
	})
}

/*
* @creator: Huxt 2019-11-26
* @desc: 出院患者 药学查房记录打印
*/
function print_OutPatPhaWardInfo(PhawardOutID){
	if(PhawardOutID == ""){
		alert("药学查房ID为空,请重试！");
		return;
	}
	PRINTCOM.jsRunServer(
	{
		ClassName: 'web.DHCSTPHCMWARDROUND',
		MethodName: 'GetWardRoundPrint',
		wardRoundID: PhawardOutID
	},
	function(retJson){
		PRINTCOM.XML({
			printBy: 'lodop',
			XMLTemplate: 'PHACPWPhaWardOut',
			data: retJson
		});
	})
}

/*
* @creator: Huxt 2019-11-26
* @desc: 新入院患者 用药教育打印
*/
function print_medEducationNew(EpisodeID){
	PRINTCOM.jsRunServer(
	{
		ClassName: 'web.DHCPHMEDEDUCATION',
		MethodName: 'GetMedEduNewPrint',
		adm: EpisodeID,
		curStatus: 'New'
	},
	function(retJson){
		PRINTCOM.XML({
			printBy: 'lodop',
			XMLTemplate: 'PHACPWMedEduNew',
			data: retJson
		});
	})
}

/*
* @creator: Huxt 2019-11-26
* @desc: 在院患者 用药教育打印
*/
function print_medEducationIN(medEduID){	
	if(medEduID == ""){
		alert("用药教育ID为空,请重试！");
		return;
	}
	PRINTCOM.jsRunServer(
	{
		ClassName: 'web.DHCPHMEDEDUCATION',
		MethodName: 'GetMedEduPrint',
		medEduID: medEduID
	},
	function(retJson){
		PRINTCOM.XML({
			printBy: 'lodop',
			XMLTemplate: 'PHACPWMedEduIn',
			data: retJson
		});
	})
}

/*
* @creator: Huxt 2019-11-26
* @desc: 出院患者 用药教育打印
*/
function print_medEducation(medEduID){
	if(medEduID==""){
		alert("用药教育ID为空,请重试！");
		return;
	}
	PRINTCOM.jsRunServer(
	{
		ClassName: 'web.DHCPHMEDEDUCATION',
		MethodName: 'GetMedEduPrint',
		medEduID: medEduID
	},
	function(retJson){
		PRINTCOM.XML({
			printBy: 'lodop',
			XMLTemplate: 'PHACPWMedEduOut',
			data: retJson
		});
	})
}

PRINTCOM.jsRunServer = function(_options, successFn, errorFn){
	var p_URL = "websys.Broker.cls"
	if ("undefined"!==typeof(websys_getMWToken)){
			p_URL += "?MWToken="+websys_getMWToken()
		}
	$.ajax({
		url:p_URL ,
		type: "post",
		async: false,
		dataType: "json",
		data: _options,
		success: function(jsonData){
			successFn(jsonData);
		},
		error: function(XMLHR){
			errorFn(XMLHR);
		}
    });
}
