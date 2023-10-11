//页面Event
function InitCCScreeningWinEvent(obj){
	obj.LoadEvent=function(){   
		$("#btnQryWarn").on('click',function(){
			obj.qryWarning();
		});
		$("#btnSingin").on('click',function(){
			obj.btnSingin_click();
		});
		obj.reportChart();
	}
	//加载页面
	
	obj.qryWarning = function(){
		obj.OperationFlg="";
		var ErrorStr="";
		var HospIDs = $("#cboHospital").combobox('getValue');
		var qryDate = $("#qryDate").datebox('getValue');
		var WarnItems =$("#WarnItem_FerverName2").html() + "|" + $("#WarnItem_FerverDay2").val() + "|" + $("#WarnItem_FerverCnt2").val();  //发热标准差
		WarnItems += "^" + $("#WarnItem_FerverName").html() + "|" + $("#WarnItem_FerverDay").val() + "|" + $("#WarnItem_FerverCnt").val();  //发热人数
		WarnItems += "^" + $("#WarnItem_BactName").html() + "|" + $("#WarnItem_BactDay").val() + "|" + $("#WarnItem_BactCnt").val();		//
		WarnItems += "^" + "实时现患" + "|" + $("#WarnItem_DayDay").val() + "|" + $("#WarnItem_DayCnt").val();
		var IsActive =$("#WarnItem_24Hour").checkbox('getValue');
		IsActive = (IsActive==true? 1: 0);
		WarnItems += "^入院24H内计入|" + IsActive;
		obj.qryWarnItems = WarnItems;
		obj.qryWarnDate=$("#qryDate").datebox('getValue');
		var DateFlag=Common_CompareDate(new Date(),qryDate);
		if (!HospIDs) {
			ErrorStr += '暴发预警院区不允许为空!<br/>';
		}
		if (!qryDate) {
			ErrorStr += '暴发预警日期不允许为空<br/>';
		}
		if (DateFlag==1) {
			ErrorStr += '查询日期大于当前日期,按当前日期查询!<br/>';
		}if (ErrorStr != '') {
			$.messager.alert("错误提示",ErrorStr, 'info');
			return;
		}
		$('#gridBfyj').datagrid('load',{
			ClassName:'DHCHAI.IRS.NewCCWaringSrv',
	        QueryName:'QryWarnResult',
	        aHospIDs:$("#cboHospital").combobox('getValue'),
	        aWarnDate:$("#qryDate").datebox('getValue'),
	        aWarnItems:WarnItems
		});
		$('#gridBfyj').datagrid('unselectAll');
		obj.reportChart();
	}
	//图显示
	obj.gridBfyj_Click=function(selItems,selLocID){
		obj.selLocID=selLocID;
		obj.selItems=selItems;
		obj.qryWarnDate=$("#qryDate").datebox('getValue');
		IsActive=$("#WarnItem_24Hour").checkbox('getValue');
		IsActive = (IsActive==true? 1: 0);
		obj.aflag= IsActive;
		refreshChart();
	}
	//患者列表
	obj.LocPatients_Click=function(selItems,selLocID){
		//window.event? window.event.cancelBubble = true : e.stopPropagation();	//阻止冒泡
		if(selItems=="发热人数1"){selItems="发热人数"}
		if(selItems=="发热人数2"){selItems="发热标准差"}
		$('#LocPatients').datagrid('load',{
			ClassName:"DHCHAI.IRS.NewCCWaringSrv",
			QueryName:"QryWarnPatList",
			aLocID:selLocID,
			aWarnDate:obj.qryWarnDate,
			aWarnItems:obj.qryWarnItems,
			aSelItem:selItems
		});
		$('#winEdit').show();
		obj.SetDiaglog();
	}
	//三管
	obj.OperSGWinByEpis_Click = function(EpisodeID)
	{	
		$('#GridSgInfo').datagrid('load',{
			ClassName:"DHCHAI.IRS.ICULogSrv",
			QueryName:"QryICUAdmOeItem",
			aPaAdm:EpisodeID,
			aFlag:"0"
		});
		$('#winEdit_two').show();
		obj.SetDiaglog_two();
	};
	//科室床位图
	obj.OperKSWin_Click=function(selLocID){
		obj.selLocID=selLocID
		obj.WarnItemsArray=["现患人数", "发热人数1", "肺炎克雷伯菌", "大肠杆菌", "金黄色葡萄球菌", "鲍曼不动杆菌", "便常规异常", "呼吸机使用", "中心静脉置管", "泌尿道插管", "上呼吸道感染", "下呼吸道感染", "泌尿道感染", "血管相关性感染", "表浅手术切口感染", "深部手术切口感染", "器官（或腔隙）感染", "发热人数2"]
		InitBedChart(obj,obj.selLocID,obj.qryWarnDate,obj.qryWarnItems,obj.WarnItemsArray,"1");
		return;
	}
	//打开报告
	obj.OperReport_Click=function(RepID,LocID){
		var Item = $m({
			ClassName:"DHCHAI.IR.CCWarningRep",
			MethodName:"GetWarnItemById",
			aId:RepID
		},false);
		obj.WarnRepShow(LocID,RepID,obj.qryWarnDate,Item,obj.qryWarnItems);
	}
	//是否已经散发
	obj.StatusValue=function(selItem,selLocID){
		var StatusValue = $m({
			ClassName:"DHCHAI.IR.CCWarningAct",
			MethodName:"GetStatusByLocDate",
			aWarnLocDr:selLocID,
			aWarnDate:obj.qryWarnDate,
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
			aDate:obj.qryWarnDate
		},false);
		return ReportID;
	}
	
	//患者列表加载
	obj.SetDiaglog=function (){
		$('#winEdit').dialog({
			title: '预警患者情况',
			iconCls:'icon-w-paper',
			modal: true,
			width:1360,
			height:600,
			isTopZindex:false,//true,
			onBeforeClose:function(){
				if (obj.OperationFlg==1){
					obj.qryWarning();
				}
				$("#gridBfyj").datagrid('reload');
			}
		});
	}
	
	obj.SetDiaglog_three=function (){
		$('#winEdit_three').dialog({
			title: '预警患者情况',
			iconCls:'icon-w-paper',
			modal: true,
			width:1360,
			height:600,
			isTopZindex:false//true,
		});
	}
	obj.SetDiaglog_two=function (){
		$('#winEdit_two').dialog({
			title: '三管信息',
			iconCls:'icon-w-paper',
			modal: true,
			width:800,
			height:600,
			isTopZindex:false//true,
		});
	}
	//摘要
	obj.OperZYWinByEpis_Click = function(EpisodeID)
	{	
		var url = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&PageType=WinOpen';
	    websys_showModal({
			url:url,
			title:'医院感染集成视图',
			iconCls:'icon-w-epr',
			closable:true,
			width:'95%',
			height:'95%'
		});
	};
	
	//主动报告暴发
	$('#btnReport').on('click',function () {
		selItems="主动报告";
		var url='../csp/dhcma.hai.ir.ccwarningrep.csp?LocID=' + ""+'&ReportID='+""+'&qryDate='+""+'&selItems='+selItems+'&WarnItems='+obj.qryWarnItems;
		websys_showModal({
			url:url,
			title:'医院感染暴发报告:'+selItems,
			iconCls:'icon-w-epr',
			width:1320,
			height:'95%',
			onBeforeClose:function(){ //关闭窗口时调用查询方法实现状态更新
				obj.btnQuery_click();
			}
		});	
	})
	//报卡
	$('#btnCollect').on('click',function () {
		var rows = obj.LocPatients.getRows();
		if (rows.length<0){
			$.messager.alert("提示", "表格中无数据!",'info');
			return;
		}
		var LocID = rows[0]["WarnLocDr"];
		var ret = $m({
			ClassName:"DHCHAI.IRS.CCWarningRepSrv",
			MethodName:"JudgeRep",
			aLocID:LocID,
			aDate:obj.qryWarnDate,
			aselItems:obj.selItems
		},false);
		if (parseInt(ret)==1){
			$.messager.alert("提示",obj.selItems+"已报卡，无需再报", 'info');
			return;
		}
		if ((parseInt(ret)==2)){
			$.messager.confirm("提示", obj.selItems+"已散发处置，是否需要报卡", function (r) {
				if (r) {				
					obj.WarnRepShow(LocID,'',obj.qryWarnDate,obj.selItems,obj.qryWarnItems);
				} 
			});	
		}
		if (parseInt(ret)==-1){
			obj.WarnRepShow(LocID,'',obj.qryWarnDate,obj.selItems,obj.qryWarnItems);
		}
	})
	
	obj.WarnRepShow =function (aLocID,aReportID,aWarnDate,aItem,aWarnItem){ 
		var url='../csp/dhcma.hai.ir.ccwarningrep.csp?LocID='+ aLocID+'&ReportID='+aReportID+'&qryDate='+aWarnDate+'&selItems='+aItem+'&WarnItems='+aWarnItem;
		websys_showModal({
			url:url,
			title:'医院感染暴发报告:'+aItem,
			iconCls:'icon-w-epr',
			width:1320,
			height:'95%'
		});
	}
	
	//非爆发
	obj.btnSingin_click= function(){
		var InputStr = "";
		InputStr += "^" + obj.selLocID;
		InputStr += "^" + obj.selItems;
		InputStr += "^" + obj.qryWarnDate;
		InputStr += "^" + "2"; 
		InputStr += "^" + "";      // 处置日期
		InputStr += "^" + "";      // 处置时间
		InputStr += "^" + $.LOGON.USERID; // 处置人
		InputStr += "^" + "";     // 处置意见
		InputStr += "^" + "";     // 报告ID
		InputStr += "^#" + obj.qryWarnItems;	//查询条件
		var retval = $m({
			ClassName:"DHCHAI.IR.CCWarningAct",
			MethodName:"Update",
			aInput:InputStr,
			aSeparate:"^"
		},false);
		if (parseInt(retval)>0){
			obj.OperationFlg=1;
			$.messager.popover({msg: '【散发】处置成功！',type:'success',timeout: 1000});
		} else {
			$.messager.popover({msg: '【散发】处置失败！',type:'error',timeout: 1000});
		}
	};
		
	//显示报表图
	obj.reportChart = function(){
		//报表		
    	obj.myChart = echarts.init(document.getElementById('main'));
        obj.myChart.resize();
        var myDate =$("#qryDate").datebox('getValue'); //获取今天日期
        function getNextDate(date,day) {  
		  var dd = new Date(date);
		  dd.setDate(dd.getDate() + day);
		  var y = dd.getFullYear();
		  var m = dd.getMonth() + 1 < 10 ? "0" + (dd.getMonth() + 1) : dd.getMonth() + 1;
		  var d = dd.getDate() < 10 ? "0" + dd.getDate() : dd.getDate();
		  return y + "-" + m + "-" + d;
		};
		var dateArray = []; 
		var dateTemp; 
		for (var i = 0; i < 7; i++) {
			dateTemp = getNextDate(myDate,-(6-i))
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
		obj.myChart.on('click', function (params) {
			// 控制台打印数据的名称
			//alert(params.name);
		});
	};
	
	refreshChart = function ()
	{
		if (obj.selLocID == null) return;
		var retval = $m({
				ClassName:"DHCHAI.IRS.NewCCWaringSrv",
				MethodName:"GetCurrItemIndex",
				aLocID:obj.selLocID,
				aWarnDate:obj.qryWarnDate,
				aWarnItems:"",
				aSelItem:obj.selItems,
				aFlag:obj.aflag
			},false);
		if(obj.selItems=="发热人数1"){obj.selItems="发热人数"}
		if(obj.selItems=="发热人数2"){obj.selItems="发热方差"}
		var dataY = [];			
		if(retval!="")
		{
			dataY =retval.split("^");
		}
		var option = {
			title: {
				text: obj.selItems,
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
	};
}
