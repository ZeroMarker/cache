var GV = {
	_CALSSNAME: "Nur.NIS.Service.ReportV2.ConfigService",
};
var PageLogicObj={
	defaultHosId : "2",
	connectionLocList : [],
	emrTemplateList : []
}
$.extend($.fn.datagrid.methods, {
  getEditingRowIndexs: function(jq) {
    var rows = $.data(jq[0], "datagrid").panel.find('.datagrid-row-editing');
    var indexs = [];
    rows.each(function(i, row) {
      var index = row.sectionRowIndex;
      if (indexs.indexOf(index) == -1) {
          indexs.push(index);
      }
    });
    return indexs;
  }
});
$(function () {
	// 加载全部科室数据
	initCondition(PageLogicObj.defaultHosId);
	var resultLocData = $cm({
	    ClassName:GV._CALSSNAME,
	    MethodName:"NurseCtloc",
	    hospitalId:$("#_HospList").combobox("getValue")
	},false);
	PageLogicObj.connectionLocList=resultLocData
	// 加载病历模板
	var resultEmrData = $cm({
	    ClassName:GV._CALSSNAME,
	    MethodName:"GetEmrTemplateList",
	    hospitalId:$("#_HospList").combobox("getValue")
	},false);	
	PageLogicObj.emrTemplateList=resultEmrData
		
	setDataGridLoad(PageLogicObj.defaultHosId, "1"); // 加载列表数据
	SearchGridLoadInit("1")
	ResetDomSize();
});

// 查询
$("#search").click(function () {
	refresh();
});
//页面
window.addEventListener("resize", ResetDomSize);


function refresh()
{	
	var value = $("#_HospList").combobox("getValue");
	var HospitalId = value ? value : "";			
	// 重载病历模板
	//reloadEmrData(HospitalId);
	//同步重载病历模板
	PageLogicObj.emrTemplateList=$cm({
		ClassName:GV._CALSSNAME,
		MethodName:"GetEmrTemplateList",
		hospitalId:HospitalId
	},false);
	PageLogicObj.connectionLocList=$cm({
	    ClassName:GV._CALSSNAME,
	    MethodName:"NurseCtloc",
	    hospitalId:HospitalId
	},false);
	//重新加载病历模板后再重载表格
	setDataGridLoad(HospitalId, "");
	$('#appendReport').linkbutton("enable");
	SearchGridLoadInit("");

}
/**
 * @description 异步重载病历模板
 */
function reloadEmrData(HospitalId)
{
	$cm({
		ClassName:GV._CALSSNAME,
		MethodName:"GetEmrTemplateList",
		hospitalId:HospitalId
	},function(result){
		PageLogicObj.emrTemplateList=result
	});
}
/**
 * @description 初始化查询条件区
 */
function initCondition(defaultHosId) {
  /*
  $("#_HospList").combobox({
    url:
      $URL +
      "?1=1&ClassName=" +
      GV._CALSSNAME +
      "&QueryName=GetHospitalList&ResultSetType=array",
    valueField: "HospitalId",
    textField: "HospitalDesc",
    defaultFilter: 4,
    onLoadSuccess: function () {
      $("#_HospList").combobox("setValue", PageLogicObj.defaultHosId); // 设置默认医院
    },
  });
  */
  
    try
	{
		// 多院区
		var sessionInfo = session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"];
		var hospComp = GenHospComp("Nur_IP_Question",sessionInfo);
		hospComp.jdata.options.onSelect = function(e,t){
			refresh();
		}
		hospComp.jdata.options.onLoadSuccess= function(data){

		}
	}catch(ex)
	{
	  // 兼容老项目，非多院区的场景
	  $("#_HospList").combobox({
	    url:
	      $URL +
	      "?1=1&ClassName=" +
	      GV._CALSSNAME +
	      "&QueryName=GetHospitalList&ResultSetType=array",
	    valueField: "HospitalId",
   		textField: "HospitalDesc",
	    defaultFilter: 4,
	    width:250,
	    value:(session['LOGON.HOSPID']||PageLogicObj.defaultHosId),
	    onSelect:function(e,t){
		    refresh();
		},
		onLoadSuccess:function(data){

		}
	  });
	}
}

