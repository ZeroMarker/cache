var ReportCode = getUrlParam("ReportCode");
$(function () {
  tabCloseEven();
  initMenu();
});

function addTab(title, url) {
  if ($("#tabs").tabs("exists", title)) {
    $("#tabs").tabs("select", title); //ѡ�в�ˢ��
    var currTab = $("#tabs").tabs("getSelected");
    var url = $(currTab.panel("options").content).attr("src");
    if (url != undefined && currTab.panel("options").title != "Home") {
      $("#tabs").tabs("update", {
        tab: currTab,
        options: {
          content: createFrame(url),
        },
      });
    }
  } else {
    var content = createFrame(url);
    $("#tabs").tabs("add", {
      title: title,
      content: content,
      closable: true,
    });
  }
  tabClose();
}
function createFrame(url) {
  if ("undefined" != typeof websys_getMWToken) {
    url += "&MWToken=" + websys_getMWToken();
  }
  var s =
    '<iframe id="iframe-center" scrolling="auto" frameborder="0"  src="' +
    url +
    '" style="width:100%;height:100%;"></iframe>';
  return s;
}
function tabClose() {
  /*˫���ر�TABѡ�*/
  $(".tabs-inner").dblclick(function () {
    var subtitle = $(this).children(".tabs-closable").text();
    $("#tabs").tabs("close", subtitle);
  });
  /*Ϊѡ����Ҽ�*/
  $(".tabs-inner").bind("contextmenu", function (e) {
    $("#mm").menu("show", {
      left: e.pageX,
      top: e.pageY,
    });
    var subtitle = $(this).children(".tabs-closable").text();
    $("#mm").data("currtab", subtitle);
    $("#tabs").tabs("select", subtitle);
    return false;
  });
}
//���Ҽ��˵��¼�
function tabCloseEven() {
  //ˢ��
  $("#mm-tabupdate").click(function () {
    var currTab = $("#tabs").tabs("getSelected");
    var url = $(currTab.panel("options").content).attr("src");
    if (url != undefined && currTab.panel("options").title != "Home") {
      $("#tabs").tabs("update", {
        tab: currTab,
        options: {
          content: createFrame(url),
        },
      });
    }
  });
  //�رյ�ǰ
  $("#mm-tabclose").click(function () {
    var currtab_title = $("#mm").data("currtab");
    $("#tabs").tabs("close", currtab_title);
  });
  //ȫ���ر�
  $("#mm-tabcloseall").click(function () {
    $(".tabs-inner span").each(function (i, n) {
      var t = $(n).text();
      if (t != "Home") {
        $("#tabs").tabs("close", t);
      }
    });
  });
  //�رճ���ǰ֮���TAB
  $("#mm-tabcloseother").click(function () {
    var prevall = $(".tabs-selected").prevAll();
    var nextall = $(".tabs-selected").nextAll();
    if (prevall.length > 0) {
      prevall.each(function (i, n) {
        var t = $("a:eq(0) span", $(n)).text();
        if (t != "Home") {
          $("#tabs").tabs("close", t);
        }
      });
    }
    if (nextall.length > 0) {
      nextall.each(function (i, n) {
        var t = $("a:eq(0) span", $(n)).text();
        if (t != "Home") {
          $("#tabs").tabs("close", t);
        }
      });
    }
    return false;
  });
  //�رյ�ǰ�Ҳ��TAB
  $("#mm-tabcloseright").click(function () {
    var nextall = $(".tabs-selected").nextAll();
    if (nextall.length == 0) {
      return false;
    }
    nextall.each(function (i, n) {
      var t = $("a:eq(0) span", $(n)).text();
      $("#tabs").tabs("close", t);
    });
    return false;
  });
  //�رյ�ǰ����TAB
  $("#mm-tabcloseleft").click(function () {
    var prevall = $(".tabs-selected").prevAll();
    if (prevall.length == 0) {
      return false;
    }
    prevall.each(function (i, n) {
      var t = $("a:eq(0) span", $(n)).text();
      $("#tabs").tabs("close", t);
    });
    return false;
  });
  //�˳�
  $("#mm-exit").click(function () {
    $("#mm").menu("hide");
  });
}
function getUrlParam(paramname) {
  var reg = new RegExp("(^|&)" + paramname + "=([^&]*)(&|$)");
  var s = window.location.search.substr(1).match(reg);
  if (s != null) {
    return unescape(s[2]); // unescape() �����ɶ�ͨ�� escape() ������ַ������н��롣
  }
  return null;
}

