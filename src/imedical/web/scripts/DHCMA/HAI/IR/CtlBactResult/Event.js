function InitCtlBactResultWinEvent(obj){
	
	obj.LoadEvent = function(args){
		$('#gridAdm').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
		obj.reloadgridApply();
		//��ѯ��ť
		$("#btnQuery").on('click',function(){
			obj.reloadgridApply();
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
	//��Ⱦ���ͱ��
	obj.MenuEdit = function(index,ResultID,MRBOutLabType,RowID) {
		var e = event || window.event;
		$('#gridApply').datagrid("clearSelections"); //ȡ������ѡ���� 
		$('#gridApply').datagrid("selectRow", index); //��������ѡ�и��� 
		$('#menu').menu({
			onClick:function(item){
			    if (MRBOutLabType=="��ԺЯ��"){
				   var ret = $m({
						ClassName:"DHCHAI.IR.OutLabReport",
						MethodName:"UpdateInfType",
						aID:RowID,
						aMakeInfType:item.id
					},false);
					if (parseInt(ret) <= 0) {
						$.messager.alert("������ʾ", "���ʧ��!Error=" + flg, 'info');
					}else {
						$.messager.popover({msg: '��ǳɹ���',type:'success',timeout: 1000});
						obj.reloadgridApply(); //ˢ�µ�ǰҳ
					}
				}else{
			       	var ret = $m({
						ClassName:"DHCHAI.DP.LabVisitRepResult",
						MethodName:"UpdateInfType",
						aID:ResultID,
						aMakeInfType:item.id,
						aIsByHand:1
					},false);
					if (parseInt(ret) <= 0) {
						$.messager.alert("������ʾ", "���ʧ��!Error=" + flg, 'info');
					}else {
						$.messager.popover({msg: '��ǳɹ���',type:'success',timeout: 1000});
						obj.reloadgridApply(); 
					}
				}
		    }
		});
		$('#menu').menu('show', { 
			left: e.pageX,   //�����������ʾ�˵� 
			top: e.pageY
		});
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
	
	obj.OpenReslut = function(ResultID) {
		$('#gridIRDrugSen').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
		obj.reloadgridIRDrugSen(ResultID);
		$HUI.dialog('#winProEdit').open();	    
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
		var LabSpec  = $("#cboLabSpec").combobox('getValue');
		var WardID   = $("#cboWard").combobox('getValue');
		var InfType  =$("#cboInfType").combobox('getValue');
		var RepType  =$("#cboMRBOutLabType").combobox('getValue');
		var DateFlag=Common_CompareDate(DateFrom,DateTo);
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
				QueryName:"QryBactResult",
				ResultSetType:"array",
				aHospIDs:HospIDs,
				aDateType:DateType,
				aDateFrom:DateFrom,
				aDateTo:DateTo,
				aLocID:Location,
				aInfID:InfType,
				aBactID:Bacteria,
				aMRBID:MRBBact,
				aSpecID:LabSpec,
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
			var length = $("#gridCtlResult").datagrid('getChecked').length;
			if (length>0) {
				$('#gridCtlResult').datagrid('toExcel', {
				    filename: 'ϸ����������ѯ.xls',
				    rows: $("#gridCtlResult").datagrid('getChecked'),
				    worksheet: 'Worksheet',
				});
			} else {
				$('#gridCtlResult').datagrid('toExcel','ϸ����������ѯ.xls');
			} 
		}else {
			$.messager.alert("ȷ��", "�����ݼ�¼,��������", 'info');
			return;
		}	
	}

	//����ҩ�������Ϣ
	obj.reloadgridIRDrugSen = function(ResultID){
		$("#gridIRDrugSen").datagrid("loading");
		$cm ({
			ClassName:"DHCHAI.IRS.CtlMRBSrv",
			QueryName:"QryResultSen",
			ResultSetType:"array",
			aResultID:ResultID,
			page:1,
			rows:200
		},function(rs){
			$('#gridIRDrugSen').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
	}

}
