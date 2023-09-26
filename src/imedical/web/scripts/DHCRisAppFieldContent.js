
//DHCRisAppFieldContent.js
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
	 
	 var FieldName=document.getElementById("FieldName").value;
	 
	 if(FieldName=="")
	 {
		 alert("字段名称不能为空!");
		 return;
	 }
	 
	 var Code=document.getElementById("Code").value;
	 var FieldDR=document.getElementById("FieldDR").value;
	 var Content=document.getElementById("Content").value;
         if(Content=="")
	 {
		 alert("内容不能为空!");
		 return;
	 }
	 var Format=document.getElementById("Format").value;

         var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisAppFieldContent');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	 for (i=1;i<rows;i++)
    {   
	    var mFieldName=document.getElementById("TFieldNamez"+i).innerText;
	    var mContent=document.getElementById("TValuez"+i).innerText;
	    if ((mFieldName==FieldName)&&(mContent==Content))
	    {
		    alert("该记录已存在,不能重复添加");
		    return;
	    }
	}
	 var Info=Rowid+"^"+Code+"^"+FieldDR+"^"+Content+"^"+Format;
	 SetAppFieldContent(Info,OperateCode);
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
	
	 var FieldName=document.getElementById("FieldName").value;
	 if(FieldName=="")
	 {
		 alert("字段名称不能为空!");
		 return;
	 }
	 
	 var Code=document.getElementById("Code").value;
	 var FieldDR=document.getElementById("FieldDR").value;
	 var Content=document.getElementById("Content").value;
	 var Format=document.getElementById("Format").value;
    
	 var Info=SelRowid+"^"+Code+"^"+FieldDR+"^"+Content+"^"+Format;
	 SetAppFieldContent(Info,OperateCode);
	
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
     SetAppFieldContent(Info,OperateCode);
	
}


function Query_click()
{
	var Code=document.getElementById("Code").value;
	var FieldDR=document.getElementById("FieldDR").value;
	var Info=Code+"^"+FieldDR;
	document.getElementById("Info").value=Info;
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisAppFieldContent"+"&Info="+Info;
	
}


function SelectRowHandler()
{
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisAppFieldContent');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;

    
 	var SelRowid=document.getElementById("TRowidz"+selectrow).value;
	var Code=document.getElementById("TCodez"+selectrow).innerText;
	var FieldName=document.getElementById("TFieldNamez"+selectrow).innerText;
	var FieldDR=document.getElementById("TFieldDRz"+selectrow).value;
	var Content=document.getElementById("TValuez"+selectrow).innerText;
	var Format=document.getElementById("TFormatz"+selectrow).innerText;
	
	
	
	
	var SeleRowidObj=document.getElementById("SelRowid");
	if (SeleRowidObj)
	{
		SeleRowidObj.value=SelRowid;
	}
	
	var CodeObj=document.getElementById("Code");
	if (CodeObj)
	{
		CodeObj.value=Code;
	}
	var FieldNameObj=document.getElementById("FieldName");
	if (FieldNameObj)
	{
		FieldNameObj.value=FieldName;
	}
	var ContentObj=document.getElementById("Content");
	if (ContentObj)
	{
		ContentObj.value=Content;
	}
	var FormatObj=document.getElementById("Format");
	if (FormatObj)
	{
		FormatObj.value=Format;
	}
	
	var FieldDRObj=document.getElementById("FieldDR");
	if (FieldDRObj)
	{
		FieldDRObj.value=FieldDR;
	}
	
}




function SetAppFieldContent(Info,OperateCode)
{
	var SetApplicationFieldFun=document.getElementById("SetAppFieldContent").value;
	var value=cspRunServerMethod(SetApplicationFieldFun,Info,OperateCode);
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
		//var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisAppFieldContent";
   		//location.href=lnk; 
   		window.location.reload();
	}
	
}



function GetSelectFieldInfo(Info)
{
  Item=Info.split("^");
  document.getElementById("FieldName").value=Item[1];
  document.getElementById("FieldDR").value=Item[0]; 
	
}



document.body.onload = BodyLoadHandler;
