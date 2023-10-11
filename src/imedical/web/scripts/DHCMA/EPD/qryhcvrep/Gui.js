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
	//ҽԺ��������
	$HUI.combobox('#cboHospital',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    obj.cboReportLoc = Common_ComboToLoc("cboReportLoc","E|EM","","",HospID);
	    }
    });
	
	$('#cboDateType').combobox({      
		valueField:'Code',    
		textField:'Desc',
		data : [ {
			Code:'IndexReportDate', 
			Desc:'��������',
			"selected":true   
		},{
			Code:'IndexCheckDate', 
			Desc:'�������'
		}]
	});  
	
   obj.gridHcvQuery = $HUI.datagrid("#HcvQuery",{
		fit: true,
		title:"���β�������������ѯ",
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
					console.log(HISUIStyleCode);
					if (HISUIStyleCode=="lite"){
						var btn = '<span class="icon icon-paper" onclick="objScreen.OpenHCVReport(\'' + ReportID + '\',\'' + EpisodeID + '\')"></span>'
					}else{
						var btn = '<a href="#" class="btn_detail" onclick="objScreen.OpenHCVReport(\'' + ReportID + '\',\'' + EpisodeID + '\')"></a>';
					}
					return btn;
				}
			}, 
			{field:'SerialNum',title:'��ˮ��',width:80,align:'center'},
			{field:'StatusDesc',title:'����״̬',width:80,align:'center',
				 styler: function(value,row,index){
					var retStr = "", tmpStatusCode = row["StatusCode"];
					if (tmpStatusCode==1) {
						retStr =  'color:red;';
					} else if (tmpStatusCode==2) {
						retStr = 'color:green;';
					}else if (tmpStatusCode==3) {
						retStr = 'color:black;';
					} else if (tmpStatusCode==4) {
						retStr = 'color:blue;';
					} else if (tmpStatusCode==5) {
						retStr = 'color:gray;';
					} else {
						retStr = 'color:black;';
					} 
					return retStr;
				}
			}, 
			{field:'PapmiNo',title:'�ǼǺ�',width:100},
			{field:'PatientName',title:'����',width:80},
			{field:'PatientSex',title:'�Ա�',width:50,align:'center'},
			{field:'PatientAge',title:'����',width:50},
			{field:'TestPosDate',title:'�״ο���������',width:130},
			{field:'TestMethodDesc',title:'�״ο����ⷽ��',width:130},
			{field:'TestReasonDesc',title:'�״ο�����ԭ��',width:140},
			{field:'ResultsDesc',title:'���帴����',width:110},
			{field:'NucleinRet',title:'���κ�������',width:180},
			{field:'BloodDate',title:'��Ѫ����',width:100},
			{field:'EntryDate',title:'����ֱ��¼������',width:130},
			{field:'ReferResultDesc',title:'ת����',width:170},
			{field:'RepUser',title:'���',width:80},
			{field:'RepDate',title:'�����',width:100},
			{field:'CheckUser',title:'�����',width:80},
			{field:'CheckDate',title:'�������',width:100},
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