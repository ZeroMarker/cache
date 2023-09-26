
//名称	DHCPESpecialItemContral.hisui.js
//功能	体检特殊项目权限管理
//创建	2019.05.17
//创建人  xy

$(function(){
		
	InitCombobox();
	
	InitSpecItemContDataGrid();
    
    InitSpecItemContDetailDataGrid(); 
    
    //新增
	$("#BAdd").click(function() {	
		BAdd_click();		
        });  
         
    //删除
	$("#BDelete").click(function() {	
		Delete_Click();		
        });
        
     //保存
	$("#BSave").click(function() {	
		BSave_Click();		
        });
    
    })

//新增
function BAdd_click()
{
	
	var UserID=$("#UserName").combogrid('getValue')
	 if (($("#UserName").combogrid('getValue')==undefined)||($("#UserName").combogrid('getValue')=="")){var UserID="";}
   
	if (UserID!=""){
			var ret=tkMakeServerCall("web.DHCPE.DHCPECommon","IsUser",UserID);
			if(ret=="0"){
				$.messager.alert("提示","请选择用户","info");
				return false;
				}
		}else{
			var valbox = $HUI.combogrid("#UserName", {
				required: true,
	    	});
			$.messager.alert("提示","用户不能为空","info");
			return false;
		}
	
	 
	var ret=tkMakeServerCall("web.DHCPE.SpecialItemContral","AddSpecialItemContralUser",UserID);
	if(ret="0"){
			$.messager.popover({msg: '新增成功',type:'success',timeout: 1000});
			
			$("#SpecialItemContralTab").datagrid('load',{
				ClassName:"web.DHCPE.SpecialItemContral",
				QueryName:"SearchSpecialItemContral",
			});
			
		}

	
}

//删除
function Delete_Click()
 {
	var UserID=$("#ID").val()
	
	if (""==UserID) {
		$.messager.alert("提示","请先选择待删除的记录","info");	
		return false;
	 }

	var ret="";

	$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.SpecialItemContral", MethodName:"DelSpecialItemContralUser",UserID:UserID},function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("提示","删除失败","error");  
				}else{
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					$("#ID").val("");	
					$("#SpecialItemContralTab").datagrid('load',{
						ClassName:"web.DHCPE.SpecialItemContral",
						QueryName:"SearchSpecialItemContral",
					});
				$('#SpecialItemContralDetailTab').datagrid('load', {
					ClassName: 'web.DHCPE.SpecialItemContral',
					QueryName: 'SearcgSIContralDetail',
					UserID: UserID,
		
				});
     
				}
			});	
		}
	});
	
	
 }

 
 //保存
 function BSave_Click()
 {
	  var str="";
	 var selectrow = $("#SpecialItemContralDetailTab").datagrid("getChecked");//获取的是数组，多行数据
	for(var i=0;i<selectrow.length;i++){
		//alert(selectrow[i].TItemID)
		if(str==""){str=selectrow[i].TItemID;}
		else{str=str+"^"+selectrow[i].TItemID;}
			
	}
	 
	var UserID=$('#UserID').val();
	if (UserID==""){
		$.messager.alert("提示","操作员不能为空","info");	
		return false;
	}
	
	var Ret=tkMakeServerCall("web.DHCPE.SpecialItemContral","SaveNew",UserID,str);
	if (Ret=="0"){
		$.messager.alert("提示","保存成功","success");
		$("#SpecialItemContralDetailTab").datagrid('load',{
			ClassName:"web.DHCPE.SpecialItemContral",
			QueryName:"SearcgSIContralDetail",
			UserID:UserID,
	        
			});

	}
	else {$.messager.alert("提示","保存失败","error");}
	
 }
 
function InitCombobox()
{
		//操作员
	   var OPNameObj = $HUI.combogrid("#UserName",{
		panelWidth:470,
		panelHeight:260,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXT",
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
		    {field:'DocDr',title:'ID',width:50},
			{field:'DocName',title:'姓名',width:200},
			{field:'Initials',title:'工号',width:190}	
				
		]],
		onLoadSuccess:function(){
			//$("#UserName").combogrid('setValue',""); 
		},

		});	 
} 

function InitSpecItemContDataGrid()
{
	$HUI.datagrid("#SpecialItemContralTab",{
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
			ClassName:"web.DHCPE.SpecialItemContral",
			QueryName:"SearchSpecialItemContral",
		},
		columns:[[
	
		    {field:'UserID',title:'UserID',hidden: true},
			{field:'UserCode',width:'200',title:'工号'},
			{field:'UserName',width:'290',title:'医生'}
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
			$('#ID').val(rowData.UserID); 
			$('#SpecialItemContralDetailTab').datagrid('loadData', {
				total: 0,
				rows: []
			});
			loadSpecItemContDetail(rowData);		
				
			
		}
		
			
	})

}


function loadSpecItemContDetail(row) {
	
	$('#SpecialItemContralDetailTab').datagrid('load', {
		ClassName: 'web.DHCPE.SpecialItemContral',
		QueryName: 'SearcgSIContralDetail',
		UserID: row.UserID,
		
	});
     $('#UserID').val(row.UserID);
	
}


function  InitSpecItemContDetailDataGrid()
{
		$HUI.datagrid("#SpecialItemContralDetailTab",{
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
		singleSelect: false,
		checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.SpecialItemContral",
			QueryName:"SearcgSIContralDetail",
			UserID:$("#UserID").val(),
		},
		frozenColumns:[[
			{title: '选择',field: 'Select',width: 60,checkbox:true},
		]],
		columns:[[
	
		    {field:'TItemID',title:'ItemID',hidden: true},
			{field:'TItemName',width:'600',title:'项目名称'},
			
		
		]],
		onLoadSuccess: function (rowData) { 
	   $('#SpecialItemContralDetailTab').datagrid('clearSelections'); //一定要加上这一句，要不然datagrid会记住之前的选中
	   //隐藏全选
	   //$("#SpecialItemContralDetailTab").parent().find("div .datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");
	
        var UserID=$("#UserID").val();
		if (UserID==""){
			return false;
		} 
		
	    var objtbl = $("#SpecialItemContralDetailTab").datagrid('getRows');
	              
		if (rowData) { 
		   
		  //遍历datagrid的行            
		 $.each(rowData.rows, function (index) {
			 //alert(UserID+"^"+objtbl[index].TItemID)
			 	var flag=tkMakeServerCall("web.DHCPE.SpecialItemContral","GetSpecItemContral",UserID,objtbl[index].TItemID);
			 			if(flag=="Y"){
				 			//加载页面时根据后台类方法返回值判断datagrid里面checkbox是否被勾选
				 		$('#SpecialItemContralDetailTab').datagrid('checkRow',index);
				 		}
		 });
		 
		 
		 }
		}	
			
	});
}
 



