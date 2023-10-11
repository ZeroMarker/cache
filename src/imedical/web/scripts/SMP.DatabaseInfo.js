var GV={};
var init=function(){
	
	var data=$q({ClassName:'BSP.SMP.BL.DatabaseInfo',QueryName:'Find',rows:9999,latest:"1",summaryInfoId:SummaryInfoId,ResultSetType:'array'},function(rows){
		console.log(rows);
		$.each(rows,function(){
			this.TSizeMB=parseFloat(this.TSizeMB);
			this.TAvailableMB=parseFloat(this.TAvailableMB);
			this.TFreePercent=parseFloat(this.TFreePercent);
			this.TGlobalCount=parseFloat(this.TGlobalCount);
			this.TDataSizeMB=parseFloat(this.TDataSizeMB); //this.TSizeMB-this.TAvailableMB; //数据实际大小
			
		})
		GV.rows=rows,GV.q="",GV.filterRows=rows;
		renderData(rows);
	})
	var dgSelectOnChange=function(){
		var rows=$('#t').datagrid('getSelections');
		console.log(rows.length);
		if(rows.length>0){
			$('#t-tb-child').linkbutton('enable');
			$('#t-tb-process').linkbutton('enable');
			
		}else{
			$('#t-tb-child').linkbutton('disable');
			$('#t-tb-process').linkbutton('disable');
		}
		
	}
	var debounced_dgSelectOnChange=SMP_COMM.debounce(dgSelectOnChange,200);
	
	$('#t').datagrid({
		fit:true,
		//fitColumns:true,
		title:'数据库信息',
		rownumbers:true,
		striped:true,
		singleSelect:true,
		headerCls:'panel-header-gray',
		//bodyCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination:false,
		idField:'TId',
		columns:[[
			{field:"TDatabaseName",title:"数据库",align:"left",width:150,sortable:true},
			{field:"TDirectory",title:"目录",align:"left",width:350,sortable:true},
			{field:"TSizeMB",title:"大小(MB)",align:"left",width:80,sortable:true},
			{field:"TAvailableMB",title:"可用大小(MB)",align:"left",width:100},
			{field:"TDataSizeMB",title:"数据大小(MB)",align:"left",width:100,sortable:true},
			{field:"TFreePercent",title:"空闲百分比",align:"left",width:100,formatter:function(val){
				return val+'%';
			}},
			{field:"TBlockSize",title:"单数据块大小",align:"left",width:90},
			{field:"TDiskFreeSpace",title:"磁盘可用空间",align:"left",width:100},
			
			{field:"TResourceName",title:"资源",align:"left",width:130},
			
			{field:"TGlobalCount",title:"Global数量",align:"left",width:100,sortable:true},
			
			{field:"TExpansionSize",title:"扩展大小",align:"left",width:100},
			{field:"TLastExpansionTime",title:"上次扩展时间",align:"left",width:150,formatter:function(val){
				return SMP_COMM.formatDate(val);	
			}},
			
			
			//{field:"TGlobalInfoDR",title:"TGlobalInfoDR",align:"left",width:100},
			{field:"TGlobalJournalState",title:"Journal日志",align:"left",width:100,formatter:function(val){
				return val==1?'是':'否';	
			}},
			
			{field:"TDay",title:"采集时间",align:"left",width:150,formatter:function(val,row,ind){
				return val+' '+row['TTiming']||'';	
			}},
			{field:"TTimeSpendAlias",title:"采集用时",align:"left",width:100}
		]],
		data:{total:0,rows:[]},
		remoteSort:false,
		onDblClickRow:function(ind,row){
			jumpOneDatabaseInfo(row,'grid');
		},
		sortName:'TDatabaseName',
		sortOrder:'asc',
		toolbar:[{
			text:'Global信息',
			id:'t-tb-child',
			iconCls:'icon-arrow-right',
			handler:function(){
				var row=$('#t').datagrid('getSelected');
				if (row) jumpGlobalInfo(row,'grid');
			}
		},{
			text:'数据库变化',
			id:'t-tb-process',
			iconCls:'icon-arrow-right',
			handler:function(){
				var row=$('#t').datagrid('getSelected');
				if (row) jumpOneDatabaseProcessInfo(row,'grid');
			}
		}],
		onLoadSuccess:function(){
			debounced_dgSelectOnChange();
		},onSelect:debounced_dgSelectOnChange
		,onUnselect:debounced_dgSelectOnChange
		,onSelectAll:debounced_dgSelectOnChange
		,onUnselectAll:debounced_dgSelectOnChange
		
	})	
	///双击某条数据库
	var jumpOneDatabaseInfo=function(row,from){
		SMP_COMM.simpleChoice({
			width:500,height:300,msg:'请选择要打开的界面',
			items:[
				{text:'Global明细',id:'database-page-to-global'},
				{text:'DB变化记录',id:'database-page-to-process'}
			],onChoice:function(v){
				if(v.id=='database-page-to-global'){
					jumpGlobalInfo(row,from);
				}else{
					jumpOneDatabaseProcessInfo(row,from)
				}
			}
		});
		return;
	}
	//查看数据库采集历史变化
	var jumpOneDatabaseProcessInfo=function(row,from){
		var opts={
			id:'OneDatabaseInfo',
			title:row.TDatabaseName,
			url:'smp.onedatabaseinfo.csp?InitViewType='+from+'&DBName='+row.TDatabaseName+'&DBCollectId='+row.TId
		}
		SMP_COMM.showBread(opts);
	}
	///查看数据库采集Global明细
	var jumpGlobalInfo=function(row,from){
		var opts={
			id:'GlobalInfo',
			title:row.TDatabaseName+' Global', //'Global'+'('+row.TDay+' '+row.TTiming+')',
			url:'smp.globalinfo.csp?InitViewType='+from+'&DBName='+row.TDatabaseName+'&DBCollectId='+row.TId
		}
		SMP_COMM.showBread(opts);
	}
	var renderGrid=function(rows){
		$('#t').datagrid('clearSelections');
		debounced_dgSelectOnChange();
		$('#t').datagrid('loadData',rows);
	}
	var renderECharts=function(rows){
		//jqSelector元素选择器，xAxisType columns[{field,title,barWidth}],dateField,timeField,cateField,selectedMode
		SMP_COMM.renderSimpleEChart({
			jqSelector:'#c',
			xAxisType:'category',
			cateField:'TDatabaseName',
			selectedMode:'single',
			columns:[
				{field:'TSizeMB',title:'空间大小(MB)',barWidth: '40%'},
				{field:'TDataSizeMB',title:'数据大小(MB)',barWidth: '40%'},
				{field:'TGlobalCount',title:'Global数量',barWidth: '40%'}
			],
			rows:rows,
			onClick:function(o){
				console.log(o);
				jumpOneDatabaseInfo(rows[o.dataIndex],'echarts');
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
	SMP_COMM.simpleFilterInit(GV,'TDatabaseName',renderData);
	SMP_COMM.simpleToggleInit(GV,InitViewType,renderData);
};
$(init);