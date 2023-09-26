/**
 * ģ��:     ���ָ�깫ʽά��
 * ��д����: 2017-12-18
 * ��д��:   yunhaibao
 * ˵����	 ͨ�ù�ʽ-��עΪϵͳ��ʽ�Ĵ���̶�,ҵ����򰴴���ȡֵ
 */
var HospId=session["LOGON.HOSPID"];
$(function() {
    InitDict();
    InitGridIngIndex();
    InitGridIngIndItm();
    $("#btnAdd").on('click', function() {
        $('#gridIngIndItm').datagrid('clear');
        $("#gridIngIndex").datagrid('addNewRow', { editField: 'ingIndexDesc' });
    });
    $("#btnSave").on('click', SaveIngIndex);
    $("#btnDelete").on('click', DeleteIngIndex);
    $("#btnAddItm").on('click', function() {
        MainTainItm("A");
    });
    $("#btnUpdateItm").on('click', function() {
        MainTainItm("U");
    });
    $("#btnDeleteItm").on('click', function() {
        DeleteIngIndItm();
    });
    $("#cacuTable a").on("click", function() {
        $("#txtIngIndItmFormula").val($("#txtIngIndItmFormula").val() + this.text)
    });
    $("#IngredientButtons a").on("click", function() {
        $("#txtIngIndItmFormula").val($("#txtIngIndItmFormula").val() + this.text)
    });
	$('.dhcpha-win-mask').remove();
})

function InitDict() {
    PIVAS.Html.IngredientButtons({ Id: 'IngredientButtons',HospId:HospId });
}

function InitGridIngIndex() {
    var columns = [
        [
            { field: "ingIndexId", title: 'ָ��Id', width: 50, hidden: true },
            { field: "ingIndexCode", title: 'ָ�����', width: 100, hidden: true },
            {
                field: "ingIndexDesc",
                title: 'ָ������',
                width: 350,
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
            ClassName: 'web.DHCSTPIVAS.Formula',
            QueryName: 'PHCDrgIngredIndex'
        },
        columns: columns,
        toolbar: "#gridIngIndexBar",
        pagination: false,
        fitColumns: true,
        onClickRow: function(rowIndex, rowData) {
            $(this).datagrid('endEditing');
            if ($(this).datagrid('options').editIndex == undefined) {
                $('#gridIngIndItm').datagrid('query', {
                    inputStr: rowData.ingIndexId || ""
                });
            }
        },
        onDblClickRow: function(rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'ingIndexDesc'
            });
            if (rowData.ingIndexDesc=="������"){
	        	$(this).datagrid('endEditing');
	        }
        },
        onLoadSuccess: function() {
            $("#gridIngIndItm").datagrid("clear");
        },
    	onBeforeLoad: function(param){
			param.HospId = HospId
		}
    };
    DHCPHA_HUI_COM.Grid.Init("gridIngIndex", dataGridOption);
}

