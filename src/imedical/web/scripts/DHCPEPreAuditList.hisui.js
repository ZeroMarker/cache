//
//����	DHCPEPreAuditList.hisui.js
//����	����hisui
//����	2019.11.6
//������  xy

$(function(){
	
	InitCombobox();
	
	InitPreAuditListGrid();
	
	InitFeeListLefGrid();
	
	InitFeeListRightGrid();
	  
	SetButtonDisabl("","","");  
	
     //����
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });  
     
     //���
	$("#BAudit").click(function() {	
		BAudit_click();			
       });
       
    //���֧�� 
    $("#BAsCharged").click(function() {	
		BAsCharged_click();		
        });  
     $("#BSplit").click(function() {	
		BSplit_click();			
       });
	
	//�������
	 $("#BUnAsCharged").click(function() {	
		BUnAsCharged_click();		
        });  
     
	//�Ż���ʽ
	$("#privilegeMode").combobox({
       onSelect:function(){
			PrivilegeMode_change();
	}
	});
	
	//�������
	$("#SplitType").combobox({
       onSelect:function(){
			SplitType_change();
	}
	});
	
	
	
	//ȫѡ�Ǽ�  
	$('#SelectR').checkbox({
		onCheckChange:function(e,vaule){
			SelectR_clicked(vaule);
			
			}
			
	});
	
	//ȫѡ����
	$('#SelectA').checkbox({
		onCheckChange:function(e,vaule){
			SelectA_clicked(vaule);
			
			}
			
	});
	
	
	//�ƶ�ѡ����(����)
    $("#MoveToR").click(function() {	
		BMoveToR_click();		
        }); 
        
    //�ƶ�������(����)
    $("#MoveAllToR").click(function() {	
		BMoveAllToR_click();		
        }); 
        
     //�ƶ�ѡ����(����)
    $("#MoveToL").click(function() {	
		BMoveToL_click();		
        }); 
        
    //�ƶ�������(����)
    $("#MoveAllToL").click(function() {	
		BMoveAllToL_click();		
        }); 
        
	$("#Name").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_Click();
			}
			
        });    
         
	$("#BFind").click(function() {
			
			BFind_Click();	
			
        });
   
     init();
	
})
function BSplit_click()
{
	var PreStatus="",DepartName="",PreAuditID="",SplitAmt="";
	
	var SplitAmt=getValueById("SplitAmt");
	if(SplitAmt==""){
		$.messager.alert("��ʾ","�������ֽ��","info");
		return false;
	}

	var FactAmount=$("#FactAmount").val();
	if(+SplitAmt<=0){
			$.messager.alert("��ʾ","��ֽ��Ӧ����0","info");
			return false;
	}
	if(+SplitAmt>=+FactAmount){
		$.messager.alert("��ʾ","��ֽ��ӦС�����ս��","info");
		return false;
	}
	
	
	var PreAuditID=$("#RowID").val();
	
	var ret=tkMakeServerCall("web.DHCPE.PreAuditEx","SplitAudit",PreAuditID,ADMType,CRMADM,PreStatus,DepartName+"^"+SplitAmt);
	
	var Arr=ret.split("^");
	if (Arr[0]!="0"){
		$.messager.alert("��ʾ","���ʧ��:"+Arr[1],"error");
		return false;
	}else{
	
		$("#RowID").val("");
		$('#PreAuditListTab').datagrid('load', {
			ClassName:"web.DHCPE.PreAudit",
			QueryName:"SerchPreAudit",
			CRMADM:CRMADM,
			ADMType:ADMType,
			GIADM:GIADM,
		
		});
	}
	
}
function init()
{
	//Ĭ�ϲ������Ϊ"��Ա"
	if(ADMType=="G"){
		$("#SplitType").combobox('setValue',"person"); 
	}else if(ADMType=="I"){
		$("#SplitType").combobox('setValue',"item"); 
		$("#SplitType").combobox("disable");
	}

	$("#SelectR").checkbox("enable");
	$("#SelectA").checkbox("enable");
	$("#Name").attr('disabled',false);
	$("#ARCIMDesc").combogrid("disable");
	$("#SetDesc").combogrid("disable");
}

