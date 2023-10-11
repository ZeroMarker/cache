/**
 * 医保医师信息JS
 * FileName:insucareprovrecinfo.js
 * DingSH 2018-10-18
 * 版本：V1.0
 * hisui版本:0.1.0
 */
var InCPRowid = "";
var HospDr = '';
var GUser = session['LOGON.USERID'];
var CPRowIndex = -1;
var CPRecRowIndex = -1;
$(function () {
    $(document).keydown(function (e) {
        banBackSpace(e);
    });

    //#1初始化医保类型	
    InitInsuTypeCmb()
    //#2初始化医保科室gd
    InitInCPDg()

    //#3初始化医保科室记录gd
    InitInCPRecDg()

    //#4初始化Btn事件
    InitBtnClick();

    //#5隐藏元素
    $('#CPDlEd').hide();
    $('#CPRecDlEd').hide();
    $('#CPRecDlBd').hide();

});

//初始化Btn事件
function InitBtnClick() {


    //关键字回车事件
    $("#KeyWords").keydown(function (e) {
        KeyWords_onkeydown(e);
    });

    $("#btnS").click(function () {
        UpdateInCP();
        QryInCP();

    });

    $("#btnC").click(function () {
        QryInCP();
        $('#CPDlEd').window('close');
    });


    $("#btnS1").click(function () {
        //QryInLoc();
        UpdateInCPRec();
        QryInCPRec();
    });

    $("#btnC1").click(function () {
        //QrylocRecDlEd();
        $('#CPRecDlEd').window('close');
    });

    $("#btnRbd").click(function () {
        ReBuildInCPRec();
    });

    $("#btnRbC").click(function () {
        //QrylocRecDlEd();
        $('#CPRecDlBd').window('close');
    });


}


//关键字回车事件
function KeyWords_onkeydown(e) {
    if (e.keyCode == 13) {
        QryInCP();

    }
}


//查询医师信息事件
function QryInCP() {

    //var stdate=$('#stdate').datebox('getValue');
    //var endate=$('#endate').datebox('getValue');
    var InRowid = ""
    var KeyWords = $('#KeyWords').val()
    //alert("KeyWords="+KeyWords)
    $('#cpdg').datagrid('options').url = $URL
    $('#cpdg').datagrid('reload', {
        ClassName: 'web.DHCINSUCareProvCtl',
        QueryName: 'QryInCPInfo',
        InRowid: InRowid,
        KeyWords: KeyWords,
        HospDr: PUBLIC_CONSTANT.SESSION.HOSPID
    });
}



//查询医保科室上传记录事件
function QryInCPRec() {
    var InRowid = ""
    var InsuType = $('#InsuType').combobox("getValue")
    //alert("InCPRowid="+InCPRowid)
    $('#cprecdg').datagrid('options').url = $URL
    $('#cprecdg').datagrid('reload', {
        ClassName: 'web.DHCINSUCareProvRecCtl',
        QueryName: 'QryInCPRecInfo',
        InCPRowid: InCPRowid,
        InsuType: InsuType,
        HospDr: PUBLIC_CONSTANT.SESSION.HOSPID
    });

}

//初始化医保类型gd
function InitInsuTypeCmb() {
    //初始化combobox
    $HUI.combobox("#InsuType", {
        valueField: 'cCode',
        textField: 'cDesc',
        panelHeight: 120,
        onSelect: function (rec) {
            QryInCPRec();

        }
    });
    var comboJson = $.cm({
        ClassName: "web.INSUDicDataCom",
        QueryName: "QueryDic",
        Type: "DLLType",
        Code: "",
        HospDr: PUBLIC_CONSTANT.SESSION.HOSPID
    }, false)
    $HUI.combobox("#InsuType").loadData(comboJson.rows)

}

