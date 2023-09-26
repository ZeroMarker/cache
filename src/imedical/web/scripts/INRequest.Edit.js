// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var update=document.getElementById("update");
if (update) update.onclick=updateClickHandler;

function updateClickHandler() {
	var date=document.getElementById("INRQDate");
	var daypast=document.getElementById("INCFDaysPastTransaction");
	var noupdate=false;
	
	if (date && daypast && date.value!="") noupdate=(DateStringCompareToday(date.value)<0&&(DateStringDifferenceToday(date.value))["dy"]>daypast.value);
	if (noupdate) {
		alert(t["PAST_DATE"]);
		if(date.disabled==false) date.focus();
		return false;
	}

	var qty="";
	var data="";
	var rowid="";
	var uom="";
	var itemDatas=document.getElementById("itemDatas");
	var itemStr="";
	var msg="";
	
	if (tbl) {
		for (i=1; i<tbl.rows.length; i++) {
			qty=document.getElementById("INRQIReqQtyz"+i);
			data=document.getElementById("itemDataz"+i);
			rowid=document.getElementById("rowidz"+i);
			uom=document.getElementById("INRQICTUOMDRz"+i);
			
			if (qty && data && mPiece(data.value,"^",1)!="" && qty.value>0 && qty.value-mPiece(data.value,"^",1)>0) {
				msg+=mPiece(data.value,"^",0)+" ("+t['CURRQTY']+mPiece(data.value,"^",1)+")\n";
			}
			if (rowid && qty && uom)
				itemStr+=rowid.value+"*"+qty.value+"*"+mPiece(uom.value,String.fromCharCode(1),0)+"^";
		}
		
		if (msg!="") {
			var ans=confirm(t['EXCEEDQTY']+"\n"+msg+"\n"+t['CONTINUE']);
			if (!ans) return false;
		}
		
		if (itemDatas && itemStr!="")
			itemDatas.value=itemStr;
	}
	update_click();
}

