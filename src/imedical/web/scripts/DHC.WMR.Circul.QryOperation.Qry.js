function BodyLoadHandler()
{
	var obj=document.getElementById("btnFind");
	if (obj){obj.onclick=btnFind_onclick;}
	var obj=document.getElementById("btnPrint");
	if (obj){obj.onclick=btnPrint_onclick;}
	var obj=document.getElementById("txtLocDesc");
	if (obj){obj.onchange=txtLocDesc_onchange;}
	var obj=document.getElementById("txtDocDesc");
	if (obj){obj.onchange=txtDocDesc_onchange;}
	//DisplayLoc();
}

function DisplayLoc()
{
	var LocRowid = session['LOGON.CTLOCID'];
	var strMethod = document.getElementById("MethodGetLoc").value;
	var ret = cspRunServerMethod(strMethod,LocRowid);
	var tmpList=ret.split("^");
	if (tmpList.length>=2)
	{
		document.getElementById("txtLocId").value=tmpList[0];
		document.getElementById("txtLocDesc").value=tmpList[2];
	}
}

function btnFind_onclick()
{
	var Loc="",Doc="",DateFrom="",DateTo="",AdmStatus="";
	
	var obj=document.getElementById("txtFromDate");
	if (obj){DateFrom=obj.value;}
	
	var obj=document.getElementById("txtToDate");
	if (obj){DateTo=obj.value;}
	
	var obj=document.getElementById("txtLocId");
	if(obj) {Loc=obj.value;}
	
	var obj=document.getElementById("txtDocId");
	if(obj) {Doc=obj.value;}
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.Circul.QryOperation.List" + "&OperLoc=" + Loc + "&OperDoc=" + Doc + "&DateFrom=" + DateFrom + "&DateTo=" + DateTo;
	parent.RPbottom.location.href=lnk;
}


function txtLocDesc_onchange()
{
	if (document.getElementById("txtLocDesc").value=="")
	{
		document.getElementById("txtLocId").value="";
	}
}

function txtDocDesc_onchange()
{
	if (document.getElementById("txtDocDesc").value=="")
	{
		document.getElementById("txtDocId").value="";
	}
}

function LookUpLocDesc(str)
{
	var tmpList=str.split("^");
	document.getElementById("txtLocId").value=tmpList[0];
	document.getElementById("txtLocDesc").value=tmpList[1];
}

function LookUpDocDesc(str)
{
	var tmpList=str.split("^");
	document.getElementById("txtDocId").value=tmpList[0];
	document.getElementById("txtDocDesc").value=tmpList[2];
}

function btnPrint_onclick()
{
	var objLnk=parent.RPbottom;
	var OperLoc=GetParam(objLnk,"OperLoc");
	var OperDoc=GetParam(objLnk,"OperDoc");
	var DateFrom=GetParam(objLnk,"DateFrom");
	var DateTo=GetParam(objLnk,"DateTo");
	var cArguments=OperLoc+"^"+OperDoc+"^"+DateFrom+"^"+DateTo;
	var flg=PrintDataByExcel("MethodGetServer","MethodGetData","DHCWMRCirculQryOperation.xls",cArguments);
}

document.body.onload=BodyLoadHandler;