/**
 * @creator:yunhaibao
 * @createdate:2016-08-06
 * @description:二次封装一些插件
 * @others:select2,jqGrid,bootbox,bootstrap-combobox,daterangepicker
 * pharmacy/common/js/dhcpha.plugins.js
 */
 
$(function () {
    /* select2 start */
    /* https://www.select2.cn */
    $.fn.dhcphaSelect = function (_options, _ajaxOption) {
        // 默认配置
        options = {
            // multiple:true,
            width: 150,
            language: 'zh-CN',
            // dropdownAutoWidth: true,
            // tags: "true",
            allowClear: true,
            placeholder: '请选择'
        };
        var langCode = session['LOGON.LANGCODE'] || 'CH';
        if(langCode === 'EN'){
            options.language = {
                searching: function(){
                    return 'Searching...'
                }
            }
            options.placeholder = 'Please Select...'
        }
        var ajaxUrl = _options.url || '';
        if (ajaxUrl !== '') {
            if (typeof HospId !== 'undefined') {
                var hospParam = 'hosp=' + HospId + '&HospId=' + HospId;
                if (ajaxUrl.indexOf('?') > 0) {
                    ajaxUrl += '&' + hospParam;
                } else {
                    ajaxUrl += '?' + hospParam;
                }
            }
        }
        ajaxOption = {
            ajax: {
                url: ajaxUrl,
                dataType: 'json',
                delay: 250,
                method: 'POST',
                data: function (params) {
                    return {
                        combotext: params.term
                    };
                },
                processResults: function (data, params) {
                    return {
                        results: data
                    };
                },
                cache: true
            }
        };
        if (_ajaxOption) {
            $.extend(ajaxOption.ajax, _ajaxOption);
        }
        var opts = $.extend({}, options, _options);
        opts = _options.url == undefined ? opts : $.extend({}, opts, ajaxOption);
        $(this).select2(opts);
        $('#select2-' + this.id + '-container').attr('title', '');
        // 控制删除数据后,依然有悬浮显示的问题
        $(this).on('select2:close', function () {
            if (($(this).val() || '') == '') {
                $('#select2-' + this.id + '-container').attr('title', '');
            }
        });
        $(".select2-selection__rendered").hover(function(){
	    	$(this).removeAttr("title")
	    })
        // 样式修改
        var tmpselect2style = $(this).next().children().find('.select2-selection__arrow');
        tmpselect2style.removeClass('select2-selection__arrow');
        var tmpselect2html = '<span class="fa fa-chevron-down" role="" style="width:30px;height:30px;background-color:#40a2de;text-align:center;position:absolute;top:0em;right:0em;color:#fff;padding-top:0.6em;"></span>';
        tmpselect2style.append(tmpselect2html);
        $('.select2-selection').on('keydown', function (e) {
            e.preventDefault();
        });
    };
    /* select2 end*/

    /* iCheck start*/
    $.fn.dhcphaCheck = function () {
        options = {
            checkboxClass: 'icheckbox_minimal-blue',
            radioClass: 'iradio_minimal-blue',
            increaseArea: '20%' // optional
        };
        $(this).iCheck(options);
    };
    /* iCheck end*/
    
    /* dateRange start */
    $.fn.dhcphaDateRange = function (_options) {
        var dhcphadatelocal;
        options = {
            autoApply: true,
            applyClass: 'btn btn-primary  dhcpha-btn-common dhcpha-btn-normal',
            cancelClass: 'btn btn-primary  dhcpha-btn-common dhcpha-btn-normal',
            locale: {
                timePicker12Hour: false,
                applyLabel: '确定',
                cancelLabel: '取消',
                format: DHCPHA_CONSTANT.PLUGINS.DATEFMT,
                separator: ' 至 ',
                daysOfWeek: ['日', '一', '二', '三', '四', '五', '六'],
                monthNames: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']
            }
            /*
            timePicker : true,
            timePickerIncrement:1,
            showDropdowns : false,
            showWeekNumbers : false, // 是否显示第几周
            ranges : {  // 自定义快捷范围
                '今日': [moment().startOf('day'), moment()],
                '昨日': [moment().subtract('days', 1).startOf('day'), moment().subtract('days', 1).endOf('day')],
                '最近7日': [moment().subtract('days', 6), moment()],
                '最近30日': [moment().subtract('days', 29), moment()]
            },
            */
        };
        var langCode = session['LOGON.LANGCODE'] || 'CH';
        if(langCode === 'EN'){
            options.locale = {
                timePicker12Hour: false,
                applyLabel: 'Apply',
                cancelLabel: 'Cancle',
                format: DHCPHA_CONSTANT.PLUGINS.DATEFMT,
                separator: ' To ',
                daysOfWeek: ['S','M','T','W','T','F','S'],
                monthNames:  ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
            }
            options.placeholder = 'Please Select...'
        }
        if (_options != undefined) {
            _options.locale = $.extend({}, options.locale, _options.locale);
        }
        var opts = $.extend({}, options, _options);
        $(this).daterangepicker(opts);
        // 绑定点击
        var thiscalendar = this;
        $(this)
        .next()
        .children('i')
        .click(function () {
            $(thiscalendar).click();
        });
    };
    /* dateReange end */

    /* jqGrid start */
    $.fn.dhcphaJqGrid = function (_options) {
        options = {
            loadui: 'block',
            multiboxonly: true,
            scrollrows: true,
            gridview: true, //设置为true将提高5~10倍的显示速度。但不能再使用treeGrid, subGrid, 或afterInsertRow事件
            mtype: 'POST', //提交方式
            datatype: 'json',
            autowidth: true, //自适应宽度
            autoheight: true, //自适应高度
            //rownumbers:true,//添加左侧行号
            altRows: false, //设置为交替行表格,默认为false
            //sortname:'createDate',
            //sortorder:'asc',
            viewrecords: true, //是否在浏览导航栏显示记录总数
            rowNum: 100, //每页显示记录数
            rowList: [50, 100, 300, 500], //用于改变显示行数的下拉列表框的元素数组
            rownumWidth: 35, // the width of the row numbers columns
            pagerpos: 'left',
            recordpos: 'right',
            //recordtext: '当前记录{0}--{1}条　共{2}条记录',
            //pgtext: '<div style="height:auto">第{0} 共{1}页</div>',
            autoScroll: true,
            shrinkToFit: true,
            refresh: true,
            //loadtext: '数据加载中...',
            //emptyrecords: '没有数据',
            sortable: false,
            multiselectWidth: '30px',
            //scrollOffset:'0px', //预留的,如果为0,则加载数据后会显示横向滚动条
            jsonReader: {
                rows: 'rows',
                records: 'total',
                total: 'pages',
                repeatitems: false,
                id: 'Id'
            },
            prmNames: {
                page: 'page', //表示请求页码的参数名称
                rows: 'rows', //表示请求行数的参数名称
                sort: 'sidx', //表示用于排序的列名的参数名称
                order: 'sord', //表示采用的排序方式的参数名称
                search: '_search', //表示是否是搜索请求的参数名称
                nd: 'nd', //表示已经发送请求的次数的参数名称
                id: 'id', //表示当在编辑数据模块中发送数据时，使用的id的名称
                oper: 'oper', //operation参数名称（我暂时还没用到）
                editoper: 'edit', //当在edit模式中提交数据时，操作的名称request.getParameter("oper") 得到edit
                addoper: 'add', //当在add模式中提交数据时，操作的名称request.getParameter("oper") 得到add
                deloper: 'del', //当在delete模式中提交数据时，操作的名称request.getParameter("oper") 得到del
                subgridid: 'id', //当点击以载入数据到子表时，传递的数据名称
                npage: null,
                totalrows: 'totalrows' //表示需从Server得到总共多少行数据的参数名称，参见jqGrid选项中的rowTotal
            },
            loadError: function (xhr, status, error) {
                alert(status + ' 加载数据中 ' + $(this).attr('id') + ' : ' + error + '; 响应结果: ' + xhr.status + ' ' + xhr.statusText);
            }
        };
        
        //标题
        var jqGridWidth = 0;
        var colModelLen = _options.colModel.length;
        var optionsModal = _options.colModel;
        _options.colNames = [];
        for (var i = 0; i < colModelLen; i++) {
            _options.colNames.push(optionsModal[i].header);
            if (optionsModal[i].sortable != true) {
                _options.colModel[i].sortable = false;
            }
            if (optionsModal[i].hidden != true) {
                jqGridWidth = jqGridWidth + optionsModal[i].width;
            }
            if (optionsModal[i].header.indexOf('金额') >= 0 || optionsModal[i].header.indexOf('差额') >= 0) {
                if (optionsModal[i].formatter == undefined) {
                    optionsModal[i].formatter = 'number';
                    optionsModal[i].formatoptions = {
                        decimalPlaces: parseInt(DHCPHA_CONSTANT.PLUGINS.SAFMT)
                    };
                }
            }
            /**if (((optionsModal[i].header.indexOf("单价")>=0))||(optionsModal[i].header.indexOf("进价")>=0)||((optionsModal[i].header.indexOf("售价")>=0))){
                if (optionsModal[i].formatter==undefined){
                    optionsModal[i].formatter='number';
                    optionsModal[i].formatoptions={decimalPlaces: 4};
                }
            }**/
            /**
             * @inputlimit,录入限制
             * number:true/false(是否数字),negative:true/false(允许负数)
             */
            var inputlimit = optionsModal[i].inputlimit;
            if (inputlimit) {
                var specialkeycode = [108, 8, 9, 13, 20, 27, 37, 38, 39, 40];
                if (inputlimit.number == true) {
                    var negainput = true;
                    if (inputlimit.negative == false) {
                        negainput = false;
                    }
                    $(this).on('keydown', function (event) {
                        if (event.keyCode == 229) {
                            /*
                            $(this).on("input propertychange",function(event){
                                var eTxt=$(event.target).val();
                                if (isNaN(eTxt)==true) {
                                    $(event.target).val("");
                                }
                            })
                            */
                            $(this).on('keyup', function (event) {
                                if (specialkeycode.indexOf(event.keyCode) >= 0) {
                                    return true;
                                }
                                if (negainput == false && event.keyCode == 189) {
                                    $(event.target).val('');
                                }
                                if (event.keyCode == 190 || event.keyCode == 110) {
                                    return true;
                                }
                                if ((event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105) && event.keyCode != 46) {
                                    $(event.target).val('');
                                }
                            });
                        } else {
                            if (specialkeycode.indexOf(event.keyCode) >= 0) {
                                return true;
                            }
                            if (negainput == false && event.keyCode == 189) {
                                return false;
                            }
                            if (event.keyCode == 190 || event.keyCode == 110) {
                                return true;
                            }
                            if ((event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105) && event.keyCode != 46) {
                                return false;
                            }
                        }
                    });
                }
            }
        }
        // 初始化后绑定才对
        var tblPanelWidth = $(this).closest('.panel').css('width');
        if (_options.phaShrinkToFit !== false) {
            if (parseInt(jqGridWidth) >= parseInt(tblPanelWidth) + 5) {
                _options.shrinkToFit = false;
            } else {
                _options.shrinkToFit = true;
            }
        } else {
            _options.shrinkToFit = false;
        }
        // 表头翻译
        for (var tI = 0; tI < _options.colNames.length; tI++) {
            var tmpHeader = _options.colNames[tI]
                if (tmpHeader.indexOf("<") < 0) {
                    _options.colNames[tI] = $g(tmpHeader)
                }
        }
        var opts = $.extend({}, options, _options);

        // jqgrid初始化
        var gId = this[0].id;
        if (typeof PHA_SYS_SET == 'object') {
            PHA_SYS_SET.Grid.InitJqGrid(gId, opts, function (_nOpts) {
                $('#' + gId).jqGrid(_nOpts);
            });
        } else {
            $('#' + gId).jqGrid(opts);
        }

        if (opts.pager != undefined) {
            $(this).jqGrid('navGrid', opts.pager, {
                edit: false,
                add: false,
                del: false,
                search: false
            });
            $('#jqGridPager_left').width(400);
        }
        // 覆盖样式
        $('#jqgh_' + this.attr('id') + '_cb').height(20);
        if (this.attr('id') != 'grid-wardlist') {
            if (_options.shrinkToFit == true) {
                $(this).closest('.ui-jqgrid-bdiv').css({
                    'overflow-x': 'hidden'
                });
            }
        }
        // 绑定上下键
        if (_options.KeyUpDown == true) {
            var _gridId = this[0].id;
            $(this).bind('keydown', function (e) {
                var keyCodeNum = e.keyCode;
                if (keyCodeNum == 38 || keyCodeNum == 40) {
                    var rows = $('#' + _gridId).jqGrid('getGridParam', 'records');
                    var row = $('#' + _gridId).jqGrid('getGridParam', 'selrow');
                    if (row) {
                        var index = '';
                        if (keyCodeNum == 38) {
                            index = parseInt(row) - 1;
                            if (index - 1 < 0) {
                                index = '';
                            }
                        } else {
                            index = parseInt(row) + 1;
                            if (index > rows) {
                                index = '';
                            }
                        }
                        if (index != '') {
                            $('#' + _gridId).jqGrid('setSelection', index, false);
                            $('#' + _gridId).jqGrid('setSelection', index);
                        }
                    }
                }
            });
        }
        // 列设置弹窗
        $('#' + gId).parent().parent().prev().on('dblclick', function (e) {
            e.stopPropagation();
            PHA_SYS_SET.Grid.OpenJqGrid(gId);
        });
    };
    // 清空jqgrid
    $.fn.clearJqGrid = function (_options) {
        var _thisid = '#' + this.attr('id');
        $(_thisid).jqGrid('clearGridData');
        var _params = {};
        var postparams = $(_thisid).getGridParam('postData');
        for (prop in postparams) {
            if (prop) {
                _params[prop] = '';
            }
        }
        $(_thisid).setGridParam({
            postData: _params
        }).trigger('reloadGrid');
    };
    //隐藏jqGrid滚动条
    $.fn.HideJqGridScroll = function (_options) {
        var _thisid = '#' + this.attr('id');
        if (_options.hideType == 'X') {
            $(_thisid).closest('.ui-jqgrid-bdiv').css({
                'overflow-x': 'hidden'
            });
        } else if (_options.hideType == 'Y') {
            $(_thisid).closest('.ui-jqgrid-bdiv').css({
                'overflow-y': 'hidden'
            });
        }
    };
    /* jqGrid end */

    /* image button change style start */
    $.fn.dhcphaImageBtn = function (_options) {
        var _btnimagesrc = DHCPHA_CONSTANT.URL.PATH + '/scripts/pharmacy/images/' + _options.image;
        $(this).mouseover(function () {
            $(this)
            .children()
            .attr('src', _btnimagesrc + '-hover.png');
            $(this).addClass('dhcpha-btn-img-color');
        });
        $(this).mouseout(function () {
            $(this)
            .children()
            .attr('src', _btnimagesrc + '-default.png');
        });
    };
    /* image button change style end */

    /* jqgrid infodialog start */
    $.extend($.jgrid, {
        info_dialog: function (caption, content, c_b, modalopt) {
            dhcphaMsgBox.message(content);
        }
    });
    $.fn.dhcphaJqGridValid = function () {
        $(this).on('keydown', function (event) {
            return false;
        });
    };
    /* jqgrid infodialog end */
});
/* bootbox start*/

