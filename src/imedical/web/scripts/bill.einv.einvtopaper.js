<!--js  bill.einv.einvtopaper.js -->
<!-- ��ں��� -->


var UserID = session['LOGON.USERID'];
var Hospital = session['LOGON.HOSPID'];
var Group=session['LOGON.GROUPID']
var Loc=session['LOGON.CTLOCID']
/*���ò�˼��ӡ�ӿڣ���ʼ����ӡ���
var jj = new BsIndustryApi ({
		'appId': 'NXYKDXZYY7954090',
		'appKey': '60128aa31681a47725ccf8bf56',
		'type': 'medical',
		'url': 'http://10.0.11.94:7001/medical-web'});



var jj = new BsIndustryApi({'appId':'CDYXYDYFSYY2256028',
    'appKey':'97a85ceaae9a5da0536c6dce7d',
    'type':'medical',
    'url':'http://172.16.50.88:7001/medical-web/'});
    
    
 var industry = new BsIndustryApi({'appId':'CDYXYDYFSYY2256028',
        'appKey':'97a85ceaae9a5da0536c6dce7d',
        'type':'medical',
        'url':'http://172.16.50.88:7001/medical-web/'});
        */

$(function(){
	setPageLayout();
	setElementEvent();
	//GetStockBillNo("");
	//FindData();	    //��ѯ
});

function setPageLayout(){
	//����Ʊ���ϴ���Ϣ��ѯ
	SetPatInfoItem();
}
function setElementEvent(){
	//���Ͽհ�ֽ��Ʊ��
	$('#blankBtn').click(function(){
	     invalidBlank();
	     //altVoidInv();
	});
	//ԭ�Ų���
	//$('#clsBtn').hide()
	$('#clsBtn').click(function(){
		PrintOnly();
	});
	
	//���»���ֽ��Ʊ��
	$('#queryBtn').click(function(){
		reTurnPaper();
	});
	//����ֽ��Ʊ��
	$('#exBtn').click(function(){
		TurnPaper();
	});
	//����
	$('#ReadCard').click(function(){
		
	});
	//����
	$('#Clear').click(function(){
		Clear();
	});
	//��ѯ
	$('#Find').click(function(){
		//��ѯ�ϴ��ɹ��ĵ��ӷ�Ʊ��Ϣ
		FindData();
		});
		
	//add by xubaobao 2020 09 08
	//��������Ʊ��(�����ϵ���������Ʊ��,Ȼ�����¿�����Ʊ)
	$('#ReTurnEPaperBtn').click(function(){
		ReTurnEPaper();
	});
}

///+dongkf 2020 03 02 start
var ALLINVTypeArr=[];
var CountNum=0;           //����


function ReloadEinvTypeCombox(){
	var AdmLogicType=$('#AdmType').combobox('getValue');
	var baseInvLen=ALLINVTypeArr.length;
	if((AdmLogicType=="")||(baseInvLen==0)){
		CountNum=CountNum+1;
		if(CountNum<3){
			setTimeout("ReloadEinvTypeCombox()","100");
		}else{
			return 0;
		}
	}else{
		var AdmInvTypeArr=[];
		var objTmp=null;
		var AdmTypeTmp="";
		var DefaultVal="";
		var DicCodeTmp="";
		var DicDemoTmp="";
		var AdmTypesTmp="";
		var AdmTypeArr="";
		for (index=0; index<ALLINVTypeArr.length; index++){
			objTmp=ALLINVTypeArr[index];
			AdmTypesTmp=objTmp.DicBill1;
			AdmTypeArr=AdmTypesTmp.split(',');
			if(AdmTypeArr.indexOf(AdmLogicType)!=-1){
			//if(objTmp.DicBill1==AdmLogicType){
				AdmInvTypeArr.push(objTmp);
				
				DicCodeTmp=objTmp.DicCode;     //�ֵ����
				DicDemoTmp=objTmp.DicDemo;     //��ע  �����1 ����Ĭ��ֵ
				if(DefaultVal==""){  //Ĭ�ϵ�һ��ΪĬ��ѡ��
					DefaultVal=DicCodeTmp;
				}
				if(DicDemoTmp=="1"){  //�����õ�ʱ�� ��������ѡ������Ĭ��ֵ
					DefaultVal=DicCodeTmp;
				}
			}
		}
		if(AdmInvTypeArr.length>0){
			$('#IUDPayAdmType').combobox('loadData', AdmInvTypeArr);   //���� ҵ���������� Ʊ������������
			$('#IUDPayAdmType').combobox('setValue',DefaultVal);       //����Ĭ��ѡ��
		}
	}
}
/// ============end================

