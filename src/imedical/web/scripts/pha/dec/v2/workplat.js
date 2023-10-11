/**
 * @模块:     煎药室工作台
 * @编写日期: 2019-07-10
 * @编写人:   pushuangcai
 */
var locId = session['LOGON.CTLOCID'];
var DAYS = 0;		//设置全局变量
var TYPEArr = ['O', 'I'];	//类型
$(function () {
	InitKeyWords();
	InitPrescNumGrid();
	loadLocBar();	
});

/**
 * 初始化关键字	#rangekw - 时间范围, #typekw - 类型
 * @method InitKeyWords
 */
function InitKeyWords(){
	$("#rangekw").keywords({
	    singleSelect:true,
	    labelCls:'blue',
	    items:[
	        {text:'今日',id:'0',selected:true},
	        {text:'3日内',id:'2'},
	        {text:'7日内',id:'6'},
	        {text:'30日内',id:'29'}
	    ],
	    onClick: function(val){
		    DAYS = val.id; 
		    InitPrescNumGrid();
		    loadLocBar();
		}
	});
	$("#typekw").keywords({
	    singleSelect:false,
	    labelCls:'blue',
	    items:[
	        {text:'门诊',id:'O',selected:true},
	        {text:'住院',id:'I',selected:true}
	    ],
	    onUnselect: function(v){
		    var tmpType = v.id;
		   	for(var i = 0; i < TYPEArr.length; i++){
				if(TYPEArr[i]==tmpType){
					TYPEArr.splice(i,1);	
				}
			}
		    loadLocBar();
	    },
	    onSelect: function(v){
		    TYPEArr.push(v.id);
			loadLocBar();
		}
	});
	
}

/**
 * 初始化煎药流程数量表格,加载完成之后载入饼图,选择行载入科室柱状图
 * @method InitPrescNumGrid
 */
function InitPrescNumGrid(){
	var days = DAYS||0;
	var columns = [[ 
		{field: 'sProDict',	title: '煎药流程',	align: 'left', width: 120},
		{field: 'Num', 		title: '处方总数', 	align: 'left', width: 110, 
			formatter: function(value,row,index){
				return Number(row.INum) + Number(row.ONum);
			}
		},
		{field: 'INum', 	title: '住院处方数', 	align: 'left', width: 110},
		{field: 'ONum', 	title: '门诊处方数', 	align: 'left', width: 110}
	]];
	var dataGridOption = {
		columns: columns,
		url: $URL,
		pagination: false,
		shrinkToFit: true,
		toolbar: null ,
		queryParams: {
			ClassName: "PHA.DEC.WorkPlat.Query",
			MethodName: "GetParaState",
			params: locId +"^"+ days
		},
		onSelect: function(rowIndex, rowData){
			loadLocBar();
		},
		onLoadSuccess: function(data){
			loadPrePie(data);
		},
        onRowContextMenu: function(){
			return false;	
		}
	};
	PHA.Grid("psPrescNum", dataGridOption);
}

/**
 * 加载饼图
 * @method loadPrePie
 * @data 图表需要显示的数据
 *		 这里使用了表格psPrescNum的数据
 */
function loadPrePie(data){
	var pieData = [];
	pieData.legendData = [];
	pieData.seriesData = [];
	$.each(data.rows, function(k, row){
		var name = row.sProDict;
		if(name=="全部") return true;
		pieData.seriesData.push({name: $g(name), value: Number(row.INum) + Number(row.ONum)});
		pieData.legendData.push($g(name));
	})
	InitPie(pieData)
}

/**
 * 初始化煎药流程处方数据饼图
 * @method InitPie
 * @data 图表需要显示的数据
 *		data.legendData label数据
 *		data.seriesData 饼图显示数据
 */
function InitPie(data){
	var pieOption = {
        title: {
            x:'center'
        },
        tooltip : {
        	trigger: 'item',
        	formatter: "{a} <br/>{b} : {c} ({d}%)"
    	},
        legend: {
	        type: 'scroll',
	        orient: 'vertical',
	        right: 40,			//控制颜色示例左右位置
	        top: 2,
	        bottom: 2,
            data: data.legendData
        },
       	series: [{
            name: '流程',
            type: 'pie',
            left: 2,
            radius: '80%',				//饼状图大小
            center: ['50%', '50%'],
            legendHoverLink: true,
            data: data.seriesData
        }]
    };
	var pieChart = echarts.init(document.getElementById('ps-pie'));
	pieChart.setOption(pieOption);
}

/**
 * 加载柱状图 proDict 查询的流程，默认为空，days 查询数据的天数，默认为当天
 * @method loadLocBar
 */
function loadLocBar(){
	var proDict = "";
	if($("#psPrescNum").datagrid('getSelected')){
		proDict = $("#psPrescNum").datagrid('getSelected').sProDict || "";
	}
	var days = DAYS||0;
	var barData = [];
	barData.legendData = [];
	barData.xAxis = [];
	barData.seriesData = [];
	if(TYPEArr.length>0){
		TYPE = TYPEArr.join(",");
	}else{
		InitLocBar([]);
		return;
	}
	var params = locId +"^"+ TYPE +"^"+ proDict +"^"+ days;
	$cm({
		ClassName: "PHA.DEC.WorkPlat.Query",
		MethodName: "GetLocPrescRank",
		params: params
	},function(jsonData) {
		if (typeof(jsonData) == "String") {
			jsonData = JSON.parse(jsonData);
		}
		for(var i in jsonData){
			$.each(jsonData[i], function(key, val){
				barData.xAxis.push(key);
				barData.legendData.push(key)
				barData.seriesData.push(val);
			})
		} 
		InitLocBar(barData);
	})
}

/**
 * 初始化柱状图
 * @method InitLocBar
 * @barData 柱状图的数据
 * 		barData.xAxis X轴的标题
 *		barData.seriesData 列数据
 */
function InitLocBar(barData){
	var barOption = {
		color: [ '#006699' ],
		title: {
		    //text: '科室/病区煎药处方数',
		    padding: [0, 0, 10, 100]  
		},
	    tooltip : {
	        trigger: 'axis',
	        axisPointer : {            
	            type : 'shadow'       
	        }
	    },
	    legend: {
        	data:['门诊','住院','急诊']
    	},
	    grid: {
			top : '3%',
	        left: '3%',
	        right: '4%',
	        bottom: '3%',
	        containLabel: true
	    },
	    xAxis : [
	        {
	            type : 'category',
	            data : barData.xAxis,
	         }
	    ],
	    yAxis : [
	        {type : 'value'}
	    ],
	    series: [{
    		data: barData.seriesData,
    		type: 'bar'
		}]
	};
	var barChart = echarts.init(document.getElementById('loc-bar'));
	barChart.setOption(barOption);	
}
