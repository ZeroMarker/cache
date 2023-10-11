/**
 * ����:	 ��������-���ϸ�ҩʦ����ά��
 * ��д��:	 dinghongying
 * ��д����: 2019-05-06
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

// �¼�
function InitEvents() {
	$("#btnAdd").on("click", AddAdvice);
	$("#btnSave").on("click", SaveAdvice);
	$("#btnClear").on("click", ClearAdvice);
}


// ���-ҩʦ����
function InitGridAdvice() {
    var columns = [
        [
            { field: "advId", title: 'advId', width: 100,hidden: true },
            {
                field: 'advDesc',
                title: '����',
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
			msg: "����д���ϸ�ҩʦ�������ݺ��ٱ��棡",
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
		PHA.Alert('��ʾ', saveInfo, 'warning');
		return;
	} else {
		PHA.Popover({
			msg: '����ɹ�',
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
			msg: "û����Ҫ���������",
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
				msg: "����дҩʦ�������ݺ��ٱ��棡",
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
		PHA.Alert('��ʾ', saveInfo, 'warning');
		ClearAdvice();
		return;
	} else {
		PHA.Alert('��ʾ', "����ɹ�", 'success');
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


