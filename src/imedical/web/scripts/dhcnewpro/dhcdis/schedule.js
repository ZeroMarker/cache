/** sufan 
  * 2018-04-09
  *
  * 配送排班明细维护
 */
var editRow = ""; 
/// 页面初始化函数
function initPageDefault(){

	iniSchItmlist();	 	///	初始页面DataGrid排班明细表
	initButton();           /// 页面Button绑定事件	
}
/// 初始化排班明细列表
function iniSchItmlist()
{
	var Scheditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "id", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCDISScheduleType&MethodName=GetSchedule",
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#scheitmlist").datagrid('getEditor',{index:editRow,field:'SchDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#scheitmlist").datagrid('getEditor',{index:editRow,field:'SchDr'});
				$(ed.target).val(option.id); 
			} 
		}
	}
	var Typeeditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "id", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetDisTypeCombobox",
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#scheitmlist").datagrid('getEditor',{index:editRow,field:'TypeDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#scheitmlist").datagrid('getEditor',{index:editRow,field:'TypeDr'});
				$(ed.target).val(option.id); 
			} 
		}
	}
	var Nodeeditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "id", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCDISScheduleType&MethodName=QueryNode",
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#scheitmlist").datagrid('getEditor',{index:editRow,field:'NodeDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#scheitmlist").datagrid('getEditor',{index:editRow,field:'NodeDr'});
				$(ed.target).val(option.id); 
			} 
		}
	}
	var Usereditor={  //设置其为可编辑
		//类别
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "id", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCDISScheduleType&MethodName=GetDisUser",
			//required:true,
			panelHeight:200,  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#scheitmlist").datagrid('getEditor',{index:editRow,field:'UserDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#scheitmlist").datagrid('getEditor',{index:editRow,field:'UserDr'});
				$(ed.target).val(option.id); 
			} 
		}
	}
	/// 文本编辑格
	var textEditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}

	// 定义columns
	var columns=[[
		{field:"SchDr",title:'SchDr',width:50,hidden:true,editor:textEditor},
		{field:"SchDesc",title:'班次',width:160,align:'center',editor:Scheditor},
		{field:"TypeDr",title:'TypeDr',width:50,hidden:true,editor:textEditor},
		{field:"TypeDesc",title:'任务类型',width:180,align:'center',editor:Typeeditor},
		{field:"NodeDr",title:'NodeDr',width:50,hidden:true,editor:textEditor},
		{field:"NodeDesc",title:'工作岗位',width:180,align:'center',editor:Nodeeditor},
		{field:"UserDr",title:'UserDr',width:50,hidden:true,editor:textEditor},
		{field:"UserDesc",title:'工作人员',width:180,hidden:true,align:'center',editor:Usereditor},
		{field:"SchtItmId",title:'SchtItmId',width:50,hidden:true,editor:textEditor}
	]];
	///  定义datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((editRow != "")||(editRow == "0")) { 
                $("#scheitmlist").datagrid('endEdit', editRow); 
            } 
            $("#scheitmlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	var uniturl =LINK_CSP+"?ClassName=web.DHCDISScheduleType&MethodName=QuerySchItm";
	new ListComponent('scheitmlist', columns, uniturl, option).Init();
}
/// 页面 Button 绑定事件
function initButton(){
	
	///  增加排班明细
	$('#subinsert').bind("click",insItmRow);
	
	///  保存排班明细
	$('#subsave').bind("click",saveItmRow);
	
	///  删除排班明细
	$('#subdelete').bind("click",delItmRow);

}

/// 插入排班明细
function insItmRow()
{

	if(editRow>="0"){
		$("#scheitmlist").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	 
	$("#scheitmlist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {SchDr:'',SchDesc:'',TypeDr: '',TypeDesc:'',NodeDr: '',NodeDesc:'',UserDr:'',UserDesc:'',SchtItmId:''}
	});
    
	$("#scheitmlist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

///保存排班明细
function saveItmRow()
{
	if(editRow>="0"){
		$("#scheitmlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#scheitmlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if((rowsData[i].SchDesc=="")||(rowsData[i].SchDr=="")){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行排班类型为空！"); 
			return false;
		}
		if((rowsData[i].TypeDesc=="")||(rowsData[i].TypeDr=="")){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行任务类为空！"); 
			return false;
		}
		if((rowsData[i].NodeDesc=="")||(rowsData[i].NodeDr=="")){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行工作岗位为空！"); 
			return false;
		}
		/*if((rowsData[i].UserDesc=="")||(rowsData[i].UserDr=="")){
			$.messager.alert("提示","第"+(rowsData.length-i)+"行工作人员为空！"); 
			return false;
		}*/
		var tmp=rowsData[i].SchtItmId +"^"+ rowsData[i].SchDr +"^"+ rowsData[i].TypeDr +"^"+ rowsData[i].NodeDr +"^"+ rowsData[i].UserDr;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//alert(params)
	//保存数据
	runClassMethod("web.DHCDISScheduleType","SaveSchItm",{"params":params},function(jsonString){
		
		if (jsonString == "0"){
			$('#scheitmlist').datagrid('reload'); //重新加载
		}
		
	});
}
/// 删除
function delItmRow(){
	
	var rowsData = $("#scheitmlist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCDISScheduleType","DelSchItm",{"SchtItmId":rowsData.SchtItmId},function(jsonString){
					$('#scheitmlist').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}


/// JQuery 初始化页面
$(function(){ initPageDefault(); })
