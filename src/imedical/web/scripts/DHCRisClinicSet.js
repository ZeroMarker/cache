//DHCRisClinicSet.js
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
	
    QueryLoc();
}

function Add_click()
{
	 var OperateCode="I";
	 var Rowid="";
	 
	 var SetData=SetClinicData()
	 var Info=Rowid+"^"+SetData;
	 
	 SetClinicSetFun(Info,OperateCode);
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
	
	 var SetData=SetClinicData()
	 var Info=SelRowid+"^"+SetData;
	 
	 SetClinicSetFun(Info,OperateCode);
	
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
	
	var str="^^^^^^^^^^^^^^^^^";
    var Info=SelRowid+str;
    SetClinicSetFun(Info,OperateCode)
	
}


function Query_click()
{
	var LocID=document.getElementById("SelLoc").value;
	var Info=LocID+"^";
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisClinicSet"+"&Info="+Info;
	
}

function SelectRowHandler()
{
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisClinicSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;

     var LocName=document.getElementById("TLocNamez"+selectrow).innerText;
     var LocDR=document.getElementById("TLocDRz"+selectrow).value;
     var SelRowid=document.getElementById("TRowidz"+selectrow).value;
     
     var ReportFullFile=document.getElementById("TReportFullFilez"+selectrow).innerText;
     var RegYesNo=document.getElementById("TRegYesNoz"+selectrow).innerText;
	 var RRegParam=document.getElementById("TRRegParamz"+selectrow).innerText;
	 var RStudyNOYesNo=document.getElementById("TRStudyNOYesNoz"+selectrow).innerText;
	 var RStudyParam=document.getElementById("TRStudyParamz"+selectrow).innerText;
	 var ROtherYesNo=document.getElementById("TROtherYesNoz"+selectrow).innerText;
	 var ROtherParam=document.getElementById("TROtherParamz"+selectrow).innerText;
	 var ReportDelim=document.getElementById("TReportDelimz"+selectrow).innerText;
	 var RNeedOrderRowid=document.getElementById("TROeitemYesNoz"+selectrow).innerText;
	 var ROrderParam=document.getElementById("TROeitemParamz"+selectrow).innerText;
	 
	 
	 var ImageFullFile=document.getElementById("TImageFullFilez"+selectrow).innerText;
	 var IRegYesNo=document.getElementById("TIRegYesNoz"+selectrow).innerText;
	 var IRegParam=document.getElementById("TIRegParamz"+selectrow).innerText;
	 var IStudyNOYesNo=document.getElementById("TIStudyNOYesNoz"+selectrow).innerText;
	 var IStudyNOParam=document.getElementById("TIStudyNOParamz"+selectrow).innerText;
	 var IOtherYerNo=document.getElementById("TIOtherYesNoz"+selectrow).innerText;
	 var IOtherParam=document.getElementById("TIOherParamz"+selectrow).innerText;
	 var ImageDelim=document.getElementById("TImageDelimz"+selectrow).innerText;
     var INeedOrderRowid=document.getElementById("TIOeitemYesNoz"+selectrow).innerText;
	 var IOrderParam=document.getElementById("TIOeitemParamz"+selectrow).innerText;
	
	

 	 if (RegYesNo=="Y")
     {
  	     document.getElementById("RegYesNo").checked=true;
     }
     else
     {
  	     document.getElementById("RegYesNo").checked=false;
     }
     
     
     if (RStudyNOYesNo=="Y")
     {
  	     document.getElementById("RStudyNOYesNo").checked=true;
     }
     else
     {
  	     document.getElementById("RStudyNOYesNo").checked=false;
     }
     
     if (ROtherYesNo=="Y")
     {
  	     document.getElementById("ROtherYesNo").checked=true;
     }
     else
     {
  	     document.getElementById("ROtherYesNo").checked=false;
     }
     
    
     if (IRegYesNo=="Y")
     {
  	     document.getElementById("IRegYesNo").checked=true;
     }
     else
     {
  	     document.getElementById("IRegYesNo").checked=false;
     }
     
     if (IStudyNOYesNo=="Y")
     {
  	     document.getElementById("IStudyNOYesNo").checked=true;
     }
     else
     {
  	     document.getElementById("IStudyNOYesNo").checked=false;
     }
     
     if (IOtherYerNo=="Y")
     {
  	     document.getElementById("IOtherYerNo").checked=true;
     }
     else
     {
  	     document.getElementById("IOtherYerNo").checked=false;
     }
	 
	 
	//报告参数 
	var SeleRowidObj=document.getElementById("SelRowid");
	if (SeleRowidObj)
	{
		SeleRowidObj.value=SelRowid;
	}
	
	var ReportFullFileObj=document.getElementById("ReportFullFile");
	if (ReportFullFileObj)
	{
		ReportFullFileObj.value=ReportFullFile;
	}
	var RRegParamObj=document.getElementById("RRegParam");
	if (RRegParamObj)
	{
		RRegParamObj.value=RRegParam;
	}
	var RStudyParamObj=document.getElementById("RStudyParam");
	if (RStudyParamObj)
	{
		RStudyParamObj.value=RStudyParam;
	}
	var ROtherParamObj=document.getElementById("ROtherParam");
	if (ROtherParamObj)
	{
		ROtherParamObj.value=ROtherParam;
	}
	
	var ReportDelimObj=document.getElementById("ReportDelim");
	if (ReportDelimObj)
	{
		ReportDelimObj.value=ReportDelim;
	}
	
	
	//影像参数
	 
	var ImageFullFileObj=document.getElementById("ImageFullFile");
	if (ImageFullFileObj)
	{
		ImageFullFileObj.value=ImageFullFile;
	}
	var IRegParamObj=document.getElementById("IRegParam");
	if (IRegParamObj)
	{
		IRegParamObj.value=IRegParam;
	}
	var IStudyNOParamObj=document.getElementById("IStudyNOParam");
	if (IStudyNOParamObj)
	{
		IStudyNOParamObj.value=IStudyNOParam;
	}
	var IOtherParamObj=document.getElementById("IOtherParam");
	if (IOtherParamObj)
	{
		IOtherParamObj.value=IOtherParam;
	}
	
	var ImageDelimObj=document.getElementById("ImageDelim");
	if (ImageDelimObj)
	{
		ImageDelimObj.value=ImageDelim;
	}

	var SelLocObj=document.getElementById("SelLoc");
    if (SelLocObj)
    {
	   SelLocObj.value=LocDR;
    }  SelLocObj.text=LocName;

	//
	if (RNeedOrderRowid=="Y")
	{
		document.getElementById("ROeitemYesNo").checked=true;
	}
	else
	{
		document.getElementById("ROeitemYesNo").checked=false;
	}
	
	if (INeedOrderRowid=="Y")
	{
		document.getElementById("IOeitemYesNo").checked=true;
	}
	else
	{
		document.getElementById("IOeitemYesNo").checked=false;
	}
	
	document.getElementById("ROeitemParam").value=ROrderParam;
	document.getElementById("IOeitemParam").value=IOrderParam;
	
	
	//
	var isOpenList=document.getElementById("TIsOpenListz"+selectrow).innerText;
	var ckIsOpenList=document.getElementById("isOpenList");
	if (ckIsOpenList)
	{
		if (isOpenList=="Y")
			ckIsOpenList.checked=true;
		else
           	ckIsOpenList.checked=false;
           				
	}	
}




