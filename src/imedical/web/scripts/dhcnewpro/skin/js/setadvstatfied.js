//qqa
//2017-12-14
;$(function(){

	initParams();
	
	initCombobx();
	
	initDatagrid();
	
	initBindMethod();
})

function initParams(){
	
	formNameID = "";
	
	editRow="";	
	
	///全局变量：动态更改编辑器
	formDicIDEditor={  
		type: 'combobox',
		options: {
			data:[],       //## 这个位置获取控件类型为时间的控件
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			required:true,
			editable:false, //huaxiaoying 2017-01-06
			onSelect:function(rowData){
				
			}
			
		}
	}
	
	
	formUomEditor={  
		type: 'combobox',
		options: {
			data:[
				{"value":"1","text":"日"},
				{"value":"2","text":"月"},
				{"value":"3","text":"年"}
			],       //## 这个位置获取控件类型为时间的控件
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //设置容器高度自动增长
			required:true,
			editable:false, //huaxiaoying 2017-01-06
			onSelect:function(rowData){
				///设置级联
				var ed=$("#setFielValTable").datagrid('getEditor',{index:editRow,field:'FieldUomID'});   //##   enabled未字段名字
				$(ed.target).val(rowData.value);
			}
			
		}
	}
	
	inputEditor={type:'validatebox',options:{required:true}};
}

function initBindMethod(){
 	$('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);	
    $("a:contains('添加元素')").bind('click',addItm);
    $("a:contains('删除元素')").bind('click',delItm);
    $("a:contains('全部选中')").bind('click',selAllItm);
    $("a:contains('取消选中')").bind('click',unSelAllItm);
    $("a:contains('全部删除')").bind('click',delAllItm);
}

///添加元素
function addItm(){
	var datas = $("#allItmTable").datagrid("getSelections");
	if(!datas.length){
		$.messager.alert("提示","未选中左侧数据！");
		return;	    
	}
	
	var dataArray=[],param="";
	for(x in datas){ 
		param = datas[x].FormDicID+"^"+ datas[x].ValDr;
		dataArray.push(param);
	}
	
	var params = dataArray.join("&&");
	runClassMethod("web.DHCADVSetAdvStatFied","InsStatField",{"FormNameID":formNameID,"Params":params},
	function(ret){
		if(ret=="0"){
			$.messager.alert("提示","爷,新增成功！");
			reloadTopTable();
		}
	},'text');
}
function delItm(){
	var datas = $("#setItmTable").datagrid("getSelections");
	if(!datas.length){
		$.messager.alert("提示","未选中右侧数据！");
		return;	    
	}
	
	var dataArray=[],param="";
	for(x in datas){ 
		param = datas[x].STFId;
		dataArray.push(param);
	}
	
	var params = dataArray.join("&&");
	runClassMethod("web.DHCADVSetAdvStatFied","DelStatField",{"Params":params},
	function(ret){
		if(ret=="0"){
			$.messager.alert("提示","爷,删除成功！");
			reloadTopTable();
		}
	},'text');
}

function delAllItm(){
	$("#setItmTable").datagrid("checkAll");
	delItm();
}

function selAllItm(){
	$("#allItmTable").datagrid("checkAll");
}

function unSelAllItm(){
	$("#allItmTable").datagrid("uncheckAll");
		
}
// 插入新行
function insertRow()
{

	if(!formNameID){
		$.messager.alert("提示","请选择报告类型！");
		return ;	
	}
	
	if(editRow>="0"){
		$("#setFielValTable").datagrid('endEdit', editRow);//结束编辑，传入之前编辑的行
	}
	 
	$("#setFielValTable").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		index: 0, // 行数从0开始计算
		row: {STFVId:'',FormNameDr:formNameID,FormDicDr:'',FeildDesc: '',FieldVal:'',FieldUom:1,FieldUomID:1} //huaxiaoying 2017-01-06
	});         
            
	$("#setFielValTable").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
	editRow=0;
}

// 删除选中行
function deleteRow()
{
	var rowsData = $("#setFielValTable").datagrid('getSelected'); //选中要删除的行
	
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这条数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCADVSetAdvStatFied","Delete",{"STFVId":rowsData.STFVId},function(ret){
					if(ret==0){
						$.messager.alert("提示","删除成功！");
						$('#setFielValTable').datagrid('reload'); //重新加载
					}
				},'text')
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
		$("#setFielValTable").datagrid('endEdit', editRow);
	}

	var rowsData = $("#setFielValTable").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if((rowsData[i].FormNameDr=="")||(rowsData[i].FormDicDr=="")||(rowsData[i].FeildDesc=="")||(rowsData[i].FieldVal=="")||(rowsData[i].FieldUomID=="")){ //huaxiaoying 2017-01-06
			$.messager.alert("提示","请编辑必填数据!"); 
			return false;
		}
		var tmp=rowsData[i].STFVId+"^"+rowsData[i].FormNameDr +"^"+ rowsData[i].FormDicDr +"^"+ rowsData[i].FeildDesc +"^"+ rowsData[i].FieldVal+"^"+rowsData[i].FieldUomID;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");

	//保存数据  ##
	runClassMethod("web.DHCADVSetAdvStatFied","Save",{"Params":params},
	function(ret){
		if(ret==0){
			$.messager.alert("提示","修改成功！");
			reloadSetFielValTable(formNameID);	
		}
	},'text');
}

