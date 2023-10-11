/*
    Creator:zhaozhiduan
    CreataDate:2020.11.18
    Description:门诊药房科室维护-hisui
*/
var GridCmbLoc="";
var GridCmbUser="";
var GridCmbWinType="";
var GridCmbPyPer="";
var GridCmbFyPer="";
var GridCmbWinLoc=""
$(function () {
    InitHosp();
    InitDict();
    InitGridDict();
    InitGridPhLoc();        //门诊的药房列表
    InitGridPhLocPer();     //门诊的药房的人员权限列表
    InitGridPhLocWin();     //门诊的药房的窗口列表
    InitGridPhWinLoc();     //门诊的药房的窗口指定科室
    InitGridPhFlow();       //门诊的药房的流程
    InitEvent();
    $.extend($.fn.validatebox.defaults.rules, {
        // 是否正数
        IPChk: {
            validator: function(value, param) {
                var regTxt = /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/;
                return regTxt.test(value);
            },
            message: $g('请输入正确的ip')
        }
    });
});
function InitDict(){
    
    PHA.ComboBox("arithmetFlag",{
        required: true,
        data:[
            {RowId:"1",Description:$g("按照次序")},
            {RowId:"2",Description:$g("按照工作量")}
        ]
    })
    PHA.ComboBox("phLocList",{
	    blurValidValue:true, 
	    width:230,
        url:PHAOP_STORE.PhLocByHosp().url,
        onLoadSuccess: function (data) {
            $('#phLocList').combobox('setValue',"")
        },
        onSelect:function(rowIndex, rowData){
	        Query()
        },
        onHidePanel: function() {
            Query();
        }
    })
    
}
function InitGridDict(){
    GridCmbLoc = PHA.EditGrid.ComboBox({
        required: true,
        tipPosition: 'top',
        url: PHAOP_STORE.UserLoc().url+"&phlFlag=0",
        defaultFilter: 5,
        loadFilter: function (rowsData) {
            var newRowsData = [];
            var locRowsData = $('#gridPhLoc').datagrid('getRows');
            for (var i = 0; i < rowsData.length; i++) {
                var pushFlag = true;
                var rowID = rowsData[i].RowId;
                for (var j = 0; j < locRowsData.length; j++) {
                    var loc = locRowsData[j].locRowId;
                    if (loc === rowID) {
                        pushFlag = false;
                        break;
                    }
                }
                if (pushFlag === true) {
                    newRowsData.push(rowsData[i]);
                }
            }
            return newRowsData;
        }
    });
    
    GridCmbUser = PHA.EditGrid.ComboBox({
        required: true,
        tipPosition: 'top',
        url:PHAOP_STORE.SSUser().url,
        defaultFilter: 5,
        onHidePanel: function() {
            var editIndex = $("#gridPhLocPer").datagrid('options').editIndex;
            if (editIndex == undefined) {
                return;
            }
            var UserId = $(this).combobox("getValue");  //当前combobox的值
            if ((UserId == "") || (UserId == null)) {
                return;
            }
            var gridSelect = $('#gridPhLocPer').datagrid("getSelected");            
            gridSelect.UserId = UserId;
            //gridSelect.phPerName = rowData.Description;
        },
        loadFilter: function (rowsData) {
            var newRowsData = [];
            var UserRowsData = $('#gridPhLocPer').datagrid('getRows');
            for (var i = 0; i < rowsData.length; i++) {
                var pushFlag = true;
                var rowID = rowsData[i].RowId;
                for (var j = 0; j < UserRowsData.length; j++) {
                    var UserId = UserRowsData[j].UserId;
                    if (UserId === rowID) {
                        pushFlag = false;
                        break;
                    }
                }
                if (pushFlag === true) {
                    newRowsData.push(rowsData[i]);
                }
            }

            return newRowsData;
        },
        onBeforeLoad: function(param) {
            var locRowId=session['LOGON.CTLOCID']
            var Selected=$("#gridPhLoc").datagrid("getSelected") || ""; 
            if(Selected!=""){
                locRowId=Selected.locRowId;
            }
            param.LocId = locRowId; 
        }
    });
    
    GridCmbWinType = PHA.EditGrid.ComboBox({
        required: true,
        url:PHAOP_STORE.WinType().url,
        onHidePanel: function() {
            var editIndex = $("#gridPhLocWin").datagrid('options').editIndex;
            if (editIndex == undefined) {
                return;
            }
            var winTypeDesc=$(this).combobox("getText");
            
            if ((winTypeDesc == "") || (winTypeDesc == null)) {
                return;
            }
            var gridRows = $('#gridPhWinLoc').datagrid('getRows'); 
            var rowNum= gridRows.length
            if(winTypeDesc.indexOf($g("指定科室"))<0){
                 
                if(rowNum>0){
                    PHA.Popover({
                        msg: '非指定科室型窗口需要删除右侧指定科室',
                        type: 'alert'
                    });
                    return;
                }
            }else{
                if(rowNum==0){
                    PHA.Popover({
                        msg: '保存后需要指定科室',
                        type: 'alert'
                    });
                    return;
                }
            }
            //gridSelect.phPerName = rowData.Description;
        }

    
    })
    GridCmbPyPer = PHA.EditGrid.ComboBox({
        required: false,
        tipPosition: 'top',
        url:PHAOP_STORE.PhPerson().url,
        defaultFilter: 5,
        onBeforeLoad: function(param) {
            var locRowId=session['LOGON.CTLOCID']
            var Selected=$("#gridPhLoc").datagrid("getSelected") || ""; 
            if(Selected!=""){
                locRowId=Selected.locRowId;
            }
            param.locId = locRowId; 
            param.perFlag = 2; 
        }
    
    })
    GridCmbFyPer = PHA.EditGrid.ComboBox({
        required: false,
        tipPosition: 'top',
        url:PHAOP_STORE.PhPerson().url,
        defaultFilter: 5,
        onBeforeLoad: function(param) {
            var locRowId=session['LOGON.CTLOCID']
            var Selected=$("#gridPhLoc").datagrid("getSelected") || ""; 
            if(Selected!=""){
                locRowId=Selected.locRowId;
            }
            param.locId = locRowId; 
            param.perFlag = 1; 
        }
    
    })
    GridCmbWinLoc = PHA.EditGrid.ComboBox({
        required: true,
        tipPosition: 'top',
        url:PHAOP_STORE.CTLOC().url+"&TypeStr=E",
        defaultFilter: 5,
        onBeforeLoad: function(param) {
            if (param.q == undefined) {
                param.q = $('#gridPhWinLoc').datagrid("getSelected").locDesc;
            }
            param.QText = param.q; 
            param.HospId = PHA_COM.Session.HOSPID; 
        }
    
    })
}

