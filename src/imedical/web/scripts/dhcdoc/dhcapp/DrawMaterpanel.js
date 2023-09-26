var DrawMaterpanel=(function(){
	function Init(){
		InitPageComponent();
		/// 取材医生		
		if (ServerObj.DefualtDoc=="1"){
			$('#DocDr').combobox("setValue",session['LOGON.USERID']);
			$('#DocDr').combobox("setText",session['LOGON.USERNAME']);
		}
		/// 取材科室
		$('#LocID').combobox("setValue",session['LOGON.CTLOCID']);
	}
	/// 初始化界面控件内容
	function InitPageComponent(){
		/// 取材科室 
		$('#LocID').combobox({	//取材科室和取材医生可以选择
			mode:'remote',  
			url:LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=SelAllLoc&&hospId="+LgHospID,
			blurValidValue:true,
			onSelect:function(){	//设置级联 选择科室后，加载可以登录该科室的医生
				$("#DocDr").combobox("setValue","");
				$("#DocDr").combobox('reload');
			}
		});
		/// 取材医生 
		$('#DocDr').combobox({
			blurValidValue:true,
			url:LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=QueryDoc&LocID=",	
			onShowPanel:function(){
				var bLocID=$('#LocID').combobox('getValue');			
				var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=QueryDoc&LocID="+bLocID;
				$("#DocDr").combobox('reload',unitUrl);
			}
		});	
	}
	function OtherInfo(){
		return ""
	}
	function PrintInfo(){
		return ""
	}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
	}
	   
})();