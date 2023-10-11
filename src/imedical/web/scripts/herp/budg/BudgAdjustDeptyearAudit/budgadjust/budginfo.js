
budginfoFun = function(Year, AdjustNo, itemCode){
	var budginfotitle = "单位计划调整";

	var budginfoUrl = 'herp.budg.budgadjustbudginfoexe.csp';
	var itemCodeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Rowid', 'Code'])
	});

	itemCodeDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : budginfoUrl+'?action=listCodeName',
						method : 'POST'
					});
	});

	var itemCodeCombo = new Ext.form.ComboBox({
			fieldLabel : '指标编码',
			store : itemCodeDs,
			displayField : 'Code',
			valueField : 'Code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
	});

	var itemNameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Rowid', 'Name'])
	});

	itemNameDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : budginfoUrl+'?action=listCodeName',
						method : 'POST'
					});
	});

	var itemNameCombo = new Ext.form.ComboBox({
			fieldLabel : '指标名称',
			store : itemNameDs,
			displayField : 'Name',
			valueField : 'Rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '-',
			width : 100,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
	});

	var findButton = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询',
		iconCls: 'option',
		handler: function(){
			var itemCode = itemCodeCombo.getValue();
			var itemName = itemNameCombo.getValue();
			detailitemGrid.load({params:{start:0,limit:25,itemCode:itemCode,itemName:itemName,Year:Year,AdjustNo:AdjustNo}});
		}
	});

	var detailitemGrid = new dhc.herp.Grid({
				width : 800,
				region : 'center',
				url : 'herp.budg.budgadjustbudginfoexe.csp',
				fields : [
						{
							id : 'ItemCode',
							header : '项目编码',
							dataIndex : 'ItemCode',
							width : 80,
							editable:false,
							renderer : function(value, cellmeta, record, rowIndex, columnIndex, store)
							{ 
								return '<span style="color:blue;cursor:hand">'+value+'</span>'	 
							}
						},{
							id : 'ItemName',
							header : '项目名称',
							dataIndex : 'ItemName',
							width : 80,
							editable:false

						},{
							id : 'CalUnitName',
							header : '计量单位',
							dataIndex : 'CalUnitName',
							width : 80,
							editable:false

						},{
							id : 'planValue',
							header : '年初预算',
							dataIndex : 'planValue',
							width : 80,
							editable:false

						},{
							id : 'planValueModi',
							header : '调整预算',
							dataIndex : 'planValueModi',
							width : 80,
							editable:false

						},{
							id : 'depSumAdjust',
							header : '科室汇总',
							dataIndex : 'depSumAdjust',
							width : 80,
							editable:false
						},
						{
							id : 'SumAdjust',
							header : '累计预算',
							dataIndex : 'SumAdjust',
							width : 80,
							editable:false
						},
						{
							id : 'adjustRatio',
							header : '调整比例',
							dataIndex : 'adjustRatio',
							width : 80,
							editable:false

						}
						],
						viewConfig : {forceFit : true},
						tbar : ['指标编码：',itemCodeCombo,'指标名称：',itemNameCombo,'-',findButton ]	

	});
	
	detailitemGrid.btnAddHide();  //隐藏增加按钮
   	detailitemGrid.btnSaveHide();  //隐藏保存按钮
    detailitemGrid.btnResetHide();  //隐藏重置按钮
    detailitemGrid.btnDeleteHide(); //隐藏删除按钮
    detailitemGrid.btnPrintHide();  //隐藏打印按钮
	detailitemGrid.load({params:{Year:Year, AdjustNo:AdjustNo, itemCode:itemCode, start:0, limit:25}});
	// 单击gird的单元格事件
	detailitemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
		var records = detailitemGrid.getSelectionModel().getSelections();
		if (columnIndex == 1) {         	
			var rowid  = records[0].get("rowid");
			var itemCode  = records[0].get("ItemCode");
			var itemName  = records[0].get("ItemName");
			var planValueModi  = records[0].get("planValueModi");
			//alert(Year);			
			depAdjustFun(Year, AdjustNo, itemCode, itemName, planValueModi);	
		}
	});
	
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
				items : [detailitemGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : budginfotitle,
				plain : true,
				width : 800,
				height : 350,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
};