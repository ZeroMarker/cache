/**
 * ����:	 ��������-��ҩר�����
 * ��д��:	 MaYuqiang
 * ��д����: 2019-07-10
 */
PHA_COM.App.Csp = "pha.prc.v2.create.general.herb.csp";
PHA_COM.App.Name = "PRC.Create.General.Herb";
PHA_COM.App.Load = "";
var logonLocId = session['LOGON.CTLOCID'];
var logonUserId = session['LOGON.USERID'];
var maxcentnum = 0.8; 	//����ȡ�ٷֱ���
var herbCatId = ""	//��ҩҽ�������id
PHA_STORE.ComboTree = function () {
	return {
		url: PHA_STORE.Url + "ClassName=PHA.STORE.Drug&MethodName=GetDHCPHCCatTree"
	}
}
$(function () {
	InitDict();
	InitEvents();
	InitSetDefVal();
});

// �¼�
function InitEvents() {
	$("#btnQuery").on("click", ComfirmQuery);
	$("#btnClean").on("click", ComfirmClear);
	$("#btnSave").on("click", ComfirmSave);
	$("#btnDownLoad").on("click", DownLoadModel);
	$HUI.radio("#chkRandomNum").setValue(true);
	$("#conSpaceQty").on('keypress', function (event){
		if (event.keyCode == "13") {
			CheckTheoryQty() ;	
			GetSpaceQty() ;		
		}
	})
	$("#conSpaceQty").on('focus', function (){
		GetSpaceQty();
	})
	$("#conSpaceQty").on('blur', function (){
		GetSpaceQty();
	})
	
	$("#conSaveTxt").on('keypress', function (event){
		if (event.keyCode == "13") {
			GetSpaceQty() ;			
		}
	})
	$("#conSaveTxt").on('blur', function (){
		GetSpaceQty();
	})

	$("#conSavePercent").on("click",function(){
		$("#conSaveRandomNum").val('')				//	�ı������
		$HUI.radio("#chkPercent").setValue(true);		// ��ѡ��ѡ��
		$HUI.radio("#chkRandomNum").setValue(false);	// ��ѡ�򲻿���
	})
		
	$("#conSaveRandomNum").on("click",function(){
		$("#conSavePercent").val('')						//	�ı������
		$HUI.radio("#chkRandomNum").setValue(true);		// ��ѡ��ѡ��
		$HUI.radio("#chkPercent").setValue(false);		// ��ѡ�򲻿���
	})
}

