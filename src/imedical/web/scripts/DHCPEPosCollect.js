/// DHCPEPosCollect.js
/// 创建时间		2007.09.20
/// 创建人			xuwm
/// 主要功能		阳性体征汇总
/// 对应表		
/// 最后修改时间	
/// 最后修改人	    yupeng

	
function BodyLoadHandler() {

	var obj;
	obj=document.getElementById('BQuery');
	if (obj){ obj.onclick=BQuery_click; }
	
	obj=document.getElementById('IName');
	if (obj){
		obj.onclick=IName_click;
		obj.onkeydown = IName_keydown;		
	}
	obj=document.getElementById('STDR');
	if (obj){
		obj.onchange=Staton_Select;
	}
	
	obj=document.getElementById('GName');
	if (obj){
		obj.onclick=GName_click;
		obj.onkeydown = GName_keydown;
	}	
	
	// 用按钮删除选择项
	obj=document.getElementById('DeleteItem');
	if (obj) { obj.onclick=DeleteItem_click; }
	
	
	iniForm();
}

function iniForm() {

}

// 获取 导出数据的条件 提供给 DHCPEPosQuery.PosCollect.js
function GetImportContion() {
	var obj;
	var iStandardsList='', GList='';
	
	iStandardsList=GetStandardsList();
	obj=document.getElementById('GList');
	if (obj){ GList=obj.value; }
	
	var iDateFrom='';
	var iDateTo='';
	var iAgeFrom='';
	var iAgeTo='';	
	var iSex='';
	var iMarried='';
	obj=document.getElementById('DateFrom');
	if (obj && ''!=obj.value) { iDateFrom = obj.value; }
	obj=document.getElementById('DateTo');
	if (obj && ''!=obj.value) { iDateTo = obj.value; }
	obj=document.getElementById('AgeFrom');
	if (obj && ''!=obj.value) { iAgeFrom = obj.value; }
	obj=document.getElementById('AgeTo');
	if (obj && ''!=obj.value) { iAgeTo = obj.value; }	
	obj=document.getElementById('Sex');
	if (obj && ''!=obj.value) { iSex = obj.value; }
	obj=document.getElementById('Married');
	if (obj && ''!=obj.value) { iMarried = obj.value; }
	
	var ret= GList
		+','+''+iStandardsList
		+','+''+iDateFrom
		+','+''+iDateTo
		+','+''+iAgeFrom
		+','+''+iAgeTo
		+','+''+iSex
		+','+''+iMarried
		;

	return ret;
	
}


