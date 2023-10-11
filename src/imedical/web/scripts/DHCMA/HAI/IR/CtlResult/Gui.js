//ҳ��Gui
var objScreen = new Object();
function InitPatFindWin(){
	var obj = objScreen;
	obj.IndexID = "";
	obj.LocID = (tDHCMedMenuOper['Admin']==1 ? '':$.LOGON.LOCID);
	var CheckFlg = 0; 
	if (tDHCMedMenuOper['Admin']==1) {
		CheckFlg = 1; //���Ȩ��
	}
	// ���ڸ���ʼֵ
	var date=new Date();
	date.setDate(1);
	var DateFrom=Common_GetDate(date);
	obj.dtDateFrom = $('#dtDateFrom').datebox('setValue',DateFrom);    // ���ڳ�ʼ��ֵ
	obj.dtDateTo = $('#dtDateTo').datebox('setValue', Common_GetDate(new Date()));
	//ҽԺ
	obj.cboHospital = Common_ComboToSSHosp("cboHospital",$.LOGON.HOSPID);
	
	//ҽԺ
    $HUI.combobox("#cboHospital",{
		onSelect:function(rec){
			if (CheckFlg!=1){  //�ǹ���ԱȨ�޿��Ҳ�����ѡ��
				Common_ComboToLoc('cboAdmWard',rec.ID,"","I","E");
				Common_ComboToLoc('cboLabWard',rec.ID,"","I","E");
				$('#cboLabWard').combobox('setValue',$.LOGON.LOCID);
				$('#cboLabWard').combobox('setText',$.LOGON.LOCDESC);
				$('#cboLabWard').combobox('disable');
				$('#cboAdmWard').combobox('disable');
			}else {
				Common_ComboToLoc('cboAdmWard',rec.ID,"","I","W");
				Common_ComboToLoc('cboLabWard',rec.ID,"","I","W");
			}
		}
	});
	$HUI.combobox("#cboDateType",{
		data:[
			{value:'1',text:'�ͼ�����',selected:true},
			{value:'2',text:'��������'}
		],
		valueField:'value',
		textField:'text'
	});
	
	
	$HUI.combobox("#cboIsUnRepeat",{
		data:[
			{value:'1',text:$g('����')},
			{value:'2',text:$g('������'),selected:true}
		],
		valueField:'value',
		textField:'text',
		onSelect:function(rows) {
			var Type = rows.value;
			if (Type==2) {
				$('.RepeatRule').css('color','#999');
				$('#cboUnSpec').combobox('disable');
				$('#cboUnBact').combobox('disable');
			}else {
				$('.RepeatRule').css('color','black');
				$('#cboUnSpec').combobox('enable');
				$('#cboUnBact').combobox('enable');
			}
		}
	});
	
	$HUI.combobox("#cboUnSpec",{
		data:[
			{value:'1',text:$g('����'),selected:true},
			{value:'2',text:$g('ͬ��')}
		],
		valueField:'value',
		textField:'text'
	});
	
	$HUI.combobox("#cboUnBact",{
		data:[
			{value:'1',text:$g('��������'),selected:true},
			{value:'2',text:$g('ϸ��')}
		],
		valueField:'value',
		textField:'text'
	});
	
	//��Ⱦ����
	$HUI.combobox("#cboInfType",{
		url:$URL+'?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=Array&aTypeCode=IRInfType&aActive=1',
		multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		valueField:'ID',
		textField:'DicDesc'
	});
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
		valueField:'value',
		textField:'text'
	});
	
	///����ϸ��
	$HUI.combobox("#cboBacteria",{
		url:$URL+'?ClassName=DHCHAI.DPS.LabBactSrv&QueryName=QryLabBacteria&ResultSetType=Array',
		allowNull: true,       //�ٴε��ȡ��ѡ��
		valueField:'ID',
		textField:'BacDesc'
	});
	
	///���ض�������
	$HUI.combobox("#cboMRBBact",{
		url:$URL+'?ClassName=DHCHAI.IRS.CRuleMRBSrv&QueryName=QryCRuleMRB&ResultSetType=Array',
		editable:false,
		allowNull: true,       //�ٴε��ȡ��ѡ��
		valueField:'ID',
		textField:'BTDesc'
	});
	obj.gridStat = $HUI.datagrid("#gridStat",{
        fit:true,
		toolbar:[],
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
        rownumbers:true,
        singleSelect:true,
        autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
			ClassName:"DHCHAI.IRS.CtlMRBSrv",
			QueryName:"StaMRBResult",
			aHospIDs:$("#cboHospital").combobox('getValue'),
			aDateType:$("#cboDateType").combobox('getValue'),
			aDateFrom:$("#dtDateFrom").datebox('getValue'),
			aDateTo:$("#dtDateTo").datebox('getValue'),
			aLocID:obj.LocID
		},
	    columns:[[
	        { field:"DataDesc",title:"�ͼ첡��/ϸ��/����״̬",width:200},
			{ field:"MRBNum",title:"����",width:60,align:'center'},
			{ field:"MRBRatio",title:"ռ��",width:90,align:'center'}
		]],
		onSelect:function(rindex,rowData){
			if ((rindex>-1)&(CheckFlg==1)) {   //ֻ�������Ա�л�
				obj.gridStat_onSelect();
			}
		}
    });
	//��ǰ���� CurrAdmBed ��Ϊ AdmBed
	obj.gridApply=$('#gridApply').datagrid({
        fit:true,
		title:'������ҩ����ز�ѯ',
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
					var txt = $g("δ����");
					var ReportID = row["INFMBRID"];				 
					var EpisodeID=row["AdmID"];
					var LabRepID=row["LabRepID"];
					var LabResID =row["ResultID"];  //������ID		
					if((value!="")&&(value!=undefined)){
						txt = value;
					}
					return '<a href="#" onclick="objScreen.OpenReport(\'' + ReportID + '\',\'' + EpisodeID + '\',\'' + LabRepID + '\',\'' + LabResID + '\')">'+txt+'</a>';
				}
			},
			{ field:"PapmiNo",title:"�ǼǺ�",width:100,sortable:true,sorter:Sort_int},
	        { field:"MrNo",title:"������",width:100,sortable:true,sorter:Sort_int},
			{ field:"PatName",title:"����",width:100,sortable:true,sorter:Sort_int},
			{ field:"LocDesc",title:"�ͼ����",width:120,sortable:true},
			{ field:"CurrAdmLoc",title:"��ǰ����",width:120,sortable:true},
			{ field:"AdmBed",title:"��ǰ����",width:120,sortable:true},
			{ field:"PAAdmDoc",title:"����ҽ��",width:90,sortable:true},
			{ field:"LabWardDesc",title:"�ͼ첡��",width:150,sortable:true},
			{ field:"SpeDesc",title:"�걾",width:100,sortable:true},
			{ field:"BacDesc",title:"ϸ��",width:150,sortable:true},
			{ field:"ActDateTime",title:"�ͼ�����",width:100,sortable:true,sorter:Sort_int},
			{ field:"RepDateTime",title:"��������",width:100,sortable:true,sorter:Sort_int},
			{ field:"MRBDesc",title:"��������",width:200,showTip:true,sortable:true,
				formatter:function(value,row,index){
					 var MRBDesc2 = row["MRBDesc2"];
					 var MRBDesc  = row["MRBDesc"];
					 if (MRBDesc2!=""){
						return MRBDesc+"��"+MRBDesc2;
					}else{
						return MRBDesc;
					}
				}
			}, 
			{ field:"InfTypeDesc",title:"��Ⱦ����",width:110,sortable:true,
				formatter:function(value,row,index){
					var ResultID=row["ResultID"];
					var MRBOutLabType = row["MRBOutLabType"];
					var RowID=row["ID"];		 
					if (value!=""){
						return '<a href="#" style="color:#000" onclick="objScreen.MenuEdit(\'' +index + '\',\'' + ResultID+ '\',\'' + MRBOutLabType+ '\',\'' + RowID + '\')">'+value+'</a>';
					}else{
						return '<a href="#" onclick="objScreen.MenuEdit(\'' +index + '\',\'' + ResultID+ '\',\'' + MRBOutLabType + '\',\'' + RowID + '\')">'+$g("���")+'</a>';
					}
				}
			},
			{ field:"link",title:"������Ϣ",width:100,
				formatter:function(value,row,index){
					 if (CheckFlg != '1') {
						return '';
					} else {
					 	var AdmID 		= row["AdmID"];
					 	var ResultID 	= row["ID"];
					 	var MRBDesc 	= row["MRBDesc"];
					 	var Bacteria 	= row["Bacteria"];
					 	return '<a href="#" onclick="objScreen.SendMessage(\'' + ResultID + '\',\'' + AdmID + '\',\'' + MRBDesc + '\',\'' + Bacteria + '\')">'+$g("������Ϣ")+'</a>';
					}
				}
			},
			{ field:"link1",title:"ҩ�����",width:100,
				formatter:function(value,row,index){
					 var ResultID=row["ResultID"];
					 
					return '<a href="#" onclick="objScreen.OpenReslut(\'' + ResultID + '\')">'+$g("ҩ�����")+'</a>';
				}
			},
			{ field:"link2",title:"ժҪ",width:80,
				formatter:function(value,row,index){
					 var EpisodeID = row["AdmID"];
					 return '<a href="#" onclick="objScreen.OpenMainView(\'' + EpisodeID + '\')">'+$g("ժҪ")+'</a>';
				}
			},
			{field:"link3",title:'����ɸ��',width:80,
				formatter:function(value,row,index){
					 var EpisodeID = row["AdmID"];
					 return '<a href="#" onclick="objScreen.OpenCCSingle(\'' + EpisodeID + '\')">'+$g("����ɸ��")+'</a>';
				}
			}, 	
			{ field:"ISOOrdDesc",title:"����ҽ��",width:180,sortable:true},
			{ field:"Gap",title:"����-������",width:180,sortable:true},
			{ field:"ISOSttDateTime",title:"����ҽ����ʼ����",width:150,sortable:true,sorter:Sort_int},
			{ field:"ISOEndDateTime",title:"����ҽ����������",width:150,sortable:true,sorter:Sort_int},			
			{ field:"Sex",title:"�Ա�",width:50,sortable:true},
			{ field:"Age",title:"����",width:80,sortable:true,sorter:Sort_int},
			{ field:"AdmDate",title:"��Ժ����",width:100,sortable:true,sorter:Sort_int},
			{ field:"DischDate",title:"��Ժ����",width:100,sortable:true,sorter:Sort_int},
			{ field:"UpdateDate",title:"��д����",width:100,sortable:true,sorter:Sort_int},
			{ field:"RepUser",title:"��д��",width:100,sortable:true},
			{ field:"UpdateLoc",title:"��д����",width:150,sortable:true},	
			{ field:"ZY",title:"������ϸ",width:80,
			   formatter:function (value, row, index){
					var RepID=row["RepID"];
					return '<a href="#" onclick="objScreen.OpenMBRRepLog(\'' + RepID + '\')">'+$g("������ϸ")+'</a>';
			   }
			},
			{ field:"MRBOutLabType",title:"���淽ʽ",width:120,sortable:true}
		]],
		rowStyler: function (index, row) {
        	if (row.InfTypeDesc == "HA(Ժ�ڸ�Ⱦ)") {
         		return 'color:red;';
        	}
        },
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
	///���ظ�Ⱦ����
	$HUI.combobox("#cboMakeInfType",{
		url:$URL+'?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=Array&aTypeCode=IRInfType&aActive=1',
		allowNull: true,       //�ٴε��ȡ��ѡ��
		valueField:'DicCode',
		textField:'DicDesc'
	});
	$("#divWest>div>div").css("border","none");
	$("#divWest").prev().css("border-radius","4px 4px 0 0");
	$("#divWest").css("border-radius","0 0 4px 4px");
	
	$(".layout-split-west").css("padding-right","5px");
	InitPatFindWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
