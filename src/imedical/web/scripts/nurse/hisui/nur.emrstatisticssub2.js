/**
 * @author zhangxiangbo
 * @version 20211017
 * @description
 * @name nur.EmrStatisticsSub.js
 */
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
	initStatistics();
  }
  function initBindEvent() {
	$("#regNoInput").bind("keydown", function (e) {
	  var regNO = $("#regNoInput").val();
	  if (e.keyCode == 13 && regNO != "") {
		var regNoComplete = completeRegNo(regNO);
		$("#regNoInput").val(regNoComplete);
		ordStatisticsReload();
	  }
	});
	$("#nameInput").bind("keydown", function (e) {
	  var name = $("#nameInput").val();
	  if (e.keyCode == 13 && name != "") {
		ordStatisticsReload();
	  }
	});
	$("#findBtn").bind("click", ordStatisticsReload);
  
	// 导出 Export
	$("#Export").click(function () {
	  // 借助插件-datagrid-export.js 实现导出excel功能
	  $("#EmrSubGrid").datagrid("toExcel", "护理病历汇总统计明细结果.xls");
	});
  }
  /*----------------------------------------------------------------------------------*/
  /**
   * @description 初始化医嘱列表
   */
  function initStatistics() {
	var defaultPageSize = 25;
	var defaultPageList = [25, 50, 100, 200, 500];
	var regNo = $("#regNoInput").val();
	var name = $("#nameInput").val();
	$("#EmrSubGrid").datagrid({
	  url: $URL,
	  pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
	  pageSize: defaultPageSize,
	  pageList: defaultPageList,
	  queryParams: {
		ClassName: "Nur.NIS.Service.ReportV2.EmrStatistics",
		QueryName: "findStatisticsSub",
		Reg: regNo,
		name: name,
		JobId: JobId,
		NurseLoc: NurseLoc,
		EmrCode: EmrCode,
		MaxCount: MaxCount,
	  },
	  columns: [
		[
		  { field: "adm", title: "就诊号", hidden: true }, //
		  { field: "PatName", title: "姓名", width: 150 },
		  { field: "RegNo", title: "登记号", width: 110 },
		  { field: "PatSex", title: "性别", width: 50 },
		  { field: "PatAge", title: "年龄", width: 50 },
		  { field: "InDate", title: "入院时间", width: 150 },
		  { field: "AdmTypeDesc", title: "就诊类型", width: 80 },
		  { field: "EmrName", title: "模板名称", width: 350 },
		  {
			field: "CareDate",
			title: "评估日期",
			width: 110,
			sortable: true,
			order: "asc",
		  },
		  {
			field: "Score",
			title: "分值",
			width: 80,
			sortable: true,
			order: "asc",
		  },
		  { field: "EmrCode", title: "EmrCode", hidden: true },
		  { field: "rw", title: "rw", hidden: true },
		  { field: "StatisticsMode", title: "StatisticsMode", hidden: true },
		],
	  ],
	  frozenColumns: [[]],
	  idField: "rw",
	  onDblClickRow: function (index, row) {
		console.log(arguments);
		//同步调用类方法 ,不建议使用
		var cspName = $m(
		  {
			ClassName: "Nur.NIS.Service.ReportV2.EmrStatistics",
			MethodName: "GetPhysicsCSPName",
			code: row.EmrCode,
		  },
		  false
		);
		var link =
		  cspName +
		  "?&EpisodeID=" +
		  row.adm +
		  "&NurMPDataID=" +
		  row.rw +
		  "&AuthorityFlag=1&IsPopUp=Y";
		//window.showModalDialog(link,"","dialogWidth:1300px;dialogHeight:800px;center:yes;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;scroll:yes")
		//websys_createWindow(link,"表单明细","width=96%,height=90%")
		var iTop = 30;
		var iLeft = 30;
		var iHeight = window.innerHeight - iTop*2;
		var iWidth = window.innerWidth - iLeft*2;
		// iTop+=window.screenTop;
		iTop=window.screenTop;
		iLeft+=window.screenLeft;
		// 患者模式，不可以跳转病历
		if (row.StatisticsMode && row.StatisticsMode == "patient") {
		  //$.messager.alert("提示", "统计患者数据，不支持跳转护理病历！", 'error');
		  //return;
		  var link = "nur.hisui.nursingRecords.csp" + "?IsPopUp=Y&EpisodeID=" + row.adm;
		  console.log("width=" + iWidth + ", height=" + iHeight + ",top=" + iTop + ",left=" + iLeft + ",scrollbars=1");
		  var w = window.open(
			link,
			"表单明细",
			"width=" +
			  iWidth +
			  ", height=" +
			  iHeight +
			  ",top=" +
			  iTop +
			  ",left=" +
			  iLeft +
			  ",scrollbars=1"
		  );
		} else {
		//   console.log("width=" + iWidth + ", height=" + iHeight + ",top=" + iTop + ",left=" + iLeft + ",scrollbars=1");
		  var w = window.open(
			link,
			"表单明细",
			"width=" +
			  iWidth +
			  ", height=" +
			  iHeight +
			  ",top=" +
			  iTop +
			  ",left=" +
			  iLeft +
			  ",scrollbars=1"
		  );
		}
		setTimeout(function () {
		  w.document.title = window.document.title;
		}, 200);
	  },
	  singleSelect: true,
	  onLoadSuccess: function (data) {
		// 获取第一条数据
		if (data && data.rows && data.rows[0] && data.rows[0].StatisticsMode) {
		  var statisticsMode = data.rows[0].StatisticsMode;
		  // 患者模式，不显示评估日期和分数
		  if (statisticsMode == "patient") {
			// 设置隐藏列
			$("#EmrSubGrid").datagrid("hideColumn", "CareDate");
			$("#EmrSubGrid").datagrid("hideColumn", "Score");
		  }
		}
	  },
	  onCheck: function (index, row) {
		var frm = dhcsys_getmenuform();
		if (frm) {
		  frm.EpisodeID.value = row.adm;
		  //frm.PatientID.value=row["PatientID"];
		}
	  },
  
	  /*onLoadSuccess: mergeCells,
		onClickCell:mergeCellSelectAll,
	*/
	});
  }
  
  // 字符串全部转成小写
  function toLowerCase(str) {
	// 判断空
	if (str == null || str == "") {
	  return "";
	}
	return str.toLowerCase();
  }
  
  /**
  所有showModalDialog替换为open
  url 打开弹出框的url地址
  obj 参数
  sFeatures 用来描述对话框的外观等信息
  */
  window.showModalDialog = function (url, obj, sFeatures) {
	sFeatures = sFeatures.replace(/dialogHeight/gi, "height");
	sFeatures = sFeatures.replace(/dialogWidth/gi, "width");
	sFeatures = sFeatures.replace(/dialogTop/gi, "top");
	sFeatures = sFeatures.replace(/dialogLeft/gi, "left");
	sFeatures = sFeatures.replace(/:/gi, "=");
	sFeatures = sFeatures.replace(/;/gi, ",");
	var newWindow = window.open(url, "", sFeatures);
	return newWindow;
  };
  
  /**
   * @description 医嘱列表刷新
   */
  function ordStatisticsReload() {
	var regNo = $("#regNoInput").val();
	var name = $("#nameInput").val();
  
	$("#EmrSubGrid").datagrid("load", {
	  ClassName: "Nur.NIS.Service.ReportV2.EmrStatistics",
	  QueryName: "findStatisticsSub",
	  Reg: regNo,
	  name: name,
	  JobId: JobId,
	  NurseLoc: NurseLoc,
	  EmrCode: EmrCode,
	  MaxCount: MaxCount,
	});
  }
  