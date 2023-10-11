var initTree=function(){
	///增加分类
	GV.mm_addCatgory=function(){
		var node=$('#left_tree').tree('getSelected');
		var arr=node.id.split("-");
		var refType=arr[0]||'',
			refObjId=arr[1]||'';
		
		
		$('#CatgoryId').val('');
		$('#CatgoryRefType').val(refType);
		$('#CatgoryRefObjId').val(refObjId);
		$('#CatgoryTitle').val('');
		$('#CatgorySummary').val('');
		$('#catgory_win').dialog('open').dialog('setTitle','增加分类');
	}
	///增加模板
	GV.mm_addContent=function(){
		var node=$('#left_tree').tree('getSelected');
		var arr=node.id.split("-");
		var refType=arr[0]||'',
			refObjId=arr[1]||'',
			catid=arr[2]||'';
		$('#ContentId').val('');
		$('#ContentRefType').val(refType);
		$('#ContentRefObjId').val(refObjId);
		$('#ContentCatgory').val(catid);
		$('#ContentTitle').val('');
		$('#ContentSummary').val('');
		
		$('#content_win').dialog('open').dialog('setTitle','增加模板');
	}
	///修改
	GV.mm_edit=function(){
		var node=$('#left_tree').tree('getSelected');
		var arr=node.id.split("-");
		if(arr.length==3) {
			var refType=arr[0]||'',
				refObjId=arr[1]||'',
				catid=arr[2]||'';
			
			$('#CatgoryId').val(catid);
			$('#CatgoryRefType').val(refType);
			$('#CatgoryRefObjId').val(refObjId);
			$('#CatgoryTitle').val(node.text);
			$('#CatgorySummary').val(node.attributes.summary);
			
			$('#catgory_win').dialog('open').dialog('setTitle','修改分类');

			
		}else if(arr.length==4){
			var refType=arr[0]||'',
				refObjId=arr[1]||'',
				catid=arr[2]||'',
				contentid=arr[3]||'';
			$('#ContentId').val(contentid);
			$('#ContentRefType').val(refType);
			$('#ContentRefObjId').val(refObjId);
			$('#ContentCatgory').val(catid);
			$('#ContentTitle').val(node.text);
			$('#ContentSummary').val(node.attributes.summary);
			
			$('#content_win').dialog('open').dialog('setTitle','修改模板');
			
		}
	}
	///删除
	GV.mm_delete=function(){
		var node=$('#left_tree').tree('getSelected');
		var arr=node.id.split("-");
		
		var data={ClassName:"CT.BSP.MSG.BL.ContentTemplate"};
		var msg='';
		if(arr.length==3) {
			msg='确认删除此分类吗，此操作会删除其下所有模板！';
			data.MethodName='DeleteCatgory';
			data.Catgory=arr[2];
		}else if(arr.length==4){
			msg='确认删除此模板吗';
			data.MethodName='Delete';
			data.Id=arr[3];
		}
		
		$.messager.confirm('确认',msg,function(r){
			if(r){
				$.m(data,function(rtn){
					console.log(rtn)	
					if (rtn>0){
						$.messager.alert("成功","删除成功",'success',function(){
							var pnode=$('#left_tree').tree('getParent',node.target);
							$('#left_tree').tree('reload',pnode.target);
						});

						
					}else{
						$.messager.popover({msg:'失败：'+(rtn.split("^")[1]||rtn),type:'error'});
						
					}
				})
			}	
		})
		
		
	}
	
	$('#catgory_win').dialog({
		title:'分类',
		iconCls:'icon-w-paper',
		buttons:[{
			text:'保存',
			handler:function(){
				var node=$('#left_tree').tree('getSelected');
				var data={ClassName:"CT.BSP.MSG.BL.ContentTemplate"};
				data.Title=$('#CatgoryTitle').val();
				data.Summary=$('#CatgorySummary').val();
				if ($.trim(data.Title)==''){
					$.messager.popover({msg:'请输入分类标题',type:'alert'});
					return ;
				}
				data.UserId=GV.user;
				var catid=$('#CatgoryId').val();
				if (catid>0) { //修改
					data.MethodName='UpdateTitleAndSummary';
					data.Id=catid
				}else{ //新增
					data.MethodName='AddCatgory'	
					data.RefType=$('#CatgoryRefType').val();
					data.RefObjId=$('#CatgoryRefObjId').val();
					data.Type=GV.type+'C';
				}
				
				$.m(data,function(rtn){
					console.log(rtn)	
					if (rtn>0){
						$.messager.alert("成功","保存成功",'success',function(){
							$('#catgory_win').dialog('close');
							if (node.id.split("-").length==2) {
								$('#left_tree').tree('reload',node.target);}
							else  {
								var pnode=$('#left_tree').tree('getParent',node.target);
								$('#left_tree').tree('reload',pnode.target);
							}
							
						});

						
					}else{
						$.messager.popover({msg:'失败：'+(rtn.split("^")[1]||rtn),type:'error'});
						
					}
				})
			}
		},{
			text:'关闭',
			handler:function(){
				$('#catgory_win').dialog('close');
			}
		}]
	})
	
	$('#content_win').dialog({
		title:'模板',
		iconCls:'icon-w-paper',
		buttons:[{
			text:'保存',
			handler:function(){
				var node=$('#left_tree').tree('getSelected');
				var data={ClassName:"CT.BSP.MSG.BL.ContentTemplate"};
				data.Title=$('#ContentTitle').val();
				data.Summary=$('#ContentSummary').val();
				if ($.trim(data.Title)==''){
					$.messager.popover({msg:'请输入模板标题',type:'alert'});
					return ;
				}
				data.UserId=GV.user;
				var contentid=$('#ContentId').val();
				if (contentid>0) { //修改
					data.MethodName='UpdateTitleAndSummary';
					data.Id=contentid
				}else{ //新增
					data.MethodName='AddContent'	
					data.RefType=$('#ContentRefType').val();
					data.RefObjId=$('#ContentRefObjId').val();
					data.Catgory=$('#ContentCatgory').val();
					data.Type=GV.type;
				}
				
				$.m(data,function(rtn){
					console.log(rtn)	
					if (rtn>0){
						$.messager.alert("成功","保存成功",'success',function(){
							$('#content_win').dialog('close');
							if (node.id.split("-").length==3) {
								$('#left_tree').tree('reload',node.target);}
							else  {
								var pnode=$('#left_tree').tree('getParent',node.target);
								$('#left_tree').tree('reload',pnode.target);
							}
							
						});

						
					}else{
						$.messager.popover({msg:'失败：'+(rtn.split("^")[1]||rtn),type:'error'});
						
					}
				})
			}
		},{
			text:'关闭',
			handler:function(){
				$('#content_win').dialog('close');
			}
		}]
	})
	

	
	var setOpBtnStatus=function(btnKey,status){
		var disabled=!(status=='enable');
		var menuSelector='#mm_'+btnKey;
		$('#left_tree_mm').menu(disabled?'disableItem':'enableItem',$(menuSelector)[0]);
		var tbSelector='#tb_mm_'+btnKey;
		$(tbSelector).linkbutton(disabled?'disable':'enable');
	}
	var treeurl=$URL+"?ClassName=CT.BSP.MSG.BL.ContentTemplate&MethodName=LazyTree&type="+GV.type+'&isSuper='+GV.isSuper;
				
	$('#left_tree').tree({
		url:treeurl,
		lines:true,
		animate:true,
		onContextMenu: function(e,node){
			e.preventDefault();
			//禁止浏览器的菜单打开
			$(this).tree('select',node.target);
	
			$('#left_tree_mm').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},	
		onClick:function(node){
			return;
			if($(this).tree('isLeaf',node.target)){
				GV.debounce_showOneTimeInfo(node);
			}
		},
		onSelect:function(node){
			var id=node.id;
			var nodelevel=id.split("-").length;
			if (nodelevel==2 ){  //某某用户  某某科室  某某医院层级
				setOpBtnStatus('addCatgory','enable');  //增加分类 启用
				setOpBtnStatus('addContent','disable');  //增加模板 禁用
				setOpBtnStatus('edit','disable');  //修改 禁用
				setOpBtnStatus('delete','disable');  //删除 禁用
				
			}else if( nodelevel==3  ){  //某分类层级
				setOpBtnStatus('addCatgory','enable');  //增加分类 启用
				setOpBtnStatus('addContent','enable');  //增加模板 启用
				setOpBtnStatus('edit','enable');  //修改 启用  修改分类名称
				setOpBtnStatus('delete','enable');  //删除 启用  删除此分类及其下面模板
				
			}else if( nodelevel==4 ){  //某具体模板层级
				setOpBtnStatus('addCatgory','disable');  //增加分类 禁用
				setOpBtnStatus('addContent','enable');  //增加模板 启用
				setOpBtnStatus('edit','enable');  //修改 启用  修改模板名称
				setOpBtnStatus('delete','enable');  //删除 启用 删除此模板
				
			}else{
				setOpBtnStatus('addCatgory','disable');  //增加分类 禁用
				setOpBtnStatus('addContent','disable');  //增加模板 禁用
				setOpBtnStatus('edit','disable');  //修改 禁用  
				setOpBtnStatus('delete','disable');  //删除 禁用 
			}
			
			if(nodelevel==4) {
				
				
				
				
				GV.setEditorValue({
					id:id.split("-")[3],
					title:getTreeNodeFullText('#left_tree',node)
				})
				
				
				
			}else{
				GV.setEditorValue();	
			}
			
			
		},
		onLoadSuccess:function(node,data){
			var sel=$('#left_tree').tree('getSelected');
			if (!sel){
				setOpBtnStatus('addCatgory','disable');  //增加分类 禁用
				setOpBtnStatus('addContent','disable');  //增加模板 禁用
				setOpBtnStatus('edit','disable');  //修改 禁用  
				setOpBtnStatus('delete','disable');  //删除 禁用 
				
				GV.setEditorValue();
			}
			if(node && node.id) {  //树的节点 懒加载下面子节点
				var id=node.id;
				var nodelevel=id.split("-").length;
				if (data.length==0) { //没获取到数据
					var msg='没有数据哦';
					if (nodelevel==2) {
						msg='没有分类数据哦，您可以选择新增';	
					}else if(nodelevel==3){
						msg='没有模板数据哦，你可以选择新增';	
					}
					$.messager.popover({msg:msg,type:'info'});
				}
			}
		}
	});
	$('#left_tree_mm').contextmenu(function(e){
		e.preventDefault();
	});
	
	///获取树某节点完整文本 根节点-2级节点-三级节点-本节点
	function getTreeNodeFullText(sel,node){
		var t=node,arr=[node.text];
		while(true) {
			var pnode=$(sel).tree('getParent',t.target);
			if(pnode) {
				arr.push(pnode.text);
				t=pnode;	
			}else{
				break;	
			}
		}
		return arr.reverse().join('-');
	}
	
}

