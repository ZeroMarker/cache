var userdr = session['LOGON.USERID']; //登录人ID
var bookID = IsExistAcctBook();
var projUrl = 'herp.acct.acctautodealcacelexe.csp';

/////////////往来核销会计科目
var CheckSubjDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['rowid', 'SubjCode', 'SubjNameAll', 'SubjCodeNameAll'])
	});

CheckSubjDs.on('beforeload', function (ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
			url: 'herp.acct.acctmanualdealcacelexe.csp?action=GetCheckSubj&str=' + encodeURIComponent(Ext.getCmp('CheckSubjCombo').getRawValue()) + '&userdr=' + userdr,
			method: 'POST'
		});
});
var CheckSubjCombo = new Ext.form.ComboBox({
		id: 'CheckSubjCombo',
		fieldLabel: '会计科目',
		store: CheckSubjDs,
		displayField: 'SubjCodeNameAll',
		valueField: 'rowid',
		typeAhead: true,
		triggerAction: 'all',
		emptyText: '请选择会计科目',
		width: 180,
		listWidth: 220,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: 'true'
	});

var startDateField = new Ext.form.DateField({
		id: 'startDateField',
		fieldLabel: '起始日期',
		// columnWidth : .1,
		width: 110,
		allowBlank: true,
		//format:'Y-m-d',
		selectOnFocus: 'true'
	});

var endDateField = new Ext.form.DateField({
		id: 'endDateField',
		fieldLabel: '起始日期',
		// columnWidth : .1,
		width: 110,
		allowBlank: true,
		//format:'Y-m-d',
		selectOnFocus: 'true'
	});

////核销条件
var ischecked = new Ext.form.CheckboxGroup({
		fieldLabel: '核销条件',
		width: 250,
		// hideLabel:true,
		defaults: {
			style: "border:0;background:none;margin-top:0px;"
		},
		items: [{
				id: 'all',
				boxLabel: '往来对象',
				name: '1',
				checked: true
			}, {
				id: 'checked',
				boxLabel: '票据号',
				name: '2'
			}, {
				id: 'unchecked',
				boxLabel: '金额',
				name: '3',
				checked: true
			}
		]
	});

var CheckButton = new Ext.Button({
		text: '自动核销',
		iconCls: 'autocheck',
		width: 80,
		handler: function () {

			var SubjNameField = new Ext.form.DisplayField({
					fieldLabel: '自动核销科目',
					width: 300
				});

			var ChexkDateField = new Ext.form.DisplayField({
					fieldLabel: '自动核销时间区间',
					width: 300
				});
			//取核销科目
			var subjname = CheckSubjCombo.getRawValue();
			if (!subjname)
				SubjNameField.setValue("所有核销科目");
			else
				SubjNameField.setValue(subjname);

			//取核销时间
			var startdate = startDateField.getValue();
			if (startdate !== "") {
				startdate = startdate.format('Y-m-d');
			}
			//alert(startdate);
			var enddate = endDateField.getValue();
			if (enddate !== "") {
				enddate = enddate.format('Y-m-d');
			}
			//var DateInterval=startdate+'--'+enddate;
			var DateInterval = startDateField.getRawValue() + '--' + endDateField.getRawValue();
			
			if(DateInterval=='--') {
				DateInterval="截至到已记账凭证的最新制作日期";
			}
			ChexkDateField.setValue(DateInterval);
			
			var formPanel = new Ext.form.FormPanel({
					//baseCls: 'x-plain',
					labelWidth: 130,
					labelAlign:'right',
					width: 200,
					frame: true,
					items: [SubjNameField, ChexkDateField]
				});

			var checksubjId = CheckSubjCombo.getValue();
			var names = [];
			var cbitems = ischecked.items;
			for (var i = 0; i < cbitems.length; i++) {
				if (cbitems.itemAt(i).checked) {
					names.push(cbitems.itemAt(i).name);
				}
			};
			var window = new Ext.Window({
					width: 500,
					height: 170,
					layout: 'fit',
					plain: true,
					modal: true,
					bodyStyle: 'padding:10px 5px;',
					buttonAlign: 'center',
					items: formPanel,
					buttons: [{
							text: '确定',
							handler: function () {
								var progressBar = Ext.Msg.show({
										title: "自动核销",
										msg: "'数据正在处理中...",
										width: 300,
										wait: true,
										closable: true
									});
								Ext.Ajax.request({
									url: '../csp/herp.acct.acctautodealcacelexe.csp?action=autocheck&&checksubjId=' + checksubjId + '&startdate=' + startdate + '&enddate=' + enddate + '&names=' + encodeURIComponent(names) + '&userdr=' + session['LOGON.USERID'],
									failure: function (result, request) {
										Ext.Msg.show({
											title: '错误',
											msg: '请检查网络连接!',
											buttons: Ext.Msg.OK,
											icon: Ext.MessageBox.ERROR
										});
									},
									success: function (result, request) {
										var jsonData = Ext.util.JSON.decode(result.responseText);
										if (jsonData.success == 'true') {
											Ext.Msg.show({
												title: '注意',
												msg: '自动核销成功!',
												buttons: Ext.Msg.OK,
												icon: Ext.MessageBox.INFO
											});
											window.close();
											ItemGrid.load({
												params: {
													start: 0,
													limit: 12
												}
											});

										} else if(jsonData.info=="NoData"){
											Ext.Msg.show({
												title: '提示',
												msg: '没有符合条件的核销数据! ',
												buttons: Ext.Msg.OK,
												icon: Ext.MessageBox.ERROR
											});
										}else {
											Ext.Msg.show({
												title: '错误',
												msg: jsonData.info,
												buttons: Ext.Msg.OK,
												icon: Ext.MessageBox.ERROR
											});
										}
									},
									scope: this
								});
							}
						}, {
							text: '取消',
							handler: function () {
								window.close();
							}
						}
					]
				});
			window.show();
		}
	});

