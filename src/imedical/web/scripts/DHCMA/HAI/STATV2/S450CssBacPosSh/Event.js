function Inits450cssbacposshWinEvent(obj){
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
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S450CssBacPosSh.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aStaType='+aStaType+'&aInfType='+1;	
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		} 	
	}
	
    obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) return;
		var arrDesc		= new Array();		//感染部位
		var arrCount	= new Array();		//感染例数
		var arrBac		= new Array();		//病原体
		var arrInfDiagCount = new Array();		//感染部位例数
		var arrInfDiagDesc	= new Array();		//感染部位
		var arrBacName		= new Array();		//病原体
		arrRecord 		= runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrDesc.push(rd["InfDiagDesc"]);
			arrCount.push(rd["InfDiagCount"]);
			arrBac.push(rd["BacName"]);
			
		}
		var Count = 0;
		var BacName = "";
		var len = arrDesc.length;
		for(var i = 0; i < len; i++){	
			var Flag1 = 1;
			for(var x=0;x<arrInfDiagDesc.length;x++){
				if(arrDesc[i]==arrInfDiagDesc[x]){
					Flag1 = 0
					break;
				}
			}
			if(Flag1==0){
				continue;
			}else{
				arrInfDiagDesc.push(arrDesc[i]);
				Count=Number(arrCount[i]);
				BacName=arrBac[i];
				for(var j = i+1; j < len; j++){
					if(arrDesc[j]==arrInfDiagDesc[arrInfDiagDesc.length-1]){
						Count = Count+Number(arrCount[j]);
						BacName = BacName+"^"+arrBac[j];
					}
				}
				arrInfDiagCount.push(Count);
				arrBacName.push(BacName);
				count = 0;
				BacName = "";		
			}
		}
		var arrName = new Array();
		for(var i = 0; i < len; i++){	
			var Flag1 = 1;
			for(var x=0;x<arrName.length;x++){
				if(arrBac[i]==arrName[x]){
					Flag1 = 0
					break;
				}
			}
			if(Flag1==0){
				continue;
			}else{
				arrName.push(arrBac[i]);
			}
		}
		var maxNumber=arrCount[0];
		for(var i=1;i<arrCount.length;i++){
			if(arrCount[i]>maxNumber){
				maxNumber=arrCount[i]
			}
			
		}
		var schema = [
			    {name: 'BacName', index: 1, text: '病原体'},
			    {name: 'Count', index: 2, text: '感染数量'}
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
		option = {
			title : {
			        text: '医院感染病原体感染部位分布',
			        textStyle:{
						fontSize:28
					},
			        x:'center'
			    },
			grid:{
				left:'2%',
				top:'11%',	
				right:'5%',
				bottom:'5%',
				containLabel:true
			},
		    backgroundColor: '#87CEFA',
		    color: [
		        '#FF6347'
		    ],
		    dataZoom:[{
				fillerColor:"rgba(255,255,255,255)",
				borderColor:"#FFF",
				show:true,
				realtime:true,    
			    end:(6/arrInfDiagDesc.length)*100,
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
		                + schema[1].text + '：' + value[2] + '<br>';
		        }
		    },
		    xAxis: {
		        type: 'category',
		        name: '感染部位',
		        data:arrInfDiagDesc,
		        nameTextStyle: {
		            color: '#000000',
		            fontSize: 14
		        },
		        splitLine: {
		            show: false
		        },
		        axisLine: {
		            lineStyle: {
		                color: '#000000'
		            }
		        }
		    },
		    yAxis: {
		        type: 'category',
		        name: '病原体',
		        data:arrName,
		        nameTextStyle: {
		            color: '#000000',
		            fontSize: 14
		        },
		        axisLine: {
		            lineStyle: {
		                color: '#000000'
		            }
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
		            max: maxNumber,
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
		                color: ['rgba(255,255,255,.2)']
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
			            name: '感染部位',
			           	type: 'scatter',
		            	itemStyle: itemStyle,
			            data: (function(){
				            var arrNum=[];
				        	for (var i = 0; i < arrDesc.length; i++) {	
 								arrNum.push([arrDesc[i],arrBac[i],arrCount[i]]);
							}
							return arrNum;  
				        })(),
			      		
			        }
		    ]
		};
		obj.myChart.setOption(option,true);
	}
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear()
		var aHospID 	= $('#cboHospital').combobox('getValue');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aStaType 	= Common_CheckboxValue('chkStatunit');		
		var dataInput = "ClassName=" + 'DHCHAI.STATV2.S450SHCSSPosBac' + "&QueryName=" + 'QryCSSBacInfPos' + "&Arg1=" + aHospID + "&Arg2=" + aDateFrom + "&Arg3=" + aDateTo +"&Arg4="+aStaType+"&Arg5="+1+"&ArgCnt=" + 5;
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
				var tkclass="DHCHAI.STATV2.S450SHCSSPosBac";
				var tkQuery="QryCSSBacInfPos";
				alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
				obj.myChart.hideLoading();    //隐藏加载动画
			}
		});
	}
	
}