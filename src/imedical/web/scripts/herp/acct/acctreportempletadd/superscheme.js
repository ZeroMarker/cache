supSchemeFun = function(curSchemeDr, curSchemeName, year, OrderBy) {

	var cschemeName = '��ǰԤ�㷽����' + curSchemeName

	// herp.budg.superschemexe.csp
	var bschemeDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
			});

	bschemeDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : 'herp.budg.budgSchemMASupexe.csp'
									+ '?action=SupSchList&start=0&limit=25&orderby='
									+ OrderBy + '&year=' + year,
							method : 'POST'
						})
			});

	var bschemebox = new Ext.form.ComboBox({
				id : 'bschemebox',
				fieldLabel : 'Ԥ�㷽��',
				width : 280,
				listWidth : 280,
				allowBlank : false,
				store : bschemeDs,
				valueField : 'rowid',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				name : 'bschemebox',
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});
	// ǰ�÷�������grid
	var supSchemeGrid = new dhc.herp.Grid({
				title : cschemeName,
				width : 400,
				region : 'center',
				url : 'herp.budg.budgSchemMASupexe.csp',
				fields : [{
							header : 'ID',
							dataIndex : 'rowid',
							hidden : true
						}, {
							id : 'SchemDR',
							header : 'Ԥ�㷽��',
							dataIndex : 'SchemDR',
							width : 280,
							align : 'center',
							// editable:false,
							//type : bschemebox,
							hidden : true

						}, {
							id : 'UpSchemDR',
							header : '   ǰ��Ԥ�㷽��',
							dataIndex : 'UpSchemDR',
							width : 280,
							align : 'left',
							// editable:false,
							type : bschemebox,
							hidden : false

						}]

			});
			//alert(curSchemeDr);
	supSchemeGrid.load({params:{start:0,limit:15,schemeDr:curSchemeDr}})
	
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
				items : [supSchemeGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : 'Ԥ��ǰ�÷���������',
				plain : true,
				width : 500,
				height : 400,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
}