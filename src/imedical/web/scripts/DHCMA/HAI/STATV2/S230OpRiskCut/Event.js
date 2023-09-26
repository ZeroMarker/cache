function InitS390InfPosfWinEvent(obj){
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
		var Qrycon = $('#aQryCon').combobox('getText');
		ReportFrame = document.getElementById("ReportFrame");
		if(Qrycon==""){
			$.messager.alert("提示","请选择筛选条件！", 'info');
			return;	
		}
		if(DateFrom > DateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((DateFrom=="")||(DateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		var objDic = $cm({                  
					ClassName:"DHCHAI.BT.Dictionary",
					MethodName:"GetObjByDesc",
					aTypeCode:"StatScreenCondition",
					aDesc:Qrycon
				},
		false);	
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S230OpRiskCut.raq&aHospIDs='+aHospID +'&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aStaType='+ Statunit +'&aQryCon='+ objDic.BTCode;	
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}		
	}
   	obj.ShowEChaert1 = function(arrViewLoc,arrInfRatio){
		obj.myChart.clear();
		option1 = {
			 title : {
				text: '不同感染风险指数（手术切口）手术部位感染例数统计表',
				textStyle:{
						fontSize:20
					},
				x:'center',
				y:'top'
			},
		    tooltip: {
				trigger: 'axis',
			},
		    legend: {
		        orient: 'vertical',
		        x: 'left',
		        y:50,
		        data:[]
		    },
		    series: [
		        {
		            //name:'感染诊断',
		            type:'pie',
		            radius: ['0%', '60%'],
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
		            data:[]
		        }
		    ]
		};
		// 使用刚指定的配置项和数据显示图表
		obj.myChart.setOption(option1,true);
		
		 //当月科室感染率图表
		var HospID = $('#cboHospital').combobox('getValue');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var StaType = Common_CheckboxValue('chkStatunit');
		var Qrycon = $('#aQryCon').combobox('getValue');
		var dataInput = "ClassName=" + 'DHCHAI.STATV2.S230OpRiskCut' + "&QueryName=" + 'QryOpRiskCut' + "&Arg1=" + HospID + "&Arg2=" + DateFrom + "&Arg3=" + DateTo+ "&Arg4=" + StaType+"&ArgCnt=" + 4;
		$.ajax({
			url: "./dhchai.query.csp",
			type: "post",
			timeout: 120000, //60秒超时
			async: true,   //异步
			beforeSend:function(){
				obj.myChart.showLoading();	
			},
			data: dataInput,
			success: function(data, textStatus){
				obj.myChart.hideLoading();    //隐藏加载动画
				//console.log(data);
				if(data=='{record:[],total : 0}'){
					$('#EchartDiv').addClass('no-result');
				}
				var retval = (new Function("return " + data))();
				obj.echartLocInfRatio(retval);
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
				obj.myChart.hideLoading();    //隐藏加载动画
			}
		});
		
	   obj.echartLocInfRatio = function(runQuery){
			if (!runQuery) return;
			var arrViewLoc = new Array();
			var arrInfRatio = new Array();
			var arrInfDiag = new Array();
			var arrInfCount = new Array();
			obj.arrLocG= new Array();
			var arrRecord = runQuery.record;

			for (var indRd = 0; indRd < arrRecord.length; indRd++){
				var rd = arrRecord[indRd];
				//去掉全院、医院、科室组
				if ((rd["DimensKey"].indexOf('-A-')<0)) {
					delete arrRecord[indRd];
					continue;
				}
			}
			for (var indRd = 0; indRd < arrRecord.length; indRd++){                     
				var rd = arrRecord[indRd];
				if(rd==undefined){   //去掉全院、医院、科室组后,会有数据变为undefined
					continue;
				}else{
					arrViewLoc.push(rd["OperIncInf0Count"]);
					arrViewLoc.push(rd["OperIncInf1Count"]);
					arrViewLoc.push(rd["OperIncInf2Count"]);
					arrViewLoc.push(rd["OperIncInf3Count"]);
					arrViewLoc.push(rd["OperIncInf4Count"]);
					arrInfRatio.push("无");
					arrInfRatio.push("Ⅰ类");
					arrInfRatio.push("Ⅱ类");
					arrInfRatio.push("Ⅲ类");
					arrInfRatio.push("Ⅳ类");
				}
			}
			console.log(arrViewLoc)
			console.log(arrInfRatio)
			// 装载数据
			obj.myChart.setOption(
				{
					legend: {
						data: arrInfRatio
					},
					series: [{
						data:(function(){
				            var arrNum=[];
				        	for (var i = 0; i < arrViewLoc.length; i++) {	
 								arrNum.push({"value": arrViewLoc[i],"name":arrInfRatio[i]});
							}
							return arrNum;  
				        })()
					}]
				}
			);
			
		}
	}
}
