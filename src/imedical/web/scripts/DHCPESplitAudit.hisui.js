//
//名称	DHCPESplitAudit.hisui.js
//功能	费用拆分hisui
//创建	2019.11.13
//创建人  xy

$(function(){
	$("#AuditID").val(AuditID);
		
	InitCombobox();
	
	//拆分类型
	$("#SplitType").combobox({
       onSelect:function(){
			SplitType_change();
	}
	});
	
	init();
	 
	InitFeeListLefGrid();
	
	InitFeeListRightGrid();
	  
	
	
	/*
	//全选登记  
	$('#SelectR').checkbox({
		onCheckChange:function(e,vaule){
			SelectR_clicked(vaule);
			
			}
			
	});
	
	//全选到达
	$('#SelectA').checkbox({
		onCheckChange:function(e,vaule){
			SelectA_clicked(vaule);
			
			}
			
	});
	*/
	
	//移动选择项(向右)
    $("#MoveToR").click(function() {	
		BMoveToR_click();		
        }); 
        
    //移动所有项(向右)
    $("#MoveAllToR").click(function() {	
		BMoveAllToR_click();		
        }); 
        
     //移动选择项(向左)
    $("#MoveToL").click(function() {	
		BMoveToL_click();		
        }); 
        
    //移动所有项(向左)
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
	   var ItemNameTitle=$g("项目名称");
	   var ARCOShidden=false;
   }else{
	   var ItemNameTitle=$g("状态");
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
		checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
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
			{title:'选择',field:'Select',width:60,checkbox:true},
			{title:'FeeType',field:'FeeType',hidden:true},
			{field:'FeeTypeDesc',width:50,title:'类别'},
			{field:'ItemName',width:120,title:ItemNameTitle},
			{field:'PatName',width:100,title:'姓名'},
						 
		]],
		columns:[[
		    {field:'RowId',title:'TRowId',hidden:true},
			{field:'FactAmount',width:100,title:'销售金额',align:'right'},
			{field:'PrivilegeMode',width:80,title:'优惠形式'},	
			{field:'OrdStatusDesc',width:80,title:'执行状态'},		
			{field:'ARCOSName',width:140,title:'套餐名称',hidden:ARCOShidden}		
				
		]],
		
			
	})
   
    
	
}
//移动选择项(向右)
function BMoveToR_click()
{
	var allFlag=0;
	var feeItems=GetFeeItemInfo("FeeListLeftGrid");
	var auditid=$("#AuditID").val();
	var toAuditid="";
	Move(auditid,toAuditid,allFlag,feeItems,1);
}

//移动所有项(向右)
function BMoveAllToR_click()
{
	var allFlag=1;
	var feeItems=GetFeeItemInfo("FeeListLeftGrid");
	var auditid=$("#AuditID").val();
	var toAuditid="";
	var objtbl = $("#FeeListLeftGrid").datagrid('getRows');
    var rows=objtbl.length
    if(rows==0){
	  	$.messager.alert("提示","没有可移动的项目","info");
		return;
  }

	Move(auditid,toAuditid,allFlag,feeItems,1);
}

//移动选择项(向左)
function BMoveToL_click()
{
	var allFlag=0;
	var feeItems=GetFeeItemInfo("FeeListRightGrid");
	var auditid=$("#ToAuditID").val();
	var toAuditid=$("#AuditID").val();
	Move(auditid,toAuditid,allFlag,feeItems,0);
}

