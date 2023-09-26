// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var f=document.forms["fPAAdm_ListCurrentInLoc"];
var tbl=document.getElementById("tPAAdm_ListCurrentInLoc");

// Log 27778: Triage colours must show.
function BodyLoadHandler(){
	for (var j=0;j<tbl.rows.length;j++) {
		var obj=document.getElementById("CTACUDescz"+j);
		if (obj) {
			var col=f.elements["PriorityColorz"+j];
			if (col) {
				while (obj.tagName!="TD") obj=obj.parentElement;
				if (obj.tagName=="TD") {
				obj.bgColor=col.value;
				}
			}
		}
	}

	var obj=document.getElementById("SelectAll");
	if (obj) obj.onclick=SelectAllClickHandler;
	var obj=document.getElementById("Update1");
	if (obj) obj.onclick=UpdateHandler;
	if (tsc['Update1']) websys_sckeys[tsc['Update1']]=UpdateHandler;
	//
	document.onclick=RefreshPatientSelected;
	//
}
document.body.onload=BodyLoadHandler;

function EpisodeIDGetSelected(frm,rowlastclicked) {
	var arrEpisodeIDs=new Array(); arrEpisodeIDs["firstSelected"]="";
	var eSrc=websys_getSrcElement();
	var tbl=getTable(eSrc);
	var frm=getFrmFromTbl(tbl);
	var selected=0;
	var objrs=document.getElementById("multiids");
	if (objrs) objrs.value="";
	for (var row=1; row<tbl.rows.length; row++) {
		var cbx=frm.elements["Selectz"+row];
		if ((cbx) && (cbx.checked) && (!cbx.disabled)) {
			arrEpisodeIDs[selected]=frm.elements["EpisodeIDz"+row].value;
			selected++;
			if (arrEpisodeIDs["firstSelected"]=="") arrEpisodeIDs["firstSelected"]=row;
		}
	}
	if (arrEpisodeIDs.length==0) {
		if (tbl.rows[rowlastclicked].className=='clsRowSelected') {
			arrEpisodeIDs[selected]=frm.elements["EpisodeIDz"+rowlastclicked].value;
			selected++;
			if (arrEpisodeIDs["firstSelected"]=="") arrEpisodeIDs["firstSelected"]=rowlastclicked;
		}
	}
	var objrs=document.getElementById("multiids");
	objrs.value=arrEpisodeIDs.join('^');
	return arrEpisodeIDs;
}

//if row is dehighlighted, keep ids for other selected rows
function ClearOnMultipleSelection(rowObj,winf) {
	var multiIDs=""; var patID=""; var episID="";
	var arrIDs=EpisodeIDGetSelected(f,rowObj.rowIndex);
	if (arrIDs.join("^")!="") multiIDs="EpisodeID^"+arrIDs.join("^");
	if (arrIDs["firstSelected"]) {
		var firstselectedrow=arrIDs["firstSelected"];
		patID=f.elements["PatientIDz"+firstselectedrow].value;
		episID=f.elements["EpisodeIDz"+firstselectedrow].value;
		if (winf) {
			winf.SetEpisodeDetails(patID,episID,"","","","","","","","",multiIDs);
			if (winf.frames["eprmenu"]) {
				winf.frames["eprmenu"].MENU_TRELOADPAGE=winf.frames["TRAK_main"].TRELOADPAGE;
				winf.frames["eprmenu"].MENU_TRELOADID=winf.frames["TRAK_main"].TRELOADID;
			}
		}
	}

}

// checks all the 'select' checkboxes in the list
function SelectAllClickHandler(e) {
	var objSA=document.getElementById("SelectAll");
	if (objSA) {
		for (var j=0;j<tbl.rows.length;j++) {
			var obj=document.getElementById("Selectz"+j);
			if (obj) {
				if (objSA.checked==true) obj.click();
				else obj.click();
			}
		}
	}
}


