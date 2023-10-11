function InitS420cssposinfWinEvent(obj){
	
   	obj.LoadEvent = function(args){
		
		$('#ReportFrame').css('display', 'block');
		setTimeout(function(){
			obj.LoadRep();
		},50);
		//表的点击事件
		$('#btnSearchTable').on('click',function(e,value){
			$('#ReportFrame').css('display', 'block');
			$('#EchartDiv').css('display', 'none');
			obj.LoadRep();
		});
		
		//图的点击事件
		$('#btnSearchChart').on('click',function(e,value){
			$('#EchartDiv').css('display', 'block');
			$('#ReportFrame').css('display', 'none');
			obj.myChart = echarts.init(document.getElementById('EchartDiv'),'theme');
			obj.ShowEChaert1();
		});
		
   	}
	
   	obj.LoadRep = function(){
		var SurNumID 	= $('#cboSurNum').combobox('getValue');	
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs = $('#cboLoc').combobox('getValues').join(',');	
		// var aQryCon= $('#cboQryCon').combobox('getValue');
		ReportFrame = document.getElementById("ReportFrame");
		p_URL = Append_Url('dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S420CssPosInf.raq&aSurNumID='+SurNumID +'&aStaType='+aLocType+'&aInfType='+"1");	//+'&aQryCon='+aQryCon
		if(!ReportFrame.src){
			ReportFrame.frameElement.src = p_URL ;
		}else{
			ReportFrame.src = p_URL;
		} 
		
	}
     obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) return;

		var arrRecord = runQuery.rows;
		RemoveArr(arrRecord);
		 arrRecord = arrRecord.sort(function(x, y) {
			return parseInt(y.InfDiagCnt) - parseInt(x.InfDiagCnt)
		});
		 objPos = {}; objDiag = {};mapDOP={}
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			
			var PosDesc = $.trim(rd["PosDesc"]); 
			var InfDiagDesc = $.trim(rd["InfDiagDesc"]); 
			if (InfDiagDesc == ""){ 
				continue;
			}
			var InfDiagCnt = parseInt(rd["InfDiagCnt"]);
			if (typeof objDiag[InfDiagDesc] == "undefined"){
				objDiag[InfDiagDesc] = InfDiagCnt
			}else{
				objDiag[InfDiagDesc] = objDiag[InfDiagDesc]+InfDiagCnt
			}
			if (typeof objPos[PosDesc] == "undefined") {
				objPos[PosDesc] = InfDiagCnt
			} else {
				objPos[PosDesc] = objPos[PosDesc] + InfDiagCnt
			}
			mapDOP[InfDiagDesc] = PosDesc  
		}
	   
		 var arrLegend=new Array();
		 var arrInfPosDesc = new Array();
		 var arrnum = new Array();
		 var arrDiagDesc = new Array();
		 var arrDiagCnt = new Array();
		 Object.getOwnPropertyNames(objDiag).forEach(function (key) { 
			 arrLegend.push(key);
		 })
		 Object.getOwnPropertyNames(objPos).forEach(function (key) {
			 arrLegend.push(key);
			 arrInfPosDesc.push(key);
			 arrnum.push(objPos[key]);
			 for (var diag in mapDOP){
				 if (mapDOP[diag] == key){
					 arrDiagDesc.push(diag)
					 arrDiagCnt.push(objDiag[diag])
				 }
			 }
		 })
		option = {
			title : {
			        text: '医院感染科室部位情况统计图',
			        textStyle:{
						fontSize:28
					},
			        x:'center'
			},
		    tooltip: {
		        trigger: 'item',
		        formatter: '{a} <br/>{b}: {c} ({d}%)'
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
						for (var i = 0; i < arrDiagDesc.length; i++) {	
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
		var SurNumID 	= $('#cboSurNum').combobox('getValue');	
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		// var aQryCon= $('#cboQryCon').combobox('getValue');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs = $('#cboLoc').combobox('getValues').join(',');	
		
		obj.myChart.showLoading();	
		var className="DHCHAI.STATV2.S420CssPosInf";
		var queryName="QryInfPosCSS";
		$cm({
		    ClassName: className,
		    QueryName: queryName,
		    aSurNumID: SurNumID,
		    aStaType: aLocType,
			aInfType:1,
			aStatDimens:aStatDimens,
            aLocIDs:aLocIDs,
			page:1,    //可选项，页码，默认1
			rows:999   //可选项，获取多少条数据，默认50
		},
		function(data){
			obj.myChart.hideLoading();    //隐藏加载动画
			obj.echartLocInfRatio(data);
		}
		,function(XMLHttpRequest, textStatus, errorThrown){
			alert("类" + className + ":" + queryName+ "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
			obj.myChart.hideLoading();    //隐藏加载动画
		}); 
		
	}
   
}