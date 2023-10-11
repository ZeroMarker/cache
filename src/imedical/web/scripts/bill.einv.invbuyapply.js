// ��ں���
$(function(){
	setPageLayout(); //��ʼ��ҳ�沼��
	setElementEvent(); //��ʼ��ҳ��Ԫ���¼�
	initSetValue(); // �������븳ֵ
});

//��ʼ��ҳ�沼��
function setPageLayout(){
	//����״̬������
	$HUI.combobox("#IBAApplyStatus",{
		valueField:'code', 
		textField:'desc',
		panelHeight:"auto",
		data:[
			{code:'All',desc:'ȫ��',selected:true},
			{code:'1',desc:'������'},
			{code:'2',desc:'����ɹ�'},
			{code:'3',desc:'����ʧ��'},
			{code:'9',desc:'��������'}
		],
		onSelect:function(){
			reloadInvBuyApplyView();
		}
	});
	//���״̬������
	$HUI.combobox("#IBAStockStatus",{
		valueField:'code', 
		textField:'desc',
		panelHeight:"auto",
		data:[
			{code:'All',desc:'ȫ��',selected:true},
			{code:'1',desc:'�����'},
			{code:'2',desc:'�����'},
			{code:'9',desc:'�ѳ���'}
		],
		onSelect:function(){
			reloadInvBuyApplyView();
		}
	});
	//������������
	$HUI.combobox('#IBAUsr', {
		url: $URL,
		valueField: 'userID',
		textField: 'userName',
		panelHeight:150,
		mode:'remote',
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.EINV.BL.COM.InvBuyApplyCtl";
			param.QueryName = 'QuerySSUserInfo';
			param.ResultSetType = 'array';
			param.KeyWord=$('#IBAUsr').combobox('getValue');
		},
		onSelect:function(){
			reloadInvBuyApplyView();
		}
	});
	//Ʊ������������
	$HUI.combobox("#invoice_type",{
		valueField:'value', 
		textField:'text'
	});
	//����Ʊ����������������
	$cm({
		ClassName:"BILL.EINV.BL.COM.InvBuyApplyCtl",
		MethodName:"GetEInvTypeList"
	},function(jsonData){
		if(jsonData.status>=0){
			$('#invoice_type').combobox('loadData', jsonData.EinvTypeArr);
			$('#INVBuyType').combobox('loadData', jsonData.EinvTypeArr);
		}
	});
	//��Ʊ��������������
	$('#INVBuyType').combobox({ 
		valueField:'value', 
		textField:'text',
		onLoadSuccess:function(){
			reloadInvBuyApplyView();	
		},
		onSelect:function(){
			reloadInvBuyApplyView();
		}
	});
	//����Ʊ����������б� 
	$('#InvBuyApplyView').datagrid({
		url:$URL,
    	fit:true,
    	border:false,
    	striped:true,
    	singleSelect:true,
    	pagination:true,
    	pageSize:30,
    	pageList:[30,40,50],
    	queryParams: {
			ClassName: 'BILL.EINV.BL.COM.InvBuyApplyCtl',
			QueryName: 'QueryInvBuyApplyInfo'
		},
    	columns:[[ 
    		//{field:"Check",id:"Check",checkbox:true},
        	//{field:'ID',title:'ID',width:100,hidden:true},
        	{field:'ID',title:'ID',width:100},
        	{field:'IBATypeCode',title:'Ʊ���������',width:100,hidden:true},    
    		{field:'IBATypeName',title:'Ʊ����������',width:100},
        	{field:'IBAEBillCount',title:'Ʊ������',width:80},
        	/*
        	{field:'IBAApplyFlag',title:'����Ʊ�������־',width:130,
        		formatter:function(value,row,index){
					if(value=="1"){
						return "������"	
					}else{
						return "������"
					}
				}
        	},*/
        	//{field:'IBAApplyCount',title:'���뵥����',width:100},
        	{field:'IBAStartNo',title:'Ʊ�ݿ�ʼ����',width:100},
        	{field:'IBAEndNo',title:'Ʊ�ݽ�������',width:100},
        	{field:'IBAApplyStatus',title:'����״̬',width:100,
        		formatter:function(value,row,index){
					if(value=="1"){
						return "������"	
					}else if(value=="2"){
						return "����ɹ�"	
					}else if(value=="3"){
						return "����ʧ��"	
					}else if(value=="9"){
						return "��������"	
					}else{
						return "������"
					}
				}
        	},
        	{field:'IBAStockStatus',title:'Ʊ�ݿ��״̬',width:100,
        		formatter:function(value,row,index){
					if(value=="2"){
						return "�����"	
					}else if(value=="9"){
						return "�ѳ���"
					}else{
						return "�����"
					}
				}
        	},
        	{field:'ApplyCommon',title:'���뱸ע',width:200},
        	//{field:'StockApplyCommon',title:'ȡ�����뱸ע',width:200,editor:'text'},
        	{field:'RevokeCommon',title:'ȡ�����뱸ע',width:200,editor:'text'},
        	{field:'IBAUsr',title:'������',width:130}, 
        	{field:'cancelApply',title:'��������',width:100,align:'center'
				,formatter:function(value,row){
					var rtn="";
					if ((row.IBAStockStatus != "2")&&(row.IBAApplyStatus != "9")&&(row.IBAApplyStatus != "2")){
						rtn="<a href='#'  class='DelItnconbtn'><img style='padding-left:0px;'src='../images/icons/undo.png' border=0/></a>";
					}
					return rtn;
				}
			},
        	 {field:'store',title:'���',width:100,align:'center'
				,formatter:function(value,row){
					var rtn="";
					if ((row.IBAStockStatus != "2")&&(row.IBAStockStatus != "9")&&(row.IBAApplyStatus != "9")){
						rtn="<a href='#'  class='DelItnconbtn'><img style='padding-left:0px;'src='../images/icons/redo.png' border=0/></a>";
					}
					return rtn;
				}
			},
			{field:'StockUsr',title:'�����',width:130},
			{field:'StockApplyUsr',title:'ȡ��������',width:130},
        	{field:'IBAApplyNo',title:'���뵥��',width:100},   
        	{field:'IBABusNo',title:'����Ψһ��ˮ��',width:120},
        	{field:'IBAResultCode',title:'��������������',width:130},
        	{field:'IBAResultMeg',title:'��������������',width:130},
        	{field:'IBAInvoiceCode',title:'����Ʊ�ݴ���',width:100},
        	{field:'IBAInvoiceName',title:'����Ʊ������',width:100},
        	{field:'IBAApplyList',title:'�������뵥�б�',width:120},
        	{field:'IBAApplyDate',title:'����ɹ�����',width:100},
        	{field:'IBAApplyTime',title:'����ɹ�ʱ��',width:100},
        	{field:'StockDate',title:'�������',width:100},
        	{field:'StockTime',title:'���ʱ��',width:100},
        	{field:'UpdateDate',title:'���һ�θ�������',width:130},
        	{field:'UpdateTime',title:'���һ�θ���ʱ��',width:130},
        	{field:'StockApplyDate',title:'ȡ������������',width:130},
        	{field:'StockApplyTime',title:'ȡ������ʱ��',width:130}
    	]],
        onLoadSuccess:function(){ 
        	
        	/*
        	var Rows=$('#InvBuyApplyView').datagrid('getRows');
        	var ApplyRecs=new Array()
        	for(n=0;n<Rows.length;n++){
	        	if(Rows[n].IBAApplyStatus=="1"){
		        	ApplyRecs.push(Rows[n]);
		        }
	        }
	        var i=0;
	        var ErrMsg=""
	        SearchApplyResults(ApplyRecs, i, ErrMsg);
	        */
	        GetBuyApplyResult();   //��ѯ��ҳ�� ������ļ�¼�Ľ��
	        
	        //��ѯ�Ƿ��д����״̬������ ����ȡ��ҳ��Ĵ����������Ϣ
	        SearchNotStockData();
		},
		onClickRow:function(index, row){
			//EditRevokeCommonRow(index, row);  //�༭��ע��	
		},
		onClickCell:function(index, field, value){
			var DataRows=$('#InvBuyApplyView').datagrid('getRows');
			var RowData=DataRows[index];
			if(field=="RevokeCommon"){
				EditRevokeCommonCell(RowData,index); //�༭ȡ����ע��
			}
			if(field=="cancelApply"){
	    		cancelInvBuyApply(RowData,index); //���볷��
			}
			if(field=="store"){
	    		SaveInvBuyApply(RowData,index); //���
			}	
		}
	});
}

