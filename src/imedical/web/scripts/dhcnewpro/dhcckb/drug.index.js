function initPageDefault()
{
	InitHxy(); 
	
	initQqa();
	
	InitQnp();
}

function InitHxy(){
	/// 区域统计
	require.config({
        paths: {
            echarts: '../scripts/dhcnewpro/plugins/echarts/echarts-2.2.1/build/dist'
        }
    });
    require(
        [
            'echarts',
            'echarts/chart/bar',
            'echarts/chart/line'
        ],
        InitAreaChart //异步加载的回调函数绘制图表 
    );
    
    /// 药品目录
    require.config({
        paths: {
            echarts: '../scripts/dhcnewpro/plugins/echarts/echarts-2.2.1/build/dist'
        }
    });
    require(
        [
            'echarts',
            'echarts/chart/bar',
            'echarts/chart/line'
        ],
        InitMenuChart //异步加载的回调函数绘制图表 
    ); 
    
    /// 药品目录-自
    require.config({
        paths: {
            echarts: '../scripts/dhcnewpro/plugins/echarts/echarts-2.2.1/build/dist'
        }
    });
    require(
        [
            'echarts',
            'echarts/chart/bar',
            'echarts/chart/line'
        ],
        InitMenuSelfChart //异步加载的回调函数绘制图表 
    ); 
    
    /// 药品规则
    require.config({
        paths: {
            echarts: '../scripts/dhcnewpro/plugins/echarts/echarts-2.2.1/build/dist'
        }
    });
    require(
        [
            'echarts',
            'echarts/chart/bar',
            'echarts/chart/line'
        ],
        InitRuleChart //异步加载的回调函数绘制图表 
    );
    
    /// 药品规则-自
    require.config({
        paths: {
            echarts: '../scripts/dhcnewpro/plugins/echarts/echarts-2.2.1/build/dist'
        }
    });
    require(
        [
            'echarts',
            'echarts/chart/bar',
            'echarts/chart/line'
        ],
        InitRuleSelfChart //异步加载的回调函数绘制图表 
    );

    
	/*InitAreaChart(); /// 区域统计
	InitMenuChart(); /// 药品目录
	InitMenuSelfChart(); /// 药品目录-自
	InitRuleChart(); /// 药品规则
	InitRuleSelfChart(); /// 药品规则-自*/
}

/// 区域统计
function InitAreaChart(echarts){
	/*var option = ECharts.ChartOptionTemplates.Bars([{"name":"江汉区","group":"访问数量","value":"1080"},{"name":"青山区","group":"访问数量","value":"781"},{"name":"汉阳区","group":"访问数量","value":"800"},{"name":"武昌区","group":"访问数量","value":"800"},{"name":"硚口区","group":"访问数量","value":"1000"},{"name":"东西湖区","group":"访问数量","value":"651"}]); 
	option.title ={
		text: '', ///'审查指标趋势图',
		subtext: '', ///'饼状图',
		x:'center'
	},
	option.color=['#3398DB']
	var container = document.getElementById('areaCharts');
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);  */
	
	var option = {
		color:['#2DC6CB'],
	    toolbox: {
	        show: true,
	        feature: {
	            magicType: {show: true, type: ['line', 'bar']},
	            restore: {show: true},
	        }
	    },
	    title: {
	        text: '',
	        subtext: ''
	    },
	    tooltip: {
	        trigger: 'axis',
	        axisPointer: {
	            type: 'shadow'
	        }
	    },
	    legend: {
	        data: ['访问数量']
	    },
	    calculable: true,
	    xAxis: {
	        type: 'value',
	    },
	    yAxis: {
	        type: 'category',
	        data: ['江汉区', '青山区', '汉阳区', '武昌区', '硚口区', '东西湖区']
	    },
	    series: [
	        {
	            name: '访问数量',
	            type: 'bar',
	            data: [1080, 1000, 800, 800, 781, 651]
	        }
	    ]
	};
	
	var myChart = echarts.init(document.getElementById('areaCharts'));
	// 使用刚指定的配置项和数据显示图表。
    myChart.setOption(option);
                                                                        
}

