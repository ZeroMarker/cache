/**
 * sae.report.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-02
 * 
 * 
 */
var PageLogicObj = {
	j_Global:{
		DefaultDate:"",
		AEUserPost:""
	},
	inGdNoteArrayObj:[],
	PDiseaseGrid:"",
	BaseParamObj:{
		AEStatus:"N",
		ID:ServerObj.MID,
		AEDeadDate:"",
		AEDrugCategoryOther:"",
		AESituationOther:"",
		AEHasSequela:"",
		AEUser:session['LOGON.USERID'],
		AEAddLoc:session['LOGON.CTLOCID'],
		AEUserPost: session['LOGON.GROUPDESC']
	},
	DiseaseObj:[]	//PageLogicObj.DiseaseObj
}

$(function() {
	Init();
	InitEvent();
	//PageHandle();
})


function Init(){
	InitDefault();
	InitData();
	InitGrid();
	InitSee();
}

function InitEvent () {
	$("#Save").click(SaveHandler)
	//$("#Reset").click(Reset_Handle)
	//$(document.body).bind("keydown",BodykeydownHandler)
}
function PageHandle() {
	
}

function InitSee() {
	if (ServerObj.See==1) {
		DisableText();
		DisableButton();
		DisableRadio();
		DisableCheckbox();
		DisableDatebox();
	}
}
function DisableText() {
	$(".textbox").attr("disabled","disabled");
}

function DisableButton() {
	$("#Save").linkbutton('disable');
}

function DisableRadio() {
	$(":radio").radio("disable");
}
function DisableCheckbox() {
	$(":checkbox").checkbox("disable");
}

function DisableDatebox() {
	$(".hisui-datebox").datebox("disable");
}

function InitData() {
	if (ServerObj.MID!="") {
		$cm({
			ClassName:"DHCDoc.GCP.SAE.BS",
			MethodName:"InitData",
			MID: ServerObj.MID
		},function(MObj){
			SetRadio("AEReportType","AEReportType_TD",MObj.AEReportType)
			SetDatebox("AEReportDate",MObj.AEReportDate)
			SetText("AEISO",MObj.AEISO)
			SetText("AECode",MObj.AECode)
			SetText("AEMajorName",MObj.AEMajorName)
			SetText("AEMajorTel",MObj.AEMajorTel)
			//SetNumberbox("AEMajorTel",MObj.AEMajorTel)
			SetText("AEFilCompanyName",MObj.AEFilCompanyName)
			SetText("AEFilCompanyTel",MObj.AEFilCompanyTel)
			//SetNumberbox("AEFilCompanyTel",MObj.AEFilCompanyTel)
			SetText("AEDrugNameZN",MObj.AEDrugNameZN)
			SetText("AEDrugNameEN",MObj.AEDrugNameEN)
			SetText("AERegisterCategory",MObj.AERegisterCategory)
			SetText("AEDrugForm",MObj.AEDrugForm)
			SetText("AEDrugCategoryOther",MObj.AEDrugCategoryOther)
			SetRadio("AEDrugCategory","AEDrugCategory_TD",MObj.AEDrugCategory)
			SetRadio("AEStage","AEStage_TD",MObj.AEStage)
			SetRadio("AEStudyCategory","AEStudyCategory_TD",MObj.AEStudyCategory)
			SetText("AEIndication",MObj.AEIndication)
			SetText("AEPatientSpell",MObj.AEPatientSpell)
			SetText("AEHeight",MObj.AEHeight)
			SetText("AEWeight",MObj.AEWeight)
			//SetNumberbox("AEHeight",MObj.AEHeight)
			//SetNumberbox("AEWeight",MObj.AEWeight)
			SetRadio("AESex","AESex_TD",MObj.AESex)
			SetDatebox("AEBirthday",MObj.AEBirthday)
			SetRadio("AEHasTreat","AEHasTreat_TD",MObj.AEHasTreat)
			SetText("AEDiagnosis",MObj.AEDiagnosis)
			SetCheckbox("AESituation","",MObj.AESituation)
			SetDatebox("AEDeadDate",MObj.AEDeadDate)
			SetText("AESituationOther",MObj.AESituationOther)
			SetDatebox("AEHappenDate",MObj.AEHappenDate)
			SetDatebox("AEKnowDate",MObj.AEKnowDate)
			SetRadio("AEMeasures","AEMeasures_TD",MObj.AEMeasures)
			SetRadio("AETurnOver","AETurnOver_TD",MObj.AETurnOver)
			SetRadio("AEHasSequela","AETurnOver_TD",MObj.AEHasSequela)
			SetRadio("AERelation","AERelation_TD",MObj.AERelation)
			SetRadio("AEReportZN","AEReportZN_TD",MObj.AEReportZN)
			SetRadio("AEReportEN","AEReportZN_TD",MObj.AEReportEN)
			SetText("AEDetail",MObj.AEDetail)
			SetText("AEUser",MObj.AEUser)
			SetText("AEReportCompany",MObj.AEReportCompany)
			SetText("AEUserPost",MObj.AEUserPost)
			
		});
	}
}

