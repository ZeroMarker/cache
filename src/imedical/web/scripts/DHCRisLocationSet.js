//DHCRisLocationSet.js
//sunyi 2011-10-12

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
		ModiObj.onclick=Updata_click;
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
	 
	 var RecLoc=document.getElementById("RecLoc").value;
	 
	 if(RecLoc=="")
	 {
		 var error="请选择接收科室!";
		 alert(error);
		 return ;
	 }
	 
	 var LocDR=document.getElementById("LocDR").value;
	 var LocDesc=document.getElementById("LocDesc").value;
	 var BookedDesc=document.getElementById("BookedDesc").value;
	 var InputFeeDesc=document.getElementById("InputFeeDesc").value;
     
	 var Info=Rowid+"^"+LocDR+"^"+LocDesc+"^"+BookedDesc+"^"+InputFeeDesc;
	 SetAddressFun(Info,OperateCode);
}



function Updata_click()
{
	
	var SelRowid=document.getElementById("SelRowid").value;
	var OperateCode="U";
	
	if (SelRowid=="")
	{
		alert("未选择记录不能更新!")
		return;	
	}
	
	 var RecLoc=document.getElementById("RecLoc").value;
	 if(RecLoc=="")
	 {
		 var error="请选择接收科室!";
		 alert(error);
		 return ;
	 }
	 
	 var LocDR=document.getElementById("LocDR").value;
	 var LocDesc=document.getElementById("LocDesc").value;
	 var BookedDesc=document.getElementById("BookedDesc").value;
	 var InputFeeDesc=document.getElementById("InputFeeDesc").value;
     
	 var Info=SelRowid+"^"+LocDR+"^"+LocDesc+"^"+BookedDesc+"^"+InputFeeDesc;
	 SetAddressFun(Info,OperateCode);
	
	
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
	
	var str="^^^^";
    var Info=SelRowid+str;
    SetAddressFun(Info,OperateCode);
}


function Query_click()
{
	var RecLoc=document.getElementById("RecLoc").value;
	var LocDR=document.getElementById("LocDR").value;
	if (RecLoc=="")
	{
		LocDR="";
	}
	var Info=LocDR+"^";
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisLocationSet"+"&Info="+Info;
	
}



function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisLocationSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

  
 	var SelRowid=document.getElementById("Rowidz"+selectrow).value;
	var LocDR=document.getElementById("TLocDRz"+selectrow).value;
	var LocDesc=document.getElementById("TLocDescz"+selectrow).innerText;
	
	var SeleRowidObj=document.getElementById("SelRowid");
	if (SeleRowidObj)
	{
		SeleRowidObj.value=SelRowid;
		
		if (SelRowid!="")
		{
			var RecLocDesc=ChangeInfo(SelRowid,"2");
			var BookedDesc=ChangeInfo(SelRowid,"3");
			var InputFeeDesc=ChangeInfo(SelRowid,"4");
		}
	}
	
	
	var LocIDObj=document.getElementById("LocDR");
	if (LocIDObj)
	{
		LocIDObj.value=LocDR;
	}
	var RecLocObj=document.getElementById("RecLoc");
	if (RecLocObj)
	{
		RecLocObj.value=LocDesc;
	}

	var LocDescObj=document.getElementById("LocDesc");
	if (LocDescObj)
	{
		LocDescObj.value=RecLocDesc;
	}	
	
	var BookedDescObj=document.getElementById("BookedDesc");
	if (BookedDescObj)
	{
		BookedDescObj.value=BookedDesc;
	}	
	
	var InputFeeDescObj=document.getElementById("InputFeeDesc");
	if (InputFeeDescObj)
	{
		InputFeeDescObj.value=InputFeeDesc;
	}	
	
		
}


function SetAddressFun(Info,OperateCode)
{
	var SetLocationFun=document.getElementById("SetLocationFun").value;
	var value=cspRunServerMethod(SetLocationFun,Info,OperateCode);
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
		
	     alert(Info);
	}
	else
	{   
   		window.location.reload(); 
	}
	
}


function GetSelectedLocInfo(Info)
{
  Item=Info.split("^");
  alert(Item);
  document.getElementById("RecLoc").value=Item[0];
  document.getElementById("LocDR").value=Item[1]; 
}


function ReplaceInfo(Strtmp)
{
   Info=Strtmp.replace(new RegExp("X000b","g"),"\r");
   Info=Info.replace(new RegExp("X000a","g"),"\n");
   return Info ;
}

function ChangeInfo(SelRowid,Index)
{
	var GetInfobyRowidFun=document.getElementById("GetInfobyRowid").value;
	var value=cspRunServerMethod(GetInfobyRowidFun,SelRowid,Index);
	var Content=ReplaceInfo(value);
	
	return Content;
}
document.body.onload = BodyLoadHandler;