//����Ʊ���ϴ���Ϣ��ѯ
function SetPatInfoItem(){
	//��ȡ��ǰ����
	var nowDate = new Date().getFullYear() + "-" + (new Date().getMonth() + 1) + "-" + new Date().getDate();
	//���ÿ�ʼ����ֵ
	$('#stDate').datebox('setValue', nowDate);
	//���ý�������ֵ
	$('#edDate').datebox('setValue', nowDate);
	///���ؾ�������������
	$HUI.combobox('#AdmType',{
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
	    	param.ResultSetType="array";
	    	param.Type="BusinessType"          
	    }
	    ,onLoadSuccess:function(){
		    $('#AdmType').combobox('setValue','OP');
		 }
	    ,onChange:function(){
			//setIUDPayAdmType();
			//ReloadEinvTypeCombox();
			CountNum=0;
			setTimeout("ReloadEinvTypeCombox()","100");
		} 
	});
	
	
	///���ز���Ա������ modify 2020-5-21 ZhaoZW
	$HUI.combobox('#operator',{
		panelHeight: 150,
		url: $URL,
		valueField: 'userID',
		textField: 'userName',
		mode:'remote',
    	onBeforeLoad:function(param)
    	{
	    	param.ClassName = "BILL.EINV.BL.COM.InvPrtGrantCtl";
			param.QueryName = 'QuerySSUserInfo';
			param.ResultSetType = 'array';
			param.KeyWord=$('#operator').combobox('getValue');
	    }   
	});
	//�վ�����
	$HUI.combobox('#IUDPayAdmType',{
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
	    	param.ResultSetType="array";
	    	param.Type="LogicIUDType"          
	    }//
	    ,onLoadSuccess:function(){
			var objTmp=null;
			var rows=$('#IUDPayAdmType').combobox('getData');
			if(rows.length>ALLINVTypeArr.length){
				for(i=0; i<rows.length; i++){
					objTmp=rows[i];
					ALLINVTypeArr.push(objTmp);
				}
				$('#IUDPayAdmType').combobox('setValue','PO');
			} 
		}
	    ,onChange:function(){
			GetStockBillNo("");    //Ʊ�ݺ����ѯ
		}
	});	
	
	//������
	$HUI.combobox('#CardType',{
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
	    	param.ResultSetType="array";
	    	param.Type="CardType"          
	    }
	     
	});
	$('#DataList').datagrid({
		fit:true,
		pagination:true,
		pageSize:20,
		pageList:[20,40,60],
		singleSelect:true,
		//singleSelect:false,
		selectOnCheck:false,
		checkOnSelect:false,
		striped:true,
		rownumbers:false,
		fit:true,
		url:$URL,
		columns:[[
			{field:'ind',title:'���'},
			{field:'checkbox',checkbox:true},
			{field:'PatNo',title:'�ǼǺ�',width:100},
			{field:'PatName',title:'����',width:100},
			{field:'IUDPayAdmType',title:'��������',width:50,
			formatter: function(value){
					if(value == "OP"){
						return '����'
					}
					if(value == "IP"){
						return 'סԺ'	
					}
					if(value == "C"){
						return 'ͨ��'	
					}
				}
        	},
			{field:'IUDCreatAmt',title:'Ʊ�ݽ��',width:100},
			{field:'IUDBillBatchCode',title:'Ʊ�ݴ���',width:100},
			{field:'IUDBillBatchNo',title:'Ʊ�ݺ���',width:100},
			//{field:'IUDBillBatchCode1',title:'ֽ��Ʊ�ݴ���',width:100},
			//{field:'IUDBillBatchNo1',title:'ֽ��Ʊ�ݺ���',width:100},
			{field:'USRName',title:'�ϴ���',width:100},
			{field:'IUDDate',title:'�ϴ�����',width:100},
			{field:'IUDTime',title:'�ϴ�����',width:100},
			{field:'IUDVoucherBatchCode',title:'Ԥ����Ʊ�ݴ���',width:100,hidden:true},
			{field:'IUDVoucherNo',title:'Ԥ����Ʊ�ݺ���',width:100,hidden:true},
			{field:'IUDCreatDate',title:'��������',width:100},
			{field:'IUDPrintType',title:'Ʊ��ģʽ',width:80},
			{field:'RateStatus',title:'ֽ������״̬',width:100},
			{field:'IUDInvDr',title:'��Ʊ��ID',width:100},
			{field:'IUDInitRowID',title:'ԭ��Ʊ��ID',width:100},
			{field:'IUDBillisScarlet',title:'�Ƿ��ѿ���Ʊ ',width:100},
			{field:'IUDBillBatchStatus',title:'����Ʊ��״̬ ',width:100}
		]],
		onBeforeLoad:function(param){
			param.rows='20';
		}
	});
}		
///���Ͽհ�ֽ��Ʊ��	
function invalidBlank()
{
	var receiptType=$('#AdmType').combobox('getValue');
	var voucherType=$('#IUDPayAdmType').combobox('getValue');
	//window.location.href="bill.einv.validblankpaper.csp"
	
	//����HIs�շѽ������Ž���
	window.open ("bill.einv.validblankpaper.csp", "newwindow", "height=400, width=620, top=200, left=400, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no")
	
	/*
	var iHeight = 400;
	var iWidth = 620;
	var iTop = (window.screen.availHeight - 30 - iHeight) / 2; //��ô��ڵĴ�ֱλ��
	var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;  //��ô��ڵ�ˮƽλ��
    var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=bill.einv.validblankpaper.csp&CurrentInsType=" + voucherType + "&receiptType=" + receiptType;
   	websys_createWindow(lnk, '_blank', "toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,top="+iTop+",left="+iLeft+",width="+iWidth+",height="+iHeight);
	*/
	//altVoidInv();	
	GetStockBillNo("");		//add by xubaobao 2020 08 13 ����Ʊ��
}

