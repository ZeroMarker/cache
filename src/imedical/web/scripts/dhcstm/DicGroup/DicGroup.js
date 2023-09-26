// 名称:类组字典授权
// 编写日期:2015-11-3

var gGroupId=session['LOGON.GROUPID'];
var gCtLocId = session['LOGON.CTLOCID'];
var gUserId = session['LOGON.USERID'];

//安全组
var groupComboStore = new Ext.data.JsonStore({
    url: 'dhcstm.orgutil.csp?actiontype=GetGroup',
    root: 'rows',
    totalProperty : "results",
    fields: ['RowId', 'Description']
});

var groupCombo = new Ext.ux.ComboBox({
	fieldLabel : '安全组',
	id : 'groupCombo',
	width : 200,
	store : groupComboStore,
	filterName:'FilterDesc',
	listeners : {
		"select":function() {
			loaddata()
		}
	}
});

var Dicbutton=new Ext.ux.Button({
    text : '基础信息全选',
	iconCls : 'page_gear',
	handler : function() {
		Ext.getCmp('dic').items.each(function(subField){
			subField.setValue(true);
		});
	}
});
var Manfbutton=new Ext.ux.Button({
    text : '厂商信息全选',
	iconCls : 'page_gear',
	handler : function() {
		Ext.getCmp('manf').items.each(function(subField){
			subField.setValue(true);
		});
	}
});
var Vendorbutton=new Ext.ux.Button({
    text : '供应商信息全选',
	iconCls : 'page_gear',
	handler : function() {
		Ext.getCmp('vendor').items.each(function(subField){
			subField.setValue(true);
		});
	}
});
var Savebutton=new Ext.ux.Button({
    text : '保存',
	iconCls : 'page_save',
	handler : function() {

    	formpanel.getForm().submit({
		    clientValidation: true,
		    url:'dhcstm.dicgroupaction.csp?actiontype=Save',
		    params: {
		        DGGroupDR: Ext.getCmp('groupCombo').getValue()
		    },
		    success: function(form, action) {
		    	if(action.result.success=='true'){Msg.info('success','保存成功！')}
		    	else{
		    		switch (action.result.info) {
		    		case '-1':
		    		Msg.info('error','保存失败，安全组不能为空！');
		    		break;
		    		default:
		    		Msg.info('error','保存失败！');
		    		}
		    	}
		    }
		});
	}
})
var Resetbutton=new Ext.ux.Button({
    text : '清空',
	iconCls : 'page_clearscreen',
	handler : function() {
		formpanel.getForm().reset ()
	}
	})
