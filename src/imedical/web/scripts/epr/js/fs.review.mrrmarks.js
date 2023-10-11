(function (win) {
    $(function () {
		setRemarksTextBox();
		
		//保存
		$('#saveBtn').on('click', function () {
			var remarks = $('#inputRemarks').val();
			if (remarks === "") {
				$.messager.alert("提示", "请填写备注", 'info');
			}
			else {
				var remarks = encodeText(remarks);
				var obj = $.ajax({
					url: "../DHCEPRFS.web.eprajax.AjaxReview.cls?Action=mrremarks&EpisodeID=" + episodeID + "&UserID=" + userID + "&mrremarks=" + encodeURI(remarks),
					type: 'post',
					async: false
				});
				var ret = obj.responseText;
				if (ret === "1") {
					$.messager.alert("提示", "保存成功", 'info', function(){closeWebPage();});
				}
				else {
					$.messager.alert("错误", "保存失败", 'error');
				}
			} 
        });
		
		//取消
		$('#cancelBtn').on('click', function () {
            closeWebPage();
        });
		
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
		
		function setRemarksTextBox() {
            var obj = $.ajax({
                url: "../DHCEPRFS.web.eprajax.AjaxReview.cls?Action=lastmrremarks&EpisodeID=" + episodeID,
                type: 'post',
                async: false
            });
            var lastRemarks = obj.responseText;
            $('#inputRemarks').val(lastRemarks);
        }
		
		//特殊字符处理
		function encodeText(str) {
			var result = str.replace(/\\/g,'\\\\').replace(/\"/g,'\\"');
			return result;
		}
    });
}(window));