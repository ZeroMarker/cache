
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
	 xlsSheet.cells(frw,1)="����";               //t['val:date'];
	 xlsSheet.cells(frw,2)="ʱ��";               //t['val:time'];
	 xlsSheet.cells(frw,3)="ҽ������";           //t['val:ordDesc'];
	 xlsSheet.cells(frw,4)="ҽ��ǩ��";           //t['val:docSign'];
	 xlsSheet.cells(frw,5)="ִ��ʱ��";           //t['val:execDateTime'];
	 xlsSheet.cells(frw,6)="��ʿǩ��";           //t['val:nurseSign'];
}





document.body.onload = BodyLoadHandler;