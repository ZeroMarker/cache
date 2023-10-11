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
				{field:'SubCateDesc',title:'费用子类',width:100,align:'left'},
				{field:'ItmDesc',title:'项目名称',width:200,align:'left'},
				{field:'Qty',title:'数量',width:100,align:'left'},
				{field:'Price',title:'单价',width:100,align:'left'},
				{field:'Amt',title:'金额',width:100,align:'right'}
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
				{field:'SurgeonDept',title:'术者科室',width:100,align:'left'},
				{field:'OperDesc',title:'手术名称',width:150,align:'left'},
				{field:'OperClass',title:'手术等级',width:100,align:'left'},
				{field:'BladeType',title:'切口类型',width:100,align:'left'},
				{field:'PostDiagnosis',title:'术后诊断',width:100,align:'left',formatter:function(val){
					var arr=val.split('&&&'),arr2=[];
					for (var i=0,len=arr.length;i<len;i++) {
						var desc=arr[i].split('###')[1]||arr[i];
						if (desc) arr2.push(desc);
					}
					return arr2.join('；');
				}},
				/*{field:'PlanSurgeonDesc',title:'手术医生(术前)',width:100,align:'left'},
				{field:'PlanAsstDesc',title:'一助/二助(术前)',width:150,align:'left',formatter:function(val){
					return val.split(',').join('/')	;
				}},*/
				{field:'Surgeon',title:'手术医生(术后)',width:100,align:'left'},
				{field:'AsstDesc',title:'一助/二助(术后)',width:150,align:'left',formatter:function(val,row){
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
				{field:'Surgeon',title:'手术医生',width:100,align:'left'},
				{field:'SurgeonSignDT',title:'签名时间',width:160,align:'left'},
				{field:'AnaDoc',title:'麻醉医生',width:100,align:'left'},
				{field:'AnaDocSignDT',title:'签名时间',width:160,align:'left'},
				{field:'OperNurse',title:'巡回护士',width:100,align:'left'},
				{field:'OperNurseSignDT',title:'签名时间',width:160,align:'left'},
				{field:'AssessmentScore',title:'风险总分',width:100,align:'left'},
				{field:'NNIS',title:'NNIS级数',width:100,align:'left'}
			]],
			queryParams:{
				ClassName:'BSP.IMP.AN.Interface',
				QueryName:'QryOpaRiskAssmt',
				OEOrdItem:opts.orders[0]
			},
			fitColumns:true
			
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
				{field:'Stage',title:'阶段',width:100,align:'left'},
				{field:'SurgeonSignName',title:'手术医生',width:100,align:'left'},
				{field:'SurgeonSignDT',title:'时间',width:160,align:'left'},
				{field:'AnaDocSignName',title:'麻醉医生',width:100,align:'left'},
				{field:'AnaDocSignDT',title:'时间',width:160,align:'left'},
				{field:'OperNurseSignName',title:'手术护士',width:100,align:'left'},
				{field:'OperNurseSignDT',title:'时间',width:160,align:'left'}
			]],
			queryParams:{
				ClassName:'BSP.IMP.AN.Interface',
				QueryName:'QryOpaSafetyCheck',
				OEOrdItem:opts.orders[0]
			},
			fitColumns:true
			
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
				{field:'ordStageDesc',title:'阶段',width:100,align:'left'},
				{field:'itemCatDesc',title:'医嘱子类',width:100,align:'left'},
				{field:'ordStDate',title:'医嘱开始时间',formatter:function(val,row){
					return val+' '+row.ordStTime;
				},width:160,align:'left'},
				{field:'arcimdesc',title:'医嘱',width:260,align:'left'},
				{field:'ordDocName',title:'开医嘱人',width:100,align:'left'},
				{field:'ordStatusDesc',title:'医嘱状态',width:100,align:'left'},
				{field:'ordLocDesc',title:'开单科室',width:100,align:'left'},
				{field:'ordRecLocDesc',title:'接收科室',width:100,align:'left'},
				{field:'ordAddDate',title:'开医嘱时间',formatter:function(val,row){
					return val+' '+row.ordAddTime;
				},width:160,align:'left'},
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
				{field:'QCContent',title:'质控内容',width:160,align:'left'},
				{field:'QCStartDT',title:'开始时间',width:160,align:'left'},
				{field:'QCFinishDT',title:'结束时间',width:160,align:'left'},
				{field:'QCDuration',title:'时长',width:100,align:'left'}
				//,{field:'QCIsPresc',title:'是否处方质控',width:100,align:'left'}
				//,{field:'QCNote',title:'备注',width:100,align:'left'}
			]],
			queryParams:{
				ClassName:'BSP.IMP.AN.Interface',
				QueryName:'QryOpaRiskQC',
				OEOrdItem:opts.orders[0]
			},
			fitColumns:true
			
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
				{field:'ScrubNurse',title:'器械护士签名',width:100,align:'left'},
				{field:'ScrubNurseSignDT',title:'时间',width:160,align:'left'},
				{field:'CircualNurse',title:'巡回护士签名',width:100,align:'left'},
				{field:'CircualNurseSignDT',title:'时间',width:160,align:'left'},
				{field:'BarCode',title:'消毒包号',width:100,align:'left',hidden:true} //暂时不显示
			]],
			queryParams:{
				ClassName:'BSP.IMP.AN.Interface',
				MethodName:'GetOpaInstruCheckDg',
				OEOrdItem:opts.orders[0]
			},
			fitColumns:true
			
		}
        renderSimpleTable(ele,data,chartPanel,dgOpts);
    }
    window.renderOpaInstruCheckDetails=renderOpaInstruCheckDetails;
    
    
    //渲染手术病理申请
	function renderOpaPisApp(ele,data,buttonData,modalContent){
		console.log(ele,data,buttonData,modalContent);
		var $ele=$(ele);
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var ordItemId=opts.orders[0];
		modalContent.empty();
		

		var $opaPisAppPanel=$('<div style="padding:10px;"></div>').appendTo(modalContent);
		var $opaPisAppTable=$('<table id="opaPisAppTable"></table>').appendTo($opaPisAppPanel);
		$opaPisAppPanel.panel({fit:true,border:false});

		$opaPisAppTable.datagrid({
			headerCls:'panel-header-gray',
			bodyCls:'panel-header-gray',
			border:true,
			url:opts.baseUrl+'/csp/websys.Broker.cls',
			queryParams:{ordItemId:ordItemId,ClassName:'icare.web.DHCAppPisCutBas',QueryName:'Find'},
			idField:'OrdItemId' ,
			singleSelect:true,
			rownumbers: true,
			pagination: true,
			pageSize:10,
			fit:true,
			pageList: [10,30,50],  
			striped: true ,	
			//lkID,insID,insTitle,insCreateUserName,insCreateDateTime	
			columns:[[
                {field:"OperId",title:"手术ID",align:"left",width:100},
                {field:"Date",title:"申请日期",align:"left",width:100},
                {field:"Time",title:"申请时间",align:"left",width:80},
                {field:"ItmName",title:"项目名称",align:"left",width:165,formatter:function(val,row,ind){
                    return '<a href="javascript:void(0)" class="a-orderview" data-id="'+row.OrdItemId+'" >'+val+'</a>'
                }},
                {field:"UserName",title:"医生姓名",align:"left",width:100},
                {field:"ReqNo",title:"请求单号",align:"left",width:100},
                {field:"OrdItemId",title:"医嘱ID",align:"left",width:100}
			]]            
			,onLoadSuccess:function(){
                $opaPisAppTable.closest('.datagrid').find('.a-orderview').off('click').on('click',function(){
					var id=$(this).data('id')
                    $.orderview.easyModal('医嘱闭环','dhc.orderview.csp?ord='+id,1300,600,'',false);
				})
            }
		})
		///此表格通过设置宽度 使表格所有列宽和表格宽一致  将左后一列边框变透明
		$opaPisAppTable.datagrid('getPanel').addClass('orderview-dg-nolastborder');
	}
	window.renderOpaPisApp=renderOpaPisApp;
    
    //渲染手术输血申请
	function renderOpaBldApp(ele,data,buttonData,modalContent){
		console.log(ele,data,buttonData,modalContent);
		var $ele=$(ele);
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var ordItemId=opts.orders[0];
		modalContent.empty();
		

		var $opaBldAppPanel=$('<div style="padding:10px;"></div>').appendTo(modalContent);
		var $opaBldAppTable=$('<table id="opaBldAppTable"></table>').appendTo($opaBldAppPanel);
		$opaBldAppPanel.panel({fit:true,border:false});

		$opaBldAppTable.datagrid({
			headerCls:'panel-header-gray',
			bodyCls:'panel-header-gray',
			border:true,
			url:opts.baseUrl+'/csp/websys.Broker.cls',
			queryParams:{ordItemId:ordItemId,ClassName:'icare.web.BDReqForm',QueryName:'Find'},
			idField:'OrdItemId' ,
			singleSelect:true,
			rownumbers: true,
			pagination: true,
			pageSize:10,
			fit:true,
			pageList: [10,30,50],  
			striped: true ,	
			columns:[[
                {field:"OperId",title:"手术ID",align:"left",width:100},
                {field:"Date",title:"申请日期",align:"left",width:100},
                {field:"Time",title:"申请时间",align:"left",width:80},
                {field:"ItmName",title:"项目名称",align:"left",width:165,formatter:function(val,row,ind){
                    return '<a href="javascript:void(0)" class="a-orderview" data-id="'+row.OrdItemId+'" >'+val+'</a>'
                }},
                {field:"UserName",title:"医生姓名",align:"left",width:100},
                {field:"ReqNo",title:"请求单号",align:"left",width:100},
                {field:"OrdItemId",title:"医嘱ID",align:"left",width:100}
			]]
            ,onLoadSuccess:function(){
                $opaBldAppTable.closest('.datagrid').find('.a-orderview').off('click').on('click',function(){
					var id=$(this).data('id')
                    $.orderview.easyModal('医嘱闭环','dhc.orderview.csp?ord='+id,1300,600,'',false);
				})
            }
		})
		///此表格通过设置宽度 使表格所有列宽和表格宽一致  将左后一列边框变透明
		$opaBldAppTable.datagrid('getPanel').addClass('orderview-dg-nolastborder');
	}
	window.renderOpaBldApp=renderOpaBldApp;
	
})(jQuery);
