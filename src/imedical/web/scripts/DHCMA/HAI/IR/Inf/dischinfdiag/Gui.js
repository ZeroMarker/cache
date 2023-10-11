//ҳ��Gui
var obj = new Object();
function InitDischDiagWin(){
	var IsCheckFlag=false;
	//ҽԺ
    $HUI.combobox("#cboHospital",{
		url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospListByLogon&ResultSetType=Array&aLogonHospID='+$.LOGON.HOSPID,
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		onSelect:function(rec){
			obj.cboLocation = Common_ComboToLoc("cboLocation",rec.ID,"","I","E");
		},
		onLoadSuccess:function(data){
			// Ժ��Ĭ��ѡ��
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
	$('#cboLocation').combobox({}); //����������ȳ�ʼ��
	//���ÿ�ʼ����Ϊ����1��
	var date=new Date()
	date.setDate(1);
	var DateFrom=Common_GetDate(date);
	var DateTo=Common_GetDate(new Date());
	Common_SetValue('DateFrom',DateFrom);
    Common_SetValue('DateTo',DateTo);
	//Ĭ����������
    $HUI.combobox("#cboStatus",{
		data:[
			{value:'1',text:'ȷ��'},
			{value:'2',text:'����'},
			{value:'3',text:'�ų�'}
		],
		valueField:'value',
		textField:'text'
	})
	//���
	obj.gridDischDiag = $('#gridDischDiag').datagrid({
        fit:true,
        title:'',
        headerCls:'panel-header-gray',
        iconCls:'icon-resort',
        pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
        rownumbers:true,
        autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
        singleSelect:true,
        nowrap:false,
        loadMsg:'���ݼ�����...',
		pageSize: 20,
		pageList : [20,50,100,200],
		sortOrder:'asc',
		remoteSort:false,
        url:$URL,
        queryParams:{
	        ClassName:'DHCHAI.IRS.INFDiagnosSrv',
	        QueryName:'QryDischInfDiag',
	        aHospIDs:$("#cboHospital").combobox('getValue'),
	        aDateFrom:$("#DateFrom").datebox('getValue'),
	        aDateTo:$("#DateTo").datebox('getValue'),
	        aAdmLoc:$("#cboLocation").combobox('getValue'),
	        aStatus:$("#cboStatus").combobox('getValue'),
	        aMrNo:$("#txtMrNO").val()
	    },
        columns:[[
        	//{field:'checked',checkbox:'true',align:'left',width:'30',auto:false},
	        { field:"MrNo",title:"������",width:100,align:'left',sortable:true},
			{ field:"PatName",title:"����",width:100,align:'left',sortable:true},
			{ field:"Sex",title:"�Ա�",width:50,align:'left',sortable:true},
			{ field:"Age",title:"����",width:70,align:'left',sortable:true},
			{ field:"AdmLocDesc",title:"����",width:150,align:'left',sortable:true},
			{ field:"ActStatus",title:"״̬",width:70,align:'left',sortable:true},
            { field:"link",title:"����",width:150,align:'left',sortable:true,
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.qz(\''+row.EpisodeDr+'\',\''+index+'\')>ȷ��</a>&nbsp;&nbsp;<a href="#" onclick=obj.ys(\''+row.EpisodeDr+'\',\''+index+'\')>����</a>&nbsp;&nbsp;<a href="#" onclick=obj.pc(\''+row.EpisodeDr+'\',\''+index+'\')>�ų�</a>';
				}
			},
			/// InDiagList,MainDiagList,FirstDiagList,OPDiagList
			{ field:"InDiagList",title:"��Ժ���",width:100,align:'left',sortable:true},
			{ field:"InfDiagList",title:"��Ժ��Ⱦ���",width:150,align:'left',sortable:true},
            { field:"link1",title:"ժҪ",width:70,align:'left',
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.btnAbstractMsg_Click(\''+row.EpisodeDr+'\')>ժҪ</a>';
				}
			},
            { field:"link2",title:"���Ӳ���",width:100,align:'left',sortable:true,
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.btnEmrRecord_Click(\''+row.EpisodeDr+'\')>���Ӳ���</a>';
				}
			},
            { field:"link3",title:"��������",width:100,align:'left',
                formatter:function(value,row,index){
                     return '<a href="#" onclick=obj.btnAddQuest_Click(\''+row.EpisodeDr+'\')>��������</a>';
                }
            },
			{ field:"InfPosDesc",title:"Ժ�б������",align:'left',sortable:true,width:100,
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.btnReprot_Click(\''+row.EpisodeDr+'\')>�½�</a>';
				}
			},
			{ field:"DischDate",title:"��Ժ����",width:100,align:'left',sortable:true,sorter:Sort_int},
			
			{ field:"FirstDiagList",title:"�������",width:100,align:'left',sortable:true},
			{ field:"MainDiagList",title:"��Ҫ���",width:100,align:'left',sortable:true},
			{ field:"OPDiagList",title:"�������",width:100,align:'left',sortable:true}
        ]],
		onSelect:function(rowIndex,rowData){
			if(!IsCheckFlag){
				IsCheckFlag = true;
				rowIndexTo=rowIndex;
			}else if(rowIndexTo==rowIndex){
				IsCheckFlag = false;
				$('#gridDischDiag').datagrid("unselectRow",rowIndex);
			}else{
				IsCheckFlag = false;
			}
		}
	});
	
	InitDischDiagWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
$(function () {
	InitDischDiagWin();
});
