;(function($){
    if ($ && $.fn && $.fn.orderview){
	    ///����id���������롢��������ơ�����š����š�Ч�ڡ���λ�����ι�Ӧ�̡����γ���
		// "Incib:%String,InciCode:%String,InciDesc:%String,BarCode:%String,BatNo:%String,ExpDate:%String,BUom:%String,Vendor:%String,Manf:%String"
	    $.fn.orderview.defaults.labels24=[[
	    		{label:'����',key:'PatName',css:{fontSize:'16px'},hideLabel:true,hideSep:true},
				{label:'�Ա�',key:'PatSex',hideLabel:true,hideSep:true},
				{label:'����',key:'PatAge',hideLabel:true},
				{label:'ҽ����ʼʱ��',key:'OrdStartDate',type:'date'},
		    	{label:'ҽ������',key:'OrdPriority'},
		    	{label:'��������',key:'OrdLocDesc'}
	    	],[
	    		{label:'ҽ������',key:'OrdDesc'},
				{label:'����',key:'InciCode'},
				{label:'����',key:'InciDesc'},
				{label:'�����',key:'BarCode'},
				{label:'����',key:'BatNo'},
				{label:'Ч��',key:'ExpDate',type:'date'},
				{label:'��λ',key:'BUom'},
		    	{label:'���ι�Ӧ��',key:'Vendor'},
				{label:'���γ���',key:'Manf'}
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
				{field:'OperDate',title:'����',width:100,align:'left'},
				{field:'OperTime',title:'ʱ��',width:100,align:'left'},
				{field:'TypeDesc',title:'����',width:100,align:'left'},
				{field:'OperNo',title:'�����',width:150,align:'left'},
				{field:'OperUser',title:'������',width:80,align:'left'},
				{field:'OperOrg',title:'λ����Ϣ',width:160,align:'left'}
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