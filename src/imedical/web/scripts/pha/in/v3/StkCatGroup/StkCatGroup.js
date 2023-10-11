/**
 * 模块:     类组维护
 * 编写日期: 2021-09-09
 * 编写人:   yangsj
 */
$(function () {
	InitHosp();
    InitDict();
    InitGrid();
    InitTrans();
});

function InitHosp(){
	var hospComp = GenHospComp("DHC_StkCatGroup");
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
        Query();
        
        QueryStkCatNotUse();
    };
    var defHosp = $cm(
        {
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: 'DHC_StkCatGroup',
            HospID: PHA_COM.Session.HOSPID
        },
        false
    );
    PHA_COM.Session.HOSPID = defHosp;
    PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
}

function InitTrans(){
	$('#stkCatPanel').panel('setTitle',$g('库存分类<font color = green>(已维护)</font>'));
	$('#stkCatNotUsePanel').panel('setTitle',$g('库存分类<font color = red>(未维护)</font>'));
}

function InitDict(){
	var SetData=[
            {
                RowId: 'GX',
                Description: $g('西药'),
            },
            {
                RowId: 'GZ',
                Description: $g('中成药'),
            },
            {
                RowId: 'GC',
                Description: $g('草药'),
            }
        ]
	GridCmbSet = PHA.EditGrid.ComboBox(
        {
            tipPosition: 'top',
            data : SetData  
        }
    );

    PHA_UX.ComboBox.StkCatGrp('scg', {simple:true,width:150});
}

function InitGrid(){
	InitGridScg();
	InitGridStkCat();
	InitGridStkCatNotUse();
}