function initMenu() {
  $cm(
    {
      ClassName: "Nur.NIS.Service.ReportV2.DataManager",
      MethodName: "FindReportDirectory",
      HospitalID: session["LOGON.HOSPID"],
      LOGONGROUPID: session["LOGON.GROUPID"],
      //ReportCode:ServerObj.ReportCode,
    },
    function (Data) {
      $("#menu-accordion").tree({
        loader: function (param, success, error) {
          var changeText = function (node) {
            node.children.forEach(function (item, index) {
              if (item.rename != "") {
                // item.text=item.rename+"("+item.text+")";
                item.text = item.rename;
              }
            });
          };
          Data.forEach(changeText);
          success(Data);
        },
        data: Data,
        onClick: function (node) {
          $("#menu-accordion").tree("toggle", node.target); //�򵥵���չ���ر�
          // url ���룬��ֹ��������
          var nodeName = encodeURIComponent(node.text);
          if (node.address == "") {
            var href =
              "nur.hisui.nursestatsreportlist.csp" +
              "?ReportCode=" +
              node.code +
              "&NodeName=" +
              nodeName; //$this.attr('src'); // node.url
          } else {
            var href =
              node.address +
              "?ReportCode=" +
              node.code +
              "&NodeName=" +
              nodeName;
          }
          var title = node.text;
          if (
            $("#menu-accordion").tree("isLeaf", node.target) &&
            !$.isEmptyObject(
              $("#menu-accordion").tree("getParent", node.target)
            )
          ) {
            addTab(title, href);
          }
          /*			
				 //���ַ��� ֻ��һ�����ڵ����
				if($(node.target).parent().parent().hasClass('accordiontree')&&node.state=="closed"){
					var roots=$('#menu-accordion').tree('getRoots');
					$.each(roots,function(i,o){
						$('#menu-accordion').tree('collapse',o.target);
					})
				}
				$('#menu-accordion').tree('toggle',node.target);	
				*/
        },

        onLoadSuccess: function (node, data) {
          if (data && ServerObj.ReportCode != "") {
            data.forEach(function (item, index) {
              if (item.children.length > 0) {
                item.children.forEach(function (n, index) {
                  // url ���룬��ֹ��������
                  var nodeName = encodeURIComponent(n.text);
                  if (ServerObj.ReportCode == n.code && n.address == "") {
                    var href =
                      "nur.hisui.nursestatsreportlist.csp" +
                      "?ReportCode=" +
                      n.code +
                      "&NodeName=" +
                      nodeName;
                    addTab(n.text, href);
                  } else if (
                    ServerObj.ReportCode == n.code &&
                    n.address !== ""
                  ) {
                    var href =
                      n.address +
                      "?ReportCode=" +
                      n.code +
                      "&NodeName=" +
                      nodeName;
                    addTab(n.text, href);
                  }
                });
              }
            });
          }

          /* ���ⳬ�� ������ʾ����
					$(".tree-title").tooltip({
	    			position: 'right',
	    			content: '<span style="color:#fff" class="__tooltip"></span>',
	    			onShow: function(){
		    			var tree_title = this;
            			//�趨��ʾ���е���ϢΪ�ڵ��е�����
	    				$('.__tooltip').text(tree_title.innerText);
						$(this).tooltip('tip').css({
						backgroundColor: '#666',
						borderColor: '#666'						
    					});		    		   
    				 }
    			  });	
    			   */
        },
      });
    }
  );
}
