//Adm=document.getElementById("Adm").value;
//var selrow;//=document.getElementById("selrow");

function BodyLoadHandler()
{

 }

function gridsetItface(xlsSheet,r,c1,c2,frw,fontnum)
{
     nfontcell(xlsSheet,r,r+1,c1,c2,fontnum);
	   nxlcenter(xlsSheet,r,r+1,c1,c2);
     nmergcell(xlsSheet,r,r,1,4);
     //nmergcell(xlsSheet,r,r+1,4,4);
     nmergcell(xlsSheet,r,r+1,5,5);
     //nmergcell(xlsSheet,r,r+1,3,3);
     nmergcell(xlsSheet,r,r,6,9);
     //nmergcell(xlsSheet,r,r+1,8,8);
     //nmergcell(xlsSheet,r,r+1,9,9);
	   xlsSheet.cells(frw,1)="起 始";         //t['val:startEnd'];
	   xlsSheet.cells(frw+1,1)="日期";        //t['val:date'];
	   xlsSheet.cells(frw+1,2)="时间";        //t['val:time'];
	   xlsSheet.cells(frw+1,3)="医生签名";    //t['val:docSign']; //longtimeord; ypz ah 060824
	   xlsSheet.cells(frw+1,4)="护士签名";     //"t['val:nurseSign']; //doc sign;
	   xlsSheet.cells(frw,5)="长 期 医 嘱";    //t['val:longTimeOrd']; //nurse sign; ypz ah 060824
	   xlsSheet.cells(frw,6)="停  止";         //t['val:disch'];
	   xlsSheet.cells(frw+1,6)="日期";        //t['val:date'];
	   xlsSheet.cells(frw+1,7)="时间";        //t['val:time'];
	   xlsSheet.cells(frw+1,8)="医生签名";    //t['val:docSign'];
	   xlsSheet.cells(frw+1,9)="护士签名";    //t['val:nurseSign'];
} 

document.body.onload = BodyLoadHandler;