//DHCRisNumberCreatRule..js
//sunyi 2012-04-21
var combo_Use
var combo_Opt
var SelectedRow="-1"

function BodyLoadHandler()
{

	var AddObj=document.getElementById("Add");
	if (AddObj)
	{
		AddObj.onclick=Add_click;
	}
	
	var UpdateObj=document.getElementById("Update");
	if (UpdateObj)
	{
		UpdateObj.onclick=Update_click;
	}
	
	var DeleteObj=document.getElementById("Del");
	if (DeleteObj)
	{
		DeleteObj.onclick=Delete_click;
	}
	
	var Obj=document.getElementById("UseToday")
	if(Obj)
	{
		Obj.onclick=SetTimeQuantum_click;
	}
	
	var Obj=document.getElementById("TimeQuantum")
	if(Obj)
	{
		Obj.onclick=SetUseToday_click;
	}
	
	
	var NoRuleDR=document.getElementById("NoRuleDR").value;
 	var GetUseTypeListStr=DHCC_GetElementData('GetUseTypeList');
 
	var UseObj=document.getElementById("NoRule");
	if(UseObj)
	{
		combo_Use=dhtmlXComboFromStr("NoRule",GetUseTypeListStr);
		combo_Use.enableFilteringMode(true);
		
		if (NoRuleDR!="")
		{
			combo_Use.setComboValue(NoRuleDR);
			//alert(NoRuleDR);
		}
		combo_Use.selectHandle=combo_UseKeydownhandler;
		combo_Use.keyenterHandle=combo_UseKeyenterhandler;
		combo_Use.attachEvent("onKeyPressed",combo_UseKeyenterhandler)
  	}

	
	var GetOptionsID=document.getElementById("OptionsID").value;
 	var GetOptionsListStr=DHCC_GetElementData('GetOptionsList');
 
	var OptionsObj=document.getElementById("Options");
	if(OptionsObj)
	{
		combo_Opt=dhtmlXComboFromStr("Options",GetOptionsListStr);
		combo_Opt.enableFilteringMode(true);
		
		if (GetOptionsID!="")
		{
			combo_Opt.setComboValue(GetOptionsID);
		}
		combo_Opt.selectHandle=combo_OptKeydownhandler;
		combo_Opt.keyenterHandle=combo_OptKeyenterhandler;
		combo_Opt.attachEvent("onKeyPressed",combo_OptKeyenterhandler)
  	}

    document.getElementById("UseToday").checked==false;
    document.getElementById("TimeQuantum").checked=false;
    document.getElementById("IsSaveNo").checked=false;

}



function combo_OptKeyenterhandler()
{
	
}

function combo_OptKeydownhandler()
{
  var obj=combo_Opt;
  var OptionsID=obj.getActualValue();
  document.getElementById("OptionsID").value=OptionsID;
}

function combo_UseKeyenterhandler()
{
	
}

function combo_UseKeydownhandler()
{
  var obj=combo_Use;
  var NoRuleDR=obj.getActualValue();
  document.getElementById("NoRuleDR").value=NoRuleDR;
}


function Add_click()
{
	 var OperateCode="I";
	 var Rowid="";
	 
	 var RecLoc=document.getElementById("RecLoc").value;
	 
	 if(RecLoc=="")
	 {
		 var error="请选择科室!";
		 alert(error);
		 return ;
	 }
	 
	 var Is=OneSelect();
	 if (Is=="1")
	 {
		 alert("请选择天或时间段单选钮!");
		 return;
	 }
	 var LocDR=document.getElementById("LocDR").value;
	 var NoRuleDR=document.getElementById("NoRuleDR").value;
	 var Type=SelAppType();
	 var OptionsID=document.getElementById("OptionsID").value;
	 
	 if(document.getElementById("IsSaveNo").checked)
	 {
		 IsSaveNo="Y";
	 }else
	 {
		 IsSaveNo="N";
	 }
	
	 var Info=Rowid+"^"+LocDR+"^"+NoRuleDR+"^"+Type+"^"+OptionsID+"^"+IsSaveNo;
	 SetNumberCreatRule(Info,OperateCode);
}



function Update_click()
{
	var OperateCode="U"
	var SelRowid=document.getElementById("SelRowid").value;
	
	if (SelRowid=="")
	{
		alert("未选择记录不能删除!")
		return;
		
	}
	
	  var RecLoc=document.getElementById("RecLoc").value;
	 
	 if(RecLoc=="")
	 {
		 var error="请选择科室!";
		 alert(error);
		 return ;
	 }
	 
	 var Is=OneSelect();
	 if (Is=="1")
	 {
		 alert("请选择天或时间段单选钮!");
		 return;
	 }
	 var LocDR=document.getElementById("LocDR").value;
	 var NoRuleDR=document.getElementById("NoRuleDR").value;
	 var Type=SelAppType();
	 var OptionsID=document.getElementById("OptionsID").value;
	 if(document.getElementById("IsSaveNo").checked)
	 {
		 IsSaveNo="Y";
	 }else
	 {
		 IsSaveNo="N";
	 }
	 var Info=SelRowid+"^"+LocDR+"^"+NoRuleDR+"^"+Type+"^"+OptionsID+"^"+IsSaveNo;
	 SetNumberCreatRule(Info,OperateCode);
	
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
	
	var str="^^^^^";
    var Info=SelRowid+str;
    SetNumberCreatRule(Info,OperateCode);
	
}



