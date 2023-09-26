/**
 * 模块:     制剂信息维护
 * 编写日期: 2018-07-04
 * 编写人:   zhaozhiduan
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var inmanuurl="dhcst.inmanuorderaction.csp"
var GridCmgInc,GridCmgUom;
var curEditInci=""
$(function() {
    
	InitDict();
    InitGridDrugInfo();
     
    $('#btnFind').on("click", Query);
    
    //维护div
    InitGridRcpInfo();
    InitGridInrecIngr();
	$('#btnSaveInRcp').on("click", SaveInRcp);
    $('#btnAddInRcp').on("click", AddInRcp);
    $('#btnDelInRcp').on("click", DelInRcp);
    //制剂原料
    $('#btnSaveInRecIngr').on("click", SaveInRecIngr);
    $('#btnAddInRecIngr').on("click", AddInRecIngr);
    $('#btnDelInRecIngr').on("click", DelInRecIngr);
})


function InitDict() {
    
    // 药品
    DHCST.ComboGrid.Init({ Id: 'cmgIncItm', Type: 'IncItm' }, { placeholder: "药品..." }); // width: 315
     // 库存分类
    DHCST.ComboBox.Init({ Id: 'cmbStkCat', Type: 'StkCat' }, { placeholder: "库存分类..." });
	
	GridCmgInc = DHCST.GridComboGrid.Init({ Type: "IncItm" }, {
        required: true,
        idField: 'InRinDesc',
        textField: 'InRinDesc',
        checkOnSelect: false,
        selectOnCheck: false,
        hasDownArrow: false,
        //pageSize: 10,
        //pageList: [10, 30, 50],
        onHidePanel: function() {
	    	var editIndex = $("#gridInRecIngr").datagrid('options').editIndex;
            if (editIndex == undefined) {
                return;
            }
            var incEd = $("#gridInRecIngr").datagrid('getEditor', { index: editIndex, field: 'InRinDesc' });
            var rowData = $(incEd.target).combogrid("grid").datagrid("getSelected");
            if ((rowData == "") || (rowData == null)) {
                return;
            }
            var gridSelect = $('#gridInRecIngr').datagrid("getSelected");
            var InRinUomEd = $("#gridInRecIngr").datagrid('getEditor', { index: editIndex, field: 'InRinUomId' });
            
            gridSelect.InRinCode = rowData.incCode;
            gridSelect.InRinInci = rowData.incRowId;
            gridSelect.InRinDesc = rowData.incDesc;
            curEditInci=rowData.incRowId;
            $(InRinUomEd.target).combobox("reload");
            
        },
        onBeforeLoad: function(param) {
	        curEditInci=$('#gridInRecIngr').datagrid("getSelected").InRinInci;
            if (param.q == undefined) {
                param.q = $('#gridInRecIngr').datagrid("getSelected").InRinDesc;
                
            }
            param.filterText = param.q; 
        }
    });
   GridCmgUom = DHCST.GridComboBox.Init({ Type: "Uom" }, {
        required: true,
        editable: true,
        onBeforeLoad: function(param) {
	        var gridSelect=$('#gridDrugInfo').datagrid("getSelected");
			if(gridSelect==null){
        		return;
			}
			var Inci=(gridSelect.Inci || "")
	
            param.inputStr =Inci; 
            param.filterText = param.q;
        },
        onLoadSuccess: function(data) {
	        var len=data.length;
            if (len > 0) {
                var selectUom = $('#gridInRcp').datagrid("getSelected").UomId || "";
                var finalUom=""
                // 默认单位
                for(var i=0;i<len;i++){
	                var iUom=data[i].RowId;
	                if (iUom==selectUom){
		            	finalUom=iUom;
		            	break;
		            }
                }
                if (finalUom==""){
	            	finalUom=data[0].RowId; 
	            }
	            $(this).combobox('select', finalUom);
            }else{
	        	$(this).combobox('clear');
	        }
        }
    });
    GridCmgIngrUom = DHCST.GridComboBox.Init({ Type: "Uom" }, {
        required: true,
        editable: true,
        onBeforeLoad: function(param) {
            param.inputStr =curEditInci;     //$('#gridInRecIngr').datagrid("getSelected").InRinInci;
            param.filterText = param.q;
        },
        onLoadSuccess: function(data) {
	        var len=data.length;
            if (len > 0) {
                var selectUom = $('#gridInRecIngr').datagrid("getSelected").InRinUomId || "";
                var finalUom=""
                // 默认单位
                for(var i=0;i<len;i++){
	                var iUom=data[i].RowId;
	                if (iUom==selectUom){
		            	finalUom=iUom;
		            	break;
		            }
                }
                if (finalUom==""){
	            	finalUom=data[0].RowId; 
	            }
	            $(this).combobox('select', finalUom);
            }else{
	        	$(this).combobox('clear');
	        }
        }
    });
   	
}

function InitGridDrugInfo() {
    var columns = [
        [
        	{ field: "InciCode", title: '药品代码', width: 120 },
            { field: "InciDesc", title: '药品名称', width: 250 },
            { field: "Spec", title: '规格', width: 105 },
            { field: "Manf", title: '厂商', width: 200},
            { field: "Sp", title: '售价', width: 70, halign: 'right', align: 'right'},
            { field: "Rp", title: '进价', width: 70, halign: 'right', align: 'right' },
            { field: "Uom", title: '单位', width: 70 },
            { field: "Form", title: '剂型', width: 80},
            { field: "GenName", title: '处方通用名', width: 120 },
            { field: "StkCat", title: '库存分类', width: 120 },
            { field: "Inci", title: '库存id', width: 50,hidden: true }
        ]
    ];
    var dataGridOption = {
        url:'', // inmanuurl + '?action=JsGetIncItm',
        rownumbers: false,
        columns: columns,
        singleSelect: true,
        striped: false,
        selectOnCheck: false,
        checkOnSelect: false,
        toolbar: "#gridQueryBar",
        pageSize: 50,
        pageList: [50, 100, 200],
        onClickRow: function(rowIndex, rowData) {
            if(rowData){
	        	FindInRcp()
	        }
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridDrugInfo", dataGridOption);
}

///查询
function Query() {
    var params = GetParams();
    $("#gridInRcp").datagrid("clear");
	$("#gridInRecIngr").datagrid("clear");
    $('#gridDrugInfo').datagrid("clear")
    $('#gridDrugInfo').datagrid({
	    url: inmanuurl + '?action=JsGetIncItm',
        queryParams: {
            params: params
        }
    });
}
function GetParams(){
	var incId =$("#cmgIncItm").combobox("getValue"); // 药品
	var stkcat = $('#cmbStkCat').combobox("getValue"); // 分类
	var incAlias = $("#txtAlias").val().trim();
    var inmanu = $("#chkInManu").is(':checked') ? "Y" : "N";
    
    var params = incId+"^"+stkcat+"^"+incAlias+"^"+inmanu
    return params
    
}



function InitGridRcpInfo() {
    var columns = [
        [
        	{ field: "InRec", title: 'Rowid', width: 50, hidden: true },
        	{ 	
        		field: "InrecDesc", 
        		title: '制剂名', 
        		width: 150, 
        		halign: 'center', 
        		align: 'right',
        		/*
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                },*/
                hidden: true 
        	},
            { 
            	field: "QtyManuf", 
            	title: '数量', 
            	width: 80, 
                editor: {
                    type: 'numberbox',
                    options: {
                        required: true
                    }
                } 
            
            },
            { 
            	field: "UomId",  //uom-rowid
            	title: '单位', 
            	width: 60, 
            	editor: GridCmgUom,
                descField: 'Uom',
                formatter: function(value, row, index) {
                    return row.Uom;
                }
            }
            ,
            { 
            	field: "Ratio",  //uom-rowid
            	title: '成本加成系数', 
            	width: 60, 
                editor: {
                    type: 'validatebox',
                    options: {
                        //required: true,
                        validType: 'PosNumber'
                    }
                }, 
                hidden: true
            }, 
            { field: "Uom", title: '单位', width: 100, hidden: true  },
            { field: "Creator", title: '创始人', width: 60 , hidden: true },
            { field: "UpdUser", title: '更新人', width: 60, hidden: true  },
            { field: "CreatDate", title: '创始日期', width: 90, halign: 'center', align: 'center', hidden: true  },
            { field: "UpdDate", title: '更新日期', width: 70, halign: 'center' , hidden: true },
            
            { field: "Remark", title: '备注', width: 250,
                editor: {
                    type: 'validatebox'
                } 
            },
			{ field: "ExpDate", title: '预计效期(月)', width: 90 ,
                editor: {
                    type: 'numberbox'
                } 
            },
            { 
            	field: "AddCost", 
            	title: '默认附加费用', 
            	width: 80, 
            	halign: 'right' , 
            	align: 'right' ,
                editor: {
                    type: 'validatebox',
                    options: {
                        validType: 'PosNumber'
                    }
                },
                 hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: '',           //inmanuurl + '?action=JsGetIncItm',
        toolbar: '#gridInRcpBar',
        rownumbers: false,
        columns: columns,
        singleSelect: true,
        striped: false,
        selectOnCheck: false,
        checkOnSelect: false,
        pagination: false,
        onClickRow: function(rowIndex, rowData) {
            if (rowData) {
                FindInRecIngr()
            }
        },
        onDblClickRow: function(rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'QtyManuf'
            });
        },
        onLoadSuccess: function() {
	        var rows = $("#gridInRcp").datagrid("getRows").length; 
			if(rows>0){
				$('#gridInRcp').datagrid("selectRow",0);
				FindInRecIngr()
			}
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridInRcp", dataGridOption);
}

