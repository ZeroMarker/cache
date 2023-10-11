/*
* 国际化（多语言）公共方法
* 
* i18n_start_basedata_trans(clsName,data)
*/
(function(){
	var _GLOBAL={}
	
	/*
	* 开始基础数据翻译 弹出数据翻译框
	* clsName 类名
	* data 字段名  {LocDesc:"名字",LocAlias:["简称1","简称2"]}
	* 
	*/
	var start_basedata_trans=function(clsName,data){
		if(!clsName) {
			return $.messager.popover({msg:'类名为空',type:'alert'});
		}
		if(!data || typeof data!='object') {
			return $.messager.popover({msg:'要翻译的数据不正确',type:'alert'});
		}
		
		
		var props=[];
		for (var i in data) {
			if (data[i]) {
				props.push(i);	
			}
		}
		if(props.length==0) {
			return $.messager.popover({msg:'翻译数据为空',type:'alert'});
		}
		
		
		checkClsProp(clsName,props,function(succ,msg){
			if(succ){
				var rows=[]
				for (var i in data) {      //{LocDesc:"名字",LocAlias:["简称1","简称2"]}
					if (data[i]) {
						if(typeof data[i]=='string') {	
							rows.push({prop:i,src:data[i]})	
						}else if (typeof data[i]=='object' && data[i] instanceof Array) {
							$.each(data[i],function(){
								rows.push({prop:i,src:this})	
							})
							
						}
					}
				}
				 
				render_basedata_transwin(msg,rows)
				
				
				
				
			}else{
				
				 $.messager.popover({msg:msg,type:'alert'});
			}
			
		})
		
		
	}
	
	function render_basedata_transwin(propInfo,searchRows){
		_GLOBAL.propInfo=propInfo;
		_GLOBAL.searchRows=searchRows;
		
		if($('#bsp_sys_i18n_basedata_trans_win').length==0) {
			
			$('<div id="bsp_sys_i18n_basedata_trans_win" class="hisui-dialog"> \
				<div class="hisui-layout" data-options="fit:true"> \
					<div data-options="region:\'north\',border:false" style="height:50px;padding:5px 10px;overflow:hidden;"> \
						<table cellspacing="0" cellpadding="0" border="0"> \
						<tr style="height:40px;"><td class="r-label">语言</td><td><input id="bsp_sys_i18n_basedata_trans_langId" class="textbox" /></td></tr>\
						</table>\
					</div>\
					<div data-options="region:\'center\',border:false" style="padding:0 10px 0px 10px;"> \
						<table id="bsp_sys_i18n_basedata_trans_table"></table> \
					</div> \
				</div> \
			</div>').appendTo('body');
			
			
			$('#bsp_sys_i18n_basedata_trans_win').dialog({
				iconCls:'icon-w-paper',
				title:'翻译',
				width:700,
				height:600,
				modal:true,
				buttons:[{
					text:'保存',
					handler:function(){
						
						if (_GLOBAL.editingIndex>-1) {
							$('#bsp_sys_i18n_basedata_trans_table').datagrid('endEdit',_GLOBAL.editingIndex)
							_GLOBAL.editingIndex=-1;
						}
						
						var changedRows=getTransChanged();
						//console.log(changedRows);
						
						if( changedRows.length>0 ) {
							
							
							$.messager.confirm('确定','确定保存已修改的翻译数据',function(r){
								if(r) {
									saveTransChanged(changedRows,function(succ,msg){
										if(succ){
											$.messager.popover({msg:'保存成功',type:'success'})	;
											$('#bsp_sys_i18n_basedata_trans_win').dialog('close');
										}else{
											$.messager.popover({msg:'保存失败：'+msg,type:'error'})	;
										}
									})	
									
								}	
								
							})
							
						}else{
							
							$.messager.popover({msg:'没有修改的数据',type:'alert'});
							
						}
						
						
						
					}	
				},{
					text:'关闭',
					handler:function(){
						$('#bsp_sys_i18n_basedata_trans_win').dialog('close');
						
					}	
				}]	
				,onClose:function(){
					$('#bsp_sys_i18n_basedata_trans_langId').combobox('setValue','')	
				}
			})
			
			$('#bsp_sys_i18n_basedata_trans_win').find('.hisui-layout').layout({})
			
			$('#bsp_sys_i18n_basedata_trans_langId').combobox({
				width:300,
				url:$URL+'?ClassName=web.SSLanguage&QueryName=LookUp&desc=&ResultSetType=Array&rows=9999',
				valueField:'HIDDEN',
				textField:'Description',
				onChange:function(nv,ov){
					//console.log(nv)	;
					
					$('#bsp_sys_i18n_basedata_trans_table').datagrid('load',{
						clsName:_GLOBAL.propInfo._className,
						langId:nv,
						json:JSON.stringify(_GLOBAL.searchRows)
					})

				},
				selectOnNavigation:false,
				onLoadSuccess:function(){
					$('#bsp_sys_i18n_basedata_trans_langId').combobox('setValue','1')
				},
				onShowPanel:function(){
					
					if(_GLOBAL.ingoreShowPanelEvent){
						_GLOBAL.ingoreShowPanelEvent=false;
						return;	
					}
					
					if (_GLOBAL.editingIndex>-1) {
						$('#bsp_sys_i18n_basedata_trans_table').datagrid('endEdit',_GLOBAL.editingIndex)
						_GLOBAL.editingIndex=-1;
					}
						
					var changedRows=getTransChanged();
					if( changedRows.length>0 ) {
						$('#bsp_sys_i18n_basedata_trans_langId').combobox('hidePanel');
						
						$.messager.confirm('确定','是否保存已修改的翻译数据',function(r){
							if(r) {
								saveTransChanged(changedRows,function(succ,msg){
									if(succ){
										$.messager.popover({msg:'保存成功',type:'success'})	;
										
										refreshTransChanged();
										$('#bsp_sys_i18n_basedata_trans_table').datagrid('reload');
										
										$('#bsp_sys_i18n_basedata_trans_langId').combobox('showPanel');
										
									}else{
										$.messager.popover({msg:'保存失败：'+msg,type:'error'})	;
										
									}
								})	
								
							}else{
								_GLOBAL.ingoreShowPanelEvent=true;
								$('#bsp_sys_i18n_basedata_trans_langId').combobox('showPanel');
							}
							
						})
						
					}
				}
			})
			
			$('#bsp_sys_i18n_basedata_trans_table').datagrid({
				url:$URL+'?ClassName=BSP.IMP.BDP.Interface&QueryName=QryBDTransByJson',
				bodyCls:'panel-header-gray',	
				columns:[[
					{field:'prop',title:'字段名',formatter:function(val,row,ind){
						return val+'('+_GLOBAL.propInfo[val]+')'
					},width:150},
					{field:'src',title:'翻译前',width:200},
					{field:'trans',title:'翻译后',width:200,editor:'text'},
				]],
				pagination:true,
				pageSize:100,
				pageList:[100],
				lazy:true
				,fit:true
				,fitColumns:true
				,rownumbers:true
				,singleSelect:true
				,onDblClickCell:function(ind,field,value){
					if(field=='trans') {
						if (_GLOBAL.editingIndex>-1) {
							//endEdit
							$('#bsp_sys_i18n_basedata_trans_table').datagrid('endEdit',_GLOBAL.editingIndex)
							_GLOBAL.editingIndex=-1;
						}
						
						$('#bsp_sys_i18n_basedata_trans_table').datagrid('beginEdit',ind);
						_GLOBAL.editingIndex=ind;
						
					}
				}
				,onLoadSuccess:function(data){
					$.each(data.rows,function(){
						this.oldTrans=this.trans;	
					})	
					if (_GLOBAL.editingIndex>-1) {
						$('#bsp_sys_i18n_basedata_trans_table').datagrid('endEdit',_GLOBAL.editingIndex)
						_GLOBAL.editingIndex=-1;
					}
				}
			})
			
			
		}else{
			$('#bsp_sys_i18n_basedata_trans_langId').combobox('setValue','1')
		}
		
		
		$('#bsp_sys_i18n_basedata_trans_win').dialog('open');
		$('#bsp_sys_i18n_basedata_trans_win').dialog('setTitle','翻译 ',propInfo._className+'('+propInfo._classDesc+')');
		
		function getTransChanged(){
			var rows=$('#bsp_sys_i18n_basedata_trans_table').datagrid('getRows');
			var changeArr=[];
			$.each(rows,function(){
				if(this.oldTrans!=this.trans){
					changeArr.push({prop:this.prop,src:this.src,trans:this.trans})	
				}	
			})
			
			return changeArr;
		}
		function saveTransChanged(changeRows,callback){
			var queryParams=$('#bsp_sys_i18n_basedata_trans_table').datagrid('options').queryParams;
			var langId=queryParams.langId;
			var clsName=queryParams.clsName;
			$.m({ClassName:'BSP.IMP.BDP.Interface',MethodName:'SaveBDTransByJson',
					clsName:clsName,
					langId:langId,
					json:JSON.stringify(changeRows)
			},function(ret){
				if(ret>0) {
					callback(true)	
				}else{
					callback(false,ret.split('^')[1]||ret)		
				}
			})
					
			
		}
		
		function refreshTransChanged(){
			var rows=$('#bsp_sys_i18n_basedata_trans_table').datagrid('getRows');
			var changeArr=[];
			$.each(rows,function(){
				if(this.oldTrans!=this.trans){
					this.oldTrans=this.trans;
				}	
			})
		}
		
		
	}
	
	
	
	/// 校验表字段 
	var checkClsProp=function(clsName,props,callback){
		$.m({ClassName:'BSP.IMP.BDP.Interface',MethodName:'CheckBDTransProps',clsName:clsName,props:props.join(',')},function(ret){
			
			if (ret.slice(0,2)=='1^') { //成功
				var data=$.parseJSON(ret.slice(2, ret.length ))
				if(typeof callback=='function') callback(true,data)
			}else{
				if(typeof callback=='function') callback(false,ret.split('-1^')[1]||ret);
			}
			
		})
		
		
	}
	
	/*
	* 开始基础数据翻译 弹出数据翻译框
	* clsName 类名
	* data 字段名  {LocDesc:"名字",LocAlias:["简称1","简称2"]}
	* 
	*/
	window.i18n_start_basedata_trans=start_basedata_trans;
	
	
})();