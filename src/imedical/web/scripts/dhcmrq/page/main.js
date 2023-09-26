	// ����׼���õ�dom����ʼ��echartsʵ��
	var missItemChart = echarts.init(document.getElementById('missItemChart'));
	//����ͼ
	var trendChart = echarts.init(document.getElementById('trendChart'));
	var goodChart = echarts.init(document.getElementById('goodChart'));
	window.onresize = function(){
		missItemChart.resize();
		trendChart.resize();
		goodChart.resize();
	}

$(function(){
	
	init();//��ʼ��
	
	$('#depScoreLink').click(function(){
	  	var param = 'startDate='+$("#startDate").val()
	  			   +'&endDate='+$("#endDate").val()
	  			   +'&mrVersionCode='+$('#mrVersionSelect').val();
		addTab('���ҵ÷����','dhcmrq.score.csp?'+param,'scorePage');  	
	})
	
	searchByCondition();
});

function loadData(){
	//��ȡȫԺ�������
	$.post('dhcmrq.service.csp',
			{ClassName:'DHCMRQ.Compute.Hospital',
			 MethodName:'GetHospInfo',
			 Params:startDate+','+endDate+','+mrVersionCode
			},
			function(data){
				//console.log(data)
				
				try{
					JSON.parse(data)[0];
				}catch(err){
					data = '[{}]';
				}
				
				loadHospData(JSON.parse(data)[0]);
				
				loadTable(JSON.parse(data)[0],startDate,endDate,mrVersionCode);
				
				loadMissDetail('������Ϣ');
	});
	
	//��ȡ���۵ȼ����
	$.post('dhcmrq.service.csp',
			{ClassName:'DHCMRQ.Compute.Hospital',
			 MethodName:'GetGradeInfo',
			 Params:startDate+','+endDate+','+mrVersionCode
			},
			function(data){
				//console.log(data)
				var data1;
				try{
					data = JSON.parse(data)[0];
					data1 = [{name:'��',value:data['fpGradeA']},{name:'��',value:data['fpGradeB']},{name:'��',value:data['fpGradeC']},{name:'��',value:data['fpGradeD']}];
					if(data['fpGradeA']==0 && data['fpGradeB']==0 && data['fpGradeC']==0 && data['fpGradeD']==0){
						data1=[];
					}
				}catch(err){
					data = {"fpGradeA":0,"fpGradeB":0,"fpGradeC":0,"fpGradeD":0};
					data1 = [];
				}
				
				
				var option = {
                    title : {
                        subtext:'���������ֲ�',
                        subtextStyle:{color:'#000'},
                        top:-30
                    },
                    tooltip : {
                        trigger: 'item',
                        formatter: "{a} <br/>{b} : {c} ({d}%)"
                    },
                    legend: {
                        orient: 'vertical',
                        left: 'right',
                        data: ['��','��','��','��']
                    },
                    series : [
                        {
                            name: '��������',
                            type: 'pie',
                            radius : '80%',
                            center: ['50%', '55%'],
                            data:data1,
                            itemStyle: {
                                emphasis: {
                                    shadowBlur: 10,
                                    shadowOffsetX: 0,
                                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                                }
                            }
                        }
                    ]
                };
				goodChart.setOption(option);
				goodChart.resize();
	});
	
	/*
	//ȫԺ��Ϣ
	var hospInfo=tkMakeServerCall("DHCMRQ.Compute.Hospital","GetHospInfo",startDate,endDate,mrVersionCode);
	//console.log(JSON.parse(hospInfo)[0])
	loadHospData(JSON.parse(hospInfo)[0]);
	
	loadTable(JSON.parse(hospInfo)[0]['tableInfo'],startDate,endDate,mrVersionCode)
	
	//�����б�Ĭ���ȼ��ػ�����Ϣ
	loadMissDetail('������Ϣ');
	*/
}

