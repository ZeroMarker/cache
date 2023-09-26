var SelectedRow=0
function BodyLoadHandler()
{	
	var obj;
	
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	
	obj=document.getElementById("BDelete");
	if (obj){obj.onclick=BDelete_Click;
			//obj.disabled=true;
	}
	
}
function BUpdate_Click()
{
	var obj;
	obj=document.getElementById("BUpdate");
	if (obj&&obj.disabled){return false;}
	obj=document.getElementById("RowId");
	if (obj) var RowId=obj.value;
	obj=document.getElementById("EDId");
	if (obj) var EDId=obj.value;
	obj=document.getElementById("Alias");
	if (obj) var Alias=obj.value;
	if (Alias=="")
	{
		alert(t["AliasNeed"]);
		return false;
	}
	var DataStr=RowId+"^"+EDId+"^"+Alias
	Update(DataStr,"0")
}
function BDelete_Click()
{
	if(SelectedRow==0){
		alert("请选择待删除的记录");
		return false;
	}

	var obj=document.getElementById("RowId");
	if (obj) var RowId=obj.value;
	Update(RowId,"1")
}
function Update(DataStr,Type)
{
	var encmethObj=document.getElementById("UpdateBox");
	if (encmethObj) var encmeth=encmethObj.value;
	var flag=cspRunServerMethod(encmeth,DataStr,Type);
	if (flag==0)
	{
		window.location.reload();
	}
	else
	{
		alert(t[flag])
	}
}
function SelectRowHandler(){  
	var eSrc=window.event.srcElement;
	
	var objtbl=document.getElementById('tDHCPEEILLSAlias');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	
	if (selectrow!=SelectedRow) {
	SelectedRow=selectrow;
	var obj;
	obj=document.getElementById("BDelete");
	if (obj) obj.disabled=false;
	obj=document.getElementById("TRowIDz"+SelectedRow);
	if (obj) var RowId=obj.value;
	obj=document.getElementById("RowId");
	if (obj) obj.value=RowId;
	obj=document.getElementById("TAliasz"+SelectedRow);
	if (obj) var RowId=obj.innerText;
	obj=document.getElementById("Alias");
	if (obj) obj.value=RowId;
	}
	else { SelectedRow=0;
	var obj;
	obj=document.getElementById("BDelete");
	if (obj) obj.disabled=true;
	obj=document.getElementById("RowId");
	if (obj) obj.value="";
	obj=document.getElementById("Alias");
	if (obj) obj.value="";}
	
}
document.body.onload = BodyLoadHandler;