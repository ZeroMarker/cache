
//����	DHCPEILLSAlias.hisui.js
//����	��������ά��
//����	2019.06.05
//������  xy

$(function(){
		
	$("#ILLSName").val(selectrowDesc);
	
	InitILLSAliasDataGrid();
      
    //����
    $('#add_btn').click(function(e){
    	AddData();
    });
    
    //�޸�
    $('#update_btn').click(function(){
    	UpdateData();
    });
    
    //ɾ��
    $('#del_btn ').click(function(){
    	DelData();
    });
     
})

//����
function AddData(){
	Update("0");
}

//�޸�
function UpdateData(){
	Update("2");
}

//ɾ��
function DelData(){
	Update("1");
}

function Update(Type){
	var ID=$("#AliasRowId").val();
    if((Type=="1")&&(ID=="")){
	     $.messager.alert('��ʾ','��ѡ���ɾ���ļ�¼',"info");
	     return false;
    }
    if((Type=="2")&&(ID=="")){
	     $.messager.alert('��ʾ','��ѡ����޸ĵļ�¼',"info");
	     return false;
    }
    if(Type=="0"){var ID="";}
    var EDId=selectrow;
    var Alias=$("#Alias").val();
	if (Alias=="")
	{
		$.messager.alert('��ʾ','��������Ϊ��',"info");
	     return false;
	}
	
	
	if(Type=="1"){
		 var DataStr=ID;	
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			$.m({ ClassName:"web.DHCPE.IllnessStandard", MethodName:"UpdateAlias",DataStr:DataStr,isDelete:Type},function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("��ʾ","ɾ��ʧ��","error");  
				}else{
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					$("#AliasRowId,#Alias").val("");
					$("#ILLSAliasGrid").datagrid('load',{
						ClassName:"web.DHCPE.IllnessStandard",
						QueryName:"FindIllAlias",
						ILLSRowID:selectrow, 
					});	
				}
				});
			
		 }
	 });
	}else{
		var DataStr=ID+"^"+EDId+"^"+Alias;
		var flag=tkMakeServerCall("web.DHCPE.IllnessStandard","UpdateAlias",DataStr,Type);
		if (flag==0)
		{
		if(Type=="2"){$.messager.alert('��ʾ',"�޸ĳɹ�","success");}
		if(Type=="0"){$.messager.alert('��ʾ',"�����ɹ�","success");}
		$("#AliasRowId,#Alias").val("");
		$("#ILLSAliasGrid").datagrid('load',{
			ClassName:"web.DHCPE.IllnessStandard",
			QueryName:"FindIllAlias",
			ILLSRowID:selectrow, 
		});	
	}else{
		$.messager.alert('��ʾ',"����ʧ��","error");
	}
		
	}

}

function InitILLSAliasDataGrid(){
	$HUI.datagrid("#ILLSAliasGrid",{
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
			QueryName:"FindIllAlias",
			ILLSRowID:selectrow, 
		    
		},
		columns:[[
		    {field:'id',title:'ID',hidden: true},
			{field:'desc',width:'730',title:'����'},
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#AliasRowId").val(rowData.id);
				$("#Alias").val(rowData.desc);
				
					
		}
		
			
	})
}