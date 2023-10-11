var GV = {}
//GV.proxy = "web.DHCENS.STBLL.Method.SystemStatusConfigMvc.cls?";
GV.proxy = "web.DHCENS.STBLL.MANAGE.Proxy.loadPage.cls"
GV.dicApplyEditRow = undefined
GV.tbPageNo = 1;  //当前页数
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

//加载列表
function loadTable () {
  GV.tb = $HUI.datagrid('#mtSourceTb', {
    fit: true,
    headerCls: 'panel-header-gray',
    //rownumbers: true,
    singleSelect: true,
    pagination: true,
    // title: '医技系统来源字典表',
    idField: 'id',
    pageSize: 20,
    pageList: [20, 40, 60, 80, 100],
    afterPageText: '页,共{pages}页', beforePageText: '第', displayMsg: '显示{from}到{to}条，共{total}条',
    fitColumns: true,
    //autoSizeColumn: false,
    url: GV.proxy + "?action=QuerySystemConfig",
    columns: [[
      { field: 'systemcode', title: '系统代码', width: 150 },
      { field: 'systemdesc', title: '系统描述', width: 150 },
      { field: 'systemversion', title: '版本', width: 150 },
      {
        field: 'hospital', title: '院区', width: 300,
        formatter: function (value, row, index) {
          var desc = "";
          var arr = GV.courtyard
          for (var i = 0; i < arr.length; i++) {
            if (arr[i].code == value) {
              desc = arr[i].desc;
              break;
            }
          }
          return desc;
        }
      },
      {
        field: 'deptdesc', title: '科室', width: 200, /* showTip: true, tipWidth: 200,  formatter: function (value, row, index) {
          return '<a href="#" title="' + row.deptdesc + '" class="hisui-tooltip deptTips"  style="color: black;text-decoration: none;">' + row.deptdesc + '</a>'
        } */
      },
      { field: 'systemmode', title: '模式', width: 150 },
      {
        field: 'workgroup', title: '产品组', width: 200,
        formatter: function (value, row, index) {
          var desc = "";
          var arr = GV.productList
          for (var i = 0; i < arr.length; i++) {
            if (arr[i].code == value) {
              desc = arr[i].desc;
              break;
            }
          }
          return desc;
        }
      },
      {
        field: 'status', title: '状态', width: 150,
        formatter: function (value, row, index) {
          var val = value == "Y" ? true : false
          var dataoptions = "onText:'启用',offText:'停用',size:'small',animated:true,onClass:'primary',offClass:'gray',checked:" + val
          var str = '<div class="hisui-switchbox tabSwitch" data-options="' + dataoptions + '"></div>'
          return str
        }
      },
      {
        field: 'cc', title: '功能', width: 100, formatter: function (value, row, index) {
          return '<a class="funConfig" onclick="showFunConfig(' + index + ')"></a>'
        }
      },
    ]],
    /*   loadFilter: function (data) {
        var newdata = JSON.parse(data)
        console.log("newdata", newdata)
        return newdata
      }, */
    toolbar: '#toolbar',
    onLoadSuccess: function (data) {
      // $(".deptTips").tooltip({ position: 'right' })
      $(".tabSwitch").switchbox({
        disabled: false,
        onSwitchChange: function (e, obj) {
          var rowIndex = $(this).parents('td').parents('tr').attr('datagrid-row-index')
          GV.tb.selectRow(rowIndex)
          var rowData = GV.tb.getSelected()
          // 系统代码^院区^版本^系统状态
          //var inpurStr =  + "^" + rowData.hospital + "^" + rowData.systemversion + "^" + obj.value
          var status = obj.value ? 'Y' : 'N'
          var inputStr = rowData.systemcode + "^" + rowData.systemdesc
            + "^" + rowData.systemversion + "^"
            + rowData.hospital + "^" +
            rowData.systemmode + "^" +
            rowData.workgroup + "^" + status + "^" + JSON.stringify(rowData.deptcode.split(','))
          //ajax调用加载方法
          $.ajax({
            type: "POST",
            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            url: GV.proxy + "?action=SystemConfig&input=" + encodeURI(inputStr),
            dateType: "json",
            success: function (result) {
              var rs = JSON.parse(result)
              if (rs.retval == 1) {
                $('#addOrEditDiag').window('close');
                GV.tb.reload()
                $('#sysDesc').combobox('reload');
              } else {
                $.messager.alert("错误", rs.retinfo);
              }
            }
          })

        }
      })
      $(".funConfig").linkbutton({ iconCls: 'icon-batch-cfg', plain: true });
    }
  });
}

