var projUrl = '../csp/herp.acct.acctsubjcomparativeanalysexe.csp';
var bookID = GetAcctBookID();
var acctbookid = bookID;
var userdr = session['LOGON.USERID']; //��¼��ID
//���ӱ���Query
function Query() {

	//��ѯ����Grid�Ķ���
	var SchemGrid = new dhc.herp.Grid({
			title: '��ѯ����ά��',
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
					header: '<div style="text-align:center">����id</div>',
					align: 'right',
					editable: false,
					width: 140,
					hidden: true,
					dataIndex: 'bookid'
				}, {
					id: 'code',
					header: '<div style="text-align:center">��������</div>',
					width: 50,
					allowBlank: false,
					align: 'center',
					dataIndex: 'code'

				}, {
					id: 'name',
					header: '<div style="text-align:center">��������</div>',
					width: 140,
					allowBlank: false,
					align: 'left',
					dataIndex: 'name'
				}, {
					id: 'desc',
					header: '��������',
					width: 220,
					allowBlank: true,
					hidden: true,
					dataIndex: 'desc'
				}
			]
		});
	//���ݼ���
	SchemGrid.load({
		params: {
			start: 0,
			limit: 10,
			bookID: bookID
		}
	});
	SchemGrid.addButton('-');
	// SchemGrid.addButton('<div style="color:red">˵������Ŀ�Աȷ����ķ��������AN0103��ͷ��</div>');
	SchemGrid.btnResetHide(); //�������ð�ť
	SchemGrid.btnPrintHide(); //���ش�ӡ��ť


	/*********************��ѯ����***************/

	//��ƿ�Ŀ1
	var SubjCodeName1Ds = new Ext.data.Store({
			autoLoad: true,
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['subjId', 'subjCode', 'subjName', 'subjCodeName', 'subjCodeNameAll'])
		}); //����Json��
	SubjCodeName1Ds.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=GetSubjCodeName&str=' + Ext.getCmp('SubjCodeName1').getRawValue() + '&bookID=' + acctbookid,
				method: 'POST'
			});
	});

	var SubjCodeName1 = new Ext.form.ComboBox({
			id: 'SubjCodeName1',
			fieldLabel: '��Ŀ��Χ',
			labelSeparator: '',
			store: SubjCodeName1Ds,
			valueField: 'subjCode',
			displayField: 'subjCodeName', //����+����
			width: 220,
			listWidth: 220,
			triggerAction: 'all',
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: 'true'
		});

	//��ƿ�Ŀ2
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

	//��ʼ�������
	var YearMonth1 = new Ext.form.DateField({
			id: 'YearMonth1',
			fieldLabel: '����',
			labelSeparator: '',
			format: 'Y-m',
			width: 100,
			emptyText: '',
			plugins: 'monthPickerPlugin'
		});
	//�����������
	var YearMonth2 = new Ext.form.DateField({
			id: 'YearMonth2',
			fieldLabel: '�Ա���',
			labelSeparator: '',
			format: 'Y-m',
			width: 100,
			emptyText: '',
			plugins: 'monthPickerPlugin'
		});

	//��Ŀ����
	var SubjLevelDs = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '1��'], ['2', '2��'], ['3', '3��'], ['4', '4��'],
				['5', '5��'], ['6', '6��'], ['7', '7��'], ['8', '8��']]
		});
	var SubjLevel = new Ext.form.ComboBox({
			store: SubjLevelDs,
			id: 'SubjLevel',
			fieldLabel: '��Ŀ����',
			labelSeparator: '',
			allowBlank: false,
			width: 200,
			valueField: 'key',
			displayField: 'keyValue',
			mode: 'local', // ����ģʽ
			triggerAction: 'all',
			selectOnFocus: true,
			forceSelection: true

		});
	//���ݷ�������
	//Descript:
	//1:�跽�����2:���������3:�跽������-����������
	//4:����������-�跽������  5���跽��ĩ��� 6��������ĩ���
	var AnalyTypeDs = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '�跽������'], ['2', '����������'], ['3', '�跽������-����������'],
				['4', '����������-�跽������'], ['5', '�跽��ĩ���'], ['6', '������ĩ���']]
		});

	var AnalyType = new Ext.form.ComboBox({
			id: 'AnalyType',
			fieldLabel: '������������',
			labelSeparator: '',
			allowBlank: false,
			width: 200,
			store: AnalyTypeDs,
			valueField: 'key',
			displayField: 'keyValue',
			mode: 'local', // ����ģʽ
			triggerAction: 'all',
			selectOnFocus: true,
			forceSelection: true
		});

	var frm = new Ext.form.FormPanel({
			labelAlign: 'right',
			title: '��ѯ����',
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
					text: '��ѯ',
					handler: function () {
						FindQuery();
					}
				}
			]
		});
	var CodeStr = "";
	var ConfigItems = [];
	//������ʾ
	//SubjCode1,SubjName1, SubjCode2, SubjName2, yearmonth1,
	// yearmonth2, level, AnalysisType, AnalysisTypeDis, userdr
	SchemGrid.on('rowclick', function (grid, rowIndex, e) {

		var rowObj = SchemGrid.getSelectionModel().getSelections();
		var rowObjID = rowObj[0].get("rowid");
		if (rowObjID == "" || rowObjID == null || rowObjID == undefined) {
			SchemGrid.edit = true;
		} else {
			var SchemDesc = rowObj[0].get("desc"); //��ȡ��������
			var code = rowObj[0].get("code");

			var arr = SchemDesc.split(";"); //���շֺŽ�ȡ����
			var subjcodename1 = arr[0]; //��ȡ��ƿ�Ŀ
			SubjCodeName1.setValue(subjcodename1);
			var subjcodename2 = arr[1]; //��ȡ��ƿ�Ŀ
			SubjCodeName2.setValue(subjcodename2);

			var yearmonth1 = arr[2]; //��ȡ��������
			YearMonth1.setValue(yearmonth1); //��ȡ���

			var yearmonth2 = arr[3];
			YearMonth2.setValue(yearmonth2); //��ȡ���

			var subjlevel = arr[4];
			SubjLevel.setValue(subjlevel); //��Ŀ����

			var analytype = arr[5];
			AnalyType.setValue(analytype);
		}
	});

	//�ܰ�������panel����Ext.panel
	var fullForm = new Ext.Panel({
			//title: '��ѯ��������',
			closable: true,
			border: true,
			layout: 'border',
			items: [SchemGrid, frm]
		});

	var window = new Ext.Window({
			// title: '��ѯ��������',
			layout: 'fit',
			plain: true,
			width: 900,
			height: 450,
			modal: true,
			buttonAlign: 'center',
			items: fullForm,
			buttons: [{
					text: '�ر�',
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
		//��ȡ����·��

		//SubjCode1,SubjName1, SubjCode2, SubjName2, yearmonth1,
		// yearmonth2, level, AnalysisType, AnalysisTypeDis, userdr

		p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.AcctSubjComparativeAnalys.raq&&SubjCode1=' + SubjCode1 +
			'&SubjName1=' + SubjName1 + '&SubjCode2=' + SubjCode2 + '&SubjName2=' + SubjName2 +
			'&yearmonth1=' + yearmonth1 + '&yearmonth2=' + yearmonth2 + '&level=' + level +
			'&AnalysisType=' + AnalysisType + '&AnalysisTypeDis=' + AnalysisTypeDis + '&userdr=' + userdr;
		reportFrame.src = p_URL;

	}

}
