var GV={};
var init=function(){
	if(InitViewType=="echarts") $('#c-wraper').show();
	var data=$q({ClassName:'BSP.SMP.BL.GlobalInfo',QueryName:'Find',rows:9999,latest:"1",dbName:DBName,globalName:GlobalName,ResultSetType:'array'},function(rows){
		console.log(rows);
		$.each(rows,function(){
			this.TAllocatedSizeMb=parseFloat(this.TAllocatedSizeMb);
			this.TUsedSizeMb=parseFloat(this.TUsedSizeMb);
			this.TParId=parseInt(this.TId);
			
		})
		GV.rows=rows,GV.q="",GV.filterRows=rows;
		renderData(rows);
	})
	
	
	$('#t').datagrid({
		fit:true,
		fixRowNumber:true,
		//fitColumns:true,
		title:'['+DBName+']'+GlobalName+' 变化信息',
		rownumbers:true,
		striped:true,
		singleSelect:true,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		
		idField:'TId',
		view:scrollview,
		pagination:true,
		pageSize:30,
		columns:[[
			{field:"TParId",title:"采集时间",align:"left",width:150,formatter:function(val,row,ind){
				return row['TDay']+' '+row['TTiming']||'';	
			}},
			{field:"TGlobalName",title:"Global",align:"left",width:400,sortable:false},
			{field:"TAllocatedSizeMb",title:"占用空间(MB)",align:"left",width:100,sortable:false},
			{field:"TUsedSizeMb",title:"实际使用(MB)",align:"left",width:100,sortable:true},
			{field:"TEarlyRefenceData",title:"最早引用日期",align:"left",width:100,sortable:false},
			{field:"TLastRefenceData",title:"最近引用日期",align:"left",width:100,sortable:false},
			{field:"TType",title:"类型",align:"left",width:100},
			{field:"TInWhiteList",title:"白名单",align:"left",width:100,formatter:function(val){
				return val==1?'是':'否';
			}}
		]],
		data:{total:0,rows:[]},
		remoteSort:false,
		onDblClickRow:function(ind,row){
			return;
		},
		sortName:'TParId',
		sortOrder:'desc'
		
	})	
	
	var renderGrid=function(rows){
		$('#t').datagrid('loadData',rows);
	}
	var renderECharts=function(rows){
		//jqSelector元素选择器，xAxisType columns[{field,title,barWidth}],dateField,timeField,cateField,selectedMode
		SMP_COMM.renderSimpleEChart({
			jqSelector:'#c',
			xAxisType:'time',
			dateField:'TDay',
			timeField:'TTiming',
			//selectedMode:'single',
			columns:[
				{field:'TAllocatedSizeMb',title:'占用空间(MB)',barWidth: '30%'},
				{field:'TUsedSizeMb',title:'实际使用(MB)',barWidth: '30%'}
			],
			rows:rows,
			onClick:function(o){
				console.log(o);
				
			}
		})
	}
	var renderData=function(rows){
		if ($('#c-wraper').is(':visible')) {
			renderECharts(rows);	
		}else{
			renderGrid(rows);
		}
	}
	$('#filter').remove();
	//SMP_COMM.simpleFilterInit(GV,'TGlobalName',renderData);
	SMP_COMM.simpleToggleInit(GV,InitViewType,renderData);
};
$(init);