/* ({})包裹函数,避免污染 */
var boxOptions = {
    title: $g('提示')
};
var msgOptions = {
    type: 'success',
    icon: 'fa fa-exclamation',
    message: $g('提示'),
    container: 'floating',
    timer: 5000
};
var dhcphaMsgBox = {
    alert: function (_message, _msgtype, _callback) {
        var msgtitle = '<i class="fa fa-info-circle"></i> '+$g('温馨提示');
        if (_msgtype == 'warn') {
            msgtitle = '<i class="fa fa-exclamation-triangle" aria-hidden="true"></i> '+$g('警告');
        } else if (_msgtype == 'error') {
            msgtitle = '<i class="fa fa-times-circle" aria-hidden="true"></i>　'+$g('错误提示');
        } else if (_msgtype == 'success') {
            msgtitle = '<i class="fa fa-check-circle-o" aria-hidden="true"></i>　'+$g('提示');
        }
        var options = {
            title: msgtitle,
            size: 'small',
            closeButton: false,
            buttons: {
                ok: {
                    label: $g('确认'),
                    className: 'dhcpha-btn-common dhcpha-btn-normal'
                }
            },
            callback: function () {
                if (_callback) {
                    _callback();
                }
            }
        };
        options.message = _message;
        bootbox.alert(options);
        var btnoktarget = $('.bootbox .btn');
        window.setTimeout(function () {
            btnoktarget.focus();
        }, 500);
    },
    confirm: function (_message, _callback) {
        var msgtitle = '<i class="fa fa-info-circle"></i> '+$g('操作提示');
        var options = {
            title: msgtitle,
            size: 'small',
            closeButton: false,
            buttons: {
                confirm: {
                    label: $g('确认'),
                    className: 'dhcpha-btn-common dhcpha-btn-normal'
                },
                cancel: {
                    label: $g('取消'),
                    className: 'dhcpha-btn-common dhcpha-btn-danger'
                }
            },
            callback: _callback
        };
        options.message = _message;
        bootbox.confirm(options);
        var btnoktarget = $('.bootbox .btn');
        window.setTimeout(function () {
            btnoktarget.focus();
        }, 500);
    },
    /**
     *此处引用此插件:scripts/pharmacy/plugins/toastmessage/js/jquery.toastmessage.js
     */
    message: function (_message, _msgoptions) {
        var options = {
            text: _message,
            sticky: false,
            stayTime: 3000,
            position: 'top-center',
            type: 'notice',
            closeText: '' //'<i class="fa fa-close"></i>'
        };
        var opts = $.extend({}, options, _msgoptions);
        $().toastmessage('showToast', opts);
    }
};
/* bootbox end */

