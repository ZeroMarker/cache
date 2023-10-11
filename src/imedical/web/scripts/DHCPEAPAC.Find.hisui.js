//名称  DHCPEAPAC.Find.hisui.js
//功能	体检卡明细查询	
//创建	2019.04.01
//创建人  xy

var selectrow=-1;

$(function(){
	 
	InitCombobox();
	 
	InitAPACFindDataGrid();
	
	//查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
        
     //原号重打
	$("#BRePRintInv").click(function() {	
		 BRePRintInv_click();		
        });
        
     //重打凭条
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

   //体检卡类型
	$("#CardType").combobox({
       onSelect:function(){
			CardType_change();
	}
	});

     //默认体检卡类型为"预缴金"
	$("#CardType").combobox('setValue',"R"); 
    $("#BRePrintBalance").css('display','none');//隐藏 
   
})

function PayMode_change()
{
	var PayModeNew=$("#PayMode").combobox('getValue');
	if (($("#PayMode").combobox('getValue')==undefined)||($("#PayMode").combobox('getValue')=="")){var PayModeNew="";}
	 var PayModeDesc=tkMakeServerCall("web.DHCPE.Cashier","GetPayModeDesc",PayModeNew);
	if((PayModeDesc!="")&&(PayModeDesc.indexOf("支票")>=0)){
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
		
        $("#RegNoL").text("代金卡号");
		$("#BRePrintBalance").css('display','block');//显示
	}
	if(CardType=="R")
	{
		 $("#RegNoL").text("登记号");
		var regNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",$("#RegNo").val());
		 $("#RegNo").val(regNo);
		 $("#BRePrintBalance").css('display','none');//隐藏
		

	}
	BFind_click();
}
function BRePrintBalance_click()
{    
    
    var RowId=$("#RowId").val();
	if (RowId=="") {
		 $.messager.alert("提示","请选择待打印的记录","info");
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
	var TxtInfoHosp=TxtInfo+"^"+"BottomRemark"+Delim+"(持卡人存根)";
	//DHCP_PrintFun(myobj,TxtInfoHosp,"");
	DHC_PrintByLodop(getLodop(),TxtInfoHosp,"","","");
	var TxtInfoPat=TxtInfo+"^"+"BottomRemark"+Delim+"(商户存根)";
	//alert("TxtInfoPat:"+TxtInfoPat)
	
	//DHCP_PrintFun(myobj,TxtInfoPat,"");
	DHC_PrintByLodop(getLodop(),TxtInfoPat,"","","");
}

//原号重打
function BRePRintInv_click()
{
	var LocID=session['LOGON.CTLOCID']
	var RowId=$("#RowId").val();
	if (RowId=="") {
		 $.messager.alert("提示","请选择待打印的记录","info");
		return false;
	}
	
	 var InvID="",DetailType="";
	 var objtbl = $("#APACFindQueryTab").datagrid('getRows'); 
	 var InvID=objtbl[selectrow].TSourceNo;
	 if(InvID.indexOf("(")>"-1") { var InvID=InvID.split("(")[0]; }

	 if (InvID=="") {
		$.messager.alert("提示","没有原发票不能重打","info");
		return false;
		}
	 var DetailType=objtbl[selectrow].TType;
	if ((DetailType!="开户")&&(DetailType!="交预缴金")&&(DetailType!="充值")) return false;
	PrintInv(InvID);
}
function PrintInv(InvID)
{
	var LocID=session['LOGON.CTLOCID']
	var TxtInfo=tkMakeServerCall("web.DHCPE.AdvancePayment","GetInvoiceInfo",InvID,"1","",LocID);
	var ListInfo=tkMakeServerCall("web.DHCPE.AdvancePayment","GetInvoiceInfo",InvID,"2","",LocID);
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
	//体检卡
	var CTypeObj = $HUI.combobox("#CardType",{
		valueField: 'id', 
		textField: 'text', 
		data: [
			{ id: 'R', text: $g('预缴金')}, 
			{ id: 'C', text: $g('代金卡') } 	
		]
	});
	
	
 	//类型
	var TypeObj = $HUI.combobox("#Type",{
		valueField: 'id', 
		textField: 'text', 
		data: [
			{ id: 'B', text: $g('开户')}, 
			{ id: 'R', text: $g('交预缴金') }, 
			{ id: 'RF', text: $g('退预缴金') }, 
			{ id: 'O', text: $g('转出') },
			{ id: 'I', text: $g('转入')}, 
			{ id: 'C', text: $g('结算') }, 
			{ id: 'CF', text: $g('结算退费') }	
		]
	});
	
	

	/*
	// 退费支付方式	
	var RPObj = $HUI.combobox("#PayMode",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindTJCardPayMode&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'text',
		panelHeight:'140',	
		})	
	*/
	
	// 退费支付方式	
	var RPObj = $HUI.combobox("#PayMode",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindRefundPayMode&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc',
		panelHeight:'140',	
		})

}

