var eventStatus = "";
var arrayObj = new Array();
var d = new Dictionary();
var outputNote = "";
var typeStatus = "";
var GV = {}
GV.proxy = 'web.DHCENS.STBLL.UTIL.PageLoad.cls'
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

//���ط����б�
function loadEnsInterfaceMethod () {
  $('#methodListDg').datagrid({
    //title:'�����б�',
    pagination: true,
    afterPageText: 'ҳ,��{pages}ҳ', beforePageText: '��', displayMsg: '��ʾ{from}��{to}������{total}��',
    fit: true,
    nowrap: false,
    fitCloumns: true,
    minimized: false,
    striped: true,
    cache: false,
    pageSize: 20,
    pageList: [20, 40, 60, 80, 100],
    method: 'get',
    url: 'web.DHCENS.STBLL.UTIL.PageLoad.cls?action=methodlist',
    singleSelect: true,
    columns: [[
      { field: 'id', title: '���', sortable: true, width: 50 },
      { field: 'code', title: '��������', sortable: true, width: 250 },
      { field: 'desc', title: '��������', width: 250 },
      { field: 'type', title: '��������', width: 100 },
      {
        field: 'productionName', title: '����Ŀ��', sortable: true, width: 300,
      },
      {
        field: 'status', title: '״̬', sortable: true, width: 100,
        formatter: function (v, rec) {
          var status = "";
          if (rec.status == "Y") {
            status = "����";
          }
          else {
            status = "ͣ��";
          }
          return status;
        }
      },
      {
        field: 'event', title: '����', align: 'left', width: 400,
        formatter: function (v, rec, index) {
          var editBtn = '<a href="#this" class="editcls" onclick="editRow(' + (rec.id) + ')">�޸�</a>';
          var deleteBtn = '<a href="#this" class="deletecls" onclick="deleteRow(' + (rec.id) + ')">ɾ��</a>';
          if (rec.status == "Y") {
            var statusBtn = '<a href="#this" class="stopcls" onclick="updateStatus(' + (rec.id) + ')">ͣ��</a>';
          }
          else {
            var statusBtn = '<a href="#this" class="startcls" onclick="updateStatus(' + (rec.id) + ')">����</a>';
          }
          var testBtn = '<a href="#this" class="testcls" onclick="testRow(' + (rec.id) + ',' + index + ')">����</a>';
          var viewBtn = '<a href="#this" class="viewcls" onclick="viewDoc(' + (rec.id) + ',' + index + ')"></a>';
          return editBtn + " " + deleteBtn + " " + statusBtn + " " + testBtn + " " + viewBtn;
          //return editBtn+" "+deleteBtn+" "+statusBtn;
        }
      }
    ]],
    toolbar: "#toolbar",
    rowStyler: function (index, row) {
      if (row.status == 'N') {
        return 'background-color:#6293BB;color:#fff;';
      }
    },
    view: detailview,
    detailFormatter: function (rowIndex, rowData) {
      return "<div id='detailDiv" + rowIndex + "' style='color:black;height:auto;'><div/>";
    },
    onExpandRow: function (index, row) {
      loadDetailView(row.id, index);
    },
    onLoadSuccess: function (data) {
      $('.editcls').linkbutton({ text: '�༭', plain: true, iconCls: 'icon-edit' });
      $('.deletecls').linkbutton({ text: 'ɾ��', plain: true, iconCls: 'icon-cancel' });
      $('.testcls').linkbutton({ text: '����', plain: true, iconCls: 'icon-ok' });
      $('.stopcls').linkbutton({ text: 'ͣ��', plain: true, iconCls: 'icon-lock' });
      $('.startcls').linkbutton({ text: '����', plain: true, iconCls: 'icon-lock' });
      $('.viewcls').linkbutton({ text: '', plain: true, iconCls: 'icon-search' });

      /*  $(".targetTips").tooltip({
         position: 'right', onShow: function () {
           $(this).tooltip('tip').css({
             backgroundColor: '#666',
             borderColor: '#666',
             width: 200
           });
         }
       }) */

      // �б�һ�и����ж���
      //$('td[field="_expander"] div').css('padding-top','2');
      $('td[field="_expander"] div').css('padding-right', '0');
      //$('td[field="_expander"] div').css('margin-top','1');
      // $('td[field="_expander"] div').css('margin-bottom','1');
      // ������֮�����
      //$('#divMethodListDg  div[class="datagrid-body"] table tr td[field="desc"] div').css('height','18');
      // $('#divMethodListDg  div[class="datagrid-body"] table tr ').css('height','27');
      /* var totalWidth = 0;
      var columns = $("#methodListDg").datagrid("options").columns[0];
      for (var i = 0; i < columns.length; i++) {
        totalWidth += columns[i].width+10;
      }
      $($(".datagrid-header-inner")[0]).css("width", totalWidth);
      $(".datagrid-footer-inner").css("width", totalWidth); */
    }
  })

}

function Dictionary () {
  this.data = new Array();
  this.put = function (key, value) {
    this.data[key] = value;
  };
  this.get = function (key) {
    return this.data[key];
  };
  this.remove = function (key) {
    this.data[key] = null;
  };
  this.isEmpty = function () {
    return this.data.length == 0;
  };
  this.size = function () {
    return this.data.length;
  };
}

