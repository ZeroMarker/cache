
//DHCRisItemMastAppSet.js
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
    var QueryObj=document.getElementById("Query");
	if(QueryObj)
	{
		QueryObj.onclick=Query_click;
	}
}

function Add_click()
{
	 var OperateCode="I";
	 var Info=GetValue();
 
	 if(Info=="-1")
	 {
		 var error="请检查申请单样式ID或医嘱项目是否为空!";
		 alert(error);
		 return ;
	 }
	 orddoc=parent.frames["DHCRisOrdAppSet"].document;
	var OrdName=orddoc.getElementById("OrdName").value;
	//alert(OrdName)
    var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisItemMastAppSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	 for (i=1;i<rows;i++)
    {   
	    var ItmMastDesc=document.getElementById("ItmMastz"+i).innerText;
	    //alert(ItmMastDesc)
	    if (ItmMastDesc==OrdName)
	    {
		    alert("医嘱项目已存在,不能重复添加");
		    return;
	    }
	}
	SetItmMastAppSet(Info,OperateCode);
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
    SetItmMastAppSet(Info,OperateCode);
	
}



function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisItemMastAppSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
    
    if (!selectrow) return;
	if (SelectedRow!=selectrow)
	{
	 	var SelRowid=document.getElementById("Rowidz"+selectrow).value;
	 	var ItmMastDesc=document.getElementById("ItmMastz"+selectrow).innerText;
		var ComponentID=document.getElementById("AppShapez"+selectrow).innerText;
		var AppShapeRowid=document.getElementById("AppShapeRowidz"+selectrow).value;
	
		var ComponentName=document.getElementById("ComponentNamez"+selectrow).value;
		var ItmMastDR=document.getElementById("ItmMastDRz"+selectrow).value;
	
		orddoc=parent.frames["DHCRisOrdAppSet"].document;
	
		var SeleRowidObj=document.getElementById("SelRowid");
		if (SeleRowidObj)
		{
			SeleRowidObj.value=SelRowid;
		    orddoc.getElementById("ArcItemID").value=ItmMastDR;
		}
	
		var OrdNameObj=orddoc.getElementById("OrdName");
		if (OrdNameObj)
		{
			OrdNameObj.value=ItmMastDesc;
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
		if(AppShapeNameObj)
		{
		    AppShapeNameObj.value=ComponentName;
		}
		SelectedRow = selectrow;
	}else
	{
		SelectedRow="-1"
		orddoc=parent.frames["DHCRisOrdAppSet"].document;
		orddoc.getElementById("OrdName").value="";
		orddoc.getElementById("ArcItemID").value="";
		orddoc.getElementById("Appshape").value="";
		orddoc.getElementById("AppShapeRowid").value="";
		orddoc.getElementById("ComponentName").value="";
		
	}
}




function SetItmMastAppSet(Info,OperateCode)
{
	var SetItmMastAppSetFun=document.getElementById("SetItmMastAppSet").value;
	var value=cspRunServerMethod(SetItmMastAppSetFun,Info,OperateCode);
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
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisItemMastAppSet";
   		location.href=lnk;
	}
	
}


function GetValue()
{
	orddoc=parent.frames["DHCRisOrdAppSet"].document;
	var Rowid="",Info=""
	var ArcItemDR=orddoc.getElementById("ArcItemID").value;
	var AppShapeID=orddoc.getElementById("AppShapeRowid").value;
	
	if((ArcItemDR!="")&&(AppShapeID!=""))
	{
	   Info=Rowid+"^"+ ArcItemDR+"^"+AppShapeID;
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
	    orddoc.getElementById("ArcItemID").value="";
	}
	
	var OrdNameObj=orddoc.getElementById("OrdName");
	if (OrdNameObj)
	{
		OrdNameObj.value="";
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

function GetOrdItemInfo(Info)
{
  Item=Info.split("^");
  document.getElementById("QArcItmRowid").value=Item[1];
  document.getElementById("QArcItemMast").value=Item[0]; 
	
}

function Query_click()
{
	var QArcItmRowid=document.getElementById("QArcItmRowid").value;
	var QArcItemMast=document.getElementById("QArcItemMast").value;
	if (QArcItemMast=="")
	{
		QArcItmRowid="";
	}
	var Info=QArcItmRowid+"^";
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisItemMastAppSet"+"&Info="+Info;
	
}
document.body.onload = BodyLoadHandler;
