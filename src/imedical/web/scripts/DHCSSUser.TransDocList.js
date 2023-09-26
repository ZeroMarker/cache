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
///查询数据
function Findclick()
{
	var doccode="";
	var obj=document.getElementById("doccode")
	if (obj) obj.value=trim(obj.value);
	find_click();
}
///代码查询
function Codeclick()
{
	if (window.event.keyCode==13){
	 Findclick();	
	} 
	
}
function Savedata()
{
	if (!CurrentRow) {
		"请先选择轮转医生"
		return;
	}
	
	var ret=confirm("确认加入本科轮转医生列表吗?");
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
	if (result!=0){alert("保存失败"+result);return}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCSSUser.LocTDoc&loc="+currloc
	parent.frames['DHCSSUser.LocTDoc'].location.href=lnk;

}

function SelectRowHandler()
{
   var row=selectedRow(window)
   CurrentRow=row;

}

///检查操作人是否轮转医生,轮转医生没有权限分配
function CheckTDocFlag()
{
	var ssuser=session['LOGON.USERID'] ;
	var xx=document.getElementById("mCheck");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,ssuser) ;
	if (result!=0){alert("您没有此权限,请核实后重试!");}
	
	return result
	
}


document.body.onload=BodyLoadHandler;