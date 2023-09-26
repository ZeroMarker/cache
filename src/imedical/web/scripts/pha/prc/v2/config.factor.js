/**
 * ����:	 ��������-������ʾֵά��
 * ��д��:	 DingHongying
 * ��д����: 2019-05-06
 */
PHA_COM.App.Csp = "pha.prc.v2.config.factor.csp";
PHA_COM.App.Name = "PRC.Config.Factor";
PHA_COM.App.Load = "";
$(function () {
	InitGridFactor();
	InitEvents();
});

// �¼�
function InitEvents() {
	$("#btnAdd").on("click", AddFactor);
	$("#btnSave").on("click", SaveFactor);
	$("#btnClear").on("click", ClearFactor);
}


// ���-������
function InitGridFactor() {
    var columns = [
        [
            { field: "facId", title: 'facId', width: 100,hidden: true },
            {
                field: 'facDesc',
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

// ������ʾֵ
function AddFactor() {	

	$("#gridFactor").datagrid('addNewRow', {});

	/*
	var facDesc=$("#conAlias").val();
	var facDesc = facDesc.replace(/\s+/g,"");
	if (facDesc == "") {
		PHA.Popover({
			msg: "����д���ϸ�ʾֵ���ݺ��ٱ��棡",
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
		PHA.Alert('��ʾ', saveInfo, 'warning');
		return;
	} else {
		PHA.Popover({
			msg: '����ɹ�',
			type: 'success'
		});
		ClearFactor();
	}
	*/
}

// �༭��ʾֵ(����)
function SaveFactor() {
	
	$('#gridFactor').datagrid('endEditing');
	var gridChanges = $('#gridFactor').datagrid('getChanges');
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
		var facDesc = $.trim(iData.facDesc || "")
		var facDesc = facDesc.replace(/\s+/g,"");
		if (facDesc == "") {
			PHA.Popover({
				msg: "����д���ϸ�ʾֵ���ݺ��ٱ��棡",
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
		PHA.Alert('��ʾ', saveInfo, 'warning');
		ClearFactor();
		return;
	} else {
		PHA.Popover({
			msg: '����ɹ�',
			type: 'success'
		});
		ClearFactor();
	}
}

function ClearFactor(){
	$("#gridFactor").datagrid("query");	
}







