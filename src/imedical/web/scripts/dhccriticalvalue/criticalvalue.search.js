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
	            // ����Ѿ�ִ�й�������ִ��
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
		data:[{value:'',text:'ȫ��'},{value:'C',text:'δ����'},{value:'F',text:'�Ѵ���'}],
		panelHeight:'auto',editable:false
	}).combobox('setValue','');
	
	$('#pAdmType').combobox({
		data:[{value:'',text:'ȫ��'},{value:'O',text:'����'},{value:'E',text:'����'},{value:'I',text:'סԺ'},{value:'H',text:'���'}],
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
		columns:[[{field:'LocDesc',title:'��������',width:200},{field:'LocCode',title:'���Ҵ���',width:200}]],
		pagination:true
	})
	
	$.q({ClassName:'web.DHCAntCVOptions',QueryName:'Find',OptsType:'CVType',q:''},function(data){
		if (data && data.rows){
			$.each(data.rows,function(i,item){
				$('#pReportType').combobox({
					//(1:����,2����,3�ĵ�,4����,5�ھ�,6����)
					data:[{TCode:'',TDesc:'ȫ��'}].concat(data.rows),
					textField:'TDesc',valueField:'TCode',
					editable:false,panelHeight:'200',editable:false
				}).combobox('setValue','');
			})
		}else{
			$('#pReportType').combobox({
				//(1:����,2����,3�ĵ�,4����,5�ھ�,6����)
				data:[{value:'',text:'ȫ��'},{value:'1',text:'����'},{value:'2',text:'����'},{value:'2',text:'�ĵ�'},{value:'4',text:'����'},{value:'5',text:'�ھ�'},{value:'6',text:'����'}],
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
	if (GV.IsForOE=="1") { //������ż������ 1����ˢ��һ��
		setTimeout(function(){
			clear_fun();
			search_fun();
		},1000*60*1);
	}
	
	
	if($('#DateFrom').closest('td').height()>50){ //��������������
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
			{title:'����ID',field:'ReportId',width:120},
			{title:'����ʱ��',field:'DPRPDate',width:150,formatter:function(val,row,ind){
				return val+' '+row['DPRPTime'];
			}},
			{title:'�ǼǺ�',field:'DebtorNo',width:120},
			{title:'��������',field:'PatName',width:120},
			{title:'�Ա�',field:'Species',width:60},
			{title:'��������',field:'DOB',width:120},
			{title:'����',field:'Age',width:60},
			{title:'�������',field:'Location',width:120},
			{title:'ҽ��',field:'Doctor',width:80},
			{title:'����(��)��',field:'LabEpis',width:120,formatter:function(value,row,ind){
				return value.replace(/--/ig,'||');   //���������滻��������
			}},
			{title:'ҽ������',field:'TestSet',width:200},
			{title:'��ϵ�˵绰',field:'MobPhone',width:120},
			{title:'��ϵ��',field:'ToPerson',width:120},
			{title:'������',field:'TransMemo',width:120},
			{title:'ҽ���벡��',field:'TransOrdAndEMR',width:120,formatter:function(val,row,ind){
				var ret=""
				if (row.HasTransOrd=="��" || row.HasTransOrd=="1"){
					ret+='<a href="javascript:void(0);" onclick="openTransOrd(\''+ind+'\')">ҽ��</a>';
				}
				if (row.HasTransEMR=="��" || row.HasTransEMR=="1"){
					ret+=(ret==""?'':'&nbsp;&nbsp;')+'<a href="javascript:void(0);" onclick="openTransEmr(\''+ind+'\')">����</a>';
				}
				return ret
			}},
			{title:'����ʱ��',field:'TransDate',width:150,formatter:function(val,row,ind){
				return val+' '+row['TransDTime'];
			}},
			//{title:'����ʱ��',field:'TransDTime',width:120},
			{title:'������',field:'TransUser',width:120},
			{title:'��������',field:'ReportType',hidden:true}
			
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
			text:'����',
			iconCls:'icon-excel',
			handler:function(){
				$.messager.progress({  //��xlsx����ʱһ��ܿ죬����һ������    ��MSExcel,�����̣���������û��
					title:'���ڵ���'
					,msg:'���ڵ�������,���Ժ�...'	
				});
				
				grid2excel($('#reportList'),{IE11IsLowIE:false,filename:'Σ��ֵ��¼',allPage:true,callback:function(success,data){
					if(success){
						$.messager.popover({msg:'�����ɹ� '+(data||''),type:'success'});
					}else{
						$.messager.popover({msg:'����ʧ�� '+(data||''),type:'error'});
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
					title:'Σ��ֵ',
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
		
		var $tb=$('<div id="transOrdExecTable-tb" style="padding:4px 0 4px 10px;line-height:30px;">ִ�����ڣ�<input class="tb-st" /> -- <input class="tb-end" /> <a href="javascript:void(0);" class="tb-search" style="margin-left:10px;" >��ѯ</a></div> ').appendTo('body');;
		//console.log($tb.html());
		var $st=$tb.find('.tb-st').datebox({});
		var $end=$tb.find('.tb-end').datebox({});
		var $search=$tb.find('.tb-search').linkbutton({
		});
		var bestSize=GV.util.bestSize(1200,600)
		$transOrdWin.dialog({
			title:'ҽ��',
			width:bestSize.width,
			height:bestSize.height,
			modal:true,
			closed:true,
			iconCls:'icon-w-paper'
		}).dialog('open');
		$layout.layout({fit:true});
		
		$transOrdTable.datagrid({
			title:'ҽ����Ϣ',
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
				{field:'ordDesc',title:'ҽ������',width:150},
				{field:'ordDoctorName',title:'��ҽ��ҽ��',width:150},
				{field:'ordDateTime',title:'��ҽ��ʱ��',width:150} //,
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
				$transOrdExecTable.datagrid('load',{orderId:row.ordItm, execStDate:st, execEndDate:end});
			}
		})
		
		$transOrdExecTable.datagrid({
			title:'ִ�м�¼',
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
			title:'����',
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
				{field:'insTitle',title:'����',width:150},
				{field:'insCreateUserName',title:'����ҽ��',width:150},
				{field:'insCreateDateTime',title:'����ʱ��',width:150},
				{field:'insID',title:'����',width:100,formatter:function(value){
					return '<a href="javascript:void(0);" onclick="openEMRView(\''+value+'\');">�鿴</a>'
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
	//����websys.jquery.js�е� $.formatByJson
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