//移动所有项(向左)
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
	var selectrow = $("#"+frameName).datagrid("getChecked");//获取的是数组，多行数据
	
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
		$.messager.alert("提示","请选择要转移的明细","info");
		return;
	}
	
	var result=tkMakeServerCall("web.DHCPE.ItemFeeList","MoveItemFee","","",auditid,toAuditid,allFlag,feeItems)
	
	if (isNaN(result)==true){
		$.messager.alert("提示",result,"info");
	}
	else
	{
		
		$.messager.alert("提示","更新成功","success");
		
		if($("#SplitType").combobox('getValue')=="item"){
	       var ItemNameTitle=$g("项目名称");
        }else{
	       var ItemNameTitle=$g("状态");
       }
	    if($("#SplitType").combobox('getValue')=="group"){
			 var PatNameTitle=$g("分组名称");
		}else{
			var PatNameTitle=$g("姓名");
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
		checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
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
			{title:'选择',field:'Select',width:60,checkbox:true},
			{title:'FeeType',field:'FeeType',hidden:true},
			{field:'FeeTypeDesc',width:50,title:'类别'},
			{field:'ItemName',width:120,title:ItemNameTitle},
			{field:'PatName',width:80,title:PatNameTitle},
						 
		]],
		columns:[[
		    {field:'RowId',title:'TRowId',hidden:true},
			{field:'FactAmount',width:100,title:'销售金额',align:'right'},
			{field:'PrivilegeMode',width:80,title:'优惠形式'},	
			{field:'OrdStatusDesc',width:80,title:'执行状态'},		
				
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
		checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
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
			{title:'选择',field:'Select',width:60,checkbox:true},
			{title:'FeeType',field:'FeeType',hidden:true},
			{field:'FeeTypeDesc',width:50,title:'类别'},
			{field:'ItemName',width:120,title:ItemNameTitle},
			{field:'PatName',width:80,title:PatNameTitle},
						 
		]],
		columns:[[
		    {field:'RowId',title:'TRowId',hidden:true},
			{field:'FactAmount',width:100,title:'销售金额',align:'right'},
			{field:'PrivilegeMode',width:80,title:'优惠形式'},	
			{field:'OrdStatusDesc',width:80,title:'执行状态'},		
				
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
     	if ((Type=="A")&&(Status=="到达")) {
	    	if (objCheck.attr("type")=="checkbox") {
				objCheck.prop("checked",SelectAll);
	    	}
	     }
		if ((Type=="R")&&(Status=="登记")) {
	    	if (objCheck.attr("type")=="checkbox") {
				objCheck.prop("checked",SelectAll);
	    	}
		}
	
     
	}
	
}
*/

var ItemNameTitle="状态";
var PatNameTitle="姓名";

function SplitType_change(){
	
	
	if((ADMType=="I")){
		var ItemNameTitle=$g("项目名称");
		var ARCOShidden=false;
	}
	else{
   		if($("#SplitType").combobox('getValue')=="item"){
	   		var ItemNameTitle=$g("项目名称");
	   		var ARCOShidden=false;
   		}else{
	  	 	var ItemNameTitle=$g("状态");
	  	 	var ARCOShidden=true;	
   		}
		if($("#SplitType").combobox('getValue')=="group"){
	        var PatNameTitle=$g("分组名称");
		}else{
			var PatNameTitle=$g("姓名");
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
		checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
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
			{title:'选择',field:'Select',width:60,checkbox:true},
			{title:'FeeType',field:'FeeType',hidden:true},
			{field:'FeeTypeDesc',width:50,title:'类别'},
			{field:'ItemName',width:120,title:ItemNameTitle},
			{field:'PatName',width:100,title:PatNameTitle},
						 
		]],
		columns:[[
		    {field:'RowId',title:'TRowId',hidden:true},
			{field:'FactAmount',width:100,title:'销售金额',align:'right'},
			{field:'PrivilegeMode',width:80,title:'优惠形式'},	
			{field:'OrdStatusDesc',width:80,title:'执行状态'},		
			{field:'ARCOSName',width:140,title:'套餐名称',hidden:ARCOShidden}		
				
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
		checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
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
			{title:'选择',field:'Select',width: 60,checkbox:true},
			{title:'FeeType',field:'FeeType',hidden:true},
			{field:'FeeTypeDesc',width:50,title:'类别'},
			{field:'ItemName',width:110,title:ItemNameTitle},
			{field:'PatName',width:100,title:PatNameTitle},
		]],
		columns:[[
		    {field:'RowId',title:'TRowId',hidden:true},
			{field:'FactAmount',width:90,title:'最终金额',align:'right'},
			{field:'PrivilegeMode',width:80,title:'优惠形式'},	
			{field:'OrdStatusDesc',width:80,title:'执行状态'},			
			{field:'ARCOSName',width:140,title:'套餐名称',hidden:ARCOShidden}		
			
		]],
		onSelect: function (rowIndex, rowData) {
										
		}		
	})
	
}
function InitFeeListLefGrid()
{
	if(ADMType=="I" ){
		var ItemNameTitle=$g("项目名称");
		var ARCOShidden=false;
		}
    if(ADMType=="G" ){
	    var ItemNameTitle=$g("状态");
	     if($("#SplitType").combobox('getValue')=="item"){
	    	var ARCOShidden=false;
	     }else{
		     var ARCOShidden=true;
	     }
	     
	    }
    if($("#SplitType").combobox('getValue')=="group"){
	      var PatNameTitle=$g("分组名称");
     }else{
	     var PatNameTitle=$g("姓名");
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
		checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
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
			{title:'选择',field:'Select',width:60,checkbox:true},
			{title:'FeeType',field:'FeeType',hidden:true},
			{field:'FeeTypeDesc',width:50,title:'类别'},
			{field:'ItemName',width:120,title:ItemNameTitle},
			{field:'PatName',width:100,title:PatNameTitle},
						 
		]],
		columns:[[
		    {field:'RowId',title:'TRowId',hidden:true},
			{field:'FactAmount',width:100,title:'销售金额',align:'right'},
			{field:'PrivilegeMode',width:80,title:'优惠形式'},	
			{field:'OrdStatusDesc',width:80,title:'执行状态'},		
			{field:'ARCOSName',width:140,title:'套餐名称',hidden:ARCOShidden}
				
		]],
		onSelect: function (rowIndex, rowData) {
			
									
		}
		
			
	})
}

