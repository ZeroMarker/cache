//DHCPEAPAC.Find.hisui.js
//����	��쿨��ϸ��ѯ	
//����	2019.04.01
//������  xy

var selectrow=-1;

$(function(){
	 
	InitCombobox();
	 
	InitAPACFindDataGrid();
	
	//��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
        
     //ԭ���ش�
	$("#BRePRintInv").click(function() {	
		 BRePRintInv_click();		
        });
        
     //�ش�ƾ��
	$("#BRePrintBalance").click(function() {	
		BRePrintBalance_click();		
        });
    
    $("#RegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();
			}
			
        });    
   
    $("#PayMode").combobox({
			onSelect:function(){
			PayMode_change(); 
		}
	    }); 

   //��쿨����
	$("#CardType").combobox({
       onSelect:function(){
			CardType_change();
	}
	});

     //Ĭ����쿨����Ϊ"Ԥ�ɽ�"
	$("#CardType").combobox('setValue',"R"); 
    $("#BRePrintBalance").css('display','none');//���� 
   
})

function PayMode_change()
{
	var PayModeNew=$("#PayMode").combobox('getValue');
	if (($("#PayMode").combobox('getValue')==undefined)||($("#PayMode").combobox('getValue')=="")){var PayModeNew="";}
	 var PayModeDesc=tkMakeServerCall("web.DHCPE.Cashier","GetPayModeDesc",PayModeNew);
	if((PayModeDesc!="")&&(PayModeDesc.indexOf("֧Ʊ")>=0)){
		$("#No").attr('disabled',false);
	}else{
		
		$("#No").attr('disabled',true);
		$("#No").val("");
	}
	
}



