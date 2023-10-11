if(typeof GV=='undefined') var GV={};



function initEidtWin(){
	GV.escapeHTML= function(sHtml) {
            return sHtml.replace(/[<>&"]/g,function(c){return {'<':'&lt;','>':'&gt;','&':'&amp;','"':'&quot;'}[c];});
    };
	GV.arr=[
		'TId'
		,{id:'TSendMode',type:'combobox',multiple:true}
		
		,{id:'TTmplCode',type:'combogrid',text:'TTmplDesc'}
		
		,'TTmplContent'
	]
	
	GV.SendModeJson=$.cm({ClassName:'websys.DHCMessageActionTypeMgr',MethodName:'OutSendModeJSON'},false)
	$('#TSendMode').combobox({
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		required:true,
		data:GV.SendModeJson
	})
	$('#TTmplCode').combogrid({
		panelWidth:650,
		delay: 500,
		mode: 'remote',
		url:$URL,
		queryParams:{ClassName: 'CT.BSP.MSG.BL.Template',QueryName: 'Find'},
		onBeforeLoad:function(param){
			param.q=param.q;
			return true;
		},
		idField:"TCode",textField:"TDesc",
		columns:[[{field:'TCode',title:'模板代码',width:150},{field:'TDesc',title:'模板名称',width:150},{field:'TTemplate',title:'模板内容',width:350,formatter:function(val,row,ind){
				return GV.escapeHTML(val);
		}}]],
		pagination:true
		,onSelect:function(ind,row){
			$('#TTmplContent').val(row.TTemplate);
		}
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
				data.ActionCode=GV.pActionCode;
				
				$.extend(data,{ClassName:'CT.BSP.MSG.BL.ActionTypeTmpl',MethodName:'Save'});
				
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
			common.setData(GV.arr,'',{});
		}
		common.validate(GV.arr);
	}
	GV.getEditVal=function(){
		var data=common.getData(GV.arr,'T');
		var isValid=common.validate(GV.arr);
		data.isValid=isValid;
		return data;
	}
	
	$('#btn-tmpl-mgr').click(function(){
		
		easyModal('模板维护','dhcmessage.template.csp','96%','96%',function(){
			//debugger;
			$('#TTmplCode').combogrid('grid').datagrid('reload');
			
		})	
	})
	
	
}


var init=function(){
	initEidtWin();
	
	
	$('#list').datagrid({
		border:false,
		headerCls:'panel-header-gray',
        pagination: true,
        pageSize:20,
        pageList:[10,15,20,30,50,100,200,1000],
        striped:true,
        singleSelect:true,
        idField:'TId',
        rownumbers:true,
        url:$URL,
        queryParams:{
	        ClassName:'CT.BSP.MSG.BL.ActionTypeTmpl',
	        QueryName:'Find',
	        pActionCode:GV.pActionCode
	    },
	    fit:true,
	    fitColumns:false,
	    nowrap:false,
	    //TId,TActionCode,TSendMode,TTmplCode,TActionDesc,TSendModeDesc,TTmplDesc,TTmplContent"
	    columns:[[
	    	{field:'TActionCode',title:'消息动作代码',width:80,hidden:true},
	    	{field:'TActionDesc',title:'消息动作描述',width:120,hidden:true},
	    	{field:'TSendModeDesc',title:'发送方式',width:100,align:'left'},
	    	{field:'TTmplCode',title:'模板代码',width:150,align:'left'},
	    	{field:'TTmplDesc',title:'模板名称',width:150,align:'left'},
	    	{field:'TTmplContent',title:'模板内容',width:500,align:'left',formatter:function(val,row,ind){
				return GV.escapeHTML(val);
			}}
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
			id:'tb-remove',
			iconCls:'icon-remove',
			text:'删除',
			handler:function(){
				var row=$('#list').datagrid('getSelected');
				if(row && row.TId) {
					$.messager.confirm('提示','确认删除此条记录么？',function(r){
						if(r){
							$.m({ClassName:'CT.BSP.MSG.BL.ActionTypeTmpl',MethodName:'Delete',Id:row.TId},function(ret){
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
			
		}
	})

}






$(init);