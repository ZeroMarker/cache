function InitS190CtlAntBloWinEvent(obj){	 
   	obj.LoadEvent = function(args){
		$('#ReportFrame').css('display', 'block');
		setTimeout(function(){
			obj.LoadRep();
		},50);

		//图的点击事件
		$('#btnSearchChart').on('click',function(e,value){
			$("#comboNum").css("display","block");
			$('#EchartDiv').css('display', 'block');
			$('#ReportFrame').css('display', 'none');
			obj.myChart = echarts.init(document.getElementById('EchartDiv'),'theme');
			obj.ShowEChaert1();
		});
		
		//表的点击事件
		$('#btnSearchTable').on('click',function(e,value){
			$("#comboNum").css("display","none");
			$('#ReportFrame').css('display', 'block');
			$('#EchartDiv').css('display', 'none');
			obj.LoadRep();
		});
   	}
   	obj.LoadRep = function(){
		var aHospID 	= $('#cboHospital').combobox('getValue');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		var aQryCon 	= $('#cboQryCon').combobox('getValue');
		ReportFrame = document.getElementById("ReportFrame");
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S190CtlAntBlo.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aLocType='+aLocType+'&aQryCon='+aQryCon;	
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}
		
	}
	obj.up=function(x,y){
        return y.BfKSS2CureSubCnt-x.BfKSS2CureSubCnt		//根据限制级治疗前送检人数排序
    }
	obj.option1 = function(arrViewLoc,arrBfKSS2Cnt,arrBfKSS2Ratio,arrBfKSS3Cnt,arrBfKSS3Ratio,endnumber){
		var option1 = {
			title : {
				text: '住院患者限制/特殊使用级抗菌药物治疗前血培养送检人数统计图',
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
				data:['限制级送检人数','特殊级送检人数','限制级送检率','特殊级送检率'],
				x: 'center',
				y: 30
			},
			 dataZoom: [{
				show: true,
				realtime: true,
				start: 0,
				zoomLock:true,
				end: endnumber
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
					name: '送检人数',
					min: 0,
					interval:function(){
						if(arrBfKSS2Cnt[0]>=arrBfKSS3Cnt[0]){
							return Math.ceil(arrBfKSS2Cnt[0]/10);	
						}else{
							return Math.ceil(arrBfKSS3Cnt[0]/10);
						}	
					},
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '送检率(%)',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} %'
					}
				}
				
			],
			series: [
				 {
					name:'限制级送检人数',
					type:'bar',
					barMaxWidth:50,
					data:arrBfKSS2Cnt
				},
				{
					name:'特殊级送检人数',
					type:'bar',
					barMaxWidth:50,
					data:arrBfKSS3Cnt
				},
				{
					name:'限制级送检率',
					type:'line',
					yAxisIndex: 1,
					data:arrBfKSS2Ratio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				}  ,
				{
					name:'特殊级送检率',
					type:'line',
					yAxisIndex: 1,
					data:arrBfKSS3Ratio,
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
		
		var arrViewLoc 		= new Array();
		var arrBfKSS2Cnt 	= new Array();		//限制级治疗前血培养送检人数
		var arrBfKSS2Ratio 	= new Array();
		var arrBfKSS3Cnt	= new Array();		//特殊级治疗前血培养送检人数
		var arrBfKSS3Ratio	= new Array();
	
		arrRecord 		= runQuery.record;
		
		var arrlength		= 0;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			//去掉全院、医院、科室组
			if ((rd["xDimensKey"].indexOf('-A-')>-1)||(rd["xDimensKey"].indexOf('-H-')>-1)||(rd["xDimensKey"].indexOf('-G-')>-1)) {
				delete arrRecord[indRd];
				arrlength = arrlength + 1;
				continue;
			}
			rd["DimensDesc"] = $.trim(rd["DimensDesc"]); //去掉空格
			rd["BfKSS2CureSubRatio"] = parseFloat(rd["BfKSS2CureSubRatio"].replace('%','').replace('‰','')).toFixed(2);
			rd["BfKSS3CureSubRatio"] = parseFloat(rd["BfKSS3CureSubRatio"].replace('%','').replace('‰','')).toFixed(2);
		}
		
		arrRecord = arrRecord.sort(obj.up);
		arrRecord.length = arrRecord.length - arrlength;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			
			arrViewLoc.push(rd["DimensDesc"]);
			arrBfKSS2Cnt.push(rd["BfKSS2CureSubCnt"]);
			arrBfKSS2Ratio.push(parseFloat(rd["BfKSS2CureSubRatio"]).toFixed(2));
			arrBfKSS3Cnt.push(rd["BfKSS3CureSubCnt"]);
			arrBfKSS3Ratio.push(parseFloat(rd["BfKSS3CureSubRatio"]).toFixed(2));
			
		}
		var endnumber = (14/arrViewLoc.length)*100;
		// 使用刚指定的配置项和数据显示图表。
		obj.myChart.setOption(obj.option1(arrViewLoc,arrBfKSS2Cnt,arrBfKSS2Ratio,arrBfKSS3Cnt,arrBfKSS3Ratio,endnumber),true);
	}
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear()
		 //当月科室感染率图表
		var aHospID = $('#cboHospital').combobox('getValue');
		var aDateFrom = $('#dtDateFrom').datebox('getValue');
		var aDateTo= $('#dtDateTo').datebox('getValue');
		var aLocType = Common_CheckboxValue('chkStatunit');
		var aQryCon 	= $('#cboQryCon').combobox('getValue');
		var dataInput = "ClassName=" + 'DHCHAI.STATV2.S190CtlAntBlo' + "&QueryName=" + 'QryCtlAntBlo' + "&Arg1=" + aHospID + "&Arg2=" + aDateFrom + "&Arg3=" + aDateTo +"&Arg4="+aLocType+"&Arg5="+aQryCon+"&ArgCnt=" + 5;

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
				var tkclass="DHCHAI.STATV2.S190CtlAntBlo";
				var tkQuery="QryCtlAntBlo";
				alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
				obj.myChart.hideLoading();    //隐藏加载动画
			}
		});
	}
	
}