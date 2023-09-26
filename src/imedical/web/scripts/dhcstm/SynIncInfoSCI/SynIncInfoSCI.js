
var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gGroupId = session['LOGON.GROUPID'];
var actionUrl = DictUrl + 'synincinfosciaction.csp';
var G_INCI = '';

var StkGrpType = new Ext.ux.StkGrpComboBox({ 
	id : 'StkGrpType',
	anchor : '90%',
	StkType : App_StkTypeCode,
	LocId : gLocId,
	UserId : UserId,
	childCombo : 'StkCat'
});

var StkCat = new Ext.ux.ComboBox({
	fieldLabel : '库存分类',
	id : 'StkCat',
	store : StkCatStore,
	params : {StkGrpId : 'StkGrpType'}
});

var InciCode = new Ext.form.TextField({
	fieldLabel : '物资代码',
	id : 'InciCode',
	anchor : '90%',
	disabled : true,
	valueNotFoundText : ''
});

var InciDesc = new Ext.form.TextField({
	fieldLabel : '物资名称',
	id : 'InciDesc',
	anchor : '90%',
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var stktype = Ext.getCmp('StkGrpType').getValue();
				GetPhaOrderInfo(field.getValue(), stktype);
			}
		},
		blur : function(field) {
			if (field.getValue() == '') {
				G_INCI = '';
				Ext.getCmp('InciCode').setValue('');
			}
		}
	}
});

function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, '', 'N', '0', '',getDrugList);
	}
}

function getDrugList(record) {
	if (record == null || record == '') {
		return;
	}
	G_INCI = record.get('InciDr');
	var inciCode = record.get('InciCode');
	var inciDesc = record.get('InciDesc');
	Ext.getCmp('InciCode').setValue(inciCode);
	Ext.getCmp('InciDesc').setValue(inciDesc);
}

var Vendor = new Ext.ux.VendorComboBox({
	id : 'Vendor',
	anchor : '90%',
	valueParams : {LocId : gLocId},
	params : {ScgId : 'StkGrpType'}
});

var SearchBT = new Ext.Button({
	text : '查询',
	width : 70,
	height : 30,
	iconCls : 'page_find',
	handler : function(e){
		var StkGrpType = Ext.getCmp('StkGrpType').getValue();
		var StkCat = Ext.getCmp('StkCat').getValue();
		var Vendor = Ext.getCmp('Vendor').getValue();
		var StrParam = StkGrpType + '^' + StkCat + '^' + G_INCI + '^' + Vendor + '^' + gLocId
			+ '^' + gUserId;
		
		InciQuaPicView.getStore().removeAll();
		InciDetailGridPanel.getStore().removeAll();
		InciGridPanel.getStore().removeAll();
		InciGridPanel.getStore().load({
			params : {
				StrParam : StrParam
			},
			callback : function(r, options, success){
				if(!success){
					Msg.info('error', '查询有误!');
				}
			}
		});
	}
});

var AuditBT = new Ext.Button({
	text : '审批资质',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function(e){
		var InciRecord = InciGridPanel.getSelectionModel().getSelected();
		var VendorId = InciRecord.get('VendorId');
		var InciId = InciRecord.get('InciId');
		
		var DetailStore = InciDetailGridPanel.getStore();
		var DetailCount = DetailStore.getCount();
		var VenIncIdStr = '';
		for(var i = 0; i < DetailCount; i++){
			var VenIncId = DetailStore.getAt(i).get('VenIncId');
			if(VenIncIdStr == ''){
				VenIncIdStr = VenIncId;
			}else{
				VenIncIdStr = VenIncIdStr + '^' + VenIncId;
			}
		}
		Ext.Ajax.request({
			url: actionUrl + '?actiontype=AuditVenIncInfo',
			params: {VendorId : VendorId, InciId : InciId, VenIncIdStr : VenIncIdStr},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if(jsonData.success == 'true'){
					Msg.info('success', '审批成功!');
					InciGridPanel.getStore().reload();
				}else{
					Msg.info('error', '审批失败:' + jsonData.info);
					return false;
				}
			},
			scope : this
		});
	}
});

var MainFormPanel = new Ext.ux.FormPanel({
	region : 'north',
	title : '平台物资资质审批',
	tbar : [SearchBT, '-', AuditBT],
	items : [{
		xtype : 'fieldset',
		title : '查询条件',
		layout : 'column',
		defaults : {layout : 'form'},
		items : [{
				columnWidth : 0.25,
				items : [StkGrpType, StkCat]
			},{
				columnWidth : 0.25,
				items : [InciCode, InciDesc]
			},{
				columnWidth : 0.25,
				items : [Vendor]
			}
		]
	}]
});

