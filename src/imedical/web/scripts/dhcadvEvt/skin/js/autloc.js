/// Creator: congyue
/// CreateDate: 2018-01-15
//  Descript: 科室1科室2 维护界面

var editRow=""; editmuliRow=""; //当前编辑行号
var url="dhcadv.repaction.csp";
var Active = [{"value":"Y","text":'Y'}, {"value":"N","text":'N'}];
var AutLocID = "";
$(function(){	
	//是否可用标志
	var activeEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:Active,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#autlocdg").datagrid('getEditor',{index:editRow,field:'Active'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	// 定义columns
	var columns=[[  
		{field:"Code",title:'代码',width:150,editor:texteditor},
		{field:'Desc',title:'描述',width:150,editor:texteditor},
		{field:'Parent',title:'父级',width:150,editor:editor},
		{field:'Active',title:'是否可用',width:150,editor:activeEditor},
		{field:"ID",title:'ID',width:70,align:'center'}
	]];
	
	// 定义datagrid
	$('#autlocdg').datagrid({
		title:'科室1',
		url:'dhcapp.broker.csp?ClassName=web.DHCADVAUTLOC&MethodName=QueryAutLoc&params='+"",
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((editRow != "")||(editRow == "0")) {
            	$("#autlocdg").datagrid('endEdit', editRow); 
			}
            $("#autlocdg").datagrid('beginEdit', rowIndex);
            
            var edc = $("#autlocdg").datagrid('getEditor', {index:rowIndex, field:'Code'});
		 	
            editRow = rowIndex; 
        },
        onClickRow:function(rowIndex, rowData){
	    	AutLocID=rowData.ID;    ///工作流ID
 			var params=AutLocID;
				$('#autlocitmdg').datagrid({
					url:'dhcapp.broker.csp?ClassName=web.DHCADVAUTLOC&MethodName=QueryAutLocItm&AutLParentID='+params
				});
 			
        } 
	});
	
	//initScroll("#autlocdg");//初始化显示横向滚动条
 
 	//按钮绑定事件
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
     //同时给代码和描述绑定回车事件
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findMedUseLink(); //调用查询
        }
    });
    
   
    // 查找按钮绑定单击事件
    $('#find').bind('click',function(event){
         findMedUseLink(); //调用查询
    });
    
   /*  $('#autlocdg').datagrid({
		url:url+'?action=QueryMedUseLink',	
		queryParams:{
			params:''}
	}); */
	InitAutLocItmParam();
	
	//给datagrid一个空数据      
	$('#autlocitmdg').datagrid({		//乔庆澳  2016/7/13
		url:url+'?action=JoeClearPage',	
		queryParams:{
			params:''}
	});
	
	
})  //这里是functions结束


// 插入新行
function insertRow()
{	
	if(editRow>="0"){
		$("#autlocdg").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	$("#autlocdg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		
		index: 0, // 行数从0开始计算
		
		row: {ID: '',Code:'',Desc: '',Parent:'',Active:'Y'}
	});
	
	$("#autlocdg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	var ed = $("#autlocdg").datagrid('getEditor', {index:0, field:'Code'});
	editRow=0;
}

// 删除选中行
function deleteRow()
{
	var rows = $("#autlocdg").datagrid('getSelections'); //选中要删除的行
	if (!rows.length>0){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	if (rows.length>1){
		$.messager.alert("提示:","请选中一行数据,重试！");
		return;
	}
	$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
		if (res) {
			runClassMethod("web.DHCADVAUTLOC","DelAutLoc",{'AutLID':rows[0].ID},function(data){ 
	 			if(data==0){
					$.messager.alert('提示','删除成功');	
				}else if(data==-1){
					$.messager.alert('提示','此数据存有关系信息，不可删除');	
				}else{
					$.messager.alert('提示','删除失败');
				}
				$('#autlocdg').datagrid('reload'); //重新加载
				$('#autlocitmdg').datagrid('reload'); //重新加载 
	 		})
		}
	});
}
// 保存编辑行
function saveRow()
{
	if(editRow>="0"){
		$("#autlocdg").datagrid('endEdit', editRow);
	}

	var rows = $("#autlocdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			return false;
		}
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc+"^"+rows[i].Parent+"^"+rows[i].Active;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&");

	//保存数据
	runClassMethod("web.DHCADVAUTLOC","SaveAutLocList",{'DataList':rowstr},function(data){ 
		
		if(data==0){
			$.messager.alert('提示','操作成功');
		}else if ((data == -1)||((data == -2))){
			$.messager.alert('提示','代码重复,请核实后再试','warning');
			//return;	//2017-03-17 保存失败，刷新字典表
		}else {
			$.messager.alert('提示','操作失败','warning');
			//return;	//2017-03-17 保存失败，刷新字典表
		}
		$('#autlocdg').datagrid('reload'); //重新加载
		
	});
}

