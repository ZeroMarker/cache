var PageLogicObj={
	CureReportDataGrid:"",
	EChartObj:""
}
$(document).ready(function(){
  	Init();
  	InitEvent();
  	LoadEchats();
  	//CureReportDataGridLoad()
});

function Init(){
	InitDate();
  	InitDoc(); 
  	InitArcimDesc(); 
  	PageLogicObj.CureReportDataGrid=InitCureReportDataGrid();	
}

function InitEvent(){
	$('#btnFind').bind('click', function(){
		   CureReportDataGridLoad();
    });
    
    $('#btnExport').bind('click', function(){
		   ExportCureReport();
    });
}

function InitCureReportDataGrid()
{
	var CureReportDataGrid=$('#tabRecordReportList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		singleSelect:true,    
		url : '',
		loadMsg : '加载中..',  
		pagination : true,
		rownumbers : true,
		idField:"seqno",
		pageSize : 20,
		pageList : [20,50,100],
		//<!--出参是：执行人、资源组（医嘱项）、执行数量、金额-->
		columns :[[ 
				{field:'seqno',title:'序号',width:30,hidden:true}, 
				{field:'CureAppUser',title:'开单医生',width:30}, 
				{field:'ArcimDesc',title:'治疗项目',width:50},								
				{field:'UnitPrice',title:'单价(元)',width:20}, 
				{field:'OrderQty',title:'数量',width:20}, 
				{field:'OrdBillUOM',title:'单位',width:30}, 
				{field:'OrdPrice',title:'总金额(元)',align:'right',width:30}, 
				{field:'Job',title:'Job',width:30,hidden:true}   
			 ]] 
	});
	return CureReportDataGrid
}
function CureReportDataGridLoad()
{
	$.messager.progress({
		title: "提示",
		text: '数据加载中...'
	});
	var StartDate=$("#StartDate").datebox("getValue");
	var EndDate=$("#EndDate").datebox("getValue");
	var queryDoc=$("#ComboDoc").combobox("getValue");
	var gtext=$HUI.lookup("#ComboArcim").getText();
	if(gtext=="")PageSizeItemObj.m_SelectArcimID="";
	var queryArcim=PageSizeItemObj.m_SelectArcimID;
	$.cm({
		ClassName:PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,
		QueryName:"QryWorkReportForDocApp",
		'StartDate':StartDate,
		'EndDate':EndDate,
		'UserID':session['LOGON.USERID'],
		'queryDoc':queryDoc,
		'queryArcim':queryArcim,
		Pagerows:PageLogicObj.CureReportDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.CureReportDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData);
		$.messager.progress("close");
		LoadEchatsData(GridData);
	})
}

