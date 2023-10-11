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
		title:'消息模板列表',
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
	    	{field:'TCode',title:'代码',width:120},
	    	{field:'TDesc',title:'名称',width:120},
	    	{field:'TTag',title:'标签',width:120},
			{field:'TTemplate',title:'模板',width:500,formatter:function(val,row,ind){
				return GV.escapeHTML(val);
			}},
			{field:'TNote',title:'备注',width:150},
			{field:'TActive',title:'启用',width:60}
			,{field:'TBizVariables',title:'其它模板变量',width:350,formatter:function(val,row,ind){
				var text='',textArr=[];
				try {
					var valJson=$.parseJSON(val);
					$.each(valJson,function(){
						textArr.push(this.key||'');
					})
				}catch(e){}
				
				text=textArr.join(',');
				text=text||'增加模板变量';
				return '<a href="javascript:void(0);" data-ind="'+ind+'" onclick="openBizVariablesEdit(\''+ind+'\')">'+text+'</a>'	
			}}  //业务变量
	    ]],
	    toolbar:[{
			id:'tb-add',
			iconCls:'icon-add',
			text:'新增',
			handler:function(){
				$('#win').dialog('open').dialog('setTitle','新增');
				GV.setEditVal();
			} 
		},{
			id:'tb-edit',
			iconCls:'icon-edit',
			text:'修改',
			handler:function(){
				var row=$('#list').datagrid('getSelected');
				if(row && row.TId) {
					$('#win').dialog('open').dialog('setTitle','修改');
					GV.setEditVal(row)
				}else{
					$.messager.popover({msg:'请选择一条记录',type:'alert'})	
				}
				
			} 
		},{
			id:'tb-copy',
			iconCls:'icon-copy',
			text:'复制',
			handler:function(){
				var row=$('#list').datagrid('getSelected');
				if(row && row.TId) {
					var rowClone=$.extend({},row)
					rowClone.TId='';
					
					$('#win').dialog('open').dialog('setTitle','新增');
					GV.setEditVal(rowClone)
				}else{
					$.messager.popover({msg:'请选择一条记录',type:'alert'})	
				}
				
			} 
		},{
			id:'tb-remove',
			iconCls:'icon-remove',
			text:'删除',
			handler:function(){
				var row=$('#list').datagrid('getSelected');
				if(row && row.TId) {
					$.messager.confirm('提示','确认删除此条记录么？',function(r){
						if(r){
							$.m({ClassName:'CT.BSP.MSG.BL.Template',MethodName:'Delete',Id:row.TId},function(ret){
								if (ret>0) {
									$.messager.popover({msg:'删除成功',type:'success'});
									$('#list').datagrid('reload');
								}else{
									$.messager.popover({msg:'删除失败'+ret.split('^')[1]||ret,type:'error'});
								}
							})	
						}	
					})
				}else{
					$.messager.popover({msg:'请选择一条记录',type:'alert'})	
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
		prompt:'代码、名称',
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
			{field:'PCode',title:'占位符',width:200},
			{field:'PDesc',title:'说明',width:200}
		]]
	});
	$('#win').dialog({
		title:'新增',
		iconCls:'icon-w-paper',
		buttons:[{
			text:'确定',
			handler:function(){
				var data=GV.getEditVal();
				if (!data.isValid) {
					$.messager.popover({msg:'数据验证失败',type:'error'});
					return;}
				delete data.isValid;
				
				data._headers={'X-Accept-Tag':1};
				$.extend(data,{ClassName:'CT.BSP.MSG.BL.Template',MethodName:'Save'});
				
				$.m(data,function(ret){
					if (ret>0) {
						$.messager.popover({msg:'保存成功',type:'success'});
						$('#win').dialog('close');
						$('#list').datagrid('reload');
					}else{
						$.messager.popover({msg:'保存失败'+ret.split('^')[1]||ret,type:'error'});
					}
				})
			}	
		},{
			text:'取消',
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
				text:'确定',
				handler:function(){
					
					var editindex=$('#bv-table').data('editindex');
					if (editindex>-1) $('#bv-table').datagrid('endEdit',editindex);
					var rows=$('#bv-table').datagrid('getRows');
					var myrows=$.grep(rows,function(itm){return !!itm.key})
					//保存
					var tmplid=$('#bv-table').data('edittmplid')
					$m({ClassName:'CT.BSP.MSG.BL.Template',MethodName:'SaveBizVariables',Id:tmplid,BizVariables:JSON.stringify(myrows)},function(ret){
						if(ret>0) {
							$.messager.popover({msg:'保存成功',type:'success'});
							$('#bv-win').dialog('close');
							$('#bv-table').data('editindex','-1');
							$('#list').datagrid('reload');
							
						}else{
							$.messager.popover({msg:'保存失败'+ret.split('^')[1]||ret,type:'error'});
						}
					})
					
					
					
				}	
			},{
				text:'关闭',
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
				{field:'key',title:'变量',width:150,editor:'text'},
				{field:'desc',title:'变量名称',width:150,editor:'text'},
				{field:'note',title:'说明',width:200,editor:'text'}
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
					if( index==$(this).datagrid('getRows').length-1){  //只要点击最后一行 就新增一行
						$(this).datagrid('appendRow',{key:'',desc:'',custom:true,note:''});
					}
					$(this).datagrid('beginEdit', index);
					editindex=index;
				}
				$(this).data('editindex',editindex)
			},
			onAfterEdit:function(index,rowData){
				if( index==$(this).datagrid('getRows').length-1){  //最后一行
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
		
		$('#bv-win').dialog('open').dialog('setTitle','其它模板变量-'+row.TDesc);
		jsonArr.push({key:'',desc:'',note:''})
		$('#bv-table').datagrid('loadData',jsonArr);
		
		$('#bv-table').data('edittmplid',row.TId);
		
	}else{
		$.messager.popover({msg:'当前行不正确',type:'error'});
	}
	
}


$(init);