//初始化医保医师gd
function InitInCPDg() {


    //初始化datagrid
    $HUI.datagrid("#cpdg", {
        //idField:'dgid',
        fit:true,
        //url:$URL,
        singleSelect: true,
        border: false,
        //autoRowHeight:false,
        data: [],
        frozenColumns: [[
            {
                field: 'TOpt',
                width: 40,
                title: '操作',
                formatter: function (value, row, index) {

                    return "<img class='myTooltip' style='width:60' title='医师信息修改' onclick=\"InCPEditClick('" + index + "')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_pen.png' style='border:0px;cursor:pointer'>";

                }
            }

        ]],

        columns: [[
            { field: 'TInd', title: 'TInd', width: 10, hidden: true },
            { field: 'TRowid', title: 'TRowid', width: 10, hidden: true },
            { field: 'TCPCode', title: '医师编码', width: 140 },
            { field: 'TCPName', title: '医师名称', width: 180 },
            { field: 'TIDType', title: '证件类型', width: 150, hidden: true },
            { field: 'TIDTypeDesc', title: '证件类型', width: 100 },
            { field: 'TIDNo', title: '证件号码', width: 140 },
            { field: 'TSex', title: '性别 ', width: 60 },
            { field: 'TNation', title: '民族', width: 60, align: 'center' },
            { field: 'TBOD', title: '出生日期', width: 120 },
            { field: 'TTelNo', title: '联系电话', width: 120 },
            { field: 'TDeptDr', title: '科室Dr', width: 50, hidden: true },
            { field: 'TDeptCode', title: '科室编号', width: 100 },
            { field: 'TDeptDesc', title: '科室名称', width: 110 },
            { field: 'TJobTitle', title: '职称（级别）', width: 50, hidden: true },
            { field: 'TAdminPost', title: '行政职务', width: 50, hidden: true },
            { field: 'TAcadePostd', title: '学术职务', width: 120, hidden: true },
            { field: 'TCollege', title: '毕业院校', width: 120, hidden: true },
            { field: 'TEducation', title: '学历', width: 100, hidden: true },
            { field: 'TProfession', title: '所学专业', width: 120, hidden: true },
            { field: 'TPatType', title: '医院人员类别', width: 140, hidden: true },
            { field: 'TAppoitNo', title: '医院聘书编码', width: 150, hidden: true },
            { field: 'TMSQCNo', title: '资格证书编码', width: 150, hidden: true },
            { field: 'TMSQCMajor', title: '资格证专业', width: 50, hidden: true },
            { field: 'TMSQCType', title: '资格证类别', width: 50, hidden: true },
            { field: 'TMCNo', title: '执业证书编码', width: 140 },
            { field: 'TMCType', title: '执业类别', width: 50, hidden: true },
            { field: 'TMCMajor', title: '执业范围（专业）', width: 10, hidden: true },
            { field: 'TMSQCStDate', title: '执业开始时间', width: 140 },
            { field: 'TMSQCEdDate', title: '执业结束时间', width: 140 },
            { field: 'TMajorDiags', title: '主治疾病内容', width: 140, hidden: true },
            { field: 'MajorDiagType', title: '疾病种类', width: 140, hidden: true },
            { field: 'TMSQCRegDate', title: '执业证书注册日期', width: 160 },
            { field: 'TMSQCMultiFlagr', title: '是否多点执业', width: 50, hidden: true },
            { field: 'TMSQCAddr1', title: '第一执业地点', width: 50, hidden: true },
            { field: 'TMSQCAddr2', title: '第二执业地点', width: 50, hidden: true },
            { field: 'TMSQCAddr3', title: '第三执业地点', width: 50, hidden: true },
            { field: 'TMSQCAddrN', title: '其它执业注册地', width: 50, hidden: true },
            { field: 'TDoctLevel', title: '医师级别', width: 50, hidden: true },
            { field: 'TNurseLevel', title: '护师级别', width: 50, hidden: true },
            { field: 'TMediPrescFlag', title: '医保处方权', width: 50, hidden: true },
            { field: 'TOpTsPrescFlag', title: '门诊特殊病开单标志', width: 180 },
            { field: 'TInsuDoctFlag', title: '医保医师标识', width: 120 },
            { field: 'TStDate', title: '备案开始日期', width: 50, hidden: true },
            { field: 'TEdDate', title: '备案结束日期', width: 50, hidden: true },
            { field: 'TActFlag', title: '有效标识', width: 50, hidden: true },
            { field: 'TMediPatype', title: '卫生技术人员类别', width: 50, hidden: true },
            { field: 'TUserDr', title: '经办人', width: 100, hidden: true },
            { field: 'TUserName', title: '经办人', width: 100 },
            { field: 'TDate', title: '经办日期', width: 50, hidden: true },
            { field: 'TTime', title: '经办时间', width: 50, hidden: true },
            { field: 'TExtStr01', title: '扩展01', width: 50, hidden: true },
            { field: 'TExtStr02', title: '扩展03', width: 50, hidden: true },
            { field: 'TExtStr03', title: '扩展03', width: 50, hidden: true },
            { field: 'TExtStr04', title: '扩展04', width: 50, hidden: true },
            { field: 'TExtStr05', title: '扩展05', width: 50, hidden: true },
            { field: 'THospDr', title: '院区ID', width: 50, hidden: true }
        ]],
        pageSize: 10,
        pagination: true,
        onClickRow: function (rowIndex, rowData) {

            //alert("rowData="+rowData.TRowid)   
            InCPRowid = rowData.TRowid;
            QryInCPRec();

        },
        onDblClickRow: function (rowIndex, rowData) {
            //initCPFrm(rowIndex, rowData);
        },
        onUnselect: function (rowIndex, rowData) {
            //alert(rowIndex+"-"+rowData.itemid)
        },
        onLoadSuccess: function (data) {
            var index = 0;
            if (data.total > 0) {
                if (CPRowIndex >= 0) {
                    index = CPRowIndex
                }
                $('#cpdg').datagrid('selectRow', index);
            }
            CPRowIndex = -1;
        }
    });

}

