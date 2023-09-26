
//����	DHCPEILLEDRelate.hisui.js
//����	�����뽨�����
//����	2019.06.05
//������  xy

$(function(){
		
	$("#ILLSName").val(selectrowDesc);
	
	InitCombobox();
	
	InitILLEDRelateDataGrid();
      
     //����
    $('#BClear').click(function(e){
    	BClear_click();
    });
     
    //����
    $('#add_btn').click(function(e){
    	AddData();
    });
    
    
    //ɾ��
    $('#del_btn ').click(function(){
    	DelData();
    });
    
   
     
})


//����
function BClear_click(){
	$("#RowId").val("");
		$("#EDDesc").combogrid('setValue',"");
		$("#ILLEDRelateGrid").datagrid('load',{
			ClassName:"web.DHCPE.IllnessStandard",
			QueryName:"EDCondition",
			ParrefRowId:selectrow, 
		});	
	
}
//����
function AddData(){
	Update("0");
}


//ɾ��
function DelData(){
	Update("1");
}

function Update(Type){
	var ID=$("#RowId").val();
    if((Type=="1")&&(ID=="")){
	     $.messager.alert('��ʾ','��ѡ���ɾ���ļ�¼',"info");
	     return false;
    }
   
    if(Type=="0"){
	    if(ID!==""){
		     $.messager.alert('��ʾ','�������ݲ���ѡ�м�¼,������������',"info");
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
		$.messager.alert('��ʾ','������������Ϊ��',"info");
	     return false;
	}
  }
	if(Type=="1"){ InString=ID;}
    else{InString=ID+"^"+EDID+"^"+IllID;}
  
	var flag=tkMakeServerCall("web.DHCPE.IllnessStandard","UpdateIDR",InString,Type);
	if (flag==0)
	{
		if(Type=="1"){$.messager.alert('��ʾ',"ɾ���ɹ�","success");}
		if(Type=="0"){$.messager.alert('��ʾ',"�����ɹ�","success");}
		BClear_click();
	}else{
		$.messager.alert('��ʾ',"����ʧ��","error");
	}
}

function InitCombobox(){
	//��������
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
		    {field:'Detail',title:'����',width:100},
		    {field:'DiagnoseConclusion',title:'����',width:180},
			{field:'Code',title:'����',width:80},			
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
			{field:'TILLNessDesc',width:100,title:'��������'},
			{field:'TEDDesc',width:100,title:'��������'},
			{field:'TEDDetail',width:580,title:'��������'},
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#RowId").val(rowData.TRowID);
				
				
					
		}
		
			
	})
}