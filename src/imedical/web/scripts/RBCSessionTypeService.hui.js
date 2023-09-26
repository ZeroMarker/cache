var PageLogicObj = {
    m_SessionTypeListDataGrid: "",
    m_SessionServerListDataGrid: "",
    editRow2: "",
    dialog1: ""
};
$(function () {
    var hospComp = GenHospComp("DHC_RBCSessionTypeService");
    hospComp.jdata.options.onSelect = function (e, t) {
        SessionTypeListDataGridLoad();
        InitSessionServerListDataGrid();
    }
    hospComp.jdata.options.onLoadSuccess = function (data) {
        //ҳ�����ݳ�ʼ��
        Init();
        //���عҺ�ְ��
        SessionTypeListDataGridLoad();
        InitTip();
    }
});
function Init() {
    $("#tipContent").css('width', $("#tipContent").parent().width() - 32);
    PageLogicObj.m_SessionTypeListDataGrid = InitSessionTypeListDataGrid();
    PageLogicObj.m_SessionServerListDataGrid = InitSessionServerListDataGrid();
    $("#cmd_OK").click(SaveExcludeAdmReason);
}
function InitSessionTypeListDataGrid() {
    var Columns = [[
        { field: 'ID', hidden: true },
        { field: 'Desc', title: '�Һ�ְ��', width: 280, align: 'center' }
    ]];
    var SessionTypeListDataGrid = $("#SessionTypeList").datagrid({
        fit: true,
        border: false,
        striped: true,
        singleSelect: true,
        fitColumns: false,
        autoRowHeight: false,
        rownumbers: true,
        pagination: true,
        rownumbers: true,
        pageSize: 20,
        pageList: [20, 100, 200],
        idField: 'ID',
        columns: Columns,
        onClickRow: function (rowIndex, rowData) {
            PageLogicObj.m_SessionServerListDataGrid.datagrid('unselectAll');
        }
    }).datagrid({
        loadFilter: SessionServerListDataGridLoad();
        DocToolsHUI.lib.pagerFilter
    });
    return SessionTypeListDataGrid;
}
function SessionTypeListDataGridLoad() {
    $.q({
        ClassName: "web.DHCBL.BaseReg.BaseDataQuery",
        QueryName: "RBCSessionTypeQuery",
        HospID: $HUI.combogrid('#_HospList').getValue(),
        Pagerows: PageLogicObj.m_SessionTypeListDataGrid.datagrid("options").pageSize, rows: 99999
    }, function (GridData) {
        PageLogicObj.m_SessionTypeListDataGrid.datagrid("unselectAll").datagrid('loadData', GridData);
    });
}
function InitSessionServerListDataGrid() {
    var RegServiceGroup = $m({
        ClassName: "web.DHCOPRegConfig",
        MethodName: "GetSpecConfigNode",
        NodeName: "RegServiceGroup",
        HospId: $HUI.combogrid('#_HospList').getValue(),
    }, false);
    ///SERRowId:%String,ARCIMDR:%String,ARCITMDesc:%String
    var SeviceQueryData = $cm({
        ClassName: "web.DHCBL.BaseReg.BaseDataQuery",
        QueryName: "SeviceQuery",
        RegServiceGroupRowId: RegServiceGroup,
        HospID: $HUI.combogrid('#_HospList').getValue(),
        Pagerows: 99999, rows: 99999
    }, false);
    var Columns = [[
        { field: 'SERRowId', hidden: true },
        { field: 'ARCIMDR', hidden: true },
        {
            field: 'ARCITMDesc', title: 'ҽ��������', width: 300, align: 'center',
            editor: {
                type: 'combogrid',
                options: {
                    required: true,
                    panelWidth: 450,
                    panelHeight: 350,
                    idField: 'ID',
                    textField: 'Desc',
                    value: '',//ȱʡֵ 
                    mode: 'remote',
                    pagination: false,//�Ƿ��ҳ   
                    rownumbers: true,//���   
                    collapsible: false,//�Ƿ���۵���   
                    fit: true,//�Զ���С   
                    pageSize: 10,//ÿҳ��ʾ�ļ�¼������Ĭ��Ϊ10   
                    pageList: [10],//��������ÿҳ��¼�������б�  
                    data: SeviceQueryData,
                    columns: [[
                        { field: 'Desc', title: '����', width: 300, sortable: true },
                        { field: 'ID', title: 'ID', width: 120, sortable: true }
                    ]],
                    keyHandler: {
                        up: function () {
                            //ȡ��ѡ����
                            var selected = $(this).combogrid('grid').datagrid('getSelected');
                            if (selected) {
                                //ȡ��ѡ���е�rowIndex
                                var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
                                //�����ƶ�����һ��Ϊֹ
                                if (index > 0) {
                                    $(this).combogrid('grid').datagrid('selectRow', index - 1);
                                }
                            } else {
                                var rows = $(this).combogrid('grid').datagrid('getRows');
                                $(this).combogrid('grid').datagrid('selectRow', rows.length - 1);
                            }
                        },
                        down: function () {
                            //ȡ��ѡ����
                            var selected = $(this).combogrid('grid').datagrid('getSelected');
                            if (selected) {
                                //ȡ��ѡ���е�rowIndex
                                var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
                                //�����ƶ�����ҳ���һ��Ϊֹ
                                if (index < $(this).combogrid('grid').datagrid('getData').rows.length - 1) {
                                    $(this).combogrid('grid').datagrid('selectRow', index + 1);
                                }
                            } else {
                                $(this).combogrid('grid').datagrid('selectRow', 0);
                            }
                        },
                        left: function () {
                            return false;
                        },
                        right: function () {
                            return false;
                        },
                        enter: function () {
                            //ѡ�к������������ʧ
                            $(this).combogrid('hidePanel');
                            $(this).focus();
                        }
                    },
                    onSelect: function (rowIndex, rowData) {
                        var ArcimSelRow = PageLogicObj.m_SessionServerListDataGrid.datagrid("selectRow", PageLogicObj.editRow2).datagrid("getSelected");
                        var oldInstrArcimId = ArcimSelRow.ARCIMDR;
                        ArcimSelRow.ARCIMDR = rowData.ID;
                    }
                }
            }
        }
    ]];
    var ToolBar = [{
        text: '���',
        iconCls: 'icon-add',
        handler: function () { //����б�Ĳ�����ť���,�޸�,ɾ����
            var rows = PageLogicObj.m_SessionTypeListDataGrid.datagrid("getSelections");
            if (rows.length == 0) {
                $.messager.alert("��ʾ", "��ѡ��һ��Ҫά���ĹҺ�ְ��", "error");
                return false;
            }
            PageLogicObj.editRow2 = "";
            PageLogicObj.m_SessionServerListDataGrid.datagrid("rejectChanges");
            PageLogicObj.m_SessionServerListDataGrid.datagrid("unselectAll");

            if (PageLogicObj.editRow2 != "") {
                PageLogicObj.m_SessionServerListDataGrid.datagrid("endEdit", PageLogicObj.editRow2);
                return;
            } else {
                //���ʱ���û�����ڱ༭���У�����datagrid�ĵ�һ�в���һ��
                PageLogicObj.m_SessionServerListDataGrid.datagrid("insertRow", {
                    index: 0,
                    // index start with 0
                    row: {

                    }
                });
                //���²������һ�п����༭״̬
                PageLogicObj.m_SessionServerListDataGrid.datagrid("beginEdit", 0);
                //����ǰ�༭���и�ֵ
                PageLogicObj.editRow2 = 0;
            }
        }
    }, {
        text: 'ɾ��',
        iconCls: 'icon-remove',
        handler: function () {
            //ɾ��ʱ�Ȼ�ȡѡ����
            var rows = PageLogicObj.m_SessionServerListDataGrid.datagrid("getSelections");
            //ѡ��Ҫɾ������
            if (rows.length > 0) {
                $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
                    function (r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                if (!rows[i].SERRowId) {
                                    PageLogicObj.m_SessionServerListDataGrid.datagrid("rejectChanges");
                                    PageLogicObj.m_SessionServerListDataGrid.datagrid("unselectAll");
                                    PageLogicObj.editRow2 = "";
                                    return;
                                }
                                ids.push(rows[i].SERRowId);
                                var entityInfo = ["ID=" + rows[i].SERRowId,
                                "SERParRef=" + rows[i].SERRowId,
                                "SERRBCServiceDR=" + rows[i].ARCIMDR
                                ];
                                var resource = Card_GetEntityClassInfoToXML(entityInfo);
                                $cm({
                                    ClassName: "web.DHCBL.DHCRBResource.DHCRBResourceBuilder",
                                    MethodName: "RBResourceServerDelete",
                                    Infostr: resource
                                }, function (value) {
                                    if (value == "0") {
                                        //PageLogicObj.m_SessionServerListDataGrid.datagrid('load');
                                        PageLogicObj.m_SessionServerListDataGrid.datagrid('unselectAll');
                                        SessionServerListDataGridLoad();

                                        $.messager.show({ title: "��ʾ", msg: "ɾ���ɹ�" });
                                    } else {
                                        $.messager.alert('��ʾ', "ɾ��ʧ��:" + value);
                                    }
                                    PageLogicObj.editRow2 = "";
                                });
                            }
                        }
                    });
            } else {
                $.messager.alert("��ʾ", "��ѡ��Ҫɾ������", "error");
            }
        }
    }, {
        text: '����',
        iconCls: 'icon-save',
        handler: function () {
            var rows = PageLogicObj.m_SessionTypeListDataGrid.datagrid("getSelections");
            if (rows.length > 0) {
                var ids = [];
                for (var i = 0; i < rows.length; i++) {
                    ids.push(rows[i].ID);
                }
                var SessionTypeList = ids.join(',')
                if (PageLogicObj.editRow2 != undefined) {
                    if (SessionTypeList == "") return false;
                    var SaveSelRow = PageLogicObj.m_SessionServerListDataGrid.datagrid("selectRow", PageLogicObj.editRow2).datagrid("getSelected");
                    //var editors = PageLogicObj.m_SessionServerListDataGrid.datagrid('getEditors', PageLogicObj.editRow2); 
                    var ARCIMDR = SaveSelRow["ARCIMDR"];
                    var SERRowId = SaveSelRow["SERRowId"];
                    if (typeof SERRowId == "undefined") {
                        SERRowId = "";
                    }
                    if ((ARCIMDR == "") || (ARCIMDR == undefined)) {
                        $.messager.alert("��ʾ", "��ѡ��ҽ����!");
                        return false;
                    }

                    var select = PageLogicObj.m_SessionTypeListDataGrid.datagrid("getSelected");
                    var SERParRef = select.ID;
                    var entityInfo = ["ID=" + SERRowId,
                    "SERParRef=" + SERParRef,
                    "SERRBCServiceDR=" + ARCIMDR,
                    "HospID=" + $HUI.combogrid('#_HospList').getValue()
                    ];
                    var resource = Card_GetEntityClassInfoToXML(entityInfo);
                    $cm({
                        ClassName: "web.DHCBL.DHCRBResource.DHCRBResourceBuilder",
                        MethodName: "RBResourceServerSave",
                        Infostr: resource
                    }, function (value) {
                        if (value == "0") {
                            PageLogicObj.m_SessionServerListDataGrid.datagrid("endEdit", PageLogicObj.editRow2);
                            PageLogicObj.m_SessionServerListDataGrid.datagrid("rejectChanges").datagrid('unselectAll');
                            PageLogicObj.m_SessionServerListDataGrid.datagrid('unselectAll');
                            var data = PageLogicObj.m_SessionServerListDataGrid.datagrid("getData");
                            for (var i = data["rows"].length - 1; i >= 0; i--) {
                                PageLogicObj.m_SessionServerListDataGrid.datagrid('deleteRow', i);
                            }
                            SessionServerListDataGridLoad();
                            $.messager.show({ title: "��ʾ", msg: "��ӳɹ�" });
                        } else {
                            $.messager.alert('��ʾ', "���ʧ��:" + value);
                        }
                        PageLogicObj.editRow2 = "";
                    });
                }

            } else {
                $.messager.alert("��ʾ", "��ѡ��һ��Ҫά���ĹҺ�ְ��", "error");
            }
        }
    }, {
        text: 'ȡ���༭',
        iconCls: 'icon-redo',
        handler: function () {
            //ȡ����ǰ�༭�аѵ�ǰ�༭�а�undefined�ع��ı������,ȡ��ѡ�����
            PageLogicObj.m_SessionServerListDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            PageLogicObj.editRow2 = "";
            SessionServerListDataGridLoad();
        }
    }, '-', {
        text: '����ķѱ�',
        iconCls: 'icon-edit',
        handler: function () {
            var select = PageLogicObj.m_SessionServerListDataGrid.datagrid("getSelected");
            if (!select) {
                $.messager.alert("��ʾ", "��ѡ��ҽ����!");
                return false;
            }
            var SERRowId = select["SERRowId"];
            if ((SERRowId == "") || (SERRowId == undefined)) {
                $.messager.alert("��ʾ", "�뱣�����ά��!");
                return false;
            }
            ExcludeAdmReason(SERRowId);
        }
    }];

    var SessionServerListDataGrid = $("#SessionServerList").datagrid({
        fit: true,
        border: false,
        striped: true,
        singleSelect: true,
        fitColumns: false,
        autoRowHeight: false,
        rownumbers: false,
        pagination: true,
        pageSize: 20,
        pageList: [20, 100, 200],
        idField: 'SERRowId',
        columns: Columns,
        toolbar: ToolBar,
        onDblClickRow: function (rowIndex, rowData) {
            if (PageLogicObj.editRow2 !== "") {
                $.messager.alert("��ʾ", "�����ڱ༭���У����ȵ������", "error");
                return false;
            }
            PageLogicObj.m_SessionServerListDataGrid.datagrid("beginEdit", rowIndex);
            PageLogicObj.editRow2 = rowIndex;
        },
        onLoadSuccess: function (data) {
            PageLogicObj.editRow2 = "";
            $(this).datagrid("unselectAll");
        }
    }).datagrid({ loadFilter: DocToolsHUI.lib.pagerFilter });
    SessionServerListDataGrid.datagrid("unselectAll").datagrid('loadData', { total: 0, rows: [] });
    return SessionServerListDataGrid;
}
function SessionServerListDataGridLoad() {
    var select = PageLogicObj.m_SessionTypeListDataGrid.datagrid("getSelected");
    if (!select) return false;
    var ID = select.ID;
    $.q({
        ClassName: "web.DHCRBResource",
        QueryName: "QuerySessionServer",
        SerParRef: ID,
        HospID: $HUI.combogrid('#_HospList').getValue(),
        Pagerows: PageLogicObj.m_SessionServerListDataGrid.datagrid("options").pageSize, rows: 99999
    }, function (GridData) {
        PageLogicObj.m_SessionServerListDataGrid.datagrid("unselectAll").datagrid('loadData', GridData);
    });
}