//保存配置
function addConfig () {
  //新增更新
  var cfgSysCode = $("#cfgSysCode").combobox("getValue")
  if (!cfgSysCode) {
    $.messager.alert('提示', '系统代码不能为空', 'info');
    return false
  }



  var cfgSysDesc = $('input[name="cfgSysDesc"]').val()
  if (!cfgSysDesc) {
    $.messager.alert('提示', '系统描述不能为空', 'info');
    return false
  }
  var cfgSysVersion = $('input[name="cfgSysVersion"]').val()
  var cfgcourtyard = $('#cfgcourtyard').combobox('getValue')
  if (!cfgcourtyard) {
    $.messager.alert('提示', '院区不能为空', 'info');
    return false
  }

  var dept = $("#dept").combobox('getValues')
  dept = JSON.stringify(dept)
  if (!dept) {
    $.messager.alert('提示', '科室不能为空', 'info');
    return false
  }
  /* 模式 */
  var cfgModel = $("#cfgSysModel").combobox("getValue")
  if (!cfgModel) {
    $.messager.alert('提示', '模式不能为空', 'info');
    return false
  }

  var cfgProduction = $('#cfgProduction').combobox('getValue')
  var status = $("#cfgStatus").switchbox('getValue') ? 'Y' : 'N'

  //inpurStr = cfgSysCode + "^" + cfgSysDesc + "^" + cfgSysVersion + "^" + cfgcourtyard + "^" + cfgProduction + "^" + status + "^" + dept
  // 系统代码^系统描述^版本^院区^模式^产品组^状态^科室代码
  inpurStr = cfgSysCode + "^" + cfgSysDesc + "^" + cfgSysVersion + "^" + cfgcourtyard + "^" + cfgModel + "^" + cfgProduction + "^" + status + "^" + dept
  $.ajax({
    type: "POST",
    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
    url: GV.proxy + "?action=SystemConfig&input=" + encodeURI(inpurStr),
    dateType: "json",
    success: function (result) {
      var rs = JSON.parse(result)
      if (rs.retval == 1) {
        $('#addOrEditDiag').window('close');
        GV.tb.reload()
        $('#sysDesc').combobox('reload');
      } else {
        $.messager.alert("错误", rs.retinfo);
      }
    }
  })
}
/* 取消保存 */
function cancel () {
  $('#addOrEditDiag').window('close');
}


