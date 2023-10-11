var AcctCheckItem = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

AcctCheckItem.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.acct.acctcheckitemmapexe.csp?action=AcctCheckItemList',
						method : 'POST'
					});
		});

var AcctCheckItemCombo = new Ext.form.ComboBox({
			fieldLabel : '核算类别项目',
			store : AcctCheckItem,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
//SysBusiModuleCode
var SysBusiModule = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowid', 'name'])
});

SysBusiModule.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.acct.acctcheckitemmapexe.csp?action=SysBusiModuleList',
				method : 'POST'
			});
});

var SysBusiModuleCombo = new Ext.form.ComboBox({
	fieldLabel : '系统业务',
	store : SysBusiModule,
	displayField : 'name',
	valueField : 'rowid',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 100,
	pageSize : 10,
	minChars : 1,
	columnWidth : .1,
	selectOnFocus : true
});
var itemGrid = new dhc.herp.Grid({
        title: '核算项目接口配置维护',
        width: 400,
        //edit:false,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'herp.acct.acctcheckitemmapexe.csp',	  
		//tbar:delButton,
		atLoad : true, // 是否自动刷新
		loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'AcctCheckItemID',
            header: '核算类别项',
			width:200,
            dataIndex: 'AcctCheckItemID',
            hidden: false,
            type:AcctCheckItemCombo
        },{
            id:'code',
            header: '项目编码',
			allowBlank: false,
			width:200,
            dataIndex: 'code'
        },{
            id:'name',
            header: '项目名称',
			allowBlank: false,
			width:200,
            dataIndex: 'name'
        },{
            id:'BusiModuleCode',
            header: '系统业务',
			width:200,
            dataIndex: 'BusiModuleCode',
            type:SysBusiModuleCombo,
            hidden: false
        }] 
});

    itemGrid.hiddenButton(3);
	itemGrid.hiddenButton(4);
