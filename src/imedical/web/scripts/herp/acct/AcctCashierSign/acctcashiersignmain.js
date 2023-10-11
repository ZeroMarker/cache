var userdr = session['LOGON.USERID']; //��¼��ID
var acctbookid = GetAcctBookID();
var acctbookid = IsExistAcctBook();

//��õ�ǰϵͳ��¼�û�����Ϣ˵��
var userID = session['LOGON.USERID'];
var userCode = session['LOGON.USERCODE'];
var userName = session['LOGON.USERNAME'];

var projUrl = 'herp.acct.acctcashiersignexe.csp';

//*****************��ѯ������ʼ*********************//

//***���������¿ؼ�***//
var startDate = new Ext.form.DateField({
		id: 'startDate',
		format: 'Y-m',
		width: 200,
		emptyText: '',
		value: new Date(),
		plugins: 'monthPickerPlugin'
	});

//***��ȡƾ֤���***//
var VouchTypeDs = new Ext.data.Store({
		autoLoad: true,
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['rowid', 'name'])
	});
VouchTypeDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=GetVouchTypeName&str' + encodeURIComponent(Ext.getCmp('VouchTypeName').getRawValue()),
			method: 'POST'
		});
});
var VouchTypeName = new Ext.form.ComboBox({
		id: 'VouchTypeName',
		fieldLabel: 'ƾ֤����',
		width: 214,
		listwidth: 220,
		allowBlank: 'false',
		store: VouchTypeDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText: '��ѡ��ƾ֤����',
		name: 'VouchTypeName',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true
	});

//***��ȡǩ��״̬***//
var IsCheckState = new Ext.form.RadioGroup({
		fieldLabel: 'ǩ��״̬',
		width: 220,
		defaults: {
			style: "margin:0;padding:0 0.25em;width:auto;overflow:visible;border:0;background:none;"
		},
		items: [{
				id: 'all',
				boxLabel: 'ȫ��',
				inputValue: '',
				name: 'IsCheck1'
			}, {
				id: 'checked',
				boxLabel: '��ǩ��',
				inputValue: '1',
				name: 'IsCheck1'
			}, {
				id: 'unchecked',
				boxLabel: 'δǩ��',
				inputValue: '0',
				name: 'IsCheck1',
				checked: true
			}
		]/*,
		listeners:{
		beforerender:function(){
		var radioLabel=document.getElementsByClassName('x-form-cb-label');
		//position:absolute;
		// radioLabel.marginLeft=20px;
		radioLabel.style.top=-3px;
		// document.getElementsByClassName('x-form-cb-label').marginLeft=20px;
		}
		}*/
	});

//***ƾ֤����ʼֵ***//
var StartVouchNo = new Ext.form.TextField({
		fieldLabel: 'ƾ֤��',
		allowBlank: true,
		align: 'right',
		width: 100
	});
//***ƾ֤�Ž���ֵ***//
var EndVouchNo = new Ext.form.TextField({
		fieldLabel: '����ƾ֤��',
		allowBlank: true,
		width: 100,
		align: 'right'
		// maxLength:50
	});

//***��ƿ�Ŀ***//
var SubjNameDs = new Ext.data.Store({
		autoLoad: true,
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['rowid', 'code', 'name', 'spell'])
	});
SubjNameDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=GetCashSubjName&str=' + encodeURIComponent(Ext.getCmp('SubjName').getRawValue()) + '&acctbookid=' + acctbookid,
			method: 'POST'
		});
});
var SubjName = new Ext.form.ComboBox({
		id: 'SubjName',
		fieldLabel: '��ƿ�Ŀ',
		width: 200,
		listWidth: 220,
		allowBlank: true,
		store: SubjNameDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText: '��ѡ���ƿ�Ŀ',
		name: 'SubjName',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true
	});

//��ǰ��¼��
/*var CurruserField = new Ext.form.Checkbox({
		id: 'CurruserField',
		fieldLabel: '��ǰ��¼��',
		allowBlank: false,
		style: 'border:0;background:none;margin-top:0px;'
	});*/

//********--��ѯ��������--*********//

//***��ѯ����***//
function dosearch() {
	var SubjID = SubjName.getValue();
	//if(SubjID!=""){
	var startTime = startDate.getValue();
	if (startTime !== "") {
		startTime = startTime.format('Y-m');
	}
	var VouchTypeID = VouchTypeName.getValue();
	var IsSign = IsCheckState.getValue().inputValue;
	var StartNum = StartVouchNo.getValue();
	var EndNum = EndVouchNo.getValue();

	//var Curruser = (CurruserField.getValue() == true) ? '1' : '0';
	//console.log(Ext.getCmp("PageSizePlugin"));
        var limits=Ext.getCmp("PageSizePlugin").getValue();
			 //alert(limits);
	         if(!limits){limits=25};
	itemGrid.load({
		params: {
			sortField: '',
			sortDir: '',
			start: 0,
			limit: limits,
			startDate: startTime, //����ڼ�
			VouchTypeID: VouchTypeID, //ƾ֤����ID
			IsSign: IsSign, //ǩ��״̬
			StartVouchNo: StartNum, //��ʼƾ֤��
			EndVouchNo: EndNum,
			SubjID: SubjID,
			acctbookid: acctbookid, //��ƿ�Ŀ
			//Curruser: Curruser,
			userdr: userdr
		}
	});
	//}else if(SubjID==""){
	//  Ext.Msg.show({title:'��ʾ',msg:'��ƿ�Ŀ��Ϊ�� �������½���ѡ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	//  return;
	//  }
};