//显示功能维护模态框
function showFunConfig (index) {
  GV.tb.selectRow(index)
  //获取选中行
  GV.selectSysRow = $("#mtSourceTb").datagrid('getSelected')
  //加载功能列表
  //GV.funTg =$("#functiinList").datagrid({
  GV.funTg = $HUI.datagrid("#functiinList", {
    fit: true,
    height: 400,
    headerCls: 'panel-header-gray',
    //rownumbers: true,
    singleSelect: true,
    pagination: true,
    //fixRowNumber: true,
    // title: '医技系统来源字典表',
    idField: 'id',
    pageSize: 10,
    pageList: [5, 10, 15, 20, 25, 30, 50, 75, 100],
    afterPageText: '页,共{pages}页', beforePageText: '第', displayMsg: '显示{from}到{to}条，共{total}条',
    fitColumns: true,
    autoSizeColumn: false,
    url: GV.proxy + "?action=QuerySysFunction&input=" + GV.selectSysRow.systemcode + "^" + GV.selectSysRow.hospital + "^" + GV.selectSysRow.systemversion,
    columns: [[
      { field: 'functioncode', title: '功能代码', width: 200, editor: { type: 'text' } },
      { field: 'functiondesc', title: '功能描述', width: 200, editor: { type: 'text' } },
    ]],
    //单击行事件
    onClickRow: function (index, row) {
      if (GV.dicApplyEditRow != undefined) {
        rejectEdit();
        GV.funTg.selectRow(index);
      }
    },
    onAfterEdit: function (rowIndex, rowData, changes) {//新增|更新
      var inpurStr = GV.editType + '|' + GV.selectSysRow.systemcode + "^" + GV.selectSysRow.hospital + "^" + GV.selectSysRow.systemversion + "^" + rowData.functioncode + "^" + rowData.functiondesc
      $.ajax({
        type: "POST",
        contentType: "application/x-www-form-urlencoded; charset=UTF-8",
        url: GV.proxy + "?action=funConfig&input=" + encodeURI(inpurStr),
        dateType: "json",
        success: function (result) {
          var rs = JSON.parse(result)
          if (rs.resultcode == 0) {
            //$('#functiinList').window('close');
            GV.funTg.reload()
            GV.dicApplyEditRow = undefined
            $.messager.alert("提示", rs.resultcontent, 'info');
          } else {
            $.messager.alert("错误", rs.resultcontent);
            GV.funTg.beginEdit(GV.dicApplyEditRow)
          }
        }
      })
    },
    toolbar: "#funToolbar",
    onLoadSuccess: function (data) {
      GV.dataTotal = data.total
    }
  })
  $('#functionConfig').css('display', 'block')
  // 打开模态框
  $("#functionConfig").window('open')

}

// 新增功能
function addFun () {
  //var pageNo = GV.funTg.options().pageNumber;//当前页码
  var pageNo = $("#functiinList").datagrid('options').pageNumber;//当前页码
  var pageSize = GV.funTg.options().pageSize; //每页数据条数
  //每页实际数据量
  var pageDataSize = (GV.dataTotal - (pageNo - 1) * pageSize > pageSize) ? pageSize : (GV.dataTotal - (pageNo - 1) * pageSize > pageSize)
  if (GV.dicApplyEditRow != undefined) {
    if (pageNo != GV.tbPageNo) {
      rejectEdit();
    } else {
      if (GV.funTg.getRows().length > pageDataSize) {
        $.messager.alert('提醒', '请先保存当前编辑行之后再进行增加行操作', 'info')
      } else {
        rejectEdit();
      }
    }
  } else {
    GV.editType = 'add'
    var insertObj = { index: 0, row: { functioncode: "", functiondesc: "" } }
    GV.dicApplyEditRow = 0
    GV.funTg.insertRow(insertObj)
    GV.funTg.selectRow(GV.dicApplyEditRow)
    GV.funTg.beginEdit(GV.dicApplyEditRow)
    GV.tbPageNo = pageNo
    setFunDefaultPropties("functiinList", GV.dicApplyEditRow, GV.editType)
  }

}
// 编辑功能
function editFun () {
  var selectRow = GV.funTg.getSelected()
  if (selectRow == undefined) {
    $.message.alert('提示', '请先选择要编辑的功能', 'info')
  } else {
    var rowIndex = GV.funTg.getRowIndex(selectRow);
    GV.funTg.beginEdit(rowIndex)
    GV.dicApplyEditRow = rowIndex
    GV.editType = "edit"
    setFunDefaultPropties("functiinList", GV.dicApplyEditRow, GV.editType)
  }
}
// 取消编辑
function rejectEdit () {
  GV.dicApplyEditRow = undefined
  GV.funTg.rejectChanges()
  GV.funTg.clearSelections();
}
// 保存功能
function saveFun () {
  GV.funTg.endEdit(GV.dicApplyEditRow)
}
// 删除功能
function delFun () {
  var selectRow = GV.funTg.getSelected()
  if (selectRow == undefined) {
    $.message.alert('提示', '请先选择要删除的功能', 'info')
  } else {
    var selectRow = GV.funTg.getSelected()
    var inpurStr = 'del|' + GV.selectSysRow.systemcode + "^" + GV.selectSysRow.hospital + "^" + GV.selectSysRow.systemversion + "^" + selectRow.functioncode + "^" + selectRow.functiondesc
    $.ajax({
      type: "POST",
      contentType: "application/x-www-form-urlencoded; charset=UTF-8",
      url: GV.proxy + "?action=funConfig&input=" + encodeURI(inpurStr),
      dateType: "json",
      success: function (result) {
        var rs = JSON.parse(result)
        if (rs.resultcode == 0) {
          //$('#functiinList').window('close');
          //GV.funTg.reload()
          GV.funTg.reload()
          $.messager.alert("提示", rs.resultcontent, 'info');
        } else {
          $.messager.alert("错误", rs.resultcontent);
        }
      }
    })
  }
}


