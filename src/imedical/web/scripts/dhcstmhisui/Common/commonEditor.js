// 名称: 物资combogrid Editor
// 描述: 公共editor
// 编写者：XuChao
// 编写日期: 2018.04.27
InciEditor = function(HandlerParams, SelectRow, MultipleFlag) {
	MultipleFlag = MultipleFlag == undefined ? false : MultipleFlag;
	var cbg = null; // combogrid this;
	function LoadData(q, obj) {
		var BarCodeInfo = $.cm({
			ClassName: 'web.DHCSTMHUI.DHCUDI',
			MethodName: 'UDIInfo',
			Code: q
		}, false);
		if (BarCodeInfo.Inci) {
			var _options = jQuery.extend(true, {}, { BarCode: BarCodeInfo.InciBarCode }, addSessionParams(HandlerParams()));
			var Params = JSON.stringify(_options);
			$.cm({
				ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
				MethodName: 'GetPhaOrderItemInfo',
				StrParam: Params,
				page: 1,
				rows: 1,
				q: ''
			}, function(jsonData) {
				if (jsonData.rows.length == 0) { return; }
				obj.combogrid('setValue', jsonData.rows[0].InciDesc);
				obj.combogrid('hidePanel');
				// /"OrgBarCode^InciBarCode^Inci^Incib^BatchNo^ExpDate^ProduceDate^SerialNo"
				var row = jQuery.extend(true, {}, jsonData.rows[0], BarCodeInfo);
				SelectRow(row);
			});
		} else {
			var queryParams = new Object();
			queryParams.ClassName = 'web.DHCSTMHUI.Util.DrugUtil';
			queryParams.MethodName = 'GetPhaOrderItemInfo';
			queryParams.q = q;
			var opts = obj.combogrid('grid').datagrid('options');
			opts.url = $URL;
			obj.combogrid('grid').datagrid('load', queryParams);
			obj.combogrid('setValue', q);
		}
	}
	return {
		type: 'combogrid',
		options: {
			url: $URL,
			queryParams: {
				ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
				MethodName: 'GetPhaOrderItemInfo',
				StrParam: ''
			},
			EnterFun: LoadData,		// 回车时,优先判断是否执行的方法
			multiple: MultipleFlag,
			checkOnSelect: !MultipleFlag,	// 注意核multiple结合
			required: true,
			tipPosition: 'bottom',
			// delay: 500,
			panelHeight: Math.max(200, $(window).height() * 0.5),		// 使用window高度的1/2,这样不管是向下显示还是向上显示,都有足够的空间.
			panelWidth: 850,
			mode: 'remote',
			idField: 'InciDr',
			textField: 'InciDesc',
			// 这里使用html工具条时,第二次展开弹窗不显示...
			toolbar: '<div><table><tr>'
			+ '<td style="padding:5px;"><label>规格</label></td>'
			+ '<td><input id="InciEditorSpec" name="Spec" class="textbox" style="margin-right:10px;"></td>'
			+ '<td style="padding:5px;"><label>品牌</label></td>'
			+ '<td><input id="InciEditorBrand" name="Brand" class="textbox" style="margin-right:10px;"></td>'
			+ '<td style="padding:5px;"><label>进价</label></td>'
			+ '<td><input id="InciEditorRp" name="Rp" class="textbox" style="margin-right:10px;"></td>'
			+ '<td><span class="icon-filter col-icon" style="vertical-align:middle" onclick="InciEditorFilter(this)">&nbsp;</span><span id="InciEditorFilterBtn" onclick="InciEditorFilter(this)">筛选</span></td>'
			+ '</tr></table></div>',
			pagination: true, // 是否分页
			rownumbers: true, // 序号
			collapsible: false, // 是否可折叠的
			fit: true, // 自动大小
			pageSize: 20, // 每页显示的记录条数，默认为10
			pageList: [10, 15, 20], // 可以设置每页记录条数的列表
			columns: [[
				{ field: 'ck', checkbox: true },
				{ field: 'InciCode', title: '代码', width: 120 },
				{ field: 'InciDesc', title: '名称', width: 150 },
				{ field: 'InciDr', title: 'InciDr', width: 60, hidden: true },
				{ field: 'Spec', title: '规格', width: 100, sortable: true },
				{ field: 'Model', title: '型号', width: 100 },
				{ field: 'Brand', title: '品牌', width: 100, sortable: true },
				{ field: 'Manfdr', title: '生产厂家Id', width: 100, hidden: true },
				{ field: 'ManfName', title: '生产厂家', width: 100, sortable: true },
				{ field: 'HVFlag', title: '高值', width: 40, formatter: BoolFormatter },
				{ field: 'InciItem', title: 'InciItem', width: 60, hidden: true },
				{ field: 'PUomDr', title: '入库单位Id', width: 100, hidden: true },
				{ field: 'PUomDesc', title: '入库单位', width: 80 },
				{ field: 'PRp', title: '进价(入库单位)', width: 110, align: 'right', sortable: true },
				{ field: 'PSp', title: '售价(入库单位)', width: 110, align: 'right' },
				{ field: 'PUomQty', title: '数量(入库单位)', width: 110, align: 'right' },
				{ field: 'BUomDr', title: '基本单位Id', width: 100, hidden: true },
				{ field: 'BUomDesc', title: '基本单位', width: 80 },
				{ field: 'BRp', title: '进价(基本单位)', width: 110, align: 'right' },
				{ field: 'BSp', title: '售价(基本单位)', width: 110, align: 'right' },
				{ field: 'BUomQty', title: '数量(基本单位)', width: 110, align: 'right' },
				{ field: 'BillUomDr', title: '账单单位Id', width: 100, hidden: true },
				{ field: 'BillUomDesc', title: '账单单位', width: 80 },
				{ field: 'BillRp', title: '进价(账单单位)', width: 110, align: 'right' },
				{ field: 'BillSp', title: '售价(账单单位)', width: 110, align: 'right' },
				{ field: 'BillUomQty', title: '数量(账单单位)', width: 110, align: 'right' },
				{ field: 'NotUseFlag', title: '不可用标志', width: 80, formatter: BoolFormatter },
				{ field: 'ProvLoc', title: '供货科室', width: 100 },
				{ field: 'Remarks', title: '备注', width: 60 },
				{ field: 'ARCDesc', title: '医嘱名称', width: 100 },
				{ field: 'ZeroStkFlag', title: '零库存标志', width: 80 },
				{ field: 'PbRp', title: '招标进价', width: 100 },
				{ field: 'CertNo', title: '注册证号', width: 100 },
				{ field: 'CertExpDate', title: '注册证效期', width: 80 },
				{ field: 'ReqPuomQty', width: 60, hidden: true },
				{ field: 'ProvLocId', width: 60, hidden: true },
				{ field: 'PFac', width: 60, hidden: true },
				{ field: 'BatchReq', width: 60, hidden: true },
				{ field: 'ExpReq', width: 60, hidden: true },
				{ field: 'BatchCodeFlag', width: 60, hidden: true },
				{ field: 'PUomAvaQty', title: '可用库存', width: 60, align: 'right', hidden: true }
			]],
			onClickRow: function(index, row) {
				var multiple = $(this).datagrid('options')['multiple'];
				if (!multiple) {
					cbg.combogrid('setValue', row.InciDesc);
					cbg.combogrid('destroy');
					SelectRow(row);
				}
			},
			onDblClickRow: function(index, row) {
				var multiple = $(this).datagrid('options')['multiple'];
				if (multiple) {
					var Rows = $(this).datagrid('getChecked');
					cbg.combogrid('destroy');
					SelectRow(Rows);
				}
			},
			onShowPanel: function() {
				cbg = $(this);
				$('#InciEditorSpec').val(''), $('#InciEditorBrand').val(''), $('#InciEditorRp').val('');
			},
			onBeforeLoad: function(param) {
				if (isEmpty(param.q)) { return false; }
				var ParamObj = HandlerParams();
				var ToolBarParam = {
					Spec: $('#InciEditorSpec').val(),
					Brand: $('#InciEditorBrand').val(),
					Rp: $('#InciEditorRp').val()
				};
				ParamObj = $.extend(ParamObj, sessionObj, ToolBarParam);
				var Params = JSON.stringify(ParamObj);
				param.StrParam = Params;
			},
			onLoadSuccess: function(data) {
				if (data.rows.length > 0) {
					$(this).combogrid('grid').datagrid('selectRow', 0);
				}
			},
			keyHandler: {
				up: function() {
					// 取得选中行
					var selected = $(this).combogrid('grid').datagrid('getSelected');
					if (selected) {
						// 取得选中行的rowIndex
						var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
						// 向上移动到第一行为止
						if (index > 0) {
							$(this).combogrid('grid').datagrid('selectRow', index - 1);
						} else {
							var rows = $(this).combogrid('grid').datagrid('getRows');
							$(this).combogrid('grid').datagrid('selectRow', rows.length - 1);
						}
					} else {
						var rows = $(this).combogrid('grid').datagrid('getRows');
						if (rows.length > 0) {
							$(this).combogrid('grid').datagrid('selectRow', rows.length - 1);
						}
					}
				},
				down: function() {
					// 取得选中行
					var selected = $(this).combogrid('grid').datagrid('getSelected');
					if (selected) {
						// 取得选中行的rowIndex
						var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
						// 向下移动到当页最后一行为止
						if (index < $(this).combogrid('grid').datagrid('getData').rows.length - 1) {
							$(this).combogrid('grid').datagrid('selectRow', index + 1);
						} else {
							$(this).combogrid('grid').datagrid('selectRow', 0);
						}
					} else {
						var rows = $(this).combogrid('grid').datagrid('getRows');
						if (rows.length > 0) {
							$(this).combogrid('grid').datagrid('selectRow', 0);
						}
					}
				},
				left: function() {
					return false;
				},
				right: function() {
					return false;
				},
				enter: function() {
					// 文本框的内容为选中行的的字段内容
					var selected = $(this).combogrid('grid').datagrid('getSelected');
					if (selected) {
						$(this).combogrid('setValue', selected.InciDesc);
						$(this).combogrid('destroy');
						setTimeout(function() {
							SelectRow(selected);
						}, 50);
					}
				},
				query: function(q) {
					if (!isEmpty($(this).combogrid('options')['EnterFun'])) {
						// 配置了EnterFun函数的,不进行自动加载
						return false;
					}
					$(this).combogrid('grid').datagrid('clearSelections');
					
					var object = new Object();
					object = $(this);
					if (this.AutoSearchTimeOut) {
						window.clearTimeout(this.AutoSearchTimeOut);
						this.AutoSearchTimeOut = window.setTimeout(function() { LoadData(q, object); }, 400);
					} else {
						this.AutoSearchTimeOut = window.setTimeout(function() { LoadData(q, object); }, 400);
					}
					$(this).combogrid('setValue', q);
				}
			}
		}
	};
};
var InciEditorFilter =	function(obj) {
	$(obj).parentsUntil('.datagrid', '.datagrid-toolbar').next().children('.datagrid-f').datagrid('reload');
};
/*
 * Incilookup的配置
 * @HandlerParams  列表参数
 * @_this 自身Id
 * @change InciId
 * 使用示例代码
 *$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#Inci'));
 */
