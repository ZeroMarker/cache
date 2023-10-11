/**
 * author :			MaYuqiang
 * datecreated :	2022-05-30
 * description: 	ºÂ“©◊¥Ã¨ ±º‰÷·
 */
var PHADEC_UX = {
	TimeLine: function (_opts, _qOpts) {
        var winId = 'PHADEC_UX_TimeLine';
        var lineId = winId + '_Line';
        var existHtml = $('#' + winId).html() || '';
        if (existHtml === '') {
            var winDiv = '<div id=' + winId + ' style="padding:10px"><div id=' + lineId + '></div></div>';
            $('body').append(winDiv);

            var winOpts = {
                title: ' ºÂ“© ±º‰÷·',
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
                ClassName: 'PHA.DEC.Compre.Query',
                QueryName: 'GetDecTimeLine',
                inputStr: _qOpts.phpmId
            },
            false
        );
        var itemsArr = [];
        var rowsData = retData.rows;
        for (var i = 0; i < rowsData.length; i++) {
            var rowData = rowsData[i];
            var contextArr = [];
            contextArr.push('<div>');
            contextArr.push(rowData.staDate);
            contextArr.push('</div>');
            contextArr.push('<div>');
            contextArr.push(rowData.staTime);
            contextArr.push('</div>');
            contextArr.push('<div>');
            contextArr.push(rowData.staUserName);
            contextArr.push('</div>');
            var item = {};
            item.title = rowData.staDesc;
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
    }
};