function InitFeeListRightGrid()
{
	if(ADMType=="I" ){
		var ItemNameTitle=$g("项目名称");
		var ARCOShidden=false;
		
		}
   if(ADMType=="G" ){
	   var ItemNameTitle=$g("状态");
	   if($("#SplitType").combobox('getValue')=="item"){
	    	var ARCOShidden=false;
	     }else{
		     var ARCOShidden=true;
	     }
	   }
    if($("#SplitType").combobox('getValue')=="group"){
	      var PatNameTitle=$g("分组名称");
     }else{
	     var PatNameTitle=$g("姓名");
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
		checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
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
			{title:'选择',field:'Select',width: 60,checkbox:true},
			{title:'FeeType',field:'FeeType',hidden:true},
			{field:'FeeTypeDesc',width:50,title:'类别'},
			{field:'ItemName',width:120,title:ItemNameTitle},
			{field:'PatName',width:80,title:PatNameTitle},
		]],
		columns:[[
		    {field:'RowId',title:'TRowId',hidden:true},
			{field:'FactAmount',width:100,title:'销售金额',align:'right'},
			{field:'PrivilegeMode',width:80,title:'优惠形式'},	
			{field:'OrdStatusDesc',width:80,title:'执行状态'},			
			{field:'ARCOSName',width:140,title:'套餐名称',hidden:ARCOShidden}			
			
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

	//拆分类型
	var SplitTypeObj = $HUI.combobox("#SplitType",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'item',text:$g('项目')},
            {id:'person',text:$g('人员')},
            {id:'group',text:$g('分组')},
           
        ]

	});
	
	//状态
	var StatusObj = $HUI.combobox("#Status",{
		valueField:'id',
		textField:'text',
		panelHeight:'80',
		data:[
            {id:'到达',text:$g('到达')},
            {id:'登记',text:$g('登记')}, 
        ]

	});
	
		//项目
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
			{field:'TARCIMDesc',title:'名称',width:200},
			{field:'TARCIMCode',title:'编码',width:100},
			{field:'TARCIMDR',title:'医嘱ID',hidden: true},	
					
		]],
		onLoadSuccess:function(){
			//$("#ARCDesc").combogrid('setValue',"")
			
		},

		});

		//套餐
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
			{field:'OrderSetDesc',title:'名称',width:200},
			{field:'IsBreakable',title:'是否拆分',width:80},
			{field:'OrderSetPrice',title:'价格',width:100},
			{field:'OrderSetId',title:'医嘱ID',hidden: true},	
					
		]],
		onLoadSuccess:function(){
			//$("#ARCDesc").combogrid('setValue',"")
			
		},

		});
        

	
}
