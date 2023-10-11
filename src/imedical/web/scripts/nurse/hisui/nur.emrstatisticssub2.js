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
  
	// ���� Export
	$("#Export").click(function () {
	  // �������-datagrid-export.js ʵ�ֵ���excel����
	  $("#EmrSubGrid").datagrid("toExcel", "����������ͳ����ϸ���.xls");
	});
  }
  /*----------------------------------------------------------------------------------*/
  /**
   * @description ��ʼ��ҽ���б�
   */
  function initStatistics() {
	var defaultPageSize = 25;
	var defaultPageList = [25, 50, 100, 200, 500];
	var regNo = $("#regNoInput").val();
	var name = $("#nameInput").val();
	$("#EmrSubGrid").datagrid({
	  url: $URL,
	  pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
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
		  { field: "adm", title: "�����", hidden: true }, //
		  { field: "PatName", title: "����", width: 150 },
		  { field: "RegNo", title: "�ǼǺ�", width: 110 },
		  { field: "PatSex", title: "�Ա�", width: 50 },
		  { field: "PatAge", title: "����", width: 50 },
		  { field: "InDate", title: "��Ժʱ��", width: 150 },
		  { field: "AdmTypeDesc", title: "��������", width: 80 },
		  { field: "EmrName", title: "ģ������", width: 350 },
		  {
			field: "CareDate",
			title: "��������",
			width: 110,
			sortable: true,
			order: "asc",
		  },
		  {
			field: "Score",
			title: "��ֵ",
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
		//ͬ�������෽�� ,������ʹ��
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
		//websys_createWindow(link,"����ϸ","width=96%,height=90%")
		var iTop = 30;
		var iLeft = 30;
		var iHeight = window.innerHeight - iTop*2;
		var iWidth = window.innerWidth - iLeft*2;
		// iTop+=window.screenTop;
		iTop=window.screenTop;
		iLeft+=window.screenLeft;
		// ����ģʽ����������ת����
		if (row.StatisticsMode && row.StatisticsMode == "patient") {
		  //$.messager.alert("��ʾ", "ͳ�ƻ������ݣ���֧����ת��������", 'error');
		  //return;
		  var link = "nur.hisui.nursingRecords.csp" + "?IsPopUp=Y&EpisodeID=" + row.adm;
		  console.log("width=" + iWidth + ", height=" + iHeight + ",top=" + iTop + ",left=" + iLeft + ",scrollbars=1");
		  var w = window.open(
			link,
			"����ϸ",
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
			"����ϸ",
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
		// ��ȡ��һ������
		if (data && data.rows && data.rows[0] && data.rows[0].StatisticsMode) {
		  var statisticsMode = data.rows[0].StatisticsMode;
		  // ����ģʽ������ʾ�������ںͷ���
		  if (statisticsMode == "patient") {
			// ����������
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
  
  // �ַ���ȫ��ת��Сд
  function toLowerCase(str) {
	// �жϿ�
	if (str == null || str == "") {
	  return "";
	}
	return str.toLowerCase();
  }
  
  /**
  ����showModalDialog�滻Ϊopen
  url �򿪵������url��ַ
  obj ����
  sFeatures ���������Ի������۵���Ϣ
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
   * @description ҽ���б�ˢ��
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
  