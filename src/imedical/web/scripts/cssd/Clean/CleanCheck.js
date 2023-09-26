function deleteItem(rowId) {
	if (isEmpty(rowId)) {
		$UI.msg('alert', '请选择要删除的单据!');
		return false;
	}
	$.cm({
		ClassName : 'web.CSSDHUI.Clean.CleanInfo',
		MethodName : 'jsDelete',
		rowId : rowId
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				$('#ItemList').datagrid('reload');
			} else {
				$UI.msg('error', jsonData.msg);
			}
		}
	);

}
var init = function() {
	setDafult();
	$("#Iscmt").val('1');
	var Params = JSON.stringify($UI.loopBlock('cleantable'));
	var GridListIndex = "";
	var GridListIndexId = ""
	// 清洗方式
	$("#cleantype").keydown(function(e) {
		var curKey = e.which;
		if (curKey == 13) {
			if ($("#cleantype").val() != "") {
				$.m({
					ClassName : "web.CSSDHUI.Clean.CleanInfo",
					MethodName : "GetCleanType",
					cleanCode : $("#cleantype").val()
				}, function(txtData) {
					if (txtData != null && !isEmpty(txtData)) {
						arr = txtData.split('^');
						$("#cleantypev").val(arr[0]);
						$("#cleantype").val(arr[1]);
						$('#cleanmachine').focus();
					} else {
						$UI.msg('alert', '错误的清洗方式!');
						$("#cleantype").val("");
						$('#cleantype').focus();
						return;
					}
				})
			}
		}
	});
	//不合格原因下拉框
	var ReasonCombox = $HUI.combobox('#UnqualifiedReason', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCleanReason&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var ReasonComData = $.cm({
			ClassName: 'web.CSSDHUI.Common.Dicts',
			QueryName: 'GetCleanReason',
			ResultSetType: 'array'
		}, false);
	var ReasonCombox = {
		type: 'combobox',
		options: {
			data: ReasonComData,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function (record) {
				var rows = GridList.getRows();
				var row = rows[GridList.editIndex];
				row.ReasonName = record.Description;
			},
			onShowPanel: function () {
				$(this).combobox('reload')
			}
		}
	}
	// 清洗锅号
	$("#cleanmachine").keydown(function(e) {
		var curKey = e.which;
		if (curKey == 13) {
			if ($("#cleanmachine").val() != "") {
				$('#cleanCode').focus();
			}
		}
	});
	// 清洗架
	$("#cleanCode").keydown(function(e) {
		var curKey = e.which;
		if (curKey == 13) {
			if ($("#cleanCode").val() != "") {
				$.m({
					ClassName : "web.CSSDHUI.Clean.CleanInfo",
					MethodName : "GetCleanCode",
					cleanCode : $("#cleanCode").val()
				}, function(txtData) {
					if (txtData != null && !isEmpty(txtData)) {
						arr = txtData.split('^');
						$("#cleanCodev").val(arr[0]);
						$("#cleanCode").val(arr[1]);
						$('#cleanStro').focus();
					} else {
						$UI.msg('alert', '错误的清洗架号!');
						$("#cleanCode").val("");
						$('#cleanCode').focus();
						return;
					}
				})
			}
		}
	});
	// 清洗程序
	$("#cleanStro").keydown(function(e) {
		var curKey = e.which;
		if (curKey == 13) {
			if ($("#cleanStro").val() != "") {
				$.m({
					ClassName : "web.CSSDHUI.Clean.CleanInfo",
					MethodName : "GetCleanPro",
					cleanCode : $("#cleanStro").val()
				}, function(txtData) {
					if (txtData != null && !isEmpty(txtData)) {
						arr = txtData.split('^');
						$("#cleanStrov").val(arr[0]);
						$("#cleanStro").val(arr[1]);
						$('#cleaner').focus();
					} else {
						$UI.msg('alert', '错误的清洗程序!');
						$("#cleanStro").val("");
						$('#cleanStro').focus();
						return;
					}
				})
			}
		}
	});
	// 清洗人回车
	$("#cleaner").keydown(function(e) {
		var curKey = e.which;
		if (curKey == 13) {
			if ($("#cleaner").val() != "") {
				$.m({
					ClassName : "web.CSSDHUI.Clean.CleanInfo",
					MethodName : "GetCleanUser",
					cleanCode : $("#cleaner").val()
				}, function(txtData) {
					if (txtData != null && !isEmpty(txtData)) {
						arr = txtData.split('^');
						$("#cleanerv").val(arr[0]);
						$("#cleaner").val(arr[1]);
						$('#cleanadd').focus();
					} else {
						$UI.msg('alert', '错误的清洗人!');
						$("#cleaner").val("");
						$('#cleaner').focus();
						return;
					}
				})
			}
		}
	});
	// 确定框
	$("#cleanadd").keydown(function(e) {
		var curKey = e.which;
		if (curKey == 13) {
			if ($("#cleanadd").val() == "0000000000") {
				$('#add').click();
			}
		}
	});
	// 增加清洗主表
	$UI.linkbutton('#add', {
		onClick : function() {
			var Params = JSON.stringify($UI.loopBlock('cleantable'));
			$.cm({
				ClassName : 'web.CSSDHUI.Clean.CleanInfo',
				MethodName : 'jsSaveClean',
				Params : Params
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg("success", jsonData.msg);
					$UI.clearBlock('#cleantable');
					GridList.commonReload();
					$UI.clearBlock('#cleantable');
				} else {
					$UI.msg("error", jsonData.msg);
				}
			});
		}
	});

	// 验收
	$UI.linkbutton('#check', {
		onClick : function() {
			var Rows = GridList.getSelected();
			if (isEmpty(Rows)) {
				$UI.msg("alert", "请选择需要验收的记录!");
				return;
			}
			GridListIndex = GridList.getRowIndex(Rows);
			GridListIndexId = Rows.ID;
			var FReqLocParams = JSON.stringify(addSessionParams({
				ID : Rows.ID
			}));
			if (Rows.IsResult) {
				$UI.msg("alert", "已经验收数据不能重复验收");
				return;
			}
			if (ItemListGrid.getRows() == "") {
				$UI.msg("alert", "没有明细不能进行验收");
				return;
			}
			$.messager.confirm("操作提示","您确定要执行操作吗？",function(data){
				if(data){
					$.cm({
						ClassName : 'web.CSSDHUI.Clean.CleanInfo',
						MethodName : 'CleanCheck',
						Params : FReqLocParams
					}, function(jsonData) {
						GridList.commonReload();
					});	
				}
			});
		}
	});
	// 验收不合格
	$UI.linkbutton('#checknpass', {
		onClick : function() {
			var Rows = GridList.getSelected();
			if (isEmpty(Rows)) {
				$UI.msg("alert", "请选择需要验收的记录!");
				return;
			}
			GridListIndex = GridList.getRowIndex(Rows);
			GridListIndexId = Rows.ID;
			var FReqLocParams = JSON.stringify(addSessionParams({ID:Rows.ID}));
			if (Rows.IsResult) {
				$UI.msg("alert", "已经验收数据不能重复验收");
				return;
			}
			$.messager.confirm("操作提示","您确定要执行操作吗？",function(data){
				if(data){
					$.cm({
						ClassName : 'web.CSSDHUI.Clean.CleanInfo',
						MethodName : 'CleanCheckNPass',
						Params : FReqLocParams
					}, function(jsonData) {
						GridList.commonReload();
					});
				}
			});	
		}
	});
	
	//单个明细验收不合格
	$UI.linkbutton('#CheckFailBT',{ 
		onClick:function(){
			var MainRow=GridList.getSelected();
			if(!isEmpty(MainRow.IsResult)){
				$UI.msg('alert',"该锅已验收,无法重复验收");
				return;
			}
			var Detail=ItemListGrid.getChecked();
			if(isEmpty(Detail)){
				$UI.msg('alert',"请选择不合格的灭菌明细");
				return;
			}
			var ReasonDr=$("#UnqualifiedReason").combobox('getValue')
			if(isEmpty(ReasonDr)){
				$UI.msg('alert',"请选择不合格原因");
				return;
			}
			var DetailIds=""
			$.each(Detail, function(index, item){
				if(DetailIds==""){
					DetailIds=item.ID;
				}else{
					DetailIds=DetailIds+","+item.ID;
				}
			});
			$.cm({
				ClassName: 'web.CSSDHUI.Clean.CleanInfo',
				MethodName: 'jsSingleFail',
				Params: JSON.stringify(addSessionParams({ID:MainRow.ID})),
				ReasonDr: ReasonDr,
				DetailIds:DetailIds
			},function(jsonData){
				if(jsonData.success>=0){
					$("#UnqualifiedReason").combobox('setValue',"");
					$UI.msg('success',jsonData.msg);
					GridList.reload();
				}else{
					$("#UnqualifiedReason").combobox('setValue',"");
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
	
	// 查询
	$UI.linkbutton('#query', {
		onClick : function() {
			$UI.clear(ItemListGrid);
			GridListIndex = "";
			GridListIndexId = "";
			var Params = JSON.stringify($UI.loopBlock('cleantable'));
			GridList.load({
				ClassName : 'web.CSSDHUI.Clean.CleanInfo',
				QueryName : 'SelectAllCleanCheck',
				Params : Params
			});
		}
	});
	// 扫码添加固定标签
	$("#BarCode").keypress(function(event) {
		if (event.which == 13) {
			var v = $("#BarCode").val();
			var row = $('#MainList').datagrid('getSelected');
			if (isEmpty(row)) {
				$UI.msg('alert', '请选择需要添加的锅次!');
				return;
			}
			if (isEmpty(row.RowId)) {
				$UI.msg('alert', '参数错误!');
				return;
			}
			$.cm({
				ClassName : 'web.CSSDHUI.Clean.CleanInfo',
				MethodName : 'jsSaveCleanDetail',
				mainId : row.RowId,
				barCode : v
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$("#BarCodeInfo").val(jsonData.msg)
					$('#ItemList').datagrid('reload');
				} else {
					$UI.msg('error', jsonData.msg);
				}
				$("#BarCode").val("").focus();
			});
		}
	});
	var ItemCm = [[
	{
		title : '',
		field : 'ck',
		checkbox : true,
		width : 30
	}, {
		title : 'ID',
		field : 'ID',
		width : 100,
		hidden : true
	}, {
		title : '申请单',
		field : 'ApplyNo',
		fitColumns:true,
		width : 100
	}, {
		title : '科室',
		field : 'LocName',
		fitColumns:true,
		width : 100
	}, {
		title : '消毒包名称',
		field : 'packagedesc',
		fitColumns:true,
		width : 140
	}, {
		title : '包标牌编码',
		field : 'CodeLabel',
		fitColumns:true,
		width : 100
	}, {
		title : '数量',
		field : 'qty',
		align : 'right',
		width : 70,
		fitColumns:true
	}, {
		title: '是否验收',
		field: 'IsResult',
		width: 100,
		fitColumns:true,
		hidden: true
	}, {
		title: '不合格原因',
		field: 'ReasonDr',
		width:179,
		formatter: CommonFormatter(ReasonCombox, 'ReasonDr', 'ReasonName'),
		editor: ReasonCombox,
		fitColumns:true
	}
	]];
	// 右边明细
	var ItemListGrid = $UI.datagrid('#ItemList', {
		queryParams : {
		ClassName : 'web.CSSDHUI.Clean.CleanInfo',
		MethodName : 'SelectCleanDetail'
		},
		columns : ItemCm,
		pagination:false,
		singleSelect:false,
		selectOnCheck: false,
		toolbar : '#InputTB',
		onLoadSuccess : function(data) {
			$("a[name='opera']").linkbutton({plain : true,iconCls : 'icon-cancel'});
		}
	});
	var Cm = [[{
				title : '验收标记',
				field : 'IsResult',
				width : 70,
				align : 'center',
				styler : flagColor,
				formatter : function(value) {
					var status = "";
					if (value == "1") {
						status = "合格";
					} else if (value == "0") {
						status = "不合格"
					} else {
						status = "未验收";
					}
					return status;
				}
			}, {
				title : 'ID',
				field : 'ID',
				hidden : true
			}, {
				title : '机器号',
				field : 'MachineNo',
				align : 'right',
				width : 60
			}, {
				title : '日期',
				field : 'CleanDate',
				width : 100
			}, {
				title : '时间',
				field : 'CleanTime',
				width : 70
			}, {
				title : '清洗人',
				field : 'CleanerName',
				width : 100
			}, {
				title: '清洗批号',
				field: 'CleanNo1',
				width: 150

			},{
				title : '验收人',
				field : 'ChkerName',
				width : 100
			}, {
				title : '验收时间',
				field : 'checktime',
				width : 100
			}]];
	function flagColor(val, row, index) {
		if (val == '1') {
			return 'background:#15b398;color:white';
		}else if(val == '0'){
			return 'background:#ff584c;color:white';
		}else {
			return 'background:#ffb746;color:white'
		}
	}
	function formatOper(val, row, index) {
		var str = "";
		str += '<span class="icon_Modify"><a href="#" onclick=update(' + row.ID+ ') id="del"  title="修改"></a></span>';
		str += '<span class="icon_chakan"><a href="#" onclick=update(' + row.ID+ ') title="删除"></a></span>';
		return str;
	}
	var GridList = $UI.datagrid('#tabDrugList', {
		url : $URL,
		queryParams : {
			ClassName : 'web.CSSDHUI.Clean.CleanInfo',
			QueryName : 'SelectAllCleanCheck',
			Params : Params
		},
		columns : Cm,
		toolbar : "#UomTB",
		lazy : false,
		onLoadSuccess : function(data) {
			$(".icon_Modify").linkbutton({text : '',plain : true,iconCls : 'icon-cancel'});
			if (data.rows.length > 0&&isEmpty(GridListIndex)) {
				$('#tabDrugList').datagrid("selectRow", 0);
				FindItemByF(data.rows[0].ID);
			}
			if(!isEmpty(GridListIndex)){
				$('#tabDrugList').datagrid("selectRow", GridListIndex);
				FindItemByF(GridListIndexId);
			}
		},
		onClickCell : function(index, filed, value) {
			var Row = GridList.getRows()[index]
			var Id = Row.ID;
			if (!isEmpty(Id)) {
				FindItemByF(Id);
			}
			GridList.commonClickCell(index, filed)
		}
	})

	function FindItemByF(Id) {
		ItemListGrid.load({
			ClassName : 'web.CSSDHUI.Clean.CleanInfo',
			QueryName : 'SelectCleanDetail',
			Params : Id
		});
	}

	function setDafult() {
		var Dafult = {
			FStartDate : DefaultStDate(),
			FEndDate : DefaultEdDate()
		}
		$UI.fillBlock('#cleantable', Dafult);
	}
}

$(init);