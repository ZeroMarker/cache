
//���� DHCPEPreTemplate.hisui.js
//����  ԤԼ�޶�ģ��ά��
//����	2020.09.04
//������  xy
//
$(function(){
	
	InitPreTemplateDataGrid();
	
	//����  
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
     
    //����   
   $("#BCreate").click(function() {	
		BCreate_click();		
        });
      
    $("#StartDate").datebox('setValue',SDate)
 
})
//���� 
function BUpdate_click()
{
	endEditing();
	var VIPID,Type,Num,OneStr="",Str="",LocID,UserID,rows=0;
	LocID=session['LOGON.CTLOCID'];
	UserID=session['LOGON.USERID'];

	var objtbl = $("#DHCPEPreTemplateTab").datagrid('getRows');
    var rows=objtbl.length
	for (var i=0;i<rows;i++){
		
		VIPID=objtbl[i].VIPID;
		OneStr=VIPID;
		Type=objtbl[i].Type;
		OneStr=OneStr+"^"+Type;
	    Num=objtbl[i].NUM1;		
		OneStr=OneStr+"^"+Num;
	    Num=objtbl[i].NUM2;		
		OneStr=OneStr+"^"+Num;
		Num=objtbl[i].NUM3;		
		OneStr=OneStr+"^"+Num;
		 Num=objtbl[i].NUM4;		
		OneStr=OneStr+"^"+Num;
	    Num=objtbl[i].NUM5;		
		OneStr=OneStr+"^"+Num;
		Num=objtbl[i].NUM6;		
		OneStr=OneStr+"^"+Num;
		Num=objtbl[i].NUM0;		
		OneStr=OneStr+"^"+Num;
		OneStr=OneStr+"^"+Num;
		if (Str==""){
			Str=OneStr;
		}else{
			Str=Str+"$"+OneStr;
		}
	}
	
	var ret=tkMakeServerCall("web.DHCPE.PreTemplate","Update",LocID,UserID,Str);
	if(ret==1) {
		$.messager.alert("��ʾ","����ɹ�","success");
		}
	else {
		$.messager.alert("��ʾ",ret,"info");
		}
}
 //����  
function BCreate_click()
{
	var obj,LocID="",UserID="",StartDate="",EndDate="",encmeth="";
	LocID=session['LOGON.CTLOCID'];
	UserID=session['LOGON.USERID'];
	
	StartDate=$("#StartDate").datebox('getValue')
	EndDate=$("#EndDate").datebox('getValue')
	
	if ((StartDate=="")||(EndDate=="")){
		$.messager.alert("��ʾ","���ڲ���Ϊ��","info");
		return false;
	}

	var iStartDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",StartDate)
	var iEndDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",EndDate)
	if(iStartDate>iEndDate){
		$.messager.alert("��ʾ","��ʼ���ڲ��ܴ��ڽ�������","info");
		return false;
	}

	var ret=tkMakeServerCall("web.DHCPE.PreTemplate","CreateRecord",LocID,UserID,StartDate,EndDate);
	if(ret=="OVER") {
		$.messager.alert("��ʾ","�����ɹ�","success");
	}
	else {
		$.messager.alert("��ʾ",ret,"info");
	}
}

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
			
			if ($('#DHCPEPreTemplateTab').datagrid('validateRow', editIndex)){
				
				$('#DHCPEPreTemplateTab').datagrid('endEdit',editIndex);
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
	}
function onClickCell(index,field,value){
	    
		if (editIndex!=index) {
			if (endEditing(field)){
				$('#DHCPEPreTemplateTab').datagrid('selectRow',index).datagrid('editCell',{index:index,field:field});
				editIndex = index;
				
			} else {
				$('#DHCPEPreTemplateTab').datagrid('selectRow',editIndex);
			}
		}
	 
	}
			
function InitPreTemplateDataGrid(){

	$HUI.datagrid("#DHCPEPreTemplateTab",{
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
			ClassName:"web.DHCPE.PreTemplate",
			QueryName:"SerchPreNum", 
		
			
		},columns:[[
		
			{field:'VIPID',hidden:true,title:''},
			{field:'VIPDesc',width:'150',title:'VIP�ȼ�'},
			{field:'NUM1',width:'150',title:'��һ',editor:{type:'text'}},
			{field:'NUM2',width:'150',title:'�ܶ�',editor:{type:'text'}},
			{field:'NUM3',width:'150',title:'����',editor:{type:'text'}},
			{field:'NUM4',width:'150',title:'����',editor:{type:'text'}},
			{field:'NUM5',width:'150',title:'����',editor:{type:'text'}},
			{field:'NUM6',width:'150',title:'����',editor:{type:'text'}},
			{field:'NUM7',width:'150',title:'����',editor:{type:'text'}},
		
		    
		
				
		]],
		onLoadSuccess:function(data){
			editIndex = undefined;
		},
		

	})
}
