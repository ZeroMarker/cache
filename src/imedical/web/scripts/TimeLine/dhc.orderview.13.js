;(function($){
    function renderSimpleTable(ele,data,chartPanel,dgOpts){
		var $ele=$(ele);
		var state = $.data(ele, "orderview");
		var opts=state.options;
		if (state.win) var $con=state.win.children('.orderview');
		else  var $con=$(opts.renderTo).children('.orderview');
		var DEFAULT_DGOPTS={
			url:opts.baseUrl+'/csp/websys.Broker.cls',
			fit:true,
			singleSelect:true,
			pagination:true,
			border:false,
			rownumbers:true,
			bodyCls:'panel-header-gray',
			fitColumns:true,
			nowrap:false
		};
		
		var thisDgOpts=$.extend({toolbar:[]},DEFAULT_DGOPTS,dgOpts);
		var $table=chartPanel.find('table.orderview-chart-table');
		if ($table.length==0){
			var $table_wrap=chartPanel;
			//$table_wrap.css({paddingTop:'4px'});
			$table=$('<table class="orderview-chart-table"></table>').appendTo($table_wrap);
			$table.datagrid(thisDgOpts);
		}else{
			$table.eq(0).datagrid(thisDgOpts);
		}
	};
	// data = > actdata
	// chartData => chart menu data
	function _renderCstFee(ele,data,chartData,chartPanel){
		var state = $.data(ele, "orderview");
		var opts=state.options;
		
		var $table = chartPanel.find('.orderview-tabs');
		if ($table.length==0){
			// tabs 覆盖 datagrid的title
			// tabs不包含datagrid,切换时单独加载datagrid
			$('<table style="margin-top:15px;" class="orderview-chart-table " >\
			</table><div class="orderview-tabs tabs-gray" style="position:absolute;top:0px;left:0px;" data-options="isBrandTabs:true"><div title="会诊费用" data-options="iconCls:\'icon-add-note\'"></div></div>').appendTo(chartPanel);
		}
		$(".orderview-tabs").width( chartPanel.width() )
		$(".orderview-tabs").parent().css("position","relative");
		$(".orderview-tabs").tabs({isBrandTabs:true});
		var CstLocArr = [];
		var CstLocInfo = data.GrpLocDesc.split("、");
		for (var i=0; i<CstLocInfo.length ;i++){
			var CstLocDesc=CstLocInfo[i].split("(")[0];
			if (CstLocArr.indexOf(CstLocDesc)==-1) {  //按科室汇总  去重科室 2022-01-05
				CstLocArr.push(CstLocDesc);
				$(".orderview-tabs").tabs('add',{title:CstLocDesc,content:'',closable:false});
			}
		}
		if (CstLocArr.length==0) return ;
		$(".orderview-tabs").tabs('select',1);
		$(".orderview-chart-table").datagrid({
			title:'会诊费用',
			toolbar:[],
			url:opts.baseUrl+'/csp/websys.Broker.cls',
			fit:true,
			singleSelect:true,
			pagination:true,
			border:true,
			rownumbers:true,
			//bodyCls:'panel-header-gray',
			headerCls:'panel-header-gray', //panel-header-big 
			fitColumns:true,
			nowrap:false,
			columns:[[
				{field:'SubCateDesc',title:'费用子类',width:100,align:'left'},
				{field:'ItmDesc',title:'项目名称',width:200,align:'left'},
				{field:'Qty',title:'数量',width:100,align:'left'},
				{field:'Price',title:'单价',width:100,align:'left'},
				{field:'Amt',title:'金额',width:100,align:'right'}
			]],
			queryParams:{
				ClassName:'BSP.IMP.CST.Interface',
				QueryName:'FindFee', 
				OEOrdItem:opts.orders[0],
				CSTLocDesc:CstLocArr[0],
				totalFields:'Amt'
				,BizId:data.OrdViewBizId||''
			},
			showFooter:true,
			loadFilter:function(data){ //拿到数据后，为合计行赋值
				if(data.footer && data.footer.length>0){
					data.footer[0]["SubCateDesc"] = $g("会诊总费用");
				}
				return data;
			}
		});
		$(".orderview-tabs").tabs('options').onSelect = function(title,index){
			$(".orderview-chart-table").datagrid("load",{ClassName:'BSP.IMP.CST.Interface',QueryName:'FindFee',OEOrdItem:opts.orders[0],CSTLocDesc:title,totalFields:'Amt'});
		};
	}
		
	//window.renderCstFee = _renderCstFee;
	
	
	///原来的没那么好用 不好控制样式
	function _renderCstFeeNew(ele,data,chartData,chartPanel){
		var state = $.data(ele, "orderview");
		var opts=state.options;
		
		if(!data.GrpLocDesc) return;
		
		
		var $mytabs = chartPanel.find('.orderview-chart-mytabs');
		if ($mytabs.length==0){
			
			$mytabs=$('<div class="orderview-chart-mytabs tabs-gray" style="" data-options="isBrandTabs:true"><div title="会诊费用" data-options="iconCls:\'icon-add-note\'"></div></div>');
			
			var CstLocArr = [];
			var CstLocInfo = data.GrpLocDesc.split("、");
			for (var i=0; i<CstLocInfo.length ;i++){
				var CstLocDesc=CstLocInfo[i].split("(")[0];
				if (CstLocArr.indexOf(CstLocDesc)==-1) {  //按科室汇总  去重科室 2022-01-05
					CstLocArr.push(CstLocDesc);
					$mytabs.append('<div title="'+CstLocDesc+'" data-options=""><table class="orderview-chart-mytable"></div></div>')
				}
			}
			if (CstLocArr.length==0) return ;
			$mytabs.appendTo(chartPanel);
			$mytabs.tabs({
				isBrandTabs:true,
				fit:true,
				onSelect:function(title,index){
					var dataIndex=index-1;
					var $mytable=$mytabs.tabs('getTab',index).find('.orderview-chart-mytable');
					if($mytable.length>0 && !$mytable.hasClass('datagrid-f')) {
						$mytable.datagrid({
							toolbar:[],
							url:opts.baseUrl+'/csp/websys.Broker.cls',
							fit:true,
							singleSelect:true,
							pagination:true,
							border:false,
							rownumbers:true,
							bodyCls:'panel-header-gray',
							fitColumns:true,
							nowrap:false,
							columns:[[
								{field:'SubCateDesc',title:'费用子类',width:100,align:'left'},
								{field:'ItmDesc',title:'项目名称',width:200,align:'left'},
								{field:'Qty',title:'数量',width:100,align:'left'},
								{field:'Price',title:'单价',width:100,align:'left'},
								{field:'Amt',title:'金额',width:100,align:'right'}
							]],
							queryParams:{
								ClassName:'BSP.IMP.CST.Interface',
								QueryName:'FindFee', 
								OEOrdItem:opts.orders[0],
								CSTLocDesc:CstLocArr[dataIndex],
								totalFields:'Amt'
								,BizId:data.OrdViewBizId||''
							},
							showFooter:true,
							loadFilter:function(data){ //拿到数据后，为合计行赋值
								if(data.footer && data.footer.length>0){
									data.footer[0]["SubCateDesc"] = $g("会诊总费用");
								}
								return data;
							}
						})
						
						
					}


				}
			});
		}

	}
	window.renderCstFee = _renderCstFeeNew;

    if ($ && $.fn && $.fn.orderview){
	    $.fn.orderview.defaults.labels13=[[
				{label:'姓名',key:'PatName',css:{fontSize:'16px'},hideLabel:true,hideSep:true},
				{label:'性别',key:'PatSex',hideLabel:true,hideSep:true},
				{label:'年龄',key:'PatAge',hideLabel:true},
				{label:'申请科室',key:'AppDeptDesc'},
				{label:'医嘱开始时间',key:'OrdStartDate',type:'date'},
		    	{label:'医嘱类型',key:'OrdPriority'},
		    	{label:'皮试',key:'OrdSkin'},
				{label:'处方号',key:'PresNo'},
				{label:'开单科室',key:'OrdLocDesc'},
				{label:'医嘱名称',key:'OrdDesc'}
	    	],[
	    		{label:'会诊科室/医生',key:'GrpLocDesc'}
	    	],[
	    		{label:'会诊类型',key:'CstType'},
	    		{label:'会诊性质',key:'CstTp'},
	    		{label:'会诊地址',key:'CstPlace'}
	    	]
	    ]
	}
    
})(jQuery);