var InciLookUpOp = function(HandlerParams, _this, change) {
	$(_this).on('input', function(e) {
		$(change).val('');
		if ($(_this).lookup('options')['valueType'] === 'text') {
			// 按text取值的lookup, text变更时,将value置空
			$HUI.lookup(_this).setValue('');
		}
	});
	return {
		url: $URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
			MethodName: 'GetPhaOrderItemInfo',
			StrParam: ''
		},
		mode: 'remote',
		idField: 'InciDr',
		textField: 'InciDesc',
		valueType: 'text',		// 2020-06-04 考虑到原有模式,按text取值
		fitColumns: true,
		columnsLoader: function() {
			return [[
				{ field: 'InciCode', title: '物资代码', width: 150 },
				{ field: 'InciDesc', title: '物资名称', width: 240 },
				{ field: 'Spec', title: '规格', width: 150 },
				{ field: 'ManfName', title: '生产厂家', width: 200 },
				{ field: 'InciDr', title: 'ID', width: 50, hidden: true }
			]];
		},
		pagination: true,
		panelWidth: 600,
		panelHeight: 410,
		onBeforeLoad: function(param) {
			var Params = JSON.stringify(addSessionParams(HandlerParams()));
			param.StrParam = Params;
		},
		onSelect: function(index, row) {
			$(change).val(row.InciDr);
		}
	};
};