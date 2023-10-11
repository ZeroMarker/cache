function InitS210OppoSinfEvent(obj){
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
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var Statunit = Common_CheckboxValue('chkStatunit');
		var Qrycon = $('#aQryCon').combobox('getValue');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var OperCat = $('#cboOperCat').combobox('getValue');
		var OperType = $('#cboOperType').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	
		//alert(Statunit)
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
p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S210OpPosInf.raq&aHospIDs='+aHospID +'&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aStaType='+ Statunit +'&aQryCon='+ Qrycon+'&aOperCat='+OperCat+'&aOperType='+OperType+'&aStatDimens='+aStatDimens+'&aLocIDs='+aLocIDs+'&aPath='+cspPath;	
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
				text: '手术患者手术部位感染率统计图',
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
		            radius: ['45%', '60%'],
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
		var HospID = $('#cboHospital').combobox('getValues').join('|');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var StaType = Common_CheckboxValue('chkStatunit');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var Qrycon = $('#aQryCon').combobox('getValue');
		var OperCat = $('#cboOperCat').combobox('getValue');
		var OperType = $('#cboOperType').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	
		obj.myChart.showLoading();
		$cm({
			ClassName:'DHCHAI.STATV2.S210OpPosInf',
			QueryName:'QryOpPosInf',
			aHospIDs:HospID,
			aDateFrom:DateFrom,
			aDateTo:DateTo,
			aStaType:StaType,
			aQryCon:Qrycon,
			aOperCat:OperCat,
			aOperType:OperType,
			aStatDimens:aStatDimens,
			aLocIDs:aLocIDs,
			page:1,
			rows:999
		},function(rs){
			obj.myChart.hideLoading();    //隐藏加载动画
			obj.echartLocInfRatio(rs);
		})
		
	   obj.echartLocInfRatio = function(runQuery){
			if (!runQuery) return;
			var arrViewLoc = new Array();
			var arrInfRatio = new Array();
			var arrInfDiag = new Array();
			var arrInfCount = new Array();
			obj.arrLocG= new Array();
			var arrRecord = runQuery.rows;
			
			var aHospID   = $('#cboHospital').combobox('getValue');
			var aHospDesc = $('#cboHospital').combobox('getText');
			var QryCon="-H-";	//默认统计医院
			if (aHospDesc=="全部院区"){
				QryCon="-A-";
			}
			for (var indRd = 0; indRd < arrRecord.length; indRd++){
				var rd = arrRecord[indRd];
				//去掉全院、医院、科室组
				if ((rd["xDimensKey"].indexOf(QryCon)<0)&&(rd["xDimensKey"]!="")) {
					delete arrRecord[indRd];
					continue;
				}
			}
			for (var indRd = 0; indRd < arrRecord.length; indRd++){                     
				var rd = arrRecord[indRd];
				if(rd==undefined){   //去掉全院、医院、科室组后,会有数据变为undefined
					continue;
				}else{
					arrViewLoc.push(rd["SuperIncCount"]);
					arrViewLoc.push(rd["DeepIncCount"]);
					arrViewLoc.push(rd["OrganCount"]);
					arrInfRatio.push("表浅切口手术感染例数");
					arrInfRatio.push("深部切口手术感染例数");
					arrInfRatio.push("器官腔隙手术感染例数");
				}
			}
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
