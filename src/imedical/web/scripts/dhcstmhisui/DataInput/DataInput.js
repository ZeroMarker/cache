// /徐超  20180920  导入数据
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
		buttonText: '选择',
		prompt: '请选择要导入的Excel',
		accept: 'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
		width: 200
	});
	$('#Type').combobox({
		data: [
			{ 'RowId': 'Stk', 'Description': '库存(入库单)导入' },
			{ 'RowId': 'Bin', 'Description': '货位码导入' },
			{ 'RowId': 'Adj', 'Description': '调价数据导入' },
			{ 'RowId': 'Reg', 'Description': '注册证信息导入' },
			{ 'RowId': 'Pur', 'Description': '带量信息导入' }
			// { 'RowId': 'ApcVendor', 'Description': '供应商导入' },
			// { 'RowId': 'Manf', 'Description': '生产厂家导入' },
			// { 'RowId': 'Inci', 'Description': '物资字典(后勤)导入' },
			// { 'RowId': 'InciArc', 'Description': '物资字典(医用)导入' }
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
			if (BtnName == 'LoadMoudle') { // 下载数导入模板
				var Type = $HUI.combobox('#Type').getText();
				if (isEmpty(Type)) {
					$UI.msg('alert', '请先选择数据类型!');
					return;
				}
				var filename = Type + '模板.xls';
				window.open('../scripts/dhcstmhisui/DataInput/Excel模板/' + filename, '_blank');
			} else if (BtnName == 'LoadMouDesc') { // 下载模板说明
				window.open('../scripts/dhcstmhisui/DataInput/Excel模板/模板说明.txt', '_blank');
			}
		}
	});
	$UI.linkbutton('#ReadBT', {
		onClick: function() {
			var wb; // wookbook
			var Type = $HUI.combobox('#Type').getValue();
			if (isEmpty(Type)) {
				$UI.msg('alert', '数据类型不能为空!');
				return;
			}
			var filelist = $('#File').filebox('files');
			if (filelist.length == 0) {
				$UI.msg('alert', '请选择要导入的Excel!');
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
		// 取 第一个sheet 数据
		var jsonData = {};
		var sheet2JSONOpts = {
			defval: ''		// 格子为空时的默认值
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
			$UI.msg('alert', '数据类型不能为空!');
			return;
		}
		var Rows = DataGrid.getRowsData();
		if (Rows.length == 0) {
			$UI.msg('alert', '没有需要上传的数据!');
			return;
		}
		Rows = JSON.stringify(Rows);
		var Params = JSON.stringify(sessionObj);
		showMask();
		
		// 先把数据记录到临时global
		var PidStr = tkMakeServerCall('web.DHCSTMHUI.Tools.DataInput', 'SetGlobal', Rows);
		var Success = PidStr.split('^')[0];
		if (Success < 0) {
			$UI.msg('alert', '程序错误!');
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
				$UI.msg('alert', '导入结果查看具体原因!');
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
					Msg = Msg + '第' + (i + 1) + '行' + CheckField[j] + '不能为空!';
					CheckFlag = false;
				}
			}
			for (var k = 0; k < CheckDateField.length; k++) {
				var val = Record[CheckDateField[k]];
				if (!isEmpty(val) && !CheckDateForm(val)) {
					Msg = Msg + '第' + (i + 1) + '行' + CheckDateField[k] + '日期格式不正确!';
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
		Cm: [[{ title: '', field: '', width: 0 }]],
		Inci: [[
			{
				title: '医院',
				field: '医院',
				// checknull: true,
				width: 100
			}, {
				title: '库存大类名称',
				field: '库存大类名称',
				checknull: true,
				width: 100
			}, {
				title: '库存子类名称',
				field: '库存子类名称',
				checknull: true,
				width: 100
			}, {
				title: '物资代码',
				field: '物资代码',
				width: 100
			}, {
				title: '物资名称',
				field: '物资名称',
				checknull: true,
				width: 100
			}, {
				title: '规格',
				field: '规格',
				width: 100
			}, {
				title: '型号',
				field: '型号',
				width: 100
			}, {
				title: '品牌',
				field: '品牌',
				width: 100
			}, {
				title: '简称',
				field: '简称',
				width: 100
			}, {
				title: '协和码',
				field: '协和码',
				width: 100
			}, {
				title: '别名',
				field: '别名',
				width: 100
			}, {
				title: '最小单位',
				field: '最小单位',
				checknull: true,
				width: 100
			}, {
				title: '整包装单位',
				field: '整包装单位',
				checknull: true,
				width: 100
			}, {
				title: '整包转换系数',
				field: '整包转换系数',
				checknull: true,
				width: 100
			}, {
				title: '售价',
				field: '售价',
				width: 100
			}, {
				title: '进价',
				field: '进价',
				checknull: true,
				width: 100
			}, {
				title: '是否收费',
				field: '是否收费',
				width: 100
			}, {
				title: '是否高值',
				field: '是否高值',
				width: 100
			}, {
				title: '批号要求',
				field: '批号要求',
				width: 100
			}, {
				title: '效期要求',
				field: '效期要求',
				width: 100
			}, {
				title: '供应商名称',
				field: '供应商名称',
				width: 100
			}, {
				title: '生产厂家名称',
				field: '生产厂家名称',
				width: 100
			}, {
				title: '器械注册证号',
				field: '器械注册证号',
				width: 100
			}, {
				title: '器械注册证效期',
				field: '器械注册证效期',
				checkDate: true,
				width: 100
			}, {
				title: '供应商营业执照号',
				field: '供应商营业执照号',
				width: 100
			}, {
				title: '供应商经营许可证号',
				field: '供应商经营许可证号',
				width: 100
			}, {
				title: '供应商经营许可证效期',
				field: '供应商经营许可证效期',
				checkDate: true,
				width: 100
			}, {
				title: '生产许可证号',
				field: '生产许可证号',
				width: 100
			}, {
				title: '生产许可证效期',
				field: '生产许可证效期',
				checkDate: true,
				width: 100
			}, {
				title: '授权到期',
				field: '授权到期',
				checkDate: true,
				width: 100
			}, {
				title: '授权联系人',
				field: '授权联系人',
				width: 100
			}, {
				title: '授权联系人电话',
				field: '授权联系人电话',
				width: 100
			}, {
				title: '备注',
				field: '备注',
				width: 100
			}, {
				title: '具体规格',
				field: '具体规格',
				width: 100
			}, {
				title: '校验信息',
				field: '校验信息',
				sortable: true,
				width: 350
			}
		]],
		InciArc: [[
			{
				title: '医院',
				field: '医院',
				// checknull: true,
				width: 100
			}, {
				title: '库存大类名称',
				field: '库存大类名称',
				checknull: true,
				width: 100
			}, {
				title: '库存子类名称',
				field: '库存子类名称',
				checknull: true,
				width: 100
			}, {
				title: '物资代码',
				field: '物资代码',
				width: 100
			}, {
				title: '物资名称',
				field: '物资名称',
				checknull: true,
				width: 100
			}, {
				title: '规格',
				field: '规格',
				width: 100
			}, {
				title: '型号',
				field: '型号',
				width: 100
			}, {
				title: '品牌',
				field: '品牌',
				width: 100
			}, {
				title: '简称',
				field: '简称',
				width: 100
			}, {
				title: '协和码',
				field: '协和码',
				width: 100
			}, {
				title: '别名',
				field: '别名',
				width: 100
			}, {
				title: '最小单位',
				field: '最小单位',
				checknull: true,
				width: 100
			}, {
				title: '整包装单位',
				field: '整包装单位',
				checknull: true,
				width: 100
			}, {
				title: '整包转换系数',
				field: '整包转换系数',
				checknull: true,
				width: 100
			}, {
				title: '账单单位',
				field: '账单单位',
				checknull: true,
				width: 100
			}, {
				title: '售价',
				field: '售价',
				width: 100
			}, {
				title: '进价',
				field: '进价',
				checknull: true,
				width: 100
			}, {
				title: '医嘱大类',
				field: '医嘱大类',
				checknull: true,
				width: 100
			}, {
				title: '医嘱子类',
				field: '医嘱子类',
				checknull: true,
				width: 100
			}, {
				title: '账单大类',
				field: '账单大类',
				checknull: true,
				width: 100
			}, {
				title: '账单子类',
				field: '账单子类',
				checknull: true,
				width: 100
			}, {
				title: '收费大类',
				field: '收费大类',
				checknull: true,
				width: 100
			}, {
				title: '收费子类',
				field: '收费子类',
				checknull: true,
				width: 100
			}, {
				title: '住院大类',
				field: '住院大类',
				checknull: true,
				width: 100
			}, {
				title: '住院子类',
				field: '住院子类',
				checknull: true,
				width: 100
			}, {
				title: '门诊大类',
				field: '门诊大类',
				checknull: true,
				width: 100
			}, {
				title: '门诊子类',
				field: '门诊子类',
				checknull: true,
				width: 100
			}, {
				title: '核算大类',
				field: '核算大类',
				checknull: true,
				width: 100
			}, {
				title: '核算子类',
				field: '核算子类',
				checknull: true,
				width: 100
			}, {
				title: '会计大类',
				field: '会计大类',
				checknull: true,
				width: 100
			}, {
				title: '会计子类',
				field: '会计子类',
				checknull: true,
				width: 100
			}, {
				title: '病案大类',
				field: '病案大类',
				checknull: true,
				width: 100
			}, {
				title: '病案子类',
				field: '病案子类',
				checknull: true,
				width: 100
			}, {
				title: '新病案首页子类',
				field: '新病案首页子类',
				checknull: true,
				width: 100
			}, {
				title: '医保编码',
				field: '医保编码',
				width: 100
			}, {
				title: '医保描述',
				field: '医保描述',
				width: 100
			}, {
				title: '医嘱优先级',
				field: '医嘱优先级',
				width: 100
			}, {
				title: '独立医嘱',
				field: '独立医嘱',
				checknull: true,
				width: 100
			}, {
				title: '无库存医嘱',
				field: '无库存医嘱',
				checknull: true,
				width: 100
			}, {
				title: '是否收费',
				field: '是否收费',
				width: 100
			}, {
				title: '是否高值',
				field: '是否高值',
				width: 100
			}, {
				title: '批号要求',
				field: '批号要求',
				width: 100
			}, {
				title: '效期要求',
				field: '效期要求',
				width: 100
			}, {
				title: '监管级别',
				field: '监管级别',
				width: 100
			}, {
				title: '条码',
				field: '条码',
				width: 100
			}, {
				title: '招标进价',
				field: '招标进价',
				width: 100
			}, {
				title: '供应商名称',
				field: '供应商名称',
				width: 100
			}, {
				title: '生产厂家名称',
				field: '生产厂家名称',
				width: 100
			}, {
				title: '招标配送商名称',
				field: '招标配送商名称',
				width: 100
			}, {
				title: '器械注册证号',
				field: '器械注册证号',
				width: 100
			}, {
				title: '器械注册证效期',
				field: '器械注册证效期',
				width: 100
			}, {
				title: '生产许可证号',
				field: '生产许可证号',
				width: 100
			}, {
				title: '生产许可证效期',
				field: '生产许可证效期',
				width: 100
			}, {
				title: '供应商营业执照号',
				field: '供应商营业执照号',
				width: 100
			}, {
				title: '供应商营业执照有效期',
				field: '供应商营业执照有效期',
				checkDate: true,
				width: 100
			}, {
				title: '供应商税务登记证号',
				field: '供应商税务登记证号',
				width: 350
			}, {
				title: '供应商组织机构代码',
				field: '供应商组织机构代码',
				width: 100
			}, {
				title: '供应商组织机构代码有效期',
				field: '供应商组织机构代码有效期',
				checkDate: true,
				width: 100
			}, {
				title: '供应商经营许可证号',
				field: '供应商经营许可证号',
				width: 100
			}, {
				title: '供应商经营许可证效期',
				field: '供应商经营许可证效期',
				checkDate: true,
				width: 100
			}, {
				title: '授权到期',
				field: '授权到期',
				width: 100
			}, {
				title: '授权联系人',
				field: '授权联系人',
				width: 100
			}, {
				title: '授权联系人电话',
				field: '授权联系人电话',
				width: 100
			}, {
				title: '备注',
				field: '备注',
				width: 100
			}, {
				title: '具体规格',
				field: '具体规格',
				width: 100
			}, {
				title: '校验信息',
				field: '校验信息',
				sortable: true,
				width: 350
			}
		]],
		ApcVendor: [[
			{
				title: '医院',
				field: '医院',
				width: 100
			}, {
				title: '代码',
				field: '代码',
				width: 100
			}, {
				title: '名称',
				field: '名称',
				checknull: true,
				width: 100
			}, {
				title: '电话',
				field: '电话',
				width: 100
			}, {
				title: '开户银行',
				field: '开户银行',
				width: 100
			}, {
				title: '开户账号',
				field: '开户账号',
				width: 100
			}, {
				title: '采购限额',
				field: '采购限额',
				width: 100
			}, {
				title: '供应商分类',
				field: '供应商分类',
				width: 100
			}, {
				title: '合同截止日期',
				field: '合同截止日期',
				checkDate: true,
				width: 100
			}, {
				title: '传真',
				field: '传真',
				width: 100
			}, {
				title: '法人代表',
				field: '法人代表',
				width: 100
			}, {
				title: '地址',
				field: '地址',
				width: 100
			}, {
				title: '工商执照',
				field: '工商执照',
				width: 100
			}, {
				title: '工商执照效期',
				field: '工商执照效期',
				checkDate: true,
				width: 100
			}, {
				title: '税务登记',
				field: '税务登记',
				width: 100
			}, {
				title: '税务登记效期',
				field: '税务登记效期',
				checkDate: true,
				width: 100
			}, {
				title: '医疗器械经营许可证',
				field: '医疗器械经营许可证',
				width: 100
			}, {
				title: '医疗器械经营许可证效期',
				field: '医疗器械经营许可证效期',
				checkDate: true,
				width: 100
			}, {
				title: '医疗器械注册证',
				field: '医疗器械注册证',
				width: 100
			}, {
				title: '医疗器械注册证效期',
				field: '医疗器械注册证效期',
				checkDate: true,
				width: 100
			}, {
				title: '卫生许可证',
				field: '卫生许可证',
				width: 100
			}, {
				title: '卫生许可证效期',
				field: '卫生许可证效期',
				checkDate: true,
			
				width: 100
			}, {
				title: '组织机构代码',
				field: '组织机构代码',
				width: 100
			}, {
				title: '组织机构代码效期',
				field: '组织机构代码效期',
				checkDate: true,
				width: 100
			}, {
				title: 'Gsp',
				field: 'Gsp',
				width: 100
			}, {
				title: 'Gsp效期',
				field: 'Gsp效期',
				width: 100
			}, {
				title: '器械生产许可证',
				field: '器械生产许可证',
				width: 100
			}, {
				title: '器械生产许可证效期',
				field: '器械生产许可证效期',
				checkDate: true,
				width: 100
			}, {
				title: '生产制造认可表',
				field: '生产制造认可表',
				width: 100
			}, {
				title: '生产制造认可表效期',
				field: '生产制造认可表效期',
				checkDate: true,
				width: 100
			}, {
				title: '进口医疗器械注册证',
				field: '进口医疗器械注册证',
				width: 100
			}, {
				title: '进口注册登记表',
				field: '进口注册登记表',
				width: 100
			}, {
				title: '进口注册登记表效期',
				field: '进口注册登记表效期',
				checkDate: true,
				width: 100
			}, {
				title: '代理销售授权书',
				field: '代理销售授权书',
				width: 100
			}, {
				title: '代理销售授权书效期',
				field: '代理销售授权书效期',
				checkDate: true,
				width: 100
			}, {
				title: '售后服务承诺书',
				field: '售后服务承诺书',
				width: 100
			}, {
				title: '法人委托书',
				field: '法人委托书',
				width: 100
			}, {
				title: '质量承诺书',
				field: '质量承诺书',
				width: 100
			}, {
				title: '质量承诺书效期',
				field: '质量承诺书效期',
				checkDate: true,
				width: 100
			}, {
				title: '业务员姓名',
				field: '业务员姓名',
				width: 100
			}, {
				title: '业务员授权书效期',
				field: '业务员授权书效期',
				checkDate: true,
				width: 100
			}, {
				title: '业务员电话',
				field: '业务员电话',
				width: 100
			}, {
				title: '校验信息',
				field: '校验信息',
				sortable: true,
				width: 350
			}
		]],
		Manf: [[
			{
				title: '医院',
				field: '医院',
				width: 100
			}, {
				title: '代码',
				field: '代码',
				checknull: true,
				width: 100
			}, {
				title: '名称',
				field: '名称',
				checknull: true,
				width: 100
			}, {
				title: '地址',
				field: '地址',
				width: 100
			}, {
				title: '电话',
				field: '电话',
				width: 100
			}, {
				title: '上级生产厂家',
				field: '上级生产厂家',
				width: 100
			}, {
				title: '材料生产许可证',
				field: '材料生产许可证',
				width: 100
			}, {
				title: '材料生产许可证效期',
				field: '材料生产许可证效期',
				checkDate: true,
				width: 100
			}, {
				title: '工商执照许可',
				field: '工商执照许可',
				width: 100
			}, {
				title: '工商执照许可效期',
				field: '工商执照许可效期',
				checkDate: true,
				width: 100
			}, {
				title: '工商注册号',
				field: '工商注册号',
				width: 100
			}, {
				title: '工商注册号效期',
				field: '工商注册号效期',
				checkDate: true,
				width: 100
			}, {
				title: '组织机构代码',
				field: '组织机构代码',
				width: 100
			}, {
				title: '组织机构代码效期',
				field: '组织机构代码效期',
				checkDate: true,
				width: 100
			}, {
				title: '税务登记号',
				field: '税务登记号',
				width: 100
			}, {
				title: '器械经营许可证',
				field: '器械经营许可证',
				width: 100
			}, {
				title: '器械经营许可证效期',
				field: '器械经营许可证效期',
				checkDate: true,
				width: 100
			}, {
				title: '校验信息',
				field: '校验信息',
				sortable: true,
				width: 350
			}
		]],
		Bin: [[
			{
				title: '科室名称',
				field: '科室名称',
				checknull: true,
				width: 150
			}, {
				title: '货位名称',
				field: '货位名称',
				checknull: true,
				width: 150
			}, {
				title: '校验信息',
				field: '校验信息',
				sortable: true,
				width: 350
			}
		]],
		Adj: [[
			{
				title: '科室名称',
				field: '科室名称',
				checknull: true,
				width: 100
			}, {
				title: '物资代码',
				field: '物资代码',
				checknull: true,
				width: 100
			}, {
				title: '物资名称',
				field: '物资名称',
				checknull: true,
				width: 100
			}, {
				title: '调价单位',
				field: '调价单位',
				checknull: true,
				width: 100
			}, {
				title: '调后进价',
				field: '调后进价',
				checknull: true,
				width: 100
			}, {
				title: '调后售价',
				field: '调后售价',
				checknull: true,
				width: 100
			}, {
				title: '计划生效日期',
				field: '计划生效日期',
				checknull: true,
				CheckDate: true,
				width: 100
			}, {
				title: '物价文件号',
				field: '物价文件号',
				width: 100
			}, {
				title: '物价文件日期',
				field: '物价文件日期',
				checkDate: true,
				width: 100
			}, {
				title: '校验信息',
				field: '校验信息',
				sortable: true,
				width: 350
			}
		]],
		Stk: [[
			{
				title: '科室名称',
				field: '科室名称',
				checknull: true,
				saveCol: true,
				width: 100
			}, {
				title: '供应商',
				field: '供应商',
				checknull: true,
				saveCol: true,
				width: 120
			}, {
				title: '物资代码',
				field: '物资代码',
				checknull: true,
				saveCol: true,
				width: 100
			}, {
				title: '物资名称',
				field: '物资名称',
				checknull: true,
				width: 120
			}, {
				title: '数量',
				field: '数量',
				checknull: true,
				saveCol: true,
				align: 'right',
				width: 60
			}, {
				title: '入库单位',
				field: '入库单位',
				checknull: true,
				saveCol: true,
				width: 60
			}, {
				title: '进价',
				field: '进价',
				checknull: true,
				saveCol: true,
				align: 'right',
				width: 100
			}, {
				title: '批号',
				field: '批号',
				saveCol: true,
				width: 100
			}, {
				title: '效期',
				field: '效期',
				checkDate: true,
				saveCol: true,
				width: 100
			}, {
				title: '具体规格',
				field: '具体规格',
				saveCol: true,
				width: 100
			}, /* {
			title: '生产厂家',
			field: '生产厂家',
			width: 100
		},*/ {
				title: '高值条码',
				field: '高值条码',
				saveCol: true,
				width: 100
			}, {
				title: '自带条码',
				field: '自带条码',
				saveCol: true,
				width: 100
			}, {
				title: '接收科室名称',
				field: '接收科室名称',
				saveCol: true,
				width: 100
			}, {
				title: '校验信息',
				field: '校验信息',
				sortable: true,
				width: 350
			}
		]],
		Reg: [[
			{
				title: '医院',
				field: '医院',
				checknull: true,
				width: 100
			}, {
				title: '物资代码',
				field: '物资代码',
				checknull: true,
				width: 100
			}, {
				title: '物资名称',
				field: '物资名称',
				checknull: true,
				width: 100
			}, {
				title: '生产厂家',
				field: '生产厂家',
				checknull: true,
				width: 100
			}, {
				title: '注册证号',
				field: '注册证号',
				checknull: true,
				width: 100
			}, {
				title: '注册证效期',
				field: '注册证效期',
				checknull: true,
				checkDate: true,
				width: 100
			}, {
				title: '注册证名称',
				field: '注册证名称',
				checknull: true,
				width: 100
			}, {
				title: '注册证发证日期',
				field: '注册证发证日期',
				checkDate: true,
				width: 100
			}, {
				title: '注册证延长效期标志',
				field: '注册证延长效期标志',
				width: 100
			}, {
				title: '校验信息',
				field: '校验信息',
				sortable: true,
				width: 350
			}
		]],
		Pur: [[
			{
				title: '物资代码',
				field: '物资代码',
				saveCol: true,
				width: 100
			}, {
				title: '物资名称',
				field: '物资名称',
				saveCol: true,
				width: 120
			}, {
				title: '带量编号',
				field: '带量编号',
				checknull: true,
				saveCol: true,
				width: 80
			}, {
				title: '带量名称',
				field: '带量名称',
				checknull: true,
				saveCol: true,
				width: 120
			}, {
				title: '带量类型',
				field: '带量类型',
				checknull: true,
				saveCol: true,
				width: 80
			}, {
				title: '起始日期',
				field: '起始日期',
				saveCol: true,
				checkDate: true,
				width: 100
			}, {
				title: '截至日期',
				field: '截至日期',
				saveCol: true,
				checkDate: true,
				width: 100
			}, {
				title: '任务量',
				field: '任务量',
				saveCol: true,
				width: 60
			}, {
				title: '校验信息',
				field: '校验信息',
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
			var Msg = row.校验信息;
			if (!isEmpty(Msg) && Msg != '√') {
				return 'background-color:yellow;color:black;font-weight:bold;';
			}
		}
	});
	ClearMain();
};
$(init);