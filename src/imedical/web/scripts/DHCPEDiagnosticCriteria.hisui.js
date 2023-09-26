
//����	DHCPEDiagnosticCriteria.hisui.js
//����	��ϱ�׼ά��
//����	2019.05.07
//������  xy

$(function(){
		
	
	InitDiagnosticCriteriaDataGrid();
      
 
     //�޸�
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
        
     //����
	$("#BAdd").click(function() {	
		BAdd_click();		
        });  
    
    //ɾ��
	$("#BDelete").click(function() {	
		BDelete_click();		
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
	
	
	if(Type=="1"){
		var ID=$("#ID").val();
		if(ID==""){
			$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
			return false;
		}
	}
	
	if(Type=="0"){
	    if($("#ID").val()!=""){
		    	$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,�����������������","info");
		    	return false;
		    }
		var ID="";
	}
	
	var Code=$("#Code").val();
	if (""==Code) {
		$("#Code").focus();
		var valbox = $HUI.validatebox("#Code", {
			required: true,
	    });
		$.messager.alert("��ʾ","���벻��Ϊ��","info");
		return false;
	}
	var Desc=$("#Desc").val();
	if (""==Desc) {
		$("#Desc").focus();
		var valbox = $HUI.validatebox("#Desc", {
			required: true,
	    });
		$.messager.alert("��ʾ","��ϱ�׼����Ϊ��","info");
		return false;
	}
	
    var ID=$("#ID").val();
	var ExpInfo=$("#ExpInfo").val();
	var Remark=$("#Remark").val();
	
	var iActive="N";
	var Active=$("#Active").checkbox('getValue');
	if(Active) iActive="Y";
	var Str=Code+"^"+Desc+"^"+iActive+"^"+ExpInfo+"^"+Remark;
	//alert(Str)
	
	var rtn=tkMakeServerCall("web.DHCPE.DiagnosticCriteria","UpdateDiagnosticCriteria",ID,Str);
	var Arr=rtn.split("^");
	if (Arr[0]>0){
		BClear_click();
		if(Type=="1"){$.messager.alert("��ʾ","�޸ĳɹ�","success");}
		if(Type=="0"){$.messager.alert("��ʾ","�����ɹ�","success");}
	}else{
		$.messager.alert("��ʾ",Arr[1],"error");	
	} 	
	
	
}


//ɾ��
function BDelete_click()
{
	var RowId=$("#ID").val();
	if (RowId=="")
	{
		$.messager.alert("��ʾ","����ѡ���ɾ���ļ�¼","info");	
		return false;
	}
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
				$.m({ ClassName:"web.DHCPE.DiagnosticCriteria", MethodName:"DeleteDiagnosticCriteria",ID:RowId},function(ReturnValue){
				if (ReturnValue.split("^")[0]=="-1") {
					$.messager.alert("��ʾ","ɾ��ʧ��"+rtn.split("^")[1],"error");  
				}else{
					BClear_click();
					$.messager.alert("��ʾ","ɾ���ɹ�","success");
				}
				});
		}
	});
	
	
}

//����
function BClear_click()
{
	$("#ID,#Code,#Desc,#ExpInfo,#Remark").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	var valbox = $HUI.validatebox("#Code,#Desc", {
			required: false,
	    });
	$("#DiagnosticCriteriaQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.DiagnosticCriteria",
			QueryName:"SearchDiagnosticCriteria",
		});	
} 




function InitDiagnosticCriteriaDataGrid()
{
	$HUI.datagrid("#DiagnosticCriteriaQueryTab",{
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
			ClassName:"web.DHCPE.DiagnosticCriteria",
			QueryName:"SearchDiagnosticCriteria",
		},
		columns:[[
	
		    {field:'TID',title:'TID',hidden: true},
			{field:'TCode',width:'200',title:'����'},
			{field:'TDesc',width:'280',title:'��ϱ�׼'},
			{field:'TActive',width:'150',title:'����'},
			{field:'TExpInfo',width:'300',title:'��չ��Ϣ'},
			{field:'TRemark',width:'250',title:'��ע'},
			
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#ID").val(rowData.TID);
				$("#Code").val(rowData.TCode);
				$("#Desc").val(rowData.TDesc);
				$("#ExpInfo").val(rowData.TExpInfo);
				$("#Remark").val(rowData.TRemark);
				if(rowData.TActive=="��"){
					$("#Active").checkbox('setValue',false);
				}if(rowData.TActive=="��"){
					$("#Active").checkbox('setValue',true);
				}			
					
		}
		
			
	})

}


