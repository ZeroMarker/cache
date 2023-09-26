var obj=""
var value=""	
var SelectedRow = 0,preRowInd=0;
var ancvcCodeold=0;
var RequestNo="";

var TakePackList=document.getElementById('TakePackList');
//var FindPackList=document.getElementById('Find');   
function BodyLoadHandler()
{
	var DateFrom=document.getElementById("DateFrom");
	var DateTo=document.getElementById("DateTo");
    //var today=document.getElementById("getToday").value;
    //var pastday=document.getElementById("getPastday").value;
    //if (DateFrom.value=="") {DateFrom.value=pastday;}
    //if (DateTo.value=="") {DateTo.value=today;}
	//var obj=document.getElementById('btSch')
	//if(obj) obj.onclick=btSch_click;
	if (TakePackList) TakePackList.onclick=SelectTakePack
	//if (FindPackList) FindPackList.onclick=Find;	
}
 function SelectRowHandler()
 {
    var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCBldApplicationForm');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
    //alert(selectrow);
	if (!selectrow) return;
	//var obj=document.getElementById('AppNo');
	var SelRowObj=document.getElementById('AppNoz'+selectrow);
	//var userLocId=session['LOGON.CTLOCID'];
	//alert(SelRowObj);
    //alert(SelRowObj.innerText);
	//obj.value=SelRowObj.innerText;
	/*
	    obj1.value=SelRowObj1.innerText;
		obj2.value=SelRowObj2.innerText;
		obj3.value=SelRowObj3.innerText;
		obj4.value=SelRowObj4.innerText;
	preRowInd=selectrow;
	*/
	SelectedRow=selectrow;

	//alert("AppNo="+SelRowObj.innerText);
	//根据申请单号得到取血单列表
	RequestNo=SelRowObj.innerText;
	IniTakePackList();
	//显示取血单
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCBldTakePack&AppNo="+SelRowObj.innerText;
    parent.frames[1].location.href=lnk; 
 }
 function DHCWeb_GetRowIdx(wobj)
{
	try{
		var eSrc=wobj.event.srcElement;
		if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
		return 	selectrow
	}catch (e)
	{
		alert(e.toString());
		return -1;
	}
}
//初始化取血单列表
function IniTakePackList(){
	//取血列表
	/*
	var obj=document.getElementById("TakePackList");
	obj.length=0;
	//alert("申请号："+RequestNo);
	var GetTakeList=document.getElementById('GetTakeList');
	if (GetTakeList) {var encmeth=GetTakeList.value} else {var encmeth=''};
    //
	var PackStr=cspRunServerMethod(encmeth,'','',RequestNo);
	if (PackStr=='') {return 0;}
	//alert("取血单："+PackStr);
	var PackInfo=PackStr.split("^");
	for(i=0;i<=PackInfo.length-1;i++){
		TakePack=PackInfo[i];
		obj.multiple=false;
		obj.options[i]=new Option(PackInfo[i],i);
	}
	*/
}

//选中取血单
function SelectTakePack(){
	var selOption=TakePackList.selectedIndex;
	var txtTake=TakePackList.options[selOption].text;
	var TakeInfo=txtTake.split(":");
	var TakeNumber=TakeInfo[1];
	//
	//alert("select:"+TakeNumber);
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCBldTakePack&AppNo="+RequestNo+"&TakePackNo="+TakeNumber;
    parent.frames[1].location.href=lnk;
}
function Find()
{   
  Find_click()
}
function BodyUnLoadHandler(){

}

document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;