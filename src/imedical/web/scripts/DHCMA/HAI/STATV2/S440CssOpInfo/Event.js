function InitS440cssopinfoWinEvent(obj){
   	obj.LoadEvent = function(args){
		
		$('#ReportFrame').css('display', 'block');
		setTimeout(function(){
			obj.LoadRep();
		},50);

		//图的点击事件
		$('#btnSearchChart').on('click',function(e,value){
			$('#EchartDiv').css('display', 'block');
			$('#ReportFrame').css('display', 'none');
			obj.myChart = echarts.init(document.getElementById('EchartDiv'),'theme');
			obj.ShowEChaert1();
		});
		
		//表的点击事件
		$('#btnSearchTable').on('click',function(e,value){
			$('#ReportFrame').css('display', 'block');
			$('#EchartDiv').css('display', 'none');
			obj.LoadRep();
		});
   	}
   	obj.LoadRep = function(){
	   	
		var SurNumID 	= $('#cboSurNum').combobox('getValue');	
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs = $('#cboLoc').combobox('getValues').join(',');	
		ReportFrame = document.getElementById("ReportFrame");
		
		p_URL = Append_Url('dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S440CssOpInfo.raq&aSurNumID='+SurNumID +'&aStaType=' + aLocType);	
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		} 
		
	}

	obj.option1 = function(arrViewLoc,arrOpUseCnt,endnumber){
		var option1 = {
			title : {
				text: '手术人数统计图',
				textStyle:{
					fontSize:28
				},
				x:'center',
				y:'top'
			},
			grid:{
				left:'5%',
				top:'11%',	
				right:'5%',
				bottom:'5%',
				containLabel:true
			},
			tooltip: {
				trigger: 'axis',
			},
			toolbox: {
				feature: {
					dataView: {show: false, readOnly: false},
					magicType: {show: true, type: ['line', 'bar']},
					restore: {show: true},
					saveAsImage: {show: true}
				}
			},
			legend: {
				data:['手术人数',],
				x: 'center',
				y: 40
			},
			 dataZoom: [{
				show: true,
				realtime: true,
				start: 0,
				end: endnumber,
				zoomLock:true
			}],
			xAxis: [
				{
					type: 'category',
					data: arrViewLoc,
					axisLabel: {
								margin:8,
								rotate:45,
								interval:0,
								// 使用函数模板，函数参数分别为刻度数值（类目），刻度的索引
								formatter: function (value, index) {
									//处理标签，过长折行和省略
									if(value.length>6 && value.length<11){
										return value.substr(0,5)+'\n'+value.substr(5,5);
									}else if(value.length>10&&value.length<16){
										return value.substr(0,5)+'\n'+value.substr(5,5)+'\n'+value.substr(10,5);
									}else if(value.length>15&&value.length<21){
										return value.substr(0,5)+'\n'+value.substr(5,5)+'\n'+value.substr(10,5)+'\n'+value.substr(15,5);
									}else{
										return value;
									}
								}
							}
				}
			],
			yAxis: [
				{
					type: 'value',
					name: '手术人数',
					nameTextStyle: {
			            padding: [0, 0, 10, -10]    // 四个数字分别为上右下左与原位置距离
			        },
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} '
					}
				},
			],
			series: [
				 {
					name:'手术人数',
					type:'bar',
					barMaxWidth:50,
					data:arrOpUseCnt
				},
			]
		};
		return option1;
	}
	
    obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) return;
		
		var arrViewLoc 		= new Array();
		var arrOpUseCnt 	= new Array();		//手术人数
		var arrRecord = runQuery.rows;
		RemoveArr(arrRecord);
		arrRecord = arrRecord.sort(function(x, y) {    
			return parseInt(y.OpUseCnt) - parseInt(x.OpUseCnt)
		});
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrViewLoc.push($.trim(rd["DimensDesc"]));
			arrOpUseCnt.push(rd["OpUseCnt"]);
		}
		var endnumber = (14/arrViewLoc.length)*100;

		// 使用刚指定的配置项和数据显示图表。
		obj.myChart.setOption(obj.option1(arrViewLoc,arrOpUseCnt,endnumber),true);
	}
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear()
		var SurNumID 	= $('#cboSurNum').combobox('getValue');	
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs = $('#cboLoc').combobox('getValues').join(',');	
		
		obj.myChart.showLoading();	
		var className="DHCHAI.STATV2.S440CssOpInfo";
		var queryName="CssQryOpInfo";
		$cm({
		    ClassName: className,
		    QueryName: queryName,
		    aSurNumID: SurNumID,
		    aStaType: aLocType,
			aStatDimens:aStatDimens,
			aLocIDs:aLocIDs,
			page:1,    //可选项，页码，默认1
			rows:999   //可选项，获取多少条数据，默认50
		},
		function(data){
			obj.myChart.hideLoading();    //隐藏加载动画
			obj.echartLocInfRatio(data);

		}
		,function(XMLHttpRequest, textStatus, errorThrown){
			alert("类" + className + ":" + queryName+ "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
			obj.myChart.hideLoading();    //隐藏加载动画
		}); 

	}
	
}