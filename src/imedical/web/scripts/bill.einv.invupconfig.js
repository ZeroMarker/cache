/// bill.einv.invupconfig.js

$(function () {   
    //���÷�Ʊ�б���Ϣ
    SetPatInfoItem();
});

function importData() {
	//����˵���������ֵ���Ϣ
    var UserDr = "1";
    var GlobalDataFlg = "0"; //�Ƿ񱣴浽��ʱglobal�ı�־ 1 ���浽��ʱglobal 0 ���浽����(�����������ͷ�����)
    var ClassName = "BILL.EINV.BL.COM.InvUpConfigCtl"; //���봦������
    var MethodName = "ImportInvUpConfigByExcel"; //���봦������
    var ExtStrPam = ""; //���ò���()
    ExcelImport(GlobalDataFlg, UserDr, ClassName, MethodName, ExtStrPam);
}

//��ȡ������datagridѡ������
function GetInvUpConfig(ID) {
    $m({
        ClassName: "BILL.EINV.BL.COM.InvUpConfigCtl",
        MethodName: "getInvUpConfigInfo",
        ID: ID
    }, function (value) {
        if (value == "") {
            return;
        }
        var rtnAry = value.split('^');
        $('#IUCServer').val(rtnAry[0]);
        $('#IUCPort').val(rtnAry[1]);
        $('#IUCTimeout').val(rtnAry[2]);
        $('#IUCSerPath').val(rtnAry[3]);
        $('#IUCVersion').val(rtnAry[4]);
        $('#IUCAPPID').val(rtnAry[5]);
        $('#IUCSecretKey').val(rtnAry[6]);
        $('#IUCInvoiceType').combobox('setValue', rtnAry[7]);
        $('#IUCActiveFlag').combobox('setValue', rtnAry[8]);
        $('#IUCUploadWay').combobox('setValue', rtnAry[9]);
        $('#IUCStyle').combobox('setValue', rtnAry[10]);
        $('#FactoryCode').combobox('setValue', rtnAry[12]);
      	$('#Hospital').combobox('setValue', rtnAry[14]);
    });
}

//��������
function loadInvConfig() {
    $('#invList').datagrid('load', {
        ClassName: "BILL.EINV.BL.COM.InvUpConfigCtl",
        QueryName: "QueryInvUpConfigInfo"
    });
}

//����
function addData() {
    $('#add').show().dialog({
        title: "�������",
        iconCls: 'icon-w-add',
        closable: false,
        onBeforeOpen: function() {
	    	initinvconfigCombo();
	    },
        buttons: [{
                text: '����',
                handler: function () {
                    //��ȡ�������ֵ�Ĵ�
                    var DataStr = $("IUCServer").val() + "^" + $("#IUCPort").val() + "^" + $("#IUCTimeout").val() + "^" +
                        $("#IUCSerPath").val() + "^" + $("#IUCVersion").val() + "^" + $("#IUCAPPID").val() + "^" + $("#IUCSecretKey").val() + "^" +
                        $('#IUCInvoiceType').combobox('getValue') + "^" + $('#IUCActiveFlag').combobox('getValue') + "^" + $('#IUCUploadWay').combobox('getValue') + "^" + $('#IUCStyle').combobox('getValue') + "^" + $('#Hospital').combobox('getValue') + "^" +
                        $('#FactoryCode').combobox('getValue') + "^" + $('#FactoryCode').combobox('getText');
                    $m({
                        ClassName: "BILL.EINV.BL.COM.InvUpConfigCtl",
                        MethodName: "SaveInvUpConfigInfo",
                        DataStr: DataStr
                    }, function (value) {
                        if (value.length != 0) {
                            $.messager.alert('��ʾ', value);
                            loadInvConfig();
                        } else {
                            $.messager.alert('��ʾ', '����������');
                        }
                    });
                    $('#add').dialog('close');
                }
            }, {
                text: '�ر�',
                handler: function () {
                    $('#add').dialog('close');
                }
            }
        ]
    });
}

