var GV={};
var init=function(){
	
	var data=$q({ClassName:'BSP.SMP.BL.DatabaseInfo',QueryName:'Find',rows:9999,latest:"1",summaryInfoId:SummaryInfoId,ResultSetType:'array'},function(rows){
		console.log(rows);
		$.each(rows,function(){
			this.TSizeMB=parseFloat(this.TSizeMB);
			this.TAvailableMB=parseFloat(this.TAvailableMB);
			this.TFreePercent=parseFloat(this.TFreePercent);
			this.TGlobalCount=parseFloat(this.TGlobalCount);
			this.TDataSizeMB=parseFloat(this.TDataSizeMB); //this.TSizeMB-this.TAvailableMB; //����ʵ�ʴ�С
			
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
		title:'���ݿ���Ϣ',
		rownumbers:true,
		striped:true,
		singleSelect:true,
		headerCls:'panel-header-gray',
		//bodyCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination:false,
		idField:'TId',
		columns:[[
			{field:"TDatabaseName",title:"���ݿ�",align:"left",width:150,sortable:true},
			{field:"TDirectory",title:"Ŀ¼",align:"left",width:350,sortable:true},
			{field:"TSizeMB",title:"��С(MB)",align:"left",width:80,sortable:true},
			{field:"TAvailableMB",title:"���ô�С(MB)",align:"left",width:100},
			{field:"TDataSizeMB",title:"���ݴ�С(MB)",align:"left",width:100,sortable:true},
			{field:"TFreePercent",title:"���аٷֱ�",align:"left",width:100,formatter:function(val){
				return val+'%';
			}},
			{field:"TBlockSize",title:"�����ݿ��С",align:"left",width:90},
			{field:"TDiskFreeSpace",title:"���̿��ÿռ�",align:"left",width:100},
			
			{field:"TResourceName",title:"��Դ",align:"left",width:130},
			
			{field:"TGlobalCount",title:"Global����",align:"left",width:100,sortable:true},
			
			{field:"TExpansionSize",title:"��չ��С",align:"left",width:100},
			{field:"TLastExpansionTime",title:"�ϴ���չʱ��",align:"left",width:150,formatter:function(val){
				return SMP_COMM.formatDate(val);	
			}},
			
			
			//{field:"TGlobalInfoDR",title:"TGlobalInfoDR",align:"left",width:100},
			{field:"TGlobalJournalState",title:"Journal��־",align:"left",width:100,formatter:function(val){
				return val==1?'��':'��';	
			}},
			
			{field:"TDay",title:"�ɼ�ʱ��",align:"left",width:150,formatter:function(val,row,ind){
				return val+' '+row['TTiming']||'';	
			}},
			{field:"TTimeSpendAlias",title:"�ɼ���ʱ",align:"left",width:100}
		]],
		data:{total:0,rows:[]},
		remoteSort:false,
		onDblClickRow:function(ind,row){
			jumpOneDatabaseInfo(row,'grid');
		},
		sortName:'TDatabaseName',
		sortOrder:'asc',
		toolbar:[{
			text:'Global��Ϣ',
			id:'t-tb-child',
			iconCls:'icon-arrow-right',
			handler:function(){
				var row=$('#t').datagrid('getSelected');
				if (row) jumpGlobalInfo(row,'grid');
			}
		},{
			text:'���ݿ�仯',
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
	///˫��ĳ�����ݿ�
	var jumpOneDatabaseInfo=function(row,from){
		SMP_COMM.simpleChoice({
			width:500,height:300,msg:'��ѡ��Ҫ�򿪵Ľ���',
			items:[
				{text:'Global��ϸ',id:'database-page-to-global'},
				{text:'DB�仯��¼',id:'database-page-to-process'}
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
	//�鿴���ݿ�ɼ���ʷ�仯
	var jumpOneDatabaseProcessInfo=function(row,from){
		var opts={
			id:'OneDatabaseInfo',
			title:row.TDatabaseName,
			url:'smp.onedatabaseinfo.csp?InitViewType='+from+'&DBName='+row.TDatabaseName+'&DBCollectId='+row.TId
		}
		SMP_COMM.showBread(opts);
	}
	///�鿴���ݿ�ɼ�Global��ϸ
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
		//jqSelectorԪ��ѡ������xAxisType columns[{field,title,barWidth}],dateField,timeField,cateField,selectedMode
		SMP_COMM.renderSimpleEChart({
			jqSelector:'#c',
			xAxisType:'category',
			cateField:'TDatabaseName',
			selectedMode:'single',
			columns:[
				{field:'TSizeMB',title:'�ռ��С(MB)',barWidth: '40%'},
				{field:'TDataSizeMB',title:'���ݴ�С(MB)',barWidth: '40%'},
				{field:'TGlobalCount',title:'Global����',barWidth: '40%'}
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