//��ʼ��ҳ��Ԫ���¼�
function setElementEvent(){
	//���봰��
	$('#AduitBtn').click(function(){
		$('#ApplyCount').val("");  //��������
		$('#ApplyCommon').val(""); //���뱸ע
		$('#startNo').val("");	   //��ʼ����
		$('#endNo').val("");	   //��������
		$('#applyDialog').dialog({
			title:'��������',
			width:575,
			height:300,
			closed:false,
			cache:false,
			modal:true
		});
	});
	//�ύ����
	$('#ApplyBtn').click(function(){
		InvBuyApply();  //Ʊ������
	});
	//��ѯƱ���б�
	$('#SearchBtn').click(function(){
		reloadInvBuyApplyView();  //���¼��������б�
	});
	//������������
	$('#batchCancelBtn').click(function(){
		batchCancelApply(); //������������
	});
}
//���¼��������б�����
function reloadInvBuyApplyView(){
	var INVBuyType=$('#INVBuyType').combobox('getValue');
	var IBAApplyStatus=$('#IBAApplyStatus').combobox('getValue');
	var IBAStockStatus=$('#IBAStockStatus').combobox('getValue');
	var IBAUsr=$('#IBAUsr').combobox('getValue');
	if($.trim($('#IBAUsr').combobox('getText'))==""){
		var IBAUsr="";	
	}
	var InputPam=INVBuyType+"^"+IBAApplyStatus+"^"+IBAStockStatus+"^"+IBAUsr;
	//alert(InputPam)
	$('#InvBuyApplyView').datagrid('load',{
		ClassName:"BILL.EINV.BL.COM.InvBuyApplyCtl",
		QueryName:"QueryInvBuyApplyInfo",
		InputPam:InputPam	
	});
}
//�����ύ
function InvBuyApply(){
	var invoice_type_code=$('#invoice_type').combobox('getValue'); //Ʊ�ݴ���
	var invoice_type_name=$('#invoice_type').combobox('getText');  //Ʊ������
	var ApplyCount=$('#ApplyCount').val();						   //��������
	var startNo=$('#startNo').val();							   //��ʼ����
	var endNo=$('#endNo').val();							   	   //��������
	if(ApplyCount==""){
		alert("������������Ϊ�գ�");
		return	
	}
	var ApplyCommon=$('#ApplyCommon').val();					   //���뱸ע
	// DataInfo="1Ʊ���������^2Ʊ����������^3��������^4��ʼ����^5��������^6������^7��ȫ��^8��½����"
	var DataInfo=invoice_type_code+"^"+invoice_type_name+"^"+ApplyCount+"^"+startNo+"^"+endNo+"^"+UserID+"^"+GroupID+"^"+CtLocID;
	$cm({
		ClassName:"BILL.EINV.BL.COM.InvBuyApplyCtl",
		MethodName:"InvBuyApply",
		DataInfo:DataInfo,
		ApplyCommon:ApplyCommon
	},function(data){
		if(data.status>0){
			//alert("����ɹ���");
			$.messager.alert("����ʾ", "����ɹ���", 'success');
			$('#InvBuyApplyView').datagrid('appendRow',data.ApplyData);
			$('#applyDialog').dialog('close');
		}else{
			alert(data.info);
		}
	});
}
// ���
function SaveInvBuyApply(RowData,index){
	if((RowData.IBAStockStatus != "2")&&(RowData.IBAStockStatus != "9")&&(RowData.IBAApplyStatus != "9")){
		$.messager.confirm('ȷ�϶Ի���', '��ȷ��Ҫ�����', function(r){
			if (r){
				var ID=RowData.ID;
				var InputPam=ID+"^"+UserID+"^"+GroupID+"^"+CtLocID;
				$cm({
					ClassName:"BILL.EINV.BL.COM.InvBuyApplyCtl",
					MethodName:"SaveApplyInvResult",
					InputPam:InputPam
				},function(data){
					if(data.status>0){
						$.messager.alert("����ʾ", "���ɹ���", 'success');
						//$('#InvBuyApplyView').datagrid('load');
						$('#InvBuyApplyView').datagrid('updateRow',{
							index:index,
							row:data.ApplyData
						});			
					}else{
						alert(data.info);	
					}
				});
			}
		});
	}	
}
var EditIndex=undefined;
//�༭ȡ���༭��
function EditRevokeCommonCell(RowData,index){
	if((RowData.IBAStockStatus != "2")&&(RowData.IBAApplyStatus != "9")&&(RowData.IBAApplyStatus != "2")){
		if((EditIndex!=index)&&(EditIndex!=undefined)){   //�Ƚ����༭��ǰ�У��ٿ�ʼ�༭�����У���ֻ֤��һ�д��ڱ༭״̬
			$('#InvBuyApplyView').datagrid('endEdit',EditIndex);
		}
		$('#InvBuyApplyView').datagrid('beginEdit', index);
		EditIndex=index;
		var ed=$('#InvBuyApplyView').datagrid('getEditor',{index:index,field:'RevokeCommon'});
		$(ed.target).focus();
	}else{
		$('#InvBuyApplyView').datagrid('endEdit',EditIndex);	
	}	
}

