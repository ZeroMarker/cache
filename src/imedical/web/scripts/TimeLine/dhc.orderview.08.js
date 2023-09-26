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
	var renderOpaFeeDetails=function(ele,data,chartData,chartPanel){ //手术费用
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var dgOpts={
			//SubCateDesc:ItmDesc:Qty:Price:Amt:
			columns:[[
				{field:'SubCateDesc',title:'费用子类',width:100,align:'center'},
				{field:'ItmDesc',title:'项目名称',width:200,align:'center'},
				{field:'Qty',title:'数量',width:100,align:'center'},
				{field:'Price',title:'单价',width:100,align:'center'},
				{field:'Amt',title:'金额',width:100,align:'center'}
			]],
			queryParams:{
				ClassName:'BSP.IMP.AN.Interface',
				QueryName:'QryOpaFee', 
				OEOrdItem:opts.orders[0],
				totalFields:'Amt'
			},
			showFooter:true
			,loadFilter:function(data){ //拿到数据后，为合计行赋值
				if(data.footer && data.footer.length>0){
					data.footer[0]["SubCateDesc"] = "手术总费用";
				}
				return data;
			}
			
		}
        renderSimpleTable(ele,data,chartPanel,dgOpts);
    }
    window.renderOpaFeeDetails=renderOpaFeeDetails;
    
    //手术信息
    var renderOpaInfoDetails=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var dgOpts={
			////RoomDesc,OperSeq,PatDeptDesc,PlanOperDesc,BladeTypeDesc,PrevDiagnosis,PostDiagnosis,PlanSurgeonDesc,PlanAsstDesc,SurgeonDesc,AsstDesc
			columns:[[
				{field:'SurgeonDept',title:'术者科室',width:100,align:'center'},
				{field:'OperDesc',title:'手术名称',width:150,align:'center'},
				{field:'OperClass',title:'手术等级',width:100,align:'center'},
				{field:'BladeType',title:'切口类型',width:100,align:'center'},
				{field:'PostDiagnosis',title:'术后诊断',width:100,align:'center'},
				/*{field:'PlanSurgeonDesc',title:'手术医生(术前)',width:100,align:'center'},
				{field:'PlanAsstDesc',title:'一助/二助(术前)',width:150,align:'center',formatter:function(val){
					return val.split(',').join('/')	;
				}},*/
				{field:'Surgeon',title:'手术医生(术后)',width:100,align:'center'},
				{field:'AsstDesc',title:'一助/二助(术后)',width:150,align:'center',formatter:function(val,row){
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
    
    //风险评估
    var renderOpaRiskAssessmentDetails=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var dgOpts={
			//Surgeon,SurgeonSignDT,AnaDoc,AnaDocSignDT,OperNurse,OperNurseSignDT,AssessmentScore,NNIS
			columns:[[
				{field:'Surgeon',title:'手术医生',width:100,align:'center'},
				{field:'SurgeonSignDT',title:'签名时间',width:160,align:'center'},
				{field:'AnaDoc',title:'麻醉医生',width:100,align:'center'},
				{field:'AnaDocSignDT',title:'签名时间',width:160,align:'center'},
				{field:'OperNurse',title:'巡回护士',width:100,align:'center'},
				{field:'OperNurseSignDT',title:'签名时间',width:160,align:'center'},
				{field:'AssessmentScore',title:'风险总分',width:100,align:'center'},
				{field:'NNIS',title:'NNIS级数',width:100,align:'center'}
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
    
    //安全核查
    var renderOpaSafetyCheckDetails=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var dgOpts={
			///Stage,SurgeonSignName,SurgeonSignDT,AnaDocSignName,AnaDocSignDT,OperNurseSignName,OperNurseSignDT
			columns:[[
				{field:'Stage',title:'阶段',width:100,align:'center'},
				{field:'SurgeonSignName',title:'手术医生',width:100,align:'center'},
				{field:'SurgeonSignDT',title:'时间',width:160,align:'center'},
				{field:'AnaDocSignName',title:'麻醉医生',width:100,align:'center'},
				{field:'AnaDocSignDT',title:'时间',width:160,align:'center'},
				{field:'OperNurseSignName',title:'手术护士',width:100,align:'center'},
				{field:'OperNurseSignDT',title:'时间',width:160,align:'center'}
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
    
        
    //手术医嘱
    var renderOpaOrdDetails=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var dgOpts={
			//ordItemId,ordStageDesc,itemCatDesc,ordStDate,ordStTime,arcimdesc,ordDocName,ordStatusDesc,ordLocDesc,ordRecLocDesc,ordAddDate,ordAddTime
			columns:[[
				{field:'ordStageDesc',title:'阶段',width:100,align:'center'},
				{field:'itemCatDesc',title:'医嘱子类',width:100,align:'center'},
				{field:'ordStDate',title:'医嘱开始时间',formatter:function(val,row){
					return val+' '+row.ordStTime;
				},width:160,align:'center'},
				{field:'arcimdesc',title:'医嘱',width:260,align:'center'},
				{field:'ordDocName',title:'开医嘱人',width:100,align:'center'},
				{field:'ordStatusDesc',title:'医嘱状态',width:100,align:'center'},
				{field:'ordLocDesc',title:'开单科室',width:100,align:'center'},
				{field:'ordRecLocDesc',title:'接收科室',width:100,align:'center'},
				{field:'ordAddDate',title:'开医嘱时间',formatter:function(val,row){
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
    
          
    //风险质控
    var renderOpaRiskQCDetails=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var dgOpts={
			//QCContent,QCStartDT,QCFinishDT,QCDuration,QCIsPresc,QCNote
			columns:[[
				{field:'QCContent',title:'质控内容',width:160,align:'center'},
				{field:'QCStartDT',title:'开始时间',width:160,align:'center'},
				{field:'QCFinishDT',title:'结束时间',width:160,align:'center'},
				{field:'QCDuration',title:'时长',width:100,align:'center'}
				//,{field:'QCIsPresc',title:'是否处方质控',width:100,align:'center'}
				//,{field:'QCNote',title:'备注',width:100,align:'center'}
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
    
            
    //风险器械清点
    var renderOpaInstruCheckDetails=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var dgOpts={
			//
			columns:[[
				{field:'ScrubNurse',title:'器械护士签名',width:100,align:'center'},
				{field:'ScrubNurseSignDT',title:'时间',width:160,align:'center'},
				{field:'CircualNurse',title:'巡回护士签名',width:100,align:'center'},
				{field:'CircualNurseSignDT',title:'时间',width:160,align:'center'},
				{field:'BarCode',title:'消毒包号',width:100,align:'center',hidden:true} //暂时不显示
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