//����ȫԺ�������
function loadHospData(data){
	//console.log(data)
	var popContent = '<table>';
	var errorADtl = data['errADtl'];
if(errorADtl){
		
	for(var i=0;i<errorADtl.length;i++){
		popContent += '<tr><td>'+errorADtl[i]['name']+'</td><td>:&nbsp;'+errorADtl[i]['triggerCnt']+'</td></tr>';
		
	}
	popContent += '</table>';
	$('#errorADetail').attr('data-content',popContent).popover({
								trigger:'hover',
								placement:'left',
								html:true,
								title:'�۷�����Ϣ'
								});
	
	$('.fpCnt').html('�ܲ�������'+data['fpCnt']);
	showNum(Number((data['fpCplRatio']+' ').replace(/%/g,'')).toFixed(2).replace(/(\.00)/g,''),$('.fpCplRatio'));
	$('.fpCplRR').html((data['fpCplRR']+' ').replace(/(%|\.00)/g,''));
	showNum(Number((data['fpRqItmCplRatio']+' ').replace(/%/g,'')).toFixed(2).replace(/(\.00)/g,''),$('.fpRqItmCplRatio'));
	$('.fpRqItmCplRR').html((data['fpRqItmCplRR']+' ').replace(/(%|\.00)/g,''));
	showNum(Number((data['mRqItmAvg']+' ').replace(/%/g,'')).toFixed(2).replace(/(\.00)/g,''),$('.mRqItmAvg'));
	showNum(Number((data['hospAvgScore']+' ').replace(/%/g,'')).toFixed(2).replace(/(\.00)/g,''),$('.hospAvgScore'));
	showNum(Number((data['fpErrACnt']+' ').replace(/%/g,'')).toFixed(2).replace(/(\.00)/g,''),$('.fpErrACnt'));
	showNum((data['errorARatio']+' ').replace(/(\.00)|%/g,''),$('.errorARatio'));
}
}

//���������б�
function loadMissDetail(className){
	var classCode = '';//��Ŀ������
	switch(className){
		case '�ϼ�':
			classCode = '';
			break;
		case '������Ϣ':
			classCode = 'DEFIR-I';
			break;
		case 'סԺ����':
			classCode = 'DEFIR-P';
			break;
		case '������Ϣ':
			classCode = 'DEFIR-D';
			break;
		case '������Ϣ':
			classCode = 'DEFIR-B';
			break;
		
	}
	$('.className').html(className);
	$.post('dhcmrq.service.csp',
			{ClassName:'DHCMRQ.Compute.Hospital',
			 MethodName:'GetMissRqItem',
			 Params:startDate+','+endDate+','+mrVersionCode+','+classCode
			},
			function(data){
				try{
					//console.log(data)
					missItemInfo = JSON.parse(data)
				}catch(err){
					missItemInfo = [];
					console.log(err);
				}
				
				var missItemTable = $('#missItemTable').DataTable( {
      				data: missItemInfo,
					columns: [
            			{ "data": "desc" },
            			{ "data": "weight" },
            			{ "data": "count" },
						{ "data": "oper" ,
						  "render": function ( data, type, full, meta ) {
							  //'<a title="�鿴��������" role="button" onclick="addTab(\''+full.desc+'ȱʧ�����б�\',\'dhcmrq.caseList.csp?itemId='+full.ItemID+'&startDate='+startDate+'&endDate='+endDate+'&mrVersionCode='+mrVersionCode+'\',\'mrList'+full.ItemID+'\')">'+full.count+'</a>';
				      		return '<a title="�鿴���ҷֲ�" role="button" onclick="addTab(\''+full.desc+'ȱʧ�������ҷֲ�\',\'dhcmrq.itemmissdep.csp?itemId='+full.ItemID+'&startDate='+startDate+'&endDate='+endDate+'&mrVersionCode='+mrVersionCode+'&itemDesc='+escape(full.desc)+'\',\'depList'+full.ItemID+'\')"><i class="fa fa-hospital-o fa-lg"></i></a>';
					    }
					}
        		],
				order: [[2, 'desc']],
				drawCallback: function( settings ) {
	        		var thisPageData = this.api().rows( {page:'current'} ).data();
					var data = [];
					var category = [];
					for (var i = 0; i < thisPageData.length; i++) {
						data.push({name:thisPageData[i]['desc'],value:thisPageData[i]['count']});
						category.push(thisPageData[i]['desc']);
					}
					$('#missItemChart').height($('#missItemTable').height()+120);
					//missItemChart.dispose();
$('#missItemChart').html('');
					missItemChart = echarts.init(document.getElementById('missItemChart'));
					pieChart(missItemChart,data,'ȱʧ��');
	    		}
  			});
	});
}

