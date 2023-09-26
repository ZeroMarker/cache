
//����	DHCPEOMEIllness.hisui.js
//����	Ŀ�꼲��ά��
//����	2019.05.07
//������  xy

$(function(){
		
	InitCombobox();
	
	InitOMEIllnessDataGrid();
      
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
		$.messager.alert("��ʾ","Ŀ�꼲������Ϊ��","info");
		return false;
	}
	
    var Conclusion=$("#Conclusion").combogrid('getValue');
  
    if (($("#Conclusion").combogrid('getValue')==undefined)||($("#Conclusion").combogrid('getValue')=="")){var Conclusion="";}
    if (""==Conclusion) {
		$("#Conclusion").focus();
		var valbox = $HUI.combogrid("#Conclusion", {
			required: true,
	   	});
		$.messager.alert("��ʾ","���۷��಻��Ϊ��","info");
		return false;
	}
	var ExpInfo=$("#ExpInfo").val();
	var Remark=$("#Remark").val();
	var ID=$("#ID").val();
	var iActive="N";
	var Active=$("#Active").checkbox('getValue');
	if(Active) iActive="Y";
	
	var Str=Code+"^"+Desc+"^"+iActive+"^"+Conclusion+"^"+ExpInfo+"^"+Remark;
	var rtn=tkMakeServerCall("web.DHCPE.OMEIllness","UpdateOMEIllness",ID,Str);
	var Arr=rtn.split("^");
	if (Arr[0]>0){
		BClear_click();
		if(Type=="1"){$.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});}
		if(Type=="0"){$.messager.popover({msg: '�����ɹ���',type:'success',timeout: 1000});}		
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
			
			$.m({ ClassName:"web.DHCPE.OMEIllness", MethodName:"OMEIllnessDelete",ID:RowId},function(ReturnValue){
				if (ReturnValue.split("^")[0]=='-1') {
					$.messager.alert("��ʾ","ɾ��ʧ��","error");  
				}else{
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					BClear_click();

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
	$("#Conclusion").combogrid('setValue',"");
	var valbox = $HUI.validatebox("#Code,#Desc", {
			required: false,
	   	});
	 var valbox = $HUI.combogrid("#Conclusion", {
			required: false,
	   	});
	$("#OMEIllnessQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.OMEIllness",
			QueryName:"SearchOMEIllness",
		});	
} 



function InitCombobox()
{
	  //���۷���
	   var ConclusionObj = $HUI.combogrid("#Conclusion",{
		panelWidth:670,
		url:$URL+"?ClassName=web.DHCPE.OMEIllness&QueryName=ConclusionList",
		mode:'remote',
		delay:200,
		idField:'ID',
		textField:'C_Desc',
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		columns:[[
		    {field:'ID',title:'ID',width:40},
		    {field:'C_Code',title:'����',width:100},
			{field:'C_Desc',title:'����',width:100},
			{field:'C_VIPLevel',title:'VIP�ȼ�',width:100},
			{field:'C_ExpInfo',title:'��չ��Ϣ',width:100},
			{field:'C_Severity',title:'���س̶�',width:100},
			{field:'C_Remark',title:'��ע',width:100},	
		]],
		onLoadSuccess:function(){
			$("#Conclusion").combogrid('setValue',"")
			
		},
		});
}

function InitOMEIllnessDataGrid()
{
	$HUI.datagrid("#OMEIllnessQueryTab",{
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
			ClassName:"web.DHCPE.OMEIllness",
			QueryName:"SearchOMEIllness",
		},
		columns:[[
	
		    {field:'TID',title:'TID',hidden: true},
		    {field:'TConclusionDR',title:'TConclusionDR',hidden: true},
			{field:'TCode',width:'150',title:'����'},
			{field:'TDesc',width:'250',title:'Ŀ�꼲��'},
			{field:'TConclusion',width:'280',title:'���۷���'},
			{field:'TActive',width:'150',title:'����'},
			{field:'TExpInfo',width:'200',title:'��չ��Ϣ'},
			{field:'TRemark',width:'150',title:'��ע'},
			
		
		]],
		onSelect: function (rowIndex, rowData) {
				$("#ID").val(rowData.TID);
				$("#Code").val(rowData.TCode);
				$("#Desc").val(rowData.TDesc);
				$("#ExpInfo").val(rowData.TExpInfo);
				$("#Remark").val(rowData.TRemark);
				$("#Conclusion").combogrid('setValue',rowData.TConclusionDR);
				if(rowData.TActive=="��"){
					$("#Active").checkbox('setValue',false);
				}if(rowData.TActive=="��"){
					$("#Active").checkbox('setValue',true);
				}			
					
		}
		
			
	})

}


