/**   
 * @Title: 知识浏览器 
 * @Description:查看知识
 * @author: 程和贵
 * @Created:  2018-03-26  
 */
var base = "";
var name = 0;
var value = 0;
var precategory = "";
var precategoryflag = 2;  //作属性下拉框的清除标志
var selectTermdr = 0;
var detailWinTitle = "" //详情面板标题
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBKnoManage&pClassMethod=SaveData&pEntityName=web.Entity.MKB.MKBKnoManage";
var PREVIEW_FILE_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBKnoManage&pClassMethod=Webservice";
var selectTermdr = GetURLParams("termdr");
base = GetURLParams("base");
if (base == null) {
	base = $.m({
		ClassName: "web.DHCBL.MKB.MKBTerm",
		MethodName: "GetBaseID",
		flag: "Diagnose"
	}, false);
}
var basedesc = tkMakeServerCall("web.DHCBL.MKB.MKBTerm", "getTermDesc", base)
//判断是列表型还是树形
var basetype = tkMakeServerCall("web.DHCBL.MKB.MKBTerm", "GetBaseTypeByID", base)
var Init = function () {
	if (selectTermdr == null) {
		//$("#dialog").css('height','570px');
		//$("#detailWindow").css('top','60px');
		//$("#detailWindow").css('left','450px');
	}
	//初始化grid
	GetList();
	//导图重新设置标题
	$("#layoutwest").panel("setTitle", basedesc)
	//检索
	SearchData()
	//双击重置搜索框内容
	DbclearContent()
	//重置
	ResetData();
	//删除显示的分页条
	DeletePage();
	//echarts单击
	InitEchatsClick();
	//打开diaglog
	OpenWindow();
	//echarts双击查看详细属性
	DblclickMyChart();
	//初始化术语下拉框
	InitTermBox();
	//导图检索
	$('#search').searchbox({
		searcher: function (value, name) {
			filter(value);
		}
	});

	//知识库选择
	$('#baseSelect').combobox({
		url: $URL + "?ClassName=web.DHCBL.MKB.MKBTermBase&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField: 'MKBTBRowId',
		textField: 'MKBTBDesc',
		panelWidth: 400,
		value: base,
		onSelect: function (o) {
			base = o.MKBTBRowId
			ResetData()
			//初始化grid
			GetList();
			//导图重新设置标题
			$("#layoutwest").panel("setTitle", basedesc)
			//检索
			SearchData()
			//双击重置搜索框内容
			DbclearContent()
			//重置
			ResetData();
			//删除显示的分页条
			DeletePage();
			//echarts单击
			InitEchatsClick();
			//打开diaglog
			OpenWindow();
			//echarts双击查看详细属性
			DblclickMyChart();
			//初始化术语下拉框
			InitTermBox();
		}
	})
}
$(Init);

//创建表单属性内容面板
var CreateDataPanel = function (type, proid) {
	$("#MKBKMDetailI").val("");
	$("#MKBKMDetailI2").val("");
	if (type == "L") {
		//列表型
		TypeOfList(proid);
	} else if (type == "T") {
		//树形
		TypeOfTree(proid);
	} else if ((type == "TA") || (type == "TX") || (type == "C") || (type == "CB") || (type == "R") || (type == "F") || (type == "SD")) {
		TypeOfTxy(proid, type);
	} else if (type == "P") {
		TypeOfPro(proid);
	} else if (type == "S") {
		//引用术语格式属性内容维护模块
		TypeOfTerm(proid);
	} else if (type == "SS") {
		//引用起始节点---石萧伟
		TypeOfSingle(proid);
	} else {
		$("#detail").empty()
	}
}
// 双击查看引用起始节点内容 --树形---石萧伟
var TypeOfSingleWin = function (proid) {
	var datagridHtml = "<div data-options='fit:true,border:false' id='detailSingleWinGrid'></div>";
	$("#detailWindow").empty()
	$("#detailWindow").append(datagridHtml);
	$HUI.tree('#detailSingleWinGrid', {
		url: "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetSourseSingleTermJson&property=" + proid,
		lines: true,  //树节点之间显示线条
		autoSizeColumn: false,
		checkbox: false,
		id: 'id',//这里的id其实是所选行的idField列的值
		cascadeCheck: true,  //是否级联检查。默认true  菜单特殊，不级联操作		
		animate: false,   //是否树展开折叠的动画效果
		onLoadSuccess: function (data) {
		},
		onBeforeExpand: function (node) {
			$(this).tree('expandFirstChildNodes', node)
		},
		onContextMenu: function (e, node) {
			e.preventDefault();
		}

	});
	$("#detailWindow").window({
		title: detailWinTitle,
		collapsible: false,
		minimizable: false,
		onClose: function () {
			$("#MKBKMDetailI").val("");
			$("#MKBKMDetailI2").val("");
			$("#detailSingleWinGrid").treegrid("clearChecked")
		}
	});

}
//表单----引用起始节点----石萧伟
var TypeOfSingle = function (proid) {
	var datagridHtml = "<table id='detailGridTreeSingle' data-options='fit:true,border:false'></table>"
	$("#detail").empty()
	$("#detail").append(datagridHtml);
	//var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetSourseSingleTermJson";	
	//列表datagrid
	$HUI.tree('#detailGridTreeSingle', {
		url: "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetSourseSingleTermJson&property=" + proid,
		lines: true,  //树节点之间显示线条
		autoSizeColumn: false,
		checkbox: false,
		id: 'id',//这里的id其实是所选行的idField列的值
		cascadeCheck: true,  //是否级联检查。默认true  菜单特殊，不级联操作		
		animate: false,   //是否树展开折叠的动画效果
		onLoadSuccess: function (data) {
		},
		onBeforeExpand: function (node) {
			$(this).tree('expandFirstChildNodes', node)
		},
		onContextMenu: function (e, node) {
			e.preventDefault();
		}

	});
}
// 生成树形的columns
var MakeTreeExtendColums = function (proid) {
	//获取扩展属性信息  
	var extendInfo = tkMakeServerCall('web.DHCBL.MKB.MKBTermProDetail', 'getExtendInfo', proid);
	var extend = extendInfo.split("[A]")
	var propertyName = extend[0];  //主列名
	var extendChild = extend[1];  //扩展属性child串
	var extendTitle = extend[2];  //扩展属性名串
	var extendType = extend[3];    //扩展属性格式串
	var extendConfig = extend[4];    //扩展属性配置项串

	//datagrid列
	var columns = [[
		{ field: 'id', title: 'id', width: 80, sortable: true, hidden: true },
		{ field: 'MKBTPDDesc', title: propertyName, width: 150, sortable: true },
		{
			field: 'MKBTPDRemark', title: '备注', width: 150, sortable: true,
			formatter: function (value, row, index) {
				var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
				return content;
			}
		},
		{ field: 'MKBTPDLastLevel', title: '上级分类', width: 150, sortable: true, hidden: true },
		{ field: 'MKBTPDSequence', title: '顺序', width: 150, sortable: true, hidden: true }
	]];

	if (extendChild != "")   //如果有扩展属性，则自动生成列
	{
		var colsField = extendChild.split("[N]");
		var colsHead = extendTitle.split("[N]");
		var typeStr = extendType.split("[N]");
		var configStr = extendConfig.split("[N]");
		for (var i = 0; i < colsField.length; i++) {
			var column = {};
			column["title"] = colsHead[i];
			column["field"] = 'Extend' + colsField[i];
			column["width"] = 150;
			column["hidden"] = true;
			column["sortable"] = true;
			columns[0].push(column)
		}
	}
	return columns;
}

