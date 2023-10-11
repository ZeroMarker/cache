/**
 * 模块		: 科室扩充信息维护
 * 编写日期	: 2021-12-29
 * 编写人	: yangsj
 */
 
var cmbWidth = 150;
PHA_COM.ResizePhaColParam.auto = false;
$(function () {
	InitHosp();		// 初始化医院
    InitDict();    	// 初始化字典
    InitGrid();    	// 初始化表格
});

function InitHosp(){
    var hospComp = GenHospComp("DHCST_CtLoc",'', { width: '358' });
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
        InitDict();
        Query();
        InitGrid();
        
    };
    var defHosp = $cm(
        {
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: 'DHCST_CtLoc',
            HospID: PHA_COM.Session.HOSPID
        },
        false
    );
    PHA_COM.Session.HOSPID = defHosp;
    PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
}

function InitDict(){
	 
	/* 科室组 */
    PHA.ComboBox('Slg', {
        width: cmbWidth,
        url: PHA_STORE.InLocGroup().url
    });

    /* 库房类别 */
    PHA.ComboBox('StoreType', {
        width: cmbWidth,
        url: PHA_STORE.StoreType().url
    });

	/* 科室项目组 */
    PHA.ComboBox('LocItemG', {
        width: cmbWidth,
        url: PHA_STORE.LocItemGroup().url
    });
      
    /* 支配科室 */
    PHA.ComboBox('MainLoc', {
        width: cmbWidth,
        url: PHA_STORE.CTLoc().url
    });  
}

function InitGrid(){
	var columns = [
        [
            { field: 'DhcLoc', 		title: 'DhcLoc', 			hidden: true },
            { field: 'LocCode', 	title: '科室代码',  		align: 'left',	width: 100,},  
            { field: 'Loc',			title: '科室名称',			width: 200,	  	descField: 'LocDesc',
                editor: PHA_GridEditor.ComboBox({
					required: true,
					tipPosition: 'top',
					url: PHA_STORE.CTLoc().url,
					defaultFilter: 5
				}),
                formatter: function (value, row, index) {
                    return row.LocDesc;
                }
            },
            { field: 'SlgId',			title: '科室组',		width: 150,	  	descField: 'SlgDesc',
                editor: PHA_GridEditor.ComboBox({
					tipPosition: 'top',
					url: PHA_STORE.InLocGroup().url
				}),
                formatter: function (value, row, index) {
                    return row.SlgDesc;
                }
            },
            { field: 'LigId',			title: '项目组',		width: 150,	  	descField: 'LigDesc',
                editor: PHA_GridEditor.ComboBox({
					tipPosition: 'top',
					url: PHA_STORE.LocItemGroup().url
				}),
                formatter: function (value, row, index) {
                    return row.LigDesc;
                }
            },
            { field: 'StoreType',			title: '库房类别',	width: 150,	  	descField: 'StoreTypeDesc',  
            	editor: PHA_GridEditor.ComboBox({
	            	required: true,
					tipPosition: 'top',
					url: PHA_STORE.StoreType().url
					
				}),
                formatter: function (value, row, index) {
                    return row.StoreTypeDesc;
                }
            },
            { field: 'MainLoc',			title: '支配科室',		width: 200,	  	descField: 'MainLocDesc',
                editor: PHA_GridEditor.ComboBox({
					tipPosition: 'top',
					url: PHA_STORE.CTLoc().url,
					defaultFilter: 5
				}),
                formatter: function (value, row, index) {
                    return row.MainLocDesc;
                }
            },
            { field: 'LocDesc', 		title: 'LocDesc', 			hidden: true },
            { field: 'SlgDesc', 		title: 'SlgDesc', 			hidden: true },
            { field: 'LigDesc', 		title: 'LigDesc', 			hidden: true }, 
            { field: 'StoreTypeDesc', 	title: 'StoreTypeDesc', 	hidden: true }, 
            { field: 'MainLocDesc', 	title: 'MainLocDesc', 		hidden: true }, 
        ]
    ];
    var dataGridOption = {
        url: $URL,
        gridSave: false,
        queryParams: {
            ClassName: 'PHA.IN.LocInfo.Query',
            QueryName: 'LocInfo',
            HospId   : PHA_COM.Session.HOSPID,
            ParamsJson : "{}",
            page	: 1, 
        	rows	: 99999
        },
        pagination: false,
        //fitColumns: true,
        fit: true,
        idField: 'DhcLoc',
        columns: columns,
        toolbar: '#GridLocInfoBar',  
        exportXls: false,
        isAutoShowPanel: true,
        isCellEdit: false,
        onClickRow: function (rowIndex, rowData) {
	        if (!PHA_GridEditor.End('GridLocInfo')) {
				var curIndex = $(this).datagrid('options').editIndx;
				if (curIndex >= 0) {
					PHA.Msg('alert', '第' + (curIndex + 1) + '行有必填项未填,请先完成编辑！');
				}
				return;
		    }
        },
	    onDblClickRow: function (rowIndex, rowData) {
		    if (!PHA_GridEditor.End('GridLocInfo')) {
				var curIndex = $(this).datagrid('options').editIndx;
				if (curIndex >= 0) {
					PHA.Msg('alert', '第' + (curIndex + 1) + '行有必填项未填,请先完成编辑！');
				}
				return;
		    }
            PHA_GridEditor.Edit({
	            gridID: "GridLocInfo",
	            index: rowIndex,
	            field: "Loc"
            });
	    }
    };
    PHA.Grid('GridLocInfo', dataGridOption);
}

