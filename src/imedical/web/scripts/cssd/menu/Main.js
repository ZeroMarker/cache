function banBackSpace(e) {
	var ev = e || window.event;
	// 获取event对象
	var obj = ev.target || ev.srcElement;
	// 获取事件源
	var t = obj.type || obj.getAttribute('type');
	// 获取事件源类型
	// 获取作为判断条件的事件类型
	var vReadOnly = obj.readOnly;
	var vDisabled = obj.disabled;
	// 处理undefined值情况
	vReadOnly = (vReadOnly == undefined) ? false : vReadOnly;
	vDisabled = (vDisabled == undefined) ? true : vDisabled;
	// 当敲Backspace键时，事件源类型为密码或单行、多行文本的，
	// 并且readOnly属性为true或disabled属性为true的，则退格键失效
	var flag1 = ev.keyCode == 8 && (t == 'password' || t == 'text' || t == 'textarea') && (vReadOnly == true || vDisabled == true);
	// 当敲Backspace键时，事件源类型非密码或单行、多行文本的，则退格键失效
	var flag2 = ev.keyCode == 8 && t != 'password' && t != 'text' && t != 'textarea';
	// 判断
	if (flag2 || flag1) return false;
}
// 禁止退格键 作用于Firefox、Opera
document.onkeypress = banBackSpace;
// 禁止退格键 作用于IE、Chrome
document.onkeydown = banBackSpace;

function CreateFrame(url) {
	if (url.indexOf('MWToken') <= 0) {
		if (url.indexOf('?') <= 0) {
			url += '?MWToken=' + websys_getMWToken();
		} else {
			url += '&MWToken=' + websys_getMWToken();
		}
	}
	var s = '<iframe scrolling="auto" frameborder="0" src="' + url + '" style="width:100%;height:98%;"></iframe>';
	return s;
}

/**
 * 判断MWToken方法是否存在
 * websys_getMWToken()获得当前界面或顶层界面的 MWToken 值
 * websys_writeMWToken(url)把当前界面或顶层界面的 MWToken 参数写入 url 中
 */
if (typeof websys_getMWToken === 'undefined') {
	websys_getMWToken = function() {
		return '';
	};
}
if (typeof websys_writeMWToken === 'undefined') {
	websys_writeMWToken = function(url) {
		return url;
	};
}

// /涉及 外部调用  拿出来
function addTab(title, url) {
	if ($('#tabs').tabs('exists', title)) {
		var oldTabTitle = $('#tabs').tabs('getSelected').panel('options').title;	// 获取之前菜单
		$('#tabs').tabs('select', title);	// 选中当前菜单
		if (url.indexOf('MENU') > 0) {	// 跳转界面刷新
			return;
		}
		var currTab = $('#tabs').tabs('getSelected');
		if (url != undefined && currTab.panel('options').title != '首页') {
			$('#tabs').tabs('update', {
				tab: currTab,
				options: {
					content: CreateFrame(url)
				}
			});
		}
	} else {
		var content = CreateFrame(url);
		$('#tabs').tabs('add', {
			title: title,
			content: content,
			closable: true
		});
	}
}

