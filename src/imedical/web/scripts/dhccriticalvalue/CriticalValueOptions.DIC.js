var GV={};
GV.alert=function(title,msg,type){
	if (typeof $.messager.popover=="function"){
		$.messager.popover({msg:msg,type:type,timeout: 1000})
	}else{
		$.messager.alert(title,msg)
	}
}
if (typeof $URL=="undefined") var $URL='jquery.easyui.querydatatrans.csp';


var initLeft=function(){
	var dg=$('#tDICType').datagrid({
		fit:true,
		fitColumns:true,
		headerCls:'panel-header-gray',
		title:'字典定义',
		url:$URL+"?ClassName=web.DHCAntCVOptions&QueryName=Find&OptsType=DICType",
		pagination:true,
		pageSize:20,
		rownumbers:true,
		singleSelect:true,
		striped:true,
		columns:[[
			{field:'TId',title:'TId',hidden:true,width:0},
			{field:'TCode',title:'字典代码',width:100,editor:{
				type:'validatebox',
				options:{required:true,validType:'length[1,40]'}
				
			}},
			{field:'TDesc',title:'字典名称',width:100,editor:{
				type:'validatebox',
				options:{required:true}
			}},
			{field:'TNote',title:'说明',width:300,editor:{
				type:'text'
			}},
		]],
		onLoadSuccess:function(){
			GV.editingIndexLeft=-1	;
			dg.datagrid('clearSelections');
			
			GV.dg.datagrid('getPanel').panel('setTitle','请选择字典');
			
			GV.dg.datagrid('clearSelections');
			GV.editingIndexLeft=-1;
			GV.dg.datagrid('load',{OptsType:''});
			GV.currDICType='';
			
			GV.dg.datagrid('getPanel').find('.datagrid-toolbar .l-btn').linkbutton('disable');
			
		},
		onSelect:function(ind,row){
			//console.log(row,ind)
			GV.dg.datagrid('getPanel').panel('setTitle',row.TDesc);
			GV.dg.datagrid('clearSelections');
			GV.editingIndexLeft=-1;
			GV.dg.datagrid('load',{OptsType:row.TCode});
			GV.currDICType=row.TCode;
			GV.dg.datagrid('getPanel').find('.datagrid-toolbar .l-btn').linkbutton('enable');
		},
		onAfterEdit:function(rowIndex,rowData,changes){
			//console.log(changes)
		},
		toolbar:[
			{
				text:'新增',
				iconCls:'icon-add',
				handler:function(){
					if (GV.editingIndexLeft>-1){
						GV.alert("提示","请先保存正在编辑的行",'info');
						return;	
					}
					var newRowIndex=dg.datagrid('unselectAll').datagrid('appendRow',{
						TId:'',
						TType:'DICType',
						TCode:'',
						TDesc:'',
						TNote:''	
					}).datagrid('getRows').length-1;
					dg.datagrid('beginEdit',newRowIndex);
					GV.editingIndexLeft=newRowIndex;
					
				}	
			},{
				text:'编辑',
				iconCls:'icon-edit',
				handler:function(){
					if (GV.editingIndexLeft>-1){
						GV.alert("提示","请先保存正在编辑的行",'info');
						return;	
					}
					var row=dg.datagrid('getSelected');
					if (row){
						var rowIndex=dg.datagrid('getRowIndex',row);
					}else{
						GV.alert("提示","请选择一行数据",'info');
						return;	
					}
					dg.datagrid('beginEdit',rowIndex);
					GV.editingIndexLeft=rowIndex;
					
					var edts=dg.datagrid('getEditors',GV.editingIndexLeft);
					for (var i=0;i<edts.length;i++){
						var edt=edts[i];
						if (edt.field=="TCode"){
							$(edt.target).attr('disabled','disabled');
						}
					}
					
				}	
			},{
				text:'删除',
				iconCls:'icon-remove',
				handler:function(){
					if (GV.editingIndexLeft>-1){
						GV.alert("提示","请先保存正在编辑的行",'info');
						return;	
					}
					var row=dg.datagrid('getSelected');
					if (row){
						$.messager.confirm("确定","确认删除此字典定义吗？",function(r){
							if(r){
								$.ajaxRunServerMethod({ClassName:'web.DHCAntCVOptions',MethodName:'DeleteDICType',Code:row.TCode},function(rtn){
									if (rtn>0){
										GV.alert("成功","删除成功","success");	
										dg.datagrid('reload');
									}else{
										GV.alert("失败",rtn.split("^")[1]||rtn,"error");	
									}
								})	
							}
						})
					}else{
						GV.alert("提示","请选择一行数据",'info');
						return;	
					}
				}	
			},{
				text:'取消编辑',
				iconCls:'icon-undo',
				handler:function(){
					if (GV.editingIndexLeft>-1){
						var row=dg.datagrid('getRows')[GV.editingIndexLeft];
						if (row && row.TId){
							dg.datagrid('cancelEdit',GV.editingIndexLeft);
						}else{
							dg.datagrid('deleteRow',GV.editingIndexLeft);
						}
						GV.editingIndexLeft=-1;
					}else{
						GV.alert("提示","您没有正在编辑的行",'info')	;
					}
				}	
			},{
				text:'保存',
				iconCls:'icon-save',
				handler:function(){
					if (GV.editingIndexLeft>-1){
						var rowData={};
						
						var edts=dg.datagrid('getEditors',GV.editingIndexLeft)
						for (var i=0;i<edts.length;i++){
							var edt=edts[i];
							rowData[edt.field]=$(edt.target).val();
						}
						if (rowData.TCode.length<1 || rowData.TCode.length>40) {
							GV.alert('提示','代码长度为1-40','info');
							return;
						}
						if (rowData.TDesc==""){
							GV.alert('提示','描述不能为空','info');
							return;
						}

						$.ajaxRunServerMethod({ClassName:'web.DHCAntCVOptions',MethodName:'SaveDICType',Code:rowData.TCode,Desc:rowData.TDesc,Note:rowData.TNote},function(rtn){
							if (rtn.indexOf('-1')==0){
								GV.alert("失败",rtn.split("^")[1]||rtn,"error");
							}else{
								GV.alert("成功","保存成功","success");	
								dg.datagrid('endEdit',GV.editingIndexLeft);
								rowData.TId=rtn
								dg.datagrid('updateRow',{
									index:GV.editingIndexLeft,
									row:rowData
								});
								GV.editingIndexLeft=-1;
								//dg.datagrid('reload');
							}
						})	
					}else{
						GV.alert("提示","您没有正在编辑的行",'info')	;
					}
				}	
			}
		]
		
	})
	
	GV.dgLeft=dg;
}