/// 药品目录
function InitMenuChart(echarts){
	/*var option = ECharts.ChartOptionTemplates.Bars([{"name":"武汉总院","group":"药品目录","value":"9500"},{"name":"武汉一院","group":"药品目录","value":"9200"},{"name":"武汉二院","group":"药品目录","value":"9300"},{"name":"武汉三院","group":"药品目录","value":"9400"},{"name":"武汉东院","group":"药品目录","value":"9500"},{"name":"武汉西院","group":"药品目录","value":"8900"}]); 
	option.title ={
		text: '', ///'审查指标趋势图',
		subtext: '', ///'饼状图',
		x:'center'
	},
	option.color=['#3398DB']
	var container = document.getElementById('menuCharts');
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt); */
	var option = {
		color:['#2DC6CB'],
		toolbox: {
	        show: true,
	        feature: {
	            magicType: {show: true, type: ['line', 'bar']},
	            restore: {show: true},
	        }
	    },
	    title: {
	        text: '',
	        subtext: ''
	    },
	    tooltip: {
	        trigger: 'axis',
	        axisPointer: {
	            type: 'shadow'
	        }
	    },
	    legend: {
	        data: ['药品目录']
	    },
	    grid: {
	        left: '4%',
	        right: '3%',
	        bottom: '4%',
	        containLabel: false
	    },
	    xAxis: {
	        type: 'value',
	        boundaryGap: [0, 0.1]
	    },
	    yAxis: {
	        type: 'category',
	        triggerEvent:true,
	        data: ['武汉总院', '武汉一院', '武汉二院', '武汉三院', '武汉东院', '武汉西院']
	    },
	    series: [
	        {
	            name: '药品目录',
	            type: 'bar',
	            data: [9500, 9500, 9400, 9300, 9200, 8900]
	        }
	    ]
	};
	
	var myChart = echarts.init(document.getElementById('menuCharts'));
	// 使用刚指定的配置项和数据显示图表。
    myChart.setOption(option);                                                                          
}

function InitMenuSelfChart(echarts){
	/*var option = ECharts.ChartOptionTemplates.Bars([{"name":"武汉总院","group":"药品目录","value":"2900"},{"name":"武汉一院","group":"药品目录","value":"4200"},{"name":"武汉二院","group":"药品目录","value":"2000"},{"name":"武汉三院","group":"药品目录","value":"3200"},{"name":"武汉东院","group":"药品目录","value":"2800"},{"name":"武汉西院","group":"药品目录","value":"2200"}]); 
	option.title ={
		text: '', ///'审查指标趋势图',
		subtext: '', ///'饼状图',
		x:'center'
	},
	option.color=['#3398DB']
	var container = document.getElementById('menuSelfCharts');
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);  */
	var option = {
		color:['#2DC6CB'],
		toolbox: {
	        show: true,
	        feature: {
	            magicType: {show: true, type: ['line', 'bar']},
	            restore: {show: true},
	        }
	    },
	    title: {
	        text: '',
	        subtext: ''
	    },
	    tooltip: {
	        trigger: 'axis',
	        axisPointer: {
	            type: 'shadow'
	        }
	    },
	    legend: {
	        data: ['药品目录']
	    },
	    grid: {
	        left: '4%',
	        right: '3%',
	        bottom: '4%',
	        containLabel: false
	    },
	    xAxis: {
	        type: 'value',
	        boundaryGap: [0, 0.1]
	    },
	    yAxis: {
	        type: 'category',
	        triggerEvent:true,
	        data: ['武汉总院', '武汉一院', '武汉二院', '武汉三院', '武汉东院', '武汉西院']
	    },
	    series: [
	        {
	            name: '药品目录',
	            type: 'bar',
	            data: [4200,3200,2800,2700,2200,2000]
	        }
	    ]
	};
	
	var myChart = echarts.init(document.getElementById('menuSelfCharts'));
	// 使用刚指定的配置项和数据显示图表。
    myChart.setOption(option);                                                                     
}

