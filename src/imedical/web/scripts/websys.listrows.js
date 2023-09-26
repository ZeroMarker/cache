// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
//*************************
//general functions for manipulating table rows
//
//tk_EnableRowLink : sets a particular column to display a link or just text pending on some criteria
//tk_ShiftItem : shifts a row either up or down
//tk_ResetRowItems : resets the z counter for each row in the table
//MoveRow : shifts a row up or down a table, and resets row zcounters. ie IDz1 will become IDz2 and vice versa
//DeletRow : deletes a row, and resets row zcounters
//AddRow : adds an empty row to the end of the table that matches fields in previous rows
//
//DebugRow : for debugging purposes for after calling tk_ResetRowItems
//*************************

//obj = object within the row
function tk_getRow(obj) {
	var objrow=obj;
	while(objrow.tagName != "TR") {objrow=websys_getParentElement(objrow);}
	return objrow
}
//obj= row object
function tk_getTBody(obj) {
	var objtbody=websys_getParentElement(obj);
	return objtbody
}

function tk_EnableRowLink(tablename,linkcolumnname,criteriafield,criteriadelim,criteriaexpr) {
	var tbl=document.getElementById(tablename);
	if (!tbl) return;
	//if no rows or the details column is not dispalying, don't have to do anything
	var colDetails=document.getElementById(linkcolumnname+"z1");
	if (!colDetails) return;
	for (var i=1; i<tbl.rows.length; i++) {
		var arrCriteria=document.getElementById(criteriafield+"z"+i).value.split(criteriadelim);
		var lnkDetails=document.getElementById(linkcolumnname+"z"+i);
		if (arrCriteria[0]==criteriaexpr) {
			lnkDetails.innerHTML = arrCriteria[1];
		} else {
			var cell=websys_getParentElement(lnkDetails);
			cell.innerHTML = arrCriteria[1];
		}
	}
}
function tk_DisableRowLink(tablename,linkcolumnname,criteriafield,criteriaexpr) {
	var tbl=document.getElementById(tablename);
	if (!tbl) return;
	//if no rows or the details column is not dispalying, don't have to do anything
	var colDetails=document.getElementById(linkcolumnname+"z1");
	if (!colDetails) return;
	for (var i=1; i<tbl.rows.length; i++) {
		var objCriteria=document.getElementById(criteriafield+"z"+i);
		var lnkDetails=document.getElementById(linkcolumnname+"z"+i);
		if (objCriteria.value==criteriaexpr) {
			var cell=websys_getParentElement(lnkDetails);
			cell.innerHTML = lnkDetails.innerHTML;
		}
	}
}

//obj=the button clicked, not the row
function MoveRow(obj,dirn) {
	var objrow=tk_getRow(obj);
	if (objrow) {
		tk_ShiftItem(objrow,dirn);
		var objtbody=tk_getTBody(objrow);
		tk_ResetRowItems(objtbody);
		//DebugRow(objtbody);
	}
}
//obj=the button clicked, not the row
//checkonlyrow= flag to disallow row to be deleted... used to stop deletion when only one row exists
function DeleteRow(obj,checkonlyrow) {
	var objrow=tk_getRow(obj);
	if (objrow) {
		var objtbody=tk_getTBody(objrow);
		if ((checkonlyrow)&&(objtbody.rows.length==1)) return;
		objtbody.deleteRow(objrow.sectionRowIndex);
		tk_ResetRowItems(objtbody);
		//DebugRow(objtbody);
	}
}

function AddRow(objtbl) {
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
	//make sure objtbl is the tbody element
	objtbl=tk_getTBody(objlastrow);
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]=row;
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			rowitems[j].value="";
		}
	}
	objnewrow=objtbl.appendChild(objnewrow);
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowEven";} else {objnewrow.className="RowOdd";}}
}

function tk_ResetRowItems(objtbl) {
	for (var i=0;i<objtbl.rows.length; i++) {
		var objrow=objtbl.rows[i];
		{if ((i+1)%2==0) {objrow.className="RowEven";} else {objrow.className="RowOdd";}}
		var rowitems=objrow.all; //IE only
		if (!rowitems) rowitems=objrow.getElementsByTagName("*"); //N6
		for (var j=0;j<rowitems.length;j++) {
			//alert(i+":"+j+":"+rowitems[j].id);
			if (rowitems[j].id) {
				var arrId=rowitems[j].id.split("z");
				//if (arrId[arrId.length-1]==i+1) break; //break out of j loop
				arrId[arrId.length-1]=i+1;
				rowitems[j].id=arrId.join("z");
				rowitems[j].name=arrId.join("z");
			}
		}
	}
}

//obj=reference to the item to shift
//dirn=direction to shift, "U"(=up) else defaults to "D"(=down)
function tk_ShiftItem(obj,dirn) {
	var objpar=websys_getParentElement(obj);
	var maxnum=objpar.childNodes.length;
	var objto=obj;
	var objnew=document.createElement(obj.tagName);
	if (dirn=="U") {
		objto=objto.previousSibling;
		objnew=objpar.insertBefore(objnew,objto);
		objpar.replaceChild(obj,objnew);
	} else {
		objto=objto.nextSibling;
		if (objto==objpar.lastChild) {
			objnew=objpar.appendChild(objnew);
		} else if ((objto)&&(objto!=objpar.lastChild)) {
			objnew=objpar.insertBefore(objnew,objto.nextSibling);
		} else {
			objnew=objpar.insertBefore(objnew,objpar.firstChild);
		}
		objpar.replaceChild(obj,objnew);
	}
}


//debugging only...
function DebugRow(objtbl) {
	var tbl=document.getElementById("tMRProcedures_EditDRG");
	if (objtbl) tbl=objtbl;
	if (tbl) {
		/***alert("PROC table rows count="+tbl.rows.length);
		for (var i=1; i<tbl.rows.length; i++) {
			//alert("row "+i);
			var el=document.getElementById("PROCOperationDRDescz"+i);
			//if (el) alert("PROCOperationDRDescz"+i+" has id="+el.id+" and val="+el.value);
			var el=document.getElementById("OPERMechVentilCodez"+i);
			//if (el) alert(el.id+"="+el.value);
		}***/

		var arrInput=tbl.getElementsByTagName("INPUT");
		//alert("PROC table fields count="+arrInput.length);
		var skiprow=0; var currrow=0;
		for (var i=0; i<arrInput.length; i++) {
			//alert(arrInput[i].id+":"+arrInput[i].name+":"+arrInput[i].value);
			var arrId=arrInput[i].id.split('z');
			if (arrId[arrId.length-1]!=currrow) {
				if (arrInput[i].value=="") {skiprow=1;} else {skiprow=0;}
				currrow=arrId[arrId.length-1];
			}
			if (!skiprow) {
				//do what you need to do
				//alert("arrId[0]="+arrId[0]);
				//alert("ADD HIDDEN FIELD:"+arrInput[i].id+":"+arrInput[i].value);
			}
		}
	}
}