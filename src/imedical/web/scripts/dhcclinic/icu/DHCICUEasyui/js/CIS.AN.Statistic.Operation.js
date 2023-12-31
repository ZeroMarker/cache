var detail={};
var type="",opclass="",asa="";
$(function(){
    // 设置默认日期
    dhccl.parseDateFormat();
    var today=(new Date()).addDays(1);
    if(session.DateFormat=="j/n/Y") var todayStr=today.format("dd/MM/yyyy");
    else var todayStr=today.format("yyyy-MM-dd");
    $("#OperStartDate").datebox("setValue",todayStr);
    $("#OperEndDate").datebox("setValue",todayStr);
	loadOperationDetail();
	InitChart1();
	InitChart2();
	InitChart3();
	InitChart4();
    $("#btnQuery").click(function(){
        type="",opclass="",asa="";
		loadOperationDetail();
        InitChart1();
        InitChart2();
        InitChart3();
        InitChart4();
    }); 
});

function loadOperationDetail(){
	var queryPara=dhccl.runServerMethod("CIS.AN.BL.AnaesthesiaStatistic","GetOperationDetail",$("#OperStartDate").datebox('getValue'),$("#OperEndDate").datebox('getValue'));
	if(queryPara && queryPara.length>0){
        var queryData=queryPara[0];
		for (var key in queryData) {
			detail[key] = queryData[key];
		}
	}
}

