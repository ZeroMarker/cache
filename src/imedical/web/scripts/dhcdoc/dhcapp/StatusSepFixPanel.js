var StatusSepFixPanel=(function(){
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
		$('#LocID').combobox({	//取材科室和取材医生可以选择 2018/2/2 qunianpeng 
			mode:'remote',  
			url:LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=SelAllLoc&&hospId="+LgHospID,
			blurValidValue:true,
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
		/// 标本离体时间控制
		$('#SepDate').datetimebox({
			onHidePanel:function (){
				var SepDate = $HUI.datetimebox("#SepDate").getValue(); /// 离体时间
				var FixDate = $HUI.datetimebox("#FixDate").getValue(); /// 固定时间
				if (FixDate != ""){
					var SepDate=parseDateTime(SepDate);
					var FixDate=parseDateTime(FixDate)
					if (SepDate >= FixDate){
						$.messager.alert("提示:","标本固定时间不能早于标本离体时间！");
						$('#SepDate').datetimebox('setValue',"");
						return;
					}
				}
				return true;    
			}
		});
		
		/// 标本固定时间控制
		$('#FixDate').datetimebox({
			onHidePanel:function (){
				var SepDate = $HUI.datetimebox("#SepDate").getValue(); /// 离体时间
				var FixDate = $HUI.datetimebox("#FixDate").getValue(); /// 固定时间
				if (SepDate != ""){
					var FixDate=parseDateTime(FixDate);
					var SepDate=parseDateTime(SepDate)
					if (FixDate < SepDate){
						$.messager.alert("提示:","标本固定时间不能早于标本离体时间！");
						$HUI.datetimebox("#FixDate").setValue("");
						return;
					}
				}
				return true;
			}
		});
		
		/// 标本离体时间控制
		$('#SepDate').datetimebox().datetimebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				return date<=now;
			}
		});
		
		/// 标本固定时间控制
		$('#FixDate').datetimebox().datetimebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				return date<=now;
			}
		});	
	}
	function parseDateTime(dateStr){
		var regexDT = /(\d{4})-?(\d{2})?-?(\d{2})?\s?(\d{2})?:?(\d{2})?:?(\d{2})?/g;
	    var matchs = regexDT.exec(dateStr);
	    if(matchs==null){
			return new Date();    
		}
	    var date = new Array();
	    for (var i = 1; i < matchs.length; i++) {
	        if (matchs[i]!=undefined) {
	            date[i] = matchs[i];
	        } else {
	            if (i<=3) {
	                date[i] = '01';
	            } else {
	                date[i] = '00';
	            }
	        }
	    }
		return new Date(date[1], date[2]-1, date[3], date[4], date[5],date[6]);    
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