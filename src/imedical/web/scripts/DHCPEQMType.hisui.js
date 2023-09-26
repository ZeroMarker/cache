
//����	DHCPEQMType.hisui.js
//����	���������������	
//����	2019.04.28
//������  xy

$(function(){
	

	InitQMTypeDataGrid();
	
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
	var Remark=$("#Remark").val();
	var ExpStr=$("#ExpStr").val();
	if(Type=="1"){
		var ID=$("#ID").val();
		if(ID==""){
			$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
			return false;
		}
	}
	if(Type=="0"){
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
	   
		$.messager.alert("������ʾ","�������Ͳ���Ϊ��","error");
		return false;
	 }

	if (""==ExpStr) {
		$("#ExpStr").focus();
		var valbox = $HUI.validatebox("#ExpStr", {
			required: true,
	    });
		$.messager.alert("������ʾ","��չ��Ϣ����Ϊ��","error");
		return false;
	 }

	var SaveInfo=Code+"^"+Desc+"^"+Remark+"^"+ExpStr+"^"+iActiveFlag;
	var Ret=tkMakeServerCall("web.DHCPE.QualityManager","SaveQMType",ID,SaveInfo);
	var Arr=Ret.split("^");
	if (Arr[0]>0){
		if(Type=="1"){$.messager.alert("��ʾ","�޸ĳɹ�","success");}
		if(Type=="0"){$.messager.alert("��ʾ","�����ɹ�","success");}
		BClear_click();
		$("#QMTypeQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.QualityManager",
			QueryName:"SearchQMType"
			});
	
	}else{
		$.messager.alert("��ʾ",Arr[1],"error");
		
	} 

}

//����
function BClear_click()
{
	$("#Code,#Desc,#ExpStr,#Remark,#ID").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	
	var valbox = $HUI.validatebox("#Code,#Desc,#ExpStr", {
		required: false,
	  });
	
}


function InitQMTypeDataGrid(){
		$HUI.datagrid("#QMTypeQueryTab",{
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
			ClassName:"web.DHCPE.QualityManager",
			QueryName:"SearchQMType",
		
		},
		columns:[[
	
		    {field:'ID',title:'ID',hidden: true},
			{field:'Code',width:'200',title:'����'},
			{field:'Desc',width:'250',title:'��������'},
			{field:'ActiveFlag',width:'50',title:'����'},
			{field:'Remark',width:'350',title:'��ע'},
			{field:'ExpStr',width:'350',title:'��չ��Ϣ'}
					
		]],
		onSelect: function (rowIndex, rowData) {
				var Code=$("#Code").val(rowData.Code);
				var Desc=$("#Desc").val(rowData.Desc);
				var Remark=$("#Remark").val(rowData.Remark);
				var ExpStr=$("#ExpStr").val(rowData.ExpStr);
				var ID=$("#ID").val(rowData.ID);
				
				if(rowData.ActiveFlag=="��"){
					$("#ActiveFlag").checkbox('setValue',false);
				}if(rowData.ActiveFlag=="��"){
					$("#ActiveFlag").checkbox('setValue',true);
				}


		}
			
	})

		
}