//查询
function BFind_click(){
	var CardType=$("#CardType").combobox('getValue');
	var LocID=session['LOGON.CTLOCID']
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",LocID);
	iRegNo=$("#RegNo").val();

  if(CardType=="R"){
	   	if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
			iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo,LocID);
			$("#RegNo").val(iRegNo)
		};
		
		var columns=[[
			
			{field:'TRowID',title:'TRowID',hidden: true},
		    {field:'TRegNo',width:120,title:'登记号'},
			{field:'TName',width:80,title:'姓名'},
			{field:'TBilledName',title:'消费者姓名',hidden: true},
			{field:'TSex',width:50,title:'性别'},
			{field:'TDate',width:100,title:'日期'},
			{field:'TTime',width:100,title:'时间'},
			{field:'TType',width:80,title:'类型'},
			{field:'TCardNo',title:'代金卡号',hidden: true},
			{field:'TAmount',width:100,title:'金额',align:'right'},
			{field:'TSourceNo',width:180,title:'单据号'},
			{field:'TPAADMTypeDesc',width:100,title:'就诊类型'},
			{field:'TUser',width:80,title:'操作员'},
			{field:'TRemainAmount',width:100,title:'剩余金额',align:'right'},
			{field:'TPayMode',width:120,title:'支付方式'},
			{field:'TAge',width:100,title:'出生日期'},
			{field:'TReport',width:80,title:'是否日结'},
			{field:'TRemark',width:120,title:'备注'},
			{field:'TReRemark',width:'120',title:'退费备注'},
					
	]]
  }else{
	  var columns=[[
			
			{field:'TRowID',title:'TRowID',hidden: true},
		    {field:'TRegNo',width:120,title:'登记号'},
			{field:'TName',width:80,title:'姓名'},
			{field:'TBilledName',width:80,title:'消费者姓名'},
			{field:'TSex',width:50,title:'性别'},
			{field:'TDate',width:100,title:'日期'},
			{field:'TTime',width:100,title:'时间'},
			{field:'TType',width:80,title:'类型'},
			{field:'TCardNo',width:150,title:'代金卡号'},
			{field:'TAmount',width:100,title:'金额',align:'right'},
			{field:'TSourceNo',width:180,title:'单据号'},
			{field:'TPAADMTypeDesc',width:100,title:'就诊类型'},
			{field:'TUser',width:80,title:'操作员'},
			{field:'TRemainAmount',width:100,title:'剩余金额',align:'right'},
			{field:'TPayMode',width:120,title:'支付方式'},
			{field:'TAge',width:100,title:'出生日期'},
			{field:'TReport',width:80,title:'是否日结'},
			{field:'TRemark',width:120,title:'备注'},
			{field:'TReRemark',width:'120',title:'退费备注'},
					
	]]
  }
 

	$HUI.datagrid("#APACFindQueryTab", {
		url: $URL,
		fit: true,
		border: false,
		striped: true,
		fitColumns: false,
		autoRowHeight: false,
		rownumbers: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 100, 200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams: {
			ClassName:"web.DHCPE.APQuery",
			QueryName:"SearchAPACDetail",
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			Type:$("#Type").combobox('getValue'),
			CardType:$("#CardType").combobox('getValue'),
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			CTLocID:session['LOGON.CTLOCID']

		},
		columns: columns,
	})
	  selectrow=-1;
	 $("#RowId").val("");

	
}

