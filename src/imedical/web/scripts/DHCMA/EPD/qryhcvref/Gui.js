//ҳ��Gui
var objScreen = new Object();

function InitviewScreen(){
	var obj = objScreen;		
    var nowdate = new Date();
    nowdate.setMonth(nowdate.getMonth()-1);
    var y = nowdate.getFullYear();
    var m = nowdate.getMonth()+1;
    var d = nowdate.getDate();
    var formatwdate = y+'-'+m+'-'+d;
    obj.dtStaDate = $('#dtStaDate').datebox('setValue', formatwdate);   // ���ڳ�ʼ��ֵ
    obj.dtEndDate = $('#dtEndDate').datebox('setValue', Common_GetDate(new Date()));
    //��ʼ��ѯ����
    obj.cboHospital = Common_ComboToSSHosp("cboHospital",SSHospCode,"EPD");

   obj.gridHcvQuery = $HUI.datagrid("#HcvQuery",{
		fit: true,
		title:'����ת�鵥��ѯ�б�',
		headerCls:'panel-header-gray',
		iconCls:'icon-apply-check',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		//singleSelect: true,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
			{field:'expander',title:'����',width:45,align:'center',
				formatter: function(value,row,index){
					var ReportID = row["ReportID"];
					var EpisodeID = row["EpisodeID"];					
					var btn = '<a href="#" class="btn_detail" onclick="objScreen.OpenHCVRefReport(\'' + ReportID + '\',\'' + EpisodeID + '\')"></a>';
					return btn;
				}
			}, 
			{field:'RepStatus',title:'����״̬',width:80,align:'center'}, 
			{field:'ReportDate',title:'��������',width:130,align:'center'},
			{field:'RecHospName',title:'����ҽ�ƻ�������',width:150,align:'center'},
			{field:'PatName',title:'����',width:120,align:'center'},
			{field:'PatSex',title:'�Ա�',width:50,align:'center'},
			{field:'PersonalID',title:'���֤��',width:180,align:'center'},
			{field:'DetectionDesc',title:'���ο�����',width:130,align:'center'},
			{field:'ExamPlanDesc',title:'���μ��鷽��',width:130,align:'center'},
			{field:'RefTelPhone',title:'ת�鵥λ��ϵ�绰',width:140,align:'center'},
			{field:'RefDoctor',title:'ת��ҽ��',width:130,align:'center'},
			{field:'RefOrgName',title:'ת�鵥λ',width:200,align:'center'},
			{field:'Resume',title:'��ע',width:150,align:'center',showTip:true}
		]],
		onDblClickRow:function(index, row) {
			if (index>-1) {				
				obj.gridReport_rowdbclick(row);
			}
		},onLoadSuccess:function(data){
			//���سɹ�
			dispalyEasyUILoad(); //����Ч��
		}
	});

	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}