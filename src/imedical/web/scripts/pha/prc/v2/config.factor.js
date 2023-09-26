/**
 * 名称:	 处方点评-不合理警示值维护
 * 编写人:	 DingHongying
 * 编写日期: 2019-05-06
 */
PHA_COM.App.Csp = "pha.prc.v2.config.factor.csp";
PHA_COM.App.Name = "PRC.Config.Factor";
PHA_COM.App.Load = "";
$(function () {
	InitGridFactor();
	InitEvents();
});

// 事件
function InitEvents() {
	$("#btnAdd").on("click", AddFactor);
	$("#btnSave").on("click", SaveFactor);
	$("#btnClear").on("click", ClearFactor);
}


// 表格-科室组
function InitGridFactor() {
    var columns = [
        [
            { field: "facId", title: 'facId', width: 100,hidden: true },
            {
                field: 'facDesc',
                title: '描述',
                width: 225,
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
            ClassName: 'PHA.PRC.ConFig.Factor',
            QueryName: 'SelectFactor'
        },
        columns: columns,
        toolbar: "#gridFactorBar",
        onClickRow: function(rowIndex, rowData) {		
			$('#gridFactor').datagrid('beginEditRow', {
				rowIndex: rowIndex
			});
        }
    };
	PHA.Grid("gridFactor", dataGridOption);
}

// 新增警示值
function AddFactor() {	

	$("#gridFactor").datagrid('addNewRow', {});

	/*
	var facDesc=$("#conAlias").val();
	var facDesc = facDesc.replace(/\s+/g,"");
	if (facDesc == "") {
		PHA.Popover({
			msg: "请填写不合格警示值内容后再保存！",
			type: "alert",
			timeout: 3000
		});
		return;
	}
	var saveRet = $.cm({
		ClassName: 'PHA.PRC.ConFig.Factor',
		MethodName: 'SaveComFactor',
		FactorId: '',
		FactorDesc: facDesc,
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('提示', saveInfo, 'warning');
		return;
	} else {
		PHA.Popover({
			msg: '保存成功',
			type: 'success'
		});
		ClearFactor();
	}
	*/
}

// 编辑警示值(保存)
function SaveFactor() {
	
	$('#gridFactor').datagrid('endEditing');
	var gridChanges = $('#gridFactor').datagrid('getChanges');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		PHA.Popover({
			msg: "没有需要保存的数据",
			type: 'alert'
		});
		return;
	}
	var inputStrArr = [];
	for (var i = 0; i < gridChangeLen; i++) {
		var iData = gridChanges[i];
		var facDesc = $.trim(iData.facDesc || "")
		var facDesc = facDesc.replace(/\s+/g,"");
		if (facDesc == "") {
			PHA.Popover({
				msg: "请填写不合格警示值内容后再保存！",
				type: "alert",
				timeout: 3000
			});
			return;
		}
		var params = $.trim(iData.facId || "") + "^" + $.trim(iData.facDesc || "");
		inputStrArr.push(params)

	}
	//alert("inputStrArr:"+inputStrArr)
	var inputStr = inputStrArr.join("!!");	
	var saveRet = $.cm({
		ClassName: 'PHA.PRC.ConFig.Factor',
		MethodName: 'SaveComFactor',
		inputStr: inputStr,
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('提示', saveInfo, 'warning');
		ClearFactor();
		return;
	} else {
		PHA.Popover({
			msg: '保存成功',
			type: 'success'
		});
		ClearFactor();
	}
}

function ClearFactor(){
	$("#gridFactor").datagrid("query");	
}







