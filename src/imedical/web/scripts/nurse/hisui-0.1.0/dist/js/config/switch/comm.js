/**
 * @Author      yaojining
 * @DateTime    2020-11-27
 * @description 公共js
 */
/**
 * @description: 初始化界面
 */
function initUI() {
	requestTreeData();
	listenEvents();
}
$(initUI);

function requestTreeData() {
	var data = [{
		"id": 1,
		"text": "版本管理",
		"state": "open",
		"children": [{
			"id": 11,
			"text": "编辑器",
			"attributes": {
				"url": "nur.hisui.nurseSwitchConfig.update.csp"
			}
		}]
	}, {
		"id": 2,
		"text": "病历通用",
		"state": "open",
		"children": [{
			"id": 21,
			"text": "列表设置",
			"attributes": {
				"url": "nur.hisui.nurseswitchconfig.list.csp"
			}
		}, {
			"id": 22,
			"text": "病历记录",
			"attributes": {
				"url": "nur.hisui.nurseSwitchConfig.edit.csp"
			}
		}]
	}, {
		"id": 3,
		"text": "CA认证",
		"state": "open",
		"children": [{
			"id": 31,
			"text": "验证设置",
			"attributes": {
				"url": "nur.hisui.nurseSwitchConfig.ca.csp"
			}
		}, {
			"id": 32,
			"text": "图片样式",
			"attributes": {
				"url": "nur.hisui.nurseSwitchConfig.size.csp"
			}
		}]
	}, {
		"id": 4,
		"text": "FTP及服务",
		"state": "open",
		"children": [{
			"id": 41,
			"text": "FTP设置",
			"attributes": {
				"url": "nur.hisui.nurseSwitchConfig.ftp.csp"
			}
		}, {
			"id": 42,
			"text": "服务地址",
			"attributes": {
				"url": "nur.hisui.nurseswitchconfig.picture.csp"
			}
		}]
	}]
	initAccTree(data);
}

function initAccTree(data) {
	$('#menu-tree').tree({
		data: data,
		formatter: treeNodeFormatter,
		onClick: function (node) {
			$('#menu-tree').tree('toggle', node.target); //简单单吉展开关闭
			if (node && node.attributes && node.attributes.url) {
				addTab(node.text, node.attributes.url);
			}
		}
	});
}

function treeNodeFormatter(node, search) {
	console.log(arguments)
	var text = node.text;
	if (search && search != '') {
		var reg = new RegExp(search, 'ig');
		text = text.replace(reg, "<span class='reg-word'>" + search + "</span>");
	}

	if (node && node.attributes && node.attributes.count > 0) {
		return text + ' ' + '<span class="menu-tree-tip-count">' + node.attributes.count + '</span>'
	} else {
		return text;
	}
}
function formatData(data, search, parent) {
	var flag = false,
		pok = (parent && parent.ok),
		search = search.toLowerCase();
	for (var i = 0; i < data.length; i++) {
		var item = data[i];
		item.ok = false;
		if (pok) {
			item.ok = true;
		} else {
			var text = item.text.toLowerCase();
			if (text.indexOf(search) > -1) {
				item.ok = true;
			} else {
				var spellArr = $.hisui.getChineseSpellArray(text);
				var len = spellArr.length;

				var spellMatch = false;
				for (var j = 0; j < len; j++) {
					var spellL = (spellArr[j] || '').toLowerCase();
					var spellIndex = spellL.indexOf(search);
					item.ok = true;
					break;
				}
			}
		}
		if (item.children) {
			formatData(item.children, search, item);
		}
		if (item.ok) flag = true;
	}
	if (flag && parent) parent.ok = true;
}
function formatNode(data, search, isRoot, keepRoot) {
	for (var i = 0; i < data.length; i++) {
		var item = data[i];

		if (item.children) {
			formatNode(item.children, search, false, keepRoot);
		}
		var t = $("#" + item.domId);

		if (isRoot && keepRoot) {
			//保持根节点并且是根节点 不用处理
		} else if (item.ok) {
			var html = treeNodeFormatter(item, search);
			t.find('.tree-title').html(html);
			t.removeClass('tree-node-hidden');
		} else {
			t.addClass('tree-node-hidden');
		}
	}
}

/**
 * @description: 添加页签
 */
function addTab(title, url) {
	if ($('#tabs').tabs('exists', title)) {
		$('#tabs').tabs('select', title);//选中并刷新
		var currTab = $('#tabs').tabs('getSelected');
		var url = $(currTab.panel('options').content).attr('src');
		if (url != undefined && currTab.panel('options').title != 'Home') {
			$('#tabs').tabs('update', {
				tab: currTab,
				options: {
					content: createFrame(url)
				}
			})
		}
	} else {
		var content = createFrame(url);
		$('#tabs').tabs('add', {
			title: title,
			content: content,
			closable: true
		});
	}
	tabClose();
}
/**
 * @description: 创建iframe
 */
