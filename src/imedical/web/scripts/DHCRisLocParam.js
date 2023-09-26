//DHCRisLocParam.js
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
	
    // 查询所有的科室
    QueryLoc();
    
    //存储类型
	GetServerList();
	
	//查询预约使用方式
	QueryLocBKType();

}

function Add_click()
{
	 var OperateCode="I";
	 var Rowid="";
	 
	 var GetData=SetLocParamData();
	 Info=Rowid+"^"+GetData
	 SetLocParamFun(Info,OperateCode);
}



function Update_click()
{
	
	 var OperateCode="U";
	 var SelRowid=document.getElementById("SelRowid").value;
	
	 if (SelRowid=="")
	 {
		alert("未选择记录不能更新!")
		return;
		
	 }
	
	 var GetData=SetLocParamData();
	 Info=SelRowid+"^"+GetData
	 SetLocParamFun(Info,OperateCode);
	
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
	
	var str="^^^^^^^^^^^^^";
    var Info=SelRowid+"^"+str;
    SetLocParamFun(Info,OperateCode);
	
}



function SelectRowHandler()
{
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisLocParam');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;


 	var SelRowid=document.getElementById("TRowidz"+selectrow).value;
	var SystemSDate=document.getElementById("TSystemSDatez"+selectrow).innerText;
	var SystemEDate=document.getElementById("TSystemEDatez"+selectrow).innerText;
	var PrintAutoVerify=document.getElementById("TPrintAutoVerifyz"+selectrow).innerText;
	var PrintAutoIssue=document.getElementById("TPrintAutoIssuez"+selectrow).innerText;
	var VerifyAutoIssue=document.getElementById("TVerifyAutoIssuez"+selectrow).innerText;
	var VerifyNeedsPWD=document.getElementById("TVerifyNeedsPWDz"+selectrow).innerText;
	var LocDR=document.getElementById("TLocDRz"+selectrow).innerText;
	var ServerDR=document.getElementById("TServerDRz"+selectrow).innerText;
	var AutoDowndload=document.getElementById("TAutoDowndloadz"+selectrow).innerText;
	var PrintBookedTemlate=document.getElementById("TPrintBookedTemlatez"+selectrow).innerText;
	var PrintRegTemplate=document.getElementById("TPrintRegTemplatez"+selectrow).innerText;
	var PrintRegListTemplate=document.getElementById("TPrintRegListTemplatez"+selectrow).innerText;
	var SendDate=document.getElementById("TSendDatez"+selectrow).innerText;
	var ExamineAfterFree=document.getElementById("TExamineAfterFreez"+selectrow).innerText;
	var LocID=document.getElementById("TLocIDz"+selectrow).value;
	var ServerID=document.getElementById("TServerIDz"+selectrow).value;
	var SendToRIS4=document.getElementById("TSendInfoToRIS4z"+selectrow).innerText;
	var StudyInfoToRIS4=document.getElementById("TStudyInfoToRIS4z"+selectrow).innerText;
	var BookUseTypeDesc=document.getElementById("BookUseTypeDescz"+selectrow).innerText;
	var BookUseTypeID=document.getElementById("BookUseTypeDRz"+selectrow).value;
	var UseAutoBooked=document.getElementById("UseAutoBookz"+selectrow).innerText;
	
	
	
	var SeleRowidObj=document.getElementById("SelRowid");
	if (SeleRowidObj)
	{
		SeleRowidObj.value=SelRowid;
	}
	
	var SystemSDateObj=document.getElementById("SystemSDate");
	if (SystemSDateObj)
	{
		SystemSDateObj.value=SystemSDate;
	}
	var SystemEDateObj=document.getElementById("SystemEDate");
	if (SystemEDateObj)
	{
		SystemEDateObj.value=SystemEDate;
	}
	var SelLocObj=document.getElementById("SelLoc");
	if (SelLocObj)
	{
		SelLocObj.value=LocID;
		SelLocObj.text=LocDR
	}
	var lSerNameObj=document.getElementById("lServerName");
	if (lSerNameObj)
	{
		lSerNameObj.value=ServerID;
		lSerNameObj.text=ServerDR;
	}
	
	var SelBKObj=document.getElementById("SelBKType");
	if (SelBKObj)
	{
		SelBKObj.value=BookUseTypeID;
		SelBKObj.text=BookUseTypeDesc;
	}
	var PBTObj=document.getElementById("PrintBookedTemlate");
	if (PBTObj)
	{
		PBTObj.value=PrintBookedTemlate;
	}
	var PRTObj=document.getElementById("PrintRegTemplate");
	if (PRTObj)
	{
		PRTObj.value=PrintRegTemplate;
	}
	var PRLTObj=document.getElementById("PrintRegListTemplate");
	if (PRLTObj)
	{
		PRLTObj.value=PrintRegListTemplate;
	}
	var SendDateObj=document.getElementById("SendDate");
	if(SendDateObj)
	{
		SendDateObj.value=SendDate;
	}
	
	if(PrintAutoVerify=="Y")
	{
	  document.getElementById("PrintAutoVerify").checked=true;	
	}
	else
	{
	  document.getElementById("PrintAutoVerify").checked=false;	
	}
	
	if(PrintAutoIssue=="Y")
	{
	  document.getElementById("PrintAutoIssue").checked=true;	
	}
	else
	{
	  document.getElementById("PrintAutoIssue").checked=false;	
	}
	if(VerifyAutoIssue=="Y")
	{
	  document.getElementById("VerifyAutoIssue").checked=true;	
	}
	else
	{
	  document.getElementById("VerifyAutoIssue").checked=false;	
	}
	
	//////////////////////////////////////////////////
	
	if(VerifyNeedsPWD=="Y")
	{
	  document.getElementById("VerifyNeedsPWD").checked=true;	
	}
	else
	{
	  document.getElementById("VerifyNeedsPWD").checked=false;	
	}
	
	if(AutoDowndload=="Y")
	{
	  document.getElementById("AutoDowndload").checked=true;	
	}
	else
	{
	  document.getElementById("AutoDowndload").checked=false;	
	}
	
	if(ExamineAfterFree=="Y")
	{
	  document.getElementById("ExamineAfterFree").checked=true;	
	}
	else
	{
	  document.getElementById("ExamineAfterFree").checked=false;	
	}
	if(SendToRIS4=="Y")
	{
	  document.getElementById("SendToRIS4").checked=true;	
	}
	else
	{
	  document.getElementById("SendToRIS4").checked=false;	
	}
	if(StudyInfoToRIS4=="Y")
	{
	  document.getElementById("StudyInfoToRIS4").checked=true;	
	}
	else
	{
	  document.getElementById("StudyInfoToRIS4").checked=false;	
	}
	if (UseAutoBooked=="Y"){
		document.getElementById("UseAutoBooked").checked=true; 
    }
    else{
	   document.getElementById("UseAutoBooked").checked=false; 
    }
	
	
}


