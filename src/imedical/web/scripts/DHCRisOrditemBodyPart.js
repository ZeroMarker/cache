//DHCRisOrditemBodyPart.js
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
	 var OrdCat=document.getElementById("OrdCat").value;
	 var ItemCat=document.getElementById("ItemCat").value;
	 var OrdName=document.getElementById("OrdName").value;
	 var ExclusionFlag=document.getElementById("ExclusionFlag").value;
	 	 
	 
	 if(OrdCat=="")
	 {
		 alert("ҽ�����಻��Ϊ��!");
		 return;
	 }
	 
	 if(ItemCat=="")
	 {
		 alert("ҽ�����಻��Ϊ��!");
		 return;
	 }
	 
	 if(OrdName=="")
	 {
		 alert("ҽ����Ŀ����Ϊ��!");
		 return;
	 }
	 
	 
	 var ArcItemID=document.getElementById("ArcItemID").value;
	 var BodyPartID=document.getElementById("BodyPartID").value;
    
	 var Info=Rowid+"^"+ArcItemID+"^"+BodyPartID+"^"+ExclusionFlag;
	 SetOeItemBoadySet(Info,OperateCode);
}



function Update_click()
{
	
	 var OperateCode="U";
	 var SelRowid=document.getElementById("SelRowid").value;
	
	 if (SelRowid=="")
	 {
		alert("δѡ���¼���ܸ���!")
		return;
		
	 }
	
	var OrdCat=document.getElementById("OrdCat").value;
	var ItemCat=document.getElementById("ItemCat").value;
	var OrdName=document.getElementById("OrdName").value;
	var ExclusionFlag=document.getElementById("ExclusionFlag").value; 	 
	 
	 if(OrdCat=="")
	 {
		 alert("ҽ�����಻��Ϊ��!");
		 return;
	 }
	 
	 if(ItemCat=="")
	 {
		 alert("ҽ�����಻��Ϊ��!");
		 return;
	 }
	 
	 if(OrdName=="")
	 {
		 alert("ҽ����Ŀ����Ϊ��!");
		 return;
	 }
	 
	 
	 var ArcItemID=document.getElementById("ArcItemID").value;
	 var BodyPartID=document.getElementById("BodyPartID").value;
    
	 var Info=SelRowid+"^"+ArcItemID+"^"+BodyPartID+"^"+ExclusionFlag;
	 SetOeItemBoadySet(Info,OperateCode);
	
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
	
	var str="^^";
    var Info=SelRowid+str;
    SetOeItemBoadySet(Info,OperateCode);
	
}


function Query_click()
{
	var OrdCatID=document.getElementById("OrdCatID").value;
	var ItemCatID=document.getElementById("ItemCatID").value;
	var ArcItemID=document.getElementById("ArcItemID").value;
	var BodyPartID=document.getElementById("BodyPartID").value
	
	var Info=OrdCatID+"^"+ItemCatID+"^"+ArcItemID+"^"+BodyPartID;
	document.getElementById("Info").value=Info;
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisOrditemBodyPart"+"&Info="+Info;
	
}


function SelectRowHandler()
{
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisOrditemBodyPart');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;

    
 	var SelRowid=document.getElementById("TRowidz"+selectrow).value;
	var OrdCat=document.getElementById("TOrdCatz"+selectrow).innerText;
	var ItemCat=document.getElementById("TItemCatz"+selectrow).innerText;
	var OrdName=document.getElementById("TOrdNamez"+selectrow).innerText;
	var BodyPart=document.getElementById("TBodyPartz"+selectrow).innerText;
	var OrdCatID=document.getElementById("TOrdCatIDz"+selectrow).value;
	var ItemCatID=document.getElementById("TItemCatIDz"+selectrow).value;
	var ArcItemID=document.getElementById("TArcItemIDz"+selectrow).value;
	var ExclusionFlag=document.getElementById("TExclusionFlagz"+selectrow).innerText;
	var BodyPartID=document.getElementById("TBodyPartIDz"+selectrow).value;
	
	
	
	var SeleRowidObj=document.getElementById("SelRowid");
	if (SeleRowidObj)
	{
		SeleRowidObj.value=SelRowid;
	}
	
	var OrdCatObj=document.getElementById("OrdCat");
	if (OrdCatObj)
	{
		OrdCatObj.value=OrdCat;
	}
	var ItemCatObj=document.getElementById("ItemCat");
	if (ItemCatObj)
	{
		ItemCatObj.value=ItemCat;
	}
	var OrdNameObj=document.getElementById("OrdName");
	if (OrdNameObj)
	{
		OrdNameObj.value=OrdName;
	}
	var BodyPartObj=document.getElementById("BodyPart");
	if (BodyPartObj)
	{
		BodyPartObj.value=BodyPart;
	}
	
	var BodyIDObj=document.getElementById("BodyPartID");
	if(BodyIDObj)
	{
		BodyIDObj.value=BodyPartID;
	}
	
	var OrdCatIDObj=document.getElementById("OrdCatID");
	if (OrdCatIDObj)
	{
		OrdCatIDObj.value=OrdCatID;
	}
	var ItemCatIDObj=document.getElementById("ItemCatID");
	if (ItemCatIDObj)
	{
		ItemCatIDObj.value=ItemCatID;
	}
	var ArcItemIDObj=document.getElementById("ArcItemID");
	if (ArcItemIDObj)
	{
		ArcItemIDObj.value=ArcItemID;
	}
	var ExclusionFlagObj=document.getElementById("ExclusionFlag");
	if (ExclusionFlagObj)
	{
		ExclusionFlagObj.value=ExclusionFlag;
	}
	
}




function SetOeItemBoadySet(Info,OperateCode)
{
	var SetOeItemBoadySetFun=document.getElementById("SetOeItemBoadySet").value;
	var value=cspRunServerMethod(SetOeItemBoadySetFun,Info,OperateCode);
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
		/*var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisOrditemBodyPart";
   		location.href=lnk; */
   		window.location.reload();
	}
	
}


function GetOrdCatInfo(Info)
{
  Item=Info.split("^");
  document.getElementById("OrdCat").value=Item[1];
  document.getElementById("OrdCatID").value=Item[0]; 
	
}

function GetSelOrdSubCat(Info)
{
  Items=Info.split("^");
  document.getElementById("ItemCat").value=Items[1];
  document.getElementById("ItemCatID").value=Items[0]; 
	
}

function SelectOrdItem(Info)
{
  Item=Info.split("^");
  document.getElementById("OrdName").value=Item[1];
  document.getElementById("ArcItemID").value=Item[0]; 
	
}

function GetBodyPartInfo(Info)
{
  Item=Info.split("^");
  document.getElementById("BodyPart").value=Item[1];
  document.getElementById("BodyPartID").value=Item[0];
}

document.body.onload = BodyLoadHandler;