//ҳ��Gui
var objScreen = new Object();
function InitAntCheckWin(){
	var obj = objScreen;
	var LogonHospID = $.LOGON.HOSPID;
	
	//ҽԺ ����
	obj.cboHospital=Common_ComboToSSHosp("cboHospital",LogonHospID);
	$HUI.combobox('#cboHospital',{
	    onSelect:function(rows){
		    var HospID=rows["ID"];
			obj.cboRepLoc=Common_ComboToLoc("cboLoc",HospID,"","","");//E|W
	    }
    });
	
	// ���ڳ�ʼ��ֵ
	obj.dtDateFrom	= $('#dtDateFrom').datebox('setValue', Common_GetDate(new Date()));
	obj.DateTo 		= $('#dtDateTo').datebox('setValue', Common_GetDate(new Date()));
	//������ҩ
	obj.cboAntiMast = Common_ComboDicID("cboAntiMast","ANTAntibiotic");
	
	obj.gridAntCheck = $HUI.datagrid("#AntCheck",{
		fit: true,
		title:'���ҿ�����ҩ��������б�',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,	
		fitColumns: true,		
		loadMsg:'���ݼ�����...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'ReportId',title:'�����',width:50,align:'left'},
			{field:'PatNo',title:'�ǼǺ�',width:120,align:'center'},
			{field:'PatName',title:'����',width:80,align:'left'},
			{field:'PAMrNo',title:'������',width:100,align:'left'},
			{field:'PatSex',title:'�Ա�',width:50,align:'center'},
			{field:'PatAge',title:'����',width:80,align:'center'},
			{field:'AdmLocDesc',title:'�������',width:100,align:'center'},
			{field:'AdmWardDesc',title:'���ﲡ��',width:180,align:'center'},
			{field:'AdmBed',title:'��λ',width:80,align:'center'},
			{field:'AdmDate',title:'��Ժ����',width:100,align:'center'},
			{field:'DischDate',title:'��Ժ����',width:100,align:'center'},
			{field:'AntiDurg',title:'�ϱ���ҩ����',width:100},
			{field:'StatusDesc',title:'����״̬',width:80},
			{field:'RepLocDesc',title:'�������',width:100},
			{field:'RepDate',title:'�ϱ�����',width:150,align:'center'},
			{field:'RepUser',title:'�ϱ���',width:80,align:'center'}
				
		]],
		//�����¼�		
		onClickRow:function (rowIndex, rowData){
			if (rowIndex>-1){
				var aReportID=rowData.ReportId;
				var aEpisodeID=rowData.PatNo;
				var aOrdItemID=rowData.OrdItemID;
				obj.openHandler(aEpisodeID,aReportID,aOrdItemID);
			}
		}
	});
	obj.gridMajor = $HUI.datagrid("#Major",{
		fit: true,
		title:'',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,	
		fitColumns: true,		
		loadMsg:'���ݼ�����...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'HospitalDesc',title:'ҽԺ�û���',width:50,align:'left'},
			{field:'PAMrNo',title:'���߲�����',width:120,align:'center'},
			{field:'ARMonthTime',title:'��ҩ����',width:80,align:'left'},
			{field:'ARAge',title:'����',width:50,align:'center'},
			{field:'ARBabyMonth',title:'Ӥ�׶�����',width:80,align:'center'},
			{field:'ARBabyDay',title:'Ӥ����������',width:100,align:'center'},
			{field:'OrdLocDesc',title:'����',width:180,align:'center'},
			{field:'SexDesc',title:'�Ա�',width:80,align:'center'},
			{field:'Diagnos',title:'��Ժ��һ���',width:100,align:'center'},
			{field:'APACHEII',title:'APACHE��',width:100,align:'center'},
			{field:'InfPosCode',title:'��Ⱦ��λ',width:100},
			{field:'IndicationCode',title:'��Ӧ֢',width:80},
			{field:'SttDate',title:'��ҩ����',width:150,align:'center'},
			{field:'EndDate',title:'ͣҩ����',width:80},
			{field:'UseDrugResCode',title:'��ҩЧ��',width:150,align:'center'},
			{field:'AntiDurgCode',title:'��ҩ����',width:80},
			{field:'IsEtiologyEvi',title:'��ԭѧ֤��',width:150,align:'center'},
			{field:'UnReactionCode',title:'ʹ��̼��ùϩ/��ӻ����࿹��ҩ���Ĳ�����Ӧ',width:80},
			{field:'QuePowerCode',title:'����Ȩ��',width:150,align:'center'},
			{field:'Freq',title:'�÷�(��/��)',width:80},
			{field:'DoseQty',title:'����(0~10g)',width:150,align:'center'},
			{field:'AdjustPlanCode',title:'��������',width:80},
			{field:'AdjustPlanTxt',title:'��������ѡ������',width:150,align:'center'},
			{field:'IsInfection',title:'�Ƿ�Ժ��',width:80},
			{field:'RepDate',title:'����¼��ʱ��',width:150,align:'center'},
			{field:'ARAdmDate',title:'��Ժ����',width:80}
		]],
	});
	obj.gridMinor = $HUI.datagrid("#Minor",{
		fit: true,
		title:'',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: true,	
		fitColumns: true,		
		loadMsg:'���ݼ�����...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'PAMrNo',title:'������',width:50,align:'left'},
			{field:'SttDate',title:'��ҩ����',width:120,align:'center'},
			{field:'EndDate',title:'ͣҩ����',width:80,align:'left'},
			{field:'CollDate',title:'�ͼ�����',width:50,align:'center'},
			{field:'AuthDate',title:'��������',width:80,align:'center'},
			{field:'SpecimenDesc',title:'�걾����',width:100,align:'center'},
			{field:'ResultCode',title:'���',width:180,align:'center'},
			{field:'BacteriaDesc',title:'ϸ������',width:80,align:'center'},
			{field:'IsResistQ',title:'�Ƿ���̼��ùϩ',width:100,align:'center'},
			{field:'QAntiDesc',title:'ҩ������',width:100,align:'center'},
			{field:'QMethodDesc',title:'ҩ������',width:100},
			{field:'QNumber',title:'ҩ����ֵ',width:80},
			{field:'IsResistT',title:'�Ƿ�����ӻ���',width:150,align:'center'},
			{field:'TAntiDesc',title:'ҩ������',width:80,align:'center'},
			{field:'TMethodDesc',title:'ҩ������',width:150,align:'center'},
			{field:'TNumber',title:'ҩ����ֵ',width:80,align:'center'}		
		]],
	});
	//״̬
	$HUI.combobox("#cboQryStatus", {
		editable:true,
		defaultFilter:4,
		valueField: 'ID',
		textField: 'DicDesc',
		onShowPanel:function(){
			var url=$URL+"?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=array&aTypeCode=ANTStatus&aActive=1";
			$("#cboQryStatus").combobox('reload',url);	
		}
	});
	
	InitAntCheckWinEvent(obj);
	obj.LoadEvent(arguments);

	return obj;
}