function InitGridScg(){
	var columns = [
        [
            // Scg, Code, Desc, SetCode, SetDesc, StruModeFlag
            { field: 'Scg', 			title: 'Scg', 			hidden: true },
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
            },
            { field: 'SetCode', 		title: '类型', 			width: 120 ,	descField: 'SetDesc', 	editor: GridCmbSet,
            	formatter: function (value, row, index) {
                    return row.SetDesc;
                }
            },
            { field: 'SetDesc', 		title: '类型名称', 			width: 120 ,	hidden: true },
            { field: 'StruModeFlag', 	title: '是否一对多', 	width: 120 , formatter:PHA_GridEditor.CheckBoxFormatter,
            /*	formatter:function (value, row, index) {
	            	if ((row.SetCode !== "GC")&&(value == 'Y')){
		            	row.StruModeFlag = "N";
		            	PHA.Msg('alert' ,"仅草药允许维护一对多！" );
		    			return PHA_COM.Fmt.Grid.No.Chinese;
	            	}
					if (value == 'Y') {
						return PHA_COM.Fmt.Grid.Yes.Chinese;
					} else {
						return PHA_COM.Fmt.Grid.No.Chinese;
					}
				} ,		*/	
            	editor: PHA_GridEditor.CheckBox({})
            },
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.StkCatGroup.Query',
            QueryName: 'QueryScg',
            HospId   : PHA_COM.Session.HOSPID,
            page	: 1, 
       	 	rows	: 99999
        },
        gridSave: false,
        pagination: false,
        idField: 'Scg',
        fitColumns: true,
        columns: columns,
        toolbar: '#GridScgBar',
        exportXls: false,
        editFieldSort: ['Code', 'Desc', 'SetCode', 'StruModeFlag'],
        onClickRow: function (rowIndex, rowData) {
		        if (rowData) {
			        $('#GridScg').datagrid('endEditing');
	                var editIndex = $(this).datagrid('options').editIndex
		            if (editIndex == undefined) {
		               QueryStkCat();
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
	    },
	    onBeginEdit: function(index, rowData){
			var ed = $(this).datagrid('getEditor', {
				index: index,
				field: 'StruModeFlag'
			});
			$(ed.target).on('click', function(){
				var SetCode = rowData.SetCode
				var StruModeFlag = rowData.StruModeFlag
				if ((SetCode !== "GC")&&(StruModeFlag == 'N')){
		            PHA.Msg('alert' ,"仅草药允许维护一对多！" );
		            return false;
				}
			});
		}
    };
    PHA.Grid('GridScg', dataGridOption);
}

function InitGridStkCat(){
	var columns = [
        [
            // RelationId, stkCat, StkCatCode, StkCatDesc
            { field: 'RelationId', 		title: 'RelationId', 	hidden: true 	},
            { field: 'deleteBut',       title: '操作',          align: 'center',width: 120,	formatter: deleteStkCatFormatter,	frozencols:true	},
            { field: 'stkCat', 			title: 'stkCat', 		hidden: true 	},
            { field: 'StkCatCode',      title: '代码', width: 250, hidden: true },
            { field: 'StkCatDesc', 		title: '名称', 			width: 250   	},
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.StkCatGroup.Query',
            QueryName: 'QueryStkCatByScg',
            HospId   : PHA_COM.Session.HOSPID,
            Scg      : '',
            page	 : 1, 
        	rows	 : 99999
        },
        gridSave: false,
        pagination: false,
        idField: 'RelationId',
        fitColumns: true,
        columns: columns,
        exportXls: false
    };
    PHA.Grid('GridStkCat', dataGridOption);
}

function UpdateScgFormatter(value, rowData, rowIndex) {
    var stkCat = rowData.stkCat;
    return ("<a onclick='UpdateScgWin()'>修改类组</a>" );
}

function UpdateScgWin() {

	$('#diagUpdateScg')
        .dialog({
            iconCls: 'icon-w-edit',
            modal: true,
            onBeforeClose: function () {},
        })
        .dialog('open'); 
}

function UpdateScg() {
    var scg = $('#scg').combobox('getValue');
    if (!scg) {
        PHA.Msg('alert', '请选择一个新类组');
	            return;
    }
    var stkcat = '';
	var gridSelect = $('#GridStkCat').datagrid('getSelected') || '';
	if (gridSelect) stkcat = gridSelect.stkCat
	if (!stkcat) {
        PHA.Msg('alert', '请选择一个库存分类');
	    return;
    }
    $.cm(
        {
            ClassName : 'PHA.IN.StkCatGroup.Save',  
            MethodName: 'UpdateScg',
            pScg      : scg,
            stkcat    : stkcat,
        },
        function (retData) {
            if(retData.code >= 0){
	            PHA.Msg('success' ,"更新成功！");
                QueryStkCat();
                $('#diagUpdateScg').dialog('close');
            }
            else{
	            PHA.Msg('alert' ,"更新失败！" + retData.msg );
	            return;
            }
        }
    );
	
}

function InitGridStkCatNotUse(){
	var columns = [
        [
            // stkCat, stkCatCode, stkCatDesc
            { field: 'addBut',       	title: '添加',          align: 'center',width: 59,		formatter: AddStkCatFormatter,	frozencols:true	},
            { field: 'stkCat', 			title: 'stkCat', 		hidden: true 	},
            { field: 'stkCatCode',      title: '代码', width: 250, hidden: true },
            { field: 'stkCatDesc', 		title: '名称', 			width: 250   	}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.StkCatGroup.Query',
            QueryName: 'QueryStkCatNotUse',
            HospId   : PHA_COM.Session.HOSPID,
            page	 : 1, 
            rows	 : 99999
        },
        gridSave: false,
        pagination: false,
        idField: 'StkCat',
        fitColumns: false,
        columns: columns,
        exportXls: false
    };
    PHA.Grid('GridStkCatNotUse', dataGridOption);
}

function Query(){
	CleanGridScg();
	CleanGridStkCat();
	$('#GridScg').datagrid('query', {
		HospId : PHA_COM.Session.HOSPID,
		page	: 1, 
        rows	: 99999
    });
}

function QueryStkCat(){
	CleanGridStkCat();
	var gridSelect = $('#GridScg').datagrid('getSelected') || '';
    var Scg = gridSelect ? gridSelect.Scg : "";
    if (Scg == "") return;
	$('#GridStkCat').datagrid('query', {
		HospId 	: PHA_COM.Session.HOSPID,
        Scg		: Scg,
        page	: 1, 
        rows	: 99999
    });
}

function QueryStkCatNotUse(){
	$('#GridStkCatNotUse').datagrid('query', {
		HospId 	: PHA_COM.Session.HOSPID,
		page	: 1, 
        rows	: 99999
    });
}

function CleanGridScg()
{
	$('#GridScg').datagrid('clearSelections');   
    $('#GridScg').datagrid('clear');
}

function CleanGridStkCat()
{
	$('#GridStkCat').datagrid('clearSelections');   
    $('#GridStkCat').datagrid('clear');
}

function AddScg(){
    $('#GridScg').datagrid('addNewRow', {
        editField: 'Code',
    });
}

function SaveScg(){
	$('#GridScg').datagrid('endEditing');
    var gridChanges = $('#GridScg').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (!gridChangeLen){
	    PHA.Msg('alert' ,"没有需要保存的数据！");
	    return
    }
    $.cm(
        {
            ClassName : 'PHA.IN.StkCatGroup.Save',  
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
	            return;
            }
        }
    );
}

