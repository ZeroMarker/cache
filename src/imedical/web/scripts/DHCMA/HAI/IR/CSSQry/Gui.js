//ҳ��Gui
var objScreen = new Object();

function InitPatFindWin(){
	var obj = objScreen;
	obj.Params="";
$(".line").css("display","none")
	//����ԱȨ��
	obj.AdminPower=0;
	if (tDHCMedMenuOper['Admin']==1) {
		obj.AdminPower =1;
	}
	
	///���ر��(���ر��[Ĭ�ϼ������һ��][��ʾ]  ����Ա:��ѡ,�ǹ���Ա:����ѡ)
	$HUI.combobox("#cboSurvNumber",{
		url:$URL+'?ClassName=DHCHAI.IRS.INFCSSSrv&QueryName=QueryByCode&ResultSetType=Array&aHospIDs='+$.LOGON.HOSPID+'&aFlag='+obj.AdminPower,
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
	$(".line").css("display","none")
	$HUI.radio("input[name='chkStatunit']",{
		onChecked:function(e,value){
			var Status=Common_CheckboxValue('chkStatunit');
			if (Status=="2"){
				$(".line").css("display","block")
				$("#btnChkReps").show();
				$("#btnUnChkReps").hide();
			}else if (Status=="3"){
				$(".line").css("display","block")
				$("#btnUnChkReps").show();
				$("#btnChkReps").hide();
			}else{
				$(".line").css("display","none")
				$("#btnChkReps").hide();
				$("#btnUnChkReps").hide();
			}
			obj.reloadgridApply();
		},
		onUnchecked:function(e,value){
			$("#btnChkReps").hide();
			$("#btnUnChkReps").hide();
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
				Common_ComboToLoc('cboLocation',rec.ID,"","I");
			},onLoadSuccess:function(data){
				// Ժ��Ĭ��ѡ��
				$('#cboHospital').combobox('select',data[0].ID);
			}
		});
	 $HUI.combobox("#cboLocation",{
			onLoadSuccess:function(data){
				// Ժ��Ĭ��ѡ��
				if(tDHCMedMenuOper['Admin']!=1) {
					$("#cboLocation").combobox('setValue',$.LOGON.LOCID);
					$("#cboLocation").combobox('setText',$.LOGON.LOCDESC);
					$('#cboLocation').combobox('disable');
					$('#cboHospital').combobox('disable');
				}
			}
		});
    Common_ComboDicID("cboInfCategoryDr","IRCSSINFTYPE");
	obj.gridApply=$('#gridApply').datagrid({
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
                ClassTableName:'DHCHAI.IR.INFCSS',
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
					var ReportID = row["RepID"];
					var EpisodeID = row["EpisodeID"];
					var SurvNumber = row["SurvNumber"];
					if (value=="δ����"){
						var RepStatus=1;
					}else if (value=="�ѵ���"){
						var RepStatus=2;
					}else{
						var RepStatus=3;
					}
					 return '<a href="#" onclick="objScreen.OpenReport(\'' + EpisodeID + '\',\'' + SurvNumber + '\',\'' + ReportID+ '\',\''+ index+ '\',\'' + RepStatus + '\')">'+value+'</a>';
				}
			}, 
			{ field:"SurLocDesc",title:"�������/����",width:180,sortable:true,sorter:Sort_int},
			{ field:"PapmiNo",title:"�ǼǺ�",width:100,sortable:true,sorter:Sort_int},
			{ field:"MrNo",title:"������",width:100,sortable:true,sorter:Sort_int},
			{ field:"PatName",title:"����",width:70,sortable:true,sorter:Sort_int},
			{ field:"Sex",title:"�Ա�",width:50,sortable:true,sorter:Sort_int},
			{ field:"Age",title:"����",width:50,sortable:true,sorter:Sort_int},
			{ field:"IdentityCode",title:"���֤��",width:180,sortable:true,sorter:Sort_int},
			{ field:"AdmBed",title:"��λ",width:70,sortable:true,sorter:Sort_int},
			{ field:"AdmDoc",title:"�ܴ�ҽʦ",width:80,sortable:true,sorter:Sort_int},
			{ field:"ZY",title:"ժҪ",width:60,
				formatter:function(value,row,index){
					 var EpisodeID = row["EpisodeID"];
					 return '<a href="#" onclick="objScreen.OpenMainView(\'' + EpisodeID + '\')">ժҪ</a>';
				}
			},
			{ field:"DiagnosDesc",title:"�������",width:200,showTip:true,sortable:true,sorter:Sort_int},
			{ field:"OBSCnt",title:"��ȥ24Сʱ</br>���Ƿ�к",width:100,sortable:true,sorter:Sort_int},
			{ field:"OperFlag",title:"�Ƿ�����",width:80,sortable:true,sorter:Sort_int},
			{ field:"CuteType",title:"�п�����",width:120,showTip:true,sortable:true,sorter:Sort_int},
            /*{ field:"YYInfPos11Desc",title:"��Ⱦ��Ϣ",width:200,sortable:true,sorter:Sort_int,
                formatter:function(value,row,index){
                     var YYInfPos11Desc = row["YYInfPos11Desc"];
                     var YYInfPos21Desc = row["YYInfPos21Desc"];
                     var YYInfPos31Desc = row["YYInfPos31Desc"];
                     var InfPosDescs=""
                     if(YYInfPos11Desc!="") InfPosDescs=YYInfPos11Desc
                     if(YYInfPos21Desc!="") InfPosDescs=InfPosDescs+"^"+YYInfPos21Desc
                     if(YYInfPos31Desc!="") InfPosDescs=InfPosDescs+"^"+YYInfPos31Desc
                     
                     return InfPosDescs;
                }
            },*/
            
            { field:"InfectionDesc",title:"�Ƿ��Ⱦ",width:100,sortable:true,sorter:Sort_int},
            { field:"InfCateDesc",title:"��Ⱦ����",width:100,sortable:true,sorter:Sort_int},
            { field:"FirInfDate",title:"�״�ҽԺ��Ⱦ����",width:120,sortable:true,sorter:Sort_int},
            { field:"YYInfPos11Desc",title:"ҽԺ��Ⱦ��λ1",width:120,sortable:true,sorter:Sort_int},
            { field:"YYBacteria11Desc",title:"HA��ԭ��11",width:120,sortable:true,sorter:Sort_int},
            { field:"YYBacteria12Desc",title:"HA��ԭ��12",width:120,sortable:true,sorter:Sort_int},
            { field:"YYBacteria13Desc",title:"HA��ԭ��13",width:120,sortable:true,sorter:Sort_int},
            { field:"YYInfPos21Desc",title:"ҽԺ��Ⱦ��λ2",width:120,sortable:true,sorter:Sort_int},
            { field:"YYBacteria21Desc",title:"HA��ԭ��21",width:120,sortable:true,sorter:Sort_int},
            { field:"YYBacteria22Desc",title:"HA��ԭ��22",width:120,sortable:true,sorter:Sort_int},
            { field:"YYBacteria23Desc",title:"HA��ԭ��23",width:120,sortable:true,sorter:Sort_int},
            { field:"YYInfPos31Desc",title:"ҽԺ��Ⱦ��λ3",width:120,sortable:true,sorter:Sort_int},
            { field:"YYBacteria31Desc",title:"HA��ԭ��31",width:120,sortable:true,sorter:Sort_int},
            { field:"YYBacteria32Desc",title:"HA��ԭ��32",width:120,sortable:true,sorter:Sort_int},
            { field:"YYBacteria33Desc",title:"HA��ԭ��33",width:120,sortable:true,sorter:Sort_int},
            { field:"OprInfDesc",title:"���������",width:80,sortable:true,sorter:Sort_int},
            { field:"ComInfPos1",title:"������Ⱦ��λ1",width:120,sortable:true,sorter:Sort_int},
            { field:"SQMethod1",title:"������ʽ1",width:120,sortable:true,sorter:Sort_int},
            { field:"ComBacteria11",title:"CA��ԭ��11",width:120,sortable:true,sorter:Sort_int},
            { field:"ComBacteria12",title:"CA��ԭ��12",width:120,sortable:true,sorter:Sort_int},
            { field:"ComBacteria13",title:"CA��ԭ��13",width:120,sortable:true,sorter:Sort_int},
            { field:"ComInfPos2",title:"������Ⱦ��λ2",width:120,sortable:true,sorter:Sort_int},
            { field:"SQMethod2",title:"������ʽ2",width:120,sortable:true,sorter:Sort_int},
            { field:"ComBacteria21",title:"CA��ԭ��21",width:120,sortable:true,sorter:Sort_int},
            { field:"ComBacteria22",title:"CA��ԭ��22",width:120,sortable:true,sorter:Sort_int},
            { field:"ComBacteria23",title:"CA��ԭ��23",width:120,sortable:true,sorter:Sort_int},
            { field:"ComInfPos3",title:"������Ⱦ��λ3",width:120,sortable:true,sorter:Sort_int},
            { field:"SQMethod3",title:"������ʽ3",width:120,sortable:true,sorter:Sort_int},
            { field:"ComBacteria31",title:"CA��ԭ��31",width:120,sortable:true,sorter:Sort_int},
            { field:"ComBacteria32",title:"CA��ԭ��32",width:120,sortable:true,sorter:Sort_int},
            { field:"ComBacteria33",title:"CA��ԭ��33",width:120,sortable:true,sorter:Sort_int},
            { field:"IRAntiFlag",title:"�Ƿ�ʹ��</br>������",width:80,sortable:true,sorter:Sort_int},
            { field:"PurposeDesc",title:"ʹ��Ŀ��",width:100,sortable:true,sorter:Sort_int},
            { field:"CombinDesc",title:"�������",width:80,sortable:true,sorter:Sort_int},
            { field:"IRAntiSenFlag",title:"������ҩ����ϸ������",width:100,sortable:true,sorter:Sort_int},
            { field:"IROperAntiFlag",title:"������ʱ��Ϊ����ҩ��ʹ��ǰ",width:100,sortable:true,sorter:Sort_int},
            { field:"AdmDate",title:"��Ժ����",width:120,sortable:true,sorter:Sort_int},
            { field:"DischDate",title:"��Ժ����",width:120,sortable:true,sorter:Sort_int},
            { field:"AdmTimes",title:"סԺ����",width:80,sortable:true,sorter:Sort_int}, 
            { field:"CSSSpecGLFlag",title:"�걾����Ⱦɫ",width:120,sortable:true,sorter:Sort_int},
            { field:"CSSSpecKSFlag",title:"�걾����Ⱦɫ",width:120,sortable:true,sorter:Sort_int},
            { field:"CSSSpecMZFlag",title:"�걾ī֭Ⱦɫ",width:120,sortable:true,sorter:Sort_int},
            { field:"CSSSpecJYFlag",title:"�걾�������",width:120,sortable:true,sorter:Sort_int},
            { field:"EpisodeID",title:"����Ψһ��ʶ",width:120,sortable:true,sorter:Sort_int}
            
			]],
		onSelect:function(rowIndex,rowData){
			obj.rowIndex=rowIndex;
        },
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
            $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //����й�������������������
            $(this).datagrid('columnMoving'); //�п�����ק�ı�˳��
		}
    });
        ShowUserHabit('gridApply');
	

	InitPatFindWinEvent(obj);
	obj.LoadEvent(arguments);

	return obj;
}
