function InitEvent()
{
	$('#tabFavCat').on('dblclick','.tabs-title',function(){
		if(!CheckBeforeEdit()) return false;
		var $input=$('<input type="text" maxlength="10"/>').attr('required','required').val($(this).text()).keyup(function(e){
			if(e.keyCode==13){
				var title=$(this).val();
				if(title==''){
					$.messager.popover({msg:'请输入分类名字',type:'alert'});
					$(this).select();
					return false;
				}
				var tabIndex=$(this).closest('li').index();
				var tab=$('#tabFavCat').tabs('getTab',tabIndex);
				var ID=tab.panel('options').id;
				var ret=$.cm({
					ClassName:'DHCDoc.Order.Fav',
					MethodName:'SaveCat',
					Type:GetCatType(),
					CONTEXT:ServerObj.CONTEXT, 
					Name:title,
					LocID:session['LOGON.CTLOCID'],
					UserID:session['LOGON.USERID'],
					ID:ID,
					dataType:'text'
				},false);
				if(ret.split('^')[0]=='0'){
					$('#tabFavCat').tabs('update', {
						tab: tab,
						options:{title:title}
					});
					$.messager.popover({msg:'保存成功',type:'success'});
				}else{
					$.messager.alert('提示',ret,'warning',function(){$input.select()});
				}
			}
			return false;
		}).focus(function(){
			$(this).select();
		});
		$(this).html($input);
		$input.select();
	});
	if(!ServerObj.EditMode){
		$('<a></a>').css({'position':'absolute','top':'48px','right':'10px'}).appendTo('body').linkbutton({
			text:$g('添加到表格'),
			iconCls:'icon-w-add',
			onClick:AddItemToEntryGrid
		});
	}
}
function InitFavTree()
{
	$('#tabFavCat').tabs({
		fit:true,
		border:false,
		tabHeight:26,
        onBeforeSelect:function(){
            if($('#swUseType').switchbox('getValue')) return true;
            return CheckBeforeEdit(true);
        },
		onSelect:function(title,index){
			var tab=$(this).tabs('getTab',index);
			if(tab.loaded) return;
			tab.loaded=true;
			var data=tab.panel('options').data;
			ShowSubCatItem(tab.panel('body'),data.children);
		},
		onBeforeClose:function(title,index){
			if(!GetAuthFlag()){
				parent.$.messager.popover({msg:'没有'+GetCatTypeDesc()+'模板维护权限',type:'alert'});
				return false;
			}
			$.messager.confirm('提示','确定删除该分类?(其子分类与项目也将一并删除)',function(r){
				if(r){
					var opts=$('#tabFavCat').tabs('options');
					var onBeforeClose=opts.onBeforeClose;
					opts.onBeforeClose=function(){};
					var tab=$('#tabFavCat').tabs('getTab',index);
					var CatID=tab.panel('options').id;
					var ret=$.cm({
						ClassName:'DHCDoc.Order.Fav',
						MethodName:'DeleteTreeNode',
						Nodes:CatID,
						dataType:'text'
					},false);
					if(ret==0){
						$.messager.popover({msg:'删除成功',type:'success'});
						$('#tabFavCat').tabs('close',index);
					}else{
						$.messager.alert('提示','删除失败:'+ret);
					}
					opts.onBeforeClose=onBeforeClose;
				}
			});
			return false;
		},
		onContextMenu:function(e, title,index){
			$(this).tabs('select',index);
			return showTreeMenu(e);
		}
	});
	LoadCatTabs();
}
function LoadCatTabs()
{
	var tab=$('#tabFavCat').tabs('getSelected');
	var selectedId=tab?tab.panel('options').id:'';
	var selectedSubCatID=GetSelectedSubCatID();
	$("#tabFavCat").find('ul.tabs').nextAll().remove();
	$('#tabFavCat').tabs('clearTabs');
	$.cm({
		ClassName:'DHCDoc.Order.Fav',
		MethodName:'GetFavData',
		Type:GetCatType(),
		CONTEXT:ServerObj.CONTEXT, 
		LocID:session['LOGON.CTLOCID'],
		UserID:session['LOGON.USERID'],
		EpisodeID:ServerObj.EpisodeID,
		SearchAlias:$('#searchTemp').val()
	},function(data){
		for(var i=0;i<data.length;i++){	
			data[i].selected=(selectedId==data[i].id);
			addCatTab(data[i]);
		}
		var tab=$('#tabFavCat').tabs('getSelected');
		if(!tab) $('#tabFavCat').tabs('select',0);
		if(selectedSubCatID&&$('#'+selectedSubCatID).length){
			$('#'+selectedSubCatID).click();
		}
		if(!$('#swUseType').switchbox('getValue')&&GetAuthFlag()){
			$("#tabFavCat").find('ul.tabs').after($('<a href="#"></a>').linkbutton({
				plain:true,
				iconCls:'icon-batch-add',
				onClick:function(){
					if(!CheckBeforeEdit()) return;
					var $input=$('<input style="width:80px;" maxlength="10"/>').attr('required','required').insertBefore(this).focus();
					$input.keyup(function(e){
						if(e.keyCode==13){
							var title=$(this).val();
							if(title==''){
								$.messager.popover({msg:'请输入分类名字',type:'alert'});
								$(this).select();
								return false;
							}
							var ret=$.cm({
								ClassName:'DHCDoc.Order.Fav',
								MethodName:'SaveCat',
								Type:GetCatType(),
								CONTEXT:ServerObj.CONTEXT, 
								Name:title,
								LocID:session['LOGON.CTLOCID'],
								UserID:session['LOGON.USERID'],
								dataType:'text'
							},false);
							if(ret.split('^')[0]=='0'){
								$input.remove();
								var id=ret.split('^')[1];
								addCatTab({id:id,text:title,selected:true});
								$.messager.popover({msg:'保存成功',type:'success'});
							}else{
								$.messager.alert('提示',ret,'warning',function(){$input.select()});
							}
						}
					});
				}
			}));
		}
	});
	function addCatTab(catData){
		$('#tabFavCat').tabs('add',{
			closable:!$('#swUseType').switchbox('getValue')&&GetAuthFlag(),
			bodyCls:'tab-fav-cat',
			id:catData.id,
			title:catData.text,
			selected:catData.selected||false,
			data:catData
		}); 
		$('#tabFavCat').children('.tabs-header').children('.tabs-wrap').children('ul.tabs').children('li:last').children('a.tabs-inner').draggable({
			delay:300,
			revert:true,
			cursor:'pointer',
			proxy: function(source){
				return $('<div style="border-radius:4px;background: #efefef;color:#666;padding:3px 5px;"></div>').html($(source).html()).appendTo('body');
			},
			onBeforeDrag:function(e){
				if(e.button==2) return false;
				if($(this).find('input').size()) return false;
				if(!CheckBeforeEdit()) return false;
				return true;
			},
			onStartDrag:function(){
				var title=$(this).children('.tabs-title').text();
				$('#tabFavCat').tabs('select',title);
			}
		}).droppable({ 
			accept:'.fav-container,#tabFavCat a.tabs-inner',
			onDragOver:function(e,source){
				$(this).css({'background': '#d8efff'});
				if($(source).hasClass('tabs-inner')){
					var difX=window.event.pageX-$(this).offset().left;
					if(difX>($(this).width()/2)){
						$(this).css({'border-right':'2px solid #40a2de','border-left':''});
					}else{
						$(this).css({'border-right':'','border-left':'2px solid #40a2de'});
					}
				}
			},
			onDragLeave:function(e,source){
				$(this).css({'background': '','border-right':'','border-left':''});
			},
			onDrop:function(e,source){
				$(this).css({'background': '','border-right':'','border-left':''});
				var idArr=new Array();
				var title2=$(this).children('.tabs-title').text();
				var tab2=$('#tabFavCat').tabs('getTab',title2);
				var targetId=tab2.panel('options').id;
				if($(source).hasClass('tabs-inner')){
					var difX=window.event.pageX-$(this).offset().left;
					var difFlag=difX>($(this).width()/2);
					var title1=$(source).children('.tabs-title').text();
					var tab1=$('#tabFavCat').tabs('getTab',title1);
					var sourceId=tab1.panel('options').id;
					var tabs=$('#tabFavCat').tabs('tabs');
					for(var i=0;i<tabs.length;i++){
						var id=tabs[i].panel('options').id;
						if(sourceId==id) continue;
						if(!difFlag&&(targetId==id)) idArr.push(sourceId);
						idArr.push(id);
						if(difFlag&&(targetId==id)) idArr.push(sourceId);
					}
					var ret=$.cm({
						ClassName:'DHCDoc.Order.Fav',
						MethodName:'UpdateTreeSeq',
						ParNodeID:'',
						IDStr:JSON.stringify(idArr),
						dataType:'text'
					},false);
					if(ret=='0'){
						$.messager.popover({msg:"分类调整成功",type:'success'});
						LoadTemplateData();
					}else{
						$.messager.popover({msg:"分类调整失败:"+ret,type:'error'});
					}
				}else{
					var tab1=$('#tabFavCat').tabs('getSelected');
					var data1=tab1.panel('options').data;
					var catData=data1.children[$(source).index()];
					var sourceId=$(source).closest('.panel-body').panel('options').id;
					if(sourceId==targetId) return false;
					tab2.loaded=false;
					var data2=tab2.panel('options').data;
					data2.children.push(catData);
					var idArr=new Array();
					for(var i=0;i<data2.children.length;i++){
						idArr.push(data2.children[i].id);
					}
					var ret=$.cm({
						ClassName:'DHCDoc.Order.Fav',
						MethodName:'UpdateTreeSeq',
						ParNodeID:data2.id,
						IDStr:JSON.stringify(idArr),
						dataType:'text'
					},false);
					if(ret=='0'){
						$.messager.popover({msg:"子类调整成功",type:'success'});
						$(source).remove();
						UpdateCatData();
					}else{
						$.messager.popover({msg:"子类调整失败:"+ret,type:'error'});
						ShowSubCatItem(tab1.panel('body'),data1.children);
					}
				}
			}
		}); 
	}
}
function ShowSubCatItem($tab,SubCatData){
	$tab.empty();
	if(SubCatData){
		for(var i=0;i<SubCatData.length;i++){
			$tab.append(GetSubCatHtml(SubCatData[i]));
		}
	}
	if(!$('#swUseType').switchbox('getValue')&&GetAuthFlag()){
		var $add=$('<div></div>').addClass('fav-add-div').append('<div class="fav-add-x"></div>').append('<div class="fav-add-y"></div>').appendTo($tab);
		$add.click(function(){
			if(!CheckBeforeEdit()) return;
			$(this).before(GetSubCatHtml());
			$(this).prev().find('input').focus();
			$(this).parent().scrollLeft($(this).parent()[0].scrollWidth);
		});
	}
	function GetSubCatHtml(subCatData){
		var $ul=$('<ul></ul>');
		var $title=$('<div></div>').addClass('fav-title-div panel-header panel-header-gray');
		var $panle=$('<div></div>').addClass('fav-item-div panel-body').append($ul);
		var $container=$('<div></div>').addClass('fav-container').append($title).append($panle);
		var treeData=[];
		if(subCatData){
			$container.attr('id',subCatData.id);
			$title.html('<div class="panel-title">'+subCatData.text+'</div>');
			treeData=subCatData.children;
		}
		$ul.tree({
			url:'',	
			singleSelect:false,
			data:treeData,
			onContextMenu:showTreeMenu,
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
			onSelect:function(node){
				if(window.event.ctrlKey){	//多选模式下按住ctrl进入单选模式
					$('.fav-item-div>ul').not($('#'+node.domId).parent().parent()).tree('unselectAll');
				}
			},
			onDblClick:function(node){
				if($('#swUseType').switchbox('getValue')){
					AddItemToEntryGrid(node);
				}else{
					$(this).tree('beginEditNew',$('#'+node.domId)[0]);
				}
			},
			onBeforeEditNew:function(){return CheckBeforeEdit()},
			onBeginEdit:function(node){
				InitItemLookUp($('#'+node.domId)[0],this);
			},
			onEndEdit:function(node){
				var target=$('#'+node.domId)[0];
				var ed=$(this).tree('getEditor',target);
				var idField=ed.lookup('options').idField;
				var selected=ed.lookup('grid').datagrid('getSelected');
				var value=selected[idField];
				var PartInfo=selected.PartInfo||'';
				var ID=node.id||'';
				var InputObj={
					Type:GetCatType(),
					CONTEXT:ServerObj.CONTEXT, 
					LocID:session['LOGON.CTLOCID'],
					UserID:session['LOGON.USERID'],
					EpisodeID:ServerObj.EpisodeID,
					ParID:$container.attr('id'),
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
					$(target).find("input.tree-editor").val(retObj.data.text);
					var that=this;
					setTimeout(function(){
						$(that).tree('update',$.extend({target:target},retObj.data));
					},50);
					return true;
				}else{
					$.messager.alert('提示',retObj.msg,'warning',function(){$(target).find('input').select()});
					return false;
				}
			},
			onAfterEdit:function(node){
				UpdateCatData();
				$(this).tree('addEditNode',null);
			},
			onBeforeDrag:function(target,source,point){
				if(window.event&&(window.event.button==2)) return false;
				if($(window.event.target).hasClass("tree-editor-icon")) return false;
				if(target){
					if($(target).find('input').size()) return false;
					var node=$(this).tree('getNode',$('#'+target.domId)[0]);
					if(!node||!node.id) return false;
				}
				return CheckBeforeEdit();
			},
			onDragOver:function(target, source){
				$(target).removeClass("tree-node-append tree-node-top tree-node-bottom");
				if(window.event.offsetY<($(target).height()/2)){
					$(target).addClass('tree-node-top');
				}else{
					$(target).addClass('tree-node-bottom');
				}
				return true;
			},
			onBeforeDrop:function(target, source, point){
				var idArr=new Array();
				var node=$(this).tree('getNode',target);
				var nodes=$(this).tree('getRoots');
				for(var i=0;i<nodes.length;i++){
					if(source.id==nodes[i].id) continue;
					if((point=='top')&&(nodes[i].id==node.id)) idArr.push(source.id);
					idArr.push(nodes[i].id);
					if((point=='bottom')&&(nodes[i].id==node.id)) idArr.push(source.id);
				}
				if(idArr.length){
					var ret=$.cm({
						ClassName:'DHCDoc.Order.Fav',
						MethodName:'UpdateTreeSeq',
						ParNodeID:GetSubCatID(target),
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
				UpdateCatData();
				DroppableAccept($('div.fav-container:visible'));
			}
		});
		if(!$('#swUseType').switchbox('getValue')){
			$panle.bind('contextmenu',function(e){
				if($container.attr('id')){
					showTreeMenu(e);
				}
			});
			if(GetAuthFlag()){
				var $icon=$('<a></a>').addClass('fav-item-close').appendTo($container);
				$icon.linkbutton({
					plain:true,
					iconCls:'icon-remove'
				}).click(function(){
					var id=$container.attr('id')||'';
					if(id!=''){
						$.messager.confirm('提示','确定删除该子类?(其项目也将一并删除)',function(r){
							if(r){
								var ret=$.cm({
									ClassName:'DHCDoc.Order.Fav',
									MethodName:'DeleteTreeNode',
									Nodes:id,
									dataType:'text'
								},false);
								if(ret==0){
									$.messager.popover({msg:'删除成功',type:'success'});
									$container.remove();
									UpdateCatData();
								}else{
									$.messager.alert('提示','删除失败:'+ret);
									return;
								}
							}
						});
					}else{
						$container.remove();
						UpdateCatData();
					}
				});
				$title.dblclick(function(){
					if($container.attr('id')){
	                	if(!CheckBeforeEdit()) return false;
					}
					var $input=$('<input type="text" maxlength="10"/>').attr('required','required').val($(this).text()).keyup(function(e){
						if(e.keyCode==13){
							var title=$(this).val();
							if(title==''){
								$.messager.popover({msg:'请输入分类名字',type:'alert'});
								$(this).select();
								return false;
							}
							var tab=$('#tabFavCat').tabs('getSelected');
							var CatID=tab.panel('options').id;
							var ret=$.cm({
								ClassName:'DHCDoc.Order.Fav',
								MethodName:'SaveSubCat',
								ID:$container.attr('id')||'',
								CatID:CatID,
								Name:title, 
								UserID:session['LOGON.USERID'], 
								dataType:'text'
							},false);
							if(ret.split('^')[0]=='0'){
								var id=CatID+"_"+ret.split('^')[1];
								$container.attr('id',id);
								$title.html('<div class="panel-title">'+title+'</div>');
								$.messager.popover({msg:'保存成功',type:'success'});
								UpdateCatData();
							}else{
								$.messager.alert('提示',ret,'warning',function(){$title.find('input').select()});
							}
						}
						return false;
					});
					$title.html($input);
					$input.select();
				});
				if(!subCatData) $title.dblclick();
				$container.draggable({
					delay:300,
					revert:true,
					cursor:'pointer',
					proxy: function(source){
						var $proxy=$('<div></div>').html($(source).html());
						$proxy.find('a.fav-item-close').hide();
						return $proxy.appendTo('body');
					},
					onBeforeDrag:function(e){
						if(e.button==2) return false;
						if($(e.target).closest('.fav-container').children('.fav-title-div').find('input').size()) return false;
						if($(window.event.target).hasClass("tree-editor-icon")) return false;
						return CheckBeforeEdit();
					},
			        onStopDrag:function(e){
			            $(this).css({left:'',top:''});
			        }
				}).droppable({ 
					onDragOver:function(e,source){
						if($(source).hasClass('tree-node')){
							$(source).draggable("proxy").find("span.tree-dnd-icon").removeClass("tree-dnd-no").addClass("tree-dnd-yes");
							$(this).children('.fav-item-div').css({'border-right':'4px solid #aaa','border-left':'4px solid #aaa'});
						}else{
							var difX=window.event.pageX-$(this).offset().left;
							if(difX>($(this).width()/2)){
								$(this).children('.fav-item-div').css({'border-right':'4px solid #aaa','border-left':''});
							}else{
								$(this).children('.fav-item-div').css({'border-right':'','border-left':'4px solid #aaa'});
							}
						}
					},
					onDragLeave:function(e,source){
						if($(source).hasClass('tree-node')){
							$(source).draggable("proxy").find("span.tree-dnd-icon").removeClass("tree-dnd-yes").addClass("tree-dnd-no");
							$(this).children('.fav-item-div').css({'border-right':'4px solid #aaa','border-left':'4px solid #aaa'});
						}
						$(this).children('.fav-item-div').css({'border-left':'','border-right':''});
					},
					onDrop:function(e,source){
						var idArr=new Array();
						var ParNodeID='';
						if($(source).hasClass('tree-node')){
							var $targetTree=$(this).children('.fav-item-div').children('ul');
							if(!$targetTree.tree('options').onBeforeDrag.call($targetTree[0])){
								return;
							}
							var $sourceTree=GetTreeByNode(source);
							ParNodeID=$(this).attr('id');
							var node=$sourceTree.tree('getNode',source);
							var nodes=$targetTree.tree('getRoots');
							for(var i=0;i<nodes.length;i++){
								if(node.id==nodes[i].id) continue;
								idArr.push(nodes[i].id);
							}
							idArr.push(node.id);
						}else{
							var difX=window.event.pageX-$(this).offset().left;
							var difFlag=difX>($(this).width()/2);
							var tab=$('#tabFavCat').tabs('getSelected');
							var data=tab.panel('options').data;
							ParNodeID=data.id;
							var thisId=$(this).attr('id');
							for(var i=0;i<data.children.length;i++){
								var id=data.children[i].id;
								if(id==source.id) continue;
								if(!difFlag&&(thisId==id)){
									if(data.children[i-1]&&(source.id==data.children[i-1].id)){
										return false;	//位置未发生变化
									}
									idArr.push(source.id);
								}
								idArr.push(id);
								if(difFlag&&(thisId==id)){
									if(data.children[i+1]&&(source.id==data.children[i+1].id)){
										return false;	//位置未发生变化
									}
									idArr.push(source.id);
								}
							}
						}
						if(idArr.length){
							var ret=$.cm({
								ClassName:'DHCDoc.Order.Fav',
								MethodName:'UpdateTreeSeq',
								ParNodeID:ParNodeID||'',
								IDStr:JSON.stringify(idArr),
								dataType:'text'
							},false);
							if(ret=='0'){
								$.messager.popover({msg:"位置调整成功",type:'success'});
								if($(source).hasClass('tree-node')){
									RemoveTreeNode($('#'+node.domId)[0]);
									$targetTree.tree('append',{data:$.extend({},node,{target:null,domId:null})})
									DroppableAccept($container);
								}else{
									var index=$(source).index();
									$('#'+source.id).remove();
									if(difFlag){
										$(this).after(GetSubCatHtml(data.children[index]));
									}else{
										$(this).before(GetSubCatHtml(data.children[index]));
									}
									UpdateCatData();
								}
							}else{
								$.messager.popover({msg:"位置调整失败:"+ret,type:'error'});
							}
						}
					}
				});
				DroppableAccept($container);
			}
		}
		$container.click(function(){
			if($(this).hasClass('fav-selected')){
				$(this).removeClass('fav-selected');
				if($('#swUseType').switchbox('getValue')){
					$(this).find('.fav-item-div>ul').tree('unselectAll');
				}
			}else{
				$('.fav-selected').removeClass('fav-selected');
				$(this).addClass('fav-selected');
				if($('#swUseType').switchbox('getValue')){
					$('.fav-container').not(this).find('.fav-item-div>ul').tree('unselectAll');
					$(this).find('.fav-item-div>ul').tree('selectAll');
				}
			}
		})
		return $container;
	}
}
function DroppableAccept($obj)
{
	for(var i=0;i<$obj.size();i++){
		var $tree=$obj.eq(i).children('.fav-item-div').children('ul');
		var nodes=$tree.tree('getRoots');
		if(nodes.length){
			$obj.eq(i).droppable({accept:'div.fav-container'});
		}else{
			$obj.eq(i).droppable({accept:'div.fav-container,div.tree-node'});
		}
		$obj.children('.fav-item-div').css({'border-left':'','border-right':''});
	}
}
function UpdateCatData()
{
	setTimeout(function(){
		var tab=$('#tabFavCat').tabs('getSelected');
		var data=tab.panel('options').data;
		data.children=[];
		var $subcat=tab.panel('body').find('.fav-container');
		for(var i=0;i<$subcat.size();i++){
			var id=$subcat.eq(i).attr('id');
			var text=$subcat.eq(i).find('.fav-title-div').text();
			var itemData=$subcat.eq(i).find('ul.tree').tree('getRoots');
			data.children.push({id:id,text:text,children:itemData})
		}
	});
}
function CheckBeforeEdit(NotCheckAuth)
{
	if($('#swUseType').switchbox('getValue')) return false;
	if(!NotCheckAuth&&!GetAuthFlag()){
		$.messager.popover({msg:'没有'+GetCatTypeDesc()+'模板维护权限',type:'alert'});
		return false;
	}
	var editNodes=$('.fav-item-div>ul').tree('getEditingNodes');
	for(var i=editNodes.length-1;i>=0;i--){
		if(!editNodes[i].id){
			RemoveTreeNode($('#'+editNodes[i].domId)[0]);
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
	var $tab = $('#tabFavCat').tabs('getSelected');
    if($tab){
		$tab.find('.fav-title-div').find('input').each(function(){
			if(!$(this).val()&&!$(this).closest('.fav-container').attr('id')){
				$(this).closest('.fav-container').remove();
				UpdateCatData();
			}
		});
        if($tab.find('.fav-title-div').find('input').size()){
            $.messager.popover({msg:'请先完成未保存的子分类',type:'alert'});
            $tab.find('.fav-title-div').find('input').focus();
            return false;
        }
    }
	$("#tabFavCat").find('ul.tabs').nextAll('input').each(function(){
		if($(this).val()=="") $(this).remove();
	});
	if($("#tabFavCat").find('ul.tabs').nextAll('input').size()){
		$.messager.popover({msg:'请先完成未保存的分类',type:'alert'});
		$("#tabFavCat").find('ul.tabs').nextAll('input').focus();
		return false;
	}
	return true;
}
function GetSeletedNode()
{
	return $('.fav-item-div:visible>ul').tree('getSelected');
}
function GetSelectedSubCatID()
{
	return $('.fav-selected:visible').attr('id');
}
function GetEventItemID(e)
{
	e=e||window.event;
	if($(e.target).hasClass('tabs-inner')||$(e.target).parent().hasClass('tabs-inner')){
		var title=$(e.target).parent().find('.tabs-title').text();
		var tab=$('#tabFavCat').tabs('getTab',title);
		return tab?tab.panel('options').id:'';
	}
	if($(e.target).closest('[id]').hasClass('tree-node')){
		var nodeTarget=$(e.target).closest('[id]')[0];
		var node=GetTreeByNode(nodeTarget).tree('getNode',nodeTarget);
		return node.id;
	}
	return $(e.target).closest('[id]').attr('id');
}
function GetSubCatID(target)
{
	return $(target).parents('[id]').eq(0).attr('id');
}
function RemoveTreeNode(target)
{
	var $tree=GetTreeByNode(target);
	var ed=$tree.tree('getEditor',target);
	if(ed.size()) try{ed.lookup('hidePanel');}catch(e){}
	$tree.tree('remove',target);
	var nodes=$tree.tree('getRoots');
	if(!nodes.length){
		DroppableAccept($tree.closest('.fav-container'));
	}
}
function GetTreeByNode(target)
{
	return $(target).closest('ul.tree');
}
function showTreeMenu(e,node)
{
	e.stopPropagation();
	e.preventDefault();
	if($('#swUseType').switchbox('getValue')) return false;
	InitMenuItem();
    $('#menu').menu('show', {left: e.pageX,top: e.pageY});
	return false;
}
function InitMenu()
{
	$('#menu').menu({
		onClick:function(item){
			switch(item.id){
				case 'menu_add_item':
					var itemid=$('#menu').data('itemid');
					var idArr=itemid.split('_');
					var SubCatID=idArr[0]+'_'+idArr[1];
					$('#'+SubCatID).find('.fav-item-div ul').tree('addEditNode',null);
					break;
				case 'menu_copy_hosp':CopyTreeNode($('#menu').data('itemid'),'');break;
				case 'menu_copy_loc':CopyTreeNode($('#menu').data('itemid'),'');break;
				case 'menu_copy_user':CopyTreeNode($('#menu').data('itemid'),'');break;
				case 'menu_copy_otherloc':CopyTreeNode($('#menu').data('itemid'),'',$(item.target).attr('locid'));;break;
				case 'menu_delete':
					var deleteNodes=new Array(),deleteTarget=new Array();
					var nodes=GetSeletedNode();
					for(var i=0;i<nodes.length;i++){
						var target=$('#'+nodes[i].domId)[0];
						if(nodes[i].id) deleteNodes.push(nodes[i].id),deleteTarget.push(target);
						else RemoveTreeNode(target);
					}
					if(deleteNodes.length){
						$.messager.confirm('提示','是否删除选择项目?',function(r){
							if(r){
								var ret=$.cm({
									ClassName:'DHCDoc.Order.Fav',
									MethodName:'DeleteTreeNode',
									Nodes:JSON.stringify(deleteNodes),
									dataType:'text'
								},false);
								if(ret=='0'){
									$.messager.popover({msg:"删除成功",type:'success'});
									RemoveTreeNode(deleteTarget);
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
						    content:'<input id="_Note" type="text" class="textbox" style="width:270px;margin:20px 10px 5px 10px;" maxlength="20"/>',  
						    modal: true,
						    onBeforeOpen:function(){
								var NodeIDArr=new Array();
								var nodes=GetSeletedNode();
								for(var i=0;i<nodes.length;i++){
									if(nodes[i].id){
										NodeIDArr.push(nodes[i].id);
										if(nodes[i].attributes.itemid.indexOf('||')==-1){
											$.messager.popover({msg:'医嘱套项目不能填写备注',type:'alert'});
											return false;
										}
									}
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
										var nodes=GetSeletedNode();
										for(var i=0;i<nodes.length;i++){
											if(!nodes[i].id) continue;
											GetTreeByNode(nodes[i].target).tree('update',{
												target:nodes[i].target,
												attributes:$.extend(nodes[i].attributes,{note:Note})
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
function InitMenuItem()
{
	var nodes=GetSeletedNode();
	var itemid=GetEventItemID();
	$('#menu').data('itemid',itemid);
	var displayItem=new Array();
	var CatType=GetCatType();
	$('#menu').children('div[name="menucopy"]').each(function(){
		var key=$(this).attr('key');
		if(key==CatType) return true;
		var id=$(this).attr('id');
		if(ServerObj.FavAuth[key]){
			displayItem.push(id);
		}
	});
	displayItem.push('menu_copy_other');
	if(GetAuthFlag()){
		if(itemid.split('_').length>1){
			displayItem.push('menu_add_item');
			if(nodes.length) displayItem.push('menu_delete','menu_edit_note');
		}
	}
	$('#menu').children('div[id]').each(function(){
		if(displayItem.indexOf($(this).attr('id'))>-1){
			$('#menu').menu('showItem',this);
		}else{
			$('#menu').menu('hideItem',this);
		}
	});
	InitCopyMenu();
}
function InitCopyMenu()
{
	var itemid=$('#menu').data('itemid');
	var itemidArr=itemid.split('_');
	var nodes=GetSeletedNode();
	if(!nodes.length&&(itemidArr.length>2)) itemidArr.pop(),itemid=itemidArr.join('_');
	$('div[name="menucopy"]').each(function(){
		//if($(this).css('display')=='none') return true;
		$('#menu').menu('removeSubMenu',this);
		if(itemidArr.length<2) return true;
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
						CopyTreeNode(itemid,value.id,LocID);
					}
				});
				if(itemidArr.length<3) return true;
				var submenu=$('#menu').menu('getSubMenu',target);
				var subTarget=submenu.children("div.menu-item:last")[0];
				$.each(value.children,function(index, value){
					$('#menu').menu('appendItem', {
						parent:subTarget,
						text:value.text,
						onclick:function(){
							CopyTreeNode(nodes,value.id,LocID);
						}
					});
				});
			});
		});	
	});
}
function CopyTreeNode(FromNodeID,ToNodeID,LocID)
{
	if(!FromNodeID){
		$.messager.popover({msg:"无效复制项目",type:'alert'});
		return;
	}
	if(!LocID) LocID=session['LOGON.CTLOCID'];
	if($.isArray(FromNodeID)){ 
		var FromIDArr=new Array();
		for(var i=0;i<FromNodeID.length;i++)
			FromIDArr.push(FromNodeID[i].id);
		FromNodeID=JSON.stringify(FromIDArr);
	}
	var Type=ToNodeID==''?$(window.event.target).closest('[key]').attr('key'):'';
	var ret=$.cm({ 
		ClassName:"DHCDoc.Order.Fav",
		MethodName:"CopyTreeNode", 
		FromNodeID:FromNodeID,
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
	var SubCatID=GetSelectedSubCatID();
	if(!SubCatID){
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
	LoadCatTabs();
}
function AddItemToEntryGrid(nodes)
{
	if(!nodes) nodes=GetSeletedNode();
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
	$('.fav-item-div>ul').tree('unselectAll');
}