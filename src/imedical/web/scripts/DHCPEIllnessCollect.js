/// DHCPEIllnessCollect.js
///疾病汇总
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("BQuery");
	if (obj){ obj.onclick=BQuery_click; }
	
	// 疾病名称
	obj=document.getElementById("IName");
	if (obj){
		obj.onclick=IName_click;
		obj.onkeydown = IName_keydown;		
	}
	
	// 团体名称
	obj=document.getElementById("GName");
	if (obj){
		obj.onclick=GName_click;
		obj.onkeydown = GName_keydown;
	}
	
	// 是否是疾病(未使用)
	obj=document.getElementById("IllnessStandardType");
	if (obj) {obj.onclick=IllnessStandardType_click; }	
	
	// 双击疾病列表?删除当前基本
	//obj=document.getElementById("EDList");
	//if (obj) { obj.ondblclick=EDList_dblclick; }
	
	//日期元素
	SetDate("DateFrom","ldDateFrom");
	SetDate("DateTo","ldDateTo");
	
	// 用按钮删除选择项
	obj=document.getElementById("DeleteItem");
	if (obj) { obj.onclick=DeleteItem_click; }
	
	// 是否过滤疾病(是:只查询所选疾病 否:显示团体的所有情况)
	obj=document.getElementById('cb_Filter');	
	if (obj) { obj.onclick=Filter_click; }
	
	obj=document.getElementById("SavePath")
	if (obj) { obj.value='D:\\'+"疾病汇总.xls"; }
	iniForm();
	
}

function iniForm() {

}

function BQuery_click() {
	var obj;
	var IllnessList='', GList='';
	
	IllnessList=GetIllnessList();

	obj=document.getElementById('GList');
	if (obj){ GList=obj.value; }
	
	if (""==IllnessList) { return;}

	var iDateFrom="";
	var iDateTo="";
	var iAgeFrom="";
	var iAgeTo="";	
	var iSex="";
	var iMarried='';
	var iAgeStep='';
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

	var TargetComponment='';
	obj=document.getElementById('Ndataframe');
	if (obj && ''!=obj.value) { TargetComponment = obj.value; }
    obj=document.getElementById("AgeStep");
	if (obj && ""!=obj.value) { iAgeStep = obj.value; }
	if (isNaN(iAgeStep))
	{
		alert("输入年龄区间必须是数值")
		websys_setfocus("AgeStep");
		return false;
	}
	
	var DepartName=""
	obj=document.getElementById("DepartName");
	if (obj) { DepartName = obj.value; }
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+TargetComponment //"DHCPEIllnessCollect.IllnessList"
		+"&"+"GList="+GList
		+"&"+"IllnessList="+IllnessList
		+"&"+"DateFrom="+iDateFrom
		+"&"+"DateTo="+iDateTo
		+"&"+"AgeFrom="+iAgeFrom
		+"&"+"AgeTo="+iAgeTo
		+"&"+"Sex="+iSex
		+"&"+"Married="+iMarried
		+"&"+"AgeStep="+iAgeStep
		+"&DepartName="+DepartName
		;
	var df=document.getElementById("dataframe");
	if (df) { df.src=lnk; } 
}


// 点击是否疾病(单选框)
function IllnessStandardType_click() {
	var src=window.event.srcElement;
	QueryIllnessStandard()
}
// 输入疾病名称(别名)
function IName_keydown(e) {
	var key=websys_getKey(e);
	if (key==13) { QueryIllnessStandard(); }
}
// 查询疾病,显示疾病列表
function QueryIllnessStandard() {
	
	var iIName='', iIllness='';
	var obj;
	obj=document.getElementById("IName");
	if (obj && ""!=obj.value) { iIName = obj.value; }
	if ('请输入疾病名称'==iIName) { iIName=''; }
	
	obj=document.getElementById("IllnessStandardType");
	if (obj && obj.checked) { iIllness = 'Y'; }
	
	var TargetComponment='';
	obj=document.getElementById('NIllnessStandardList');
	if (obj && ''!=obj.value) { TargetComponment = obj.value; }

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+TargetComponment //"DHCPEIllnessStatistic.IllnessStandardList"
		+"&"+"AddDiagnosis="+iIName
		+"&"+"Illness="+iIllness
		;
	var df=document.getElementById("IllnessStandardList");
	if (df) { df.src=lnk; }
}

// 单击疾病名称输入框,清空输入框
function IName_click() {
	var src=window.event.srcElement;
	if ("请输入疾病名称"==src.value) { src.value=""; } 
}
// 获取当前所选择的疾病列表
function GetIllnessList() {

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
// 单击是否过滤(疾病)单选框
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

// //////////////////////////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////////////////////////
// 根据输入的团体名称,重新查询团体,更新团体列表
function GName_keydown(e) {
	var key=websys_getKey(e);
	if (key==13) { GetGroupList(); }
}
// 获取选择的团体列表
function GetGroupList() {
	
	var iGName='';
	var obj;

	obj=document.getElementById("GName");
	if (obj && ""!=obj.value) { iGName = obj.value; }
	if ('请输入单位名称'==iGName) { iGName=''; }
	
	var TargetComponment='';
	obj=document.getElementById('NGroupList');
	if (obj && ''!=obj.value) { TargetComponment = obj.value; }
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+TargetComponment //"DHCPEIllnessCollect.GList"
		+"&"+"GBIDesc="+iGName
		;
	
	var df=document.getElementById("GroupList");
	if (df) { df.src=lnk; }
}

function GName_click() {
	var src=window.event.srcElement;
	if ("请输入单位名称"==src.value) { src.value=""; } 
}

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
// 点击按钮删除选择项
// modified by wangfujian 2009-05-15
function DeleteItem_click() {
	var obj;
	obj=document.getElementById('EDList');

	var len=obj.options.length;
	
	var j=0;
	for (var i=0;i<len;i++)
	{	
	
		if (obj&&obj.options[j].selected) {
			
			obj.options[j]=null;
		}else{
			j++;
		}		
	}
}
// 双击按钮删除选择项
function EDList_dblclick() {
	var obj=document.getElementById('EDList');
	if (obj && obj.selectedIndex!=-1) {
		obj.options[obj.selectedIndex]=null;
	}
}

document.body.onload = BodyLoadHandler;
