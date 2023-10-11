/**
 * ҽ��ҽʦ��ϢJS
 * FileName:insucareprovrecinfo.js
 * DingSH 2018-10-18
 * �汾��V1.0
 * hisui�汾:0.1.0
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

    //#1��ʼ��ҽ������	
    InitInsuTypeCmb()
    //#2��ʼ��ҽ������gd
    InitInCPDg()

    //#3��ʼ��ҽ�����Ҽ�¼gd
    InitInCPRecDg()

    //#4��ʼ��Btn�¼�
    InitBtnClick();

    //#5����Ԫ��
    $('#CPDlEd').hide();
    $('#CPRecDlEd').hide();
    $('#CPRecDlBd').hide();

});

//��ʼ��Btn�¼�
function InitBtnClick() {


    //�ؼ��ֻس��¼�
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


//�ؼ��ֻس��¼�
function KeyWords_onkeydown(e) {
    if (e.keyCode == 13) {
        QryInCP();

    }
}


//��ѯҽʦ��Ϣ�¼�
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



//��ѯҽ�������ϴ���¼�¼�
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

//��ʼ��ҽ������gd
function InitInsuTypeCmb() {
    //��ʼ��combobox
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

//��ʼ��ҽ��ҽʦgd
function InitInCPDg() {


    //��ʼ��datagrid
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
                title: '����',
                formatter: function (value, row, index) {

                    return "<img class='myTooltip' style='width:60' title='ҽʦ��Ϣ�޸�' onclick=\"InCPEditClick('" + index + "')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_pen.png' style='border:0px;cursor:pointer'>";

                }
            }

        ]],

        columns: [[
            { field: 'TInd', title: 'TInd', width: 10, hidden: true },
            { field: 'TRowid', title: 'TRowid', width: 10, hidden: true },
            { field: 'TCPCode', title: 'ҽʦ����', width: 140 },
            { field: 'TCPName', title: 'ҽʦ����', width: 180 },
            { field: 'TIDType', title: '֤������', width: 150, hidden: true },
            { field: 'TIDTypeDesc', title: '֤������', width: 100 },
            { field: 'TIDNo', title: '֤������', width: 140 },
            { field: 'TSex', title: '�Ա� ', width: 60 },
            { field: 'TNation', title: '����', width: 60, align: 'center' },
            { field: 'TBOD', title: '��������', width: 120 },
            { field: 'TTelNo', title: '��ϵ�绰', width: 120 },
            { field: 'TDeptDr', title: '����Dr', width: 50, hidden: true },
            { field: 'TDeptCode', title: '���ұ��', width: 100 },
            { field: 'TDeptDesc', title: '��������', width: 110 },
            { field: 'TJobTitle', title: 'ְ�ƣ�����', width: 50, hidden: true },
            { field: 'TAdminPost', title: '����ְ��', width: 50, hidden: true },
            { field: 'TAcadePostd', title: 'ѧ��ְ��', width: 120, hidden: true },
            { field: 'TCollege', title: '��ҵԺУ', width: 120, hidden: true },
            { field: 'TEducation', title: 'ѧ��', width: 100, hidden: true },
            { field: 'TProfession', title: '��ѧרҵ', width: 120, hidden: true },
            { field: 'TPatType', title: 'ҽԺ��Ա���', width: 140, hidden: true },
            { field: 'TAppoitNo', title: 'ҽԺƸ�����', width: 150, hidden: true },
            { field: 'TMSQCNo', title: '�ʸ�֤�����', width: 150, hidden: true },
            { field: 'TMSQCMajor', title: '�ʸ�֤רҵ', width: 50, hidden: true },
            { field: 'TMSQCType', title: '�ʸ�֤���', width: 50, hidden: true },
            { field: 'TMCNo', title: 'ִҵ֤�����', width: 140 },
            { field: 'TMCType', title: 'ִҵ���', width: 50, hidden: true },
            { field: 'TMCMajor', title: 'ִҵ��Χ��רҵ��', width: 10, hidden: true },
            { field: 'TMSQCStDate', title: 'ִҵ��ʼʱ��', width: 140 },
            { field: 'TMSQCEdDate', title: 'ִҵ����ʱ��', width: 140 },
            { field: 'TMajorDiags', title: '���μ�������', width: 140, hidden: true },
            { field: 'MajorDiagType', title: '��������', width: 140, hidden: true },
            { field: 'TMSQCRegDate', title: 'ִҵ֤��ע������', width: 160 },
            { field: 'TMSQCMultiFlagr', title: '�Ƿ���ִҵ', width: 50, hidden: true },
            { field: 'TMSQCAddr1', title: '��һִҵ�ص�', width: 50, hidden: true },
            { field: 'TMSQCAddr2', title: '�ڶ�ִҵ�ص�', width: 50, hidden: true },
            { field: 'TMSQCAddr3', title: '����ִҵ�ص�', width: 50, hidden: true },
            { field: 'TMSQCAddrN', title: '����ִҵע���', width: 50, hidden: true },
            { field: 'TDoctLevel', title: 'ҽʦ����', width: 50, hidden: true },
            { field: 'TNurseLevel', title: '��ʦ����', width: 50, hidden: true },
            { field: 'TMediPrescFlag', title: 'ҽ������Ȩ', width: 50, hidden: true },
            { field: 'TOpTsPrescFlag', title: '�������ⲡ������־', width: 180 },
            { field: 'TInsuDoctFlag', title: 'ҽ��ҽʦ��ʶ', width: 120 },
            { field: 'TStDate', title: '������ʼ����', width: 50, hidden: true },
            { field: 'TEdDate', title: '������������', width: 50, hidden: true },
            { field: 'TActFlag', title: '��Ч��ʶ', width: 50, hidden: true },
            { field: 'TMediPatype', title: '����������Ա���', width: 50, hidden: true },
            { field: 'TUserDr', title: '������', width: 100, hidden: true },
            { field: 'TUserName', title: '������', width: 100 },
            { field: 'TDate', title: '��������', width: 50, hidden: true },
            { field: 'TTime', title: '����ʱ��', width: 50, hidden: true },
            { field: 'TExtStr01', title: '��չ01', width: 50, hidden: true },
            { field: 'TExtStr02', title: '��չ03', width: 50, hidden: true },
            { field: 'TExtStr03', title: '��չ03', width: 50, hidden: true },
            { field: 'TExtStr04', title: '��չ04', width: 50, hidden: true },
            { field: 'TExtStr05', title: '��չ05', width: 50, hidden: true },
            { field: 'THospDr', title: 'Ժ��ID', width: 50, hidden: true }
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

//��ʼ��ҽ�����Ҽ�¼gd
function InitInCPRecDg() {
    //��ʼ��datagrid
    $HUI.datagrid("#cprecdg", {
		fit:true,        
        singleSelect: true,
        border: false,
        data: [],
        frozenColumns: [[
            {
                field: 'TOpt1',
                width: 40,
                title: '����',
                formatter: function (value, row, index) {

                    return "<img class='myTooltip' style='width:60' title='�ϴ���¼�޸�' onclick=\"InCPRecEditClick('" + index + "')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/write_order.png' style='border:0px;cursor:pointer'>";

                }
            }

        ]],
        columns: [[
            { field: 'TInd', title: 'TInd', width: 10, hidden: true },
            { field: 'TRowid', title: 'TRowid', width: 10, hidden: true },
            { field: 'TCPDr', title: 'ҽ��ҽʦ��Ϣָ��', width: 60, hidden: true },
            { field: 'TCenterNo', title: 'ͳ��������', width: 100 },
            { field: 'TStates', title: '����������', width: 100 },
            { field: 'TSeriNo', title: '������ˮ��', width: 100 },
            { field: 'TBusiNo', title: '���ͷ�������ˮ��', width: 150, hidden: true },
            { field: 'TInsuType', title: 'ҽ������', width: 80, align: 'center', hidden: true },
            { field: 'TInsuTypeDesc', title: 'ҽ������', width: 80, align: 'left' },
            { field: 'THSPUserDr', title: 'ҽԺ������', width: 60, hidden: true },
            { field: 'THSPUserCode', title: 'ҽԺ������', width: 60, hidden: true },
            { field: 'THSPUserName', title: 'ҽԺ������', width: 120 },
            { field: 'THSPFlag', title: 'ҽԺ����״̬', width: 140 },
            { field: 'THSPDate', title: 'ҽԺ��������', width: 140 },
            { field: 'THSPTime', title: 'ҽԺ����ʱ��', width: 140 },
            { field: 'TISPUserDr', title: 'ҽ��������', width: 140, hidden: true },
            { field: 'TISPFlag', title: 'ҽ������״̬', width: 140 },
            { field: 'TISPDate', title: 'ҽ����������', width: 140 },
            { field: 'TISPTime', title: 'ҽ������ʱ��', width: 140 },
            { field: 'TUserDr', title: '������', width: 60, hidden: true },
            { field: 'TUserCode', title: '������', width: 60, hidden: true },
            { field: 'TUserName', title: '������', width: 100 },
            { field: 'TDate', title: '��������', width: 150 },
            { field: 'TTime', title: '����ʱ��', width: 150 },
            { field: 'TExtStr01', title: '��չ01', width: 50, hidden: true },
            { field: 'TExtStr02', title: '��չ03', width: 50, hidden: true },
            { field: 'TExtStr03', title: '��չ03', width: 50, hidden: true },
            { field: 'TExtStr04', title: '��չ04', width: 50, hidden: true },
            { field: 'TExtStr05', title: '��չ05', width: 50, hidden: true },
            { field: 'THospDr', title: 'Ժ��ID', width: 50, hidden: true }
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

//����ҽʦ��Ϣ
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

//��ʼ��ҽʦ�༭��
function initCPFrm(rowIndex, rowData) {
    loadCPPanel(rowIndex, rowData);
    $('#CPDlEd').show();
    $HUI.dialog("#CPDlEd", {
        title: "ҽʦ��Ϣ�༭",
        height: 635,
        width: 1037,
        //collapsible:true,
        modal: true,
        iconCls: 'icon-w-edit'
        //content:initLocFrmC(),
        /*pagination:true,toolbar:[{
                iconCls: 'icon-edit',
                text:'����',
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
                        //if(textData!="") alert("�޸ĳɹ�,RowId:"+textData);
                        //RunQuery();
                        $('#locDlEd').window('close');  
                    })					
                }
        }] */
    })

}

