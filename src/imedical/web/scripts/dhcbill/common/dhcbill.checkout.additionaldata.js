/**
 * @file dhcbill.chectout.additionaldata.js
 * 收银台--附加数据对象
 * @author ZhYW
 * @date 2021-08-30
 */

var dhcbill = window.dhcbill || {};
dhcbill.checkout = window.dhcbill.checkout || {};

/**
 * @class
 * 收银台类
 */
dhcbill.checkout.AdditionData = function (args) {
    args = args || {};
    this.title = args.title || "附加数据";
    this.payMode = args.payMode || "";
    this.patientId = args.patientId || "";
};

//构建一个块级作用域
(function () {
    //私有成员属性
    var _title = "";
    var _payMode = "";
    var _patientId = "";

    //私有方法
	var _getAdditionalData = function (paymId) {
        return $.m({ClassName: "web.UDHCOPGSConfig", MethodName: "GetAdditionalData", payMode: paymId, groupId: PUBLIC_CONSTANT.SESSION.GROUPID, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
    };

    /**
     * 初始化界面
     * 需要做配置，根据支付方式显示附属信息
     */
    var _initPanel = function () {
        var $container = $("#additionDataDlg");
        $container.find(".paym-additional").addClass("hidden");
        //根据支付方式取其附属数据 -- 需要做配置，先写死
     	var payMAddiStr = _getAdditionalData(_payMode);
        $.each(payMAddiStr.split("^"), function (index, item) {
	        var myAry = item.split("!");
          	var code = myAry[0];
         	var isRequired = myAry[2];
          	var $label = $("#" + code).prev().find(":first-child");
            if ($label.hasClass("clsRequired")) {
                $label.removeClass("clsRequired");
            }
            if (isRequired == "Y") {
                $label.addClass("clsRequired");
            }
            $("#" + code).parent().removeClass("hidden").addClass("clsRequired");
        });
    };

    //公有方法
    /**
     * 显示界面
     * @return {Boolean} true-成功，false-失败
     */
    dhcbill.checkout.AdditionData.prototype.show = function (callbackFun) {
        _title = this.title;
        _payMode = this.payMode;
        _patientId = this.patientId;

        _initPanel();

        $("#additionDataDlg").show();
        var dlgObj = $HUI.dialog("#additionDataDlg", {
                title: _title,
                iconCls: 'icon-w-plus',
                draggable: false,
                resizable: false,
                closable: false,
                cache: false,
                modal: true,
                onBeforeOpen: function () {
                    $("#additionDataDlg").form("clear");
                    if (!$("#Bank").combobox("options").url) {
	                    //银行
	                    $HUI.combobox("#Bank", {
	                        panelHeight: 150,
	                        url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QBankList&ResultSetType=array',
	                        method: 'GET',
	                        valueField: 'id',
	                        textField: 'text',
	                        blurValidValue: true,
	                        defaultFilter: 5,
	                        loadFilter: function(data) {
		                        return data.filter(function (item) {
							   		return (item.id > 0);
							  	});
		                    }
	                    });
	                }
                    
                    //公费单位
                    if (!$("#HCP").combobox("options").url) {
	                    $HUI.combobox("#HCP", {
	                        panelHeight: 150,
	                        url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryHCPList&ResultSetType=array&patientId=' + _patientId + '&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
	                        method: 'GET',
	                        valueField: 'id',
	                        textField: 'text',
	                        blurValidValue: true,
	                        defaultFilter: 5,
	                        loadFilter: function(data) {
		                        return data.filter(function (item) {
							   		return (item.id > 0);
							  	});
		                    }
	                    });
	                }
                },
                onOpen: function () {
                    var $container = $("#additionDataDlg");
                    var inputsSelector = ".paym-additional:not(.hidden) .combo-text,.paym-additional:not(.hidden) .item-textbox";
                    $container.find(inputsSelector).each(function (index, ele) {
                        if (index == 0) {
                            ele.focus();
                        }
                        $(this).on("keydown", function (e) {
                            var key = websys_getKey(e);
                            if (key == 13) {
                                var inputs = $container.find(inputsSelector); //获取所有输入框
                                var idx = inputs.index(this); //获取当前输入框的位置索引
                                var step = 1;
                                if (idx == inputs.length - 1) {
                                    //判断是否是最后一个输入框
                                    idx = -1;
                                    focusById("dlg-btn-ok");
                                    return false;
                                }
                                $(inputs[idx + step]).focus().select();
                                if ($(inputs[idx + step]).hasClass("combo-text")) {
                                    $(inputs[idx + step]).parent().prev().combo("showPanel");
                                }
                            }
                            e.stopPropagation();
                        });
                    });
                },
                buttons: [{
                        text: '确认',
                        id: 'dlg-btn-ok',
                        handler: function () {
                            var bool = true;
                            var id = "";
                            $("#additionDataDlg .paym-additional:not(.hidden) .r-label .clsRequired").each(function (index, item) {
                                id = $(this).parent().next().attr('id');
                                if (!id) {
                                    return bool;
                                }
                                if (!getValueById(id)) {
                                    bool = false;
                                    focusById(id);
                                    $.messager.popover({msg: ($g("请输入") + "<font color='red'>" + $(this).text() + "</font>"), type: "info"});
                                    return false;
                                }
                            });
                            if (!bool) {
                                return false;
                            }
                            var rtnObj = {};
                            var $container = $("#additionDataDlg");
                            var inputsSelector = ".paym-additional .additional-item";
                            $container.find(inputsSelector).each(function (index, ele) {
                                var id = $(this).attr("id");
                                var value = getValueById(id);
                                rtnObj[id] = value;
                            });
                            callbackFun(true, rtnObj);
                            dlgObj.close();
                        }
                    }, {
                        text: '关闭',
                        handler: function () {
                            callbackFun(false, {});
                            dlgObj.close();
                        }
                    }
                ]
            });
        return true;
    };
})();