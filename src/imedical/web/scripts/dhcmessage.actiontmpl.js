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
		columns:[[{field:'TCode',title:'ģ�����',width:150},{field:'TDesc',title:'ģ������',width:150},{field:'TTemplate',title:'ģ������',width:350,formatter:function(val,row,ind){
				return GV.escapeHTML(val);
		}}]],
		pagination:true
		,onSelect:function(ind,row){
			$('#TTmplContent').val(row.TTemplate);
		}
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
				data.ActionCode=GV.pActionCode;
				
				$.extend(data,{ClassName:'CT.BSP.MSG.BL.ActionTypeTmpl',MethodName:'Save'});
				
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
		
		easyModal('ģ��ά��','dhcmessage.template.csp','96%','96%',function(){
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
	    	{field:'TActionCode',title:'��Ϣ��������',width:80,hidden:true},
	    	{field:'TActionDesc',title:'��Ϣ��������',width:120,hidden:true},
	    	{field:'TSendModeDesc',title:'���ͷ�ʽ',width:100,align:'left'},
	    	{field:'TTmplCode',title:'ģ�����',width:150,align:'left'},
	    	{field:'TTmplDesc',title:'ģ������',width:150,align:'left'},
	    	{field:'TTmplContent',title:'ģ������',width:500,align:'left',formatter:function(val,row,ind){
				return GV.escapeHTML(val);
			}}
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
			id:'tb-remove',
			iconCls:'icon-remove',
			text:'ɾ��',
			handler:function(){
				var row=$('#list').datagrid('getSelected');
				if(row && row.TId) {
					$.messager.confirm('��ʾ','ȷ��ɾ��������¼ô��',function(r){
						if(r){
							$.m({ClassName:'CT.BSP.MSG.BL.ActionTypeTmpl',MethodName:'Delete',Id:row.TId},function(ret){
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
			
		}
	})

}






$(init);