///����
function ReadCard(){}



function FindData()
{
	var IUDStDate = $('#stDate').datebox('getValue');
	var IUDEdDate = $('#edDate').datebox('getValue');
	var AdmType= $('#AdmType').combobox('getValue')
	var InvNO=$('#IUDPrtNo').val();
	var UserID=$('#operator').combobox('getValue');
	var RegNo=$('#rmarkNo').val();
	var queryParam={
		ClassName:'BILL.EINV.BL.COM.InvPageInfoCtl',
		QueryName:'QueryBillIUDInfo',
        IUDStDate:IUDStDate,
		IUDEdDate:IUDEdDate,
		IUDAdmType:AdmType,
		InvNo:InvNO,
		UserId:UserID,
		RegNo:RegNo
	}
	$('#DataList').datagrid({
		url:$URL,
		queryParams:queryParam
	})	
	$('#DataList').datagrid('load')
	}

// ԭ�Ŵ�ӡ
function PrintOnly(){
	var rows = $('#DataList').datagrid('getChecked');
	if (rows.length !=1) {
		$.messager.alert("��ʾ","��ѡ��һ�����ݣ�");
		return;
	}
	
	if(rows[0].PrintType =="E"){
		$.messager.alert("��ʾ","����Ʊ�ݲ���ԭ�Ŵ�ӡ��");
		return;
	}
	
	var pBillBatchCode=rows[0].IUDBillBatchCode;
	var pBillNo= rows[0].IUDBillBatchNo;
	if((pBillBatchCode=="")||(pBillNo=="")){
		$.messager.alert("��ʾ","Ʊ�ݴ��롢Ʊ�ݺ��벻��Ϊ��!");
		return;
	}
	
	var PayAdmType=rows[0].IUDPayAdmType;
	PrintBtnBS(pBillBatchCode,pBillNo, PayAdmType)      //���ò�˼��ӡ
	
}

