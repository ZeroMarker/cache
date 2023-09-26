$.fn.combogrid.defaults.height=30;
if(typeof GV=="undefined") var GV={};
GV.nowDate=$.fn.datebox.defaults.formatter(new Date());
GV.util={
	debounce:function(func, wait, immediate) {
	    var timeout, result;
	    var debounced = function () {
	        var context = this;
	        var args = arguments;

	        if (timeout) clearTimeout(timeout);
	        if (immediate) {
	            // 如果已经执行过，不再执行
	            var callNow = !timeout;
	            timeout = setTimeout(function(){
	                timeout = null;
	            }, wait)
	            if (callNow) result = func.apply(context, args)
	        }
	        else {
	            timeout = setTimeout(function(){
	                func.apply(context, args)
	            }, wait);
	        }
	        return result;
	    };

	    debounced.cancel = function() {
	        clearTimeout(timeout);
	        timeout = null;
	    };

	    return debounced;
	},
	formatPAPMINO:function(no){
		no+='';
		if(no!=""){
			while(no.length<10){
				no=0+''+no;
			}	
		}
		return no;
	},
	easyModal:function(title,url,width,height){
		var $easyModal=$('#easyModal');
		if ($easyModal.length==0){
			$easyModal=$('<div id="easyModal" style="overflow:hidden;"><iframe name="easyModal" style="	width: 100%;height: 100%; margin:0; border: 0;" scroll="auto"></iframe></div>').appendTo('body');
		}
		var maxWidth=$(window).width(),maxHeight=$(window).height();
		width=''+(width||'80%'),width=Math.min(maxWidth-20,(width.indexOf('%')>-1?parseInt(maxWidth*parseFloat(width)*0.01):parseInt(width)));
		height=''+(height||'80%'),height=Math.min(maxHeight-20,(height.indexOf('%')>-1?parseInt(maxHeight*parseFloat(height)*0.01):parseInt(height)));
		$easyModal.find('iframe').attr('src',url);
		$easyModal.dialog({
			iconCls:'icon-w-paper',
			modal:true,
			title:title,
			width:width,
			height:height
		}).dialog('open').dialog('center');
		
	},
	bestSize:function(width,height){
		var maxWidth=$(window).width(),maxHeight=$(window).height();
		width=''+(width||'80%'),width=Math.min(maxWidth-20,(width.indexOf('%')>-1?parseInt(maxWidth*parseFloat(width)*0.01):parseInt(width)));
		height=''+(height||'80%'),height=Math.min(maxHeight-20,(height.indexOf('%')>-1?parseInt(maxHeight*parseFloat(height)*0.01):parseInt(height)));
		return {width:width,height:height};
	}
}
var initSearch=function(){
	$('#DateFrom').datebox('setValue',GV.nowDate);
	$('#DateTo').datebox('setValue',GV.nowDate);
	$('#pStatus').combobox({
		data:[{value:'',text:'全部'},{value:'C',text:'未处理'},{value:'F',text:'已处理'}],
		panelHeight:'auto',editable:false
	}).combobox('setValue','');
	
	$('#pAdmType').combobox({
		data:[{value:'',text:'全部'},{value:'O',text:'门诊'},{value:'E',text:'急诊'},{value:'I',text:'住院'},{value:'H',text:'体检'}],
		panelHeight:'auto',editable:false
	}).combobox('setValue','');

	$('#pAdmLoc').combogrid({
		panelWidth:450,
		delay: 500,
		mode: 'remote',
		url:$URL+"?ClassName=web.DHCAntCVMsgCfg&QueryName=FindLoc",
		onBeforeLoad:function(param){
			param.HospId=GV.HospId||'';
			param.desc=param.q;
			return true;
		},
		idField:"LocId",textField:"LocDesc",
		columns:[[{field:'LocDesc',title:'科室名称',width:200},{field:'LocCode',title:'科室代码',width:200}]],
		pagination:true
	})
	
	$.q({ClassName:'web.DHCAntCVOptions',QueryName:'Find',OptsType:'CVType',q:''},function(data){
		if (data && data.rows){
			$.each(data.rows,function(i,item){
				$('#pReportType').combobox({
					//(1:检验,2病理,3心电,4超声,5内镜,6放射)
					data:[{TCode:'',TDesc:'全部'}].concat(data.rows),
					textField:'TDesc',valueField:'TCode',
					editable:false,panelHeight:'200',editable:false
				}).combobox('setValue','');
			})
		}else{
			$('#pReportType').combobox({
				//(1:检验,2病理,3心电,4超声,5内镜,6放射)
				data:[{value:'',text:'全部'},{value:'1',text:'检验'},{value:'2',text:'病理'},{value:'2',text:'心电'},{value:'4',text:'超声'},{value:'5',text:'内镜'},{value:'6',text:'放射'}],
				editable:false,panelHeight:'auto',editable:false
			}).combobox('setValue','');
		}
		if (typeof GV.ReportType=="string" && GV.ReportType>0) 	$('#pReportType').combobox('setValue',GV.ReportType).combobox('disable');
	})

	
	
	var search_fun=function(){
		var DateFrom=$('#DateFrom').datebox('getValue');
		if (DateFrom=='') {DateFrom=GV.nowDate;$('#DateFrom').datebox('setValue',DateFrom);}
		
		var DateTo=$('#DateTo').datebox('getValue');
		if (DateTo=='') {DateTo=DateFrom;$('#DateTo').datebox('setValue',DateTo);}
		if (GV.IsForOE!="1") {
			var pAdmType=$('#pAdmType').combobox('getValue');
			var pAdmLoc= $('#pAdmLoc').combogrid('getValue');
			var pStatus=$('#pStatus').combobox('getValue');
			var pReportType=$('#pReportType').combobox('getValue');
		}else{
			var pAdmType='OE';
			var pAdmLoc='';
			var pStatus='';
			var pReportType=GV.ReportType>0?GV.ReportType:'';
		}
		var params={
	        DateFrom: DateFrom,
	        DateTo : DateTo, 
	        LocId : '', 
	        QryType : pAdmType, 
	        TransStatus : pStatus, 
			ReportType : pReportType,
			pAdmLocId:pAdmLoc
			,pHospId:GV.HospId||''
		};
		//console.log(params);
		$('#reportList').datagrid('load',params);
		
		
	}
	$('#btnFind').click(search_fun);
	
	var clear_fun=function(){
		$('#DateFrom').datebox('setValue',GV.nowDate);
		$('#DateTo').datebox('setValue',GV.nowDate);
		if (GV.IsForOE!="1") {
			$('#pAdmType').combobox('clear');
			$('#pStatus').combobox('setValue','');
			$('#pReportType').combobox('clear');
		}

		
	}
	
	$('#btnClear').click(clear_fun);
	if (GV.IsForOE=="1") { //如果是门急诊界面 1分钟刷新一次
		setTimeout(function(){
			clear_fun();
			search_fun();
		},1000*60*1);
	}
	
	
	if($('#DateFrom').closest('td').height()>50){ //出现了折行现象
		var $newTr=$('<tr></tr>').appendTo( $('#DateFrom').closest('table'));
		$newTr.append($('#pStatus').closest('td').prev('td'));
		$newTr.append($('#pStatus').closest('td'));
		$newTr.append($('#pReportType').closest('td').prev('td'));
		$newTr.append($('#pReportType').closest('td'));
		
		$('#center-layout').layout('panel','north').panel('resize',{height:90});
		$('#center-layout').layout('resize');
	}
}
var init=function(){
	$('#reportList').datagrid({
		bodyCls:'panel-header-gray',
		url:$URL+"?ClassName=web.DHCAntCVReportSearch&QueryName=GetCVReportNew",
		fit:true,
		border:false,
		idField:'reportID',
		columns:[[
			{title:'报告ID',field:'ReportId',width:120},
			{title:'报告时间',field:'DPRPDate',width:150,formatter:function(val,row,ind){
				return val+' '+row['DPRPTime'];
			}},
			{title:'登记号',field:'DebtorNo',width:120},
			{title:'病人姓名',field:'PatName',width:120},
			{title:'性别',field:'Species',width:60},
			{title:'出生日期',field:'DOB',width:120},
			{title:'年龄',field:'Age',width:60},
			{title:'就诊科室',field:'Location',width:120},
			{title:'医生',field:'Doctor',width:80},
			{title:'检验(查)号',field:'LabEpis',width:120,formatter:function(value,row,ind){
				return value.replace(/--/ig,'||');   //把两横线替换成两竖线
			}},
			{title:'医嘱名称',field:'TestSet',width:200},
			{title:'联系人电话',field:'MobPhone',width:120},
			{title:'联系人',field:'ToPerson',width:120},
			{title:'处理结果',field:'TransMemo',width:120},
			{title:'医嘱与病历',field:'TransOrdAndEMR',width:120,formatter:function(val,row,ind){
				var ret=""
				if (row.HasTransOrd=="是" || row.HasTransOrd=="1"){
					ret+='<a href="javascript:void(0);" onclick="openTransOrd(\''+ind+'\')">医嘱</a>';
				}
				if (row.HasTransEMR=="是" || row.HasTransEMR=="1"){
					ret+=(ret==""?'':'&nbsp;&nbsp;')+'<a href="javascript:void(0);" onclick="openTransEmr(\''+ind+'\')">病程</a>';
				}
				return ret
			}},
			{title:'处理时间',field:'TransDate',width:150,formatter:function(val,row,ind){
				return val+' '+row['TransDTime'];
			}},
			//{title:'处理时间',field:'TransDTime',width:120},
			{title:'处理人',field:'TransUser',width:120},
			{title:'报告类型',field:'ReportType',hidden:true}
			
		]],
		rowStyler:function(ind,row){
			if (GV.IsForOE=="1" && row.colorflag>0) {
				return 'background-color:#E2FAFA';	
			}
			return '';
		},
		queryParams:{
	        DateFrom: GV.nowDate,
	        DateTo : GV.nowDate, 
	        LocId : '', 
	        QryType : GV.IsForOE!="1"?"":"OE",
	        TransStatus : '', 
	        ReportType : GV.ReportType>0?GV.ReportType:''
	        ,pAdmLocId:''
	        ,pHospId:GV.HospId||''
		},
		pagination:true,
		pageSize:20,
		pageList:[20,50,100],
		rownumbers:true,
		striped:true,
		singleSelect:true,
		toolbar:[{
			text:'导出',
			iconCls:'icon-excel',
			handler:function(){
				$.messager.progress({  //用xlsx导出时一般很快，可能一闪而过    用MSExcel,卡进程，动画基本没有
					title:'正在导出'
					,msg:'正在导出数据,请稍后...'	
				});
				
				grid2excel($('#reportList'),{IE11IsLowIE:false,filename:'危急值记录',allPage:true,callback:function(success,data){
					if(success){
						$.messager.popover({msg:'导出成功 '+(data||''),type:'success'});
					}else{
						$.messager.popover({msg:'导出失败 '+(data||''),type:'error'});
					}
					$.messager.progress('close');
				}});
			}
		}],
		onDblClickRow:function(ind,row){
			if($('#transWin').length==0){
				$('<div id="transWin" style="overflow:hidden;"><iframe name="transWin_iframe" id="transWin_iframe" scrolling="auto" frameborder=0 style="width:100%;height:100%;"></iframe></div>').appendTo('body');
				var bestSize=GV.util.bestSize(1200,590);
				$('#transWin').dialog({
					width:bestSize.width,
					height:bestSize.height,	
					onClose:function(){
						$('#reportList').datagrid('reload');
						$('#transWin_iframe').attr('src','');
					},
					title:'危急值',
					iconCls:'icon-w-paper',
					closed:true,
					modal:true,
				})
			}
			$('#transWin').dialog('open');
			var url="criticalvalue.trans.hisui.csp"+"?ReportId="+row.ReportId+"&RepType="+row.ReportType;
			$('#transWin_iframe').attr('src',url);
		}
		
	})
};
function closeTransWin(){
	$('#transWin').dialog('close');
	$('#transWin_iframe').attr('src','');
}
function openTransOrd(ind){
	var row=$('#reportList').datagrid('getRows')[ind];
	GV.currentRow=row;
	console.log(row)
	var $transOrdWin=$('#transOrdWin');
	var $transOrdTable=$('#transOrdTable');
	var $transOrdExecTable=$('#transOrdExecTable');
	
	if ($transOrdWin.length>0){
		$transOrdWin.dialog('open');
		
		$transOrdTable.datagrid('clearSelections').datagrid('load',{reportID:row.reportID});
		
		$transOrdExecTable.datagrid('clearSelections').datagrid('loadData',{total:0,rows:[]});
		$('#transOrdExecTable-tb').find('.tb-st').datebox('setValue','');
		$('#transOrdExecTable-tb').find('.tb-end').datebox('setValue','');
		
	}else{
		$transOrdWin=$('<div id="transOrdWin"></div>').appendTo('body');
		$layout=$('<div >'
					+'<div data-options="region:\'west\',split:false,border:false,headerCls:\'panel-header-gray\'" style="width:600px;padding:10px;"><table id="transOrdTable" class="transOrdTable"></table></div>'
					+'<div data-options="region:\'center\',border:false,headerCls:\'panel-header-gray\'" style="padding:10px 10px 10px 0;"><table id="transOrdExecTable" class="transOrdExecTable"></table></div>'
				+'</div>'
		).appendTo($transOrdWin);
		
		$transOrdTable=$layout.find('.transOrdTable');
		$transOrdExecTable=$layout.find('.transOrdExecTable');
		
		var $tb=$('<div id="transOrdExecTable-tb" style="padding:4px 0 4px 10px;line-height:30px;">执行日期：<input class="tb-st" /> -- <input class="tb-end" /> <a href="javascript:void(0);" class="tb-search" style="margin-left:10px;" >查询</a></div> ').appendTo('body');;
		//console.log($tb.html());
		var $st=$tb.find('.tb-st').datebox({});
		var $end=$tb.find('.tb-end').datebox({});
		var $search=$tb.find('.tb-search').linkbutton({
		});
		var bestSize=GV.util.bestSize(1200,600)
		$transOrdWin.dialog({
			title:'医嘱',
			width:bestSize.width,
			height:bestSize.height,
			modal:true,
			closed:true,
			iconCls:'icon-w-paper'
		}).dialog('open');
		$layout.layout({fit:true});
		
		$transOrdTable.datagrid({
			title:'医嘱信息',
			headerCls:'panel-header-gray',
			border:true,
			url:'jquery.easyui.querydatatrans.csp?ClassName=web.DHCAntCVReportLink&QueryName=FindOrd',
			queryParams:{reportID:row.reportID},
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
				{field:'ordDesc',title:'医嘱名称',width:150},
				{field:'ordDoctorName',title:'下医嘱医生',width:150},
				{field:'ordDateTime',title:'下医嘱时间',width:150} //,
				//{field:'ordExecNurseName',title:'执行护士',width:100} ,
				//{field:'ordExecDateTime',title:'执行时间',width:150} 
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
				$transOrdExecTable.datagrid('load',{orderId:row.ordItm, execStDate:st, execEndDate:end});
			}
		})
		
		$transOrdExecTable.datagrid({
			title:'执行记录',
			headerCls:'panel-header-gray',
			border:true,
			url:'jquery.easyui.querydatatrans.csp?ClassName=web.DHCDocMain&QueryName=FindOrderExecDet',
			queryParams:{orderId:'', execStDate:'', execEndDate:''},
			idField:'HIDDEN' ,
			singleSelect:true,
			rownumbers: true,
			pagination: true,
			pageSize:15,
			fit:true,
			pageList: [15,30,50],  
			striped: true ,	
			toolbar:'#transOrdExecTable-tb',
			//HIDDEN:%String:OrderExecId,HIDDEN:%String:TItemStatCode,TExStDate:%String:要求执行时间,TExecState:%String:状态,TExecStateCode:%String:状态代码,TRealExecDate:%String:执行时间,THourExEnTime:%String:小时医嘱结束时间,TExecRes:%String:执行原因,TExecFreeRes:%String:免费原因,TExecUser:%String:处理人,TExecLoc:%String:处理Loc,TBillState:%String:帐单状态,TExecFreeChargeFlag:%String:免费状态,TgiveDrugQty:%String:发药数量,TcancelDrugQty:%String:退药数量,TPBOID:%String:帐单号,TApplyCancelStatus:%String:申请撤销状态,TApplyCancelStatusCode:%String:申请撤销状态,IsCanExecOrdArrear:%String:欠费执行标志,TExDateTimes:%String:要求执行次数
			columns:[[
				{field:'TExStDate',title:'要求执行时间',width:150},
				{field:'TExecState',title:'状态',width:100},
				{field:'TExecUser',title:'执行人',width:100},
				{field:'TRealExecDate',title:'执行时间',width:150} 
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
	
	
	
	
	
	
	
	
	
}
function openTransEmr(ind){
	var row=$('#reportList').datagrid('getRows')[ind];
	GV.currentRow=row;
	var $transEMRWin=$('#transEMRWin');
	var $transEMRTable=$('#transEMRTable');
	if ($transEMRWin.length>0){
		$transEMRWin.dialog('open');
		$transEMRTable.datagrid('load',{reportID:row.reportID});
	}else{
		$transEMRWin=$('<div id="transEMRWin" style="padding:10px;"></div>').appendTo('body');
		$transEMRTable=$('<table id="transEMRTable"></table>').appendTo($transEMRWin);
		$transEMRWin.dialog({
			title:'病程',
			width:620,
			height:400,
			modal:true,
			closed:true,
			iconCls:'icon-w-paper'
		}).dialog('open');
		$transEMRTable.datagrid({
			headerCls:'panel-header-gray',
			bodyCls:'panel-header-gray',
			border:true,
			url:'jquery.easyui.querydatatrans.csp?ClassName=web.DHCAntCVReportLink&QueryName=FindEMR',
			queryParams:{reportID:row.reportID},
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
				{field:'insTitle',title:'标题',width:150},
				{field:'insCreateUserName',title:'创建医生',width:150},
				{field:'insCreateDateTime',title:'创建时间',width:150},
				{field:'insID',title:'病历',width:100,formatter:function(value){
					return '<a href="javascript:void(0);" onclick="openEMRView(\''+value+'\');">查看</a>'
				}}
			]]
		})
	}
}
function openEMRView(instanceID){
	var obj={
		EpisodeID:GV.currentRow.Adm,
		UserCode:GV.UserCode,
		UserID:GV.UserId,
		GroupID:GV.GroupId,
		CTLocID:GV.LocId,
		AntCVID:GV.currentRow.reportID,
		PatientID:GV.currentRow.PatientID,
		mradm:GV.currentRow.mradm||'',
		InstanceID:instanceID
	}
	//调用websys.jquery.js中的 $.formatByJson
	var link=$.formatByJson(GV.EmrViewLink,obj);
	var maxWidth=screen.availWidth-20;
	var maxHeight=screen.availHeight-40;
	var w=parseInt(maxWidth*0.8),h=parseInt(maxHeight*0.8),l=parseInt((maxWidth-w)/2),t=parseInt((maxHeight-h)/2);
	var features='top='+t+',left='+l+',width='+w+',height='+h+',toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=yes,maximized=yes'
	window.open(link,'transEMRWin',features);
}
$(function(){
	init();
	initSearch();	
});