/* 读卡 start */
var dhcphaReadCard = function (CardCallBack) {
    'use strict'; // 严格模式
    $.ajax({
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + '?action=GetCardType&style=',
        type: 'post',
        success: function (data) {
            if ('#modal-readcard') {
                $('#modal-readcard').remove();
            }
            var dhcphaReadCardHtml =
                '<div class="modal fade" id="modal-readcard" tabindex="-1" role="dialog" aria-hidden="false">' +
                '<div class="modal-dialog" style="width:400px">' +
                '<div class="modal-content" style="height:250px">' +
                ' <div class="modal-header modal_header_style">' +
                '  <button type="button" class="close" data-dismiss="modal" aria-label="Close" ><span style="color:#fff;" aria-hidden="true">&times;</span></button>' +
                ' <span class="modal-title" style="background-color:#556983;"><i class="fa fa-credit-card" aria-hidden="true"></i>　　读卡-选择卡类型</span>' +
                ' </div>' +
                '<div class="modal-body">' +
                '你好,此卡包含多种卡类型,请选择:' +
                '<div style="margin-left:50px;margin-top:40px;margin-bottom:40px">';
            var cardTypeData = eval('(' + data + ')');
            var cardTypeLen = cardTypeData.length;
            var cardTypeI = 0;
            var cardTypeRowId = '',
            cardTypeInfo = '',
            cardTypeObj = '';
            for (cardTypeI = 0; cardTypeI < cardTypeLen; cardTypeI++) {
                cardTypeObj = cardTypeData[cardTypeI];
                cardTypeRowId = cardTypeObj.RowId;
                cardTypeInfo = cardTypeObj.Desc;
                var cardTypeBtnCls = '';
                ('btn btn-primary  dhcpha-cardtype-icon-normal');
                var cardTypeIconCls = '';
                ('fa fa-credit-card dhcpha-cardtype-icon-common dhcpha-cardtype-icon-normal');
                var cardTypeArr = cardTypeRowId.split('^');
                var cardTypeDefault = cardTypeArr[8];
                if (cardTypeDefault == 'Y') {
                    cardTypeBtnCls = 'btn btn-danger  dhcpha-cardtype-button-common dhcpha-cardtype-button-primary';
                    cardTypeIconCls = 'fa fa-credit-card dhcpha-cardtype-icon-common dhcpha-cardtype-icon-primary';
                } else {
                    cardTypeBtnCls = 'btn btn-primary dhcpha-cardtype-button-common  dhcpha-cardtype-button-normal';
                    cardTypeIconCls = 'fa fa-credit-card dhcpha-cardtype-icon-common dhcpha-cardtype-icon-normal';
                }
                dhcphaReadCardHtml +=
                '<div class="btn-group ">' +
                ' <span class="' +
                cardTypeIconCls +
                '"></span>' +
                '  <button class="' +
                cardTypeBtnCls +
                '" type="button" value=' +
                cardTypeRowId +
                '>' +
                cardTypeInfo +
                '</button>' +
                '</div></br></br>';
                //拼串组合modal
            }
            dhcphaReadCardHtml += '</div>' + '</div>' + '</div>' + '</div>' + '</div>' + '</div>';
            // show啊
            $('body').append(dhcphaReadCardHtml);
            $('#modal-readcard').modal('show');
            $('#modal-readcard button').on('click', function () {
                var cardTypeValue = $(this).val();
                var cardTypeDesc = $(this).text();
                var cardTypeRowId = '';
                if (cardTypeDesc != 'x') {
                    if (cardTypeValue != '') {
                        var cardTypeArr = cardTypeValue.split('^');
                        cardTypeRowId = cardTypeArr[0];
                        //m_CardNoLength= cardTypeArr[17];
                    }
                    if (cardTypeValue != '') {
                        CardCallBack(cardTypeRowId, cardTypeDesc, cardTypeValue);
                    }
                }
                $('#modal-readcard').modal('hide');
            });
        }
    });
};
/* 读卡 end */

