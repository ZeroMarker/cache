//
//����	DHCPESplitAudit.hisui.js
//����	���ò��hisui
//����	2019.11.13
//������  xy

$(function(){
	$("#AuditID").val(AuditID);
		
	InitCombobox();
	
	//�������
	$("#SplitType").combobox({
       onSelect:function(){
			SplitType_change();
	}
	});
	
	init();
	 
	InitFeeListLefGrid();
	
	InitFeeListRightGrid();
	  
	
	
	/*
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
	*/
	
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
   
    
	
})


function BFind_Click(){
		
	 
     var iARCIMID=$("#ARCIMDesc").combogrid('getValue');
     if (($("#ARCIMDesc").combogrid('getValue')==undefined)||($("#ARCIMDesc").combogrid('getValue')=="")){var iARCIMID="";}
     var iOrdSetID=getValueById("OrdSetID");
     var iOrdSetID=$("#SetDesc").combogrid('getValue');
     if (($("#SetDesc").combogrid('getValue')==undefined)||($("#SetDesc").combogrid('getValue')=="")){var iOrdSetID="";}
	 var auditid=$("#AuditID").val();
	
	if($("#SplitType").combobox('getValue')=="item"){
	   var ItemNameTitle=$g("��Ŀ����");
	   var ARCOShidden=false;
   }else{
	   var ItemNameTitle=$g("״̬");
	   var ARCOShidden=true;
   }
   var Status=$("#Status").combobox('getValue');
   
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
			Status:$("#Status").combobox('getValue'),
			CSPName:"dhcpesplitaudit.hiui.csp"	
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
			{field:'FactAmount',width:100,title:'���۽��',align:'right'},
			{field:'PrivilegeMode',width:80,title:'�Ż���ʽ'},	
			{field:'OrdStatusDesc',width:80,title:'ִ��״̬'},		
			{field:'ARCOSName',width:140,title:'�ײ�����',hidden:ARCOShidden}		
				
		]],
		
			
	})
   
    
	
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
	var objtbl = $("#FeeListLeftGrid").datagrid('getRows');
    var rows=objtbl.length
    if(rows==0){
	  	$.messager.alert("��ʾ","û�п��ƶ�����Ŀ","info");
		return;
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
		$.messager.alert("��ʾ","��ѡ��Ҫת�Ƶ���ϸ","info");
		return;
	}
	
	var result=tkMakeServerCall("web.DHCPE.ItemFeeList","MoveItemFee","","",auditid,toAuditid,allFlag,feeItems)
	
	if (isNaN(result)==true){
		$.messager.alert("��ʾ",result,"info");
	}
	else
	{
		
		$.messager.alert("��ʾ","���³ɹ�","success");
		
		if($("#SplitType").combobox('getValue')=="item"){
	       var ItemNameTitle=$g("��Ŀ����");
        }else{
	       var ItemNameTitle=$g("״̬");
       }
	    if($("#SplitType").combobox('getValue')=="group"){
			 var PatNameTitle=$g("��������");
		}else{
			var PatNameTitle=$g("����");
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
				CSPName:"dhcpesplitaudit.hiui.csp"	
		
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
			CSPName:"dhcpesplitaudit.hiui.csp"	
		},
		frozenColumns:[[
			{title:'ѡ��',field:'Select',width:60,checkbox:true},
			{title:'FeeType',field:'FeeType',hidden:true},
			{field:'FeeTypeDesc',width:50,title:'���'},
			{field:'ItemName',width:120,title:ItemNameTitle},
			{field:'PatName',width:80,title:PatNameTitle},
						 
		]],
		columns:[[
		    {field:'RowId',title:'TRowId',hidden:true},
			{field:'FactAmount',width:100,title:'���۽��',align:'right'},
			{field:'PrivilegeMode',width:80,title:'�Ż���ʽ'},	
			{field:'OrdStatusDesc',width:80,title:'ִ��״̬'},		
				
		]],
		
			
	});
			
	     }else{
		       
		       $("#AuditID").val(result);
		       $("#ToAuditID").val(auditid);
		       
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
				CSPName:"dhcpesplitaudit.hiui.csp"	
		
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
			CSPName:"dhcpesplitaudit.hiui.csp"	
		},
		frozenColumns:[[
			{title:'ѡ��',field:'Select',width:60,checkbox:true},
			{title:'FeeType',field:'FeeType',hidden:true},
			{field:'FeeTypeDesc',width:50,title:'���'},
			{field:'ItemName',width:120,title:ItemNameTitle},
			{field:'PatName',width:80,title:PatNameTitle},
						 
		]],
		columns:[[
		    {field:'RowId',title:'TRowId',hidden:true},
			{field:'FactAmount',width:100,title:'���۽��',align:'right'},
			{field:'PrivilegeMode',width:80,title:'�Ż���ʽ'},	
			{field:'OrdStatusDesc',width:80,title:'ִ��״̬'},		
				
		]],
		
			
	});
			
	     }
	     
	   
	    parent.window.$("#PreAuditListTab").datagrid('load',{ClassName:"web.DHCPE.PreAudit",QueryName:"SerchPreAudit",ADMType:ADMType,CRMADM:CRMADM,GIADM:GIADM,AppType:"Fee"});
					
		window.opener.$("#PreAuditPayTable").datagrid('load',{ClassName:"web.DHCPE.PreAudit",QueryName:"SerchPreAudit",ADMType:ADMType,CRMADM:"",GIADM:GIADM,AppType:"Fee"});
					
}
}
/*
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
*/

