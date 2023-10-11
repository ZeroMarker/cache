
var CalcFieldConfUrl='herp.srm.calcfieldconfexe.csp';
///////////查询条件/////////////////////////////////////////////////////////////////
//年度
var YearSearchDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
YearSearchDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : CalcFieldConfUrl+'?action=yearlist&str='+encodeURIComponent(Ext.getCmp('YearSearchField').getRawValue()),
						method : 'POST'
					});
		});
var YearSearchField = new Ext.form.ComboBox({
            id:'YearSearchField',
			name:'YearSearchField',
			fieldLabel : '年度',
			width : 120,
			listWidth : 260,
			selectOnFocus : true,
			allowBlank : false,
			store : YearSearchDs,
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
var CodeField = new Ext.form.TextField({
	  id:'CodeField',
    fieldLabel: '编码',
	  width:120,
    //allowBlank: false,
    //emptyText:'编码...',
    anchor: '95%'
	});
var NameField = new Ext.form.TextField({
	  id:'NameField',
    fieldLabel: '名称',
	  width:120,
    //allowBlank: false,
    //emptyText:'名称...',
    anchor: '95%'
	});
//系统模块号
var SysModListDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
SysModListDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : CalcFieldConfUrl+'?action=sysmodelist&str='+encodeURIComponent(Ext.getCmp('SysModListField').getRawValue()),
						method : 'POST'
					});
		});
var SysModListField = new Ext.form.ComboBox({
            id:'SysModListField',
			name:'SysModListField',
			fieldLabel : '系统模块',
			width : 120,
			listWidth : 260,
			selectOnFocus : true,
			//allowBlank : false,
			store : SysModListDs,
			//anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // 本地模式
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
///////////EditGrid编辑框类型/////////////////////////////////////////////////////////////////
//年度
var YearListDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
YearListDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : CalcFieldConfUrl+'?action=yearlist&str='+encodeURIComponent(Ext.getCmp('YearField').getRawValue()),
						method : 'POST'
					});
		});
var YearField = new Ext.form.ComboBox({
            id:'YearField',
			name:'YearField',
			fieldLabel : '年度',
			width : 120,
			listWidth : 260,
			selectOnFocus : true,
			allowBlank : false,
			store : YearListDs,
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
//系统模块号
var SysModDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
SysModDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : CalcFieldConfUrl+'?action=sysmodelist&str='+encodeURIComponent(Ext.getCmp('SysModField').getRawValue()),
						method : 'POST'
					});
		});
var SysModField = new Ext.form.ComboBox({
            id:'SysModField',
			name:'SysModField',
			fieldLabel : '系统模块',
			width : 120,
			listWidth : 260,
			selectOnFocus : true,
			allowBlank : false,
			store : SysModDs,
			//anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // 本地模式
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
//是否由其他字段构成
var IsComprehensiveDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '是'], ['0', '否']]
		});
var IsComprehensiveField = new Ext.form.ComboBox({
			fieldLabel : '是否由其他字段构成',
			width : 120,
			listWidth : 150,
			selectOnFocus : true,
			//allowBlank : false,
			store : IsComprehensiveDs,
			//anchor : '90%',
			value:'1', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
//计算方法
var CalcMethodDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '比例系数法'], ['2', '公式法'], ['3', '等比步长法'], ['4', '非等比步长法'], ['5', '列举法']]
		});
var CalcMethodField = new Ext.form.ComboBox({
			fieldLabel : '计算方法',
			width : 120,
			listWidth : 150,
			selectOnFocus : true,
			//allowBlank : false,
			store : CalcMethodDs,
			//anchor : '90%',
			value:'1', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
/////////////////// 查询按钮 
var findButton = new Ext.Toolbar.Button({
	text: '查询',
	//tooltip: '查询',
	iconCls: 'search',
	handler: function(){
	    
		//var year = YearSearchField.getValue();
		var sysno = SysModListField.getValue();
		var code = CodeField.getValue();
		var name = NameField.getValue();
	
		itemGrid.load({
		    params:{
		    start:0,
		    limit:25,   
			SysNO:sysno,
		    Code: code,
		    Name: name
		   }
	  })
  }
});

var itemGrid = new dhc.herp.Grid({
        title: '参与科研绩效计算字段维护列表',
		iconCls: 'list',
        width: 400,
        edit:true,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: CalcFieldConfUrl,	  
		atLoad : true, // 是否自动刷新
		loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			      //edit:false,
            hidden: true
        },{
            id:'SysNO',
            header: '系统模块',
			      //allowBlank: false,
			      width:150,
            dataIndex: 'SysNO',
			allowBlank:false,
			type:SysModField
        },{
            id:'Code',
            header: '字段编码',
			allowBlank: false,
			width:120,
            dataIndex: 'Code'
        },{
            id:'Name',
            header: '字段名称',
			allowBlank: false,
			width:150,
            dataIndex: 'Name'
        },{
            id:'CalcMethod',
            header: '计算方法',
			allowBlank: false,
			width:100,
			hidden:false,
            dataIndex: 'CalcMethod',
			type:CalcMethodField
        },{
            id:'IsComprehensive',
            header: '是否由其他字段构成',
			//allowBlank: false,
			editable:true,
			width:150,
            dataIndex: 'IsComprehensive',
            type : IsComprehensiveField
        }
		/**,{
            id:'TableIndex',
            header: '字段指向表',
			      //allowBlank: false,
			      editable:true,
			      width:200,
            dataIndex: 'TableIndex'
        }**/
		],
        tbar :['','系统模块','',SysModListField,'','字段编码','', CodeField,'','字段名称','',NameField,'-',findButton]
});

    itemGrid.btnResetHide();  //隐藏重置按钮
    itemGrid.btnPrintHide();  //隐藏打印按钮
  //itemGrid.load({	params:{start:0, limit:25}});
