
//名称	DHCPEDoctorBatchRecord .js
//功能	批量录入
//组件	DHCPEDoctorBatchRecord 	
//创建	2018.09.30
//创建人  xy


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
	var ArrivedDate="",CheckDate="",DocID="",LocID="",GroupID="";

	var ArrivedDate=getValueById("ArrivedDate");
	
	var CheckDate=getValueById("CheckDate");
	
	DocID=session['LOGON.USERID'];
	LocID=session['LOGON.CTLOCID'];
	GroupID=session['LOGON.GROUPID'];
	
	var ret=tkMakeServerCall("web.DHCPE.DoctorBatchRecord","BatchSaveResult",ArrivedDate,CheckDate,DocID,GroupID,LocID);
	
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
            //alert(lnk)
    location.href=lnk; 
   
}
