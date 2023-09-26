/* =========================================================================
/By ZF 2007-09-05
============================================================================ */
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_Up="^";
var CHR_Tilted="/";
var strExpression = "";
var objDicResult = new ActiveXObject("Scripting.Dictionary");
var arryKeys = new Array();
function GetFieldSplitString()
{
    return appletFieldSplit;
}

function GetRowSplitString()
{
    return appletRowSplit;
}

function GetExamAutoCheckRuleItemById(RowID)
{
    if(RowID == "")
        return;
        
    var objItm = GetExamACRById("MethodGetExamACRById", RowID);
    var str = objItm.RowID + appletFieldSplit + objItm.Code + appletFieldSplit + objItm.Description  + appletFieldSplit + 
        objItm.Expression  + appletFieldSplit + (objItm.IsActive ? "Y" : "N") + appletFieldSplit + objItm.ResumeText  +" "+ appletFieldSplit;
    //window.alert(RowID + "\n" + str);
    return str;
}

function FindRuleByDesc(Desc)
{
    var arryResult = null;
    var objItm = null;
    var strKey = "";
    if(Desc == "")
        arryResult = GetExamACRAll("MethodGetExamACRAll");
    else
        arryResult = GetExamACRByDesc("MethodGetExamACRByDesc", Desc);
	arryKeys = new Array();
	objDicResult.RemoveAll();
	for(var i = 0; i < arryResult.length; i ++)
	{
	    objItm = arryResult[i];
	    objDicResult.Add(objItm.RowID, objItm);
	    arryKeys[i] = objItm.RowID;
	    strKey += objItm.RowID + appletFieldSplit;
	}
	return strKey;
}

function GetExpression()
{
    return strExpression;
}
function BodyLoadHandler()
{
	document.getElementById("cmdUpdate").onclick=Update_onclick;
	document.getElementById("txtPos").onblur=txtPos_onblur;
	Inform();
}
function Inform()
{


	var EntryRowid="",SectionRowid="";
	var objEntry=document.getElementById("EntryRowid");
	var objSection=document.getElementById("SectionRowid");
	if (objEntry)
	{
		EntryRowid=objEntry.value;
		SectionRowid=objSection.value;
		if ((EntryRowid=="")&&(SectionRowid=="")){
			alert("Link Error!");
			return;
		}
		if (EntryRowid!==""){
			var strMethod = document.getElementById("MethodGetEntry").value;
			var ret = cspRunServerMethod(strMethod,EntryRowid);
			if (ret!==""){
				var tmpList=ret.split(CHR_2);
				var tmpSubList1=tmpList[0].split("^");
				if (tmpList[1]){
					var tmpSubList2=tmpList[1].split("^");    //EntryDr
				}
				if (tmpList[7]){
					var tmpSubList3=tmpList[7].split("^");    //RSbilityDr
				}
				document.getElementById("EntryRowid").value=tmpSubList1[0];
				document.getElementById("txtDicEntryRowid").value=tmpSubList1[1];
				if (tmpList[1]){document.getElementById("txtDicEntry").value=tmpSubList2[2];}
				document.getElementById("txtScore").value=tmpSubList1[2];
				document.getElementById("txtPos").value=tmpSubList1[3];
				document.getElementById("txtMoney").value=tmpSubList1[4];
				if (tmpSubList1[5]=="Yes"){document.getElementById("chkMultiErr").checked=true;}
				else{document.getElementById("chkMultiErr").checked=false;}
				if (tmpSubList1[6]=="Yes"){document.getElementById("chkVeto").checked=true;}
				else{document.getElementById("chkVeto").checked=false;}
				document.getElementById("ParentDr").value=tmpSubList1[7];
				document.getElementById("txtLayer").value=tmpSubList1[8];
				document.getElementById("txtRSbilityRowid").value=tmpSubList1[9];
				if (tmpList[7]){document.getElementById("txtRSbility").value=tmpSubList3[3];}
				if (tmpSubList1[10]=="Yes"){document.getElementById("chkIsActive").checked=true;}
				else{document.getElementById("chkIsActive").checked=false;}
				document.getElementById("txtResume").value=tmpSubList1[11];
				strExpression = tmpSubList1[12];
			}
		}
	}
	var strApplet = "<APPLET ID = 'ExpressionEditor' Name = 'ExpressionEditor' codebase = '../addins/java' code = 'com.dhcc.wmr.qualityctl.maintain.EntryAutoCheckRuleEditor' width = '380' height	= '80' >";
	var objTable = document.getElementsByTagName("table")[2];
    objTable.rows[5].cells[1].appendChild(document.createElement(strApplet));


}

