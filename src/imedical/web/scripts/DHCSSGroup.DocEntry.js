
function BodyLoadHandler() {
	
	var obj=document.getElementById("Save");
	if (obj) obj.onclick=SaveClickHandler;
	
	InitShow();
}
function InitShow() {
	var GroupID=DHCC_GetElementData("GroupRowId");
	var trClass="web.DHCDocConfig";
	var trMethod="GetConfigNode1"
	//检验检查树权限设置
	var TreeMaintain=tkMakeServerCall(trClass,trMethod,"TreeMaintain",GroupID);
	if (TreeMaintain==1){TreeMaintain=true}else{TreeMaintain=false}
	DHCC_SetElementData("TreeMaintain",TreeMaintain);
	
	//一键打印
	var ClickPrnConfig=tkMakeServerCall(trClass,trMethod,"ClickPrnConfig",GroupID);
	if (ClickPrnConfig==1){ClickPrnConfig=true}else{ClickPrnConfig=false}
	DHCC_SetElementData("ClickPrnConfig",ClickPrnConfig);
	
	//不受就诊有效天数限制
	var NoAdmValidDaysLimit=tkMakeServerCall(trClass,trMethod,"NoAdmValidDaysLimit",GroupID);
	if (NoAdmValidDaysLimit==1){NoAdmValidDaysLimit=true}else{NoAdmValidDaysLimit=false}
	DHCC_SetElementData("NoAdmValidDaysLimit",NoAdmValidDaysLimit);
	
	//医嘱录入不做欠费控制
	var NotDoCheckDeposit=tkMakeServerCall(trClass,trMethod,"NotDoCheckDeposit",GroupID);
	if (NotDoCheckDeposit==1){NotDoCheckDeposit=true}else{NotDoCheckDeposit=false}
	DHCC_SetElementData("NotDoCheckDeposit",NotDoCheckDeposit);
	//补录模式
	var obj=document.getElementById("cSupplementMode");
	if (obj){
		obj.title="禁用部分控制;以下是添加医嘱的控制-0--------------------------\n不允许重复录入的子类\n不允许录入相同通用名的医嘱\n如果是有一天最大量设置的医嘱门诊患者同一次就诊不能出现两条、急诊或住院患者同一天不能出现两条\n存在相同的医嘱?是否确认要增加\n非药品的重复医嘱提示\n重复检验标本提示\n重复当日已开医嘱(门诊)\n住院急诊流观押金控制\n医嘱项提示强制不弹出窗口，走医嘱录入界面上方《提示消息》\n此项目只限在门诊使用；\n医保限制用药；\n受病种诊断限制用药，只能开自费；\n已经开过相同的医嘱且在疗程内,不允许再开；\n特病项目,请在特病处方内开医嘱\n医保适应症提示及控制\n\n以下是点击审核按钮的控制--------------------------\n临床路径检查\n押金不足";
		var SupplementMode=tkMakeServerCall(trClass,trMethod,"SupplementMode",GroupID);
		if (SupplementMode==1){SupplementMode=true}else{SupplementMode=false}
		DHCC_SetElementData("SupplementMode",SupplementMode);
	}
	
}
function SaveClickHandler() {
	var SaveMethod=DHCC_GetElementData("SaveMethod");
	if (SaveMethod=="") { 
		alert("缺少后台调用元素");
		return;
	}
	//检验检查树权限设置
	var NodeName="TreeMaintain";
	var GroupID=DHCC_GetElementData("GroupRowId");
	var TreeMaintain=DHCC_GetElementData("TreeMaintain");
	cspRunServerMethod(SaveMethod,NodeName,GroupID,TreeMaintain);
	
	//一键打印
	var NodeName="ClickPrnConfig";
	var ClickPrnConfig=DHCC_GetElementData("ClickPrnConfig");
	cspRunServerMethod(SaveMethod,NodeName,GroupID,ClickPrnConfig);
	
	//不受就诊有效天数限制
	var NodeName="NoAdmValidDaysLimit";
	var NoAdmValidDaysLimit=DHCC_GetElementData("NoAdmValidDaysLimit");
	cspRunServerMethod(SaveMethod,NodeName,GroupID,NoAdmValidDaysLimit);
	
	//医嘱录入不做欠费控制
	var NodeName="NotDoCheckDeposit";
	var NotDoCheckDeposit=DHCC_GetElementData("NotDoCheckDeposit");
	cspRunServerMethod(SaveMethod,NodeName,GroupID,NotDoCheckDeposit);
	
	//补录模式
	var NodeName="SupplementMode";
	var NotDoCheckDeposit=DHCC_GetElementData("SupplementMode");
	cspRunServerMethod(SaveMethod,NodeName,GroupID,NotDoCheckDeposit);
	alert("保存成功");
	
}

document.body.onload = BodyLoadHandler;;