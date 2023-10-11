;(function ($) {
	$.fn.combogrid.methods.setRemoteValue=function (jq,param) {
    	return jq.each(function(){
	    	if (typeof param=="string"){
		    	$(this).combogrid('setValue',param);
		    }else{
			    var val=param['value']||'';
			    var text=param['text']||'';
			    $(this).combogrid('options').keyHandler.query.call(this,text);
				$(this).combogrid('setValue',val).combogrid('setText',text);
			}
	    })
    }
})(jQuery);
if (typeof GV=='undefined') {
	var GV={};	
}


var initEditWin=function(){
	$('#cfg_edit_win').dialog({
		buttons:[{
			text:'保存',
			handler:function(){
				GV.save();
			}
		},{
			text:'关闭',
			handler:function(){
				$('#cfg_edit_win').dialog('close');
			}
		}],
		width:400,
		iconCls:'icon-w-paper'
		,modal:true
		
	})
	
	$('#SrcRefType').combobox({
		data:[],
		panelHeight:'auto',
		width:200,
		onSelect:function(row){
			//console.log('src',row);
			$('#cSrcRefObjId').text(row.label||'源对象');
			var defParams={rectype:row.value};
			if(row.params){
				var arr=row.params.split('&');
				for(var i=0;i<arr.length;i++){
					var itemArr=arr[i].split('=');
					var key=itemArr[0],value=itemArr[1]||'';
					defParams[key]=value;
				}	
				
			}
			GV.srcDefParams=defParams;
			$('#SrcRefObjId').combogrid('setRemoteValue',{value:'',text:''});
		}
	})
	$('#LinkRefType').combobox({
		data:[],
		panelHeight:'auto',
		width:200,
		onSelect:function(row){
			//console.log('link',row);
			$('#cLinkRefObjId').text(row.label||'关联对象');
			var defParams={rectype:row.value};
			if(row.params){
				var arr=row.params.split('&');
				for(var i=0;i<arr.length;i++){
					var itemArr=arr[i].split('=');
					var key=itemArr[0],value=itemArr[1]||'';
					defParams[key]=value;
				}
				
			}
			GV.linkDefParams=defParams;
			
			$('#LinkRefObjId').combogrid('setRemoteValue',{value:'',text:''});
			
		}	
	})
	

	$('#SrcRefObjId').combogrid({
		panelWidth:450,
		width:200,
		delay: 500,
		mode: 'remote',
		url:$URL+"?ClassName=websys.DHCMessageReceiveCfgMgr&QueryName=FindReceiveObj",
		onBeforeLoad:function(param){
			param.desc=param.q;
			var defParams=GV.srcDefParams||{}
			$.extend(param,defParams);
			return true;
		},
		idField:"ID",textField:"Desc",
		columns:[[{field:'Desc',title:'名称',width:200},{field:'Code',title:'代码',width:200}]],
		pagination:true
	})
	
	$('#LinkRefObjId').combogrid({
		panelWidth:450,
		width:200,
		delay: 500,
		mode: 'remote',
		url:$URL+"?ClassName=websys.DHCMessageReceiveCfgMgr&QueryName=FindReceiveObj",
		onBeforeLoad:function(param){
			param.desc=param.q;
			var defParams=GV.linkDefParams||{}
			$.extend(param,defParams);
			return true;
		},
		idField:"ID",textField:"Desc",
		columns:[[{field:'Desc',title:'名称',width:200},{field:'Code',title:'代码',width:200}]],
		pagination:true
	})

	
	GV.setEditVal=function(row){
		if (row){
			$('#Id').val(row.TId);
			$('#SrcRefType').combobox('setValue',row.TSrcRefType)
			$('#SrcRefType').combobox('options').onSelect.call($('#SrcRefType')[0],$.hisui.getArrayItem(GV.cfg.srcRefType,'value',row.TSrcRefType));
			$('#SrcRefObjId').combogrid('setRemoteValue',{value:row.TSrcRefObjId,text:row.TSrcRefObjDesc});
			
			$('#LinkRefType').combobox('setValue',row.TLinkRefType)
			$('#LinkRefType').combobox('options').onSelect.call($('#LinkRefType')[0],$.hisui.getArrayItem(GV.cfg.linkRefType,'value',row.TLinkRefType));

			$('#LinkRefObjId').combogrid('setRemoteValue',{value:row.TLinkRefObjId,text:row.TLinkRefObjDesc});

		}else{
			$('#Id').val('');
			if(GV.cfg){ 
				$('#SrcRefType').combobox('select',GV.cfg.srcRefType[0].value);
				$('#SrcRefType').combobox('options').onSelect.call($('#SrcRefType')[0],GV.cfg.srcRefType[0]);
			}else{
				$('#SrcRefType').combobox('setValue','')
			}
			
			$('#SrcRefObjId').combogrid('setRemoteValue',{value:'',text:''});
			
			if (GV.cfg) {
				$('#LinkRefType').combobox('setValue',GV.cfg.linkRefType[0].value);
				$('#LinkRefType').combobox('options').onSelect.call($('#LinkRefType')[0],GV.cfg.linkRefType[0]);
			}else{
				$('#LinkRefType').combobox('setValue','')
			}
			
			$('#LinkRefObjId').combogrid('setRemoteValue',{value:'',text:''});
			
		}
	}
	GV.save=function(){
		if(!GV.cfg || !GV.cfg.linkKey) {
			$.messager.popover({msg:'请选择左侧基础数据关联类型',type:'error'})	;
			return;
		}
		var data={ClassName:"CT.BSP.MSG.BL.BaseDataLink",MethodName:'Save'};
		data.Id=$('#Id').val();
		data.SrcRefType=$('#SrcRefType').combobox('getValue');
		data.SrcRefObjId=$('#SrcRefObjId').combogrid('getValue');
		data.LinkRefType=$('#LinkRefType').combobox('getValue');
		data.LinkRefObjId=$('#LinkRefObjId').combogrid('getValue');
		data.LinkKey=GV.cfg.linkKey;
		
		if(!data.SrcRefType) {
			$.messager.popover({msg:'请选择'+$('#cSrcRefType').text(),type:'alert'})	;
			return;
		}
		if(!data.SrcRefObjId) {
			$.messager.popover({msg:'请选择'+$('#cSrcRefObjId').text(),type:'alert'})	;
			return;
		}
		if(!data.LinkRefType) {
			$.messager.popover({msg:'请选择'+$('#cLinkRefType').text(),type:'alert'})	;
			return;
		}
		if(!data.LinkRefObjId) {
			$.messager.popover({msg:'请选择'+$('#cLinkRefObjId').text(),type:'alert'})	;
			return;
		}
		$.m(data,function(rtn){	
			if (rtn>0){
				$.messager.popover({msg:'保存成功',type:'success'});
				$('#cfg_edit_win').dialog('close');
				$('#cfg_list').datagrid('reload');
			}else{
				$.messager.alert("失败","保存失败<br>"+rtn.split("^")[1]||rtn,'error')	
			}
		})
	}
	
	GV.refreshRight=function(cfg){
		GV.cfg=cfg;
		if(cfg){
			$('#cSrcRefType').text(cfg.srcRefTypeLabel||'源对象类型');
			$('#SrcRefType').combobox('loadData',cfg.srcRefType);

			
			$('#cLinkRefType').text(cfg.LinkRefTypeLabel||'关联对象类型');
			$('#LinkRefType').combobox('loadData',cfg.linkRefType);
			
			if(cfg.srcRefType.length>1){
				$('#tr-SrcRefType').show();
			}else{
				$('#tr-SrcRefType').hide();
			}
			
			if(cfg.linkRefType.length>1){
				$('#tr-LinkRefType').show();
			}else{
				$('#tr-LinkRefType').hide();
			}
			
			
			
			$('#cfg_list').datagrid({
				columns:[cfg.columns||GV.defColumns]	
				
			})
			$('#cfg_list').datagrid('load',{LinkKey:cfg.linkKey});
			$('#cfg_list').datagrid('getPanel').panel('setTitle',cfg.linkName);
			
			$('#tip').text($g(cfg.linkNote));
			
			$('#search').searchbox('setValue','');
			
		}else{
			$('#cSrcRefType').text('源对象类型');
			$('#SrcRefType').combobox('loadData',[]);
			
			$('#cLinkRefType').text('关联对象类型');
			$('#LinkRefType').combobox('loadData',[]);
			

			$('#cfg_list').datagrid({
				columns:[GV.defColumns]	
				
			})
			$('#cfg_list').datagrid('load',{LinkKey:''})
			$('#cfg_list').datagrid('getPanel').panel('setTitle','基础数据关联');
			
			$('#tip').text($g('请选择左侧关联类型'));
			
			$('#search').searchbox('setValue','');
		}
		

	}
	
}

