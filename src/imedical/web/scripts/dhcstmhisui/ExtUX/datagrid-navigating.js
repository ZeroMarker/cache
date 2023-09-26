/**
* jQuery EasyUI 1.4.3
* Copyright (c) 2009-2015 www.jeasyui.com. All rights reserved.
*
* Licensed under the GPL license: http://www.gnu.org/licenses/gpl.txt
* To use it on other terms please contact us at info@jeasyui.com
* http://www.jeasyui.com/license_commercial.php
*
* jQuery EasyUI datagrid �����չ
* jeasyui.extensions.datagrid.navigating.js
* ���� �ǹ���
* �� ���� ����
* ������£�2016-05-10
*
* �����
*   1��jquery.jdirk.js
*
* Copyright (c) 2015 Lixilin personal All rights reserved.
*/
(function () {

    $.util.namespace("$.fn.datagrid.extensions");

    function onNavigatePaginate(paginateType, data) {
        if (paginateType == "prev") {
            $(this).datagrid("selectRow", $(this).datagrid("getRows").length - 1);
        } else {
            $(this).datagrid("selectRow", 0);
        }
    }

    function prevPage(t, opts, callback) {
        if (opts.pagination) {
            var pager = t.datagrid("getPager"), currentPageNumber = pager.pagination("options").pageNumber;
            if (currentPageNumber > 1) {
                //����ص���datagrid����
                opts.successCallBackForNavigating = function (data) {
                    if ($.isFunction(opts.onNavigatePaginate)) { opts.onNavigatePaginate.call(this, "prev", data); }
                    if (callback && $.isFunction(callback)) {
                        callback.call(t[0], data);
                    }
                };
                pager.pagination("select", currentPageNumber - 1);
            }
        }
    }

    function nextPage(t, opts, callback) {
        if (opts.pagination) {
            var pager = t.datagrid("getPager"), pagerOpts = pager.pagination("options"),
                currentPageNumber = pagerOpts.pageNumber, recordsTotal = pagerOpts.total, pageSize = pagerOpts.pageSize;
            var totalPage = Math.ceil(recordsTotal / pageSize) || 1;
            if (currentPageNumber < totalPage) {
                //����ص���datagrid����
                opts.successCallBackForNavigating = function (data) {
                    if ($.isFunction(opts.onNavigatePaginate)) { opts.onNavigatePaginate.call(this, "next", data); }
                    if (callback && $.isFunction(callback)) {
                        callback.call(t[0]);
                    }
                };
                pager.pagination("select", currentPageNumber + 1);
            }
        }
    }

    function initKeyNavigatingEvent(t, opts) {
        if (!opts.navigatingWithKey) { return; }
        if (opts.pagination) {
            var po = t.datagrid("getPager"), popts = po.pagination("options");
            var _onSelectPage = popts.onSelectPage;
            popts.onSelectPage = function (pn, ps) {
                /*��д datagrid �� onSelectPage */
                opts.pageNumber = pn || 1;
                opts.pageSize = ps;
                po.pagination("refresh", { pageNumber: pn, pageSize: ps });

                var queryParams = $.extend({ page: opts.pageNumber, rows: opts.pageSize }, opts.queryParams);
                if (opts.sortName) {
                    $.extend(queryParams, { sort: opts.sortName, order: opts.sortOrder });
                }
                if (opts.onBeforeLoad.call(t[0], queryParams) == false) {
                    return;
                }
                t.datagrid("loading");
                var loadResult = opts.loader.call(t[0], queryParams, function (data) {
                    t.datagrid("loaded");
                    t.datagrid("loadData", data);
                    //ִ�лص�
                    if ($.isFunction(opts.successCallBackForNavigating)) {
                        opts.successCallBackForNavigating.call(t[0], data);
                        opts.successCallBackForNavigating = undefined;
                    }
                }, function () {
                    t.datagrid("loaded");
                    opts.onLoadError.apply(t[0], arguments);
                });
                if (loadResult == false) {
                    t.datagrid("loaded");
                }
            };
        }
        t.datagrid("getPanel").panel("panel").attr('tabindex', 1).off('keydown.navigating').on('keydown.navigating', function (e) {
            switch (e.keyCode) {
                // Up
                case 38:
                    e.preventDefault();
                    var selected = t.datagrid("getSelections");
                    var targetIndex = -1;
                    if (selected && selected.length) {
                        var indexs = $.array.map(selected, function (item) {
                            return t.datagrid("getRowIndex", item);
                        });
                        var index = $.array.min(indexs);
                        if (index > 0) {
                            targetIndex = index - 1;
                            t.datagrid("selectRow", targetIndex);
                            if (opts.navigateHandler && opts.navigateHandler.up && $.isFunction(opts.navigateHandler.up)) {
                                opts.navigateHandler.up.call(t[0], targetIndex);
                            }
                        }
                        else {
                            prevPage(t, opts, function (data) {
                                if ($.util.isObject(data)) {
                                    targetIndex = data.rows.length - 1;
                                } else {
                                    targetIndex = data.length - 1;
                                }
                                if (opts.navigateHandler && opts.navigateHandler.up && $.isFunction(opts.navigateHandler.up)) {
                                    opts.navigateHandler.up.call(t[0], targetIndex);
                                }
                            });
                        }
                    } else {
                        targetIndex = t.datagrid("getRows").length - 1;
                        t.datagrid("selectRow", targetIndex);
                        if (opts.navigateHandler && opts.navigateHandler.up && $.isFunction(opts.navigateHandler.up)) {
                            opts.navigateHandler.up.call(t[0], targetIndex);
                        }
                    }
                    break;
                // Down
                case 40:
                    e.preventDefault();
                    var selected = t.datagrid("getSelections");
                    var targetIndex = -1;
                    if (selected && selected.length) {
                        var indexs = $.array.map(selected, function (item) {
                            return t.datagrid("getRowIndex", item);
                        });
                        var index = $.array.max(indexs), rows = t.datagrid("getRows");
                        if (index < rows.length - 1) {
                            targetIndex = index + 1;
                            t.datagrid("selectRow", targetIndex);
                            if (opts.navigateHandler && opts.navigateHandler.down && $.isFunction(opts.navigateHandler.down)) {
                                opts.navigateHandler.down.call(t[0], targetIndex);
                            }
                        }
                        else {
                            targetIndex = 0;
                            nextPage(t, opts, function () {
                                if (opts.navigateHandler && opts.navigateHandler.down && $.isFunction(opts.navigateHandler.down)) {
                                    opts.navigateHandler.down.call(t[0], targetIndex);
                                }
                            });
                        }
                    } else {
                        targetIndex = 0;
                        t.datagrid("selectRow", targetIndex);
                        if (opts.navigateHandler && opts.navigateHandler.down && $.isFunction(opts.navigateHandler.down)) {
                            opts.navigateHandler.down.call(t[0], targetIndex);
                        }
                    }
                    break;
                // Left
                case 37:
                    e.preventDefault(); prevPage(t, opts);
                    break;
                // Right
                case 39:
                    e.preventDefault(); nextPage(t, opts);
                    break;
                // Enter
                case 13:
                    if (opts.navigateHandler && opts.navigateHandler.enter && $.isFunction(opts.navigateHandler.enter)) {
                        e.preventDefault();
                        var selected = t.datagrid("getSelections");
                        if (selected) {
                            opts.navigateHandler.enter.call(t[0], selected);
                        }
                    }
                    break;
            }
        });
    };

    function initializeExtensions(target) {
        var t = $(target),
            state = $.data(target, "datagrid"),
            opts = state.options;

        initKeyNavigatingEvent(t, opts);
        if (opts.navigatingWithKey) { t.datagrid("getPanel").panel("panel").focus(); }
    }

    var _datagrid = $.fn.datagrid;
    $.fn.datagrid = function (options, param) {
        if (typeof options == "string") {
            return _datagrid.apply(this, arguments);
        }
        options = options || {};
        return this.each(function () {
            var jq = $(this),
                isInited = $.data(this, "datagrid") ? true : false,
                opts = isInited ? options : $.extend({},
                        $.fn.datagrid.parseOptions(this),
                        $.parser.parseOptions(this, [
                            {
                                navigatingWithKey: "boolean"
                            }
                        ]), options);
            _datagrid.call(jq, opts, param);
            if (!isInited) {
                initializeExtensions(this);
            }
        });
    };
    $.union($.fn.datagrid, _datagrid);

    var methods = {

    };

    var defaults = {

        //  ��չ easyui-datagrid ���Զ������ԣ���ʾ�Ƿ��������������ܣ�
        //      Up ����selected ����������
        //      Down ����selected ����������
        //      Left ������һҳ����������һҳʱ��Ч
        //      Right ������һҳ����������һҳʱ��Ч
        //      Enter �������� datagrid onDblClickRow �¼��������� selected ������ʱ��Ч
        navigatingWithKey: true,

        //  ��չ easyui-datagrid ���Զ����¼�����ʾͨ�������������з�ҳ�󴥷����¼������¼��ص������ṩ���²�����
        //      paginateType:  ��ʾ��ҳ���ͣ���ֵ������ prev��next���ֱ��ʾ��һҳ����һҳ��
        //      data: ��ʾ��ҳ������ݶ��󣬸����ݶ�������� object���� total��rows ���ԣ���Ҳ������ array��
        //  ���¼������е� this ָ��ǰ easyui-datarid �� DOM ����(�� jQuery ����)��
        onNavigatePaginate: onNavigatePaginate,

        //  ��չ easyui-datagrid ���Զ�����󣻱�ʾ��������ִ�к󴥷����¼����ϣ��ö���֧�������¼����ԣ�
        //      up:  ��ʾ���ϡ����������󴥷����¼������¼��ĺ���ǩ�� targetIndex ��ʾ������������е�������
        //      down:  ��ʾ���¡����������󴥷����¼������¼��ĺ���ǩ�� targetIndex ��ʾ������������е�������
        //      enter:  ��ʾ���س������������󴥷����¼������¼��ĺ���ǩ�� selectedData ��ʾ�Ѿ� selected �������У�
        //              ע�⣺selectedData ������Ϊ object ���� array ȡ���ڵ�ǰ easyui-datagrid �ǵ�ѡ���Ƕ�ѡ��
        //  �����¼������е� this ָ��ǰ easyui-datarid �� DOM ����(�� jQuery ����)��
        navigateHandler: {
            up: function (targetIndex) { },
            down: function (targetIndex) { },
            enter: function (selectedData) { }
        }
    };

    if ($.fn.datagrid.extensions.defaults) {
        $.extend($.fn.datagrid.extensions.defaults, defaults);
    } else {
        $.fn.datagrid.extensions.defaults = defaults;
    }

    if ($.fn.datagrid.extensions.methods) {
        $.extend($.fn.datagrid.extensions.methods, methods);
    } else {
        $.fn.datagrid.extensions.methods = methods;
    }

    $.extend($.fn.datagrid.defaults, defaults);
    $.extend($.fn.datagrid.methods, methods);

})(jQuery);