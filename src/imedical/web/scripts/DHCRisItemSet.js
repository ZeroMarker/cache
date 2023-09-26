//DHCRisItemSet.js

function BodyLoadHandler()
{
	//alert("Load");
	var ModiObj=document.getElementById("Modi");
	if (ModiObj)
	{
		ModiObj.onclick=Modi_click;
	}
	
	// 获取预约方法
	GetBookMethod();
	
	//获取服务组
	GetServiceGroup();
}
// 选择医嘱大类
function SelectOrdCat(Info)
{
	Item=Info.split("^");
    document.getElementById("ItemCat").value=Item[1];
    document.getElementById("OrdCatId").value=Item[0];
}

//选择子类
function SelectOrdSubCat(Info)
{
	Item=Info.split("^");
    document.getElementById("ItemSubCat").value=Item[1];
    document.getElementById("OrdSubCatId").value=Item[0];

}


function GetBookMethod()
{
	lBookedMethodObj=document.getElementById("lBookedMethod");
    if (lBookedMethodObj)
    {
	 	combo("lBookedMethod");
	}
	
}


function Trim(x) {
  return x.replace(/^\s+|\s+$/gm,'');
}

function Modi_click()
{
	var ArcItemId,AppointMethodId,IsEmpty,InputFee;
	var Location,Note,ServiceGroupId;
	var AppLocation,Telphone;
	
	var ArcItemIdObj=document.getElementById("SelArcItemId");
	if (ArcItemIdObj)
	{
		ArcItemId=ArcItemIdObj.value;
	}
	
	if (ArcItemId=="")
	{
		alert("请先选择一条记录!");
		return;
	}
	
	var lBookedMethodObj=document.getElementById("lBookedMethod");
	if (lBookedMethodObj)
	{
		AppointMethodId=cTrim(lBookedMethodObj.value);
		//alert(lBookedMethodObj.text);
		if (AppointMethodId=="")
		{
			alert("请先选择预约方法!");
			return;
		}
		appointMethodText=lBookedMethodObj.options[lBookedMethodObj.selectedIndex].innerText;
		//alert(appointMethodText);
	}
	
	var ckEmptyObj=document.getElementById("ckEmpty");
	if (ckEmptyObj)
	{
		if (ckEmptyObj.checked)
		{
			IsEmpty="Y";
		}
		else
		{
			IsEmpty="N";
		}
	}
	
    /*
	var ckInputFeeObj=document.getElementById("ckInputFee");
	if (ckInputFeeObj)
	{
	    if  (ckInputFeeObj.checked)
	    {
			InputFee="Y"
	    }
	    else 
	    {
		    InputFee="N"
	    }
	}
	
	var ExclusionObj=document.getElementById("IsExclusion");
	if (ExclusionObj)
	{
		if (ExclusionObj.checked)
		{
			Exclusion="Y"	
		}
		else
        {
	        Exclusion="N"
	    }
           				
	}
	

	var SelLocationObj=document.getElementById("SelLocation");
	if (SelLocationObj)
	{
		Location=cTrim(SelLocationObj.value,0)	
	}
	*/
	
	var InputNoteObj=document.getElementById("InputNote");
	if (InputNoteObj)
	{
		Note=cTrim(InputNoteObj.value,0)
	}
	
	/*
	var InServiceGroupNameObj=document.getElementById("InServiceGroupName");
	if (InServiceGroupNameObj)
	{
		ServiceGroupId=InServiceGroupNameObj.value;
	}
	
	var InTelephoneObj=document.getElementById("InTelephone");
	if (InTelephoneObj)
	{
		Telphone=cTrim(InTelephoneObj.value,0)
	}
	
	var InAppLocationObj=document.getElementById("InAppLocation");
	if (InAppLocationObj)
	{
		AppLocation=cTrim(InAppLocationObj.value,0)
	}
	*/
	
	var ItemUseTimeObj=document.getElementById("ItemUseTime");
	if (ItemUseTimeObj)
	{
		ItemUseTime=Trim(ItemUseTimeObj.value)	
	}
	

	//var Info=ArcItemId+"^"+AppointMethodId+"^"+IsEmpty+"^"+InputFee+"^"+Location+"^"+Note+"^"+AppLocation+"^"+Telphone+"^"+ServiceGroupId+"^"+Exclusion+"^"+ItemUseTime;
	var Info=ArcItemId+"^"+AppointMethodId+"^"+IsEmpty+"^"+""+"^"+""+"^"+Note+"^"+""+"^"+""+"^"+""+"^"+""+"^"+ItemUseTime;
	//alert(Info);
	var UpdateItemInfoFun=document.getElementById("UpdateItemInfo").value;
	var ret=cspRunServerMethod(UpdateItemInfoFun,Info);
	//alert(ret);
	if (ret!="0")
	{
	     var Info="更新检查项目信息失败:SQLCODE="+ret;
		alert(Info);
	}
	else
	{
		/*var OrdCatId=document.getElementById("OrdCatId").value;
		var OrdSubCatId=document.getElementById("OrdSubCatId").value;
		var InputOrdName=document.getElementById("InputOrdName").value;
		var ItemCat=document.getElementById("ItemCat").value;
        var ItemSubCat= document.getElementById("ItemSubCat").value;
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisItemSet&OrdCatId="+OrdCatId+"&OrdSubCatId="+OrdSubCatId+"&InputOrdName="+InputOrdName+"&ItemSubCat="+ItemSubCat+"&ItemCat="+ItemCat;
   		location.href=lnk; 
   		*/
   		//window.location.reload();
   		alert("修改成功!");
   		var objtbl=document.getElementById('tDHCRisItemSet');
		var rows=objtbl.rows.length;
		for (i=1;i<rows;i++)
    	{
	   		var itmMastRowidGet = document.getElementById("ArcItemIdz"+i).value;
	   		if (ArcItemId==itmMastRowidGet)
	   		{		   		
		   		document.getElementById("BookMethodz"+i).innerText=appointMethodText;
				document.getElementById("AppointMethodIdz"+i).value=AppointMethodId;

				document.getElementById("IsEmptyz"+i).innerText=IsEmpty;
				document.getElementById("TUseTimez"+i).innerText=ItemUseTime;
				document.getElementById("Notez"+i).innerText=ReplaceInfo(Note);
				var itemBookProperRowid=tkMakeServerCall("web.DHCRisBookParam","getItemBookProperRowid",itmMastRowidGet);
				document.getElementById("IPRowidz"+i).value=itemBookProperRowid;
				//document.getElementById("SetSerz"+i).innerText="医嘱关联服务组";
	   		}
    	}
	}
	
}




