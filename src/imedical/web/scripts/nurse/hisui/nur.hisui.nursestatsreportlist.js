/**
 * @author gaoshan
 * @version 2022.1.23
 * @description 
 * @name nur.hisui.nursestatsreportlist.js
 */
 // test
 /*
alert("当日："+getNowDate())
alert("前3天："+getBeforeDate(3))
alert("后7天："+getAfterDate(7))
alert("当月第一天："+getFirstDay())
alert("当月最后一天："+getLastDay())
*/

// 过滤次数
var pageActionCount = 0
var dcTableColumns=[];
// 获取配置检索条件 start
var searchList = $cm({
  ClassName:"Nur.NIS.Service.ReportV2.ReportStatistics",
  MethodName:"GetSearchInfo",
  hosID:session['LOGON.HOSPID'],
  reportCode:ServerObj.ReportCode
},false);
searchList.map(function (s,i) {
  searchList[i].itemName=$g(s.itemName);
})
var JsonCol="",detailCaseObj={},dcTableObj;
var columnNum = 0
// 判读是否高级权限,项目个性需求这里可以过滤
function isAdmin()
{
	var groupStr = $.m({
	    ClassName:"Nur.NIS.Service.ReportV2.DataManager",
	    MethodName:"GetGroupListByCode",
	    reportCode:ServerObj.ReportCode
	},false);
	var admin = false;
	if (groupStr && groupStr!="")
	{
		if (groupStr.toString().indexOf(",") > -1)
		{
			var gpArr = groupStr.split(",")
			for (var i = 0; i < gpArr.length; i++) {
			    if(session['LOGON.GROUPID'] == gpArr[i])
				{
					admin = true;
					break;
				}
			}
		}else
		{
			if(session['LOGON.GROUPID'] == groupStr)
			{
				admin = true;
			}
		}
	}
	// 单个报表或护理部可以查看全部病区数据 2022.8.18 add
	if(session['LOGON.GROUPDESC'].indexOf("护理部") > -1 || admin)
	{
		return true;
	}
	return false;
}

// 病区数据
if(!isAdmin()) {
	//JsonCol=tkMakeServerCall("Nur.NIS.Service.ReportV2.ReportConfig","getNurseStatisticsCol", ServerObj.ReportCode, session['LOGON.HOSPID'],session['LOGON.CTLOCID']);
	JsonCol=$cm({
	    ClassName:"Nur.NIS.Service.ReportV2.ReportConfig",
	    MethodName:"getNurseStatisticsCol",
	    reportCode:ServerObj.ReportCode,
	    hosId:session['LOGON.HOSPID'],
	    locId:session['LOGON.CTLOCID']
	},false);
}else{
	// 护理部数据
	//JsonCol=tkMakeServerCall("Nur.NIS.Service.ReportV2.ReportConfig","getNurseStatisticsCol", ServerObj.ReportCode, session['LOGON.HOSPID'],"");	
	JsonCol=$cm({
	    ClassName:"Nur.NIS.Service.ReportV2.ReportConfig",
	    MethodName:"getNurseStatisticsCol",
	    reportCode:ServerObj.ReportCode,
	    hosId:session['LOGON.HOSPID']
	},false);
}
console.log(JsonCol);
JsonCol[0].unshift({field:'ck',title:'sel',checkbox:true,rowspan:2});
var ColOBJECT=JsonCol; //($.parseJSON(JsonCol))
var GV = {
    _CALSSNAME: "NurMp.Sources.EmrStatistics",
    episodeID: "",
};
var init = function () {
    initPageDom();
    initBindEvent();
}
$(init)
function initPageDom() {
	initCondition();
    initStatistics();
}

