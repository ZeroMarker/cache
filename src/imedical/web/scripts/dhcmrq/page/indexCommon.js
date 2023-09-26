
$(function () {
	//console.log(session)
	if(session['LOGON.ROLECODE'].toLowerCase()=='admin') {
	    $('#sidebar').css('display','block');
	    $('.main-content').css('margin-left','200px');
	        	
	} else {
		$('#licBtn').remove();
	}
	
	GetSysInfo();
	LoadMenu();
});

//���ز˵�
function LoadMenu(){
	$.post('dhcmrq.service.csp',
		    {ClassName:'DHCMRQ.Base.Logon',
			 MethodName:'LoadMenu',
			 Params:session['LOGON.ROLECODE']
			},
			function(res){
				//console.log(res)
				var data = JSON.parse(res).sort(function(a,b){
					return a.menuOrder-b.menuOrder;
				});
				
		showNavTab(data[0]['menuCode'], data[0]['menuDesc'], data[0]['menuResource'], data[0]['menuCode'], data[0]['menuIcon'],true);
		var menuHtml = '';
		for (var i = 0; i < data.length; i++) {
			var menuId = data[i]['menuCode'];
			var menuIcon = data[i]['menuIcon'];
			var menuDesc = data[i]['menuDesc'];
			var menuUrl = data[i]['menuResource'];
			var subMenu = data[i]['subMenu'];
			if (subMenu) {
					menuHtml += '<li id="li_parent_'+menuId+'">'
							+'<a href="" class="dropdown-toggle">'
							+		'<i class="menu-icon fa fa-wrench"></i>'
							+		'<span class="menu-text">'
							+				menuDesc
							+		'</span>'
							+		'<b class="arrow fa fa-angle-down"></b>'
							+'</a>'
							+'<ul class="submenu " id="ul_parent_'+menuId+'">';
							for (var j = 0; j < subMenu.length; j++) {
									var menuId = subMenu[j]['menuCode'];
									var menuIcon = subMenu[j]['menuIcon'];
									var menuDesc = subMenu[j]['menuDesc'];
									var menuUrl = subMenu[j]['menuResource'];
									menuHtml += '<li>'
											+'<a RowID="'+menuId+'" id="'+menuId+'" href="#" onclick="showNavTab(\''+menuId+'\',\''+menuDesc+'\',\''+menuUrl+'\',\''+menuId+'\',\''+menuIcon+'\')">'
											+		'<i class="menu-icon fa fa-caret-right"></i>'+menuDesc+'</a>'
											+'<b class="arrow"></b>'
									+'</li>';
							}
					menuHtml += '</ul>'
					menuHtml += '</li>'
			} else {
				menuHtml += '<li id="ul_parent_'+menuId+'">'
											+'<a RowID="'+menuId+'"  id="'+menuId+'" href="#" onclick="showNavTab(\''+menuId+'\',\''+menuDesc+'\',\''+menuUrl+'\',\''+data[i]['menuCode']+'\',\''+menuIcon+'\')">'
											+		'<i class="menu-icon fa fa-'+menuIcon+'"></i>'
											+		'<span class="menu-text">'+menuDesc+'</span>'
											+'</a>'
										+'</li>';
			}

		}

		$('#navmenu').html(menuHtml);
	});
}

//��ȡϵͳ��Ϣ
function GetSysInfo(){
	$('#currentRole').html(session['LOGON.ROLEDESC']+'-'+session['LOGON.DEPTDESC']+'-'+session['LOGON.USERNAME']);
	$('#licenseInfo').html(session['LOGON.LICINFO']);
	
	$.ajax({
	    type: 'POST',
	    async:false,
        url: 'dhcmrq.service.csp',
        data: {ClassName:'DHCMRQ.Base.Config',
			   MethodName:'GetValueByCode',
			   Params:'SystemTitle'
		},
		success: function (data) {
			$('.SystemTitle').html(data);
	    }
	});
}