//初始化医保科室记录gd
function InitInCPRecDg() {
    //初始化datagrid
    $HUI.datagrid("#cprecdg", {
		fit:true,        
        singleSelect: true,
        border: false,
        data: [],
        frozenColumns: [[
            {
                field: 'TOpt1',
                width: 40,
                title: '操作',
                formatter: function (value, row, index) {

                    return "<img class='myTooltip' style='width:60' title='上传记录修改' onclick=\"InCPRecEditClick('" + index + "')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/write_order.png' style='border:0px;cursor:pointer'>";

                }
            }

        ]],
        columns: [[
            { field: 'TInd', title: 'TInd', width: 10, hidden: true },
            { field: 'TRowid', title: 'TRowid', width: 10, hidden: true },
            { field: 'TCPDr', title: '医保医师信息指针', width: 60, hidden: true },
            { field: 'TCenterNo', title: '统筹区编码', width: 100 },
            { field: 'TStates', title: '行政区代码', width: 100 },
            { field: 'TSeriNo', title: '申请流水号', width: 100 },
            { field: 'TBusiNo', title: '发送方交易流水号', width: 150, hidden: true },
            { field: 'TInsuType', title: '医保类型', width: 80, align: 'center', hidden: true },
            { field: 'TInsuTypeDesc', title: '医保类型', width: 80, align: 'left' },
            { field: 'THSPUserDr', title: '医院审批人', width: 60, hidden: true },
            { field: 'THSPUserCode', title: '医院审批人', width: 60, hidden: true },
            { field: 'THSPUserName', title: '医院审批人', width: 120 },
            { field: 'THSPFlag', title: '医院审批状态', width: 140 },
            { field: 'THSPDate', title: '医院审批日期', width: 140 },
            { field: 'THSPTime', title: '医院审批时间', width: 140 },
            { field: 'TISPUserDr', title: '医保审批人', width: 140, hidden: true },
            { field: 'TISPFlag', title: '医保审批状态', width: 140 },
            { field: 'TISPDate', title: '医保审批日期', width: 140 },
            { field: 'TISPTime', title: '医保审批时间', width: 140 },
            { field: 'TUserDr', title: '经办人', width: 60, hidden: true },
            { field: 'TUserCode', title: '经办人', width: 60, hidden: true },
            { field: 'TUserName', title: '经办人', width: 100 },
            { field: 'TDate', title: '经办日期', width: 150 },
            { field: 'TTime', title: '经办时间', width: 150 },
            { field: 'TExtStr01', title: '扩展01', width: 50, hidden: true },
            { field: 'TExtStr02', title: '扩展03', width: 50, hidden: true },
            { field: 'TExtStr03', title: '扩展03', width: 50, hidden: true },
            { field: 'TExtStr04', title: '扩展04', width: 50, hidden: true },
            { field: 'TExtStr05', title: '扩展05', width: 50, hidden: true },
            { field: 'THospDr', title: '院区ID', width: 50, hidden: true }
        ]],
        pageSize: 10,
        pagination: true,
        onClickRow: function (rowIndex, rowData) {
            if (tmpselRow == rowIndex) {
                clearform("")
                tmpselRow = -1
                $(this).datagrid('unselectRow', rowIndex)
            } else {
                fillform(rowIndex, rowData)
                tmpselRow = rowIndex
            }

        },
        onDblClickRow: function (rowIndex, rowData) {
            //initCPRecFrm(rowIndex, rowData);
        },
        onUnselect: function (rowIndex, rowData) {
            //alert(rowIndex+"-"+rowData.itemid)
        },
        onLoadSuccess: function (data) {
            var index = 0;
            if (data.total > 0) {
                if (CPRecRowIndex >= 0) {
                    index = CPRecRowIndex
                }
                $('#cprecdg').datagrid('selectRow', index);
            }
            CPRecRowIndex = -1;
        }
    });



}

