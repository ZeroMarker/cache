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
				{field:'SubCateDesc',title:'��������',width:100,align:'left'},
				{field:'ItmDesc',title:'��Ŀ����',width:200,align:'left'},
				{field:'Qty',title:'����',width:100,align:'left'},
				{field:'Price',title:'����',width:100,align:'left'},
				{field:'Amt',title:'���',width:100,align:'right'}
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
				{field:'SurgeonDept',title:'���߿���',width:100,align:'left'},
				{field:'OperDesc',title:'��������',width:150,align:'left'},
				{field:'OperClass',title:'�����ȼ�',width:100,align:'left'},
				{field:'BladeType',title:'�п�����',width:100,align:'left'},
				{field:'PostDiagnosis',title:'�������',width:100,align:'left',formatter:function(val){
					var arr=val.split('&&&'),arr2=[];
					for (var i=0,len=arr.length;i<len;i++) {
						var desc=arr[i].split('###')[1]||arr[i];
						if (desc) arr2.push(desc);
					}
					return arr2.join('��');
				}},
				/*{field:'PlanSurgeonDesc',title:'����ҽ��(��ǰ)',width:100,align:'left'},
				{field:'PlanAsstDesc',title:'һ��/����(��ǰ)',width:150,align:'left',formatter:function(val){
					return val.split(',').join('/')	;
				}},*/
				{field:'Surgeon',title:'����ҽ��(����)',width:100,align:'left'},
				{field:'AsstDesc',title:'һ��/����(����)',width:150,align:'left',formatter:function(val,row){
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
				{field:'Surgeon',title:'����ҽ��',width:100,align:'left'},
				{field:'SurgeonSignDT',title:'ǩ��ʱ��',width:160,align:'left'},
				{field:'AnaDoc',title:'����ҽ��',width:100,align:'left'},
				{field:'AnaDocSignDT',title:'ǩ��ʱ��',width:160,align:'left'},
				{field:'OperNurse',title:'Ѳ�ػ�ʿ',width:100,align:'left'},
				{field:'OperNurseSignDT',title:'ǩ��ʱ��',width:160,align:'left'},
				{field:'AssessmentScore',title:'�����ܷ�',width:100,align:'left'},
				{field:'NNIS',title:'NNIS����',width:100,align:'left'}
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
    
    //��ȫ�˲�
    var renderOpaSafetyCheckDetails=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var dgOpts={
			///Stage,SurgeonSignName,SurgeonSignDT,AnaDocSignName,AnaDocSignDT,OperNurseSignName,OperNurseSignDT
			columns:[[
				{field:'Stage',title:'�׶�',width:100,align:'left'},
				{field:'SurgeonSignName',title:'����ҽ��',width:100,align:'left'},
				{field:'SurgeonSignDT',title:'ʱ��',width:160,align:'left'},
				{field:'AnaDocSignName',title:'����ҽ��',width:100,align:'left'},
				{field:'AnaDocSignDT',title:'ʱ��',width:160,align:'left'},
				{field:'OperNurseSignName',title:'������ʿ',width:100,align:'left'},
				{field:'OperNurseSignDT',title:'ʱ��',width:160,align:'left'}
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
    
        
    //����ҽ��
    var renderOpaOrdDetails=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var dgOpts={
			//ordItemId,ordStageDesc,itemCatDesc,ordStDate,ordStTime,arcimdesc,ordDocName,ordStatusDesc,ordLocDesc,ordRecLocDesc,ordAddDate,ordAddTime
			columns:[[
				{field:'ordStageDesc',title:'�׶�',width:100,align:'left'},
				{field:'itemCatDesc',title:'ҽ������',width:100,align:'left'},
				{field:'ordStDate',title:'ҽ����ʼʱ��',formatter:function(val,row){
					return val+' '+row.ordStTime;
				},width:160,align:'left'},
				{field:'arcimdesc',title:'ҽ��',width:260,align:'left'},
				{field:'ordDocName',title:'��ҽ����',width:100,align:'left'},
				{field:'ordStatusDesc',title:'ҽ��״̬',width:100,align:'left'},
				{field:'ordLocDesc',title:'��������',width:100,align:'left'},
				{field:'ordRecLocDesc',title:'���տ���',width:100,align:'left'},
				{field:'ordAddDate',title:'��ҽ��ʱ��',formatter:function(val,row){
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
    
          
    //�����ʿ�
    var renderOpaRiskQCDetails=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var dgOpts={
			//QCContent,QCStartDT,QCFinishDT,QCDuration,QCIsPresc,QCNote
			columns:[[
				{field:'QCContent',title:'�ʿ�����',width:160,align:'left'},
				{field:'QCStartDT',title:'��ʼʱ��',width:160,align:'left'},
				{field:'QCFinishDT',title:'����ʱ��',width:160,align:'left'},
				{field:'QCDuration',title:'ʱ��',width:100,align:'left'}
				//,{field:'QCIsPresc',title:'�Ƿ񴦷��ʿ�',width:100,align:'left'}
				//,{field:'QCNote',title:'��ע',width:100,align:'left'}
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
    
            
    //������е���
    var renderOpaInstruCheckDetails=function(ele,data,chartData,chartPanel){ 
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var dgOpts={
			//
			columns:[[
				{field:'ScrubNurse',title:'��е��ʿǩ��',width:100,align:'left'},
				{field:'ScrubNurseSignDT',title:'ʱ��',width:160,align:'left'},
				{field:'CircualNurse',title:'Ѳ�ػ�ʿǩ��',width:100,align:'left'},
				{field:'CircualNurseSignDT',title:'ʱ��',width:160,align:'left'},
				{field:'BarCode',title:'��������',width:100,align:'left',hidden:true} //��ʱ����ʾ
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
    
    
    //��Ⱦ������������
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
                {field:"OperId",title:"����ID",align:"left",width:100},
                {field:"Date",title:"��������",align:"left",width:100},
                {field:"Time",title:"����ʱ��",align:"left",width:80},
                {field:"ItmName",title:"��Ŀ����",align:"left",width:165,formatter:function(val,row,ind){
                    return '<a href="javascript:void(0)" class="a-orderview" data-id="'+row.OrdItemId+'" >'+val+'</a>'
                }},
                {field:"UserName",title:"ҽ������",align:"left",width:100},
                {field:"ReqNo",title:"���󵥺�",align:"left",width:100},
                {field:"OrdItemId",title:"ҽ��ID",align:"left",width:100}
			]]            
			,onLoadSuccess:function(){
                $opaPisAppTable.closest('.datagrid').find('.a-orderview').off('click').on('click',function(){
					var id=$(this).data('id')
                    $.orderview.easyModal('ҽ���ջ�','dhc.orderview.csp?ord='+id,1300,600,'',false);
				})
            }
		})
		///�˱��ͨ�����ÿ�� ʹ��������п�ͱ���һ��  �����һ�б߿��͸��
		$opaPisAppTable.datagrid('getPanel').addClass('orderview-dg-nolastborder');
	}
	window.renderOpaPisApp=renderOpaPisApp;
    
    //��Ⱦ������Ѫ����
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
                {field:"OperId",title:"����ID",align:"left",width:100},
                {field:"Date",title:"��������",align:"left",width:100},
                {field:"Time",title:"����ʱ��",align:"left",width:80},
                {field:"ItmName",title:"��Ŀ����",align:"left",width:165,formatter:function(val,row,ind){
                    return '<a href="javascript:void(0)" class="a-orderview" data-id="'+row.OrdItemId+'" >'+val+'</a>'
                }},
                {field:"UserName",title:"ҽ������",align:"left",width:100},
                {field:"ReqNo",title:"���󵥺�",align:"left",width:100},
                {field:"OrdItemId",title:"ҽ��ID",align:"left",width:100}
			]]
            ,onLoadSuccess:function(){
                $opaBldAppTable.closest('.datagrid').find('.a-orderview').off('click').on('click',function(){
					var id=$(this).data('id')
                    $.orderview.easyModal('ҽ���ջ�','dhc.orderview.csp?ord='+id,1300,600,'',false);
				})
            }
		})
		///�˱��ͨ�����ÿ�� ʹ��������п�ͱ���һ��  �����һ�б߿��͸��
		$opaBldAppTable.datagrid('getPanel').addClass('orderview-dg-nolastborder');
	}
	window.renderOpaBldApp=renderOpaBldApp;
	
})(jQuery);
