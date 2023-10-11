var GV={};
var init=function(){
	function getDiffData(summArr,callback){
		if (!summArr || summArr.length==0){
			 callback([]);
			 return;
		}
		var temp=[];
		function getOne(ind){
			var SummaryInfoId=summArr[ind];
			$q({ClassName:'BSP.SMP.BL.DatabaseInfo',QueryName:'Find',rows:9999,latest:"",summaryInfoId:SummaryInfoId,ResultSetType:'array'},function(rows){
				console.log(rows);
				$.each(rows,function(i,row){
					row.TSizeMB=parseFloat(row.TSizeMB);
					row.TAvailableMB=parseFloat(row.TAvailableMB);
					row.TFreePercent=parseFloat(row.TFreePercent);
					row.TGlobalCount=parseFloat(row.TGlobalCount);
					row.TDataSizeMB=parseFloat(row.TDataSizeMB); //row.TSizeMB-row.TAvailableMB; //数据实际大小
					
					var newRow={}
					for (var j in row){
						newRow[j+''+(ind+1)]=row[j];
					}
					
					if (!temp[row.TDatabaseName]) {
						temp[row.TDatabaseName]=$.extend({TDatabaseName:newRow['TDatabaseName'+(ind+1)],TDirectory:newRow['TDirectory'+(ind+1)]},newRow);
					}else {
						$.extend(temp[row.TDatabaseName],newRow);
					}
					
				})
				
				if (ind==summArr.length-1) { //最后一个了
					var ret=[];
					for (var i in temp){
						ret.push(temp[i]);
					}
					callback(ret);
				}else{
					getOne(ind+1);
				}
				
			})
		}
		getOne(0);

	}
	
	getDiffData([SummaryInfoId1,SummaryInfoId2],function(rows){
		GV.rows=rows,GV.q="",GV.filterRows=rows;
		renderData(rows);
	})

	
	var cUp='\u2191',
		cDown='\u2193',
		upHtml='<span class="dg-cell-up">'+cUp+'</span>',
		downHtml='<span class="dg-cell-down">'+cDown+'</span>',
		newHtml='<span class="dg-cell-new">'+cUp+cUp+'</span>',
		deleteHtml='<span class="dg-cell-delete">'+cDown+cDown+'</span>',
		equalHtml='<span class="dg-cell-equal">=</span>';
		
	function diffCellFormatter(val,row,field1,field2,fieldType){
		if (typeof row[field1]=='undefined'){ //原本没有
			return val+newHtml;
		}else{
			if (typeof row[field2]=='undefined'){ //删除
				return ''+deleteHtml;
			}else{
				
				return val+(row[field2]>row[field1]?upHtml:(row[field2]==row[field1]?equalHtml:downHtml));
			}
		}
	}
	
	var dgSelectOnChange=function(){
		var rows=$('#t').datagrid('getSelections');
		console.log(rows.length);
		if(rows.length>0){
			$('#t-tb-child').linkbutton('enable');
		}else{
			$('#t-tb-child').linkbutton('disable');
		}
		
	}
	var debounced_dgSelectOnChange=SMP_COMM.debounce(dgSelectOnChange,200);
		
	$('#t').datagrid({
		fit:true,
		//fitColumns:true,
		title:'数据库对比信息',
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
			{field:"TSizeMB1",title:"大小(MB)1",align:"left",width:80,sortable:true},
			{field:"TSizeMB2",title:"大小(MB)2",align:"left",width:80,sortable:true,formatter:function(val,row){
				return diffCellFormatter(val,row,'TSizeMB1','TSizeMB2')
			}},
			{field:"TDataSizeMB1",title:"数据大小(MB)1",align:"left",width:100,sortable:true},
			{field:"TDataSizeMB2",title:"数据大小(MB)2",align:"left",width:100,sortable:true,formatter:function(val,row){
				return diffCellFormatter(val,row,'TDataSizeMB1','TDataSizeMB2')
			}},
			{field:"TAvailableMB1",title:"可用大小(MB)1",align:"left",width:100},
			{field:"TAvailableMB2",title:"可用大小(MB)2",align:"left",width:100,formatter:function(val,row){
				return diffCellFormatter(val,row,'TAvailableMB1','TAvailableMB2')
			}},
			{field:"TGlobalCount1",title:"Global数量1",align:"left",width:100,sortable:true},
			{field:"TGlobalCount2",title:"Global数量2",align:"left",width:100,sortable:true,formatter:function(val,row){
				return diffCellFormatter(val,row,'TGlobalCount1','TGlobalCount2')
			}}
			
			/*{field:"TBlockSize",title:"单数据块大小",align:"left",width:90},
			{field:"TDiskFreeSpace",title:"磁盘可用空间",align:"left",width:100},
			{field:"TResourceName",title:"资源",align:"left",width:130},
			
			
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
			{field:"TTimeSpendAlias",title:"采集用时",align:"left",width:100}*/
		]],
		data:{total:0,rows:[]},
		remoteSort:false,
		onDblClickRow:function(ind,row){
			jumpOneDatabaseInfo(row,'grid');
		},
		sortName:'TDatabaseName',
		sortOrder:'asc',
		toolbar:[{
			text:'Global信息对比',
			id:'t-tb-child',
			iconCls:'icon-arrow-right',
			handler:function(){
				var row=$('#t').datagrid('getSelected');
				if (row) jumpOneDatabaseInfo(row,'grid');
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
		jumpGlobalInfo(row,from);
	}

	///查看数据库采集Global明细
	var jumpGlobalInfo=function(row,from){
		var opts={
			id:'GlobalInfo',
			title:row.TDatabaseName+' Global对比', //'Global'+'('+row.TDay+' '+row.TTiming+')',
			url:'smp.globalinfodiff.csp?InitViewType='+from+'&DBName='+row.TDatabaseName+'&DBCollectId1='+row.TId1+'&DBCollectId2='+row.TId2
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
			//selectedMode:'single',
			columns:[
				{field:'TSizeMB1',title:'空间大小(MB)1',barWidth: '30%'},
				{field:'TSizeMB2',title:'空间大小(MB)2',barWidth: '30%'},
				{field:'TDataSizeMB1',title:'数据大小(MB)1',barWidth: '30%',selected:false},
				{field:'TDataSizeMB2',title:'数据大小(MB)2',barWidth: '30%',selected:false},
				{field:'TGlobalCount1',title:'Global数量1',barWidth: '30%',selected:false},
				{field:'TGlobalCount2',title:'Global数量2',barWidth: '30%',selected:false}
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