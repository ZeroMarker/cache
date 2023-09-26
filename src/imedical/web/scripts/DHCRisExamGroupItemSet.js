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
	
}


function trim(str)
{ //ɾ���������˵Ŀո�  
	return str.replace(/(^\s*)|(\s*$)/g, "");  
} 


function getParam()
{	
	var itmMastDr=trim($("itmMastDr").value);
	if ( (itmMastDr==""))
	{
		alert("��ѡ������Ŀ!!");
		return "";
	}	
		
	var param=$("examGroupItemDR").value+"^"+$("groupDR").value+"^"+itmMastDr;
	//alert(param)
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
	//alert(param)
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
	var objtbl = $("tDHCRisExamGroupItemSet");
	var rows = objtbl.rows.length;
	var lastrowindex = rows-1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if ( !selectrow) return;
	//alert(selectrow);
	if ( SelectedRow != selectrow)
	{	
		//alert(	trim($("tItmMastDrz"+selectrow).innerText));
		//alert(trim($("tItemMastDRz"+selectrow).value));
		//alert(trim($("tExamGroupItemDrz"+selectrow).value));
		$("itmMast").value = trim($("tItmMastDrz"+selectrow).innerText);		
		$("itmMastDr").value = trim($("tItemMastDRz"+selectrow).value);		
		$("examGroupItemDR").value = trim($("tExamGroupItemDrz"+selectrow).value);

		SelectedRow = selectrow;
	}
	else
	{
		SelectedRow="-1";
		$("itmMast").value = "";		
		$("itmMastDr").value = "";		
		$("examGroupItemDR").value = "";
		//alert("-1");
	}

}


document.body.onload = BodyLoadHandler;