//**�����ѯ��ť**//
var QueryButton = new Ext.Toolbar.Button({
		text: '��ѯ	',
		tooltips: '��ѯ����',
		width: 65,
		iconCls: 'find',
		handler: function () {
			dosearch();
		}
	});

//**������������**//
var BatchSign = new Ext.Toolbar.Button({
		text: '����ǩ��',
		tooltip: '����ǩ��',
		width: 80,
		iconCls: 'cashiersign',
		handler: function () {
			batchsign();
			return;
		}
	});

//**��������ȡ��**//
var SignCancel = new Ext.Toolbar.Button({
		text: 'ȡ��ǩ��',
		tooltip: 'ȡ��ǩ��',
		width: 80,
		iconCls: 'cancel_sign',
		handler: function () {
			cancelsign();
			return;
		}
	});

//****��ѯ���--��ѯ����*****//
var queryPanel = new Ext.FormPanel({
		region: 'north',
		height:85,
		frame: true,
		defaults: {
			bodyStyle: 'padding:5px;'
		},
		items: [{
				columnWidth: 1,
				xtype: 'panel',
				layout: 'column',
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '����ڼ�',
						style: 'line-height: 20px;',
						width: 65
					}, startDate, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: 'ƾ֤����',
						style: 'line-height: 20px;',
						width: 65
					}, VouchTypeName, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: 'ǩ��״̬',
						style: 'line-height: 20px;',
						width: 65
					}, IsCheckState]
			}, {
				columnWidth: 1,
				xtype: 'panel',
				layout: 'column',
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '��ƿ�Ŀ',
						style: 'line-height: 20px;',
						width: 65
					}, SubjName, {
						xtype: 'displayfield',
						value: '',
						width: 45
					}, {
						xtype: 'displayfield',
						value: 'ƾ֤��',
						style: 'line-height: 20px;',
						width: 50
					}, StartVouchNo, {
						xtype: 'displayfield',
						value: '',
						width: 1
					}, {
						xtype: 'displayfield',
						value: '--'
						//width: 10
					}, {
						xtype: 'displayfield',
						value: '',
						width: 1
					}, EndVouchNo, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}/*, {
						xtype: 'displayfield',
						value: '��ǰ����ִ��:',
						style: 'margin-bottom:3px;line-height: 20px;',
						width: 90
					}, CurruserField*/, {
						xtype: 'displayfield',
						value: '',
						width: 40
					}, QueryButton
				]
			}
		]
	});

//***itemGrid���***//
var itemGrid = new dhc.herp.Grid({
		width: 400,
		region: 'center',
		url: projUrl,
		//atLoad:true,
		fields: [
			new Ext.grid.CheckboxSelectionModel({
				editable: false
			}), {
				id: 'rowid',
				header: 'ID',
				dataIndex: 'rowid',
				hidden: true
			}, {
				id: 'AcctYear',
				header: '<div style="text-align:center">��</div>',
				width: 50,
				editable: false,
				align: 'center',
				dataIndex: 'AcctYear'
			}, {
				id: 'AcctMonth',
				header: '<div style="text-align:center">��</div>',
				width: 40,
				editable: false,
				align: 'center',
				dataIndex: 'AcctMonth'
			}, {
				id: 'VouchNo',
				header: '<div style="text-align:center">ƾ֤��</div>',
				width: 100,
				editable: false,
				renderer: function (value, cellmeta, records, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>';
				},
				align: 'center',
				dataIndex: 'VouchNo'
			}, {
				id: 'MakeBillDate',
				header: '<div style="text-align:center">�Ƶ�ʱ��</div>',
				width: 100,
				editable: false,
				align: 'center',
				dataIndex: 'MakeBillDate'
			}, {
				id: 'Summary',
				header: '<div style="text-align:center">ժҪ</div>',
				width: 150,
				editable: false,
				align: 'left',
				dataIndex: 'Summary'
			}, {
				id: 'CheqTypeName',
				header: '<div style="text-align:center">Ʊ������</div>',
				width: 80,
				editable: false,
				align: 'center',
				dataIndex: 'CheqTypeName'
			}, {
				id: 'CheqNo',
				header: '<div style="text-align:center">Ʊ�ݺ�</div>',
				width: 150,
				editable: false,
				//align:'left',
				dataIndex: 'CheqNo'
			}, {
				id: 'OccurDate',
				header: '<div style="text-align:center">����ʱ��</div>',
				width: 100,
				editable: false,
				align: 'center',
				dataIndex: 'OccurDate'
			}, {
				id: 'AmtDebit',
				header: '<div style="text-align:center">�跽���</div>',
				width: 150,
				editable: false,
				align: 'right',
				dataIndex: 'AmtDebit'
			}, {
				id: 'AmtCredit',
				header: '<div style="text-align:center">�������</div>',
				width: 150,
				editable: false,
				align: 'right',
				dataIndex: 'AmtCredit'
			}, {
				id: 'IsCheck',
				header: '<div style="text-align:center">����ǩ��״̬</div>',
				width: 110,
				editable: false,
				align: 'center',
				dataIndex: 'IsCheck',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					var sf = record.data['IsCheck']
						// if (sf == "��ǩ��") {return '<span style="cursor:hand">'+value+'</span>';}
						if (sf == "δǩ��") {
							return '<span style="color:blue;">' + value + '</span>';
						} else {
							return value;
						}
				}

			}, {
				id: 'CheckerID',
				header: '<div style="text-align:center">ǩ����id</div>',
				width: 80,
				hidden: true,
				editable: false,
				align: 'center',
				dataIndex: 'CheckerID'
			}, {
				id: 'CheckerName',
				header: '<div style="text-align:center">ǩ����</div>',
				width: 100,
				editable: false,
				align: 'center',
				dataIndex: 'CheckerName'
			}, {
				id: 'CheckDate',
				header: '<div style="text-align:center">ǩ������</div>',
				width: 100,
				editable: false,
				align: 'center',
				dataIndex: 'CheckDate'
			}, {
				id: 'VouchState1',
				header: '<div style="text-align:center">ƾ֤״̬code</div>',
				width: 80,
				editable: false,
				hidden: true,
				align: 'center',
				dataIndex: 'VouchState1'
			}, {
				id: 'VouchState',
				header: '<div style="text-align:center">ƾ֤״̬</div>',
				width: 80,
				editable: false,
				// hidden:true,
				align: 'center',
				dataIndex: 'VouchState'
			}, {
				id: 'VouchProgress',
				header: 'ƾ֤�������',
				width: 100,
				editable: false,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>';
				},
				dataIndex: 'VouchProgress'
			}
		]

	});

