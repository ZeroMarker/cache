$(function(){
	$("#inputCreateDateStart").datetimebox('setText',SDate);
	$("#inputCreateDateEnd").datetimebox('setText',EDate);
	eprPatient.StartDate=SDate
	eprPatient.EndDate =EDate
	InitDataList();
	CorectListView("CorectListView")
    AcceptRateView("UseListView")
    if(HISUIStyleCode == "lite"){
	    $(".div_center").css({'background-color':'#f5f5f5'});
	}
});
var eprPatient= new Object();
eprPatient.StartDate = "";
eprPatient.EndDate = "";

function InitDataList()
{
	//内涵质控采纳反馈率 表
	$('#CorectListTable').datagrid({ 
			//title:'标题',
			//headerCls:'panel-header-gray',
			pagination: true,
            pageSize: 10,
            pageList: [10, 20, 50],
			method: 'post',
            loadMsg: '加载中......',
			autoRowHeight: true,
			fitColumns:true,
			scrollbarSize:0,
			url:'../EPRservice.Quality.Ajax.AiAnalysis.cls',
			queryParams: {
				StartDate:eprPatient.StartDate,
				EndDate: eprPatient.EndDate,
				Action:"CorrectRate"
            },
			fit:true,
			columns:[[
				//{field: 'ckb', checkbox: true },
				{field:'startDate',title:'开始时间',width:100,align:'left'},
				{field:'endDate',title:'结束时间',width:100,align:'left'},
				{field:'ErrCount',title:'错误反馈',width:100,align:'left',
				formatter:function(value,row,index){ 
					return '<span style="color:#40a2de;cursor:pointer">'+row.ErrCount+'</span>'
					}
				},
				{field:'CorrectCount',title:'正确反馈',width:100,align:'left',
				formatter:function(value,row,index){ 
					return '<span style="color:#40a2de;cursor:pointer">'+row.CorrectCount+'</span>'
					}
				},
				{field:'Count',title:'合计',width:100,align:'left'},
				{field:'CorrectRate',title:'准确率',width:100,align:'left'},
			]],
			onLoadSuccess: function(data){   
		　　},
			onClickCell: function(rowIndex, field, value) {
					var rows = $('#CorectListTable').datagrid('getRows');
					var row = rows[rowIndex];
					var startDate = row.startDate;
					var endDate = row.endDate;
					if(field =='ErrCount'){	
						var urlstr = "dhc.emr.quality.AiAnalysisData.csp?startDate="+startDate+ '&endDate='+endDate+'&Type='+'AiErrDetail';
						if('undefined' != typeof websys_getMWToken)
						{
							urlstr += "&MWToken="+websys_getMWToken()
						}	
						//createModalDialog("AiAnalysisDataDetail"," ","1300","500","iframeAiAnalysisDataDetail","<iframe id='iframeAiAnalysisDataDetail' scrolling='auto' frameborder='0' src='" + urlstr +"' style='width:1300px; height:463px; display:block;'></iframe>","","")
						websys_showModal({
						iconCls:'icon-w-msg',
						url:urlstr,
						title:$g('错误反馈明细'),
						width:1300,height:500
						});
					}else if(field =='CorrectCount'){
						var urlstr = "dhc.emr.quality.AiAnalysisData.csp?startDate="+startDate+ '&endDate='+endDate+'&Type='+'AiCorrectDetail';	
						//createModalDialog("AiAnalysisDataDetail"," ","1300","500","iframeAiAnalysisDataDetail","<iframe id='iframeAiAnalysisDataDetail' scrolling='auto' frameborder='0' src='" + urlstr +"' style='width:1300px; height:463px; display:block;'></iframe>","","")
						if('undefined' != typeof websys_getMWToken)
						{
							urlstr += "&MWToken="+websys_getMWToken()
						}
						websys_showModal({
						iconCls:'icon-w-msg',
						url:urlstr,
						title:$g('评分明细'),
						width:1300,height:500
						});
					} 
				},
			loadFilter:function(data)
			{
				if(typeof data.length == 'number' && typeof data.splice == 'function'){
					data={total: data.length,rows: data}
				}
				var dg=$(this);
				var opts=dg.datagrid('options');
				var pager=dg.datagrid('getPager');
				pager.pagination({
					onSelectPage:function(pageNum, pageSize){
						opts.pageNumber=pageNum;
						opts.pageSize=pageSize;
						pager.pagination('refresh',{pageNumber:pageNum,pageSize:pageSize});
						dg.datagrid('loadData',data);
					}
				});
				if(!data.originalRows){
					data.originalRows = (data.rows);
				}
				var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
				var end = start + parseInt(opts.pageSize);
				data.rows = (data.originalRows.slice(start, end));
				return data;
			}
			}); 
				
	//内涵质控人工使用率 表
	$('#UseListTable').datagrid({ 
			pagination: true,
            pageSize: 10,
            pageList: [10, 20, 50],
			method: 'post',
            loadMsg: '加载中......',
			autoRowHeight: true,
			fitColumns:true,
			scrollbarSize:0,
			url:'../EPRservice.Quality.Ajax.AiAnalysis.cls',
			queryParams: {
				StartDate:eprPatient.StartDate,
				EndDate: eprPatient.EndDate,
				Action:"AcceptRate"
            },
			fit:true,
			columns:[[
				//{field: 'ckb', checkbox: true },
				{field:'startDate',title:'开始时间',width:100,align:'left'},
				{field:'endDate',title:'结束时间',width:100,align:'left'},
				{field:'AiCount',title:'内涵条目',width:100,align:'left',
				formatter:function(value,row,index){ 
					return '<span style="color:#40a2de;cursor:pointer">'+row.AiCount+'</span>'
					}
				},
				{field:'ManualCount',title:'手工条目',width:100,align:'left',
				formatter:function(value,row,index){ 
					return '<span style="color:#40a2de;cursor:pointer">'+row.ManualCount+'</span>'
					}
				},
				{field:'Count',title:'条目合计',width:100,align:'left'},
				{field:'EpiCount',title:'病历合计',width:100,align:'left'},
				{field:'AcceptRate',title:'使用率',width:100,align:'left'},
			]],
			onLoadSuccess: function(data){   
		　　},
			onClickCell: function(rowIndex, field, value) {
				var rows = $('#UseListTable').datagrid('getRows');
				var row = rows[rowIndex];
				var startDate = row.startDate;
				var endDate = row.endDate;
				if(field =='ManualCount'){	
					var urlstr = "dhc.emr.quality.AiAnalysisData.csp?startDate="+startDate+ '&endDate='+endDate+'&Type='+'ManualDetail';
					if('undefined' != typeof websys_getMWToken)
					{
						urlstr += "&MWToken="+websys_getMWToken()
					}	
					//createModalDialog("AiAnalysisDataDetail"," ","1300","500","iframeAiAnalysisDataDetail","<iframe id='iframeAiAnalysisDataDetail' scrolling='auto' frameborder='0' src='" + urlstr +"' style='width:1300px; height:463px; display:block;'></iframe>","","")
					websys_showModal({
						iconCls:'icon-w-msg',
						url:urlstr,
						title:$g('内涵质控评分'),
						width:1300,height:500
						});
				}else if(field =='AiCount'){
					var urlstr = "dhc.emr.quality.AiAnalysisData.csp?startDate="+startDate+ '&endDate='+endDate+'&Type='+'AiCorrectDetail';	
					if('undefined' != typeof websys_getMWToken)
					{
						urlstr += "&MWToken="+websys_getMWToken()
					}
					//createModalDialog("AiAnalysisDataDetail"," ","1300","500","iframeAiAnalysisDataDetail","<iframe id='iframeAiAnalysisDataDetail' scrolling='auto' frameborder='0' src='" + urlstr +"' style='width:1300px; height:463px; display:block;'></iframe>","","")
					websys_showModal({
						iconCls:'icon-w-msg',
						url:urlstr,
						title:$g('内涵质控评分'),
						width:1300,height:500
						});
				} 
			},
			loadFilter:function(data)
			{
				if(typeof data.length == 'number' && typeof data.splice == 'function'){
					data={total: data.length,rows: data}
				}
				var dg=$(this);
				var opts=dg.datagrid('options');
				var pager=dg.datagrid('getPager');
				pager.pagination({
					onSelectPage:function(pageNum, pageSize){
						opts.pageNumber=pageNum;
						opts.pageSize=pageSize;
						pager.pagination('refresh',{pageNumber:pageNum,pageSize:pageSize});
						dg.datagrid('loadData',data);
					}
				});
				if(!data.originalRows){
					data.originalRows = (data.rows);
				}
				var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
				var end = start + parseInt(opts.pageSize);
				data.rows = (data.originalRows.slice(start, end));
				return data;
			}
			}); 	
}

