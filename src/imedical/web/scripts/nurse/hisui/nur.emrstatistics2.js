/**
 * @author zhangxiangbo
 * @version 20211017
 * @description
 * @name nur.EmrStatistics.js    nur.emrstatistics2.js
 */

// �ж��Ƿ�߼�Ȩ��,��Ŀ��������������Թ���
function isAdmin() {
	var groupStr = $.m(
	  {
		ClassName: "Nur.NIS.Service.ReportV2.DataManager",
		MethodName: "GetGroupListByCode",
		reportCode: "NurEmrSumReport", // д���������������� TODO
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
	// ��������������Բ鿴ȫ���������� 2022.8.18 add
	if (session["LOGON.GROUPDESC"].indexOf("����") > -1 || admin) {
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
	// ���� Export
	$("#Export").click(function () {
	  $("#EmrGrid").datagrid("toExcel", "��������ͳ�ƽ��.xls");
	});
  }
  /*-------------------------------------------------------------------*/
  /**
   * @description ��ʼ��ҽ���б�
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
	  pagination: false, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
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
	  // ��ͷ�������ݴ�λ start
	  onLoadSuccess: function () {
		var table = $(this).prev().find("table");
		var posDivs = table.eq(0).find("div.datagrid-cell"); //��ͷ������λ�õ�div
		var bodyFirstDivs = table.eq(1).find("tr:eq(0) div"); //���ݵ�һ���������ÿ�ȵ�div���Ա����úͱ�ͷһ���Ŀ��
		var orderHeader = posDivs.map(function (index) {
		  return { index: index, left: $(this).position().left };
		}); //�����ͷ�����λ�ã��Ա���������������е�Ԫ��ѭ��һ��
		orderHeader.sort(function (a, b) {
		  return a.left - b.left;
		}); //�Ա�ͷλ������
		setTimeout(function () {
		  //��ʱ���ÿ�ȣ���Ϊeasyuiִ����ϻص����к����Ĵ�����ȥ���������������ÿ�ȵ�div��css width����
		  for (var i = 0; i < orderHeader.length; i++) {
			var wid = posDivs.eq(orderHeader[i].index).parents("td").width(); // todo �ȸ�Ҫ����0.5������Ԫ�������������ܻᳬ��һЩ
			bodyFirstDivs
			  .eq(i)
			  .parents("td")
			  .css("width", wid + "px");
		  }
		}, 50);
		// if ($('#EmrGrid').datagrid('options').sortOrder) return;
		// console.log($('#EmrGrid').datagrid('options').sortOrder);
		//ɾ�����ϼơ���
		var rows=$(this).datagrid('getRows');
		for (var i = 0; i < rows.length; i++) {
			var row = rows[i];
			if ($g('�ϼ�')==row.LocDesc) {
				$(this).datagrid("deleteRow", i); //ɾ��
				break;
			}
		}
		//��ӡ��ϼơ���
		var locList = $("#LoginLocs").combobox("getValues");
		if (
		  $("#EmrGrid").datagrid("getData") &&
		  $("#EmrGrid").datagrid("getData").total > 1
		) {
		  // �����Ҳ���Ҫ���ܣ����ظ���ʾ����
		  var newRow = {};
		  var firstRow = $("#EmrGrid").datagrid("getData").rows[0];
		  if (firstRow) {
			for (var filedName in firstRow) {
			//   if (filedName == "JId" || filedName == "NurseLoc") continue;
			  if (filedName == "LocDesc") {
				newRow[filedName] = $g('�ϼ�');
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
  
  //ָ�������
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
	var date1 = getDate(-7); // �������� ����ǰ����
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
	  rowStyle: "checkbox", //��ʾ�ɹ�ѡ����ʽ
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
	  rowStyle: "checkbox", //��ʾ�ɹ�ѡ����ʽ
	  data: emrsobj,
	});
  }
  /**
   *@description ��ʼ��bedGrid��ť�������¼�������
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
				// �������������
				if (objsub.field.indexOf("_0") > -1) {
				  var maxCount = row[objsub.field + "subCount"];
				}
				if (val == "0") {
				  btns = val;
				} else {
				  // ����Ĭ��ֵ
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
					  // �ܵĺϼ��� ��������id
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
			  // ������ʾ
			  if (objsub.exp && objsub.exp != "") {
				var tips = $g("���ַ�Χ��") + objsub.exp;
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
	//websys_createWindow(link,"������ϸ","width=96%,height=90%")
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
	  "������ϸ",
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
   * @description ҽ���б�ˢ��
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
   * ��ȡָ��ʱ�������
   * @params ���ǽ���֮������ڡ����ǽ���ǰ������
   * @return 2020-05-10
   * */
  function getDate(num) {
	var date1 = new Date();
	//����ʱ��
	var time1 =
	  date1.getFullYear() + "-" + (date1.getMonth() + 1) + "-" + date1.getDate();
	var date2 = new Date(date1);
	date2.setDate(date1.getDate() + num);
	//num��������ʾ֮���ʱ�䣬num������ʾ֮ǰ��ʱ�䣬0��ʾ����
	var time2 =
	  this.addZero(date2.getFullYear()) +
	  "-" +
	  this.addZero(date2.getMonth() + 1) +
	  "-" +
	  this.addZero(date2.getDate());
	return time2;
  }
  
  //��0
  function addZero(num) {
	if (parseInt(num) < 10) {
	  num = "0" + num;
	}
	return num;
  }
  