var InciGridPanel = new Ext.ux.GridPanel({
	region : 'west',
	width : 300,
	id : 'InciGridPanel',
	title : '物资信息',
	store : new Ext.data.JsonStore({
		url : actionUrl + '?actiontype=GetInci',
		root : 'rows',
		totalProperty : 'results',
		fields : ['InciId', 'InciCode', 'InciDesc', 'VendorId', 'VendorDesc'],
		listeners : {
			load : function(store, records, options){
				if(records.length > 0){
					InciGridPanel.getSelectionModel().selectFirstRow();
				}
			}
		}
	}),
	cm : new Ext.grid.ColumnModel([
		{header : 'InciId', dataIndex : 'InciId', align : 'left', width : 50, hidden : true},
		{header : '物资代码', dataIndex : 'InciCode', align : 'left', width : 80},
		{header : '物资名称', dataIndex : 'InciDesc', align : 'left', width : 120}
	]),
	viewConfig: {
		forceFit: true
	},
	sm : new Ext.grid.RowSelectionModel({
		singleSelect : true,
		listeners : {
			rowselect : function(sm, rowIndex, r){
				var VendorId = r.get('VendorId');
				var InciId = r.get('InciId');
				InciDetailGridPanel.getStore().removeAll();
				InciDetailGridPanel.getStore().load({
					params : {
						VendorId : VendorId,
						InciId : InciId
					},
					callback : function(r, options, success){
						if(!success){
							Msg.info('error', '查询有误!');
						}
					}
				});
			}
		}
	})
});

var InciDetailGridPanel = new Ext.ux.GridPanel({
	region : 'center',
	id : 'InciDetailGridPanel',
	title : '物资资质',
	sm : new Ext.grid.RowSelectionModel({
		listeners : {
			rowselect : function(sm, rowIndex, r){
				var VenIncId = r.get('VenIncId');
				InciQuaPicView.getStore().removeAll();
				InciQuaPicView.getStore().load({
					params : {
						VenIncId : VenIncId
					}
				});
			}
		}
	}),
	store : new Ext.data.JsonStore({
		url : actionUrl + '?actiontype=GetInciDetail',
		root : 'rows',
		totalProperty : 'results',
		fields : ['VenIncId', 'VenIncNo', 'VenIncDate', 'VenIncType', 'VenIncTypeDesc',
			'OrgId']
	}),
	cm : new Ext.grid.ColumnModel([
		{header : 'VenIncId', dataIndex : 'VenIncId', align : 'left', width : 120, hidden : true},
		{header : '资质名称', dataIndex : 'VenIncTypeDesc', align : 'left', width : 120},
		{header : '资质编号', dataIndex : 'VenIncNo', align : 'left', width : 120},
		{header : '资质效期', dataIndex : 'VenIncDate', align : 'left', width : 120},
		{header : 'OrgId', dataIndex : 'OrgId', align : 'left', width : 60}
	]),
	viewConfig: {
		forceFit: true,
		getRowClass : function(record,rowIndex,rowParams,store){ 
			var VenIncType = record.get('VenIncType');
			switch(VenIncType){
				case 'Manf_Name':
					return 'my_row_Red';
					break;
				case 'V1_Name':
					return 'my_row_Yellow';
					break;
				case 'V2_Name':
					return 'my_row_Yellow';
					break;
				case 'V3_Name':
					return 'my_row_Yellow';
					break;
				case 'V4_Name':
					return 'my_row_Yellow';
					break;
				case 'V5_Name':
					return 'my_row_Yellow';
					break;
				default:
					break;
			}
		}
	}
});

var WestInciPanel = new Ext.Panel({
	region : 'west',
	width : 600,
	layout : 'border',
	items : [InciGridPanel, InciDetailGridPanel]
});

var FtpSrc = 'http://' + gFtpParam[5];
var InciQuaPicTpl = new Ext.XTemplate(
	'<tpl for=".">',
		'<div style="padding:5px; height:230px; width:210px; float:left;" class="select_pic" >',
			'<img class="pic" src="' + FtpSrc + '{picsrc}"style="height:210; width:210;"position: relative;>',
			'<p><font color=blue size="2">{imgtype}</font></p>',
		'</div>',
	'</tpl>'
);

var InciQuaPicView = new Ext.DataView({
	store : new Ext.data.JsonStore({
		url : actionUrl+ '?actiontype=GetVenIncPic',
		root : 'rows',
		totalProperty : 'results',
		fields : ['rowid', 'picsrc', 'imgtype']
	}),
	tpl : InciQuaPicTpl,
	frame : true,
	singleSelect : true,
	autoScroll : true,
	trackOver : true,
	selectedClass : 'selected-pic',
	overClass : 'over-pic',
	itemSelector : 'div.select_pic',
	emptyText : '没有要显示的资质图片',
	listeners : {
		'dblclick' : function(view, index, node, e) {
			var src = view.getStore().getAt(index).get('picsrc');
			var type = view.getStore().getAt(index).get('imgtype');
			var allsrc = FtpSrc + src;
			var image = new Image();
			image.src = FtpSrc + src;
			var OpenWindow = window.open(allsrc,'','height='+(image.height+30)+',width='+(image.width+30)+',resizable=yes,scrollbars=yes,status =yes')
		}
	}
});

var CenterPicPanel = new Ext.Panel({
	region:'center',
	title:'图片',
	items:[InciQuaPicView]
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	new Ext.ux.Viewport({
		layout : 'border',
		items : [MainFormPanel, WestInciPanel, CenterPicPanel]
	});
	SearchBT.handler();
});