var init=function(){
	initLeft();
	
	var dg=$('#tDIC').datagrid({
		fit:true,
		fitColumns:true,
		headerCls:'panel-header-gray',
		title:'请选择字典',
		url:$URL+"?ClassName=web.DHCAntCVOptions&QueryName=Find",
		pagination:true,
		pageSize:20,
		rownumbers:true,
		singleSelect:true,
		striped:true,
		columns:[[
			{field:'TId',title:'TId',hidden:true,width:0},
			{field:'TCode',title:'代码',width:100,editor:{
				type:'validatebox',
				options:{required:true,validType:'length[1,40]'}
				
			}},
			{field:'TDesc',title:'描述',width:100,editor:{
				type:'validatebox',
				options:{required:true}
			}},
			{field:'TSeq',title:'顺序',width:100,editor:{
				type:'text'
			}},
			{field:'TNote',title:'说明',width:300,editor:{
				type:'text'
			}},
		]],
		onLoadSuccess:function(){
			GV.editingIndex=-1	;
		},
		onAfterEdit:function(rowIndex,rowData,changes){
			//console.log(changes)
		},
		toolbar:[
			{
				text:'新增',
				iconCls:'icon-add',
				handler:function(){
					if (GV.editingIndex>-1){
						GV.alert("提示","请先保存正在编辑的行",'info');
						return;	
					}
					var newRowIndex=dg.datagrid('unselectAll').datagrid('appendRow',{
						TId:'',
						TType:GV.currDICType,
						TCode:'',
						TDesc:'',
						TNote:''
						,TSeq:''	
					}).datagrid('getRows').length-1;
					dg.datagrid('beginEdit',newRowIndex);
					GV.editingIndex=newRowIndex;
					
				}	
			},{
				text:'编辑',
				iconCls:'icon-edit',
				handler:function(){
					if (GV.editingIndex>-1){
						GV.alert("提示","请先保存正在编辑的行",'info');
						return;	
					}
					var row=dg.datagrid('getSelected');
					if (row){
						var rowIndex=dg.datagrid('getRowIndex',row);
					}else{
						GV.alert("提示","请选择一行数据",'info');
						return;	
					}
					dg.datagrid('beginEdit',rowIndex);
					GV.editingIndex=rowIndex;
					
					var edts=dg.datagrid('getEditors',GV.editingIndex);
					for (var i=0;i<edts.length;i++){
						var edt=edts[i];
						if (edt.field=="TCode"){
							$(edt.target).attr('disabled','disabled');
						}
					}
					
				}	
			},{
				text:'删除',
				iconCls:'icon-remove',
				handler:function(){
					if (GV.editingIndex>-1){
						GV.alert("提示","请先保存正在编辑的行",'info');
						return;	
					}
					var row=dg.datagrid('getSelected');
					if (row){
						$.messager.confirm("确定","确认删除此条数据吗？",function(r){
							if(r){
								$.ajaxRunServerMethod({ClassName:'web.DHCAntCVOptions',MethodName:'Delete',Type:GV.currDICType,Code:row.TCode},function(rtn){
									if (rtn>0){
										GV.alert("成功","删除成功","success");	
										dg.datagrid('reload');
									}else{
										GV.alert("失败",rtn.split("^")[1]||rtn,"error");	
									}
								})	
							}
						})
					}else{
						GV.alert("提示","请选择一行数据",'info');
						return;	
					}
				}	
			},{
				text:'取消编辑',
				iconCls:'icon-undo',
				handler:function(){
					if (GV.editingIndex>-1){
						var row=dg.datagrid('getRows')[GV.editingIndex];
						if (row && row.TId){
							dg.datagrid('cancelEdit',GV.editingIndex);
						}else{
							dg.datagrid('deleteRow',GV.editingIndex);
						}
						GV.editingIndex=-1;
					}else{
						GV.alert("提示","您没有正在编辑的行",'info')	;
					}
				}	
			},{
				text:'保存',
				iconCls:'icon-save',
				handler:function(){
					if (GV.editingIndex>-1){
						var rowData={};
						
						var edts=dg.datagrid('getEditors',GV.editingIndex)
						for (var i=0;i<edts.length;i++){
							var edt=edts[i];
							rowData[edt.field]=$(edt.target).val();
						}
						if (rowData.TCode.length<1 || rowData.TCode.length>40) {
							GV.alert('提示','代码长度为1-40','info');
							return;
						}
						if (rowData.TDesc==""){
							GV.alert('提示','描述不能为空','info');
							return;
						}

						$.ajaxRunServerMethod({ClassName:'web.DHCAntCVOptions',MethodName:'Save',Type:GV.currDICType,Code:rowData.TCode,Value:rowData.TDesc,Note:rowData.TNote,Seq:rowData.TSeq},function(rtn){
							if (rtn.indexOf('-1')==0){
								GV.alert("失败",rtn.split("^")[1]||rtn,"error");
							}else{
								GV.alert("成功","保存成功","success");	
								dg.datagrid('endEdit',GV.editingIndex);
								rowData.TId=rtn
								dg.datagrid('updateRow',{
									index:GV.editingIndex,
									row:rowData
								});
								GV.editingIndex=-1;
								//dg.datagrid('reload');
							}
						})	
					}else{
						GV.alert("提示","您没有正在编辑的行",'info')	;
					}
				}	
			}
		]
		
	})
	GV.dg=dg;
}


$(init);