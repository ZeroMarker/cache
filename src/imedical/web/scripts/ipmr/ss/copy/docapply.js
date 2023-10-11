/**
 * docapply 病案复印--医生申请
 * 
 * CREATED BY WHui 2021-11-23
 */

// 页面全局变量对象
var globalObj = {
    
}

$(function(){
    // 初始化
    Init();

    // 事件初始化
    InitEvent();
})

function Init(){
    var tdateFrom   = Common_GetDate(-30,"");
    var tdateTo     = Common_GetDate(0,""); 
    $('#DateFrom').datebox('setValue', tdateFrom);      // 给日期框赋值
    $('#DateTo').datebox('setValue', tdateTo);          // 给日期框赋值
    Common_ComboToDic("cboRelation","RelationType",1,'');
    Common_ComboToDic("cboCertificate","Certificate",1,'');
    Common_CheckboxToDicID("cbgContentIDs","CopyContent","9");
    Common_CheckboxToDicID("cbgPurposes","CopyPurpose","9");
    // 禁用编辑区域
    setEditPartState('disable');
    InitGridVolList();
    var cboApplyStatus = Common_MultipleComboToDicCode("cboApplyStatus","CopyReqStatus",1,'');
    var ApplyStatusCodeArr = [];
    $m({
        ClassName:"CT.IPMR.BTS.DictionarySrv",
        MethodName:"GetDicsByType",
        aType:'CopyReqStatus',
        aHospID:'',
        aActive:1
    },function(txtData){
        var dicList = txtData.split(String.fromCharCode(1));
        var len = dicList.length;
        for (var i = 0; i < dicList.length; i++) {
            var tdata = dicList[i];
            var tcode = tdata.split(String.fromCharCode(2))[1];
            ApplyStatusCodeArr.push(tcode);
        }
        cboApplyStatus.setValues(ApplyStatusCodeArr);
        // 初始化申请记录
        InitgridApplyList();
        // 加载申请记录
        LoadgridApplyList();
    });
}

function InitEvent(){
    // 病案号|登记号|条码
    $('#txtNumber').bind('keyup', function(event) {                 
    　　if (event.keyCode == "13") {
            NumberSearch();
    　　}
    });

    // 申请人与患者关系为本人事件
    $HUI.combobox('#cboRelation',{
        onSelect:function(e,value){
            setPatInfo(e.Desc);
        }
    })

    // 申请
    $('#btnApply').click(function(){
        SaveCopyApply();
    });

     // 查询
    $('#btnQry').click(function(){
        LoadgridApplyList();
    });
 
    $('#btnEditApply').click(function(){
        SaveApplyMsg();
    });

    $('#btnRemove').click(function(){
        RemoveVol();
    });


}