function initBindEvent() {
	// 查询
	$("#findBtn").click(function(){
		pageActionCount = 0 // 重新查询、设置初始值
		initStatistics();
	});
	
	// 导出 Export -- 当前页
	$("#Export").click(function(){
		// 借助插件-datagrid-export.js 实现导出excel功能
		// var startDate = $('#startDate').datebox('getValue');
		var startDate = getBeforeDate(7) // 默认日期-前7天
		if (ServerObj.startDateShowFlag == "1") {
			startDate = $('#startDate').datebox('getValue');
		}
		var endDate = getNowDate()
		if ($('#endDate').length) {
			endDate = $('#endDate').datebox('getValue');
		}
		var param = {}
		var tempFileName = decodeURIComponent(ServerObj.NodeName) || $g("统计结果")
		param['filename']=tempFileName+"-"+getDate(0)+'.xls'
		if (endDate!=0) {
			param['worksheet']=$g("统计日期")+startDate+$g("至")+endDate+""
		}else{
			param['worksheet']=$g("统计日期")+startDate
		}
		// 标题名称
		param['centertitle']=ServerObj.NodeName
		var rows=$('#EmrGrid').datagrid('getChecked');
		if (RowMergeArray.length) { // 合并导出
			var allRows=$('#EmrGrid').datagrid('getRows'),locIds=[];
			for (var i = 0; i < rows.length; i++) {
				locIds.push(rows[i].locId);
			}
			allRows=JSON.parse(JSON.stringify(allRows));
			for (var i = 0; i < allRows.length; i++) {
				if (locIds.indexOf(allRows[i].locId)<0) {
					allRows.splice(i,1);
					i--;
				}
			}
			rows=allRows;
		}
		rows=JSON.parse(JSON.stringify(rows));
		if (!rows.length) {
			$.messager.popover({ msg: $g("请选择要导出的数据！"), type: "alert" });
			return false;
		}
		if (rows.length>1) {
		var lastRow={baseWardName: $g("总计"), locId: -1}
		rows.map(function (r) {
			if (ColOBJECT[1]) {
				ColOBJECT[1].map(function (col) {
					var field=col.field;
					if ('undefined'==typeof lastRow[field]) lastRow[field]=0;
					// lastRow[field]+=parseInt(r[field]||0);
					lastRow[field]=stringSegmentAdd(lastRow[field],r[field]);
				})
			}
		})
		rows.push(lastRow);
		}
		param['rows']=rows;
		param['removeCols']=['ck'];
		param['maxcolumn']=columnNum-param['removeCols'].length;
		$('#EmrGrid').datagrid('toExcel',param)
	});

	/*
	// 导出全部 --所有数据 --有bug，数据行合并没有效果
	$("#ExportAll").click(function(){
		// 借助插件-datagrid-export.js 实现导出excel功能
		var param = {}
		param['exportAll']="1";
		param['filename']='分娩登记表结果_'+getDate(0)+'.xls'
		$('#EmrGrid').datagrid('toExcel',param)
	});
	*/
}
function stringSegmentAdd(a,b) {
	// 字符串分段相加 如：3+2加5+3等于8+5
	a=a.toString();
	b=b.toString();
	var a1=parseFloat(a||0);
	var a2=a.replace(a1,"");
	var b1=parseFloat(b||0);
	var b2=b.replace(b1,"");
	var c1=a1+b1;
	var c2=a2+b2;
	if (!c2) return c1;
	c2=eval(c2);
	if (parseFloat(c2)>0) {
		return c1+"+"+c2;
	}
	if (parseFloat(c2)<0) {
		return c1+"-"+c2;
	}
	return c1;
}

// 记录合并行列集合
var RowMergeArray = [];

/*----------------------------------------------------------------------------------*/
/**
 * @description 初始化列表
 */
