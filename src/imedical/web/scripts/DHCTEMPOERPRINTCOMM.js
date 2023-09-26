
var selrow;
var BPRNSTR;
BPRNSTR="";
var ComDep=""
var DepSelIndex=""
var tem=""
var Dep=""
var DepNo=""
var NurOrd=""
var DocOrd=""
function BodyLoadHandler()
{

  
}

function gridsettmpItfaceL(xlsSheet,r,c1,c2,frw,fontnum)
{
  fontcell(xlsSheet,r,c1,c2,fontnum);
	 xlcenter(xlsSheet,r,c1,c2);
	 xlsSheet.cells(frw,1)="日期";               //t['val:date'];
	 xlsSheet.cells(frw,2)="时间";               //t['val:time'];
	 xlsSheet.cells(frw,3)="医嘱名称";           //t['val:ordDesc'];
	 xlsSheet.cells(frw,4)="医生签名";           //t['val:docSign'];
	 xlsSheet.cells(frw,5)="执行时间";           //t['val:execDateTime'];
	 xlsSheet.cells(frw,6)="护士签名";           //t['val:nurseSign'];
}





document.body.onload = BodyLoadHandler;