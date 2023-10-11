supSchemeFun = function(curSchemeDr, curSchemeName, year, OrderBy) {

	var cschemeName = '当前预算方案：' + curSchemeName;

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
							url : 'herp.budg.budgschemmasupexe.csp'
									+ '?action=SupSchList&start=0&limit=25&orderby='
									+ OrderBy + '&year=' + year,
							method : 'POST'
						});
			});

	var bschemebox = new Ext.form.ComboBox({
				id : 'bschemebox',
				fieldLabel : '预算方案',
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
	// 前置方案设置grid
	var supSchemeGrid = new dhc.herp.Grid({
				title : cschemeName,
				width : 400,
				region : 'center',
				url : 'herp.budg.budgschemmasupexe.csp',
				fields : [{
							header : 'ID',
							dataIndex : 'rowid',
							hidden : true
						}, {
							id : 'SchemDR',
							header : '预算方案',
							dataIndex : 'SchemDR',
							width : 280,
							align : 'center',
							// editable:false,
							//type : bschemebox,
							hidden : true

						}, {
							id : 'UpSchemDR',
							header : '   前置预算方案',
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
	
	
	supSchemeGrid.btnResetHide();
	supSchemeGrid.btnPrintHide();

	
	
	
	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({
				text : '关闭'
			});

	// 定义取消按钮的响应函数
	cancelHandler = function() {
		window.hide();
	}

	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [supSchemeGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : '预算前置方案列设置',
				plain : true,
				width : 500,
				height : 400,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				closeAction:'hide',
				items : formPanel,
				buttons : [cancelButton]
				

			});
	window.show();
}