//加载医师信息
function loadCPPanel(rowIndex, rowData) {
    $('#CPCode').val(rowData.TCPCode)
    $('#CPName').val(rowData.TCPName)
    $('#IDType').val(rowData.TIDType)
    $('#IDTypeDesc').val(rowData.TIDTypeDesc)
    $('#IDNo').val(rowData.TIDNo)
    $('#Sex').val(rowData.TSex)
    $('#Nation').val(rowData.TNation)
    $('#BOD').val(rowData.TBOD)
    $('#TelNo').val(rowData.TTelNo)
    $('#DeptDr').val(rowData.TDeptDr)
    $('#DeptCode').val(rowData.TDeptCode)
    $('#DeptDesc').val(rowData.TDeptDesc)
    $('#JobTitle').val(rowData.TJobTitle)
    $('#AdminPost').val(rowData.TAdminPost)
    $('#AcadePost').val(rowData.TAcadePost)
    $('#College').val(rowData.TCollege)
    $('#Education').val(rowData.TEducation)
    $('#Profession').val(rowData.TProfession)
    $('#PatType').val(rowData.TPatType)
    $('#AppoitNo').val(rowData.TAppoitNo)
    $('#MSQCNo').val(rowData.TMSQCNo)
    $('#MSQCMajor').val(rowData.TMSQCMajor)
    $('#MSQCType').val(rowData.TMSQCType)
    $('#MCNo').val(rowData.TMCNo)
    $('#MCType').val(rowData.TMCType)
    $('#MCMajor').val(rowData.TMCMajor)
    $('#MSQCStDate').val(rowData.TMSQCStDate)
    $('#MSQCEdDate').val(rowData.TMSQCEdDate)
    $('#MajorDiags').val(rowData.TMajorDiags)
    $('#MajorDiagType').val(rowData.TMajorDiagType)
    $('#MSQCRegDate').val(rowData.TMSQCRegDate)
    $('#MSQCMultiFlag').val(rowData.TMSQCMultiFlag)
    $('#MSQCAddr1').val(rowData.TMSQCAddr1)
    $('#MSQCAddr2').val(rowData.TMSQCAddr2)
    $('#MSQCAddr3').val(rowData.TMSQCAddr3)
    $('#MSQCAddrN').val(rowData.TMSQCAddrN)
    $('#DoctLevel').val(rowData.TDoctLevel)
    $('#NurseLevel').val(rowData.TNurseLevel)
    $('#MediPrescFlag').val(rowData.TMediPrescFlag)
    $('#OpTsPrescFlag').val(rowData.TOpTsPrescFlag)
    $('#InsuDoctFlag').val(rowData.TInsuDoctFlag)
    $('#StDate').val(rowData.TStDate)
    $('#EdDate').val(rowData.TEdDate)
    $('#ActFlag').val(rowData.TActFlag)
    $('#MediPatype').val(rowData.TMediPatype)
    $('#UserDr').val(rowData.TUserDr)
    $('#UserName').val(rowData.TUserName)
    $('#Date').val(rowData.TDate)
    $('#Time').val(rowData.TTime)
    $('#Remark').val(rowData.TRemark)
    $('#ExtStr01').val(rowData.TExtStr01)
    $('#ExtStr02').val(rowData.TExtStr02)
    $('#ExtStr03').val(rowData.TExtStr03)
    $('#ExtStr04').val(rowData.TExtStr04)
    $('#ExtStr05').val(rowData.TExtStr05)
    $('#HospDr').val(rowData.THospDr);
    $('#Rowid').val(rowData.TRowid);

}

function InCPEditClick(rowIndex) {
    CPRowIndex = rowIndex;
    var rowData = $('#cpdg').datagrid("getRows")[rowIndex]; //$('#dg').datagrid('fixColumnSize');       
    initCPFrm(rowIndex, rowData)

}

//初始化医师编辑框
function initCPFrm(rowIndex, rowData) {
    loadCPPanel(rowIndex, rowData);
    $('#CPDlEd').show();
    $HUI.dialog("#CPDlEd", {
        title: "医师信息编辑",
        height: 635,
        width: 1037,
        //collapsible:true,
        modal: true,
        iconCls: 'icon-w-edit'
        //content:initLocFrmC(),
        /*pagination:true,toolbar:[{
                iconCls: 'icon-edit',
                text:'保存',
                handler: function(){
                    $.m(
                        {
                        ClassName:"web.INSUMsgInfo",
                        MethodName:"update",
                        MsgInfoDr:dgobj.getSelected().MsgInfoDr,
                        InString:$('#ta').val()
                        },
                        function(textData){
                        //console.dir(txtData);
                        //if(textData!="") alert("修改成功,RowId:"+textData);
                        //RunQuery();
                        $('#locDlEd').window('close');  
                    })					
                }
        }] */
    })

}

//加载医师记录信息
function loadCPRecPanel(rowIndex, rowData) {
    $('#RCPDr').val(rowData.TCPDr);
    $('#RCenter').val(rowData.TCenterNo);
    $('#RStates').val(rowData.TStates);
    $('#RSeriNo').val(rowData.TSeriNo);
    $('#RBusiNo').val(rowData.TBusiNo);
    $('#RInsuType').val(rowData.TInsuType);
    $('#RInsuTypeDesc').val(rowData.TInsuTypeDesc);
    $('#RHSPUserDr').val(rowData.THSPUserDr);
    $('#RHSPUserName').val(rowData.THSPUserName)
    $('#RHSPFlag').val(rowData.THSPFlag);
    $('#RHSPDate').val(rowData.THSPDate);
    $('#RHSPTime').val(rowData.THSPTime);
    $('#RISPUserDr').val(rowData.TISPUserDr);
    $('#RISPFlag').val(rowData.TISPFlag);
    $('#RISPDate').val(rowData.TISPDate);
    $('#RISPTime').val(rowData.TISPTime);
    $('#RUserDr').val(rowData.TUserDr);
    $('#RUserName').val(rowData.TUserName);
    $('#RDate').val(rowData.TDate);
    $('#RTime').val(rowData.TTime);
    $('#RExtStr01').val(rowData.TExtStr01);
    $('#RExtStr02').val(rowData.TExtStr02);
    $('#RExtStr03').val(rowData.TExtStr03);
    $('#RExtStr04').val(rowData.TExtStr04);
    $('#RExtStr05').val(rowData.TExtStr05);
    $('#RHospDr').val(rowData.THospDr);
    $('#RRowid').val(rowData.TRowid);
}