itemGrid.btnResetHide(); //�������ð�ť
itemGrid.btnPrintHide(); //���ش�ӡ��ť
itemGrid.btnAddHide(); //���ذ�ť
itemGrid.btnSaveHide(); //���ذ�ť
itemGrid.btnDeleteHide();

itemGrid.addButton(BatchSign);
itemGrid.addButton('-');
itemGrid.addButton(SignCancel);
itemGrid.addButton('-');
itemGrid.addButton('<span style="color:red;cursor:hand">' + "&nbsp;&nbsp;&nbsp;��ʾ:����ϸ�˶�ÿ��ƾ֤�Ķ����¼���ٽ���ǩ�ִ���" + '</span>');
//itemGrid.load({params:{start:0,limit:25,userdr:userdr}});

itemGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {

	if (columnIndex == '5') {
		//p_URL = 'acct.html?acctno=2';
		//document.getElementById("frameReport").src='acct.html';
		var records = itemGrid.getSelectionModel().getSelections();
		var VouchNo = records[0].get("VouchNo");
		var VouchState = records[0].get("VouchState1");
		var searchFlag = 4;
		var myPanel = new Ext.Panel({
				layout: 'fit',
				//scrolling="auto"
				html: '<iframe id="frameReport" style="zoom:100%;margin-top:-3px;" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno=' + VouchNo + '&user=' + userdr + '&acctstate=' + VouchState + '&bookID=' + acctbookid + '&searchFlag=' + searchFlag + '" /></iframe>'
				//frame : true
			});

		var win = new Ext.Window({
				title: 'ƾ֤�鿴',
				width: 1093,
				height: 620,
				resizable: true,
				closable: true,
				draggable: true,
				resizable: false,
				author: '50%',
				layout: 'fit',
				modal: false,
				plain: true, // ��ʾΪ��Ⱦwindow body�ı���Ϊ͸���ı���
				// bodyStyle : 'padding:-500px;',
				items: [myPanel],
				buttonAlign: 'center',
				buttons: [{
						text: '�ر�',
						type: 'button',
						handler: function () {
							win.close();
						}
					}
				]
			});
		win.show();
	} //ƾ֤�����������
	if (columnIndex == '19') {
		var records = itemGrid.getSelectionModel().getSelections();
		var VouchID = records[0].get("rowid");
		VouchProgressFun(VouchID);
	}

})

function GetYearMonth() {
	Ext.Ajax.request({
		url: 'herp.acct.acctbatchauditexe.csp?action=GetYearMonth' + '&bookID=' + acctbookid,
		failure: function (result, request) {
			Ext.Msg.show({
				title: '����',
				msg: '������������!',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.ERROR
			});
		},
		success: function (result, request) {
			var jsonData = Ext.util.JSON
				.decode(result.responseText);
			//alert(jsonData.success );
			if (jsonData.success == 'false') {
				//alert("dddd="+jsonData.info)
				var date = jsonData.info + "-01"
					startDate.setValue(date);
			}
		},
		scope: this
	});
}
GetYearMonth();
