document.write('<style type="text/css">')
document.write('.pagebg{')
document.write('background:#F4F4F4;')
document.write('border:1px solid #dddddd;')
document.write('height:50px;')
document.write('list-style:none;')
document.write('}')
document.write('</style>')
function BodyLoadHandler()
{
	iniBgColor()
}
var selRow=-1;
function iniBgColor()
{
	var tableObj=document.getElementById('tDHCNurseBLPatList');
	var rowNum=tableObj.rows.length
	//alert(rowNum)  
	var frm =dhcsys_getmenuform() 
	var seladm=frm.EpisodeID.value
	//alert(seladm)
	for(var i=1;i<rowNum;i++)
	{
		var adm=document.getElementById('paadmz'+i).value;
		if (seladm==adm)
		{
			 tableObj.rows[i].style.backgroundColor="#CBE5FF";
			 selRow=i;
			 break;
		}        
	 }
}
function SelectRowHandler()	
{  	
 	var eSrc=window.event.srcElement;
	Objtbl=document.getElementById('tDHCNurseBLPatList');
	if (selRow>0)
	{
		Objtbl.rows[selRow].style.backgroundColor="#FFFFFF";
	}
	Rows=Objtbl.rows.length;
	var rowObj=getRow(eSrc);           //
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
    var locdesc=document.getElementById('locdesc').value;
   
    var PatientID=document.getElementById('PatientIDz'+selectrow).value;
    var adm=document.getElementById('paadmz'+selectrow).value;
    //alert(PatientID)
		var frm =dhcsys_getmenuform()   // win.document.forms['fEPRMENU'];
       
        if (frm) {
			frm.PatientID.value = PatientID;
			frm.EpisodeID.value =adm;
         
        }
    //var mradm=document.getElementById('mradmz'+selectrow).innerText;
   // var obj=document.getElementById('type');
    //var type=obj.value
    //alert(type)
   // if (type==2){
   //alert(PatientID+"@"+adm)
	 //lnk= "dhcnuremr1.csp?PatientID="+PatientID+"&EpisodeID="+adm  
	 //alert(adm) 
	 lnk= "dhcnuremrnew.csp?EpisodeID="+adm 
   // }
  
   
    // else if (type==3){
	// lnk= "websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFORDCHK&getnotpaid=0&getstatus=1&EpisodeID="+adm   
   // }
   // else{
     //lnk= "websys.default.csp?WEBSYS.TCOMPONENT=UDHCStopOrder&Lflag=1&Sflag=1&CurDataFlag=1&EpisodeID="+adm+"&lulocdes="+locdesc;
   // }
    //alert (lnk);      //&Lflag=1&Sflag=1&CurDataFlag=1&EpisodeID=#(%request.Get("EpisodeID"))#&lulocdes=#lulocdesc#">
    parent.frames['right'].location.href=lnk; 
   //	<frame name="right" src="epr.chartbook.csp?PatientID=#(%request.Get("PatientID"))#&EpisodeID=#(%request.Get("EpisodeID"))#&mradm=#(%request.Get("mradm"))#">

}
document.body.onload = BodyLoadHandler;