var queryPanel = new Ext.FormPanel({
	    title: '往来核销-自动核销',
	    iconCls:'find',
		height: 70,
		region: 'north',
		frame: true,
		defaults: {
			bodyStyle: 'padding:3px 0 0 0'
		},
		items: [{
				xtype: 'panel',
				layout: 'column',
				// hideLabel: true,
				// width:1200,
				items: [{
						xtype: 'displayfield',
						value: '往来科目',
						style: 'line-height: 15px;',
						width: 60
					},
					CheckSubjCombo, {
						xtype: 'displayfield',
						value: '',
						width: 20
					}, {
						xtype: 'displayfield',
						value: '时间范围',
						style: 'line-height: 15px;',
						width: 60
					},
					startDateField, {
						xtype: 'displayfield',
						value: '--'
						//width : 10
					},
					endDateField, {
						xtype: 'displayfield',
						value: '',
						width: 20
					}, {
						xtype: 'displayfield',
						value: '核销条件',
						style: 'line-height: 15px;',
						width: 60
					},
					ischecked, {
						xtype: 'displayfield',
						value: '',
						width: 0
					}, CheckButton]
			}
		]
	});

//var summary = new Ext.ux.grid.GridSummary(); //声明
var ItemGrid = new dhc.herp.Grid({
		region: 'center',
		url: projUrl,
		//plugins: [summary],
		// tbar:['往来科目:',CheckSubjCombo,'-','开始时间:',startDateField,'-','结束时间:',endDateField,'-','核销条件:',ischecked,'-',CheckButton],
		fields: [
			//CheckItemCode^CheckItemName^checkCount^SumAmtDebit^UncheckAmtDebit^UncheckAmtCredit
			{
				id: 'CheckItemID',
				header: '往来对象ID',
				allowBlank: false,
				hidden: true,
				dataIndex: 'CheckItemID'
			}, {
				id: 'CheckItemCode',
				header: '往来编码',
				allowBlank: false,
				align: 'center',
				editable: false,
				width: 150,
				update: true,
				dataIndex: 'CheckItemCode'
			}, {
				id: 'CheckItemName',
				header: '<div style="text-align:center">往来单位名称</div>',
				//hidden:false,
				width: 180,
				editable: false,
				dataIndex: 'CheckItemName'

			}, {
				id: 'checkCount',
				header: '本次核销记录数',
				align: 'center',
				width: 130,
				hidden: false,
				editable: false,
				summaryType: 'sum',
				dataIndex: 'checkCount'
			}, {
				id: 'SumAmtDebit',
				header: '<div style="text-align:center">本次核销总金额</div>',
				align: 'right',
				width: 150,
				hidden: false,
				editable: false,
				summaryType: 'sum',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				dataIndex: 'SumAmtDebit'
			}, {
				id: 'UncheckAmtDebit',
				header: '<div style="text-align:center">借方未核销总金额</div>',
				align: 'right',
				width: 150,
				hidden: false,
				editable: false,
				summaryType: 'sum',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				dataIndex: 'UncheckAmtDebit'
			}, {
				id: 'UncheckAmtCredit',
				header: '<div style="text-align:center">贷方未核销总金额</div>',
				align: 'right',
				width: 150,
				hidden: false,
				editable: false,
				summaryType: 'sum',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				dataIndex: 'UncheckAmtCredit'
			}
		]
	});

