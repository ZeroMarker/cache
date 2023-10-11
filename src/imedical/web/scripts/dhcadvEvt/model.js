//model.js
//�����¼�ģ��
//zhouxin
//2019-05-29
var HospDr="";
$(function(){ 
    //��ʼ��ҽԺ ��Ժ������ cy 2021-04-09
    InitHosp(); 
	document.onkeydown = function(e){ 
    var ev = document.all ? window.event : e;
    	if(ev.keyCode==13) {
			Query();
     	}
	}
	initDataGrid();
	Query();

});
// ��ʼ��ҽԺ ��Ժ������ cy 2021-04-09
function InitHosp(){
	hospComp = GenHospComp("DHC_ADVModel"); 
	HospDr=hospComp.getValue(); //cy 2021-04-09
	hospComp.options().onSelect = function(){///ѡ���¼�
		HospDr=hospComp.getValue(); //cy 2021-04-09
		Query();
	}
	$("#_HospBtn").bind('click',function(){
		var rowData = $("#datagrid").datagrid('getSelected');
		if (!rowData){
			$.messager.alert("��ʾ","��ѡ��һ�У�")
			return false;
		}
		GenHospWin("DHC_ADVModel",rowData.ID);
	})

}
function initDataGrid(){
	$('#datagrid').datagrid({
		toolbar:"#toolbar",
		url:LINK_CSP+"?ClassName=web.DHCADVModel&MethodName=ListModel",
		columns:[[ 
			{field:'ID'},
			{field:'FormName',hidden:true,editor:{type:'validatebox'}},
			{field:'SubModel',hidden:true,editor:{type:'validatebox'}},
			
			{field:'Code',title:'ģ�ʹ���',width:60,align:'center',editor:{type:'validatebox',options:{required:true,validType:'isBlank'}}},
			{field:'Name',title:'ģ������',width:100,align:'center',editor:{type:'validatebox',options:{required:true,validType:'isBlank'}}},
			{field:'FormNameDesc',title:'������',width:100,align:'center',editor:{type:'validatebox'}},
			{field:'SubModelDesc',title:'�ӱ���',width:100,align:'center',editor:{type:'validatebox'}},
			{field:'FilterClass',title:'���˺�������',width:60,align:'center',editor:{type:'validatebox'}},
			{field:'FilterFunc',title:'���˺���������',width:60,align:'center',editor:{type:'validatebox'}},
			{field:'Handler',title:'����',width:80,align:'center',formatter:opRow},
			{field:'HospID',hidden:true,editor:{type:'validatebox'},hidden:true}
	
		 ]],
		title:'����ģ��<font color=red font-weight=bold font-size=12pt >��˫�����ɱ༭��</font>',
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
		onDblClickRow: function (rowIndex, rowData) {		//˫��ѡ���б༭
           onClickRow(rowIndex,rowData,"#datagrid");
           dataGridBindEnterEvent(rowIndex);
        }
	});
}
function dataGridBindEnterEvent(index){
	
	editRow=index;
	var editors = $('#datagrid').datagrid('getEditors', index);
	/// �����Ŀ����

	for(var i=0;i<editors.length;i++){
		var workEditor = editors[i];

		//������  FormNameDesc
		if(workEditor.field=="FormNameDesc"){
			workEditor.target.mousedown(function(e){
					var ed=$("#datagrid").datagrid('getEditor',{index:index, field:'FormNameDesc'});		
					var input = $(ed.target).val();
					divComponent({tarobj:$(ed.target),
								  input:input,
								  htmlType:'datagrid',
								  url:LINK_CSP+'?ClassName=web.DHCADVFormName&MethodName=listGrid&queryName='+escape(input)+'&hosp='+HospDr,
								  columns:[[
								  	{field:'ID',hidden:true},
								  	{field:'code',title:'������',width:60},
								  	{field:'name',title:'������',width:60}
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
		//�ӱ��� SubModelDesc
		else if(workEditor.field=="SubModelDesc"){
			workEditor.target.mousedown(function(e){
					var ed=$("#datagrid").datagrid('getEditor',{index:index, field:'SubModelDesc'});		
					var input = $(ed.target).val();
					divComponent({tarobj:$(ed.target),
								  input:input,
								  htmlType:'datagrid',
								  url:LINK_CSP+'?ClassName=web.DHCADVModel&MethodName=ListModel&hosp='+HospDr,
								  columns:[[
								  	{field:'ID',hidden:true},
								  	{field:'Code',title:'�������',width:60},
								  	{field:'Name',title:'��������',width:60}
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
	commonAddRow({'datagrid':'#datagrid',value:{'HospID':HospDr}})
	dataGridBindEnterEvent(0);
}

function save(){
	comSaveByDataGrid("User.DHCADVModel","#datagrid","","json",HospDr)		
}


function delModel(){
	var rowsData = $("#datagrid").datagrid('getSelected');
	if(rowsData==null){
		$.messager.alert("��ʾ","��ѡ��Ҫɾ���ļ�¼��");
		return false;
	}
	removeCom("User.DHCADVModel","#datagrid"); 
}

function opRow(value,row,index){
	var html="<a href='javascript:design("+row.ID+",\""+row.FormName+"\")' style='text-decoration:none;'>���</a>&nbsp;&nbsp;&nbsp;";
	html=html+"<a href='javascript:report(\""+row.Code+"\")' style='text-decoration:none;'>����</a>";
	return  html;
}

function design(modelId,formNameId){
	
	var url="dhcadv.model.design.csp?modelId="+modelId+"&formNameId="+formNameId
	var content = '<iframe src="' + url + '" width="100%" height="99%" frameborder="0" scrolling="yes"></iframe>';
    
    $('#designDia').dialog({
                content: content,
                maximized: true,//Ĭ�����
                modal: false
	});
	$('#designDia').dialog('open');	

}

function report(code){
	var url="dhcadv.model.report.csp?code="+code+"&quoteflag="
	var content = '<iframe src="' + url + '" width="100%" height="99%" frameborder="0" scrolling="yes"></iframe>';
    
    $('#reportDia').dialog({
                content: content,
                maximized: true,//Ĭ�����
                modal: false
	});
	$('#reportDia').dialog('open')
}
/// ��ѯ ��Ժ������ cy 2021-04-09
function Query(){
	commonQuery({'datagrid':'#datagrid','formid':'#toolbar'})
}
