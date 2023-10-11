DetailFun = function(RowId)
{
	
	//调节比例
	var bssdrateField = new Ext.form.TextField({
		id: 'bssdrateField',
		width:215,
		regex : /^(-?\d+)(\.\d+)?$/,
		regexText : "只能输入数字",
		name: 'bssdrateField',
		editable:true
	});
	
	var detaileditButton = new Ext.Toolbar.Button({
		text: '批量处理',
	    tooltip:'批量处理',        
	    iconCls:'add',
		handler:function(){
			detaileditFun(detailGrid,RowId);
		}
	});
		
	var detailGrid = new dhc.herp.Grid({
	    title: '分解比例系数维护界面 ',
	    width: 200,
	    //edit:false, //是否可编辑
	    //readerModel:'local',
	    region: 'center',
	    //atLoad : true, // 是否自动刷新
	    url: 'herp.budg.budgschemsplityearmonthdetailexe.csp',
		tbar:[detaileditButton],
	    fields: [
	    new Ext.grid.CheckboxSelectionModel({editable:false}),
	    {
	        id:'rowid',
	        header: 'ID',
	        dataIndex: 'rowid',
	        hidden: true
	    },{
	        id:'bssdspltmaindr',
	        header: '分解主表ID',
	        dataIndex: 'bssdspltmaindr',
	        width:150,
			editable:true,
			hidden: true
	    },{
	        id:'bmcode',
	        header: '月份',
	        dataIndex: 'bmcode',
	        width:100,
	        update:true,
			editable:false,
			hidden: false
	    },{ 
	        id:'bssdrate',
	        header: '调节比例',
	        dataIndex: 'bssdrate',
	        width:150,
	        align:'right',
			editable:true,
			align: 'right',
			hidden: false,
			type:bssdrateField
	    }
		],
		viewConfig : {
			forceFit : true
		}

	});
	detailGrid.load(({params:{start : Ext.isEmpty(detailGrid.getTopToolbar().cursor)
									? 0: detailGrid.getTopToolbar().cursor,
							  limit : detailGrid.pageSize,
							  RowId:RowId}}));	
	
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
				items : [detailGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				//title : '内科科室年度预算分解比例维护;门诊收入分解系数维护界面',
				plain : true,
				width : 600,
				height : 500,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
	
	detailGrid.btnAddHide();  //隐藏增加按钮
	//detailGrid.btnSaveHide();  //隐藏保存按钮
	detailGrid.btnResetHide();  //隐藏重置按钮
	detailGrid.btnDeleteHide(); //隐藏删除按钮
	detailGrid.btnPrintHide();  //隐藏打印按钮
};