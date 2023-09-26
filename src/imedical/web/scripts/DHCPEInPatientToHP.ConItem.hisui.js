
//名称	DHCPEInPatientToHP.ConItem.hisui.js
//功能	会诊费设置
//创建	2019.05.05
//创建人  xy

$(function(){
		
	InitCombobox();
	
	InitIPToHPConItemDataGrid();
      
    //默认会诊医嘱
	$("#BSaveDefaultItem").click(function() {	
		BSaveDefaultItem_click();		
        });
    
    //保存项目
	$("#BSaveItem").click(function() {	
		BSaveItem_click();		
        });
        
   
})

//默认会诊医嘱
function BSaveDefaultItem_click()
{
	
	var LocID=session['LOGON.CTLOCID'];
	var DefaultItemID=$("#DefaultItemDesc").combogrid('getValue');
    if (($("#DefaultItemDesc").combogrid('getValue')==undefined)||($("#DefaultItemDesc").combogrid('getValue')=="")){var DefaultItemID="";}
	if ( DefaultItemID==""){
		//$.messager.alert("提示","请选择默认会诊医嘱","info");
		//return false;
	}
	var ret=tkMakeServerCall("web.DHCPE.OtherPatientToHPBaseSet","SetConOrderDefault",LocID,DefaultItemID);
	$("#IPToHPConItemQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.OtherPatientToHPBaseSet",
			QueryName:"FindCarPrvTp",
		});
		$.messager.alert("提示","默认会诊医嘱成功","success");
}

//保存项目
function BSaveItem_click()
{
	
	var LocID=session['LOGON.CTLOCID'];
	var CarPrvTpID=$("#ID").val();
	if (CarPrvTpID==""){
		$.messager.alert("提示","请选择职称，然后保存数据","info");
		return false;
	}
	var ItemID=$("#ItemDesc").combogrid('getValue');
    if (($("#ItemDesc").combogrid('getValue')==undefined)||($("#ItemDesc").combogrid('getValue')=="")){var ItemID="";}
	
	var ret=tkMakeServerCall("web.DHCPE.OtherPatientToHPBaseSet","SetCarPrvTpConOrder",CarPrvTpID,LocID,ItemID);
	
	 $("#IPToHPConItemQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.OtherPatientToHPBaseSet",
			QueryName:"FindCarPrvTp",
		});
		$.messager.alert("提示","保存项目成功","success");
}
 
 


function InitCombobox()
{
	  //医嘱名称
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
			{field:'Name',title:'医嘱名称',width:200},
			{field:'Code',title:'医嘱编码',width:150},
			
				
		]]
		});
		 //医嘱名称
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
			{field:'Name',title:'医嘱名称',width:200},
			{field:'Code',title:'医嘱编码',width:150},
			
				
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
			{field:'Desc',width:'250',title:'职称'},
			{field:'InternalType',width:'250',title:'类型'},
			{field:'ARCIMDesc',width:'300',title:'项目'},
			{field:'DefaultARCIMDesc',width:'350',title:'默认会诊医嘱'},
			
		
		]],
		onSelect: function (rowIndex, rowData) {
			    
				$("#ID").val(rowData.CarPrvTpID);
				$("#CarPrvTpDesc").val(rowData.Desc);
				$("#ItemDesc").combogrid('setValue',rowData.ARCIMDesc);		
					
		}
		
			
	})

}


