;(function($){
    if ($ && $.fn && $.fn.orderview){
	    ///批次id、库存项代码、库存项名称、条码号、批号、效期、单位、批次供应商、批次厂商
		// "Incib:%String,InciCode:%String,InciDesc:%String,BarCode:%String,BatNo:%String,ExpDate:%String,BUom:%String,Vendor:%String,Manf:%String"
	    $.fn.orderview.defaults.labels24=[[
	    		{label:'姓名',key:'PatName',css:{fontSize:'16px'},hideLabel:true,hideSep:true},
				{label:'性别',key:'PatSex',hideLabel:true,hideSep:true},
				{label:'年龄',key:'PatAge',hideLabel:true},
				{label:'医嘱开始时间',key:'OrdStartDate',type:'date'},
		    	{label:'医嘱类型',key:'OrdPriority'},
		    	{label:'开单科室',key:'OrdLocDesc'}
	    	],[
	    		{label:'医嘱名称',key:'OrdDesc'},
				{label:'代码',key:'InciCode'},
				{label:'名称',key:'InciDesc'},
				{label:'条码号',key:'BarCode'},
				{label:'批号',key:'BatNo'},
				{label:'效期',key:'ExpDate',type:'date'},
				{label:'单位',key:'BUom'},
		    	{label:'批次供应商',key:'Vendor'},
				{label:'批次厂商',key:'Manf'}
	    	]
	    ];
	}
	
	//dgOpts:queryParams,idField,columns
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
	var renderHVMTransLog=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var dgOpts={
			//"Type:%String,OperUser:%String,OperDate:%String,OperTime:%String,OperNo:%String,OperOrg:%String,TypeDesc"
			columns:[[
				{field:'OperDate',title:'日期',width:100,align:'left'},
				{field:'OperTime',title:'时间',width:100,align:'left'},
				{field:'TypeDesc',title:'类型',width:100,align:'left'},
				{field:'OperNo',title:'处理号',width:150,align:'left'},
				{field:'OperUser',title:'操作人',width:80,align:'left'},
				{field:'OperOrg',title:'位置信息',width:160,align:'left'}
			]],
			//fitColumns:false,
			queryParams:{
				ClassName:'BSP.IMP.STM.Interface',
				QueryName:'QryHVMTrans',
				OrdItemId:opts.orders[0]
			},
			border:true,
			toolbar:null
			
		}
        renderSimpleTable(ele,data,chartPanel,dgOpts);
    }
    window.renderHVMTransLog=renderHVMTransLog;
	
	
 
})(jQuery);