/**
* @creator: Huxt 2019-11-26
* @desc: �ٴ�ҩѧ��ӡ����js
* @js: scripts/dhcpha/clinical/cpwprintcom.js
*/

/*
* @creator: Huxt 2019-11-26
* @desc: ҽѧ�״β鷿��¼��ӡ
*/
function print_FirstMedRoundInf(medWardID){
	if(medWardID==""){
		alert("ҽѧ�鷿IDΪ��,�����ԣ�");
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
* @desc: ҽѧ�ճ��鷿��¼��ӡ
*/
function print_MedRoundInf(medWardID){
	if(medWardID==""){
		alert("ҽѧ�鷿IDΪ��,��ѡ��鷿��¼�����ԣ�");
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
* @desc: ����Ժ���� ҩѧ�鷿��¼��ӡ
*/
function print_NewInPatPhaWardInfo(PhawardNewID){	
	if(PhawardNewID==""){
		alert("ҩѧ�鷿IDΪ��,�����ԣ�");
		return;
	}
	PRINTCOM.jsRunServer(
	{
		ClassName: 'web.DHCSTPHCMWARDROUND',
		MethodName: 'GetWardRoundPrint',
		wardRoundID: PhawardNewID
		
	},
	function(retJson){
		//��һҳ
	    PRINTCOM.XML({
		XMLTemplate: 'PHACPWPhaWardNew1',
		data:retJson
		});
		//�ڶ�ҳ
		PRINTCOM.XML({
		XMLTemplate: 'PHACPWPhaWardNew2',
		data:retJson
		});
	})
}

/*
* @creator: Huxt 2019-11-26
* @desc: ��Ժ���� ҩѧ�鷿��¼��ӡ
*/
function print_InPatPhaWardInfo(PhawardID){	
	if(PhawardID==""){
		alert("ҩѧ�鷿IDΪ��,�����ԣ�");
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
* @desc: ��Ժ���� ҩѧ�鷿��¼��ӡ
*/
function print_OutPatPhaWardInfo(PhawardOutID){
	if(PhawardOutID == ""){
		alert("ҩѧ�鷿IDΪ��,�����ԣ�");
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
* @desc: ����Ժ���� ��ҩ������ӡ
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
* @desc: ��Ժ���� ��ҩ������ӡ
*/
function print_medEducationIN(medEduID){	
	if(medEduID == ""){
		alert("��ҩ����IDΪ��,�����ԣ�");
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
* @desc: ��Ժ���� ��ҩ������ӡ
*/
function print_medEducation(medEduID){
	if(medEduID==""){
		alert("��ҩ����IDΪ��,�����ԣ�");
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