var ItemNameTitle="״̬";
var PatNameTitle="����";

function SplitType_change(){
	
	
	if((ADMType=="I")){
		var ItemNameTitle=$g("��Ŀ����");
		var ARCOShidden=false;
	}
	else{
   		if($("#SplitType").combobox('getValue')=="item"){
	   		var ItemNameTitle=$g("��Ŀ����");
	   		var ARCOShidden=false;
   		}else{
	  	 	var ItemNameTitle=$g("״̬");
	  	 	var ARCOShidden=true;	
   		}
		if($("#SplitType").combobox('getValue')=="group"){
	        var PatNameTitle=$g("��������");
		}else{
			var PatNameTitle=$g("����");
		 }

  
	}
	
	$HUI.datagrid("#FeeListLeftGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
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
			CSPName:"dhcpesplitaudit.hiui.csp"	
			
			
		},
		frozenColumns:[[
			{title:'ѡ��',field:'Select',width:60,checkbox:true},
			{title:'FeeType',field:'FeeType',hidden:true},
			{field:'FeeTypeDesc',width:50,title:'���'},
			{field:'ItemName',width:120,title:ItemNameTitle},
			{field:'PatName',width:100,title:PatNameTitle},
						 
		]],
		columns:[[
		    {field:'RowId',title:'TRowId',hidden:true},
			{field:'FactAmount',width:100,title:'���۽��',align:'right'},
			{field:'PrivilegeMode',width:80,title:'�Ż���ʽ'},	
			{field:'OrdStatusDesc',width:80,title:'ִ��״̬'},		
			{field:'ARCOSName',width:140,title:'�ײ�����',hidden:ARCOShidden}		
				
		]],
		
			
	})
	
   if($("#SplitType").combobox('getValue')=="person"){
	    //$("#SelectR").checkbox("enable");
	   // $("#SelectA").checkbox("enable");
	      $("#Status").combobox("enable");
	    $("#Name").attr('disabled',false);
	    if(ADMType=="I"){
			$("#Name").attr('disabled',true);
			 $("#Status").combobox("disable");
			//$("#SelectR").checkbox("disable");
			//$("#SelectA").checkbox("disable");
		
	}
   }else{
	  // $("#SelectR").checkbox("setValue",false);
	  // $("#SelectA").checkbox("setValue",false);
	   //$("#SelectR").checkbox("disable");
	   //$("#SelectA").checkbox("disable");
	    $("#Status").combobox("disable");
	   $("#Name").val("")
	   $("#Name").attr('disabled',true);
	   $("#Status").combobox('setValue',"");
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
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect:false,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		toolbar:[] ,
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
			CSPName:"dhcpesplitaudit.hiui.csp"	
			
		},
		frozenColumns:[[
			{title:'ѡ��',field:'Select',width: 60,checkbox:true},
			{title:'FeeType',field:'FeeType',hidden:true},
			{field:'FeeTypeDesc',width:50,title:'���'},
			{field:'ItemName',width:110,title:ItemNameTitle},
			{field:'PatName',width:100,title:PatNameTitle},
		]],
		columns:[[
		    {field:'RowId',title:'TRowId',hidden:true},
			{field:'FactAmount',width:90,title:'���ս��',align:'right'},
			{field:'PrivilegeMode',width:80,title:'�Ż���ʽ'},	
			{field:'OrdStatusDesc',width:80,title:'ִ��״̬'},			
			{field:'ARCOSName',width:140,title:'�ײ�����',hidden:ARCOShidden}		
			
		]],
		onSelect: function (rowIndex, rowData) {
										
		}		
	})
	
}
function InitFeeListLefGrid()
{
	if(ADMType=="I" ){
		var ItemNameTitle=$g("��Ŀ����");
		var ARCOShidden=false;
		}
    if(ADMType=="G" ){
	    var ItemNameTitle=$g("״̬");
	     if($("#SplitType").combobox('getValue')=="item"){
	    	var ARCOShidden=false;
	     }else{
		     var ARCOShidden=true;
	     }
	     
	    }
    if($("#SplitType").combobox('getValue')=="group"){
	      var PatNameTitle=$g("��������");
     }else{
	     var PatNameTitle=$g("����");
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
			PreAudits:$("#AuditID").val(),
			SelectIds:"",
			ReadOnlyFlag:"", 
			 ADMType:"", 
			 GIADM:"", 
			ARCIMID:"", 
			OrdSetID:"", 
			Name:"",
			CSPName:"dhcpesplitaudit.hiui.csp"	
			
			
		},
		frozenColumns:[[
			{title:'ѡ��',field:'Select',width:60,checkbox:true},
			{title:'FeeType',field:'FeeType',hidden:true},
			{field:'FeeTypeDesc',width:50,title:'���'},
			{field:'ItemName',width:120,title:ItemNameTitle},
			{field:'PatName',width:100,title:PatNameTitle},
						 
		]],
		columns:[[
		    {field:'RowId',title:'TRowId',hidden:true},
			{field:'FactAmount',width:100,title:'���۽��',align:'right'},
			{field:'PrivilegeMode',width:80,title:'�Ż���ʽ'},	
			{field:'OrdStatusDesc',width:80,title:'ִ��״̬'},		
			{field:'ARCOSName',width:140,title:'�ײ�����',hidden:ARCOShidden}
				
		]],
		onSelect: function (rowIndex, rowData) {
			
									
		}
		
			
	})
}

