$(function () {
	InitItmScreenWin();
});
//页面Gui
var objScreen = new Object();
function InitItmScreenWin(){
	var obj = objScreen;
    obj.RuleID = '';
	obj.ScreenDtl = '';
	obj.EpisodeID = '';
	obj.ScreenID = ''; 
	obj.DiagCnt = 0;
	obj.ExcCnt =0;
   //设置开始日期为当月1号
	var date=new Date()
	date.setDate(1);
	var DateFrom=Common_GetDate(date);
	var DateTo=Common_GetDate(new Date());
	Common_SetValue('dtDateFrom',DateFrom);
    Common_SetValue('dtDateTo',DateTo);

    obj.gridScreenOpr = $HUI.datagrid("#ScreenOpr",{
		fit: true,
		title:'指标分析',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:false,		
		loadMsg:'数据加载中...',
		loading:true,
		pageSize: 9999,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		url:$URL,
	    queryParams:{
			ClassName:"DHCHAI.IRS.CCScreenLogSrv",
			QueryName:"QrySuRuleOpr",
			aDateFrom:$('#dtDateFrom').datebox('getValue'),
			aDateTo:$('#dtDateTo').datebox('getValue'),
			aIsActive:1,
			page:1,    //可选项，页码，默认1
			rows:9999    //可选项，获取多少条数据，默认50
	    },	    
		columns:[[
			{field:'RuleNote',title:'疑似指标',width:240,align:'left'},
			{field:'ItmScreen',title:'筛查项目',width:180,align:'left'},
			{field:'DiagNum',title:'确诊',width:80,align:'left',sortable:true},
			{field:'ExcNum',title:'排除',width:80,align:'left',sortable:true},
			{field:'DiaRatio',title:'确诊占比',width:80,align:'left'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridScreenOpr_onSelect();
			}
		},onLoadSuccess:function(data){
			var len = data.total;
			if (len>0) {
				obj.LoadItemChart(data.rows);
			}
			for (var indRd = 0; indRd < len; indRd++){  
                var rd = data.rows[indRd];			
				obj.DiagCnt = obj.DiagCnt + parseInt(rd["DiagNum"]);
				obj.ExcCnt = obj.ExcCnt + parseInt(rd["ExcNum"]);		
			}
			obj.LoadChart(obj.DiagCnt,obj.ExcCnt);
		}
	});
	
	obj.gridScreenDtl = $HUI.datagrid("#ScreenDtl",{
		fit: true,
		nowrap:true,
		fitColumns: true,
		title:'明细日志',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:false,		
		loadMsg:'数据加载中...',
		loading:true,
		pageSize: 9999,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		url:$URL,
	    queryParams:{
			ClassName:"DHCHAI.IRS.CCScreenLogSrv",
			QueryName:"QrySuRuleOprDtl",
			page:1,    //可选项，页码，默认1
			rows:9999    //可选项，获取多少条数据，默认50
	    },	    
		columns:[[
			{field:'RuleNote',title:'疑似指标',width:280,align:'left',
				formatter: function(value,row,index){
					if ((row.ItmScreenID=='2')||(row.ItmScreen.indexOf('诊断血流感染')>-1)) {  //处理清洁标本检出菌显示
						if(row.RuleNote!="") {
							var NoteArr = row.RuleNote.split("#");	
							var htmlStr ="";									
							for (var index =0; index< NoteArr.length; index++) {
								var Note = NoteArr[index];							
								htmlStr +='<span style="line-height:25px;">'+Note+"</span></br>";	
							}							
							return htmlStr;
							
						}else {
							return value;
						}
					}else {
						return value;
					}							
				}	
			},
			{field:'Status',title:'状态',width:60,align:'left'},
			{field:'ActDateTime',title:'操作时间',width:100,align:'left'},
			{field:'ActUserDesc',title:'操作人',width:100,align:'left'},	
			{field:'InfPosDesc',title:'确诊诊断',width:120,align:'left'},	
			{field:"link",title:"详情",width:60,align:'left',
				formatter:function(value,row,index){
					return '<a href="#" onclick="objScreen.PatScreenShow(\'' + row.EpisodeID + '\')">详情</a>';
				}
			}
		]]
		,onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridScreenDtl_onSelect();
			}
		}
	});
	
	obj.gridScreenLog = $HUI.datagrid("#ScreenLog",{
		fit: true,
		nowrap:true,
		fitColumns: true,
		//title:'日志记录',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:false,		
		loadMsg:'数据加载中...',
		loading:true,
		pageSize: 9999,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		url:$URL,
	    queryParams:{
			ClassName:"DHCHAI.IRS.CCScreenLogSrv",
			QueryName:"QrySrceenDtlLog",
			page:1,    //可选项，页码，默认1
			rows:9999    //可选项，获取多少条数据，默认50
	    },	    
		columns:[[
			{field:'ItmScreen',title:'疑似指标',width:280
				,formatter: function(value,row,index){
					if ((row.ItmScreenID=='2')||(row.ItmScreen.indexOf('诊断血流感染')>-1)) {  //处理清洁标本检出菌显示
						if(row.Details!="") {
							var NoteArr = row.Details.split("#");	
							var htmlStr ="";							
							for (var index =0; index< NoteArr.length; index++) {
								var Note = NoteArr[index];							
								htmlStr +='<span style="line-height:25px;">'+Note+"</span></br>";	
							}								
							return htmlStr;
						}else {
							return value;
						}
					}else {
						return value;
					}						
					
				}	
			},
			{field:'Status',title:'状态',width:60,align:'left'},
			{field:'ActDateTime',title:'操作时间',width:100,align:'left'
				,formatter: function(value,row,index){
					return row.ActDate+" "+row.ActTime;			
				}	
			},	
			{field:'ActUserDesc',title:'操作人',width:100,align:'left'},
			{field:'Opinion',title:'排除原因',width:180,align:'left'}
		]]
	});
	
	 //默认日期类型
    $HUI.combobox("#cboStatus",{
		data:[
			{value:'1',text:'确诊'},
			{value:'2',text:'排除'}
		],
		editable:false,
		allowNull: true,       //再次点击取消选中
		valueField:'value',
		textField:'text',
		onSelect:function(rec){
			obj.EpisodeID="";
			obj.ScreenID="";	
			obj.gridScreenDtlLoad(obj.RuleID);
			obj.gridScreenLogLoad();
		}
	})
	
	InitItmScreenWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


