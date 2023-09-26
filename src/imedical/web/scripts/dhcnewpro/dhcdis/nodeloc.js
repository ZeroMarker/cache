/// Creator: zhaowuqiang
/// CreateDate: 2017-03-23
//  Descript:中转站维护

var editRow="";parentID="";  //当前编辑行号
var dataArray=[{"value":"Y","text":"Y"},{"value":"N","text":"N"}];
$(function(){
	
	//同时给代码和描述绑定回车事件
     $('#NLcode,#NLDesc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
	        findNodeLoc();  //调用查询
            //commonQuery({'datagrid':'#nodeloclist','formid':'#queryForm'}); //调用查询
        }
    });
	
	var Flageditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:dataArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			editable:false, 
			onSelect:function(option){
				///设置类型值
				var ed=$("#nodeloclist").datagrid('getEditor',{index:editRow,field:'nlenabled'});
				$(ed.target).combobox('setValue', option.text);  //设置是否可用
			} 
		}

	}
	var Loceditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCDISNodeLoc&MethodName=SelLoc", 
			required:true,
			panelHeight:"200",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#nodeloclist").datagrid('getEditor',{index:editRow,field:'nlloc'});
				$(ed.target).combobox('setValue', option.text); 
				var ed=$("#nodeloclist").datagrid('getEditor',{index:editRow,field:'nllocid'});
				$(ed.target).val(option.value);
			} 
		}
	}
	var NLLLoceditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCDISNodeLoc&MethodName=SelLoc", 
			required:true,
			panelHeight:"200",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#nodeloclinklist").datagrid('getEditor',{index:editRow,field:'nllloc'});
				$(ed.target).combobox('setValue', option.text); 
				var ed=$("#nodeloclinklist").datagrid('getEditor',{index:editRow,field:'nlllocid'});
				$(ed.target).val(option.value);    
			} 
		}
	}
	// 定义columns
	var columns=[[
		{field:"nlcode",title:'代码',width:100,align:'center',editor:{type:'validatebox',options:{required:true}}}, 
		{field:"nldesc",title:'描述',width:130,align:'center',editor:{type:'validatebox',options:{required:true}}},
		{field:'nlenabled',title:'是否可用',width:130,align:'center',editor:Flageditor},
		//{field:'nlloc',title:'所属科室',width:200,align:'center',editor:Loceditor},
		//{field:'nllocid',title:'科室ID',width:130,align:'center',editor:{type:'text'},hidden:true},
		{field:"nlid",title:'ID',width:70,align:'center',editor:{type:'validatebox'},hidden:true}
	]];
	var option = {
		title:'配送中转站字典维护',
		singleSelect : true,
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != "") { 
                $("#nodeloclist").datagrid('endEdit', editRow); 
            } 
            $("#nodeloclist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        },
        onClickRow:function(rowIndex, rowData){
			$('#nodeloclinklist').datagrid('reload',{params: rowData.nlid});
			parentID=rowData.nlid
	    }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCDISNodeLoc&MethodName=QueryNodeLoc";
	new ListComponent('nodeloclist', columns, uniturl, option).Init();
	// 定义columns
	var columns=[[
		{field:'nllloc',title:'关联业务科室',width:300,align:'center',editor:NLLLoceditor},   
		{field:"nlllocid",title:'关联科室ID',width:70,align:'center',editor:{type:'validatebox'},hidden:true},
		{field:"nllid",title:'ID',width:70,align:'center',editor:{type:'validatebox'},hidden:true},
		{field:"parentid",title:'parentID',width:70,align:'center',editor:{type:'validatebox'},hidden:true}
	]];
	///  定义datagrid  
	var option = {
		title:'配送中转站关联业务科室',
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != "") { 
                $("#nodeloclinklist").datagrid('endEdit', editRow); 
            } 
            $("#nodeloclinklist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCDISNodeLoc&MethodName=QueryNodeLocLink";
	new ListComponent('nodeloclinklist', columns, uniturl, option).Init();
	
	//按钮绑定事件
    $('#NLinsert').bind('click',NLinsertRow);
    $('#NLsave').bind('click',NLsaveRow);
    $('#NLdelete').bind('click',NLdeleteRow);
    $('#NLLinsert').bind('click',NLLinsertRow); 
    $('#NLLsave').bind('click',NLLsaveRow);
    $('#NLLdelete').bind('click',NLLdeleteRow);
    
    $('#NLfind').bind('click',function(event){
         findNodeLoc(); //调用查询
    });
  
		
})

