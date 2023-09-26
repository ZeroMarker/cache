
//����	DHCPEConclusion.hisui.js
//����	ְҵ�����۷���
//����	2019.05.06
//������  xy

$(function(){
		
	InitCombobox();
	
	InitConclusionDataGrid();
      
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
		$.messager.alert("��ʾ","���۷��಻��Ϊ��","info");
		return false;
	}
	var PEType=$("#VIPLevel").combobox('getValue');
	 if (($("#VIPLevel").combobox('getValue')==undefined)||($("#VIPLevel").combobox('getValue')=="")){var PEType="";}
	if (""==PEType) {
		$("#VIPLevel").focus();
		var valbox = $HUI.combobox("#VIPLevel", {
			required: true,
	   	});
		$.messager.alert("��ʾ","VIP�ȼ�����Ϊ��","info");
		return false;
	}
	
	var ExpInfo=$("#ExpInfo").val();
	var Remark=$("#Remark").val();
	var Severity=$("#Severity").val();
	var re = /^[0-9]+[0-9]*]*$/;
	if(Severity!=""){
		if (!re.test(Severity))
	 	{
		 	$("#Severity").focus();
		 	$.messager.alert("��ʾ","���س̶���������Ӧ����","info");
			return false;
		}
	}
	
	var ID=$("#ID").val();
	var iActive="N";
	var Active=$("#Active").checkbox('getValue');
	if(Active) iActive="Y";
	var Str=Code+"^"+Desc+"^"+iActive+"^"+PEType+"^"+ExpInfo+"^"+Severity+"^"+Remark;
	//alert(Str)
	var rtn=tkMakeServerCall("web.DHCPE.Conclusion","UpdateConclusion",ID,Str);
	var Arr=rtn.split("^");
	if (Arr[0]>0){
		if(Type=="1"){$.messager.alert("��ʾ","�޸ĳɹ�","success");}
		if(Type=="0"){$.messager.alert("��ʾ","�����ɹ�","success");}
		BClear_click();		
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
	
	var flag=tkMakeServerCall("web.DHCPE.Conclusion","IsUseConclusion",RowId);
	if(flag=="1"){
		var str="�ý��۷�����Ŀ�꼲������ʹ��, "
	}else{
		var str=""
	}
	
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.Conclusion", MethodName:"DeleteConclusion",ID:RowId},function(rtn){
				if (rtn.split("^")[0]=="-1") {
					$.messager.alert("��ʾ","ɾ��ʧ��:"+rtn.split("^")[1],"error");  
				}else{
					$.messager.alert("��ʾ","ɾ���ɹ�","success");
					BClear_click();
			        
				}
			});	
		}
	});
	
}

//����
function BClear_click()
{
	$("#ID,#Code,#Desc,#ExpInfo,#Severity,#Remark").val("");
	$("#VIPLevel").combobox('setValue',"")
	$(".hisui-checkbox").checkbox('setValue',false);
	var valbox = $HUI.validatebox("#Code,#Desc", {
			required: false,
	   	});
	var valbox = $HUI.combobox("#VIPLevel", {
			required: false,
	   	});
	$("#ConclusionQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.Conclusion",
			QueryName:"FindConclusion",
		});	
} 


function InitCombobox()
{
	 
		 //vip�ȼ�
	  var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		})
		
}

function InitConclusionDataGrid()
{
	$HUI.datagrid("#ConclusionQueryTab",{
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
			ClassName:"web.DHCPE.Conclusion",
			QueryName:"FindConclusion",
		},
		columns:[[
	
		    {field:'TRowId',title:'TRowId',hidden: true},
			{field:'TCode',width:'150',title:'����'},
			{field:'TDesc',width:'200',title:'���۷���'},
			{field:'TVIPLevelDR',title:'TVIPLevelDR',hidden: true},
			{field:'TVIPLevel',width:'150',title:'VIP�ȼ�'},
			{field:'TSeverity',width:'150',title:'���س̶�'},
			{field:'TActive',width:'150',title:'����'},
			{field:'TExpInfo',width:'250',title:'��չ��Ϣ'},
			{field:'TRemark',width:'150',title:'��ע'},
			
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#ID").val(rowData.TRowId);
				$("#Code").val(rowData.TCode);
				$("#Desc").val(rowData.TDesc);
				$("#Severity").val(rowData.TSeverity);
				$("#ExpInfo").val(rowData.TExpInfo);
				$("#Remark").val(rowData.TRemark);
				$("#VIPLevel").combobox('setValue',rowData.TVIPLevelDR);
				if(rowData.TActive=="��"){
					$("#Active").checkbox('setValue',false);
				}if(rowData.TActive=="��"){
					$("#Active").checkbox('setValue',true);
				}			
					
		}
		
			
	})

}


