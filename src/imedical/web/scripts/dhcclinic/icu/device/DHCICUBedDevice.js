$(document).ready(function () {


    //ά�������ʼ��
    InitForm();
    var isDemoGroup=true;
    // �жϵ�½�����Ƿ�demo��ȫ��,������Կ���ȫ��������Ϣ������ֻ���Կ�����������Ϣ
    if (session['LOGON.GROUPDESC'] != 'Demo Group'){
	     isDemoGroup=false;
         $('#Department').combogrid('disable');
         $("#Department").combogrid("setValue", session['LOGON.ICU.WARDID']);
         $("#Department").combogrid("setText", session['LOGON.ICU.WARDDesc']);
    }
    //������ݱ���һ�����ݷ��ص������
    var SelectedRowID = 0;
    var preRowID = 0;
    var departmentId = session['LOGON.ICU.WARDID'];

    function bedDeviceDatagrid_OnClickRow() {
        var selected = $('#bedDeviceDatagrid').datagrid('getSelected');
        if (selected) {
            SelectedRowID = selected.RowId;
            if (preRowID != SelectedRowID) {
                $('#RowId').val(selected.RowId);
                 if (isDemoGroup){
                   $('#Department').combogrid("setValue", selected.DepartmentId);
                   $('#Department').combogrid("setText", selected.Department);
                }
                $('#Bed').combogrid("setValue", selected.BedId);
                $('#Bed').combogrid("setText", selected.Bed);
                $('#Device').combogrid("setValue", selected.DeviceId);
                $('#Device').combogrid("setText", selected.Device);
                $('#Note').val(selected.Note);
                preRowID = SelectedRowID;
            }
            else {
                $('#RowId').val("");
                if (isDemoGroup){
                  $('#Department').combogrid("setValue", "");
                  $('#Department').combogrid("setText", "");
                }
                $('#Bed').combogrid("setValue", "");
                $('#Bed').combogrid("setText", "");
                $('#Device').combogrid("setValue", "");
                $('#Device').combogrid("setText", "");
                $('#Note').val("");
                SelectedRowID = 0;
                preRowID = 0;
                $('#bedDeviceDatagrid').datagrid("unselectAll")
            }
        }
    }

    
    var grid=$('#bedDeviceDatagrid').datagrid({
        url: 'dhcclinic.jquery.csp',
        queryParams: {
            ClassName: "web.DHCICUBedDevice",
            QueryName: "FindIcuBedDevice",
            Arg1: function () {
                return GetDepartmentId();
            },
            ArgCnt: 1
        },
        border: 'true',
        singleSelect: true,
        toolbar: [{
            iconCls: 'icon-add',
            text: '����',
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
            { field: 'DepartmentId', title: '����ID', width: 100, hidden: true },
            { field: 'Department', title: '����', width: 300 },
            { field: 'BedId', title: '��λid', width: 100, hidden: true },
            { field: 'Bed', title: '��λ', width: 100 },
            { field: 'DeviceId', title: '�豸ID', width: 100, hidden: true },
            { field: 'Device', title: '�豸', width: 200 },
            { field: 'Note', title: '��ע', width: 100 }

        ]],
        onClickRow: function (rowIndex, rowData) {
            bedDeviceDatagrid_OnClickRow();
        },
        pagination: true,
        pageSize: 15,
        pageNumber: 1,
        pageList: [15, 30, 45, 60, 75]
    });
    //���Ӻ���
    function AddgridData() {
        var Bed = $('#Bed').combogrid("getValue");
        var Device = $('#Device').combogrid("getValue");
        var Note = $('#Note').val();
        if (Bed == "") {
            $.messager.alert("����", "��λ����Ϊ�գ�", 'error')
            return false;
        }
        if (Device == "") {
            $.messager.alert("����", "�豸�Ų���Ϊ�գ�", 'error')
            return false;
        }

        $.ajax({
            url: "dhcclinic.jquery.method.csp",
            type: "POST",
            data: {
                ClassName: "web.DHCICUBedDevice",
                MethodName: "AddBedDevice",
                Arg1: Bed,
                Arg2: Device,
                Arg3: Note,
                ArgCnt: 3
            },
            beforeSend: function () {
                $.messager.progress({
                    text: '���ڱ�����...'
                });
            },
            success: function (data, response, status) {
                $.messager.progress('close');
                rowId=parseInt(data);
                if (rowId > 0) {
                    $('#bedDeviceDatagrid').datagrid('reload');
                    $.messager.show({
                        title: '��ʾ',
                        msg: '����ɹ�'
                    });
                    grid.load();
                }
                else {
                    $.messager.alert('����ʧ�ܣ�', data, 'warning');
                    return;
                }
            }

        })
    }

    //���º���
    function UpdategridData() {
        var RowId = $('#RowId').val();
        var Bed = $('#Bed').combogrid("getValue");
        var Device = $('#Device').combogrid("getValue");
        var Note = $('#Note').val();
        if (RowId == "") {
            $.messager.alert("����", "Rowid����Ϊ�գ�", 'error')
            return false;
        }
        if (Bed == "") {
            $.messager.alert("����", "BedId����Ϊ�գ�", 'error')
            return false;
        }

        if (Device == "") {
            $.messager.alert("����", "�豸����Ϊ�գ�", 'error')
            return false;
        }
        $.ajax({
            url: "dhcclinic.jquery.method.csp",
            type: "POST",
            data: {
                ClassName: "web.DHCICUBedDevice",
                MethodName: "UpdateBedDevice",
                Arg1: RowId,
                Arg2: Bed,
                Arg3: Device,
                Arg4: Note,
                ArgCnt: 4
            },
            success: function (data, response, status) {
                $.messager.progress('close');
                if (data == 0) {
                    $('#bedDeviceDatagrid').datagrid('reload');
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

        var selectRow = $('#bedDeviceDatagrid').datagrid('getSelected');
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
                        ClassName: "web.DHCICUBedDevice",
                        MethodName: "DeleteBedDevice",
                        Arg1: selectRow.RowId,
                        ArgCnt: 1
                    },
                    success: function (data, response, status) {
                        $.messager.progress('close');
                        if (data == 0) {
                            $('#bedDeviceDatagrid').datagrid('reload');
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

        $("#Department").combogrid({
            panelWidth: 150,
            loadMsg: "���ڼ�����...",
            width: 140,
            rownumbers: true,
            idField: "Id",
            textField: "Text",
            url: 'dhcclinic.jquery.csp',
            queryParams: {
                ClassName: "web.DHCICUDevice",
                QueryName: "FindWard",
                Arg1: function () {
                    return $('#Department').combogrid("getText");
                },
                ArgCnt: 1
            },
            columns: [[
                { field: "Id", title: "ID" },
                { field: "Text", title: "Desc" }
            ]],
            onChange: function () {
                if ($(this).nextAll().find("input").is(":focus"))
                    $('#Department').combogrid('grid').datagrid('reload')
            },
            onHidePanel: function () {
	      //20190110 YuanLin ������ֻ��ѡ��������д
	      var SelectRow = $(this).combogrid("grid").datagrid('getSelected');
	      var Val = $(this).combogrid('getValue');
	      if(SelectRow)
	      {
		      if (Val != SelectRow.Id)
		      {
			      $.messager.alert("��ʾ","���������ѡ��","info");
			      return;
			  }
		  }
		  else
		  {
			  $.messager.alert("��ʾ","���������ѡ��","info");
			  return;
		  }
        }
        });
        
        $("#Bed").combogrid({
            panelWidth: 150,
            loadMsg: "���ڼ�����...",
            width: 140,
            rownumbers: true,
            idField: "Id",
            textField: "Code",
            url: 'dhcclinic.jquery.csp',
            queryParams: {
                ClassName: "web.DHCICUBedDevice",
                QueryName: "FindBed",
                Arg1: function () {
                    return GetDepartmentId();
                },
                Arg2: function () {
                    return $("#Bed").combogrid("getText");
                },

                ArgCnt: 2
            },
            columns: [[
                { field: "Id", title: "ID" },
                { field: "Code", title: "Desc" }
            ]]
      , onShowPanel: function () { $(this).combogrid('grid').datagrid('reload'); }
      , onChange: function () {
          if ($(this).nextAll().find("input").is(":focus"))
              $(this).combogrid('grid').datagrid('reload');
      }
      ,onHidePanel: function () {
	      //20190110 YuanLin ������ֻ��ѡ��������д
	      var SelectRow = $(this).combogrid("grid").datagrid('getSelected');
	      var Val = $(this).combogrid('getValue');
	      if(SelectRow)
	      {
		      if (Val != SelectRow.Id)
		      {
			      $.messager.alert("��ʾ","���������ѡ��","info");
			      return;
			  }
		  }
		  else
		  {
			  $.messager.alert("��ʾ","���������ѡ��","info");
			  return;
		  }
        }
       });
        $("#Device").combogrid({
            panelWidth: 150,
            loadMsg: "���ڼ�����...",
            width: 160,
            rownumbers: true,
            idField: "RowId",
            textField: "DeviceName",
            url: 'dhcclinic.jquery.csp',
            queryParams: {
                ClassName: "web.DHCICUDevice",
                QueryName: "FindIcuDevice",
                Arg1: function () { return GetDepartmentId(); },
                Arg2: function () { return $("#Device").combogrid("getText"); },
                ArgCnt: 2
            },
            columns: [[
                { field: "RowId", title: "ID" },
                { field: "DeviceName", title: "Desc" }
            ]]
           ,onChange: function () {
                if ($(this).nextAll().find("input").is(":focus"))
                    $(this).combogrid('grid').datagrid('reload')
            }
            ,onHidePanel: function () {
	      //20190110 YuanLin ������ֻ��ѡ��������д
	      var SelectRow = $(this).combogrid("grid").datagrid('getSelected');
	      var Val = $(this).combogrid('getValue');
	      if(SelectRow)
	      {
		      if (Val != SelectRow.RowId)
		      {
			      $.messager.alert("��ʾ","���������ѡ��","info");
			      return;
			  }
		  }
		  else
		  {
			  $.messager.alert("��ʾ","���������ѡ��","info");
			  return;
		  }
        }
        });

        $("#Note").validatebox({
            width: 160
        });
    }
    function GetDepartmentId() {
        departmentId = session['LOGON.ICU.WARDID'];
        if (session['LOGON.GROUPDESC'] == 'Demo Group') {
            departmentId = $('#Department').combogrid("getValue");
        }
        return departmentId;
    }
    $('#Bed').combogrid('textbox').bind('focus',function(){
	    DepartmentId = $('#Department').combogrid("getValue");
	    if(DepartmentId==""){
		    $.messager.alert("��ʾ", "����ѡ����ң�", 'info')
		    return;
	    }
    })
});
