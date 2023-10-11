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
		title:'�ɼ���Ϣ��¼',
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
			{field:"TId",sortable:'true',title:"�ɼ�ʱ��",align:"left",width:150,formatter:function(val,row,ind){
				return row['TCollectDate']+' '+row['TCollectTime']||'';	
			}},
			{field:"TDatabaseCount",title:"���ݿ�����",align:"left",width:80},
			{field:"TAllDatabaseSizeGB",title:"���ݿ��ܴ�С(GB)",align:"left",width:120},
			{field:"TGlobalCount",title:"Global����",align:"left",width:80},
			{field:"TCollectTypeDesc",title:"�ɼ�����",align:"left",width:300},
			{field:"TThisInfoCostTimeAlias",title:"�ɼ���ʱ",align:"left",width:80},
			{field:"TIsCompleteFlag",title:"�Ƿ����",align:"left",width:80,formatter:function(val){
				return val==1?'��':'��';	
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
			text:'���ݿ���Ϣ',
			id:'t-tb-child',
			iconCls:'icon-arrow-right',
			handler:function(){
				var row=$('#t').datagrid('getSelected');
				if (row) jumpDatabaseInfo(row,'grid');
			}
		},{
			text:'�Ա�',
			id:'t-tb-diff',
			iconCls:'icon-lt-rt-55',
			handler:function(){
				var rows=$('#t').datagrid('getSelections');
				if (rows.length>2){ //�������� ������ʾ
					$.messager.confirm('��ʾ','��ѡ����г�������,ֻ��ԱȲɼ����ڿ��������,�Ƿ������',function(r){
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
				title:'���ݿ���Ϣ�Ա�'+'('+cloneRows[0].TCollectDate+' '+cloneRows[0].TCollectTime+'��'+cloneRows[1].TCollectDate+' '+cloneRows[1].TCollectTime+')',
				url:'smp.databaseinfodiff.csp?InitViewType='+from+'&SummaryInfoId1='+cloneRows[0].TId+'&SummaryInfoId2='+cloneRows[1].TId
			}
			SMP_COMM.showBread(opts);
		}
	}	
	var jumpDatabaseInfo=function(row,from){
		var opts={
			id:'DatabaseInfo',
			title:'���ݿ���Ϣ'+'('+row.TCollectDate+' '+row.TCollectTime+')',
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
		//jqSelectorԪ��ѡ������xAxisType columns[{field,title,barWidth}],dateField,timeField,cateField,selectedMode
		SMP_COMM.renderSimpleEChart({
			jqSelector:'#c',
			xAxisType:'time',
			dateField:'TCollectDate',
			timeField:'TCollectTime',
			selectedMode:'single',
			columns:[
				{field:'TAllDatabaseSizeGB',title:'�ռ��С(GB)',barWidth: '40%'},
				{field:'TDatabaseCount',title:'���ݿ�����',barWidth: '40%'},
				{field:'TGlobalCount',title:'Global����',barWidth: '40%'}
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