function InitDefault() {
	PageLogicObj.j_Global = $cm({
		ClassName: "DHCDoc.GCP.SAE.BS",
		MethodName: "GetDefaultValue",
		InUser: session['LOGON.USERID'],
		InHsop: session['LOGON.HOSPID']
	},false)
	$("#AEReportDate,#AEBirthday,#AEDeadDate,#AEHappenDate,#AEKnowDate").datebox({
		maxDate:PageLogicObj.j_Global.DefaultDate
	})
	
	if (ServerObj.MID=="") {
		//$("#AEUserPost").val(session['LOGON.GROUPDESC'])
		//$("#AEUser").val(session['LOGON.USERNAME'])
		$("#AEUser").val(PageLogicObj.j_Global.AEUser)
		
		//$("#AEReportCompany").val(session['LOGON.HOSPDESC'])
		$("#AEReportCompany").val(PageLogicObj.j_Global.AEReportCompany)
		
		$("#AEUserPost").val(PageLogicObj.j_Global.AEUserPost)
		SetDatebox("AEReportDate",PageLogicObj.j_Global.DefaultDate)
	} else {
		
	}
}
function InitCombox() {
	PageLogicObj.m_Project = $HUI.combobox("#Project", {
		url:$URL+"?ClassName=web.PilotProject.Extend.Stage&QueryName=QryGCP&InHosp="+ServerObj.InHosp+"&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		//required:true,
		value:ServerObj.PPRowId,
		blurValidValue:true,
		onBeforeLoad:function(param){
			param.inDesc = param["q"];
		}
	});
}

function ResetPara() {
	PageLogicObj.BaseParamObj = {
		AEStatus:"N",
		ID:ServerObj.MID,
		AEDeadDate:"",
		AEDrugCategoryOther:"",
		AESituationOther:"",
		AEHasSequela:"",
		AEUser:session['LOGON.USERID'],
		AEAddLoc:session['LOGON.CTLOCID'],
		AEUserPost: session['LOGON.GROUPDESC']
	}
	
	PageLogicObj.DiseaseObj = []
}

