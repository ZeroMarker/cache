var GV={};
GV.alert=function(title,msg,type){
	if (typeof $.messager.popover=="function"){
		$.messager.popover({msg:msg,type:type,timeout: 1000})
	}else{
		$.messager.alert(title,msg)
	}
}
if (typeof $URL=="undefined") var $URL='jquery.easyui.querydatatrans.csp';
var init=function(){
	GV.HISUIEnable= (typeof $HUI=="object");
	var dg=$('#tDHCAntCVType').datagrid({
		fit:true,
		headerCls:'panel-header-gray',
		title:'危急值类型',
		url:$URL+"?ClassName=web.DHCAntCVOptions&QueryName=Find&OptsType=CVType",
		pagination:true,
		pageSize:20,
		rownumbers:true,
		singleSelect:true,
		striped:true,
		columns:[[
			{field:'TId',title:'TId',hidden:true,width:0},
			{field:'TCode',title:'代码',width:100,editor:{
				type:'validatebox',
				options:{required:true,validType:'length[1,2]'}
				
			}},
			{field:'TDesc',title:'描述',width:100,editor:{
				type:'validatebox',
				options:{required:true}
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
						TType:'CVType',
						TCode:'',
						TDesc:'',
						TNote:''	
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
						$.messager.confirm("确定","确认删除此危急值类型吗？",function(r){
							if(r){
								$.ajaxRunServerMethod({ClassName:'web.DHCAntCVOptions',MethodName:'DeleteCVType',Code:row.TCode},function(rtn){
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
						if (rowData.TCode.length<1 || rowData.TCode.length>2) {
							GV.alert('提示','代码长度为1或2','info');
							return;
						}
						if (rowData.TDesc==""){
							GV.alert('提示','描述不能为空','info');
							return;
						}

						$.ajaxRunServerMethod({ClassName:'web.DHCAntCVOptions',MethodName:'SaveCVType',Code:rowData.TCode,Desc:rowData.TDesc,Note:rowData.TNote},function(rtn){
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
}


$(init);