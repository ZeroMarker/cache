/**
 * 名称:	 处方点评-不合格药师建议维护
 * 编写人:	 dinghongying
 * 编写日期: 2019-05-06
 */
PHA_COM.App.Csp = "pha.prc.v2.config.advice.csp";
PHA_COM.App.Name = "PRC.Config.Advice";
PHA_COM.App.Load = "";
var hospID = PHA_COM.Session.HOSPID;
$(function () {
	InitGridAdvice();
	InitEvents();
	InitHospCombo();
});

// 事件
function InitEvents() {
	$("#btnAdd").on("click", AddAdvice);
	$("#btnSave").on("click", SaveAdvice);
	$("#btnClear").on("click", ClearAdvice);
}


// 表格-药师建议
function InitGridAdvice() {
    var columns = [
        [
            { field: "advId", title: 'advId', width: 100,hidden: true },
            {
                field: 'advDesc',
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
            ClassName: 'PHA.PRC.ConFig.Advice',
            QueryName: 'SelectAdvice',
            hospID: hospID
        },
        columns: columns,
        toolbar: "#gridAdviceBar",
        onClickRow: function(rowIndex, rowData) {		
			$('#gridAdvice').datagrid('beginEditRow', {
				rowIndex: rowIndex
			});
        }
    };
	PHA.Grid("gridAdvice", dataGridOption);
}

function AddAdvice(){
	$("#gridAdvice").datagrid('addNewRow', {});
	
	/*
	var advDesc=$("#conAlias").val();
	var advDesc = advDesc.replace(/\s+/g,"");
	if (advDesc == "") {
		PHA.Popover({
			msg: "请填写不合格药师建议内容后再保存！",
			type: "alert",
			timeout: 3000
		});
		return;
	}
	var saveRet = $.cm({
		ClassName: 'PHA.PRC.ConFig.Advice',
		MethodName: 'SaveComAdvice',
		AdviceId: '',
		AdviceDesc: advDesc,
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
		ClearAdvice();
	}
	*/
}
function SaveAdvice(){
	$('#gridAdvice').datagrid('endEditing');
	var gridChanges = $('#gridAdvice').datagrid('getChanges');
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
		var advDesc = $.trim(iData.advDesc || "")
		var advDesc = advDesc.replace(/\s+/g,"");
		if (advDesc == "") {
			PHA.Popover({
				msg: "请填写药师建议内容后再保存！",
				type: "alert",
				timeout: 3000
			});
			return;
		}
		var params = $.trim(iData.advId || "") + "^" + $.trim(iData.advDesc || "");
		inputStrArr.push(params)

	}
	//alert("inputStrArr:"+inputStrArr)
	var inputStr = inputStrArr.join("!!");	
	var saveRet = $.cm({
		ClassName: 'PHA.PRC.ConFig.Advice',
		MethodName: 'SaveComAdvice',
		inputStr: inputStr,
		hospID: hospID,
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('提示', saveInfo, 'warning');
		ClearAdvice();
		return;
	} else {
		PHA.Alert('提示', "保存成功", 'success');
		ClearAdvice();
	}
	
}

function ClearAdvice(){
	$("#gridAdvice").datagrid("query");
	
}

function InitHospCombo() {
	var genHospObj = GenHospComp('DHC_PHCNTSADVICE');
	if (typeof genHospObj ==='object'){
        genHospObj.options().onSelect =  function(index, record) {	
        	hospID = record.HOSPRowId;
            $('#gridAdvice').datagrid('query', {hospID: hospID}); 
        }
    }
}


