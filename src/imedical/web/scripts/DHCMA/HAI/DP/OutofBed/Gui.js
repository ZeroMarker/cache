$(function () {
	InitOutofBedWin();
});
//页面Gui
var objScreen = new Object();
function InitOutofBedWin(){
	var obj = objScreen;
    obj.RecRowID = '';	
    
    Common_ComboToSSHosp("cboHosp",$.LOGON.HOSPID);
	var nowDate = new Date();
	nowDate.setMonth(nowDate.getMonth()-1);
    $('#aDateFrom').datebox('setValue', Common_GetDate(nowDate));// 日期初始赋值
    $('#aDateTo').datebox('setValue', Common_GetDate(new Date()));

    obj.gridOutofBed = $HUI.datagrid("#OutofBed",{
		fit: true,
		title:'离床患者查询',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:false,		
		loadMsg:'数据加载中...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200],
		 //是否是服务器对数据排序
        sortOrder:'asc',
		remoteSort:false,
		columns:[[
			{field:'PapmiNo',title:'登记号',width:110,sortable:true,align:'left'},
			{field:'PatName',title:'姓名',width:80,sortable:true,align:'left'},
			{field:'Sex',title:'性别',width:50,align:'left',sortable:true},
			{field:'VisitStatusDesc',title:'就诊状态',width:70,align:'left',sortable:true},
			{field:'AdmDate',title:'入院日期',width:100,sortable:true,sorter:Sort_int,align:'left'},
			{field:'AdmTime',title:'入院时间',width:80,sortable:true,sorter:Sort_int,align:'left'},
			{field:'OutbedDate',title:'离床日期',width:100,sortable:true,sortable:true,sorter:Sort_int,align:'left'},
			{field:'OutbedTime',title:'离床时间',width:80,sortable:true,sorter:Sort_int,align:'left'},
			{field:'OprStatusDesc',title:'操作',width:80,align:'left',sortable:true,
				formatter: function(value,row,index){
					if (row.OprStatus == "1") { //已标记
					    if (row.IsActive=="1") {  //his中仍未出院 
							return " <a href='#'  onclick='objScreen.CancelOpr(\"" + row.ID + "\", \"" + row.VisitStatus + "\");'>取消标记</a>";
				        } else {   //his中已出院
							return;
						}
					} {  //未标记、取消标记
						if (row.IsActive=="1") {  //his中仍未出院 
							return " <a href='#'  onclick='objScreen.OprStatusEdit(\"" + row.ID + "\",\"" + row.OutbedDate + "\",\"" + row.OutbedTime + "\",\"" + row.AdmDate + "\",\"" + row.AdmTime + "\");'>标记</a>";
					    } else { //his中已出院
							return;
						}
					}
				}
			},
			{field:'expander',title:'操作日志',width:70,align:'left',sortable:true,
				formatter: function(value,row,index){          					
					var btn = '<a href="#" class="icon-search" onclick="objScreen.OprStatusLog(\'' + row.ID  + '\')">&nbsp;&nbsp;&nbsp;&nbsp;</a>';
					return btn;
				}
			},
			{field:'EpisodeID',title:'摘要',width:60,sortable:true,align:'left',sortable:true,
				formatter: function(value,row,index){
					return " <a href='#'  onclick='objScreen.OpenView(\"" + row.EpisodeID + "\");'>摘要</a>";
				}
			},
	        {field:'IsActiveDesc',title:'是否有效',width:80,align:'left',sortable:true,
				 styler: function(value,row,index){
					if (value=="否") {
						retStr = 'color:gray;';
					} else {
						retStr = 'color:black;';
					} 
					return retStr;
				}
			}, 		
			{field:'DischDate',title:'标记出院日期',width:100,sortable:true,sorter:Sort_int,align:'left'},
			{field:'DischTime',title:'标记出院时间',width:100,sortable:true,sorter:Sort_int,align:'left'},
			{field:'AdmLocDesc',title:'就诊科室',width:120,sortable:true,align:'left'},
			{field:'AdmWardDesc',title:'就诊病区',width:150,sortable:true,align:'left'}
		]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
	});
	
	
	obj.gridOutofBedLog = $HUI.datagrid("#OutofBedLog",{
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:false,		
		loadMsg:'数据加载中...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'OprStatus',title:'操作',width:80,align:'left'},
			{field:'DischDate',title:'标记出院日期',width:100,align:'left'},
			{field:'DischTime',title:'标记出院时间',width:100,align:'left'},
			{field:'UpdateDate',title:'操作日期',width:100,align:'left'},
			{field:'UpdateTime',title:'操作时间',width:80,align:'left'},
			{field:'UserDesc',title:'操作人',width:120,align:'left'}		
		]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
	});
	
	
	InitOutofBedWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


