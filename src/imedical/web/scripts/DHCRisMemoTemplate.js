//DHCRisMemoTemplate.js
//sunyi 2012-04-20

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
	var Rowid=""
	var Info=""
	
	var Code=document.getElementById("Code").value;
	var Desc=document.getElementById("Desc").value;
	var Content=document.getElementById("Content").value;
	
	if ((Code=="")||(Desc==""))
	{
	   str="代码或名称不能为空!";
	   alert(str);
	   return;
	}
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisMemoTemplate');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

for (i=1;i<rows;i++)
    {   
	    //var ItemCatDesc=document.getElementById("ItemCatz"+i).innerText;
	    var CodeL=document.getElementById("TCodez"+i).innerText;
 	    var DescL=document.getElementById("TDescz"+i).innerText;
	    //alert(ItmMastDesc)
	    if ((CodeL==Code)||(DescL==Desc))
	    {
		    alert("模板已存在,不能重复添加");
		    return;
	    }
	}
	
	Info=Rowid+"^"+Code+"^"+Desc+"^"+Content;
	SetDHCRBMemoSet(Info,OperateCode);
}


function Update_click()
{
	var OperateCode="U"
	var SelRowid=document.getElementById("SelRowid").value;
	
	if (SelRowid=="")
	{
		alert("未选择记录不能更新!")
		return;
		
	}
	var Code=document.getElementById("Code").value;
	var Desc=document.getElementById("Desc").value;
	var Content=document.getElementById("Content").value;
	
    if ((Code=="")||(Desc==""))
	{
	   str="代码或名称不能为空!";
	   alert(str);
	   return;
	}
	
	
	Info=SelRowid+"^"+Code+"^"+Desc+"^"+Content;
	SetDHCRBMemoSet(Info,OperateCode);
	
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
	
	var str="^^^";
    var Info=SelRowid+str;
    SetDHCRBMemoSet(Info,OperateCode);
	
}

function Query_click()
{
	var Desc=document.getElementById("Desc").value;
	var Code=document.getElementById("Code").value;
	var Info=Desc+"^"+Code;
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisMemoTemplate"+"&Info="+Info;
}


function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisMemoTemplate');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

    
 	var SelRowid=document.getElementById("TRowidz"+selectrow).value;
 	var Code=document.getElementById("TCodez"+selectrow).innerText;
 	var Desc=document.getElementById("TDescz"+selectrow).innerText;
	
	var SeleRowidObj=document.getElementById("SelRowid");
	if (SeleRowidObj)
	{
		SeleRowidObj.value=SelRowid;
		var GetMTemplateFun=document.getElementById("GetMTemplateFun").value;
	    var value=cspRunServerMethod(GetMTemplateFun,SelRowid);
	    var Content=ReplaceInfo(value);  
	}
	
	var CodeObj=document.getElementById("Code");
	if(CodeObj)
	{
		CodeObj.value=Code;
	}
	
	var DescObj=document.getElementById("Desc");
	if(DescObj)
	{
	   DescObj.value=Desc;	
	}
	
	var ContentObj=document.getElementById("Content");
	if(ContentObj)
	{
	   ContentObj.value=Content;
	}
	
	
}


function SetDHCRBMemoSet(Info,OperateCode)
{
	var SetMTemplateFun=document.getElementById("SetMTemplateFun").value;
	var value=cspRunServerMethod(SetMTemplateFun,Info,OperateCode);
	
	if (value!="0")
	{  
	     if(OperateCode=="I")
	     {
		    var Info="增加失败 : 返回值="+value;
		 }
	     if(OperateCode=="U")
	     {
		    var Info="更新失败 : 返回值="+value;
		 }
		 if(OperateCode=="D")
		 {
			if(value=="-999")
			{
			   var Info="已使用不能删除";	
			}
			else
			{
			   var Info="删除失败 : 返回值="+value;
			}
			
	     }
	     alert(Info);
	     return;	 
		
	}
	else
	{   
		/*var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisMemoTemplate";
   		location.href=lnk;*/
   		window.location.reload();
   		
	}
	
}




function ReplaceInfo(Strtmp)
{
   Info=Strtmp.replace(new RegExp("X000b","g"),"\r");
   Info=Info.replace(new RegExp("X000a","g"),"\n");
   return Info ;
}

document.body.onload = BodyLoadHandler;