function BFind_Click(){
		
	 
     var iARCIMID=$("#ARCIMDesc").combogrid('getValue');
     if (($("#ARCIMDesc").combogrid('getValue')==undefined)||($("#ARCIMDesc").combogrid('getValue')=="")){var iARCIMID="";}
     var iOrdSetID=getValueById("OrdSetID");
     var iOrdSetID=$("#SetDesc").combogrid('getValue');
     if (($("#SetDesc").combogrid('getValue')==undefined)||($("#SetDesc").combogrid('getValue')=="")){var iOrdSetID="";}
	 var auditid=$("#AuditID").val();
	
	if($("#SplitType").combobox('getValue')=="item"){
	   var ItemNameTitle="��Ŀ����";
   }else{
	   var ItemNameTitle="״̬";
   }
   
   $HUI.datagrid("#FeeListLeftGrid",{
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
		singleSelect:false,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.ItemFeeList",
			QueryName:"FindItemFeeList",
			SplitType:$("#SplitType").combobox('getValue'),
			InvPrtId:"", 
			PreAudits:auditid,
			SelectIds:"",
			ReadOnlyFlag:"", 
			ADMType:"", 
			GIADM:"", 
			ARCIMID:iARCIMID, 
			OrdSetID:iOrdSetID, 
			Name:$("#Name").val(),		
		},
		frozenColumns:[[
			{title:'ѡ��',field:'Select',width:60,checkbox:true},
			{title:'FeeType',field:'FeeType',hidden:true},
			{field:'FeeTypeDesc',width:50,title:'���'},
			{field:'ItemName',width:120,title:ItemNameTitle},
			{field:'PatName',width:100,title:'����'},
						 
		]],
		columns:[[
		    {field:'RowId',title:'TRowId',hidden:true},
			{field:'FactAmount',width:120,title:'���۽��',align:'right'},
			{field:'PrivilegeMode',width:100,title:'�Ż���ʽ'},	
			{field:'OrdStatusDesc',width:100,title:'ִ��״̬'},		
				
		]],
		
			
	})
   /*
	$('#FeeListLeftGrid').datagrid('load', {
				ClassName:"web.DHCPE.ItemFeeList",
				QueryName:"FindItemFeeList",
				SplitType:$("#SplitType").combobox('getValue'),
				InvPrtId:"", 
				PreAudits:auditid,
				SelectIds:"",
				ReadOnlyFlag:"", 
				ADMType:"", 
				GIADM:"", 
				ARCIMID:iARCIMID, 
				OrdSetID:iOrdSetID, 
				Name:$("#Name").val(),	
		
			});
			
    */
    
	
}
//�ƶ�ѡ����(����)
function BMoveToR_click()
{
	var allFlag=0;
	var feeItems=GetFeeItemInfo("FeeListLeftGrid");
	var auditid=$("#AuditID").val();
	var toAuditid="";
	Move(auditid,toAuditid,allFlag,feeItems,1);
}

//�ƶ�������(����)
function BMoveAllToR_click()
{
	var allFlag=1;
	var feeItems=GetFeeItemInfo("FeeListLeftGrid");
	var auditid=$("#AuditID").val();
	var toAuditid="";
	var objtbl=$("#FeeListLeftGrid").datagrid('getRows');
    var rows=objtbl.length;
	if(rows==""){
		$.messager.alert("��ʾ","��û�п��ƶ���","info");
 	   return false;
  }

	Move(auditid,toAuditid,allFlag,feeItems,1);
}

//�ƶ�ѡ����(����)
function BMoveToL_click()
{
	var allFlag=0;
	var feeItems=GetFeeItemInfo("FeeListRightGrid");
	var auditid=$("#ToAuditID").val();
	var toAuditid=$("#AuditID").val();
	Move(auditid,toAuditid,allFlag,feeItems,0);
}

//�ƶ�������(����)
function BMoveAllToL_click()
{
	var allFlag=1;
	var feeItems=GetFeeItemInfo("FeeListRightGrid");
	var auditid=$("#ToAuditID").val();
	var toAuditid=$("#AuditID").val();
	Move(auditid,toAuditid,allFlag,feeItems,0);
}

function GetFeeItemInfo(frameName)
{
	var SelectIds="";
	var RowIDs="";
	var selectrow = $("#"+frameName).datagrid("getChecked");//��ȡ�������飬��������
	
	for(var i=0;i<selectrow.length;i++){
		var itemfeeid=selectrow[i].RowId;
		var itemfeetype=selectrow[i].FeeType;
		var itemfeeinfos="";
		if ((""!=itemfeeid)&&(""!=itemfeetype)) itemfeeinfos=itemfeeid+","+itemfeetype;
			if((""!=itemfeeid)&&(""==itemfeetype)) itemfeeinfos=itemfeeid;
			   if (RowIDs=="") RowIDs=RowIDs+"^"		
			RowIDs=RowIDs+itemfeeinfos+"^";
	}
	return RowIDs
	
}



