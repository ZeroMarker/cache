function InitS021DayInfWinEvent(obj){
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
	obj.up=function(x,y){
        return y.PICCAdmNum-x.PICCAdmNum
    }
   	obj.LoadRep = function(){
		var aHospID = $('#cboHospital').combobox('getValue');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var Statunit = Common_CheckboxValue('chkStatunit');
		var Qrycon = $('#aQryCon').combobox('getValue');
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
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S350BWPICCInf.raq&aHospIDs='+aHospID +'&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aLocType='+ Statunit +'&aQryCon='+Qrycon;	
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}	
	}
	obj.option1 = function(arrViewLoc,arrCatDesc,arrLoc,arrWtCatDesc,arrPICCAdmNum,arrAPICCRatio){
		var schema = [
		    {name: 'CatDesc', index: 1, text: '体重分组'},
		    {name: 'ViewLoc', index: 2, text: '科室(病区)'},
		    {name: 'PICCAdmNum', index: 3, text: '感染例次数'}
		];
		var itemStyle = {
		    normal: {
		        opacity: 0.8,
		        shadowBlur: 10,
		        shadowOffsetX: 0,
		        shadowOffsetY: 0,
		        shadowColor: 'rgba(0, 0, 0, 0.5)'
		    }
		};	
		var option = {
			title : {
			        text: '出生体重分组新生儿中央血管导管相关血流感染发病率统计图',
			        textStyle:{
						fontSize:28
					},
			        x:'center'
			    },
			grid:{
				left:'2%',
				top:'11%',	
				right:'8%',
				bottom:'6%',
				containLabel:true
			},
		    //backgroundColor: '#FFFFFF',
		    dataZoom:[{
			    height: 30,
				show:true,
				realtime:true,    
			    end:(6/arrViewLoc.length)*100,
			    zoomLock:true
			}],
		    tooltip: {
		        padding: 10,
		        backgroundColor: '#222',
		        borderColor: '#777',
		        borderWidth: 1,
		        formatter: function (obj) {
		            var value = obj.value;
		            return '<div style="border-bottom: 1px solid rgba(255,255,255,.3); font-size: 18px;padding-bottom: 7px;margin-bottom: 7px">'
		                + obj.seriesName + ' : ' + value[0] + ''
		                + '</div>'
		                + schema[0].text + '：' + value[1] + '<br>'
		                + schema[1].text + '：' + value[2] + '<br>'
		                + schema[2].text + '：' + value[3] + '<br>';
		        }
		    },
		    xAxis: {
		        type: 'category',
		        name: '科室(病区)',
		        data:arrViewLoc,
		        nameTextStyle: {
		            fontSize: 14
		        },
		        splitLine: {
		            show: false
		        },
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
		    },
		    yAxis: {
		        type: 'category',
		        name: '体重分组',
		        data:arrCatDesc,
		        nameTextStyle: {
		            fontSize: 14
		        },
		        splitLine: {
		            show: false
		        }
		    },
		    visualMap: [
		        {
		            left: 'right',
		            top: '10%',
		            dimension: 2,
		            min: 0,
		            max: Math.ceil(arrPICCAdmNum[0]),
		            itemWidth: 30,
		            itemHeight: 120,
		            calculable: true,
		            precision: 0.1,
		            text: ['圆形大小：数量'],
		            textGap: 30,
		            textStyle: {
		                color: '#000000'
		            },
		            inRange: {
		                symbolSize: [10, 70]
		            },
		            outOfRange: {
		                symbolSize: [10, 70],
		                color: ['rgba(255,255,255,0.2)']
		            },
		            controller: {
		                inRange: {
		                    color: ['#c23531']
		                },
		                outOfRange: {
		                    color: ['#444']
		                }
		            }
		        }
		    ],
		    series: [	 
		        {
		            name: '感染发病率',
		           	type: 'scatter',
	            	itemStyle: itemStyle,
		            data: (function(){
			            var arrNum=[];
			        	for (var i = 0; i < arrWtCatDesc.length; i++) {	
							arrNum.push([arrAPICCRatio[i],arrWtCatDesc[i],arrLoc[i],arrPICCAdmNum[i]]);
						}
						return arrNum;
			        })(),
		        }
	    	]
		};
		return 	option;
		
	}
	obj.ShowEChaert1 = function(){
		obj.myChart.clear();
		 //当月科室感染率图表
		var HospID = $('#cboHospital').combobox('getValue');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var StaType = Common_CheckboxValue('chkStatunit');
		var Qrycon = $('#aQryCon').combobox('getValue');
		var dataInput = "ClassName=" + 'DHCHAI.STATV2.S350BWPICCInf' + "&QueryName=" + 'QrySDayInf' + "&Arg1=" + HospID + "&Arg2=" + DateFrom + "&Arg3=" + DateTo+ "&Arg4=" + StaType+"&Arg5=" + Qrycon+"&ArgCnt=" + 5;
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
				}else{
					var retval = (new Function("return " + data))();
					obj.echartLocInfRatio(retval);	
				}	
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
				obj.myChart.hideLoading();    //隐藏加载动画
			}
		});
		
	   obj.echartLocInfRatio = function(runQuery){
			if (!runQuery) return;
			var arrLoc 		= new Array();
			var arrPICCAdmNum 	= new Array();
			var arrWtCatDesc 	= new Array();
			var arrAPICCRatio	= new Array();
			var arrRecord = runQuery.record;
			
			arrRecord = arrRecord.sort(obj.up);
			for (var indRd = 0; indRd < arrRecord.length; indRd++){
				var rd = arrRecord[indRd];
				rd["DimensDesc"] = $.trim(rd["DimensDesc"]); //去掉空格
				rd["WtCatDesc"] = $.trim(rd["WtCatDesc"]); //去掉空格
				rd["APICCRatio"] = parseFloat(rd["APICCRatio"].replace('%','').replace('‰','')).toFixed(2);
				
				arrLoc.push(rd["DimensDesc"]);
				arrWtCatDesc.push(rd["WtCatDesc"]);
				arrPICCAdmNum.push(rd["PICCAdmNum"]);
				arrAPICCRatio.push(parseFloat(rd["APICCRatio"]).toFixed(2));
			}

			var arrCatDesc = [];
			var arrViewLoc = [];
		    for (var i = 0; i < arrWtCatDesc.length; i++) {
		        if (arrCatDesc.indexOf(arrWtCatDesc[i]) === -1) {
		            arrCatDesc.push(arrWtCatDesc[i])
		        }
		         if (arrViewLoc.indexOf(arrLoc[i]) === -1) {
		            arrViewLoc.push(arrLoc[i])
		        }
		    }
		obj.myChart.setOption(obj.option1(arrViewLoc,arrCatDesc,arrLoc,arrWtCatDesc,arrPICCAdmNum,arrAPICCRatio),true);
		}
	}		
}
   	
