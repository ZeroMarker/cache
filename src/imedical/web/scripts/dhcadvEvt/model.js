//model.js
//不良事件模型
//zhouxin
//2019-05-29
$(function(){ 

	document.onkeydown = function(e){ 
    var ev = document.all ? window.event : e;
    	if(ev.keyCode==13) {
			commonQuery({'datagrid':'#datagrid','formid':'#toolbar'})
     	}
	}
	initDataGrid();
});

function initDataGrid(){
	$('#datagrid').datagrid({
		toolbar:"#toolbar",
		url:LINK_CSP+"?ClassName=web.DHCADVModel&MethodName=ListModel",
		columns:[[ 
			{field:'ID'},
			{field:'FormName',hidden:true,editor:{type:'validatebox'}},
			{field:'SubModel',hidden:true,editor:{type:'validatebox'}},
			
			{field:'Code',title:'模型代码',width:60,align:'center',editor:{type:'validatebox',options:{required:true,validType:'isBlank'}}},
			{field:'Name',title:'模型名称',width:100,align:'center',editor:{type:'validatebox',options:{required:true,validType:'isBlank'}}},
			{field:'FormNameDesc',title:'关联表单',width:100,align:'center',editor:{type:'validatebox'}},
			{field:'SubModelDesc',title:'子报表',width:100,align:'center',editor:{type:'validatebox'}},
			{field:'FilterClass',title:'过滤函数类名',width:60,align:'center',editor:{type:'validatebox'}},
			{field:'FilterFunc',title:'过滤函数方法名',width:60,align:'center',editor:{type:'validatebox'}},
			{field:'Handler',title:'操作',width:40,align:'center',formatter:opRow}		
		 ]],
		title:'数据模型<font color=red font-weight=bold font-size=12pt >【双击即可编辑】</font>',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper', 
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
		onDblClickRow: function (rowIndex, rowData) {		//双击选择行编辑
           onClickRow(rowIndex,rowData,"#datagrid");
           dataGridBindEnterEvent(rowIndex);
        }
	});
}
function dataGridBindEnterEvent(index){
	
	editRow=index;
	var editors = $('#datagrid').datagrid('getEditors', index);
	/// 检查项目名称

	for(var i=0;i<editors.length;i++){
		var workEditor = editors[i];

		//关联表单  FormNameDesc
		if(workEditor.field=="FormNameDesc"){
			workEditor.target.mousedown(function(e){
					var ed=$("#datagrid").datagrid('getEditor',{index:index, field:'FormNameDesc'});		
					var input = $(ed.target).val();
					divComponent({tarobj:$(ed.target),
								  input:input,
								  htmlType:'datagrid',
								  url:LINK_CSP+'?ClassName=web.DHCADVFormName&MethodName=listGrid',
								  columns:[[
								  	{field:'ID',hidden:true},
								  	{field:'code',title:'表单代码',width:60},
								  	{field:'name',title:'表单名称',width:60}
								  ]]
								},function(rowData){
									$(ed.target).val(rowData.name);
									var FormNameEd=$("#datagrid").datagrid('getEditor',{index:index, field:'FormName'});
									$(FormNameEd.target).val(rowData.ID);
									$("#win").remove();
								})
				
			});
			workEditor.target.bind("input propertychange",function(e){
				var ed=$("#datagrid").datagrid('getEditor',{index:index, field:'FormNameDesc'});		
				var input = $(ed.target).val();
				if($.trim(input)==""){
					var FormNameEd=$("#datagrid").datagrid('getEditor',{index:index, field:'FormName'});
					$(FormNameEd.target).val("");
				}
			})	
		}
		//子报表 SubModelDesc
		else if(workEditor.field=="SubModelDesc"){
			workEditor.target.mousedown(function(e){
					var ed=$("#datagrid").datagrid('getEditor',{index:index, field:'SubModelDesc'});		
					var input = $(ed.target).val();
					divComponent({tarobj:$(ed.target),
								  input:input,
								  htmlType:'datagrid',
								  url:LINK_CSP+'?ClassName=web.DHCADVModel&MethodName=ListModel',
								  columns:[[
								  	{field:'ID',hidden:true},
								  	{field:'Code',title:'报表代码',width:60},
								  	{field:'Name',title:'报表名称',width:60}
								  ]]
								},function(rowData){
									$(ed.target).val(rowData.Name);
									var SubModelEd=$("#datagrid").datagrid('getEditor',{index:index, field:'SubModel'});
									$(SubModelEd.target).val(rowData.ID);
									$("#win").remove();
								})
				
			});
			workEditor.target.bind("input propertychange",function(e){
				var ed=$("#datagrid").datagrid('getEditor',{index:index, field:'SubModel'});		
				var input = $(ed.target).val();
				if($.trim(input)==""){
					var SubModelEd=$("#datagrid").datagrid('getEditor',{index:index, field:'FormName'});
					$(SubModelEd.target).val("");
				}
			})
		}
		else{
			workEditor.target.mousedown(function(e){
					$("#win").remove();;
			});
			workEditor.target.focus(function(e){
					$("#win").remove();;
			});
		}
	}
}
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}

function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{}})
	dataGridBindEnterEvent(0);
}

function save(){
	comSaveByDataGrid("User.DHCADVModel","#datagrid","","json")		
}


function delModel(){
	var rowsData = $("#datagrid").datagrid('getSelected');
	if(rowsData==null){
		$.messager.alert("提示","请选择要删除的记录！");
		return false;
	}
	removeCom("User.DHCADVModel","#datagrid"); 
}

function opRow(value,row,index){
	var html="<a href='javascript:design("+row.ID+",\""+row.FormName+"\")' style='text-decoration:none;'>设计</a>&nbsp;&nbsp;&nbsp;";
	html=html+"<a href='javascript:report(\""+row.Code+"\")' style='text-decoration:none;'>报表</a>";
	return  html;
}

function design(modelId,formNameId){
	
	var url="dhcadv.model.design.csp?modelId="+modelId+"&formNameId="+formNameId
	var content = '<iframe src="' + url + '" width="100%" height="99%" frameborder="0" scrolling="yes"></iframe>';
    
    $('#designDia').dialog({
                content: content,
                maximized: true,//默认最大化
                modal: false
	});
	$('#designDia').dialog('open');	

}

function report(code){
	var url="dhcadv.model.report.csp?code="+code+"&quoteflag="
	var content = '<iframe src="' + url + '" width="100%" height="99%" frameborder="0" scrolling="yes"></iframe>';
    
    $('#reportDia').dialog({
                content: content,
                maximized: true,//默认最大化
                modal: false
	});
	$('#reportDia').dialog('open')
}
