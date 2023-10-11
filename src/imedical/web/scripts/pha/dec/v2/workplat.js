/**
 * @ģ��:     ��ҩ�ҹ���̨
 * @��д����: 2019-07-10
 * @��д��:   pushuangcai
 */
var locId = session['LOGON.CTLOCID'];
var DAYS = 0;		//����ȫ�ֱ���
var TYPEArr = ['O', 'I'];	//����
$(function () {
	InitKeyWords();
	InitPrescNumGrid();
	loadLocBar();	
});

/**
 * ��ʼ���ؼ���	#rangekw - ʱ�䷶Χ, #typekw - ����
 * @method InitKeyWords
 */
function InitKeyWords(){
	$("#rangekw").keywords({
	    singleSelect:true,
	    labelCls:'blue',
	    items:[
	        {text:'����',id:'0',selected:true},
	        {text:'3����',id:'2'},
	        {text:'7����',id:'6'},
	        {text:'30����',id:'29'}
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
	        {text:'����',id:'O',selected:true},
	        {text:'סԺ',id:'I',selected:true}
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
 * ��ʼ����ҩ�����������,�������֮�������ͼ,ѡ�������������״ͼ
 * @method InitPrescNumGrid
 */
function InitPrescNumGrid(){
	var days = DAYS||0;
	var columns = [[ 
		{field: 'sProDict',	title: '��ҩ����',	align: 'left', width: 120},
		{field: 'Num', 		title: '��������', 	align: 'left', width: 110, 
			formatter: function(value,row,index){
				return Number(row.INum) + Number(row.ONum);
			}
		},
		{field: 'INum', 	title: 'סԺ������', 	align: 'left', width: 110},
		{field: 'ONum', 	title: '���ﴦ����', 	align: 'left', width: 110}
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
 * ���ر�ͼ
 * @method loadPrePie
 * @data ͼ����Ҫ��ʾ������
 *		 ����ʹ���˱��psPrescNum������
 */
function loadPrePie(data){
	var pieData = [];
	pieData.legendData = [];
	pieData.seriesData = [];
	$.each(data.rows, function(k, row){
		var name = row.sProDict;
		if(name=="ȫ��") return true;
		pieData.seriesData.push({name: $g(name), value: Number(row.INum) + Number(row.ONum)});
		pieData.legendData.push($g(name));
	})
	InitPie(pieData)
}

/**
 * ��ʼ����ҩ���̴������ݱ�ͼ
 * @method InitPie
 * @data ͼ����Ҫ��ʾ������
 *		data.legendData label����
 *		data.seriesData ��ͼ��ʾ����
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
	        right: 40,			//������ɫʾ������λ��
	        top: 2,
	        bottom: 2,
            data: data.legendData
        },
       	series: [{
            name: '����',
            type: 'pie',
            left: 2,
            radius: '80%',				//��״ͼ��С
            center: ['50%', '50%'],
            legendHoverLink: true,
            data: data.seriesData
        }]
    };
	var pieChart = echarts.init(document.getElementById('ps-pie'));
	pieChart.setOption(pieOption);
}

/**
 * ������״ͼ proDict ��ѯ�����̣�Ĭ��Ϊ�գ�days ��ѯ���ݵ�������Ĭ��Ϊ����
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
 * ��ʼ����״ͼ
 * @method InitLocBar
 * @barData ��״ͼ������
 * 		barData.xAxis X��ı���
 *		barData.seriesData ������
 */
function InitLocBar(barData){
	var barOption = {
		color: [ '#006699' ],
		title: {
		    //text: '����/������ҩ������',
		    padding: [0, 0, 10, 100]  
		},
	    tooltip : {
	        trigger: 'axis',
	        axisPointer : {            
	            type : 'shadow'       
	        }
	    },
	    legend: {
        	data:['����','סԺ','����']
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
