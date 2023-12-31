var type="",opclass=""
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
        type="",opclass="";
        InitChart2();
    }); 
});
function InitChart1()
{
	var stdate=$("#OperStartDate").datebox('getValue')
	var enddate=$("#OperEndDate").datebox('getValue');
	var EMNum1=GetOpClassNum(stdate,enddate,"E","一级手术");
	var OPNum1=GetOpClassNum(stdate,enddate,"B","一级手术");
	var EMNum2=GetOpClassNum(stdate,enddate,"E","二级手术");
	var OPNum2=GetOpClassNum(stdate,enddate,"B","二级手术");
	var EMNum3=GetOpClassNum(stdate,enddate,"E","三级手术");
	var OPNum3=GetOpClassNum(stdate,enddate,"B","三级手术");
	var EMNum4=GetOpClassNum(stdate,enddate,"E","四级手术");
	var OPNum4=GetOpClassNum(stdate,enddate,"B","四级手术");
	var EMNumOther=GetOpClassNum(stdate,enddate,"E","");
	var OPNumOther=GetOpClassNum(stdate,enddate,"B","");
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
	var myChart = echarts.init(document.getElementById('chartmain'));
	myChart.setOption(option);
	myChart.on("click", pieConsole);
	function pieConsole(param) {
		type=param.data.type;
		opclass=param.data.opclass;
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
			field: "OperClassDesc",
			title: "手术级别",
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
			param.Arg5 = "";
		},
		rowStyler: function(index, row) {
			return "";
		},
		pagination: true,
		pageList: [200, 500],
		pageSize: 500
	});
}

function GetOpClassNum(stdate,enddate,type,opclass){
	var result=dhccl.runServerMethodNormal("CIS.AN.BL.AnaesthesiaStatistic","GetOpClassNum",stdate,enddate,type,opclass);
    return result;
}
