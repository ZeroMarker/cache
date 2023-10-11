var tb, proxy = "web.DHCENS.STBLL.Method.SystemStatusConfigMvc.cls?";
var initSearchbox = function () {
  $("#sbPacsCode").appendTo(".datagrid-toolbar table tbody tr")
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
  $("#pacsCodeTb").datagrid("load", { input: value });
  $(initSearchbox());
}



function loadTable () {
  tb = $HUI.datagrid('#pacsCodeTb', {
    fit: true,
    headerCls: 'panel-header-gray',
    //rownumbers: true,
    singleSelect: true,
    pagination: true,
    fixRowNumber: true,
    //  title: '������״̬�ֵ��',
    idField: 'id',
    pageSize: 20,
    pageList: [5, 10, 15, 20, 25, 30, 50, 75, 100],
    afterPageText: 'ҳ,��{pages}ҳ', beforePageText: '��', displayMsg: '��ʾ{from}��{to}������{total}��',
    fitColumns: true,
    url: proxy + "action=GetEnsStatusCode&Input=",
    /*queryParams:{
            Input:"0^100"
    },*/
    columns: [[
      { field: 'ESCCode', title: '״̬����' },
      { field: 'ESCDesc', title: '״̬����' },
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
      // {field: 'ESCStartDate', title: '��ʼ����'},
      // {field: 'ESCEndDate', title: '��������'},
      { field: 'ESCNote', title: '��ע' },
    ]],
    //toolbar:"#toolbar",
    toolbar: [{
      iconCls: 'icon-add', text: '����', handler: function () {
        $('#pacsAddModal').css('display', 'block');
        $('#pacsAddModal').window({
          iconCls: 'icon-w-add',
          title: '����',
        }).window('open');
        //$("#pacsForm")[0].reset();
        //$("#ESCNote").html("");

        /*  
        �������
        var dateTime=new Date();
         var nextd=new Date(dateTime.setDate(dateTime.getDate()+1))
         $('#ESCStartDate').datebox({
             formatter: function(date){ 
               var y = date.getFullYear();
               var m = date.getMonth()+1;
               var d = date.getDate();
               return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
             }
         });
         $('#ESCEndDate').datebox({
             formatter: function(date){ 
               var y = date.getFullYear();
               var m = date.getMonth()+1;
               var d = date.getDate();
               return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
             }
         }); 
         $('#ESCStartDate').datebox("setValue",nextd)
         $("#ESCEndDate").datebox('readonly',true) 
         $('#ESCEndDate').datebox("setValue","")*/

        $("input[name='ESCCode']").removeAttr('readonly', 'readonly').css("background-color", "#fff");
        $(".Y").radio('setValue', true);
        $("input[name='ESCCode']").validatebox("validate")
        $("input[name='ESCDesc']").validatebox("validate")
      }
    },
    {
      iconCls: 'icon-edit', text: '�༭', handler: function () {
        var row = tb.getSelected();
        if (row) {
          $('#pacsAddModal').css('display', 'block');
          $('#pacsAddModal').window({
            iconCls: 'icon-w-edit',
            title: '�޸�',
          }).window('open');
          $("input[name='ESCCode']").attr('readonly', 'readonly').css("background-color", "gainsboro");
          $("input[name='ESCCode']").val(row.ESCCode)
          $("input[name='ESCDesc']").val(row.ESCDesc)
          $("input[name='ESCEffectiveFlag'][value='" + row.ESCEffectiveFlag + "']").radio('setValue', true);
          $("#ESCNote").html(row.ESCNote);
          //��֤����
          $("input[name='ESCCode']").validatebox("validate")
          $("input[name='ESCDesc']").validatebox("validate")

          /* $('#ESCStartDate').datebox({
              formatter: function(date){ 
                var y = date.getFullYear();
                var m = date.getMonth()+1;
                var d = date.getDate();
                return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
              }
          });
          $('#ESCEndDate').datebox({
              formatter: function(date){ 
                var y = date.getFullYear();
                var m = date.getMonth()+1;
                var d = date.getDate();
                return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
              }
          });
          //$('#ESCStartDate').datebox('readonly',true) 
          $("#ESCEndDate").datebox('readonly',true) 
          $('#ESCStartDate').datebox("setValue",row.ESCStartDate)
          $('#ESCEndDate').datebox("setValue",row.ESCEndDate) */

          /* $.each($("input[name=ESCEffectiveFlag]"), function(index) {
            //������ǶԵ�ѡ��ť�ĵ����¼�����Ҫһ��each�����������е�radio,Ȼ���ÿ��radio��һ��click
              $(this).click(function() {
                if(this.value == "N") {
                  console.log("N")
                }else{
                  console.log("Y")
                }
              });
            }); */


        } else {
          $.messager.alert("����", "��ѡ����");
        }
      }
    },
    /*{
        iconCls: 'icon-remove', text: 'ɾ��', handler: function () {
        var row = tb.getSelected();
        console.log(row)
        if (row) {
            $.messager.confirm("��ʾ", "ȷ��ɾ����", function (r) {
                var input = row.ESCCode
                var rs = commonAjax(proxy, {
                    action: "EnsStatusCodeDelete",
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
    }*/
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
  $('#pacsAddModal').window({
    title: '�½��ֵ�',
    iconCls: 'icon-add',
    modal: true,
    closed: true,
    top: 200,
    onBeforeClose: function () {
      $("#pacsForm")[0].reset()
      $(".Y").radio('setValue', true)
      $("#ESCNote").html("");
    }
  });
  $(".Y").radio({});
  $(".N").radio({});
  $(".Y").radio('setValue', true);
}

$(function () {
  loadTable()
  modalInit()
  $("#pacSave").click(function () {
    if ($(".window-header .panel-title").text() == "����") {
      var input = JSON.stringify($("#pacsForm").serializeArray())
      var rs = commonAjax(proxy, {
        action: "EnsStatusCodeInsert",
        input: input
      }, "", "")
      if (rs.data == "1") {
        $('#pacsAddModal').window('close');
        tb.reload()
        $("#ESCNote").html("");

      } else {
        $.messager.alert("����", rs.data);
      }
    } else {
      var input = JSON.stringify($("#pacsForm").serializeArray())
      var rs = commonAjax(proxy, {
        action: "EnsStatusCodeUpdate",
        input: input
      }, "", "")
      if (rs.data == "1") {
        $('#pacsAddModal').window('close');
        $("#ESCNote").html("");
        tb.reload()

      } else {
        $.messager.alert("����", rs.data);
      }
    }
  })

  $("#pacClose").click(function () {
    $('#pacsAddModal').window('close');
  })
})