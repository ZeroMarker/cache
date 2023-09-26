/**
 * dhcant.kss.config.function.app.js - KJ Config Module DISPLAY CUSTOM
 * 
 * Copyright (c) 2016-2017 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2017-03-09
 * 
 */
$(function(){
	
	var TabControl = function(){
		this.navBasedata = $("#nav-basedata");
		this.tabBasedata = $("#tabPanel-basedata");
	};
	
	$.extend(TabControl.prototype,{
		init:function(){
			var _this = this;
			this.navBasedata.tree({
				url:"dhcant.kss.config.request.csp?action=GeTreeBasedataType&type=PARA",
				method:"get",
				lines:true,
				autoNodeHeight:true,
				formatter:function(node){
					if (node.children){
						return node.text;
					}else{
						return "<div >"
								+"<div style='height:28px;line-height:28px;'>"+node.text+"</div>"
							+"</div>";
					}
					
				},
				onClick:function(node){
					if(node.url && node.url.length > 0){
						_this.addBasdata(node.text,node.url,node.id,node.icon);
					}
				}
			});
			this.tabBasedata.on("dblclick",".tabs-header a",function(){
				//_this.closeBasedata($(this).find(".tabs-title").html());
			});
		},addBasdata:function(pTitle,pUrl,pId,pIcon){
			if(this.tabBasedata.tabs("exists",pTitle)){
				this.tabBasedata.tabs("select", pTitle);
			}else{
				this.tabBasedata.tabs("add",{
					title:pTitle,
					closable:true,
					content:'<iframe scrolling="no" frameborder="no"  src="' + pUrl + '" style="width:100%;height:100%"></iframe>',
					iconCls:pIcon || ''
				});
			};
			showRightMenu(this.tabBasedata,pTitle,pUrl,pId,pIcon);
		},closeBasedata:function(pTitle){
			this.tabBasedata.tabs("close",pTitle);
		}
	});
	
	var Tab = new TabControl();
	Tab.init();
	var baseDataHomeUrl = "dhcant.kss.config.basedata.home.csp";
	Tab.tabBasedata.tabs("add",{
		title:"主页",
		content:'<iframe scrolling="no" frameborder="no"  src="' + baseDataHomeUrl + '" style="width:100%;height:100%"></iframe>',
		iconCls:'fa fa-home'
	});
	addRightMenuEvent(Tab.tabBasedata,"主页");
	/*
	$("#l-base-panel").panel({
		fit:true,
		//iconCls:'fa fa-paint-brush',
		//headerCls:'panel-header-gray',
		title:'基础数据维护',
		border:false,
		tools: [{   
			iconCls:'fa fa-refresh c-refresh', 
			handler:function(){
				$("#nav-basedata").tree('reload');
			}   
		  },{   
			iconCls:'layout-button-left',   
			handler:function(){
				$("#i-base-layout").layout('collapse','west');
			}   
		  }]

	});*/
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
