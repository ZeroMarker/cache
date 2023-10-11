var PHA_IP_UX = {
    ReqTimeLine: function (phr) {
        var winID = 'PHA_IP_UX_ReqTimeLine';
        if ($('#' + winID).text() != '') {
            $('#' + winID).html('');
        } else {
            var winDiv = '<div id="' + winID + '" style="overflow:hidden"><div id="stepss" style="padding:10px;height:90px"></div></div>';
            $('body').append(winDiv);
        }
        $.cm(
            {
                ClassName: 'PHA.IP.COM.TimeLine',
                QueryName: 'InPhReq',
                phr: phr
            },
            function (retJson) {
                $('#' + winID).window({
                    title: ' 领药单时间轴',
                    collapsible: false,
                    iconCls: 'icon-w-clock',
                    border: false,
                    closed: true,
                    modal: false,
                    maximizable: false,
                    minimizable: false,
                    width: $(window).width() - 20,
                    left: 10,
                    top: 10,
                    onBeforeClose: function () {
                        $('#' + winID).remove();
                    }
                });
                $('#' + winID).window('open');

                $('#stepss').hstep({
                    //showNumber:false,
                    stepWidth: 200,
                    currentInd: 3,
                    onSelect: function (ind, item) {
                        console.log(item);
                    },
                    //titlePostion:'top',
                    items: [
                        {
                            title: '挂号',
                            context: '<div>王二</div><div>2020-07-03 09:10</div>'
                        },
                        {
                            title: '就诊',
                            context: '<div>张三</div> 2020-07-03 10:10'
                        },
                        {
                            title: '收费',
                            context: '<div>李四</div> 2020-07-03 11:10'
                        },
                        {
                            title: '取药'
                        },
                        {
                            title: '完成'
                        }
                    ]
                });
            }
        );
    }
};
