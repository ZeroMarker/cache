//DHCRisBookedItem.js

var SelectedRow="-1";

function BodyLoadHandler()
{
	
}




function GetCurrentDate()
{
	var d, s="";         
    d = new Date(); 
    var sDay="",sMonth="",sYear="";
    sDay = d.getDate();		
    if(sDay < 10)
    sDay = "0"+sDay;
    
    sMonth = d.getMonth()+1;		
    if(sMonth < 10)
    sMonth = "0"+sMonth;
    
    sYear  = d.getYear();	
    
    var sHoure=d.getHours();
    var sMintues=d.getMinutes();
    	
    s=sYear +"-"+sMonth+"-"+sDay+"    "+sHoure+":"+sMintues ;
    
    return s;

}

function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisBookedItem');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
    
     
    
         var MemoLink='TMemoz'+selectrow;
   	 if(eSrc.id==MemoLink)
  	 {
	  	var OEOrdItemID=document.getElementById("OEOrdItemIDz"+selectrow).value;
	  	window.showModalDialog("websys.default.csp?WEBSYS.TCOMPONENT=DHCRisMemoBrowse&OEOrdItemID="+OEOrdItemID,"","dialogwidth:500px;dialogheight:300px;status:no;center:1;resizable:yes");
	  	return false;
  	 }	
       
        return false; 

}



document.body.onload = BodyLoadHandler;



