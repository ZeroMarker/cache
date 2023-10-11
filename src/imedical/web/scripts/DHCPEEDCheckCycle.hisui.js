
//����	DHCPEEDCheckCycle.hisui.js
//����	Σ�����ؼ������ά��
//����	2019.06.17
//������  xy

$(function(){
	InitCombobox();
	
	InitEDCheckCycleGrid();
	    
    //�޸�
	$("#update_btn").click(function() {	
		BUpdate_click();		
        });
        
     //����
	$("#add_btn").click(function() {	
		BAdd_click();		
        }); 
    
    //ɾ��
	$("#del_btn").click(function() {	
		BDel_click();		
        });   
    
    
    //����
	$("#BClear").click(function() {	
		BClear_click();		
        });
     
 
   
})


 //�޸�
function BUpdate_click(){
	BSave_click("1");
}

//����
function BAdd_click(){
	BSave_click("0");
}

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
	}
	var Code=$("#Code").val();
	
	if(Code==""){
		var valbox = $HUI.validatebox("#Code", {
			required: true,
	    });
		$.messager.alert("��ʾ","���벻��Ϊ��","info");
		return false;
	}
	
	var Desc=$("#Desc").val();
	if(Desc==""){
		var valbox = $HUI.validatebox("#Desc", {
			required: true,
	    });
		$.messager.alert("��ʾ","��������Ϊ��","info");
		return false;
	}
	
	var OMETypeDR=$("#OMEType").combogrid('getValue');
	if (($("#OMEType").combogrid('getValue')==undefined)||($("#OMEType").combogrid('getValue')=="")){var OMETypeDR="";}

	var ExpInfo=$("#ExpInfo").val();
	var Remark=$("#Remark").val();
	var ID=$("#ID").val();
	var Parref=$.trim(selectrow);
	var iActive="N";
	var Active=$("#Active").checkbox('getValue');
	if(Active) iActive="Y";
	var Str=Parref+"^"+Code+"^"+Desc+"^"+OMETypeDR+"^"+iActive+"^"+ExpInfo+"^"+Remark;
	//alert(Str)
	var rtn=tkMakeServerCall("web.DHCPE.Endanger","EDCheckCycleSave",ID,Str);
	var Arr=rtn.split("^");
	if (rtn.split("^")[0]=="-1"){
		$.messager.alert("��ʾ","����ʧ��"+rtn.split("^")[1],"error");
		
	}else{
		BClear_click();
		if(Type=="1"){$.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});}
		if(Type=="0"){$.messager.popover({msg: '�����ɹ���',type:'success',timeout: 1000});}
		
	}
	
	
	
}

//ɾ��
//ɾ��
function BDel_click(){
	var ID=$("#ID").val();
	if (ID=="")
	{
		$.messager.alert("��ʾ","��ѡ���ɾ���ļ�¼","info");
		return false;
	}
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.Endanger", MethodName:"EDCheckCycleDelete",ID:ID},function(ReturnValue){
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

function BClear_click(){
	$("#ID,#Code,#Desc,#ExpInfo,#Remark").val("");
	$("#Active").checkbox('setValue',true);
	$(".hisui-combogrid").combogrid('setValue',"");

	var valbox = $HUI.validatebox("#Code,#Desc", {
			required: false,
	    });
	$("#EDCheckCycleGrid").datagrid('load',{
			ClassName:"web.DHCPE.Endanger",
			QueryName:"SearchEDCheckCycle",
			Parref:$.trim(selectrow),
		});	
}


function InitCombobox(){
	
		
		//�������
	   var OMETypeObj = $HUI.combogrid("#OMEType",{
		panelWidth:400,
		url:$URL+"?ClassName=web.DHCPE.Endanger&QueryName=OMETypeList",
		mode:'remote',
		delay:200,
		idField:'ID',
		textField:'OMET_Desc',
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		columns:[[
		    {field:'ID',title:'ID',hidden: true},
			{field:'OMET_Code',title:'����',width:80},
			{field:'OMET_Desc',title:'����',width:180},	
			{field:'OMET_VIPLevel',title:'VIP�ȼ�',width:100},	
					
		]],
		onLoadSuccess:function(){
			$("#OMEType").combogrid('setValue',""); 
		},
		});
}

function InitEDCheckCycleGrid(){
	$HUI.datagrid("#EDCheckCycleGrid",{
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
			ClassName:"web.DHCPE.Endanger",
			QueryName:"SearchEDCheckCycle",
			Parref:$.trim(selectrow),
		},
		columns:[[
	
		    {field:'TID',title:'ID',hidden: true},
			{field:'TCode',width:'200',title:'����'},
			{field:'TDesc',width:'200',title:'����'},
			{field:'TOMEType',width:'150',title:'�������'},
			{field:'TActive',width:'60',title:'����'},
			{field:'TExpInfo',width:'130',title:'��չ��Ϣ'},
			{field:'TRemark',width:'100',title:'��ע'},
			
			
		]],
		onSelect: function (rowIndex, rowData) {
			    $("#ID").val(rowData.TID);
				$("#Code").val(rowData.TCode);
				$("#Desc").val(rowData.TDesc);
				$("#OMEType").combogrid('setValue',rowData.TOMETypeDR);
				$("#ExpInfo").val(rowData.TExpInfo);
				$("#Remark").val(rowData.TRemark);
				if(rowData.TActive=="��"){
					$("#Active").checkbox('setValue',false);
				}if(rowData.TActive=="��"){
					$("#Active").checkbox('setValue',true);
				};
					
												
		}
	})
}