function loadDetailView (id, index) {
  var detailHtml = "";
  $.ajax({
    type: "get",
    url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=expandMethodDetail&input=" + id,
    dataType: "json",
    success: function (data) {
      var detailHtml = "<table style='width:750px;color:blue;font-size:12px;font-weight:bold;'>";
      $.each(data, function (i, list) {
        if (list.methodType == "classMethod") {
          detailHtml += "<tr><td>���÷�����" + list.methodPublishClassName + "</td></tr>";
        }
        else {
          detailHtml += "<tr><td>wsdl��ַ��" + list.wsdlAddress + "</td></tr>";
          detailHtml += "<tr><td>�������ƣ�DHCWebInterface(KeyName As %String, input1 As %GlobalCharacterStream)</td></tr>";
          //detailHtml+="<tr><td>��θ�ʽ������KeyName:�¼�����,InputParameter:��ϸ����</td></tr>";
        }
        detailHtml += "<tr><td>��θ�ʽ������" + list.methodInputDesc + "</td></tr>";
        detailHtml += "<tr><td>����ֵ��" + list.methodOutputDesc + "</td></tr>";
        detailHtml += "<tr><td>����������" + list.methodDesc + "</td></tr>";
        detailHtml += "<tr><td>��ע��" + list.methodNote + "</td></tr>";
      });
      detailHtml += "</table>";
      $('#detailDiv' + index).html(detailHtml);
      $('#methodListDg').datagrid('fixDetailRowHeight', index);
    }
  })
}
function editRow (id) {
  eventStatus = "update";
  $('#methodDataCancleBtn').linkbutton('disable');
  $('#methodDataCancleBtn').attr("disabled", true);
  $('#methodInputAddBtn').attr("disabled", false);
  arrayObj = [];
  outputNote = "";
  $.ajax({
    type: "get",
    url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=methodDetail&input=" + id,
    dateType: "json",
    success: function (data) {
      GV.methodType = data.methodType
      var obj = eval('(' + data + ')');
      $('#methodCode').attr("readOnly", true);
      $('#methodDataCancleBtn').attr("disabled", true);
      $('#methodCode').val(obj.methodCode);
      var methodDesc = replaceTextarea2(obj.methodDesc);
      $('#methodDesc').val(methodDesc);
      $('#methodClassName').val(obj.methodClassName);
      $('#methodName').val(obj.methodName);
      var methodNote = replaceTextarea2(obj.methodNote);
      $('#methodNote').val(methodNote);
      $('#procuctionnameDetail').combogrid('setValues', obj.procuctionnameDetail.split(','));
      $('#methodStatus').combobox('select', obj.methodStatus);
      $('#methodType').combobox('select', obj.methodType);
      //��־��¼���
      obj.ensInterfaceFlag=="Y"?$("#ensInterfaceFlag").checkbox("setValue",true):$("#ensInterfaceFlag").checkbox("setValue",false)
      obj.hsbSyncFlag=="Y"?$("#hsbSyncFlag").checkbox("setValue",true):$("#hsbSyncFlag").checkbox("setValue",false)
     
      loadInputDetail(id);
      loadOutputDetail(id);
      $('#methodDetail').css('display', 'block');
      $('#methodDetail').window('open');

    }
  });
}

