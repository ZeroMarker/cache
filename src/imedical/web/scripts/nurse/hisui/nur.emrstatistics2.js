/**
 * @author zhangxiangbo
 * @version 20211017
 * @description
 * @name nur.EmrStatistics.js    nur.emrstatistics2.js
 */

// 判读是否高级权限,项目个性需求这里可以过滤
function isAdmin() {
	var groupStr = $.m(
	  {
		ClassName: "Nur.NIS.Service.ReportV2.DataManager",
		MethodName: "GetGroupListByCode",
		reportCode: "NurEmrSumReport", // 写死，后面做成配置 TODO
	  },
	  false
	);
	var admin = false;
	if (groupStr && groupStr != "") {
	  if (groupStr.toString().indexOf(",") > -1) {
		var gpArr = groupStr.split(",");
		for (var i = 0; i < gpArr.length; i++) {
		  if (session["LOGON.GROUPID"] == gpArr[i]) {
			admin = true;
			break;
		  }
		}
	  } else {
		if (session["LOGON.GROUPID"] == groupStr) {
		  admin = true;
		}
	  }
	}
	// 单个报表或护理部可以查看全部病区数据 2022.8.18 add
	if (session["LOGON.GROUPDESC"].indexOf("护理部") > -1 || admin) {
	  return true;
	}
	return false;
  }
  
  var JsonCol = "";
  if (!isAdmin()) {
	JsonCol = tkMakeServerCall(
	  "Nur.NIS.Service.ReportV2.EmrStatistics",
	  "getEmrStatisticsCol",
	  session["LOGON.HOSPID"],
	  session["LOGON.CTLOCID"]
	);
  } else {
	JsonCol = tkMakeServerCall(
	  "Nur.NIS.Service.ReportV2.EmrStatistics",
	  "getEmrStatisticsCol",
	  session["LOGON.HOSPID"],
	  ""
	);
  }
  var ColOBJECT = $.parseJSON(JsonCol);
  for(var k=0;k<ColOBJECT[1].length;k++){
	ColOBJECT[1][k].sorter=function (a,b) {
		return parseFloat(a||0)-parseFloat(b||0);
	};
  }
  var GV = {
	_CALSSNAME: "Nur.NIS.Service.ReportV2.EmrStatistics",
	episodeID: "",
  };
  var init = function () {
	initPageDom();
	initBindEvent();
  };
  $(init);
  function initPageDom() {
	initCondition();
	initStatistics();
	initStatisticsGrid();
  }
  function initBindEvent() {
	// $("#regNoInput").bind("keydown", function (e) {
	//   var regNO = $("#regNoInput").val();
	//   if (e.keyCode == 13 && regNO != "") {
	// 	var regNoComplete = completeRegNo(regNO);
	// 	$("#regNoInput").val(regNoComplete);
	// 	queryOrdStatistics();
	//   }
	// });
	// $("#nameInput").bind("keydown", function (e) {
	//   var name = $("#nameInput").val();
	//   if (e.keyCode == 13 && name != "") {
	// 	queryOrdStatistics();
	//   }
	// });
	$("#findBtn").bind("click", queryOrdStatistics);
	// 导出 Export
	$("#Export").click(function () {
	  $("#EmrGrid").datagrid("toExcel", "病历汇总统计结果.xls");
	});
  }
  /*-------------------------------------------------------------------*/
  /**
   * @description 初始化医嘱列表
   */
  function initStatistics() {
	var defaultPageSize = 25;
	var defaultPageList = [25, 50, 100, 200, 500];
	var Locs = $("#LoginLocs").combobox("getValues").join(",");
	if (!isAdmin()) {
	  Locs = session["LOGON.CTLOCID"];
	}
	var startDate = $("#startDate").datebox("getValue");
	var endDate = $("#endDate").datebox("getValue");
	var ifOuted = $("#ifOuted").checkbox("getValue");
	var type = "";
	$("#EmrGrid").datagrid({
	  bodyCls: "table-splitline",
	  url: $URL,
	  pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
	//   pageSize: defaultPageSize,
	//   pageList: defaultPageList,
	  queryParams: {
		ClassName: "Nur.NIS.Service.ReportV2.EmrStatistics",
		MethodName: "getEmrStatisticsData",
		StartDate: startDate,
		EndDate: endDate,
		LocId: Locs,
		type: type,
		ifOuted: ifOuted,
		sessionGrpId: session["LOGON.GROUPID"],
		sessionHosId: session["LOGON.HOSPID"],
	  },
	  columns: ColOBJECT,
	  idField: "JId",
	  remoteSort: false,
	  singleSelect: true,
	  // 表头与表格内容错位 start
	  onLoadSuccess: function () {
		var table = $(this).prev().find("table");
		var posDivs = table.eq(0).find("div.datagrid-cell"); //表头用来定位用的div
		var bodyFirstDivs = table.eq(1).find("tr:eq(0) div"); //内容第一行用来设置宽度的div，以便设置和表头一样的宽度
		var orderHeader = posDivs.map(function (index) {
		  return { index: index, left: $(this).position().left };
		}); //计算表头的左边位置，以便重新排序和内容行单元格循序一致
		orderHeader.sort(function (a, b) {
		  return a.left - b.left;
		}); //对表头位置排序
		setTimeout(function () {
		  //延时设置宽度，因为easyui执行完毕回调后有后续的处理，会去掉内容行用来设置宽度的div的css width属性
		  for (var i = 0; i < orderHeader.length; i++) {
			var wid = posDivs.eq(orderHeader[i].index).parents("td").width(); // todo 谷歌要减掉0.5，否则单元格描述过长可能会超出一些
			bodyFirstDivs
			  .eq(i)
			  .parents("td")
			  .css("width", wid + "px");
		  }
		}, 50);
		// if ($('#EmrGrid').datagrid('options').sortOrder) return;
		// console.log($('#EmrGrid').datagrid('options').sortOrder);
		//删除“合计”列
		var rows=$(this).datagrid('getRows');
		for (var i = 0; i < rows.length; i++) {
			var row = rows[i];
			if ($g('合计')==row.LocDesc) {
				$(this).datagrid("deleteRow", i); //删除
				break;
			}
		}
		//添加“合计”列
		var locList = $("#LoginLocs").combobox("getValues");
		if (
		  $("#EmrGrid").datagrid("getData") &&
		  $("#EmrGrid").datagrid("getData").total > 1
		) {
		  // 单科室不需要汇总，会重复显示数据
		  var newRow = {};
		  var firstRow = $("#EmrGrid").datagrid("getData").rows[0];
		  if (firstRow) {
			for (var filedName in firstRow) {
			//   if (filedName == "JId" || filedName == "NurseLoc") continue;
			  if (filedName == "LocDesc") {
				newRow[filedName] = $g('合计');
			  } else if (filedName == "JId") {
				newRow["JId"] = firstRow["JId"];
			  } else {
				// newRow[filedName] = '<span class="subtotal">' + compute(filedName) + "</span>";
				newRow[filedName] = compute(filedName);
			  }
			  newRow["noclick"] = "1";
			}
			$("#EmrGrid").datagrid("appendRow", newRow);
		  }
		}
		initStatisticsGrid();
	  },
	});
  }
  
  //指定列求和
  function compute(colName) {
	var rows = $("#EmrGrid").datagrid("getRows");
	var total = 0;
	for (var i = 0; i < rows.length; i++) {
	  total += parseFloat(rows[i][colName]||0);
	}
	return total;
  }
  
  function initCondition() {
	//console.log(new Date().Format("yyyy-MM-dd"))
	var date1 = getDate(-7); // 正数后几天 负数前几天
	var date2 = getDate(0);
  
	var defaultValue = "";
	if (!isAdmin()) {
	  defaultValue = session["LOGON.CTLOCID"];
	  $("#LoginLocs").combobox({ disabled: true });
	}
  
	$("#startDate").datebox("setValue", date1);
	$("#endDate").datebox("setValue", date2);
	$("#LoginLocs").combobox({
	  url:
		$URL +
		"?1=1&ClassName=" +
		GV._CALSSNAME +
		"&QueryName=NurseCtloc&desc=" +
		"&ResultSetType=array&hosId=" +
		session["LOGON.HOSPID"],
	  valueField: "locID",
	  textField: "locDesc",
	  defaultFilter: 4,
	  multiple: true,
	  rowStyle: "checkbox", //显示成勾选行形式
	  value: defaultValue,
	  onLoadSuccess: function () {},
	});
	var emrs = tkMakeServerCall(
	  "Nur.NIS.Service.ReportV2.EmrStatistics",
	  "GetAllEmr",
	  session["LOGON.HOSPID"]
	);
  
	var emrsobj = $.parseJSON(emrs);
	emrsobj.map(function (e,i) {
		emrsobj[i].name=$g(e.name);
	})
	$("#ProjectName").combobox({
	  valueField: "id",
	  textField: "name",
	  defaultFilter: 4,
	  multiple: true,
	  rowStyle: "checkbox", //显示成勾选行形式
	  data: emrsobj,
	});
  }
  /**
   *@description 初始化bedGrid按钮操作及事件监听等
   *
   */
  function initStatisticsGrid() {
	$.each(ColOBJECT, function (index, obj) {
	  $.each(obj, function (subindex, objsub) {
		if (objsub.hidden != true) {
			if (!$("#EmrGrid").datagrid("getColumnOption", objsub.field)) return;
			$("#EmrGrid").datagrid("getColumnOption", objsub.field).sorter=function (a,b) {
				return parseFloat(a||0)-parseFloat(b||0);
			};
		  $("#EmrGrid").datagrid("getColumnOption", objsub.field).formatter =
			function (val, row, index) {
			  var btns = "";
			  if (objsub.field != "LocDesc") {
				var maxCount = 1;
				// 评分种类的数量
				if (objsub.field.indexOf("_0") > -1) {
				  var maxCount = row[objsub.field + "subCount"];
				}
				if (val == "0") {
				  btns = val;
				} else {
				  // 设置默认值
				  if (typeof val == "undefined") {
					val = "0";
				  }
				  if (val == "0") {
					btns = val;
				  } else {
					//   if(row["noclick"]) debugger;
					btns =
					  '<a href="#" class="editcls" onclick="openwindows(\'' +
					  row["JId"] +
					  "," +
					  // 总的合计行 不传科室id
					  ((row["noclick"] == "1")?"":row["NurseLoc"]) +
					  "," +
					  objsub.field +
					  "," +
					  maxCount +
					  "')\">" +
					  val +
					  "</a>";
				  }
				}
			  } else {
				btns = val;
			  }
			  // 悬浮提示
			  if (objsub.exp && objsub.exp != "") {
				var tips = $g("评分范围：") + objsub.exp;
				btns = "<span title='" + tips + "'>" + btns + "</span>";
			  }
			  return btns;
			};
		}
	  });
	});
  }
  function openwindows(ParaData) {
	if (ParaData == "") return;
	var ParaArray = ParaData.split(",");
	if (
	  ParaArray[2] == "0" ||
	  ParaArray[2] == undefined ||
	  ParaArray[2] == "LocDesc"
	) return;
	var link =
	  "nur.hisui.emrstatisticssub2.csp?&JobId=" +
	  ParaArray[0] +
	  "&NurseLoc=" +
	  ParaArray[1] +
	  "&EmrCode=" +
	  ParaArray[2] +
	  "&MaxCount=" +
	  ParaArray[3];
	if ("undefined" != typeof websys_getMWToken) {
	  link += "&MWToken=" + websys_getMWToken();
	}
	//websys_createWindow(link,"数据明细","width=96%,height=90%")
	//window.showModalDialog(link,window,"dialogWidth:1300px;dialogHeight:800px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;")
	//window.open(link,window,"dialogWidth:1300px;dialogHeight:800px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;")
	//alert(ParaData)

// console.log(document.body.clientWidth); // 1208
// console.log(document.body.clientHeight); // 754
// console.log(document.body.offsetWidth); // 1208
// console.log(document.body.offsetHeight); // 754
// console.log(document.body.scrollWidth); // 1208
// console.log(document.body.scrollHeight); // 754
// console.log(document.body.scrollTop); // 0
// console.log(document.body.scrollLeft); // 0
// console.log(window.screenTop); // 23
// console.log(window.screenLeft); // 0
// console.log(window.screen.height); // 900
// console.log(window.screen.width); // 1440
	var iTop = 30;
	var iLeft = 30;
	var iHeight = window.screen.availHeight - iTop*2;
	var iWidth = window.screen.availWidth - iLeft*2;
	console.log("width=" + iWidth + ", height=" + iHeight + ",top=" + iTop + ",left=" + iLeft);
	window.open(
	  link,
	  "数据明细",
	  "width=" +
		iWidth +
		", height=" +
		iHeight +
		",top=" +
		iTop +
		",left=" +
		iLeft
	);
  }
