var ZHLPanel=(function(){
	function Init(){
		InitPageComponent();
		GetPatBaseInfo();
		}
	/// 初始化界面控件内容
	function InitPageComponent(){

		/// 取材日期控制
		$('#SepDate').datetimebox().datetimebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				return date<=now;
			}
		});
		
		/// 上次月经日期控制
		$('#LastMensDate').datebox().datebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				return date<=now;
			}
		});
		
		/// 末次月经日期控制
		$('#MensDate').datebox().datebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				return date<=now;
			}
		});
		
		/// 上次月经日期控制
		$('#LastMensDate').datebox({
			onSelect: function(date){
				var MensDate = $HUI.datebox("#MensDate").getValue(); /// 末次月经
				if (MensDate != ""){
					var LastMensDate = $HUI.datebox("#LastMensDate").getValue(); /// 上次月经
					if (isCompare(LastMensDate, MensDate) == 1){
						$.messager.alert("提示:","【上次月经日期】不能大于等于【末次月经日期】！");
						$('#LastMensDate').datebox('setValue',"");
						return;
					}
				}else{
					$HUI.checkbox("#PauFlag").setValue(false);  /// 绝经
				}
				return true;
			}
		});
		
		/// 末次月经日期控制
		$('#MensDate').datebox({
			onSelect: function(date){
				var LastMensDate = $HUI.datebox("#LastMensDate").getValue(); /// 上次月经
				if (LastMensDate != ""){
					//var LastMensDate = new Date(LastMensDate.replace(/\-/g, "\/"));
					var MensDate = $HUI.datebox("#MensDate").getValue(); /// 末次月经
					if (isCompare(LastMensDate, MensDate) != 0){
						$.messager.alert("提示:","【末次月经日期】不能小于等于【上次月经日期】！");
						$('#MensDate').datebox('setValue',"");
						return;
					}
				}else{
					$HUI.checkbox("#PauFlag").setValue(false);  /// 绝经
				}
				return true;
			}
		});
		
		/// 胎数
		$("#PreTimes").keyup(function(){
		    var PreTimes = $("#PreTimes").val();  /// 胎数
		    var LyTimes = $("#LyTimes").val();    /// 产数
		    if ((LyTimes != "")&(PreTimes < LyTimes)){
			    $.messager.alert("提示:","胎数必须大于等于产数！");
				$("#PreTimes").val("");
			}
		});
		
		/// 产数
		$("#LyTimes").keyup(function(){
		    var PreTimes = $("#PreTimes").val();  /// 胎数
		    var LyTimes = $("#LyTimes").val();    /// 产数
		    if ((LyTimes != "")&(PreTimes < LyTimes)){
			    $.messager.alert("提示:","胎数必须大于等于产数！");
				$("#LyTimes").val("");
			}
		});
		
		/// 取材科室 
		$('#LocID').combobox({	//取材科室和取材医生可以选择 2018/2/2 qunianpeng 
			url:LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=SelAllLoc&&hospId="+LgHospID,
			mode:'remote',  
			onShowPanel:function(){
				var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=SelAllLoc&&hospId="+LgHospID;
				$("#LocID").combobox('reload',unitUrl);
			},
			onSelect:function(){	//设置级联 选择科室后，加载可以登录该科室的医生 qunianpeng 2018/2/7
				$("#DocDr").combobox("setValue","");
				$("#DocDr").combobox('reload');
			}
		});
		
		/// 取材医生 
		$('#DocDr').combobox({
			//mode:'remote',  
			url:LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=QueryDoc&LocID=",
			onShowPanel:function(){
				var bLocID=$('#LocID').combobox('getValue');	
				var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=QueryDoc&LocID="+bLocID;
				$("#DocDr").combobox('reload',unitUrl);
			}
		});	
		
	}
	/// 病人就诊信息
	function GetPatBaseInfo(){
		runClassMethod("web.DHCAppPisMasterQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID, "LocID":session['LOGON.CTLOCID'], "UserID":session['LOGON.USERID']},function(jsonString){
			if (PisID == ""){
				/// 取材医生
				if (ServerObj.DefualtDoc=="1"){$('#DocDr').combobox("setValue",session['LOGON.USERID']);}
				/// 取材科室
				$('#LocID').combobox("setValue",session['LOGON.CTLOCID']);
			}

		},'json',false)
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