var columns=[[
			
			{field:'TRowID',title:'TRowID',hidden: true},
		    {field:'TRegNo',width:120,title:'登记号'},
			{field:'TName',width:80,title:'姓名'},
			{field:'TBilledName',title:'消费者姓名',hidden: true},
			{field:'TSex',width:50,title:'性别'},
			{field:'TDate',width:100,title:'日期'},
			{field:'TTime',width:100,title:'时间'},
			{field:'TType',width:80,title:'类型'},
			{field:'TCardNo',title:'代金卡号',hidden: true},
			{field:'TAmount',width:100,title:'金额',align:'right'},
			{field:'TSourceNo',width:180,title:'单据号'},
			{field:'TPAADMTypeDesc',width:100,title:'就诊类型'},
			{field:'TUser',width:80,title:'操作员'},
			{field:'TRemainAmount',width:100,title:'剩余金额',align:'right'},
			{field:'TPayMode',width:120,title:'支付方式'},
			{field:'TAge',width:100,title:'出生日期'},
			{field:'TReport',width:80,title:'是否日结'},
			{field:'TRemark',width:120,title:'备注'},
			{field:'TReRemark',width:'120',title:'退费备注'},
					
	]]
		
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
			EndDate:$("#EndDate").datebox('getValue'),
			CTLocID:session['LOGON.CTLOCID']
				
		},
		onClickRow:function(rowIndex,rowData){
			
			setValueById("RowId",rowData.TRowID);
			selectrow=rowIndex;
	
		},
		frozenColumns:[[
		{field:'TRefund',title:'退费',width:50,

			formatter:function(value,rowData,rowIndex){
				if((rowData.TSourceNo.indexOf("退")<0)&&(rowData.TType.indexOf("结算")<0)&&(rowData.TType.indexOf("转出")<0)&&(rowData.TType.indexOf("转入")<0)&&(rowData.TRemainAmount!="0.00")){
					return "<span style='cursor:pointer;padding:0 8px 0px 10px' class='icon-return-paid' onclick='BRefund_click("+rowIndex+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";	                   				
				}
				}}	
				]],
		columns: columns,
		onSelect: function (rowIndex, rowData) {
			
			if((rowData.TSourceNo=="")||(rowData.TSourceNo.indexOf("退")>=0)||(rowData.TSourceNo.indexOf("集")>=0)||((rowData.TType!="开户")&&(rowData.TType!="交预缴金")&&(rowData.TType!="充值"))){
					$("#BRePRintInv").linkbutton('disable');
				
					}else{
						$("#BRePRintInv").linkbutton('enable');	
						}
			

		}
			
	})
		
}