function InitEvent(){
    //门诊的药房科室
    $('#btnAddPhLoc').on('click', function () {
        Clear();
        $('#gridPhLoc').datagrid('addNewRow', {
            editField: 'locRowId'
        });
    });
    $('#btnSavePhLoc').on('click', SavePhLoc);
    $('#btnDelPhLoc').on('click', DelPhLoc);
    //门诊的药房科室流程配置
    $('#btnAddFlow').on('click', function () {
        var Selected=$("#gridPhLoc").datagrid("getSelected") || "";
        if(Selected==""){return}
        var phLocId=Selected.phLocId ||"";
        if(phLocId===""){return}
        $('#gridPhlFlow').datagrid('addNewRow', {
            editField: 'flowCode'
        });
        var rowIndex = $('#gridPhlFlow').datagrid('getRows').length - 1;
        $('#gridPhlFlow').datagrid("checkRow",rowIndex);
    });
    //$('#btnSaveFlow').on('click', SavePhlFlow);
    $('#btnDelFlow').on('click', DelPhlFlow);
    PHA_UX.Translate({ buttonID: 'btnTranslateFlow', gridID: 'gridPhlFlow', idField: 'phlFlowId', sqlTableName: 'CF_PHA_OP.PHA_OP_Flow' });
    //门诊的药房科室配置
    $('#btnSavePhlConfig').on('click', SavePhlConfig);
    //门诊的药房的人员
    $('#btnAddPer').on('click', function () {
        var Selected=$("#gridPhLoc").datagrid("getSelected") || "";
        if(Selected==""){return}
        var phLocId=Selected.phLocId ||"";
        if(phLocId===""){return}
        $('#gridPhLocPer').datagrid('addNewRow', {
            editField: 'phPerName'
        });
    });
    $('#btnSavePer').on('click', SavePhPer);
    $('#btnDelPer').on('click', DelPhPer);
    PHA_UX.Translate({ buttonID: 'btnTranslatePer', gridID: 'gridPhLocPer', idField: 'phPerId', sqlTableName: 'DHC_PHPERSON' });
   //门诊的药房的窗口
    $('#btnAddWin').on('click', function () {
        var Selected=$("#gridPhLoc").datagrid("getSelected") || "";
        if(Selected==""){return}
        var phLocId=Selected.phLocId ||"";
        if(phLocId===""){return}
        $('#gridPhWinLoc').datagrid('clear');
        $('#gridPhLocWin').datagrid('addNewRow', {
            editField: 'phWinDesc'
        });
    });
    $('#btnSaveWin').on('click', SavePhWin);
    $('#btnDelWin').on('click', DelPhWin);
    PHA_UX.Translate({ buttonID: 'btnTranslateWin', gridID: 'gridPhLocWin', idField: 'phWinId', sqlTableName: 'DHC_PHWINDOW' });

    //门诊的药房的窗口指定科室
    $('#btnAddWinLoc').on('click', function () {
        var Selected=$("#gridPhLocWin").datagrid("getSelected") || "";
        if(Selected==""){return}
        var phWinId=Selected.phWinId ||"";
        if(phWinId===""){return}
        $('#gridPhWinLoc').datagrid('addNewRow', {
            editField: 'locRowId'
        });
    });
    
    $('#btnSaveWinLoc').on('click', SavePhWinLoc);
    $('#btnDelWinLoc').on('click', DelPhWinLoc);

    $("input[type=checkbox]").on("change", function () {
        var val=$(this).checkbox('getValue');
        ElementRequired(this.id,val)
    })
    
    
    //页签切换
    $("#tabsOne").tabs({
        onSelect:function(title){
            if (title === $g('发药窗口')){
                $('#lyThird').layout();
            }
            QueryPhLocSetting()                 
        }
    })
    
    /* 触发界面的不可用*/
    ElementRequired("autoPrescAudit",false)
    ElementRequired("sendMachineFlag",false)
    ElementRequired("dispAsCall",false)
    ElementRequired("screenFlag",false)
    ElementRequired("reportFlag",false)
    ElementRequired("prescAuditFlag",false)
}
function InitGridPhLoc(){
    var columns = [[
        {
            field: 'phLocId',
            title: '门诊药房id',
            hidden: true,
            width: 100
        },
        {
            field: 'locRowId',
            title: '科室',
            descField: 'locDesc',
            width: 100,
            editor: GridCmbLoc,
            formatter: function(value, row, index) {
                return row.locDesc;
            }
        },
        {
            field: 'locDesc',
            title: '科室',
            hidden: true,
            width: 100,
            hidden: true
        }
    ]];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.OP.Config.PhLoc.Query',
            QueryName: 'QueryPhLoc',
            pJsonStr: JSON.stringify({ hospId: PHA_COM.Session.HOSPID }),
            rows: 999
        },
        pagination: false,
        columns: columns,
        toolbar: '#gridPhLocBar',
        enableDnd: false,
        fitColumns: true,
        rownumbers: true,
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('endEditing');
            QueryPhLocSetting();
        },
        onLoadSuccess: function (data) {
            if(data.total>0){
                //$('#gridPhLoc').datagrid("selectRow",0);
            }
            Clear();
        }
    };

    PHA.Grid('gridPhLoc', dataGridOption);

}
function FormActiveFlagChk(value, row, index){
    if (value === 'Y' || value === '1') {
        return true;
    } else {
        return false;
    }
}
// 门诊流程grid
function InitGridPhFlow(){

    var columns = [[
        {
            field: 'phlFlowId',
            title: '门诊流程id',
            hidden: true,
            width: 50
        },
        {
            field: 'activeFlag',
            width: 50,
            align: 'center',
            checkbox:true,
            checked:true
            
        },
        {
            field: 'flowCode',
            title: '流程序号',
            width: 60,
            editor: {
                type: 'numberbox',
                options: {
                    required: true
                }
            }
        },
        {
            field: 'flowPyDisp',
            title: '配发流程',
            width: 100,
            editor: {
                type: 'validatebox',
                options: {
                    required: true
                }
            }
        },
        {
            field: 'flowDirDisp',
            title: '直发药流程',
            width: 100,
            editor: {
                type: 'validatebox',
                options: {
                    required: true
                }
            }
        },
        {
            field: 'editDisable',
            title: '不可编辑',
            hidden: true,
            width: 100
        },
        {
            field: 'comFlag',
            title: '通用流程标志',
            hidden: true,
            width: 100
        }
    ]];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.OP.Config.PhLoc.Query',
            QueryName: 'QueryPhFlow',
            pJsonStr: JSON.stringify({ hospId: PHA_COM.Session.HOSPID }),
            rows: 999
        },
        pagination: false,
        columns: columns,
        toolbar: '#gridPhlFlowBar',
        enableDnd: false,
        fitColumns: true,
        rownumbers: false,
        exportXls: false,
        singleSelect:true,
        checkOnSelect:false,
        selectOnCheck:false,
        idField:'flowCode',
        onClickRow: function (rowIndex, rowData) {
            if(rowData.editDisable=="1"){
                //$(this).datagrid('endEditing');
            }
        },
        onDblClickRow: function (rowIndex, rowData) {
            if (rowData) {
                var comFlag = rowData.comFlag || "";    
                var phlFlowId = rowData.phlFlowId || "";    
                if((comFlag!="1")&&(phlFlowId =="")){
                    $(this).datagrid('beginEditRow', {
                        rowIndex: rowIndex,                     
                        editField: 'flowCode'
                    });
                }
                
            }
        },
        onCheck:function (rowIndex, rowData) {
            if (rowData) {
                if(rowData.flowCode=="30"){  //门诊报道
                    ElementRequired("reportFlag",1)
                }
                if(rowData.flowCode=="20"){  //处方审核
                    ElementRequired("prescAuditFlag",1)
                }
            }
        },
        onUncheck:function (rowIndex, rowData) {
            if (rowData) {
                if(rowData.flowCode=="30"){
                    ElementRequired("reportFlag",0)
                }
                if(rowData.flowCode=="20"){
                    ElementRequired("prescAuditFlag",0)
                }
            }
        },
        onLoadSuccess: function (data) {
            if(data.total>0){
                for(var i=0;i<data.total;i++){
                    var activeFlag=data.rows[i].activeFlag;
                    if(activeFlag=="Y") {
                        $('#gridPhlFlow').datagrid("checkRow",i);
                    }else{
                        $('#gridPhlFlow').datagrid("uncheckRow",i);
                    }
                    var editDisable=data.rows[i].editDisable;
                    if(editDisable=="1") {
                        $(".datagrid-row[datagrid-row-index=" + i + "] input[type='checkbox']")[0].disabled = true;
                    }
                    
                }
            }
            //$(".datagrid-header-check").attr("disabled",true);
            $(".datagrid-header-check").html("");
        }
    };

    PHA.Grid('gridPhlFlow', dataGridOption);

}
function InitGridPhLocPer(){
     var EG_CheckBox = {
        type: 'checkbox',
        options: {
            on: '1',
            off: '0'
        }
    };
    var columns = [[
        {
            field: 'phPerId',
            title: '药房人员id',
            hidden: true,
            width: 100
        },
        {
            field: 'phPerCode',
            title: '人员代码',
            width: 150
        },
        {
            field: 'UserId',
            title: '人员姓名',
            width: 150,
            hidden: true
        },
        {
            field: 'phPerName',
            title: '人员姓名',
            width: 150,
            descField: 'phPerName',
            width: 300,
            editor: GridCmbUser,
            formatter: function(value, row, index) {
                return row.phPerName;
            }
        },
        {
            field: 'auditFlag',
            title: '审核',
            width: 100,
            align: 'center',
            formatter: FormatterCheck,
            editor: EG_CheckBox,
            hidden: true,
        },
        {
            field: 'pyFlag',
            title: '配药',
            width: 100,
            align: 'center',
            formatter: FormatterCheck,
            editor: EG_CheckBox
        },
        {
            field: 'fyFlag',
            title: '发药',
            width: 100,
            align: 'center',
            formatter: FormatterCheck,
            editor: EG_CheckBox
            
        },
        {
            field: 'noActiveFlag',
            title: '无效',
            width: 100,
            align: 'center',
            formatter: FormatterCheck,
            editor: {
                type: 'icheckbox',
                options: {
                    on: '1',
                    off: '0'
                }
            }
            

        }
    ]];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.OP.Config.Person.Query',
            QueryName: 'QueryPerson',
            pJsonStr: "{}",
            rows: 999
        },
        pagination: false,
        columns: columns,
        toolbar: null,
        toolbar: '#gridPhLocPerBar',
        enableDnd: false,
        fitColumns: false,
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('endEditing');
        },
        onDblClickRow: function (rowIndex, rowData) {
            if (rowData) {
                var phPerId=rowData.phPerId;
                if(phPerId!=""){
                    $(this).datagrid('beginEditRow', {
                        rowIndex: rowIndex,                     
                        editField: 'auditFlag'
                    });
                    var gpp = $('#gridPhLocPer').datagrid('getEditor', { index:rowIndex, field: 'phPerName' });
                    //$(gpp.target).attr('disabled',true);
                     $(gpp.target).combobox('disable');
                     
                }
                else{
                    $(this).datagrid('beginEditRow', {
                        rowIndex: rowIndex,                    
                        editField: 'phPerName'
                    });
                }
                var ed = $(this).datagrid('getEditor', { index: rowIndex, field: 'noActiveFlag' });
                var tmpval=$(ed.target).checkbox('getValue');
                $(ed.target).checkbox({ 
                    onCheckChange: function (e,val) {
                        if(val===true){
                            var tmped = $('#gridPhLocPer').datagrid('getEditor', {index:rowIndex,field:'fyFlag'});
                            $(tmped.target).checkbox('setValue', false);
                            var tmped = $('#gridPhLocPer').datagrid('getEditor', {index:rowIndex,field:'pyFlag'});
                            $(tmped.target).checkbox('setValue', false);
                            var tmped = $('#gridPhLocPer').datagrid('getEditor', {index:rowIndex,field:'auditFlag'});
                            $(tmped.target).checkbox('setValue', false);
                        }
                    }
                    
                });
                
                if(tmpval===true){$(ed.target).checkbox('setValue',true);}
                else{$(ed.target).checkbox('setValue',false);}
                var ed = $(this).datagrid('getEditor', { index: rowIndex, field: 'fyFlag' });
                var tmpval=$(ed.target).checkbox('getValue');
                $(ed.target).checkbox({ 
                    onCheckChange: function (e,val) {
                        if(val===true){
                            var tmped = $('#gridPhLocPer').datagrid('getEditor', {index:rowIndex,field:'noActiveFlag'});
                            $(tmped.target).checkbox('setValue', false);
                        }
                    }
                });
                if(tmpval===true){$(ed.target).checkbox('setValue',true);}
                else{$(ed.target).checkbox('setValue',false);}
                var ed = $(this).datagrid('getEditor', { index: rowIndex, field: 'pyFlag' });
                var tmpval=$(ed.target).checkbox('getValue');
                $(ed.target).checkbox({ 
                    onCheckChange: function (e,val) {
                        if(val===true){
                            var tmped = $('#gridPhLocPer').datagrid('getEditor', {index:rowIndex,field:'noActiveFlag'});
                            $(tmped.target).checkbox('setValue', false);
                        }
                    }
                });
                if(tmpval===true){$(ed.target).checkbox('setValue',true);}
                else{$(ed.target).checkbox('setValue',false);}
                var ed = $(this).datagrid('getEditor', { index: rowIndex, field: 'auditFlag' });
                var tmpval=$(ed.target).checkbox('getValue');
                $(ed.target).checkbox({ 
                    onCheckChange: function (e,val) {
                        if(val===true){
                            var tmped = $('#gridPhLocPer').datagrid('getEditor', {index:rowIndex,field:'noActiveFlag'});
                            $(tmped.target).checkbox('setValue', false);
                        }
                    }
                });
                 if(tmpval===true){$(ed.target).checkbox('setValue',true);}
                 else{$(ed.target).checkbox('setValue',false);}
                
            }
        },
        onLoadSuccess: function () {
            
        }
    };

    PHA.Grid('gridPhLocPer', dataGridOption);

}
function InitGridPhLocWin(){
     var EG_CheckBox = {
        type: 'icheckbox',
        options: {
            on: '1',
            off: '0'
        }
    };
    var columns = [[
        {
            field: 'phWinId',
            title: '药房窗口id',
            hidden: true,
            width: 100
        },
        {
            field: 'phWinDesc',
            title: '窗口描述',
            width: 120,
            editor: {
                type: 'validatebox',
                options: {
                    required: true
                }
            }
        },
        
        {
            field: 'phWinType',
            title: '窗口类型',
            width: 120,
            descField: 'phWinTypeDesc',
            editor:GridCmbWinType,
            formatter: function(value, row, index) {
                return row.phWinTypeDesc ;
            }
        },
        {
            field: 'phWinTypeDesc',
            title: '窗口类型',
            width: 150,
            hidden: true
        },
        {
            field: 'defFlag',
            title: '默认',
            width: 60,
            align: 'center',
            formatter: FormatterCheck,
            editor: EG_CheckBox
        },
        {
            field: 'pyPerDr',
            title: '预配药人',
            width: 120,
            align: 'center',
            editor:GridCmbPyPer,
            formatter: function(value, row, index) {
                return row.pyPerName ;
            }
        },
        {
            field: 'pyPerName',
            title: '预配药人',
            width: 60,
            align: 'center',
            hidden: true
        },
        {
            field: 'fyPerDr',
            title: '预发药人',
            width: 120,
            align: 'center',
            editor:GridCmbFyPer,
            formatter: function(value, row, index) {
                return row.fyPerName ;
            }
        },
        {
            field: 'fyPerName',
            title: '预发药人',
            width: 60,
            align: 'center',
            hidden: true
        },
        {
            field: 'defPyIP',
            title: '默认配药IP',
            width: 120,
            align: 'center',
            editor: {
                type: 'validatebox',
                options: {
                    validType: 'IPChk'
                }
            }
        },
        {
            field: 'printerName',
            title: '默认打印机',
            width: 200,
            align: 'center',
            editor: {
                type: 'validatebox'
            }
        },
        {
            field: 'phWinCode',
            title: '排队号前缀',
            width: 80,
            align: 'center',
            editor: {
                type: 'validatebox'
            }
        },
        {
            field: 'noActiveFlag',
            title: '无效',
            width: 60,
            align: 'center',
            formatter: FormatterCheck,
            editor: EG_CheckBox
        }
    ]];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.OP.Config.Window.Query',
            QueryName: 'QueryWindow',
            pJsonStr: "{}",
            rows: 999
        },
        pagination: false,
        columns: columns,
        toolbar: null,
        toolbar: '#gridPhLocWinBar',
        enableDnd: false,
        fitColumns: false,
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('endEditing');
            QueryPhWinLoc();
        },
        onDblClickRow: function (rowIndex, rowData) {
            if (rowData) {
                
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'phWinDesc'
                });
            }
        },
        onLoadSuccess: function () {
        }
    };

    PHA.Grid('gridPhLocWin', dataGridOption);

}
function InitGridPhWinLoc(){
    var columns = [[
        {
            field: 'phWinLocId',
            title: '窗口指定科室id',
            hidden: true,
            width: 100
        },
        {
            field: 'locRowId',
            title: '科室',
            descField: 'locDesc',
            width: 300,
            editor: GridCmbWinLoc,
            formatter: function(value, row, index) {
                return row.locDesc;
            }
        },
        {
            field: 'locDesc',
            title: '科室',
            hidden: true,
            width: 100,
            hidden: true
        }
    ]];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.OP.Config.Window.Query',
            QueryName: 'QueryPhWinLoc',
            pJsonStr: {},
            rows: 999
        },
        pagination: false,
        columns: columns,
        toolbar: '#gridPhWinLocBar',
        enableDnd: false,
        fitColumns: false,
        rownumbers: true,
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('endEditing');
        },
        onLoadSuccess: function (data) {
            if(data.total>0){
            }
        }
    };

    PHA.Grid('gridPhWinLoc', dataGridOption);
}
function FormatterCheck(value, row, index) {
    if (value === 'Y' || value === '1') {
        return PHA_COM.Fmt.Grid.Yes.Chinese;
    } else {
        return PHA_COM.Fmt.Grid.No.Chinese;
    }
}
function InitHosp() {
    var hospComp = GenHospComp('DHC_PHLOC','',{width:230});
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        $('#gridPhLoc').datagrid('getColumnOption', 'locRowId').editor.options.url = PHAOP_STORE.UserLoc().url;
        $('#phLocList').combobox('reload',PHAOP_STORE.PhLocByHosp().url);
        $('#phLocList').combobox('setValue',"")
        Query();
    };
}
// 查询药房列表
function Query(){

    var pJson = {};
    pJson.hospId = PHA_COM.Session.HOSPID;  
    pJson.locId = $('#phLocList').combobox('getValue') || "";  
    $("#gridPhLoc").datagrid("query",{
        pJsonStr: JSON.stringify(pJson),
    });  
}
function QueryPhLocSetting(){
    var $grid = $('#gridPhLoc');
    if ($grid.datagrid('endEditing') == false) {
        PHA.Popover({
            msg: '请先完成必填项',
            type: 'alert'
        });
        return;
    }
    var tab = $('#tabsOne').tabs('getSelected');
    var index = $('#tabsOne').tabs('getTabIndex',tab);
    if(index==0){       //门诊药房配置
        SetPhLocConfig();
    }else if(index==1){ 
        QueryPhPer();
    }else if(index==2){ 
        QueryPhWin();
    }       
}

