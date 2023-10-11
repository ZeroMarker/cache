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
					row.TDataSizeMB=parseFloat(row.TDataSizeMB); //row.TSizeMB-row.TAvailableMB; //����ʵ�ʴ�С
					
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
				
				if (ind==summArr.length-1) { //���һ����
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
		if (typeof row[field1]=='undefined'){ //ԭ��û��
			return val+newHtml;
		}else{
			if (typeof row[field2]=='undefined'){ //ɾ��
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
		title:'���ݿ�Ա���Ϣ',
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
			{field:"TSizeMB1",title:"��С(MB)1",align:"left",width:80,sortable:true},
			{field:"TSizeMB2",title:"��С(MB)2",align:"left",width:80,sortable:true,formatter:function(val,row){
				return diffCellFormatter(val,row,'TSizeMB1','TSizeMB2')
			}},
			{field:"TDataSizeMB1",title:"���ݴ�С(MB)1",align:"left",width:100,sortable:true},
			{field:"TDataSizeMB2",title:"���ݴ�С(MB)2",align:"left",width:100,sortable:true,formatter:function(val,row){
				return diffCellFormatter(val,row,'TDataSizeMB1','TDataSizeMB2')
			}},
			{field:"TAvailableMB1",title:"���ô�С(MB)1",align:"left",width:100},
			{field:"TAvailableMB2",title:"���ô�С(MB)2",align:"left",width:100,formatter:function(val,row){
				return diffCellFormatter(val,row,'TAvailableMB1','TAvailableMB2')
			}},
			{field:"TGlobalCount1",title:"Global����1",align:"left",width:100,sortable:true},
			{field:"TGlobalCount2",title:"Global����2",align:"left",width:100,sortable:true,formatter:function(val,row){
				return diffCellFormatter(val,row,'TGlobalCount1','TGlobalCount2')
			}}
			
			/*{field:"TBlockSize",title:"�����ݿ��С",align:"left",width:90},
			{field:"TDiskFreeSpace",title:"���̿��ÿռ�",align:"left",width:100},
			{field:"TResourceName",title:"��Դ",align:"left",width:130},
			
			
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
			{field:"TTimeSpendAlias",title:"�ɼ���ʱ",align:"left",width:100}*/
		]],
		data:{total:0,rows:[]},
		remoteSort:false,
		onDblClickRow:function(ind,row){
			jumpOneDatabaseInfo(row,'grid');
		},
		sortName:'TDatabaseName',
		sortOrder:'asc',
		toolbar:[{
			text:'Global��Ϣ�Ա�',
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
	///˫��ĳ�����ݿ�
	var jumpOneDatabaseInfo=function(row,from){
		jumpGlobalInfo(row,from);
	}

	///�鿴���ݿ�ɼ�Global��ϸ
	var jumpGlobalInfo=function(row,from){
		var opts={
			id:'GlobalInfo',
			title:row.TDatabaseName+' Global�Ա�', //'Global'+'('+row.TDay+' '+row.TTiming+')',
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
		//jqSelectorԪ��ѡ������xAxisType columns[{field,title,barWidth}],dateField,timeField,cateField,selectedMode
		SMP_COMM.renderSimpleEChart({
			jqSelector:'#c',
			xAxisType:'category',
			cateField:'TDatabaseName',
			//selectedMode:'single',
			columns:[
				{field:'TSizeMB1',title:'�ռ��С(MB)1',barWidth: '30%'},
				{field:'TSizeMB2',title:'�ռ��С(MB)2',barWidth: '30%'},
				{field:'TDataSizeMB1',title:'���ݴ�С(MB)1',barWidth: '30%',selected:false},
				{field:'TDataSizeMB2',title:'���ݴ�С(MB)2',barWidth: '30%',selected:false},
				{field:'TGlobalCount1',title:'Global����1',barWidth: '30%',selected:false},
				{field:'TGlobalCount2',title:'Global����2',barWidth: '30%',selected:false}
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