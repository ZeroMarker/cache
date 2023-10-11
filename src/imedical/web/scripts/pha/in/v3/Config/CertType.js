/**
 * ģ��:     ֤������ά��
 * ��д����: 2021-05-07
 * ��д��:   yangsj
 */
var SessionLoc  = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionHosp = session['LOGON.HOSPID'];
$(function () {
    InitGrid();				//��ʼ��grid
});

function InitGrid(){
	InitVendorCertTypeGrid();
	InitManfCertTypeGrid();
}

var columns = [
        [  //RowId,Type,Code,FullName,ShortName,Num,ShowFlag
            {title: 'RowId',	field: 'RowId',		width:50,		hidden: true},
			{title: '����',		field: 'Code',		width:150,		editor:{type:'validatebox',	options:{required:true}}},
			{title: 'ȫ��',		field: 'FullName',	width:200,		editor:{type:'validatebox',	options:{required:true}}},
			{title: '���',		field: 'ShortName',	width:200,		editor:{type:'validatebox',	options:{}}}, 
			{title: '���',		field: 'Num',		width:500,		align:'left',		editor:{type:'numberbox',options:{required:true}}},
			/*{title: '�Ƿ�չʾ',	field: 'ShowFlag',	width:100,      hidden: true,
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
	   PHA.Msg("alert", $g("����Ҫ�������ݣ�"))
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
	        PHA.Msg("alert", $g("����/ȫ��/��Ų���Ϊ�գ�"))
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
	            PHA.Msg("success", $g("����ɹ�!"))
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
	 $.messager.confirm($g('ȷ�϶Ի���'), $g('�����ڳ�ʼ��, ���ͬʱɾ��֮ǰ�ľ�Ӫ��ҵ��������ҵ֤������, �Ƿ����?'), function(r) {
        if (r) {
            $.cm({
				ClassName: 'PHA.IN.Cert.Save',
				MethodName: 'ResetCert',
			},function(retData){
				if(retData.code>=0){
					PHA.Msg("success", $g("��ʼ���ɹ�!"))
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
	   PHA.Msg("alert", $g("����Ҫ�������ݣ�"))
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
	        PHA.Msg("alert", $g("����/ȫ��/��Ų���Ϊ�գ�"))
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
	            PHA.Popover({ showType: 'show', msg: '����ɹ�!', type: 'success' });
	            $('#ManfCertTypeGrid').datagrid('query', {});
            }
            else{
	            PHA.Popover({ showType: 'show', msg: retData.msg, type: 'alert' });
	            return
            }
        }
    );
}