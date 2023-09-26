/**
 * �շ��쳣����  dhcpe.cashierexception.js
 * @Author   wangguoying
 * @DateTime 2019-07-17
 */
var userId=session["LOGON.USERID"];
function myformatter(date){  
    var y = date.getFullYear();  
    var m = date.getMonth()+1;  
    var d = date.getDate();  
    return (d<10?('0'+d):d)+'/'+(m<10?('0'+m):m)+'/'+y;  
}
var InvDataGrid;


$(function(){
	
	$('#BeginDate').datebox('setValue', myformatter(new Date()));
	$('#EndDate').datebox('setValue', myformatter(new Date()));
	InvDataGrid=$HUI.datagrid("#InvListQueryTab",{
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
		selectOnCheck: false,
		queryParams:{
			ClassName:"web.DHCPE.InvPrt",
			QueryName:"FindInvPrtList",
			InvNo:$("#InvNo").val(),
			PatName:$("#PatName").val(),
			RegNo:$("#RegNo").val(),
			User:$("#User").val(),
			BeginDate:$('#BeginDate').datebox("getValue"),
			BeginDate:$('#EndDate').datebox("getValue"),
			CashierStat:$('#CashierStat').combobox("getValue")
		},
		frozenColumns:[[
		
		{field:'TOPInfo',title:'����',width:'80',align:"center",
			formatter:function(value,rowData,rowIndex){
				if((rowData.TOPInfo!="")&&(rowData.TOPInfo.split("^")[0]=="SE")){
					return  "<a href='#' onclick='cancel_cashier(\""+rowData.TRowId+"\")' >\
					<img title='����Ԥ����'  src='../scripts_lib/hisui-0.1.0/dist/css/icons/refuse_select_grant.png' border=0/></a>\
					<a href='#' title='ȷ�����' style='margin-left:6px' onclick='confirm_cashier(\""+rowData.TRowId+"\")' >\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/select_grant.png' border=0/></a>";
				}else if((rowData.TOPInfo!="")&&(rowData.TOPInfo.split("^")[0]=="TE")) {
					return "<a href='#' onclick='re_refund(\""+rowData.TOPInfo.split("^")[1]+"\")' >\
					<img title='������'  src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_money.png' border=0/></a>";
					
				}
			}},
			{field:'TInvNo',width:'120',title:'��Ʊ��'},
			{field:'TPatName',width:'100',title:'����'},
			{field:'TRegNo',width:'100',title:'�ǼǺ�'}
			
				]],
		columns:[[
		    {field:'TRowId',title:'TRowId',hidden: true},	
			{field:'TAmount',width:'80',title:'���',align:'right'},
			{field:'TFlag',width:'60',title:'״̬'},
			{field:'TUser',width:'80',title:'�շ�Ա'},
			{field:'TInvDate',width:'150',title:'�շ�����'},
			{field:'TRPFlag',width:'80',title:'���˱�־',align:'center'},
			{field:'TRPDate',width:'120',title:'��������'},
			{field:'TDropDate',width:'100',title:'�˷�����'},
			{field:'TRInvNo',width:'120',title:'���˷ѵķ�Ʊ��'},
			{field:'TPayMode',width:'300',title:'֧����ʽ'},
			{field:'TRoundInfo',width:'80',title:'������',align:'right'},
			{field:'TInvName',width:'100',title:'��Ʊ����'},
			{field:'Tsswr',width:'80',title:'�ֱ����',align:'right'},
			{field:'TSex',width:'40',title:'�Ա�'},
			{field:'TAge',width:'40',title:'����'},
			{field:'TPosition',width:'80',title:'����'}
			
			
					
		]],
		onSelect: function (rowIndex, rowData) {
			
			$('#RPFRowId').val(rowData.TRowId);
			$('#RPFInvNo').val(rowData.TInvNo);
		},
		onLoadSuccess: function(data){                      
			var mark=1;                                                
			for (var i=1; i <data.rows.length; i++) {     
				if (data.rows[i]['TOPInfo'] == data.rows[i-1]['TOPInfo']) {   
					mark += 1;                                            
					$(this).datagrid('mergeCells',{ 
						index: i+1-mark,                 
						field: 'TOPInfo',                
						rowspan:mark                   
					}); 
				}else{
					mark=1;                                         
				}
			}
		}
			
	});
	
	
	//��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
    //��������
	$("#BRelate").click(function() {	
		relateTrade();		
        }); 
     
     //����
	$("#BReadCard").click(function() {	
		ReadCardClickHandle();		
        });
      
     
   
  
   $("#RegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();
			}
			
        }); 
          
   $("#InvNo").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();
			}
			
        });  
         
   $("#PatName").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();	
			}
			
        });   
   
   $("#CardNo").keydown(function(e) {
			
			if(e.keyCode==13){
				CardNoKeydownHandler();
			}
			
        }); 
	
   $('#CardNo').change(CardNoChange);
     
	
        
})