/* easyui Grid Start */
$.fn.dhcphaEasyUIGrid = function (_options) {
    var _loadingimge = DHCPHA_CONSTANT.URL.PATH + '/scripts/pharmacy/images/loading.png';
    var options = {
        fit: true,
        height: 'auto',
        border: false,
        singleSelect: true,
        rownumbers: false,
        pagination: true,
        nowrap: false,
        isTrans: true,
        pageSize: 100, // 每页显示的记录条数
        pageList: [100, 300, 500], // 可以设置每页记录条数的列表
        loadMsg: '<img  width=20px>数据正在加载中...',
        onRowContextMenu: function (e, rowIndex, rowData) {
            // 右键时触发事件
            if ($('#easyui-rightmenu').html() == undefined) {
                return;
            }
            var _grid_id = $(this).attr('id');
            e.preventDefault(); // 阻止浏览器捕获右键事件
            $(this).datagrid('clearSelections');
            $(this).datagrid('selectRow', rowIndex);
            $('#easyui-rightmenu #menu-export')
            .unbind()
            .bind('click', function () {
                ExportAllToExcel(_grid_id);
            });
            $('#easyui-rightmenu').menu('show', {
                left: e.pageX,
                top: e.pageY
            });
        },
        onLoadError: function (XMLHttpRequest) {
            var retJson = eval('(' + XMLHttpRequest.responseText + ')');
            if (retJson != '') {
                dhcphaMsgBox.alert($g('错误信息')+'</br>' + retJson.ERROR, 'error');
            } else {
                dhcphaMsgBox.alert($g('数据格式可能存在问题,请联系工程师!'), 'error');
            }
        },
        onLoadSuccess: function (data) {
            $(this)
            .datagrid('getPager')
            .pagination({
                layout: ['sep', 'first', 'prev', 'manual', 'next', 'last', 'sep', 'refresh', 'list']
                // layout:['sep', 'first', 'prev', 'links', 'next', 'last', 'sep', 'refresh', 'list']
            });
            $(this).datagrid('scrollTo', 0);
        }
    };
    var dataGridColumns = _options.columns[0];
    var dataGridColumnsLen = dataGridColumns.length;
    _options.colNames = [];
    for (var coli = 0; coli < dataGridColumnsLen; coli++) {
	    _options.colNames.push(dataGridColumns[coli].title);
        var tmpTitle = dataGridColumns[coli].title;
        var hideFlag = dataGridColumns[coli].hidden;
        if (tmpTitle.indexOf('药费') >= 0 || tmpTitle.indexOf('金额') >= 0) {
            _options.columns[0][coli].formatter = FormatDataGridAmount;
        }
        /**else if ((tmpTitle.indexOf("价格")>=0)||((tmpTitle.indexOf("进价")>=0)||(tmpTitle.indexOf("单价")>=0)||(tmpTitle.indexOf("售价")>=0))){
            _options.columns[0][coli].formatter=FormatDataGridPrice;
        }else if (tmpTitle.indexOf("数量")>=0){
            _options.columns[0][coli].formatter=FormatDataGridQty;
        }
        **/
    }
	// 表头翻译
    for (var tI = 0; tI < _options.colNames.length; tI++) {
        var tmpHeader = _options.colNames[tI]
        if (tmpHeader.indexOf("<") < 0 && tmpHeader !== '') {
            _options.colNames[tI] = $g(tmpHeader)
        }
    }
	
    // easyUIgrid初始化
    var opts = $.extend({}, options, _options);
    
    // 列设置
    var gId = this[0].id;
    if (typeof PHA_SYS_SET == 'object') {
        PHA_SYS_SET.Grid.Init(gId, opts, function (_nOpts) {
            $('#' + gId).datagrid(_nOpts);
        });
    } else {
        $('#' + gId).datagrid(opts);
    }

    if (_options.KeyUpDown == true) {
        EasyUIGridBindKeys($(this))
    }

    // 双击表头
    $(this).prev().children().eq(0).on('dblclick', function (e) {
        e.stopPropagation();
        PHA_SYS_SET.Grid.OpenJqGrid(gId);
    });
};

