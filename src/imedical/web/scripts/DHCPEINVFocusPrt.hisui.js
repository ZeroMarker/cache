//����	DHCPEINVFocusPrt.hisui.js
//����	���д�ӡ	
//����	2019.06.12
//������  xy

var PayModeLength=0;
$(function(){
		
	InitCombobox();
	
	InitINVFocusPrtDataGrid();
	
	$("#content").css("height", "608px")
	//$("#content").css("height", "483px")
	
		
	//��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
      
     
     //����
	$("#BReadCard").click(function() {	
		ReadCardClickHandle();		
        });
      
     
    //��ӡ��Ʊ
	$("#BPrintInv").click(function() {	
		BPrintInv_click();		
        });

    $("#BCancelPrint").click(function() {	
		CancelFocusPrint();		
        });    
        
        
        
    //��ӡ��ϸ
	$("#BPrintDetail").click(function() {	
		BPrintDetail_click();		
        });
    
   
   $("#RegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();
			}
			
        }); 
   
     
          
   $("#CardNo").keydown(function(e) {
			
			if(e.keyCode==13){
				  CardNo_Change();
			}
			
        }); 
      
       
 
 //��ȡ��ǰ��Ʊ��
  SetInvNo();
  
  Init();

 //��Ʊ����
	$("#InvType").combobox({
       onSelect:function(){
			InvType_change();
	}
	}); 
	

 //Ĭ�Ϸ�Ʊ����Ϊ"��Ԥ����"
	$("#InvType").combobox('setValue',"0"); 
 	$("#FocusStat").combobox('setValue',"1");
})



function InvType_change()
{
	var InvType=$("#InvType").combobox('getValue');
	if (InvType=="0")
	{
		$("#BPrintDetail").css('display','block');//��ʾ
	}
	if(InvType=="1")
	{ 
		 $("#BPrintDetail").css('display','none');//����	

	}
}


function FocusStat_change()
{
	var InvType=$("#FocusStat").combobox('getValue');
	if (InvType=="1")
	{
		$("#BPrintInv").css('display','block');//��ʾ
		$("#BCancelPrint").css('display','none');//����	
	}
	if(InvType=="2")
	{ 
		 $("#BPrintInv").css('display','none');//����	
		 $("#BCancelPrint").css('display','block');//��ʾ
	}
}

function Init(){
	var ret=tkMakeServerCall("web.DHCPE.HISUICommon","GetInvPrintInfo");
	var PrintCatFlag=ret.split("^")[0];
	var ListFlag=ret.split("^")[1];
	if(PrintCatFlag=="Y"){
		$("#PrintCatInfo").checkbox('setValue',true);
	}else{
		$("#PrintCatInfo").checkbox('setValue',false);
	}
	if(ListFlag=="1"){
		$("#ListFlag").checkbox('setValue',true);
	}else{
		$("#ListFlag").checkbox('setValue',false);
	}
}