function initCombobx(){
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=";
	var option = {
		panelHeight:"auto",
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			formNameID = option.value;
			reloadAllItmTable(option.value);
			reloadSetFielValTable(option.value);
			reloadSetFielTable(option.value);
			updateFormDicIDEditor();
	    }
	};
	
	var url = uniturl+"JsonGetRepotType";
	new ListCombobox("reportType",url,'',option).init();	
}


function initDatagrid(){
	
	var columns=[[
		{field:'PatLabel',title:'',width:210,formatter:setCellLabel}
	]];
	

	$("#allItmTable").datagrid({
		url:LINK_CSP+"?ClassName=web.DHCADVSetAdvStatFied&MethodName=JsonListGetAllItmByFormID",
		queryParams:{
			ForNameID:""
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		loadMsg: '正在加载信息...',
		showHeader:false,
		rownumbers : false,
		pagination:false,
		onSelect:function (rowIndex, rowData){
			
		}
	});	
	
	
	var columns=[[
		{field:'PatLabel',title:'',width:210,formatter:setCellLabel}
	]];
	

	$("#setItmTable").datagrid({
		url:LINK_CSP+"?ClassName=web.DHCADVSetAdvStatFied&MethodName=JsonListGetSetFiel",
		queryParams:{
			ForNameID:""
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		loadMsg: '正在加载信息...',
		showHeader:false,
		rownumbers : false,
		pagination:false,
		onSelect:function (rowIndex, rowData){
			
		}
	});	
	
	//初始化最下方表格
	initFieldValTable();
	
	
	
}

//为了动态
function initFieldValTable(){
	// 定义columns
	var columns=[[
		{field:"STFVId",title:'自定义元素ID',width:100,hidden:true,align:'center'}, 
		{field:"FormNameDr",title:'统计表单',width:100,hidden:true,align:'center',editor:inputEditor}, 
		{field:"FormDicDesc",title:'元素描述',width:130,align:'center',editor:inputEditor,editor:formDicIDEditor},
		{field:"FormDicDr",title:'元素ID',width:130,hidden:true,align:'center',editor:inputEditor},
		{field:"FeildDesc",title:'描述',width:150,align:'center',editor:inputEditor},
		{field:'FieldVal',title:'统计时长',width:130,align:'center',editor:inputEditor},
		{field:'FieldUom',title:'统计单位',width:130,align:'center',editor:formUomEditor},
		{field:'FieldUomID',title:'统计单位ID',width:130,align:'center',hidden:true,editor:inputEditor},
	]];
	
	
	// 定义datagrid
	$('#setFielValTable').datagrid({
		title:'',
		url:LINK_CSP+"?ClassName=web.DHCADVSetAdvStatFied&MethodName=JsonListGetSetFielVal", //huaxiaoying 2017-1-4 规范名字
		queryParams:{
			ForNameID:formNameID
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:10,  // 每页显示的记录条数
		pageList:[30,60],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != "") { 
                $("#setFielValTable").datagrid('endEdit', editRow); 
            } 
            $("#setFielValTable").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	});
}

//reload 左上表
function reloadAllItmTable(value){
	
	$("#allItmTable").datagrid('load',{
		ForNameID:value
	})
}

function reloadSetFielValTable(value){
	$("#setFielValTable").datagrid('load',{
		ForNameID:value
	})
}

function reloadSetFielTable(value){
	$("#setItmTable").datagrid('load',{
		ForNameID:value
	})
}

///病人检验医嘱加载
function setCellLabel(value, rowData, rowIndex){
	var retHtml=rowData.DicDesc;
	return retHtml;
}

///刷新 field和fieldVal
function reloadTopTable(){
	reloadSetFielTable(formNameID);
	reloadAllItmTable(formNameID);
}

function updateFormDicIDEditor(){
	
	runClassMethod("web.DHCADVSetAdvStatFied","GetStatFiedValComboBox",{"FormNameID":formNameID},
	function(jsonData){
		console.log(jsonData);
		formDicIDEditor={  
			type: 'combobox',
			options: {
				//url:LINK_CSP+"?ClassName=web.DHCADVSetAdvStatFied&MethodName=GetStatFiedValComboBox&FormNameID="+FormNameID,       //## 这个位置获取控件类型为时间的控件
				data:jsonData,
				valueField: "value", 
				textField: "text",
				editable:false, //huaxiaoying 2017-01-06
				onSelect:function(rowData){
					///设置级联
					var ed=$("#setFielValTable").datagrid('getEditor',{index:editRow,field:'FormDicDr'});   //##   enabled未字段名字
					//$(ed.target).combobox('setValue', option.text);  //设置是否可用
					$(ed.target).val(rowData.value);
				} 
			}
		}
		
	},'json',false);
	
	
	initFieldValTable();	
}