// �ֵ�
function InitDict() {
	// ��ʼ��-����
	PHA.DateBox("conStartDate", {});
	PHA.DateBox("conEndDate", {});
	// ��ʼ��-��ѡ������
	PHA.ComboBox("conMultiDocLoc", {
		multiple: true,
		rowStyle: 'checkbox', //��ʾ�ɹ�ѡ����ʽ,��Ҫ��ѡ���ע��
		url: PHA_STORE.DocLoc().url
	});
	PHA.ComboBox("conMultiInstruc", {
		multiple: true,
		rowStyle: 'checkbox', //��ʾ�ɹ�ѡ����ʽ,��Ҫ��ѡ���ע��
		url: PHA_STORE.PHCInstruc().url
	});
	PHA.ComboBox("conMultiAntDrugLevel", {
		multiple: true,
		rowStyle: 'checkbox', 		//��ʾ�ɹ�ѡ����ʽ,��Ҫ��ѡ���ע��
		url: PRC_STORE.PCNTSAntiLevel(),
		
	});
	PHA.ComboBox("conMultiAdmFee", {
		multiple: true,
		rowStyle: 'checkbox', 		//��ʾ�ɹ�ѡ����ʽ,��Ҫ��ѡ���ע��
		url: PHA_STORE.PACAdmReason().url
	});
	PHA.ComboBox("conMultiPosion", {
		multiple: true,
		rowStyle: 'checkbox', //��ʾ�ɹ�ѡ����ʽ,��Ҫ��ѡ���ע��
		url: PRC_STORE.PCNTSPoison(),
		width:160
	});
	PHA.ComboBox("conMultiForm", {
		multiple: true,
		rowStyle: 'checkbox', //��ʾ�ɹ�ѡ����ʽ,��Ҫ��ѡ���ע��
		url: PHA_STORE.PHCForm().url
	});
	var opts=$.extend({},{width:160},PHA_STORE.ArcItmMast());
	PHA.LookUp("conMultiArcDesc", opts);
	
	PHA.ComboBox("conMultiPhaLoc", {
		multiple: true,
		rowStyle: 'checkbox', //��ʾ�ɹ�ѡ����ʽ,��Ҫ��ѡ���ע��
		url: PHA_STORE.Pharmacy("").url
	});
	// ��ʼ��-������
	PHA.ComboBox("conDoctor", {
		url: PHA_STORE.Doctor().url,
		width:160
	});
	PHA.ComboBox("conDuration", {
		url: PHA_STORE.PHCDuration().url
	});	
	PHA.ComboBox("conMultiHerbForm", {
		multiple: true,
		rowStyle: 'checkbox', //��ʾ�ɹ�ѡ����ʽ,��Ҫ��ѡ���ע��
		url: PRC_STORE.HerbForm().url
	});
	PHA.ComboBox("conAdmType", {
		data: [{
			RowId: "1",
			Description: "����"
		}, {
			RowId: "2",
			Description: "����"
		}, {
			RowId: "3",
			Description: "סԺ"
		}, {
			RowId: "4",
			Description: "ȫ��"
		}],
		panelHeight: "auto"
	});
	
	PHA.ComboBox("conSaveType", {
		data: [{
			RowId: "Random",
			Description: "�����"
		}, {
			RowId: "Percent",
			Description: "�ٷֱ�"
		}],
		panelHeight: "auto",
		width:85
	});
	
	// ��ʼ��-������
	PHA.ComboTree("conDrugCatTree", {
		panelWidth:300,
		width:160,
		editable:true,	
		delay:1000,
		lines: true,
		autoNodeHeight: true,
		url: PHA_STORE.ComboTree().url,
		keyHandler:{
			query:function(q){
				// todo ǰ̨�ж��Ƿ���Ҫ��ʾ
				var t = $(this).combotree('tree');  
				var nodes = t.tree('getChildren');  
				for(var i=0; i<nodes.length; i++){  
					var node = nodes[i];  
					if (node.text.indexOf(q) >= 0){  
						$(node.target).show();  
					} else {  
						$(node.target).hide();  
					}  
				}  
				
			}
		}
				
	});
	PHA.TriggerBox("genePHCCat", {
		width: 160,
		handler: function (data) {
			PHA_UX.DHCPHCCat("genePHCCat", {}, function (data) {
				$("#genePHCCat").triggerbox("setValue", data.phcCatDescAll);
				$("#genePHCCat").triggerbox("setValueId", data.phcCatId);
			});
		}
	});
	ImportHandler();	
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

	var herbCatId = tkMakeServerCall("PHA.PRC.Com.Util","GetHerbCatId")
	$("#conSaveType").combobox("setValue", "Random");
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
			var importRet = tkMakeServerCall("PHA.PRC.Create.IPHerb","ImportCommentData",importData,logonLocId,logonUserId)
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

//���ص���ģ��
function DownLoadModel(){
	window.open("../scripts/pha/prc/v2/��ҩ������������ģ��.xlsx", "_blank");	
}

function ComfirmQuery(){
	var comInfo = "��ȷ��ͳ�Ʋ�ҩ������?"
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
	var pid = tkMakeServerCall("PHA.PRC.Create.IPHerb", "JobGetIPHerbPrescNum", queryParStr, saveParStr, logonLocId);
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
	$("#conMultiDocLoc").combobox("setValue",'');
	$("#conAdmType").combobox("setValue",'');
	$("#conMultiPhaLoc").combobox("setValue",'');		
	$("#conPresAmt").val('');					
	$("#conMultiInstruc").combobox("setValue",'');	
	$("#conMultiAdmFee").combobox("setValue",'');	
	$("#conDuration").combobox("setValue",'');				
	$("#conAgeMin").val(''); 					
	$("#conMultiPosion").combobox("setValue",'');		
	//$("#conDrugCatTree").combobox("setValues",'');		
	$("#conMultiArcDesc").val('');			
	$("#conMultiForm").combobox("setValue",'');			
	$("#conAgeMax").val(''); 					
	$("#conDoctor").combobox("setValue",'');			
	$("#conMultiAntDrugLevel").combobox("setValue",'');		
	$("#conMultiHerbForm").combobox("setValue",'');
	//$('#chkBasicFlag').iCheck('uncheck') ;
	$('#chkBasicFlag').checkbox('uncheck',true) ;
	
	$('#conComNo').val('');
	$("#conSaveTxt").val('');	
	$("#conSpaceQty").val('');	
	$("#conWriteQty").val('');
	$("#conASpaceQty").val('');
	$("#conTheoryQty").val('');
	
	$('#conFileBox').filebox('clear');
	$('#importConComNo').val('');
	InitSetDefVal();
	return ;	
}

function ComfirmSave(){
	var comInfo = "��ȷ��Ҫ���ɲ�ҩר����������� ?"
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
	var pid = tkMakeServerCall("PHA.PRC.Create.IPHerb", "JobSaveIPHerbComData", queryParStr, saveParStr, logonLocId, logonUserId);
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
				PHA.Alert('��ʾ', "��ȡʧ�ܣ�������룺"+jobRetVal, 'warning');
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

function GetQueryParStr(){
	var startDate = $("#conStartDate").datebox('getValue')||'';
	var endDate = $("#conEndDate").datebox('getValue')||'';
	var docLocStr = $("#conMultiDocLoc").combobox('getValues')||'';		//ҽ������
	var admType = $("#conAdmType").combobox('getValue')||'';			//��������
	var phaLocStr = $("#conMultiPhaLoc").combobox('getValues')||'';		//ҩ������
	var prescAmt = $.trim($("#conPresAmt").val())||'';					//����������
	var prescType = herbCatId ;												//��������(Ĭ��Ϊ��ҩ)
	var billTypeStr = $("#conMultiAdmFee").combobox('getValues')||'';	//�ѱ�
	var duraId = $("#conDuration").combobox('getValue')||'';			//�Ƴ�	
	var ageMin = $.trim($("#conAgeMin").val())||''; 					//��������
	var poisonStr = $("#conMultiPosion").combobox('getValues')||'';		//���Ʒ���
	//var stkCatId = $("#conDrugCatTree").combobox('getValue')||'';		//ҩѧ����
	var stkCatId = $("#genePHCCat").triggerbox("getValueId")||'' ;
	var arcimId = $("#conMultiArcDesc").lookup('getValue')||'';			//ҽ������
	var formStr = $("#conMultiForm").combobox('getValues')||'';			//����
	var ageMax = $.trim($("#conAgeMax").val())||''; 					//��������
	var doctorId = $("#conDoctor").combobox('getValue')||'';			//ҽ��
	var antiLevelStr = $("#conMultiAntDrugLevel").combobox('getValues')||'';		//����ҩ�Ｖ��
	var instrStr = $("#conMultiInstruc").combobox('getValues')||'';		//�÷�
	var herbFormCodeStr = $("#conMultiHerbForm").combobox('getValues')||'';			//��ҩ��������
	var basicFlag = ""			//����ҩ���־
	if ($("#chkBasicFlag").is(':checked')){
		basicFlag = "Y"	
	}
	else{
		basicFlag = "N"		
	}
	
	var parstr = startDate +"^"+ endDate +"^"+ docLocStr +"^"+ admType +"^"+ phaLocStr
	var parstr = parstr +"^"+ prescAmt +"^"+ prescType +"^"+ billTypeStr +"^"+ duraId +"^"+ ageMin
	var parstr = parstr +"^"+ poisonStr +"^"+ stkCatId +"^"+ arcimId +"^"+ formStr +"^"+ ageMax
	var parstr = parstr +"^"+ doctorId +"^"+ antiLevelStr +"^"+ basicFlag +"^"+ instrStr +"^"+ herbFormCodeStr
	
	return parstr
	
}

function GetSaveParStr(){
	var wayCode = "PC"		//������ʽ����
	//var savenum = $.trim($("#conSaveText").val())||'';
	var rnum="",pcent=""
	var savetype = $("#conSaveType").combobox('getValue')||'';
	var conTxt = $.trim($("#conSaveTxt").val())||'';	
    if (savetype=="Random"){
		var rnum = conTxt;	
	}
	else{
		var pcent = conTxt;	
	}
	var spaceqty = $.trim($("#conSpaceQty").val())||'';		//�����
	
	var saveparstr = wayCode +"^"+ rnum +"^"+ pcent +"^"+ spaceqty	
	
	return saveparstr
	
}

function CheckBeforeQuery() {
	var prescAmt = $.trim($("#conPresAmt").val())||'';
	if (!(prescAmt > 0) && (prescAmt != 0) && (prescAmt !== "")) {
		PHA.Alert('��ʾ', "������������д����ȷ!", 'warning');
		return -1;
	}
	var ageMin = $.trim($("#conAgeMin").val())||''; 	
	if ((!(ageMin > 0)) && (ageMin != 0) && (ageMin !== "")) {
		PHA.Alert('��ʾ', "��������������д����ȷ!", 'warning');
		return -1;
	}
	var ageMax = $.trim($("#conAgeMax").val())||''; 
	if ((!(ageMax > 0)) && (ageMax != 0) && (ageMax !== "")) {
		PHA.Alert('��ʾ', "��������������д����ȷ!", 'warning');
		return -1;
	}
}

function CheckBeforeSave() {
	if (CheckBeforeQuery() < 0) {
		return;
    }
	var maxnum = $.trim($("#conPresNum").val())||'';
	if (maxnum == "") {
		PHA.Alert('��ʾ', "����ͳ�ƴ�������!", 'warning');
		return -1;
	}
	if (maxnum == 0) {
		PHA.Alert('��ʾ', "��������Ϊ0,û�пɳ�ȡ�Ĵ���,����ͳ�ƴ�������!", 'warning');
		return -1;
	}
	var rnum="",pcent=""
	var savetype = $("#conSaveType").combobox('getValue')||'';
	var conTxt = $.trim($("#conSaveTxt").val())||'';	
    if (savetype=="Random"){
		var rnum = conTxt;	
	}
	else{
		var pcent = conTxt;	
	}	
	if ((rnum=="")&&(pcent=="")){
		PHA.Alert('��ʾ', "������д��������߰ٷֱ�!", 'warning');
		return -1;		
	}
	if ((!(rnum>0))&&(!(pcent>0))){
		PHA.Alert('��ʾ', "��д����������߰ٷֱȸ�ʽ����ȷ�����޸ĺ�����!", 'warning');
		return -1;		
	}
	var rnumstr = rnum.split(".")
	if (rnumstr[0] !== rnum){
		PHA.Alert('��ʾ', "��д�����������ΪС�������޸ĺ�����!", 'warning');
		return -1;		
	}
	if (parseFloat(rnum) > parseFloat((maxnum * maxcentnum))) {
		PHA.Alert('��ʾ', "����������ܴ�������"+ maxcentnum * 100 + '%,������������!', 'warning');
		return -1;
	}
	if (!(pcent > 0)&&(pcent!=="")) {
		PHA.Alert('��ʾ', "�ٷֱȸ�ʽ����ȷ!", 'warning');
        return -1;
    }
	if (parseFloat(pcent) > (maxcentnum * 100)) {
		PHA.Alert('��ʾ', "�ٷֱȲ��ܴ���"+ maxcentnum * 100 + '%,��������ٷֱ�!', 'warning');
		return -1;
	}
	if (((parseFloat(pcent) * parseFloat(maxnum) / 100) < 1)&&(pcent!=="")) {
		PHA.Alert('��ʾ', '���ٷֱȳ�ȡ�����С��1,���ܳ�ȡ!', 'warning');
        return -1;
    }
	//�����
	var spaceqtynum = $.trim($("#conSpaceQty").val())||'';
	//��������
	var spaceAqtynum = $.trim($("#conASpaceQty").val())||'';
	if ((!(spaceqtynum > 0)) && (spaceqtynum != 0) && (spaceqtynum != "")) {
		PHA.Alert('��ʾ', '�������д����ȷ!', 'warning');
		return -1;
	}
	if ((parseInt(spaceqtynum) != spaceqtynum) && (spaceqtynum != "")) {
		PHA.Alert('��ʾ', '�����ֻ��������!', 'warning');
		return -1;
	}
	var spaceqtynum=parseInt(spaceqtynum)
	var spaceAqtynum=parseInt(spaceAqtynum)
	if((spaceqtynum>0)&&(spaceqtynum>spaceAqtynum)){
		PHA.Alert('��ʾ', '��������ڽ�������,���ܳ�ȡ!��ο���������,���¸���¼��������', 'warning');
		return -1;
	}
	return 0;
	
}


function CheckTheoryQty()
{
	if (CheckBeforeSave() < 0) {
        return false;
    }
}

function GetSpaceQty()
{
	var spaceQty = $.trim($("#conSpaceQty").val())||'';
	var maxnum = $.trim($("#conPresNum").val())||'';		//ͳ�ƴ�������
	var rnum="",pcent=""
	var savetype = $("#conSaveType").combobox('getValue')||'';
	var conTxt = $.trim($("#conSaveTxt").val())||'';	
    if (savetype=="Random"){
		var rnum = conTxt;	
	}
	else{
		var pcent = conTxt;	
	}
	if (rnum != "") {
		var writeqty = rnum;
	} else {
		var rnum = parseInt(maxnum * pcent / 100);
		var writeqty = rnum;
	}
	if (writeqty==0){
		$("#conWriteQty").val('') ;
	}
	else{
		$("#conWriteQty").val(writeqty) ;
	}
	if ((rnum != 0)&&(rnum != "")) {
		$("#conASpaceQty").val(Math.floor(maxnum / rnum));
	} else {
		$("#conASpaceQty").val('');
	}
	if ((spaceQty == 0)||(spaceQty == "")) {
		$("#conTheoryQty").val('');
	} else {
		$("#conTheoryQty").val(parseInt(writeqty * spaceQty));
	}

}