//��ȡ��ǰ��Ʊ��
function SetInvNo()
{ 

	var userId=session['LOGON.USERID'];
	var CTLocID=session['LOGON.CTLOCID']
	var ret=tkMakeServerCall("web.DHCPE.DHCPEPAY","getcurinvno",userId,"N",CTLocID);

	//alert(ret)
    var invNo=ret.split("^");
    if ((invNo[0]=="")||(invNo[1]=="")){ 
    	$.messager.alert('��ʾ','û����ȷ�ķ�Ʊ��',"info");
    	return false;		
    }
    	 		   
    if(invNo[2]!=""){var No=invNo[2]+""+invNo[0];}
    else {var No=invNo[0];}
    $("#CurInvNo").val(No);
   
    
    
}



 //��ӡ��Ʊ
 function BPrintInv_click(){
	
	
	var UserID=session['LOGON.USERID'];
	var HospitalID=session['LOGON.HOSPID'];
	var CTLocID=session['LOGON.CTLOCID'];
	
	var InvID=$("#InvID").val();
	
	if (InvID==""){
		$.messager.alert('��ʾ','��ѡ����Ҫ��ӡ��Ʊ�ļ�¼',"info");
		return false;
	}
	
	var InvNoZM=$("#CurInvNo").val();
	//var InvNo=tkMakeServerCall("web.DHCPE.DHCPECommon","GetInvnoNotZM",InvNoZM);
	var ret=tkMakeServerCall("web.DHCPE.DHCPEPAY","getcurinvno",UserID,"N",CTLocID)
	var InvNo=ret.split("^")[0];

	if (InvNo==""){
		$.messager.alert('��ʾ','û�з�Ʊ�ţ����ܴ�ӡ��Ʊ',"info");
		return false;
	}
	var InvName=$("#InvName").val();
	
	var AdmReason="";
	//AdmReason=$("#AdmReason").val();
	
	var InvInfo=InvNo+"^"+InvName+"^"+AdmReason;
	
	var Ret=tkMakeServerCall("web.DHCPE.INVFocusPrt","Save",InvID,InvInfo,UserID,"1",HospitalID,CTLocID);
	var Arr=Ret.split("^");
	if (Arr[0]!=0){
		$.messager.alert('��ʾ',Arr[1],"info");
		//alert(Arr[1]);
		return false;	
	}
	//�Ƿ�ʹ��ҽ�����´�ӡ��Ʊ
	var InsuFlag="N";
	var InsuPay=$("#InsuPay").checkbox('getValue');
	if(InsuPay){var InsuFlag="Y";}
	else{var InsuFlag="N";}
	
	if (InsuFlag=="Y")
	{
		if (PayModeLength>2){
			$.messager.alert('��ʾ','ҽ������ֻ����һ��֧����ʽ,�˼�¼������ҽ������',"info");
			return false;
		}
		if (AdmReason==""){
		  $.messager.alert('��ʾ','��ѡ��ҽ����Ӧ�ķѱ�',"info");
		  return false;
	  	}
	  	
	  	var ExpStr="^^5^CHANGETOYB^";
	    try
		{
			var ret=InsuPEDivide("0",InvID,UserID,ExpStr,AdmReason,"N");
	    	var InsuArr=ret.split("^");
	    	var ret=InsuArr[0];
	    	if ((ret=="-3")||(ret=="-4"))
	    	{ 
	    		 $.messager.alert('��ʾ','ҽ������ʧ�ܣ�����ϵ��Ϣ���ģ������ԷѴ�ӡ',"error");
	        	return false;
	    	}
            if (ret=="-1")
            {
	             $.messager.alert('��ʾ',"ҽ������ʧ�ܣ�����ϵ��Ϣ���ģ������ԷѴ�ӡ","error");
	        
	        	return false;
		    }
		    else{
			     $.messager.alert('��ʾ',"ҽ������ɹ�,�����Էѽ��Ϊ:"+InsuArr[2],"info");
		    	
	    	}
		}
	    catch(e){
		     $.messager.alert('��ʾ',"ҽ������ʧ��^"+e.message,"error");
			return false;
		}	
	}
	var InvInfo=InvNo+"^"+InvName+"^"+AdmReason;
	var Ret=tkMakeServerCall("web.DHCPE.INVFocusPrt","Save",InvID,InvInfo,UserID,"0",HospitalID,CTLocID);
	var Arr=Ret.split("^");
	if (Arr[0]!=0){
		var MessageStr=Arr[1];
		if (InsuFlag=="Y"){
			MessageStr=MessageStr+",ҽ���Ѿ����㣬����ϵ��Ϣ���ġ�"
		}
		 $.messager.alert('��ʾ',MessageStr,"info");
		return false;	
	}
	
	DHCP_GetXMLConfig("InvPrintEncrypt","PEInvPrint");
	
	var InvInfoZM=InvNoZM+"^"+InvName+"^"+AdmReason;
	//alert("InvInfoZM:"+InvInfoZM)
	//alert(InvID)
	var temp=InvID.split("||");
	if ((temp.length)>1 ){
		
		var TxtInfo=tkMakeServerCall("web.DHCPE.INVFocusPrt","GetInvoiceInfo",InvID,InvInfoZM,"1",CTLocID,UserID);
		var ListInfo=tkMakeServerCall("web.DHCPE.INVFocusPrt","GetInvoiceInfo",InvID,InvInfoZM,"2",CTLocID,UserID);
		if (TxtInfo=="") return;
		//var myobj=document.getElementById("ClsBillPrint");
		//DHCP_PrintFun(myobj,TxtInfo,ListInfo);
		DHC_PrintByLodop(getLodop(),TxtInfo,ListInfo,"","{printListByText: true}"); 
	}
	else {
		
		var peAdmType=tkMakeServerCall("web.DHCPE.Cashier","GetAdmType",InvID);
		var listFlag=GetListFlag(peAdmType,CTLocID);
		var TxtInfo=tkMakeServerCall("web.DHCPE.Cashier","GetInvoiceInfo",peAdmType,InvID,"INV",UserID);
		var ListInfo=tkMakeServerCall("web.DHCPE.Cashier","GetInvoiceListInfo",peAdmType,InvID,listFlag);	
		//var myobj=document.getElementById("ClsBillPrint");
		//DHCP_PrintFun(myobj,TxtInfo,ListInfo);
		DHC_PrintByLodop(getLodop(),TxtInfo,ListInfo,"","{printListByText: true}"); 
	}
	
	BFind_click();
	SetInvNo()
 }
 
 
