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
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S401InvasOper.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aLocType='+aLocType+'&aQryCon='+aQrycon+'&aStatDimens='+aStatDimens+'&aLocIDs='+aLocIDs+'&aPath='+cspPath;
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
				text: '出院患者医院感染侵害性操作分布',
				textStyle:{
						fontSize:20
					},
				x:'center',
				y:'top'
			},
		    tooltip: {
				trigger: 'axis',
			},
			toolbox: {
				feature: {
					dataView: {show: false, readOnly: false},
					magicType: {show: false},
					restore: {show: true},
					saveAsImage: {show: true}
				}
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
		var aHospID 	= $('#cboHospital').combobox('getValues').join('|');
		var aDateFrom = $('#dtDateFrom').datebox('getValue');
		var aDateTo= $('#dtDateTo').datebox('getValue');
		var aLocType = Common_CheckboxValue('chkStatunit');
		var aQryCon =  $('#cboQryCon').combobox('getValue');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	
		
		obj.myChart.showLoading();
		$cm({
			ClassName:'DHCHAI.STATV2.S401InvasOper',
			QueryName:'QryInvasOper',
			aHospIDs:aHospID,
			aDateFrom:aDateFrom,
			aDateTo:aDateTo,
			aLocType:aLocType,
			aQryCon:aQryCon,
			aStatDimens:aStatDimens,
			aLocIDs:aLocIDs,
			page:1,    //可选项，页码，默认1
			rows:999   //可选项，获取多少条数据，默认50
		},function(rs){
			obj.myChart.hideLoading();    //隐藏加载动画
			obj.echartLocInfRatio(rs);
		});
		
	   obj.echartLocInfRatio = function(runQuery){
			if (!runQuery) return;
			var aHospID = $('#cboHospital').combobox('getValue');
	   	 	var QryCon="-H-";	//默认统计医院
	    	if (aHospID.indexOf('|')>-1) QryCon="-A-";	//多院区时统计全院
			var aLocIDs = $('#cboLoc').combobox('getValues').join(',');	
			var arrViewLoc = new Array();
			var arrInfRatio = new Array();
			var arrInfDiag = new Array();
			var arrInfCount = new Array();
			obj.arrLocG= new Array();
			var arrRecord = runQuery.rows;

			for (var indRd = 0; indRd < arrRecord.length; indRd++){
				var rd = arrRecord[indRd];
				if ((rd["xDimensKey"].indexOf(QryCon)>-1)||((aLocIDs!="")&&(rd["DimensDesc"]=="全部"))) {
					arrViewLoc.push(rd["InvDesc"]);
					arrInfRatio.push(rd["InfInvCount"]);
				}
			}
			// 装载数据
			obj.myChart.setOption(
				{
					legend: {
						data: arrViewLoc
					},
					series: [{
						data:(function(){
				            var arrNum=[];
				        	for (var i = 0; i < arrViewLoc.length; i++) {	
 								arrNum.push({"value": arrInfRatio[i],"name":arrViewLoc[i]});
							}
							return arrNum;  
				        })()
					}]
				}
			);
			
		}
	}
}
