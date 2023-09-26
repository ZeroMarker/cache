
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
	
	if (deptdr=="") {alert("����¼�����");return;}
	
	var phwinobj=document.getElementById("phwid");
	if (phwinobj) phwid=phwinobj.value;
	
	var xx=document.getElementById("mSave");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,phwid,deptdr) ;
	
	if (result==0){alert("����ɹ�");FindRecord();}
	else {alert("����ʧ��")}
	
	
	
}

function DeleteClick()
{
	if (!selectrow) {alert("����ѡ���¼");return;}
	if (selectrow<1) {alert("����ѡ���¼");return;}
	
	var rowid="" ;
	var objrowid=document.getElementById("Trowidz"+selectrow);
	if (objrowid) {rowid=objrowid.value}
	
	if (confirm("ȷ��ɾ����?")==false) {return; }
	
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
		if (event.preventDefault()){event.preventDefault()} //yunhaibao20160201,��������Ļس�������keydown�¼�
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