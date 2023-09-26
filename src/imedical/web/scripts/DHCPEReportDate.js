
function BodyLoadHandler(){
	var obj;   
	obj=document.getElementById("BConfirm"); //确认
	if (obj){ obj.onclick=BConfirm_click; }
	
	obj=document.getElementById("BCancle"); //确认
	if (obj){ obj.onclick=BCancle_click; }
	
	obj=document.getElementById("BSaveResult");
	if (obj){ obj.onclick=BSaveResult_click; }
	 obj=document.getElementById("ReportDate");
	if (obj){ obj.onkeydown=ReportDate_keydown; }
	 //alert(1)
	 //obj=document.getElementById("BPrint");
	//if (obj){ obj.onclick=PisRequestPrint; 
	//PisRequestPrint
	
	document.onkeydown=Doc_OnKeyDown;
	SetFocus(); 
}
function RefuseItem(e)
{
	if (!confirm("确实要放弃'"+e.innerText+"'吗")) return false;
	var OEID=e.id;
	var ret=tkMakeServerCall("web.DHCPE.ResultEdit","RefuseCheck",OEID);
	window.location.reload();
}
function SetFocus()
{
	var obj=document.getElementsByName('result'); //.length
	if (obj) ResultLength=obj.length;
	if (ResultLength>0){
		var ID=obj[0];
		websys_setfocus(ID); 
	}else{
		websys_setfocus("ReportDate"); 
	}
}
function Doc_OnKeyDown(){
	if (event.keyCode==13)
	{
		event.keyCode=9;
		
		////F2
		//document.onkeydown=function(){return false;}
		//alert('dacc')
		document.onkeydown=Doc_OnKeyDown;
	}
	
}
function ReportDate_keydown()
{
	var Key=websys_getKey(e); 
	if ((13==Key)) 
	{
		websys_setfocus("BConfirm");  
	}
	
}

function BCancle_click()
{
	//parent.opener.BFind_click();
	 parent.opener.location.reload();
	parent.close();
	return false 


}

function BSaveResult_click()
{
	var ResultLength=0,ResultObj,Result="",ResultID="";
	var obj=document.getElementsByName('result'); //.length
	if (obj) ResultLength=obj.length;
	var ResultStr="";
	for (var i=0;i<ResultLength;i++)
	{
		ResultObj=obj[i];
		Result=ResultObj.value;
		ResultID=ResultObj.id;
		var OneStr=ResultID+"#"+Result;
		if (ResultStr==""){
			ResultStr=OneStr;
		}else{
			ResultStr=ResultStr+"%"+OneStr;
		}
	}
	var Return=tkMakeServerCall("web.DHCPE.DHCPEIAdm","SaveResult",ResultStr);
	if (Return=="0"){
		
		window.location.reload();
		
		}
	else{
	alert(Return)
	}

}
function BConfirm_click()
{
	var obj;  
	var iReportDate="",iRegNo="",iSendMethod=""; 
 
	if (parent.opener){ 
	obj=document.getElementById("ReportDate");  
	if (obj){ iReportDate=obj.value; } 
	obj=document.getElementById("RegNo");  
	if (obj){ iRegNo=obj.value; }
	obj=document.getElementById("SendMethod"); 
	if (obj){ iSendMethod=obj.value; }
	
	var Return=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetRecPaper",iRegNo,iReportDate,iSendMethod);

	if (Return!=0)
	{   
		alert(Return);
    }
    parent.opener.location.reload();
    //parent.opener.BFind_click();
	parent.close();
	return true 
	 
	}
	
}
document.body.onload = BodyLoadHandler;