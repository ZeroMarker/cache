/** 
 * 模块: 	 处方点评-抗菌药报表汇总
 * 编写日期: 2020-09-04
 * 编写人:   pushuangcai
 */
var logonLocId = session['LOGON.CTLOCID'] ;
var logonUserId = session['LOGON.USERID'] ;
var logonGrpId = session['LOGON.GROUPID'] ;
var hospID = session['LOGON.HOSPID'];
$(function(){
	PHA.ComboBox("antiCtrl", {
		width: 155,		
		url: PRC_STORE.PCNTSAntiLevel(),
	});
	InitSetDefVal();
	$('#btnFind').on("click", Query);
})
/// 界面信息初始化
function InitSetDefVal() {
	//查询日期初始化
	$.cm({
		ClassName: "PHA.PRC.Com.Util",
		MethodName: "GetAppProp",
		UserId: logonUserId ,
		LocId: logonLocId ,
		SsaCode: "PRC.COMMON"
	}, function (jsonColData) {
		$("#conStartDate").datebox("setValue", jsonColData.QueryStartDate);
		$("#conEndDate").datebox("setValue", jsonColData.QueryEndDate);
		$("#conNoStartDate").datebox("setValue", jsonColData.ComStartDate);
		$("#conNoEndDate").datebox("setValue", jsonColData.ComEndDate);
		$("iframe").attr("src",PRC_STORE.RunQianBG);
	});
}

/// 查询
function Query() {
	var comNo = $('#conComNo').val() ;

	var StartDate = $('#conStartDate').datebox('getValue') ;
	var EndDate = $('#conEndDate').datebox('getValue') ;
	if ((StartDate == "")||(StartDate == "")){
		PHA.Alert('提示', "日期范围不能为空!", 'warning');
		return ;
	}
	var Ctype = $('input[name="type"]:checked').attr("value");
	var poisonstr = $('#antiCtrl').combobox("getValue");
	var radioValue = $('input[name="wantSelect"]:checked').attr("value");
	if(radioValue === ""){
		PHA.Alert('提示', "请先选择报表类型!", 'warning');
		return ;	
	}
    if (radioValue == "抗菌药物用量分析") {
        var raqObj = {
            raqName: "DHCPRC_PharmacyCnt_KJInfo.raq",
            raqParams: {
                SDate: StartDate,
                EndDate: EndDate,            
                PcntsNo: comNo ,
                Ctype: Ctype,
                poisonstr: poisonstr,
                Cphcsubcat: '',
                Carcitmid: '',
                HOSPID: hospID,
                USERNAME: session['LOGON.USERNAME'],
            },
            isPreview: 1,
            isPath: 1
        };
		var raqSrc=PRCPRINT.RaqPrint(raqObj)
	    $("iframe").attr("src",raqSrc);
    } 
}