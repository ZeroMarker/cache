// /名称: 付款汇总
// /描述: 付款单汇总
// /编写者：zhangxiao
// /编写日期: 2014.09.04

var StrParam="";
var gIncId="";
var gGroupId=session['LOGON.GROUPID'];

Ext.onReady(function() {
	Ext.QuickTips.init();// 浮动信息提示
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	Ext.Ajax.timeout = 900000;
	var GetPaymodeStore=new Ext.data.Store({
		url:"dhcstm.payaction.csp?actiontype=GetPayMode",
		reader:new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results',
			fields:[{name:'RowId',mapping:'rowid'},{name:'Description',mapping:'payDesc'},'payCode']
		})
	});
	var PayMode = new Ext.ux.form.LovCombo({
		id : 'PayMode',
		fieldLabel : '支付方式',
		anchor: '90%',
		separator:',',	//科室id用^连接
		store : GetPaymodeStore,
		valueField : 'RowId',
		displayField : 'Description',
		triggerAction : 'all'
	});
	var StDateField=new Ext.ux.DateField ({
				xtype: 'datefield',
				fieldLabel: '开始日期',
				name: 'startdt',
				id: 'startdt',
				anchor : '90%',
				value:new Date
			});
			
	var EndDateField=new Ext.ux.DateField ({
			fieldLabel: '截止日期',
			name: 'enddt',
			id: 'enddt',
			anchor : '90%',
			value:new Date
		});


	var FindTypeData=[['未完成','N'],['完成','Y'],['全部','']];
	var FindTypeStore = new Ext.data.SimpleStore({
		fields: ['Description', 'RowId'],
		data : FindTypeData
	});

	var FindTypeCombo = new Ext.form.ComboBox({
		store: FindTypeStore,
		valueField : 'RowId',
		displayField:'Description',
		mode: 'local', 
		anchor : '90%',
		emptyText:'',
		id:'FindTypeCombo',
		fieldLabel : '单据状态',
		triggerAction:'all'
	});
	Ext.getCmp("FindTypeCombo").setValue("");
	
	var FindVendor = new Ext.ux.VendorComboBox({
		fieldLabel : '供应商',
		id : 'FindVendor',
		name : 'FindVendor',
		anchor : '90%',
		emptyText : '供应商...',
		params : {LocId : 'PhaLoc'}
	});
	//科室名称
	var PhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '采购科室',
					id : 'PhaLoc',
					name : 'PhaLoc',
					anchor:'90%',
					width : 100,
					emptyText : '采购科室...',
					groupId:gGroupId,
					childCombo : 'FindVendor'
				});

	var FindButton = new Ext.Button({
			height : 30,
			width : 70,
			id:"FindButton",
			text: '统计',
			iconCls : 'page_find',
			tooltip:'统计付款数据',
			icon:"../scripts/dhcpha/img/find.gif",
			listeners:{
				"click":function(){
					FindData();
				}
			}
		});
	
	var StatType = new Ext.form.RadioGroup({
		//fieldLabel : '统计方式',
		id : 'StatType',
		columns : 1,
		anchor : '90%',
		items : [
			{boxLabel : '供应商汇总', name : 'StatType', inputValue : 'VendorStat', checked : true},
			{boxLabel : '供应商明细汇总', name : 'StatType', inputValue : 'VendorItmStat'},
			{boxLabel : '付款单汇总', name : 'StatType', inputValue : 'PayNoStat'}
		]
	});
	
	var QueryForm = new Ext.ux.FormPanel({
		labelWidth : 80,
		region : 'west',
		title:'付款单汇总',
		frame : true,
		width:330,
		tbar:[FindButton],
		items : [{
				xtype : 'fieldset',
				title : '查询条件',
				items : [StDateField,EndDateField,PhaLoc,PayMode,FindVendor,FindTypeCombo]
			}, {
				xtype : 'fieldset',
				title : '报表类型',
				items : [StatType]
			}]
	});
	
	var QueryTabs = new Ext.TabPanel({
		region: 'center',
		id:'TblTabPanel',
		margins:'3 3 3 0',
		activeTab: 0,
		items:[{
			title: '统计列表',
			id:'list',
			frameName: 'list',
			html: '<iframe id="list" width=100% height=100% src= ></iframe>'
		}]
	});

	///框架定义
	var port = new Ext.ux.Viewport({
				layout : 'border',
				items : [QueryForm,QueryTabs]
			});
	//查询数据
	function FindData(){
		//GetStrParam();
		var sdate=Ext.getCmp("startdt").getValue();
		var edate=Ext.getCmp("enddt").getValue();
		if(sdate!=""){
			sdate = sdate.format(ARG_DATEFORMAT);
		}
		if(edate!=""){
			edate = edate.format(ARG_DATEFORMAT);
		}
		var phaLoc=Ext.getCmp("PhaLoc").getValue();
		var phadesc=Ext.getCmp("PhaLoc").getRawValue();
		if(phaLoc==""){
			Msg.info("warning","采购科室不能为空!");
			return;
		}
		var paymode=Ext.getCmp("PayMode").getValue();
		var vendor = Ext.getCmp('FindVendor').getValue();
		var findtype=Ext.getCmp("FindTypeCombo").getValue();
		var qPar="^"
		var p = Ext.getCmp("TblTabPanel").getActiveTab();
		var iframe = p.el.dom.getElementsByTagName("iframe")[0];
		var StatType = Ext.getCmp("StatType").getValue().getGroupValue();
		var RaqName = '';
		if(StatType == 'VendorStat'){
			//供应商汇总
			RaqName = 'DHCSTM_PayStat.raq';
		}else if(StatType == 'VendorItmStat'){
			//供应商明细汇总
			RaqName = 'DHCSTM_PayStat2.raq';
		}else if(StatType == 'PayNoStat'){
			//付款单汇总
			RaqName = 'DHCSTM_PayStat_payno.raq';
		}
		iframe.src = PmRunQianUrl + '?reportName=' + RaqName
			+'&sdate='+ sdate + '&edate=' + edate + '&phaLoc=' + phaLoc +'&vendor=' + vendor +'&findtype=' + findtype
			+'&qPar=' + qPar + '&paymode=' + paymode + '&phadesc=' + phadesc;
	}
});