
schemeDetailFun = function(curSchemeDr,IsCheck, curSchemeName, syear) {
		
		 

	var cschemeName = '��ǰԤ�㷽����' + curSchemeName
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
				fieldLabel : 'Ԥ����Ŀ',
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
				data : [['1', '��ʽ����'], ['2', '��ʷ����* ����ϵ��'], ['3', '��ʷ����']]
			});

	var sCalFlagDsCombo = new Ext.form.ComboBox({
				fieldLabel : '���㷽��',
				store : CalFlagDs,
				// data:[['0','ȫԺ'],['1','����']]
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
				mode : 'local', // ����ģʽ
				selectOnFocus : true
			});

	var IsSplitDs = new Ext.data.SimpleStore({
				fields : ['rowid', 'name'],
				data : [['0', '��'], ['1', '��']]
			});

	var IsSplitCombo = new Ext.form.ComboBox({
				fieldLabel : '���㷽��',
				store : IsSplitDs,
				// data:[['0','ȫԺ'],['1','����']]
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
				mode : 'local', // ����ģʽ
				selectOnFocus : true
			});
	var IsCalDs = new Ext.data.SimpleStore({
				fields : ['rowid', 'name'],
				data : [['0', '��'], ['1', '��']]
			});

	var IsCalCombo = new Ext.form.ComboBox({
				fieldLabel : '�Ƿ����',
				store : IsCalDs,
				// data:[['0','ȫԺ'],['1','����']]
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
				mode : 'local', // ����ģʽ
				selectOnFocus : true
			});

	var SplitMethDs = new Ext.data.SimpleStore({
				fields : ['rowid', 'name'],
				data : [['1', '��ʷ����'], ['2', '��ʷ����*���ڱ���'], ['3', '����ϵ��'],
						['4', 'ȫ��᳹'], ['5', '��̯']]
			});

	var SplitMethCombo = new Ext.form.ComboBox({
				fieldLabel : '���㷽��',
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
				mode : 'local', // ����ģʽ
				selectOnFocus : true
			});
			
///////////////////////�������/////////////////////////
	//�������÷ֽⷽ����ť
	var additemButton = new Ext.Toolbar.Button({
		text: '�������',
		tooltip: 'ѡ��Ԥ�������',
		iconCls: 'add',
		handler: function(){
			additemFun(curSchemeDr,schemeDetailGrid);
			}
	});
	
	// ������ϸ����grid
	var schemeDetailGrid = new dhc.herp.Grid({
		title : cschemeName,
		width : 400,
		region : 'center',		
		listeners : {
			'cellclick' : function(grid, rowIndex, columnIndex, e) {
				var record = grid.getStore().getAt(rowIndex);
				// Ԥ����Ŀ��ʽ�༭
				//alert(record.get('IsLast'));
				//alert(columnIndex);
				if (IsCheck =="���") {
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
				// Ԥ����Ŀ��ʽ�༭
				if (IsCheck =="���") {
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
					header : '��Ŀ����',
					dataIndex : 'itemname',
					width : 150,
					align : 'left',
					// editable:false,
					type : bdgitembox,
					hidden : false

				}, {
					id : 'calflag',
					header : '���㷽��',
					dataIndex : 'calflag',
					width : 130,
					align : 'left',
					type : sCalFlagDsCombo,
					hidden : false

				}, {
					id : 'iscal',
					header : '�Ƿ����',
					dataIndex : 'iscal',
					width : 80,
					align : 'left',

					type : IsCalCombo,
					hidden : false

				}, {
					id : 'formula',
					header : '��ʽ����',
					dataIndex : 'formula',
					width : 80,
					align : 'left',
					editable : false,
					renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { //value, cellmeta, record, rowIndex, columnIndex, store
						var sf = record.data['calflag']
						if (sf == 1) {
							// p.setDisabled(true); background:red; .backgroundColor = '#990033'
								
							return '<span style="color:blue;cursor:hand;"><u>��ʽ����</u></span>';
						} else {
							'<span style="color:blue;cursor:hand"><u></u></span>';
						}
					},
					hidden : false

				}, {
					id : 'formulaset',
					header : '��ʽ���ʽ',
					dataIndex : 'formulaset',
					width : 180,
					align : 'left',
					editable : true,
					renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { //value, cellmeta, record, rowIndex, columnIndex, store
						var sf = record.data['calflag']
						if (sf != 1) {
							cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						} else {
							'<span style="color:blue;cursor:hand"><u></u></span>';
						}
					},
					hidden : true

				}, {
					id : 'formuladesc',
					header : '��ʽ����',
					dataIndex : 'formuladesc',
					width : 180,
					align : 'left',
					editable : false,
					hidden : false

				}, {
					id : 'issplit',
					header : '�Ƿ�ֽ�',
					dataIndex : 'issplit',
					width : 70,
					align : 'left',
					// editable:false,
					type : IsSplitCombo,
					hidden : false

				}, {
					id : 'splitmeth',
					header : '�ֽⷽ��',
					dataIndex : 'splitmeth',
					width : 130,
					align : 'left',
					// editable:false,
					type : SplitMethCombo,
					hidden : false

				}, {
					id : 'IsLast',
					header : '�Ƿ�ĩ��',
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
		var addbutton = tbar.get('herpAddId');//����
		var savebutton = tbar.get('herpSaveId');//����
		var resetbutton = tbar.get('herpResetId');//����
		var delbutton = tbar.get('herpDeleteId');//ɾ��
		var printbutton = tbar.get('herpPrintId');//��ӡ
		
		if(IsCheck=='���') {
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

	// ��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({
				text : '�ر�'
			});

	// ����ȡ����ť����Ӧ����
	cancelHandler = function() {
		window.close();
	}

	// ���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);
	// ��ʼ�����
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [schemeDetailGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : 'Ԥ�㷽����Ŀ����',
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
	 * // ����gird�ĵ�Ԫ���¼� schemeDetailGrid.on('cellclick', function(thisgrid,
	 * rowIndex, columnIndex, e) { // alert(columnIndex) // Ԥ����Ŀ��ʽ����
	 * 
	 * if (columnIndex == 5) {
	 * 
	 * var schmDr; var type; var records =
	 * thisgrid.getSelectionModel().getSelections(); // Ԥ�㷽���༭ҳ��
	 * budgformula(schmDr, type, thisgrid);
	 * 
	 * var record = thisgrid.getStore().getAt(rowIndex); } })
	 */
}
