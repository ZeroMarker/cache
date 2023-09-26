	// 基于准备好的dom，初始化echarts实例
	var missItemChart = echarts.init(document.getElementById('missItemChart'));
	//趋势图
	var trendChart = echarts.init(document.getElementById('trendChart'));
	var goodChart = echarts.init(document.getElementById('goodChart'));
	window.onresize = function(){
		missItemChart.resize();
		trendChart.resize();
		goodChart.resize();
	}

$(function(){
	
	init();//初始化
	
	$('#depScoreLink').click(function(){
	  	var param = 'startDate='+$("#startDate").val()
	  			   +'&endDate='+$("#endDate").val()
	  			   +'&mrVersionCode='+$('#mrVersionSelect').val();
		addTab('科室得分情况','dhcmrq.score.csp?'+param,'scorePage');  	
	})
	
	searchByCondition();
});

function loadData(){
	//获取全院基本情况
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
				
				loadMissDetail('基本信息');
	});
	
	//获取评价等级情况
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
					data1 = [{name:'优',value:data['fpGradeA']},{name:'良',value:data['fpGradeB']},{name:'中',value:data['fpGradeC']},{name:'差',value:data['fpGradeD']}];
					if(data['fpGradeA']==0 && data['fpGradeB']==0 && data['fpGradeC']==0 && data['fpGradeD']==0){
						data1=[];
					}
				}catch(err){
					data = {"fpGradeA":0,"fpGradeB":0,"fpGradeC":0,"fpGradeD":0};
					data1 = [];
				}
				
				
				var option = {
                    title : {
                        subtext:'病案质量分布',
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
                        data: ['优','良','中','差']
                    },
                    series : [
                        {
                            name: '病案质量',
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
	//全院信息
	var hospInfo=tkMakeServerCall("DHCMRQ.Compute.Hospital","GetHospInfo",startDate,endDate,mrVersionCode);
	//console.log(JSON.parse(hospInfo)[0])
	loadHospData(JSON.parse(hospInfo)[0]);
	
	loadTable(JSON.parse(hospInfo)[0]['tableInfo'],startDate,endDate,mrVersionCode)
	
	//问题列表默认先加载基本信息
	loadMissDetail('基本信息');
	*/
}

//加载全院总体情况
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
								title:'扣分项信息'
								});
	
	$('.fpCnt').html('总病例数：'+data['fpCnt']);
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

//加载问题列表
function loadMissDetail(className){
	var classCode = '';//项目类别代码
	switch(className){
		case '合计':
			classCode = '';
			break;
		case '基本信息':
			classCode = 'DEFIR-I';
			break;
		case '住院过程':
			classCode = 'DEFIR-P';
			break;
		case '诊疗信息':
			classCode = 'DEFIR-D';
			break;
		case '费用信息':
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
							  //'<a title="查看病例详情" role="button" onclick="addTab(\''+full.desc+'缺失病例列表\',\'dhcmrq.caseList.csp?itemId='+full.ItemID+'&startDate='+startDate+'&endDate='+endDate+'&mrVersionCode='+mrVersionCode+'\',\'mrList'+full.ItemID+'\')">'+full.count+'</a>';
				      		return '<a title="查看科室分布" role="button" onclick="addTab(\''+full.desc+'缺失病例科室分布\',\'dhcmrq.itemmissdep.csp?itemId='+full.ItemID+'&startDate='+startDate+'&endDate='+endDate+'&mrVersionCode='+mrVersionCode+'&itemDesc='+escape(full.desc)+'\',\'depList'+full.ItemID+'\')"><i class="fa fa-hospital-o fa-lg"></i></a>';
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
					pieChart(missItemChart,data,'缺失项');
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
				      		return '<a title="查看问题详情" role="button" onclick="loadMissDetail(\''+full.sortDesc+'\')">'+full.sortDesc+'</a>';
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
  	
  	//需要排名的指标
  	var rankQuotas = [
  					{code:'1',name:'首页完整率'},
  					{code:'2',name:'平均缺失数'},
  					{code:'3',name:'A类错误病例数'},
  					{code:'4',name:'平均得分'},
  					{code:'5',name:'优等率'},
  					{code:'6',name:'差等率'}
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
						+'					<tr><th colspan="3"><strong>手术科室</strong></th></tr>'
						+'					<tr class="tr-no-width"><th width="15%">排名</th><th>科室</th><th width="45%">'+quota.name+'</th></tr>'
						+'				</thead>'
						+'				<tbody></tbody>'
						+'			</table>'
						+'		</div>'
						+'		<div class="col-sm-6">'
						+'			<table class="table table-striped otherDepTable" width="100%">'
						+'				<thead>'
						+'					<tr><th colspan="3"><strong>非手术科室</strong></th></tr>'
						+'					<tr class="tr-no-width"><th width="15%">排名</th><th>科室</th><th width="45%">'+quota.name+'</th></tr>'
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
					//lengthMenu: [ [5, 10, -1], [5, 10, "全部"] ],
					columns: [
            			{ "data": "ranking" },
            			{ "data": "deptDesc" 
            			//,
						//  "render": function ( data, type, full, meta ) {
				      	//	return '<a title="查看科室详情" role="button" onclick="addTab(\''+full.deptDesc+'首页\',\'dhcmrq.home.clinicdep.csp?depCode='+full.deptCode+'&depName='+escape(full.deptDesc)+'&startDate='+startDate+'&endDate='+endDate+'&mrVersionCode='+mrVersionCode+'\',\'dep'+full.deptCode+'\')">'+full.deptDesc+'</a>';
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

//全院指标趋势图
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
        			data:['首页完整率(%)','项目完整率(%)','平均得分']
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
        			name: '完整率',
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
            		name:'首页完整率(%)',
            		type:'line',
            		smooth: true,
            		data:fpCplRatio
        			},
        			{
            		name:'项目完整率(%)',
            		type:'line',
            		smooth: true,
            		data:fpItemCplRatio
        			},
        			{
            		name:'平均得分',
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
	// 指定图表的配置项和数据
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
				//name:'首页完整率',
				type:'bar',
				data:data
			}
		]
  };

	// 使用刚指定的配置项和数据显示图表。
  chart.setOption(barOption);
  chart.resize();
}