function InitGridIngIndItm() {
    var columns = [
        [
            { field: "ingIndItmId", title: 'ָ����ϸId', width: 50, hidden: true },
            { field: "ingIndItmCode", title: '����', width: 50 },
            { field: "ingIndItmDesc", title: '����', width: 150 },
            { field: "ingIndItmFormula", title: '��ʽ', width: 400 },
            { field: "ingIndItmMin", title: '����', width: 80 },
            { field: "ingIndItmMax", title: '����', width: 80 },
            { field: "ingIndItmUom", title: '��λ', width: 80 },
            { field: "ingIndItmRemark", title: '��ע', width: 150 }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.Formula',
            QueryName: 'PHCDrgIngrIndItm',
            inputStr: ""
        },
        nowrap:false,
        columns: columns,
        //fitColumns: true,
        toolbar: "#gridIngIndItmBar",
        pagination: false,
        onClickRow: function(rowIndex, rowData) {
            if (rowData) {}
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridIngIndItm", dataGridOption);
}

function MainTainItm(type) {
    var gridSelect = $('#gridIngIndItm').datagrid('getSelected');
    var indexGridSelect = $('#gridIngIndex').datagrid('getSelected');
    if (type == "U") {
        if (gridSelect == null) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: "����ѡ����Ҫ�޸ĵļ�¼",
                type: 'alert'
            });
            return;
        }
        $("#txtIngIndItmDesc").val(gridSelect.ingIndItmDesc);
        $("#txtIngIndItmMax").val(gridSelect.ingIndItmMax);
        $("#txtIngIndItmMin").val(gridSelect.ingIndItmMin);
        $("#txtIngIndItmUom").val(gridSelect.ingIndItmUom);
        $("#txtIngIndItmFormula").val(gridSelect.ingIndItmFormula);
        $("#txtIngIndItmRemark").val(gridSelect.ingIndItmRemark);
        $("#txtIngIndItmCode").val(gridSelect.ingIndItmCode);
    } else if (type = "A") {
        if (indexGridSelect == null) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: "����ѡ����Ҫ������ҩѧ�ɷ�ָ��",
                type: 'alert'
            });
            return;
        }
        $("#gridIngIndItmWin input").val("");
        $("#gridIngIndItmWin textarea").val("");
    }
    $('#gridIngIndItmWin').window({ 
    	'title': "ҩѧ�ɷ�ָ�깫ʽ" + ((type == "A") ? "����" : "�޸�") ,
    	'iconCls':(type=="A")?"icon-w-add":"icon-w-edit"
    })
    $('#gridIngIndItmWin').window('open');  
    if (type=="U"){
		if (gridSelect.ingIndItmRemark=="ϵͳ��ʽ"){
			$("#txtIngIndItmCode,#txtIngIndItmDesc,#txtIngIndItmRemark").attr("readonly",true);
		
		}else{
			$("#txtIngIndItmCode,#txtIngIndItmDesc,#txtIngIndItmRemark").attr("readonly",false);
		}
    }else{
		$("#txtIngIndItmCode,#txtIngIndItmDesc,#txtIngIndItmRemark").attr("readonly",false);
	}
}

// ����ָ��
function SaveIngIndex() {
    $('#gridIngIndex').datagrid('endEditing');
    var gridChanges = $('#gridIngIndex').datagrid('getChanges')
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "û����Ҫ���������",
            type: 'alert'
        });
        return;
    }
    var paramsStr = "";
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var params = (iData.ingIndexId || "") + "^" + (iData.ingIndexDesc || "");
        paramsStr = (paramsStr == "") ? params : paramsStr + "!!" + params;
    }
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.Formula", "Save", paramsStr, HospId);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("��ʾ", saveInfo, "warning");
    }
    $('#gridIngIndex').datagrid('query', {});
}

function DeleteIngIndex() {
    var gridSelect = $('#gridIngIndex').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "����ѡ����Ҫɾ���ļ�¼",
            type: 'alert'
        });
        return;
    }
    if (gridSelect.ingIndexDesc=="������"){
        DHCPHA_HUI_COM.Msg.popover({
            msg: "ϵͳ��ʽ�����޷�ɾ��",
            type: 'alert'
        });
        return;
    }
    var ingIndexId = gridSelect.ingIndexId || "";
    $.messager.confirm('ȷ�϶Ի���', 'ɾ������ϸ��ʽ��ȫ����ʧ</br>��ȷ��ɾ����', function(r) {
        if (r) {
            if (ingIndexId == "") {
                var rowIndex = $('#gridIngIndex').datagrid('getRowIndex', gridSelect);
                $('#gridIngIndex').datagrid("deleteRow", rowIndex);
            } else {
                var ret = tkMakeServerCall("web.DHCSTPIVAS.Formula", "DeletePHCDrgIngredIndex", gridSelect.ingIndexId, HospId);
                $('#gridIngIndex').datagrid('query', {});
            }
        }
    });

}

