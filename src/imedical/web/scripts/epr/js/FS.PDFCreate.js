(function (win) {
	$(function () {
		setPatInfo();
		if (timeOutItemID == '') {
			beginPDFCreate();
		}
		else {
			timeOut(timeOutItemID);
		}
	});
	
	function setPatInfo() {
		var splitor = '&nbsp&nbsp|&nbsp&nbsp';
		var htmlStr = '<span class="spantitle">病人基本信息</span>';
		htmlStr += splitor
				+ '<span class="spantext">姓名：</span><span class="spantext">'
				+ patName + '</span>';
		htmlStr += splitor
				+ '<span class="spantext">性别：</span><span class="spantext">'
				+ patSex + '</span>';
		htmlStr += splitor
				+ '<span class="spantext">就诊科室：</span><span class="spantext">'
				+ currentDept + '</span>';
		htmlStr += splitor
				+ '<span class="spantext">病案号：</span><span class="spantext">'
				+ patMedRecordNo + '</span>';
		htmlStr += splitor
				+ '<span class="spantext">登记号：</span><span class="spantext">'
				+ patRegNo + '</span>';
		$('#patBasicInfo').append(htmlStr);
	}
}(window));
