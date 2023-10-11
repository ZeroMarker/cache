//����ȫ�ֱ���
var buyend = "";
var AMRowID = "";
//��ں���
$(function(){
	setPageLayout(); //ҳ�沼�ֳ�ʼ��
	setElementEvent();	//ҳ���¼���ʼ��
});

//ҳ�沼�ֳ�ʼ��
function setPageLayout(){
	initDate(); //��ʼ������
	initType(); //��ʼ��Ʊ������
	initLquser(); //��ʼ����ȡ��
	initInvprtFlag(); //��ʼ����Ʊ��־
	initInvgrantDataGrid(); //��ʼ����Ʊ���Ų�ѯ��ϸ���
	initNumListDataGrid(); //��ʼ���Ŷ��б���
}

//ҳ���¼���ʼ��
function setElementEvent(){
	initImportBtn(); //��ʼ�����뷢Ʊ������Ϣ�¼�
	initSelectBtn(); //��ʼ��ѡ��Ŷ��¼�
	initAddBtn(); //��ʼ����Ʊ�����¼�
	initSerachBtn(); //��ʼ����ѯ��Ʊ������ϸ��Ϣ�¼�
	initSetValue(); //��ʼ���븳ֵ
	initUpdateInvType(); 
}

function initDate(){
	//��ȡ��ǰ����
	var CurrentDate = new Date().getFullYear() + "-" + (new Date().getMonth() + 1) + "-" + new Date().getDate();
	//���ÿ�ʼ����ֵ
	$('#stdate').datebox('setValue', CurrentDate);
	//���ý�������ֵ
	$('#enddate').datebox('setValue', CurrentDate);
}

//Ʊ������������	
function initType(){
	
	$("#type").combobox({
		valueField:'DicCode', 
		textField:'DicDesc',
		panelHeight:"auto",
		url:$URL,
		editable:false,
    	method:"GET",
    	onBeforeLoad:function(param)
    	{
	   		param.ClassName="BILL.EINV.BL.COM.DicDataCtl"
	    	param.QueryName="QueryDicDataInfo"
	   		param.ResultSetType="array"
	 		param.Type="LogicIUDType"          
	    },
	    onLoadSuccess:function(){
		    $('#type').combobox('setValue','PO');
		}
	});
}	


//��ȡ��������
function initLquser(){
	
	/*$HUI.combobox('#lquser', {
		panelHeight: 150,
		url: $URL,
		valueField: 'userID',
		textField: 'userName',
		mode:'remote',
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.EINV.BL.COM.InvPrtGrantCtl";
			param.QueryName = 'QuerySSUserInfo';
			param.ResultSetType = 'array';
			param.KeyWord=$('#lquser').combobox('getValue');
		}
	});*/
	
	//ȡ�շ�Ա��Ϣ
	$HUI.combobox('#lquser', {
		panelHeight: 150,
		url: $URL,
		valueField: 'userID',
		textField: 'userName',
		mode:'remote',
		onBeforeLoad: function (param) {
			param.ClassName = "BILL.EINV.BL.COM.InvPrtGrantCtl";
			param.QueryName = 'QuerySFUserInfo';
			param.ResultSetType = 'array';
			param.Type=$('#type').combobox('getValue');
			param.KeyWord=$('#lquser').combobox('getValue');
		},
	    onLoadSuccess:function(){
		   
		}
	});
}

//��Ʊ��־������	
function initInvprtFlag(){
	
	$HUI.combobox('#invprtFlag',{
		valueField:'code',
		textField:'desc',
		panelHeight:'auto',
		data:[
			{code:'All',desc:'ȫ��',selected:'true'},
			{code:'Y',desc:'����'},
			{code:'N',desc:'������'},
			{code:'',desc:'����'},
			{code:'Confirm',desc:'�Ѻ���'}
		]
	});
}

