//ҳ��Gui
var objScreen = new Object();
function InitMBRRepWin(){
	var obj = objScreen;
	var CheckFlg = 0;
	if (tDHCMedMenuOper['Admin']==1) {
		CheckFlg = 1; //���Ȩ��
	}
	//����״̬
	$HUI.combobox("#cboStatus",{
		data:[
			{value:'0',text:$g('δ����')},
			{value:'1',text:$g('����')},
			{value:'2',text:$g('�ύ')},
			{value:'3',text:$g('���')},
			{value:'4',text:$g('ɾ��')},
		],
		allowNull: true,
		valueField:'text',
		textField:'text'
	});
	// ���ڳ�ʼ��ֵ
	var date=new Date()
	date.setDate(1);
	var DateFrom=Common_GetDate(date);	
	obj.dtDateFrom = $('#dtDateFrom').datebox('setValue', DateFrom);    // ���ڳ�ʼ��ֵ
	obj.dtDateTo = $('#dtDateTo').datebox('setValue', Common_GetDate(new Date()));
	//ҽԺ
    $HUI.combobox("#cboHospital",{
		url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospListByLogon&ResultSetType=Array&aLogonHospID='+$.LOGON.HOSPID,
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		onSelect:function(rec){
			if (CheckFlg!=1){  //�ǹ���ԱȨ�޿��Ҳ�����ѡ��
				Common_ComboToLoc('cboLocation',rec.ID,"","I","E");
				$('#cboLocation').combobox('setValue',$.LOGON.LOCID);
				$('#cboLocation').combobox('setText',$.LOGON.LOCDESC);
				$('#cboLocation').combobox('disable');
			}else {
				Common_ComboToLoc('cboLocation',rec.ID,"","I","W");
			}
		},
		onLoadSuccess:function(data){
			// Ժ��Ĭ��ѡ��
			$('#cboHospital').combobox('select',data[0].ID);			
			obj.reloadgridApply(); //��ʼ���в�ѯ
		}
	});

	$HUI.combobox("#cboDateType",{
		data:[
			{value:'1',text:$g('�ͼ�����'),selected:true},
			{value:'2',text:$g('��������')}
		],
		valueField:'value',
		textField:'text'
	})
	
	///���ز�ԭ��
	$HUI.combobox("#cboBacteria",{
		url:$URL+'?ClassName=DHCHAI.DPS.LabBactSrv&QueryName=QryLabBacteria&ResultSetType=Array',
		allowNull: true,       //�ٴε��ȡ��ѡ��
		valueField:'ID',
		textField:'BacDesc'
	});
	///���ض�������
	$HUI.combobox("#cboMRBBact",{
		url:$URL+'?ClassName=DHCHAI.IRS.CRuleMRBSrv&QueryName=QryCRuleMRB&ResultSetType=Array',
		allowNull: true,       //�ٴε��ȡ��ѡ��
		valueField:'ID',
		textField:'BTDesc'
	});
	///���ر걾
	$HUI.combobox("#cboInfType",{
		url:$URL+'?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=Array&aTypeCode=IRInfType&aActive=1',
		allowNull: true,       //�ٴε��ȡ��ѡ��
		valueField:'ID',
		textField:'DicDesc'
	});
	
	obj.gridMBRRep=$HUI.datagrid("#gridMBRRep", {
        fit:true,
        title:'������ҩ�������ѯ',
        toolbar:'#ToolBar',
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
        rownumbers:true,
        singleSelect:false,
        autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
		loading:true,
		//�Ƿ��Ƿ���������������
		sortOrder:'asc',
		remoteSort:false,
		
		pageSize: 20,
		pageList : [20,50,100,200],
	    columns:[[
			{ field:"RepStatus",title:"����״̬",width:100,sortable:true,sorter:Sort_int,
				formatter:function(value,row,index){
					var ReportID=row["ID"];
					var RepStatus=row["RepStatus"];
					var EpisodeID=row["AdmID"];
					var LabRepID=row["xLabRepID"];
					return '<a href="#" onclick="objScreen.OpenReport(\'' + ReportID + '\',\'' + EpisodeID + '\',\'' + LabRepID + '\')">'+RepStatus+'</a>';
				}
			}, 
			{ field:"PapmiNo",title:"�ǼǺ�",width:100,sortable:true,sorter:Sort_int},
			{ field:"MrNo",title:"������",width:100,sortable:true,sorter:Sort_int},
			{ field:"PatName",title:"����",width:100,sortable:true,sorter:Sort_int},		
			{ field:"AdmWardDesc",title:"���ﲡ��",width:180,sortable:true},
			{ field:"SpecDesc",title:"�걾",width:100,sortable:true},
			{ field:"SubmissDate",title:"�ͼ�����",width:100,sortable:true,sorter:Sort_int},
			{ field:"ActDate",title:"��������",width:100,sortable:true,sorter:Sort_int},
			{ field:"MRBDesc",title:"��������",width:200,showTip:true,sortable:true},
			{ field:"link",title:"ҩ�����",width:80,
				formatter:function(value,row,index){
					var ResultID=row["ResultID"];
					return '<a href="#" onclick="objScreen.OpenReslut(\'' + ResultID + '\')">'+$g("ҩ�����")+'</a>';
				}
			},
			{ field:"InfTypeDesc",title:"��Ⱦ����",width:110,sortable:true},
			{ field:"InsulatDesc",title:"���뷽ʽ",width:140,sortable:true},
			{ field:"ContactListDesc",title:"�����ʩ",width:200,showTip:true,sortable:true},
			{ field:"PlaceListDesc",title:"��Ⱦ���˰���",width:200,showTip:true,sortable:true},
			{ field:"UnitListDesc",title:"���뵥Ԫ����",width:200,showTip:true,sortable:true},
			{ field:"TreatDesc",title:"��Ⱦ��������",width:200,sortable:true},
			{ field:"EnvDesc",title:"���������",width:200,sortable:true},
			{ field:"ClothDesc",title:"�ú󱻷�����",width:200,showTip:true,sortable:true},
			{ field:"VisitListDesc",title:"̽���߹���",width:200,sortable:true},
			{ field:"EndListDesc",title:"��ĩ����",width:200,sortable:true},
			{ field:"Sex",title:"�Ա�",width:50,sortable:true},
			{ field:"Age",title:"����",width:80,sortable:true,sorter:Sort_int},
			{ field:"AdmDate",title:"��Ժ����",width:100,sortable:true,sorter:Sort_int},		
			{ field:"DischDate",title:"��Ժ����",width:100,sortable:true,sorter:Sort_int},
			{ field:"RepDate",title:"��д����",width:100,sortable:true,sorter:Sort_int},
			{ field:"RepUser",title:"��д��",width:100,sortable:true},
			{ field:"RepLoc",title:"��д����",width:150,sortable:true},
			{ field:"ZY",title:"������ϸ",width:80,
			   formatter:function (value, row, index){
					var RepID=row["RepID"];
					return '<a href="#" onclick="objScreen.OpenMBRRepLog(\'' + RepID + '\')">'+$g("������ϸ")+'</a>';
			   }
			}
		]],
		onSelect:function(rowIndex,rowData){
			obj.rowIndex=rowIndex;
        },
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
			$(this).datagrid('columnMoving'); //�п�����ק�ı�˳��
		}
    });
	//���ͱ��������ϸ
	obj.gridMBRRepLog=$('#gridMBRRepLog').datagrid({
        fit:true,
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
        rownumbers:true,
        singleSelect:false,
        autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200],
        columns: [[
			{ field:"SubID",title:"����ID",width:80},
			{ field:"StatusDesc",title:"����",width:120},
			{ field:"UpdateDate",title:"��������",width:120},
            { field:"UpdateTime",title:"����ʱ��",width:120},
            { field:"UpdateUserDesc",title:"������",width:120}
        ]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
		}
    });
	obj.gridIRDrugSen=$('#gridIRDrugSen').datagrid({
        fit:true,
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
        rownumbers:true,
        singleSelect:false,
        autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200],
	    columns:[[
	        { field:"AntDesc",title:"������",width:400},
			{ field:"Sensitivity",title:"ҩ�����",width:320,
				formatter: function(value,row,index){
					if (row.IsInt==1) {
						return value +'<div style="display:inline;margin-left:3px;background-color:red;color:#fff;border-radius:1px;font-size:10px;padding:2px;">'+$g("��")+'</div>';
					}else {
						return value;
					}						
				}		
			}
		]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
		}
    });

	InitMBRRepWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