///����ֽ��Ʊ��
function TurnPaper()
{
	var rows = $('#DataList').datagrid('getChecked');
	var pBillBatchCode= $("#IUDBillBatchNo").val();
	var pBillNo= $("#PresentNo").val();
	if((pBillBatchCode=="")||(pBillNo=="")){
		$.messager.alert("��ʾ","����ֽ��Ʊ��ʱ,Ʊ�Ŵ����뵱ǰ����Ʊ�Ų���Ϊ��.");
		return;
	}
	var ErrInfo=$('#ErrMsgInfo').text()
	if(ErrInfo=="��������ǰƱ�Ż�ȡʧ��"){
		$.messager.alert("��ʾ","����ֽ��Ʊ��ʱ,��������ǰƱ�Ż�ȡʧ��.");
		return;
	}
	
	if(parseInt(ErrInfo)>parseInt(pBillNo)){
		$.messager.alert("��ʾ","����ֽ��Ʊ��ʱ,��������ǰƱ�Ŵ���HIS��ǰƱ�Ų�������.");
		return;
	}
	if(rows != ""){
		if(rows.RateStatus=="1"){
			$.messager.alert("��ʾ","��Ʊ���Ѿ���ֽ��Ʊ�ݣ������ڻ���ֽ��Ʊ��");
			return;
		}
		var PayAdmType=rows[0].IUDPayAdmType;
		var HISPrtRowID=rows[0].IUDInvDr;
		var OrgHISPrtRowID=rows[0].IUDInitRowID;
		var PathCode="PrintPaper";
		var ExpStr=UserID+"^"+Group+"^"+Loc+"^"+Hospital+"^"+pBillBatchCode+"^"+pBillNo;
		var prtRowIdStr=HISPrtRowID+"#"+"R";      //suihuide
		alert(PayAdmType+"^"+HISPrtRowID+"^"+OrgHISPrtRowID)
		alert(ExpStr)
		//return;
		$m({
			ClassName:"BILL.EINV.BL.EInvoiceLogic",
			MethodName:"InvocieBill",
			PayAdmType:PayAdmType,
			HISPrtRowID:HISPrtRowID,
			OrgHISPrtRowID:OrgHISPrtRowID,
			PathCode:PathCode,
			ExpStr:ExpStr
		},function(rtn){
			if(rtn.split("^")[0] != "0"){
				$.messager.alert("��ʾ","��Ʊ�ݻ���ʧ��,����ԭ��:"+rtn.split("^")[1]);
			}else{
				$.messager.alert("��ʾ","��Ʊ�ݻ����ɹ�");
				$('#DataList').datagrid('load');
				GetStockBillNo("");           //���»�ȡ��ǰƱ��
				//patInvPrint(PayAdmType, prtRowIdStr);				//his�Լ���ӡ��Ʊ(���Ϊҵ�����ͺͷ�Ʊ��)
				PrintBtnBS(pBillBatchCode,pBillNo, PayAdmType)      //���ò�˼��ӡ
			}
		});
	}
}


