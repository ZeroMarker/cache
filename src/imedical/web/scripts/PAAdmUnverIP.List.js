// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var tbl=document.getElementById('tPAAdmUnverIP_List')
function BodyLoadHandler()
{
 //alert("start");
 var numRows=tbl.rows.length;
 var admdep,selectfield

   for (i=1;i<numRows;i++)
  {
   admdept=document.getElementById("EMEpisodeIDz"+i);
   selectfield=document.getElementById("Verifyz"+i);
   vefifyfield=document.getElementById("Verifiedz"+i);
   diagnos=document.getElementById("Diagnosz"+i);
   disstatus=document.getElementById("Disstatusz"+i);
   emestring=document.getElementById("EMstingz"+i);
   disdate=document.getElementById("Disdatez"+i);
   distime=document.getElementById("Distimez"+i);
   //emepisodeid=document.getElementById("EMEpisodeIDz"+i);							
   if (emestring)
	{
	var dataary=(emestring.value).split("^");
	if (dataary[0]!=0) 
		{
		//if (emepisodeid) {emepisodeid.innerText=dataary[0];}
		if (disdate) {disdate.innerText=dataary[1];}
		if (distime) {distime.innerText=dataary[2];}
		if (diagnos) {diagnos.innerText=dataary[3];}
		if (disstatus) {disstatus.innerText=dataary[4];}
		if (vefifyfield) {vefifyfield.value=dataary[5];}
		if ((vefifyfield)&&(vefifyfield.value=="Y")) 
			{
			tbl.rows[i].className="clsRowPre";
			}
		}
        if ((dataary[0]=="0"))
   		{
	        if (selectfield)
			{
			selectfield.disabled=true;
			selectfield.onclick=LinkDisable;
			}
	        }
         }
  }
}


function LinkDisable(evt) {
	//alert("diasble")
	return false;
	}

document.body.onload=BodyLoadHandler;
