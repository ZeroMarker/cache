//dhcpha.table.edit.js

function DelAllRows(objtbl)
{  //Erase all the rows of table ;
	if (objtbl) var cnt=objtbl.rows.length-1;
	if (cnt==0) {return;}
	do {
		//objtbl.deleteRow(1)
		DelOneRow(objtbl,1)
		cnt=objtbl.rows.length-1;
		}while (cnt>0)
	}
function DelOneRow(objtbl,row)
{ // Erase one row ; 
	if (objtbl)
	{objtbl.deleteRow(row) ;		}
	}
	
function getRowcount(obj)
{ if (obj)
	{return  obj.rows.length-1 ;}
	return 0	
	}
function selectedRow(w)
{
	var eSrc=w.event.srcElement;
	if (eSrc){
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
    return selectrow }
}   	
function tk_ResetRowItemst(objtbl) {
	for (var i=0;i<objtbl.rows.length; i++) {
		var objrow=objtbl.rows[i];
		{if ((i+1)%2==0) {objrow.className="RowEven";} else {objrow.className="RowOdd";}}
		var rowitems=objrow.all; //IE only
		//alert(rowitems.length);
		if (!rowitems) rowitems=objrow.getElementsByTagName("*"); //N6
		for (var j=0;j<rowitems.length;j++) {
		//	alert(i+":"+j+":"+rowitems[j].id);
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
function tAddRow(objtbl) {
	tk_ResetRowItemst(objtbl);
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
	//make sure objtbl is the tbody element
	objtbl=websys_getParentElement(objlastrow);
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
	
	//
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowOdd";} else {objnewrow.className="RowEven";}}
	tk_ResetRowItemst(objtbl);
}

function DHCWeb_GetRowIdx(wobj)
{
	var eSrc=wobj.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	return 	selectrow
}

function ResetRowClass(objtbl) {
	for (var i=0;i<objtbl.rows.length; i++) {
		var objrow=objtbl.rows[i];
		if ((i+1)%2==0) {objrow.className="RowOdd";}
		else {objrow.className="RowEven";}
	}
}