var initRight=function(){

	
	
	
	initEditWin();
	
	GV.defColumns=[
			{field:"TSrcRefTypeDesc",title:"源对象类型",width:100},
			{field:"TSrcRefObjDesc",title:"源对象",width:100},
			{field:"TLinkRefTypeDesc",title:"关联对象类型",width:100},
			{field:"TLinkRefObjDesc",title:"关联对象",width:100}
	];
	
	
	$('#cfg_list').datagrid({
		headerCls:'panel-header-gray',
		title:'基础数据关联',
		iconCls:'icon-paper',
		url:$URL+"?ClassName=CT.BSP.MSG.BL.BaseDataLink&QueryName=Find",
		fitColumns:true,
		fit:true,
		//TId,LinkKey,TSrcRefType,TSrcRefTypeDesc,TSrcRefObjId,TSrcRefObjDesc,TLinkRefType,TLinkRefTypeDesc,TLinkRefObjId,TLinkRefObjDesc
		columns:[GV.defColumns],
		pagination:true,
		pageSize:20,
		pageList:[20,50,100],
		rownumbers:true,
		striped:true,
		singleSelect:true,
		onLoadSuccess:function(){
			$('#cfg_list').datagrid('clearSelections');
			$('#cfg_list_tb_edit,#cfg_list_tb_remove').linkbutton('disable');
			if(GV.cfg) {
				$('#cfg_list_tb_add').linkbutton('enable');
			}else{
				$('#cfg_list_tb_add').linkbutton('disable');
			}
		},
		onSelect:function(){
			$('#cfg_list_tb_edit,#cfg_list_tb_remove').linkbutton('enable');
		},
		toolbar:'#cfg_list_tb'
		,lazy:true
	})	
	$('#cfg_list_tb_remove').click(function(){
		var row=$('#cfg_list').datagrid('getSelected')
		if (!row) {
			$.messager.alert("提示","请选择行")	;
			return ;
		}
		$.messager.confirm("确定","确定删除此条配置记录吗？",function(r){
			if(r){
				var data={ClassName:"CT.BSP.MSG.BL.BaseDataLink",MethodName:'Delete'};
				data.Id=row.TId;
				$.m(data,function(rtn){
					if (rtn>0){
						$.messager.popover({msg:'删除成功',type:'success'});
						$('#cfg_list').datagrid('reload');
					}else{
						$.messager.alert("失败","删除失败<br>"+rtn.split("^")[1]||rtn,'error')	
					}
				})
			}
		})
	})
	$('#cfg_list_tb_edit').click(function(){
		var row=$('#cfg_list').datagrid('getSelected')
		if (!row) {
			$.messager.alert("提示","请选择行")	;
			return ;
		}
		GV.setEditVal(row);
		$('#cfg_edit_win').dialog('open').dialog('setTitle','修改');
	})
	$('#cfg_list_tb_add').click(function(){
		GV.setEditVal();
		$('#cfg_edit_win').dialog('open').dialog('setTitle','新增');	
		
	})
	$('#search').searchbox({
		searcher:function(val){
			if(GV.cfg) {
				$('#cfg_list').datagrid('load',{q:val,LinkKey:GV.cfg.linkKey})
			}else{
				$('#cfg_list').datagrid('load',{});
				$.messager.popover({msg:'请先选择左侧关联类型',type:'info'})
			}
			
			
		},prompt:'查询条件'	
	})
	
	
}