function InCPRecEditClick(rowIndex) {
    CPRecRowIndex = rowIndex;
    var rowData = $('#cprecdg').datagrid("getRows")[rowIndex]; //$('#dg').datagrid('fixColumnSize');       
    initCPRecFrm(rowIndex, rowData)

}

//初始化医保上传记录编辑框
function initCPRecFrm(rowIndex, rowData) {
    loadCPRecPanel(rowIndex, rowData);
    $('#CPRecDlEd').show();
    $HUI.dialog("#CPRecDlEd", {
        title: "医保上传记录编辑",
        height: 465,
        width: 880,
        //collapsible:true,
        modal: true,
        iconCls: 'icon-w-edit'
        //content:initLocFrmC(),
        /*pagination:true,toolbar:[{
                iconCls: 'icon-edit',
                text:'保存',
                handler: function(){
                    $.m(
                        {
                        ClassName:"web.INSUMsgInfo",
                        MethodName:"update",
                        MsgInfoDr:dgobj.getSelected().MsgInfoDr,
                        InString:$('#ta').val()
                        },
                        function(textData){
                        //console.dir(txtData);
                        //if(textData!="") alert("修改成功,RowId:"+textData);
                        //RunQuery();
                        $('#locDlEd').window('close');  
                    })					
                }
        }] */
    })

}


//保存医师信息
function UpdateInCP() {
    var InStr = BuildInCP();
    //alert("InStr="+InStr)
    //var rtn=tkMakeServerCall("web.DHCINSULocInfoCtl","Save",InStr)
    $.m({
        ClassName: "web.DHCINSUCareProvCtl",
        MethodName: "Save",
        InString: InStr
    },
        function (rtn) {
            if (eval(rtn.split("^")[0]) > 0) {
                $.messager.alert("提示", "保存成功", 'info');
            } else {
                $.messager.alert("提示", "保存失败" + rtn, 'info');
            }
            $('#CPDlEd').window('close');
        });

}
//获取待保存医师信息串
function BuildInCP() {
    var InStr = $('#Rowid').val()
    InStr = InStr + "^" + $('#CPCode').val()
    InStr = InStr + "^" + $('#CPName').val()
    InStr = InStr + "^" + $('#IDType').val()
    InStr = InStr + "^" + $('#IDNo').val()
    InStr = InStr + "^" + $('#Sex').val()
    InStr = InStr + "^" + $('#Nation').val()
    InStr = InStr + "^" + $('#BOD').val()
    InStr = InStr + "^" + $('#TelNo').val()
    InStr = InStr + "^" + $('#DeptDr').val()

    InStr = InStr + "^" + $('#DeptCode').val()
    InStr = InStr + "^" + $('#DeptDesc').val()
    InStr = InStr + "^" + $('#JobTitle').val()
    InStr = InStr + "^" + $('#AdminPost').val()
    InStr = InStr + "^" + $('#AcadePost').val()
    InStr = InStr + "^" + $('#College').val()
    InStr = InStr + "^" + $('#Education').val()
    InStr = InStr + "^" + $('#Profession').val()
    InStr = InStr + "^" + $('#PatType').val()
    InStr = InStr + "^" + $('#AppoitNo').val()


    InStr = InStr + "^" + $('#MSQCNo').val()
    InStr = InStr + "^" + $('#MSQCMajor').val()
    InStr = InStr + "^" + $('#MSQCType').val()
    InStr = InStr + "^" + $('#MCNo').val()
    InStr = InStr + "^" + $('#MCType').val()
    InStr = InStr + "^" + $('#MCMajor').val()
    InStr = InStr + "^" + $('#MSQCStDate').val()
    InStr = InStr + "^" + $('#MSQCEdDate').val()
    InStr = InStr + "^" + $('#MajorDiags').val()
    InStr = InStr + "^" + $('#MajorDiagType').val()

    InStr = InStr + "^" + $('#MSQCRegDate').val()
    InStr = InStr + "^" + $('#MSQCMultiFlag').val()
    InStr = InStr + "^" + $('#MSQCAddr1').val()
    InStr = InStr + "^" + $('#MSQCAddr2').val()
    InStr = InStr + "^" + $('#MSQCAddr3').val()
    InStr = InStr + "^" + $('#MSQCAddrN').val()
    InStr = InStr + "^" + $('#DoctLevel').val()
    InStr = InStr + "^" + $('#NurseLevel').val()
    InStr = InStr + "^" + $('#MediPrescFlag').val()
    InStr = InStr + "^" + $('#OpTsPrescFlag').val()

    InStr = InStr + "^" + $('#InsuDoctFlag').val()
    InStr = InStr + "^" + $('#StDate').val()
    InStr = InStr + "^" + $('#EdDate').val()
    InStr = InStr + "^" + $('#ActFlag').val()
    InStr = InStr + "^" + $('#MediPatype').val()
    InStr = InStr + "^" + $('#UserDr').val()
    InStr = InStr + "^" + $('#Date').val()
    InStr = InStr + "^" + $('#Time').val()
    InStr = InStr + "^" + $('#ExtStr01').val()
    InStr = InStr + "^" + $('#ExtStr02').val()


    InStr = InStr + "^" + $('#ExtStr03').val()
    InStr = InStr + "^" + $('#ExtStr04').val()
    InStr = InStr + "^" + $('#ExtStr05').val()
    InStr = InStr + "^" + $('#ExtStr05').val()
    return InStr
}



