//var username = session['LOGON.USERCODE'];

var projUrl = 'dhc.bonus.module.FUNCmaintainexe.csp';

// ///////////////////函数标识
var funcodeText = new Ext.form.TextField({
	width : 120,
	listWidth : 240,
	pageSize : 10,
	minChars : 1,
	selectOnFocus : true
});

// ///////////////////函数名称
var funnameText = new Ext.form.TextField({
	width : 120,
	listWidth : 240,
	pageSize : 10,
	minChars : 1,
	selectOnFocus : true
});

/////////////////// 查询按钮 //////////////////
var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
	    var FunName  = funnameText.getValue();
	    var FunCode = funcodeText.getValue();
		itemGrid.load({params:{start:0,limit:25,FunName:FunName,FunCode:FunCode}});
		
	}
});

var itemGrid = new dhc.herp.Grid({
        title: '奖金函数维护',
        width: 400,
        edit:true,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.module.FUNCmaintainexe.csp',	  
		atLoad : true, // 是否自动刷新
		loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			      edit:false,
            hidden: true
        },{
            id:'funcode',
            header: '函数标识',
			allowBlank: true,
			width:120,
            dataIndex: 'funcode'
        },{
            id:'funname',
            header: '函数名称',
			allowBlank: true,
			width:80,
            dataIndex: 'funname'
        },{
            id:'fundesc',
            header: '功能描述',
			allowBlank: true,
			width:120,
            dataIndex: 'fundesc'
        },{
            id:'funclass',
            header: '函数M类',
			allowBlank: true,
			width:120,
            dataIndex: 'funclass'
        },{
            id:'paradesc',
            header: '参数说明',
			allowBlank: true,
			width:120,
            dataIndex: 'paradesc'
        },{
            id:'creattdate',
            header: '创建日期',
			allowBlank: true,
			editable:false,
			width:120,
            dataIndex: 'creattdate'
        }],
        
       tbar:['函数名称',funnameText,'-','函数标识',funcodeText,'-',findButton]
        
});
  itemGrid.btnResetHide(); 	//隐藏重置按钮
  itemGrid.btnPrintHide() ;	//隐藏打印按钮
/*itemGrid.btnDeleteHide(); //隐藏删除按钮
  itemGrid.btnPrintHide(); 	//隐藏打印按钮
  itemGrid.btnAddHide(); 	//隐藏重置按钮
  itemGrid.btnSaveHide(); 	//隐藏重置按钮
  itemGrid.load({params:{start:0, limit:12, userdr:username}});
*/
   
   
    

