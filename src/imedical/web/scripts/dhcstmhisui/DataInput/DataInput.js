// /�쳬  20180920  ��������
// readAsBinaryString function is not defined in IE
// Adding the definition to the function prototype
if (!FileReader.prototype.readAsBinaryString) {
	console.log('readAsBinaryString definition not found');
	FileReader.prototype.readAsBinaryString = function(fileData) {
		var binary = '';
		var pk = this;
		var reader = new FileReader();
		reader.onload = function(e) {
			var bytes = new Uint8Array(reader.result);
			var length = bytes.byteLength;
			for (var i = 0; i < length; i++) {
				var a = bytes[i];
				var b = String.fromCharCode(a);
				binary += b;
			}
			pk.content = binary;
			$(pk).trigger('onload');
		};
		reader.readAsArrayBuffer(fileData);
	};
}
var init = function() {
	var ClearMain = function() {
		$UI.clearBlock('#Conditions');
		$UI.clear(DataGrid);
		$('#File').filebox('clear');
		$('#Msg').panel({ 'content': ' ' });
		ChangeButtonEnable({ '#CheckBT': false, '#ImportBT': false, '#ClearBT': false, '#ReadBT': true });
	};
	$('#File').filebox({
		buttonText: 'ѡ��',
		prompt: '��ѡ��Ҫ�����Excel',
		accept: 'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
		width: 200
	});
	$('#Type').combobox({
		data: [
			{ 'RowId': 'Stk', 'Description': '���(��ⵥ)����' },
			{ 'RowId': 'Bin', 'Description': '��λ�뵼��' },
			{ 'RowId': 'Adj', 'Description': '�������ݵ���' },
			{ 'RowId': 'Reg', 'Description': 'ע��֤��Ϣ����' },
			{ 'RowId': 'Pur', 'Description': '������Ϣ����' }
			// { 'RowId': 'ApcVendor', 'Description': '��Ӧ�̵���' },
			// { 'RowId': 'Manf', 'Description': '�������ҵ���' },
			// { 'RowId': 'Inci', 'Description': '�����ֵ�(����)����' },
			// { 'RowId': 'InciArc', 'Description': '�����ֵ�(ҽ��)����' }
		],
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(rec) {
			ChangeCm(rec.RowId);
		}
	});

	function ChangeCm(CmType) {
		$UI.clear(DataGrid);
		$UI.datagrid('#DataGrid', {
			queryParams: {
				ClassName: '',
				QueryName: ''
			},
			pagination: false,
			remoteSort: false,
			columns: CmObj[CmType]
		});
	}
	var LoadBtn = $('#LoadBT').menubutton({ menu: '#mm-DownLoad' });
	$(LoadBtn.menubutton('options').menu).menu({
		onClick: function(item) {
			var BtnName = item.name;
			if (BtnName == 'LoadMoudle') { // ����������ģ��
				var Type = $HUI.combobox('#Type').getText();
				if (isEmpty(Type)) {
					$UI.msg('alert', '����ѡ����������!');
					return;
				}
				var filename = Type + 'ģ��.xls';
				window.open('../scripts/dhcstmhisui/DataInput/Excelģ��/' + filename, '_blank');
			} else if (BtnName == 'LoadMouDesc') { // ����ģ��˵��
				window.open('../scripts/dhcstmhisui/DataInput/Excelģ��/ģ��˵��.txt', '_blank');
			}
		}
	});
	$UI.linkbutton('#ReadBT', {
		onClick: function() {
			var wb; // wookbook
			var Type = $HUI.combobox('#Type').getValue();
			if (isEmpty(Type)) {
				$UI.msg('alert', '�������Ͳ���Ϊ��!');
				return;
			}
			var filelist = $('#File').filebox('files');
			if (filelist.length == 0) {
				$UI.msg('alert', '��ѡ��Ҫ�����Excel!');
				return;
			}
			showMask();
			var file = filelist[0];
			var reader = new FileReader();
			reader.onload = function(e) {
				if (reader.result) { reader.content = reader.result; }
				// In IE browser event object is null
				var data = e ? e.target.result : reader.content;
				// var baseEncoded = btoa(data);
				// var wb = XLSX.read(baseEncoded, {type: 'base64'});
				wb = XLSX.read(data, {
					type: 'binary'
				});
				var json = to_json(wb);
				$('#DataGrid').datagrid('loadData', json);
				ChangeButtonEnable({ '#CheckBT': true, '#ImportBT': false, '#ClearBT': true, '#ReadBT': true });
				hideMask();
			};
			reader.readAsBinaryString(file);
		}
	});
	function to_json(workbook) {
		// ȡ ��һ��sheet ����
		var jsonData = {};
		var sheet2JSONOpts = {
			defval: ''		// ����Ϊ��ʱ��Ĭ��ֵ
		};
		var result = XLSX.utils.sheet_to_json(workbook.Sheets[workbook.SheetNames[0]], sheet2JSONOpts);
		jsonData.rows = result;
		jsonData.total = result.length;
		return jsonData;	// JSON.stringify(jsonData);
	}

	$UI.linkbutton('#ImportBT', {
		onClick: function() {
			Save();
		}
	});
	var Save = function() {
		var Type = $HUI.combobox('#Type').getValue();
		if (isEmpty(Type)) {
			$UI.msg('alert', '�������Ͳ���Ϊ��!');
			return;
		}
		var Rows = DataGrid.getRowsData();
		if (Rows.length == 0) {
			$UI.msg('alert', 'û����Ҫ�ϴ�������!');
			return;
		}
		Rows = JSON.stringify(Rows);
		var Params = JSON.stringify(sessionObj);
		showMask();
		
		// �Ȱ����ݼ�¼����ʱglobal
		var PidStr = tkMakeServerCall('web.DHCSTMHUI.Tools.DataInput', 'SetGlobal', Rows);
		var Success = PidStr.split('^')[0];
		if (Success < 0) {
			$UI.msg('alert', '�������!');
			return;
		}
		var Pid = PidStr.split('^')[1];
		
		$.cm({
			ClassName: 'web.DHCSTMHUI.Tools.DataInput',
			MethodName: 'DataInput',
			Pid: Pid,
			Type: Type,
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('alert', '�������鿴����ԭ��!');
				$('#Msg').panel({ 'content': jsonData.msg });
				ChangeButtonEnable({ '#CheckBT': false, '#ImportBT': false, '#ClearBT': true, '#ReadBT': true });
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	};
	$UI.linkbutton('#CheckBT', {
		onClick: function() {
			var Type = $HUI.combobox('#Type').getValue();
			if (isEmpty(Type)) {
				$UI.msg('alert', '�������Ͳ���Ϊ��!');
				return;
			}
			showMask();
			if (CheckObj() === false) {
				hideMask();
				$UI.msg('error', '����У�鲻ͨ��!');
				return;
			}
			hideMask();
			$UI.msg('success', '����У��ͨ��!');
			ChangeButtonEnable({ '#CheckBT': true, '#ImportBT': true, '#ClearBT': true, '#ReadBT': true });
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			ClearMain();
		}
	});
	var CheckObj = function() {
		var CheckField = [];
		var opt = DataGrid.options();
		var CheckDateField = [];
		for (var i = 0; i < opt.columns[0].length; i++) {
			if (opt.columns[0][i].checknull === true) {
				CheckField.push(opt.columns[0][i].field);
			}
			if (opt.columns[0][i].CheckDate === true) {
				CheckDateField.push(opt.columns[0][i].field);
			}
		}
		var Rows = DataGrid.getRows();
		var len = Rows.length;
		var CheckFlag = true;
		var RecordArr = [];
		for (var i = 0; i < len; i++) {
			var Msg = '';
			var Record = Rows[i];
			for (var j = 0; j < CheckField.length; j++) {
				var val = Record[CheckField[j]];
				if (isEmpty(val)) {
					Msg = Msg + '��' + (i + 1) + '��' + CheckField[j] + '����Ϊ��!';
					CheckFlag = false;
				}
			}
			for (var k = 0; k < CheckDateField.length; k++) {
				var val = Record[CheckDateField[k]];
				if (!isEmpty(val) && !CheckDateForm(val)) {
					Msg = Msg + '��' + (i + 1) + '��' + CheckDateField[k] + '���ڸ�ʽ����ȷ!';
					CheckFlag = false;
				}
			}
			if (isEmpty(Msg)) {
				Msg = '��';
			} else {
				$('#DataGrid').datagrid('highlightRow', i);
			}
			Record['У����Ϣ'] = Msg;
			RecordArr.push(Record);
		}
		$('#DataGrid').datagrid('loadData', RecordArr);
		return CheckFlag;
	};
	var CmObj = {
		Cm: [[{ title: '', field: '', width: 0 }]],
		Inci: [[
			{
				title: 'ҽԺ',
				field: 'ҽԺ',
				// checknull: true,
				width: 100
			}, {
				title: '����������',
				field: '����������',
				checknull: true,
				width: 100
			}, {
				title: '�����������',
				field: '�����������',
				checknull: true,
				width: 100
			}, {
				title: '���ʴ���',
				field: '���ʴ���',
				width: 100
			}, {
				title: '��������',
				field: '��������',
				checknull: true,
				width: 100
			}, {
				title: '���',
				field: '���',
				width: 100
			}, {
				title: '�ͺ�',
				field: '�ͺ�',
				width: 100
			}, {
				title: 'Ʒ��',
				field: 'Ʒ��',
				width: 100
			}, {
				title: '���',
				field: '���',
				width: 100
			}, {
				title: 'Э����',
				field: 'Э����',
				width: 100
			}, {
				title: '����',
				field: '����',
				width: 100
			}, {
				title: '��С��λ',
				field: '��С��λ',
				checknull: true,
				width: 100
			}, {
				title: '����װ��λ',
				field: '����װ��λ',
				checknull: true,
				width: 100
			}, {
				title: '����ת��ϵ��',
				field: '����ת��ϵ��',
				checknull: true,
				width: 100
			}, {
				title: '�ۼ�',
				field: '�ۼ�',
				width: 100
			}, {
				title: '����',
				field: '����',
				checknull: true,
				width: 100
			}, {
				title: '�Ƿ��շ�',
				field: '�Ƿ��շ�',
				width: 100
			}, {
				title: '�Ƿ��ֵ',
				field: '�Ƿ��ֵ',
				width: 100
			}, {
				title: '����Ҫ��',
				field: '����Ҫ��',
				width: 100
			}, {
				title: 'Ч��Ҫ��',
				field: 'Ч��Ҫ��',
				width: 100
			}, {
				title: '��Ӧ������',
				field: '��Ӧ������',
				width: 100
			}, {
				title: '������������',
				field: '������������',
				width: 100
			}, {
				title: '��еע��֤��',
				field: '��еע��֤��',
				width: 100
			}, {
				title: '��еע��֤Ч��',
				field: '��еע��֤Ч��',
				checkDate: true,
				width: 100
			}, {
				title: '��Ӧ��Ӫҵִ�պ�',
				field: '��Ӧ��Ӫҵִ�պ�',
				width: 100
			}, {
				title: '��Ӧ�̾�Ӫ���֤��',
				field: '��Ӧ�̾�Ӫ���֤��',
				width: 100
			}, {
				title: '��Ӧ�̾�Ӫ���֤Ч��',
				field: '��Ӧ�̾�Ӫ���֤Ч��',
				checkDate: true,
				width: 100
			}, {
				title: '�������֤��',
				field: '�������֤��',
				width: 100
			}, {
				title: '�������֤Ч��',
				field: '�������֤Ч��',
				checkDate: true,
				width: 100
			}, {
				title: '��Ȩ����',
				field: '��Ȩ����',
				checkDate: true,
				width: 100
			}, {
				title: '��Ȩ��ϵ��',
				field: '��Ȩ��ϵ��',
				width: 100
			}, {
				title: '��Ȩ��ϵ�˵绰',
				field: '��Ȩ��ϵ�˵绰',
				width: 100
			}, {
				title: '��ע',
				field: '��ע',
				width: 100
			}, {
				title: '������',
				field: '������',
				width: 100
			}, {
				title: 'У����Ϣ',
				field: 'У����Ϣ',
				sortable: true,
				width: 350
			}
		]],
		InciArc: [[
			{
				title: 'ҽԺ',
				field: 'ҽԺ',
				// checknull: true,
				width: 100
			}, {
				title: '����������',
				field: '����������',
				checknull: true,
				width: 100
			}, {
				title: '�����������',
				field: '�����������',
				checknull: true,
				width: 100
			}, {
				title: '���ʴ���',
				field: '���ʴ���',
				width: 100
			}, {
				title: '��������',
				field: '��������',
				checknull: true,
				width: 100
			}, {
				title: '���',
				field: '���',
				width: 100
			}, {
				title: '�ͺ�',
				field: '�ͺ�',
				width: 100
			}, {
				title: 'Ʒ��',
				field: 'Ʒ��',
				width: 100
			}, {
				title: '���',
				field: '���',
				width: 100
			}, {
				title: 'Э����',
				field: 'Э����',
				width: 100
			}, {
				title: '����',
				field: '����',
				width: 100
			}, {
				title: '��С��λ',
				field: '��С��λ',
				checknull: true,
				width: 100
			}, {
				title: '����װ��λ',
				field: '����װ��λ',
				checknull: true,
				width: 100
			}, {
				title: '����ת��ϵ��',
				field: '����ת��ϵ��',
				checknull: true,
				width: 100
			}, {
				title: '�˵���λ',
				field: '�˵���λ',
				checknull: true,
				width: 100
			}, {
				title: '�ۼ�',
				field: '�ۼ�',
				width: 100
			}, {
				title: '����',
				field: '����',
				checknull: true,
				width: 100
			}, {
				title: 'ҽ������',
				field: 'ҽ������',
				checknull: true,
				width: 100
			}, {
				title: 'ҽ������',
				field: 'ҽ������',
				checknull: true,
				width: 100
			}, {
				title: '�˵�����',
				field: '�˵�����',
				checknull: true,
				width: 100
			}, {
				title: '�˵�����',
				field: '�˵�����',
				checknull: true,
				width: 100
			}, {
				title: '�շѴ���',
				field: '�շѴ���',
				checknull: true,
				width: 100
			}, {
				title: '�շ�����',
				field: '�շ�����',
				checknull: true,
				width: 100
			}, {
				title: 'סԺ����',
				field: 'סԺ����',
				checknull: true,
				width: 100
			}, {
				title: 'סԺ����',
				field: 'סԺ����',
				checknull: true,
				width: 100
			}, {
				title: '�������',
				field: '�������',
				checknull: true,
				width: 100
			}, {
				title: '��������',
				field: '��������',
				checknull: true,
				width: 100
			}, {
				title: '�������',
				field: '�������',
				checknull: true,
				width: 100
			}, {
				title: '��������',
				field: '��������',
				checknull: true,
				width: 100
			}, {
				title: '��ƴ���',
				field: '��ƴ���',
				checknull: true,
				width: 100
			}, {
				title: '�������',
				field: '�������',
				checknull: true,
				width: 100
			}, {
				title: '��������',
				field: '��������',
				checknull: true,
				width: 100
			}, {
				title: '��������',
				field: '��������',
				checknull: true,
				width: 100
			}, {
				title: '�²�����ҳ����',
				field: '�²�����ҳ����',
				checknull: true,
				width: 100
			}, {
				title: 'ҽ������',
				field: 'ҽ������',
				width: 100
			}, {
				title: 'ҽ������',
				field: 'ҽ������',
				width: 100
			}, {
				title: 'ҽ�����ȼ�',
				field: 'ҽ�����ȼ�',
				width: 100
			}, {
				title: '����ҽ��',
				field: '����ҽ��',
				checknull: true,
				width: 100
			}, {
				title: '�޿��ҽ��',
				field: '�޿��ҽ��',
				checknull: true,
				width: 100
			}, {
				title: '�Ƿ��շ�',
				field: '�Ƿ��շ�',
				width: 100
			}, {
				title: '�Ƿ��ֵ',
				field: '�Ƿ��ֵ',
				width: 100
			}, {
				title: '����Ҫ��',
				field: '����Ҫ��',
				width: 100
			}, {
				title: 'Ч��Ҫ��',
				field: 'Ч��Ҫ��',
				width: 100
			}, {
				title: '��ܼ���',
				field: '��ܼ���',
				width: 100
			}, {
				title: '����',
				field: '����',
				width: 100
			}, {
				title: '�б����',
				field: '�б����',
				width: 100
			}, {
				title: '��Ӧ������',
				field: '��Ӧ������',
				width: 100
			}, {
				title: '������������',
				field: '������������',
				width: 100
			}, {
				title: '�б�����������',
				field: '�б�����������',
				width: 100
			}, {
				title: '��еע��֤��',
				field: '��еע��֤��',
				width: 100
			}, {
				title: '��еע��֤Ч��',
				field: '��еע��֤Ч��',
				width: 100
			}, {
				title: '�������֤��',
				field: '�������֤��',
				width: 100
			}, {
				title: '�������֤Ч��',
				field: '�������֤Ч��',
				width: 100
			}, {
				title: '��Ӧ��Ӫҵִ�պ�',
				field: '��Ӧ��Ӫҵִ�պ�',
				width: 100
			}, {
				title: '��Ӧ��Ӫҵִ����Ч��',
				field: '��Ӧ��Ӫҵִ����Ч��',
				checkDate: true,
				width: 100
			}, {
				title: '��Ӧ��˰��Ǽ�֤��',
				field: '��Ӧ��˰��Ǽ�֤��',
				width: 350
			}, {
				title: '��Ӧ����֯��������',
				field: '��Ӧ����֯��������',
				width: 100
			}, {
				title: '��Ӧ����֯����������Ч��',
				field: '��Ӧ����֯����������Ч��',
				checkDate: true,
				width: 100
			}, {
				title: '��Ӧ�̾�Ӫ���֤��',
				field: '��Ӧ�̾�Ӫ���֤��',
				width: 100
			}, {
				title: '��Ӧ�̾�Ӫ���֤Ч��',
				field: '��Ӧ�̾�Ӫ���֤Ч��',
				checkDate: true,
				width: 100
			}, {
				title: '��Ȩ����',
				field: '��Ȩ����',
				width: 100
			}, {
				title: '��Ȩ��ϵ��',
				field: '��Ȩ��ϵ��',
				width: 100
			}, {
				title: '��Ȩ��ϵ�˵绰',
				field: '��Ȩ��ϵ�˵绰',
				width: 100
			}, {
				title: '��ע',
				field: '��ע',
				width: 100
			}, {
				title: '������',
				field: '������',
				width: 100
			}, {
				title: 'У����Ϣ',
				field: 'У����Ϣ',
				sortable: true,
				width: 350
			}
		]],
		ApcVendor: [[
			{
				title: 'ҽԺ',
				field: 'ҽԺ',
				width: 100
			}, {
				title: '����',
				field: '����',
				width: 100
			}, {
				title: '����',
				field: '����',
				checknull: true,
				width: 100
			}, {
				title: '�绰',
				field: '�绰',
				width: 100
			}, {
				title: '��������',
				field: '��������',
				width: 100
			}, {
				title: '�����˺�',
				field: '�����˺�',
				width: 100
			}, {
				title: '�ɹ��޶�',
				field: '�ɹ��޶�',
				width: 100
			}, {
				title: '��Ӧ�̷���',
				field: '��Ӧ�̷���',
				width: 100
			}, {
				title: '��ͬ��ֹ����',
				field: '��ͬ��ֹ����',
				checkDate: true,
				width: 100
			}, {
				title: '����',
				field: '����',
				width: 100
			}, {
				title: '���˴���',
				field: '���˴���',
				width: 100
			}, {
				title: '��ַ',
				field: '��ַ',
				width: 100
			}, {
				title: '����ִ��',
				field: '����ִ��',
				width: 100
			}, {
				title: '����ִ��Ч��',
				field: '����ִ��Ч��',
				checkDate: true,
				width: 100
			}, {
				title: '˰��Ǽ�',
				field: '˰��Ǽ�',
				width: 100
			}, {
				title: '˰��Ǽ�Ч��',
				field: '˰��Ǽ�Ч��',
				checkDate: true,
				width: 100
			}, {
				title: 'ҽ����е��Ӫ���֤',
				field: 'ҽ����е��Ӫ���֤',
				width: 100
			}, {
				title: 'ҽ����е��Ӫ���֤Ч��',
				field: 'ҽ����е��Ӫ���֤Ч��',
				checkDate: true,
				width: 100
			}, {
				title: 'ҽ����еע��֤',
				field: 'ҽ����еע��֤',
				width: 100
			}, {
				title: 'ҽ����еע��֤Ч��',
				field: 'ҽ����еע��֤Ч��',
				checkDate: true,
				width: 100
			}, {
				title: '�������֤',
				field: '�������֤',
				width: 100
			}, {
				title: '�������֤Ч��',
				field: '�������֤Ч��',
				checkDate: true,
			
				width: 100
			}, {
				title: '��֯��������',
				field: '��֯��������',
				width: 100
			}, {
				title: '��֯��������Ч��',
				field: '��֯��������Ч��',
				checkDate: true,
				width: 100
			}, {
				title: 'Gsp',
				field: 'Gsp',
				width: 100
			}, {
				title: 'GspЧ��',
				field: 'GspЧ��',
				width: 100
			}, {
				title: '��е�������֤',
				field: '��е�������֤',
				width: 100
			}, {
				title: '��е�������֤Ч��',
				field: '��е�������֤Ч��',
				checkDate: true,
				width: 100
			}, {
				title: '���������Ͽɱ�',
				field: '���������Ͽɱ�',
				width: 100
			}, {
				title: '���������Ͽɱ�Ч��',
				field: '���������Ͽɱ�Ч��',
				checkDate: true,
				width: 100
			}, {
				title: '����ҽ����еע��֤',
				field: '����ҽ����еע��֤',
				width: 100
			}, {
				title: '����ע��ǼǱ�',
				field: '����ע��ǼǱ�',
				width: 100
			}, {
				title: '����ע��ǼǱ�Ч��',
				field: '����ע��ǼǱ�Ч��',
				checkDate: true,
				width: 100
			}, {
				title: '����������Ȩ��',
				field: '����������Ȩ��',
				width: 100
			}, {
				title: '����������Ȩ��Ч��',
				field: '����������Ȩ��Ч��',
				checkDate: true,
				width: 100
			}, {
				title: '�ۺ�����ŵ��',
				field: '�ۺ�����ŵ��',
				width: 100
			}, {
				title: '����ί����',
				field: '����ί����',
				width: 100
			}, {
				title: '������ŵ��',
				field: '������ŵ��',
				width: 100
			}, {
				title: '������ŵ��Ч��',
				field: '������ŵ��Ч��',
				checkDate: true,
				width: 100
			}, {
				title: 'ҵ��Ա����',
				field: 'ҵ��Ա����',
				width: 100
			}, {
				title: 'ҵ��Ա��Ȩ��Ч��',
				field: 'ҵ��Ա��Ȩ��Ч��',
				checkDate: true,
				width: 100
			}, {
				title: 'ҵ��Ա�绰',
				field: 'ҵ��Ա�绰',
				width: 100
			}, {
				title: 'У����Ϣ',
				field: 'У����Ϣ',
				sortable: true,
				width: 350
			}
		]],
		Manf: [[
			{
				title: 'ҽԺ',
				field: 'ҽԺ',
				width: 100
			}, {
				title: '����',
				field: '����',
				checknull: true,
				width: 100
			}, {
				title: '����',
				field: '����',
				checknull: true,
				width: 100
			}, {
				title: '��ַ',
				field: '��ַ',
				width: 100
			}, {
				title: '�绰',
				field: '�绰',
				width: 100
			}, {
				title: '�ϼ���������',
				field: '�ϼ���������',
				width: 100
			}, {
				title: '�����������֤',
				field: '�����������֤',
				width: 100
			}, {
				title: '�����������֤Ч��',
				field: '�����������֤Ч��',
				checkDate: true,
				width: 100
			}, {
				title: '����ִ�����',
				field: '����ִ�����',
				width: 100
			}, {
				title: '����ִ�����Ч��',
				field: '����ִ�����Ч��',
				checkDate: true,
				width: 100
			}, {
				title: '����ע���',
				field: '����ע���',
				width: 100
			}, {
				title: '����ע���Ч��',
				field: '����ע���Ч��',
				checkDate: true,
				width: 100
			}, {
				title: '��֯��������',
				field: '��֯��������',
				width: 100
			}, {
				title: '��֯��������Ч��',
				field: '��֯��������Ч��',
				checkDate: true,
				width: 100
			}, {
				title: '˰��ǼǺ�',
				field: '˰��ǼǺ�',
				width: 100
			}, {
				title: '��е��Ӫ���֤',
				field: '��е��Ӫ���֤',
				width: 100
			}, {
				title: '��е��Ӫ���֤Ч��',
				field: '��е��Ӫ���֤Ч��',
				checkDate: true,
				width: 100
			}, {
				title: 'У����Ϣ',
				field: 'У����Ϣ',
				sortable: true,
				width: 350
			}
		]],
		Bin: [[
			{
				title: '��������',
				field: '��������',
				checknull: true,
				width: 150
			}, {
				title: '��λ����',
				field: '��λ����',
				checknull: true,
				width: 150
			}, {
				title: 'У����Ϣ',
				field: 'У����Ϣ',
				sortable: true,
				width: 350
			}
		]],
		Adj: [[
			{
				title: '��������',
				field: '��������',
				checknull: true,
				width: 100
			}, {
				title: '���ʴ���',
				field: '���ʴ���',
				checknull: true,
				width: 100
			}, {
				title: '��������',
				field: '��������',
				checknull: true,
				width: 100
			}, {
				title: '���۵�λ',
				field: '���۵�λ',
				checknull: true,
				width: 100
			}, {
				title: '�������',
				field: '�������',
				checknull: true,
				width: 100
			}, {
				title: '�����ۼ�',
				field: '�����ۼ�',
				checknull: true,
				width: 100
			}, {
				title: '�ƻ���Ч����',
				field: '�ƻ���Ч����',
				checknull: true,
				CheckDate: true,
				width: 100
			}, {
				title: '����ļ���',
				field: '����ļ���',
				width: 100
			}, {
				title: '����ļ�����',
				field: '����ļ�����',
				checkDate: true,
				width: 100
			}, {
				title: 'У����Ϣ',
				field: 'У����Ϣ',
				sortable: true,
				width: 350
			}
		]],
		Stk: [[
			{
				title: '��������',
				field: '��������',
				checknull: true,
				saveCol: true,
				width: 100
			}, {
				title: '��Ӧ��',
				field: '��Ӧ��',
				checknull: true,
				saveCol: true,
				width: 120
			}, {
				title: '���ʴ���',
				field: '���ʴ���',
				checknull: true,
				saveCol: true,
				width: 100
			}, {
				title: '��������',
				field: '��������',
				checknull: true,
				width: 120
			}, {
				title: '����',
				field: '����',
				checknull: true,
				saveCol: true,
				align: 'right',
				width: 60
			}, {
				title: '��ⵥλ',
				field: '��ⵥλ',
				checknull: true,
				saveCol: true,
				width: 60
			}, {
				title: '����',
				field: '����',
				checknull: true,
				saveCol: true,
				align: 'right',
				width: 100
			}, {
				title: '����',
				field: '����',
				saveCol: true,
				width: 100
			}, {
				title: 'Ч��',
				field: 'Ч��',
				checkDate: true,
				saveCol: true,
				width: 100
			}, {
				title: '������',
				field: '������',
				saveCol: true,
				width: 100
			}, /* {
			title: '��������',
			field: '��������',
			width: 100
		},*/ {
				title: '��ֵ����',
				field: '��ֵ����',
				saveCol: true,
				width: 100
			}, {
				title: '�Դ�����',
				field: '�Դ�����',
				saveCol: true,
				width: 100
			}, {
				title: '���տ�������',
				field: '���տ�������',
				saveCol: true,
				width: 100
			}, {
				title: 'У����Ϣ',
				field: 'У����Ϣ',
				sortable: true,
				width: 350
			}
		]],
		Reg: [[
			{
				title: 'ҽԺ',
				field: 'ҽԺ',
				checknull: true,
				width: 100
			}, {
				title: '���ʴ���',
				field: '���ʴ���',
				checknull: true,
				width: 100
			}, {
				title: '��������',
				field: '��������',
				checknull: true,
				width: 100
			}, {
				title: '��������',
				field: '��������',
				checknull: true,
				width: 100
			}, {
				title: 'ע��֤��',
				field: 'ע��֤��',
				checknull: true,
				width: 100
			}, {
				title: 'ע��֤Ч��',
				field: 'ע��֤Ч��',
				checknull: true,
				checkDate: true,
				width: 100
			}, {
				title: 'ע��֤����',
				field: 'ע��֤����',
				checknull: true,
				width: 100
			}, {
				title: 'ע��֤��֤����',
				field: 'ע��֤��֤����',
				checkDate: true,
				width: 100
			}, {
				title: 'ע��֤�ӳ�Ч�ڱ�־',
				field: 'ע��֤�ӳ�Ч�ڱ�־',
				width: 100
			}, {
				title: 'У����Ϣ',
				field: 'У����Ϣ',
				sortable: true,
				width: 350
			}
		]],
		Pur: [[
			{
				title: '���ʴ���',
				field: '���ʴ���',
				saveCol: true,
				width: 100
			}, {
				title: '��������',
				field: '��������',
				saveCol: true,
				width: 120
			}, {
				title: '�������',
				field: '�������',
				checknull: true,
				saveCol: true,
				width: 80
			}, {
				title: '��������',
				field: '��������',
				checknull: true,
				saveCol: true,
				width: 120
			}, {
				title: '��������',
				field: '��������',
				checknull: true,
				saveCol: true,
				width: 80
			}, {
				title: '��ʼ����',
				field: '��ʼ����',
				saveCol: true,
				checkDate: true,
				width: 100
			}, {
				title: '��������',
				field: '��������',
				saveCol: true,
				checkDate: true,
				width: 100
			}, {
				title: '������',
				field: '������',
				saveCol: true,
				width: 60
			}, {
				title: 'У����Ϣ',
				field: 'У����Ϣ',
				sortable: true,
				width: 350
			}
		]]
	};
	var DataGrid = $UI.datagrid('#DataGrid', {
		queryParams: {
			ClassName: '',
			QueryName: ''
		},
		remoteSort: false,
		pagination: false,
		columns: CmObj.Cm,
		singleSelect: true,
		rowStyler: function(index, row) {
			var Msg = row.У����Ϣ;
			if (!isEmpty(Msg) && Msg != '��') {
				return 'background-color:yellow;color:black;font-weight:bold;';
			}
		}
	});
	ClearMain();
};
$(init);