;(function($){
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
	var renderOpaFeeDetails=function(ele,data,chartData,chartPanel){ //��������
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var dgOpts={
			//SubCateDesc:ItmDesc:Qty:Price:Amt:
			columns:[[
				{field:'SubCateDesc',title:'��������',width:100,align:'center'},
				{field:'ItmDesc',title:'��Ŀ����',width:200,align:'center'},
				{field:'Qty',title:'����',width:100,align:'center'},
				{field:'Price',title:'����',width:100,align:'center'},
				{field:'Amt',title:'���',width:100,align:'center'}
			]],
			queryParams:{
				ClassName:'BSP.IMP.AN.Interface',
				QueryName:'QryOpaFee', 
				OEOrdItem:opts.orders[0],
				totalFields:'Amt'
			},
			showFooter:true
			,loadFilter:function(data){ //�õ����ݺ�Ϊ�ϼ��и�ֵ
				if(data.footer && data.footer.length>0){
					data.footer[0]["SubCateDesc"] = "�����ܷ���";
				}
				return data;
			}
			
		}
        renderSimpleTable(ele,data,chartPanel,dgOpts);
    }
    window.renderOpaFeeDetails=renderOpaFeeDetails;
    
    //������Ϣ
    var renderOpaInfoDetails=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var dgOpts={
			////RoomDesc,OperSeq,PatDeptDesc,PlanOperDesc,BladeTypeDesc,PrevDiagnosis,PostDiagnosis,PlanSurgeonDesc,PlanAsstDesc,SurgeonDesc,AsstDesc
			columns:[[
				{field:'SurgeonDept',title:'���߿���',width:100,align:'center'},
				{field:'OperDesc',title:'��������',width:150,align:'center'},
				{field:'OperClass',title:'�����ȼ�',width:100,align:'center'},
				{field:'BladeType',title:'�п�����',width:100,align:'center'},
				{field:'PostDiagnosis',title:'�������',width:100,align:'center'},
				/*{field:'PlanSurgeonDesc',title:'����ҽ��(��ǰ)',width:100,align:'center'},
				{field:'PlanAsstDesc',title:'һ��/����(��ǰ)',width:150,align:'center',formatter:function(val){
					return val.split(',').join('/')	;
				}},*/
				{field:'Surgeon',title:'����ҽ��(����)',width:100,align:'center'},
				{field:'AsstDesc',title:'һ��/����(����)',width:150,align:'center',formatter:function(val,row){
					return row.Assist1+'/'+row.Assist2;
				}}
			]],
			queryParams:{
				ClassName:'BSP.IMP.AN.Interface',
				MethodName:'GetOpaInfoDg',
				OEOrdItem:opts.orders[0]
			}
			
		}
        renderSimpleTable(ele,data,chartPanel,dgOpts);
    }
    window.renderOpaInfoDetails=renderOpaInfoDetails;
    
    //��������
    var renderOpaRiskAssessmentDetails=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var dgOpts={
			//Surgeon,SurgeonSignDT,AnaDoc,AnaDocSignDT,OperNurse,OperNurseSignDT,AssessmentScore,NNIS
			columns:[[
				{field:'Surgeon',title:'����ҽ��',width:100,align:'center'},
				{field:'SurgeonSignDT',title:'ǩ��ʱ��',width:160,align:'center'},
				{field:'AnaDoc',title:'����ҽ��',width:100,align:'center'},
				{field:'AnaDocSignDT',title:'ǩ��ʱ��',width:160,align:'center'},
				{field:'OperNurse',title:'Ѳ�ػ�ʿ',width:100,align:'center'},
				{field:'OperNurseSignDT',title:'ǩ��ʱ��',width:160,align:'center'},
				{field:'AssessmentScore',title:'�����ܷ�',width:100,align:'center'},
				{field:'NNIS',title:'NNIS����',width:100,align:'center'}
			]],
			queryParams:{
				ClassName:'BSP.IMP.AN.Interface',
				QueryName:'QryOpaRiskAssmt',
				OEOrdItem:opts.orders[0]
			},
			fitColumns:false
			
		}
        renderSimpleTable(ele,data,chartPanel,dgOpts);
    }
    window.renderOpaRiskAssessmentDetails=renderOpaRiskAssessmentDetails;
    
    //��ȫ�˲�
    var renderOpaSafetyCheckDetails=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var dgOpts={
			///Stage,SurgeonSignName,SurgeonSignDT,AnaDocSignName,AnaDocSignDT,OperNurseSignName,OperNurseSignDT
			columns:[[
				{field:'Stage',title:'�׶�',width:100,align:'center'},
				{field:'SurgeonSignName',title:'����ҽ��',width:100,align:'center'},
				{field:'SurgeonSignDT',title:'ʱ��',width:160,align:'center'},
				{field:'AnaDocSignName',title:'����ҽ��',width:100,align:'center'},
				{field:'AnaDocSignDT',title:'ʱ��',width:160,align:'center'},
				{field:'OperNurseSignName',title:'������ʿ',width:100,align:'center'},
				{field:'OperNurseSignDT',title:'ʱ��',width:160,align:'center'}
			]],
			queryParams:{
				ClassName:'BSP.IMP.AN.Interface',
				QueryName:'QryOpaSafetyCheck',
				OEOrdItem:opts.orders[0]
			},
			fitColumns:false
			
		}
        renderSimpleTable(ele,data,chartPanel,dgOpts);
    }
    window.renderOpaSafetyCheckDetails=renderOpaSafetyCheckDetails;
    
        
    //����ҽ��
    var renderOpaOrdDetails=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var dgOpts={
			//ordItemId,ordStageDesc,itemCatDesc,ordStDate,ordStTime,arcimdesc,ordDocName,ordStatusDesc,ordLocDesc,ordRecLocDesc,ordAddDate,ordAddTime
			columns:[[
				{field:'ordStageDesc',title:'�׶�',width:100,align:'center'},
				{field:'itemCatDesc',title:'ҽ������',width:100,align:'center'},
				{field:'ordStDate',title:'ҽ����ʼʱ��',formatter:function(val,row){
					return val+' '+row.ordStTime;
				},width:160,align:'center'},
				{field:'arcimdesc',title:'ҽ��',width:260,align:'center'},
				{field:'ordDocName',title:'��ҽ����',width:100,align:'center'},
				{field:'ordStatusDesc',title:'ҽ��״̬',width:100,align:'center'},
				{field:'ordLocDesc',title:'��������',width:100,align:'center'},
				{field:'ordRecLocDesc',title:'���տ���',width:100,align:'center'},
				{field:'ordAddDate',title:'��ҽ��ʱ��',formatter:function(val,row){
					return val+' '+row.ordAddTime;
				},width:160,align:'center'},
			]],
			queryParams:{
				ClassName:'BSP.IMP.AN.Interface',
				QueryName:'QryOpaOrd',
				OEOrdItem:opts.orders[0]
			},
			fitColumns:false
			
		}
        renderSimpleTable(ele,data,chartPanel,dgOpts);
    }
    window.renderOpaOrdDetails=renderOpaOrdDetails;
    
          
    //�����ʿ�
    var renderOpaRiskQCDetails=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var dgOpts={
			//QCContent,QCStartDT,QCFinishDT,QCDuration,QCIsPresc,QCNote
			columns:[[
				{field:'QCContent',title:'�ʿ�����',width:160,align:'center'},
				{field:'QCStartDT',title:'��ʼʱ��',width:160,align:'center'},
				{field:'QCFinishDT',title:'����ʱ��',width:160,align:'center'},
				{field:'QCDuration',title:'ʱ��',width:100,align:'center'}
				//,{field:'QCIsPresc',title:'�Ƿ񴦷��ʿ�',width:100,align:'center'}
				//,{field:'QCNote',title:'��ע',width:100,align:'center'}
			]],
			queryParams:{
				ClassName:'BSP.IMP.AN.Interface',
				QueryName:'QryOpaRiskQC',
				OEOrdItem:opts.orders[0]
			},
			fitColumns:false
			
		}
        renderSimpleTable(ele,data,chartPanel,dgOpts);
    }
    window.renderOpaRiskQCDetails=renderOpaRiskQCDetails;
    
            
    //������е���
    var renderOpaInstruCheckDetails=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var dgOpts={
			//
			columns:[[
				{field:'ScrubNurse',title:'��е��ʿǩ��',width:100,align:'center'},
				{field:'ScrubNurseSignDT',title:'ʱ��',width:160,align:'center'},
				{field:'CircualNurse',title:'Ѳ�ػ�ʿǩ��',width:100,align:'center'},
				{field:'CircualNurseSignDT',title:'ʱ��',width:160,align:'center'},
				{field:'BarCode',title:'��������',width:100,align:'center',hidden:true} //��ʱ����ʾ
			]],
			queryParams:{
				ClassName:'BSP.IMP.AN.Interface',
				MethodName:'GetOpaInstruCheckDg',
				OEOrdItem:opts.orders[0]
			},
			fitColumns:false
			
		}
        renderSimpleTable(ele,data,chartPanel,dgOpts);
    }
    window.renderOpaInstruCheckDetails=renderOpaInstruCheckDetails;
})(jQuery);