var initLeft=function(){
	
	
	if ($('#linkKeyList').length>0) {
		var rows=[]
		$.each(GV.linkKeyData,function(){
			if(!this.hidden) {
				rows.push({
					linkKey:this.linkKey,
					linkName:this.linkName,
					linkNote:this.linkNote
				})	
			}
			
		})
		$('#linkKeyList').datagrid({
			headerCls:'panel-header-gray',
			title:'基础数据关联类型',
			iconCls:'icon-paper',
			fitColumns:true,
			fit:true,
			columns:[[
				{field:"linkKey",title:"类型代码",width:100},
				{field:"linkName",title:"类型名称",width:100}
			]],
			pagination:true,
			pageSize:100,
			pageList:[100],
			rownumbers:true,
			striped:true,
			singleSelect:true,
			onSelect:function(ind,row){
				GV.selectLinkKey(row.linkKey);
			},
			data:rows,
			toolbar:[]
		})
		
	}
	
}


$(function(){
	GV.linkKeyData=[
		{
			linkKey:'TEST',
			linkName:'测试',
			linkNote:'用于复制使用',
			srcRefType:[
				{value:'L',text:'科室',params:'admType=O',label:'门诊科室'}
			],
			srcRefTypeLabel:'源对象类型',

			linkRefType:[
				{value:'L',text:'科室',params:'admType=I',label:'住院科室'}
				,{value:'G',text:'安全组',params:'',label:'安全组'}
			],
			linkRefTypeLabel:'关联对象类型',
			columns:[
				{field:'TSrcRefObjDesc',title:'门诊科室',width:160},
				{field:'TLinkTypeDesc',title:'关联对象类型',width:160},
				{field:'TLinkRefObjDesc',title:'关联对象',width:160},
			]
			,hidden:true
		},
		{
			linkKey:'OpIpLocLink',
			linkName:'门诊住院科室关联',
			linkNote:'适用危急值等在下班时间将消息发送给关联的住院科室',
				srcRefType:[
				{value:'L',text:'科室',params:'admType=O',label:'门诊科室'}
			],
			srcRefTypeLabel:'源对象类型',

			linkRefType:[
				{value:'L',text:'科室',params:'admType=I',label:'住院科室'}
			],
			linkRefTypeLabel:'关联对象类型',
			columns:[
				{field:'TSrcRefObjDesc',title:'门诊科室',width:160},
				{field:'TLinkRefObjDesc',title:'住院科室',width:160},
			]
			,hidden:false

		},{
			linkKey:'OpWardLocLink',
			linkName:'门诊科室与病区关联',
			linkNote:'适用危急值等在下班时间将消息发送给关联的病区科室',
			srcRefType:[
				{value:'L',text:'科室',params:'admType=O',label:'门诊科室'}
			],
			srcRefTypeLabel:'源对象类型',

			linkRefType:[
				{value:'L',text:'病区',params:'locType=W',label:'病区'}
			],
			linkRefTypeLabel:'关联对象类型',
			columns:[
				{field:'TSrcRefObjDesc',title:'门诊科室',width:160},
				{field:'TLinkRefObjDesc',title:'病区',width:160},
			]
			,hidden:false
		}
	]
	
	initLeft();
	initRight();
	
	
	GV.selectLinkKey=function(linkKey){
		var cfg;
		$.each(GV.linkKeyData,function(){
			if(this.linkKey==linkKey){
				cfg=this
				return false;	
			}
		})
		
		GV.refreshRight(cfg);
		
		if (linkKey && !cfg) {
				
			$('#tip').text($g('参数linkKey='+linkKey+'不正确'));
		}
		
	}
	
	if(GV.linkKey) {
		GV.selectLinkKey(GV.linkKey);
		
	}
	
})



