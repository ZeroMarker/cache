///DHCOPInvDaily.js
var hidden="false";
function BodyLoadHandler(){ 
 Initialpaym();
 setBackground();
}
function Initialpaym()
{
	///unescape
	var catobj=websys_$("GetPayMDesc");
	if (catobj) {var encmeth=catobj.value} else {var encmeth=''};
	var payminfo=cspRunServerMethod(encmeth);
	var objtbl=document.getElementById("tDHCOPInvDaily");
	var Rows=objtbl.rows.length;
	var firstRow=objtbl.rows[0];
	//var RowItems=firstRow.all;
	if(!!window.ActiveXObject){
		var RowItems=firstRow.all;	// IE8及以下支持
	}else{
		var RowItems=firstRow.cells;		// IE11支持
	}
	var paymtmp =payminfo.split("^");
	var paymnum=paymtmp.length;
	for (var i=1;i<=paymnum-1;i++)
	{
		var ColName="TPaym"+i;
		for (var j=0;j<RowItems.length;j++) 
		{
			var RowStr=RowItems[j].innerHTML;
		var RowStr=RowStr.replace('\n','')	// 去除换行符
		var RowStr=RowStr.replace(/[ ]/g,"");	// 去除空格
			if ((RowStr==ColName)&(RowItems[j].tagName=='TH'))
			{
				//RowItems[j].innerHTML=paymtmp[i];
				RowItems[j].innerText=paymtmp[i];
			}
		}
	}
	
	for (var i=paymnum;i<=16;i++){
		HiddenTblColumn(objtbl,"TPaym"+i,i);
	}
}

function HiddenTblColumn(tbl,ColName,ColIdx){
	///
	///
	var row=tbl.rows.length;
	var firstRow=tbl.rows[0];
	//var RowItems=firstRow.all;
	if(!!window.ActiveXObject){
		var RowItems=firstRow.all;	// IE8及以下支持
	}else{
		var RowItems=firstRow.cells;		// IE11支持
	}
	
	for (var j=0;j<RowItems.length;j++) {
		///alert(RowItems[j].childNodes.length);
		///if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH')) {
		var RowStr=RowItems[j].innerHTML;
		var RowStr=RowStr.replace('\n','')	// 去除换行符
		var RowStr=RowStr.replace(/[ ]/g,"");	// 去除空格
		//if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH')) {
		if ((RowStr==ColName)&(RowItems[j].tagName=='TH')) {
			RowItems[j].style.display="none";
		} else {
		}
	}
	row=row-1;
	for (var j=1;j<row+1;j++) {
		var sLable=document.getElementById("TPaym"+ColIdx+'z'+j);
		var sTD=sLable.parentElement;
		sTD.style.display="none";
	}
}
function setBackground()
{
	var myRows = DHCWeb_GetTBRows("tDHCOPInvDaily");
	for (var i = 1; i < myRows + 1; i++) {
		var obj=document.getElementById('TPrtStatusz'+i);
		if (obj)
		{
			var TRobj=obj.parentElement;
			var TPrtStatus=obj.innerText;
		switch (TPrtStatus)  
	    {  
		   
		   case "红冲":TRobj.className="Blue";break;
		   case "作废":TRobj.className="Yellow";break;
		   case "预结算":TRobj.className="Red";break;
		   default:
	    }
		}
	}
}
document.body.onload = BodyLoadHandler;