function initStatistics() {
	var defaultPageSize = 20;
    var defaultPageList = [20, 50, 100, 200, 500, 1000, 5000, 999999];
    var paginationResult = true;
    // 不分页处理
	if (ServerObj.ShowPage == "N") {
    	paginationResult = false;
    }
    var Locs = ""
    if (ServerObj.wardLocsShowFlag == "1") {
	    var Locs = $('#wardLocs').combobox('getValues').join(",");
	    if(!isAdmin()) {
			 Locs=session['LOGON.CTLOCID'];
      }
    }
    var startDate = getBeforeDate(7) // 默认日期-前7天
    if (ServerObj.startDateShowFlag == "1") {
    	startDate = $('#startDate').datebox('getValue');
    }
    var endDate = getNowDate()
    if (ServerObj.endDateShowFlag == "1")
    { 
    	endDate = $('#endDate').datebox('getValue');
    }
    var outFlag = $('#outFlag').checkbox('getValue');
    // 获取表格默认排序字段 2022.6.17 add
    var sortName = ""
    var sortOrder = ""
    if (ServerObj.SortInfo) {
	    var arr = ServerObj.SortInfo.split("#")
	    sortName = arr[0]
	    sortOrder = arr[1]
	}
	var tableData=$cm({
		ClassName: "Nur.NIS.Service.ReportV2.ReportStatistics",
		MethodName: "GetEmrStatisticsData",
		StartDate: startDate,
		EndDate: endDate,
		ReportCode:ServerObj.ReportCode,
		LocId: Locs,
		SessionGrpId:session['LOGON.GROUPID'],
		SessionHosId:session['LOGON.HOSPID'],
		OutFlag:outFlag
	},false);
	var rowMerge=0;
	ColOBJECT.map(function (col,i) {
		if (col.length) {
			col.map(function (c,j) {
				if ('Y'==c.RowMerge) rowMerge=1
			})
		} else {
			if ('Y'==col.RowMerge) rowMerge=1
		}
	})
	if (!rowMerge) {
		// 合并通常是病区合并，没有合并时，相同locId分不开
		tableData.map(function (t,i) {
			tableData[i].locId=Math.random().toString(16).slice(2,8);
		})
	}
	$('#EmrGrid').datagrid('uncheckAll');
    $('#EmrGrid').datagrid({
	    bodyCls:'table-splitline',
		pagination: paginationResult, //如果为true, 则在DataGrid控件底部显示分页工具栏
		pageSize: defaultPageSize,
		pageList: defaultPageList,
		rownumbers:true,
		data: tableData,
		columns:ColOBJECT,
		idField: 'locId',
		singleSelect:false,
		remoteSort: false, // 前端排序 2022.6.17 add
		sortName:sortName, // 前端排序 2022.6.17 add
		sortOrder:sortOrder, // 前端排序 2022.6.17 add
		// nowrap:false, // 超过列宽自适应 ：列不折行，一页可以展示更多数据，
		// 表头与表格内容错位 start
		onSelect: function(rowIndex, rowData){
			console.log(rowIndex, rowData);
			if (rowData["noclick"]) {
				$(this).datagrid('unselectRow', rowIndex);
			}
		},
		onSelectAll: function(rows){
			var that=this;
			rows.map(function (r,i) {
				if (r["noclick"]) {
					setTimeout(function() {
						var j=i;
						$(that).datagrid('unselectRow', j);
						$(that).datagrid('uncheckRow', j);
					}, 300);
				}
			})
		},
		onLoadSuccess: function (data) {
			initStatisticsGrid();
		    var table = $(this).prev().find('table')
		    var posDivs = Array.from(table.eq(0).find('div.datagrid-header-check')).concat(Array.from(table.eq(0).find('div.datagrid-cell')))//表头用来定位用的div
		    var bodyFirstDivs = table.eq(1).find('tr:eq(0) div') //内容第一行用来设置宽度的div，以便设置和表头一样的宽度
		    var orderHeader = posDivs.map(function (elem,ind) {
				return { index: ind, left: $(elem).position().left} 
			}); //计算表头的左边位置，以便重新排序和内容行单元格循序一致
		    orderHeader.sort(function (a, b) { return a.left - b.left; }); //对表头位置排序
		    setTimeout(function () {//延时设置宽度，因为easyui执行完毕回调后有后续的处理，会去掉内容行用来设置宽度的div的css width属性
		        for (var i = 0; i < orderHeader.length; i++) {
		            // var wid = $(posDivs[orderHeader[i].index]).parents("td").width() // todo 谷歌要减掉0.5，否则单元格描述过长可能会超出一些
		            var wid = $(posDivs[i]).parents("td").width() // todo 谷歌要减掉0.5，否则单元格描述过长可能会超出一些
		            bodyFirstDivs.eq(i).parents("td").css('width', wid+"px");
		        }
		    }, 50);
		    
		    // 数据合并行
		    mergeCells("EmrGrid",RowMergeArray, "episodeID");
		    
		    //交班添加“合计”列 2022.6.9 add
		    if (ServerObj.ReportType == "Shift") {
          // var locList = $('#wardLocs').combobox('getValues')
			    // 单科室不需要汇总，会重复显示数据
			    if($('#EmrGrid').datagrid('getData') && $('#EmrGrid').datagrid('getData').total > 0) {
					var newRow = {}
					var firstRow = $('#EmrGrid').datagrid('getData').rows[0];
					if (firstRow) {
					for (var filedName in firstRow) {
						if (filedName == "locId" || filedName == "wardId") continue;
						if (filedName == "baseWardName") {
						newRow[filedName] = $g('总计');
						}else{
						newRow[filedName] =  compute(filedName);
						}
						newRow["noclick"] = "1"
					}    
					$('#EmrGrid').datagrid('appendRow',newRow);
					console.log(data.total);
					// $(".datagrid-row[datagrid-row-index=" + (data.total-1) + "] input[type='checkbox']")[0].disabled = true;
					$(".datagrid-row[datagrid-row-index=" + (data.total-1) + "] input[type='checkbox']").remove();
					}
				}   
			}
		},
		loadFilter: function(data){
			// 交班以外的场景
			if (ServerObj.ReportType != "Shift") {
				// 源数据只过滤一次，过滤多次会导致行合并出问题 2022.6.6
				if (pageActionCount == 0) {
					var newData = [];
					// 提前计算函数结果，避免后面计算出各种问题
					for(var m in data){
						var keyObj = data[m];
						for(var n in keyObj){
							  var propertyVal = keyObj[n]; // obj key value
							  var propertyStr = String(propertyVal)
							  // 通过表达式函数计算
							  if (isContainFormula(propertyStr)) {
								var expData = propertyStr.split("formula:")
								var resultObj = parser.parse(expData[1]);
								keyObj[n] = resultObj.result
							  }
						}
						newData.push(keyObj);
					}

					var _data = newData;
					// 前端过滤
					var newData = filterByPage(newData, _data)
					// 重新赋值
					data = newData;
					// 释放对象
					newData = null;
				}
		    }
			// 前端分页，此处可以避免重复请求问题
			return pageAction("EmrGrid",data);
		}
    });
    
    /* 多字段排序 有问题 暂停使用 2022.6.17
    $('#EmrGrid').datagrid('sort', {	
        sortName: 'jjzyReportDate04,patInHospDate',
        sortOrder: 'asc,asc'
    });
    */
    //.datagrid({loadFilter:DocToolsHUINur.lib.pagerFilter}); -- 注释掉过滤器
}