function Move(auditid,toAuditid,allFlag,feeItems,isLToR)
{
	//alert("auditid:"+auditid+"  toAuditid:"+toAuditid+"  allFlag:"+allFlag+"  feeItems:"+feeItems);
	
	//if ((auditid=="")||((feeItems=="")&&(allFlag==0))||((feeItems=="^")&&(allFlag==0))||((allFlag==1)&&(feeItems=="")))
	if ((auditid=="")||((feeItems=="")&&(allFlag==0))||((feeItems=="^")&&(allFlag==0)))
	{	
		$.messager.alert("��ʾ","��ѡ��Ҫת�Ƶ���ϸ!","info");
		return;
	}
	
	var result=tkMakeServerCall("web.DHCPE.ItemFeeList","MoveItemFee","","",auditid,toAuditid,allFlag,feeItems)
	
	if (isNaN(result)==true){
			$.messager.alert("��ʾ",result,"info");
		   return false;

	}
	else
	{
		
		$.messager.alert("��ʾ","���³ɹ�","success");
		
		if($("#SplitType").combobox('getValue')=="item"){
	       var ItemNameTitle="��Ŀ����";
        }else{
	       var ItemNameTitle="״̬";
       }
	   
	     if (1==isLToR) {
		       $("#ToAuditID").val(result);
		       $("#AuditID").val(auditid);
			$('#FeeListLeftGrid').datagrid('load', {
				ClassName:"web.DHCPE.ItemFeeList",
				QueryName:"FindItemFeeList",
				SplitType:$("#SplitType").combobox('getValue'),
				InvPrtId:"", 
				PreAudits:auditid,
				SelectIds:"",
				ReadOnlyFlag:"", 
				ADMType:"", 
				GIADM:"", 
				ARCIMID:"", 
				OrdSetID:"", 
				Name:"",	
		
			});
		$HUI.datagrid("#FeeListRightGrid",{
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
		singleSelect:false,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.ItemFeeList",
			QueryName:"FindItemFeeList",
			SplitType:$("#SplitType").combobox('getValue'),
			InvPrtId:"", 
			PreAudits:result,
			SelectIds:"",
			ReadOnlyFlag:"", 
			ADMType:"", 
			GIADM:"", 
			ARCIMID:"", 
			OrdSetID:"", 
			Name:"",			
		},
		frozenColumns:[[
			{title:'ѡ��',field:'Select',width:60,checkbox:true},
			{title:'FeeType',field:'FeeType',hidden:true},
			{field:'FeeTypeDesc',width:50,title:'���'},
			{field:'ItemName',width:120,title:ItemNameTitle},
			{field:'PatName',width:100,title:'����'},
						 
		]],
		columns:[[
		    {field:'RowId',title:'TRowId',hidden:true},
			{field:'FactAmount',width:120,title:'���۽��',align:'right'},
			{field:'PrivilegeMode',width:100,title:'�Ż���ʽ'},	
			{field:'OrdStatusDesc',width:100,title:'ִ��״̬'},		
				
		]],
		
			
	});
			
	     }else{
		       
		       $("#AuditID").val(result);
		       $("#ToAuditID").val(auditid);
		       //alert("result:"+result+"auditid:"+auditid)
		       
		     	$('#FeeListLeftGrid').datagrid('load', {
				ClassName:"web.DHCPE.ItemFeeList",
				QueryName:"FindItemFeeList",
				SplitType:$("#SplitType").combobox('getValue'),
				InvPrtId:"", 
				PreAudits:result,
				SelectIds:"",
				ReadOnlyFlag:"", 
				ADMType:"", 
				GIADM:"", 
				ARCIMID:"", 
				OrdSetID:"", 
				Name:"",	
		
			});
		$HUI.datagrid("#FeeListRightGrid",{
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
		singleSelect:false,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.ItemFeeList",
			QueryName:"FindItemFeeList",
			SplitType:$("#SplitType").combobox('getValue'),
			InvPrtId:"", 
			PreAudits:auditid,
			SelectIds:"",
			ReadOnlyFlag:"", 
			ADMType:"", 
			GIADM:"", 
			ARCIMID:"", 
			OrdSetID:"", 
			Name:"",		
		},
		frozenColumns:[[
			{title:'ѡ��',field:'Select',width:60,checkbox:true},
			{title:'FeeType',field:'FeeType',hidden:true},
			{field:'FeeTypeDesc',width:50,title:'���'},
			{field:'ItemName',width:120,title:ItemNameTitle},
			{field:'PatName',width:100,title:'����'},
						 
		]],
		columns:[[
		    {field:'RowId',title:'TRowId',hidden:true},
			{field:'FactAmount',width:120,title:'���۽��',align:'right'},
			{field:'PrivilegeMode',width:100,title:'�Ż���ʽ'},	
			{field:'OrdStatusDesc',width:100,title:'ִ��״̬'},		
				
		]],
		
			
	});
			
	     }
			$('#PreAuditListTab').datagrid('load', {
			ClassName:"web.DHCPE.PreAudit",
			QueryName:"SerchPreAudit",
			CRMADM:CRMADM,
			ADMType:ADMType,
			GIADM:GIADM,
		
		});
	
}
}

function SelectR_clicked(vaule)
{

	Select("R",vaule);
}
function SelectA_clicked(vaule)
{

	Select("A",vaule);
}

function Select(Type,value)
{
	if (value==true) 
	{
		var SelectAll=1;
	}
	else
	{ 
		var SelectAll=0;
	}
	var objtbl=$("#FeeListLeftGrid").datagrid('getRows');
    var rows=objtbl.length;
    
    for (var i=0;i<rows;i++)
    {
	
     	var Status=objtbl[i].ItemName;
     	 var objCheck=$(".datagrid-row[datagrid-row-index="+i+"] td[field="+"Select"+"] input")
     	if ((Type=="A")&&(Status=="����")) {
	    	if (objCheck.attr("type")=="checkbox") {
				objCheck.prop("checked",SelectAll);
	    	}
	     }
		if ((Type=="R")&&(Status=="�Ǽ�")) {
	    	if (objCheck.attr("type")=="checkbox") {
				objCheck.prop("checked",SelectAll);
	    	}
		}
	
     
	}
	
}

var ItemNameTitle="״̬";

