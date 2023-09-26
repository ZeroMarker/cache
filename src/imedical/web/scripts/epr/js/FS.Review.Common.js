//全局
var FSReviewCommon = FSReviewCommon || {
    //公有方法声明
    CloseWebPage: null,
    OpenBackWin: null
};

(function (win) {
    //初始化公有方法
    FSReviewCommon.CloseWebPage = closeWebPage;
    FSReviewCommon.OpenBackWin = openBackWin;

    //------------------------------------------------------------------------------------------------------------------

    function closeWebPage() {
        if (navigator.userAgent.indexOf("MSIE") > 0) {
            if (navigator.userAgent.indexOf("MSIE 6.0") > 0) {
                window.opener = null;
                window.close();
            } else {
                window.open('', '_top');
                window.top.close();
            }
        }
        else if (navigator.userAgent.indexOf("Firefox") > 0) {
            window.location.href = 'about:blank ';
        }
        else {
            window.opener = null;
            window.open('', '_self', '');
            window.close();
        }
    }

    function openBackWin(functionObj) {
        var iWidth = 370;                          //弹出窗口的宽度;
        var iHeight = 300;                        //弹出窗口的高度;
        var iTop = (window.screen.availHeight - 30 - iHeight) / 2;       //获得窗口的垂直位置;
        var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;
        var url = 'dhc.epr.fs.review.dialog.csp?UserID=' + userID;
        window.showModalDialog(url, { funObj: functionObj }, 'dialogHeight=' + iHeight + 'px;dialogWidth=' + iWidth + 'px;dialogTop=' + iTop + 'px;dialogLeft=' + iLeft + 'px;center=yes;help=no;resizable=yes;scroll=no;status=no;edge=sunken');
    }

}(window));