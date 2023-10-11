function InitCtlMonitorWinEvent(obj){
	
	obj.LoadEvent = function(args){
		//��ѯ��ť
		$("#btnQuery").on('click',function(){
			obj.reloadgridApply();
		});
		// ��ذ�ť
		$("#btnTask").on('click',function(){
			obj.MonlitTsak();
		});
		$("#btnExport").on('click',function(){
			obj.btnExport_click();
		});	
		//�Ǽǰ�ť
		$("#btnOutLabReg").on('click',function(){
			obj.OpenOutLabReg();
		});
	}
	//�򿪵Ǽ�����
	obj.OpenOutLabReg = function() {
		var strUrl = '../csp/dhcma.hai.ir.outlabreg.csp';
		websys_showModal({
			url:strUrl,
			title:'�ⲿ�������Ǽ�',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:true,
			width:1344,
			height:700,  //8.2���ϰ汾֧�ְٷֱȣ�8.2���µ��þ������أ���height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.reloadgridApply();  //ˢ��
			} 
		});
	}
	// ���
	obj.MonlitTsak = function(EpisodeID) {
		var CurrDate = Common_GetDate(new Date());
		$.messager.confirm("���","ȷ��ִ�м������",function(r){
			if (r){
				$('#p').progressbar({value:0});
				var flg = $m({
					ClassName:"DHCHAI.Task.TaskManager",
					MethodName:"CheckBactTask",
					aDateFrom:CurrDate,
					aDateTo:CurrDate
				},false)
				if (flg.indexOf('OK') > -1) {
					//ִ�����
					setTimeout(function() {
						$('#p').progressbar({value:100});
						$.messager.popover({msg: '���ִ����ɣ�',type:'success',timeout: 2000});
						setTimeout(function() {$('#p').hide();},2000);
						obj.reloadDetail();
					},1000);
				} else{
					$.messager.alert("��ʾ","����������������ִ�У�",'info');
				}
			}
		})
	}
	
	//������
	obj.OpenMainView = function(EpisodeID) {
		var strUrl = './dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&PageType=WinOpen';
		
		var Page=DHCCPM_Open(strUrl);
	}
	
	
	//���Ӳ���
	obj.OpenEmrRecord = function(EpisodeID,PatientID) {		
		var strUrl = cspUrl+'&PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&DefaultOrderPriorType=ALL&2=2';		
		
		var Page=DHCCPM_Open(strUrl);
	};
	
	obj.openDetail = function(EpisodeID) {
		$('#gridBactDetail').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
		obj.reloadDetail(EpisodeID);
		$HUI.dialog('#winProEdit').open();	    
	}
	
	obj.reloadDetail= function(EpisodeID){
		var DateType = $("#cboDateType").combobox('getValue');
		var DateFrom = $("#dtDateFrom").datebox('getValue');
		var DateTo	 = $("#dtDateTo").datebox('getValue');
		$("#gridBactDetail").datagrid("loading");
		$cm ({
			ClassName:"DHCHAI.IRS.CtlMRBSrv",
			QueryName:"QryBactDetail",
			ResultSetType:"array",
			aEpisodeID:EpisodeID,
			aDateType:DateType,
			aDateFrom:DateFrom,
			aDateTo:DateTo,
			page:1,
			rows:200
		},function(rs){
			$('#gridBactDetail').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
	}
	//���¼��ر������
	obj.reloadgridApply = function(){
		var HospIDs  = $("#cboHospital").combobox('getValue');
		var DateType = $("#cboDateType").combobox('getValue');
		var DateFrom = $("#dtDateFrom").datebox('getValue');
		var DateTo	 = $("#dtDateTo").datebox('getValue');
		var Location = $("#cboLocation").combobox('getValue');
		var Bacteria = $("#cboBacteria").combobox('getValue');
		var MRBBact  = $("#cboMRBBact").combobox('getValue');
		var InfType  = $("#cboInfType").combobox('getValue');
		var WardID   = $("#cboWard").combobox('getValue');
		var DateFlag=Common_CompareDate(DateFrom,DateTo);
		var RepType  =$("#cboMRBOutLabType").combobox('getValue');
		var ErrorStr="";
		if (HospIDs=="") {
			ErrorStr += '��ѡ��Ժ��!<br/>';
		}
		if(DateType==""){
			$.messager.alert("��ʾ","�������Ͳ���Ϊ�գ�", 'info');
			return;
		}
		if(DateFrom==""){
			$.messager.alert("��ʾ","��ʼ���ڲ���Ϊ�գ�", 'info');
			return;
		}
		if(DateTo==""){
			$.messager.alert("��ʾ","�������ڲ���Ϊ�գ�", 'info');
			return;
		}
		if (DateFlag==1){
			$.messager.alert("��ʾ","��ʼ���ڲ��ܴ��ڽ������ڣ�", 'info');
			return;
		}
		
		if (ErrorStr != '') {
			$.messager.alert("������ʾ",ErrorStr, 'info');
			return;
		}else{
			$("#gridCtlResult").datagrid("loading");
			$cm ({
				ClassName:"DHCHAI.IRS.CtlMRBSrv",
				QueryName:"QryMRBMonitor",
				ResultSetType:"array",
				aHospIDs:HospIDs,
				aDateType:DateType,
				aDateFrom:DateFrom,
				aDateTo:DateTo,
				aLocID:Location,
				aInfID:InfType,
				aBactID:Bacteria,
				aMRBID:MRBBact,
				aSpecID:"",
				aWardID:WardID,
				aRepTypeID:RepType,
				page:1,
				rows:999999
			},function(rs){
				$('#gridCtlResult').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
			});
		
		};
	}
	obj.btnExport_click = function() {
		var rows=$("#gridCtlResult").datagrid('getRows').length;
		if (rows>0) {
			/*var length = $("#gridCtlResult").datagrid('getChecked').length;
			if (length>0) {
				$('#gridCtlResult').datagrid('toExcel', {
				    filename: '������ҩ�����.xls',
				    rows: $("#gridCtlResult").datagrid('getChecked'),
				    worksheet: 'Worksheet',
				});
			} else {
				$('#gridCtlResult').datagrid('toExcel','������ҩ�����.xls');
			} */
			$('#gridCtlResult').datagrid('toExcel','������ҩ�����.xls');
		}else {
			$.messager.alert("ȷ��", "�����ݼ�¼,��������", 'info');
			return;
		}	
	}
	setTimeout(function(){obj.reloadgridApply()},1000);
}