// 列表数据加载
function setDataGridLoad(HospitalId, flag) {
	if (flag==1)
	{
		$("#appendReport").click(function () {
			addReportConfig();
			$('#appendReport').linkbutton("disable");
		}).linkbutton({ iconCls: "icon-add", plain: true });
		$("#saveReport").click(function () {
			saveReportConfig();
		}).linkbutton({ iconCls: "icon-save", plain: true });
		$("#deleteReport").click(function () {
			delReportConfig();
		}).linkbutton({ iconCls: "icon-cancel", plain: true });
	}

	var tmpRowData = undefined;
	var defaultPageSize = 25;
	var defaultPageList = [25, 50, 100, 200, 500];
	var setColumns = [[
	{ field: 'rowId',hidden: true },
	{ field: 'connectLocIds', hidden: true  },
	{ field: "templateId", hidden: true },
	{ field: "name", title: "录入模板", width: 250, 
		editor: {
				type: "combobox",
				options: {
					valueField: "id",
					textField: "desc",
					defaultFilter: 4,
					multiple:false,
					selectOnNavigation:false,
					data:PageLogicObj.emrTemplateList,
					/*
					data:$cm({
						ClassName:GV._CALSSNAME,
						MethodName:"GetEmrTemplateList",						
						hospitalId:$("#_HospList").combobox("getValue")?$("#_HospList").combobox("getValue"):""
						},false),
					*/
					filter: function(q, row){        //本地数据进行数据检索  q是自带的参数名称   如果是remote前端是不需要操作后台自动返回
			            var opts = $(this).combobox('options');
			            var dbval = row[opts.textField] + ""
			            return dbval.indexOf(q) > -1;
			        }
				},
			},
			formatter:function(v,row,index){
				// var resultdesc = getComboboxText(emrTemplateList,row.name)
				return row.name;
			}
	},
	{ field: "shortName", title: "模板简称", width: 80, editor: "validatebox" },
	{ field: "dateItem", title: "日期Item", width: 120, editor: "validatebox",
		// 2022.1.10 日期超长换行处理
		formatter:function(v,row,index){
			 return '<span style="word-break:break-all;">'+v+'</span>';		
		}
	},
	{ field: "scoreItem", title: "分值Item", width: 80, editor: "validatebox" },
	{ field: "connectLocs", title: "关联科室", width: 200, 
		editor: {
				type: "combobox",
				options: {
					valueField: "id",
					textField: "desc",
					defaultFilter: 4,
					multiple:true,
					rowStyle:'checkbox',
					selectOnNavigation:false,
					data:PageLogicObj.connectionLocList
				},
			},
			formatter:function(v,row,index){ 
				var resultdesc = getComboboxText(PageLogicObj.connectionLocList,row.connectLocs)
				return resultdesc;
			}
	},
	{ field: "sortNo", title: "排序", width: 40, editor: "validatebox" }
	]];
	$("#reportList").datagrid({
		url: $URL,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		//pageSize: defaultPageSize,
		//pageList: defaultPageList,
		queryParams: {
			ClassName: GV._CALSSNAME,
			QueryName: "GetTemplateList",
			HospitalId: HospitalId
		},
		fit: true,
		fitColumns: true,
		columns: setColumns,
		rownumbers: true,
		singleSelect: true,
		nowrap:false,
		loadMsg: "加载中..",
		onDblClickCell: function (index, field, value) {
			if (endEditing()) {
				// 设置回显
				setLocValues(index);
				
				$("#reportList")
				.datagrid("selectRow", index)
				.datagrid("beginEdit", index);
				editIndex = index;
			}
		},
		onClickRow: function (rowIndex, rowData) {
			GetReportConfig();
		},
		onLoadSuccess:function(){
			//$(this).datagrid('enableDnd');
		},
		onBeforeEdit: function (index, row) {
             tmpRowData = row;
         },
		//拖拽行 onDrop:function(targetRow,sourceRow,point){}
	});
}

function getComboboxText(datalist,values)
{
	var re = /^[0-9]+.?[0-9]*/;
	var res = ""
	if (values && values != "")
	{
		var arr = values.split(",");
		var oneval = values.split(",")[0]
		// 数值
		if (re.test(oneval))
		{
			for (j=0;j<arr.length;j++)
			{
				var sval = arr[j]
				for (i=0;i<datalist.length;i++)
				{
					var obj = datalist[i]
					if (sval == obj.id)
					{
						if (res=="")
						{
							res = obj.desc
						}else
						{
							res = res+","+obj.desc	
						}
					}
				}
			}
		}else
		{
			res = values;	
		}
	}
	return res;
}

function refreshLocData()
{
	var ed1 = $('#reportList').datagrid('getEditor', {index:editIndex,field:'connectLocIds'});
	var val=$(ed1.target).val();
	var ed = $('#reportList').datagrid('getEditor', {index:editIndex,field:'connectLocs'});
	$(ed.target).combobox('setValues',val.split("^"));	
}