function CardType_change()
{
	
	 var CardType=$("#CardType").combobox('getValue')
	if (CardType=="C")
	{
		
        $("#RegNoL").text("���𿨺�");
		$("#BRePrintBalance").css('display','block');//��ʾ
	}
	if(CardType=="R")
	{
		 $("#RegNoL").text("�ǼǺ�");
		var regNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",$("#RegNo").val());
		 $("#RegNo").val(regNo);
		 $("#BRePrintBalance").css('display','none');//����
		

	}
	BFind_click();
}
function BRePrintBalance_click()
{    
    
    var RowId=$("#RowId").val();
	if (RowId=="") {
		 $.messager.alert("��ʾ","��ѡ�����ӡ�ļ�¼","info");
		return false;
	}
	var Delim=String.fromCharCode(2);
	var CardNO="",DateTime="";
	
	var HosName="";
    var HosName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",session['LOGON.HOSPID'])
	//if(HosName.indexOf("[")>-1){var HosName=HosName.split("[")[0];}
 
    var objtbl = $("#APACFindQueryTab").datagrid('getRows'); 
	var CardNO=objtbl[selectrow].TCardNo;
	if(CardNO==undefined){CardNO=""}
	var TxtInfo="CardNo"+Delim+CardNO;
	var Amt=objtbl[selectrow].TAmount;
	if(Amt>0){Amt=0;}
	else{Amt=-Amt;} 
	var TxtInfo=TxtInfo+"^"+"Cost"+Delim+Amt;
	var ReAmt=objtbl[selectrow].TRemainAmount;
	var TxtInfo=TxtInfo+"^"+"CurrentBalance"+Delim+ReAmt;
	var Date=objtbl[selectrow].TDate;
	var Time=objtbl[selectrow].TTime;
	DateTime=Date+" "+Time;
	var TxtInfo=TxtInfo+"^"+"DateTime"+Delim+DateTime;
	var TxtInfo=TxtInfo+"^"+"DateTime"+Delim+DateTime+"^"+"HosName"+Delim+HosName;
	//alert("TxtInfo:"+TxtInfo)
	PrintBalance(TxtInfo);
}
function PrintBalance(TxtInfo)
{
	//alert("TxtInfo=="+TxtInfo);
	DHCP_GetXMLConfig("InvPrintEncrypt","PEINVPRTBalance");
	//var myobj=document.getElementById("ClsBillPrint");
	var Delim=String.fromCharCode(2);
	var TxtInfoHosp=TxtInfo+"^"+"BottomRemark"+Delim+"(�ֿ��˴��)";
	//DHCP_PrintFun(myobj,TxtInfoHosp,"");
	DHC_PrintByLodop(getLodop(),TxtInfoHosp,"","","");
	var TxtInfoPat=TxtInfo+"^"+"BottomRemark"+Delim+"(�̻����)";
	//alert("TxtInfoPat:"+TxtInfoPat)
	
	//DHCP_PrintFun(myobj,TxtInfoPat,"");
	DHC_PrintByLodop(getLodop(),TxtInfoPat,"","","");
}
function BRePRintInv_click()
{
	var RowId=$("#RowId").val();
	if (RowId=="") {
		 $.messager.alert("��ʾ","��ѡ�����ӡ�ļ�¼","info");
		return false;
	}
	
	 var InvID="",DetailType="";
	 var objtbl = $("#APACFindQueryTab").datagrid('getRows'); 
	 var InvID=objtbl[selectrow].TSourceNo;
	 
	if (InvID=="") {
		$.messager.alert("��ʾ","û��ԭ��Ʊ�����ش�","info");
		return false;
		}
	 var DetailType=objtbl[selectrow].TType;
	if ((DetailType!="����")&&(DetailType!="��Ԥ�ɽ�")) return false;
	PrintInv(InvID);
}
function PrintInv(InvID)
{
	var TxtInfo=tkMakeServerCall("web.DHCPE.AdvancePayment","GetInvoiceInfo",InvID,"1");
	var ListInfo=tkMakeServerCall("web.DHCPE.AdvancePayment","GetInvoiceInfo",InvID,"2");
	if (TxtInfo=="") return
	///xml print requird
	DHCP_GetXMLConfig("InvPrintEncrypt","PEInvPrint");
	
	//alert("TxtInfo:"+TxtInfo)
	//alert("ListInfo:"+ListInfo)
	//var myobj=document.getElementById("ClsBillPrint");
	//DHCP_PrintFun(myobj,TxtInfo,ListInfo);
	DHC_PrintByLodop(getLodop(),TxtInfo,ListInfo,"","{printListByText:true}");
}

	
function InitCombobox()
{
	// ��쿨
	var CTypeObj = $HUI.combobox("#CardType",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindTJCardType&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		
		})
	
	// ����	
	var TypeObj = $HUI.combobox("#Type",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindType&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		
		})
	/*	
	// ֧����ʽ	
	var RPObj = $HUI.combobox("#PayMode",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPayMode&ResultSetType=array",
		valueField:'id',
		textField:'text'
		})	
		*/

		// ֧����ʽ	
	var RPObj = $HUI.combobox("#PayMode",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindTJCardPayMode&ResultSetType=array",
		valueField:'id',
		textField:'text',
		panelHeight:'140',	
		})	

}

//��ѯ
function BFind_click(){
	var CardType=$("#CardType").combobox('getValue');
	
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	iRegNo=$("#RegNo").val();

  if(CardType=="R"){
	   	if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
			iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo);
			$("#RegNo").val(iRegNo)
		};
  }

	$("#APACFindQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.APQuery",
			QueryName:"SearchAPACDetail",
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			Type:$("#Type").combobox('getValue'),
			CardType:$("#CardType").combobox('getValue'),
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue')
			})
	
}

