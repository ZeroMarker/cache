//CF.BSP.CA.SignModel.js
var ClassName = "CF.BSP.CA.DTO.SignModel";
var getData = function(){
	var data = {};
	data["dto.entiy.SMActive"]=getValueById("SMActive")?1:0;
	data["dto.entiy.SMCode"]=getValueById("SMCode");
	data["dto.entiy.SMDesc"]=getValueById("SMDesc");
	data["dto.entiy.SMForceOpen"]=getValueById("SMForceOpen")?1:0;
	data["dto.entiy.SMSingleLogon"]=getValueById("SMSingleLogon")?1:0;
	data["dto.entiy.SMProductor"]=getValueById("SMProductor");
	data["dto.entiy.SMBizSysCode"]=getValueById("SMBizSysCode");
	data["dto.entiy.SMHospDr"]=getValueById("SingleHospId");
	return data;
};
var clearData = function(){
	var data = {};
	setValueById("SMID","");
	setValueById("SMActive",false);
	setValueById("SMCode","");
	setValueById("SMDesc","");
	setValueById("SMForceOpen",false);
	setValueById("SMSingleLogon",false);
	setValueById("SMProductor","");
	setValueById("SMBizSysCode","");
	return data;
};
var defaultCallBack = function(rtn){
	if (rtn.success==1){
		if (rtn.gridId!=""){
			$('#'+rtn.gridId).datagrid('load');
		}
		$("#Clean").click();
		$.messager.popover({msg:rtn.msg,type:'success'});
	}else{
		$.messager.popover({msg:rtn.msg,type:'error'});
	}
}
function init(){
	$(".textbox").keydown(function(event){
		if(event.keyCode==13){
			$('#Find').trigger('click');
		};
	});
	$("#Ins").click(function(){
		var data = getData();
		if (data["dto.entiy.SMCode"]==""){
			$.messager.popover({msg: 'È±Ê§´úÂë',type:'alert',timeout: 2000});
			return ;
		}
		if (data["dto.entiy.SMDesc"]==""){
			$.messager.popover({msg: 'È±Ê§ÃèÊö',type:'alert',timeout: 2000});
			return ;
		}
		$cm($.extend({
			ClassName:ClassName,
			MethodName:"Insert",
			"dto.gridId":"tCF_BSP_CA_SignModel"
		},data),defaultCallBack);
	});
	$("#Save").click(function(){
		var data = {};
		var id = getValueById("SMID");
		if (id>0){
			var data = getData();
			data["dto.entiy.id"]=id;
			$cm($.extend({
				ClassName:ClassName,
				MethodName:"Update",
				"dto.gridId":"tCF_BSP_CA_SignModel"
			},data),defaultCallBack)
		}else{
			$.messager.popover({msg: 'È±Ê§ID',type:'alert',timeout: 2000});
			return ;
		}
	});
	$("#Clean").click(function(){
		clearData();
	});
	$("#Del").click(function(){
		var data = {};
		var id = getValueById("SMID");
		if (id>0){
			$.messager.confirm("É¾³ý", "È·ÈÏÉ¾³ý "+getValueById("SMDesc")+" ¼ÇÂ¼Âð?", function (r) {
				if (r) {
					data["dto.entiy.id"]=id;
					$cm($.extend({
						ClassName:ClassName,
						MethodName:"Del",
						"dto.gridId":"tCF_BSP_CA_SignModel"
					},data),defaultCallBack)
				}
			});
		}else{
			$.messager.popover({msg: 'È±Ê§ID',type:'alert',timeout: 2000});
			return ;
		}
	});
	$("#SMLogonTypeList").combobox({
		valueField:'Code',
		textField:'Code',
		multiple:true,
		rowStyle:'checkbox', //ÏÔÊ¾³É¹´Ñ¡ÐÐÐÎÊ½
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		mode:'remote',
		url:$URL+"?ClassName="+ClassName+"&QueryName=LookUpCALogonType&ResultSetType=array"
	});
	$("#tCF_BSP_CA_SignModel").datagrid("options").onClickRow = function(ind,row){
		var target = event.target||event.srcElement;
		if (target.tagName.toLowerCase()!="a"){
			for(var i in row){
				setValueById(i.slice(1),row[i]);
			}
		}
	}
	var obj = document.getElementById("SingleHospId");
	var comp = GenUserHospComp({defaultValue:obj.value||(session&&session['LOGON.HOSPID'])});
	comp.options().onSelect = function(ind,row){
		//var curHospCode = row["HOSPCode"];
		var obj = document.getElementById("SingleHospId");
		if (obj){
			obj.value = row["HOSPRowId"];
			$('#Find').trigger('click');
		}
	}
}
$(init);

websys_lu_bak = websys_lu;
websys_lu = function(url,flag,opt){
	if (url.indexOf("iTSMCfgJson")>-1){
		var RowId = url.match(/TSMID=(.+?)&/)[1];
		var Code = url.match(/TSMCode=(.+?)&/)[1];
		websys_createWindow("websys.default.hisui.csp?WEBSYS.TCOMPONENT=CF.BSP.CA.SignModelParam&SMID="+RowId+"&SMCode="+Code);
		return false;
	}else{
		websys_lu_bak(url,flag,opt);
	}
}