// 初始复印登记卷列表
function InitGridVolList(){
    var columns = [[
        {field:'volList_ck',title:'sel',checkbox:true},
        {field:'AdmDate',title:'入院日期',width:100,align:'left'},
        {field:'DischDate',title:'出院日期',width:100,align:'left'},
        {field:'AdmLocDesc',title:'就诊科室',width:80,align:'left',showTip:true,tipWidth:100},
        {field:'DischLocDesc',title:'出院科室',width:80,align:'left',showTip:true,tipWidth:100},
        {field:'CopyContent',title:'复印内容',width:70,align:'left',showTip:true,tipWidth:200},
        {field:'CopyPurpose',title:'复印目的',width:70,align:'left',showTip:true,tipWidth:200},
        {field:'CopyNum',title:'复印份数',width:65,align:'left'},
        {field:'GeneratedPDF',title:'生成PDF',width:65,align:'left'}
    ]];
    var gridVolList = $HUI.datagrid("#gridVolList",{
        fit:true,
        headerCls:'panel-header-gray',
        iconCls:'icon-paper',
        pagination: false,   //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers: true,   //如果为true, 则显示一个行号列
        singleSelect:false,
        autoRowHeight: false,   //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
        loadMsg:'数据加载中...',
        pageSize: 100,
        // showPageList:false,
        // pageList:[10,20,50,100],
        fitColumns:true,       //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        checkOnSelect:true,     //true,击某一行时，选中/取消选中复选框
        selectOnCheck:true,     //true,点击复选框将会选中该行
        sortName:'RowIndex',
        sortOrder:'desc',
        url:$URL,
        queryParams:{
            ClassName:"MA.IPMR.SSService.CopyRequestSrv",
            QueryName:"QryVolList",
            aHospID:'',
            aMrTypeID:'',
            aWFItemID:'',
            aNumber:'',
            aDocApplyFlg:'',
            rows:10000
        },
        columns :columns,
        /*toolbar: [{
            id:'btnEditApply',
            text:'保存复印内容、目的、份数到选中行',
            iconCls: 'icon-edit',
            handler: function(){
                SaveApplyMsg();
            }
        },{
            id:'btnRemove',
            text:'移除选中行',
            iconCls: 'icon-remove',
            handler: function(){
                RemoveVol();
            }
        }],*/
        onLoadSuccess:function(data){
            if (data.total>0) {
                var tdata = data.rows[0];

                $("#txtPatName").val(tdata.PatName);
                $("#txtMrNo").val(tdata.MrNo);
                $("#txtPapmiNo").val(tdata.PapmiNo);
                $("#txtSex").val(tdata.Sex);
                $("#txtAge").val(tdata.Age);
            }
        },
        onSelect: function(rowIndex, rowData){
            // 将选中行复印目的、内容、份数赋值到编辑区
            ProEditPart(rowIndex,rowData);
        },
        onUnselect: function(rowIndex, rowData){
            var selLen = $('#gridVolList').datagrid('getSelections').length;
            if (selLen===0) {
                // 清空编辑区
                clearEditPart();
                // 禁用编辑区域
                setEditPartState('disable');
            }
        }
    });
}

// 加载卷列表
function NumberSearch(){
    $('#gridVolList').datagrid('reload',  {
        ClassName:"MA.IPMR.SSService.CopyRequestSrv",
        QueryName:"QryVolList",
        aHospID:Logon.HospID,
        aMrTypeID:parseInt(Logon.MrTypeID),
        aWFItemID:'',
        aNumber:$('#txtNumber').val(),
        aDocApplyFlg:'1',
        rows:10000
    });
    $('#gridVolList').datagrid('unselectAll');
    $('#txtNumber').val('');
}

// 患者关系为本人时，自动加载基本信息
function setPatInfo(value){
    var Data = $('#gridVolList').datagrid('getData').rows;
    var len  = Data.length;
    if (len==0) {
        $.messager.popover({msg: '请先查询待申请病历记录！',type: 'alert',timeout: 2000});
        return;
    }
    if (value==$g("本人")) {
        var VolID = Data[0].VolID;

        $cm({
            ClassName:"MA.IPMR.SSService.VolumeSrv",
            MethodName:"GetPatInfo",
            aVolId:VolID
        },'text',
        function(jsonData){
            var tArray  = jsonData.responseText.split("^");

            $("#txtClientName").val(tArray[0]);
            $("#cboCertificate").combobox('setValue',tArray[1]);
            $("#txtIDCode").val(tArray[3]);
            $("#txtTel").val(tArray[5]);
            $("#txtAddress").val(tArray[4]);
            $("#txtResume").val('');
        });
    } else {
        $("#txtClientName").val('');
        $("#cboCertificate").combobox('setValue','');
        $("#txtIDCode").val('');
        $("#txtTel").val('');
        $("#txtAddress").val('');
        $("#txtResume").val('');
    }
}

// 移除选中行
function RemoveVol(){
    var data = $('#gridVolList').datagrid('getSelections');
    var len  = data.length;

    if (len==0) {
        $.messager.popover({msg: '请勾选至少一条记录！',type: 'alert',timeout: 1000});
        return;
    }
    
    for (var i = 0; i < data.length; i++) {
        var tdata = data[i];
        var index = $('#gridVolList').datagrid('getRowIndex',tdata);

        $('#gridVolList').datagrid('deleteRow',index);
    }
    // 清空编辑区域
    clearEditPart();
    // 禁用编辑区域
    setEditPartState('disable');
}

