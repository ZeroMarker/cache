/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.No.Edit

AUTHOR: ZhuFei , Microsoft
DATE  : 2007-3

COMMENT: DHC.WMR.No.Edit event handler

========================================================================= */
function BodyLoadHandler()
{
	var obj=document.getElementById("cmdBatchCreatMrNo");
	if (obj){ obj.onclick=cmdBatchCreatMrNo_click;}
	iniForm();
}

function iniForm()
{
	var obj=document.getElementById("cboType");
	if (obj){
		obj.size=1;
		obj.multiple=false;
	}
}

function cmdBatchCreatMrNo_click()
{
	var cType="",cLoc="",cActive="",cUser="",cResume="";
	var cNoFrom="",cNoTo=""
	var obj=document.getElementById("cboType");
	if (obj){
		var Idx=obj.options.selectedIndex;
		if (Idx==-1){return;}
		var cType=obj.options[Idx].value;
	}
	
	var obj=document.getElementById("txtDepId");
	if (obj){
		cLoc=Trim(obj.value);
	}
	
	var obj=document.getElementById("txtResume");
	if (obj){var cResume=Trim(obj.value);}
	
	var obj=document.getElementById("txtNoFrom");
	if (obj){var cNoFrom=Trim(obj.value);}
	var obj=document.getElementById("txtNoTo");
	if (obj){var cNoTo=Trim(obj.value);}
	cNoFrom=parseInt(cNoFrom);
	if (isNaN(cNoFrom)) {
		return;
		}
	cNoTo=parseInt(cNoTo);
	if (isNaN(cNoTo)) {	
		return;
		}

	if (cNoFrom>cNoTo){
		alert(t['NoFromNoToFalse'])
		return;
		}
	
	cUser=session['LOGON.USERID']
	
	var InStr=cType+"^"+cLoc+"^"+cResume+"^"+cUser+"^"+cNoFrom+"^"+cNoTo;
	var obj=document.getElementById('ClassBatchCreatMrNo');
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var ret=cspRunServerMethod(encmeth,InStr);
    var Temp=ret.split("^")
    if (Temp[0]==1){
	    if (Trim(Temp[1])!="") {
		    alert(t['AddDataTrue']+"---"+Trim(Temp[1])+" have been already assigned!");
		    }
		else{
			//alert(t['AddDataTrue']);
			}
    	}
    else{
	    alert(t['AddDataFalse']);
	    }
	
	var obj=window.opener.document.getElementById('cboType');
	if (obj){
		for(var i = 0; i < obj.options.length; i++)
			{
			var Tmp=obj.options.item(i).value;
			if(Tmp==cType){obj.selectedIndex=i;}
			}
		}
	/*
	var obj=window.opener.document.getElementById('cboLoc');
	if (obj){
		for(var i = 0; i < obj.options.length; i++)
			{
			var Tmp=obj.options.item(i).value;
			if(Tmp==cLoc){obj.selectedIndex=i;}
			}
		}
	*/
	var obj=window.opener.document.getElementById('chkFlag');
	if (obj){
	
		obj.checked=true;
		}
	window.opener.Query_click();
	window.close();
}

function LookUpDep(str)
{
	var objDepId=document.getElementById('txtDepId');
	var objDep=document.getElementById('txtDep');
	var tem=str.split("^");
	objDepId.value=tem[0];
	objDep.value=tem[1];
}
document.body.onload = BodyLoadHandler;