function SplitType_change(){
   if($("#SplitType").combobox('getValue')=="item"){
	   var ItemNameTitle="��Ŀ����";
   }else{
	   var ItemNameTitle="״̬";
   }
  
	/*$('#FeeListLeftGrid').datagrid('load', {
			ClassName:"web.DHCPE.ItemFeeList",
			QueryName:"FindItemFeeList",
			SplitType:$("#SplitType").combobox('getValue'),
			InvPrtId:"", 
			PreAudits:$("#AuditID").val(),
			SelectIds:"",
			ReadOnlyFlag:"", 
			 ADMType:"", 
			 GIADM:"", 
			ARCIMID:"", 
			OrdSetID:"", 
			Name:"",
		
		});
		*/
	$HUI.datagrid("#FeeListLeftGrid",{
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
		singleSelect:false,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.ItemFeeList",
			QueryName:"FindItemFeeList",
			SplitType:$("#SplitType").combobox('getValue'),
			InvPrtId:"", 
			PreAudits:$("#AuditID").val(),
			SelectIds:"",
			ReadOnlyFlag:"", 
			 ADMType:"", 
			 GIADM:"", 
			ARCIMID:"", 
			OrdSetID:"", 
			Name:"",
			
			
		},
		frozenColumns:[[
			{title:'ѡ��',field:'Select',width:60,checkbox:true},
			{title:'FeeType',field:'FeeType',hidden:true},
			{field:'FeeTypeDesc',width:50,title:'���'},
			{field:'ItemName',width:120,title:ItemNameTitle},
			{field:'PatName',width:100,title:'����'},
						 
		]],
		columns:[[
		    {field:'RowId',title:'TRowId',hidden:true},
			{field:'FactAmount',width:120,title:'���ս��',align:'right'},
			{field:'PrivilegeMode',width:100,title:'�Ż���ʽ'},	
			{field:'OrdStatusDesc',width:100,title:'ִ��״̬'},		
				
		]],
		
			
	})
	
   if($("#SplitType").combobox('getValue')=="person"){
	    $("#SelectR").checkbox("enable");
	    $("#SelectA").checkbox("enable");
	    $("#Name").attr('disabled',false);
   }else{
	   $("#SelectR").checkbox("setValue",false);
	   $("#SelectA").checkbox("setValue",false);
	   $("#SelectR").checkbox("disable");
	   $("#SelectA").checkbox("disable");
	   $("#Name").val("")
	   $("#Name").attr('disabled',true);
   }

	if($("#SplitType").combobox('getValue')=="item"){
		$("#ARCIMDesc").combogrid("enable");
		$("#SetDesc").combogrid("enable");
	}else{
		$("#ARCIMDesc").combogrid("setValue","");
		$("#SetDesc").combogrid("setValue","");
		$("#ARCIMDesc").combogrid("disable");
		$("#SetDesc").combogrid("disable");
	}

$HUI.datagrid("#FeeListRightGrid",{
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
		singleSelect:false,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		toolbar: [] ,
		queryParams:{
			ClassName:"web.DHCPE.ItemFeeList",
			QueryName:"FindItemFeeList",
			SplitType:"",
			InvPrtId:"", 
			PreAudits:"",
			SelectIds:"",
			ReadOnlyFlag:"", 
			 ADMType:"", 
			 GIADM:"", 
			ARCIMID:"", 
			OrdSetID:"", 
			Name:"",	
			
		},
		frozenColumns:[[
			{title:'ѡ��',field:'Select',width: 60,checkbox:true},
			{title:'FeeType',field:'FeeType',hidden:true},
			{field:'FeeTypeDesc',width:50,title:'���'},
			{field:'ItemName',width:120,title:ItemNameTitle},
			{field:'PatName',width:100,title:'����'},
		]],
		columns:[[
		    {field:'RowId',title:'TRowId',hidden:true},
			{field:'FactAmount',width:120,title:'���ս��',align:'right'},
			{field:'PrivilegeMode',width:100,title:'�Ż���ʽ'},	
			{field:'OrdStatusDesc',width:100,title:'ִ��״̬'},			
			
		]],
		onSelect: function (rowIndex, rowData) {
										
		}		
	})
	
}
//���
function BAudit_click()
{
	//if($("#BAudit").linkbutton('options').disabled==true){return;}
	var Type="CancelAudited";
	if($.trim($("#BAudit").text())=="���"){	
		Type="Audited";
		}
	
	AuditUpdate(Type,"");
}