function doSearch()
{	
	var DateStart=$("#inputCreateDateStart").datetimebox('getText');
	var DateEnd=$("#inputCreateDateEnd").datetimebox('getText')
	eprPatient.StartDate=DateStart;
	eprPatient.EndDate =DateEnd;	
    CorectListView("CorectListView")
    AcceptRateView("UseListView")
	
	var CorectQueryParams = $('#CorectListTable').datagrid('options').queryParams;
    CorectQueryParams.StartDate = DateStart;
    CorectQueryParams.EndDate =DateEnd;
    $('#CorectListTable').datagrid('options').queryParams = CorectQueryParams;
    $('#CorectListTable').datagrid('reload');
    	
    var UseQueryParams = $('#UseListTable').datagrid('options').queryParams;
    UseQueryParams.StartDate =DateStart; 
    UseQueryParams.EndDate =DateEnd;
    $('#UseListTable').datagrid('options').queryParams = UseQueryParams;
    $('#UseListTable').datagrid('reload');	
    
       	
}

function exportExcel(){
    var options = $('#patientListTable').datagrid('getPager').data("pagination").options; 
    var curr = options.pageNumber; 
    var total = options.total;
    var pager = $('#patientListTable').datagrid('getPager');
    var rows = []
    for (i=1;i<=((total/options.pageSize)+1);i++)
    {
	     pager.pagination('select',i);
         pager.pagination('refresh');
         var currows =  $('#patientListTable').datagrid('getRows');
         if (currows.length==0)
         {
	         continue;
	     }
         for (var j in currows)
         {
	         rows.push(currows[j]);
	     }
	}
	 pager.pagination('select',curr);
     pager.pagination('refresh');
	$('#patientListTable').datagrid('toExcel',{
		filename:'内涵质控触犯修正明细.xls',
		rows:rows
		});
	}
	
