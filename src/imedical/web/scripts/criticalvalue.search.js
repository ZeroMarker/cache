;(function ($) {
	$.fn.combogrid.methods.setRemoteValue=function (jq,param) {
    	return jq.each(function(){
	    	if (typeof param=="string"){
		    	$(this).combogrid('setValue',param);
		    }else{
			    var val=param['value']||'';
			    var text=param['text']||'';
			    $(this).combogrid('options').keyHandler.query.call(this,text);
				$(this).combogrid('setValue',val).combogrid('setText',text);
			}
	    })
    }
})(jQuery);
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
	
	
	
//	if (GV.ReceiveMode>0) {
//		$('#pStatus').combobox({
//			data:[{value:'C',text:$g('δ����δ����')},{value:'Rec',text:$g('δ�����ѽ���')},{value:'F',text:$g('�Ѵ���')}],
//			panelHeight:'auto',editable:false,multiple:true
//		}).combobox('setValues',[]);
//	}else{
//		$('#pStatus').combobox({
//			data:[{value:'',text:$g('ȫ��')},{value:'C,Rec',text:$g('δ����')},{value:'F',text:$g('�Ѵ���')}],
//			panelHeight:'auto',editable:false
//		}).combobox('setValue','');
//	}


	//�µ�Σ��ֵ״̬��ѯ
	if (GV.EXECTIMELIMIT>0) {
		$('#pExecStatus').combobox({
			data:[{value:'1',text:$g('��ʱ����')},{value:'2',text:$g('��ʱ����')},{value:'3',text:$g('δ��ʱδ����')},{value:'4',text:$g('��ʱδ����')}],
			panelHeight:'auto',editable:false,multiple:true,rowStyle:'checkbox'
		}).combobox('setValues',[]);
	}else{
		$('#pExecStatus').combobox({
			data:[{value:'',text:$g('ȫ��')},{value:'12',text:$g('�Ѵ���')},{value:'34',text:$g('δ����')}],
			panelHeight:'auto',editable:false,multiple:false
		}).combobox('setValue','');
		
	}
	if (GV.ReceiveMode>0) {
		if (GV.RECTIMELIMIT>0) {
			$('#pRecStatus').combobox({
				data:[{value:'1',text:$g('��ʱ����')},{value:'2',text:$g('��ʱ����')},{value:'3',text:$g('δ��ʱδ����')},{value:'4',text:$g('��ʱδ����')}],
				panelHeight:'auto',editable:false,multiple:true,rowStyle:'checkbox'
			}).combobox('setValues',[]);
		}else{
			$('#pRecStatus').combobox({
				data:[{value:'',text:$g('ȫ��')},{value:'12',text:$g('�ѽ���')},{value:'34',text:$g('δ����')}],
				panelHeight:'auto',editable:false,multiple:false
			}).combobox('setValue','');
			
		}
	}
	
	$('#pAdmType').combobox({
		data:[{value:'',text:$g('ȫ��')},{value:'O',text:$g('����')},{value:'E',text:$g('����')},{value:'I',text:$g('סԺ')},{value:'H',text:$g('���')}],
		panelHeight:'auto',editable:false
	}).combobox('setValue','');
	
	$('#pHospId').combogrid({
		panelWidth:450,
		delay: 500,
		mode: 'remote',
		url:$URL+"?ClassName=web.CTHospital&QueryName=List",
		onBeforeLoad:function(param){
			param.desc=param.q;
			return true;
		},
		onSelect:function(row){
			setTimeout(function(){
				$('#pAdmLoc').combogrid('setRemoteValue',{value:'',text:''})	
			},200)
		},
		onLoadSuccess:function(data){

		},
		idField:"HOSPRowId",textField:"HOSPDesc",
		columns:[[{field:'HOSPDesc',title:'ҽԺ����',width:200},{field:'HOSPCode',title:'ҽԺ����',width:200}]],
		pagination:true
	})
	
	if ($('#pHospId').length>0) { //Ĭ�ϵ�ǰ��¼Ժ��
		$('#pHospId').combogrid('setRemoteValue',{value:GV.HospId,text:GV.HospDesc});
	}
	
	var getHospId=function(){
		var hospId='';
		if ($('#pHospId').length>0) {
			hospId=$('#pHospId').combogrid('getValue');
			
		}else{
			if (GV.HospControl=='ALL'){
				hospId='';
			}else{
				hospId=GV.HospId||'';	
			}
			
		}
		return hospId;
	}
	
	$('#pAdmLoc').combogrid({
		panelWidth:450,
		delay: 500,
		mode: 'remote',
		url:$URL+"?ClassName=web.DHCAntCVMsgCfg&QueryName=FindLoc",
		onBeforeLoad:function(param){
			param.HospId=getHospId();
			param.desc=param.q;
			return true;
		},
		idField:"LocId",textField:"LocDesc",
		columns:[[{field:'LocDesc',title:'��������',width:200},{field:'LocCode',title:'���Ҵ���',width:200}]],
		pagination:true
	})
	
	$('#pAdmDocId').combogrid({
		panelWidth:450,
		delay: 500,
		mode: 'remote',
		url:$URL,
		queryParams:{
			ClassName:'web.DHCAntCVComm',
			QueryName:'LookUpUser',
			onlyActive:1,
			UseRes:1,
			CareType:'DOCTOR'
		},
		onBeforeLoad:function(param){
			param.LocId='';
			return true;
		},
		onSelect:function(ind,row){

		},
		idField:"TId",textField:"TDesc",
		columns:[[{field:'TDesc',title:'����',width:200},{field:'TCode',title:'����',width:200}]],
		pagination:true
	})
	
	$.q({ClassName:'web.DHCAntCVOptions',QueryName:'Find',OptsType:'CVType',q:''},function(data){
		if (data && data.rows){
			$.each(data.rows,function(){this.TDesc=$g(this.TDesc);})
			$('#pReportType').combobox({
				//(1:����,2����,3�ĵ�,4����,5�ھ�,6����)
				data:[{TCode:'',TDesc:$g('ȫ��')}].concat(data.rows),
				textField:'TDesc',valueField:'TCode',
				editable:false,panelHeight:'200',editable:false
			}).combobox('setValue','');
		}else{
			$('#pReportType').combobox({
				//(1:����,2����,3�ĵ�,4����,5�ھ�,6����)
				data:[{value:'',text:'ȫ��'},{value:'1',text:'����'},{value:'2',text:'����'},{value:'3',text:'�ĵ�'},{value:'4',text:'����'},{value:'5',text:'�ھ�'},{value:'6',text:'����'}],
				editable:false,panelHeight:'auto',editable:false
			}).combobox('setValue','');
		}
		if (typeof GV.ReportType=="string" && GV.ReportType>0) 	$('#pReportType').combobox('setValue',GV.ReportType).combobox('disable');
	})

	
		
	if ($('#pExecTimeUsed').length>0) {
		$('#pExecTimeUsed').combobox({
			data:GV.ExecTimeUsedData,textField:'value',valueField:'key',multiple:true
		})
	}
	
	$('#pPapmiNo').on('keyup',function(e){
		if(e.keyCode==13){
			var val=$('#pPapmiNo').val();
			if (val!='') {
				var newval=$.trim(val);
				newval=GV.util.formatPAPMINO(newval);
				if (newval!=val){
					$('#pPapmiNo').val(newval);
				}
				$('#btnFind').click();
			}	
			
		}
		
	}).on('blur',function(){
		var val=$('#pPapmiNo').val();
		if (val!='') {
			var newval=$.trim(val);
			newval=GV.util.formatPAPMINO(newval);
			if (newval!=val){
				$('#pPapmiNo').val(newval);
			}
		}	
			
		
	})
	

	var search_fun=function(){
		var DateFrom=$('#DateFrom').datebox('getValue');
		if (DateFrom=='') {DateFrom=GV.nowDate;$('#DateFrom').datebox('setValue',DateFrom);}
		
		var DateTo=$('#DateTo').datebox('getValue');
		if (DateTo=='') {DateTo=DateFrom;$('#DateTo').datebox('setValue',DateTo);}
		if (GV.IsForOE!="1") {
			var pAdmType=$('#pAdmType').combobox('getValue');
			var pAdmLoc= $('#pAdmLoc').length>0?$('#pAdmLoc').combogrid('getValue'):'';
			//var pStatus=$('#pStatus').combobox('getValues').join(',');
			var pReportType=$('#pReportType').combobox('getValue');
			
		}else{
			var pAdmType='OE';
			var pAdmLoc='';
			//var pStatus='';
			var pReportType=GV.ReportType>0?GV.ReportType:'';
		}
		var pLocId="";
		if (GV.OnlyCurrLoc=='1') pLocId=GV.LocId;
		
		var pExecTimeUsed=$('#pExecTimeUsed').length>0?$('#pExecTimeUsed').combobox('getValues').join(','):'';
		var pPapmiNo=$('#pPapmiNo').length>0?$('#pPapmiNo').val():'';
		
		var pStatus='^';
		var pExecStatus=$('#pExecStatus').length>0?$('#pExecStatus').combobox('getValues').join(''):'';
		var pRecStatus=$('#pRecStatus').length>0?$('#pRecStatus').combobox('getValues').join(''):'';
		pStatus=pStatus+'^'+pRecStatus+'^'+pExecStatus;  //TransStatus^��3λ������״̬^��4λ������״̬
		
		var pAdmDocId=$('#pAdmDocId').length>0?$('#pAdmDocId').combogrid('getValue'):'';
		
		var params={
	        DateFrom: DateFrom,
	        DateTo : DateTo, 
	        LocId : pLocId,
	        QryType : pAdmType, 
	        TransStatus : pStatus, 
			ReportType : pReportType,
			pAdmLocId:pAdmLoc
			,pHospId:getHospId()
			,pExecTimeUsed:pExecTimeUsed
			,pPapmiNo:pPapmiNo
			,pAdmDocId:pAdmDocId
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
	
	
	if ($('.f-item').length>10) {  //5��Ԫ��һ��
		var rowCnt=1;
		var $newTr=null;
		$('.f-item').each(function(ind,item){
			if (ind>0 && ind%10==0) {
				$newTr=$('<tr style="height:40px;"></tr>').appendTo( $(this).closest('table') );
				rowCnt++;
			}
			if (ind>9) {
				$newTr.append($(this));
			}
			
		})
		
		var height=40*rowCnt+11;
		$('#center-layout').layout('panel','north').panel('resize',{height:height});
		$('#center-layout').layout('resize');
	}
	
}
var init=function(){
	var columns0=[
			{title:'����ID',field:'reportID',width:140,formatter:function(val,row,ind){
				return '<a href="javascript:void(0);" onclick="openOrderView(\''+ind+'\')">'+val+'</a>'	;
			}},
			{title:'����ʱ��',field:'DPRPDate',width:160,formatter:function(val,row,ind){
				return val+' '+row['DPRPTime'];
			}},
			{title:'������',field:'repUser',width:80},
			{title:'�ǼǺ�',field:'DebtorNo',width:120},
			{title:'��������',field:'PatName',width:120},
			{title:'�Ա�',field:'Species',width:60},
			{title:'��������',field:'DOB',width:120},
			{title:'����',field:'Age',width:60},
			{title:'�������',field:'Location',width:120},
			{title:'ҽ��',field:'Doctor',width:80},
			{title:'����ʱ���߿���',field:'oglLoc',width:120},
			{title:'����(��)��',field:'LabEpis',width:120,formatter:function(value,row,ind){
				return value.replace(/--/ig,'||');   //���������滻��������
			}},
			{title:'ҽ������',field:'TestSet',width:200},
			{title:'��������',field:'ordLoc',width:120},
			{title:'����ҽ��',field:'ordDoc',width:80},
			{title:'Σ��ֵ������',field:'repResult',width:300},
			{title:'ҽ������ʱ��',field:'mtsRepTime',width:160}
		].concat(
			GV.ReceiveMode>0?[{title:'����ʱ��',field:'recDate',width:160,formatter:function(val,row,ind){
					return val+' '+row['recTime'];
				}},
				{title:'������',field:'recUser',width:80}
			]:[]
			, 
			[
				{title:'��ϵ�˵绰',field:'MobPhone',width:120},
				{title:'��ϵ��',field:'ToPerson',width:120},
				{title:'������',field:'TransMemo',width:120},
				{title:'ҽ���벡��',field:'TransOrdAndEMR',width:120,formatter:function(val,row,ind){
					var ret=""
					if (row.HasTransOrd=="��" || row.HasTransOrd=="1"){
						ret+='<a href="javascript:void(0);" onclick="openTransOrd(\''+ind+'\')">'+$g('ҽ��')+'</a>';
					}
					if (row.HasTransEMR=="��" || row.HasTransEMR=="1"){
						ret+=(ret==""?'':'&nbsp;&nbsp;')+'<a href="javascript:void(0);" onclick="openTransEmr(\''+ind+'\')">'+$g('����')+'</a>';
					}
					return ret
				}},
				{title:'����ʱ��',field:'TransDate',width:160,formatter:function(val,row,ind){
					return val+' '+row['TransDTime'];
				}},
				{title:'�״δ�����ʱ',field:'transTimeUsedAlias',width:160},
				
				//{title:'����ʱ��',field:'TransDTime',width:120},
				{title:'������',field:'TransUser',width:120},
				{title:'��������',field:'ReportType',hidden:true}
				
			]	
			
		)
			
		
	
	
	
	$('#reportList').datagrid({
		bodyCls:'panel-header-gray',
		url:$URL+"?ClassName=web.DHCAntCVReportSearch&QueryName=GetCVReportNew",
		fit:true,
		border:false,
		idField:'reportID',
		columns:[columns0],
		rowStyler:function(ind,row){
			if (GV.IsForOE=="1" && row.colorflag>0) {
				return 'background-color:#E2FAFA';	
			}
			return '';
		},
		queryParams:{
	        DateFrom: GV.nowDate,
	        DateTo : GV.nowDate, 
	        LocId : GV.OnlyCurrLoc=='1'?GV.LocId:'', 
	        QryType : GV.IsForOE!="1"?"":"OE",
	        TransStatus : '', 
	        ReportType : GV.ReportType>0?GV.ReportType:''
	        ,pAdmLocId:''
	        ,pHospId:GV.HospControl=='ALL'?'':(GV.HospId||'')   //������ֱ�Ӳ�����Ժ��������Ĭ�ϲ鵱ǰ��¼Ժ��
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
			var url="criticalvalue.trans.hisui.csp"+"?ReportId="+row.ReportId+"&RepType="+row.ReportType+'&OnlyView='+(GV.OnlyView||'');
			$('#transWin_iframe').attr('src',url);
		},
		onSelect:function(idx,row){
			if (GV.AllowChangeSysPat=='Y') {
				var frm=dhcsys_getmenuform();
				if (frm) {
					frm.EpisodeID.value=row.Adm;
					frm.PatientID.value=row.PatientID;
					frm.mradm.value=row.mradm;
				}
				
			}
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
		
		var $tb=$('<div id="transOrdExecTable-tb" style="padding:4px 0 4px 10px;line-height:30px;">'+$g('ִ������')+'��<input class="tb-st" /> -- <input class="tb-end" /> <a href="javascript:void(0);" class="tb-search" style="margin-left:10px;" >��ѯ</a></div> ').appendTo('body');;
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
			url:(GV.HasNewOrderExecQuery&&GV.HasNewOrderExecQuery=='1')?'websys.Broker.cls?ClassName=web.DHCDocInPatPortalCommon&QueryName=FindOrderExecDet':'jquery.easyui.querydatatrans.csp?ClassName=web.DHCDocMain&QueryName=FindOrderExecDet',
			queryParams:{orderId:'', execStDate:'', execEndDate:''},
			idField:(GV.HasNewOrderExecQuery&&GV.HasNewOrderExecQuery=='1')?'OrderExecId':'HIDDEN' ,
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
				//console.log(row);
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
					return '<a href="javascript:void(0);" onclick="openEMRView(\''+value+'\');">'+$g('�鿴')+'</a>'
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
/// ��Σ��ֵҽ���ջ�
function openOrderView(ind){
	var row=$('#reportList').datagrid('getRows')[ind];
	var url='dhc.orderview.csp?ordViewBizId='+row.reportID+'&ordViewType=CV'
	GV.util.easyModal('Σ��ֵ�ջ�',url,1400,600);
}

$(function(){
	if (typeof window.$g=='undefined') {
		window.$g=function(a){return a;}	
	}
	init();
	initSearch();	
});