function SaveHandler() {
	ResetPara();
	var AEISO = GetTextValue("AEISO");
	if (AEISO == "") {
		$.messager.alert('��ʾ',"��ҩ�ٴ��о���׼�ĺŲ���Ϊ�գ�","warning",function () {
			SetFocus("AEISO");
		});
		return false;
	}
	var AECode = GetTextValue("AECode");
	if (AECode == "") {
		$.messager.alert('��ʾ',"��Ų���Ϊ�գ�","warning",function () {
			SetFocus("AECode");
		});
		return false;
	}
	var AEReportType = GetRadioValue("AEReportType","AEReportType_TD")
	if (AEReportType == "") {
		$.messager.alert('��ʾ',"�������Ͳ���Ϊ�գ�","warning");
		return false;
	}
	
	var AEReportDate = GetDateValue("AEReportDate")
	if (AEReportDate == "") {
		$.messager.alert('��ʾ',"����ʱ�䲻��Ϊ�գ�","warning");
		return false;
	}
	
	var AEMajorName = GetTextValue("AEMajorName");
	if (AEMajorName == "") {
		$.messager.alert('��ʾ',"רҵ���Ʋ���Ϊ�գ�","warning",function () {
			SetFocus("AEMajorName");
		});
		return false;
	}
	
	var AEMajorTel = GetTextValue("AEMajorTel");
	if (AEMajorTel == "") {
		$.messager.alert('��ʾ',"רҵ���Ƶ绰����Ϊ�գ�","warning",function () {
			SetFocus("AEMajorTel");
		});
		return false;
	} else {
		if (!CheckTelOrMobile(AEMajorTel,"AEMajorTel","רҵ���Ƶ绰")) return false;	
		/*
		if (AEMajorTel.length!="11") {
			$.messager.alert('��ʾ',"������ȷ��רҵ���Ƶ绰(11λ)��","warning",function () {
				SetFocus("AEMajorTel");
			});
			return false;
		}*/
	}
	
	var AEFilCompanyName = GetTextValue("AEFilCompanyName");
	if (AEFilCompanyName == "") {
		$.messager.alert('��ʾ',"�걨��λ���Ʋ���Ϊ�գ�","warning",function () {
			SetFocus("AEFilCompanyName");
		});
		return false;
	}
	
	var AEFilCompanyTel = GetTextValue("AEFilCompanyTel");
	if (AEFilCompanyTel == "") {
		$.messager.alert('��ʾ',"�걨��λ�绰����Ϊ�գ�","warning",function () {
			SetFocus("AEFilCompanyTel");
		});
		return false;
	} else {
		if (!CheckTelOrMobile(AEFilCompanyTel,"AEFilCompanyTel","�걨��λ�绰")) return false;	
		/*
		if (AEFilCompanyTel.length!="11") {
			$.messager.alert('��ʾ',"������ȷ���걨��λ�绰(11λ)��","warning",function () {
				SetFocus("AEFilCompanyTel");
			});
			return false;
		}*/
	}
	
	var AEDrugNameZN = GetTextValue("AEDrugNameZN");
	if (AEDrugNameZN == "") {
		$.messager.alert('��ʾ',"������ҩƷ�����������Ʋ���Ϊ�գ�","warning",function () {
			SetFocus("AEDrugNameZN");
		});
		return false;
	}
	
	var AEDrugNameEN = GetTextValue("AEDrugNameEN");
	if (AEDrugNameEN == "") {
		$.messager.alert('��ʾ',"������ҩƷ����Ӣ�����Ʋ���Ϊ�գ�","warning",function () {
			SetFocus("AEDrugNameEN");
		});
		return false;
	}
	
	var AEDrugCategory = GetRadioValue("AEDrugCategory","AEDrugCategory_TD")
	if (AEDrugCategory == "") {
		$.messager.alert('��ʾ',"ҩƷ���಻��Ϊ�գ�","warning");
		return false;
	}
	
	if (AEDrugCategory == 5) {
		var AEDrugCategoryOther = GetTextValue("AEDrugCategoryOther");
		if (AEDrugCategoryOther == "") {
			$.messager.alert('��ʾ',"ҩƷ����������������Ϊ��","warning",function () {
				SetFocus("AEDrugCategoryOther");
			});
			return false;
		}
	}
	
	
	var AERegisterCategory = GetTextValue("AERegisterCategory");
	if (AERegisterCategory == "") {
		$.messager.alert('��ʾ',"ע����಻��Ϊ�գ�","warning",function () {
			SetFocus("AERegisterCategory");
		});
		return false;
	}
	
	var AEDrugForm = GetTextValue("AEDrugForm");
	if (AEDrugForm == "") {
		$.messager.alert('��ʾ',"���Ͳ���Ϊ�գ�","warning",function () {
			SetFocus("AEDrugForm");
		});
		return false;
	}
	
	var AEStage = GetRadioValue("AEStage","AEStage_TD")
	if (AEStage == "") {
		$.messager.alert('��ʾ',"�ڱ���Ϊ�գ�","warning");
		return false;
	}
	var AEStudyCategory = GetRadioValue("AEStudyCategory","AEStudyCategory_TD")
	if (AEStudyCategory == "") {
		$.messager.alert('��ʾ',"�ٴ��о����಻��Ϊ�գ�","warning");
		return false;
	}
	var AEIndication = GetTextValue("AEIndication");
	if (AEIndication == "") {
		$.messager.alert('��ʾ',"�ٴ�������Ӧ֢����Ϊ�գ�","warning",function () {
			SetFocus("AEIndication");
		});
		return false;
	}
	
	var AEPatientSpell = GetTextValue("AEPatientSpell");
	if (AEPatientSpell == "") {
		$.messager.alert('��ʾ',"����ƴ����д����Ϊ�գ�","warning",function () {
			SetFocus("AEPatientSpell");
		});
		return false;
	}
	var AEBirthday = GetDateValue("AEBirthday");
	if (AEBirthday == "") {
		$.messager.alert('��ʾ',"�������ڲ���Ϊ�գ�","warning",function () {
			SetFocus("AEBirthday");
		});
		return false;
	}
	var AESex = GetRadioValue("AESex","AESex_TD")
	if (AESex == "") {
		$.messager.alert('��ʾ',"�Ա���Ϊ�գ�","warning");
		return false;
	}
	
	var AEHeight = GetTextValue("AEHeight");
	if (AEHeight == "") {
		$.messager.alert('��ʾ',"��߲���Ϊ�գ�","warning",function () {
			SetFocus("AEHeight");
		});
		return false;
	}
	var AEWeight = GetTextValue("AEWeight");
	if (AEWeight == "") {
		$.messager.alert('��ʾ',"���ز���Ϊ�գ�","warning",function () {
			SetFocus("AEWeight");
		});
		return false;
	}
	
	var AEHasTreat = GetRadioValue("AEHasTreat","AEHasTreat_TD")
	if (AEHasTreat == "") {
		$.messager.alert('��ʾ',"�ϲ����������Ʋ���Ϊ�գ�","warning");
		return false;
	}
	
	if (AEHasTreat==1) {
		var HasFillDiease = GetDiseaseObj();
		if (!HasFillDiease) {
			return false;
		}
	}
	var AEDiagnosis = GetTextValue("AEDiagnosis");
	if (AEDiagnosis == "") {
		$.messager.alert('��ʾ',"SAE��ҽѧ����(���)����Ϊ�գ�","warning",function () {
			SetFocus("AEDiagnosis");
		});
		return false;
	}
	
	var AESituation = GetCheckboxValue("AESituation")
	if (AESituation == "") {
		$.messager.alert('��ʾ',"SAE�������Ϊ�գ�","warning");
		return false;
	}
	var AEHasDead = $("#AEHasDead").checkbox("getValue");
	
	if (AEHasDead)  {
		var AEDeadDate = GetDateValue("AEDeadDate")
		if (AEDeadDate == "") {
			$.messager.alert('��ʾ',"����ʱ�䲻��Ϊ�գ�","warning");
			return false;
		}
	}
	var AESituationOT = $("#AESituationOT").checkbox("getValue");
	if (AESituationOT)  {
		var AESituationOther = GetTextValue("AESituationOther");
		if (AESituationOther == "") {
			$.messager.alert('��ʾ',"SAE�����������Ϊ�գ�","warning",function () {
				SetFocus("AESituationOther");
			});
			return false;
		}
	}
	
	var AEHappenDate = GetDateValue("AEHappenDate")
	if (AEHappenDate == "") {
		$.messager.alert('��ʾ',"SAE����ʱ�䲻��Ϊ�գ�","warning");
		return false;
	}
	
	var AEKnowDate = GetDateValue("AEKnowDate")
	if (AEKnowDate == "") {
		$.messager.alert('��ʾ',"�о��߻�֪SAEʱ�䲻��Ϊ�գ�","warning");
		return false;
	}
	
	
	var AEMeasures = GetRadioValue("AEMeasures","AEMeasures_TD")
	if (AEMeasures == "") {
		$.messager.alert('��ʾ',"��������ҩ��ȡ�Ĵ�ʩ����Ϊ�գ�","warning");
		return false;
	}
	
	var AETurnOver = GetRadioValue("AETurnOver","AETurnOver_TD")
	if (AETurnOver == "") {
		$.messager.alert('��ʾ',"SAEת�鲻��Ϊ�գ�","warning");
		return false;
	}
	
	if (AETurnOver==1) {
		var AEHasSequela = GetRadioValue("AEHasSequela","AETurnOver_TD")
		if (AEHasSequela == "") {
			$.messager.alert('��ʾ',"����֢����Ϊ�գ�","warning");
			return false;
		}
	}
	
	var AERelation = GetRadioValue("AERelation","AERelation_TD")
	if (AERelation == "") {
		$.messager.alert('��ʾ',"SAE������ҩ�Ĺ�ϵ����Ϊ�գ�","warning");
		return false;
	}
	
	var AEReportZN = GetRadioValue("AEReportZN","AEReportZN_TD")
	if (AEReportZN == "") {
		$.messager.alert('��ʾ',"SAE����������ڲ���Ϊ�գ�","warning");
		return false;
	}
	
	var AEReportEN = GetRadioValue("AEReportEN","AEReportZN_TD")
	if (AEReportEN == "") {
		$.messager.alert('��ʾ',"SAE����������ⲻ��Ϊ�գ�","warning");
		return false;
	}
	
	
	var AEDetail = GetTextValue("AEDetail");
	if (AEDetail == "") {
		$.messager.alert('��ʾ',"SAE�������������ϸ�������Ϊ�գ�","warning",function () {
			SetFocus("AEDetail");
		});
		return false;
	}
	
	var AEReportCompany = GetTextValue("AEReportCompany");
	if (AEReportCompany == "") {
		$.messager.alert('��ʾ',"���浥λ���Ʋ���Ϊ�գ�","warning",function () {
			SetFocus("AEReportCompany");
		});
		return false;
	}
	
	var AEUserPost = GetTextValue("AEUserPost");
	if (AEUserPost == "") {
		$.messager.alert('��ʾ',"������ְ��/ְ�Ʋ���Ϊ�գ�","warning",function () {
			SetFocus("AEUserPost");
		});
		return false;
	}
	
	var BaseParamJson=JSON.stringify(PageLogicObj.BaseParamObj);
	var DiseaseJson=JSON.stringify(PageLogicObj.DiseaseObj);
	
	$m({
		ClassName:"DHCDoc.GCP.SAE.BS",
		MethodName:"Save",
		BaseParamJson:BaseParamJson,
		DiseaseJson:DiseaseJson
	}, function(result){
		result = result.split("^")
		if (result[0]> 0) {
			$.messager.alert("��ʾ", "����ɹ���", "info", function () {
				websys_showModal("hide");
				websys_showModal('options').CallBackFunc();
				websys_showModal("close");	
			});
		} else {
			$.messager.alert("��ʾ", result , "warning");
			return false;
		}
	});
}

