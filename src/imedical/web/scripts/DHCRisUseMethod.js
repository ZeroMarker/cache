//DHCRisUseMethod.js
//sunyi 2012-05-16

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
	
	if ((Code=="")||(Desc==""))
	{
	   str="��������Ʋ���Ϊ��!";
	   alert(str);
	   return;
	}
	
	
	Info=Rowid+"^"+Code+"^"+Desc;
	SetDHCRBCUse(Info,OperateCode);
}


function Update_click()
{
	var OperateCode="U"
	var SelRowid=document.getElementById("SelRowid").value;
	
	if (SelRowid=="")
	{
		alert("δѡ���¼���ܸ���!")
		return;
		
	}
	var Code=document.getElementById("Code").value;
	var Desc=document.getElementById("Desc").value;

	
    if ((Code=="")||(Desc==""))
	{
	   str="��������Ʋ���Ϊ��!";
	   alert(str);
	   return;
	}
	
	
	Info=SelRowid+"^"+Code+"^"+Desc;
	SetDHCRBCUse(Info,OperateCode);
	
}

function Delete_click()
{
    var OperateCode="D"
	var SelRowid=document.getElementById("SelRowid").value;
	
	if (SelRowid=="")
	{
		alert("δѡ���¼����ɾ��!")
		return;
		
	}
	
	var str="^^";
    var Info=SelRowid+str;
    SetDHCRBCUse(Info,OperateCode);
	
}

function Query_click()
{
	var Desc=document.getElementById("Desc").value;
	var Code=document.getElementById("Code").value;
	var Info=Code+"^"+Desc;
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisUseMethod"+"&Info="+Info;
}


function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisUseMethod');
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
	
	
	
}


function SetDHCRBCUse(Info,OperateCode)
{
	var SetUseFun=document.getElementById("SetUseFun").value;
	var value=cspRunServerMethod(SetUseFun,Info,OperateCode);
	
	//alert(value)
	
	if (value!="0")
	{  
	     if(OperateCode=="I")
	     {
		    var Info="����ʧ��:SQLCODE="+value;
		 }
	     if(OperateCode=="U")
	     {
		    var Info="����ʧ��:SQLCODE="+value;
		 }
		 if(OperateCode=="D")
		 {
			if(value=="-999")
			{
			   var Info="��ʹ�ò���ɾ��:SQLCODE="+value;	
			}
			else
			{
			   var Info="ɾ��ʧ��:SQLCODE="+value;
			}
			
	     }
	     alert(Info);
	     return;	 
		
	}
	else
	{   
		/*var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisUseMethod";
   		location.href=lnk;*/
   		window.location.reload();
   		
	}
	
}


document.body.onload = BodyLoadHandler;