// 判断sex关键字，然后过滤数据
function filterByPage(newData, _data) {
	// 过滤器
	var filter = {};
	// 前端自定义控件
	$(".customComponent").each(function(){
		var that = $(this) // select 控件
		var pageValue = ""
		var thatObj = that[0]
		if(!thatObj) return newData;
		if (thatObj.nodeName == "SELECT"){
			pageValue = $("#"+thatObj.id).combobox('getValues');
		}else if (thatObj.nodeName == "INPUT"){
			pageValue = $("#"+thatObj.id).val();
		}
		if (pageValue !="" && pageValue.length > 0)  filter[thatObj.id] = [getConnInfo(pageValue)]
	})
	// 过滤得到最终数据
	if (_data && _data.length > 0 && Object.keys(filter).length > 0){
		newData = multiFilter(_data, filter);
	}
	return newData;
}

// 字符串拼接
function getConnInfo(pageValue) {
	var connstr = ""
	if (pageValue == "") return connstr;
	for (var m in pageValue)
	{
		var pageOptionText = pageValue[m];
		// 以间隔父拼接connstr
		if (connstr != "")
		{
			connstr += "^"
		}
		connstr += pageOptionText
	}
	return connstr;
}

// 判断是否包含formula
function isContainFormula(str)
{
	if (str.indexOf("formula:") > -1 && 
			str.indexOf("(") > -1 
			&& str.indexOf(")") > -1){
		return true
	}
	return false
}

