
//����	DHCPEDoctorBatchRecord .js
//����	����¼��
//���	DHCPEDoctorBatchRecord 	
//����	2018.09.30
//������  xy


document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{
	
	$("#BBatchResult").click(function() {
				BBatchResult_click();		
        });

	$("#BFind").click(function() {
				BFind_click();		
        });
	
}
function BBatchResult_click()
{
	var encmeth="",ArrivedDate="",CheckDate="",DocID="",LocID="",GroupID="";
	var obj=document.getElementById("BatchClass");
	if (obj) encmeth=obj.value;
	var ArrivedDate=getValueById("ArrivedDate");
	var CheckDate=getValueById("CheckDate");
	
	DocID=session['LOGON.USERID'];
	LocID=session['LOGON.CTLOCID'];
	GroupID=session['LOGON.GROUPID'];
	var ret=cspRunServerMethod(encmeth,ArrivedDate,CheckDate,DocID,GroupID,LocID);
	BFind_click();
}

function BFind_click()
{
	var iArrivedDate=getValueById("ArrivedDate");
    
    var iCheckDate=getValueById("CheckDate");
    
	var ShowErr=getValueById("ShowErr");
	if(ShowErr){ShowErr=1;}
	else{ShowErr=0;}
    
    var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEDoctorBatchRecord"
			+"&ArrivedDate="+iArrivedDate
			+"&CheckDate="+iCheckDate
			+"&ShowErr="+ShowErr
		    ;
            //messageShow("","","",lnk)
    location.href=lnk; 
   
}