var GLOBAL = {
	MuchHospFlag : '1' // �Ƿ�ʹ�û�������ƽ̨�Ķ�Ժ��   0 �� ������   1������	
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
	var BDPID = GetURLParam("BDPMENU"); // ���ݲ˵�Id ��ȡ�˵�����
	var defaultHospId = GetURLParam("HospId") || '';
	// GetBDPMenuTable
	var TableName=tkMakeServerCall("web.DHCBILLINSUCloudCommon","GetBDPMenuTable",BDPID);
	// ��˵�ȡ�������ã�ȡͷ�˵�����
	var tmpHeadTable = GetURLParam('TableName');
	if(tmpHeadTable != "" && TableName==""){
		TableName = tmpHeadTable;	
	}
	if(location.toString().indexOf('insutarcontrast') > 0 &&  TableName=="" ){
			TableName = 'ALLHospital';
	}
	// ���������Ժ���ؼ� �����
	if ($("#_HospList").length==0){
		$("<tr><td style='text-align:right'><label id='_HospListLabel' style='color:red' class='r-label td-first-col'>ҽԺ</label></td>\
		<td colspan='6'><input id='_HospList' class='textbox' /></td></tr>").prependTo("table:first");
	}
		
	var HospitalSelect = "_HospList";
	// ����ά���������ж��Ƿ���ʾ����ҽԺ
	if(TableName == "ALLHospital"){
		$('#_HospListLabel').attr("id","_HospUserListLabel");
		$('#_HospList').attr("id","_HospUserList");
		var hospCombo=GenUserHospComp(); //����ҽԺ�ӿ� hisui/websyscomm.js
		HospitalSelect = '_HospUserList'; // _HospUserListLabel	
	}else{
		var hospCombo=GenHospComp(TableName); //��½Ȩ��ҽԺ�ӿ�
	}
	var hospWidth='300'; // ���ڴ�ֵ�����
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
   
    var url = location.search; //��ȡurl��"?"������ִ� 
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