function InitAPACFindDataGrid(){
	
	$HUI.datagrid("#APACFindQueryTab",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns:true,
		singleSelect: true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		queryParams:{
			ClassName:"web.DHCPE.APQuery",
			QueryName:"SearchAPACDetail",
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			Type:$("#Type").combobox('getValue'),
			CardType:$("#CardType").combobox('getValue'),
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue')
				
		},
		onClickRow:function(rowIndex,rowData){
			
			setValueById("RowId",rowData.TRowID);
			selectrow=rowIndex;
	
		},
		frozenColumns:[[
		{field:'TRefund',title:'�˷�',width:50,

			formatter:function(value,rowData,rowIndex){
				if((rowData.TSourceNo.indexOf("��")<0)&&(rowData.TType.indexOf("����")<0)&&(rowData.TType.indexOf("ת��")<0)&&(rowData.TType.indexOf("ת��")<0)&&(rowData.TRemainAmount!="0.00")){
					return "<a href='#' onclick='BRefund_click(\""+rowIndex+"\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel_order.png' border=0/>\
					</a>";
				}
				}}	
				]],
		columns:[[
			
			{field:'TRowID',title:'TRowID',hidden: true},
		    {field:'TRegNo',width:120,title:'�ǼǺ�'},
			{field:'TName',width:80,title:'����'},
			{field:'TBilledName',width:80,title:'����������'},
			{field:'TSex',width:50,title:'�Ա�'},
			{field:'TDate',width:100,title:'����'},
			{field:'TTime',width:100,title:'ʱ��'},
			{field:'TType',width:80,title:'����'},
			{field:'TCardNo',width:150,title:'���𿨺�'},
			{field:'TAmount',width:100,title:'���',align:'right'},
			{field:'TSourceNo',width:150,title:'���ݺ�'},
			{field:'TUser',width:80,title:'����Ա'},
			{field:'TRemainAmount',width:100,title:'ʣ����',align:'right'},
			{field:'TPayMode',width:120,title:'֧����ʽ'},
			{field:'TAge',width:100,title:'��������'},
			{field:'TReport',width:80,title:'�Ƿ��ս�'},
			{field:'TRemark',width:120,title:'��ע'},
			{field:'TReRemark',width:'120',title:'�˷ѱ�ע'},
					
		]],
		onSelect: function (rowIndex, rowData) {
			
			if((rowData.TSourceNo=="")||(rowData.TSourceNo.indexOf("��")>=0)||(rowData.TSourceNo.indexOf("��")>=0)||((rowData.TType!="����")&&(rowData.TType!="��Ԥ�ɽ�"))){
					$("#BRePRintInv").linkbutton('disable');
				
					}else{
						$("#BRePRintInv").linkbutton('enable');	
						}
			

		}
			
	})
		
}


//�˷�
function BRefund_click(selectrow)
{
	/*
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEAPAC.Refund"+"&RowID="+ID;
	websys_lu(lnk,false,'width=630,height=340,hisui=true,title=�˷�')
	*/
	 var objtbl = $("#APACFindQueryTab").datagrid('getRows'); 
	var ID=objtbl[selectrow].TRowID;
	var Type=objtbl[selectrow].TType;
   var PayMode=objtbl[selectrow].TPayMode;
	$("#myWin").show();
	 
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-edit',
			resizable:true,
			title:'�˷�',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'�˷�',
				id:'BRefund_btn',
				handler:function(){
					BRefund(ID)
				}
			},{
				text:'����֧����ʽ',
				id:'BUpdatePayMode_btn',
				handler:function(){
					BUpdatePayMode_click(ID)
				}
			},{
				text:'�ر�',
				handler:function(){
					myWin.close();
				}
			}]
		});
		$('#form-save').form("clear");
		if(Type=="ת��"){
		$("#BUpdatePayMode_btn").linkbutton('disable');
		}else{
		$("#BUpdatePayMode_btn").linkbutton('enable');
		}
		if((PayMode!="")&&(PayMode.indexOf("(")!="-1")){
		
			var NoStr=PayMode.split("(")[1];
			var No=NoStr.split(")")[0];
			$("#No").val(No);
		}		

    if((PayMode!="")&&(PayMode.indexOf("֧Ʊ")>=0)){
			$("#No").attr('disabled',false);
		}else{
		
			$("#No").attr('disabled',true);
		}

		SetInvNo();
		FillPatientDatabyRowID(ID);
			
}
function BUpdatePayMode_click(ID)
{
	
	if (ID=="")
	{
		$.messager.alert("��ʾ","�˷ѵļ�¼������","info");
		return false;
	}
	
	var PayMode=$("#PayMode").combobox("getValue");
	var No="";
	var No=$("#No").val();
	var PayModeDesc=tkMakeServerCall("web.DHCPE.Cashier","GetPayModeDesc",PayMode); 
	if(PayModeDesc.indexOf("֧Ʊ")>=0){

			if(No==""){
			$.messager.alert("��ʾ","������֧Ʊ��","info");
			return false;
			}
		}

	var ret=tkMakeServerCall("web.DHCPE.AdvancePayment","UpdatePayMode",ID,PayMode,No);
	var Arr=ret.split("^");
	if (Arr[0]!="0"){
		$.messager.alert("��ʾ",Arr[1],"info");
	}else{
		$.messager.alert("��ʾ","���³ɹ�","success");
		$('#myWin').dialog('close'); 
		$("#APACFindQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.APQuery",
			QueryName:"SearchAPACDetail",
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			Type:$("#Type").combobox('getValue'),
			CardType:$("#CardType").combobox('getValue'),
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue')
			})
	}
	
}


