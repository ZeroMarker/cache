//连接报表Query
function Query() {

	////Schem	简历查询方案的grid
	var SchemGrid = new dhc.herp.Grid({
			title: '查询方案维护',
			iconCls:'maintain',
			region: 'center',
			// atLoad: true,
			url: 'herp.acct.DepAssAcctSumReportexe.csp',
			// split : true,
			viewConfig: {
				forceFit: true
			},
			fields: [//new Ext.grid.CheckboxSelectionModel({editable:false}),
				{
					id: 'rowid',
					header: 'ID',
					width: 100,
					editable: false,
					hidden: true,
					dataIndex: 'rowid'
				}, {
					id: 'bookid',
					header: '<div style="text-align:center">账套id</div>',
					align: 'right',
					editable: false,
					width: 140,
					hidden: true,
					dataIndex: 'bookid'
				}, {
					id: 'code',
					header: '<div style="text-align:center">方案编号</div>',
					width: 50,
					align: 'left',
					allowBlank: false,
					dataIndex: 'code'

				}, {
					id: 'name',
					header: '<div style="text-align:center">方案名称</div>',
					width: 140,
					align: 'left',
					allowBlank: false,
					dataIndex: 'name'
				}, {
					id: 'desc',
					header: '方案描述',
					width: 220,
					allowBlank: true,
					hidden: true,
					dataIndex: 'desc'
				}
			]
		});

	SchemGrid.load({
		params: {
			start: 0,
			limit: 10,
			bookID: bookID
		}
	});

	//SchemGrid.addButton('-');
	//SchemGrid.addButton('<div style="color:red">说明：部门核算汇总表的方案编号以ZB1301开头。</div>');
	SchemGrid.btnResetHide(); //隐藏重置按钮
	SchemGrid.btnPrintHide(); //隐藏打印按钮


	//////////////部门核算汇总表查询条件start//////////

	//----------------期间范围-----------//

	var startYearMonth = new Ext.form.DateField({
			id: 'startYearMonth',
			name: 'STARTYEAR_MONTH',
			fieldLabel: '期间范围',
			labelSeparator:'',
			emptyMsg: "请选择年月...",
			format: 'Y-m',
			width: 100,
			triggerAction: 'all',
			allowBlank: true,
			plugins: 'monthPickerPlugin'
		});
	var endYearMonth = new Ext.form.DateField({
			id: 'endYearMonth',
			name: 'ENDYEAR_MONTH',
			labelSeparator:'',
			fieldLabel: '至',
			emptyMsg: "请选择年月...",
			format: 'Y-m',
			width: 100,
			triggerAction: 'all',
			allowBlank: true,
			plugins: 'monthPickerPlugin'
		});

	/*
	var startYearMonth = new Ext.form.DateField({
	id:'startYearMonth',
	fieldLabel: '期间范围',
	name : 'STARTYEAR_MONTH',
	format : 'Y-m',
	editable : false,
	allowBlank : false,
	emptyText:'请选择年月...',
	// value:new Date(),
	width: 100,
	maxValue : new Date(),
	plugins: 'monthPickerPlugin',
	listeners : {
	scope : this,
	'select' : function(dft){
	}
	}
	});

	var endYearMonth = new Ext.form.DateField({
	id:'endYearMonth',
	fieldLabel: '会计范围',
	name : 'ENDYEAR_MONTH',
	format : 'Y-m',
	editable : false,
	allowBlank : false,
	emptyText:'请选择年月...',
	width: 100,
	maxValue : new Date(),
	plugins: 'monthPickerPlugin',
	listeners : {
	scope : this,
	'select' : function(dft){
	}
	}
	});*/

	//----------科室范围-----------//
	var ItemNamestartDs = new Ext.data.Store({
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['CheckItemCode', 'CheckItemName'])
		});
		//没有取到isstop的值，刚开始不刷新
	/* ItemNamestartDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'../csp/herp.acct.DepAssAcctSumReportexe.csp?action=GetCIname&bookID='+bookID,method:'POST'});
	}); */

	var CheckItemNameField1 = new Ext.form.ComboBox({
			id: 'CheckItemNameField1',
			fieldLabel: '科室范围始',
			store: ItemNamestartDs,
			labelSeparator:'',
			valueField: 'CheckItemCode',
			displayField: 'CheckItemName',
			emptyText: '请选择科室范围...',
			typeAhead: true,
			width: 150,
			listWidth: 230,
			forceSelection: true,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1

		});
	// CheckItemNameField1.render(document.body);
	var fg;
	//判断是否包含停用科室 focus	buttQuery
	CheckItemNameField1.on('focus', function () {

		if (fg) {

			ItemNamestartDs.load({
				params: {
					start: 0,
					limit: 25,
					bookID:bookID,
					isStop: IsStopField.getValue() ? 1 : 0
				}
			});
			fg = 0;
			return;
		} else {
			Ext.Msg.confirm('提示', '是否要选择停用科室？ ', function (id) {
				if (id == "yes") {
					// Ext.getCmp('IsStopField').setValue(true);
					IsStopField.setValue(1);
					fg = 1;

				} else {
					IsStopField.setValue(0);
					fg = 1;
				}
				// alert(Ext.getCmp('IsStopField').getValue())
				// 窗口关闭后加载数据集
				ItemNamestartDs.on('beforeload', function (ds, o) {
					var IsStop = IsStopField.getValue() ? 1 : 0
						ds.proxy = new Ext.data.HttpProxy({
							url: '../csp/herp.acct.DepAssAcctSumReportexe.csp?action=GetCIname&bookID=' + bookID + '&isStop=' + IsStop,
							method: 'POST'
						});
				});

			});
		}
	});

	var ItemNameEndDs = new Ext.data.Store({
			// autoLoad:true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['CheckItemCode', 'CheckItemName'])
		});
	ItemNameEndDs.on('beforeload', function (ds, o) {
		var IsStop = IsStopField.getValue() ? 1 : 0
			ds.proxy = new Ext.data.HttpProxy({
				url: '../csp/herp.acct.DepAssAcctSumReportexe.csp?action=GetCIname&bookID=' + bookID + '&isStop=' + IsStop,
				method: 'POST'
			});
	});

	var CheckItemNameField2 = new Ext.form.ComboBox({
			id: 'CheckItemNameField2',
			fieldLabel: '科室范围终',
			store: ItemNameEndDs,
			labelSeparator:'',
			valueField: 'CheckItemCode',
			displayField: 'CheckItemName',
			emptyText: '请选择科室范围...',
			typeAhead: true,
			width: 150,
			listWidth: 230,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1
		});

	//----------取会计科目编码、名称-----------//
	var GetAcctSubjProxy = new Ext.data.HttpProxy({
			url: 'herp.acct.DepAssAcctSumReportexe.csp?action=GetAcctSubj&bookID=' + bookID, //&subjstr='+SubjCodeNameField1.getValue(),	//Ext.getCmp('SubjCodeNameField1').getRawValue(),
			method: 'POST'
		});
	var GetAcctSubjDS = new Ext.data.Store({
			proxy: GetAcctSubjProxy,
			reader: new Ext.data.JsonReader({
				root: 'rows',
				totalProperty: 'results'
			},
				['AcctSubjCode', 'AcctCodeName']),
			remoteSort: true
		});

	var GetAcctSubjField = new Ext.form.ComboBox({
			id: 'GetAcctSubjField',
			store: GetAcctSubjDS,
			displayField: 'AcctCodeName',
			labelSeparator:'',
			valueField: 'AcctSubjCode',
			fieldLabel: '会计科目',
			width: 150,
			listWidth: 260,
			pageSize: 10,
			minChars: 1,
			emptyText: '请选择会计科目...',
			selectOnFocus: true,
			triggerAction: 'all',
			forceSelection: true
		});

	//-----------科目级别------------//
	var SubjLevelStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyvalue'],
			data: [['1', '1级'], ['2', '2级'], ['3', '3级'], ['4', '4级'], ['5', '5级'], ['6', '6级'], ['7', '7级'], ['8', '8级']]
		});
	var SubjLevelField = new Ext.form.ComboBox({
			id: 'SubjLevelField',
			fieldLabel: '科目级别',
			labelSeparator:'',
			width: 150,
			store: SubjLevelStore,
			emptyText: '请选择科目级别...',
			displayField: 'keyvalue',
			valueField: 'key',
			//value:'1',	//设默认值
			mode: 'local',
			selectOnFocus: true,
			triggerAction: 'all',
			forceSelection: true
		});

	//------------包含未记账复选框-------------//
	var VouchStateField = new Ext.form.Checkbox({
			id: "VouchStateField",
			fieldLabel: '包含未记账',
			labelSeparator:'',
			inputValue: 1,
			style: 'border:0;background:none;margin-top:0px;',
			checked: false
		});
	//------------借方金额-------------//
	var AmtDebitField = new Ext.form.Checkbox({
			id: "AmtDebitField",
			fieldLabel: '借方金额',
			labelSeparator:'',
			inputValue: 1,
			style: 'border:0;background:none;margin-top:0px;',
			checked: false
		});
	//------------包含分摊管理-------------//
	var OutSubjCodeField = new Ext.form.Checkbox({
			id: "OutSubjCodeField",
			fieldLabel: '包含分摊管理',
			inputValue: 1,
			labelSeparator:'',
			style: 'border:0;background:none;margin-top:0px;',
			checked: false
		});
	//------------包含停用科室-------------//
	var IsStopField = new Ext.form.Checkbox({
			id: "IsStopField",
			fieldLabel: '包含停用科室',
			labelSeparator:'',
			inputValue: 1,
			style: 'border:0;background:none;margin-top:0px;',
			disabled: true,
			checked: false
		});

	//////////////部门核算汇总表查询条件end//////////


	var frm = new Ext.form.FormPanel({

			labelAlign: 'right',
			title: '查询条件',
			iconCls:'find',
			width: 400,
			heigth: 400,
			frame: true,
			region: 'east',
			labelWidth: 120,
			// buttonAlign: 'center',

			// closable: true, //这个属性就可以控制关闭该from
			items: [{
					xtype: 'fieldset',
					style:"padding:5px;",
					//title : '报表类型',
					items: [startYearMonth, endYearMonth, CheckItemNameField1, CheckItemNameField2, GetAcctSubjField,
						SubjLevelField, VouchStateField, AmtDebitField, //OutSubjCodeField,
						IsStopField]
				}, {
					xtype: 'button',
					style: "margin-left:45%;",
					width: 55,
					iconCls: 'find',
					Align: 'center',
					text: '查询',
					handler: function () {

						FindQuery();
					}
				}
			]

		});

	SchemGrid.on('rowclick', function (grid, rowIndex, e) {

		var object = SchemGrid.getSelectionModel().getSelections();
		var rowObjID = object[0].get("rowid");
		if (rowObjID == "" || rowObjID == null || rowObjID == undefined) {
			SchemGrid.edit = true;
		} else {

			var code = object[0].get("code");
			var SchemDesc = object[0].get("desc");
			//alert(SchemDesc);
			var arr = SchemDesc.split(";");

			startYearMonth.setValue(arr[0]);
			endYearMonth.setValue(arr[1]);
			CheckItemNameField1.setValue(arr[2]);
			CheckItemNameField2.setValue(arr[3]);
			GetAcctSubjField.setValue(arr[4]);
			SubjLevelField.setValue(arr[5]);

			if (arr[6] == 1) {
				VouchStateField.setValue(1);
			} else {
				VouchStateField.setValue(0);
			}
			if (arr[7] == 1) {
				AmtDebitField.setValue(1);
			} else {
				AmtDebitField.setValue(0);
			}
			if (arr[8] == 1) {
				OutSubjCodeField.setValue(1);
			} else {
				OutSubjCodeField.setValue(0);
			}
			if (arr[9] == 1) {
				IsStopField.setValue(1);
			} else {
				IsStopField.setValue(0);
			}
		}
	});

	//能包含其他panel的是Ext.panel
	var fullForm = new Ext.Panel({
			//title: '查询方案管理',
			closable: true,
			border: true,
			layout: 'border',
			items: [SchemGrid, frm]
		});

	var window = new Ext.Window({
			// title: '查询方案管理',
			layout: 'fit',
			plain: true,
			width: 900,
			height: 500,
			modal: true,
			buttonAlign: 'center',
			items: fullForm,
			buttons: [{
					text: '关闭',
					iconCls:'cancel',
					handler: function () {
						window.close();
					}
				}
			]

		});
	window.show();

	function FindQuery() {

		//// startYearMonth endYearMonth CheckItemNameField1 CheckItemNameField2 GetAcctSubjField SubjLevelField
		// VouchStateField 	AmtDebitField OutSubjCodeField IsStopField


		var StartDate = Ext.getCmp('startYearMonth').getValue();
		//alert(StartDate);
		if (StartDate != "") {
			StartDate = StartDate.format('Y-m')
		};
		var EndDate = Ext.getCmp('endYearMonth').getValue();
		if (EndDate != "") {
			EndDate = EndDate.format('Y-m')
		};
		var ItemCode1 = Ext.getCmp('CheckItemNameField1').getRawValue();
		if (ItemCode1 != "") {
			ItemCode1 = ItemCode1.split(" ")[0];
		}
		var ItemCode2 = Ext.getCmp('CheckItemNameField2').getRawValue();
		if (ItemCode2 != "") {
			ItemCode2 = ItemCode2.split(" ")[0];
		}
		var SubjCode = Ext.getCmp('GetAcctSubjField').getRawValue();
		//  alert(SubjCode);

		var SubjLevel = Ext.getCmp('SubjLevelField').getValue();
		var VouchState = VouchStateField.getValue();
		if (VouchState == "")
			VouchState = 0;
		else
			VouchState = 1;
		var Amtdebit = AmtDebitField.getValue();
		if (Amtdebit == "")
			Amtdebit = 0;
		else
			Amtdebit = 1;
		var OutSubjcode = OutSubjCodeField.getValue();
		if (OutSubjcode == "")
			OutSubjcode = 0;
		else
			OutSubjcode = 1;
		var IsStop = IsStopField.getValue();
		if (IsStop == "")
			IsStop = 0;
		else
			IsStop = 1;
		window.close();
		var reportFrame = document.getElementById("frameReport");
		var p_URL = "";
		// alert(ItemCode1+""+ItemCode2+""+SubjCode);
		//后台userid,startdate,enddate,itemcode1,itemcode2,subjcode,subjlevel,vouchstate,amtdebit,outsubjcode,isStop
		//前台 startdate enddate itemcode1 itemcode2 subjcode subjlevel vouchstate outsubjcode amtdebit isStop
		//获取报表路径
		p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.DepartmentAssistantAcctSum.raq&startdate=' + StartDate + '&enddate=' + EndDate
			 + '&itemcode1=' + ItemCode1 + '&itemcode2=' + ItemCode2 + '&subjlevel=' + SubjLevel + '&vouchstate=' + VouchState
			 + '&amtdebit=' + Amtdebit + '&outsubjcode=' + OutSubjcode + '&isStop=' + IsStop + '&userid=' + userdr + '&subjcode=' + SubjCode;
		//alert(p_URL);
		reportFrame.src = p_URL;

	}

}
