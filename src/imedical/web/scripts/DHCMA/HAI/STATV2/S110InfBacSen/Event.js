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
   	}
	
   	obj.LoadRep = function(){
		var aHospID 	= $('#cboHospital').combobox('getValues').join('|');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		var aQrycon 	= "";	//$('#cboQryCon').combobox('getValue');
		var aStatDimens ="";
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	
		var aBacDescs	= $('#cboBacteria').combobox('getValues').join(',');
		var aAntDescs 	= $('#cboAnti').combobox('getValues').join(',');		
		ReportFrame = document.getElementById("ReportFrame");
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S110InfBacSen.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aLocType='+aLocType+'&aQryCon='+aQrycon+'&aStatDimens='+aStatDimens+'&aLocIDs='+aLocIDs+'&aBacDescs='+aBacDescs+'&aAntDescs='+aAntDescs+'&aPath='+cspPath;	
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
				data:['耐药数','耐药率'],
				x: 'center',
				y: 30
			},
			 dataZoom: [{
			 	height: 40,
				show: true,
				realtime: true,
				start: 0,
				end: endnumber,
				bottom: 0,
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
		arrRecord 		= runQuery.rows;	
		
		var BacDesc = new Array();			//细菌名称
		var arrBacCount = new Array();		//耐药数目
		var arrBacRatio= new Array();		//耐药率
		
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			
			BacDesc.push(rd["BacDesc"]);
		}
		//合并细菌
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
			var Count1=0;
			var Sum=0;	
			for (var indRd = 0; indRd < arrRecord.length; indRd++){
				var rd = arrRecord[indRd];
				if(rd["BacDesc"]==BacDesc1){
					Sum=parseInt(Sum)+parseInt(rd["Cnt"]);
					Count1=parseInt(Count1)+parseInt(rd["NoSCnt"]);
				}
			}
			arrBacRatio.push(((Count1/Sum)*100).toFixed(2));
			arrBacCount.push(Count1);
		}
		
		if(obj.sortName=="耐药数"){
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
		}
		else{
			var len = BacDesc.length;
			for(var i = 0; i < len-1; i++){
				for(var j = 0; j < len-1-i ; j++){
					if(parseFloat(arrBacRatio[j+1])>parseFloat(arrBacRatio[j])) {//相邻元素两两对比
						var temp1 = arrBacRatio[j+1];//元素交换
						arrBacRatio[j+1] = arrBacRatio[j];
						arrBacRatio[j] = temp1;
						var temp2 = BacDesc[j+1];//元素交换
						BacDesc[j+1] = BacDesc[j];
						BacDesc[j] = temp2;
						var temp2 = arrBacCount[j+1];//元素交换
						arrBacCount[j+1] = arrBacCount[j];
						arrBacCount[j] = temp2;	
					}
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
		var aHospID 	= $('#cboHospital').combobox('getValues').join('|');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		var aQrycon 	= "";	//$('#cboQryCon').combobox('getValue');
		var aStatDimens ="";
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	
		var aBacDescs	= $('#cboBacteria').combobox('getValues').join(',');
		var aAntDescs 	= $('#cboAnti').combobox('getValues').join(',');		
		ReportFrame = document.getElementById("ReportFrame");
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		obj.myChart.showLoading();    //显示加载动画
		$cm({
			ClassName:'DHCHAI.STATV2.S110InfBacSen',
			QueryName:'QryRepRstSen',
			aHospIDs:aHospID,
			aDateFrom:aDateFrom,
			aDateTo:aDateTo,
			aLocType:aLocType,
			aQryCon:aQrycon,
			aStatDimens:aStatDimens,
			aLocIDs:aLocIDs,
			aBacDescs:aBacDescs,
			aAntDescs:aAntDescs,
			page:1,    //可选项，页码，默认1
			rows:999   //可选项，获取多少条数据，默认50
		},function(rs){
			obj.myChart.hideLoading();    //隐藏加载动画
			obj.echartLocInfRatio(rs); //
			
			obj.sortName="耐药率"; //初始化排序指标
			obj.myChart.off('legendselectchanged'); //取消事件，避免事件绑定重复导致多次触发
			obj.myChart.on('legendselectchanged', function(legObj){
				//处理排序问题 
				//如果是重复点击认为是需要执行隐藏处理,不想隐藏就不用判断了	
				if(obj.sortName!=legObj.name)
				{
					obj.sortName=legObj.name;
					obj.echartLocInfRatio(rs);
				}
				else
				{
					obj.sortName="";  //初始化
				}
				
			});
		});
	}
}