function InitRuleChart(echarts){
	/*var option = ECharts.ChartOptionTemplates.Bars([{"name":"武汉总院","group":"药品目录","value":"7290"},{"name":"武汉一院","group":"药品目录","value":"6420"},{"name":"武汉二院","group":"药品目录","value":"7200"},{"name":"武汉三院","group":"药品目录","value":"6320"},{"name":"武汉东院","group":"药品目录","value":"7280"},{"name":"武汉西院","group":"药品目录","value":"7220"}]); 
	option.title ={
		text: '', ///'审查指标趋势图',
		subtext: '', ///'饼状图',
		x:'center'
	},
	option.color=['#3398DB']
	var container = document.getElementById('ruleCharts');
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt); */
		var option = {
		color:['#2DC6CB'], //#3398DB blue
		toolbox: {
	        show: true,
	        feature: {
	            magicType: {show: true, type: ['line', 'bar']},
	            restore: {show: true},
	        }
	    },
	    title: {
	        text: '',
	        subtext: ''
	    },
	    tooltip: {
	        trigger: 'axis',
	        axisPointer: {
	            type: 'shadow'
	        }
	    },
	    legend: {
	        data: ['药品规则']
	    },
	    grid: {
	        left: '4%',
	        right: '3%',
	        bottom: '4%',
	        containLabel: false
	    },
	    xAxis: {
	        type: 'value',
	        boundaryGap: [0, 0.1]
	    },
	    yAxis: {
	        type: 'category',
	        triggerEvent:true,
	        data: ['武汉总院', '武汉一院', '武汉二院', '武汉三院', '武汉东院', '武汉西院']
	    },
	    series: [
	        {
	            name: '药品规则',
	            type: 'bar',
	            data: [7290,7280,7200,6320,6300,6000]
	        }
	    ]
	};
	
	var myChart = echarts.init(document.getElementById('ruleCharts'));
	// 使用刚指定的配置项和数据显示图表。
    myChart.setOption(option);                                                                     
                                                                          
}

function InitRuleSelfChart(echarts){
	/*var option = ECharts.ChartOptionTemplates.Bars([{"name":"武汉总院","group":"药品目录","value":"2911"},{"name":"武汉一院","group":"药品目录","value":"4222"},{"name":"武汉二院","group":"药品目录","value":"2033"},{"name":"武汉三院","group":"药品目录","value":"3244"},{"name":"武汉东院","group":"药品目录","value":"2800"},{"name":"武汉西院","group":"药品目录","value":"2200"}]); 
	option.title ={
		text: '', ///'审查指标趋势图',
		subtext: '', ///'饼状图',
		x:'center'
	},
	option.color=['#3398DB']
	var container = document.getElementById('ruleSelfCharts');
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);  */
		var option = {
		color:['#2DC6CB'],
		toolbox: {
	        show: true,
	        feature: {
	            dataView: {show: false, readOnly: false},
	            magicType: {show: true, type: ['line', 'bar']},
	            restore: {show: true},
	            saveAsImage: {show: false}
	        }
	    },
	    title: {
	        text: '',
	        subtext: ''
	    },
	    tooltip: {
	        trigger: 'axis',
	        axisPointer: {
	            type: 'shadow'
	        }
	    },
	    legend: {
	        data: ['药品规则']
	    },
	    grid: {
	        left: '4%',
	        right: '3%',
	        bottom: '4%',
	        containLabel: false
	    },
	    xAxis: {
	        type: 'value',
	        boundaryGap: [0, 0.1]
	    },
	    yAxis: {
	        type: 'category',
	        triggerEvent:true,
	        data: ['武汉总院', '武汉一院', '武汉二院', '武汉三院', '武汉东院', '武汉西院']
	    },
	    series: [
	        {
	            name: '药品规则',
	            type: 'bar',
	            data: [4222,4000,3333,3244,2800,2200]
	        }
	    ]
	};
	
	var myChart = echarts.init(document.getElementById('ruleSelfCharts'));
	// 使用刚指定的配置项和数据显示图表。
    myChart.setOption(option);                                                                     
                                                                         
}



