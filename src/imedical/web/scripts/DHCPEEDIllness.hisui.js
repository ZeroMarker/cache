//����	DHCPEEDIllness.hisui.js
//����	Σ������Ŀ�꼲��ά��
//����	2019.06.14
//������  xy

$(function(){
	InitCombobox();
	
	InitEDIllnessGrid();
	    
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

function BSave_click(Type) {
	if(Type=="1"){
		var ID=$("#ENIllID").val();
		if(ID==""){
			$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
			return false;
		}
	}
	
	if(Type=="0"){
	    if($("#ENIllID").val()!=""){
			$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,�����������������","info");
			return false;
		}
	}
	var IllnessDR=$("#Illness").combogrid('getValue');
	if (($("#Illness").combogrid('getValue') == undefined) || ($("#Illness").combogrid('getValue') == "")) { var IllnessDR = ""; }	 
	
	if(Type=="1"){var IllnessDR=$("#IllnessID").val();}
	if(IllnessDR==""){
		$.messager.alert("��ʾ","Ŀ�꼲������Ϊ�գ�","info");
		return false;
	}
	
	if (IllnessDR!=""){
		var ret=tkMakeServerCall("web.DHCPE.DHCPECommon","IsIllness",IllnessDR);
		if(ret=="0"){
			$.messager.alert("��ʾ","��ѡĿ�꼲����","info");
			return false;
		}
	}
	
	var OMETypeDR=$("#OMEType").combogrid('getValue');
	if (($("#OMEType").combogrid('getValue')==undefined)||($("#OMEType").combogrid('getValue')=="")){var OMETypeDR="";}
	if(OMETypeDR==""){
		$.messager.alert("��ʾ","��ѡ�������࣡","info");
		return false;
	}

	var ExpInfo=$("#ExpInfo").val();
	if(ExpInfo==""){
		$.messager.alert("��ʾ","��������弲����","info");
		return false;
	}
	
	var Remark=$("#Remark").val();
	var ID=$("#ENIllID").val();
	var Parref=$.trim(selectrow);
	var iActive="N";
	var Active=$("#Active").checkbox('getValue');
	if(Active) iActive="Y";
	
	var Str=Parref+"^"+IllnessDR+"^"+OMETypeDR+"^"+iActive+"^"+ExpInfo+"^"+Remark;
	//alert(Str)
	
	var rtn=tkMakeServerCall("web.DHCPE.Endanger","EDIllnessSave",ID,Str);
	var Arr=rtn.split("^");
	if (rtn.split("^")[0]=="-1"){
		$.messager.alert("��ʾ","����ʧ��","error");
	} else {
		BClear_click();
		if(Type=="1"){$.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});}
		if(Type=="0"){$.messager.popover({msg: '�����ɹ���',type:'success',timeout: 1000});}
		
	}
}

//ɾ��
function BDel_click(){
	var ID=$("#ENIllID").val();
	if (ID=="")
	{
		$.messager.alert("��ʾ","��ѡ���ɾ���ļ�¼","info");
		return false;
	}
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.Endanger", MethodName:"EDIllnessDelete",ID:ID},function(ReturnValue){
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
	$("#ENIllID,#ExpInfo,#Remark,#IllnessID").val("");
	$("#Active").checkbox('setValue',true);
	$(".hisui-combogrid").combogrid('setValue',"");

	var valbox = $HUI.combogrid("#OMEType,#Illness", {
			required: false,
	});
	
	$("#EDIllnessGrid").datagrid('load',{
		ClassName:"web.DHCPE.Endanger",
		QueryName:"SearchEDIllness",
		Parref:$.trim(selectrow),
	});	
}

function InitCombobox() {
	//Ŀ�꼲��
	var IllnessObj = $HUI.combogrid("#Illness",{
		panelWidth:185,
		url:$URL+"?ClassName=web.DHCPE.Endanger&QueryName=IllnessList",
		mode:'remote',
		delay:200,
		idField:'ID',
		textField:'IT_Desc',
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		columns:[[
		    {field:'ID',title:'ID',hidden:true},
			{field:'IT_Code',title:'����',width:50},
			{field:'IT_Desc',title:'����',width:120},
			{field:'IT_ConclusionDR',title:'���۷���',hidden:true},	 	
		]],
		onLoadSuccess:function(){
			//$("#Illness").combogrid('setValue',""); 
		},
	});
		
	//�������
	var OMETypeObj = $HUI.combogrid("#OMEType",{
		panelWidth:325,
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
			{field:'OMET_Code',title:'����',width:50},
			{field:'OMET_Desc',title:'����',width:150},	
			{field:'OMET_VIPLevel',title:'VIP�ȼ�',width:100},	
					
		]],
		onLoadSuccess:function(){
			$("#OMEType").combogrid('setValue',""); 
		},
	});
}

function InitEDIllnessGrid() {
	$HUI.datagrid("#EDIllnessGrid",{
		url:$URL,
		border : false,
		striped : true,
		fit : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 25,
		pageList : [10,25,50,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Endanger",
			QueryName:"SearchEDIllness",
			Parref:$.trim(selectrow),
		},
		columns:[[
	
		    {field:'TID',title:'ID',hidden: true},
			{field:'TIllnessDesc',width:'110',title:'Ŀ�꼲��'},
			{field:'TOMEType',width:'110',title:'�������'},
			{field:'TExpInfo',width:'200',title:'���弲��'},
			{field:'TActive',width:'50',title:'����',align:'center'},
			{field:'TRemark',title:'��ע'}
		]],
		onSelect: function (rowIndex, rowData) {
			$("#ENIllID").val(rowData.TID);
			$("#Illness").combogrid('setValue',rowData.TIllnessDR);
			$("#IllnessID").val(rowData.TIllnessDR);
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