var formpanel=new Ext.form.FormPanel({
	title:'字典安全组授权',
	labelAlign : 'right',
	frame : true,
	bodyStyle : 'padding:5px 0 0 0;',
	tbar:['安全组：',groupCombo,'-',Dicbutton,'-',Manfbutton,'-',Vendorbutton,'-',Savebutton,'-',Resetbutton],
    defaults:{xtype:'fieldset'},
	items:[
	{
		id:'dic',
		fieldLabel: '基础信息',
     	xtype:'checkboxgroup',
     	columns: 5,
		items:[
			{
			boxLabel : '物资代码',
			hideLabel : true,
			inputValue:'Y',
			id:'DGCode',
			name:'DGCode'
			},
			{
			boxLabel : '物资名称',
			hideLabel : true,
			inputValue:'Y',
			id:'DGDesc',
			name:'DGDesc'
			},
			{
			boxLabel : '收费类型',
			hideLabel : true,
			inputValue:'Y',
			id:'DGChargeType',
			name:'DGChargeType'
			},
			{
			boxLabel : '当前售价',
			hideLabel : true,
			inputValue:'Y',
			id:'DGSp',
			name:'DGSp'
			},
			{
			boxLabel : '招标进价',
			hideLabel : true,
			inputValue:'Y',
			id:'DGPbRp',
			name:'DGPbRp'
			},
			{
			boxLabel : '规格',
			hideLabel : true,
			inputValue:'Y',
			id:'DGSpec',
			name:'DGSpec'
			},
			{
			boxLabel : '类组',
			hideLabel : true,
			inputValue:'Y',
			id:'DGScg',
			name:'DGScg'
			},
			{
			boxLabel : '库存分类',
			hideLabel : true,
			inputValue:'Y',
			id:'DGStkcat',
			name:'DGStkcat'
			},
			{
			boxLabel : '品牌',
			hideLabel : true,
			inputValue:'Y',
			id:'DGBrand',
			name:'DGBrand'
			},
			{
			boxLabel : '单位',
			hideLabel : true,
			inputValue:'Y',
			id:'DGUom',
			name:'DGUom'
			},
			{
			boxLabel : '生产厂商',
			hideLabel : true,
			inputValue:'Y',
			id:'DGPbManf',
			name:'DGPbManf'
			},
			{
			boxLabel : '供应商',
			hideLabel : true,
			inputValue:'Y',
			id:'DGPbVendor',
			name:'DGPbVendor'
			},
			{
			boxLabel : '高值',
			hideLabel : true,
			inputValue:'Y',
			id:'DGHVFlag',
			name:'DGHVFlag'
			},
			{
			boxLabel : '注册证号码',
			hideLabel : true,
			inputValue:'Y',
			id:'DGCertNo',
			name:'DGCertNo'
			},
			{
			boxLabel : '供应科室',
			hideLabel : true,
			inputValue:'Y',
			id:'DGProvLoc',
			name:'DGProvLoc'
			},
			{
			boxLabel : '物资主图',
			hideLabel : true,
			inputValue:'Y',
			id:'DGPruPic',
			name:'DGPruPic'
			},{
				boxLabel : '物资普通图片',
				hideLabel : true,
				inputValue:'Y',
				id:'DGPruCommonPic'
			},{
				boxLabel : '物资说明书图片',
				hideLabel : true,
				inputValue:'Y',
				id:'DGPruDocumentPic'
			},
			{
			boxLabel : '供应链',
			hideLabel : true,
			inputValue:'Y',
			id:'DGItmSA',
			name:'DGItmSA',
			listeners : {
				check : function(checkbox, checked){
					if(checked){
						Ext.getCmp('DGPbManf').setValue(true);
						Ext.getCmp('DGPbVendor').setValue(true);
					}
				}
			}
			},
			{
			boxLabel : '入院审批材料',
			hideLabel : true,
			inputValue:'Y',
			id:'DGHospAllowed',
			name:'DGHospAllowed'
			}
		]
	},
	{
		id:'manf',
		fieldLabel: '厂商',
		xtype:'checkboxgroup',
     	columns: 5,
		items:[
			{
			boxLabel : '厂商注册证',
			hideLabel : true,
			inputValue:'Y',
			id:'DGMCert',
			name:'DGMCert'
			},
			{
			boxLabel : '器械生产许可',
			hideLabel : true,
			inputValue:'Y',
			id:'DGMMatProduct',
			name:'DGMMatProduct'
			},
			{
			boxLabel : '工商执照',
			hideLabel : true,
			inputValue:'Y',
			id:'DGMComLic',
			name:'DGMComLic'
			},
			{
			boxLabel : '工商注册号',
			hideLabel : true,
			inputValue:'Y',
			id:'DGMBusinessReg',
			name:'DGMBusinessReg'
			},
			{
			boxLabel : '组织机构代码',
			hideLabel : true,
			inputValue:'Y',
			id:'DGMOrgCode',
			name:'DGMOrgCode'
			},
			{
			boxLabel : '器械经营许可证',
			hideLabel : true,
			inputValue:'Y',
			id:'DGMMatManLic',
			name:'DGMMatManLic'
			}
			]
	},
	{
		id:'vendor',
		fieldLabel: '供应商',
		xtype:'checkboxgroup',
     	columns: 5,
		items:[
			{
			boxLabel : '授权书',
			hideLabel : true,
			inputValue:'Y',
			id:'DGVLic',
			name:'DGVLic'
			},
			{
			boxLabel : '工商执照',
			hideLabel : true,
			inputValue:'Y',
			id:'DGVComlic',
			name:'DGVComlic'
			},
			{
			boxLabel : '税务登记',
			hideLabel : true,
			inputValue:'Y',
			id:'DGVRevreg',
			name:'DGVRevreg'
			},
			{
			boxLabel : '医疗器械经营许可',
			hideLabel : true,
			inputValue:'Y',
			id:'DGVMatmanlic',
			name:'DGVMatmanlic'
			},
			{
			boxLabel : '医疗器械注册证',
			hideLabel : true,
			inputValue:'Y',
			id:'DGVMatenrol',
			name:'DGVMatenrol'
			},
			{
			boxLabel : '卫生许可证',
			hideLabel : true,
			inputValue:'Y',
			id:'DGVSanitation',
			name:'DGVSanitation'
			},
			{
			boxLabel : '组织机构代码',
			hideLabel : true,
			inputValue:'Y',
			id:'DGVOrgcode',
			name:'DGVOrgcode'
			},
			{
			boxLabel : 'GSP认证',
			hideLabel : true,
			inputValue:'Y',
			id:'DGVGsp',
			name:'DGVGsp'
			},
			{
			boxLabel : '器械生产许可',
			hideLabel : true,
			inputValue:'Y',
			id:'DGVMatpro',
			name:'DGVMatpro'
			},
			{
			boxLabel : '生产制造认可表',
			hideLabel : true,
			inputValue:'Y',
			id:'DGVPropermit',
			name:'DGVPropermit'
			},
			//2016-06-16 进口医疗器械注册证,进口注册登记表,代理销售授权书 目前界面上没有维护
			/*{
			fieldLabel:'进口医疗器械注册证',
			inputValue:'Y',
			id:'DGVImpenrol',
			name:'DGVImpenrol'
			},
			{
			fieldLabel:'进口注册登记表',
			inputValue:'Y',
			id:'DGVImplic',
			name:'DGVImplic'
			},
			{
			fieldLabel:'代理销售授权书',
			inputValue:'Y',
			id:'DGVAgentlic',
			name:'DGVAgentlic'
			},*/
			{
			boxLabel : '质量承诺书',
			hideLabel : true,
			inputValue:'Y',
			id:'DGVQuality',
			name:'DGVQuality'
			},
			{
			boxLabel : '业务员授权书',
			hideLabel : true,
			inputValue:'Y',
			id:'DGVSales',
			name:'DGVSales'
			}
			]
	}
	]
})
function loaddata(){
	Ext.Ajax.request({
		url : 'dhcstm.dicgroupaction.csp?actiontype=LoadData&DGGroupDR='+Ext.getCmp('groupCombo').getValue(),
		method : 'POST',
		waitMsg : '查询中...',
		success : function(result,request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			formpanel.getForm().setValues(jsonData);
		},
		scope : this
	});
}
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	new Ext.ux.Viewport({
		layout:'fit',
		items:[formpanel]
	});
});
