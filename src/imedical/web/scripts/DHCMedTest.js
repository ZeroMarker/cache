var selectrow
var rows
function BodyLoadHandler() {
	iniForm();
    var obj=document.getElementById("testClass");
	if (obj){ obj.onclick=Test_click;}
    var obj=document.getElementById("TestKey");
	if (obj){ obj.onkeydown=Key_Down;}
    var obj=document.getElementById("CtLoc");
	if (obj){		
	  obj.size=1; 
	  obj.multiple=false;
	  obj.onclick=CtLoc_click;
		}
    var obj=document.getElementById("tDHCMedTest");
	///if (obj){ obj.onclick=Table_click;}
	///ini_ListBox()
	}
function iniForm() {
	s=gGetObjValue("EpdaRowid");
	}
function Key_Down(){
	alert(event.keyCode);
	}
function CtLoc_click(){
	//alert(gGetListData("CtLoc"));
	}
function Table_click(){
	SelectRowHandler()
	alert(selectrow);
	}
	
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCMedTest');
	///var rows=objtbl.rows.length;
	rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	//var selectrow=rowObj.rowIndex;
    selectrow=rowObj.rowIndex; 
    //alert(selectrow+"/"+rows)
    
	if (!selectrow) return;
	//alert("iSeldRow="+iSeldRow+"   selectrow="+selectrow);
	//if (iSeldRow==selectrow){

	//	return;
	//	}
	//iSeldRow=selectrow;
	var SelRowObj
	var obj
	
	//SelRowObj=document.getElementById('MEARowidz'+selectrow);
	//if (SelRowObj){alert(SelRowObj.value)}
	
}	
function Test_click(){
	
	var xobj=new clsStudent("Pipen");
	xobj.Birthday="";
	xobj.body.size=203;
	xobj.body.weight=105;
	alert(xobj.Name+" "+xobj.body.size+" "+xobj.body.weight);
	}

function ini_ListBox(){
	///SelectRowHandler()
	obj=document.getElementById('TestLinkz1');
	  alert("333333")	;
	if (obj){	
	  alert("true")	;
	  obj.size=1; 
	  obj.multiple=false;
		}
	
	}


document.body.onload = BodyLoadHandler;