function FormatDataGridAmount(value, row, index) {
    if (value != '') {
        return parseFloat(value).toFixed(DHCPHA_CONSTANT.PLUGINS.SAFMT);
    } else {
        return value;
    }
}
function FormatDataGridPrice(value, row, index) {
    if (value != '') {
        return parseFloat(value).toFixed(4);
    } else {
        return value;
    }
}
function FormatDataGridQty(value, row, index) {
    if (value != '') {
        if (isNaN(value) == false) {
            if (parseFloat(value) > 0 && parseFloat(value) < 1) {
                var numlen = value.toString().split('.')[1].length;
                return parseFloat(value).toFixed(numlen);
            }
        }
    }
    return value;
}
//清空easyuigrid
$.fn.clearEasyUIGrid = function (_options) {
    var _thisid = '#' + this.attr('id');
    /*$(_thisid).datagrid({
        queryParams:{
            ClassName: "",
            QueryName: "",
            Params: ""
        }
    });*/
    $(_thisid).datagrid('loadData', {
        total: 0,
        rows: [],
        footer: []
    });
    // $(_thisid).datagrid('loadData', { total: 0, rows: [] });
    $(_thisid).datagrid('options').queryParams = {};
};
/* easyui Grid End */

/* easyui ComboBox Start */
$.fn.dhcphaEasyUICombo = function (_options) {
    var options = {
        width: 150,
        panelWidth: 150,
        valueField: 'RowId',
        textField: 'Desc',
        mode: 'remote',
        onHidePanel: function () {
            var valueField = $(this).combobox('options').valueField;
            var val = $(this).combobox('getValue');
            var allData = $(this).combobox('getData');
            var result = true;
            for (var i = 0; i < allData.length; i++) {
                if (val == allData[i][valueField]) {
                    result = false;
                    break;
                }
            }
            if (result) {
                $(this).combobox('clear');
            }
        }
        /*keyHandler: {
            query: function (keyword) { // 实时检索
                alert(1);
                $(this).combobox('reload');
            }
        }*/
    };
    var opts = $.extend({}, options, _options);
    $(this).combobox(opts);
};
/* easyui ComboBox End */