function txtPos_onblur()
{
	var cPos="",cRuleRowid="",cSectionSub="",cEntryChl="",cSectionRowid="",cEntryRowid="",cParentRowid="";
	var objSection=document.getElementById("SectionRowid");
	if (objSection){
		var tmpRowid=Trim(objSection.value);
		if (tmpRowid!==""){
			var tmpList=tmpRowid.split("||")
			cRuleRowid=tmpList[0];
			cSectionSub=tmpList[1];
		}
	}
	var objEntry=document.getElementById("EntryRowid");
	if (objEntry){
		var tmpRowid=Trim(objEntry.value);
		if (tmpRowid!==""){
			var tmpList=tmpRowid.split("||");
			cRuleRowid=tmpList[0];
			cSectionSub=tmpList[1];
			cEntryChl=tmpList[2];
		}
	}
	var objParent=document.getElementById("ParentDr");
	if (objParent){
		cParentRowid=Trim(objParent.value);
	}
	var objPos=document.getElementById("txtPos");
	if (objPos){cPos=Trim(objPos.value);}
	
	if ((cRuleRowid=="")||(cSectionSub=="")||(cEntryChl=="")) return;
	if ((cParentRowid=="")||(cPos=="")) return;
	var InString=cRuleRowid+"^"+cSectionSub+"^"+cEntryChl+"^"+cParentRowid+"^"+cPos;
	var strMethod = document.getElementById("MethodCheckEntryPos").value;
	var ret = cspRunServerMethod(strMethod,InString);
	if (ret<0){
		alert(t["Pos"]);
		objPos.value="";
		return;
	}
}