function CardNoChange(){
	var CardNo=$("#CardNo").val();
	if (CardNo==""){
		$("#CardTypeNew,#CardTypeRowID").val("");
	}
}
function CardNoKeydownHandler(){
		var CardNo=$("#CardNo").val();
		if (CardNo=="") return;
		CheckCardNo();
		return false;
	
}
function CheckCardNo(){
	var CardNo=$("#CardNo").val();
	if (CardNo=="") return false;
	var myrtn=DHCACC_GetAccInfo("",CardNo,"","",CardNoKeyDownCallBack);
}
 //����
function ReadCardClickHandle(){
	DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
}

function CardNoKeyDownCallBack(myrtn){
	var CardNo=$("#CardNo").val();
	var CardTypeNew=$("#CardTypeNew").val();
	$(".textbox").val('');
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
		$.messager.alert("��ʾ","����Ч!","info",function(){
			$("#CardNo").val(CardNo).focus();
		});
		return false;
	}
}





//��ѯ
function BFind_click()
{
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	iRegNo=$("#RegNo").val();
	if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
		iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo);
		$("#RegNo").val(iRegNo)
	}

	$("#InvListQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.InvPrt",
			QueryName:"FindInvPrtList",
			InvNo:$("#InvNo").val(),
			PatName:$("#PatName").val(),
			RegNo:$("#RegNo").val(),
			User:$("#User").val(), 
			CardNo:$("#CardNo").val(),
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			CashierStat:$("#CashierStat").combobox('getValue')
			});
}

/**
 * ����Ԥ����
 * @param    {[int]}   	   inprtId [Ԥ���㷢ƱID]
 * @Author   wangguoying
 * @DateTime 2019-07-18
 */
function cancel_cashier(inprtId){
	var Return=tkMakeServerCall("web.DHCPE.DHCPEBillCharge","CancelCashier",inprtId,userId);
	if (Return!=""){ 	
		$.messager.alert("��ʾ","����Ԥ����ʧ��"+Return,"info");
		return false ;
	}else{
		$.messager.alert("��ʾ","����Ԥ����ɹ�"+Return,"success");
		InvDataGrid.reload();
	}
}


/**
 * ȷ�����
 * @param    {[int]}   	   inprtId [Ԥ���㷢ƱID]
 * @Author   wangguoying
 * @DateTime 2019-07-18
 */
function confirm_cashier(inprtId){
	var Return=tkMakeServerCall("web.DHCPE.Cashier","RealCashier",inprtId,userId,"^^1");
	if (Return.split("^")[0]!=""){ 	
		$.messager.alert("��ʾ","ȷ��ʧ��"+Return,"error");
		return false ;
	}else{
		$.messager.alert("��ʾ","ȷ�Ͻ���ɹ�,���跢Ʊ���������д�ӡ�����ӡ��Ʊ","success");
		InvDataGrid.reload();
	}
}

/**
 * ֧��ʱ��������
 * @Author   wangguoying
 * @DateTime 2019-12-26
 */
function relateTrade(){
	var select=$("#InvListQueryTab").datagrid("getSelected");
	if(select==null || select.TOPInfo!="" || select.TRowId==""||select.TInvNo==""){
		$.messager.alert("��ʾ","��ѡ�������շѵķ�Ʊ���й���","info");
		return false;
	}
	var InvPrt=select.TRowId;
	var IBPRowid="";
	$.messager.prompt("��ʾ","�����붩��ID��",function(r){
		if(r){
			if(r==""){
				$.messager.alert("��ʾ","����ID����Ϊ��","info");
				return false;
			}
			IBPRowid=r;
			var ReFlag = RelationService(IBPRowid, InvPrt, "PE")
			if (ReFlag.ResultCode != "0") {
				$.messager.alert("��ʾ","�Ʒѹ���ʧ�ܣ�����ϵ��Ϣ�ƣ�\n" + ReFlag.ResultMsg,"info");
			}
		}else{
		}
	});
	
}

/**
 * �˷Ѳ�����
 * @param    {[int]}   	   invprt [ԭƱID&��ƱID&��ƱID ]
 * @Author   wangguoying
 * @DateTime 2019-07-18
 */
function re_refund(invprt)
{
	//alert(RelationService(156737,618150,"OP"));
	//return false;
	var oriInvprt=invprt.split("&")[0]
	var	dropInvprt=invprt.split("&")[1];
	var newInvprt=invprt.split("&")[2];
	var yjsFlag=invprt.split("&")[3];
	var rfdRtn=extRefund(dropInvprt);  //DHCPEPayService
	if(rfdRtn.ResultCode!="0"){
		$.messager.alert("��ʾ",rfdRtn.ResultMsg,"info");
	}else{
		if(yjsFlag=="1"){//��Ҫȷ�����
			confirm_cashier(newInvprt);
		}	
		InvDataGrid.reload();	
	}
}







