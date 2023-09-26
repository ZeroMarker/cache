function InitS440CssOpInfoShWinEvent(obj){
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
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S440CssOpInfoSh.raq&aHospIDs='+aHospID +'&aDateFrom='+aDateFrom+'&aDateTo='+aDateTo+'&aStaType='+aStaType;
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		} 
	}	
    obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) return;
		arrRecord 		= runQuery.record;
		var arrlength		= 0;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			//去掉全院、医院、科室组
			if (rd["DimensKey"].indexOf('-A-')>-1){
				var Oper1Count 	= rd["Oper1Count"];		
				var Oper2Count 	= rd["Oper2Count"];		
				var Oper3Count 	= rd["Oper3Count"];		
				var Oper4Count 	= rd["Oper4Count"];		
				var Oper5Count 	= rd["Oper5Count"];	
				break	
			}	
		}
		option = {
		    title : {
		        text: '全院手术人数情况汇总表',
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
		        data: ['Ⅰ类切口','Ⅱ类切口','Ⅲ类切口','Ⅳ类切口','其他']
		    },
		    series : [
		        {
		            name: '全院抗菌药物使用情况',
		            type: 'pie',
		            radius : '60%',
		            center: ['50%', '50%'],
		            data:[
		                {value:Oper1Count, name:'Ⅰ类切口'},
		                {value:Oper2Count, name:'Ⅱ类切口'},
		                {value:Oper3Count, name:'Ⅲ类切口'},
		                {value:Oper4Count, name:'Ⅳ类切口'},
		                {value:Oper5Count, name:'其他'}
		            ]
		        }
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
		var dataInput = "ClassName=" + 'DHCHAI.STATV2.S440SHCssOpInfo' + "&QueryName=" + 'CssQryOpInfo' + "&Arg1=" + aHospID + "&Arg2=" + aDateFrom + "&Arg3=" + aDateTo +"&Arg4=" + aStaType +"&ArgCnt=" + 4;

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
				var tkclass="DHCHAI.STATV2.S440SHCssOpInfo";
				var tkQuery="CssQryOpInfo";
				alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
				obj.myChart.hideLoading();    //隐藏加载动画
			}
		});
	}
	
}