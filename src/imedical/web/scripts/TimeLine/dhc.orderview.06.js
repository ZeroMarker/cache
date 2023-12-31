;(function($){
    if ($ && $.fn && $.fn.orderview){
	    ///// 批次id、库存项名称、批号、效期、包装单位、基本单位、批次供应商、批次厂商
		// "inclb, inciDesc, batNo, expDate, pUomDesc, bUomDesc, vendorDesc, manfDesc")
	    $.fn.orderview.defaults.labels0651=[[
				{label:'库存项名称',key:'InciDesc',hideLabel:true},
				{label:'批号',key:'BatNo'},
				{label:'效期',key:'ExpDate',type:'date'},
				{label:'包装单位',key:'PUomDesc'},
				{label:'基本单位',key:'BUomDesc'},
		    	{label:'批次经营企业',key:'VendorDesc'},
				{label:'批次生产企业',key:'ManfDesc'}
	    	]
	    ];
	    
	    $.fn.orderview.defaults.labels0661=$.fn.orderview.defaults.labels0651;
	    $.fn.orderview.defaults.hideLabelIcon0651=true;
	    $.fn.orderview.defaults.hideLabelIcon0661=true;
		$.fn.orderview.defaults.labels0671=$.fn.orderview.defaults.labels0651;
		$.fn.orderview.defaults.hideLabelIcon0671=true;
	    
	    $.fn.orderview.defaults.labels0751=$.fn.orderview.defaults.labels0651;
	    $.fn.orderview.defaults.labels0761=$.fn.orderview.defaults.labels0651;
	   	$.fn.orderview.defaults.hideLabelIcon0751=true;
	    $.fn.orderview.defaults.hideLabelIcon0761=true;
		$.fn.orderview.defaults.labels0771=$.fn.orderview.defaults.labels0651;
		$.fn.orderview.defaults.hideLabelIcon0771=true;
	}
	
	
    function renderDetails(ele,data,chartPanel){
		var $ele=$(ele);
		var state = $.data(ele, "orderview");
		var opts=state.options;
		if (state.win) var $con=state.win.children('.orderview');
		else  var $con=$(opts.renderTo).children('.orderview');
		//默认开始日期 结束日期
		var tbStartDate="",tbEndDate="",tbNowDate=$.fn.datebox.defaults.formatter(new Date());
		tbStartDate=(data.OrdStartDate||'').split(' ')[0];
		if (tbStartDate=='' && data.ActData.length>0) tbStartDate=data.ActData[0].OprDate;
		if (tbStartDate.indexOf('-')>-1 && tbNowDate.indexOf('/')>-1){
			tbStartDate=tbStartDate.split('-').reverse().join('/');
		}else if(tbStartDate.indexOf('/')>-1 && tbNowDate.indexOf('-')>-1){
			tbStartDate=tbStartDate.split('/').reverse().join('-');
		}
		if(data.PatOrdType=="0711" || data.PatOrdType=="0721"){  //门急诊临时  住院临时
			if(data.ActData.length>0) tbEndDate=data.ActData[data.ActData.length-1].OprDate;
		}
		if (tbEndDate.indexOf('-')>-1 && tbNowDate.indexOf('/')>-1){
			tbEndDate=tbEndDate.split('-').reverse().join('/');
		}else if(tbEndDate.indexOf('/')>-1 && tbNowDate.indexOf('-')>-1){
			tbEndDate=tbEndDate.split('/').reverse().join('-');
		}

		var $table=chartPanel.find('table.orderview-chart-table');
		if ($table.length==0){
			var $table_wrap=chartPanel;
			var $toolbar=$('<div class="orderview-chart-table-tb" style="padding:10px;height:30px;"><table cellspacing="0" cellpadding="0" border="0"><tr><td class="r-label">'+$g('开始时间')+'</td><td><input class="orderview-chart-table-tb-st" value="'+tbStartDate+'"/>'
							+'</td><td style="padding-left:20px;" class="r-label">'+$g('结束时间')+'</td><td><input class="orderview-chart-table-tb-end" value="'+tbEndDate+'"/>'
							+'</td><td><a class="orderview-chart-table-tb-ser" style="margin-left:20px;">查询</a>'
							+'</td></tr></table></div>').appendTo($table_wrap);
			$toolbar.find('.orderview-chart-table-tb-st,.orderview-chart-table-tb-end').datebox({
				
			})
			$toolbar.find('.orderview-chart-table-tb-ser').linkbutton({
				iconCls:'icon-w-find',
				onClick:function(){
					var tb=$(this).closest('.orderview-chart-table-tb');
					var st=tb.find('.orderview-chart-table-tb-st').datebox('getValue');
					var end=tb.find('.orderview-chart-table-tb-end').datebox('getValue');
					var $table=$(this).closest('.orderview-charts-cell').find('table.orderview-chart-table');
					var oldQueryParams=$table.datagrid('options').queryParams;
					$table.datagrid('load',$.extend({},oldQueryParams,{execStDate:st,execEndDate:end}));
					
				}
			})
			$table=$('<table class="orderview-chart-table"></table>').appendTo($table_wrap);
			$table.datagrid($.extend({toolbar:$toolbar},getDgOptions(data.PatOrdType,data.NeedPIVAFlag,data.IsOral)));
		}else{
			$table.eq(0).datagrid(getDgOptions(data.PatOrdType,data.NeedPIVAFlag,data.IsOral));
		}
		
		
		
		function getDgOptions(PatOrdType,NeedPIVAFlag,IsOral){
			//0621 住院长期
			//ExecId:%String:OrderExecId,TExStDate:%String:要求执行时间,TBilledNum:%String,TAmount:%String,TExecStateDesc:%String:状态,TReqDrug:%String:领药审核,TDrugDocAudit:%String:药师审核,TgiveDrug:%String:发药,TReqCancelDrg:%String:申请退药,TcancelDrugQty:%String:退药数量,TBillState:%String:帐单状态,TPBOID:%String:帐单号
			//0721 住院临时
			//ExecId:%String:OrderExecId,TExStDate:%String:要求执行时间,TBilledNum:%String,TAmount:%String,TExecStateDesc:%String:状态,TReqDrug:%String:领药审核,TDrugDocAudit:%String:药师审核,TgiveDrug:%String:发药,TReqCancelDrg:%String:申请退药,TcancelDrugQty:%String:退药数量,TBillState:%String:帐单状态,TPBOID:%String:帐单号
			//0711 门诊临时
			//ExecId:%String:OrderExecId,TExStDate:%String:要求执行时间,TBilledNum:%String,TAmount:%String,TExecStateDesc:%String:状态
			var dgOpts={
				url:opts.baseUrl+'/csp/websys.Broker.cls',
				fit:true,
				queryParams:{
					ClassName:'icare.web.TimeLineActData',
					QueryName:'Find'+PatOrdType,
					orderId:opts.ord,
					execStDate:tbStartDate,
					execEndDate:tbEndDate
				},
				singleSelect:true,
				pagination:true,
				idField:'ExecId',
				rownumbers:true,
				bodyCls:'panel-header-gray',
				fitColumns:true,
				nowrap:false
			};
			if (PatOrdType=='0621' || PatOrdType=='0721'){
				dgOpts.columns=[[
					{field:'TExStDate',title:'要求执行时间',width:100,formatter:function(val,row){
						return '<a class="orderview-chart-table-col-time" href="javascript:void(0);" data-id="'+row.ExecId+'">'+val+'</a>'
					}},
					{field:'TBilledNum',title:'计费数量',width:80},
					{field:'TAmount',title:'金额',width:50},
					{field:'TExecStateDesc',title:'状态',width:160},
					{field:'TReqDrug',title:'领药审核',width:160},
					//{field:'TDrugDocAudit',title:'药师审核',width:160},
					{field:'TgiveDrug',title:'发药',width:160},
					{field:'TReqCancelDrg',title:'申请退药',width:160},
					{field:'TcancelDrugQty',title:'退药数量',width:160},
					{field:'TBillState',title:'账单状态',width:100},
					{field:'TPBOID',title:'账单号',width:100,hidden:true}
				]]
			}else if(PatOrdType=='0711'){
				dgOpts.columns=[[
					{field:'TExStDate',title:'要求执行时间',width:100,formatter:function(val,row){
						return '<a class="orderview-chart-table-col-time" href="javascript:void(0);" data-id="'+row.ExecId+'">'+val+'</a>'
					}},
					//{field:'TBilledNum',title:'计费数量',width:80},
					//{field:'TAmount',title:'金额',width:50},
					{field:'TExecStateDesc',title:'状态',width:160}
				]]
			}
			if (typeof NeedPIVAFlag=="string" && NeedPIVAFlag=="Y"){
				dgOpts.columns[0].push({field:'TPIVAStatus',title:'静配状态',width:160});
				dgOpts.columns[0].push({field:'TPIVAStatusDet',title:'静配明细',width:80,formatter:function(val,row){
					return '<a class="orderview-chart-table-col-piva" href="javascript:void(0);" data-id="'+row.ExecId+'">静配明细</a>'
				}});
			}
			if (typeof IsOral!="undefined" && IsOral=="1"){
				dgOpts.columns[0].push({field:'OralDet',title:'口服药明细',width:80,formatter:function(val,row){
					return '<a class="orderview-chart-table-col-oral" href="javascript:void(0);" data-id="'+row.ExecId+'">口服药明细</a>'
				}});
			}
			dgOpts.onLoadSuccess=function(){
				$('.orderview-chart-table-col-piva').off('click').on('click',function(){
					var execId=$(this).data('id');
					showPIVADetails(execId);
				});
				$('.orderview-chart-table-col-oral').off('click').on('click',function(){
					var execId=$(this).data('id');
					showOralDetails(execId);
				});
				///药品执行记录 明细时间轴
				$('.orderview-chart-table-col-time').off('click').on('click',function(){
					var execId=$(this).data('id');
					//$.orderview.easyModal('执行记录','dhc.orderview.csp?ordViewType=DRUGEXEC&ordViewBizId='+execId,'99%','280',$con)
					
					var easyModal=$.orderview.easyModal('执行记录','','95%','280',$con) //第二个参数传空 生成一个空白窗口
					//orderview-easyModal-content
					var myCon=easyModal.find('.orderview-easyModal-content');
					myCon.orderview({
						type:'container',
						ord:'',
						ordViewType:'DRUGEXEC',
						ordViewBizId:execId
					})
					
					
					
				});
			}
			
			return dgOpts;
		}
		function showPIVADetails(execId){
			$.post(opts.baseUrl+'/csp/websys.Broker.cls',{ClassName:'BSP.IMP.PHA.Interface',QueryName:'PIVASRecords',Oeore:execId,ResultSetType:'array',rows:99},function(rows){
				renderPIVADetails(rows);
			},'json')
		}
		function showOralDetails(execId){
			$.post(opts.baseUrl+'/csp/websys.Broker.cls',{ClassName:'BSP.IMP.PHA.Interface',QueryName:'OralRecords',Oeore:execId,ResultSetType:'array',rows:99},function(rows){
				renderPIVADetails(rows);
			},'json')
		}
		function renderPIVADetails(pivaData){
			if(!pivaData || pivaData.length==0) {
				$.messager.popover({msg:'未获取到静配状态变化数据',type:'alert'});
				return;
			}
			var $pivaDetWin=$con.find('.orderview-piva-det-win');
			if ($pivaDetWin.length==0) {
				$pivaDetWin=$('<div id="orderview-piva-det-win" style="padding:10px;"><div class="orderview-piva-det-warp"></div></div>').appendTo($con);
				$pivaDetWin.window({
					title:'静配明细',iconCls:'icon-w-paper',width:$con.width()-20,inline:true,height:170,modal:true,
					collapsible:false,minimizable:false,maximizable:false,draggable:false,resizable:false
				})
			}
			$pivaDetWin.window('open');
			var tempProcessData=[]
			$.each(pivaData,function(ind,item){
				var oprDate=(item.dateTime||'').split(' ')[0]||'',
					oprTime=(item.dateTime||'').split(' ')[1]||'';
				var data={ActCode: 'PIVA'+ind,ActDesc: item.psName,OprDate: oprDate,OprTime: oprTime,OprUser: item.userName||'',Sort: ind+1}
				var one={ActCode:data.ActCode,ActDesc:data.ActDesc,Sort:data.Sort,state:0,data:[]}
				if (data.OprDate!="") {
					one.state=1;
					one.data.push(data);
					one.showData=data;
				}
				tempProcessData.push(one);
			})
			var $process_wrap=$pivaDetWin.find('.orderview-piva-det-warp');
			$.orderview.renderProcessDom($process_wrap,tempProcessData,{
		        branchHeight:115,
		        num:1,
		        processDetailPopover:false,
		        branchStartSort:1000,
		        maxStepWidth:opts.maxStepWidth,
		        lineFollowState0:opts.lineFollowState0,
		        branchStyle:opts.branchStyle
		    })
		}
		
	};
	var renderOrderExecDetails=function(ele,data,chartData,chartPanel){
        renderDetails(ele,data,chartPanel);
    }
    window.renderOrderExecDetails=renderOrderExecDetails;
})(jQuery);
