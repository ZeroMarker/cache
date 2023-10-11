
/**
 * ҽ�����˲�ѯJS
 * FileName:insubalance.js
 * Huang SF 2018-03-12
 * �汾��V1.0
 * hisui�汾:0.1.0
 */
 
 var tabIdArr=[];
 var tabTitleArr=[];
 var iconClsArr=[];
 var PIDStr="";
 var HospDr=session['LOGON.HOSPID']; 
$(function(){
	initData();
	initPanel();
});

//��ʼ�������ص�ǰʱ��
function initData(){
	
	var Now=new Date();
	$('#stdate').datebox('setValue',Now.getFullYear()+"-"+(Now.getMonth()+1)+"-"+Now.getDate());
	$('#endate').datebox('setValue',Now.getFullYear()+"-"+(Now.getMonth()+1)+"-"+Now.getDate());
	var stdate=$('#stdate').datebox('getValue');
	var endate=$('#endate').datebox('getValue');
}


//��ʼ�����
function initPanel(){
	//ҽ�������������
	$HUI.datagrid("#InsuError",{
		fit: true,
		border:false,
		toolbar:[],
		striped: true, //�Ƿ���ʾ������Ч��
		singleSelect: true,
		selectOnCheck: false,
		fitColumns: true,
		autoRowHeight: false,
		showFooter: true,
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		pageSize: 10,
		pageList: [10,20,30,40],
		columns:[[
			{field:'PAPMINO',title:'�ǼǺ�'},
			{field:'PAPMIName',title:'����'},
			{field:'INSUiDate',title:'ҽ��ҵ������'},
			{field:'HISFlag',title:'HIS����״̬'},
			{field:'INSUFlag',title:'ҽ������״̬'},
			{field:'DHCINVPRTDr',title:'INVPRTDr'},
			{field:'INSUDivDr',title:'ҽ�������Dr'},
			{field:'PrtInsDivDr',title:'��Ʊҽ�������Dr'},
			{field:'INSUUser',title:'ҽ������Ա'},
			{field:'INSUAdmType',title:'ҽ�����'},
			{field:'InsuId',title:'ҽ����'},
			{field:'FairType',title:'ҵ������'},
			{field:'INSUAmount',title:'�ܽ��'},
			//{field:'HISiDate',title:'HISҵ������'},
			//{field:'HISUser',title:'HIS����Ա'},
			{field:'AdmDr',title:'�����Dr'},
			
		]],
		data:[]
	});
	
	//Ĭ�ϼ���His��������һ����ͨ�����ǩ
	initTabDatagrid("INVDiv");
}


//�����¼�
function Inquriy(){
	var stdate=$('#stdate').datebox('getValue');
	var endate=$('#endate').datebox('getValue');
	PIDStr=tkMakeServerCall("web.DHCINSUBalance","GetBalanceALLHISOPErrorByDate",stdate,endate,HospDr);
	$HUI.datagrid("#InsuError",{url:$URL+"?ClassName=web.DHCINSUBalance&QueryName=QryBalanceINSUErrorByDate&STDate="+stdate+"&EndDate="+endate+"&HospDr="+HospDr});
	
	//����tab��ǩ
	var tabIdStr=tkMakeServerCall("web.DHCINSUBalance","GetBalanceALLHISOPErrorTabStr",PIDStr)
	if((""!=tabIdStr)&(undefined!=tabIdStr)){tabIdArr=tabIdStr.split("|")};
	var titleTemp="",iconClsTemp="";
	for(var i=0;i<tabIdArr.length;i++){
		switch(tabIdArr[i]){
			case "INVReg":
				titleTemp="�Һ�";
				iconClsTemp="icon-apply-adm";
				break;
			case "INVDiv":
				titleTemp="��ͨ����";
				iconClsTemp="icon-add-note";
				break;
			case "INVPE":
				titleTemp="���";
				iconClsTemp="icon-add-note";
				break;
			case "AccPay":
				titleTemp="���д�ӡ";
				iconClsTemp="icon-copy-drug";
				break;
			case "Mobile":
				titleTemp="�ƶ�֧��";
				iconClsTemp="icon-cancel-order";
				break;
			default:
	    		break;
		}
		tabTitleArr[i]=titleTemp;
		iconClsArr[i]=iconClsTemp;
	}
	
	//��̬����tab
	for(var i=0;i<tabIdArr.length;i++){
		var tabObj=$HUI.tabs("#HisTabs");
		if(!tabObj.exists(tabTitleArr[i])){
			var content="<div class='hisui-layout' fit='true'><table id='"+tabIdArr[i]+"' class='hisui-datagrid'></table></div>"
			tabObj.add({
    			title:tabTitleArr[i],
    			iconCls:iconClsArr[i],
    			closable:false,
    			content:content
			});	
			initTabDatagrid(tabIdArr[i]);
		}
		$HUI.datagrid("#"+tabIdArr[i],{
			url:$URL+"?ClassName=web.DHCINSUBalance&QueryName=QryBalanceHISErrorByDate&Type="+tabIdArr[i]+"&PID="+PIDStr
		});
	}	
	
	//Ĭ��ѡ�е�һ����ǩ
	$HUI.tabs("#HisTabs").select("��ͨ����");
}

//��ʼ����ǩ���datagrid
function initTabDatagrid(id){
	$HUI.datagrid("#"+id,{
		fit:true,
		border:false,
		toolbar:[],
		striped: true, //�Ƿ���ʾ������Ч��
		singleSelect: true,
		selectOnCheck: false,
		fitColumns: true,
		autoRowHeight: false,
		showFooter: true,
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		pageSize: 10,
		pageList: [10,20,30,40],
		columns:[[//PAPMINO,PAPMIName,AdmDr,HISiDate,HISFlag,DHCINVPRTDr,PRTInsDivDR,HISUser,BLLDateRowid,INSUFlag,INSUiDate,INSUUser,INSUAdmType,PID
			{field:'PAPMINO',title:'�ǼǺ�',height:50},
			{field:'PAPMIName',title:'����',height:50},
			{field:'HISiDate',title:'HISҵ������'},
			{field:'HISFlag',title:'HIS����״̬'},
			{field:'INSUFlag',title:'ҽ������״̬'},
			{field:'BLLDataRowid',title:'������Դ��Dr'},
			{field:'PRTInsDivDR',title:'ҽ�������Dr'},
			{field:'HISUser',title:'HIS����Ա'},
			{field:'INSUiDate',title:'ҽ��ҵ������'},
			{field:'INSUUser',title:'ҽ������Ա'},
			{field:'INSUAdmType',title:'ҽ�����'},
			{field:'HISAmount',title:'�ܽ��'},
			{field:'AdmDr',title:'�����Dr',height:50},
			//{field:'DHCINVPRTDr',title:'INVPRTDr'},
			{field:'PID',title:'PID',hidden:true}
		]],
	   data:[]
	});
}