//����ҽʦ��¼��Ϣ
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

//��ʼ��ҽ���ϴ���¼�༭��
function initCPRecFrm(rowIndex, rowData) {
    loadCPRecPanel(rowIndex, rowData);
    $('#CPRecDlEd').show();
    $HUI.dialog("#CPRecDlEd", {
        title: "ҽ���ϴ���¼�༭",
        height: 465,
        width: 880,
        //collapsible:true,
        modal: true,
        iconCls: 'icon-w-edit'
        //content:initLocFrmC(),
        /*pagination:true,toolbar:[{
                iconCls: 'icon-edit',
                text:'����',
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
                        //if(textData!="") alert("�޸ĳɹ�,RowId:"+textData);
                        //RunQuery();
                        $('#locDlEd').window('close');  
                    })					
                }
        }] */
    })

}


//����ҽʦ��Ϣ
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
                $.messager.alert("��ʾ", "����ɹ�", 'info');
            } else {
                $.messager.alert("��ʾ", "����ʧ��" + rtn, 'info');
            }
            $('#CPDlEd').window('close');
        });

}
//��ȡ������ҽʦ��Ϣ��
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



//����ҽ���ϴ���¼��Ϣ
function UpdateInCPRec() {
    var InStr = BuildInCPRec();
    $.m({
        ClassName: "web.DHCINSUCareProvRecCtl",
        MethodName: "Save",
        InString: InStr
    },
        function (rtn) {
            if (eval(rtn.split("^")[0]) > 0) {
                $.messager.alert("��ʾ", "����ɹ�", 'info');
            } else {
                $.messager.alert("��ʾ", "����ʧ��" + rtn, 'info');
            }
            $('#CPRecDlEd').window('close');
        });

}
//��ȡ������ҽ���ϴ���¼��
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




