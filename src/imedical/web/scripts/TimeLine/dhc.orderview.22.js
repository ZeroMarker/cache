;(function($){
    if ($ && $.fn && $.fn.orderview){
	    $.fn.orderview.defaults.labels22=[[
				{label:'����',key:'PatName',css:{fontSize:'16px'},hideLabel:true,hideSep:true},
				{label:'�Ա�',key:'PatSex',hideLabel:true,hideSep:true},
				{label:'����',key:'PatAge',hideLabel:true},
				{label:'�������',key:'AppDeptDesc'},
				{label:'ҽ����ʼʱ��',key:'OrdStartDate',type:'date'},
		    	{label:'ҽ������',key:'OrdPriority'},
		    	{label:'Ƥ��',key:'OrdSkin'},
				{label:'������',key:'PresNo'},
				{label:'��������',key:'OrdLocDesc'}
	    	],[
	    		{label:'ҽ������',key:'OrdDesc'}
	    		,{label:'���뵥��',key:'OrdViewBizId'}
	    	]
	    ]
	}
    
})(jQuery);