function EasyUIGridBindKeys(grid) {
    grid.datagrid('getPanel')
    .panel('panel')
    .attr('tabindex', 1)
    .bind('keydown', function (e) {
        switch (e.keyCode) {
        case 38: // up
            var rows = grid.datagrid('getRows');
            var selected = grid.datagrid('getSelected');
            if (selected) {
                var index = grid.datagrid('getRowIndex', selected);
                if (index - 1 < 0) {
                    break;
                }
                grid.datagrid('selectRow', index - 1);
            } else {
                var rows = grid.datagrid('getRows');
                grid.datagrid('selectRow', rows.length - 1);
            }
            break;
        case 40:
            var rows = grid.datagrid('getRows');
            var selected = grid.datagrid('getSelected');
            if (selected) {
                var index = grid.datagrid('getRowIndex', selected);
                if (index == rows.length - 1) {
                    break;
                }
                grid.datagrid('selectRow', index + 1);
            } else {
                grid.datagrid('selectRow', 0);
            }
            break;
        }
    });
}

// 药房下拉框
function InitPhaLoc() {
    var selectoption = {
        minimumResultsForSearch: Infinity,
        allowClear: false,
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCSTPharmacyCommon&MethodName=GetPhaLocByGrp&style=select2&grpdr=' + gGroupId,
        placeholder: '药房科室...'
    };
    $('#sel-phaloc').dhcphaSelect(selectoption);
    var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>';
    $('#sel-phaloc').append(select2option);
}

