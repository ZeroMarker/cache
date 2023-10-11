ChildFun = function(Id)
{	
	
		
	var childGrid = new dhc.herp.Grid({
	    title: '前置方案列表 ',
	    width: 400,
	    // edit:false, //是否可编辑
	    // readerModel:'local',
	    region: 'center',
	   //atLoad : true, // 是否自动刷新
	    url: 'herp.budg.budgschemauditwidehoschildexe.csp',
	    
		
	    fields: [
	    {
	        id:'rowid',
	        header: 'ID',
	        dataIndex: 'rowid',
	        hidden: true
	    },{
	        id:'bsmcode',
	        header: '方案编号',
	        dataIndex: 'bsmcode',
	        width:150,
			editable:false
			//hidden: true
	    },{
	        id:'bsmname',
	        header: '方案名称',
	        dataIndex: 'bsmname',
	        width:250,
	        update:true,
			editable:false,
			hidden: false
//			type:bsmNameField
	    },{ 
	        id:'bsmorderby',
	        header: '编制顺序',
	        dataIndex: 'bsmorderby',
	        width:100,
			editable:false,
			hidden: false
	    }
		]

	});
	childGrid.load(({params:{start:0, limit:25,Id:Id}}));
	
	
	
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
				//title : '内科科室年度预算分解比例维护;门诊收入分解系数维护界面',
				plain : true,
				width : 550,
				height : 450,
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