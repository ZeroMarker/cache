
//名称 DHCPEPreTemplate.hisui.js
//功能  预约限额模板维护
//创建	2020.09.04
//创建人  xy
//
$(function(){
	
	InitPreTemplateDataGrid();
	
	//保存  
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
     
    //新增   
   $("#BCreate").click(function() {	
		BCreate_click();		
        });
      
    $("#StartDate").datebox('setValue',SDate)
 
})
//保存 
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
		$.messager.alert("提示","保存成功","success");
		}
	else {
		$.messager.alert("提示",ret,"info");
		}
}
 //新增  
function BCreate_click()
{
	var obj,LocID="",UserID="",StartDate="",EndDate="",encmeth="";
	LocID=session['LOGON.CTLOCID'];
	UserID=session['LOGON.USERID'];
	
	StartDate=$("#StartDate").datebox('getValue')
	EndDate=$("#EndDate").datebox('getValue')
	
	if ((StartDate=="")||(EndDate=="")){
		$.messager.alert("提示","日期不能为空","info");
		return false;
	}

	var iStartDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",StartDate)
	var iEndDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",EndDate)
	if(iStartDate>iEndDate){
		$.messager.alert("提示","开始日期不能大于结束日期","info");
		return false;
	}

	var ret=tkMakeServerCall("web.DHCPE.PreTemplate","CreateRecord",LocID,UserID,StartDate,EndDate);
	if(ret=="OVER") {
		$.messager.alert("提示","创建成功","success");
	}
	else {
		$.messager.alert("提示",ret,"info");
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
			{field:'VIPDesc',width:'150',title:'VIP等级'},
			{field:'NUM1',width:'150',title:'周一',editor:{type:'text'}},
			{field:'NUM2',width:'150',title:'周二',editor:{type:'text'}},
			{field:'NUM3',width:'150',title:'周三',editor:{type:'text'}},
			{field:'NUM4',width:'150',title:'周四',editor:{type:'text'}},
			{field:'NUM5',width:'150',title:'周五',editor:{type:'text'}},
			{field:'NUM6',width:'150',title:'周六',editor:{type:'text'}},
			{field:'NUM7',width:'150',title:'周日',editor:{type:'text'}},
		
		    
		
				
		]],
		onLoadSuccess:function(data){
			editIndex = undefined;
		},
		

	})
}
