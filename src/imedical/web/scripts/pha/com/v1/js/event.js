/**
 * ����:	 ҩ�������¼���
 * ��д��:	 yunhaibao
 * ��д����: 2019-03-12
 */
PHA_EVENT = {
    CurrentGrid: ''
};
$(function () {
    if (typeof PHA_SYS_SET == 'undefined') {
        if (PHA_COM.ResizePhaColParam.auto) {
            PHA_COM.ResizePhaCol(); // TODO...
        }
        return;
    }

    /**
     * ��ť�Ҽ����ÿ�ݼ�
     */
    $('a[id]').on('contextmenu', function (e) {
        e.preventDefault();
        var _domObj = this;
        // PHA_PLUS.Key('Menu', _domObj);
        PHA_SYS_SET.Form.ButtonSet.ShowMenu(_domObj);
    });
    /**
     * ����ҳ��Ԫ��
     */
    hotkeys('ctrl+alt+i', function (e, h) {
        PHA.Confirm('��ܰ��ʾ', '�Ƿ�ȷ����ϵͳ������<b>[��]</b>��Ϣ��', function () {
            PHA_SYS_SET.Form.Create();
        });
    });
    /**
     * ͬ�������
     */
    hotkeys('ctrl+alt+g', function (e, h) {
        PHA.Confirm('��ܰ��ʾ', '�Ƿ�ȷ����ϵͳ��ͬ��<b>[���]</b>��Ϣ��', function () {
            PHA_SYS_SET.Grid.SyncCols();
        });
    });
    /**
     * ɾ��ҳ������ 2021-08-19 Huxt
     */
    hotkeys('ctrl+alt+k', function (e, h) {
        PHA.Confirm('��ܰ��ʾ', '�Ƿ�ȷ����ϵͳ��ɾ��<b>[ҳ������]</b>��Ϣ��<br/>����ܰ�������С��������ã�ɾ��������������ã�', function () {
            PHA_SYS_SET.Com.DeletePageCfg();
        });
    });
    /**
     * ��ɸѡ 2021-11-24 yunhaibao
     */
    setTimeout(function () {
        $('.datagrid-view2 .datagrid-body').on('click', function (e) {
            PHA_EVENT.CurrentGrid = $(e.target).parents('.datagrid-view').parent().find('[id].datagrid-f').attr('id');
        });
        hotkeys('ctrl+alt+f', function (e, h) {
            try {
                if (PHA_EVENT.CurrentGrid) {
                    var maxPageSize = 9999;
                    var $grid = $('#' + PHA_EVENT.CurrentGrid);
                    var gridOpts = $grid.datagrid('options');
                    var clientPaging = gridOpts.clientPaging;
                    var remoteFilter = gridOpts.remoteFilter;

                    var filterHand = $grid.datagrid('isFilterEnabled') === true ? 'disableFilter' : 'enableFilterAll';
                    if (filterHand === 'enableFilterAll' && !$.fn.datagrid.methods[filterHand]) {
                        filterHand = 'enableFilter';
                    }
                    if (filterHand.indexOf('enable') >= 0) {
                        gridOpts.pageOriginalSize = gridOpts.pageSize;
                    }
                    $grid.datagrid(filterHand);
                    $grid.datagrid('options').clientPaging = clientPaging;
                    if (remoteFilter === false && gridOpts.pagination == true) {
                        // ����ɸѡʱ, �����ݲ���ҳ
                        var $pager = $grid.datagrid('getPager');
                        var pageList = $pager.pagination('options').pageList;

                        if (pageList.indexOf(maxPageSize) < 0) {
                            pageList.push(maxPageSize);
                        }
                        if (filterHand.indexOf('enable') >= 0) {
                            $pager.pagination({
                                pageList: pageList,
                                pageSize: maxPageSize,
                                pageNumber: 1
                            });
                            $grid.datagrid('options').pageSize = maxPageSize;
                            $grid.datagrid('reload');
                        }
                    }
                }
            } catch (error) {
                console.warn('event.js:' + error.message);
            }
        });
    }, 1000);

    /**
     * ��ʼ��ҳ��Ԫ������
     */
    if (typeof PHA_SYS_SET != 'undefined') {
        PHA_SYS_SET.Init();
    }
});
var PHA_EVENT = {
    Key: function (keyArr) {
        keyArr = keyArr || '';
        if (keyArr === '') {
            keyArr = [
                ['btnFind', 'alt+F'],
                ['btnFind', 'ctrl+enter'],
                ['btnSave', 'f2']
            ];
        }
        if (keyArr.length === 0) {
            return;
        }
        this.KeyHandler(keyArr);
        this.KeyPop(keyArr);
    },
    KeyHandler: function (keyArr) {
        var handlerArr = [];
        var codeArr = [];
        for (var i = 0; i < keyArr.length; i++) {
            var keyData = keyArr[i];
            handlerArr.push(keyData[0]);
            codeArr.push(keyData[1]);
        }

        /**
         * key�¼�һ�ΰ�
         */
        hotkeys(codeArr.join(','), function (e, h) {
            e.preventDefault();
            /* �޸�������������ͬһ����ť�������縶���ѯ���� */
            var startIndex = 0;
            var handIndex;
            while ((handIndex = codeArr.indexOf(h.key, startIndex)) > -1) {
                var hand = handlerArr[handIndex];
                if (typeof hand === 'function') {
                    hand();
                } else {
                    $('#' + hand).click();
                }
                startIndex = handIndex + 1;
            }
            /*var hand = handlerArr[codeArr.indexOf(h.key)];
            if (typeof hand === 'function') {
                hand();
            } else {
                $('#' + hand).click();
            }*/
            return false;
        });
    },
    KeyPop: function (keyArr) {
        var keyObj = {};
        for (var i = 0; i < keyArr.length; i++) {
            var keyData = keyArr[i];
            var hand = keyData[0];
            var code = keyData[1];
            if (typeof hand === 'function') {
                continue;
            }
            var codeHtml = code; //'<div style="display:inline-block;padding-left:10px;padding-right:10px;background:#000;border-radius:4px;line-height:18px">'+code+'</div>'
            if (keyObj[hand]) {
                keyObj[hand] += '</br>' + codeHtml;
            } else {
                keyObj[hand] = codeHtml;
            }
        }
        for (var id in keyObj) {
            $('#' + id).tooltip({
                content: keyObj[id],
                position: 'left',
                showDelay: 1500
            });
        }
    },
    Bind: function (target, handle, callBack) {
        $(target).on(handle, function (e) {
            var $target = $(this);
            if ($target.linkbutton('options').disabled === true) {
                return;
            }
            
            $target.linkbutton('disable');
            try{
                callBack.call(this, e);
            }catch(error){
                PHA.Alert('������ʾ', 'event.js PHA_EVENT.Bind</br>' + '��'+$target.text()+'��' + '�󶨵��¼��ڴ����쳣</br>'+error, 'error')
            }
            
            // ����1s, �����ڻص������п���
            var timeNum = setTimeout(function () {
                $.data($target[0], 'timer', '')
                $target.linkbutton('enable');
            }, 500);
            $.data($target[0], 'timer', timeNum)
        });
        $(target).on(handle + '-i', function (e) {
            callBack.call(this, e);
        });
    }
};
// �������κα�ǩ,ȫ��������
hotkeys.filter = function (event) {
    //  var tagName = (event.target || event.srcElement).tagName;
    //  hotkeys.setScope(/^(INPUT|TEXTAREA|SELECT)$/.test(tagName) ? 'input' : 'other');
    return true;
};