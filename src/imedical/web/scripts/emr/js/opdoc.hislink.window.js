
//关闭窗口
function closeWindow() {
    window.opener = null;
    window.open('', '_self');
    window.close();
}

$(function () {

    var args = opener.HisTools.hislinkWindow.args;
    //var args = window.HisTools.hislinkWindow.args;
    document.title = args.title;

    var isConfirm = false;
    $('#confirm').bind('click', function () {
        isConfirm = true;
        //window.$('#'+args.id).window('close');
        /*if (args.confirmCallback)
            args.confirmCallback();*/
        closeWindow();
    });
    $('#cancel').bind('click', function () {
        isConfirm = false;
        //window.$('#'+args.id).window('close');
        /*if (args.cancelCallback)
            args.cancelCallback();*/
        closeWindow();
    });

    window.onunload = function () {
        if (isConfirm) {
            if (args.confirmCallback)
                args.confirmCallback();
        } else {
            if (args.cancelCallback)
                args.cancelCallback();
        }
    };

    if (null !== args.confirmCallback) {
        $('#confirm').show();
    }
    $('#frameHIS').attr('src', args.lnk);

});
