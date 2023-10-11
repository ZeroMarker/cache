// ---------------------------普通循环包\标牌追溯包\非循环包\低温打印-----------------------------------
// 标牌追溯包、普通循环包、非循环包打印带明细的消毒包
function printout(label, PrintParams) {
	DHCP_GetXMLConfig('InvPrintEncrypt', 'CSSD_PackageLabel');
	var inpara = $.cm({ ClassName: 'web.CSSDHUI.Pack.Package', MethodName: 'GetPrintPackageLabelInfo', label: label, Params: PrintParams, dataType: 'text' }, false);
	var Params = JSON.stringify(addSessionParams({ label: label }));
	var inlist = $.cm({ ClassName: 'web.CSSDHUI.Pack.Package', MethodName: 'GetItms', Params: Params, dataType: 'text' }, false);
	var message = ($.parseJSON(inlist)).msg;
	var ItemList = message.replace(/;/g, String.fromCharCode(2));
	DHC_PrintByLodop(getLodop(), inpara, ItemList, [], '标签打印', { printListByText: true });
	/* $.cm({
		ClassName:"web.CSSDHUI.Pack.Package",
		MethodName:"GetItms",
		Params:Params
	},function(inlist){
		var message=inlist.msg;
		if(inlist.success!=0){
			$UI.msg('alert',message);
			return;
		}
		var ItemList=message.replace(/;/g,String.fromCharCode(2));
		DHC_PrintByLodop(getLodop(),inpara,ItemList,[],"标签打印",{printListByText:true});
	});
	*/
}

// 标牌追溯包、普通循环包、非循环包打印不带器械明细
function printoutnotitm(label, PrintParams) {
	DHCP_GetXMLConfig('InvPrintEncrypt', 'CSSD_PackageLabelNotDetail');
	var inpara = $.cm({ ClassName: 'web.CSSDHUI.Pack.Package', MethodName: 'GetPrintPackageLabelInfo', label: label, Params: PrintParams, dataType: 'text' }, false);
	DHC_PrintByLodop(getLodop(), inpara, '', [], '标签打印', { printListByText: true });
}
// 组合包打印带明细的消毒包
function printoutCompose(label, MainParams) {
	DHCP_GetXMLConfig('InvPrintEncrypt', 'CSSD_PackageLabelNew');
	var inpara = $.cm({ ClassName: 'web.CSSDHUI.Pack.Package', MethodName: 'GetPrintComposeLabelInfo', label: label, Params: MainParams, dataType: 'text' }, false);
	var Params = JSON.stringify(addSessionParams({ label: label }));
	var inlist = $.cm({ ClassName: 'web.CSSDHUI.Pack.Package', MethodName: 'GetComposeItms', Params: Params, dataType: 'text' }, false);
	var message = ($.parseJSON(inlist)).msg;
	var ItemList = message.replace(/;/g, String.fromCharCode(2));
	DHC_PrintByLodop(getLodop(), inpara, ItemList, [], '组合标签打印', { printListByText: true });
	/*
	$.cm({
		ClassName:"web.CSSDHUI.Pack.Package",
		MethodName:"GetComposeItms",
		Params:Params
	},function(inlist){
		var message=inlist.msg;
		if(inlist.success!=0){
			$UI.msg('alert',message);
			return;
		}
		var ItemList=message.replace(/;/g,String.fromCharCode(2));
		DHC_PrintByLodop(getLodop(),inpara,ItemList,[],"组合标签打印",{printListByText:true});
	});
	*/
}

// 标牌追溯包、普通循环包打印多张低温包
function printlower(label, PrintParams) {
	DHCP_GetXMLConfig('InvPrintEncrypt', 'CSSD_PackageLabelLower');
	var inpara = $.cm({ ClassName: 'web.CSSDHUI.Pack.Package', MethodName: 'GetPrintPackageLabelInfo', label: label, Params: PrintParams, dataType: 'text' }, false);
	var Params = JSON.stringify(addSessionParams({ label: label }));
	var inlist = $.cm({ ClassName: 'web.CSSDHUI.Pack.Package', MethodName: 'GetItms', Params: Params, dataType: 'text' }, false);
	var message = ($.parseJSON(inlist)).msg;
	var ItemList = message.replace(/;/g, String.fromCharCode(2));
	DHC_PrintByLodop(getLodop(), inpara, ItemList, [], '低温标签打印', { printListByText: true });
	/*
	$.cm({
		ClassName:"web.CSSDHUI.Pack.Package",
		MethodName:"GetItms",
		Params:Params
	},function(inlist){
		var message=inlist.msg;
		if(inlist.success!=0){
			$UI.msg('alert',message);
			return;
		}
		var ItemList=message.replace(/;/g,String.fromCharCode(2));
		DHC_PrintByLodop(getLodop(),inpara,ItemList,[],"低温标签打印",{printListByText:true});
	});
	*/
}

