var GV={};
var init=function(){
	if(InitViewType=="echarts") $('#c-wraper').show();
	
	function getDiffData(dbCollArr,callback){
		if (!dbCollArr || dbCollArr.length==0){
			 callback([]);
			 return;
		}
		var temp=[];
		function getOne(ind){
			var DBCollectId=dbCollArr[ind];
			$q({ClassName:'BSP.SMP.BL.GlobalInfo',QueryName:'Find',rows:9999,latest:"",pid:DBCollectId,ResultSetType:'array'},function(rows){
				console.log(rows);
				$.each(rows,function(i,row){
					row.TAllocatedSizeMb=parseFloat(row.TAllocatedSizeMb);
					row.TUsedSizeMb=parseFloat(row.TUsedSizeMb);
					
					var newRow={}
					for (var j in row){
						newRow[j+''+(ind+1)]=row[j];
					}
					
					if (!temp[row.TGlobalName]) {
						temp[row.TGlobalName]=$.extend({TGlobalName:row.TGlobalName},newRow);
					}else {
						$.extend(temp[row.TGlobalName],newRow);
					}
					
				})
				
				if (ind==dbCollArr.length-1) { //最后一个了
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
	
	getDiffData([DBCollectId1,DBCollectId2],function(rows){
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
			{field:"TAllocatedSizeMb1",title:"占用空间(MB)1",align:"left",width:120,sortable:true},
			{field:"TAllocatedSizeMb2",title:"占用空间(MB)2",align:"left",width:120,sortable:true,formatter:function(val,row){
				return diffCellFormatter(val,row,'TAllocatedSizeMb1','TAllocatedSizeMb2')
			}},
			{field:"TUsedSizeMb1",title:"实际使用(MB)1",align:"left",width:120,sortable:true},
			{field:"TUsedSizeMb2",title:"实际使用(MB)2",align:"left",width:120,sortable:true,formatter:function(val,row){
				return diffCellFormatter(val,row,'TUsedSizeMb1','TUsedSizeMb2')
			}},
			{field:"TInWhiteList1",title:"白名单1",align:"left",width:100,formatter:function(val){
				return val==1?'是':'否';
			}},
			{field:"TInWhiteList2",title:"白名单2",align:"left",width:100,formatter:function(val){
				return val==1?'是':'否';
			}}
		]],
		data:{total:0,rows:[]},
		remoteSort:false,
		onDblClickRow:function(ind,row){
			jumpOneGlobalInfo(row,'grid');
		},
		sortName:'TGlobalName',
		sortOrder:'asc'
		
	})	
	var jumpOneGlobalInfo=function(row,from){
		return ; //
		var opts={
			id:'OneGlobalInfo',
			title:row.TGlobalName,
			url:'smp.oneglobalinfo.csp?InitViewType='+from+'&DBName='+row.TDatabaseName+'&GlobalName='+row.TGlobalName
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
			xAxisType:'category',
			cateField:'TGlobalName',
			columns:[
				{field:'TAllocatedSizeMb1',title:'占用空间(MB)1',barWidth: '30%'},
				{field:'TAllocatedSizeMb2',title:'占用空间(MB)2',barWidth: '30%'},
				{field:'TUsedSizeMb1',title:'实际使用(MB)1',barWidth: '30%',selected:false},
				{field:'TUsedSizeMb2',title:'实际使用(MB)2',barWidth: '30%',selected:false}
				
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