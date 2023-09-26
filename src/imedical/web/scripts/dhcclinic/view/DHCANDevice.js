$(document).ready(function () {

    //维护界面初始化
    InitForm();
    var isDemoGroup=true;
    // 判断登陆科室是否demo安全组,是则可以看到全部科室信息，否则只可以看到本科室信息
    if (session['LOGON.GROUPDESC'] != 'Demo Group'){
	     isDemoGroup=false;
         $('#Department').combogrid('disable');
         $("#Department").combogrid("setValue", session['LOGON.CTLOCID']);
         $("#Department").combogrid("setText", session['LOGON.AN.LocDesc']);
    }
    
    //点击数据表格的一行数据返回到输入框
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

    //数据表格datagrid的定义 
   
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
            text: '添加',
            handler: function () {
                AddgridData();
            }
        }, '----', {
            iconCls: 'icon-edit',
            text: '修改',
            handler: function () {
                UpdategridData();
            }
        }, '----', {
            iconCls: 'icon-cut',
            text: '删除',
            handler: function () {
                DeleteGridData();
            }
        }],

        columns: [[
            { field: 'RowId', title: 'RowId', width: 100 },
            { field: 'DeviceNumber', title: '设备编号', width: 100 },
            { field: 'DeviceName', title: '设备名称', width: 100 },
            { field: 'DepartmentId', title: '科室Id', width: 100, hidden: true },
            { field: 'Department', title: '科室', width: 250 },
            { field: 'CollectInterfaceId', title: '采集代码Id', width: 100, hidden: true },
            { field: 'CollectInterface', title: '采集代码', width: 100 },
            { field: 'Ip', title: 'ip地址', width: 100 },
            { field: 'Port', title: '端口', width: 100 },
            { field: 'IntervalTime', title: '采集间隔', width: 100 },
            { field: 'MacAddress', title: 'MAC地址', width: 100 },
            { field: 'SerialNumber', title: '序列号', width: 100 },
            { field: 'CollectSrvIP', title: '采集服务器Ip', width: 100 }
        ]],
        onClickRow: function (rowIndex, rowData) {
            deviceDatagrid_OnClickRow();
        },
        pagination: true,
        pageSize: 15,
        pageNumber: 1,
        pageList: [15, 30, 45, 60]
    });

    //增加函数
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
            $.messager.alert("错误", "设备编号不能为空！", 'error')
            return false;
        }
        if (DeviceName == "") {
            $.messager.alert("错误", "设备名称不能为空！", 'error')
            return false;
        }
        if (Department == "") {
            $.messager.alert("错误", "科室不能为空！", 'error')
            return false;
        }
        if (CollectInterfaceId == "") {
            $.messager.alert("错误", "采集代码不能为空！", 'error')
            return false;
        }
        if (Ip == "") {
            $.messager.alert("错误", "ip地址不能为空！", 'error')
            return false;
        }
        if (Port == "") {
            $.messager.alert("错误", "端口不能为空！", 'error')
            return false;
        }
        if (MacAddress == "") {
            $.messager.alert("错误", "MAC地址不能为空！", 'error')
            return false;
        }
        if (SerialNumber == "") {
            $.messager.alert("错误", "序列号不能为空！", 'error')
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
                    text: '正在保存中...'
                });
            },
            success: function (data, response, status) {
                $.messager.progress('close');
                if (data > 0) {
                    $('#deviceDatagrid').datagrid('reload');
                    $.messager.show({
                        title: '提示',
                        msg: '保存成功'
                    });
                }
                else {
                    $.messager.alert('保存失败！', data, 'warning')
                    return;
                }
            }

        })
    }

    //更新函数
    function UpdategridData() {
        var RowId = $('#RowId').val();
		if (RowId=="" || RowId==undefined){
			 $.messager.alert("错误", "请先择中一行", 'error')
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
            $.messager.alert("错误", "设备编号不能为空！", 'error')
            return false;
        }
        if (DeviceName == "") {
            $.messager.alert("错误", "设备名称不能为空！", 'error')
            return false;
        }
        if (Department == "") {
            $.messager.alert("错误", "科室不能为空！", 'error')
            return false;
        }
        if (CollectInterfaceId == "") {
            $.messager.alert("错误", "采集代码不能为空！", 'error')
            return false;
        }
        if (Ip == "") {
            $.messager.alert("错误", "ip地址不能为空！", 'error')
            return false;
        }
        if (Port == "") {
            $.messager.alert("错误", "端口不能为空！", 'error')
            return false;
        }
        if (MacAddress == "") {
            $.messager.alert("错误", "MAC地址不能为空！", 'error')
            return false;
        }
        if (SerialNumber == "") {
            $.messager.alert("错误", "序列号不能为空！", 'error')
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
                        title: '提示',
                        msg: '更新成功'
                    });
                }
                else {
                    $.messager.alert('更新失败！', data, 'warning')
                    return;
                }
            }

        })
    }

    //删除函数
    function DeleteGridData() {
        var selectRow = $('#deviceDatagrid').datagrid('getSelected');
        if (!selectRow) {
            $.messager.alert("错误", "RowId不能为空！", 'error')
            return false;
        }
        $.messager.confirm('请确认', '您确定要删除所选的行？', function (b) {
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
                                title: '提示',
                                msg: '删除成功'
                            });
                        }
                        else {
                            $.messager.alert('删除失败！', data, 'warning')
                            return;
                        }
                    }

                })
            }
        })


    }

    //界面初始化函数
    function InitForm() {
        $("#DeviceNumber").validatebox({
            width: 140
        });
        $("#DeviceName").validatebox({
            width: 140
        });

        $("#Department").combogrid({
            panelWidth: 150,
            loadMsg: "正在加载中...",
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
            loadMsg: "正在加载中...",
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
	    var val = $(item).combogrid("getValue");  //当前combobox的值
	    if(valueField==val)
	    {
		    alert("请从下拉框选择")	    
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