function Update_onclick()
{
	var cSectionRowid="",cEntrySub="",cDicEntryRowid="",cScore="",cPos="",cMoney="";
	var cMultiErr="",cVeto="",cParentDr="",cLayer="",cRSbilityDr="",cIsActive="",cResume="";
	
	var objSection=document.getElementById("SectionRowid");
	if (objSection){
		cSectionRowid=Trim(objSection.value);
		var tmpRowid=Trim(objSection.value);
		if (tmpRowid!==""){
			var tmpList=tmpRowid.split("||");
			cSectionRowid=tmpList[0]+"||"+tmpList[1];
		}
	}
	var objEntry=document.getElementById("EntryRowid");
	if (objEntry){
		var tmpRowid=Trim(objEntry.value);
		if (tmpRowid!==""){
			var tmpList=tmpRowid.split("||");
			cSectionRowid=tmpList[0]+"||"+tmpList[1];
			cEntrySub=tmpList[2];
		}
	}
	
	if (cSectionRowid==""){
		alert("Link Error!");
		return;
	}
	
	var objDicEntryRowid=document.getElementById("txtDicEntryRowid");
	var objDicEntry=document.getElementById("txtDicEntry");
	if (objDicEntryRowid){
		cDicEntryRowid=Trim(objDicEntryRowid.value);
		if (cDicEntryRowid==""){
			objDicEntry.value="";
			objDicEntryRowid.value="";
			alert(t['Entry']);
			objDicEntry.focus;
			return;
		}
	}
	var objScore=document.getElementById("txtScore");
	if (objScore){
		cScore=Trim(objScore.value);
		if (cScore==""){
			alert(t['Score']);
			objScore.focus;
			return;
		}
	}
	var objPos=document.getElementById("txtPos");
	if (objPos){
		cPos=Trim(objPos.value);
		if (cPos==""){
			alert(t['Pos']);
			objPos.focus;
			return;
		}
	}
	
	var objMoney=document.getElementById("txtMoney");
	if (objMoney){cMoney=Trim(objMoney.value);}

	var objMultiErr=document.getElementById("chkMultiErr");
	if (objMultiErr){
		if (objMultiErr.checked==true){cMultiErr="Y"}
		else{cMultiErr="N"}
	}
	
	var objParent=document.getElementById("ParentDr");
	if (objParent){cParentDr=Trim(objParent.value);}
	
	var objLayer=document.getElementById("txtLayer");
	if (objLayer){
		cLayer=Trim(objLayer.value);
		if (cLayer==""){
			alert(t['Layer']);
			objLayer.focus;
			return;
		}
	}
	
	var objVeto=document.getElementById("chkVeto");
	if (objVeto){
		if (objVeto.checked==true){cVeto="Y"}
		else{cVeto="N"}
	}
	
	var objRSbilityRowid=document.getElementById("txtRSbilityRowid");
	var objRSbility=document.getElementById("txtRSbility");
	if (objRSbilityRowid){
		cRSbilityDr=Trim(objRSbilityRowid.value);
		cRSbility=Trim(objRSbility.value);
		if (cRSbility=="") {
			//alert(t['RSbility']);
			//return;
		}
	}
	
	var objIsActive=document.getElementById("chkIsActive");
	if (objIsActive){
		if (objIsActive.checked==true){cIsActive="Y"}
		else{cIsActive="N"}
	}
	var objResume=document.getElementById("txtResume");
	if (objResume){cResume=Trim(objResume.value);}
	var strExpression = document.getElementById("ExpressionEditor").GetExpression();
	if(strExpression == "error")
	    return;
	var InString=cSectionRowid+"^"+cEntrySub+"^"+cDicEntryRowid+"^"+cScore+"^"+cPos+"^"+cMoney;
	InString=InString+"^"+cMultiErr+"^"+cVeto+"^"+cParentDr+"^"+cLayer+"^"+cRSbilityDr+"^"+cIsActive+"^"+cResume +"^"+strExpression;
	var strMethod = document.getElementById("MethodUpdateEntry").value;
	var ret = cspRunServerMethod(strMethod,InString);
	if (ret<0){
		alert(t['UpdateFalse']);
		return;
	}else{
		alert(t['UpdateTrue']);
		window.close();
		//window.opener.location.close();
		//parent.location.reload();
	}
}

function LookUpDicEntry(str)
{
	var tmpList=str.split("^");
	var objDicEntryRowid=document.getElementById('txtDicEntryRowid');
	if (objDicEntryRowid){objDicEntryRowid.value=tmpList[0];}
	var objEntryTitle=document.getElementById('txtDicEntry');
	if (objEntryTitle){objEntryTitle.value=tmpList[1];}
}

function LookUpRSbility(str)
{
	var tmpList=str.split("^");
	var objRSbilityRowid=document.getElementById('txtRSbilityRowid');
	if (objRSbilityRowid){objRSbilityRowid.value=tmpList[0];}
	var objRSbilityTitle=document.getElementById('txtRSbility');
	if (objRSbilityTitle){objRSbilityTitle.value=tmpList[1];}
}

document.body.onload = BodyLoadHandler;
 
	function LTrim(str){
		var i;
		for(i=0;i < str.length; i ++)
		{
			 if(str.charAt(i)!=" "&&str.charAt(i)!=" ") 
				break;
		}
		str = str.substring(i,str.length);
		return str;
	}
	
	function RTrim(str){
		var i;
		for(i = str.length - 1; i>=0; i--)
		{
			if(str.charAt(i)!=" "&&str.charAt(i)!=" ") 
				break;
		}
		str = str.substring(0,i+1);
		return str;
	}
	
	function Trim(str){
		return LTrim(RTrim(str));
	} 
	
