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
                $('#Bed').combogrid("setValue", selected.RoomId);
                $('#Bed').combogrid("setText", selected.Room);
                $('#Device').combogrid("setValue", selected.DeviceId);
                $('#Device').combogrid("setText", selected.DeviceName);
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
    var opaId=getParam("opaId");
    var queryFunName="FindANRoomDevice";
    var buttons = [{
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
        }];
    var getQueryParam=GetDepartmentId;
    if (opaId){
	    queryFunName="FindANRoomDeviceByOpaId";
	    getQueryParam=function(){
		    return opaId;
		};
	    buttons=[{
            iconCls: 'icon-edit',
            text: '�޸�',
            handler: function () {
                UpdategridData();
            }
	    }];
    }
    
    
    $('#bedDeviceDatagrid').datagrid({
        url: 'dhcclinic.jquery.csp',
        queryParams: {
            ClassName: "web.DHCANRoomDevice",
            QueryName: queryFunName,
            Arg1: function () {
                return getQueryParam();
            },
            ArgCnt: 1
        },
        border: 'true',
        singleSelect: true,
        toolbar: buttons,

        columns: [[
            { field: 'RowId', title: 'RowId', width: 100 },
            { field: 'DepartmentId', title: '����ID', width: 100, hidden: true },
            { field: 'Department', title: '����', width: 300 },
            { field: 'RoomId', title: '������id', width: 100, hidden: true },
            { field: 'Room', title: '������', width: 100 },
            { field: 'DeviceId', title: '�豸ID', width: 100, hidden: true },
            { field: 'DeviceName', title: '�豸', width: 200 },
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
            $.messager.alert("����", "�����䲻��Ϊ�գ�", 'error')
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
                ClassName: "web.DHCANRoomDevice",
                MethodName: "AddRoomDevice",
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

                if (data == 0) {
                    $('#bedDeviceDatagrid').datagrid('reload');
                    $.messager.show({
                        title: '��ʾ',
                        msg: '����ɹ�'
                    });
                }
                else {
                    $.messager.alert('����ʧ�ܣ�', data, 'warning');
                    return;
                }
            }

        })
    }

    //���º���
    function UpdategridData(isForce) {
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
        var data =  {
                ClassName: "web.DHCANRoomDevice",
                MethodName: "UpdateRoomDevice",
                Arg1: RowId,
                Arg2: Bed,
                Arg3: Device,
                Arg4: Note,
                ArgCnt: 4
            };
        if (isForce){
	        data.Arg5=true;
	        data.ArgCnt=5;
	      }
        $.ajax({
            url: "dhcclinic.jquery.method.csp",
            type: "POST",
            data: data,
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
                    $.messager.confirm('����!!', data+"�Ƿ�ǿ��ʹ�ø��豸��", function(b){
					      if (b){
					            UpdategridData(true);
					      }else{
					      }
					});
                    return;
                }
            }

        });
        
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
                        ClassName: "web.DHCANRoomDevice",
                        MethodName: "DeleteRoomDevice",
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
                ClassName: "web.DHCANDevice",
                QueryName: "FindLoc",
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
            }
            ,onHidePanel: function () {
               OnHidePanel("#Department");
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
                ClassName: "web.DHCANRoomDevice",
                QueryName: "FindRoom",
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
               OnHidePanel("#Bed");
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
                ClassName: "web.DHCANDevice",
                QueryName: "FindANDevice",
                Arg1: function () { return GetDepartmentId(); },
                Arg2: function () { return $("#Device").combogrid("getText"); },
                ArgCnt: 2
            },
            columns: [[
                { field: "RowId", title: "ID" },
                { field: "DeviceName", title: "Desc" }
            ]]
           ,
            onChange: function () {
                if ($(this).nextAll().find("input").is(":focus"))
                    $(this).combogrid('grid').datagrid('reload')
            }
            ,onHidePanel: function () {
               OnHidePanel("#Device");
            }
        });

        $("#Note").validatebox({
            width: 160
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
        departmentId = session['LOGON.ICU.WARDID'];
        if (session['LOGON.GROUPDESC'] == 'Demo Group') {
            departmentId = $('#Department').combogrid("getValue");
        }
        return departmentId;
    }

});
function getParam(paramName) {
    paramValue = "", isFound = !1;
    if (this.location.search.indexOf("?") == 0 && this.location.search.indexOf("=") > 1) {
        arrSource = unescape(this.location.search).substring(1, this.location.search.length).split("&"), i = 0;
        while (i < arrSource.length && !isFound) arrSource[i].indexOf("=") > 0 && arrSource[i].split("=")[0].toLowerCase() == paramName.toLowerCase() && (paramValue = arrSource[i].split("=")[1], isFound = !0), i++
    }
    return paramValue == "" && (paramValue = null), paramValue
}