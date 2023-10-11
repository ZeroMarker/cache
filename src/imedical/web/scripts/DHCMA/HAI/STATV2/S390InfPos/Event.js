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
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S390InfPos.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aLocType='+aLocType+'&aQryCon='+aQrycon+'&aStatDimens='+aStatDimens+'&aLocIDs='+aLocIDs+'&aPath='+cspPath;	
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}	
	}
		
	obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) return;
		var aHospID = $('#cboHospital').combobox('getValue');
	    var QryCon="-H-";	//默认统计医院
	    if (aHospID.indexOf('|')>-1) QryCon="-A-";	//多院区时统计全院
		var aLocIDs = $('#cboLoc').combobox('getValues').join(',');	
		var arrInfDiagDesc = new Array();	//感染诊断
		var arrInfDiagCnt  = new Array();   //感染诊断例数
		var arrPosDesc		= new Array();	//感染部位(临时)
		var arrInfPosDesc	= new Array();	//感染部位
		var arrInfPosCnt  	= new Array();  //感染部位例数
		arrRecord 		= runQuery.rows;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			if ((rd["DimensKey"].indexOf(QryCon)>-1)||((aLocIDs!="")&&(rd["DimensDesc"]=="全部"))) {
				arrInfDiagDesc.push(rd["PosDesc"]);		//加载诊断
				arrInfDiagCnt.push(rd["InfDiagCnt"]);	//加载诊断数据
				arrPosDesc.push(rd["InfDiagDesc"]);		//加载感染部位-临时
				
				var IsRespect=0;			//是否重复
				for(var indPos = 0; indPos < arrInfPosDesc.length; indPos++){
					if(rd["InfDiagDesc"]==arrInfPosDesc[indPos]){
						IsRespect=1;
						arrInfPosCnt[indPos]=parseInt(rd["InfDiagCnt"])+parseInt(arrInfPosCnt[indPos]);
						/*//感染诊断按感染部位重组
						var x=rd["PosDesc"];	
						var y=rd["InfDiagCnt"];
						for(var i=indRd;i>0;i--){
							arrInfDiagDesc[i]=arrInfDiagDesc[i-1];
							arrInfDiagCnt[i]=arrInfDiagCnt[i-1];
							if(rd["InfDiagDesc"]==arrPosDesc[i]){
								arrInfDiagDesc[i-1]=x;
								arrInfDiagCnt[i-1]=y;
								break;
							}
						}*/
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
			        text: '住院患者医院感染部位分布图',
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
					magicType: {show: false},
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
		obj.myChart.clear();
		var aHospID 	= $('#cboHospital').combobox('getValues').join('|');
		var aDateFrom = $('#dtDateFrom').datebox('getValue');
		var aDateTo= $('#dtDateTo').datebox('getValue');
		var aLocType = Common_CheckboxValue('chkStatunit');
		var aQryCon =  $('#cboQryCon').combobox('getValue');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	
		
		obj.myChart.showLoading();
		$cm({
			ClassName:'DHCHAI.STATV2.S390InfPos',
			QueryName:'QryInfPos',
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
	}
}