// 表单---属性内容面板-树形
var TypeOfTree = function (proid) {
	var datagridHtml = "<table data-options='fit:true,border:false' id='detailGridTree'></table>"
	$("#detail").empty()
	$("#detail").append(datagridHtml);
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetJsonList";
	//列表datagrid
	var columns = MakeTreeExtendColums(proid);
	$("#detailGridTree").treegrid({
		bodyCls: 'panel-header-gray',
		url: QUERY_ACTION_URL + "&property=" + proid,
		columns: columns,
		idField: 'id',
		//checkbox:true,
		//scrollbarSize:0,
		treeField: 'MKBTPDDesc',  //树形列表必须定义 'treeField' 属性，指明哪个字段作为树节点。
		autoSizeColumn: true,
		animate: false,     //是否树展开折叠的动画效果
		fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort: false,  //定义是否从服务器排序数据。true
		onCheckNode: function () {    //多选 
			var selections = $("#detailGridTree").treegrid("getCheckedNodes");
			var str = ""
			for (var i = 0, len = selections.length; i < len; i++) {
				//$("#detailTreeWinGridGrid").treegrid("checkNode",selections[i].id)
				if (str != "") {
					str = str + "^" + selections[i].id;
				} else {
					str = selections[i].id;
				}
			}
			$("#MKBKMDetailI").val(str)
			var descstr = ""
			for (var i = 0, len = str.split("^").length; i < len; i++) {
				var desc = $.m({ ClassName: "web.DHCBL.MKB.MKBTermProDetail", MethodName: "GetDesc", id: str.split("^")[i] }, false);
				if (descstr != "") {
					descstr = descstr + "^" + desc
				} else {
					descstr = desc
				}
				$("#MKBKMDetailI2").val(descstr)
			}

		},
		onLoadSuccess: function (data) {
			$('.mytooltip').tooltip({
				trackMouse: true,
				onShow: function (e) {
					$(this).tooltip('tip').css({
						width: 250, top: e.pageY + 20, left: e.pageX - (250 / 2)
					});
				}

			});
		}
	});
}
// 生成列表的columns
var MakeListExtendColums = function (proid) {
	//获取扩展属性信息
	var extendInfo = tkMakeServerCall('web.DHCBL.MKB.MKBTermProDetail', 'getExtendInfo', proid);
	var extend = extendInfo.split("[A]")
	var propertyName = extend[0];  //主列名
	var extendChild = extend[1];  //扩展属性child串
	var extendTitle = extend[2];  //扩展属性名串
	var extendType = extend[3];    //扩展属性格式串
	var extendConfig = extend[4];    //扩展属性配置项串
	//datagrid列
	var columns = [[
		{ field: 'ck', checkbox: true },
		{ field: 'MKBTPDRowId', title: 'RowId', width: 80, sortable: true, hidden: true },
		{ field: 'MKBTPDDesc', title: propertyName, width: 150, sortable: true },
		{
			field: 'MKBTPDRemark', title: '备注', width: 150, sortable: true,
			formatter: function (value, row, index) {
				var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
				return content;
			}
		},
		{
			field: 'MKBTPDSequence', title: '顺序', width: 150, sortable: true, hidden: true,
			sorter: function (a, b) {
				if (a.length > b.length) return 1;
				else if (a.length < b.length) return -1;
				else if (a > b) return 1;
				else return -1;
			}
		}
	]];

	if (extendChild != "")   //如果有扩展属性，则自动生成列
	{
		var colsField = extendChild.split("[N]");
		var colsHead = extendTitle.split("[N]");
		var typeStr = extendType.split("[N]");
		var configStr = extendConfig.split("[N]");
		//alert(configStr)
		for (var i = 0; i < colsField.length; i++) {
			var column = {};
			column["title"] = colsHead[i];
			column["field"] = 'Extend' + colsField[i];
			column["width"] = 150;
			column["sortable"] = true;
			columns[0].push(column);

		}
	}
	return columns;
}
//表单 ---列表型的 属性内容
var TypeOfList = function (proid) {
	var datagridHtml = "<table data-options='fit:true,border:false' id='detailGridList'></table>";
	$("#detail").empty()
	$("#detail").append(datagridHtml);
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetMyList";
	var columns = MakeListExtendColums(proid);
	//列表datagrid
	var mygrid = $HUI.datagrid("#detailGridList", {
		bodyCls: 'panel-header-gray',
		url: QUERY_ACTION_URL + "&property=" + proid + "&rows=9999999&page=1",
		columns: columns,
		pagination: false,   //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		singleSelect: false,
		idField: 'MKBTPDRowId',
		fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort: false,  //定义是否从服务器排序数据。true
		sortName: 'MKBTPDSequence',
		sortOrder: 'asc',
		//ctrlSelect:true,
		//checkOnSelect: false,
		//selectOnCheck: true,
		//scrollbarSize:0,
		//checkbox:true,
		onCheck: function () { selectDetail() },
		onUncheck: function () { selectDetail() },
		onLoadSuccess: function (data) {
			$('.mytooltip').tooltip({
				trackMouse: true,
				onShow: function (e) {
					$(this).tooltip('tip').css({
						width: 250, top: e.pageY + 20, left: e.pageX - (250 / 2)
					});
				}

			});
		}
	});
	//设置分页属性
	/*var mypagination = $('#detailGridList').datagrid("getPager");
	   if (mypagination){
		   $(mypagination).pagination({
			  showPageList:false,
			  displayMsg: ''
		   });
	   }*/
	//多条选中行
	var selectDetail = function () {
		var selections = $('#detailGridList').datagrid('getChecked');
		var str = ""
		for (var i = 0, len = selections.length; i < len; i++) {
			//$("#detailListWinGrid").datagrid("selectRecord",selections[i].MKBTPDRowId); 
			if (str != "") {
				str = str + "^" + selections[i].MKBTPDRowId;
			} else {
				str = selections[i].MKBTPDRowId;
			}

		}
		$("#MKBKMDetailI").val(str)
		var descstr = ""
		for (var i = 0, len = str.split("^").length; i < len; i++) {
			var desc = $.m({ ClassName: "web.DHCBL.MKB.MKBTermProDetail", MethodName: "GetDesc", id: str.split("^")[i] }, false);
			if (descstr != "") {
				descstr = descstr + "^" + desc
			} else {
				descstr = desc
			}
			$("#MKBKMDetailI2").val(descstr)
		}
	}
}
//表单---属性内容面板---文本,多行文本,下拉框,表单,单选,多选
// 均以文本展示
var TypeOfTxy = function (proid, type) {
	var tmpdesc = $.m({ ClassName: 'web.DHCBL.MKB.MKBEncyclopedia', MethodName: 'GetDetailDesc', id: proid, type: type }, false);
	var datagridHtml = "<div class='taf' style='width:100%;height:100%;border:false;'>" + tmpdesc + "</div>";
	$("#detail").empty()
	$("#detail").append(datagridHtml);
}
// 表单---属性内容面板---引用属性
var TypeOfPro = function (proid) {
	var datagridHtml = '<table  id="pplist" data-options="fit:true,border:false"></table>'
	$("#detail").empty();
	$("#detail").append(datagridHtml);
	//datagrid列
	var columns = [[
		{ field: 'MKBTPRowId', title: 'RowId', width: 80, hidden: true, resizable: false },
		{ field: 'MKBTPDesc', title: '属性', width: 150, resizable: false },
		{ field: 'MKBTPType', title: '格式', width: 150, resizable: false, hidden: true },
		{
			field: 'MKBTPShowType', title: '展示格式', width: 150, resizable: false,
			formatter: function (v, row, index) {
				if (v == "C") { return "下拉框" }
				if (v == "T") { return "下拉树" }
				if (v == "TX") { return "文本框" }
				if (v == "TA") { return "多行文本框" }
				if (v == "CB") { return "单选框" }
				if (v == "CG") { return "复选框" }
				if (v == "MC") { return "多选下拉框" }
			}
		},
		{
			field: 'MKBTPTreeNode', title: '定义节点', width: 150, resizable: false,
			formatter: function (v, row, index) {
				var showvalue = $.m({ ClassName: "web.DHCBL.MKB.MKBTermProDetail", MethodName: "GetDesc", id: v }, false);
				return showvalue
			}
		}
	]];
	//列表datagrid
	//console.log(columns)
	$HUI.datagrid("#pplist", {
		bodyCls: 'panel-header-gray',
		url: $URL,
		queryParams: {
			ClassName: "web.DHCBL.MKB.MKBTermProDetail",
			QueryName: "GetSelPropertyList",
			property: proid
		},
		columns: columns,
		pagination: false,   //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏
		singleSelect: true,
		idField: 'MKBTPRowId',
		rownumbers: true,    //设置为 true，则显示带有行号的列。
		fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		//scrollbarSize :0,
		onLoadSuccess: function (data) {
			$(this).prev().find('div.datagrid-body').prop('scrollTop', 0);

			$('.mytooltip').tooltip({
				trackMouse: true,
				onShow: function (e) {
					$(this).tooltip('tip').css({
						width: 250, top: e.pageY + 20, left: e.pageX - (250 / 2)
					});
				}

			});
		}
	});
}
// 表单---属性内容面板---引用知识点
var TypeOfTerm = function (proid) {
	var configListOrTree = $.m({ ClassName: "web.DHCBL.MKB.MKBTermProDetail", MethodName: "GetProListOrTree", property: proid }, false);  //引用术语是树形还是列表型
	if (configListOrTree == "T") {
		var datagridHtml = '<table id="dtreeterm" data-options="fit:true,border:false" ></table>';
		$("#detail").empty();
		$("#detail").append(datagridHtml);
		$HUI.tree('#dtreeterm', {
			bodyCls: 'panel-header-gray',
			url: "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetDocSourseTreeJson&property=" + proid,
			lines: true,  //树节点之间显示线条
			autoSizeColumn: true,
			id: 'id',//这里的id其实是所选行的idField列的值
			cascadeCheck: true,  //是否级联检查。默认true  菜单特殊，不级联操作     
			animate: false,   //是否树展开折叠的动画效果 
			onExpand: function (node) {
			},
			onCollapse: function (node) {
			}
		});
	} else {
		var datagridHtml = '<table id="dlistterm" data-options="fit:true,border:false"></table>';
		$("#detail").empty();
		$("#detail").append(datagridHtml);
		//datagrid列
		var columns = [[
			{ field: 'MKBTPDRowId', title: '属性内容表id', width: 80, hidden: true, resizable: false },
			{
				field: 'MKBTPDSequence', title: '顺序', width: 150, sortable: true, hidden: true, resizable: false,
				sorter: function (a, b) {
					if (a.length > b.length) return 1;
					else if (a.length < b.length) return -1;
					else if (a > b) return 1;
					else return -1;
				}
			},
			{ field: 'MKBTRowId', title: 'RowId', width: 80, hidden: true, resizable: false },
			{ field: 'MKBTDesc', title: '描述', width: 150, resizable: false },
			{ field: 'MKBTCode', title: '代码', width: 150, resizable: false }
		]];
		//列表datagrid
		var mygrid = $HUI.datagrid("#dlistterm", {
			bodyCls: 'panel-header-gray',
			url: $URL,
			queryParams: {
				ClassName: "web.DHCBL.MKB.MKBTermProDetail",
				QueryName: "GetSellistTermList",
				property: proid
			},
			columns: columns,
			pagination: false,   //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏
			idField: 'MKBTRowId',
			rownumbers: true,    //设置为 true，则显示带有行号的列。
			fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
			remoteSort: false,  //定义是否从服务器排序数据。true
			sortName: 'MKBTPDSequence',
			sortOrder: 'asc',
			onLoadSuccess: function (data) {
				$('.mytooltip').tooltip({
					trackMouse: true,
					onShow: function (e) {
						$(this).tooltip('tip').css({
							width: 250, top: e.pageY + 20, left: e.pageX - (250 / 2)
						});
					}

				});
			}
			//scrollbarSize :0
		});
	}
}
//双击 导图的属性显示 属性内容
var CreateWinPanel = function (type, proid) {
	detailWinTitle = tkMakeServerCall('web.DHCBL.MKB.MKBTermProperty', 'GetDesc', proid);
	if (type == "L") {
		TypeOfListWin(proid);
	} else if (type == "T") {
		TypeOfTreeWin(proid);
	} else if ((type == "TA") || (type == "TX") || (type == "C") || (type == "CB") || (type == "R") || (type == "F") || (type == "SD")) {
		TypeOfTxyWin(type, proid);
	} else if (type == "P") {
		TypeOfProWin(proid);
	} else if (type == "S") {
		//引用术语格式属性内容维护模块
		TypeOfTermWin(proid);
	} else if (type == "SS") {
		TypeOfSingleWin(proid);
	} else {
		$("#detailWindow").empty();
	}
}
// 属性内容  引用知识点
var TypeOfTermWin = function (proid) {
	var configListOrTree = $.m({ ClassName: "web.DHCBL.MKB.MKBTermProDetail", MethodName: "GetProListOrTree", property: proid }, false);  //引用术语是树形还是列表型
	if (configListOrTree == "T") {
		var datagridHtml = '<table id="treeterm" data-options="fit:true,border:false"></table>';
		$("#detailWindow").empty();
		$("#detailWindow").append(datagridHtml);
		$HUI.tree('#treeterm', {
			bodyCls: 'panel-header-gray',
			url: "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetDocSourseTreeJson&property=" + proid,
			lines: true,  //树节点之间显示线条
			autoSizeColumn: true,
			id: 'id',//这里的id其实是所选行的idField列的值
			cascadeCheck: true,  //是否级联检查。默认true  菜单特殊，不级联操作     
			animate: false,   //是否树展开折叠的动画效果 
			onExpand: function (node) {
			},
			onCollapse: function (node) {
			}
		});
	} else {
		var datagridHtml = '<table id="listterm" data-options="fit:true,border:false"></table>';
		$("#detailWindow").empty();
		$("#detailWindow").append(datagridHtml);
		//datagrid列
		var columns = [[
			{ field: 'MKBTPDRowId', title: '属性内容表id', width: 80, hidden: true, resizable: false },
			{
				field: 'MKBTPDSequence', title: '顺序', width: 150, sortable: true, hidden: true, resizable: false,
				sorter: function (a, b) {
					if (a.length > b.length) return 1;
					else if (a.length < b.length) return -1;
					else if (a > b) return 1;
					else return -1;
				}
			},
			{ field: 'MKBTRowId', title: 'RowId', width: 80, hidden: true, resizable: false },
			{ field: 'MKBTDesc', title: '描述', width: 150, resizable: false },
			{ field: 'MKBTCode', title: '代码', width: 150, resizable: false }
		]];
		//列表datagrid
		var mygrid = $HUI.datagrid("#listterm", {
			bodyCls: 'panel-header-gray',
			url: $URL,
			queryParams: {
				ClassName: "web.DHCBL.MKB.MKBTermProDetail",
				QueryName: "GetSellistTermList",
				property: proid
			},
			columns: columns,
			pagination: false,   //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏
			idField: 'MKBTRowId',
			rownumbers: true,    //设置为 true，则显示带有行号的列。
			fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
			remoteSort: false,  //定义是否从服务器排序数据。true
			sortName: 'MKBTPDSequence',
			sortOrder: 'asc',
			onLoadSuccess: function (data) {
				$('.mytooltip').tooltip({
					trackMouse: true,
					onShow: function (e) {
						$(this).tooltip('tip').css({
							width: 250, top: e.pageY + 20, left: e.pageX - (250 / 2)
						});
					}

				});
			}
			//scrollbarSize :0
		});
	}
	$("#detailWindow").window({
		title: detailWinTitle,
		collapsible: false,
		minimizable: false,
		onClose: function () {
			$("#MKBKMDetailI").val("");
			$("#MKBKMDetailI2").val("");
		}
	});
}
// 属性内容 为引用属性型
var TypeOfProWin = function (proid) {
	var datagridHtml = '<div  id="plist" data-options="fit:true,border:false"></div>'
	$("#detailWindow").empty();
	$("#detailWindow").append(datagridHtml);
	//datagrid列
	var columns = [[
		{ field: 'MKBTPRowId', title: 'RowId', width: 80, hidden: true, resizable: false },
		{ field: 'MKBTPDesc', title: '属性', width: 150, resizable: false },
		{ field: 'MKBTPType', title: '格式', width: 150, resizable: false, hidden: true },
		{
			field: 'MKBTPShowType', title: '展示格式', width: 150, resizable: false,
			formatter: function (v, row, index) {
				if (v == "C") { return "下拉框" }
				if (v == "T") { return "下拉树" }
				if (v == "TX") { return "文本框" }
				if (v == "TA") { return "多行文本框" }
				if (v == "CB") { return "单选框" }
				if (v == "CG") { return "复选框" }
				if (v == "MC") { return "多选下拉框" }
			}
		},
		{
			field: 'MKBTPTreeNode', title: '定义节点', width: 150, resizable: false,
			formatter: function (v, row, index) {
				if (v) {
					var showvalue = $.m({ ClassName: "web.DHCBL.MKB.MKBTermProDetail", MethodName: "GetDesc", id: v }, false);
					return showvalue
				} else {
					return "";
				}
			}
		}
	]];
	$HUI.datagrid("#plist", {
		bodyCls: 'panel-header-gray',
		url: $URL,
		queryParams: {
			ClassName: "web.DHCBL.MKB.MKBTermProDetail",
			QueryName: "GetSelPropertyList",
			property: proid
		},
		//fit:false,
		columns: columns,
		pagination: false,   //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏
		singleSelect: true,
		idField: 'MKBTPRowId',
		rownumbers: true,    //设置为 true，则显示带有行号的列。
		fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		//scrollbarSize :0,
		onLoadSuccess: function (data) {
			$(this).prev().find('div.datagrid-body').prop('scrollTop', 0);
			$('.mytooltip').tooltip({
				trackMouse: true,
				onShow: function (e) {
					$(this).tooltip('tip').css({
						width: 250, top: e.pageY + 20, left: e.pageX - (250 / 2)
					});
				}

			});

		}
	});

	$("#detailWindow").window({
		title: detailWinTitle,
		collapsible: false,
		minimizable: false,
		onClose: function () {
			$("#MKBKMDetailI").val("");
			$("#MKBKMDetailI2").val("");
		}
	});
}
// 双击查看属性内容 --文本,多行文本,下拉框,表单,单选,多选
// 均以文本展示
var TypeOfTxyWin = function (type, proid) {
	var tmpdesc = $.m({ ClassName: 'web.DHCBL.MKB.MKBEncyclopedia', MethodName: 'GetDetailDesc', id: proid, type: type }, false);
	var datagridHtml = "<div class='taf' style='border:false;width:100%;height:100%;scorol'>" + tmpdesc + "</div>";
	$("#detailWindow").empty()
	$("#detailWindow").append(datagridHtml);
	var titlef = function (type) {
		if (type == "TX") {
			return '文本';
		}
		if (type == "TA") {
			return '多行文本';
		}
		if (type == "C") {
			return '下拉框';
		}
		if (type == "CB") {
			return '多选';
		}
		if (type == "R") {
			return '单选';
		}
		if (type == "F") {
			return '表单';
		}
		if (type == "SD") {
			return '表达式';
		}
	}

	$("#detailWindow").window({
		title: detailWinTitle,
		collapsible: false,
		minimizable: false,
		onClose: function () {
			$("#MKBKMDetailI").val("");
			$("#MKBKMDetailI2").val("");
		}
	});
}
// 双击查看属性内容 --树形
var TypeOfTreeWin = function (proid) {
	var datagridHtml = "<table data-options='fit:true,border:false' id='detailTreeWinGrid'> </table>";
	$("#detailWindow").empty()
	$("#detailWindow").append(datagridHtml);
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetJsonList";
	//获取扩展属性信息  
	var columns = MakeTreeExtendColums(proid);
	//树表treegrid
	$("#detailTreeWinGrid").treegrid({
		bodyCls: 'panel-header-gray',
		url: QUERY_ACTION_URL + "&property=" + proid,
		columns: columns,
		idField: 'id',
		//checkbox:true,
		//scrollbarSize:0,
		treeField: 'MKBTPDDesc',  //树形列表必须定义 'treeField' 属性，指明哪个字段作为树节点。
		autoSizeColumn: true,
		animate: false,     //是否树展开折叠的动画效果
		fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort: false,  //定义是否从服务器排序数据。true
		onCheckNode: function () {    //多选 
			var selections = $("#detailTreeWinGrid").treegrid("getCheckedNodes");
			var str = ""
			for (var i = 0, len = selections.length; i < len; i++) {
				$("#detailGridTree").treegrid("checkNode", selections[i].id)
				if (str != "") {
					str = str + "^" + selections[i].id;
				} else {
					str = selections[i].id;
				}
			}
			$("#MKBKMDetailI").val(str)
			var descstr = ""
			for (var i = 0, len = str.split("^").length; i < len; i++) {
				var desc = $.m({ ClassName: "web.DHCBL.MKB.MKBTermProDetail", MethodName: "GetDesc", id: str.split("^")[i] }, false);
				if (descstr != "") {
					descstr = descstr + "^" + desc
				} else {
					descstr = desc
				}
				$("#MKBKMDetailI2").val(descstr)
			}

		},
		onLoadSuccess: function (data) {
			$('.mytooltip').tooltip({
				trackMouse: true,
				onShow: function (e) {
					$(this).tooltip('tip').css({
						width: 250, top: e.pageY + 20, left: e.pageX - (250 / 2)
					});
				}

			});
		}
	});
	$("#detailWindow").window({
		title: detailWinTitle,
		collapsible: false,
		minimizable: false,
		onClose: function () {
			$("#MKBKMDetailI").val("");
			$("#MKBKMDetailI2").val("");
			$("#detailTreeWinGrid").treegrid("clearChecked")
		}
	});

}
// 双击查看属性内容 --列表型
var TypeOfListWin = function (proid) {
	var datagridHtml = "<table data-options='fit:true,border:false' id='detailListWinGrid'></table>";
	$("#detailWindow").empty()
	$("#detailWindow").append(datagridHtml);

	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetMyList";
	//获取扩展属性信息
	var columns = MakeListExtendColums(proid);
	//列表datagrid
	$("#detailListWinGrid").datagrid({
		bodyCls: 'panel-header-gray',
		url: QUERY_ACTION_URL + "&property=" + proid + "&rows=9999999&page=1",
		columns: columns,
		pagination: false,   //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		singleSelect: false,
		idField: 'MKBTPDRowId',
		fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort: false,  //定义是否从服务器排序数据。true
		sortName: 'MKBTPDSequence',
		sortOrder: 'asc',
		//ctrlSelect:true,
		//checkOnSelect: false,
		//selectOnCheck: true,
		//scrollbarSize:0,
		//checkbox:true,
		onCheck: function () { selectDetail() },
		onUncheck: function () { selectDetail() },
		onLoadSuccess: function (data) {
			$('.mytooltip').tooltip({
				trackMouse: true,
				onShow: function (e) {
					$(this).tooltip('tip').css({
						width: 250, top: e.pageY + 20, left: e.pageX - (250 / 2)
					});
				}

			});
		}
	});
	$("#detailWindow").window({
		// content: '<iframe id="thisIframe" name="thisIframe" width="100%" height="100%"  frameborder="0" src=' + link + '></iframe>',
		title: detailWinTitle,
		collapsible: false,
		minimizable: false,
		onClose: function () {
			$("#MKBKMDetailI").val("");
			$("#MKBKMDetailI2").val("");
			$("#detailListWinGrid").datagrid("clearChecked");
		}
	});
	//多条选中行
	var selectDetail = function () {
		var selections = $('#detailListWinGrid').datagrid('getChecked');
		var str = ""
		for (var i = 0, len = selections.length; i < len; i++) {
			var index = $('#detailGridList').datagrid('getRowIndex', selections[i].MKBTPDRowId);
			$("#detailGridList").datagrid("checkRow", index);
			//下列方式也可以
			//$("#detailGridList").datagrid("selectRecord",selections[i].MKBTPDRowId);
			if (str != "") {
				str = str + "^" + selections[i].MKBTPDRowId;
			} else {
				str = selections[i].MKBTPDRowId;
			}
		}
		$("#MKBKMDetailI").val(str)
		var descstr = ""
		for (var i = 0, len = str.split("^").length; i < len; i++) {
			var desc = $.m({ ClassName: "web.DHCBL.MKB.MKBTermProDetail", MethodName: "GetDesc", id: str.split("^")[i] }, false);
			if (descstr != "") {
				descstr = descstr + "^" + desc
			} else {
				descstr = desc
			}
			$("#MKBKMDetailI2").val(descstr)
		}

	}
}
//知识提交功能
var CommitIfo = function () {
	$('#form-save').form('submit', {
		url: SAVE_ACTION_URL,
		onSubmit: function (param) { },
		success: function (data) {
			var data = eval('(' + data + ')');
			if (data.success == 'true') {
				var fileName = $('#MKBKnoPathI').val();
				var pp = fileName.split(".")[fileName.split(".").length - 1];
				if ((pp == "doc") || (pp == "docx") || (pp == "xls") || (pp == "xlsx")) {
					$.ajax({
						url: PREVIEW_FILE_URL,
						method: 'POST',
						data: {
							path: "D:\\DTHealth\\app\\dthis\\web\\scripts\\bdp\\MKB\\Doc\\Kno\\" + fileName
						},
						success: function () {
							/*$.messager.show({ 
							title: '提示消息', 
							msg: '预览文件生成成功', 
							showType: 'show', 
							timeout: 1000, 
							style:{ 
									right: '', 
									bottom: ''
								} 
							})*/
							$.messager.popover({ msg: '预览文件生成成功！', type: 'success', timeout: 1000 });
						}
					});
				}
				/*$.messager.show({ 
					title: '提示消息', 
					msg: '提交成功', 
					showType: 'show', 
					timeout: 1000, 
					style: { 
						right: '', 
						bottom: ''
					} 
				});*/
				$.messager.popover({ msg: '保存成功！', type: 'success', timeout: 1000 });
				// $('#listgrid').datagrid('reload');  // 重新载入当前页面数据 
				$('#dialog').dialog('close'); // close a dialog

			} else {
				var errorMsg = "提交失败！"
				if (data.errorinfo) {
					errorMsg = errorMsg + '<br/>错误信息:' + data.errorinfo
				}
				$.messager.alert('操作提示', errorMsg, "error");
			}
		}
	});
	$('#form-save').form("clear");
	CreateDataPanel("", "");
}
// 双击查看属性内容
var DblclickMyChart = function () {
	var myChart = echarts.init(document.getElementById('main'), 'macarons')
	myChart.on('dblclick', function (param) {
		if (param.data.category == 2) {
			var strs = param.value.split("[AND]")[0].split(",");
			var ci = strs[0];
			var tp = strs[1];
			CreateWinPanel(tp, ci);
			$('#detailWindow').show();
		}
	});
}
// 左侧 中心词 列表
var GetList = function () {
	if (basetype == "T") {
		var columns = [[
			{ field: 'MKBTRowId', title: 'MKBTRowId', width: 80, sortable: true, hidden: true },
			{ field: 'MKBTDesc', title: '中心词', width: 200, sortable: true },
			{ field: 'MKBTSequence', title: '顺序', width: 150, sortable: true, hidden: true },
			{ field: 'MKBTLastLevel', title: '上级节点', width: 80, hidden: true }
		]];
		$("#listgrid").treegrid({
			url: "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetTreeJson&base=" + base,
			columns: columns,  //列信息
			height: $(window).height() - 105,   ///需要设置高度，不然数据展开太多时，列头就滚动上去了。
			idField: 'MKBTRowId',
			ClassName: "web.DHCBL.MKB.MKBTerm", //拖拽方法DragNode存在的类
			treeField: 'MKBTDesc',  //树形列表必须定义 'treeField' 属性，指明哪个字段作为树节点。
			autoSizeColumn: false,
			scrollbarSize: 8,
			ClassTableName: 'User.MKBDiagBrowserT',
			SQLTableName: 'MKB_DiagBrowserT',
			animate: false,     //是否树展开折叠的动画效果
			fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
			remoteSort: false,  //定义是否从服务器排序数据。true
			onClickRow: function (rowIndex, rowData) {
				RefreshSearchData("User.MKBTermMapT" + base, rowData.MKBTRowId, "A", rowData.MKBTDesc)
			},
			onLoadSuccess: function (data) {
				$("#listgrid").treegrid('select', selectTermdr);
				$('.mytooltip').tooltip({
					trackMouse: true,
					onShow: function (e) {
						$(this).tooltip('tip').css({
							width: 250, top: e.pageY + 20, left: e.pageX - (250 / 2)
						});
					}

				});
			},
			onSelect: function (index, row) {
				var echarts_html = $.m({
					ClassName: "web.DHCBL.MKB.MKBDiagBrowser",
					MethodName: "DataCreat",
					id: row.MKBTRowId,
					base: base
				}, false)
				$("#main").append(echarts_html);
			}
		});
	} else {
		var columns = [[{
			field: 'MKBTDesc',
			title: '中心词',
			width: 100
		}, {
			field: 'MKBTRowId',
			title: 'MKBTRowId',
			hidden: true
		}]];
		$("#listgrid").datagrid({
			url: $URL,   //QUERY_ACTION_URL
			queryParams: {
				ClassName: "web.DHCBL.MKB.MKBTerm",
				QueryName: "GetList",
				'base': base,
				'rowid': selectTermdr
			},
			width: '100%',
			height: '100%',
			displayMsg: "",  //显示信息	显示 {from} 到 {to} ,从 {total} 条记录
			showPageList: "", //是否显示翻页条上的下拉行列表
			showRefresh: false, //是否显示翻页条上的刷新按钮	true	
			pagination: true,
			fitColumns: true,
			ClassTableName: 'User.MKBDiagBrowserL',
			SQLTableName: 'MKB_DiagBrowserL',
			//loadMsg: '数据装载中......',
			autoRowHeight: true,
			singleSelect: true,
			pageSize: PageSizeMain,
			idField: 'MKBTRowId',
			fit: true,
			remoteSort: false,
			columns: columns,
			onLoadSuccess: function (data) {
				if (selectTermdr == null) {
					setTimeout(function () { $("#listgrid").datagrid('selectRow', 0); }, 100);//默认选择第一条
				} else {
					setTimeout(function () { $("#listgrid").datagrid('selectRecord', selectTermdr); }, 100);

				}
				$(this).datagrid('columnMoving');

				$('.mytooltip').tooltip({
					trackMouse: true,
					onShow: function (e) {
						$(this).tooltip('tip').css({
							width: 250, top: e.pageY + 20, left: e.pageX - (250 / 2)
						});
					}

				});
			},
			onLoadError: function () { },
			onSelect: function (index, row) {
				$('body').find('.window').each(function () {
					$(this).css('display', 'none')
				})
				$('body').find('.window-shadow').each(function () {
					$(this).css('display', 'none')
				})

				$("#detail").empty();
				var echarts_html = $.m({
					ClassName: "web.DHCBL.MKB.MKBDiagBrowser",
					MethodName: "DataCreat",
					id: row.MKBTRowId,
					base: base
				}, false)
				$("#main").append(echarts_html);
				$("#main_1").html("节点关系展示区");
				RefreshSearchData("User.MKBTermMapL" + base, row.MKBTRowId, "A", row.MKBTDesc);
			}
		});
	}
}
// 删除显示的分页条
var DeletePage = function () {
	$('select.pagination-page-list').remove();
	//设置分页属性 有bug 分页工具栏都莫名消失了
	/*var mypagination = $('#listgrid').datagrid("getPager");
	   if (mypagination){
		   $(mypagination).pagination({
			  showPageList:false,
			  showRefresh:true,
			  displayMsg: ''
		   });
	   }*/
}
//清空输入框
var DbclearContent = function () {
	$(document).dblclick(function () {
		//$('#searchbox').searchbox('reset');作用同下
		$('#searchbox').searchcombobox('setValue', "");
	});
}
// 左侧检索
var SearchData = function () {
	if (basetype == "L") {
		$("#searchbox").searchcombobox({
			url: $URL + "?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename=" + "User.MKBTermMapL" + base,
			onSelect: function () {
				$(this).combobox('textbox').focus();
				SearchFunLib()

			}
		});
	} else {
		$("#searchbox").searchcombobox({
			url: $URL + "?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename=" + "User.MKBTermMapT" + base,
			onSelect: function () {
				$(this).combobox('textbox').focus();
				SearchFunLib()

			}
		});
	}
	$("#searchbox").combobox('textbox').bind('keyup', function (e) {
		if (e.keyCode == 13) {
			SearchFunLib()
		}
	});
	$("#btnSearch").click(function (e) {
		SearchFunLib();
	})
	SearchFunLib = function () {
		var desc = $("#searchbox").combobox('getText');
		if (basetype == "L") {
			$('#listgrid').datagrid('load', {
				ClassName: "web.DHCBL.MKB.MKBTerm",
				QueryName: "GetList",
				desc: desc,
				base: base
			});
		} else {
			$("#listgrid").treegrid("search", desc);
			$('#listgrid').treegrid('unselectAll');

		}
	}
}
// 左侧重置
var ResetData = function () {
	$("#btnReset").click(function (e) {
		if (basetype == "L") {
			$('#listgrid').datagrid('load', {
				ClassName: "web.DHCBL.MKB.MKBTerm",
				QueryName: "GetList",
				'base': base
			});
			//$('#listgrid').datagrid('unselectAll');
		} else {
			$('#listgrid').treegrid('load', {
				ClassName: "web.DHCBL.MKB.MKBTerm",
				QueryName: "GetTreeJson",
				'base': base
			});
			//$('#listgrid').treegrid('unselectAll');
		}
		$('#searchbox').searchcombobox('setValue', "");
	})
}
// 知识提交window
var OpenWindow = function () {
	$("#commit").click(function (e) {
		$("#dialog").show();
		var termRowId = $("#listgrid").datagrid("getSelected").MKBTRowId;
		if (basetype == "L") {
			$("#termbox").combobox("setValue", termRowId);
		} else {
			$("#termbox").combotree("setValue", termRowId);
		}
		var url = $URL + "?ClassName=web.DHCBL.MKB.MKBTermProperty&QueryName=GetList&ResultSetType=array&termdr=" + termRowId;
		$('#probox').combobox("reload", url);
		if ((precategory == 2) & (precategoryflag == 2)) {
			var proid = parseInt(value.split("[AND]")[0].split(',')[0]);
			if (isNaN(proid)) {
				proid = ""
			}
			$("#probox").combobox("setValue", proid);
		} else {
			$('#probox').combobox('clear');
		}
		var autoCode = $.m({ ClassName: "web.DHCBL.MKB.MKBKnoManage", MethodName: "GetLastCode" }, false);
		$("#MKBKnoCodeI").val(autoCode);
		$("#dialog").dialog({
			//iconCls:'icon-save',
			resizable: true,
			iconCls: 'icon-textbook',
			title: "知识提交",
			modal: true,
			buttons: [{
				text: '提交',
				//  iconCls:'icon-ok',
				handler: function () {
					//提交表单
					var fileflag = $('#MKBKnoPathI').val();
					if (!!fileflag) {
						CommitIfo();
					} else {
						$.messager.alert('提示', '请先上传文件再提交', 'info');
						return
					}

				}
			}, {
				text: '关闭',
				// iconCls:'icon-no',
				handler: function () {
					// $('#DetailIframe').attr("src","");
					$("#dialog").dialog("close");
					$('#form-save').form("clear");
					//CreateDataPanel("",""); 
					//$("#probox").combobox("setValue","");
					$('#probox').combobox('clear');
				}
			}]
		})
		precategoryflag = -1;
	})
}
//右侧图谱检索
var filter = function (value) {
	var str = value.toUpperCase()//document.getElementById("search").value.toUpperCase(); 
	var chart = echarts.getInstanceByDom(document.getElementById("main"));
	var options = chart.getOption()
	var data = options.series[0].data
	//console.log(data[0])
	var PYCode = Pinyin.GetJPU(str)  //检索条件的拼音
	for (var i = 1; i < data.length; i++) {
		if (data[i].category == 1 || data[i].category == -2) {
			if (data[i].name.toUpperCase().indexOf(str) == -1 && Pinyin.GetJPU(data[i].name.toUpperCase()).indexOf(PYCode) == -1) {
				options.series[0].data[i].category = -2;
			}
			else {
				options.series[0].data[i].category = 1;
			}
		}
		if (data[i].category == 2 || data[i].category == -3) {
			if (data[i].name.toUpperCase().indexOf(str) == -1 && Pinyin.GetJPU(data[i].name.toUpperCase()).indexOf(PYCode) == -1) {
				options.series[0].data[i].category = -3;

			}
			else {
				options.series[0].data[i].category = 2;

			}
		}
	}
	chart.setOption(options);
}
//初始化 图谱
var InitEchatsClick = function () {
	var myChart = echarts.init(document.getElementById('main'), 'macarons')
	var preid = "";
	myChart.on('click', function (param) {
		var tempdata = param.data;
		name = tempdata.name;
		if (param.data.category == 0) {
			return;
		} else {
			value = tempdata.value;
		}
		typecategory = tempdata.category
		//dataid=tempdata.id;
		var options = myChart.getOption();
		var series = options.series[param.seriesIndex];
		var id = param.data.id;
		if (preid != "") {
			if (precategory == 1) {
				series.data[preid].itemStyle.normal.color = "#60C0DD";
				series.data[id].itemStyle.normal.color = "#CC3366";
			}
			if (precategory == 2) {

				series.data[preid].itemStyle.normal.color = "#B6A2DE";
				series.data[id].itemStyle.normal.color = "#CC3366";
			}
			precategoryflag = 2
		}
		else {
			series.data[id].itemStyle.normal.color = "#CC3366";
		}
		preid = param.data.id;
		precategory = param.data.category;
		myChart.setOption(options);
		CreateDataPanel(value.split("[AND]")[0].split(",")[1], value.split("[AND]")[0].split(",")[0]);
	})
}
// 知识点下拉框
var InitTermBox = function () {
	if (basetype == "L") {
		$("#termbox").combobox({
			//url: $URL+"?ClassName=web.DHCBL.MKB.MKBTerm&QueryName=GetList&ResultSetType=array&base="+base,
			url: $URL + "?ClassName=web.DHCBL.MKB.MKBKnoExpression&QueryName=GetListTerm&ResultSetType=array&base=" + base,
			valueField: 'MKBTRowId',
			textField: 'MKBTDesc',
			onSelect: function (rec) {
				var url = $URL + "?ClassName=web.DHCBL.MKB.MKBTermProperty&QueryName=GetList&ResultSetType=array&termdr=" + rec.MKBTRowId;
				$('#probox').combobox({ url: url });
				CreateDataPanel("", "");
			},
			keyHandler: {
				enter: function () {
					var desc = $.trim($('#termbox').combobox('getText'));
					$('#termbox').combobox('reload', $URL + "?ClassName=web.DHCBL.MKB.MKBTerm&QueryName=GetList&ResultSetType=array&base=" + base + "&desc=" + encodeURI(desc));
					$('#termbox').combobox("setValue", desc);
				}
			}
		});
	} else {
		$HUI.combotree('#termbox', {
			url: "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetJsonDataForCmb&base=" + base,
			onSelect: function (node) {
				var url = $URL + "?ClassName=web.DHCBL.MKB.MKBTermProperty&QueryName=GetList&ResultSetType=array&termdr=" + node.id;
				$('#probox').combobox({ url: url });
				CreateDataPanel("", "");
			}
		});
	}
	$("#probox").combobox({
		valueField: 'MKBTPRowId',
		textField: 'MKBTPDesc',
		onSelect: function (rec) {
			CreateDataPanel(rec.MKBTPType, rec.MKBTPRowId);
		},
		keyHandler: {
			enter: function () {
				var desc = $.trim($('#probox').combobox('getText'));
				var termdr = $('#termbox').combobox("getValue");
				$('#probox').combobox('reload', $URL + "?ClassName=web.DHCBL.MKB.MKBTermProperty&QueryName=GetList&ResultSetType=array&termdr=" + termdr + "&desc=" + encodeURI(desc));
				$('#probox').combobox("setValue", desc);
			}

		}
	})
}