var Main = function() {
	$('#menus').tree({
		onClick: function(node) {
			if (node.myhref) {
				var tabTitle = node.text;
				var url = node.myhref;
				addTab(tabTitle, url);
			} else if (node.state == 'closed') {
				var Siblings = $(node.target).parent().siblings();
				for (var i = 0, Len = Siblings.length; i < Len; i++) {
					var NodeTarget = Siblings[i].children[0];
					var IsLeaf = $(this).tree('isLeaf', NodeTarget);
					if (IsLeaf === false) {
						$(this).tree('collapseAll', NodeTarget);
					}
				}
				$(this).tree('expand', node.target);
			} else if (node.state == 'open') {
				$(this).tree('collapse', node.target);
			}
		}
	});

	$HUI.searchbox('#Filter', {
		prompt: '菜单搜索',
		searcher: function(value, name) {
			$.cm({
				ClassName: 'web.CSSDHUI.Main.Menu',
				MethodName: 'ShowBarJson',
				id: menusid,
				filter: value
			}, function(data) {
				$('#menus').tree('loadData', data);
			});
		}
	});
	// 获取一级菜单
	var menusArr = $.cm({
		ClassName: 'web.CSSDHUI.Main.Menu',
		MethodName: 'ShowBarJson',
		id: '1'
	}, false);
	var menusid = menusArr[0].id;
	// 获取二级菜单
	$.cm({
		ClassName: 'web.CSSDHUI.Main.Menu',
		MethodName: 'ShowBarJson',
		id: menusid
	}, function(data) {
		$('#menus').tree('loadData', data);
	});
	function tabClose() {
		/* 双击关闭TAB选项卡*/
		$('.tabs-header').on('dblclick', '.tabs-inner', function() {
			var subtitle = $(this).children('.tabs-closable').text();
			$('#tabs').tabs('close', subtitle);
		}).on('contextmenu', '.tabs-inner', function(e) {
			e.preventDefault();
			var subtitle = $(this).children('.tabs-title').text();
			// 做一些右键菜单的禁用启用
			if (subtitle == '工作台') {
				$('#mm').menu('disableItem', $('#mm-tabupdate')[0]);
				$('#mm').menu('disableItem', $('#mm-tabclose')[0]);
			} else {
				$('#mm').menu('enableItem', $('#mm-tabupdate')[0]);
				$('#mm').menu('enableItem', $('#mm-tabclose')[0]);
			}

			var leftnum = $('.tabs-selected').prevAll().length;
			if (leftnum > 1) { // 有个首页 要大于1
				$('#mm').menu('enableItem', $('#mm-tabcloseleft')[0]);
			} else {
				$('#mm').menu('disableItem', $('#mm-tabcloseleft')[0]);
			}
			var rightnum = $('.tabs-selected').nextAll().length;
			if (rightnum > 0) {
				$('#mm').menu('enableItem', $('#mm-tabcloseright')[0]);
			} else {
				$('#mm').menu('disableItem', $('#mm-tabcloseright')[0]);
			}

			if (leftnum > 1 || rightnum > 0) {
				$('#mm').menu('enableItem', $('#mm-tabcloseother')[0]);
			} else {
				$('#mm').menu('disableItem', $('#mm-tabcloseother')[0]);
			}
			$('#mm').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
			$('#mm').data('currtab', subtitle);
			$('#tabs').tabs('select', subtitle);
			return false;
		});
	}
	// 绑定右键菜单事件
	var tabCloseEven = function() {
		// 刷新
		$('#mm-tabupdate').click(function() {
			var currTab = $('#tabs').tabs('getSelected');
			var url = $(currTab.panel('options').content).attr('src');
			if (url != undefined && currTab.panel('options').title != '工作台') {
				$('#tabs').tabs('update', {
					tab: currTab,
					options: {
						content: createFrame(url)
					}
				});
			}
		});
		// 关闭当前
		$('#mm-tabclose').click(function() {
			var currtab_title = $('#mm').data('currtab');
			if (currtab_title != '工作台') {
				$('#tabs').tabs('close', currtab_title);
			}
		});
		// 全部关闭
		$('#mm-tabcloseall').click(function() {
			$('.tabs-inner span').each(function(i, n) {
				var t = $(n).text();
				if (t != '工作台') {
					$('#tabs').tabs('close', t);
				}
			});
		});
		// 关闭除当前之外的TAB
		$('#mm-tabcloseother').click(function() {
			var prevall = $('.tabs-selected').prevAll();
			var nextall = $('.tabs-selected').nextAll();
			if (prevall.length > 0) {
				prevall.each(function(i, n) {
					var t = $('a:eq(0) span', $(n)).text();
					if (t != '工作台') {
						$('#tabs').tabs('close', t);
					}
				});
			}
			if (nextall.length > 0) {
				nextall.each(function(i, n) {
					var t = $('a:eq(0) span', $(n)).text();
					if (t != '工作台') {
						$('#tabs').tabs('close', t);
					}
				});
			}
			// 需要重新选中当前
			$('#tabs').tabs('select', $('#mm').data('currtab'));
			return false;
		});
		// 关闭当前右侧的TAB
		$('#mm-tabcloseright').click(function() {
			var nextall = $('.tabs-selected').nextAll();
			if (nextall.length == 0) {
				return false;
			}
			nextall.each(function(i, n) {
				var t = $('a:eq(0) span', $(n)).text();
				$('#tabs').tabs('close', t);
			});
			// 需要重新选中当前
			$('#tabs').tabs('select', $('#mm').data('currtab'));
			return false;
		});
		// 关闭当前左侧的TAB
		$('#mm-tabcloseleft').click(function() {
			var prevall = $('.tabs-selected').prevAll();
			if (prevall.length == 0) {
				return false;
			}
			prevall.each(function(i, n) {
				var t = $('a:eq(0) span', $(n)).text();
				if (t != '工作台') {
					$('#tabs').tabs('close', t);
				}
			});
			// 需要重新选中当前
			$('#tabs').tabs('select', $('#mm').data('currtab'));
			return false;
		});
	};
	tabClose();
	tabCloseEven();
};
$(Main);