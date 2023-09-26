//zhouxin 2016-04-19
$(function(){ 
	//选择上级部位
	$('#datagrid').datagrid({    
		 onClickRow:function(rowIndex, rowData){
	            $("#AOIOptParRef").val(rowData.ID);
	            $('#subdatagrid').datagrid('load', {    
				    AOIOptParRef: rowData.ID  
				}); 
         }
	});
});

//函数commonQuery 和 commonReload 说明
//<a class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="javascript:commonQuery({'datagrid':'#datagrid','formid':'#queryForm'})">查询</a> 

//如上所示在csp中给按钮注册 单击事件
//commonQuery 和 commonReload 的入参都是 json字符串,格式为 {'datagrid':'#datagrid','formid':'#queryForm'}
// 其中datagrid 是datagrid的id
 // formid 是<form>的id ，这个form必须是在所有查询条件的父容器，所有查询条件都必须在这个容器里面
 // <input type="text" name="AOCode" class="textParent"></input>
 //所有查询条件都应该有name属性，这里的属性和后台类的入参名相同
 // 如果满足以上条件，调用commonQuery({'datagrid':'#datagrid','formid':'#queryForm'})
 // 会把#queryForm 下面的所有表单元素提交到datagrid 定义的后台类方法，并且类方法的入参名和表单元素的name一直
 //  commonReload 方法同 commonQuery ,只不过是清空查询条件而已

//其他部位字典新增一行
//commonAddRow 函数说明
//第一个参数 datagrid 是需要新增一行的datagrid的id
//第二个参数 value 是新增行赋初始值
//如果没有需要初始的值可以不传第二个参数
function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'AORequired':'Y','AOType':'Input'}})
}
//其他部位字典双击编辑
//第三个参数将双击的datagrid的id传入
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}
//其他部位保存
//"web.DHCAPPOtherOpt" 类名
//"save"   			  方法名
//"#datagrid"          要保存的datagrid的id
// 此方法自动将datagrid中的编辑的待保存的数据传入后台
// 一行数据之间用 "^" 分割
// 多行数据之间用 "$$" 分割
// 提交 到后台的参数名是 params
// 第四个参数是后台执行完的回调函数

function save(){
	saveByDataGrid("web.DHCAPPOtherOpt","save","#datagrid",function(data){
			if(data==0){
				$.messager.alert('提示','保存成功')			
			}else if(data==-10){
				$.messager.alert('提示','代码重复')	
			}else{
				$.messager.alert('提示','保存失败:'+data)
			}
			$("#datagrid").datagrid('reload')
		});	
}

function addRowSub(){
	if($("#AOIOptParRef").val() == ""){
		$.messager.alert('提示','请先选择其它项目字典')
		return;
	}
	commonAddRow({'datagrid':'#subdatagrid',value:{AOIOptParRef:$("#AOIOptParRef").val()}})
}
function onClickRowSub(index,row){
	CommonRowClick(index,row,"#subdatagrid");
}
function saveSub(){
	saveByDataGrid("web.DHCAPPOtherOpt","saveSub","#subdatagrid",function(data){
		if(data == 0){     //qunianpeng 2016-07-15
			$.messager.alert('提示','添加成功');
		}else if(data == -10){
			$.messager.alert('提示','代码不能重复');
		}else{
			$.messager.alert('提示','添加失败:'+data);
		}		
		$("#subdatagrid").datagrid('reload');
	});	

}





function cancelSub(){
	
	if ($("#subdatagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#subdatagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCAPPOtherOpt","removeSub",{'Id':row.ID},function(data){ $('#subdatagrid').datagrid('load'); })
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
		 runClassMethod("web.DHCAPPOtherOpt","remove",{'Id':row.ID},function(data){
			  if(data==1){     //lvpeng  2016/7/13
				$.messager.alert("提示：","此项已被引用，无法删除");	 
			 }else{
				$.messager.alert("提示：","删除成功");	 
		     }
			  $('#datagrid').datagrid('load'); })
    }    
}); 
}

///sufan 增加了commonQuery,commonReload方法
function commonQuery()
{
	var code=$("#code").val();
	var desc=$("#desc").val();
	$('#datagrid').datagrid('load',{AOCode:code,AODesc:desc}); 
}

function commonReload()
{
	$("#code").val("");
	$("#desc").val("");
	commonQuery();
}

/// 根据选择类型设置【是否必填】下拉列表
function reLoadReq(){
	
	var ed=$("#datagrid").datagrid('getEditor',{index:editIndex,field:'AOType'});
	if ($(ed.target).combobox("getValue")== "Check"){
		var ed=$("#datagrid").datagrid('getEditor',{index:editIndex,field:'AORequired'});
		$(ed.target).combobox("clear");
		$(ed.target).combobox("loadData",[{"value":"N","text":'否'}]);
		$(ed.target).combobox('setValue',"N");
	}else{
		var ed=$("#datagrid").datagrid('getEditor',{index:editIndex,field:'AORequired'});
		$(ed.target).combobox("loadData",[{"value":"N","text":'否'},{"value":"Y","text":'是'}]);
	}
	
}
