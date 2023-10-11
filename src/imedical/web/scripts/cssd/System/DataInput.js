var init = function() {
	// 兼容IE11对象不支持“readAsBinaryString”属性或方法
	if (!FileReader.prototype.readAsBinaryString) {
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
	
	var HospId = gHospId;
	function InitHosp(TableName) {
		var hospComp = InitHospCombo(TableName, gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
			};
		}
	}
	
	var ClearMain = function() {
		$UI.clearBlock('#Conditions');
		$UI.clear(DataGrid);
		$('#File').filebox('clear');
		$('#Msg').panel({ 'content': ' ' });
		ChangeButtonEnable({ '#CheckBT': false, '#ImportBT': false, '#ClearBT': true, '#ReadBT': true });
	};
	$('#File').filebox({
		buttonText: '选择',
		prompt: '请选择要导入的Excel',
		accept: 'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
		width: 180
	});
	
	$('#Type').combobox({
		data: [
			{ 'RowId': 'CSSD_PackageClass', 'Description': '1-消毒包分类导入' },
			{ 'RowId': 'CSSD_Package', 'Description': '2-消毒包数据导入' },
			{ 'RowId': 'CSSD_Item', 'Description': '3-消毒包明细导入' },
			{ 'RowId': 'CSSD_CodeDict', 'Description': '4-消毒包标牌导入' },
			{ 'RowId': 'CSSD_PackagePack', 'Description': '5-非循环包标签导入' }
		],
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			ChangeCm(record.RowId);
			var TableName = record.RowId;
			if (record.RowId === 'CSSD_PackagePack') {
				TableName = 'CSSD_Package';
			}
			InitHosp(TableName);
		}
	});
	
	function ChangeCm(CmType) {
		$UI.clear(DataGrid);
		$('#File').filebox('clear');
		$UI.datagrid('#DataGrid', {
			queryParams: {
				ClassName: '',
				QueryName: ''
			},
			pagination: false,
			toolbar: '#operatorBar',
			remoteSort: false,
			columns: CmObj[CmType]
		});
	}
	$UI.linkbutton('#LoadBT', { 						// 下载模板
		onClick: function() {
			var Type = $HUI.combobox('#Type').getText();
			if (isEmpty(Type)) {
				$UI.msg('alert', '请先选择数据类型!');
				return;
			}
			var filename = Type + '模板.xlsx';
			window.open('../scripts/cssd/System/Excel模板/' + filename, '_blank');
		}
	});
	
	$UI.linkbutton('#ReadBT', { 						// 读取数据
		onClick: function() {
			var Type = $HUI.combobox('#Type').getValue();
			if (isEmpty(Type)) {
				$UI.msg('alert', '数据类型不能为空!');
				return;
			}
			var Filelist = $('#File').filebox('files');
			if (Filelist.length == 0) {
				$UI.msg('alert', '请选择要导入的Excel!');
				return;
			}
			showMask();
			var File = Filelist[0];
			var reader = new FileReader();
			reader.onload = function(e) {
				if (reader.result) { reader.content = reader.result; }
				var data = e ? e.target.result : reader.content;
				var Data = XLSX.read(data, { type: 'binary' });
				var json = ToJson(Data);
				$('#DataGrid').datagrid('loadData', json);
				ChangeButtonEnable({ '#CheckBT': true, '#ImportBT': false, '#ClearBT': true, '#ReadBT': true });
				hideMask();
			};
			reader.readAsBinaryString(File);
		}
	});
	function ToJson(workbook) {
		// 取第一个sheet 数据
		var result = XLSX.utils.sheet_to_json(workbook.Sheets[workbook.SheetNames[0]], { defval: null });
		var jsonData = {};
		jsonData.rows = result;
		jsonData.total = result.length;
		return jsonData;
	}
	$UI.linkbutton('#ImportBT', {
		onClick: function() {
			Save();
		}
	});
	var Save = function() {
		var Type = $HUI.combobox('#Type').getValue();
		var Rows = DataGrid.getRowsData();
		var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		if (isEmpty(Type)) {
			$UI.msg('alert', '数据类型不能为空!');
			return;
		}
		if (Rows.length === 0) {
			$UI.msg('alert', '没有需要导入的数据!');
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.System.DataInput',
			MethodName: 'DataInput',
			Rows: JSON.stringify(Rows),
			Type: Type,
			Params: Params
		}, function(jsonData) {
			hideMask();
			var contenthtml = "<span style='padding:5px;'>" + jsonData.msg + '</span>';
			$('#Msg').panel({ 'content': contenthtml });
		});
	};
	// 数据校验
	$UI.linkbutton('#CheckBT', {
		onClick: function() {
			var Type = $HUI.combobox('#Type').getValue();
			if (isEmpty(Type)) {
				$UI.msg('alert', '数据类型不能为空!');
				return;
			}
			showMask();
			if (CheckObj() === false) {
				hideMask();
				$UI.msg('error', '数据校验不通过!');
				return;
			}
			hideMask();
			$UI.msg('success', '数据校验通过!');
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
		var DataOptions = DataGrid.options();
		for (var i = 0; i < DataOptions.columns[0].length; i++) {
			if (DataOptions.columns[0][i].checknull === true) {
				CheckField.push(DataOptions.columns[0][i].field);
			}
		}
		var Rows = DataGrid.getRows();
		var Len = Rows.length;
		var CheckFlag = true;
		var RecordArr = [];
		for (i = 0; i < Len; i++) {
			var Msg = '';
			var Record = Rows[i];
			for (var j = 0; j < CheckField.length; j++) {
				var val = Record[CheckField[j]];
				if (isEmpty(val)) {
					Msg = Msg + '第' + (i + 1) + '行' + CheckField[j] + '不能为空!';
					CheckFlag = false;
				}
			}
			if (isEmpty(Msg)) {
				Msg = '√';
			} else {
				$('#DataGrid').datagrid('highlightRow', i);
			}
			Record['校验信息'] = Msg;
			RecordArr.push(Record);
		}
		$('#DataGrid').datagrid('loadData', RecordArr);
		return CheckFlag;
	};
	var CmObj = {
		CSSD_Package: [[
			{
				title: '消毒包编码',
				field: '消毒包编码',
				checknull: true,
				width: 100
			}, {
				title: '消毒包名称',
				field: '消毒包名称',
				checknull: true,
				width: 100
			}, {
				title: '消毒包别名',
				field: '消毒包别名',
				width: 100
			}, {
				title: '包装材料',
				field: '包装材料',
				checknull: true,
				width: 100
			}, {
				title: '消毒包分类',
				field: '消毒包分类',
				checknull: true,
				width: 100
			}, {
				title: '消毒包属性',
				field: '消毒包属性',
				checknull: true,
				width: 100
			}, {
				title: '价格',
				field: '价格',
				align: 'center',
				checknull: true,
				width: 100
			}, {
				title: '单位',
				field: '单位',
				checknull: true,
				width: 60
			}, {
				title: '规格',
				field: '规格',
				width: 60
			}, {
				title: '灭菌方式',
				field: '灭菌方式',
				checknull: true,
				width: 100
			}, {
				title: '有效期',
				field: '有效期',
				width: 100
			}, {
				title: '外来器械标志',
				field: '外来器械标志',
				width: 150
			}, {
				title: '接收科室',
				field: '接收科室',
				width: 100
			}, {
				title: '自动生成标牌数',
				field: '自动生成标牌数',
				align: 'right',
				width: 120
			}, {
				title: '校验信息',
				field: '校验信息',
				width: 160
			}
		]],
		CSSD_Item: [[
			{
				title: '消毒包名称',
				field: '消毒包名称',
				checknull: true,
				width: 160
			}, {
				title: '器械名称',
				field: '器械名称',
				checknull: true,
				width: 200
			}, {
				title: '器械数量',
				field: '器械数量',
				checknull: true,
				align: 'right',
				width: 80
			}, {
				title: '器械规格',
				field: '器械规格',
				width: 160
			}, {
				title: '器械别名',
				field: '器械别名',
				width: 160
			}, {
				title: '器械价格',
				field: '器械价格',
				align: 'right',
				width: 110
			}, {
				title: '一次性标志',
				field: '一次性标志',
				align: 'center',
				width: 100
			}, {
				title: '备注',
				field: '备注',
				width: 100
			}, {
				title: '校验信息',
				field: '校验信息',
				width: 160
			}
		]],
		CSSD_PackagePack: [[
			{
				title: '消毒包名称',
				field: '消毒包名称',
				checknull: true,
				width: 160
			}, {
				title: '非循环包标签',
				field: '非循环包标签',
				checknull: true,
				width: 200
			}, {
				title: '失效日期',
				field: '失效日期',
				checknull: true,
				width: 120
			}, {
				title: '接收科室',
				field: '接收科室',
				checknull: true,
				width: 160
			}, {
				title: '校验信息',
				field: '校验信息',
				width: 160
			}
		]],
		CSSD_PackageClass: [[
			{
				title: '代码',
				field: '代码',
				checknull: true,
				width: 160
			}, {
				title: '描述',
				field: '描述',
				checknull: true,
				width: 200
			}, {
				title: '校验信息',
				field: '校验信息',
				width: 160
			}
		]],
		CSSD_CodeDict: [[
			{
				title: '消毒包名称',
				field: '消毒包名称',
				checknull: true,
				width: 150
			}, {
				title: '标牌编码',
				field: '标牌编码',
				checknull: true,
				width: 200
			}, {
				title: '标牌名称',
				field: '标牌名称',
				checknull: true,
				width: 150
			}, {
				title: '校验信息',
				field: '校验信息',
				width: 160
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
		columns: CmObj.CSSD_Package,
		singleSelect: false
	});
	ClearMain();
	InitHosp('CSSD_Package');
};
$(init);