
//名称	DHCPEInvList.hisui.js
//功能	收费收据查询	
//创建	2019.04.26
//创建人  xy

$(function(){
	
	
	InitCombobox();
	
	ElementEnble();
	
	InitInvListQueryTabDataGrid();
	
	   //修改
     $("#BModify").click(function() {	
		SaveForm();		
        });

	
	//查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
      
     
     //读卡
	$("#BReadCard").click(function() {	
		ReadCardClickHandle();		
        });
      
     
    //打印收据证明
	$("#BPrintProve").click(function() {	
		BPrintProve_click();		
        });
        
    //打印清单
	$("#BPrintList").click(function() {	
		BPrintList_click();		
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
     
	$("#OldPayMode").combogrid({
			onSelect:function(){
			PayMode_change(); 
		}
	    }); 

    $("#PayMode").combobox({
			onSelect:function(){
			PayModeNew_change(); 
		}
	    }); 
    
})


function ElementEnble()
{
	
	if(ApplyFlag=="M"){
		 $("#BPrintList").css('display','none');//隐藏
		 $("#BPrintProve").css('display','none');
		 
	}else if(ApplyFlag=="F"){
		$("#BPrintList").css('display','block');//显示
		 $("#BPrintProve").css('display','block');
	}
}


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
 //读卡
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
		$.messager.popover({msg: "卡无效!", type: "info"});
		$("#CardNo").focus().val(CardNo);
		return false;
	}
}

//打印收据证明xml
function BPrintProveXML_click(){
	
	
	var PEINVDR=$('#RPFRowId').val();
	if(PEINVDR==""){
		$.messager.alert("提示","请选择要打印清单的记录","info");
	    	return ;
	}
	
	
	var PrintData=tkMakeServerCall("web.DHCPE.CashierEx","GetProveInfoXML",PEINVDR);
	 if(parseInt(PrintData)<0){
		$.messager.alert("提示",PrintData.split("^")[1],"info");
		return false
	 }
	 var Char_3=String.fromCharCode(3);
	 var DataArr=PrintData.split(Char_3);
	 var BaseInfo=DataArr[0];
	 var ItemFeeInfo=DataArr[2];
	 var TxtInfo=BaseInfo;
	 var ListInfo=ItemFeeInfo;
	 //alert("TxtInfo:"+TxtInfo)
	 //alert("ListInfo:"+ListInfo)
	 DHCP_GetXMLConfig("InvPrintEncrypt","PEInvProve");
	 //var myobj=document.getElementById("ClsBillPrint");
	 //DHCP_PrintFun(myobj,TxtInfo,ListInfo);
	 DHC_PrintByLodop(getLodop(),TxtInfo,ListInfo,"","{printListByText:true}");
	
}

 //打印收据证明
