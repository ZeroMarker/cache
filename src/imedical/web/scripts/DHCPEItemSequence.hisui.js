
//名称	DHCPEItemSequence.hisui.js
//功能	医嘱在报告上的显示顺序	
//创建	2019.04.30
//创建人  xy

$(function(){
		
	
	InitCombobox();
	
	InitItemSequenceDataGrid();
      
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
    
    //修改
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
        
     //新增
	$("#BAdd").click(function() {	
		BAdd_click();		
        }); 
          
    //删除
	$("#BDelete").click(function() {	
		BDelete_click();		
        });
})



//清屏
function BClear_click()
{
	$("#ItemID").val("");
	$("#ItemName").combogrid('setValue',"");
	$("#ItemSequence").val("");
	var valbox = $HUI.validatebox("#ItemName,#ItemSequence", {
				required: false,
	    	});
	
	 $("#ItemSequenceQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.ItemSequence",
			QueryName:"SearchItemSeqInfo",
		});
}


//修改
function BUpdate_click()
{
	BSave_click("1");
}

 //新增
function BAdd_click()
{
	BSave_click("0");
}

 
 function BSave_click(Type)
 {	
 
 	if(Type=="1"){
		var iItemID=$("#ItemID").val();
		if(""==iItemID){
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
	}
	
	if(Type=="0"){
	   
	    if($("#ItemID").val()!=""){
		    	$.messager.alert("提示","新增数据不能选中记录,请点击清屏后进行新增","info");
		    	return false;
		    }
	    
			var iItemID=$("#ItemName").combogrid('getValue');
        	if (($("#ItemName").combogrid('getValue')==undefined)||($("#ItemName").combogrid('getValue')=="")){var iItemID="";}
	    
        if (""==iItemID) {
	 	  	$.messager.alert("提示","医嘱名称不能为空","info");
		 	$("#ItemName").focus();
			var valbox = $HUI.validatebox("#ItemName", {
				required: true,
	    	});
			return false;
	 }
	
	}
	
   
    var iItemSequence=$("#ItemSequence").val();
    if (""==iItemSequence) {
	    	$.messager.alert("提示","医嘱顺序不能为空","info");
		 	$("#ItemSequence").focus();
			var valbox = $HUI.validatebox("#ItemSequence", {
				 required: true,
	    	});
			return false;
	 }
    
     var InString=trim(iItemID)+"^"+trim(iItemSequence);
	 var flag=tkMakeServerCall("web.DHCPE.ItemSequence","SaveNew",InString);                  
    if (flag==0)  
	{   
		if(Type=="1"){$.messager.alert("提示","修改成功","success");}
		if(Type=="0"){$.messager.alert("提示","新增成功","success");}
		 
		BClear_click();
		 
	}
	else
	{
		$.messager.alert("提示","更新失败","error");
		
	}
 }

 //删除
function BDelete_click()
{
	var ID=$("#ItemID").val();
	if (ID=="") 
	{
		$.messager.alert("提示","请选择待删除的记录","info");
		return;
	}
	var Sequence=$("#ItemSequence").val();
	var string=trim(ID)+"^"+trim(Sequence)
	var flag=tkMakeServerCall("web.DHCPE.ItemSequence","Delete",string);
	if (flag==0)
	{
		 BClear_click();
		$.messager.alert("提示","删除成功","success");
		
	}
	else
	{
		$.messager.alert("提示","删除失败","error");
		
	}
}

function InitCombobox()
{
	  //医嘱名称
	   var OPNameObj = $HUI.combogrid("#ItemName",{
		panelWidth:400,
		url:$URL+"?ClassName=web.DHCPE.Public.SettingEdit&QueryName=QueryFeeID",
		mode:'remote',
		delay:200,
		idField:'ID',
		textField:'Name',
		onBeforeLoad:function(param){
			param.FeeTest = param.q;
		},
		columns:[[
		    {field:'ID',title:'ID',width:40},
			{field:'Name',title:'医嘱名称',width:200},
			{field:'Code',title:'医嘱编码',width:150},
			
				
		]],
		onLoadSuccess:function(){
			$("#ItemName").combogrid('setValue',""); 
		},

		});
}


function InitItemSequenceDataGrid()
{
	$HUI.datagrid("#ItemSequenceQueryTab",{
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
			ClassName:"web.DHCPE.ItemSequence",
			QueryName:"SearchItemSeqInfo",
		},
		columns:[[
	
		    {field:'TItemID',title:'TItemID',hidden: true},
			{field:'TItemCode',width:'350',title:'医嘱编码'},
			{field:'TItemName',width:'500',title:'医嘱名称'},
			{field:'TItemSequence',width:'300',title:'医嘱显示顺序'}
				
		]],
		onSelect: function (rowIndex, rowData) {
			    
				$("#ItemID").val(rowData.TItemID);
				$("#ItemName").combogrid('setValue',rowData.TItemName);
				$("#ItemSequence").val(rowData.TItemSequence);
				
			
		}
			
	})

}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[0];
}	
