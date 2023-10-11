/**
 * ����:	 Ftp�ϴ�Ԥ��ɾ���ļ�
 * ��д��:	 yunhaibao
 * ��д����: 2019-11-19
 * ������	 http://fex.baidu.com/webuploader/
 * 			<link rel="stylesheet" type="text/css" href="../scripts/pha/plugins/webuploader/dist/webuploader.css" />
 * 			 <script type="text/javascript" src="../scripts/pha/plugins/webuploader/dist/webuploader.js"></script>
 */
var PHA_UPLOAD = {
    WinId: 'PHA_UPLOAD_Window',
    BtnAdd: 'PHA_UPLOAD_BtnAdd',
    BtnUpLoad: 'PHA_UPLOAD_BtnLoad',
    BtnRemove: 'PHA_UPLOAD_BtnRemove',
    BtnKeyWord: 'PHA_UPLOAD_BtnKeyWord',
    Viewer: 'PHA_UPLOAD_Viewer',
    HttpSrc: '',
    // dataOpts
    // 			callBack �ϴ��ɹ���ص�
    // 			id		 ��Ӧ�����ݵ�Id
    /**
	 * 
	 * @param {*} dataOpts �������ݵĲ���
	 * 				callBack 		�ϴ��ɹ���ص�
	 * 				callBackKeyWord ����ؼ��ֵĻص�
	 * 				callBackDelete	ɾ���ص�
	 * 				id		 		��Ӧ�����ݵ�Id(������,��Ϊ�����Id)
	 * 				type 			�ļ�����(D:˵����,P:ͼƬ...)
	 * 				keyWord 		Ĭ�ϵĹؼ���,ѡ���ļ���,Ĭ��

	 * @param {*} winOpts window����
	 */
    Upload: function (dataOpts, winOpts) {
        if ((dataOpts.type || '') == '') {
            PHA.Popover({
                msg: 'type��ѡ����',
                type: 'alert'
            });
            return;
        }
        $('body').append(this.UploadHtml());
        var defWinOpts = {
            title: '�ļ��ϴ�',
            collapsible: false,
            iconCls: 'icon-w-file',
            border: false,
            closed: true,
            modal: true,
            minimizable: false,
            width: 800,
            height: 500,
            onBeforeClose: function () {
                $('#' + PHA_UPLOAD.WinId + ' [src]').attr('src', '');
                $('#' + PHA_UPLOAD.WinId).window('destroy');
            }
        };
        if (winOpts) {
            $.extend(defWinOpts, winOpts);
        }
        $('#' + this.WinId)
            .window(defWinOpts)
            .window('open');
        $.parser.parse($('#' + this.WinId));
        var $ul = $('#' + this.Viewer);
        var thumbnailWidth = 1; //����ͼ�߶ȺͿ�� ����λ�����أ�������߶���0~1��ʱ���ǰ��հٷֱȼ��㣬������Կ�api�ĵ�
        var thumbnailHeight = 1;
        // ��ʼ��uploader
        PHA_UPLOAD_Loader = WebUploader.create({
            // ѡ���ļ����Ƿ��Զ��ϴ���
            auto: false,
            // ����ȫ�ֵ���ק���ܡ������������ͼƬ�Ͻ�ҳ���ʱ�򣬰�ͼƬ�򿪡�
            disableGlobalDnd: true,
            // swf�ļ�·��
            swf: '../scripts/pha/plugins/webuploader/dist/Uploader.swf',
            // �ļ����շ����
            server: 'pha.com.v1.upload.csp',
            // ѡ���ļ��İ�ť����ѡ��
            // �ڲ����ݵ�ǰ�����Ǵ�����������inputԪ�أ�Ҳ������flash.
            pick: {
                id: '#PHA_UPLOAD_BtnAdd',
                innerHTML: '<a id="PHA_UPLOAD_BtnAdd_Dis" class="hisui-linkbutton" data-options="iconCls:\'icon-w-file\'" style="margin-left: -15px;">ѡ��</a>',
                multiple: true // ��ֹ��ѡ�ļ�
            },
            // ֻ����ѡ��ͼƬ�ļ���

            accept: {
                title: 'Files',
                extensions: 'jpg,jpeg,png,pdf',
                mimeTypes: 'image/jpg,image/jpeg,image/png,application/pdf'
            },
            method: 'POST'
        });
        $('#PHA_UPLOAD_BtnAdd_Dis').linkbutton();

        // �����ļ���ӽ�����ʱ��
        PHA_UPLOAD_Loader.on('fileQueued', function (file) {
            var liHtml = PHA_UPLOAD.LIHtml(file.id);
            $ul.append(liHtml);
            $.parser.parse($('#' + file.id));
            $('#' + file.id + " [name='PHA_UPLOAD_KeyWord']").val(dataOpts.keyWord || '');
            $('#' + file.id + ' .pha-uploader-body-header').text(file.name);
            $('#' + file.id + ' .hisui-progressbar').hide();
            $('#' + file.id + " [name='btnDelFile']").on('click', function (e) {
                $(e.target).closest('li').remove();
                PHA_UPLOAD_Loader.removeFile(file);
                PHA_UPLOAD_Loader.refresh();
            });
            PHA_UPLOAD_Loader.makeThumb(
                file,
                function (error, src) {
                    if (error) {
                        // ����Ԥ��
                        var unimgHtml = '<div>��ͼƬ֧��Ԥ��</div>';
                        $('#' + file.id)
                            .find('.pha-uploader-body-img')
                            .removeClass('pha-uploader-body-img')
                            .addClass('pha-uploader-body-unimg')
                            .append(unimgHtml);
                        return;
                    } else {
                        // ��Ԥ��
                        var imgHtml = '<img src=' + src + '>';
                        $('#' + file.id)
                            .find('.pha-uploader-body-img')
                            .append(imgHtml);
                    }
                },
                thumbnailWidth,
                thumbnailHeight
            );
            // ÿ��refresh,�����ٵ���ϴ�û��Ӧ
            PHA_UPLOAD_Loader.refresh();
            $('#' + PHA_UPLOAD.BtnUpLoad).linkbutton('enable', true);
        });

        // �ϴ�����
        $('#' + PHA_UPLOAD.BtnUpLoad).on('click', function () {
            if ($('#' + PHA_UPLOAD.BtnUpLoad).linkbutton('options').disabled == true) {
                return;
            }
            if ($("#PHA_UPLOAD_Viewer li[id^='WU_FILE']").length == 0) {
                PHA.Popover({
                    msg: 'û����Ҫ�ϴ�������',
                    type: 'alert'
                });
                return;
            }
            var $KeyWord = $('[name=PHA_UPLOAD_KeyWord]');
            var keyWordLen = $KeyWord.length;
            for (var keyI = 0; keyI < keyWordLen; keyI++) {
                if ($($KeyWord[keyI]).val() == '') {
                    PHA.Popover({
                        msg: '��������ؼ���',
                        type: 'alert'
                    });
                    return;
                }
            }

            $('#' + PHA_UPLOAD.BtnUpLoad).linkbutton('disable', true);
            PHA_UPLOAD_Loader.options.formData = {
                sessionLocId: session['LOGON.CTLOCID'],
                uploadType: 'Ftp'
            };
            PHA_UPLOAD_Loader.upload();
        });

        // �ļ��ϴ������д���������ʵʱ��ʾ��
        PHA_UPLOAD_Loader.on('uploadProgress', function (file, percentage) {
            $('#' + file.id + ' .pha-uploader-tool').hide();
            $proBar = $('#' + file.id + ' .hisui-progressbar');
            if ($proBar.css('display') == 'none') {
                $proBar.show();
            }
            $proBar.progressbar('setValue', parseInt(percentage * 100));
        });
        PHA_UPLOAD_Loader.on('uploadSuccess', function (file, ret) {
            var keyWord = $('#' + file.id + ' [name=PHA_UPLOAD_KeyWord]').val() || '';
            var retRaw = ret._raw.trim();
            var retRawArr = retRaw.split('^');
            if (retRaw[0] == 0) {
                var name = retRawArr[1];
                var fileName = file.name;
                var saveRet = dataOpts.callBack(dataOpts.id, name, dataOpts.type, keyWord, fileName);
                // ����һ������
                var data = {
                    id: saveRet,
                    name: retRawArr[1],
                    keyWord: keyWord,
                    fileName: fileName
                };
                PHA_UPLOAD.RefreshSingle(file.id, data, dataOpts);
                PHA.Popover({
                    msg: '�ϴ��ɹ�',
                    type: 'success'
                });
            } else {
                PHA.Alert('������ʾ', retRawArr[1], 'error');
                return;
            }
        });
        PHA_UPLOAD_Loader.on('uploadError', function (file) {
            PHA.Popover({
                msg: '�ϴ�ʧ��',
                type: 'error'
            });
        });
        // ���ļ��ϴ����
        PHA_UPLOAD_Loader.on('uploadComplete', function (file) {
            var $li = $('#' + file.id);
            $li.find('.pha-uploader-tool').show();
            $li.find('.hisui-progressbar').hide();
        });
        // ȫ���ϴ��ɹ�,��ˢ�½���
        PHA_UPLOAD_Loader.on('uploadFinished', function () {
            //			PHA.Popover({
            //				msg: '�ϴ��ɹ�',
            //				type: 'success'
            //			});
        });

        if (dataOpts.callBackKeyWord) {
            $('#PHA_UPLOAD_BtnKeyWord').on('click', function () {
                var $li_PHA = $("#PHA_UPLOAD_Viewer li[id^='PHA']");
                var keyWordStr = '';
                var popFlag = '1';
                $li_PHA.each(function (i) {
                    var id = this.id;
                    var keyWord = $(this).find('[name=PHA_UPLOAD_KeyWord]').val();
                    if (keyWord == '') {
                        PHA.Popover({
                            msg: '�ؼ��ֲ���Ϊ��',
                            type: 'alert'
                        });
                        keyWordStr = '';
                        popFlag = '';
                        return false;
                    }
                    id = id.split('_')[1];
                    var keyData = id + '^' + keyWord;
                    keyWordStr = keyWordStr == '' ? keyData : keyWordStr + '$$' + keyData;
                });
                if (keyWordStr == '') {
                    if (popFlag != '') {
                        PHA.Popover({
                            msg: 'û�пɱ���Ĺؼ���',
                            type: 'alert'
                        });
                    }
                    return;
                }
                dataOpts.callBackKeyWord(keyWordStr);
            });
        } else {
            $('#PHA_UPLOAD_BtnKeyWord').hide();
        }
        // �������ϴ�����
        PHA_UPLOAD.Refresh(dataOpts);
    },
    DownLoad: function () {},
    // dataOpts
    // 			data 	 �ļ��б�
    Preview: function (dataOpts, winOpts) {
        // ����Ԥ��
        $('body').append(this.PreviewHtml());
        var defWinOpts = {
            title: '�ļ�Ԥ��',
            collapsible: false,
            iconCls: 'icon-w-eye',
            border: false,
            closed: true,
            modal: true,
            minimizable: false,
            width: 800,
            height: 500,
            onBeforeClose: function () {
                $('#' + PHA_UPLOAD.WinId + ' [src]').attr('src', '');
                $('#' + PHA_UPLOAD.WinId).window('destroy');
            }
        };
        if (winOpts) {
            $.extend(defWinOpts, winOpts);
        }
        $('#' + this.WinId)
            .dialog(defWinOpts)
            .window('open'); // diag����window
        $.parser.parse($('#' + this.WinId));
        var dataGridOption = {
            pagination: false,
            toolbar: null,
            fitColumns: true,
            columns: [
                [
                    {
                        field: 'keyWord',
                        title: '�ؼ���',
                        width: 150,
                        formatter: function (value, row, index) {
                            var imgHtml = '';
                            var fileType = row.type;
                            if (fileType == 'P') {
                                imgHtml = '<img src="../scripts_lib/hisui-0.1.0/dist/css/icons/img.png"';
                            } else if (fileType == 'D') {
                                imgHtml = '<img src="../scripts_lib/hisui-0.1.0/dist/css/icons/book_green.png"';
                            } else {
                                imgHtml = '<img src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper_info.png"';
                            }
                            if (imgHtml != '') {
                                imgHtml += ' style="position: relative;top: 2px;"/>';
                            }
                            return imgHtml + '<span style="padding-left:10px">' + value + '</span>';
                        }
                    },
                    {
                        field: 'name',
                        title: 'ϵͳ�ļ���',
                        hidden: true,
                        width: 150
                    },
                    {
                        field: 'type',
                        title: '�ļ�������',
                        hidden: true,
                        width: 150
                    },
                    {
                        field: 'id',
                        title: '�ļ�Id',
                        hidden: true,
                        width: 150
                    }
                ]
            ],
            data: dataOpts.data,
            exportXls: false,
            onClickRow: function (index, rowData) {
                var name = rowData.name;
                var httpSrc = PHA_UPLOAD.GetHttpFile(name);
                var showHtml = '';
                $('#PHA_UPLOAD_Viewer *').hide();
                var $fileSrc = $('#PHA_UPLOAD_Viewer ' + "[src='" + httpSrc + "']");
                if ($fileSrc.length > 0) {
                    $fileSrc.show();
                } else {
                    if (PHA_UPLOAD.CanView(name) == false) {
                        var frameHeight = $('#' + PHA_UPLOAD.WinId).height() - 25;
                        showHtml = '<iframe src=' + httpSrc + ' style="width:100%;display:block;height:' + frameHeight + 'px;" frameboder="0"/>';
                        $('#PHA_UPLOAD_CENTER').css('overflow', 'hidden');
                    } else {
                        showHtml = '<image src=' + httpSrc + '/>';
                    }
                    $('#PHA_UPLOAD_Viewer').append(showHtml);
                }
            },
            onLoadSuccess: function (data) {}
        };

        PHA.Grid('PHA_UPLOAD_Tbl', dataGridOption);
        $('#' + this.WinId + ' .datagrid-header').css('display', 'none');
        // �����¼�
        $('#PHA_UPLOAD_OpenWin').on('click', function (e) {
            var $src = $('#PHA_UPLOAD_Viewer ' + '[src]:visible');
            if ($src.length == 0) {
                PHA.Popover({
                    msg: 'û���ļ���Ҫ���´��ڴ�',
                    type: 'alert'
                });
                return;
            }
            var src = $src[0].src;
            PHA_UPLOAD.OpenWin(src);
        });

        // $("#PHA_UPLOAD_Delete").on("click", function (e) {
        // 	var $grid = $("#PHA_UPLOAD_Tbl");
        // 	var gridSelect = $grid.datagrid("getSelected");
        // 	var name = gridSelect.name;
        // 	var delRet = PHA_UPLOAD.Delete(name);
        // 	var delRetArr = delRet.split("^");
        // 	if (delRetArr[0] < 0) {
        // 		PHA.Popover({
        // 			msg: delRetArr[1],
        // 			type: 'alert'
        // 		});
        // 		return
        // 	}
        // 	var $src = $("#PHA_UPLOAD_Viewer " + "[src]:visible");
        // 	$src.remove();
        // 	var rowIndex = $grid.datagrid("getRows").indexOf(gridSelect);
        // 	$grid.datagrid("deleteRow", rowIndex);
        // 	dataOpts.callback(gridSelect.id)
        // })
    },

    /**
     *
     * @param {String} _fileName ���ش��ļ�����ַ
     */
    GetHttpFile: function (_name) {
        if (PHA_UPLOAD.HttpSrc == '') {
            var httpSrc = $.cm(
                {
                    ClassName: 'PHA.COM.Upload',
                    MethodName: 'GetFtpHttpSrc',
                    LocId: session['LOGON.CTLOCID'],
                    dataType: 'text'
                },
                false
            );
            var httpSrcArr = httpSrc.split('^');
            if (httpSrcArr[0] < 0) {
                PHA.Popover({
                    msg: httpSrcArr[1],
                    type: 'alert'
                });
                return '';
            } else {
                PHA_UPLOAD.HttpSrc = httpSrcArr[1];
            }
        }
        var httpHref = window.location.href;
        var httpPre = 'http://';
        if (httpHref.indexOf('https') >= 0) {
            httpPre = 'https://';
        }
        var httpSrc = httpPre + PHA_UPLOAD.HttpSrc + _name;
        return httpSrc;
    },
    /**
     *
     * @param {Object} _dataOpts �ϴ��򴰿ڴ�ʱ,��������,�������ݼ�ΪUpload._dataOpts
     * 						callBackDelete ɾ���ص�
     */
    Refresh: function (_dataOpts) {
        var jsonData = _dataOpts.data;
        var rowsData = jsonData.rows;
        var rowsLen = rowsData.length;
        if (rowsLen == 0) {
            return;
        }
        var $ul = $('#' + this.Viewer);
        $ul.find('li').remove();
        for (var i = 0; i < rowsLen; i++) {
            var rowData = rowsData[i];
            PHA_UPLOAD.RefreshSingle('', rowData, _dataOpts);
        }
    },
    /**
     *
     * @param {String} _liId ��Ϊ���滻,Ϊ��append
     * @param {Array} _data  ����
     */
    RefreshSingle: function (_liId, _data, _dataOpts) {
        var $ul = $('#' + this.Viewer);
        var id = _data.id;
        var name = _data.name;
        var keyWord = _data.keyWord || '';
        var fileName = _data.fileName || '';
        var name = _data.name || '';
        var fileId = 'PHA_' + id;
        var liHtml = PHA_UPLOAD.LIHtml(fileId);
        if (_liId != '') {
            $('li[id=' + _liId + '] [src]').attr('src', '');
            $('li[id=' + _liId + ']').replaceWith(liHtml);
        } else {
            $ul.append(liHtml);
        }

        $.parser.parse($('#' + fileId));
        $('#' + fileId + " [name='PHA_UPLOAD_KeyWord']").val(keyWord || '');
        $('#' + fileId + ' .pha-uploader-body-header').text(fileName);
        $('#' + fileId + ' .pha-uploader-body-realfile').text(name);
        $('#' + fileId + ' .hisui-progressbar').hide();
        $('#' + fileId + " [name='btnDelFile']").on('click', function (e) {
            if (!_dataOpts.callBackDelete) {
                PHA.Popover({
                    msg: '�޷�ɾ��,δ����ɾ������',
                    type: 'alert'
                });
                return;
            }
            PHA.Confirm('��ʾ', '��ȷ��ɾ����?', function () {
                $e_li = $(e.target).closest('li');
                // �ļ���
                var name = $e_li.find('.pha-uploader-body-realfile').text() || '';
                if (name == '') {
                    PHA.Popover({
                        msg: 'ɾ��ʧ��,��ˢ�½��������',
                        type: 'alert'
                    });
                    return;
                }
                if (_dataOpts.callBackDelete(id) == true) {
                    PHA_UPLOAD.Delete(name);
                    PHA.Popover({
                        msg: 'ɾ���ɹ�',
                        type: 'success'
                    });
                    // ɾ����
                    $e_li.remove();
                    PHA_UPLOAD_Loader.refresh();
                }
            });
        });
        if (PHA_UPLOAD.CanView(name) == true) {
            var src = PHA_UPLOAD.GetHttpFile(name);
            var imgHtml = '<img src=' + src + '>';
            $('#' + fileId)
                .find('.pha-uploader-body-img')
                .append(imgHtml);
        } else {
            var unimgHtml = '<div>��ͼƬ֧��Ԥ��</div>';
            $('#' + fileId)
                .find('.pha-uploader-body-img')
                .removeClass('pha-uploader-body-img')
                .addClass('pha-uploader-body-unimg')
                .append(unimgHtml);
        }
        var loadedHtml = "<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/big/paper.png' style='position: relative;top: -142px;left: 0px;'/>";
        $('#' + fileId + ' .pha-uploader-body').append(loadedHtml);
    },
    // ���´����д�
    // todo���Ӳ���,���ļ�����ֱ�Ӵ�
    OpenWin: function (_httpSrc) {
        window.open(encodeURI(_httpSrc), '_blank', 'resizable=yes,scrollbars=yes,titlebar=no,' + 'width=' + $(window).width() * 0.9 + ',height=' + $(window).height() * 0.9);
    },
    Delete: function (_fileName) {
        if (_fileName == '') {
            return '';
        }
        var delRet = $.cm(
            {
                ClassName: 'PHA.COM.Upload',
                MethodName: 'FtpDelete',
                SessioLocId: session['LOGON.CTLOCID'],
                FileName: _fileName,
                dataType: 'text'
            },
            false
        );
        return delRet;
    },
    /**
     * �ж��Ƿ��Ԥ��
     * @param {String} _name �ļ���ȫ��
     * @return
     * 			true  ��Ԥ��
     */
    CanView: function (_name) {
        if (_name == '') {
            return false;
        }
        // ��Ԥ��
        var typeArr = ['jpg', 'bmp', 'png', 'jpeg'];
        var fileSuff = _name.split('.')[_name.split('.').length - 1];
        if (typeArr.indexOf(fileSuff) >= 0) {
            return true;
        }
        return false;
    },
    UploadHtml: function () {
        var winHtml =
            '' +
            '<div id="' +
            this.WinId +
            '" class="hisui-dialog" data-options="modal:true,iconCls:\'icon-w-plus\'" title="�ļ��ϴ�">' +
            '	<div class="hisui-layout" data-options="fit:true">' +
            '		<div data-options="region:\'north\',border:false,height:60" style="overflow:hidden;">' +
            '			<div class="pha-row">' +
            '				<div class="pha-col">' +
            '					<div style="line-height:30px">' +
            // '						<img src="../scripts_lib/hisui-0.1.0/dist/css/icons/white/file.png" style="background:red"/>'+
            '						<div id="PHA_UPLOAD_BtnAdd"></div>' +
            '					</div>' +
            '				</div>' +
            '				<div class="pha-col">' +
            '					<a id="PHA_UPLOAD_BtnLoad" class="hisui-linkbutton" style="margin-top: 2px;" data-options="iconCls:\'icon-w-import\'">�ϴ�</a>' +
            '				</div>' +
            '				<div class="pha-col">' +
            '					<a id="PHA_UPLOAD_BtnKeyWord" class="hisui-linkbutton" style="margin-top: 2px;" data-options="iconCls:\'icon-w-save\'">����ؼ���</a>' +
            '				</div>' +
            '			</div>' +
            '			<div class="pha-line"></div>' +
            '		</div>' +
            '		<div data-options="region:\'center\',border:false">' +
            '			<div class="pha-uploader">' +
            '				<ul id="PHA_UPLOAD_Viewer"></ul>' +
            '			</div>' +
            '		</div>' +
            '	</div>' +
            '</div>';
        return winHtml;
    },
    PreviewHtml: function () {
        var winHtml =
            '' +
            '<div id="' +
            this.WinId +
            '" class="hisui-dialog" data-options="modal:true,iconCls:\'icon-w-plus\'" title="�ļ��ϴ�">' +
            '	<div class="hisui-layout" fit="true">' +
            '		<div data-options="region:\'center\',border:false" style="padding:10px;">' +
            '			<div class="hisui-layout" fit="true" >' +
            '				<div data-options="region:\'west\',border:false,split:true" style="width:200px;border:1px solid #cccccc;border-radius: 4px;">' +
            '					<table id="PHA_UPLOAD_Tbl"></table>' +
            '				</div>' +
            '				<div data-options="region:\'center\',border:false" id="PHA_UPLOAD_CENTER" style="border:1px solid #cccccc;border-radius: 4px;">' +
            '					<div style="background:white;" id="PHA_UPLOAD_TOOLBAR">' +
            '						<a  class="hisui-linkbutton" data-options="plain:true,iconCls:\'icon-switch\'" id="PHA_UPLOAD_OpenWin" >�´����д�</a>' +
            '						<a  class="hisui-linkbutton" data-options="plain:true,iconCls:\'icon-remove\'" id="PHA_UPLOAD_Delete" style="display:none;">ɾ��	</a>' +
            '					</div>' +
            '					<div class="pha-line"></div>' +
            '					<div id="PHA_UPLOAD_Viewer"></div>' +
            '				</div>' +
            '			</div>' +
            '		</div>' +
            '	</div>' +
            '</div>';
        return winHtml;
    },
    LIHtml: function (_fileId) {
        var liHtml = '';
        liHtml += '<li id=' + _fileId + '>';
        liHtml += '	<div>';
        liHtml += '		<div class="hisui-progressbar pha-uploader-body-status" style="height:25px;width:250px;"></div>';
        liHtml += '		<div class="pha-uploader-tool" style="height:25px">';
        liHtml += '			<input class="hisui-validatebox" placeholder="�ؼ���..." name="PHA_UPLOAD_KeyWord"/>';
        liHtml += '			<a class="hisui-linkbutton" data-options="plain:true,iconCls:\'icon-remove\'" name="btnDelFile"/></a>';
        liHtml += '		</div>';
        liHtml += '	</div>';
        liHtml += '	<div class="pha-uploader-body">';
        liHtml += '		<div class="pha-uploader-body-header"></div>'; //fileName
        liHtml += '		<div class="pha-uploader-body-img"></div>';
        liHtml += '		<div class="pha-uploader-body-footer"></div>';
        liHtml += '		<div class="pha-uploader-body-realfile" style="display:none;"></div>';
        liHtml += '	</div>';
        liHtml += '</li>';
        return liHtml;
    }
};
