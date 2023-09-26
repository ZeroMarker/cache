// dhccpw.mr.opformvariance.csp
function InitMainViewport() {
	//alert(ImplNewID+":"+FuncSign+":"+VarianceMode);
	var objInterfaceOP = ExtTool.StaticServerObject("web.DHCCPW.OPCPW.InterfaceOP");
	var ImplNewStr = objInterfaceOP.GetStringByImplNewID(ImplNewID);
	var EpisodeID = "", EpStepID = "", UserType = "";
	if (ImplNewStr) {
		EpisodeID = ImplNewStr.split("^")[3];
		EpStepID = ImplNewStr.split("^")[1];
	}
	if (VarianceMode) { UserType = VarianceMode.substring(0, 1); }
	if (UserType!="D" && UserType!="N") { return; }
	if (!ImplNewID || !EpisodeID || !EpStepID) { return; }
	var objClinPathWaysVariance = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWaysVariance");
	var CHR_1 = String.fromCharCode(1);
	var CHR_2 = String.fromCharCode(2);
	var CHR_ER = String.fromCharCode(13)+String.fromCharCode(10);
	
	var obj = new Object();
	
	obj.VariancePanel = new Ext.Panel({
		id : 'VariancePanel'
		,region : 'center'
		,layout : 'fit'
		,frame : false
		,autoScroll : true
		,title : '病情变异记录'
	});
	
	obj.VarianceViewport = new Ext.Viewport({
		id : 'VarianceViewport'
		,layout : 'fit'
		,items : [ obj.VariancePanel ]
	});
	
	var ViewHeight = obj.VarianceViewport.getHeight();
	var RowHeight = 30;
	var DivHeight = (ViewHeight - RowHeight * 5 - 27)/2;
	if (DivHeight.toString().indexOf(".")>0) { DivHeight = parseInt(DivHeight); }
	
	obj.VarianceHTML = ''
	 +	'<table width="100%" height="'+RowHeight+'px" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>'
	 +		'<td width="10%" class="diytd4th">选择</td>'
	 +		'<td width="90%" class="diytd4th">变异项目</td>'
	 +	'</tr></table>'
	 +	'<div id="exeVariance" style="height:'+(DivHeight+1)+'px"></div>'
	 +	'<table width="100%" height="'+RowHeight+'px" class="diytd3th" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>'
	 +		'<td width="10%" align="center">原因分类:</td>'
	 +		'<td width="40%" align="center"><div id="varcbo1"></div></td>'
	 +		'<td width="10%" align="center">变异原因:</td>'
	 +		'<td width="40%" align="center"><div id="varcbo2"></div></td>'
	 +	'</tr></table>'
	 +	'<table width="100%" height="'+RowHeight+'px" class="diytd3th" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>'
	 +		'<td width="10%" align="center">原因备注:</td>'
	 +		'<td width="70%" align="center"><div id="vartxt"></div></td>'
	 +		'<td width="20%" align="center"><input type="button" id="btnExeVar" value="执行"></td>'
	 +	'</tr></table>'
	 +	'<table width="100%" height="'+RowHeight+'px" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>'
	 +		'<td width="10%" class="diytd4th"><input type="checkbox" id="VARITEM_All"></td>'
	 +		'<td width="90%" class="diytd4th">病情变异记录</td>'
	 +	'</tr></table>'
	 +	'<div id="canVariance" style="height:'+DivHeight+'px"></div>'
	 +	'<table width="100%" height="'+RowHeight+'px" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>'
	 +		'<td width="100%" class="diytd3th"><input type="button" id="btnCanVar" value="撤销"></td>'
	 +	'</tr></table>'
	 +	'';
	
	Ext.getCmp("VariancePanel").body.update(obj.VarianceHTML);
	
	obj.cboVarCategStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboVarCategStore = new Ext.data.Store({
		proxy : obj.cboVarCategStoreProxy,
		reader : new Ext.data.JsonReader({
			root : 'record',
			totalProperty : 'total',
			idProperty : 'Rowid'
		},
		[
			 { name : 'checked', mapping : 'checked' }
			,{ name : 'Rowid', mapping : 'Rowid' }
			,{ name : 'Code', mapping : 'Code' }
			,{ name : 'Desc', mapping : 'Desc' }
		])
	});
	obj.cboVarCateg = new Ext.form.ComboBox({
		width : 240
		,displayField : 'Desc'
		,minChars : 1
		//,fieldLabel : '原因分类'
		,store : obj.cboVarCategStore
		,editable : false
		,triggerAction : 'all'
		,anchor : '100%'
		,valueField : 'Rowid'
		,renderTo : 'varcbo1'
		,listeners : {
			'select' : function() {
				obj.cboVarReason.setValue('');
				obj.cboVarReasonStore.load({});
			}
		}
	});
	obj.cboVarCategStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'web.DHCCPW.MRC.VarianceCategory';
		param.QueryName = 'QryVarCateg';
		param.Arg1 = "V";
		param.ArgCnt = 1;
	});
	
	obj.cboVarReasonStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboVarReasonStore = new Ext.data.Store({
		proxy : obj.cboVarReasonStoreProxy,
		reader : new Ext.data.JsonReader({
			root : 'record',
			totalProperty : 'total',
			idProperty : 'Rowid'
		},
		[
			 { name : 'checked', mapping : 'checked' }
			,{ name : 'Rowid', mapping : 'Rowid' }
			,{ name : 'Code', mapping : 'Code' }
			,{ name : 'Desc', mapping : 'Desc' }
		])
	});
	obj.cboVarReason = new Ext.form.ComboBox({
		width : 240
		,displayField : 'Desc'
		,minChars : 1
		//,fieldLabel : '变异原因'
		,store : obj.cboVarReasonStore
		,editable : false
		,triggerAction : 'all'
		,anchor : '100%'
		,valueField : 'Rowid'
		,renderTo : 'varcbo2'
	});
	obj.cboVarReasonStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'web.DHCCPW.MRC.VarianceReason';
		param.QueryName = 'QryVarReasonNew';
		param.Arg1 = obj.cboVarCateg.getValue();
		param.ArgCnt = 1;
	});
	
	obj.txtVarResume = new Ext.form.TextField({
		width : 500
		//,fieldLable : '原因备注'
		,anchor : '100%'
		,renderTo : 'vartxt'
	});
	
	var ExeVarXTemplate = new Ext.XTemplate(
		'<tpl for="VarData">',
			'<table width="100%" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>',
				'<td width="10%" height="'+RowHeight+'px" class="diytd3th">',
					'<input type="checkbox" id="{groupcheckbox}"></td>',
				'<td width="90%" height="'+RowHeight+'px" class="diytd3th">{VarItemGroup}</td>',
			'</tr></table>',
			'<tpl for="gruopItems">',
				'<table width="100%" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>',
					'<td width="10%" height="'+RowHeight+'px" class="diytd4">',
						'<input type="checkbox" id="{VarItemCode}" name="{itemcheckbox}"></td>',
					'<td width="90%" height="'+RowHeight+'px" class="diytd5">{VarItemDesc}</td>',
				'</tr></table>',
			'</tpl>',
		'</tpl>',
		{
			compiled : true
			,disableFormats : true
		}
	);
	
	var CanVarXTemplate = new Ext.XTemplate(
		'<tpl for="VarData">',
			'<table width="100%" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>',
				'<td width="10%" height="'+RowHeight+'px" class="diytd4">',
					'<input type="checkbox" id="{VarRowID}" name="VARITEM_ITM"></td>',
				'<td width="90%" height="'+RowHeight+'px" class="diytd5">{VarNum}、{VarDesc}</td>',
			'</tr></table>',
			'<table width="100%" class="diytd5" cellspacing="0" cellpadding="0" border="0" rules="cols">',
				'<tpl for="VarExtra"><tr>',
					'<td width="15%" height="'+RowHeight+'px" class=""></td>',
					'<td width="85%" height="'+RowHeight+'px" class="">{ExtraDesc}</td>',
				'</tr></tpl>',
			'</table>',
		'</tpl>',
		{
			compiled : true
			,disableFormats : true
		}
	);
	
	function buildExeVarObj(Str) {
		var objData = Ext.decode(Str);
		var arraygroup = new Array(), ind = 0, tmpgroup = "";
		for (var i=0; i<objData.total; i++) {
			if (tmpgroup.indexOf(objData.record[i].VarItemGroup)<0) {
				tmpgroup = tmpgroup + objData.record[i].VarItemGroup + ",";
				arraygroup[ind] = objData.record[i].VarItemGroup;
				ind = ind + 1;
			}
		}
		var dataStr = "", groupStr = "";
		for (var j=0; j<arraygroup.length; j++) {
			var groupcheckbox = "NULL_All", itemcheckbox = "NULL_ITM";
			if (arraygroup[j]=="步骤时间调整") {
				groupcheckbox = "STEPTIME_All";
				itemcheckbox = "STEPTIME_ITM";
			} else if (arraygroup[j]=="表单外医嘱") {
				groupcheckbox = "OEITEM_All";
				itemcheckbox = "OEITEM_ITM";
			} else if (arraygroup[j]=="必选项目未执行") {
				groupcheckbox = "CPWITEM_B_ALL";
				itemcheckbox = "CPWITEM_B_ITM";
			} else if (arraygroup[j]=="可选项目已执行") {
				groupcheckbox = "CPWITEM_K_All";
				itemcheckbox = "CPWITEM_K_ITM";
			}
			groupStr = groupStr + "{'VarItemGroup':'"+arraygroup[j];
			groupStr = groupStr + "','groupcheckbox':'"+groupcheckbox+"','gruopItems':[";
			var itemStr = "";
			for (var k=0; k<objData.total; k++) {
				if (arraygroup[j]==objData.record[k].VarItemGroup) {
					itemStr = itemStr + "{'VarItemCode':'"+objData.record[k].VarItemCode;
					var VarItemDesc = objData.record[k].VarItemDesc.replace(CHR_1, "");
					itemStr = itemStr + "','VarItemDesc':'"+VarItemDesc;
					itemStr = itemStr + "','itemcheckbox':'"+itemcheckbox+"'},";
				}
			}
			itemStr = itemStr.substring(0, itemStr.length-1);
			groupStr = groupStr + itemStr+"]},";
		}
		groupStr = groupStr.substring(0, groupStr.length-1);
		dataStr = "{VarData:["+groupStr+"]}";
		var ExeVarData = Ext.decode(dataStr);
		return ExeVarData;
	}
	
	function buildCanVarObj(Str) {
		var objData = Ext.decode(Str);
		var data = "", vargroup = "";
		for (var i=0; i<objData.total; i++) {
			vargroup = vargroup + "{'VarRowID':'" + objData.record[i].VarRowID + "',";
			vargroup = vargroup + "'VarNum':'" + objData.record[i].VarNum + "',";
			vargroup = vargroup + "'VarDesc':'" + objData.record[i].VarDesc + "',";
			vargroup = vargroup + "'VarExtra':[";
			var tmpVarExtra = objData.record[i].ExtraDesc;
			tmpVarExtra = tmpVarExtra.substring(0, tmpVarExtra.length-1);
			var arrayExtra = tmpVarExtra.split(",");
			var varitem = "";
			for (var j=0; j<arrayExtra.length; j++) {
				if (arrayExtra[j]=="") { continue; }
				varitem = varitem + "{'ExtraDesc':'" + arrayExtra[j] + "'},";
			}
			varitem = varitem.substring(0, varitem.length-1);
			vargroup = vargroup + varitem + "]},";
		}
		vargroup = vargroup.substring(0, vargroup.length-1);
		data = data + "{VarData:[" + vargroup + "]}";
		var CanVarData = Ext.decode(data);
		return CanVarData;
	}
	
	obj.RenderExeVariance = function(TargetElement, ImplNewID, UserType) {
		var objTargetElement = document.getElementById(TargetElement);
		if (!objTargetElement) { return; }
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL
			,method : 'POST'
			,params : {
				ClassName : 'web.DHCCPW.OPCPW.FormShowOP',
				QueryName : 'QryVarItemListOP',
				Arg1 : ImplNewID,
				Arg2 : UserType,
				ArgCnt : 2
			}
			,success : function(response, opts) {
				var Data = buildExeVarObj(response.responseText);
				ExeVarXTemplate.overwrite(TargetElement, Data);
				ExeVarDisabled(FuncSign);
				ExeVarSelectAll();
			}
			,failure : function(response, opts) { objTargetElement.innerHTML = response.responseText; }
		});
	}
	
	obj.RenderCanVariance = function(TargetElement, ImplNewID) {
		var objTargetElement = document.getElementById(TargetElement);
		if (!objTargetElement) { return; }
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL
			,method : 'POST'
			,params : {
				ClassName : 'web.DHCCPW.OPCPW.FormShowOP',
				QueryName : 'QryEpStepVars',
				Arg1 : ImplNewID,
				ArgCnt : 1
			}
			,success : function(response, opts) {
				var Data = buildCanVarObj(response.responseText);
				CanVarXTemplate.overwrite(TargetElement, Data);
				CanVarDisabled(FuncSign);
				CanVarSelectAll();
			}
			,failure : function(response, opts) { objTargetElement.innerHTML = response.responseText; }
		});
	}
	
	obj.VariancePanel.setDisabled(true);
	obj.RenderExeVariance('exeVariance', ImplNewID, UserType);
	obj.RenderCanVariance('canVariance', ImplNewID);
	obj.cboVarCateg.setDisabled(FuncSign);
	obj.cboVarReason.setDisabled(FuncSign);
	obj.txtVarResume.setDisabled(FuncSign);
	var objbtnExeVar = document.getElementById("btnExeVar");
	objbtnExeVar.disabled = FuncSign;
	objbtnExeVar.onclick = function() { ExeVarClick(); }
	var objbtnCanVar = document.getElementById("btnCanVar");
	objbtnCanVar.disabled = FuncSign;
	objbtnCanVar.onclick = function() { CanVarClick(); }
	obj.VariancePanel.setDisabled(false);
	
	function ExeVarSelectAll() {
		var objStepTimeAll = document.getElementById("STEPTIME_All");
		if (objStepTimeAll) {
			objStepTimeAll.onclick = function() {
				var objStepTimeITM = document.getElementsByName("STEPTIME_ITM");
				for (var i=0; i<objStepTimeITM.length; i++) {
					objStepTimeITM[i].checked = objStepTimeAll.checked;
				}
			}
		}
		var objOEItemAll = document.getElementById("OEITEM_All");
		if (objOEItemAll) {
			objOEItemAll.onclick = function() {
				var objOEItemITM = document.getElementsByName("OEITEM_ITM");
				for (var i=0; i<objOEItemITM.length; i++) {
					objOEItemITM[i].checked = objOEItemAll.checked;
				}
			}
		}
		var objCPWItemBAll = document.getElementById("CPWITEM_B_ALL");
		if (objCPWItemBAll) {
			objCPWItemBAll.onclick = function() {
				var objCPWItemBITM = document.getElementsByName("CPWITEM_B_ITM");
				for (var i=0; i<objCPWItemBITM.length; i++) {
					objCPWItemBITM[i].checked = objCPWItemBAll.checked;
				}
			}
		}
		var objCPWItemKAll = document.getElementById("CPWITEM_K_ALL");
		if (objCPWItemKAll) {
			objCPWItemKAll.onclick = function() {
				var objCPWItemKITM = document.getElementsByName("CPWITEM_K_ITM");
				for (var i=0; i<objCPWItemKITM.length; i++) {
					objCPWItemKITM[i].checked = objCPWItemKAll.checked;
				}
			}
		}
		
	}
	
	function CanVarSelectAll() {
		var objVarItemAll = document.getElementById("VARITEM_All");
		if (objVarItemAll) {
			objVarItemAll.onclick = function() {
				var objVarItemITM = document.getElementsByName("VARITEM_ITM");
				for (var i=0; i<objVarItemITM.length; i++) {
					objVarItemITM[i].checked = objVarItemAll.checked;
				}
			}
		}
	}
	
	function ExeVarDisabled(check) {
		var objStepTimeAll = document.getElementById("STEPTIME_All");
		if (objStepTimeAll) { objStepTimeAll.disabled = check; }
		var objStepTimeITM = document.getElementsByName("STEPTIME_ITM");
		for (var i=0; i<objStepTimeITM.length; i++) {
			if (objStepTimeITM[i]) { objStepTimeITM[i].disabled = check; }
		}
		var objOEItemAll = document.getElementById("OEITEM_All");
		if (objOEItemAll) { objOEItemAll.disabled = check; }
		var objOEItemITM = document.getElementsByName("OEITEM_ITM");
		for (var i=0; i<objOEItemITM.length; i++) {
			if (objOEItemITM[i]) { objOEItemITM[i].disabled = check; }
		}
		var objCPWItemBAll = document.getElementById("CPWITEM_B_ALL");
		if (objCPWItemBAll) { objCPWItemBAll.disabled = check; }
		var objCPWItemBITM = document.getElementsByName("CPWITEM_B_ITM");
		for (var i=0; i<objCPWItemBITM.length; i++) {
			if (objCPWItemBITM[i]) { objCPWItemBITM[i].disabled = check; }
		}
		var objCPWItemKAll = document.getElementById("CPWITEM_K_ALL");
		if (objCPWItemKAll) { objCPWItemKAll.disabled = check; }
		var objCPWItemKITM = document.getElementsByName("CPWITEM_K_ITM");
		for (var i=0; i<objCPWItemKITM.length; i++) {
			if (objCPWItemKITM[i]) { objCPWItemKITM[i].disabled = check; }
		}
	}
	
	function CanVarDisabled(check) {
		var objVarItemAll = document.getElementById("VARITEM_All");
		if (objVarItemAll) { objVarItemAll.disabled = check; }
		var objVarItemITM = document.getElementsByName("VARITEM_ITM");
		for (var i=0; i<objVarItemITM.length; i++) {
			if (objVarItemITM[i]) { objVarItemITM[i].disabled = check; }
		}
	}
	
	function ExeVarClick() {
		var ErrorInfo = "";
		var VarReason = obj.cboVarReason.getValue();
		var VarReasonRaw = obj.cboVarReason.getRawValue();
		var VarResume = obj.txtVarResume.getValue();
		if (!VarReason) { ErrorInfo = ErrorInfo + "请选择变异原因，变异原因不允许为空！"; }
		if (VarReasonRaw.indexOf("其他")>=0 && !VarResume) { ErrorInfo = ErrorInfo + "请填写原因备注，备注不允许为空！"; }
		if (ErrorInfo) { ExtTool.alert("提示", ErrorInfo); return; }
		var selectItems = "";
		var objStepTimeITM = document.getElementsByName("STEPTIME_ITM");
		for (var i=0; i<objStepTimeITM.length; i++) {
			if (objStepTimeITM[i].checked) { selectItems = selectItems + objStepTimeITM[i].id + ","; }
		}
		var objOEItemITM = document.getElementsByName("OEITEM_ITM");
		for (var i=0; i<objOEItemITM.length; i++) {
			if (objOEItemITM[i].checked) { selectItems = selectItems + objOEItemITM[i].id + ","; }
		}
		var objCPWItemBITM = document.getElementsByName("CPWITEM_B_ITM");
		for (var i=0; i<objCPWItemBITM.length; i++) {
			if (objCPWItemBITM[i].checked) { selectItems = selectItems + objCPWItemBITM[i].id + ","; }
		}
		var objCPWItemKITM = document.getElementsByName("CPWITEM_K_ITM");
		for (var i=0; i<objCPWItemKITM.length; i++) {
			if (objCPWItemKITM[i].checked) { selectItems = selectItems + objCPWItemKITM[i].id + ","; }
		}
		var InputStr = EpisodeID;
		InputStr = InputStr + "^" + VarReason;
		InputStr = InputStr + "^" + VarResume;
		InputStr = InputStr + "^" + session['LOGON.USERID'];
		InputStr = InputStr + "^" + "";
		InputStr = InputStr + "^" + selectItems;
		InputStr = InputStr + "^" + EpStepID;
		InputStr = InputStr + "^" + ImplNewID;
		var ret = objClinPathWaysVariance.UpdateExtraVar(InputStr);
		if (ret<0) {
			ExtTool.alert("提示", "操作失败！", Ext.MessageBox.ERROR);
			return;
		}
		VarianceRefresh();
	}
	
	function CanVarClick() {
		var objVarItemITM = document.getElementsByName("VARITEM_ITM");
		var selflg = 0;
		for (var i=0; i<objVarItemITM.length; i++) {
			if (objVarItemITM[i].checked) { selflg = selflg + 1; }
		}
		if (selflg<1) { ExtTool.alert("提示", "请选择要撤销的项目！"); return; }
		for (var j=0; j<objVarItemITM.length; j++) {
			if (objVarItemITM[j].checked) {
				var inputStr = objVarItemITM[j].id + "^" + session['LOGON.USERID'];
				var ret = objClinPathWaysVariance.UpdoVariance(inputStr);
				if (ret<0) { ExtTool.alert("提示", "撤销失败！"); return; }
			}
		}
		VarianceRefresh();
	}
	
	function VarianceRefresh() {
		obj.cboVarCateg.setValue('');
		obj.cboVarReason.setValue('');
		obj.txtVarResume.setValue('');
		var objVarItemAll = document.getElementById("VARITEM_All");
		objVarItemAll.checked = false;
		obj.RenderExeVariance('exeVariance', ImplNewID, UserType);
		obj.RenderCanVariance('canVariance', ImplNewID);
		if (typeof(window.parent.objControlArry)['FormNewWin'].RenderVariance=="function") {
			window.parent.objControlArry['FormNewWin'].RenderVariance('divVariance', ImplNewID);
		}
	}
	
	return obj;
}