//������Ϣ�е�������
function initinvconfigCombo() {
    $('#IUCInvoiceType').combobox({
        panelHeight: 'auto',
        valueField: 'value',
        textField: 'text',
        data: [{
                value: 'E',
                text: '����Ʊ��',
                selected: true
            }, {
                value: 'P',
                text: 'ֽ�ʷ�Ʊ'
            }
        ]
    }),
    $('#IUCActiveFlag').combobox({
        panelHeight: 'auto',
        valueField: 'value',
        textField: 'text',
        data: [{
                value: 'Y',
                text: '����',
                selected: true
            }, {
                value: 'N',
                text: '�ر�'
            }
        ]
    }),
    $('#IUCUploadWay').combobox({
        panelHeight: 'auto',
        valueField: 'value',
        textField: 'text',
        data: [{
                value: 'N',
                text: 'ʵʱ',
                selected: true
            }, {
                value: 'B',
                text: '����'
            }
        ]
    }),
    $('#IUCStyle').combobox({
        panelHeight: 'auto',
        valueField: 'value',
        textField: 'text',
        data: [{
                value: 'V',
                text: '��ֵ˰��Ʊ',
                selected: true
            }, {
                value: 'C',
                text: '��Ʊ'
            }
        ]
    }),
    
    $('#Hospital').combobox({
        panelHeight: 160,
        valueField: 'id',
        textField: 'text',
        url: $URL + '?ClassName=BILL.EINV.BL.COM.InvUpConfigCtl&QueryName=QryHospital&ResultSetType=array',
        blurValidValue: true,
        value: session['LOGON.HOSPID']
    });
    
    $HUI.combobox('#FactoryCode', {
	 	panelHeight: 'auto',
        valueField: 'DicCode',
        textField: 'DicDesc',
        url: $URL + '?ClassName=BILL.EINV.BL.COM.DicDataCtl&QueryName=QueryDicDataInfo&ResultSetType=array',
        editable: false,
        onBeforeLoad: function (param) {
            param.Type = "EInv_Factory_List";
        },
        onLoadSuccess: function () {
            $('#FactoryCode').combobox('setValue', 'BS');
        }
    });
}

//ɾ��
function removeData() {
    var selectedRow = $('#invList').datagrid('getSelected');
    if (!selectedRow) {
        $.messager.alert('��ʾ', '��ѡ����Ҫɾ������');
        return;
    }
    $.messager.confirm('��ʾ', '��ȷ��Ҫɾ��������¼��?', function (r) {
        if (r) {
            var ID = selectedRow.ID;
            $m({
                ClassName: "BILL.EINV.BL.COM.InvUpConfigCtl",
                MethodName: "DeleteInvUpConfigInfo",
                ID: ID
            }, function (value) {
                if (value.length != 0) {
                    $.messager.alert('��ʾ', value);
                    loadInvConfig();
                } else {
                    $.messager.alert('��ʾ', '����������')
                }
            });
        }
    });
}

//����
function updateData() {
    var selectedRow = $('#invList').datagrid('getSelected');
    if (!selectedRow || !selectedRow.ID) {
        $.messager.alert('��ʾ', '��ѡ����Ҫ�޸ĵ���');
        return;
    }
    var ID = selectedRow.ID;
    $('#add').show().dialog({
        title: "�޸�����",
        iconCls: 'icon-w-edit',
        closable: false,
        onBeforeOpen: function() {
	   		initinvconfigCombo();
	   		//��ȡ����
	     	GetInvUpConfig(ID);
	    },
        buttons: [{
                text: '����',
                handler: function () {
                    //��ȡ�������ֵ�Ĵ�
                    var DataStr = ID + "^" + $("#IUCServer").val() + "^" + $("#IUCPort").val() + "^" + $("#IUCTimeout").val() + "^" +
                        $("#IUCSerPath").val() + "^" + $("#IUCVersion").val() + "^" + $("#IUCAPPID").val() + "^" + $("#IUCSecretKey").val() + "^" +
                        $('#IUCInvoiceType').combobox('getValue') + "^" + $('#IUCActiveFlag').combobox('getValue') + "^" + $('#IUCUploadWay').combobox('getValue') + "^" + $('#IUCStyle').combobox('getValue') + "^" + $('#Hospital').combobox('getValue') + "^" +
                        $('#FactoryCode').combobox('getValue') + "^" + $('#FactoryCode').combobox('getText');
                    $m({
                        ClassName: "BILL.EINV.BL.COM.InvUpConfigCtl",
                        MethodName: "UpdateInvUpConfigInfo",
                        DataStr: DataStr
                    }, function (value) {
                        if (value.length != 0) {
                            $.messager.alert('��ʾ', value);
                            loadInvConfig();
                        } else {
                            $.messager.alert('��ʾ', '����������');
                        }
                    });
                    $('#add').dialog('close');
                }
            }, {
                text: '�ر�',
                handler: function () {
                    $('#add').dialog('close');
                    $('#invList').datagrid('clearSelections');
                    clearDialog();
                }
            }
        ]
    });
}