function initQqa(){
	function showEchartBars(idName,data){
		var option = ECharts.ChartOptionTemplates.Bars(data); 
		option.title ={
			
		}
		
		var container = document.getElementById(idName);
		opt = ECharts.ChartConfig(container, option);
		ECharts.Charts.RenderChart(opt);	
	}

	function InitTableAndEchart(columns,tableData,tableEchartData,tableId,echartId,showEhcarts){

		$HUI.datagrid('#'+tableId,{
			url: '',
			data:tableData,
			fit:true,
			columns:columns,
			fitColumns:true,
			pageSize:60,  
			pageList:[30,60,90], 
			loadMsg: '正在加载信息...',
			rownumbers : false,
			pagination:true,
			singleSelect:true,
			iconCls:'icon-paper',
			headerCls:'panel-header-gray'
		})
		showEhcarts==1?showEchartBars(echartId,tableEchartData):"";
	}

	$(".SetInst").combobox({})
	$(".SetArea").combobox({})
	
	var columns = [[
		{field: 'MedInst', align: 'center',width:100,title: '医疗机构'},
		{field: 'InstArea', align: 'center',width:100,title: '区域'},
		{field: 'Category', align: 'center',width:50,title: '类别'},
		{field: 'DrugName', align: 'center',width:50,title: '药品'},
		{field: 'Number', align: 'center',width:50,title: '数量'}
	]]
	var tableData=[
		{"MedInst":"协和医院","InstArea":"江汉区","Category":"西药","DrugName":"青霉素","Number":"120"},
		{"MedInst":"湖北省荣军医院","InstArea":"洪山区","Category":"西药","DrugName":"葡萄糖","Number":"220"},
		{"MedInst":"湖北省中医院","InstArea":"武昌区","Category":"西药","DrugName":"阿莫西林","Number":"320"},
		{"MedInst":"省口腔医院","InstArea":"洪山区","Category":"西药","DrugName":"青莲地心","Number":"420"},
		{"MedInst":"武汉大学人民医院","InstArea":"武昌区","Category":"西药","DrugName":"ob","Number":"520"},
		{"MedInst":"新洲区中医骨伤科医院","InstArea":"新洲区","Category":"西药","DrugName":"ob","Number":"620"},
		{"MedInst":"武汉市皮肤病防治院","InstArea":"硚口区","Category":"西药","DrugName":"ob","Number":"720"},
		{"MedInst":"新洲区中医骨伤科医院","InstArea":"新洲区","Category":"西药","DrugName":"ob","Number":"820"}
	]

	var tableEchartData=[];
	for (var i in tableData){
		var itmObj={};
		itmObj.name=tableData[i].MedInst;
		itmObj.value=parseInt(tableData[i].Number);
		itmObj.group=tableData[i].Category;
		tableEchartData.push(itmObj);
	}

	InitTableAndEchart(columns,tableData,tableEchartData,"yiLiaoZxyTable","yiLiaoZxyEcharts",1);


	var columns = [[
		{field: 'MedInst', align: 'center',width:100,title: '医疗机构'},
		{field: 'InstArea', align: 'center',width:100,title: '区域'},
		{field: 'Number', align: 'center',width:50,title: '问题数量'}
	]]
	var tableData=[
		{"MedInst":"协和医院","InstArea":"江汉区","Category":"","Number":"120"},
		{"MedInst":"湖北省荣军医院","InstArea":"洪山区","Category":"","Number":"111"},
		{"MedInst":"湖北省中医院","InstArea":"武昌区","Category":"","Number":"222"},
		{"MedInst":"省口腔医院","InstArea":"洪山区","Category":"","Number":"555"},
		{"MedInst":"武汉大学人民医院","InstArea":"武昌区","Category":"","Number":"520"},
		{"MedInst":"新洲区中医骨伤科医院","InstArea":"新洲区","Category":"","Number":"620"},
		{"MedInst":"武汉市皮肤病防治院","InstArea":"硚口区","Category":"","Number":"720"},
		{"MedInst":"新洲区中医骨伤科医院","InstArea":"新洲区","Category":"","Number":"666"}
	]
	var tableEchartData=[];
	for (var i in tableData){
		var itmObj={};
		itmObj.name=tableData[i].MedInst;
		itmObj.value=parseInt(tableData[i].Number);
		itmObj.group=tableData[i].Category;
		tableEchartData.push(itmObj);
	}
	InitTableAndEchart(columns,tableData,tableEchartData,"proOfMedInstTable","proOfMedInstEcharts",1);

	var columns = [[
		{field: 'Category', align: 'center',width:100,title: '类别'},
		{field: 'Number', align: 'center',width:50,title: '问题数量'}
	]]
	var tableData=[
		{"MedInst":"协和医院","InstArea":"江汉区","Category":"禁忌症","Number":"120"},
		{"MedInst":"湖北省荣军医院","InstArea":"洪山区","Category":"适应症","Number":"111"},
		{"MedInst":"湖北省中医院","InstArea":"武昌区","Category":"用法","Number":"222"},
		{"MedInst":"省口腔医院","InstArea":"洪山区","Category":"用量","Number":"555"},
		{"MedInst":"武汉大学人民医院","InstArea":"武昌区","Category":"注意事项","Number":"520"},
		{"MedInst":"新洲区中医骨伤科医院","InstArea":"新洲区","Category":"不良反应","Number":"620"},
		{"MedInst":"武汉市皮肤病防治院","InstArea":"硚口区","Category":"药物反应","Number":"720"},
		{"MedInst":"新洲区中医骨伤科医院","InstArea":"新洲区","Category":"过敏反应","Number":"666"}
	]
	var tableEchartData=[];
	for (var i in tableData){
		var itmObj={};
		itmObj.name=tableData[i].Category;
		itmObj.value=parseInt(tableData[i].Number);
		itmObj.group="";
		tableEchartData.push(itmObj);
	}
	InitTableAndEchart(columns,tableData,tableEchartData,"kindsOfProTable","kindsOfProEcharts",1);

	var columns = [[
		{field: 'Category', align: 'center',width:100,title: '级别'},
		{field: 'Number', align: 'center',width:50,title: '问题数量'}
	]]
	var tableData=[
		{"MedInst":"协和医院","InstArea":"江汉区","Category":"提醒","Number":"120"},
		{"MedInst":"湖北省荣军医院","InstArea":"洪山区","Category":"警示","Number":"111"},
		{"MedInst":"湖北省中医院","InstArea":"武昌区","Category":"管控","Number":"222"}
	]
	var tableEchartData=[];
	for (var i in tableData){
		var itmObj={};
		itmObj.name=tableData[i].Category;
		itmObj.value=parseInt(tableData[i].Number);
		itmObj.group="";
		tableEchartData.push(itmObj);
	}
	InitTableAndEchart(columns,tableData,tableEchartData,"levOfProTable","levOfProEcharts",1);	
	
	
	///为了便于从官网copy代码
    require.config({
        paths: {
            echarts: '../scripts/dhcnewpro/plugins/echarts/echarts-2.2.1/build/dist'
        }
    }

    );
    require(
        [
            'echarts',
            'echarts/chart/bar',
            'echarts/chart/line'
        ],
        initQqaEchart //异步加载的回调函数绘制图表 
    ); 
}