// ---------------------------消毒打印-----------------------------------
// 消毒类型的包-组合包打印带明细的消毒包
function printoutComposeXD(label, MainParams) {
	DHCP_GetXMLConfig('InvPrintEncrypt', 'CSSD_PackageLabelXD');
	var inpara = $.cm({ ClassName: 'web.CSSDHUI.Pack.Package', MethodName: 'GetPrintComposeLabelInfo', label: label, Params: MainParams, dataType: 'text' }, false);
	var Params = JSON.stringify(addSessionParams({ label: label }));
	var inlist = $.cm({ ClassName: 'web.CSSDHUI.Pack.Package', MethodName: 'GetComposeItms', Params: Params, dataType: 'text' }, false);
	var message = ($.parseJSON(inlist)).msg;
	var ItemList = message.replace(/;/g, String.fromCharCode(2));
	DHC_PrintByLodop(getLodop(), inpara, ItemList, [], '组合消毒类标签打印', { printListByText: true });
	/* $.cm({
		ClassName:"web.CSSDHUI.Pack.Package",
		MethodName:"GetComposeItms",
		Params:Params
	},function(inlist){
		var message=inlist.msg;
		if(inlist.success!=0){
			$UI.msg('alert',message);
			return;
		}
		var ItemList=message.replace(/;/g,String.fromCharCode(2));
		DHC_PrintByLodop(getLodop(),inpara,ItemList,[],"组合消毒类标签打印",{printListByText:true});
	});
	*/
}
// 消毒类型的包 进行的打印
function printoutXD(label, PrintParams) {
	DHCP_GetXMLConfig('InvPrintEncrypt', 'CSSD_PackageLabelXD');
	var inpara = $.cm({ ClassName: 'web.CSSDHUI.Pack.Package', MethodName: 'GetPrintPackageLabelInfo', label: label, Params: PrintParams, dataType: 'text' }, false);
	var Params = JSON.stringify(addSessionParams({ label: label }));
	var inlist = $.cm({ ClassName: 'web.CSSDHUI.Pack.Package', MethodName: 'GetItms', Params: Params, dataType: 'text' }, false);
	var message = ($.parseJSON(inlist)).msg;
	var ItemList = message.replace(/;/g, String.fromCharCode(2));
	DHC_PrintByLodop(getLodop(), inpara, ItemList, [], '消毒类标签打印', { printListByText: true });
	/* $.cm({
		ClassName:"web.CSSDHUI.Pack.Package",
		MethodName:"GetItms",
		Params:Params
	},function(inlist){
		var message=inlist.msg;
		if(inlist.success!=0){
			$UI.msg('alert',message);
			return;
		}
		var ItemList=message.replace(/;/g,String.fromCharCode(2));
		DHC_PrintByLodop(getLodop(),inpara,ItemList,[],"消毒类标签打印",{printListByText:true});
	});
	*/
}

// ---------------------------外来器械打印-----------------------------------
// 外来器械打印带明细
function printExt(label, MainParams) {
	DHCP_GetXMLConfig('InvPrintEncrypt', 'CSSD_PackageLabelExtDetail');
	var inpara = $.cm({ ClassName: 'web.CSSDHUI.Pack.Package', MethodName: 'GetPrintExtPackageLabelInfo', label: label, Params: MainParams, dataType: 'text' }, false);
	var Params = JSON.stringify(addSessionParams({ label: label }));
	var inlist = $.cm({ ClassName: 'web.CSSDHUI.Pack.Package', MethodName: 'GetExtItms', Params: Params, dataType: 'text' }, false);
	var message = ($.parseJSON(inlist)).msg;
	var ItemList = message.replace(/;/g, String.fromCharCode(2));
	DHC_PrintByLodop(getLodop(), inpara, ItemList, [], '外来器械标签打印', { printListByText: true });
	/* $.cm({
		ClassName:"web.CSSDHUI.Pack.Package",
		MethodName:"GetExtItms",
		Params:Params
	},function(inlist){
		var message=inlist.msg;
		if(inlist.success!=0){
			$UI.msg('alert',message);
			return;
		}
		var ItemList=message.replace(/;/g,String.fromCharCode(2));
		DHC_PrintByLodop(getLodop(),inpara,ItemList,[],"外来器械标签打印",{printListByText:true});
	});*/
}

