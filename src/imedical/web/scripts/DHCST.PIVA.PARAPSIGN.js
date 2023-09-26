//DHCST.PIVA.PARAPSIGN
function BodyLoadHandler()
{
	var obj=document.getElementById("bNewRow");
	if (obj) obj.onclick=NewRow;
	websys_sckeys['N']=NewRow;	//zhouyg 20151013 
	//var obj=document.getElementById("tEditRow");
	//if (obj) obj.onclick=EditRow;	
}

//*function SelectRowHandler()
// {
//	var row=selectedRow(window);
//	var obj=document.getElementById("tCurRow") ;
//	if (obj) obj.value=row;
	//alert("AA")
//}
//

function NewRow()
{
	var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.PARAPSIGNADD"
	window.open(link,"_TARGET","height=500,width=750,menubar=no,status=yes,toolbar=no")
}

function EditRow()
{
	var row;
	var pps;
	var obj=document.getElementById("tCurRow");
	if (obj) row=obj.value ;
	if (row>0){
		var obj=document.getElementById("TPSSDr"+"z"+row);
		if (obj) pps=obj.value;
		if (pps!=""){
			var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCST.PIVA.PARAPSIGNADD&tPpsDr="+pps;
			window.open(link,"_TARGET","height=150,width=750,menubar=no,status=yes,toolbar=no");
		}
	}
	
	
}

function SaveSign()
{
	alert("ÐÞ¸ÄÖÐ");
	return;
	var row=0;
	var cnt=0
	var tbl=document.getElementById("t"+"DHCST_PIVA_PARAPSIGN") ;	
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
				var flag="";
				var cell=document.getElementById("TPrintSignz"+row);
				if (cell) flag=cell.value;
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
	var obj=document.getElementById("mSaveSign");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,arcicdr,flag);
	if (result>=0) return true;
	return false;
}
document.body.onload=BodyLoadHandler