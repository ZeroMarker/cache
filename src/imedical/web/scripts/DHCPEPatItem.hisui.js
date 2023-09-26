
//名称	DHCPEPatItem.hisui.js
//功能	导诊单顺序设置
//创建	2019.05.08
//创建人  xy

$(function(){
		
	InitCombobox();
	
	InitPatItemDataGrid();
    
    InitPatItemlistDataGrid(); 
    
     
      //修改(导诊单类别设置)
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
        
     //新增(导诊单类别设置)
	$("#BAdd").click(function() {	
		BAdd_click();		
        });  
     
        
    //删除(导诊单类别设置)
	$("#BDelete").click(function() {	
		Delete_Click();		
        });
      
    //清屏(导诊单类别设置)
	$("#BClearP").click(function() {	
		BClearP_click();		
        });
     
       
      //修改(导诊单详情)
	$("#BUpdateL").click(function() {	
		BUpdateL_click();		
        });
        
     //新增(导诊单详情)
	$("#BAddL").click(function() {	
		BAddL_click();		
        }); 
     //清屏(导诊单详情)
	$("#BClearL").click(function() {	
		BClearL_click();		
        });
   
})

//修改(导诊单类别设置)
function BUpdate_click()
{  
	 Update("0");
}

//新增(导诊单类别设置)
function BAdd_click()
{
	 Update("2");
}
 


//删除
function Delete_Click()
{
	var RowID=$("#PID").val();
	if(RowID==""){
		$.messager.alert("提示","请选择待删除的记录","info");	
		return false;
		
		}
	Update("1");
	
}


function Update(Type)
{
	
	if(Type=="0"){
		var RowID=$("#PID").val();
		if(RowID==""){
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
	}
	if(Type=="2"){
	    if($("#PID").val()!=""){
		    	$.messager.alert("提示","新增数据不能选中记录,请点击清屏后进行新增","info");
		    	return false;
		    }
		var RowID="";
	}
	
	var AutoChange="N",Reporttype="PatItem",AutoChange="N";
	var RowID=$("#PID").val();
	
	var Name=$("#Name").val();
	if (""==Name) {
		$("#Name").focus();
		var valbox = $HUI.validatebox("#Name", {
			required: true,
	    });
		$.messager.alert("提示","类别不能为空","info");
		return false;
	}
	
	var Sort=$("#Sort").val();
	if (""==Sort) {
		$("#Sort").focus();
		var valbox = $HUI.validatebox("#Sort", {
			required: true,
	    });
		$.messager.alert("提示","顺序不能为空","info");
		return false;
	}
	var Place=$("#Place").val();
	
	var iIFDocSign="N"
	var IFDocSign=$("#IFDocSign").checkbox('getValue');
	if(IFDocSign) iIFDocSign="Y";
	
	var iPatSignName="N"
	var PatSignName=$("#PatSignName").checkbox('getValue');
	if(PatSignName) iPatSignName="Y";
	
	var Strs=Name+"^"+Sort+"^^"+AutoChange+"^"+Place+"^"+iIFDocSign+"^"+iPatSignName;
	
	if(Type=="1"){
		$.messager.confirm("确认", "确定要删除该记录吗？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.SetPatItem", MethodName:"Update",RowID:RowID,Strs:Strs,isDel:Type,Type:Reporttype},function(ReturnValue){
			if (ReturnValue!='0') {
					$.messager.alert("提示","删除失败","error");  
				}else{
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					BClearP_click();
					BClearL_click();
					    
				}
			});	
		}
	});
		
	}else{
		var flag=tkMakeServerCall("web.DHCPE.SetPatItem","Update",RowID,Strs,Type,Reporttype);
		
	if(flag==0){
		BClearP_click();
	
		if(Type=="0"){
			$.messager.alert("提示","修改成功","success");	
		}
		if(Type=="2"){
			$.messager.alert("提示","新增成功","success");	
		}
		
	}
	}
	
	
	//类别
	  var PatItemObj = $HUI.combobox("#PatItemName",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatItem&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		});
	
		
}

//修改(导诊单详情)
function BUpdateL_click()
{  
	 BSaveL_click("1");
}

//新增(导诊单详情)
function BAddL_click()
{
	BSaveL_click("0");
}
 