//��ʼ��ҽ���ϴ���¼���ɿ�
function initCPRecRbFrm() {
    $('#RdInsuTypeDesc').val($("#InsuType").combobox('getText'));
    $('#RdInsuType').val($("#InsuType").combobox('getValue'));

    $('#CPRecDlBd').show();
    $HUI.dialog("#CPRecDlBd", {
        title: "ҽ���ϴ���¼����",
        height: 260,
        width: 300,
        iconCls: 'icon-w-batch-add',
        modal: true

        //content:initLocFrmC(),
        /*pagination:true,toolbar:[{
                iconCls: 'icon-edit',
                text:'����',
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
                        //if(textData!="") alert("�޸ĳɹ�,RowId:"+textData);
                        //RunQuery();
                        $('#locDlEd').window('close');  
                    })					
                }
        }] */
    })

}

function FrmRbdResShw() {
    if ("" == $("#InsuType").combobox('getValue')) {
        $.messager.alert("��ʾ", "��ѡ��ҽ������", 'info'); return;
    }
    $("#RdInsuTypeDesc").val("");
    $("#RdInsuType").val("");
    initCPRecRbFrm();

}



function ReBuildInCPRec() {

    var InsuTypeDesc = $("#RdInsuTypeDesc").val();
    var InsuType = $("#RdInsuType").val();
    var ExpStr = $("#RdCenter").val() + "^" + $("#RdStates").val() + "^^^^^"
    $.messager.confirm("����", "ȷ����������" + InsuTypeDesc + "ҽʦ�ϴ���¼?", function (r) {
        if (r) {
            $.messager.progress({
                title: "��ʾ",
                msg: '����ͬ�����ϴ�����',
                text: 'ͬ����....',
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
                    $.messager.alert("���ɼ�¼��ʾ", rtn.split("!")[1], 'info');
                    setTimeout('$.messager.progress("close");', 2 * 1000);
                    QryInCPRec();
                });
            //setTimeout('$.messager.progress("close");', 2 * 1000);
        }

    });

}