function SetPhLocConfig()
{
    PHA.DomData('#divPhlConfig', {
        doType: 'clear'
    });
    
    var Selected=$("#gridPhLoc").datagrid("getSelected") || "";
    if(Selected==""){return}
    var phLocId=Selected.phLocId || '';;
    QueryPhlFlow(); 
    
    var retInfo=$.cm({
        ClassName:'PHA.OP.Config.PhLoc.Query',
        MethodName:'JsonPhLocConfig',
        phLocId:phLocId,
        ResultSetType: 'Array'
    },false);
    

    if (retInfo.msg) {
        PHA.Alert('错误提示', retInfo.msg, 'error');
    } else {
        PHA.SetVals(retInfo);
    }
    
}
function SavePhLoc(){
    var $grid = $('#gridPhLoc');
    if ($grid.datagrid('endEditing') == false) {
        PHA.Popover({
            msg: '请先完成必填项',
            type: 'alert'
        });
        return;
    }
    var gridRows = $grid.datagrid('getRows');

    var dataArr = [];
    for (var i = 0; i < gridRows.length; i++) {
        var rowData = gridRows[i];
        if (rowData.phLocId || '' !== '') {
            continue;
        }
        var locRowId = rowData.locRowId || '';
        if (locRowId === '') {
            continue;
        }
        var iJson = {
            locId: rowData.locRowId
        };
        dataArr.push(iJson);
    }
    if (dataArr.length === 0) {
        PHA.Popover({
            msg: '没有需要保存的数据',
            type: 'alert'
        });
        return;
    }
    
    var retJson = $.cm(
        {
            ClassName: 'PHA.OP.Data.Api',
            MethodName: 'HandleInOne',
            pClassName: 'PHA.OP.Config.PhLoc.OperTab',
            pMethodName: 'SavePhLoc',
            pJsonStr: JSON.stringify(dataArr)
        },false
    );

    if (retJson.success === 'N') {
        msg=PHAOP_COM.DataApi.Msg(retJson)
        PHA.Alert('提示', msg, 'warning');
        return;
    }else{
        PHA.Popover({
            msg: '保存成功',
            type: 'success'
        });
    }
    $grid.datagrid('reload');
}
function DelPhLoc(){
    var gridSelect = $('#gridPhLoc').datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '请先选中需要删除的行',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var phLocId = gridSelect.phLocId || '';
    if(phLocId!==""){
        PHA.Popover({
            msg: '已保存门诊的药房科室不可删除',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var rowIndex = $('#gridPhLoc').datagrid('getRowIndex', gridSelect);
    $('#gridPhLoc').datagrid('deleteRow', rowIndex);
}
function SavePhlConfig(){
    var dataRows=$("#gridPhLoc").datagrid("getRows");
    if(dataRows<=0){
        PHA.Popover({
            msg: '请选择药房科室！',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var selectPhloc=$('#gridPhLoc').datagrid('getSelected') ||'';
    if (selectPhloc == '') {
        PHA.Popover({
            msg: '请选择药房科室！',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var phLocId=selectPhloc.phLocId ||"";
    if(phLocId==""){
        PHA.Popover({
            msg: '请先保存药房科室！',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var chkFlag=ChkBeforeSaveFlow();
    if(chkFlag==false){return;}
    
    var retFlag=SavePhlFlow();
    if(retFlag==false){return;}
    var valsArr = PHA.DomData('#divPhlConfig', {
        doType: 'save',
        retType: 'Json'
    });
 
    valsArr[0].phLocId = phLocId; 
    var retJson = $.cm(
        {
            ClassName: 'PHA.OP.Data.Api',
            MethodName: 'HandleInAll',
            pClassName: 'PHA.OP.Config.PhLoc.OperTab',
            pMethodName: 'UpdatePhLoc',
            pJsonStr: JSON.stringify(valsArr)
        },
        false
    );
    
    if (retJson.success === 'N') {
        var msg = PHAOP_COM.DataApi.Msg(retJson);
        PHA.Alert('提示', msg, 'warning');
        return;
    }
    PHA.Popover({
        msg: '保存成功',
        type: 'success'
    });
    SetPhLocConfig();
}

//门诊的药房科室人员页签
function QueryPhPer(){
    var Selected=$("#gridPhLoc").datagrid("getSelected") || "";
    if(Selected==""){return}
    var phLocId=Selected.phLocId;
    var pJson = {};
    pJson.phLocId = phLocId;    
    $("#gridPhLocPer").datagrid("query",{
        pJsonStr: JSON.stringify(pJson),
    });  
}

function SavePhPer(){
    var $grid = $('#gridPhLocPer');
    if ($grid.datagrid('endEditing') == false) {
        PHA.Popover({
            msg: '请先完成必填项',
            type: 'alert'
        });
        return;
    }
    var Selected=$("#gridPhLoc").datagrid("getSelected") || "";
    if(Selected==""){ PHA.Popover({
            msg: '请选择需要保存的科室数据',
            type: 'alert'
        });
        return;
    }
    var phLocId=Selected.phLocId ||"";
    
    var gridChanges = $grid.datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        PHA.Popover({
            msg: '没有需要保存的数据',
            type: 'alert'
        });
        return;
    }
    
    var dataArr = [];
    for (var i = 0; i < gridChangeLen; i++) {
        var rowData = gridChanges[i];
        var phPerId=rowData.phPerId;
        var UserId = rowData.UserId || '';
        if (UserId === '') {
            continue;
        }
        var auditFlag=rowData.auditFlag;
        var pyFlag=rowData.pyFlag;
        var fyFlag=rowData.fyFlag;
        var noActiveFlag=rowData.noActiveFlag;

        var iJson = {
            phLocId:phLocId,
            phPerId: phPerId,
            userId:UserId,
            auditFlag:auditFlag,
            pyFlag:pyFlag,
            fyFlag:fyFlag,
            noActiveFlag:noActiveFlag           
        };
        dataArr.push(iJson);
    }
    if (dataArr.length === 0) {
        PHA.Popover({
            msg: '没有需要保存的数据',
            type: 'alert'
        });
        return;
    }
    
    var retJson = $.cm(
        {
            ClassName: 'PHA.OP.Data.Api',
            MethodName: 'HandleInOne',
            pClassName: 'PHA.OP.Config.Person.OperTab',
            pMethodName: 'SavePhPer',
            pJsonStr: JSON.stringify(dataArr)
        },false
    );

    if (retJson.success === 'N') {
        msg=PHAOP_COM.DataApi.Msg(retJson)
        PHA.Alert('提示', msg, 'warning');
        return;
    }else{
        PHA.Popover({
            msg: '保存成功',
            type: 'success'
        });
    }
    $grid.datagrid('reload');
}
function DelPhPer(){
    var gridSelect = $('#gridPhLocPer').datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '请先选中需要删除的行',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var phPerId = gridSelect.phPerId || '';
    if(phPerId!==""){
        PHA.Popover({
            msg: '已保存门诊的药房人员不可删除！',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var rowIndex = $('#gridPhLocPer').datagrid('getRowIndex', gridSelect);
    $('#gridPhLocPer').datagrid('deleteRow', rowIndex);
}
//门诊的药房科室窗口
function QueryPhWin(){
    $('#gridPhLocWin').datagrid('clear');
    $('#gridPhWinLoc').datagrid('clear');
    var Selected=$("#gridPhLoc").datagrid("getSelected") || "";
    if(Selected==""){return}
    var phLocId=Selected.phLocId ||'';
    var pJson = {};
    pJson.phLocId = phLocId;    
    $("#gridPhLocWin").datagrid("query",{
        pJsonStr: JSON.stringify(pJson),
    });  
}

function SavePhWin(){
    var $grid = $('#gridPhLocWin');
    if ($grid.datagrid('endEditing') == false) {
        PHA.Popover({
            msg: '请检查必填项及已填写信息',
            type: 'alert'
        });
        return;
    }
    var Selected=$("#gridPhLoc").datagrid("getSelected") || "";
    if(Selected==""){ 
        PHA.Popover({
            msg: '请选择需要保存的科室数据',
            type: 'alert'
        });
        return;
    }
    var phLocId=Selected.phLocId ||'';
    if(phLocId==""){ 
        PHA.Popover({
            msg: '请选择需要保存的科室数据',
            type: 'alert'
        });
        return;
    }
    var gridChanges = $grid.datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        PHA.Popover({
            msg: '没有需要保存的数据',
            type: 'alert'
        });
        return;
    }
    var repeatObj = $grid.datagrid('checkRepeat', [['phWinDesc']]);
    if (typeof repeatObj.pos === 'number') {
        PHA.Popover({
            msg: '第{' + (repeatObj.pos + 1) + '}、{' + (repeatObj.repeatPos + 1) + '}行:' + repeatObj.titleArr.join('、') + '重复',
            type: 'alert'
        });
        return;
    }
    var tmpJson={}
    var dataArr = [];
    for (var i = 0; i < gridChangeLen; i++) {
        var rowData = gridChanges[i];
        var phWinId=rowData.phWinId;
        var phWinDesc=rowData.phWinDesc;
        var phWinType=rowData.phWinType;
        var defFlag=rowData.defFlag;
        
        var defPyIP=rowData.defPyIP;
        var printerName=rowData.printerName;
        var pyPerDr=rowData.pyPerDr;
        var fyPerDr=rowData.fyPerDr;
        var phWinCode=rowData.phWinCode;
        var noActiveFlag=rowData.noActiveFlag;
        
        
        var iJson = {
            phLocId:phLocId,
            phWinId: phWinId,
            phWinDesc:phWinDesc,
            phWinType:phWinType,
            defFlag:defFlag,
            defPyIP:defPyIP,
            printerName:printerName,
            pyPerDr:pyPerDr,
            fyPerDr:fyPerDr,
            phWinCode:phWinCode,
            noActiveFlag:noActiveFlag           
        };
        if(defFlag==="1"){
            if((JSON.stringify(tmpJson))!="{}"){
                PHA.Popover({
                    msg: '编辑数据行中多个默认窗口',
                    type: 'alert'
                });
                return;
            }
            tmpJson=iJson
            continue;
        }
        dataArr.push(iJson);
    }
    if((JSON.stringify(tmpJson))!="{}"){
        dataArr.push(tmpJson);
    }
    if (dataArr.length === 0) {
        PHA.Popover({
            msg: '没有需要保存的数据',
            type: 'alert'
        });
        return;
    }
    
    var retJson = $.cm(
        {
            ClassName: 'PHA.OP.Data.Api',
            MethodName: 'HandleInOne',
            pClassName: 'PHA.OP.Config.Window.OperTab',
            pMethodName: 'SavePhWin',
            pJsonStr: JSON.stringify(dataArr)
        },false
    );

    if (retJson.success === 'N') {
        msg=PHAOP_COM.DataApi.Msg(retJson)
        PHA.Alert('提示', msg, 'warning');
        return;
    }else{
        PHA.Popover({
            msg: '保存成功',
            type: 'success'
        });
    }
    $grid.datagrid('reload');
}
function DelPhWin(){
    var gridSelect = $('#gridPhLocWin').datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '请先选中需要删除的行',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var phWinId = gridSelect.phWinId || '';
    if(phWinId!==""){
        PHA.Popover({
            msg: '已保存门诊的药房窗口不可删除！',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var rowIndex = $('#gridPhLocWin').datagrid('getRowIndex', gridSelect);
    $('#gridPhLocWin').datagrid('deleteRow', rowIndex);
}
// 窗口指定科室
function QueryPhWinLoc(){
    var Selected=$("#gridPhLocWin").datagrid("getSelected") || "";
    if(Selected==""){return}
    var phWinId=Selected.phWinId;
    var pJson = {};
    pJson.winId = phWinId;  
    $("#gridPhWinLoc").datagrid("query",{
        pJsonStr: JSON.stringify(pJson),
    });  
}
function SavePhWinLoc(){
    var $grid = $('#gridPhWinLoc');
    if ($grid.datagrid('endEditing') == false) {
        PHA.Popover({
            msg: '请先完成必填项',
            type: 'alert'
        });
        return;
    }
    var Selected=$("#gridPhLocWin").datagrid("getSelected") || "";
    if(Selected==""){ 
        PHA.Popover({
            msg: '请选择需要保存的窗口数据',
            type: 'alert'
        });
        return;
    }
    
    var phWinId = Selected.phWinId || '';
    
    var repeatObj = $grid.datagrid('checkRepeat', [['locRowId']]);
    if (typeof repeatObj.pos === 'number') {
        PHA.Popover({
            msg: '第{' + (repeatObj.pos + 1) + '}、{' + (repeatObj.repeatPos + 1) + '}行:' + repeatObj.titleArr.join('、') + '重复',
            type: 'alert'
        });
        return;
    }

    var dataArr = [];
    var gridChanges = $grid.datagrid('getChanges',"updated");
    var gridChangeLen = gridChanges.length;

    for (var i = 0; i < gridChangeLen; i++) {
        var rowData = gridChanges[i];
        var locRowId = rowData.locRowId || '';
        var winLocId=rowData.phWinLocId || '';
        if (locRowId === '') {
            continue;
        }
        var iJson = {
            phWinId:phWinId,
            winLocId: winLocId,
            locId: rowData.locRowId
        };
        dataArr.push(iJson);
    }
    var gridChanges = $grid.datagrid('getChanges',"inserted");
    var gridChangeLen = gridChanges.length;
    for (var i = 0; i < gridChangeLen; i++) {
        var rowData = gridChanges[i];
        var locRowId = rowData.locRowId || '';
        var winLocId=rowData.phWinLocId || '';
        if (locRowId === '') {
            continue;
        }
        var iJson = {
            phWinId:phWinId,
            winLocId: winLocId,
            locId: rowData.locRowId
        };
        dataArr.push(iJson);
    }
    if (dataArr.length === 0) {
        PHA.Popover({
            msg: '没有需要保存的数据',
            type: 'alert'
        });
        return;
    }
    
    var retJson = $.cm(
        {
            ClassName: 'PHA.OP.Data.Api',
            MethodName: 'HandleInOne',
            pClassName: 'PHA.OP.Config.Window.OperTab',
            pMethodName: 'SavePhLocWin',
            pJsonStr: JSON.stringify(dataArr)
        },false
    );

    if (retJson.success === 'N') {
        msg=PHAOP_COM.DataApi.Msg(retJson)
        PHA.Alert('提示', msg, 'warning');
        return;
    }else{
        PHA.Popover({
            msg: '保存成功',
            type: 'success'
        });
    }
    $grid.datagrid('reload');

}
function DelPhWinLoc(){
    var gridSelect = $('#gridPhWinLoc').datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '请先选中需要删除的行',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    PHAOP_COM._Confirm("", $g("您确定删除当前窗口的指定科室吗") + "<br/>" + $g("点击[确定]将继续删除，点击[取消]将放弃删除操作。"), function (r) {
        if (r == true) {
            var winLocId = gridSelect.phWinLocId || '';
            if(winLocId!==""){
                var locDesc= gridSelect.locDesc || '';
                var dataArr = [];
                var iJson = {
                    winLocId:winLocId,
                    locDesc:locDesc
                };
                dataArr.push(iJson);
                var retJson = $.cm(
                    {
                        ClassName: 'PHA.OP.Data.Api',
                        MethodName: 'HandleInOne',
                        pClassName: 'PHA.OP.Config.Window.OperTab',
                        pMethodName: 'DelPhLocWin',
                        pJsonStr:JSON.stringify(dataArr)
                    },false
                );
                if (retJson.success === 'N') {
                    msg=PHAOP_COM.DataApi.Msg(retJson)
                    PHA.Alert('提示', msg, 'warning');
                    return;
                }
            }
            PHA.Popover({
                msg: '删除成功',
                type: 'success'
            });
            var rowIndex = $('#gridPhWinLoc').datagrid('getRowIndex', gridSelect);
            $('#gridPhWinLoc').datagrid('deleteRow', rowIndex);
            return true;
        } else {
            return false;
        }
    });    
    

}
function Clear(){
    //门诊科室配置
    PHA.DomData('#divPhlConfig', {
        doType: 'clear'
    });
    $('#gridPhlFlow').datagrid('clear');
    $('#gridPhLocPer').datagrid('clear');
    $('#gridPhLocWin').datagrid('clear');
    $('#gridPhWinLoc').datagrid('clear');  
    var pJson = {};
    pJson.phLocId = "";
    $("#gridPhlFlow").datagrid("query",{
        pJsonStr: JSON.stringify(pJson),
    }); 
}


function ElementRequired(element,flag){
    var domId="";
    if(flag==true){flag="1"}
    
    if(element=="reportFlag"){
        domId="quePosi";
        var domVal="1";
        if(flag=="1"){
            var tmpVal=$('input[name='+domId+']:checked').val() || "";
            if(tmpVal==""){
                $HUI.radio('input[name='+domId+'][value='+domVal+']').setValue(true); 
            }
            $('[name='+domId+']').radio('setDisable',false); 
            $('[name='+domId+']').radio('setRequired',true);
        }
        else{
            $('[name='+domId+']').radio('setValue',false);
            $('[name='+domId+']').radio('setDisable',true); 
            $('[name='+domId+']').radio('setRequired',false);
            
            
        }
    }
    if(element=="prescAuditFlag"){
        domId="autoPrescAudit"
        if(flag=="1"){
            $("#"+domId).checkbox("setDisable",false);
            var val=$("#"+domId).checkbox('getValue');  
            ElementRequired(domId,val)
        }else{
            $("#"+domId).checkbox("setValue",false);
            $("#"+domId).checkbox("setDisable",true);
            var val=$("#"+domId).checkbox('getValue');  
            ElementRequired(domId,val)
        }
    }
    if(element=="autoPrescAudit"){
        domId="waitAuditTime"
        if(flag=="1"){
            $("#waitAuditTime").validatebox("setDisabled",false);
        }else{
            //$("#waitAuditTime").val('');
            $('#waitAuditTime').numberbox("setValue",'');
            $("#waitAuditTime").validatebox("setDisabled",true);
        }
    }
    if(element=="sendMachineFlag"){
        if(flag=="1"){
            $("#callAsLightUp").checkbox("setDisable",false);
            $("#queryAsLightUp").checkbox("setDisable",false);
            $("#dispAsLightDown").checkbox("setDisable",false);
        }else{
            $("#callAsLightUp").checkbox("setValue",false);
            $("#queryAsLightUp").checkbox("setValue",false);
            $("#dispAsLightDown").checkbox("setValue",false);

            $("#callAsLightUp").checkbox("setDisable",true);
            $("#queryAsLightUp").checkbox("setDisable",true);
            $("#dispAsLightDown").checkbox("setDisable",true);
        }
    }
    if(element=="dispAsCall"){
        if(flag=="1"){
            $("#callAsUpScreen").checkbox("setDisable",false);
        }else{
            $("#callAsUpScreen").checkbox("setValue",false);
            $("#callAsUpScreen").checkbox("setDisable",true);
        }
    }
    if(element=="screenFlag"){
        domId="upScreenFlag"
        var domVal="3";
        if(flag=="1"){
            var tmpVal=$('input[name='+domId+']:checked').val() || "";
            if(tmpVal==""){
                $HUI.radio('input[name='+domId+'][value='+domVal+']').setValue(true); 
            }
            $('[name='+domId+']').radio('setDisable',false); 
            $('[name='+domId+']').radio('setRequired',true);
            
            $("#screenPath").validatebox("setDisabled",false);
            
        }else{
            $('[name='+domId+']').radio('setValue',false);
            $('[name='+domId+']').radio('setDisable',true); 
            $('[name='+domId+']').radio('setRequired',false);
            
            $("#screenPath").validatebox("setDisabled",true);
            $("#screenPath").val('');
            
        }
    }
}

///***************************门诊流程的保存、删除
function QueryPhlFlow(){
    
    var Selected=$("#gridPhLoc").datagrid("getSelected") || "";
    if(Selected==""){ PHA.Popover({
            msg: '请选择需要保存的科室数据',
            type: 'alert'
        });
        return false;
    }
    var phLocId=Selected.phLocId ||"";
    if(phLocId==""){
        PHA.Popover({
            msg: '请先保存药房科室！',
            type: 'alert',
            timeout: 1000
        });
        return false;
    }
    $('#gridPhlFlow').datagrid('clear');
    var pJson = {};
    pJson.phLocId = phLocId;
    $("#gridPhlFlow").datagrid("query",{
        pJsonStr: JSON.stringify(pJson),
    });  
}

function SavePhlFlow(){
    var Selected=$("#gridPhLoc").datagrid("getSelected") || "";
    if(Selected==""){ PHA.Popover({
            msg: '请选择需要保存的科室数据',
            type: 'alert'
        });
        return false;
    }
    var phLocId=Selected.phLocId ||"";
    if(phLocId==""){
        PHA.Popover({
            msg: '请先保存药房科室！',
            type: 'alert',
            timeout: 1000
        });
        return false;
    }
    
    var $grid = $('#gridPhlFlow');
    if ($grid.datagrid('endEditing') == false) {
        PHA.Popover({
            msg: '请先完成必填项',
            type: 'alert'
        });
        return false;
    }
    var gridRows = $grid.datagrid('getRows');
    
     var chkRows=$grid.datagrid('getChecked');   //获取所有被选中的行
     var CodeArr=[];
    $.each(chkRows,function(i,data){
        CodeArr["Code"+data.flowCode]=""
    })
    var dataArr = [];
    for (var i = 0; i < gridRows.length; i++) {
        var rowData = gridRows[i];
        var phlFlowId=rowData.phlFlowId || '';
        var activeFlag=""; //rowData.activeFlag;
        var flowCode=rowData.flowCode;
        if(CodeArr["Code"+flowCode]==undefined){
            activeFlag="0"
        }else{
            activeFlag="1"
        }
        if ((phlFlowId== '')&&(activeFlag!="1")) {
            continue;
        }
        var flowPyDisp=rowData.flowPyDisp;
        var flowDirDisp=rowData.flowDirDisp;
        var comFlag=rowData.comFlag;
        if((comFlag!="1")&&((flowPyDisp=="")||(flowDirDisp==""))){
            PHA.Popover({
                msg: '配发流程描述和直发流程描述不能为空',
                type: 'alert'
            });
            return false;
        }
        var flowCode=rowData.flowCode;
        if(flowCode==""){
            PHA.Popover({
                msg: '流程代码不能为空',
                type: 'alert'
            });
            return false;
        }
        
        var iJson = {
            phlRowId:phLocId,
            phlFlowId: rowData.phlFlowId,
            flowCode: flowCode,
            flowPyDisp: flowPyDisp,
            flowDirDisp: flowDirDisp,
            activeFlag: activeFlag
        };
        dataArr.push(iJson);
    }
    
    if (dataArr.length === 0) {
        PHA.Popover({
            msg: '没有需要保存的数据',
            type: 'alert'
        });
        return false;
    }
    
    var retJson = $.cm(
        {
            ClassName: 'PHA.OP.Data.Api',
            MethodName: 'HandleInOne',
            pClassName: 'PHA.OP.Config.PhLoc.OperTab',
            pMethodName: 'UpdPhLocFlow',
            pJsonStr: JSON.stringify(dataArr)
        },false
    );

    if (retJson.success === 'N') {
        msg=PHAOP_COM.DataApi.Msg(retJson)
        PHA.Alert('提示', msg, 'warning');
        return false;
    }else{
        /*
        PHA.Popover({
            msg: '保存成功',
            type: 'success'
        });
        */
    }
    $grid.datagrid('reload');
    return true
    
}
function DelPhlFlow(){
    var $grid = $('#gridPhlFlow');
    var gridSelect = $grid.datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '请先选中需要删除的行',
            type: 'alert',
            timeout: 1000
        });
        return false;
    }
    var comFlag= gridSelect.comFlag || '';
    if(comFlag=="1"){
        PHA.Popover({
            msg: '流程为通用流程不可删除，不用去勾选即可！',
            type: 'alert',
            timeout: 1000
        });
        return false;
    }
    PHAOP_COM._Confirm("", $g("您确定删除当前流程吗？") + "<br/>" + $g("点击[确定]将继续删除，点击[取消]将放弃删除操作。"), function (r) {
        if (r == true) {
            var phlFlowId=gridSelect.phlFlowId;
            if(phlFlowId==""){
                var rowIndex = $grid.datagrid('getRowIndex', gridSelect);
                $grid.datagrid('deleteRow', rowIndex);
            }else{
                var dataArr = [];
                var iJson = {
                    phlFlowId: phlFlowId
                };
                dataArr.push(iJson);
                var retJson = $.cm({
                        ClassName: 'PHA.OP.Data.Api',
                        MethodName: 'HandleInOne',
                        pClassName: 'PHA.OP.Config.PhLoc.OperTab',
                        pMethodName: 'DelPhLocFlow',
                        pJsonStr: JSON.stringify(dataArr)
                    },false
                );

                if (retJson.success === 'N') {
                    msg=PHAOP_COM.DataApi.Msg(retJson)
                    PHA.Alert('提示', msg, 'warning');
                    return false;
                }else{
                    PHA.Popover({
                        msg: '删除成功',
                        type: 'success'
                    });
                    QueryPhlFlow();
                }
            }
            return true;
        } else {
            return false;
        }
    });
    
    
}

function ChkBeforeSaveFlow(){
    
    var $grid = $('#gridPhlFlow');
    if ($grid.datagrid('endEditing') == false) {
        PHA.Popover({
            msg: '请先完成流程必填项',
            type: 'alert'
        });
        return false;
    }
    var arithmetFlag = $("#arithmetFlag").combobox("getValue")||'';  //当前combobox的值
    if ((arithmetFlag == "") || (arithmetFlag == null)) {
        PHA.Popover({
            msg: '请选择取药算法！',
            type: 'alert',
            timeout: 1000
        });
        return false;
    }
    var gridRows = $grid.datagrid('getRows');
    var ExitCodeArr = [];
    for (var i = 0; i < gridRows.length; i++) {
        var rowData = gridRows[i];
        var flowCode=rowData.flowCode;
        if(ExitCodeArr["ExitCodeArr"+flowCode]!=undefined){
            PHA.Popover({
                msg: '流程代码重复！'+flowCode,
                type: 'alert'
            });
            return false;
            
        }
        
        ExitCodeArr["ExitCodeArr"+flowCode]=""
    }
     var chkRows=$grid.datagrid('getChecked');   //获取所有被选中的行
     var CodeArr=[];
    $.each(chkRows,function(i,data){
        CodeArr["Code"+data.flowCode]=""
        
    })
    if(CodeArr["Code50"]==""){
        if(CodeArr["Code40"]==undefined){
            PHA.Popover({
                msg: '配药确认需要勾选配药！',
                type: 'alert'
            });
            return false;
        }
    }
    if(CodeArr["Code30"]!=undefined){
        var domId="quePosi";
        var quePosi=$('input[name='+domId+']:checked').val() || "";
        if(quePosi==""){
                PHA.Popover({
                msg: '请设置报到环节！',
                type: 'alert'
            });
            return false;
        }
    }
    var screenFlag=$("#screenFlag").checkbox("getValue");
    if(screenFlag==true){
        var domId="upScreenFlag";
        var upScreenFlag=$('input[name='+domId+']:checked').val() || "";
        if(upScreenFlag==""){
                PHA.Popover({
                msg: '请设置何时上屏！',
                type: 'alert'
            });
            return false;
        }
    }
    var autoPrescAudit=$("#autoPrescAudit").checkbox("getValue");
    if(autoPrescAudit==true){
        var domId="waitAuditTime";
        var waitAuditTime=$('#'+domId).numberbox('getValue');
        if(waitAuditTime==""){
                PHA.Popover({
                msg: '请设置自动审核时间！',
                type: 'alert'
            });
            return false;
        }
    }
    return true;
}