/**
 *@description 初始化bedGrid按钮操作及事件监听等
 *
 */
function initStatisticsGrid() {
	$.each(ColOBJECT,function (index,obj) {
		$.each(obj,function (subindex,objsub) {
			// 空表头不算，否则合并excel出问题
			if (objsub.ItemDataType != "EmptyHeader" && !objsub.hidden) {
				columnNum = columnNum + 1
			}
			if(objsub.hidden!=true){
				var colObj = $('#EmrGrid').datagrid('getColumnOption', objsub.field);
				colObj.formatter =function(val, row, index){
					var btns=val;
					/*
					if(objsub.field!="LocDesc"){
					}
					*/
					//return btns;
					if (val.toString().indexOf('span')>-1) return val;
					// 单元格 悬浮提示全部名称
					return "<span title='" + val + "' >" + val + "</span>";
				};
				if (colObj.RowMerge=="Y") {
					RowMergeArray.push(colObj.field)
				}
			}
		})
	})
	if (RowMergeArray.length) RowMergeArray.unshift('ck');
}

//指定列求和
function compute(colName) {
    var rows = $('#EmrGrid').datagrid('getRows');
    var total = 0;
    var empty = 0
    var rowCount = rows.length
    for (var i = 0; i < rowCount; i++) {
	    var tmp = rows[i][colName];
	    if (String(tmp) == "")
	    {
		    empty = empty + 1
		    continue
	    }
        // total += parseInt(tmp);
		total=stringSegmentAdd(total,tmp);
    }
    // 都为空，显示空，不显示0
    if (empty>0 && empty == rowCount) total=""
    return total;
}
        
function initCondition() {
    // var date1 = getBeforeDate(7); // 默认取前7天
	// var date2 = getDate(0);
	
	var defaultValue = ""
    if(!isAdmin())
    {
       defaultValue = session['LOGON.CTLOCID']
        if (ServerObj.wardLocsShowFlag == "1")
	    {
		   var dataInfo = getSearchInitCode("wardLocs")
	       $('#wardLocs').combobox({disabled:true});
	       $('#wardLocs').parent().prev().html(dataInfo.split("^")[0]);
	    }
    }
 	if (ServerObj.startDateShowFlag == "1")
	{
		// 设置初始值
		var dataInfo = getSearchInitCode("startDate")
		var defaultDate = getDefaultDateValue(dataInfo.split("^")[1])
    	$('#startDate').datebox('setValue', defaultDate);
    	$('#startDate').parent().prev().html(dataInfo.split("^")[0]);
	}
	if (ServerObj.endDateShowFlag == "1")
	{
		// 设置初始值
		var dataInfo = getSearchInitCode("endDate")
		var defaultDate = getDefaultDateValue(dataInfo.split("^")[1])
    	$('#endDate').datebox('setValue', defaultDate);
    	$('#endDate').parent().prev().html(dataInfo.split("^")[0]);
	}
    $('#wardLocs').combobox({
        url: $URL + '?1=1&ClassName=Nur.NIS.Service.ReportV2.LocUtils&QueryName=NurseCtloc&desc='+ '&ResultSetType=array&hosId='+session['LOGON.HOSPID'],
        valueField: 'locID',
        textField: 'locDesc',
        defaultFilter:4,
        multiple:true,
        rowStyle:'checkbox', //显示成勾选行形式
        value:defaultValue,
        onLoadSuccess: function () {
	       
	    }
    })
    
    // 自定义select控件 需要清理选中值，否则程序没有指定默认值，也会将第一个默认选中
    $(".customComponent").each(function(){
		var that = $(this)
		if (that[0] && that[0].tagName == "SELECT")
		{
			that.combobox('clear');
		}
	})
}

