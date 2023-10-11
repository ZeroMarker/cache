// scripts/pha/in/v3/StkLocCatGroup/StkLocCatGroup.js  
/**
 * 模块		: 科室人员类组权限维护
 * 编写日期	: 2021-08-31
 * 编写人	: yangsj
 */
PHA_COM.ResizePhaColParam.auto = false;
var SessionLoc  = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionHosp = session['LOGON.HOSPID'];
$(function () {
    InitDict();  // 初始化字典
    InitGrid();  // 初始化表格
    InitHosp();  // 初始化医院
    InitEvent(); // 绑定事件
    QueryLoc();  // 加载查询方法
});

function InitHosp() {
    var hospComp = GenHospComp("PHA-IN-LocStkCatGrp",'', { width: 280 });           // DHC_StkCatGroup   PHA-IN-LocStkCatGrp
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
        QueryLoc();
    };
    var defHosp = $cm(
        {
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: 'PHA-IN-LocStkCatGrp',
            HospID: PHA_COM.Session.HOSPID
        },
        false
    );
    PHA_COM.Session.HOSPID = defHosp;
    PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
}

function InitEvent(){
	$('#LocCode').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            QueryLoc();
        }
    });
    
    $('#LocDesc').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            QueryLoc();
        }
    });
}

function InitDict(){
	GridCmbScg = PHA.EditGrid.ComboBox(
        {
            required: true,
            tipPosition: 'top',
            url: PHA_STORE.DHCStkCatGroup().url,
        },
        { lnkField: 'Hosp', lnkGrid: 'GridLoc', lnkQName: 'HospId' }
    );
    GridCmbUser = PHA.EditGrid.ComboBox(
        {
            required: true,
            tipPosition: 'top',
            url: PHA_STORE.LocUser(PHA_COM.Session.CTLOCID).url,
        },
        { lnkField: 'Loc', lnkGrid: 'GridLoc', lnkQName: 'Loc' }
    );
}

function InitDictByHosp(){
	
}

function InitDictByLoc(){
	var gridSelect = $('#GridLoc').datagrid('getSelected') || '';
    var Loc = gridSelect ? gridSelect.Loc : "";
	GridCmbUser = PHA.EditGrid.ComboBox(
        {
            required: true,
            tipPosition: 'top',
            url: PHA_STORE.LocUser(Loc).url,
        }
    );
}

function InitGrid(){
	InitGridLoc();
	InitGridLocScg();
	InitGridLocScgUser();
	InitGridLocUser();
	InitGridLocUserScg();
}

