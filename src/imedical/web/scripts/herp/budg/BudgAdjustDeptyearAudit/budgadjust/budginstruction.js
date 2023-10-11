
budginstructionFun = function(adjid,Year,adjustno, memo){
	var budginstructiontitle = "调整顺序-调整说明";
	
	var schemeDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
	});

	schemeDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:'herp.budg.budgadjustinstructionexe.csp'+'?action=listScheme&start='+0+'&limit='+25+'&str='+encodeURIComponent(Ext.getCmp('schemeField').getRawValue()),method:'POST'});
	});

	var schemeField = new Ext.form.ComboBox({
		id: 'schemeField',
		fieldLabel: '对应方案',
		width:200,
		listWidth : 300,
		allowBlank: false,
		store: schemeDs,
		valueField: 'rowid',
		displayField: 'Name',
		triggerAction: 'all',
		emptyText:'请选择对应方案...',
		name: 'schemeField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
		
	var budginstructionGrid = new dhc.herp.Gridsch({
				width : 400,
				region : 'center',
				url : 'herp.budg.budgadjustinstructionexe.csp',
				listeners:{
        		'cellclick' : function(grid, rowIndex, columnIndex, e) {
               		var record = grid.getStore().getAt(rowIndex);
               		// 根据条件设置单元格点击编辑是否可用
               		if ((record.get('rowid') !== '') &&(columnIndex == 3)) {    
                     		 return false;
               		} else{ return true;}
        		},        
        		'celldblclick' : function(grid, rowIndex, columnIndex, e) {
           			var record = grid.getStore().getAt(rowIndex);
            		if ((record.get('rowid') !== '') &&(columnIndex == 3)) {      
                   		return false;
            		} else{return true;}
     				}
				},
				fields : [{
							header : '调整表ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'SchemDR',
							header : '预算编制方案ID',
							dataIndex : 'SchemDR',
							width : 60,
							editable:false,
							hidden : true
						},{
							id : 'schemeCode',
							header : '预算编制方案编号',
							dataIndex : 'schemeCode',
							width : 60,
							editable:false
						},{
							id : 'schemeName',
							header : '预算编制方案名称',
							dataIndex : 'schemeName',
							//align:'right',
							width : 60,
							type:schemeField,
							editable:true
						}
						],
						viewConfig : {forceFit : true},
						tbar : ['调整序号：',adjustno,'-','调整说明：',memo ,'-']	
	});

	//budginstructionGrid.btnAddHide();  //隐藏增加按钮
   	//budginstructionGrid.btnSaveHide();  //隐藏保存按钮
    budginstructionGrid.btnResetHide();  //隐藏重置按钮
    budginstructionGrid.btnDeleteHide(); //隐藏删除按钮
    budginstructionGrid.btnPrintHide();  //隐藏打印按钮
	budginstructionGrid.load({params : {start : 0,limit : 25,Year:Year,AdjustNo:adjustno}});
	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({ text : '关闭'});
	// 定义取消按钮的响应函数
	cancelHandler = function(){ 
	  window.close();
	};
	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
		
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [budginstructionGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : budginstructiontitle,
				plain : true,
				width : 600,
				height : 350,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
};