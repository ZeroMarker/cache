
//关闭窗口
function closeWindow() {
    window.opener = null;
    window.open('', '_self');
    window.close();
}

$(function () {

    var args = opener.HisTools.hislinkWindow.args;
    document.title = args.title;

    var isConfirm = false;
    function setConfirm(flag) {
        isConfirm = flag;
        closeWindow();        
    }
    $('#confirm').live('click', function () {
        setConfirm(true);
    });
    $('#cancel').live('click', function () {
        setConfirm(false);
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
