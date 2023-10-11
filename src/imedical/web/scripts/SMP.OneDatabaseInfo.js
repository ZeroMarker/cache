var GV={};
var init=function(){
	
	var data=$q({ClassName:'BSP.SMP.BL.DatabaseInfo',QueryName:'Find',rows:9999,latest:"0",dbName:DBName,ResultSetType:'array'},function(rows){
		console.log(rows);
		$.each(rows,function(){
			this.TSizeMB=parseFloat(this.TSizeMB);
			this.TAvailableMB=parseFloat(this.TAvailableMB);
			this.TFreePercent=parseFloat(this.TFreePercent);
			this.TGlobalCount=parseFloat(this.TGlobalCount);
			this.TDataSizeMB=parseFloat(this.TDataSizeMB); //this.TSizeMB-this.TAvailableMB; //数据实际大小
			this.TId=parseInt(this.TId);
			
		})
		GV.rows=rows,GV.q="",GV.filterRows=rows;
		renderData(rows);
	})
	
	$('#t').datagrid({
		fit:true,
		//fitColumns:true,
		title:DBName+' 数据库变化信息',
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
			{field:"TId",sortable:'true',title:"采集时间",align:"left",width:150,formatter:function(val,row,ind){
				return row['TDay']+' '+row['TTiming']||'';	
			}},
			{field:"TDatabaseName",title:"数据库",align:"left",width:150},
			{field:"TDirectory",title:"目录",align:"left",width:350},
			{field:"TSizeMB",title:"大小(MB)",align:"left",width:80},
			{field:"TAvailableMB",title:"可用大小(MB)",align:"left",width:100},
			{field:"TDataSizeMB",title:"数据大小(MB)",align:"left",width:100},
			{field:"TFreePercent",title:"空闲百分比",align:"left",width:100,formatter:function(val){
				return val+'%';
			}},
			{field:"TBlockSize",title:"单数据块大小",align:"left",width:90},
			{field:"TDiskFreeSpace",title:"磁盘可用空间",align:"left",width:100},
			
			{field:"TResourceName",title:"资源",align:"left",width:130},
			
			{field:"TGlobalCount",title:"Global数量",align:"left",width:100},
			
			{field:"TExpansionSize",title:"扩展大小",align:"left",width:100},
			{field:"TLastExpansionTime",title:"上次扩展时间",align:"left",width:150,formatter:function(val){
				return SMP_COMM.formatDate(val);	
			}},
			
			
			//{field:"TGlobalInfoDR",title:"TGlobalInfoDR",align:"left",width:100},
			{field:"TGlobalJournalState",title:"Journal日志",align:"left",width:100,formatter:function(val){
				return val==1?'是':'否';	
			}},
			{field:"TTimeSpendAlias",title:"采集用时",align:"left",width:100}
		]],
		data:{total:0,rows:[]},
		remoteSort:false,
		onDblClickRow:function(ind,row){
			jumpGlobalInfo(row,'grid');
		},
		sortName:'TId',
		sortOrder:'desc'
		
	})	
	var jumpGlobalInfo=function(row,from){
		//暂时不让从此调到Global明细去了
		return;
		var opts={
			id:'GlobalInfo',
			title:'Global'+'('+row.TDay+' '+row.TTiming+')',
			url:'smp.globalinfo.csp?InitViewType='+from+'&DBName='+row.TDatabaseName+'&DBCollectId='+row.TId
		}
		SMP_COMM.showBread(opts);
	}
	
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
			selectedMode:'single',
			columns:[
				{field:'TSizeMB',title:'空间大小(MB)',barWidth: '40%'},
				{field:'TDataSizeMB',title:'数据大小(MB)',barWidth: '40%'},
				{field:'TGlobalCount',title:'Global数量',barWidth: '40%'}
			],
			rows:rows,
			onClick:function(o){
				console.log(o);
				jumpGlobalInfo(rows[o.dataIndex],'echarts');
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
	//SMP_COMM.simpleFilterInit(GV,'TDatabaseName',renderData);
	SMP_COMM.simpleToggleInit(GV,InitViewType,renderData);
};
$(init);