//��������ҽʦ��Ϣ 
function ReBuildInCP() {

    $.messager.confirm("����", "ȷ����������ҽʦ��Ϣ?", function (r) {


        if (r) {
            $.messager.progress({
                title: "��ʾ",
                msg: '����ͬ��ҽʦ����',
                text: 'ͬ����....',
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

                    $.messager.alert("��ʾ", rtn.split("!")[1], 'info');
                    setTimeout('$.messager.progress("close");', 2 * 1000);
                    QryInCP();
                });
            //setTimeout('$.messager.progress("close");', 3 * 1000);
        }




    });



}


//ҽʦ��Ϣ�ϴ�
function InCPUL() {
    var InsuType = $("#InsuType").combobox('getValue');
    if ("" == InsuType) {
        $.messager.alert("��ʾ", "��ѡ��ҽ������", 'info'); return;
    }
    var ExpStr = InsuType + "^^" + InCPRowid

    var RtnFLag = InsuDicCTCareprovUL(0, GUser, ExpStr); //DHCINSUPort.js
}

//ҽʦ��Ϣ����
function InCPDL() {
    var InsuType = $("#InsuType").combobox('getValue');
    if ("" == InsuType) {
        $.messager.alert("��ʾ", "��ѡ��ҽ������", 'info'); return;
    }
    var ExpStr = InsuType + "^^" + InCPRowid
    var RtnFLag = InsuDicCTCareprovDL(0, GUser, ExpStr); //DHCINSUPort.js
}

//ҽʦ��Ϣ����
function InCPImpt() {


    importDiag();



}


