function InitForm()
{
   var objTable = document.getElementById("tDHC_WMR_CurrVol_List"); 
    for(var i = 1; i < objTable.rows.length; i ++)
    {
    		var obj=document.getElementById("chkItemz" + i);
    		if (obj)  {obj.checked =  true;}
    		var obj=document.getElementById("SelectAll");
    		if (obj)  {obj.checked =  true;}
    }   

}
function InitEvents()
{
	var obj=document.getElementById("SelectAll");
	if(obj) obj.onclick=SelectAllOnChange;
}
function SelectAllOnChange()
{
	var obj=document.getElementById("SelectAll");
	var objTable = document.getElementById("tDHC_WMR_CurrVol_List"); 
	if (obj.checked==true){
    for(var i = 1; i < objTable.rows.length; i ++)
    {
    		var obj=document.getElementById("chkItemz" + i);
    		if (obj)  {obj.checked =  true;}
    }  	
	}else{
		for(var i = 1; i < objTable.rows.length; i ++)
    {
    		var obj=document.getElementById("chkItemz" + i);
    		if (obj)  {obj.checked =  false;}
    } 
	}
}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) 
	{
		intSelectRow = -1;
	}
	else
	{
		intSelectRow = selectrow;
	} 
	var paadm="",patientId="";
	var obj=document.getElementById("VolumePaadmz"+intSelectRow);
	if (obj){
		paadm=obj.value;	
	}
	var obj=document.getElementById("PatientIdz"+intSelectRow);
	if (obj){patientId=obj.value}
	var frm=parent.parent.parent.document.forms['fEPRMENU'];
	//var frm =dhcsys_getmenuform();
	//alert(frm);
	var frmEpisodeID=frm.EpisodeID;
	var frmPatientID=frm.PatientID;
	var frmmradm=frm.mradm;
	frmEpisodeID.value=paadm;
	
}

InitForm();
InitEvents();
