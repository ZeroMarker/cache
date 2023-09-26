var gLocid=""
var gDocid
var str1
var str2
var str3
var tem

function BodyLoadHandler() {	
	//alert("0");
	var obj=document.getElementById("sUpdate");
	//if (obj){ obj.onclick=Updat_click;}
	if (obj)
	{
		obj.onclick=Update_click;
	}
	/*
	var Findobj=document.getElementById("sFind");
	if (Findobj)
	{
		Findobj.onclick=Find_click;
	}
	//*/
	ini();
 }
 
 function ini(){
	
	var obj=document.getElementById("SRight");
	if (obj){		
	  //alert("4")
	  obj.size=1; 
	  obj.multiple=false;
	  obj.options[0]=new Option(t['rr1'],"1");
	  obj.options[1]=new Option(t['rr2'],"2");
	  obj.options[2]=new Option(t['rr3'],"3");
	  obj.options[3]=new Option(t['rr4'],"4");
	  obj.options[4]=new Option(t['rr5'],"5");
		}
	//alert("3");
	}
	
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCRisRightSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	//var obj=document.getElementById('Mon');
	//var obj1=document.getElementById('RegNo');
	var DocID=document.getElementById('tIDZ'+selectrow);
	var DocRight=document.getElementById('tRightZ'+selectrow);
	var LocID=document.getElementById('tLocIDZ'+selectrow);
	
	var DocNameObj=document.getElementById("sDocID");
	var DocRightObj=document.getElementById("sDocRight");
	var LocIDObj=document.getElementById("sLocID");
	
	DocNameObj.value=DocID.innerText;
	DocRightObj.value=DocRight.innerText;
	LocIDObj.value=LocID.innerText;
	
	//var SelRowObj1=document.getElementById('TabRegnoz'+selectrow);
	//obj.value=SelRowObj.innerText;
	//obj1.value=SelRowObj1.innerText;
	alert(SelRowObj.innerText);
	//SelectedRow = selectrow;
}



function GetLocId(value){
	var s=value;
	var Temp=s.split("^")
	sss=Temp[1];

	var obj=document.getElementById("LocID");
	if (obj){
		if (Temp[1]!="") {
			obj.value=Temp[1];
			gLocid=Temp[1];
			}
			}

	}



function Update_click()
{

	//alert("WYK");
	
	//return;
	//
	//var LocIDobj=document.getElementById("LocID");
	//var LocID=LocIDobj.value;
	//alert(LocID);	
	//return;
	
	var DocNameObj=document.getElementById("sDocID");
	var DocRightObj=document.getElementById("sDocRight");
	var RightObj=document.getElementById("SRight");
	
	var LocIDobj=document.getElementById("LocID");
	var LocID=LocIDobj.value;
	
	if (DocNameObj.text=="")
	{
		//alert("请选择相关医生");
		return;
	}

	var info=DocNameObj.value+"^"+RightObj.value+"^"+LocIDobj.value+"^"+DocRightObj.value;
	
	var InsertInfo=document.getElementById("addfunction").value;
	var Acessioninfo=cspRunServerMethod(InsertInfo,info);
	
	//alert(info);
	
	//var Locobj=document.getElementById("SLoc");
	//var Loc=Locobj.value;
	
	//alert("websys.default.csp?WEBSYS.TCOMPONENT=DHCRisRightSet&LocID="+LocID+"&SLoc="+Loc);
	//location.reload();
	//location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisRightSet&LocID="+LocID+"&SLoc="+Loc;
	
	location.reload();
	
	//return;
	
	/*
	var obj=document.getElementById("sFind");
	if (obj)
	{
		obj.onclick();
	}
	*/
	
	
}

function Find_click()
{

	
	var LocIDobj=document.getElementById("LocID");
	var LocID=LocIDobj.value;
	
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisRightSet&mmLocID="+LocID;
	
}

document.body.onload = BodyLoadHandler;