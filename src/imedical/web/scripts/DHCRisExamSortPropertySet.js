//DHCRisExamSortPropertySet.js
var SelectedRow="-1";
var combo_isSort;
var combo_isAuto;

var $=function(Id){
	return document.getElementById(Id);
}


function BodyLoadHandler()
{

	
	var ModiObj=$("modify");
	if (ModiObj)
	{
		ModiObj.onclick=Modi_click;
	}
	
	var findObj=$("Find");
	if (findObj) findObj.onclick=FindClickHandler;
	
	var getYesNoListObj=DHCC_GetElementData("getYesNoList");
	var isSortObj=$("IsSort");
	
	if(isSortObj)
	{	
		
		combo_isSort=dhtmlXComboFromStr("IsSort",getYesNoListObj);
		
		combo_isSort.enableFilteringMode(true);
		
		combo_isSort.setComboValue($("IsSort").value);
		//combo_isSort.selectHandle=combo_UseKeydownhandler;
		//combo_isSort.keyenterHandle=combo_UseKeyenterhandler;
		//combo_isSort.attachEvent("onKeyPressed",combo_UseKeyenterhandler);
		combo_isAuto=dhtmlXComboFromStr("isAutoSendAppbill",getYesNoListObj);
		
		combo_isAuto.enableFilteringMode(true);
		
		combo_isAuto.setComboValue($("isAutoSendAppbill").value);
  	}
	
}

function FindClickHandler()
{
	//$("SortGroupFind").value=Item[1];
	//$("GroupDrCondition").value=Item[0];
	var groupName=$("SortGroupFind").value;
	if ( groupName=="")
		$("GroupDrCondition").value="";
	return  Find_click();
}
function combo_UseKeyenterhandler()
{
	
}

function combo_UseKeydownhandler()
{
  //var obj=combo_isSort;
  //var combo_isSort=obj.getActualValue();
  //alert(typeList);
  //$("IsSort").value=typeList;
}



function trim(str)
{ //删除左右两端的空格  
	return str.replace(/(^\s*)|(\s*$)/g, "");  
} 
function asynDr()
{
	var itmMast=trim( $("itmMast").value);
	var itemCat=trim( $("itemCat").value);
	if ( trim(itmMast) == "")
		$("itmMastDr").value="";
	if ( trim(itemCat) == "")
		$("itemCatDr").value="";
}

function getParam()
{
	asynDr();
	var selRowid=trim( $("selRowid").value);
	var groupName=trim ($("name").value);
	var groupID=trim($("ID").value);
	var itmMastDr=trim($("itmMastDr").value);
	//var itmMast=$("itmMast").value;
	var itemCatDr=trim($("itemCatDr").value);
	//var itemCat=$("itemCat").value;
	if ( (itmMastDr!="")&&(itemCatDr!=""))
	{
		alert("不能同时选择检查项目和医嘱子类!!");
		return "";
	}
	
	if ( (itmMastDr=="")&&(itemCatDr==""))
	{
		alert("请选择检查项目或医嘱子类!!");
		return "";
	}	
	var relationShip="";
	if ( $("exclusive").checked)
	 	relationShip="out";
	else if($("inclusive").checked)
		relationShip="in";
		
	var param=selRowid+"^"+groupName+"^"+groupID+"^"+itmMastDr+"^"+itemCatDr+"^"+relationShip;
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
	
	var propertyID = trim($("propertyID").value);
	//$("propertyID").value = propertyID;
	var itmMastDr =	trim( $("itmMastDr").value) ; 
	var itmMastDesc = trim($("ItemDesc").value) ;
	var sortGroupName =	trim($("SortGroup").value) ;
	var sortGroupId = trim($("SortGroupID").value );
	var isSort = trim($("IsSort").value);
	var examTime = trim($("ExamTime").value) ;
	var startDate = trim($("StartDate").value) ;
	var endDate = trim($("EndDate").value) ;
	var isAuto = trim($("isAutoSendAppbill").value) ;
	
	if ( itmMastDr == "")
	{
		alert("请先选择检查项目!");
		return;
	}
	if ( sortGroupName == "")
	{
		alert("请先选择组!");
		return;
	}
	var param= propertyID+"^"+itmMastDr+"^"+sortGroupId+"^"+isSort+"^"+examTime+"^"+startDate+"^"+endDate+"^"+isAuto;
	//alert(param);
	var operateFunction=document.getElementById("operateFunction").value;
	var ret=cspRunServerMethod(operateFunction,param,"M");
	if (ret!="0")
	{
	    var Info="更新检查项目信息失败:SQLCODE="+ret;
		alert(Info);
	}
	else
	{
		//var OrdCatId=document.getElementById("OrdCatId").value;
		//var OrdSubCatId=document.getElementById("OrdSubCatId").value;
		//var InputOrdName=document.getElementById("InputOrdName").value;
		//var ItemCat=document.getElementById("ItemCat").value;
        //var ItemSubCat= document.getElementById("ItemSubCat").value;
		//var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisItemSet&OrdCatId="+OrdCatId+"&OrdSubCatId="+OrdSubCatId+"&InputOrdName="+InputOrdName+"&ItemSubCat="+ItemSubCat+"&ItemCat="+ItemCat;
   		//location.href=lnk; 
   		var OrdSubCatId=$("OrdSubCatId").value; 
   		var InputOrdName=$("InputOrdName").value;
   		var ItmCatDesc=$("ItemSubCat").value;
   		var SortGroupFind=$("SortGroupFind").value;
   		var GroupDrCondition=$("GroupDrCondition").value;
   		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisExamSortPropertySet&ItemSubCat="+ItmCatDesc+"&InputOrdName="+InputOrdName+"&OrdSubCatId="+OrdSubCatId+"&SortGroupFind="+SortGroupFind+"&GroupDrCondition="+GroupDrCondition;
   		location.href=lnk; 
	}
	//alert(ret);
	
}

