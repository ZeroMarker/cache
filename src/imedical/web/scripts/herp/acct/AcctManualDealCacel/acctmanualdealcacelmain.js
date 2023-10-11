var bookID = IsExistAcctBook();
var userdr = session['LOGON.USERID']; //��¼��ID
var DebitGrid = new dhc.herp.Grid({
		iconCls: 'list',
		title: '�跽',
		region: 'center',
		url: 'herp.acct.acctmanualdealcacelexe.csp',
		atLoad: true, // �Ƿ��Զ�ˢ��
		//split : true,
		//viewConfig : {forceFit : true},
		fields: [new Ext.grid.CheckboxSelectionModel({
				editable: false
			}),
			//  s jsonTitle="rowid^AmtDebit^AcctYear^AcctMonth^Summary^OrderID^VouchDate^VouchNo^CheckFund^CheckerName^CheckDate"
			{
				id: 'rowid',
				header: 'ID',
				allowBlank: false,
				width: 100,
				editable: false,
				hidden: true,
				dataIndex: 'rowid'
			}, {
				id: 'AmtDebit',
				header: '<div style="text-align:center">�跽���</div>',
				allowBlank: false,
				align: 'right',
				editable: false,
				width: 150,
				update: true,
				type: 'numberField',
				dataIndex: 'AmtDebit'
			}, {
				id: 'AcctYear',
				header: '<div style="text-align:center">������</div>',
				align: 'center',
				//hidden:false,
				width: 80,
				editable: false,
				dataIndex: 'AcctYear'

			}, {
				id: 'AcctMonth',
				header: '<div style="text-align:center">����·�</div>',
				align: 'center',
				editable: false,
				width: 80,
				hidden: false,
				dataIndex: 'AcctMonth'
			}, {
				id: 'Summary',
				header: '<div style="text-align:center">ժҪ</div>',
				align: 'left',
				editable: false,
				width: 200,
				hidden: false,
				dataIndex: 'Summary'
			}, {
				id: 'OrderID',
				header: '<div style="text-align:center">Ʊ�ݺ�</div>',
				editable: false,
				width: 120,
				editable: false,
				dataIndex: 'OrderID'
			}, {
				id: 'VouchDate',
				header: 'ƾ֤����',
				align: 'center',
				editable: false,
				width: 100,
				hidden: false,
				dataIndex: 'VouchDate'

			}, {
				id: 'VouchNo',
				header: 'ƾ֤��',
				align: 'center',
				editable: false,
				width: 100,
				hidden: false,
				dataIndex: 'VouchNo',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;Text-Decoration:underline">' + value + '</span>';
				}

			}, {
				id: 'VouchState',
				header: 'ƾ֤״̬',
				align: 'center',
				editable: false,
				width: 80,
				hidden: true,
				dataIndex: 'VouchState'
			}, {
				id: 'CheckFund',
				header: '���˷�ʽ',
				editable: false,
				align: 'center',
				width: 80,
				dataIndex: 'CheckFund'
			}, {
				id: 'CheckerName',
				header: '������',
				editable: false,
				align: 'center',
				width: 100,
				dataIndex: 'CheckerName'
			}, {
				id: 'CheckDate',
				header: '��������',
				align: 'center',
				editable: false,
				width: 100,
				dataIndex: 'CheckDate'
			}
		]
	});

DebitGrid.btnAddHide(); //�������Ӱ�ť
DebitGrid.btnSaveHide(); //���ر��水ť
DebitGrid.btnDeleteHide(); //����ɾ����ť
DebitGrid.btnResetHide(); //�������ð�ť
DebitGrid.btnPrintHide(); //���ش�ӡ��ť

//DebitGrid.getColumnModel().setHidden(4,true);  //��̬������
// DebitGrid.getColumnModel().setColumnHeader(3,"��Ӧ�̸�������"); //��̬��ʾ��������

//getElementsByClassName��IE����ģʽ������
function ifClassName(){
	document.getElementsByClassName = function (classname) {
		var children = document.getElementsByTagName('div');
		var elements = new Array();
		for (var i = 0; i < children.length; i++) {
			var child = children[i];
			var classNames = child.className.split(' ');
			for (var j = 0; j < classNames.length; j++) {
				if (classNames[j].indexOf(classname) > -1) {
					elements.push(child);
					// break;
				}
			}
		}
		return elements;
	};
}


DebitGrid.store.on('load', function () {
	// console.log(document.getElementsByClassName('x-grid3-hd-inner x-grid3-hd-checker'))
	/* if (!document.getElementsByClassName) {
		var node = ifClassName('x-grid3-hd-inner x-grid3-hd-checker');
		console.log(node)
		node[0].className="x-grid3-hd-inner x-grid3-hd-checker";
		return;
	} */ 
	document.getElementsByClassName('x-grid3-hd-inner x-grid3-hd-checker')[0].className = "x-grid3-hd-inner x-grid3-hd-checker"; //.checked=false;

});

