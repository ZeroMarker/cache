$(document).ready(function () {

    //ά�������ʼ��
    InitForm();
    var isDemoGroup=true;
    // �жϵ�½�����Ƿ�demo��ȫ��,������Կ���ȫ��������Ϣ������ֻ���Կ�����������Ϣ
    if (session['LOGON.GROUPDESC'] != 'Demo Group'){
	     isDemoGroup=false;
         $('#Department').combogrid('disable');
         $("#Department").combogrid("setValue", session['LOGON.CTLOCID']);
         $("#Department").combogrid("setText", session['LOGON.AN.LocDesc']);
    }
    
    //������ݱ���һ�����ݷ��ص������
    var SelectedRowID = 0;
    var preRowID = 0;
    
    var departmentId = session['LOGON.CTLOCID'];
    function deviceDatagrid_OnClickRow() {
        var selected = $('#deviceDatagrid').datagrid('getSelected');

        if (selected) {
            SelectedRowID = selected.RowId;
            if (preRowID != SelectedRowID) {
                $('#RowId').val(selected.RowId);
                $('#DeviceNumber').val(selected.DeviceNumber);
                $('#DeviceName').val(selected.DeviceName);
                if(isDemoGroup){
                   $('#Department').combogrid("setValue", selected.DepartmentId);
                   $('#Department').combogrid("setText", selected.Department);
                }

                $('#CollectInterface').combogrid("setValue", selected.CollectInterfaceId);
                $('#CollectInterface').combogrid("setText", selected.CollectInterface);

                $('#Ip').val(selected.Ip);
                $('#Port').val(selected.Port);
                $('#MacAddress').val(selected.MacAddress);
                $('#SerialNumber').val(selected.SerialNumber);
                $('#CollectSrvIP').val(selected.CollectSrvIP);
                $('#IntervalTime').val(selected.IntervalTime);
				
                preRowID = SelectedRowID;
            }
            else {
                $('#RowId').val("");
                $('#DeviceNumber').val("");
                $('#DeviceName').val("");
                if(isDemoGroup){
                    $('#Department').combogrid("setValue", "");
                    $('#Department').combogrid("setText", "");
                }
                $('#CollectInterface').combogrid("setValue", "");
                $('#CollectInterface').combogrid("setText", "");
                $('#Ip').val("");
                $('#Port').val("");
                $('#MacAddress').val("");
                $('#SerialNumber').val("");
                $('#CollectSrvIP').val("");
                $('#IntervalTime').val("");
                SelectedRowID = 0;
                preRowID = 0;
                $('#deviceDatagrid').datagrid("unselectAll")
            }
        }
    }

    //���ݱ��datagrid�Ķ��� 
   
    $('#deviceDatagrid').datagrid({
        url: 'dhcclinic.jquery.csp',
        queryParams: {
            ClassName: "web.DHCANDevice",
            QueryName: "FindANDevice",
            Arg1: GetDepartmentId(),
            ArgCnt: 1
        },

        border: 'true',
        singleSelect: true,
        toolbar: [{
            iconCls: 'icon-add',
            text: '���',
            handler: function () {
                AddgridData();
            }
        }, '----', {
            iconCls: 'icon-edit',
            text: '�޸�',
            handler: function () {
                UpdategridData();
            }
        }, '----', {
            iconCls: 'icon-cut',
            text: 'ɾ��',
            handler: function () {
                DeleteGridData();
            }
        }],

        columns: [[
            { field: 'RowId', title: 'RowId', width: 100 },
            { field: 'DeviceNumber', title: '�豸���', width: 100 },
            { field: 'DeviceName', title: '�豸����', width: 100 },
            { field: 'DepartmentId', title: '����Id', width: 100, hidden: true },
            { field: 'Department', title: '����', width: 250 },
            { field: 'CollectInterfaceId', title: '�ɼ�����Id', width: 100, hidden: true },
            { field: 'CollectInterface', title: '�ɼ�����', width: 100 },
            { field: 'Ip', title: 'ip��ַ', width: 100 },
            { field: 'Port', title: '�˿�', width: 100 },
            { field: 'IntervalTime', title: '�ɼ����', width: 100 },
            { field: 'MacAddress', title: 'MAC��ַ', width: 100 },
            { field: 'SerialNumber', title: '���к�', width: 100 },
            { field: 'CollectSrvIP', title: '�ɼ�������Ip', width: 100 }
        ]],
        onClickRow: function (rowIndex, rowData) {
            deviceDatagrid_OnClickRow();
        },
        pagination: true,
        pageSize: 15,
        pageNumber: 1,
        pageList: [15, 30, 45, 60]
    });

    //���Ӻ���
    function AddgridData() {
        var DeviceNumber = $('#DeviceNumber').val();
        var DeviceName = $('#DeviceName').val();
        var Department = GetDepartmentId();
        var CollectInterfaceId = $('#CollectInterface').combogrid("getValue");
        var Ip = $('#Ip').val();
        var Port = $('#Port').val();
        var MacAddress = $('#MacAddress').val();
        var SerialNumber = $('#SerialNumber').val();
        var CollectSrvIP = $('#CollectSrvIP').val();
        var IntervalTime = $('#IntervalTime').val();
        if (DeviceNumber == "") {
            $.messager.alert("����", "�豸��Ų���Ϊ�գ�", 'error')
            return false;
        }
        if (DeviceName == "") {
            $.messager.alert("����", "�豸���Ʋ���Ϊ�գ�", 'error')
            return false;
        }
        if (Department == "") {
            $.messager.alert("����", "���Ҳ���Ϊ�գ�", 'error')
            return false;
        }
        if (CollectInterfaceId == "") {
            $.messager.alert("����", "�ɼ����벻��Ϊ�գ�", 'error')
            return false;
        }
        if (Ip == "") {
            $.messager.alert("����", "ip��ַ����Ϊ�գ�", 'error')
            return false;
        }
        if (Port == "") {
            $.messager.alert("����", "�˿ڲ���Ϊ�գ�", 'error')
            return false;
        }
        if (MacAddress == "") {
            $.messager.alert("����", "MAC��ַ����Ϊ�գ�", 'error')
            return false;
        }
        if (SerialNumber == "") {
            $.messager.alert("����", "���кŲ���Ϊ�գ�", 'error')
            return false;
        }
        if (IntervalTime == "") {
            IntervalTime = 60;
        }

        $.ajax({
            url: "dhcclinic.jquery.method.csp",
            type: "POST",
            data: {
                ClassName: "web.DHCANDevice",
                MethodName: "AddANDevice",
                Arg1: DeviceNumber,
                Arg2: DeviceName,
                Arg3: Department,
                Arg4: CollectInterfaceId,
                Arg5: Ip,
                Arg6: Port,
                Arg7: MacAddress,
                Arg8: SerialNumber,
                Arg9: CollectSrvIP,
                Arg10: IntervalTime,
                ArgCnt: 10
            },
            beforeSend: function () {
                $.messager.progress({
                    text: '���ڱ�����...'
                });
            },
            success: function (data, response, status) {
                $.messager.progress('close');
                if (data > 0) {
                    $('#deviceDatagrid').datagrid('reload');
                    $.messager.show({
                        title: '��ʾ',
                        msg: '����ɹ�'
                    });
                }
                else {
                    $.messager.alert('����ʧ�ܣ�', data, 'warning')
                    return;
                }
            }

        })
    }

    //���º���
    function UpdategridData() {
        var RowId = $('#RowId').val();
		if (RowId=="" || RowId==undefined){
			 $.messager.alert("����", "��������һ��", 'error')
		}
        var DeviceNumber = $('#DeviceNumber').val();
        var DeviceName = $('#DeviceName').val();
        var Department = GetDepartmentId();
        var CollectInterfaceId = $('#CollectInterface').combogrid("getValue");
        var Ip = $('#Ip').val();
        var Port = $('#Port').val();
        var MacAddress = $('#MacAddress').val();
        var SerialNumber = $('#SerialNumber').val();
        var CollectSrvIP = $('#CollectSrvIP').val();
        var IntervalTime = $('#IntervalTime').val();
        if (DeviceNumber == "") {
            $.messager.alert("����", "�豸��Ų���Ϊ�գ�", 'error')
            return false;
        }
        if (DeviceName == "") {
            $.messager.alert("����", "�豸���Ʋ���Ϊ�գ�", 'error')
            return false;
        }
        if (Department == "") {
            $.messager.alert("����", "���Ҳ���Ϊ�գ�", 'error')
            return false;
        }
        if (CollectInterfaceId == "") {
            $.messager.alert("����", "�ɼ����벻��Ϊ�գ�", 'error')
            return false;
        }
        if (Ip == "") {
            $.messager.alert("����", "ip��ַ����Ϊ�գ�", 'error')
            return false;
        }
        if (Port == "") {
            $.messager.alert("����", "�˿ڲ���Ϊ�գ�", 'error')
            return false;
        }
        if (MacAddress == "") {
            $.messager.alert("����", "MAC��ַ����Ϊ�գ�", 'error')
            return false;
        }
        if (SerialNumber == "") {
            $.messager.alert("����", "���кŲ���Ϊ�գ�", 'error')
            return false;
        }
        if (IntervalTime == "") {
            IntervalTime = 60;
        }
        $.ajax({
            url: "dhcclinic.jquery.method.csp",
            type: "POST",
            data: {
                ClassName: "web.DHCANDevice",
                MethodName: "UpdateANDevice",
                Arg1: RowId,
                Arg2: DeviceNumber,
                Arg3: DeviceName,
                Arg4: Department,
                Arg5: CollectInterfaceId,
                Arg6: Ip,
                Arg7: Port,
                Arg8: MacAddress,
                Arg9: SerialNumber,
                Arg10: CollectSrvIP,
                Arg11: IntervalTime,
                ArgCnt: 11
            },
            success: function (data, response, status) {
                $.messager.progress('close');
                if (data == 0) {
                    $('#deviceDatagrid').datagrid('reload');
                    $.messager.show({
                        title: '��ʾ',
                        msg: '���³ɹ�'
                    });
                }
                else {
                    $.messager.alert('����ʧ�ܣ�', data, 'warning')
                    return;
                }
            }

        })
    }

    //ɾ������
    function DeleteGridData() {
        var selectRow = $('#deviceDatagrid').datagrid('getSelected');
        if (!selectRow) {
            $.messager.alert("����", "RowId����Ϊ�գ�", 'error')
            return false;
        }
        $.messager.confirm('��ȷ��', '��ȷ��Ҫɾ����ѡ���У�', function (b) {
            if (b == false) {
                return;
            }
            else {
                $.ajax({
                    url: "dhcclinic.jquery.method.csp",
                    type: "POST",
                    data: {
                        ClassName: "web.DHCANDevice",
                        MethodName: "DeleteANDevice",
                        Arg1: selectRow.RowId,
                        ArgCnt: 1
                    },
                    success: function (data, response, status) {
                        $.messager.progress('close');
                        if (data == 0) {
                            $('#deviceDatagrid').datagrid('reload');
                            $.messager.show({
                                title: '��ʾ',
                                msg: 'ɾ���ɹ�'
                            });
                        }
                        else {
                            $.messager.alert('ɾ��ʧ�ܣ�', data, 'warning')
                            return;
                        }
                    }

                })
            }
        })


    }

    //�����ʼ������
    function InitForm() {
        $("#DeviceNumber").validatebox({
            width: 140
        });
        $("#DeviceName").validatebox({
            width: 140
        });

        $("#Department").combogrid({
            panelWidth: 150,
            loadMsg: "���ڼ�����...",
            width: 140,
            rownumbers: true,
            idField: "Id",
            textField: "Text",
            url: 'dhcclinic.jquery.csp',
            queryParams: {
                ClassName: "web.DHCANDevice",
                QueryName: "FindLoc",
                Arg1: function () {
                    return $("#Department").combogrid("getText");
                },
                ArgCnt: 1
            },
            columns: [[
                { field: "Id", title: "ID" },
                { field: "Text", title: "Desc" }
            ]]
       , onChange: function () {
           if ($(this).nextAll().find("input").is(":focus"))
               $(this).combogrid('grid').datagrid('reload');
       },
       onHidePanel: function () {
               OnHidePanel("#Department");
            }
        });
        
        $("#CollectInterface").combogrid({
            panelWidth: 150,
            loadMsg: "���ڼ�����...",
            width: 140,
            rownumbers: true,
            idField: "trowid",
            textField: "tDesc",
            url: 'dhcclinic.jquery.csp',
            queryParams: {
                ClassName: "web.DHCANCCollectType",
                QueryName: "FindDHCANCCollectType",
                Arg1: function () {
                    return $("#CollectInterface").combogrid("getText");
                },
                Arg2: "",
                Arg3: "I",
                ArgCnt: 3
            },
            columns: [[
                { field: "trowid", title: "ID" },
                { field: "tDesc", title: "Desc" }
            ]]
            , onChange: function () {
                if ($(this).nextAll().find("input").is(":focus"))
                    $(this).combogrid('grid').datagrid('reload');
            },
            onHidePanel: function () {
               OnHidePanel("#CollectInterface");
            }
        });
        $("#Ip").validatebox({
            width: 140
        });
        $("#Port").validatebox({
            width: 140
        });
        $("#MacAddress").validatebox({
            width: 140
        });
        $("#SerialNumber").validatebox({
            width: 140
        });
        $("#CollectSrvIP").validatebox({
            width: 140
        });

    }
        function OnHidePanel(item)
	{
		var valueField = $(item).combogrid("getText");
	    var val = $(item).combogrid("getValue");  //��ǰcombobox��ֵ
	    if(valueField==val)
	    {
		    alert("���������ѡ��")	    
		    $(item).combogrid("setValue","");

		    return;
	    } 	
	}

    function GetDepartmentId() {
        departmentId = session['LOGON.CTLOCID'];
        if (session['LOGON.GROUPDESC'] == 'Demo Group') {
            departmentId = $('#Department').combogrid("getValue");
        }
        return departmentId;
    }
});