function initQqaEchart(echarts){
	var option = {
		color:['#2DC6CB'],
	    title: {
	        text: '',
	        subtext: ''
	    },
	    tooltip: {
	        trigger: 'axis',
	        axisPointer: {
	            type: 'shadow'
	        }
	    },
	    legend: {
	        data: ['']
	    },
	    grid: {
	        left: '3%',
	        right: '4%',
	        bottom: '3%',
	        containLabel: false
	    },
	    xAxis: {
	        type: 'value',
	        boundaryGap: [0, 0.1]
	    },
	    yAxis: {
	        type: 'category',
	        triggerEvent:true,
	        data: ['江夏区', '黄陂区', '东西湖区', '新洲区', '蔡甸区', '青山区', '江岸区', '东湖风景区', '经开汉南区']
	    },
	    series: [
	        {
	            name: '',
	            type: 'bar',
	            data: [111, 222, 333, 444, 555, 666, 777, 888, 999]
	        }
	    ]
	};
	
	
	var myChart = echarts.init(document.getElementById('qyHeLiYongYaoCharts'));
	
	myChart.on('click', function (params) { 
		var lnk = "dhcckb.qypro.csp";
	
		websys_showModal({
			url: lnk,
			width: '1300px',
			height: '600px',
			iconCls:"icon-w-paper",
			title: '接单列表',
			closed: true,
			modal:true,
			onClose:function(){
				
			}
		}); 
		
		return;
	})
	// 使用刚指定的配置项和数据显示图表。
    myChart.setOption(option);
    
    
    option = {
	    title: {
	        text: '',
	        subtext: ''
	    },
	    tooltip: {
	        trigger: 'axis'
	    },
	    legend: {
	        data: ['提醒', '警示', '管控']
	    },
	    toolbox: {
	        show: true,
	        feature: {
	            dataView: {show: true, readOnly: false},
	            magicType: {show: true, type: ['line', 'bar']},
	            restore: {show: true},
	            saveAsImage: {show: true}
	        }
	    },
	    calculable: true,
	    xAxis: [
	        {
	            type: 'category',
	            data: ['蔡甸区', '武昌区', '青山区', '洪山区', '新洲区', '汉阳区', '硚口区', '江岸区', '东湖风景区', '经开汉南区'],
	            axisLabel: {
                    interval: 0,
                    formatter:function(value)
                    {
                        //debugger
                        var ret = "";//拼接加\n返回的类目项
                        var maxLength = 4;//每项显示文字个数
                        var valLength = value.length;//X轴类目项的文字个数
                        var rowN = Math.ceil(valLength / maxLength); //类目项需要换行的行数
                        if (rowN > 1)//如果类目项的文字大于3,
                        {
                            for (var i = 0; i < rowN; i++) {
                                var temp = "";//每次截取的字符串
                                var start = i * maxLength;//开始截取的位置
                                var end = start + maxLength;//结束截取的位置
                                //这里也可以加一个是否是最后一行的判断，但是不加也没有影响，那就不加吧
                                temp = value.substring(start, end) + "\n";
                                ret += temp; //凭借最终的字符串
                            }
                            return ret;
                        }
                        else {
                            return value;
                        }
                    }
                }
	        }
	        
	    ],
	    yAxis: [
	        {
	            type: 'value'
	        }
	    ],
	    series: [
	    	 {
	            name: '提醒',
	            type: 'bar',
	            data: [200, 260, 160, 174, 150, 140, 130, 120, 125, 115]
	        },
	        	
	        {
	            name: '警示',
	            type: 'bar',
	            data: [380, 400, 198, 200, 210, 190, 185, 160, 174, 150]
	        },
	        {
	            name: '管控',
	            type: 'bar',	           
	            data: [220, 280, 191, 234, 290, 330, 310, 290, 198, 200]
	        }
	    ]
	};

	var myChart = echarts.init(document.getElementById('qyAllLevEchart'));
	// 使用刚指定的配置项和数据显示图表。
    myChart.setOption(option);
    
}

