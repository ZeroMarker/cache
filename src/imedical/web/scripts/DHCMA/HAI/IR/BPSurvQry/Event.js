function InitBPSurvWinEvent(obj){

	CheckSpecificKey();
	var CheckFlg = 0; 
	if(tDHCMedMenuOper['Admin']==1) {
		CheckFlg = 1; //���Ȩ��
	}
	obj.LoadEvent = function(args){
		//��ѯ��ť
		$("#btnQuery").on('click',function(){
			obj.reloadgridBPReg();
		});
		$("#btnExport").on('click',function(){
			obj.btnExport_click();
		});
		//��˽��
		$('#btnChkReps').on('click', function(){
			obj.btnCheckRep_onClick();
		});
		//ȡ����˽��
		$('#btnUnChkReps').on('click', function(){
			obj.btnUnCheckRep_onClick();
		});
	}
	$("#txtPatName").keydown(function(event){
		if (event.keyCode ==13) obj.reloadgridBPReg();	
	});	
	//��˽��
	obj.btnCheckRep_onClick = function(){
		var rows = $("#gridBPRegList").datagrid('getRows').length;
		if (rows>0) {
			var chkRows=$HUI.datagrid('#gridBPRegList').getChecked();
			if (chkRows.length>0) {
				 $.messager.confirm("ȷ��", "�Ƿ�������˱���?", function (r) {
					if (r) {
						var reportIds = '';
						for (var row = 0; row < chkRows.length; row++){
							var rd = chkRows[row];
							if (!rd) continue;
							var repId = rd['BPSurvID'];
							if (reportIds != ''){
								reportIds += ',' + repId;
							} else {
								reportIds = repId;
							}
						}
						
						var flg = $m({
							ClassName   : "DHCHAI.IRS.BPSurverySrv",
							MethodName  : "SaveBPRepStatus",
							aReportIDs  : reportIds,
							aStatusCode : 3
						},false);
						if (parseInt(flg) < 1) {
							$.messager.alert("������ʾ","������˱����������!Error=" + flg, 'info');
						} else {
							$.messager.popover({msg: '������˱�������ɹ���',type:'success',timeout: 1000});
							obj.reloadgridBPReg();  //ˢ��
						}
					}
				});
			} else {
				$.messager.alert("������ʾ", "��ѡ�м�¼,���ɲ���!",'info');
				return;
			}
		}else {
			$.messager.alert("������ʾ", "�޼�¼,���ɲ���!", 'info');
			return;
		}
	}
	//ȡ����˽��
	obj.btnUnCheckRep_onClick = function(){
		var rows = $("#gridBPRegList").datagrid('getRows').length;
		if (rows>0) {
			var chkRows=$HUI.datagrid('#gridBPRegList').getChecked();
			if (chkRows.length>0) {
				 $.messager.confirm("ȷ��", "�Ƿ�����ȡ����˱���?", function (r) {
					if (r) {
						var reportIds = '';
						for (var row = 0; row < chkRows.length; row++){
							var rd = chkRows[row];
							if (!rd) continue;
							var repId = rd['BPSurvID'];
							if (reportIds != ''){
								reportIds += ',' + repId;
							} else {
								reportIds = repId;
							}
						}
						
						var flg = $m({
							ClassName   : "DHCHAI.IRS.BPSurverySrv",
							MethodName  : "SaveBPRepStatus",
							aReportIDs  : reportIds,
							aStatusCode : 6
						},false);
						if (parseInt(flg) < 1) {
							$.messager.alert("������ʾ","����ȡ����˱����������!Error=" + flg, 'info');
						} else {
							$.messager.popover({msg: '����ȡ����˱�������ɹ���',type:'success',timeout: 1000});
							obj.reloadgridBPReg();  //ˢ��
						}
					}
				});
			} else {
				$.messager.alert("������ʾ", "��ѡ�м�¼,���ɲ���!",'info');
				return;
			}
		}else {
			$.messager.alert("������ʾ", "�޼�¼,���ɲ���!", 'info');
			return;
		}
	}
	//������
	obj.OpenReport = function(SurvNumber,ReportID,Index,RepStatus,BPRegID) {
		var strUrl = '../csp/dhcma.hai.ir.bpsurvreport.csp?SurvNumber='+$("#cboSurvNumber").combobox("getValue")+'&ReportID='+ReportID+'&BPRegID='+BPRegID+'&AdminPower='+CheckFlg+'&RepStatus='+RepStatus+'&inputParams='+obj.Params+'&ComTempTypeCode='+'BP-REP'+'&1=1';
		websys_showModal({
			url:strUrl,
			title:'Ѫ͸��������:'+$("#cboSurvNumber").combobox("getText"),
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:true,
			width:1420,
			height:'95%',  //8.2���ϰ汾֧�ְٷֱȣ�8.2���µ��þ������أ���height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.reloadgridBPReg();
			} 
		});
	}
	setTimeout(function(){obj.reloadgridBPReg();},1000);
	//���¼��ر������
	obj.reloadgridBPReg = function(){
		var HospIDs 	= $("#cboHospital").combobox('getValue');
		var BDLocation  = $("#cboBDLocation").combobox('getValues').join(',');;
		var SEID	 	= $("#cboSurvNumber").combobox('getValue');
		var PatName 	= $("#txtPatName").val();
		var PapmiNo 	= "";  
		var MrNo 		= "";
		//����״̬
		var Status=Common_CheckboxValue('chkStatunit');
		var Inputs = HospIDs+'^'+BDLocation+'^'+""+"^"+SEID+'^'+PatName+'^'+PapmiNo+'^'+MrNo+"^"+Status;
		
		var ErrorStr="";
		if (HospIDs=="") {
			ErrorStr += '��ѡ��Ժ��!<br/>';
		}
		if (SEID==""){
			ErrorStr += '��ѡ������ţ�<br/>';
		}
		if (ErrorStr != '') {
			$.messager.alert("������ʾ",ErrorStr, 'info');
			return;
		}else{
			obj.Params = HospIDs+'^'+BDLocation+'^'+""+"^"+SEID+'^'+""+'^'+""+'^'+""+"^";
			$("#gridBPRegList").datagrid("loading");
			$cm ({
				ClassName:"DHCHAI.IRS.BPSurverySrv",
				QueryName:"QryBPPatList",
				ResultSetType:"array",
				aIntputs:Inputs,
				page:1,
				rows:1000
			},function(rs){
				$('#gridBPRegList').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
			});
		
		};
	}
	obj.btnExport_click = function() {
		var rows=$("#gridBPRegList").datagrid('getRows').length;
		if (rows>0) {
			var length = $("#gridBPRegList").datagrid('getChecked').length;
			if (length>0) {
				$('#gridBPRegList').datagrid('toExcel', {
				    filename: 'Ѫ͸���������б�.xls',
				    rows: $("#gridBPRegList").datagrid('getChecked'),
				    worksheet: 'Worksheet',
				});
			} else {
				$('#gridBPRegList').datagrid('toExcel','Ѫ͸���������б�.xls');
			} 
		}else {
			$.messager.alert("ȷ��", "�����ݼ�¼,��������", 'info');
			return;
		}	
	}
}