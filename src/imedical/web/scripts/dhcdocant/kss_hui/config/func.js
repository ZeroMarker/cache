/**
 * dhcant.kss.config.func.js - KJ Config Module DISPLAY CUSTOM
 * 
 * Copyright (c) 2016-2017 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2017-03-09
 * 
 */
$(function(){
	
	var TabControl = function(){
		this.tabPanel = $("#tabPanel");
		this.nav = $("#nav");
		this.navOS = $("#navOS");
	};
	
	$.extend(TabControl.prototype,{
		init:function(){
			var _this = this;
			this.nav.tree({
				//url:"dhcant.kss.config.request.csp?action=GeTreeFuncConfigNew&type=PARA",
				url:"dhcant.kss.config.request.csp?action=GetBaseTree&type=PARA",
				method:"get",
				//lines:true,
				border:false,
				animate:true,
				onClick:function(node){
					if(node.url && node.url.length > 0){
						_this.add(node.text,node.url,node.id,node.icon);
					}
					//toggleTree(_this,node);
				}
				/*,onContextMenu: function(e, node){
					e.preventDefault();
					$('#tt').tree('select', node.target);
					$('#mm').menu('show', {
						left: e.pageX,
						top: e.pageY
					});
				}*/
			});
			this.navOS.tree({
				//url:"dhcant.kss.config.request.csp?action=GeTreeFuncConfigNew&type=PARA",
				url:"dhcant.kss.config.request.csp?action=GetOSTree&type=PARA",
				method:"get",
				//lines:true,
				border:false,
				animate:true,
				onClick:function(node){
					if(node.url && node.url.length > 0){
						_this.add(node.text,node.url,node.id,node.icon);
					}
					//toggleTree(_this,node);
				}
				/*,onContextMenu: function(e, node){
					e.preventDefault();
					$('#tt').tree('select', node.target);
					$('#mm').menu('show', {
						left: e.pageX,
						top: e.pageY
					});
				}*/
			});
			this.tabPanel.on("dblclick",".tabs-header a",function(){
				//_this.close($(this).find(".tabs-title").html());
			});
		},add:function(pTitle,pUrl,pId,pIcon){
			if(this.tabPanel.tabs("exists",pTitle)){
				this.tabPanel.tabs("select", pTitle);
			}else{
				this.tabPanel.tabs("add",{
					title:pTitle,
					closable:true,
					content:setPageContent(pUrl),
					iconCls:pIcon || ''
				});
			};
			showRightMenu(this.tabPanel,pTitle,pUrl,pId,pIcon);
		},close:function(pTitle){
			this.tabPanel.tabs("close",pTitle);
		}
	});
	
	var Tab = new TabControl();
	Tab.init();
	var functionHomeUrl = "dhcant.kss.config.function.home.csp";
	Tab.tabPanel.tabs("add",{
		title:"主页",
		content:setPageContent(functionHomeUrl),
		iconCls:'fa fa-home'
	});
	
	addRightMenuEvent(Tab.tabPanel,"主页");
})

function showRightMenu(tabPanel,pTitle,pUrl,pId,pIcon) {
	
	$(".tabs-inner").dblclick(function(){
		var subtitle = $(this).children(".tabs-closable").text();
		tabPanel.tabs('close',subtitle);
	})
	
	$(".tabs-inner").bind('contextmenu',function(e){
		var subtitle =$(this).children(".tabs-closable").text();
		if (subtitle == "") return;
		$('#mm').menu('show', {
			left: e.pageX,
			top: e.pageY
		});
		$('#mm').data("currtab",subtitle);
		tabPanel.tabs('select',subtitle);
		return false;
	});
}	

function setPageContent(url) {
	var s = '<iframe scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
	return s;
}

function addRightMenuEvent(tabPanel,homeTitle) {
	//刷新页签
	$('#mm-tabupdate').click(function(){
		var currTab = tabPanel.tabs('getSelected');
		var url = $(currTab.panel('options').content).attr('src');
		if(url != undefined && currTab.panel('options').title != 'Home') {
			tabPanel.tabs('update',{
				tab:currTab,
				options:{
					content:setPageContent(url)
				}
			})
		}
	})
	//关闭当前
	$('#mm-tabclose').click(function(){
		var currtab_title = $('#mm').data("currtab");
		tabPanel.tabs('close',currtab_title);
	})
	//全部关闭
	$('#mm-tabcloseall').click(function(){
		$('.tabs-inner span').each(function(i,n){
			var t = $(n).text();
			if(t != homeTitle) {
				tabPanel.tabs('close',t);
			}
		});
	});
	//关闭其他
	$('#mm-tabcloseother').click(function(){
		var subtitle = $('.tabs-selected').find(".tabs-closable").text();
		var prevall = $('.tabs-selected').prevAll();
		var nextall = $('.tabs-selected').nextAll();		
		if(prevall.length>0){
			prevall.each(function(i,n){
				var t=$('a:eq(0) span',$(n)).text();
				if(t != homeTitle) {
					tabPanel.tabs('close',t);
				}
			});
		}
		if(nextall.length>0) {
			nextall.each(function(i,n){
				var t=$('a:eq(0) span',$(n)).text();
				if(t != homeTitle) {
					tabPanel.tabs('close',t);
				}
			});
		}
		tabPanel.tabs('select',subtitle);
		return false;
	});
}

function toggleTree(tbj,node) {
	var isLeaf = tbj.nav.tree('isLeaf', node.target)
	if (!isLeaf) {
		tbj.nav.tree('toggle',node.target);
		var roots = tbj.nav.tree("getRoots");
		for (var i=0; i<roots.length; i++) {
			var cnode = roots[i];
			if (node != cnode) {
				tbj.nav.tree('collapse',cnode.target);
			}
		}
	};
}
	