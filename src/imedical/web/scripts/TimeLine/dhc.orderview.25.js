;(function($){
	window.ORDERVIEW_FUNC=window.ORDERVIEW_FUNC||{};
	window.ORDERVIEW_FUNC.f25=window.ORDERVIEW_FUNC.f25||{};
	
    if ($ && $.fn && $.fn.orderview){
	    $.fn.orderview.defaults.labels25=[[
				{label:'姓名',key:'PatName',css:{fontSize:'16px'},hideLabel:true,hideSep:true},
				{label:'性别',key:'PatSex',hideLabel:true,hideSep:true},
				{label:'年龄',key:'PatAge',hideLabel:true},
				{label:'透析日期',key:'BPDate',type:'date'},
				{label:'透析床位',key:'BPBed'},
				{label:'透析类型',key:'BPType'},
				{label:'透析状态',key:'BPStatus'},
				{label:'登记时间',key:'BPRegDate',type:'date'},
				{label:'患者转归',key:'BPEndDate',type:'date'}
				
	    	],[
				{label:'透析方式',key:'BPMode'},
				{label:'血管通路',key:'BPVascularAccess'},
				{label:'透析科室',key:'BPLoc'}
	    	]
	    ]
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
	///登记信息
	var renderBPREG=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var dgOpts={
			columns:[[
				{field:'PatDate',title:'登记日期',width:100,align:'left'},
				{field:'PatBPNo',title:'透析编号',width:100,align:'left'},
				{field:'PatType',title:'病人类型',width:100,align:'left'},
				{field:'PatStatus',title:'状态',width:100,align:'left'},
				{field:'PatDiagnosis',title:'诊断',width:100,align:'left'},
				{field:'PatMRCICD',title:'透析原因',width:100,align:'left'},
				{field:'PatStartDate',title:'首次透析日期',width:100,align:'left'}
			]],
			queryParams:{
				ClassName:'web.DHCBPInterface',
				QueryName:'FindBPPatRegister', 
				bpaId:opts.ordViewBizId
			}
		}
        renderSimpleTable(ele,data,chartPanel,dgOpts);
    }
    window.ORDERVIEW_FUNC.f25.renderBPREG=renderBPREG;
    
    
	///透析方案
	var renderBPPROGRAM=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		//StartDate开始日期，PatDryWeight干体重，BFR血流量，BPMode透析方式，BPAtMode抗凝方式，Note备注，UpdateUser创建者
		var dgOpts={
			columns:[[
				{field:'StartDate',title:'开始日期',width:100,align:'left'},
				{field:'BPMode',title:'透析方式',width:100,align:'left'},
				{field:'BPAtMode',title:'抗凝方式',width:100,align:'left'},
				{field:'Note',title:'备注',width:100,align:'left'}
			]],
			queryParams:{
				ClassName:'web.DHCBPInterface',
				QueryName:'FindBPScheme', 
				bpaId:opts.ordViewBizId
			}
		}
        renderSimpleTable(ele,data,chartPanel,dgOpts);
    }
    window.ORDERVIEW_FUNC.f25.renderBPPROGRAM=renderBPPROGRAM;
    
	///透析计划
	var renderBPPLAN=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		//WeekSeq周期，WeekDay星期，DaySeqNo班次，EffectDate生效日期，BPMode透析方式，BPSecondMode附件透析，Consumable透析器材，SecondConsumable附加器材
		var dgOpts={
			columns:[[
				{field:'WeekSeq',title:'周期',width:100,align:'left'},
				{field:'WeekDay',title:'星期',width:100,align:'left'},
				{field:'DaySeqNo',title:'时段',width:100,align:'left'},
				{field:'EffectDate',title:'生效日期',width:100,align:'left'},
				{field:'BPMode',title:'透析方式',width:100,align:'left'},
				{field:'Consumable',title:'透析器材',width:100,align:'left'}
			]],
			queryParams:{
				ClassName:'web.DHCBPInterface',
				QueryName:'FindBPArrangeScheme', 
				bpaId:opts.ordViewBizId
			}
		}
        renderSimpleTable(ele,data,chartPanel,dgOpts);
    }
    window.ORDERVIEW_FUNC.f25.renderBPPLAN=renderBPPLAN;
    
	///异常体征
	var renderBPVitalSigns=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		//StartDate日期，StartTime时间，RecordItem异常项目，Qty异常值，UpdateUser记录人
		var dgOpts={
			columns:[[
				{field:'StartDate',title:'记录日期时间',width:160,align:'left',formatter:function(val,row,ind){
					return row.StartDate+' '+row.StartTime;
				}},
				{field:'UpdateUser',title:'记录人',width:100,align:'left'},
				{field:'RecordItem',title:'异常项目',width:100,align:'left'},
				{field:'Qty',title:'异常值',width:100,align:'left'}
			]],
			queryParams:{
				ClassName:'web.DHCBPInterface',
				QueryName:'FindBPVitalSigns', 
				bpaId:opts.ordViewBizId
			}
		}
        renderSimpleTable(ele,data,chartPanel,dgOpts);
    }
    window.ORDERVIEW_FUNC.f25.renderBPVitalSigns=renderBPVitalSigns;
    
    ///透析充分性
	var renderBPCalculateURR=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		//StartDate日期，DaySeqNo时段，BPMode透析方式，BPSecondMode附件透析，KtV：Kt/v值，URR：URR值，PCR：PCR值
		var dgOpts={
			columns:[[
				{field:'StartDate',title:'记录日期时间',width:160,align:'left',formatter:function(val,row,ind){
					return row.StartDate+' '+(row.StartTime||'');
				}},
				{field:'DaySeqNo',title:'时间段',width:100,align:'left'},
				{field:'BPMode',title:'透析方式',width:100,align:'left'},
				{field:'BPSecondMode',title:'附件透析',width:100,align:'left'},
				{field:'KtV',title:'Kt/v值',width:100,align:'left'},
				{field:'URR',title:'URR值',width:100,align:'left'},
				{field:'PCR',title:'PCR值',width:100,align:'left'}
			]],
			queryParams:{
				ClassName:'web.DHCBPInterface',
				QueryName:'FindBPCalculateURR', 
				bpaId:opts.ordViewBizId
			}
		}
        renderSimpleTable(ele,data,chartPanel,dgOpts);
    }
    window.ORDERVIEW_FUNC.f25.renderBPCalculateURR=renderBPCalculateURR;
    
    ///透析安排
	var renderBPArrange=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		//BPDate日期，DaySeqNo时间段，BPMode透析方式，BPSecondMode附件透析，Status状态，WeekSeqNo所属透析计划周
		var dgOpts={
			columns:[[
				{field:'BPDate',title:'日期',width:100,align:'left'},
				{field:'DaySeqNo',title:'时间段',width:100,align:'left'},
				{field:'BPMode',title:'透析方式',width:100,align:'left'},
				{field:'BPSecondMode',title:'附件透析',width:100,align:'left'},
				{field:'Status',title:'状态',width:100,align:'left'},
				{field:'WeekSeqNo',title:'所属透析计划周',width:100,align:'left'}
			]],
			queryParams:{
				ClassName:'web.DHCBPInterface',
				QueryName:'FindBPArrange', 
				bpaId:opts.ordViewBizId
			}
		}
        renderSimpleTable(ele,data,chartPanel,dgOpts);
    }
    window.ORDERVIEW_FUNC.f25.renderBPArrange=renderBPArrange;
    
    ///查房记录
	var renderBPTreatment=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		//BPDate日期，BPTime时间，TreatmentCat项目分类，TreatmentItem项目，Symptom调整原因，Treatment调整内容，UpdateUser操作人
		var dgOpts={
			columns:[[
				{field:'BPDate',title:'操作日期时间',width:160,align:'left',formatter:function(val,row,ind){
					return row.BPDate+' '+(row.BPTime||'');
				}},
				{field:'UpdateUser',title:'操作人',width:100,align:'left'},
				{field:'TreatmentItem',title:'调整项目',width:100,align:'left'},
				{field:'Symptom',title:'调整原因',width:200,align:'left'},
				{field:'Treatment',title:'调整内容',width:200,align:'left'}
			]],
			queryParams:{
				ClassName:'web.DHCBPInterface',
				QueryName:'FindBPTreatment', 
				bpaId:opts.ordViewBizId
			}
		}
        renderSimpleTable(ele,data,chartPanel,dgOpts);
    }
    window.ORDERVIEW_FUNC.f25.renderBPTreatment=renderBPTreatment;
    
    
    ///透析医嘱
	var renderBPOrderItem=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		//ARCIM医嘱名称，Instruc用法，Dose剂量，UOM单位，Freq频次，Note备注，Status状态，StartDate开始日期，ExecUser执行人，ExecDate执行日期，ExecTime执行时间
		var dgOpts={
			columns:[[
				{field:'StartDate',title:'医嘱开始日期',width:100,align:'left'},
				{field:'ARCIM',title:'医嘱名称',width:160,align:'left'},
				{field:'Status',title:'状态',width:60,align:'left'},
				{field:'Instruc',title:'用法',width:60,align:'left'},
				{field:'Dose',title:'剂量',width:60,align:'left'},
				{field:'UOM',title:'单位',width:60,align:'left'},
				{field:'Freq',title:'频次',width:60,align:'left'},
				{field:'Note',title:'备注',width:60,align:'left'},
				{field:'ExecUser',title:'执行人',width:80,align:'left'},
				{field:'ExecDate',title:'执行日期时间',width:160,align:'left',formatter:function(val,row){
					return row.ExecDate+' '+row.ExecTime
				}}
			]],
			queryParams:{
				ClassName:'web.DHCBPInterface',
				QueryName:'FindBPOrderItem', 
				bpaId:opts.ordViewBizId
			}
		}
        renderSimpleTable(ele,data,chartPanel,dgOpts);
    }
    window.ORDERVIEW_FUNC.f25.renderBPOrderItem=renderBPOrderItem;
    
})(jQuery);
