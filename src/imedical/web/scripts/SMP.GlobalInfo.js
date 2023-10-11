var GV={};
var init=function(){
	if(InitViewType=="echarts") $('#c-wraper').show();
	var data=$q({ClassName:'BSP.SMP.BL.GlobalInfo',QueryName:'Find',rows:9999,latest:"1",pid:DBCollectId,ResultSetType:'array'},function(rows){
		console.log(rows);
		$.each(rows,function(){
			this.TAllocatedSizeMb=parseFloat(this.TAllocatedSizeMb);
			this.TUsedSizeMb=parseFloat(this.TUsedSizeMb);
			
		})
		GV.rows=rows,GV.q="",GV.filterRows=rows;
		renderData(rows);
	})
	
	var dgSelectOnChange=function(){
		var rows=$('#t').datagrid('getSelections');
		console.log(rows.length);
		if(rows.length>0){
			$('#t-tb-process').linkbutton('enable');
		}else{
			$('#t-tb-process').linkbutton('disable');
		}
		
	}
	var debounced_dgSelectOnChange=SMP_COMM.debounce(dgSelectOnChange,200);
	
	
	$('#t').datagrid({
		fit:true,
		fixRowNumber:true,
		//fitColumns:true,
		title:DBName+' Global信息',
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
			{field:"TGlobalName",title:"Global",align:"left",width:400,sortable:true},
			{field:"TAllocatedSizeMb",title:"占用空间(MB)",align:"left",width:100,sortable:true},
			{field:"TUsedSizeMb",title:"实际使用(MB)",align:"left",width:100,sortable:true},
			{field:"TEarlyRefenceData",title:"最早引用日期",align:"left",width:100,sortable:true},
			{field:"TLastRefenceData",title:"最近引用日期",align:"left",width:100,sortable:true},
			{field:"TType",title:"类型",align:"left",width:100},
			{field:"TInWhiteList",title:"白名单",align:"left",width:100,formatter:function(val){
				return val==1?'是':'否';
			}},
			{field:"TDay",title:"采集时间",align:"left",width:150,formatter:function(val,row,ind){
				return val+' '+row['TTiming']||'';	
			}}
		]],
		data:{total:0,rows:[]},
		remoteSort:false,
		onDblClickRow:function(ind,row){
			jumpOneGlobalInfo(row,'grid');
		},
		sortName:'TGlobalName',
		sortOrder:'asc',
		toolbar:[{
			text:'Global变化',
			id:'t-tb-process',
			iconCls:'icon-arrow-right',
			handler:function(){
				var row=$('#t').datagrid('getSelected');
				if (row) jumpOneGlobalInfo(row,'grid');
			}
		}],
		onLoadSuccess:function(){
			debounced_dgSelectOnChange();
		},onSelect:debounced_dgSelectOnChange
		,onUnselect:debounced_dgSelectOnChange
		,onSelectAll:debounced_dgSelectOnChange
		,onUnselectAll:debounced_dgSelectOnChange
		
	})	
	var jumpOneGlobalInfo=function(row,from){
		var opts={
			id:'OneGlobalInfo',
			title:row.TGlobalName,
			url:'smp.oneglobalinfo.csp?InitViewType='+from+'&DBName='+row.TDatabaseName+'&GlobalName='+row.TGlobalName
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
			cateField:'TGlobalName',
			columns:[
				{field:'TAllocatedSizeMb',title:'占用空间(MB)',barWidth: '30%'},
				{field:'TUsedSizeMb',title:'实际使用(MB)',barWidth: '30%'}
			],
			rows:rows,
			onClick:function(o){
				console.log(o);
				jumpOneGlobalInfo(rows[o.dataIndex],'echarts');
			},
			dataZoom: [
		        {
		            type: 'slider',
		            start:0,
		            end:rows.length<=30?100:(30/(rows.length)*100)
		        }
		    ]
		})
	}
	var renderData=function(rows){
		if ($('#c-wraper').is(':visible')) {
			renderECharts(rows);	
		}else{
			renderGrid(rows);
		}
	}
	SMP_COMM.simpleFilterInit(GV,'TGlobalName',renderData);
	SMP_COMM.simpleToggleInit(GV,InitViewType,renderData);
};
$(init);