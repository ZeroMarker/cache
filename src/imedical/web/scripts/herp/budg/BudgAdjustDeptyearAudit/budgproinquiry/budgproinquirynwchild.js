ChildFun = function(name)
{	
	//项目状态
	var stateStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['0','新建'],['1','执行'],['2','完成'],['3','取消']]
	});
	var stateStoreField = new Ext.form.ComboBox({
		id: 'stateStoreField',
		fieldLabel: '项目状态',
		width:120,
		listWidth : 215,
		selectOnFocus: true,
		allowBlank: false,
		store: stateStore,
		anchor: '90%',
		// value:'key', //默认值
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		// emptyText:'选择模块名称...',
		mode: 'local', // 本地模式
		editable:false,
		pageSize: 10,
		minChars: 15,
		selectOnFocus:true,
		forceSelection:true
	});
	
	//项目性质 
	var propertyStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['1','一般性项目'],['2','基建项目'],['3','科研项目']]
	});
	var propertyStoreField = new Ext.form.ComboBox({
		id: 'propertyStoreField',
		fieldLabel: '项目性质',
		width:120,
		listWidth : 215,
		selectOnFocus: true,
		allowBlank: false,
		store: stateStore,
		anchor: '90%',
		// value:'key', //默认值
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		// emptyText:'选择模块名称...',
		mode: 'local', // 本地模式
		editable:false,
		pageSize: 10,
		minChars: 15,
		selectOnFocus:true,
		forceSelection:true
	});
		
	//“是否”状态 
	var whetherStore = new Ext.data.SimpleStore({
		fields:['key','keyValue'],
		data:[['0','否'],['1','是']]
	});
	var whetherStoreField = new Ext.form.ComboBox({
		id: 'whetherStoreField',
		fieldLabel: '是否',
		width:120,
		listWidth : 215,
		selectOnFocus: true,
		allowBlank: false,
		store: stateStore,
		anchor: '90%',
		// value:'key', //默认值
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		// emptyText:'选择模块名称...',
		mode: 'local', // 本地模式
		editable:false,
		pageSize: 10,
		minChars: 15,
		selectOnFocus:true,
		forceSelection:true
	});
	
	var childGrid = new dhc.herp.Grid({
	    title: '项目详细信息表 ',
	    width: 400,
	    // edit:false, //是否可编辑
	    // readerModel:'local',
	    region: 'center',
	   //atLoad : true, // 是否自动刷新
	    url: 'herp.budg.budgproinquirynwchildexe.csp',
		
		
	    fields: [
	    {
	        id:'rowid',
	        header: 'ID',
	        dataIndex: 'rowid',
	        hidden: true
	    },{
	        id:'year',
	        header: '立项年度',
	        dataIndex: 'year',
	        width:75,
	        update:true,
	        allowBlank: true,
			editable:false
	    },{ 
	        id:'compdr',
	        header: '医院编码',
	        dataIndex: 'compdr',
	        width:100,
	        allowBlank: true,
			editable:false,
			hidden: false
	    }, {
	        id:'projcode',
	        header: '项目编码',
	        width:100,
			//tip:true,
			//allowBlank: false,
	        editable:false,
	        allowBlank: true,
	        dataIndex: 'projcode'
			
	    }, {
	        id:'projname',
	        header: '项目名称',
	        width:250,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'projname'
	    }, {
	        id:'spell',
	        header: '拼音码',
	        width:100,
			//tip:true,
			allowBlank: true,
			editable:false,
	        dataIndex: 'spell'
	    },{
	        id:'goal',
	        header: '项目目的',
	        width:150,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'goal'
	    }, {
	        id:'dutydr',
	        header: '项目负责人(号)',
	        width:100,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'dutydr',
	        hidden: true
	    }, {
	        id:'ssname',
	        header: '项目负责人',
	        width:100,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'ssname'
	    }, {
	        id:'start',
	        header: '立项时间',
	        width:150,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'start'
	    }, {
	        id:'deptdr',
	        header: '责任科室(号)',
	        width:100,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'deptdr',
	        hidden: true
	    }, {
	        id:'deptname',
	        header: '责任科室',
	        width:200,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'deptname'
	    }, {
	        id:'plansdate',
	        header: '计划开始时间',
	        width:150,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'plansdate'
	    }, {
	        id:'planedate',
	        header: '计划结束时间',
	        width:150,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'planedate'
	    }, {
	        id:'realsdate',
	        header: '实际开始时间',
	        width:150,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'realsdate'
	    }, {
	        id:'realedate',
	        header: '实际结束时间',
	        width:150,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'realedate'
	    }, {
	        id:'state',
	        header: '项目状态',
	        width:100,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'state',
	        type:stateStoreField
	    }, {
	        id:'propertyid',
	        header: '项目性质',
	        width:150,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'propertyid',
	        type:propertyStoreField
	    }, {
	        id:'iscontinue',
	        header: '是否延续性项目',
	        width:100,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'iscontinue',
	        type:whetherStoreField
	    }, {
	        id:'isgovbuy',
	        header: '是否政府性采购',
	        width:100,
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'isgovbuy',
	        type:whetherStoreField
	    }, {
	        id:'fundgov',
	        header: '政府支付金额',
	        width:120,
	        align:'right',
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'fundgov'
	    }, {
	        id:'fundown',
	        header: '自筹资金',
	        width:120,
	        align:'right',
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'fundown'
	    }, {
	        id:'fundtotal',
	        header: '项目总预算',
	        width:120,
	        align:'right',
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'fundtotal'
	    },  {
	        id:'reqmoney',
	        header: '申请资金总额',
	        width:120,
	        align:'right',
			//tip:true,
			allowBlank: false,
			editable:false,
	        dataIndex: 'reqmoney'
	    }, {
	        id:'actpaywait',
	        header: '在途报销额',
	        width:120,
	        align:'right',
			//tip:true,
			allowBlank: true,
			editable:false,
	        dataIndex: 'actpaywait'
	    },  {
	        id:'actpaymoney',
	        header: '已执行预算',
	        width:120,
	        align:'right',
			//tip:true,
			allowBlank: true,
			editable:false,
	        dataIndex: 'actpaymoney'
			
	    },{
	    	id:'alertpercent',
	        header: '执行预警百分比',
	        width:100,
	        align:'right',
		    //tip:true,
		    allowBlank: true,
		    editable:false,
	        dataIndex: 'alertpercent'
	    },{
	    	id:'filedesc',
	        header: '附件',
	        width:100,
		    //tip:true,
		    allowBlank: true,
		    editable:false,
	        dataIndex: 'filedesc'
	    }
		]

	});
	childGrid.load(({params:{start:0, limit:25,name:name}}));
	
	
	
	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({
				text : '关闭'
			});

	// 定义取消按钮的响应函数
	cancelHandler = function() {
		window.close();
	}
	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [childGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				plain : true,
				width : 1000,
				height : 500,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
	
	
	childGrid.btnAddHide();  //隐藏增加按钮
	childGrid.btnSaveHide();  //隐藏保存按钮
	childGrid.btnResetHide();  //隐藏重置按钮
	childGrid.btnDeleteHide(); //隐藏删除按钮
	childGrid.btnPrintHide();  //隐藏打印按钮
	

};