function loadTable(data,startDate,endDate,mrVersionCode){
	
	//console.log(data['tableInfo'])
	var fpCnt = data['fpCnt']
	var itemClassTable = $('#itemClassTable').DataTable( {
			//dom: 'Bfrtip',
			dom: 'rt',
      		data: data['tableInfo'],
			columns: [
            	{ "data": "sortDesc" ,
						  "render": function ( data, type, full, meta ) {
				      		return '<a title="�鿴��������" role="button" onclick="loadMissDetail(\''+full.sortDesc+'\')">'+full.sortDesc+'</a>';
					    }
				},
            	{ "data": "RqItmTotalCnt" ,
				  "render": function ( data, type, full, meta ) {
							return (full.RqItmTotalCnt/fpCnt).toFixed(2);
					}
				},
            	{ "data": "cRqItmCnt" ,
				  "render": function ( data, type, full, meta ) {
							return (full.cRqItmCnt/fpCnt).toFixed(2);
					}
				},
				{ "data": "cRqItmRatio" },
				{ "data": "mRqItmAvgCnt" },
				{ "data": "FpErrACnt" },
				{ "data": "tScore" },
				{ "data": "AvgScore" },
				{ "data": "TransScore" }
        	],
			order: [[2, 'desc']]
  	});
  	
  	//��Ҫ������ָ��
  	var rankQuotas = [
  					{code:'1',name:'��ҳ������'},
  					{code:'2',name:'ƽ��ȱʧ��'},
  					{code:'3',name:'A���������'},
  					{code:'4',name:'ƽ���÷�'},
  					{code:'5',name:'�ŵ���'},
  					{code:'6',name:'�����'}
  					];
  	$('#depRank .nav-tabs').html('');
  	$('#depRank .tab-content').html('');
  	for(var i=0;i<rankQuotas.length;i++){
	  	var quota = rankQuotas[i];
	  	var active = '';
	  	$.ajax({
        	type: "post",
        	async:false,
        	url: 'dhcmrq.service.csp',
        	data: {ClassName:'DHCMRQ.Compute.Hospital',
			 	   MethodName:'GetDeptRanking',
			 	   Params:startDate+','+endDate+','+mrVersionCode+','+quota.code
				  },
        	success: function (data) {
				if(i==0) active = 'active';
		
				$('#depRank .nav-tabs').append('<li class="'+active+'"><a href="#rankQuota'+quota.code+'" role="tab" data-toggle="tab">'+quota.name+'</a></li>');
	
				$('#depRank .tab-content').append('<div id="rankQuota'+quota.code+'" role="tabpanel" class="tab-pane '+active+'">'
						+'	<div class="row">'
						+'		<div class="col-sm-6">'
						+'			<table class="table table-striped operDepTable" width="100%">'
						+'				<thead>'
						+'					<tr><th colspan="3"><strong>��������</strong></th></tr>'
						+'					<tr class="tr-no-width"><th width="15%">����</th><th>����</th><th width="45%">'+quota.name+'</th></tr>'
						+'				</thead>'
						+'				<tbody></tbody>'
						+'			</table>'
						+'		</div>'
						+'		<div class="col-sm-6">'
						+'			<table class="table table-striped otherDepTable" width="100%">'
						+'				<thead>'
						+'					<tr><th colspan="3"><strong>����������</strong></th></tr>'
						+'					<tr class="tr-no-width"><th width="15%">����</th><th>����</th><th width="45%">'+quota.name+'</th></tr>'
						+'				</thead>'
						+'				<tbody></tbody>'
						+'			</table>'
						+'		</div>'
						+'	</div>'
						+'</div>'
						);
						
				try{
					//console.log(data)
					depRankInfo = JSON.parse(data)
				}catch(err){
					depRankInfo = [];
					console.log(err);
				}
				
				var table = $('#rankQuota'+quota.code+' table').DataTable({
					dom: 'lrtip',
      				data: depRankInfo,
					//lengthMenu: [ [5, 10, -1], [5, 10, "ȫ��"] ],
					columns: [
            			{ "data": "ranking" },
            			{ "data": "deptDesc" 
            			//,
						//  "render": function ( data, type, full, meta ) {
				      	//	return '<a title="�鿴��������" role="button" onclick="addTab(\''+full.deptDesc+'��ҳ\',\'dhcmrq.home.clinicdep.csp?depCode='+full.deptCode+'&depName='+escape(full.deptDesc)+'&startDate='+startDate+'&endDate='+endDate+'&mrVersionCode='+mrVersionCode+'\',\'dep'+full.deptCode+'\')">'+full.deptDesc+'</a>';
					    //	}
					    },
						{ "data": "deptValue" }
        			],
					order: [[2, 'desc']]
  				});
		}
		});
		
		
  	/*
  		t.on( 'order.dt', function () {
        	t.column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
            	cell.innerHTML = i+1;
        	});
    	}).draw();
    */
	}
	
	$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
  		e.target // newly activated tab
  		e.relatedTarget // previous active tab
  		$('.tr-no-width th').removeAttr('style');
	})
}