// ����ָ����ϸ
function SaveIngIndItm() {
    var winTitle = $("#gridIngIndItmWin").panel('options').title;
    var gridSelect = $('#gridIngIndItm').datagrid('getSelected');
    var ingIndGridSelect = $('#gridIngIndex').datagrid('getSelected');
    var ingInexId = ingIndGridSelect.ingIndexId;
    var ingIndItmId = "";
    if (winTitle.indexOf("����") >= 0) {} else {
        ingIndItmId = gridSelect.ingIndItmId;
    }
    var ingIndItmDesc = $("#txtIngIndItmDesc").val().trim();
    var ingIndItmMax = $("#txtIngIndItmMax").val().trim();
    var ingIndItmMin = $("#txtIngIndItmMin").val().trim();
    var ingIndItmUom = $("#txtIngIndItmUom").val().trim();
    var ingIndItmFormula = $("#txtIngIndItmFormula").val().trim();
    var ingIndItmCode = $("#txtIngIndItmCode").val().trim();
    var ingIndItmRemark = $("#txtIngIndItmRemark").val().trim();
    if (ingIndItmDesc == "") {
        $.messager.alert("��ʾ", "��¼������", "warning");
        return;
    }
    if (ingIndItmFormula == "") {
        $.messager.alert("��ʾ", "��¼�빫ʽ", "warning");
        return;
    }
    if (ingIndItmCode==""){
        $.messager.alert("��ʾ", "��¼�����,���뽫���ڼ���������", "warning");
        return;	
	}
	if ((ingIndItmMin!="")&&(ingIndItmMax!="")){
		if ((ingIndItmMin*1000)>(ingIndItmMax*1000)){
	        $.messager.alert("��ʾ", "���޸�������", "warning");
        	return;		
		}
	}
    var params = ingInexId + "^" + ingIndItmId + "^" + ingIndItmDesc + "^" + ingIndItmMax + "^" + ingIndItmMin + "^" + ingIndItmUom + "^" + ingIndItmFormula + "^" + ingIndItmCode + "^" + ingIndItmRemark;
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.Formula", "SavePHCDrgIngIndItm", params);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("��ʾ", saveInfo, "warning");
        return;
    }
    $('#gridIngIndItmWin').window('close');
    $('#gridIngIndItm').datagrid('reload');
}

function DeleteIngIndItm() {
    var gridSelect = $('#gridIngIndItm').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "����ѡ����Ҫɾ���ļ�¼",
            type: 'alert'
        });
        return;
    }
    if (gridSelect.ingIndItmRemark=="ϵͳ��ʽ"){
	    DHCPHA_HUI_COM.Msg.popover({
            msg: "ϵͳ��ʽ�����޷�ɾ���������޸ľ��幫ʽ",
            type: 'alert'
        });
        return;	
	}
    $.messager.confirm('ȷ�϶Ի���', '��ȷ��ɾ����', function(r) {
        if (r) {
		    var ret = tkMakeServerCall("web.DHCSTPIVAS.Formula", "DeletePHCDrgIngIndItm", gridSelect.ingIndItmId);
		    $('#gridIngIndItm').datagrid('reload');
        }
    });
}

function InitHospCombo(){
	var genHospObj=PIVAS.AddHospCom({});
	if (typeof genHospObj ==='object'){
		//����ѡ���¼�
		$('#_HospList').combogrid("options").onSelect=function(index,record){		
			var newHospId=record.HOSPRowId;		
			if(newHospId!=HospId){
				HospId=newHospId;
				PIVAS.Html.IngredientButtons({ Id: 'IngredientButtons',HospId:HospId });
				$("#IngredientButtons a").off("click").on("click", function() {
			        $("#txtIngIndItmFormula").val($("#txtIngIndItmFormula").val() + this.text)
			    });
				$('#gridIngIndex').datagrid('load');
			}
		};
	}
}