function BRefund(ID)
{
	
	if (ID=="")
	{	
		$.messager.alert("��ʾ","�˷ѵļ�¼������","info");
		return false;
	}
	var Data=tkMakeServerCall("web.DHCPE.AdvancePayment","GetData",ID.split("||")[0])
	var Status=Data.split("^")[4];
	if(Status!="N"){
		$.messager.alert("��ʾ","�ÿ���������״̬�������˷�","info");
		return false;
	}
	var RFee=$("#RFee").val();
	if(RFee<=0){
		$.messager.alert("��ʾ","�˷ѽ��Ӧ����0","info");
		return false;
	}
	if (!(IsFloat(RFee))) {
				$.messager.alert("��ʾ","�˷ѽ���ʽ�Ƿ�","info"); 
				return false;
			}

	if((RFee!="")&&(RFee.indexOf(".")!="-1")&&(RFee.toString().split(".")[1].length>2))
		{
			$.messager.alert("��ʾ","�˷ѽ��С������ܳ�����λ","info");
			return false;
		}


	var LFee=$("#RemainAmount").val();
	var OldFee=$("#Amount").val();
	if ((+RFee)>(+OldFee))
	{
		
		$.messager.alert("��ʾ","�˷ѽ��ܴ���ԭ��ֵ���","info");
		return false;
	}
	if ((+RFee)>(+LFee))
	{
		$.messager.alert("��ʾ","�˷ѽ��ܴ���ʣ����","info");
		return false;
	}
	
	var RRemark=$("#RRemark").val();
	var InvID=$("#CurInvNo").val();
    var InvID=tkMakeServerCall("web.DHCPE.DHCPECommon","GetInvnoNotZM",InvID);
	var PayMode=$("#PayMode").combobox('getValue');
	if (($("#PayMode").combobox('getValue')==undefined)||($("#PayMode").combobox('getValue')=="")){var PayMode="";}
	if(PayMode==""){
		$.messager.alert("��ʾ","��ѡ��֧����ʽ","info");
		return false;
		}
	var No="";
	var No=$("#No").val();
	var PayModeDesc=tkMakeServerCall("web.DHCPE.Cashier","GetPayModeDesc",PayMode); 
	if(PayModeDesc.indexOf("֧Ʊ")>=0){

			if(No==""){
			$.messager.alert("��ʾ","������֧Ʊ��","info");
			return false;
			}
		}

	var Strings=ID+"^"+RFee+"^"+InvID+"^"+PayMode+"^"+RRemark
	var ret=tkMakeServerCall("web.DHCPE.AdvancePayment","Refund",Strings);

	var RetArr=ret.split("^");
	if (RetArr[0]!=0)
	{
		$.messager.alert("��ʾ",RetArr[0],"info");
		return false;
	}
	var NewAPCRowId=RetArr[2];
	var refundInfo=tkMakeServerCall("web.DHCPE.AdvancePayment","GetExtRefundByAPCRowID",NewAPCRowId,"",ID);
	if (refundInfo != "") {
			var char1 = String.fromCharCode(1);
			var PEBarCodePayStr = refundInfo.split(char1)[1]; //������ɨ�븶֧����¼
			refundInfo = refundInfo.split(char1)[0];
			var refundDr = refundInfo.split("^")[1];
			var refundAmt = parseFloat(refundInfo.split("^")[2]);
			var oldETPRowID = refundInfo.split("^")[3];
			var oldINvID = refundInfo.split("^")[4]; //��Ʊ
			var dropInvID = refundInfo.split("^")[5]; //��Ʊ    			
			var newInvID = refundInfo.split("^")[6] //��Ʊ
			var oriInvID = refundInfo.split("^")[7] //ԭʼ��Ʊ
			var paadm = refundInfo.split("^")[8];
			var scanFlag = refundInfo.split("^")[9] //������ɨ�븶
			if (scanFlag == "1") {
				
			} else {
				var expStr = session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.HOSPID'] + "^" + session['LOGON.USERID'] + "^^^^^D^";
				var refRtn = RefundPayService("PEDEP", oldINvID, dropInvID, newInvID, refundAmt, "PEDEP", expStr);
				if (refRtn.rtnCode != "0") {
					$.messager.alert("��ʾ","����˷ѳɹ������õ������˷ѽӿ�ʧ��,�벹���ף�\n" + refRtn.rtnMsg,"info");
				}
			}
	}

	var Inv=RetArr[1];
	if (Inv!="")
	{
		PrintInv(Inv)
	}
	$.messager.alert("��ʾ","�˷ѳɹ�","success");
    $('#myWin').dialog('close'); ;
	$("#APACFindQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.APQuery",
			QueryName:"SearchAPACDetail",
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			Type:$("#Type").combobox('getValue'),
			CardType:$("#CardType").combobox('getValue'),
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue')
			})
	
}

