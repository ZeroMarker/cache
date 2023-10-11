var tb, proxy = "web.DHCENS.STBLL.Method.SystemStatusConfigMvc.cls?";
var initPara = "";

function reLoadEnsInterfaceMethod () {
  var methodCode = $('#methodCode').combobox('getText');//服务代码
  var methodType = $('#type').combobox('getValue');	//方法类型
  var inputContent = $("#inputContent").val().replace(/\ /g, ""); //入参
  var starttime = $("#starttime").datetimebox('getValue'); //开始时间
  var endtime = $("#endtime").datetimebox('getValue');//结束时间
  console.log("starttime", starttime + "----" + endtime)
  var methodstatus = $('#status').combobox('getValue');	//处理结果

  if (compareDateTime(starttime, endtime)) {
    $.messager.alert("提示", '开始时间不能大于结束时间')
    return false
  }
  /* 服务代码  方法类型 入参 入参 结束时间 处理结果*/
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
      afterPageText: '页,共{pages}页', beforePageText: '第', displayMsg: '显示{from}到{to}条，共{total}条',
      fitCloumns: true,
      fixRowNumber: true,
      nowrap: false,
      idField: 'id',
      method: 'get',
      url: 'web.DHCENS.STBLL.UTIL.PageLoad.cls?action=ensInterfacelist&input=' + input,
      pageSize: 20,
      pageList: [20, 40, 60, 80, 100],
      columns: [[
        { field: 'id', title: '序号', sortable: true, width: 80 },
        { field: 'code', title: '方法代码', width: 200 },
        /* 
        {field:'desc',title:'方法描述',width:250},  
        */
        { field: 'transferInClass', title: '方法使用类', width: 180 },
        { field: 'transferInMethod', title: '方法使用名', width: 150 },
        { field: 'input', title: '入参', width: 300, },
        { field: 'inputDesc', title: '入参描述', width: 300 },
        { field: 'transferOuput', title: '返回值', width: 300 },
        { field: 'transferInsDate', title: '日期', sortable: true, width: 100 },
        { field: 'transferInsTime', title: '时间', sortable: true, width: 100 },
        {
          field: 'transferStatus', title: '状态', sortable: true, width: 40,
          formatter: function (v, rec) {
            var status = "";
            if (rec.transferStatus == "Y") {
              status = "成功";
            }
            else {
              status = "失败";
            }
            return status;
          }
        }
      ]],
      toolbar: "#toolbar", /* [{
            iconCls: 'icon-add', text: '增加', handler: function () {
	            	
	        }
	    }], */


      rowStyler: function (index, row) {
        if (row.transferStatus == 'N') {
          return 'background-color:#E93C20;color:#fff;';
        }
      }
    })
}


//日期格式化
function formatDate (date, dtype) {
  var year = date.getFullYear();    //获取完整的年份(4位,1970-????)
  var month = date.getMonth() + 1;       //获取当前月份(0-11,0代表1月)
  var day = date.getDate();
  month = (month < 10) ? "0" + month : month;
  day = (day < 10) ? "0" + day : day;       //获取当前日(1-31)
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

//时间格式化 
function formatTime (date, tType) {
  var hour = date.getHours();//得到小时
  var minu = date.getMinutes();//得到分钟
  var sec = date.getSeconds();//得到秒
  hour = (hour < 10) ? "0" + hour : hour;
  minu = (minu < 10) ? "0" + minu : minu;
  sec = (sec < 10) ? "0" + sec : sec;
  return hour + ":" + minu + ":" + sec;
}

var dFormat, tFormat = 1;
var startTime, endTime;
function initDateTime () {
  //修改日历框显示格式
  $.fn.calendar.defaults.weeks = ['日', '一', '二', '三', '四', '五', '六'];
  $.fn.calendar.defaults.months = ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'];

  $.ajaxSettings.async = false;//设置同步
  $.ajax({
    type: "get",
    url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=DateFormat",
    dataType: "json",
    success: function (data) {
      dFormat = data
    }
  });

  //初始化开始时间
  startTime = $('#starttime').datetimebox({
    showSeconds: true,
    currentText: '今天',
    closeText: '关闭',
    okText: '确定',
    formatter: function (date) {
      return formatDate(date, dFormat) + " " + formatTime(date, "1")
    }
  });

  //初始化结束时间
  endTime = $('#endtime').datetimebox({
    showSeconds: true,
    currentText: '今天',
    closeText: '关闭',
    okText: '确定',
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
  /* 初始化服务代码 */
  $("#methodCode").combobox({
    valueField: 'id',
    textField: 'code',
    url: 'web.DHCENS.STBLL.UTIL.PageLoad.cls?action=methodComboxlist',
    method: 'get'
  })

  /* 初始化 类型 */
  $("#type").combobox({
    valueField: 'code',
    textField: 'desc',
    data: [{ code: 'ALL', desc: '全部' }, { code: 'classMethod', desc: '内部调用' }, { code: 'webMethod', desc: '外部调用' }],
  })

  /* 初始化 状态 */
  $("#status").combobox({
    valueField: 'code',
    textField: 'desc',
    data: [{ code: 'ALL', desc: '全部' }, { code: 'N', desc: '失败' }, { code: 'Y', desc: '成功' }],
  })


}



$(function () {
  init()
  initDateTime();
  var startTime = $("#starttime").datetimebox('getValue'); //开始时间
  var endTime = $("#endtime").datetimebox('getValue');//结束时间
  initPara = "^ALL^^" + startTime + "^" + endTime + "^ALL";
  loadEnsWebServiceClient(initPara);
  // 查询按钮
  $("#methodDataSelectBtn").click(function () {
    reLoadEnsInterfaceMethod();
  });
})