//��Ʊ���Ų�ѯ��ϸ���	
function initInvgrantDataGrid(){
	
	$('#invgrant').datagrid({
		fit:true,
		border:false,
		pagination:true,    
    	url:$URL,    
    	columns:[[    
        	{field:'Trowid',title:'Trowid',width:100},    
        	{field:'Tdate',title:'����',width:100},    
        	{field:'Ttime',title:'ʱ��',width:100},
        	{field:'Tstartno',title:'��ʼ����',width:100},    
        	{field:'Tendno',title:'��������',width:100},    
        	{field:'Tcurrentno',title:'��ǰ����',width:100}, 
        	{field:'INVBillInvCode',title:'Ʊ�ݴ���',width:100},
        	{field:'Tlquser',title:'��ȡ��',width:100},    
        	{field:'leftinvnum',title:'ʣ������',width:100},    
        	{field:'Tflag',title:'��־',width:100}, 
        	{field:'Ttype',title:'����',width:100},    
        	{field:'TconfirmInvDate',title:'��������',width:100},    
        	{field:'TConfirmInvUser',title:'������',width:100}
    	]]    
	}); 
}

//�Ŷ��б���
function initNumListDataGrid(){
	
	$('#NumList').datagrid({
		fit:true,
		pagination:true,    
    	url:$URL,
    	columns:[[
    		{field: 'TRowID',title: 'TRowID',hidden: true},  
        	{field:'TStartNO',title:'��ʼ����',width:100},    
        	{field:'TEndNO',title:'��������',width:100},    
        	{field:'TCurrentNO',title:'��ǰ����',width:100}, 
        	{field:'finaccode',title:'Ʊ�ݴ���',width:100},
        	{field:'TTitle',title:'��ʼ��ĸ',width:100},    
        	{field:'TBuyer',title:'������',width:100},    
        	{field:'TDate',title:'��������',width:100}
    	]],
    	onDblClickRow:function(index, row){
	    	$('#startno').val(row.TCurrentNO);
	    	//$("#startno").attr("readonly",true);
	    	$('#endno').val(row.TEndNO);
	    	$('#finaccode').val(row.finaccode);
	    	//���˺Ŷ���Ϊ����
	    	var rtn = tkMakeServerCall("web.UDHCJFInvprt","UpdateAmtMagAvail",row.TRowID)
	    	//��ȫ�ֱ���buyend��AMRowID��ֵ
	    	buyend = row.TEndNO;
	    	AMRowID = row.TRowID;
	    	$('#Dialog').dialog('close');
	    }    
	});
}

//���뷢Ʊ������Ϣ
function initImportBtn(){	
	
	$('#importBtn').click(function(){
		var UserDr=session['LOGON.USERID'];
		var GlobalDataFlg="0";                        	 //�Ƿ񱣴浽��ʱglobal�ı�־ 1 ���浽��ʱglobal 0 ���浽����(�����������ͷ�����)
		var ClassName="BILL.EINV.BL.COM.InvPrtGrantCtl"; //���봦������
		var MethodName="ImportInvPrtGrantByExcel";       //���봦������
		var ExtStrPam="";                			     //���ò���()
		ExcelImport(GlobalDataFlg, UserDr, ClassName, MethodName, ExtStrPam);
	});
	
	$('#downloadInv').click(function(){
		downloadEinvInfo();
	});
}

/// ����˵����ͬ����˼��Ʊ�ݵ����ű���
function downloadEinvInfo(){
	//var userId=$('#lquser').combobox('getValue'); //��ȡ��
	//var InputPam=userId+"^^";
	
	var userId=$('#lquser').combobox('getValue'); //��ȡ��	
	if(userId==""){
		//var userId=session['LOGON.USERID'];	
		alert("��ȡ��Ա����Ϊ�գ�");
		return;
	}
	var InvType=$('#type').combobox('getValue'); //Ʊ������
	var InputPam=userId+"^^^"+InvType;
	
	//return 0;
	$.m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"GetBillParagraphNo",
		InputPam:InputPam
		},function(rtn){
			alert(rtn);
			LoadInvPrtGrantList(); //���ط�Ʊ������ϸ�б�
	});	
}

//ѡ��Ŷ�	
function initSelectBtn(){
	
	$('#selectBtn').click(function(){
		var type = $('#type').combobox('getValue'); //Ʊ������
		$('#NumList').datagrid('load',{
			ClassName:'web.UDHCJFInvprt',
			QueryName:'FindInvBuyList',
			type:type,
			hospital:session['LOGON.HOSPID']
		});	
		$('#Dialog').dialog({    
    		title: '�Ŷ��б�',    
   			width: 606,    
    		height: 300,     
    		modal: true    
		});	
	});
}