//�������
function clearDialog() {
    $('#IUCServer').val("");
    $('#IUCPort').val("");
    $('#IUCTimeout').val("");
    $('#IUCSerPath').val("");
    $('#IUCVersion').val("");
    $('#IUCAPPID').val("");
    $('#IUCSecretKey').val("");
    $('#IUCInvoiceType').combobox('setValue', 'E');
    $('#IUCActiveFlag').combobox('setValue', 'Y');
    $('#IUCUploadWay').combobox('setValue', 'N');
    $('#IUCStyle').combobox('setValue', 'V');
    $('#Hospital').combobox('setValue', '');
    $('#FactoryCode').combobox('setValue', 'BS');
}

//���÷�Ʊ�б���Ϣ
function SetPatInfoItem() {
    $('#invList').datagrid({
		fit: true,
		striped: true,
		singleSelect: true,
		bodyCls: 'panel-body-gray',
        pagination: true,
        pageSize: 20,
        rownumbers: true,
    	toolbar: [{
                iconCls: 'icon-add',
                text: '����',
                handler: addData
            }, {
                iconCls: 'icon-write-order',
                text: '�޸�',
                handler: updateData
            }, {
                iconCls: 'icon-remove',
                text: 'ɾ��',
                handler: removeData
            }, {
                iconCls: 'icon-import',
                text: '����',
                handler: importData
            }
        ],
     	columns: [[{
                    field: 'ID',
                    title: 'ID',
                    hidden: true
                }, {
                    field: 'FactoryCode',
                    title: '�����̱���',
                    width: 100
                }, {
                    field: 'FactoryDesc',
                    title: '����������',
                    width: 100
                }, {
                    field: 'IUCAPPID',
                    title: 'Ӧ���ʺ�',
                    width: 150
                }, {
                    field: 'IUCActiveFlag',
                    title: '�Ƿ�����',
                    width: 80,
                    formatter: function (value) {
	                    return (value == "Y") ? '<font color="#21ba45">��</font>' : '<font color="#f16e57">��</font>';
                    }
                }, {
                    field: 'IUCInvoiceType',
                    title: 'Ʊ�ݼ������',
                    width: 100,
                    formatter: function (value) {
                        if (value == "E") {
                            return "����Ʊ��";
                        } else {
                            return "ֽ�ʷ�Ʊ";
                        }
                    }
                }, {
                    field: 'IUCPort',
                    title: '�˿ں�',
                    width: 80
                }, {
                    field: 'IUCSecretKey',
                    title: '��λУ��KEY',
                    width: 180
                }, {
                    field: 'IUCSerPath',
                    title: '·��',
                    width: 180
                }, {
                    field: 'IUCServer',
                    title: 'Ʊ�ݷ�������ַ',
                    width: 130
                }, {
                    field: 'IUCStyle',
                    title: 'Ʊ������',
                    width: 120,
                    formatter: function (value) {
                        if (value == "V") {
                            return "��ֵ˰��Ʊ";
                        } else {
                            return "��Ʊ";
                        }
                    }
                }, {
                    field: 'IUCTimeout',
                    title: '������ʱ',
                    width: 100
                }, {
                    field: 'IUCUploadWay',
                    title: 'Ʊ�ݿ��߻��ϴ���ʽ',
                    width: 150,
                    formatter: function (value) {
                        if (value == "N") {
                            return "ʵʱ";
                        } else {
                            return "����";
                        }
                    }
                }, {
                    field: 'IUCVersion',
                    title: '�汾��',
                    width: 80
                }, {
                    field: 'HospDesc',
                    title: 'ҽԺ',
                    width: 100
                }
            ]],
        url: $URL,
        queryParams: {
            ClassName: "BILL.EINV.BL.COM.InvUpConfigCtl",
            QueryName: "QueryInvUpConfigInfo"
        }
    });
}