function InitGridInrecIngr() {
    var columns = [
        [		
        	{ field: "InRin", title: 'InRin', width: 50, halign: 'center', hidden: true },
        	{ field: "InRinCode", title: '代码', width: 100 },
            { 
            	field: "InRinInci", 
            	title: '库存名称', 
            	width: 230, 
            	hidden: true
            },
            { 
            	field: "InRinDesc", 
            	title: '名称', 
            	width: 200,
            	editor: GridCmgInc,
                descField: 'InRinDesc',
                formatter: function(value, row, index) {
                    return row.InRinDesc;
                }
            },
            { 
            	field: "InRinQty", 
            	title: '数量', 
            	width: 50, 
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                        validType: 'PosNumber'
                    }
                }
            },
            { 
            	field: "InRinUomId",   //uom-rowid
            	title: '单位', 
            	width: 80, 
            	editor: GridCmgIngrUom,
                descField: 'InRinUom',
                formatter: function(value, row, index) {
                    return row.InRinUom;
                }
            },
			{ field: "InRinUom", title: '单位', width: 200,hidden: true},

        ]
    ];
    var dataGridOption = {
        url: '',
        toolbar: '#gridInRecIngrBar',
        rownumbers: false,
        columns: columns,
        singleSelect: true,
        striped: false,
        selectOnCheck: false,
        checkOnSelect: false,
        pagination: false,
        onDblClickRow: function(rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'InRinInci'
            });
        },
        onClickCell: function(rowIndex, field, value) {
            if(field=="InRinCode"){
	       		$(this).datagrid('endEdit',rowIndex );
	        }
        },
    };
    DHCPHA_HUI_COM.Grid.Init("gridInRecIngr", dataGridOption);
}
function FindInRcp(){
	var gridSelect=$('#gridDrugInfo').datagrid("getSelected");
	if(gridSelect==null){
		$.messager.alert("提示", "请选择记录!", "warning");
        return;
	}
	var Inci=(gridSelect.Inci || "")
	if(Inci==""){
		$.messager.alert("提示", "请选择记录!", "warning");
        return;
	}
	$("#gridInRcp").datagrid("clear");
	$("#gridInRecIngr").datagrid("clear");
	$('#gridInRcp').datagrid({
	    url: inmanuurl + '?action=GetIncItmRcp',
        queryParams: {
            Params: Inci
        }
    });
}
function SaveInRcp(){
	var gridSelect=$('#gridDrugInfo').datagrid("getSelected");
	if(gridSelect==null){
		$.messager.alert("提示", "请选择记录!", "warning");
        return;
	}
	var Inci=(gridSelect.Inci || "")
;
	if(Inci==""){
		$.messager.alert("提示", "请选择记录!", "warning");
        return;
	}
	$('#gridInRcp').datagrid('endEditing');
    var gridChanges = $('#gridInRcp').datagrid('getChanges')
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        $.messager.alert("提示", "没有需要保存的数据", "warning");
        return;
    }
    var paramsStr = "";
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i]; 
        var params =  (iData.InRec || "") + "^" + (iData.QtyManuf || "")+ "^" + (iData.UomId || "")+ "^" + (iData.InrecDesc || "")+ "^" + (iData.Remark || "")+ "^" + (iData.Ratio || "")+ "^" + (iData.ExpDate || "") + "^" + (iData.AddCost || "")    ;
        paramsStr = (paramsStr == "") ? params : paramsStr + "!!" + params;
    }
    
    var saveRet = tkMakeServerCall("web.DHCST.IncItmRcp", "SaveInRcp", Inci,paramsStr,SessionUser);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    if (saveVal!=0) {
	    var saveInfo = saveArr[1];
        $.messager.alert("提示", saveInfo, "warning");
    }else{
		FindInRcp();
	}



}
function AddInRcp(){
	var gridSelect=$('#gridDrugInfo').datagrid("getSelected");
	if(gridSelect==null){
		$.messager.alert("提示", "请选择记录!", "warning");
        return;
	}
	$("#gridInRcp").datagrid('addNewRow', { editField: 'QtyManuf' });	
	
}
//删除制剂
function DelInRcp(){
	var gridSelect=$('#gridInRcp').datagrid("getSelected");
	if(gridSelect==null){
		$.messager.alert("提示", "请选择记录!", "warning");
        return;
	}
	var InRec=(gridSelect.InRec || "")
	if(InRec==""){
		var curInd =$('#gridInRcp').datagrid('getRowIndex',gridSelect) ;
		$('#gridInRcp').datagrid('deleteRow',curInd);
	}else{
		DHCST.Progress.Show({ type: 'delete', interval: 1000 });
	    $.m({
	        ClassName: "web.DHCST.IncItmRcp",
	        MethodName: "DeleteInRcp",	        
	        InRec: InRec,
	        
	    }, function(retData) {
	        DHCST.Progress.Close();
	        var retArr = retData.split("^");
	        if (retArr[0] != 0) {
	            $.messager.alert('提示', "删除失败！"+retArr[0], 'warning');
	            return;
	        } 
	       	FindInRcp(); //查询制剂信息 
	    });
	}
}
//查询制剂
function FindInRecIngr(){
	var gridSelect = $('#gridInRcp').datagrid("getSelected");
	if(gridSelect==null){
		$.messager.alert("提示", "请选择记录!", "warning");
        return;
	}
	$("#gridInRecIngr").datagrid("clear");
	var InRec= (gridSelect.InRec || "");
	$('#gridInRecIngr').datagrid({
	    url: inmanuurl + '?action=GetIncItmRecIngr',
        queryParams: {
            Params: InRec
        }
    });
}
function CheckBeforeSaveIngr(){
	var rows = $("#gridInRecIngr").datagrid("getRows"); 
	for(var i=0;i<rows.length;i++){
		var iData=rows[i];
        var InRinInci=(iData.InRinInci || "")
        if((InRinInci=="")||(InRinInci==0)){
	    	$.messager.alert("提示", "请选择药品！", "warning");
	    	return false;
	    }
        var InRinQty=(iData.InRinQty || 0)
        if(InRinQty==0){
	    	$.messager.alert("提示", "请正确录入数量！", "warning");
	    	return false;
	    }
	    var UomId=(iData.InRinUomId || "")
	    if(UomId==""){
	    	$.messager.alert("提示", "请选择单位！", "warning");
	    	return false;
	    }
	    for(var j=0;j<i;j++){
		    var jData=rows[j];
		    var tmpInci=(jData.InRinInci || "")
		    if(InRinInci==tmpInci){
				$.messager.alert("提示", "第"+(i+1)+"行与第"+(j+1)+"行原料重复", "warning");
	    		return false;
			}
	    }
	    
    }
    return true;
}
function SaveInRecIngr(){
	
	var gridSelect=$('#gridInRcp').datagrid("getSelected");
	if(gridSelect==null){
		$.messager.alert("提示", "请选择记录!", "warning");
        return;
	}
	var InRec=(gridSelect.InRec || "")
	$('#gridInRecIngr').datagrid('endEditing');
	if(CheckBeforeSaveIngr()==false){return;}
	
	var paramsStr=""
	var rows = $("#gridInRecIngr").datagrid("getRows"); 
	for(var i=0;i<rows.length;i++){
		var iData=rows[i];
		
 
        var InRinInci=(iData.InRinInci || "")

        var InRinQty=(iData.InRinQty || 0)
       
       
	    var UomId=(iData.InRinUomId || "")
	    
	    var Desc=(iData.InRinDesc || "")
        var params =  (iData.InRin || "") + "^" + InRinInci+ "^" + InRinQty+ "^" + UomId+ "^" +Desc;
        paramsStr = (paramsStr == "") ? params : paramsStr + "!!" + params;
    }
    var saveRet = tkMakeServerCall("web.DHCST.IncItmRcp", "SaveInRecIngr", InRec,paramsStr,SessionUser);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    if (saveVal!=0) {
	    var saveInfo = saveArr[1];
        $.messager.alert("提示", saveInfo, "warning");
    }else{
		FindInRecIngr();
	}


}
function AddInRecIngr(){
	var gridSelect=$('#gridInRcp').datagrid("getSelected");
	if(gridSelect==null){
		$.messager.alert("提示", "请选择制剂记录!", "warning");
        return;
	}
	$("#gridInRecIngr").datagrid('addNewRow', { editField: 'InRinDesc' });	
}
function DelInRecIngr(){
	var gridSelect=$('#gridInRecIngr').datagrid("getSelected");
	if(gridSelect==null){
		$.messager.alert("提示", "请选择制剂原料记录!", "warning");
        return;
	}
	var InRin=(gridSelect.InRin || "")
	if(InRin==""){
		var curInd =$('#gridInRecIngr').datagrid('getRowIndex',gridSelect) ;
		$('#gridInRecIngr').datagrid('deleteRow',curInd);
	}else{
		DHCST.Progress.Show({ type: 'delete', interval: 1000 });
	    $.m({
	        ClassName: "web.DHCST.IncItmRcp",
	        MethodName: "DeleteInRecIngr",	       
	        InRin: InRin,
	        
	    }, function(retData) {
	        DHCST.Progress.Close();
	        var retArr = retData.split("^");
	        if (retArr[0] != 0) {
	            $.messager.alert('提示', "删除原料失败！"+retArr[0], 'warning');
	            return;
	        } 
	        
    		$("#gridInRecIngr").datagrid("clear");
	       	FindInRecIngr(); //查询制剂信息 
	    });
	}
}