function queryOrdStatistics() {
	$('#EmrGrid').datagrid('options').sortName = "";
	$('#EmrGrid').datagrid('options').sortOrder = "";
	ordStatisticsReload();
}
  
  /**
   * @description 医嘱列表刷新
   */
  function ordStatisticsReload() {
	var Locs = $("#LoginLocs").combobox("getValues").join(",");
	// var sortName= $('#EmrGrid').datagrid('options').sortName;
	// var sortOrder= $('#EmrGrid').datagrid('options').sortOrder;
	if (!isAdmin()) {
	  Locs = session["LOGON.CTLOCID"];
	}
	var startDate = $("#startDate").datebox("getValue");
	var endDate = $("#endDate").datebox("getValue");
	var type = "";
	var ifOuted = $("#ifOuted").checkbox("getValue");
  
	var emrs = $("#ProjectName").combobox("getValues").join(",");
	if (!isAdmin()) {
	  JsonCol = tkMakeServerCall(
		"Nur.NIS.Service.ReportV2.EmrStatistics",
		"getEmrStatisticsCol",
		session["LOGON.HOSPID"],
		session["LOGON.CTLOCID"],
		emrs
	  );
	} else {
	  JsonCol = tkMakeServerCall(
		"Nur.NIS.Service.ReportV2.EmrStatistics",
		"getEmrStatisticsCol",
		session["LOGON.HOSPID"],
		"",
		emrs
	  );
	}
	var ColOBJECT = $.parseJSON(JsonCol);
	for (var k = 0; k < ColOBJECT[1].length; k++) {
		ColOBJECT[1][k].sorter=function (a,b) {
			return parseFloat(a||0)-parseFloat(b||0);
		};
		  // if(ColOBJECT[1][k]["heji"]=="1"){
		  // 	ColOBJECT[1][k]["styler"]=cellStyle;
		  // }
	}
	var newCols = [];
	var frozenColumns = [[ColOBJECT[0][0]]];
	var topCol = ColOBJECT[0];
	topCol.splice(0, 1);
	newCols.push(topCol);
	newCols.push(ColOBJECT[1]);
	$("#EmrGrid").datagrid({
	  columns: newCols,
	  frozenColumns: frozenColumns,
	});
  
	$("#EmrGrid").datagrid("load", {
	  ClassName: "Nur.NIS.Service.ReportV2.EmrStatistics",
	  MethodName: "getEmrStatisticsData",
	  StartDate: startDate,
	  EndDate: endDate,
	  LocId: Locs,
	  type: type,
	  ifOuted: ifOuted,
	  sessionGrpId: session["LOGON.GROUPID"],
	  sessionHosId: session["LOGON.HOSPID"],
	});
	initStatisticsGrid();
	// $('#EmrGrid').datagrid('options').sortName=sortName;
	// $('#EmrGrid').datagrid('options').sortOrder=sortOrder;
  }
  
	
	
  /**
   * 获取指定时间的日期
   * @params 正是今天之后的日期、负是今天前的日期
   * @return 2020-05-10
   * */
  function getDate(num) {
	var date1 = new Date();
	//今天时间
	var time1 =
	  date1.getFullYear() + "-" + (date1.getMonth() + 1) + "-" + date1.getDate();
	var date2 = new Date(date1);
	date2.setDate(date1.getDate() + num);
	//num是正数表示之后的时间，num负数表示之前的时间，0表示今天
	var time2 =
	  this.addZero(date2.getFullYear()) +
	  "-" +
	  this.addZero(date2.getMonth() + 1) +
	  "-" +
	  this.addZero(date2.getDate());
	return time2;
  }
  
  //补0
  function addZero(num) {
	if (parseInt(num) < 10) {
	  num = "0" + num;
	}
	return num;
  }
  