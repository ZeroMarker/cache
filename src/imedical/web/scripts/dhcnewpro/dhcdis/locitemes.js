///CreatDate:  2017-01-07
///Author:    yuliping
var ItmID="";
$(function(){ 
	//同时给代码和描述绑定回车事件
     $('#LICode,#LIDesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}); //调用查询
        }
    });
    $('#Code,#Desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagridsub','formid':'#queryFormsub'}); //调用查询
        }
    });
});
function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'LIType':'1','LIActiveFlag':'Y',LIHospDrID:'2','LIHospDr':'2','LITypeAddDr':'1'}})
}
function onClickRow(index,row){
	
	CommonRowClick(index,row,"#datagrid");
}
function save(){
	
	saveByDataGrid("web.DHCDISLocItemEs","SaveUpdLevReson","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
			
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#datagrid").datagrid('reload')
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
		 runClassMethod("web.DHCDISLocItemEs","RemoveUpdLevReson",{'Id':row.ID},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}
function fillvalue(obj)
{
	var ed=$("#datagrid").datagrid('getEditor',{index:editIndex, field:'LITypeAddDesc'});			//项目ID赋值
	$(ed.target).val(obj.text);
	var ed=$("#datagrid").datagrid('getEditor',{index:editIndex, field:'LITypeAddDr'});				//项目描述赋值
	$(ed.target).val(obj.value);
	
}
function fillHospvalue(obj)
{
	var ed=$("#datagrid").datagrid('getEditor',{index:editIndex, field:'LIHospDr'});			//项目ID赋值
	$(ed.target).val(obj.text);
	var ed=$("#datagrid").datagrid('getEditor',{index:editIndex, field:'LIHospDrID'});				//项目描述赋值
	$(ed.target).val(obj.value);
}

function onClickLocRow(index,row)
{
	ItmID=row.ID;
	$('#datagridsub').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISLocItemLinkRec&MethodName=ListLocItemLinkRec',	
		queryParams:{
			Item:ItmID}
	});
	
	
}
///关联接收科室内容
function SubaddRow(){
	commonAddRow({'datagrid':'#datagridsub',value:{'LREItemDr':ItmID,'LRELocDr':''}})
}
function onClickRowsub(index,row){

	CommonRowClick(index,row,"#datagridsub");
}
function Subsave(){
	
	saveByDataGrid("web.DHCDISLocItemLinkRec","SaveUpdLevReson","#datagridsub",function(data){
			if(data==0){
				//$.messager.alert("提示","保存成功!");
				$("#datagridsub").datagrid('reload')
			}else if(data==1){
			
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#datagridsub").datagrid('reload')
			}else{	
				$.messager.alert('提示','保存失败:'+data)
				
			}
		});	
	/*if(editIndex>="0"){
		$("#datagridsub").datagrid('endEdit', editIndex);
	}

	var rowsData = $("#datagridsub").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		var tmp=ItmID +"^"+ rowsData[i].LRELocDr ;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//保存数据
	runClassMethod("web.DHCDISLocItemLinkRec","SaveUpdLevReson",{"params":params},function(data){
		
		if (data==0){
			$('#datagridsub').datagrid('reload'); //重新加载
		}else if (data==1){
				$.messager.alert("提示","代码已存在,不能重复保存!"); 
				$("#datagridsub").datagrid('reload')
		}else{	
				$.messager.alert('提示','保存失败:'+data)
				
			}
		//$('#arccatlist').datagrid('reload'); //重新加载
	});	*/
		
}



function Subcancel(){
	
	if ($("#datagridsub").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#datagridsub").datagrid('getSelected');     
		 runClassMethod("web.DHCDISLocItemLinkRec","RemoveUpdLevReson",{'Id':row.ID},function(data){ $('#datagridsub').datagrid('load'); })
    }    
}); 
}