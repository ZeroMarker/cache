/**
 * name:tab of database author:wang ying Date:2011-1-7 ��Ч������ϵͳָ������excel�ļ��ϴ�����
 */
var importExcel = function() {
	var excelUpload = new Ext.form.TextField({
				id : 'excelUpload',
				name : 'Excel',
				anchor : '90%',
				height : 20,
				inputType : 'file',
				fieldLabel : '�ļ�ѡ��'
			});

	// �ļ�ѡ��
	var upLoadFieldSet = new Ext.form.FieldSet({
				title : '�ļ�ѡ��',
				height : 50,
				labelSeparator : '��',
				items : [excelUpload]
			});

	// ���ı���
	var textArea = new Ext.form.TextArea({
				id : 'textArea',
				width : 325,
				fieldLabel : '�Ѻ���ʾ',
				readOnly : true,
				disabled : true,
				emptyText : '����ϸ�˶�Ҫ�������ݵĸ�ʽ�Լ����ݵ���Ч�ԣ�'
			});

	// ����˵�����ı���
	var exampleFieldSet = new Ext.form.FieldSet({
				title : '���ݵ���������ʾ',
				height : 90,
				labelSeparator : '��',
				items : textArea
			});

	var formPanel = new Ext.form.FormPanel({
		labelWidth : 80,
		bodyStyle : 'padding:5 5 5 5',
		height : 360,
		width : 515,
		frame : true,
		fileUpload : true,
		items : [upLoadFieldSet, exampleFieldSet]
		});

	// ���尴ť
	var importB = new Ext.Toolbar.Button({
				text : '���ݵ���'
			});

	// �������ݹ���
	var handler = function(bt) {
		if (bt == "yes") {
			function callback(id) {
				if (id == "yes") {

					var bYear = Ext.getCmp('cycle').getValue();
					var bPeriod = Ext.getCmp('period').getValue();

					// �ж��Ƿ���ѡ�����Ҫ�ϴ���excel�ļ�
					var excelName = Ext.getCmp('excelUpload').getRawValue();// �ϴ��ļ����Ƶ�·��
					if (excelName == "") {
						Ext.Msg.show({
									title : '��ʾ',
									msg : '��ѡ��Excel�ļ�!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFOR
								});
						return;
					} else {
						var array = new Array();
						array = excelName.split("\\");
						var fileName = "";
						var i = 0;
						for (i = 0; i < array.length; i++) {
							if (fileName == "") {
								fileName = array[i];
							} else {
								fileName = fileName + "/" + array[i];
							}
						}

						var uploadUrl ="http://127.0.0.1:8080/dhchxbonus/importRyxx";
						
						formPanel.getForm().submit({
							url : uploadUrl,
							method : 'POST',
							waitMsg : '���ݵ�����, ���Ե�...',
							success : function(form, action, o) {
								Ext.MessageBox.alert("��ʾ��Ϣ", "���ݳɹ�����!");
							},
							failure : function(form, action) {
								Ext.messageBox.alert("��ʾ��Ϣ", action.result.mess);
							}
						});
					}
				} else {
					return;
				}
			}
			//Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ������ļ��е�������?', callback);
			Ext.MessageBox.confirm('xxx', 'dddd', callback);
		}
		//Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫ����excel������?', callback);
		Ext.MessageBox.confirm('xxx', 'dddd', callback);
	}

	// ��Ӱ�ť����Ӧ�¼�
	importB.addListener('click', handler, false);

	// ����رհ�ť
	var cancelButton = new Ext.Toolbar.Button({
				text : '�رյ���'
			});

	// ����رհ�ť��Ӧ����
	cancelHandler = function() {
		window.close();
	}

	// ��ӹرհ�ť�����¼�
	cancelButton.addListener('click', cancelHandler, false);

	var window = new Ext.Window({
				title:'������Ա��Ϣ����',
				width:530,
				height:270,
				minWidth:530,
				minHeight:270,
				layout:'fit',
				plain:true,
				modal:true,
				bodyStyle:'padding:5px;',
				buttonAlign:'center',
				items:formPanel,
				buttons:[importB,cancelButton]
			});
	window.show();
}