// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var chkcnt=0
var tbl=document.getElementById("tRBApptSchedule_Tree")

function DocumentLoadHandler() {
	for (var i=1; i<tbl.rows.length; i++) {
		var obj=document.getElementById("SessSelz"+i);
		if (obj) {
			obj.onclick=updcnt;
			if (obj.checked==true) chkcnt++
		}
	}
	var swap=document.getElementById("SchedSwap");
	if (swap) {
		swap.onclick=swapClickHandler;
		if (chkcnt>1) {
			swap.disabled=false;
		} else {
			swap.disabled=true;
		}
	}
	for (var i=1; i<tbl.rows.length; i++) {
		var obj=document.getElementById("SessSelz"+i);
		if (chkcnt>1) {
			if ((obj)&&(obj.checked==false)) obj.disabled=true;
		} else {
			if ((obj)&&(obj.checked==false)) obj.disabled=false;
		}
	}
}

function updcnt(e) {
	var obj=websys_getSrcElement(e);
	var rowid=obj.id
	var rowAry=rowid.split("z");

	var obj=document.getElementById("SessSelz"+rowAry[1]);
	if ((obj)&&(obj.checked==true)) chkcnt++
	if ((obj)&&(obj.checked==false)) chkcnt--

	for (var i=1; i<tbl.rows.length; i++) {
		var obj=document.getElementById("SessSelz"+i);
		var lnk=document.getElementById("SchedSwap");
		if (chkcnt>1) {
			if ((obj)&&(obj.checked==false)) obj.disabled=true;
			if (lnk) lnk.disabled=false;
		} else {
			if ((obj)&&(obj.checked==false)) obj.disabled=false;
			if (lnk) lnk.disabled=true;
		}
	}
}

function swapClickHandler() {
	var lnk=document.getElementById("SchedSwap");
	if ((lnk)&&(lnk.disabled==true)) return false;
	var schedID1=document.getElementById("SchedID1");
	var schedID2=document.getElementById("SchedID2");
	schedID1.value=""; schedID2.value="";
	for (var i=1; i<tbl.rows.length; i++) {
		var chk=document.getElementById("SessSelz"+i);
		if ((chk)&&(chk.checked==true)) {
			var dt=document.getElementById("ASDatez"+i);
			var stm=document.getElementById("ASSessStartTimez"+i);
			var etm=document.getElementById("ASSessEndTimez"+i);
			var asid=document.getElementById("ASIDz"+i);
			if (dt&&stm&&etm&&asid) {
				if (DateStringCompareToday(dt.innerHTML)<0) {
					alert(t['cantSwap'])
					return false;
				} else if (DateStringCompareToday(dt.innerHTML)==0) {
					var now=new Date()
					var arrStm = TimeStringToArray(stm.innerHTML);
					var arrEtm = TimeStringToArray(etm.innerHTML);
					if ((arrStm["hr"]<now.getHours())&&(arrEtm["hr"]>now.getHours())) {
						alert(t['cantSwap'])
						return false;
					} else if (arrEtm["hr"]<now.getHours()) {
						alert(t['cantSwap'])
						return false;
					} else if ((arrStm["hr"]==now.getHours())||(arrEtm["hr"]==now.getHours())) {
						if ((arrStm["hr"]==now.getHours())&&(arrStm["mn"]<now.getMinutes())) {
							alert(t['cantSwap'])
							return false;
						} else if ((arrEtm["hr"]==now.getHours())&&(arrEtm["mn"]>now.getMinutes())) {
							alert(t['cantSwap'])
							return false;
						}
					}
				}
				if (schedID1.value=="") {schedID1.value=asid.value} else {schedID2.value=asid.value}
			}
		}
	}
	//var dywtc=confirm(t['sureSwap'])
	//if (dywtc==false) return false;
	return SchedSwap_click();
}

document.body.onload=DocumentLoadHandler;