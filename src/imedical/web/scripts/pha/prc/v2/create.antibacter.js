/**
 * ����:	 ��������-����ҩר�����
 * ��д��:	 dinghongying
 * ��д����: 2019-05-10
 */
PHA_COM.App.Csp = "pha.prc.v2.create.antibacter";
PHA_COM.App.Name = "PRC.Create.Antibacter";
PHA_COM.App.Load = "";
var logonLocId = session['LOGON.CTLOCID'];
var logonUserId = session['LOGON.USERID'];
$(function () {
	InitDict();
	InitEvents();
	InitSetDefVal();
});

// �ֵ�
function InitDict() {
	// ��ʼ��-����
	PHA.DateBox("conStartDate", {});
	PHA.DateBox("conEndDate", {});
	// ��ʼ��-��ѡ������
	PHA.ComboBox("conMultiAntDrugLevel", {
		multiple: true,
		rowStyle: 'checkbox', //��ʾ�ɹ�ѡ����ʽ,��Ҫ��ѡ���ע��
		width:156,
		url: PRC_STORE.PCNTSAntiLevel()
	});
	ImportHandler();
}

// �¼�
function InitEvents() {
	$("#btnQuery").on("click", ComfirmQuery);
	$("#btnClean").on("click", ComfirmClear);
	$("#btnImport").on("click", ImportHandler);
	$("#btnSave").on("click", ComfirmSave);
	$("#btnDownLoad").on("click", DownLoadModel);
}

/// ������Ϣ��ʼ��
function InitSetDefVal() {
	//��������
	$.cm({
		ClassName: "PHA.PRC.Com.Util",
		MethodName: "GetAppProp",
		UserId: logonUserId ,
		LocId: logonLocId ,
		SsaCode: "PRC.COMMON"
	}, function (jsonColData) {
		$("#conStartDate").datebox("setValue", jsonColData.CreateStartDate);
		$("#conEndDate").datebox("setValue", jsonColData.CreateEndDate);
	});

}


function ImportHandler() {
	$("#conFileBox").filebox({
		prompt: '��ѡ���ļ�...',
		buttonText: 'ѡ��',
		width: 250,
		accept: 'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
	})
	$("#btnFileBox").on("click", function(){
		var filelist = $('#conFileBox').filebox("files");
		if (filelist.length == 0) {
			//alert("����ѡ���ļ�")
			PHA.Alert('��ʾ', "����ѡ���ļ���", 'warning');
			return
		}
		var file = filelist[0];
		var importData="";
		PHA_COM.ReadExcel(file,function(xlsData){
			var dataLen = xlsData.length ;
			//alert(JSON.stringify(xlsData))
			//var JSONData = JSON.stringify(xlsData) ;
			for (var num=0;num<dataLen;num++){
				var sData = xlsData[num] ;
				var prescno = sData['prescno'] ;
				if ((prescno !="")&&(prescno!=null)&&(prescno!=undefined)){
					importData=(importData=="")?prescno:importData+"^"+prescno ;
				}
			}
			if ((importData=="")||(importData==null)||(importData==undefined)){
				PHA.Alert('��ʾ', "û�л�ȡ����Ҫ����Ĵ�����Ϣ����ע��Excelģ���ʽ�Ƿ���ȷ��", 'warning');
				return ;
			}
			var importRet = tkMakeServerCall("PHA.PRC.Create.Antibacter","ImportCommentData",importData,logonLocId,logonUserId)
			var RetArr = importRet.split("^");
			var RetSucc = RetArr[0];
			var RetVal = RetArr[1];
			if (RetSucc < 0) {
				PHA.Alert('��ʾ', "����ʧ�ܣ�������Ϣ��"+RetVal, 'warning');
			} else {				
				var msgInfo = "��ȡ�ɹ�!";
				PHA.Alert('��ʾ', msgInfo, 'success');
				$('#importConComNo').val(RetVal);
				
			}
		})
		
	});
}

function ComfirmQuery(){
	var comInfo = "��ȷ��ͳ�ƴ�����?"
	PHA.Confirm("��ѯ��ʾ", comInfo, function () {
		Query();
	})
}

function Query(){
	if (CheckBeforeQuery() < 0) {
            return;
        }
	$('#conPresNum').val('');
	var queryParStr = GetQueryParStr() ;
	var saveParStr = GetSaveParStr() ;
	PHA.Loading("Show") 
	var pid = tkMakeServerCall("PHA.PRC.Create.Antibacter", "JobGetAntiPrescDataNum", queryParStr, saveParStr, logonLocId);
	// ����̨,5sһ��
	var jobInterval = setInterval(function() {
		var jobRet = tkMakeServerCall("PHA.PRC.Com.Util", "JobRecieve", pid);
		if (jobRet != "") {
			clearInterval(jobInterval);
			PHA.Loading("Hide")
			var jobRetArr = jobRet.split("^");
			var jobRetSucc = jobRetArr[0];
			var jobRetVal = jobRetArr[1];
			if (jobRetSucc < 0) {
				PHA.Alert('��ʾ', "��ѯʧ�ܣ�������룺"+jobRetVal, 'warning');
			} else {
				if (jobRetVal == 0) {
					var msgInfo = "û�з��������Ĵ���,�������ѯ����������!";
					PHA.Alert('��ʾ', msgInfo, 'warning');
				} else {
					$('#conPresNum').val(jobRetVal);
				}
			}
		}
	},5000);
	
}