// ������������
function cancelInvBuyApply(RowData,index){
	if((RowData.IBAStockStatus != "2")&&(RowData.IBAApplyStatus != "9")&&(RowData.IBAApplyStatus != "2")){
		var ed=$('#InvBuyApplyView').datagrid('getEditor',{index:index,field:'RevokeCommon'});
		if(ed == null){
			$.messager.confirm('��ʾ��', '���Ƿ�Ҫ��дȡ�����뱸ע��', function(r){
				if(r){
					$('#InvBuyApplyView').datagrid('beginEdit', index);
					EditIndex=index;
					var ed=$('#InvBuyApplyView').datagrid('getEditor',{index:index,field:'RevokeCommon'});
					$(ed.target).focus();
				}else{
					ConfirmCancelApply(index);	
				}
			});
		}else{
			if(($.trim($(ed.target).val())=="")){
				$.messager.popover({msg: '��û����д��ע��Ϣ��',type:'info',timeout: 2000,showType: 'show'});
				$(ed.target).focus();
				return	
			}
			ConfirmCancelApply(index);
		}
	}
}
/// ȷ���Ƿ�������
function ConfirmCancelApply(index){
	$.messager.confirm('������', '��ȷ��Ҫ����������', function(r){
		if (r){
			var ID=RowData.ID;
			var ed=$('#InvBuyApplyView').datagrid('getEditor',{index:index,field:'RevokeCommon'});
			if(ed!=null){
				var RevokeCommon=$(ed.target).val();
			}else{
				var RevokeCommon="";	
			}
			var InputPam=ID+"^"+UserID+"^"+GroupID+"^"+CtLocID;
			$cm({
				ClassName:"BILL.EINV.BL.COM.InvBuyApplyCtl",
				MethodName:"InvBuyApplyRevoke",
				InputPam:InputPam,
				RevokeCommon:RevokeCommon
			},function(data){
				if(data.status>0){
					//alert("��������ɹ���");
					$.messager.popover({msg: '��������ɹ���',type:'success',timeout: 2000});
					//$('#InvBuyApplyView').datagrid('load');
					$('#InvBuyApplyView').datagrid('updateRow',{
						index:index,
						row:data.ApplyData
					});		
				}else{
					alert(data.info);	
				}
			});	
		}else{
			var ed=$('#InvBuyApplyView').datagrid('getEditor',{index:index,field:'RevokeCommon'});
			$(ed.target).val("");
			$('#InvBuyApplyView').datagrid('endEdit',index);	
		}
	});		
}

