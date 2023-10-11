/**
 * 名称:   	 药房药库-毒麻药品管理-登记册报表
 * 编写人:   Huxiaotian
 * 编写日期: 2020-08-23
 * csp:		 pha.in.v1.narcqueryreg.csp
 * js:		 pha/in/v1/narcqueryreg.js
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = '药库';
PHA_COM.App.Csp = 'pha.in.v1.narcqueryreg.csp';
PHA_COM.App.Name = '登记查询';
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};
PHA_COM.VAR.SetDefaultTask = null;
PHA_COM.VAR.EmptyRepUrl = '../csp/dhcst.blank.backgroud.csp';
if (typeof websys_writeMWToken !== 'undefined') {
	PHA_COM.VAR.EmptyRepUrl = websys_writeMWToken(PHA_COM.VAR.EmptyRepUrl);
}
$(function() {
	InitLayout();
	InitDict();
	InitEvents();
	InitConfig();
});

// 初始化 - 表单字典
function InitDict(){
	$('#recLocId').parent().parent().hide();
	InitCondition();
}

// 初始化 - 事件绑定
function InitEvents(){
	$('#btnFind').on("click", Query);
    $('#btnClear').on("click", Clear);
    $('#patNo').on('keydown', function(e){
		if (e.keyCode == 13) {
			var tPatNo = $('#patNo').val() || "";
			if (tPatNo == '') {
				return;
			}
			var nPatNo = PHA_COM.FullPatNo(tPatNo);
			$('#patNo').val(nPatNo);
			Query();
		}
	});
}

// 初始化 - 布局
function InitLayout(){
	$('#div-report').html('<iframe id="iframe-report" style="display:block;width:99.6%;height:99%" src="' + PHA_COM.VAR.EmptyRepUrl + '" />');
}

// 查询
function Query(){
	var formData = GetCondition();
	if (formData == null) {
		return;
	}
	var InputStr = JSON.stringify(formData);
	var _reportUrl = 'dhccpmrunqianreport.csp';
	_reportUrl += '?reportName=' + 'PHAIN_NarcReg.rpx';
	_reportUrl += '&InputStr=' + InputStr;
	_reportUrl += '&startDate=' + formData.startDate;
	_reportUrl += '&endDate=' + formData.endDate;
	_reportUrl += '&hospId=' + session['LOGON.HOSPID'];
	if (typeof websys_writeMWToken !== 'undefined') {
		_reportUrl = websys_writeMWToken(_reportUrl);
	}
	$('#iframe-report').attr('src', _reportUrl);
}

// 清除
function Clear(){
	ClearCondition();
	$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['RegQuery.StDate']));
	$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['RegQuery.EdDate']));
	PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	$('#iframe-report').attr('src', PHA_COM.VAR.EmptyRepUrl);
}

// 配置初始化
function InitConfig() {
	$.cm({
		ClassName: "PHA.IN.Narc.Com",
		MethodName: "GetConfigParams",
		InputStr: PHA_COM.Session.ALL
	}, function(retJson) {
		// 传递给全局
		PHA_COM.VAR.CONFIG = retJson;
		$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['RegQuery.StDate']));
		$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['RegQuery.EdDate']));
		PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	}, function(error){
		console.dir(error);
		alert(error.responseText);
	});
}