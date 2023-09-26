
//����	DHCPEPreManager.hisui.js
//����  ԤԼ����
//����	2019.01.30
//������  xy


$(function(){
	
	InitPreManagerDataGrid();
	
	
	$("#DateStr").val(DateStr)
	//����  
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
     
    //����   
   $("#BCreate").click(function() {	
		BCreate_click();		
        });
        
    //�滻   
   $("#BReplace").click(function() {	
		BReplace_click();		
        });
 
})




var editIndex=undefined;
$.extend($.fn.datagrid.methods, {
			editCell: function(jq,param){
				return jq.each(function(){
					var opts = $(this).datagrid('options');
					var fields = $(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
					for(var i=0; i<fields.length; i++){
						var col = $(this).datagrid('getColumnOption', fields[i]);
						col.editor1 = col.editor;
						if (fields[i] != param.field){
							col.editor = null;
						}
					}
					$(this).datagrid('beginEdit', param.index);
					for(var i=0; i<fields.length; i++){
						var col = $(this).datagrid('getColumnOption', fields[i]);
						col.editor = col.editor1;
					}
				});
			}
});

function endEditing(field){
			
			if (editIndex == undefined){return true}
			
			if ($('#dhcpepremanagerQueryTab').datagrid('validateRow', editIndex)){
				
				$('#dhcpepremanagerQueryTab').datagrid('endEdit',editIndex);
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
	}
function onClickCell(index,field,value){
	    
		if (editIndex!=index) {
			if (endEditing(field)){
				$('#dhcpepremanagerQueryTab').datagrid('selectRow',index).datagrid('editCell',{index:index,field:field});
				editIndex = index;
				
			} else {
				$('#dhcpepremanagerQueryTab').datagrid('selectRow',editIndex);
			}
		}
	 
	}
			


function BCreate_click()
{
	var OldDate="",NewDate="",UserID="";
	OldDate=getValueById("DateStr");
	NewDate=getValueById("NewDate");
	if (NewDate==""){
		$.messager.alert("��ʾ","�滻���ڲ���Ϊ��","info");
		return false;
	}
	UserID=session['LOGON.USERID'];
	var ret=tkMakeServerCall("web.DHCPE.PreManager","Create",OldDate,NewDate,UserID);
	if(ret=="0"){
		$.messager.alert("��ʾ","���Ƴɹ�","success");
		$("#dhcpepremanagerQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.PreManager",
			QueryName:"FindPreManagerByDate",
			DateStr:getValueById("DateStr")
			})
	}
	//window.location.reload();
}


function BReplace_click()
{
	var OldDate="",NewDate="";
	OldDate=getValueById("DateStr");
	NewDate=getValueById("NewDate");
	if (NewDate==""){
		$.messager.alert("��ʾ","�滻���ڲ���Ϊ��","info");
		return false;
	}
	
	var ret=tkMakeServerCall("web.DHCPE.PreManager","Replace",OldDate,NewDate);
	
	if((ret=="0")||(ret="100")){
		$.messager.alert("��ʾ","�滻�ɹ�","success");
		$("#dhcpepremanagerQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.PreManager",
			QueryName:"FindPreManagerByDate" ,
			DateStr:getValueById("DateStr")
			})
	}
}

function BUpdate_click()
{
	
	var objtbl = $("#dhcpepremanagerQueryTab").datagrid('getRows');
    var rows=objtbl.length;
    
	for (var i=0;i<rows;i++)
	{
		var Type=objtbl[i].TType;
		var ID=objtbl[i].TID;
		var Num=objtbl[i].TNum;
		var GADMDesc=objtbl[i].TGADMDesc;
		ID=ID+"^"+Type;
		//alert(ID+"^"+Num+"^"+GADMDesc)
	    var ret=tkMakeServerCall("web.DHCPE.PreManager","UpdatePreManager",ID,Num,GADMDesc);
	}
	window.location.reload();
	
}
function InitPreManagerDataGrid(){

	$HUI.datagrid("#dhcpepremanagerQueryTab",{
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		onClickCell: onClickCell,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.PreManager",
			QueryName:"FindPreManagerByDate", 
			DateStr:DateStr 
			
		},columns:[[
		
			{field:'TID',hidden:true,title:''},
			{field:'TGADMID',hidden:true,title:''},
			{field:'TType',hidden:true,title:''},
			{field:'TNum',width:'150',title:'����',editor:{type:'text'}},
			{field:'TGADMDesc',width:'400',title:'��������'},
			{field:'TRemark',width:'200',title:'��ע'},		
		    
			{field:'str',title:'ʱ����Ϣ',width:'100',
			formatter:function(value,rowData,rowIndex){
				if(rowData.TID!=""){
					
					return '<a><img style="cursor:pointer" src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png" title="ʱ����Ϣ"  border="0" onclick="ShowPreTemplateTimerInfo('+rowIndex+')"></a>';
			
				}
				}},
				
		]],
		onLoadSuccess:function(data){
			editIndex = undefined;
		},
		

	})
}
function ShowPreTemplateTimerInfo(Index)
{
	 var objtbl = $("#dhcpepremanagerQueryTab").datagrid('getRows');
	 var ID=objtbl[Index].TID;
	 var Type=objtbl[Index].TType;
    var lnk=" dhcpepretemplatetime.hisui.csp?Type="+Type+"&ParRef="+ID;
    //alert(lnk)
	websys_lu(lnk,false,'width=800,height=400,hisui=true,title=ʱ����Ϣ')
	
	
}
