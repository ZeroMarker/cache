// dhccpw.mr.opformcontrast.csp	style="border:1px solid blue;height:40%"
function InitMainViewport() {
	//alert(ImplNewID+":"+FuncSign+":"+ContrastMode); return;
	var UserType = "";
	if (ContrastMode) { UserType = ContrastMode.substring(0, 1); }
	if (UserType!="D" && UserType!="N") { return; }
	if (!ImplNewID) { return; }
	var objInterfaceOP = ExtTool.StaticServerObject("web.DHCCPW.OPCPW.InterfaceOP");
	var CHR_1 = String.fromCharCode(1);
	var CHR_2 = String.fromCharCode(2);
	var CHR_ER = String.fromCharCode(13)+String.fromCharCode(10);
	
	var obj = new Object();
	
	obj.exeContrastPanel = new Ext.Panel({
		id : 'exeContrastPanel'
		,region : 'center'
		,layout : 'fit'
		,frame : false
		,title : '医嘱对照'
	});
	
	obj.canContrastPanel = new Ext.Panel({
		id : 'canContrastPanel'
		,region : 'center'
		,layout : 'fit'
		,frame : false
		,autoScroll : true
		,title : '已对照医嘱'
	});
	
	obj.exeContrastPanel.setVisible(true);
	obj.canContrastPanel.setVisible(false);
	
	obj.ContrastViewport = new Ext.Viewport({
		id : 'ContrastViewport'
		,layout : 'fit'
		,items : [ obj.exeContrastPanel, obj.canContrastPanel ]
	});
	
	var ViewHeight = obj.ContrastViewport.getHeight();
	var RowHeight = 30;
	var DivHeight = ViewHeight - RowHeight - 27;
	
	obj.exeContrastHTML = ''
	 +	'<div id="OrderItem" style="height:'+DivHeight+'px;width:50%;overflow-y:auto;float:left;clear:left;border-right:2px solid #899bb3"></div>'
	 +	'<div id="StepItem" style="height:'+DivHeight+'px;width:50%;overflow-y:auto;float:right;clear:right;border-left:2px solid #899bb3"></div>'
	 +	'<table width="100%" height="'+RowHeight+'px" class="diytd3th" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>'
	 +		'<td width="50%"><input type="button" id="btnExeCont" value="关联"></td>'
	 +		'<td width="50%"><input type="button" id="canContPanel" value="已对照"></td>'
	 +	'</tr></table>'
	 +	'';
	
	obj.canContrastHTML = ''
	 +	'<table width="100%" height="'+RowHeight+'px" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>'
	 +		'<td class="diytd4th" width="10%">选择</td>'
	 +		'<td class="diytd4th" width="30%">对照医嘱</td>'
	 +		'<td class="diytd4th" width="20%">对照人</td>'
	 +		'<td class="diytd4th" width="20%">对照日期</td>'
	 +		'<td class="diytd4th" width="20%">对照时间</td>'
	 +	'</tr></table>'
	 +	'<div id="ContItem" style="height:'+(DivHeight-RowHeight)+'px;width:100%"></div>'
	 +	'<table width="100%" height="'+RowHeight+'px" class="diytd3th" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>'
	 +		'<td width="50%"><input type="button" id="btnCanCont" value="撤销"></td>'
	 +		'<td width="50%"><input type="button" id="exeContPanel" value="对照"></td>'
	 +	'</tr></table>'
	 +	'';
	
	Ext.getCmp("exeContrastPanel").body.update(obj.exeContrastHTML);
	Ext.getCmp("canContrastPanel").body.update(obj.canContrastHTML);
	
	var OrderItemXTemplate = new Ext.XTemplate(
		'<table width="100%" height="'+RowHeight+'px" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>',
			'<td width="10%" class="diytd4th">选择</td>',
			'<td width="90%" class="diytd4th">医嘱名称</td>',
		'</tr></table>',
		'<tpl for=".">',
			'<table width="100%" height="'+RowHeight+'px" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>',
				'<td width="10%" class="diytd4"><input type="checkbox" id={ArcimID} name="ORDER_ITM" value={OEItemID}></td>',
				'<td width="90%" class="diytd5">{ArcimDesc}</td>',
			'</tr></table>',
		'</tpl>',
		{
			compiled : true
			,disableFormats : true
		}
	);
	
	var StepItemXTemplate = new Ext.XTemplate(
		'<table width="100%" height="'+RowHeight+'px" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>',
			'<td width="10%" class="diytd4th">选择</td>',
			'<td width="70%" class="diytd4th">项目名称</td>',
			'<td width="20%" class="diytd4th">项目类型</td>',
		'</tr></table>',
		'<tpl for="ImplData">',
			'<table width="100%" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>',
				'<td width="10%" height="'+RowHeight+'px" class="diytd4">',
					'<input type="checkbox" id={ItemRowid} name="STEP_ITM"></td>',
				'<td width="70%" height="'+RowHeight+'px" class="diytd5',
					'<tpl if="this.isOptional(ItemOptional)"> diyfont1</tpl>',
				'">{ItemDesc}</td>',
				'<td width="20%" height="'+RowHeight+'px" class="diytd5">{SubCatDesc}</td>',
			'</tr></table>',
			'<table width="100%" class="diytd5" cellspacing="0" cellpadding="0" border="0" rules="cols">',
				'<tpl for="ImplDtl"><tr>',
					'<td width="20%" height="'+RowHeight+'px"></td>',
					'<td width="80%" height="'+RowHeight+'px">{ArcimDesc}</td>',
				'</tr></tpl>',
			'</table>',
		'</tpl>',
		{
			compiled : true
			,disableFormats : true
			,isOptional : function(ItemOptional) { return ItemOptional=="1"; }
		}
	);
	
	var ContItemXTemplate = new Ext.XTemplate(
		'<tpl for="ContData">',
			'<table width="100%" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>',
				'<td width="100%" height="'+RowHeight+'px" class="diytd3th',
					'<tpl if="this.isOptional(ItemOptional)"> diyfont1</tpl>',
				'">[{SubCatDesc}] {StepItemDesc}</td>',
			'</tr></table>',
			'<tpl for="ContDtl">',
				'<table width="100%" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>',
					'<td width="10%" height="'+RowHeight+'px" class="diytd4">',
						'<input type="checkbox" id="{ContrastID}" name="CONT_ITM"></td>',
					'<td width="30%" height="'+RowHeight+'px" class="diytd5">{ContItemDesc}</td>',
					'<td width="20%" height="'+RowHeight+'px" class="diytd5">{ContUser}</td>',
					'<td width="20%" height="'+RowHeight+'px" class="diytd5">{ContDate}</td>',
					'<td width="20%" height="'+RowHeight+'px" class="diytd5">{ContTime}</td>',
				'</tr></table>',
			'</tpl>',
		'</tpl>',
		{
			compiled : true
			,disableFormats : true
			,isOptional : function(ItemOptional) { return ItemOptional=="1"; }
		}
	);
	
	function buildXTemplateObj(Str) {
		var objData = Ext.decode(Str);
		var arrayData = new Array();
		var objItm = null;
		for (var i=0; i<objData.total; i++) {
			objItm = objData.record[i];
			arrayData[arrayData.length] = objItm;
		}
		return arrayData;
	}
	
	function buildStepItemObj(Str) {
		var objData = Ext.decode(Str);
		var arrayData = new Array();
		var objItm = null, ImplStr = "";
		for (var i=0; i<objData.total; i++) {
			objItm = objData.record[i];
			arrayData[arrayData.length] = objItm;
			ImplStr = ImplStr + "{'ItemRowid':'" + objItm.ItemRowid;
			ImplStr = ImplStr + "','ItemDesc':'" + objItm.ItemDesc;
			ImplStr = ImplStr + "','SubCatDesc':'" + objItm.SubCatDesc;
			ImplStr = ImplStr + "','ItemOptional':'" + objItm.ItemOptional;
			ImplStr = ImplStr + "','ImplDtl':[";
			var ImplDtl = objItm.ImplDtl, DtlStr = "";
			ImplDtl = ImplDtl.split(CHR_1);
			for (var j=0; j<ImplDtl.length; j++) {
				var tmpDtl = ImplDtl[j];
				if (tmpDtl=="") { continue; }
				DtlStr = DtlStr + "{'ArcimDesc':'" + tmpDtl.split("^")[1] + "'},";
			}
			DtlStr = DtlStr.substring(0, DtlStr.length-1);
			ImplStr = ImplStr + DtlStr + "]},";
		}
		ImplStr = ImplStr.substring(0, ImplStr.length-1);
		ImplStr = "{ImplData:[" + ImplStr + "]}";
		var ImplData = Ext.decode(ImplStr);
		return ImplData;
	}
	
	function buildContItemObj(Str) {
		var objData = Ext.decode(Str);
		var arraygroup = new Array(), ind = 0, tmpgroup = "";
		for (var i=0; i<objData.total; i++) {
			if (tmpgroup.indexOf(objData.record[i].StepItemDesc)<0) {
				tmpgroup = tmpgroup + objData.record[i].StepItemDesc + ",";
				arraygroup[ind] = objData.record[i].StepItemDesc + "^" + objData.record[i].SubCatDesc + "^" + objData.record[i].ItemOptional;
				ind = ind + 1;
			}
		}
		var dataStr = "", groupStr = "";
		for (var j=0; j<arraygroup.length; j++) {
			groupStr = groupStr + "{'StepItemDesc':'" + arraygroup[j].split("^")[0];
			groupStr = groupStr + "','SubCatDesc':'" + arraygroup[j].split("^")[1];
			groupStr = groupStr + "','ItemOptional':'" + arraygroup[j].split("^")[2] + "','ContDtl':[";
			var itemStr = "";
			for (var k=0; k<objData.total; k++) {
				if (arraygroup[j].split("^")[0]==objData.record[k].StepItemDesc) {
					itemStr = itemStr + "{'ContrastID':'" + objData.record[k].ContrastID;
					itemStr = itemStr + "','ContItemDesc':'" + objData.record[k].ContItemDesc;
					itemStr = itemStr + "','ContUser':'" + objData.record[k].ContUser;
					itemStr = itemStr + "','ContDate':'" + objData.record[k].ContDate;
					itemStr = itemStr + "','ContTime':'" + objData.record[k].ContTime+"'},";
				}
			}
			itemStr = itemStr.substring(0, itemStr.length-1);
			groupStr = groupStr + itemStr+"]},";
		}
		groupStr = groupStr.substring(0, groupStr.length-1);
		dataStr = "{ContData:[" + groupStr + "]}";
		var ContData = Ext.decode(dataStr);
		return ContData;
	}
	
	obj.RenderOrderItem = function(TargetElement, ImplNewID, UserType) {
		var objTargetElement = document.getElementById(TargetElement);
		if (!objTargetElement) { return; }
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL
			,method : 'POST'
			,params : {
				ClassName : 'web.DHCCPW.OPCPW.FormShowOP',
				QueryName : 'QryVarOrder',
				Arg1 : ImplNewID,
				Arg2 : UserType,
				ArgCnt : 2
			}
			,success : function(response, opts) {
				var Data = buildXTemplateObj(response.responseText);
				OrderItemXTemplate.overwrite(TargetElement, Data);
				chkOrderItemDisabled(FuncSign);
			}
			,failure : function(response, opts) { objTargetElement.innerHTML = response.responseText; }
		});
	}
	
	obj.RenderStepItem = function(TargetElement, ImplNewID, Flag) {
		var objTargetElement = document.getElementById(TargetElement);
		if (!objTargetElement) { return; }
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL
			,method : 'POST'
			,params : {
				ClassName : 'web.DHCCPW.OPCPW.FormShowOP',
				QueryName : 'QryEpStepItems',
				Arg1 : ImplNewID,
				Arg2 : Flag,
				ArgCnt : 2
			}
			,success : function(response, opts) {
				var Data = buildStepItemObj(response.responseText);
				StepItemXTemplate.overwrite(TargetElement, Data);
				chkStepItemDisabled(FuncSign);
				StepItemSelect();
			}
			,failure : function(response, opts) { objTargetElement.innerHTML = response.responseText; }
		});
	}
	
	obj.RenderContItem = function(TargetElement, ImplNewID) {
		var objTargetElement = document.getElementById(TargetElement);
		if (!objTargetElement) { return; }
		var ImplNewStr = objInterfaceOP.GetStringByImplNewID(ImplNewID);
		var EpStepID = ImplNewStr.split("^")[1];
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL
			,method : 'POST'
			,params : {
				ClassName : 'web.DHCCPW.OPCPW.FormShowOP',
				QueryName : 'QryContrastByEpStepID',
				Arg1 : EpStepID,
				Arg2 : "Y",
				ArgCnt : 2
			}
			,success : function(response, opts) {
				var Data = buildContItemObj(response.responseText);
				ContItemXTemplate.overwrite(TargetElement, Data);
				chkContItemDisabled(FuncSign);
			}
			,failure : function(response, opts) { objTargetElement.innerHTML = response.responseText; }
		});
	}
	
	obj.exeContrastPanel.setDisabled(true);
	obj.canContrastPanel.setDisabled(true);
	obj.RenderOrderItem("OrderItem", ImplNewID, UserType);
	obj.RenderStepItem("StepItem", ImplNewID, "02");
	obj.RenderContItem("ContItem", ImplNewID);
	var exeContPanel = document.getElementById("exeContPanel");
	if (exeContPanel) {
		exeContPanel.onclick = function() { exeContLink(); }
	}
	var canContPanel = document.getElementById("canContPanel");
	if (canContPanel) {
		canContPanel.onclick = function() { canContLink(); }
	}
	var btnExeCont = document.getElementById("btnExeCont");
	if (btnExeCont) {
		btnExeCont.disabled = FuncSign;
		btnExeCont.onclick = function() { exeContClick(); }
	}
	var btnCanCont = document.getElementById("btnCanCont");
	if (btnCanCont) {
		btnCanCont.disabled = FuncSign;
		btnCanCont.onclick = function() { canContClick(); }
	}
	obj.exeContrastPanel.setDisabled(false);
	obj.canContrastPanel.setDisabled(false);
	
	function StepItemSelect() {
		var objStepItem = document.getElementsByName("STEP_ITM");
		for (i=0; i<objStepItem.length; i++) {
			objStepItem[i].onclick = function() {
				for (j=0; j<objStepItem.length; j++) {
					if (this.id!=objStepItem[j].id) {
						objStepItem[j].checked = false;
					}
				}
			}
		}
	}
	
	function chkOrderItemDisabled(check) {
		var objOrderItm = document.getElementsByName("ORDER_ITM");
		for (var i=0; i<objOrderItm.length; i++) {
			if (objOrderItm[i]) { objOrderItm[i].disabled = check; }
		}
	}
	
	function chkStepItemDisabled(check) {
		var objStepItm = document.getElementsByName("STEP_ITM");
		for (var i=0; i<objStepItm.length; i++) {
			if (objStepItm[i]) { objStepItm[i].disabled = check; }
		}
	}
	
	function chkContItemDisabled(check) {
		var objContItm = document.getElementsByName("CONT_ITM");
		for (var i=0; i<objContItm.length; i++) {
			if (objContItm[i]) { objContItm[i].disabled = check; }
		}
	}
	
	function exeContLink() { //exeContPanel
		obj.RenderOrderItem("OrderItem", ImplNewID, UserType);
		obj.RenderStepItem("StepItem", ImplNewID, "02");
		obj.exeContrastPanel.setVisible(true);
		obj.canContrastPanel.setVisible(false);
	}
	
	function canContLink() { //canContPanel
		obj.RenderContItem("ContItem", ImplNewID);
		obj.exeContrastPanel.setVisible(false);
		obj.canContrastPanel.setVisible(true);
	}
	
	function exeContClick() { //btnExeCont
		var objOrderItm = document.getElementsByName("ORDER_ITM");
		var objStepItm = document.getElementsByName("STEP_ITM");
		var SelOrderItm = "", SelStepItm = "";
		for (var i=0; i<objOrderItm.length; i++) {
			if (objOrderItm[i].checked) { SelOrderItm = SelOrderItm + objOrderItm[i].id + ","; }
		}
		if (SelOrderItm=="") { ExtTool.alert("提示", "请选择关联医嘱！"); return; }
		for (var j=0; j<objStepItm.length; j++) {
			if (objStepItm[j].checked) { SelStepItm = objStepItm[j].id.split("-")[0]; }
		}
		if (SelStepItm=="") { ExtTool.alert("提示", "请选择关联项目！"); return; }
		for (var k=0; k<objOrderItm.length; k++) {
			var inputStr = "";
			if (objOrderItm[k].checked) {
				inputStr = inputStr + "^" + SelStepItm.split("||")[0];
				inputStr = inputStr + "^" + SelStepItm.split("||")[0] + "||" + SelStepItm.split("||")[1] + "||" + SelStepItm.split("||")[2];
				inputStr = inputStr + "^" + SelStepItm;
				inputStr = inputStr + "^" + objOrderItm[k].id;
				inputStr = inputStr + "^" + "Y";
				inputStr = inputStr + "^" + session['LOGON.USERID'];
				inputStr = inputStr + "^" + "";	// Date
				inputStr = inputStr + "^" + "";	// Time
				var ret1 = objInterfaceOP.UpdateContrast(inputStr);
				var ImplementStr = objInterfaceOP.BuildImplStr(objOrderItm[k].value, SelStepItm, ImplNewID, session['LOGON.USERID']);
				var objImplement = ExtTool.StaticServerObject("web.DHCCPW.MR.Implement");
				var ret2 = objImplement.InsertImpl(ImplementStr);
				if (ret1<0 || ret2<0) { ExtTool.alert("提示", "关联失败！"); return; }
			}
		}
		obj.RenderOrderItem("OrderItem", ImplNewID, UserType);
		obj.RenderStepItem("StepItem", ImplNewID, "02");
		if (typeof(window.parent.objControlArry)['FormNewWin'].RenderEpStepItems=="function") {
			window.parent.objControlArry['FormNewWin'].RenderEpStepItems('divOrder', ImplNewID, '02');
		}
	}
	
	function canContClick() { //btnCanCont
		var objContItm = document.getElementsByName("CONT_ITM");
		var SelContItm = "", inputStr = "";
		for (var i=0; i<objContItm.length; i++) {
			if (objContItm[i].checked) { SelContItm = SelContItm + objContItm[i].id + ","; }
		}
		if (SelContItm=="") { ExtTool.alert("提示", "请选择撤销的项目！"); return; }
		for (var j=0; j<objContItm.length; j++) {
			if (objContItm[j].checked) {
				inputStr = objContItm[j].id + "^" + session['LOGON.USERID'];
				var ret = objInterfaceOP.UpdoContrast(inputStr);
				if (ret<0) { ExtTool.alert("提示", "撤销失败！"); return; }
			}
		}
		obj.RenderContItem("ContItem", ImplNewID);
	}
	
	return obj;
}
