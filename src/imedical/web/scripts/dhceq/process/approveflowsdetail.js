var myDate = new Date();
///定义一个对象,把全局变量的数据放在里面
var GlobalObj = {
	//参数
	//QXType : "",
	//ReadOnly : "",
	//vData : "",
	//后台取出来的数据
	DateList : "",
	
	getManagementData : function ()
	{
		var ApproveFlowData="";
	    $.ajax(
			{
		    	async: false,
	            url :"dhceq.jquery.method.csp",
				type:"POST",
		            data:{
	                ClassName:"web.DHCEQCApproveSet",
	                MethodName:"GetBussApproveFlow",
			        Arg1:jQuery('#BussType').val(),
			        Arg2:jQuery('#SourceID').val(),
			        ArgCnt:2
	            },
	           	error:function(XMLHttpRequest, textStatus, errorThrown){
	                alertShow(XMLHttpRequest.status);
	                alertShow(XMLHttpRequest.readyState);
	                alertShow(textStatus);
	            },
	            success:function (data, response, status){
	            	$.messager.progress('close');
					data=data.replace(/\ +/g,"");		//去掉空格
					data=data.replace(/[\r\n]/g,"");	//去掉回车换行
	            	ApproveFlowData=data;
	           }
			}
		)
		//alertShow(ApproveFlowData)
	    this.DateList=ApproveFlowData;
	}
}

///jquery界面入口
jQuery(document).ready(function()
{
	//初始化系统变量,通过ajxe从后台取数据
	GlobalObj.getManagementData();
	
	//初始化图表
	initEcharts_ApproveFlow();
	initLifeInfoDataGrid();
});