// 查询
function BQuery_click() {
	var obj;
	var iStandardsList='', GList='';
	
	iStandardsList=GetStandardsList();
	
	obj=document.getElementById('GList');
	if (obj){ GList=obj.value; }

	var iDateFrom='';
	var iDateTo='';
	var iAgeFrom='';
	var iAgeTo='';	
	var iSex='';
	var iMarried='';
	var iAgeStep='';
	obj=document.getElementById('DateFrom');
	if (obj && ''!=obj.value) { iDateFrom = obj.value; }
	obj=document.getElementById('DateTo');
	if (obj && ''!=obj.value) { iDateTo = obj.value; }
	obj=document.getElementById('AgeFrom');
	if (obj && ''!=obj.value) { iAgeFrom = obj.value; }
	obj=document.getElementById('AgeTo');
	if (obj && ''!=obj.value) { iAgeTo = obj.value; }	
	obj=document.getElementById('Sex');
	if (obj && ''!=obj.value) { iSex = obj.value; }
	obj=document.getElementById('Married');
	if (obj && ''!=obj.value) { iMarried = obj.value; }
	
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
	
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT='+TargetComponment //'DHCPEPosQuery.PosCollect'
		+'&'+'GList='+GList
		+'&'+'Standards='+iStandardsList
		+'&'+'DateFrom='+iDateFrom
		+'&'+'DateTo='+iDateTo
		+'&'+'AgeFrom='+iAgeFrom
		+'&'+'AgeTo='+iAgeTo
		+'&'+'Sex='+iSex
		+'&'+'Married='+iMarried
		+"&"+"AgeStep="+iAgeStep
		;
	var df=document.getElementById('dataframe');
	if (df) { df.src=lnk; }
		
}
// 设置站点条件
function Staton_Select() {
	var obj;
	var iSTDR='';
	
	obj=document.getElementById('STDR');
	if (obj){ iSTDR=obj.value; }
	
	
	var TargetComponment='';
	obj=document.getElementById('NStandardList');
	if (obj && ''!=obj.value) { TargetComponment = obj.value; }
	
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT='+TargetComponment  // 'DHCPEPosQuery.StandardList'
		+'&'+'ParRef='+iSTDR
		;
	var df=document.getElementById('StandardList');
	if (df) { df.src=lnk; }
		
}
function GetExpertDiagnosisList() {
	
	var iIName='', iIllness='';
	var obj;
	obj=document.getElementById('IName');
	if (obj && ''!=obj.value) { iIName = obj.value; }
	if ('请输入疾病名称'==iIName) { iIName=''; }
	
	obj=document.getElementById('ExpertDiagnosisType');
	if (obj && obj.checked) { iIllness = 'Y'; }
	
	var TargetComponment='';
	obj=document.getElementById('NExpertDiagnosisList');
	if (obj && ''!=obj.value) { TargetComponment = obj.value; }
	
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT='+TargetComponment //'DHCPEIllnessStatistic.ExpertDiagnosisList'
		+'&'+'Desc='+iIName
		+'&'+'Illness='+iIllness
		;
	var df=document.getElementById('ExpertDiagnosisList');
	if (df) { df.src=lnk; }
}

function ExpertDiagnosisType_click() {
	var src=window.event.srcElement;
	GetExpertDiagnosisList()
}

function IName_click() {
	var src=window.event.srcElement;
	if ('请输入疾病名称'==src.value) { src.value=''; } 
}

function IName_keydown(e) {
	var key=websys_getKey(e);
	if (key==13) { GetExpertDiagnosisList(); }
}

//used
function GetGroupList() {
	
	var iGName='';
	var obj;

	obj=document.getElementById('GName');
	if (obj && ''!=obj.value) { iGName = obj.value; }
	if ('请输入单位名称'==iGName) { iGName=''; }
	
	var TargetComponment='';
	obj=document.getElementById('NGroupList');
	if (obj && ''!=obj.value) { TargetComponment = obj.value; }
	
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT='+TargetComponment // 'DHCPEIllnessStatistic.GList'
		+'&'+'GBIDesc='+iGName
		;
	
	var df=document.getElementById('GroupList');
	if (df) { df.src=lnk; }
}

//used
function GName_click() {
	var src=window.event.srcElement;
	if ('请输入单位名称'==src.value) { src.value=''; } 
}

//used
function GName_keydown(e) {
	var key=websys_getKey(e);
	if (key==13) { GetGroupList(); }
}

//used
// 点击按钮删除选择项
function DeleteItem_click() 
{
	var obj;
	var selectedIndex=-1;
	obj=document.getElementById('StandardsList');
	if (obj && obj.selectedIndex!=-1) {
		selectedIndex=obj.selectedIndex;
		obj.options[obj.selectedIndex]=null;
		if (selectedIndex<obj.options.length) {
			obj.selectedIndex=selectedIndex;
		}else{ obj.selectedIndex=obj.options.length-1; }
	}
	
}



//used
//返回选择项目的体征
function GetStandardsList() {
	var obj;
	var StandardsList='';
	
	obj=document.getElementById('StandardsList');
	if (obj) {
		for (var iLoop=0;iLoop<obj.options.length;iLoop++) {				
			if (''!=StandardsList+obj.options[iLoop]) {StandardsList=StandardsList+obj.options[iLoop].value+'$'; }
		}
	}
	if (''!=StandardsList) { StandardsList='$'+StandardsList; }
	return StandardsList;

}


