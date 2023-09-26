/**
 * 名称:	 处方点评-点评原因维护
 * 编写人:	 dinghongying
 * 编写日期: 2019-05-07
 */
PHA_COM.App.Csp = "pha.prc.v2.config.reason.csp";
PHA_COM.App.Name = "PRC.Config.Reason";
PHA_COM.App.Load = "";
PHA_STORE.Tree = function () {
	return {
		url: PHA_STORE.Url + "ClassName=web.PHA.PRC.Reason&MethodName=JsGetReasonTree"
	}
}
$(function () {
	InitDict();
	InitEvents();
	InitTreeGridReason(); 
    InitGridReason();
});

// 字典
function InitDict() {
	// 初始化方式
	PHA.ComboBox("conWay", {
		url: PRC_STORE.PCNTSWay("","").url ,
		onSelect: function (data) {
			Clear();
			InitTreeGridReason();			
		}
	});	
	
}

// 事件
function InitEvents() {
	$("#btnAdd").on("click", AddReason);
	$("#btnEdit").on("click", EditReason);
	$("#btnDel").on("click", ComfirmDel);

}

function InitTreeGridReason() {
	var loadWayId = $("#conWay").combobox('getValue')||''; 
	PHA.Tree("treeGridReason",{
		lines: false,
		onClick: function (node) {			 
			$("#conLevel").val(node.id)
			Clear();
			$("#gridReason").datagrid("query", {
				wayId: loadWayId ,
				reaLevel: node.id
			});			
		}
	})
	$.cm({
		ClassName: 'PHA.PRC.ConFig.Reason',
		MethodName: 'GetPRCReasonTree',
		wayId: loadWayId , 
	},function(data){
		$('#treeGridReason').tree({
			data: data
		});
	});

}

function InitGridReason() {
    var columns = [
        [
            { field: "reasonId", title: '点评原因Id', width: 100, hidden: true },
            {
                field: 'reasonCode',
                title: '原因代码',
                width: 20,
                sortable: 'true',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },
            {
                field: 'reasonDesc',
                title: '原因描述',
                width: 70,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.ConFig.Reason',
            QueryName: 'SelectReason',
			wayId: '',
			reaLevel: ''
        },
        columns: columns,
        pagination: true,
        fitColumns: true,
        nowrap: false,
        toolbar: "#gridReasonBar",
        onClickRow: function(rowIndex, rowData) {
	        var code = rowData.reasonCode ;
			var desc = rowData.reasonDesc ;
			var reaId = rowData.reasonId ;
			$("#conCode").val(code);
			$("#conDesc").val(desc);
        }
    };
    PHA.Grid("gridReason", dataGridOption);
}


function AddReason(){
	var reaCode=$("#conCode").val();
	var reaDesc=$("#conDesc").val();
	if ((reaCode=="")||(reaDesc == "")) {
		PHA.Popover({
			msg: "请填写点评原因代码和描述后再保存！",
			type: "alert",
			timeout: 3000
		});
		return;
	}
	var loadWayId = $("#conWay").combobox('getValue')||''; 
	var reaLevel = $("#conLevel").val();
	
	var DataStr = reaCode + "^" + reaDesc + "^" + reaLevel + "^" + loadWayId
	var saveRet = $.cm({
		ClassName: 'PHA.PRC.ConFig.Reason',
		MethodName: 'SaveComReason',
		ReasonID: '',
		DataStr: DataStr,
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('提示', saveInfo, 'warning');
		return;
	} else {
		PHA.Alert('提示',"增加成功", 'success');
		Clear();
	}
}
function EditReason(){
	var gridSelect = $('#gridReason').datagrid('getSelected') || "";
		if (gridSelect == "") {
			PHA.Popover({
				msg: "请选择需要修改的点评原因",
				type: "alert"
			});
			return;
		}
	var reaCode=$("#conCode").val();
	var reaDesc=$("#conDesc").val();
	if ((reaCode=="")||(reaDesc == "")) {
		PHA.Popover({
			msg: "请填写点评原因代码和描述后再保存！",
			type: "alert",
			timeout: 3000
		});
		return;
	}
	var reasonId = gridSelect.reasonId ;	
	var loadWayId = $("#conWay").combobox('getValue')||''; 
	var reaLevel = $("#conLevel").val();
	
	var DataStr = reaCode + "^" + reaDesc + "^" + reaLevel + "^" + loadWayId
	var saveRet = $.cm({
		ClassName: 'PHA.PRC.ConFig.Reason',
		MethodName: 'SaveComReason',
		ReasonID: reasonId,
		DataStr: DataStr,
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('提示', saveInfo, 'warning');
		return;
	} else {
		PHA.Alert('提示',"修改成功", 'success');
		Clear();
		
	}
}

function ComfirmDel(){
	var delInfo = "您确认删除吗?"
	PHA.Confirm("删除提示", delInfo, function () {
		deleteReason();
	})
}

//删除点评药师
function deleteReason(){
	var gridSelect = $('#gridReason').datagrid('getSelected') || "";
	if (gridSelect == "") {
		PHA.Popover({
			msg: "请先选中需要删除的点评原因",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var reasonId = gridSelect.reasonId ;
	var reaLevel = $("#conLevel").val();
	var loadWayId = $("#conWay").combobox('getValue')||'';
	
	var DataStr = reasonId + "^" + reaLevel + "^" + loadWayId
	var saveRet = $.cm({
		ClassName: 'PHA.PRC.ConFig.Reason',
		MethodName: 'DelComReason',
		DataStr: DataStr,
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('提示', saveInfo, 'warning');
		return;
	} else {
		PHA.Alert('提示',"删除成功", 'success');
		Clear();
		//$('#gridReason').datagrid("reload");
	}
	
}

function Clear(){
	//$("#gridReason").datagrid("clear");
	//$('#gridReason').datagrid("reload");
	//$('#treeGridReason').tree("reload");
	var loadWayId = $("#conWay").combobox('getValue')||'';
	var reasonLevel = $("#conLevel").val();
	$("#gridReason").datagrid("query", {
		wayId: loadWayId ,
		reaLevel: reasonLevel
	});	
	$("#conCode").val('');
	$("#conDesc").val('');
	
	
}





