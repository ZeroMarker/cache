//ҳ��Gui
var objScreen = new Object();
function InitHandHyQryWin() {
	var obj = objScreen;

	//���ÿ�ʼ���ںͽ�������Ϊ���µ�һ��
	var date=new Date()
	date.setDate(1);
	var DateFrom=Common_GetDate(date)
	Common_SetValue('DateFrom',DateFrom);
	Common_SetValue('DateTo',Common_GetDate(new Date())); 
    //ҽԺ
    $HUI.combobox("#cboHospital",{
		url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospListByLogon&ResultSetType=Array&aLogonHospID='+$.LOGON.HOSPID,
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		onSelect:function(rec){
			Common_ComboToLoc('cboLoc',rec.ID,"","","");
		},
		onLoadSuccess:function(data){
			// Ժ��Ĭ��ѡ��
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
	Common_ComboDicID("cboMethod","HandHyObsMethod");
	
	
    $('#girdHandHyQry').datagrid({
        fit:true,
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
		sortOrder:'asc',
		remoteSort:false,
	    columns:[[
			{ field:"LocDesc",title:"�������/����",width:240,align:'left',sortable:true},		
			{ field:"ObsMethodDesc",title:"���鷽ʽ",width:120,align:'left',sortable:true},
			{ field:"ObsDate",title:"��������",width:150,align:'left',sortable:true,sorter:Sort_int},
			{ field:"ObsPageDesc",title:"����ҳ��",width:100,align:'left',sortable:true},
			{ field:"ObsUser",title:"������",width:150,align:'left',sortable:true},
			{ field:"link",title:"����",width:150,align:'left',sortable:true,
				formatter:function(value,row,index){
					return '<a href="#" onclick="objScreen.ShowHandHyReg(\'' +row.RegID + '\',\'' +row.LocID + '\',\'' +row.ObsDate + '\',\'' +row.ObsPageID + '\',\'' +row.ObsMethodID + '\',\'' +row.ObsUser + '\')">�鿴</a>';
				}
			}
		]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
		}
    });
    InitHandHyQryWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}