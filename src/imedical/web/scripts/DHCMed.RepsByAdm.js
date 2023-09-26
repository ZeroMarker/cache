
var objTable = document.getElementById("tDHCMed_RepsByAdm"); 
var EpisodeID;
var PatientID;
var ct=0;
function SelectDBRowHandler()	{
		
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
	var obj=document.getElementById("rowidz" + intSelectRow);
	if (obj) {
		var RepRowId=obj.innerText;
	}
	var obj=document.getElementById("rowidinfz" + intSelectRow);
	if (obj) {
		var RepRowId=obj.innerText;
	}
	var typeCodeLk=document.getElementById("typeCodez" + intSelectRow).value;
	var lnk="dhcmed.inf.mainlayoutbytype.csp?&TypeDr="+typeCodeLk+"&Paadm="+EpisodeID+"&InfRepDr="+RepRowId+"&Papmi="+PatientID;
	//window.open(lnk, "_blank","top=10,left=10,width=950,height=680,scrollbars=no,resizable=no");
	window.showModalDialog(lnk,"","dialogTop=0;dialogWidth=960px;dialogHeight=680px;status=no");
}
var objhiddenPaadm=document.getElementById("EpisodeID");
if(objhiddenPaadm)
{
   EpisodeID=objhiddenPaadm.value;	
}
var objhiddenPapmi=document.getElementById("Papmi");
if(objhiddenPapmi)
{
   PatientID=objhiddenPapmi.value;	
}
//"&TypeDr=1&Paadm="_%request.Get("EpisodeID")_"&Papmi="_%request.Get("PatientID")
var btnNewRep=document.getElementById("NewRep");
if(btnNewRep)
{
   btnNewRep.onclick=btnNewRep_click;	
}
var btnNewICURep=document.getElementById("NewICURep");
if(btnNewICURep)
{
   btnNewICURep.onclick=btnNewICURep_click;	
}
var btnNewOperRep=document.getElementById("NewOperRep");
if(btnNewOperRep)
{
   btnNewOperRep.onclick=btnNewOperRep_click;	
}
if (objTable != null) {
	objTable.ondblclick=SelectDBRowHandler;
	//objtbl.onKeyPress=SelectRow;
	//objtbl.className='tblListSelect';
}
function btnNewRep_click()
{
      var RepRowId="";
      var lnk="dhcmed.inf.mainlayoutbytype.csp?&TypeDr=1&Paadm="+EpisodeID+"&InfRepDr="+RepRowId+"&Papmi="+PatientID;
      //showModalDialogºÍshowModelessDialog
      //window.open(lnk, "_blank","top=10,left=10,width=950,height=680,titlebar=no,toolbar=no, menubar=no, scrollbars=no,resizable=no,location=no,status=no");
      window.showModalDialog(lnk,"","dialogTop=0;dialogWidth=960px;dialogHeight=680px;status=no");
}
function btnNewICURep_click()
{
      var RepRowId="";
      var lnk="dhcmed.inf.mainlayoutbytype.csp?&TypeDr=2&Paadm="+EpisodeID+"&InfRepDr="+RepRowId+"&Papmi="+PatientID;
      //showModalDialogºÍshowModelessDialog
      //window.open(lnk, "_blank","top=10,left=10,width=950,height=680,titlebar=no,toolbar=no, menubar=no, scrollbars=no,resizable=no,location=no,status=no");
      window.showModalDialog(lnk,"","dialogTop=0;dialogWidth=960px;dialogHeight=680px;status=no");
}
function btnNewOperRep_click()
{
      var RepRowId="";
      var lnk="dhcmed.inf.mainlayoutbytype.csp?&TypeDr=5&Paadm="+EpisodeID+"&InfRepDr="+RepRowId+"&Papmi="+PatientID;
      //showModalDialogºÍshowModelessDialog
      //window.open(lnk, "_blank","top=10,left=10,width=950,height=680,titlebar=no,toolbar=no, menubar=no, scrollbars=no,resizable=no,location=no,status=no");
      window.showModalDialog(lnk,"","dialogTop=0;dialogWidth=960px;dialogHeight=680px;status=no");
}
        