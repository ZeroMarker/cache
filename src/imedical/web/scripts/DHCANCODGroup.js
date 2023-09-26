function BodyLoadHandler()
{
	var objAdd=document.getElementById("btnAdd");
	objAdd.onclick=Add_Click;
	
	var objModify=document.getElementById("btnModify");
	objModify.onclick=Modify_Click;
	
	var objDel=document.getElementById("btnDel");
	objDel.onclick=Del_Click;
	
	var objTxtOPDoc=document.getElementById("txtOPDoc");
	objTxtOPDoc.onkeydown=GetOPDoc;
	
	var objTxtFrtAst=document.getElementById("txtFrtAst");
	objTxtFrtAst.onkeydown=GetFrtAst;
	
	var objSecAst=document.getElementById("txtSecAst");
	objSecAst.onkeydown=GetSecAst;
	
	var objTrdAst=document.getElementById("txtTrdAst");
	objTrdAst.onkeydown=GetTrdAst;
}

function Add_Click()
{
	var add=document.getElementById("Add").value;
	var groupID=document.getElementById("txtGroupID").value;
	var deptID=session['LOGON.CTLOCID'];
	var docID=document.getElementById("opDocID").value;
	var txtOpDoc=document.getElementById("txtOPDoc").value;
	if(txtOpDoc=="")
	{
		document.getElementById("opDocID").value="";
		docID="";
		alert("请选择手术医生");//20160920+dyl
		return;
	}
	var frtAstID=document.getElementById("frtAstID").value;
	var txtFirstAst=document.getElementById("txtFrtAst").value;
	if(txtFirstAst=="")
	{
		document.getElementById("frtAstID").value="";
		frtAstID="";
		alert("请选择一助");//20160920+dyl
		return;
	}
	var secAstID=document.getElementById("secAstID").value;
	var objSecAst=document.getElementById("txtSecAst");	//20160920+dyl
	if(objSecAst.value=="")
	{
		secAstID="";
	}
	var trdAstID=document.getElementById("trdAstID").value;
	var objTrdAst=document.getElementById("txtTrdAst");	//20160920+dyl
	if(objTrdAst.value=="")
	{
		trdAstID="";
	}
	var groupStr=docID+"^"+frtAstID+"^"+secAstID+"^"+trdAstID;
	var res=cspRunServerMethod(add,deptID,groupID,groupStr);
	if(res==0)
	{
		alert(t['01']);
		window.location.reload();	
	}
	else
	{
		alert(t['02']);
	}
	
}

function Modify_Click()
{
	var modify=document.getElementById("Modify").value;
	var deptID=session['LOGON.CTLOCID'];
	var objtxtGroupID=document.getElementById("txtGroupID");
	var selectrow=document.getElementById("selrow").value;
	if(selectrow=="")
	{
		alert("请选中一行");
		return;	
	}
	if(objtxtGroupID.value=="")
	{
		alert("请填写组号");
		return;	
	}
	var oldGroupID=document.getElementById("tGroupIDz"+selectrow).innerText;
	var objopDocID=document.getElementById("opDocID");
	var txtOPDoc=document.getElementById("txtOPDoc");
	if(txtOPDoc.value=="")
	{
		objopDocID.value="";//20160920+dyl
		alert("请选择手术医师");
		return;	
	}
	var objfrtAstID=document.getElementById("frtAstID");
	var txtFrtAst=document.getElementById("txtFrtAst");
	if(txtFrtAst.value=="")
	{
		objfrtAstID.value="";
		alert("请选择一助")	;	//20160920+dyl
		return;
	}
	var ObjsecAstID=document.getElementById("secAstID");
	var txtSecAst=document.getElementById("txtSecAst");
	if(txtSecAst.value=="")
	{
		ObjsecAstID.value="";	
	}
	
	var objtrdAstID=document.getElementById("trdAstID");
	var txtTrdAst=document.getElementById("txtTrdAst");
	if(txtTrdAst.value=="")
	{
		objtrdAstID.value="";	
	}
	
	var groupStr=objopDocID.value+"^"+objfrtAstID.value+"^"+ObjsecAstID.value+"^"+objtrdAstID.value;
	var res=cspRunServerMethod(modify,deptID,objtxtGroupID.value,oldGroupID,groupStr);
	
	if(res==0)
	{
		alert(t['05']);	
		window.location.reload();
	}
	else
	{
		alert(res);	
	}
}

