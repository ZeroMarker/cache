	// ����׼���õ�dom����ʼ��echartsʵ��
  	var chart1 = echarts.init(document.getElementById('chart1'));
  	var mrDepChart = echarts.init(document.getElementById('mrDepChart'));
	var feeDepChart = echarts.init(document.getElementById('feeDepChart'));
	window.onresize = function(){
		chart1.resize();
	}
$(function(){
	init();//��ʼ��
	
	searchByCondition();
});

function loadData(){
	//����ǰ������������Ϣ
	var depScoreRankT = tkMakeServerCall("DHCMRQ.Compute.DeptData","GetDeptScoreRank",startDate,endDate,mrVersionCode,'T');
	var depScoreRankL = tkMakeServerCall("DHCMRQ.Compute.DeptData","GetDeptScoreRank",startDate,endDate,mrVersionCode,'L');
	
	//���ҵ÷���Ϣ
	var depScoreData = tkMakeServerCall("DHCMRQ.Compute.DeptData","GetDeptScoreAll",startDate,endDate,mrVersionCode);
	
	//console.log('depScoreData:'+depScoreData);
	//console.log(depScoreRankT)
	//console.log(depScoreRankL)
	try{
		loadDepScoreRankT(JSON.parse(depScoreRankT));
		loadDepScoreRankL(JSON.parse(depScoreRankL));
		loadTable(JSON.parse(depScoreData),startDate,endDate,mrVersionCode);
	}catch(err){
		loadTable([],startDate,endDate,mrVersionCode);
		console.error(err);
	}
}

function loadDepScoreRankT(data){
	$('.top1Name').html((data[0]['dDesc']+' ').replace(/(\.00)|%/g,''));
	$('.top1Value').html((data[0]['score']+' ').replace(/(\.00)|%/g,''));
	$('.top2Name').html((data[1]['dDesc']+' ').replace(/(\.00)|%/g,''));
	$('.top2Value').html((data[1]['score']+' ').replace(/(\.00)|%/g,''));
	$('.top3Name').html((data[2]['dDesc']+' ').replace(/(\.00)|%/g,''));
	$('.top3Value').html((data[2]['score']+' ').replace(/(\.00)|%/g,''));
}
function loadDepScoreRankL(data){
	$('.last1Name').html((data[0]['dDesc']+' ').replace(/(\.00)|%/g,''));
	$('.last1Value').html((data[0]['score']+' ').replace(/(\.00)|%/g,''));
	$('.last2Name').html((data[1]['dDesc']+' ').replace(/(\.00)|%/g,''));
	$('.last2Value').html((data[1]['score']+' ').replace(/(\.00)|%/g,''));
	$('.last3Name').html((data[2]['dDesc']+' ').replace(/(\.00)|%/g,''));
	$('.last3Value').html((data[2]['score']+' ').replace(/(\.00)|%/g,''));
}

