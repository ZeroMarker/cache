function BodyLoadHandler()
{
	var objtbl=document.getElementById('tDHCNurOPExecAttach');
    for (i=1;i<objtbl.rows.length;i++)
	{
	    var eSrc=objtbl.rows[i];
	   	var RowObj=getRow(eSrc);
	   	var item=document.getElementById("disposeStatCodez"+i);
	    if (item.innerText.length>3) RowObj.className=item.innerText;
	}
}
document.body.onload = BodyLoadHandler;