function SetClinicSetFun(Info,OperateCode)
{
	var SetClinicSetFun=document.getElementById("SetClinicSetFun").value;
	var value=cspRunServerMethod(SetClinicSetFun,Info,OperateCode);
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
		/*var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisClinicSet";
   		location.href=lnk;*/
   		window.location.reload(); 
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


function SetClinicData()
{
	 if (document.getElementById("RegYesNo").checked)
     {
  	     var RegYesNo="Y";
     }
     else
     {
  	     var RegYesNo="N";
     }
     
     if (document.getElementById("RStudyNOYesNo").checked)
     {
  	     var RStudyNOYesNo="Y";
     }
     else
     {
  	     var RStudyNOYesNo="N";
     }
     
     if (document.getElementById("ROtherYesNo").checked)
     {
  	     var ROtherYesNo="Y";
     }
     else
     {
  	     var ROtherYesNo="N";
     }
     
     if (document.getElementById("IRegYesNo").checked)
     {
  	     var IRegYesNo="Y";
     }
     else
     {
  	     var IRegYesNo="N";
     }
     
     if (document.getElementById("IStudyNOYesNo").checked)
     {
  	     var IStudyNOYesNo="Y";
     }
     else
     {
  	     var IStudyNOYesNo="N";
     }
     
     if (document.getElementById("IOtherYerNo").checked)
     {
  	     var IOtherYerNo="Y";
     }
     else
     {
  	     var IOtherYerNo="N";
     }
	 
	 var SelLocObj=document.getElementById("SelLoc");
	 if (SelLocObj)
	 {
		 var LocId=SelLocObj.value;
	 }
	 
	 //20170310
	 var isOpenList=""
	var isOpenListObj=document.getElementById("isOpenList");
	if (isOpenListObj)
	{
		if (isOpenListObj.checked)
		{
			isOpenList="Y"	
		}
           				
	}
	var RNeedOrder="";
	var INeedOrder="";
	if ( document.getElementById("IOeitemYesNo").checked )
		INeedOrder="Y";
	if ( document.getElementById("ROeitemYesNo").checked )
		RNeedOrder="Y";
	
	
	var ROrderParam=document.getElementById("ROeitemParam").value;
	var IOrderParam=document.getElementById("IOeitemParam").value;
	 
	 var ReportFullFile=document.getElementById("ReportFullFile").value;
	 var RRegParam=document.getElementById("RRegParam").value;
	 var RStudyParam=document.getElementById("RStudyParam").value;
	 var ROtherParam=document.getElementById("ROtherParam").value;
	 var ReportDelim=document.getElementById("ReportDelim").value;
	 
	 var ImageFullFile=document.getElementById("ImageFullFile").value;
	 var IRegParam=document.getElementById("IRegParam").value;
	 var IStudyNOParam=document.getElementById("IStudyNOParam").value;
	 var IOtherParam=document.getElementById("IOtherParam").value;
	 var ImageDelim=document.getElementById("ImageDelim").value;
     
     var Info=LocId+"^"+ReportFullFile+"^"+RegYesNo+"^"+RRegParam+"^"+RStudyNOYesNo+"^"+RStudyParam+"^"+ReportDelim;
         Info=Info+"^"+ImageFullFile+"^"+IRegYesNo+"^"+IRegParam+"^"+IStudyNOYesNo+"^"+IStudyNOParam+"^"+ImageDelim+"^"+ROtherYesNo+"^"+ROtherParam+"^"+IOtherYerNo+"^"+IOtherParam;
         Info=Info+"^"+ROrderParam+"^"+RNeedOrder+"^"+IOrderParam+"^"+INeedOrder+"^"+isOpenList;
     return Info;
}



document.body.onload = BodyLoadHandler;