function selectItemCat(Info)
{
	//alert(Info);
	Item=Info.split("^");
	$("OrdSubCatId").value=Item[0];
	$("ItemSubCat").value=Item[1];
}

function selectSortGroup(Info)
{
	Item=Info.split("^");
	//alert(Item);
	$("SortGroup").value=Item[1];
	$("SortGroupID").value=Item[0];
}

function selectSortGroupFind(Info)
{
	Item=Info.split("^");
	//alert(Item);
	$("SortGroupFind").value=Item[1];
	$("GroupDrCondition").value=Item[0];
}

function SelectRowHandler()
{
	var eSrc = window.event.srcElement;
	var objtbl = $("tDHCRisExamSortPropertySet");
	var rows = objtbl.rows.length;
	var lastrowindex = rows-1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if ( !selectrow) return;
	//alert(selectrow);
	if ( SelectedRow != selectrow)
	{			
		var propertyID = trim($("tPropertyIDz"+selectrow).value);
		var itmMastDr = trim($("tItmMastDRz"+selectrow).value);
		var itmMastDesc = trim($("tItemDescz"+selectrow).innerText);
		var sortGroupId = trim($("tSortGroupIDz"+selectrow).value);
		var sortGroupName = trim($("tGroupNamez"+selectrow).innerText);
		var isSort= trim($("tIsSortz"+selectrow).innerText);
		var examTime = trim($("tExamTimez"+selectrow).innerText);
		var startDate = trim($("tStartDatez"+selectrow).innerText);
		var endDate = trim($("tEndDatez"+selectrow).innerText);
		var isAutoSend = trim($("tIsAutoSendAppbillz"+selectrow).innerText)
		
		$("propertyID").value = propertyID;
		$("itmMastDr").value = itmMastDr;
		$("ItemDesc").value = itmMastDesc;
		$("SortGroup").value = sortGroupName;
		$("SortGroupID").value = sortGroupId;
		$("IsSort").value = isSort;
		$("ExamTime").value = examTime;
		$("StartDate").value = startDate;
		$("EndDate").value = endDate;
		$("isAutoSendAppbill").value = isAutoSend;
		
		SelectedRow = selectrow;
		
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisExamRejectItemSet&InItmMastDR="+itmMastDr;
       	parent.frames['ExamRejectItemSet'].location.href=lnk; 
       	var lnk1= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisExamPrepositionItemSet&InItmMastDR="+itmMastDr;
       	parent.frames['ExamPrepositionItemSet'].location.href=lnk1;
	}
	else
	{
		$("propertyID").value = "";
		$("itmMastDr").value = "";
		$("ItemDesc").value = "";
		$("SortGroup").value = "";
		$("SortGroupID").value = "";
		$("IsSort").value = "";
		$("ExamTime").value = "";
		$("StartDate").value = "";
		$("EndDate").value = "";
		$("isAutoSendAppbill").value = "";
		
		SelectedRow="-1";
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisExamRejectItemSet&InItmMastDR=";
       	parent.frames['ExamRejectItemSet'].location.href=lnk; 
       	var lnk1= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisExamPrepositionItemSet&InItmMastDR=";
       	parent.frames['ExamPrepositionItemSet'].location.href=lnk1;
	}

}


document.body.onload = BodyLoadHandler;