//保存医保上传记录信息
function UpdateInCPRec() {
    var InStr = BuildInCPRec();
    $.m({
        ClassName: "web.DHCINSUCareProvRecCtl",
        MethodName: "Save",
        InString: InStr
    },
        function (rtn) {
            if (eval(rtn.split("^")[0]) > 0) {
                $.messager.alert("提示", "保存成功", 'info');
            } else {
                $.messager.alert("提示", "保存失败" + rtn, 'info');
            }
            $('#CPRecDlEd').window('close');
        });

}
//获取待保存医保上传记录串
function BuildInCPRec() {
    var InStr = $('#RRowid').val()
    InStr = InStr + "^" + $('#RCPDr').val()
    InStr = InStr + "^" + $('#RCenter').val()
    InStr = InStr + "^" + $('#RStates').val()
    InStr = InStr + "^" + $('#RSeriNo').val()
    InStr = InStr + "^" + $('#RBusiNo').val()
    InStr = InStr + "^" + $('#RInsuType').val()
    InStr = InStr + "^" + $('#RHSPUserDr').val()
    InStr = InStr + "^" + $('#RHSPFlag').val()
    InStr = InStr + "^" + $('#RHSPDate').val()
    InStr = InStr + "^" + $('#RHSPTime').val()
    InStr = InStr + "^" + $('#RISPUserDr').val()
    InStr = InStr + "^" + $('#RISPFlag').val()
    InStr = InStr + "^" + $('#RISPDate').val()
    InStr = InStr + "^" + $('#RISPTime').val()
    InStr = InStr + "^" + $('#RUserDr').val()
    InStr = InStr + "^" + $('#RDate').val()
    InStr = InStr + "^" + $('#RTime').val()
    InStr = InStr + "^" + $('#RExtStr01').val()
    InStr = InStr + "^" + $('#RExtStr02').val()
    InStr = InStr + "^" + $('#RExtStr03').val()
    InStr = InStr + "^" + $('#RExtStr04').val()
    InStr = InStr + "^" + $('#RExtStr05').val()
    InStr = InStr + "^" + $('#RHospDr').val()
    return InStr
}




//初始化医保上传记录生成框
function initCPRecRbFrm() {
    $('#RdInsuTypeDesc').val($("#InsuType").combobox('getText'));
    $('#RdInsuType').val($("#InsuType").combobox('getValue'));

    $('#CPRecDlBd').show();
    $HUI.dialog("#CPRecDlBd", {
        title: "医保上传记录生成",
        height: 260,
        width: 300,
        iconCls: 'icon-w-batch-add',
        modal: true

        //content:initLocFrmC(),
        /*pagination:true,toolbar:[{
                iconCls: 'icon-edit',
                text:'保存',
                handler: function(){
                    $.m(
                        {
                        ClassName:"web.INSUMsgInfo",
                        MethodName:"update",
                        MsgInfoDr:dgobj.getSelected().MsgInfoDr,
                        InString:$('#ta').val()
                        },
                        function(textData){
                        //console.dir(txtData);
                        //if(textData!="") alert("修改成功,RowId:"+textData);
                        //RunQuery();
                        $('#locDlEd').window('close');  
                    })					
                }
        }] */
    })

}

function FrmRbdResShw() {
    if ("" == $("#InsuType").combobox('getValue')) {
        $.messager.alert("提示", "请选择医保类型", 'info'); return;
    }
    $("#RdInsuTypeDesc").val("");
    $("#RdInsuType").val("");
    initCPRecRbFrm();

}



function ReBuildInCPRec() {

    var InsuTypeDesc = $("#RdInsuTypeDesc").val();
    var InsuType = $("#RdInsuType").val();
    var ExpStr = $("#RdCenter").val() + "^" + $("#RdStates").val() + "^^^^^"
    $.messager.confirm("生成", "确定重新生成" + InsuTypeDesc + "医师上传记录?", function (r) {
        if (r) {
            $.messager.progress({
                title: "提示",
                msg: '正在同步待上传数据',
                text: '同步中....',
                iconCls: 'icon-reset'

            });
            $.m({
                ClassName: "web.DHCINSUCareProvRecCtl",
                MethodName: "BuildINCPRecInfo",
                InRowid: "",
                InsuType: InsuType,
                UserDr: GUser,
                HospDr: PUBLIC_CONSTANT.SESSION.HOSPID,
                ExpStr: ExpStr

            },
                function (rtn) {
                    $.messager.alert("生成记录提示", rtn.split("!")[1], 'info');
                    setTimeout('$.messager.progress("close");', 2 * 1000);
                    QryInCPRec();
                });
            //setTimeout('$.messager.progress("close");', 2 * 1000);
        }

    });

}