function ExportCureReportOld(){
	try{
		var UserID=session['LOGON.USERID'];
		var RowIDs=PageLogicObj.CureReportDataGrid.datagrid('getRows');
		//if(RowIDs.length)
		var RowNum=RowIDs.length;
		if(RowNum==0){
			$.messager.alert("提示",$g("未有需要导出的数据"));
			return false;
		}
		PageLogicObj.CureReportDataGrid.datagrid('selectRow',0);
		var ProcessNo=""
		var row = PageLogicObj.CureReportDataGrid.datagrid('getSelected');
		if (row){
			ProcessNo=row.Job
		}

		if(ProcessNo==""){
			$.messager.alert("提示",$g("获取进程号错误"));
			return false;
		}
		var datacount=tkMakeServerCall(PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,"GetQryWorkReportForDocAppNum",ProcessNo,UserID);
		if(datacount==0){
			$.messager.alert("提示",$g("获取导出数据错误"));
			return false;
		}
		var xlApp,xlsheet,xlBook;
		var TemplatePath=ServerObj.PrintBath+"DHCDocCureWorkReportDocApp.xlsx";
		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(TemplatePath);
	    
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    xlsheet.PageSetup.RightMargin=0;
    	
    	var StartDate=$("#StartDate").datebox("getValue");
		var EndDate=$("#EndDate").datebox("getValue");
    	var DateStr=StartDate+"至"+EndDate
    	xlsheet.cells(2,2)=DateStr;
		var myret=tkMakeServerCall(PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,"GetLocDesc",session['LOGON.CTLOCID']);
		var Title=myret+"医生治疗申请工作量统计"
    	var xlsrow=3;
		xlsheet.cells(1,1)=Title;
	    for(var i=1;i<=datacount;i++){
			var ret=tkMakeServerCall(PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,"GetQryWorkReportForDocAppInfo",ProcessNo,i,UserID);
			if(ret=="") return ;
			var arr=ret.split("^");
			xlsrow=xlsrow+1;
			var FinishUser=arr[1]
			var ArcimDesc=arr[2]
			var UnitPrice=arr[3]
			var OrderQty=arr[4]
			var OrdBillUOM=arr[5]
			var OrdPrice=arr[6]
			if(OrdBillUOM!="")OrdBillUOM="/"+OrdBillUOM;
			xlsheet.cells(xlsrow,1)=FinishUser;
			xlsheet.cells(xlsrow,2)=ArcimDesc;
			xlsheet.cells(xlsrow,3)=UnitPrice;
		    xlsheet.cells(xlsrow,4)=OrderQty+OrdBillUOM;
		    xlsheet.cells(xlsrow,5)=OrdPrice;		    
	    }
	    xlsheet.printout;
	    gridlist(xlsheet,4,xlsrow,1,5)
		xlBook.Close (savechanges=true);
		xlApp.Quit();
		xlApp=null;
		xlsheet=null;
	}catch(e){
		alert(e.message);	
	}
}
/**
 * @author QP
 * @date 2019-12-26
 * @param {*}  
 */
function ExportCureReport(){
	try{
		//打印
		var PrintNum = 1; //打印次数
		var IndirPrint = "N"; //是否预览打印
		var TaskName="治疗站医生申请工作量报表"; //打印任务名称
		var StartDate=$("#StartDate").datebox("getValue");
		var EndDate=$("#EndDate").datebox("getValue");
		var queryDoc=$("#ComboDoc").combobox("getValue");
		var gtext=$HUI.lookup("#ComboArcim").getText();
		if(gtext=="")PageSizeItemObj.m_SelectArcimID="";
		var queryArcim=PageSizeItemObj.m_SelectArcimID;
		var Title=StartDate+"至"+EndDate+TaskName;
		var GridData=$.cm({
			ClassName:PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,
			QueryName:"QryWorkReportForDocApp",
			'StartDate':StartDate,
			'EndDate':EndDate,
			'UserID':session['LOGON.USERID'],
			'queryDoc':queryDoc,
			'queryArcim':queryArcim,
		},false)	
		var DetailData=GridData.rows; //明细信息
		if (DetailData.length==0) {
			$.messager.alert("提示",$g("没有需要打印的数据!"));
			return false
		}
		//明细信息展示
		var Cols=[
			{field:"CureAppUser",title:"开单医生",width:"10%",align:"left"},
			{field:"ArcimDesc",title:"治疗项目",width:"10%",align:"left"},
			{field:"UnitPrice",title:"单价(元)",width:"10%",align:"right"},
			{field:"OrderQty",title:"数量",width:"10%",align:"left"},
			{field:"OrdBillUOM",title:"单位",width:"10%",align:"left"},
			{field:"OrdPrice",title:"总金额(元)",width:"10%",align:"right"}
		];	
		PrintDocument(PrintNum,IndirPrint,TaskName,Title,Cols,DetailData)
	}catch(e){
		$.messager.alert("提示",e.message);	
	}
}