//更新(导诊单详情)
function BSaveL_click(Type)
{
	
	if(Type=="1"){
		var ARCIMID=$("#LID").val();
		var ARCIMIDNew=$("#ARCIMDesc").combogrid('getValue');
		
		if(ARCIMID==""){
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
		
		if((ARCIMIDNew!=ARCIMID)&&(ARCIMIDNew.indexOf("||")>0)){
				$.messager.alert("提示","关联新的医嘱请新增","info");
			return false;
		}
	}
	
    if(Type=="0"){
	    if($("#LID").val()!=""){
		    	$.messager.alert("提示","新增数据不能选中记录,请点击清屏后进行新增","info");
		    	return false;
		    }
		
		var ARCIMID=$("#ARCIMDesc").combogrid('getValue');
		if (($("#ARCIMDesc").combogrid('getValue')==undefined)||($("#ARCIMDesc").combogrid('getValue')=="")){var ARCIMID="";}
		if (ARCIMID==""){
			var valbox = $HUI.validatebox("#ARCIMDesc", {
				required: true,
	    	});
			$.messager.alert("提示","医嘱名称不能为空","info");
			return false
		}
		if (ARCIMID.indexOf("||")<0){
			$.messager.alert("提示","请选择医嘱名称","info");
			return false
		}

	}
	
	var PatItem=$("#PatItemName").combobox('getValue');
	if (PatItem==""){
		var valbox = $HUI.validatebox("#PatItemName", {
			required: true,
	    });
		$.messager.alert("提示","类别不能为空","info");
		return false
	}
	
	
	var Sort=$("#SortL").val();
	
	var iPrintFlag="N";
	var PrintFlag=$("#PrintFlag").checkbox('getValue');
	if(PrintFlag)iPrintFlag="Y";
	
	var PrintName=$("#PrintName").val();
	
	
	var Str=PatItem+"^"+Sort+"^"+iPrintFlag+"^"+PrintName;
	
	if(Type=="1"){
		   var ret=tkMakeServerCall("web.DHCPE.SetPatItem","UpdateItemInfo",ARCIMID,Str);
			$.messager.alert("提示","修改成功","success"); 
				BClearL_click();
		}
	if(Type=="0"){
		var flag=tkMakeServerCall("web.DHCPE.SetPatItem","IsExsitPatItem",ARCIMID);
			$.messager.confirm("确认", "该医嘱已关联导诊单类别，确定要修改吗？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.SetPatItem", MethodName:"UpdateItemInfo",ARCIMID:ARCIMID,Str:Str},function(ReturnValue){
			if (ReturnValue=='0') {
					$.messager.alert("提示","新增成功","success"); 
						BClearL_click();
					
				}
			}); 
		}
	});
			
		}
			
	
}



//清屏(导诊单设置)
function BClearP_click()
{ 
	$("#PID,#Name,#Sort,#Place").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	var valbox = $HUI.validatebox("#Name,#Sort", {
		required: false,
	  });
	$("#PatItemTab").datagrid('load',{
			ClassName:"web.DHCPE.SetPatItem",
			QueryName:"SetPatItem",
		});

	
} 

//清屏(导诊单详情)
function BClearL_click()
{
	$("#LID,#PrintName,#SortL").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	$("#Station").combobox('setValue',"");
	$("#ARCIMDesc").combogrid('setValue',"");
	/*
	var valbox = $HUI.validatebox("#PatItemName,#ARCIMDesc", {
			required: false,
	    });	
	    */
	var PatItem=$("#PatItemName").combobox('getValue');
     $('#PatItemName').combobox('setValue',PatItem);
    
	$('#PatItemlistTab').datagrid('load', {
		ClassName: 'web.DHCPE.SetPatItem',
		QueryName: 'SetPatItemListNew',
		PatItemName: PatItem,
		
	});
	
	
	
} 

