/**
 * 编写者:   yunhaibao
 * 编写日期: 2020-04-12
 * 说明:    住院药房公共JS
 */
var PHAIP_COM = {
    DataApi: {
        Msg: function (msgJson) {
            var messageStr = msgJson.message;
            messageArr = messageStr.split('</br>');
            messageStr = messageArr.slice(0, 5).join('</li><li style="padding-left:13px;padding-top:5px;">');
            // if (messageArr.length > 5) {
            //     messageStr += '</li><li style="padding-left:13px">. . . ';
            // }
            var msg = '';
            msg += '<div style="line-height:32px">';
            msg += '    <span style="color:#757575;font-weight:bold">总记录:' + msgJson.recordCnt + '</span>';
            msg += '    <span style="padding-left:10px;color:#00B69C;font-weight:bold">成功:' + msgJson.succCnt + '</span>';
            msg += '    <span style="padding-left:10px;color:#FFA804;font-weight:bold">失败:' + msgJson.failCnt + '</span>';
            msg += '</div>';
            msg += '<div style="border-top:1px solid #cccccc;margin-left:-40px;margin-top:10px"></div>';
            msg += '<div style="color:#757575;padding-top:10px;margin-left:-13px">';
            msg += '    <ul style="list-style-type:disc;">';
            msg += '        <li style="padding-left:13px">' + messageStr + '</li>';
            msg += '    </ul>';
            msg += '</div>';
            return msg;
        }
    },
    LocalFilterGroup: PHA_COM.LocalFilterGroup,
    LocalFilter: function (data) {
        var $grid = $(this);
        var opts = $grid.datagrid('options');
        var pager = $grid.datagrid('getPager');
        pager.pagination({
            onSelectPage: function (pageNum, pageSize) {
                opts.pageNumber = pageNum;
                opts.pageSize = pageSize;
                pager.pagination('refresh', {
                    pageNumber: pageNum,
                    pageSize: pageSize
                });
                $grid.datagrid('loading');
                setTimeout(function () {
                    $grid.datagrid('loadData', data);
                }, 100);
            }
        });
        if (!data.originalRows) {
            data.originalRows = data.rows;
        }
        var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
        var end = start + parseInt(opts.pageSize);
        data.rows = data.originalRows.slice(start, end);
        return data;
    },
    /**
     * 窗口卸载时,删除产生的临时数据
     * @param {String} clsName 类名全称
     * @param {String} pid 进程号
     */
    KillTmpOnUnLoad: function (clsName, pid) {
        window.addEventListener('beforeunload', function () {
            if (navigator.sendBeacon) {
                navigator.sendBeacon($URL + '?ClassName=PHA.IP.COM.Base&MethodName=KillTmp&clsName=' + clsName + '&pid=' + pid, '');
            } else {
                tkMakeServerCall('PHA.IP.COM.Base', 'KillTmp', clsName, pid);
            }
        });
    },
    /**
     * 控制条件区域的title是否显示
     *
     */
    PanelCondition: function (_options) {
        if (PHA_COM.IsTabsMenu() === true) {
            var tmpHeightArr = _options.heightArr;
            for (var i = 0; i < tmpHeightArr.length; i++) {
                tmpHeightArr[i] = tmpHeightArr[i] - 33;
            }
            $(_options.panel).panel({
                title: ''
            });
            $(_options.field + ' div').text('');
            $(_options.body).layout('panel', 'north').panel('resize', { height: tmpHeightArr[0] });
            $(_options.body).layout('resize');
        } else {
            $(_options.panel).panel({});
        }

        var heightArr = _options.heightArr;
        $(_options.field).on('click', function (e) {
            $(_options.field).toggle();
            $(_options.field + '-link').toggle();
            var tHeight = $(_options.field + '-link').css('display') === 'block' ? heightArr[1] : heightArr[0];
            $(_options.body).layout('panel', 'north').panel('resize', { height: tHeight });
            $(_options.body).layout('resize');
        });
    },
    Grid: {
        Formatter: {
            YesNo: function (value, row, index) {
                if (value === 'Y') {
                    return PHA_COM.Fmt.Grid.Yes.Chinese;
                }
                if (value === 'N') {
                    return PHA_COM.Fmt.Grid.No.Chinese;
                }
                return value;
            }
        }
    },
    AppendLogonData: function (jsonObj) {
        return PHA_COM.AppendLogonData(jsonObj);
    },
    Invoke: function (cmOptions, iOptions) {
        PHA.Loading('Show');
        var ret;
        var callBack = iOptions.callBack;
        $.cm(
            cmOptions,
            function (retData) {
                PHA.Loading('Hide');
                callBack(ret);
            },
            function (retData) {
                PHA.Loading('Hide');
                callBack(ret);
            }
        );
    },
    InvokeSyn: function (cmOptions) {
        return $.cm(cmOptions, false);
    },
    PageCheckHandler: function ($grid, checkFlag) {
        if ($grid.datagrid('options').checking == true) {
            return;
        }
        var opts = $grid.datagrid('getPager').pagination('options');
        var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
        var end = start + parseInt(opts.pageSize);
        this.LocalCheckPage($grid, checkFlag, start, end);
    },
    LocalCheckPage: function ($grid, checkFlag, start, end) {
        var origRows = $grid.datagrid('getData').originalRows;
        if (origRows === undefined) {
            return;
        }
        var rowData;
        var uniqueArr = [],
            uniqueValue;
        var linkField = $grid.datagrid('options').linkField || '';
        var len = origRows.length;
        var iCnt = -1;

        for (var i = 0; i < len; i++) {
            rowData = origRows[i];

            if (linkField !== '') {
                uniqueValue = rowData[linkField];
            } else {
                uniqueValue = i;
            }

            if (uniqueArr.indexOf(uniqueValue) < 0) {
                iCnt++;
            }
            uniqueArr.push(uniqueValue);
            if (iCnt < start) {
                continue;
            }
            if (iCnt >= end) {
                break;
            }
            origRows[i].check = checkFlag;
        }
    },
    GetOriginalChecked: function (target) {
        var retArr = [];
        var origRows = $(target).datagrid('getData').originalRows;
        if (typeof origRows === 'undefined') {
            return retArr;
        }
        var len = origRows.length;
        for (var i = 0; i < len; i++) {
            var rowData = origRows[i];
            if (rowData.canUpdate !== 'Y') {
                continue;
            }
            var mDspBat = {
                mDsp: rowData.mDsp,
                batNo: rowData.batNo
            };
            retArr.push(mDspBat);
        }
        return retArr;
    },
    GetMac: function () {
        if (typeof isIECore != 'undefined' && isIECore == false) {
            if ('undefined' != typeof EnableLocalWeb && EnableLocalWeb == 1) {
                if (getClientIP) {
                    var ipData = getClientIP();
                    if (ipData != '') {
                        return ipData.split('^')[2];
                    }
                }
            }
        }
        var macAddr = '';
        try {
            var locator = new ActiveXObject('WbemScripting.SWbemLocator');
            var service = locator.ConnectServer('.'); //连接本机服务器
            var properties = service.ExecQuery('SELECT * FROM Win32_NetworkAdapterConfiguration Where IPEnabled =True'); //查询使用SQL标准
            var e = new Enumerator(properties);
            var p = e.item();
            for (; !e.atEnd(); e.moveNext()) {
                var p = e.item();
                if (p.MACAddress == null) {
                    continue;
                }
                macAddr = p.MACAddress;
                if (macAddr) break;
            }
        } catch (e) {
            return macAddr;
        }
        return macAddr;
    },
    SameRows: function (gridID, sameFields) {
        var _gridID = gridID;
        var _personSameFields = sameFields;
        return {
            Hide: function () {
                $('#' + _gridID)
                    .closest('.datagrid-view')
                    .find('[datagrid-row-index=0] .pha-ip-person-toggle')
                    .removeClass('pha-ip-person-toggle');
                var $person = $('.pha-ip-person-toggle').closest('tr').children(_personSameFields).children();
                $person.hide();
                $person.css('white-space', 'nowrap');
                // $person.css('display', 'none important');
            },
            HideRow: function (rowIndex) {
                this.GetEle(rowIndex).hide();
            },
            ShowRow: function (rowIndex) {
                this.Hide();
                this.GetEle(rowIndex).show();
            },
            GetStat: function (rowIndex) {
                var stat = this.GetEle(rowIndex).css('display') || '';
                if (stat === '') {
                    return '';
                }
                return stat === 'block' ? 'show' : 'hide';
            },
            GetEle: function (rowIndex) {
                var $ele = $('#' + _gridID)
                    .closest('.datagrid-view')
                    .find('[datagrid-row-index=' + rowIndex + ']')
                    .children(_personSameFields)
                    .children();
                return $ele;
            },
            UpdateRow: function (rowIndex, rowData) {
                var stat = this.GetStat(rowIndex);
                $('#' + _gridID).datagrid('updateRow', {
                    index: rowIndex,
                    row: rowData
                });
                if (stat === 'show') {
                    this.ShowRow(rowIndex);
                }
                if (stat === 'hide') {
                    this.HideRow(rowIndex);
                }
            }
        };
    },
    /**
     * 分组标识
     * @param {}} value
     */
    OrderLinkSign: function (value) {
        if (value == '│' || value == '0') {
            return '<div class="pha-ip-orderlinksign-c">│</div>';
        } else if (value == '┍' || value == '-1') {
            return '<div class="pha-ip-orderlinksign-t">┍</div>';
        } else if (value == '┕' || value == '1') {
            return '<div class="pha-ip-orderlinksign-b">┕</div>';
        } else {
            return value;
        }
    },
    DataGridLinkCheck: function ($grid, type, rowIndex, rowData, callBack) {
        if ($grid.datagrid('options').checking == true) {
            return;
        }
        $grid.datagrid('options').checking = true;
        var linkField = $grid.datagrid('options').linkField;
        var linkValue = rowData[linkField];
        var rows = $grid.datagrid('getRows');
        var len = rows.length;
        for (var i = rowIndex; i < len; i++) {
            if (linkValue === rows[i][linkField]) {
                $grid.datagrid(type, i);
                if (callBack) {
                    callBack(i, rows[i]);
                }
            } else {
                break;
            }
        }
        // 向上
        for (var j = rowIndex; j >= 0; j--) {
            if (linkValue === rows[j][linkField]) {
                $grid.datagrid(type, j);
                if (callBack) {
                    callBack(j, rows[j]);
                }
            } else {
                break;
            }
        }
        $grid.datagrid('options').checking = '';
    },
    CACert: PHA_COM.CACert,
    ToggleMore: function (domID, moreTarget, options) {
        PHA.ToggleButton(domID, {
            buttonTextArr: ['更多', '隐藏'],
            selectedText: '更多',
            onClick: function (oldText, newText) {}
        });
        options = options || {};
        $('#' + domID).popover(
            $.extend(
                {
                    trigger: 'click',
                    placement: 'auto',
                    content: 'content',
                    dismissible: false,
                    // width: 1300,
                    padding: false,
                    url: moreTarget
                },
                options
            )
        );
    },
    GetTdRangeWidth: function (target, start, end) {
        target = $('#gridInciBar > table > tbody > tr:nth-child(2)');
    },
    /**
     * 取消选择关键字
     * @param {*} target 目标元素
     * @param {*} idArr 需要不选择的数组
     * PHAIP_COM.UnSelectKeyWords('#kwPrintWay', ['total','detail'])
     */
    UnSelectKeyWords: function (target, idArr) {
        var selectedData = $(target).keywords('getSelected');
        for (var i = 0, length = selectedData.length; i < length; i++) {
            var iData = selectedData[i];
            if (idArr.indexOf(iData.id) >= 0) {
                $(target).keywords('select', iData.id);
            }
        }
    }
};