function DeleteScg(){
	var gridSelect = $('#GridScg').datagrid('getSelected');
    if (gridSelect == null) {
	    PHA.Msg('alert' ,"请选择需要删除的记录！");
        return;
    }
    var Scg = gridSelect.Scg || '';
    if (Scg == '') {
        var rowIndex = $('#GridScg').datagrid('getRowIndex', gridSelect);
        $('#GridScg').datagrid('deleteRow', rowIndex);
        $('#GridScg').datagrid('clearSelections');  
        return;
    }
    PHA.Confirm('提示', '您确认删除吗?', function () {
        $.cm(
		    {
		        ClassName : 'PHA.IN.StkCatGroup.Save',  
		        MethodName: 'DeleteScg',
		        Scg       : Scg,
		        HospId    : PHA_COM.Session.HOSPID
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
    });
}



function deleteStkCatFormatter(value, rowData, rowIndex) {
    var RelationId = rowData.RelationId;
    if(HISUIStyleCode == 'blue'){
        return (
            "<span onclick='DeleteStkCat(\"" + RelationId +"\")' class='icon-cancel'>&nbsp;&nbsp;&nbsp;&nbsp;</span><span onclick='UpdateScgWin()' class='icon-update'>&nbsp;&nbsp;&nbsp;&nbsp;</span>"        
        );
    }else {
        return (
            "<span onclick='DeleteStkCat(\"" + RelationId +"\")' class='icon-cancel'></span><span style=\"padding-left:10px\" onclick='UpdateScgWin()' class='icon-update'></span>"        
        );
    }
}

function AddStkCatFormatter(value, rowData, rowIndex) {
    var stkCat = rowData.stkCat;
    if(HISUIStyleCode == 'blue'){
        return (
            "<span onclick='AddStkCat(\"" + stkCat +"\")' class='icon-add'>&nbsp;&nbsp;&nbsp;&nbsp;</span>"
        );
    }else {
        return (
            "<span onclick='AddStkCat(\"" + stkCat +"\")' class='icon-add'></span>"
        );
    }
}

function DeleteStkCat(RelationId)
{
	if (RelationId == "") 
    {
	    PHA.Msg('alert' ,"请先选择一个库存分类！" );
	    return;
    }
    PHA.Confirm('提示', '您确认删除吗?', function () {
	    $.cm(
			{
	            ClassName : 'PHA.IN.StkCatGroup.Save',  
	            MethodName: 'DeleteStkCat',
	            RelationId: RelationId
	        },
	        function (retData) {
	            if(retData.code >= 0){
		            PHA.Msg('success' ,"删除成功！");
		            QueryStkCat();
		            QueryStkCatNotUse();
	            }
	            else{
		            PHA.Msg('alert' ,"删除失败！" + retData.msg );
		            return;
	            }
	        }
	    );
	});
}

function AddStkCat(stkCat)
{
	var gridSelect = $('#GridScg').datagrid('getSelected') || '';
    var Scg = gridSelect ? gridSelect.Scg : "";
    if (Scg == "") 
    {
	    PHA.Msg('alert' ,"请先选择一个类组！" );
	    return;
    }
	$.cm(
		{
            ClassName : 'PHA.IN.StkCatGroup.Save',  
            MethodName: 'AddStkCat',
            Scg       : Scg,
            StkCat    : stkCat
        },
        function (retData) {
            if(retData.code >= 0){
	            PHA.Msg('success' ,"添加成功！");
	            QueryStkCat();
	            QueryStkCatNotUse();
            }
            else{
	            PHA.Msg('alert' ,"添加失败！" + retData.msg );
	            return;
            }
        }
    );
}