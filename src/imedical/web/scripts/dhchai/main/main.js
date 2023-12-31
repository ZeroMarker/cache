$(function () {
	$("#menuPanel", parent.document).remove();
	$(".navbarhead", parent.document).remove();
	//alert($(window).height()+";"+$(parent.document).height());
	var pH = $(parent.document).height();
	$("#centerPanel", parent.document).css({top: 0,height:$(parent.document).height()});
	if ($("#ext-gen14", parent.document)){  //协和版本HIS高度特殊处理
		$("#ext-gen14", parent.document).css({top: 0,height:$(parent.document).height()});
		$("#ext-gen20", parent.document).css({top: 0,height:$(parent.document).height()-2});
	}
	//8.02版本上方有蓝色条问题处理
	if  ($("div.panel.layout-panel.layout-panel-center")) {
		$("div.panel.layout-panel.layout-panel-center", parent.document).css({top: 0});
	}
	//加载菜单
	LoadMenu(GroupId,ProductID);
	//主菜单
	var data = [{
		"menuId": "91",
		"menuCode": "home",
		"menuDesc": "<i class=icon-home style=line-height:20px;padding-top:5px;padding-bottom:5px;> 主页</i>",
		"menuResource": "dhcma.hai.main.welcome.csp",
		"menuOrder": "1",
		"menuIcon": "home"
	}];
	showNavTab(data[0]['menuCode'], data[0]['menuDesc'], data[0]['menuResource'], data[0]['menuCode'], data[0]['menuIcon'], true);
	
	//testMoreTab();
	$("#chgDep").on('click', function(){
		var url="dhc.logon.otherloc.csp";
		var param='scrollbars=no,toolbar=no,width='+800+',height='+500+',top=100,left=200';
		openUrlWin(url,param);
	});
	$("#chgPwd").on('click', function(){
		var url="websys.default.csp?WEBSYS.TCOMPONENT=SSUser.EditPassword&ID="+USERID;
		var param='scrollbars=no,toolbar=no,width='+350+',height='+250+',top=200,left=400';
		openUrlWin(url,param);
	});
	
	var isResizing = false;	  //8.02版本谷歌下重复执行导致报错问题处理
	$(window).resize(function () {
		if (!isResizing) {
			$("#menuPanel", parent.document).remove();
			$(".navbarhead", parent.document).remove();
			$("#centerPanel", parent.document).css({top: 0,height:$(parent.document).height()});
			if ($("#ext-gen14", parent.document)){  //协和版本HIS高度特殊处理
				$("#ext-gen14", parent.document).css({top: 0,height:$(parent.document).height()});
				$("#ext-gen20", parent.document).css({top: 0,height:$(parent.document).height()-2});
			}
			//8.02版本上方有蓝色条问题处理
			if  ($("div.panel.layout-panel.layout-panel-center")) {
				$("div.panel.layout-panel.layout-panel-center", parent.document).css({top: 0,height:$(parent.document).height()});
			}
			var ifmId = $('iframe:visible').attr('id')
			iFrameHeight(ifmId);
	
			setTimeout(function () {
				isResizing = false;
			}, 100);
		}
		isResizing = true;
		
	});//自适应调整#MainFrame页面高度和宽度
});

///iframe自适应屏幕高度
function iFrameHeight(id) {
	var ifm = document.getElementById(id);
	if (ifm != null) {
		////父窗口也随着改变 myTabContent
		try {
			var bHeight = ifm.contentWindow.document.body.scrollHeight;
			var dHeight = ifm.contentWindow.document.documentElement.scrollHeight;
			var innerHeight = Math.min(bHeight, dHeight);
			var outerHeight = $(window).height()-80 ;
			ifm.height = outerHeight;
		} catch (e) {
			//console.error(e);
			ifm.height = $(window).height()-80;
		}
	}
}

