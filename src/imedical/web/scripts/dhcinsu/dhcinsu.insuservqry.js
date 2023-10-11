/*
 * FileName:	dhcinsu.insuservqry.js
 * User:		DingSH
 * Date:		2021-01-08
 * Description: 医保常用服务查询(主JS)
 */
$(function() {
	/*window.onresize=function(){
    	location.reload();//页面进行刷新
 	} */
	tabCloseEven();
	$('.cs-navi-tab').click(function() {
		var $this = $(this);
		var href = $this.attr('src');
		var title = $this.text();
		addTab(title, href);
	});
	$('.layout-button-left').click(function() {
		$('#cc2').layout('collapse','west');
	});
    /**
	 * 增加选中侧菜单背景变色 2023/2/9 LUANZH
	 */
	$('#tabs').tabs({
 		onSelect: function(title,index){			
			if(title=='首页') {
				for(var i=0;i<box.length;i++) {
					box[i].style.background = 'white';
				}
			}
			var box = document.querySelectorAll('.cs-navi-tab');
			for(var i=0;i<box.length;i++) {
				box[i].style.background = 'white';
				if(box[i].text==title){
					box[i].style.background = '#E3E3E3';
				}
			}
		},
		onBeforeClose: function(title,index){
			var closable = document.querySelectorAll('.tabs-closable');	
			var box = document.querySelectorAll('.cs-navi-tab');
			if(closable.length==1) {
				for(var i=0;i<box.length;i++) {
					box[i].style.background = 'white';
				}
			}
		}
	}) 
});

function addTab(title, url){
	if ($('#tabs').tabs('exists', title)){
		$('#tabs').tabs('select', title);//选中并刷新
		var currTab = $('#tabs').tabs('getSelected');
		var url = $(currTab.panel('options').content).attr('src');
		if(url != undefined && currTab.panel('options').title != '首页') {
			$('#tabs').tabs('update',{
				tab:currTab,
				options:{
					content:createFrame(url)
				}
			})
		}
	} else {
		var content = createFrame(url);
		$('#tabs').tabs('add',{
			title:title,
			content:content,
			closable:true
		});
	}
	tabClose();
}
function createFrame(url) {
	//var urlrr=url+"?"+"INSUTYPE="+GV.INSUTYPE+"&INSUTYPEDESC="+GV.INSUTYPEDESC+"&INSUPLCADMDVS="+GV.INSUPLCADMDVS
	//alert("urlrr"+urlrr);
	var s = '<iframe scrolling="auto" frameborder="0" width="100%" height="100%" src="' + url + '"></iframe>';
	return s;
}
function tabClose() {
	/*双击关闭TAB选项卡*/
	$(".tabs-inner").dblclick(function(){
		var subtitle = $(this).children(".tabs-closable").text();
		$('#tabs').tabs('close',subtitle);
	})
	/*为选项卡绑定右键*/
	$(".tabs-inner").bind('contextmenu',function(e){
		$('#mm').menu('show', {
			left: e.pageX,
			top: e.pageY
		});
		var subtitle =$(this).children(".tabs-closable").text();
		$('#mm').data("currtab",subtitle);
		$('#tabs').tabs('select',subtitle);
		return false;
	});
}		
//绑定右键菜单事件
function tabCloseEven() {
	//刷新
	$('#mm-tabupdate').click(function(){
		var currTab = $('#tabs').tabs('getSelected');
		var url = $(currTab.panel('options').content).attr('src');
		if(url != undefined && currTab.panel('options').title != '首页') {
			$('#tabs').tabs('update',{
				tab:currTab,
				options:{
					content:createFrame(url)
				}
			})
		}
	})
	//关闭当前
	$('#mm-tabclose').click(function(){
		var currtab_title = $('#mm').data("currtab");
		$('#tabs').tabs('close',currtab_title);
	})
	//全部关闭
	$('#mm-tabcloseall').click(function(){
		$('.tabs-inner span').each(function(i,n){
			var t = $(n).text();
			if(t != '首页') {
				$('#tabs').tabs('close',t);
			}
		});
	});
	//关闭除当前之外的TAB
	$('#mm-tabcloseother').click(function(){
		var prevall = $('.tabs-selected').prevAll();
		var nextall = $('.tabs-selected').nextAll();		
		if(prevall.length>0){
			prevall.each(function(i,n){
				var t=$('a:eq(0) span',$(n)).text();
				if(t != 'Home') {
					$('#tabs').tabs('close',t);
				}
			});
		}
		if(nextall.length>0) {
			nextall.each(function(i,n){
				var t=$('a:eq(0) span',$(n)).text();
				if(t != 'Home') {
					$('#tabs').tabs('close',t);
				}
			});
		}
		return false;
	});
	//关闭当前右侧的TAB
	$('#mm-tabcloseright').click(function(){
		var nextall = $('.tabs-selected').nextAll();
		if(nextall.length==0){
			return false;
		}
		nextall.each(function(i,n){
			var t=$('a:eq(0) span',$(n)).text();
			$('#tabs').tabs('close',t);
		});
		return false;
	});
	//关闭当前左侧的TAB
	$('#mm-tabcloseleft').click(function(){
		var prevall = $('.tabs-selected').prevAll();
		if(prevall.length==0){
			return false;
		}
		prevall.each(function(i,n){
			var t=$('a:eq(0) span',$(n)).text();
			$('#tabs').tabs('close',t);
		});
		return false;
	});
	//退出
	$("#mm-exit").click(function(){
		$('#mm').menu('hide');
	})
}

