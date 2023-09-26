// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 22.08.06 59768
var epId=document.getElementById("EpisodeID");
var conEpId=document.getElementById("ConsultEpisodeID");
if(epId && conEpId && conEpId.value!="" && conEpId.value!=epId.value){
	var objNew=document.getElementById("compnew1");
	if(objNew){
		objNew.disabled=true;
		objNew.onclick=LinkDisable;
	}
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}


function SelectRowHandler(e) {
	var eSrc=websys_getSrcElement(e);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	//var tbl=getTableName(eSrc);
	var eSrcAry=eSrc.id.split("z");
	if (eSrcAry[0]=="DSTDesc") {
		var dslink=document.getElementById("DSLinkz"+eSrcAry[1]).value;
		var tp = 0;  //window.screen.height-window.screen.availHeight;
		var lft = 0;  //window.screen.Width-window.screen.availWidth;
		var wid = screen.availWidth-10;
		var hght = screen.availHeight-30;
		var feature='top='+tp+',left='+lft+',width='+wid+',height='+hght + ',scrollbars=yes,resizable=yes';
		websys_createWindow(dslink, 'DischargeSummary', feature );
		return false;
	}
}

function tk_DisableRowLink(tablename,linkcolumnname,criteriafield,criteriaexpr) {
	var tbl=document.getElementById(tablename);

	if (!tbl) return;
	//if no rows or the details column is not displaying, don't have to do anything
	var colDetails=document.getElementById(linkcolumnname+"z1");
	if (!colDetails) return;
	for (var i=1; i<tbl.rows.length; i++) {
		var objCriteria=document.getElementById(criteriafield+"z"+i);
		var lnkDetails=document.getElementById(linkcolumnname+"z"+i);
		if ((lnkDetails)&&(objCriteria.value==criteriaexpr)) {
			var cell=websys_getParentElement(lnkDetails);
			cell.innerHTML = lnkDetails.innerHTML;
		}
	}
}

// ab 4.01.07 60381
function PassExtRefDetails(lnk,newwin) {
		var eSrc=websys_getSrcElement();
		var tbl=getTableName(eSrc);
		var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
		var aryfound=checkedCheckBoxes(f,tbl,"SelectItemz");
		if (aryfound.length==0) {
			alert(t['NONE_SELECTED']);
			return;
		}
		var currentmradm="";
		var CONTEXT=f.elements["CONTEXT"].value;
		var ExtRefString="";
		for (var i=0;i<aryfound.length;i++) {
			var count=aryfound[i];
			var currentmradm=f.elements["mradmz"+count].value;
			var PatientID=f.elements["PatientIDz"+count].value;
			var EpisodeID=f.elements["EpisodeIDz"+count].value;

			var ExtRefID=f.elements["IDz"+count].value;
			if (ExtRefString!="") ExtRefString=ExtRefString+"^";
			ExtRefString=ExtRefString+ExtRefID
		}
		lnk+="&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+currentmradm+"&PARREF="+currentmradm+"&ExtRefString="+ExtRefString+"&CONTEXT="+CONTEXT+"&PatientBanner=1";
		//alert(lnk);

		websys_lu(lnk,0,newwin);
}

// disable link if there is no document and DS is authorised
var tbl=document.getElementById("tepr_SOAPExternalRef");
tk_DisableRowLink(tbl.id,"DSTDesc","DocDR","");
