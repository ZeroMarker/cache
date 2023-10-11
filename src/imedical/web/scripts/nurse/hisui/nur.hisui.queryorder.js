var freqFilter=['St'],freqFilterList=[
	{value:'',desc:$g('空')},
	// {value:'Bid',desc:'Bid'},
	// {value:'Tid',desc:'Tid'},
	// {value:'Qd',desc:'Qd'},
	// {value:'Fre',desc:'Fre'},
	// {value:'St',desc:'St'},
	{value:'St',desc:stDesc},
];
var allOrderId="";
$(function(){
	init()
});
function init() {
	initDateTime()
	initWard()
	initDataGrid()
}
function print(){
	var rows = $("#orderDatagrid").datagrid('getRows');
	var columns=$('#orderDatagrid').datagrid('options').columns[0];
	var thead='<table cellpadding="0" style="border-collapse: collapse;width:100%;line-height:1.5;border-top:1px solid #ccc;border-left:1px solid #ccc;"><tr>';
	columns.map(function (c) {
		thead+='<th style="text-align:left;border-bottom:1px solid #ccc;border-right:1px solid #ccc;">'+c.title+'</th>';
	})
	thead+='</tr>';
	var modulus=33; // 每页显示数量
	var tableStr=[],tmpStrs;
	rows.map(function (r,i) {
		if (!(i%modulus)) {
			tmpStrs=thead;
		}
		tmpStrs+='<tr>';
		columns.map(function (c) {
			tmpStrs+='<td style="border-bottom:1px solid #ccc;border-right:1px solid #ccc;">'+r[c.field]+'</td>';
		})
		tmpStrs+='</tr>';
		if (!((i+1)%modulus)||(i==(rows.length-1))) {
			tmpStrs+='</table>';
			tableStr.push(tmpStrs);
		}
	})
	var LODOP = getLodop();
	LODOP.PRINT_INIT("医嘱明细查询");
	LODOP.SET_PRINT_PAGESIZE(0, 0, 0, "A4");
	console.log(tableStr);
	for (var i = 0; i < tableStr.length; i++) {
		if (i) {
			LODOP.NEWPAGE();
		}
		LODOP.ADD_PRINT_TABLE("25mm", "10mm", "180mm", "280mm", tableStr[i]);
	}
	var date = $HUI.datebox("#startDate").getValue()+" "+$("#startTime").timespinner('getValue')+"~"+$HUI.datebox("#endDate").getValue()+" "+$("#endTime").timespinner('getValue');
	var wardDesc = $('#ward').combobox("getText");
	LODOP.ADD_PRINT_TEXT("10mm", 277, 154, 32, "医嘱明细查询\n");
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 15);
	LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
	LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
	LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
	LODOP.ADD_PRINT_TEXT("20mm", "10mm", 100, 25, "日期:");
	LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
	LODOP.ADD_PRINT_TEXT("20mm", "20mm", 300, 25, date);
	LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
	LODOP.ADD_PRINT_TEXT("20mm", "80mm", 100, 25, "病区:");
	LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
	LODOP.ADD_PRINT_TEXT("20mm", "90mm", 374, 25, wardDesc);
	LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
	LODOP.PREVIEW();
}
function find(){
	var startDate = $HUI.datebox("#startDate").getValue()
	var endDate = $HUI.datebox("#endDate").getValue()
	var startTime = $("#startTime").timespinner('getValue')
	var endTime = $("#endTime").timespinner('getValue')
	var arcimArray = $('#arcimCombobox').combobox("getValues")
	var arcimStr = arcimArray.join("^")||allOrderId;
	if (!arcimStr) return $.messager.popover({msg: '没有要查询的医嘱！',type:'alert'});
	var wardId = $('#ward').combobox("getValue")
	freqFilter = $('#freqFilter').combobox('getValues');
	var tableData = $cm({
		ClassName: "Nur.Custom.NeedUnit.guardianshipOrderSheet",
		QueryName: "queryOrder",
		ResultSetType: 'array',
		WardId:wardId,
		StartDate:startDate,
		EndDate:endDate,
		ArcimStr:arcimStr,
		StartTime:startTime,
		EndTime:endTime,
	},false);
	var ffValue=[];
	for (var i = 0; i < tableData.length; i++) {
		var t = tableData[i],freq=t.frequency;
		if (freqFilter.indexOf(freq)>-1) {
			tableData.splice(i,1);
			i--;
			continue;
		}
		if (ffValue.indexOf(freq)<0) {
			ffValue.push(freq);
		}
	}
	for (var i = 0; i < freqFilterList.length; i++) {
		var v = freqFilterList[i].value;
		var ind=ffValue.indexOf(v);
		if (ind>-1) {
			ffValue.splice(ind,1);
		}
	}
	for (var i = 0; i < ffValue.length; i++) {
		freqFilterList.push({value:ffValue[i],desc:ffValue[i]})
	}
	$("#freqFilter").combobox({
		'data':freqFilterList
	});
	$('#freqFilter').combobox('setValues', freqFilter);
	$('#orderDatagrid').datagrid('loadData',{total:tableData.length,rows:tableData});
}
function initWard(){
	$HUI.combobox('#ward',{
	    valueField:'wardid',
	    textField:'warddesc',
	    width:'150',
	    selectOnNavigation:false,
		defaultFilter:6,
		onSelect: function () {
			initArcimCombobox();
		},
	})
	$HUI.combobox('#freqFilter',{
	    valueField:'value',
	    textField:'desc',
	    width:'100',
	    selectOnNavigation:false,
		defaultFilter:6,
		multiple:'true',
		data:freqFilterList
	})
	$('#freqFilter').combobox('setValues', freqFilter);
	$cm({
		ClassName: 'Nur.NIS.Service.Base.Ward',
		QueryName: 'GetallWardNew',
		rows: 999999999999999,
		hospid: session['LOGON.HOSPID'],
		bizTable: "Nur_IP_QueryOrderCfg",
	},function(res){
		$HUI.combobox('#ward',{
			data:res.rows
		});
		$('#ward').combobox('setValue', session['LOGON.WARDID']);
		if (!session['LOGON.WARDID']) {
			return;
		}else{
			$('#ward').combo('disable');
		}
		initArcimCombobox();
	})
}
function initDateTime(){
	$HUI.datebox("#startDate").setValue(formatDate(-6));
	$HUI.datebox("#endDate").setValue(formatDate(0));
	$("#startTime").timespinner('setValue',"00:00");
	$("#endTime").timespinner('setValue',"23:59");
}
function initArcimCombobox(){
	var arcimData = $cm({
		ClassName: 'Nur.Custom.NeedUnit.guardianshipOrderSheet',
		MethodName: 'getWardOrder',
		wardId: $('#ward').combobox('getValue'),
		hospDR: session['LOGON.HOSPID'],
		entireHosp: 1
	}, function(res){
		var orderIds=[];
		res.map(function (r) {
			orderIds.push(r.orderId);
		})
		allOrderId=orderIds.join("^");
		$('#arcimCombobox').combobox({
		    valueField:'orderId',
		    textField:'desc',
		    width:'200',
		    multiple:'true',
		    rowStyle:'checkbox',
		    data:res
		});
		if (allOrderId) find();
	})
}
function initDataGrid(){
	var columns = [[
		{field: "bed",title: "床号",width: 50,sortable:true,sorter:function(a,b){
			return parseInt(a||0)-parseInt(b||0);
		}},
		{field: "patName",title: "病人姓名",width: 50},
		{field: "orderName",title: "医嘱描述",width: 50},
		{field: "orderStartDateTime",title: "医嘱开始日期",width: 50},
		{field: "frequency",title: "频次",width: 50},
		{field: "notes",title: "备注",width: 50},
		{field: "orderId",title: "医嘱明细id",width: 50},
	]]
	$("#orderDatagrid").datagrid({
		title:$g("病人列表"),
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		toolbar: "#searchBar",
		remoteSort: false,
		columns: columns,
		sortName: "bed",
		fitColumns:true,
		onLoadSuccess: function(data){
			updateDomSize();
		},
	})
	updateDomSize();
}
/// 格式化日期  bianshuai 2014-09-18
function formatDate(t){
	var curr_Date = new Date();  
	curr_Date.setDate(curr_Date.getDate() + parseInt(t)); 
	var Year = curr_Date.getFullYear();
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	if(typeof(DateFormat)=="undefined"){ //2017-03-15 cy
		return Year+"-"+Month+"-"+Day;
	}else{
		if(DateFormat=="4"){ //日期格式 4:"DMY" DD/MM/YYYY 2017-03-07 cy
			return Day+"/"+Month+"/"+Year;
		}else if(DateFormat=="3"){ //日期格式 3:"YMD" YYYY-MM-DD
			return Year+"-"+Month+"-"+Day;
		}else if(DateFormat=="1"){ //日期格式 1:"MDY" MM/DD/YYYY
			return Month+"/"+Day+"/"+Year;
		}else{ //2017-03-15 cy
			return Year+"-"+Month+"-"+Day;
		}
	}
}
function updateDomSize() {
	var innerHeight=window.innerHeight;
	$('#orderDatagrid').datagrid('resize',{
		height:innerHeight-20
	});
}
window.addEventListener("resize",updateDomSize)