function LoadEchats(){
	var colors = ['#5793f3', '#d14a61', '#675bba'];
	var option = null;
	option = {
		title: {
            text: $g("医生申请工作量柱状图"),
            left: "center"
        },
        color: colors,
	    tooltip: {
	        trigger: 'axis',
	        axisPointer: {
	            type: 'cross'
	        }
	    },
	    grid: {
		    bottom: '15%',
		    top: 75,
	        right: '5%',
	        left:'3%'
	    },
	    toolbox: {
	        feature: {
	            /*dataView: {
		            title : $g("数据视图"),
		            lang :[$g('数据视图列表'), $g('关闭'), $g('刷新')],
		            show: true, 
		            readOnly: false,
		            optionToContent: function(opt) {
					    var axisData = opt.xAxis[0].data;
					    var series = opt.series;
					    var table = '<table style="width:100%;text-align:left"><tbody><tr>'
					                 + '<td>'+$g("开单医生")+'</td>'
					                 + '<td>' + series[0].name + '</td>'
					                 + '<td>' + series[1].name + '</td>'
					                 + '</tr>';
					    for (var i = 0, l = axisData.length; i < l; i++) {
					        table += '<tr>'
					                 + '<td>' + axisData[i] + '</td>'
					                 + '<td>' + series[0].data[i] + '</td>'
					                 + '<td>' + series[1].data[i] + '</td>'
					                 + '</tr>';
					    }
					    table += '</tbody></table>';
					    return table;
					}
				},*/
	            saveAsImage: {
		            title : $g("保存为图片"),
		            show: true
		        }
	        }
	    },
	    legend: {
		    data: [$g("申请数量"), $g("总金额(RMB/元)")],
		    top:30
		},
	    xAxis: [
	        {
	            type: 'category',
	            axisTick: {
	                alignWithLabel: true
	            },
	            data: []
	        }
	    ],
	    yAxis: [
	        {
	            type: 'value',
	            name: $g("申请数量"),
	            min: 0,
	            position: 'left',
	            axisLine: {
	                lineStyle: {
	                    color: colors[0]
	                }
	            },
	            axisLabel: {
	                formatter: '{value}'
	            }
	        },
	        {
	            type: 'value',
	            name: $g("总金额(RMB/元)"),
	            min: 0,
	            position: 'right',
	            axisLine: {
	                lineStyle: {
	                    color: colors[1]
	                }
	            },
	            axisLabel: {
	                formatter: '{value}'
	            }
	        }
	    ],
	    series: []
	};
	
	var dom = document.getElementById("container");
	PageLogicObj.EChartObj = echarts.init(dom);
	
	if (option && typeof option === "object") {
	    PageLogicObj.EChartObj.setOption(option, true);
	}	
}

function LoadEchatsData(data){
	var newdata=[];
	var name="";
	var NameArr=[];
	var QtyArr=[];
	var PriceArr=[];
	for(var i=0;i<data.total;i++){
		var onedata=data.originalRows[i]
		//alert(onedata)
		if(onedata.DCARowId!=""){
			var name=onedata.CureAppUser;
			var index=$.inArray(name, NameArr);
			if(index<0){
				NameArr.push(name)
			}
			continue;
		}
		var OrdPrice=parseFloat(onedata.OrdPrice);
		var OrderQty=parseFloat(onedata.OrderQty);
		QtyArr.push(OrderQty);
		PriceArr.push(OrdPrice)
	}	
	
	var seriesArr=[
        {
            name: $g("申请数量"),
            type: 'bar',
            data: QtyArr,
            markPoint: {
                data: [
                    {type: 'max', name: $g("最大值")},
                    {type: 'min', name: $g("最小值")}
                ]
            },
            markLine: {
                data: [
                    {type: 'average', name: $g("平均值")}
                ]
            }
        },
        {
            name: $g("总金额(RMB/元)"),
            type: 'bar',
            yAxisIndex: 1,
            data: PriceArr,
            markPoint: {
                data: [
                    {type: 'max', name: $g("最大值")},
                    {type: 'min', name: $g("最小值")}
                ]
            },
            markLine: {
                data: [
                    {type: 'average', name: $g("平均值")}
                ]
            }
        }
    ]
	workReport_InitItem.ReloadEChartData(PageLogicObj.EChartObj,NameArr,seriesArr)
}