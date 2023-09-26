/**
 * 模块:     审核指标公式维护
 * 编写日期: 2017-12-18
 * 编写人:   yunhaibao
 * 说明：	 通用公式-备注为系统公式的代码固定,业务程序按代码取值
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
            { field: "ingIndexId", title: '指标Id', width: 50, hidden: true },
            { field: "ingIndexCode", title: '指标代码', width: 100, hidden: true },
            {
                field: "ingIndexDesc",
                title: '指标名称',
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
            if (rowData.ingIndexDesc=="体表面积"){
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
            { field: "ingIndItmId", title: '指标明细Id', width: 50, hidden: true },
            { field: "ingIndItmCode", title: '代码', width: 50 },
            { field: "ingIndItmDesc", title: '名称', width: 150 },
            { field: "ingIndItmFormula", title: '公式', width: 400 },
            { field: "ingIndItmMin", title: '下限', width: 80 },
            { field: "ingIndItmMax", title: '上限', width: 80 },
            { field: "ingIndItmUom", title: '单位', width: 80 },
            { field: "ingIndItmRemark", title: '备注', width: 150 }
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
                msg: "请先选中需要修改的记录",
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
                msg: "请先选中需要新增的药学成分指标",
                type: 'alert'
            });
            return;
        }
        $("#gridIngIndItmWin input").val("");
        $("#gridIngIndItmWin textarea").val("");
    }
    $('#gridIngIndItmWin').window({ 
    	'title': "药学成分指标公式" + ((type == "A") ? "新增" : "修改") ,
    	'iconCls':(type=="A")?"icon-w-add":"icon-w-edit"
    })
    $('#gridIngIndItmWin').window('open');  
    if (type=="U"){
		if (gridSelect.ingIndItmRemark=="系统公式"){
			$("#txtIngIndItmCode,#txtIngIndItmDesc,#txtIngIndItmRemark").attr("readonly",true);
		
		}else{
			$("#txtIngIndItmCode,#txtIngIndItmDesc,#txtIngIndItmRemark").attr("readonly",false);
		}
    }else{
		$("#txtIngIndItmCode,#txtIngIndItmDesc,#txtIngIndItmRemark").attr("readonly",false);
	}
}

// 保存指标
function SaveIngIndex() {
    $('#gridIngIndex').datagrid('endEditing');
    var gridChanges = $('#gridIngIndex').datagrid('getChanges')
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "没有需要保存的数据",
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
        $.messager.alert("提示", saveInfo, "warning");
    }
    $('#gridIngIndex').datagrid('query', {});
}

function DeleteIngIndex() {
    var gridSelect = $('#gridIngIndex').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "请先选中需要删除的记录",
            type: 'alert'
        });
        return;
    }
    if (gridSelect.ingIndexDesc=="体表面积"){
        DHCPHA_HUI_COM.Msg.popover({
            msg: "系统公式，您无法删除",
            type: 'alert'
        });
        return;
    }
    var ingIndexId = gridSelect.ingIndexId || "";
    $.messager.confirm('确认对话框', '删除后明细公式将全部消失</br>您确定删除吗？', function(r) {
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

// 保存指标明细
function SaveIngIndItm() {
    var winTitle = $("#gridIngIndItmWin").panel('options').title;
    var gridSelect = $('#gridIngIndItm').datagrid('getSelected');
    var ingIndGridSelect = $('#gridIngIndex').datagrid('getSelected');
    var ingInexId = ingIndGridSelect.ingIndexId;
    var ingIndItmId = "";
    if (winTitle.indexOf("新增") >= 0) {} else {
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
        $.messager.alert("提示", "请录入名称", "warning");
        return;
    }
    if (ingIndItmFormula == "") {
        $.messager.alert("提示", "请录入公式", "warning");
        return;
    }
    if (ingIndItmCode==""){
        $.messager.alert("提示", "请录入代码,代码将用于计算结果排序", "warning");
        return;	
	}
	if ((ingIndItmMin!="")&&(ingIndItmMax!="")){
		if ((ingIndItmMin*1000)>(ingIndItmMax*1000)){
	        $.messager.alert("提示", "下限高于上限", "warning");
        	return;		
		}
	}
    var params = ingInexId + "^" + ingIndItmId + "^" + ingIndItmDesc + "^" + ingIndItmMax + "^" + ingIndItmMin + "^" + ingIndItmUom + "^" + ingIndItmFormula + "^" + ingIndItmCode + "^" + ingIndItmRemark;
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.Formula", "SavePHCDrgIngIndItm", params);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("提示", saveInfo, "warning");
        return;
    }
    $('#gridIngIndItmWin').window('close');
    $('#gridIngIndItm').datagrid('reload');
}

function DeleteIngIndItm() {
    var gridSelect = $('#gridIngIndItm').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "请先选中需要删除的记录",
            type: 'alert'
        });
        return;
    }
    if (gridSelect.ingIndItmRemark=="系统公式"){
	    DHCPHA_HUI_COM.Msg.popover({
            msg: "系统公式，您无法删除，可以修改具体公式",
            type: 'alert'
        });
        return;	
	}
    $.messager.confirm('确认对话框', '您确定删除吗？', function(r) {
        if (r) {
		    var ret = tkMakeServerCall("web.DHCSTPIVAS.Formula", "DeletePHCDrgIngIndItm", gridSelect.ingIndItmId);
		    $('#gridIngIndItm').datagrid('reload');
        }
    });
}

function InitHospCombo(){
	var genHospObj=PIVAS.AddHospCom({});
	if (typeof genHospObj ==='object'){
		//增加选择事件
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