// ab - is this needed any more?
function imagesShow(tbl,f) {
	var row=0; var div=""; var 	Modifiers=""; var MainMeal1=""; var MainMeal2=""; var MainMeal3="";

	var divAry=document.all.tags("DIV");
	for (var j=0;j<divAry.length;j++) {
		if (divAry[j].id.substring(1,divAry[j].id.length)==tbl.id.substring(1,tbl.id.length)) var div=document.all.tags("DIV")[j];
	}
	for (var i=0;i<tbl.rows.length;i++) {
		if (i==0&&tbl.rows[i].className!="") row++;
		if (tbl.rows[i].className!="") {
			imgAry=f.elements["dimgListz"+row].value.split("^");
			ttlAry=f.elements["ddescListz"+row].value.split("^");
			orderAry=document.getElementById("OrderNamez"+row).innerText.split(",");
			ModifiersAry=document.getElementById("Modifiersz"+row).innerText.split(",");
			MainMeal1Ary=document.getElementById("MainMeal1z"+row).innerText.split(",");
			MainMeal2Ary=document.getElementById("MainMeal2z"+row).innerText.split(",");
			MainMeal3Ary=document.getElementById("MainMeal3z"+row).innerText.split(",");
			var img="&nbsp;";
			for (var j=0;j<orderAry.length;j++) {
				if ((imgAry[j]!="")&&(orderAry[j]!="")) img=img+'<IMG SRC="../images'+imgAry[j]+'" title="'+ttlAry[j]+'">'+orderAry[j];
				else if (orderAry[j]!="") img=img+orderAry[j];
				Modifiers=Modifiers+ModifiersAry[j]+"<BR>";
				MainMeal1=MainMeal1+MainMeal1Ary[j]+"<BR>";
				MainMeal2=MainMeal2+MainMeal2Ary[j]+"<BR>";
				MainMeal3=MainMeal3+MainMeal3Ary[j]+"<BR>";
			}
			document.getElementById("OrderNamez"+row).innerHTML=img;
		}
		row++;
	}
}

function UpdateHandler(e) {
	var objrs=document.getElementById("multiids");
	var fsel=document.getElementById("EpisodeID");
	if ((objrs)&&(objrs.value=="")) {
		alert(t['SEL_PAT']);
		return false;
	}
	var str=objrs.value;
	var idx=str.indexOf('^');
	if (idx<0) {
 		fsel.value=str;
		objrs.value="";
	}
	if (idx>0) {
		fsel.value=str.substring(0,idx);
		objrs.value=str.substring(idx+1,str.length);
	}
	var TWKFLL=f.elements["TWKFLL"];
	var TWKFJL=f.elements["TWKFLJ"];
	if (TWKFJL) TWKFJL.value=TRELOADPAGE+"^"+TRELOADID;
	if ((objrs)&&(TWKFLL)) TWKFLL.value="EpisodeID"+"^"+objrs.value;
	return Update1_click(e);
}

//
function RefreshPatientSelected(evt) {
	//alert("RefreshPatientSelected");
	var eSrc = websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc = websys_getParentElement(eSrc);
	if ((eSrc.id)&&(eSrc.id.indexOf("PAADMAdmDatez")==0)) {
		//alert("RefreshPatientSelected1");
		var eSrcAry=eSrc.id.split("z");
		var row=eSrcAry[eSrcAry.length-1];
		var objID=document.getElementById("PAADMADMNoz"+row);
		if (objID) {
			//alert(objID.innerText);
			//var LEpisodeID=objID.value;
			var EpiNo=objID.innerText;
			var re = /(\s)+/g ;	//regular expr for removing all spaces
			EpiNo=EpiNo.replace(re,'');
			if (window.opener) {
				//alert("RefreshPatientSelected3");
				var obj=window.opener.document.getElementById('EpisodeNo');
				if (obj) obj.value=EpiNo;
				window.close();
			}
		}

	}
}



//