function Del_Click()
{
	var del=document.getElementById("Del").value;
	var deptID=session['LOGON.CTLOCID'];
	var txtGroupID=document.getElementById("txtGroupID");
	var res=cspRunServerMethod(del,deptID,txtGroupID.value);
	if(res==0)
	{
		alert(t['07']);	
		window.location.reload();
	}	
	else
	{
		alert(t['08']);
	}
}
var befRow="",curRow=""
function SelectRowHandler()
{
	//获取选中的行
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var	selectrow=rowObj.rowIndex;
		var selrow=document.getElementById("selrow");
	selrow.value=selectrow;

	//获取table的记录数
	var objtbl=document.getElementById('tDHCANCODGroup');
	var rows=objtbl.rows.length;
		var ObjtxtGroupID=document.getElementById("txtGroupID");
		var ObjtxtOPDoc=document.getElementById("txtOPDoc");
		var ObjopDocID=document.getElementById("opDocID");
		var ObjtxtFrtAst=document.getElementById("txtFrtAst");
		var ObjfrtAstID=document.getElementById("frtAstID");
		var ObjtxtSecAst=document.getElementById("txtSecAst");
		var ObjsecAstID=document.getElementById("secAstID");
		var ObjtxtTrdAst=document.getElementById("txtTrdAst");
		var ObjtrdAstID=document.getElementById("trdAstID");
	if(selectrow!=befRow)
	{
		ObjtxtGroupID.value=document.getElementById("tGroupIDz"+selectrow).innerText;
		ObjtxtOPDoc.value=document.getElementById("tOPDocz"+selectrow).innerText;
		ObjopDocID.value=document.getElementById("tOPDocIdz"+selectrow).innerText;
		ObjtxtFrtAst.value=document.getElementById("tFrtAstz"+selectrow).innerText;
		ObjfrtAstID.value=document.getElementById("tFrtAstIdz"+selectrow).innerText;
		ObjtxtSecAst.value=document.getElementById("tSecAstz"+selectrow).innerText;
		ObjsecAstID.value=document.getElementById("tSecAstIdz"+selectrow).innerText;
		ObjtxtTrdAst.value=document.getElementById("tTrdAstz"+selectrow).innerText;
		ObjtrdAstID.value=document.getElementById("tTrdAstIdz"+selectrow).innerText;
		befRow=selectrow;
	}
	else
	{
		ObjtxtGroupID.value="";
		ObjtxtOPDoc.value="";
		ObjopDocID.value="";
		ObjtxtFrtAst.value="";
		ObjfrtAstID.value="";
		ObjtxtSecAst.value="";
		ObjsecAstID.value="";
		ObjtxtTrdAst.value="";
		ObjtrdAstID.value="";
		befRow="",curRow="";
	}
	
}

function LookUpOPDoc(str)
{
	var opDoc=document.getElementById("txtOPDoc");
	var opDocID=document.getElementById("opDocID");
	var tmp=str.split("^");
	opDoc.value=tmp[1];
	opDocID.value=tmp[0];	
	if(opDoc.value=="")opDocID.value="";
}

function LookUpFrtAst(str)
{
	var frtAst=document.getElementById("txtFrtAst");
	var frtAstID=document.getElementById("frtAstID");
	var tmp=str.split("^");
	frtAst.value=tmp[1];	
	frtAstID.value=tmp[0];
	if(frtAst.value=="")frtAstID.value="";
}

function LookUpSecAst(str)
{
	var secAst=document.getElementById("txtSecAst");
	var secAstID=document.getElementById("secAstID");
	var tmp=str.split("^");
	secAst.value=tmp[1];
	secAstID.value=tmp[0];	
	if(secAst.value=="")secAstID.value="";
}

function LookUpTrdAst(str)
{
	var trdAst=document.getElementById("txtTrdAst");
	var trdAstID=document.getElementById("trdAstID");
	var tmp=str.split("^");
	trdAst.value=tmp[1];
	trdAstID.value=tmp[0];	
	if(trdAst.value=="")trdAstID.value="";
}

function GetOPDoc()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		txtOPDoc_lookuphandler();	
	}	
}

function GetTrdAst()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		txtTrdAst_lookuphandler();	
	}	
}

function GetFrtAst()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		txtFrtAst_lookuphandler();	
	}	
}

function GetSecAst()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		txtSecAst_lookuphandler();	
	}	
}

document.body.onload=BodyLoadHandler;