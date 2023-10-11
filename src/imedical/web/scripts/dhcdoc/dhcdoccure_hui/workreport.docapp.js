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
		loadMsg : '������..',  
		pagination : true,
		rownumbers : true,
		idField:"seqno",
		pageSize : 20,
		pageList : [20,50,100],
		//<!--�����ǣ�ִ���ˡ���Դ�飨ҽ�����ִ�����������-->
		columns :[[ 
				{field:'seqno',title:'���',width:30,hidden:true}, 
				{field:'CureAppUser',title:'����ҽ��',width:30}, 
				{field:'ArcimDesc',title:'������Ŀ',width:50},								
				{field:'UnitPrice',title:'����(Ԫ)',width:20}, 
				{field:'OrderQty',title:'����',width:20}, 
				{field:'OrdBillUOM',title:'��λ',width:30}, 
				{field:'OrdPrice',title:'�ܽ��(Ԫ)',align:'right',width:30}, 
				{field:'Job',title:'Job',width:30,hidden:true}   
			 ]] 
	});
	return CureReportDataGrid
}
function CureReportDataGridLoad()
{
	$.messager.progress({
		title: "��ʾ",
		text: '���ݼ�����...'
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
			$.messager.alert("��ʾ",$g("δ����Ҫ����������"));
			return false;
		}
		PageLogicObj.CureReportDataGrid.datagrid('selectRow',0);
		var ProcessNo=""
		var row = PageLogicObj.CureReportDataGrid.datagrid('getSelected');
		if (row){
			ProcessNo=row.Job
		}

		if(ProcessNo==""){
			$.messager.alert("��ʾ",$g("��ȡ���̺Ŵ���"));
			return false;
		}
		var datacount=tkMakeServerCall(PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,"GetQryWorkReportForDocAppNum",ProcessNo,UserID);
		if(datacount==0){
			$.messager.alert("��ʾ",$g("��ȡ�������ݴ���"));
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
    	var DateStr=StartDate+"��"+EndDate
    	xlsheet.cells(2,2)=DateStr;
		var myret=tkMakeServerCall(PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,"GetLocDesc",session['LOGON.CTLOCID']);
		var Title=myret+"ҽ���������빤����ͳ��"
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
		//��ӡ
		var PrintNum = 1; //��ӡ����
		var IndirPrint = "N"; //�Ƿ�Ԥ����ӡ
		var TaskName="����վҽ�����빤��������"; //��ӡ��������
		var StartDate=$("#StartDate").datebox("getValue");
		var EndDate=$("#EndDate").datebox("getValue");
		var queryDoc=$("#ComboDoc").combobox("getValue");
		var gtext=$HUI.lookup("#ComboArcim").getText();
		if(gtext=="")PageSizeItemObj.m_SelectArcimID="";
		var queryArcim=PageSizeItemObj.m_SelectArcimID;
		var Title=StartDate+"��"+EndDate+TaskName;
		var GridData=$.cm({
			ClassName:PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,
			QueryName:"QryWorkReportForDocApp",
			'StartDate':StartDate,
			'EndDate':EndDate,
			'UserID':session['LOGON.USERID'],
			'queryDoc':queryDoc,
			'queryArcim':queryArcim,
		},false)	
		var DetailData=GridData.rows; //��ϸ��Ϣ
		if (DetailData.length==0) {
			$.messager.alert("��ʾ",$g("û����Ҫ��ӡ������!"));
			return false
		}
		//��ϸ��Ϣչʾ
		var Cols=[
			{field:"CureAppUser",title:"����ҽ��",width:"10%",align:"left"},
			{field:"ArcimDesc",title:"������Ŀ",width:"10%",align:"left"},
			{field:"UnitPrice",title:"����(Ԫ)",width:"10%",align:"right"},
			{field:"OrderQty",title:"����",width:"10%",align:"left"},
			{field:"OrdBillUOM",title:"��λ",width:"10%",align:"left"},
			{field:"OrdPrice",title:"�ܽ��(Ԫ)",width:"10%",align:"right"}
		];	
		PrintDocument(PrintNum,IndirPrint,TaskName,Title,Cols,DetailData)
	}catch(e){
		$.messager.alert("��ʾ",e.message);	
	}
}


function LoadEchats(){
	var colors = ['#5793f3', '#d14a61', '#675bba'];
	var option = null;
	option = {
		title: {
            text: $g("ҽ�����빤������״ͼ"),
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
		            title : $g("������ͼ"),
		            lang :[$g('������ͼ�б�'), $g('�ر�'), $g('ˢ��')],
		            show: true, 
		            readOnly: false,
		            optionToContent: function(opt) {
					    var axisData = opt.xAxis[0].data;
					    var series = opt.series;
					    var table = '<table style="width:100%;text-align:left"><tbody><tr>'
					                 + '<td>'+$g("����ҽ��")+'</td>'
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
		            title : $g("����ΪͼƬ"),
		            show: true
		        }
	        }
	    },
	    legend: {
		    data: [$g("��������"), $g("�ܽ��(RMB/Ԫ)")],
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
	            name: $g("��������"),
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
	            name: $g("�ܽ��(RMB/Ԫ)"),
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
            name: $g("��������"),
            type: 'bar',
            data: QtyArr,
            markPoint: {
                data: [
                    {type: 'max', name: $g("���ֵ")},
                    {type: 'min', name: $g("��Сֵ")}
                ]
            },
            markLine: {
                data: [
                    {type: 'average', name: $g("ƽ��ֵ")}
                ]
            }
        },
        {
            name: $g("�ܽ��(RMB/Ԫ)"),
            type: 'bar',
            yAxisIndex: 1,
            data: PriceArr,
            markPoint: {
                data: [
                    {type: 'max', name: $g("���ֵ")},
                    {type: 'min', name: $g("��Сֵ")}
                ]
            },
            markLine: {
                data: [
                    {type: 'average', name: $g("ƽ��ֵ")}
                ]
            }
        }
    ]
	workReport_InitItem.ReloadEChartData(PageLogicObj.EChartObj,NameArr,seriesArr)
}