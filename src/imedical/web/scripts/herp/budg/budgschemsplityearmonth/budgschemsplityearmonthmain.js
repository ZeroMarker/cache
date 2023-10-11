var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var BudgSchemSplitYearMonthUrl = 'herp.budg.budgschemsplityearmonthexe.csp';

// 年度
var yearDs  = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['year','year'])
});
yearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:commonboxUrl+'?action=year',method:'POST'})
		});
var yearField  = new Ext.form.ComboBox({
	id: 'yearField',
	fieldLabel: '预算年度',
	width:120,
	listWidth : 245,
	// allowBlank: false,
	store: yearDs,
	valueField: 'year',
	displayField: 'year',
	triggerAction: 'all',
	emptyText:'请选择年度...',
	name: 'yearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	columnWidth:.166,
	forceSelection:'true',
	editable:true,
	listeners:{
		select:{fn:function(combo,record,index) { 
			BSMnameDs.removeAll();
			BSMnameField.setValue('');     				
			BSMnameDs.load({params:{start:0,limit:10,year:combo.value,flag:2}});
		}}
	}
});

// 预算方案
var BSMnameDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
BSMnameDs.on('beforeload', function(ds, o){
	var Year=yearField.getValue();
	ds.proxy=new Ext.data.HttpProxy({
	
		url:commonboxUrl+'?action=bsm&flag=1&year='+Year,method:'GET'})
		});
var BSMnameField = new Ext.form.ComboBox({
	id: 'BSMnameField',
	fieldLabel: '预算方案',
	width:120,
	listWidth : 245,
	// allowBlank: false,
	store: BSMnameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'预算方案...',
	name: 'BSMnameField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	columnWidth:.166,
	forceSelection:'true',
	editable:true
});

// 预算项大类
var BIDTypeFirstnameStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['1','会计科目'],['2','医疗指标']]
});
var BIDTypeFirstnameField = new Ext.form.ComboBox({
	id: 'BIDTypeFirstnameField',
	fieldLabel: '预算项大类',
	width:120,
	listWidth : 245,
	selectOnFocus: true,
	allowBlank: true,
	store: BIDTypeFirstnameStore,
	anchor: '90%',
	// value:'key', //默认值
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'预算项大类...',
	mode: 'local', // 本地模式
	editable:true,
	pageSize: 10,
	minChars: 15,
	selectOnFocus:true,
	forceSelection:true
});

// 预算项类别
var BITnameDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
});
BITnameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url:commonboxUrl+'?action=itemtype&flag=1',method:'POST'})
		});
var BITnameField = new Ext.form.ComboBox({
	id: 'BITnameField',
	fieldLabel: '预算项类别',
	width:120,
	listWidth : 245,
	// allowBlank: false,
	store: BITnameDs,
	valueField: 'code',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'预算项类别...',
	name: 'BITnameField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	columnWidth:.15,
	forceSelection:'true',
	editable:true
});

// 预算项编码
var codeField = new Ext.form.TextField({
	id: 'codeField',
	fieldLabel: '预算项编码',
	width:120,
	listWidth : 245,
	triggerAction: 'all',
	emptyText:'模糊查询...',
	name: 'codeField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	columnWidth:.15,
	editable:true
});


var queryPanel = new Ext.FormPanel({
	height : 120,
	region : 'north',
	frame : true,
	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<left><p style="font-weight:bold;font-size:100%">全院预算分解方法设置（年度预算——月预算）</p></center>',
			columnWidth : 1,
			height : '30'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
		{
					xtype : 'displayfield',
					value : '预算年度:',
					columnWidth : .08
				}, yearField,

				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .08
				}, {
					xtype : 'displayfield',
					value : '预算方案:',
					columnWidth : .08
				}, BSMnameField, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .08
				}, {
					xtype : 'displayfield',
					value : '预算项大类:',
					columnWidth : .08
				}, BIDTypeFirstnameField,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .07
				}
				]
	},
	{
		xtype: 'panel',
		layout:"column",
		items: [
				{
					xtype : 'displayfield',
					value : '预算项类别:',
					columnWidth : .07
				}, BITnameField, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .07
				},{
					xtype : 'displayfield',
					value : '预算项编码:',
					columnWidth : .07
				}, codeField, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .07
				},{
					columnWidth:.07,
					xtype:'button',
					text: '查询',
					handler:function(b)
					{
						var Year=yearField.getValue();
						var BSMName=BSMnameField.getValue();
						var Code=codeField.getValue();
						var BITName=BITnameField.getValue();
						var BIDTypeFirstName=BIDTypeFirstnameField.getValue();
						itemGrid.load((
						{
							params:
							{
									start : 0,
								    limit : 25,
								    Year:Year,BSMName:BSMName
								    ,Code:Code,BITName:BITName
								    ,BIDTypeFirstName:BIDTypeFirstName
							 }
			    		}));
					},
					iconCls: 'add'
				}	
				]
		}
		]
	});

var editrButton = new Ext.Toolbar.Button({
	text: '分解方法+调节比例',
    tooltip:'批量处理',        
    iconCls:'add',
	handler:function(){
		//批量处理--分解方法+调节比例
		batchEditFun(itemGrid);
	}
});	

