
//����	DHCPEInvList.hisui.js
//����	�շ��վݲ�ѯ	
//����	2019.04.26
//������  xy

$(function(){
	
	
	InitCombobox();
	
	ElementEnble();
	
	InitInvListQueryTabDataGrid();
	
	   //�޸�
     $("#BModify").click(function() {	
		SaveForm();		
        });

	
	//��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
      
     
     //����
	$("#BReadCard").click(function() {	
		ReadCardClickHandle();		
        });
      
     
    //��ӡ�վ�֤��
	$("#BPrintProve").click(function() {	
		BPrintProve_click();		
        });
        
    //��ӡ�嵥
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
		 $("#BPrintList").css('display','none');//����
		 $("#BPrintProve").css('display','none');
		 
	}else if(ApplyFlag=="F"){
		$("#BPrintList").css('display','block');//��ʾ
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
		$.messager.popover({msg: "����Ч!", type: "info"});
		$("#CardNo").focus().val(CardNo);
		return false;
	}
}

//��ӡ�վ�֤��xml
function BPrintProveXML_click(){
	
	
	var PEINVDR=$('#RPFRowId').val();
	if(PEINVDR==""){
		$.messager.alert("��ʾ","��ѡ��Ҫ��ӡ�嵥�ļ�¼","info");
	    	return ;
	}
	
	
	var PrintData=tkMakeServerCall("web.DHCPE.CashierEx","GetProveInfoXML",PEINVDR);
	 if(parseInt(PrintData)<0){
		$.messager.alert("��ʾ",PrintData.split("^")[1],"info");
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

 //��ӡ�վ�֤��
function BPrintProve_click(){
	
	BPrintProveXML_click()
	return false; 

	
	var PEINVDR=$('#RPFRowId').val();
	if(PEINVDR==""){
		$.messager.alert("��ʾ","��ѡ��Ҫ��ӡ�嵥�ļ�¼","info");
	    	return ;
	}
	
	
	
	 var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
     var Templatefilepath=prnpath+'DHCPEProvePrt.xls';
	 var PrintData=tkMakeServerCall("web.DHCPE.CashierEx","GetProveInfo",PEINVDR);
	
		xlApp= new ActiveXObject("Excel.Application"); //�̶�
		xlBook= xlApp.Workbooks.Add(Templatefilepath); //�̶�
		xlsheet= xlBook.WorkSheets("Sheet1"); //Excel�±������
		var Char_3=String.fromCharCode(3);
		var Char_2=String.fromCharCode(2);
		var DataArr=PrintData.split(Char_3);
		var BaseInfo=DataArr[0];
		var BaseArr=BaseInfo.split("^");
		
		
		var Str="����ѯ"+BaseArr[0]+"ͬ־����Ժ�������վݺ�Ϊ"+BaseArr[1];
		var Length=Str.length
		if(Length>31) {
			var m=1;
			xlsheet.cells(5,3)=Str.substr(0,30);
			xlsheet.Rows(6).insert();
			 xlsheet.Range(xlsheet.Cells(6,2),xlsheet.Cells(6,8)).mergecells=true
			xlsheet.cells(6,2)=Str.substr(30,Length);
			
			
		}else{
			var m=0;
			xlsheet.cells(5,3)="����ѯ"+BaseArr[0]+"ͬ־����Ժ�������վݺ�Ϊ"+BaseArr[1];
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
		xlsheet.cells(Rows,4)="ʵ��";
		xlsheet.cells(Rows,6)=BaseArr[4];
		Rows=Rows+1;
		xlsheet.cells(Rows,4)="�ϼ�";
		xlsheet.cells(Rows,6)=BaseArr[3];
		Rows=Rows+1;
		xlsheet.cells(Rows,4)="��д";
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
		xlsheet.cells(Rows,2)="�ϼ�";
		xlsheet.cells(Rows,8)=BaseArr[4];
		Rows=Rows+3;
		xlsheet.cells(Rows,2)="�ش�֤��";
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


//��ӡ�嵥
function BPrintList_click(){
	
	var PEINVDR=$('#RPFRowId').val();
	if(PEINVDR==""){
		    $.messager.alert("��ʾ","��ѡ��Ҫ��ӡ�嵥�ļ�¼","info");
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



//��ѯ
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
		
		{field:'TModifyPaymode',title:'�޸�֧����ʽ',width:'100',hidden:ApplyFlag=="F"?true:false,align:'center',
			formatter:function(value,rowData,rowIndex){
				if((rowData.TInvNo.indexOf("��")==-1)&&(rowData.TFlag.indexOf("����")==-1)&&(rowData.TRPFlag=="��")){
					return "<span style='cursor:pointer;' class='icon-paid' title='�޸�֧����ʽ' onclick='BMPaymode_click(\"" + rowIndex + "\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>"
						
					
					return "<a href='#' onclick='BMPaymode_click(\""+rowIndex+"\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/change_pay_way.png' border=0/>\
					</a>";
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
			{field:'TPrintEInv',width:'160',title:'�Ƿ��ӡ���ӷ�Ʊ',align:'center',
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
            {field:'TEInvNo',width:'140',title:'����Ʊ�ݺ�'},
			{field:'TUser',width:'80',title:'�շ�Ա'},
			{field:'TInvDate',width:'150',title:'�շ�����'},
			{field:'TRPFlag',width:'80',title:'���˱�־',align:'center'},
			{field:'TRPDate',width:'120',title:'��������'},
			{field:'TDropDate',width:'100',title:'�˷�����'},
			{field:'TRInvNo',title:'���˷ѵķ�Ʊ��',hidden: true},
			{field:'TPayMode',width:'300',title:'֧����ʽ'},
			{field:'TRoundInfo',width:'80',title:'������',align:'right'},
			{field:'TInvName',width:'100',title:'��Ʊ����'},
			{field:'Tsswr',width:'80',title:'�ֱ����',align:'right'},
			{field:'TSex',width:'40',title:'�Ա�'},
			{field:'TAge',width:'40',title:'����'},
			{field:'TPosition',width:'80',title:'ְλ'}
			
			
					
		]],
		onSelect: function (rowIndex, rowData) {
			
			$('#RPFRowId').val(rowData.TRowId);
			//$('#RPFInvNo').val(rowData.TInvNo);
			if((rowData.TInvNo.indexOf("��")>=0)||(rowData.TFlag!="����")){
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

	// �ս���	
	var RPObj = $HUI.combobox("#RPFlag",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'Y',text:$g('��')},
            {id:'N',text:$g('��')} 
        ]

	}); 
	
	// ֧����ʽ	
	var InvPayModeObj = $HUI.combobox("#InvPayMode",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindTJPayMode&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'text',
		panelHeight:'200',
		})

	// ֧����ʽ	
	var PayModeObj = $HUI.combobox("#PayMode",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindTJPayMode&extFlag=1&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		})

	//��Ʊ״̬
	var InvStatusObj = $HUI.combobox("#InvStatus",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'����',text:$g('����')},
            {id:'����',text:$g('����')},
            {id:'���',text:$g('���')}
           
        ]

	}); 
   
    //����
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
			{field:'GBI_Desc',title:'����',width:150},
			{field:'GBI_Code',title:'����',width:100}
					
		]]
		});


}