function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisNumberCreatRule');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	if (SelectedRow!=selectrow)
	{

	 	var SelRowid=document.getElementById("TRowidz"+selectrow).value;
	 	var RecLoc=document.getElementById("TLocDescz"+selectrow).innerText;
		var NoRuleDesc=document.getElementById("TNoRuleDescz"+selectrow).innerText;
	
		var AppDateType=document.getElementById("TAppDateTypez"+selectrow).innerText;
		var Opertion=document.getElementById("TOpertionz"+selectrow).innerText;
		var LocDR=document.getElementById("TLocDRz"+selectrow).value;
		var NoRuleDR=document.getElementById("NoRuleDRz"+selectrow).value;
	
		var OperationDR=document.getElementById("TOperationDRz"+selectrow).value;
		var IsSaveNo=document.getElementById("TIsSaveNoz"+selectrow).value;
	 
		
		var SeleRowidObj=document.getElementById("SelRowid");
		if (SeleRowidObj)
		{
			SeleRowidObj.value=SelRowid;
		}
		
		var Obj=document.getElementById("RecLoc");
		if(Obj)
		{
			Obj.value=RecLoc;
		}
		
		var Obj=document.getElementById("NoRule");
		if(Obj)
		{
			Obj.value=NoRuleDesc;
		}
		
		
		if(AppDateType=="天")
		{
			document.getElementById("UseToday").checked=true;
			document.getElementById("TimeQuantum").checked=false;
		}
		else if(AppDateType=="时间段")
		{
			document.getElementById("TimeQuantum").checked=true;
			document.getElementById("UseToday").checked=false;
		}
		
		if(IsSaveNo=="N")
		{
			document.getElementById("IsSaveNo").checked=false;
		}else
		{
			document.getElementById("IsSaveNo").checked=true;
		}
		
		var Obj=document.getElementById("Options");
		if(Obj)
		{
			Obj.value=Opertion;
		}
		
		
		var LocDRObj=document.getElementById("LocDR");
		if(LocDRObj)
		{
			LocDRObj.value=LocDR;
		}
		
		
		var Obj=document.getElementById("NoRuleDR");
		if(Obj)
		{
			Obj.value=NoRuleDR;
			if(NoRuleDR!="")
			{
			  combo_Opt.setComboValue(NoRuleDR);
			}
			else
			{
			  combo_Opt.setComboText('');
			}
		}
	
		var OpIDObj=document.getElementById("OptionsID");
		if(OpIDObj)
		{
			OpIDObj.value=OperationDR;
			if(OperationDR!="")
			{
			  combo_Use.setComboValue(OperationDR);
			}
			else
			{
			  combo_Use.setComboText('');
			}
		}
        
		SelectedRow = selectrow;
	
	}
	else
	{
		SelectedRow="-1"
		document.getElementById("RecLoc").value="";
	    document.getElementById("LocDR").value="";
        document.getElementById("NoRuleDR").value="";
	    combo_Use.setComboText('');
	    document.getElementById("OptionsID").value="";
	    combo_Opt.setComboText('');
	    document.getElementById("UseToday").checked=false;
	    document.getElementById("TimeQuantum").checked=false;
	    document.getElementById("IsSaveNo").checked=false;
        
	}
	
	
}


function SetNumberCreatRule(Info,OperateCode)
{
	var SetCreatRule=document.getElementById("SetNumberCreateRule").value;
	var value=cspRunServerMethod(SetCreatRule,Info,OperateCode);
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
		/*var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisMemoSet";
   		location.href=lnk;*/
   		window.location.reload();
   		
	}
	
}


function SetTimeQuantum_click()
{
	document.getElementById("TimeQuantum").checked=false;
}

function SetUseToday_click()
{
	document.getElementById("UseToday").checked=false;
}

function SelAppType()
{
	var AppType;
	
	if(document.getElementById("UseToday").checked)
	{
		document.getElementById("TimeQuantum").checked=false;
		AppType="0"
	}
	if(document.getElementById("TimeQuantum").checked)
	{
		document.getElementById("UseToday").checked=false;
		AppType="1"
	}
	
	return AppType
}

//选择检查科室
function GetSelectedLocInfo(Info)
{
  Item=Info.split("^");
  document.getElementById("RecLoc").value=Item[0];
  document.getElementById("LocDR").value=Item[1]; 
}

function OneSelect()
{
	if ((document.getElementById("UseToday").checked==false)&(document.getElementById("TimeQuantum").checked==false))
	{
	   return "1"
	}
	
	return "0"
}

document.body.onload = BodyLoadHandler;

