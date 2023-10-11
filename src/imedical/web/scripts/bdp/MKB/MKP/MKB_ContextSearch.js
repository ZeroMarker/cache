var num = ""
var totalPage = ""
//***************fwkadd*******************//
//***************fwkadd*******************//
function hideandmore(self) {
    if ($(self).html() == "查看更多") {
        $(self).html("隐藏")
        $("#tip" + self.id.substring(3)).removeClass('tipcontent')
    } else {
        $(self).html("查看更多")
        $("#tip" + self.id.substring(3)).addClass('tipcontent')
    }
}

function goPage(current) {
    $('body').animate({
        scrollTop: 0
    }, 'fast');
    $('#pagenation').remove();
    var pagestr = "<ul id='pagenation'>";
    pagestr += "<li><a style='width:50px' id='pre'>上一页</a></li>";
    var total = num;
    var psize = 5;
    current = parseInt(current);
    var start = current * 5 - 4
    var end = current * 5
    if (current * 5 > total) {
        end = total
    }
    var result = tkMakeServerCall("web.DHCBL.MKB.MKBContextSearch", "SearchContext", start, end)
    $("#DivContent").empty()
    $("#DivContent").append(result)
    for (var k = start; k <= end; k++) {
        if ($("#tip" + k).height() < 169) {
            $("#btn" + k).hide();
        }
    }
    if (totalPage < 7) {
        for (var i = 1; i <= totalPage; i++) {
            pagestr += "<li><a style='width:30px' id=a" + i + ">" + i + "</a></li>";
        }
        pagestr += "<li><a style='width:50px' id='next'>下一页</a></li>";
    } else {
        if (current <= 4) {
            for (var i = 1; i <= 7; i++) {
                pagestr += "<li><a style='width:30px' id=a" + i + ">" + i + "</a></li>";
            }
            pagestr += "<li><a style='width:50px' id='next'>下一页</a></li>";
        } else {
            start = current - 3;
            if (start <= 0) {
                start = 1
            }
            if (current + 4 <= totalPage) {
                end = current + 4;
                for (var i = start; i < end; i++) {
                    pagestr += "<li><a style='width:30px' id=a" + i + ">" + i + "</a></li>";
                }
            } else {
                end = totalPage;
                for (var i = start; i <= end; i++) {
                    pagestr += "<li><a style='width:30px' id=a" + i + ">" + i + "</a></li>";
                }
            }
            pagestr += "<li><a style='width:50px' id='next'>下一页</a></li>";
        }
    }
    pagestr += "</ul>";
    if (totalPage != 0) {
        $('#footer').append(pagestr);
    }
    $("#a" + current).css({
        "background-color": "#41A3DF",
        "color": "#fdfdfd",
        "border": "solid 1px #ccc"
    });
    $("li a").click(function() {
        if ($(this).attr("id").indexOf("a") != -1) {
            goPage($(this).attr("id").substring(1));
        } else if ($(this).attr("id") == "pre") {
            if (current == 1) {
                //$("#pre").attr("href","javascript:return false;");
                $(this).onclick = function() {
                    return false;
                }
            } else {
                // $("#pre").attr("onclick","goPage("+(current-1)+")")
                $(this).onclick = goPage(current - 1)
            }
        } else if ($(this).attr("id") == "next") {
            if (current == totalPage) {
                $(this).onclick = function() {
                    return false;
                }
            } else {
                $(this).onclick = goPage(current + 1)
            }
        }
    })
};

function Search() {
    var termbase = "";
    var desc = $("#context").val();
    if ($("#ZSKlist").length > 0) {
        var arr = $("#ZSKlist").datagrid('getSelections');
        var temp = [];
        for (i = 0; i < arr.length; i++) {
            temp.push(arr[i].TermBaseID);
        }
        termbase = temp.join(',');
    } else {
        termbase = tkMakeServerCall("web.DHCBL.MKB.MKBContextSearch", "QWJSZSK");
    }
    /*var arr=$("#ZSKlist").datagrid('getSelections');
    var temp=[];
    for(i=0;i<arr.length;i++)
    {
       temp.push(arr[i].TermBaseID);
    }
    var termbase = temp.join(',');*/
    /*$('#ZSKlist').datagrid('getSelections').each(function(){
        arr.push($(this).val());
    });*/
    //var termbase = arr.join(',');
    num = tkMakeServerCall("web.DHCBL.MKB.MKBContextSearch", "ContextData", desc, termbase)
    if (num == "error") {
        $("#DivContent").empty()
        $('#MKBTip').empty()
        $("#DivContent").html('<div id="div-img" style="width:100%;height:8%;text-align:center"><img src="../scripts/bdp/Framework/icons/mkb/contextnodatatip.png" alt="没有数据哦，重新输入试试吧" style=""/></div>');
        $('#footer').empty()
        return;
    }
    num = parseInt(num)
    if (num / 5 > parseInt(num / 5)) {
        totalPage = parseInt(num / 5) + 1;
    } else {
        totalPage = parseInt(num / 5);
    }
    $("#MKBTip").empty()
    $("#MKBTip").append("<span style='color:gray'>为您找到相关结果" + num + "个,共" + totalPage + "页。</span>")
    goPage(1)
}
//$(goPage(2,10))
function goTerm(MKBTBCode, MKBTBDesc, TermID, ProId, DetId) {
    var menuid = tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine", "GetID", "dhc.bdp.mkb.mtm." + MKBTBCode);
    var parentid = tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine", "GetID", "dhc.bdp.mkb.mtm");
    var menuimg = tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine", "GetIconByID", menuid);
    //判断浏览器版本
    var Sys = {};
    var ua = navigator.userAgent.toLowerCase();
    var s;
    (s = ua.match(/msie ([\d.]+)/)) ? Sys.ie = s[1]: (s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] : (s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] : (s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] : (s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;
    //双击时跳转到对应界面
    if (!Sys.ie) {
        window.parent.closeNavTab(menuid)
        window.parent.showNavTab(menuid, MKBTBDesc, 'dhc.bdp.ext.sys.csp?BDPMENU=' + menuid + '&TermID=' + TermID + "&ProId=" + ProId + "&detailId=" + DetId, parentid, menuimg)
    } else {
        parent.PopToTab(menuid, MKBTBDesc, 'dhc.bdp.ext.sys.csp?BDPMENU=' + menuid + '&TermID=' + TermID + "&ProId=" + ProId + "&detailId=" + DetId, menuimg);
    }
}