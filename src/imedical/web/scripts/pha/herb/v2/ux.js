/**
 * 编写者:   mayuqiang
 * 编写日期: 2020-12-28
 * 说明:    草药房公共JS
 */
var PHAHERB_COM = {
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
            msg += '    <span style="color:#757575;font-weight:bold">总记录' + msgJson.recordCnt + '</span>';
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
    Element:{
	    AutoExeErrInfo:"errInfo"
	},
    Default:{
	    selCookTypeId : "",         // 当前选择处方的煎药方式id
        selCookTypeDesc : "",       // 当前选择处方的煎药方式描述
	},
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
                navigator.sendBeacon($URL + '?ClassName=PHA.HERB.Com.Base&MethodName=KillTmp&clsName=' + clsName + '&pid=' + pid + "&MWToken="+ websys_getMWToken(), '');
            } else {
                tkMakeServerCall('PHA.HERB.Com.Base', 'KillTmp', clsName, pid);
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
    /**
     * 草药处方可退原因窗体
     * @param {object} _opts 窗体大小参数
     * @param {*} _qOpts 	 query入参(AdmId,Ooeri)
     */
    AgreeRetReason: function (_opts, _qOpts) {
        var winId = 'PHA_HERB_AgreeRetReason';
        var gridId = winId + '_Grid';
        var existHtml = $('#PHA_HERB_AgreeRetReason').html() || '';
        if (existHtml !== '') {
            $('#' + gridId).datagrid('query', {
                ClassName: 'PHA.HERB.Dispen.Query',
                QueryName: 'PrescAgrRetReason',
                phbdId: _qOpts.phbdId || ''
            });
            $('#' + winId).window('open');
            return;
        }
        var winDiv = '<div id=' + winId + ' style="padding:10px;overflow:hidden;"><div id=' + gridId + '></div></div>';
        $('body').append(winDiv);
        //定义表格
        var columns = [
            [
                {
                    field: 'group',
                    hidden: true
                },
                {
                    field: 'field',
                    title: '属性',
                    width: 100,
                    align: 'right',
                    formatter: function (value, row, index) {
                        return $g(value)
                    },
                    styler: function (value, row, index) {
                        if (!PHA_UX.IsLiteCss) {
                            return 'background:#f4f6f5;';
                        }else{
                            return 'background:rgb(248,248,248)'
                        }
                    }
                },
                {
                    field: 'value',
                    title: '值',
                    width: 300
                }
                
                
            ]
        ];
        var dataGridOption = {
            url: $URL,
            queryParams: {
                ClassName: 'PHA.HERB.Dispen.Query',
                QueryName: 'PrescAgrRetReason',
                phbdId: _qOpts.phbdId || ''
            },
            fit: true,
            fitColumns: true,
            showHeader: false,
            // showGroup: true,
            bodyCls: PHA_UX.IsLiteCss ? 'table-splitline' : '',
            scrollbarSize: -1,
            rownumbers: false,
            columns: columns,
            pageSize: 9999,
            pagination: false,
            singleSelect: true,
            nowrap: false,
            toolbar: null,
            border: false,
            onLoadSuccess: function (data) {
                if (data.rows) {
                    var rowsData = data.rows;
                }
                $('#' + winId + ' td.datagrid-td-merged > div').css({'line-height':'28px','position':'relative','top':'-5px'})
            }
        };
        $('#' + gridId).datagrid(dataGridOption);
        var winOpts = {
            title: ' 可退原因信息',
            collapsible: false,
            iconCls: 'icon-w-list',
            border: false,
            resizable: true,
            minimizable: false,
            maximizable: false,
            closed: true,
            modal: true,
            width: 400,
            height: 194,    //PHA_UX.IsLiteCss ? 194 : 194,
            toolbar: null,
            onBeforeClose: function () {
                //$('#' + winId).remove();
            }
        };
        $('#' + winId).window($.extend({}, winOpts, _opts));
        $('#' + winId + " [class='datagrid-header']").css('border', 'none');
        $('#' + winId + " [class='panel datagrid']").css('border', '#e2e2e2 solid 1px');
        $('#' + winId + " [class='panel datagrid']").css('border-radius', '4px');
        $('#' + winId + " [class='datagrid-body']").css('overflow', 'hidden');
        $('#' + winId).window('open');
    },
    TimeLine: function (_opts, _qOpts) {
        var winId = 'PHAHERB_UX_TimeLine';
        var lineId = winId + '_Line';
        var existHtml = $('#' + winId).html() || '';
        if (existHtml === '') {
            var winDiv = '<div id=' + winId + ' style="padding:10px"><div id=' + lineId + '></div></div>';
            $('body').append(winDiv);

            var winOpts = {
                title: ' 处方时间轴',
                collapsible: false,
                iconCls: 'icon-w-clock',
                border: false,
                resizable: true,
                minimizable: false,
                maximizable: false,
                closed: true,
                modal: true,
                width: $('body').width() - 40,
                height: 180,
                top: 20,
                left: 20,
                toolbar: null,
                onBeforeClose: function () {}
            };

            $('#' + winId).window($.extend({}, winOpts, _opts));
            $('#' + winId).window('setModalable');
        }
        $('#' + winId).window('open');
        var retData = $.cm(
            {
                ClassName: 'PHA.HERB.Query.TimeLine',
                QueryName: 'GetHerbTimeLine',
                prescNo: _qOpts.prescNo
            },
            false
        );
        var itemsArr = [];
        var rowsData = retData.rows;
        for (var i = 0; i < rowsData.length; i++) {
            var rowData = rowsData[i];
            var contextArr = [];
            contextArr.push('<div>');
            contextArr.push(rowData.stateDate);
            contextArr.push('</div>');
            contextArr.push('<div>');
            contextArr.push(rowData.stateTime);
            contextArr.push('</div>');
            contextArr.push('<div>');
            contextArr.push(rowData.stateUserName);
            contextArr.push('</div>');
            contextArr.push('<div>');
            contextArr.push(rowData.stateLocDesc);
            contextArr.push('</div>');
            var item = {};
            item.title = rowData.stateDesc;
            item.context = contextArr.join('');
            itemsArr.push(item);
        }
        $('.hstep').children().remove();
        $('#' + lineId).hstep({
            showNumber: false,
            stepWidth: 150,
            currentInd: rowsData.length,
            items: itemsArr
        });
    },
    Window : {
	    ComInfo:{
			winId:"WindowInfo",
			gridId:"gridExeWin",
			type:"",
			height:"",
			width:""
		},
	    Open:function(_opt,_fn){
			var type = _opt.type;
            var tipMsg = _opt.title
			var winOpts = {};
			PHA_COM.Window.Proportion = 1;
			if(type == "AutoExe"){
				winOpts.title = $g("自动执行");
                winOpts.winTipMsg = tipMsg;
				winOpts.width = PHA_COM.Window.Width() * 0.65;
				winOpts.height = PHA_COM.Window.Height() * 0.8
				winOpts.top = 20;
				winOpts.left = (PHA_COM.Window.Width() - winOpts.width)/2 ;
				winOpts.opType = type;
				PHAHERB_COM.Window.InitWindowAutoExe(winOpts,_fn);
			}
			// 修改窗口标题
			$('#'+ this.ComInfo.winId ).window('setTitle', winOpts.title);
			$('#'+ this.ComInfo.winId ).window('open');		//  InitWindowAutoExe 之后窗体就已经打开了，所以注释此处
		},
		InitWindowAutoExe:function(_opt,_callBack){
			if(_opt.opType !== this.ComInfo.type){
				var $widow = $('#' + this.ComInfo.winId);
				if ($widow.length === 0){
					var $widow = $('<div id="'+ this.ComInfo.winId +'"></div>').appendTo('body');
				}
				$widow.empty();
                var winTipMsg = _opt.winTipMsg;
				var htmlStr = '<table width="100%" height="100%" >'
                            +   '<tr>'
							+ 		'<td align="center">'
							+ 			'<lable style=font-weight:bold;font-size:30px;>'+ winTipMsg +'</lable>'
							+ 		'</td>'
							+ 	'</tr>'
							+ 	'<tr>'
							+ 		'<td align="center">'
							+ 			'<img src="../scripts/pha/com/v1/css/imgs/start_dispensing.gif" height="250px" width="250px">'
							+ 		'</td>'
							+ 	'</tr>'
							+ 	'<tr>'
							+ 		'<td>'
							+ 			'<lable id="'+PHAHERB_COM.Element.AutoExeErrInfo+'"></lable>'
							+ 		'</td>'
							+ 	'</tr>'
							+ '</table>'
				$widow.append(htmlStr);
				this.ComInfo.type = _opt.opType;
			} else {
				return;	
			}			
			
			if (typeof _opt === "undefined"){
				var _opt = {};	
			}
			$widow.window({
				collapsible: false,
				minimizable: false,
				maximizable: false,
				closable: true,	
				closed:true,			
				modal: true,
				title: _opt.title || "弹窗",
				width: _opt.width || PHA_COM.Window.Width() * 0.65,	
				height: _opt.height || PHA_COM.Window.Height() * 0.65,		
				left:_opt.left || 300, 	
                iconCls:'icon-w-paper',	
				onOpen: function(){
					if(_callBack){
						_callBack();
					}
				},
				onClose: function(){
					clearInterval(DHCPHA_CONSTANT.VAR.TIMER);
				}
			});	
		}
	    
    },
    WaitStatusFormatter: function(val, rowData, rowIndex){
		var retArr = [];
		retArr.push('<span class="pha-grid-a icon icon-ring-blue" title="叫号">&nbsp;</span>');
        retArr.push('<span class="pha-grid-a icon icon-skip-no" title="过号">&nbsp;</span>'); 
		return retArr.join('');
	},
    Formatter: {
        OeoriSign: function (value, row, index) {
            if ((value == "│") || (value == "0")) {
                return '<div class="herb-oeori-sign-c"></div>';
            } else if ((value == "┍") || (value == "-1")) {
                return '<div class="herb-oeori-sign-t"></div>';
            } else if ((value == "┕") || (value == "1")) {
                return '<div class="herb-oeori-sign-b"></div>';
            } else {
                return value;
            }
        }
    },
	// 待发药列表状态 ()
	WaitStatusStyler : function(value, row, index){
		var statusCode = row.TCallFlag || ""
		var styleCls = "";
	     switch (statusCode) {
	         case '0':
	             styleCls = {class:'pha-herb-grid-call'}
	             break;
	         case '3':
	             styleCls = {class:'pha-herb-grid-skip'}
	             break;
	         case '5':
	             styleCls = {class:'pha-herb-grid-unqueue'}
	             break;
	     }
	     return styleCls;
	}

};