function GetDiseaseObj() {
	var outputGdRows=$('#PDiseaseTab').datagrid('getRows');
	if (outputGdRows.length==0) {
		$.messager.alert('��ʾ',"����д�����ߵ���ҩ�����","warning");
		return false;
	}
	var msg=""
	for (var i=0;i<outputGdRows.length;i++) {
		$('#PDiseaseTab').datagrid('endEdit', i);
		editIndex=undefined;
		var CObj={}
		var PDisease=$.trim(outputGdRows[i]['PDisease']);
		var PDrug=$.trim(outputGdRows[i]['PDrug']);
		var PUseInfo=$.trim(outputGdRows[i]['PUseInfo']);
		if (PDisease=="") {
			msg = "��������Ϊ�գ�";
			break
		}
		if (PDrug=="") {
			msg = "����ҩ�ﲻ��Ϊ�գ�";
			break
		}
		if (PUseInfo=="") {
			msg = "�÷���������Ϊ�գ�";
			break
		}
		
		CObj.PDisease=PDisease
		CObj.PDrug=PDrug
		CObj.PUseInfo=PUseInfo
		PageLogicObj.DiseaseObj.push(CObj)
	}	
	if (msg!="") {
		$.messager.alert('��ʾ',msg,"warning",function () {
			onClickRow(i);	
		});
		
		return false;
	}
	return true;
}

