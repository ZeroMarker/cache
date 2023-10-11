/**
 * register 病案复印登记
 * 
 * CREATED BY WHui 2021-11-23
 */

// 页面全局变量对象
var globalObj = {
    m_RegSelData:[],   // 点击登记时，主页选中数据
    m_WFIConfig :'',    // 操作项目配置属性
}

$(function(){
    // 初始化
    Init();

    // 事件初始化
    InitEvent();
})

function Init(){
    var tdateFrom   = Common_GetDate(-7,"");
    var tdateTo     = Common_GetDate(0,""); 
    $('#dfDateFrom').datebox('setValue', tdateFrom);        // 给日期框赋值
    $('#dfDateTo').datebox('setValue', tdateTo);            // 给日期框赋值
    Common_ComboToHosp("cboHospital",'',Logon.HospID);
    Common_ComboToMrType("cboMrType",ServerObj.MrClass);
    InitGridVolList();
}

function InitEvent(){
    $HUI.combobox('#cboMrType',{
        onSelect:function(rows){
            $m({
                ClassName:"CT.IPMR.BT.WorkFItem",
                MethodName:"GetWFItemBySysOpera",
                aMrTypeID:rows["ID"],
                aSysOpera:'C',
                aWorkSubFlow:'C'
            },function(rtn){
                if (rtn==''){
                    $.messager.alert("提示", "工作流维护错误，请检查工作流配置!", 'info');
                    return;
                }
                rtn = JSON.parse(rtn);
                globalObj.m_WFIConfig = {
                    WFItemID    : rtn.ID,
                    WFItemDesc  : rtn.BWAlias,
                    ItemID      : rtn.BWItem,
                    ItemType    : rtn.BWType,
                    SubFlow     : rtn.BWSubFlow,
                    SysOpera    : rtn.BWSysOpera,
                    PreStep     : rtn.BWPreStep,
                    PreItems    : rtn.BWPreItems,
                    PostStep    : rtn.BWPostStep,
                    CheckUser   : rtn.BWCheckUser,
                    BeRequest   : rtn.BWBeRequest,
                    BatchOper   : rtn.BWBatchOper,
                    MRCategory  : rtn.BWMRCategory
                }
                NumberSearch();
            });
        }
    });

    $HUI.combobox('#cboHospital',{
        onSelect:function(rows){
            $('#txtNumber').val('');
            NumberSearch();
        }
    });

    // 病案号|登记号|条码
    $('#txtNumber').bind('keyup', function(event) {                 
    　　if (event.keyCode == "13") {
            NumberSearch();
    　　}
    });

    // 登记
    $('#btnRegister').click(function(){
        CopyRegister();
    });
}

// 初始复印登记卷列表
function InitGridVolList(){
    var columns = [[
        {field:'volList_ck',title:'sel',checkbox:true},
        {field:'PatName',title:'姓名',width:120,align:'left'},
        {field:'MrNo',title:'病案号',width:100,align:'left'},
        {field:'PapmiNo',title:'登记号',width:100,align:'left'},
        {field:'Sex',title:'性别',width:60,align:'left'},
        {field:'Age',title:'年龄',width:60,align:'left'},
        {field:'AdmDate',title:'入院日期',width:100,align:'left'},
        {field:'DischDate',title:'出院日期',width:100,align:'left'},
        {field:'DischLocDesc',title:'出院科室',width:150,align:'left'},
        {field:'DischWardDesc',title:'出院病区',width:150,align:'left'},
        {field:'CopyContent',title:'复印内容',width:150,align:'left',showTip:true,tipWidth:200},
        {field:'CopyPurpose',title:'复印目的',width:150,align:'left',showTip:true,tipWidth:200},
        {field:'CopyStatus',title:'复印流程状态',width:150,align:'left'},
        {field:'GeneratedPDF',title:'是否生成PDF',width:150,align:'left'}
    ]];
    var gridVolList = $HUI.datagrid("#gridVolList",{
        fit:true,
        headerCls:'panel-header-gray',
        iconCls:'icon-paper',
        pagination: true,   //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers: true,   //如果为true, 则显示一个行号列
        singleSelect:false,
        autoRowHeight: false,   //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
        loadMsg:'数据加载中...',
        pageSize: 500,
        pageList:[100,200,500,1000],
        fitColumns:false,       //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
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
            rows:10000
        },
        columns :columns
    });
}

// 加载卷列表
function NumberSearch(){
    $('#gridVolList').datagrid('reload',  {
        ClassName:"MA.IPMR.SSService.CopyRequestSrv",
        QueryName:"QryVolList",
        aHospID:$('#cboHospital').combobox('getValue'),
        aMrTypeID:parseInt($('#cboMrType').combobox('getValue')),
        aWFItemID:globalObj.m_WFIConfig.WFItemID,
        aNumber:$('#txtNumber').val(),
        rows:10000
    });
    $('#gridVolList').datagrid('unselectAll');
}

