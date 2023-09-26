//页面Event
function InitviewScreenEvent(obj) {
	obj.LoadEvent = function(args){ 
		//查询
		$('#btnQuery').on('click', function(){
			obj.QueryLoad(); //刷新当前页   
		});
		$('#btnPass').on('click', function(){
			obj.btnPass_click();
		});
    }
	obj.btnPass_click = function(){
		$.messager.confirm("提示", "确定过号?", function (r) {
			if (r) {
				var separate="^"
				var LogonLocID=session['LOGON.CTLOCID'];
				var LogonUserID=session['LOGON.USERID'];
				var inStr=LogonLocID+separate+LogonUserID+separate+"1";
				var ret = $m({                  
					ClassName:"DHCMed.DTHService.RepNoSrv",
					MethodName:"SaveDTHRepNo",
					Str:inStr
				},false);
				if(parseInt(ret)<=0){
					$.messager.alert("错误","分号错误!"+ret, 'error');
					return;
				}else{
					$.messager.alert("提示","分号成功!", 'info');
					obj.gridRepNoList.reload();//刷新当前页   
				}
			}
		});
	}
	obj.QueryLoad = function(){
		obj.gridRepNoList.load({
		    ClassName:"DHCMed.DTHService.RepNoSrv",
			QueryName:"QryRepNobyLocID",
			aLoc:$('#cboLoc').combobox("getValue"),
			aHosp:$('#cboSSHosp').combobox("getValue")
	    });		
	}
}