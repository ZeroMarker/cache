
var acctbookid= IsExistAcctBook();

//币种ID下拉列表框 
var unitDs = new Ext.data.Store({
    autoLoad:true,
    proxy:"",
    reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
unitDs.on('beforeload', function(ds, o){
    ds.proxy=new Ext.data.HttpProxy({
    url:'herp.acct.acctCurRateexe.csp'+'?action=caldept',method:'POST'});
});
var unitField = new Ext.form.ComboBox({
    id: 'unitField',
    fieldLabel: '币种ID',
    width:200,
    listWidth : 300,
    allowBlank: true,
    store: unitDs,
    valueField: 'rowid',
    displayField: 'name',
    triggerAction: 'all',
    emptyText:'请选择币种ID...',
    name: 'unitField',
    minChars: 1,
    pageSize: 10,
    selectOnFocus:true,
    forceSelection:'true',
    editable:true
});


//会计年度/期间
var acctsubjField = new Ext.form.TextField({
    id: 'acctsubjField ',
    fieldLabel: '会计科目',
    width:150,
    listWidth : 150,
    //allowBlank: false,
    //store: yearDs,
    //valueField: 'rowid',
    //displayField: 'name',
    triggerAction: 'all',
    emptyText:'模糊查询...',
    name: 'acctsubjField ',
    minChars: 1,
    pageSize: 10,
    selectOnFocus:true,
    forceSelection:'true',
    editable:true
});

//币种查询
var acctuserFieldDs = new Ext.data.Store({
    autoLoad:true,
    proxy:"",
    reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
acctuserFieldDs.on('beforeload', function(ds, o){
    ds.proxy=new Ext.data.HttpProxy({
    url:'herp.acct.acctCurRateexe.csp'+'?action=caldept',method:'POST'});
});
var acctuserField = new Ext.form.ComboBox({
    id: 'acctuserField',
    fieldLabel: '币种ID',
    store: acctuserFieldDs,
    width:200,
    listWidth : 260,
    valueField: 'rowid',
    displayField: 'name',
    triggerAction: 'all',
    emptyText:'模糊查询...',
    name: 'acctuserField',
    minChars: 1,
    pageSize: 10,
    selectOnFocus:true,
    forceSelection:'true',
    editable:true
    
});



//查询按钮
var findButton = new Ext.Toolbar.Button({
    text: '查询', 
        tooltip:'查询',        
        iconCls:'find',
    handler:function(){
    
    var acctsubj=acctsubjField.getValue();
    
    var acctuser=acctuserField.getValue();
    
    itemGrid.load({
                params:{
                sortField:'',
                sortDir:'',
                start:0,
                limit:25,
                acctbookid:acctbookid,
                acctsubj:acctsubj,
                acctuser:acctuser
                }
            }); 
    
    //itemGrid.load(({params:{start:0,limit:25,acctsubj:acctsubj,acctuser:acctuser}}));
    
    }
});


//只能输数字
var bibbrejectmoneyField = new Ext.form.TextField({
    id: 'bibbrejectmoneyField',
    //fieldLabel: '预算项编码',
    width:215,
    regex : /^(-?\d+)(\.\d+)?$/,
    regexText : "只能输入数字",

    name: 'bibbrejectmoneyField',
    editable:true
});
//tbar:['会计年度/期间:',acctsubjField,'-','币种:',acctuserField,'-',findButton],
var queryPanel = new Ext.form.FormPanel({
		title: '币种汇率维护',
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
            	value : '会计年度/期间',
				style:'padding:0px 10px;'
            	//width : 60
            },acctsubjField,{
           		xtype : 'displayfield',
           		value : '',
           		width : 50
           	},{
            	xtype : 'displayfield',
            	value : '币种',
				style:'padding:0px 10px;'
            	//width : 60
            },acctuserField,{
           		xtype : 'displayfield',
           		value : '',
           		width : 50
           	},findButton]
        }]
});

var itemGrid = new dhc.herp.Grid({
    //title: '币种汇率表',
    width: 400,
    //edit:false,                   //是否可编辑
    //readerModel:'local',
    region: 'center',
    atLoad : true, // 是否自动刷新
    url: 'herp.acct.acctCurRateexe.csp',
    
   // tbar:['会计年度/期间:',acctsubjField,'-','币种:',acctuserField,'-',findButton],

    fields: [
//new Ext.grid.CheckboxSelectionModel({editable:false}),
    {   
        id:'acctCurRateID',
        header: '<div style="text-align:center">币种汇率ID</div>',
        hidden: true,
        print:false,
        align: 'center',
        dataIndex: 'rowid'
 
    },{ 
        id:'acctbookid',
        header: '<div style="text-align:center">账套ID</div>',
        hidden: true,
        print:false,
        align: 'center',
        dataIndex: 'bookid'
 
    },{
        id:'acctYear',
        header: '<div style="text-align:center">会计年度</div>',
        dataIndex: 'acctYear',
        width:70,
        align: 'center',
        editable:true,
        allowBlank: false,
        hidden: false,
        type:bibbrejectmoneyField
    },{ 
        id:'acctMonth',
        header: '<div style="text-align:center">会计月份</div>',
        dataIndex: 'acctMonth',
        width:70,
        align: 'center',
        editable:true,
        allowBlank: false,
        hidden: false,
        type:bibbrejectmoneyField
    }, {
        id:'acctCurID',
        header: '<div style="text-align:center">币种</div>',
        //tip:true,
        allowBlank: false,
        //align: 'right',
        width:80,
        align: 'center',
        editable:true,
        dataIndex: 'acctCurID',
        type:unitField
    
    }, {
        id:'startRate',
        header: '<div style="text-align:center">期初汇率</div>',
        width:150,
        align: 'right',
        //align: 'center',
        allowBlank: true,
        editable:true,
        dataIndex: 'startRate',
        type:bibbrejectmoneyField
        
    }, {    
        id:'endRate',
        header: '<div style="text-align:center">期末汇率</div>',
        width:150,
        align: 'right',
        //align: 'center',
        update:true,
        editable:true,
        allowBlank: true,
        dataIndex: 'endRate',
        type:bibbrejectmoneyField   
    },  {
        id:'averRate',
        header: '<div style="text-align:center">平均汇率</div>',
        width:150,
        align: 'right',
        //align: 'center',
        allowBlank: true,
        editable:false,
        dataIndex: 'averRate',
        type:bibbrejectmoneyField
        
    }]

});

    
 /* itemGrid.load({
        params:{
            start:0,
            limit:25,
            acctbookid:acctbookid
            }
            }); */ 

//itemGrid.btnAddHide();  //隐藏增加按钮
itemGrid.btnResetHide();  //隐藏重置按钮
itemGrid.btnDeleteHide(); //隐藏删除按钮
itemGrid.btnPrintHide();  //隐藏打印按钮



