var PageLogicObj={
	CureReportDataGrid:"",
	EChartObj:"",
	cspName:"doccure.workreport.user.hui.csp"
}
$(document).ready(function(){
	Init();
	InitEvent();
	CureReportDataGridLoad();
});

function Init(){
	InitDate();
	InitDoc(); 
  	InitArcimDesc(); 
  	LoadEchats();
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
		pagination : true,  //
		rownumbers : true,  //
		idField:"seqno",
		//pageNumber:0,
		pageSize : 20,
		pageList : [20,50,100],
		//<!--出参是：执行人、资源组（医嘱项）、执行数量、金额-->
		columns :[[ 
				{field:'seqno',title:'序号',width:30,hidden:true}, 
				{field:'FinishUser',title:'执行人',width:30}, 
				{field:'ArcimDesc',title:'治疗项目',width:50},								
				{field:'UnitPrice',title:'单价(元)',width:20}, 
				{field:'OrderQty',title:'执行数量',width:20}, 
				{field:'OrdBillUOM',title:'单位',width:30}, 
				{field:'OrdPrice',title:'总金额(元)',align:'right',width:30}, 
				{field:'Job',title:'Job',width:30,hidden:true}   
			 ]] 
	});
	return CureReportDataGrid;
}
function CureReportDataGridLoad()
{
	var StartDate=$("#StartDate").datebox("getValue");
	var EndDate=$("#EndDate").datebox("getValue");
	var queryDoc=$("#ComboDoc").combobox("getValue");
	var gtext=$HUI.lookup("#ComboArcim").getText();
	if(gtext=="")PageSizeItemObj.m_SelectArcimID="";
	var queryArcim=PageSizeItemObj.m_SelectArcimID;
	var ExpStr=PageLogicObj.cspName+ "^" + com_Util.GetSessionStr();
	$.cm({
		ClassName:PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,
		QueryName:"QryWorkReportFor",
		'query':"doc",
		'StartDate':StartDate,
		'EndDate':EndDate,
		'UserID':session['LOGON.USERID'],
		'queryDoc':queryDoc,
		'queryLoc':session['LOGON.CTLOCID'],
		'queryArcim':queryArcim,
		ExpStr:ExpStr,
		Pagerows:PageLogicObj.CureReportDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.CureReportDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
		LoadEchatsData(GridData);
	})	
}

function ExportCureReport(){
	try{
		var StartDate=$("#StartDate").datebox("getValue");
		var EndDate=$("#EndDate").datebox("getValue");
		var queryDoc=$("#ComboDoc").combobox("getValue");
		var gtext=$HUI.lookup("#ComboArcim").getText();
		if(gtext=="")PageSizeItemObj.m_SelectArcimID="";
		var queryArcim=PageSizeItemObj.m_SelectArcimID;	
		var myret=tkMakeServerCall(PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,"GetLocDesc",session['LOGON.CTLOCID'],session['LOGON.LANGID']);
		var Title=myret+$g("个人治疗工作量统计")
		var ExpStr=PageLogicObj.cspName+ "^" + com_Util.GetSessionStr();
		//导出
		var rtn = $cm({
			dataType:'text',
			ResultSetType:'Excel',
			ExcelName:Title,
			ClassName:PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,
			QueryName:"QryWorkReportForExport",
			'query':"doc",
			'StartDate':StartDate,
			'EndDate':EndDate,
			'UserID':session['LOGON.USERID'],
			'queryDoc':queryDoc,
			'queryLoc':session['LOGON.CTLOCID'],
			'queryArcim':queryArcim,
			ExpStr:ExpStr
		}, false);
		if(typeof websys_writeMWToken=='function') rtn=websys_writeMWToken(rtn);
		location.href = rtn;
		//打印
		var PrintNum = 1; //打印次数
		var IndirPrint = "N"; //是否预览打印
		var TaskName=Title; //打印任务名称
		
		var GridData=$.cm({
			ClassName:PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,
			QueryName:"QryWorkReportForExport",
			'query':"doc",
			'StartDate':StartDate,
			'EndDate':EndDate,
			'UserID':session['LOGON.USERID'],
			'queryDoc':queryDoc,
			'queryLoc':session['LOGON.CTLOCID'],
			'queryArcim':queryArcim,
			ExpStr:ExpStr,
			Pagerows:PageLogicObj.CureReportDataGrid.datagrid("options").pageSize,
			rows:99999
		},false)	
		var DetailData=GridData.rows; //明细信息
		if (DetailData.length==0) {
			$.messager.alert("提示","没有需要打印的数据!");
			return false
		}
		//明细信息展示
		var Cols=[
			{field:"FinishUser",title:$g("执行人"),width:"10%",align:"left"},
			{field:"ArcimDesc",title:$g("治疗项目"),width:"10%",align:"left"},
			{field:"UnitPrice",title:$g("单价(元)"),width:"10%",align:"right"},
			{field:"OrderQty",title:$g("执行数量"),width:"10%",align:"right"},
			{field:"OrdPrice",title:$g("总金额"),width:"10%",align:"right"}
		];	
		PrintDocument(PrintNum,IndirPrint,TaskName,Title,Cols,DetailData)
		return;
	}catch(e){
		$.messager.alert("提示",e.message,"error");
	}
}

function LoadEchats(){
	var colors = ['#5793f3', '#d14a61', '#675bba'];
	var option = null;
	option = {
		title: {
            text: $g('个人工作量柱状图'),
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
		            show: true, 
		            title: $g('数据视图'),
		            lang:[$g('数据视图'), $g('关闭'), $g('刷新')],
		            readOnly: false,
		            optionToContent: function(opt) {
					    var axisData = opt.xAxis[0].data;
					    var series = opt.series;
					    var table = '<table class="c-tbl-line"><tbody><tr class="datagrid-header-row">'
					                + '<td class="c-tb-th">'+$g("治疗项目")+'</td>'
					                + '<td class="c-tb-th">' + series[0].name + '</td>'
					                + '<td class="c-tb-th">' + series[1].name + '</td>'
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
	            //restore: {show: true},
	            saveAsImage: {
		            show: true,
		            title: $g('保存为图片')
		        }
	        }
	    },
	    legend: {
		    data: [$g('治疗次数'), $g('工作量(RMB/元)')],
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
	            name: $g('治疗次数'),
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
	            name: $g('工作量(RMB/元)'),
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
			var name=onedata.FinishUser;
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
            name: $g('治疗次数'),
            type: 'bar',
            yAxisIndex: 0,
            data: QtyArr,
            markPoint: {
                data: [
                    {type: 'max', name: $g('最大值')},
                    {type: 'min', name: $g('最小值')}
                ]
            },
            markLine: {
                data: [
                    {type: 'average', name: $g('平均值')}
                ]
            }
        },
        {
            name: $g('工作量(RMB/元)'),
            type: 'bar',
            yAxisIndex: 1,
            data: PriceArr,
            markPoint: {
                data: [
                    {type: 'max', name: $g('最大值')},
                    {type: 'min', name: $g('最小值')}
                ]
            },
            markLine: {
                data: [
                    {type: 'average', name: $g('平均值')}
                ]
            }
        }
    ]
	workReport_InitItem.ReloadEChartData(PageLogicObj.EChartObj,NameArr,seriesArr)
}