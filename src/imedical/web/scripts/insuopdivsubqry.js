// insuopdivsubqry.js
/**
 *	filename������ҽ��������ϸ��ѯJS
 *	���ܣ�ͨ��ʱ�䣬�ǼǺţ��鵽his����ҽ����Ʊ������Ϣ��ѡ��ĳ�в�������ݣ����س�ҽ����ϸ��Ϣ
 * FileName:insuopdivsubqry.js
 * zyx 2018-03-26
 * �汾��V1.0
 * hisui�汾:0.1.0
 */
 
 var TmpPAPMINo="";
 var StDate="";
 var EndDate="";
 var PAPMINo="";
//�������
$(function(){
	initDocument();

});
//��ʼ������
function initDocument(){
	initHisInv();
	initIndis();
	//�س��¼�
	key_enter();
	RunQuery()
}
function initHisInv(){
    //�������
	$HUI.datagrid("#HisInv",{	
   	 	nowrap: true,
    	striped: true,	
		pagination:true,
		border:false,
		collapsible:true,
		height:400,
		checkOnSelect:false,
		singleSelect: true,   
	 	//fitColumns:true,   //����Ϊ true������Զ��������С�еĳߴ�����Ӧ����Ŀ�Ȳ��ҷ�ֹˮƽ������
	 	selectOnCheck:true,
	 	pagesize:100,
	 	autoRowHeight:true,
	 	cache:true,
	 	loadMsg:'Loading',
	 	rownumbers:true,
	 	scrollbarSize:20,
		toolbar:[],	
		columns:[[
			//��ʼ��his���﷢Ʊ������Ϣ
			{title:'���',field:'Ind',hidden:true},
			{title:'��Ʊid',field:'PrtRowid',hidden:true},
			{title:'�ǼǺ�',field:'PAPMINO',width:180},
			{title:'��������',field:'PAPMIName',width:100},
			{title:'��Ʊ���',field:'PrtAcount',width:100,},
			{title:'��Ʊ����',field:'InvNo',width:120},
			{title:'��Ʊ����',field:'PRTdate',width:120},
			{title:'��Ʊ״̬',field:'InvFlag',width:738},
			{title:'����Dr',field:'PAADMDr',hidden:true},
			{title:'ҽ������Dr',field:'PRTInsDivDR',hidden:true}			
		]]
		
	});
	//��ѯ���
	$HUI.panel("#QueryPanel",{
		collapsible:true,
		headerCls:'panel-header-big' 
	})
	//Ĭ��ʱ��
	setDateBox();
	$("#Find").click=RunQuery;
}
function initIndis(){
	$HUI.datagrid("#InsuDivSub",{
		rownumbers:true,	
	 	nowrap: true,
		striped: true,	
		pagination:true,
		singleSelect:true,
		selectOnCheck:true,
		collapsible:true,
		height:400,
		border:false,
		toolbar:[],
		columns:[[
			//��ʼ��ҽ��������ϸ�������ֶ�
			{title:'���',field:'ind',hidden:true},
			{title:'INDISRowid',field:'INDISRowid',hidden:true},
			{title:'ҽ�������Dr',field:'DivideDr',hidden:true},
			{title:'ҽ����Dr',field:'ArcimDr',hidden:true},
			{title:'�շ���Dr',field:'TarItmDr',hidden:true},
			{title:'ҽ����ĿDr',field:'INSUItmDr',hidden:true},
			{title:'ҽ����ϸDr',field:'OEORIDr',hidden:true},
			{title:'�˵�Dr',field:'PBDr',hidden:true},
			{title:'�˵���ϸDr',field:'PBDDr',hidden:true},
			{title:'ҽ������',field:'INSUCode',width:90},
			{title:'ҽ������',field:'INSUDesc',width:90},
			{title:'ҽ���ȼ�',field:'INSUXMLB',width:90},
			{title:'����',field:'Qty',width:90},
			{title:'�۸�',field:'Price',width:90},
			{title:'���',field:'Amount',width:90},
			{title:'��Ŀ�������',field:'TarCate',width:90},
			{title:'�Ը�����',field:'Scale',width:90},	
			{title:'ͳ��֧��',field:'Fund',width:90},
			{title:'�����Ը�',field:'Self',width:90},
			{title:'�ϴ���־',field:'Flag',width:90},
			{title:'��ϸ���1',field:'Sequence1',width:90},
			{title:'��ϸ���2',field:'Sequence2',width:90},
			{title:'�ϴ�����',field:'Date',width:90},
			{title:'�ϴ�ʱ��',field:'Time',width:90},
			{title:'����ԱDr',field:'UserDr',width:90},
			{title:'�Ƿ�ҽ����־',field:'INSUFlag',width:90},
			{title:'ҽ���޼�',field:'INSUMaxPrice',width:90},
			{title:'Ԥ���ִ�1',field:'Demo1',width:90},
			{title:'Ԥ���ִ�2',field:'Demo2',width:90},
			{title:'Ԥ���ִ�3',field:'Demo3',width:90},
			{title:'Ԥ���ִ�4',field:'Demo4',width:90},
			{title:'Ԥ���ִ�5',field:'Demo5',width:90},
			{title:'�շ���Ŀ����',field:'TARICode',width:90},
			{title:'�շ���Ŀ����',field:'TARIDesc',width:90},
			{title:'ִ�м�¼DR',field:'INDISExecDr',width:90},
			{title:'ʵ���ϴ�����(ҽ��)',field:'INDISUpQty ',width:90},
			{title:'�˷�����',field:'INDISReQty',width:90},
			{title:'���Ľ�����ˮ��',field:'INDISInsuRetSeqNo',width:90},
			{title:'����¼dr$����',field:'INDISPlusLinkNeg',width:90},
			{title:'����(ҽ��)',field:'INDISInsuPrice',width:90},
			{title:'����(ҽ��)',field:'INDISInsuQty',width:90},
			{title:'���(ҽ��)',field:'INDISInsuAmount',width:90},
			{title:'ҽ�����������ֶ�',field:'INDISInsuRetStr',width:90}
	 ]],
	 data:[]		
	});
}
///�س��¼�
function key_enter(){
	$('#PAPMINo').keyup(function(event){
		if(event.keyCode ==13){
			TmpPAPMINo=tkMakeServerCall("web.UDHCJFBaseCommon","regnocon",$('#PAPMINo').val())	//Zhan 20160725,�ǼǺŲ�ȫ
			$("#PAPMINo").val(TmpPAPMINo)
			RunQuery();	
		}
	});	
}