function SetFocus(id) {
	$("#"+id).focus();
}

function SetRadio(name,id,value) {
	if (value=="") return;
	var id=id||"",
		selector="";
	if (id == "") selector="body"
	else selector="#"+id
	$(selector).find("input[type='radio'][name='"+name+"'][value='"+ value +"']").radio('check');
}

function SetCheckbox(name,id,value) {
	if (value=="") return;
	var id=id||"",
		selector="";
	if (id == "") selector="body"
	else selector="#"+id
	var myArr = value.split("^")
	for (var i=0; i<myArr.length; i++) {
		var cValue=myArr[i];
		if (cValue=="") continue;
		$(selector).find("input[type='checkbox'][name='"+name+"'][value='"+ cValue +"']").checkbox('check');
	}
	
}

function SetText(id,value) {
	$("#"+id).val(value)
}

function SetNumberbox(id,value) {
	$("#"+id).numberbox("setValue",value)
}

function SetDatebox(id,value) {
	$("#"+id).datebox("setValue",value);
}

function GetDateValue(id) {
	PageLogicObj.BaseParamObj[id]= $("#"+id).datebox("getValue")||"";
	return PageLogicObj.BaseParamObj[id];
}

function GetTextValue(id) {
	PageLogicObj.BaseParamObj[id]= $.trim($("#"+id).val()||"");
	return PageLogicObj.BaseParamObj[id];
}