function InitFeeListRightGrid()
{
	if(ADMType=="I" ){
		var ItemNameTitle=$g("��Ŀ����");
		var ARCOShidden=false;
		
		}
   if(ADMType=="G" ){
	   var ItemNameTitle=$g("״̬");
	   if($("#SplitType").combobox('getValue')=="item"){
	    	var ARCOShidden=false;
	     }else{
		     var ARCOShidden=true;
	     }
	   }
    if($("#SplitType").combobox('getValue')=="group"){
	      var PatNameTitle=$g("��������");
     }else{
	     var PatNameTitle=$g("����");
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
			CSPName:"dhcpesplitaudit.hiui.csp"	
			
		},
		frozenColumns:[[
			{title:'ѡ��',field:'Select',width: 60,checkbox:true},
			{title:'FeeType',field:'FeeType',hidden:true},
			{field:'FeeTypeDesc',width:50,title:'���'},
			{field:'ItemName',width:120,title:ItemNameTitle},
			{field:'PatName',width:80,title:PatNameTitle},
		]],
		columns:[[
		    {field:'RowId',title:'TRowId',hidden:true},
			{field:'FactAmount',width:100,title:'���۽��',align:'right'},
			{field:'PrivilegeMode',width:80,title:'�Ż���ʽ'},	
			{field:'OrdStatusDesc',width:80,title:'ִ��״̬'},			
			{field:'ARCOSName',width:140,title:'�ײ�����',hidden:ARCOShidden}			
			
		]],
		onSelect: function (rowIndex, rowData) {
										
		}		
	})
}


function init()
{/*
	$("#SplitType").combobox('setValue',SplitType); 
	$("#SelectR").checkbox("enable");
	$("#SelectA").checkbox("enable");
	$("#Name").attr('disabled',false);
	$("#ARCIMDesc").combogrid("disable");
	$("#SetDesc").combogrid("disable");
	if(ADMType=="I"){
			$("#Name").attr('disabled',true);
			$("#SelectR").checkbox("disable");
			$("#SelectA").checkbox("disable");
			$("#SplitType").combobox("disable");
		
	}*/
	
	if(ADMType=="G"){
		$("#SplitType").combobox('setValue',"person"); 
		$("#Status").combobox("enable");
		$("#ARCIMDesc").combogrid("disable");
		$("#SetDesc").combogrid("disable");
		$("#Name").attr('disabled',false);
	}else if(ADMType=="I"){
		$("#SplitType").combobox('setValue',"item"); 
		$("#SplitType").combobox("disable");
		$("#Status").combobox("disable");
		$("#ARCIMDesc").combogrid("enable");
		$("#SetDesc").combogrid("enable");
		$("#Name").attr('disabled',true);
	} 
}
function InitCombobox()
{

	//�������
	var SplitTypeObj = $HUI.combobox("#SplitType",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'item',text:$g('��Ŀ')},
            {id:'person',text:$g('��Ա')},
            {id:'group',text:$g('����')},
           
        ]

	});
	
	//״̬
	var StatusObj = $HUI.combobox("#Status",{
		valueField:'id',
		textField:'text',
		panelHeight:'80',
		data:[
            {id:'����',text:$g('����')},
            {id:'�Ǽ�',text:$g('�Ǽ�')}, 
        ]

	});
	
		//��Ŀ
	var ARCIMDescObj = $HUI.combogrid("#ARCIMDesc",{
		panelWidth:340,
		url:$URL+"?ClassName=web.DHCPE.CT.StationOrder&QueryName=FindLocAllOrder",
		mode:'remote',
		delay:200,
		idField:'TARCIMDR',
		textField:'TARCIMDesc',
		onBeforeLoad:function(param){
			param.ARCIMDesc = param.q;
			param.Type ="B";
			param.hospId=session['LOGON.HOSPID'];
			param.LocID=session['LOGON.CTLOCID'];
			param.tableName="DHC_PE_StationOrder"
		},
		onShowPanel:function()
		{
			$('#ARCIMDesc').combogrid('grid').datagrid('reload');
		},
		columns:[[
			{field:'TARCIMDesc',title:'����',width:200},
			{field:'TARCIMCode',title:'����',width:100},
			{field:'TARCIMDR',title:'ҽ��ID',hidden: true},	
					
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
			param.hospId=session['LOGON.HOSPID'];
			param.LocID=session['LOGON.CTLOCID'];
			param.UserID=session['LOGON.USERID'];
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
        

	
}