//��ӡ��ϸ
function BPrintDetail_click(){
	var CTLocID=session['LOGON.CTLOCID'];
	var UserID = session['LOGON.USERID'];
	var InvID=$("#InvID").val();
	if(InvID==""){
		$.messager.alert("��ʾ","����ѡ�����ӡ��ϸ�ķ�Ʊ��¼","info");
	    return ;
	}
	var temp=InvID.split("||");
	if ((temp.length)>1 ){ return false;}
	
    var peAdmType=tkMakeServerCall("web.DHCPE.Cashier","GetAdmType",InvID);
	var listFlag=GetListFlag(peAdmType,CTLocID);
	
	var TxtInfo=tkMakeServerCall("web.DHCPE.Cashier","GetInvoiceInfo",peAdmType,InvID,"List",UserID);
	var ListInfo=tkMakeServerCall("web.DHCPE.Cashier","GetInvoiceListInfo",peAdmType,InvID,1,"1");
	//alert("TxtInfo:"+TxtInfo)
	//alert("ListInfo:"+ListInfo)
	DHCP_GetXMLConfig("InvPrintEncrypt","PEINVPRTLIST");	
	//var myobj=document.getElementById("ClsBillPrint");
	//DHCP_PrintFun(myobj,TxtInfo,ListInfo);
	DHC_PrintByLodop(getLodop(),TxtInfo,ListInfo,"","{printListByText: true}"); 
}

function GetListFlag(admtype,CTLocID)
{
	if (admtype!="I") return 0;
	var InvListFlag=tkMakeServerCall("web.DHCPE.HISUICommon","GetInvListFlag",CTLocID);
	if (InvListFlag=="1") return 1;
	return 0;
	
}


function CardNo_Change()
{
	
	var myCardNo=$("#CardNo").val();
	if (myCardNo=="") return;
		var myrtn=DHCACC_GetAccInfo("",myCardNo,"","BFind_click()",CardNoKeyDownCallBack);
		return false;
	
}  


 //����
function ReadCardClickHandle(){
	DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
}

function CardNoKeyDownCallBack(myrtn){
	var CardNo=$("#CardNo").val();
	var CardTypeNew=$("#CardTypeNew").val();
	//$(".textbox").val('');
	$("#RegNo,#InvNo,#CardTypeNew,#InvName").val("");
	$("#BeginDate").datebox('setValue',"");
	$("#EndDate").datebox('setValue',"");
	$("#CardTypeNew").val(CardTypeNew);
   var myary=myrtn.split("^");
   var rtn=myary[0];
   if ((rtn=="0")||(rtn=="-201")){
		var PatientID=myary[4];
		var PatientNo=myary[5];
		var CardNo=myary[1];
		$("#CardTypeRowID").val(myary[8]);
		$("#CardNo").focus().val(CardNo);
		$("#RegNo").val(PatientNo);
		BFind_click();
	}else if(rtn=="-200"){
		$.messager.popover({msg: "����Ч!", type: "info"});
		$("#CardNo").val(CardNo).focus();
		/*
		$.messager.alert("��ʾ","����Ч!","info",function(){
			$("#CardNo").val(CardNo).focus();
		});
		*/
		return false;
	}
}


