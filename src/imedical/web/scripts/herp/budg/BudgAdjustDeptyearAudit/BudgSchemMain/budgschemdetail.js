
schemeDetailFun = function(curSchemeDr,IsCheck, curSchemeName, syear) {
		
		 

	var cschemeName = '当前预算方案：' + curSchemeName
	var itemtype = "";

	// herp.budg.superschemexe.csp
	var bgItemDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'code', name, 'cname'])
			});

	bgItemDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : 'herp.budg.budgchemdetailexe.csp'
									+ '?action=getitem&byear=' + syear
									+ '&itemtype=' + itemtype,
							method : 'GET'
						})
			});

	var bdgitembox = new Ext.form.ComboBox({
				id : 'bdgitembox',
				fieldLabel : '预算项目',
				width : 150,
				listWidth : 220,
				allowBlank : false,
				store : bgItemDs,
				valueField : 'code',
				displayField : 'cname',
				triggerAction : 'all',
				emptyText : '',
				name : 'bdgitembox',
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});

	var CalFlagDs = new Ext.data.SimpleStore({
				fields : ['rowid', 'name'],
				data : [['1', '公式计算'], ['2', '历史数据* 比例系数'], ['3', '历史数据']]
			});

	var sCalFlagDsCombo = new Ext.form.ComboBox({
				fieldLabel : '计算方法',
				store : CalFlagDs,
				// data:[['0','全院'],['1','科室']]
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '',
				width : 100,
				listWidth : 120,
				pageSize : 10,
				minChars : 1,
				columnWidth : .12,
				mode : 'local', // 本地模式
				selectOnFocus : true
			});

	var IsSplitDs = new Ext.data.SimpleStore({
				fields : ['rowid', 'name'],
				data : [['0', '否'], ['1', '是']]
			});

	var IsSplitCombo = new Ext.form.ComboBox({
				fieldLabel : '计算方法',
				store : IsSplitDs,
				// data:[['0','全院'],['1','科室']]
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '',
				width : 70,
				listWidth : 70,
				pageSize : 10,
				minChars : 1,
				columnWidth : .12,
				mode : 'local', // 本地模式
				selectOnFocus : true
			});
	var IsCalDs = new Ext.data.SimpleStore({
				fields : ['rowid', 'name'],
				data : [['0', '否'], ['1', '是']]
			});

	var IsCalCombo = new Ext.form.ComboBox({
				fieldLabel : '是否计算',
				store : IsCalDs,
				// data:[['0','全院'],['1','科室']]
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '',
				width : 70,
				listWidth : 70,
				pageSize : 10,
				minChars : 1,
				columnWidth : .12,
				mode : 'local', // 本地模式
				selectOnFocus : true
			});

	var SplitMethDs = new Ext.data.SimpleStore({
				fields : ['rowid', 'name'],
				data : [['1', '历史数据'], ['2', '历史数据*调节比例'], ['3', '比例系数'],
						['4', '全面贯彻'], ['5', '均摊']]
			});

	var SplitMethCombo = new Ext.form.ComboBox({
				fieldLabel : '计算方法',
				store : SplitMethDs,
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '',
				width : 100,
				listWidth : 120,
				pageSize : 10,
				minChars : 1,
				columnWidth : .12,
				mode : 'local', // 本地模式
				selectOnFocus : true
			});
			
