var PreStartNumObj=document.getElementById("PreStartNum")
var PreStartNumNewObj=document.getElementById("PreStartNumNew")
var UpdateHideObj=document.getElementById("UpdateHide")
var ErrorTextObj=document.all.ErrorText
var RunClassObj=document.getElementById("RunClass")
var ClassNameObj=document.getElementById("ClassName")
var ClassValueObj=document.getElementById("ClassValue")
var UpDateObj=document.getElementById("Update")
var ErrorText=""
function BodyOnLoad() 
{
	
	
	if (UpDateObj)	{	UpDateObj.onclick=UpDateObjClick;}
	if (PreStartNumObj)
	{	PreStartNumObj.onkeydown=PreStartNumObjClick
	}
	var TableListObj=document.getElementById("tDHCFSessionUp")
	if (TableListObj)
	{	TableListObj.onkeydown=TableListObjOnKeyDown;
		TableListObj.border=1
	}
	combo_DeptList=dhtmlXComboFromStr("CtLoc","");
	combo_DeptList.enableFilteringMode(true);
	var DeptStr=DHCC_GetElementData('DeptStr');
	var Arr=DHCC_StrToArray(DeptStr);
	combo_DeptList.addOption(Arr);
}

function PreStartNumObjClick()
{	
	if (event.keyCode==13)	{	event.keyCode=9	}
}
function UpDateObjClick()
{	
	//RunClassObj.click()
	//alert(ClassValueObj.value)
	UpDateObj.enabled=false
	if (PreStartNumObj)
	{
		if (PreStartNumObj.value==""||PreStartNumObj.value<1)
		{
			alert("ԤԼ��ʼ�Ų���ȷ,����������");PreStartNumObj.focus();return;UpDateOb.enabled=true;
		}
	}
	if (PreStartNumNewObj.value==""||PreStartNumNewObj.value<1)
		{
			alert("��ԤԼ��ʼ�Ų���ȷ,����������");PreStartNumNewObj.focus();return;UpDateOb.enabled=true;
		}
	if (PreStartNumObj.value==PreStartNumNewObj.value)
		{
			alert("��ʼ��һ��,���ø���");return;UpDateOb.enabled=true;
		}
	if (UpdateHideObj)
	{	
		//web.DHCFScheduleUp.UpSchedule
		var ClassName="S bb=##class(web.DHCFScheduleUp).UpSchedule"
		var ClassMod="UpSchedule"
		var ParaStr=PreStartNumObj.value+"^"+PreStartNumNewObj.value+"^"+combo_DeptList.getSelectedValue();
		var Para=ClassName+"-"+ParaStr
		var RetValue=cspRunServerMethod(UpdateHideObj.value,Para);
		ErrorTextObj.value=RetValue
		alert("���½���")
		UpDateOb.enabled=true
	}
}
function TableListObjOnKeyDown(e)
{	
	if ((event.keyCode==38)||(event.keyCode=40))
		{	MoveCursor("tDHCFSessionUp");	}
}
document.body.onload = BodyOnLoad