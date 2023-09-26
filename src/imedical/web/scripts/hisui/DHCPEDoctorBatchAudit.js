

//名称	DHCPEDoctorBatchAudit .js
//功能	批量总检初审/复审
//组件	DHCPEDoctorBatchAudit
//创建	2018.09.30
//创建人  xy

document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{
	
	$("#BBatchAudit").click(function() {
				BBatchAudit_click();		
        });
	
	$("#BFind").click(function() {
				BFind_click();		
        });
        
      info();
	
}

function info()
{
	 var MainDoctor=getValueById("MainDoctor");
	if(MainDoctor){
		var obj=document.getElementById("cTitle");
		if (obj){obj.innerText="批量总检复审";}
			
	}
}
function BFind_click()
{
	var ArrivedDate=getValueById("ArrivedDate");
    
    var MainDoctor=getValueById("MainDoctor");
    if(MainDoctor){MainDoctor="Y";}
    else {MainDoctor="N";}
	
	var ShowErr=getValueById("ShowErr");
	if(ShowErr){ShowErr=1;}
	else{ShowErr=0;}
	
	lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEDoctorBatchAudit&ArrivedDate="+ArrivedDate+"&ShowErr="+ShowErr+"&MainDoctor="+MainDoctor;
	//alert(lnk)
	window.location.href=lnk;
}

function BBatchAudit_click()
{
	var encmeth="",DocID="";
	var obj=document.getElementById("BatchClass");
	if (obj) encmeth=obj.value;
	
	var ArrivedDate=getValueById("ArrivedDate");
	
	var AuditDate=getValueById("AuditDate");
	
	var MainDoctor=getValueById("MainDoctor");
	if(MainDoctor){MainDoctor="Y";}
	else{MainDoctor="N"}
	
	var NoResultFlag=getValueById("NoResultFlag");
	if(NoResultFlag){NoResultFlag="1";}
	else{NoResultFlag="0"}
	
	DocID=session['LOGON.USERID'];
	
	var ret=cspRunServerMethod(encmeth,ArrivedDate,AuditDate,DocID,MainDoctor,NoResultFlag);
	
	BFind_click();
}