function setLocValues(rowIndex)
{
	var selectedRow = $("#reportList").datagrid('getSelected');
	$('#reportList').datagrid('beginEdit', rowIndex); // 开始编辑
	var ed = $('#reportList' ).datagrid( 'getEditor',{index:rowIndex,field:'connectLocs'});
	$(ed.target).combobox('setValues',selectedRow.connectLocIds.split("^"));
	$('#reportList').datagrid('endEdit', rowIndex); // 结束编辑	
}

// 判断选择报表
function checkSelectReportRow() {
	var id = getSelectRowId();
	if (id == "") {
		$.messager.popover({ msg: "请选择报表！", type: "error" });
		return false;
	}
	return true;
}

// 获取选择的症状
function getSelectRowId() {
	var selectId = "";
	var rows = $("#reportList").datagrid("getSelections");
	if (rows.length > 0) {
		var selectId = rows[0].rowId;
	}
	return selectId;
}

// 右侧列表数据加载
function SearchGridLoadInit(flag) {
	if (flag == 1)
	{
		$("#appendSearch").click(function () {
		addSearchConfig();
		}).linkbutton({ iconCls: "icon-add", plain: true });
		$("#saveSearch").click(function () {
			saveSearchConfig();
		}).linkbutton({ iconCls: "icon-save", plain: true });
		$("#deleteSearch").click(function () {
			delSearchConfig();
		}).linkbutton({ iconCls: "icon-cancel", plain: true });
	}
	
	var setColumns = [[
			{ field: 'rowId', title: 'rowId',hidden: true },
			{ field: "conditionDesc", title: "评分描述", width: 100, editor: "validatebox"},
			{ field: "conditionExp", title: "评分公式", width: 100, editor: "validatebox" },
			{ field: "recordFlag", title: "统计模式", width: 100, 
				editor: {
						type: "combobox",
						options: {
							valueField: "id",
							textField: "desc",
							defaultFilter: 4,
							multiple:false,
							rowStyle:'checkbox',
							selectOnNavigation:false,
							editable:false,
							data:[{"id":"R","desc":"R"},{"id":"P","desc":"P"}]
						},
					}
			},
			{ field: "sortNo", title: "排序", width: 50, editor: "validatebox" }
	]];
	$("#searchList").datagrid({
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		fit: true,
		fitColumns: true,
		columns: setColumns,
		rownumbers: true,
		singleSelect: true,
		loadMsg: "加载中..",
		url:$URL,
		queryParams: {
			ClassName: GV._CALSSNAME,
			QueryName: "GetSubCfgList",
			pafRowId: "",
		},
		onDblClickCell: function (index, field, value) {
			if (endEditing2()) {
				$("#searchList")
				.datagrid("selectRow", index)
				.datagrid("beginEdit", index);
				editIndex2 = index;
			}
		}
	});
}

// 获取报表配置数据
function GetReportConfig()
{
	var rows = $("#reportList").datagrid("getSelections");
	if (rows.length == 1) {
		InitSearchGridLoad(rows[0].rowId);
	}
}

// 关联检索条件列表数据加载
function InitReportGridLoad() {
	var value = $("#_HospList").combobox("getValue");
	var HospitalId = value ? value : PageLogicObj.defaultHosId
	setDataGridLoad(HospitalId, ""); 
	$('#appendReport').linkbutton("enable");
	/*
	$cm({
	    ClassName:GV._CALSSNAME,
	    MethodName:"GetReportList",
	    HospitalId: HospitalId,
	},function(jsonData){
	    $("#reportList").datagrid("loadData", Data);
	});
	*/
	
	/*
	$.q(
		{
		ClassName: GV._CALSSNAME,
		QueryName: "GetReportList",
		HospitalId: HospitalId,
		Pagerows: $("#reportList").datagrid("options").pageSize,
		rows: 99999,
		},
		function (Data) {
			$("#reportList").datagrid("loadData", Data);
		}
	);
	*/
}

// 关联检索条件列表数据加载
function InitSearchGridLoad(pafRowId) {
	$.q(
		{
		ClassName: GV._CALSSNAME,
		QueryName: "GetSubCfgList",
		pafRowId: pafRowId,
		Pagerows: $("#searchList").datagrid("options").pageSize,
		rows: 99999,
		dataType: "json",
		},
		function (Data) {
			$("#searchList").datagrid("loadData", Data);
		}
	);
}

