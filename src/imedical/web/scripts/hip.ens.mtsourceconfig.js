var tb, proxy = "web.DHCENS.STBLL.Method.SystemStatusConfigMvc.cls?";
var initSearchbox = function () {
  $("#sbMtSource").appendTo(".datagrid-toolbar table tbody tr")
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
    $.error("��θ�ʽ����:" + params)
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
      var errorstr = "������־��" + "\n"
        + "url��" + url + ";" + "\n"
        + "params: " + JSON.stringify(params) + ";" + "\n"
        + "reason:" + JSON.stringify(a) + "\n";
      +b + "\n";
      +c + "\n";
      try {
        console.error("ajax����", errorstr, JSON.stringify(a), b, c)
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
  $("#mtSourceTb").datagrid("load", { input: value });
  $(initSearchbox());
}


function loadTable () {
  tb = $HUI.datagrid('#mtSourceTb', {
    fit: true,
    headerCls: 'panel-header-gray',
    //rownumbers: true,
    singleSelect: true,
    pagination: true,
    // fixRowNumber: true,
    // title: 'ҽ��ϵͳ��Դ�ֵ��',
    idField: 'id',
    pageSize: 20,
    pageList: [5, 10, 15, 20, 25, 30, 50, 75, 100],
    afterPageText: 'ҳ,��{pages}ҳ', beforePageText: '��', displayMsg: '��ʾ{from}��{to}������{total}��',
    fitColumns: true,
    url: proxy + "action=GetEnsSystem&Input=",
    // url:$URL+"drms.Dao.DRUser/GetUserInfoData?rows=9999&Input=",
    /*queryParams:{
            Input:"0^100"
    },*/
    columns: [[
      { field: 'ESCCode', title: '����' },
      { field: 'ESCDesc', title: '����' },
      { field: 'ESysTypeCode', title: 'ϵͳ�������' },
      {
        field: 'ESCEffectiveFlag', title: '���ñ�־',
        formatter: function (value, row, index) {
          var str;
          if (value == "Y") {
            str = "��"

          } else {
            str = "��"
          }
          return str
        }
      },
      //{field: 'DRUSRPassword', title: '��ʼ����'},
      //{field: 'DRUSRLANCode', title: '��������'},

    ]],
    toolbar: [{
      iconCls: 'icon-add', text: '����', handler: function () {
        $('#mtSourceModal').css('display', 'block')
        $('#mtSourceModal').window({
          iconCls: 'icon-w-add',
          title: '����',
        }).window('open');
        loadSelect()
        $("input[name='ESCCode']").removeAttr('readonly').css("background-color", "#fff");
        //$("#mtsForm")[0].reset()
        // ��֤����
        $("input[name='ESCCode']").validatebox('validate')
        $("input[name='ESCDesc']").validatebox('validate')
      }
    },
    {
      iconCls: 'icon-edit', text: '�༭', handler: function () {
        var row = tb.getSelected();
        if (row) {
          $('#mtSourceModal').css('display', 'block')
          $('#mtSourceModal').window({
            iconCls: 'icon-w-edit',
            title: '�޸�',
          }).window('open');
          loadSelect()
          $("input[name='ESCCode']").attr('readonly', 'readonly').css("background-color", "gainsboro")
          $("input[name='ESCCode']").val(row.ESCCode)
          $("input[name='ESCDesc']").val(row.ESCDesc)
          $("input[name='ESCEffectiveFlag'][value='" + row.ESCEffectiveFlag + "']").radio('setValue', true);
          $("#mtsSysItem").combobox('setValue', row.ESysTypeCode);
          // ��֤����
          $("input[name='ESCCode']").validatebox('validate')
          $("input[name='ESCDesc']").validatebox('validate')

        } else {
          $.messager.alert("����", "��ѡ����");
        }
      }
    },/*
            {
                iconCls: 'icon-remove', text: 'ɾ��', handler: function () {
                var row = tb.getSelected();
                if (row) {
                    $.messager.confirm("��ʾ", "ȷ��ɾ����", function (r) {
                        var input = row.ESCCode
                        var rs = commonAjax(proxy, {
                            action: "EnsSystemDelete",
                            input: input
                        }, "", "")
                        if (rs.data == "1") {
                            $.messager.alert("�ɹ�", "ɾ���ɹ�");
                            tb.reload();
                        } else {
                            $.messager.alert("�ɹ�", "ɾ��ʧ��<br>" + (rtn));
                        }
                    })
                } else {
                    $.messager.alert("����", "��ѡ����");
                }
            }
            },*/
    {
      iconCls: 'icon-reload', text: 'ˢ��', handler: function () {
        tb.reload();
      }
    }
    ],
  });
  $(initSearchbox());
}

function modalInit () {
  $('#mtSourceModal').window({
    title: '�½��ֵ�',
    iconCls: 'icon-add',
    modal: true,
    closed: true,
    top: 200,
    onBeforeClose: function () {
      $("#mtsForm")[0].reset()
      $(".Y").radio('setValue', true)
    }
  });
  $(".Y").radio({});
  $(".N").radio({});
  $(".Y").radio('setValue', true);
}
function loadSelect () {
  var sys = commonAjax(proxy, {
    action: "GetEnsSystemType",
    input: "enable"
  }, "", "")
  $('#mtsSysItem').combobox({
    //url: proxy + "action=GetEnsSystem&Input=",
    valueField: 'ESCCode',
    textField: 'ESCCode',
    data: sys.rows
  })
}

$(function () {
  loadTable()
  modalInit()
  $("#mtsSave").click(function () {
    if ($(".window-header .panel-title").text() == "����") {
      var input = JSON.stringify($("#mtsForm").serializeArray()) //$("#mtsForm").serialize()
      var rs = commonAjax(proxy, {
        action: "EnsSystemInsert",
        input: input
      }, "", "")
      if (rs.data == "1") {
        $('#mtSourceModal').window('close');
        tb.reload()
      } else {
        $.messager.alert("����", rs.data);
      }
    } else if ($(".window-header .panel-title").text() == "�޸�") {
      var input = JSON.stringify($("#mtsForm").serializeArray())
      var rs = commonAjax(proxy, {
        action: "EnsSystemUpdate",
        input: input
      }, "", "")
      if (rs.data == "1") {
        $('#mtSourceModal').window('close');
        tb.reload()
      } else {
        $.messager.alert("����", rs.data);
      }
    }
  })
  $("#mtsClose").click(function () {
    $('#mtSourceModal').window('close');
  })

})