///打开指定的页面
function displayNavTab(RowID) {
	
	$("#myTab").find("li").removeClass("active");
	$("#myTabContent").find(".tab-pane").removeClass("active");
	
	$("a[href='#content_" + RowID + "']").parent("li").addClass("active");
	$("#content_" + RowID).addClass("active");
	$("#li_" + RowID).addClass("active");
	//通过rowID找到左侧对应的子菜单，并给子菜单设定样式
	var ifm = document.getElementById('iframe_' + RowID);
	//debugger;
	if(ifm.attachEvent){
    ifm.attachEvent("onload", function(){
				if (ifm != null) {
				////父窗口也随着改变 myTabContent
				try {
					var bHeight = ifm.contentWindow.document.body.scrollHeight;
					var dHeight = ifm.contentWindow.document.documentElement.scrollHeight;
					var innerHeight = Math.min(bHeight, dHeight);
					var outerHeight = $(window).height()-80 ;
					ifm.height = outerHeight;
				} catch (e) {
					//console.error(e);
					ifm.height = $(window).height()-80;
				}
			}
		});
	}else{
		ifm.onload = function(){
			if (ifm != null) {
				////父窗口也随着改变 myTabContent
				try {
					var bHeight = ifm.contentWindow.document.body.scrollHeight;
					var dHeight = ifm.contentWindow.document.documentElement.scrollHeight;
					var innerHeight = Math.min(bHeight, dHeight);
					var outerHeight = $(window).height()-80 ;
					ifm.height = outerHeight;
				} catch (e) {
					//console.error(e);
					ifm.height = $(window).height()-80;
				}
			}
			//$.fn.dataTable.tables({visible: true, api: true}).columns.adjust();
		};
	}
}

///关闭Tab
function closeNavTab(RowID) {
	///如果关闭的是当前正打开的tab页，则需要先打开一个前面紧挨着的页面，然后再关闭
	if ($("#li_" + RowID).hasClass("active")) {
		var li = $("a[href='#content_" + RowID + "']").parent("li").prev();
		if(li.length>0)
		{
			//在下拉的隐藏里非最后一个
			var preRowID = li.attr("id").split("_")[1];
			displayNavTab(preRowID);
		}
		else
		{
			li = $("#myTab").children("li").last();
			if(li.length>0)
			{
				//
				var preRowID = li.attr("id").split("_")[1];
				displayNavTab(preRowID);
			}
		}
	}
	if (RowID != "home") {
		$("#li_" + RowID).remove();
		$("#content_" + RowID).remove();
		$('.nav-pills,.nav-tabs').tabdrop('layout');
	}
}

///横向导航的样式控制
function navTabStyle(RowID) {
	$("#li_" + RowID).find(".icon-remove").hover(
		function() {
			$(this).addClass("badge badge-danger");
		},
		function() {
			$(this).removeClass("badge badge-danger");
		}
	);

	$("#li_" + RowID).find(".fa-times").click(
		function() {
			closeNavTab(RowID);
		}
	);

	$("#li_" + RowID).click(
		function() {
			//通过rowID找到左侧对应的子菜单，并给子菜单设定样式
			//alert("click");
			//获取所有可见的表格			
			//$.fn.dataTable.tables({visible: true, api: true}).fnAdjustColumnSizing()
			//$.fn.dataTable.tables({visible: true, api: true}).columns.adjust();
			var iframes = document.getElementById('iframe_' + RowID);
			if (!iframes.contentWindow.document.body) {
				iframes.contentWindow.location.reload();
			} else {
				if (iframes.contentWindow.document.body.innerHTML.indexOf("dhccpmrunqianreport")>-1) {
					//iframes.contentWindow.location.reload();
				}	
			}
		}
	);
	$("#li_" + RowID).contextMenu('mm', {

		bindings: {
			'tabClose': function(t) {
				if (RowID == 'home') {} else {
					closeNavTab(RowID);
				}
			},
			'tabCloseOther': function(t) {
				//先清空下拉菜单 dropdown-menu_zyq
				$("#dropdown-menu_zyq").children("li").each(function(i, e) {
					$(e).remove();
				});
				$("#myTab").children("li").each(function(i, e) {
					
					if (e.id != "li_home" && e.id != "li_tabdrop" && e.id != "li_" + RowID) {
						$(e).remove();
					}
				});
				$("#myTabContent").children("div").each(function(i, e) {
					if (e.id != "content_home" && e.id != "content_" + RowID) {
						$(e).remove();
						
					}
				});
				displayNavTab(RowID);
			},
			'tabCloseAll': function(t) {
				//先清空下拉菜单 dropdown-menu_zyq
				$("#dropdown-menu_zyq").children("li").each(function(i, e) {
					$(e).remove();
				});
				$("#myTab").children("li").each(function(i, e) {
					//debugger
					if (e.id != "li_home" && e.id != "li_tabdrop") {
						$(e).remove();
					}
				});
				$("#myTabContent").children("div").each(function(i, e) {
					if (e.id != "content_home") {
						$(e).remove();
					}
				});
				displayNavTab("home");
			}
		}
	});
}