function InitCombobox()
{
	  //站点
	  var StationObj = $HUI.combobox("#Station",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationBase&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		onChange:function()
		{
			OrdObj.clear();
			
		},
		});

	 //类别
	  var PatItemObj = $HUI.combobox("#PatItemName",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatItem&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		});
	
	
	//项目
	var OrdObj = $HUI.combogrid("#ARCIMDesc",{
		panelWidth:350,
		url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=QueryAll",
		mode:'remote',
		delay:200,
		idField:'STORD_ARCIM_DR',
		textField:'STORD_ARCIM_Desc',
		onBeforeLoad:function(param){
			param.ParRef = $("#Station").combobox('getValue');
			param.ARCIMDesc = param.q;
		},
		onShowPanel:function()
		{
			$('#ARCIMDesc').combogrid('grid').datagrid('reload');
		},
		columns:[[
		   {field:'STORD_ParRef',title:'站点ID',hidden: true},
		    {field:'STORD_ParRef_Name',title:'站点',width:100},
			{field:'STORD_ARCIM_Desc',title:'医嘱名称',width:120},
			{field:'STORD_ARCIM_Code',title:'医嘱编码',width:100},
			{field:'STORD_ARCIM_DR',title:'医嘱ID',hidden: true},
					
		]]
		});
}

function InitPatItemDataGrid()
{
	$HUI.datagrid("#PatItemTab",{
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
			ClassName:"web.DHCPE.SetPatItem",
			QueryName:"SetPatItem",
		},
		columns:[[
	
		    {field:'TID',title:'ID',hidden: true},
			{field:'TName',width:150,title:'类别'},
			{field:'TSort',width:40,title:'顺序'},
			{field:'TIFDocSign',width:80,title:'医生签名'},
			{field:'TPatSignName',width:80,title:'患者签名'},
			{field:'TPlace',width:300,title:'位置'},
			

			
		]],
		onSelect: function (rowIndex, rowData) {
			  
				$("#PID").val(rowData.TID);
				$("#Name").val(rowData.TName);
				$("#Sort").val(rowData.TSort);
				$("#Place").val(rowData.TPlace);
				
				if(rowData.TIFDocSign=="否"){
					$("#IFDocSign").checkbox('setValue',false);
				}if(rowData.TIFDocSign=="是"){
					$("#IFDocSign").checkbox('setValue',true);
				};
				if(rowData.TPatSignName=="否"){
					$("#PatSignName").checkbox('setValue',false);
				}if(rowData.TPatSignName=="是"){
					$("#PatSignName").checkbox('setValue',true);
				};
				
							
			$('#PatItemlistTab').datagrid('loadData', {
				total: 0,
				rows: []
			});
			loadPatItemlist(rowData);			
					
		}
		
			
	})

}

function loadPatItemlist(row) {
	
	$('#PatItemlistTab').datagrid('load', {
		ClassName: 'web.DHCPE.SetPatItem',
		QueryName: 'SetPatItemListNew',
		PatItemName: row.TID,
		
	});
	
	$('#PatItemName').combobox('setValue',row.TID);
	$("#LID,#PrintName,#SortL").val("");
	$("#PrintFlag").checkbox('setValue',false);
	$("#Station").combobox('setValue',"");
	$("#ARCIMDesc").combogrid('setValue',"");

}

function InitPatItemlistDataGrid()
{
		$HUI.datagrid("#PatItemlistTab",{
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
			ClassName: 'web.DHCPE.SetPatItem',
			QueryName: 'SetPatItemListNew',
		},
		columns:[[
	
		    {field:'TARCIMID',title:'ID',hidden: true},
			{field:'STRowId',title:'STRowId',hidden: true},
			{field:'TARCIMDesc',width:250,title:'医嘱名称'},
			{field:'TPrintName',width:250,title:'打印名称'},
			{field:'TSort',width:50,title:'序号'},
			{field:'TPrintFlag',width:40,title:'打印'},
	
		]],
		onSelect: function (rowIndex, rowData) {
			    $("#Station").combobox('setValue',rowData.STRowId);
				$("#ARCIMDesc").combogrid('setValue',rowData.TARCIMDesc);
				$("#PrintName").val(rowData.TPrintName);
				$("#SortL").val(rowData.TSort);
				$("#LID").val(rowData.TARCIMID);
				
				if(rowData.TPrintFlag=="否"){
					$("#PrintFlag").checkbox('setValue',false);
				}if(rowData.TPrintFlag=="是"){
					$("#PrintFlag").checkbox('setValue',true);
				};							
		}
		
			
	})

}


