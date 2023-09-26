/* ======================================================================
AUTHOR: wuqk , Microsoft
DATE  : 2007-9
========================================================================= */
function BodyLoadHandler()
{
	var obj=document.getElementById("cmdQuery");
	if (obj){ obj.onclick=Query_click;}
	//var obj=document.getElementById("RuleDic");
	//if (obj){ obj.onclick=RuleDic_click;}
	iniForm();
}
function iniForm()
{	
	var MrTypeDr=""
	
	var obj=document.getElementById("MrType");
	if (obj){
				MrTypeDr=obj.value;
		}
		
	var obj=document.getElementById("RuleDic");
	if (obj){
		obj.size=1;
		obj.multiple=false;
        obj.selectedIndex=-1;
	}
	var obj=document.getElementById("ctloc");
	if (obj){
		obj.size=1;
		obj.multiple=false;
        obj.selectedIndex=-1;
	}
	
}
function RuleDic_click()
{
	//alert("as");
  	//var RuleRowid=gGetListData("RuleDic");
}
function Query_click()
{
	/*
	var obj=document.getElementById("mmm");
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var ret=cspRunServerMethod(encmeth,"web.DHCWMRQualityDic","QueryRuleDic");
	b
	if (ret==""){
		
		}
		*/
	 
	var RuleRowid=gGetListData("RuleDic");
	var Ward=gGetListData("ctloc");
	if (RuleRowid=="") return;
	var sExamRule=""
	var obj=document.getElementById("GetRuleByDic");
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var ret=cspRunServerMethod(encmeth,RuleRowid,"Y");
	if (ret==""){
		alert(t['NoExam']);
		return;}
	sExamRule=ret;
	
	var ExamTemp=sExamRule.split(CHR_Up);
	var ExamRuleRowid=ExamTemp[0];
	var obj=document.getElementById("ExamRuleRowid");
	if (obj) {obj.value=ExamRuleRowid;}
	var obj=document.getElementById("Ward");
	if (obj) {obj.value=Ward;}
	var obj=document.getElementById("MrType");
	if (obj) {MrType=obj.value;}
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.RunTimeAdms"+"&MrType=" +MrType+ "&ExamRuleRowid=" +ExamRuleRowid+ "&Ward=" +Ward
	
    parent.RPbottom.location.href=lnk;
     
	//alert(RuleRowid);
	/*
	var MrType="",ItemDr="",DateFrom="",DateTo=""
	
	
	var obj=document.getElementById("MrType");
	if (obj){
		MrType=obj.value;
	}
	var obj=document.getElementById("ItemDr");
	if (obj){
		ItemDr=obj.value;
	}
	var obj=document.getElementById("DateFrom");
	if (obj){
		DateFrom=obj.value;
	}
	var obj=document.getElementById("DateTo");
	if (obj){
		DateTo=obj.value;
	}
		
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.XRecpt.List"+"&MrType=" +MrType+ "&ItemDr=" +ItemDr+ "&DateFrom=" +DateFrom+ "&DateTo=" +DateTo
    parent.RPbottom.location.href=lnk;
    */
}


document.body.onload = BodyLoadHandler;
