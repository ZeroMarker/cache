﻿function InitS800cssposinf1WinEvent(obj){
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
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S800CssPosInf1.raq&aSurNumID='+SurNumID +'&aInfType='+"0";
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		} 
		
	}
    obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) return;
		var arrCount	= new Array();
		var arrPosDesc	= new Array();
		arrRecord 		= runQuery.record;
		
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrCount.push(rd["InfDiagCount"]);
			arrPosDesc.push(rd["PosDesc"]);
		}
	   var arrInfPosDesc= new Array();     //定义一个临时数组 
       for(var i = 0; i < arrPosDesc.length; i++){    //循环遍历当前数组 
           //判断当前数组下标为i的元素是否已经保存到临时数组 
           //如果已保存，则跳过，否则将此元素保存到临时数组中 
           if(arrInfPosDesc.indexOf(arrPosDesc[i]) == -1){ 
               arrInfPosDesc.push(arrPosDesc[i]); 
           } 
       } 
       var arrnum =new Array(arrInfPosDesc.length);
       for(var index = 0;index < arrnum.length;index++){
	       arrnum[index] = 0;
	     }
		for(var i = 0; i < arrInfPosDesc.length; i++){
			for(var j = 0; j < arrPosDesc.length; j++){
				if(arrPosDesc[j]==arrInfPosDesc[i]){
					arrnum[i]=Number(arrnum[i])+Number(arrCount[j]);	
				} 
			}
		}
		var option = {
			    title : {
			        text: '全院社区感染部位例次占比统计图',
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
			        data:arrInfPosDesc
			    },
			    series : [
			        {
			            name: '感染部位',
			            type: 'pie',
			            radius : '60%',
			            center: ['50%', '50%'],
			            data: (function(){
				            var arrNum=[];
				        	for (var i = 0; i < arrInfPosDesc.length; i++) {	
 								arrNum.push({"value": arrnum[i],"name":arrInfPosDesc[i]});
							}
							return arrNum;  
				        })(),
			      		
			        }
			    ]
			};
		// 使用刚指定的配置项和数据显示图表。
		obj.myChart.setOption(option,true);
	}
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear()
		var SurNumID 	= $('#cboSurNum').combobox('getValue');	
		var dataInput = "ClassName=" + 'DHCHAI.STATV2.S450CSSPosBac' + "&QueryName=" + 'QryCSSBacInfPos' + "&Arg1=" + SurNumID + "&Arg2=" + "0" + "&ArgCnt=" + 2;

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
				var tkclass="DHCHAI.STATV2.S450CSSPosBac";
				var tkQuery="QryCSSBacInfPos";
				alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
				obj.myChart.hideLoading();    //隐藏加载动画
			}
		});
	}
	
}