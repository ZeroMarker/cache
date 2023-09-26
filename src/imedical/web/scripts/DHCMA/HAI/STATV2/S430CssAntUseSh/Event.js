function InitS430CssAntUseShWinEvent(obj){
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
		var aHospID 	= $('#cboHospital').combobox('getValue');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aStaType 	= Common_CheckboxValue('chkStatunit');
	
		ReportFrame = document.getElementById("ReportFrame");
	
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S430CssAntUseSh.raq&aHospIDs='+aHospID +'&aDateFrom='+aDateFrom+'&aDateTo='+aDateTo+'&aStaType='+aStaType;	
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		} 
		
	}
    obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) return;
		arrRecord 		= runQuery.record;
		
		for (var indRd = 0; indRd < 1; indRd++){
			var rd = arrRecord[indRd];
			if (rd["DimensKey"].indexOf('-A-')>-1){
				var HospAntUseZL 	= rd["AntiZLCount"];		//治疗用药人数
				var HospAntUseYF 	= rd["AntiYFCount"];		//预防用药人数
				var HospAntUseZLYF 	= rd["AntiZLYFCount"];		//治疗+预防用药人数
				var HospAntUseWZZ 	= rd["AntiWZZCount"];		//无指征用药人数
				var HospAntUseQT 	= rd["AntiQTCount"];		//其他用药人数
				var HospAntUseDL	= rd["AntiDALCount"];		//单联人数
				var HospAntUseEL	= rd["AntiERLCount"];		//二联人数
				var HospAntUseSL	= rd["AntiSALCount"];		//三联人数
				var HospAntUseESIL	= rd["AntiSILCount"];		//四联人数
				var HospAntUseSLYS	= rd["AntiWULCount"];		//四联以上人数
				break; 
			}	
		}
		option = {
		    title : {
		        text: '全院抗菌药物使用情况汇总表',
		        textStyle:{
					fontSize:28
				},
		        x:'center'
		    },
		    tooltip : {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    legend: {
		        orient: 'vertical',
		        left: 'left',
		        data: ['治疗用药人数','预防用药人数','治疗+预防用药人数','无指征用药人数','其他用药人数','单联人数','二联人数','三联人数','四联人数','四联以上人数']
		    },
		    series : [
		        {
		            name: '全院抗菌药物使用情况',
		            type: 'pie',
		            radius : '50%',
		            center: ['25%', '50%'],
		            data:[
		                {value:HospAntUseZL, name:'治疗用药人数'},
		                {value:HospAntUseYF, name:'预防用药人数'},
		                {value:HospAntUseZLYF, name:'治疗+预防用药人数'},
		                {value:HospAntUseWZZ, name:'无指征用药人数'},
		                {value:HospAntUseQT, name:'其他用药人数'}
		            ]
		        },{
			        name: '全院抗菌药物使用情况',
		            type: 'pie',
		            radius : '50%',
		            center: ['75%', '50%'],
		            data:[
		                {value:HospAntUseDL, name:'单联人数'},
		                {value:HospAntUseEL, name:'二联人数'},
		                {value:HospAntUseSL, name:'三联人数'},
		                {value:HospAntUseESIL, name:'四联人数'},
		                {value:HospAntUseSLYS, name:'四联以上人数'}
		            ]
		        },
		    ]
		};
		// 使用刚指定的配置项和数据显示图表。
		obj.myChart.setOption(option,true);
	}
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear()
		var aHospID 	= $('#cboHospital').combobox('getValue');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aStaType 	= Common_CheckboxValue('chkStatunit');
		var dataInput = "ClassName=" + 'DHCHAI.STATV2.S430SHCssAntUse' + "&QueryName=" + 'CssQryAntUse' + "&Arg1=" + aHospID + "&Arg2=" + aDateFrom + "&Arg3=" + aDateTo +"&Arg4=" + aStaType +"&ArgCnt=" + 4;

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
				var tkclass="DHCHAI.STATV2.S430SHCssAntUse";
				var tkQuery="CssQryAntUse";
				alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
				obj.myChart.hideLoading();    //隐藏加载动画
			}
		});
	}
	
}