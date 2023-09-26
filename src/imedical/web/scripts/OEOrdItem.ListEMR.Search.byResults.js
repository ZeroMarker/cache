// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var f=fOEOrdItem_ListEMR_Search_byResults;

function LookUpResult(val) {
	ary=val.split("^");
	obj=f.CategorySelected;
	f.TestCode.value=ary[1];
}