var HPVFoundPanel=(function(){
	function Init(){
		/// 取材科室 
		$('#LocID').combobox({	//取材科室和取材医生可以选择 2018/2/2 qunianpeng 
			mode:'remote',  
			url:LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=SelAllLoc&&hospId="+LgHospID,
			blurValidValue:true,
			onShowPanel:function(){
				// var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=SelAllLoc&&hospId="+LgHospID;
				// $("#LocID").combobox('reload',unitUrl);
			},
			onSelect:function(){	//设置级联 选择科室后，加载可以登录该科室的医生 qunianpeng 2018/2/7
				$("#DocDr").combobox("setValue","");
				$("#DocDr").combobox('reload');
			}
		});
		/// 取材医生 
		$('#DocDr').combobox({
			//mode:'remote',
			blurValidValue:true,
			url:LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=QueryDoc&LocID=",	
			onShowPanel:function(){
				var bLocID=$('#LocID').combobox('getValue');			
				var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=QueryDoc&LocID="+bLocID;
				$("#DocDr").combobox('reload',unitUrl);
			}
		});	
		/// 首次发现人乳头瘤病毒时间
		$('#FoundDate').datebox().datebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				return date<=now;
			}
		});
		/// 取材医生				
		if (ServerObj.DefualtDoc=="1"){$('#DocDr').combobox("setValue",session['LOGON.USERID']);}
			
		/// 取材科室
		$('#LocID').combobox("setValue",session['LOGON.CTLOCID']);
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