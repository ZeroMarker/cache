var userdr = session['LOGON.USERID']; //��¼��ID
var bookID = IsExistAcctBook();
var projUrl = 'herp.acct.acctautodealcacelexe.csp';

/////////////����������ƿ�Ŀ
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
		fieldLabel: '��ƿ�Ŀ',
		store: CheckSubjDs,
		displayField: 'SubjCodeNameAll',
		valueField: 'rowid',
		typeAhead: true,
		triggerAction: 'all',
		emptyText: '��ѡ���ƿ�Ŀ',
		width: 180,
		listWidth: 220,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: 'true'
	});

var startDateField = new Ext.form.DateField({
		id: 'startDateField',
		fieldLabel: '��ʼ����',
		// columnWidth : .1,
		width: 110,
		allowBlank: true,
		//format:'Y-m-d',
		selectOnFocus: 'true'
	});

var endDateField = new Ext.form.DateField({
		id: 'endDateField',
		fieldLabel: '��ʼ����',
		// columnWidth : .1,
		width: 110,
		allowBlank: true,
		//format:'Y-m-d',
		selectOnFocus: 'true'
	});

////��������
var ischecked = new Ext.form.CheckboxGroup({
		fieldLabel: '��������',
		width: 250,
		// hideLabel:true,
		defaults: {
			style: "border:0;background:none;margin-top:0px;"
		},
		items: [{
				id: 'all',
				boxLabel: '��������',
				name: '1',
				checked: true
			}, {
				id: 'checked',
				boxLabel: 'Ʊ�ݺ�',
				name: '2'
			}, {
				id: 'unchecked',
				boxLabel: '���',
				name: '3',
				checked: true
			}
		]
	});

var CheckButton = new Ext.Button({
		text: '�Զ�����',
		iconCls: 'autocheck',
		width: 80,
		handler: function () {

			var SubjNameField = new Ext.form.DisplayField({
					fieldLabel: '�Զ�������Ŀ',
					width: 300
				});

			var ChexkDateField = new Ext.form.DisplayField({
					fieldLabel: '�Զ�����ʱ������',
					width: 300
				});
			//ȡ������Ŀ
			var subjname = CheckSubjCombo.getRawValue();
			if (!subjname)
				SubjNameField.setValue("���к�����Ŀ");
			else
				SubjNameField.setValue(subjname);

			//ȡ����ʱ��
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
				DateInterval="�������Ѽ���ƾ֤��������������";
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
							text: 'ȷ��',
							handler: function () {
								var progressBar = Ext.Msg.show({
										title: "�Զ�����",
										msg: "'�������ڴ�����...",
										width: 300,
										wait: true,
										closable: true
									});
								Ext.Ajax.request({
									url: '../csp/herp.acct.acctautodealcacelexe.csp?action=autocheck&&checksubjId=' + checksubjId + '&startdate=' + startdate + '&enddate=' + enddate + '&names=' + encodeURIComponent(names) + '&userdr=' + session['LOGON.USERID'],
									failure: function (result, request) {
										Ext.Msg.show({
											title: '����',
											msg: '������������!',
											buttons: Ext.Msg.OK,
											icon: Ext.MessageBox.ERROR
										});
									},
									success: function (result, request) {
										var jsonData = Ext.util.JSON.decode(result.responseText);
										if (jsonData.success == 'true') {
											Ext.Msg.show({
												title: 'ע��',
												msg: '�Զ������ɹ�!',
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
												title: '��ʾ',
												msg: 'û�з��������ĺ�������! ',
												buttons: Ext.Msg.OK,
												icon: Ext.MessageBox.ERROR
											});
										}else {
											Ext.Msg.show({
												title: '����',
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
							text: 'ȡ��',
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
	    title: '��������-�Զ�����',
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
						value: '������Ŀ',
						style: 'line-height: 15px;',
						width: 60
					},
					CheckSubjCombo, {
						xtype: 'displayfield',
						value: '',
						width: 20
					}, {
						xtype: 'displayfield',
						value: 'ʱ�䷶Χ',
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
						value: '��������',
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

//var summary = new Ext.ux.grid.GridSummary(); //����
var ItemGrid = new dhc.herp.Grid({
		region: 'center',
		url: projUrl,
		//plugins: [summary],
		// tbar:['������Ŀ:',CheckSubjCombo,'-','��ʼʱ��:',startDateField,'-','����ʱ��:',endDateField,'-','��������:',ischecked,'-',CheckButton],
		fields: [
			//CheckItemCode^CheckItemName^checkCount^SumAmtDebit^UncheckAmtDebit^UncheckAmtCredit
			{
				id: 'CheckItemID',
				header: '��������ID',
				allowBlank: false,
				hidden: true,
				dataIndex: 'CheckItemID'
			}, {
				id: 'CheckItemCode',
				header: '��������',
				allowBlank: false,
				align: 'center',
				editable: false,
				width: 150,
				update: true,
				dataIndex: 'CheckItemCode'
			}, {
				id: 'CheckItemName',
				header: '<div style="text-align:center">������λ����</div>',
				//hidden:false,
				width: 180,
				editable: false,
				dataIndex: 'CheckItemName'

			}, {
				id: 'checkCount',
				header: '���κ�����¼��',
				align: 'center',
				width: 130,
				hidden: false,
				editable: false,
				summaryType: 'sum',
				dataIndex: 'checkCount'
			}, {
				id: 'SumAmtDebit',
				header: '<div style="text-align:center">���κ����ܽ��</div>',
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
				header: '<div style="text-align:center">�跽δ�����ܽ��</div>',
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
				header: '<div style="text-align:center">����δ�����ܽ��</div>',
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

ItemGrid.btnAddHide(); //�������Ӱ�ť
ItemGrid.btnSaveHide(); //���ر��水ť
ItemGrid.btnDeleteHide(); //����ɾ����ť
ItemGrid.btnResetHide(); //�������ð�ť
ItemGrid.btnPrintHide(); //���ش�ӡ��ť
/*
function GridSum(grid)
{
var sum1 = 0; //�洢��һ���еĺϼ�ֵ
var sum2 = 0; //�洢�ڶ����еĺϼ�ֵ
//...�м�������Ҫ�ϼƾ�������������
ItemGrid.store.each(function(record){ //����grid.store.each(record))�൱��һ��forѭ������������record
sum1 += Number(record.data.checkCount); //��money1�����������ֵ���мӺ�����
sum2 += record.data.SumAmtDebit; //��money2�����������ֵ���мӺ�����
});
var p = new Ext.data.Record(
{
checkCount:sum1, //��money1����ϼƺ�õ���ֵ��Ӧ����
SumAmtDebit:sum2 //��money2����ϼƺ�õ���ֵ��Ӧ����
}
);
//grid.store.insert(0, p);// ���뵽��ǰҳ�ĵ�һ��

grid.store.insert(ItemGrid.getStore().getCount(), p); //���뵽��ǰҳ�����һ�У����� grid.getStore().getCount()������õ�ǰҳ�ļ�¼����

}
ItemGrid.getStore().on('load', function() {

GridSum(ItemGrid);//���úϼƺ���,gridui����ҳ���ж����gridui������,������Ϊ�������ݸ�GridSum()����

});
 */
//����gird�ĵ�Ԫ���¼�
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