//设置默认属性
function setFunDefaultPropties (id, index, editFlag) {
  var eds = $('#' + id).datagrid('getEditors', index);
  //console.log("eds",eds);	
  var len = eds.length;
  for (var i = 0; i < len; i++) {
    if (eds[i].field == 'functioncode') {
      if (editFlag == "add") {
        $(eds[i].target).attr('disabled', false);
      } else {
        $(eds[i].target).attr('disabled', true);
      }
    }
  }
}




//初始化模态框
function modalInit () {

  // 初始化新增编辑模式
  $("#cfgSysModel").combobox({
    valueField: 'code',
    textField: 'desc',
    required: true,
    data: [{ code: '分库', desc: '分库' }, { code: '共库', desc: '共库' }],
  })

  // 初始化系统描述
  $("#sysDesc").combobox({
    valueField: 'desc',
    textField: 'desc',
    defaultFilter: 2,
    url: GV.proxy + "?action=SystemList"
  })


  //获取 [所属产品组] 产品组数据
  //https://114.242.246.243:1443/imedical/web/csp/web.DHCENS.STBLL.MANAGE.Proxy.loadPage.cls?action=WorkGroupDict
  commonAjax(GV.proxy, {
    action: "WorkGroupDict",
    input: "enable"
  }, "", function (production) {
    GV.productList = production
    $("#cfgProduction").combobox({
      valueField: 'code',
      textField: 'desc',
      data: production,
      defaultFilter: 2
    })
  })



  // 初始化 [所属院区]
  //https://114.242.246.243:1443/imedical/web/csp/web.DHCENS.STBLL.MANAGE.Proxy.loadPage.cls?action=HospitalDict
  commonAjax(GV.proxy, {
    action: "HospitalDict",
    input: "enable"
  }, "", function (yard) {
    GV.courtyard = yard
    // 初始化院区-查询
    $("#courtyard").combobox({
      valueField: 'code',
      textField: 'desc',
      data: yard,
      defaultFilter: 2
    })
  })

  /* 初始化系统代码 */
  $("#cfgSysCode").combobox({
    valueField: 'code',
    textField: 'code',
    editable: true,
    defaultFilter: 2,
    url: GV.proxy + "?action=EnsSystemList",
    onSelect: function (record) {
      //var cfgSysCode = $(this).combobox('getValue')
      $("#cfgSysDesc").val(record.desc)
      $("#cfgSysDesc").validatebox("validate");
    }

  });



  //初始化导入模态框
  $("#importDig").dialog({
    buttons: [{
      id: 'confirm',
      text: '确定',
      handler: function () {
        var files = $('#file').filebox('files');
        if (files && files.length > 0) {
          $('#pBar').parent().show();
          $('#pBar').progressbar({ value: 0 });
          $('#pBar').progressbar('setValue', 0);
          $('#confirm').linkbutton('disable');
        }
        common.transExcelData(files, importData);
      }
    }, {
      text: '取消',
      handler: function () { $HUI.dialog('#importDig').close(); }
    }]
  })


  //初始化新增|编辑模态框

  $("#addOrEditDiag").window({
    title: '新增',
    width: 600,
    height: 340,
    iconCls: 'icon-add',
    modal: true,
    closed: true,
    onBeforeOpen: function () {
      //$("#dept").combobox("clear")
      //$("#cfgcourtyard").combobox("clear")
      $("#cfgcourtyard").combobox("validate");
    },
    onClose: function () {//面板关闭之后触发
      $("#configForm")[0].reset()
      //重置系统代码
      $("#cfgSysCode").combobox("enable");
      $("#cfgSysCode").combobox("setValue", '');
      $("#cfgSysCode").combobox("validate");
      //重置系统描述
      $("#cfgSysDesc").validatebox("validate");
      //$("#cfgSysDesc").attr("readonly", true);
      //$("#cfgSysDesc").attr("disabled", true);
      //重置模式 
      $("#cfgSysModel").combobox("clear");
      $("#cfgSysModel").combobox("validate");
      //重置产品组 
      //重置版本
      //重置状态
      $("#cfgStatus").switchbox('setValue', true);
      //重置科室
      //$("#dept").combobox("setValue", '');
      // $("#dept").combobox("clear");
      // 重置所属院区
      //$("#cfgcourtyard").combobox("clear");
      // $("#cfgcourtyard").combobox("validate");
      initYard("", "")
      initDept("", "")
    }
  })
  initYard("", "")
  initDept("", "")
}

