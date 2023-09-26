///CreatDate:  2017-01-09
///Author:    yuliping
var editRow="";
$(function(){ 
	
	//科室下拉列表，选择后触发查询
    $("#LULocDr").combobox({    
   			valueField: "id", 
			textField: "text",
			editable:true,
			url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID,
			//url:'dhcapp.broker.csp?ClassName=web.DHCDISLocUser&MethodName=GetLoc&HospID='+hosp,
			mode:'remote',
			onSelect:function(){
				findItmlist();
					/*setTimeout(function(){
	 	  				commonQuery({'datagrid':'#datagrid','formid':'#queryForm'});
  					},100)*/
			}
	});
	//人员下拉列表，选择后触发查询
    $("#LUUserDr").combobox({    
   			valueField: "id", 
			textField: "text",
			mode:'remote',
			url:'dhcapp.broker.csp?ClassName=web.DHCDISLocUser&MethodName=GetSSUser&HospID='+hosp,
			onSelect:function(){
				findItmlist();
					/*setTimeout(function(){
	 	  				commonQuery({'datagrid':'#datagrid','formid':'#queryForm'});
  					},100)*/
			}
	});
	//项目名称下拉列表，选择后触发查询
    $("#itemName").combobox({    
   			valueField: "id", 
			textField: "text",
			url:'dhcapp.broker.csp?ClassName=web.DHCDISLocUser&MethodName=ListItemCode',
			onSelect:function(){
					setTimeout(function(){
	 	  				commonQuery({'datagrid':'#locdatagrid','formid':'#queryLocForm'});
	 	  		
  					},100)
			}
	});

	$('#find').bind('click',function(event){
         findItmlist(); //调用查询
    });
    
    $('#reset').bind('click',function(event){
	     $HUI.combobox('#LULocDr').setValue("");
		 $HUI.combobox('#LUUserDr').setValue("");
         findItmlist(); //调用查询
    });
	
});
function onDbClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
	
}
function onDbClickRows(index,row){
	CommonRowClick(index,row,"#locdatagrid");
	editRow = index;
	var rows = $("#locdatagrid").datagrid('getChanges'); 
	if(rows.length==1){
		$.messager.alert("提示","有未完成编辑的数据!"); 
		$("#locdatagrid").datagrid('endEdit', index)
		return;
	}
}
function onClickRow(index,row){

	$("#getLuId").val(row.ID)
	$("#LocUser").val(row.ID)
	
	$("#locdatagrid").datagrid({
		queryParams: {
		LocUser:row.ID,
		itemName:''
		}
});
}

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'LUActiveFlag':'Y','LUStatus':'0'}})
}
function save(){
	saveByDataGrid("web.DHCDISLocUser","SaveUpdLevReson","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("提示","科室人员已存在,不能重复保存!"); 
				$("#datagrid").datagrid('reload')
			}else if(data==-3){
				$.messager.alert("提示","请编辑必填数据!"); 
			}else{	
				$.messager.alert('提示','保存失败:'+data)
				
			}
		});	
}



function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCDISLocUser","RemoveUpdLevReson",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}

function addItemRow(){
	var liid=$("#getLuId").val();
	if(liid==""){
		$.messager.alert('提示','请选一个人员');
		return;
		}
	if(editRow>="0"){
		//$("#locdatagrid").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
		$.messager.alert("提示","有未完成编辑的数据!"); 
		return;
	}
	
	var rows = $("#locdatagrid").datagrid('getChanges');    
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Type=="")||(rows[i].Pointer=="")){
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return;
		}		
	} 
	$("#locdatagrid").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ItemDesc: '',ItemLoc:''}
	});
	$("#locdatagrid").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
	
}
function Itemsave(){
	if(editRow>="0"){
		$("#locdatagrid").datagrid('endEdit', editRow);
	
	}
	var LocUserID=$("#getLuId").val();
	var rows = $("#locdatagrid").datagrid('getChanges');
	
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		
		if((rows[i].ItemDesc=="")){ 
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return false;
		}
		var ID=rows[i].linkitem
		if(typeof(ID)=="undefined"){ 

			ID =0

		} 
		var tmp=LocUserID+"^"+ID+"^"+rows[i].ItemDesc
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("$$");
	
	//保存数据
	var data=serverCall("web.DHCDISLocLinkItem","SaveUpdUserLinkItem",
				{
					'params': rowstr
				})
	
	
		if(data==0){
			$.messager.alert("提示","保存成功!");		
		}else if(data==10){
			$.messager.alert("提示","记录重复，保存失败!");	
			$('#locdatagrid').datagrid('reload');
			return;		
		}else{
			$.messager.alert("提示","保存失败!");
			
			return;	
			
		}
		
		$('#locdatagrid').datagrid('reload'); //重新加载

}



function Itemcancel(){
	var LocUserID=$("#getLuId").val();
	
	if ($("#locdatagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}

	
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#locdatagrid").datagrid('getSelected');  
	    var tmp=LocUserID+"^"+row.linkitem+"^"+row.IDd
	   
		 runClassMethod("web.DHCDISLocLinkItem","RemoveUserLinkItem",{'str':tmp},function(data){ $('#locdatagrid').datagrid('load'); })
    }    
}); 
}
//重置，原来的不能传DHC_DisLocUser的ID
function reloadData(){
	//$("#itemName ").find('input').val('');
	var td=$("#itemName ").parents("td");
	var span=td.find("span")
	span.find("input").val('');
	$("#locdatagrid").datagrid({
		queryParams: {
		LocUser:$("#getLuId").val(),
		itemName:''
		}
});
	}
function ma(index,row){
	//alert(row.linkitem)
	
	}
	
///查询
function findItmlist()
{
	var loc=$HUI.combobox('#LULocDr').getValue();
	var user=$HUI.combobox('#LUUserDr').getValue();
	$('#datagrid').datagrid('load',{"LULocDr":loc,"LUUserDr":user}); 
}