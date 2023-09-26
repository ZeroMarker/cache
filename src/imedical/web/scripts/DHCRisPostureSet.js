//DHCRisPostureSet.js
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
	 var BodyPart=document.getElementById("BodyPart").value;
	
 
	 if(BodyPart=="")
	 {
		 alert("部位不能为空!");
		 return;
	 }
	 
	 
	 var BodyPartID=document.getElementById("BodyPartID").value;
	 var Posture=document.getElementById("Posture").value;
	
	 var Info=Rowid+"^"+BodyPartID+"^"+Posture;
	 SetBoadyPostureSet(Info,OperateCode);
}



function Update_click()
{
	
	 var OperateCode="U";
	 var SelRowid=document.getElementById("SelRowid").value;
	 var BodyPart=document.getElementById("BodyPart").value;
	
	 if (SelRowid=="")
	 {
		alert("未选择记录不能更新!")
		return;
		
	 }
 
	 if(BodyPart=="")
	 {
		 alert("部位不能为空!");
		 return;
	 }
	 
	 
	 var BodyPartID=document.getElementById("BodyPartID").value;
	 var Posture=document.getElementById("Posture").value;
	
	 var Info=SelRowid+"^"+BodyPartID+"^"+Posture;
	 SetBoadyPostureSet(Info,OperateCode);
	
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
    SetBoadyPostureSet(Info,OperateCode);
	
}


function Query_click()
{
	var BodyPartID=document.getElementById("BodyPartID").value;

	var Info=BodyPartID+"^";
	document.getElementById("Info").value=Info;
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisPostureSet"+"&Info="+Info;
	
}


function SelectRowHandler()
{
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisPostureSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;

    
 	var SelRowid=document.getElementById("TRowidz"+selectrow).value;
	var BodyPart=document.getElementById("TBodyPartz"+selectrow).innerText;
	var Posture=document.getElementById("TPosturez"+selectrow).innerText;
	var BodyPartID=document.getElementById("TBodyPartIDz"+selectrow).value;
	
	
	
	var SeleRowidObj=document.getElementById("SelRowid");
	if (SeleRowidObj)
	{
		SeleRowidObj.value=SelRowid;
	}
	
	var BodyPartObj=document.getElementById("BodyPart");
	if (BodyPartObj)
	{
		BodyPartObj.value=BodyPart;
	}
	var PostureObj=document.getElementById("Posture");
	if (PostureObj)
	{
		PostureObj.value=Posture;
	}
	var BodyPartIDObj=document.getElementById("BodyPartID");
	if (BodyPartIDObj)
	{
		BodyPartIDObj.value=BodyPartID;
	}
	
	
}




function SetBoadyPostureSet(Info,OperateCode)
{
	var SetBoadyPostureSetFun=document.getElementById("SetBoadyPostureSet").value;
	var value=cspRunServerMethod(SetBoadyPostureSetFun,Info,OperateCode);
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
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisPostureSet";
   		location.href=lnk; 
	}
	
}

function GetBodyPartInfo(Info)
{
  Item=Info.split("^");
  document.getElementById("BodyPart").value=Item[1];
  document.getElementById("BodyPartID").value=Item[0];
}




document.body.onload = BodyLoadHandler;