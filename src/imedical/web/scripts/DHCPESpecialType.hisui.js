
//����	DHCPESpecialType.hisui.js
//����	�������ͻ�����	
//����	2021.07.27
//������  xy
$(function(){

	InitSpecialTypeGrid();
	
	//�޸�
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
        
     //����
	$("#BAdd").click(function() {	
		BAdd_click();		
        });
        
    //����
	$("#BClear").click(function() {	
		BClear_click();		
        });
    
})

//�޸�
function BUpdate_click()
{
	BSave_click("1");
}

 //����
function BAdd_click()
{
	BSave_click("0");
}

//����
function BSave_click(Type)
{
	
	var Code=$("#Code").val();
	var Desc=$("#Desc").val();
	if(Type=="1"){
		var ID=$("#ID").val();
		if(ID==""){
			$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
			return false;
		}
	}
	if(Type=="0"){
		
		if($("#ID").val()!=""){
			$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,��������������","info");
			return false;
		}
		var ID="";
	}

	var iActiveFlag="N";
	var ActiveFlag=$("#ActiveFlag").checkbox('getValue');
	if(ActiveFlag) iActiveFlag="Y";
   
    if (""==Code) {
	    
		$("#Code").focus();
		var valbox = $HUI.validatebox("#Code", {
			required: true,
	  });
		$.messager.alert("������ʾ","���벻��Ϊ��","error");
		return false;
	 }
	 
      if (""==Desc) {
		$("#Desc").focus();
		var valbox = $HUI.validatebox("#Desc", {
			required: true,
	   });
	   
		$.messager.alert("������ʾ","��������Ϊ��","error");
		return false;
	 }


	var SaveInfo=Code+"^"+Desc+"^"+iActiveFlag;
	//alert(SaveInfo)
	//alert(ID)
	var Ret=tkMakeServerCall("web.DHCPE.SpecialType","SaveSPType",ID,SaveInfo);
	var Arr=Ret.split("^");
	if (Arr[0]>0){
		if(Type=="1"){$.messager.alert("��ʾ","�޸ĳɹ�","success");}
		if(Type=="0"){$.messager.alert("��ʾ","�����ɹ�","success");}
		BClear_click();
	   $("#SpecialTypeGrid").datagrid('reload');
	}else{
		$.messager.alert("��ʾ",Arr[1],"error");
		
	} 
	

}

//����
function BClear_click()
{
	$("#Code,#Desc,#ID").val("");
	$(".hisui-checkbox").checkbox('setValue',true);
	
	var valbox = $HUI.validatebox("#Code,#Desc", {
		required: false,
	  });
	 $("#SpecialTypeGrid").datagrid('reload');
	
}

function InitSpecialTypeGrid(){
	
		$HUI.datagrid("#SpecialTypeGrid",{
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
			ClassName:"web.DHCPE.SpecialType",
			QueryName:"SearchSPType",

		},
		columns:[[
		    {field:'ID',title:'ID',hidden: true},
			{field:'Code',width:'200',title:'����'},
			{field:'Desc',width:'250',title:'����'},
			{field:'ActiveFlag',width:'50',title:'����'}
					
		]],
		onSelect: function (rowIndex, rowData) {
				var Code=$("#Code").val(rowData.Code);
				var Desc=$("#Desc").val(rowData.Desc);
				var ID=$("#ID").val(rowData.ID);
				
				if(rowData.ActiveFlag=="��"){
					$("#ActiveFlag").checkbox('setValue',false);
				}if(rowData.ActiveFlag=="��"){
					$("#ActiveFlag").checkbox('setValue',true);
				}


		}
			
	})

		
}