///���»���ֽ��Ʊ��
function reTurnPaper()
{
	var rows = $('#DataList').datagrid('getChecked');
	var pBillBatchCode= $("#IUDBillBatchNo").val();
	var pBillNo= $("#PresentNo").val();
	if((pBillBatchCode=="")||(pBillNo=="")){
		$.messager.alert("��ʾ","����ֽ��Ʊ��ʱ,Ʊ�Ŵ����뵱ǰ����Ʊ�Ų���Ϊ��.");
		return;
	}
	var ErrInfo=$('#ErrMsgInfo').text()
	if(ErrInfo=="��������ǰƱ�Ż�ȡʧ��"){
		$.messager.alert("��ʾ","����ֽ��Ʊ��ʱ,��������ǰƱ�Ż�ȡʧ��.");
		return;
	}
	
	if(parseInt(ErrInfo)>parseInt(pBillNo)){
		$.messager.alert("��ʾ","����ֽ��Ʊ��ʱ,��������ǰƱ�Ŵ���HIS��ǰƱ�Ų�������.");
		return;
	}
	if(rows != ""){
		var PayAdmType=rows[0].IUDPayAdmType;
		var HISPrtRowID=rows[0].IUDInvDr;
		var OrgHISPrtRowID=rows[0].IUDInitRowID;
		var PathCode="RePrintPaper";
		var ExpStr=UserID+"^"+Group+"^"+Loc+"^"+Hospital+"^"+pBillBatchCode+"^"+pBillNo;
		var prtRowIdStr=HISPrtRowID+"#"+"R";      //suihuide
		//alert(PayAdmType+"^"+HISPrtRowID+"^"+OrgHISPrtRowID)
		//alert(ExpStr)
		//return;
		$m({
			ClassName:"BILL.EINV.BL.EInvoiceLogic",
			MethodName:"InvocieBill",
			PayAdmType:PayAdmType,
			HISPrtRowID:HISPrtRowID,
			OrgHISPrtRowID:OrgHISPrtRowID,
			PathCode:PathCode,
			ExpStr:ExpStr
		},function(rtn){
			if(rtn.split("^")[0] != "0"){
				$.messager.alert("��ʾ","��Ʊ�ݻ���ʧ��,����ԭ��:"+rtn.split("^")[1]);
			}else{
				$.messager.alert("��ʾ","��Ʊ�ݻ����ɹ�");
				$('#DataList').datagrid('load');
				//UpDateDHCInvoice()         //�����ɹ��󣬸��·�Ʊ���ű�  //-dongkf 2020 01 03 ��̨�Ļ���ҵ����ִ�����ߺŷ������������ﲻ��Ҫ���ߺ�
				GetStockBillNo("");          //���»�ȡ��ǰƱ��
				
				//patInvPrint(PayAdmType, prtRowIdStr);			//��ӡ��Ʊ����������HIs�Լ���Ʊģ���ӡ
				PrintBtnBS(pBillBatchCode,pBillNo, PayAdmType)      //���ò�˼��ӡ
			}
		});
	}
	
}


///��ȡ������(��˼)��ǰƱ�ţ����������ֿ�סԺ�����
/// add by xubaobao 2021 06 11 ��LogicIUDType--> BillBatchNo
function GetStockBillNoBSOld(BillBatchNo){
	var InputPam=UserID+"^"+BillBatchNo;
	$.m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"GetStockBillNo",
		InputPam:InputPam,
		PathCode:"PaperNo"
		},function(rtn){
			if (rtn==""){
	        	$('#ErrMsgInfo').text("��������ǰƱ�Ż�ȡʧ��");
			}else{
				$('#ErrMsgInfo').text(rtn.split("^")[1]);
			}
	       
	});		
	
}


///��ȡ������(��˼)��ǰƱ�ţ����ڲ�����������סԺ��
function GetStockBillNoBS(BillBatchNo,EndInv){
	var InputPam=UserID+"^^"+BillBatchNo+"^"+EndInv;
	$.m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"GetCurBillNoByEndInv",
		InputPam:InputPam,
		},function(rtn){
			if (rtn==""){
	        	$('#ErrMsgInfo').text("��������ǰƱ�Ż�ȡʧ��");
			}else{
				$('#ErrMsgInfo').text(rtn);
			}
	       
	});		
	
}

