//页面Gui
var objScreen = new Object();
function InitAssRateWin(){
	var obj = objScreen;
    var objSttDate = '';
	var objEndDate = '';	
				
    obj.gridAssRate = $HUI.datagrid("#AssessRate",{
		fit: true,
		title:'疑似病例筛查相关率',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,		
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
			ClassName:'DHCHAI.AMS.AssessRateSrv',
			QueryName:'QryAssessRate',
			aModelDr:''
	    },
		columns:[[
			{field:'PatAdmSum',title:'总人数',width:100,align:'center',
				formatter: function(value,row,index){
					if (value==0){
					  	return value;
				  	}else {
						var type =1;
						return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenDtl(\""+type+"\");' >"+value+ "</a>";
				  	}
				}
			},
			{field:'ReportSum',title:'感染人数',width:120,align:'center',
				formatter: function(value,row,index){
					if (value==0){
					  	return value;
				  	}else {
						var type =2;
						return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenDtl(\""+type+"\");' >"+value+ "</a>";
				  	}
				}
			},
			{field:'InfRate',title:'感染率',width:100,align:'center'},
			{field:'ScreenSum',title:'疑似人数',width:120,align:'center'},
			{field:'ScreenRate',title:'疑似率',width:100,align:'center'},
			{field:'DiagNoneSum',title:'未处置人数',width:100,align:'center'},
			{field:'DiagCancelSum',title:'排除人数',width:100,align:'center'},
			{field:'DiagnosisSum',title:'确诊人数',width:120,align:'center'},
			{field:'DiagnosisRate',title:'精准率',width:100,align:'center'},
			{field:'DiagReportSum',title:'自报人数',width:100,align:'center',
				formatter: function(value,row,index){
					if (value==0){
					  	return value;
				  	}else {
						var type =4;
						return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenDtl(\""+type+"\");' >"+value+ "</a>";
				  	}
				}
			},
			{field:'MissedSum',title:'漏筛人数',width:100,align:'center',
				formatter: function(value,row,index){
					if (value==0){
					  	return value;
				  	}else {
						var type =3;
						return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenDtl(\""+type+"\");' >"+value+ "</a>";
				  	}
				}
			},
			{field:'MissedRate',title:'漏筛率',width:100,align:'center'}
		]]
	});
	
	//评估模型
	obj.cbgModel = $HUI.combogrid('#cbgModel', {
		panelWidth: 400,
		editable: true,
	    pagination: true,
		blurValidValue: true, //为true时，光标离开时，检查是否选中值,没选中则置空输入框的值
		fitColumns: true,     //真正的自动展开/收缩列的大小，以适应网格的宽度，防止水平滚动条
		mode:'remote',        //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		idField: 'ID',
		textField: 'AMDesc',
		multiple: false,
		url: $URL,
		queryParams:{ClassName: 'DHCHAI.AMS.AssessModelSrv',QueryName: 'QryAssessModel',aIsActive:1},
		columns: [[
			{field:'AMCode',title:'评估模型代码',width:120},
			{field:'AMDesc',title:'评估模型定义',width:240}
		]]
	});
	
	obj.gridRateDtl = $HUI.datagrid("#RateDtlTab",{
		fit: true,
		//title:'明细数据',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,		
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
			ClassName:'DHCHAI.AMS.AssessRateSrv',
			QueryName:'QryRateDtl'
	    },
		columns:[[
			{field:'PapmiNo',title:'登记号',width:120,sortable:true},
			{field:'MrNo',title:'病案号',width:120,sortable:true},
			{field:'PatName',title:'姓名',width:120},
			{field:'Sex',title:'性别',width:80},
			{field:'Age',title:'年龄',width:80},
			{field:'EpisodeID',title:'摘要',width:60,sortable:true,align:'center',
				formatter: function(value,row,index){
					return " <a href='#' style='white-space:normal; color:blue' onclick='objScreen.OpenView(\"" + row.EpisodeID + "\");'>摘要</a>";
				}
			},
			{field:'AdmDate',title:'就诊日期',width:120,sortable:true},
			{field:'AdmTime',title:'就诊时间',width:100,sortable:true},
			{field:'AdmLocDesc',title:'就诊科室',width:150,sortable:true},
			{field:'AdmWardDesc',title:'就诊病区',width:180,sortable:true},
			{field:'DischDate',title:'出院日期',width:120,sortable:true},
			{field:'DischTime',title:'出院时间',width:100,sortable:true},
			{field:'DischLocDesc',title:'出院科室',width:150},
			{field:'DischWardDesc',title:'出院病区',width:180},
			{field:'AdmDays',title:'住院天数',width:80}
		]]
	});

	InitAssRateWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


