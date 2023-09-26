//DHCRisStudyNoCreatRule.js
//sunyi 2012-04-21
var combo_Use
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
	
	var NoObj=document.getElementById("UseNo")
	if(NoObj)
	{
		NoObj.onclick=SetUseStudy_click;
	}
	
	var UseStudyNoObj=document.getElementById("UseStudyNo")
	if(UseStudyNoObj)
	{
		UseStudyNoObj.onclick=SetUseNO_click;
	}
	
	
	var GetOptionsID=document.getElementById("OptionsID").value;
 	var GetOptionsListStr=DHCC_GetElementData('GetOptionsList');
 
	/*
	var UseOptionsObj=document.getElementById("Options");
	if(UseOptionsObj)
	{
		combo_Use=dhtmlXComboFromStr("Options",GetOptionsListStr);
		combo_Use.enableFilteringMode(true);
		
		if (GetOptionsID!="")
		{
			combo_Use.setComboValue(GetOptionsID);
		}
		combo_Use.selectHandle=combo_UseKeydownhandler;
		combo_Use.keyenterHandle=combo_UseKeyenterhandler;
		combo_Use.attachEvent("onKeyPressed",combo_UseKeyenterhandler)
  	}
	*/

}



function combo_UseKeyenterhandler()
{
	
}

function combo_UseKeydownhandler()
{
  //var obj=combo_Use;
  //var OptionsID=obj.getActualValue();
  //document.getElementById("OptionsID").value=OptionsID;
}


function Add_click()
{
	 var OperateCode="I";
	 var Rowid="";
	 
	 var RecLoc=document.getElementById("RecLoc").value;
	 var GroupDesc=document.getElementById("GroupDesc").value;
	 var subOrdSubCat=document.getElementById("subOrdSubCat").value;
	 
	 if(RecLoc=="")
	 {
		 var error="请选择科室!";
		 alert(error);
		 return ;
	 }
	 
	 if(GroupDesc=="")
	 {
		 document.getElementById("GroupDR").value="";
	 }
	 
	 if(subOrdSubCat=="")
	 {
		 document.getElementById("OrdSubCatID").value=""
	 }
	 
	 /*if ((document.getElementById("UseNo").checked==false)&(document.getElementById("UseStudyNo").checked==false))
	 {
		 alert("请选择应用于编号或检查号!");
		 return;
	 }
	*/
	 var GroupDR=document.getElementById("GroupDR").value;
	 var Prefix=document.getElementById("Prefix").value;
	 var MaxNumber=document.getElementById("MaxNumber").value;
	 var LocDR=document.getElementById("LocDR").value;
	 var Type="1"; //SelAppType();
	 var MoreStudyNo=SelMoreStydyNo();
	 var OptionsID="";  //document.getElementById("OptionsID").value;
	 var OrdSubCatID=document.getElementById("OrdSubCatID").value;
	 
	 var Info=Rowid+"^"+GroupDR+"^"+Prefix+"^"+MaxNumber+"^"+LocDR+"^"+Type+"^"+OptionsID+"^"+OrdSubCatID+"^"+MoreStudyNo;
	 SetStudyNoCreatRule(Info,OperateCode);
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
	 var GroupDesc=document.getElementById("GroupDesc").value;
	 var subOrdSubCat=document.getElementById("subOrdSubCat").value;
	 
	 if(RecLoc=="")
	 {
		 var error="请选择科室!";
		 alert(error);
		 return ;
	 }
	 
	 if(GroupDesc=="")
	 {
		 document.getElementById("GroupDR").value="";
	 }
	 
	 if(subOrdSubCat=="")
	 {
		 document.getElementById("OrdSubCatID").value=""
	 }
	 /*
	 if ((document.getElementById("UseNo").checked==false)&(document.getElementById("UseStudyNo").checked==false))
	 {
		 alert("请选择应用于编号或检查号!");
		 return;
	 }
	 */	
	 var GroupDR=document.getElementById("GroupDR").value;
	 var Prefix=document.getElementById("Prefix").value;
	 var MaxNumber=document.getElementById("MaxNumber").value;
	 var LocDR=document.getElementById("LocDR").value;
	 var Type="1"; //SelAppType();
	 var MoreStudyNo=SelMoreStydyNo();
	 var OptionsID=""; //document.getElementById("OptionsID").value;
	 var OrdSubCatID=document.getElementById("OrdSubCatID").value;
	 
	 
	 var Info=SelRowid+"^"+GroupDR+"^"+Prefix+"^"+MaxNumber+"^"+LocDR+"^"+Type+"^"+OptionsID+"^"+OrdSubCatID+"^"+MoreStudyNo;
	 //alert(Info);
	 SetStudyNoCreatRule(Info,OperateCode);
	
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
	
	var str="^^^^^^^";
    var Info=SelRowid+str;
    SetStudyNoCreatRule(Info,OperateCode);
	
}



