
var selectrow;
function BodyLoadHandler()
{
	SetLoc();
	SetObjHandler();
	var obj=document.getElementById("CDepDesc");	 
 	if (obj){	
		obj.onkeydown=popCDepCode;
		obj.onblur=checkCDepCode;
 	}
	
}

function SetLoc()
{
	var info=""
	var objinfo=document.getElementById("locInfo");
	if (objinfo) {var info=objinfo.value ; }
	
	
	var obj=document.getElementById("cInfo");
	if (obj){
		obj.innerText=info
	}
}

function SetObjHandler()
{
	var objsave=document.getElementById("save"); 
	if (objsave) objsave.onclick=SaveClick;
	var objdel=document.getElementById("delete"); 
	if (objdel) objdel.onclick=DeleteClick;
	
}


function SaveClick()
{
	var deptdrobj=document.getElementById("CDepCode");
	if (deptdrobj) deptdr=deptdrobj.value ;
	
	if (deptdr=="") {alert("请先录入科室");return;}
	
	var phwinobj=document.getElementById("phwid");
	if (phwinobj) phwid=phwinobj.value;
	
	var xx=document.getElementById("mSave");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,phwid,deptdr) ;
	
	if (result==0){alert("保存成功");FindRecord();}
	else {alert("保存失败")}
	
	
	
}

function DeleteClick()
{
	if (!selectrow) {alert("请先选择记录");return;}
	if (selectrow<1) {alert("请先选择记录");return;}
	
	var rowid="" ;
	var objrowid=document.getElementById("Trowidz"+selectrow);
	if (objrowid) {rowid=objrowid.value}
	
	if (confirm("确认删除吗?")==false) {return; }
	
	var xx=document.getElementById("mDelete");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,rowid) ;

	FindRecord();
	
}

function FindRecord()
{
	var phwinobj=document.getElementById("phwid");
	if (phwinobj) PhwinId=phwinobj.value;
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhLocWinConfig"+"&phwid="+PhwinId
	window.location.reload();

}

function SelectRowHandler()	
{
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	selectrow=rowObj.rowIndex;
	
		
}
function popCDepCode()
{
	if (window.event.keyCode==13) 
	{  
		if (event.preventDefault()){event.preventDefault()} //yunhaibao20160201,弹出界面的回车需屏蔽keydown事件
		window.event.keyCode=117;
		window.event.isLookup=true;		
	  	CDepDesc_lookuphandler(window.event);
	  	
	}
}
function checkCDepCode()
{
	var objlocdesc=document.getElementById("CDepDesc");
	var objloc=document.getElementById("CDepCode");
	if (objlocdesc==""){objloc.value=""}
}
function GetDropDept(value)
{
  var val=value.split("^") 
  var deptdrobj=document.getElementById("CDepCode");
  deptdrobj.value=val[1];
}

document.body.onload = BodyLoadHandler;