function BPrintProve_click(){
	
	BPrintProveXML_click()
	return false; 

	
	var PEINVDR=$('#RPFRowId').val();
	if(PEINVDR==""){
		$.messager.alert("提示","请选择要打印清单的记录","info");
	    	return ;
	}
	
	
	
	 var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
     var Templatefilepath=prnpath+'DHCPEProvePrt.xls';
	 var PrintData=tkMakeServerCall("web.DHCPE.CashierEx","GetProveInfo",PEINVDR);
	
		xlApp= new ActiveXObject("Excel.Application"); //固定
		xlBook= xlApp.Workbooks.Add(Templatefilepath); //固定
		xlsheet= xlBook.WorkSheets("Sheet1"); //Excel下标的名称
		var Char_3=String.fromCharCode(3);
		var Char_2=String.fromCharCode(2);
		var DataArr=PrintData.split(Char_3);
		var BaseInfo=DataArr[0];
		var BaseArr=BaseInfo.split("^");
		
		
		var Str="经查询"+BaseArr[0]+"同志在我院开出的收据号为"+BaseArr[1];
		var Length=Str.length
		if(Length>31) {
			var m=1;
			xlsheet.cells(5,3)=Str.substr(0,30);
			xlsheet.Rows(6).insert();
			 xlsheet.Range(xlsheet.Cells(6,2),xlsheet.Cells(6,8)).mergecells=true
			xlsheet.cells(6,2)=Str.substr(30,Length);
			
			
		}else{
			var m=0;
			xlsheet.cells(5,3)="经查询"+BaseArr[0]+"同志在我院开出的收据号为"+BaseArr[1];
		}
        
        xlsheet.cells(7+m,5)=BaseArr[2];
		var Rows=7+m;

		var CatInfo=DataArr[1];
		var CatArr=CatInfo.split(Char_2);
		var CatLength=CatArr.length;
		for (var i=0;i<CatLength;i++)
		{
			var OneCatInfo=CatArr[i];
			var OneArr=OneCatInfo.split("^");
			Rows=Rows+1;
			xlsheet.cells(Rows,4)=OneArr[0];
			xlsheet.cells(Rows,6)=OneArr[1];
		}
		Rows=Rows+1;
		xlsheet.cells(Rows,4)="实付";
		xlsheet.cells(Rows,6)=BaseArr[4];
		Rows=Rows+1;
		xlsheet.cells(Rows,4)="合计";
		xlsheet.cells(Rows,6)=BaseArr[3];
		Rows=Rows+1;
		xlsheet.cells(Rows,4)="大写";
		xlsheet.cells(Rows,6)=BaseArr[5];
		Rows=Rows+2;
		var ItemFeeInfo=DataArr[2];
		var ItemFeeArr=ItemFeeInfo.split(Char_2)
		var ItemFeeLength=ItemFeeArr.length;
		for (var i=0;i<ItemFeeLength;i++)
		{
			Rows=Rows+1;
			xlsheet.cells(Rows,1)=(i+1);
			var OneInfo=ItemFeeArr[i];
			var OneArr=OneInfo.split("^");
			xlsheet.cells(Rows,2)=OneArr[0];
			xlsheet.cells(Rows,5)=OneArr[1];
			xlsheet.cells(Rows,6)=OneArr[2];
			xlsheet.cells(Rows,7)=OneArr[3];
			xlsheet.cells(Rows,8)=OneArr[4];
		}
		Rows=Rows+1;
		xlsheet.cells(Rows,2)="合计";
		xlsheet.cells(Rows,8)=BaseArr[4];
		Rows=Rows+3;
		xlsheet.cells(Rows,2)="特此证明";
		xlsheet.cells(Rows+1,7)=BaseArr[6];
		var HosName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",session['LOGON.HOSPID'])
		xlsheet.cells(Rows,7)=HosName;
		xlsheet.cells(Rows,7).HorizontalAlignment=1;
		xlsheet.cells(Rows+1,7).HorizontalAlignment=1;

		xlsheet.printout;
		xlBook.Close (savechanges=false);
		xlApp=null;
		xlsheet=null;
	
}


//打印清单
function BPrintList_click(){
	
	var PEINVDR=$('#RPFRowId').val();
	if(PEINVDR==""){
		    $.messager.alert("提示","请选择要打印清单的记录","info");
	    	return ;
	}
	var peAdmType=tkMakeServerCall("web.DHCPE.Cashier","GetAdmType",PEINVDR);
	
	
	var listFlag=GetListFlag(peAdmType);
	var TxtInfo=tkMakeServerCall("web.DHCPE.Cashier","GetInvoiceInfo",peAdmType,PEINVDR,"List");
	var ListInfo=tkMakeServerCall("web.DHCPE.Cashier","GetInvoiceListInfo",peAdmType,PEINVDR,1,"1");
	//alert("TxtInfo:"+TxtInfo)
	//alert("ListInfo:"+ListInfo)
	
	DHCP_GetXMLConfig("InvPrintEncrypt","PEINVPRTLIST");
	//var myobj=document.getElementById("ClsBillPrint");
	//DHCP_PrintFun(myobj,TxtInfo,ListInfo);
	//DHC_PrintByLodop(getLodop(),TxtInfo,ListInfo,"","{printListByText:true}");
	var otherCfg={	
		printListByText:true,
		tdnowrap:true, 
	}	  
    DHC_PrintByLodop(getLodop(),TxtInfo,ListInfo,"","",otherCfg);

}