//从子页面获取条件

//检查目的listitem 是否有该值
function ifexist(val,list)
{
	for (var i=0;i<list.options.length;i++){
		if (list.options[i].value==val)
		{
			return i;
		}
    }
	return -1;
}	

//used	
function SetGroupList(GroupList){
	var obj=document.getElementById('GList');
	if (obj){ obj.value=GroupList; }
}
// 从专家诊断页面获取 疾病查询条件 
function SetStandardList(StandardDRListList,StandardDescList,operatorType) {
		
		obj=document.getElementById('cb_Filter');	
		if (obj && !obj.checked) { return ; }
		
		var iStandardDR='';iStandardDesc='';
		var StandardDRs=StandardDRListList.split('^');
		var StandardDescs=StandardDescList.split('^');
		var obj=document.getElementById('StandardsList');
		if (obj) {
			//obj.options.length=0;
			for (var iLoop=0;iLoop<StandardDRs.length;iLoop++) {				
				if (''!=StandardDRs[iLoop]) {
					if ('A'==operatorType) {
						if (-1==ifexist(StandardDRs[iLoop],obj)) {							
							obj.options[obj.options.length]=new Option(StandardDescs[iLoop], StandardDRs[iLoop]);
						}
					}
					else{
						if (-1!=ifexist(StandardDRs[iLoop],obj)) {
							obj.options[ifexist(StandardDRs[iLoop],obj)]=null;
						}
					}
				}
			}
		}
}


document.body.onload = BodyLoadHandler;




function DateFrom_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var obj=document.getElementById('DateFrom');
		if (!IsValidDate(obj)) return;
		var url='websys.lookupdate.csp?ID=DateFrom&STARTVAL=';
		url += '&DATEVAL=' + escape(obj.value);
		var tmp=url.split('%');
		url=tmp.join('%25');
		websys_lu(url,1,'top=200,left=200,width=370,height=230');
		return websys_cancel();
	}
}
function DateFrom_lookupSelect(dateval) {
	var obj=document.getElementById('DateFrom');
	obj.value=dateval;
		websys_nextfocusElement(obj);
}
var obj=document.getElementById('DateFrom');
if (obj) obj.onkeydown=DateFrom_lookuphandler;
var obj=document.getElementById('ldDateFrom');
if (obj) obj.onclick=DateFrom_lookuphandler;
function DateFrom_changehandler(e) {
	var eSrc=websys_getSrcElement(e);
	if (!IsValidDate(eSrc)) {
		eSrc.className='clsInvalid';
		websys_setfocus('DateFrom');
		return  websys_cancel();
	} else {
		eSrc.className='';
	}
}
var obj=document.getElementById('DateFrom');
if (obj) obj.onchange=DateFrom_changehandler;
function DateTo_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var obj=document.getElementById('DateTo');
		if (!IsValidDate(obj)) return;
		var url='websys.lookupdate.csp?ID=DateTo&STARTVAL=';
		url += '&DATEVAL=' + escape(obj.value);
		var tmp=url.split('%');
		url=tmp.join('%25');
		websys_lu(url,1,'top=200,left=200,width=370,height=230');
		return websys_cancel();
	}
}
function DateTo_lookupSelect(dateval) {
	var obj=document.getElementById('DateTo');
	obj.value=dateval;
		websys_nextfocusElement(obj);
}
var obj=document.getElementById('DateTo');
if (obj) obj.onkeydown=DateTo_lookuphandler;
var obj=document.getElementById('ldDateTo');
if (obj) obj.onclick=DateTo_lookuphandler;
function DateTo_changehandler(e) {
	var eSrc=websys_getSrcElement(e);
	if (!IsValidDate(eSrc)) {
		eSrc.className='clsInvalid';
		websys_setfocus('DateTo');
		return  websys_cancel();
	} else {
		eSrc.className='';
	}
}
var obj=document.getElementById('DateTo');
if (obj) obj.onchange=DateTo_changehandler;
