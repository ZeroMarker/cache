//页面Gui
var objScreen = new Object();
function InitAssRateWin(){
	var obj = objScreen;
    obj.SttDate = '';
	obj.EndDate = '';	
				
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
			{field:'PatAdmSum',title:'总人数',width:90,align:'center',
				formatter: function(value,row,index){
					if (value==0){
					  	return value;
				  	}else {
						var type =1;
						return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenDtl(\""+type+"\");' >"+value+ "</a>";
				  	}
				}
			},
			{field:'ReportSum',title:'感染人数',width:90,align:'center',
				formatter: function(value,row,index){
					if (value==0){
					  	return value;
				  	}else {
						var type =2;
						return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenDtl(\""+type+"\");' >"+value+ "</a>";
				  	}
				}
			},
			{field:'InfRate',title:'感染率',width:80,align:'center'},
			{field:'ScreenSum',title:'疑似人数',width:90,align:'center'},
			{field:'ScreenRate',title:'疑似率',width:80,align:'center'},
			{field:'InfScreenCnt',title:'感染疑似',width:90,align:'center',sortable:true,	
				formatter: function(value,row,index){
					if (value==0){
						return value;
					}else {
						var type =6;
						return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenDtl(\""+type+"\",\""+row.RuleID+"\");' >"+value+ "</a>";
					}
				}
			},
			{field:'RepUnScreenCnt',title:'感染非疑似',width:100,align:'center',sortable:true,	
				formatter: function(value,row,index){
					if (value==0){
						return value;
					}else {
						var type =7;
						return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenDtl(\""+type+"\",\""+row.RuleID+"\");' >"+value+ "</a>";
					}
				}
			},
			{field:'ScreenUnInfCnt',title:'疑似非感染',width:100,align:'center',sortable:true,	
				formatter: function(value,row,index){
					if (value==0){
						return value;
					}else {
						var type =8;
						return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenDtl(\""+type+"\",\""+row.RuleID+"\");' >"+value+ "</a>";
					}
				}
			},
			{field:'UnInfScreenCnt',title:'非疑似感染',width:100,align:'center',sortable:true,
				formatter: function(value,row,index){
					if (value==0){
						return value;
					}else {
						var type =9;
						return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenDtl(\""+type+"\",\""+row.RuleID+"\");' >"+value+ "</a>";
					}
				}
			},
			{field:'ACCRatio',title:'准确率',width:80,align:'center',sortable:true},
			{field:'TPRRatio',title:'灵敏度',width:80,align:'center',sortable:true},
			{field:'TNRRatio',title:'特异度',width:80,align:'center',sortable:true},
			{field:'PPVRatio',title:'阳性预测值',width:90,align:'center',sortable:true},
			{field:'NPVRatio',title:'阴性预测值',width:90,align:'center',sortable:true},
			{field:'FNRRatio',title:'假阴性率',width:80,align:'center',sortable:true},
			{field:'FPRRatio',title:'假阳性率',width:80,align:'center',sortable:true}
		]]
	});
	
	//评估模型
	obj.cbgModel = $HUI.combogrid('#cbgModel', {
		panelWidth: 460,
	    pagination: true,
		blurValidValue: true, //为true时，光标离开时，检查是否选中值,没选中则置空输入框的值
		fitColumns: true,     //真正的自动展开/收缩列的大小，以适应网格的宽度，防止水平滚动条
		idField: 'ID',
		textField: 'AMDesc',
		multiple: false,
		url: $URL,
		queryParams:{ClassName: 'DHCHAI.AMS.AssessModelSrv',QueryName: 'QryAssessModel',aIsActive:1},
		columns: [[
			{field:'AMCode',title:'评估模型代码',width:100},
			{field:'AMDesc',title:'评估模型定义',width:300}
		]]
		,onSelect:function(index, row){		
			var ModelID = row.ID;
			var AdmStatus = row.AdmStatus;
			if (AdmStatus) {
				$HUI.radio('#radAdmStatus-'+AdmStatus).setValue(true);
			}
			obj.SttDate = row.SttDate;
			obj.EndDate = row.EndDate;
					
			$('#dtDateFrom').datebox('setValue',obj.SttDate);
			$('#dtDateTo').datebox('setValue',obj.EndDate);
			obj.btnQuery_click();
		}
	});
	
	obj.gridRateDtl = $HUI.datagrid("#RateDtlTab",{
		fit: true,
		//title:'明细数据',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		toolbar: [{
            text:'导出',
            iconCls:'icon-export',
            handler:function(){$('#RateDtlTab').datagrid('toExcel','明细数据.xls');}
        }],
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
			{field:'PapmiNo',title:'登记号',width:100,sortable:true},
			{field:'MrNo',title:'病案号',width:100,sortable:true},
			{field:'PatName',title:'姓名',width:100},
			{field:'Sex',title:'性别',width:80},
			{field:'Age',title:'年龄',width:80},
			{field:'link',title:'摘要',width:60,sortable:true,align:'center',
				formatter: function(value,row,index){
					return " <a href='#' style='white-space:normal; color:blue' onclick='objScreen.OpenView(\"" + row.EpisodeID + "\");'>摘要</a>";
				}
			},
			{field:'AdmDate',title:'就诊日期',width:100,sortable:true},
			{field:'AdmTime',title:'就诊时间',width:100,sortable:true},
			{field:'AdmLocDesc',title:'就诊科室',width:150,sortable:true},
			{field:'AdmWardDesc',title:'就诊病区',width:180,sortable:true},
			{field:'DischDate',title:'出院日期',width:100,sortable:true},
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


