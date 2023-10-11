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
		$.messager.alert('提示',"新药临床研究批准文号不能为空！","warning",function () {
			SetFocus("AEISO");
		});
		return false;
	}
	var AECode = GetTextValue("AECode");
	if (AECode == "") {
		$.messager.alert('提示',"编号不能为空！","warning",function () {
			SetFocus("AECode");
		});
		return false;
	}
	var AEReportType = GetRadioValue("AEReportType","AEReportType_TD")
	if (AEReportType == "") {
		$.messager.alert('提示',"报告类型不能为空！","warning");
		return false;
	}
	
	var AEReportDate = GetDateValue("AEReportDate")
	if (AEReportDate == "") {
		$.messager.alert('提示',"报告时间不能为空！","warning");
		return false;
	}
	
	var AEMajorName = GetTextValue("AEMajorName");
	if (AEMajorName == "") {
		$.messager.alert('提示',"专业名称不能为空！","warning",function () {
			SetFocus("AEMajorName");
		});
		return false;
	}
	
	var AEMajorTel = GetTextValue("AEMajorTel");
	if (AEMajorTel == "") {
		$.messager.alert('提示',"专业名称电话不能为空！","warning",function () {
			SetFocus("AEMajorTel");
		});
		return false;
	} else {
		if (!CheckTelOrMobile(AEMajorTel,"AEMajorTel","专业名称电话")) return false;	
		/*
		if (AEMajorTel.length!="11") {
			$.messager.alert('提示',"输入正确的专业名称电话(11位)！","warning",function () {
				SetFocus("AEMajorTel");
			});
			return false;
		}*/
	}
	
	var AEFilCompanyName = GetTextValue("AEFilCompanyName");
	if (AEFilCompanyName == "") {
		$.messager.alert('提示',"申报单位名称不能为空！","warning",function () {
			SetFocus("AEFilCompanyName");
		});
		return false;
	}
	
	var AEFilCompanyTel = GetTextValue("AEFilCompanyTel");
	if (AEFilCompanyTel == "") {
		$.messager.alert('提示',"申报单位电话不能为空！","warning",function () {
			SetFocus("AEFilCompanyTel");
		});
		return false;
	} else {
		if (!CheckTelOrMobile(AEFilCompanyTel,"AEFilCompanyTel","申报单位电话")) return false;	
		/*
		if (AEFilCompanyTel.length!="11") {
			$.messager.alert('提示',"输入正确的申报单位电话(11位)！","warning",function () {
				SetFocus("AEFilCompanyTel");
			});
			return false;
		}*/
	}
	
	var AEDrugNameZN = GetTextValue("AEDrugNameZN");
	if (AEDrugNameZN == "") {
		$.messager.alert('提示',"试验用药品名称中文名称不能为空！","warning",function () {
			SetFocus("AEDrugNameZN");
		});
		return false;
	}
	
	var AEDrugNameEN = GetTextValue("AEDrugNameEN");
	if (AEDrugNameEN == "") {
		$.messager.alert('提示',"试验用药品名称英文名称不能为空！","warning",function () {
			SetFocus("AEDrugNameEN");
		});
		return false;
	}
	
	var AEDrugCategory = GetRadioValue("AEDrugCategory","AEDrugCategory_TD")
	if (AEDrugCategory == "") {
		$.messager.alert('提示',"药品分类不能为空！","warning");
		return false;
	}
	
	if (AEDrugCategory == 5) {
		var AEDrugCategoryOther = GetTextValue("AEDrugCategoryOther");
		if (AEDrugCategoryOther == "") {
			$.messager.alert('提示',"药品分类其他描述不能为空","warning",function () {
				SetFocus("AEDrugCategoryOther");
			});
			return false;
		}
	}
	
	
	var AERegisterCategory = GetTextValue("AERegisterCategory");
	if (AERegisterCategory == "") {
		$.messager.alert('提示',"注册分类不能为空！","warning",function () {
			SetFocus("AERegisterCategory");
		});
		return false;
	}
	
	var AEDrugForm = GetTextValue("AEDrugForm");
	if (AEDrugForm == "") {
		$.messager.alert('提示',"剂型不能为空！","warning",function () {
			SetFocus("AEDrugForm");
		});
		return false;
	}
	
	var AEStage = GetRadioValue("AEStage","AEStage_TD")
	if (AEStage == "") {
		$.messager.alert('提示',"期别不能为空！","warning");
		return false;
	}
	var AEStudyCategory = GetRadioValue("AEStudyCategory","AEStudyCategory_TD")
	if (AEStudyCategory == "") {
		$.messager.alert('提示',"临床研究分类不能为空！","warning");
		return false;
	}
	var AEIndication = GetTextValue("AEIndication");
	if (AEIndication == "") {
		$.messager.alert('提示',"临床试验适应症不能为空！","warning",function () {
			SetFocus("AEIndication");
		});
		return false;
	}
	
	var AEPatientSpell = GetTextValue("AEPatientSpell");
	if (AEPatientSpell == "") {
		$.messager.alert('提示',"姓名拼音缩写不能为空！","warning",function () {
			SetFocus("AEPatientSpell");
		});
		return false;
	}
	var AEBirthday = GetDateValue("AEBirthday");
	if (AEBirthday == "") {
		$.messager.alert('提示',"出生日期不能为空！","warning",function () {
			SetFocus("AEBirthday");
		});
		return false;
	}
	var AESex = GetRadioValue("AESex","AESex_TD")
	if (AESex == "") {
		$.messager.alert('提示',"性别不能为空！","warning");
		return false;
	}
	
	var AEHeight = GetTextValue("AEHeight");
	if (AEHeight == "") {
		$.messager.alert('提示',"身高不能为空！","warning",function () {
			SetFocus("AEHeight");
		});
		return false;
	}
	var AEWeight = GetTextValue("AEWeight");
	if (AEWeight == "") {
		$.messager.alert('提示',"体重不能为空！","warning",function () {
			SetFocus("AEWeight");
		});
		return false;
	}
	
	var AEHasTreat = GetRadioValue("AEHasTreat","AEHasTreat_TD")
	if (AEHasTreat == "") {
		$.messager.alert('提示',"合并疾病及治疗不能为空！","warning");
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
		$.messager.alert('提示',"SAE的医学术语(诊断)不能为空！","warning",function () {
			SetFocus("AEDiagnosis");
		});
		return false;
	}
	
	var AESituation = GetCheckboxValue("AESituation")
	if (AESituation == "") {
		$.messager.alert('提示',"SAE情况不能为空！","warning");
		return false;
	}
	var AEHasDead = $("#AEHasDead").checkbox("getValue");
	
	if (AEHasDead)  {
		var AEDeadDate = GetDateValue("AEDeadDate")
		if (AEDeadDate == "") {
			$.messager.alert('提示',"死亡时间不能为空！","warning");
			return false;
		}
	}
	var AESituationOT = $("#AESituationOT").checkbox("getValue");
	if (AESituationOT)  {
		var AESituationOther = GetTextValue("AESituationOther");
		if (AESituationOther == "") {
			$.messager.alert('提示',"SAE情况其他不能为空！","warning",function () {
				SetFocus("AESituationOther");
			});
			return false;
		}
	}
	
	var AEHappenDate = GetDateValue("AEHappenDate")
	if (AEHappenDate == "") {
		$.messager.alert('提示',"SAE发生时间不能为空！","warning");
		return false;
	}
	
	var AEKnowDate = GetDateValue("AEKnowDate")
	if (AEKnowDate == "") {
		$.messager.alert('提示',"研究者获知SAE时间不能为空！","warning");
		return false;
	}
	
	
	var AEMeasures = GetRadioValue("AEMeasures","AEMeasures_TD")
	if (AEMeasures == "") {
		$.messager.alert('提示',"对试验用药采取的措施不能为空！","warning");
		return false;
	}
	
	var AETurnOver = GetRadioValue("AETurnOver","AETurnOver_TD")
	if (AETurnOver == "") {
		$.messager.alert('提示',"SAE转归不能为空！","warning");
		return false;
	}
	
	if (AETurnOver==1) {
		var AEHasSequela = GetRadioValue("AEHasSequela","AETurnOver_TD")
		if (AEHasSequela == "") {
			$.messager.alert('提示',"后遗症不能为空！","warning");
			return false;
		}
	}
	
	var AERelation = GetRadioValue("AERelation","AERelation_TD")
	if (AERelation == "") {
		$.messager.alert('提示',"SAE与试验药的关系不能为空！","warning");
		return false;
	}
	
	var AEReportZN = GetRadioValue("AEReportZN","AEReportZN_TD")
	if (AEReportZN == "") {
		$.messager.alert('提示',"SAE报道情况国内不能为空！","warning");
		return false;
	}
	
	var AEReportEN = GetRadioValue("AEReportEN","AEReportZN_TD")
	if (AEReportEN == "") {
		$.messager.alert('提示',"SAE报道情况国外不能为空！","warning");
		return false;
	}
	
	
	var AEDetail = GetTextValue("AEDetail");
	if (AEDetail == "") {
		$.messager.alert('提示',"SAE发生及处理的详细情况不能为空！","warning",function () {
			SetFocus("AEDetail");
		});
		return false;
	}
	
	var AEReportCompany = GetTextValue("AEReportCompany");
	if (AEReportCompany == "") {
		$.messager.alert('提示',"报告单位名称不能为空！","warning",function () {
			SetFocus("AEReportCompany");
		});
		return false;
	}
	
	var AEUserPost = GetTextValue("AEUserPost");
	if (AEUserPost == "") {
		$.messager.alert('提示',"报告人职务/职称不能为空！","warning",function () {
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
			$.messager.alert("提示", "保存成功！", "info", function () {
				websys_showModal("hide");
				websys_showModal('options').CallBackFunc();
				websys_showModal("close");	
			});
		} else {
			$.messager.alert("提示", result , "warning");
			return false;
		}
	});
}

