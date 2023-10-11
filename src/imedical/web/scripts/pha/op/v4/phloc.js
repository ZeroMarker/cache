/*
    Creator:zhaozhiduan
    CreataDate:2020.11.18
    Description:����ҩ������ά��-hisui
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
    InitGridPhLoc();        //�����ҩ���б�
    InitGridPhLocPer();     //�����ҩ������ԱȨ���б�
    InitGridPhLocWin();     //�����ҩ���Ĵ����б�
    InitGridPhWinLoc();     //�����ҩ���Ĵ���ָ������
    InitGridPhFlow();       //�����ҩ��������
    InitEvent();
    $.extend($.fn.validatebox.defaults.rules, {
        // �Ƿ�����
        IPChk: {
            validator: function(value, param) {
                var regTxt = /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/;
                return regTxt.test(value);
            },
            message: $g('��������ȷ��ip')
        }
    });
});
function InitDict(){
    
    PHA.ComboBox("arithmetFlag",{
        required: true,
        data:[
            {RowId:"1",Description:$g("���մ���")},
            {RowId:"2",Description:$g("���չ�����")}
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
            var UserId = $(this).combobox("getValue");  //��ǰcombobox��ֵ
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
            if(winTypeDesc.indexOf($g("ָ������"))<0){
                 
                if(rowNum>0){
                    PHA.Popover({
                        msg: '��ָ�������ʹ�����Ҫɾ���Ҳ�ָ������',
                        type: 'alert'
                    });
                    return;
                }
            }else{
                if(rowNum==0){
                    PHA.Popover({
                        msg: '�������Ҫָ������',
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
    //�����ҩ������
    $('#btnAddPhLoc').on('click', function () {
        Clear();
        $('#gridPhLoc').datagrid('addNewRow', {
            editField: 'locRowId'
        });
    });
    $('#btnSavePhLoc').on('click', SavePhLoc);
    $('#btnDelPhLoc').on('click', DelPhLoc);
    //�����ҩ��������������
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
    //�����ҩ����������
    $('#btnSavePhlConfig').on('click', SavePhlConfig);
    //�����ҩ������Ա
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
   //�����ҩ���Ĵ���
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

    //�����ҩ���Ĵ���ָ������
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
    
    
    //ҳǩ�л�
    $("#tabsOne").tabs({
        onSelect:function(title){
            if (title === $g('��ҩ����')){
                $('#lyThird').layout();
            }
            QueryPhLocSetting()                 
        }
    })
    
    /* ��������Ĳ�����*/
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
            title: '����ҩ��id',
            hidden: true,
            width: 100
        },
        {
            field: 'locRowId',
            title: '����',
            descField: 'locDesc',
            width: 100,
            editor: GridCmbLoc,
            formatter: function(value, row, index) {
                return row.locDesc;
            }
        },
        {
            field: 'locDesc',
            title: '����',
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
// ��������grid
function InitGridPhFlow(){

    var columns = [[
        {
            field: 'phlFlowId',
            title: '��������id',
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
            title: '�������',
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
            title: '�䷢����',
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
            title: 'ֱ��ҩ����',
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
            title: '���ɱ༭',
            hidden: true,
            width: 100
        },
        {
            field: 'comFlag',
            title: 'ͨ�����̱�־',
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
                if(rowData.flowCode=="30"){  //���ﱨ��
                    ElementRequired("reportFlag",1)
                }
                if(rowData.flowCode=="20"){  //�������
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
            title: 'ҩ����Աid',
            hidden: true,
            width: 100
        },
        {
            field: 'phPerCode',
            title: '��Ա����',
            width: 150
        },
        {
            field: 'UserId',
            title: '��Ա����',
            width: 150,
            hidden: true
        },
        {
            field: 'phPerName',
            title: '��Ա����',
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
            title: '���',
            width: 100,
            align: 'center',
            formatter: FormatterCheck,
            editor: EG_CheckBox,
            hidden: true,
        },
        {
            field: 'pyFlag',
            title: '��ҩ',
            width: 100,
            align: 'center',
            formatter: FormatterCheck,
            editor: EG_CheckBox
        },
        {
            field: 'fyFlag',
            title: '��ҩ',
            width: 100,
            align: 'center',
            formatter: FormatterCheck,
            editor: EG_CheckBox
            
        },
        {
            field: 'noActiveFlag',
            title: '��Ч',
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
            title: 'ҩ������id',
            hidden: true,
            width: 100
        },
        {
            field: 'phWinDesc',
            title: '��������',
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
            title: '��������',
            width: 120,
            descField: 'phWinTypeDesc',
            editor:GridCmbWinType,
            formatter: function(value, row, index) {
                return row.phWinTypeDesc ;
            }
        },
        {
            field: 'phWinTypeDesc',
            title: '��������',
            width: 150,
            hidden: true
        },
        {
            field: 'defFlag',
            title: 'Ĭ��',
            width: 60,
            align: 'center',
            formatter: FormatterCheck,
            editor: EG_CheckBox
        },
        {
            field: 'pyPerDr',
            title: 'Ԥ��ҩ��',
            width: 120,
            align: 'center',
            editor:GridCmbPyPer,
            formatter: function(value, row, index) {
                return row.pyPerName ;
            }
        },
        {
            field: 'pyPerName',
            title: 'Ԥ��ҩ��',
            width: 60,
            align: 'center',
            hidden: true
        },
        {
            field: 'fyPerDr',
            title: 'Ԥ��ҩ��',
            width: 120,
            align: 'center',
            editor:GridCmbFyPer,
            formatter: function(value, row, index) {
                return row.fyPerName ;
            }
        },
        {
            field: 'fyPerName',
            title: 'Ԥ��ҩ��',
            width: 60,
            align: 'center',
            hidden: true
        },
        {
            field: 'defPyIP',
            title: 'Ĭ����ҩIP',
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
            title: 'Ĭ�ϴ�ӡ��',
            width: 200,
            align: 'center',
            editor: {
                type: 'validatebox'
            }
        },
        {
            field: 'phWinCode',
            title: '�ŶӺ�ǰ׺',
            width: 80,
            align: 'center',
            editor: {
                type: 'validatebox'
            }
        },
        {
            field: 'noActiveFlag',
            title: '��Ч',
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
            title: '����ָ������id',
            hidden: true,
            width: 100
        },
        {
            field: 'locRowId',
            title: '����',
            descField: 'locDesc',
            width: 300,
            editor: GridCmbWinLoc,
            formatter: function(value, row, index) {
                return row.locDesc;
            }
        },
        {
            field: 'locDesc',
            title: '����',
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
// ��ѯҩ���б�
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
            msg: '������ɱ�����',
            type: 'alert'
        });
        return;
    }
    var tab = $('#tabsOne').tabs('getSelected');
    var index = $('#tabsOne').tabs('getTabIndex',tab);
    if(index==0){       //����ҩ������
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
        PHA.Alert('������ʾ', retInfo.msg, 'error');
    } else {
        PHA.SetVals(retInfo);
    }
    
}
function SavePhLoc(){
    var $grid = $('#gridPhLoc');
    if ($grid.datagrid('endEditing') == false) {
        PHA.Popover({
            msg: '������ɱ�����',
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
            msg: 'û����Ҫ���������',
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
        PHA.Alert('��ʾ', msg, 'warning');
        return;
    }else{
        PHA.Popover({
            msg: '����ɹ�',
            type: 'success'
        });
    }
    $grid.datagrid('reload');
}
function DelPhLoc(){
    var gridSelect = $('#gridPhLoc').datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '����ѡ����Ҫɾ������',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var phLocId = gridSelect.phLocId || '';
    if(phLocId!==""){
        PHA.Popover({
            msg: '�ѱ��������ҩ�����Ҳ���ɾ��',
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
            msg: '��ѡ��ҩ�����ң�',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var selectPhloc=$('#gridPhLoc').datagrid('getSelected') ||'';
    if (selectPhloc == '') {
        PHA.Popover({
            msg: '��ѡ��ҩ�����ң�',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var phLocId=selectPhloc.phLocId ||"";
    if(phLocId==""){
        PHA.Popover({
            msg: '���ȱ���ҩ�����ң�',
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
        PHA.Alert('��ʾ', msg, 'warning');
        return;
    }
    PHA.Popover({
        msg: '����ɹ�',
        type: 'success'
    });
    SetPhLocConfig();
}

//�����ҩ��������Աҳǩ
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
            msg: '������ɱ�����',
            type: 'alert'
        });
        return;
    }
    var Selected=$("#gridPhLoc").datagrid("getSelected") || "";
    if(Selected==""){ PHA.Popover({
            msg: '��ѡ����Ҫ����Ŀ�������',
            type: 'alert'
        });
        return;
    }
    var phLocId=Selected.phLocId ||"";
    
    var gridChanges = $grid.datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        PHA.Popover({
            msg: 'û����Ҫ���������',
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
            msg: 'û����Ҫ���������',
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
        PHA.Alert('��ʾ', msg, 'warning');
        return;
    }else{
        PHA.Popover({
            msg: '����ɹ�',
            type: 'success'
        });
    }
    $grid.datagrid('reload');
}
function DelPhPer(){
    var gridSelect = $('#gridPhLocPer').datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '����ѡ����Ҫɾ������',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var phPerId = gridSelect.phPerId || '';
    if(phPerId!==""){
        PHA.Popover({
            msg: '�ѱ��������ҩ����Ա����ɾ����',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var rowIndex = $('#gridPhLocPer').datagrid('getRowIndex', gridSelect);
    $('#gridPhLocPer').datagrid('deleteRow', rowIndex);
}
//�����ҩ�����Ҵ���
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
            msg: '������������д��Ϣ',
            type: 'alert'
        });
        return;
    }
    var Selected=$("#gridPhLoc").datagrid("getSelected") || "";
    if(Selected==""){ 
        PHA.Popover({
            msg: '��ѡ����Ҫ����Ŀ�������',
            type: 'alert'
        });
        return;
    }
    var phLocId=Selected.phLocId ||'';
    if(phLocId==""){ 
        PHA.Popover({
            msg: '��ѡ����Ҫ����Ŀ�������',
            type: 'alert'
        });
        return;
    }
    var gridChanges = $grid.datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        PHA.Popover({
            msg: 'û����Ҫ���������',
            type: 'alert'
        });
        return;
    }
    var repeatObj = $grid.datagrid('checkRepeat', [['phWinDesc']]);
    if (typeof repeatObj.pos === 'number') {
        PHA.Popover({
            msg: '��{' + (repeatObj.pos + 1) + '}��{' + (repeatObj.repeatPos + 1) + '}��:' + repeatObj.titleArr.join('��') + '�ظ�',
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
                    msg: '�༭�������ж��Ĭ�ϴ���',
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
            msg: 'û����Ҫ���������',
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
        PHA.Alert('��ʾ', msg, 'warning');
        return;
    }else{
        PHA.Popover({
            msg: '����ɹ�',
            type: 'success'
        });
    }
    $grid.datagrid('reload');
}
function DelPhWin(){
    var gridSelect = $('#gridPhLocWin').datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '����ѡ����Ҫɾ������',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var phWinId = gridSelect.phWinId || '';
    if(phWinId!==""){
        PHA.Popover({
            msg: '�ѱ��������ҩ�����ڲ���ɾ����',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var rowIndex = $('#gridPhLocWin').datagrid('getRowIndex', gridSelect);
    $('#gridPhLocWin').datagrid('deleteRow', rowIndex);
}
// ����ָ������
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
            msg: '������ɱ�����',
            type: 'alert'
        });
        return;
    }
    var Selected=$("#gridPhLocWin").datagrid("getSelected") || "";
    if(Selected==""){ 
        PHA.Popover({
            msg: '��ѡ����Ҫ����Ĵ�������',
            type: 'alert'
        });
        return;
    }
    
    var phWinId = Selected.phWinId || '';
    
    var repeatObj = $grid.datagrid('checkRepeat', [['locRowId']]);
    if (typeof repeatObj.pos === 'number') {
        PHA.Popover({
            msg: '��{' + (repeatObj.pos + 1) + '}��{' + (repeatObj.repeatPos + 1) + '}��:' + repeatObj.titleArr.join('��') + '�ظ�',
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
            msg: 'û����Ҫ���������',
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
        PHA.Alert('��ʾ', msg, 'warning');
        return;
    }else{
        PHA.Popover({
            msg: '����ɹ�',
            type: 'success'
        });
    }
    $grid.datagrid('reload');

}
function DelPhWinLoc(){
    var gridSelect = $('#gridPhWinLoc').datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '����ѡ����Ҫɾ������',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    PHAOP_COM._Confirm("", $g("��ȷ��ɾ����ǰ���ڵ�ָ��������") + "<br/>" + $g("���[ȷ��]������ɾ�������[ȡ��]������ɾ��������"), function (r) {
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
                    PHA.Alert('��ʾ', msg, 'warning');
                    return;
                }
            }
            PHA.Popover({
                msg: 'ɾ���ɹ�',
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
    //�����������
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

///***************************�������̵ı��桢ɾ��
function QueryPhlFlow(){
    
    var Selected=$("#gridPhLoc").datagrid("getSelected") || "";
    if(Selected==""){ PHA.Popover({
            msg: '��ѡ����Ҫ����Ŀ�������',
            type: 'alert'
        });
        return false;
    }
    var phLocId=Selected.phLocId ||"";
    if(phLocId==""){
        PHA.Popover({
            msg: '���ȱ���ҩ�����ң�',
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
            msg: '��ѡ����Ҫ����Ŀ�������',
            type: 'alert'
        });
        return false;
    }
    var phLocId=Selected.phLocId ||"";
    if(phLocId==""){
        PHA.Popover({
            msg: '���ȱ���ҩ�����ң�',
            type: 'alert',
            timeout: 1000
        });
        return false;
    }
    
    var $grid = $('#gridPhlFlow');
    if ($grid.datagrid('endEditing') == false) {
        PHA.Popover({
            msg: '������ɱ�����',
            type: 'alert'
        });
        return false;
    }
    var gridRows = $grid.datagrid('getRows');
    
     var chkRows=$grid.datagrid('getChecked');   //��ȡ���б�ѡ�е���
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
                msg: '�䷢����������ֱ��������������Ϊ��',
                type: 'alert'
            });
            return false;
        }
        var flowCode=rowData.flowCode;
        if(flowCode==""){
            PHA.Popover({
                msg: '���̴��벻��Ϊ��',
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
            msg: 'û����Ҫ���������',
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
        PHA.Alert('��ʾ', msg, 'warning');
        return false;
    }else{
        /*
        PHA.Popover({
            msg: '����ɹ�',
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
            msg: '����ѡ����Ҫɾ������',
            type: 'alert',
            timeout: 1000
        });
        return false;
    }
    var comFlag= gridSelect.comFlag || '';
    if(comFlag=="1"){
        PHA.Popover({
            msg: '����Ϊͨ�����̲���ɾ��������ȥ��ѡ���ɣ�',
            type: 'alert',
            timeout: 1000
        });
        return false;
    }
    PHAOP_COM._Confirm("", $g("��ȷ��ɾ����ǰ������") + "<br/>" + $g("���[ȷ��]������ɾ�������[ȡ��]������ɾ��������"), function (r) {
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
                    PHA.Alert('��ʾ', msg, 'warning');
                    return false;
                }else{
                    PHA.Popover({
                        msg: 'ɾ���ɹ�',
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
            msg: '����������̱�����',
            type: 'alert'
        });
        return false;
    }
    var arithmetFlag = $("#arithmetFlag").combobox("getValue")||'';  //��ǰcombobox��ֵ
    if ((arithmetFlag == "") || (arithmetFlag == null)) {
        PHA.Popover({
            msg: '��ѡ��ȡҩ�㷨��',
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
                msg: '���̴����ظ���'+flowCode,
                type: 'alert'
            });
            return false;
            
        }
        
        ExitCodeArr["ExitCodeArr"+flowCode]=""
    }
     var chkRows=$grid.datagrid('getChecked');   //��ȡ���б�ѡ�е���
     var CodeArr=[];
    $.each(chkRows,function(i,data){
        CodeArr["Code"+data.flowCode]=""
        
    })
    if(CodeArr["Code50"]==""){
        if(CodeArr["Code40"]==undefined){
            PHA.Popover({
                msg: '��ҩȷ����Ҫ��ѡ��ҩ��',
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
                msg: '�����ñ������ڣ�',
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
                msg: '�����ú�ʱ������',
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
                msg: '�������Զ����ʱ�䣡',
                type: 'alert'
            });
            return false;
        }
    }
    return true;
}