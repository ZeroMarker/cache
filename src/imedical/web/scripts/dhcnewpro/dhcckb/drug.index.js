function initPageDefault()
{
	InitHxy(); 
	
	initQqa();
	
	InitQnp();
}

function InitHxy(){
	/// ����ͳ��
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
        InitAreaChart //�첽���صĻص���������ͼ�� 
    );
    
    /// ҩƷĿ¼
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
        InitMenuChart //�첽���صĻص���������ͼ�� 
    ); 
    
    /// ҩƷĿ¼-��
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
        InitMenuSelfChart //�첽���صĻص���������ͼ�� 
    ); 
    
    /// ҩƷ����
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
        InitRuleChart //�첽���صĻص���������ͼ�� 
    );
    
    /// ҩƷ����-��
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
        InitRuleSelfChart //�첽���صĻص���������ͼ�� 
    );

    
	/*InitAreaChart(); /// ����ͳ��
	InitMenuChart(); /// ҩƷĿ¼
	InitMenuSelfChart(); /// ҩƷĿ¼-��
	InitRuleChart(); /// ҩƷ����
	InitRuleSelfChart(); /// ҩƷ����-��*/
}

/// ����ͳ��
function InitAreaChart(echarts){
	/*var option = ECharts.ChartOptionTemplates.Bars([{"name":"������","group":"��������","value":"1080"},{"name":"��ɽ��","group":"��������","value":"781"},{"name":"������","group":"��������","value":"800"},{"name":"�����","group":"��������","value":"800"},{"name":"�~����","group":"��������","value":"1000"},{"name":"��������","group":"��������","value":"651"}]); 
	option.title ={
		text: '', ///'���ָ������ͼ',
		subtext: '', ///'��״ͼ',
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
	        data: ['��������']
	    },
	    calculable: true,
	    xAxis: {
	        type: 'value',
	    },
	    yAxis: {
	        type: 'category',
	        data: ['������', '��ɽ��', '������', '�����', '�~����', '��������']
	    },
	    series: [
	        {
	            name: '��������',
	            type: 'bar',
	            data: [1080, 1000, 800, 800, 781, 651]
	        }
	    ]
	};
	
	var myChart = echarts.init(document.getElementById('areaCharts'));
	// ʹ�ø�ָ�����������������ʾͼ��
    myChart.setOption(option);
                                                                        
}

/// ҩƷĿ¼
function InitMenuChart(echarts){
	/*var option = ECharts.ChartOptionTemplates.Bars([{"name":"�人��Ժ","group":"ҩƷĿ¼","value":"9500"},{"name":"�人һԺ","group":"ҩƷĿ¼","value":"9200"},{"name":"�人��Ժ","group":"ҩƷĿ¼","value":"9300"},{"name":"�人��Ժ","group":"ҩƷĿ¼","value":"9400"},{"name":"�人��Ժ","group":"ҩƷĿ¼","value":"9500"},{"name":"�人��Ժ","group":"ҩƷĿ¼","value":"8900"}]); 
	option.title ={
		text: '', ///'���ָ������ͼ',
		subtext: '', ///'��״ͼ',
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
	        data: ['ҩƷĿ¼']
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
	        data: ['�人��Ժ', '�人һԺ', '�人��Ժ', '�人��Ժ', '�人��Ժ', '�人��Ժ']
	    },
	    series: [
	        {
	            name: 'ҩƷĿ¼',
	            type: 'bar',
	            data: [9500, 9500, 9400, 9300, 9200, 8900]
	        }
	    ]
	};
	
	var myChart = echarts.init(document.getElementById('menuCharts'));
	// ʹ�ø�ָ�����������������ʾͼ��
    myChart.setOption(option);                                                                          
}

function InitMenuSelfChart(echarts){
	/*var option = ECharts.ChartOptionTemplates.Bars([{"name":"�人��Ժ","group":"ҩƷĿ¼","value":"2900"},{"name":"�人һԺ","group":"ҩƷĿ¼","value":"4200"},{"name":"�人��Ժ","group":"ҩƷĿ¼","value":"2000"},{"name":"�人��Ժ","group":"ҩƷĿ¼","value":"3200"},{"name":"�人��Ժ","group":"ҩƷĿ¼","value":"2800"},{"name":"�人��Ժ","group":"ҩƷĿ¼","value":"2200"}]); 
	option.title ={
		text: '', ///'���ָ������ͼ',
		subtext: '', ///'��״ͼ',
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
	        data: ['ҩƷĿ¼']
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
	        data: ['�人��Ժ', '�人һԺ', '�人��Ժ', '�人��Ժ', '�人��Ժ', '�人��Ժ']
	    },
	    series: [
	        {
	            name: 'ҩƷĿ¼',
	            type: 'bar',
	            data: [4200,3200,2800,2700,2200,2000]
	        }
	    ]
	};
	
	var myChart = echarts.init(document.getElementById('menuSelfCharts'));
	// ʹ�ø�ָ�����������������ʾͼ��
    myChart.setOption(option);                                                                     
}

function InitRuleChart(echarts){
	/*var option = ECharts.ChartOptionTemplates.Bars([{"name":"�人��Ժ","group":"ҩƷĿ¼","value":"7290"},{"name":"�人һԺ","group":"ҩƷĿ¼","value":"6420"},{"name":"�人��Ժ","group":"ҩƷĿ¼","value":"7200"},{"name":"�人��Ժ","group":"ҩƷĿ¼","value":"6320"},{"name":"�人��Ժ","group":"ҩƷĿ¼","value":"7280"},{"name":"�人��Ժ","group":"ҩƷĿ¼","value":"7220"}]); 
	option.title ={
		text: '', ///'���ָ������ͼ',
		subtext: '', ///'��״ͼ',
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
	        data: ['ҩƷ����']
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
	        data: ['�人��Ժ', '�人һԺ', '�人��Ժ', '�人��Ժ', '�人��Ժ', '�人��Ժ']
	    },
	    series: [
	        {
	            name: 'ҩƷ����',
	            type: 'bar',
	            data: [7290,7280,7200,6320,6300,6000]
	        }
	    ]
	};
	
	var myChart = echarts.init(document.getElementById('ruleCharts'));
	// ʹ�ø�ָ�����������������ʾͼ��
    myChart.setOption(option);                                                                     
                                                                          
}

function InitRuleSelfChart(echarts){
	/*var option = ECharts.ChartOptionTemplates.Bars([{"name":"�人��Ժ","group":"ҩƷĿ¼","value":"2911"},{"name":"�人һԺ","group":"ҩƷĿ¼","value":"4222"},{"name":"�人��Ժ","group":"ҩƷĿ¼","value":"2033"},{"name":"�人��Ժ","group":"ҩƷĿ¼","value":"3244"},{"name":"�人��Ժ","group":"ҩƷĿ¼","value":"2800"},{"name":"�人��Ժ","group":"ҩƷĿ¼","value":"2200"}]); 
	option.title ={
		text: '', ///'���ָ������ͼ',
		subtext: '', ///'��״ͼ',
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
	        data: ['ҩƷ����']
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
	        data: ['�人��Ժ', '�人һԺ', '�人��Ժ', '�人��Ժ', '�人��Ժ', '�人��Ժ']
	    },
	    series: [
	        {
	            name: 'ҩƷ����',
	            type: 'bar',
	            data: [4222,4000,3333,3244,2800,2200]
	        }
	    ]
	};
	
	var myChart = echarts.init(document.getElementById('ruleSelfCharts'));
	// ʹ�ø�ָ�����������������ʾͼ��
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
			loadMsg: '���ڼ�����Ϣ...',
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
		{field: 'MedInst', align: 'center',width:100,title: 'ҽ�ƻ���'},
		{field: 'InstArea', align: 'center',width:100,title: '����'},
		{field: 'Category', align: 'center',width:50,title: '���'},
		{field: 'DrugName', align: 'center',width:50,title: 'ҩƷ'},
		{field: 'Number', align: 'center',width:50,title: '����'}
	]]
	var tableData=[
		{"MedInst":"Э��ҽԺ","InstArea":"������","Category":"��ҩ","DrugName":"��ù��","Number":"120"},
		{"MedInst":"����ʡ�پ�ҽԺ","InstArea":"��ɽ��","Category":"��ҩ","DrugName":"������","Number":"220"},
		{"MedInst":"����ʡ��ҽԺ","InstArea":"�����","Category":"��ҩ","DrugName":"��Ī����","Number":"320"},
		{"MedInst":"ʡ��ǻҽԺ","InstArea":"��ɽ��","Category":"��ҩ","DrugName":"��������","Number":"420"},
		{"MedInst":"�人��ѧ����ҽԺ","InstArea":"�����","Category":"��ҩ","DrugName":"ob","Number":"520"},
		{"MedInst":"��������ҽ���˿�ҽԺ","InstArea":"������","Category":"��ҩ","DrugName":"ob","Number":"620"},
		{"MedInst":"�人��Ƥ��������Ժ","InstArea":"�~����","Category":"��ҩ","DrugName":"ob","Number":"720"},
		{"MedInst":"��������ҽ���˿�ҽԺ","InstArea":"������","Category":"��ҩ","DrugName":"ob","Number":"820"}
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
		{field: 'MedInst', align: 'center',width:100,title: 'ҽ�ƻ���'},
		{field: 'InstArea', align: 'center',width:100,title: '����'},
		{field: 'Number', align: 'center',width:50,title: '��������'}
	]]
	var tableData=[
		{"MedInst":"Э��ҽԺ","InstArea":"������","Category":"","Number":"120"},
		{"MedInst":"����ʡ�پ�ҽԺ","InstArea":"��ɽ��","Category":"","Number":"111"},
		{"MedInst":"����ʡ��ҽԺ","InstArea":"�����","Category":"","Number":"222"},
		{"MedInst":"ʡ��ǻҽԺ","InstArea":"��ɽ��","Category":"","Number":"555"},
		{"MedInst":"�人��ѧ����ҽԺ","InstArea":"�����","Category":"","Number":"520"},
		{"MedInst":"��������ҽ���˿�ҽԺ","InstArea":"������","Category":"","Number":"620"},
		{"MedInst":"�人��Ƥ��������Ժ","InstArea":"�~����","Category":"","Number":"720"},
		{"MedInst":"��������ҽ���˿�ҽԺ","InstArea":"������","Category":"","Number":"666"}
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
		{field: 'Category', align: 'center',width:100,title: '���'},
		{field: 'Number', align: 'center',width:50,title: '��������'}
	]]
	var tableData=[
		{"MedInst":"Э��ҽԺ","InstArea":"������","Category":"����֢","Number":"120"},
		{"MedInst":"����ʡ�پ�ҽԺ","InstArea":"��ɽ��","Category":"��Ӧ֢","Number":"111"},
		{"MedInst":"����ʡ��ҽԺ","InstArea":"�����","Category":"�÷�","Number":"222"},
		{"MedInst":"ʡ��ǻҽԺ","InstArea":"��ɽ��","Category":"����","Number":"555"},
		{"MedInst":"�人��ѧ����ҽԺ","InstArea":"�����","Category":"ע������","Number":"520"},
		{"MedInst":"��������ҽ���˿�ҽԺ","InstArea":"������","Category":"������Ӧ","Number":"620"},
		{"MedInst":"�人��Ƥ��������Ժ","InstArea":"�~����","Category":"ҩ�ﷴӦ","Number":"720"},
		{"MedInst":"��������ҽ���˿�ҽԺ","InstArea":"������","Category":"������Ӧ","Number":"666"}
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
		{field: 'Category', align: 'center',width:100,title: '����'},
		{field: 'Number', align: 'center',width:50,title: '��������'}
	]]
	var tableData=[
		{"MedInst":"Э��ҽԺ","InstArea":"������","Category":"����","Number":"120"},
		{"MedInst":"����ʡ�پ�ҽԺ","InstArea":"��ɽ��","Category":"��ʾ","Number":"111"},
		{"MedInst":"����ʡ��ҽԺ","InstArea":"�����","Category":"�ܿ�","Number":"222"}
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
	
	
	///Ϊ�˱��ڴӹ���copy����
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
        initQqaEchart //�첽���صĻص���������ͼ�� 
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
	        data: ['������', '������', '��������', '������', '�̵���', '��ɽ��', '������', '�����羰��', '����������']
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
			title: '�ӵ��б�',
			closed: true,
			modal:true,
			onClose:function(){
				
			}
		}); 
		
		return;
	})
	// ʹ�ø�ָ�����������������ʾͼ��
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
	        data: ['����', '��ʾ', '�ܿ�']
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
	            data: ['�̵���', '�����', '��ɽ��', '��ɽ��', '������', '������', '�~����', '������', '�����羰��', '����������'],
	            axisLabel: {
                    interval: 0,
                    formatter:function(value)
                    {
                        //debugger
                        var ret = "";//ƴ�Ӽ�\n���ص���Ŀ��
                        var maxLength = 4;//ÿ����ʾ���ָ���
                        var valLength = value.length;//X����Ŀ������ָ���
                        var rowN = Math.ceil(valLength / maxLength); //��Ŀ����Ҫ���е�����
                        if (rowN > 1)//�����Ŀ������ִ���3,
                        {
                            for (var i = 0; i < rowN; i++) {
                                var temp = "";//ÿ�ν�ȡ���ַ���
                                var start = i * maxLength;//��ʼ��ȡ��λ��
                                var end = start + maxLength;//������ȡ��λ��
                                //����Ҳ���Լ�һ���Ƿ������һ�е��жϣ����ǲ���Ҳû��Ӱ�죬�ǾͲ��Ӱ�
                                temp = value.substring(start, end) + "\n";
                                ret += temp; //ƾ�����յ��ַ���
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
	            name: '����',
	            type: 'bar',
	            data: [200, 260, 160, 174, 150, 140, 130, 120, 125, 115]
	        },
	        	
	        {
	            name: '��ʾ',
	            type: 'bar',
	            data: [380, 400, 198, 200, 210, 190, 185, 160, 174, 150]
	        },
	        {
	            name: '�ܿ�',
	            type: 'bar',	           
	            data: [220, 280, 191, 234, 290, 330, 310, 290, 198, 200]
	        }
	    ]
	};

	var myChart = echarts.init(document.getElementById('qyAllLevEchart'));
	// ʹ�ø�ָ�����������������ʾͼ��
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
            initAreaQueChart //�첽���صĻص���������ͼ�� 
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
            //initAreaQueChart //�첽���صĻص���������ͼ�� 
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
            //initAreaQueChart //�첽���صĻص���������ͼ�� 
        );
	//initAreaQueChart();
}


/// ���������ַ���
function initAreaQueChart(echarts)
	{
		
		var option = {
			tooltip: {
		        trigger: 'axis'
		    },
		    //color:['#EFFFD7','#FFF8D7','#F2E6E6','#E8E8D0','#D1E9E9'],
		    legend: {
		        data: ['�̵���', '�����', '��ɽ��', '��ɽ��', '������']
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
		        data: ['1��', '2��', '3��', '4��', '5��', '6��', '7��','8��','9��','10��','11��','12��']
		    },
		    yAxis: {
		        type: 'value'
		    },
		    series: [
		        {
		            name: '�̵���',
		            type: 'line',
		            stack: '����', 
		            data: [200, 180, 160, 174, 150, 140, 130, 120, 125, 115, 100, 110]
		        },
		        {
		            name: '�����',
		            type: 'line',
		            stack: '����',
		            data: [380, 190, 198, 200, 210, 190, 185, 160, 174, 150, 140, 130]
		        },
		         {
		            name: '��ɽ��',
		            type: 'line',
		            stack: '����',
		            data: [220, 182, 191, 234, 290, 330, 310, 290, 198, 200, 210, 190]
		        },
		         {
		            name: '��ɽ��',
		            type: 'line',
		            stack: '����',
		            data: [200, 170, 191, 200, 200, 198, 180, 200, 210, 190, 185,160]
		        },
		         {
		            name: '������',
		            type: 'line',
		            stack: '����',
		            data: [190, 230, 191, 170, 160, 150, 160, 174, 150, 140, 130, 120]
		        }
		    ]
		};		
	
		var myChart = echarts.init(document.getElementById('areaAnaly'));
		// ʹ�ø�ָ�����������������ʾͼ��
        myChart.setOption(option);
        
        

	}
	
/// ����ҩƷ����
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
	        data: ['�̵���', '�����', '��ɽ��','��ɽ��','������']
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
	            data: ['�����������Ƭ', '��˾��ע��Һ', '�Ŷ���������ע��Һ', '���Ī�����', '��������Ƭ', '�����Ƭ', 'ƥ����͡��Ƭ', '��ù��V��Ƭ', 'ͷ�ߵ��ὺ��', '����ɳ̹Ƭ','������Ƭ','�����Ƭ'],
	            axisLabel: {
                    interval: 0,
                    formatter:function(value)
                    {
                        //debugger
                        var ret = "";//ƴ�Ӽ�\n���ص���Ŀ��
                        var maxLength = 4;//ÿ����ʾ���ָ���
                        var valLength = value.length;//X����Ŀ������ָ���
                        var rowN = Math.ceil(valLength / maxLength); //��Ŀ����Ҫ���е�����
                        if (rowN > 1)//�����Ŀ������ִ���3,
                        {
                            for (var i = 0; i < rowN; i++) {
                                var temp = "";//ÿ�ν�ȡ���ַ���
                                var start = i * maxLength;//��ʼ��ȡ��λ��
                                var end = start + maxLength;//������ȡ��λ��
                                //����Ҳ���Լ�һ���Ƿ������һ�е��жϣ����ǲ���Ҳû��Ӱ�죬�ǾͲ��Ӱ�
                                temp = value.substring(start, end) + "\n";
                                ret += temp; //ƾ�����յ��ַ���
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
	            name: '�̵���',
	            type: 'bar',
	            data: [200, 260, 160, 174, 150, 140, 130, 120, 125, 115, 100, 110]
	        },
	        	
	        {
	            name: '�����',
	            type: 'bar',
	            data: [380, 400, 198, 200, 210, 190, 185, 160, 174, 150, 140, 130]
	        },
	        {
	            name: '��ɽ��',
	            type: 'bar',	           
	            data: [220, 280, 191, 234, 290, 330, 310, 290, 198, 200, 210, 190]
	        },
	         {
	            name: '��ɽ��',
	            type: 'bar',	          
	            data: [200, 270, 191, 200, 200, 198, 180, 200, 210, 190, 185,160]
	        },
	         {
	            name: '������',
	            type: 'bar',	         
	            data: [190, 230, 191, 170, 160, 150, 160, 174, 150, 140, 130, 120]
	        }
	    ]
	};

	var myChart = echarts.init(document.getElementById('errDrugRange'));
	// ʹ�ø�ָ�����������������ʾͼ��
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
		    x:'left',      //���趨ͼ�������ҡ�����
	        data: ['����', '�ܾ�', '����']
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
	            data: ['�̵���', '�����', '��ɽ��','��ɽ��','������']
	        }
	    ],
	    yAxis: [
	        {
	            type: 'value'
	        }
	    ],	    
	    series: [
	    	 {
	            name: '����',
	            type: 'bar',
	            data: [200, 190, 230, 150, 120]
	        },
	        	
	        {
	            name: '�ܾ�',
	            type: 'bar',
	            data: [230, 180, 200,120, 180]
	        },
	        {
	            name: '����',
	            type: 'bar',	           
	            data: [280, 230, 300,190, 200]
	        }
	    ]
	};

	 var myChart = echarts.init(document.getElementById('feedBackCharts'));
	// ʹ�ø�ָ�����������������ʾͼ��
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
	        data: ['������', '������', '��������', '������', '�̵���', '��ɽ��', '������', '�����羰��', '����������']
	    },
	    series: [
	        {
	            name: '',
	            type: 'bar',
	            data: [111, 222, 333, 444, 555, 666, 777, 888, 999]
	        }
	    ]
	};
	
	if(btnText=="ǰ5��"){
		option.yAxis.data=['�̵���', '��ɽ��', '������', '�����羰��', '����������'].reverse();
		option.series[0].data=[999,888,777,666,555].reverse();
		
	}
	if(btnText=="��5��"){
		option.yAxis.data=['������', '������', '��������', '������', '�̵���'];
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
			title: '�ӵ��б�',
			closed: true,
			modal:true,
			onClose:function(){
				
			}
		}); 
		
		return;
	})
	// ʹ�ø�ָ�����������������ʾͼ��
    myChart.setOption(option);
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