function GetListFlag(admtype)
{
	if (admtype!="I") return 0;
	var InvListFlag=tkMakeServerCall("web.DHCPE.HISUICommon","GetInvListFlag");
	if (InvListFlag=="1") return 1;
	return 0;
	
}



//查询
function BFind_click()
{
	var CTLocID=session['LOGON.CTLOCID'];

	$('#RPFRowId').val("");

	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",CTLocID);
	iRegNo=$("#RegNo").val();
	if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
		iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo,CTLocID);
		$("#RegNo").val(iRegNo)
	}

	 var iGroupID=$("#GDesc").combogrid('getValue');
	if (($("#GDesc").combogrid('getValue')==undefined)||($("#GDesc").combogrid('getValue')=="")){var iGroupID="";} 
	
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
			RPFlag:$("#RPFlag").combobox('getValue'),
			InvStatus:$("#InvStatus").combobox('getValue'),
			InvPayMode:$("#InvPayMode").combobox('getValue'),
			CashierStat:"",
			isApply:ApplyFlag,
			LocID:CTLocID,
            GroupID:iGroupID

			});
}


function InitInvListQueryTabDataGrid()
{
	
	$HUI.datagrid("#InvListQueryTab",{
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
			CardNo:$("#CardNo").val(),
			BeginDate:$("#BeginDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			RPFlag:$("#RPFlag").combogrid('getValue'),
			CashierStat:"",
			isApply:ApplyFlag,
			LocID:session['LOGON.CTLOCID']		
				
		},
		frozenColumns:[[
		
		{field:'TModifyPaymode',title:'修改支付方式',width:'100',hidden:ApplyFlag=="F"?true:false,align:'center',
			formatter:function(value,rowData,rowIndex){
				if((rowData.TInvNo.indexOf("退")==-1)&&(rowData.TFlag.indexOf("作废")==-1)&&(rowData.TRPFlag=="否")){
					return "<span style='cursor:pointer;' class='icon-paid' title='修改支付方式' onclick='BMPaymode_click(\"" + rowIndex + "\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>"
						
					
					return "<a href='#' onclick='BMPaymode_click(\""+rowIndex+"\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/change_pay_way.png' border=0/>\
					</a>";
				}
				}},
			{field:'TInvNo',width:'120',title:'发票号'},
			{field:'TPatName',width:'100',title:'姓名'},
			{field:'TRegNo',width:'100',title:'登记号'}
			
				]],
		columns:[[
		    {field:'TRowId',title:'TRowId',hidden: true},	
			{field:'TAmount',width:'80',title:'金额',align:'right'},
			{field:'TFlag',width:'60',title:'状态'},
			{field:'TPrintEInv',width:'160',title:'是否打印电子发票',align:'center',
           		formatter: function (value,rowData,rowIndex) {
	           	if(rowData.TRowId!=""){
					if(value=="0"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
	           	}
			}
            },
            {field:'TEInvNo',width:'140',title:'电子票据号'},
			{field:'TUser',width:'80',title:'收费员'},
			{field:'TInvDate',width:'150',title:'收费日期'},
			{field:'TRPFlag',width:'80',title:'结账标志',align:'center'},
			{field:'TRPDate',width:'120',title:'结账日期'},
			{field:'TDropDate',width:'100',title:'退费日期'},
			{field:'TRInvNo',title:'被退费的发票号',hidden: true},
			{field:'TPayMode',width:'300',title:'支付方式'},
			{field:'TRoundInfo',width:'80',title:'凑整费',align:'right'},
			{field:'TInvName',width:'100',title:'发票名称'},
			{field:'Tsswr',width:'80',title:'分币误差',align:'right'},
			{field:'TSex',width:'40',title:'性别'},
			{field:'TAge',width:'40',title:'年龄'},
			{field:'TPosition',width:'80',title:'职位'}
			
			
					
		]],
		onSelect: function (rowIndex, rowData) {
			
			$('#RPFRowId').val(rowData.TRowId);
			//$('#RPFInvNo').val(rowData.TInvNo);
			if((rowData.TInvNo.indexOf("退")>=0)||(rowData.TFlag!="正常")){
				$("#BPrintProve").linkbutton('disable');
				$("#BPrintList").linkbutton('disable');
				}else{
					$("#BPrintProve").linkbutton('enable');
					$("#BPrintList").linkbutton('enable');
					
					}

			

		}
			
	})
}


function InitCombobox()
{

	// 日结标记	
	var RPObj = $HUI.combobox("#RPFlag",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'Y',text:$g('是')},
            {id:'N',text:$g('否')} 
        ]

	}); 
	
	// 支付方式	
	var InvPayModeObj = $HUI.combobox("#InvPayMode",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindTJPayMode&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'text',
		panelHeight:'200',
		})

	// 支付方式	
	var PayModeObj = $HUI.combobox("#PayMode",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindTJPayMode&extFlag=1&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		})

	//发票状态
	var InvStatusObj = $HUI.combobox("#InvStatus",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'正常',text:$g('正常')},
            {id:'作废',text:$g('作废')},
            {id:'冲红',text:$g('冲红')}
           
        ]

	}); 
   
    //团体
	var GDescObj = $HUI.combogrid("#GDesc",{
		panelWidth:430,
		url:$URL+"?ClassName=web.DHCPE.PreGBaseInfo&QueryName=SearchGListByDesc",
		mode: 'remote',  
		delay:200,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
		idField:'GBI_RowId',
		textField:'GBI_Desc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
		},
		onShowPanel:function()
		{
			$('#GDesc').combogrid('grid').datagrid('reload');
		},
		columns:[[
			{field:'GBI_RowId',title:'ID',width:30},
			{field:'GBI_Desc',title:'名称',width:150},
			{field:'GBI_Code',title:'编码',width:100}
					
		]]
		});


}