function Query(){
	Clean();
	var ParamsJson = PHA.DomData('#GridLocInfoBar', {
        doType: 'query',
        retType: 'Json'
    });
    var ParamsJson = JSON.stringify(ParamsJson[0]);
	$('#GridLocInfo').datagrid('query', {
        HospId : PHA_COM.Session.HOSPID,
        ParamsJson : ParamsJson,
        page	: 1, 
        rows	: 99999
    });
}
function Clean(){
	$('#GridLocInfo').datagrid('clearSelections');   
	$('#GridLocInfo').datagrid('clear');
}

function AddDhcLoc(){
	if (!PHA_GridEditor.End('GridLocInfo')) {
		var curIndex = $('#GridLocInfo').datagrid('options').editIndx;
		if (curIndex >= 0) {
			PHA.Msg('alert', '第' + (curIndex + 1) + '行有必填项未填,请先完成编辑！');
		}
		return;
    }
	PHA_GridEditor.Add({
		gridID : 'GridLocInfo',
		field  : 'Loc',
		checkRow :true
	},1);
}

function SaveDhcLoc(){
	//$('#GridLocInfo').datagrid('endEditing');
	PHA_GridEditor.End('GridLocInfo');
	if($("#GridLocInfo").datagrid('options').editIndex != undefined) 
    {
        PHA.Msg('alert','请检查编辑行是否有必填列未填写!');
        return;
    }
    var gridChanges = $('#GridLocInfo').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (!gridChangeLen){
	    PHA.Msg('alert' ,"没有需要保存的数据！");
	    return
    }
    $.cm(
        {
            ClassName : 'PHA.IN.LocInfo.Save',  
            MethodName: 'Save',
            HospId    : PHA_COM.Session.HOSPID,
            DetailData: JSON.stringify(gridChanges),
        },
        function (retData) {
            if(retData.code >= 0){
	            PHA.Msg('success' ,"保存成功！");
	            Query();
            }
            else{
	            PHA.Msg('alert' ,"保存失败！" + retData.msg );
	            return
            }
        }
    );
}

function DeleteDhcLoc(){
	var gridSelect = $('#GridLocInfo').datagrid('getSelected');
    if (gridSelect == null) {
	    PHA.Msg('alert' ,"请选择需要删除的记录！");
        return;
    }
    $.messager.confirm('确认对话框', '您确定删除吗？', function (r) {
        if (r) {
            var dhcLoc = gridSelect.DhcLoc || '';
            if (dhcLoc == '') {
                var rowIndex = $('#GridLocInfo').datagrid('getRowIndex', gridSelect);
                $('#GridLocInfo').datagrid('deleteRow', rowIndex);
            } else {
                $.cm(
				    {
				        ClassName : 'PHA.IN.LocInfo.Save',  
				        MethodName: 'Delete',
				        DhcLoc    : dhcLoc,
				    },
				    function (retData) {
				        if(retData.code >= 0){
				            PHA.Msg('success' ,"删除成功！");
				            Query();
				        }
				        else{
				            PHA.Msg('alert' ,retData.msg );
				            return;
				        }
				    }
				);
            }
        }
    });
}
