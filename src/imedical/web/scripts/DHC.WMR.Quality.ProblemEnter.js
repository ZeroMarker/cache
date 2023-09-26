function InitFrom()
{
	DisplayExamRule();
	if (GetParam(window,"ExamRule")=="") {btnQuery_onclick();}
	DisplayLoc();
	DisplayIPNo();
	var obj=document.getElementById("btnEntryItem");
	if (obj){obj.onclick=btnEntryItem_onclick;}
	var obj=document.getElementById("txtLocDesc");
	if (obj){obj.onchange=txtLocDesc_onchange;}
	var obj=document.getElementById("txtEmployeeDesc");
	if (obj){obj.onchange=txtEmployeeDesc_onchange;}
	var obj=document.getElementById("btnSave");
	if (obj){obj.onclick=btnSave_onclick;}
	var obj=document.getElementById("btnDel");
	if (obj){obj.onclick=btnDel_onclick;}
	var obj=document.getElementById("cboExamRule");
	if (obj){obj.onchange=btnQuery_onclick;}
}

function SelectRowHandler()
{
	var objtbl=document.getElementById('tDHC_WMR_Quality_ProblemEnter');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var eSrc=window.event.srcElement;
	var objRow=getRow(eSrc);
	var selectrow=objRow.rowIndex;
	if (selectrow <= 0) return;
	
	var RRstDtlPId=document.getElementById('RRstDtlPIdz'+selectrow).value;
	var RstSignUser=document.getElementById('RSignUserIdz'+selectrow).value;
	if (document.getElementById("DelRstDtlPId").value!==RRstDtlPId)
	{
		document.getElementById("DelRstDtlPId").value=RRstDtlPId;
		document.getElementById("DelRstSignUser").value=RstSignUser;
	}else{
		document.getElementById("DelRstDtlPId").value="";
		document.getElementById("DelRstSignUser").value="";
	}
}

function btnDel_onclick()
{
	var RstDtlPId=document.getElementById("DelRstDtlPId").value;
	if (RstDtlPId=="")
	{
		alert(t["RstDtlPIdNot"]);
		return;
	}
	
	var RstSignUser=document.getElementById("DelRstSignUser").value;
	if (RstSignUser!==session['LOGON.USERID'])
	{
		alert(t["RstSignUserNot"]);
		return;
	}
	
	var RstRowid=document.getElementById("DelRstDtlPId").value;
	var strMethod = document.getElementById("MethodDeleteIniResult").value;
	var ret = cspRunServerMethod(strMethod,RstRowid);
	if ((ret)||(ret>0))
	{
		document.getElementById("DelRstDtlPId").value="";
		document.getElementById("DelRstSignUser").value="";
		//alert(t["DeleteRstSuccess"]);
		window.location.reload();
	}else{
		alert(t["DeleteRstFail"]);
	}
}

function DisplayLoc()
{
	var LocRowid = session['LOGON.CTLOCID'];
	var strMethod = document.getElementById("MethodGetLoc").value;
	var ret = cspRunServerMethod(strMethod,LocRowid);
	var tmpList=ret.split("^");
	if (tmpList.length>=2)
	{
		document.getElementById("txtLocID").value=tmpList[0];
		document.getElementById("txtLocDesc").value=tmpList[2];
	}
	
	var obj=document.getElementById("cboExamRule");
	if (obj){
		var ind=obj.options.selectedIndex;
		if (ind<0) return;
		var ExamRuleDesc=obj.options[ind].innerText;
		var tmpList=ExamRuleDesc.split("-");
		if (!tmpList[0]) return;
		if (tmpList[0]<11){
			document.getElementById("txtLocDesc").disabled=true;
		}
	}
}

function DisplayIPNo()
{
	var Paadm=document.getElementById("ArgPaadm").value;
	var strMethod=document.getElementById("MethodGetIPNoByPaadm").value;
	var ret = cspRunServerMethod(strMethod,Paadm);
	document.getElementById("txtIPNo").value=ret;
	var obj=document.getElementById("cboExamRule");
	if (obj){
		var ind=obj.options.selectedIndex;
		if (ind<0) return;
		var ExamRuleDesc=obj.options[ind].innerText;
		var tmpList=ExamRuleDesc.split("-");
		if (!tmpList[0]) return;
		if (tmpList[0]<11){
			document.getElementById("txtIPNo").disabled=true;
		}
	}
}

function DisplayExamRule()
{
	var obj=document.getElementById("cboExamRule");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.length=0;
		
		var UserGrouId = session['LOGON.GROUPID'];
		var strMethod = document.getElementById("MethodGetExamRule").value;
		var ret = cspRunServerMethod(strMethod,UserGrouId);
		var tmpList=ret.split("$");
		for (var ind=0;ind<tmpList.length;ind++)
		{
			var tmpListSub=tmpList[ind].split("^");
			var objItm=document.createElement("OPTION");
			obj.options.add(objItm);
			objItm.innerText = tmpListSub[1];
			objItm.value = tmpListSub[0];
		}
		if (tmpList.length>0){obj.selectedIndex=0;}
		var CurrExamRule=GetParam(window,"ExamRule")
		if (CurrExamRule!=="")
		{
			for (var ind=0;ind<obj.options.length;ind++)
			{
				if (obj.options[ind].value==CurrExamRule) {obj.selectedIndex=ind;}
			}
		}
	}
}