//�˳�
function logout() {
    $.ajax({
        type: 'post',
		url: 'dhcmrq.service.csp',
		data: {ClassName:'DHCMRQ.Base.Logon',
			   MethodName:'Logout',
			   Params:''
		},
        success: function (res) {
            window.location.href = "dhcmrq.logon.csp";
        }
    })
}

//license����
function importLicense(){
	if($('#licenseText').val()==''){
		msg('danger','������license');
		$('#licenseText').focus();
		return;
	}
	$.ajax({
	    type: 'post',
		url: 'dhcmrq.service.csp',
		data: {ClassName:'DHCMRQ.Base.Util.LicEncry',
			   MethodName:'NewLicense',
			   Params:$('#licenseText').val()
			  },
		success: function (res) {
			if (res==1) {
				msg('success','License����ɹ�!');
			} else {
				var errInfo=res.split('^')[1]
				msg('danger','License����ʧ��! '+errInfo);
			}
			$('#licenseModal').modal('hide').val('');
		}
	});
}


///iframe����Ӧ��Ļ�߶�
function iFrameHeight(id) {
    var ifm = document.getElementById(id);
    if (ifm != null) {
	    //�Ƴ��Ӵ��ڱ���
        $('.navbar-brand',ifm.contentWindow.document.body).fadeOut();
        
        //ifm.height = window.innerHeight - 90;
        ////������Ҳ���Ÿı� myTabContent
        //$("#myTabContent").height(window.innerHeight - 90);
        try{
            var bHeight = ifm.contentWindow.document.body.scrollHeight;
            var dHeight = ifm.contentWindow.document.documentElement.scrollHeight;
            var innerHeight = Math.min(bHeight, dHeight);
            var outerHeight = $(window).height() - 110;
            // var height = Math.max(innerHeight, outerHeight);
            ifm.height = outerHeight;
        }
        catch(e)
        {
            ifm.height = 600;
        }

    }
}

///������˵����ִ˲˵���Ӧ��tab����
function showNavTab(RowID, MenuName, URL, parentRowID, iconurl, canClose) {
    var nav = $("#content_" + RowID).get(0);
    if(!iconurl) iconurl = 'bars';
    if ($.isEmptyObject(nav)) {//����Ƿ��Ѿ����ڴ򿪵Ĳ˵�
        var htm = '';
        htm += '<li id="li_' + RowID + '">';
        htm += '<a data-toggle="tab"  href="#content_' + RowID + '">';
        htm += '<i class="ace-icon fa fa-' + iconurl + '"></i>';
        htm += MenuName;
        
		if(!canClose){
			htm += '<i class="fa fa-times bigger-110" style="cursor:pointer"></i>';
		}
		
        htm += '</a>';
        htm += '</li>';
        $("#myTab").append(htm);

        htm = '';
        htm += '<div id="content_' + RowID + '" class="tab-pane">';
        htm += '<iframe id="iframe_' + RowID + '" src="' + URL + '"  width="100%"  min-height="500px"  onLoad="iFrameHeight(\'iframe_' + RowID + '\')" frameborder="0" >';
        htm += 'ϵͳʹ���˿�ܼ��������������������֧�ֿ�ܣ�����������������Ա��������ʡ�';
        htm += '</iframe>';
        htm += '</div>';
        $("#myTabContent").append(htm);
        
        navTabStyle(RowID);
    }
    displayNavTab(RowID);
    $("#navmenu").find("li").removeClass("active");
    //$("#nav").addClass("active");
    //$("#nav").find(".active").removeClass("active");
    //alert($("#nav>li").find(".active"));
    $("#li_parent_" + parentRowID).addClass("active");
    $("#" + RowID).parent("li").addClass("active");
    // alert(RowID);
    //   $("#ul_parent_" + parentRowID).show();
}