var editIndex = undefined;
function endEditing() {
	if (editIndex == undefined) {
		return true;
	}
	if ($("#reportList").datagrid("validateRow", editIndex)) {
		$("#reportList").datagrid("endEdit", editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
//报表配置数据添加
function addReportConfig() {
	$("#reportList").datagrid("appendRow", { status: "P" });
	editIndex = $("#reportList").datagrid("getRows").length - 1;
	$("#reportList").datagrid("selectRow", editIndex)
	.datagrid("beginEdit", editIndex);
}

function isNumber(str)
{
   // 数字验证！
   var reg = new RegExp("^[0-9]*$");
   if(reg.test(str)){
   		return true;
   }
   return false;
}
//报表配置数据保存
function saveReportConfig() {
	var value = $("#_HospList").combobox("getValue");
	var hospitalId = value ? value : PageLogicObj.defaultHosId
	var index=$('#reportList').datagrid('getEditingRowIndexs')[0];
	if (undefined===index) return true;
	var curRow=$('#reportList').datagrid('getRows')[index];
	var rowEditors=$('#reportList').datagrid('getEditors',index);
	var rowId=curRow.rowId||'';
	var newTempId=$(rowEditors[0].target).combobox('getValue');
    if (!newTempId) newTempId=$(rowEditors[0].target).combobox('getText');
	var templateId = newTempId;
	var shortName=$(rowEditors[1].target).val();
	var dateItem=$(rowEditors[2].target).val();
	var scoreItem=$(rowEditors[3].target).val();
	var connectLocs=$(rowEditors[4].target).combobox('getValues').join();
	var sortNo=$(rowEditors[5].target).val();
	$cm(
		{
			ClassName: GV._CALSSNAME,
			MethodName: "SaveTemplateInfo",
			dataType: "text",
			hospitalId:hospitalId,
			rowId: rowId,
			templateId:templateId,
			shortName:shortName,
			dateItem:dateItem,
			scoreItem:scoreItem,
			connectLocs:connectLocs,
			sortNo:sortNo
		},
		function (result) {
			if (result == 0) {
				endEditing();
				$.messager.popover({ msg: "保存成功！", type: "success" });
				InitReportGridLoad()
			} else {
				$.messager.popover({ msg: $g(result), type: "error" });
			}
		}
	);
}
//报表配置数据删除
function delReportConfig() {
var rows = $("#reportList").datagrid("getSelections");
if (rows.length == 1) {
	$.messager.confirm("删除", "确定删除吗?", function (r) {
	if (r) {
			var rowId = rows[0].rowId;
			$.m(
			{
				ClassName: GV._CALSSNAME,
				MethodName: "DeleteReportInfo",
				rowId: rowId,
			},
			function testget(result) {
				//$("#add-dialog").dialog( "close" );
				if (result == "0") {
					$.messager.alert("简单提示", "删除成功！", "success");
					InitReportGridLoad()
				} else {
				$.messager.alert("简单提示", "删除失败！", "error");
				}
			}
			);
	 	}
		});
	} else {
		$.messager.alert("简单提示", "请选择要删除的数据", "info");
	}
}

	var editIndex2 = undefined;
function endEditing2() {
	if (editIndex2 == undefined) {
		return true;
	}
	if ($("#searchList").datagrid("validateRow", editIndex2)) {
		$("#searchList").datagrid("endEdit", editIndex2);
		editIndex2 = undefined;
		return true;
	} else {
		return false;
	}
}
//检索条件配置数据添加
function addSearchConfig() {
	if (checkSelectReportRow())
	{
		$("#searchList").datagrid("appendRow", { status: "P" });
		editIndex2 = $("#searchList").datagrid("getRows").length - 1;
		$("#searchList").datagrid("selectRow", editIndex2)
		.datagrid("beginEdit", editIndex2);
	}
}

// 判断str是否全角字符
function isFullWidth(str) {
    var reg = /[^\x00-\xff]/g;
    return reg.test(str);
}

// 判断str是否包含一个或多个字母
function isAlphabet(str) {
    var reg = /[a-zA-Z]/g;
    return reg.test(str);
}

//检索条件配置数据保存
function saveSearchConfig() {
if (endEditing2()) {
	var dataSourceRow = $("#searchList").datagrid("getSelected");
	var parentId = getSelectRowId()
	var conditionDesc = dataSourceRow.conditionDesc;
	var conditionExp = dataSourceRow.conditionExp;
	// 全角或中文校验
	if (isFullWidth(conditionExp))
	{
		$.messager.popover({ msg: "评分公式不能输入全角字符！", type: "error" });
		return;
	}
	// 字母校验
	if (isAlphabet(conditionExp))
	{
		$.messager.popover({ msg: "评分公式不能输入字母！", type: "error" });
		return;
	}
	var sortNo = dataSourceRow.sortNo;
	var rowId = dataSourceRow.rowId;
	var recordFlag = dataSourceRow.recordFlag
	$m(
		{
			ClassName: GV._CALSSNAME,
			MethodName: "SaveConditionInfo",
			rowId: rowId,
			parentId:parentId,
			conditionDesc: conditionDesc,
			conditionExp: conditionExp,
			recordFlag:recordFlag,
			sortNo: sortNo
		},
		function (result) {
			if (result == 0) {
				$.messager.popover({ msg: "保存成功！", type: "success" });
				InitSearchGridLoad(parentId)
			} else {				
				$.messager.popover({ msg: result, type: "error" });
				InitSearchGridLoad(parentId)
			}
		}
	);
  }
}

//检索条件配置数据删除
function delSearchConfig() {
	var rows = $("#searchList").datagrid("getSelections");
	if (rows.length == 1) {
		$.messager.confirm("删除", "确定删除吗?", function (r) {
		if (r) {
			var rowId = rows[0].rowId;
			$.m(
			{
				ClassName: GV._CALSSNAME,
				MethodName: "DeleteConditionInfo",
				rowId: rowId,
			},
			function testget(result) {
				//$("#add-dialog").dialog( "close" );
				if (result == "0") {
					$.messager.alert("简单提示", "删除成功！", "success");
					var reportId = getSelectRowId()
					InitSearchGridLoad(reportId)
				} else {
				$.messager.alert("简单提示", "删除失败！", "error");
				}
			}
			);
	 	}
		});
	} else {
		$.messager.alert("简单提示", "请选择要删除的数据", "info");
	}
}
function ResetDomSize() {
    $(".hisui-layout").layout("resize").layout('panel', 'center').panel('resize', {
        height: '100%',
        width: '100%'
    });
    //var east = $(".hisui-layout").layout('panel', 'center').layout('panel', 'east');
    //var center =  $(".hisui-layout").layout('panel', 'center').layout('panel', 'center');
}
/**
 * linkbutton方法扩展
 * @param {Object} jq
 */
$.extend($.fn.linkbutton.methods, {
    /**
     * 激活选项（覆盖重写）
     * @param {Object} jq
     */
    enable: function(jq){
        return jq.each(function(){
            var state = $.data(this, 'linkbutton');
            if ($(this).hasClass('l-btn-disabled')) {
                var itemData = state._eventsStore;
                //恢复超链接
                if (itemData.href) {
                    $(this).attr("href", itemData.href);
                }
                //回复点击事件
                if (itemData.onclicks) {
                    for (var j = 0; j < itemData.onclicks.length; j++) {
                        $(this).bind('click', itemData.onclicks[j]);
                    }
                }
                //设置target为null，清空存储的事件处理程序
                itemData.target = null;
                itemData.onclicks = [];
                $(this).removeClass('l-btn-disabled');
            }
        });
    },
    /**
     * 禁用选项（覆盖重写）
     * @param {Object} jq
     */
    disable: function(jq){
        return jq.each(function(){
            var state = $.data(this, 'linkbutton');
            if (!state._eventsStore)
                state._eventsStore = {};
            if (!$(this).hasClass('l-btn-disabled')) {
                var eventsStore = {};
                eventsStore.target = this;
                eventsStore.onclicks = [];
                //处理超链接
                var strHref = $(this).attr("href");
                if (strHref) {
                    eventsStore.href = strHref;
                    $(this).attr("href", "javascript:void(0)");
                }
                //处理直接耦合绑定到onclick属性上的事件
                var onclickStr = $(this).attr("onclick");
                if (onclickStr && onclickStr != "") {
                    eventsStore.onclicks[eventsStore.onclicks.length] = new Function(onclickStr);
                    $(this).attr("onclick", "");
                }
                //处理使用jquery绑定的事件
                var eventDatas = $(this).data("events") || $._data(this, 'events');
                if (eventDatas["click"]) {
                    var eventData = eventDatas["click"];
                    for (var i = 0; i < eventData.length; i++) {
                        if (eventData[i].namespace != "menu") {
                            eventsStore.onclicks[eventsStore.onclicks.length] = eventData[i]["handler"];
                            $(this).unbind('click', eventData[i]["handler"]);
                            i--;
                        }
                    }
                }
                state._eventsStore = eventsStore;
                $(this).addClass('l-btn-disabled');
            }
        });
    }
});