function initYard (dept, oldYard) {
  // 初始化院区-新增|编辑
  $("#cfgcourtyard").combobox({
    valueField: 'code',
    textField: 'desc',
    defaultFilter: 2,
    url: GV.proxy + "?action=HospitalDict&input=" + dept,
    onSelect: function (newVal, oldVal) {
      // var yard = $(this).combobox('getValue')
      var oldDept = $("#dept").combobox("getValues")
      initDept(newVal.code, oldDept)
    },
    onLoadSuccess: function () {
      $("#cfgcourtyard").combobox("setValue", oldYard)
    }
  })
}


function initDept (yard, oldDept) {
  $("#dept").combobox({
    valueField: 'code',
    textField: 'desc',
    multiple: true,
    rowStyle: 'checkbox', //显示成勾选行形式
    selectOnNavigation: false,
    panelHeight: 200,
    editable: true,
    defaultFilter: 2,
    url: GV.proxy + "?action=CTLocList&input=" + yard,
    allSelectButtonPosition: "bottom",
    onChange: function (newVal, oldVal) {
      var dept = $(this).combobox('getValues')
      var oldYard = $("#cfgcourtyard").combobox("getValue")
      initYard(dept.join(","), oldYard)
    },
    /*  onAllSelectClick: function () {
       var oldYard = $("#cfgcourtyard").combobox("getValue")
       var arr = $(this).combobox("getValues")
       var inputStr =""
       var len=arr.length
       if(len!=0){
         inputStr = len==1?arr[len-1]:(arr[0] + "," + arr[len-1])
          
       }
       initYard(inputStr, oldYard)
     }, */
    onLoadSuccess: function () {
      $("#dept").combobox("setValues", oldDept)
    }
  });
}





//查询
function cfgSearch () {
  // 获取查询参数
  var sysDesc = $("#sysDesc").combobox('getValue')
  var courtyard = $("#courtyard").combobox('getValue')
  var model = $("#model").combobox('getValue')
  var status = $("#status").combobox('getValue')
  var input = sysDesc + "^" + courtyard + "^" + model + "^" + status
  GV.tb.reload({ input: input })
}

// 新增
function cfgAdd () {
  $('#addOrEditDiag').css('display', 'block')
  $('#addOrEditDiag').window({
    iconCls: 'icon-add',
    title: '新增',
  }).dialog('open');
}