function InitGridLoc(){
	var columns = [
        [
            // PhManf,ManfCode,ManfName,Tel,Address,State
            { field: 'Loc', 		title: 'Loc', 			hidden: true },
            { field: 'LocCode', 	title: '科室代码',  	width: 100},
            { field: 'LocDesc', 	title: '科室名称', 		width: 200},
            { field: 'Hosp', 		title: 'Hosp', 			hidden: true },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        gridSave: false,
        queryParams: {
            ClassName: 'PHA.IN.CTLoc.Query',
            QueryName: 'LocList',
            HospId   : PHA_COM.Session.HOSPID,
            GroupId  : '',
            page	 : 1, 
            rows	 : 99999
            
        },
        pagination: false,
        fitColumns: true,
        
        pageNumber:1,
		pageSize:1000,
        //idField: 'Loc',
        columns: columns,
        toolbar: '#GridLocBar',
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
		        if (rowData) {
			        var Loc = rowData.Loc
	                QueryLocScg();
	                QueryLocUser();
	                InitDictByLoc()
	            }
	        },
    };
    PHA.Grid('GridLoc', dataGridOption);
}
function InitGridLocScg(){
		var columns = [
        [
            // LocScg, Scg, ScgCode, ScgDesc, Default
            { field: 'LocScg', 		title: 'LocScg', 	hidden: true 	},
            { field: 'ScgCode', 	title: '代码',  	width: 100		},
            { field: 'Scg', 		title: '描述', 		width: 150 , 	descField: 'ScgDesc', 	editor: GridCmbScg,
            	formatter: function (value, row, index) {
                    return row.ScgDesc;
                },
            },
            { field: 'ScgDesc', 	title: '描述', 		width: 225, 	hidden: true },
            { field: 'Default', 	title: '缺省标志', 	width: 80, 		align: 'center',		formatter: ScgFormatter},
        ],
    ];
    var dataGridOption = {
        url: $URL,
        gridSave: false,
        queryParams: {
            ClassName: 'PHA.IN.StkLocCatGroup.Query',
            QueryName: 'LocScgList',
            Loc      : "",
            HospId   : ""
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        idField: 'LocScg',
        columns: columns,
        toolbar: '#GridLocScgBar',
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
	        if (rowData.LocScg) {
                QueryLocScgUser();
            }
	    },
	    onLoadSuccess: function (data) {
            $('.hisui-switchboxlocscg').switchbox();
        },
        onDblClickRow: function (rowIndex, rowData) {
	        if (!rowData.LocScg){
		        PHA_GridEditor.Edit({
					gridID: "GridLocScg",
					index: rowIndex,
					field: "Scg"
				});
	        }
	    }
    };
    PHA.Grid('GridLocScg', dataGridOption);

}
function InitGridLocScgUser(){
		var columns = [
        [
            // LSU, User,UserCode,UserName
            { field: 'LSU', 		title: 'LSU', 		width: 200 ,	hidden: true },
            { field: 'UserCode', 	title: '代码',  	width: 100},
            { field: 'User', 		title: '名称', 		width: 200,		descField: 'UserName', editor: GridCmbUser,
            	formatter: function (value, row, index) {
                    return row.UserName;
                }
            },
            { field: 'UserName', 	title: '名称', 		width: 200 ,	hidden: true },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        gridSave: false,
        queryParams: {
            ClassName: 'PHA.IN.StkLocCatGroup.Query',
            QueryName: 'LocScgUserList',
            LocScg   : "",
            HospId   : ""
        },
        pagination: false,
        //fitColumns: true,
        fit: true,
        //idField: 'User',
        columns: columns,
        toolbar: '#GridLocScgUserBar',
        exportXls: false,
        onDblClickRow: function (rowIndex, rowData) {
	        if (!rowData.LSU){
		        PHA_GridEditor.Edit({
					gridID: "GridLocScgUser",
					index: rowIndex,
					field: "User"
				});
	        }
	    }
    };
    PHA.Grid('GridLocScgUser', dataGridOption);
}
function InitGridLocUser(){
		var columns = [
        [
            // PhManf,ManfCode,ManfName,Tel,Address,State
            { field: 'User', 		title: 'User', 		hidden: true },
            { field: 'UserCode', 	title: '代码',  		width: 100},
            { field: 'UserName', 	title: '名称', 			width: 200},
        ],
    ];
    var dataGridOption = {
        url: $URL,
        gridSave: false,
        queryParams: {
            ClassName: 'PHA.IN.StkLocCatGroup.Query',
            QueryName: 'LocUserList',
            Loc		 : "",
            HospId   : ""
        },
        pagination: false,
       	fitColumns: true,
        fit: true,
        //idField: 'PhManf',
        columns: columns,
        //toolbar: '#GridPhManfBar',
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
		        if (rowData) {
	                QueryLocUserScg();
	            }
	    },
    };
    PHA.Grid('GridLocUser', dataGridOption);

}
function InitGridLocUserScg(){
		var columns = [
        [
            // useType, SLUCG, ScgCode, ScgDesc, Default
            { field: 'SLUCG', 		title: 'SLUCG', 		width: 100, 	hidden: true 	},
            { field: 'useType', 	title: '使用类型',  	width: 100, 	align: 'center',		formatter:UseStateFormatter, 	styler:UseStateStyler},
            { field: 'ScgCode', 	title: '代码', 			width: 100		},
            { field: 'Scg', 	    title: '描述', 			width: 100,		descField: 'ScgDesc',	editor: GridCmbScg,
            	formatter: function (value, row, index) {
                    return row.ScgDesc;
                }
            },
            { field: 'ScgDesc', 	title: '描述', 			width: 200,		hidden: true },
            { field: 'Default', 	title: '缺省标志', 		width: 80,		align: 'center',	formatter: UserFormatter},
        ]
    ];
    var dataGridOption = {
        url: $URL,
        gridSave: false,
        queryParams: {
            ClassName: 'PHA.IN.StkLocCatGroup.Query',
            QueryName: 'LocUserScgList',
            Loc      : "",
            User     : ""
        },
        pagination: false,
        //fitColumns: true,
        fit: true,
        //idField: 'PhManf',
        columns: columns,
        toolbar: '#GridLocUserScgBar',
        exportXls: false,
        onDblClickRow: function (rowIndex, rowData) {
	        if ((!rowData.SLUCG)&&(rowData.useType!="public" )){
		        PHA_GridEditor.Edit({
					gridID: "GridLocUserScg",
					index: rowIndex,
					field: "Scg"
				});
	        }
	    },
	    onLoadSuccess: function (data) {
            $('.hisui-switchboxlocuserscg').switchbox();
        }
    };
    PHA.Grid('GridLocUserScg', dataGridOption);
}

