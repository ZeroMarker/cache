//insudivdesubqry.js
var GV={
      HOSPID:session["LOGON.HOSPID"]
	};
//�������
$(function(){
	initDocument();

});
function initDocument(){
			//�س��¼�
			key_enter();
			
			//������Ŀ����
			init_XMFL();
			
	        //�������
	        var rowindex,rowData=""
			$HUI.datagrid("#DivSubInfoItem",{	
           	 	nowrap: true,
            	striped: true,	
				pagination:true,
				singleSelect:true,
				fit:true,
				//pagesize:100,
				//collapsible:true,
				//height:400,
				
				columns:[[
					{title:'���',field:'ind',width:70,hidden:true},
					{title:'INDISRowid',field:'INDISRowid',width:70,hidden:true},
					{title:'ҽ�������Dr',field:'DivideDr',width:70,hidden:true},
					{title:'ҽ����Dr',field:'ArcimDr',width:70,hidden:true},
					{title:'�շ���Dr',field:'TarItmDr',width:70,hidden:true},
					{title:'ҽ����ĿDr',field:'INSUItmDr',width:70,hidden:true},
					{title:'ҽ����ϸDr',field:'OEORIDr',width:70,hidden:true},
					{title:'�˵�Dr',field:'PBDr',width:70,hidden:true},
					{title:'�˵���ϸDr',field:'PBDDr',width:70,hidden:true},
					{title:'ҽ������',field:'INSUCode',width:90},
					{title:'ҽ������',field:'INSUDesc',width:150},
					{title:'ҽ���ȼ�',field:'INSUXMLB',width:80},
					{title:'����',field:'Qty',width:60},
					{title:'�۸�',field:'Price',width:60},
					{title:'���',field:'Amount',width:90},
					{title:'סԺ����',field:'TarCate',width:90},
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
					//dividesub�������ֶ�
					{title:'ִ�м�¼DR',field:'INDISExecDr',width:90},
					{title:'ʵ���ϴ�����(ҽ��)',field:'INDISUpQty ',width:90},
					{title:'�˷�����',field:'INDISReQty',width:90},
					{title:'���Ľ�����ˮ��',field:'INDISInsuRetSeqNo',width:90},
					{title:'����¼dr$����',field:'INDISPlusLinkNeg',width:90},
					{title:'����(ҽ��)',field:'INDISInsuPrice',width:90},
					{title:'����(ҽ��)',field:'INDISInsuQty',width:90},
					{title:'���(ҽ��)',field:'INDISInsuAmount',width:90},
					{title:'ҽ�����������ֶ�',field:'INDISInsuRetStr',width:90}
				]]
				
				,
				data:[]
				
				
			});
			$("#Find").click=RunQuery;
	}
///�س��¼�
function key_enter(){
			$('#PBRowId').keyup(function(event){
				if(event.keyCode ==13){
				RunQuery();	
				}
			});
			$('#TarCode').keyup(function(event){
				if(event.keyCode ==13){
				RunQuery();	
				}
			});
			$('#InsuTarCode').keyup(function(event){
				if(event.keyCode ==13){
				RunQuery();	
				}
			});
			$('#DisFlag').keyup(function(event){
				if(event.keyCode ==13){
				RunQuery();
				}
			});
			$('#TarDesc').keyup(function(event){
				if(event.keyCode ==13){
				RunQuery();	
				}
			});
			$('InsuTarDesc').keyup(function(event){
				if(event.keyCode ==13){
				RunQuery();	
				}
			});
			
			$('#PAPMINo').keyup(function(event){
				if(event.keyCode ==13){
					QueryPBRowid();		
				}
			});
}

//������Ŀ����������
function init_XMFL(){

$(function(){
	var cbox = $HUI.combobox("#InsuXMFLQry",{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[
			{id:'1',text:'ȫ����Ŀ'}
			,{id:'2',text:'�Է���Ŀ'}
			,{id:'3',text:'�������Ʒ�����Ŀ'}
			,{id:'4',text:'���޼��Ը���Ŀ'}
		],
		defaultFilter:4
	});
});
}


//��ѯ
function RunQuery(){
	  
		var PBRowId=$('#PBRowId').val();
		var TarCode=$('#TarCode').val();
		var InsuTarCode=$('#InsuTarCode').val();
		var DisFlag=$('#DisFlag').val();
		var TarDesc=$('#TarDesc').val();
		var InsuTarDesc=$('#InsuTarDesc').val();
		var InsuXMFLQryobj=$HUI.combogrid("#InsuXMFLQry")
		var InsuXMFLQry=InsuXMFLQryobj.getValue();
		//���ú�̨query�������
		$HUI.datagrid('#DivSubInfoItem',{
			 	idField:'ind', 
			 	url:$URL,  
			 	queryParams:{
					ClassName:"web.DHCINSUDivQue",
					QueryName:"findDivideSubByPBRowId",
					PBRowId:PBRowId,
					TarCode:TarCode,
					InsuTarCode:InsuTarCode,
					DisFlag:DisFlag,
					TarDesc:TarDesc,
					InsuTarDesc:InsuTarDesc,
					InsuXMFLQry:InsuXMFLQry
				}, 
			 	singleSelect: true,   //
			 	//fitColumns:true,   //����Ϊ true������Զ��������С�еĳߴ�����Ӧ����Ŀ�Ȳ��ҷ�ֹˮƽ������
			 	selectOnCheck:true,
			 	pagesize:100,
			 	autoRowHeight:true,
			 	cache:false,
			 	loadMsg:'Loading',
			 	rownumbers:true,
			 	scrollbarSize:20,
			 	striped:true,
			 	pagination: true,  //��ҳ
			 	
			},false);
}


//���ݵǼǺŲ�����סԺ�˵���Ϣ
function QueryPBRowid(){
	TmpPAPMINo=tkMakeServerCall("web.UDHCJFBaseCommon","regnocon",$('#PAPMINo').val())	//Zhan 20160725,�ǼǺŲ�ȫ
		$("#PAPMINo").val(TmpPAPMINo);
	$HUI.combogrid("#AdmLoc",{
			url:$URL+"?ClassName=web.DHCINSUDivQue&QueryName=searchAdm&RegNO="+$('#PAPMINo').val()+"&HospDr="+GV.HOSPID,
			idField:"TadmLoc",
			textField:"TadmLoc",
			singleSelect:true,
			panelWidth:500,
			columns:[[
				{title:'�������',field:'TadmLoc',width:100},
				{title:'���ﲡ��',field:'TadmWard',width:150},
				{title:'����ʱ��',field:'TadmDate',width:150},
				{title:'��Ժʱ��',field:'TdisDate',width:150},
				{title:'����ID',field:'TadmId',width:50},
				{title:'�˵���',field:'PBRowID',width:50}
					]],
		onClickRow:function(rowIndex, rowData)
		{
			  setValueById('PBRowId',rowData.PBRowID);
			  
		},
		
		
		})
		
	}


//����
function clear_click() {
	window.location.reload();
}

