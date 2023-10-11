var tb, proxy = "web.DHCENS.STBLL.Method.SystemStatusConfigMvc.cls?";
var initSearchbox = function () {
  $("#sbPacsSource").appendTo(".datagrid-toolbar table tbody tr")
}

function commonAjax (url, params, ansycflag, fn) {
  var reData = '', postUrl = url;
  if (typeof arguments[arguments.length - 1] === "function")
    var callbackftn = arguments[arguments.length - 1];

  if (ansycflag == null) {
    var ansycflag = true;
  } else {
    var ansycflag = false;
  }

  if (typeof params === "object") {
    paradata = params
  } else {
    $.error("入参格式不对:" + params)
  }
  $.ajax({
    type: "POST",
    url: url,
    dataType: "json",
    data: paradata,
    async: ansycflag,
    success: function (data) {
      if (callbackftn != undefined || callbackftn != null && typeof callbackftn === "function") {
        callbackftn(data);
      } else {
        reData = data;
        return reData;
      }
      ;
    },
    error: function (a, b, c) {
      var errorstr = "错误日志：" + "\n"
        + "url：" + url + ";" + "\n"
        + "params: " + JSON.stringify(params) + ";" + "\n"
        + "reason:" + JSON.stringify(a) + "\n";
      +b + "\n";
      +c + "\n";
      try {
        console.error("ajax错误：", errorstr, JSON.stringify(a), b, c)
        //console.error(errorstr)
      } catch (e) {
        alert(errorstr);
      }

    }
  });
  return reData;

}
function searcherFun (value) {
  console.log("searcherFun=", value)
  var queryvalue = value;
  $("#pacsSourceTb").datagrid("load", { input: value });
  $(initSearchbox());
}
function loadTable () {
  tb = $HUI.datagrid('#pacsSourceTb', {
    fit: true,
    headerCls: 'panel-header-gray',
    // rownumbers: true,
    singleSelect: true,
    pagination: true,
    fixRowNumber: true,
    // title: '检验检查状态系统来源表',
    idField: 'id',
    pageSize: 20,
    pageList: [5, 10, 15, 20, 25, 30, 50, 75, 100],
    afterPageText: '页,共{pages}页', beforePageText: '第', displayMsg: '显示{from}到{to}条，共{total}条',
    fitColumns: true,
    url: proxy + "action=GetEnsSystemLinkStatus&Input=",
    // url:$URL+"drms.Dao.DRUser/GetUserInfoData?rows=9999&Input=",
    /*queryParams:{
            Input:"0^100"
    },*/
    columns: [[
      { field: 'ESSSystemCode', title: '系统来源代码' },
      { field: 'ESSStatusCode', title: '状态代码' },
      { field: 'ESSSequence', title: '状态顺序' },
      {
        field: 'ESCEffectiveFlag', title: '启用标志',
        formatter: function (value, row, index) {
          var str;
          if (value == "Y") {
            str = "是"
          } else {
            str = "否"
          }
          return str
        }
      },
    ]],
    toolbar: [{
      iconCls: 'icon-add', text: '新增', handler: function () {
        $('#pacsSourceModal').css("display", 'block')
        $('#pacsSourceModal').window({
          iconCls: 'icon-w-add',
          title: '新增',
        }).window('open');
        loadSelect()
        // 验证必填项
        $('#pacssSysItem').combobox("validate")
        $('#statusSysItem').combobox("validate")
        $('#ESSSequence').validatebox('validate')
        $("#pacssSysItem").combobox('readonly', false)
        $("#statusSysItem").combobox('readonly', false)
        // $("#pacssSysItem").combobox('enable')
        ///$("#statusSysItem").combobox('enable')
        //$("#pacssForm")[0].reset()
      }
    },
    {
      iconCls: 'icon-edit', text: '编辑', handler: function () {
        var row = tb.getSelected();
        if (row) {
          $('#pacsSourceModal').css("display", 'block')
          $('#pacsSourceModal').window({
            iconCls: 'icon-w-edit',
            title: '修改',
          }).window('open');
          loadSelect()
          $("#pacssSysItem").combobox('setValue', row.ESSSystemCode);
          $("#statusSysItem").combobox('setValue', row.ESSStatusCode);
          $("#pacssSysItem").combobox('readonly', true)
          $("#statusSysItem").combobox('readonly', true)
          $("input[name='ESSSequence']").val(row.ESSSequence)
          $('#pacssSysItem').combobox("validate")
          $('#statusSysItem').combobox("validate")
          $('#ESSSequence').validatebox('validate')
          //$("#pacssSysItem").combobox('disable')
          //$("#statusSysItem").combobox('disable')
          $("input[name='ESCEffectiveFlag'][value='" + row.ESCEffectiveFlag + "']").radio('setValue', true);
        } else {
          $.messager.alert("错误", "请选择行");
        }
      }
    },
    /*{
        iconCls: 'icon-remove', text: '删除', handler: function () {
        var row = tb.getSelected();
        if (row) {
            $.messager.confirm("提示", "确认删除？", function (r) {
                var input = row.ESSSystemCode+"&"+row.ESSStatusCode
                var rs = commonAjax(proxy, {
                    action: "EnsSystemLinkStatusDelete",
                    input: input
                }, "", "")
                if (rs.data == "1") {
                    $.messager.alert("成功", "删除成功");
                    tb.reload();
                } else {
                    $.messager.alert("成功", "删除失败<br>" + (rtn));
                }
            })
        } else {
            $.messager.alert("错误", "请选择行");
        }
    }
    }*/
    {
      iconCls: 'icon-reload', text: '刷新', handler: function () {
        tb.reload();
      }
    }
    ],
  });
  $(initSearchbox());
}