//重新生成医师信息 
function ReBuildInCP() {

    $.messager.confirm("生成", "确定重新生成医师信息?", function (r) {


        if (r) {
            $.messager.progress({
                title: "提示",
                msg: '正在同步医师数据',
                text: '同步中....',
                iconCls: 'icon-reset'
            });
            $.m({
                ClassName: "web.DHCINSUCareProvCtl",
                MethodName: "SynBuildINCPInfo",
                InRowid: "",
                CPCode: "",
                CPDesc: "",
                UserDr: GUser,
                HospDr: PUBLIC_CONSTANT.SESSION.HOSPID,
                ExpStr: "^^^^^"

            },
                function (rtn) {

                    $.messager.alert("提示", rtn.split("!")[1], 'info');
                    setTimeout('$.messager.progress("close");', 2 * 1000);
                    QryInCP();
                });
            //setTimeout('$.messager.progress("close");', 3 * 1000);
        }




    });



}


//医师信息上传
function InCPUL() {
    var InsuType = $("#InsuType").combobox('getValue');
    if ("" == InsuType) {
        $.messager.alert("提示", "请选择医保类型", 'info'); return;
    }
    var ExpStr = InsuType + "^^" + InCPRowid

    var RtnFLag = InsuDicCTCareprovUL(0, GUser, ExpStr); //DHCINSUPort.js
}

//医师信息下载
function InCPDL() {
    var InsuType = $("#InsuType").combobox('getValue');
    if ("" == InsuType) {
        $.messager.alert("提示", "请选择医保类型", 'info'); return;
    }
    var ExpStr = InsuType + "^^" + InCPRowid
    var RtnFLag = InsuDicCTCareprovDL(0, GUser, ExpStr); //DHCINSUPort.js
}

//医师信息导入
function InCPImpt() {


    importDiag();



}