///////////////////////批量添加/////////////////////////
	//批量设置分解方法按钮
	var additemButton = new Ext.Toolbar.Button({
		text: '批量添加',
		tooltip: '选择预算项添加',
		iconCls: 'add',
		handler: function(){
			additemFun(curSchemeDr,schemeDetailGrid);
			}
	});
	
	// 方案明细设置grid
	var schemeDetailGrid = new dhc.herp.Grid({
		title : cschemeName,
		width : 400,
		region : 'center',		
		listeners : {
			'cellclick' : function(grid, rowIndex, columnIndex, e) {
				var record = grid.getStore().getAt(rowIndex);
				// 预算项目公式编辑
				//alert(record.get('IsLast'));
				//alert(columnIndex);
				if (IsCheck =="审核") {
			        return false;}
				else if ((record.get('calflag') == '1') && (columnIndex == 6)) {
					//alert(111)
					return false;
				}
				else if ((record.get('IsLast') == '0')&& ((columnIndex == 8)||(columnIndex == 9))) {
					return false;
				} 
				else if ((record.get('calflag') == '1') && (columnIndex == 5)) {
					var schmDr;
					var type;
					var records = grid.getSelectionModel().getSelections();
					budgformula(schmDr, type, grid);
					// return true;
				}else{
					return true;
				}
			},
			'celldblclick' : function(grid, rowIndex, columnIndex, e) {
				var record = grid.getStore().getAt(rowIndex);
				// 预算项目公式编辑
				if (IsCheck =="审核") {
			        return false;}
				else if ((record.get('calflag') == '1') && (columnIndex == 6)) {
					//alert(111)
					return false;
				}
				else if (record.get('IsLast') == '0') {
					return false;
				}
				 else {
					//alert(222)
					return true;
				}
			}
		},
		url : 'herp.budg.budgchemdetailexe.csp',
		fields : [{
					header : 'ID',
					dataIndex : 'rowid',
					hidden : true
				}, {
					id : 'itemname',
					header : '项目名称',
					dataIndex : 'itemname',
					width : 150,
					align : 'left',
					// editable:false,
					type : bdgitembox,
					hidden : false

				}, {
					id : 'calflag',
					header : '计算方法',
					dataIndex : 'calflag',
					width : 130,
					align : 'left',
					type : sCalFlagDsCombo,
					hidden : false

				}, {
					id : 'iscal',
					header : '是否计算',
					dataIndex : 'iscal',
					width : 80,
					align : 'left',

					type : IsCalCombo,
					hidden : false

				}, {
					id : 'formula',
					header : '公式设置',
					dataIndex : 'formula',
					width : 80,
					align : 'left',
					editable : false,
					renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { //value, cellmeta, record, rowIndex, columnIndex, store
						var sf = record.data['calflag']
						if (sf == 1) {
							// p.setDisabled(true); background:red; .backgroundColor = '#990033'
								
							return '<span style="color:blue;cursor:hand;"><u>公式设置</u></span>';
						} else {
							'<span style="color:blue;cursor:hand"><u></u></span>';
						}
					},
					hidden : false

				}, {
					id : 'formulaset',
					header : '公式表达式',
					dataIndex : 'formulaset',
					width : 180,
					align : 'left',
					editable : true,
					renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { //value, cellmeta, record, rowIndex, columnIndex, store
						var sf = record.data['calflag']
						if (sf != 1) {
							cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						} else {
							'<span style="color:blue;cursor:hand"><u></u></span>';
						}
					},
					hidden : true

				}, {
					id : 'formuladesc',
					header : '公式描述',
					dataIndex : 'formuladesc',
					width : 180,
					align : 'left',
					editable : false,
					hidden : false

				}, {
					id : 'issplit',
					header : '是否分解',
					dataIndex : 'issplit',
					width : 70,
					align : 'left',
					// editable:false,
					type : IsSplitCombo,
					hidden : false

				}, {
					id : 'splitmeth',
					header : '分解方法',
					dataIndex : 'splitmeth',
					width : 130,
					align : 'left',
					// editable:false,
					type : SplitMethCombo,
					hidden : false

				}, {
					id : 'IsLast',
					header : '是否末级',
					dataIndex : 'IsLast',
					width : 130,
					align : 'left',
					hidden : true

				}],
				tbar:[additemButton]

	});
	// schemeDetailGrid.setUrlParam({SchemDR:curSchemeDr})
	//alert(curSchemeDr)
	
	var tbar = schemeDetailGrid.getTopToolbar();
		var addbutton = tbar.get('herpAddId');//增加
		var savebutton = tbar.get('herpSaveId');//保存
		var resetbutton = tbar.get('herpResetId');//重置
		var delbutton = tbar.get('herpDeleteId');//删除
		var printbutton = tbar.get('herpPrintId');//打印
		
		if(IsCheck=='审核') {
		additemButton.disable();
		addbutton.disable();
		savebutton.disable();
		resetbutton.disable();
		delbutton.disable();
		printbutton.disable();
		}
		else {
		additemButton.enable();
		addbutton.enable();
		savebutton.enable();
		resetbutton.enable();
		delbutton.enable();
		printbutton.enable();
		} 
	
	schemeDetailGrid.load({
				params : {
					start : 0,
					limit : 15,
					SchemDR : curSchemeDr
				}
			})

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
				items : [schemeDetailGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : '预算方案项目设置',
				plain : true,
				width : 900,
				height : 600,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
	/*
	 * // 单击gird的单元格事件 schemeDetailGrid.on('cellclick', function(thisgrid,
	 * rowIndex, columnIndex, e) { // alert(columnIndex) // 预算项目公式设置
	 * 
	 * if (columnIndex == 5) {
	 * 
	 * var schmDr; var type; var records =
	 * thisgrid.getSelectionModel().getSelections(); // 预算方案编辑页面
	 * budgformula(schmDr, type, thisgrid);
	 * 
	 * var record = thisgrid.getStore().getAt(rowIndex); } })
	 */
}