function initEcharts_ApproveFlow()
{
	/*
	var jsonStr  = "{\"userId\":\"001\"}";  // json对象字符串
	var jsonArryStr = "[{\"userId\":\"001\"},{\"userId\":\"002\"}]"; // json数组字符串
	var jsonObj  = JSON.parse(jsonStr);     // 字符串转为json对象
	var jsonArry = JSON.parse(jsonArryStr); // 字符串转为json数组
	var jsonStr  = JSON.stringify(jsonObj); // json对象转为字符串
	var jsonArryStr=JSON.stringify(jsonArry);// json数组转为字符串
	//alertShow(jsonStr);
	//alertShow(jsonArryStr);
	//alertShow(jsonObj.userId);
	
	data: [{
                name: '节点1',
                x: 300,
                y: 300
            }, {
                name: '节点2',
                x: 800,
                y: 300
            }, {
                name: '节点3',
                x: 550,
                y: 100
            }, {
                name: '节点4',
                x: 550,
                y: 500
            }],
	*/
	var Left = 300;
    var Top = 300;
    var Width = 300;
    var Height = 300;
    
    var Node = "";
    var xNodeCount = 0;
	var yNodeCount = 0;
	var xNode = 0;		// 节点x位置
	var yNode = 0;		// 节点y位置
	var NeedNode = ""; 	// 主要节点
	var PreviousNode = ""; // 前一个节点
	var NodeArryStr = "";	// 节点数组字符串
	var LineArryStr = "";	// 节点连线数组字符串
	
	// "申请^1&派单^0&受理^1&维修^1&配件确认^0&完成^1&组长审核^1&科室确认^1"
	//alertShow("initEcharts_PaidStatistics:"+GlobalObj.DateList)
	if (GlobalObj.DateList=="")
	{
		jsonArryStr='['+'{\"name\":\"'+'无业务流'+'\",\"x\":\"'+Left+'\",\"y\":\"'+Top+'\"}]';
	}
	else
	{
		var dataList=GlobalObj.DateList.split("&");
		var Len=dataList.length;
		for(var i=0;i<Len;i++)
		{
			//alertShow(dataList[i])
			var ApproveFlow=dataList[i].split("^");
			if (NodeArryStr!="") NodeArryStr=NodeArryStr+',';
			Node=ApproveFlow[0];
			if (ApproveFlow[1]==1)
			{
				xNodeCount = xNodeCount + 1;
				yNodeCount = 0;
				xNode=Left + Width * xNodeCount;
				if ((NeedNode!="")&&(NeedNode!=PreviousNode))
				{
					if (LineArryStr!="") LineArryStr=LineArryStr+',';
					if (PreviousNode!="")
					{
						LineArryStr = LineArryStr + '{\"source\":\"'+NeedNode;
						LineArryStr = LineArryStr + '\",\"target\":\"' + Node;
			            LineArryStr = LineArryStr + '\"}';
					}
				}
				NeedNode=Node;
			}
			else
			{
				// 可选流程
				//xNodeCount = 0;
				xNode=Left + Width * (xNodeCount+0.5);
				yNodeCount = yNodeCount + 1;
				Node = Node + "(可选)";
			}
			yNode=Top + Height * yNodeCount;
			NodeArryStr = NodeArryStr + '{\"name\":\"'+Node + '\",\"x\":\"' + xNode + '\",\"y\":\"' + yNode + '\"}';
			//alertShow(NodeArryStr)
			if (LineArryStr!="") LineArryStr=LineArryStr+',';
			if (PreviousNode!="")
			{
				LineArryStr = LineArryStr + '{\"source\":\"'+PreviousNode;
				LineArryStr = LineArryStr + '\",\"target\":\"' + Node;
				//LineArryStr = LineArryStr + '\",\"symbolSize\": \"[5'+','+'20]';		//symbolSize: [5, 20],
				//LineArryStr = LineArryStr + '\",\"lineStyle\": {\"width\":'+'5}';	//lineStyle: {width: 5,curveness: 0.2}
				//var tmpNodeArryStr='{\"width\":\"'+ 25 + '\"}';
				//LineArryStr = LineArryStr + '\",\"lineStyle\":' + [tmpNodeArryStr];
				
	            LineArryStr = LineArryStr + '\"}';
			}
			PreviousNode=Node;
		}
		NodeArryStr = '[' + NodeArryStr + ']';
		LineArryStr = '[' + LineArryStr + ']';
	}
	// alertShow(NodeArryStr)
	// 字符串转为json数组
	var xAxisData = JSON.parse(NodeArryStr);
	var yAxisData = JSON.parse(LineArryStr);
	
	var myChart = echarts.init(document.getElementById('ApproveFlow'));
	option = {
	    title: {
	        text: '业务工作流'
	    },
	    tooltip: {},
	    animationDurationUpdate: 1500,
	    animationEasingUpdate: 'quinticInOut',
	    series : [
	        {
	            type: 'graph',
	            layout: 'none',
	            symbolSize: 80,
	            roam: true,
	            label: {
	                normal: {
	                    show: true
	                }
	            },
	            edgeSymbol: ['circle', 'arrow'],
	            edgeSymbolSize: [4, 10],
	            edgeLabel: {
	                normal: {
	                    textStyle: {
	                        fontSize: 10
	                    }
	                }
	            },
	            data : xAxisData,
	            
	            links : yAxisData,
	            lineStyle: {
                	normal: {
                    	opacity: 0.9,
                    	width: 4,
                    	curveness: 0
                	}
            	}
	        }
	    ]
	};
	// 使用指定的配置项和数据显示图表
    myChart.setOption(option);
}
function initLifeInfoDataGrid()
{
	jQuery('#LifeInfo').datagrid({
		url:'dhceq.jquery.csp',
		queryParams:{
	        ClassName:"web.DHCEQLifeInfo",
	        QueryName:"GetDetailOperatorInfo",
			Arg1:jQuery('#BussType').val(),
			Arg2:jQuery('#SourceID').val(),
	        ArgCnt:2
    	},
	    border:'true',
	    fit:"true",
	    singleSelect:true,
	    rownumbers: true,  //显示一个行号列
	    columns:[[
	    	{field:'TAction',title:'业务流',width:100,align:'center'},
			{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},
			{field:'TOpinion',title:'意见',width:200,align:'center'},
			{field:'TApproveRole',title:'角色',width:100,align:'center'},
			{field:'TApproveUserDR',title:'处理人',width:100,align:'center'},
			{field:'TApproveDate',title:'时间',width:150,align:'center'}
	    ]],
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40]
    });
}