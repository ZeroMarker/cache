/**
 * @creator:yunhaibao
 * @createdate:2016-08-06
 * @description:���η�װһЩ���
 * @others:select2,jqGrid,bootbox,bootstrap-combobox,daterangepicker
 * pharmacy/common/js/dhcpha.plugins.js
 */
 
$(function () {
    /* select2 start */
    /* https://www.select2.cn */
    $.fn.dhcphaSelect = function (_options, _ajaxOption) {
        // Ĭ������
        options = {
            // multiple:true,
            width: 150,
            language: 'zh-CN',
            // dropdownAutoWidth: true,
            // tags: "true",
            allowClear: true,
            placeholder: '��ѡ��'
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
        // ����ɾ�����ݺ�,��Ȼ��������ʾ������
        $(this).on('select2:close', function () {
            if (($(this).val() || '') == '') {
                $('#select2-' + this.id + '-container').attr('title', '');
            }
        });
        $(".select2-selection__rendered").hover(function(){
	    	$(this).removeAttr("title")
	    })
        // ��ʽ�޸�
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
                applyLabel: 'ȷ��',
                cancelLabel: 'ȡ��',
                format: DHCPHA_CONSTANT.PLUGINS.DATEFMT,
                separator: ' �� ',
                daysOfWeek: ['��', 'һ', '��', '��', '��', '��', '��'],
                monthNames: ['1��', '2��', '3��', '4��', '5��', '6��', '7��', '8��', '9��', '10��', '11��', '12��']
            }
            /*
            timePicker : true,
            timePickerIncrement:1,
            showDropdowns : false,
            showWeekNumbers : false, // �Ƿ���ʾ�ڼ���
            ranges : {  // �Զ����ݷ�Χ
                '����': [moment().startOf('day'), moment()],
                '����': [moment().subtract('days', 1).startOf('day'), moment().subtract('days', 1).endOf('day')],
                '���7��': [moment().subtract('days', 6), moment()],
                '���30��': [moment().subtract('days', 29), moment()]
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
        // �󶨵��
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
            gridview: true, //����Ϊtrue�����5~10������ʾ�ٶȡ���������ʹ��treeGrid, subGrid, ��afterInsertRow�¼�
            mtype: 'POST', //�ύ��ʽ
            datatype: 'json',
            autowidth: true, //����Ӧ���
            autoheight: true, //����Ӧ�߶�
            //rownumbers:true,//�������к�
            altRows: false, //����Ϊ�����б��,Ĭ��Ϊfalse
            //sortname:'createDate',
            //sortorder:'asc',
            viewrecords: true, //�Ƿ��������������ʾ��¼����
            rowNum: 100, //ÿҳ��ʾ��¼��
            rowList: [50, 100, 300, 500], //���ڸı���ʾ�����������б���Ԫ������
            rownumWidth: 35, // the width of the row numbers columns
            pagerpos: 'left',
            recordpos: 'right',
            //recordtext: '��ǰ��¼{0}--{1}������{2}����¼',
            //pgtext: '<div style="height:auto">��{0} ��{1}ҳ</div>',
            autoScroll: true,
            shrinkToFit: true,
            refresh: true,
            //loadtext: '���ݼ�����...',
            //emptyrecords: 'û������',
            sortable: false,
            multiselectWidth: '30px',
            //scrollOffset:'0px', //Ԥ����,���Ϊ0,��������ݺ����ʾ���������
            jsonReader: {
                rows: 'rows',
                records: 'total',
                total: 'pages',
                repeatitems: false,
                id: 'Id'
            },
            prmNames: {
                page: 'page', //��ʾ����ҳ��Ĳ�������
                rows: 'rows', //��ʾ���������Ĳ�������
                sort: 'sidx', //��ʾ��������������Ĳ�������
                order: 'sord', //��ʾ���õ�����ʽ�Ĳ�������
                search: '_search', //��ʾ�Ƿ�����������Ĳ�������
                nd: 'nd', //��ʾ�Ѿ���������Ĵ����Ĳ�������
                id: 'id', //��ʾ���ڱ༭����ģ���з�������ʱ��ʹ�õ�id������
                oper: 'oper', //operation�������ƣ�����ʱ��û�õ���
                editoper: 'edit', //����editģʽ���ύ����ʱ������������request.getParameter("oper") �õ�edit
                addoper: 'add', //����addģʽ���ύ����ʱ������������request.getParameter("oper") �õ�add
                deloper: 'del', //����deleteģʽ���ύ����ʱ������������request.getParameter("oper") �õ�del
                subgridid: 'id', //��������������ݵ��ӱ�ʱ�����ݵ���������
                npage: null,
                totalrows: 'totalrows' //��ʾ���Server�õ��ܹ����������ݵĲ������ƣ��μ�jqGridѡ���е�rowTotal
            },
            loadError: function (xhr, status, error) {
                alert(status + ' ���������� ' + $(this).attr('id') + ' : ' + error + '; ��Ӧ���: ' + xhr.status + ' ' + xhr.statusText);
            }
        };
        
        //����
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
            if (optionsModal[i].header.indexOf('���') >= 0 || optionsModal[i].header.indexOf('���') >= 0) {
                if (optionsModal[i].formatter == undefined) {
                    optionsModal[i].formatter = 'number';
                    optionsModal[i].formatoptions = {
                        decimalPlaces: parseInt(DHCPHA_CONSTANT.PLUGINS.SAFMT)
                    };
                }
            }
            /**if (((optionsModal[i].header.indexOf("����")>=0))||(optionsModal[i].header.indexOf("����")>=0)||((optionsModal[i].header.indexOf("�ۼ�")>=0))){
                if (optionsModal[i].formatter==undefined){
                    optionsModal[i].formatter='number';
                    optionsModal[i].formatoptions={decimalPlaces: 4};
                }
            }**/
            /**
             * @inputlimit,¼������
             * number:true/false(�Ƿ�����),negative:true/false(������)
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
        // ��ʼ����󶨲Ŷ�
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
        // ��ͷ����
        for (var tI = 0; tI < _options.colNames.length; tI++) {
            var tmpHeader = _options.colNames[tI]
                if (tmpHeader.indexOf("<") < 0) {
                    _options.colNames[tI] = $g(tmpHeader)
                }
        }
        var opts = $.extend({}, options, _options);

        // jqgrid��ʼ��
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
        // ������ʽ
        $('#jqgh_' + this.attr('id') + '_cb').height(20);
        if (this.attr('id') != 'grid-wardlist') {
            if (_options.shrinkToFit == true) {
                $(this).closest('.ui-jqgrid-bdiv').css({
                    'overflow-x': 'hidden'
                });
            }
        }
        // �����¼�
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
        // �����õ���
        $('#' + gId).parent().parent().prev().on('dblclick', function (e) {
            e.stopPropagation();
            PHA_SYS_SET.Grid.OpenJqGrid(gId);
        });
    };
    // ���jqgrid
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
    //����jqGrid������
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

/* ({})��������,������Ⱦ */
var boxOptions = {
    title: $g('��ʾ')
};
var msgOptions = {
    type: 'success',
    icon: 'fa fa-exclamation',
    message: $g('��ʾ'),
    container: 'floating',
    timer: 5000
};
var dhcphaMsgBox = {
    alert: function (_message, _msgtype, _callback) {
        var msgtitle = '<i class="fa fa-info-circle"></i> '+$g('��ܰ��ʾ');
        if (_msgtype == 'warn') {
            msgtitle = '<i class="fa fa-exclamation-triangle" aria-hidden="true"></i> '+$g('����');
        } else if (_msgtype == 'error') {
            msgtitle = '<i class="fa fa-times-circle" aria-hidden="true"></i>��'+$g('������ʾ');
        } else if (_msgtype == 'success') {
            msgtitle = '<i class="fa fa-check-circle-o" aria-hidden="true"></i>��'+$g('��ʾ');
        }
        var options = {
            title: msgtitle,
            size: 'small',
            closeButton: false,
            buttons: {
                ok: {
                    label: $g('ȷ��'),
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
        var msgtitle = '<i class="fa fa-info-circle"></i> '+$g('������ʾ');
        var options = {
            title: msgtitle,
            size: 'small',
            closeButton: false,
            buttons: {
                confirm: {
                    label: $g('ȷ��'),
                    className: 'dhcpha-btn-common dhcpha-btn-normal'
                },
                cancel: {
                    label: $g('ȡ��'),
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
     *�˴����ô˲��:scripts/pharmacy/plugins/toastmessage/js/jquery.toastmessage.js
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

/* ���� start */
var dhcphaReadCard = function (CardCallBack) {
    'use strict'; // �ϸ�ģʽ
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
                ' <span class="modal-title" style="background-color:#556983;"><i class="fa fa-credit-card" aria-hidden="true"></i>��������-ѡ������</span>' +
                ' </div>' +
                '<div class="modal-body">' +
                '���,�˿��������ֿ�����,��ѡ��:' +
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
                //ƴ�����modal
            }
            dhcphaReadCardHtml += '</div>' + '</div>' + '</div>' + '</div>' + '</div>' + '</div>';
            // show��
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
/* ���� end */

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
        pageSize: 100, // ÿҳ��ʾ�ļ�¼����
        pageList: [100, 300, 500], // ��������ÿҳ��¼�������б�
        loadMsg: '<img  width=20px>�������ڼ�����...',
        onRowContextMenu: function (e, rowIndex, rowData) {
            // �Ҽ�ʱ�����¼�
            if ($('#easyui-rightmenu').html() == undefined) {
                return;
            }
            var _grid_id = $(this).attr('id');
            e.preventDefault(); // ��ֹ����������Ҽ��¼�
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
                dhcphaMsgBox.alert($g('������Ϣ')+'</br>' + retJson.ERROR, 'error');
            } else {
                dhcphaMsgBox.alert($g('���ݸ�ʽ���ܴ�������,����ϵ����ʦ!'), 'error');
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
        if (tmpTitle.indexOf('ҩ��') >= 0 || tmpTitle.indexOf('���') >= 0) {
            _options.columns[0][coli].formatter = FormatDataGridAmount;
        }
        /**else if ((tmpTitle.indexOf("�۸�")>=0)||((tmpTitle.indexOf("����")>=0)||(tmpTitle.indexOf("����")>=0)||(tmpTitle.indexOf("�ۼ�")>=0))){
            _options.columns[0][coli].formatter=FormatDataGridPrice;
        }else if (tmpTitle.indexOf("����")>=0){
            _options.columns[0][coli].formatter=FormatDataGridQty;
        }
        **/
    }
	// ��ͷ����
    for (var tI = 0; tI < _options.colNames.length; tI++) {
        var tmpHeader = _options.colNames[tI]
        if (tmpHeader.indexOf("<") < 0 && tmpHeader !== '') {
            _options.colNames[tI] = $g(tmpHeader)
        }
    }
	
    // easyUIgrid��ʼ��
    var opts = $.extend({}, options, _options);
    
    // ������
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

    // ˫����ͷ
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
//���easyuigrid
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
            query: function (keyword) { // ʵʱ����
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

// ҩ��������
function InitPhaLoc() {
    var selectoption = {
        minimumResultsForSearch: Infinity,
        allowClear: false,
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCSTPharmacyCommon&MethodName=GetPhaLocByGrp&style=select2&grpdr=' + gGroupId,
        placeholder: 'ҩ������...'
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
        placeholder: '����...',
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
        placeholder: '����...',
        width: daterangewidth
    };
    $('#sel-phaward').dhcphaSelect(selectoption);
}

function InitDecCond() {
    var selectoption = {
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCINPHA.MTCommon.CommonUtil&MethodName=GetDecConComb&style=select2',
        placeholder: '��¼״̬...'
    };
    $('#sel-deccond').dhcphaSelect(selectoption);
}

// add by psc 2018/08/06
// �÷�������
function InitPhcInstruc(PrescConfigId) {
    var selectoption = {
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCOUTPHA.Common.CommonUtil&MethodName=GetInstrJs&PrescConfigId=' + PrescConfigId + '&style=select2',
        placeholder: '�÷�...'
    };
    $('#sel-cmbPhcInstruc').dhcphaSelect(selectoption);
}

// �Ƴ�������
function InitPhcDuration() {
    var selectoption = {
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCOUTPHA.Common.CommonUtil&MethodName=GetPhcDurationjs&style=select2',
        placeholder: '�Ƴ�...'
    };
    $('#sel-cmbPhcDuration').dhcphaSelect(selectoption);
}

// Ƶ��������
function InitPHCFreq() {
    var selectoption = {
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCOUTPHA.Common.CommonUtil&MethodName=GetPHCFreqJs&style=select2',
        placeholder: 'Ƶ��...'
    };
    $('#sel-cmbInitPHCFreq').dhcphaSelect(selectoption);
}

// ��������������
function InitCategory() {
    var selectoption = {
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCOUTPHA.Common.CommonUtil&MethodName=GetPrescTypeJs&style=select2',
        placeholder: '��������...'
    };
    $('#sel-cmbCategory').dhcphaSelect(selectoption);
}

// ���Ʒ���������
function InitMakeMedthod(phcPrescType) {
    var selectoption = {
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCOUTPHA.Common.CommonUtil&MethodName=GetPrescConfigJs&PrescType=' + phcPrescType + '&style=select2',
        placeholder: '���Ʒ���...'
    };
    $('#sel-cmbMakeMedthod').dhcphaSelect(selectoption);
}

// ����������
function InitPrescOrderQty(phcInstr) {
    var selectoption = {
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCOUTPHA.Common.CommonUtil&MethodName=GetPrescOrderQtyJs&Instr=' + phcInstr + '&style=select2',
        placeholder: '����...'
    };
    $('#sel-cmbPrescOrderQty').dhcphaSelect(selectoption);
}

// ����巨������
function InitPhSpecInst(count) {
    var selectoption = {
        width: 100,
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCOUTPHA.Common.CommonUtil&MethodName=GetPhSpecInstJs&style=select2',
        placeholder: '�巨...'
    };
    for (var i = 0; i <= count; i++) {
        $('#sel-cmbBoil' + i).dhcphaSelect(selectoption);
    }
}

// ��ʼ��ĳ���ҵ����е�¼�û�
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

// ҽԺ
var DHCSTEASYUI = {};
DHCSTEASYUI.GenHospComp = function (_options, sessionStr) {
    var tableName = tableName || '';
    var tableName = _options.tableName || '';
    if (tableName === '') {
        $.messager.alert('��ʾ', '�������,δ����Ȩ���������', 'error');
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
            '           <label id="_HospListLabel" style="color:red;">' + $g("ҽԺ") + '</label>' +
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
            $("<label style='color:red;margin:0 10px 0 10px' class='r-label'>" + $g("ҽԺ") + "</label>").prependTo('body');
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
            displayMsg: '��ǰ:{from}~{to},��{total}��',
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
                        title: 'ҽԺ����',
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

// ҽԺ
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

// jqgrid ���ʻ����⴦��
(function($){
    var langCode = session['LOGON.LANGCODE'] || 'CH';
    if(langCode === 'CH'){
        if($.jgrid) {
            $.extend($.jgrid.defaults, {
                recordtext: '��ǰ��¼{0}--{1}������{2}����¼',
                pgtext: '<div style="height:auto">��{0} ��{1}ҳ</div>',
                loadtext: '���ݼ�����...',
                emptyrecords: 'û������'
            })
            $.extend($.jgrid.nav, {
                refreshtitle: 'ˢ�±��'
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