///��ȡ��ǰƱ��(���ű��ȡ��ǰƱ��)
///w ##class(web.udhcOPBillIF).GetreceipNO("dddddd","","639^Y")
function GetStockBillNo(LogicIUDType){
	if (LogicIUDType==""){
		var LogicIUDType=$('#IUDPayAdmType').combobox('getValue');
	}
	
	$('#ErrMsgInfo').empty();           //������Ϣ���
	$("#IUDBillBatchNo").val("");       //Ʊ�ݴ���
	$("#PresentNo").val("");            //Ʊ�ݺ���
	
	
	///����Ա^Ʊ������^��ȫ��^�ѱ�^Ժ��
	var AdmReasonId=""
	var OutMsg=""
	var InputPam=UserID+"^"+LogicIUDType+"^"+Group+"^"+AdmReasonId+"^"+Hospital;	 
	 $.m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"GetPaperBillNo",
		InputData:InputPam,
		OutMsg:OutMsg
		},function(rtn){
			if(rtn.split("^")[0]<0){
	        	$('#ErrMsgInfo').text(rtn.split("^")[1]);
	        }else{
		        $('#ErrMsgInfo').empty();
		        $("#IUDBillBatchNo").val(rtn.split("^")[3]);  
		        $("#PresentNo").val(rtn.split("^")[0]);  
		        
		        GetStockBillNoBSOld(rtn.split("^")[3]);  //(ֽ��Ʊ����������סԺ����ʱ)
		        
		        //GetStockBillNoBS(rtn.split("^")[3],rtn.split("^")[2]);		//add by xubaobao 2020 09 07 ��ȡ��������ǰƱ��(ֽ��Ʊ�ݲ���������סԺ����ʱ)
	   		}
	  });		
	
}

function setIUDPayAdmType(){
	var DicCode=$('#AdmType').combobox('getValue');
	$.m({
		ClassName:"BILL.EINV.COM.Common",
		MethodName:"GetEINVDicByCodeAndInd",
		DicType:"AdmType",
		DicCode:DicCode,
		ind:"5"
		},function(rtn){
			//$('#IUDPayAdmType').combobox('setValue',rtn);   �������������͡�Ʊ������Code��һ��
			GetStockBillNo(rtn);		 
	});	
}
///����
function Clear(){
	$('#stDate').datebox('setValue',"");
	$('#edDate').datebox('setValue',"");
	$('#AdmType').combobox('setValue',"");
	$('#operator').combobox('setValue',"");
	$("#rmarkNo").val("")
	//FindData();
	
}
///�����ɹ�����·�Ʊ���ű�
function UpDateDHCInvoice()
{
	/*
	if (LogicIUDType==""){
		var LogicIUDType=$('#IUDPayAdmType').combobox('getValue');
	}
	*/
	var LogicIUDType=$('#IUDPayAdmType').combobox('getValue');
	
	var PresentNo=$("#PresentNo").val()
	var InputPam=UserID+"^"+PresentNo+"^"+LogicIUDType
	$.m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"UpDateDHCINvoice",
		InputPam:InputPam
		},function(rtn){
        if (rtn=="0")
        {   
        	setIUDPayAdmType()         //���»�ȡ��ǰƱ��
	    }else 
	    {
		   $.messager.show({title:'��ʾ',msg:'���·�Ʊ���ű�ʧ�ܣ�',timeout:1000,showType:'slide'});
		  }
	});	
	
}

///his��Ʊ��ӡ(���������סԺ)
function patInvPrint(PayAdmType, prtRowIdStr)
{
	try{
		if (PayAdmType == ""){
			$.messager.alert("��ʾ","���߾�������Ϊ��,��˲�.");
			return;
		}
		
		if ((PayAdmType == "OP")||(PayAdmType == "REG")){
			OPPatInvPrint(prtRowIdStr);				//���﷢Ʊ��ӡ
		}else if(PayAdmType == "IP"){
			IPPatInvPrint(prtRowIdStr);				//סԺ��Ʊ��ӡ
		}
		
	}catch (e) {
		$.messager.alert("��ӡ�쳣:" + e.message);
	}
	
}

