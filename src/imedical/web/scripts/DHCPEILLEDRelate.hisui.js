
//名称	DHCPEILLEDRelate.hisui.js
//功能	疾病与建议对照
//创建	2019.06.05
//创建人  xy

$(function(){
		
	$("#ILLSName").val(selectrowDesc);
	
	InitCombobox();
	
	InitILLEDRelateDataGrid();
      
     //清屏
    $('#BClear').click(function(e){
    	BClear_click();
    });
     
    //新增
    $('#add_btn').click(function(e){
    	AddData();
    });
    
    
    //删除
    $('#del_btn ').click(function(){
    	DelData();
    });
    
   
     
})


//清屏
function BClear_click(){
	$("#RowId").val("");
		$("#EDDesc").combogrid('setValue',"");
		$("#ILLEDRelateGrid").datagrid('load',{
			ClassName:"web.DHCPE.IllnessStandard",
			QueryName:"EDCondition",
			ParrefRowId:selectrow, 
		});	
	
}
//新增
function AddData(){
	Update("0");
}


//删除
function DelData(){
	Update("1");
}

function Update(Type){
	var ID=$("#RowId").val();
    if((Type=="1")&&(ID=="")){
	     $.messager.alert('提示','请选择待删除的记录',"info");
	     return false;
    }
   
    if(Type=="0"){
	    if(ID!==""){
		     $.messager.alert('提示','新增数据不能选中记录,先清屏再新增',"info");
	     	return false;
	    }
	    var ID="";
	    }
  if(Type=="0") {
    var IllID=selectrow;
    var EDID=$("#EDDesc").combogrid('getValue');
    if (($("#EDDesc").combogrid('getValue')==undefined)||($("#EDDesc").combogrid('getValue')=="")){var EDID="";}
    
    if (EDID=="")
	{
		$.messager.alert('提示','建议描述不能为空',"info");
	     return false;
	}
  }
	if(Type=="1"){ InString=ID;}
    else{InString=ID+"^"+EDID+"^"+IllID;}
  
	var flag=tkMakeServerCall("web.DHCPE.IllnessStandard","UpdateIDR",InString,Type);
	if (flag==0)
	{
		if(Type=="1"){$.messager.alert('提示',"删除成功","success");}
		if(Type=="0"){$.messager.alert('提示',"新增成功","success");}
		BClear_click();
	}else{
		$.messager.alert('提示',"操作失败","error");
	}
}

function InitCombobox(){
	//建议描述
	var EDDescObj = $HUI.combogrid("#EDDesc",{
		panelWidth:400,
		url:$URL+"?ClassName=web.DHCPE.DHCPEExpertDiagnosis&QueryName=GetEDiagnosisByAlias",
		mode:'remote',
		delay:200,
		idField:'ID',
		textField:'Detail',
		onBeforeLoad:function(param){
			param.AddDiagnosis = param.q;
		},
		columns:[[
		    {field:'ID',title:'ID',hidden: true},
		    {field:'Detail',title:'结论',width:100},
		    {field:'DiagnoseConclusion',title:'建议',width:180},
			{field:'Code',title:'编码',width:80},			
		]]
		});
}

function InitILLEDRelateDataGrid(){
	$HUI.datagrid("#ILLEDRelateGrid",{
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
			ClassName:"web.DHCPE.IllnessStandard",
			QueryName:"EDCondition",
			ParrefRowId:selectrow, 
		    
		},
		columns:[[
		    {field:'TRowID',title:'ID',hidden: true},
		    {field:'TEDID',title:'EDID',hidden: true},
			{field:'TILLNessDesc',width:100,title:'疾病描述'},
			{field:'TEDDesc',width:100,title:'建议描述'},
			{field:'TEDDetail',width:580,title:'建议内容'},
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#RowId").val(rowData.TRowID);
				
				
					
		}
		
			
	})
}