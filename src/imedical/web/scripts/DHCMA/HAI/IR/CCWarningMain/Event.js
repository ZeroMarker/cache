//页面Event
function InitWarnMianEvent(obj){
	obj.LoadEvent=function(){   
		$("#btnQryWarn").on('click',function(){
			obj.qryWarning();
		});
		
		obj.reportChart();
	}
	
	//加载页面
	obj.qryWarning = function(){
		var ErrorStr="";
		var HospIDs = $("#cboHospital").combobox('getValue');
		var qryDate = $("#qryDate").datebox('getValue');
		obj.qryWarnItems =obj.WarnItems();
	    
		var DateFlag=Common_CompareDate(qryDate,Common_GetDate(new Date()));
		if (!HospIDs) {
			ErrorStr += '暴发预警院区不允许为空!<br/>';
		}
		if (!qryDate) {
			ErrorStr += '暴发预警日期不允许为空<br/>';
		}
		if (DateFlag==1) {
			ErrorStr += '查询日期大于当前日期,按当前日期查询!<br/>';
		}
		if (ErrorStr != '') {
			$.messager.alert("错误提示",ErrorStr, 'info');
			return;
		}
		$('#gridWarning').datagrid('load',{
			ClassName:'DHCHAI.IRS.CCWarningNewSrv',
	        QueryName:'QryWarnResult',
	        aHospIDs:HospIDs,
			aLocIDs:'',
	        aWarnDate:qryDate,
	        aWarnItems:obj.qryWarnItems
		});
		$('#gridWarning').datagrid('unselectAll');
		obj.reportChart();
	}
	//病区详情
	obj.ShowWardInfo=function(LocID,LocDesc){
		var url='./dhchai.hai.ir.inf.warddetails.csp?aLocDr='+LocID+'&LocDesc='+LocDesc;;
		websys_showModal({
			url:url,
			title:'病区详情',
			iconCls:'icon-w-epr',
			width:1320,
			height:'95%'
		});	
	}
	//预警患者
	obj.ShowPatInfo=function(SelItem,LocID, WarnDays,ShowType,Status){
		var WarnDate = $("#qryDate").datebox('getValue');
		var IsActive =$("#WarnItem_24Hour").checkbox('getValue');
		IsActive = (IsActive==true? 1: 0);
		var url='./dhcma.hai.ir.ccwarningpat.csp?WarnLocID='+LocID+'&WarnDate='+WarnDate+'&WarnItems='+obj.qryWarnItems+'&SelItem='+SelItem+'&WarnDays='+WarnDays+'&IsWarn24Hour='+IsActive+'&ShowType='+ShowType+'&Status='+Status;
		websys_showModal({
			url:url,
			title:'预警患者明细',
			iconCls:'icon-w-epr',
			width:'95%',
			height:'95%',
			onBeforeClose:function(){
				obj.qryWarning();
			} 
		});	
	}
	//图显示
	obj.ShowWarnChart=function(selItems,selLocID){
		obj.selLocID=selLocID;
		obj.selItems=selItems;
		refreshChart();
	}
	
	//打开报告
	obj.OpenReport_Click=function(RepID,LocID){
		var WarnDate = $("#qryDate").datebox('getValue');
		var Item = $m({
			ClassName:"DHCHAI.IR.CCWarningRep",
			MethodName:"GetWarnItemById",
			aId:RepID
		},false);
		obj.WarnRepShow(LocID,RepID,WarnDate,Item,obj.qryWarnItems);
	}
	//是否已经散发
	obj.StatusValue=function(selItem,selLocID){
		var WarnDate = $("#qryDate").datebox('getValue');
		var StatusValue = $m({
			ClassName:"DHCHAI.IR.CCWarningAct",
			MethodName:"GetStatusByLocDate",
			aWarnLocDr:selLocID,
			aWarnDate:WarnDate,
			aWarnItem:selItem
		},false);
		return StatusValue;	
	}
	//获取报告ID
	obj.GetRepID=function(selLocID){
		var ReportID = $m({
			ClassName:"DHCHAI.IRS.CCWarningRepSrv",
			MethodName:"FindRepByLoc",
			aLocID:selLocID,
			aDate:$("#qryDate").datebox('getValue')
		},false);
		return ReportID;
	}
	
	obj.WarnRepShow =function (aLocID,aReportID,aWarnDate,aItem,aWarnItem){ 
		var url='./dhcma.hai.ir.ccwarningrep.csp?LocID='+ aLocID+'&ReportID='+aReportID+'&qryDate='+aWarnDate+'&selItems='+aItem+'&WarnItems='+aWarnItem;
		websys_showModal({
			url:url,
			title:'医院感染暴发报告:'+aItem,
			iconCls:'icon-w-epr',
			width:1320,
			height:'95%'
		});
	}
	
	
	//显示报表图
	obj.reportChart = function(){
		//报表		
    	obj.myChart = echarts.init(document.getElementById('main'));
        obj.myChart.resize();
        var myDate =$("#qryDate").datebox('getValue'); //获取今天日期
        
        var DateFormat = GetDateFormat();  //取日期格式类型
        function getNextDate(adate,aday) {
	        if (DateFormat=='dd/mm/yyyy') {
		       	var year=adate.split('/')[2];
				var month=adate.split('/')[1];
				var day=adate.split('/')[0];
				var date=year+"-"+month+"-"+day;
	        } else{
		        date = adate;
	        }
        	var dd = new Date(date);
		  	dd.setDate(dd.getDate() +aday);
		  	var y = dd.getFullYear();
		  	var m = dd.getMonth() + 1 < 10 ? "0" + (dd.getMonth() + 1) : dd.getMonth() + 1;
		 	var d = dd.getDate() < 10 ? "0" + dd.getDate() : dd.getDate();
		    
		 	if (DateFormat=='dd/mm/yyyy') {
				return d+'/'+ m +'/'+y;
			}else {
				return y+ "-" + m + "-" + d;
			}
		};
		
		var dateArray = []; 
		var dateTemp; 
		for (var i = 0; i < 7; i++) {
			dateTemp = getNextDate(myDate,-(6-i));
		    dateArray.push(dateTemp);
		}
        // 指定图表的配置项和数据 $.form.GetCurrDate("-")
        var option = {
			title: {
				text: '人数',
				show: true,
				x: 'center',
				textStyle: {
					fontSize: 14,
					fontWeight: 'bold',
				},
			},
			tooltip: {
				trigger: 'axis'
			},
			legend: {
				data:['发热']
			},
			toolbox: {
				show: true,
				padding: 5,
				feature: {
					dataZoom: {
						yAxisIndex: 'none'
					},
					dataView: {show: false,readOnly: false},
					magicType: {type: ['line', 'bar']},
					saveAsImage: {},
					restore: {}
				}
			},
			xAxis:  {
				type: 'category',
				boundaryGap: false,
				data:dateArray
			},
			yAxis: {
				type: 'value',
				axisLabel: {
					formatter: '{value}'
				}
			},
			series: [
				{
					name:'发热人数',
					type:'line',
					data:[],  //11, 11, 15, 13, 12, 13, 10
					markPoint: {
						data: [
							{type: 'max', name: '最大值'},
							{type: 'min', name: '最小值'}
						]
					},
					markLine: {
						data: [
							{type: 'average', name: '平均值'}
						]
					}
				}
			]
		};
		
        // 使用刚指定的配置项和数据显示图表。
        obj.myChart.setOption(option);
	};
	
	refreshChart = function () {
		if (obj.selLocID == null) return;
		IsActive=$("#WarnItem_24Hour").checkbox('getValue');
		IsActive = (IsActive==true? 1: 0);
		
		var retval = $m({
			ClassName:"DHCHAI.IRS.CCWarningNewSrv",
			MethodName:"GetCurrItemIndex",
			aLocID:obj.selLocID,
			aWarnDate:$("#qryDate").datebox('getValue'),
			aSelItem:obj.selItems,
			aFlag:IsActive
		},false);
		var titleTxt = obj.selItems.split("|")[0];
		if ((titleTxt.split(":")[0].indexOf("发热")>-1)) {
			titleTxt = "发热:"+titleTxt.split(":")[1];
		}
	    
		var dataY = [];			
		if(retval!="") {
			dataY =retval.split("^");
		}
		var option = {
			title: {
				text: titleTxt,
				subtext: ''
			},
			series: [
				{
					name:"人数",
					type:'line',
					data:dataY,  //11, 11, 15, 13, 12, 13, 10
					markPoint: {
						data: [
							{type: 'max', name: '最大值'},
							{type: 'min', name: '最小值'}
						]
					},
					markLine: {
						data: [
							{type: 'average', name: '平均值'}
						]
					}
				}
			]
		};
		obj.myChart.setOption(option);
	}
}