function modalInit () {
  $('#pacsSourceModal').window({
    title: '新建字典',
    iconCls: 'icon-add',
    modal: true,
    closed: true,
    onBeforeClose: function () {
      $("#pacssForm")[0].reset()
      $(".Y").radio('setValue', true)
      $(".N").radio('setValue', false)
    }
  });
  $(".Y").radio({});
  $(".N").radio({});
  $(".Y").radio('setValue', true)
  $(".N").radio('setValue', false)
}

function loadSelect () {
  var sys = commonAjax(proxy, {
    action: "GetEnsSystem",
    input: "enable"
  }, "", "")
  $('#pacssSysItem').combobox({
    //url: proxy + "action=GetEnsSystem&Input=",
    valueField: 'ESCCode',
    textField: 'ESCCode',
    required: true,
    data: sys.rows
  })
  var status = commonAjax(proxy, {
    action: "GetEnsStatusCode",
    input: "enable"
  }, "", "")
  $('#statusSysItem').combobox({
    //url:proxy + "action=GetEnsStatusCode&Input=",
    valueField: 'ESCCode',
    textField: 'ESCCode',
    required: true,
    data: status.rows
  })
}

$(function () {
  loadTable()
  modalInit()
  $("#pacsSave").click(function () {
    if ($(".window-header .panel-title").text() == "新增") {
      var input = JSON.stringify($("#pacssForm").serializeArray())//$("#pacssForm").serializeArray()
      var rs = commonAjax(proxy, {
        action: "EnsSystemLinkStatusInsert",
        input: input
      }, "", "")
      if (rs.data == "1") {
        $('#pacsSourceModal').window('close');
        tb.reload()
      } else {
        $.messager.alert("错误", rs.data);
      }
    } else {
      var input = JSON.stringify($("#pacssForm").serializeArray())
      var rs = commonAjax(proxy, {
        action: "EnsSystemLinkStatusUpdate",
        input: input
      }, "", "")
      if (rs.data == "1") {
        $('#pacsSourceModal').window('close');
        tb.reload()
      } else {
        $.messager.alert("错误", rs.data);
      }
    }
  })
  $("#pacsClose").click(function () {
    $('#pacsSourceModal').window('close');
  })
})