function combo(cmstr)
{
	var obj=document.getElementById(cmstr);
	obj.size=1; 
	obj.multiple=false;
}

function AddItem(ObjName, Info)
{
	var Obj=document.getElementById(ObjName);
    if (Obj.options.length>0)
 	{
		for (var i=Obj.options.length-1; i>=0; i--) Obj.options[i] = null;
	}
	
    var ItemInfo=Info.split("^");
 	for (var i=0;i<ItemInfo.length;i++)
 	{
	 	perInfo=ItemInfo[i].split(String.fromCharCode(1))
	 	var sel=new Option(perInfo[1],perInfo[0]);
		Obj.options[Obj.options.length]=sel;
	} 
}


function SelectRowHandler()
{
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisItemSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var Editlink='SetSerz'+selectrow;
	var Applink='SetAppz'+selectrow;
	var Bodylink='SetOrdBodyPartz'+selectrow;
	var ItemName= document.getElementById("ItemNamez"+selectrow).innerText;
	var ArcItemId=document.getElementById("ArcItemIdz"+selectrow).value;
	
	var AppointMethod= document.getElementById("BookMethodz"+selectrow).innerText;
	var AppointMethodId =document.getElementById("AppointMethodIdz"+selectrow).value;

	var IsEmpty= document.getElementById("IsEmptyz"+selectrow).innerText;
	var InputFee= ""; //document.getElementById("InputFeez"+selectrow).innerText;
	var Location= ""; //document.getElementById("Locationz"+selectrow).innerText;
	//var Note = document.getElementById("Notez"+selectrow).innerText;

	var AppLocation= ""; //document.getElementById("AppLocationz"+selectrow).innerText;
	var Telephone = ""; //document.getElementById("Telephonez"+selectrow).innerText;

	
	var SeviceGroupName= ""; //document.getElementById("ServiceGroupNamez"+selectrow).innerText;
	var ServiceGroupId= ""; //document.getElementById("ServiceGroupIDz"+selectrow).value;
	var Exclusion= ""; //document.getElementById("TExclusionz"+selectrow).innerText;
	var DMRowid=document.getElementById("DMRowidz"+selectrow).value;
	var ItemUseTime=document.getElementById("TUseTimez"+selectrow).innerText;
	var IPRowid=document.getElementById("IPRowidz"+selectrow).value;
	
	if(DMRowid!="")
	{
		var GetMemobyRowidFun=document.getElementById("GetMemobyRowid").value;
	    var value=cspRunServerMethod(GetMemobyRowidFun,DMRowid);
	    var Note=ReplaceInfo(value);  
	}
	else
	{
		var Note="";
	}
	
	
	var SelOrdNameObj=document.getElementById("SelOrdName");
	if (SelOrdNameObj)
	{
		SelOrdNameObj.value=ItemName;
	}

	var ArcItemIdObj=document.getElementById("SelArcItemId");
	if (ArcItemIdObj)
	{
		ArcItemIdObj.value=ArcItemId;
	}
	var lBookedMethodObj=document.getElementById("lBookedMethod");
	if (lBookedMethodObj)
	{
		lBookedMethodObj.value=AppointMethodId;
		lBookedMethodObj.text=AppointMethod;
	}
	
	var ckEmptyObj=document.getElementById("ckEmpty");
	if (ckEmptyObj)
	{
		if (IsEmpty=="Y")
			ckEmptyObj.checked=true;
		else
		   ckEmptyObj.checked=false;
		
	}

	var ckInputFeeObj=document.getElementById("ckInputFee");
	if (ckInputFeeObj)
	{
		if (InputFee=="Y")
			ckInputFeeObj.checked=true;
		else
           	ckInputFeeObj.checked=false;
           				
	}

    
    
    var ExclusionObj=document.getElementById("IsExclusion");
	if (ExclusionObj)
	{
		if (Exclusion=="Y")
			ExclusionObj.checked=true;
		else
           	ExclusionObj.checked=false;
           				
	}

	var SelLocationObj=document.getElementById("SelLocation");
	if (SelLocationObj)
	{
		SelLocationObj.value=Location;		
	}
	
	var InputNoteObj=document.getElementById("InputNote");
	if (InputNoteObj)
	{
		InputNoteObj.value=Note;
	}
	
	var InTelephoneObj=document.getElementById("InTelephone");
	if (InTelephoneObj)
	{
		InTelephoneObj.value=Telephone;
	}
	
	var InAppLocationObj=document.getElementById("InAppLocation");
	if (InAppLocationObj)
	{
		InAppLocationObj.value=AppLocation;
	}
	
	
	var InServiceGroupNameObj=document.getElementById("InServiceGroupName");
	if (InServiceGroupNameObj)
	{
		InServiceGroupNameObj.value=ServiceGroupId;
		InServiceGroupNameObj.text=SeviceGroupName;
	}	
	var ItemUseTimeObj=document.getElementById("ItemUseTime");
	if (ItemUseTimeObj)
	{
		ItemUseTimeObj.value=ItemUseTime;		
	}
	
	 if (eSrc.id==Editlink)
     {
	    if ( IPRowid=="")
	    {
		    alert("请先配置预约方式!");
		    return false;
	    }
	    var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisAddSerGroup"+"&PerRwoid="+IPRowid+"&ArcItemRowid="+ArcItemId;   
        var mynewlink=open(link,"DHCRisRetinueEdit","scrollbars=yes,resizable=yes,top=20,left=800,width=400,height=680");
        return false;
	 }
	 if(eSrc.id==Applink)
	 {
		 //alert("HH");
		 var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisAppLocEdit"+"&ArcItemRowid="+ArcItemId;   
	     var mynewlink=open(link,"DHCRisAppLocEdit","scrollbars=yes,resizable=yes,top=20,left=800,width=300,height=680");
		 return false;
	 }
	 
	 if(eSrc.id==Bodylink)
     {
         //alert("HH");
         var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisOrdBodyPart"+"&ArcItemRowid="+ArcItemId; 
         var mynewlink=open(link,"DHCRisOrdBodyPart","scrollbars=yes,resizable=yes,top=20,left=100,width=900,height=650");
         return false;
     }
	
}
function GetServiceGroup()
{
	InServiceGroupNameObj=document.getElementById("InServiceGroupName");
    if (InServiceGroupNameObj)
    {
	 	combo("InServiceGroupName");
	}
}

function ReplaceInfo(Strtmp)
{
   Info=Strtmp.replace(new RegExp("X000b","g"),"\r");
   Info=Info.replace(new RegExp("X000a","g"),"\n");
   return Info ;
}

function selectBookMethod(info)
{
	alert(info);
	/*
	var lBookedMethodObj=document.getElementById("lBookedMethod");
	lBookedMethodObj.value=AppointMethodId;
	lBookedMethodObj.text=AppointMethod;
	*/
}

document.body.onload = BodyLoadHandler;


