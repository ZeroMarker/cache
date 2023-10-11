

function initBreadcrumb(){
	var fixPanelSize=function(){
		var panelHeight=$(window).height()-$('.breadcrumb').outerHeight()-30-2;
		$('.breadcrumb-panels').outerHeight(panelHeight);
		$('.breadcrumb-panels').find('.panel').triggerHandler('_resize');
	}
	var debounced_fixPanelSize=SMP_COMM.debounce(fixPanelSize,200);
	$(window).resize(debounced_fixPanelSize);
	fixPanelSize();
	$('.breadcrumb').on('click','.secondBread>a',function(){
		var id=$(this).parent().attr('id').split('-bread')[0];
		showBread(id);
	})
	function showBread(opts){
		var $breadcrumb=$('.breadcrumb'),$panels=$('.breadcrumb-panels');
		if (typeof opts=="string") opts={id:opts} ;
		if (!opts || !opts.id ) return;

		var id=opts.id,
			breadSelector='#'+id.escapeJquery()+'-bread',
			breadPanelSelector='#'+id.escapeJquery()+'-bread-panel',
			title=opts.title,
			content=opts.content||'<iframe src="'+opts.url+'" scrolling="auto" frameborder=0 style="width:100%;height:100%;"></iframe>';
		
		//如果没有此面包屑 或者要强制修改面包屑   需要内容
		if (($(breadSelector).length==0 || opts.force)&&(!opts.title || (!opts.url&&!opts.content))) return;

		if ($(breadSelector).length>0){
			var selectors=[];
			var nextAll=$(breadSelector).nextAll();
			if (nextAll.length>0){
				nextAll.each(function(){
					selectors.push('#'+this.id.escapeJquery());
					selectors.push('#'+this.id.escapeJquery()+'-panel');
				})
				$(selectors.join(',')).remove();
			}
			if (!$(breadPanelSelector).hasClass('active')) $(breadPanelSelector).addClass('active');
			if (opts.force) $(breadPanelSelector).html(content);
			
		}else{
			$panels.find('.breadcrumb-panel.active').removeClass('active');
			var $bread=$('<li class="secondBread" id="'+id+'-bread"><a href="javascript:void(0);" >'+title+'</a></li>').appendTo($breadcrumb);
			var $panel=$('<div class="breadcrumb-panel active" id="'+id+'-bread-panel" ></div>').appendTo($panels);
			$panel.html(content);
		}
	}
	window.showBread=showBread;
	window.isIndexPage=true;
}


function initTodoList(){
	$q({ClassName:'BSP.SMP.BL.Event',QueryName:'QryEventCount',rows:9999,ResultSetType:'array'},function(rows){
		console.log(rows);
		renderTodoList(rows);
	})
	function renderTodoList(rows){
		$.each(rows,function(ind,item){
			$('<div data-code="'+item.EventType+'" data-title="'+item.EventTypeDesc+'" class="todo-list-item">\
				<a href="javascript:void(0);">\
					<img src="../scripts_lib/hisui-0.1.0/dist/css/icons/big/paper_time.png">\
					<span class="notice">'+item.EventTypeCount+'</span>\
				</a>\
				<div>'+item.EventTypeDesc+'</div>\
			</div>').appendTo('#todolist');
		})
		$('#todolist').on('click','.todo-list-item>a',function(){
			var t=$(this).closest('.todo-list-item');
			var code=t.data('code'),title=t.data('title');
			SMP_COMM.simpleModal(title,'smp.eventlist.csp?AuditFlag=N&EventType='+code,1400,600,null,{onClose:function(){
				$q({ClassName:'BSP.SMP.BL.Event',QueryName:'QryEventCount',rows:9999,ResultSetType:'array'},function(rows){
					$.each(rows,function(ind,item){
						$('.todo-list-item[data-code="'+item.EventType+'"]').find('.notice').text(item.EventTypeCount);
					})
				})
			}})
			
		})
	}
}

function initIndexChartSummary(){
	$.q2({ClassName:'BSP.SMP.BL.SummaryInfo',QueryName:'Find',
		rows:9999,ResultSetType:'array',showFields:'TCollectDate,TCollectTime,TAllDatabaseSizeGB,TDatabaseCount,TGlobalCount,TCollectType'
	},function(rows){
		console.log(rows);
		$.each(rows,function(){
			this.TAllDatabaseSizeGB=parseFloat(this.TAllDatabaseSizeGB);
			this.TDatabaseCount=parseInt(this.TDatabaseCount);
			this.TGlobalCount=parseInt(this.TGlobalCount);
		})
		//jqSelector元素选择器，xAxisType columns[{field,title,barWidth}],dateField,timeField,cateField,selectedMode
		SMP_COMM.renderSimpleEChart({
			jqSelector:'#index-chart-summary-c',
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
			},
			grid:{
		        left: '10px',
		        right: '10px',
		        bottom: '0px',
		        containLabel: true
		    }
		})
		
		
	})
}

