var initTree=function(){
	///���ӷ���
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
		$('#catgory_win').dialog('open').dialog('setTitle','���ӷ���');
	}
	///����ģ��
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
		
		$('#content_win').dialog('open').dialog('setTitle','����ģ��');
	}
	///�޸�
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
			
			$('#catgory_win').dialog('open').dialog('setTitle','�޸ķ���');

			
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
			
			$('#content_win').dialog('open').dialog('setTitle','�޸�ģ��');
			
		}
	}
	///ɾ��
	GV.mm_delete=function(){
		var node=$('#left_tree').tree('getSelected');
		var arr=node.id.split("-");
		
		var data={ClassName:"CT.BSP.MSG.BL.ContentTemplate"};
		var msg='';
		if(arr.length==3) {
			msg='ȷ��ɾ���˷����𣬴˲�����ɾ����������ģ�壡';
			data.MethodName='DeleteCatgory';
			data.Catgory=arr[2];
		}else if(arr.length==4){
			msg='ȷ��ɾ����ģ����';
			data.MethodName='Delete';
			data.Id=arr[3];
		}
		
		$.messager.confirm('ȷ��',msg,function(r){
			if(r){
				$.m(data,function(rtn){
					console.log(rtn)	
					if (rtn>0){
						$.messager.alert("�ɹ�","ɾ���ɹ�",'success',function(){
							var pnode=$('#left_tree').tree('getParent',node.target);
							$('#left_tree').tree('reload',pnode.target);
						});

						
					}else{
						$.messager.popover({msg:'ʧ�ܣ�'+(rtn.split("^")[1]||rtn),type:'error'});
						
					}
				})
			}	
		})
		
		
	}
	
	$('#catgory_win').dialog({
		title:'����',
		iconCls:'icon-w-paper',
		buttons:[{
			text:'����',
			handler:function(){
				var node=$('#left_tree').tree('getSelected');
				var data={ClassName:"CT.BSP.MSG.BL.ContentTemplate"};
				data.Title=$('#CatgoryTitle').val();
				data.Summary=$('#CatgorySummary').val();
				if ($.trim(data.Title)==''){
					$.messager.popover({msg:'������������',type:'alert'});
					return ;
				}
				data.UserId=GV.user;
				var catid=$('#CatgoryId').val();
				if (catid>0) { //�޸�
					data.MethodName='UpdateTitleAndSummary';
					data.Id=catid
				}else{ //����
					data.MethodName='AddCatgory'	
					data.RefType=$('#CatgoryRefType').val();
					data.RefObjId=$('#CatgoryRefObjId').val();
					data.Type=GV.type+'C';
				}
				
				$.m(data,function(rtn){
					console.log(rtn)	
					if (rtn>0){
						$.messager.alert("�ɹ�","����ɹ�",'success',function(){
							$('#catgory_win').dialog('close');
							if (node.id.split("-").length==2) {
								$('#left_tree').tree('reload',node.target);}
							else  {
								var pnode=$('#left_tree').tree('getParent',node.target);
								$('#left_tree').tree('reload',pnode.target);
							}
							
						});

						
					}else{
						$.messager.popover({msg:'ʧ�ܣ�'+(rtn.split("^")[1]||rtn),type:'error'});
						
					}
				})
			}
		},{
			text:'�ر�',
			handler:function(){
				$('#catgory_win').dialog('close');
			}
		}]
	})
	
	$('#content_win').dialog({
		title:'ģ��',
		iconCls:'icon-w-paper',
		buttons:[{
			text:'����',
			handler:function(){
				var node=$('#left_tree').tree('getSelected');
				var data={ClassName:"CT.BSP.MSG.BL.ContentTemplate"};
				data.Title=$('#ContentTitle').val();
				data.Summary=$('#ContentSummary').val();
				if ($.trim(data.Title)==''){
					$.messager.popover({msg:'������ģ�����',type:'alert'});
					return ;
				}
				data.UserId=GV.user;
				var contentid=$('#ContentId').val();
				if (contentid>0) { //�޸�
					data.MethodName='UpdateTitleAndSummary';
					data.Id=contentid
				}else{ //����
					data.MethodName='AddContent'	
					data.RefType=$('#ContentRefType').val();
					data.RefObjId=$('#ContentRefObjId').val();
					data.Catgory=$('#ContentCatgory').val();
					data.Type=GV.type;
				}
				
				$.m(data,function(rtn){
					console.log(rtn)	
					if (rtn>0){
						$.messager.alert("�ɹ�","����ɹ�",'success',function(){
							$('#content_win').dialog('close');
							if (node.id.split("-").length==3) {
								$('#left_tree').tree('reload',node.target);}
							else  {
								var pnode=$('#left_tree').tree('getParent',node.target);
								$('#left_tree').tree('reload',pnode.target);
							}
							
						});

						
					}else{
						$.messager.popover({msg:'ʧ�ܣ�'+(rtn.split("^")[1]||rtn),type:'error'});
						
					}
				})
			}
		},{
			text:'�ر�',
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
			//��ֹ������Ĳ˵���
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
			if (nodelevel==2 ){  //ĳĳ�û�  ĳĳ����  ĳĳҽԺ�㼶
				setOpBtnStatus('addCatgory','enable');  //���ӷ��� ����
				setOpBtnStatus('addContent','disable');  //����ģ�� ����
				setOpBtnStatus('edit','disable');  //�޸� ����
				setOpBtnStatus('delete','disable');  //ɾ�� ����
				
			}else if( nodelevel==3  ){  //ĳ����㼶
				setOpBtnStatus('addCatgory','enable');  //���ӷ��� ����
				setOpBtnStatus('addContent','enable');  //����ģ�� ����
				setOpBtnStatus('edit','enable');  //�޸� ����  �޸ķ�������
				setOpBtnStatus('delete','enable');  //ɾ�� ����  ɾ���˷��༰������ģ��
				
			}else if( nodelevel==4 ){  //ĳ����ģ��㼶
				setOpBtnStatus('addCatgory','disable');  //���ӷ��� ����
				setOpBtnStatus('addContent','enable');  //����ģ�� ����
				setOpBtnStatus('edit','enable');  //�޸� ����  �޸�ģ������
				setOpBtnStatus('delete','enable');  //ɾ�� ���� ɾ����ģ��
				
			}else{
				setOpBtnStatus('addCatgory','disable');  //���ӷ��� ����
				setOpBtnStatus('addContent','disable');  //����ģ�� ����
				setOpBtnStatus('edit','disable');  //�޸� ����  
				setOpBtnStatus('delete','disable');  //ɾ�� ���� 
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
				setOpBtnStatus('addCatgory','disable');  //���ӷ��� ����
				setOpBtnStatus('addContent','disable');  //����ģ�� ����
				setOpBtnStatus('edit','disable');  //�޸� ����  
				setOpBtnStatus('delete','disable');  //ɾ�� ���� 
				
				GV.setEditorValue();
			}
			if(node && node.id) {  //���Ľڵ� �����������ӽڵ�
				var id=node.id;
				var nodelevel=id.split("-").length;
				if (data.length==0) { //û��ȡ������
					var msg='û������Ŷ';
					if (nodelevel==2) {
						msg='û�з�������Ŷ��������ѡ������';	
					}else if(nodelevel==3){
						msg='û��ģ������Ŷ�������ѡ������';	
					}
					$.messager.popover({msg:msg,type:'info'});
				}
			}
		}
	});
	$('#left_tree_mm').contextmenu(function(e){
		e.preventDefault();
	});
	
	///��ȡ��ĳ�ڵ������ı� ���ڵ�-2���ڵ�-�����ڵ�-���ڵ�
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

	/// �����Ҳ�༭������
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
		
		$('#editor-panel').panel('setTitle','��ѡ�����Ŀ¼Ҷ�ӽڵ�');
		$('#EditorId').val('');
		
		$('#editor-btn-edit,#editor-btn-save,#editor-btn-cancel').linkbutton('disable');
		
	}
	///�޸İ�ť
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
				$.messager.alert("�ɹ�","����ɹ�",'success',function(){
					$('#editor-btn-edit').linkbutton('enable');
					$('#editor-btn-save').linkbutton('disable');
					$('#editor-wrap').hide();
					$('#editor-preview').show().html(content);
					$('#editor-btn-cancel').linkbutton('disable');
					
				});

				
			}else{
				$.messager.popover({msg:'ʧ�ܣ�'+(rtn.split("^")[1]||rtn),type:'error'});
				
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