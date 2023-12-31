var asa=""
$(function(){
	var date=new Date();
	var month=date.getMonth();
	date.setMonth(month-1);
	date.setDate(1);
	var FirstDay = date;
	$("#OperStartDate").datebox("setValue", FirstDay.format("yyyy-MM-dd"));
	$("#OperEndDate").datebox("setValue", new Date().format("yyyy-MM-dd"));
	InitChart1();
	InitChart2();
    $("#btnQuery").click(function(){
        InitChart1();
        asa="";
        InitChart2();
    }); 
});
function InitChart1()
{
	var Num1=GetASANum($("#OperStartDate").datebox('getValue'),$("#OperEndDate").datebox('getValue'),"1");
	var Num2=GetASANum($("#OperStartDate").datebox('getValue'),$("#OperEndDate").datebox('getValue'),"2");
	var Num3=GetASANum($("#OperStartDate").datebox('getValue'),$("#OperEndDate").datebox('getValue'),"3");
	var Num4=GetASANum($("#OperStartDate").datebox('getValue'),$("#OperEndDate").datebox('getValue'),"4");
	var Num5=GetASANum($("#OperStartDate").datebox('getValue'),$("#OperEndDate").datebox('getValue'),"5");
	var NumOther=GetASANum($("#OperStartDate").datebox('getValue'),$("#OperEndDate").datebox('getValue'),"");
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
	var myChart = echarts.init(document.getElementById('chartmain'));
	myChart.setOption(option);
	myChart.on("click", pieConsole);
	function pieConsole(param) {
		asa=param.data.asa;
		$("#data_grid").datagrid("reload");
	}
}
function InitChart2(){
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
			param.Arg3 = "";
			param.Arg4 = "";
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
function GetASANum(stdate,enddate,asa){
	var result=dhccl.runServerMethodNormal("CIS.AN.BL.AnaesthesiaStatistic","GetASANum",stdate,enddate,asa);
    return result;
}
