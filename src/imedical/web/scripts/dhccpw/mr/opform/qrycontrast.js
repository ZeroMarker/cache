// dhccpw.mr.cpwqrycontrast.csp
function InitMainViewport() {
	var obj = new Object();
	var objInterfaceOP = ExtTool.StaticServerObject("web.DHCCPW.OPCPW.InterfaceOP");
	
	obj.cboPathWayDicStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboPathWayDicStore = new Ext.data.Store({
		proxy : obj.cboPathWayDicStoreProxy,
		reader : new Ext.data.JsonReader({
			root : 'record',
			totalProperty : 'total',
			idProperty : 'ID'
		},
		[
			{name : 'checked', mapping : 'checked'}
			,{name : 'ID', mapping : 'ID'}
			,{name : 'Desc', mapping : 'Desc'}
			,{name : 'CurrVersion', mapping : 'CurrVersion'}
		])
	});
	obj.cboPathWayDic = new Ext.form.ComboBox({
		id : 'cboPathWayDic'
		,minChars : 1
		,store : obj.cboPathWayDicStore
		,valueField : 'ID'
		//,fieldLabel : '临床路径字典'
		,displayField : 'Desc'
		,triggerAction : 'all'
		,width : 150
		,anchor : '99%'
		,listeners : {
			'select' : function() {
				obj.cboPathWayVer.setValue('');
				obj.PathWayStep.setValue('');
				obj.cboPathWayVerStore.load({});
				obj.PathWayStepStore.load({});
			}
		}
	});
	obj.cboPathWayDicStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'web.DHCCPW.MRC.ClinPathWaysDicSrv';
		param.QueryName = 'QryClinPathWayDic';
		param.Arg1 = 'N';
		param.Arg2 = 'Y';
		param.ArgCnt = 2;
	});
	obj.cboPathWayDicStore.load();
	
	obj.cboPathWayVerStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboPathWayVerStore = new Ext.data.Store({
		proxy : obj.cboPathWayVerStoreProxy,
		reader : new Ext.data.JsonReader({
			root : 'record',
			totalProperty : 'total',
			idProperty : 'ID'
		},
		[
			{name : 'checked', mapping : 'checked'}
			,{name : 'CPWID', mapping : 'CPWID'}
			,{name : 'Desc', mapping : 'Desc'}
			,{name : 'ImgPath', mapping : 'ImgPath'}
		])
	});
	obj.cboPathWayVer = new Ext.form.ComboBox({
		id : 'cboPathWayVer'
		,minChars : 1
		,store : obj.cboPathWayVerStore
		,valueField : 'CPWID'
		//,fieldLabel : '临床路径版本'
		,displayField : 'Desc'
		,triggerAction : 'all'
		,width : 150
		,anchor : '99%'
		,tpl : '<tpl for="."><div x-combo-list-item:qtip="{ImgPath}" class="x-combo-list-item"><img src="{ImgPath}" width="16" height="16">&nbsp;{Desc}</div></tpl>'
		,listeners : {
			'select' : function() {
				obj.PathWayStep.setValue('');
				obj.PathWayStepStore.load({});
			}
		}
	});
	obj.cboPathWayVerStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'web.DHCCPW.OPCPW.FormShowOP';
		param.QueryName = 'QryCPWVersion';
		param.Arg1 = obj.cboPathWayDic.getValue();
		param.ArgCnt = 1;
	});
	
	obj.PathWayStepStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.PathWayStepStore = new Ext.data.Store({
		proxy : obj.PathWayStepStoreProxy,
		reader : new Ext.data.JsonReader({
			root : 'record',
			totalProperty : 'total',
			idProperty : 'StepRowID'
		},
		[
			 { name : 'checked', mapping : 'checked' }
			,{ name : 'StepRowID', mapping : 'StepRowID' }
			,{ name : 'StepDesc', mapping : 'StepDesc' }
		])
	});
	obj.PathWayStep = new Ext.form.ComboBox({
		id : 'PathWayStep'
		,width : 150
		,store : obj.PathWayStepStore
		,minChars : 1
		,mode : 'local'
		,displayField : 'StepDesc'
		,editable : false
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'StepRowID'
	});
	obj.PathWayStepStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'web.DHCCPW.OPCPW.FormShowOP';
		param.QueryName = 'GetEpStepByCPWID';
		param.Arg1 = obj.cboPathWayVer.getValue();
		param.ArgCnt = 1;
	});
	
	obj.cboActive = new Ext.form.ComboBox({
		id : 'cboActive'
		,width : 100
		,store : new Ext.data.ArrayStore({
			id : 'cboActiveStore'
			,fields : [ 'Code', 'Desc' ]
			,data : [ ['', '全部'], ['Y', '有效'], ['N', '撤销'] ]
		})
		,mode : 'local'
		,minChars : 1
		,valueField : 'Code'
		,displayField : 'Desc'
		,editable : false
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.cboActive.setValue('');
	
	obj.btnQryCont = new Ext.Toolbar.Button({
		tooltip : '查询'
		,iconCls : 'icon-find'
		,text : '查询'
		,id : 'btnQryCont'
		,handler : function() {
			var TipInfo = "";
			if (!obj.cboPathWayDic.getValue()) { TipInfo = TipInfo + "【路径】、"; }
			if (!obj.cboPathWayVer.getValue()) { TipInfo = TipInfo + "【版本】、"; }
			var selEpStepID = obj.PathWayStep.getValue();
			var selActive = obj.cboActive.getValue();
			if (!selEpStepID) { TipInfo = TipInfo + "【步骤】、"; }
			if (TipInfo) {
				TipInfo = TipInfo.substring(0, TipInfo.length-1);
				ExtTool.alert("提示", "请选择"+TipInfo+"!");
				return;
			}
			obj.RenderContrast("divQryCont", selEpStepID, selActive);
		}
	});
	
	obj.btnCanCont = new Ext.Toolbar.Button({
		tooltip : '撤销'
		,iconCls : 'icon-cancel'
		,text : '撤销'
		,id : 'btnCanCont'
		,handler : function() {
			var selContITM = "";
			var objContITM = document.getElementsByName("CONT_ITM");
			for (var i=0; i<objContITM.length; i++) {
				if (objContITM[i].checked) { selContITM = selContITM + objContITM[i].id + ","; }
			}
			if (!selContITM) { ExtTool.alert("提示", "请选择要撤销的项目!"); return; }
			Ext.MessageBox.confirm('Confirm', '确定是否要撤销所选项目？', function(btn, text) {
				if (btn=="yes") {
					for (var j=0; j<objContITM.length; j++) {
						if (objContITM[j].checked) {
							inputStr = objContITM[j].id + "^" + session['LOGON.USERID'];
							var ret = objInterfaceOP.UpdoContrast(inputStr);
							if (ret<0) { ExtTool.alert("提示", "撤销失败！"); return; }
						}
					}
					obj.RenderContrast("divQryCont", obj.PathWayStep.getValue(), obj.cboActive.getValue());
				}
			});
		}
	});
	
	var tbar = [
		{ xtype : 'tbspacer' , width : 100 }
		,'-','路径:',obj.cboPathWayDic
		,'-','版本:',obj.cboPathWayVer
		,'-','步骤:',obj.PathWayStep
		,'-','范围:',obj.cboActive
		,'-',obj.btnQryCont
		,'-',obj.btnCanCont
		,'-'
	];
	
	obj.MainPanel = new Ext.Panel({
		id : 'MainPanel'
		,region : 'center'
		,layout : 'fit'
		,frame : true
		,autoScroll : true
		,tbar : tbar
	});
	
	obj.MainViewport = new Ext.Viewport({
		id : 'MainViewport'
		,layout : 'fit'
		,items : [ obj.MainPanel ]
	});
	
	var RowHeight = 30;
	
	obj.QryContHTML = ''
	 +	'<table width="100%" height="'+RowHeight+'px" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>'
	 +		'<td width="5%" class="diytd4th">选择</td>'
	 +		'<td width="30%" class="diytd4th">对照医嘱</td>'
	 +		'<td width="5%" class="diytd4th">有效</td>'
	 +		'<td width="10%" class="diytd4th">对照人</td>'
	 +		'<td width="10%" class="diytd4th">对照日期</td>'
	 +		'<td width="10%" class="diytd4th">对照时间</td>'
	 +		'<td width="10%" class="diytd4th">撤销人</td>'
	 +		'<td width="10%" class="diytd4th">撤销日期</td>'
	 +		'<td width="10%" class="diytd4th">撤销时间</td>'
	 +	'</tr></table>'
	 +	'<div id="divQryCont" style=""></div>'
	 +	'';
	
	Ext.getCmp("MainPanel").body.update(obj.QryContHTML);
	
	var QryContXTemplate = new Ext.XTemplate(
		'<tpl for="ContData">',
			'<table width="100%" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>',
				'<td width="100%" height="'+RowHeight+'px" class="diytd3th',
					'<tpl if="this.isOptional(ItemOptional)"> diyfont1</tpl>',
				'">[{SubCatDesc}] {StepItemDesc}</td>',
			'</tr></table>',
			'<tpl for="ContDtl">',
				'<table width="100%" cellspacing="0" cellpadding="0" border="0" rules="cols"><tr>',
					'<td width="5%" height="'+RowHeight+'px" class="diytd4"><tpl if="this.isActive(ContActive)">',
						'<input type="checkbox" id="{ContrastID}" name="CONT_ITM">',
					'</tpl></td>',
					'<td width="30%" height="'+RowHeight+'px" class="diytd5">{ContItemDesc}</td>',
					'<td width="5%" height="'+RowHeight+'px" class="diytd4"><tpl if="this.isActive(ContActive)">√</tpl></td>',
					'<td width="10%" height="'+RowHeight+'px" class="diytd5">{ContUser}</td>',
					'<td width="10%" height="'+RowHeight+'px" class="diytd5">{ContDate}</td>',
					'<td width="10%" height="'+RowHeight+'px" class="diytd5">{ContTime}</td>',
					'<td width="10%" height="'+RowHeight+'px" class="diytd5">{UpdoUser}</td>',
					'<td width="10%" height="'+RowHeight+'px" class="diytd5">{UpdoDate}</td>',
					'<td width="10%" height="'+RowHeight+'px" class="diytd5">{UpdoTime}</td>',
				'</tr></table>',
			'</tpl>',
		'</tpl>',
		{
			compiled : true
			,disableFormats : true
			,isOptional : function(ItemOptional) { return ItemOptional=="1"; }
			,isActive : function(ContActive) { return ContActive=="Y"; }
		}
	);
	
	function buildContObj(Str) {
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
					itemStr = itemStr + "','ContActive':'" + objData.record[k].ContActive;
					itemStr = itemStr + "','ContUser':'" + objData.record[k].ContUser;
					itemStr = itemStr + "','ContDate':'" + objData.record[k].ContDate;
					itemStr = itemStr + "','ContTime':'" + objData.record[k].ContTime;
					itemStr = itemStr + "','UpdoUser':'" + objData.record[k].UpdoUser;
					itemStr = itemStr + "','UpdoDate':'" + objData.record[k].UpdoDate;
					itemStr = itemStr + "','UpdoTime':'" + objData.record[k].UpdoTime+"'},";
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
	
	obj.RenderContrast = function(TargetElement, EpStepID, Active) {
		var objTargetElement = document.getElementById(TargetElement);
		if (!objTargetElement) { return; }
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL
			,method : 'POST'
			,params : {
				ClassName : 'web.DHCCPW.OPCPW.FormShowOP',
				QueryName : 'QryContrastByEpStepID',
				Arg1 : EpStepID,
				Arg2 : Active,
				ArgCnt : 2
			}
			,success : function(response, opts) {
				var Data = buildContObj(response.responseText);
				QryContXTemplate.overwrite(TargetElement, Data);
			}
			,failure : function(response, opts) { objTargetElement.innerHTML = response.responseText; }
		});
	}
	
	return obj;
}
