function banBackSpace(e) {
	var ev = e || window.event;
	// ��ȡevent����
	var obj = ev.target || ev.srcElement;
	// ��ȡ�¼�Դ
	var t = obj.type || obj.getAttribute('type');
	// ��ȡ�¼�Դ����
	// ��ȡ��Ϊ�ж��������¼�����
	var vReadOnly = obj.readOnly;
	var vDisabled = obj.disabled;
	// ����undefinedֵ���
	vReadOnly = (vReadOnly == undefined) ? false : vReadOnly;
	vDisabled = (vDisabled == undefined) ? true : vDisabled;
	// ����Backspace��ʱ���¼�Դ����Ϊ������С������ı��ģ�
	// ����readOnly����Ϊtrue��disabled����Ϊtrue�ģ����˸��ʧЧ
	var flag1 = ev.keyCode == 8 && (t == 'password' || t == 'text' || t == 'textarea') && (vReadOnly == true || vDisabled == true);
	// ����Backspace��ʱ���¼�Դ���ͷ�������С������ı��ģ����˸��ʧЧ
	var flag2 = ev.keyCode == 8 && t != 'password' && t != 'text' && t != 'textarea';
	// �ж�
	if (flag2 || flag1) return false;
}
// ��ֹ�˸�� ������Firefox��Opera
document.onkeypress = banBackSpace;
// ��ֹ�˸�� ������IE��Chrome
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
 * �ж�MWToken�����Ƿ����
 * websys_getMWToken()��õ�ǰ����򶥲����� MWToken ֵ
 * websys_writeMWToken(url)�ѵ�ǰ����򶥲����� MWToken ����д�� url ��
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

// /�漰 �ⲿ����  �ó���
function addTab(title, url) {
	if ($('#tabs').tabs('exists', title)) {
		var oldTabTitle = $('#tabs').tabs('getSelected').panel('options').title;	// ��ȡ֮ǰ�˵�
		$('#tabs').tabs('select', title);	// ѡ�е�ǰ�˵�
		if (url.indexOf('MENU') > 0) {	// ��ת����ˢ��
			return;
		}
		var currTab = $('#tabs').tabs('getSelected');
		if (url != undefined && currTab.panel('options').title != '��ҳ') {
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
		prompt: '�˵�����',
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
	// ��ȡһ���˵�
	var menusArr = $.cm({
		ClassName: 'web.CSSDHUI.Main.Menu',
		MethodName: 'ShowBarJson',
		id: '1'
	}, false);
	var menusid = menusArr[0].id;
	// ��ȡ�����˵�
	$.cm({
		ClassName: 'web.CSSDHUI.Main.Menu',
		MethodName: 'ShowBarJson',
		id: menusid
	}, function(data) {
		$('#menus').tree('loadData', data);
	});
	function tabClose() {
		/* ˫���ر�TABѡ�*/
		$('.tabs-header').on('dblclick', '.tabs-inner', function() {
			var subtitle = $(this).children('.tabs-closable').text();
			$('#tabs').tabs('close', subtitle);
		}).on('contextmenu', '.tabs-inner', function(e) {
			e.preventDefault();
			var subtitle = $(this).children('.tabs-title').text();
			// ��һЩ�Ҽ��˵��Ľ�������
			if (subtitle == '����̨') {
				$('#mm').menu('disableItem', $('#mm-tabupdate')[0]);
				$('#mm').menu('disableItem', $('#mm-tabclose')[0]);
			} else {
				$('#mm').menu('enableItem', $('#mm-tabupdate')[0]);
				$('#mm').menu('enableItem', $('#mm-tabclose')[0]);
			}

			var leftnum = $('.tabs-selected').prevAll().length;
			if (leftnum > 1) { // �и���ҳ Ҫ����1
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
	// ���Ҽ��˵��¼�
	var tabCloseEven = function() {
		// ˢ��
		$('#mm-tabupdate').click(function() {
			var currTab = $('#tabs').tabs('getSelected');
			var url = $(currTab.panel('options').content).attr('src');
			if (url != undefined && currTab.panel('options').title != '����̨') {
				$('#tabs').tabs('update', {
					tab: currTab,
					options: {
						content: createFrame(url)
					}
				});
			}
		});
		// �رյ�ǰ
		$('#mm-tabclose').click(function() {
			var currtab_title = $('#mm').data('currtab');
			if (currtab_title != '����̨') {
				$('#tabs').tabs('close', currtab_title);
			}
		});
		// ȫ���ر�
		$('#mm-tabcloseall').click(function() {
			$('.tabs-inner span').each(function(i, n) {
				var t = $(n).text();
				if (t != '����̨') {
					$('#tabs').tabs('close', t);
				}
			});
		});
		// �رճ���ǰ֮���TAB
		$('#mm-tabcloseother').click(function() {
			var prevall = $('.tabs-selected').prevAll();
			var nextall = $('.tabs-selected').nextAll();
			if (prevall.length > 0) {
				prevall.each(function(i, n) {
					var t = $('a:eq(0) span', $(n)).text();
					if (t != '����̨') {
						$('#tabs').tabs('close', t);
					}
				});
			}
			if (nextall.length > 0) {
				nextall.each(function(i, n) {
					var t = $('a:eq(0) span', $(n)).text();
					if (t != '����̨') {
						$('#tabs').tabs('close', t);
					}
				});
			}
			// ��Ҫ����ѡ�е�ǰ
			$('#tabs').tabs('select', $('#mm').data('currtab'));
			return false;
		});
		// �رյ�ǰ�Ҳ��TAB
		$('#mm-tabcloseright').click(function() {
			var nextall = $('.tabs-selected').nextAll();
			if (nextall.length == 0) {
				return false;
			}
			nextall.each(function(i, n) {
				var t = $('a:eq(0) span', $(n)).text();
				$('#tabs').tabs('close', t);
			});
			// ��Ҫ����ѡ�е�ǰ
			$('#tabs').tabs('select', $('#mm').data('currtab'));
			return false;
		});
		// �رյ�ǰ����TAB
		$('#mm-tabcloseleft').click(function() {
			var prevall = $('.tabs-selected').prevAll();
			if (prevall.length == 0) {
				return false;
			}
			prevall.each(function(i, n) {
				var t = $('a:eq(0) span', $(n)).text();
				if (t != '����̨') {
					$('#tabs').tabs('close', t);
				}
			});
			// ��Ҫ����ѡ�е�ǰ
			$('#tabs').tabs('select', $('#mm').data('currtab'));
			return false;
		});
	};
	tabClose();
	tabCloseEven();
};
$(Main);