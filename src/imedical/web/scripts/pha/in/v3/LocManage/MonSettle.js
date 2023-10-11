/**
 * 模块		: 月结配置
 * 编写日期	: 2021-11-15
 * 编写人	: yangsj
 */

var APINAME = 'PHA.IN.MonSettle.Api';


$(function () {
	InitHosp();    // 初始化医院
    InitDict();    // 初始化字典
    InitGrid();    // 初始化表格
    DefaQuery();    
});

function InitHosp(){
    var hospComp = GenHospComp("CF_PHA_IN.MonSettle",'', { width: 300 }); //CF_PHA_IN.MonSettle
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
        //$("#GridMonSettle").datagrid("getColumnOption", "SSGroupId").editor.options.url = PHA_STORE.SSGroup().url,
        Query();
    };
    var defHosp = $cm(
        {
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: 'CF_PHA_IN.MonSettle',
            HospID: PHA_COM.Session.HOSPID
        },
        false
    );
    PHA_COM.Session.HOSPID = defHosp;
    PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
}

function InitDict(){}

function InitGrid(){
	var columns = [
        [
            // MonSId, HospId, Loc, LocDesc, GroupType, Day, ActiveFlag, UserId, UserName, InitAutoAcc, OverMonBanAcc
            { field: 'msId', 		title: 'msId', 	    hidden: true 		},
            { field: 'hospId', 		title: 'hospId', 	hidden: true 		},
            { field: 'groupType', 	title: '作用范围',  align: 'center',	width: 100,
            	formatter: function (value, row, index) {
                    if (value == 'HOS') {
                        return $g("院级");
                    } else if (value == 'LOC'){
                        return $g("科室级");
                    }
                },
            },  
            { 
            	field: 'locId',
                title: '科室',
                width: 250,
                descField: 'locDesc',
                editor: PHA_GridEditor.ComboBox({
					tipPosition: 'top',
					url: PHA_STORE.CTLoc().url,
					defaultFilter:6,
					onBeforeLoad: function (param) {
						param.HospId = PHA_COM.Session.HOSPID;
                        param.QText = param.q;
					}
				}),
                formatter: function (value, row, index) {
                    return row.locDesc;
                }
            },
            /*
            { field: 'ActiveFlag', 	title: '自动生成月报',      width: 120,     align:"center",	formatter: PHA_GridEditor.CheckBoxFormatter,	editor: PHA_GridEditor.CheckBox({}) }, 
            { field: 'Day',         title: '月结日',            width: 80,      align:"center",	editor: PHA_GridEditor.NumberBox({precision:0,required: true})},
            */
            { field: 'autoDayFlag', title: '自动生成日报',      width: 120,     align:"center",	formatter: PHA_GridEditor.CheckBoxFormatter,	editor: PHA_GridEditor.CheckBox({}) }, 
            { field: 'autoDays', 	title: '日报日期范围',      width: 100,		align:"right",	editor: PHA_GridEditor.NumberBox({precision:0})},
            { 
            	field: 'userId',
                title: '默认操作人',
                width: 120,
                descField: 'userName',
                editor: PHA_GridEditor.ComboBox({
					required: true,
					tipPosition: 'top',
					url: PHA_STORE.SSUser().url,
					defaultFilter:6,
					onBeforeLoad: function (param) {
						param.HospId = PHA_COM.Session.HOSPID;
                        param.QText = param.q;
					}
				}),
                formatter: function (value, row, index) {
                    return row.userName;
                }
            }
            /*
            ,
            { field: 'InitAutoAcc', 	title: '月底自动转移接收', 		width: 130,  align:"center",	formatter: PHA_GridEditor.CheckBoxFormatter,	editor: PHA_GridEditor.CheckBox({}) }, 
            { field: 'OverMonBanAcc', 	title: '跨月禁止拒绝接收', 		width: 130,  align:"center",	formatter: PHA_GridEditor.CheckBoxFormatter,	editor: PHA_GridEditor.CheckBox({})	}
            */
        
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : 'PHA.IN.MonSettle.Api',
            pMethodName: 'QueryMs',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        /*
        queryParams: {
            ClassName: 'PHA.IN.MonSettle.Query',
            QueryName: 'QueryMonS',
            pHospId  : PHA_COM.Session.HOSPID,
            page	: 1, 
        	rows	: 99999
        },*/
        pagination: false,
        //fitColumns: true,
        fit: true,
        idField: 'msId',
        columns: columns,
        toolbar: '#GridMonSettleBar',  
        exportXls: false,
        isCellEdit: false,
		onClickRow: function (rowIndex, rowData) {
	        if (rowData) {
		        if (!EncCheck('GridMonSettle')) return;
		    }
        },
	    onDblClickRow: function (rowIndex, rowData) { 
            PHA_GridEditor.Edit({
	            gridID: 'GridMonSettle',
	            index: rowIndex,
	            field: 'locId',
	        });
	    }
    };
    PHA.Grid('GridMonSettle', dataGridOption);
}



function Clean()
{
	$('#GridMonSettle').datagrid('clearSelections');   
    $('#GridMonSettle').datagrid('clear');
}

function  Query(){
	Clean();
    $('#GridMonSettle').datagrid('query', {
        pJson : JSON.stringify({hospId : PHA_COM.Session.HOSPID})
    });
}

function AddSAL(){
    PHA_GridEditor.Add({
		gridID: 'GridMonSettle',
		field: 'locId'
	});
}

function EncCheck(gridID){
	if (!PHA_GridEditor.End(gridID)) {
        var gridOptions = $('#' + gridID).datagrid('options');
        var editIndex = gridOptions.editIndex;
        if (editIndex >= 0) {
            PHA_GridEditor.popoverTips('第' + (editIndex + 1) + '行, 有必填项未填写, 请先完成编辑！');
            return false;
        }
	}
	return true;
}

function SaveSAL(){
	if (!EncCheck('GridMonSettle')) return;
    var gridChanges = $('#GridMonSettle').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (!gridChangeLen){
	    PHA.Msg('alert' ,"没有需要保存的数据！");
	    return;
    }

    var pJson = {
	    hospId : PHA_COM.Session.HOSPID,
	    rows   : gridChanges
    } 
	PHA.CM(
        {
            pClassName : APINAME,  
            pMethodName: 'Save',
            pJson   : JSON.stringify(pJson),
        },
        function (retData) {
	        if (PHA.Ret(retData)) {
				Query();
			}
        }
    )
    /*
    $.cm(
        {
            ClassName : 'PHA.IN.MonSettle.Save',  
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
    */
}

function DeleteSAL(){
	var gridSelect = $('#GridMonSettle').datagrid('getSelected');
    if (gridSelect == null) {
	    PHA.Msg('alert' ,"请选择需要删除的记录！");
        return;
    }
    var msId = gridSelect.msId || '';
    if (msId == '') {
        var rowIndex = $('#GridMonSettle').datagrid('getRowIndex', gridSelect);
        $('#GridMonSettle').datagrid('deleteRow', rowIndex);
        return;
    } 
    
    $.messager.confirm('确认对话框', '您确定删除吗？', function (r) {
        if (r) {
            $.cm(
			    {
			        ClassName : 'PHA.IN.MonSettle.Save',  
			        MethodName: 'Delete',
			        HospId    : PHA_COM.Session.HOSPID,
			        MonSId	  : msId,
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
    });
}

function DefaQuery(){
    setTimeout(function () { Query(); }, 500)
}