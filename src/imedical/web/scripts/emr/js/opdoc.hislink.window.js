
//关闭窗口
function closeWindow() {
    if (window.returnValue) {
        if (window.parent.HisTools['hislinkWindow'].args.confirmCallback) {
            window.parent.HisTools['hislinkWindow'].args.confirmCallback();
        }
    } else {
        if (window.parent.HisTools['hislinkWindow'].args.cancelCallback) {
            window.parent.HisTools['hislinkWindow'].args.cancelCallback();
        }
    }
    if ((window.parent)&&(window.parent.closeDialog)){
        window.parent.closeDialog(dialogId);
    }
}

$(function () {
    document.title = title;

    window.returnValue = false;
    
    $('#confirm').bind('click', function () {
        window.returnValue = true;
        closeWindow();
    });
    $('#cancel').bind('click', function () {
        window.returnValue = false;
        closeWindow();
    });


    if (null !== isConfirmCallback) {
        $('#confirm').show();
    }
    $('#frameHIS').attr('src', lnk);

});
