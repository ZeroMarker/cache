function InitEvent()
{
	$('#layoutMain').layout('panel','center').bind('contextmenu',showTreeMenu);
	if(!ServerObj.EditMode){
		$('#layoutMain').layout('add',{
	        region:'south',
	        border:false,
	        collapsible:false,
	        split:false,
	        height:40,
	        bodyCls:'panel-noscroll',
	        style:{'padding':'5px','box-shadow':'0px -2px 4px 0px rgba(0, 0, 0, 0.1)'},
	        content:$('<a></a>').linkbutton({
				text:$g('添加到表格'),
				iconCls:'icon-w-add',
				onClick:AddItemToEntryGrid
			})
	    });
	}
}
function InitFavTree()
{
	$('#tFav').tree({
		url:'websys.Broker.cls',
		singleSelect:false,
		animate:true,	
		checkbox:false,
		cascadeCheck:false,		
		lines:true,
		dnd:true,
		formatter:function(node){
			var text=node.text;
			if(node.attributes){
				var PartDesc=node.attributes.partDesc,Note=node.attributes.note;
				if(parseFloat(node.attributes.stock)<=0) text='<span class="item-nostock">'+text+'</span>';
				if(PartDesc) text+='<span class="item-part">'+PartDesc+'</span>';
				if(Note) text+='<span class="item-note">['+Note+']</span>';
			}
			return text;
		},
		onBeforeLoad:function(node,param){
			param.ClassName='DHCDoc.Order.Fav';
			param.MethodName='GetFavData';
			param.Type=GetCatType();
			param.CONTEXT=ServerObj.CONTEXT, 
			param.LocID=session['LOGON.CTLOCID'];
			param.UserID=session['LOGON.USERID'];
			param.EpisodeID=ServerObj.EpisodeID;
			param.SearchAlias=$('#searchTemp').val();
		},
		onClick:function(node){
			if(!$(this).tree('isLeaf',node.target)&&$('#swUseType').switchbox('getValue')){
				var level=$(this).tree('getLevel',node.target);
				if(level==1){
					if(node.state=='closed') $(this).tree('expand',node.target);
					else $(this).tree('collapse',node.target);
				}else{
					var method=$(this).tree('isSelected',node.target)?'select':'unselect';
					$.each(node.children,function(){
						$('#tFav').tree(method,$('#'+this.domId)[0]);
					});
				}
			}
		},
		onDblClick:function(node){
			if($('#swUseType').switchbox('getValue')){
				AddItemToEntryGrid(node);
			}else{
				$(this).tree('beginEditNew',$('#'+node.domId)[0]);
			}
		},
		onContextMenu:showTreeMenu,
		onBeforeEditNew:function(node){return CheckBeforeEdit(node.target)},
		onBeginEdit:function(node){
			var that=this;
			var target=$('#'+node.domId)[0];
			var level=$(this).tree('getLevel',target);
			var ed=$(this).tree('getEditor',target);
			if(level==3){
				InitItemLookUp(target,that);
			}else{
				ed.keydown(function(e){
					if(e.keyCode==13){
						$(that).tree('endEditNew',target);
					}
				});
			}
			ed.select();
		},
		onEndEdit:function(node){
			var target=$('#'+node.domId)[0];
			var level=$(this).tree('getLevel',target);
			var ed=$(this).tree('getEditor',target);
			var value=ed.val(),PartInfo='';
			if(level>2){
				var idField=ed.lookup('options').idField;
				var selected=ed.lookup('grid').datagrid('getSelected');
				value=selected[idField]
				PartInfo=selected.PartInfo||'';
			}
			var parNode=$(this).tree('getParent',target);
			var parID=parNode?parNode.id:'';
			var ID=node.id||'';
			var InputObj={
				Type:GetCatType(),
				CONTEXT:ServerObj.CONTEXT, 
				LocID:session['LOGON.CTLOCID'],
				UserID:session['LOGON.USERID'],
				EpisodeID:ServerObj.EpisodeID,
				ParID:parID,
				ID:ID,
				Value:value,
				Note:'',
				PartInfo:PartInfo
			}
			var retObj=$.cm({
				ClassName:'DHCDoc.Order.Fav',
				MethodName:'SaveTreeNode',
				InputStr:JSON.stringify(InputObj)
			},false);
			if(retObj.code=='0'){
				$.messager.popover({msg:retObj.msg,type:'success'});
				var that=this;
				setTimeout(function(){
					$(that).tree('update',$.extend({target:target},retObj.data));
				},50);
				return true;
			}else{
				$.messager.alert('提示',retObj.msg);
				return false;
			}
		},
		onAfterEdit:function(node){
			if($(this).tree('getLevel',$('#'+node.domId)[0])==3)
				$('#menu').menu('options').onClick($('#menu_add_item')[0]);
		},
		onBeforeDrag:CheckBeforeEdit,
		onDragOver:function(target, source){
			var sourceLevel=$(this).tree('getLevel',$('#'+source.domId)[0]);
			var level=$(this).tree('getLevel',target);
			var difLevel=sourceLevel-level;
			$(target).removeClass("tree-node-append tree-node-top tree-node-bottom");
			if(difLevel==0){
				$(target).removeClass("tree-node-append tree-node-top tree-node-bottom");
				if(window.event.offsetY<($(target).height()/2)){
					$(target).addClass('tree-node-top');
				}else{
					$(target).addClass('tree-node-bottom');
				}
			}else{
				$(target).addClass('tree-node-append');
			} 
			return (difLevel==1)||(difLevel==0);
		},
		onBeforeDrop:function(target, source, point){
			var idArr=new Array();
			var node=$(this).tree('getNode',target);
			if(point=='append'){
				var parNode=node;
				var nodes=node.children;
				for(var i=0;i<nodes.length;i++){
					if(source.id==nodes[i].id) continue;
					idArr.push(nodes[i].id);
				}
				idArr.push(source.id);
			}else{
				var parNode=$(this).tree('getParent',target);
				var nodes=parNode?parNode.children:$(this).tree('getRoots');
				for(var i=0;i<nodes.length;i++){
					if(source.id==nodes[i].id) continue;
					if((point=='top')&&(nodes[i].id==node.id)) idArr.push(source.id);
					idArr.push(nodes[i].id);
					if((point=='bottom')&&(nodes[i].id==node.id)) idArr.push(source.id);
				}
			}
			if(idArr.length){
				var ret=$.cm({
					ClassName:'DHCDoc.Order.Fav',
					MethodName:'UpdateTreeSeq',
					ParNodeID:parNode?parNode.id:'',
					IDStr:JSON.stringify(idArr),
					dataType:'text'
				},false);
				if(ret=='0'){
					$.messager.popover({msg:"位置调整成功",type:'success'});
				}else{
					$.messager.popover({msg:"位置调整失败:"+ret,type:'error'});
					return false;
				}
			}
			return true;
		},
		onDrop:function(target, source, point){
			var parNode=$(this).tree('getParent',target);
			if(parNode){	//更新tree id
				var ParID=parNode.id;
				var node=$(this).tree('getNode',target);
				var idArr=node.id.split('_');
				var newID=ParID+'_'+idArr[idArr.length-1];
				$(this).tree('update',{target:target,id:newID});
				if(node.children){
					for(var i=0;i<node.children.length;i++){
						var childIdArr=node.children[i].id.split('_');
						var newChildID=newID+'_'+childIdArr[childIdArr.length-1];
						$(this).tree('update',{target:$('#'+node.children[i].domId)[0],id:newChildID});
					}
				}
			}
		}
	});
	function CheckBeforeEdit(target){
		if(window.event&&(window.event.button==2)) return false;
		if($('#swUseType').switchbox('getValue')) return false;
		if(target&&$(target).find('input').size()) return false;
		if(window.event&&$(window.event.target).hasClass("tree-editor-icon")) return false;
		if(!GetAuthFlag()){
			$.messager.popover({msg:'没有'+GetCatTypeDesc()+'模板维护权限',type:'alert'});
			return false;
		}
		var editNodes=$('#tFav').tree('getEditingNodes');
		for(var i=editNodes.length-1;i>=0;i--){
			if(!editNodes[i].id){
				var target=$('#'+editNodes[i].domId)[0];
				var ed=$('#tFav').tree('getEditor',target);
				if(ed.size()) try{ed.lookup('hidePanel');}catch(e){}
				RemoveTreeNode(target);
				editNodes.pop();
			}else{
				var $cancel=$('#'+editNodes[i].domId).find('.icon-back.tree-editor-icon');
				if($cancel.size()){
					$cancel.click();
					editNodes.pop();
				}
			}
		}
		if(editNodes.length){
			$.messager.popover({msg:'请先完成正在编辑节点',type:'alert'});
			return false;
		}
		return true;
	}
}
function RemoveTreeNode(target)
{
	var ed=$('#tFav').tree('getEditor',target);
	if(ed.size()) try{ed.lookup('hidePanel');}catch(e){}
	$('#tFav').tree('remove',target);
}
function showTreeMenu(e,node)
{
	e.stopPropagation();
	e.preventDefault();
	if($('#swUseType').switchbox('getValue')) return false;
	/*$('#tFav').tree('unselectAll');
	if(node){
		$('#tFav').tree('select',$('#'+node.domId)[0]);
	}*/
	var editNodes=$('#tFav').tree('getEditingNodes');
	if(editNodes.length){
		$.messager.popover({msg:'请先完成正在编辑节点',type:'alert'});
		return false;
	}
	$('#menu').menu('show', {left: e.pageX,top: e.pageY});
	return false;
}
function InitMenu()
{
	$('#menu').menu({
		onShow:function(){
			var displayItem=new Array();
			var nodes=$('#tFav').tree('getSelected');
			var level=nodes[0]?$('#tFav').tree('getLevel',$('#'+nodes[0].domId)[0]):0;
			if(level){
				var CatType=GetCatType();
				$(this).find('div[name="menucopy"]').each(function(){
					var key=$(this).attr('key');
					if(key==CatType) return true;
					if(ServerObj.FavAuth[key]){
						displayItem.push($(this).attr('id'));
					}
				});
				displayItem.push('menu_copy_other');
			}
			if(GetAuthFlag()){
				switch(level){
					case 3:displayItem.push('menu_add_item','menu_delete','menu_edit_note');break;
					case 2:displayItem.push('menu_add_subcat','menu_add_item','menu_delete');break;
					case 1:displayItem.push('menu_add_cat','menu_add_subcat','menu_delete');break;
					default:displayItem.push('menu_add_cat');break;
				}
			}
			$('#menu').find('div[id]').each(function(){
				if(displayItem.indexOf($(this).attr('id'))>-1){
					$('#menu').menu('showItem',this);
				}else{
					$('#menu').menu('hideItem',this);
				}
			});
			InitCopyMenu();
		},
		onClick:function(item){
			switch(item.id){
				case 'menu_add_cat':
					$('#tFav').tree('addEditNode',null);
					break;
				case 'menu_add_subcat':
					var node=$('#tFav').tree('getSelected')[0];
					var level=$('#tFav').tree('getLevel',$('#'+node.domId)[0]);
					if(level>1){
						node=$('#tFav').tree('getParent',$('#'+node.domId)[0]);
					}
					$('#tFav').tree('addEditNode',$('#'+node.domId)[0]);
					break;
				case 'menu_add_item':
					var node=$('#tFav').tree('getSelected')[0];
					var level=$('#tFav').tree('getLevel',$('#'+node.domId)[0]);
					if(level>2){
						node=$('#tFav').tree('getParent',$('#'+node.domId)[0]);
					}
					$('#tFav').tree('addEditNode',$('#'+node.domId)[0]);
					break;
				case 'menu_copy_hosp':CopyTreeNode('');break;
				case 'menu_copy_loc':CopyTreeNode('');break;
				case 'menu_copy_user':CopyTreeNode('');break;
				case 'menu_copy_otherloc':CopyTreeNode('',$(item.target).attr('locid'));break;
				case 'menu_delete':
					var NodeIDArr=new Array();
					var nodes=$('#tFav').tree('getSelected'),deleteTarget=new Array();
					for(var i=0;i<nodes.length;i++){
						var node=nodes[i];
						var target=$('#'+node.domId)[0];
						if(!node.id){
							RemoveTreeNode(target);
							continue
						}
						NodeIDArr.push(node.id);
						deleteTarget.push(target);
					}
					if(NodeIDArr.length){
						$.messager.confirm('提示','是否删除所选项目?',function(r){
							if(r){
								var ret=$.cm({
									ClassName:'DHCDoc.Order.Fav',
									MethodName:'DeleteTreeNode',
									Nodes:JSON.stringify(NodeIDArr),
									dataType:'text'
								},false);
								if(ret=='0'){
									$.messager.popover({msg:"删除成功",type:'success'});
									$.each(deleteTarget,function(index,target){
										RemoveTreeNode(target);
									});
								}else{
									$.messager.alert('提示','删除失败:'+ret);
								}
							}
						});
					}
					break;
				case 'menu_edit_note':
					if(!$('#_Item_Note_Dialog').size()){
						$('body').append('<div id="_Item_Note_Dialog"></div>');
						$('#_Item_Note_Dialog').dialog({
							iconCls:'icon-w-pen-paper',    
						    title: '维护项目备注',    
						    width: 300,
						    content:'<input id="_Note" type="text" class="textbox" style="width:270px;margin:20px 10px 5px 10px;" maxlength="10"/>',  
						    modal: true,
						    onBeforeOpen:function(){
							    var NodeIDArr=new Array();
								var nodes=$('#tFav').tree('getSelected');
								for(var i=0;i<nodes.length;i++){
									var node=nodes[i];
									var level=$('#tFav').tree('getLevel',$('#'+node.domId)[0]);
									if((level==3)&&(node.attributes.itemid.indexOf('||')>-1))
										NodeIDArr.push(node.id);
								}
								if(!NodeIDArr.length){
									$.messager.popover({msg:'请选择医嘱项目维护备注',type:'alert'});
									return false;
								}
							    $('#_Note').val(nodes[0].attributes.note).select();
								$('#_Item_Note_Dialog').dialog('options').NodeIDArr=NodeIDArr;
								return true;
							},
							onOpen:function(){
								$('#_Note').select();
							},
						    buttons:[{
							    text:'确定',
								handler:function(){
									var Note=$('#_Note').val();
									var NodeIDArr=$('#_Item_Note_Dialog').dialog('options').NodeIDArr;
									var ret=$.cm({
										ClassName:'DHCDoc.Order.Fav',
										MethodName:'UpdateItemNode',
										ItemIDStr:JSON.stringify(NodeIDArr),
										Note:Note
									},false);
									if(ret=='0'){
										$('#_Item_Note_Dialog').dialog('close');
										$.messager.popover({msg:'修改备注成功',type:'success'});
										var nodes=$('#tFav').tree('getSelected');
										for(var i=0;i<nodes.length;i++){
											var node=nodes[i];
											var level=$('#tFav').tree('getLevel',$('#'+node.domId)[0]);
											if((level!=3)||(node.attributes.itemid.indexOf('||')==-1)) continue
											$('#tFav').tree('update',{
												target:node.target,
												attributes:$.extend(node.attributes,{note:Note})
											});
										}
									}else{
										$.messager.alert('提示','修改备注失败:'+ret,'warning');
									}
								}
							}]
						});
					}else{
						$('#_Item_Note_Dialog').dialog('open');
					}
					break;
				default:break;
			}
		}
	});
}
function InitCopyMenu()
{
	var nodes=$('#tFav').tree('getSelected');
	var level=nodes.length?$('#tFav').tree('getLevel',$('#'+nodes[0].domId)[0]):0;
	$('div[name="menucopy"]').each(function(){
		$('#menu').menu('removeSubMenu',this);
		if(level<2) return true;
		var target=this;
		var key=$(target).attr('key');
		var LocID=$(target).attr('locid');
		if(!LocID) LocID=session['LOGON.CTLOCID'];
		$.cm({ 
			ClassName:"DHCDoc.Order.Fav",
			MethodName:"GetFavData", 
			Type:key,
			CONTEXT:ServerObj.CONTEXT, 
			LocID:LocID,
			UserID:session['LOGON.USERID'],
			EpisodeID:ServerObj.EpisodeID,
			OnlyCatNode:1
		},function(data){
			$.each(data,function(index, value){
				$('#menu').menu('appendItem', {
					parent:target,
					text:value.text,
					onclick:function(){
						CopyTreeNode(value.id,LocID);
					}
				});
				if(level<3) return true;
				var submenu=$('#menu').menu('getSubMenu',target);
				var subTarget=submenu.children("div.menu-item:last")[0];
				$.each(value.children,function(index, value){
					$('#menu').menu('appendItem', {
						parent:subTarget,
						text:value.text,
						onclick:function(){
							CopyTreeNode(value.id,LocID);
						}
					});
				});
			});
		});	
	});
}
function CopyTreeNode(ToNodeID,LocID)
{
	var nodes=$('#tFav').tree('getSelected');
	var FromIDArr=new Array();
	var lastLevel=0;
	for(var i=0;i<nodes.length;i++){
		var level=$('#tFav').tree('getLevel',$('#'+nodes[i].domId)[0]);
		if(lastLevel&&(lastLevel!=level)){
			$.messager.popover({msg:'被复制项目必须层级一样',type:'alert'});
			return false;
		}
		lastLevel=level;
		FromIDArr.push(nodes[i].id);
	}
	if(!LocID) LocID=session['LOGON.CTLOCID'];
	var Type=ToNodeID==''?$(window.event.target).closest('[key]').attr('key'):'';
	var ret=$.cm({ 
		ClassName:"DHCDoc.Order.Fav",
		MethodName:"CopyTreeNode", 
		FromNodeID:JSON.stringify(FromIDArr),
		ToNodeID:ToNodeID,
		Type:Type,
		CONTEXT:ServerObj.CONTEXT, 
		LocID:LocID,
		UserID:session['LOGON.USERID'],
		dataType:'text'
	},false);
	if(ret=='0'){
		$.messager.popover({msg:"复制成功",type:'success'});
		return true;
	}else{
		$.messager.popover({msg:ret,type:'alert'});
		return false;
	}
}
function InsertMultItem(ItemArr)
{
	if(!ItemArr||!ItemArr.length){
		parent.$.messager.popover({msg:'没有需要保存的项目',type:'alert'});
		return false;
	}
	if(!GetAuthFlag()){
		parent.$.messager.popover({msg:'没有'+GetCatTypeDesc()+'模板维护权限',type:'alert'});
		return false;
	}
	var SubCatID="";
	var nodes=$('#tFav').tree('getSelected');
	for(var i=0;i<nodes.length;i++){
		var node=nodes[i];
		var level=$('#tFav').tree('getLevel',$('#'+node.domId)[0]);
		if(level>1) SubCatID=node.id;
	}
	if(SubCatID==''){
		parent.$.messager.popover({msg:'请先选择保存的子分类',type:'alert'});
		return false;
	}
	var ret=$.cm({ 
		ClassName:"DHCDoc.Order.Fav",
		MethodName:"InsertMultItem", 
		FavItemStr:JSON.stringify(ItemArr),
		SubCatID:SubCatID,
		UserID:session['LOGON.USERID'],
		dataType:'text'
	},false);
	if(ret=='0'){
		parent.$.messager.popover({msg:"保存成功",type:'success'});
		LoadTemplateData();
		return true;
	}else{
		parent.$.messager.alert('提示','保存失败:'+ret.split("^")[0]);
		return false;
	}
}
function LoadTemplateData()
{
	$('#tFav').tree('reload');
}
function AddItemToEntryGrid(nodes)
{
	if(!nodes) nodes=$('#tFav').tree('getSelected');
	if(!nodes) return;
	if(!$.isArray(nodes)){
		var node=nodes;
		if(node&&node.attributes){
			var obj=node.attributes;
			parent.addSelectedFav(obj.itemid,node.text,obj.note,obj.partInfo);
		}
	}else{
		var index=0;
		mulAddSelectedFav(nodes[0]);
		function mulAddSelectedFav(node){
			if(!node) return;
			if(!node.attributes){
				mulAddSelectedFav(nodes[++index]);
			}else{
				var obj=node.attributes;
				parent.addSelectedFav(obj.itemid,node.text,obj.note,obj.partInfo,function(){
					mulAddSelectedFav(nodes[++index]);
				});
			}
		}
	}
	$('#tFav').tree('unselectAll');
}