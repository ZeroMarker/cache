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
	var renderCVTransLog=function(ele,data,chartData,chartPanel){ //��������
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var dgOpts={
			//trID,contact,contactTel,conResult,trAdvice,fwLocDesc,fwUserName,trUserName,trOpDT,trOpDesc
			columns:[[
				{field:'contact',title:'��ϵ��',width:80,align:'left'},
				{field:'contactTel',title:'��ϵ�绰',width:100,align:'left'},
				{field:'conResult',title:'��ϵ���',width:100,align:'left'},
				{field:'fwLocDesc',title:'ת������',width:100,align:'left'},
				{field:'fwUserName',title:'ת��ҽ��',width:80,align:'left'},
				{field:'trAdvice',title:'�����ʩ',width:300,align:'left'},
				{field:'trOpDesc',title:'����',width:80,align:'left'},
				{field:'trUserName',title:'������',width:80,align:'left'},
				{field:'trOpDT',title:'����ʱ��',width:160,align:'left'}
			]],
			//fitColumns:false,
			queryParams:{
				ClassName:'web.DHCAntCVReportTrans',
				QueryName:'QryTransLog',
				OEOrdItem:opts.orders[0],
				reportID:opts.ordViewBizId
			},
			border:true,
			toolbar:null
			
		}
        renderSimpleTable(ele,data,chartPanel,dgOpts);
    }
    window.renderCVTransLog=renderCVTransLog;
    
    
    //��Ⱦ����ҽ��
	function renderCVTransOrd(ele,data,buttonData,modalContent){
		console.log(ele,data,buttonData,modalContent);
		var $ele=$(ele);
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var reportID=opts.ordViewBizId;
		
		modalContent.empty();

		$layout=$('<div >'
					+'<div data-options="region:\'west\',split:false,border:false,headerCls:\'panel-header-gray\'" style="width:530px;padding:10px;"><table class="transOrdTable"></table></div>'
					+'<div data-options="region:\'center\',border:false,headerCls:\'panel-header-gray\'" style="padding:10px 10px 10px 0;"><table class="transOrdExecTable"></table></div>'
				+'</div>'
		).appendTo(modalContent);
			
		var $transOrdTable=$layout.find('.transOrdTable');
		var $transOrdExecTable=$layout.find('.transOrdExecTable');
		$layout.layout({fit:true});
		
		var tbLineHeight=30;
		if(typeof HISUIStyleCode=='string' && HISUIStyleCode=='lite') tbLineHeight=28;
		
		var $tb=$('<div id="transOrdExecTable-tb" style="padding:4px 0 4px 10px;line-height:'+tbLineHeight+'px;"><span style="padding-right:10px;">'+$g('ִ������')+'</span><input class="tb-st" /><span style="padding:0 10px;">'+$g('��')+'</span><input class="tb-end" /> <a href="javascript:void(0);" class="tb-search" style="margin-left:10px;" >��ѯ</a></div> ').appendTo('body');;
		//console.log($tb.html());
		var $st=$tb.find('.tb-st').datebox({});
		var $end=$tb.find('.tb-end').datebox({});
		var $search=$tb.find('.tb-search').linkbutton({
		});

		$transOrdTable.datagrid({
			title:'ҽ����Ϣ',
			iconCls:'icon-paper-info',
			headerCls:'panel-header-gray',
			border:true,
			url:opts.baseUrl+'/csp/websys.Broker.cls',
			queryParams:{reportID:reportID,ClassName:'web.DHCAntCVReportLink',QueryName:'FindOrd'},
			idField:'lkID' ,
			singleSelect:true,
			rownumbers: true,
			pagination: true,
			pageSize:15,
			fit:true,
			pageList: [15,30,50],  
			striped: true ,	
			toolbar:[],
			//lkID,ordItm,ordDesc,ordDoctorName,ordLocDesc,ordDateTime,ordExecNurseName,ordExecDateTime		
			columns:[[
				{field:'ordDesc',title:'ҽ������',width:199},
				{field:'ordDoctorName',title:'��ҽ��ҽ��',width:120},
				{field:'ordDateTime',title:'��ҽ��ʱ��',width:160} //,
				//{field:'ordExecNurseName',title:'ִ�л�ʿ',width:100} ,
				//{field:'ordExecDateTime',title:'ִ��ʱ��',width:150} 
			]],
			onSelect:function(idx,row){
				var st=row.ordDateTime.split(' ')[0];
				$st.datebox('setValue',st);
				if(0&&row.isLongDrug){
					var end="";
				}else{
					var end=st;
				}
				var curDate=new Date();
				var nextDate = new Date(curDate.getTime() + 24*60*60*1000);
				end=$.fn.datebox.defaults.formatter(nextDate);
				$end.datebox('setValue',end);
				$transOrdExecTable.datagrid('load',{orderId:row.ordItm, execStDate:st, execEndDate:end,ClassName:'web.DHCDocMain',QueryName:'FindOrderExecDet'});
			}
		})
		///�˱��ͨ�����ÿ�� ʹ��������п�ͱ���һ��  �����һ�б߿��͸��
		$transOrdTable.datagrid('getPanel').addClass('orderview-dg-nolastborder');
			
		$transOrdExecTable.datagrid({
			title:'ִ�м�¼',
			iconCls:'icon-paper-clock-bue',
			headerCls:'panel-header-gray',
			border:true,
			url:opts.baseUrl+'/csp/websys.Broker.cls',
			queryParams:{orderId:'', execStDate:'', execEndDate:'',ClassName:'web.DHCDocMain',QueryName:'FindOrderExecDet'},
			idField:'HIDDEN' ,
			singleSelect:true,
			rownumbers: true,
			pagination: true,
			pageSize:15,
			fit:true,
			fitColumns:true,
			pageList: [15,30,50],  
			striped: true ,	
			toolbar:'#transOrdExecTable-tb',
			//HIDDEN:%String:OrderExecId,HIDDEN:%String:TItemStatCode,TExStDate:%String:Ҫ��ִ��ʱ��,TExecState:%String:״̬,TExecStateCode:%String:״̬����,TRealExecDate:%String:ִ��ʱ��,THourExEnTime:%String:Сʱҽ������ʱ��,TExecRes:%String:ִ��ԭ��,TExecFreeRes:%String:���ԭ��,TExecUser:%String:������,TExecLoc:%String:����Loc,TBillState:%String:�ʵ�״̬,TExecFreeChargeFlag:%String:���״̬,TgiveDrugQty:%String:��ҩ����,TcancelDrugQty:%String:��ҩ����,TPBOID:%String:�ʵ���,TApplyCancelStatus:%String:���볷��״̬,TApplyCancelStatusCode:%String:���볷��״̬,IsCanExecOrdArrear:%String:Ƿ��ִ�б�־,TExDateTimes:%String:Ҫ��ִ�д���
			columns:[[
				{field:'TExStDate',title:'Ҫ��ִ��ʱ��',width:150},
				{field:'TExecState',title:'״̬',width:100},
				{field:'TExecUser',title:'ִ����',width:100},
				{field:'TRealExecDate',title:'ִ��ʱ��',width:150} 
			]]
		})
		$search.click(function(){
			var st=$st.datebox('getValue');
				var end=$end.datebox('getValue');
				var row=$transOrdTable.datagrid('getSelected');
				console.log(row);
				if(row && row.ordItm){
					$transOrdExecTable.datagrid('load',{orderId:row.ordItm, execStDate:st, execEndDate:end});
				}
		})


	}
    window.renderCVTransOrd=renderCVTransOrd;
    
    
    //��Ⱦ�������
	function renderCVTransEmr(ele,data,buttonData,modalContent){
		console.log(ele,data,buttonData,modalContent);
		var $ele=$(ele);
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var reportID=opts.ordViewBizId;
		modalContent.empty();
		

		var $transEmrPanel=$('<div style="padding:10px;"></div>').appendTo(modalContent);
		var $transEMRTable=$('<table id="transEMRTable"></table>').appendTo($transEmrPanel);
		$transEmrPanel.panel({fit:true,border:false});

		$transEMRTable.datagrid({
			headerCls:'panel-header-gray',
			bodyCls:'panel-header-gray',
			border:true,
			url:opts.baseUrl+'/csp/websys.Broker.cls',
			queryParams:{reportID:reportID,ClassName:'web.DHCAntCVReportLink',QueryName:'FindEMR'},
			idField:'lkID' ,
			singleSelect:true,
			rownumbers: true,
			pagination: true,
			pageSize:10,
			fit:true,
			pageList: [10,30,50],  
			striped: true ,	
			//lkID,insID,insTitle,insCreateUserName,insCreateDateTime	
			columns:[[
				{field:'insTitle',title:'����',width:150},
				{field:'insCreateUserName',title:'����ҽ��',width:150},
				{field:'insCreateDateTime',title:'����ʱ��',width:160},
				{field:'insID',title:'����',width:188,formatter:function(value){
					return '<a class="a-emr-view" data-instance="'+value+'" data-adm="'+(data.Adm||'')+'" href="javascript:void(0);" >�鿴</a>';
				}}
			]],
			onLoadSuccess:function(){
				$transEMRTable.closest('.datagrid').find('.a-emr-view').off('click').on('click',function(){
					var instanceID=$(this).data('instance'),adm=$(this).data('adm');
					//var link='emr.browse.csp?EpisodeID='+adm+'&InstanceID='+instanceID;
					
					getEmrViewLinkCfg(function(link){
						link=$.orderview.formatByJson(link,{EpisodeID:adm,InstanceID:instanceID});
						var maxWidth=screen.availWidth-20;
						var maxHeight=screen.availHeight-40;
						var w=parseInt(maxWidth*0.8),h=parseInt(maxHeight*0.8),l=parseInt((maxWidth-w)/2),t=parseInt((maxHeight-h)/2);
						var features='top='+t+',left='+l+',width='+w+',height='+h+',toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=yes,maximized=yes'
						$.orderview.easyOriginWin(link,'transEMRWin',features);
						
					})
					

				})
			}
		})
		///�˱��ͨ�����ÿ�� ʹ��������п�ͱ���һ��  �����һ�б߿��͸��
		$transEMRTable.datagrid('getPanel').addClass('orderview-dg-nolastborder');
	}
	
	var cacheEmrViewLinkCfg=''
	function getEmrViewLinkCfg(callback){
		if (cacheEmrViewLinkCfg) {
			callback(cacheEmrViewLinkCfg);
		}else{
			$.m({ClassName:'web.DHCAntCVOptions',MethodName:'GetBaseOpt',Code:'EmrViewLink'},function(ret){
				cacheEmrViewLinkCfg=ret;
				callback(ret);
			})
		}
		
	}
	
	
	window.renderCVTransEmr=renderCVTransEmr;
    
    if ($ && $.fn && $.fn.orderview){
	    $.fn.orderview.defaults.labels23=[[
				{label:'����',key:'PatName',css:{fontSize:'16px'},hideLabel:true,hideSep:true},
				{label:'�Ա�',key:'PatSex',hideLabel:true,hideSep:true},
				{label:'����',key:'PatAge',hideLabel:true},
				{label:'�������',key:'AdmLocDesc'},
				{label:'����ʱ��',key:'AdmDT'},
				{label:'����ҽ��',key:'AdmDocName'},
		    	{label:'���ߵ绰',key:'PatPhone'}
		    ],[
		    	{label:'ҽ������',key:'OrdItemDesc'},
		    	{label:'���(��)��',key:'ExamNo'},
				{label:'ҽ��ʱ��',key:'OrdAddDT',type:'date'},
				{label:'��������',key:'OrdLocDesc'},
				{label:'����ҽ��',key:'OrdDocName'}
	    	],[
	    		{label:'Σ��ֵ���',key:'RepResult'}
	    	]
	    ]
	}
    
})(jQuery);
