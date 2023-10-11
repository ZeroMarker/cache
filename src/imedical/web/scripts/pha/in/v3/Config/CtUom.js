/**
 * 模块:     单位维护
 * 编写日期: 2021-10-08
 * 编写人:   yangsj
 */
$(function () {
    InitDict();
    InitGrid();
});

function InitDict(){
	/// 模糊检索
    $('#txtAlias').searchbox({
	    searcher:function(value,name){
	    Query();
	    },
	    width:300,
	    prompt:$g('模糊检索...')
	}); 
	
	GridCmbUom = PHA.EditGrid.ComboBox(  
        {
            required: true,
            tipPosition: 'top',
            url: PHA_STORE.CTUOM().url,
            defaultFilter:6
        }
    );
}

function InitGrid(){
	InitGridUom();
	InitGridFac();
}

function InitGridUom(){
	var columns = [
        [
            // Uom, Code, Desc
            { field: 'Uom', 			title: 'Uom', 			hidden: true },
            { field: 'Code', 			title: '代码',  		width: 100,
            	editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
            { field: 'Desc', 			title: '名称', 			width: 200,
            	editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.CtUom.Query',
            QueryName: 'QueryCtUom',
            Alias    : ""
        },
        gridSave: false,
        pagination: true,
        idField: 'Uom',
        fitColumns: true,
        columns: columns,
        toolbar: '#GridUomBar',
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
		        if (rowData) {
			        $('#GridUom').datagrid('endEditing');
	                var editIndex = $(this).datagrid('options').editIndex
		            if (editIndex == undefined) {
		               QueryFac();
		            }
		            else {
			            var nextRow=editIndex+1
		                PHA.Msg("alert",'第 ' + nextRow + " 行必填项未填，请先补充必填项！");
		        		return;
		            }
	            }
	        },
	    onDblClickRow: function (rowIndex, rowData) { 
	    		$(this).datagrid('beginEditRow', {
	                rowIndex: rowIndex,
	                editField: 'Code',
	            });
	    }
    };
    PHA.Grid('GridUom', dataGridOption);
}

function InitGridFac(){
	var columns = [
        [
            // Ctcf, ToUom, Code, Desc, Fac, Active
            { field: 'Ctcf', 		title: 'Ctcf', 			hidden: true 	},
            { field: 'Code', 		title: '代码', 			width: 150,		},
            { field: 'ToUom', 		title: '名称', 			width: 150,  	descField: 'Desc',		editor: GridCmbUom,
            	formatter: function (value, row, index) {
                    return row.Desc;
                }  		
            },
            { field: 'Desc', 		title: '名称', 			width: 250,		hidden: true },
            { field: 'Fac', 		title: '转换因子', 		width: 120, 	align: 'center',	
            	editor: PHA_GridEditor.NumberBox({
	            	required: true,	
	            	precision: 0,
	            	checkValue: function (val, checkRet) {
						if (val == "") {
							checkRet.msg = "不能为空！"
								return false;
						}
						var nQty = parseFloat(val);
						if (isNaN(nQty)) {
							checkRet.msg = "请输入数字！";
							return false;
						}
						if (nQty <= 0) {
							checkRet.msg = "请输入大于0的整数！";
							return false;
						}
						return true;
					}
	            })
            },
            { field: 'Active', 		title: '激活标志', 		width: 120,		align: 'center',	formatter: PHA_GridEditor.CheckBoxFormatter,
            	editor: PHA_GridEditor.CheckBox({})	
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.CtUom.Query',
            QueryName: 'QueryFac',
            FrUom    : ""
        },
        gridSave: false,
        toolbar: '#GridFacBar',
        pagination: false,
        idField: 'Ctcf',
        fitColumns: false,
        columns: columns,
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
		        if (rowData) {
			        $('#GridFac').datagrid('endEditing');
	                var editIndex = $(this).datagrid('options').editIndex
		            if (editIndex != undefined) {
			            var nextRow=editIndex+1
		                PHA.Msg("alert",'第 ' + nextRow + " 行必填项未填，请先补充必填项！");
		        		return;
		            }
	            }
	        },
	    onDblClickRow: function (rowIndex, rowData) { 
	    		$(this).datagrid('beginEditRow', {
	                rowIndex: rowIndex,
	                editField: 'ToUom',
	            });
	    }
    };
    PHA.Grid('GridFac', dataGridOption);
}

function Query(){
	CleanGridUom();
	CleanGridFac();
	var Alias = $('#txtAlias').searchbox("getValue");
	$('#GridUom').datagrid('query', {
		Alias : Alias
    });
}

function QueryFac(){
	CleanGridFac();
	var gridSelect = $('#GridUom').datagrid('getSelected') || '';
    var frUom = gridSelect ? gridSelect.Uom : "";
    if (frUom == "") return;
	$('#GridFac').datagrid('query', {
		FrUom : frUom
    });
}

function CleanGridUom(){
	$('#GridUom').datagrid('clearSelections');   
	$('#GridUom').datagrid('clear');
}

function CleanGridFac(){
	$('#GridFac').datagrid('clearSelections');   
	$('#GridFac').datagrid('clear');
}

function AddUom(){
    $('#GridUom').datagrid('addNewRow', {
        editField: 'Code',
    });
}

function AddFac(){
    PHA_GridEditor.Add({
		gridID   : 'GridFac',
		field    : 'ToUom',
		checkRow : true,
		rowData  : {
				Active : 'Y'
			}
	});
}

function SaveUom(){
	$('#GridUom').datagrid('endEditing');
    var gridChanges = $('#GridUom').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (!gridChangeLen){
	    PHA.Msg('alert' ,"没有需要保存的数据！");
	    return
    }
    $.cm(
        {
            ClassName : 'PHA.IN.CtUom.Save',  
            MethodName: 'Save',
            DetailData: JSON.stringify(gridChanges),
        },
        function (retData) {
            if(retData.code >= 0){
	            PHA.Msg('success' ,"保存成功！");
	            Query();
            }
            else{
	            PHA.Msg('alert' ,"保存失败！" + retData.msg );
	            return;
            }
        }
    );
}

function SaveFac(){
	var gridSelect = $('#GridUom').datagrid('getSelected') || '';
    var frUom = gridSelect ? gridSelect.Uom : "";
    if (!frUom){
	    PHA.Msg('alert' ,"请先选择一个主单位！");
	    return
    }
	$('#GridFac').datagrid('endEditing');
	var chkRetStr = PHA_GridEditor.CheckValues('GridFac');
	if (chkRetStr != "") {
		PHA.Msg('alert', chkRetStr);
		return;
	}
    var gridChanges = $('#GridFac').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (!gridChangeLen){
	    PHA.Msg('alert' ,"没有需要保存的数据！");
	    return
    }
    $.cm(
        {
            ClassName : 'PHA.IN.CtUom.Save',  
            MethodName: 'SaveFac',
            DetailData: JSON.stringify(gridChanges),
            FrUom     : frUom
        },
        function (retData) {
            if(retData.code >= 0){
	            PHA.Msg('success' ,"保存成功！");
	            QueryFac();
            }
            else{
	            PHA.Msg('alert' ,"保存失败！" + retData.msg );
	            return;
            }
        }
    );
}


function DeleteUom(){
	PHA.Msg("alert"," 暂不提供删除功能！！！");
}

function DeleteFac(){
	var gridSelect = $('#GridFac').datagrid('getSelected');
    if (gridSelect == null) {
	    PHA.Msg('alert' ,"请选择需要删除的记录！");
        return;
    }
    var ctcf = gridSelect.Ctcf || '';
    if (ctcf == '') {
        var rowIndex = $('#GridFac').datagrid('getRowIndex', gridSelect);
        $('#GridFac').datagrid('deleteRow', rowIndex);
        $('#GridFac').datagrid('clearSelections');  
        return;
    }
    PHA.Confirm('提示', '单位转换系数为重要数据！您确认删除吗?', function () {
        $.cm(
		    {
		        ClassName : 'PHA.IN.CtUom.Save',  
		        MethodName: 'DeleteFac',
		        Ctcf       : ctcf,
		    },
		    function (retData) {
		        if(retData.code >= 0){
		            PHA.Msg('success' ,"删除成功！");
		            QueryFac();
		        }
		        else{
		            PHA.Msg('alert' ,retData.msg );
		            return;
		        }
		    }
		);
    });
}
