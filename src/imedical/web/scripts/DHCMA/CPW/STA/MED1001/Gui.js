//页面Gui
function InitMED1001Win(){
	var obj = new Object();
    $.parser.parse(); 
	
	//初始查询条件
    obj.cboHospital = Common_ComboToSSHosp("cboHospital",SSHospCode,"CPW");
	//医院科室联动
	$HUI.combobox('#cboHospital',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
		    Common_ComboToLoc("cboLocation","E","","",HospID);
	    }
    });
	Common_CreateMonth('DateFrom');
	Common_CreateMonth('DateTo');
	//添加病种下拉框
	$HUI.combobox("#cboPathEntity", {
		url: $URL,
		editable: true,
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'BTID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCMA.CPW.BTS.PathEntitySrv';
			param.QueryName = 'QryPathEntity';
			param.aIsActive = 1;
			param.ResultSetType = 'array';
		}
	});
	obj.IsAdmin = 0;
	if (tDHCMedMenuOper) {
		if (tDHCMedMenuOper['admin'] == '1') {
			obj.IsAdmin=1;
		}
	}
	
	InitMED1001WinEvent(obj);	
	return obj;
}