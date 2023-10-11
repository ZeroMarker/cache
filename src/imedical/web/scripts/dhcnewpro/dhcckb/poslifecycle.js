var AddAttrCode="JobData";
var LifeCycleData="LifeCycleData";
var IP=ClientIPAdd
var editRow=0,editsubRow=0;editsubRow2=0;editsubRow3=0;
var ActiveArray = [{"value":"是","text":'是'}, {"value":"否","text":'否'}];
/// 页面初始化函数
function initPageDefault(){
	//InitButton();		// 按钮响应事件初始化
	InitDataList();		// 页面DataGrid初始化定义
	InitButton();
	InitDataJurisdiction();
	InitDatalife();
}
	

/// 页面DataGrid初始定义通用名（岗位字典名称）
function InitDataList(){
						
	// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: false //设置编辑规则属性
		}
	}
	
	/*// 职务
	var Roleeditor={type:'combobox',
				  	 options:{
						valueField:'value',
						textField:'text',
						mode:'remote',
						enterNullValueClear:false,
						blurValidValue:true,
						onSelect:function(option) {
							var ed=$("#diclist").datagrid('getEditor',{index:editsubRow,field:'post'});
							$(ed.target).combobox('setValue', option.text);
							var ed=$("#diclist").datagrid('getEditor',{index:editsubRow,field:'postID'});
							$(ed.target).val(option.value);
						},
				  		onShowPanel:function(){
							var ed=$("#diclist").datagrid('getEditor',{index:editsubRow,field:'post'}) ;
							var unitUrl=$URL+"?ClassName=web.DHCCKBPosLifeCycle&MethodName=QueryValue&AddAttrCode="+AddAttrCode;
							$(ed.target).combobox('reload',unitUrl) ;
				    	}	  
					}
	}*/
	
	// 定义columns
	var columns=[[   
			{field:'ID',title:'ID',width:80,hidden:true},
			{field:'postID',title:'岗位ID',width:80,editor:texteditor,hidden:true},
			{field:'encoded',title:'编码',width:80,hidden:false,editor:texteditor},
			{field:'post',title:'岗位',width:80,hidden:false,editor:texteditor},
		 ]]
	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){ 	
            InitDatalife()
		}, 
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
      		if (editsubRow != ""||editsubRow == 0) { 
                $("#diclist").datagrid('endEdit', editsubRow); 
            } 
            $("#diclist").datagrid('beginEdit', rowIndex); 
            editsubRow = rowIndex;
        },
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBPosLifeCycle&MethodName=Queryposlifecycle&AddAttrCode="+AddAttrCode;
	new ListComponent('diclist', columns, uniturl, option).Init();
	
}

///初始化类别列表
function InitDataJurisdiction(){
	// 定义columns
	var columns=[[  
			{field:'code',title:'类别代码',width:80,hidden:true},
			{field:'type',title:'类别',width:80,hidden:false}
		 ]]
	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		toolbar:[],
		pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){ 
		  if (editsubRow2 != ""||editsubRow2 == 0) { 
                $("#predictList").datagrid('endEdit', editsubRow2); 
            } 
            $("#predictList").datagrid('beginEdit', rowIndex); 
            
            editsubRow2 = rowIndex;
            InitDatalife(); 
		}, 
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
          
        },
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBPosLifeCycle&MethodName=Querylist";
	new ListComponent('predictList', columns, uniturl, option).Init();
	
	
	
	}