function InitChart1()
{
	var EMNum=detail.EMNumByStatus;
	var OPNum=detail.OPNumByStatus;
	var totalnum=Number(EMNum)+Number(OPNum);
	option = {
		title : {
			text: "手术例数统计 (总计:"+totalnum+")",
			x:'center'
		},
		tooltip : {
			trigger: 'item',
			formatter: "{a} <br/>{b} : {c} ({d}%)"
		},
		legend: {
			orient: 'vertical',
			left: 'left',
			textStyle:{fontSize:14},
			data:['急诊','择期']
		},
		toolbox: {
			show : true,
			feature : {
				mark : {show: true},
				dataView : {show: true, readOnly: false},
				magicType : {
					show: true,
					type: ['pie', 'funnel'],
					option: {
						funnel: {
							x: '25%',
							width: '50%',
							funnelAlign: 'left',
							max: 1548
						}
					}
				},
				restore : {show: true},
				saveAsImage : {show: true}
			}
		},
		calculable : true,
		color : [ SourceTypeColors.Emergency, SourceTypeColors.Book],
		series : [
		    {
			    name:'手术例数',
			    type:'pie',
			    radius : '55%',
			    center: ['50%', '60%'],
			    data:[
			         {value:EMNum, name:'急诊', type:"E"},
			         {value:OPNum, name:'择期', type:"B"}
			    ]
			}
		]
	};
	var myChart = echarts.init(document.getElementById('StatusChartMain'));
	myChart.setOption(option);
	myChart.on("click", pieConsole);
	function pieConsole(param) {
		type=param.data.type;
		opclass="";
		asa="";
		$("#data_grid").datagrid("reload");
	}
}
function InitChart2()
{
	var EMNum1=detail.EMNumOpClass1;
	var EMNum2=detail.EMNumOpClass2;
	var EMNum3=detail.EMNumOpClass3;
	var EMNum4=detail.EMNumOpClass4;
	var EMNumOther=detail.EMNumOpClass;
	
	var OPNum1=detail.OPNumOpClass1;
	var OPNum2=detail.OPNumOpClass2;
	var OPNum3=detail.OPNumOpClass3;
	var OPNum4=detail.OPNumOpClass4;
	var OPNumOther=detail.OPNumOpClass;
	var Num1=Number(EMNum1)+Number(OPNum1);
	var Num2=Number(EMNum2)+Number(OPNum2);
	var Num3=Number(EMNum3)+Number(OPNum3);
	var Num4=Number(EMNum4)+Number(OPNum4);
	var NumOther=Number(EMNumOther)+Number(OPNumOther);
	var totalnum=Number(Num1)+Number(Num2)+Number(Num3)+Number(Num4)+Number(NumOther);
	option = {
		title : {
			text: "手术级别统计 (总计:"+totalnum+")",
			x:'center'
		},
		tooltip : {
			trigger: 'item',
			formatter: "{a} <br/>{b} : {c} ({d}%)"
		},
		legend: {
			orient : 'vertical',
			x : 'left',
			data:['一级择期','一级急诊','二级择期','二级急诊','三级择期','三级急诊','四级择期','四级急诊','无级择期','无级急诊']
		},
		toolbox: {
			show : true,
			feature : {
				mark : {show: true},
				dataView : {show: true, readOnly: false},
				magicType : {
					show: true,
					type: ['pie', 'funnel']
				},
				restore : {show: true},
				saveAsImage : {show: true}
			}
		},
		calculable : false,
		series : [
		    {
			    name:'手术例数',
			    type:'pie',
			    selectedMode: 'single',
			    radius : [0, 80],
			    center: ['50%', '60%'],
			    x: '30%',
			    width: '50%',
			    funnelAlign: 'right',
			    max: 2548,
			    itemStyle : {
				    normal : {
					    label : {
						    position : 'inner'
						},
						labelLine : {
							show : false
						}
					}
				},
				data:[
				     {value:Num1, name:'一级', type:"", opclass:"一级手术"},
				     {value:Num2, name:'二级', type:"", opclass:"二级手术"},
				     {value:Num3, name:'三级', type:"", opclass:"三级手术"},
				     {value:Num4, name:'四级', type:"", opclass:"四级手术"},
				     {value:NumOther, name:'无级', type:"", opclass:"无级手术"}
				]
			},
			{
				name:'手术例数',
				type:'pie',
				radius : [90, 150],
			    center: ['50%', '60%'],
				x: '30%',
				width: '50%',
				funnelAlign: 'left',
				max: 2048,
				data:[
				     {value:OPNum1, name:'一级择期', type:"B", opclass:"一级手术"},
				     {value:EMNum1, name:'一级急诊', type:"E", opclass:"一级手术"},
				     {value:OPNum2, name:'二级择期', type:"B", opclass:"二级手术"},
				     {value:EMNum2, name:'二级急诊', type:"E", opclass:"二级手术"},
				     {value:OPNum3, name:'三级择期', type:"B", opclass:"三级手术"},
				     {value:EMNum3, name:'三级急诊', type:"E", opclass:"三级手术"},
				     {value:OPNum4, name:'四级择期', type:"B", opclass:"四级手术"},
				     {value:EMNum4, name:'四级急诊', type:"E", opclass:"四级手术"},
				     {value:OPNumOther, name:'无级择期', type:"B", opclass:"无级手术"},
				     {value:EMNumOther, name:'无级急诊', type:"E", opclass:"无级手术"}
				]
			}
		]
	};
	var myChart = echarts.init(document.getElementById('OpClassChartMain'));
	myChart.setOption(option);
	myChart.on("click", pieConsole);
	function pieConsole(param) {
		type=param.data.type;
		opclass=param.data.opclass;
		asa="";
		$("#data_grid").datagrid("reload");
	}
}
function InitChart3()
{
	var Num1=detail.ASANum1;
	var Num2=detail.ASANum2;
	var Num3=detail.ASANum3;
	var Num4=detail.ASANum4;
	var Num5=detail.ASANum5;
	var NumOther=detail.ASANum;
	var totalnum=Number(Num1)+Number(Num2)+Number(Num3)+Number(Num4)+Number(Num5)+Number(NumOther);
	option = {
		title : {
			text: "麻醉例数统计 (总计:"+totalnum+")",
			x:'center'
		},
		tooltip : {
			trigger: 'item',
			formatter: "{a} <br/>{b} : {c} ({d}%)"
		},
		legend: {
			orient: 'vertical',
			left: 'left',
			textStyle:{fontSize:14},
			data:['ASAI','ASAII','ASAIII','ASAIV','ASAV','无']
		},
		toolbox: {
			show : true,
			feature : {
				mark : {show: true},
				dataView : {show: true, readOnly: false},
				magicType : {
					show: true,
					type: ['pie', 'funnel'],
					option: {
						funnel: {
							x: '25%',
							width: '50%',
							funnelAlign: 'left',
							max: 1548
						}
					}
				},
				restore : {show: true},
				saveAsImage : {show: true}
			}
		},
		calculable : true,
		color : [ 'orange', 'yellow', 'green', 'blue', 'indigo', 'purple'],
		series : [
		    {
			    name:'手术例数',
			    type:'pie',
			    radius : '55%',
			    center: ['50%', '60%'],
			    data:[
			         {value:Num1, name:'ASAI', asa:"1"},
			         {value:Num2, name:'ASAII', asa:"2"},
			         {value:Num3, name:'ASAIII', asa:"3"},
			         {value:Num4, name:'ASAIV', asa:"4"},
			         {value:Num5, name:'ASAV', asa:"5"},
			         {value:NumOther, name:'无', asa:"无"}
			    ]
			}
		]
	};
	var myChart = echarts.init(document.getElementById('ASAChartMain'));
	myChart.setOption(option);
	myChart.on("click", pieConsole);
	function pieConsole(param) {
		type="";
		opclass="";
		asa=param.data.asa;
		$("#data_grid").datagrid("reload");
	}
}
function InitChart4(){
	var datagrid = $("#data_grid");
	datagrid.datagrid({
		idField: "RowId",
		fit: true,
		rownumbers: true,
		remoteSort: false,
		singleSelect:true,
		striped:true,
		title: "",
		nowrap: true,
		toolbar: "#dataTools",
		border:false,
		url: ANCSP.DataQuery,
		queryParams: {
			ClassName: "CIS.AN.BL.AnaesthesiaStatistic",
			QueryName: "FindOperationList",
			ArgCnt: 5
		},
		columns: [
		[{
			field: "StatusDesc",
			title: "状态",
			width: 50,
			styler:function(value,row,index){return "background-color:" + row.StatusColor + ";";}
		}, {
			field: "SourceTypeDesc",
			title: "类型",
			width: 50,
			styler: function (value, row, index) {
				switch (row.SourceType) {
					case "B":
					    return "background-color:"+SourceTypeColors.Book+";";
					case "E":
					    return "background-color:"+SourceTypeColors.Emergency+";";
                    default:
                        return "background-color:white;";
                }
            }
		}, {
			field: "OperClassDesc",
			title: "手术级别",
			width: 80
		}, {
			field: "ASAClassDesc",
			title: "ASA分级",
			width: 80
		}, {
			field: "OperDate",
			title: "手术日期",
			width: 100
		}, {
			field: "RoomDesc",
			title: "手术间",
			width: 80
		},{
			field: "OperSeq",
			title: "台次",
			width: 50
		}, {
			field: "PatName",
			title: "患者姓名",
			width: 80
		}, {
			field: "PatGender",
			title: "性别",
			width: 50
		}, {
			field: "PatAge",
			title: "年龄",
			width: 50
		}, {
			field: "PatDeptDesc",
			title: "科室",
			width: 120
		}, {
			field: "PrevDiagnosis",
			title: "术前诊断",
			width: 150
		}, {
			field: "OperDesc",
			title: "手术名称",
			width: 150
		},{
			field: "PlanSurgeonDesc",
			title: "主刀",
			width: 80
		}, {
			field: "AnaMethodDesc",
			title: "麻醉方法",
			width: 80
		}, {
			field: "AnesthesiologistDesc",
			title: "麻醉医生",
			width: 80
		}]
		],
		onBeforeLoad: function(param) {
			param.Arg1 = $("#OperStartDate").datebox("getValue");
			param.Arg2 = $("#OperEndDate").datebox("getValue");
			param.Arg3 = type;
			param.Arg4 = opclass;
			param.Arg5 = asa;
		},
		rowStyler: function(index, row) {
			return "";
		},
		pagination: true,
		pageList: [200, 500],
		pageSize: 500
	});
}
