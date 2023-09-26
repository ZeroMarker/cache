// DHCST.MBCPARASTATE
function BodyLoadHandler()
{
	//SetRowDisabled();
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=UpdMSState;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=Add;
	/// var objtbl=document.getElementById("t"+"DHCST_MBCPARASTATE");
    /// if (objtbl) cnt=getRowcount(objtbl);
}

function Add()
{
	var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.MBCPARASTATEADD"
	window.open(link,"_TARGET","height=200,width=600,menubar=no,status=yes,toolbar=no")
}
function UpdMSState()
{
	var row=0;
	var cnt=0
	var tbl=document.getElementById("t"+"DHCST_MBCPARASTATE") ;	
	if (tbl) cnt=getRowcount(tbl);
	else return ;
	if (cnt<1) return ;
	var msnumflag=0 ;
	for (var i=0;i<tbl.rows.length;i++)
	{
		if (i==0&&tbl.rows[i].className!="") row++;
		if (tbl.rows[i].className!="")
		{
			var arcicdr="";
			var cell=document.getElementById("TMSDrz"+row);
			if (cell) msdr=cell.value;
			if (msdr!="")
			{
				var flag=false;
				var cell=document.getElementById("TMSFlagz"+row);
				if (cell) flag=cell.checked;
				if (flag==true) flag="Y";
				else flag="N";
				var result=cspRunUpdMS(msdr,flag);
				if (result!=0)
				{
					alert(t['UpdERR']+row+"^"+result);
				 	return ;
				}
				
				
				
			}
		}
		row++;
	}
	
	
	alert(t['UpdOK']);
	self.location.reload();
}
function cspRunUpdMS(msdr,flag)
{
	var obj=document.getElementById("mUpdPsFlag");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,msdr,flag);
	return result;
}

function SetRowDisabled()
{
	var row=0;
	var cnt=0
	var tbl=document.getElementById("t"+"DHCST_MBCPARASTATE") ;	
	if (tbl) cnt=getRowcount(tbl);
	else return ;
	if (cnt<1) return ;
	for (var i=0;i<tbl.rows.length;i++)
	{
		if (i==0&&tbl.rows[i].className!="") row++;
		if (tbl.rows[i].className!="")
		{
			var flag=false;
			var cell=document.getElementById("TMSSysFlagz"+row);
			if (cell) flag=cell.checked;
			if ((flag==false))
			{
				var cell=document.getElementById("TMSFlagz"+row);
				if (cell) cell.disabled=false;
			}
			
			var number="";
			var objnum=document.getElementById("TMSNumberz"+row);
			if (objnum) {number=objnum.innerText ; }
			
			if ((number==10)||(number==60))
			{
				var objdisp=document.getElementById("TMSDispFlagz"+row);
			    if (objdisp) objdisp.disabled=false;
				
			}
			
			if (number==40)
			{
				var objsin=document.getElementById("TMSSinFlagz"+row);
			    if (objsin) objsin.disabled=false;
				
			}

			//if ((flag==true))
			//{
			//	var cell=document.getElementById("TMSFlagz"+row);
			//	if (cell) cell.disabled=true;
			//}
		}
		row++;
	}
}
document.body.onload=BodyLoadHandler;
