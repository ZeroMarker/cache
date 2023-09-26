// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function getTableName(eSrc) {
	while(eSrc.tagName != "TABLE") eSrc=eSrc.parentElement;
	var tbl=document.getElementById("t"+eSrc.id.substring(1,eSrc.id.length));
	return tbl;
}
// Log 55973 - AI - 30-11-2005 : New function getFormName created for this log.
//    Called from LIST components in the EPR, where the TABLE (above) cannot be found.
function getFormName(eSrc) {
	while(eSrc.tagName != "FORM") eSrc=eSrc.parentElement;
	var frm=document.getElementById("f"+eSrc.id.substring(1,eSrc.id.length));
	return frm;
}
function changeColContent(tbl,colToChange,colToExamine,valToFind,valToBecome) {
	var row=0;
	for (var i=0;i<tbl.rows.length;i++) {
		var change=0;
		if (i==0&&tbl.rows[i].className!="") row++;
		if (tbl.rows[i].className!="") {
			var cell=document.getElementById(colToExamine+"z"+row);
			if (cell.tagName=="LABEL") {var cell=cell.innerText} else {var cell=cell.value}
			//remove blanks from cell
			if (valToFind=="NOTBLANK") {if (cell!="") change=1} else {if (valToFind==cell) change=1;}
			if (change==1) {
				var objChange = document.getElementById(colToChange+"z"+row);
				if (objChange) objChange.innerHTML=valToBecome;
			}
		}
		row++;
	}
}
function checkedCheckBoxes(f,tbl,col) {
	var aryfound=new Array;found=0;
	for (var i=1;i<tbl.rows.length;i++) {
		if (f.elements[col+i] && f.elements[col+i].checked && !f.elements[col+i].disabled) {
			aryfound[found]=i;found++;
		}
	}
	return aryfound;
}


function CheckedCheckBoxesOrSelectedRow(f,tbl,col) {
	var aryfound=new Array;found=0;
	for (var ic=1;ic<tbl.rows.length;ic++) {
		if (f.elements[col+ic] && f.elements[col+ic].checked && !f.elements[col+ic].disabled) {
			aryfound[found]=ic;found++;
		} else if (tbl.rows[ic].className=="clsRowSelected" && !f.elements[col+ic].disabled) {
			aryfound[found]=ic;found++;
		}
	}
	return aryfound;
}
//KM 13-Mar-2002: Need to pass in form as well because if you have more than one table on the page you need to identify which form the iList and tList elements are from!
function imagesShow(tbl,f) {
	//alert(tbl.id+"**"+f.id);
	var row=0; var div=""
	var divAry=document.all.tags("DIV");
	for (var j=0;j<divAry.length;j++) {
		if (divAry[j].id.substring(1,divAry[j].id.length)==tbl.id.substring(1,tbl.id.length)) var div=document.all.tags("DIV")[j];
	}
	for (var i=0;i<tbl.rows.length;i++) {
		if (i==0&&tbl.rows[i].className!="") row++;
		if (tbl.rows[i].className!="") {
			// 12-07-2002 Log 26491 AI: Check to make sure the form (f) was passed in, before checking for its id.
			//if (f.id) {
            imgAry="";
			if ((f)&&(f.id)&&(f.elements)&&(row)) {
				if ((f.elements["iLISTz"+row])&&(f.elements["iLISTz"+row].value)) imgAry=f.elements["iLISTz"+row].value.split(",");
				if ((f.elements["iLISTz"+row])&&(f.elements["iLISTz"+row].value)) ttlAry=f.elements["tLISTz"+row].value.split(",");
			} else {
				if ((document.getElementById("iLISTz"+row))&&(document.getElementById("iLISTz"+row).value))	imgAry=document.getElementById("iLISTz"+row).value.split(",");
				if ((document.getElementById("iLISTz"+row))&&(document.getElementById("iLISTz"+row).value))	ttlAry=document.getElementById("tLISTz"+row).value.split(",");
			}
			var img="&nbsp;";
			if (imgAry) {
               for (var j=0;j<imgAry.length;j++) {
				var ary=imgAry[j].split("/");var id=ary[ary.length-1].split(".");
				if (imgAry[j]!="") img=img+'<IMG SRC="../images/'+imgAry[j]+'" id="'+id[0]+'" onclick="imgClick(this.id)" title="'+ttlAry[j]+'">';
			    }
            }
			// 12-07-2002 Log 26491 AI: Check to make sure the form (f) was passed in, before checking for its id.
			//if (f.id) {
			if ((f)&&(f.id)) {
				if ((row)&&(div.all)&&(div.all.tags("LABEL"))&&(div.all.tags("LABEL")["PatientInfoz"+row])) div.all.tags("LABEL")["PatientInfoz"+row].innerHTML=img;
			} else {
				document.getElementById("PatientInfoz"+row).innerHTML=img;
			}
		}
		row++;
	}
}
function imgClick(id) {
	//If onclick events required, create function, with following name, on component js page.
	try {imgClickHandler(id);} catch(e) {}
}
