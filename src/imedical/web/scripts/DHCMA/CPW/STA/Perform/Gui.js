//页面Gui
function InitPerformWin(){
	var obj = new Object();
    $.parser.parse(); 
	
	//初始查询条件
    obj.cboHospital = Common_ComboToSSHosp2("cboHospital",session['DHCMA.HOSPID'],"");
	//医院科室联动
	$HUI.combobox('#cboHospital',{
	    onSelect:function(rows){
		    var HospID=rows["OID"];
		    Common_ComboToLoc3("cboLocation","E","","I",HospID);
			//添加病种下拉框
		    if(HospID.indexOf(",")>-1){
			    HospID="";
			}
			$HUI.combobox("#cboPathForm", {
				url: $URL,
				editable: true,
				defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
				valueField: 'BTID',
				textField: 'BTDesc',
				onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
					param.ClassName = 'DHCMA.CPW.BTS.PathMastSrv';
					param.QueryName = 'QryRepPathMast';
					param.aHospID = HospID;
					param.aAdmType='I';
					param.ResultSetType = 'array';
				}
			});
	    }
    });
	obj.DateTo = $('#DateTo').datebox('setValue', Common_GetDate(new Date()));// 日期初始赋值
    obj.DateFrom = $('#DateFrom').datebox('setValue', Common_GetDate(new Date()));
	
	//权限控制
	if(tDHCMedMenuOper['admin']>0){
		obj.IsAdmin=1;
	}else{
		obj.IsAdmin=0;
		$("#cboLocation").combobox('select',session['LOGON.CTLOCID']);
		$("#cboLocation").combobox('disable');	
	}
	
	InitPerformEvent(obj);	
	return obj;
}