// 编辑
function cfgUpdate () {
  $('#addOrEditDiag').css('display', 'block')
  var row = GV.tb.getSelected();
  if (row) {
    $('#addOrEditDiag').window({
      iconCls: 'icon-edit',
      title: '编辑',
    }).dialog('open');
    //赋值   
    $("#cfgSysCode").combobox('setValue', row.systemcode)
    $("#cfgSysCode").combobox("disable")
    $("#cfgSysDesc").val(row.systemdesc)
    //$("#cfgSysDesc").val(row.systemcode)
    //$("#cfgSysDesc").attr("disabled", true)
    //$("#cfgSysDesc").attr("readonly", true)
    $("#dept").combobox('setValues', row.deptcode.split(','))
    $("#cfgSysVersion").val(row.systemversion)
    $("#cfgcourtyard").combobox('setValue', row.hospital);
    $("#cfgSysModel").combobox('setValue', row.systemmode);

    $("#cfgProduction").combobox('setValue', row.workgroup);
    $("#cfgStatus").switchbox('setValue', row.status == "Y" ? true : false);
    $("#cfgSysCode").combobox("validate");
    $("#cfgSysDesc").validatebox("validate");
    $("#cfgSysModel").combobox("validate");
    $("#cfgcourtyard").combobox("validate");
  } else {
    $.messager.alert("错误", "请选择行");
  }
}

// 刷新
function cfgReload () {
  GV.tb.reload();
}

// 导入
function cfgImport () {
  $('#importDiag').dialog('open')
}
/*************导入-start******************/
//表格-导入(显示模态框)
showImportWin = function () {
  //清空File域
  $('#fileArea').empty();
  $('<input id="file" class="hisui-filebox" name="file"/>').appendTo('#fileArea');
  $('#file').filebox({
    width: 400,
    buttonText: '选择',
    buttonIcon: 'icon-folder',
    prompt: '请选择excel文件',
    accept: '.xml,application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,text/csv',
    onChange: function (fileName) {
      $("#confirm").linkbutton('enable');
    }
  });
  $("#confirm").linkbutton('disable');
  //$('#importDig').css('display','block');
  $('#importDig').dialog('open');

}

