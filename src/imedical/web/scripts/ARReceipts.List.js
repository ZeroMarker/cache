// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 


function GetSelectedRows(f,tbl,col) {
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
