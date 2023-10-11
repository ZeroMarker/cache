var tb, proxy = "web.DHCENS.STBLL.Method.SystemStatusConfigMvc.cls?";
var initSearchbox = function () {
  $("#sbMtCode").appendTo(".datagrid-toolbar table tbody tr")
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
  //$("#mtCodeTb").datagrid({url:proxy + "action=GetEnsSystemType&input="+value});
  $("#mtCodeTb").datagrid("load", { input: value });
  $(initSearchbox());
}


//加载表格
function loadTable () {
  tb = $HUI.datagrid('#mtCodeTb', {
    fit: true,
    headerCls: 'panel-header-gray',
    //rownumbers: true,
    singleSelect: true,
    pagination: true,
    fitColumns: true,
    //fixRowNumber: true,
    // title: '医技系统分类字典表',
    idField: 'id',
    pageSize: 20,
    pageList: [5, 10, 15, 20, 25, 30, 50, 75, 100],
    afterPageText: '页,共{pages}页', beforePageText: '第', displayMsg: '显示{from}到{to}条，共{total}条',
    url: proxy + "action=GetEnsSystemType",
    // url:$URL+"drms.Dao.DRUser/GetUserInfoData?rows=9999&Input=",
    /*queryParams:{
            Input:"0^100"
    },*/
    columns: [[
      { field: 'ESCCode', title: '系统代码' },
      { field: 'ESCDesc', title: '系统描述' },
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
      iconCls: 'icon-add', text: '增加', handler: function () {
        $('#mtAddModal').css('display', 'block');
        $('#mtAddModal').window({
          iconCls: 'icon-w-add',
          title: '新增',
        }).window('open');
        $('#mtAddModal').css('display', 'block');
        //$('#methodDetail').window('open');
        $("input[name='ESCCode']").removeAttr('readonly').css("background-color", "#fff");
        $("input[name='ESCCode']").validatebox('validate')
        $("input[name='ESCDesc']").validatebox('validate')
      }
    },
    {
      iconCls: 'icon-edit', text: '编辑', handler: function () {
        $('#mtAddModal').css('display', 'block');
        var row = tb.getSelected();
        if (row) {
          $('#mtAddModal').window({
            iconCls: 'icon-w-edit',
            title: '修改',
          }).window('open');
          $("input[name='ESCCode']").attr('readonly', 'readonly').css("background-color", "gainsboro");
          $("input[name='ESCCode']").val(row.ESCCode)
          $("input[name='ESCDesc']").val(row.ESCDesc)
          $("input[name='ESCEffectiveFlag'][value='" + row.ESCEffectiveFlag + "']").radio('setValue', true);
          $("input[name='ESCCode']").validatebox('validate')
          $("input[name='ESCDesc']").validatebox('validate')
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
                var input = row.ESCCode
                var rs = commonAjax(proxy, {
                    action: "EnsSystemTypeDelete",
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
    },*/
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
  $('#mtAddModal').window({
    title: '新建字典',
    iconCls: 'icon-add',
    modal: true,
    closed: true,
    top: 200,
    onBeforeClose: function () {
      $("#mtForm")[0].reset()
      $(".Y").radio('setValue', true)
    },
  });
  $(".Y").radio({});
  $(".N").radio({});
  $(".Y").radio('setValue', true)
}

$(function () {
  loadTable()
  modalInit()
  //保存
  $("#mtSave").click(function () {
    if ($(".window-header .panel-title").text() == "新增") {
      var input = JSON.stringify($("#mtForm").serializeArray())//$("#mtForm").serialize()
      var rs = commonAjax(proxy, {
        action: "EnsSystemTypeInsert",
        input: input
      }, "", "")
      if (rs.data == "1") {
        $('#mtAddModal').window('close');
        tb.reload()
      } else {
        $.messager.alert("错误", rs.data);
      }
    } else {
      var input = JSON.stringify($("#mtForm").serializeArray())//$("#$mtForm").serialize()
      var rs = commonAjax(proxy, {
        action: "EnsSystemTypeUpdate",
        input: input
      }, "", "")
      if (rs.data == "1") {
        $('#mtAddModal').window('close');

        tb.reload()

      } else {
        $.messager.alert("错误", rs.data);
      }
    }
  })
  // 关闭
  $("#mtClose").click(function () {
    $('#mtAddModal').window('close');
  })


})