function createFrame(url) {
	var iframe = '<iframe scrolling="auto" frameborder="0"  src="' + buildMWTokenUrl(url) + '" style="width:100%;height:100%;"></iframe>';
	return iframe;
}
/**
 * @description: 监听页签事件
 */
function tabClose() {
	/*双击关闭TAB选项卡*/
	$(".tabs-inner").dblclick(function () {
		var subtitle = $(this).children(".tabs-closable").text();
		$('#tabs').tabs('close', subtitle);
	})
	/*为选项卡绑定右键*/
	$(".tabs-inner").bind('contextmenu', function (e) {
		$('#menu').menu('show', {
			left: e.pageX,
			top: e.pageY
		});
		var subtitle = $(this).children(".tabs-closable").text();
		$('#menu').data("currtab", subtitle);
		$('#tabs').tabs('select', subtitle);
		return false;
	});
}
/**
 * @description: 绑定右键菜单事件
 */
function tabCloseEven() {
	//刷新
	$('#menu-tabupdate').click(function () {
		var currTab = $('#tabs').tabs('getSelected');
		var url = $(currTab.panel('options').content).attr('src');
		if (url != undefined && currTab.panel('options').title != 'Home') {
			$('#tabs').tabs('update', {
				tab: currTab,
				options: {
					content: createFrame(url)
				}
			})
		}
	})
	//关闭当前
	$('#menu-tabclose').click(function () {
		var currtab_title = $('#menu').data("currtab");
		$('#tabs').tabs('close', currtab_title);
	})
	//全部关闭
	$('#menu-tabcloseall').click(function () {
		$('.tabs-inner span').each(function (i, n) {
			var t = $(n).text();
			if (t != 'Home') {
				$('#tabs').tabs('close', t);
			}
		});
	});
	//关闭除当前之外的TAB
	$('#menu-tabcloseother').click(function () {
		var prevall = $('.tabs-selected').prevAll();
		var nextall = $('.tabs-selected').nextAll();
		if (prevall.length > 0) {
			prevall.each(function (i, n) {
				var t = $('a:eq(0) span', $(n)).text();
				if (t != 'Home') {
					$('#tabs').tabs('close', t);
				}
			});
		}
		if (nextall.length > 0) {
			nextall.each(function (i, n) {
				var t = $('a:eq(0) span', $(n)).text();
				if (t != 'Home') {
					$('#tabs').tabs('close', t);
				}
			});
		}
		return false;
	});
	//关闭当前右侧的TAB
	$('#menu-tabcloseright').click(function () {
		var nextall = $('.tabs-selected').nextAll();
		if (nextall.length == 0) {
			return false;
		}
		nextall.each(function (i, n) {
			var t = $('a:eq(0) span', $(n)).text();
			$('#tabs').tabs('close', t);
		});
		return false;
	});
	//关闭当前左侧的TAB
	$('#menu-tabcloseleft').click(function () {
		var prevall = $('.tabs-selected').prevAll();
		if (prevall.length == 0) {
			return false;
		}
		prevall.each(function (i, n) {
			var t = $('a:eq(0) span', $(n)).text();
			$('#tabs').tabs('close', t);
		});
		return false;
	});
	//退出
	$("#menu-exit").click(function () {
		$('#menu').menu('hide');
	})
}
/**
 * @description 事件监听
 */
function listenEvents() {
	tabCloseEven();
	$('.config-switch-tab').click(function () {
		var $this = $(this);
		var href = $this.attr('src');
		var title = $this.text();
		addTab(title, href);
	});
	$('#btnDownload').bind('click', function () {
		var arrurl = window.location.href.split('/');
		if (!!session['SERVER_NAME']) {
			var arrport = arrurl[2].split(':');
			if ((arrport.length > 0) && (!!arrport[1])) {
				arrurl[2] = session['SERVER_NAME'] + ':' + arrport[1];
			} else {
				arrurl[2] = session['SERVER_NAME'];
			}
		}
		window.location.href = arrurl[0] + '//' + arrurl[2] + '/dhcmg/护理病历编辑器v2.0.zip';
	});
	$('#btnAftUpdate').bind('click', function () {
		$.messager.progress({
			title: "提示",
			msg: '后置任务升级',
			text: '升级中....'
		});
		$m({
			ClassName: 'NurMp.Service.Editor.Update',
			MethodName: 'updateEmr',
			HospitalID: session['LOGON.HOSPID']
		}, function (ret) {
			$.messager.progress("close");
			$.messager.popover({ msg: "升级成功!", type: "success" });
		});
	})
}