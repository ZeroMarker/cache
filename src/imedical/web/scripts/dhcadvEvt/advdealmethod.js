var editRow="";editparamRow="";  //当前编辑行号
var url="dhcadv.repaction.csp";
//var titleNotes='<span style="font-weight:bold;font-size:12pt;font-family:华文楷体;color:red;">[双击行即可编辑]</span>';
//var titleNotes2='<span style="font-weight:bold;font-size:12pt;font-family:华文楷体;color:red;"></span>';
var Active = [{"value":"Y","text":'是'}, {"value":"N","text":'否'}];
$(function(){
   
	//是否可用标志
	var activeEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:Active,
			valueField: "value", 
			textField: "text",
			//required:true,
			panelHeight:"auto"
		}
	}
	//医院 //hxy 2019-07-02
	var hospEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
			valueField: "value", 
			textField: "text",
			//required:true,
			//editable:false, //hxy 2019-07-04 可清空的话，清空后提示不准确
			//panelHeight:"auto" //设置容器高度自动增长
			onSelect:function(option){
				var Hosped=$("#advdeal").datagrid('getEditor',{index:editRow,field:'Hosp'});
				$(Hosped.target).val(option.text);  //设置医院
				var HospIDed=$("#advdeal").datagrid('getEditor',{index:editRow,field:'HospID'});
				$(HospIDed.target).val(option.value);  //设置医院ID
			}
		}
	}
	// 定义columns
	var columns=[[
		{field:"ID",title:'ID',width:70,align:'center'},
		{field:"Code",title:'代码',width:120,editor:texteditor},
		{field:'Desc',title:'描述',width:200,editor:texteditor},
		{field:'Active',title:'是否可用',width:80,formatter:formatLink,editor:activeEditor},
		{field:'Hosp',title:'医院',width:200,editor:hospEditor}, //hxy 2019-07-02
		{field:'HospID',title:'医院ID',width:80,editor:'text',hidden:true} //hxy 2019-07-02
	]];
	
// 定义datagrid
	$('#advdeal').datagrid({
		title:'',//不良事件处理方法
		url:'',
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
                $("#advdeal").datagrid('endEdit', editRow); 
            } 
            $("#advdeal").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
       
	});
	
    initScroll("#advdeal");//初始化显示横向滚动条
 
 	//按钮绑定事件
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    $('#find').bind("click",Query);  //点击查询	

    $('#advdeal').datagrid({
		url:url+'?action=QueryAdvDeal',
		queryParams:{
			params:''}
	});
	
	$('#hospDrID').combobox({ //hxy 2019-07-20 st
	 	url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto'
	}) //ed
	
})

//查询
function Query()
{
	var admeCode=$('#code').val();
	var admeDesc=$('#desc').val();                 
	var hospDrID=$('#hospDrID').combobox('getValue');  //hxy 2019-07-20  
	if(hospDrID==undefined){hospDrID=""}               
	var params=admeCode+"^"+admeDesc+"^"+hospDrID;
	//alert(params)
    $('#advdeal').datagrid('load',{params:params}); 	

}


 // 插入新行
function insertRow()
{
	if(editRow>="0"){
		$("#advdeal").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	
	var rows = $("#advdeal").datagrid('getChanges')
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			return false;
		}
	} 
	
	$("#advdeal").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',Code:'',Desc:'',Active:'Y',Hosp:LgHospID,HospID:LgHospID} //hxy 2019-07-01 LgHospID

	});
	$("#advdeal").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

// 删除选中行
function deleteRow()
{
	var rows = $("#advdeal").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=DelAdvDeal',{"params":rows[0].ID}, function(data){
                    if(data==0){
						$.messager.alert('提示','删除成功');	
					}else if(data==-1){
						$.messager.alert('提示','此数据存在使用信息，不可删除');	
					}else{
						$.messager.alert('提示','删除失败');
					}

					$('#advdeal').datagrid('reload'); //重新加载
					
				});
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
} 


// 保存编辑行
function saveRow()
{
	if(editRow>="0"){
		$("#advdeal").datagrid('endEdit', editRow);
	}

	var rows = $("#advdeal").datagrid('getChanges')
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
		if((rows[i].Hosp=="")||(rows[i].HospID=="")){
			$.messager.alert("提示","医院信息不能为空!"); 
			return false;
		}

		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc+"^"+rows[i].Active+"^"+rows[i].Hosp+"^"+rows[i].HospID; //hxy 2019-07-02
		dataList.push(tmp);
	} 
	var params=dataList.join("||");

	//保存数据
	$.post(url+'?action=SaveAdvDeal',{"params":params},function(data){
		if ((data == -1)||((data == -2))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			//return;	//2017-03-17 保存失败，刷新字典表
		}
		$('#advdeal').datagrid('reload'); //重新加载

		
	});
}

// 编辑格
var texteditor={
	type: 'validatebox',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}
//YN转换是否
function formatLink(value,row,index){
	if (value=='Y'){
		return '是';
	} else {
		return '否';
	}
}