/******************************************修改支付方式弹窗****************************************************/
function InitInfo(InvNo)
{
	$('#WInvNo').val(InvNo);
	if((InvNo!="")&&(InvNo.indexOf("(")>=0)){
		var InvNo=(InvNo.split("(")[1]).split(")")[0];
	}
	var User=session['LOGON.USERID'];
	var Info=tkMakeServerCall("web.DHCPE.ModifyPayMode","GetInvInfoByInvNo",InvNo,"",User);
	if ((Info=="NoData")||(Info=="NoRefData")||(Info=="HadReport")||(Info=="UserNotOne")){
		
		//alert(t[Info]);
		$.messager.alert("提示","没有支付信息,或不是同一个收费员,不能操作","info");
		return false;
	}else{
		var Arr=Info.split("^");
		$("#WName").val(Arr[0]);
		$("#WAmount").val(Arr[1]);
		var PayModeInfo=Arr[2];
		
	}
}

function BMPaymode_click(selectrow)
{
	var objtbl = $("#InvListQueryTab").datagrid('getRows');
	var InvNo=objtbl[selectrow].TInvNo;
	if((InvNo!="")&&(InvNo.indexOf("(")>=0)){
		var InvNo=(InvNo.split("(")[1]).split(")")[0];
	}
	var InvID=objtbl[selectrow].TRowId;
	var PayMode=objtbl[selectrow].TPayMode;
	var User=session['LOGON.USERID'];
	var Info=tkMakeServerCall("web.DHCPE.ModifyPayMode","GetInvInfoByInvNo",InvNo,"",User);
	if ((Info=="NoData")||(Info=="NoRefData")||(Info=="HadReport")||(Info=="UserNotOne")){
		$.messager.alert("提示","没有支付信息,或不是同一个收费员,不能操作","info");
		return false;
	}

	
	$("#myWin").show();
	 
	 $HUI.window("#myWin", {
        title: "修改支付方式",
        iconCls: "icon-w-edit",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        modal: true,
       
       
    });
	 
	 /*
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-edit',
			resizable:true,
			title:'修改支付方式',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				id:'save_btn',
				handler:function(){
					SaveForm()
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]
		});
		*/
		$('#form-save').form("clear");
		InitInfo(InvNo);
		
		if((PayMode.indexOf("体检代金卡")>=0)||(PayMode.indexOf("体检预交金")>=0)||(PayMode.indexOf("预交金")>=0)){
        $("#PayMode").combobox("disable"); 
	}else{
		$("#PayMode").combobox("enable");
	}
		GetOldPayMode();
		
	    
}


