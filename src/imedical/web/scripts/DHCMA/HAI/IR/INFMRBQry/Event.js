function InitMBRRepWinEvent(obj){
	obj.LoadEvent = function(args){
		//��ѯ��ť
		$("#btnQuery").on('click',function(){
			obj.reloadgridApply();
		});
		$("#btnExport").on('click',function(){
			obj.btnExport_click();
		});		
	}
	
	obj.OpenReslut = function(ResultID) {
		$('#gridIRDrugSen').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
		obj.reloadgridIRDrugSen(ResultID);
		$HUI.dialog('#winProEdit').open();	    
	}
	obj.OpenMBRRepLog = function(RepID) {
		$('#gridMBRRepLog').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
		obj.reloadgridMBRRepLog(RepID);
		$HUI.dialog('#LayerMBRRepLog').open();	    
	}
	
	//������
	obj.OpenReport = function(ReportID,EpisodeID,LabRepID) {
		var ParamAdmin= (tDHCMedMenuOper['Admin']==1 ?"Admin" : "")
		var strUrl = './dhcma.hai.ir.mrb.ctlreport.csp?&ReportID='+ReportID+'&EpisodeID='+EpisodeID+'&LabRepID='+LabRepID+'&ParamAdmin='+ParamAdmin+'&1=1';
		websys_showModal({
			url:strUrl,
			title:'����ϸ������',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:true,
			width:1340,
			height:700,  //8.2���ϰ汾֧�ְٷֱȣ�8.2���µ��þ������أ���height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.reloadgridApply();  //ˢ��
			} 
		});
	}
	
	//�ǼǺŲ��� lengthλ��
	var length=10;
	obj.PapmiNo=""
	$("#txtPapmiNo").keydown(function(event){
		 if (event.keyCode ==13) {
			obj.PapmiNo = $("#txtPapmiNo").val();
			if(!obj.PapmiNo) return;
			$("#txtPapmiNo").val((Array(length).join('0') + obj.PapmiNo).slice(-length)); 
			obj.reloadgridApply();
		}
	});	
	//���¼��ر������
	obj.reloadgridApply = function(){
		var HospIDs  = $("#cboHospital").combobox('getValue');
		var DateFrom = $("#dtDateFrom").datebox('getValue');
		var DateTo	 = $("#dtDateTo").datebox('getValue');
		var Location = $("#cboLocation").combobox('getValue');
		var Bacteria = $("#cboBacteria").combobox('getValue');
		var MRBBact  = $("#cboMRBBact").combobox('getValue');
		var InfType  = $("#cboInfType").combobox('getValue');
		var PatName  = $("#txtPatName").val();
		var PapmiNo  = $("#txtPapmiNo").val();
		var MrNo 	 = $("#txtMrNo").val();
		var Inputs = PatName+'^'+PapmiNo+'^'+MrNo;
		var DateFlag=Common_CompareDate(DateFrom,DateTo);
		var Status   =$("#cboStatus").combobox('getValue');
		var ErrorStr="";
		if (HospIDs=="") {
			ErrorStr += '��ѡ��Ժ��!<br/>';
		}
		if(DateFrom==""){
			$.messager.alert("��ʾ","�ͼ����ڲ���Ϊ�գ�", 'info');
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
		
			$("#gridMBRRep").datagrid("loading");
			$cm ({
				ClassName:"DHCHAI.IRS.INFMBRSrv",
				QueryName:"QryINFMBRSrv",
				ResultSetType:"array",
				aHospIDs:HospIDs,
				aDateFrom:DateFrom,
				aDateTo:DateTo,
				aLocID:Location,
				aInfID:InfType,
				aBactID:Bacteria,
				aMRBID:MRBBact,
				aIntputs:Inputs,
				aStatus:Status,
				page:1,
				rows:999999
			},function(rs){
				$('#gridMBRRep').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
				$('#gridMBRRep').datagrid('selectRow', obj.rowIndex );				
			});
		
		};
	}
	obj.btnExport_click = function() {
		var rows=$("#gridMBRRep").datagrid('getRows').length;
		if (rows>0) {
			var length = $("#gridMBRRep").datagrid('getChecked').length;
			if (length>0) {
				$('#gridMBRRep').datagrid('toExcel', {
				    filename: '������ҩ������.xls',
				    rows: $("#gridMBRRep").datagrid('getChecked'),
				    worksheet: 'Worksheet',
				});
			} else {
				$('#gridMBRRep').datagrid('toExcel','������ҩ������.xls');
			} 
		}else {
			$.messager.alert("ȷ��", "�����ݼ�¼,��������", 'info');
			return;
		}	
	}
	
	//���¼��ر������
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

	//ˢ�²�����ϸ
    obj.reloadgridMBRRepLog = function (RepID){
		$("#gridMBRRepLog").datagrid("loading");
		$cm ({
			ClassName:"DHCHAI.IRS.INFMBRSrv",
			QueryName:"QryMBRRepLog",
			ResultSetType:"array",
			aRepID:RepID,
			page:1,
			rows:200
		},function(rs){
			$('#gridMBRRepLog').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
    }	
}
