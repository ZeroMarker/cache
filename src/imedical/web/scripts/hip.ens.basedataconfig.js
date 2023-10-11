var GV = {}
//GV.proxy = "web.DHCENS.STBLL.Method.SystemStatusConfigMvc.cls?";
GV.proxy = "web.DHCENS.STBLL.MANAGE.Proxy.loadPage.cls"
GV.dicApplyEditRow = undefined
GV.tbPageNo = 1;  //��ǰҳ��
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

//�����б�
function loadTable () {
  GV.tb = $HUI.datagrid('#mtSourceTb', {
    fit: true,
    headerCls: 'panel-header-gray',
    //rownumbers: true,
    singleSelect: true,
    pagination: true,
    // title: 'ҽ��ϵͳ��Դ�ֵ��',
    idField: 'id',
    pageSize: 20,
    pageList: [20, 40, 60, 80, 100],
    afterPageText: 'ҳ,��{pages}ҳ', beforePageText: '��', displayMsg: '��ʾ{from}��{to}������{total}��',
    fitColumns: true,
    //autoSizeColumn: false,
    url: GV.proxy + "?action=QuerySystemConfig",
    columns: [[
      { field: 'systemcode', title: 'ϵͳ����', width: 150 },
      { field: 'systemdesc', title: 'ϵͳ����', width: 150 },
      { field: 'systemversion', title: '�汾', width: 150 },
      {
        field: 'hospital', title: 'Ժ��', width: 300,
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
        field: 'deptdesc', title: '����', width: 200, /* showTip: true, tipWidth: 200,  formatter: function (value, row, index) {
          return '<a href="#" title="' + row.deptdesc + '" class="hisui-tooltip deptTips"  style="color: black;text-decoration: none;">' + row.deptdesc + '</a>'
        } */
      },
      { field: 'systemmode', title: 'ģʽ', width: 150 },
      {
        field: 'workgroup', title: '��Ʒ��', width: 200,
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
        field: 'status', title: '״̬', width: 150,
        formatter: function (value, row, index) {
          var val = value == "Y" ? true : false
          var dataoptions = "onText:'����',offText:'ͣ��',size:'small',animated:true,onClass:'primary',offClass:'gray',checked:" + val
          var str = '<div class="hisui-switchbox tabSwitch" data-options="' + dataoptions + '"></div>'
          return str
        }
      },
      {
        field: 'cc', title: '����', width: 100, formatter: function (value, row, index) {
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
          // ϵͳ����^Ժ��^�汾^ϵͳ״̬
          //var inpurStr =  + "^" + rowData.hospital + "^" + rowData.systemversion + "^" + obj.value
          var status = obj.value ? 'Y' : 'N'
          var inputStr = rowData.systemcode + "^" + rowData.systemdesc
            + "^" + rowData.systemversion + "^"
            + rowData.hospital + "^" +
            rowData.systemmode + "^" +
            rowData.workgroup + "^" + status + "^" + JSON.stringify(rowData.deptcode.split(','))
          //ajax���ü��ط���
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
                $.messager.alert("����", rs.retinfo);
              }
            }
          })

        }
      })
      $(".funConfig").linkbutton({ iconCls: 'icon-batch-cfg', plain: true });
    }
  });
}

//��������
function addConfig () {
  //��������
  var cfgSysCode = $("#cfgSysCode").combobox("getValue")
  if (!cfgSysCode) {
    $.messager.alert('��ʾ', 'ϵͳ���벻��Ϊ��', 'info');
    return false
  }



  var cfgSysDesc = $('input[name="cfgSysDesc"]').val()
  if (!cfgSysDesc) {
    $.messager.alert('��ʾ', 'ϵͳ��������Ϊ��', 'info');
    return false
  }
  var cfgSysVersion = $('input[name="cfgSysVersion"]').val()
  var cfgcourtyard = $('#cfgcourtyard').combobox('getValue')
  if (!cfgcourtyard) {
    $.messager.alert('��ʾ', 'Ժ������Ϊ��', 'info');
    return false
  }

  var dept = $("#dept").combobox('getValues')
  dept = JSON.stringify(dept)
  if (!dept) {
    $.messager.alert('��ʾ', '���Ҳ���Ϊ��', 'info');
    return false
  }
  /* ģʽ */
  var cfgModel = $("#cfgSysModel").combobox("getValue")
  if (!cfgModel) {
    $.messager.alert('��ʾ', 'ģʽ����Ϊ��', 'info');
    return false
  }

  var cfgProduction = $('#cfgProduction').combobox('getValue')
  var status = $("#cfgStatus").switchbox('getValue') ? 'Y' : 'N'

  //inpurStr = cfgSysCode + "^" + cfgSysDesc + "^" + cfgSysVersion + "^" + cfgcourtyard + "^" + cfgProduction + "^" + status + "^" + dept
  // ϵͳ����^ϵͳ����^�汾^Ժ��^ģʽ^��Ʒ��^״̬^���Ҵ���
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
        $.messager.alert("����", rs.retinfo);
      }
    }
  })
}
/* ȡ������ */
function cancel () {
  $('#addOrEditDiag').window('close');
}


