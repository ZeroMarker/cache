var myDate = new Date();
///����һ������,��ȫ�ֱ��������ݷ�������
var GlobalObj = {
	//����
	//QXType : "",
	//ReadOnly : "",
	//vData : "",
	//��̨ȡ����������
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
					data=data.replace(/\ +/g,"");		//ȥ���ո�
					data=data.replace(/[\r\n]/g,"");	//ȥ���س�����
	            	ApproveFlowData=data;
	           }
			}
		)
		//alertShow(ApproveFlowData)
	    this.DateList=ApproveFlowData;
	}
}

///jquery�������
jQuery(document).ready(function()
{
	//��ʼ��ϵͳ����,ͨ��ajxe�Ӻ�̨ȡ����
	GlobalObj.getManagementData();
	
	//��ʼ��ͼ��
	initEcharts_ApproveFlow();
	initLifeInfoDataGrid();
});

function initEcharts_ApproveFlow()
{
	/*
	var jsonStr  = "{\"userId\":\"001\"}";  // json�����ַ���
	var jsonArryStr = "[{\"userId\":\"001\"},{\"userId\":\"002\"}]"; // json�����ַ���
	var jsonObj  = JSON.parse(jsonStr);     // �ַ���תΪjson����
	var jsonArry = JSON.parse(jsonArryStr); // �ַ���תΪjson����
	var jsonStr  = JSON.stringify(jsonObj); // json����תΪ�ַ���
	var jsonArryStr=JSON.stringify(jsonArry);// json����תΪ�ַ���
	//alertShow(jsonStr);
	//alertShow(jsonArryStr);
	//alertShow(jsonObj.userId);
	
	data: [{
                name: '�ڵ�1',
                x: 300,
                y: 300
            }, {
                name: '�ڵ�2',
                x: 800,
                y: 300
            }, {
                name: '�ڵ�3',
                x: 550,
                y: 100
            }, {
                name: '�ڵ�4',
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
	var xNode = 0;		// �ڵ�xλ��
	var yNode = 0;		// �ڵ�yλ��
	var NeedNode = ""; 	// ��Ҫ�ڵ�
	var PreviousNode = ""; // ǰһ���ڵ�
	var NodeArryStr = "";	// �ڵ������ַ���
	var LineArryStr = "";	// �ڵ����������ַ���
	
	// "����^1&�ɵ�^0&����^1&ά��^1&���ȷ��^0&���^1&�鳤���^1&����ȷ��^1"
	//alertShow("initEcharts_PaidStatistics:"+GlobalObj.DateList)
	if (GlobalObj.DateList=="")
	{
		jsonArryStr='['+'{\"name\":\"'+'��ҵ����'+'\",\"x\":\"'+Left+'\",\"y\":\"'+Top+'\"}]';
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
				// ��ѡ����
				//xNodeCount = 0;
				xNode=Left + Width * (xNodeCount+0.5);
				yNodeCount = yNodeCount + 1;
				Node = Node + "(��ѡ)";
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
	// �ַ���תΪjson����
	var xAxisData = JSON.parse(NodeArryStr);
	var yAxisData = JSON.parse(LineArryStr);
	
	var myChart = echarts.init(document.getElementById('ApproveFlow'));
	option = {
	    title: {
	        text: 'ҵ������'
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
	// ʹ��ָ�����������������ʾͼ��
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
	    rownumbers: true,  //��ʾһ���к���
	    columns:[[
	    	{field:'TAction',title:'ҵ����',width:100,align:'center'},
			{field:'TRowID',title:'TRowID',width:50,align:'center',hidden:true},
			{field:'TOpinion',title:'���',width:200,align:'center'},
			{field:'TApproveRole',title:'��ɫ',width:100,align:'center'},
			{field:'TApproveUserDR',title:'������',width:100,align:'center'},
			{field:'TApproveDate',title:'ʱ��',width:150,align:'center'}
	    ]],
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40]
    });
}