/******************************************�޸�֧����ʽ����****************************************************/
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
		$.messager.alert("��ʾ","û��֧����Ϣ,����ͬһ���շ�Ա,���ܲ���","info");
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
		$.messager.alert("��ʾ","û��֧����Ϣ,����ͬһ���շ�Ա,���ܲ���","info");
		return false;
	}

	
	$("#myWin").show();
	 
	 $HUI.window("#myWin", {
        title: "�޸�֧����ʽ",
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
			title:'�޸�֧����ʽ',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'����',
				id:'save_btn',
				handler:function(){
					SaveForm()
				}
			},{
				text:'�ر�',
				handler:function(){
					myWin.close();
				}
			}]
		});
		*/
		$('#form-save').form("clear");
		InitInfo(InvNo);
		
		if((PayMode.indexOf("������")>=0)||(PayMode.indexOf("���Ԥ����")>=0)||(PayMode.indexOf("Ԥ����")>=0)){
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
		$.messager.alert("��ʾ","û��ѡ��ԭ֧����Ϣ","info");
		return false;
	}
	
	var PayMode=$("#PayMode").combobox('getValue');
	if (PayMode==""){
		$.messager.alert("��ʾ","û��ѡ��֧����ʽ","info");
		return false;
	}
	var OldPayMode=tkMakeServerCall("web.DHCPE.ModifyPayMode","GetOldPaymode",Info);
	if (OldPayMode==""){
		$.messager.alert("��ʾ","��ѡ��ԭ֧����Ϣ","info");
		return false;
	}
	var extFlag=tkMakeServerCall("web.DHCPE.ModifyPayMode","IsExtPayMode",OldPayMode);
	if(extFlag=="1"){
		$.messager.alert("��ʾ","���ܽ�������֧����ʽ�޸�Ϊ������ʽ","info");
		return false;
	}
	if(PayMode==OldPayMode)
	{
		$.messager.alert("��ʾ","��֧����ʽ��ԭ֧����ʽһ�£������޸�","info");
		return false;
	}

    var PayModeDesc=tkMakeServerCall("web.DHCPE.Cashier","GetPayModeDesc",PayMode);
	var No=$("#No").val();
	if(PayModeDesc.indexOf("֧Ʊ")>=0){

			if(No==""){
			$.messager.alert("��ʾ","������֧Ʊ��","info");
			return false;
			}
		}
	if((PayModeDesc.indexOf("������")>=0)||(PayModeDesc.indexOf("���Ԥ����")>=0)||(PayModeDesc.indexOf("Ԥ����")>=0)){ 
	  	$.messager.alert("��ʾ","�����޸�Ϊ��֧����ʽ����ѡ������֧����ʽ","info");
			return false;
	}


	var Info=tkMakeServerCall("web.DHCPE.ModifyPayMode","Update",Info,PayMode,No);
	if(Info==0){
		    $.messager.popover({msg: '���³ɹ���',type:'success',timeout: 1000});
		    BFind_click();
			$('#myWin').dialog('close'); 
	    }else{
		    $.messager.alert('������ʾ',"����ʧ��","error");
	    }
}


function GetOldPayMode(){
	    //ԭ֧����ʽ   
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
			{field:'PayInfo',title:'֧����Ϣ',width:200},
			
		]]
		});
}


function PayMode_change(){
	
	var Info=$("#OldPayMode").combogrid('getValue');
	
	var PayMode=tkMakeServerCall("web.DHCPE.ModifyPayMode","GetOldPaymode",Info);
	 var PayModeDesc=tkMakeServerCall("web.DHCPE.Cashier","GetPayModeDesc",PayMode);
	if((PayModeDesc.indexOf("������")>=0)||(PayModeDesc.indexOf("���Ԥ����")>=0)||(PayModeDesc.indexOf("Ԥ����")>=0)){
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
	if((PayModeDesc!="")&&(PayModeDesc.indexOf("֧Ʊ")>=0)){
		$("#No").attr('disabled',false);
	}else{
		
		$("#No").attr('disabled',true);
		$("#No").val("");
	}
	
}