// 清空编辑区
function clearEditPart(){
    $("input[name='cbgContentIDs']").each(function () {
        $(this).checkbox('setValue',false);
    });
    $("input[name='cbgPurposes']").each(function () {
        $(this).checkbox('setValue',false);
    });
    $("#txCopyNum").val('');
}

// 获取编辑区值
function getEditPartData(flg){
    if (typeof(flg) =='undefined') flg='';
    var ContentIDs  = Common_CheckboxValue("cbgContentIDs").split(',').sort().toString();   // 复印内容
    var Purposes    = Common_CheckboxValue("cbgPurposes").split(',').sort().toString();     // 复印目的
    var CopyNum     = $("#txCopyNum").val();    // 复印份数
    var ContentDesc = Common_CheckboxLabel("cbgContentIDs");    // 复印内容描述
    var PurposeDesc = Common_CheckboxLabel("cbgPurposes");      // 复印目的描述
    if (flg=='all') {
        return  ContentIDs + "^" + Purposes + "^" +CopyNum + "^" + 
                ContentDesc + "^" +PurposeDesc;
    } else {
        return  ContentIDs + "^" + Purposes + "^" +CopyNum;
    }
}

// 设置编辑区的可编辑状态   disable|enable
function setEditPartState(state){
    $("input[name='cbgContentIDs']").each(function () {
        $(this).checkbox('setDisable',(state=='disable'));
    });
    $("input[name='cbgPurposes']").each(function () {
        $(this).checkbox('setDisable',(state=='disable'));
    });
    $("#txCopyNum").attr("disabled", (state=='disable'));
    var mydiv = document.getElementById('p2');
    if (state=='disable') {
        //mydiv.style.backgroundColor='#cecece'; 
    }else{
        //mydiv.style.backgroundColor='#fedcbd'; 
    }
}

// 处理编辑区域
function ProEditPart(rowIndex,rows,allSelFlg){
    if (allSelFlg=='all') {
        // TODO:全选时怎么赋值？暂时将第一行的值赋值到编辑区
        var rowData = rows[0];
    } else {
        var rowData = rows;
    }

    // 1、获取编辑区域现有值
    var oldData = getEditPartData();
    var newData = rowData.CopyContentIDs.split(',').sort().toString() + "^" + 
                  rowData.CopyPurposeIDs.split(',').sort().toString() + "^" + 
                  rowData.CopyNum;

    if ((oldData=='^^')||(oldData==newData)) {
        // 2、赋值
        setValueToEditPart(rowData);
    } else {
        $.messager.confirm("赋值", "选中行复印内容、目的、份数与编辑区不一致，是否继续赋值?", function (r) {
            if (r) {
                // 2、赋值
                setValueToEditPart(rowData);
            } else {
                $('#gridVolList').datagrid('unselectRow',rowIndex);
                return;
            }
        });
    }
}

// 将选中行复印目的、内容、份数赋值到编辑区
function setValueToEditPart(rowData){
    // 1、设置多选框、输入框可用
    setEditPartState('enable');
    // 2、赋值
    var arrContent  = rowData.CopyContentIDs.split(",");
    var arrPurpose  = rowData.CopyPurposeIDs.split(",");
    var CopyNum     = rowData.CopyNum;
    $("input[name='cbgContentIDs']").each(function () {
        var dicid   = this.id.split('cbgContentIDs')[1];
        var exist   = $.hisui.indexOfArray(arrContent,dicid);
        if (exist>-1) {
            $(this).checkbox('setValue',true);
        }else{
            $(this).checkbox('setValue',false);
        }
    });
    $("input[name='cbgPurposes']").each(function () {
        var dicid   = this.id.split('cbgPurposes')[1];
        var exist   = $.hisui.indexOfArray(arrPurpose,dicid);
        if (exist>-1) {
            $(this).checkbox('setValue',true);
        }else{
            $(this).checkbox('setValue',false);
        }
    });
    $("#txCopyNum").val(CopyNum);
}