//����
function BUpdate_click()
{
	//if($("#BUpdate").linkbutton('options').disabled==true){return;}
	var InfoStr=""
	var Rebate=$("#Rebate").val();
    var PrivilegeMode=$("#privilegeMode").combobox('getValue');
    var AccountAmount=$("#AccountAmount").val();
	var yikoujia=$("#SaleAmount").val();
	 if (PrivilegeMode=="OS"){
		
		if (yikoujia=="") {
			
			$.messager.alert("��ʾ","���۽���Ϊ��","info");
			return false;
		}
        if (yikoujia<=0) {
			
			$.messager.alert("��ʾ","���۽��Ӧ����0","info");
			return false;
		}
		if((yikoujia.indexOf(".")!="-1")&&(yikoujia.toString().split(".")[1].length>2))
		{
			$.messager.alert("��ʾ","���۽��С������ܳ�����λ","info");
			return false;
		}

		
		var Rebate=(yikoujia/AccountAmount)*100
		Rebate= Rebate.toFixed(4)
	
		}
		else{
			$("#SaleAmount").val("");
			}

	InfoStr=InfoStr+"^"+Rebate;
	InfoStr=InfoStr+"^"+$("#SaleAmount").val();
	FactAmount=$("#FactAmount").val();
	InfoStr=InfoStr+"^"+FactAmount;
	InfoStr=InfoStr+"^"+$("#Remark").val();
	InfoStr=InfoStr+"^"+PrivilegeMode;
	if (PrivilegeMode=="OR")
	{
		if (Rebate=="")
		{
			$.messager.alert("��ʾ","�ۿ��ʲ���Ϊ��","info");
			websys_setfocus('FactAmount');
			return;
		}
		if(Rebate>100)
		{
			$.messager.alert("��ʾ","�ۿ��ʲ��ܴ���100","info");
	     	return;
		}
		if(Rebate<0)
		{
			$.messager.alert("��ʾ","�ۿ��ʲ���С��0","info");
	     	return;
		}

	var userId=session['LOGON.USERID'];
	
	var ReturnStr=tkMakeServerCall("web.DHCPE.ChargeLimit","DFLimit",userId)
	var DFLimit=ReturnStr;
	if (DFLimit==0){
		$.messager.alert("��ʾ","û�д���Ȩ��","info");
	     return;
	    }
    if(+DFLimit>+Rebate){
	   $.messager.alert("��ʾ","Ȩ�޲���,�����ۿ�Ȩ��Ϊ:"+DFLimit+"%","info");
		return;
		}
	}
	if (PrivilegeMode=="TP")
	{
		if (FactAmount=="")
		{
			$.messager.alert("��ʾ","���ս���Ϊ��","info");
			websys_setfocus('FactAmount');
			return;
		}
	}
	
	AuditUpdate("Update",InfoStr);
	
}
function AuditUpdate(Type,DataStr)
{
	var RowID=$("#RowID").val();
	if (RowID=="") {
		$.messager.alert("��ʾ","����ѡ���¼","info");
		return;
		}
	var Flag=tkMakeServerCall("web.DHCPE.PreAudit","UpdatePreAudit",Type,RowID,DataStr)
	if (Flag!=0){
		$.messager.alert("��ʾ","����ʧ��"+Flag,"error");
		return;
	}else{
		$.messager.alert("��ʾ","���³ɹ�","success");
		$("#RowID").val("");
		$('#PreAuditListTab').datagrid('load', {
			ClassName:"web.DHCPE.PreAudit",
			QueryName:"SerchPreAudit",
			CRMADM:CRMADM,
			ADMType:ADMType,
			GIADM:GIADM,
		
		});
	}
	
	
	
}

function BAsCharged_click()
{
	//if($("#BAsCharged").linkbutton('options').disabled==true){return;}
	var userId="",RowID="",obj,encmeth="",ChargedType="",ChargedRemark="";
	var userId=session['LOGON.USERID'];
	var RowID=$("#RowID").val();
	if (RowID=="") {
		$.messager.alert("��ʾ","����ѡ����˼�¼","info");
		return false;
	}
	
	var ChargedType=$("#ChargedType").combobox('getValue');
	var ChargedRemark=$("#ChargedRemark").text();	
	var RowID=RowID+"^"+ChargedType+"^"+ChargedRemark;
	var ret=tkMakeServerCall("web.DHCPE.PreAudit","AsCharged",RowID,userId)
	
	var Arr=ret.split("^");
	if (Arr[0]=="-1"){
		$.messager.alert("��ʾ",Arr[1],"info");
		return false;
	}else{
		$.messager.alert("��ʾ","���³ɹ�","success");
		$("#RowID").val("");
		$('#PreAuditListTab').datagrid('load', {
			ClassName:"web.DHCPE.PreAudit",
			QueryName:"SerchPreAudit",
			CRMADM:CRMADM,
			ADMType:ADMType,
			GIADM:GIADM,
		
		});
		
	}
	
}
function BUnAsCharged_click()
{
	
	//if($("#BUnAsCharged").linkbutton('options').disabled==true){return;}
	var userId=session['LOGON.USERID'];
	var RowID=$("#RowID").val();
	if (RowID=="") {
		$.messager.alert("��ʾ","����ѡ����˼�¼","info");
		return false;
	}
	
	var ret=tkMakeServerCall("web.DHCPE.PreAudit","UnAsCharged",RowID)
	
	var Arr=ret.split("^");
	if (Arr[0]=="-1"){
		$.messager.alert("��ʾ",Arr[1],"info");
		return false;
	}else{
		$.messager.alert("��ʾ","���³ɹ�","success");
		$("#RowID").val("");
			$('#PreAuditListTab').datagrid('load', {
			ClassName:"web.DHCPE.PreAudit",
			QueryName:"SerchPreAudit",
			CRMADM:CRMADM,
			ADMType:ADMType,
			GIADM:GIADM,
		
		});
	}
}
function SetButtonDisabl(RowID,Audit,Charged,AsCharged,AccountAmount)
{
	//alert(Audit+"^"+Charged)
	$("#BAudit").linkbutton({text:'���'})
	$("#SaleAmount").attr('disabled',true);
	$("#Rebate").attr('disabled',true);
	if (RowID=="")
	{
		$("#BUpdate").linkbutton('disable');
		$("#BAudit").linkbutton('disable');
		$("#BAsCharged").linkbutton('disable');
		$("#BUnAsCharged").linkbutton('disable');
		$("#BSplit").linkbutton('disable');
		return;
	}
	else
	{	
	
		if (Charged=="CHARGED")
		{
			$("#BUpdate").linkbutton('disable');
			$("#BAudit").linkbutton('disable');
			$("#BAsCharged").linkbutton('disable');
			$("#BSplit").linkbutton('disable');
			if(AsCharged=="Y"){
				$("#BUnAsCharged").linkbutton('enable');
			}else{
				$("#BUnAsCharged").linkbutton('disable');
			}
			return;
		}
		
		if (Audit=="Audited")
		{
			$("#BAudit").linkbutton({text:'ȡ�����'})
			
			$("#BUpdate").css({"width":"115px"});
			$("#BUpdate").linkbutton('disable');
			$("#BAudit").linkbutton('enable');
			$("#BAsCharged").linkbutton('disable');
			$("#BUnAsCharged").linkbutton('disable');
			$("#BSplit").linkbutton('disable');
			return;
		}
		
		$("#BUpdate").css({"width":"88px"});
 		$("#BUpdate").linkbutton('enable');
		$("#BAudit").linkbutton('enable');
		$("#BAsCharged").linkbutton('enable');
		$("#BSplit").linkbutton('enable');
		$("#BUnAsCharged").linkbutton('disable');
		if(AccountAmount<0){
			$("#BAsCharged").linkbutton('disable');
		}
	
	}
	
	
}