function clearDetailContent () {

  $('#methodCode').val("");
  $('#methodName').val("");
  $('#methodClassName').val("");
  $('#procuctionnameDetail').combogrid('clear');
  $('#methodStatus').combobox('setValue', 'Y');
  $("#methodType").combobox('setValue', "classMethod");
  $('textarea').val("");
  //$('#model').val("");
  //$('#methoDesc').val("");
  $('#methodNote').val("");
  $('#fileSel').filebox('clear')
}
function reLoadEnsInterfaceMethod () {
  var methodCode = $("#code").val().replace(/\ /g, "");
  var methodDesc = $("#desc").val().replace(/\ /g, "");
  var procuctionnameDetail = $('#procuctionname').combogrid('getText').replace(/\ /g, "");
  var methodStatus = $('#status').combobox('getValue');
  var methodType = $('#type').combobox('getValue');
  var selectInfo = methodCode + "^" + methodDesc + "^" + procuctionnameDetail + "^" + methodStatus + "^" + methodType;
  selectInfo = escape(selectInfo);
  $('#methodListDg').datagrid({ url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=methodlist&input=" + selectInfo, method: "get" });
  $('#methodListDg').datagrid('load');
}
function updateStatus (id) {
  $.messager.defaults = { ok: "��", cancel: "��" };
  $.messager.confirm("������ʾ", "��ȷ��Ҫִ���޸Ĳ�����", function (data) {
    if (data) {
      $.ajax({
        type: "get",
        url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=updateMethodStatus&input=" + id,
        dateType: "json",
        success: function (data) {
          var dataInfo = data.replace(/[\r\n]/g, "^")
          var arr = new Array();
          arr = dataInfo.split("^^");
          var length = arr.length
          var obj = eval('(' + arr[length - 1] + ')');
          if (obj.retvalue == "1") {
            $.messager.alert('��ʾ', '�޸ĳɹ�', "", function () {
              reLoadEnsInterfaceMethod();
            });
          }
          else {
            $.messager.alert('��ʾ', obj.retinfo);
          }
        }
      });
    } else {

    }
  });
}

function deleteRow (id) {
  $.messager.defaults = { ok: "��", cancel: "��" };
  $.messager.confirm("������ʾ", "��ȷ��Ҫִ��ɾ��������", function (data) {
    if (data) {
      $.ajax({
        type: "get",
        url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=delMethodData&input=" + id,
        dateType: "json",
        success: function (data) {
          var dataInfo = data.replace(/[\r\n]/g, "^")
          var arr = new Array();
          arr = dataInfo.split("^^");
          var length = arr.length
          var obj = eval('(' + arr[length - 1] + ')');
          if (obj.retvalue == "0") {
            $.messager.alert('��ʾ', 'ɾ���ɹ�', "", function () {
              reLoadEnsInterfaceMethod();
            });
          }
          else {
            $.messager.alert('��ʾ', obj.retinfo);
          }
        }
      });
    }
  });
}

function editinputrow (target) {
  $('#inputListDg').datagrid('beginEdit', getRowIndex(target));
}
function getRowIndex (target) {
  var tr = $(target).closest('tr.datagrid-row');
  return parseInt(tr.attr('datagrid-row-index'));
}
function updateInputActions (index) {
  $('#inputListDg').datagrid('updateRow', {
    index: index
  });
}
function cancelinputrow (target) {
  $('#inputListDg').datagrid('cancelEdit', getRowIndex(target));
}
function saveinputrow (target) {
  $('#inputListDg').datagrid('endEdit', getRowIndex(target));
}

function insertinputrow () {
  var data = $('#inputListDg').datagrid('getData');
  var index = data.total;
  /*
  var total=data.total;
  $('#inputListDg').datagrid('selectRow',total-1);
  var row = $('#inputListDg').datagrid('getSelected');
  var index=$('#inputListDg').datagrid('getRowIndex',row);
  index=index+1;
  alert(index);
  */
  $('#inputListDg').datagrid('insertRow', {
    index: index,
    row: {
      flag: 'N'
    }
  });
  //$('#inputListDg').datagrid('selectRow',index);
  $('#inputListDg').datagrid('beginEdit', index);
  //d.put(index, "��β���"+index)
  arrayObj.push("")
}
function deleteinputrow (target) {
  var index = getRowIndex(target);
  $('#inputListDg').datagrid('selectRow', getRowIndex(target));
  var row = $('#inputListDg').datagrid('getSelected');
  var type = row["type"];
  if (typeof (type) != "undefined") {
    $('#inputListDg').datagrid('deleteRow', index);
  }
  else {
    $('#inputListDg').datagrid('cancelEdit', index);
  }
  var data = $('#inputListDg').datagrid('getData');
  var total = data.total;
  for (i = index; i < total; i++) {
    arrayObj[index] = arrayObj[index + 1];
  }
  arrayObj.splice(index, 1);
  //var tVal=d.remove(index);
}
function showinputdetail (index) {
  //$('#inputListDg').datagrid('selectRow',index);
  //var row = $('#inputListDg').datagrid('getSelected');
  //var tVal=d.get(index);
  var tVal = arrayObj[index];
  typeStatus = "input";
  bindInputDescDialog(tVal);
}
function loadInputDetail (rowId) {
  $('#inputListDg').datagrid({
    nowrap: false,
    singleSelect: true,
    idField: 'code',
    method: 'Get',
    fit: true,
    fitCloumns: true,
    url: 'web.DHCENS.STBLL.UTIL.PageLoad.cls?action=inputType&input=' + rowId,
    columns: [[
      {
        field: 'type', title: '��������', width: 170,
        formatter: function (value, rowData) {
          return value;
        },
        editor: {
          id: "lookTable",
          type: 'combobox',
          options: {
            valueField: 'baseType',
            textField: 'baseType',
            method: 'get',
            url: 'web.DHCENS.STBLL.UTIL.PageLoad.cls?action=baseType'
          }
        }
      },
      {
        field: 'flag', title: '����', width: 40, align: 'center',
        editor: {
          type: 'checkbox',
          options: {
            on: 'Y',
            off: 'N'
          }
        }
      },
      { field: 'desc', title: '�ֶ�˵��', width: 230, editor: 'text' },
      // ����������
      { field: 'descHidden', title: '�ֶ�˵��', width: 135, editor: 'text', hidden: 'true' },
      {
        field: 'note', title: '��ע', width: 40, align: 'center',
        formatter: function (value, row, index) {
          var s = '<a href="#" onclick="showinputdetail(' + (index) + ')">Detail</a> ';
          return s;
        }
      },
      {
        field: 'action', title: '', width: 40, align: 'center',
        formatter: function (value, row, index) {
          var d = '<a href="#" onclick="deleteinputrow(this)">Delete</a>';
          return d;
        }
      }
    ]],
    onBeforeEdit: function (index, row) {
      row.editing = true;
      //updateInputActions(index);
    },
    onAfterEdit: function (index, row) {
      row.editing = false;
      var methodCode = $("#methodCode").val().replace(/\ /g, "");
      if (methodCode == "") {
        $.messager.alert('��ʾ', "��������Ϊ��");
        return;
      }
      //updateInputActions(index);
      bindDescTip();
    },
    onCancelEdit: function (index, row) {
      var type = row["type"];
      if (typeof (type) == "undefined") {
        $('#inputListDg').datagrid('deleteRow', index)
        return;
      }
      else {
        row.editing = false;
        //updateInputActions(index);
      }
      //bindDescTip();
    },
    onLoadSuccess: function (data) {
      bindDescTip();
      var data = $('#inputListDg').datagrid('getData');
      var total = data.total;
      for (i = 0; i < total; i++) {
        //d.put(i, "��β���"+i)
        //alert(total+":"+i);
        //row.editing = false;
        $('#inputListDg').datagrid('beginEdit', i);
        arrayObj.push(data.rows[i].descHidden)
      }
      //$.parser.parse("#methodDetail")
    }
  });
}
function insertoutputrow () {
  var data = $('#outputListDg').datagrid('getData');
  var index = data.total;
  $('#outputListDg').datagrid('insertRow', {
    index: index,
    row: {
      flag: 'N'
    }
  });
  $('#outputListDg').datagrid('selectRow', index);
  $('#outputListDg').datagrid('beginEdit', index);
  outputNote = "";
}
function editoutputrow (target) {
  $('#outputListDg').datagrid('beginEdit', getRowIndex(target));
}
function updateOutputActions (index) {
  $('#outputListDg').datagrid('updateRow', {
    index: index
  });
}
function canceloutputrow (target) {
  $('#outputListDg').datagrid('cancelEdit', getRowIndex(target));
}
function saveoutputrow (target) {
  $('#outputListDg').datagrid('endEdit', getRowIndex(target));
}
function deleteoutputrow (target) {
  var index = getRowIndex(target);
  $('#outputListDg').datagrid('selectRow', getRowIndex(target));
  var row = $('#outputListDg').datagrid('getSelected');
  var type = row["type"];
  if (typeof (type) != "undefined") {
    $('#outputListDg').datagrid('deleteRow', index);
  }
  else {
    $('#outputListDg').datagrid('cancelEdit', index);
  }
  $('#methodOutputAddBtn').attr("disabled", false);
}
function showoutputdetail (index) {
  $('#outputListDg').datagrid('selectRow', index);
  var row = $('#outputListDg').datagrid('getSelected');
  typeStatus = "output";
  bindInputDescDialog(outputNote);
}
function loadOutputDetail (rowId) {
  $('#outputListDg').datagrid({
    nowrap: false,
    singleSelect: true,
    idField: 'code',
    method: 'Get',
    fit: true,
    url: 'web.DHCENS.STBLL.UTIL.PageLoad.cls?action=outputType&input=' + rowId,
    columns: [[
      {
        field: 'type', title: '��������', width: 170,
        formatter: function (value, rowData) {
          return value;
        },
        editor: {
          id: "lookTable",
          type: 'combobox',
          options: {
            valueField: 'baseType',
            textField: 'baseType',
            method: 'get',
            url: 'web.DHCENS.STBLL.UTIL.PageLoad.cls?action=baseType'
          }
        }
      },
      { field: 'desc', title: '�ֶ�˵��', width: 260, editor: 'text' },
      // ����������
      { field: 'descHidden', title: '�ֶ�˵��', width: 135, editor: 'text', hidden: 'true' },
      {
        field: 'note', title: '��ע', width: 40, align: 'center',
        formatter: function (value, row, index) {
          var e = '<a href="#" onclick="showoutputdetail(' + (index) + ')">Detail</a> ';
          return e;
        }
      },
      {
        field: 'action', title: '', width: 40, align: 'center',
        formatter: function (value, row, index) {
          var d = '<a href="#" onclick="deleteoutputrow(this)">Delete</a>';
          return d;
        }
      }
    ]],
    onBeforeEdit: function (index, row) {
      row.editing = true;
      updateOutputActions(index);
    },
    onAfterEdit: function (index, row) {
      row.editing = false;
      $('#hiddenOutputDesc').val(row['desc']);
      var methodCode = $("#methodCode").val().replace(/\ /g, "");
      if (methodCode == "") {
        $.messager.alert('��ʾ', "��������Ϊ��");
        return;
      }
      updateOutputActions(index);
      bindOutputDescTip();
    },
    onCancelEdit: function (index, row) {
      var type = row["type"];
      $('#methodOutputAddBtn').attr("disabled", false);
      if (typeof (type) == "undefined") {
        $('#outputListDg').datagrid('deleteRow', index)
        return;
      }
      else {
        row.editing = false;
      }
      bindOutputDescTip();
    },
    onLoadSuccess: function () {
      if ("update" == eventStatus) {
        var data = $('#outputListDg').datagrid('getData');
        var index = data.total;
        if (index > 0) {
          $('#methodOutputAddBtn').attr("disabled", true);
        }
        else {
          $('#methodOutputAddBtn').attr("disabled", false);
        }
      }
      else {
        $('#methodOutputAddBtn').attr("disabled", false);
      }
      var data = $('#outputListDg').datagrid('getData');
      var total = data.total;
      for (i = 0; i < total; i++) {
        outputNote = data.rows[i].descHidden;
        $('#outputListDg').datagrid('beginEdit', i);
      }
      bindOutputDescTip();
      //$.parser.parse("#methodDetail")
    }
  });
}
function getMethodCode () {
  var retinfo = ""
  $.ajax({
    type: "get",
    url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=methodCode",
    dateType: "json",
    async: false,
    success: function (data) {
      var dataInfo = data.replace(/[\r\n]/g, "^")
      var arr = new Array();
      arr = dataInfo.split("^^");
      var length = arr.length
      var obj = eval('(' + arr[length - 1] + ')');
      if (obj.retvalue == "0") {
        retinfo = obj.retinfo;
      }
      else {
        $.messager.alert('��ʾ', obj.retinfo);
      }
    }
  });
  return retinfo;
}

function bindInputDescDialog (tVal) {
  //$('#ff1 table table td[field="note"] a').on('click',function(){
  //var tVal=$(this).val();
  //var tVal=row["desc"];
  tVal = replaceTextarea2(tVal);
  $('#inputDescDialog textarea').val(tVal);
  $('#inputDescDialog').dialog("open");
  //});
}

function bindDescTip () {
  var tTR = $('#t1 tr:eq(5) div[class="datagrid-body"] table tr');
  tTR.css('height', '25px');
  var tDesc = $('#t1 tr:eq(5) div[class="datagrid-body"] table td[field="desc"] div');
  tDesc.css('height', '20px');
}

function bindOutputDescTip () {
  var tDesc = $('#t1 tbody').children(':eq(6)').find('div[class="datagrid-body"] table td[field="desc"] div');
  tDesc.css('height', '20px');
}

function replaceTextarea1 (str) {
  var reg = new RegExp("\n", "g");
  var reg1 = new RegExp(" ", "g");
  str = str.replace(reg, "<br>");
  str = str.replace(reg1, "<p>");
  return str;
}

function replaceTextarea2 (str) {
  var reg = new RegExp("<br>", "g");
  var reg1 = new RegExp("<p>", "g");
  str = str.replace(reg, "\n");
  str = str.replace(reg1, " ");
  return str;
}

function testRow (id, index) {
  $("#methodListDg").datagrid('selectRow', index)
  $.ajax({
    type: "get",
    url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=expandMethodDetail&input=" + id,
    dataType: "json",
    success: function (data) {
      var detailHtml = "<table style='width:600px;color:blue;font-size:12px;font-weight:bold;margin:15px auto;'>";
      $.each(data, function (i, list) {
        detailHtml += "<tr><td>���÷�����</td><td>" + list.methodPublishClassName + "</td></tr>";
        var arr = new Array();
        var inputInfo = list.methodInputDesc
        arr = inputInfo.split(",");
        var length = arr.length
        for (i = 0; i < length; i++) {
          var inputdesc = arr[i];
          var ar = inputdesc.split(":");
          if (ar[0] == "KeyName(�̶�ֵ)") {
            detailHtml += "<tr><td style='width:80px'>" + ar[0] + "��</td><td><input class='textbox' type='text' id='" + ar[0] + "' style='width:520px' value='" + ar[1] + "'></input></td></tr>";
          }
          else {
            detailHtml += "<tr><td style='width:80px'>" + ar[0] + "��</td><td><input class='textbox' type='text' id='" + ar[0] + "' style='width:520px'></input></td></tr>";
          }
        }
        detailHtml += "<tr><td></td><td style='text-align:right;'><a id='methodRelBtn' href='#' class='easyui-linkbutton'>��������</a>   <a id='testBtn' href='#' class='easyui-linkbutton'>����</a></td></tr>"
        detailHtml += "<tr><td>�����</td><td><label id='ttile'></label></td></tr>";
      });
      detailHtml += "</table>";
      $('#testMethod').html(detailHtml);
      $('#testBtn').linkbutton({
        iconCls: 'icon-ok'
      });
      $('#methodRelBtn').linkbutton({
        iconCls: 'icon-edit'
      });
      $('#testBtn').bind('click', function () {
        var inputInfo = "";
        var inputs = document.getElementById("testMethod").getElementsByTagName("input");
        for (var i = 0; i < inputs.length; i++) {
          if (inputs[i].type == "text") {
            inputInfo = inputInfo + "&input=" + inputs[i].value;
          }
        }
        inputInfo = "input=" + id + inputInfo
        $.ajax({
          type: "get",
          url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=testMethodResult&" + inputInfo,
          dateType: "json",
          async: false,
          success: function (data) {
            var dataInfo = data.replace(/[\r\n]/g, "^")
            var arr = new Array();
            arr = dataInfo.split("^^");
            var length = arr.length
            var obj = eval('(' + arr[length - 1] + ')');
            var detailHtml = "<table style='width:500px;color:blue;font-size:12px;font-weight:bold;margin:15 auto;'>";
            detailHtml += "<tr><td>" + obj.retinfo + "</td></tr>";
            //detailHtml+="<tr><td>"+inputInfo+"</td></tr>";
            detailHtml += "</table>";
            document.getElementById("ttile").innerHTML = detailHtml
          }
        })
      });
      $('#methodRelBtn').bind('click', function () {
        var leftSel = $("#selectL");
        var rightSel = $("#selectR");
        $("#toright").bind("click", function () {
          leftSel.find("option:selected").each(function () {
            $(this).remove().appendTo(rightSel);
          });
        });
        $("#toleft").bind("click", function () {
          rightSel.find("option:selected").each(function () {
            $(this).remove().appendTo(leftSel);
          });
        });
        leftSel.dblclick(function () {
          $(this).find("option:selected").each(function () {
            $(this).remove().appendTo(rightSel);
          });
        });
        rightSel.dblclick(function () {
          $(this).find("option:selected").each(function () {
            $(this).remove().appendTo(leftSel);
          });
        });
        $("#sub").click(function () {
          var selVal = [];
          rightSel.find("option").each(function () {
            selVal.push(this.value);
          });
          selVals = selVal.join(",");
          //selVals = rightSel.val();
          if (selVals == "") {
            alert("û��ѡ���κ��");
          } else {
            alert(selVals);
          }
        });
        loadMethodItemListInfo(id);
        $('#addEnsInterfaceMethod').css('display', 'block');
        $('#addEnsInterfaceMethod').window('open');
      });
    }
  })
  $("#testMethod").css('display', 'block')
  $('#testMethod').window('open');
}

function viewDoc (id, index) {
  $("#methodListDg").datagrid('selectRow', index)
  var row = $("#methodListDg").datagrid('getSelected', index)
  var input = row.type + "^" + row.code
  //window.open("hip.ens.viewMd.csp?input=" + encodeURI(input))
  $.ajax({
    type: "get",
    url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=MDSearch&input=" + encodeURI(input),
    dataType: "json",
    success: function (data) {
      if (data.ResultCode == 0) {
        console.log("data.DocumentContent", data.DocumentContent)
        var base64 = data.DocumentContent
        var decode = atob(base64)
        console.log("decode", decode)
        var str = decodeURI(decode)
        console.log("str", str)
        //$("#docContent").val(marked.parse(str))
        $("#docView").html(marked.parse(str))
        $("#docViewContent").css('display', 'block')
        $('#docViewContent').window('open');
      } else {
        $.messager.alert('��ʾ', data.ResultContent, 'error')
      }
      //{"ResultCode":0,"ResultContent":"�ɹ�","DocumentContent":"xxxxxxxxxxxxxxxxxxxxxx"} 
    }
  })

}

function loadMethodItemListInfo (id) {
  $.ajax({
    type: "get",
    url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=loadMethodItemListInfo&input=" + id,
    dateType: "json",
    success: function (data) {
      var obj = eval('(' + data + ')');
      var lSelectHTML = "", rSelectHTML = "";
      for (var i = 0; i < obj.length; i++) {
        if (obj[i].type == "right") {
          rSelectHTML = rSelectHTML + "<option value=" + obj[i].id + ">" + obj[i].code + "</option>";
        }
        else {
          lSelectHTML = lSelectHTML + "<option value=" + obj[i].id + ">" + obj[i].code + "</option>";
        }
      }
      $('#selectL').empty();
      $('#selectL').html(lSelectHTML);
      $('#selectR').empty();
      $('#selectR').html(rSelectHTML);
    }
  });
}


function init () {
  var getFileContent = function (fileInput, callback) {
    var files = $('#fileSel').filebox('files');
    if (files && files.length > 0 && files[0].size > 0) {
      //������һ���൱��JQuery�ģ�var file =$("#upload").prop('files')[0];
      var file = files[0];
      if (window.FileReader) {
        var reader = new FileReader();
        reader.onloadend = function (evt) {
          if (evt.target.readyState == FileReader.DONE) {
            callback(evt.target.result);
          }
        };
        // ��������������gbk����
        reader.readAsText(file);
      }
    }
  };
  //��ʼ���ļ���
  $("#fileSel").filebox({
    width: 400, buttonIcon: 'icon-folder', plain: true, buttonText: 'ѡ���ļ�',
    accept: '.md', prompt: '��ѡ��markdown�ļ���.md��',
    onChange: function () {
      getFileContent(this, function (str) {
        GV.fileText = str
        //GV.fileText=marked.marked(str)
        //GV.fileText = '123'
      })

    }
  })
  //$("#model").attr('readonly', true)
  /*  ��ʼ������Ŀ��-ģ̬�� */
  $('#procuctionnameDetail').combogrid({
    panelWidth: 450,
    idField: 'rowid',
    textField: 'desc',
    multiple: true,
    fitColumns: true,
    //blurValidValue: true,
    url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=TargetList",
    /*  data: {
       total: 2, rows: [{ "rowid": "4", "code": "PIS", "desc": "����", "hospital": "DHSZHYYZY", "version": "Default", "mode": "����" },
       { "rowid": "5", "code": "PIc", "desc": "����1", "hospital": "DHSZHYYZn", "version": "Default", "mode": "�ֿ�" },
       { "rowid": "4", "code": "PIS", "desc": "1��22����2", "hospital": "DHSZHYYZY", "version": "Default", "mode": "����" },
       { "rowid": "5", "code": "PIc", "desc": "3��34����3", "hospital": "DHSZHYYZn", "version": "Default", "mode": "�ֿ�" },
       { "rowid": "4", "code": "PIS", "desc": "��2233����4", "hospital": "DHSZHYYZY", "version": "Default", "mode": "����" },
       { "rowid": "5", "code": "PIc", "desc": "�²���5", "hospital": "DHSZHYYZn", "version": "Default", "mode": "�ֿ�" },
       { "rowid": "4", "code": "PIS", "desc": "�ϲ���6", "hospital": "DHSZHYYZY", "version": "Default", "mode": "����" },
       { "rowid": "5", "code": "PIc", "desc": "������7", "hospital": "DHSZHYYZn", "version": "Default", "mode": "�ֿ�" }
       ]
     }, */
    columns: [[
      { field: 'ck', title: 'sel', checkbox: true },
      //{ field: 'rowid', title: 'ID' },
      { field: 'code', title: '����' },
      { field: 'desc', title: '����' },
      { field: 'functioncode', title: '���ܴ���' },
      { field: 'functiondesc', title: '��������' },
      { field: 'hospital', title: 'Ժ��' },
      { field: 'version', title: '�汾' },
      { field: 'mode', title: 'ģʽ' }
    ]],
    filter: function (q, row) {
      //var opts = $(this).combogrid('options');
      var g = $(this).combogrid('grid');
      g.datagrid('load', { desc: q });
      //return row[opts.textField].indexOf(q) != -1;
      return false
    },
    loadFilter: function (data) {
      var newData = { total: data.length, rows: data }
      return newData
    },
    /* onSelect: function (index, row) {
      $("#model").val(row.mode)
    } */
  });

  /* ��ʼ����Ʒ��-��ѯ */
  $("#procuctionname").combobox({
    valueField: 'methodProcuctionTerm',
    textField: 'methodProcuctionTerm',
    //data: production,
    url: GV.proxy + "?action=methodProcuctionTermlist",
    defaultFilter: 2
  })

  /* ��ʼ��״̬ */
  // ��ʼ��״̬-��ѯ
  $("#status").combobox({
    valueField: 'code',
    textField: 'desc',
    data: [{ code: 'ALL', desc: 'ȫ��' }, { code: 'Y', desc: '����' }, { code: 'N', desc: 'ֹͣ' }]
  })
  // ��ʼ��״̬-dialog
  $("#methodStatus").combobox({
    valueField: 'code',
    textField: 'desc',
    data: [{ code: 'Y', desc: '����' }, { code: 'N', desc: 'ֹͣ' }]
  })

  /* ��ʼ���������� */
  // ��ʼ����������-��ѯ
  $("#type").combobox({
    valueField: 'code',
    textField: 'desc',
    data: [{ code: 'ALL', desc: 'ȫ��' }, { code: 'classMethod', desc: '�ڲ�����' }, { code: 'webMethod', desc: '�ⲿ����' }]
  })
  // ��ʼ����������-dialog
  $("#methodType").combobox({
    valueField: 'code',
    textField: 'desc',
    data: [{ code: 'classMethod', desc: '�ڲ�����' }, { code: 'webMethod', desc: '�ⲿ����' }]
  })

  //��ʼ�� ����|����ģ̬��
  $('#methodDetail').window({
    iconCls: 'icon-add', modal: true, closed: true, top: '35px', resizable: false,
    onClose: function () {
      clearDetailContent()
    }
  })
}





//�����￪ʼ
$(function () {
  Dictionary();
  init();
  loadEnsInterfaceMethod();
  // ��ѯ��ť
  $("#methodDataSelectBtn").click(function () {
    reLoadEnsInterfaceMethod();
  });
  // �������
  $("#methodInputAddBtn").click(function () {
    insertinputrow();
  });
  //��������
  $("#methodOutputAddBtn").click(function () {
    insertoutputrow();
    $('#methodOutputAddBtn').attr("disabled", true);
  });
  //��������-����
  $("#methodRelSaveBtn").click(function () {
    var arrAllL = document.getElementById("selectL");
    var arrAllR = document.getElementById("selectR");
    var selectL = "", selectR = ""
    for (i = 0; i < arrAllL.length; i++) {
      if (arrAllL[i].tagName.toLowerCase() == "option") {
        if (selectL == "") {
          selectL = arrAllL[i].value;
        }
        else {
          selectL = selectL + "^" + arrAllL[i].value;
        }
      }
    }
    for (i = 0; i < arrAllR.length; i++) {
      if (arrAllR[i].tagName.toLowerCase() == "option") {
        if (selectR == "") {
          selectR = arrAllR[i].value;
        }
        else {
          selectR = selectR + "^" + arrAllR[i].value;
        }
      }
    }
    var row = $('#methodListDg').datagrid('getSelected');
    var input = row["id"] + "@" + selectR;
    input = encodeURI(input);
    $.ajax({
      type: "POST",
      contentType: "application/x-www-form-urlencoded; charset=UTF-8",
      url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=saveEnsInMethodItem&input=" + input,
      dateType: "json",
      success: function (data) {
        var dataInfo = data.replace(/[\r\n]/g, "^")
        var arr = new Array();
        arr = dataInfo.split("^^");
        var length = arr.length;
        var obj = eval('(' + arr[length - 1] + ')');
        if (obj.retvalue == "1") {
          $.messager.alert('��ʾ', '����ɹ�', "", function () {
            $('#addEnsInterfaceMethod').window('close');
          });
        }
        else {
          $.messager.alert('��ʾ', obj.retinfo);
        }
      }
    })

  });
  // ������ť
  $("#methodDataAddBtn").click(function () {
    eventStatus = "add";
    //�������ģ̬��
    //clearDetailContent();
    $('#methodDataCancleBtn').linkbutton('enable');     // ���ô� button 
    $('#methodDataCancleBtn').attr("disabled", false);
    $('#methodCode').attr("readOnly", false);
    //���س���
    loadOutputDetail("");
    //�������
    loadInputDetail("");
    arrayObj = [];
    outputNote = "";
    $('#methodDetail').window('open');
    $('#methodDetail').css('display', 'block')
    $.parser.parse("#methodDetail")
  });
  // ����-���水ť
  $("#methodDataSaveBtn").click(function () {

    var res = [];
    $("input[name='recordPos']").each(function (index, obj) {
      if ($(obj).checkbox('options').checked) {
        //  ѡ�и�ѡ���е�ֵ
        res.push($(obj).val())
        //res += $(obj).val();
      } else {
        res.push("N")
      }
    });
    /*  var recordPos = { "recordPos": res }
 
     if (recordPos == "") {
       $.messager.alert('��ʾ', "ѡ���¼��ʽ");
       return;
     } */
    //var procuctionnameDetail = $('#procuctionnameDetail').combogrid('getValues').replace(/\ /g, "");
    var procuctionnameDetail = $('#procuctionnameDetail').combogrid('getValues')
    procuctionnameDetail = JSON.stringify(procuctionnameDetail)
    if (procuctionnameDetail == "") {
      $.messager.alert('��ʾ', "���������Ŀ��");
      return;
    }
    /* var model = $('#model').val().replace(/\ /g, "");
    if (model == "") {
      $.messager.alert('��ʾ', "ģʽ����Ϊ��");
      return;
    } */
    var methodCode = $("#methodCode").val().replace(/\ /g, "");
    if (methodCode == "") {
      $.messager.alert('��ʾ', "�����뷽������");
      return;
    }
    var methodStatus = $('#methodStatus').combobox('getValue');
    if (methodStatus == "") {
      $.messager.alert('��ʾ', "��ѡ��ǰ״̬");
      return;
    }
    var methodType = $('#methodType').combobox('getValue');
    if (methodType == "") {
      $.messager.alert('��ʾ', "��ѡ�񷽷�����");
      return;
    }
    var methodName = $("#methodName").val().replace(/\ /g, "");
    if (methodName == "") {
      $.messager.alert('��ʾ', "�����뷽������");
      return;
    }
    var methodDesc = $("#methodDesc").val().replace(/\ /g, "");
    methodDesc = replaceTextarea1(methodDesc);
    if (methodDesc == "") {
      $.messager.alert('��ʾ', "�����뷽������");
      return;
    }
    var methodClassName = $("#methodClassName").val().replace(/\ /g, "");
    if (methodClassName == "") {
      $.messager.alert('��ʾ', "������������");
      return;
    }


    var methodNote = $("#methodNote").val().replace(/\ /g, "");
    methodNote = replaceTextarea1(methodNote);
    var inputGdRows = $('#inputListDg').datagrid('getRows');
    var outputGdRows = $('#outputListDg').datagrid('getRows');
    var inputGdInfo = "";
    for (var i = 0; i < inputGdRows.length; i++) {
      $('#inputListDg').datagrid('endEdit', i);
      var tmpType = inputGdRows[i]['type'];
      if (("undefined" == typeof (tmpType)) || ("" == tmpType)) {
        tmpType = "undefined";
        continue;
      }
      var tmpFlag = inputGdRows[i]['flag'];
      var tmpDesc = inputGdRows[i]['desc'];
      var tmpDescLong = arrayObj[i];
      var inGdKey = "inGd" + i + "=";
      var tmpRowInfo = inGdKey + tmpType + "&" + inGdKey + tmpFlag + "&" + inGdKey + tmpDesc + "&" + inGdKey + tmpDescLong;
      if ("" == inputGdInfo) {
        inputGdInfo = tmpRowInfo;
      } else {
        var endFlag = "inGd" + (i - 1) + "=" + "inGd" + i;  //���һλ��־λ ��¼�Ƿ�����һ������
        inputGdInfo = inputGdInfo + "&" + endFlag + "&" + tmpRowInfo;
      }
    }
    var tOutPutType = ""
    var tOutPutDesc = ""
    var tOutputLongDesc = "";
    for (var i = 0; i < outputGdRows.length; i++) {
      $('#outputListDg').datagrid('endEdit', i);
      tOutPutType = outputGdRows[0]['type'];
      if (("undefined" == typeof (tOutPutType)) || ("" == tOutPutType)) {
        continue;
      }
      tOutPutDesc = outputGdRows[0]['desc'];
      tOutputLongDesc = outputNote;
    }




    var methodInfo = "input=" + eventStatus + "&input=" + methodCode + "&input=" + methodDesc;
    var methodInfo = methodInfo + "&input=" + procuctionnameDetail + "&input=" + methodStatus + "&input=" + methodType;
    var methodInfo = methodInfo + "&input=" + methodClassName + "&input=" + methodName + "&input=" + methodNote;
    var methodInfo = methodInfo + "&input=" + tOutPutType + "&input=" + tOutPutDesc + "&input=" + tOutputLongDesc + "&input=" + res[0] + "&input=" + res[1];
    //var methodInfo = methodInfo + "&" + inputGdInfo + "&input=" +
    methodInfo = encodeURI(methodInfo);
    inputGdInfo = encodeURI(inputGdInfo);
    //fileCon = GV.fileText
    var fileCon = encodeURI(GV.fileText);
    console.log("fileCon", fileCon)
    var fileBase64 = btoa(fileCon)
    console.log("fileBase64", fileBase64)
    var inputStr = methodInfo + "&input=" + fileBase64 + "&" + inputGdInfo

    //return

    $.ajax({
      type: "POST",
      contentType: "application/x-www-form-urlencoded; charset=UTF-8",
      // url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=saveMethodData&" + methodInfo + "&" + inputGdInfo + "&" +fileCon,
      //url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=saveMethodData&" + inputStr,
      url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=saveMethodData",
      data: inputStr,
      dateType: "json",
      success: function (data) {
        var dataInfo = data.replace(/[\r\n]/g, "^")
        var arr = new Array();
        arr = dataInfo.split("^^");
        var length = arr.length;
        var obj = eval('(' + arr[length - 1] + ')');
        if (obj.retvalue == "1") {
          $.messager.alert('��ʾ', '����ɹ�', "", function () {
            $('#methodInputAddBtn').attr("disabled", false);
            $('#methodOutputAddBtn').attr("disabled", false);
            reLoadEnsInterfaceMethod();
            $('#methodDetail').window('close');
          });
        }
        else {
          $.messager.alert('��ʾ', obj.retinfo);
        }
      }
    })
  });
  //����- ȡ����ť
  $("#methodDataCancleBtn").click(function () {
    if ($(this).linkbutton('options').disabled == true) {
      return;
    }
    clearDetailContent();
  });
  //����-���-detail
  $('#inputDescDialog').dialog({
    autoOpen: false,
    title: '��ע',
    iconCls: 'icon-edit',
    width: 500,
    height: 250,
    closed: true,
    cache: false,
    href: '',
    modal: true,
    resizable: true,
    buttons: [{
      text: 'ȡ��',
      iconCls: 'icon-cancel',
      handler: function () {
        $.messager.confirm("��ʾ", "��ȷ��Ҫȡ����ǰ������", function (data) {
          if (data) {
            $('#inputDescDialog').dialog('close');
          }
        });
      }
    }, {
      text: '����',
      iconCls: 'icon-save',
      handler: function () {
        var tVal = $('#inputDescDialog textarea').val();
        tVal = replaceTextarea1(tVal);
        var row = $('#inputListDg').datagrid('getSelected');
        var index = $('#inputListDg').datagrid('getRowIndex', row)
        if (typeStatus == "input") {
          arrayObj[index] = tVal;
        }
        else {
          outputNote = tVal;
        }
        //$('#ff1 table table td[field="descHidden"] table input[type="text"]').val(tVal);
        //$('#ff1 table table td[field="desc"] table input[type="text"]').val(tVal);
        $('#inputDescDialog').dialog('close');
      }
    }
    ]
  });

  $('#inputDescDialogView').dialog({
    autoOpen: false,
    title: '�鿴 �ֶ�˵��',
    iconCls: 'icon-tip',
    width: 500,
    height: 250,
    top: '35px',
    closed: true,
    cache: false,
    href: '',
    modal: true,
    resizable: true
  });





  //��ȡ�ļ�����
  /*  var getFileContent = function (fileInput, callback) {
     var files = $('#fileSel').filebox('files');
     if (files && files.length > 0 && files[0].size > 0) {
       //������һ���൱��JQuery�ģ�var file =$("#upload").prop('files')[0];
       var file = files[0];
       if (window.FileReader) {
         var reader = new FileReader();
         reader.onloadend = function (evt) {
           if (evt.target.readyState == FileReader.DONE) {
             callback(evt.target.result);
           }
         };
         // ��������������gbk����
         reader.readAsText(file);
       }
     }
   };
  */


})