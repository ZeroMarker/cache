/*
 * @author: yaojining
 * @discription: �����������ַ�����
 * @date: 2019-12-29
 */
var GV = {
    ClassName: "NurMp.Service.Refer.Chars",
    HospEnvironment: false
};
var init = function () {
    initPageDom();
}
$(init)
function initPageDom() {
	$cm({
        ClassName: GV.ClassName,
        MethodName: "getChars",
        HospitalID: session['LOGON.HOSPID']
    }, function (jsonData) {
        $("#kwChars").keywords({
		    singleSelect:false,
		    items:jsonData,
		    onClick:function(v){
				
		    }
		});
    });
}