///点击左侧菜单出现此菜单对应的tab界面
function showNavTab(RowID, MenuName, URL, parentRowID, iconurl, canClose) {
	//debugger;
	var nav = $("#content_" + RowID).get(0);
	if (!iconurl) iconurl = 'bars';
	//debugger;
	if (!$.isEmptyObject(nav))
	{
		//先移除
		closeNavTab(RowID);
	}
	if (true) { //$.isEmptyObject(nav)检查是否已经存在打开的菜单
		var htm = '';
		htm += '<li id="li_' + RowID + '">';
		htm += '<a data-toggle="tab"  href="#content_' + RowID + '">';
		//htm += '<i class="ace-icon fa fa-' + iconurl + '"></i>';
		htm += MenuName;
		if (!canClose) {
			htm += '<i class="fa fa-times bigger-110" style="cursor:pointer;margin-left:5px;color:#e08374;"></i>';
			//htm += '<i class="fa fa-times bigger-110" style="cursor:pointer"></i>';
		}
		htm += '</a>';
		htm += '</li>';
		//$("#myTab").append(htm);  //  append prepend
		if(("li_"+RowID)=="li_home")
		{
			$("#myTab").append(htm);
		}
		else
		{
			$("#li_home").after(htm);
		}
				
		htm = '';
		htm += '<div id="content_' + RowID + '" class="tab-pane">';
		htm += '<iframe id="iframe_' + RowID + '" src="' + URL + '"  width="100%"  min-height="500px" frameborder="0" >';
		htm += '系统使用了框架技术，但是您的浏览器不支持框架，请升级您的浏览器以便正常访问。';
		htm += '</iframe>';
		htm += '</div>';
		$("#myTabContent").append(htm);

		navTabStyle(RowID);
	}
	displayNavTab(RowID);
	$('.nav-pills,.nav-tabs').tabdrop('layout');
}
//测试的菜单标签页
function testMoreTab()
{
	for(iTab=1;iTab<=10;iTab++)
	{
		var testDate = {
			"menuId": ""+iTab,
			"menuCode": "test"+iTab,
			"menuDesc": "菜单"+iTab,
			"menuResource": "three-column-width-auto-2.html",
			"menuOrder": "1"+iTab,
			"menuIcon": "home"
		};
		showNavTab(testDate['menuCode'], testDate['menuDesc'], testDate['menuResource'], testDate['menuCode'], testDate['menuIcon'], false);
	}
}

function openUrlWin(url,param) {
	window.parent.open(url,'new',param);
	//$("#iModal").modal({remote: doc});  
	//var params = "dialogWidth:"+ 800 +"px;dialogHeight:"+ 500 +"px;center:yes;status:no;help:no";  
	//window.parent.window.showModalDialog(doc,window.parent.window,params);  	
}