// 查询方法集中
function QueryLoc()
{
	Clean();	
	var LocCode = $('#LocCode').val()
	var LocDesc = $('#LocDesc').val()
	$('#GridLoc').datagrid('query', {
        HospId   : PHA_COM.Session.HOSPID,
        GroupId  : PHA_COM.Session.GROUPID,
        LocCode  : LocCode,
        LocDesc  : LocDesc,
        page	 : 1, 
        rows	 : 99999
    });
}

function QueryLocScg()
{
	CleanLocScg();
	CleanLocScgUser();
	var gridSelect = $('#GridLoc').datagrid('getSelected') || '';
    var Loc = gridSelect ? gridSelect.Loc : "";
    if (Loc == "") return;
	$('#GridLocScg').datagrid('query', {
        Loc : Loc,
        page	 : 1, 
        rows	 : 99999
    });
}

function QueryLocScgUser()
{
	//CleanLocScgUser();
	var gridSelect = $('#GridLocScg').datagrid('getSelected') || '';
    var LocScg = gridSelect ? gridSelect.LocScg : "";
    if (LocScg == "") return;
	$('#GridLocScgUser').datagrid('query', {
        LocScg : LocScg,
        page	 : 1, 
        rows	 : 99999
    });
}

function QueryLocUser()
{	
	CleanLocUser();
	CleanLocUserScg();
	var gridSelect = $('#GridLoc').datagrid('getSelected') || '';
    var Loc = gridSelect ? gridSelect.Loc : "";
    if (Loc == "") return;
	$('#GridLocUser').datagrid('query', {
        Loc : Loc,
        page	 : 1, 
        rows	 : 99999
    });
}

function QueryLocUserScg()
{
	var gridSelect = $('#GridLocUser').datagrid('getSelected') || '';
    var User = gridSelect ? gridSelect.User : "";
    if (User == '') return;
    var gridSelect = $('#GridLoc').datagrid('getSelected') || '';
    var Loc = gridSelect ? gridSelect.Loc : "";
    if (Loc == "") return;
    $('#GridLocUserScg').datagrid('query', {
        Loc : Loc,
        User: User,
        page	 : 1, 
        rows	 : 99999
    });
}

// 样式方法集中
function ScgFormatter(value, rowData, rowIndex)
{
	var LocScg = rowData.LocScg;
    var IndexString = JSON.stringify(rowIndex);
    if (value == 'Y') {
        return (
            "<div class=\"hisui-switchboxlocscg\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('是') + "',offText:'" + $g('否') + "',checked:" +
            'true' +
            ",disabled:false,onSwitchChange:function(e, obj){UpdateLocScg(obj.value,'" +
            LocScg +
            "'," +
            IndexString +
            ')}"></div>'
        );
    } else {
        return (
            "<div class=\"hisui-switchboxlocscg\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('是') + "',offText:'" + $g('否') + "',checked:" +
            'false' +
            ",disabled:false,onSwitchChange:function(e, obj){UpdateLocScg(obj.value,'" +
            LocScg +
            "'," +
            IndexString +
            ')}"></div>'
        );
    }
}