function PrivilegeMode_change()
{
    var PrivilegeMode=$("#privilegeMode").combobox('getValue');
	
	$("#SaleAmount").attr('disabled',true);
	$("#Rebate").attr('disabled',true);
	
	if(PrivilegeMode=="OS")
	{
		$("#SaleAmount").attr('disabled',false);
	}
	else
	{
		$("#SaleAmount").attr('disabled',true);
		$("#SaleAmount").val("")
		
	}
	if (PrivilegeMode=="OR")
	{
		$("#Rebate").attr('disabled',false);
	}
	else
	{
		$("#Rebate").attr('disabled',true);
		$("#Rebate").val("");
	}
	$("#FactAmount").attr('disabled',true);
	if (PrivilegeMode=="TP")
	{
		$("#FactAmount").attr('disabled',false);
	}
	else
	{
		$("#FactAmount").attr('disabled',true);
		$("#FactAmount").val();
	}
}

//��Ŀ��ϸ(����)
function ItemDetail_click(AuditID)
{
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEFeeList"
			+"&PreAudits="+AuditID;
	websys_lu(lnk,false,'iconCls=icon-w-edit,width=980,height=480,hisui=true,title=��Ŀ��ϸ')
	
}

//���(����)
function SplitItem_click(AuditID)
{
	$("#AuditID").val(AuditID);
	    
	$HUI.window("#NewWin",{
		title:"�����Ϣ",
		collapsible:false,
		minimizable:false,
		maximizable:false,
		iconCls:'icon-w-edit',
		//modal:true,
		width:1000,
		height:1000
	});
	
	$('#FeeListLeftGrid').datagrid('load', {
			ClassName:"web.DHCPE.ItemFeeList",
			QueryName:"FindItemFeeList",
			SplitType:$("#SplitType").combobox('getValue'),
			InvPrtId:"", 
			PreAudits:AuditID,
			SelectIds:"",
			ReadOnlyFlag:"", 
			 ADMType:"", 
			 GIADM:"", 
			ARCIMID:"", 
			OrdSetID:"", 
			Name:"",
		
		});
	$('#FeeListRightGrid').datagrid('load', {
			ClassName:"web.DHCPE.ItemFeeList",
			QueryName:"FindItemFeeList",
			SplitType:$("#SplitType").combobox('getValue'),
			InvPrtId:"", 
			PreAudits:"",
			SelectIds:"",
			ReadOnlyFlag:"", 
			 ADMType:"", 
			 GIADM:"", 
			ARCIMID:"", 
			OrdSetID:"", 
			Name:"",
		
		});

	
	
}
function InitPreAuditListGrid()
{
	$HUI.datagrid("#PreAuditListTab",{
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
		singleSelect:true,
		//checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.PreAudit",
			QueryName:"SerchPreAudit",
			CRMADM:CRMADM,
			ADMType:ADMType,
			GIADM:GIADM,
			
		},
		
		columns:[[
		    {field:'TRowId',title:'PreAudit',hidden:true},
			//{title:'ѡ��',field: 'Select',width: 60,checkbox:true},
			{field:'TRebate',width:120,title:'�ۿ���'},
			{field:'TAccountAmount',width:120,title:'Ӧ�ս��',align:'right'},
			{field:'TDiscountedAmount',width:120,title:'�ۺ���',align:'right'},
			{field:'TFactAmount',width:120,title:'���ս��',align:'right'},
			{field:'TAuditedStatus',width:90,title:'���״̬'},
			{field:'TChargedStatus',width:90,title:'�շ�״̬'},
			//{field:'Audited',title:'���״̬',hidden:true},
			//{field:'Charged',title:'�շ�״̬',hidden:true},
			{field:'TPrivilegeMode',width:100,title:'�Ż���ʽ'},
			{field:'TType',width:50,title:'����'},
			{field:'ItemDetail',title:'��Ŀ��ϸ',width:80,align:'center',
				formatter:function(value,rowData,rowIndex){
					if(rowData.TRowId!=""){
						return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png"  title="��Ŀ��ϸ" border="0" onclick="ItemDetail_click('+rowData.TRowId+')"></a>';
					
					}
				}},
			{field:'SplitItem',title:'���',width:50,align:'center',
				formatter:function(value,rowData,rowIndex){
					if(rowData.TRowId!=""){
						return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/transfer.png"  title="���" border="0" onclick="SplitItem_click('+rowData.TRowId+')"></a>';
					
					}
				}},
			{field:'TAsCharged',width:90,title:'���֧��'},
			{field:'TTeamName',width:190,title:'��������'},
			{field:'TRemark',width:100,title:'��ע'},
			
		]],
		onSelect: function (rowIndex, rowData) {
			
			 $("#RowID").val(rowData.TRowId);
			 fillData(rowData.TRowId);
		     if(rowData.TAccountAmount=="0.00"){
				 $("#privilegeMode").combobox("disable"); 
			 }else{
				  $("#privilegeMode").combobox("enable"); 
			 }

			if((rowData.TRemark.indexOf("������")>-1)||(rowData.TChargedStatus.indexOf("���շ�")>-1)){
	    		$("#BSplit").linkbutton('disable');
   			 }else{	
	    		$("#BSplit").linkbutton('enable');
    		}
			 			
		}
		
			
	})
}
		
