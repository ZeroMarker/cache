
//名称	DHCPEProtectiveMeasures.hisui.js
//功能	防护措施维护
//创建	2019.05.07
//创建人  xy

$(function(){
			
	InitProtectiveMeasuresDataGrid();
       
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
      
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
   
})

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
		var ID=$("#ID").val();
		if(ID==""){
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
	}
	
	if(Type=="0"){
	    if($("#ID").val()!=""){
		    	$.messager.alert("提示","新增数据不能选中记录,请点击清屏后进行新增","info");
		    	return false;
		    }
	}
	
	var Code=$("#Code").val();
	if (""==Code) {
		$("#Code").focus();
		var valbox = $HUI.validatebox("#Code", {
			required: true,
	    });
		$.messager.alert("提示","编码不能为空","info");
		return false;
	}
	var Desc=$("#Desc").val();
	if (""==Desc) {
		$("#Desc").focus();
		var valbox = $HUI.validatebox("#Desc", {
			required: true,
	    });
		$.messager.alert("提示","防护措施不能为空","info");
		return false;
	}
	

	var ExpInfo=$("#ExpInfo").val();
	var Remark=$("#Remark").val();
	var ID=$("#ID").val();
	var iActive="N";
	var Active=$("#Active").checkbox('getValue');
	if(Active) iActive="Y";
	var Str=Code+"^"+Desc+"^"+iActive+"^"+ExpInfo+"^"+Remark;
	//alert(Str)
	var rtn=tkMakeServerCall("web.DHCPE.ProtectiveMeasures","UpdateProtectiveMeasures",ID,Str);
	var Arr=rtn.split("^");
	if (Arr[0]>0){
		BClear_click();
		if(Type=="1"){$.messager.alert("提示","修改成功","success");}
		if(Type=="0"){$.messager.alert("提示","新增成功","success");}	
	}else{
		$.messager.alert("提示",Arr[1],"error");	
	} 	
	
	
}

//删除
function BDelete_click()
{
	var RowId=$("#ID").val();
	if (RowId=="")
	{
		$.messager.alert("提示","请先选择待删除的记录","info");	
		return false;
	}
	
	var rtn=tkMakeServerCall("web.DHCPE.ProtectiveMeasures","DeleteProtectiveMeasures",RowId);
	if (rtn.split("^")[0]=="-1"){
		$.messager.alert("提示","删除失败"+rtn.split("^")[1],"error");	
	}else{
		BClear_click();
		$.messager.alert("提示","删除成功","success");
	}
	
	
}

//清屏
function BClear_click()
{
	$("#ID,#Code,#Desc,#ExpInfo,#Remark").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	var valbox = $HUI.validatebox("#Code,#Desc", {
			required: false,
	    });
	$("#ProtectiveMeasuresQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.ProtectiveMeasures",
			QueryName:"SearchProtectiveMeasures",
		});	
} 




function InitProtectiveMeasuresDataGrid()
{
	$HUI.datagrid("#ProtectiveMeasuresQueryTab",{
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
			ClassName:"web.DHCPE.ProtectiveMeasures",
			QueryName:"SearchProtectiveMeasures",
		},
		columns:[[
	
		    {field:'TID',title:'TID',hidden: true},
			{field:'TCode',width:'200',title:'代码'},
			{field:'TDesc',width:'280',title:'防护措施'},
			{field:'TActive',width:'150',title:'激活'},
			{field:'TExpInfo',width:'300',title:'扩展信息'},
			{field:'TRemark',width:'250',title:'备注'},
			
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#ID").val(rowData.TID);
				$("#Code").val(rowData.TCode);
				$("#Desc").val(rowData.TDesc);
				$("#ExpInfo").val(rowData.TExpInfo);
				$("#Remark").val(rowData.TRemark);
				if(rowData.TActive=="否"){
					$("#Active").checkbox('setValue',false);
				}if(rowData.TActive=="是"){
					$("#Active").checkbox('setValue',true);
				}			
					
		}
		
			
	})

}