// 保存复印内容、目的、份数到选中行
function SaveApplyMsg(){
    var selData = $('#gridVolList').datagrid('getSelections');
    var selLen  = selData.length;
    if (selLen===0) {
        $.messager.popover({msg: '请勾选至少一条记录！',type: 'alert',timeout: 1000});
        return;
    }
    var arrEditPartData = getEditPartData('all').split('^');
    var ContentIDs  = arrEditPartData[0];   // 复印内容
    var Purposes    = arrEditPartData[1];   // 复印目的
    var CopyNum     = arrEditPartData[2];   // 复印份数
    var ContentDesc = arrEditPartData[3];   // 复印内容描述
    var PurposeDesc = arrEditPartData[4];   // 复印目的描述

    for (var index = 0; index < selLen; index++) {
        // 1、选中行原来值
        var rowdata = selData[index];
        var tIndex  = $('#gridVolList').datagrid('getRowIndex',rowdata);
        
        // 2、根据编辑区域的值改变row值
        rowdata.CopyContentIDs = ContentIDs;
        rowdata.CopyContent = ContentDesc;

        rowdata.CopyPurposeIDs = Purposes;
        rowdata.CopyPurpose = PurposeDesc;

        rowdata.CopyNum = CopyNum;
        
        // 3、将改变后的值更新到选中行
        $('#gridVolList').datagrid('updateRow',{
            index: tIndex,
            row: rowdata    //tmpdata
        });
        // 4、取消选中
        $('#gridVolList').datagrid('unselectRow',index);
    }
    // 清空编辑区域值
    clearEditPart();
}

// 保存申请信息
function SaveCopyApply(){
    var ClientName  = $("#txtClientName").val();
    var Relation    = $("#cboRelation").combobox('getValue');
    var Certificate = $("#cboCertificate").combobox('getValue');
    var IDCode      = $("#txtIDCode").val();
    var Tel         = $("#txtTel").val();
    var Address     = $("#txtAddress").val();
    var Resume      = $("#txtResume").val();
    if (ClientName=='') {
        $.messager.popover({msg: '申请人姓名不能为空！',type: 'alert',timeout: 1000});
        return;
    }
    if (Relation=='') {
        $.messager.popover({msg: '与患者关系不能为空！',type: 'alert',timeout: 1000});
        return;
    }
    if (Certificate=='') {
        $.messager.popover({msg: '申请人证件类型不能为空！',type: 'alert',timeout: 1000});
        return;
    }
    if (IDCode=='') {
        $.messager.popover({msg: '申请人证件号码不能为空！',type: 'alert',timeout: 1000});
        return;
    }
    if (Tel=='') {
        $.messager.popover({msg: '申请人电话不能为空！',type: 'alert',timeout: 1000});
        return;
    }
    if (Address=='') {
        $.messager.popover({msg: '申请人地址不能为空！',type: 'alert',timeout: 1000});
        return;
    }
    var Str1 = ClientName + '^' + 
               Relation + '^' + 
               Certificate + '^' + 
               IDCode + '^' + 
               Tel + '^' + 
               Address + '^' +
               Resume + '^' +
               Logon.UserID + '^' +
               'D' + '^' +  // 申请类型,D:医生申请,P:患者申请
               '' + '^' +   // CopyRequest.ID
               'DR'         // 病案复印申请表操作状态 (医生申请)

    var data = $('#gridVolList').datagrid('getSelections');
    var len  = data.length;
    if (len==0) {
        $.messager.popover({msg: '请勾选至少一条申请记录！',type: 'alert',timeout: 1000});
        return;
    }
    var strResult = '';
    for (var index = 0; index < data.length; index++) {
        var row = data[index];
        if (
            (row.CopyContentIDs==='')||(row.CopyContent==='')||
            (row.CopyPurposeIDs==='')||(row.CopyPurpose==='')||
            (row.CopyNum==='')
            ) {
                $.messager.popover({msg: '复印内容、目的、份数部分或全部为空！',type: 'alert',timeout: 2000});
                return;
        }
        if (strResult != '') strResult += '!'
        strResult += '^' + row.VolID
        strResult += '^' + row.CopyContentIDs
        strResult += '^' + row.CopyPurposeIDs
        strResult += '^' + row.CopyNum
    }
    var flg = $m({
        ClassName:"MA.IPMR.SSService.CopyRequestSrv",
        MethodName:"SaveCopyReg",
        aPersonInfo:Str1,
        aCopyInfo:strResult,
    },false);

    if (parseInt(flg) <= 0) {
        $.messager.alert("错误", flg.split('^')[1], 'error');
        return;
    }else{
       $.messager.popover({msg:'申请成功',type:'success',timeout: 1000});
    }
    // 清空申请区域
    clearApplyInfo();
    // 加载申请记录
    LoadgridApplyList();
}

