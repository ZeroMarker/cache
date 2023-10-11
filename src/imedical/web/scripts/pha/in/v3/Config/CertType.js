/**
 * 模块:     证件类型维护
 * 编写日期: 2021-05-07
 * 编写人:   yangsj
 */
var SessionLoc  = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionHosp = session['LOGON.HOSPID'];
$(function () {
    InitGrid();				//初始化grid
});

function InitGrid(){
	InitVendorCertTypeGrid();
	InitManfCertTypeGrid();
}

var columns = [
        [  //RowId,Type,Code,FullName,ShortName,Num,ShowFlag
            {title: 'RowId',	field: 'RowId',		width:50,		hidden: true},
			{title: '代码',		field: 'Code',		width:150,		editor:{type:'validatebox',	options:{required:true}}},
			{title: '全称',		field: 'FullName',	width:200,		editor:{type:'validatebox',	options:{required:true}}},
			{title: '简称',		field: 'ShortName',	width:200,		editor:{type:'validatebox',	options:{}}}, 
			{title: '序号',		field: 'Num',		width:500,		align:'left',		editor:{type:'numberbox',options:{required:true}}},
			/*{title: '是否展示',	field: 'ShowFlag',	width:100,      hidden: true,
				editor: {type: 'icheckbox',options: {on: 'Y',off: 'N'}},
				formatter: YNformatter
			}*/
            
        ],
    ]
function YNformatter(value, row, index){
	if (value == 'Y') {
        return PHA_COM.Fmt.Grid.Yes.Chinese;
    } else {
        return PHA_COM.Fmt.Grid.No.Chinese;
    }
}


function InitVendorCertTypeGrid(){
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.Cert.Query',
            QueryName: 'QueryCertALL',
            Type	 : 'Vendor'
        },
        gridSave: false,
        pagination: true,
        columns: columns,
        fitColumns: false,
        enableDnd: false,
        onClickRow: function (rowIndex, rowData) {},
        onDblClickCell: function (rowIndex, field, value) {},
        toolbar: '#VendorCertTypeGridBar',
        onDblClickRow: function (rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'Code',
            });
        }
    };
    PHA.Grid('VendorCertTypeGrid', dataGridOption);
}


function InitManfCertTypeGrid(){
	
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.Cert.Query',
            QueryName: 'QueryCertALL',
            Type	 : 'Manf'
        },
        gridSave:false,
        pagination: true,
        columns: columns,
        fitColumns: false,
        enableDnd: false,
        onClickRow: function (rowIndex, rowData) {},
        onDblClickCell: function (rowIndex, field, value) {},
        toolbar: '#ManfCertTypeGridBar',
        onDblClickRow: function (rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'Code',
            });
        }
    };
    PHA.Grid('ManfCertTypeGrid', dataGridOption);
}

function AddV(){
	$("#VendorCertTypeGrid").datagrid('addNewRow', {
        editField: 'Code'
    });
}

function AddM(){
	$("#ManfCertTypeGrid").datagrid('addNewRow', {
        editField: 'Code'
    });
}


function SaveV(){
	$('#VendorCertTypeGrid').datagrid('endEditing');
    var gridChanges = $('#VendorCertTypeGrid').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if(gridChangeLen==0){	   
	   PHA.Msg("alert", $g("无需要保存数据！"))
	   return;
    }
    var paramsStr=""
    // RowId,Code,FullName,ShortName,Num,ShowFlag
    for (var i = 0; i < gridChangeLen; i++) {
        var iData	  = gridChanges[i];
        var RowId 	  = iData.RowId 	|| "";
        var Code 	  = iData.Code 		|| "";
        var FullName  = iData.FullName 	|| "";
        var ShortName = iData.ShortName || "";
        var Num 	  = iData.Num 		|| "";
        //var ShowFlag  = iData.ShowFlag 	|| "";
        
        var params = [RowId, Code, FullName, ShortName, Num].join("^")
        if(params.replace("^")=="") continue;
        if(Code==""||FullName==""||Num==""){
	        PHA.Msg("alert", $g("代码/全称/序号不能为空！"))
	   		return;
        }
        paramsStr = (paramsStr == "") ? params : paramsStr + "!!" + params;
    }
    $.cm(
        {
            ClassName: 'PHA.IN.Cert.Save',  
            MethodName: 'SaveCertTypeAll',
            pOrgType:"Vendor",
            paramsStr:paramsStr
        },
        function (retData) {
            if(retData.code>=0){
	            PHA.Msg("success", $g("保存成功!"))
	            $('#VendorCertTypeGrid').datagrid('query', {});
            }
            else{
	            PHA.Popover({ showType: 'show', msg: retData.msg, type: 'alert' });
	            return
            }
        }
    );
}

function InitCert(){
	 $.messager.confirm($g('确认对话框'), $g('您正在初始化, 这会同时删除之前的经营企业和生产企业证件类型, 是否继续?'), function(r) {
        if (r) {
            $.cm({
				ClassName: 'PHA.IN.Cert.Save',
				MethodName: 'ResetCert',
			},function(retData){
				if(retData.code>=0){
					PHA.Msg("success", $g("初始化成功!"))
					$('#VendorCertTypeGrid').datagrid('query', {});
					$('#ManfCertTypeGrid').datagrid('query', {});
				}else{
					PHA.Msg("alert", retData.msg)
					return;
				}
			});
        }
    })
}

function SaveM(){
	$('#ManfCertTypeGrid').datagrid('endEditing');
    var gridChanges = $('#ManfCertTypeGrid').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if(gridChangeLen==0){	   
	   PHA.Msg("alert", $g("无需要保存数据！"))
	   return;
    }
    var paramsStr=""
    // RowId,Code,FullName,ShortName,Num,ShowFlag
    for (var i = 0; i < gridChangeLen; i++) {
        var iData	  = gridChanges[i];
        var RowId 	  = iData.RowId 	|| "";
        var Code 	  = iData.Code 		|| "";
        var FullName  = iData.FullName 	|| "";
        var ShortName = iData.ShortName || "";
        var Num 	  = iData.Num 		|| "";
        //var ShowFlag  = iData.ShowFlag 	|| "";
        
        var params = [RowId, Code, FullName, ShortName, Num].join("^")
        if(params.replace("^")=="") continue;
        if(Code==""||FullName==""||Num==""){
	        PHA.Msg("alert", $g("代码/全称/序号不能为空！"))
	   		return;
        }
        paramsStr = (paramsStr == "") ? params : paramsStr + "!!" + params;
    }
    $.cm(
        {
            ClassName: 'PHA.IN.Cert.Save',  
            MethodName: 'SaveCertTypeAll',
            pOrgType:"Manf",
            paramsStr:paramsStr
        },
        function (retData) {
            if(retData.code>=0){
	            PHA.Popover({ showType: 'show', msg: '保存成功!', type: 'success' });
	            $('#ManfCertTypeGrid').datagrid('query', {});
            }
            else{
	            PHA.Popover({ showType: 'show', msg: retData.msg, type: 'alert' });
	            return
            }
        }
    );
}