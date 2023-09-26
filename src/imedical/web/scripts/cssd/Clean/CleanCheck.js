function deleteItem(rowId) {
	if (isEmpty(rowId)) {
		$UI.msg('alert', '��ѡ��Ҫɾ���ĵ���!');
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
	// ��ϴ��ʽ
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
						$UI.msg('alert', '�������ϴ��ʽ!');
						$("#cleantype").val("");
						$('#cleantype').focus();
						return;
					}
				})
			}
		}
	});
	//���ϸ�ԭ��������
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
	// ��ϴ����
	$("#cleanmachine").keydown(function(e) {
		var curKey = e.which;
		if (curKey == 13) {
			if ($("#cleanmachine").val() != "") {
				$('#cleanCode').focus();
			}
		}
	});
	// ��ϴ��
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
						$UI.msg('alert', '�������ϴ�ܺ�!');
						$("#cleanCode").val("");
						$('#cleanCode').focus();
						return;
					}
				})
			}
		}
	});
	// ��ϴ����
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
						$UI.msg('alert', '�������ϴ����!');
						$("#cleanStro").val("");
						$('#cleanStro').focus();
						return;
					}
				})
			}
		}
	});
	// ��ϴ�˻س�
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
						$UI.msg('alert', '�������ϴ��!');
						$("#cleaner").val("");
						$('#cleaner').focus();
						return;
					}
				})
			}
		}
	});
	// ȷ����
	$("#cleanadd").keydown(function(e) {
		var curKey = e.which;
		if (curKey == 13) {
			if ($("#cleanadd").val() == "0000000000") {
				$('#add').click();
			}
		}
	});
	// ������ϴ����
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

	// ����
	$UI.linkbutton('#check', {
		onClick : function() {
			var Rows = GridList.getSelected();
			if (isEmpty(Rows)) {
				$UI.msg("alert", "��ѡ����Ҫ���յļ�¼!");
				return;
			}
			GridListIndex = GridList.getRowIndex(Rows);
			GridListIndexId = Rows.ID;
			var FReqLocParams = JSON.stringify(addSessionParams({
				ID : Rows.ID
			}));
			if (Rows.IsResult) {
				$UI.msg("alert", "�Ѿ��������ݲ����ظ�����");
				return;
			}
			if (ItemListGrid.getRows() == "") {
				$UI.msg("alert", "û����ϸ���ܽ�������");
				return;
			}
			$.messager.confirm("������ʾ","��ȷ��Ҫִ�в�����",function(data){
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
	// ���ղ��ϸ�
	$UI.linkbutton('#checknpass', {
		onClick : function() {
			var Rows = GridList.getSelected();
			if (isEmpty(Rows)) {
				$UI.msg("alert", "��ѡ����Ҫ���յļ�¼!");
				return;
			}
			GridListIndex = GridList.getRowIndex(Rows);
			GridListIndexId = Rows.ID;
			var FReqLocParams = JSON.stringify(addSessionParams({ID:Rows.ID}));
			if (Rows.IsResult) {
				$UI.msg("alert", "�Ѿ��������ݲ����ظ�����");
				return;
			}
			$.messager.confirm("������ʾ","��ȷ��Ҫִ�в�����",function(data){
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
	
	//������ϸ���ղ��ϸ�
	$UI.linkbutton('#CheckFailBT',{ 
		onClick:function(){
			var MainRow=GridList.getSelected();
			if(!isEmpty(MainRow.IsResult)){
				$UI.msg('alert',"�ù�������,�޷��ظ�����");
				return;
			}
			var Detail=ItemListGrid.getChecked();
			if(isEmpty(Detail)){
				$UI.msg('alert',"��ѡ�񲻺ϸ�������ϸ");
				return;
			}
			var ReasonDr=$("#UnqualifiedReason").combobox('getValue')
			if(isEmpty(ReasonDr)){
				$UI.msg('alert',"��ѡ�񲻺ϸ�ԭ��");
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
	
	// ��ѯ
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
	// ɨ����ӹ̶���ǩ
	$("#BarCode").keypress(function(event) {
		if (event.which == 13) {
			var v = $("#BarCode").val();
			var row = $('#MainList').datagrid('getSelected');
			if (isEmpty(row)) {
				$UI.msg('alert', '��ѡ����Ҫ��ӵĹ���!');
				return;
			}
			if (isEmpty(row.RowId)) {
				$UI.msg('alert', '��������!');
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
		title : '���뵥',
		field : 'ApplyNo',
		fitColumns:true,
		width : 100
	}, {
		title : '����',
		field : 'LocName',
		fitColumns:true,
		width : 100
	}, {
		title : '����������',
		field : 'packagedesc',
		fitColumns:true,
		width : 140
	}, {
		title : '�����Ʊ���',
		field : 'CodeLabel',
		fitColumns:true,
		width : 100
	}, {
		title : '����',
		field : 'qty',
		align : 'right',
		width : 70,
		fitColumns:true
	}, {
		title: '�Ƿ�����',
		field: 'IsResult',
		width: 100,
		fitColumns:true,
		hidden: true
	}, {
		title: '���ϸ�ԭ��',
		field: 'ReasonDr',
		width:179,
		formatter: CommonFormatter(ReasonCombox, 'ReasonDr', 'ReasonName'),
		editor: ReasonCombox,
		fitColumns:true
	}
	]];
	// �ұ���ϸ
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
				title : '���ձ��',
				field : 'IsResult',
				width : 70,
				align : 'center',
				styler : flagColor,
				formatter : function(value) {
					var status = "";
					if (value == "1") {
						status = "�ϸ�";
					} else if (value == "0") {
						status = "���ϸ�"
					} else {
						status = "δ����";
					}
					return status;
				}
			}, {
				title : 'ID',
				field : 'ID',
				hidden : true
			}, {
				title : '������',
				field : 'MachineNo',
				align : 'right',
				width : 60
			}, {
				title : '����',
				field : 'CleanDate',
				width : 100
			}, {
				title : 'ʱ��',
				field : 'CleanTime',
				width : 70
			}, {
				title : '��ϴ��',
				field : 'CleanerName',
				width : 100
			}, {
				title: '��ϴ����',
				field: 'CleanNo1',
				width: 150

			},{
				title : '������',
				field : 'ChkerName',
				width : 100
			}, {
				title : '����ʱ��',
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
		str += '<span class="icon_Modify"><a href="#" onclick=update(' + row.ID+ ') id="del"  title="�޸�"></a></span>';
		str += '<span class="icon_chakan"><a href="#" onclick=update(' + row.ID+ ') title="ɾ��"></a></span>';
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