// 清空申请区域
function clearApplyInfo(){
    // 清空编辑区域
    clearEditPart();
    // 清空申请人信息
    $("#txtClientName").val('');
    $("#cboCertificate").combobox('setValue','');
    $("#txtIDCode").val('');
    $("#txtTel").val('');
    $("#txtAddress").val('');
    $("#txtResume").val('');
    // 清空患者信息
    $("#txtPatName").val('');
    $("#txtMrNo").val('');
    $("#txtPapmiNo").val('');
    $("#txtSex").val('');
    $("#txtAge").val('');
    // 清空列表信息
    $("#gridVolList").datagrid("loadData", {"rows":[],"total":0});
    // 清空查询条件
    $("#txtNumber").val('');
}

// 申请记录模块
function InitgridApplyList(){
    var columns = [[
        // {field:'CopyReqID',title:'申请ID',width:100,align:'left'},
        {field:'MrNo',title:'病案号',width:80,align:'left'},
        {field:'DisLocDesc',title:'出院科室',width:100,align:'left'},
        {field:'DisDate',title:'出院日期',width:100,align:'left'},
        {field:'ClientName',title:'申请人',width:100,align:'left'},
        {field:'RegDate',title:'申请日期',width:100,align:'left'},
        {field:'RegTime',title:'申请时间',width:80,align:'left'},
        {field:'ClientRelationDesc',title:'与患者关系',width:100,align:'left'},
        {field:'IdentityCode',title:'证件号',width:180,align:'left'},
        {field:'LatestStatusDesc',title:'申请状态',width:80,align:'left'},
        {field:'Telephone',title:'联系电话',width:100,align:'left'},
        {field:'ContentDesc',title:'复印内容',width:180,align:'left'},
        {field:'PurposeIDDesc',title:'复印目的',width:100,align:'left'},
        {field:'CopyNum',title:'复印份数',width:80,align:'left'}
    ]];
    var gridApply =$HUI.datagrid("#gridApply",{
        fit: true,
        //title: "",
        headerCls:'panel-header-gray',
        iconCls:'icon-paper',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers: true, //如果为true, 则显示一个行号列
        singleSelect: true,
        autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
        loadMsg:'数据加载中...',
        pageSize: 20,
        fitColumns:false,
        checkOnSelect:true,     //true,击某一行时，选中/取消选中复选框
        selectOnCheck:true,     //true,点击复选框将会选中该行
        pageList : [20,50,100,200],
        url:$URL,
        queryParams:{
            ClassName:"MA.IPMR.SSService.CopyRequestSrv",
            QueryName:"QryReqList",
            aHospID:'',
            aMrTypeID:'',
            aDateFrom:'',
            aDateTo:'',
            aStatusCode: '',
            aNumber:'',
            aCopyReqID:'',
            aReqUserID:''
        },
        columns:columns
    });
    return gridApply;
}

function LoadgridApplyList(){
    var data = $("#cboApplyStatus").combobox('getValues');
    var len  = data.length;
    var StatusCodeStr='';
    for (var i = 0; i < data.length; i++) {
        var tcode = data[i];
        if (StatusCodeStr=='') {
            StatusCodeStr = tcode;
        } else {
            StatusCodeStr = StatusCodeStr + ',' + tcode;
        }
    }
    $('#gridApply').datagrid('reload',  {
        ClassName:"MA.IPMR.SSService.CopyRequestSrv",
        QueryName:"QryReqList",
        aHospID:'',
        aMrTypeID:'',
        aDateFrom:$('#DateFrom').datebox('getValue'),
        aDateTo:$('#DateTo').datebox('getValue'),
        aStatusCode: StatusCodeStr,
        aNumber:'',
        aCopyReqID:'',
        aReqUserID:Logon.UserID,
        rows:10000
    });
    $('#gridApply').datagrid('unselectAll');
}