//��ʾ����ά��ģ̬��
function showFunConfig (index) {
  GV.tb.selectRow(index)
  //��ȡѡ����
  GV.selectSysRow = $("#mtSourceTb").datagrid('getSelected')
  //���ع����б�
  //GV.funTg =$("#functiinList").datagrid({
  GV.funTg = $HUI.datagrid("#functiinList", {
    fit: true,
    height: 400,
    headerCls: 'panel-header-gray',
    //rownumbers: true,
    singleSelect: true,
    pagination: true,
    //fixRowNumber: true,
    // title: 'ҽ��ϵͳ��Դ�ֵ��',
    idField: 'id',
    pageSize: 10,
    pageList: [5, 10, 15, 20, 25, 30, 50, 75, 100],
    afterPageText: 'ҳ,��{pages}ҳ', beforePageText: '��', displayMsg: '��ʾ{from}��{to}������{total}��',
    fitColumns: true,
    autoSizeColumn: false,
    url: GV.proxy + "?action=QuerySysFunction&input=" + GV.selectSysRow.systemcode + "^" + GV.selectSysRow.hospital + "^" + GV.selectSysRow.systemversion,
    columns: [[
      { field: 'functioncode', title: '���ܴ���', width: 200, editor: { type: 'text' } },
      { field: 'functiondesc', title: '��������', width: 200, editor: { type: 'text' } },
    ]],
    //�������¼�
    onClickRow: function (index, row) {
      if (GV.dicApplyEditRow != undefined) {
        rejectEdit();
        GV.funTg.selectRow(index);
      }
    },
    onAfterEdit: function (rowIndex, rowData, changes) {//����|����
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
            $.messager.alert("��ʾ", rs.resultcontent, 'info');
          } else {
            $.messager.alert("����", rs.resultcontent);
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
  // ��ģ̬��
  $("#functionConfig").window('open')

}

// ��������
function addFun () {
  //var pageNo = GV.funTg.options().pageNumber;//��ǰҳ��
  var pageNo = $("#functiinList").datagrid('options').pageNumber;//��ǰҳ��
  var pageSize = GV.funTg.options().pageSize; //ÿҳ��������
  //ÿҳʵ��������
  var pageDataSize = (GV.dataTotal - (pageNo - 1) * pageSize > pageSize) ? pageSize : (GV.dataTotal - (pageNo - 1) * pageSize > pageSize)
  if (GV.dicApplyEditRow != undefined) {
    if (pageNo != GV.tbPageNo) {
      rejectEdit();
    } else {
      if (GV.funTg.getRows().length > pageDataSize) {
        $.messager.alert('����', '���ȱ��浱ǰ�༭��֮���ٽ��������в���', 'info')
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
// �༭����
function editFun () {
  var selectRow = GV.funTg.getSelected()
  if (selectRow == undefined) {
    $.message.alert('��ʾ', '����ѡ��Ҫ�༭�Ĺ���', 'info')
  } else {
    var rowIndex = GV.funTg.getRowIndex(selectRow);
    GV.funTg.beginEdit(rowIndex)
    GV.dicApplyEditRow = rowIndex
    GV.editType = "edit"
    setFunDefaultPropties("functiinList", GV.dicApplyEditRow, GV.editType)
  }
}
// ȡ���༭
function rejectEdit () {
  GV.dicApplyEditRow = undefined
  GV.funTg.rejectChanges()
  GV.funTg.clearSelections();
}
// ���湦��
function saveFun () {
  GV.funTg.endEdit(GV.dicApplyEditRow)
}
// ɾ������
function delFun () {
  var selectRow = GV.funTg.getSelected()
  if (selectRow == undefined) {
    $.message.alert('��ʾ', '����ѡ��Ҫɾ���Ĺ���', 'info')
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
          $.messager.alert("��ʾ", rs.resultcontent, 'info');
        } else {
          $.messager.alert("����", rs.resultcontent);
        }
      }
    })
  }
}


//����Ĭ������
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




//��ʼ��ģ̬��
function modalInit () {

  // ��ʼ�������༭ģʽ
  $("#cfgSysModel").combobox({
    valueField: 'code',
    textField: 'desc',
    required: true,
    data: [{ code: '�ֿ�', desc: '�ֿ�' }, { code: '����', desc: '����' }],
  })

  // ��ʼ��ϵͳ����
  $("#sysDesc").combobox({
    valueField: 'desc',
    textField: 'desc',
    defaultFilter: 2,
    url: GV.proxy + "?action=SystemList"
  })


  //��ȡ [������Ʒ��] ��Ʒ������
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



  // ��ʼ�� [����Ժ��]
  //https://114.242.246.243:1443/imedical/web/csp/web.DHCENS.STBLL.MANAGE.Proxy.loadPage.cls?action=HospitalDict
  commonAjax(GV.proxy, {
    action: "HospitalDict",
    input: "enable"
  }, "", function (yard) {
    GV.courtyard = yard
    // ��ʼ��Ժ��-��ѯ
    $("#courtyard").combobox({
      valueField: 'code',
      textField: 'desc',
      data: yard,
      defaultFilter: 2
    })
  })

  /* ��ʼ��ϵͳ���� */
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



  //��ʼ������ģ̬��
  $("#importDig").dialog({
    buttons: [{
      id: 'confirm',
      text: 'ȷ��',
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
      text: 'ȡ��',
      handler: function () { $HUI.dialog('#importDig').close(); }
    }]
  })


  //��ʼ������|�༭ģ̬��

  $("#addOrEditDiag").window({
    title: '����',
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
    onClose: function () {//���ر�֮�󴥷�
      $("#configForm")[0].reset()
      //����ϵͳ����
      $("#cfgSysCode").combobox("enable");
      $("#cfgSysCode").combobox("setValue", '');
      $("#cfgSysCode").combobox("validate");
      //����ϵͳ����
      $("#cfgSysDesc").validatebox("validate");
      //$("#cfgSysDesc").attr("readonly", true);
      //$("#cfgSysDesc").attr("disabled", true);
      //����ģʽ 
      $("#cfgSysModel").combobox("clear");
      $("#cfgSysModel").combobox("validate");
      //���ò�Ʒ�� 
      //���ð汾
      //����״̬
      $("#cfgStatus").switchbox('setValue', true);
      //���ÿ���
      //$("#dept").combobox("setValue", '');
      // $("#dept").combobox("clear");
      // ��������Ժ��
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
  // ��ʼ��Ժ��-����|�༭
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
    rowStyle: 'checkbox', //��ʾ�ɹ�ѡ����ʽ
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





//��ѯ
function cfgSearch () {
  // ��ȡ��ѯ����
  var sysDesc = $("#sysDesc").combobox('getValue')
  var courtyard = $("#courtyard").combobox('getValue')
  var model = $("#model").combobox('getValue')
  var status = $("#status").combobox('getValue')
  var input = sysDesc + "^" + courtyard + "^" + model + "^" + status
  GV.tb.reload({ input: input })
}

// ����
function cfgAdd () {
  $('#addOrEditDiag').css('display', 'block')
  $('#addOrEditDiag').window({
    iconCls: 'icon-add',
    title: '����',
  }).dialog('open');
}

// �༭
function cfgUpdate () {
  $('#addOrEditDiag').css('display', 'block')
  var row = GV.tb.getSelected();
  if (row) {
    $('#addOrEditDiag').window({
      iconCls: 'icon-edit',
      title: '�༭',
    }).dialog('open');
    //��ֵ   
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
    $.messager.alert("����", "��ѡ����");
  }
}

// ˢ��
function cfgReload () {
  GV.tb.reload();
}

// ����
function cfgImport () {
  $('#importDiag').dialog('open')
}
/*************����-start******************/
//���-����(��ʾģ̬��)
showImportWin = function () {
  //���File��
  $('#fileArea').empty();
  $('<input id="file" class="hisui-filebox" name="file"/>').appendTo('#fileArea');
  $('#file').filebox({
    width: 400,
    buttonText: 'ѡ��',
    buttonIcon: 'icon-folder',
    prompt: '��ѡ��excel�ļ�',
    accept: '.xml,application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,text/csv',
    onChange: function (fileName) {
      $("#confirm").linkbutton('enable');
    }
  });
  $("#confirm").linkbutton('disable');
  //$('#importDig').css('display','block');
  $('#importDig').dialog('open');

}

//���-���루�������ݣ�excel��
importData = function (json) {
  //row:{�ϱ�״̬: "δ�ϱ�", ͳ�ƿ�ʼ����: "2019-07-25", ͳ�ƽ�������: "2019-07-25", ��ѧ: "78", ����: "89",??��}
  //���ݸ�ʽת��
  function transrow (row) {
    var newrow = {};
    for (var title in GV.titlefield) {
      if (title.indexOf("����") > -1) {
        //�������Ǹ������ڻ�ת��m/d/yy ��ʽ ���  
        //�ɽ�xlsx.core�� e[14] = "m/d/yy"; ��Ϊ e[14] = "YYYY-MM-DD"; ���  
        //�������������ⲻ�� �Ȳ����� �ڴ˴��������� �������ֻ��������λ ���϶� 40~99 Ϊ1940~1999 00~39Ϊ2000~2039
        var str = row[title] || "";
        var arr = str.split("/");
        if (arr.length == 3) {
          var m = arr[0];
          var d = arr[1];
          var y = arr[2];
          if (y.length == 2) {  //yy��ʽ��
            if (y < 40) {
              y = "20" + y;
            } else {
              y = "19" + y;
            }
          }
          str = y + "-" + m + "-" + d;
        }
        newrow[GV.titlefield[title]] = str;
      } else if ((title.indexOf("��������") > -1) && (typeof (row[title]) == "undefined")) {
        newrow[GV.titlefield[title]] = GV.User;
      } else {
        newrow[GV.titlefield[title]] = row[title] || "";
      }
    }
    return newrow;
  }
  // �������Ľ�����浽��̨�����ú�̨����(���е�json�������飬��ʼλ�ã�ÿ�α��������)
  function submitRows (allrows, start, limit) {
    var data = '', cnt = 0, dataArr = [];
    for (var i = start, len = allrows.length; i < len && i < start + limit; i++) {
      dataArr[cnt] = allrows[i];
      cnt++;
    }
    data = JSON.stringify(dataArr);
    //data���ݣ�[{"DRRDReport":"δ�ϱ�","DRRDSPStartDate":"2019-07-25","DRRDSPEndDate":"2019-07-25","Math":"78","Chinese":"89","sex":"��","name":"�˳�","age":"42","sequence":"60","number":"1001","StCourseEnglish":"10"},{"DRRDReport":"δ�ϱ�","DRRDSPStartDate":"2019-07-26","DRRDSPEndDate":"2019-07-26","Math":"12","Chinese":"12","sex":"��","name":"�º�","age":"38","sequence":"63","number":"1002","StCourseEnglish":"12"}]
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
  //��ʾ������
  function showImportResult (result) {
    alert("")
    var html = "<div>��������:&nbsp;" + result.total + "&nbsp;&nbsp;&nbsp;&nbsp;�ɹ�:&nbsp;" + (result.total - result.fail) + "&nbsp;&nbsp;&nbsp;&nbsp;ʧ��:&nbsp;" + result.fail + "</div>"
    html += "<table style='width:100%;'><tr><td>���</td><td>�������</td><td>����ԭ��</td></tr>",
      success = true,
      cnt = 0;
    if (result.fail == 0) {
      //ȫ���ɹ�
      $.messager.alert('�ɹ�', 'ȫ������ɹ�', 'info');
      GV.tg.reload();
    } else {
      success = false;
      //���ֳɹ�����ȫ��ʧ��
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
        title: '��������б�',
        //width:1000,
        //height:400,
        fit: true,
        content: html
      }).dialog('open');
    }
  }

  var allrows = [], result = {};
  result.info = [], result.total = 0, result.fail = 0;
  // ������jsonת��������
  for (var i in json) {  //ѭ���ļ� 
    var sheetrows = json[i][0];
    var newsheetrow = [];
    var len = sheetrows.length;
    for (var j = 0; j < len; j++) {
      newsheetrow[j] = {};
      for (var item in sheetrows[j]) {
        var value = sheetrows[j][item].replace(/(^\s*)|(\s*$)/g, "");
        var newItem = item.replace(/(^\s*)|(\s*$)/g, "");
        /*if((newItem.indexOf('������')>-1)&&(value=='')){
        value=GV.User;
      } */
        newsheetrow[j][newItem] = value;
      }
      // ��������ÿһ��ת���ɶ�����ɵ�����
      allrows.push(transrow(newsheetrow[j]));
    }
  }
  $('#pBar').progressbar('setValue', 10);
  // ÿһ��������һ�κ�̨�������б���
  submitRows(allrows, 0, 5);
}


/***************����-end***************/



$(function () {
  modalInit()
  loadTable()
})