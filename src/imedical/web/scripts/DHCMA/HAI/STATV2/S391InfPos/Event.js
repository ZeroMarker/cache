﻿function InitS390InfPosfWinEvent(obj){
	obj.numbers = "ALL";
   	obj.LoadEvent = function(args){ 
		$('#ReportFrame').css('display', 'block');
   	    setTimeout(function () {
   	        obj.LoadRep();
   	    }, 50);

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
		var aHospID = $('#cboHospital').combobox('getValue');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var Statunit = Common_CheckboxValue('chkStatunit');
		ReportFrame = document.getElementById("ReportFrame");
		if(DateFrom > DateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((DateFrom=="")||(DateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S391InfPos.raq&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aHospIDs='+aHospID +'&aStaType='+ Statunit;
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}	
	}
		
	obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) return;
		var arrInfDiagDesc = new Array();	//感染部位
		var arrInfDiagCnt  = new Array();   //感染部位例数
		var arrPosDesc	   = new Array();	//感染部位
		arrRecord 		= runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			if ((rd["DimensKey"].indexOf('-A-')>-1)) {
				arrInfDiagDesc.push(rd["InfDiagDesc"]);
				arrInfDiagCnt.push(rd["InfDiagCnt"]);
				arrPosDesc.push(rd["PosDesc"]);
			}
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
					arrnum[i]=Number(arrnum[i])+Number(arrInfDiagCnt[j]);	
				} 
			}
		}
		var arrDiagDesc = new Array();
		var arrDiagCnt = new Array();
		for(var i = 0; i < arrInfPosDesc.length; i++){
			for(var j = 0; j < arrPosDesc.length; j++){
				if(arrInfPosDesc[i]==arrPosDesc[j]){
					arrDiagDesc.push(arrInfDiagDesc[j]);
					arrDiagCnt.push(arrInfDiagCnt[j]);
				}
			}
			
		}
		var arrLegend = arrInfDiagDesc;
		arrLegend=arrInfDiagDesc.concat(arrPosDesc);
		option = {
			title : {
			        text: '出院患者医院感染部位分布图',
			        textStyle:{
						fontSize:28
					},
			        x:'center'
			},
		    tooltip: {
		        trigger: 'item',
		        formatter: '{a} <br/>{b}: {c} ({d}%)'
		    },
		    legend: {
		        orient: 'vertical',
		        left: 10,
		        data: arrLegend
		    },
		    series: [
		        {
		            name: '感染部位',
		            type: 'pie',
		            selectedMode: 'single',
		            radius: [0, '45%'],

		            label: {
		                position: 'inner'
		            },
		            labelLine: {
		                show: false
		            },
		            data:(function(){
				            var arrNum1=[];
				        	for (var i = 0; i < arrInfPosDesc.length; i++) {	
 								arrNum1.push({"value": arrnum[i],"name":arrInfPosDesc[i]});
							}
							return arrNum1;  
				        })(),
		        },
		        {
		            name: '感染诊断',
		            type: 'pie',
		            radius: ['60%', '75%'],
		            label: {
		                normal: {
		                    formatter: '{hr|}\n  {b|{b}：}{c}  {per|{d}%}  ',
		                    backgroundColor: '#eee',
		                    borderColor: '#aaa',
		                    borderWidth: 1,
		                    borderRadius: 4,
		                    rich: {
			                    
		                        a: {
		                            color: '#999',
		                            lineHeight: 22,
		                            align: 'center'
		                        },
		                        
		                        hr: {
		                            borderColor: '#aaa',
		                            width: '100%',
		                            borderWidth: 0.5,
		                            height: 0
		                        },
		                        b: {
		                            fontSize: 16,
		                            lineHeight: 33
		                        },
		                        
		                        per: {
		                            color: '#eee',
		                            backgroundColor: '#334455',
		                            padding: [2, 4],
		                            borderRadius: 2
		                        }
		                    }
		                }
		            },
		            data: (function(){
				            var arr=[];
				        	for (var i = 0; i < arrInfDiagDesc.length; i++) {	
 								arr.push({"value": arrDiagCnt[i],"name":arrDiagDesc[i]});
							}
							return arr;  
				        })(),
		        }
		    ]
		};
		// 使用刚指定的配置项和数据显示图表。
		obj.myChart.setOption(option,true);
	}
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear()
		var HospID = $('#cboHospital').combobox('getValue');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var StaType = Common_CheckboxValue('chkStatunit');
		var dataInput = "ClassName=" + 'DHCHAI.STATV2.S391InfPos' + "&QueryName=" + 'QryInfPosCSS' + "&Arg1=" + DateFrom + "&Arg2=" + DateTo+  "&Arg3=" + HospID +"&Arg4=" +StaType+"&ArgCnt=" + 4;

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
				if(data=='{record:[],total : 0}'){
					$('#EchartDiv').addClass('no-result');
				}
				var retval = (new Function("return " + data))();
				obj.echartLocInfRatio(retval);
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				var tkclass="DHCHAI.STATV2.S391InfPos";
				var tkQuery="QryInfPosCSS";
				alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
				obj.myChart.hideLoading();    //隐藏加载动画
			}
		});
	}
}
