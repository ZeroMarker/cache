﻿function InitS050mrbposWinEvent(obj){
	obj.LoadEvent = function(args){
		$('#ReportFrame').css('display', 'block');
		setTimeout(function(){
			obj.LoadRep();
		},50);

		//图的点击事件
		$('#btnSearchChart').on('click',function(e,value){
			$('#EchartDiv').css('display', 'block');
			$('#ReportFrame').css('display', 'none');
			$('#EchartDiv').removeClass("no-result");
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
		var aQrycon 	= $('#cboQryCon').combobox('getValue');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	
		ReportFrame = document.getElementById("ReportFrame");
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		if ((aStatDimens=="")){
			$.messager.alert("提示","请选择展示维度！", 'info');
			return;
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S050MRBPos.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aLocType='+aLocType+'&aQryCon='+aQrycon+'&aStatDimens='+aStatDimens+'&aLocIDs='+aLocIDs+'&aPath='+cspPath;		
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}
		
	}
    obj.echartLocInfRatio = function(runQuery){
	    if (!runQuery) return;
		arrRecord 		= runQuery.record;
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	
		if(aLocIDs==""){
			var rd = arrRecord[0];					//取首条记录
		}
		else{
			var rd = arrRecord[arrRecord.length-1];	//取末条记录
		}
		
		if(rd.MMRBCase==0){
			$('#EchartDiv').addClass('no-result');
			return;
		}
		var M1MRBCase=rd["M1MRBCase"];
		var M2MRBCase=rd["M2MRBCase"];
		var M3MRBCase=rd["M3MRBCase"];
		var M4MRBCase=rd["M4MRBCase"];
		var M5MRBCase=rd["M5MRBCase"];
		var M6MRBCase=rd["M6MRBCase"];
		var M7MRBCase=rd["M7MRBCase"];
		var M8MRBCase=rd["M8MRBCase"];
		var M9MRBCase=rd["M9MRBCase"];
		//取多耐类别描述
		var MRBDescList = $cm ({
			ClassName:"DHCHAI.STATV2.S040MRBInf",
			QueryName:"QryMRBSrv"
		},false);
		var M1Desc=MRBDescList.rows[0].M1Desc;	
		var M2Desc=MRBDescList.rows[0].M2Desc;	
		var M3Desc=MRBDescList.rows[0].M3Desc;	
		var M4Desc=MRBDescList.rows[0].M4Desc;	
		var M5Desc=MRBDescList.rows[0].M5Desc;	
		var M6Desc=MRBDescList.rows[0].M6Desc;	
		var M7Desc=MRBDescList.rows[0].M7Desc;	
		var M8Desc=MRBDescList.rows[0].M8Desc;	
		var M9Desc=MRBDescList.rows[0].M9Desc;	
		
		// 使用刚指定的配置项和数据显示图表。
		option = {
			    title : {
			        text: '多重耐药菌检出例数统计图',
			        textStyle:{
						fontSize:28
					},
			        x:'center'
			    },
			    tooltip : {
			        trigger: 'item',
			        formatter: "{a} <br/>{b} : {c} ({d}%)"
			    },
				toolbox: {
					feature: {
						dataView: {show: false, readOnly: false},
						magicType: {show: false, type: ['line', 'bar']},
						restore: {show: true},
						saveAsImage: {show: true}
					}
				},
			    legend: {
			        orient: 'vertical',
			        left: 'left',
			        data:[M1Desc,M2Desc,M3Desc,M4Desc,M5Desc,M6Desc,M7Desc,M8Desc,M9Desc]
			    },
			    series : [
			        {
			            name: '多耐名称',
			            type: 'pie',
			            radius : '55%',
			            center: ['50%', '60%'],
			           data: [
			            	{"value": M1MRBCase,"name":M1Desc},
			            	{"value": M2MRBCase,"name":M2Desc},
			            	{"value": M3MRBCase,"name":M3Desc},
			            	{"value": M4MRBCase,"name":M4Desc},
			            	{"value": M5MRBCase,"name":M5Desc},
			            	{"value": M6MRBCase,"name":M6Desc},
			            	{"value": M7MRBCase,"name":M7Desc},
			            	{"value": M8MRBCase,"name":M8Desc},
			            	{"value": M9MRBCase,"name":M9Desc}
			            ]
			        }
			    ]
			};
		obj.myChart.setOption(option,true);
	}
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear()
		//当月科室感染率图表
		var aHospID 	= $('#cboHospital').combobox('getValues').join('|');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		var aQrycon 	= $('#cboQryCon').combobox('getValue');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	
		/*
		var dataInput 	= "ClassName=" + 'DHCHAI.STATV2.S050MRBPos' + "&QueryName=" + 'QryMRBPos' + "&Arg1=" + aHospID + "&Arg2=" + aDateFrom + "&Arg3=" + aDateTo +"&Arg4="+aLocType+"&Arg5="+aQrycon+"&Arg6="+aStatDimens+"&Arg7="+aLocIDs+"&ArgCnt=" + 7;
		
		$.ajax({
			url: "./dhchai.query.csp",
			type: "post",
			timeout: 120000, //120秒超时
			async: true,   //异步
			beforeSend:function(){
				obj.myChart.showLoading();	
			},
			data: dataInput,
			success: function(data, textStatus){
				obj.myChart.hideLoading();    //隐藏加载动画
				var retval = (new Function("return " + data))();
				if(retval.record[0]["MRBCount"]==0){
					$('#EchartDiv').addClass('no-result');
				}else{
					obj.echartLocInfRatio(retval);
				}
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				var tkclass="DHCHAI.STATV2.S050MRBPos";
				var tkQuery="QryMRBPos";
				alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
				obj.myChart.hideLoading();    //隐藏加载动画
			}
		});*/
		obj.myChart.showLoading();
		$cm({
			ClassName:'DHCHAI.STATV2.S050MRBPos',
			QueryName:'QryMRBPos',
			aHospIDs:aHospID,
			aDateFrom:aDateFrom,
			aDateTo:aDateTo,
			aLocType:aLocType,
			aQryCon:aQrycon,
			aStatDimens:aStatDimens,
			aLocIDs:aLocIDs,
			page:1,
			rows:999
		},function(rs){
			obj.myChart.hideLoading();    //隐藏加载动画
			obj.echartLocInfRatio(rs);
		})
	}
	
}