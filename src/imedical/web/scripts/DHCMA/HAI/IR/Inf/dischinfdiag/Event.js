function InitDischDiagWinEvent(obj){
	obj.LoadEvent = function(args){ 
		$("#btnQuery").on('click',function(){
			obj.reloadgridDischDiag();
		});
		$("#btnExport").on('click',function(){
			obj.btnExport_click();
		});
	}
	//��ѯ
	obj.reloadgridDischDiag = function(){
		var ErrorStr="";
		var DateFrom 	= $("#DateFrom").datebox('getValue');
		var DateTo 		= $("#DateTo").datebox('getValue');
		if ((DateFrom == '')||(DateTo=='')) {
			ErrorStr += '��Ժ���ڲ�����Ϊ��!<br/>';
		}
		if ((Common_CompareDate(DateFrom,DateTo))) {
			ErrorStr += '��ʼ���ڲ��ܴ��ڽ�������!<br/>';
		}if (ErrorStr != '') {
			$.messager.alert("������ʾ",ErrorStr, 'info');
			return;
		}
		$('#gridDischDiag').datagrid('load',{
			ClassName:'DHCHAI.IRS.INFDiagnosSrv',
	        QueryName:'QryDischInfDiag',
	        aHospIDs:$("#cboHospital").combobox('getValue'),
	        aDateFrom:$("#DateFrom").datebox('getValue'),
	        aDateTo:$("#DateTo").datebox('getValue'),
	        aAdmLoc:$("#cboLocation").combobox('getValue'),
	        aStatus:$("#cboStatus").combobox('getValue'),
	        aMrNo:$("#txtMrNO").val(), 
			});
			$('#gridDischDiag').datagrid('unselectAll');
	};
	//ժҪ
	obj.btnAbstractMsg_Click = function(EpisodeID)
	{	
	    var strUrl = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&PageType=WinOpen';
	    
	    var Page=DHCCPM_Open(strUrl);
	};
	//���Ӳ���
	obj.btnEmrRecord_Click = function(EpisodeID){		
		var rst = $m({
			ClassName:"DHCHAI.DPS.PAAdmSrv",
			MethodName:"GetPaAdmHISx",
			aEpisodeID:EpisodeID
		},false);
		if(rst=="")return;
		var EpisodeID = rst.split("^")[0];
		var PatientID = rst.split("^")[1];
		var strUrl = cspUrl+'&PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&DefaultOrderPriorType=ALL&2=2';		
		
		var Page=DHCCPM_Open(strUrl);
	};
	//��������
	obj.btnAddQuest_Click = function(EpisodeID)
	{		
		var t=new Date();
		t=t.getTime();
		var strUrl = "./dhcma.hai.ir.feedback.csp?EpisodeID=" + EpisodeID+"&TypeCode=3";
		websys_showModal({
			url:strUrl,
			title:'��������',
			iconCls:'icon-w-paper',  
			width:800,
			height:600,
			onBeforeClose:function(){}  //���޴ʾ�,IE�´�һ�ݱ���رպ�ժҪ�޷��ر�
		});
	};
	
	obj.btnReprot_Click=function(EpisodeID) {
		if (!EpisodeID) return;
		var url = '../csp/dhcma.hai.ir.inf.report.csp?EpisodeID='+EpisodeID+'&1=1';
		websys_showModal({
			url:url,
			title:'ҽԺ��Ⱦ����',
			iconCls:'icon-w-epr',
			closable:false,
			width:1320,
			height:'95%',
			onBeforeClose:function(){
				obj.reloadgridDischDiag();
			}
		});
	}

	//ȷ��
	obj.qz = function(EpisodeID,index)
	{	
		var InputStr  = EpisodeID;
		InputStr += "^" + "1";             // ����״̬ ȷ��
		InputStr += "^" + "";              // �������
		InputStr += "^" + $.LOGON.USERID;  // ������
	    var rst = $m({
			ClassName:"DHCHAI.IRS.CCDiagnosSrv",
			MethodName:"SaveCCDiagnos",
			aInputInfo:InputStr,
			separete:"^"
		},false);
		if (parseInt(rst) <= 0) {
				$.messager.alert("������ʾ", "ȷ��ʧ��" , 'info');		
		}else {
			var rowData = $("#gridDischDiag").datagrid('getChecked');
			$.messager.popover({msg: 'ȷ��ɹ�',type:'success',timeout: 1000});
			//$("#gridDischDiag").datagrid('reload')
			//obj.gridDischDiag.reload() ;//ˢ�µ�ǰҳ
			//��������ˢ��
			$('#gridDischDiag').datagrid('updateRow', {
			    index: index,
			    row: {
			        "ActStatus": 'ȷ��'
			    }
			});
		}
	};
	// ����
	obj.ys = function(EpisodeID,index)
	{	
		var InputStr  = EpisodeID;
		InputStr += "^" + "2";             // ����״̬ ȷ��
		InputStr += "^" + "";              // �������
		InputStr += "^" + $.LOGON.USERID;  // ������
	    var rst = $m({
			ClassName:"DHCHAI.IRS.CCDiagnosSrv",
			MethodName:"SaveCCDiagnos",
			aInputInfo:InputStr,
			separete:"^"
		},false);
		if (parseInt(rst) <= 0) {
				$.messager.alert("������ʾ", "����ʧ��" , 'info');		
			}else {
				$.messager.popover({msg: '���Ƴɹ�',type:'success',timeout: 1000});
				//obj.gridDischDiag.reload() ;//ˢ�µ�ǰҳ
				//$("#gridDischDiag").datagrid('reload')
				//��������ˢ��
				$('#gridDischDiag').datagrid('updateRow', {
				    index: index,
				    row: {
				        "ActStatus": '����'
				    }
				});
			}
	};
	// �ų�
	obj.pc = function(EpisodeID,index)
	{	
		var InputStr  = EpisodeID;
		InputStr += "^" + "3";             // ����״̬ �ų�
		InputStr += "^" + "";              // �������
		InputStr += "^" + $.LOGON.USERID;  // ������
	    var rst = $m({
			ClassName:"DHCHAI.IRS.CCDiagnosSrv",
			MethodName:"SaveCCDiagnos",
			aInputInfo:InputStr,
			separete:"^"
		},false);
		if (parseInt(rst) <= 0) {
			$.messager.alert("������ʾ", "�ų�ʧ��" , 'info');		
		}else {
			$.messager.popover({msg: '�ų��ɹ�',type:'success',timeout: 1000});
			//obj.gridDischDiag.reload() ;//ˢ�µ�ǰҳ
			//$("#gridDischDiag").datagrid('reload')
			//��������ˢ��
			$('#gridDischDiag').datagrid('updateRow', {
			    index: index,
			    row: {
			        "ActStatus": '�ų�'
			    }
			});
		}
	};
	
	//����
	obj.btnExport_click = function() {
		var rows=$("#gridDischDiag").datagrid('getRows').length;
		
		if (rows>0) {
			$('#gridDischDiag').datagrid('toExcel','��Ժ��Ⱦ��ϲ�ѯ.xls');
		}else {
			$.messager.alert("ȷ��", "�����ݼ�¼,��������", 'info');
			return;
		}	
	}
}