///��ӡֽ�ʷ�Ʊ--���ò�˼��ӡ�ӿ�
function PrintBtnBS(pBillBatchCode,pBillNo, PayAdmType)
{
	
	if ((pBillBatchCode=="")||(pBillNo=="")){
		
	var rows = $('#DataList').datagrid('getChecked');
	pBillBatchCode=rows[0].IUDBillBatchCode ;                      // $("#IUDBillBatchNo").val();
    pBillNo=rows[0].IUDBillBatchNo;                                 //$("#PresentNo").val();
	PayAdmType=rows[0].IUDPayAdmType;	
	}
	/*
    alert("��ӡֽ��Ʊ��="+pBillBatchCode+"^"+pBillNo);
    var param = {
		'pBillBatchCode':pBillBatchCode,
		'pBillNo':pBillNo  
		//,'pBillCode': '4014'
	}
	    //alert(pBillBatchCode+"^"+pBillNo); printPaperBill
		industry.jsRequest('printPaperBill', '1.0', param).then(function (data) {
            if(data&&data.result!='S0000'){
	            alert("��ӡ�ɹ�");
            }
            console.log("success");
        }).fail(function (data) {
            console.log( data);
        }); 
        //GetStockBillNo(""); 
        */
        
        /*
        var param = {
            'pBillBatchCode': pBillBatchCode,
            'pBillNo': pBillNo,
            'pBillCode': '4014'
        }
        industry.printPaperBill(param, '1.0', false).then(function (data) {
            if(data&&data.result!='S0000'){
                alert(data.message)
            }
            console.log("success")
        }).fail(function (data) {
            console.log( data)
        });
        */
        
        var pBillCode="";
        if (PayAdmType == "OP"){
	        pBillCode="4014";
        }
        
        if (PayAdmType == "IP"){
	        pBillCode="4015";
        }
       
        var param = {
            'pBillBatchCode': pBillBatchCode,
            'pBillNo': pBillNo,
            'pBillCode': pBillCode
        }
        industry.printPaperBill(param, '1.0', true).then(function (data) {
            if(data&&data.result!='S0000'){
                alert(data.message)
            }
            //console.log("success")
        }).fail(function (data) {
            console.log( data)
        });
      
		
}


/// ��������Ʊ
/// add by xubaobao 2020 09 08 
function ReTurnEPaper()
{
	var rows = $('#DataList').datagrid('getChecked');
	if(rows != ""){
		if(rows.RateStatus=="1"){
			$.messager.alert("��ʾ","��Ʊ����ֽ��Ʊ�ݣ���ѡ�����Ʊ�ݽ��е���Ʊ�ݻ���");
			return;
		}
		
		//������������
		var PayAdmType=rows[0].IUDPayAdmType;
		var HISPrtRowID=rows[0].IUDInvDr;
		var OrgHISPrtRowID=rows[0].IUDInitRowID;
		var PathCode="InvalidInvSvr";
		var ExpStr="";    
		$m({
			ClassName:"BILL.EINV.BL.EInvoiceLogic",
			MethodName:"InvocieBill",
			PayAdmType:PayAdmType,
			HISPrtRowID:HISPrtRowID,
			OrgHISPrtRowID:OrgHISPrtRowID,
			PathCode:PathCode,
			ExpStr:ExpStr
		},function(rtn){
			if(rtn.split("^")[0] != "0"){
				$.messager.alert("��ʾ","��Ʊ�ݳ��ʧ��,����ԭ��:"+rtn.split("^")[1]);
			}else{
				InvocieBill(PayAdmType,HISPrtRowID)
			}
		});
	}
}

