
//名称	DHCPEInPatientToHP.InDoc.hisui.js
//功能	住院医生维护
//创建	2019.05.05
//创建人  xy

$(function(){
		
	InitCombobox();
	
	InitIPToHPInDocDataGrid();
      
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
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
	$("#UserName").combogrid('setValue',"");
	$("#ID").val("");
	var valbox = $HUI.combogrid("#UserName", {
				required: false,
	   	   });
	$("#IPToHPInDocQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.OtherPatientToHPBaseSet",
			QueryName:"FindInDoc",
		});
}

 //新增
 function BAdd_click()
 {
	
	LocID=session['LOGON.CTLOCID'];
	
	var UserID=$("#ID").val();
	if($("#ID").val()!=""){
			$.messager.alert("提示","新增数据不能选中记录,请点击清屏后进行新增","info");
		    return false;
	}
	if(UserID==""){
		var UserID=$("#UserName").combogrid('getValue');
        if (($("#UserName").combogrid('getValue')==undefined)||($("#UserName").combogrid('getValue')=="")){var UserID="";}
	}
	
	if (UserID!=""){
			var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","IsUser",UserID);
			if(flag=="0"){
				$.messager.alert("提示","请选择医生","info");
				return false;
				}
			
	}else{
		    $("#UserName").focus();
		    $.messager.alert("提示","医生不能为空","info");
		 	var valbox = $HUI.combogrid("#UserName", {
				required: true,
	   	   });
			return false;
		}
	
	//alert(LocID+"^"+UserID)
	var ret=tkMakeServerCall("web.DHCPE.OtherPatientToHPBaseSet","SetInDoc",LocID,UserID,"N");
	
	     BClear_click();
	 if(ret==0){
		$.messager.alert("提示","新增成功","success");
	  }
				
 
 }

 //删除
function BDelete_click()
{
	
	LocID=session['LOGON.CTLOCID'];
	var UserID=$("#ID").val();
	
	if (UserID==""){
		$.messager.alert("提示","请选择待删除的数据","info");
		return false;
	}
	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
				$.m({ ClassName:"web.DHCPE.OtherPatientToHPBaseSet", MethodName:"SetInDoc",LocID:LocID,UserID:UserID,DeleteFlag:"Y"},function(ReturnValue){
				if (ReturnValue!="0") {
					$.messager.alert("提示","删除失败","error");
				}else{
					BClear_click();
					$.messager.alert("提示","删除成功","success");
				}
				});
		}
	});
	
}


function InitCombobox()
{
	//操作员
	   var OPNameObj = $HUI.combogrid("#UserName",{
		panelWidth:470,
		panelHeight:260,
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindCTPCP",
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//序号   
		fit: true,
		pageSize: 5,
		pageList: [5,10],
		idField:'DocDr',
		textField:'DocName',
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		columns:[[
		    {field:'DocDr',title:'ID',width:40},
			{field:'DocName',title:'姓名',width:200},
			{field:'Initials',title:'工号',width:200}			
		]],
		onLoadSuccess:function(){
			//$("#UserName").combogrid('setValue',"")	
		},
		});
}

function InitIPToHPInDocDataGrid()
{
	$HUI.datagrid("#IPToHPInDocQueryTab",{
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
			ClassName:"web.DHCPE.OtherPatientToHPBaseSet",
			QueryName:"FindInDoc",
		},
		columns:[[
	
		    {field:'UserID',title:'UserID',hidden: true},
			{field:'UserCode',width:'600',title:'工号'},
			{field:'UserName',width:'600',title:'医生'}
		
		]],
		onSelect: function (rowIndex, rowData) {
			    
				$("#ID").val(rowData.UserID);
				$("#UserName").combogrid('setValue',rowData.UserName);		
				
			
		}
		
			
	})

}