//退费
function BRefund_click(selectrow)
{
	/*
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEAPAC.Refund"+"&RowID="+ID;
	websys_lu(lnk,false,'width=630,height=340,hisui=true,title=退费')
	*/
	 var LocID=session['LOGON.CTLOCID'];
	 var objtbl = $("#APACFindQueryTab").datagrid('getRows'); 
	 var ID=objtbl[selectrow].TRowID;
	 var Type=objtbl[selectrow].TType;
     var PayMode=objtbl[selectrow].TPayMode;
     var PayModeID=objtbl[selectrow].TPayModeID;
     
	  $("#myWin").show();
	 
	  $('#form-save').form("clear");
	 
	 //退费支付方式-重新加载
	 var PayModeUrl=$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindRefundPayMode&ResultSetType=array&LocID="+LocID+"&PayModeID="+PayModeID;
     $("#PayMode").combobox('reload',PayModeUrl);

		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-edit',
			resizable:true,
			title:'退费',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'退费',
				id:'BRefund_btn',
				handler:function(){
					BRefund(ID)
				}
			},{
				text:'更新支付方式',
				id:'BUpdatePayMode_btn',
				handler:function(){
					BUpdatePayMode_click(ID)
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]
		});
		

		if(Type=="转入"){
			$("#BUpdatePayMode_btn").linkbutton('disable');
		}else{
			$("#BUpdatePayMode_btn").linkbutton('enable');
		}

		if((PayMode!="")&&(PayMode.indexOf("(")!="-1")){
		
			var NoStr=PayMode.split("(")[1];
			var No=NoStr.split(")")[0];
			$("#No").val(No);
		}		

		if((PayMode!="")&&(PayMode.indexOf("支票")>=0)){
			$("#No").attr('disabled',false);
		}else{
		
			$("#No").attr('disabled',true);
		}

		SetInvNo();
		FillPatientDatabyRowID(ID);
			
}
function BUpdatePayMode_click(ID)
{
	var LocID=session['LOGON.CTLOCID']
	if (ID=="")
	{
		$.messager.alert("提示","退费的记录不存在","info");
		return false;
	}
	
	var PayMode=$("#PayMode").combobox("getValue");
	var No="";
	var No=$("#No").val();
	var PayModeDesc=tkMakeServerCall("web.DHCPE.Cashier","GetPayModeDesc",PayMode); 
	if(PayModeDesc.indexOf("支票")>=0){

			if(No==""){
			$.messager.alert("提示","请输入支票号","info");
			return false;
			}
		}

	var ret=tkMakeServerCall("web.DHCPE.AdvancePayment","UpdatePayMode",ID,PayMode,No,LocID);
	var Arr=ret.split("^");
	if (Arr[0]!="0"){
		$.messager.alert("提示",Arr[1],"info");
	}else{
		$.messager.alert("提示","更新成功","success");
		$('#myWin').dialog('close'); 
		$("#APACFindQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.APQuery",
			QueryName:"SearchAPACDetail",
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			Type:$("#Type").combobox('getValue'),
			CardType:$("#CardType").combobox('getValue'),
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			CTLocID:session['LOGON.CTLOCID']
			})
	}
	
}