//��ȡ��ǰ��Ʊ��
function SetInvNo()
{ 
	var userId=session['LOGON.USERID'];
	var ret=tkMakeServerCall("web.DHCPE.DHCPEPAY","getcurinvno",userId);
	
    var invNo=ret.split("^");
    if ((invNo[0]=="")||(invNo[1]=="")){ 
    	$.messager.alert('��ʾ','û����ȷ�ķ�Ʊ��',"info");
    	return false;		
    }
    	 		   
    if(invNo[2]!=""){var No=invNo[2]+""+invNo[0];}
    else {var No=invNo[0];}
    $("#CurInvNo").val(No);
   
    
    
}

//��ȡ�˷ѵķ�Ʊ��Ϣ
function FillPatientDatabyRowID(ID)
{
	
	var RowID=ID;  
    if (RowID==""){return false;}
	var Data=tkMakeServerCall("web.DHCPE.AdvancePayment","GetInfo",RowID);
	var DataArr=Data.split("^");
	if (DataArr[0]!=0)
	{
		$.messager.alert("��ʾ",DataArr[0],"info");
		return false;
	}
	
	//setValueById("RowID",DataArr[1]);
	$("#RRegNo").val(DataArr[2]);
	$("#RName").val(DataArr[3]);
	$("#Amount").val(DataArr[4]);
	$("#PayMode").combobox('setValue',DataArr[5]);
	$("#Remark").val(DataArr[6]);
    $("#RemainAmount").val(DataArr[7]);
	$("#InvNo").val(DataArr[8]);
	
	if ((+DataArr[7])>(+DataArr[4]))
	{
		var RFee=DataArr[4];
	}
	else
	{
		var RFee=DataArr[7]
	}
	$("#RFee").val(RFee);
	
}

//��֤�Ƿ�Ϊ������
function IsFloat(Value) {
	
	var reg;
	if(""==$.trim(Value)) { 
		return true; 
	}else { Value=Value.toString(); }
	reg=/^((\d+\.\d*[1-9]\d*)|(\d*[1-9]\d*\.\d+)|(\d*[1-9]\d*))$/
	//reg=/^((-?|\+?)\d+)(\.\d+)?$/;
	if ("."==Value.charAt(0)) {
		Value="0"+Value;
	}
	
	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
	
}