//表格-导入（导入数据（excel）
importData = function (json) {
  //row:{上报状态: "未上报", 统计开始日期: "2019-07-25", 统计结束日期: "2019-07-25", 数学: "78", 语文: "89",??…}
  //数据格式转换
  function transrow (row) {
    var newrow = {};
    for (var title in GV.titlefield) {
      if (title.indexOf("日期") > -1) {
        //导出的那个表日期会转成m/d/yy 格式 奇怪  
        //可将xlsx.core中 e[14] = "m/d/yy"; 改为 e[14] = "YYYY-MM-DD"; 解决  
        //但对里面代码理解不深 先不改他 在此处做下修正 由于年份只保留了两位 先认定 40~99 为1940~1999 00~39为2000~2039
        var str = row[title] || "";
        var arr = str.split("/");
        if (arr.length == 3) {
          var m = arr[0];
          var d = arr[1];
          var y = arr[2];
          if (y.length == 2) {  //yy格式的
            if (y < 40) {
              y = "20" + y;
            } else {
              y = "19" + y;
            }
          }
          str = y + "-" + m + "-" + d;
        }
        newrow[GV.titlefield[title]] = str;
      } else if ((title.indexOf("最后更新人") > -1) && (typeof (row[title]) == "undefined")) {
        newrow[GV.titlefield[title]] = GV.User;
      } else {
        newrow[GV.titlefield[title]] = row[title] || "";
      }
    }
    return newrow;
  }
  // 将读到的结果保存到后台，调用后台方法(所有的json对象数组，起始位置，每次保存的数量)
  function submitRows (allrows, start, limit) {
    var data = '', cnt = 0, dataArr = [];
    for (var i = start, len = allrows.length; i < len && i < start + limit; i++) {
      dataArr[cnt] = allrows[i];
      cnt++;
    }
    data = JSON.stringify(dataArr);
    //data数据：[{"DRRDReport":"未上报","DRRDSPStartDate":"2019-07-25","DRRDSPEndDate":"2019-07-25","Math":"78","Chinese":"89","sex":"男","name":"邓超","age":"42","sequence":"60","number":"1001","StCourseEnglish":"10"},{"DRRDReport":"未上报","DRRDSPStartDate":"2019-07-26","DRRDSPEndDate":"2019-07-26","Math":"12","Chinese":"12","sex":"男","name":"陈赫","age":"38","sequence":"63","number":"1002","StCourseEnglish":"12"}]
    //inputJson={tableId:GV.modalId,dataArr:dataArr};
    //inputJsonStr=JSON.stringify(inputJson);
    if (cnt > 0) {
      $.post($URL + "drms.Entity.Method.DRReportDataDetail/ExcelImportTable", { startC: start, tableId: GV.modalId, DataStrs: data }, null, "json").done(function (rtn) {
        for (var i = 0; i < rtn.info.length; i++) {
          result.info.push(rtn.info[i]);
        }
        result.fail += rtn.fail;
        result.total += rtn.total;
        submitRows(allrows, start + cnt, limit);
        var percent = 10 + Math.floor(90 * (start + cnt) / allrows.length);
        $('#pBar').progressbar('setValue', percent);
      })
    } else {
      showImportResult(result);
    }
  }
  //显示导入结果
  function showImportResult (result) {
    alert("")
    var html = "<div>导入总数:&nbsp;" + result.total + "&nbsp;&nbsp;&nbsp;&nbsp;成功:&nbsp;" + (result.total - result.fail) + "&nbsp;&nbsp;&nbsp;&nbsp;失败:&nbsp;" + result.fail + "</div>"
    html += "<table style='width:100%;'><tr><td>序号</td><td>错误代码</td><td>错误原因</td></tr>",
      success = true,
      cnt = 0;
    if (result.fail == 0) {
      //全部成功
      $.messager.alert('成功', '全部导入成功', 'info');
      GV.tg.reload();
    } else {
      success = false;
      //部分成功或者全部失败
      for (var i = 0; i < result.fail; i++) {
        cnt++;
        var tr = "<tr><td>" + cnt + "</td><td>" + result.info[i].code + "</td><td>" + result.info[i].desc + "</td></tr>";
        html += tr;
      }
      html += "</table>";
    }
    $('#importDig').dialog('close');
    $('#pBar').parent().hide();
    $('#pBar').progressbar('setValue', 0);
    $("#importDig").find(".dialog-button .l-btn").eq(0).linkbutton('enable');
    if (!success) {
      GV.tg.reload();
      if ($('#importResultWin').length == 0) $('<div id="importResultWin"></div>').appendTo('body');
      $('#importResultWin').dialog({
        title: '导入错误列表',
        //width:1000,
        //height:400,
        fit: true,
        content: html
      }).dialog('open');
    }
  }

  var allrows = [], result = {};
  result.info = [], result.total = 0, result.fail = 0;
  // 将多层的json转换成数组
  for (var i in json) {  //循环文件 
    var sheetrows = json[i][0];
    var newsheetrow = [];
    var len = sheetrows.length;
    for (var j = 0; j < len; j++) {
      newsheetrow[j] = {};
      for (var item in sheetrows[j]) {
        var value = sheetrows[j][item].replace(/(^\s*)|(\s*$)/g, "");
        var newItem = item.replace(/(^\s*)|(\s*$)/g, "");
        /*if((newItem.indexOf('更新人')>-1)&&(value=='')){
        value=GV.User;
      } */
        newsheetrow[j][newItem] = value;
      }
      // 将读到的每一行转换成对象组成的数组
      allrows.push(transrow(newsheetrow[j]));
    }
  }
  $('#pBar').progressbar('setValue', 10);
  // 每一百条调用一次后台方法进行保存
  submitRows(allrows, 0, 5);
}


/***************导入-end***************/



$(function () {
  modalInit()
  loadTable()
})