function InitQnp(){
	
	require.config({
            paths: {
                echarts: '../scripts/dhcnewpro/plugins/echarts/echarts-2.2.1/build/dist'
            }
        }
 
        );
        require(
            [
                'echarts',
                'echarts/chart/bar',
                'echarts/chart/line'
            ],
            //initAreaErrDrugChart
            initAreaQueChart //异步加载的回调函数绘制图表 
        ); 
       
      require.config({
            paths: {
                echarts: '../scripts/dhcnewpro/plugins/echarts/echarts-2.2.1/build/dist'
            }
        }
 
        );
        require(
            [
                'echarts',
                'echarts/chart/bar',
                'echarts/chart/line'
            ],
            initAreaErrDrugChart
            //initAreaQueChart //异步加载的回调函数绘制图表 
        ); 
        
        require.config({
            paths: {
                echarts: '../scripts/dhcnewpro/plugins/echarts/echarts-2.2.1/build/dist'
            }
        }
 
        );
        require(
            [
                'echarts',
                'echarts/chart/bar',
                'echarts/chart/line'
            ],
            initAreaFeedBackChart
            //initAreaQueChart //异步加载的回调函数绘制图表 
        );
	//initAreaQueChart();
}


/// 区域内区分分析
function initAreaQueChart(echarts)
	{
		
		var option = {
			tooltip: {
		        trigger: 'axis'
		    },
		    //color:['#EFFFD7','#FFF8D7','#F2E6E6','#E8E8D0','#D1E9E9'],
		    legend: {
		        data: ['蔡甸区', '武昌区', '青山区', '洪山区', '新洲区']
		    },
		    grid: {
		        left: '3%',
		        right: '4%',
		        bottom: '3%',
		        width:'70%',
		        height:'60%',
		        containLabel: true
		    },
		    toolbox: {
		        feature: {
		            saveAsImage: {}
		        }
		    },
		    xAxis: {
		        type: 'category',
		        boundaryGap: false,
		        data: ['1月', '2月', '3月', '4月', '5月', '6月', '7月','8月','9月','10月','11月','12月']
		    },
		    yAxis: {
		        type: 'value'
		    },
		    series: [
		        {
		            name: '蔡甸区',
		            type: 'line',
		            stack: '总量', 
		            data: [200, 180, 160, 174, 150, 140, 130, 120, 125, 115, 100, 110]
		        },
		        {
		            name: '武昌区',
		            type: 'line',
		            stack: '总量',
		            data: [380, 190, 198, 200, 210, 190, 185, 160, 174, 150, 140, 130]
		        },
		         {
		            name: '青山区',
		            type: 'line',
		            stack: '总量',
		            data: [220, 182, 191, 234, 290, 330, 310, 290, 198, 200, 210, 190]
		        },
		         {
		            name: '洪山区',
		            type: 'line',
		            stack: '总量',
		            data: [200, 170, 191, 200, 200, 198, 180, 200, 210, 190, 185,160]
		        },
		         {
		            name: '新洲区',
		            type: 'line',
		            stack: '总量',
		            data: [190, 230, 191, 170, 160, 150, 160, 174, 150, 140, 130, 120]
		        }
		    ]
		};		
	
		var myChart = echarts.init(document.getElementById('areaAnaly'));
		// 使用刚指定的配置项和数据显示图表。
        myChart.setOption(option);
        
        

	}
	
