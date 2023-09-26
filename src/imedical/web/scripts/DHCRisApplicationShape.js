
//DHCRisApplicationShape.js
//sunyi 2011-10-12

function BodyLoadHandler()
{

	var AddObj=document.getElementById("Add");
	if (AddObj)
	{
		AddObj.onclick=Add_click;
	}
	
	var ModiObj=document.getElementById("Updata");
	if (ModiObj)
	{
		ModiObj.onclick=Updata_click;
	}
	
	var DeleteObj=document.getElementById("Delete");
	if (DeleteObj)
	{
		DeleteObj.onclick=Delete_click;
	}

}


/*function setHospitalID(Info)
{
	Item=Info.split("^");
	//alert(Info);
	document.getElementById("hospitalID").value=Item[0];
	document.getElementById("hospital").value=Item[1];
}*/

function Add_click()
{
	 var OperateCode="I";
	 var Rowid="";
	 var ComponentID=document.getElementById("ComponentID").value;
	 
	 if(ComponentID=="")
	 {
		 var error="���뵥��ʽID����Ϊ��!";
		 alert(error);
		 return ;
	 }
	  //�ж����뵥ID�Ƿ��ظ�
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisApplicationShape');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
    for (i=1;i<rows;i++)
    {   
	    var ComponentId=document.getElementById("TComponentIDz"+i).innerText;
	    //alert(ComponentId)
	    //alert(ComponentID)
	    if (ComponentId==ComponentID)
	    {
		    alert("���뵥ID�Ѿ�����,�����ظ����");
		    return;
	    }
	}
	 var ComponentName=document.getElementById("ComponentName").value;
	 var PrintTempName=document.getElementById("PrintTempName").value;
	 var HtmlTempleContent=document.getElementById("HtmlTempleContent").value;
	 //var hospitalID=trim(document.getElementById("hospitalID").value);
	 var Info=Rowid+"^"+ComponentID+"^"+ComponentName+"^"+PrintTempName+"^"+HtmlTempleContent;    //+"^"+hospitalID;
	 SetApplicationShape(Info,OperateCode);
}



function Updata_click()
{
	
	
	var SelRowid=document.getElementById("SelRowid").value;
	
	if (SelRowid=="")
	{
		alert("δѡ���¼���ܸ���!")
		return;
		
	}
	
	var OperateCode="U";
	var ComponentID=document.getElementById("ComponentID").value;
	var ComponentName=document.getElementById("ComponentName").value;
	var PrintTempName=document.getElementById("PrintTempName").value;
	var HtmlTempleContent=document.getElementById("HtmlTempleContent").value;
	/*var hospitalID=trim(document.getElementById("hospitalID").value);
	if (document.getElementById("hospital").value=="")
	{
		hospitalID="";
	}*/
	var Info=SelRowid+"^"+ComponentID+"^"+ComponentName+"^"+PrintTempName+"^"+HtmlTempleContent;   //+"^"+hospitalID;
	SetApplicationShape(Info,OperateCode);
	
	
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
	
	var str="^^^^^";
    var Info=SelRowid+str;

    SetApplicationShape(Info,OperateCode);
	
}



function SelectRowHandler()
{
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisApplicationShape');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

 	var SelRowid=document.getElementById("TRowidz"+selectrow).innerText;
	var ComponentID=document.getElementById("TComponentIDz"+selectrow).innerText;
	var ComponentName=document.getElementById("TComponentNamez"+selectrow).innerText;
	var PrintTempName= document.getElementById("TPrintTempNamez"+selectrow).innerText;
	
	//var hosDesc=trim(document.getElementById("THospitalDescz"+selectrow).innerText);	
	//var hosId=trim(document.getElementById("THospitalIDz"+selectrow).value);
	
	var SeleRowidObj=document.getElementById("SelRowid");
	
	if (SeleRowidObj)
	{
		SeleRowidObj.value=SelRowid;
		var HtmlTCObj=document.getElementById("HtmlTempleContent");
		HtmlTCObj.value=GetAppHtmlbyRowid(SelRowid);
	}
	
	var ComponentIDObj=document.getElementById("ComponentID");
	if (ComponentIDObj)
	{
		ComponentIDObj.value=ComponentID;
	}
	var ComponentNameObj=document.getElementById("ComponentName");
	if (ComponentNameObj)
	{
		ComponentNameObj.value=ComponentName;
	}

	var PrintTempNameObj=document.getElementById("PrintTempName");
	if (PrintTempNameObj)
	{
		PrintTempNameObj.value=PrintTempName;
	}	
	
	/*var hosObj=document.getElementById("hospital");
	//alert(hosObj);
	if (hosObj)
	{
		
		hosObj.value=hosDesc;
	}
	
	var hosIdObj=document.getElementById("hospitalID");
	//alert(hosIdObj);
	if (hosIdObj)
	{
		
		hosIdObj.value=hosId;
	}*/
	
}




function SetApplicationShape(Info,OperateCode)
{
	var InfoHint="";
	var SetApplicationShapeFun=document.getElementById("SetApplicationShape").value;
	var value=cspRunServerMethod(SetApplicationShapeFun,Info,OperateCode);
	if (value!="0")
	{  
	     if(OperateCode=="I")
	     {
		     InfoHint="����ʧ��:SQLCODE="+value;
		 }
	     if(OperateCode=="U")
	     {
		     InfoHint="����ʧ��:SQLCODE="+value;
		 }
		 else
		 {
			if ( value=="200")
			{
				 InfoHint="����������������������ɾ������ɾ���������!";
			}
			else
			{
			 	InfoHint="ɾ��ʧ��:SQLCODE="+value;
			}
	     }	 
		
	     alert(InfoHint);
	}
	else
	{   
		/*var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisApplicationShape";
   		location.href=lnk; */
   		window.location.reload();
	}
	
}


function GetAppHtmlbyRowid(AppRowid)
{
	var GetAppHtmlbyRowidFun=document.getElementById("GetAppHtmlbyRowid").value;
	var value=cspRunServerMethod(GetAppHtmlbyRowidFun,AppRowid);
	var HtmlTempleContent="";
	
	if(value!="")
	{
	  	HtmlTempleContent=value;
	}
	
	return HtmlTempleContent
}


function trim(str)
{ 
    //ɾ���������˵Ŀո�  
	return str.replace(/(^\s*)|(\s*$)/g, "");  
} 

document.body.onload = BodyLoadHandler;