/// ������Ʊ
/// add by xubaobao 2020 09 08 
function InvocieBill(PayAdmType,HISPrtRowID){
	
	$m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"InvocieBill",
		PayAdmType:PayAdmType,
		HISPrtRowID:HISPrtRowID,
		OrgHISPrtRowID:"",
		PathCode:"",
		ExpStr:""
	},function(rtn){
		if(rtn.split("^")[0] != "0"){
			$.messager.alert("��ʾ","������Ʊʧ��,����ԭ��:"+rtn.split("^")[1]);
		}else{
			$.messager.alert("��ʾ","����Ʊ�����ɹ�");
		}
	});
	
}



// add by xubaobao 2021 07 30
// ��������ֽ��Ʊ��
function EInvPrintAll()
{
	var rows = $('#DataList').datagrid('getChecked');;
	if(rows.length>0){
		var PathCodeTmp="PrintPaper";
		var ErrMsgTmp="";
		TurnPaperDo(rows, 0, ErrMsgTmp, PathCodeTmp);   �����Ʊ
	}else{
		alert("��ѡ��һ����¼!");
	}
}

/// ����˵������Ʊ��ӡ
function TurnPaperDo(CheckedRecs, i, ErrMsg, PathCode){
	
	var pBillBatchCode= $("#IUDBillBatchNo").val();
	var pBillNo= $("#PresentNo").val();
	if((pBillBatchCode=="")||(pBillNo=="")){
		$.messager.alert("��ʾ","����ֽ��Ʊ��ʱ,Ʊ�Ŵ����뵱ǰ����Ʊ�Ų���Ϊ��.");
		return;
	}
	
	var ErrMsgTmp="";
	var NextIndex=0;
	var AllRecLen=CheckedRecs.length;   //���ο�Ʊ��Ŀ
	var nowInvRecInfo=CheckedRecs[i];   //��ǰƱ�ݼ�¼
	var InvRecIndex=$('#DataList').datagrid('getRowIndex', nowInvRecInfo);   //��ǰƱ������������
	
	var PayAdmType=nowInvRecInfo.IUDPayAdmType;
	var HISPrtRowID=nowInvRecInfo.IUDInvDr;
	var OrgHISPrtRowID=nowInvRecInfo.IUDInitRowID;
	
	var ExpStr=UserID+"^"+Group+"^"+Loc+"^"+Hospital+"^"+pBillBatchCode+"^"+pBillNo;
	var prtRowIdStr=HISPrtRowID+"#"+"R";      //suihuide
	
	$m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"InvocieBill",
		PayAdmType:PayAdmType,
		HISPrtRowID:HISPrtRowID,
		OrgHISPrtRowID:OrgHISPrtRowID,
		PathCode:PathCode,
		ExpStr:ExpStr
	},function(rtn){
		if(rtn.split("^")[0] != "0"){
			ErrMsgTmp="��["+(InvRecIndex+1)+"]��Ʊ���ϴ�ʧ��:"+rtn.split("^")[1];
			if(ErrMsg==""){
				ErrMsg=ErrMsgTmp;
			}else{
				ErrMsg=ErrMsg+"\n"+ErrMsgTmp;
			}
			//$.messager.alert("��ʾ","��Ʊ�ݻ���ʧ��,����ԭ��:"+rtn.split("^")[1]);
		}else{
			//$.messager.alert("��ʾ","��Ʊ�ݻ����ɹ�");
			$('#DataList').datagrid('load');
			GetStockBillNo("");           //���»�ȡ��ǰƱ��
			//patInvPrint(PayAdmType, prtRowIdStr);				//his�Լ���ӡ��Ʊ(���Ϊҵ�����ͺͷ�Ʊ��)
			PrintBtnBS(pBillBatchCode,pBillNo, PayAdmType)      //���ò�˼��ӡ
			
			
			NextIndex=i+1;    //��һ������¼
			if(NextIndex<AllRecLen){
				InvoiceDo(CheckedRecs, NextIndex, ErrMsg, PathCode)
			}else{
				if(ErrMsg!=""){
					alert(ErrMsg);
				}else{
					alert("Ʊ�ݻ����ɹ�!");
				}
			}
			
		}
	});
		
}
