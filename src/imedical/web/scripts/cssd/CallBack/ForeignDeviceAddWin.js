var AddWin=function(Fn){
	//请求科室
	var typeDetial=""
	var PackageBox = $HUI.combobox('#InstruName', {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackage&ResultSetType=array&typeDetial=' + typeDetial+'&packageClassName='+packageClassDr,
			valueField: 'RowId',
			textField: 'Description',
			onSelect:function(record){
				var pkgDr= record['RowId'];
				getCodeDictData(pkgDr);
			}
	});
	function getCodeDictData(PkgDr){
		$("#InstruCode").combobox('clear');
		$("#InstruCode").combobox('reload',
		$URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCodeDict&ResultSetType=array&PkgDr='+PkgDr);
		
	}
	var Dafult={
		RecDate:DefaultEdDate(),
		UseDate:DefaultEdDate(),
		OperatorType:2
	}
	var CodeDictBox = $HUI.combobox('#InstruCode', {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCodeDict&ResultSetType=array&PkgDr=""',
			valueField: 'RowId',
			textField: 'Description'
	});
	var ReqLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var ReqLocBox = $HUI.combobox('#ExtLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ReqLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function (data) {   //默认登录科室
			//$("#FReqLoc").combobox('setValue',gLocId);
		}
	});
	var FirmBox = $HUI.combobox('#Firm', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetFirm&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onSelect:function(record){
			var RowId= record['RowId'];
			getFirmData(RowId);
		}
	});
	function getFirmData(RowId){
		var Ret = tkMakeServerCall('web.CSSDHUI.Common.Dicts', 'GetFirmInfo',RowId);
        if(!isEmpty(Ret)){
            $("#SerMan").val(Ret.split('^')[0]);
            $("#Tel").val(Ret.split('^')[1]);
            $("#Receipt").focus();
        }else{
            $UI.msg('alert','未找到厂商相关信息!');
            $("#Receipt").focus();
        }
	}
	
	//接收人回车操作
    $("#RecMan").keypress(function(event) {
		var curKey = event.which;
		if(curKey == 13) {
			if($("#RecMan").val() != "") {
				$.m({
					ClassName: "web.CSSDHUI.Clean.CleanInfo",
					MethodName: "GetCleanUser",
					cleanCode: $("#RecMan").val()
				}, function(txtData) {
					if(txtData != null && !isEmpty(txtData)) {
						var arr = txtData.split('^');
						$("#RecMan").val(arr[1]);
						$("#RecManDr").val(arr[0]);
						$("#RecNum").focus();
					} else {
						$UI.msg('alert', '未找到相关信息!');
						$("#RecMan").val("");
						$("#RecManDr").val("");
						$("#RecMan").focus();
						return;
					}
				})
			}
		}
    });
	$UI.clearBlock('#SelBarCodeConditions');
	$UI.fillBlock('#AddWin',Dafult);
	$HUI.dialog('#AddWin').open();
	$UI.linkbutton('#CancelBT',{
		onClick:function(){
			$HUI.dialog('#AddWin').close();
		}
	});
	var Implants="";
	$HUI.radio("[name='Implants']",{
		onChecked:function(e,value){
			Implants = $(e.target).attr("value");  //输出当前选中的value值
		}
	});
	var PatientSex="";
	$HUI.radio("[name='PatientSex']",{
		onChecked:function(e,value){
			PatientSex = $(e.target).attr("value");  //输出当前选中的value值
		}
	});
	$UI.linkbutton('#AddSaveBT',{
		onClick:function(){
			var ParamsObj =$UI.loopBlock('#SelBarCodeConditions');
			ParamsObj.PatientSex=PatientSex;
			var Params=JSON.stringify(ParamsObj);
			if($("#InstruName").combobox('getValue')==""){
				$UI.msg('alert', '请选择消毒包！');
				$('#InstruName').focus();
				return ;
			}
			if($("#InstruCode").combobox('getValue')==""){
				$UI.msg('alert', '请选择消毒包代码！');
				$('#InstruCode').focus();
				return ;
			}
			var InstruNum = $("#InstruNum").val();
			if(isEmpty(InstruNum)||InstruNum<=0){
				$UI.msg('alert', '请输入器械数量！');
				$(InstruNum).numberbox("setValue","");
				$('#InstruNum').focus();
				return ;
			}
			if(Implants==""){
				$UI.msg('alert', '请选择是否有植入物！');
				$('#Implants').focus();
				return ;
			}
			if($("#Firm").combobox('getValue')==""){
				$UI.msg('alert', '请选择厂商！');
				$('#Firm').focus();
				return ;
			}
			if($("#HospitalNo").val()==""){
				$UI.msg('alert', '请输入住院登记号！');
				$('#HospitalNo').focus();
				return ;
			}
			if($("#RecMan").val()==""){
				$UI.msg('alert', '请输入接收人！');
				$('#RecMan').focus();
				return ;
			}
			if($("#RecNum").val()==""){
				$UI.msg('alert', '请输入接收数量！');
				$('#RecNum').focus();
				return ;
			}
			
			$.cm({
				ClassName: 'web.CSSDHUI.PackageCallBack.ForeignDeviceRegister',
				MethodName: 'jsSave',
				Params: Params
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					$HUI.dialog('#AddWin').close();
					Fn();
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
			
		}
	});
}
