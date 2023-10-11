var GV={};
var init=function(){
	
	var data=$q({ClassName:'BSP.SMP.BL.DatabaseInfo',QueryName:'Find',rows:9999,latest:"0",dbName:DBName,ResultSetType:'array'},function(rows){
		console.log(rows);
		$.each(rows,function(){
			this.TSizeMB=parseFloat(this.TSizeMB);
			this.TAvailableMB=parseFloat(this.TAvailableMB);
			this.TFreePercent=parseFloat(this.TFreePercent);
			this.TGlobalCount=parseFloat(this.TGlobalCount);
			this.TDataSizeMB=parseFloat(this.TDataSizeMB); //this.TSizeMB-this.TAvailableMB; //����ʵ�ʴ�С
			this.TId=parseInt(this.TId);
			
		})
		GV.rows=rows,GV.q="",GV.filterRows=rows;
		renderData(rows);
	})
	
	$('#t').datagrid({
		fit:true,
		//fitColumns:true,
		title:DBName+' ���ݿ�仯��Ϣ',
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
			{field:"TId",sortable:'true',title:"�ɼ�ʱ��",align:"left",width:150,formatter:function(val,row,ind){
				return row['TDay']+' '+row['TTiming']||'';	
			}},
			{field:"TDatabaseName",title:"���ݿ�",align:"left",width:150},
			{field:"TDirectory",title:"Ŀ¼",align:"left",width:350},
			{field:"TSizeMB",title:"��С(MB)",align:"left",width:80},
			{field:"TAvailableMB",title:"���ô�С(MB)",align:"left",width:100},
			{field:"TDataSizeMB",title:"���ݴ�С(MB)",align:"left",width:100},
			{field:"TFreePercent",title:"���аٷֱ�",align:"left",width:100,formatter:function(val){
				return val+'%';
			}},
			{field:"TBlockSize",title:"�����ݿ��С",align:"left",width:90},
			{field:"TDiskFreeSpace",title:"���̿��ÿռ�",align:"left",width:100},
			
			{field:"TResourceName",title:"��Դ",align:"left",width:130},
			
			{field:"TGlobalCount",title:"Global����",align:"left",width:100},
			
			{field:"TExpansionSize",title:"��չ��С",align:"left",width:100},
			{field:"TLastExpansionTime",title:"�ϴ���չʱ��",align:"left",width:150,formatter:function(val){
				return SMP_COMM.formatDate(val);	
			}},
			
			
			//{field:"TGlobalInfoDR",title:"TGlobalInfoDR",align:"left",width:100},
			{field:"TGlobalJournalState",title:"Journal��־",align:"left",width:100,formatter:function(val){
				return val==1?'��':'��';	
			}},
			{field:"TTimeSpendAlias",title:"�ɼ���ʱ",align:"left",width:100}
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
		//��ʱ���ôӴ˵���Global��ϸȥ��
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
		//jqSelectorԪ��ѡ������xAxisType columns[{field,title,barWidth}],dateField,timeField,cateField,selectedMode
		SMP_COMM.renderSimpleEChart({
			jqSelector:'#c',
			xAxisType:'time',
			dateField:'TDay',
			timeField:'TTiming',
			selectedMode:'single',
			columns:[
				{field:'TSizeMB',title:'�ռ��С(MB)',barWidth: '40%'},
				{field:'TDataSizeMB',title:'���ݴ�С(MB)',barWidth: '40%'},
				{field:'TGlobalCount',title:'Global����',barWidth: '40%'}
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