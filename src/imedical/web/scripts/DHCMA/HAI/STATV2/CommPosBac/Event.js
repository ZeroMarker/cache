function InitCPosBacInfPreWinEvent(obj){
	obj.numbers = "ALL";
   	obj.LoadEvent = function(args){
		$('#ReportFrame').css('display', 'block');
   	    setTimeout(function () {
   	        obj.LoadRep();
   	    }, 50);

		//图的点击事件
		$('#btnSearchChart').on('click',function(e,value){
			$('#EchartDiv').css('display', 'block');
			$('#EchartDiv1').css('display', 'block');
			$('#ReportFrame').css('display', 'none');
			obj.myChart = echarts.init(document.getElementById('EchartDiv'), 'theme');
			obj.myChart1 = echarts.init(document.getElementById('EchartDiv1'), 'theme');
			obj.ShowEchart();
			obj.ShowEchart1();
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
		var aDateFrom = $('#dtDateFrom').datebox('getValue');
		var aDateTo= aDateFrom;
	
		ReportFrame = document.getElementById("ReportFrame");
	
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S450SHCSSPosBac.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aStaType='+"E"+'&aInfType=0';
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		} 
		
	}
 obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) return;
		var arrInfDiagDesc = new Array();	//感染部位	arrInfDiagDesc
		var arrInfDiagCnt  = new Array();   //感染部位数	arrInfDiagCnt
		var arrPosDesc		= new Array();	//部位分类(临时)
		var arrInfPosDesc	= new Array();	//部位分类	arrInfPosDesc
		var arrInfPosCnt  	= new Array();  //部位分类数量	arrInfPosCnt
		arrRecord 		= runQuery.rows;
		function perNode(key,value){
			return new function(){
					var _this=this
		   			this._value = value;
		   			this.subNode={};
		   			this.subNode[key]=value;
		   			this.push=function(key,value){
		                if (_this.subNode.hasOwnProperty(key)){
		                    _this.subNode[key]+=value;
		                    _this._value+=value;
		                }else{
		                    _this.subNode[key]=value;
		                    _this._value+=value;
		                }
		            };
		        	this.getValue=function(){
		            	return _this._value
		        	}
		    }
		}
		var nodeData={}
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];

				var PosDesc =rd["PosTypeDesc"]
                var InfDiagDesc = rd["InfDiagDesc"]   
                var InfDiagCnt=parseInt(rd["InfDiagCount"])
                if (typeof(nodeData[PosDesc])=="undefined"){
                    nodeData[PosDesc]=new perNode(InfDiagDesc,InfDiagCnt);
                }else{
                    nodeData[PosDesc].push(InfDiagDesc,InfDiagCnt);
                }
				
		}
		for(var item in nodeData){
            arrInfPosDesc.push(item)
            arrInfPosCnt.push(nodeData[item].getValue())
            var subNode=nodeData[item].subNode
            for(var key in subNode){
                arrInfDiagDesc.push(key)
                arrInfDiagCnt.push(subNode[key])
            }
        }
		
		var arrLegend = arrInfPosDesc;
		arrLegend=arrInfPosDesc.concat(arrInfDiagDesc);
		option = {
			title : {
			        text: '社区感染病原体部位分布图',
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
		            name: '部位分类',
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
						for (var i = 0; i < arrInfPosDesc.length; i++) {	
							arr.push({"value": arrInfPosCnt[i],"name":arrInfPosDesc[i]});
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
				        for (var i = 0; i < arrInfDiagDesc.length; i++) {	
							arrNum1.push({"value": arrInfDiagCnt[i],"name":arrInfDiagDesc[i]});
						}
						return arrNum1;  
				    })(),
		        }
		    ]
		};
		// 使用刚指定的配置项和数据显示图表。
		obj.myChart.setOption(option,true);
	}
	
	
   	obj.ShowEchart = function(){
		obj.myChart.clear()
		var HospID = $('#cboHospital').combobox('getValue');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
        var DateTo= DateFrom;

		obj.myChart.showLoading();	
		var className="DHCHAI.STATV2.S450SHCSSPosBac";
		var queryName="QryHCSSBacInfPos";
		$cm({
		    ClassName: className,
		    QueryName: queryName,
		    aHospIDs: HospID,
		    aDateFrom: DateFrom,
			aDateTo:DateTo,
			aStaType:"E",
            aInfType:0,
			page:1,    //可选项，页码，默认1
			rows:999   //可选项，获取多少条数据，默认50
		},
		function(data){
			obj.myChart.hideLoading();    //隐藏加载动画
			if(data.total == "0"){
				$('#EchartDiv').addClass('no-result');
			}else{
				$('#EchartDiv').removeClass('no-result');
			}
			
			obj.echartLocInfRatio(data);
		}
		,function(XMLHttpRequest, textStatus, errorThrown){
			alert("类" + className + ":" + queryName+ "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
			obj.myChart.hideLoading();    //隐藏加载动画
		});

	}
	
	
	
	
	obj.up=function(x,y){
        return y.UseAntiCnt-x.UseAntiCnt
    }
	obj.option1 = function(arrBacName,arrDiagCount,endnumber){
		var option1 = {
			title : {
				text: '导致现患病原体数统计',
				textStyle:{
					fontSize:28
				},
				x:'center',
				y:'top'
			},
			grid:{
				left:'5%',
				top:'11%',	
				right:'5%',
				bottom:'5%',
				containLabel:true
			},
			tooltip: {
				trigger: 'axis',
			},
			toolbox: {
				feature: {
					dataView: {show: false, readOnly: false},
					magicType: {show: true, type: ['line', 'bar']},
					restore: {show: true},
					saveAsImage: {show: true}
				}
			},
			legend: {
				data:['导致现患病原体数','数量'],
				x: 'center',
				y: 30
			},
			 dataZoom: [{
				show: true,
				realtime: true,
				start: 0,
				zoomLock:true,
				end: endnumber
			}],
			xAxis: [
				{
					type: 'category',
					data: arrBacName,
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
				}
			],
			yAxis: [
				{
					type: 'value',
					name: '导致现患病原体数',
					min: 0,
					interval:Math.ceil(arrDiagCount[0]/10),
					axisLabel: {
						formatter: '{value} '
					}
				}
			],
			series: [
				 {
					name:'导致现患病原体数',
					type:'bar',
					barMaxWidth:50,
					data:arrDiagCount
				}
			]
		};
		return option1;
	}
	
    obj.echartLocInfRatio1 = function(runQuery){
		if (!runQuery) return;
		
		var arrBacName 		= new Array();
		var arrDiagCount 	= new Array();		

		arrRecord 		= runQuery.rows;
		var arrlength		= 0;
		arrRecord = arrRecord.sort(obj.up);
		arrRecord.length = arrRecord.length - arrlength;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			var len=arrBacName.indexOf(rd["BacName"])
			if (len>=0){
				arrDiagCount[0]=arrDiagCount[0]+parseInt(rd["InfDiagCount"])
			}else{
				arrBacName.push(rd["BacName"]);
				arrDiagCount.push(parseInt(rd["InfDiagCount"]));
		}
		}
		var endnumber = (14/arrBacName.length)*100;
		// 使用刚指定的配置项和数据显示图表。
		obj.myChart1.setOption(obj.option1(arrBacName,arrDiagCount,endnumber),true);
	}
   	obj.ShowEchart1 = function(){
		obj.myChart1.clear()
		var HospID = $('#cboHospital').combobox('getValue');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= DateFrom;

		obj.myChart1.showLoading();	
		var className="DHCHAI.STATV2.S450SHCSSPosBac";
		var queryName="QryHCSSBacInfPos";
		$cm({
		    ClassName: className,
		    QueryName: queryName,
		    aHospIDs: HospID,
		    aDateFrom: DateFrom,
			aDateTo:DateTo,
			aStaType:"E",
            aInfType:0,
			page:1,    //可选项，页码，默认1
			rows:999   //可选项，获取多少条数据，默认50
		},
		function(data){
			obj.myChart1.hideLoading();    //隐藏加载动画

			obj.echartLocInfRatio1(data);
		}
		,function(XMLHttpRequest, textStatus, errorThrown){
			alert("类" + className + ":" + queryName+ "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
			obj.myChart1.hideLoading();    //隐藏加载动画
		});
		
	}

}