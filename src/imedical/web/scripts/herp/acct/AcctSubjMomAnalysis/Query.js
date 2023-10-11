//---------------���ӱ���Query
function Query() {

	var SchemGrid = new dhc.herp.Grid({
		    iconCls:'maintain',
			title : '��ѯ����ά��',
			region : 'center',
			atLoad : true,
			url : 'herp.acct.acctsubjanalysisexe.csp',
			// split : true,
			viewConfig : {
				forceFit : true
			},
			fields : [//new Ext.grid.CheckboxSelectionModel({editable:false}),
				{
					id : 'rowid',
					header : 'ID',
					width : 100,
					editable : false,
					hidden : true,
					dataIndex : 'rowid'
				}, {
					id : 'bookid',
					header : '<div style="text-align:center">����id</div>',
					align : 'right',
					editable : false,
					width : 140,
					hidden : true,
					dataIndex : 'bookid'
				}, {
					id : 'code',
					header : '<div style="text-align:center">�������</div>',
					width : 50,
					align : 'left',
					allowBlank : false,
					dataIndex : 'code'

				}, {
					id : 'name',
					header : '<div style="text-align:center">��������</div>',
					width : 140,
					align : 'left',
					allowBlank : false,
					dataIndex : 'name'
				}, {
					id : 'desc',
					header : '��������',
					width : 220,
					allowBlank : true,
					hidden : true,
					dataIndex : 'desc'
				}
			]
		});

	SchemGrid.load({
		params : {
			start : 0,
			limit : 10,
			bookID : AcctBookID
		}
	});

	// SchemGrid.addButton('-');
	// SchemGrid.addButton('<div style="color:red">˵������Ŀ���ȷ����ķ��������AN0102��ͷ��</div>');
	SchemGrid.btnResetHide(); //�������ð�ť
	SchemGrid.btnPrintHide(); //���ش�ӡ��ť


	//----------ȡ��Ŀ���롢����-----------//
	var SubjCodeNameProxy = new Ext.data.HttpProxy({
			url : 'herp.acct.acctsubjanalysisexe.csp?action=GetSubjCodeName&bookID=' + AcctBookID,
			method : 'POST'
		});
	var SubjCodeNameDS = new Ext.data.Store({
			proxy : SubjCodeNameProxy,
			reader : new Ext.data.JsonReader({
				idProperty : 'id',
				root : 'rows',
				totalProperty : 'results'

			},
				['subjCode', 'subjCodeName']),
			remoteSort : true
		});

	var SubjCodeNameField1 = new Ext.form.ComboBox({
			id : 'SubjCodeNameField1',
			store : SubjCodeNameDS,
			displayField : 'subjCodeName',
			valueField : 'subjCode',
			fieldLabel : '��Ŀ��Χ',
			labelSeparator:'',
			width : 200,
			listWidth : 235,
			pageSize : 10,
			minChars : 1,
			emptyText : '��ѡ��...',
			selectOnFocus : true,
			triggerAction : 'all',
			forceSelection : true
		});

	var SubjCodeNameField2 = new Ext.form.ComboBox({
			id : 'SubjCodeNameField2',
			store : SubjCodeNameDS,
			displayField : 'subjCodeName',
			valueField : 'subjCode',
			width : 200,
			listWidth : 235,
			pageSize : 10,
			minChars : 1,
			emptyText : '��ѡ��...',
			selectOnFocus : true,
			triggerAction : 'all',
			forceSelection : true
		});

	//-----------��Ŀ����------------//
	var SubjLevelStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyvalue'],
			data : [['1', '1��'], ['2', '2��'], ['3', '3��'], ['4', '4��'], ['5', '5��'], ['6', '6��'], ['7', '7��'], ['8', '8��']]
		});
	var SubjLevelField = new Ext.form.ComboBox({
			id : 'SubjLevelField',
			width : 90,
			store : SubjLevelStore,
			displayField : 'keyvalue',
			valueField : 'key',
			fieldLabel : '��Ŀ����',
			labelSeparator:'',
			value : '1', //��Ĭ��ֵ
			triggerAction : 'all',
			mode : 'local',
			selectOnFocus : true,
			triggerAction : 'all',
			forceSelection : true
		});
	//----------------����ڼ�-----------//
	var AcctYearMonthField1 = new Ext.form.DateField({
			id : 'AcctYearMonthField1',
			fieldLabel : '����ڼ�',
			labelSeparator:'',
			width : 90,
			listWidth : 187,
			emptyText : '��ѡ��...',
			format : 'Y-m',
			plugins : 'monthPickerPlugin',
			selectOnFocus : true,
			triggerAction : 'all',
			forceSelection : true,
			editable : true
		});

	var AcctYearMonthField2 = new Ext.form.DateField({
			id : 'AcctYearMonthField2',
			fieldLabel : '',
			width : 90,
			listWidth : 187,
			emptyText : '��ѡ��...',
			format : 'Y-m',
			plugins : 'monthPickerPlugin',
			selectOnFocus : true,
			triggerAction : 'all',
			forceSelection : true,
			editable : true
		});

	//------------������������-------------//
	var AnalysisTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyvalue'],
			data : [['1', '�跽������'], ['2', '����������'], ['3', '�跽������-����������'], ['4', '����������-�跽������'], ['5', '�跽��ĩ���'], ['6', '������ĩ���']]
		});

	var AnalysisTypeField = new Ext.form.ComboBox({
			id : "AnalysisTypeField",
			fieldLabel : '������������',
			labelSeparator:'',
			width : 200,
			store : AnalysisTypeStore,
			displayField : 'keyvalue',
			valueField : 'key',
			value : '1', //��Ĭ��ֵ
			triggerAction : 'all',
			mode : 'local',
			selectOnFocus : true,
			triggerAction : 'all',
			forceSelection : true
		});

	//-------��ѯ����---------//
	var frm = new Ext.form.FormPanel({
            iconCls:'find',
			labelAlign : 'right',
			title : '��ѯ����',
			width : 400,
			heigth : 400,
			frame : true,
			region : 'east',
			labelWidth : 100,
			// buttonAlign: 'center',
			// closable: true, //������ԾͿ��Կ��ƹرո�from
			items : [{
					xtype : 'fieldset',
					style:"padding:5px;",
					//title : '��������',
					items : [SubjCodeNameField1, SubjCodeNameField2, AcctYearMonthField1, AcctYearMonthField2,
						SubjLevelField, AnalysisTypeField]
				}, {
					xtype:'button', 
					style : "marginLeft:40%",
					iconCls:'find',
       				width : 55,
					text: '��ѯ',
					handler : function () {

						FindQuery();
					}
				}
			]

		});

	SchemGrid.on('rowclick', function (grid, rowIndex, e) {

		var object = SchemGrid.getSelectionModel().getSelections();
		var id = object[0].get("rowid");
		if (id==""||id==null||id==undefined){
			SchemGrid.edit=true;
		}else{
			var SchemDesc = object[0].get("desc");
			var arr = SchemDesc.split(";");
			
			SubjCodeNameField1.setValue(arr[0]);
			SubjCodeNameField2.setValue(arr[1]);
			AcctYearMonthField1.setValue(arr[2]);
			AcctYearMonthField2.setValue(arr[3]);
			SubjLevelField.setValue(arr[4]);
			AnalysisTypeField.setValue(arr[5]);
				
		}
		

	});

	//�ܰ�������panel����Ext.panel
	var fullForm = new Ext.Panel({
			//title: '��ѯ��������',
			closable : true,
			border : true,
			layout : 'border',
			items : [SchemGrid, frm]
		});

	var window = new Ext.Window({
			// title : '��ѯ��������',
			layout : 'fit',
			plain : true,
			width : 900,
			height : 450,
			modal : true,
			buttonAlign : 'center',
			items : fullForm,
			buttons : [{
					text : '�ر�',
					iconCls:'cancel',
					handler : function () {
						window.close();
					}
				}
			]

		});
	window.show();

	function FindQuery() {
		var AcctSubjCodeName1 = Ext.getCmp('SubjCodeNameField1').getRawValue();
		var AcctSubjCode1 = AcctSubjCodeName1.split(" ")[0];
		var AcctSubjName1 = Ext.util.Format.trim(Ext.util.Format.substr(AcctSubjCodeName1, AcctSubjCode1.length, 50));
		var AcctSubjCodeName2 = Ext.getCmp('SubjCodeNameField2').getRawValue();
		var AcctSubjCode2 = AcctSubjCodeName2.split(" ")[0];
		var AcctSubjName2 = Ext.util.Format.trim(Ext.util.Format.substr(AcctSubjCodeName2, AcctSubjCode2.length, 50));
		var AcctYearMonth1 = AcctYearMonthField1.getRawValue(); //.format('Y-M');
		var AcctYearMonth2 = AcctYearMonthField2.getRawValue(); //.format('Y-M');
		var SubjLevel = Ext.getCmp('SubjLevelField').getValue();
		var AnalysisType = Ext.getCmp('AnalysisTypeField').getValue();
		var AnalysisTypeDis = AnalysisTypeField.getRawValue();
		window.close();
		var reportFrame = document.getElementById("frameReport");
		var p_URL = "";

		//��ȡ����·��
		p_URL = 'dhccpmrunqianreport.csp?reportName=herp.acct.AcctSubjMomAnalysis.raq&SubjCode1=' + AcctSubjCode1 + '&SubjCode2=' + AcctSubjCode2
			 + '&SubjName1=' + AcctSubjName1 + '&SubjName2=' + AcctSubjName2
			 + '&yearmonth1=' + AcctYearMonth1 + '&yearmonth2=' + AcctYearMonth2 + '&level=' + SubjLevel
			 + '&AnalysisType=' + AnalysisType + '&AnalysisTypeDis=' + AnalysisTypeDis + '&userdr=' + UserID;
		reportFrame.src = p_URL;

	}

}