///���򵼺�����ʽ����
function navTabStyle(RowID) {
    $("#li_" + RowID).find(".icon-remove").hover(
        function () {
            $(this).addClass("badge badge-danger");
        },
        function () {
            $(this).removeClass("badge badge-danger");
        }
    );

    $("#li_" + RowID).find(".fa-times").click(
        function () {
            closeNavTab(RowID);
        }
    );

    $("#li_" + RowID).click(
        function () {
            //ͨ��rowID�ҵ�����Ӧ���Ӳ˵��������Ӳ˵��趨��ʽ
            setSubMenusActiveStyle(RowID);
        }
    );
    $("#li_" + RowID).contextMenu('mm', {

        bindings: {
            'tabClose': function (t) {
                if (RowID == 'home') {
                } else {
                    closeNavTab(RowID);
                }
            },
            'tabCloseOther': function (t) {
                $("#myTab").children("li").each(function (i, e) {
                    if (e.id != "li_home" && e.id != "li_" + RowID) {
                        $(e).remove();
                    }
                });
                $("#myTabContent").children("div").each(function (i, e) {
                    if (e.id != "content_home" && e.id != "content_" + RowID) {
                        $(e).remove();
                    }
                });
                displayNavTab(RowID);
            },
            'tabCloseAll': function (t) {
                $("#myTab").children("li").each(function (i, e) {
                    if (e.id != "li_home") {
                        $(e).remove();
                    }
                });
                $("#myTabContent").children("div").each(function (i, e) {
                    if (e.id != "content_home") {
                        $(e).remove();
                    }
                });
                displayNavTab("home");
            }
        }
    });
}

//ͨ��rowID�ҵ�����Ӧ���Ӳ˵��������Ӳ˵��趨ѡ����ʽ
function setSubMenusActiveStyle(RowID) {
    $("#nav").find("a[RowID]").removeClass("submenus_active");
    $("#nav").find("a[RowID=" + RowID + "]").addClass("submenus_active");
}

///�ر�Tab
function closeNavTab(RowID) {
    ///����رյ��ǵ�ǰ���򿪵�tabҳ������Ҫ�ȴ�һ��ǰ������ŵ�ҳ�棬Ȼ���ٹر�
    if ($("#li_" + RowID).hasClass("active")) {
        var li = $('a[href=#content_' + RowID + ']').parent("li").prev();
        var preRowID = li.attr("id").split("_")[1];
        displayNavTab(preRowID);
    }
    if (RowID != "home") {
        $("#li_" + RowID).remove();
        $("#content_" + RowID).remove();
    }
}

///��ָ����ҳ��
function displayNavTab(RowID) {
    $("#myTab").find("li").removeClass("active");
    $("#myTabContent").find(".tab-pane").removeClass("active");

    $('a[href=#content_' + RowID + ']').parent("li").addClass("active");
    $("#content_" + RowID).addClass("active");
    $("#li_" + RowID).addClass("active");
    //ͨ��rowID�ҵ�����Ӧ���Ӳ˵��������Ӳ˵��趨��ʽ
    setSubMenusActiveStyle(RowID);
}
function setCookie(name, value) {//����������һ����cookie�����ӣ�һ����ֵ
    var Days = 30; //�� cookie �������� 30 ��
    var exp = new Date();    //new Date("December 31, 9998");
    exp.setTime(exp.getTime() + Days * 24 * 60 * 60 * 1000);
    document.cookie = name + "=" + escape(value) + ";expires=" + exp.toGMTString();
}

function getCookie(name) {//ȡcookies����
    var arr = document.cookie.match(new RegExp("(^| )" + name + "=([^;]*)(;|$)"));
    if (arr != null) return unescape(arr[2]); return null;
}

function msg (type,msg){
	var icon = {
		info:'fa-info-circle',
		success:'fa-check-circle',
		warning:'fa-exclamation-circle',
		danger:'fa-times-circle'
	}
	var alert = $('<div class="alert note-wt note-wt-'+type+' alert-dismissible" role="alert">'
				+	'<button type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>'
				+	'<i class="fa '+icon[type]+'"></i><span class="text">' + msg +'</span>'
				+'</div>');
	$('body').append(alert);
	setTimeout(function () {
		alert.fadeOut();
	}, 2000);
}