ItemGrid.btnAddHide(); //隐藏增加按钮
ItemGrid.btnSaveHide(); //隐藏保存按钮
ItemGrid.btnDeleteHide(); //隐藏删除按钮
ItemGrid.btnResetHide(); //隐藏重置按钮
ItemGrid.btnPrintHide(); //隐藏打印按钮
/*
function GridSum(grid)
{
var sum1 = 0; //存储第一个列的合计值
var sum2 = 0; //存储第二个列的合计值
//...有几个列需要合计就声明几个变量
ItemGrid.store.each(function(record){ //函数grid.store.each(record))相当于一个for循环，遍历整个record
sum1 += Number(record.data.checkCount); //把money1列下面的所有值进行加和运算
sum2 += record.data.SumAmtDebit; //把money2列下面的所有值进行加和运算
});
var p = new Ext.data.Record(
{
checkCount:sum1, //把money1列与合计后得到的值对应起来
SumAmtDebit:sum2 //把money2列与合计后得到的值对应起来
}
);
//grid.store.insert(0, p);// 插入到当前页的第一行

grid.store.insert(ItemGrid.getStore().getCount(), p); //插入到当前页的最后一行，函数 grid.getStore().getCount()用来获得当前页的记录行数

}
ItemGrid.getStore().on('load', function() {

GridSum(ItemGrid);//调用合计函数,gridui是你页面中定义的gridui变量名,这里作为参数传递给GridSum()函数

});
 */
//单击gird的单元格事件
ItemGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {
	var records = ItemGrid.getSelectionModel().getSelections();
	var CheckItemID = records[0].get("CheckItemID");
	var CheckItemName = records[0].get("CheckItemName");
	var checksubjId = CheckSubjCombo.getValue();
	var startdate = startDateField.getValue();
	var SumAmtDebit=records[0].get("SumAmtDebit");
	var UncheckAmtDebit=records[0].get("UncheckAmtDebit");
	var UncheckAmtCredit=records[0].get("UncheckAmtCredit");
	//alert(SumAmtDebit+" "+UncheckAmtDebit+" "+UncheckAmtCredit)
	if (startdate !== "") {
		startdate = startdate.format('Y-m-d');
	}
	//alert(startdate);
	var enddate = endDateField.getValue();
	if (enddate !== "") {
		enddate = enddate.format('Y-m-d');
	}
	if ((columnIndex == 5)&&(SumAmtDebit!="")&&(CheckItemName!="")) {
		CheckAmtFun(CheckItemName, checksubjId, startdate, enddate, CheckItemID, userdr);
	}
	if ((columnIndex == 6)&&(UncheckAmtDebit!="")&&(CheckItemName!="")) {
		UnCheckAmtDebitFun(CheckItemName, checksubjId, startdate, enddate, CheckItemID, userdr);
	}
	if ((columnIndex == 7)&&(UncheckAmtCredit!="")&&(CheckItemName!="")) {
		UnCheckAmtCreditFun(CheckItemName, checksubjId, startdate, enddate, CheckItemID, userdr);
	}
})