///初始化生命周期列表
function InitDatalife(){
	
	// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	// 是否授权
	var Roleeditornew={type:'combobox',
	  	 options:{
		  	data:ActiveArray,
			valueField:'value',
			textField:'text',
			mode:'remote',
			enterNullValueClear:false,
			blurValidValue:true,
			onSelect:function(option) {
				var ed=$("#tabooListnew").datagrid('getEditor',{index:editsubRow3,field:'authorization'});
				$(ed.target).combobox('setValue', option.value);  //设置Desc
			},
	  		onShowPanel:function(){
				
	    	}	  
		}
	}
		
// 定义columns
	var columns=[[ 
			{field:'id',title:'rowid',hidden:true},
			{field:'num',title:'顺序号',width:80,hidden:true},
			{field:'Result',title:'顺序号',width:80,hidden:true},
			{field:'lifecycle',title:'生命周期节点',width:250,hidden:false},
			{field:'authorization',title:'是否授权',width:300,hidden:false,editor:Roleeditornew},
			{field:'order',title:'顺序',width:350,formatter:function(value,rec,index){
			var a = '<a href="#" class="icon icon-up" style="color:#000;display:inline-block;width:16px;height:16px" mce_href="#" onclick="upclick(\''+ index + '\')"></a> ';
			var b = '<a href="#" class="icon icon-down" style="color:#000;display:inline-block;width:16px;height:16px" mce_href="#" onclick="downclick(\''+ index + '\')"></a> ';
			return a+b;  
        		}  ,hidden:false},
        	{field:'code',title:'code',width:80,hidden:true} 
		 ]]
	var option={	
		bordr:false,
		fit:true,
		fitColumns:false,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		toolbar:[],
		pageSize:30,
		pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){ 
		   
		}, 
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
          if (editsubRow3 != ""||editsubRow3 == 0) { 
                $("#tabooListnew").datagrid('endEdit', editsubRow3); 
            } 
            $("#tabooListnew").datagrid('beginEdit', rowIndex); 
            
            editsubRow3 = rowIndex; 
        },
		  
	}
	var rowsData = $("#diclist").datagrid("getSelected");
	var rowData = $("#predictList").datagrid("getSelected");
	var id =""
	if(rowsData!=null){
		var id=rowsData.ID
		
		}
	var type=""
	if(rowData!=null){
		var type=rowData.code
		
		}
	var param=id+"^"+LifeCycleData+"^"+type
	var uniturl = $URL+"?ClassName=web.DHCCKBPosLifeCycle&MethodName=QuerylifeValue&param="+param;
	new ListComponent('tabooListnew', columns, uniturl, option).Init();	
}


/// 按钮响应事件初始化
function InitButton(){
	
	$("#insert").bind("click",InsertRow);	        // 增加岗位
	$("#savedata").bind("click",saveRow);		// 保存修改岗位
	$("#delete").bind("click",DeleteRow);	// 岗位删除
	$("#savedatabt").bind("click",saveRowbt);		// 授权保存修改
	$("#deletebt").bind("click",DeleteRowbt);	// 取消授权
}

// 增加岗位
function InsertRow(){
	//debugger;
	if(editsubRow>="0"){
		$("#diclist").datagrid('endEdit', editsubRow);		//结束编辑，传入之前编辑的行
	}
	$("#diclist").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		/* row: {ID:'', Code:'', Desc:'',Type:"",TypeDr:""} */
		row: {}
	});
	$("#diclist").datagrid('beginEdit', 0);				//开启编辑并传入要编辑的行
	editsubRow=0;
}

/// 保存修改岗位
function saveRow(){
	
	if(editsubRow>="0"){
		$("#diclist").datagrid('endEdit', editsubRow);
	}

	var rowsData = $("#diclist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!","info");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].encoded=="")||(rowsData[i].post=="")){
			$.messager.alert("提示","编码或岗位不能为空!","info"); 
			return false;
		}
	
		var tmp=($g(rowsData[i].ID)) +"^"+ ($g(rowsData[i].encoded)) +"^"+ ($g(rowsData[i].post)) +"^"+AddAttrCode 
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	var attrData = "";
	
	//保存数据 
	runClassMethod("web.DHCCKBPosLifeCycle","SaveUpdatenew",{"params":params},function(jsonString){
		
		if (jsonString >= 0){
			$.messager.alert('提示','保存成功！','info');
			$('#diclist').datagrid('reload'); //重新加载
		}else if(jsonString == -100){
			$.messager.alert('提示','保存失败,编码和岗位重复','warning');
			
		}else if(jsonString == -99){
			$.messager.alert('提示','保存失败,编码或岗位不能为空！','warning');

		}else{
			$.messager.alert('提示','保存失败！','warning');
		}
	});
}

/// 授权保存修改
function saveRowbt(){
	
	if(editsubRow>="0"){
		$("#tabooListnew").datagrid('endEdit', editsubRow3);
	}

	var rowsData = $("#diclist").datagrid("getSelected");
	var rowData = $("#predictList").datagrid("getSelected");
	var rowDatanew = $("#tabooListnew").datagrid("getSelected");
	var rowDatanewnoe = $("#tabooListnew").datagrid('getChanges');

	if(rowDatanewnoe.length<=0){
		$.messager.alert("提示","没有待保存数据!","info");
		return;
	}
	if(rowData==null){
		$.messager.alert("提示","请选择权限类别!","info");
		return;
		}

	var dataList = [];
	for(var i=0;i<rowDatanewnoe.length;i++){
		
		var tmp=rowsData.ID  +"^"+rowData.code  +"^"+ $g(rowDatanewnoe[i].authorization)+"^"+$g(rowDatanewnoe[i].lifecycle)
		dataList.push(tmp);
	}
	var params=dataList.join("&&");
	
	//保存数据
	runClassMethod("web.DHCCKBPosLifeCycle","SaveUpdate",{"params":params},function(jsonString){
		if (jsonString >= 0){
			$.messager.alert('提示','保存成功！','info');
		}else if(jsonString == -99){
			$.messager.alert('提示','保存失败,已存在该条数据','warning');
		}else if(jsonString == -100){
			$.messager.alert('提示','保存失败,没有待保存数据','warning');
		}else{
			$.messager.alert('提示','保存失败！','warning');
		}
		//InitPageInfo();		
		$('#tabooListnew').datagrid('reload'); //重新加载
	});
}



