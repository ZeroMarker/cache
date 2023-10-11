var tb, proxy = "web.DHCENS.STBLL.Method.SystemStatusConfigMvc.cls?";
var initPara = "";

function reLoadEnsInterfaceMethod () {
  var methodCode = $('#methodCode').combobox('getText');//�������
  var methodType = $('#type').combobox('getValue');	//��������
  var inputContent = $("#inputContent").val().replace(/\ /g, ""); //���
  var starttime = $("#starttime").datetimebox('getValue'); //��ʼʱ��
  var endtime = $("#endtime").datetimebox('getValue');//����ʱ��
  console.log("starttime", starttime + "----" + endtime)
  var methodstatus = $('#status').combobox('getValue');	//������

  if (compareDateTime(starttime, endtime)) {
    $.messager.alert("��ʾ", '��ʼʱ�䲻�ܴ��ڽ���ʱ��')
    return false
  }
  /* �������  �������� ��� ��� ����ʱ�� ������*/
  var selectInfo = methodCode + "^" + methodType + "^" + inputContent + "^" + starttime + "^" + endtime + "^" + methodstatus;
  $('#ensInterfaceListDg').datagrid({ url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=ensInterfacelist&input=" + selectInfo, method: "get" });
  $('#ensInterfaceListDg').datagrid('load');
}

function loadEnsWebServiceClient (input) {
  tb = $HUI.datagrid('#ensInterfaceListDg',
    {
      fit: true,
      headerCls: 'panel-header-gray',
      singleSelect: true,
      pagination: true,
      afterPageText: 'ҳ,��{pages}ҳ', beforePageText: '��', displayMsg: '��ʾ{from}��{to}������{total}��',
      fitCloumns: true,
      fixRowNumber: true,
      nowrap: false,
      idField: 'id',
      method: 'get',
      url: 'web.DHCENS.STBLL.UTIL.PageLoad.cls?action=ensInterfacelist&input=' + input,
      pageSize: 20,
      pageList: [20, 40, 60, 80, 100],
      columns: [[
        { field: 'id', title: '���', sortable: true, width: 80 },
        { field: 'code', title: '��������', width: 200 },
        /* 
        {field:'desc',title:'��������',width:250},  
        */
        { field: 'transferInClass', title: '����ʹ����', width: 180 },
        { field: 'transferInMethod', title: '����ʹ����', width: 150 },
        { field: 'input', title: '���', width: 300, },
        { field: 'inputDesc', title: '�������', width: 300 },
        { field: 'transferOuput', title: '����ֵ', width: 300 },
        { field: 'transferInsDate', title: '����', sortable: true, width: 100 },
        { field: 'transferInsTime', title: 'ʱ��', sortable: true, width: 100 },
        {
          field: 'transferStatus', title: '״̬', sortable: true, width: 40,
          formatter: function (v, rec) {
            var status = "";
            if (rec.transferStatus == "Y") {
              status = "�ɹ�";
            }
            else {
              status = "ʧ��";
            }
            return status;
          }
        }
      ]],
      toolbar: "#toolbar", /* [{
            iconCls: 'icon-add', text: '����', handler: function () {
	            	
	        }
	    }], */


      rowStyler: function (index, row) {
        if (row.transferStatus == 'N') {
          return 'background-color:#E93C20;color:#fff;';
        }
      }
    })
}


//���ڸ�ʽ��
function formatDate (date, dtype) {
  var year = date.getFullYear();    //��ȡ���������(4λ,1970-????)
  var month = date.getMonth() + 1;       //��ȡ��ǰ�·�(0-11,0����1��)
  var day = date.getDate();
  month = (month < 10) ? "0" + month : month;
  day = (day < 10) ? "0" + day : day;       //��ȡ��ǰ��(1-31)
  switch (dtype) {
    case 1:
      var date = month + "/" + day + "/" + year
      break;
    case 3:
      var date = year + "-" + month + "-" + day
      break;
    case 4:
      var date = day + "/" + month + "/" + year
      break;
    default:
      var date = year + "-" + month + "-" + day
      break;
  }
  return date
}

//ʱ���ʽ�� 
function formatTime (date, tType) {
  var hour = date.getHours();//�õ�Сʱ
  var minu = date.getMinutes();//�õ�����
  var sec = date.getSeconds();//�õ���
  hour = (hour < 10) ? "0" + hour : hour;
  minu = (minu < 10) ? "0" + minu : minu;
  sec = (sec < 10) ? "0" + sec : sec;
  return hour + ":" + minu + ":" + sec;
}

var dFormat, tFormat = 1;
var startTime, endTime;
function initDateTime () {
  //�޸���������ʾ��ʽ
  $.fn.calendar.defaults.weeks = ['��', 'һ', '��', '��', '��', '��', '��'];
  $.fn.calendar.defaults.months = ['һ��', '����', '����', '����', '����', '����', '����', '����', '����', 'ʮ��', 'ʮһ��', 'ʮ����'];

  $.ajaxSettings.async = false;//����ͬ��
  $.ajax({
    type: "get",
    url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=DateFormat",
    dataType: "json",
    success: function (data) {
      dFormat = data
    }
  });

  //��ʼ����ʼʱ��
  startTime = $('#starttime').datetimebox({
    showSeconds: true,
    currentText: '����',
    closeText: '�ر�',
    okText: 'ȷ��',
    formatter: function (date) {
      return formatDate(date, dFormat) + " " + formatTime(date, "1")
    }
  });

  //��ʼ������ʱ��
  endTime = $('#endtime').datetimebox({
    showSeconds: true,
    currentText: '����',
    closeText: '�ر�',
    okText: 'ȷ��',
    formatter: function (date) {
      return formatDate(date, dFormat) + " " + formatTime(date, "1")
    }
  });

  var myDate = new Date();
  var curDate = formatDate(myDate, dFormat);
  var startTime = curDate + " 00:00:00";
  var endTime = curDate + " 23:59:59";
  $('#starttime').datetimebox('setValue', startTime)
  $('#endtime').datetimebox('setValue', endTime)
}

function compareDateTime (startDateTime, endDateTime) {
  var startArr = startDateTime.split(' ')
  var endArr = endDateTime.split(" ")
  var endDate = endArr[0],
    endTime = endArr[1],
    startDate = startArr[0],
    startTime = startArr[1],
    startDateArr, endDateArr, startTimeArr, endTimeArr;
  switch (dFormat) {
    case 1:
      startDateArr = startDate.split("/");
      startDate = startDateArr[2] + startDateArr[0] + startDateArr[1];
      endDateArr = endDate.split("/");
      endDate = endDateArr[2] + endDateArr[0] + endDateArr[1];
      break;
    case 3:
      startDate = startDate.replace(/-/g, "");
      endDate = endDate.replace(/-/g, "");
      break;
    case 4:
      startDateArr = startDate.split("/");
      startDate = startDateArr[2] + startDateArr[1] + startDateArr[0];
      endDateArr = endDate.split("/");
      endDate = endDateArr[2] + endDateArr[1] + endDateArr[0];
      break;
    default:
      startDate = startDate.replace(/-/g, "");
      endDate = endDate.replace(/-/g, "");
      break;
  }
  switch (tFormat) {
    case 1:
      startTime = startTime.replace(/:/g, "");
      endTime = endTime.replace(/:/g, "");
      break;
    default:
      startTime = startTime.replace(/:/g, "");
      endTime = endTime.replace(/:/g, "");
      break;
  }

  startDateTime = startDate + startTime;
  endDateTime = endDate + endTime;
  return startDateTime > endDateTime
}

function init () {
  /* ��ʼ��������� */
  $("#methodCode").combobox({
    valueField: 'id',
    textField: 'code',
    url: 'web.DHCENS.STBLL.UTIL.PageLoad.cls?action=methodComboxlist',
    method: 'get'
  })

  /* ��ʼ�� ���� */
  $("#type").combobox({
    valueField: 'code',
    textField: 'desc',
    data: [{ code: 'ALL', desc: 'ȫ��' }, { code: 'classMethod', desc: '�ڲ�����' }, { code: 'webMethod', desc: '�ⲿ����' }],
  })

  /* ��ʼ�� ״̬ */
  $("#status").combobox({
    valueField: 'code',
    textField: 'desc',
    data: [{ code: 'ALL', desc: 'ȫ��' }, { code: 'N', desc: 'ʧ��' }, { code: 'Y', desc: '�ɹ�' }],
  })


}



$(function () {
  init()
  initDateTime();
  var startTime = $("#starttime").datetimebox('getValue'); //��ʼʱ��
  var endTime = $("#endtime").datetimebox('getValue');//����ʱ��
  initPara = "^ALL^^" + startTime + "^" + endTime + "^ALL";
  loadEnsWebServiceClient(initPara);
  // ��ѯ��ť
  $("#methodDataSelectBtn").click(function () {
    reLoadEnsInterfaceMethod();
  });
})
