
//����	DHCPEEDKey.hisui.js
//����	����ؼ���ά��
//����	2019.05.05
//������  xy

$(function(){
		
	
	InitEDKeyQueryTabDataGrid();
      
    //����
	$("#BClear").click(function() {	
		BClear_click();		
        });
    
     
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
	var ID=$("#ID").val();
	var Desc=$("#Desc").val();
	if (Desc==""){
		$("#Desc").focus();
		var valbox = $HUI.validatebox("#Desc", {
			required: true,
	   	});
		$.messager.alert("��ʾ","������ؼ���","info");
		return false;
	}
	var Color=$("#Color").val();
	if (Color==""){
		$("#Color").focus();
		var valbox = $HUI.validatebox("#Color", {
			required: true,
	   	});
		$.messager.alert("��ʾ","��������ɫ","info");
		return false;
	}
	//alert(ID+"^"+Desc+"^"+Color)
	var ret=tkMakeServerCall("web.DHCPE.EDKey","Update",ID,Desc,Color)
	if (ret=="0"){
	     BClear_click();
	    
		if(Type=="1"){$.messager.alert("��ʾ","�޸ĳɹ�","success");}
		if(Type=="0"){$.messager.alert("��ʾ","�����ɹ�","success");}
		
	}
	else
	{
		$.messager.alert("��ʾ","����ʧ��","error");
		
	}
 }

 //ɾ��
function BDelete_click()
{

    var ID=$("#ID").val();
    if(ID==""){
	    $.messager.alert("��ʾ","��ѡ���ɾ���ļ�¼","info");
	    return 
    }
    	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
				$.m({ ClassName:"web.DHCPE.EDKey", MethodName:"Delete",ID:ID},function(ReturnValue){
				if (ReturnValue!="0") {
					$.messager.alert("��ʾ","ɾ��ʧ��","error");  
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
	$("#Desc,#Color,#ID").val("");
	var valbox = $HUI.validatebox("#Desc,#Color", {
			required: false,
	   	});
	 $("#EDKeyQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.EDKey",
			QueryName:"SearchEDKey",
		});
}

function InitEDKeyQueryTabDataGrid()
{
	$HUI.datagrid("#EDKeyQueryTab",{
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
			ClassName:"web.DHCPE.EDKey",
			QueryName:"SearchEDKey",
		},
		columns:[[
	
		    {field:'TID',title:'TID',hidden: true},
			{field:'TDesc',width:'600',title:'�ؼ���'},
			{field:'TColor',width:'600',title:'��ɫ'},
		
		]],
		onSelect: function (rowIndex, rowData) {
			    
			    $("#ID").val(rowData.TID);
				$("#Desc").val(rowData.TDesc);
				$("#Color").val(rowData.TColor);		
				
			
		}
			
	})

}


