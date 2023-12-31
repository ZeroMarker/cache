
expend = function(deptcode,yearmonth) {
	//alert("deptcode"+deptcode);
	var itemGrid = new dhc.herp.Grid({
        title: '收入明细',
        width: 400,
        edit:true,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'dhc.pa.basedeptpacheckexe.csp',	  
		//atLoad : true, // 是否自动刷新
		loadmask:true,
        fields: [{
			 id:'rowid',
		     header: '年月',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'rowid'
		}, {
		     id:'itemname',
		     header: '收费项',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'itemname'
		}, {
		     id:'itemvalue',
		     header: '金额',
		     allowBlank: false,
		     align:'right',
		     width:100,
		     editable:false,
		     dataIndex: 'itemvalue'
		}, {
		     id:'deptname',
		     header: '科室',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'deptname'
		}, {
		     id:'itemtype',
		     header: '类别',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'itemtype'
		}]

        
});
itemGrid.load({params:{start:0,limit:15,yearmonth:yearmonth,deptcode:deptcode}})


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
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [itemGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : '支出明细',
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
		itemGrid.btnAddHide() ;	//隐藏增加按钮
		itemGrid.btnSaveHide(); 	//隐藏保存按钮
		itemGrid.btnResetHide(); 	//隐藏重置按钮
		itemGrid.btnDeleteHide(); //隐藏删除按钮
		itemGrid.btnPrintHide() ;	//隐藏打印按钮
	
	
}