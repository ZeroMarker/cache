
//DHCPisclinicQueryOEItem
var CurrentSel=0
var PatientID,StudyNo;
var RptParm;
function BodyLoadHandler() 
{
  var rows=1
	var objtbl=document.getElementById('tDHCPisclinicQueryOEItem');
	if (objtbl) 
	{ 
		var rows=objtbl.rows.length; 
	}
	//tmpobj是zcl添加的（参�?�DHCLabOrderList.js�?
	var tmpobj
	for(var index=1;index<rows;index++)
	{
		tmpobj=document.getElementById('TReadFlag2z'+index);		
	 	//alert(document.getElementById("TIsOpenFrostRptz"+index).innerText)
		if(document.getElementById("TIsOpenFrostRptz"+index).innerText==1)
		{
			//PlayMusic()			
			RowHandler(index)
			
		}
	}
}

function SelectRowHandler()
{
   var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCPisclinicQueryOEItem');
	if (objtbl) { var rows=objtbl.rows.length; }
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	
	CurrentSel=selectrow;
	
	var TItemStatus=document.getElementById('TItemStatus'+'z'+selectrow).innerText;
    	//var LocDr=document.getElementById('TreplocDr'+'z'+selectrow).innerText;
	var TOEOrderDr=document.getElementById('TOEOrderDr'+'z'+selectrow).innerText;
	//var TRptCls=document.getElementById('TRptCls'+'z'+selectrow).innerText;
	//zcl add 2015-3-24
    var TRptCls=document.getElementById('TRptRowid'+'z'+selectrow).innerText;
	var reportzlink='TOpenRptz'+selectrow;
	var allreportzlink='TOpenAllRptz'+selectrow;	
	var readzlink='TIfReadz'+selectrow;	
	var readCauselink='IsdelayReportz'+selectrow;
	
    var readflagzlink='TReadFlag2z'+selectrow;	
    if (eSrc.id==reportzlink)
  	{	
	   	var docCode=session['LOGON.USERCODE']
	   	GetRptParm(TOEOrderDr,TRptCls,docCode);
		//点击"已阅�?，查看报告阅读信�?
		var UserId=session['LOGON.USERID']
		var AddViewLogFun=document.getElementById("AddViewLog").value
		var vstatus=cspRunServerMethod(AddViewLogFun,UserId,"","",TOEOrderDr)	
		//打开报告
		window.open(RptParm);
		return false;
  	}
  	else
  	{
	
	}
	
	if(eSrc.id==allreportzlink)
	{
		var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCPisReport"+"&OEorditemID="+TOEOrderDr
    	var mynewlink=open(link,"DHCPisAppTemplList","scrollbars=yes,resizable=yes,top=50,left=50,width=900,height=600");
	}
	
	//zcl add
	if (eSrc.id==readzlink)
	{
		var docCode=session['LOGON.USERCODE']
		var SetReadFlagFun=document.getElementById("SetReadFlag").value
		var readflag=cspRunServerMethod(SetReadFlagFun,TOEOrderDr,TRptCls,docCode)
		
		 if (readflag!="")
	     {	  
	 	    location.reload() 
         }
	}
	//点击"已阅�?，查看报告阅读信�?
	/*if (eSrc.id==readflagzlink)
  	{       
	var UserId=session['LOGON.USERID']
	var AddViewLogFun=document.getElementById("AddViewLog").value
  	var vstatus=cspRunServerMethod(AddViewLogFun,UserId,"","",TOEOrderDr)	   
  	}*/
	//zs add
	if (eSrc.id==readCauselink)
	{
		var GetC=document.getElementById("ReadCause").value
		var readCause=cspRunServerMethod(GetC,"87",TOEOrderDr)
		if(readCause!="")
		{
			alert(readCause) 
		}
		location.reload()
	}
}

function bodyunload()
{
	//alert("unload");
}

function RowHandler(selectrow)
{
	if (!selectrow) return;
	
	CurrentSel=selectrow;
	
	var TItemStatus=document.getElementById('TItemStatus'+'z'+selectrow).innerText;
    //var LocDr=document.getElementById('TreplocDr'+'z'+selectrow).innerText;
	var TOEOrderDr=document.getElementById('TOEOrderDr'+'z'+selectrow).innerText;	
	//var TRptCls=document.getElementById('TRptCls'+'z'+selectrow).innerText;
	var TRptCls=document.getElementById('TRptClsDesc'+'z'+selectrow).innerText;

	var reportzlink='TOpenRptz'+selectrow;
	var allreportzlink='TOpenAllRptz'+selectrow;
	//zcl add
	var readzlink='TIfReadz'+selectrow;	
 	//GetRptParm(TOEOrderDr,TRptCls,docCode);

	window.open(RptParm,"DHCPisReport","scrollbars=yes,resizable=yes,top=50,left=50,width=900,height=600");
	return false;

}

function PlayMusic()
{
  //C:\\Run.mp3
  var wss = new ActiveXObject("WScript.Shell");
	wss.run("C:\\Run.mp3");
	
}

function GetRptParm(TOEOrderDr,TRptCls,docCode)
{	
	RptParm = "";	
    RptParm ='http://172.19.19.82/PISWeb/Default.aspx?OID='+ TOEOrderDr+'&RPTID='+TRptCls+'&DOCCODE='+docCode;
    
}
//zcl加的ChkUnReadWarnReport()和MarkAsAbnormal

function ChkUnReadWarnReport() {
	var tbl=document.getElementById("tDHCPisclinicQueryOEItem");
	for (var curr_row=1; curr_row<tbl.rows.length; curr_row++) {
		var FlagValue = document.getElementById("ReadFlagz" + curr_row);
        if (FlagValue==null){
        	MarkAsAbnormal(curr_row,tbl);
        }
	}
}

function MarkAsAbnormal(CurrentRow,tableobj) {
	for (var CurrentCell=0; CurrentCell<tableobj.rows[CurrentRow].cells.length; CurrentCell++) {
		tableobj.rows[CurrentRow].cells[CurrentCell].style.color="Red";
	}
}


setTimeout("BodyLoadHandler();",1000)
setTimeout("window.parent.frames['dataframe'].location.reload();",600000)
document.body.onload = BodyLoadHandler;
document.body.onunload= bodyunload;