function InitPhaWard() {
    var daterangewidth = $('#date-daterange').outerWidth();
    if (daterangewidth == '' || daterangewidth == null) {
        daterangewidth = 180;
    }
    var selectoption = {
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCSTPharmacyCommon&MethodName=GetCtLocDs&style=select2&loctype=W',
        placeholder: '病区...',
        width: daterangewidth
    };
    $('#sel-phaward').dhcphaSelect(selectoption);
}

function InitPhaLocWard() {
    var daterangewidth = $('#date-daterange').outerWidth();
    if (daterangewidth == '' || daterangewidth == null) {
        daterangewidth = 180;
    }
    var selectoption = {
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCSTPharmacyCommon&MethodName=GetCtLocDs&style=select2&loctype=W$$E',
        placeholder: '病区...',
        width: daterangewidth
    };
    $('#sel-phaward').dhcphaSelect(selectoption);
}

function InitDecCond() {
    var selectoption = {
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCINPHA.MTCommon.CommonUtil&MethodName=GetDecConComb&style=select2',
        placeholder: '记录状态...'
    };
    $('#sel-deccond').dhcphaSelect(selectoption);
}

// add by psc 2018/08/06
// 用法下拉框
function InitPhcInstruc(PrescConfigId) {
    var selectoption = {
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCOUTPHA.Common.CommonUtil&MethodName=GetInstrJs&PrescConfigId=' + PrescConfigId + '&style=select2',
        placeholder: '用法...'
    };
    $('#sel-cmbPhcInstruc').dhcphaSelect(selectoption);
}

// 疗程下拉框
function InitPhcDuration() {
    var selectoption = {
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCOUTPHA.Common.CommonUtil&MethodName=GetPhcDurationjs&style=select2',
        placeholder: '疗程...'
    };
    $('#sel-cmbPhcDuration').dhcphaSelect(selectoption);
}

// 频次下拉框
function InitPHCFreq() {
    var selectoption = {
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCOUTPHA.Common.CommonUtil&MethodName=GetPHCFreqJs&style=select2',
        placeholder: '频次...'
    };
    $('#sel-cmbInitPHCFreq').dhcphaSelect(selectoption);
}

// 处方类型下拉框
function InitCategory() {
    var selectoption = {
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCOUTPHA.Common.CommonUtil&MethodName=GetPrescTypeJs&style=select2',
        placeholder: '处方类型...'
    };
    $('#sel-cmbCategory').dhcphaSelect(selectoption);
}

// 配制方法下拉框
function InitMakeMedthod(phcPrescType) {
    var selectoption = {
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCOUTPHA.Common.CommonUtil&MethodName=GetPrescConfigJs&PrescType=' + phcPrescType + '&style=select2',
        placeholder: '配制方法...'
    };
    $('#sel-cmbMakeMedthod').dhcphaSelect(selectoption);
}

// 用量下拉框
function InitPrescOrderQty(phcInstr) {
    var selectoption = {
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCOUTPHA.Common.CommonUtil&MethodName=GetPrescOrderQtyJs&Instr=' + phcInstr + '&style=select2',
        placeholder: '用量...'
    };
    $('#sel-cmbPrescOrderQty').dhcphaSelect(selectoption);
}

