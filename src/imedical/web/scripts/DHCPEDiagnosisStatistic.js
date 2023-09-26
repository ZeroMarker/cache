/// DHCPEDiagnosisStatistic.js

///疾病汇总

function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("BQuery");
	if (obj){ obj.onclick=BQuery_click; }
	
	obj=document.getElementById("IName");
	if (obj){
		obj.onclick=IName_click;
		obj.onkeydown = IName_keydown;		
	}
	
	obj=document.getElementById("GName");
	if (obj){
		obj.onclick=GName_click;
		obj.onkeydown = GName_keydown;
	}
	obj=document.getElementById("ExpertDiagnosisType");
	if (obj) {obj.onclick=ExpertDiagnosisType_click; }	
	
	// 双击疾病列表?删除当前基本
	//obj=document.getElementById("EDList");
	//if (obj) { obj.ondblclick=EDList_dblclick; }
	
	//日期元素
	SetDate("DateFrom","ldDateFrom");
	SetDate("DateTo","ldDateTo");
	
	// 用按钮删除选择项
	obj=document.getElementById("DeleteItem");
	if (obj) { obj.onclick=DeleteItem_click; }
	
	obj=document.getElementById('cb_Filter');	
	if (obj) { obj.onclick=Filter_click; }
	
	iniForm();
}

function iniForm() {

}

function BQuery_click() {
	var obj;
	var TDiagnosisList='', GList='';
	
	//obj=document.getElementById('EDList');
	//if (obj) { TDiagnosisList=obj.value; }
	TDiagnosisList=GetEDList();
	obj=document.getElementById('GList');
	if (obj){ GList=obj.value; }
	
	if ((""==GList)||(""==TDiagnosisList)) { return;}
	
	var iDateFrom="";
	var iDateTo="";
	var iAgeFrom="";
	var iAgeTo="";	
	var iSex="";
	var iMarried='';
	obj=document.getElementById("DateFrom");
	if (obj && ""!=obj.value) { iDateFrom = obj.value; }
	obj=document.getElementById("DateTo");
	if (obj && ""!=obj.value) { iDateTo = obj.value; }
	obj=document.getElementById("AgeFrom");
	if (obj && ""!=obj.value) { iAgeFrom = obj.value; }
	obj=document.getElementById("AgeTo");
	if (obj && ""!=obj.value) { iAgeTo = obj.value; }	
	obj=document.getElementById("Sex");
	if (obj && ""!=obj.value) { iSex = obj.value; }
	obj=document.getElementById("Married");
	if (obj && ""!=obj.value) { iMarried = obj.value; }
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEIllnessStatistic.DiagnosisList"
		+"&"+"GList="+GList
		+"&"+"DiagnosisList="+TDiagnosisList
		+"&"+"DateFrom="+iDateFrom
		+"&"+"DateTo="+iDateTo
		+"&"+"AgeFrom="+iAgeFrom
		+"&"+"AgeTo="+iAgeTo
		+"&"+"Sex="+iSex
		+"&"+"Married="+iMarried
		;
	var df=document.getElementById("dataframe");
	if (df) { df.src=lnk; }
		
}
function GetExpertDiagnosisList() {
	
	var iIName='', iIllness='';
	var obj;
	obj=document.getElementById("IName");
	if (obj && ""!=obj.value) { iIName = obj.value; }
	if ('请输入疾病名称'==iIName) { iIName=''; }
	
	obj=document.getElementById("ExpertDiagnosisType");
	if (obj && obj.checked) { iIllness = 'Y'; }

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEIllnessStatistic.ExpertDiagnosisList"
		+"&"+"Desc="+iIName
		+"&"+"Illness="+iIllness
		;
	var df=document.getElementById("ExpertDiagnosisList");
	if (df) { df.src=lnk; }
}
// 
function ExpertDiagnosisType_click() {
	var src=window.event.srcElement;
	GetExpertDiagnosisList()
}

function IName_click() {
	var src=window.event.srcElement;
	if ("请输入疾病名称"==src.value) { src.value=""; } 
}

function IName_keydown(e) {
	var key=websys_getKey(e);
	if (key==13) { GetExpertDiagnosisList(); }
}

function GetGroupList() {
	
	var iGName='';
	var obj;

	obj=document.getElementById("GName");
	if (obj && ""!=obj.value) { iGName = obj.value; }
	if ('请输入单位名称'==iGName) { iGName=''; }
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEIllnessStatistic.GList"
		+"&"+"GBIDesc="+iGName
		;
	
	var df=document.getElementById("GroupList");
	if (df) { df.src=lnk; }
}
function GName_click() {
	var src=window.event.srcElement;
	if ("请输入单位名称"==src.value) { src.value=""; } 
}

function GName_keydown(e) {
	var key=websys_getKey(e);
	if (key==13) { GetGroupList(); }
}

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
// 点击按钮删除选择项
function DeleteItem_click() {
	var obj;
	var selectedIndex=-1;
	obj=document.getElementById('EDList');
	if (obj && obj.selectedIndex!=-1) {
		selectedIndex=obj.selectedIndex;
		obj.options[obj.selectedIndex]=null;
		if (selectedIndex<obj.options.length) {
			obj.selectedIndex=selectedIndex;
		}else{ obj.selectedIndex=obj.options.length-1; }
	}
	
}

// 双击按钮删除选择项
function EDList_dblclick() {
	var obj=document.getElementById('EDList');
	if (obj && obj.selectedIndex!=-1) {
		obj.options[obj.selectedIndex]=null;
	}
}

function GetEDList() {

	obj=document.getElementById('cb_Filter');	
	if (obj && !obj.checked) { return '*'; }
	
	var EDList='';
	var obj=document.getElementById('EDList');
	if (obj) {
		for (var iLoop=0;iLoop<obj.options.length;iLoop++) {				
			if (''!=EDList+obj.options[iLoop]) {EDList=EDList+obj.options[iLoop].value+'^'; }
		}
	}
	if (''!=EDList) { EDList='^'+EDList; }
	return EDList;

}
function Filter_click() {
	var src=window.event.srcElement;	
	var obj=document.getElementById('EDList');
	if (obj) {
		obj.disabled= !src.checked;
		return;
		if (!src.checked) 
			while(0<obj.options.length) obj.options[obj.options.length-1]=null;	
	}
	else{ return; }
}
document.body.onload = BodyLoadHandler;