//ȫԺָ������ͼ
function showTrend(){
$('#trendModal').modal('show');
	$.post('dhcmrq.service.csp',
			{ClassName:'DHCMRQ.Compute.Hospital',
			 MethodName:'GetHospTrend',
			 Params:startDate+','+endDate+','+mrVersionCode
			},
			function(data){
				
				try{
					data = JSON.parse(data);
					//console.log(data)
				}catch(err){
					console.log(data)
					data = {"fpCplRatio":[],"fpItemCplRatio":[],"avgScore":[],"date":[]};
				}
				
				var fpCplRatio = data['fpCplRatio'];
				var fpItemCplRatio = data['fpItemCplRatio'];
				var avgScore = data['avgScore'];
				var dateArray = data['date'];
				
			var lineOption = {
    			//title: {
        		//	text: depName,
        		//	subtext: '2016-01'
    			//},
    			grid: {
	    			top:40,
	    			bottom:60,
	    			left:60,
	    			right:60
	    		},
    			tooltip: {
        			trigger: 'axis'
    			},
    			legend: {
	    			left:0,
        			data:['��ҳ������(%)','��Ŀ������(%)','ƽ���÷�']
    			},
    			toolbox: {
        			feature: {
            			saveAsImage: {}
        			}
    			},
    			xAxis: {
        			type: 'category',
        			boundaryGap: false,
        			data: dateArray
    			},
    			yAxis: {
        			type: 'value',
        			name: '������',
        			nameGap: 45,
        			nameLocation:'middle'
    			},
    			dataZoom: [
        			{
            			type: 'slider',
            			xAxisIndex: [0]//,
            			//startValue: '2016-01',
            			//endValue: '2016-06'
        			}
    			],
    			series: [
        			{
            		name:'��ҳ������(%)',
            		type:'line',
            		smooth: true,
            		data:fpCplRatio
        			},
        			{
            		name:'��Ŀ������(%)',
            		type:'line',
            		smooth: true,
            		data:fpItemCplRatio
        			},
        			{
            		name:'ƽ���÷�',
            		type:'line',
            		smooth: true,
            		data:avgScore
        			}
    			]
			};
			
			//console.log(JSON.stringify(lineOption))
			trendChart.setOption(lineOption);
			trendChart.resize();
			})
	
			
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
				//name:'��ҳ������',
				type:'bar',
				data:data
			}
		]
  };

	// ʹ�ø�ָ�����������������ʾͼ��
  chart.setOption(barOption);
  chart.resize();
}
