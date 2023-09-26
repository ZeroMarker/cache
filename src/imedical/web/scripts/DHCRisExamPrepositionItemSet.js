//DHCRisExamPrepositionItemSet.js
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
{ //ɾ���������˵Ŀո�  
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
	
	var prepositionItemID=trim( $("prepositionItemID").value);
	var examGroupID=trim($("examGroupID").value);
	var prepositionItmMastDr=trim($("itmMastDr").value);
	
	var prepositionTime=trim($("prepositionTime").value);
	var timeUnit=trim($("timeUnit").value);
	if ( (prepositionItmMastDr!="")&&(examGroupID!=""))
	{
		alert("����ͬʱѡ������Ŀ�ͼ����!!");
		return "";
	}
	
	
	var param=prepositionItemID+"^"+inItmMastDr+"^"+examGroupID+"^"+prepositionItmMastDr+"^"+prepositionTime+"^"+timeUnit;
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
		alert("�����ɹ�!");
		window.location.reload();
	}
	else
	{
		alert("����ʧ��! code="+ret);
	}
	//alert(ret);
	
}

function Delete_click()
{
	if ( SelectedRow == "-1" )
	{
		alert("����ѡ���¼!");
		return;
	}
	
	var param = getParam();
	if ( param=="") return;
	var operateFunction=$("operateFunction").value;
	 
	var ret=cspRunServerMethod(operateFunction,param,"D");
	if ( ret == "0")
	{
		alert("ɾ���ɹ�!");
		window.location.reload();
	}
	else
	{
		alert("ɾ��ʧ��! code="+ret);
	}
}

function Modi_click()
{
	//alert(param);
	if ( SelectedRow == "-1" )
	{
		alert("����ѡ���¼!");
		return;
	}
	
	var param = getParam();
	if ( param=="") return;
	var operateFunction=$("operateFunction").value;
	 
	var ret=cspRunServerMethod(operateFunction,param,"M");
	if ( ret == "0")
	{
		alert("�޸ĳɹ�!");
		window.location.reload();
	}
	else
	{
		alert("�޸�ʧ��! code="+ret);
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
	var objtbl = $("tDHCRisExamPrepositionItemSet");
	var rows = objtbl.rows.length;
	var lastrowindex = rows-1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if ( !selectrow) return;
	//alert(selectrow);
	if ( SelectedRow != selectrow)
	{	
		var prepositionItemID = trim($("tPrepositionItemIDz"+selectrow).value);
		var examGroupID = trim($("tExamGroupIDz"+selectrow).value);
		var examGroupDesc = trim($("tExamGroupNamez"+selectrow).innerText);
		var prepositionItmMastDr = trim($("tItmMastDRz"+selectrow).value);
		var prepositionItmMastDesc = trim($("tItmMastDescz"+selectrow).innerText);
		var prepositionTime = trim($("tTimez"+selectrow).innerText);
		var timeUnit = trim($("tTimeUnitz"+selectrow).innerText);
		
		$("prepositionItemID").value = prepositionItemID;
		$("examGroup").value = examGroupDesc;
		$("examGroupID").value = examGroupID;
		$("itmMastDr").value = prepositionItmMastDr;
		$("itmMast").value = prepositionItmMastDesc;
		$("prepositionTime").value = prepositionTime;
		$("timeUnit").value = timeUnit;
		
		SelectedRow = selectrow;
		
		//var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisExamRejectItemSet&InItmMastDR="+trim($("InItmMastDR").value);
       	//parent.frames['ExamRejectItemSet'].location.href=lnk; 
	}
	else
	{
		$("prepositionItemID").value = "";
		$("examGroup").value = "";
		$("examGroupID").value = "";
		$("itmMastDr").value = "";
		$("itmMast").value = "";
		$("prepositionTime").value = "";
		$("timeUnit").value = "";
		
		SelectedRow="-1";
		//var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisExamGroupItemSet&groupDR="+"&itemCatDr=";
       	//parent.frames['ExamGroupItemSet'].location.href=lnk; 
	}

}


document.body.onload = BodyLoadHandler;


