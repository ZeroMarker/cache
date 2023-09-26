/**
 * dhcant.kss.config.function.init.js - KJ Config Module DISPLAY CUSTOM
 * 
 * Copyright (c) 2016-2017 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2017-03-09
 * 
 */
(function(){
	var TabControl = function(){
		this.tabPanel = $("#tabPanel");
		this.nav = $("#nav");
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
				onClick:function(node){
					if(node.url && node.url.length > 0){
						_this.addBasdata(node.text,node.url,node.id,node.icon);
					}
				}
			});
			this.nav.tree({
				url:"dhcant.kss.config.request.csp?action=GeTreeFuncConfig&type=PARA",
				method:"get",
				lines:true,
				onClick:function(node){
					if(node.url && node.url.length > 0){
						_this.add(node.text,node.url,node.id,node.icon);
					}
				},
				onContextMenu: function(e, node){
					e.preventDefault();
					$('#tt').tree('select', node.target);
					$('#mm').menu('show', {
						left: e.pageX,
						top: e.pageY
					});
				}
			});
			this.tabBasedata.on("dblclick",".tabs-header a",function(){
				_this.closeBasedata($(this).find(".tabs-title").html());
			});
			this.tabPanel.on("dblclick",".tabs-header a",function(){
				_this.close($(this).find(".tabs-title").html());
			});
		},add:function(pTitle,pUrl,pId,pIcon){
			if(this.tabPanel.tabs("exists",pTitle)){
				this.tabPanel.tabs("select", pTitle);
			}else{
				this.tabPanel.tabs("add",{
					title:pTitle,
					content:'<iframe scrolling="no" frameborder="no"  src="' + pUrl + '" style="width:100%;height:100%"></iframe>',
					iconCls:pIcon || 'fa fa-gavel'
				});
			};
		},addBasdata:function(pTitle,pUrl,pId,pIcon){
			if(this.tabBasedata.tabs("exists",pTitle)){
				this.tabBasedata.tabs("select", pTitle);
			}else{
				this.tabBasedata.tabs("add",{
					title:pTitle,
					content:'<iframe scrolling="no" frameborder="no"  src="' + pUrl + '" style="width:100%;height:100%"></iframe>',
					iconCls:pIcon || 'fa fa-gavel'
				});
			};
		},close:function(pTitle){
			this.tabPanel.tabs("close",pTitle);
		},closeBasedata:function(pTitle){
			this.tabBasedata.tabs("close",pTitle);
		}
	});
	$(document).ready(function(){
		var Tab = new TabControl();
		Tab.init();
		var functionHomeUrl = "dhcant.kss.config.function.home.csp";
		var baseDataHomeUrl = "dhcant.kss.config.basedata.home.csp"
		Tab.tabPanel.tabs("add",{
			title:"ึ๗าณ",
			content:'<iframe scrolling="no" frameborder="no"  src="' + functionHomeUrl + '" style="width:100%;height:100%"></iframe>',
			iconCls:'fa fa-home'
		});
		Tab.tabBasedata.tabs("add",{
			title:"ึ๗าณ",
			content:'<iframe scrolling="no" frameborder="no"  src="' + baseDataHomeUrl + '" style="width:100%;height:100%"></iframe>',
			iconCls:'fa fa-home'
		});
	});
})();