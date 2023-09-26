var tPanel=(function(){
	function Init(){
		/// 接收科室
		var option = {
			panelHeight:"auto",
			blurValidValue:true,
			onSelect:function(option){
			},
			onShowPanel:function(){
				var itmmastid = $("#TesItemID").val();
				if (itmmastid != ""){
					var OpenForAllHosp=0,LogLoc="";
					var OrderOpenForAllHosp=parent.$HUI.checkbox("#OrderOpenForAllHosp").getValue();
					var FindByLogDep=parent.$HUI.checkbox("#FindByLogDep").getValue();
					if (OrderOpenForAllHosp==true){OpenForAllHosp=1}
					if (FindByLogDep==true){LogLoc=session['LOGON.CTLOCID']}
					var unitUrl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=jsonExaCatRecLocNew&EpisodeID="+ EpisodeID +"&ItmmastID="+itmmastid+"&OrderDepRowId="+LogLoc+"&OpenForAllHosp="+OpenForAllHosp;
					$("#recLoc").combobox('reload',unitUrl);
				}
			}
		}
		new ListCombobox("recLoc",'','',option).init();
		
			/// 申请科室 
		$('#ApplyLoc').combobox({	//申请科室和申请医生可以选择(默认就诊医生和科室) 2018/2/5 qunianpeng
			url:LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=SelAllLoc&&hospId="+LgHospID,
			mode:'remote',	
			//blurValidValue:true,		
			onShowPanel:function(){
				//var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=SelAllLoc&hospId="+LgHospID;
				//$("#ApplyLoc").combobox('reload',unitUrl);
			},
			onSelect:function(){	//设置级联 选择科室后，加载可以登录该科室的医生 qunianpeng 2018/2/7
				$("#ApplyDocUser").combobox("setValue","");
				$("#ApplyDocUser").combobox('reload');
			}
		});
		
		/// 申请医生  
		$('#ApplyDocUser').combobox({
			//mode:'remote',
			url:LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=QueryDoc&LocID=",
			blurValidValue:true,		
			onShowPanel:function(){
				var appLocID=$('#ApplyLoc').combobox('getValue');
				var unitUrl = LINK_CSP+"?ClassName=web.DHCAppPisMasterQuery&MethodName=QueryDoc&LocID="+appLocID;
				$("#ApplyDocUser").combobox('reload',unitUrl);
			}
		});	
		/// 申请医生	
		$('#ApplyDocUser').combobox("setValue",session['LOGON.USERID']);
		/// 申请科室
		$('#ApplyLoc').combobox("setValue",session['LOGON.CTLOCID']);
		$HUI.checkbox("#EmgFlag", {
			onCheckChange:function(event,value){
				if (value == true){
					$HUI.checkbox("#FrostFlag").setValue(false);  /// 冰冻
				}
			}
		})
		$HUI.checkbox("#FrostFlag", {
			onCheckChange:function(event,value){
				if (value == true){
					$HUI.checkbox("#EmgFlag").setValue(false);   
					//$("#OperCon").show(); 
					//$(".datagrid-header-row ").find(".datagrid-cell-c1-SepDate").text("预约时间")  					 
				}else{
					//$("#OperCon").hide();  
					//$(".datagrid-header-row ").find(".datagrid-cell-c1-SepDate").text("离体时间")   
				}
			}
		})
		GetPatBaseInfo();
	}
	/// 病人就诊信息
	function GetPatBaseInfo(){
		runClassMethod("web.DHCAppPisMasterQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID, "LocID":session['LOGON.CTLOCID'], "UserID":session['LOGON.USERID'] },function(jsonString){
			var jsonObject = jsonString;
			if (jsonObject.PatSex == "男"){
				$("label:contains('妇科信息')").parent().hide();
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