// 编辑格
var texteditor={
	type: 'validatebox',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}
// 编辑格
var editor={
	type: 'validatebox'//设置编辑格式

}


// 查询
function findMedUseLink()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#autlocdg').datagrid('load',{params:params}); 
}
/// =====================================用药环节项目设置=============================
function InitAutLocItmParam()
{
		//是否可用标志
	var activeEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:Active,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				
				var ed=$("#autlocitmdg").datagrid('getEditor',{index:editmuliRow,field:'Active'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}

	// 定义columns
	var columns=[[
		{field:'Code',title:'代码',width:150,editor:texteditor},
		{field:"Desc",title:'描述',width:150,editor:texteditor},
		{field:'Parent',title:'父级',width:150,editor:texteditor},
		{field:'Active',title:'是否可用',width:100,editor:activeEditor},
		{field:"ID",title:'ID',width:90,align:'center',hidden:true}
	]];
	
	// 定义datagrid
	$('#autlocitmdg').datagrid({
		title:'科室2',
		url:'dhcapp.broker.csp?ClassName=web.DHCADVAUTLOC&MethodName=QueryAutLocItm&AutLParentID='+"",
		fit:true,
		rownumbers:true,
		columns:columns,
		order:'asc',
		pageSize:40,        // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
			if ((editmuliRow != "")||(editmuliRow == "0")) {
            	 $("#autlocitmdg").datagrid('endEdit', editmuliRow); 
			}            
            $("#autlocitmdg").datagrid('beginEdit', rowIndex); 
            editmuliRow = rowIndex; 
        }
       
	});
	
	//initScroll("#autlocitmdg");//初始化显示横向滚动条
	
	//按钮绑定事件
    $('#insali').bind('click',insaliRow); 
    $('#delali').bind('click',delaliRow);
    $('#savali').bind('click',savaliRow);
	

}
// 插入新行
function insaliRow()
{

	if( editmuliRow>="0"){
		$("#autlocitmdg").datagrid('endEdit',  editmuliRow);//结束编辑，传入之前编辑的行
	}
	$("#autlocitmdg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',Code:'',Desc: '',Parent:AutLocID,Active: 'Y'}
	});
	$("#autlocitmdg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	 editmuliRow=0;
}

// 删除选中行
function delaliRow()
{
	var rows = $("#autlocitmdg").datagrid('getSelections'); //选中要删除的行
	if (!rows.length>0){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	if (rows.length>1){
		$.messager.alert("提示:","请选中一行数据,重试！");
		return;
	}
	$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
		if (res) {
			runClassMethod("web.DHCADVAUTLOC","DelAutLoc",{'AutLID':rows[0].ID},function(data){ 
				if(data==0){
					$.messager.alert('提示','删除成功');	
				}else if(data==-1){
					$.messager.alert('提示','此数据存在使用信息，不可删除');	
				}else{
					$.messager.alert('提示','删除失败');
				}
				$('#autlocitmdg').datagrid('reload'); //重新加载
			});
		}
	});
}

// 保存编辑行
function savaliRow()
{
	if( editmuliRow>="0"){
		$("#autlocitmdg").datagrid('endEdit',  editmuliRow);
	}
	var rows = $("#autlocitmdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if(AutLocID==""){
			$.messager.alert("提示","请选择一条用药环节数据!"); 
			return false;
		}
		if((rows[i].Code=="")||(rows[i].Desc=="")||(rows[i].Active=="")){
			$.messager.alert("提示","有必填项未填写，请核实!"); 
			return false;
		}
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc+"^"+rows[i].Parent+"^"+rows[i].Active;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&")
	
	//保存数据
	runClassMethod("web.DHCADVAUTLOC","SaveAutLocList",{'DataList':rowstr},function(data){ 
		if(data==0){
			$.messager.alert('提示','操作成功');
		}else if ((data == -1)||((data == -2))){
			$.messager.alert('提示','代码重复,请核实后再试','warning');
			//return;	//2017-03-17 保存失败，刷新字典表
		}else {
			$.messager.alert('提示','操作失败','warning');
			//return;	//2017-03-17 保存失败，刷新字典表
		}
		$('#autlocitmdg').datagrid('reload'); //重新加载
		
	});
	
}