/// ����˵������ѯ�������¼�Ľ����Ϣ
function SearchApplyResults(ApplyRecs, i, ErrMsg){
	var nowRec=ApplyRecs[i];   //��ǰ��¼
	var AllLen=ApplyRecs.length;
	var nowRecIndex=$('#InvBuyApplyView').datagrid('getRowIndex', nowRec);
	var ID=nowRec.ID;   //��ǰ�����¼Dr
	var InputPam=ID+"^"+UserID+"^"+GroupID+"^"+CtLocID;
	$cm({
		ClassName:"BILL.EINV.BL.COM.InvBuyApplyCtl",
		MethodName:"SearchBuyApplyResult",
		InputPam:InputPam,
		Index:nowRecIndex
	},function(data){
		if(data.status>0){
			$('#InvBuyApplyView').datagrid('updateRow',{
				index:data.DataIndex,
				row:data.ApplyData
			});
		}else{
			ErrMsg=ErrMsg+";"+data.info;
		}
		
		var nexti=i+1;
		if(nexti<AllLen){
			SearchApplyResults(ApplyRecs, nexti, ErrMsg);   //�ݹ����
		}else{
			if(ErrMsg!=""){
				alert("��ѯ������ʧ�ܣ�"+ErrMsg);
			}
		}
	});	
}
/// ����˵�������������¼��Dr��ȡ���µļ�¼��Ϣ
function GetApplyDataByDr(ApplyRecs, i, ErrMsg){
	
	var nowRec=ApplyRecs[i];   //��ǰ��¼
	var AllLen=ApplyRecs.length;
	var nowRecIndex=$('#InvBuyApplyView').datagrid('getRowIndex', nowRec);
	var ID=nowRec.ID;   //��ǰ�����¼Dr
	$cm({
		ClassName:"BILL.EINV.BL.COM.InvBuyApplyCtl",
		MethodName:"GetApplyDataByDr",
		ApplyDataDr:ID,
		Index:nowRecIndex
	},function(data){
		if(data.status>0){
			$('#InvBuyApplyView').datagrid('updateRow',{
				index:data.DataIndex,
				row:data.ApplyData
			});
		}else{
			ErrMsg=ErrMsg+";"+data.info;
		}
		
		var nexti=i+1;
		if(nexti<AllLen){
			GetApplyDataByDr(ApplyRecs, nexti, ErrMsg);   //�ݹ����
		}else{
			if(ErrMsg!=""){
				alert("��ѯ������ʧ�ܣ�"+ErrMsg);
			}
		}
	});	
}
/// ����˵����ͨ�������������ѯ�Ƿ���ڴ����ļ�¼
function SearchNotStockData(){
	var InputPam=""
	$cm({
		ClassName:"BILL.EINV.BL.COM.InvBuyApplyCtl",
		MethodName:"SearchNotStockData",
		InputPam:InputPam
	},function(data){
		if(data.status>0){
			reloadApplyInfo();	//���¼���ҳ���Ѿ�����ļ�¼
		}
	});	
}
//���¼���ҳ���Ѿ�����ļ�¼
function reloadApplyInfo(){	
    var Rows=$('#InvBuyApplyView').datagrid('getRows');
    var ApplyRecs=new Array()
    for(n=0;n<Rows.length;n++){
        if(Rows[n].IBAApplyStatus=="1"){
	        ApplyRecs.push(Rows[n]);
	    }
   	}
   	if(ApplyRecs.length>0){
   		var i=0;
    	var ErrMsg="";
   		GetApplyDataByDr(ApplyRecs, i, ErrMsg); 	//���������¼��Dr��ȡ���µļ�¼��Ϣ
   	}
}

