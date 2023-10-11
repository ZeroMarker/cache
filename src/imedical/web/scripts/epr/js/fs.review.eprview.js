//全局
var FSEPRView = FSEPRView || {
    SelectEpisode: "",
    Back2Doc: "0",
    Back2Nur: "0",

    //公有方法声明
    QCBack: null
};

//配置和静态
FSEPRView.Config = FSEPRView.Config || {
    ERROR_INFO: "错误",
    ERROR_INFO_EPISODEINFO: "获取患者信息失败！",
    ERROR_INFO_REVIEW: "复核失败，请重新尝试或联系管理员",
    ERROR_INFO_QCBACK: "退回失败，请重新尝试或联系管理员",
    LOADING_INFO: "数据装载中......"
};

(function (win) {
    $(function () {

        //初始化公有方法
        FSEPRView.QCBack = qcback;

		var actionCode = window.dialogArguments.ActionCode;

        //设置患者信息
        setPatInfo();
        var iframeWidth = document.body.clientWidth;
        var iframeHeight = document.body.clientHeight - 85;
        var url = './dhc.epr.fs.review.eprview.centertab.csp?EpisodeID=' + episodeID;
        document.getElementById("iframeDIV").innerHTML = "<iframe id='pdfiframe' src=\'" + url + "\' frameBorder=0 scrolling=no style='z-index:-1;height:" + iframeHeight + ";width:" + iframeWidth + "'></iframe>";

        //关闭时调用父页面刷新列表
        window.onbeforeunload = onbeforeunload_handler;
        function onbeforeunload_handler() {
            searchEpisode();
            return;
        }

        //------------------------------------------------------------------------------------------------------------------

        //关闭
        $('#windowCloseBtn').on('click', function () {
            FSReviewCommon.CloseWebPage();
        });

        //复核通过
        $('#passBtn').on('click', function () {
            getSelectEpisode();
            var obj = $.ajax({
				url: reviewUrl = "../DHCEPRFS.web.eprajax.AjaxReview.cls?Action=reviewpass&ActionCode=" + actionCode + "&EpisodeID=" + FSEPRView.SelectEpisode + "&UserID=" + userID,
                type: 'post',
                async: false
            });

            FSEPRView.SelectEpisode = "";
            var ret = obj.responseText;
			if (ret == "-10")
			{
				if (actionCode == "1")
				{
					alert('质控科复核未通过，不能进行操作！');
				}
				else if (actionCode == "3")
				{
					
					alert('病案室复核未通过，不能进行操作！');
				}
			}
			else
			{
				if (ret !== "1") {
					alert(FSEPRView.Config.ERROR_INFO_REVIEW);
					return;
				}
				else {
					searchEpisode();
					FSReviewCommon.CloseWebPage();
				}
			}
        });

        //退回医生
        $('#back2DocBtn').on('click', function () {
            FSEPRView.Back2Doc = "1";
            FSEPRView.Back2Nur = "0";
            getSelectEpisode();
            FSReviewCommon.OpenBackWin(FSEPRView.QCBack);
        });

        //退回护士
        $('#back2NurBtn').on('click', function () {
            FSEPRView.Back2Doc = "0";
            FSEPRView.Back2Nur = "1";
            getSelectEpisode();
            FSReviewCommon.OpenBackWin(FSEPRView.QCBack);
        });

        //全部退回
        $('#back2AllBtn').on('click', function () {
            FSEPRView.Back2Doc = "1";
            FSEPRView.Back2Nur = "1";
            getSelectEpisode();
            FSReviewCommon.OpenBackWin(FSEPRView.QCBack);
        });
		
		//电子病历链接
        $('#viewEPRBtn').on('click', function () {
			openEPR2Win();
        });
		
		//病案室备注
        $('#mrRemarksBtn').on('click', function () {
			var iWidth = 350;                          //弹出窗口的宽度;
			var iHeight = 240;                        //弹出窗口的高度;
			var iTop = (window.screen.availHeight - 30 - iHeight) / 2;       //获得窗口的垂直位置;
			var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;
			var url = 'dhc.epr.fs.review.mrremarks.csp?EpisodeID=' + episodeID + '&UserID=' + userID;
			window.showModalDialog(url, '', 'dialogHeight=' + iHeight + 'px;dialogWidth=' + iWidth + 'px;dialogTop=' + iTop + 'px;dialogLeft=' + iLeft + 'px;center=yes;help=no;resizable=yes;scroll=no;status=no;edge=sunken');
        });

        //------------------------------------------------------------------------------------------------------------------

		function openEPR2Win() {
            var iWidth = screen.availWidth - 10;                         //弹出窗口的宽度;
            var iHeight = screen.availHeight - 30;                       //弹出窗口的高度;
            var iTop = 0;       //获得窗口的垂直位置;
            var iLeft = 0;
            var url = 'epr.newfw.main.csp?EpisodeID=' + episodeID;
            window.showModalDialog(url, "", 'dialogHeight=' + iHeight + 'px;dialogWidth=' + iWidth + 'px;dialogTop=' + iTop + 'px;dialogLeft=' + iLeft + 'px;center=yes;help=no;resizable=yes;scroll=no;status=no;edge=sunken');
        }
		
        function setPatInfo() {
            var ret = "";
            var obj = $.ajax({
                url: "../DHCEPRFS.web.eprajax.AjaxReview.cls?Action=getepisodeinfo&EpisodeID=" + episodeID,
                type: 'post',
                async: false
            });
            var ret = obj.responseText;
            if ((ret != "") && (ret != null) && (ret != "-1")) {
                var arr = new Array();
                arr = ret.split("^");
                //MedRecordNo_"^"_RegNo_"^"_patientID_"^"_AEpisodeID_"^"_Name_"^"_Gender_"^"_admDate_"^"_disDate_"^"_admLoc_"^"_disLoc
                var medRecordNo = arr[0];
                var regNo = arr[1];
                var name = arr[4];
                var gender = arr[5];
                var admDate = arr[6];
                var disDate = arr[7];
                var admLoc = arr[8];
                var disLoc = arr[9];

                var splitor = '&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp';
                var htmlStr = '<div style="margin:3px;">';
                htmlStr += '<span style="font-family:微软雅黑;font-size:14px;">病案号：</span><textarea style="font-family:微软雅黑;color:#008b8b;font-size:14px;border:0;padding:0;width:85px;height:20px;overflow:hidden" readonly="readonly">' + medRecordNo + '</textarea>' + splitor;
                htmlStr += '<span style="font-family:微软雅黑;font-size:14px;">登记号：</span><textarea style="font-family:微软雅黑;color:#008b8b;font-size:14px;border:0;padding:0;width:100px;height:20px;overflow:hidden" readonly="readonly">' + regNo + '</textarea>' + splitor;
                htmlStr += '<span style="font-family:微软雅黑;font-size:14px;">姓名：</span><span style="font-family:微软雅黑;color:#008b8b;font-size:14px;">' + name + '</span>' + splitor;
                htmlStr += '<span style="font-family:微软雅黑;font-size:14px;">性别：</span><span style="font-family:微软雅黑;color:#008b8b;font-size:14px;">' + gender + '</span>' + splitor;
                //htmlStr += '</div><div style="margin:3px">';
                htmlStr += '<span style="font-family:微软雅黑;font-size:14px;">入院日期：</span><span style="font-family:微软雅黑;color:#008b8b;font-size:14px;">' + admDate + '</span>' + splitor;
                htmlStr += '<span style="font-family:微软雅黑;font-size:14px;">出院日期：</span><span style="font-family:微软雅黑;color:#008b8b;font-size:14px;">' + disDate + '</span>' + splitor;
                htmlStr += '<span style="font-family:微软雅黑;font-size:14px;">入院科室：</span><span style="font-family:微软雅黑;color:#008b8b;font-size:14px;">' + admLoc + '</span>' + splitor;
                htmlStr += '<span style="font-family:微软雅黑;font-size:14px;">出院科室：</span><span style="font-family:微软雅黑;color:#008b8b;font-size:14px;">' + disLoc + '</span>' + splitor;
                htmlStr += '</div>';
                $('#infoPanel').append(htmlStr);
            }
            else {
                $.messager.alert(FSEPRView.Config.ERROR_INFO, FSEPRView.Config.ERROR_INFO_EPISODEINFO, 'error');
            }
        }

        function getSelectEpisode() {
            FSEPRView.SelectEpisode = episodeID;
        }

        function qcback(reason) {
            var obj = $.ajax({
				url: "../DHCEPRFS.web.eprajax.AjaxReview.cls?Action=qcback&ActionCode=" + actionCode + "&EpisodeID=" + FSEPRView.SelectEpisode + "&UserID=" + userID + "&Reason=" + encodeURI(reason) + "&Back2Nur=" + FSEPRView.Back2Nur + "&Back2Doc=" + FSEPRView.Back2Doc,
                type: 'post',
                async: false
            });

            FSEPRView.Back2Doc = "0";
            FSEPRView.Back2Nur = "0";
            FSEPRView.SelectEpisode = "";

            var ret = obj.responseText;
			if (ret == "-10")
			{
				if (actionCode == "1")
				{
					alert('质控科复核未通过，不能进行操作！');
				}
				else
				{
					if (actionCode == "3")
					{
						alert('病案室复核未通过，不能进行操作！');
					}
				}
			}
			else
			{
				if (ret != "1") {
					alert(FSEPRView.Config.ERROR_INFO_QCBACK);
					return;
				}
				else {
					searchEpisode();
					FSReviewCommon.CloseWebPage();
				}
			}
        }

        function searchEpisode() {
            window.dialogArguments.funObj.apply(this, []);
        }

    });
}(window));