///******************************************************************
///功能说明：
///          医师数据导入
///******************************************************************
function importDiag() {
    try {
        //var fd = new ActiveXObject("MSComDlg.CommonDialog");
        ///fd.Filter = "*.xls"; //过滤文件类别
        //fd.FilterIndex = 2;
        //fd.MaxFileSize = 128;
        //fd.ShowSave();//如果是需要打开的话，就要用fd.ShowOpen();
        //fd.ShowOpen();
        //filePath=fd.filename;//fd.filename是用户的选择路径

        var filePath = "";
        filePath = FileOpenWindow();
        if (filePath == "") {
            $.messager.alert('提示', '请选择文件！', 'info')
            return;
        }
        $.messager.progress({
            title: "提示",
            msg: '正在导入科室数据',
            text: '导入中....'
        });


        var ErrMsg = "";     //错误数据
        var errRowNums = 0;  //错误行数
        var sucRowNums = 0;  //导入成功的行数

        xlApp = new ActiveXObject("Excel.Application");
        xlBook = xlApp.Workbooks.open(filePath);
        xlBook.worksheets(1).select();
        var xlsheet = xlBook.ActiveSheet;

        var rows = xlsheet.usedrange.rows.count;
        var columns = xlsheet.usedRange.columns.count;

        try {

            for (i = 2; i <= rows; i++) {
                var pym = "";
                var UpdateStr = buildImportStr(xlsheet, i);
                var savecode = tkMakeServerCall("web.DHCINSUCareProvCtl", "Save", UpdateStr)
                if (savecode == null || savecode == undefined) savecode = -1
                if (eval(savecode) >= 0) {
                    sucRowNums = sucRowNums + 1;


                } else {
                    errRowNums = errRowNums + 1;
                    if (ErrMsg == "") {
                        ErrMsg = i;
                    } else {
                        ErrMsg = ErrMsg + "\t" + i;
                    }
                }
            }

            if (ErrMsg == "") {
                setTimeout('$.messager.progress("close");', 1 * 1000);
                $.messager.alert('提示', '数据正确导入完成', 'info');
            } else {
                setTimeout('$.messager.progress("close");', 1 * 1000);
                var tmpErrMsg = "成功导入【" + sucRowNums + "/" + (rows - 1) + "】条数据";
                tmpErrMsg = tmpErrMsg + "失败数据行号如下：\n\n" + ErrMsg;
                $.messager.alert('提示', tmpErrMsg, 'info');
            }
        }
        catch (e) {
            $.messager.alert('报错提示', "导入时发生异常0：ErrInfo：" + e.message, 'error');
        }
        finally {
            xlBook.Close(savechanges = false);
            xlApp.Quit();
            xlApp = null;
            xlsheet = null;
        }

    }
    catch (e) {
        $.messager.alert('报错提示', "导入时发生异常1：" + e.message, 'error');

    }
    finally {
        setTimeout('$.messager.progress("close");', 1 * 1000);
    }


}
function buildImportStr(xlsheet, rowindex) {
    var tmpVal = "";

    //Rowid^医师编号^医师姓名^证件类型^证件号码^性别^民族^出生日期^联系电话^科室Dr^科室编号^科室名称^职称（级别）^行政职务^学术职务^毕业院校^学历^所学专业^医院人员类别^医院聘书编码^资格证书编码^资格证专业^资格证类别^执业证书编码^执业类别^执业范围（专业）^执业开始时间^执业结束时间^主治疾病内容^疾病种类^执业证书注册日期^是否多点执业^第一执业地点^第二执业地点^第三执业地点^其它执业注册地^医师级别^护师级别^医保处方权^门诊特殊病开单标志^医保医师标志^备案开始日期^备案结束日期^有效标志^卫生技术人员类别^经办人^经办日期^经办时间^扩展串01^扩展串02^扩展串03^扩展串04^扩展串05
    //1-5 Rowid^医师编号^医师姓名^证件类型^证件号码^
    var updateStr = "";
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 1).value);                     //分类
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 2).value);
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 3).value);
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 4).value);
    //6-10 性别^民族^出生日期^联系电话^科室Dr^

    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 5).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 6).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 7).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 8).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 9).value);		//

    //11-15 科室编号^科室名称^职称（级别）^行政职务^学术职务^

    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 10).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 11).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 12).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 13).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 14).value);		//

    //16-20 毕业院校^学历^所学专业^医院人员类别^医院聘书编码^

    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 15).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 16).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 17).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 18).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 19).value);		//

    //21-25 资格证书编码^资格证专业^资格证类别^执业证书编码^执业类别^

    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 20).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 21).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 22).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 23).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 24).value);		//

    //26-30 执业范围（专业）^执业开始时间^执业结束时间^主治疾病内容^疾病种类^

    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 25).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 26).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 27).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 28).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 29).value);		//

    //31-35 执业证书注册日期^是否多点执业^第一执业地点^第二执业地点^第三执业地点^
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 30).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 31).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 32).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 33).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 34).value);		//
    //36-40 其它执业注册地^医师级别^护师级别^医保处方权^门诊特殊病开单标志^
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 35).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 36).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 37).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 38).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 39).value);		//
    //41-45 医保医师标志^备案开始日期^备案结束日期^有效标志^卫生技术人员类别^
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 40).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 41).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 42).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 43).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 44).value);		//
    //46-50 经办人^经办日期^经办时间^扩展串01^扩展串02^
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 45).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 46).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 47).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 48).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 49).value);		//
    //51-53 扩展串03^扩展串04^扩展串05
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 50).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 51).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 52).value);		//

    return updateStr;
}
function SetValue(value) {
    if (value == undefined) {
        value = "";
    }

    value = value.toString().replace(/\"/g, "");
    value = value.toString().replace(/\?/g, "");
    return value;
}





//医师信息导出
function InCPEpot() {
    try {
        var rtn = $cm({
            dataType: 'text',
            ResultSetType: "Excel",
            ExcelName: "医师信息维护", //默认DHCCExcel
            ClassName: "web.DHCINSUCareProvCtl",
            QueryName: "QryInCPInfo",
            InRowid: "",
            KeyWords: $('#KeyWords').val(),
            HospDr: PUBLIC_CONSTANT.SESSION.HOSPID
        }, false);
        location.href = rtn;
        $.messager.progress({
            title: "提示",
            msg: '正在导出医师数据',
            text: '导出中....'
        });
        setTimeout('$.messager.progress("close");', 3 * 1000);

        return;
    } catch (e) {
        $.messager.alert("警告", e.message);
        $.messager.progress('close');
    };


}


function FileOpenWindow() {
    if ($('#FileWindowDiv').length == 0) {
        $('#FileWindowDiv').empty();

        $FileWindowDiv = $("<a id='FileWindowDiv' class='FileWindow' style='display:none'>&nbsp;</a>");
        $("body").append($FileWindowDiv);
        $FileWindow = $("<input id='FileWindow' type='file' name='upload'/>");
        $("#FileWindowDiv").append($FileWindow);
    }
    $('#FileWindow').val("");
    $('#FileWindow').select();
    $(".FileWindow input").click();
    var FilePath = $('#FileWindow').val();
    //alert(FilePath);
    return FilePath;
}

$(".FileWindow").on("change", "input[type='file']", function () {
    //alert(3233);
    var filePath = $(this).val();
    //alert("filePath="+filePath);
});
function selectHospCombHandle() {
    $('#InsuType').combobox('reload');
    QryInCP();
    QryInCPRec();
}