//内涵质控采纳反馈率 图
function CorectListView(ElementID)
{
	
	jQuery.ajax({
				type: "get",
				dataType: "json",
				url: "../EPRservice.Quality.Ajax.AiAnalysis.cls",
				async: true,
				data: {
					"Action":"CorrectRateView",	
					"StartDate":eprPatient.StartDate,
					"EndDate": eprPatient.EndDate,	
				},
				success: function(d) {
					var Date=[];
					var CorrectRate=[];
					for (var i = d.length-1; i >=0; i--) {
						Date.push(d[i].Date)
						CorrectRate.push(d[i].CorrectRate)
					} 
				var showLine = echarts.init(document.getElementById(ElementID));
				showLine.setOption(Line(emrTrans('内涵质控采纳反馈率'),Date,CorrectRate));
				
				}
	})
}

//内涵质控人工使用率 图
function AcceptRateView(ElementID)
{
	
	jQuery.ajax({
				type: "get",
				dataType: "json",
				url: "../EPRservice.Quality.Ajax.AiAnalysis.cls",
				async: true,
				data: {
					"Action":"AcceptRateView",	
					"StartDate":eprPatient.StartDate,
					"EndDate": eprPatient.EndDate,	
				},
				success: function(d) {
					var Date=[];
					var DateDesc=[];
					var AcceptRate=[];
					for (var i = d.length-1; i >=0; i--) {
						Date.push(d[i].Date)
						DateDesc.push(d[i].DateDesc)
						AcceptRate.push(d[i].AcceptRate)
					} 
				var showLine = echarts.init(document.getElementById(ElementID));
				showLine.setOption(Line(emrTrans('内涵质控人工使用率'),Date,AcceptRate));
				
				}
	})
}
function Line(Title,xAxisData,Data)
{
	option = {
		title: {
	        text: Title
	    },
	    tooltip: {
	        trigger: 'axis',
	        /*formatter:'{a}{b}{c}{d}'
	        formatter: function (params) {
		        console.log(params)
                return params.name + '<br />' + (params.value  * 100).toFixed(1) + '%';
                
            }*/
	    },
	    grid: {
	        left: '2%',
	        right: '3%',
	        bottom: '7%',
	        containLabel: true
	    },
	    xAxis: {
	        type: 'category',
	        data: xAxisData,
	        axisTick: {
	                alignWithLabel: true
	            },
	        axisLabel:{
		        	rotate:20
	        }
	    },
	    yAxis: {
	        type: 'value',
	        axisLabel: {
                formatter: '{value} %'
            },
            max: function (value) {
			    return '100';
			}
            
	    },
	    series: [{
	        data: Data,
	        type: 'line',
	        itemStyle: {        //上方显示数值
                normal: {
                    label: {
                        show: true, //开启显示
                        position: 'top', //在上方显示
                        textStyle: { //数值样式
                            color: 'black',
                            
                        },
                        formatter: '{c} %'
                    }
                }
	        }
	    }],
	    color:['#4ECB73']
	};
	return option
}