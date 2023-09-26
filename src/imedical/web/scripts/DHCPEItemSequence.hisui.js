
//����	DHCPEItemSequence.hisui.js
//����	ҽ���ڱ����ϵ���ʾ˳��	
//����	2019.04.30
//������  xy

$(function(){
		
	
	InitCombobox();
	
	InitItemSequenceDataGrid();
      
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



//����
function BClear_click()
{
	$("#ItemID").val("");
	$("#ItemName").combogrid('setValue',"");
	$("#ItemSequence").val("");
	var valbox = $HUI.validatebox("#ItemName,#ItemSequence", {
				required: false,
	    	});
	
	 $("#ItemSequenceQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.ItemSequence",
			QueryName:"SearchItemSeqInfo",
		});
}


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
		var iItemID=$("#ItemID").val();
		if(""==iItemID){
			$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
			return false;
		}
	}
	
	if(Type=="0"){
	   
	    if($("#ItemID").val()!=""){
		    	$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,�����������������","info");
		    	return false;
		    }
	    
			var iItemID=$("#ItemName").combogrid('getValue');
        	if (($("#ItemName").combogrid('getValue')==undefined)||($("#ItemName").combogrid('getValue')=="")){var iItemID="";}
	    
        if (""==iItemID) {
	 	  	$.messager.alert("��ʾ","ҽ�����Ʋ���Ϊ��","info");
		 	$("#ItemName").focus();
			var valbox = $HUI.validatebox("#ItemName", {
				required: true,
	    	});
			return false;
	 }
	
	}
	
   
    var iItemSequence=$("#ItemSequence").val();
    if (""==iItemSequence) {
	    	$.messager.alert("��ʾ","ҽ��˳����Ϊ��","info");
		 	$("#ItemSequence").focus();
			var valbox = $HUI.validatebox("#ItemSequence", {
				 required: true,
	    	});
			return false;
	 }
    
     var InString=trim(iItemID)+"^"+trim(iItemSequence);
	 var flag=tkMakeServerCall("web.DHCPE.ItemSequence","SaveNew",InString);                  
    if (flag==0)  
	{   
		if(Type=="1"){$.messager.alert("��ʾ","�޸ĳɹ�","success");}
		if(Type=="0"){$.messager.alert("��ʾ","�����ɹ�","success");}
		 
		BClear_click();
		 
	}
	else
	{
		$.messager.alert("��ʾ","����ʧ��","error");
		
	}
 }

 //ɾ��
function BDelete_click()
{
	var ID=$("#ItemID").val();
	if (ID=="") 
	{
		$.messager.alert("��ʾ","��ѡ���ɾ���ļ�¼","info");
		return;
	}
	var Sequence=$("#ItemSequence").val();
	var string=trim(ID)+"^"+trim(Sequence)
	var flag=tkMakeServerCall("web.DHCPE.ItemSequence","Delete",string);
	if (flag==0)
	{
		 BClear_click();
		$.messager.alert("��ʾ","ɾ���ɹ�","success");
		
	}
	else
	{
		$.messager.alert("��ʾ","ɾ��ʧ��","error");
		
	}
}

function InitCombobox()
{
	  //ҽ������
	   var OPNameObj = $HUI.combogrid("#ItemName",{
		panelWidth:400,
		url:$URL+"?ClassName=web.DHCPE.Public.SettingEdit&QueryName=QueryFeeID",
		mode:'remote',
		delay:200,
		idField:'ID',
		textField:'Name',
		onBeforeLoad:function(param){
			param.FeeTest = param.q;
		},
		columns:[[
		    {field:'ID',title:'ID',width:40},
			{field:'Name',title:'ҽ������',width:200},
			{field:'Code',title:'ҽ������',width:150},
			
				
		]],
		onLoadSuccess:function(){
			$("#ItemName").combogrid('setValue',""); 
		},

		});
}


function InitItemSequenceDataGrid()
{
	$HUI.datagrid("#ItemSequenceQueryTab",{
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
			ClassName:"web.DHCPE.ItemSequence",
			QueryName:"SearchItemSeqInfo",
		},
		columns:[[
	
		    {field:'TItemID',title:'TItemID',hidden: true},
			{field:'TItemCode',width:'350',title:'ҽ������'},
			{field:'TItemName',width:'500',title:'ҽ������'},
			{field:'TItemSequence',width:'300',title:'ҽ����ʾ˳��'}
				
		]],
		onSelect: function (rowIndex, rowData) {
			    
				$("#ItemID").val(rowData.TItemID);
				$("#ItemName").combogrid('setValue',rowData.TItemName);
				$("#ItemSequence").val(rowData.TItemSequence);
				
			
		}
			
	})

}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[0];
}	