function ExcludeAdmReason(SERRowId) {
    //IInstrAutoLinkOrdExcludePrior
    $("#excludeAdmReason").val(SERRowId);
    $("#dialog-AdmReasonSelect").css("display", "");
    PageLogicObj.dialog1 = $("#dialog-AdmReasonSelect").dialog({
        autoOpen: false,
        height: 400,
        width: 300,
        modal: true
    });
    PageLogicObj.dialog1.dialog("open");
    $("#List_AdmReason").html("");
    $.q({
        ClassName: "web.DHCRBResource",
        QueryName: "FindAdmReason",
        SERRowId: SERRowId,
        HospID: $HUI.combogrid('#_HospList').getValue(),
        rows: 99999
    }, function (Data) {
        var ListArr = new Array();
        jQuery.each(Data.rows, function (i, n) {
            if (n.SelFlag == 1) {
                ListArr[ListArr.length] = "<option value=" + n.AdmReason + " Selected=" + n.SelFlag + ">" + n.AdmReasonDesc + "</option>";
            } else {
                ListArr[ListArr.length] = "<option value=" + n.AdmReason + ">" + n.AdmReasonDesc + "</option>";
            }
        });
        $("#List_AdmReason").append(ListArr.join(""));
    });
}
function SaveExcludeAdmReason() {
    var SERRowId = $("#excludeAdmReason").val();
    var AdmReasonStr = "";
    var size = $("#List_AdmReason" + " option").size();
    if (size > 0) {
        $.each($("#List_AdmReason" + " option:selected"), function (i, own) {
            var svalue = $(own).val();
            if (AdmReasonStr == "") AdmReasonStr = svalue;
            else AdmReasonStr = AdmReasonStr + "^" + svalue;
        })
    }
    var ret = $cm({
        ClassName: "web.DHCRBResource",
        MethodName: "InsertSEREXCludeAdmReason",
        SERRowId: SERRowId,
        EXCludeAdmReasonStr: AdmReasonStr
    }, false);
    if (ret == 0) {
        $("#excludeAdmReason").val("");
        PageLogicObj.dialog1.dialog("close");
        $.messager.show({ title: "��ʾ", msg: "��ӳɹ�" });
    }
}
function InitTip() {
    var _content = "<ul class='tip_class'><li style='font-weight:bold'>���Ｖ��ҳ��ʹ��˵��</li>" +
        "<li>1�����Ｖ��ά����ά���Һ�ְ����Ӧ�ķ�����ã��Һ�ʱ������ѡ�Ű�ĹҺ�ְ�Ʋ�����عҺŷ��á�</li>" +
        "<li>2���Ҳ�ҽ�������Ƽ���������ҽ����ά��-������Դ������<�Һŷ�����>��ҽ�����б�</li>" +
        "<li>3��<�Һŷ�����>�����ڹҺ����ý���ά����</li>" +
        "<li>4�����Һŷ�����δ����,��ҳ��ҽ��������������Ϊ��,�ҶԼ������ʱ���������¼�ĹҺŷ��ڽɷ�ʱ�����������ɷѡ�</li>" +
        "<li>5���Һŷ��������ú�,����������,�����޸�,�����޸�����ѯ������</li>" +
        "<li>6��ҽ������ڹҺ���ط��õ�ҽ��,��������ҽ���������Ϊ�Һŷ�����,���������ʱ���������¼�ĹҺŷ��ڽɷ�ʱ�����������ɷѡ�</li>"
    $("#tip").popover({
        trigger: 'hover',
        content: _content
    });
}
