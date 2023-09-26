var SelectedRow = 0;
var Guser
function BodyLoadHandler() {  
  Guser=session['LOGON.USERID']
  }
 function SelectRowHandler()	
{  
    var stdate,enddate
	var eSrc=window.event.srcElement;
	Objtbl=document.getElementById('tUDHCJFAcountHis');
	Rows=Objtbl.rows.length;
	
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	
	stdate=document.getElementById('TStDatez'+selectrow).innerText;
	enddate=document.getElementById('TEndDatez'+selectrow).innerText;
	var year,mon,day
	var str=stdate.split("-")
	
	year=str[0],mon=str[1],day=str[2]
	stdate=day+"/"+mon+"/"+year
	var str=enddate.split("-")
	year=str[0],mon=str[1],day=str[2]
	enddate=day+"/"+mon+"/"+year
    var Flag
    Flag=document.getElementById('Flag').value;
	SelRowObj=document.getElementById('TJSRowIdz'+selectrow);
    var jsrowid=SelRowObj.innerText;
    if (Flag=="FLFEEACOUNT")
        
    {    
        window.opener.document.getElementById("stdate").value=stdate
        //window.opener.document.getElementById("jsflag").checked=true
        window.opener.document.getElementById("enddate").value=enddate
        window.opener.document.getElementById("jsrowid").value=jsrowid
        opener.Find_click()
    }
    window.close();
   
}
  document.body.onload = BodyLoadHandler;