$(function(){
    ExendHISUI();
	InitUseType();
    InitFavType();
	InitMenu();
	InitEvent();
    InitEventCommon();
})
function InitEventCommon()
{
    $(window).keyup(function(e){
		if($('#swUseType').switchbox('getValue')&&(e.keyCode==13)){
			AddItemToEntryGrid();
		}
	});
    if(!ServerObj.EditMode){
		$('#BSearchShow').popover({
			trigger:'manual',
			width:255,
			closeable:true,
			content:'<input id="searchTemp" type="text" class="textbox" onkeyup="SearchTempHandle()" placeholder="'+$g('请输入大类、子类、项目别名...')+'" style="width:200px;"/>',
			onShow:function(){
				setTimeout(function(){$('#searchTemp').select();},50);
			},
			onHide:function(){
				$('#searchTemp').val("");
				SearchTempHandle();
			}
		}).click(function(){
			$('#BSearchShow').popover('show');
		});
	}
}

var SearchTimer;
function SearchTempHandle()
{
	clearTimeout(SearchTimer);
	SearchTimer=setTimeout(function(){
		LoadTemplateData();
	},300);
}
function InitUseType()
{
	$('#swUseType').switchbox({
		onText:$g('使用'),
        offText:$g('维护'),
        onClass:'primary',
        offClass:'info',
		size:'small',
		checked:!ServerObj.EditMode,
        onSwitchChange:function(e,obj){
			if($('#BSearchShow').size()){
				$('#searchTemp').val('');
				if(obj.value) $('#BSearchShow').show();
				else $('#BSearchShow').hide();
				$('#BSearchShow').popover('hide');
			}
			LoadTemplateData();
			if(parent.TemplateModeChange) parent.TemplateModeChange(obj.value);
        }
	});
	$('#swXCONTEXT').switchbox({
		onText:$g('西药模板'),
        offText:$g('草药模板'),
        onClass:'primary',
        offClass:'info',
		size:'small',
        onSwitchChange:function(e,obj){
	        ServerObj.CONTEXT=$('#swXCONTEXT').switchbox('getValue')?'WNewOrderEntry':'W50007';
			LoadTemplateData();
        }
	});
	if(ServerObj.EditMode){
		$('#swUseType').hide(); 
	}else{
		$('#swXCONTEXT').hide(); 
	}
}
function InitFavType()
{
	$.cm({
		ClassName:'DHCDoc.Order.Fav',
		MethodName:'GetFavTypeJSON',
		CONTEXT:ServerObj.CONTEXT, 
		LocID:session['LOGON.CTLOCID'],
		UserID:session['LOGON.USERID'],
		EditMode:!$('#swUseType').switchbox('getValue')?'Y':''
	},function(FavTypeData){
	    $("#kwFavType").keywords({
	        singleSelect:true,
	        items:FavTypeData,
	        onClick:LoadTemplateData
	    });
		InitFavTree();
	});
}
function InitItemLookUp(target,that)
{
	var ed=$(that).tree('getEditor',target);
	ed.lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'ARCIMDesc',
		fitColumns:true,
        columns:[[  
			{field:'HIDDEN',hidden:true},
			{field:'ARCIMDesc',title:'医嘱名称',width:320},
			{field:'subcatdesc',title:'子类',width:80},
			{field:'ItemPrice',title:'价格',width:50},
			{field:'billuom',title:'计价单位',width:60}
        ]],
        pagination:true,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
		panelWidth:600,
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCDocOrderEntry',QueryName: 'LookUpItem'},
        onBeforeLoad:function(param){
	        if (param.q=='') return false;
			var CMFlag=ServerObj.CONTEXT=="W50007"?"CM":'XY';
			var NonFormulary="NonFormAndBrand"+"^"+CMFlag;
			param = $.extend(param,{Item:param.q,GroupID:session['LOGON.GROUPID'],Category:'',SubCategory:'',TYPE:'',OrderDepRowId:'', OrderPriorRowId:'', EpisodeID:"", BillingGrp:'', BillingSubGrp:'', UserRowId:session["LOGON.USERID"], OrdCatGrp:'', NonFormulary:NonFormulary, Form:session['LOGON.CTLOCID']});
	    },
		onSelect:function(index,row){
			row.PartInfo='';
			if(row.HIDDEN2=="ARCIM"){
				var ARCIMRowid=row.HIDDEN;
				if('1'==tkMakeServerCall('web.DHCDocOrderCommon','GetItemServiceFlag',ARCIMRowid))
					if('1'==tkMakeServerCall('web.DHCAPPInterface','isExistPart',ARCIMRowid)){
						var ChooseFlag=false;
						websys_showModal({
							iconCls:'icon-w-pen-paper',
							url:"dhcapp.appreppartwin.csp?itmmastid="+ARCIMRowid,
							title:row.ARCIMDesc+$g(' 部位选择'),
							width:1200,height:700,
							CallBackFunc:function(reppartStr){
								ChooseFlag=true;
								row.PartInfo=reppartStr.split("^").slice(1).join("*");
								row.PartInfo=row.PartInfo.split("@").join(",");
								$(that).tree('endEditNew',target);
							},
							onClose:function(){
								if(!ChooseFlag) $(that).tree('endEditNew',target);
							}
						});
						return;
					}
			}
			$(that).tree('endEditNew',target);
		}
    });
	//tree编辑框初始化控件显示BUG处理
	ed.parent().css({height:'28px'});
	ed.css({position:'absolute',top:'2px',height:'28px'}).next().css({position:'absolute',right:'8px'}).children().css({height:'28px'});
	ed.select();
	$('<div></div>').addClass('icon-back tree-editor-icon').insertAfter(ed).click(function(e){
		e.stopPropagation();
		var node=$(that).tree('getNode',target);
		if(node.id){
			var ed=$(that).tree('getEditor',target);
			if(ed.size()) try{ed.lookup('hidePanel');}catch(e){}
			$(that).tree('cancelEdit',target);
		}else{
			RemoveTreeNode(target);
		}
		return false;
	});
}
function GetCatType()
{
	return "User."+$("#kwFavType").keywords('getSelected')[0].id;
}
function GetCatTypeDesc()
{
	return $("#kwFavType").keywords('getSelected')[0].text;
}
function GetAuthFlag()
{
	var CatType=GetCatType();
	return ServerObj.FavAuth[CatType];
}
function xhrRefresh(obj)
{
	$.extend(ServerObj,obj);
	LoadTemplateData();
	history.pushState("", "", rewriteUrl(window.location.href,ServerObj));
}
function ExendHISUI()
{
	$.extend($.fn.keywords.methods, { 
		append:function(jq,item){
			return jq.each(function(){
				var opts = $.data(this, 'keywords').options;
				opts.items.push(item);
				$(this).children('ul.keywords').append('<li id="'+(item.id||item.text)+'" rowid="'+(opts.items.length-1)+'"><a>'+item.text+'</a></li>');
			});
		},
		addCloseICON:function(jq,id){
			return jq.each(function(){
				var opts = $.data(this, 'keywords').options;
				var $li=(id==undefined)?$(this).children('ul.keywords').children('li'):$(this).children('ul.keywords').children('li#'+id);
				$li.each(function(){
					var that=this;
					var item=opts.items[$(that).index()];
					$('<div></div>').addClass('icon-close').appendTo($(that)).click(function(e){
						e.preventDefault();
						if(opts.onClose) opts.onClose.call(that,item);
						return false;
					});
				})
			});
		}
	});
	$.extend($.fn.tree.methods, { 
		unselectAll:function(jq){
			return jq.each(function(){  
				$(this).find("div.tree-node-selected").removeClass('tree-node-selected');
			});
		}, 
		getLevel:function(jq, target){  
			var id=jq.tree('getNode',target).id;
			if(id) return id.split('_').length;
			return ReculParNode(target,0);
			function ReculParNode(target,level){
				var parNode=jq.tree('getParent',target);
				return parNode?ReculParNode($('#'+parNode.domId)[0],++level):++level;
			}
		},
		addEditNode:function(jq,parTarget){
			return jq.each(function(){  
				$(this).tree('append',{parent:parTarget,data:[{id:'',text:''}]});
				if(parTarget){
					var parNode=$(this).tree('getNode',parTarget)
					var node=parNode.children[parNode.children.length-1];
				}else{
					var roots=$(this).tree('getRoots');
					var node=roots[roots.length-1];
				}
				$(this).tree('beginEditNew',$('#'+node.domId)[0]);
				if(!$(this).tree('getEditor',$('#'+node.domId)[0]).size()){
					RemoveTreeNode($('#'+node.domId)[0]);
				}
			});
		},
		beginEditNew:function(jq,target){
			return jq.each(function(){
				var node=$(this).tree('getNode',target);
				var opts=$(this).tree('options');
				if(opts.onBeforeEditNew){
					if(opts.onBeforeEditNew.call(this,node)==false){
						return true;
					}
				}
				$(this).tree('beginEdit',target).tree('scrollTo',target);
				var ed=$(this).tree('getEditor',target);
				ed.unbind('blur').unbind('keydown');	//移除HISUI自带事件
				ed.css({width:$(target).width()-ed.position().left-5});
				if(opts.onBeginEdit) opts.onBeginEdit.call(this,node);
			});
		},
		endEditNew:function(jq,target){
			return jq.each(function(){
				var opts=$(this).tree('options');
				if(opts.onEndEdit){
					var node=$(this).tree('getNode',target);
					if(opts.onEndEdit.call(this,node)==false){
						return true;
					}
				}
				$(this).tree('endEdit',target);
			});
		},
		getEditor:function(jq,target){
			return $(target).find('input.tree-editor');
		},
		getEditingNodes:function(jq){
			var nodes=new Array();
			jq.each(function(){
				var eds=$(this).find('input.tree-editor');
				for(var i=0;i<eds.size();i++){
					var target=eds.eq(i).closest('.tree-node')[0];
					var node=$(this).tree('getNode',target);
					if(!node) continue;
					nodes.push(node);
				}
			});
			return nodes;
		},
		getSelected:function(jq){
			var nodeArr=new Array();
			for(var i=0;i<jq.length;i++){
				var $tree=jq.eq(i);
				var $node=$tree.find("div.tree-node-selected:visible");
				for(var j=0;j<$node.length;j++){
					var node=$tree.tree('getNode',$node[j]);
					nodeArr.push(node);
				}
			}
			return nodeArr;
		},
		select:function(jq,target){
			return jq.each(function(){
				var opts = $(this).tree('options');
				var node=$(this).tree('getNode',target);
				if (opts.onBeforeSelect.call(this, node) == false) {
					return;
				}
				if(opts.singleSelect){
					$(this).find("div.tree-node-selected").removeClass("tree-node-selected");
				}
				$(target).addClass("tree-node-selected");
        		opts.onSelect.call(this, node);
			});
		},
		selectAll:function(jq){
			return jq.each(function(){
				var target=this;
				var roots=$(target).tree('getRoots');
				RecurSelectTree(roots);
				function RecurSelectTree(data){
					for(var i=0;i<data.length;i++){
						$(target).tree('select',data[i].target);
						if(data.children) RecurSelectTree(data.children);
					}
				}
			});
		},
		unselect:function(jq,target){
			return jq.each(function(){
				$(target).removeClass("tree-node-selected");
			});
		},
		isSelected:function(jq,target){
			return $(target).hasClass('tree-node-selected');
		}
	});
	$.extend($.fn.tree.defaults,{
		singleSelect:true,
		onLoadSuccess:function(){
			var $tree=$(this);
			$tree.unbind('click').bind('click',function(e){
				var tt = $(e.target);
				var $node = tt.closest("div.tree-node");
				if (!$node.length) {
					return;
				}
				var node=$tree.tree('getNode',$node[0]);
				if (tt.hasClass("tree-hit")) {
					if(node.state=='open') $tree.tree('collapse',$node[0]);
					else $tree.tree('expand',$node[0]);
					return false;
				} else {
					if (tt.hasClass("tree-checkbox")) {
						if(node.checked) $tree.tree('uncheck',$node[0]);
						else $tree.tree('check',$node[0]);
						return false;
					} else {
						var opts = $tree.tree('options');
						if (!$node.hasClass('tree-node-selected')&&opts.onBeforeSelect.call($tree[0], node) == false) {
							return false;
						}
						if(e.shiftKey){
							var $brother=null;
							if($node.parent().nextAll().children("div.tree-node-selected").length){
								$brother=$node.parent().nextUntil($node.parent().nextAll().children("div.tree-node-selected").parent()).children('div.tree-node');
							}else if($node.parent().prevAll().children("div.tree-node-selected").length){
								$brother=$node.parent().prevUntil($node.parent().prevAll().children("div.tree-node-selected").parent()).children('div.tree-node');
							}
							if($brother){
								$brother.each(function(){
									$(this).addClass("tree-node-selected");
									var newNode=$tree.tree('getNode',this);
									opts.onSelect.call($tree[0], newNode);
								});
							}
							$node.addClass("tree-node-selected");
						}else{
							var singleSelect=opts.singleSelect?!e.ctrlKey:e.ctrlKey;
							if(singleSelect) $tree.find("div.tree-node-selected").not($node).removeClass("tree-node-selected");
							if($node.hasClass("tree-node-selected")){
								$node.removeClass("tree-node-selected");
							}else{
								$node.addClass("tree-node-selected");
							}
						}
						if($node.hasClass("tree-node-selected")){
							opts.onSelect.call($tree[0], node);
						}else{
							if(opts.onUnselect) opts.onUnselect.call($tree[0], node);
						}
						opts.onClick.call($tree[0], node);
					}
				}
				e.preventDefault();
				e.stopPropagation();
				return false;
			});
			$tree.find('.tree-node').overflowtip();
		}
	});
	$.extend($.fn.menu.methods, {    
		showItem:function(jq, itemEl){    
			return jq.each(function(){
				if($.isArray(itemEl)){
					for(var i=0;i<itemEl.length;i++)
						$(itemEl[i]).show().next('.menu-sep').show();  
				}else{
					$(itemEl).show().next('.menu-sep').show();  
				}  
				$(this).menu('resize');
			});    
		},
		hideItem:function(jq, itemEl){    
			return jq.each(function(){
				if($.isArray(itemEl)){
					for(var i=0;i<itemEl.length;i++)
						$(itemEl[i]).hide().next('.menu-sep').hide();  
				}else{
					$(itemEl).hide().next('.menu-sep').hide();  
				}
				$(this).menu('resize');    
			});    
		},
		resize:function(jq){    
			return jq.each(function(){  
				var height=0;
				$(this).children('.menu-item').each(function(){
					if($(this).css('display')!='none'){
						height+=$(this).outerHeight();
					}
				});
				$(this).height(height).next('.menu-shadow').height(height+2);  
			});    
		},
		removeSubMenu:function(jq,target){
			return jq.each(function(){  
				if(target.submenu){
					if(target.submenu[0].shadow){
						target.submenu[0].shadow.remove();
					}
					target.submenu.remove();
					delete target.submenu;
				}
			});
		},
		getSubMenu:function(jq,target){
			return target.submenu;
		}
	}); 
	$.extend($.fn.tabs.methods, {
		clearTabs: function(jq){    
			return jq.each(function(){ 
				var opts=$(this).tabs('options');
				var onSelect=opts.onSelect;
				var onBeforeClose=opts.onBeforeClose;
                var onBeforeSelect=opts.onBeforeSelect;
				opts.onSelect=function(){};
                opts.onBeforeSelect=function(){};
				opts.onBeforeClose=function(){};
				var length=$(this).tabs('tabs').length;
				for(var i=length;i>0;i--){
					$(this).tabs('close',i-1);
				}
				opts.onSelect=onSelect;
				opts.onBeforeClose=onBeforeClose;
                opts.onBeforeSelect=onBeforeSelect;
			});    
		}    
	}); 
	$.fn.overflowtip = function(){
		var that=this;
        return this.tooltip({
			position:'top',
			content:'',
			onShow:function(){
                if((this.clientWidth<this.scrollWidth)&&!$(this).find('input').size()){
                    var content=$(this).children('.tree-title').html();
					$(this).tooltip('tip').css({'width':that.width()})
					$(this).tooltip('tip').show();
					$(this).tooltip('update',content).tooltip('reposition');
                }else{
                    $(this).tooltip('tip').hide();
                }
			}
		});
    };
}