function InitFeeListLefGrid()
{
	if(ADMType=="I" ){var ItemNameTitle="��Ŀ����";}
   if(ADMType=="G" ){var ItemNameTitle="״̬";}

	$HUI.datagrid("#FeeListLeftGrid",{
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
		singleSelect:false,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.ItemFeeList",
			QueryName:"FindItemFeeList",
			SplitType:"",
			InvPrtId:"", 
			PreAudits:"",
			SelectIds:"",
			ReadOnlyFlag:"", 
			 ADMType:"", 
			 GIADM:"", 
			ARCIMID:"", 
			OrdSetID:"", 
			Name:"",
			
			
		},
		frozenColumns:[[
			{title:'ѡ��',field:'Select',width:60,checkbox:true},
			{title:'FeeType',field:'FeeType',hidden:true},
			{field:'FeeTypeDesc',width:50,title:'���'},
			{field:'ItemName',width:120,title:ItemNameTitle},
			{field:'PatName',width:100,title:'����'},
						 
		]],
		columns:[[
		    {field:'RowId',title:'TRowId',hidden:true},
			{field:'FactAmount',width:120,title:'���ս��',align:'right'},
			{field:'PrivilegeMode',width:100,title:'�Ż���ʽ'},	
			{field:'OrdStatusDesc',width:100,title:'ִ��״̬'},		
				
		]],
		onSelect: function (rowIndex, rowData) {
			
									
		}
		
			
	})
}

function InitFeeListRightGrid()
{
	if(ADMType=="I" ){var ItemNameTitle="��Ŀ����";}
   if(ADMType=="G" ){var ItemNameTitle="״̬";}

	$HUI.datagrid("#FeeListRightGrid",{
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
		singleSelect:false,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		toolbar: [] ,
		queryParams:{
			ClassName:"web.DHCPE.ItemFeeList",
			QueryName:"FindItemFeeList",
			SplitType:"",
			InvPrtId:"", 
			PreAudits:"",
			SelectIds:"",
			ReadOnlyFlag:"", 
			 ADMType:"", 
			 GIADM:"", 
			ARCIMID:"", 
			OrdSetID:"", 
			Name:"",	
			
		},
		frozenColumns:[[
			{title:'ѡ��',field:'Select',width: 60,checkbox:true},
			{title:'FeeType',field:'FeeType',hidden:true},
			{field:'FeeTypeDesc',width:50,title:'���'},
			{field:'ItemName',width:120,title:ItemNameTitle},
			{field:'PatName',width:100,title:'����'},
		]],
		columns:[[
		    {field:'RowId',title:'TRowId',hidden:true},
			{field:'FactAmount',width:120,title:'���ս��',align:'right'},
			{field:'PrivilegeMode',width:100,title:'�Ż���ʽ'},	
			{field:'OrdStatusDesc',width:100,title:'ִ��״̬'},			
			
		]],
		onSelect: function (rowIndex, rowData) {
										
		}		
	})
}


function fillData(RowID)
{
	if (RowID!="")
	{
		var Data=tkMakeServerCall("web.DHCPE.PreAudit","GetOneInfo",RowID)
		Data=RowID+"^"+Data;
	}
	else
	{
		Data="^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^";
	}
	fill(Data);
}
///���ݱ�ṹ����һ������
function fill(Data)
{
	
	var Data=Data.split("^");
	$("#Rebate").val(Data[5]);
	$("#AccountAmount").val(Data[6]);
	$("#DiscountedAmount").val(Data[7]);
	$("#SaleAmount").val(Data[8]);
	$("#FactAmount").val(Data[9]);
	$("#privilegeMode").combobox("setValue",Data[19]);
	if((Data[8]>0)&&(Data[19]=="OR")) {$("#privilegeMode").combobox("setValue","OS");}
	$("#Type").combobox("setValue",Data[20]);
	$("#ChargedType").combobox("setValue",Data[25]);
	$("#ChargedRemark").val(Data[26]);
	$("#Remark").val(Data[18]);
	
	SetButtonDisabl(Data[0],Data[10],Data[14],Data[27],Data[6]);
}

