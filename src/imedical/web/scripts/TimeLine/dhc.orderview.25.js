;(function($){
	window.ORDERVIEW_FUNC=window.ORDERVIEW_FUNC||{};
	window.ORDERVIEW_FUNC.f25=window.ORDERVIEW_FUNC.f25||{};
	
    if ($ && $.fn && $.fn.orderview){
	    $.fn.orderview.defaults.labels25=[[
				{label:'����',key:'PatName',css:{fontSize:'16px'},hideLabel:true,hideSep:true},
				{label:'�Ա�',key:'PatSex',hideLabel:true,hideSep:true},
				{label:'����',key:'PatAge',hideLabel:true},
				{label:'͸������',key:'BPDate',type:'date'},
				{label:'͸����λ',key:'BPBed'},
				{label:'͸������',key:'BPType'},
				{label:'͸��״̬',key:'BPStatus'},
				{label:'�Ǽ�ʱ��',key:'BPRegDate',type:'date'},
				{label:'����ת��',key:'BPEndDate',type:'date'}
				
	    	],[
				{label:'͸����ʽ',key:'BPMode'},
				{label:'Ѫ��ͨ·',key:'BPVascularAccess'},
				{label:'͸������',key:'BPLoc'}
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
	///�Ǽ���Ϣ
	var renderBPREG=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var dgOpts={
			columns:[[
				{field:'PatDate',title:'�Ǽ�����',width:100,align:'left'},
				{field:'PatBPNo',title:'͸�����',width:100,align:'left'},
				{field:'PatType',title:'��������',width:100,align:'left'},
				{field:'PatStatus',title:'״̬',width:100,align:'left'},
				{field:'PatDiagnosis',title:'���',width:100,align:'left'},
				{field:'PatMRCICD',title:'͸��ԭ��',width:100,align:'left'},
				{field:'PatStartDate',title:'�״�͸������',width:100,align:'left'}
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
    
    
	///͸������
	var renderBPPROGRAM=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		//StartDate��ʼ���ڣ�PatDryWeight�����أ�BFRѪ������BPMode͸����ʽ��BPAtMode������ʽ��Note��ע��UpdateUser������
		var dgOpts={
			columns:[[
				{field:'StartDate',title:'��ʼ����',width:100,align:'left'},
				{field:'BPMode',title:'͸����ʽ',width:100,align:'left'},
				{field:'BPAtMode',title:'������ʽ',width:100,align:'left'},
				{field:'Note',title:'��ע',width:100,align:'left'}
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
    
	///͸���ƻ�
	var renderBPPLAN=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		//WeekSeq���ڣ�WeekDay���ڣ�DaySeqNo��Σ�EffectDate��Ч���ڣ�BPMode͸����ʽ��BPSecondMode����͸����Consumable͸�����ģ�SecondConsumable��������
		var dgOpts={
			columns:[[
				{field:'WeekSeq',title:'����',width:100,align:'left'},
				{field:'WeekDay',title:'����',width:100,align:'left'},
				{field:'DaySeqNo',title:'ʱ��',width:100,align:'left'},
				{field:'EffectDate',title:'��Ч����',width:100,align:'left'},
				{field:'BPMode',title:'͸����ʽ',width:100,align:'left'},
				{field:'Consumable',title:'͸������',width:100,align:'left'}
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
    
	///�쳣����
	var renderBPVitalSigns=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		//StartDate���ڣ�StartTimeʱ�䣬RecordItem�쳣��Ŀ��Qty�쳣ֵ��UpdateUser��¼��
		var dgOpts={
			columns:[[
				{field:'StartDate',title:'��¼����ʱ��',width:160,align:'left',formatter:function(val,row,ind){
					return row.StartDate+' '+row.StartTime;
				}},
				{field:'UpdateUser',title:'��¼��',width:100,align:'left'},
				{field:'RecordItem',title:'�쳣��Ŀ',width:100,align:'left'},
				{field:'Qty',title:'�쳣ֵ',width:100,align:'left'}
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
    
    ///͸�������
	var renderBPCalculateURR=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		//StartDate���ڣ�DaySeqNoʱ�Σ�BPMode͸����ʽ��BPSecondMode����͸����KtV��Kt/vֵ��URR��URRֵ��PCR��PCRֵ
		var dgOpts={
			columns:[[
				{field:'StartDate',title:'��¼����ʱ��',width:160,align:'left',formatter:function(val,row,ind){
					return row.StartDate+' '+(row.StartTime||'');
				}},
				{field:'DaySeqNo',title:'ʱ���',width:100,align:'left'},
				{field:'BPMode',title:'͸����ʽ',width:100,align:'left'},
				{field:'BPSecondMode',title:'����͸��',width:100,align:'left'},
				{field:'KtV',title:'Kt/vֵ',width:100,align:'left'},
				{field:'URR',title:'URRֵ',width:100,align:'left'},
				{field:'PCR',title:'PCRֵ',width:100,align:'left'}
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
    
    ///͸������
	var renderBPArrange=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		//BPDate���ڣ�DaySeqNoʱ��Σ�BPMode͸����ʽ��BPSecondMode����͸����Status״̬��WeekSeqNo����͸���ƻ���
		var dgOpts={
			columns:[[
				{field:'BPDate',title:'����',width:100,align:'left'},
				{field:'DaySeqNo',title:'ʱ���',width:100,align:'left'},
				{field:'BPMode',title:'͸����ʽ',width:100,align:'left'},
				{field:'BPSecondMode',title:'����͸��',width:100,align:'left'},
				{field:'Status',title:'״̬',width:100,align:'left'},
				{field:'WeekSeqNo',title:'����͸���ƻ���',width:100,align:'left'}
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
    
    ///�鷿��¼
	var renderBPTreatment=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		//BPDate���ڣ�BPTimeʱ�䣬TreatmentCat��Ŀ���࣬TreatmentItem��Ŀ��Symptom����ԭ��Treatment�������ݣ�UpdateUser������
		var dgOpts={
			columns:[[
				{field:'BPDate',title:'��������ʱ��',width:160,align:'left',formatter:function(val,row,ind){
					return row.BPDate+' '+(row.BPTime||'');
				}},
				{field:'UpdateUser',title:'������',width:100,align:'left'},
				{field:'TreatmentItem',title:'������Ŀ',width:100,align:'left'},
				{field:'Symptom',title:'����ԭ��',width:200,align:'left'},
				{field:'Treatment',title:'��������',width:200,align:'left'}
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
    
    
    ///͸��ҽ��
	var renderBPOrderItem=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		//ARCIMҽ�����ƣ�Instruc�÷���Dose������UOM��λ��FreqƵ�Σ�Note��ע��Status״̬��StartDate��ʼ���ڣ�ExecUserִ���ˣ�ExecDateִ�����ڣ�ExecTimeִ��ʱ��
		var dgOpts={
			columns:[[
				{field:'StartDate',title:'ҽ����ʼ����',width:100,align:'left'},
				{field:'ARCIM',title:'ҽ������',width:160,align:'left'},
				{field:'Status',title:'״̬',width:60,align:'left'},
				{field:'Instruc',title:'�÷�',width:60,align:'left'},
				{field:'Dose',title:'����',width:60,align:'left'},
				{field:'UOM',title:'��λ',width:60,align:'left'},
				{field:'Freq',title:'Ƶ��',width:60,align:'left'},
				{field:'Note',title:'��ע',width:60,align:'left'},
				{field:'ExecUser',title:'ִ����',width:80,align:'left'},
				{field:'ExecDate',title:'ִ������ʱ��',width:160,align:'left',formatter:function(val,row){
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