function UserFormatter(value, rowData, rowIndex)
{
	var SLUCG = rowData.SLUCG;
    var IndexString = JSON.stringify(rowIndex);
    if (value == 'Y') {
        return (
            "<div class=\"hisui-switchboxlocuserscg\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('是') + "',offText:'" + $g('否') + "',checked:" +
            'true' +
            ",disabled:false,onSwitchChange:function(e, obj){UpdateLocUserScg(obj.value,'" +
            SLUCG +
            "'," +
            IndexString +
            ')}"></div>'
        );
    } else if (value == 'N'){
        return (
            "<div class=\"hisui-switchboxlocuserscg\"  style=\"margin-left:5px\" data-options=\"onClass:'primary',offClass:'gray',onText:'" + $g('是') + "',offText:'" + $g('否') + "',checked:" +
            'false' +
            ",disabled:false,onSwitchChange:function(e, obj){UpdateLocUserScg(obj.value,'" +
            SLUCG +
            "'," +
            IndexString +
            ')}"></div>'
        );
    }
    else{
	    return ("");
    }
}


function UseStateFormatter(value, row, index){
	if (value == 'single') {
        return "已维护";
    } else if(value == 'public'){
        return "公共";
    }else {
        return "";
    }
}

function UseStateStyler(value, row, index){
     switch (value) {
         case 'single':
             colorStyle = 'background:#51b80c;color:white;';
             break;
         case 'public':
             colorStyle = 'background:#f1c516;color:white;';
             break;
         default:
             colorStyle = 'background:white;color:black;';
             break; 
     }
     return colorStyle;
}

/// 新增行方法集中
function AddLocScg(){
	var gridSelect = $('#GridLoc').datagrid('getSelected') || '';
    var Loc = gridSelect ? gridSelect.Loc : "";
    if (Loc == "") {
	    PHA.Msg('alert' ,"请选择一个科室！");
	    return;
    }
    CleanLocScgUser();
    $('#GridLocScg').datagrid('addNewRow', {
        editField: 'Scg',
    });
}


function AddLocScgUser(){
	var gridSelect = $('#GridLocScg').datagrid('getSelected') || '';
    var LocScg = gridSelect ? gridSelect.LocScg : "";
    if (LocScg == "") {
	    PHA.Msg('alert' ,"请选择一个科室类组！");
	    return;
    }
    $('#GridLocScgUser').datagrid('addNewRow', {
        editField: 'User',
    });
}

function AddLocUserScg(){
	var gridSelect = $('#GridLoc').datagrid('getSelected') || '';
    var Loc = gridSelect ? gridSelect.Loc : "";
    if (Loc == "") {
	    PHA.Msg('alert' ,"请选择一个科室！");
	    return;
    }
	var gridSelect = $('#GridLocUser').datagrid('getSelected') || '';
    var User = gridSelect ? gridSelect.v : "";
    if (User == "") {
	    PHA.Msg('alert' ,"请选择一个人员！");
	    return;
    }
    $('#GridLocUserScg').datagrid('addNewRow', {
        editField: 'Scg',
    });
}


/// 保存方法集中
function SaveLocScg(){
	var gridSelect = $('#GridLoc').datagrid('getSelected') || '';
    var Loc = gridSelect ? gridSelect.Loc : "";
    if (Loc == "") {
	    PHA.Msg('alert' ,"请选择一个科室！");
	    return;
    }
	$('#GridLocScg').datagrid('endEditing');
    var gridChanges = $('#GridLocScg').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (!gridChangeLen){
	    PHA.Msg('alert' ,"没有需要保存的数据！");
	    return
    }
    $.cm(
        {
            ClassName : 'PHA.IN.StkLocCatGroup.Save',  
            MethodName: 'SaveLocScg',
            Loc       : Loc,
            DetailData: JSON.stringify(gridChanges),
        },
        function (retData) {
            if(retData.code >= 0){
	            PHA.Msg('success' ,"保存成功！");
	            QueryLocScg();
            }
            else{
	            PHA.Msg('alert' ,"保存失败！" + retData.msg );
	            return
            }
        }
    );
}

