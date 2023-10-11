$.extend($.fn.datagrid.methods, {
	editCell: function (jq, param) {
	  return jq.each(function () {
		$(this).datagrid("endEdit", param.index);
		var opts = $(this).datagrid("options");
		var fields = $(this)
		  .datagrid("getColumnFields", true)
		  .concat($(this).datagrid("getColumnFields"));
		for (var i = 0; i < fields.length; i++) {
		  var col = $(this).datagrid("getColumnOption", fields[i]);
		  col.editor1 = col.editor;
		  if (param.field.indexOf(fields[i]) < 0) {
			col.editor = null;
		  }
		}
		$(this).datagrid("beginEdit", param.index);
		for (var i = 0; i < fields.length; i++) {
		  var col = $(this).datagrid("getColumnOption", fields[i]);
		  col.editor = col.editor1;
		}
	  });
	},
  });
  var editBGCell = (function () {
	var oldFields;
	return function (fields, index) {
	  if (fields) oldFields = fields;
	  $("#multiVSTable").datagrid("editCell", {
		index: index,
		field: oldFields || [],
	  });
	};
  })();
  var patNode,
	saveFlag = true,
	dateformat,
	singleConfigObj,
	singleConfig = [],
	multiColumns = [],
	colCodesObj = {},
	colCodesArr = [],
	curEditorTarget,
	startMVSDay,
	endMVSDay,
	episodeIDs = [],
	vsItems = [],
	patientList = [],secondScreen={};
  var ifNewBaby = "N"; //是否新生儿标志
  var menuEpisodeID; //右键患者就诊号
  var timeouter;
  // 腋温、口温、肛温、耳温
  // var tempDesc=['腋','口','肛','耳'];
  // var tempObj={
  //   temperature:0,
  //   oraltemperature:1,
  //   rectemperature:2,
  //   eartemperature:3,
  //   0:'temperature',
  //   1:'oraltemperature',
  //   2:'rectemperature',
  //   3:'eartemperature',
  // }
  var tempDesc=[];
  var tempObj={};
  // 体温、脉搏、呼吸，有一个就显示三个；
  // 收缩压、舒张压，有一个就显示两个；
  var groups=[
	['temperature','pulse','breath'],
	['sysPressure','diaPressure']
  ];
  if ('undefined'==typeof HISUIStyleCode) {
	  var HISUIStyleCode="blue";
  }
  var subScreen; // 副屏
  var frm = dhcsys_getmenuform();
  $("#multiVSTable").datagrid({
	singleSelect: true,
	onClickRow: function (rowIndex, rowData) {
	  $(this).datagrid("unselectRow", rowIndex);
	},
  });
  $(function () {
	  if ('lite'==HISUIStyleCode) { //极简
		  $('#multiSaveBtn').css('top','1px').addClass('green');
	  }
	init();
	$("#multiVSTable").datagrid({
	  data: { total: 0, rows: [] },
	});
	updateDomSize();
	  // 模态框关闭后事件
	  $("#singleVSModal").dialog({
		  onClose: getPatientsTempDataByTime
	  });
	  $("#vsddModal").dialog({
		  onClose: getPatientsTempDataByTime
	  });
	  subScreen=window.parent.websys_emit && window.parent.websys_getMWScreens && window.parent.websys_getMWScreens().screens;
  });
  /**
   * @description 展示病人标题信息
   * @param {EpisodeID} 患者就诊号
   */
  function setPatientInfo(EpisodeID) {
	$m(
	  {
		ClassName: "web.DHCDoc.OP.AjaxInterface",
		MethodName: "GetOPInfoBar",
		CONTEXT: "",
		EpisodeID: EpisodeID,
	  },
	  function (html) {
		if (html != "") {
		  $(".PatInfoItem").html(reservedToHtml(html));
		} else {
		  $(".PatInfoItem").html(
			"获取病人信息失败。请检查【患者信息展示】配置。"
		  );
		}
	  }
	);
	function reservedToHtml(str) {
	  var replacements = {
		"&lt;": "<",
		"&#60;": "<",
		"&gt;": ">",
		"&#62;": ">",
		"&quot;": '"',
		"&#34;": '"',
		"&apos;": "'",
		"&#39;": "'",
		"&amp;": "&",
		"&#38;": "&",
	  };
	  return str.replace(
		/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,
		function (v) {
		  return replacements[v];
		}
	  );
	}
  }
  // 根据天查询血糖数据
  function findVSByDay() {
	var opeTabs = $("#opeTabs");
	opeTabs.tabs("exists", 0);
	while (opeTabs.tabs("exists", 0)) {
	  opeTabs.tabs("close", 0);
	}
	var startMVSDay = $("#startMVSDay").datebox("getValue"),
	  endMVSDay = $("#endMVSDay").datebox("getValue");
	while (
	  new Date(standardizeDate(startMVSDay)).valueOf() <=
	  new Date(standardizeDate(endMVSDay)).valueOf()
	) {
	  opeTabs.tabs("add", {
		title: startMVSDay,
	  });
	  startMVSDay = formattingDate(
		dateCalculate(new Date(standardizeDate(startMVSDay)), 1)
	  );
	}
	$HUI.tabs("#opeTabs", {
	  onSelect: function (date, index) {
		clearTimeout(timeouter);
		timeouter = setTimeout(getPatientsTempDataByTime, 25);
	  },
	});
	console.log(1);
	setTimeout(getPatientsTempDataByTime, 25);
  }
  // 初始化
  function init() {
	InitTip();
	// 获取日期格式
	var res = $cm(
	  {
		ClassName: "Nur.NIS.Service.System.Config",
		MethodName: "GetSystemConfig",
	  },
	  false
	);
	dateformat = res.dateformat;
	if (window.startDateTime) {
	  startMVSDay = window.startDateTime.split(" ")[0];
	  endMVSDay = window.endDateTime.split(" ")[0];
	} else {
	  startMVSDay = formattingDate(dateCalculate(new Date()));
	  endMVSDay = formattingDate(dateCalculate(new Date()));
	}
	$("#startMVSDay").datebox("setValue", startMVSDay);
	$("#endMVSDay").datebox("setValue", endMVSDay);
	vsItems = window.codeStr.split("^");
	var flag1=0,flag2=0;
	for (var i = 0; i < vsItems.length; i++) {
	  if (groups[0].indexOf(vsItems[i])>-1) {
		flag1=1
		vsItems.splice(i,1);
		i--;
		continue;
	  }
	  if (groups[1].indexOf(vsItems[i])>-1) {
		flag2=1
		vsItems.splice(i,1);
		i--;
		continue;
	  }
	}
	if (flag2) {
	  for (var i = groups[1].length-1; i > -1; i--) {
		vsItems.unshift(groups[1][i]);
	  }
	}
	if (flag1) {
	  for (var i = groups[0].length-1; i > -1; i--) {
		vsItems.unshift(groups[0][i]);
	  }
	}
  
	if ("Y" == window.IsShowAllPatient) {
	  var patientTimer = setInterval(function () {
		console.log($("#patientTree"));
		console.log($("#patientTree").length);
		var nodes = $("#patientTree").tree("getRoots");
		console.log(nodes);
		if (nodes.length) {
		  clearInterval(patientTimer);
		  nodes.map(function (node) {
			$("#patientTree").tree("check", node.target);
		  });
		}
	  }, 30);
	} else {
	  getPatientsByEpisodeIDs();
	}
  }
  function getPatientsByEpisodeIDs() {
	episodeIDs = episodeIDsStr.split("^");
	// 获取患者信息
	$cm(
	  {
		ClassName: "Nur.NIS.Service.VitalSign.Temperature",
		MethodName: "GetPatientsByEpisodeIDs",
		EpisodeIDs: episodeIDsStr,
	  },
	  function (res) {
		patientList = res;
		getSingleConfig();
	  }
	);
  }
  function getSingleConfig() {
	$cm(
	  {
		ClassName: "Nur.NIS.Service.VitalSign.Temperature",
		MethodName: "GetAllTempConfig",
		locID: session["LOGON.CTLOCID"],
		time: "",
		wardId: session['LOGON.WARDID'],
		bloodFlag:1
	  },
	  function (data) {
		singleConfig = data.SingleConfig;
		if (!singleConfigObj) {
		  singleConfigObj = {};
		  $("#vsItems tr:eq(1) td").empty();
		  var n=0;
		  for (var i = 0; i < singleConfig.length; i++) {
			var e = singleConfig[i];
			// 去除成人婴儿体征不匹配的项
			if ("N" == ifNewBaby && 1 == e.flag) {
			  singleConfig.splice(i, 1);
			  i--;
			  continue;
			}
			if ("Y" == ifNewBaby && "0" === e.flag) {
			  singleConfig.splice(i, 1);
			  i--;
			  continue;
			}
			e.select = JSON.parse(e.select);
			e.blank = JSON.parse(e.blank);
			e.validate = JSON.parse(e.validate);
			if (e.errorValueHightFrom)
			  e.errorValueHightFrom = parseFloat(e.errorValueHightFrom);
			if (e.errorValueLowTo)
			  e.errorValueLowTo = parseFloat(e.errorValueLowTo);
			if (e.normalValueRangFrom)
			  e.normalValueRangFrom = parseFloat(e.normalValueRangFrom);
			if (e.normalValueRangTo)
			  e.normalValueRangTo = parseFloat(e.normalValueRangTo);
			singleConfigObj[e.code] = e;
			if (e.signType=="T") {
			  tempDesc.push(e.desc.slice(0,1));
			  tempObj[e.code]=n;
			  tempObj[n]=e.code;
			  n++;
			}
		  }
		}
		findVSByDay();
	  }
	);
  }
  function getPatientsTempDataByTime() {
	if (!episodeIDsStr) return;
	var date = $("#opeTabs").tabs("getSelected").panel("options").title;
	console.log(date);
	  var newDay=Date.parse(standardizeDate(date))-24 * 3600 * 1000;
	  var preDay=formatDate(new Date(newDay));
	  var preRes=$cm({
	  ClassName: 'Nur.NIS.Service.VitalSign.Temperature',
	  MethodName: "GetGroupNeedMeasureByDay",
	  episodeIDS: episodeIDsStr,
	  date: preDay,
	  locID: session['LOGON.CTLOCID'],
	  needMeasure: 1,
	}, false);
	$cm(
	  {
		ClassName: "Nur.NIS.Service.VitalSign.Temperature",
		MethodName: "GetGroupNeedMeasureByDay",
		episodeIDS: episodeIDsStr,
		date: date,
		locID: session["LOGON.CTLOCID"],
		needMeasure: 1,
	  },
	  function (res) {
		colCodesArr.map(function (c,i) {
		  if (c.item=='temperature') {
			patientList.map(function (p,j) {
			  delete patientList[j]['temp'+i];
			})
		  }
		});
		var frozenColumns = [
		  [
			{ title: "床号", field: "bedCode", width: 125, rowspan: 2 },
			{ title: "姓名", field: "name", width: 125, rowspan: 2 },
		  ],
		];
		var timePoint = Object.keys(res);
		var data = [];
		// var ep0=episodeIDs[0];
		multiColumns = [[], []];
		colCodesArr = [];
		timePoint.map(function (tp) {
		  var colspan = 0;
		  if (!colCodesObj[tp]) colCodesObj[tp] = {};
		  var episodeArr = Object.keys(res[tp]);
		  var items = [];
		  episodeArr.map(function (ep) {
			var itemArr = Object.keys(res[tp][ep]);
			itemArr.map(function (item) {
			  if (-1 == items.indexOf(item)) {
				items.push(item);
			  }
			});
		  });
		  var flag1=0,flag2=0;
		  for (var i = 0; i < items.length; i++) {
			if (groups[0].indexOf(items[i])>-1) {
			  flag1=1
			  items.splice(i,1);
			  i--;
			  continue;
			}
			if (groups[1].indexOf(items[i])>-1) {
			  flag2=1
			  items.splice(i,1);
			  i--;
			  continue;
			}
		  }
		  if (flag2) {
			for (var i = groups[1].length-1; i > -1; i--) {
			  items.unshift(groups[1][i]);
			}
		  }
		  if (flag1) {
			for (var i = groups[0].length-1; i > -1; i--) {
			  items.unshift(groups[0][i]);
			}
		  }
		  // var items=Object.keys(res[tp][ep0]||[]);
		  items.map(function (item) {
			if (vsItems.indexOf(item) > -1) {
			  var len = colCodesArr.length;
			  colCodesObj[tp][item] = len;
			  colCodesArr.push({
				time: tp,
				item: item,
			  });
			  colspan++;
			  var e = singleConfigObj[item];
			  multiColumns[1].push({
				title: (item.indexOf('temperature')>-1)?'体温':(e.abbrCode||e.desc),
				field: "col" + len,
				align: "center",
				width: 125,
				styler: function (value, row, index) {
				  if ("undefined" == typeof value)
					return "background: #e4e4e4!important;";
				  // if (!JSON.parse(row[e.code+'_WriteFlag'])) return 'background: #e4e4e4!important;';
				  if (e.normalValueRangFrom || e.normalValueRangTo) {
					if (value == parseFloat(value)) {
					  if (
						value < e.normalValueRangFrom ||
						value > e.normalValueRangTo
					  ) {
						// return 'color: rgb(246, 164, 5);border: 1px solid rgb(246, 164, 5)!important;';
						return { class: "warning" };
					  }
					}
				  }
				},
				formatter: function (value, row, index) {
				  if ("undefined" == typeof value) return "";
				  if (item.indexOf('temperature')>-1) {
					return getCurrentTemp(value,index,len);
					// return value+'<span class="tempBtn" onclick="toggleTemp(event,this,'+index+','+len+');">腋</span>';
				  } else {
					return value;
				  }
				},
			  });
			  patientList.map(function (p, i) {
				if (res[tp][p.episodeID]) {
				  if (e.yestDesc) {
					var d = preRes[tp][p.episodeID][item];
				  } else {
					var d = res[tp][p.episodeID][item];
				  }
				  if ("undefined" != typeof d) {
					patientList[i]["col" + len] = d;
				  }
				  if (item.indexOf('temperature')>-1) {
					for (var j = 0; j < tempDesc.length; j++) {
					  var itm = tempObj[j];
					  if (singleConfigObj[itm].yestDesc) {
						var d0 = preRes[tp][p.episodeID][itm];
					  } else {
						var d0 = res[tp][p.episodeID][itm];
					  }
					  patientList[i][itm + len] = d0;
					}
				  }
				}
			  });
			}
		  });
		  if (colspan) {
			multiColumns[0].push({
			  title: tp + "点",
			  align: "center",
			  halign: "center",
			  width: 125 * colspan,
			  colspan: colspan,
			});
		  }
		});
		$("#multiVSTable").datagrid({
		  style: "width:98%;",
		  singleSelect: true,
		  autoSizeColumn: false,
		  fitColumns: false,
		  pagination: false,
		  bodyCls:'table-splitline',
		  frozenColumns: frozenColumns,
		  columns: multiColumns,
		  data: patientList,
		  onClickCell: function (index, field, value) {
					  console.log(arguments);
					  if (subScreen&&(window.codeStr.indexOf('FBS')<0)) {
						  var episodeId=patientList[index].episodeID;
						  var curDay=$("#opeTabs").tabs("getSelected").panel("options").title;
						  if ((secondScreen.EpisodeID!=episodeId)||(secondScreen.Date!=curDay)) {
							  secondScreen.EpisodeID=episodeId;
							  secondScreen.Date=curDay;
							  console.log(websys_getMWToken());
							  window.parent.websys_emit("onOpenTempPreview",{EpisodeID:episodeId,MWToken:websys_getMWToken(),Date:curDay});
						  }
					  }
			$("#mm").hide();
			if ("bedCode" == field || "name" == field) return;
			console.log(index, field, value);
			var bgColor = $(
			  'tr[datagrid-row-index="' + index + '"]>td[field="' + field + '"]'
			).css("backgroundColor");
			if ("rgb(228, 228, 228)" == bgColor) return;
			colIndex = parseInt(field.slice(3));
			editTableCell(index, field);
		  },
		  onDblClickCell: function (index, field, value) {
			var rows = $("#multiVSTable").datagrid("getRows");
			if ("vsItem" == field) {
			  if (!rows[index].blank) return;
			  var $blankTitle = $(
				'tr[datagrid-row-index="' + index + '"]>td[field="vsItem"]'
			  );
			  var bgColor = $blankTitle.css("backgroundColor");
			  if ("rgb(228, 228, 228)" == bgColor) {
				$blankTitle.css("backgroundColor", "transparent");
				$.messager.popover({
				  msg: "如若更改该空白栏标题，则本住院周的数据都将被更改。",
				  type: "info",
				});
			  }
			}
		  },
		  onRowContextMenu: function (e, index, row) {
			e.preventDefault();
			EpisodeID = row.episodeID;
			setPatientInfo(EpisodeID);
			var bgFlag=window.codeStr.indexOf('FBS')>-1;
			if (bgFlag) {
			  $("#mm>div:lt(5)").hide();
			  $("#mm>div:eq(5)").show();
			} else {
			  $("#mm>div:lt(5)").show();
			  $("#mm>div:eq(5)").hide();
			}
			$("#mm")
			  .css({
				left: e.pageX,
				top: Math.min(e.clientY, window.innerHeight - (bgFlag?35:155)) + "px",
			  })
			  .show();
		  },
		  onLoadSuccess: function (data) {
			updateDomSize();
			setTimeout(updateDomSize, 500);
		  },
		});
	  }
	);
  }
  // 获取当前体温
  function getCurrentTemp(value,index,len) {
	var itm='temperature',patient=patientList[index];
	if ('undefined'==typeof patient['temp'+len]) {
	  for (var i = 0; i < tempDesc.length; i++) {
		var val = patient[tempObj[i]+len];
		if (val) {
		  itm=tempObj[i];
		  value=val;
		  break;
		}
	  }
	  patientList[index]['temp'+len]=itm;
	} else {
	  itm=patient['temp'+len];
	  value=patient[itm+len]||'';
	}
	return '<span>'+value+'</span><span class="tempBtn" onclick="toggleTemp(event,this,'+index+','+len+');">'+tempDesc[tempObj[itm]]+'</span>';
  }
  // 切换体温
  function toggleTemp(e,obj,rowIndex,colIndex) {
	e.stopPropagation();
	console.log(arguments);
	var index=tempDesc.indexOf($(obj).html())
	index=(index+1)%tempDesc.length;
	$(obj).html(tempDesc[index]);
	patientList[rowIndex]['temp'+colIndex]=tempObj[index];
	$(obj).prev().html(patientList[rowIndex][tempObj[index]+colIndex]);
  }
  // 单人体征
  function openSingleVSModal(bgFlag) {
	var innerWidth = window.innerWidth - 50;
	var innerHeight = window.innerHeight - 50;
	$("#singleVSModal").dialog({
	  width: innerWidth,
	  height: innerHeight,
	}).dialog("open");
	$HUI.dialog('#singleVSModal').setTitle(bgFlag?'单人血糖':'单人体征');
	if (bgFlag) {
	  var url = "nur.hisui.SingleBG.csp?EpisodeID=" + EpisodeID + "&IsShowPatInfoBannner=Y";
	} else {
	  var url = "nur.hisui.singlevitalsign.csp?EpisodeID=" + EpisodeID + "&IsShowPatInfoBannner=Y";
	}
  if ("undefined" != typeof websys_getMWToken) {
    url += "&MWToken=" + websys_getMWToken();
  }
	$("#singleVSModal iframe").css("height", "calc(100% - 0px)").attr("src", url);
  }
  function preShow() {
							  console.log(websys_getMWToken());
	var url = "nur.hisui.temperature.linux.csp" + "?EpisodeID=" + EpisodeID;
  if ("undefined" != typeof websys_getMWToken) {
    url += "&MWToken=" + websys_getMWToken();
  }
	var width, height, left, top;
	if (window.screen.availWidth > 1900) {
	  width = Math.floor(window.screen.availWidth * 0.79);
	  height = Math.floor(window.screen.availHeight * 0.83);
	  left = (window.screen.availWidth - width) / 2;
	  top = (window.screen.availHeight - height) / 3;
	} else {
	  width = Math.floor(window.screen.availWidth * 0.98);
	  height = Math.floor(window.screen.availHeight * 0.83);
	  left = (window.screen.availWidth - width) / 3;
	  top = (window.screen.availHeight - height) / 3;
	}
	window.open(
	  url,
	  "newwindow",
	  "width=" +
		width +
		",height=" +
		height +
		",top=" +
		top +
		",left=" +
		left +
		",toolbar=no,menubar=yes,scrollbars=yes,resizable=yes,location=no,status=no"
	);
  }
  function editTableCell(index, field, keyCode) {
	var $td = $(
	  'tr[datagrid-row-index="' + index + '"]>td[field="' + field + '"]'
	);
	var bgColor = $td.css("backgroundColor");
	console.log(bgColor);
	if ("rgb(228, 228, 228)" == bgColor) {
	  if (keyCode) {
		forwardTableCell(index, field, keyCode);
	  }
	  return;
	}
	var rows = $("#multiVSTable").datagrid("getRows"),
	  row = rows[index];
	var saveRes = endEditTableCell();
	if (!saveRes) return;
	if (subScreen&&(window.codeStr.indexOf('FBS')<0)) {
		  var episodeId=patientList[index].episodeID;
		  var curDay=$("#opeTabs").tabs("getSelected").panel("options").title;
		  if ((secondScreen.EpisodeID!=episodeId)||(secondScreen.Date!=curDay)) {
			  secondScreen.EpisodeID=episodeId;
			  secondScreen.Date=curDay;
							  console.log(websys_getMWToken());
			  window.parent.websys_emit("onOpenTempPreview",{EpisodeID:episodeId,MWToken:websys_getMWToken(),Date:curDay});
		  }
	  }
	var vsItemCode = colCodesArr[colIndex].item;
	var vsItem = singleConfigObj[vsItemCode];
	console.log(vsItem);
	console.log(singleConfigObj);
	var tipId = vsItem.code + "Tip";
	if (vsItem.symbol && !$("#" + tipId).length) {
	  var tipDom = '<div id="' + tipId + '">';
	  vsItem.symbol.map(function (e) {
		tipDom +=
		  '<a href="#" name="symbol" class="easyui-linkbutton" data-options="plain:true" data-text="' +
		  e +
		  '"></a>';
	  });
	  tipDom += "</div>";
	  $("#toolTips").append(tipDom);
	  $("a[name='symbol']").map(function (index, elem) {
		var text = $(this).data("text");
		$(elem).linkbutton({
		  size: "small",
		  onClick: function () {
			addSymbol(text);
		  },
		  text: text,
		});
	  });
	}
	var e = $("#multiVSTable").datagrid("getColumnOption", field);
	console.log(vsItem);
	if (vsItem.select) {
	  var optData = [];
	  vsItem.options.map(function (item) {
		optData.push({ item: item });
	  });
	  e.editor = {
		type: "combobox",
		options: {
		  valueField: "item",
		  textField: "item",
		  data: optData,
				  defaultFilter:6,
		},
	  };
	} else {
	  e.editor = {
		type: "text",
		options: {
		  required: true,
		},
	  };
	}
	$("#multiVSTable").datagrid("editCell", {
	  index: index,
	  field: [field] || [],
	});
	var ed = $("#multiVSTable").datagrid("getEditor", {
	  index: index,
	  field: field,
	}); // 获取编辑器
	curEditorTarget = ed.target;
	if (vsItem.code.indexOf('temperature')>-1) {
	  var patient=patientList[index]
	  $(ed.target).val(patient[patient['temp'+colIndex]+colIndex]);
	}
	$(ed.target)
	  .focus()
	  .bind("keyup", function (e) {
		if (13 == e.keyCode) e.keyCode = 40;
		if ([13, 37, 38, 39, 40].indexOf(e.keyCode) > -1) {
		  forwardTableCell(index, field, e.keyCode);
		  return;
		}
	  })
	  .bind("blur", function (e) {
		endEditTableCell(2);
	  });
	if (vsItem.select) {
	  $(ed.target)
		.combobox("textbox")
		.bind("focus", function () {
		  $(ed.target).combobox("showPanel");
		  $(ed.target)
			.combobox("textbox")
			.bind("keyup", function (e) {
			  if (13 == e.keyCode) {
				keyCode = keyCode || 40;
				if ([13, 37, 38, 39, 40].indexOf(keyCode) > -1) {
				  forwardTableCell(index, field, keyCode);
				  return;
				}
			  }
			});
		})
		.focus();
	}
	if (vsItem.symbol) {
	  $(ed.target).tooltip({
		position: "top",
		hideEvent: "none",
		deltaY: 10,
		backgroundColor: "rgba(255,255,255,0.8)",
		content: function () {
		  return $("#" + tipId);
		},
		onShow: function (e) {
		  $(this)
			.tooltip("tip")
			.css({
			  backgroundColor: "#fff",
			  left:
				e.clientX -
				e.offsetX -
				($("#" + tipId).width() + 18 - e.target.clientWidth) / 2 +
				"px",
			  top: e.clientY - e.offsetY - 35 + "px",
			});
		},
	  });
	}
  }
  function endEditTableCell(flag) {
	if (curEditorTarget) {
	  var tmpEditorTarget=curEditorTarget;
	  setTimeout(function() {
		// $(tmpEditorTarget).tooltip("hide");
		$(".tooltip").hide();
		$(curEditorTarget).tooltip("show");
	  }, 300);
	}
	var rows = $("#multiVSTable").datagrid("getRows");
	// 结束编辑
	for (var i = 0, len = rows.length; i < len; i++) {
	  e = rows[i];
	  var ed = $("#multiVSTable").datagrid("getEditors", i)[0]; // 获取编辑器
	  if (ed) {
		console.log(ed);
		var colIndex=ed.field.slice(3);
		var colObj = colCodesArr[colIndex];
		var item=colObj.item;
		if (item.indexOf('temperature')>-1) {
		  item=patientList[i]['temp'+colIndex];
		}
		e = singleConfigObj[item];
		console.log(e);
		if (e.select) {
		  var value = $(ed.target).combobox("getValue");
				  if ((''===value)&&("Y"==e.udFlag)) {
					  value=$(ed.target).combobox('textbox').val();
					  $(ed.target).combobox("setValue",value);
				  }
		} else {
		  var value = $(ed.target).val();
		}
		if (e.validate && "" !== value) {
		  var symbol = e.symbol;
		  if (!symbol || symbol.indexOf(value) < 0) {
			if (e.errorValueHightFrom || e.errorValueLowTo) {
			  if (value != parseFloat(value)) {
				$.messager.popover({ msg: "请填写正确的数值！", type: "alert" });
				return false;
				} else if (value.length!=(parseFloat(value)).toString().length) { // 需求号：2627879
				  $.messager.popover({msg: $g('数值小数点后为0不能保存！'),type:'alert'});
				  return false;
			  } else {
							  value=parseFloat(value);
						  }
			  if (value > e.errorValueHightFrom || value < e.errorValueLowTo) {
							  $(ed.target).addClass('error');
				$.messager.popover({
				  msg: "填写的值超出正确范围！",
				  type: "alert",
				});
				return false;
			  }
			}
		  }
		}
		var date = $("#opeTabs").tabs("getSelected").panel("options").title;
			  if (e.yestDesc) {
				  var newDay=Date.parse(standardizeDate(date))-24 * 3600 * 1000;
				  date=formatDate(new Date(newDay));
			  }
		if (item.indexOf('temperature')>-1) {
		  patientList[i][item+colIndex]=value;
		}
		var res = $cm(
		  {
			ClassName: "Nur.NIS.Service.VitalSign.Temperature",
			MethodName: "SaveObsDataByDay",
			dataType: "text",
			episodeID: rows[i].episodeID,
			modifyData: JSON.stringify([
			  {
				code: item,
				value: value,
				time: colObj.time,
			  },
			]),
			userID: session["LOGON.USERID"],
			date: date,
			userLocID: session["LOGON.CTLOCID"],
			wardID: session["LOGON.WARDID"],
		  },
		  false
		);
		if ('-1000'==res) {
		  $('#multiVSTable').datagrid('endEdit', i);
		  applyAuthority(rows[i]);
	  } else if (0==parseInt(res)) {
		  if (res.toString().indexOf('^')>-1) {
			  $.messager.popover({msg: $g(res.split('^')[1]),type:'alert'});
		  }else if (1==flag) {
			  $.messager.popover({msg: $g('数据保存成功'),type:'success'});
		  }
				  if(subScreen) {
					  window.parent.websys_emit("vitalSignChange",{});
				  }
		} else {
		  $.messager.popover({ msg: res.msg, type: "alert" });
		  return false;
		}
		if (2 != flag) {
		  $("#multiVSTable").datagrid("endEdit", i);
		}
		return true;
	  }
	}
	return true;
  }
  function applyAuthority(patientInfo) {
	  var oldOk = $.messager.defaults.ok;
	  var oldNo = $.messager.defaults.no;
	  $.messager.defaults.ok = $g("申请授权");
	  $.messager.defaults.no = $g("取消");
	  var btns = $.messager.confirm($g("提示"), $g("病人已出院，限制操作，请申请出院病历授权"), function (r) {
		  if (true===r) {
			  var url='nur.emr.dischargerecordauthorizeapply.csp?mouldType=SMTZ&regNo='+patientInfo.regNo; 
			  if ("undefined" != typeof websys_getMWToken) {
				url += "&MWToken=" + websys_getMWToken();
			  }
			  window.location.href=url;
		  }
		  /*要写在回调方法内,否则在旧版下可能不能回调方法*/
		  $.messager.defaults.ok = oldOk;
		  $.messager.defaults.no = oldNo;
	  }).children("div.messager-button");
	  btns.children("a.l-btn").css({width:'auto'});
	  $(".window-shadow").map(function (i,obj) {
		  $(obj).css({height:$(obj).prev().height()});
	  });
  }
  function forwardTableCell(index, field, keyCode) {
	var rows = $("#multiVSTable").datagrid("getRows"),
	  row = rows[index];
	var colspan;
	switch (keyCode) {
	  case 38: //上
		if (0 == index) {
		  index = rows.length - 1;
		  if (0 == colIndex) {
			colIndex = colCodesArr.length - 1;
		  } else {
			colIndex--;
		  }
		} else {
		  index--;
		}
		break;
	  case 40: //下
		if (index == rows.length - 1) {
		  index = 0;
		  if (colCodesArr.length - 1 == colIndex) {
			colIndex = 0;
		  } else {
			colIndex++;
		  }
		} else {
		  index++;
		}
		break;
	  case 37: //左
		if (0 == colIndex) {
		  if (0 == index) {
			index = rows.length - 1;
		  } else {
			index--;
		  }
		  colIndex = colCodesArr.length - 1;
		} else {
		  colIndex--;
		}
		break;
	  case 39: //右
		if (colIndex == colCodesArr.length - 1) {
		  colIndex = 0;
		  if (index == rows.length - 1) {
			index = 0;
		  } else {
			index++;
		  }
		} else {
		  colIndex++;
		}
		break;
	  default:
		return;
	}
	field = "col" + colIndex;
	editTableCell(index, field, keyCode);
  }
  function addSymbol(d) {
	console.log(curEditorTarget);
	$(curEditorTarget).val($(curEditorTarget).val() + d);
  }
  function InitTip() {
	  var _content="<p style='white-space: nowrap;'>"+$g("红色框：非有效数据")+"</p>";
	  _content+="<p style='white-space: nowrap;'>"+$g("黄色框：非正常数据")+"</p>";
	$("#vsReminder_tip").popover({
	  trigger: "hover",
	  content: _content,
	  style: "inverse",
	});
  }
  // 标准化日期
  function standardizeDate(day) {
	var y = dateformat.indexOf("YYYY");
	var m = dateformat.indexOf("MM");
	var d = dateformat.indexOf("DD");
	var str =
	  day.slice(y, y + 4) + "/" + day.slice(m, m + 2) + "/" + day.slice(d, d + 2);
	return str;
  }
  // 格式化日期
  function formattingDate(day) {
	var s = dateformat || "YYYY-MM-DD";
	var y = s.indexOf("YYYY");
	var m = s.indexOf("MM");
	var d = s.indexOf("DD");
	s = s.replace("YYYY", day.substr(y, 4));
	s = s.replace("MM", day.substr(m, 2));
	s = s.replace("DD", day.substr(d, 2));
	return s;
  }
  function onPrintBtnClick(blankFlag) {
	  var date=$("#opeTabs").tabs("getSelected").panel("options").title;
	  var printFlag=1;
	  var patCount=0;
	  patientList.map(function (e,i) {
		  var j=i;
		  $cm({
			  ClassName: 'NurMp.Discharge.Authority',
			  MethodName: 'getPatAction',
			  dataType: "text",
			  EpisodeId: e.episodeID,
			  STDate: date,
			  MouldType: "SMTZ",
			  UserID: session['LOGON.USERID'],
			  Action: "print",
		  }, function (data) {
			  data=parseInt(data);
			  printFlag=printFlag&&data;
			  if (1!=data) {
				  $.messager.popover({msg: patientList[j].name+$g('出院病历未对此操作授权。'),type:'alert'});
				  return;
			  }
			  patCount++;
		  });
	  })
	  var paTimer=setInterval(function() {
		  if (!printFlag) clearInterval(paTimer);
		  if (patientList.length==patCount) {
			  clearInterval(paTimer);
			  onPrintBtnClickAfterCheck(blankFlag);
		  }
	  }, 100);
  }
  function onPrintBtnClickAfterCheck(blankFlag) {
	  var measureFlag=$("#needMeasure").checkbox('getValue');
	  var episodeIDArray = [];
	  patientList.forEach(function(row) {
		  episodeIDArray.push(row.episodeID);
	  });
	  var tableStart='<table border="1" width="107%" style="border:solid 1px black;border-collapse:collapse"><thead><tr><th rowspan="2">床号</th><th rowspan="2">姓名</th>';
	  var colLen=10; // 每行显示的列数（不包括固定的2列）
	  var columns=JSON.parse(JSON.stringify(multiColumns));
	  var date=$("#opeTabs").tabs("getSelected").panel("options").title;
	  var tableStr=[];
	  var start=0,end,bigEnd=columns[1].length;
	  columns[0].map(function(c){
		  if (c.time) {
			  bigEnd++;
		  }
	  })
	  while (columns[0].length) {
		  end=Math.min(start+colLen,bigEnd);
		  var count=colLen,table=tableStart,cols=[],col1=[],col2=[];
		  while (count&&columns[0].length) {
			  var colspan=columns[0][0].colspan||1;
			  if (colspan<=count) {
				  count=count-colspan;
				  if (columns[0][0].time) { //colspan是1
					  cols.push(columns[0][0]);
					  col1.push(columns[0][0]);
				  } else {
					  col1.push(columns[0][0]);
					  while (colspan) {
						  var obj=columns[1].shift();
						  cols.push(obj);
						  col2.push(obj);
						  colspan--;
					  }
				  }
				  columns[0].shift();
			  } else {
				  columns[0][0].colspan=colspan-count;
				  var obj=JSON.parse(JSON.stringify(columns[0][0]));
				  obj.colspan=count;
				  col1.push(obj);
				  while (count) {
					  obj=columns[1].shift();
					  cols.push(obj);
					  col2.push(obj);
					  count--;
				  }
			  }
		  }
  
		  col1.map(function(c){
			  table+='<th style="min-width:40px;" colspan="'+(c.colspan||1)+'" rowspan="'+(c.rowspan||1)+'">'+c.title+'</th>';
		  })
		  table+='</tr><tr>';
		  col2.map(function(c){
			  table+='<th style="min-width:40px;">'+c.title+'</th>';
		  })
		  table+='</tr>';
		  patientList.map(function(p,ind){
			  table+='<tr><td>'+p.bedCode+'</td><td>'+p.name+'</td>';
			  for (var i = start; i < end; i++) {
				  if ('undefined'==typeof p['col'+i]) {
					  table+='<td style="background:#e4e4e4!important;"></td>';
				  } else {
			if (multiColumns[1][i].title=='体温') {
			  table+='<td style="min-width:50px;">'+getCurrentTemp("",ind,i)+'</td>';
			} else {
			  table+='<td>'+p['col'+i]+'</td>';
			}
				  }
			  }
			  table+='</tr>';
		  })
		  tableStr.push(table);
  
		  start=start+colLen;
	  }
  
	var style="<style type='text/css'>";
	style+="span.tempBtn{display: inline-block;font-weight: bold;width: 18px;height: 18px;text-align: center;color: green;float: right;}";
	style+="</style>";
  
	  var LODOP = getLodop();
	  LODOP.PRINT_INIT("打印待测患者列表");
	  LODOP.SET_PRINT_PAGESIZE(0, 0, 0, "A4");
	  var pageSize=Math.ceil(episodeIDArray.length/40);
	  for (var i = 0; i < tableStr.length; i++) {
		  if (i) {
			  LODOP.NEWPAGE();
			  for (var j = 1; j < pageSize; j++) {
				  LODOP.NEWPAGE();
			  }
		  }
	  // 纵向
		  // LODOP.ADD_PRINT_TABLE("30mm", "10mm", "185mm", "230mm", tableStr[i]);
	  // 横向
		  LODOP.ADD_PRINT_TABLE("30mm", "10mm", "230mm", "185mm", style+tableStr[i]);
	  }
	  LODOP.ADD_PRINT_TEXT("10mm", 277, 154, 32, "待测患者列表\n");
	  LODOP.SET_PRINT_STYLEA(0, "FontSize", 15);
	  LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
	  LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
	  LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
	  LODOP.ADD_PRINT_TEXT("20mm", "10mm", 100, 25, "待测日期:");
	  LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
	  LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
	  LODOP.ADD_PRINT_TEXT("20mm", "25mm", 100, 25, date);
	  LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
	  LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
	  LODOP.PREVIEW();
  }
  window.addEventListener("click", function () {
	$("#mm").hide();
  });
  function updateDomSize() {
	var innerHeight = window.innerHeight;
	$("#patientList").panel("resize", {
	  height: innerHeight - 93,
	});
	$("#multiVSPanel").panel("resize", {
	  height: innerHeight - 8,
	});
	$("#multiVSTable").datagrid("resize", {
	  height: innerHeight - 132,
	});
  }
  window.addEventListener("resize", updateDomSize);
  