/// 问题药品排行
function initAreaErrDrugChart(echarts){	
	
	option = {
	    title: {
	        text: '',
	        subtext: ''
	    },
	    tooltip: {
	        trigger: 'axis'
	    },
	    color:['#2DC6CB','#DA70D6','#00CD00','#F5F5F5','#D2B48C'],
	    //color:['#4A4AFF','#00E3E3','#02F78E','#F00078','#02C874'],
	    legend: {
	        data: ['蔡甸区', '武昌区', '青山区','洪山区','新洲区']
	    },
	    toolbox: {
	        show: true,
	        feature: {
	            dataView: {show: true, readOnly: false},
	            magicType: {show: true, type: ['line', 'bar']},
	            restore: {show: true},
	            saveAsImage: {show: true}
	        }
	    },
	    calculable: true,
	    xAxis: [
	        {
	            type: 'category',
	            data: ['美托洛尔缓释片', '美司钠注射液', '门冬氨酸鸟氨酸注射液', '咪喹莫特乳膏', '尼美舒利片', '哌唑嗪片', '匹伐他汀钙片', '青霉素V钾片', '头孢地尼胶囊', '替米沙坦片','舍曲林片','舒必利片'],
	            axisLabel: {
                    interval: 0,
                    formatter:function(value)
                    {
                        //debugger
                        var ret = "";//拼接加\n返回的类目项
                        var maxLength = 4;//每项显示文字个数
                        var valLength = value.length;//X轴类目项的文字个数
                        var rowN = Math.ceil(valLength / maxLength); //类目项需要换行的行数
                        if (rowN > 1)//如果类目项的文字大于3,
                        {
                            for (var i = 0; i < rowN; i++) {
                                var temp = "";//每次截取的字符串
                                var start = i * maxLength;//开始截取的位置
                                var end = start + maxLength;//结束截取的位置
                                //这里也可以加一个是否是最后一行的判断，但是不加也没有影响，那就不加吧
                                temp = value.substring(start, end) + "\n";
                                ret += temp; //凭借最终的字符串
                            }
                            return ret;
                        }
                        else {
                            return value;
                        }
                    }
                }
	        }
	        
	    ],
	    yAxis: [
	        {
	            type: 'value'
	        }
	    ],
	    series: [
	    	 {
	            name: '蔡甸区',
	            type: 'bar',
	            data: [200, 260, 160, 174, 150, 140, 130, 120, 125, 115, 100, 110]
	        },
	        	
	        {
	            name: '武昌区',
	            type: 'bar',
	            data: [380, 400, 198, 200, 210, 190, 185, 160, 174, 150, 140, 130]
	        },
	        {
	            name: '青山区',
	            type: 'bar',	           
	            data: [220, 280, 191, 234, 290, 330, 310, 290, 198, 200, 210, 190]
	        },
	         {
	            name: '洪山区',
	            type: 'bar',	          
	            data: [200, 270, 191, 200, 200, 198, 180, 200, 210, 190, 185,160]
	        },
	         {
	            name: '新洲区',
	            type: 'bar',	         
	            data: [190, 230, 191, 170, 160, 150, 160, 174, 150, 140, 130, 120]
	        }
	    ]
	};

	var myChart = echarts.init(document.getElementById('errDrugRange'));
	// 使用刚指定的配置项和数据显示图表。
    myChart.setOption(option);
}