function btnQuery_onclick()
{
	var Paadm=document.getElementById("ArgPaadm").value;
	var ExamRule=""
	var obj=document.getElementById("cboExamRule");
	if (obj){
		var ind=obj.options.selectedIndex;
		if (ind>=0){ExamRule=obj.options[ind].value;}
	}
	var Responsibility="Responsibility";
	var ErrorType="ErrorType";
	var DicActive="Y";
	var IsActive="Y";
	var ExamType="";
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.Quality.ProblemEnter&EpisodeID=" + Paadm + "&Paadm=" + Paadm + "&ExamRule=" + ExamRule + "&Responsibility=" + Responsibility + "&ErrorType=" + ErrorType + "&DicActive=" + DicActive + "&IsActive=" + IsActive + "&ExamType=" + ExamType;
	location.href=lnk;
}

function btnSave_onclick()
{
	//IniResult=Paadm^ExamRule^SignUser^ExamEntry^INumber^TriggerDate^ErrType^ResumeText^Employee^RSbility^Loc
	var Paadm=document.getElementById("ArgPaadm").value;
	var ExamRule="";
	var obj=document.getElementById("cboExamRule");
	if (obj){
		var ind=obj.options.selectedIndex;
		if (ind>=0){ExamRule=obj.options[ind].value;}
	}
	var SignUser=session['LOGON.USERID']
	var ExamEntry=document.getElementById("txtEntryID").value;
	var INumber=document.getElementById("txtINumber").value;
	var TriggerDate=document.getElementById("txtQueDate").value;
	var ErrType=document.getElementById("txtQueTypeID").value;
	var ResumeText=document.getElementById("txtResume").value;
	var Employee=document.getElementById("txtEmployeeID").value;
	var RSbility=document.getElementById("txtEmpTypeID").value;
	var Loc=document.getElementById("txtLocID").value;
	var RstID=document.getElementById("ArgRstID").value;
	
	if ((Paadm=="")||(ExamRule=="")||(SignUser=="")||(ExamEntry=="")||(INumber=="")) return;
	if ((TriggerDate=="")||(ErrType=="")||(Employee=="")||(RSbility=="")||(Loc=="")) return;
	
	var IniResult=Paadm + "^" + ExamRule + "^" + SignUser + "^" + ExamEntry + "^" + INumber + "^" + TriggerDate + "^" + ErrType + "^" + ResumeText + "^" + Employee + "^" + RSbility + "^" + Loc
	var strMethod = document.getElementById("MethodSaveIniResult").value;
	var ret = cspRunServerMethod(strMethod,RstID,IniResult);
	if ((ret)&&(ret>0))
	{
		//window.location.reload();
		btnQuery_onclick();
	}else{
		alert(t["SaveRstFail"]);
	}
	
}

function btnEntryItem_onclick()
{
	var ExamRule="";
	var obj=document.getElementById("cboExamRule");
	if (obj){
		var ind=obj.options.selectedIndex;
		if (ind>=0){ExamRule=obj.options[ind].value;}
	}
	if (ExamRule==""){
		alert(t['ExamRullNull']);
		return;
	}
	
	var strUrl = "dhc.wmr.quality.tree.csp?&ExamRule="+ExamRule;
	var ret = "";
	ret = window.showModalDialog(strUrl,"","dialogHeight=600px;dialogWidth=600px;scroll=no;status=yes;resizable=yes");
	if((ret)&&(ret !== ""))
	{
		var tmpList=ret.split("^");
		document.getElementById("txtEntryID").value=tmpList[0];
		document.getElementById("txtEntryDesc").value=tmpList[1];
	}
}

function txtLocDesc_onchange()
{
	if (document.getElementById("txtLocDesc").value=="")
	{
		document.getElementById("txtLocID").value="";
	}
}

function txtEmployeeDesc_onchange()
{
	if (document.getElementById("txtEmpTypeDesc").value=="")
	{
		document.getElementById("txtEmpTypeID").value="";
	}
}

function LookupEmpTypeDic(str)
{
	var tmpList=str.split("^");
	document.getElementById("txtEmpTypeID").value=tmpList[0];
	document.getElementById("txtEmpTypeDesc").value=tmpList[2];
}

function LookupQueTypeDic(str)
{
	var tmpList=str.split("^");
	document.getElementById("txtQueTypeID").value=tmpList[0];
	document.getElementById("txtQueTypeDesc").value=tmpList[2];
}

function LookupLoc(str)
{
	var tmpList=str.split("^");
	document.getElementById("txtLocID").value=tmpList[0];
	document.getElementById("txtLocDesc").value=tmpList[1];
}

function LookupEmployee(str)
{
	var tmpList=str.split("^");
	document.getElementById("txtEmployeeID").value=tmpList[0];
	document.getElementById("txtEmployeeDesc").value=tmpList[2];
}

InitFrom();