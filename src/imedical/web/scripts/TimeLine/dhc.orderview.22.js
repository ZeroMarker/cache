;(function($){
    if ($ && $.fn && $.fn.orderview){
	    $.fn.orderview.defaults.labels22=[[
				{label:'姓名',key:'PatName',css:{fontSize:'16px'},hideLabel:true,hideSep:true},
				{label:'性别',key:'PatSex',hideLabel:true,hideSep:true},
				{label:'年龄',key:'PatAge',hideLabel:true},
				{label:'申请科室',key:'AppDeptDesc'},
				{label:'医嘱开始时间',key:'OrdStartDate',type:'date'},
		    	{label:'医嘱类型',key:'OrdPriority'},
		    	{label:'皮试',key:'OrdSkin'},
				{label:'处方号',key:'PresNo'},
				{label:'开单科室',key:'OrdLocDesc'}
	    	],[
	    		{label:'医嘱名称',key:'OrdDesc'}
	    		,{label:'申请单号',key:'OrdViewBizId'}
	    	]
	    ]
	}
    
})(jQuery);
