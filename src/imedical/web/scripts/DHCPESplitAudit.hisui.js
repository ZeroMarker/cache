//
//����	DHCPESplitAudit.hisui.js
//����	���ò��hisui
//����	2019.11.13
//������  xy

$(function(){
	$("#AuditID").val(AuditID);
		
	InitCombobox();
	
	InitFeeListLefGrid();
	
	InitFeeListRightGrid();
	  
	
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
	    
		window.opener.$("#PreAuditPayTable").datagrid('load',{ClassName:"web.DHCPE.PreAudit",QueryName:"SerchPreAudit",ADMType:ADMType,CRMADM:"",GIADM:GIADM,AppType:"Fee"});
					
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



function SplitType_change(){
	
	
	if((ADMType=="I")){var ItemNameTitle="��Ŀ����";}
	else{
   		if($("#SplitType").combobox('getValue')=="item"){
	   		var ItemNameTitle="��Ŀ����";
   		}else{
	  	 var ItemNameTitle="״̬";
   		}
  
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
	
   if($("#SplitType").combobox('getValue')=="person"){
	    $("#SelectR").checkbox("enable");
	    $("#SelectA").checkbox("enable");
	    $("#Name").attr('disabled',false);
	    if(ADMType=="I"){
			$("#Name").attr('disabled',true);
			$("#SelectR").checkbox("disable");
			$("#SelectA").checkbox("disable");
		
	}
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


	
}
function InitFeeListLefGrid()
{
	
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
			SplitType:SplitType,
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
			{field:'FactAmount',width:120,title:'���۽��',align:'right'},
			{field:'PrivilegeMode',width:100,title:'�Ż���ʽ'},	
			{field:'OrdStatusDesc',width:100,title:'ִ��״̬'},		
				
		]],
		onSelect: function (rowIndex, rowData) {
			
									
		}
		
			
	})
}

function InitFeeListRightGrid()
{
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
			{field:'FactAmount',width:120,title:'���۽��',align:'right'},
			{field:'PrivilegeMode',width:100,title:'�Ż���ʽ'},	
			{field:'OrdStatusDesc',width:100,title:'ִ��״̬'},			
			
		]],
		onSelect: function (rowIndex, rowData) {
										
		}		
	})
}


function init()
{
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
        

	
}
