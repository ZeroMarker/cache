
//DHCRisAppFieldMatch.js
//2011-10-18 sunyi
var CurrentSel=0,TypeIndex

function BodyLoadHandler()
{

	var AddObj=document.getElementById("Add");
	if (AddObj)
	{
		AddObj.onclick=Add_click;
	}
	
	var ModiObj=document.getElementById("Update");
	if (ModiObj)
	{
		ModiObj.onclick=Update_click;
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
	 var Rowid="";
	 
	 var AppShapeName=document.getElementById("AppShapeName").value;
	 var AppFieldName=document.getElementById("AppFieldName").value;
	 	 
	 
	 if(AppShapeName=="")
	 {
		 alert("���뵥ID����Ϊ��!");
		 return;
	 }
	 
	 if(AppFieldName=="")
	 {
		 alert("�ֶ����Ʋ���Ϊ��!");
		 return;
	 }
    

	 var AppShapeID=document.getElementById("AppShapeID").value;
	 var AppFieldDR=document.getElementById("AppFieldDR").value;
	 var Index=document.getElementById("AppIndex").value;
	     Index=Number(Index);
	  if(Index=="")
	 {
		 alert("��Ų���Ϊ��!");
		 return;
	 }
	 var ArcItmRowid=document.getElementById("ArcItmRowid").value;
	 var eSrc=window.event.srcElement;
	 var objtbl=document.getElementById('tDHCRisAppFieldMatch');
	 var rows=objtbl.rows.length;
	 var lastrowindex=rows - 1;
	
	 var rowObj=getRow(eSrc);
	 var selectrow=rowObj.rowIndex;

for (i=1;i<rows;i++)
    {   
	    //var ItemCatDesc=document.getElementById("ItemCatz"+i).innerText;
	    var AppShapeNameL=document.getElementById("TAppShapeNamez"+i).innerText;
	    var AppFieldNameL=document.getElementById("TAppFieldNamez"+i).innerText;
	    //alert(ItmMastDesc)
	    if ((AppShapeNameL==AppShapeName)&&(AppFieldNameL==AppFieldName))
	    {
		    alert("�ü�¼�Ѵ���,�����ظ����");
		    return;
	    }
	} 
	 
    
	 var Info=Rowid+"^"+AppShapeID+"^"+AppFieldDR+"^"+Index+"^"+ArcItmRowid;
	 SetApplicationShapeField(Info,OperateCode);
}



function Update_click()
{
	
	 var OperateCode="U";
	 var SelRowid=document.getElementById("SelRowid").value;
	
	 var AppShapeName=document.getElementById("AppShapeName").value;
	 var AppFieldName=document.getElementById("AppFieldName").value;
	 	 
	 
	 if(AppShapeName=="")
	 {
		 alert("���뵥ID����Ϊ��!");
		 return;
	 }
	 
	 if(AppFieldName=="")
	 {
		 alert("�ֶ����Ʋ���Ϊ��!");
		 return;
	 }
    

	 var AppShapeID=document.getElementById("AppShapeID").value;
	 var AppFieldDR=document.getElementById("AppFieldDR").value;
	 var Index=document.getElementById("AppIndex").value;
	     Index=Number(Index);
	 if(Index=="")
	 {
		 alert("��Ų���Ϊ��!");
		 return;
	 }
	 var ArcItmRowid=document.getElementById("ArcItmRowid").value;
	  
	 
    
	 var Info=SelRowid+"^"+AppShapeID+"^"+AppFieldDR+"^"+Index+"^"+ArcItmRowid;
	 SetApplicationShapeField(Info,OperateCode);
	
}




function Delete_click()
{
    var OperateCode="D"
	var SelRowid=document.getElementById("SelRowid").value;
	
	if (SelRowid=="")
	{
		alert("δѡ���¼����ɾ��!")
		return;
		
	}
	
	var str="^^^^";
    var Info=SelRowid+str;
    SetApplicationShapeField(Info,OperateCode);
	
}


function Query_click()
{
	
	var AppShapeID=document.getElementById("AppShapeID").value;
	var ArcItmRowid=document.getElementById("ArcItmRowid").value;
	var AppFieldDR=document.getElementById("AppFieldDR").value;
	
	var Info=AppShapeID+"^"+ArcItmRowid+"^"+AppFieldDR;
	document.getElementById("Info").value=Info;
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisAppFieldMatch"+"&Info="+Info;
	
}


function SelectRowHandler()
{
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisAppFieldMatch');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;

    
 	var SelRowid=document.getElementById("TRowidz"+selectrow).value;
	var AppShapeName=document.getElementById("TAppShapeNamez"+selectrow).innerText;
	var AppFieldName=document.getElementById("TAppFieldNamez"+selectrow).innerText;
	var Index=document.getElementById("TAppIndexz"+selectrow).innerText;
	var ArcItemMast=document.getElementById("TArcItemMastz"+selectrow).innerText;
	var ArcItmRowid=document.getElementById("TArcItmRowidz"+selectrow).value;
	var AppFieldDR=document.getElementById("TAppFieldDRz"+selectrow).value;
	var AppShapeID=document.getElementById("TAppShapeIDz"+selectrow).value;
	
	
	
	var SeleRowidObj=document.getElementById("SelRowid");
	if (SeleRowidObj)
	{
		SeleRowidObj.value=SelRowid;
	}
	
	var AppShapeNameObj=document.getElementById("AppShapeName");
	if (AppShapeNameObj)
	{
		AppShapeNameObj.value=AppShapeName;
	}
	
	var AppFieldNameObj=document.getElementById("AppFieldName");
	if (AppFieldNameObj)
	{
		AppFieldNameObj.value=AppFieldName;
	}
	var IndexObj=document.getElementById("AppIndex");
	if (IndexObj)
	{
		IndexObj.value=Index;
	}
	
	
	var ArcItemMastObj=document.getElementById("ArcItemMast");
	if (ArcItemMastObj)
	{
		ArcItemMastObj.value=ArcItemMast;
	}
	var ArcItmRowidObj=document.getElementById("ArcItmRowid");
	if (ArcItmRowidObj)
	{
		ArcItmRowidObj.value=ArcItmRowid;
	}
	var AppFieldDRObj=document.getElementById("AppFieldDR");
	if (AppFieldDRObj)
	{
		AppFieldDRObj.value=AppFieldDR;
	}
	var AppShapeIDObj=document.getElementById("AppShapeID");
	if (AppShapeIDObj)
	{
		AppShapeIDObj.value=AppShapeID;
	}
	
	
}




function SetApplicationShapeField(Info,OperateCode)
{
	var SetApplicationShapeFieldFun=document.getElementById("SetApplicationShapeField").value;
	var value=cspRunServerMethod(SetApplicationShapeFieldFun,Info,OperateCode);
	if (value!="0")
	{  
	     if(OperateCode=="I")
	     {
		    var Info="����ʧ��:SQLCODE="+value;
		 }
	     if(OperateCode=="U")
	     {
		    var Info="����ʧ��:SQLCODE="+value;
		 }
		 else
		 {
			var Info="ɾ��ʧ��:SQLCODE="+value;
	     }	 
		
	     alert(Info);
	}
	else
	{   
		//var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisAppFieldMatch";
   		//location.href=lnk; 
   		window.location.reload()
	}
	
}



function GetAppShapeInfo(Info)
{
  Item=Info.split("^");
  document.getElementById("AppShapeName").value=Item[1];
  document.getElementById("AppShapeID").value=Item[0]; 
	
}

function GetAppAllField(Info)
{
  Items=Info.split("^");
  document.getElementById("AppFieldName").value=Items[1];
  document.getElementById("AppFieldDR").value=Items[0]; 
	
}

function GetOrdItemInfo(Info)
{
  Item=Info.split("^");
  document.getElementById("ArcItmRowid").value=Item[1];
  document.getElementById("ArcItemMast").value=Item[0]; 
	
}

document.body.onload = BodyLoadHandler;
