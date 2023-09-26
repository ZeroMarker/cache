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
		title:'Σ��ֵ����',
		url:$URL+"?ClassName=web.DHCAntCVOptions&QueryName=Find&OptsType=CVType",
		pagination:true,
		pageSize:20,
		rownumbers:true,
		singleSelect:true,
		striped:true,
		columns:[[
			{field:'TId',title:'TId',hidden:true,width:0},
			{field:'TCode',title:'����',width:100,editor:{
				type:'validatebox',
				options:{required:true,validType:'length[1,2]'}
				
			}},
			{field:'TDesc',title:'����',width:100,editor:{
				type:'validatebox',
				options:{required:true}
			}},
			{field:'TNote',title:'˵��',width:300,editor:{
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
				text:'����',
				iconCls:'icon-add',
				handler:function(){
					if (GV.editingIndex>-1){
						GV.alert("��ʾ","���ȱ������ڱ༭����",'info');
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
				text:'�༭',
				iconCls:'icon-edit',
				handler:function(){
					if (GV.editingIndex>-1){
						GV.alert("��ʾ","���ȱ������ڱ༭����",'info');
						return;	
					}
					var row=dg.datagrid('getSelected');
					if (row){
						var rowIndex=dg.datagrid('getRowIndex',row);
					}else{
						GV.alert("��ʾ","��ѡ��һ������",'info');
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
				text:'ɾ��',
				iconCls:'icon-remove',
				handler:function(){
					if (GV.editingIndex>-1){
						GV.alert("��ʾ","���ȱ������ڱ༭����",'info');
						return;	
					}
					var row=dg.datagrid('getSelected');
					if (row){
						$.messager.confirm("ȷ��","ȷ��ɾ����Σ��ֵ������",function(r){
							if(r){
								$.ajaxRunServerMethod({ClassName:'web.DHCAntCVOptions',MethodName:'DeleteCVType',Code:row.TCode},function(rtn){
									if (rtn>0){
										GV.alert("�ɹ�","ɾ���ɹ�","success");	
										dg.datagrid('reload');
									}else{
										GV.alert("ʧ��",rtn.split("^")[1]||rtn,"error");	
									}
								})	
							}
						})
					}else{
						GV.alert("��ʾ","��ѡ��һ������",'info');
						return;	
					}
				}	
			},{
				text:'ȡ���༭',
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
						GV.alert("��ʾ","��û�����ڱ༭����",'info')	;
					}
				}	
			},{
				text:'����',
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
							GV.alert('��ʾ','���볤��Ϊ1��2','info');
							return;
						}
						if (rowData.TDesc==""){
							GV.alert('��ʾ','��������Ϊ��','info');
							return;
						}

						$.ajaxRunServerMethod({ClassName:'web.DHCAntCVOptions',MethodName:'SaveCVType',Code:rowData.TCode,Desc:rowData.TDesc,Note:rowData.TNote},function(rtn){
							if (rtn.indexOf('-1')==0){
								GV.alert("ʧ��",rtn.split("^")[1]||rtn,"error");
							}else{
								GV.alert("�ɹ�","����ɹ�","success");	
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
						GV.alert("��ʾ","��û�����ڱ༭����",'info')	;
					}
				}	
			}
		]
		
	})
}


$(init);