/**
 * 复印登记 编辑模块
 */

// 获取登记主界面选中数据
function getSelData(){
    globalObj.m_RegSelData  = [];
    var selData = $('#gridVolList').datagrid('getSelections');
    
    for (var index = 0; index < selData.length; index++) {
        var tRow = selData[index];
        var tmpData = {
            AdmDate         : tRow.AdmDate,
            AdmLocDesc      : tRow.AdmLocDesc,
            AdmLocID        : tRow.AdmLocID,
            Age             : tRow.Age,
            CopyContent     : tRow.CopyContent,
            CopyContentIDs  : tRow.CopyContentIDs,
            CopyNum         : tRow.CopyNum,
            CopyPurpose     : tRow.CopyPurpose,
            CopyPurposeIDs  : tRow.CopyPurposeIDs,
            CopyStatus      : tRow.CopyStatus,
            DischDate       : tRow.DischDate,
            DischLocDesc    : tRow.DischLocDesc,
            DischLocID      : tRow.DischLocID,
            DischWardDesc   : tRow.DischWardDesc,
            DischWardID     : tRow.DischWardID,
            DocName         : tRow.DocName,
            EpisodeID       : tRow.EpisodeID,
            GeneratedPDF    : tRow.GeneratedPDF,
            MrNo            : tRow.MrNo,
            PapmiNo         : tRow.PapmiNo,
            PatName         : tRow.PatName,
            PatientID       : tRow.PatientID,
            Sex             : tRow.Sex,
            VolID           : tRow.VolID
        };
        
        globalObj.m_RegSelData.push(tmpData);
    }

    
    return globalObj.m_RegSelData;
}

function CopyRegister(){
    var ReqVolsData = getSelData();

    /* var selData = $('#gridVolList').datagrid('getSelections');
    var ReqVolsData = selData; */
    
    var ReqLen  = ReqVolsData.length;
    if (ReqLen==0) {
        $.messager.popover({msg: '请至少勾选一条信息！',type: 'alert',timeout: 1000});
        return;
    }
    
    var _title = $g("复印登记")+'&nbsp;'+ReqVolsData[0].PatName+"/"+ReqVolsData[0].MrNo
                ,_icon="icon-w-edit";
    $('#CopyRegisterDialog').css('display','block');
    var CopyRegisterDialog = $HUI.dialog('#CopyRegisterDialog',{
        title: _title,
        iconCls: _icon,
        closable: true,
        modal: true,
        minimizable:false,
        maximizable:false,
        collapsible:false,
        onBeforeOpen: function(){
            Common_ComboToDic("cboRelation","RelationType",1,'');
            Common_ComboToDic("cboCertificate","Certificate",1,'');
            Common_CheckboxToDicID("cbgContentIDs","CopyContent","7");
            Common_CheckboxToDicID("cbgPurposes","CopyPurpose","7");

            // 申请人与患者关系为本人事件
            $HUI.combobox('#cboRelation',{
                onSelect:function(e,value){
                    setPatInfo(e.Code);
                }
            })

            // 加载复印登记列表
            loadReqVols(ReqVolsData);
            
            // 判断各卷复印内容、目的、复印份数是否一致
            var flg = chkVolCopyData(ReqVolsData);
            if (flg=='true') {
                $('#gridReqVols').datagrid('selectAll');
            }else{
                // 禁用编辑区域
                setEditPartState('disable');
            }
        },
        onClose: function(){
            // 清空复印登记界面
            clearRegister();
        },
        buttons:[{
            text:'保存',
            iconCls:'icon-w-save',
            handler:function(){
                SaveCopyRegister();
            }
        },{
            text:'关闭',
            iconCls:'icon-w-close',
            handler:function(){
                closeView();
            }   
        }]
    });
}