/// ��ѯҳ����Ϊ������״̬�ļ�¼ �Ƿ��Ѿ�����ͨ�� ��ȡ���뱻�ܾ�
function GetBuyApplyResult(){
    var Rows=$('#InvBuyApplyView').datagrid('getRows');
    var ApplyRecs=new Array()
    for(n=0;n<Rows.length;n++){
        if(Rows[n].IBAApplyStatus=="1"){
	        ApplyRecs.push(Rows[n]);
	     }
    }
    if(ApplyRecs.length > 0){
    	var i=0;
    	var ErrMsg="";
    	SearchApplyResults(ApplyRecs, i, ErrMsg);    //�����ѯ����������״̬
    }
}

/// ������������
function batchCancelApply(){
	var AllRows=$('#InvBuyApplyView').datagrid('getChecked');
	var Rows=new Array();
	for(n=0;n<AllRows.length;n++){
		if((AllRows[n].IBAApplyStatus!="9")&&(AllRows[n].IBAStockStatus!="2")){
			Rows.push(AllRows[n])	
		} 
	}
	var i=0;
	var ErrMsg=""
	var successNum=0;
	var errorNum=0;
	DealCancelApply(Rows,i,ErrMsg,successNum,errorNum); //�������������
}
//�������������
function DealCancelApply(Rows,i,ErrMsg,successNum,errorNum){
	var Row=Rows[i];
	var length=Rows.length;
	var index=$('#InvBuyApplyView').datagrid('getRowIndex', Row);
	var ID=Row.ID;
	var RevokeCommon="";
	var InputPam=ID+"^"+UserID+"^"+GroupID+"^"+CtLocID;
	$cm({
		ClassName:"BILL.EINV.BL.COM.InvBuyApplyCtl",
		MethodName:"InvBuyApplyRevoke",
		InputPam:InputPam,
		RevokeCommon:RevokeCommon
	},function(data){
		if(data.status>0){
			$('#InvBuyApplyView').datagrid('updateRow',{
				index:index,
				row:data.ApplyData
			});	
			successNum=successNum+1;	
		}else{
			ErrMsg=ErrMsg+";"+data.info;
			errorNum=errorNum+1;	
		}
		var nexti=i+1;
		if(nexti<length){
			DealCancelApply(Rows,nexti,ErrMsg,successNum,errorNum); //���õݹ�
		}else{
			if(ErrMsg!=""){
				$.messager.popover({
					msg: '��������ʧ�ܣ�'+ErrMsg,
					type:'error',
					style:{
						bottom:-document.body.scrollTop - document.documentElement.scrollTop+10, //��ʾ�����½�
						right:10
					}
				});
			}
			$.messager.popover({msg: '�����������룬�ɹ���'+successNum+'����ʧ�ܣ�'+errorNum+'����',type:'info',timeout: 3000,showType: 'show'});	
		}
	});	
}
function initSetValue(){
	//�������븳ֵ
	$("#ApplyCount").keyup(function(){
		var startNo = $('#startNo').val();
		if(startNo != ""){
			var ApplyCount = $('#ApplyCount').val();
			if(ApplyCount != ""){
				$('#endNo').val((Array(startNo.length).join("0") + (parseInt(ApplyCount)+parseInt(startNo,10)-1)).slice(-startNo.length)); 
			}
		}
	});
	$("#ApplyCount").bind('input propertychange',function(){
		var ApplyCount = $('#ApplyCount').val();
		if(ApplyCount == ""){
			$('#startNo').val("");
			$('#endNo').val("");	
		}
	});
}
