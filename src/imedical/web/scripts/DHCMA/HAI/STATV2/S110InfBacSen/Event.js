function InitS110infbacsenWinEvent(obj){
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
		//
   	}
	
   	obj.LoadRep = function(){
		var aHospID 	= $('#cboHospital').combobox('getValue');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		var aQrycon 	= $('#cboQryCon').combobox('getValue');
		ReportFrame = document.getElementById("ReportFrame");
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S110InfBacSen.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aStaType='+aLocType+'&aQryCon='+aQrycon;	
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		} 
		
	}

	obj.option1 = function(BacDesc,arrBacCount,arrBacRatio,endnumber){
		var option1 = {
			title : {
				text: '医院感染病原体对抗菌药物的耐药率',
				textStyle:{
					fontSize:28
				},
				x:'center',
				y:'top'
			},
			tooltip: {
				trigger: 'axis',
			},
			grid:{
				left:'5%',
				top:'12%',	
				right:'5%',
				bottom:'5%',
				containLabel:true
			},
			toolbox: {
				right:"20px",
				feature: {
					dataView: {show: false, readOnly: false},
					magicType: {show: true, type: ['line', 'bar']},
					restore: {show: true},
					saveAsImage: {show: true}
				}
			},
			legend: {
				data:['感染人数','感染率'],
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
					data: BacDesc,
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
					name: '耐药数',
					min: 0,
					interval:Math.ceil(arrBacCount[0]/10),
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '耐药率(%)',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} %'
					}
				}
			],
			series: [
				 {
					name:'耐药数',
					type:'bar',
					barMaxWidth:50,
					data:arrBacCount
				},
				{
					name:'耐药率',
					type:'line',
					yAxisIndex: 1,
					data:arrBacRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				}  
			]
		};
		return option1;
	}
	
    obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) return;
		
		var BacDesc = new Array();
		var AntDesc = new Array();
		var arrBacCount = new Array();
		var arrAntCount = new Array();
		var arrBacRatio = new Array();
		var arrAntRatio = new Array();
		
		arrRecord 		= runQuery.record;
		var arrlength	= arrRecord.length;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			BacDesc.push(rd["BacDesc"]);
			AntDesc.push(rd["AntDesc"]);
		}
		
		function uniq(array){
		    var temp = [];
		    var index = [];
		    var l = array.length;
		    for(var i = 0; i < l; i++) {
		        for(var j = i + 1; j < l; j++){
		            if (array[i] === array[j]){
		                i++;
		                j = i;
		            }
		        }
		        temp.push(array[i]);
		        index.push(i);
		    }
		    return temp;
		}
		BacDesc=uniq(BacDesc)
		for(var i = 0; i < BacDesc.length; i++){
			var BacDesc1 = BacDesc[i];
			//var AntDesc1 = AntDesc[i];
			var Count1=0;
			//var Count2=0;
			var Sum=0;	
			for (var indRd = 0; indRd < arrRecord.length; indRd++){
				var rd = arrRecord[indRd];
				if(rd["BacDesc"]==BacDesc1){
					Sum=Sum+1;
					if(rd["MapTestSen"]!='S'){
						Count1=Count1+1;	
					}
				}
				/*
				if((rd["BacDesc"]==BacDesc1)&&(rd["MapTestSen"]!='S')){
					Count1=Count1+1;
				}else if((rd["AntDesc"]==AntDesc1)&&(rd["MapTestSen"]!='S')){
					Count2=Count2+1;
				}*/
			}
			
			arrBacRatio.push(((Count1/Sum)*100).toFixed(2));
			arrBacCount.push(Count1);
			/*
			arrBacRatio.push((rd["Count1"]/arrlength)*100);
			arrAntRatio.push((rd["Count2"]/arrlength)*100);
			arrBacCount.push(rd["Count1"]);
			arrAntCount.push(rd["Count2"]);
			*/
		}
		var len = BacDesc.length;
		for(var i = 0; i < len-1; i++){
			for(var j = 0; j < len-1-i ; j++){
				if(arrBacCount[j+1] > arrBacCount[j]) {//相邻元素两两对比
					var temp1 = arrBacCount[j+1];//元素交换
					arrBacCount[j+1] = arrBacCount[j];
					arrBacCount[j] = temp1;
					var temp2 = BacDesc[j+1];//元素交换
					BacDesc[j+1] = BacDesc[j];
					BacDesc[j] = temp2;
					var temp2 = arrBacRatio[j+1];//元素交换
					arrBacRatio[j+1] = arrBacRatio[j];
					arrBacRatio[j] = temp2;	
				}
			}
		}
		var endnumber = (14/BacDesc.length)*100;
		// 使用刚指定的配置项和数据显示图表。
		obj.myChart.setOption(obj.option1(BacDesc,arrBacCount,arrBacRatio,endnumber),true);
	}
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear()
		 //当月科室感染率图表
		var aHospID = $('#cboHospital').combobox('getValue');
		var aDateFrom = $('#dtDateFrom').datebox('getValue');
		var aDateTo= $('#dtDateTo').datebox('getValue');
		var aLocType = Common_CheckboxValue('chkStatunit');
		var aQryCon 	= $('#cboQryCon').combobox('getValue');
		var dataInput = "ClassName=" + 'DHCHAI.STATV2.S110InfBacSen' + "&QueryName=" + 'QryRepRstSen' + "&Arg1=" + aHospID + "&Arg2=" + aDateFrom + "&Arg3=" + aDateTo +"&Arg4="+aLocType+"&Arg5="+aQryCon+"&ArgCnt=" + 5;

		$.ajax({
			url: "./dhchai.query.csp",
			type: "post",
			timeout: 30000, //30秒超时
			async: true,   //异步
			beforeSend:function(){
				obj.myChart.showLoading();	
			},
			data: dataInput,
			success: function(data, textStatus){
				obj.myChart.hideLoading();    //隐藏加载动画
				var retval = (new Function("return " + data))();
				obj.echartLocInfRatio(retval);
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				var tkclass="DHCHAI.STATV2.S110InfBacSen";
				var tkQuery="QryRepRstSen";
				alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
				obj.myChart.hideLoading();    //隐藏加载动画
			}
		});
	}
	
}