function getDatabasesTimeData(dbArr,field,callback){
	if (!dbArr || dbArr.length==0) {
		callback([]);
		return;
	}
	var temp={};
	function getOne(ind){
		var dbName=dbArr[ind];
		$.q2({ClassName:'BSP.SMP.BL.DatabaseInfo',QueryName:'Find',
			rows:9999,ResultSetType:'array',showFields:'TDay,TTiming,'+field,
			latest:"0",dbName:dbName
		},function(rows){
			$.each(rows,function(i,row){
				if (temp[row.TDay+row.TTiming]) {
					temp[row.TDay+row.TTiming][dbName]=parseFloat(row[field]);
				}else {
					temp[row.TDay+row.TTiming]={TDay:row.TDay,TTiming:row.TTiming};
					temp[row.TDay+row.TTiming][dbName]=parseFloat(row[field]);
				}
			})
			
			if (ind==dbArr.length-1) { //最后一个数据库了
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


function initIndexChartDbtop5(){
	var state={};
	function show(field){
		$('#index-chart-dbtop5-c-'+field).siblings().hide();
		$('#index-chart-dbtop5-c-'+field).show();
		if (state[field] && state[field].inited) return; //已经加载过的图
		
		$.q2({ClassName:'BSP.SMP.BL.DatabaseInfo',QueryName:'Find'
			,ResultSetType:'array',rows:5,sort:field,order:'desc',orderType:'number',showFields:'TDatabaseName'
			,latest:"1"
		},function(rows){
			var dbArr=rows.map(function(row){return row.TDatabaseName});
			
			console.log(dbArr);
			getDatabasesTimeData(dbArr,field,function(lineRows){
				var columns={}
				SMP_COMM.renderSimpleEChart({
					jqSelector:'#index-chart-dbtop5-c-'+field,
					xAxisType:'time',
					dateField:'TDay',
					timeField:'TTiming',
					//selectedMode:'single',
					columns:dbArr.map(function(item){return {field:item,title:item,barWidth:'40%'}}),
					rows:lineRows,
					onClick:function(o){
						console.log(o);
					},
					grid:{
				        left: '10px',
				        right: '10px',
				        bottom: '0px',
				        containLabel: true
				    }
				})
				state[field]={inited:true};
				
			}) //end getDatabasesTimeData
			
		})
	}
	show('TSizeMB');
	$('#index-chart-dbtop5-p').find('a.left,a.right').on('click',function(){
		var t=$(this);
		var field=t.hasClass('left')?'TSizeMB':'TDataSizeMB';
		if(!t.parent().hasClass('active')){
			t.parent().siblings().removeClass('active');
			t.parent().addClass('active');
			show(field);
		}
		
	})
}

function initIndexChartDbfocus(){
	var state={};
	function show(field){
		$('#index-chart-dbfocus-c-'+field).siblings().hide();
		$('#index-chart-dbfocus-c-'+field).show();
		if (state[field] && state[field].inited) return; //已经加载过的图
		
		$.q2({ClassName:'CF.BSP.SMP.Comm',QueryName:'Find'
			,ResultSetType:'array',rows:999
			,Type:'DBFocus',IsPar:0,Active:1
		},function(rows){
			var dbArr=[];
			rows.map(function(row){if (row.TValue=='1')dbArr.push(row.TCode)});
			
			console.log(dbArr);
			getDatabasesTimeData(dbArr,field,function(lineRows){
				var columns={}
				SMP_COMM.renderSimpleEChart({
					jqSelector:'#index-chart-dbfocus-c-'+field,
					xAxisType:'time',
					dateField:'TDay',
					timeField:'TTiming',
					//selectedMode:'single',
					columns:dbArr.map(function(item){return {field:item,title:item,barWidth:'40%'}}),
					rows:lineRows,
					onClick:function(o){
						console.log(o);
					},
					grid:{
				        left: '10px',
				        right: '10px',
				        bottom: '0px',
				        containLabel: true
				    }
				})
				state[field]={inited:true};
				
			}) //end getDatabasesTimeData
			
		})
	}
	show('TSizeMB');
	$('#index-chart-dbfocus-p').find('a.left,a.right').on('click',function(){
		var t=$(this);
		var field=t.hasClass('left')?'TSizeMB':'TDataSizeMB';
		if(!t.parent().hasClass('active')){
			t.parent().siblings().removeClass('active');
			t.parent().addClass('active');
			show(field);
		}
		
	})
}


function getGlobalsTimeData(gblArr,field,callback){
	if (!gblArr || gblArr.length==0) {
		callback([]);
		return;
	}
	var temp={};
	function getOne(ind){
		var gblKey=gblArr[ind],
			dbName=gblKey.split(']')[0].split('[')[1],
			gblName=gblKey.split(']')[1];
		
		$.q2({ClassName:'BSP.SMP.BL.GlobalInfo',QueryName:'Find',
			rows:9999,ResultSetType:'array',showFields:'TDay,TTiming,'+field,
			dbName:dbName,globalName:gblName
		},function(rows){
			$.each(rows,function(i,row){
				if (temp[row.TDay+row.TTiming]) {
					temp[row.TDay+row.TTiming][gblKey]=parseFloat(row[field]);
				}else {
					temp[row.TDay+row.TTiming]={TDay:row.TDay,TTiming:row.TTiming};
					temp[row.TDay+row.TTiming][gblKey]=parseFloat(row[field]);
				}
			})
			
			if (ind==gblArr.length-1) { //最后一个global了
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
function initIndexChartGbltop5(){
	var state={};
	function show(field){
		$('#index-chart-gbltop5-c-'+field).siblings().hide();
		$('#index-chart-gbltop5-c-'+field).show();
		if (state[field] && state[field].inited) return; //已经加载过的图
		
		//获取最近采集Global大小的记录
		$.m({ClassName:'BSP.SMP.BL.SummaryInfo',MethodName:'GetLatestSummary'
			,collectType:'111,110' //collectType 一般只用111 999  不过110也采集到了Global大小
		},function(ret){ 
			if(!(ret>0)) return;
			//获取最近一次采集记录中最大的几个Global
			$.q2({ClassName:'BSP.SMP.BL.GlobalInfo',QueryName:'Find'
				,ResultSetType:'array',rows:5,sort:field,order:'desc',orderType:'number',showFields:'TDatabaseName,TGlobalName'
				,summaryInfoId:ret
			},function(rows){
				var gblArr=rows.map(function(row){return '['+row.TDatabaseName+']'+row.TGlobalName});
				console.log(gblArr);
				getGlobalsTimeData(gblArr,field,function(lineRows){
					var columns={}
					SMP_COMM.renderSimpleEChart({
						jqSelector:'#index-chart-gbltop5-c-'+field,
						xAxisType:'time',
						dateField:'TDay',
						timeField:'TTiming',
						//selectedMode:'single',
						columns:gblArr.map(function(item){return {field:item,title:item,barWidth:'40%'}}),
						rows:lineRows,
						onClick:function(o){
							console.log(o);
						},
						grid:{
					        left: '10px',
					        right: '10px',
					        bottom: '0px',
					        containLabel: true
					    }
					})
					state[field]={inited:true};
					
				}) //end getDatabasesTimeData
				
			})
		})
		

	}
	show('TAllocatedSizeMb');
	$('#index-chart-gbltop5-p').find('a.left,a.right').on('click',function(){
		var t=$(this);
		var field=t.hasClass('left')?'TAllocatedSizeMb':'TUsedSizeMb';
		if(!t.parent().hasClass('active')){
			t.parent().siblings().removeClass('active');
			t.parent().addClass('active');
			show(field);
		}
		
	})
}

function initIndexChartGblfocus(){
	var state={};
	function show(field){
		$('#index-chart-gblfocus-c-'+field).siblings().hide();
		$('#index-chart-gblfocus-c-'+field).show();
		if (state[field] && state[field].inited) return; //已经加载过的图
		
		//获取最近采集Global大小的记录
		$.q2({ClassName:'CF.BSP.SMP.Comm',QueryName:'Find'
			,ResultSetType:'array',rows:999
			,Type:'GlobalFocus',IsPar:0,Active:1
		},function(rows){
			var gblArr=[];
			rows.map(function(row){if (row.TValue=='1')gblArr.push(row.TCode)});
			console.log(gblArr);
			getGlobalsTimeData(gblArr,field,function(lineRows){
				var columns={}
				SMP_COMM.renderSimpleEChart({
					jqSelector:'#index-chart-gblfocus-c-'+field,
					xAxisType:'time',
					dateField:'TDay',
					timeField:'TTiming',
					//selectedMode:'single',
					columns:gblArr.map(function(item){return {field:item,title:item,barWidth:'40%'}}),
					rows:lineRows,
					onClick:function(o){
						console.log(o);
					},
					grid:{
				        left: '10px',
				        right: '10px',
				        bottom: '0px',
				        containLabel: true
				    }
				})
				state[field]={inited:true};
				
			}) //end getDatabasesTimeData

		})
		

	}
	show('TAllocatedSizeMb');
	$('#index-chart-gblfocus-p').find('a.left,a.right').on('click',function(){
		var t=$(this);
		var field=t.hasClass('left')?'TAllocatedSizeMb':'TUsedSizeMb';
		if(!t.parent().hasClass('active')){
			t.parent().siblings().removeClass('active');
			t.parent().addClass('active');
			show(field);
		}
		
	})
}
$(function(){
	//初始化面包屑
	initBreadcrumb();
	//几个入口按钮
	$('.entrance-button').click(function(){
		var url=$(this).data('url');
		showBread({id:url,title:$(this).text(),url:url});	
	})
	//待办事项
	initTodoList();
	//摘要
	initIndexChartSummary();
	//数据库大小top5
	initIndexChartDbtop5();
	//重点关注数据库
	initIndexChartDbfocus();
	//Global大小top5
	initIndexChartGbltop5();
	//Global重点关注
	initIndexChartGblfocus();
})