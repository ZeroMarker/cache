//DHCRisOrdBodyPart.js

var SelectedRow="-1"

var $=function(Id){
	return document.getElementById(Id);
}



function BodyLoadHandler()
{
	
	if ($("ArcItemRowid").value=="")
	{
		alert("参数错误");
		return;
	}
	
	var ArcItemRowid=$("ArcItemRowid").value;
	var ArcItemName=tkMakeServerCall("web.DHCRisBookParam","GetOrdItmName",ArcItemRowid);	
	document.getElementById("SelOrdName").value=ArcItemName
	var AddObj=$("Add");
	if (AddObj)
	{
		AddObj.onclick=Add_click;
	}
	var UpdateObj=$("Update");
	if (UpdateObj)
	{
		UpdateObj.onclick=Update_click;
	}
	
	var DeleteObj=$("Del");
	if (DeleteObj)
	{
		DeleteObj.onclick=Delete_click;
	}
	GetBookMethod();
    //鏌ヨ閮ㄤ綅锛?
    //QueryBodyPart();
    GetOrdBodyPart();
}



function Add_click()
{
	var ArcItemRowid=$("ArcItemRowid").value;
	var ArcItemId,AppointMethodId,IsEmpty,ServiceGroupId,ArcItemTime;
    
    
    var ArcItemIdObj=document.getElementById("SelArcItemId");
    if (ArcItemIdObj)
    {
        ArcItemId=ArcItemIdObj.value;
    }
    
    
    var lBookedMethodObj=document.getElementById("lBookedMethod");
    if (lBookedMethodObj)
    {
        AppointMethodId=lBookedMethodObj.value;
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
    var InServiceGroupNameObj=document.getElementById("InServiceGroupName");
    if (InServiceGroupNameObj)
    {
        ServiceGroupId=InServiceGroupNameObj.value;
    }
    var ItemUseTimeObj=document.getElementById("ItemUseTime");
    if (ItemUseTimeObj)
    {
        ItemUseTime=cTrim(ItemUseTimeObj.value,0)   
    }
    var BodyPartSET=document.getElementById("BodyPartSET").value;
    var BodyPartSETID=document.getElementById("BodyPartSETID").value;
    //alert(BodyPartSETID);
    /*
	//var BodyPartObj=$("BodyPartSET");
    if (BodyPartObj)
    {  
       
        //alert(ServiceListObj.value);
        var nIndex=BodyPartObj.selectedIndex;
	    if (nIndex==-1) return;
		var value=BodyPartObj.options[nIndex].value;
		var item=value.split(":");
		var BodyRowid=item[0];
		var BodyDesc=tkMakeServerCall("web.DHCRisBookParam","GetBodyCody",BodyRowid);                            //BodyPartObj.options[BodyPartObj.selectedIndex].text;	
	
		//SaveSet(Info,"I");
	
    }
    */
    if (BodyPartSETID=="")
    {
	    alert("请先选择部位");
	    return;
    }
	
	if ( AppointMethodId=="")
	{
		alert("请选择预约方式");
		return;
	}
    var Info=ArcItemRowid+"^"+AppointMethodId+"^"+IsEmpty+"^"+ItemUseTime+"^"+BodyPartSETID+"^"+BodyPartSET;
    
   
    SaveSet(Info,"I");
    /*
    var UpdateItemInfoFun=document.getElementById("UpdateItemInfo").value;
    var ret=cspRunServerMethod(UpdateItemInfoFun,Info);
    if (ret!="0")
    {
         var Info="鏇存柊妫?鏌ラ」鐩俊鎭け璐?SQLCODE="+ret;
        alert(Info);
    }
    else
    {
        var OrdCatId=document.getElementById("OrdCatId").value;
        var OrdSubCatId=document.getElementById("OrdSubCatId").value;
        var InputOrdName=document.getElementById("InputOrdName").value;
        var ItemCat=document.getElementById("ItemCat").value;
        var ItemSubCat= document.getElementById("ItemSubCat").value;
        var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisItemSet&OrdCatId="+OrdCatId+"&OrdSubCatId="+OrdSubCatId+"&InputOrdName="+InputOrdName+"&ItemSubCat="+ItemSubCat+"&ItemCat="+ItemCat;
        location.href=lnk; 
    }
    */

}
function Update_click()
{
	var ArcItemRowid=$("ArcItemRowid").value;
	var ArcItemId,AppointMethodId,IsEmpty,ServiceGroupId,ArcItemTime;
    
    
    var ArcItemIdObj=document.getElementById("SelArcItemId");
    if (ArcItemIdObj)
    {
        ArcItemId=ArcItemIdObj.value;
    }
    
    
    var lBookedMethodObj=document.getElementById("lBookedMethod");
    if (lBookedMethodObj)
    {
        AppointMethodId=lBookedMethodObj.value;
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
    var InServiceGroupNameObj=document.getElementById("InServiceGroupName");
    if (InServiceGroupNameObj)
    {
        ServiceGroupId=InServiceGroupNameObj.value;
    }
    var ItemUseTimeObj=document.getElementById("ItemUseTime");
    if (ItemUseTimeObj)
    {
        ItemUseTime=cTrim(ItemUseTimeObj.value,0)   
    }
	 var BodyPartSET=document.getElementById("BodyPartSET").value;
    var BodyPartSETID=document.getElementById("BodyPartSETID").value;
    //alert(BodyPartSETID);
    /*
	//var BodyPartObj=$("BodyPartSET");
    if (BodyPartObj)
    {  
       
        //alert(ServiceListObj.value);
        var nIndex=BodyPartObj.selectedIndex;
	    if (nIndex==-1) return;
		var value=BodyPartObj.options[nIndex].value;
		var item=value.split(":");
		var BodyRowid=item[0];
		var BodyDesc=tkMakeServerCall("web.DHCRisBookParam","GetBodyCody",BodyRowid);                            //BodyPartObj.options[BodyPartObj.selectedIndex].text;	
	
		//SaveSet(Info,"I");
	
    }
    */
    
   
	
	if (( AppointMethodId=="" )|| (BodyPartSETID==""))
	{
		alert("请选择一条记录");
		return;
	}
	
    var Info=ArcItemRowid+"^"+AppointMethodId+"^"+IsEmpty+"^"+ItemUseTime+"^"+BodyPartSETID+"^"+BodyPartSET;
    
    //alert(Info);
    //return;
    SaveSet(Info,"U");
}
function Delete_click()
{	
		var ArcItemRowid=$("ArcItemRowid").value;
	var ArcItemId,AppointMethodId,IsEmpty,ServiceGroupId,ArcItemTime;
    
    
    var ArcItemIdObj=document.getElementById("SelArcItemId");
    if (ArcItemIdObj)
    {
        ArcItemId=ArcItemIdObj.value;
    }
    
    
    var lBookedMethodObj=document.getElementById("lBookedMethod");
    if (lBookedMethodObj)
    {
        AppointMethodId=lBookedMethodObj.value;
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
    var InServiceGroupNameObj=document.getElementById("InServiceGroupName");
    if (InServiceGroupNameObj)
    {
        ServiceGroupId=InServiceGroupNameObj.value;
    }
    var ItemUseTimeObj=document.getElementById("ItemUseTime");
    if (ItemUseTimeObj)
    {
        ItemUseTime=cTrim(ItemUseTimeObj.value,0)   
    }
    var BodyPartID=document.getElementById("BodyPartSET").value;
	 var BodyPartSET=document.getElementById("BodyPartSET").value;
    var BodyPartSETID=document.getElementById("BodyPartSETID").value;
    //alert(BodyPartSETID);
    /*
	//var BodyPartObj=$("BodyPartSET");
    if (BodyPartObj)
    {  
       
        //alert(ServiceListObj.value);
        var nIndex=BodyPartObj.selectedIndex;
	    if (nIndex==-1) return;
		var value=BodyPartObj.options[nIndex].value;
		var item=value.split(":");
		var BodyRowid=item[0];
		var BodyDesc=tkMakeServerCall("web.DHCRisBookParam","GetBodyCody",BodyRowid);                            //BodyPartObj.options[BodyPartObj.selectedIndex].text;	
	
		//SaveSet(Info,"I");
	
    }
    */
    
    if (( AppointMethodId=="" )|| (BodyPartSETID==""))
	{
		alert("请选择一条记录");
		return;
	}
	
    var Info=ArcItemRowid+"^"+AppointMethodId+"^"+IsEmpty+"^"+ItemUseTime+"^"+BodyPartSETID+"^"+BodyPartSET;
    
   // alert(Info);
    SaveSet(Info,"D");
	
}

/*
//鏌ヨ閮ㄤ綅
function QueryBodyPart()
{
    BodyPartNameObj=document.getElementById("BodyPart");
    if (BodyPartNameObj)
    {
	 	combo("BodyPart");
	}
}
*/
function GetBodyPart(Info)
{
	
	var item=Info.split("^");
	
	
	document.getElementById("BodyPartSETID").value=item[0];
	
	document.getElementById("BodyPartSET").value=item[2];
	//FindClickHandler();
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

function GetOrdBodyPart()
{
	//鑾峰彇鍖诲槺椤圭洰鍏虫敞鐨勯儴浣?
    //var AdmLocFun=document.getElementById("GetItmServiceGroup").value;
    
	//var Info1=cspRunServerMethod(AdmLocFun,$("PerRwoid").value);
	//AddItem("SelServiceGroupList",Info1);

}


//鍑芥暟
function SaveSet(Info,OperateCode)
{
	//var SaveUserSetFun=$("SaveFun").value;
	//var value=cspRunServerMethod(SaveUserSetFun,Info,OperateCode);
	var value=tkMakeServerCall("web.DHCRisBookParam","SetArcItmBody",Info,OperateCode);
	if (value!="0")
	{  
		if ( value=="200")
		{
			alert("不能重复添加");
			return;
		}
		if ( value=="300")
		{
			alert("请选择一条记录");
			return;
		}
	     if(OperateCode=="I")
	     {
		    var Info="增加失败:SQLCODE="+value;
		 }
	     if(OperateCode=="U")
	     {
		    var Info="更新失败:SQLCODE="+value;
		 }
		 if(OperateCode=="D")
		 {
			
			var Info="删除失败:SQLCODE="+value;
			
	     }
	     alert(Info);
	     return;	 
		
	}
	else
	{   
   		window.location.reload();
	}
}
function GetBookMethod()
{
    lBookedMethodObj=document.getElementById("lBookedMethod");
    if (lBookedMethodObj)
    {
        combo("lBookedMethod");
    }
    
}
function cTrim(sInputString,iType)
{
  var sTmpStr = ' '
  var i = -1

  if(iType == 0 || iType == 1)
  {
     while(sTmpStr == ' ')
     {
       ++i
       sTmpStr = sInputString.substr(i,1)
     }
     sInputString = sInputString.substring(i)
  }

  if(iType == 0 || iType == 2)
  {
    sTmpStr = ' '
    i = sInputString.length
    while(sTmpStr == ' ')
    {
       --i
       sTmpStr = sInputString.substr(i,1)
    }
    sInputString = sInputString.substring(0,i+1)
  }
  return sInputString
}
function SelectRowHandler()
{
    var ArcItemId=$("ArcItemRowid").value;
   
    var eSrc=window.event.srcElement;
    var objtbl=document.getElementById('tDHCRisOrdBodyPart');
    var rows=objtbl.rows.length;
    var lastrowindex=rows - 1;
    
    var rowObj=getRow(eSrc);
    var selectrow=rowObj.rowIndex;
    //alert(selectrow);
     var Applink='SetServicez'+selectrow;
   var AppointMethod= document.getElementById("BookMethodz"+selectrow).innerText;
    
   var AppointMethodId =document.getElementById("AppointMethodIdz"+selectrow).value;
	
		
   var IsEmpty= document.getElementById("IsEmptyz"+selectrow).innerText;
   var ItemUseTime=document.getElementById("TUseTimez"+selectrow).innerText;
   var IPRowid=document.getElementById("IPRowidz"+selectrow).value;
   // alert(IPRowid);
   var BodyPart=document.getElementById("BodyPartz"+selectrow).innerText;
   //alert(BodyPart);
   var BodyPartID=document.getElementById("BodyPartIDz"+selectrow).value;
   //alert(BodyPartID);
  
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
    var ItemUseTimeObj=document.getElementById("ItemUseTime");
    if (ItemUseTimeObj)
    {
        ItemUseTimeObj.value=ItemUseTime;       
    }
    
     var BodyPartObj=document.getElementById("BodyPartSET"); 
    if (BodyPartObj)
    {
        BodyPartObj.value=BodyPart;
       
    }
     var BodyPartIDObj=document.getElementById("BodyPartSETID");
     //alert(BodyPartIDObj);
     if (BodyPartIDObj)
     {
	     //alert(BodyPartID);
	     BodyPartIDObj.value=BodyPartID;
	     //alert("1");
	 }

    if(eSrc.id==Applink)
     {
         //alert("HH");
         var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisOrdBodyPartSerGroup"+"&PerRwoid="+IPRowid+"&ArcItemRowid="+ArcItemId+"&BodyPartID="+BodyPartID;   
         //alert(link);
         var mynewlink=open(link,"DHCRisAppLocEdit","scrollbars=yes,resizable=yes,top=20,left=800,width=300,height=680");
         return false;
     } 
}
document.body.onload = BodyLoadHandler;


