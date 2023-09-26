// dhccpw.mr.opformorder.csp
function InitMainViewport() {
	//alert("ImplNewID:"+ImplNewID+":FuncSign:"+FuncSign+":OrderMode:"+OrderMode);
	var PathWayID = "";
	var objInterfaceOP = ExtTool.StaticServerObject("web.DHCCPW.OPCPW.InterfaceOP");
	var ImplNewStr = objInterfaceOP.GetStringByImplNewID(ImplNewID);
	if (ImplNewStr) { PathWayID = ImplNewStr.split("^")[0]; }
	if (!ImplNewID || !OrderMode ||!PathWayID) { return; }
	var objImplement = ExtTool.StaticServerObject("web.DHCCPW.MR.Implement");
	var CHR_1 = String.fromCharCode(1);
	var CHR_2 = String.fromCharCode(2);
	var CHR_ER = String.fromCharCode(13)+String.fromCharCode(10);
	
	var obj = new Object();
	
	obj.DoctorPanel = new Ext.Panel({
		id : 'DoctorPanel'
		,region : 'center'
		,layout : 'fit'
		,split : true
		,border : true
	});
	
	obj.OrderPanel = new Ext.Panel({
		id : 'OrderPanel'
		,region : 'center'
		,layout : 'fit'
		,frame : false
		,autoScroll : true
		,title : '重点医嘱'
	});
	
	obj.ExeFormPanel = new Ext.Panel({
		id : 'ExeFormPanel'
		,region : 'center'
		,layout : 'fit'
		,frame : false
		,autoScroll : true
		,title : '标记执行'
	});
	
	if (OrderMode=="YZBD") {
		obj.DoctorPanel.setVisible(false);
		obj.OrderPanel.setVisible(true);
	} else {
		obj.DoctorPanel.setVisible(true);
		obj.OrderPanel.setVisible(false);
	}
	obj.ExeFormPanel.setVisible(false);
	
	obj.OrderViewport = new Ext.Viewport({
		id : 'OrderViewport'
		,layout : 'fit'
		,items : [ obj.DoctorPanel, obj.OrderPanel, obj.ExeFormPanel ]
	});
	
	var ViewHeight = obj.OrderViewport.getHeight();
	var RowHeight = 30;
	var DivHeight = ViewHeight - RowHeight - RowHeight - 27;
	obj.DoctorPanel.setHeight(ViewHeight);
	obj.OrderPanel.setHeight(ViewHeight);
	obj.ExeFormPanel.setHeight(ViewHeight-RowHeight);
	
	obj.OrderHTML = ''
	 +	'<table width="100%" height="'+RowHeight+'px" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>'
	 +		'<td width="10%" class="diytd4th"><input type="checkbox" id="ORDER_ALL"></td>'
	 +		'<td width="10%" class="diytd4th">医嘱序号</td>'
	 +		'<td width="70%" class="diytd4th">医嘱名称</td>'
	 +		'<td width="10%" class="diytd4th">关联医嘱</td>'
	 +	'</tr></table>'
	 +	'<div id="Order" style="height:'+DivHeight+'px"></div>'
	 +	'<table width="100%" height="'+RowHeight+'px" class="diytd3th" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>'
	 +		'<td width="50%"><input type="button" id="OrderEntry" value="下医嘱"></td>'
	 +		'<td width="50%"><input type="button" id="ExeFormPnl" value="标记执行"></td>'
	 +	'</tr></table>'
	 +	'';
	
	obj.ExeFormHTML = ''
	 +	'<table width="100%" height="'+RowHeight+'px" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>'
	 +		'<td width="10%" class="diytd4th">选择</td>'
	 +		'<td width="10%" class="diytd4th">是否执行</td>'
	 +		'<td width="80%" class="diytd4th">表单项目</td>'
	 +	'</tr></table>'
	 +	'<div id="ExeForm" style="height:'+(DivHeight-RowHeight-4)+'px"></div>'
	 +	'<table width="100%" height="'+RowHeight+'px" class="diytd3th" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>'
	 +		'<td width="20%">执行说明:</td>'
	 +		'<td width="80%"><div id="divProcNote"></div></td>'
	 +	'</tr></table>'
	 +	'<table width="100%" height="'+RowHeight+'px" class="diytd3th" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>'
	 +		'<td width="33%"><input type="button" id="btnExeForm" value="标记"></td>'
	 +		'<td width="33%"><input type="button" id="btnCanForm" value="撤销"></td>'
	 +		'<td width="34%"><input type="button" id="OrderPnl" value="返回"></td>'
	 +	'</tr></table>'
	 +	'';
	
	var DocURL = window.parent.objControlArry['FormNewWin'].BuildOrderEntryURL(ImplNewID);
	DocURL = "<iframe id = 'DocIfrm' name = 'DocIfrm' height = '100%' width = '100%' src = '" + DocURL + "'/>";
	Ext.getCmp("DoctorPanel").body.update(DocURL);
	Ext.getCmp("OrderPanel").body.update(obj.OrderHTML);
	Ext.getCmp("ExeFormPanel").body.update(obj.ExeFormHTML);
	
	obj.txtProcNote = new Ext.form.TextField({
		width : 500
		//,fieldLable : '标记执行说明'
		,anchor : '100%'
		,emptyText : '外院已执行'
		,renderTo : 'divProcNote'
	});
	
	var OrderXTemplate = new Ext.XTemplate(
		'<tpl for="OrderData">',
			'<table width="100%" cellspacing="" cellpadding="0" border="0" rules="cols"><tr>',
				'<td width="100%" height="'+RowHeight+'px" class="diytd3th',
					'<tpl if="this.isOptional(ItemOptional)"> diyfont1</tpl>',
				'">[{SubCatDesc}] {ItemDesc}</td>',
			'</tr></table>',
			'<tpl for="OrderDtl">',
				'<table width="100%" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>',
					'<td width="10%" height="'+RowHeight+'px" class="diytd4">',
						'<input type="checkbox" id={ArcimId} name="ORDER_ITM" ',
						'<tpl if="this.IsDefault(ItmDefault)">checked="checked"</tpl>></td>',
					'<td width="10%" height="'+RowHeight+'px" class="diytd5">{ItmNo}</td>',
					'<td width="70%" height="'+RowHeight+'px" class="diytd5">{ArcimDesc}</td>',
					'<td width="10%" height="'+RowHeight+'px" class="diytd5">{ItmLinkNo}</td>',
				'</tr></table>',
			'</tpl>',
		'</tpl>',
		{
			compiled : true
			,disableFormats : true
			,IsDefault : function(ItmDefault) { return ItmDefault=="Y"; }
			,isOptional : function(ItemOptional) { return ItemOptional=="1"; }
		}
	);
	
	var ExeFormXTemplate = new Ext.XTemplate(
		'<tpl for="OrderData">',
			'<table width="100%" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>',
				'<td width="100%" height="'+RowHeight+'px" class="diytd3th">{SubCatDesc}</td>',
			'</tr></table>',
			'<tpl for="CateItems">',
				'<table width="100%" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>',
					'<td width="10%" height="'+RowHeight+'px" class="diytd4">',
						'<input type="checkbox" id={ItemRowid} name="EXEFORM_ITM"></td>',
					'<td width="10%" height="'+RowHeight+'px" class="diytd4',
						'<tpl if="this.isImplCur(ItemImpl)"> diyfont2</tpl>">',
						'<tpl if="this.isImpl(ItemImpl)">√</tpl></td>',
					'<td width="80%" height="'+RowHeight+'px" class="diytd5',
						'<tpl if="this.isOptional(ItemOptional)"> diyfont1</tpl>',
					'">{ItemDesc}</td>',
				'</tr></table>',
				'<table width="100%" class="diytd5" cellspacing="0" cellpadding="0" border="0" rules="cols">',
					'<tpl for="ImplDtl"><tr>',
						'<td width="20%" height="'+RowHeight+'px"></td>',
						'<td width="5%" height="'+RowHeight+'px"><tpl if="this.isCheckBox(ImplementID)">',
							'<input type="checkbox" id={ImplementID} name="CANFORM_ITM"></tpl></td>',
						'<td width="75%" height="'+RowHeight+'px">{ImplDesc}</td>',
					'</tr></tpl>',
				'</table>',
			'</tpl>',
		'</tpl>',
		{
			compiled : true
			,disableFormats : true
			,isImpl : function(ItemImpl) { return ItemImpl > 0; }
			,isImplCur : function(ItemImpl) { return ItemImpl == 2; }
			,isOptional : function(ItemOptional) { return ItemOptional == "1"; }
			,isCheckBox : function(ImplementID) { return ImplementID != ""; }
		}
	);
	
	function buildOrderObj(Str) {
		var objData = Ext.decode(Str);
		var arrayData = new Array();
		var objItm = null, OrderStr = "";
		for (var i=0; i<objData.total; i++) {
			objItm = objData.record[i];
			OrderStr = OrderStr + "{'ItemRowid':'" + objItm.ItemRowid;
			OrderStr = OrderStr + "','ItemDesc':'" + objItm.ItemDesc;
			OrderStr = OrderStr + "','SubCatDesc':'" + objItm.SubCatDesc;
			OrderStr = OrderStr + "','ItemOptional':'" + objItm.ItemOptional;
			OrderStr = OrderStr + "','ItemImpl':'" + objItm.ItemImpl;
			OrderStr = OrderStr + "','OrderDtl':[";
			var OrderDtl = objItm.OrderDtl, DtlStr = "";
			OrderDtl = OrderDtl.substring(0, OrderDtl.length-1);
			OrderDtl = OrderDtl.split(CHR_1);
			for (var j=0; j<OrderDtl.length; j++) {
				var tmpDtl = OrderDtl[j];
				tmpDtl = tmpDtl.split("^");
				if (tmpDtl=="") { continue; }
				DtlStr = DtlStr + "{'ArcimId':'" + objItm.ItemRowid + "^" + tmpDtl[0] + "^" + tmpDtl[4];
				DtlStr = DtlStr + "','ArcimDesc':'" + tmpDtl[2];
				DtlStr = DtlStr + "','ItmLinkNo':'" + tmpDtl[4];
				DtlStr = DtlStr + "','ItmNo':'" + tmpDtl[0];
				DtlStr = DtlStr + "','ItmDefault':'" + tmpDtl[3];
				var tmp5 = "必选";
				if (tmpDtl[5]=="Y") { tmp5 = "可选"; }
				DtlStr = DtlStr + "','ItmPriority':'" + tmp5;
				DtlStr = DtlStr + "','ItemID':'" + objItm.ItemRowid + "'},";
			}
			DtlStr = DtlStr.substring(0, DtlStr.length-1);
			OrderStr = OrderStr + DtlStr + "]},";
		}
		OrderStr = OrderStr.substring(0, OrderStr.length-1);
		OrderStr = "{OrderData:[" + OrderStr + "]}";
		var OrderData = Ext.decode(OrderStr);
		return OrderData;
	}
	
	function buildExeFormObj(Str) {
		var objData = Ext.decode(Str);
		var arrayData = new Array();
		var objItm = null;
		var groupCateg = new Array(), ind = 0, tmpCateg = "";
		for (var i=0; i<objData.total; i++) {
			objItm = objData.record[i];
			arrayData[arrayData.length] = objItm;
			if (tmpCateg.indexOf(objData.record[i].SubCatDesc)<0) {
				tmpCateg = tmpCateg + objData.record[i].SubCatDesc + ",";
				groupCateg[ind] = objData.record[i].SubCatDesc;
				ind = ind + 1;
			}
		}
		var OrderStr = "";
		for (var j=0; j<groupCateg.length; j++) {
			OrderStr = OrderStr + "{'SubCatDesc':'" + groupCateg[j] + "','CateItems':[";
			var itmStr = "";
			for (var k=0; k<objData.total; k++) {
				if (groupCateg[j]==objData.record[k].SubCatDesc) {
					itmStr = itmStr + "{'ItemRowid':'" + objData.record[k].ItemRowid;
					itmStr = itmStr + "','ItemDesc':'" + objData.record[k].ItemDesc;
					itmStr = itmStr + "','ItemOptional':'" + objData.record[k].ItemOptional;
					itmStr = itmStr + "','ItemImpl':'" + objData.record[k].ItemImpl;
					itmStr = itmStr + "','ImplDtl':[";
					var implDtl = objData.record[k].ImplDtl;
					var arrayImplDtl = implDtl.split(CHR_1);
					var DtlStr = "";
					for (var l=0; l<arrayImplDtl.length; l++) {
						var tmpImplDtl = arrayImplDtl[l];
						if (tmpImplDtl=="") { continue; }
						tmpImplDtl = tmpImplDtl.split("^");
						DtlStr = DtlStr + "{'ImplementID':'" + tmpImplDtl[0];
						DtlStr = DtlStr + "','ImplDesc':'" + tmpImplDtl[1] + "'},";
					}
					DtlStr = DtlStr.substring(0, DtlStr.length-1);
					itmStr = itmStr + DtlStr + "]},";
				}
			}
			itmStr = itmStr.substring(0, itmStr.length-1);
			OrderStr = OrderStr + itmStr + "]},";
		}
		OrderStr = OrderStr.substring(0, OrderStr.length-1);
		OrderStr = "{OrderData:[" + OrderStr + "]}";
		var OrderData = Ext.decode(OrderStr);
		return OrderData;
	}
	
	obj.RenderOrder = function(TargetElement, ImplNewID, Flag) {
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
				var Data = buildOrderObj(response.responseText);
				OrderXTemplate.overwrite(TargetElement, Data);
				OrderDisabled(FuncSign);
				OrderSelect();
			}
			,failure : function(response, opts) { objTargetElement.innerHTML = response.responseText; }
		});
	}
	
	obj.RenderExeForm = function(TargetElement, ImplNewID, Flag) {
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
				var Data = buildExeFormObj(response.responseText);
				ExeFormXTemplate.overwrite(TargetElement, Data);
				ExeFormDisabled(FuncSign);
			}
			,failure : function(response, opts) { objTargetElement.innerHTML = response.responseText; }
		});
	}
	
	obj.OrderPanel.setDisabled(true);
	obj.RenderOrder('Order', ImplNewID, '02');
	obj.RenderExeForm('ExeForm', ImplNewID, '02');
	var objOrderEntry = document.getElementById("OrderEntry");
	objOrderEntry.disabled = FuncSign;
	obj.txtProcNote.setDisabled(FuncSign);
	objOrderEntry.onclick = function() { onEntryClick(); }
	var ExeFormPnl = document.getElementById("ExeFormPnl");
	if (ExeFormPnl) {
		ExeFormPnl.onclick = function() { ExeFormLink(); }
	}
	var OrderPnl = document.getElementById("OrderPnl");
	if (OrderPnl) {
		OrderPnl.onclick = function() { OrderLink(); }
	}
	var btnExeForm = document.getElementById("btnExeForm");
	if (btnExeForm) {
		btnExeForm.disabled = FuncSign;
		btnExeForm.onclick = function() { ExeFormClick(); }
	}
	var btnCanForm = document.getElementById("btnCanForm");
	if (btnCanForm) {
		btnCanForm.disabled = FuncSign;
		btnCanForm.onclick = function() { CanFormClick(); }
	}
	obj.OrderPanel.setDisabled(false);
	
	function OrderSelect() {
		var objOrderAll = document.getElementById("ORDER_ALL");
		var objOrderITM = document.getElementsByName("ORDER_ITM");
		objOrderAll.onclick = function() {
			for (var i=0; i<objOrderITM.length; i++) {
				objOrderITM[i].checked = objOrderAll.checked;
			}
		}
		for (var i=0; i<objOrderITM.length; i++) {
			objOrderITM[i].onclick = function() {
				var tmplist0 = this.id.split("^");
				for (var j=0; j<objOrderITM.length; j++) {
					var tmplist1 = objOrderITM[j].id.split("^");
					if (tmplist0[0]==tmplist1[0] && tmplist0[2]==tmplist1[2]) {
						objOrderITM[j].checked = this.checked;
					}
				}
			}
		}
	}
	
	function OrderDisabled(check) {
		var objOrderAll = document.getElementById("ORDER_ALL");
		if (objOrderAll) { objOrderAll.disabled = check; }
		var objOrderITM = document.getElementsByName("ORDER_ITM");
		for (var i=0; i<objOrderITM.length; i++) {
			if (objOrderITM[i]) { objOrderITM[i].disabled = check; }
		}
	}
	
	function ExeFormDisabled(check) {
		var objExeFormItm = document.getElementsByName("EXEFORM_ITM");
		for (var i=0; i<objExeFormItm.length; i++) {
			if (objExeFormItm[i]) { objExeFormItm[i].disabled = check; }
		}
		var objCanFormItm = document.getElementsByName("CANFORM_ITM");
		for (var i=0; i<objCanFormItm.length; i++) {
			if (objCanFormItm[i]) { objCanFormItm[i].disabled = check; }
		}
	}
	
	function onEntryClick() {
		var selectItems = "";
		var objOrder = document.getElementsByName("ORDER_ITM");
		for (var i=0; i<objOrder.length; i++) {
			if (objOrder[i].checked==true) {
				selectItems = selectItems + objOrder[i].id + ",";
			}
		}
		if (selectItems=="") {
			ExtTool.alert("提示", "请选择医嘱！");
			return;
		}
		obj.DoctorPanel.setVisible(true);
		obj.OrderPanel.setVisible(false);
		var objFormRadio = window.parent.document.getElementsByName("FormRadio");
		for (var i=0; i<objFormRadio.length; i++) {
			if (objFormRadio[i].value=="YZYZ") {
				objFormRadio[i].checked = true;
			} else {
				objFormRadio[i].checked = false;
			}
		}
		var ifrmDoc = document.getElementById("DocIfrm");
		if (typeof ifrmDoc.contentWindow.addOEORIByCPW=="function") {
			ifrmDoc.contentWindow.addOEORIByCPW(selectItems);
		} else {
			ExtTool.alert("提示", "医嘱录入模块升级导致结构变化，请调整！");
		}
	}
	
	obj.OrderRefresh = function() {
		if (typeof window.parent.objControlArry['FormNewWin'].RenderEpStepItems=="function") {
			window.parent.objControlArry['FormNewWin'].RenderEpStepItems('divOrder', ImplNewID, '02');
		}
	}
	
	function OrderLink() {
		obj.RenderOrder('Order', ImplNewID, '02');
		obj.RenderExeForm('ExeForm', ImplNewID, '02');
		obj.DoctorPanel.setVisible(false);
		obj.OrderPanel.setVisible(true);
		obj.ExeFormPanel.setVisible(false);
	}
	
	function ExeFormLink() {
		obj.RenderOrder('Order', ImplNewID, '02');
		obj.RenderExeForm('ExeForm', ImplNewID, '02');
		obj.DoctorPanel.setVisible(false);
		obj.OrderPanel.setVisible(false);
		obj.ExeFormPanel.setVisible(true);
	}
	
	function ExeFormClick() {
		var ExeFormItem = document.getElementsByName("EXEFORM_ITM");
		var selExeFormItm = "";
		for (var i=0; i<ExeFormItem.length; i++) {
			if (ExeFormItem[i].checked==true) { selExeFormItm = selExeFormItm + ExeFormItem[i].id; }
		}
		if (selExeFormItm=="") { ExtTool.alert("提示","请选择标记项目!"); return; }
		var UserId = session['LOGON.USERID'];
		var ProcNote = obj.txtProcNote.getValue();
		if (ProcNote=="") { ProcNote = "外院已执行"; }
		for (var j=0; j<ExeFormItem.length; j++) {
			if (ExeFormItem[j].checked==true) {
				var ItemID = ExeFormItem[j].id;
				var ret = objImplement.doImplOutOrder(PathWayID, ItemID, "", ProcNote, UserId, ImplNewID);
				if (ret<0) { ExtTool.alert("提示","标记失败!"); return; }
			}
		}
		obj.txtProcNote.setValue('');
		obj.RenderExeForm('ExeForm', ImplNewID, '02');
		obj.OrderRefresh();
	}
	
	function CanFormClick() {
		var CanFormItem = document.getElementsByName("CANFORM_ITM");
		var selCanFormItm = "";
		for (var i=0; i<CanFormItem.length; i++) {
			if (CanFormItem[i].checked==true) { selCanFormItm = selCanFormItm + CanFormItem[i].id + ","; }
		}
		if (selCanFormItm=="") { ExtTool.alert("提示", "请选择撤销项目!"); return; }
		selCanFormItm = selCanFormItm.substring(0, selCanFormItm.length-1);
		var ret = objImplement.updoImplBatch(selCanFormItm, session['LOGON.USERID']);
		if (ret<0) { ExtTool.alert("提示", "撤销失败!"); return; }
		obj.txtProcNote.setValue('');
		obj.RenderExeForm('ExeForm', ImplNewID, '02');
		obj.OrderRefresh();
	}
	
	return obj;
}
