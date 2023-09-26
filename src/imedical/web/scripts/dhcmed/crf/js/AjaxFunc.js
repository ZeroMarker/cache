/*
*封装ajax的调用方法，使用之前先引用jQuery类库
*增加了对异常的处理，直接显示错误页面
*Success中是被我们捕捉到的，但是还想显示错误界面的时候的处理方式
*error中处理的是对我们未捕捉的异常，都将采取直接弹出错误框的形式
*/
function AjaxInvoke(url, data, type, succcallback, async) {
    if (data == null || data.length < 1) {
        $.ajax({
            type: type,
            dataType: "text",
            url: url,
            async: async,
            success: function (d) {
            	d = eval("("+d+")");
                if (!d.Result) {
                    if (d.Message == "DHCSYSTEMERROR") {
                        //window.open("MessagesWebControls.do/SystemMessage/DHCSYSTEMERROR", "mainFrame");
                    } else if (d.Message == "DHCNOAUTHORIZATE") {
                        //window.open("MessagesWebControls.do/SystemMessage/DHCNOAUTHORIZATE", "mainFrame");
                    } else {
                        if (succcallback != null) {
                            succcallback(d);
                        }
                    }
                } else {
                    if (succcallback != null) {
                        succcallback(d);
                    }
                }
            },
            error: function (d) {
                if (d.responseText.indexOf("用户登录") != -1) {
                    //window.open("Login.do", "_self");
                } else {
                    //window.open("MessagesWebControls.do", "mainFrame");
                }
            }
        });
    } else {
    $.ajax({
        type: type,
        dataType: "text",
        url: url,
        data: data,
        //contentType:'multipart/form-data',
        async: async,
        success: function (d) {
            if (!d.Result) {
            	  d = eval("("+d+")");
                if (d.Message == "DHCSYSTEMERROR") {
                    //window.open("MessagesWebControls.do/SystemMessage/DHCSYSTEMERROR", "mainFrame");
                } else if (d.Message == "DHCNOAUTHORIZATE") {
                    //window.open("MessagesWebControls.do/SystemMessage/DHCNOAUTHORIZATE", "mainFrame");
                } else {
                    if (succcallback != null) {
                        succcallback(d);
                    }
                }
            } else {
                if (succcallback != null) {
                    succcallback(d);
                }
            }
        },
        error: function (d) {
            if (d.responseText.indexOf("用户登录") != -1 || d.responseText.indexOf("<script>window.parent.location='Login.do'</script>") != -1) {
                //window.open("Login.do", "_self");
            } else {
                //window.open("MessagesWebControls.do", "mainFrame");
            }
        }
    });
    }
}

/*
 * 封装ajax的调用方法，使用之前先引用jQuery类库 增加了对异常的处理，直接显示错误页面
 * Success中是被我们捕捉到的，但是还想显示错误界面的时候的处理方式 error中处理的是对我们未捕捉的异常，都将采取直接弹出错误框的形式
 * 返回从url取得的数据的DataObject中的数据
 * gaojb 2010-11-20
 */
function AjaxReturn(url, data, type, async) {
	var result;
	if (data == null || data.length < 1) {
		$.ajax({
			type : type,
			dataType : "json",
			url : text,
			async : async,
			success : function(d) {
				if (!d.Result) {
					if (d.Message == "DHCSYSTEMERROR") {
						//window.open("MessagesWebControls.do/SystemMessage/DHCSYSTEMERROR","mainFrame");
						return null;
					} else if (d.Message == "DHCNOAUTHORIZATE") {
						//window.open("MessagesWebControls.do/SystemMessage/DHCNOAUTHORIZATE","mainFrame");
						return null;
					} else {
						result = d.DataObject;
					}
				} else {
					result = d.DataObject;
				}
			},
			error : function(d) {
				if (d.responseText.indexOf("用户登录") != -1) {
					//window.open("Home.do/Login", "_self");
					return null;
				} else {
					//window.open("MessagesWebControls.do", "mainFrame");
					return null;
				}
			}
		});
	} else {
		$.ajax({
			type : type,
			dataType : "text",
			url : url,
			data : data,
			async : async,
			success : function(d) {
				if (!d.Result) {
					if (d.Message == "DHCSYSTEMERROR") {
						
						return null;
					} else if (d.Message == "DHCNOAUTHORIZATE") {
						
						return null;
					} else {
						result = d.DataObject;
					}
				} else {
					result = d.DataObject;
				}
			},
			error : function(d) {
				if (d.responseText.indexOf("用户登录") != -1) {
					//window.open("Home.do/Login", "_self");
					return null;
				} else {
					//window.open("MessagesWebControls.do", "mainFrame");
					return null;
				}
			}
		});
	}
	
	return result;
}