///******************************************************************
///����˵����
///          ҽʦ���ݵ���
///******************************************************************
function importDiag() {
    try {
        //var fd = new ActiveXObject("MSComDlg.CommonDialog");
        ///fd.Filter = "*.xls"; //�����ļ����
        //fd.FilterIndex = 2;
        //fd.MaxFileSize = 128;
        //fd.ShowSave();//�������Ҫ�򿪵Ļ�����Ҫ��fd.ShowOpen();
        //fd.ShowOpen();
        //filePath=fd.filename;//fd.filename���û���ѡ��·��

        var filePath = "";
        filePath = FileOpenWindow();
        if (filePath == "") {
            $.messager.alert('��ʾ', '��ѡ���ļ���', 'info')
            return;
        }
        $.messager.progress({
            title: "��ʾ",
            msg: '���ڵ����������',
            text: '������....'
        });


        var ErrMsg = "";     //��������
        var errRowNums = 0;  //��������
        var sucRowNums = 0;  //����ɹ�������

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
                $.messager.alert('��ʾ', '������ȷ�������', 'info');
            } else {
                setTimeout('$.messager.progress("close");', 1 * 1000);
                var tmpErrMsg = "�ɹ����롾" + sucRowNums + "/" + (rows - 1) + "��������";
                tmpErrMsg = tmpErrMsg + "ʧ�������к����£�\n\n" + ErrMsg;
                $.messager.alert('��ʾ', tmpErrMsg, 'info');
            }
        }
        catch (e) {
            $.messager.alert('������ʾ', "����ʱ�����쳣0��ErrInfo��" + e.message, 'error');
        }
        finally {
            xlBook.Close(savechanges = false);
            xlApp.Quit();
            xlApp = null;
            xlsheet = null;
        }

    }
    catch (e) {
        $.messager.alert('������ʾ', "����ʱ�����쳣1��" + e.message, 'error');

    }
    finally {
        setTimeout('$.messager.progress("close");', 1 * 1000);
    }


}
function buildImportStr(xlsheet, rowindex) {
    var tmpVal = "";

    //Rowid^ҽʦ���^ҽʦ����^֤������^֤������^�Ա�^����^��������^��ϵ�绰^����Dr^���ұ��^��������^ְ�ƣ�����^����ְ��^ѧ��ְ��^��ҵԺУ^ѧ��^��ѧרҵ^ҽԺ��Ա���^ҽԺƸ�����^�ʸ�֤�����^�ʸ�֤רҵ^�ʸ�֤���^ִҵ֤�����^ִҵ���^ִҵ��Χ��רҵ��^ִҵ��ʼʱ��^ִҵ����ʱ��^���μ�������^��������^ִҵ֤��ע������^�Ƿ���ִҵ^��һִҵ�ص�^�ڶ�ִҵ�ص�^����ִҵ�ص�^����ִҵע���^ҽʦ����^��ʦ����^ҽ������Ȩ^�������ⲡ������־^ҽ��ҽʦ��־^������ʼ����^������������^��Ч��־^����������Ա���^������^��������^����ʱ��^��չ��01^��չ��02^��չ��03^��չ��04^��չ��05
    //1-5 Rowid^ҽʦ���^ҽʦ����^֤������^֤������^
    var updateStr = "";
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 1).value);                     //����
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 2).value);
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 3).value);
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 4).value);
    //6-10 �Ա�^����^��������^��ϵ�绰^����Dr^

    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 5).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 6).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 7).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 8).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 9).value);		//

    //11-15 ���ұ��^��������^ְ�ƣ�����^����ְ��^ѧ��ְ��^

    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 10).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 11).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 12).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 13).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 14).value);		//

    //16-20 ��ҵԺУ^ѧ��^��ѧרҵ^ҽԺ��Ա���^ҽԺƸ�����^

    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 15).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 16).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 17).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 18).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 19).value);		//

    //21-25 �ʸ�֤�����^�ʸ�֤רҵ^�ʸ�֤���^ִҵ֤�����^ִҵ���^

    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 20).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 21).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 22).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 23).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 24).value);		//

    //26-30 ִҵ��Χ��רҵ��^ִҵ��ʼʱ��^ִҵ����ʱ��^���μ�������^��������^

    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 25).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 26).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 27).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 28).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 29).value);		//

    //31-35 ִҵ֤��ע������^�Ƿ���ִҵ^��һִҵ�ص�^�ڶ�ִҵ�ص�^����ִҵ�ص�^
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 30).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 31).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 32).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 33).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 34).value);		//
    //36-40 ����ִҵע���^ҽʦ����^��ʦ����^ҽ������Ȩ^�������ⲡ������־^
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 35).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 36).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 37).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 38).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 39).value);		//
    //41-45 ҽ��ҽʦ��־^������ʼ����^������������^��Ч��־^����������Ա���^
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 40).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 41).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 42).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 43).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 44).value);		//
    //46-50 ������^��������^����ʱ��^��չ��01^��չ��02^
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 45).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 46).value);       //
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 47).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 48).value);		//
    updateStr = updateStr + "^" + SetValue(xlsheet.Cells(rowindex, 49).value);		//
    //51-53 ��չ��03^��չ��04^��չ��05
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





//ҽʦ��Ϣ����
function InCPEpot() {
    try {
        var rtn = $cm({
            dataType: 'text',
            ResultSetType: "Excel",
            ExcelName: "ҽʦ��Ϣά��", //Ĭ��DHCCExcel
            ClassName: "web.DHCINSUCareProvCtl",
            QueryName: "QryInCPInfo",
            InRowid: "",
            KeyWords: $('#KeyWords').val(),
            HospDr: PUBLIC_CONSTANT.SESSION.HOSPID
        }, false);
        location.href = rtn;
        $.messager.progress({
            title: "��ʾ",
            msg: '���ڵ���ҽʦ����',
            text: '������....'
        });
        setTimeout('$.messager.progress("close");', 3 * 1000);

        return;
    } catch (e) {
        $.messager.alert("����", e.message);
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