// 是否末级
var IsLastStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['0','否'],['1','是']]
});
var IsLastStoreField = new Ext.form.ComboBox({
	id: 'IsLastStoreField',
	fieldLabel: '是否末级',
	store: IsLastStore,
	anchor: '90%',
	// value:'key', //默认值
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	// emptyText:'选择模块名称...',
	mode: 'local', // 本地模式
	editable:false
});

// 分解方法设置
var bssmsplitmethStoreField = new Ext.form.ComboBox({												
				fieldLabel: '分解方法设置',
				width:120,
				anchor: '90%',
				store : new Ext.data.ArrayStore({
					fields:['key','keyValue'],
					data : [['1', '历史数据'], ['2', '历史数据*调节比例'], ['3', '比例系数'],
							['4', '全面贯彻'], ['5', '均摊']]
				}),
				displayField : 'keyValue',
				valueField : 'key',
				typeAhead : true,
				mode : 'local',
				///value : '0',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});

var itemGrid = new dhc.herp.Grid({
    //title: '全院预算分解方法设置（年度预算——月预算）',
    width: 400,
    // edit:false, //是否可编辑
    // readerModel:'local',
    region: 'center',
    atLoad : true, // 是否自动刷新
    url: 'herp.budg.budgschemsplityearmonthexe.csp',
    listeners:{
        'cellclick' : function(grid, rowIndex, columnIndex, e) {
		//alert(columnIndex)
               var record = grid.getStore().getAt(rowIndex);
               // alert(columnIndex)
               // 根据条件设置单元格点击编辑是否可用
               if ((record.get('bidislast') == '0') && ((columnIndex == 7) || (columnIndex == 8))) {    
                      return false;
               } else 
                      {
                      return true;
                      }
        },        
        'celldblclick' : function(grid, rowIndex, columnIndex, e) {
            var record = grid.getStore().getAt(rowIndex);
            // alert(columnIndex)
            // 根据条件设置单元格点击编辑是否可用
            if ((record.get('bidislast') == '0')  && ((columnIndex == 8) || (columnIndex == 7))) {      
                   return false;
            } else 
                   {
                   return true;
                   }
     }
},
    
    tbar:[editrButton,'-'],
    fields: [
    new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: 'ID',
        hidden: true,
        dataIndex: 'rowid'
        
    },{
		id : 'CompName',
		header : '医疗单位',
		width : 90,
		hidden: true,
		editable : false,
		dataIndex : 'CompName'

	},{
        id:'bidyear',
        header: '预算年度',
        dataIndex: 'bidyear',
        width:75,
        update:true,
		editable:false,
		hidden: false
    },{ 
        id:'bidcode',
        header: '预算项编码',
        dataIndex: 'bidcode',
        width:150,
        update:true,
		editable:false,
		hidden: false
    }, {
        id:'bidname',
        header: '预算项名称',
		width:250,
		editable:false,
        dataIndex: 'bidname'
	
    }, {
        id:'bssmsplitmeth',
        header: '分解方法设置',
        width:150,
        editable:true,
        dataIndex: 'bssmsplitmeth',
        allowBlank: true,
        renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
    	var sf = record.data['bidislast']
    	var rd = record.data['rowid']
    	cellmeta.css="cellColor3";
            if ((sf == 1)&&(rd!="")) {
                   return '<span style="cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
            } else {
                   '<span style="cursor:hand"><u></u></span>';
            }
    	},
        type:bssmsplitmethStoreField
    }, {
        id:'coefficient',
        header: '调解比例系数',
        width:150,
		allowBlank: true,
		editable:false,
		overrender:true,
		renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
	    	var sf = record.data['bidislast']
	        var rd = record.data['rowid']
	        var bssmsplitmeth = record.data['bssmsplitmeth']
	            if ((sf == 1)&&(rd!="")) {
	                   cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
	                   return '<span style="cursor:hand;backgroundColor:red"><u>维护数据</u></span>';
	            } else {
	                   '<span style="cursor:hand"><u></u></span>';
	            }
	    	},
        dataIndex: 'coefficient'
	
    }, {
        id:'bidislast',
        header: '是否末级',
        width:150,
		// tip:true,
		allowBlank: true,
		editable:false,
		update:true,
        dataIndex: 'bidislast',
        hidden: true,
        type:IsLastStoreField
		
    }
	],
	viewConfig : {
		forceFit : true
	}

});

//单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	var records = itemGrid.getSelectionModel().getSelections();
	var detailID = records[0].get("rowid")
	if(detailID!=""){
	if (columnIndex == 8) {
		// 维护数据页面
		DetailFun(detailID);
	}
}
})

itemGrid.btnAddHide();  	//隐藏增加按钮
//itemGrid.btnSaveHide();   //隐藏保存按钮
itemGrid.btnResetHide();    //隐藏重置按钮
itemGrid.btnDeleteHide();   //隐藏删除按钮
itemGrid.btnPrintHide();    //隐藏打印按钮