var initEditor=function(){

	/// 设置右侧编辑区数据
	var setEditorValue =function(obj){
		if(obj && obj.id) {
			clearEditorValue();
			$.m({ClassName:"CT.BSP.MSG.BL.ContentTemplate",MethodName:'OutputContent',Id:obj.id},function(ret){
				
				$('#editor-btn-edit').linkbutton('enable');
				$('#editor-btn-save').linkbutton('disable');
				$('#editor-btn-cancel').linkbutton('disable');
				$('#editor-wrap').hide();
				$('#editor-preview').show().html(ret).removeClass('no-data');
				$('#editor-buttons').show();
				$('#editor-panel').panel('setTitle',obj.title);
				$('#EditorId').val(obj.id);
			})
			

			
		}else{
			clearEditorValue();
			$('#editor-preview').empty().addClass('no-data');
			$('#editor-buttons').hide();
		}
		
	}
	GV.setEditorValue=setEditorValue;
	var clearEditorValue=function(){
		
		$('#editor-panel').panel('setTitle','请选择左侧目录叶子节点');
		$('#EditorId').val('');
		
		$('#editor-btn-edit,#editor-btn-save,#editor-btn-cancel').linkbutton('disable');
		
	}
	///修改按钮
	$('#editor-btn-edit').click(function(){
		$('#editor-wrap').show();
		$('#editor-preview').hide();
		
		if(!window.ckeditorInited) {
			initCKEditor()
		}
		var content=$('#editor-preview').html();
		GV.setCKEditorContext(content);
		
		$('#editor-btn-edit').linkbutton('disable');
		$('#editor-btn-cancel').linkbutton('enable');
		$('#editor-btn-save').focus();
		
	})
	
	$('#editor-btn-save').click(function(){
		var id=$('#EditorId').val();
		var content=GV.getCKEditorContext();
		//alert(content);
		$.m({ClassName:"CT.BSP.MSG.BL.ContentTemplate",MethodName:'UpdateContent',_headers:{'X-Accept-Tag':1},
			Id:id,
			Content:content
		},function(rtn){
			if (rtn>0){
				$.messager.alert("成功","保存成功",'success',function(){
					$('#editor-btn-edit').linkbutton('enable');
					$('#editor-btn-save').linkbutton('disable');
					$('#editor-wrap').hide();
					$('#editor-preview').show().html(content);
					$('#editor-btn-cancel').linkbutton('disable');
					
				});

				
			}else{
				$.messager.popover({msg:'失败：'+(rtn.split("^")[1]||rtn),type:'error'});
				
			}
		})
		
		
			
	})
	
	$('#editor-btn-cancel').click(function(){
		
		$('#editor-btn-edit').linkbutton('enable');
		$('#editor-btn-save').linkbutton('disable');
		$('#editor-wrap').hide();
		$('#editor-preview').show();
		$('#editor-btn-cancel').linkbutton('disable');

		$('#editor-btn-save').focus();
	})
	
	
	
	
	var initCKEditor=function(){
		var edtheight=400;
		edtheight=$('#editor-wrap').height();
		edtheight=edtheight-42-29-2;
		var editor=CKEDITOR.replace( 'editor-text' ,{
				height:edtheight,
				toolbar:[
				['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
				['TextColor','BGColor'],
				['Styles','Format','Font','FontSize'],
				['Link','Unlink'],
				['HorizontalRule','Smiley','SpecialChar','-','Outdent','Indent'],
				['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
				['Maximize']
				]
			});
		editor.on("instanceReady", function (evt) {
			editor.on("change",function(){
				//
				$('#editor-btn-save').linkbutton('enable');
			});
 
		})
		
		GV.getCKEditorContext=function(){
			return editor.getData();
		}
		GV.setCKEditorContext=function(context){
			editor.setData(context);	
		}
		GV.clearCKEditorContext=function(){
			editor.toolbar[0].items[0].setState(0);
			editor.setData("");	
		}
		window.ckeditorInited=true;
	}
}
var init=function(){
	initTree();	
	initEditor();
}
$(init);