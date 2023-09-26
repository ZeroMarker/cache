//===========================================================================================
// 作者：      yangyongtao
// 编写日期:   2019-12-07
// 描述:	   急诊院前出诊记录
//===========================================================================================
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var VisID=""

/// 页面初始化函数
function initPageDefault(){
   InitSystemTime() //初始化系统时间
   
   InitCombobox();
   
   
   if(PhvID!=""){
	 VisID=	PhvID
	 GetPreHosVisInfo(VisID)
   }
}


function InitCombobox(){
	$("#RecUser").combobox({
		url:$URL+"?ClassName=web.DHCEMPreHosVis&MethodName=GetAllUser&LgHospID="+LgHospID,
		valueField:'id',
		textField:'text',
		mode:"remote",
		onSelect:function(option){
	       
	    }	
	})
}

/// 保存急诊科院前出诊记录数据
function SaveHosVis(){
	var PatName = $('#PatName').val();  						/// 病人姓名
	if(PatName==""){
		$.messager.alert("提示:","病人姓名不能为空！","warning");
		return;
	}
	var PatSex = $('#PatSex').val();  							/// 性别
	if(PatSex==""){
		$.messager.alert("提示:","性别不能为空！","warning");
		return;
	}
	var PatAge = $('#PatAge').val(); 							/// 年龄
	if(PatAge==""){
		$.messager.alert("提示:","年龄不能为空！","warning");
		return;
	}
	var VisPlace = $('#VisPlace').val();  						/// 出诊地点
	if(VisPlace==""){
		$.messager.alert("提示:","出诊地点不能为空！","warning");
		return;
	}
	var VisRea = $('#VisRea').val();  							/// 出诊事由
	if(VisRea==""){
		$.messager.alert("提示:","出诊事由不能为空！","warning");
		return;
	}
	var VisDate = $HUI.datebox("#VisDate").getValue();			/// 出诊日期
	var VisTime = $("#VisTime").val(); 							/// 出诊时间	
	var RecUser = $.trim($('#RecUser').combobox("getValue"));  				/// 接通知者	
	var CallerName = $('#CallerName').val();  					/// 呼救者姓名
	var CallerPhone = $('#CallerPhone').val();  				/// 联系电话
	var VisSource = $("input[name='VisSource']:checked").val(); /// 信息来源 
	var CrateUser = LgUserID  // $('#CrateUser').val();    		/// 登记人
	var CrateDate = $HUI.datebox("#CrateDate").getValue();    	/// 登记日期
	var CrateTime = $("#CrateTime").val();  	/// 登记时间
	///             主信息
	var mListData = PatName +"^"+ PatSex +"^"+ PatAge +"^"+ VisPlace +"^"+ VisRea;
    mListData = mListData +"^"+ VisDate +"^"+ VisTime +"^"+ RecUser +"^"+ CallerName +"^"+ CallerPhone;
    mListData = mListData + "^" +VisSource+"^"+ CrateUser +"^"+ CrateDate +"^"+ CrateTime +"^"+LgHospID //hxy 2020-06-04
  
	/// 保存
	runClassMethod("web.DHCEMPreHosVis","Insert",{"VisID":VisID, "mListData":mListData},function(jsonString){
		if (jsonString < 0){
			if(jsonString=="-1001"){
				$.messager.alert("提示:","保存失败，失败原因:接通知日期大于当前日期","warning");
				return;
			}else if(jsonString=="-1002"){
				$.messager.alert("提示:","保存失败，失败原因:接通知时间大于当前时间","warning");
				return;
			}else if(jsonString=="-1003"){
				$.messager.alert("提示:","保存失败，失败原因:接通知日期大于创建日期","warning");
				return;
			}else if(jsonString=="-1004"){
				$.messager.alert("提示:","保存失败，失败原因:接通知时间大于创建时间","warning");
				return;
			}else{
				$.messager.alert("提示:","保存失败，失败原因:"+jsonString,"warning");
			}
		}else{
			VisID=jsonString
			$.messager.alert("提示:","保存成功！","info",function(){
				window.location.reload();
				if (window.opener){
					window.opener.QryDisAmbMan()
					CancelHosVis() //关闭
				}	
			});
		}
	},'',false)
}


/// 急诊院前出诊记录
function GetPreHosVisInfo(VisID){
	runClassMethod("web.DHCEMPreHosVis","GetPreHosVisInfo",{"VisID":VisID},function(jsonString){
		var jsonObject = jsonString;
		if (jsonObject != null){
			$('#PatName').val(jsonObject.PatName);  						/// 病人姓名
			$('#PatSex').val(jsonObject.PatSex);  							/// 性别
			$('#PatAge').val(jsonObject.PatAge); 							/// 年龄
			$('#VisPlace').val(jsonObject.VisPlace);  						/// 出诊地点
			$('#VisRea').val(jsonObject.VisRea);  							/// 出诊事由
			$HUI.datebox("#VisDate").setValue(jsonObject.VisDate);			/// 出诊日期
			$("#VisTime").val(jsonObject.VisTime); 							/// 出诊时间	
			$('#RecUser').combobox("setValue",jsonObject.RecUserID);  		/// 接通知者	
			$('#CallerName').val(jsonObject.CallerName);  					/// 呼救者姓名
			$('#CallerPhone').val(jsonObject.CallerPhone);  				/// 联系电话
			$HUI.radio("input[name='VisSource']").setValue(false);
			if (jsonObject.VisSource != ""){
				$HUI.radio("input[name='VisSource'][value='"+ jsonObject.VisSource +"']").setValue(true);
			}
			$("input[name='VisSource']:checked").val(); 					/// 信息来源 
			$('#CrateUser').val(jsonObject.CrateUser);    					/// 登记人
			$HUI.datebox("#CrateDate").setValue(jsonObject.CrateDate);    	/// 登记日期
			$("#CrateTime").val(jsonObject.CrateTime);  					/// 登记时间
		}
	},'json',false)
}


///  效验时间栏录入数据合法性
function CheckEmPcsTime(id){

	var InTime = $('#'+ id).val();
	InTime=InTime.replace(/\D/g,'')
	if (InTime == ""){return "";}
	
	if (InTime.length < 4){InTime = "0" + InTime;}
	if (InTime.length != 4){
		$.messager.alert("提示:","请录入正确的时间格式！<span style='color:red;'>例如:18:23,请录入1823</span>");
		$('#'+ id).val("");
		return "";
	}
	
	var hour = InTime.substring(0,2);
	if (hour > 23){
		$.messager.alert("提示:","小时数不能大于23！");
		$('#'+ id).val("");
		return "";
	}
	
	var itme = InTime.substring(2,4);
	if (itme > 59){
		$.messager.alert("提示:","分钟数不能大于59！");
		$('#'+ id).val("");
		return "";
	}
	
	return hour +":"+ itme;
}

/// 初始化系统时间
function InitSystemTime(){
	
	runClassMethod("web.DHCEMPreHosVis","GetSystemTime",{},function(jsonObject){
		if (jsonObject != null){
			$HUI.datebox("#VisDate").setValue(jsonObject["SystemDate"]); /// 出诊日期
			$("#VisTime").val(jsonObject["SystemTime"]); /// 出诊时间
		}
	},'json',false)
}

/// 获取焦点后时间栏设置
function SetEmPcsTime(id){
	
//	var InTime = $('#'+ id).val();
//	if (InTime == ""){return "";}
//	InTime = InTime.replace(":","");
	return "";
}

//取消
function CancelHosVis(){
	window.close();
}
/// 内容为 undefined 显示空
function txtUtil(txt){
	
	return (typeof txt == "undefined")?"":txt;
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
