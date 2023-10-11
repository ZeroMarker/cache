var GV={};
var init=function(){
	
	var data=$q({ClassName:'BSP.SMP.BL.SummaryInfo',QueryName:'Find',rows:9999,ResultSetType:'array'},function(rows){
		console.log(rows);
		$.each(rows,function(){
			this.TAllDatabaseSizeGB=parseFloat(this.TAllDatabaseSizeGB);
			this.TDatabaseCount=parseInt(this.TDatabaseCount);
			this.TGlobalCount=parseInt(this.TGlobalCount);
			this.TId=parseInt(this.TId);
		})
		GV.rows=rows,GV.q="",GV.filterRows=rows;
		renderData(rows);
	})
	
	var dgSelectOnChange=function(){
		var rows=$('#t').datagrid('getSelections');
		console.log(rows.length);
		if(rows.length>0){
			$('#t-tb-child').linkbutton('enable');
			
		}else{
			$('#t-tb-child').linkbutton('disable');
		}
		if(rows.length>1){
			$('#t-tb-diff').linkbutton('enable');
			
		}else{
			$('#t-tb-diff').linkbutton('disable');
		}
		
	}
	var debounced_dgSelectOnChange=SMP_COMM.debounce(dgSelectOnChange,200);
	
	$('#t').datagrid({
		fit:true,
		//fitColumns:true,
		title:'采集信息记录',
		rownumbers:true,
		striped:true,
		singleSelect:false,
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		idField:'TId',
		view:scrollview,
		pagination:true,
		pageSize:30,
		//TId,TAllDatabaseSizeGB,TCollectDate,TCollectTime,TCollectType,TCollectTypeDesc,TDatabaseCount,TDatabaseName,TGlobalCount,TIsCompleteFlag,TIsDatabaseDetailExist,TThisInfoCostTimeAlias,TThisInfoCostTimeSecond
		columns:[[	
			{field:'ck',checkbox:'true'},
			{field:"TId",sortable:'true',title:"采集时间",align:"left",width:150,formatter:function(val,row,ind){
				return row['TCollectDate']+' '+row['TCollectTime']||'';	
			}},
			{field:"TDatabaseCount",title:"数据库数量",align:"left",width:80},
			{field:"TAllDatabaseSizeGB",title:"数据库总大小(GB)",align:"left",width:120},
			{field:"TGlobalCount",title:"Global数量",align:"left",width:80},
			{field:"TCollectTypeDesc",title:"采集类型",align:"left",width:300},
			{field:"TThisInfoCostTimeAlias",title:"采集耗时",align:"left",width:80},
			{field:"TIsCompleteFlag",title:"是否完成",align:"left",width:80,formatter:function(val){
				return val==1?'是':'否';	
			}}
		]],
		data:{total:0,rows:[]},
		remoteSort:false,
		onDblClickRow:function(ind,row){
			jumpDatabaseInfo(row,'grid');
		},
		sortName:'TId',
		sortOrder:'desc',
		toolbar:[{
			text:'数据库信息',
			id:'t-tb-child',
			iconCls:'icon-arrow-right',
			handler:function(){
				var row=$('#t').datagrid('getSelected');
				if (row) jumpDatabaseInfo(row,'grid');
			}
		},{
			text:'对比',
			id:'t-tb-diff',
			iconCls:'icon-lt-rt-55',
			handler:function(){
				var rows=$('#t').datagrid('getSelections');
				if (rows.length>2){ //超过两条 弹出提示
					$.messager.confirm('提示','您选择的行超过两条,只会对比采集日期靠后的两条,是否继续？',function(r){
						if(r) jumpDatabaseInfoDiff(rows,'grid');
					})
				}else{
					jumpDatabaseInfoDiff(rows,'grid');
				}
			}
		}],
		onLoadSuccess:function(){
			debounced_dgSelectOnChange();
		},onSelect:debounced_dgSelectOnChange
		,onUnselect:debounced_dgSelectOnChange
		,onSelectAll:debounced_dgSelectOnChange
		,onUnselectAll:debounced_dgSelectOnChange
		
	})
	var jumpDatabaseInfoDiff=function(rows,from){
		var rows=$('#t').datagrid('getSelections');
		var cloneRows=[].concat(rows);
		if (cloneRows.length>1){
			cloneRows.sort(function(a,b){
				if(a.TId==b.TId) return 0;
				if(a.TId<b.TId) return -1;
				return 1;
			})
			var opts={
				id:'DatabaseInfoDiff',
				title:'数据库信息对比'+'('+cloneRows[0].TCollectDate+' '+cloneRows[0].TCollectTime+'，'+cloneRows[1].TCollectDate+' '+cloneRows[1].TCollectTime+')',
				url:'smp.databaseinfodiff.csp?InitViewType='+from+'&SummaryInfoId1='+cloneRows[0].TId+'&SummaryInfoId2='+cloneRows[1].TId
			}
			SMP_COMM.showBread(opts);
		}
	}	
	var jumpDatabaseInfo=function(row,from){
		var opts={
			id:'DatabaseInfo',
			title:'数据库信息'+'('+row.TCollectDate+' '+row.TCollectTime+')',
			url:'smp.databaseinfo.csp?InitViewType='+from+'&SummaryInfoId='+row.TId
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
			xAxisType:'time',
			dateField:'TCollectDate',
			timeField:'TCollectTime',
			selectedMode:'single',
			columns:[
				{field:'TAllDatabaseSizeGB',title:'空间大小(GB)',barWidth: '40%'},
				{field:'TDatabaseCount',title:'数据库数量',barWidth: '40%'},
				{field:'TGlobalCount',title:'Global数量',barWidth: '40%'}
			],
			rowFilter:function(row,field){
				return row.TCollectType!='' &&'111,110,999,998'.indexOf(row.TCollectType)>-1
			},
			rows:rows,
			onClick:function(o){
				console.log(o);
				jumpDatabaseInfo(rows[o.dataIndex],'echarts');
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