$(function(){
	InitCTDefineTree();
	InitDataGrid();
	InitEvent();
});
function InitEvent()
{
	$('#menu').children('div[id]').click(function(e){
		$('#TreeNodeCode,#TreeNodeDesc').val('');
		var node=$('#tCTDefine').tree('getSelected')[0];
		var parentNode=$('#tCTDefine').tree('getParent',node.target);
		var isLeaf=node.id.indexOf('.')>-1;	//$('#tCTDefine').tree('isLeaf',node.target);
		var winOpts=$('#TreeNodeWin').window('options');
		winOpts.nodeId='',winOpts.parentNodeId='';
		switch($(this).attr('id')){
			case 'menu_add_model':
				$('#TreeNodeCode').parent().parent().hide();
				$('#TreeNodeWin').window('setTitle','增加模块分类');
				break;
			case 'menu_add':
				$('#TreeNodeCode').parent().parent().show();
				var title=isLeaf?parentNode.text:node.text;
				$('#TreeNodeWin').window('setTitle',title+' 增加代码');
				winOpts.parentNodeId=isLeaf?parentNode.id:node.id;
				break;
			case 'menu_edit':
				if(isLeaf){
					$('#TreeNodeCode').parent().parent().show();
					$('#TreeNodeWin').window('setTitle','修改模块代码: '+node.text);
					$('#TreeNodeCode').val(node.attributes.code);
				}else{
					$('#TreeNodeCode').parent().parent().hide();
					$('#TreeNodeWin').window('setTitle','修改模块分类: '+node.text);
				}
				$('#TreeNodeDesc').val(node.text);
				winOpts.nodeId=node.id;
				break;
			case 'menu_delete':
				$.messager.confirm('提示','是否删除'+(isLeaf?'模块代码':'模块分类')+': '+node.text+'?'+(isLeaf?'':'(<span style="color:red;">将删除该分类下的所有模块代码!</span>)'),function(r){
					if(r){
						var ret=$.cm({
							ClassName:'DHCDoc.DHCDocConfig.CodeTable',
							MethodName:'DeleteData',
							dataType:'text',
							NodeId:node.id,
						},false);
						if(ret==0){
							$.messager.popover({msg:'删除成功',type:'success'});
							$('#tCTDefine').tree('remove',node.target);
							$('#tabCTDefineData').datagrid('loadData',[]).datagrid("getPanel").panel("setTitle",' ');
						}else{
							$.messager.popover({msg:'删除失败:'+ret,type:'error'});
						}
					}
				});
				return;
			case 'menu_auth':
				$('#AuthGroupWin').window("open");
				return;
			default:return;
		}
		$('#TreeNodeCode,#TreeNodeDesc').validatebox('validate');
		$('#TreeNodeWin').window("open");
	});
	$('#SaveTreeNode').click(function(){
		var winOpts=$('#TreeNodeWin').window('options');
		var ret=SaveTreeNode(winOpts.parentNodeId,winOpts.nodeId,$('#TreeNodeCode').val(),$('#TreeNodeDesc').val());
		if(ret=='0'){
			$('#TreeNodeWin').window("close");
			$.messager.popover({msg:'保存成功',type:'success'});
			LoadTreeData();
		}else{
			$.messager.popover({msg:'保存失败:'+ret,type:'error'});
		}
	});
	$('#AuthGroupWin').window({
		onOpen:function(){
			if(!$('#AuthGroupWin').window('options').opened){
				$('#AuthGroupWin').window('options').opened=1;
				InitGroup();
			}else{
				$('#filtGroup').val('');
				filterGroup();
				InitAuthData();
			}
		}
	});
	$('#AuthSave').click(function(){
		var nodes=$('#tCTDefine').tree('getSelected');
		if(!nodes.length){
			$.messager.popover({msg:'请先选中需要授权的节点',type:'alert'});
			return;
		}
		var SaveArr=new Array();
		var checkedRows = $('#tabGroup').datagrid('getChecked');
		for(var i=0;i<checkedRows.length;i++){
			SaveArr.push(checkedRows[i].id);
		}
		var ret=$.cm({
			ClassName:'DHCDoc.DHCDocConfig.CodeTable',
			MethodName:'SaveNodeAuth',
			dataType:'text',
			NodeID:nodes[0].id,
			AuthData:JSON.stringify(SaveArr)
		},false);
		if(ret=='0'){
			$.messager.popover({msg:"保存成功",type:'success'});
		}else{
			$.messager.alert('提示','保存失败:'+ret);
		}
	});
	var searchTimer;
	$('#filtGroup').keyup(function(e){
		clearTimeout(searchTimer);
		searchTimer=setTimeout(filterGroup,200);
	});
	$('#btnGroupAuth').click(function(){
		ShowHISUIWindow('安全组批量授权','dhcdoc.config.groupauth.hui.csp?ShowTabs=["代码模块授权"]','icon-set-paper',$(document).width()-200,$(document).height()-200);
	});
	$('#btnHelp').click(function(){
		if($('#tipInfo').is(':visible')){
			$('#tipInfo').hide();
		}else{
			$('#tipInfo').show();
		}
	});
	$('#tipInfo').height($('#tipInfo').parent().height()-$('#tipInfo').offset().top-5);
}
function InitCTDefineTree()
{
    $('#tCTDefine').tree({
        url:'websys.Broker.cls?ClassName=DHCDoc.DHCDocConfig.CodeTable&MethodName=GetCTDefineJSON',
    	animate:true,	
		checkbox:false,
    	cascadeCheck:false,		
    	lines:true,
		dnd:true,
		onClick:function(node){
			if(!$('#tCTDefine').tree('isLeaf',node.target)){
				if(node.state=='closed') $('#tCTDefine').tree('expand',node.target);
				else $('#tCTDefine').tree('collapse',node.target);
			}else{
				//$('#tabCTDefineData').datagrid('reload');
				InitDataGrid();
			}
		},
    	onContextMenu: function(e, node){
			e.preventDefault();
			$('#tCTDefine').tree('select',node.target);
			$('#menu').menu('show', {left: e.pageX,top: e.pageY});
			//$('#tabCTDefineData').datagrid('reload');
			InitDataGrid();
		},
		onBeforeDrag:function(node){
			if(node.id.indexOf('.')==-1){
				return false;
			}
			return true;
		},
		onDragOver:function(target, source){
			var node=$('#tCTDefine').tree('getNode',target);
			if(node.id.indexOf('.')>-1){
				//$.messager.popover({msg:'请拖拽到模块分类节点上',type:'alert'});
				return false;
			}
			if(source.id.split('.')[0]==node.id){
				$.messager.popover({msg:'请拖拽到其他模块分类节点上',type:'alert'});
				return false;
			}
			return true;
		},
		onBeforeDrop:function(target, source, point){
			if(point!='append') return false;
			var node=$('#tCTDefine').tree('getNode',target);
			var ret=SaveTreeNode(node.id,source.id,source.attributes.code,source.text);
			if(ret=='0'){
				$.messager.popover({msg:'移动成功',type:'success'});
				return true;
			}else{
				$.messager.popover({msg:'移动失败:'+ret,type:'error'});
				return false
			}
		},
		onDrop:function(target, source, point){
			LoadTreeData();
		}
    });
}
function LoadTreeData()
{
	$('#tCTDefine').tree('reload');
	$('#tabCTDefineData').datagrid('loadData',[]);
	$('#tabCTDefineData').datagrid("getPanel").panel("setTitle",'代码数据');
}
function InitDataGrid()
{
	var toolbar=[{
		text:'增加',
		iconCls: 'icon-add',
		handler: function(){
			if(!GetSelectDefineId()){
				$.messager.popover({msg:'请先选中模块代码',type:'alert'});
				return;
			}
			$('#tabCTDefineData').datagrid('appendRow',{SubStDate:GetCurrentDate()});
			var rows= $('#tabCTDefineData').datagrid('getRows');
			$('#tabCTDefineData').datagrid('beginEdit',rows.length-1);
		}
	},'-',{
		text:'删除',
		iconCls: 'icon-remove',
		handler: function(){
			var Selected= $('#tabCTDefineData').datagrid('getSelected');
			if(!Selected){
				$.messager.popover({msg:"请选择需要删除的数据",type:'alert'});
				return;
			}
			if(Selected.SubRowID){
				$.messager.confirm('提示','确定删除此条数据?',function(r){
					if(r){
						var ret=$.cm({
							ClassName:'DHCDoc.DHCDocConfig.CodeTable',
							MethodName:'DelDefineData',
							DefineRowID:GetSelectDefineId(),
							SubRowID:Selected.SubRowID,
							dataType:'text'
						},false);
						if(ret=='0'){
							$.messager.popover({msg:"删除成功",type:'success'});
							$('#tabCTDefineData').datagrid('reload');
						}else{
							$.messager.alert('提示','删除失败:'+ret);
						}
					}
				});
			}else{
				var index=$('#tabCTDefineData').datagrid('getRowIndex',Selected);
				$('#tabCTDefineData').datagrid('deleteRow',index);
			}
		}
	},'-',{
		text:'保存',
		iconCls: 'icon-save',
		handler: function(){
			var SaveRows=new Array();
			var rows= $('#tabCTDefineData').datagrid('getRows');
			for(var i=0;i<rows.length;i++){
				var Editors=$('#tabCTDefineData').datagrid('getEditors',i);
				if(!Editors.length) continue;
				var row=rows[i];
				if(!row.SubRowID) row.SubRowID="";
				row.SubCode=$(Editors[0].target).val();
				row.SubDesc=$(Editors[1].target).val();
				row.SubStDate=$(Editors[2].target).datebox("getValue");
				if((row.SubCode=='')||(row.SubDesc=='')){
					$.messager.popover({msg:"代码与描述不能为空",type:'alert'});
					return;
				}
				if(row.SubStDate==""){
					$.messager.popover({msg:"开始日期不能为空",type:'alert'});
					return;
				}
				for(var j=2;j<Editors.length;j++){
					row[Editors[j].field]=$(Editors[j].target).getValue();
				}
				SaveRows.push(row);
			}
			if(!SaveRows.length){
				$.messager.popover({msg:"没有需要保存的数据",type:'alert'});
				return;
			}
			var ret=$.cm({
				ClassName:'DHCDoc.DHCDocConfig.CodeTable',
				MethodName:'SaveDefineData',
				DefineRowID:GetSelectDefineId(),
				InputStr:JSON.stringify(SaveRows),
				dataType:'text'
			},false);
			if(ret=='0'){
				$.messager.popover({msg:"保存成功",type:'success'});
				$('#tabCTDefineData').datagrid('reload');
			}else{
				$.messager.alert('提示','保存失败:'+ret);
			}
		}
	},'-',{
		text:'列扩展设定',
		iconCls: 'icon-set-col',
		handler: function(){
			var id=GetSelectDefineId();
			if(!id){
				$.messager.popover({msg:'请选择代码表',type:'alert'})
				return false;
			}
			websys_showModal({
				url: 'dhcdoc.ct.define.col.csp?DefineID='+id,
				title: '扩展列设定',
				iconCls: 'icon-set-col',
				width: 800,
				height: 600,
				onClose: function() {
					InitDataGrid();
				}
			});
		}
	}];
	var columns=$.cm({
		ClassName:'DHCDoc.DHCDocConfig.CodeTable',
		MethodName:'GetExtColCfg',
		DefineID:GetSelectDefineId()
	},false);
	$('#tabCTDefineData').datagrid({
		url:'websys.Broker.cls',
		border:true,
		title:'代码数据',
		headerCls:'panel-header-gray',
		fit : true,
		autoRowHeight:false,
		striped : true,
		singleSelect : true,
		fitColumns : false, 
		autoRowHeight : false,
		pagination : false, 
		rownumbers : true, 
		idField:"SubRowID",
		columns :columns,
		toolbar:toolbar,
		onBeforeLoad:function(param){
			var id=GetSelectDefineId();
			if(!id){
				$(this).datagrid('loadData',[]);
				return false;
			}
			var nodes=$('#tCTDefine').tree('getSelected')
			$(this).datagrid('unselectAll').datagrid("getPanel").panel("setTitle",nodes[0].text);
			param.ClassName ='DHCDoc.DHCDocConfig.CodeTable';
			param.MethodName ='GetDefineData';
			param.DefineRowID=id;
			$('#tipInfo').hide();
		},
		onDblClickRow:function(rowIndex,rowData){
			$(this).datagrid("beginEdit", rowIndex);
		}
	});
}
function GetSelectDefineId(){
	var id="";
	var node=$('#tCTDefine').tree('getSelected');
	if(node&&node.length){
		id=node[0].id.split('.')[1]||'';
	}
	return id;
}
function SaveTreeNode(ParentNodeId,NodeId,TreeNodeCode,TreeNodeDesc)
{
	return $.cm({
		ClassName:'DHCDoc.DHCDocConfig.CodeTable',
		MethodName:'SaveTreeNode',
		dataType:'text',
		ParentNodeId:ParentNodeId,
		NodeId:NodeId,
		TreeNodeCode:TreeNodeCode,
		TreeNodeDesc:TreeNodeDesc
	},false);
}
function InitGroup()
{
	$('#tabGroup').datagrid({
		idField:'id',
		singleSelect:false,
		rownumbers:false,
		columns:[[
			{field: 'id',hidden:true},
			{field:'check',checkbox:true},
			{field: 'text', title:'安全组', width: 200}
		]],
		onBeforeLoad:function(param){
			param.ClassName='DHCDoc.DHCDocConfig.CodeTable';
			param.QueryName='QueryGroup';
		},
		onLoadSuccess:function(data){
			InitAuthData();
		}
	});
}
function InitAuthData()
{
	var node=$('#tCTDefine').tree('getSelected');
	$.cm({
		ClassName:'DHCDoc.DHCDocConfig.CodeTable',
		MethodName:'GetNodeAuth',
		NodeID:node[0].id
	},function(AuthData){
		var rows=$('#tabGroup').datagrid('getRows');
		for(var i=0;i<rows.length;i++){
			if(AuthData.indexOf(rows[i].id)>-1){
				$('#tabGroup').datagrid('checkRow',i);
			}else{
				$('#tabGroup').datagrid('uncheckRow',i);
			}
		}
	});
}
function filterGroup()
{
	var desc=$('#filtGroup').val().toUpperCase();
	var GroupData=$('#tabGroup').datagrid('getRows');
	var trObj=$('#tabGroup').datagrid('getPanel').find('.datagrid-view2').find('table.datagrid-btable').find('tr');
	for(var i=0;i<GroupData.length;i++){
		if((GroupData[i].code.indexOf(desc)==-1)&&(GroupData[i].text.indexOf(desc)==-1)){
			trObj.eq(i).hide();
		}else{
			trObj.eq(i).show();
		}
	}
}