// dhccpw.mr.opformshow.csp
function InitFormNewWin() {
	//alert(ImplNewID+":"+UserMode+":"+FormMode+":"+NewPage+":"+PortalFlg);
	var objInterfaceOP = ExtTool.StaticServerObject("web.DHCCPW.OPCPW.InterfaceOP");
	var objImplNew = GetImplNew(ImplNewID);
	if (!objImplNew) { return; }
	var PathWayID = objImplNew.PathWayID;
	var EpisodeID = objImplNew.EpisodeID;
	var objPathWay = GetClinPathWay(PathWayID);
	if (!objPathWay) { return; }
	var CPWID = objPathWay.CPWDR;
	var objCPW = GetClinPathWayDic(CPWID);
	if (!objCPW) { return; }
	var objPaadm = GetDHCPAADM(EpisodeID);
	if (!objPaadm) { return; }
	var objPerson = GetDHCPaPerson(objPaadm.PatientID);
	if (!objPerson) { return; }
	var objTitle = BuildTitleObject(objPerson, objCPW);
	
	var obj = new Object();
	
	obj.combStepListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.combStepListStore = new Ext.data.Store({
		proxy : obj.combStepListStoreProxy,
		reader : new Ext.data.JsonReader({
			root : 'record',
			totalProperty : 'total',
			idProperty : 'ImplNewID'
		},
		[
			 { name : 'checked', mapping : 'checked' }
			,{ name : 'ImplNewID', mapping : 'ImplNewID' }
			,{ name : 'ImplNewDesc', mapping : 'ImplNewDesc' }
		])
		,listeners : {
			'load' : function() {
				var StepListlength = obj.combStepListStore.getCount(), Errflg = "Y";
				for (var i=0; i<StepListlength; i++) {
					if (obj.combStepListStore.getAt(i).get("ImplNewID")==ImplNewID) { Errflg = "N"; }
				}
				if (Errflg=="Y") { ImplNewID = "ERROR"; }
				obj.combStepList.setValue(ImplNewID);
				obj.FreshForm(ImplNewID);
			}
		}
	});
	obj.combStepList = new Ext.form.ComboBox({
		id : 'combStepList'
		,width : 320
		,store : obj.combStepListStore
		,minChars : 1
		,mode : 'local'
		,displayField : 'ImplNewDesc'
		,editable : false
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'ImplNewID'
		,listeners : {
			'select' : function() { obj.FreshForm(obj.combStepList.value); }
		}
	});
	obj.combStepListStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'web.DHCCPW.OPCPW.FormShowOP';
		param.QueryName = 'QryImplNew';
		param.Arg1 = PathWayID;
		param.ArgCnt = 1;
	});
	obj.combStepListStore.load();
	
	obj.btnCancelPath = new Ext.Toolbar.Button({
		tooltip : '撤销'
		,iconCls : 'icon-cancel'
		,text : '撤销'
		,id : 'btnCancelPath'
		,handler : function() {
			var canImplNewID = obj.combStepList.getValue();
			if (canImplNewID.split("||")[1]==1) { ExtTool.alert("提示", "步骤第一次不允许撤销!"); return; }
			var canImplNewStr = objInterfaceOP.GetStringByImplNewID(canImplNewID);
			canImplNewStr = canImplNewStr.split("^");
			if (canImplNewStr[3]!=EpisodeID) { ExtTool.alert("提示", "非本次就诊不允许撤销!"); return; }
			var ret = objInterfaceOP.ChkImplNewOperation(canImplNewID);
			if (ret=="Y") { ExtTool.alert("提示", "步骤已做过操作,不允许撤销!"); return; }
			Ext.MessageBox.confirm('Confirm', '确定要撤销此步骤？', function(btn, text) {
				if (btn=="yes") {
					var UpdoDoc = "";
					var ctpcpService = ExtTool.StaticServerObject("web.DHCCPW.MR.CTCareProvSrv");
					var docString = ctpcpService.GetCareProvByUserID(session['LOGON.USERID'], "^");
					UpdoDoc = docString.split("^")[0];
					var ret = objInterfaceOP.UpdoImplNew(canImplNewID, UpdoDoc);
					if (ret<0) {
						ExtTool.alert("提示", "撤销失败!");
					} else {
						var lnk = "dhccpw.mr.opclinpathway.csp?EpisodeID="+EpisodeID+"&BackPage=1";
						document.location.href = lnk;
					}
				}
			});
		}
	});
	
	obj.btnOutPath = new Ext.Toolbar.Button({
		tooltip : '出径'
		,iconCls : 'icon-cancel'
		,text : '出径'
		,id : 'btnOutPath'
		,handler : function() {
			var objParent = Ext.getCmp('MainPanel');
			OutPathWayHeader(objParent, PathWayID, session['LOGON.USERID']);
		}
	});
	
	obj.btnClosePath = new Ext.Toolbar.Button({
		tooltip : '完成'
		,iconCls : 'icon-update'
		,text : '完成'
		,id : 'btnClosePath'
		,handler : function() {
			var ret = objInterfaceOP.ChkStepSign(PathWayID, session['LOGON.USERID']);
			ret = ret.split(CHR_1)
			var StepSignID = ret[0], ChkStepSignDesc = ret[1];
			if (StepSignID<0) { StepSignID = "Y"; }
			if (ret[0]=="Y" || ret[0]=="N") { alert(ChkStepSignDesc); }
			if (ret[0]=="Y") { return; }
			var ret = objInterfaceOP.ChkResult(PathWayID);
			if (ret!="Y") { ExtTool.alert("提示", "路径没评估不允许完成!"); return; }
			Ext.MessageBox.confirm('Confirm', '确定是否要完成路径？', function(btn, text) {
				if (btn=="yes") {
					try {
						var ImplNewIndStr = objInterfaceOP.GetImplNewStrByInd(PathWayID, "1");
						var PaadmInd = ImplNewIndStr.split("^")[3];
						var objInterfaceCls = ExtTool.StaticServerObject("web.DHCCPW.MR.Interface");
						var ret = objInterfaceCls.ClosePathWay(PaadmInd);	// FirstPaadm
						if (parseInt(ret)<1) {
							ExtTool.alert("提示", "结束路径失败！");
							return;
						} else {
							window.location.reload();
						}
					} catch(err) {
						ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
					}
					return;
				}
			});
		}
	});
	
	obj.btnRstPathWay = new Ext.Toolbar.Button({
		tooltip : '出径或完成路径评估'
		,iconCls : 'icon-update'
		,text : '评估'
		,id : 'btnRstPathWay'
		,handler : function() {
			var objParent = Ext.getCmp('MainPanel');
			PathWayEvaHeader(objParent, PathWayID, session['LOGON.USERID']);
		}
	});
	
	obj.btnPageMRCPW = new Ext.Toolbar.Button({
		tooltip : '出入径'
		,iconCls : 'icon-find'
		,text : "出入径"
		,id : 'btnPageMRCPW'
		,handler : function() {
			var lnk = "dhccpw.mr.opclinpathway.csp?EpisodeID="+EpisodeID+"&BackPage=1";
			document.location.href = lnk;
		}
	});
	
	obj.tbar = [
		'-', obj.combStepList, '-',
		objTitle.RegNo, objTitle.PatName, objTitle.PatSex, objTitle.PatAge,
		objTitle.AdmDate, objTitle.AdmTime, objTitle.AdmDoc, objTitle.CPWDesc, '-'
	];
	
	obj.bbar = [
		'->', "<i>相关操作:</i>", { xtype : 'tbspacer' , width : 25 }, '-',
		//{ xtype : 'tbspacer' , width : 25 }, obj.btnPageMRCPW,	// 出入径
		{ xtype : 'tbspacer' , width : 25 }, obj.btnCancelPath,	// 撤销
		{ xtype : 'tbspacer' , width : 25 }, obj.btnOutPath,	// 出径
		{ xtype : 'tbspacer' , width : 25 }, obj.btnClosePath,	// 完成
		{ xtype : 'tbspacer' , width : 25 }, obj.btnRstPathWay,	// 评估
		{ xtype : 'tbspacer' , width : 200 }
		//,btnPrintPathWay		// 打印表单
		//,btnPrintFormToPatient	// 打印患者表单
	];
	
	obj.FormPanel = new Ext.Panel({
		id : 'FormPanel'
		,layout : 'fit'
		,region : 'west'
		,frame : true
		,autoScroll : true
		,split : true
		,collapsible : true
		,collapsed : false
        ,lines : false
        ,animCollapse : false
        ,animate : false
        ,collapseMode : 'mini'
		,collapseFirst : false
		,hideCollapseTool : true
		,border : true
		,boxMinWidth : 350
		,boxMaxWidth : 350
		,width : 350
	});
	
	obj.FuncPanel = new Ext.Panel({
		id : 'FuncPanel'
		,layout : 'fit'
		,region : 'center'
		,frame : true
		,split : true
		,border : true
	});
	
	obj.MainPanel = new Ext.Panel({
		id : 'MainPanel'
		,layout : 'border'
		,region : 'center'
		,buttonAlign : 'center'
		,frame : true
		,items : [ obj.FormPanel, obj.FuncPanel ]
		,tbar : obj.tbar
		,bbar : obj.bbar
	});
	
	obj.MainViewport = new Ext.Viewport({
		id : 'MainViewport'
		,layout : 'fit'
		,items : [ obj.MainPanel ]
	});
	
	var FormHeight = Ext.getCmp('FormPanel').getSize().height;
	var RowHeight = 30;
	
	var ConsultTable = ''
	 +	'<table width="100%" height="'+RowHeight+'px" class="diytd4th" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>'
	 +		'<td width="50%" align="left">主要诊疗工作</td>'
	 +		'<td width="50%" align="right">'
	 +			'<input type="Radio" name="FormRadio" id="ZLZX" value="ZLZX">执行'
	 +			'<input type="Radio" name="FormRadio" id="ZLCX" value="ZLCX">撤销'
	 +		'</td>'
	 +	'</tr></table>'
	 +	'<div id="divConsult" style="height:'+RowHeight+'px"></div>'
	 +	'';
	
	var OrderTable = ''
	 +	'<table width="100%" height="'+RowHeight+'px" class="diytd4th" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>'
	 +		'<td width="50%" align="left">重点医嘱</td>'
	 +		'<td width="50%" align="right">'
	 +			'<input type="Radio" name="FormRadio" id="YZBD" value="YZBD">表单'
	 +			'<input type="Radio" name="FormRadio" id="YZYZ" value="YZYZ" checked="checked">医嘱'
	 +		'</td>'
	 +	'</tr></table>'
	 +	'<div id="divOrder" style="height:'+RowHeight+'px"></div>'
	 +	'';
	
	var NursingTable = ''
	 +	'<table width="100%" height="'+RowHeight+'px" class="diytd4th" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>'
	 +		'<td width="50%" align="left">主要护理工作</td>'
	 +		'<td width="50%" align="right">'
	 +			'<input type="Radio" name="FormRadio" id="HLZX" value="HLZX">执行'
	 +			'<input type="Radio" name="FormRadio" id="HLCX" value="HLCX">撤销'
	 +		'</td>'
	 +	'</tr></table>'
	 +	'<div id="divNursing" style="border:1px solid blue;height:'+RowHeight+'px"></div>'
	 +	'';
	
	var VarianceTable = ''
	 +	'<table width="100%" height="'+RowHeight+'px" class="diytd4th" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>'
	 +		'<td width="50%" align="left">病情变异记录</td>'
	 +		'<td width="50%" align="right">'
	 +			'<input type="Radio" name="FormRadio" id="BYJL" value="BYJL">变异'
	 +			'<input type="Radio" name="FormRadio" id="YZDZ" value="YZDZ">对照'
	 +		'</td>'
	 +	'</tr></table>'
	 +	'<div id="divVariance" style="height:'+RowHeight+'px"></div>'
	 +	'';
	
	var DoctorSignTable = ''
	 +	'<table width="100%" height="'+RowHeight+'px" class="diytd4th" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>'
	 +		'<td width="50%" align="left">医师签名</td>'
	 +		'<td width="50%" align="right">'
	 +			'<input type="button" name="Sign" id="YSQM" value="签名">'
	 +			'<input type="button" name="Sign" id="YSCX" value="撤销">'
	 +		'</td>'
	 +	'</tr></table>'
	 +	'<div id="divDoctorSign" style="height:'+RowHeight+'px"></div>'
	 +	'';
	
	var NurseSignTable = ''
	 +	'<table width="100%" height="'+RowHeight+'px" class="diytd4th" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>'
	 +		'<td width="50%" align="left">护士签名</td>'
	 +		'<td width="50%" align="right">'
	 +			'<input type="button" name="Sign" id="HSQM" value="签名">'
	 +			'<input type="button" name="Sign" id="HSCX" value="撤销">'
	 +		'</td>'
	 +	'</tr></table>'
	 +	'<div id="divNurseSign" style="height:'+RowHeight+'px"></div>'
	 +	'';
	
	/*	// 门诊仅有doctor的权限
	if (UserMode=="DEMO") {
		obj.FormHTML = ConsultTable + OrderTable + NursingTable + VarianceTable + DoctorSignTable + NurseSignTable;
	} else if (UserMode=="DOCTOR") {
		obj.FormHTML = ConsultTable + OrderTable + VarianceTable + DoctorSignTable;
	} else if (UserMode=="NURSE") {
		obj.FormHTML = OrderTable + NursingTable + VarianceTable + NurseSignTable;
	} else {
		obj.FormHTML = "";
	}*/
	obj.FormHTML = ConsultTable + OrderTable + VarianceTable + DoctorSignTable;
	Ext.getCmp("FormPanel").body.update(obj.FormHTML);
	
	var ConsultXTemplate = new Ext.XTemplate(
		'<tpl for=".">',
			'<table width="100%" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>',
				'<td width="10%" height="'+RowHeight+'px" class="diytd4',
					'<tpl if="this.isImplCur(ItemImpl)"> diyfont2</tpl>">',
					'<tpl if="this.isImpl(ItemImpl)">√</tpl></td>',
				'<td width="90%" height="'+RowHeight+'px" class="diytd5',
					'<tpl if="this.isOptional(ItemOptional)"> diyfont1</tpl>',
				'">{ItemDesc}</td>',
			'</tr></table>',
		'</tpl>',
		{
			compiled : true
			,disableFormats : true
			,isImpl : function(ItemImpl) { return ItemImpl > 0; }
			,isImplCur : function(ItemImpl) { return ItemImpl == 2; }
			,isOptional : function(ItemOptional) { return ItemOptional == "1"; }
		}
	);
	
	var OrderXTemplate = new Ext.XTemplate(
		'<tpl for="OrderData">',
			'<table width="100%" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>',
				'<td width="100%" height="'+RowHeight+'px" class="diytd3th">{SubCatDesc}</td>',
			'</tr></table>',
			'<tpl for="CateItems">',
				'<table width="100%" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>',
					'<td width="10%" height="'+RowHeight+'px" class="diytd4',
						'<tpl if="this.isImplCur(ItemImpl)"> diyfont2</tpl>">',
						'<tpl if="this.isImpl(ItemImpl)">√</tpl></td>',
					'<td width="90%" height="'+RowHeight+'px" class="diytd5',
						'<tpl if="this.isOptional(ItemOptional)"> diyfont1</tpl>">{ItemDesc}</td>',
				'</tr></table>',
			'</tpl>',
		'</tpl>',
		{
			compiled : true
			,disableFormats : true
			,isImpl : function(ItemImpl) { return ItemImpl > 0; }
			,isImplCur : function(ItemImpl) { return ItemImpl == 2; }
			,isOptional : function(ItemOptional) { return ItemOptional == "1"; }
		}
	);
	
	var VarianceXTemplate = new Ext.XTemplate(
		'<tpl for=".">',
			'<table width="100%" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>',
				'<td width="10%" height="'+RowHeight+'px" class="diytd4"></td>',
				'<td width="90%" height="'+RowHeight+'px" class="diytd5">{VarNum}、{VarDesc}</td>',
			'</tr></table>',
		'</tpl>',
		{
			compiled : true
			,disableFormats : true
		}
	);
	
	var SignXTemplate = new Ext.XTemplate(
		'<tpl for=".">',
			'<table width="100%" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>',
				'<td width="10%" height="'+RowHeight+'px" class="diytd4">',
					'<input type="checkbox" id={SignRowID} name="chbSign"></td>',
				'<td width="90%" height="'+RowHeight+'px" class="diytd5">{SignNum}、{ItemDesc}</td>',
			'</tr></table>',
		'</tpl>',
		{
			compiled : true
			,disableFormats : true
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
	
	function buildOrderObj(Str) {
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
					itmStr = itmStr + "','ItemImpl':'" + objData.record[k].ItemImpl + "'},";
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
	
	obj.RenderEpStepItems = function(TargetElement, ImplNewID, Flag) {
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
				var Data = "", XTemplate = "", Str = response.responseText;
				if (Flag=="01" || Flag=="03") {
					Data = buildXTemplateObj(Str);
					XTemplate = ConsultXTemplate;
				} else if (Flag=="02") {
					Data = buildOrderObj(Str);
					XTemplate = OrderXTemplate;
				}
				XTemplate.overwrite(TargetElement, Data);
			}
			,failure : function(response, opts) { objTargetElement.innerHTML = response.responseText; }
		});
	}
	
	obj.RenderVariance = function(TargetElement, ImplNewID) {
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
				Data = buildXTemplateObj(response.responseText);
				VarianceXTemplate.overwrite(TargetElement, Data);
			}
			,failure : function(response, opts) { objTargetElement.innerHTML = response.responseText; }
		});
	}
	
	obj.RenderSign = function(TargetElement, ImplNewID, Type) {
		var objTargetElement = document.getElementById(TargetElement);
		if (!objTargetElement) { return; }
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL
			,method : 'POST'
			,params : {
				ClassName : 'web.DHCCPW.OPCPW.FormShowOP',
				QueryName : 'QryEpStepSigns',
				Arg1 : ImplNewID,
				Arg2 : Type,
				ArgCnt : 2
			}
			,success : function(response, opts) {
				Data = buildXTemplateObj(response.responseText);
				SignXTemplate.overwrite(TargetElement, Data);
				SignDisabled();
			}
			,failure : function(response, opts) { objTargetElement.innerHTML = response.responseText; }
		});
	}
	
	obj.FreshForm = function(ImplNewID) {
		obj.MainPanel.setDisabled(true);
		obj.RenderEpStepItems('divConsult', ImplNewID, '01');
		obj.RenderEpStepItems('divOrder', ImplNewID, '02');
		//obj.RenderEpStepItems('divNursing', ImplNewID, '03');
		obj.RenderVariance('divVariance', ImplNewID);
		obj.RenderSign('divDoctorsign', ImplNewID, 'D');
		//obj.RenderSign('divNurseSign', ImplNewID, 'N');
		selectFormRadio(ImplNewID);
		var FormRadio = document.getElementsByName("FormRadio");
		for (var i=0; i<FormRadio.length; i++) {
			var radio = FormRadio[i];
			if (radio.type=="radio") {
				radio.onclick = function() { selectFormRadio(ImplNewID); }
			}
		}
		var check = false;
		if (objPathWay.Status!="I") { check = true; }
		obj.btnCancelPath.setDisabled(check);
		obj.btnOutPath.setDisabled(check);
		obj.btnClosePath.setDisabled(check);
		obj.btnRstPathWay.setDisabled(check);
		var objYSQM = document.getElementById("YSQM");
		var objYSCX = document.getElementById("YSCX");
		//var objHSQM = document.getElementById("HSQM");
		//var objHSCX = document.getElementById("HSCX");
		if (check) {
			if (objYSQM) { objYSQM.disabled = check; }
			if (objYSCX) { objYSCX.disabled = check; }
			//if (objHSQM) { objHSQM.disabled = check; }
			//if (objHSCX) { objHSCX.disabled = check; }
		} else {
			if (objYSQM) { objYSQM.onclick = function() { exeSign(ImplNewID, "D"); } }
			if (objYSCX) { objYSCX.onclick = function() { canSign(ImplNewID, "D"); } }
			//if (objHSQM) { objHSQM.onclick = function() { exeSign(ImplNewID, "N"); } }
			//if (objHSCX) { objHSCX.onclick = function() { canSign(ImplNewID, "N"); } }
		}
		obj.MainPanel.setDisabled(false);
	}
	
	function selectFormRadio(ImplNewID) {
		var urlFunc = "", htmlFunc = "", FuncSign = "";
		var SignCount = objInterfaceOP.ChkSignList(ImplNewID, UserMode.substring(0, 1));
		if (objPathWay.Status!="I" || SignCount>0) { FuncSign = true; }
		var FormRadio = document.getElementsByName("FormRadio");
		for (i=0; i<FormRadio.length; i++) {
			var radio = FormRadio[i];
			if (!radio.checked) { continue; }
			if (radio.value=="ZLZX" || radio.value=="ZLCX" || radio.value=="HLZX" || radio.value=="HLCX") {
				urlFunc = "dhccpw.mr.opformconsult.csp?ImplNewID="+ImplNewID+"&FuncSign="+FuncSign+"&ConsultMode="+radio.value;
			} else if (radio.value=="YZBD" || radio.value=="YZYZ") {
				urlFunc = "dhccpw.mr.opformorder.csp?ImplNewID="+ImplNewID+"&FuncSign="+FuncSign+"&OrderMode="+radio.value;
			} else if (radio.value=="BYJL") {
				urlFunc = "dhccpw.mr.opformvariance.csp?ImplNewID="+ImplNewID+"&FuncSign="+FuncSign+"&VarianceMode="+UserMode;
			} else if (radio.value=="YZDZ") {
				urlFunc = "dhccpw.mr.opformcontrast.csp?ImplNewID="+ImplNewID+"&FuncSign="+FuncSign+"&ContrastMode="+UserMode;
			}
		}
		htmlFunc = "<iframe id = 'Func' name = 'Func' height = '100%' width = '100%' src = '" + urlFunc + "'/>";
		Ext.getCmp("FuncPanel").body.update(htmlFunc);
	}
	
	function SignDisabled() {
		var check = false;
		if (objPathWay.Status!="I") { check = true; }
		var objSign = document.getElementsByName("chbSign");
		for (var i=0; i<objSign.length; i++) { objSign[i].disabled = check; }
	}
	
	function exeSign(ImplNewID, SignUserType) {
		var objImplNew = GetImplNew(ImplNewID), PathWayID = "", EpStepID = "";
		if (objImplNew) { PathWayID = objImplNew.PathWayID; EpStepID = objImplNew.EpStepID; }
		if (PathWayID=="" || EpStepID=="") { ExtTool.alert("提示", "更新失败！"); return; }
		var ret = objInterfaceOP.ChkVarItemList(ImplNewID, SignUserType);
		if (ret>0) {
			ExtTool.alert("提示", "此步骤存在变异，请填写病情变异记录后再签名！");
			return;
		}
		var SignUserID = session['LOGON.USERID'];
		var objCTCareProvSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.CTCareProvSrv");
		var strCareProv = objCTCareProvSrv.GetCareProvByUserID(SignUserID);
		var tiptitle = "Null", SignDoctorID = "", SignNurseID = "", divSign = "Null";
		if (SignUserType=="D") {
			tiptitle = "医师";
			SignDoctorID = strCareProv.split("^")[0];
			divSign = "divDoctorsign";
		} else if (SignUserType=="N") {
			tiptitle = "护士";
			SignNurseID = strCareProv.split("^")[0];
			divSign = "divNurseSign";
		}
		ExtTool.confirm(tiptitle+"签名确认", "请确认是否进行"+tiptitle+"签名？", function(btn) {
			if (btn=="yes") {
				var InputStr = PathWayID;
				InputStr = InputStr + "^" + EpStepID;
				InputStr = InputStr + "^" + SignDoctorID;
				InputStr = InputStr + "^" + SignNurseID;
				InputStr = InputStr + "^" + "Y";
				InputStr = InputStr + "^" + "";
				InputStr = InputStr + "^" + "";
				InputStr = InputStr + "^" + SignUserID;
				InputStr = InputStr + "^" + "";
				InputStr = InputStr + "^" + "";
				InputStr = InputStr + "^" + "";
				InputStr = InputStr + "^" + ImplNewID;
				var objSignSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWaysSign");
				var ret = objSignSrv.Update(InputStr);
				if (ret<0) {
					ExtTool.alert("提示", "更新失败！");
					return;
				} else {
					obj.RenderSign(divSign, ImplNewID, SignUserType);
					selectFormRadio(ImplNewID);
				}
			}
		});
	}
	
	function canSign(ImplNewID, SignUserType) {
		var selitms = "";
		var objchbSign = document.getElementsByName("chbSign");
		for (var i=0; i<objchbSign.length; i++) {
			if (objchbSign[i].checked) { selitms = objchbSign[i].id + ","; }
		}
		if (selitms=="") {
			ExtTool.alert("提示", "请选择要撤销的项目！");
			return;
		}
		var divSign = "Null";
		if (SignUserType=="D") {
			divSign = "divDoctorsign";
		} else if (SignUserType=="N") {
			divSign = "divNurseSign";
		}
		var objSignSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWaysSign");
		for (var j=0; j<objchbSign.length; j++) {
			if (objchbSign[j].checked) {
				var InputStr = objchbSign[j].id + "^" + session['LOGON.USERID'];
				var flg = objSignSrv.UpdoSign(InputStr);
				if (flg<0) { ExtTool.alert("提示", "撤销失败！"); return; }
			}
		}
		obj.RenderSign(divSign, ImplNewID, SignUserType);
		selectFormRadio(ImplNewID);
	}
	
	function BuildTitleObject(objPerson, objCPW) {
		var objTitle = new Object();
		if (objPerson) {
			objTitle.RegNo = "<b>登记号:</b>" + objPerson.PapmiNo;
			objTitle.PatName = "<b>姓名:</b>" + objPerson.PatName;
			objTitle.PatSex = "<b>性别:</b>" + objPerson.PatSex;
			objTitle.PatAge = "<b>年龄:</b>" + objPerson.Age;
		} else {
			objTitle.RegNo = "";
			objTitle.PatName = "";
			objTitle.PatSex = "";
			objTitle.PatAge = "";
		}
		if (objPaadm) {
			objTitle.AdmDate = "<b>就诊日期:</b>" + objPaadm.AdmDate;
			objTitle.AdmTime = "<b>就诊时间:</b>" + objPaadm.AdmTime;
			objTitle.AdmDoc = "<b>主管医生:</b>" + objPaadm.AdmDoc;
		} else {
			objTitle.AdmDate = "";
			objTitle.AdmTime = "";
			objTitle.AdmDoc = "";
		}
		if (objCPW) {
			objTitle.CPWDesc = "<b>当前路径:</b>" + objCPW.CPWDesc;
		} else {
			objTitle.CPWDesc = "";
		}
		return objTitle;
	}
	
	obj.BuildOrderEntryURL = function(ImplNewID) {
		var orderEntry = "";
		var objTMPOrder = GetImplNew(ImplNewID);
		if (objTMPOrder) { objTMPOrder = GetDHCPAADM(objTMPOrder.EpisodeID); }
		var objGetWKFLI = ExtTool.StaticServerObject("web.DHCCPW.MR.Interface");
		var TWKFL = objGetWKFLI.GetWorkflowID("DHCCPW.OrderEntry");
		if (TWKFL!="" && objTMPOrder) {
			var objSysBaseSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.SysBaseSrv");
			var flg = objSysBaseSrv.CopyPreferencesToCPWWF(session['LOGON.SITECODE'], session['LOGON.USERID'], session['LOGON.GROUPID'], session['LOGON.CTLOCID'], session['LOGON.HOSPID']);
			if (flg) {
				orderEntry = orderEntry + "websys.csp?";
				orderEntry = orderEntry + "PatientID=";
				orderEntry = orderEntry + objTMPOrder.PatientID;
				orderEntry = orderEntry + "&EpisodeID=";
				orderEntry = orderEntry + objTMPOrder.EpisodeID;
				orderEntry = orderEntry + "&EpisodeIDs=";
				orderEntry = orderEntry + "&mradm=";
				orderEntry = orderEntry + objTMPOrder.MRAdm;
				orderEntry = orderEntry + "&ChartID=";
				orderEntry = orderEntry + "&PAAdmTransactionID=";
				orderEntry = orderEntry + "&OperRoomID=";
				orderEntry = orderEntry + "&DischID=";
				orderEntry = orderEntry + "&CurrDischID=";
				orderEntry = orderEntry + "&DischEpisodes=";
				orderEntry = orderEntry + "&doctype=";
				orderEntry = orderEntry + "&TWKFL=";
				orderEntry = orderEntry + TWKFL;
				orderEntry = orderEntry + "&TWKFLI=";
				orderEntry = orderEntry + "&Random=";
			}
		}
		return orderEntry;
	}
	
	function GetImplNew(ImplNewID) {
		var ret = objInterfaceOP.GetStringByImplNewID(ImplNewID);
		var objTMP = null;
		if (ret!="") {
			objTMP = new Object();
			var arrItems = ret.split("^");
			objTMP.PathWayID = arrItems[0];
			objTMP.EpStepID = arrItems[1];
			objTMP.DoctorID = arrItems[2];
			objTMP.EpisodeID = arrItems[3];
			objTMP.StepDate = arrItems[4];
			objTMP.StepTime = arrItems[5];
		}
		return objTMP
	}
	
	function GetClinPathWay(PathWayID) {
		var objMRClinicalPathWays = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinicalPathWays");
		var ret = objMRClinicalPathWays.GetStringById(PathWayID, CHR_1);
		if (ret!="") {
			var arrItems = ret.split(CHR_1);
			var objCPW = new ClinicalPathWay();
			objCPW.Rowid = arrItems[0];
			objCPW.MRADMDR = arrItems[1];
			objCPW.CPWDR = arrItems[2];
			objCPW.CPWDesc = arrItems[3];
			objCPW.CPWEpDR = arrItems[4];
			objCPW.CPWEpDesc = arrItems[5];
			objCPW.CPWEpStepDR = arrItems[6];
			objCPW.CPWEPStepDesc = arrItems[7];
			objCPW.Status = arrItems[8];
			objCPW.StatusDesc = arrItems[9];
			objCPW.InDoctorDR = arrItems[10];
			objCPW.InDoctorDesc = arrItems[11];
			objCPW.InDate = arrItems[12];
			objCPW.InTime = arrItems[13];
			objCPW.OutDoctorDR = arrItems[14];
			objCPW.OutDoctorDesc = arrItems[15];
			objCPW.OutDate = arrItems[16];
			objCPW.OutTime = arrItems[17];
			objCPW.OutReasonDR = arrItems[18];
			objCPW.OutReasonDesc = arrItems[19];
			objCPW.UpdateUserDR = arrItems[20];
			objCPW.UpdateUserDesc = arrItems[21];
			objCPW.UpdateDate = arrItems[22];
			objCPW.UpdateTime = arrItems[23];
			objCPW.Comments = arrItems[24];
			return objCPW;
		}
		return null;
	}
	
	function GetClinPathWayDic(cpwRowid) {
		var objCPWService = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysSrv");
		var ret = objCPWService.GetById(cpwRowid, CHR_1);
		if (ret!="") {
			var arrItems = ret.split(CHR_1);
			var objCPW = new ClinicalPathWay();
			objCPW.CPWDR = arrItems[0];
			objCPW.CPWDesc = arrItems[2];
			objCPW.IsOffShoot = arrItems[18];
			return objCPW;
		}
		return null;
	}
	
	function GetDHCPAADM(EpisodeID) {
		var objBasePAADMSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.PAADMSrv");
		if (EpisodeID) {
			var ret = objBasePAADMSrv.GetAdmInfoByID(EpisodeID, CHR_1);
			if (ret!="") {
				var arrItems = ret.split(CHR_1);
				var objPaadm = new DHCPAADM();
				objPaadm.EpisodeID = arrItems[0];
				objPaadm.AdmType = arrItems[1];
				objPaadm.AdmDate = arrItems[2];
				objPaadm.AdmTime = arrItems[3];
				objPaadm.AdmDoc = arrItems[4];
				objPaadm.AdmLoc = arrItems[5];
				objPaadm.AdmWard = arrItems[6];
				objPaadm.AdmRoom = arrItems[7];
				objPaadm.AdmBed = arrItems[8];
				objPaadm.AdmStatus = arrItems[9];
				objPaadm.DischDate = arrItems[10];
				objPaadm.DischTime = arrItems[11];
				objPaadm.MRAdm = arrItems[12];
				objPaadm.PatientID = arrItems[13];
				return objPaadm;
			}
		}
		return null;
	}
	
	function GetDHCPaPerson(PatientID) {
		var objBasePaPatmasSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.PaPatmasSrv");
		if (PatientID) {
			var ret = objBasePaPatmasSrv.GetPatInfoByID(PatientID, "", CHR_1);
			if (ret!="") {
				var arrItems = ret.split(CHR_1);
				var objPaPerson = new DHCPaPerson();
				objPaPerson.PatientID = arrItems[0];
				objPaPerson.PapmiNo = arrItems[1];
				objPaPerson.PatName = arrItems[2];
				objPaPerson.PatSex = arrItems[3];
				objPaPerson.BirthDay = arrItems[4];
				objPaPerson.Age = arrItems[5];
				return objPaPerson;
			}
		}
		return null;
	}
	
	function ClinicalPathWay() {
		var objTMP = new Object();
		objTMP.Rowid = "";
		objTMP.MRADMDR = "";
		objTMP.CPWDR = "";
		objTMP.CPWDesc = "";
		objTMP.CPWEpDR = "";
		objTMP.CPWEpDesc = "";
		objTMP.CPWEpStepDR ="";
		objTMP.CPWEPStepDesc ="";
		objTMP.Status ="";
		objTMP.StatusDesc ="";
		objTMP.InDoctorDR ="";
		objTMP.InDoctorDesc ="";
		objTMP.InDate ="";
		objTMP.InTime ="";
		objTMP.OutDoctorDR ="";
		objTMP.OutDoctorDesc ="";
		objTMP.OutDate ="";
		objTMP.OutTime ="";
		objTMP.OutReasonDR ="";
		objTMP.OutReasonDesc ="";
		objTMP.UpdateUserDR ="";
		objTMP.UpdateUserDesc ="";
		objTMP.UpdateDate ="";
		objTMP.UpdateTime ="";
		objTMP.Comments ="";
		objTMP.IsOffShoot ="";
		return objTMP;
	}
		
	function DHCPAADM() {
		var objTMP = new Object();
		objTMP.EpisodeID = "";
		objTMP.AdmType = "";
		objTMP.AdmDate = "";
		objTMP.AdmTime = "";
		objTMP.AdmDoc = "";
		objTMP.AdmLoc = "";
		objTMP.AdmWard = "";
		objTMP.AdmRoom = "";
		objTMP.AdmBed = "";
		objTMP.AdmStatus = "";
		objTMP.DischDate = "";
		objTMP.DischTime = "";
		objTMP.MRAdm = "";
		objTMP.PatientID = "";
		return objTMP;
	}
	
	function DHCPaPerson() {
		var objTMP = new Object();
		objTMP.PatientID = "";
		objTMP.PapmiNo = "";
		objTMP.PatName = "";
		objTMP.PatSex = "";
		objTMP.BirthDay = "";
		objTMP.Age = "";
		return objTMP;
	}
	
	return obj;
}