function SaveLocScgUser(){
	var gridSelect = $('#GridLocScg').datagrid('getSelected') || '';
    var LocScg = gridSelect ? gridSelect.LocScg : "";
    if (LocScg == "") {
	    PHA.Msg('alert' ,"请选择一个科室类组！");
	    return;
    }
	$('#GridLocScgUser').datagrid('endEditing');
    var gridChanges = $('#GridLocScgUser').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (!gridChangeLen){
	    PHA.Msg('alert' ,"没有需要保存的数据！");
	    return
    }
    $.cm(
        {
            ClassName : 'PHA.IN.StkLocCatGroup.Save',  
            MethodName: 'SaveLocScgUser',
            LocScg      : LocScg,
            DetailData: JSON.stringify(gridChanges),
        },
        function (retData) {
            if(retData.code >= 0){
	            PHA.Msg('success' ,"保存成功！");
	            QueryLocScgUser();
            }
            else{
	            PHA.Msg('alert' ,"保存失败！" + retData.msg );
	            return
            }
        }
    );
}

function SaveLocUserScg(){
	var gridSelect = $('#GridLoc').datagrid('getSelected') || '';
    var Loc = gridSelect ? gridSelect.Loc : "";
    if (Loc == "") {
	    PHA.Msg('alert' ,"请选择一个科室！");
	    return;
    }
	var gridSelect = $('#GridLocUser').datagrid('getSelected') || '';
    var User = gridSelect ? gridSelect.User : "";
    if (User == "") {
	    PHA.Msg('alert' ,"请选择一个人员！");
	    return;
    }
	$('#GridLocUserScg').datagrid('endEditing');
    var gridChanges = $('#GridLocUserScg').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (!gridChangeLen){
	    PHA.Msg('alert' ,"没有需要保存的数据！");
	    return
    }
    $.cm(
        {
            ClassName : 'PHA.IN.StkLocCatGroup.Save',  
            MethodName: 'SaveLocUserScg',
            Loc       : Loc,
            User	  : User,
            DetailData: JSON.stringify(gridChanges),
        },
        function (retData) {
            if(retData.code >= 0){
	            PHA.Msg('success' ,"保存成功！");
	            QueryLocUserScg();
            }
            else{
	            PHA.Msg('alert' ,"保存失败！" + retData.msg );
	            return
            }
        }
    );
}


/// 更细方法集中
function UpdateLocScg(DefualtFlag, LocScg, IndexString){
	var Default = DefualtFlag ? "Y" : "N"
    $.cm(
	    {
	        ClassName : 'PHA.IN.StkLocCatGroup.Save',  
	        MethodName: 'UpdataLocScgDefault',
	        LocScg    : LocScg,
	        Default	  : Default
	    },
	    function (retData) {
	        if(retData.code >= 0){
	            PHA.Msg('success' ,"更新成功！");
	        }
	        else{
	            PHA.Msg('alert' ,"更新失败！" + retData.msg );
	            QueryLocScg();
	        }
	    }
	);
}
function UpdateLocUserScg(DefualtFlag, SLUCG, IndexString){
	var Default = DefualtFlag ? "Y" : "N"
    $.cm(
	    {
	        ClassName : 'PHA.IN.StkLocCatGroup.Save',  
	        MethodName: 'UpdataLUSDefault',
	        SLUCG     : SLUCG,
	        Default	  : Default
	    },
	    function (retData) {
	        if(retData.code >= 0){
	            PHA.Msg('success' ,"更新成功！");
	        }
	        else{
	            PHA.Msg('alert' ,"更新失败！" + retData.msg );
	            QueryLocUserScg();
	        }
	    }
	);
}



