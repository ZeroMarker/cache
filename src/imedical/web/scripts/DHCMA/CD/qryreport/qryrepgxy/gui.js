//ҳ��Gui
var objScreen = new Object();
function InitViewport(){
	var obj = objScreen;		  	
    
    $.parser.parse(); // ��������ҳ��  
    
    //��ʼ��ѯ����
    obj.cboHospital = Common_ComboToSSHosp("cboHospital",SSHospCode,"CD");
	//ҽԺ��������
	$HUI.combobox('#cboHospital',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    obj.cboRepLoc = Common_ComboToLoc("cboRepLoc","E","","",HospID);
	    }
    });
	var nowDate = new Date();
	nowDate.setMonth(nowDate.getMonth()-1);
	obj.txtFromDate = $('#txtFromDate').datebox('setValue', Common_GetDate(nowDate));// ���ڳ�ʼ��ֵ
    obj.txtToDate = $('#txtToDate').datebox('setValue', Common_GetDate(new Date()));
  	
	//����״̬
	obj.chkStatusList = Common_CheckboxToDic("chkStatusList","CRReportStatus",5);
	var DicInfo = $m({                   
		ClassName:"DHCMed.SSService.DictionarySrv",
		MethodName:"GetDicByDesc",
		argType:"CRReportStatus",
		argDesc:"�ϱ�",
		argIsActive:"1"
	},false);
	$('#chkStatusList'+DicInfo.split("^")[0]).checkbox('setValue', (DicInfo.split("^")[0]!="" ? true:false));  
	
	obj.gridRepInfo = $HUI.datagrid("#gridRepInfo",{
		fit: true,
		title:'��Ѫѹ�����ѯ',
		headerCls:'panel-header-gray',
		iconCls:'icon-apply-check',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: false,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
			{title:'����',width:45,field:'expander',align:'center',
				formatter: function(value,row,index){
					var ReportID = row["ReportID"];
					var EpisodeID = row["EpisodeID"];
					if ((typeof HISUIStyleCode != 'undefined') && (HISUIStyleCode=="lite")){
						var btn = '<a href="#" class="icon icon-paper" onclick="objScreen.OpenReport(\'' + ReportID + '\',\'' + EpisodeID + '\')"></a>';
					}else{
						var btn = '<a href="#" class="btn_detail" onclick="objScreen.OpenReport(\'' + ReportID + '\',\'' + EpisodeID + '\')"></a>';
					}
					return btn;
				}
			}, 
			{title: '����״̬', width: 120, field: 'expander1',
				formatter: function(value,row,index){
					return  row["RepStatusDesc"];
				}
			}, 
			{title: '��Ƭ���', width: 100, field: 'expander2',
				formatter: function(value,row,index){
					return  row["KPBH"];
				}
			},        
			{title: '�ǼǺ�', width: 100, field: 'expander3',
				formatter: function(value,row,index){
					return  row["PapmiNo"];
				}
			},       
			{title: '��������', width: 120, field: 'PatName'},      
			{title: '�Ա�', width: 50, field: 'PatSex'},      
			{title: '��������', width: 160, field: 'Birthday'}, 
			{title: '���֤������', width: 160, field: 'CaraType'}, 
			{title: '���֤������', width: 220, field: 'CaraNo'}, 
			{title: '����', width: 160, field: 'Nation'}, 
			{title: '����', width: 120, field: 'Country',hidden:true,exportHidden:false}, 
			{title: 'ѧ��', width: 160, field: 'Education',hidden:true,exportHidden:false}, 
			{title: '����״��', width: 160, field: 'Marriage',hidden:true,exportHidden:false}, 
			{title: 'ְҵ����', width: 160, field: 'Occupation',hidden:true,exportHidden:false}, 
			{title: '������λ', width: 160, field: 'Company',hidden:true,exportHidden:false}, 
			{title: '��ϵ��', width: 160, field: 'RelateMan',hidden:true,exportHidden:false}, 
			{title: '��ϵ��/�໤���뱾�˹�ϵ', width: 160, field: 'Relationship',hidden:true,exportHidden:false}, 
			{title: '��ϵ�绰(�ֻ�)', width: 160, field: 'RelationTelOne',hidden:true,exportHidden:false}, 
			{title: '��ϵ�绰(����)', width: 160, field: 'RelationTelTwo',hidden:true,exportHidden:false}, 
			{title: '��סַ(����)', width: 160, field: 'CurrAddType',hidden:true,exportHidden:false}, 
			{title: '��סַ(����)', width: 160, field: 'CurrAddCode',hidden:true,exportHidden:false}, 
			{title: '��ס��ϸ��ַ', width: 160, field: 'CurrAddInfo'}, 
			{title: '��������ס6��������', width: 160, field: 'IsLiveSixInfo',hidden:true,exportHidden:false}, 
			{title: '������ַ(����)', width: 160, field: 'RegAddType',hidden:true,exportHidden:false}, 
			{title: '������ַ(����)', width: 160, field: 'RegAddCode',hidden:true,exportHidden:false}, 
			{title: '������ϸ��ַ', width: 160, field: 'RegAddInfo',hidden:true,exportHidden:false}, 
			{title: '����icd', width: 160, field: 'DiagICD',hidden:true,exportHidden:false}, 
			{title: '�״��������', width: 160, field: 'FirstDiagDate',hidden:true,exportHidden:false}, 
			{title: 'ȷ������', width: 160, field: 'DiagDate',hidden:true,exportHidden:false}, 
			{title: '����ʷ', width: 160, field: 'FamilyHistory'}, 
			{title: '�뻼�߹�ϵ', width: 160, field: 'PatRelationship'},    
			{title: 'סԺ��', width: 120, field: 'MrNo',hidden:true,exportHidden:false},    
			{title: '�����', width: 120, field: 'OPNo',hidden:true,exportHidden:false}, 
			{title: '����ѹ', width: 180, field: 'SSY'},            
			{title: '����ѹ', width: 120, field: 'SZY'},          
			{title: '����ת��', width: 120, field: 'Reversion',hidden:true,exportHidden:false},
			{title: '��������', width: 160, field: 'DeathDate',hidden:true,exportHidden:false}, 
			{title: '����ԭ��', width: 160, field: 'DeathReason',hidden:true,exportHidden:false}, 
			{title: '��������ԭ��', width: 160, field: 'DeathReasonInfo',hidden:true,exportHidden:false}, 
			{title: '�����ϵ�λ', width: 120, field: 'MostUnit',hidden:true,exportHidden:false},
			{title: '֢״', width: 220, field: 'SymptomList',showTip:true},   
			{title: '��ϵ���(����)', width: 120, field: 'DiagPlaceCode',hidden:true,exportHidden:false},
			{title: '��ϻ���(����)', width: 120, field: 'DiagUnitCode',hidden:true,exportHidden:false}, 
			{title: '��������', width: 160, field: 'TreatDate',hidden:true,exportHidden:false},    
			{title: '��ʼ��������', width: 160, field: 'StartTreatDate',hidden:true,exportHidden:false}, 
			{title: '��������', width: 160, field: 'TreatType',hidden:true,exportHidden:false},     
			{title: '������Ӧ��������', width: 160, field: 'ADRsAppearDate',hidden:true,exportHidden:false}, 
			{title: '������Ӧȷ������', width: 160, field: 'ADRsDiagDate',hidden:true,exportHidden:false}, 
			{title: '������Ӧ���', width: 160, field: 'ADRsDiag',hidden:true,exportHidden:false},       
			{title: '������Ӧ����ҩ��', width: 160, field: 'ADRsDrug',hidden:true,exportHidden:false},  
			{title: 'ֹͣ��������', width: 160, field: 'EndTreatDate',hidden:true,exportHidden:false},  
			{title: 'ֹͣ����ԭ��', width: 160, field: 'EndTreatReason',hidden:true,exportHidden:false},  
			{title: 'ԤԼ��Ժ���ʱ��', width: 160, field: 'AppointmentDate',hidden:true,exportHidden:false},  
			{title: 'ʵ����Ժ���ʱ��', width: 160, field: 'ActualDate',hidden:true,exportHidden:false},  
			{title: '���Ƶ���(����)', width: 160, field: 'TreatPlaceCode',hidden:true,exportHidden:false},   
			{title: '���ƻ���(����)', width: 160, field: 'TreatUnitCode',hidden:true,exportHidden:false},   
			{title: '����ҽʦ', width: 160, field: 'ReportUser'}   
		]],
		onDblClickRow:function(index, row) {
			if (index>-1) {
				obj.gridRepInfo_click();
			}
		},onLoadSuccess:function(data){
			//���سɹ�
			dispalyEasyUILoad(); //����Ч��
		}
	});

	InitViewportEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


