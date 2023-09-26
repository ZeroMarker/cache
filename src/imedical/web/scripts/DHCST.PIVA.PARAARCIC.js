// DHCST.PIVA.PARAARCIC
function BodyLoadHandler()
{
	var obj=document.getElementById("BSave");
	if (obj) obj.onclick=SaveArcic;	
}
function SaveArcic()
{
	var row=0;
	var cnt=0
	var tbl=document.getElementById("t"+"DHCST_PIVA_PARAARCIC") ;	
	if (tbl) cnt=getRowcount(tbl);
	else return ;
	if (cnt<1) return ;
	for (var i=0;i<tbl.rows.length;i++)
	{
		if (i==0&&tbl.rows[i].className!="") row++;
		if (tbl.rows[i].className!="")
		{
			var arcicdr="";
			var cell=document.getElementById("TArcicDrz"+row);
			if (cell) arcicdr=cell.value;
			if (arcicdr!="")
			{
				var flag=false;
				var cell=document.getElementById("TArcicFlagz"+row);
				if (cell) flag=cell.checked;
				if (cspRunSave(arcicdr,flag)==false)
				{
					alert(t['SaveERR']+row);
				 	return ;
				}
			}
		}
		row++;
	}
	alert(t['SaveOK']);
	self.location.reload();
}
function cspRunSave(arcicdr,flag)
{
	var obj=document.getElementById("mSaveArcic");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,arcicdr,flag);
	if (result>=0) return true;
	return false;
}
document.body.onload=BodyLoadHandler
