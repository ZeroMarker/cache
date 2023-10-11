var GLOBAL = {
	MuchHospFlag : '1' // 是否使用基础数据平台的多院区   0 ： 不启用   1：启用	
}
function BuildHospitalComb(){
	if(GLOBAL.MuchHospFlag){
		BuildBaseDatHospitalComb();
	}else{
		BuildBILLINSUHospitalComb();
	}	
}
function BuildBILLINSUHospitalComb(){
			
}
function BuildBaseDatHospitalComb(){
	var BDPID = GetURLParam("BDPMENU"); // 根据菜单Id 获取菜单描述
	var defaultHospId = GetURLParam("HospId") || '';
	// GetBDPMenuTable
	var TableName=tkMakeServerCall("web.DHCBILLINSUCloudCommon","GetBDPMenuTable",BDPID);
	// 侧菜单取不到配置，取头菜单配置
	var tmpHeadTable = GetURLParam('TableName');
	if(tmpHeadTable != "" && TableName==""){
		TableName = tmpHeadTable;	
	}
	if(location.toString().indexOf('insutarcontrast') > 0 &&  TableName=="" ){
			TableName = 'ALLHospital';
	}
	// 界面如果有院区控件 则不添加
	if ($("#_HospList").length==0){
		$("<tr><td style='text-align:right'><label id='_HospListLabel' style='color:red' class='r-label td-first-col'>医院</label></td>\
		<td colspan='6'><input id='_HospList' class='textbox' /></td></tr>").prependTo("table:first");
	}
		
	var HospitalSelect = "_HospList";
	// 根据维护的配置判断是否显示所有医院
	if(TableName == "ALLHospital"){
		$('#_HospListLabel').attr("id","_HospUserListLabel");
		$('#_HospList').attr("id","_HospUserList");
		var hospCombo=GenUserHospComp(); //所有医院接口 hisui/websyscomm.js
		HospitalSelect = '_HospUserList'; // _HospUserListLabel	
	}else{
		var hospCombo=GenHospComp(TableName); //登陆权限医院接口
	}
	var hospWidth='300'; // 低于此值会变形
	if($('#' + HospitalSelect).css('width').split('px').length>0){
		tmpHospWidth=$('#' + HospitalSelect).css('width').split('px')[0];
		hospWidth < tmpHospWidth?hospWidth = tmpHospWidth:hospWidth;
	}
	$.extend(hospCombo.jdata.options, {
		width:hospWidth,
		panelWidth:hospWidth,
		onSelect:function(){
  			PUBLIC_CONSTANT.SESSION.HOSPID = hospCombo.getValue();
			var rtn = tkMakeServerCall("web.DHCBILLINSUCloudCommon","SetSessionData",PUBLIC_CONSTANT.SESSION.HOSPID);
  			if (typeof selectHospCombHandle == 'function') {
    			setTimeout("selectHospCombHandle()",100);
    		}	
		},
		onLoadSuccess:function(data){
   			if(defaultHospId!=""){
	   			setValueById(HospitalSelect,defaultHospId);
	   		}else if($(this).combobox('getValue')){
	   			setValueById(HospitalSelect,$(this).combobox('getValue'));
	   		}
   		}
	})
}
// 
function GetURLParam(code) {
   
    var url = location.search; //获取url中"?"符后的字串 
    var theRequest = new Object();
    if (url.indexOf("?") != -1) {
        var str = url.substr(1);
        strs = str.split("&");
        for (var i = 0; i < strs.length; i++) {
            theRequest[strs[i].split("=")[0]] = unescape(strs[i].split("=")[1]);
        }
    }
    return theRequest[code]; 
}