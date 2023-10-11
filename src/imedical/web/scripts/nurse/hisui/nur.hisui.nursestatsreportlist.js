/**
 * @author gaoshan
 * @version 2022.1.23
 * @description 
 * @name nur.hisui.nursestatsreportlist.js
 */
 // test
 /*
alert("���գ�"+getNowDate())
alert("ǰ3�죺"+getBeforeDate(3))
alert("��7�죺"+getAfterDate(7))
alert("���µ�һ�죺"+getFirstDay())
alert("�������һ�죺"+getLastDay())
*/

// ���˴���
var pageActionCount = 0
var dcTableColumns=[];
// ��ȡ���ü������� start
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
// �ж��Ƿ�߼�Ȩ��,��Ŀ��������������Թ���
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
	// ��������������Բ鿴ȫ���������� 2022.8.18 add
	if(session['LOGON.GROUPDESC'].indexOf("����") > -1 || admin)
	{
		return true;
	}
	return false;
}

// ��������
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
	// ��������
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
	// ��ѯ
	$("#findBtn").click(function(){
		pageActionCount = 0 // ���²�ѯ�����ó�ʼֵ
		initStatistics();
	});
	
	// ���� Export -- ��ǰҳ
	$("#Export").click(function(){
		// �������-datagrid-export.js ʵ�ֵ���excel����
		// var startDate = $('#startDate').datebox('getValue');
		var startDate = getBeforeDate(7) // Ĭ������-ǰ7��
		if (ServerObj.startDateShowFlag == "1") {
			startDate = $('#startDate').datebox('getValue');
		}
		var endDate = getNowDate()
		if ($('#endDate').length) {
			endDate = $('#endDate').datebox('getValue');
		}
		var param = {}
		var tempFileName = decodeURIComponent(ServerObj.NodeName) || $g("ͳ�ƽ��")
		param['filename']=tempFileName+"-"+getDate(0)+'.xls'
		if (endDate!=0) {
			param['worksheet']=$g("ͳ������")+startDate+$g("��")+endDate+""
		}else{
			param['worksheet']=$g("ͳ������")+startDate
		}
		// ��������
		param['centertitle']=ServerObj.NodeName
		var rows=$('#EmrGrid').datagrid('getChecked');
		if (RowMergeArray.length) { // �ϲ�����
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
			$.messager.popover({ msg: $g("��ѡ��Ҫ���������ݣ�"), type: "alert" });
			return false;
		}
		if (rows.length>1) {
		var lastRow={baseWardName: $g("�ܼ�"), locId: -1}
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
	// ����ȫ�� --�������� --��bug�������кϲ�û��Ч��
	$("#ExportAll").click(function(){
		// �������-datagrid-export.js ʵ�ֵ���excel����
		var param = {}
		param['exportAll']="1";
		param['filename']='����ǼǱ���_'+getDate(0)+'.xls'
		$('#EmrGrid').datagrid('toExcel',param)
	});
	*/
}
function stringSegmentAdd(a,b) {
	// �ַ����ֶ���� �磺3+2��5+3����8+5
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

// ��¼�ϲ����м���
var RowMergeArray = [];

/*----------------------------------------------------------------------------------*/
/**
 * @description ��ʼ���б�
 */
function initStatistics() {
	var defaultPageSize = 20;
    var defaultPageList = [20, 50, 100, 200, 500, 1000, 5000, 999999];
    var paginationResult = true;
    // ����ҳ����
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
    var startDate = getBeforeDate(7) // Ĭ������-ǰ7��
    if (ServerObj.startDateShowFlag == "1") {
    	startDate = $('#startDate').datebox('getValue');
    }
    var endDate = getNowDate()
    if (ServerObj.endDateShowFlag == "1")
    { 
    	endDate = $('#endDate').datebox('getValue');
    }
    var outFlag = $('#outFlag').checkbox('getValue');
    // ��ȡ���Ĭ�������ֶ� 2022.6.17 add
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
		// �ϲ�ͨ���ǲ����ϲ���û�кϲ�ʱ����ͬlocId�ֲ���
		tableData.map(function (t,i) {
			tableData[i].locId=Math.random().toString(16).slice(2,8);
		})
	}
	$('#EmrGrid').datagrid('uncheckAll');
    $('#EmrGrid').datagrid({
	    bodyCls:'table-splitline',
		pagination: paginationResult, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		pageSize: defaultPageSize,
		pageList: defaultPageList,
		rownumbers:true,
		data: tableData,
		columns:ColOBJECT,
		idField: 'locId',
		singleSelect:false,
		remoteSort: false, // ǰ������ 2022.6.17 add
		sortName:sortName, // ǰ������ 2022.6.17 add
		sortOrder:sortOrder, // ǰ������ 2022.6.17 add
		// nowrap:false, // �����п�����Ӧ ���в����У�һҳ����չʾ�������ݣ�
		// ��ͷ�������ݴ�λ start
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
		    var posDivs = Array.from(table.eq(0).find('div.datagrid-header-check')).concat(Array.from(table.eq(0).find('div.datagrid-cell')))//��ͷ������λ�õ�div
		    var bodyFirstDivs = table.eq(1).find('tr:eq(0) div') //���ݵ�һ���������ÿ�ȵ�div���Ա����úͱ�ͷһ���Ŀ��
		    var orderHeader = posDivs.map(function (elem,ind) {
				return { index: ind, left: $(elem).position().left} 
			}); //�����ͷ�����λ�ã��Ա���������������е�Ԫ��ѭ��һ��
		    orderHeader.sort(function (a, b) { return a.left - b.left; }); //�Ա�ͷλ������
		    setTimeout(function () {//��ʱ���ÿ�ȣ���Ϊeasyuiִ����ϻص����к����Ĵ�����ȥ���������������ÿ�ȵ�div��css width����
		        for (var i = 0; i < orderHeader.length; i++) {
		            // var wid = $(posDivs[orderHeader[i].index]).parents("td").width() // todo �ȸ�Ҫ����0.5������Ԫ�������������ܻᳬ��һЩ
		            var wid = $(posDivs[i]).parents("td").width() // todo �ȸ�Ҫ����0.5������Ԫ�������������ܻᳬ��һЩ
		            bodyFirstDivs.eq(i).parents("td").css('width', wid+"px");
		        }
		    }, 50);
		    
		    // ���ݺϲ���
		    mergeCells("EmrGrid",RowMergeArray, "episodeID");
		    
		    //������ӡ��ϼơ��� 2022.6.9 add
		    if (ServerObj.ReportType == "Shift") {
          // var locList = $('#wardLocs').combobox('getValues')
			    // �����Ҳ���Ҫ���ܣ����ظ���ʾ����
			    if($('#EmrGrid').datagrid('getData') && $('#EmrGrid').datagrid('getData').total > 0) {
					var newRow = {}
					var firstRow = $('#EmrGrid').datagrid('getData').rows[0];
					if (firstRow) {
					for (var filedName in firstRow) {
						if (filedName == "locId" || filedName == "wardId") continue;
						if (filedName == "baseWardName") {
						newRow[filedName] = $g('�ܼ�');
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
			// ��������ĳ���
			if (ServerObj.ReportType != "Shift") {
				// Դ����ֻ����һ�Σ����˶�λᵼ���кϲ������� 2022.6.6
				if (pageActionCount == 0) {
					var newData = [];
					// ��ǰ���㺯��������������������������
					for(var m in data){
						var keyObj = data[m];
						for(var n in keyObj){
							  var propertyVal = keyObj[n]; // obj key value
							  var propertyStr = String(propertyVal)
							  // ͨ�����ʽ��������
							  if (isContainFormula(propertyStr)) {
								var expData = propertyStr.split("formula:")
								var resultObj = parser.parse(expData[1]);
								keyObj[n] = resultObj.result
							  }
						}
						newData.push(keyObj);
					}

					var _data = newData;
					// ǰ�˹���
					var newData = filterByPage(newData, _data)
					// ���¸�ֵ
					data = newData;
					// �ͷŶ���
					newData = null;
				}
		    }
			// ǰ�˷�ҳ���˴����Ա����ظ���������
			return pageAction("EmrGrid",data);
		}
    });
    
    /* ���ֶ����� ������ ��ͣʹ�� 2022.6.17
    $('#EmrGrid').datagrid('sort', {	
        sortName: 'jjzyReportDate04,patInHospDate',
        sortOrder: 'asc,asc'
    });
    */
    //.datagrid({loadFilter:DocToolsHUINur.lib.pagerFilter}); -- ע�͵�������
}

// �ж�sex�ؼ��֣�Ȼ���������
function filterByPage(newData, _data) {
	// ������
	var filter = {};
	// ǰ���Զ���ؼ�
	$(".customComponent").each(function(){
		var that = $(this) // select �ؼ�
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
	// ���˵õ���������
	if (_data && _data.length > 0 && Object.keys(filter).length > 0){
		newData = multiFilter(_data, filter);
	}
	return newData;
}

// �ַ���ƴ��
function getConnInfo(pageValue) {
	var connstr = ""
	if (pageValue == "") return connstr;
	for (var m in pageValue)
	{
		var pageOptionText = pageValue[m];
		// �Լ����ƴ��connstr
		if (connstr != "")
		{
			connstr += "^"
		}
		connstr += pageOptionText
	}
	return connstr;
}

// �ж��Ƿ����formula
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
 *@description ��ʼ��bedGrid��ť�������¼�������
 *
 */
function initStatisticsGrid() {
	$.each(ColOBJECT,function (index,obj) {
		$.each(obj,function (subindex,objsub) {
			// �ձ�ͷ���㣬����ϲ�excel������
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
					// ��Ԫ�� ������ʾȫ������
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

//ָ�������
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
    // ��Ϊ�գ���ʾ�գ�����ʾ0
    if (empty>0 && empty == rowCount) total=""
    return total;
}
        
function initCondition() {
    // var date1 = getBeforeDate(7); // Ĭ��ȡǰ7��
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
		// ���ó�ʼֵ
		var dataInfo = getSearchInitCode("startDate")
		var defaultDate = getDefaultDateValue(dataInfo.split("^")[1])
    	$('#startDate').datebox('setValue', defaultDate);
    	$('#startDate').parent().prev().html(dataInfo.split("^")[0]);
	}
	if (ServerObj.endDateShowFlag == "1")
	{
		// ���ó�ʼֵ
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
        rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
        value:defaultValue,
        onLoadSuccess: function () {
	       
	    }
    })
    
    // �Զ���select�ؼ� ��Ҫ����ѡ��ֵ���������û��ָ��Ĭ��ֵ��Ҳ�Ὣ��һ��Ĭ��ѡ��
    $(".customComponent").each(function(){
		var that = $(this)
		if (that[0] && that[0].tagName == "SELECT")
		{
			that.combobox('clear');
		}
	})
}

// ��ȡ��Ŀ��ʼֵ����
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

// ��ȡ��ʼ������ֵ
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
   * ��ȡָ��ʱ�������
   * @params ���ǽ���֮������ڡ����ǽ���ǰ������
   * @return 2020-05-10
   * */
function getDate(num) {
    var date1 = new Date();
    //����ʱ��
    var time1 = date1.getFullYear() + "-" + (date1.getMonth() + 1) + "-" + date1.getDate();
    var date2 = new Date(date1);
    date2.setDate(date1.getDate() + num);
    //num��������ʾ֮���ʱ�䣬num������ʾ֮ǰ��ʱ�䣬0��ʾ����
    var time2 = this.addZero(date2.getFullYear()) + "-" + this.addZero((date2.getMonth() + 1)) + "-" + this.addZero(date2.getDate());
    return time2;
  }
  
  //��0
function addZero(num){
    if(parseInt(num) < 10){
      num = '0'+num;
    }
    return num;
  }
  
// ǰ�˷�ҳ
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
			dg.datagrid('scrollTo',0); //������ָ������  
			/*
			//���⴦������Ϣ���������ҽ���б�
			ˢ�µ�ǰҳ��ѡ����,Դ�����������ӳ٣�Ҫ��֤��ջִ��˳��
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
				//ȡ���������������ҳ��ʼֵ
				//start=Math.floor((data.originalRows.length-1)/opts.pageSize)*opts.pageSize;
				start=Math.floor((data.originalRows.length<1?1:data.originalRows.length-1)/opts.pageSize)*opts.pageSize;
				opts.pageNumber=(start/opts.pageSize)+1;
			}
			//���ҳ����ʾ����ȷ������
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

  // ������������ɸѡ
function multiFilter(array, filters) {
    var filterKeys = Object.keys(filters); 
    // filters all elements passing the criteria

   return array.filter(function (item) {
      // dynamically validate all filter criteria
      return filterKeys.every(function (key) {
        //ignore when the filter is empty Anne
        if (!filters[key].length) return true;
        // ת����es5��д��
        var filterInfo  = String(filters[key])
        if (filterInfo && filterInfo !="" && filterInfo.indexOf("^")) {
            var array = filterInfo.split("^");
            var exist = false;
            for (var index = 0; index < array.length; index++) {
                 var element = array[index];
                 // ��һ������Ϳ���
				 if (key.indexOf("patAge") > -1) // ����Ƚ� ���⴦��
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

// ����Ƚϴ�С
function compareAge(inAge,dataAge) {
	var dataAgeNum = 0;
	if (inAge == "" || dataAge == "") return true;
	// �����ꡢ�������¡��� --����
	if (dataAge.indexOf("��") > -1 && dataAge.indexOf("��") == -1 && dataAge.indexOf("��") == -1) {
		dataAgeNum = parseInt(dataAge.split("��")[0]);
	}else{
		// ��ͯ: ���꼸���� ���꼸��
		if (dataAge.indexOf("��") > -1 && (dataAge.indexOf("��") > -1 || dataAge.indexOf("��") > -1)) {
			dataAgeNum = parseInt(dataAge.split("��")[0]);
		}else{
			// Ӥ��������һ�꣬����0�����
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
	}else if (inAge.indexOf("-") > -1){ // �����䷶Χ
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
			var title=detailCaseObj.StartDate+[$g("��֤���˴���ϸ"),$g("��֤δ�Ǽ��˴���ϸ"),$g("�Ǽ�δ��Ժ�˴���ϸ")][detailCaseObj.flag];
			$HUI.dialog('#detailCasesModal').setTitle(title);
		}, 300);
	}
	getDetailCasesData();
}

function getDetailCasesData() {
	updateModalPos("detailCasesModal");
	// ��ȡ��Ϣ
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
// ����ģ̬��λ��
function updateModalPos(id) {
  var offsetLeft=(window.innerWidth-$('#'+id).parent().width())/2;
  var offsetTop=(window.innerHeight-$('#'+id).parent().height())/2;
  $('#'+id).dialog({
    left: offsetLeft,
    top: offsetTop
  }).dialog("open");
}