function SetLocParamData()
{
	 var SystemSDate=document.getElementById("SystemSDate").value;
	 var SystemEDate=document.getElementById("SystemEDate").value;
	 var LocID=document.getElementById("SelLoc").value;
	 var ServerID=document.getElementById("lServerName").value;
	 var PrintBookedTemlate=document.getElementById("PrintBookedTemlate").value;
	 var PrintRegTemplate=document.getElementById("PrintRegTemplate").value;
	 var PrintRegListTemplate=document.getElementById("PrintRegListTemplate").value;
	 var SendDate=document.getElementById("SendDate").value;
	 var BKUseTypeID=document.getElementById("SelBKType").value;
	  
	 if (document.getElementById("PrintAutoVerify").checked)
     {
  	     var PrintAutoVerify="Y";
     }
     else
     {
  	     var PrintAutoVerify="N";
     }
     if (document.getElementById("PrintAutoIssue").checked)
     {
  	     var PrintAutoIssue="Y";
     }
     else
     {
  	     var PrintAutoIssue="N";
     }
     if (document.getElementById("VerifyAutoIssue").checked)
     {
  	     var VerifyAutoIssue="Y";
     }
     else
     {
  	     var VerifyAutoIssue="N";
     }
     if (document.getElementById("VerifyNeedsPWD").checked)
     {
  	     var VerifyNeedsPWD="Y";
     }
     else
     {
  	     var VerifyNeedsPWD="N";
     }
     if (document.getElementById("AutoDowndload").checked)
     {
  	     var AutoDowndload="Y";
     }
     else
     {
  	     var AutoDowndload="N";
     }
     if (document.getElementById("ExamineAfterFree").checked)
     {
  	     var ExamineAfterFree="Y";
     }
     else
     {
  	     var ExamineAfterFree="N";
     }
     if (document.getElementById("SendToRIS4").checked)
     {
  	     var SendToRIS4="Y";
     }
     else
     {
  	     var SendToRIS4="N";
     }
     if (document.getElementById("StudyInfoToRIS4").checked)
     {
  	     var StudyInfoToRIS4="Y";
     }
     else
     {
  	     var StudyInfoToRIS4="N";
     }
     if (document.getElementById("UseAutoBooked").checked)
     {
	     var AutoBooked="Y";
	 }else{
		 var AutoBooked="N";
	 }
     var Info=SystemSDate+"^"+SystemEDate+"^"+PrintAutoVerify+"^"+PrintAutoIssue+"^"+VerifyAutoIssue+"^"+VerifyNeedsPWD+"^"+LocID;
	     Info=Info+"^"+ServerID+"^"+AutoDowndload+"^"+PrintBookedTemlate+"^"+PrintRegTemplate+"^"+PrintRegListTemplate+"^"+SendDate+"^"+ExamineAfterFree+"^"+SendToRIS4+"^"+StudyInfoToRIS4+"^"+BKUseTypeID+"^"+AutoBooked;
	    
	 return Info;    
}


function SetLocParamFun(Info,OperateCode)
{
	var SetLocParamFun=document.getElementById("SetLocParamFun").value;
	var value=cspRunServerMethod(SetLocParamFun,Info,OperateCode);
	if (value!="0")
	{  
		if (value=="200")
		{
			var Info="不能重复添加!";
		}
		else
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
	    alert(Info);
	}
	else
	{   
		/*var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisLocParam";
   		location.href=lnk;*/
   		window.location.reload(); 
	}
	
}

//存储类型
function GetServerList()
{
    lServerNameObj=document.getElementById("lServerName");
    if (lServerNameObj)
    {
 		combo("lServerName");
		var GetServerListFunction=document.getElementById("GetServerList").value;
		var Info1=cspRunServerMethod(GetServerListFunction);
    	AddItem("lServerName",Info1);
    }
}

// 查询所有的科室
function QueryLoc()
{
    SelLocObj=document.getElementById("SelLoc");
    if (SelLocObj)
    {
 		combo("SelLoc");
		var GetAllLocFunction=document.getElementById("GetAllLoc").value;
		var Info1=cspRunServerMethod(GetAllLocFunction,"");
    	AddItem("SelLoc",Info1);
    }
}


// 查询所有的科室
function QueryLocBKType()
{
    SelLocObj=document.getElementById("SelBKType");
    if (SelLocObj)
    {
 		combo("SelBKType");
		var BKUseFunction=document.getElementById("GetBKUseTypeInfo").value;
		var Info1=cspRunServerMethod(BKUseFunction);
    	AddItem("SelBKType",Info1);
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



document.body.onload = BodyLoadHandler;