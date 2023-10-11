//ҳ��Gui
var objScreen = new Object();

function InitBPSurvWin(){
	var obj = objScreen;
	obj.Params="";
	//����ԱȨ��
	obj.AdminPower=0;
	if (tDHCMedMenuOper['Admin']==1) {
		obj.AdminPower =1;
	}
	
	///���ر��(���ر��[Ĭ�ϼ������һ��][��ʾ]  ����Ա:��ѡ,�ǹ���Ա:����ѡ)
	$HUI.combobox("#cboSurvNumber",{
		url:$URL+'?ClassName=DHCHAI.IRS.BPSurveyExecSrv&QueryName=QueryByCode&ResultSetType=Array&aHospIDs='+$.LOGON.HOSPID+'&aFlag='+obj.AdminPower,
		valueField:'ID',
		textField:'SESurvNumber',
		onLoadSuccess:function(data){
			//Ĭ��ѡ������һ��
			$("#cboSurvNumber").combobox('select',data[0].ID);
			if(tDHCMedMenuOper['Admin']!=1) {
				$('#cboSurvNumber').combobox('disable');
			}
		}
	});
	$("#btnChkReps").hide();
	$("#btnUnChkReps").hide();
	$HUI.radio("input[name='chkStatunit']",{
		onChecked:function(e,value){
			var Status=Common_CheckboxValue('chkStatunit');
			if (Status=="2"){
				$("#btnChkReps").show();
				$("#btnUnChkReps").hide();
			}else if (Status=="3"){
				$("#btnUnChkReps").show();
				$("#btnChkReps").hide();
			}else{
				$("#btnChkReps").hide();
				$("#btnUnChkReps").hide();
			}
			obj.reloadgridBPReg();
		},
		onUnchecked:function(e,value){
			$("#btnChkReps").hide();
			$("#btnUnChkReps").hide();
			obj.reloadgridBPReg();
		}
	});
	//͸������
	obj.cboBDLocation  = $HUI.combobox("#cboBDLocation", {
		url: $URL,
		editable: true,
		allowNull: true, 
		multiple:true,
		rowStyle:'checkbox',
		defaultFilter:4,     //text�ֶΰ���ƥ���ƴ������ĸ����ƥ�� �����ִ�Сд
		valueField: 'LocID',
		textField: 'LocDesc2',
		onBeforeLoad: function (param) {    //�������������֮ǰ���������� false ��ȡ�����ض���
			param.ClassName = 'DHCHAI.IRS.BPSurverySrv';
			param.QueryName = 'QryBPLocation';
			param.ResultSetType = 'array';
		}
	});
	var HospList = $cm ({
		ClassName:"DHCHAI.BTS.HospitalSrv",
		QueryName:"QryHospListByLogon",
		aLogonHospID:$.LOGON.HOSPID
	},false);
	obj.HospData = HospList.rows;
    $HUI.combobox("#cboHospital",{
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		data:obj.HospData,
		onSelect:function(rec){
		},onLoadSuccess:function(data){
			// Ժ��Ĭ��ѡ��
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
	
	if(tDHCMedMenuOper['Admin']!=1) {
		$("#cboBDLocation").combobox('setValue',$.LOGON.LOCID);
		$("#cboBDLocation").combobox('setText',$.LOGON.LOCDESC);
		$('#cboLocation').combobox('disable');
		$('#cboHospital').combobox('disable');
	}
	
	obj.gridBPRegList=$('#gridBPRegList').datagrid({
        fit:true,
        toolbar:'#ToolBar',
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
        rownumbers:false,
        singleSelect:false,
        autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
		loading:true,
		//�Ƿ��Ƿ���������������
		sortOrder:'asc',
		remoteSort:false,
		//��ҳ
		pageSize: 20,
		pageList : [20,50,100,500,1000,10000],
	    columns:[[
	    	{field:'checkOrd',checkbox:'true',width:'80',auto:false},
			{title:'����״̬',width:80,field:'RepStatus',
				formatter:function(value,row,index){
					var ReportID   = row["BPSurvID"];
					var SurvNumber = row["SurvNumberID"];
					var BPRegID    = row["BPRegID"];
					if (value=="δ����"){
						var RepStatus=1;
					}else if (value=="�ѵ���"){
						var RepStatus=2;
					}else{
						var RepStatus=3;
					}
					 return '<a href="#" onclick="objScreen.OpenReport(\'' + SurvNumber + '\',\'' + ReportID+ '\',\''+ index+ '\',\'' + RepStatus+ '\',\'' + BPRegID + '\')">'+value+'</a>';
				}
			}, 
			{ field:"AdmLocDesc",title:"�������/����",width:180,sortable:true},
			{ field:"PapmiNo",title:"�ǼǺ�",width:100,sortable:true},
			{ field:"PAMrNo",title:"������",width:100,sortable:true},
			{ field:"PAPatName",title:"����",width:70,sortable:true},
			{ field:"PAPatSex",title:"�Ա�",width:50,sortable:true},
			{ field:"PAPatAge",title:"����",width:50,sortable:true},
			{ field:"PARegDate",title:"�Ǽ�����",width:110,sortable:true},
			{ field:"PAStartDate",title:"�״�͸������",width:110,sortable:true},
			{ field:"PAHDTime",title:"͸������",width:80,sortable:true},
			{ field:"PABPPatType",title:"��������",width:80,showTip:true,sortable:true},
			{ field:"BAccessType",title:"Ѫ��ͨ·����",width:120,sortable:true},
			{ field:"PAAdmDoc",title:"����ҽ��",width:80,sortable:true},
			{ field:"PAAdmNurse",title:"���ܻ�ʿ",width:80,showTip:true,sortable:true},
			{ field:"PAEpiInfo",title:"��Ⱦ������",width:100,sortable:true},
			{ field:"PADiagnosis",title:"Ѫ͸������",width:200,sortable:true},
			{ field:"BPRegDate",title:"��������",width:100,sortable:true},
			{ field:"BPRegLocDesc",title:"�������",width:80,sortable:true,sorter:Sort_int},
			{ field:"BPRegUserDesc",title:"������",width:100,sortable:true,sorter:Sort_int}
			]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
		}
    });
	

	InitBPSurvWinEvent(obj);
	obj.LoadEvent(arguments);

	return obj;
}
