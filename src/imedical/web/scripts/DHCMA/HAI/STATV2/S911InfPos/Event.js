function InitS911InfPosfWinEvent(obj){
	obj.numbers = "ALL";
   	obj.LoadEvent = function(args){ 
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
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S911InfPos.raq&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aHospIDs='+aHospID +'&aStaType='+ Statunit;
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}	
	}
		
	obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) return;
		var arrInfDiagDesc 	= new Array();	//感染诊断
		var arrInfDiagCnt  	= new Array();  //感染诊断例数
		var arrPosDesc		= new Array();	//感染部位(临时)
		var arrInfPosDesc	= new Array();	//感染部位
		var arrInfPosCnt  	= new Array();  //感染部位例数
		arrRecord 		= runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			if ((rd["DimensKey"].indexOf('-A-')>-1)) {
			    arrInfDiagDesc.push(rd["InfPosDesc"]);		//加载诊断
				arrInfDiagCnt.push(rd["InfDiagCnt"]);		//加载诊断数据
				arrPosDesc.push(rd["InfDiagDesc"]);				//加载感染部位-临时
				
				var IsRespect=0;		//是否重复
				for(var indPos = 0; indPos < arrInfPosDesc.length; indPos++){
				    if (rd["InfDiagDesc"] == arrInfPosDesc[indPos]) {		//感染部位重复
						IsRespect=1;
						arrInfPosCnt[indPos]=parseInt(rd["InfDiagCnt"])+parseInt(arrInfPosCnt[indPos]);
						//感染诊断按感染部位重组
						var x = rd["InfPosDesc"];
						var y=rd["InfDiagCnt"];
						for(var i=indRd;i>0;i--){
							arrInfDiagDesc[i]=arrInfDiagDesc[i-1];
							arrInfDiagCnt[i]=arrInfDiagCnt[i-1];
							if (rd["InfDiagDesc"] == arrPosDesc[i]) {
								arrInfDiagDesc[i-1]=x;
								arrInfDiagCnt[i-1]=y;
								break;
							}
						}
						break;
					}
				}
				if(IsRespect!=1){
				    arrInfPosDesc.push(rd["InfDiagDesc"]);
					arrInfPosCnt.push(rd["InfDiagCnt"]);
				}
			}
		}
		var arrLegend = arrInfPosDesc;
		arrLegend=arrInfPosDesc.concat(arrInfDiagDesc);
		option = {
			title : {
			        text: '出院患者社区感染部位分布图',
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
		            name: '感染诊断',
		            type: 'pie',
		            selectedMode: 'single',
		            radius: [0, '45%'],

		             label: {
		                position: 'inner'
		            },
		            labelLine: {
		                show: false
		            },
		            data: (function(){
				            var arr=[];
				        	for (var i = 0; i < arrInfDiagDesc.length; i++) {	
 								arr.push({"value": arrInfDiagCnt[i],"name":arrInfDiagDesc[i]});
							}
							return arr;  
				        })(),
		        },
		        {
		            name: '感染部位',
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
		            data:(function(){
				        var arrNum1=[];
				       	for (var i = 0; i < arrInfPosDesc.length; i++) {	
 							arrNum1.push({"value": arrInfPosCnt[i],"name":arrInfPosDesc[i]});
						}
						return arrNum1;  
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
		var dataInput = "ClassName=" + 'DHCHAI.STATV2.S911InfPos' + "&QueryName=" + 'QryInfPosCSS' + "&Arg1=" + DateFrom + "&Arg2=" + DateTo+  "&Arg3=" + HospID +"&Arg4=" +StaType+"&ArgCnt=" + 4;

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
				var tkclass="DHCHAI.STATV2.S911InfPos";
				var tkQuery="QryInfPosCSS";
				alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
				obj.myChart.hideLoading();    //隐藏加载动画
			}
		});
	}
}