function BRefund(ID)
{
	var LocID=session['LOGON.CTLOCID']
	var HOSPID=session['LOGON.HOSPID']
	var USERID=session['LOGON.USERID']

	if (ID=="")
	{	
		$.messager.alert("提示","退费的记录不存在","info");
		return false;
	}
	var Data=tkMakeServerCall("web.DHCPE.AdvancePayment","GetData",ID.split("||")[0])
	var Status=Data.split("^")[4];
	if(Status!="N"){
		$.messager.alert("提示","该卡不是正常状态，不能退费","info");
		return false;
	}
	var RFee=$("#RFee").val();
	if(RFee<=0){
		$.messager.alert("提示","退费金额应大于0","info");
		return false;
	}
	if (!(IsFloat(RFee))) {
				$.messager.alert("提示","退费金额格式非法","info"); 
				return false;
			}

	if((RFee!="")&&(RFee.indexOf(".")!="-1")&&(RFee.toString().split(".")[1].length>2))
		{
			$.messager.alert("提示","退费金额小数点后不能超过两位","info");
			return false;
		}


	var LFee=$("#RemainAmount").val();
	var OldFee=$("#Amount").val();
	if ((+RFee)>(+OldFee))
	{
		
		$.messager.alert("提示","退费金额不能大于原充值金额","info");
		return false;
	}
	if ((+RFee)>(+LFee))
	{
		$.messager.alert("提示","退费金额不能大于剩余金额","info");
		return false;
	}
	
	var RRemark=$("#RRemark").val();
	var InvID=$("#CurInvNo").val();
    var InvID=tkMakeServerCall("web.DHCPE.DHCPECommon","GetInvnoNotZM",InvID);
	var PayMode=$("#PayMode").combobox('getValue');
	if (($("#PayMode").combobox('getValue')==undefined)||($("#PayMode").combobox('getValue')=="")){var PayMode="";}
	if(PayMode==""){
		$.messager.alert("提示","请选择支付方式","info");
		return false;
		}
	var No="";
	var No=$("#No").val();
	var PayModeDesc=tkMakeServerCall("web.DHCPE.Cashier","GetPayModeDesc",PayMode); 
	if(PayModeDesc.indexOf("支票")>=0){

			if(No==""){
			$.messager.alert("提示","请输入支票号","info");
			return false;
			}
		}

	var Strings=ID+"^"+RFee+"^"+InvID+"^"+PayMode+"^"+RRemark
	//var ret=tkMakeServerCall("web.DHCPE.AdvancePayment","Refund",Strings);
	var ret=tkMakeServerCall("web.DHCPE.AdvancePayment","Refund",Strings,LocID,USERID,HOSPID);

	var RetArr=ret.split("^");
	if (RetArr[0]!=0)
	{
		$.messager.alert("提示",RetArr[0],"info");
		return false;
	}
	var NewAPCRowId=RetArr[2];
	var refundInfo=tkMakeServerCall("web.DHCPE.AdvancePayment","GetExtRefundByAPCRowID",NewAPCRowId,"",ID,"",LocID);
	if (refundInfo != "") {
			var char1 = String.fromCharCode(1);
			var PEBarCodePayStr = refundInfo.split(char1)[1]; //互联网扫码付支付记录
			refundInfo = refundInfo.split(char1)[0];
			var refundDr = refundInfo.split("^")[1];
			var refundAmt = parseFloat(refundInfo.split("^")[2]);
			var oldETPRowID = refundInfo.split("^")[3];
			var oldINvID = refundInfo.split("^")[4]; //正票
			var dropInvID = refundInfo.split("^")[5]; //负票    			
			var newInvID = refundInfo.split("^")[6] //新票
			var oriInvID = refundInfo.split("^")[7] //原始正票
			var paadm = refundInfo.split("^")[8];
			var scanFlag = refundInfo.split("^")[9] //互联网扫码付
			if (scanFlag == "1") {
				
			} else {
				var expStr = session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.HOSPID'] + "^" + session['LOGON.USERID'] ;
				var refRtn = RefundPayService("PEDEP", oldINvID, dropInvID, newInvID, refundAmt, "PEDEP", expStr);
				if (refRtn.ResultCode != "0") {
					$.messager.alert("提示","体检退费成功，调用第三方退费接口失败,请补交易！\n" + refRtn.ResultMsg,"info");
				}
			}
	}

	var Inv=RetArr[1];
	if (Inv!="")
	{
		PrintInv(Inv)
	}
	$.messager.alert("提示","退费成功","success");
    $('#myWin').dialog('close'); ;
	$("#APACFindQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.APQuery",
			QueryName:"SearchAPACDetail",
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			Type:$("#Type").combobox('getValue'),
			CardType:$("#CardType").combobox('getValue'),
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			CTLocID:session['LOGON.CTLOCID']
			
			})
	
}

//获取当前发票号
function SetInvNo()
{ 
	var userId=session['LOGON.USERID'];
	var CTLocId=session['LOGON.CTLOCID'];
	//var ret=tkMakeServerCall("web.DHCPE.DHCPEPAY","getcurinvno",userId);
	var ret=tkMakeServerCall("web.DHCPE.DHCPEPAY","getcurinvno",userId,"N",CTLocId);
	
    var invNo=ret.split("^");
    if ((invNo[0]=="")||(invNo[1]=="")){ 
    	$.messager.alert('提示','没有正确的发票号',"info");
    	return false;		
    }
    	 		   
    if(invNo[2]!=""){var No=invNo[2]+""+invNo[0];}
    else {var No=invNo[0];}
    $("#CurInvNo").val(No);
   
    
    
}

//获取退费的发票信息
function FillPatientDatabyRowID(ID)
{
	
	var RowID=ID;  
    if (RowID==""){return false;}
	var Data=tkMakeServerCall("web.DHCPE.AdvancePayment","GetInfo",RowID);
	var DataArr=Data.split("^");
	if (DataArr[0]!=0)
	{
		$.messager.alert("提示",DataArr[0],"info");
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

//验证是否为浮点数
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
