function InitS132AntCombWinEvent(obj){
   	obj.LoadEvent = function(args){
		
		$('#ReportFrame').css('display', 'block');
		
		setTimeout(function(){
			obj.LoadRep();
		},50);
		//图的点击事件
		$('#btnSearchChart').on('click',function(e,value){
            //显示图
		    $('#EchartDiv').css('display', 'block');
		    $('#EchartDiv1').css('display', 'block');
		    $('#EchartDiv2').css('display', 'block');
		    $('#EchartDiv3').css('display', 'block');
			$('#EchartDiv4').css('display', 'block');
			$('#ReportFrame').css('display', 'none');
			obj.myChart = echarts.init(document.getElementById('EchartDiv'), 'theme');
			obj.myChart1 = echarts.init(document.getElementById('EchartDiv1'), 'theme');
			obj.myChart2 = echarts.init(document.getElementById('EchartDiv2'), 'theme');
			obj.myChart3 = echarts.init(document.getElementById('EchartDiv3'), 'theme');
			obj.myChart4 = echarts.init(document.getElementById('EchartDiv4'),'theme');
			obj.ShowEChaert();
		});
		//表的点击事件
		$('#btnSearchTable').on('click',function(e,value){
			$('#ReportFrame').css('display', 'block');
			$('#EchartDiv').css('display', 'none');
			obj.LoadRep();
		});
   	}

   	obj.LoadRep = function(){
	   	var NoMapCount = $cm ({									
			ClassName:"DHCHAI.DPS.NoMapCountSrv",
			MethodName:"NoOEItmMastMap"
		},false);
	
	   	if (NoMapCount>0) {
		   	$.messager.defaults.ok ="跳转";
		   	$.messager.confirm("提示", "当前存在<span style='color:red;font-size:16px;'>"+NoMapCount+"</span>条抗菌药物未对照标准名称的记录，不完成数据对照影响联合用药数判断，是否跳转至抗菌药物对照界面？", function(r){
				if (r){
					OpenMenu('DHCHAIBaseDP-LabInfTestSet','抗菌药物对照','dhcma.hai.dp.oeantimastmap.csp');
				}
		   	})
		   	$.messager.defaults.ok="确认";
	   	}
		var aHospID 	= $('#cboHospital').combobox('getValues').join('|');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		var aQrycon 	= $('#cboQryCon').combobox('getValue');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	
		ReportFrame = document.getElementById("ReportFrame");
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		if ((aStatDimens=="")){
			$.messager.alert("提示","请选择展示维度！", 'info');
			return;
		}
		
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S132AntComb.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aLocType='+aLocType+'&aQryCon='+aQrycon+'&aStatDimens='+aStatDimens+'&aLocIDs='+aLocIDs+'&aPath='+cspPath;		
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}
		
	}
	
	// 菜单跳转
	function OpenMenu(menuCode,menuDesc,menuUrl) {
		var strUrl = '../csp/'+menuUrl+'?+&1=1';
		//主菜单
		var data = [{
			"menuId": "",
			"menuCode": menuCode,
			"menuDesc": menuDesc,
			"menuResource": menuUrl,
			"menuOrder": "1",
			"menuIcon": "icon"
		}];
		if( typeof window.parent.showNavTab === 'function' ){   //bootstrap 版本
			window.parent.showNavTab(data[0]['menuCode'], data[0]['menuDesc'], data[0]['menuResource'], data[0]['menuCode'], data[0]['menuIcon'], false);
		}else{ //HISUI 版本
			window.parent.addTab({
				url:menuUrl,
				title:menuDesc
			});
		}
	}
	obj.AntiUp=function(x,y){
        return y.UseAntiCnt-x.UseAntiCnt
	}
	obj.CombUp1 = function (x, y) {
	    return y.CombSingle - x.CombSingle
	}
	obj.CombUp2 = function (x, y) {
	    return y.CombTwo - x.CombTwo
	}
	obj.CombUp3 = function (x, y) {
	    return y.CombThree - x.CombThree
	}
	obj.CombUp4 = function (x, y) {
	    return y.CombFourAndMore - x.CombFourAndMore
	}
	obj.option = function(arrViewLoc,arrUseAntiCnt,arrUseAntiRatio,endnumber){
		var option = {
			title : {
				text: '抗菌药物使用人数统计',
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
				trigger: 'axis'
			},
			toolbox: {
			    right: '20px',
				feature: {
					dataView: {show: false, readOnly: false},
					magicType: {show: true, type: ['line', 'bar']},
					restore: {show: true},
					saveAsImage: {show: true}
				}
			},
			legend: {
				data:['应用抗菌药物人数','使用率'],
				x: 'center',
				y: 30
			},
			dataZoom: [{
			    height: 30,
				show: true,
				realtime: true,
				start: 0,
				zoomLock:true,
				end: endnumber
			}],
			xAxis: [
				{
					type: 'category',
					data: arrViewLoc,
					axisLabel: {
					    margin:8,
					    rotate:45,  //科室旋转角度
					    interval: 0,
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
					name: '应用抗菌药物人数',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} '
					}
				}
			],
			series: [
				 {
					name:'应用抗菌药物人数',
					type: 'bar',
					barMaxWidth: 50,
					yAxisIndex: 0,
					data: arrUseAntiCnt
				}
			]
		};
		return option;
	}
	obj.option1 = function (arrViewLoc, arrUseAntiCnt, arrUseAntiRatio, endnumber) {
	    var option1 = {
	        title: {
	            text: '抗菌药物单用统计',
	            textStyle: {
	                fontSize: 28
	            },
	            x: 'center',
	            y: 'top'
	        },
	        grid: {
	            left: '5%',
	            top: '11%',
	            right: '5%',
	            bottom: '5%',
	            containLabel: true
	        },
	        tooltip: {
	            trigger: 'axis',
	        },
	        toolbox: {
	            right: '20px',
	            feature: {
	                dataView: { show: false, readOnly: false },
	                magicType: { show: true, type: ['line', 'bar'] },
	                restore: { show: true },
	                saveAsImage: { show: true }
	            }
	        },
	        legend: {
	            data: ['抗菌药物单用人数', '使用率'],
	            x: 'center',
	            y: 30
	        },
	        dataZoom: [{
	            height: 30,
	            show: true,
	            realtime: true,
	            start: 0,
	            zoomLock: true,
	            end: endnumber
	        }],
	        xAxis: [
				{
				    type: 'category',
				    data: arrViewLoc,
				    axisLabel: {
				        margin: 8,
				        rotate: 45,  //科室旋转角度
				        interval: 0,
				        // 使用函数模板，函数参数分别为刻度数值（类目），刻度的索引
				        formatter: function (value, index) {
				            //处理标签，过长折行和省略
				            if (value.length > 6 && value.length < 11) {
				                return value.substr(0, 5) + '\n' + value.substr(5, 5);
				            } else if (value.length > 10 && value.length < 16) {
				                return value.substr(0, 5) + '\n' + value.substr(5, 5) + '\n' + value.substr(10, 5);
				            } else if (value.length > 15 && value.length < 21) {
				                return value.substr(0, 5) + '\n' + value.substr(5, 5) + '\n' + value.substr(10, 5) + '\n' + value.substr(15, 5);
				            } else {
				                return value;
				            }
				        }
				    }
				}
	        ],
	        yAxis: [
				{
				    type: 'value',
				    name: '抗菌药物单用人数',
				    min: 0,
				    interval: Math.ceil(arrUseAntiCnt[0] / 10),
				    axisLabel: {
				        formatter: '{value} '
				    }
				}
	        ],
	        series: [
				 {
				     name: '抗菌药物单用人数',
				     type: 'bar',
				     barMaxWidth: 50,
				     yAxisIndex: 0,
				     data: arrUseAntiCnt
				 }
	        ]
	    };
	    return option1;
	}
	obj.option2 = function (arrViewLoc, arrUseAntiCnt, arrUseAntiRatio, endnumber) {
	    var option2 = {
	        title: {
	            text: '抗菌药物二联统计',
	            textStyle: {
	                fontSize: 28
	            },
	            x: 'center',
	            y: 'top'
	        },
	        grid: {
	            left: '5%',
	            top: '11%',
	            right: '5%',
	            bottom: '5%',
	            containLabel: true
	        },
	        tooltip: {
	            trigger: 'axis',
	        },
	        toolbox: {
	            right: '20px',
	            feature: {
	                dataView: { show: false, readOnly: false },
	                magicType: { show: true, type: ['line', 'bar'] },
	                restore: { show: true },
	                saveAsImage: { show: true }
	            }
	        },
	        legend: {
	            data: ['抗菌药物二联人数', '使用率'],
	            x: 'center',
	            y: 30
	        },
	        dataZoom: [{
	            height: 30,
	            show: true,
	            realtime: true,
	            start: 0,
	            zoomLock: true,
	            end: endnumber
	        }],
	        xAxis: [
				{
				    type: 'category',
				    data: arrViewLoc,
				    axisLabel: {
				        margin: 8,
				        rotate: 45,  //科室旋转角度
				        interval: 0,
				        // 使用函数模板，函数参数分别为刻度数值（类目），刻度的索引
				        formatter: function (value, index) {
				            //处理标签，过长折行和省略
				            if (value.length > 6 && value.length < 11) {
				                return value.substr(0, 5) + '\n' + value.substr(5, 5);
				            } else if (value.length > 10 && value.length < 16) {
				                return value.substr(0, 5) + '\n' + value.substr(5, 5) + '\n' + value.substr(10, 5);
				            } else if (value.length > 15 && value.length < 21) {
				                return value.substr(0, 5) + '\n' + value.substr(5, 5) + '\n' + value.substr(10, 5) + '\n' + value.substr(15, 5);
				            } else {
				                return value;
				            }
				        }
				    }
				}
	        ],
	        yAxis: [
				{
				    type: 'value',
				    name: '抗菌药物二联人数',
				    min: 0,
				    interval: Math.ceil(arrUseAntiCnt[0] / 10),
				    axisLabel: {
				        formatter: '{value} '
				    }
				}
	        ],
	        series: [
				 {
				     name: '抗菌药物二联人数',
				     type: 'bar',
				     barMaxWidth: 50,
				     yAxisIndex: 0,
				     data: arrUseAntiCnt
				 }
	        ]
	    };
	    return option2;
	}
	obj.option3 = function (arrViewLoc, arrUseAntiCnt, arrUseAntiRatio, endnumber) {
	    var option3 = {
	        title: {
	            text: '抗菌药物三联统计',
	            textStyle: {
	                fontSize: 28
	            },
	            x: 'center',
	            y: 'top'
	        },
	        grid: {
	            left: '5%',
	            top: '11%',
	            right: '5%',
	            bottom: '5%',
	            containLabel: true
	        },
	        tooltip: {
	            trigger: 'axis',
	        },
	        toolbox: {
	            right: '20px',
	            feature: {
	                dataView: { show: false, readOnly: false },
	                magicType: { show: true, type: ['line', 'bar'] },
	                restore: { show: true },
	                saveAsImage: { show: true }
	            }
	        },
	        legend: {
	            data: ['抗菌药物三联人数', '使用率'],
	            x: 'center',
	            y: 30
	        },
	        dataZoom: [{
	            height: 30,
	            show: true,
	            realtime: true,
	            start: 0,
	            zoomLock: true,
	            end: endnumber
	        }],
	        xAxis: [
				{
				    type: 'category',
				    data: arrViewLoc,
				    axisLabel: {
				        margin: 8,
				        rotate: 45,  //科室旋转角度
				        interval: 0,
				        // 使用函数模板，函数参数分别为刻度数值（类目），刻度的索引
				        formatter: function (value, index) {
				            //处理标签，过长折行和省略
				            if (value.length > 6 && value.length < 11) {
				                return value.substr(0, 5) + '\n' + value.substr(5, 5);
				            } else if (value.length > 10 && value.length < 16) {
				                return value.substr(0, 5) + '\n' + value.substr(5, 5) + '\n' + value.substr(10, 5);
				            } else if (value.length > 15 && value.length < 21) {
				                return value.substr(0, 5) + '\n' + value.substr(5, 5) + '\n' + value.substr(10, 5) + '\n' + value.substr(15, 5);
				            } else {
				                return value;
				            }
				        }
				    }
				}
	        ],
	        yAxis: [
				{
				    type: 'value',
				    name: '抗菌药物三联人数',
				    min: 0,
				    interval: Math.ceil(arrUseAntiCnt[0] / 10),
				    axisLabel: {
				        formatter: '{value} '
				    }
				}
	        ],
	        series: [
				 {
				     name: '抗菌药物三联人数',
				     type: 'bar',
				     barMaxWidth: 50,
				     yAxisIndex: 0,
				     data: arrUseAntiCnt
				 }
	        ]
	    };
	    return option3;
	}
	obj.option4 = function (arrViewLoc, arrUseAntiCnt, arrUseAntiRatio, endnumber) {
	    var option4 = {
	        title: {
	            text: '抗菌药物四联及以上统计',
	            textStyle: {
	                fontSize: 28
	            },
	            x: 'center',
	            y: 'top'
	        },
	        grid: {
	            left: '5%',
	            top: '11%',
	            right: '5%',
	            bottom: '5%',
	            containLabel: true
	        },
	        tooltip: {
	            trigger: 'axis',
	        },
	        toolbox: {
	            right: '20px',
	            feature: {
	                dataView: { show: false, readOnly: false },
	                magicType: { show: true, type: ['line', 'bar'] },
	                restore: { show: true },
	                saveAsImage: { show: true }
	            }
	        },
	        legend: {
	            data: ['抗菌药物四联及以上人数', '使用率'],
	            x: 'center',
	            y: 30
	        },
	        dataZoom: [{
	            height: 30,
	            show: true,
	            realtime: true,
	            start: 0,
	            zoomLock: true,
	            end: endnumber
	        }],
	        xAxis: [
				{
				    type: 'category',
				    data: arrViewLoc,
				    axisLabel: {
				        margin: 8,
				        rotate: 45,  //科室旋转角度
				        interval: 0,
				        // 使用函数模板，函数参数分别为刻度数值（类目），刻度的索引
				        formatter: function (value, index) {
				            //处理标签，过长折行和省略
				            if (value.length > 6 && value.length < 11) {
				                return value.substr(0, 5) + '\n' + value.substr(5, 5);
				            } else if (value.length > 10 && value.length < 16) {
				                return value.substr(0, 5) + '\n' + value.substr(5, 5) + '\n' + value.substr(10, 5);
				            } else if (value.length > 15 && value.length < 21) {
				                return value.substr(0, 5) + '\n' + value.substr(5, 5) + '\n' + value.substr(10, 5) + '\n' + value.substr(15, 5);
				            } else {
				                return value;
				            }
				        }
				    }
				}
	        ],
	        yAxis: [
				{
				    type: 'value',
				    name: '抗菌药物四联\n及以上人数',
				    min: 0,
				    interval: Math.ceil(arrUseAntiCnt[0] / 10),
				    axisLabel: {
				        formatter: '{value} '
				    }
				}
	        ],
	        series: [
				 {
				     name: '抗菌药物四联及以上人数',
				     type: 'bar',
				     barMaxWidth: 50,
				     yAxisIndex: 0,
				     data: arrUseAntiCnt
				 }
	        ]
	    };
	    return option4;
	}
    obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) return;
		var aStatDimens = $('#cboShowType').combobox('getValue');  //展示维度
		var arrViewLoc = new Array();
		var arrViewLoc1 = new Array();
		var arrViewLoc2 = new Array();
		var arrViewLoc3 = new Array();
		var arrViewLoc4 = new Array();

		var arrUseAntiCnt = new Array();		//同期全身应用抗菌药物的人数
		var arrAntiComb1 = new Array();
		var arrAntiComb2 = new Array();
		var arrAntiComb3 = new Array();
		var arrAntiComb4 = new Array();
		var arrUseAntiRatio = new Array();
		arrRecord 		= runQuery.rows;
		
		var arrlength		= 0;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			//去掉全院、医院、科室组
			if ((rd["DimensKey"].indexOf('-A-')>-1)||((aStatDimens!="H")&&(rd["DimensKey"].indexOf('-H-')>-1))||((aStatDimens!="G")&&(aStatDimens!="HG")&&(rd["DimensKey"].indexOf('-G-')>-1))||(!rd["DimensKey"])) {
				delete arrRecord[indRd];
				arrlength = arrlength + 1;
				continue;
			}
			rd["DimensDesc"] = $.trim(rd["DimensDesc"]); //去掉空格
		}
        //存入抗菌药物人数数据
		arrRecord = arrRecord.sort(obj.AntiUp);
		arrRecord.length = arrRecord.length - arrlength;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			
			arrViewLoc.push(rd["DimensDesc"]);
			arrUseAntiCnt.push(rd["UseAntiCnt"]);
		}
		var endnumber = (14 / arrViewLoc.length) * 100;
        //存入一联抗菌药物数据
		arrRecord = arrRecord.sort(obj.CombUp1);
		for (var indRd = 0; indRd < arrRecord.length; indRd++) {
		    var rd = arrRecord[indRd];
		    arrViewLoc1.push(rd["DimensDesc"]);
		    arrAntiComb1.push(rd["CombSingle"]);
		}
		var endnumber1 = (14 / arrViewLoc1.length) * 100;
		
		//存入二联抗菌药物数据
		arrRecord = arrRecord.sort(obj.CombUp2);
		for (var indRd = 0; indRd < arrRecord.length; indRd++) {
		    var rd = arrRecord[indRd];
		    arrViewLoc2.push(rd["DimensDesc"]);
		    arrAntiComb2.push(rd["CombTwo"]);
		}
		var endnumber2 = (14 / arrViewLoc2.length) * 100;
        //存入三联抗菌药物数据
		arrRecord = arrRecord.sort(obj.CombUp3);
		for (var indRd = 0; indRd < arrRecord.length; indRd++) {
		    var rd = arrRecord[indRd];
		    arrViewLoc3.push(rd["DimensDesc"]);
		    arrAntiComb3.push(rd["CombThree"]);
		}
		var endnumber3 = (14 / arrViewLoc3.length) * 100;
        //存入四联及以上抗菌药物数据
		arrRecord = arrRecord.sort(obj.CombUp4);
		for (var indRd = 0; indRd < arrRecord.length; indRd++) {
		    var rd = arrRecord[indRd];
		    arrViewLoc4.push(rd["DimensDesc"]);
		    arrAntiComb4.push(rd["CombFourAndMore"]);
		}
		var endnumber4 = (14 / arrViewLoc4.length) * 100;

		// 使用刚指定的配置项和数据显示图表。
		obj.myChart.setOption(obj.option(arrViewLoc, arrUseAntiCnt, arrUseAntiRatio, endnumber), true);
		obj.myChart1.setOption(obj.option1(arrViewLoc1, arrAntiComb1, arrUseAntiRatio, endnumber1), true);
		obj.myChart2.setOption(obj.option2(arrViewLoc2, arrAntiComb2, arrUseAntiRatio, endnumber2), true);
		obj.myChart3.setOption(obj.option3(arrViewLoc3, arrAntiComb3, arrUseAntiRatio, endnumber3), true);
		obj.myChart4.setOption(obj.option4(arrViewLoc4, arrAntiComb4, arrUseAntiRatio, endnumber4), true);
	}
   	obj.ShowEChaert = function(){
   	    obj.myChart.clear();
   	    obj.myChart1.clear();
   	    obj.myChart2.clear();
   	    obj.myChart3.clear();
   	    obj.myChart4.clear();
   	    var NoMapCount = $cm ({									
			ClassName:"DHCHAI.DPS.NoMapCountSrv",
			MethodName:"NoOEItmMastMap"
		},false);
	
	   	if (NoMapCount>0) {
		   	$.messager.defaults.ok ="跳转";
		   	$.messager.confirm("提示", "当前存在<span style='color:red;font-size:16px;'>"+NoMapCount+"</span>条抗菌药物未对照标准名称的记录，不完成数据对照影响联合用药数判断，是否跳转至抗菌药物对照界面？", function(r){
				if (r){
					OpenMenu('DHCHAIBaseDP-LabInfTestSet','抗菌药物对照','dhcma.hai.dp.oeantimastmap.csp');
				}
		   	})
		   	$.messager.defaults.ok="确认";
	   	}
		 //当月科室使用率图表
		var aHospID 	= $('#cboHospital').combobox('getValues').join('|');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		var aQrycon 	= $('#cboQryCon').combobox('getValue');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');		
		
		obj.myChart.showLoading();	//隐藏加载动画
		$cm({
			ClassName:"DHCHAI.STATV2.S132AntComb",
			QueryName:"QryAntComb",
			aHospIDs:aHospID, 
			aDateFrom:aDateFrom, 
			aDateTo:aDateTo, 
			aLocType:aLocType, 
			aQryCon:aQrycon, 
			aStatDimens:aStatDimens, 
			aLocIDs:aLocIDs, 
			page: 1,
			rows: 999
		},function(rs){
			obj.myChart.hideLoading();    //隐藏加载动画
			obj.echartLocInfRatio(rs);
		});
	}
	
}