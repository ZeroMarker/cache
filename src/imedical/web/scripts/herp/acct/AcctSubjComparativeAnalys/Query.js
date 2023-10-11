var projUrl = '../csp/herp.acct.acctsubjcomparativeanalysexe.csp';
var bookID = GetAcctBookID();
var acctbookid = bookID;
var userdr = session['LOGON.USERID']; //登录人ID
//连接报表Query
function Query() {

	//查询方案Grid的定义
	var SchemGrid = new dhc.herp.Grid({
			title: '查询方案维护',
			iconCls: 'maintain',
			region: 'center',
			url: projUrl,
			split: true,
			viewConfig: {
				forceFit: true
			},
			fields: [
				//var json=rowid^bookid^code^name^desc
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
					header: '<div style="text-align:center">方案编码</div>',
					width: 50,
					allowBlank: false,
					align: 'center',
					dataIndex: 'code'

				}, {
					id: 'name',
					header: '<div style="text-align:center">方案名称</div>',
					width: 140,
					allowBlank: false,
					align: 'left',
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
	//数据加载
	SchemGrid.load({
		params: {
			start: 0,
			limit: 10,
			bookID: bookID
		}
	});
	SchemGrid.addButton('-');
	// SchemGrid.addButton('<div style="color:red">说明：科目对比分析的方案编号以AN0103开头。</div>');
	SchemGrid.btnResetHide(); //隐藏重置按钮
	SchemGrid.btnPrintHide(); //隐藏打印按钮


	/*********************查询条件***************/

	//会计科目1
	var SubjCodeName1Ds = new Ext.data.Store({
			autoLoad: true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['subjId', 'subjCode', 'subjName', 'subjCodeName', 'subjCodeNameAll'])
		}); //返回Json串
	SubjCodeName1Ds.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=GetSubjCodeName&str=' + Ext.getCmp('SubjCodeName1').getRawValue() + '&bookID=' + acctbookid,
				method: 'POST'
			});
	});

	var SubjCodeName1 = new Ext.form.ComboBox({
			id: 'SubjCodeName1',
			fieldLabel: '科目范围',
			labelSeparator: '',
			store: SubjCodeName1Ds,
			valueField: 'subjCode',
			displayField: 'subjCodeName', //编码+名称
			width: 220,
			listWidth: 220,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: 'true'
		});

	//会计科目2
	var SubjCodeName2Ds = new Ext.data.Store({
			autoLoad: true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['subjId', 'subjCode', 'subjName', 'subjCodeName', 'subjCodeNameAll'])
		});
	SubjCodeName2Ds.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=GetSubjCodeName&str=' + Ext.getCmp('SubjCodeName2').getRawValue() + '&bookID=' + acctbookid,
				method: 'POST'
			});
	});

	var SubjCodeName2 = new Ext.form.ComboBox({
			id: 'SubjCodeName2',
			fieldLabel: '',
			store: SubjCodeName2Ds,
			valueField: 'subjCode',
			displayField: 'subjCodeName',
			width: 220,
			listWidth: 220,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: 'true'
		});

	//起始会计年月
	var YearMonth1 = new Ext.form.DateField({
			id: 'YearMonth1',
			fieldLabel: '基期',
			labelSeparator: '',
			format: 'Y-m',
			width: 100,
			emptyText: '',
			plugins: 'monthPickerPlugin'
		});
	//结束会计年月
	var YearMonth2 = new Ext.form.DateField({
			id: 'YearMonth2',
			fieldLabel: '对比期',
			labelSeparator: '',
			format: 'Y-m',
			width: 100,
			emptyText: '',
			plugins: 'monthPickerPlugin'
		});

	//科目级别
	var SubjLevelDs = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '1级'], ['2', '2级'], ['3', '3级'], ['4', '4级'],
				['5', '5级'], ['6', '6级'], ['7', '7级'], ['8', '8级']]
		});
	var SubjLevel = new Ext.form.ComboBox({
			store: SubjLevelDs,
			id: 'SubjLevel',
			fieldLabel: '科目级次',
			labelSeparator: '',
			allowBlank: false,
			width: 200,
			valueField: 'key',
			displayField: 'keyValue',
			mode: 'local', // 本地模式
			triggerAction: 'all',
			selectOnFocus: true,
			forceSelection: true

		});
	//数据分析类型
	//Descript:
	//1:借方发生额，2:贷方发生额，3:借方发生额-贷方发生额
	//4:贷方发生额-借方发生额  5；借方期末余额 6：贷方期末余额
	var AnalyTypeDs = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '借方发生额'], ['2', '贷方发生额'], ['3', '借方发生额-贷方发生额'],
				['4', '贷方发生额-借方发生额'], ['5', '借方期末余额'], ['6', '贷方期末余额']]
		});

	var AnalyType = new Ext.form.ComboBox({
			id: 'AnalyType',
			fieldLabel: '分析数据类型',
			labelSeparator: '',
			allowBlank: false,
			width: 200,
			store: AnalyTypeDs,
			valueField: 'key',
			displayField: 'keyValue',
			mode: 'local', // 本地模式
			triggerAction: 'all',
			selectOnFocus: true,
			forceSelection: true
		});

	var frm = new Ext.form.FormPanel({
			labelAlign: 'right',
			title: '查询条件',
			iconCls: 'find',
			width: 400,
			frame: true,
			region: 'east',
			labelWidth: 100,
			items: [{
					xtype: 'fieldset',
					style:"padding:5px;",
					items: [SubjCodeName1, SubjCodeName2,
						SubjLevel, AnalyType, YearMonth1, YearMonth2]
				}, {
					xtype: 'button',
					style: "marginLeft:40%",
					iconCls: 'find',
					width: 55,
					text: '查询',
					handler: function () {
						FindQuery();
					}
				}
			]
		});
	var CodeStr = "";
	var ConfigItems = [];
	//载入显示
	//SubjCode1,SubjName1, SubjCode2, SubjName2, yearmonth1,
	// yearmonth2, level, AnalysisType, AnalysisTypeDis, userdr
	SchemGrid.on('rowclick', function (grid, rowIndex, e) {

		var rowObj = SchemGrid.getSelectionModel().getSelections();
		var rowObjID = rowObj[0].get("rowid");
		if (rowObjID == "" || rowObjID == null || rowObjID == undefined) {
			SchemGrid.edit = true;
		} else {
			var SchemDesc = rowObj[0].get("desc"); //截取方案描述
			var code = rowObj[0].get("code");

			var arr = SchemDesc.split(";"); //按照分号截取方案
			var subjcodename1 = arr[0]; //截取会计科目
			SubjCodeName1.setValue(subjcodename1);
			var subjcodename2 = arr[1]; //截取会计科目
			SubjCodeName2.setValue(subjcodename2);

			var yearmonth1 = arr[2]; //截取方案的年
			YearMonth1.setValue(yearmonth1); //截取年度

			var yearmonth2 = arr[3];
			YearMonth2.setValue(yearmonth2); //截取年度

			var subjlevel = arr[4];
			SubjLevel.setValue(subjlevel); //科目级次

			var analytype = arr[5];
			AnalyType.setValue(analytype);
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
			height: 450,
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
		var SubjCodeName1 = Ext.getCmp('SubjCodeName1').getValue();
		var SubjCode1 = SubjCodeName1.trim().split(" ")[0];
		//alert(SubjCode1);
		var SubjName1 = Ext.getCmp('SubjCodeName1').getRawValue();
		var SubjName1 = SubjName1.split(" ")[1];

		var SubjCodeName2 = Ext.getCmp('SubjCodeName2').getValue();
		var SubjCode2 = SubjCodeName2.trim().split(" ")[0];

		// alert(SubjCode2);
		var SubjName2 = Ext.getCmp('SubjCodeName2').getRawValue();
		var SubjName2 = SubjName2.split(" ")[1];
		//var yearmonth1=Ext.getCmp('YearMonth1').getValue();
		//var yearmonth2=Ext.getCmp('YearMonth2').getValue();

		var startTime = Ext.getCmp('YearMonth1').getValue();
		if (startTime !== "") {
			yearmonth1 = startTime.format('Y-m');
		}
		var endTime = Ext.getCmp('YearMonth2').getValue();
		if (endTime !== "") {
			yearmonth2 = endTime.format('Y-m');
		}

		var level = Ext.getCmp('SubjLevel').getValue();

		var AnalysisType = Ext.getCmp('AnalyType').getValue();
		var AnalysisTypeDis = Ext.getCmp('AnalyType').getRawValue();

		window.close();
		var reportFrame = document.getElementById("frameReport");
		var p_URL = "";
		//获取报表路径

		//SubjCode1,SubjName1, SubjCode2, SubjName2, yearmonth1,
		// yearmonth2, level, AnalysisType, AnalysisTypeDis, userdr

		p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.AcctSubjComparativeAnalys.raq&&SubjCode1=' + SubjCode1 +
			'&SubjName1=' + SubjName1 + '&SubjCode2=' + SubjCode2 + '&SubjName2=' + SubjName2 +
			'&yearmonth1=' + yearmonth1 + '&yearmonth2=' + yearmonth2 + '&level=' + level +
			'&AnalysisType=' + AnalysisType + '&AnalysisTypeDis=' + AnalysisTypeDis + '&userdr=' + userdr;
		reportFrame.src = p_URL;

	}

}
