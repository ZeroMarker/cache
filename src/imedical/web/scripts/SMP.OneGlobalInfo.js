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
		title:'['+DBName+']'+GlobalName+' �仯��Ϣ',
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
			{field:"TParId",title:"�ɼ�ʱ��",align:"left",width:150,formatter:function(val,row,ind){
				return row['TDay']+' '+row['TTiming']||'';	
			}},
			{field:"TGlobalName",title:"Global",align:"left",width:400,sortable:false},
			{field:"TAllocatedSizeMb",title:"ռ�ÿռ�(MB)",align:"left",width:100,sortable:false},
			{field:"TUsedSizeMb",title:"ʵ��ʹ��(MB)",align:"left",width:100,sortable:true},
			{field:"TEarlyRefenceData",title:"������������",align:"left",width:100,sortable:false},
			{field:"TLastRefenceData",title:"�����������",align:"left",width:100,sortable:false},
			{field:"TType",title:"����",align:"left",width:100},
			{field:"TInWhiteList",title:"������",align:"left",width:100,formatter:function(val){
				return val==1?'��':'��';
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
		//jqSelectorԪ��ѡ������xAxisType columns[{field,title,barWidth}],dateField,timeField,cateField,selectedMode
		SMP_COMM.renderSimpleEChart({
			jqSelector:'#c',
			xAxisType:'time',
			dateField:'TDay',
			timeField:'TTiming',
			//selectedMode:'single',
			columns:[
				{field:'TAllocatedSizeMb',title:'ռ�ÿռ�(MB)',barWidth: '30%'},
				{field:'TUsedSizeMb',title:'ʵ��ʹ��(MB)',barWidth: '30%'}
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