// 特殊煎法下拉框
function InitPhSpecInst(count) {
    var selectoption = {
        width: 100,
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCOUTPHA.Common.CommonUtil&MethodName=GetPhSpecInstJs&style=select2',
        placeholder: '煎法...'
    };
    for (var i = 0; i <= count; i++) {
        $('#sel-cmbBoil' + i).dhcphaSelect(selectoption);
    }
}

// 初始化某科室的所有登录用户
function InitLocAllUser(_options) {
    var selectoption = {
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCSTPharmacyCommon&MethodName=GetLocAllUserDs&style=select2&ctloc=' + _options.locid,
        placeholder: _options.placeholder,
        allowClear: true
    };
    if (_options.width != undefined) {
        selectoption.width = _options.width;
    }
    $(_options.id).dhcphaSelect(selectoption);
}

// 医院
var DHCSTEASYUI = {};
DHCSTEASYUI.GenHospComp = function (_options, sessionStr) {
    var tableName = tableName || '';
    var tableName = _options.tableName || '';
    if (tableName === '') {
        $.messager.alert('提示', '程序错误,未传授权表名或代码', 'error');
        return;
    }
    var hospAutFlag = tkMakeServerCall('PHA.FACE.IN.Com', 'GetHospAut');
    if (hospAutFlag === 'Y') {
        $($('body>.easyui-layout')[0]).layout('add', {
            region: 'north',
            border: false,
            height: 45,
            split: false,
            bodyCls: 'pha-ly-hosp',
            content:
            '<div>' +
            '   <div class="pha-row">' +
            '       <div class="pha-col">' +
            '           <label id="_HospListLabel" style="color:red;">' + $g("医院") + '</label>' +
            '           <input id="_HospList" class="textbox" />' +
            '       </div>' +
            '   </div>' +
            '</div>'
        });
        sessionStr = sessionStr || '';
        var hospid = (session && session['LOGON.HOSPID']) || '';
        if ($('#_HospList').length == 0) {
            $('<input id="_HospList" class="textbox"/>').prependTo('body');
        }
        if ($('#_HospListLabel').length == 0) {
            $("<label style='color:red;margin:0 10px 0 10px' class='r-label'>" + $g("医院") + "</label>").prependTo('body');
        }
        // ##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(tableName,hospid,"");
        var defHospId = $cm({
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: tableName,
            HospID: hospid
        }, false);
        var hospObj = $('#_HospList').combogrid({
            delay: 500,
            blurValidValue: true,
            panelWidth: 350,
            width: 350,
            mode: 'remote',
            editable: false,
            pagination: true,
            lazy: true,
            minQueryLen: 1,
            value: defHospId,
            isCombo: true,
            showPageList: false,
            showRefresh: false,
            displayMsg: '当前:{from}~{to},共{total}条',
            onBeforeLoad: function (param) {
                // param = $.extend(param,{desc:$("#_HospList").lookup("getText")});
                return true;
            },
            queryParams: {
                ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
                QueryName: 'GetHospDataForCombo',
                tablename: tableName,
                SessionStr: sessionStr
            },
            url: 'websys.Broker.cls',
            idField: 'HOSPRowId',
            textField: 'HOSPDesc',
            columns: [
                [{
                        field: 'HOSPRowId',
                        title: 'HOSPRowId',
                        align: 'left',
                        hidden: true,
                        width: 100
                    }, {
                        field: 'HOSPDesc',
                        title: '医院名称',
                        align: 'left',
                        width: 300
                    }
                ]
            ]
        });
        return hospObj;
    } else {
        return '';
    }
};

// 医院
DHCSTEASYUI.GenHospCompVal = function () {
    // session['LOGON.HOSPID']
    if ($('#_HospList').length == 0) {
        return '';
    }
    var HospCompText = $('#_HospList').combogrid('getText');
    if (HospCompText == '') {
        return '';
    }
    var HospCompValue = $('#_HospList').combogrid('getValue');
    return HospCompValue;
};

// jqgrid 国际化问题处理
(function($){
    var langCode = session['LOGON.LANGCODE'] || 'CH';
    if(langCode === 'CH'){
        if($.jgrid) {
            $.extend($.jgrid.defaults, {
                recordtext: '当前记录{0}--{1}条　共{2}条记录',
                pgtext: '<div style="height:auto">第{0} 共{1}页</div>',
                loadtext: '数据加载中...',
                emptyrecords: '没有数据'
            })
            $.extend($.jgrid.nav, {
                refreshtitle: '刷新表格'
            })
        }
    }

    if(langCode === 'EN'){
        if($.jgrid) {
            $.extend($.jgrid.defaults, {
                recordtext: 'Displaying {0} to {1} of {2} items ',
                pgtext: 'Page {0} of {1}',
                loadtext: 'Loading...',
                emptyrecords: 'No records to view'
            })
            $.extend($.jgrid.nav, {
                refreshtitle: 'Reload Grid'
            });
        }
        
    }     
        
}(jQuery));