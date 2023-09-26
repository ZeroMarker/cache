
//DHCRisOrdCatAppSet.js
//sunyi 2011-10-16
var SelectedRow="-1"

function BodyLoadHandler()
{

	var AddObj=document.getElementById("Add");
	if (AddObj)
	{
		AddObj.onclick=Add_click;
	}
	
	var DeleteObj=document.getElementById("Delete");
	if (DeleteObj)
	{
		DeleteObj.onclick=Delete_click;
	}

}

function Add_click()
{
	 var OperateCode="I";
	 var Info=GetValue();
	 
 
	 if(Info=="-1")
	 {
		 var error="请检查申请单样式ID或医嘱大类是否为空!";
		 alert(error);
		 return ;
	 }
	 	orddoc=parent.frames["DHCRisOrdAppSet"].document;
	var OrdCat=orddoc.getElementById("ItemCat").value;
    var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisOrdCatAppSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	 for (i=1;i<rows;i++)
    {   
	    var OrdCatDesc=document.getElementById("OrdCatz"+i).innerText;
	    //alert(OrdCatDesc)
	    if (OrdCatDesc==OrdCat)
	    {
		    alert("医嘱大类已存在,不能重复添加");
		    return;
	    }
	}
	SetOrdCatAppSet(Info,OperateCode);
}



function Delete_click()
{
    var OperateCode="D"
	var SelRowid=document.getElementById("SelRowid").value;
	
	if (SelRowid=="")
	{
		alert("未选择记录不能删除!")
		return;
		
	}
	
	var str="^^";
    var Info=SelRowid+str;
    SetOrdCatAppSet(Info,OperateCode);
	
}



function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisOrdCatAppSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

    var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	if (SelectedRow!=selectrow)
	{
	 	var SelRowid=document.getElementById("Rowidz"+selectrow).value;
	 	var OrdCatDesc=document.getElementById("OrdCatz"+selectrow).innerText;
		var ComponentID=document.getElementById("AppShapeIDz"+selectrow).innerText;
		var AppShapeRowid=document.getElementById("AppShapeRowidz"+selectrow).value;
		var ComponentName=document.getElementById("ComponentNamez"+selectrow).value;
		var OrdCatDR=document.getElementById("OrdCatDRz"+selectrow).value;
	
		orddoc=parent.frames["DHCRisOrdAppSet"].document;
	
		var SeleRowidObj=document.getElementById("SelRowid");
		if (SeleRowidObj)
		{
			SeleRowidObj.value=SelRowid;
		    orddoc.getElementById("ItemCatID").value=OrdCatDR;
	   
		}
	
		var ItemCatObj=orddoc.getElementById("ItemCat");
		if (ItemCatObj)
		{
			ItemCatObj.value=OrdCatDesc;
		}
	
		var AppshapeObj=orddoc.getElementById("Appshape");
		if(AppshapeObj)
		{
		    AppshapeObj.value=ComponentID;
		}
	
		var AppShapeRowidObj=orddoc.getElementById("AppShapeRowid");
		if(AppShapeRowidObj)
		{
		    AppShapeRowidObj.value=AppShapeRowid;
		}
	
		var AppShapeNameObj=orddoc.getElementById("ComponentName");
		if(AppShapeNameObj);
		{
		    AppShapeNameObj.value=ComponentName;
		}
		
		SelectedRow = selectrow;
	}else
	{
		SelectedRow="-1"
		orddoc=parent.frames["DHCRisOrdAppSet"].document;
		orddoc.getElementById("ItemCatID").value="";
		orddoc.getElementById("ItemCat").value="";
		orddoc.getElementById("Appshape").value="";
		orddoc.getElementById("AppShapeRowid").value="";
		orddoc.getElementById("ComponentName").value="";
	}
}




function SetOrdCatAppSet(Info,OperateCode)
{
	var SetOrdCatAppSetFun=document.getElementById("SetOrdCatAppSet").value;
	var value=cspRunServerMethod(SetOrdCatAppSetFun,Info,OperateCode);
	if (value!="0")
	{  
	     if(OperateCode=="I")
	     {
		    var Info="增加失败:SQLCODE="+value;
		 }
	     if(OperateCode=="U")
	     {
		    var Info="更新失败:SQLCODE="+value;
		 }
		 else
		 {
			var Info="删除失败:SQLCODE="+value;
	     }	 
		
	}
	else
	{   
	    ClearData();
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisOrdCatAppSet";
   		location.href=lnk;
   		
	}
	
}


function GetValue()
{
	orddoc=parent.frames["DHCRisOrdAppSet"].document;
	var Rowid="",Info=""
	var OrdCatDR=orddoc.getElementById("ItemCatID").value;
	var AppShapeID=orddoc.getElementById("AppShapeRowid").value;
	
	if((OrdCatDR!="")&&(AppShapeID!=""))
	{
	   Info=Rowid+"^"+OrdCatDR+"^"+AppShapeID;
	   return Info;
	}
	else
	{
	   return -1;	
	}

}


function ClearData()
{
	orddoc=parent.frames["DHCRisOrdAppSet"].document;
	var SeleRowidObj=document.getElementById("SelRowid");
	if (SeleRowidObj)
	{
		SeleRowidObj.value="";
	    orddoc.getElementById("ItemCatID").value="";
	}
	
	var ItemCatObj=orddoc.getElementById("ItemCat");
	if (ItemCatObj)
	{
		ItemCatObj.value="";
	}
	
	var AppshapeObj=orddoc.getElementById("Appshape");
	if(AppshapeObj)
	{
	    AppshapeObj.value="";
	}
	
	var AppShapeRowidObj=orddoc.getElementById("AppShapeRowid");
	if(AppShapeRowidObj)
	{
	    AppShapeRowidObj.value="";
	}
	
	var AppShapeNameObj=orddoc.getElementById("ComponentName");
	if(AppShapeNameObj)
	{
	    AppShapeNameObj.value="";
	}
}

document.body.onload = BodyLoadHandler;