function loadTable(data,startDate,endDate,mrVersionCode){
	var dutyItem = {
					'CLINIC':{dutyDep:'�����',base:false,hosp:true,med:true,fee:false},
					'CODING':{dutyDep:'������',base:true,hosp:false,med:true,fee:false},
					'HQMS':{dutyDep:'�����',base:false,hosp:false,med:true,fee:true},
					'WT4':{dutyDep:'�����',base:false,hosp:false,med:true,fee:true}
					}
	
	var mrDepTable = $('#mrDepTable').DataTable( {
      	data: data,
			destroy: true,
			lengthMenu: [ [5, 10, 25, 50, -1], [5, 10, 25, 50, "ȫ��"] ],
			language: {"url": "../scripts/dhcmrq/datatable-1.10.12/datatables.zh-CN.json"},
			columns: [
				{ "data": "dCode" ,"visible":false},
            	{ "data": "dDesc" ,
						  "render": function ( data, type, full, meta ) {
				      		return '<a title="�鿴��������" role="button" onclick="addTab(\''+full.dDesc+'��ҳ���\',\'dhcmrq.caseList.csp?depName='+escape(full.dDesc)+'&depCode='+full.dCode+'&startDate='+startDate+'&endDate='+endDate+'&mrVersionCode='+mrVersionCode+'&type=1\',\'mrList'+full.dCode+'\')">'+full.dDesc+'</a>'
				      			  //+'<a href="javascript:;" onclick="showTrend(\''+full.dDesc+'\')"><i class="fa fa-line-chart"></i></a>';
					    }
				},
            	{ "data": "score" },
				{ "data": "tScore" },
				{ "data": "pScore" }
        	],
			order: [[2, 'desc']],
			drawCallback: function( settings ) {
	        var thisPageData = this.api().rows( {page:'current'} ).data();
					var data = [];
					var category = [];
					for (var i = 0; i < thisPageData.length; i++) {
						data.push({name:thisPageData[i]['dDesc'],value:thisPageData[i]['tScore'].replace(/%/g,'')});
						category.push(thisPageData[i]['dDesc']);
					}
					$('#mrDepChart').height($('#mrDepTable').height()+120);
					barChart(mrDepChart,data.reverse(),category.reverse());
	    }
  });
  
  var feeDepTable = $('#feeDepTable').DataTable( {
      	data: data,
			destroy: true,
			lengthMenu: [ [5, 10, 25, 50, -1], [5, 10, 25, 50, "ȫ��"] ],
			language: {"url": "../scripts/dhcmrq/datatable-1.10.12/datatables.zh-CN.json"},
			columns: [
				{ "data": "dCode" ,"visible":false},
            	{ "data": "dDesc" ,
						  "render": function ( data, type, full, meta ) {
				      		return '<a title="�鿴��������" role="button" onclick="addTab(\''+full.dDesc+'��ҳ���\',\'dhcmrq.caseList.csp?depName='+escape(full.dDesc)+'&depCode='+full.dCode+'&startDate='+startDate+'&endDate='+endDate+'&mrVersionCode='+mrVersionCode+'&type=1\',\'mrList'+full.dCode+'\')">'+full.dDesc+'</a>'
				      			  //+'<a href="javascript:;" onclick="showTrend(\''+full.dDesc+'\')"><i class="fa fa-line-chart"></i></a>';
					    }
				},
            	{ "data": "score" },
            	{ "data": "pScore" }
        	],
			order: [[2, 'desc']],
			drawCallback: function( settings ) {
	        var thisPageData = this.api().rows( {page:'current'} ).data();
					var data = [];
					var category = [];
					for (var i = 0; i < thisPageData.length; i++) {
						data.push({name:thisPageData[i]['dDesc'],value:thisPageData[i]['pScore'].replace(/%/g,'')});
						category.push(thisPageData[i]['dDesc']);
					}
					$('#feeDepChart').height($('#feeDepTable').height()+120);
					barChart(feeDepChart,data.reverse(),category.reverse());
	    }
  });

	
	var dt1 = $('#table1').DataTable( {
      data: data,
			destroy: true,
			lengthMenu: [ [5, 10, 25, 50, -1], [5, 10, 25, 50, "ȫ��"] ],
			language: {"url": "../scripts/dhcmrq/datatable-1.10.12/datatables.zh-CN.json"},
			columns: [
						{ "data": "dCode" ,"visible":false},
            			{ "data": "dDesc" ,
						  "render": function ( data, type, full, meta ) {
				      		return '<a title="�鿴��������" role="button" onclick="addTab(\''+full.dDesc+'��ҳ���\',\'dhcmrq.caseList.csp?depName='+escape(full.dDesc)+'&depCode='+full.dCode+'&startDate='+startDate+'&endDate='+endDate+'&mrVersionCode='+mrVersionCode+'\',\'mrList'+full.dCode+'\')">'+full.dDesc+'</a>'
					    	}
					    },
            			{ "data": "dRecords" },
            			{ "data": "score" },
						{ "data": "pScore" ,"visible":false},
						{ "data": "tScore" ,"visible":true},
						{ "data": "pScore" ,"visible":true},
						{ "data": "tScore" ,"visible":false}
        			],
			order: [[3, 'desc']],
			drawCallback: function( settings ) {
	        var thisPageData = this.api().rows( {page:'current'} ).data();
					var data = [];
					var category = [];
					for (var i = 0; i < thisPageData.length; i++) {
						data.push({name:thisPageData[i]['dDesc'],value:thisPageData[i]['score']});
						category.push(thisPageData[i]['dDesc']);
					}
					$('#chart1').height($('#table1').height()+120);
					barChart(chart1,data.reverse(),category.reverse());
					chart1.resize();
	    }
  });

}

function barChart(chart,data,category){
	// ָ��ͼ��������������
  var barOption = {
		tooltip : {
				trigger: 'item',
				formatter: "{a} <br/>{b} : {c}"
		},
    xAxis : [
        {
            type : 'value'
        }
    ],
    yAxis : [
        {
            type : 'category',
            data : category
        }
    ],
    series : [
			{
				name:'�����ۺϵ÷�',
				type:'bar',
				data:data
			}
		]
  };

	// ʹ�ø�ָ�����������������ʾͼ��
  chart.setOption(barOption);
  chart.resize();
}