// 获取项目初始值条件
function getSearchInitCode(key) {
	var ret = "^"
	if (searchList)
	{
		for (var i = 0; i < searchList.length; i++) {
	    	var obj = searchList[i];
	    	if (obj.itemCode == key)
	    	{
		    	return obj.itemName+"^"+obj.initValue
		    }
		}
	}
	return ret;
}

// 获取初始的日期值
function getDefaultDateValue(keyCode)
{
	var date = ""
	switch (keyCode) {
	    case "ToDay":
	        date = getNowDate();
	        break;
	    case "Yesterday":
	        date = getBeforeDate(1);
	        break;
	    case "Tomorrow":
	        date = getAfterDate(1);
	        break;
	    case "3DaysAgo":
	        date = getBeforeDate(3);
	        break;
	    case "7DaysAgo":
	        date = getBeforeDate(7);
	        break;
	    case "1StOfTheMonth":
	        date = getFirstDayOfMonth();
	        break;
        case "LastDayOfTheMonth":
       		 date = getLastDayOfMonth();
	        break; 
	    case "NowQuarterStart":
       		 date = DateUtil.getQuarterStart();
	        break;
	    case "NowQuarterEnd":
       		 date = DateUtil.getQuarterEnd();
	        break;
	    default:
	        date = getNowDate();
	        break;
	}
	return date;
}

 /**
   * 获取指定时间的日期
   * @params 正是今天之后的日期、负是今天前的日期
   * @return 2020-05-10
   * */
function getDate(num) {
    var date1 = new Date();
    //今天时间
    var time1 = date1.getFullYear() + "-" + (date1.getMonth() + 1) + "-" + date1.getDate();
    var date2 = new Date(date1);
    date2.setDate(date1.getDate() + num);
    //num是正数表示之后的时间，num负数表示之前的时间，0表示今天
    var time2 = this.addZero(date2.getFullYear()) + "-" + this.addZero((date2.getMonth() + 1)) + "-" + this.addZero(date2.getDate());
    return time2;
  }
  
  //补0
function addZero(num){
    if(parseInt(num) < 10){
      num = '0'+num;
    }
    return num;
  }
  
// 前端分页
function pageAction(datagridId, data)
{
	if (typeof data.length == 'number' && typeof data.splice == 'function'){	// is array
		data = {
			total: data.length,
			rows: data
		}
	}else{
		if(typeof(data.rows)=='undefined'){
			var arr = []
			for (var i in data){
				arr.push(data[i])
			}
			data = {
				total: arr.length,
				rows: arr
			}
		}
	}
	var dg = $("#"+datagridId);
	var opts = dg.datagrid('options');
	var pager = dg.datagrid('getPager');
	pager.pagination({
		showRefresh:false,
		onSelectPage:function(pageNum, pageSize){
			if (dg[0].id!="tabInPatOrd"){
				dg.datagrid('unselectAll');
			}
			opts.pageNumber = pageNum;
			opts.pageSize = pageSize;
			pager.pagination('refresh',{
				pageNumber:pageNum,
				pageSize:pageSize
			});
			dg.datagrid('loadData',data);
			dg.datagrid('scrollTo',0); //滚动到指定的行  
			/*
			//特殊处理下信息总览界面的医嘱列表
			刷新当前页的选中行,源码里面做了延迟，要保证堆栈执行顺序，
			*/
			if (dg[0].id=="tabInPatOrd"){
				/*
				setTimeout(function() {
					SetVerifiedOrder(true);
				}, 0);
				*/
			}      
		},onChangePageSize:function(pageSize){
			if (typeof opts.onChangePageSize == "function"){
				opts.onChangePageSize(pageSize);
			}
		}
	});
	pager.pagination('refresh',{
		total:data.total,
		pageNumber:opts.pageNumber,
		pageSize:opts.pageSize
	});
	if (!data.originalRows){
		data.originalRows = (data.rows);
	}
	if (opts.pagination){
		if (data.originalRows.length>0) {
			var start = (opts.pageNumber==0?1:opts.pageNumber-1)*parseInt(opts.pageSize);
			if ((start+1)>data.originalRows.length){
				//取现有行数最近的整页起始值
				//start=Math.floor((data.originalRows.length-1)/opts.pageSize)*opts.pageSize;
				start=Math.floor((data.originalRows.length<1?1:data.originalRows.length-1)/opts.pageSize)*opts.pageSize;
				opts.pageNumber=(start/opts.pageSize)+1;
			}
			//解决页码显示不正确的问题
			$.extend($.data(pager[0], "pagination").options,{pageNumber:opts.pageNumber});
			
			var end = start + parseInt(opts.pageSize);
			data.rows = (data.originalRows.slice(start, end));
		}
	}
	//console.log(data)
	
	pageActionCount = 1
	
	return data;	
}

