//DHCRisExamRejectItemSet.js
var SelectedRow="-1";
var combo_TimeUnit;

var $=function(Id){
	return document.getElementById(Id);
}


function BodyLoadHandler()
{

	var AddObj=$("add");
	if (AddObj)
	{
		AddObj.onclick=Add_click;
	}
	
	var DeleteObj=$("delete");
	if (DeleteObj)
	{
		DeleteObj.onclick=Delete_click;
	}
	
	var ModiObj=$("modify");
	if (ModiObj)
	{
		ModiObj.onclick=Modi_click;
	}
	
	var getTimeUnitObj=DHCC_GetElementData("getTimeUnit");
	var timeUnitObj=$("timeUnit");
	
	if(timeUnitObj)
	{
		combo_TimeUnit=dhtmlXComboFromStr("timeUnit",getTimeUnitObj);
		combo_TimeUnit.enableFilteringMode(true);
		//if (GetOptionsID!="")
		{
		//	combo_Use.setComboValue(GetOptionsID);
		}
		combo_TimeUnit.setComboValue($("timeUnit").value);
		//combo_type.selectHandle=combo_UseKeydownhandler;
		//combo_type.keyenterHandle=combo_UseKeyenterhandler;
		//combo_type.attachEvent("onKeyPressed",combo_UseKeyenterhandler);
  	}
	
}


function trim(str)
{ //删除左右两端的空格  
	return str.replace(/(^\s*)|(\s*$)/g, "");  
} 
function asynDr()
{
	var examGroupDesc=trim( $("examGroup").value);
	var itmMastDesc=trim( $("itmMast").value);
	if ( trim(examGroupDesc) == "")
		$("examGroupID").value="";
	if ( trim(itmMastDesc) == "")
		$("itmMastDr").value="";
}

function getParam()
{
	asynDr();
	var inItmMastDr=trim($("InItmMastDR").value);
	
	var rejectItemID=trim( $("rejectItemID").value);
	var examGroupID=trim($("examGroupID").value);
	var rejectItmMastDr=trim($("itmMastDr").value);
	
	var rejectTime=trim($("rejectTime").value);
	var timeUnit=trim($("timeUnit").value);
	if ( (rejectItmMastDr!="")&&(examGroupID!=""))
	{
		alert("不能同时选择检查项目和检查组!!");
		return "";
	}
	
	
	var param=rejectItemID+"^"+inItmMastDr+"^"+examGroupID+"^"+rejectItmMastDr+"^"+rejectTime+"^"+timeUnit;
	return param;
	
}
function Add_click()
{
	
	//alert(param);
	var param = getParam();
	if ( param=="") return;
	var operateFunction=$("operateFunction").value;
	//alert(addFunction);
	var ret=cspRunServerMethod(operateFunction,param,"A");
	if ( ret == "0")
	{
		alert("新增成功!");
		window.location.reload();
	}
	else
	{
		alert("新增失败! code="+ret);
	}
	//alert(ret);
	
}

function Delete_click()
{
	if ( SelectedRow == "-1" )
	{
		alert("请先选择记录!");
		return;
	}
	
	var param = getParam();
	if ( param=="") return;
	var operateFunction=$("operateFunction").value;
	 
	var ret=cspRunServerMethod(operateFunction,param,"D");
	if ( ret == "0")
	{
		alert("删除成功!");
		window.location.reload();
	}
	else
	{
		alert("删除失败! code="+ret);
	}
}

function Modi_click()
{
	//alert(param);
	if ( SelectedRow == "-1" )
	{
		alert("请先选择记录!");
		return;
	}
	
	var param = getParam();
	if ( param=="") return;
	var operateFunction=$("operateFunction").value;
	 
	var ret=cspRunServerMethod(operateFunction,param,"M");
	if ( ret == "0")
	{
		alert("修改成功!");
		window.location.reload();
	}
	else
	{
		alert("修改失败! code="+ret);
	}
	//alert(ret);
	
}

function selectExamGroup(Info)
{
	//alert(Info);
	Item=Info.split("^");
	$("examGroup").value=Item[1];
	$("examGroupID").value=Item[0];
	
}

function selectItmMast(Info)
{
	//alert(Info);
	Item=Info.split("^");

	$("itmMast").value=Item[0];
	
	$("itmMastDr").value=Item[1];
}



function SelectRowHandler()
{
	var eSrc = window.event.srcElement;
	var objtbl = $("tDHCRisExamRejectItemSet");
	var rows = objtbl.rows.length;
	var lastrowindex = rows-1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if ( !selectrow) return;
	//alert(selectrow);
	if ( SelectedRow != selectrow)
	{	
		var rejectItemID = trim($("tRejectItemIDz"+selectrow).value);
		var examGroupID = trim($("tExamGroupIDz"+selectrow).value);
		var examGroupDesc = trim($("tExamGroupNamez"+selectrow).innerText);
		var rejectItmMastDr = trim($("tItmMastDRz"+selectrow).value);
		var rejectItmMastDesc = trim($("tItmMastDescz"+selectrow).innerText);
		var rejectTime = trim($("tTimez"+selectrow).innerText);
		var timeUnit = trim($("tTimeUnitz"+selectrow).innerText);
		
		$("rejectItemID").value = rejectItemID;
		$("examGroup").value = examGroupDesc;
		$("examGroupID").value = examGroupID;
		$("itmMastDr").value = rejectItmMastDr;
		$("itmMast").value = rejectItmMastDesc;
		$("rejectTime").value = rejectTime;
		$("timeUnit").value = timeUnit;
		
		SelectedRow = selectrow;
		
		//var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisExamRejectItemSet&InItmMastDR="+trim($("InItmMastDR").value);
       	//parent.frames['ExamRejectItemSet'].location.href=lnk; 
	}
	else
	{
		$("rejectItemID").value = "";
		$("examGroup").value = "";
		$("examGroupID").value = "";
		$("itmMastDr").value = "";
		$("itmMast").value = "";
		$("rejectTime").value = "";
		$("timeUnit").value = "";
		
		SelectedRow="-1";
		//var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisExamGroupItemSet&groupDR="+"&itemCatDr=";
       	//parent.frames['ExamGroupItemSet'].location.href=lnk; 
	}

}


document.body.onload = BodyLoadHandler;