SaveForm=function()
{
	var Info=$("#OldPayMode").combogrid('getValue');
	if (($("#OldPayMode").combogrid('getValue')==undefined)||($("#OldPayMode").combogrid('getText')=="")){var Info="";}
	
	if (Info==""){
		$.messager.alert("提示","没有选择原支付信息","info");
		return false;
	}
	
	var PayMode=$("#PayMode").combobox('getValue');
	if (PayMode==""){
		$.messager.alert("提示","没有选择支付方式","info");
		return false;
	}
	var OldPayMode=tkMakeServerCall("web.DHCPE.ModifyPayMode","GetOldPaymode",Info);
	if (OldPayMode==""){
		$.messager.alert("提示","请选择原支付信息","info");
		return false;
	}
	var extFlag=tkMakeServerCall("web.DHCPE.ModifyPayMode","IsExtPayMode",OldPayMode);
	if(extFlag=="1"){
		$.messager.alert("提示","不能将第三方支付方式修改为其他方式","info");
		return false;
	}
	if(PayMode==OldPayMode)
	{
		$.messager.alert("提示","现支付方式与原支付方式一致，无需修改","info");
		return false;
	}

    var PayModeDesc=tkMakeServerCall("web.DHCPE.Cashier","GetPayModeDesc",PayMode);
	var No=$("#No").val();
	if(PayModeDesc.indexOf("支票")>=0){

			if(No==""){
			$.messager.alert("提示","请输入支票号","info");
			return false;
			}
		}
	if((PayModeDesc.indexOf("体检代金卡")>=0)||(PayModeDesc.indexOf("体检预交金")>=0)||(PayModeDesc.indexOf("预交金")>=0)){ 
	  	$.messager.alert("提示","不能修改为该支付方式，请选择其它支付方式","info");
			return false;
	}


	var Info=tkMakeServerCall("web.DHCPE.ModifyPayMode","Update",Info,PayMode,No);
	if(Info==0){
		    $.messager.popover({msg: '更新成功！',type:'success',timeout: 1000});
		    BFind_click();
			$('#myWin').dialog('close'); 
	    }else{
		    $.messager.alert('操作提示',"更新失败","error");
	    }
}


function GetOldPayMode(){
	    //原支付方式   
		var OldPayModeObj = $HUI.combogrid("#OldPayMode",{
		panelWidth:210,
		panelHeight:100,
		url:$URL+"?ClassName=web.DHCPE.ModifyPayMode&QueryName=FindOldPayMode",
		mode:'remote',
		delay:200,
		idField:'ARCCPayModeDR',
		textField:'PayInfo',
		onBeforeLoad:function(param){
			var InvID=$('#RPFRowId').val();
			param.InvID = InvID; 
		
		},
		onShowPanel:function()
		{
			$('#OldPayMode').combogrid('grid').datagrid('reload');
		},
		columns:[[
			{field:'ARCCPayModeDR',title:'ARCCID',hidden: true},
			{field:'PayModeID',title:'ID',hidden: true},
			{field:'PayInfo',title:'支付信息',width:200},
			
		]]
		});
}


function PayMode_change(){
	
	var Info=$("#OldPayMode").combogrid('getValue');
	
	var PayMode=tkMakeServerCall("web.DHCPE.ModifyPayMode","GetOldPaymode",Info);
	 var PayModeDesc=tkMakeServerCall("web.DHCPE.Cashier","GetPayModeDesc",PayMode);
	if((PayModeDesc.indexOf("体检代金卡")>=0)||(PayModeDesc.indexOf("体检预交金")>=0)||(PayModeDesc.indexOf("预交金")>=0)){
        $("#PayMode").combobox("disable"); 
	}else{
		$("#PayMode").combobox("enable");
		$("#No").val("");
	}
}


function PayModeNew_change()
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




