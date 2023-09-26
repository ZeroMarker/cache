//DHCRisExamGroupSet.js
var SelectedRow="-1"

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
	
	var inclusiveObj=$("inclusive");
	if (inclusiveObj)
		inclusiveObj.onclick=inclusive_click;
		
	var exclusiveObj=$("exclusive");
	if (exclusiveObj)
		exclusiveObj.onclick=exclusive_click;
	
}
function inclusive_click()
{
	//alert($("inclusive").checked);
	if ($("inclusive").checked )
		$("exclusive").checked=false;
}

function exclusive_click()
{
	//alert($("exclusive").checked);
	if ($("exclusive").checked )
		$("inclusive").checked=false;
}

function trim(str)
{ 
	//ɾ���������˵Ŀո�  
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
		alert("����ͬʱѡ������Ŀ��ҽ������!!");
		return "";
	}
	
	if ( (itmMastDr=="")&&(itemCatDr==""))
	{
		//alert("��ѡ������Ŀ��ҽ������!!");
		//return "";
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

function selectItemCat(Info)
{
	//alert(Info);
	Item=Info.split("^");
	$("itemCatDr").value=Item[0];
	$("itemCat").value=Item[1];
}

function selectItmMast(Info)
{
	//alert(Info);
	Item=Info.split("^");
	$("itmMastDr").value=Item[1];
	$("itmMast").value=Item[0];
}



function SelectRowHandler()
{
	var eSrc = window.event.srcElement;
	var objtbl = $("tDHCRisExamGroupSet");
	var rows = objtbl.rows.length;
	var lastrowindex = rows-1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if ( !selectrow) return;
	//alert(selectrow);
	if ( SelectedRow != selectrow)
	{	
		var gourpDr = trim($("tRowidz"+selectrow).value)
		var itemCatDr = trim($("tItemCatDrz"+selectrow).value)
		$("selRowid").value = gourpDr;	
		$("name").value = trim($("tGroupNamez"+selectrow).innerText);
		$("ID").value = trim($("tGroupCodez"+selectrow).innerText);
		
		$("itmMast").value = trim($("tItemMastDescz"+selectrow).innerText);
		$("itemCat").value = trim($("tItemCatDescz"+selectrow).innerText);
		
		//tItemMastDR
		$("itmMastDr").value = trim($("tItemMastDRz"+selectrow).value);
		$("itemCatDr").value = itemCatDr;
		//alert("@"+$("itmMastDr").value+"@"+$("itemCatDr").value+"@");
		var relation = trim($("trelationShipz"+selectrow).innerText);
		//alert("@"+relation+"@");
		if ( relation == "����")
		{
		  	$("inclusive").checked = true;
		  	$("exclusive").checked = false;
		}
		else if ( relation == "������")
		{
			$("exclusive").checked = true;
			$("inclusive").checked = false;
		}
		else
		{
			$("inclusive").checked = false;
			$("exclusive").checked = false;
		}
		SelectedRow = selectrow;
		
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisExamGroupItemSet&groupDR="+gourpDr+"&itemCatDr="+itemCatDr;
       	parent.frames['ExamGroupItemSet'].location.href=lnk; 
	}
	else
	{
		$("selRowid").value = "";	
		$("name").value = "";
		$("ID").value = "";
		
		$("itmMast").value = "";
		$("itemCat").value = "";
		
		//tItemMastDR
		$("itmMastDr").value = "";
		$("itemCatDr").value = "";
		
		
		$("inclusive").checked = false;
		$("exclusive").checked = false;
		
		SelectedRow="-1";
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisExamGroupItemSet&groupDR="+"&itemCatDr=";
       	parent.frames['ExamGroupItemSet'].location.href=lnk; 
	}

}


document.body.onload = BodyLoadHandler;


