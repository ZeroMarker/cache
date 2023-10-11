//ҳ��Gui
var objScreen = new Object();
var obj = new Object();

function InitCtlResultWin(){
	obj.AdminPower=0;
	if (tDHCMedMenuOper['Admin']==1) {
		obj.AdminPower =1;
	}
	//ҽԺ
	obj.cboHospital = Common_ComboToSSHosp("cboHospital",$.LOGON.HOSPID);
    $HUI.combobox("#cboHospital",{
		onSelect:function(rec){
			Common_ComboToLoc('cboLocation',rec.ID,"","I","E");
			Common_ComboToLoc('cboInfLocation',rec.ID,"","I","E");
			if (obj.AdminPower!=1) {
				$('#cboLocation').combobox('disable');
				$('#cboLocation').combobox('setValue',$.LOGON.LOCID);
			}
		}
	});
	//��Ⱦ���
	obj.cboInfDiags  = $HUI.combobox("#cboInfDiags", {
		url: $URL,
		editable: true,
		allowNull: true, 
		multiple:true,
		rowStyle:'checkbox',
		defaultFilter:4,     //text�ֶΰ���ƥ���ƴ������ĸ����ƥ�� �����ִ�Сд
		valueField: 'ID',
		textField: 'Desc',
		onBeforeLoad: function (param) {    //�������������֮ǰ���������� false ��ȡ�����ض���
			param.ClassName = 'DHCHAI.BTS.InfPosSrv';
			param.QueryName = 'QryInfPosToSelect';
			param.aPosFlg = 2;
			param.ResultSetType = 'array';
		}
	});
	//��������
	obj.cboStatus = Common_ComboDicID("cboStatus","InfReportStatus");
	// ���ڳ�ʼ��ֵ
	var date=new Date()
	date.setDate(1);
	var DateFrom=Common_GetDate(date);
	obj.DateFrom = $('#DateFrom').datebox('setValue', DateFrom);    
	obj.DateTo = $('#DateTo').datebox('setValue', Common_GetDate(new Date()));
    //Ĭ����������
    $HUI.combobox("#cboDateType",{
		data:[
			{value:'1',text:$g('��������'),selected:true},
			{value:'2',text:$g('��Ժ����')},
			{value:'3',text:$g('��Ժ����')},
			{value:'4',text:$g('��Ⱦ����')}
		],
		valueField:'value',
		textField:'text'
	})
	
	//���
	obj.gridReport = $('#gridReport').datagrid({
        fit:true,
        title:'',
        headerCls:'panel-header-gray',
        iconCls:'icon-resort',
        pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
        rownumbers:true,
        autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
        singleSelect:false,
        loadMsg:'���ݼ�����...',
        //�Ƿ��Ƿ���������������
        sortOrder:'asc',
		remoteSort:false, 
		pageSize: 20,
		pageList : [20,50,100,200],
        columns:[[
        	{field:'checked',checkbox:'true',align:'left',width:30,auto:false},
			{ field:"ReportStatusDesc",title:"����״̬",width:100,align:'left',sortable:true,
				formatter:function(value,row,index){
					 return '<a href="#"  onclick=obj.ShowResutlDtl(\''+row.ReportID+'\')>'+row.ReportStatusDesc+'</a>';
				}
			},
	        { field:"PatMrNo",title:"������",width:100,align:'left',sortable:true},
			{ field:"PatName",title:"����",width:100,align:'left',sortable:true},
			{ field:"PatSex",title:"�Ա�",width:50,align:'left',sortable:true},
			{ field:"PatAge",title:"����",width:70,align:'left',sortable:true},
			{ field:"AdmitDate",title:"��Ժ����",width:100,align:'left',sortable:true,sorter:Sort_int},
			{ field:"DischDate",title:"��Ժ����",width:100,align:'left',sortable:true,sorter:Sort_int},
			{ field:"ReportLocDesc",title:"�������",width:100,align:'left',sortable:true},
			{ field:"ReportDate",title:"��������",width:100,align:'left',sortable:true,sorter:Sort_int},
			{ field:"InfLocDesc",title:"��Ⱦ����",width:100,align:'left',sortable:true},
			{ field:"IRInfDate",title:"��Ⱦ����",width:100,align:'left',sortable:true,sorter:Sort_int},
			{ field:"InfPos",title:"��Ⱦ���",width:100,align:'left',sortable:true,showTip:true,tipWidth:200,tipTrackMouse:true,
				formatter: function (value,row,index) {
					var rs = row["ReportStatusCode"];
					var InfPos = row["InfPos"];
					var DiasID = row["DiasID"];
					var InfPosArray = InfPos.split(",");
					var DiasIDArray = DiasID.split(",");
					var InfPosHtml = "";
					for (var i=0; i<InfPosArray.length; i++) {
						if ((rs == 4)||(rs ==5)||(rs == 6)) {
							InfPosHtml += InfPosArray[i];
							if (i !== InfPosArray.length-1) InfPosHtml += '<br>';
						} else {
							InfPosHtml += '<a href="#" onclick=obj.OpenInfPosDialog(\''+row.EpisodeID+'\',\''+DiasIDArray[i]+'\',\''+row.AdmitDate+'\',\''+row.DischDate+'\',\''+rs+'\')>'+InfPosArray[i]+'</a>';
							if (i !== InfPosArray.length-1) InfPosHtml += '<br>';
						}
					}
					return InfPosHtml;
				}
			},
			//��Ӳ�ԭѧ���顢������������ҩ��Ϣ
			{ field:"INFLabDesc",title:"��ԭѧ����",width:100,align:'left',sortable:true,showTip:true,tipWidth:200,tipTrackMouse:true},
			{ field:"INFOPSDesc",title:"������Ϣ",width:100,align:'left',sortable:true,showTip:true,tipWidth:200,tipTrackMouse:true},
			{ field:"INFAntiDesc",title:"������ҩ",width:100,align:'left',sortable:true,showTip:true,tipWidth:200,tipTrackMouse:true},
			
			{ field:"link1",title:"ժҪ",align:'left',width:70,
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.btnAbstractMsg_Click(\''+row.EpisodeID+'\')>'+$g("ժҪ")+'</a>';
				}
			},
			{ field:"link",title:"���Ӳ���",width:100,align:'left',
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.btnEmrRecord_Click(\''+row.EpisodeID+'\')>'+$g("���Ӳ���")+'</a>';
				}
			},
			{ field:"expander",title:"��ͨ��¼",width:100,align:'left',
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.btnMsgSend_Click(\''+row.PatName+'\',\''+row.EpisodeID+'\')>'+$g("��ͨ��¼")+'</a>';
				}
			},
			{ field:"ReportUserDesc",title:"������",width:150,align:'left',sortable:true},
			{ field:"CheckUser",title:"�����",width:100,align:'left',sortable:true},
			{ field:"CheckDate",title:"�������",width:100,align:'left',sortable:true,sorter:Sort_int},
			{ field:"ReturnReason",title:"�˻�ԭ��",width:100,align:'left',sortable:true,showTip:true,tipWidth:100,tipTrackMouse:true}
        ]],
		onDblClickRow:function(rowIndex,rowData){
			$("#gridReport").datagrid('clearSelections');  //ȡ����ʷѡ��
			if(rowIndex>-1){
				obj.ShowResutlDtl(rowData.ReportID,rowData.RepType)	
			}	
        },
        	onSelect:function(rowIndex,rowData){
			obj.rowIndex=rowIndex;
        },
        onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
		}
	});
	InitCtlResultWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