if (!Array.prototype.filter)
  Array.prototype.filter = function(func, thisArg) {
    if ( ! ((typeof func === 'Function' || typeof func === 'function') && this) )
        throw new TypeError();
    
    var len = this.length >>> 0,
        res = new Array(len), // preallocate array
        t = this, c = 0, i = -1;
    if (thisArg === undefined)
      while (++i !== len)
        // checks to see if the key was set
        if (i in this)
          if (func(t[i], i, t))
            res[c++] = t[i];
    else
      while (++i !== len)
        // checks to see if the key was set
        if (i in this)
          if (func.call(thisArg, t[i], i, t))
            res[c++] = t[i];
    
    res.length = c; // shrink down array to proper size
    return res;
  };

  // 多条件多数据筛选
function multiFilter(array, filters) {
    var filterKeys = Object.keys(filters); 
    // filters all elements passing the criteria

   return array.filter(function (item) {
      // dynamically validate all filter criteria
      return filterKeys.every(function (key) {
        //ignore when the filter is empty Anne
        if (!filters[key].length) return true;
        // 转换成es5的写法
        var filterInfo  = String(filters[key])
        if (filterInfo && filterInfo !="" && filterInfo.indexOf("^")) {
            var array = filterInfo.split("^");
            var exist = false;
            for (var index = 0; index < array.length; index++) {
                 var element = array[index];
                 // 有一个满足就可以
				 if (key.indexOf("patAge") > -1) // 年龄比较 特殊处理
				 {
					var flag = compareAge(element,item[key]);
					if (flag) exist = true
				}else{
					if (String(item[key]).indexOf(element) !== -1) {
						exist = true;
					}
				}
            }
            if (exist) return true;
        } else {
            return String(item[key]).indexOf(filterInfo) !== -1;
        }
      });
    });
}

