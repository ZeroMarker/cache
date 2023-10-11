
var bookID = IsExistAcctBook();

//ȡ���ٷֱȷ��ĳ�ʼֵ
Ext.Ajax.request({
	url: '../csp/herp.acct.acctbaddebtsexe.csp?action=GetParamValue&bookID=' + bookID,
	waitMsg: '������...',
	failure: function (result, request) {
		Ext.Msg.show({
			title: '����',
			msg: '������������!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.ERROR
		});
	},
	success: function (result, request) {
		var str = result.responseText;
		typename.setValue(parseInt(str.split('^')[0]));
		if (parseInt(str.split('^')[0]) == 2) {
			itemGrid.enable();
			Paramproportion.disable();
		} else {
			itemGrid.disable();
			Paramproportion.enable();
		}
		resultstr = Ext.util.Format.trim(str.split('^')[1]); //ȥ��ǰ��Ļ��з����ո�
		var resultfrist = Ext.util.Format.substr(resultstr, 0, 1); //��ȡ��һλ
		// alert(resultstr+"^"+resultfrist);
		if (resultfrist == ".")
			resultstr = "0" + resultstr; //�жϵ�һλ�Ƿ�Ϊ���֣������0
		Paramproportion.setValue(resultstr);

	},
	scope: this
});

var typeStore = new Ext.data.SimpleStore({
		fields: ['rowid', 'mode'],
		data: [['1', '���ٷֱȷ�'], ['2', '���������']]
	})
	var typename = new Ext.form.ComboBox({
		width: 120,
		listWidth: 120,
		// selectOnFocus : true,
		// allowBlank : false,
		store: typeStore,
		displayField: 'mode',
		valueField: 'rowid',
		triggerAction: 'all',
		mode: 'local', // ����ģʽ
		editable: false,
		// minChars : 1,
		selectOnFocus: true,
		disabled: true /* ,
		listeners : { //�����¼�
		select : function () {
		if (typename.getValue() == 2) {
		itemGrid.enable();
		Paramproportion.disable();
		} else {
		itemGrid.disable();
		Paramproportion.enable();
		}

		}
		} */

	});

////////////
var Paramproportion = new Ext.form.NumberField({
		fieldLabel: '���ٷֱȷ���������',
		width: 50,
		decimalPrecision: 2, //С��������2λ
		regex: /^0|(^0\.[0-9]{1,2})$/,
		regexText: '���ɱ�����λС����',
		style: "padding-top:3px;text-align:right;",
		maxValue: 1,
		minValue: 0

	});

//////////���水ť//////////////
var SaveButton = new Ext.Button({
		text: '����',
		tooltip: '����',
		iconCls: 'save',
		width: 55,
		handler: function () {
			save();
		}
	});

var queryPanel = new Ext.FormPanel({
		title: '���˼�������',
		iconCls: 'maintain',
		height: 125,
		region: 'north',
		frame: true,
		defaults: {
			style: "padding:3px;"
		},
		items: [{
				xtype: 'panel',
				layout: 'column',
				// hideLabel : true,
				items: [{
						xtype: 'displayfield',
						value: '���˼��᷽ʽ',
						style: 'padding-top:4px;',
						width: 90
					},
					typename]
			}, {
				xtype: 'panel',
				layout: "column",
				items: [{
						xtype: 'displayfield',
						value: '���ٷֱȷ���������',
						style: 'padding-top:3px;', //line-height: 5px;
						width: 145
					},
					Paramproportion, {
						xtype: 'displayfield',
						value: '(1����)',
						style: 'padding-left:5px;padding-top:3px;',
						width: 100
					}
				]
			}, {
				xtype: 'panel',
				layout: "column",
				items: [
					SaveButton
				]
			}

		]
	});

var itemGrid = new dhc.herp.Grid({
		title: '�����������������',
		iconCls: 'maintain',
		// width: 400,
		//edit:false,                   //�Ƿ�ɱ༭
		readerModel: 'remote',
		region: 'center',
		// url: 'herp.acct.vouchtypeexe.csp',
		url: '../csp/herp.acct.acctbaddebtsexe.csp',
		// tbar:delButton,
		// atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask: true,
		fields: [{
				header: 'ID',
				dataIndex: 'rowid',
				edit: false,
				hidden: true
			}, {
				id: 'code',
				header: '������',
				allowBlank: false,
				align: 'center',
				width: 80,
				editable: false,
				update: true,
				dataIndex: 'code'
			}, {
				id: 'describe',
				header: '��������',
				allowBlank: false,
				editable: false,
				align: 'center',
				width: 300,
				update: true,
				dataIndex: 'describe'

			}, {
				id: 'beginDays',
				header: '��ʼ����',
				editable: false,
				align: 'center',
				allowBlank: false,
				width: 100,
				update: true,
				dataIndex: 'beginDays'
			}, {
				id: 'endDays',
				header: '��ֹ����',
				editable: false,
				//allowBlank: false,
				align: 'center',
				width: 100,
				update: true,
				dataIndex: 'endDays'

			}, {
				id: 'deadScale',
				header: '���������%��',
				allowBlank: false,
				align: 'center',
				width: 120,
				update: true,
				dataIndex: 'deadScale'
			}

		]
	});

itemGrid.load({
	params: {
		start: 0,
		limit: 25,
		bookID: bookID
	}
});

itemGrid.on('afterEdit', function (e) {
	if (e.field == 'deadScale') {
		//alert(isNaN(e.value));
		if(!isNaN(e.value)){
		if (e.value < 0 || e.value > 100) {
			Ext.Msg.show({
				title: '��ʾ',
				msg: '������0-100���ڵ�����!',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.WARNING
			});
			return;
		}
		}else{
			Ext.Msg.show({
				title: '��ʾ',
				msg: '������0-100���ڵ�����!',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.WARNING
			});
			return
		}

	}
}, this);
/* itemGrid.store.on('load',function(){
//���᷽ʽ����Ĭ��ֵ��ͬʱ��һ�ּ��᷽ʽ���ɱ༭
typename.setValue(1);
Paramproportion.disable();
});
 */
itemGrid.btnAddHide(); //�������Ӱ�ť
itemGrid.btnSaveHide(); //���ر��水ť
itemGrid.btnDeleteHide(); //����ɾ����ť
itemGrid.btnResetHide() //�������ð�ť
itemGrid.btnPrintHide() //���ش�ӡ��ť