/// 删除方法集中
function DeleteLocScg(){
	var gridSelect = $('#GridLocScg').datagrid('getSelected');
    if (gridSelect == null) {
	    PHA.Msg('alert' ,"请选择需要删除的记录！");
        return;
    }
    $.messager.confirm('确认对话框', '您确定删除吗？', function (r) {
        if (r) {
            var LocScg = gridSelect.LocScg || '';
            if (LocScg == '') {
                var rowIndex = $('#GridLocScg').datagrid('getRowIndex', gridSelect);
                $('#GridLocScg').datagrid('deleteRow', rowIndex);
            } else {
                    $.cm(
					    {
					        ClassName : 'PHA.IN.StkLocCatGroup.Save',  
					        MethodName: 'DeleteLocScg',
					        LocScg    : LocScg,
					    },
					    function (retData) {
					        if(retData.code >= 0){
					            PHA.Msg('success' ,"删除成功！");
					            QueryLocScg();
					            CleanLocScgUser();
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

function DeleteLocScgUser(){
	var gridSelect = $('#GridLocScgUser').datagrid('getSelected');
    if (gridSelect == null) {
	    PHA.Msg('alert' ,"请选择需要删除的记录！");
        return;
    }
    $.messager.confirm('确认对话框', '您确定删除吗？', function (r) {
        if (r) {
            var LSU = gridSelect.LSU || '';
            if (LSU == '') {
                var rowIndex = $('#GridLocScgUser').datagrid('getRowIndex', gridSelect);
                $('#GridLocScgUser').datagrid('deleteRow', rowIndex);
            } else {
                    $.cm(
					    {
					        ClassName : 'PHA.IN.StkLocCatGroup.Save',  
					        MethodName: 'DeleteLocScgUser',
					        LSU       : LSU,
					    },
					    function (retData) {
					        if(retData.code >= 0){
					            PHA.Msg('success' ,"删除成功！");
					            QueryLocScgUser();
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

function DeleteLocUserScg(){
	var gridSelect = $('#GridLocUserScg').datagrid('getSelected');
    if (gridSelect == null) {
	    PHA.Msg('alert' ,"请选择需要删除的记录！");
        return;
    }
    var useType = gridSelect.useType || '';
    if (useType == "public"){
	    PHA.Msg('alert' ,"公共类组属性不可删除！");
        return;
    }
    $.messager.confirm('确认对话框', '您确定删除吗？', function (r) {
        if (r) {
            var SLUCG = gridSelect.SLUCG || '';
            if (SLUCG == '') {
                var rowIndex = $('#GridLocUserScg').datagrid('getRowIndex', gridSelect);
                $('#GridLocUserScg').datagrid('deleteRow', rowIndex);
            } else {
                    $.cm(
					    {
					        ClassName : 'PHA.IN.StkLocCatGroup.Save',  
					        MethodName: 'DeleteLocScgUser',
					        LSU       : SLUCG,
					    },
					    function (retData) {
					        if(retData.code >= 0){
					            PHA.Msg('success' ,"删除成功！");
					            QueryLocUserScg();
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

// 清除方法集中
function Clean()
{
	CleanLoc();
	CleanGridI();
}

function CleanGridI()
{
	CleanLocScg();
	CleanLocScgUser();
	CleanLocUser();
	CleanLocUserScg();
}

function CleanLoc()
{
	 PHA.DomData('#GridLocBar', {
    	 doType: 'clear',
	 });
	 $('#GridLoc').datagrid('clearSelections');   
     $('#GridLoc').datagrid('clear');
}

function CleanLocScg()
{
	$('#GridLocScg').datagrid('clearSelections');   
    $('#GridLocScg').datagrid('clear');
}

function CleanLocScgUser()
{
	$('#GridLocScgUser').datagrid('clearSelections');   
    $('#GridLocScgUser').datagrid('clear');
}

function CleanLocUser()
{
	
	$('#GridLocUser').datagrid('clearSelections');   
    $('#GridLocUser').datagrid('clear');
}

function CleanLocUserScg()
{
	$('#GridLocUserScg').datagrid('clearSelections');   
    $('#GridLocUserScg').datagrid('clear');
}