// 年龄比较大小
function compareAge(inAge,dataAge) {
	var dataAgeNum = 0;
	if (inAge == "" || dataAge == "") return true;
	// 包含岁、不包含月、天 --成人
	if (dataAge.indexOf("岁") > -1 && dataAge.indexOf("月") == -1 && dataAge.indexOf("天") == -1) {
		dataAgeNum = parseInt(dataAge.split("岁")[0]);
	}else{
		// 儿童: 几岁几个月 或几岁几天
		if (dataAge.indexOf("岁") > -1 && (dataAge.indexOf("月") > -1 || dataAge.indexOf("天") > -1)) {
			dataAgeNum = parseInt(dataAge.split("岁")[0]);
		}else{
			// 婴儿、不到一岁，按照0岁计算
			dataAgeNum = 0;
		}
	}
	dataAgeNum = parseInt(dataAgeNum);
	if (inAge.indexOf(">") > -1){
		var inAgeNum = parseInt(inAge.split(">")[1]);
		if (dataAgeNum > inAgeNum) {
			return true;
		}
	}else if (inAge.indexOf(">=") > -1){
		var inAgeNum = parseInt(inAge.split(">=")[1]);
		if (dataAgeNum >= inAgeNum) {
			return true;
		}
	}else if (inAge.indexOf("-") > -1){ // 闭区间范围
		inAgeNum1 = parseInt(inAge.split("-")[0]);
		inAgeNum2 = parseInt(inAge.split("-")[1]);
		if (dataAgeNum >= inAgeNum1 && dataAgeNum <= inAgeNum2) {
			return true;
		}
	}else if (inAge.indexOf("<") > -1){
		var inAgeNum = parseInt(inAge.split("<")[1]);
		if (dataAgeNum < inAgeNum) {
			return true;
		}
	}else if (inAge.indexOf("<=") > -1){
		var inAgeNum = parseInt(inAge.split("<=")[1]);
		if (dataAgeNum <= inAgeNum) {
			return true;
		}
	}
	return false;
}
function openDCModal(type,p1,p2) {
	detailCaseObj={
		page: 1,
		rows: 20,
	}
	dcTableObj="";
	if ("GetPreHospAppInfoDetial"==type) {
		detailCaseObj.ClassName= "Nur.DHCNurQZRM";
		detailCaseObj.QueryName= 'GetPreHospAppInfoDetial';
		detailCaseObj.StartDate= p1;
		detailCaseObj.EndDate= p1;
		detailCaseObj.flag= p2;
        var colsData=$cm({
			ClassName: "Nur.Interface.OutSide.PortalUC.Ward",
			MethodName: "GetQueryRowspec",
			dataType: "text",
			className: detailCaseObj.ClassName,
			queryName: detailCaseObj.QueryName,
        }, false);
        colsData=colsData.split(",");
        dcTableColumns=[];
        colsData.map(function (d) {
          d=d.split(":%String:");
          if (('hidden'!=d[1])&&d[1]) {
            dcTableColumns.push({
              field:d[0],
              title:d[1],
            })
          }
        })
		setTimeout(function() {
			var title=detailCaseObj.StartDate+[$g("开证总人次明细"),$g("开证未登记人次明细"),$g("登记未入院人次明细")][detailCaseObj.flag];
			$HUI.dialog('#detailCasesModal').setTitle(title);
		}, 300);
	}
	getDetailCasesData();
}

function getDetailCasesData() {
	updateModalPos("detailCasesModal");
	// 获取信息
	saveFlag=false;
	$cm(detailCaseObj, function (data) {
		console.log(data);
		if (!dcTableObj) {
			dcTableObj=$HUI.datagrid("#detailCases",{
				autoSizeColumn:true,
				// checkbox:true,
				columns:[dcTableColumns],
				// idField:'id',
				// treeField:'oeCatDesc',
				// headerCls:'panel-header-gray',
				pagination:true,
				pageList:[10,20,50,100,200],
				pageSize: 20,
				singleSelect:true,
				onClickRow:function(id,row){
				},
			})
		}
		dcTableObj.loadData({
			total:data.total,
			rows:data.rows
		});
		$('#detailCases').datagrid("getPager").pagination({
			onSelectPage:function(p,size){
				detailCaseObj.page=p;
				detailCaseObj.rows=size;
				if (saveFlag) {
					getDetailCasesData();
				} else {
					saveFlag=true;
				}
			},
			onRefresh:function(p,size){
				detailCaseObj.page=p;
				detailCaseObj.rows=size;
				getDetailCasesData();
			},
			onChangePageSize:function(size){
				detailCaseObj.page=1;
				detailCaseObj.rows=size;
				getDetailCasesData();
			}
		}).pagination('select', detailCaseObj.page);
		// updateDomSize();
		updateModalPos("detailCasesModal");
	})
}
// 更新模态框位置
function updateModalPos(id) {
  var offsetLeft=(window.innerWidth-$('#'+id).parent().width())/2;
  var offsetTop=(window.innerHeight-$('#'+id).parent().height())/2;
  $('#'+id).dialog({
    left: offsetLeft,
    top: offsetTop
  }).dialog("open");
}