// 外来器械打印-不带明细
function printExtNotDetail(label, MainParams) {
	DHCP_GetXMLConfig('InvPrintEncrypt', 'CSSD_PackageLabelExt');
	var inpara = $.cm({ ClassName: 'web.CSSDHUI.Pack.Package', MethodName: 'GetPrintExtPackageLabelInfo', label: label, Params: MainParams, dataType: 'text' }, false);
	DHC_PrintByLodop(getLodop(), inpara, '', [], '外来器械标签无明细打印', { printListByText: true });
}

// ---------------------------标牌编码打印-----------------------------------
// 标牌编码打印
function printCodeDict(label, name, stertype, ItemCount) {
	DHCP_GetXMLConfig('InvPrintEncrypt', 'CSSD_CodeLabel');
	var inpara = 'label' + String.fromCharCode(2) + label
		+ '^name' + String.fromCharCode(2) + name
		+ '^ItemCount' + String.fromCharCode(2) + ItemCount
		+ '^stertype' + String.fromCharCode(2) + stertype;
	DHC_PrintByLodop(getLodop(), inpara, '', [], '标签打印', { printListByText: true });
}
// 标牌编码打印-打印明细
function printitmByCodeDict(label, CodeDictName, stertype, ItemCount) {
	DHCP_GetXMLConfig('InvPrintEncrypt', 'CSSD_CodeDictItem');
	var inpara = 'label' + String.fromCharCode(2) + label
		+ '^CodeDictName' + String.fromCharCode(2) + CodeDictName
		+ '^ItemCount' + String.fromCharCode(2) + ItemCount
		+ '^stertype' + String.fromCharCode(2) + stertype;
	var Params = JSON.stringify(addSessionParams({ label: label }));
	var inlist = $.cm({ ClassName: 'web.CSSDHUI.Pack.Package', MethodName: 'GetItmsByCode', Params: Params, dataType: 'text' }, false);
	var message = ($.parseJSON(inlist)).msg;
	var msg = message.replace(/;/g, String.fromCharCode(2));
	DHC_PrintByLodop(getLodop(), inpara, msg, [], '标牌编码明细打印', { printListByText: true });
	/* $.cm({
		ClassName:"web.CSSDHUI.Pack.Package",
		MethodName:"GetItmsByCode",
		Params:Params
	},function(inlist){
		var message=inlist.msg;
		if(inlist.success!=0){
			$UI.msg('alert',message);
			return;
		}
		var msg=message.replace(/;/g,String.fromCharCode(2));
		DHC_PrintByLodop(getLodop(),inpara,msg,[],"标牌编码明细打印",{printListByText:true});
	});
	*/
}

// ---------------------------灭菌信息打印-----------------------------------
// 打印灭菌信息
function printSterPotInfo(SterName, SterDateTime, SterNo, SterPackageNum, CheckType, IsBioLabel, IsCheLabel, IsPhyLabel) {
	DHCP_GetXMLConfig('InvPrintEncrypt', 'CSSD_PrintSterPotInfo');
	var inpara = 'SterName' + String.fromCharCode(2) + SterName
		+ '^SterDateTime' + String.fromCharCode(2) + SterDateTime
		+ '^SterNo' + String.fromCharCode(2) + SterNo
		+ '^SterPackageNum' + String.fromCharCode(2) + SterPackageNum
		+ '^CheckType' + String.fromCharCode(2) + CheckType
		+ '^IsBioLabel' + String.fromCharCode(2) + IsBioLabel
		+ '^IsCheLabel' + String.fromCharCode(2) + IsCheLabel
		+ '^IsPhyLabel' + String.fromCharCode(2) + IsPhyLabel;
	DHC_PrintByLodop(getLodop(), inpara, '', [], '灭菌信息打印', { printListByText: true });
}

// 外来器械患者信息打印
function printInfo(InstruName, InstruCode, ExtLocDesc, RecNum, SickerName, BedNo, HospitalNo, UseDate) {
	DHCP_GetXMLConfig('InvPrintEncrypt', 'CSSD_ForeignDeviceInfo');
	var inpara = 'InstruName' + String.fromCharCode(2) + InstruName
		+ '^InstruCode' + String.fromCharCode(2) + InstruCode
		+ '^ExtLocDesc' + String.fromCharCode(2) + ExtLocDesc
		+ '^RecNum' + String.fromCharCode(2) + RecNum
		+ '^SickerName' + String.fromCharCode(2) + SickerName
		+ '^BedNo' + String.fromCharCode(2) + BedNo
		+ '^HospitalNo' + String.fromCharCode(2) + HospitalNo
		+ '^UseDate' + String.fromCharCode(2) + UseDate;
	DHC_PrintByLodop(getLodop(), inpara, '', [], '外来器械患者信息打印', { printListByText: true });
}