function GetRadioValue(name,id) {
	var id=id||"",
		selector="";
	if (id == "") selector="body"
	else selector="#"+id
	var selectObjValue = $(selector).find("input[type='radio'][name='"+name+"']:checked").val()||"";
	PageLogicObj.BaseParamObj[name]= selectObjValue;
	return PageLogicObj.BaseParamObj[name];
}

function GetCheckboxValue(name,id) {
	var id=id||"",
		selector="";
	if (id == "") selector="body"
	else selector="#"+id
	var selectObjValue = $(selector).find("input[type='checkbox'][name='"+name+"']:checked");
	if (selectObjValue.length==0) {
		return "";
	}
	var TempArr = [];
	for (var i=0;i<selectObjValue.length;i++) {
		TempArr.push($(selectObjValue[i]).val())
	}
	PageLogicObj.BaseParamObj[name]= TempArr.join("^");
	return PageLogicObj.BaseParamObj[name];
}

function InitGrid(){
	
	var TitLnk = '<a href="#" onclick="insertinputrow()"><img style="margin:6px 3px 0px 3px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>';
	
	var DataGrid = $HUI.datagrid("#PDiseaseTab", {
		nowrap:false,
		singleSelect:true,
		idField:'id',
		//method:'Get',
		fit:true,
		fitColumns : true,
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.GCP.SAE.BS",
			QueryName : "QrySAEPat",
			MID:ServerObj.MID
		},
	    //url:'web.DHCDocInterfaceMethodPageLoad.cls?action=inputType&input='+1,
	    columns:[[
		    {field:'PDisease',title:'����',width:230,editor:'text'},
		    {field:'PDrug',title:'����ҩ��',width:230,editor:'text'},
		    {field:'PUseInfo',title:'�÷�����',width:230,editor:'text'},
			{field:'action',title:TitLnk,width:90,align:'center',
				formatter:function(value,row,index){
					var d = "<a href='#' onclick='deleteinputrow(this)'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
					return d;
				}
			}
	    ]],
		onBeforeEdit:function(index,row){
			row.editing = true;
		},
		onAfterEdit:function(index,row){
			row.editing = false;
			/*var interfaceCode=$("#interfaceCode").val().replace(/\ /g,"");
			if (interfaceCode=="") {
				$.messager.alert('��ʾ',"�ӿڴ���Ϊ��");
				return;
			}*/
		},
		onCancelEdit:function(index,row){
			var type=row["type"];
			if (typeof(type) == "undefined") {
				$('#PDiseaseTab').datagrid('deleteRow', index)
				return;
			}else {
				row.editing = false;
			}
		},
		onLoadSuccess:function(data){
			if (ServerObj.See==1) {
				$(this).datagrid("hideColumn", "action");
			}
			return
			
			//bindDescTip();
			var data=$('#PDiseaseTab').datagrid('getData');
			var total=data.total;
			for (i=0;i<total;i++) {
				$('#PDiseaseTab').datagrid('beginEdit',i);
				PageLogicObj.inGdNoteArrayObj.push(data.rows[i].descHidden);
			}
		},
		onClickRow:function (rowIndex, rowData) {
			//rowIndex��0��ʼ
			onClickRow(rowIndex, rowData)
		}
    });
    
	
	PageLogicObj.PDiseaseGrid = DataGrid;
}

