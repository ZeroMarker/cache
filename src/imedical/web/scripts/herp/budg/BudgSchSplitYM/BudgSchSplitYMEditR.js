var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
EditRFun = function(Sname,Bcode,itemGrid,Dname,year){

	var cschemeName = '当前科目名称 ：'+Sname ;
	///////////////////////科室类别///////////////////////////
	var deptTypeDs = new Ext.data.Store({
			proxy: "",
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
		});
		deptTypeDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgcommoncomboxexe.csp?action=deptType',method:'POST'});
		});
		var deptTypeCombo = new Ext.form.ComboBox({
			fieldLabel:'科室类别',
			store: deptTypeDs,
			displayField:'name',
			valueField:'rowid',
			typeAhead: true,
			forceSelection: true,
			triggerAction: 'all',
			emptyText:'选择...',
			width: 110,
			listWidth : 245,
			pageSize: 10,
			minChars: 1,
			selectOnFocus:true
		});
	
	///////////////////////科室名称///////////////////////////
	var deptNameDs = new Ext.data.Store({
			proxy: "",
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
		});
		deptNameDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgcommoncomboxexe.csp?action=dept',method:'POST'});
		});
		var deptNameCombo = new Ext.form.ComboBox({
			fieldLabel:'科室名称',
			store: deptNameDs,
			displayField:'name',
			valueField:'rowid',
			typeAhead: true,
			forceSelection: true,
			triggerAction: 'all',
			emptyText:'选择...',
			width: 110,
			listWidth : 245,
			pageSize: 10,
			minChars: 1,
			selectOnFocus:true
		});

	/////////////////年/////////////////////////////////
	var YearDs = new Ext.data.Store({
			proxy: "",
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['year','year'])
		});
		YearDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgcommoncomboxexe.csp?action=year',method:'POST'});		
		});
		var YearCombo = new Ext.form.ComboBox({
			fieldLabel:'年度',
			store: YearDs,
			displayField:'year',
			valueField:'year',
			typeAhead: true,
			forceSelection: true,
			triggerAction: 'all',
			emptyText:'选择...',
			width: 100,
			listWidth : 245,
			pageSize: 10,
			minChars: 1,
			selectOnFocus:true
		});

	//查询按钮
	var findButton = new Ext.Toolbar.Button({
		text: '查询',
	    tooltip:'查询',        
	    iconCls:'add',
		handler:function(){
	        var year=YearCombo.getValue();   
			var DeptType=deptTypeCombo.getValue();
			var DeptName=deptNameCombo.getValue();
			budgEditRGrid.load(({params:{start:0, limit:25,Bcode:Bcode,year:year,DeptType:DeptType,DeptName:DeptName}}));
		}
	});		

	///////////////////////批量填写/////////////////////////
	//批量设置分解方法按钮
	var editRDButton = new Ext.Toolbar.Button({
		text: '批量添加',
		tooltip: '批量添加科室',
		iconCls: 'add',
		handler: function(){
			EditRDFun(Bcode,budgEditRGrid,year);
		}
	});

	var bssdrateField = new Ext.form.NumberField({
			id: 'bssdrateField',
			width:215,
			listWidth : 215,
			name: 'bssdrateField',
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true
		});


	// 调节比例明细设置grid
	var budgEditRGrid = new dhc.herp.Grid({
				title : cschemeName,
				width : 400,
				region : 'center',
				url : 'herp.budg.budgschsplitymeditrexe.csp',
				fields : [
				new Ext.grid.CheckboxSelectionModel({editable:false}),
				{
							header : 'ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'deptDr',
							header : '科室dr',
							dataIndex : 'deptDr',
							width : 50,
							align : 'center',
							editable:false
							//hidden : true

						},{
							id : 'deptName',
							header : '科室名称',
							dataIndex : 'deptName',
							width : 70,
							align : 'center',
							editable:false,
							hidden : false

						},{
							id : 'm1',
							header : '1月',
							dataIndex : 'm1',
							width : 50,
							align : 'center',
							editable:true,
							hidden : false,
							type:bssdrateField

						},{
							id : 'm2',
							header : '2月',
							dataIndex : 'm2',
							width : 50,
							align : 'center',
							editable:true,
							hidden : false,
							type:bssdrateField

						},{
							id : 'm3',
							header : '3月',
							dataIndex : 'm3',
							width : 50,
							align : 'center',
							editable:true,
							hidden : false,
							type:bssdrateField

						},{
							id : 'm4',
							header : '4月',
							dataIndex : 'm4',
							width : 50,
							align : 'center',
							editable:true,
							hidden : false,
							type:bssdrateField

						},{
							id : 'm5',
							header : '5月',
							dataIndex : 'm5',
							width : 50,
							align : 'center',
							editable:true,
							hidden : false,
							type:bssdrateField

						},{
							id : 'm6',
							header : '6月',
							dataIndex : 'm6',
							width : 50,
							align : 'center',
							editable:true,
							hidden : false,
							type:bssdrateField

						},{
							id : 'm7',
							header : '7月',
							dataIndex : 'm7',
							width : 50,
							align : 'center',
							editable:true,
							hidden : false,
							type:bssdrateField

						},{
							id : 'm8',
							header : '8月',
							dataIndex : 'm8',
							width : 50,
							align : 'center',
							editable:true,
							hidden : false,
							type:bssdrateField

						},{
							id : 'm9',
							header : '9月',
							dataIndex : 'm9',
							width : 50,
							align : 'center',
							editable:true,
							hidden : false,
							type:bssdrateField

						},{
							id : 'm10',
							header : '10月',
							dataIndex : 'm10',
							width : 50,
							align : 'center',
							editable:true,
							hidden : false,
							type:bssdrateField

						},{
							id : 'm11',
							header : '11月',
							dataIndex : 'm11',
							width : 50,
							align : 'center',
							editable:true,
							hidden : false,
							type:bssdrateField

						},{
							id : 'm12',
							header : '12月',
							dataIndex : 'm12',
							width : 50,
							align : 'center',
							editable:true,
							hidden : false,
							type:bssdrateField

						}],
				tbar:['年度:',YearCombo,'-','科室分类:',deptTypeCombo,'-','科室名称:',deptNameCombo,'-',findButton,'-',editRDButton]

			});
	
    budgEditRGrid.btnAddHide();  //隐藏增加按钮
    //budgEditRGrid.btnSaveHide();  //隐藏保存按钮
    budgEditRGrid.btnResetHide();  //隐藏重置按钮
    //budgEditRGrid.btnDeleteHide(); //隐藏删除按钮
    budgEditRGrid.btnPrintHide();  //隐藏打印按钮
    
	budgEditRGrid.load({params:{start:0,limit:15,Bcode:Bcode}});
	
	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({ text : '关闭'});

	// 定义取消按钮的响应函数
	cancelHandler = function() 
	{ 
	  itemGrid.load({params:{start:0,limit:15,Dname:Dname}});
	  window.close(); 
	};

	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [budgEditRGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : '科室年度科目预算分解系数维护',
				plain : true,
				width : 840,
				height : 500,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
};