/** 
 * ģ��: 	 ��������-����ҩ�������
 * ��д����: 2020-09-04
 * ��д��:   pushuangcai
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
/// ������Ϣ��ʼ��
function InitSetDefVal() {
	//��ѯ���ڳ�ʼ��
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

/// ��ѯ
function Query() {
	var comNo = $('#conComNo').val() ;

	var StartDate = $('#conStartDate').datebox('getValue') ;
	var EndDate = $('#conEndDate').datebox('getValue') ;
	if ((StartDate == "")||(StartDate == "")){
		PHA.Alert('��ʾ', "���ڷ�Χ����Ϊ��!", 'warning');
		return ;
	}
	var Ctype = $('input[name="type"]:checked').attr("value");
	var poisonstr = $('#antiCtrl').combobox("getValue");
	var radioValue = $('input[name="wantSelect"]:checked').attr("value");
	if(radioValue === ""){
		PHA.Alert('��ʾ', "����ѡ�񱨱�����!", 'warning');
		return ;	
	}
    if (radioValue == "����ҩ����������") {
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