// 将主界面选中的卷列表加载到申请列表
function loadReqVols(data){
    var columns = [[
        {field:'reqVol_ck',title:'sel',checkbox:true},
        {field:'AdmDate',title:'入院日期',width:150,align:'left'},
        {field:'DischDate',title:'出院日期',width:150,align:'left'},
        {field:'DischLocDesc',title:'出院科室',width:150,align:'left'},
        {field:'CopyContent',title:'复印内容',width:150,align:'left',showTip:true,tipWidth:200},
        {field:'CopyPurpose',title:'复印目的',width:150,align:'left',showTip:true,tipWidth:200},
        {field:'CopyNum',title:'复印份数',width:100,align:'left'},
    ]];

    var gridReqVols = $HUI.datagrid("#gridReqVols",{
        fit: true,
        title:'病案信息',
        headerCls:'panel-header-gray',
        iconCls:'icon-paper',
        rownumbers: true,
        singleSelect: false,
        autoRowHeight: false,
        loadMsg: '数据加载中...',
        fitColumns: true,
        columns: columns,
        data:data,
        toolbar: [{
            id:'btnEditReg',
            text:'保存复印信息',
            iconCls: 'icon-save',
            handler: function(){
                SaveRegMsg();
            }
        }],
        onLoadSuccess: function(data){},
        onSelect: function(rowIndex, rowData){
            // 将选中行复印目的、内容、份数赋值到编辑区
            ProEditPart(rowIndex,rowData);
        },
        onUnselect: function(rowIndex, rowData){
            var selLen = $('#gridReqVols').datagrid('getSelections').length;
            if (selLen===0) {
                // 清空编辑区
                clearEditPart();
                // 禁用编辑区域
                setEditPartState('disable');
            }/*  else {
                $.messager.confirm("清空编辑区", "还有其他卷处于选中状态，是否清空编辑区域", function (r) {
                    if (r) {
                        // 清空编辑区
                        clearEditPart();
                    } else {
                        $.messager.popover({ msg: "点击了取消" });
                    }
                });
            } */
        },
        onSelectAll: function(rows){
            ProEditPart('',rows,'all');
        },
        onUnselectAll: function(rows){
            // 清空编辑区
            clearEditPart();
            // 禁用编辑区域
            setEditPartState('disable');
        }
    });
}

// 判断要加载到登记界面的各卷：复印内容、目的、复印份数是否一致
function chkVolCopyData(data){
    var flg = 'true';

    var len = data.length;
    if (len==1) {return flg};

    var line1Data = data[0].CopyContentIDs.split(',').sort().toString() + "^" + 
                    data[0].CopyPurposeIDs.split(',').sort().toString() + "^" + 
                    data[0].CopyNum;

    for (var index = 0; index < len; index++) {
        var row = data[index];
        var tmpLineData = data[index].CopyContentIDs.split(',').sort().toString() + "^" + 
                        data[index].CopyPurposeIDs.split(',').sort().toString() + "^" + 
                        data[index].CopyNum;
        
        if (tmpLineData!=line1Data) {
            var flg = 'false';
            break;
        }
    }

    return flg;
}

// 关闭复印登记详情页
function closeView(){
    globalObj.m_RegSelData  = [];

    $('#CopyRegisterDialog').window("close");
}

/* // 设置“编辑复印内容、目的、份数”按钮是否可用
function setBtnEditRegPower(){
    var selData = $('#gridReqVols').datagrid('getSelections');
    var selLen  = selData.length;

    if (selLen===0) {
        $('#btnEditReg').linkbutton('disable');
    } else {
        $('#btnEditReg').linkbutton("enable");
    }
} */

// 保存复印内容、目的、份数到选中行
function SaveRegMsg(){
    var selData = $('#gridReqVols').datagrid('getSelections');
    var selLen  = selData.length;
    if (selLen===0) {
        $.messager.popover({msg: '请选择至少一条数据！',type: 'alert',timeout: 1000});
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
        var tIndex  = $('#gridReqVols').datagrid('getRowIndex',rowdata);
        
        // 2、根据编辑区域的值改变row值
        rowdata.CopyContentIDs = ContentIDs;
        rowdata.CopyContent = ContentDesc;

        rowdata.CopyPurposeIDs = Purposes;
        rowdata.CopyPurpose = PurposeDesc;

        rowdata.CopyNum = CopyNum;
        
        // 3、将改变后的值更新到选中行
        $('#gridReqVols').datagrid('updateRow',{
            index: tIndex,
            row: rowdata    //tmpdata
        });
        // 4、取消选中
        $('#gridReqVols').datagrid('unselectRow',index);
    }

    // 清空编辑区域值
    clearEditPart();
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
                $('#gridReqVols').datagrid('unselectRow',rowIndex);
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

// 清空复印登记界面
function clearRegister(){
    clearEditPart();

    $("#txtClientName").val('');
    $("#cboCertificate").combobox('setValue','');
    $("#txtIDCode").val('');
    $("#txtTel").val('');
    $("#txtAddress").val('');
    $("#txtResume").val('');

    $("#gridReqVols").datagrid('load',{"rows":[],"total":0});
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
}

// 患者关系为本人时，自动加载基本信息
function setPatInfo(value){
    if (value=='BR') {
        var VolID = $('#gridVolList').datagrid('getSelections')[0].VolID;

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

// 保存复印登记信息
function SaveCopyRegister(){
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
               'P' + '^' +  // 申请类型,D:医生申请,P:患者申请
               '' + '^' +   // CopyRequest.ID
               'Reg'        // 病案复印申请表操作状态
               

    var data = $('#gridReqVols').datagrid('getData').rows;
    var len  = data.length;
    if (len==0) {
        $.messager.alert("提示", "复印申请列表不能为空!", 'info');
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
        $.messager.popover({msg: '登记成功',type:'success',timeout: 1000});
        $('#CopyRegisterDialog').window("close");
    }
}