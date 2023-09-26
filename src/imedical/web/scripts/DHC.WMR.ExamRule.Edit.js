/* =========================================================================
/By wuqk 2007-09-07
============================================================================ */
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_Up="^";
var CHR_Tilted="/";
function BodyLoadHandler()
{
	var obj=document.getElementById("UpdateRule");
	if (obj){obj.onclick=Update_click;}
	var obj=document.getElementById("ScoreMethod");
	if (obj){
		obj.multiple = false;
	    obj.size = 1;
	    gSetListValue("ScoreMethod","Reduce",0);
	    gSetListValue("ScoreMethod","Add",1);
	    }
	GetData();
}

function GetData()
{
	var DicRowId=document.getElementById("DicRowId").value;
	if (DicRowId==""){}
	else{
	    var strMethod = document.getElementById("MethodGetDic").value;
	    var ret = cspRunServerMethod(strMethod,DicRowId);
	    if (ret!=""){
		    showDic(ret);
		    }
		}
	var RuleRowid=document.getElementById("RuleRowid").value;
	if (RuleRowid==""){}
	else{
	    var strMethod = document.getElementById("MethodGetRule").value;
	    var ret = cspRunServerMethod(strMethod,RuleRowid);
	    if (ret!=""){
		    showRule(ret);
		    }
		}
}
function showDic(value)
{
	var tempArr0=value.split(CHR_2);
	var tempArr=tempArr0[0].split(CHR_Up);
	gSetObjValue("DicTitle",tempArr[2]);
}
function showRule(value)
{
	var tempArr0=value.split(CHR_2);
	var tempArr=tempArr0[0].split(CHR_Up);
	gSetObjValue("MaxScore",tempArr[2]);
	gSetObjValue("PassingScore",tempArr[3]);
	gSetObjValue("DeductLine",tempArr[4]);
	gSetObjValue("MonyPerPoint",tempArr[5]);
	//gSetObjValue("ScoreMethod",tempArr[7]);
	if (tempArr[7]=="A"){gSetListIndex("ScoreMethod",1);}
	else{gSetListIndex("ScoreMethod",0);}
	var obj=document.getElementById("RIsActive")
	if (tempArr[8]=="Yes"){obj.checked=true;}
	else{obj.checked=false;} 
	//gSetObjValue("RIsActive",tempArr[8]);
	gSetObjValue("RuleResumeText",tempArr[9]);
}
function Update_click()
{
	if (VerifyData()==false){
		alert(['DataTypeErr']);
		return;
		}
	
	var Instring=BuildData();
	var strMethod = document.getElementById("MethodUpdate").value;
	
	var ret = cspRunServerMethod(strMethod,Instring);
	if (ret > 0 ){
		//alert(t['UpdateTrue']);
	    var RuleRowid=Number(ret);
	    var DicRowId=gGetListData("DicRowId");
		lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.ExamRule.Edit&DicRowid="+DicRowId+"&RuleRowid="+RuleRowid;
		location.href=lnk;
		    }
	else{
		alert(['UpdateFalse']+" Error:"+ret);
		}
}
function VerifyData(){
	
	if (isNaN(Number(gGetListData("MaxScore")))){
		 websys_setfocus("MaxScore");
		 return false;
		}
	if (isNaN(Number(gGetListData("PassingScore")))){
		 websys_setfocus("PassingScore");
		 return false;
		}
	return true;
}
function BuildData()
{
	var s=gGetListData("RuleRowid")+ CHR_Up;
	s=s + gGetListData("DicRowId") + CHR_Up;
	s=s + gGetListData("MaxScore") + CHR_Up;
	s=s + gGetListData("PassingScore") + CHR_Up;
	s=s + gGetListData("DeductLine") + CHR_Up;
	s=s + gGetListData("MonyPerPoint") + CHR_Up;
	s=s + gGetListData("Punishment") + CHR_Up;
	var ScoreMethod=gGetObjValue("ScoreMethod")
	if (ScoreMethod=="Add"){s=s + "A" + CHR_Up;}
	else {s=s + "R" + CHR_Up;}
	var obj=document.getElementById("RIsActive")
	if (obj.checked==true){s=s + "Yes" + CHR_Up;}
	else{s=s + "No" + CHR_Up;}
	s+=gGetListData("RuleResumeText");
	return s;
}


document.body.onload = BodyLoadHandler;