function GetDiseaseObj() {
	var outputGdRows=$('#PDiseaseTab').datagrid('getRows');
	if (outputGdRows.length==0) {
		$.messager.alert('提示',"请填写受试者的用药情况！","warning");
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
			msg = "疾病不能为空！";
			break
		}
		if (PDrug=="") {
			msg = "治疗药物不能为空！";
			break
		}
		if (PUseInfo=="") {
			msg = "用法用量不能为空！";
			break
		}
		
		CObj.PDisease=PDisease
		CObj.PDrug=PDrug
		CObj.PUseInfo=PUseInfo
		PageLogicObj.DiseaseObj.push(CObj)
	}	
	if (msg!="") {
		$.messager.alert('提示',msg,"warning",function () {
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
		    {field:'PDisease',title:'疾病',width:230,editor:'text'},
		    {field:'PDrug',title:'治疗药物',width:230,editor:'text'},
		    {field:'PUseInfo',title:'用法用量',width:230,editor:'text'},
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
				$.messager.alert('提示',"接口代码为空");
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
			//rowIndex从0开始
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
			$.messager.alert("提示",Type+"固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,并以连接符【-】连接,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("提示",Type+"固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}else{
		if(telephone.length!=11){
			$.messager.alert("提示",Type+"电话长度应为【11】位,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("提示",Type+"不存在该号段的手机号,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}
	return true;
}


/*  
用途：检查输入是否正确的电话和手机号  
输入：  
value：字符串  
返回：  
如果通过验证返回true,否则返回false
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
	//浏览器中Backspace不可用  
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