function NLinsertRow(){
	if(editRow>="0"){
		$("#nodeloclist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	 
	$("#nodeloclist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {nlid: '',nlcode:'',nldesc: '',nlloc:'',nlenabled:'Y',nllocid:''} 
	});
            
	$("#nodeloclist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}
function NLLinsertRow(){
	if(parentID==""){
	$.messager.alert("提示","请选择中转站!");
		return;
	}
	if(editRow>="0"){
		$("#nodeloclinklist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#nodeloclinklist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {nllid: '',nllloc:'2',nlllocid:'2',parentid:parentID} 
	});
            
	$("#nodeloclinklist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}
function NLsaveRow(){
	if(editRow>="0"){
		$("#nodeloclist").datagrid('endEdit', editRow);
	}
	var rowsData = $("#nodeloclist").datagrid('getChanges');
	//console.log(rowsData);
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if((rowsData[i].nllloc=="")||(rowsData[i].nldesc=="")||(rowsData[i].nlenabled=="")){ //huaxiaoying 2017-01-06
			$.messager.alert("提示","请编辑必填数据!"); 
			return false;
		}
		var tmp=rowsData[i].nlid +"^"+ rowsData[i].nlcode +"^"+ rowsData[i].nldesc +"^"+ rowsData[i].nlenabled +"^"+ "";
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//保存数据
	runClassMethod("web.DHCDISNodeLoc","SaveNodeLoc",{"params":params},function(jsonString){
		if(jsonString==0){
			$.messager.alert("提示","保存成功!"); 
			$('#nodeloclist').datagrid('reload'); //重新加载
		}else if(jsonString==-96){
			$.messager.alert("提示","代码重复!"); 
			$('#nodeloclist').datagrid('reload'); //重新加载
		}else{
			$.messager.alert("提示","保存失败!"); 
			$('#nodeloclist').datagrid('reload'); //重新加载
		}
	});
}
function NLLsaveRow(){
	if(editRow>="0"){
		$("#nodeloclinklist").datagrid('endEdit', editRow);
	}
	var rowsData = $("#nodeloclinklist").datagrid('getChanges');
	console.log(rowsData);
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if(rowsData[i].nlcode==""){ 
			$.messager.alert("提示","请编辑必填数据!"); 
			return false;
		}
		var tmp=rowsData[i].nllid +"^"+ rowsData[i].nlllocid +"^"+ rowsData[i].parentid;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//保存数据
	runClassMethod("web.DHCDISNodeLoc","SaveNodeLocLink",{"params":params},function(jsonString){
		if(jsonString==0){
			$.messager.alert("提示","保存成功!"); 
			$('#nodeloclinklist').datagrid('reload'); //重新加载
		}else if(jsonString==-96){
			$.messager.alert("提示","代码重复!"); 
			$('#nodeloclinklist').datagrid('reload'); //重新加载
		}else{
			$.messager.alert("提示","保存失败!"); 
			$('#nodeloclinklist').datagrid('reload'); //重新加载
		}
	});
}
function NLdeleteRow(){
	var rowsData = $("#nodeloclist").datagrid('getSelected');
	if (rowsData != null) {
		$.messager.confirm("提示", "关联科室也将删除.您确定要删除吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCDISNodeLoc","DelNodeLoc",{"params":rowsData.nlid},function(jsonString){
					if(jsonString==0){
						$.messager.alert('提示','删除成功！','warning');
					}
					else{
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#nodeloclist').datagrid('reload'); //重新加载
					$('#nodeloclinklist').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}

}
function NLLdeleteRow(){
	var rowsData = $("#nodeloclinklist").datagrid('getSelected');
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCDISNodeLoc","DelLocLink",{"params":rowsData.nllid},function(jsonString){
					if(jsonString==0){
						$.messager.alert('提示','删除成功！','warning');
					}
					else{
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#nodeloclinklist').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

function findNodeLoc()
{
	var code=$('#NLcode').val();
	var desc=$('#NLdesc').val();
	var params=code+"^"+desc;
	$('#nodeloclist').datagrid('load',{params:params}); 
}
