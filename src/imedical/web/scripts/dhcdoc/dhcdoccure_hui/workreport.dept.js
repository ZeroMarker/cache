var PageLogicObj={
	CureReportDataGrid:"",
	EChartObj:"",
	cspName:"doccure.workreport.dept.hui.csp"
}
$(document).ready(function(){
	Init();
	InitEvent();
	CureReportDataGridLoad();
});

function Init(){
	InitDate();
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
		loadMsg : '������..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"seqno",
		//pageNumber:0,
		pageSize : 20,
		pageList : [20,50,100],
		columns :[[ 
				{field:'seqno',title:'���',width:30,hidden:true}, 
				{field:'TLocDesc',title:'����',width:50},	
				{field:'ArcimDesc',title:'������Ŀ',width:100},						
				{field:'UnitPrice',title:'����/Ԫ',width:20}, 
				{field:'OrderQty',title:'ִ������',width:20}, 
				{field:'OrdBillUOM',title:'��λ',width:30}, 
				{field:'OrdPrice',title:'�ܽ��/Ԫ',width:30,align:'right'}, 
				{field:'Job',title:'Job',width:30,align:'center',hidden:true}   
			 ]] 
	});
	return CureReportDataGrid;
}
function CureReportDataGridLoad()
{
	var StartDate=$("#StartDate").datebox("getValue");
	var EndDate=$("#EndDate").datebox("getValue");
	//var queryDoc=$("#ComboDoc").combogrid("getValue");
	var gtext=$HUI.lookup("#ComboArcim").getText();
	if(gtext=="")PageSizeItemObj.m_SelectArcimID="";
	var queryArcim=PageSizeItemObj.m_SelectArcimID;
	var ExpStr=PageLogicObj.cspName+ "^" + com_Util.GetSessionStr();
	$.cm({
		ClassName:PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,
		QueryName:"QryWorkReportFor",
		'query':"dept",
		'StartDate':StartDate,
		'EndDate':EndDate,
		'UserID':session['LOGON.USERID'],
		'queryDoc':"",
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
		var gtext=$HUI.lookup("#ComboArcim").getText();
		if(gtext=="")PageSizeItemObj.m_SelectArcimID="";
		var queryArcim=PageSizeItemObj.m_SelectArcimID;
		var myret=tkMakeServerCall(PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,"GetLocDesc",session['LOGON.CTLOCID'],session['LOGON.LANGID']);
		var Title=myret+$g("�������ƹ�����ͳ��");
		var ExpStr=PageLogicObj.cspName+ "^" + com_Util.GetSessionStr();
		//����
		var rtn = $cm({
			dataType:'text',
			ResultSetType:'Excel',
			ExcelName:Title,
			ClassName:PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,
			QueryName:"QryWorkReportForLocExport",
			'query':"dept",
			'StartDate':StartDate,
			'EndDate':EndDate,
			'UserID':session['LOGON.USERID'],
			'queryDoc':"",
			'queryLoc':session['LOGON.CTLOCID'],
			'queryArcim':queryArcim,
			ExpStr:ExpStr
		}, false);
		if(typeof websys_writeMWToken=='function') rtn=websys_writeMWToken(rtn);
		location.href = rtn;
		//��ӡ
		var PrintNum = 1; //��ӡ����
		var IndirPrint = "N"; //�Ƿ�Ԥ����ӡ
		var TaskName=Title; //��ӡ��������
		
		var GridData=$.cm({
			ClassName:PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,
			QueryName:"QryWorkReportForLocExport",
			'query':"dept",
			'StartDate':StartDate,
			'EndDate':EndDate,
			'UserID':session['LOGON.USERID'],
			'queryDoc':"",
			'queryLoc':session['LOGON.CTLOCID'],
			'queryArcim':queryArcim,
			ExpStr:ExpStr,
			Pagerows:PageLogicObj.CureReportDataGrid.datagrid("options").pageSize,
			rows:99999
		},false)	
		var DetailData=GridData.rows; //��ϸ��Ϣ
		if (DetailData.length==0) {
			$.messager.alert("��ʾ","û����Ҫ��ӡ������!");
			return false
		}
		//��ϸ��Ϣչʾ
		var Cols=[
			{field:"LocDesc",title:"����",width:"20%",align:"left"},
			{field:"ArcimDesc",title:"������Ŀ",width:"20%",align:"left"},
			{field:"UnitPrice",title:"����(Ԫ)",width:"10%",align:"right"},
			{field:"OrderQty",title:"ִ������",width:"10%",align:"right"},
			{field:"OrdPrice",title:"�ܽ��",width:"10%",align:"right"}
		];	
		PrintDocument(PrintNum,IndirPrint,TaskName,Title,Cols,DetailData)
		return;
	}catch(e){
		$.messager.alert("��ʾ",e.message,"error");
	}
}

function LoadEchats(){
	var colors = ['#5793f3', '#d14a61', '#675bba'];
	var option = null;
	option = {
		title: {
            text: $g('���ҹ�������״ͼ'),
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
		            readOnly: false,
					title: $g('������ͼ'),
					lang:[$g('������ͼ'), $g('�ر�'), $g('ˢ��')],
		            optionToContent: function(opt) {
					    var axisData = opt.xAxis[0].data;
					    var series = opt.series;
					    var table = '<table style="width:100%;text-align:left"><tbody><tr>'
					                 + '<td>'+$g("����������Ŀ")+'</td>'
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
	            //restore: {show: true},
	            saveAsImage: {
					show: true,
					title: $g('����ΪͼƬ')
				}
	        }
	    },
	    legend: {
		    data: [$g('ִ������'), $g('������(RMB/Ԫ)')],
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
	            name: $g('ִ������'),
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
	            name: $g('������(RMB/Ԫ)'),
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
	    series: [
	    	{
	            name: $g('ִ������'),
	            type: 'bar',
	            yAxisIndex: 0,
	            data: []
	        },
	        {
	            name: $g('������(RMB/Ԫ)'),
	            type: 'bar',
	            yAxisIndex: 1,
	            data: []
	        }
        ]
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
		if(onedata.DCARowId==""){
			continue;
		}
		var locname=onedata.TLocDesc;
		var name=locname+String.fromCharCode(10)+onedata.ArcimDesc;
		var index=$.inArray(name, NameArr);
		if(index<0){
			NameArr.push(name)
		}
		var OrdPrice=parseFloat(onedata.OrdPrice);
		var OrderQty=parseFloat(onedata.OrderQty);
		QtyArr.push(OrderQty);
		PriceArr.push(OrdPrice)
	}	
	
	var seriesArr=[
        {
            name: $g('ִ������'),
            type: 'bar',
            yAxisIndex: 0,
            data: QtyArr,
            markPoint: {
                data: [
                    {type: 'max', name: $g('���ֵ')},
                    {type: 'min', name: $g('��Сֵ')}
                ]
            },
            markLine: {
                data: [
                    {type: 'average', name: $g('ƽ��ֵ')}
                ]
            }
        },
        {
            name: $g('������(RMB/Ԫ)'),
            type: 'bar',
            yAxisIndex: 1,
            data: PriceArr,
            markPoint: {
                data: [
                    {type: 'max', name: $g('���ֵ')},
                    {type: 'min', name: $g('��Сֵ')}
                ]
            },
            markLine: {
                data: [
                    {type: 'average', name: $g('ƽ��ֵ')}
                ]
            }
        }
    ]
	workReport_InitItem.ReloadEChartData(PageLogicObj.EChartObj,NameArr,seriesArr)
}
