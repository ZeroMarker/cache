
//����	DHCPEInPatientToHP.ConItem.hisui.js
//����	���������
//����	2019.05.05
//������  xy

$(function(){
		
	InitCombobox();
	
	InitIPToHPConItemDataGrid();
      
    //Ĭ�ϻ���ҽ��
	$("#BSaveDefaultItem").click(function() {	
		BSaveDefaultItem_click();		
        });
    
    //������Ŀ
	$("#BSaveItem").click(function() {	
		BSaveItem_click();		
        });
        
   
})

//Ĭ�ϻ���ҽ��
function BSaveDefaultItem_click()
{
	
	var LocID=session['LOGON.CTLOCID'];
	var DefaultItemID=$("#DefaultItemDesc").combogrid('getValue');
    if (($("#DefaultItemDesc").combogrid('getValue')==undefined)||($("#DefaultItemDesc").combogrid('getValue')=="")){var DefaultItemID="";}
	if ( DefaultItemID==""){
		//$.messager.alert("��ʾ","��ѡ��Ĭ�ϻ���ҽ��","info");
		//return false;
	}
	var ret=tkMakeServerCall("web.DHCPE.OtherPatientToHPBaseSet","SetConOrderDefault",LocID,DefaultItemID);
	$("#IPToHPConItemQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.OtherPatientToHPBaseSet",
			QueryName:"FindCarPrvTp",
		});
		$.messager.alert("��ʾ","Ĭ�ϻ���ҽ���ɹ�","success");
}

//������Ŀ
function BSaveItem_click()
{
	
	var LocID=session['LOGON.CTLOCID'];
	var CarPrvTpID=$("#ID").val();
	if (CarPrvTpID==""){
		$.messager.alert("��ʾ","��ѡ��ְ�ƣ�Ȼ�󱣴�����","info");
		return false;
	}
	var ItemID=$("#ItemDesc").combogrid('getValue');
    if (($("#ItemDesc").combogrid('getValue')==undefined)||($("#ItemDesc").combogrid('getValue')=="")){var ItemID="";}
	
	var ret=tkMakeServerCall("web.DHCPE.OtherPatientToHPBaseSet","SetCarPrvTpConOrder",CarPrvTpID,LocID,ItemID);
	
	 $("#IPToHPConItemQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.OtherPatientToHPBaseSet",
			QueryName:"FindCarPrvTp",
		});
		$.messager.alert("��ʾ","������Ŀ�ɹ�","success");
}
 
 


function InitCombobox()
{
	  //ҽ������
	   var OPNameObj = $HUI.combogrid("#DefaultItemDesc",{
		panelWidth:430,
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
			
				
		]]
		});
		 //ҽ������
	   var OPNameObj = $HUI.combogrid("#ItemDesc",{
		panelWidth:430,
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
			
				
		]]
		});
}

function InitIPToHPConItemDataGrid()
{
	$HUI.datagrid("#IPToHPConItemQueryTab",{
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
			ClassName:"web.DHCPE.OtherPatientToHPBaseSet",
			QueryName:"FindCarPrvTp",
		},
		columns:[[
	
		    {field:'CarPrvTpID',title:'CarPrvTpID',hidden: true},
			{field:'Desc',width:'250',title:'ְ��'},
			{field:'InternalType',width:'250',title:'����'},
			{field:'ARCIMDesc',width:'300',title:'��Ŀ'},
			{field:'DefaultARCIMDesc',width:'350',title:'Ĭ�ϻ���ҽ��'},
			
		
		]],
		onSelect: function (rowIndex, rowData) {
			    
				$("#ID").val(rowData.CarPrvTpID);
				$("#CarPrvTpDesc").val(rowData.Desc);
				$("#ItemDesc").combogrid('setValue',rowData.ARCIMDesc);		
					
		}
		
			
	})

}


