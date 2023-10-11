//creator：赵伟
//date:2013年9月6日10:55:41
var userAcctBookUrl = '../csp/herp.acct.useracctbookexe.csp';
//AcctBook数据源用于查询
var AcctBookDs  = new Ext.data.Store({
    autoLoad:true,
    proxy:"",
    reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

AcctBookDs.on('beforeload', function(ds, o){
    ds.proxy=new Ext.data.HttpProxy({
    
        url:userAcctBookUrl+'?action=AcctBooklist',method:'POST'})
        });

var AcctBookField  = new Ext.form.ComboBox({
    id: 'AcctBookField',
    fieldLabel: '单位帐套',
    width:200,
    listWidth : 200,
    //allowBlank: false,
    store: AcctBookDs,
    valueField: 'rowid',
    displayField: 'name',
    triggerAction: 'all',
    emptyText:'请选择单位帐套...',
    name: 'AcctBookField',
    minChars: 1,
    pageSize: 10,
    selectOnFocus:true,
    forceSelection:'true',
    editable:true
});
//AcctBook数据源用于grid插入数据
var gridAcctBookDs  = new Ext.data.Store({
    autoLoad:true,
    proxy:"",
    reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

gridAcctBookDs.on('beforeload', function(ds, o){
    ds.proxy=new Ext.data.HttpProxy({
    
        url:userAcctBookUrl+'?action=AcctBooklist',method:'POST'})
        });

var gridAcctBookField  = new Ext.form.ComboBox({
    id: 'gridAcctBookField',
    fieldLabel: '单位帐套',
    width:200,
    listWidth : 200,
    //allowBlank: false,
    store: gridAcctBookDs,
    valueField: 'rowid',
    displayField: 'name',
    triggerAction: 'all',
    emptyText:'请选择单位帐套...',
    name: 'gridAcctBookField',
    minChars: 1,
    pageSize: 10,
    selectOnFocus:true,
    forceSelection:'true',
    editable:true
});
//会计用户数据源用于grid插入时查询用户
var acctUserDs  = new Ext.data.Store({
    autoLoad:true,
    proxy:"",
    reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

acctUserDs.on('beforeload', function(ds, o){
    ds.proxy=new Ext.data.HttpProxy({
    
        url:userAcctBookUrl+'?action=acctUserlist',method:'POST'})
        });

var acctUserField  = new Ext.form.ComboBox({
    id: 'acctUserField',
    fieldLabel: '会计用户',
    width:120,
    listWidth : 245,
    //allowBlank: false,
    store: acctUserDs,
    valueField: 'rowid',
    displayField: 'name',
    triggerAction: 'all',
    emptyText:'请选择会计用户...',
    name: 'acctUserField',
    minChars: 1,
    pageSize: 10,
    selectOnFocus:true,
    forceSelection:'true',
    editable:true
});
//用户数据源，用于查询时的条件
var maybeacctUserField = new Ext.form.TextField({
    id: 'maybeacctUserField',
    fieldLabel: '会计用户',
    width:145,
    listWidth : 245,
    //valueField: 'rowid',
    //displayField: 'name',
    triggerAction: 'all',
    emptyText:'模糊查询...',
    name: 'maybeacctUserField',
    minChars: 1,
    pageSize: 10,
    selectOnFocus:true,
    forceSelection:'true',
    editable:true
});
var findButton = new Ext.Toolbar.Button({
    text: '查询',
    tooltip:'查询',        
    iconCls:'find',
    handler:function(){
    
    var AcctBook=AcctBookField.getValue();
    var acctUser=maybeacctUserField.getValue();
    
    itemGrid.load(({params:{start:InDeptSetsPagingToolbar.cursor, limit:25,AcctBook:AcctBook,acctUser:acctUser}}));
    
    }
});
//是否当前帐套
var driectStore = new Ext.data.SimpleStore({
    fields:['key','keyValue'],
    data:[['0','否'],['1','是']]
});
var driectField = new Ext.form.ComboBox({
    id: 'driectField',
    fieldLabel: '是否当前帐套',
    width:100,
    listWidth : 130,
    selectOnFocus: true,
    allowBlank: false,
    store: driectStore,
    //anchor: '90%',
    valueNotFoundText:'',
    displayField: 'keyValue',
    valueField: 'key',
    triggerAction: 'all',
    //emptyText:'选择期间类型...',
    mode: 'local', //本地模式
    editable:true,
    pageSize: 10,
    minChars: 1,
    selectOnFocus:true,
    forceSelection:true
});

var queryPanel = new Ext.form.FormPanel({
		title: '帐套权限维护',
		iconCls:'maintain',
		height: 70,
		width: 400,
		region: 'north',
		frame: true,
		labelWidth: 140,
		// labelAlign:'right',
		// autoHeight:true,
		defaults: {
			bodyStyle: 'padding:5px'
		},
		items: [{
            xtype : 'panel',
            layout : 'column',
            items : [{
            	xtype : 'displayfield',
            	value : '单位帐套',
            	width : 60
            },AcctBookField,{
           		xtype : 'displayfield',
           		value : '',
           		style : 'padding-top:3px;',
           		width : 50
           	},{
           		xtype : 'displayfield',
           		value : '会计用户',
           		width : 60
           	},maybeacctUserField,{
           		xtype : 'displayfield',
           		value : '',
           		style : 'padding-top:3px;',
           		width : 50
           	},findButton]
        }]
});

var itemGrid = new dhc.herp.Grid({      
        width: 400,
        //edit:false,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'herp.acct.useracctbookexe.csp',    
        atLoad : true, // 是否自动刷新
        loadmask:true,
        fields: [{
            id:'rowid',
            header: 'ID',
            dataIndex: 'rowid', //acctdeptID
            edit:false,
            editable:false,
            hidden: true
        },{
            id:'AcctBookID',
            header: '<div style="text-align:center">单位账套</div>',
            allowBlank: false,
            width:200,
            dataIndex: 'AcctBookID',    
            type:gridAcctBookField  
        },{
            id:'acctUserID',
            header: '<div style="text-align:center">会计用户ID</div>',
            allowBlank: true,
            width:120,
            dataIndex: 'acctUserID',
            hidden: true
        },{
            id:'acctUserName',
            header: '<div style="text-align:center">会计用户</div>',
            allowBlank: false,
            width:120,
            dataIndex: 'acctUserName',
            type:acctUserField
        },{
            id:'isCurrAcct',
            header: '<div style="text-align:center">是否当前帐套</div>',
            align:'center',
            allowBlank: true,
            width:110,
            editable:false,
            emptyText:'默认为否',
            dataIndex: 'isCurrAcct',
            type:driectField
        }] 
});
var InDeptSetsPagingToolbar = new Ext.PagingToolbar({//分页工具栏
        pageSize: 25,
        store: itemGrid,
        displayInfo: true,
        displayMsg: '当前显示{0} - {1}，共计{2}',
        emptyMsg: "没有数据"//,
        //buttons: ['-',InDeptSetsFilterItem,'-',InDeptSetsSearchBox]
});

    //itemGrid.hiddenButton(3);
    //itemGrid.hiddenButton(4);
    itemGrid.btnResetHide()     //隐藏重置按钮
    itemGrid.btnPrintHide()     //隐藏打印按钮
