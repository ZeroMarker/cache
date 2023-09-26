$(document).ready(function () {


    //维护界面初始化
    InitForm();
    var isDemoGroup=true;
    // 判断登陆科室是否demo安全组,是则可以看到全部科室信息，否则只可以看到本科室信息
    if (session['LOGON.GROUPDESC'] != 'Demo Group'){
	     isDemoGroup=false;
         $('#Department').combogrid('disable');
         $("#Department").combogrid("setValue", session['LOGON.ICU.WARDID']);
         $("#Department").combogrid("setText", session['LOGON.ICU.WARDDesc']);
    }
    //点击数据表格的一行数据返回到输入框
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
            text: '增加',
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
            { field: 'DepartmentId', title: '科室ID', width: 100, hidden: true },
            { field: 'Department', title: '科室', width: 300 },
            { field: 'BedId', title: '床位id', width: 100, hidden: true },
            { field: 'Bed', title: '床位', width: 100 },
            { field: 'DeviceId', title: '设备ID', width: 100, hidden: true },
            { field: 'Device', title: '设备', width: 200 },
            { field: 'Note', title: '备注', width: 100 }

        ]],
        onClickRow: function (rowIndex, rowData) {
            bedDeviceDatagrid_OnClickRow();
        },
        pagination: true,
        pageSize: 15,
        pageNumber: 1,
        pageList: [15, 30, 45, 60, 75]
    });
    //增加函数
    function AddgridData() {
        var Bed = $('#Bed').combogrid("getValue");
        var Device = $('#Device').combogrid("getValue");
        var Note = $('#Note').val();
        if (Bed == "") {
            $.messager.alert("错误", "床位不能为空！", 'error')
            return false;
        }
        if (Device == "") {
            $.messager.alert("错误", "设备号不能为空！", 'error')
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
                    text: '正在保存中...'
                });
            },
            success: function (data, response, status) {
                $.messager.progress('close');
                rowId=parseInt(data);
                if (rowId > 0) {
                    $('#bedDeviceDatagrid').datagrid('reload');
                    $.messager.show({
                        title: '提示',
                        msg: '保存成功'
                    });
                    grid.load();
                }
                else {
                    $.messager.alert('保存失败！', data, 'warning');
                    return;
                }
            }

        })
    }

    //更新函数
    function UpdategridData() {
        var RowId = $('#RowId').val();
        var Bed = $('#Bed').combogrid("getValue");
        var Device = $('#Device').combogrid("getValue");
        var Note = $('#Note').val();
        if (RowId == "") {
            $.messager.alert("错误", "Rowid不能为空！", 'error')
            return false;
        }
        if (Bed == "") {
            $.messager.alert("错误", "BedId不能为空！", 'error')
            return false;
        }

        if (Device == "") {
            $.messager.alert("错误", "设备不能为空！", 'error')
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

        var selectRow = $('#bedDeviceDatagrid').datagrid('getSelected');
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

        $("#Department").combogrid({
            panelWidth: 150,
            loadMsg: "正在加载中...",
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
	      //20190110 YuanLin 下拉框只能选择不允许手写
	      var SelectRow = $(this).combogrid("grid").datagrid('getSelected');
	      var Val = $(this).combogrid('getValue');
	      if(SelectRow)
	      {
		      if (Val != SelectRow.Id)
		      {
			      $.messager.alert("提示","请从下拉框选择","info");
			      return;
			  }
		  }
		  else
		  {
			  $.messager.alert("提示","请从下拉框选择","info");
			  return;
		  }
        }
        });
        
        $("#Bed").combogrid({
            panelWidth: 150,
            loadMsg: "正在加载中...",
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
	      //20190110 YuanLin 下拉框只能选择不允许手写
	      var SelectRow = $(this).combogrid("grid").datagrid('getSelected');
	      var Val = $(this).combogrid('getValue');
	      if(SelectRow)
	      {
		      if (Val != SelectRow.Id)
		      {
			      $.messager.alert("提示","请从下拉框选择","info");
			      return;
			  }
		  }
		  else
		  {
			  $.messager.alert("提示","请从下拉框选择","info");
			  return;
		  }
        }
       });
        $("#Device").combogrid({
            panelWidth: 150,
            loadMsg: "正在加载中...",
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
	      //20190110 YuanLin 下拉框只能选择不允许手写
	      var SelectRow = $(this).combogrid("grid").datagrid('getSelected');
	      var Val = $(this).combogrid('getValue');
	      if(SelectRow)
	      {
		      if (Val != SelectRow.RowId)
		      {
			      $.messager.alert("提示","请从下拉框选择","info");
			      return;
			  }
		  }
		  else
		  {
			  $.messager.alert("提示","请从下拉框选择","info");
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
		    $.messager.alert("提示", "请先选择科室！", 'info')
		    return;
	    }
    })
});
