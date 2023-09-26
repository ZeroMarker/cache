Ext.onReady(function() {

	Ext.QuickTips.init();
	var qtrowid;
	var qtstore = new Ext.data.Store({

				url : 'dhccrmqtdisease1.csp?actiontype=list',

				reader : new Ext.data.JsonReader({

							totalProperty : 'results',
							root : 'rows',
							id : 'QTRowId'

						}, [{
									name : 'QTRowId'
								}, {
									name : 'QTCode'
								}, {
									name : 'QTDesc'
								}])

			});
	var icdstore = new Ext.data.Store({

				url : 'dhccrmqtdisease1.csp?actiontype=icdlist',

				reader : new Ext.data.JsonReader({

							totalProperty : 'results',
							root : 'rows',
							id : 'icdid'

						}, [{
									name : 'icdid'
								}, {
									name : 'icdqtdr'
								}, {
									name : 'icddr'
								}, {
									name : 'icddesc'
								}])

			});
	var qtcm = new Ext.grid.ColumnModel([{

				header : '编码',
				dataIndex : 'QTCode',
				editor : new Ext.form.TextField({
							allowBlank : false
						})

			}, {

				header : '名称',
				dataIndex : 'QTDesc',
				width : 300,
				editor : new Ext.form.TextField({
							allowBlank : false
						})

			}]);
	var fuICDstore = new Ext.data.Store({
				url : 'dhccrmsetplan1.csp?action=fuICDlist',
				reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : "rows"
						}, ['RowID', 'Name'])
			})
	var icdcm = new Ext.grid.ColumnModel([{

				header : 'icdqtdr',
				dataIndex : 'icdqtdr'

			}, {

				header : 'icddr',
				dataIndex : 'icddr'

			}, {

				header : 'ICD诊断',
				dataIndex : 'icddesc',
				width : 300,
				editor : new Ext.form.ComboBox({
					enableKeyEvents : true,
					fieldLabel : '出院诊断',
					width : 150,
					store : fuICDstore,
					valueField : 'RowID',
					displayField : 'Name',
					triggerAction : 'all',
					id : 'mrdisdiagname',
					mode : 'local',
					PageSize : 20,
					minListWidth : 220,
					selectOnFocus : true,
					listeners : {
						'beforequery' : function(obj) {

							var ICDDesc = this.getRawValue();
							if (ICDDesc == "")
								return;

							this.store.proxy.conn.url = 'dhccrmsetplan1.csp?action=fuICDlist&ICDDesc='
									+ ICDDesc;
							this.store.load({});
						}
					}
				})

			}]);
	var qtbbar = new Ext.PagingToolbar({

				pageSize : 200,
				store : qtstore
			});
	function AddQt() {

		var row = new Ext.data.Record({
					QTCode : '',
					QTDesc : ''
				});
		qtgrid.stopEditing();
		qtstore.insert(0, row);
		qtgrid.startEditing(0, 0);

	}
	function AddICD() {

		var row = new Ext.data.Record({
					icdqtdr : '',
					icddr : '',
					icddesc : ''
				});
		icdgrid.stopEditing();
		icdstore.insert(0, row);
		icdgrid.startEditing(0, 0);

	}
	var qttbar = new Ext.Toolbar({

				items : [{
							xtype : 'tbbutton',
							text : '新增',
							id : 'addqt',
							handler : AddQt
						}, {
							xtype : 'tbbutton',
							text : '导入ICD对照',
							id : 'fusicdimport',
							handler : Import_click
						}]
			})
	function StringIsNull(String) {
		if (String == null)
			return ""
		return String
	}		
	
	function Import_click() {
		
		var kill = tkMakeServerCall("web.DHCCRM.SetPlan", "KillICDDataGlobal");
		try {
			
			var Template = "";
			var obj = document.getElementById("File")
			if (obj) {
				obj.click();
				Template = obj.value;
				obj.outerHTML = obj.outerHTML; // 清空选择文件名称
			}
			if (Template == "")
				return false;
			var extend = Template.substring(Template.lastIndexOf(".") + 1);
			if (!(extend == "xls" || extend == "xlsx")) {
				alert("请选择xls文件")
				return false;
			}
			
			xlApp = new ActiveXObject("Excel.Application"); // 固定
			xlBook = xlApp.Workbooks.Add(Template); // 固定
			xlsheet = xlBook.WorkSheets("Sheet1"); // Excel下标的名称

			i = 2

			while (Flag = 1) {
				IInString = ""
				StrValue = StringIsNull(xlsheet.cells(i, 1).Value);
				if (StrValue == "")
					break;
				IInString = StrValue;

				StrValue = StringIsNull(xlsheet.cells(i, 3).Value);
				IInString = IInString + "^" + StrValue;
				
				
				var ReturnValue = tkMakeServerCall("web.DHCCRM.SetPlan",
						"CreateICDDataGolDZ", IInString);
				i = i + 1
			}

			xlApp.Quit();
			xlApp = null;
			xlsheet = null;

			var Return = tkMakeServerCall("web.DHCCRM.SetPlan",
					"ImportICDDataByGolDZ")
			if (Return == 0) {
				alert("导入成功!")
			}
		} catch (e) {
			alert(e + "^" + e.message);
		}
	
	}		
			
			

	var icdtbar = new Ext.Toolbar({

				items : [{
							xtype : 'tbbutton',
							text : '新增',
							id : 'addicd',
							handler : AddICD
						}]
			})
	var qtgrid = new Ext.grid.EditorGridPanel({

				region : 'center',
				title : '躯体疾病',
				collapsible : true,
				frame : true,
				viewConfig : {
					forceFit : true
				},
				store : qtstore,
				cm : qtcm,
				tbar : qttbar,
				bbar : qtbbar

			});
	var icdgrid = new Ext.grid.EditorGridPanel({

				region : 'east',
				width : 800,
				title : 'icd对照',
				collapsible : true,
				frame : true,
				viewConfig : {
					forceFit : true
				},
				store : icdstore,
				cm : icdcm,
				tbar : icdtbar

			});
	qtgrid.on('afteredit', function(e) {

				var QTCode = e.record.get("QTCode");
				var QTDesc = e.record.get("QTDesc");
				if ((QTCode == '') || (QTDesc == ''))
					return;
				var QTRowId = e.record.get("QTRowId");
				if (QTRowId) {
				} else
					QTRowId = '';

				var ret = tkMakeServerCall("web.DHCCRM.CRMBaseSet",
						"SaveQTDisease", QTCode, QTDesc, QTRowId);

				if (ret == 0)
					qtstore.load();

			});
	icdgrid.on('afteredit', function(e) {

				var icdid = e.record.get("icdid");

				var icddr = Ext.getCmp('mrdisdiagname').getValue();
				if (icdid) {
				} else
					icdid = '';
				var ret = tkMakeServerCall("web.DHCCRM.CRMBaseSet",
						"SaveICDRelate", icdid, qtrowid, icddr);

				if (ret == 0)
					icdstore.load();

			});
	qtgrid.on('rowclick', function(grid, rowIndex, event) {

		var qtrecord = qtstore.getAt(rowIndex);
		qtrowid = qtrecord.get('QTRowId');
		icdstore.proxy.conn.url = 'dhccrmqtdisease1.csp?actiontype=icdlist&qtid='
				+ qtrowid;
		icdstore.load({
					params : {
						start : 0,
						limit : 200
					}
				});

	});
	var main = new Ext.Viewport({

				layout : 'border',
				collapsible : true,
				items : [qtgrid, icdgrid]
			});
	qtstore.load({

				params : {
					start : 0,
					limit : 200
				}

			});
})