/// 岗位删除
function DeleteRow(){
	 
	var rowsData = $("#diclist").datagrid('getSelected'); 						// 选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {	// 提示是否删除
			if (res) {
				runClassMethod("web.DHCCKBPosLifeCycle","DeleteDic",{"RowID":rowsData.ID},function(jsonString){
					if (jsonString == 0){
						$('#diclist').datagrid('reload'); //重新加载
					}else{
						 $.messager.alert('提示','删除失败.失败代码'+jsonString,'warning');
					}					
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}
//取消授权
function DeleteRowbt(){
	
	var rowsDatanew = $("#diclist").datagrid("getSelected");
	var rowData = $("#predictList").datagrid("getSelected");  
	var rowsData = $("#tabooListnew").datagrid('getSelected'); 						// 选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {	// 提示是否删除
			if (res) {
				runClassMethod("web.DHCCKBPosLifeCycle","DeleteDicnew",{"RowID":rowsDatanew.ID,"type":rowData.code,"authorization":rowsData.authorization,"lifecycle":rowsData.lifecycle},function(jsonString){
					if (jsonString == 0){
						$('#tabooListnew').datagrid('reload'); //重新加载
					}else{
						 $.messager.alert('提示','删除失败.失败代码'+jsonString,'warning');
					}					
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

//上移 
function upclick(index)
{
	
	
	var newrow=parseInt(index)-1     
	var curr=$("#tabooListnew").datagrid('getData').rows[index];
	var currowid=curr.id;
	var currordnum=curr.Result;
	var up =$("#tabooListnew").datagrid('getData').rows[newrow];
	var uprowid=up.id;
	var upordnum=up.Result;

	var input=currowid+"^"+upordnum+"^"+uprowid+"^"+currordnum ;
	SaveUp(input);
	mysort(index, 'up', 'tabooListnew');
	
}
//下移  
function downclick(index)
{
	
	
	var newrow=parseInt(index)+1 ;
	var curr=$("#tabooListnew").datagrid('getData').rows[index];
	var currowid=curr.id;
	var currordnum=curr.Result;
	var down =$("#tabooListnew").datagrid('getData').rows[newrow];
	var downrowid=down.id;
	var downordnum=down.Result;

	var input=currowid+"^"+downordnum+"^"+downrowid+"^"+currordnum ;
	SaveUp(input);
	mysort(index, 'down', 'tabooListnew');
}

function SaveUp(input,datas)
{
	runClassMethod("web.DHCCKBPosLifeCycle","UpdExpFieldNum",{"input":input},
	function(ret){
		$('#tabooListnew').datagrid('reload'); //重新加载 
	},'text');
	 
}

function mysort(index, type, gridname) {

    if ("up" == type) {

        if (index != 0) {
			var nextrow=parseInt(index)-1 ;
			var lastrow=parseInt(index);
            var toup = $('#' + gridname).datagrid('getData').rows[lastrow];
            var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
            $('#' + gridname).datagrid('getData').rows[lastrow] = todown;
            $('#' + gridname).datagrid('getData').rows[nextrow] = toup;
            $('#' + gridname).datagrid('refreshRow', lastrow);
            $('#' + gridname).datagrid('refreshRow', nextrow);
            $('#' + gridname).datagrid('selectRow', nextrow);
        }
    } else if ("down" == type) {
        var rows = $('#' + gridname).datagrid('getRows').length;
        if (index != rows - 1) {
		    var nextrow=parseInt(index)+1 ;
			var lastrow=parseInt(index);
            var todown = $('#' + gridname).datagrid('getData').rows[lastrow];
            var toup = $('#' + gridname).datagrid('getData').rows[nextrow];
            $('#' + gridname).datagrid('getData').rows[nextrow] = todown;              
            $('#' + gridname).datagrid('getData').rows[lastrow] = toup;
            $('#' + gridname).datagrid('refreshRow', lastrow);
            $('#' + gridname).datagrid('refreshRow', nextrow);
            $('#' + gridname).datagrid('selectRow', nextrow);
        }
    }
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