//ƾ֤����
DebitGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {

	if (columnIndex == '9') {
		//p_URL = 'acct.html?acctno=2';
		//document.getElementById("frameReport").src='acct.html';
		var records = DebitGrid.getSelectionModel().getSelections();
		var VouchNo = records[0].get("VouchNo");
		var VouchState = records[0].get("VouchState");
		var myPanel = new Ext.Panel({
				layout: 'fit',
				//scrolling="auto"
				html: '<iframe id="frameReport" style="margin-top:-3px" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno=' + VouchNo + '&user=' + userdr + '&acctstate=' + VouchState + '&bookID=' + bookID + '&SearchFlag=' + '1' + '" /></iframe>'
				// frame : true
			});

		var win = new Ext.Window({
				title: 'ƾ֤�鿴',
				width: 1093,
				height: 620,
				resizable: false,
				closable: true,
				draggable: true,
				resizable: false,
				layout: 'fit',
				modal: false,
				plain: true, // ��ʾΪ��Ⱦwindow body�ı���Ϊ͸���ı���
				//bodyStyle : 'padding:5px;',
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
	}
});

var CreditGrid = new dhc.herp.GridMain({
		title: '����', //�Ƿ�ɱ༭
		iconCls: 'list',
		readerModel: 'remote',
		// url: 'herp.acct.vouchtypeexe.csp',
		url: 'herp.acct.acctmanualdealcacelcreditexe.csp',
		atLoad: true, // �Ƿ��Զ�ˢ��
		loadmask: true,
		region: 'south',
		split: true,
		height: 250,

		//viewConfig : {forceFit : true},
		fields: [new Ext.grid.CheckboxSelectionModel({
				editable: false
			}), {
				id: 'rowid',
				header: 'ID',
				allowBlank: false,
				width: 100,
				editable: false,
				hidden: true,
				dataIndex: 'rowid'
			}, {
				id: 'AmtCredit',
				header: '<div style="text-align:center">�������</div>',
				allowBlank: false,
				align: 'right',
				editable: false,
				width: 150,
				update: true,
				type: 'numberField',
				dataIndex: 'AmtCredit'
			}, {
				id: 'AcctYear',
				header: '<div style="text-align:center">������</div>',
				align: 'center',
				editable: false,
				//hidden:false,
				width: 80,
				editable: false,
				dataIndex: 'AcctYear'

			}, {
				id: 'AcctMonth',
				header: '<div style="text-align:center">����·�</div>',
				align: 'center',
				editable: false,
				width: 80,
				hidden: false,
				dataIndex: 'AcctMonth'
			}, {
				id: 'Summary',
				header: '<div style="text-align:center">ժҪ</div>',
				align: 'left',
				editable: false,
				width: 200,
				hidden: false,
				dataIndex: 'Summary'
			}, {
				id: 'OrderID',
				header: '<div style="text-align:center">Ʊ�ݺ�</div>',
				align: 'center',
				width: 120,
				editable: false,
				dataIndex: 'OrderID'
			}, {
				id: 'VouchDate',
				header: 'ƾ֤����',
				align: 'center',
				editable: false,
				width: 100,
				hidden: false,
				dataIndex: 'VouchDate'

			}, {
				id: 'VouchNo',
				header: 'ƾ֤��',
				align: 'center',
				editable: false,
				width: 100,
				hidden: false,
				dataIndex: 'VouchNo',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;Text-Decoration:underline">' + value + '</span>';
				}
			}, {
				id: 'VouchState',
				header: 'ƾ֤״̬',
				editable: false,
				align: 'center',
				width: 80,
				hidden: true,
				dataIndex: 'VouchState'
			}, {
				id: 'CheckFund',
				editable: false,
				header: '���˷�ʽ',
				align: 'center',
				width: 80,
				dataIndex: 'CheckFund'
			}, {
				id: 'CheckerName',
				header: '������',
				editable: false,
				align: 'center',
				width: 100,
				dataIndex: 'CheckerName'
			}, {
				id: 'CheckDate',
				header: '��������',
				editable: false,
				align: 'center',
				width: 100,
				dataIndex: 'CheckDate'
			}
		]
	});
/*
CreditGrid.hiddenButton(1); 	//�������Ӱ�ť
CreditGrid.hiddenButton(2); 	//���ر��水ť
CreditGrid.hiddenButton(3); //����ɾ����ť
CreditGrid.hiddenButton(4) 	//�������ð�ť
CreditGrid.hiddenButton(5) 	//���ش�ӡ��ť */

CreditGrid.store.on('load', function () {
	/* if (!document.getElementsByClassName) {
		var node = ifClassName('x-grid3-hd-inner x-grid3-hd-checker');
		node[1].className = "x-grid3-hd-inner x-grid3-hd-checker";
		return;
	} */
	document.getElementsByClassName('x-grid3-hd-inner x-grid3-hd-checker')[1].className = "x-grid3-hd-inner x-grid3-hd-checker";
});

//ƾ֤����
CreditGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {

	if (columnIndex == '9') {
		//p_URL = 'acct.html?acctno=2';
		//document.getElementById("frameReport").src='acct.html';
		var records = CreditGrid.getSelectionModel().getSelections();
		var VouchNo = records[0].get("VouchNo");
		var VouchState = records[0].get("VouchState");
		var myPanel = new Ext.Panel({
				layout: 'fit',
				//scrolling="auto"
				html: '<iframe id="frameReport" style="margin-top:-3px" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno=' + VouchNo + '&user=' + userdr + '&acctstate=' + VouchState + '&bookID=' + bookID + '&SearchFlag=' + '1' + '" /></iframe>'
				// frame : true
			});

		var win = new Ext.Window({
				title: 'ƾ֤�鿴',
				width: 1093,
				height: 620,
				resizable: false,
				closable: true,
				draggable: true,
				resizable: false,
				layout: 'fit',
				modal: false,
				plain: true, // ��ʾΪ��Ⱦwindow body�ı���Ϊ͸���ı���
				//bodyStyle : 'padding:5px;',
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
	}
});
