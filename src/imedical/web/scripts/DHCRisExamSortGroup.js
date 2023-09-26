//DHCRisExamSortGroup.js
var SelectedRow="-1"

var $=function(Id){
	return document.getElementById(Id);
}


function BodyLoadHandler()
{
	
	var AddObj=$("add");
	if (AddObj)
	{
		//alert("2");
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
	var rowid = trim($("Rowid").value) ;
	var groupCode = trim($("GroupCode").value);
	var groupName = trim($("GroupName").value);
	var groupDesc = trim($("GroupDesc").value);
		
	
	if ( groupCode=="")
	{
		alert("���벻��Ϊ��!!");
		return "";
	}
	
	var param=rowid+"^"+groupName+"^"+groupCode+"^"+groupDesc;
	//alert(param)
	return param;
	
}
function Add_click()
{
	
	//alert(param);
	var param = getParam();
	if ( param=="") return;
	var operateFunction=$("operateFunction").value;
	//alert(operateFunction);
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
	//alert(param.split("^")[0]);
	var mradm=tkMakeServerCall("web.DHCRisExamScheSet","IsCanDeleGroup",param.split("^")[0]);
	//alert(mradm);
	if(mradm==="N"){
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
	else
	{
		alert("�ѱ�ʹ�ò�����ɾ��");
		
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
	$("groupDr").value=Item[0];
	$("examGroup").value=Item[1];
}



function SelectRowHandler()
{
	var eSrc = window.event.srcElement;
	var objtbl = $("tDHCRisExamSortGroup");
	var rows = objtbl.rows.length;
	var lastrowindex = rows-1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if ( !selectrow) return;
	//alert(selectrow);
	if ( SelectedRow != selectrow)
	{	
		var rowid = trim($("tRowidz"+selectrow).value);
		var groupDesc = trim($("tGroupDescz"+selectrow).innerText);
		var groupCode = trim($("tGroupCodez"+selectrow).innerText);
		var groupName = trim($("tGroupNamez"+selectrow).innerText);
		
		
		$("Rowid").value = rowid;	
		$("GroupName").value = groupName;
		$("GroupDesc").value = groupDesc;
		
		$("GroupCode").value = groupCode;	
		

		SelectedRow = selectrow;
	}
	else
	{
		SelectedRow="-1";
		$("Rowid").value = "";	
		$("GroupName").value = "";
		$("GroupDesc").value = "";
		
		$("GroupCode").value = "";
		//alert("-1");
	}

}


document.body.onload = BodyLoadHandler;


