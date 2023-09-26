//DHCPEEDKeyReplace.JS 关键字维护
var SelectedRow=0
function Init()
{
	var obj;
	
	obj=document.getElementById("Update");
	if (obj) obj.onclick=Update_Click;
	
	obj=document.getElementById("Delete");
	if (obj) obj.onclick=Delete_Click;
	
	Muilt_LookUp('Station'+'^'+'Detail');

}
//增加
function Update_Click()
{	
	Update(0);
}
//删除
function Delete_Click()
{	
	Update(1);
}

function Update(Type)
{
	var obj;
	var DetailID="",EDID="",Code="",InString="",encmeth="";
	obj=document.getElementById("EDID");
	if (obj) EDID=obj.value;
	obj=document.getElementById("Code");
	if (obj) Code=obj.value;
	if (Code==""){ alert(t['CodeRequired'])}
  	obj=document.getElementById("DetailID");
	if (obj) DetailID=obj.value;
	if (DetailID==""){ alert(t['DetailRequired'])}
	InString=EDID+"^"+Code+"^"+DetailID;
	
	obj=document.getElementById("UpdateBox");
	if (obj) encmeth=obj.value;
	var flag=cspRunServerMethod(encmeth,InString,Type)
	if (flag==0)
	{
		location.reload();
		return;
	}
	alert(t[flag]);
}

// **************************************************************

function SelectRowHandler(){  
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCPEEDKeyReplace');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	var obj;
    var SelRowObj;
 
    
	SelRowObj=document.getElementById('TCode'+'z'+selectrow);
	obj=document.getElementById("Code");
	if (SelRowObj && obj) { obj.value=SelRowObj.innerText; }

		
	SelRowObj=document.getElementById('TEDRowID'+'z'+selectrow);
	obj=document.getElementById("DetailID");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }
	
	SelRowObj=document.getElementById('TDetail'+'z'+selectrow);
	obj=document.getElementById("Detail");
	if (SelRowObj && obj) { obj.value=SelRowObj.innerText; }
	
	SelRowObj=document.getElementById('TStationName'+'z'+selectrow);
	obj=document.getElementById("Station");
	if (SelRowObj && obj) { obj.value=SelRowObj.innerText; }
	
	SelRowObj=document.getElementById('TStationID'+'z'+selectrow);
	obj=document.getElementById("StationID");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }

}

function SetStationID(value)
{
	if (value=="") return false;
	var DataArry=value.split("^");
	var obj=document.getElementById("StationID");
	if (obj) obj.value=DataArry[1];
}

function GetDetailID(value)
{   
	if (value=="") return false;
	var DataArry=value.split("^");
	var obj=document.getElementById("DetailID");
	if (obj) obj.value=DataArry[3];
	var obj=document.getElementById("Detail");
	if (obj) obj.value=DataArry[1];
}

document.body.onload = Init;// BodyLoadHandler;