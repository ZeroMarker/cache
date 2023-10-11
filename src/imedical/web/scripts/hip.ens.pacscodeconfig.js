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
    //  title: '检验检查状态字典表',
    idField: 'id',
    pageSize: 20,
    pageList: [5, 10, 15, 20, 25, 30, 50, 75, 100],
    afterPageText: '页,共{pages}页', beforePageText: '第', displayMsg: '显示{from}到{to}条，共{total}条',
    fitColumns: true,
    url: proxy + "action=GetEnsStatusCode&Input=",
    /*queryParams:{
            Input:"0^100"
    },*/
    columns: [[
      { field: 'ESCCode', title: '状态代码' },
      { field: 'ESCDesc', title: '状态描述' },
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
      // {field: 'ESCStartDate', title: '开始日期'},
      // {field: 'ESCEndDate', title: '结束日期'},
      { field: 'ESCNote', title: '备注' },
    ]],
    //toolbar:"#toolbar",
    toolbar: [{
      iconCls: 'icon-add', text: '新增', handler: function () {
        $('#pacsAddModal').css('display', 'block');
        $('#pacsAddModal').window({
          iconCls: 'icon-w-add',
          title: '新增',
        }).window('open');
        //$("#pacsForm")[0].reset();
        //$("#ESCNote").html("");

        /*  
        日期相关
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
      iconCls: 'icon-edit', text: '编辑', handler: function () {
        var row = tb.getSelected();
        if (row) {
          $('#pacsAddModal').css('display', 'block');
          $('#pacsAddModal').window({
            iconCls: 'icon-w-edit',
            title: '修改',
          }).window('open');
          $("input[name='ESCCode']").attr('readonly', 'readonly').css("background-color", "gainsboro");
          $("input[name='ESCCode']").val(row.ESCCode)
          $("input[name='ESCDesc']").val(row.ESCDesc)
          $("input[name='ESCEffectiveFlag'][value='" + row.ESCEffectiveFlag + "']").radio('setValue', true);
          $("#ESCNote").html(row.ESCNote);
          //验证必填
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
            //这里就是对单选按钮的单击事件，需要一个each，遍历出所有的radio,然后对每个radio绑定一个click
              $(this).click(function() {
                if(this.value == "N") {
                  console.log("N")
                }else{
                  console.log("Y")
                }
              });
            }); */


        } else {
          $.messager.alert("错误", "请选择行");
        }
      }
    },
    /*{
        iconCls: 'icon-remove', text: '删除', handler: function () {
        var row = tb.getSelected();
        console.log(row)
        if (row) {
            $.messager.confirm("提示", "确认删除？", function (r) {
                var input = row.ESCCode
                var rs = commonAjax(proxy, {
                    action: "EnsStatusCodeDelete",
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
  $('#pacsAddModal').window({
    title: '新建字典',
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
    if ($(".window-header .panel-title").text() == "新增") {
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
        $.messager.alert("错误", rs.data);
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
        $.messager.alert("错误", rs.data);
      }
    }
  })

  $("#pacClose").click(function () {
    $('#pacsAddModal').window('close');
  })
})