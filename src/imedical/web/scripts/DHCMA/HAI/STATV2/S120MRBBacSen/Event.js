function InitS120mrbbacsenWinEvent(obj){
	var MRBDesc = new Array();
	var AntDesc = new Array();
	var arrMRBCount = new Array();
	var arrAntCount = new Array();
	var arrMRBRatio = new Array();
	var arrAntRatio = new Array();
	
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
	obj.clickEvent = function(number){
		if(MRBDesc.length<=number){
			var MRBDesc1 	 = MRBDesc.slice(0,MRBDesc.length);
			var arrMRBCount1 = arrMRBCount.slice(0,MRBDesc.length);		
			var arrMRBRatio1 = arrMRBRatio.slice(0,MRBDesc.length);
		
			var endnumber = (10/BacDesc.length)*100;
		}else{
			var MRBDesc1 	 = MRBDesc.slice(0,number);
			var arrMRBCount1 = arrMRBCount.slice(0,number);		
			var arrMRBRatio1 = arrMRBRatio.slice(0,number);

			var endnumber = (10/number)*100;
		}
		
		var option2 = obj.option1(MRBDesc1,arrMRBCount1,arrMRBRatio1,endnumber);
		obj.myChart.setOption(option2,true);
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
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S120MRBBacSen.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aLocType='+aLocType+'&aQryCon='+aQrycon;	
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}
		
	}
	obj.option1 = function(MRBDesc,arrMRBCount,arrMRBRatio,endnumber){
		var option1 = {
			title : {
				text: '多重耐药医院感染病原体对抗菌药物的耐药率',
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
				data:['耐药数','耐药率'],
				x: 'center',
				y: 30
			},
			 dataZoom: [{
				show: true,
				realtime: true,
				start: 0,
				end: endnumber
			}],
			xAxis: [
				{
					type: 'category',
					data: MRBDesc,
					axisLabel: {
								margin:8,
								rotate:45,
								interval:0,
								// 使用函数模板，函数参数分别为刻度数值（类目），刻度的索引
								formatter: function (value, index) {
									//处理标签，过长折行和省略
									if(value.length>6 && value.length<11){
										return value.substr(0,5)+'\n'+value.substr(5,5);
									}else if(value.length>10){
										return value.substr(0,6)+'\n'+value.substr(6,4)+"...";
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
					interval:1,
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '耐药率(%)',
					min: 0,
					interval:1,
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
					data:arrMRBCount
				},
				{
					name:'耐药率',
					type:'line',
					yAxisIndex: 1,
					data:arrMRBRatio,
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
		
		MRBDesc.splice(0,MRBDesc.length);
		arrMRBCount.splice(0,arrMRBCount.length);		
		arrMRBRatio.splice(0,arrMRBRatio.length);
		AntDesc.splice(0,AntDesc.length);
		arrAntCount.splice(0,arrAntCount.length);		
		arrAntRatio.splice(0,arrAntRatio.length);
		
		arrRecord 		= runQuery.record;
		var arrlength	= arrRecord.length;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			MRBDesc.push(rd["MRBDesc"]);
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
		MRBDesc=uniq(MRBDesc);
		for(var i = 0; i < MRBDesc.length; i++){
			var MRBDesc1 = MRBDesc[i];
			var AntDesc1 = AntDesc[i];
			var Count1=0;
			var Count2=0;	
			for (var indRd = 0; indRd < arrRecord.length; indRd++){
				var rd = arrRecord[indRd];
				if((rd["MRBDesc"]==MRBDesc1)&&(rd["MapTestSen"]!='S')){
					Count1=Count1+1;
				}else if((rd["AntDesc"]==AntDesc1)&&(rd["MapTestSen"]!='S')){
					Count2=Count2+1;
				}
			}
			arrMRBRatio.push((rd["Count1"]/arrlength)*100);
			arrAntRatio.push((rd["Count2"]/arrlength)*100);
			arrMRBCount.push(rd["Count1"]);
			arrAntCount.push(rd["Count2"]);
		}
		var len = MRBDesc.length;
		for(var i = 0; i < len-1; i++){
			for(var j = 0; j < len-1-i ; j++){
				if(arrMRBCount[j+1] > arrMRBCount[j]) {//相邻元素两两对比
					var temp1 = arrMRBCount[j+1];//元素交换
					arrMRBCount[j+1] = arrMRBCount[j];
					arrMRBCount[j] = temp1;
					var temp2 = MRBDesc[j+1];//元素交换
					MRBDesc[j+1] = MRBDesc[j];
					MRBDesc[j] = temp2;
					var temp2 = arrMRBRatio[j+1];//元素交换
					arrMRBRatio[j+1] = arrMRBRatio[j];
					arrMRBRatio[j] = temp2;
					
				}
			}
		}
		var endnumber = (10/MRBDesc.length)*100;
		// 使用刚指定的配置项和数据显示图表。
		obj.myChart.setOption(obj.option1(MRBDesc,arrMRBCount,arrMRBRatio,endnumber),true);
	}
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear()
		 //当月科室感染率图表
		var aHospID = $('#cboHospital').combobox('getValue');
		var aDateFrom = $('#dtDateFrom').datebox('getValue');
		var aDateTo= $('#dtDateTo').datebox('getValue');
		var aLocType = Common_CheckboxValue('chkStatunit');
		var aQrycon 	= $('#cboQryCon').combobox('getValue');
		var dataInput = "ClassName=" + 'DHCHAI.STATV2.S120MRBBacSen' + "&QueryName=" + 'QryRstMRBSen' + "&Arg1=" + aHospID  +"&Arg2="+aDateFrom+"&Arg3="+aDateTo+ "&Arg4=" + aLocType + "&Arg5=" + aQrycon+"&ArgCnt=" + 5;

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
				var tkclass="DHCHAI.STATV2.S120MRBBacSen";
				var tkQuery="QryRstMRBSen";
				alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
				obj.myChart.hideLoading();    //隐藏加载动画
			}
		});
	}
	
}