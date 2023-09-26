///udhcOPHandin.Details.js

function BodyLoadHandler()
{
	InitialCAT();
}

function InitialCAT()
{
	///unescape
	var obj=document.getElementById("uName");
	if (obj){
		////alert(obj.value);
		obj.value=unescape(obj.value);
	}
	var catobj=document.getElementById("getOPCAT");
	if (catobj) {var encmeth=catobj.value} else {var encmeth=''};
	var catinfo=cspRunServerMethod(encmeth);
	var objtbl=document.getElementById('tudhcOPHandin_Details');
	var Rows=objtbl.rows.length;
	var firstRow=objtbl.rows[0];
	var RowItems=firstRow.all;
	
	var cattmp =catinfo.split("^");
	var catnum=cattmp.length;
	for (var i=1;i<=catnum;i++)
	{
		var ColName="cat"+i;
		for (var j=0;j<RowItems.length;j++) 
		{
		   if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH'))
		   {
			   RowItems[j].innerHTML=cattmp[i-1];
			}
		}
	}
	
	for (var i=catnum+1;i<=20;i++){
		HiddenTblColumn(objtbl,"cat"+i,i);
	}
	
}

function HiddenTblColumn(tbl,ColName,ColIdx){
	///
	///
	var row=tbl.rows.length;
	var firstRow=tbl.rows[0];
	var RowItems=firstRow.all;
	
	for (var j=0;j<RowItems.length;j++) {
		///alert(RowItems[j].childNodes.length);
		///if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH')) {
		if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH')) {
			RowItems[j].style.display="none";
		} else {
		}
	}

	row=row-1;
	for (var j=1;j<row+1;j++) {
		var sLable=document.getElementById("TCAT"+ColIdx+'z'+j);
		var sTD=sLable.parentElement;
		sTD.style.display="none";
	}
}

function AddTblColumn(tbl,CopeName)	{
	///
	///
	var row=tbl.rows.length;
	var firstRow=tbl.rows[0];
	var RowItems=firstRow.all;
	
	var mylen=RowItems.length;
	var lastcolobj=RowItems[mylen-1];
	
	var newcolobj=lastcolobj.cloneNode(true);

	newcolobj=firstRow.appendChild(newcolobj);
	newcolobj.id=mylen;
	newcolobj.innerHTML="Else"
	for (var j=1;j<row;j++) {
		var sLable=document.getElementById("TCAT11z"+j);
		var sTD=sLable.parentElement;
		var otRowObj=tbl.rows[j];
		var newcolobj=sTD.cloneNode(true);
		
		newcolobj=otRowObj.appendChild(newcolobj);
	}
}


document.body.onload = BodyLoadHandler;
