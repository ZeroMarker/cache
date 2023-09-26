//全局
var FSReviewTimeLine = FSReviewTimeLine || {};

(function (win) {
    $(function () {

        //加载完即显示示踪时间轴
        setTrakInfo();

        //------------------------------------------------------------------------------------------------------------------

        //div格式，color红色表示退回，黑色正常操作，绿色表示通过
        //<div class="history">
        //	<div class="history-date">
        //		<ul>
        //			<h2 class="first"></h2>
        //			<li>
        //				<h3 >日期<span>时间</span></h3>
        //				<dl>
        //					<dt style="color:red">动作<span>动作操作者</span><span>备注内容</span></dt>
        //				</dl>
        //			</li>
        //			<li>
        //				<h3 >日期<span>时间</span></h3>
        //				<dl>
        //					<dt style="color:black">动作<span>动作操作者</span><span>备注内容</span></dt>
        //				</dl>
        //			</li>
        //		</ul>
        //	</div>
        //</div>

        function setTrakInfo() {
            var ret = "";
            var obj = $.ajax({
                url: "../DHCEPRFS.web.eprajax.AjaxReview.cls?Action=trakinfo&EpisodeID=" + episodeID,
                type: 'post',
                async: false
            });
            var ret = obj.responseText;
            if ((ret != "") && (ret != null) && (ret != "-1")) {
                var htmlStr = '<div class="history">';
                htmlStr += '<div class="history-date">';
                htmlStr += '<ul>';
                htmlStr += '<h2 class="first"></h2>';

                var arr = new Array();
                arr = ret.split("|");

                for (var i = 0; i < arr.length; i++) {
                    var arrIn = new Array();
                    arrIn = arr[i].split("^");
                    var actDate = arrIn[0];
                    var actTime = arrIn[1];
                    var actUserName = arrIn[2];
                    var color = arrIn[3];
                    var actDesc = arrIn[4];
                    var message = arrIn[5];

                    htmlStr += '<li>';
                    htmlStr += '<h3 style="color:' + color + '">' + actDate + '<span style="color:' + color + '">' + actTime + '</span></h3>';
                    htmlStr += '<dl>';
                    htmlStr += '<dt style="color:' + color + '">' + actDesc + '<span class="dtspan1" style="color:' + color + '">' + actUserName + '</span><span class="dtspan2" style="color:' + color + '">' + message + '</span></dt>';
                    htmlStr += '</dl>';
                    htmlStr += '</li>';
                }
                htmlStr += '</ul>';
                htmlStr += '</div>';
                htmlStr += '</div>';

                $('#timelineroot').append(htmlStr);
                systole();	
            }
        }

        function systole() {
            if (!$(".history").length) {
                return;
            }
            var $warpEle = $(".history-date");
            var parentH;
            var eleTop = [];

            parentH = $warpEle.parent().height() + 130;
            $warpEle.parent().css({ "height": 59 });

            setTimeout(function () {
                $warpEle.find("ul").children(":not('h2')").each(function (idx) {
                    eleTop.push($(this).position().top);
                    $(this).css({ "margin-top": -eleTop[idx] }).children().hide();
                }).animate({ "margin-top": 0 }, 1600).children().fadeIn();
                $("html,body").animate({ "scrollTop": parentH }, 2600);
                $warpEle.parent().animate({ "height": parentH }, 2600);
                $warpEle.find("ul").children(":not('h2')").addClass("bounceInDown").css({ "-webkit-animation-duration": "2s", "-webkit-animation-delay": "0", "-webkit-animation-timing-function": "ease", "-webkit-animation-fill-mode": "both" }).end().children("h2").css({ "position": "relative" });
            }, 600);
        }

    });
}(window));