//��ѯ
function BFind_click()
{
	$('#InvID').val("");
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	iRegNo=$("#RegNo").val();
	if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
		iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo);
		$("#RegNo").val(iRegNo)
	}
   var InvType=$("#InvType").combobox('getValue');
   
   if(InvType=="1"){
	   var columns =[[
			{field:'TRowId',title:'ID',hidden: true},
		 	{field:'TInvNo',width:'110',title:'��Ʊ��'},
		 	{field:'TCardNo',width:'110',title:'���𿨺�'},
			{field:'TRegNo',width:'110',title:'�ǼǺ�'},
			{field:'TPatName',width:'150',title:'����'},
			{field:'TAmount',width:'150',title:'���',align:'right'},
			{field:'TUser',width:'120',title:'�շ�Ա'},
			{field:'TInvDate',width:'120',title:'�շ�����'},
			{field:'TRPFlag',width:'100',title:'���˱�־'},
			{field:'TRPDate',width:'120',title:'�ս�����'},
			{field:'TPayMode',width:'200',title:'֧����ʽ'},
			{field:'TCardType',width:'100',title:'��쿨����'},
		    {field:'Tsswr',width:'100',title:'�ֱ����'},
			{field:'TAge',width:'50',title:'����'}
						 
		]];


	   }
	if(InvType=="0"){
	   var columns =[[
			{field:'TRowId',title:'ID',hidden: true},
		 	{field:'TInvNo',width:'110',title:'��Ʊ��'},
			{field:'TRegNo',width:'110',title:'�ǼǺ�'},
			{field:'TPatName',width:'150',title:'����'},
			{field:'TAmount',width:'150',title:'���',align:'right'},
			{field:'TUser',width:'120',title:'�շ�Ա'},
			{field:'TInvDate',width:'190',title:'�շ�����'},
			{field:'TRPFlag',width:'100',title:'���˱�־'},
			{field:'TRPDate',width:'120',title:'�ս�����'},
			{field:'TPayMode',width:'250',title:'֧����ʽ'},
			{field:'TCardType',title:'��쿨����',hidden: true},
		    {field:'Tsswr',width:'100',title:'�ֱ����'},
			{field:'TAge',width:'50',title:'����'}	
						 
		]];


	   }
	var FocusPrint=$("#FocusStat").combobox('getValue');
   $HUI.datagrid("#INVFocusPrtTab",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.INVFocusPrt",
			QueryName:"FindInvFocusPrtList",
			InvNo:$("#InvNo").val(),
			RegNo:$("#RegNo").val(),
			CardNo:$("#CardNo").val(),
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			InvType:InvType,
			FocusPrint:FocusPrint,
			CTLocID:session['LOGON.CTLOCID']

		},
		columns:columns,
		
			
	})
	
}

var columns =[[
			{field:'TRowId',title:'ID',hidden: true},
		 	{field:'TInvNo',width:'110',title:'��Ʊ��'},
			{field:'TRegNo',width:'110',title:'�ǼǺ�'},
			{field:'TPatName',width:'150',title:'����'},
			{field:'TAmount',width:'150',title:'���',align:'right'},
			{field:'TUser',width:'120',title:'�շ�Ա'},
			{field:'TInvDate',width:'190',title:'�շ�����'},
			{field:'TRPFlag',width:'100',title:'���˱�־'},
			{field:'TRPDate',width:'120',title:'�ս�����'},
			{field:'TPayMode',width:'250',title:'֧����ʽ'},
			{field:'Tsswr',width:'100',title:'�ֱ����'},
			{field:'TAge',width:'50',title:'����'}
						 
		]];

function InitINVFocusPrtDataGrid(){
	
	$HUI.datagrid("#INVFocusPrtTab",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.INVFocusPrt",
			QueryName:"FindInvFocusPrtList",
			FocusPrint:"1",
			CTLocID:session['LOGON.CTLOCID']

		},
		columns:columns,
		onSelect: function (rowIndex, rowData) {	
			$('#InvID').val(rowData.TRowId);
			//alert(rowData.TRowId)
			if(rowData.TRowId!=""){
				var InvName=tkMakeServerCall("web.DHCPE.INVFocusPrt","GetInvInfo",rowData.TRowId);
				var Arr=InvName.split("^");
				$("#InvName").val(Arr[0]);
				$("#AdmReason").combobox('setValue',Arr[1]);
				var PayModeStr=$.trim(rowData.TPayMode);
				if (PayModeStr==""){
					PayModeLength=0;
				}else{
					PayModeLength=PayModeStr.split(":").length;
				}
			}
			
		
		
			
		}
			
	})	
}
function CancelFocusPrint()
{
	var InvID="",UserID="";
	InvID=$("#InvID").val();
	if (InvID==""){
		$.messager.alert("��ʾ","��ѡ����Ҫ�������д�ӡ��Ʊ�ļ�¼","info");
		return false;
	}
	UserID=session['LOGON.USERID'];
	var cancelRet=tkMakeServerCall("web.DHCPE.INVFocusPrt","Cancel",InvID,UserID);
	var retArr=cancelRet.split("^");
	$.messager.alert("��ʾ",retArr[1],"info");
	if(retArr[0]=="0"){	
		BFind_click();
	    SetInvNo()
	}
}

function InitCombobox(){
	
	//��Ʊ����
	var AddItemObj = $HUI.combobox("#InvType",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'0',text:$g('��Ԥ����')},
            {id:'1',text:$g('Ԥ����')}
        ]

	});	
			
	
	var FocusStatObj = $HUI.combobox("#FocusStat",{
		valueField:'id',
		textField:'text',
		onSelect:function(){
			FocusStat_change();
		},
		panelHeight:'70',
		data:[
            {id:'1',text:$g('δ��ӡ')},
            {id:'2',text:$g('�Ѵ�ӡ')}  
        ]

	});	
}
