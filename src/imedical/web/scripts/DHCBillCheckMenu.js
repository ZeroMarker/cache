/// DHCBillCheckMenu.js
/// 	Creator:	tangt
/// 	Date: 		2014-04-15
function DHCMenu()
{
	var Menus;
	var Root;
	var AccordionID;		// easyui-accordion ID			// '#wnav'
	var TreeID;				// easyui-tree ID				// tt1
	this.InitMenu = function(thisMenus,thisRoot,thisAccordionID,thisTreeID){
		Menus = thisMenus;
		Root = thisRoot;
		AccordionID = thisAccordionID;
		TreeID = thisTreeID;
	}
    this.addNav = function (){	// �״μ��� Root
    	addNav(Menus[Root],AccordionID,TreeID)
    }
    this.InitLeftMenu = function(){
    	InitLeftMenu()
    }
    this.tabClose = function(){
	    tabClose()
    }
    this.tabCloseEven = function(){
	    tabCloseEven()
    }
    this.Clearnav = function(){
	    Clearnav()
    }
		
	function addNav(data,AccordionID,TreeID) {
	    $.each(data, function(i, sm) {
	        var menulist1 = "";
	        menulist1 = GetMenuList(sm, menulist1);
	        menulist1 = "<ul id="+TreeID+" class='easyui-tree' animate='true' dnd='true'>" + menulist1.substring(4); 
	        $(AccordionID).accordion('add', {
	            title: sm.menuname,
	            content: menulist1,
	            iconCls: 'icon ' + sm.icon
	        });

	    });
	    var pp = $(AccordionID).accordion('panels');
	    var t = pp[0].panel('options').title;
	    $(AccordionID).accordion('select', t);
	}

	function GetMenuList(data, menulist) {
	    if (data.menus == null)
	        return menulist;
	    else {
	        menulist += '<ul>';
	        $.each(data.menus, function(i, sm) {
				classname = sm.classname
				methodname = sm.methodname
				menuparam = sm.menuparam
				menuparamnum = sm.menuparamnum
	            if (sm.url != null) {
	                menulist += '<li ><a ref="' + sm.menuid + '" href="#" rel="'
						+ sm.url +'?classname=' + classname +'&methodname=' + methodname +'&menuparam=' + menuparam +'&menuparamnum=' + menuparamnum + '" ><span class="nav">' + sm.menuname
						+ '</span></a>'
	            }
	            else {
	                menulist += '<li state="closed"><span class="nav">' + sm.menuname + '</span>'
	            }
	            menulist = GetMenuList(sm, menulist);
	        })
	        menulist += '</ul>';
	    }
	    return menulist;
	}

	// ��ʼ�����
	function InitLeftMenu() {

	    $('#wnav li').on('click', 'a', function() {
	        var tabTitle = $(this).children('.nav').text();
	        var url = $(this).attr("rel");
	        var menuid = $(this).attr("ref");
	        var icon = getIcon(menuid, icon);

	        addTab(tabTitle, url, icon);
	        $('#wnav li div').removeClass("selected");
	        $(this).parent().addClass("selected");
	    }).hover(function(){
			$(this).parent().addClass("hover");
		},function(){
			$(this).parent().removeClass("hover");
		});
	}

	// ��ȡ��ർ����ͼ��Tab
	function getIcon(menuid) {
	    var icon = 'icon ';
	    $.each(Menus, function(i, n) {
	        $.each(n, function(j, o) {
	            $.each(o.menus, function(k, m) {
	                if (m.menuid == menuid) {
	                    icon += m.icon;
	                    return false;
	                }
	            });
	        });
	    });
	    return icon;
	}
	
	function addTab(subtitle, url, icon) {
	    if (!$('#tabs').tabs('exists', subtitle)) {
	        $('#tabs').tabs('add', {
	            title: subtitle,
	            content: createFrame(url),
	            closable: true,
	            icon: icon
	        });
	    } else {
	        $('#tabs').tabs('select', subtitle);
	        $('#mm-tabupdate').click();
	    }
	    tabClose();
	}
	
	function createFrame(url) {
	    var s = '<iframe scrolling="auto" frameborder="0"  src="' + url + '" style="width:100%;height:100%;"></iframe>';
	    return s;
	}

	function tabClose() {
	    /* ˫���ر�TABѡ� */
	    $(".tabs-inner").dblclick(function() {
	        var subtitle = $(this).children(".tabs-closable").text();
	        $('#tabs').tabs('close', subtitle);
	    });
	    /* Ϊѡ����Ҽ� */
	    $(".tabs-inner").bind('contextmenu', function(e) {
	        $('#mm').menu('show', {
	            left: e.pageX,
	            top: e.pageY
	        });
	        var subtitle = $(this).children(".tabs-closable").text();
	        $('#mm').data("currtab", subtitle);
	        $('#tabs').tabs('select', subtitle);
	        return false;
	    });
	}
	// ���Ҽ��˵��¼�
	function tabCloseEven() {
	    // ˢ��
	    $('#mm-tabupdate').click(function() {
	        var currTab = $('#tabs').tabs('getSelected');
	        var url = $(currTab.panel('options').content).attr('src');
	        $('#tabs').tabs('update', {
	            tab: currTab,
	            options: {
	                content: createFrame(url)
	            }
	        });
	    });
	    // �رյ�ǰ
	    $('#mm-tabclose').click(function() {
	        var currtab_title = $('#mm').data("currtab");
	        $('#tabs').tabs('close', currtab_title);
	    });
	    // ȫ���ر�
	    $('#mm-tabcloseall').click(function() {
	        $('.tabs-inner span').each(function(i, n) {
	            var t = $(n).text();
	            $('#tabs').tabs('close', t);
	        });
	    });
	    // �رճ���ǰ֮���TAB
	    $('#mm-tabcloseother').click(function() {
	        $('#mm-tabcloseright').click();
	        $('#mm-tabcloseleft').click();
	    });
	    // �رյ�ǰ�Ҳ��TAB
	    $('#mm-tabcloseright').click(function() {
	        var nextall = $('.tabs-selected').nextAll();
	        if (nextall.length == 0) {
	            // msgShow('ϵͳ��ʾ','���û����~~','error');
	            alert('���û����~~');
	            return false;
	        }
	        nextall.each(function(i, n) {
	            var t = $('a:eq(0) span', $(n)).text();
	            $('#tabs').tabs('close', t);
	        });
	        return false;
	    });
	    // �رյ�ǰ����TAB
	    $('#mm-tabcloseleft').click(function() {
	        var prevall = $('.tabs-selected').prevAll();
	        if (prevall.length == 0) {
	            alert('��ͷ�ˣ�ǰ��û����~~');
	            return false;
	        }
	        prevall.each(function(i, n) {
	            var t = $('a:eq(0) span', $(n)).text();
	            $('#tabs').tabs('close', t);
	        });
	        return false;
	    });
	    // �˳�
	    $("#mm-exit").click(function() {
	        $('#mm').menu('hide');
	    });
	}
	
	function Clearnav() {
	    var pp = $('#wnav').accordion('panels');
	    $.each(pp, function(i, n) {
	        if (n) {
	            var t = n.panel('options').title;
	            $('#wnav').accordion('remove', t);
	        }
	    });
	    pp = $('#wnav').accordion('getSelected');
	    if (pp) {
	        var title = pp.panel('options').title;
	        $('#wnav').accordion('remove', title);
	    }
	}
}