function InitCombobox()
{
	//�Ż���ʽ
	var privilegeModeObj = $HUI.combobox("#privilegeMode",{
		valueField:'id',
		textField:'text',
		panelHeight:'140',
		data:[
		  	{id:'NP',text:'���Ż�'},
            {id:'OR',text:'�ۿ�'},
            {id:'OP',text:'��Ŀ�Ż�'},
            {id:'OS',text:'���۽��'},
           
        ]

	});
	//֧������
	var ChargedTypeObj = $HUI.combobox("#ChargedType",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'1',text:'���'},
            {id:'4',text:'����'},
           
        ]

	});
	
	//����
	var TypeObj = $HUI.combobox("#Type",{
		valueField:'id',
		textField:'text',
		panelHeight:'70',
		data:[
            {id:'PRE',text:'ԤԼ'},
            {id:'ADD',text:'����'},
           
        ]

	});
	
	//�������
	var SplitTypeObj = $HUI.combobox("#SplitType",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'item',text:'��Ŀ'},
            {id:'person',text:'��Ա'},
            {id:'group',text:'����'},
           
        ]

	});
	
	
	
	//��Ŀ
	var OrdObj = $HUI.combogrid("#ARCIMDesc",{
		panelWidth:340,
		url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=ArcItmmastList",
		mode:'remote',
		delay:200,
		idField:'STORD_ARCIM_DR',
		textField:'STORD_ARCIM_Desc',
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		onShowPanel:function()
		{
			$('#ARCIMDesc').combogrid('grid').datagrid('reload');
		},
		columns:[[
			{field:'STORD_ARCIM_Desc',title:'����',width:200},
			{field:'STORD_ARCIM_Code',title:'����',width:100},
			{field:'STORD_ARCIM_DR',title:'ҽ��ID',hidden: true},	
					
		]],
		onLoadSuccess:function(){
			//$("#ARCDesc").combogrid('setValue',"")
			
		},

		});
		
		//�ײ�
	var SetObj = $HUI.combogrid("#SetDesc",{
		panelWidth:390,
		url:$URL+"?ClassName=web.DHCPE.HandlerOrdSetsEx&QueryName=queryOrdSet",
		mode:'remote',
		delay:200,
		idField:'OrderSetId',
		textField:'OrderSetDesc',
		onBeforeLoad:function(param){
			param.Set = param.q;
		},
		onShowPanel:function()
		{
			$('#SetDesc').combogrid('grid').datagrid('reload');
		},
		columns:[[
			{field:'OrderSetDesc',title:'����',width:200},
			{field:'IsBreakable',title:'�Ƿ���',width:80},
			{field:'OrderSetPrice',title:'�۸�',width:100},
			{field:'OrderSetId',title:'ҽ��ID',hidden: true},	
					
		]],
		onLoadSuccess:function(){
			//$("#ARCDesc").combogrid('setValue',"")
			
		},

		});
        
	/*
	 $("#ARCIMDesc").lookup({
           
          panelWidth:420,
           url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=QueryAll",
           mode:'remote',
            idField:'STORD_ARCIM_DR',
            textField:'STORD_ARCIM_Desc',
            columns:[[  
                {field:'STORD_ParRef',title:'վ��ID',hidden: true},
		    	{field:'STORD_ParRef_Name',title:'վ������',width:100},
				{field:'STORD_ARCIM_Desc',title:'ҽ������',width:120},
				{field:'STORD_ARCIM_Code',title:'ҽ������',width:100},
				{field:'STORD_ARCIM_DR',title:'ҽ��ID',hidden: true},	
					     
           ]],
            pagination:true,
            onSelect:function(index,rowData){
               console.log("index="+index+",rowData=",rowData);
               //$('#group').lookup('setText',rowData.HIDDEN+"-"+rowData.Description);  //textField����Description����onSelect������Լ�����ʾ��ֵ �����ֲ�����Ҫ�Լ�����ò�ѯ������Ĺ�ϵ
            }
        });
        
         $("#SetDesc").lookup({
           
          panelWidth:420,
           url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=QueryAll",
           mode:'remote',
            idField:'STORD_ARCIM_DR',
            textField:'STORD_ARCIM_Desc',
            columns:[[  
                {field:'STORD_ParRef',title:'վ��ID',hidden: true},
		    	{field:'STORD_ParRef_Name',title:'վ��Ŀ������',width:100},
				{field:'STORD_ARCIM_Desc',title:'ҽ������',width:120},
				{field:'STORD_ARCIM_Code',title:'ҽ������',width:100},
				{field:'STORD_ARCIM_DR',title:'ҽ��ID',hidden: true},	
					     
           ]],
            pagination:true,
            onSelect:function(index,rowData){
               console.log("index="+index+",rowData=",rowData);
               //$('#group').lookup('setText',rowData.HIDDEN+"-"+rowData.Description);  //textField����Description����onSelect������Լ�����ʾ��ֵ �����ֲ�����Ҫ�Լ�����ò�ѯ������Ĺ�ϵ
            }
        });
*/
	
	
}