function ComfirmClear(){
	var comInfo = "��ȷ��Ҫ�����?"
	PHA.Confirm("�����ʾ", comInfo, function () {
		Clear();
	})
}

function Clear(){
	$('#conPresNum').val('');
	$("#conMultiAntDrugLevel").combobox("setValue",'');	
	$('#conDocCent').val('');
	$('#conPresCent').val('');
	$('#chkAllFlag').checkbox("uncheck",true) ;		
	$('#conComNo').val('');
	
	$('#conFileBox').filebox('clear');
	$('#importConComNo').val('');
	InitSetDefVal();
	return ;	
}


function ComfirmSave(){
	var comInfo = "ȷ��Ҫ���ɿ���ҩ������������ ?"
	PHA.Confirm("ȷ����ʾ", comInfo, function () {
		Save();
	})
	
}

function Save(){
	if (CheckBeforeSave() < 0) {
            return;
        }
	var queryParStr = GetQueryParStr() ;
	var saveParStr = GetSaveParStr() ;
	$('#conComNo').val('');
	PHA.Loading("Show") 
	var pid = tkMakeServerCall("PHA.PRC.Create.Antibacter", "JobSaveAntiCommentData", queryParStr, saveParStr, logonLocId, logonUserId);
	// ����̨,5sһ��
	var jobInterval = setInterval(function() {
		var jobRet = tkMakeServerCall("PHA.PRC.Com.Util", "JobRecieve", pid);
		if (jobRet != "") {
			clearInterval(jobInterval);
			PHA.Loading("Hide")
			var jobRetArr = jobRet.split("^");
			var jobRetSucc = jobRetArr[0];
			var jobRetVal = jobRetArr[1];
			if (jobRetSucc < 0) {
				PHA.Alert('��ʾ', "��ѯʧ�ܣ�������룺"+jobRetVal, 'warning');
			} else {
				if (jobRetVal == 0) {
					var msgInfo = "û�з��������Ĵ���,�������ѯ����������!";
					PHA.Alert('��ʾ', msgInfo, 'warning');
				} else {
					var msgInfo = "��ȡ�ɹ�!";
					PHA.Alert('��ʾ', msgInfo, 'success');
					$('#conComNo').val(jobRetVal);
				}
			}
		}
	},5000);
	
	
}

//���ص���ģ��
function DownLoadModel(){
	window.open("../scripts/pha/prc/v2/���ﴦ����������ģ��.xlsx", "_blank");	
}

function GetQueryParStr(){
	var startDate = $("#conStartDate").datebox('getValue')||'';
	var endDate = $("#conEndDate").datebox('getValue')||'';	
	var antiLevelStr = $("#conMultiAntDrugLevel").combobox('getValues')||'';		//����ҩ�Ｖ��
	var docCent = $.trim($("#conDocCent").val())||''; 
	var prescNum = $.trim($("#conPresCent").val())||''; 
	var allFlag = ""			//����ҩ���־
	if ($("#chkAllFlag").is(':checked')){
		allFlag = "Y"	
	}
	else{
		allFlag = "N"		
	}
	
	var parstr = startDate +"^"+ endDate +"^"+ docCent +"^"+ prescNum +"^"+ antiLevelStr 
	var parstr = parstr +"^"+ allFlag
	
	return parstr
	
}

function GetSaveParStr(){
	var wayCode = "K"		//������ʽ����	
	var saveparstr = wayCode
	
	return saveparstr

}

function CheckBeforeQuery() {
	var docCent = $.trim($("#conDocCent").val())||'';
	if (docCent == "") {
		PHA.Alert('��ʾ', "ҽ������Ϊ���������Ϊ��!", 'warning');
		return -1;
	}
	if (!(docCent > 0) && (docCent !== "")) {
		PHA.Alert('��ʾ', "ҽ��������д����ȷ!", 'warning');
		return -1;
	}
	var prescNum = $.trim($("#conPresCent").val())||''; 
	if (prescNum == "") {
		PHA.Alert('��ʾ', "��������Ϊ���������Ϊ��!", 'warning');
		return -1;
	}	
	if ((!(prescNum > 0)) && (prescNum !== "")) {
		PHA.Alert('��ʾ', "����������д����ȷ!", 'warning');
		return -1;
	}
	return 0 ;
}

function CheckBeforeSave() {
	if (CheckBeforeQuery() < 0) {
		return -99;
    }
	var maxnum = $.trim($("#conPresNum").val())||'';
	if (maxnum == "") {
		PHA.Alert('��ʾ', "����ͳ�ƴ�������!", 'warning');
		return -11;
	}
	if (maxnum == 0) {
		PHA.Alert('��ʾ', "��������Ϊ0,û�пɳ�ȡ�Ĵ���,����ͳ�ƴ�������!", 'warning');
		return -12;
	}
	return 0;
	
}

