;(function($){
    if ($ && $.fn && $.fn.orderview){
	    $.fn.orderview.defaults.labels134=[[
				{label:'姓名',key:'PatName',css:{fontSize:'16px'},hideLabel:true,hideSep:true},
				{label:'性别',key:'PatSex',hideLabel:true,hideSep:true},
				{label:'年龄',key:'PatAge',hideLabel:true},
				{label:'就诊号',key:'EpisodeID'},
				{label:'登记号',key:'PapmiNo'},
				{label:'病案号',key:'MrNo'},
				{label:'入院日期',key:'AdmDate',type:'date'},
				{label:'科室',key:'PatDept'}
		    ]
	    ]

	}
    
})(jQuery);