function initAreaFeedBackChart(echarts){
	
	option = {
	    title: {
	        text: '',
	        subtext: ''
	    },
	    tooltip: {
	        trigger: 'axis'
	    },
	    legend: {
		    x:'left',      //可设定图例在左、右、居中
	        data: ['接受', '拒绝', '评论']
	    },
	    toolbox: {
	        show: true,
	        feature: {
	            dataView: {show: true, readOnly: false},
	            magicType: {show: true, type: ['line', 'bar']},
	            restore: {show: true},
	            saveAsImage: {show: true}
	        }
	    },
	    calculable: true,
	    xAxis: [
	        {
	            type: 'category',
	            data: ['蔡甸区', '武昌区', '青山区','洪山区','新洲区']
	        }
	    ],
	    yAxis: [
	        {
	            type: 'value'
	        }
	    ],	    
	    series: [
	    	 {
	            name: '接受',
	            type: 'bar',
	            data: [200, 190, 230, 150, 120]
	        },
	        	
	        {
	            name: '拒绝',
	            type: 'bar',
	            data: [230, 180, 200,120, 180]
	        },
	        {
	            name: '评论',
	            type: 'bar',	           
	            data: [280, 230, 300,190, 200]
	        }
	    ]
	};

	 var myChart = echarts.init(document.getElementById('feedBackCharts'));
	// 使用刚指定的配置项和数据显示图表。
    myChart.setOption(option);	
}

function showEchartOrder(_this){
	if($(_this).hasClass("orderSpanBtnActive")) return;
	$(".orderSpanBtn").removeClass("orderSpanBtnActive");
	$(_this).addClass("orderSpanBtnActive");
	var typeDom=document.querySelector(".spanBtnActive");
	$(typeDom).removeClass("spanBtnActive");
	showEchart(typeDom);
}


function showEchart(_this){
	if($(_this).hasClass("spanBtnActive")) return;
	
	$(".spanBtnActive").removeClass("spanBtnActive");
	$(_this).addClass("spanBtnActive");
	var btnText=$(_this).text();
	var orderValue = $(".orderSpanBtnActive").attr("value");
	
	var option = {
	    title: {
	        text: '',
	        subtext: ''
	    },
	    tooltip: {
	        trigger: 'axis',
	        axisPointer: {
	            type: 'shadow'
	        }
	    },
	    legend: {
	        data: ['']
	    },
	    grid: {
	        left: '3%',
	        right: '4%',
	        bottom: '3%',
	        containLabel: false
	    },
	    xAxis: {
	        type: 'value',
	        boundaryGap: [0, 0.1]
	    },
	    yAxis: {
	        type: 'category',
	        triggerEvent:true,
	        data: ['江夏区', '黄陂区', '东西湖区', '新洲区', '蔡甸区', '青山区', '江岸区', '东湖风景区', '经开汉南区']
	    },
	    series: [
	        {
	            name: '',
	            type: 'bar',
	            data: [111, 222, 333, 444, 555, 666, 777, 888, 999]
	        }
	    ]
	};
	
	if(btnText=="前5名"){
		option.yAxis.data=['蔡甸区', '青山区', '江岸区', '东湖风景区', '经开汉南区'].reverse();
		option.series[0].data=[999,888,777,666,555].reverse();
		
	}
	if(btnText=="后5名"){
		option.yAxis.data=['江夏区', '黄陂区', '东西湖区', '新洲区', '蔡甸区'];
		option.series[0].data=[111,222,333,444,555];
	}
	
	if(orderValue==1){
		option.yAxis.data.reverse();
		option.series[0].data.reverse();	
	}

	var myChart = echarts.init(document.getElementById('qyHeLiYongYaoCharts'));
	
	myChart.on('click', function (params) { 
		var lnk = "dhcckb.qypro.csp";
	
		websys_showModal({
			url: lnk,
			width: '1350px',
			height: '500px',
			iconCls:"icon-w-paper",
			title: '接单列表',
			closed: true,
			modal:true,
			onClose:function(){
				
			}
		}); 
		
		return;
	})
	// 使用刚指定的配置项和数据显示图表。
    myChart.setOption(option);
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
