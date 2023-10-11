//ҳ��Gui
var objScreen = new Object();
function InitCtlBactResultWin(){
	var obj = objScreen;
	// ���ڸ���ʼֵ
	var YearList = $cm ({									//��ʼ����(���ʮ��)
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryYear"
	},false);
	$HUI.combobox("#cboYear",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:YearList.rows,
		onSelect:function(rec){
			Date_QuickSelect("cboYear","cboMonth","dtDateFrom","dtDateTo");	//���Ŀ�ʼ-��������
		}
	});
	var MonthList = $cm ({									//��ʼ����+����+ȫ��
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryMonth"
	},false);
	$HUI.combobox("#cboMonth",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:MonthList.rows,
		onSelect:function(rec){
			Date_QuickSelect("cboYear","cboMonth","dtDateFrom","dtDateTo");	//���Ŀ�ʼ-��������
		}
	});
	var NowDate=month_formatter(new Date());
	var NowYear=NowDate.split("-")[0];	//��ǰ��
	var NowMonth=NowDate.split("-")[1]	//��ǰ��
	$('#cboYear').combobox('select',NowYear);
	$('#cboMonth').combobox('select',NowMonth);
	$HUI.combobox("#cboDateType",{
		data:[
			{value:'1',text:'�ͼ�����',selected:true},
			{value:'2',text:'��������'}
		],
		valueField:'value',
		textField:'text'
	})
	
	//ҽԺ�б�
	var HospList = $cm ({
		ClassName:"DHCHAI.BTS.HospitalSrv",
		QueryName:"QryHospListByLogon",
		aLogonHospID:$.LOGON.HOSPID
	},false);
	obj.HospData = HospList.rows;
		
	//ҽԺ
    $HUI.combobox("#cboHospital",{
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		data:obj.HospData,
		onSelect:function(rec){
			Common_ComboToLoc('cboLocation',rec.ID,"","I","W");
			Common_ComboToLoc('cboWard',rec.ID,"","I","W");
		},
		onLoadSuccess:function(data){
			// Ժ��Ĭ��ѡ��
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
	
	///���ز�ԭ��
	$HUI.combobox("#cboBacteria",{
		url:$URL+'?ClassName=DHCHAI.DPS.LabBactSrv&QueryName=QryLabBacteria&ResultSetType=Array',
		allowNull: false,       //�ٴε��ȡ��ѡ��
		valueField:'ID',
		textField:'BacDesc'
	});
	///���ض�������
	$HUI.combobox("#cboMRBBact",{
		url:$URL+'?ClassName=DHCHAI.IRS.CRuleMRBSrv&QueryName=QryCRuleMRB&ResultSetType=Array',
		allowNull: false,       //�ٴε��ȡ��ѡ��
		valueField:'ID',
		textField:'BTDesc'
	});
	///���ر걾
	$HUI.combobox("#cboLabSpec",{
		url:$URL+'?ClassName=DHCHAI.DPS.LabSpecSrv&QueryName=QryLabSpecimen&ResultSetType=Array&aActive=1',
		allowNull: false,       //�ٴε��ȡ��ѡ��
		valueField:'ID',
		textField:'SpecDesc'
	});
	$HUI.combobox("#cboMRBOutLabType",{
		url:$URL+'?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=Array&aTypeCode=MRBOutLabType',
		allowNull: true,       //�ٴε��ȡ��ѡ��
		valueField:'ID',
		textField:'DicDesc'
	});
	//��Ⱦ����
	obj.cboInfType = Common_ComboDicID("cboInfType","IRInfType");
	
	obj.gridCtlResult=$('#gridCtlResult').datagrid({
        fit:true,
        title:'ϸ����������ѯ',
        toolbar:'#ToolBar',
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
		sortOrder:'asc',
		remoteSort:false,
	    columns:[[
			{ field:"PapmiNo",title:"�ǼǺ�",width:100,sortable:true},
			{ field:"MrNo",title:"������",width:100,sortable:true},
			{ field:"PatName",title:"����",width:100,sortable:true},
			{ field:"AdmWardDesc",title:"���ﲡ��",width:180,sortable:true},
			{ field:"LocDesc",title:"�ͼ����",width:150,sortable:true},
			{ field:"LabWardDesc",title:"�ͼ첡��",width:150,sortable:true},
			{ field:"ActDate",title:"�ͼ�����",width:100,sortable:true,sorter:Sort_int},
			{ field:"RepDate",title:"��������",width:100,sortable:true,sorter:Sort_int},
			{ field:"Specimen",title:"�걾",width:100,sortable:true},
			{ field:"Bacteria",title:"ϸ��",width:150,sortable:true},
			{ field:"MRBDesc",title:"���ͱ��",width:200,showTip:true,sortable:true,
				formatter:function(value,row,index){
					 var MRBDesc2 = row["MRBDesc2"];
					 var MRBDesc  = row["MRBDesc"];
					 if (MRBDesc2!=""){
						return MRBDesc+","+MRBDesc2;
					}else{
						return MRBDesc;
					}
				}
			}, 
			{ field:"InfTypeDesc",title:"��Ⱦ����",width:120,sortable:true,
				formatter:function(value,row,index){
					var ResultID=row["ResultID"];
					var MRBOutLabType = row["MRBOutLabType"];
					var RowID=row["ID"];
					if (value!=""){
						return '<a href="#" style="color:#000" onclick="objScreen.MenuEdit(\'' +index + '\',\'' + ResultID+ '\',\'' + MRBOutLabType+ '\',\'' + RowID + '\')">'+value+'</a>';
					}else{
						return '<a href="#" onclick="objScreen.MenuEdit(\'' +index + '\',\'' + ResultID+ '\',\'' + MRBOutLabType + '\',\'' + RowID + '\')">���</a>';
					}
				}
			},
			{ field:"expander",title:"ժҪ",width:80,
				formatter:function(value,row,index){					
					 return '<a href="#" onclick="objScreen.OpenMainView(\'' + row.AdmID + '\')">ժҪ</a>';
				}
			},
			{ field:"expander1",title:"���Ӳ���",width:80,sortable:true,
				formatter:function(value,row,index){
					var EpisodeID = row["EpisodeID"];
					EpisodeID = EpisodeID.split("||")[1];
					return '<a href="#" onclick=objScreen.OpenEmrRecord(\''+EpisodeID+'\',\''+row.PatientID+'\')>�������</a>';
				}
			},
			{ field:"expander2",title:"ҩ�����",width:80,
				formatter:function(value,row,index){
					 var ResultID=row["ResultID"];
					return '<a href="#" onclick="objScreen.OpenReslut(\'' + ResultID + '\')">ҩ�����</a>';
				}
			},					
		
			{ field:"Sex",title:"�Ա�",width:50,sortable:true},
			{ field:"Age",title:"����",width:80,sortable:true},
			{ field:"AdmDate",title:"��Ժ����",width:100,sortable:true,sorter:Sort_int},
			{ field:"DischDate",title:"��Ժ����",width:100,sortable:true,sorter:Sort_int},
			{ field:"MRBOutLabType",title:"���淽ʽ",width:120,sortable:true,sorter:Sort_int}
		]],
		rowStyler: function (index, row) {
        	if (row.InfTypeDesc == "HA(Ժ�ڸ�Ⱦ)") {
         		return 'color:red;';
        	}
        },
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
						return value +'<div style="display:inline;margin-left:3px;background-color:red;color:#fff;border-radius:3px;font-size:10px;padding:3px;width:20px;height:20px;font-weight: 600;">��</div>';
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

	InitCtlBactResultWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
