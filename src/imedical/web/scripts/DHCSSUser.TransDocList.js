var CurrentRow;
function BodyLoadHandler()
{	
   var doccode="";
   var obj=document.getElementById("find")
   if (obj) obj.onclick=Findclick;
   var obj=document.getElementById("doccode")
   if (obj) obj.onkeydown=Codeclick;
   var objtbl=document.getElementById("t"+"DHCSSUser_TransDocList")
   if (objtbl) objtbl.ondblclick=Savedata;
   
}
///��ѯ����
function Findclick()
{
	var doccode="";
	var obj=document.getElementById("doccode")
	if (obj) obj.value=trim(obj.value);
	find_click();
}
///�����ѯ
function Codeclick()
{
	if (window.event.keyCode==13){
	 Findclick();	
	} 
	
}
function Savedata()
{
	if (!CurrentRow) {
		"����ѡ����תҽ��"
		return;
	}
	
	var ret=confirm("ȷ�ϼ��뱾����תҽ���б���?");
	if (ret!=true) return;
	
    var ret=CheckTDocFlag();
    if (ret!=0) return;
	
	var ctpcp=""
	var obj=document.getElementById("Tctpcp"+"z"+CurrentRow)
    if (obj) var ctpcp=obj.value
    var currloc=session['LOGON.CTLOCID'] ;
    var currgrp=session['LOGON.GROUPID'] ;
    var xx=document.getElementById("mSave");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,ctpcp,currloc,currgrp) ;
	if (result!=0){alert("����ʧ��"+result);return}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCSSUser.LocTDoc&loc="+currloc
	parent.frames['DHCSSUser.LocTDoc'].location.href=lnk;

}

function SelectRowHandler()
{
   var row=selectedRow(window)
   CurrentRow=row;

}

///���������Ƿ���תҽ��,��תҽ��û��Ȩ�޷���
function CheckTDocFlag()
{
	var ssuser=session['LOGON.USERID'] ;
	var xx=document.getElementById("mCheck");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,ssuser) ;
	if (result!=0){alert("��û�д�Ȩ��,���ʵ������!");}
	
	return result
	
}


document.body.onload=BodyLoadHandler;