//加载菜单 暂支持3级菜单展示
function LoadMenu(GroupId,ProductID) {
	
	var objTxt=$.ajax({url:"dhcmed.main.loadmenus.csp?groupId=" + GroupId + "&parentId=0&proId="+ProductID,async:false,type:'post'});//ie8 不支持 JSON.parse     
	//var objJson = JSON.parse(objTxt.responseText);
	var objJson = eval('(' + objTxt.responseText + ')');
	var menuHtml = '';
	for (var i = 0; i < objJson.length; i++) {
		var menuId = objJson[i]['id'];
		var menuIcon = objJson[i]['iconCls'];
		var menuDesc = objJson[i]['text'];
		var menuUrl = "";  //链接地址
		var subMenu = objJson[i]['leaf'];
		if (!subMenu) {
			menuHtml += '<li role="presentation" class="dropdown dropdown-hover" id="li_parent_' + menuId + '">' +
			'<a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">' +
			menuDesc +
			'<span class="caret"></span></a>' +
			'<ul class="dropdown-menu" id="ul_parent_' + menuId + '">';
			for (var j = 0; j < objJson[i].children.length; j++) {
				var jmenuId = objJson[i].children[j]['id'];
				var jmenuIcon = objJson[i].children[j]['iconCls'];
				var jmenuDesc = objJson[i].children[j]['text'];
				var jmenuUrl = "";  //链接地址
				var jsubMenu = objJson[i].children[j]['leaf'];
				if (!jsubMenu) {
					menuHtml += '<li role="presentation" class="dropdown-submenu" id="li_parent_' + jmenuId + '">' +
					'<a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">' +
					jmenuDesc +
					'</a>' +
					'<ul class="dropdown-menu" id="ul_parent_' + jmenuId + '">';
					for (var jj = 0; jj < objJson[i].children[j].children.length; jj++) {
						var jjmenuId = objJson[i].children[j].children[jj]['id'];
						var jjmenuIcon = objJson[i].children[j].children[jj]['iconCls'];
						var jjmenuDesc = objJson[i].children[j].children[jj]['text'];
						var jjmenuUrl = "";  //链接地址
						var jjsubMenu = objJson[i].children[j].children[jj]['leaf'];
						if(jjsubMenu){
							jjmenuUrl = $.Tool.RunServerMethod("DHCMed.SSService.Main","GetMenuLinkUrl",jjmenuId);
							// add by zhoubo 2018-01-18 菜单操作权限无法获取
							if (jjmenuUrl!="") {
								jjmenuUrl = jjmenuUrl+"&menuId="+jjmenuId;
							}
							menuHtml += '<li id="ul_parent_' + jmenuId + ' role="presentation" class="dropdown dropdown-hover">' +
							'<a RowID="' + jjmenuId + '"  id="' + jjmenuId + '" href="#" onclick="showNavTab(\'' + jjmenuId + '\',\'' + jjmenuDesc + '\',\'' + jjmenuUrl + '\',\'' + jjmenuId + '\',\'' + jjmenuIcon + '\')">' +
							jjmenuDesc +
							'</a>' +
							'</li>';
						}
					}
					menuHtml += '</ul>'
					menuHtml += '</li>'
				}else {
					jmenuUrl = $.Tool.RunServerMethod("DHCMed.SSService.Main","GetMenuLinkUrl",jmenuId);
					// add by zhoubo 2018-01-18 菜单操作权限无法获取
					if (jmenuUrl!="") {
						jmenuUrl = jmenuUrl+"&menuId="+jmenuId;
					}
					menuHtml += '<li id="ul_parent_' + jmenuId + ' role="presentation" class="dropdown dropdown-hover">' +
					'<a RowID="' + jmenuId + '"  id="' + jmenuId + '" href="#" onclick="showNavTab(\'' + jmenuId + '\',\'' + jmenuDesc + '\',\'' + jmenuUrl + '\',\'' + jmenuId + '\',\'' + jmenuIcon + '\')">' +
					'<span>' + jmenuDesc + '</span>' +
					'</a>' +
					'</li>';
				}
			}
			menuHtml += '</ul>'
			menuHtml += '</li>'
		}else {
			menuUrl = $.Tool.RunServerMethod("DHCMed.SSService.Main","GetMenuLinkUrl",menuId);
			// add by zhoubo 2018-01-18 菜单操作权限无法获取
			if (menuUrl!="") {
				menuUrl = menuUrl+"&menuId="+menuId;
			}
			menuHtml += '<li id="ul_parent_' + menuId + ' role="presentation" class="dropdown">' +
			'<a RowID="' + menuId + '"  id="' + menuId + '" href="#" onclick="showNavTab(\'' + menuId + '\',\'' + menuDesc + '\',\'' + menuUrl + '\',\'' + menuId + '\',\'' + menuIcon + '\')">' +
			menuDesc +
			'</a>' +
			'</li>';
		}
	}
	$('#navmenu').html(menuHtml);
	
}
