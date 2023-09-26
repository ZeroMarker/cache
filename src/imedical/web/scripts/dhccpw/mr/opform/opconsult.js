// dhccpw.mr.opformconsult.csp
function InitMainViewport() {
	//alert("ImplNewID:"+ImplNewID+":FuncSign:"+FuncSign+":ConsultMode:"+ConsultMode);
	var Type = "", Flag = "", TemplateTitle = "ERROR", ButtonTitle = "ERROR", divOPForm = "divNull";
	if (ConsultMode.indexOf("ZX")>0) {
		ButtonTitle = "执行";
	} else if (ConsultMode.indexOf("CX")>0) {
		ButtonTitle = "撤销";
		Type = "Cancel";
	}
	if (ConsultMode.indexOf("ZL")>=0) {
		Flag = "01";
		divOPForm = "divConsult";
		TemplateTitle = "主要诊疗工作";
	} else if (ConsultMode.indexOf("HL")>=0) {
		Flag = "03";
		divOPForm = "divNursing";
		TemplateTitle = "主要护理工作";
	}
	if (!ImplNewID || ButtonTitle=="ERROR" || TemplateTitle=="ERROR") { return; }
	var CHR_1 = String.fromCharCode(1);
	var CHR_2 = String.fromCharCode(2);
	var CHR_ER = String.fromCharCode(13)+String.fromCharCode(10);
	
	var obj = new Object();
	
	obj.ConsultPanel = new Ext.Panel({
		id : 'ConsultPanel'
		,region : 'center'
		,layout : 'fit'
		,frame : false
		,autoScroll : true
		,title : TemplateTitle
	});
	
	obj.ConsultViewport = new Ext.Viewport({
		id : 'ConsultViewport'
		,layout : 'fit'
		,items : [ obj.ConsultPanel ]
	});
	
	var ViewHeight = obj.ConsultViewport.getHeight();
	var RowHeight = 30;
	var DivHeight = ViewHeight - RowHeight - RowHeight - 27;
	
	obj.ConsultHTML = ''
	 +	'<table width="100%" height="'+RowHeight+'px" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>'
	 +		'<td width="10%" class="diytd4th"><input type="checkbox" id="CONSULT_ALL"></td>'
	 +		'<td width="45%" class="diytd4th">'+TemplateTitle+'</td>'
	 +		'<td width="45%" class="diytd4th">执行情况</td>'
	 +	'</tr></table>'
	 +	'<div id="Consult" style="height:'+DivHeight+'px"></div>'
	 +	'<table width="100%" height="'+RowHeight+'px" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>'
	 +		'<td width="100%" class="diytd3th"><input type="button" id="ConsultEntry" value="'+ButtonTitle+'"></td>'
	 +	'</tr></table>'
	 +	'';
	
	Ext.getCmp("ConsultPanel").body.update(obj.ConsultHTML);
	
	var ConsultXTemplate = new Ext.XTemplate(
		'<tpl for="ConsultData">',
			'<table width="100%" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>',
				'<td width="10%" height="'+RowHeight+'px" class="diytd4">',
					'<input type="checkbox" id="{ItemRowid}" name="CONSULT_ITM"></td>',
				'<td width="45%" height="'+RowHeight+'px" class="diytd5',
					'<tpl if="this.isOptional(ItemOptional)"> diyfont1</tpl>',
				'">{ItemDesc}</td>',
				'<td width="45%" height="'+RowHeight+'px" class="diytd5">{Exec}</td>',
			'</tr></table>',
		'</tpl>',
		{
			compiled : true
			,disableFormats : true
			,isOptional : function(ItemOptional) { return ItemOptional=="1"; }
		}
	);
	
	function buildConsultObj(Str, Type) {
		var objData = Ext.decode(Str);
		var objItm = null, ConsultStr = "";
		if (Type!="Cancel") {
			for (var i=0; i<objData.total; i++) {
				objItm = objData.record[i];
				ConsultStr = ConsultStr + "{'ItemRowid':'" + objItm.ItemRowid;
				ConsultStr = ConsultStr + "','ItemDesc':'" + objItm.ItemDesc;
				ConsultStr = ConsultStr + "','SubCatDesc':'" + objItm.SubCatDesc;
				ConsultStr = ConsultStr + "','ItemOptional':'" + objItm.ItemOptional;
				ConsultStr = ConsultStr + "','ItemImpl':'" + objItm.ItemImpl;
				var ImplDtl = objItm.ImplDtl, DtlStr = "";
				ImplDtl = ImplDtl.split(CHR_1);
				for (var j=0; j<ImplDtl.length; j++) {
					var tmpDtl = ImplDtl[j];
					if (tmpDtl=="") { continue; }
					DtlStr = DtlStr + tmpDtl.split("^")[1] + " ; ";
				}
				ConsultStr = ConsultStr + "','Exec':'" + DtlStr + "'},";
			}
		} else {
			for (var i=0; i<objData.total; i++) {
				objItm = objData.record[i];
				var ImplDtl = objItm.ImplDtl, DtlStr = "";
				ImplDtl = ImplDtl.split(CHR_1);
				for (var j=0; j<ImplDtl.length; j++) {
					var tmpDtl = ImplDtl[j];
					if (tmpDtl=="") { continue; }
					ConsultStr = ConsultStr + "{'ItemRowid':'" + tmpDtl.split("^")[0];
					ConsultStr = ConsultStr + "','ItemDesc':'" + objItm.ItemDesc;
					ConsultStr = ConsultStr + "','SubCatDesc':'" + objItm.SubCatDesc;
					ConsultStr = ConsultStr + "','ItemOptional':'" + objItm.ItemOptional;
					ConsultStr = ConsultStr + "','ItemImpl':'" + objItm.ItemImpl;
					ConsultStr = ConsultStr + "','Exec':'" + tmpDtl.split("^")[1] + "'},";
				}
			}
		}
		ConsultStr = ConsultStr.substring(0, ConsultStr.length-1);
		ConsultStr = "{ConsultData:[" + ConsultStr + "]}";
		var ConsultData = Ext.decode(ConsultStr);
		return ConsultData;
	}
	
	obj.RenderConsult = function(TargetElement, ImplNewID, Flag, Type) {
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
				var Data = buildConsultObj(response.responseText, Type);
				ConsultXTemplate.overwrite(TargetElement, Data);
				ConsultDisabled(FuncSign);
				ConsultSelectAll();
			}
			,failure : function(response, opts) { objTargetElement.innerHTML = response.responseText; }
		});
	}
	
	obj.ConsultPanel.setDisabled(true);
	obj.RenderConsult('Consult', ImplNewID, Flag, Type);
	var objConsultEntry = document.getElementById("ConsultEntry");
	objConsultEntry.disabled = FuncSign;
	objConsultEntry.onclick = function() { onEntryClick(objConsultEntry.value); }
	obj.ConsultPanel.setDisabled(false);
	
	function ConsultSelectAll() {
		var objSelAll = document.getElementById("CONSULT_ALL");
		objSelAll.onclick = function() {
			var objSelItm = document.getElementsByName("CONSULT_ITM");
			for (var i=0; i<objSelItm.length; i++) {
				objSelItm[i].checked = objSelAll.checked;
			}
		}
	}
	
	function ConsultDisabled(check) {
		var objEleAll = document.getElementById("CONSULT_ALL");
		if (objEleAll) { objEleAll.disabled = check; }
		var objEleItm = document.getElementsByName("CONSULT_ITM");
		for (var i=0; i<objEleItm.length; i++) {
			if (objEleItm[i]) { objEleItm[i].disabled = check; }
		}
	}
	
	function onEntryClick(btnValue) {
		var selectItems = "", ret = -1;
		var objConsult = document.getElementsByName("CONSULT_ITM");
		for (var i=0; i<objConsult.length; i++) {
			if (objConsult[i].checked) {
				selectItems = selectItems + objConsult[i].id + ",";
			}
		}
		if (selectItems!="") {
			selectItems = selectItems.substring(0, selectItems.length-1);
		} else {
			ExtTool.alert("提示", "请选择项目！");
			return;
		}
		var service = ExtTool.StaticServerObject("web.DHCCPW.MR.Implement");
		if (btnValue=="执行") {
			ret = service.doImplBatch(ImplNewID, selectItems, session['LOGON.USERID']);
		} else if (btnValue=="撤销") {
			ret = service.updoImplBatch(selectItems, session['LOGON.USERID']);
		}
		if (ret<0) { ExtTool.alert("提示", "操作失败！"); return; }
		obj.RenderConsult('Consult', ImplNewID, Flag, Type);
		if (typeof window.parent.objControlArry['FormNewWin'].RenderEpStepItems=="function") {
			window.parent.objControlArry['FormNewWin'].RenderEpStepItems(divOPForm, ImplNewID, Flag);
		}
	}
	
	return obj;
}