var editIndex=undefined;
var modifyBeforeRow = {};
var modifyAfterRow = {};

function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#PDiseaseTab').datagrid('validateRow', editIndex)){
			editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}
	
function onClickRow(index,rowData){
	if (ServerObj.See==1) {
		return false;
	}
	if (editIndex!=index) {
		if (endEditing()){
			$('#PDiseaseTab').datagrid('selectRow', index)
					.datagrid('beginEdit', index);
			editIndex = index;
			//modifyBeforeRow = $.extend({},$('#PDiseaseTab').datagrid('getRows')[editIndex]);
		} else {
			$('#PDiseaseTab').datagrid('selectRow', editIndex);
		}
	}
}

function insertinputrow(){
	var data=$('#PDiseaseTab').datagrid('getData');
	var index=data.total;
	$('#PDiseaseTab').datagrid('insertRow', {
		index: index,
		row:{
			//requireFlag:'N'
		}
	});
	$('#PDiseaseTab').datagrid('beginEdit',index);
	PageLogicObj.inGdNoteArrayObj.push("");
}

function deleteinputrow(target){
	var index=getRowIndex(target);
	$('#PDiseaseTab').datagrid('selectRow',getRowIndex(target));
	var row = $('#PDiseaseTab').datagrid('getSelected');
	$('#PDiseaseTab').datagrid('deleteRow', index);
	
	return
	if (typeof(type) != "undefined") {
		$('#PDiseaseTab').datagrid('deleteRow', index);
	}
	else {
		$('#PDiseaseTab').datagrid('cancelEdit', index);
	}
	var data=$('#PDiseaseTab').datagrid('getData');
	var total=data.total;
	for (i=index;i<total;i++) {
		PageLogicObj.inGdNoteArrayObj[index]=inGdNoteArrayObj[index+1];
	}
	PageLogicObj.inGdNoteArrayObj.splice(index,1);
}

function getRowIndex(target){
	var tr = $(target).closest('tr.datagrid-row');
	return parseInt(tr.attr('datagrid-row-index'));
}

function CheckTelOrMobile(telephone,Name,Type){
	if (telephone.length==8) return true;
	if (DHCC_IsTelOrMobile(telephone)) return true;
	if (telephone.substring(0,1)==0){
		if (telephone.indexOf('-')>=0){
			$.messager.alert("��ʾ",Type+"�̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,�������ӷ���-������,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("��ʾ",Type+"�̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}else{
		if(telephone.length!=11){
			$.messager.alert("��ʾ",Type+"�绰����ӦΪ��11��λ,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("��ʾ",Type+"�����ڸúŶε��ֻ���,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}
	return true;
}


/*  
��;����������Ƿ���ȷ�ĵ绰���ֻ���  
���룺  
value���ַ���  
���أ�  
���ͨ����֤����true,���򷵻�false
/^1[34578]\d{9}$/;  
*/  
function DHCC_IsTelOrMobile(telephone){ 
	//var teleReg = /^((0\d{2,3})-)(\d{7,8})$/;
	var teleReg1 = /^((0\d{2,3})-)(\d{7,8})$/;
	var teleReg2 = /^((0\d{2,3}))(\d{7,8})$/;  
	var mobileReg =/^1[3|4|5|6|7|8|9][0-9]{9}$/;
	if (!teleReg1.test(telephone)&& !teleReg2.test(telephone) && !mobileReg.test(telephone)){  
		return false;  
	}else{  
		return true;  
	}  
}

function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	//alert(keyCode)
	if (keyCode==13) {
		if(SrcObj && SrcObj.id.indexOf("PPDesc")>=0){
			Find_Handle();
			return false;
		}
		return true;
	}
	//�������Backspace������  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }   
}