//��ѯhis��Ʊ������Ϣ
function RunQuery(){
	var StDate = getValueById('StDate');
	var EndDate = getValueById('EndDate');
	var PAPMINo = getValueById('PAPMINo'); 
	var rowindex,rowData=""
	//���ú�̨query�������his��Ʊ������Ϣ
	$HUI.datagrid('#HisInv',{
			url:$URL,  
		 	queryParams:{
				ClassName:"web.DHCINSUDivQue",
				QueryName:"findOPDivideSubByPAPMINo",
				StDate:StDate,
				EndDate:EndDate,
				PAPMINo:PAPMINo,
				HospId: session['LOGON.HOSPID']
			}, 
		 	onSelect : function(rowIndex, rowData) {
	    		loadInsDivSubData(rowIndex,rowData); 
	    	 }	
		},false);		
}

//��ѯ��his��Ʊ��Ϣ��ѡ��ĳһ�в����Ӧ��Ʊ��ҽ����ϸ��Ϣ
function loadInsDivSubData(rowIndex,rowData){
	var PRTRowid=rowData.PrtRowid
	//alert("PRTRowid��"+PRTRowid)
	$HUI.datagrid("#InsuDivSub",{
		idField:'Ind', 
			 	url:$URL,  
			 	queryParams:{
					ClassName:"web.DHCINSUDivQue",
					QueryName:"findDivideSubByPrtId",
					PRTRowid:PRTRowid,
				},	
			});
	}
//����
function clear_click() {
	window.location.reload();
}
//Ĭ��ʱ��
function setDateBox() {
	setValueById('StDate',getDefStDate(0));
	setValueById('EndDate',getDefStDate(0));
}