function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisStudyNoCreatRule');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	if (SelectedRow!=selectrow)
	{
	 	var SelRowid=document.getElementById("TRowidz"+selectrow).value;
	 	var RecLoc=document.getElementById("TLocDescz"+selectrow).innerText;
		var GroupDesc=document.getElementById("TEQGroupDescz"+selectrow).innerText;
		var SubCatDesc=document.getElementById("TSubCatDescz"+selectrow).innerText;
		var Prefix=document.getElementById("TPrefixz"+selectrow).innerText;
		var AppType=document.getElementById("TAppTypez"+selectrow).innerText;
		var Operation=document.getElementById("TOperationz"+selectrow).innerText;
		var GroupDR=document.getElementById("TEQGroupz"+selectrow).value;
		var LocDR=document.getElementById("TLocDRz"+selectrow).value;
		var OperationDR=document.getElementById("TOperationDRz"+selectrow).value;
		var OrdSubCatID=document.getElementById("SubCatDRz"+selectrow).value;
		var MaxNumber=document.getElementById("TMaxNumberz"+selectrow).innerText;
		//var MoreStudyNo=document.getElementById("TMoreStudyNoz"+selectrow).innerText;
		 
		
		var SeleRowidObj=document.getElementById("SelRowid");
		if (SeleRowidObj)
		{
			SeleRowidObj.value=SelRowid;
		}
		
		var RecLocObj=document.getElementById("RecLoc");
		if(RecLocObj)
		{
			RecLocObj.value=RecLoc;
		}
		
		var GroupDescObj=document.getElementById("GroupDesc");
		if(GroupDescObj)
		{
			GroupDescObj.value=GroupDesc;
		}
		
		var subOrdSubCatObj=document.getElementById("subOrdSubCat");
		if(subOrdSubCatObj)
		{
			subOrdSubCatObj.value=SubCatDesc;
		}
		
		var PrefixObj=document.getElementById("Prefix");
		if(PrefixObj)
		{
			PrefixObj.value=Prefix;
		}
		/*
		if(AppType=="应用于编号")
		{
			document.getElementById("UseNo").checked=true;
			document.getElementById("UseStudyNo").checked=false;
		}
		else if(AppType=="应用于检查号")
		{
			document.getElementById("UseStudyNo").checked=true;
			document.getElementById("UseNo").checked=false;
		}
		*/
		/*
		if(MoreStudyNo=="Y")
		{
			document.getElementById("MoreStudyNo").checked=true;
		}else
		{
			document.getElementById("MoreStudyNo").checked=false;
		}
		*/
		var MaxNumberObj=document.getElementById("MaxNumber");
		if(MaxNumberObj)
		{
			MaxNumberObj.value=MaxNumber;
		}
		/*
		var OptionsObj=document.getElementById("Options");
		if(OptionsObj)
		{
			OptionsObj.value=Operation;
		}
		*/
		var LocDRObj=document.getElementById("LocDR");
		if(LocDRObj)
		{
			LocDRObj.value=LocDR;
		}
		var GroupDRObj=document.getElementById("GroupDR");
		if(GroupDRObj)
		{
			GroupDRObj.value=GroupDR;
		}
		var OcidObj=document.getElementById("OrdSubCatID");
		if(OcidObj)
		{
			OcidObj.value=OrdSubCatID;
		}
		/*
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
		*/
		SelectedRow = selectrow;
	
	}
	else
	{
		SelectedRow="-1"
		document.getElementById("RecLoc").value="";
	    GroupDesc=document.getElementById("GroupDesc").value="";
	    document.getElementById("subOrdSubCat").value="";
	    document.getElementById("OrdSubCatID").value=""

	    document.getElementById("GroupDR").value="";
	    document.getElementById("Prefix").value="";
	    document.getElementById("MaxNumber").value="";
	    document.getElementById("LocDR").value="";
	 
	    //document.getElementById("OptionsID").value="";
	    //combo_Use.setComboText('');
	    //document.getElementById("UseStudyNo").checked=false;
	    //document.getElementById("UseNo").checked=false;
	    document.getElementById("MoreStudyNo").checked=false;
        
	}
	
	
}


function SetStudyNoCreatRule(Info,OperateCode)
{
	var SetCreatRule=document.getElementById("SetStudyNoCreatRule").value;
	var value=cspRunServerMethod(SetCreatRule,Info,OperateCode);
	if (value!="0")
	{  
	     if(OperateCode=="I")
	     {
		    var Info="增加失败:返回值="+value;
		 }
	     if(OperateCode=="U")
	     {
		    var Info="更新失败:返回值="+value;
		 }
		 else
		 {
			var Info="删除失败:返回值="+value;
	     }	 
		
	}
	else
	{   
		/*var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisMemoSet";
   		location.href=lnk;*/
   		window.location.reload();
   		
	}
	
}


function SetUseStudy_click()
{
	document.getElementById("UseStudyNo").checked=false;
}

function SetUseNO_click()
{
	document.getElementById("UseNo").checked=false;
}

function SelAppType()
{
	var AppType;
	
	if(document.getElementById("UseNo").checked)
	{
		document.getElementById("UseStudyNo").checked=false;
		AppType="0"
	}
	if(document.getElementById("UseStudyNo").checked)
	{
		document.getElementById("UseNo").checked=false;
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

//选择检查子类
function SelectOrdSubCat(Info)
{
    Item=Info.split("^");
    document.getElementById("subOrdSubCat").value=Item[1];
    document.getElementById("OrdSubCatID").value=Item[0];

}

//选择资源组
function GetGroupDesc(Info)
{
  Item=Info.split("^");
  document.getElementById("GroupDesc").value=Item[2];
  document.getElementById("GroupDR").value=Item[0]; 
	
}

function SelMoreStydyNo()
{
	/*
	var More="N";
	
	if(document.getElementById("MoreStudyNo").checked)
	{
		
		More="Y";
	}
	return More
	*/
	return "";
}

document.body.onload = BodyLoadHandler;

