/// Creator: congyue
/// CreateDate: 2016-03-24
//  Descript: 医疗不良事件报告分类

var editRow=""; //当前编辑行号
var url="dhcadv.repaction.csp";
var Active = [{"value":"Y","text":'是'}, {"value":"N","text":'否'}];
var Levelrowid="";
var level=0,parentid="";
$(function(){
	var params="";
 	$('#tree').tree({
	 	type: 'get',
		url: url+"?action=QueryMrcInfo&params"+params,
		loadFilter: function(MrcInfo){
				var data=eval(MrcInfo);
				var json=GetJson(data,Levelrowid);
				return json;
		},
	 	onClick: function(node){
			level=node.Level;
			level++;
			parentid=node.ID;
			ChildrenInfo(parentid);
			/* $('#mrcdg').datagrid({
				url:url+'?action=QueryMedRepCat',	
				queryParams:{
					params:parentid
				}
			
			});	 */
		},
		onLoadSuccess:function(node){
			
				var node=$('#tree').tree('getRoot');
				parentid=node.ID;
				level=node.Level;
				level++;
				$('#tree').tree('select', node.target);
			
			ChildrenInfo(parentid);
			/* $('#mrcdg').datagrid({
				url:url+'?action=QueryMedRepCat',	
				queryParams:{
					params:parentid
				}
			
			}); */
			}
	 
 	});
	
InitMedRepCat();
});

function GetJson(data,Levelrowid){
    var result = [] , temp;//声明temp中间变量
    for(var i in data){
        if(data[i].Levelrowid==Levelrowid){
            result.push(data[i]);
            temp = GetJson(data,data[i].ID); // 定义temp          
            if(temp.length>0){
                data[i].children=temp; //给data[i]添加children属性并赋值
            }           
        }       
    }
    return result;
}

function ChildrenInfo()
{
	$('#mrcdg').datagrid({
				url:url+'?action=QueryMedRepCat',	
				queryParams:{
					params:parentid
				}
			
			});
}



// 编辑格
var texteditor={
	type: 'validatebox',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}

function InitMedRepCat()
{
		
	//是否可用标志
	var activeEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:Active,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto"  //设置容器高度自动增长
			
		}
	}

	// 定义columns
	var columns=[[
		{field:'Code',title:'代码',width:150,editor:texteditor},
		{field:"Desc",title:'描述',width:150,editor:texteditor},
		{field:'Level',title:'级别',width:50,hidden:false},
		{field:"Levelrowid",title:'上一级别的rowid',width:100,hidden:false},
		{field:'Active',title:'是否可用',width:60,formatter:formatLink,editor:activeEditor},
		{field:"ID",title:'ID',width:50,align:'center',hidden:false}
	]];
	
	// 定义datagrid
	$('#mrcdg').datagrid({
		title:'医疗不良事件报告分类',
		url:'',
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
			if ((editRow != "")||(editRow == "0")) {
            	 $("#mrcdg").datagrid('endEdit', editRow); 
			}            
            $("#mrcdg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
       
	});
	$('#mrcdg').datagrid({
		url:url+'?action=QueryMedRepCat',	
		queryParams:{
			params:Levelrowid}
			
	});	
	
initScroll("#mrcdg");//初始化显示横向滚动条
	
	//按钮绑定事件
    $('#insmrc').bind('click',insmrcRow); 
    $('#delmrc').bind('click',delmrcRow);
    $('#savmrc').bind('click',savmrcRow);
	

}
// 插入新行
function insmrcRow()
{
	if( editRow>="0"){
		$("#mrcdg").datagrid('endEdit',  editRow);//结束编辑，传入之前编辑的行
	}
	
	var rows = $("#mrcdg").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			return false;
		}
	} 
	
	$("#mrcdg").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {ID: '',Code:'',Desc: '',Level:level,Levelrowid: parentid,Active: 'Y'}
	});
	$("#mrcdg").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	 editRow=0;
}

// 删除选中行
function delmrcRow()
{
	var rows = $("#mrcdg").datagrid('getSelections'); //选中要删除的行
	if (rows.length > 0) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				$.post(url+'?action=DelMedRepCat',{"params":rows[0].ID}, function(data){
                    if(data==0){
						$.messager.alert('提示','删除成功');	
					}else if((data == -1)||(data == -2)){
						$.messager.alert('提示','此数据存在使用信息，不可删除');	
					}else{
						$.messager.alert('提示','删除失败');
					}


					$('#mrcdg').datagrid('reload'); //重新加载
					$('#tree').tree('reload'); //重新加载
				});
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

// 保存编辑行
function savmrcRow()
{
	if( editRow>="0"){
		$("#mrcdg").datagrid('endEdit',  editRow);
	}
	var rows = $("#mrcdg").datagrid('getChanges');
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
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc+"^"+rows[i].Level+"^"+rows[i].Levelrowid+"^"+rows[i].Active;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&");
	//保存数据
	$.post(url+'?action=SaveMedRepCat',{"params":rowstr},function(data){
		if(data==0){
			$.messager.alert('提示','操作成功');
		}else if ((data == -1)||((data == -2))){
			$.messager.alert('提示','代码重复,请核实后再试','warning');
			//return;	//2017-03-17 保存失败，刷新字典表
		}else {
			$.messager.alert('提示','操作失败','warning');
			//return;	//2017-03-17 保存失败，刷新字典表
		}
		$('#mrcdg').datagrid('reload'); //重新加载
		$('#tree').tree('reload'); //重新加载
	});
}
 
//YN转换是否
function formatLink(value,row,index){
	if (value=='Y'){
		return '是';
	} else {
		return '否';
	}
}