//�������븳ֵ
function initSetValue(){
	
	$("#invnum").keyup(function(){
		var startno = $.trim($('#startno').val());
		if(startno != ""){
			var invnum = $.trim($('#invnum').val());
			if(invnum != ""){
				$('#endno').val((Array(startno.length).join("0") + (parseInt(invnum)+parseInt(startno,10)-1)).slice(-startno.length)); 
			}
		}
	});
}	

//���ŷ�Ʊ
function initAddBtn(){
	
	$('#addBtn').click(function(){
		var startno = $('#startno').val();
		if($.trim(startno) == ""){
			alert("��ʼ���벻��Ϊ�գ�");
			return
		}
		var lquser = $('#lquser').combobox('getValue'); //��ȡ��
		if(lquser == ""){
			alert("��ȡ��Ա����Ϊ�գ�");
		}else{
			var startno = $('#startno').val(); //��ʼ����
			var endno = $('#endno').val(); //��������
			var type=$("#type").combobox('getValue'); //Ʊ������
			var finaccode = $('#finaccode').val(); //Ʊ�ݴ���
			var InStr=type+"^"+startno+"^"+endno+"^"+lquser+"^"+session['LOGON.HOSPID']+"^"+finaccode;
			var r = confirm("��ȷ��Ҫ���Ŵ�"+startno+"��"+endno+"�ķ�Ʊ��");
			if(r){
				$m({
					ClassName:"BILL.EINV.BL.COM.InvoiceCtl",
					MethodName:"SaveDHcinvoice",
					Str:InStr
				},function(value){
					if(value == 0){
						alert("���ųɹ���");
						var endno = $('#endno').val(); //��������
						var type=$("#type").combobox('getValue'); //Ʊ������
						//����DHC_AMTMAG��ǰ�Ŷ� 
						//����˵����buyend:�����������  AMRowID:DHC_AMTMAG���rowid
						var rtn=tkMakeServerCall("web.UDHCJFInvprt","invupdateByRowID",endno,buyend,type,AMRowID);
						$('#lquser').combobox('setValue',"");
						$('#startno').val("");
						$('#invnum').val("");
						$('#endno').val("");
						LoadInvPrtGrantList();	//���ط�Ʊ������ϸ�б�
					}else{
						alert("�Ŷ��ظ�������ѡ�ŶΣ�")
					}
				});
			}
		}
	});
}

//��ѯ��Ʊ������ϸ��Ϣ
function initSerachBtn(){
	
	$('#serachBtn').click(function(){
		LoadInvPrtGrantList(); //���ط�Ʊ������ϸ�б�
	});	
}	
	
//���ط�Ʊ������ϸ�б�
function LoadInvPrtGrantList(){
	var stdate = $('#stdate').datebox('getValue'); //��ʼ����
	var enddate = $('#enddate').datebox('getValue'); //��������
	var type = $('#type').combobox('getValue'); //Ʊ������
	var invprtFlag = $('#invprtFlag').combobox('getValue'); //��Ʊ��־
	var lquser = $('#lquser').combobox('getText'); //��ȡ��
	$('#invgrant').datagrid('load',{
		ClassName:'web.UDHCJFInvprt',
		QueryName:'InvprtGrantList',
		invprtFlag:invprtFlag,
		type:type,
		stdate:stdate,
		enddate:enddate,
		lquser:lquser
	});	
}


function initUpdateInvType(){
	$('#UpdateInvTypeBtn').click(function(){
		var rows = $('#invgrant').datagrid('getChecked');
		var ID=rows[0].Trowid;
		var InvType=$('#type').combobox('getValue'); //Ʊ������
		
		$.m({
			ClassName:"BILL.EINV.BL.COM.InvoiceCtl",
			MethodName:"UpdateDHCInvoiceById",
			DhcInvoiceId:ID,
			type:InvType,
			HospDr:session['LOGON.HOSPID']
			},function(rtn){
				if(rtn<0){
					alert("����ʧ��")
				}else{
					//alert("���³ɹ�");
					LoadInvPrtGrantList(); //���ط�Ʊ������ϸ�б�
				}
			});	
	});
}