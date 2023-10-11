if(typeof GV=='undefined') var GV={};

var init=function(){

	GV.escapeHTML= function(sHtml) {
            return sHtml.replace(/[<>&"]/g,function(c){return {'<':'&lt;','>':'&gt;','&':'&amp;','"':'&quot;'}[c];});
    };
	
	GV.arr=[
		'TId','TCode','TDesc','TTemplate','TNote','TTag'
		,{id:'TActive',type:'checkbox',on:'Y',off:'N'}
	]
	$('#list').datagrid({
		title:'��Ϣģ���б�',
		headerCls:'panel-header-gray',
        pagination: true,
        striped:true,
        singleSelect:true,
        idField:'TId',
        rownumbers:true,
        url:$URL,
        queryParams:{
	        ClassName:'CT.BSP.MSG.BL.Template',
	        QueryName:'Find',
	        q:''
	    },
	    fit:true,
	    fitColumns:true,
	    //TId:%String,TActive:%String,TCode:%String,TDesc:%String,TNote:%String,TTemplate:%String
	    columns:[[
	    	{field:'TCode',title:'����',width:120},
	    	{field:'TDesc',title:'����',width:120},
	    	{field:'TTag',title:'��ǩ',width:120},
			{field:'TTemplate',title:'ģ��',width:500,formatter:function(val,row,ind){
				return GV.escapeHTML(val);
			}},
			{field:'TNote',title:'��ע',width:150},
			{field:'TActive',title:'����',width:60}
			,{field:'TBizVariables',title:'����ģ�����',width:350,formatter:function(val,row,ind){
				var text='',textArr=[];
				try {
					var valJson=$.parseJSON(val);
					$.each(valJson,function(){
						textArr.push(this.key||'');
					})
				}catch(e){}
				
				text=textArr.join(',');
				text=text||'����ģ�����';
				return '<a href="javascript:void(0);" data-ind="'+ind+'" onclick="openBizVariablesEdit(\''+ind+'\')">'+text+'</a>'	
			}}  //ҵ�����
	    ]],
	    toolbar:[{
			id:'tb-add',
			iconCls:'icon-add',
			text:'����',
			handler:function(){
				$('#win').dialog('open').dialog('setTitle','����');
				GV.setEditVal();
			} 
		},{
			id:'tb-edit',
			iconCls:'icon-edit',
			text:'�޸�',
			handler:function(){
				var row=$('#list').datagrid('getSelected');
				if(row && row.TId) {
					$('#win').dialog('open').dialog('setTitle','�޸�');
					GV.setEditVal(row)
				}else{
					$.messager.popover({msg:'��ѡ��һ����¼',type:'alert'})	
				}
				
			} 
		},{
			id:'tb-copy',
			iconCls:'icon-copy',
			text:'����',
			handler:function(){
				var row=$('#list').datagrid('getSelected');
				if(row && row.TId) {
					var rowClone=$.extend({},row)
					rowClone.TId='';
					
					$('#win').dialog('open').dialog('setTitle','����');
					GV.setEditVal(rowClone)
				}else{
					$.messager.popover({msg:'��ѡ��һ����¼',type:'alert'})	
				}
				
			} 
		},{
			id:'tb-remove',
			iconCls:'icon-remove',
			text:'ɾ��',
			handler:function(){
				var row=$('#list').datagrid('getSelected');
				if(row && row.TId) {
					$.messager.confirm('��ʾ','ȷ��ɾ��������¼ô��',function(r){
						if(r){
							$.m({ClassName:'CT.BSP.MSG.BL.Template',MethodName:'Delete',Id:row.TId},function(ret){
								if (ret>0) {
									$.messager.popover({msg:'ɾ���ɹ�',type:'success'});
									$('#list').datagrid('reload');
								}else{
									$.messager.popover({msg:'ɾ��ʧ��'+ret.split('^')[1]||ret,type:'error'});
								}
							})	
						}	
					})
				}else{
					$.messager.popover({msg:'��ѡ��һ����¼',type:'alert'})	
				}
			} 
		}],
		onLoadSuccess:function(){
			$('.op-test').off('click').on('click',function(){
				var ind=$(this).data('ind');
				var row=$('#list').datagrid('getRows')[ind];
				showTestWin(row,ind);
			})	
		}
	})
	$('#search').searchbox({
		prompt:'���롢����',
		searcher:function(val){
			$('#list').datagrid('load',{ClassName:'CT.BSP.MSG.BL.Template',QueryName:'Find',q:val})
		}
	})
	$('#TTemplate').templateprompt({
		url:$URL,
		mode:'remote',
		queryParams:{ClassName:'CT.BSP.MSG.BL.Template',QueryName:'FindParams'},
		pagination:true,
		idField: 'PCode', 
		onBeforeLoad:function(param){
			param = $.extend(param,{q:param.q});
			param.tmplId=$('#TId').val();
			return true;
		},
		panelWidth:430,
		panelHeight:200,
		columns:[[
			{field:'PCode',title:'ռλ��',width:200},
			{field:'PDesc',title:'˵��',width:200}
		]]
	});
	$('#win').dialog({
		title:'����',
		iconCls:'icon-w-paper',
		buttons:[{
			text:'ȷ��',
			handler:function(){
				var data=GV.getEditVal();
				if (!data.isValid) {
					$.messager.popover({msg:'������֤ʧ��',type:'error'});
					return;}
				delete data.isValid;
				
				data._headers={'X-Accept-Tag':1};
				$.extend(data,{ClassName:'CT.BSP.MSG.BL.Template',MethodName:'Save'});
				
				$.m(data,function(ret){
					if (ret>0) {
						$.messager.popover({msg:'����ɹ�',type:'success'});
						$('#win').dialog('close');
						$('#list').datagrid('reload');
					}else{
						$.messager.popover({msg:'����ʧ��'+ret.split('^')[1]||ret,type:'error'});
					}
				})
			}	
		},{
			text:'ȡ��',
			handler:function(){
				$('#win').dialog('close');
			}
		}]
	})
	
	
	GV.setEditVal=function(row){
		if(row){
			common.setData(GV.arr,'',row);
		}else{
			common.setData(GV.arr,'',{TActive:'Y'});
		}
		common.validate(GV.arr);
		
		$('#TTemplate').templateprompt('clearPreviousValue')
		
	}
	GV.getEditVal=function(){
		var data=common.getData(GV.arr,'T');
		var isValid=common.validate(GV.arr);
		data.isValid=isValid;
		return data;
	}
}

function openBizVariablesEdit(ind){
	if ($('#bv-win').length==0) {
		$('<div id="bv-win"><table id="bv-table"></table></div>').appendTo('body')	
		
		$('#bv-win').dialog({
			width:530,
			height:500,
			modal:true,
			buttons:[{
				text:'ȷ��',
				handler:function(){
					
					var editindex=$('#bv-table').data('editindex');
					if (editindex>-1) $('#bv-table').datagrid('endEdit',editindex);
					var rows=$('#bv-table').datagrid('getRows');
					var myrows=$.grep(rows,function(itm){return !!itm.key})
					//����
					var tmplid=$('#bv-table').data('edittmplid')
					$m({ClassName:'CT.BSP.MSG.BL.Template',MethodName:'SaveBizVariables',Id:tmplid,BizVariables:JSON.stringify(myrows)},function(ret){
						if(ret>0) {
							$.messager.popover({msg:'����ɹ�',type:'success'});
							$('#bv-win').dialog('close');
							$('#bv-table').data('editindex','-1');
							$('#list').datagrid('reload');
							
						}else{
							$.messager.popover({msg:'����ʧ��'+ret.split('^')[1]||ret,type:'error'});
						}
					})
					
					
					
				}	
			},{
				text:'�ر�',
				handler:function(){
					$('#bv-win').dialog('close');
					$('#bv-table').data('editindex','-1');
					$('#bv-table').data('edittmplid','-1')
				}	
			}]	
			
		})
		
		$('#bv-table').data('editindex','-1');
		$('#bv-table').datagrid({
			columns:[[
				{field:'key',title:'����',width:150,editor:'text'},
				{field:'desc',title:'��������',width:150,editor:'text'},
				{field:'note',title:'˵��',width:200,editor:'text'}
			]],
			fit:true,
			data:[{key:'',desc:'',note:''}],
			rownumbers:true,
			bodyCls:'panel-header-gray',
			border:false,
			onClickRow:function(index,row){
				var editindex=$(this).data('editindex')
				if( editindex==index){
					$(this).datagrid('endEdit', index);
					editindex=-1;
				}else{
					if(editindex>-1) $(this).datagrid('endEdit', editindex);
					if( index==$(this).datagrid('getRows').length-1){  //ֻҪ������һ�� ������һ��
						$(this).datagrid('appendRow',{key:'',desc:'',custom:true,note:''});
					}
					$(this).datagrid('beginEdit', index);
					editindex=index;
				}
				$(this).data('editindex',editindex)
			},
			onAfterEdit:function(index,rowData){
				if( index==$(this).datagrid('getRows').length-1){  //���һ��
					if(rowData.key!="" && rowData.value!="" ){
						$(this).datagrid('appendRow',{key:'',desc:'',custom:true,note:''});
					}
				}
			}
			
		})
		
		
		
	}
	
	
	
	
	var row=$('#list').datagrid('getRows')[ind];
	if(row) {
		
		var TBizVariables=row.TBizVariables;
		var jsonArr=[];
		try {
			jsonArr=$.parseJSON(TBizVariables);
		}catch(e){}
		
		$('#bv-win').dialog('open').dialog('setTitle','����ģ�����-'+row.TDesc);
		jsonArr.push({key:'',desc:'',note:''})
		$('#bv-table').datagrid('loadData',jsonArr);
		
		$('#bv-table').data('edittmplid',row.TId);
		
	}else{
		$.messager.popover({msg:'��ǰ�в���ȷ',type:'error'});
	}
	
}


$(init);