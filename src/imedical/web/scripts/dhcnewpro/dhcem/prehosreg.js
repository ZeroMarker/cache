//===========================================================================================
// 作者：      yangyongtao
// 编写日期:   2019-12-07
// 描述:	   急诊院前登记记录
//===========================================================================================
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgUserName= session['LOGON.USERNAME']/// 用户姓名
var del = String.fromCharCode(2);
var RegID=""
/// 页面初始化函数
function initPageDefault(){
   InitSystemTime() //初始化系统时间
   if(MaID!=""){
	 GetPreHosRegInfo(MaID)
   }
   if(PhvID!=""){
	  GetPreHosVisInfo(PhvID) 
	}
    /// 登记号
	$("#PatNo").bind('keypress',PatNo_KeyPress);
}
/// 登记号
function PatNo_KeyPress(e){
	
	var PatNo = $("#PatNo").val();
	if(e.keyCode == 13){
		if (!PatNo.replace(/[\d]/gi,"")&(PatNo != "")){
			///  登记号补0
			var PatNo = GetWholePatNo(PatNo);
			$("#PatNo").val(PatNo);
			GetPatBaseInfo(PatNo);  /// 查询
		}
	}
}

/// 病人就诊信息
function GetPatBaseInfo(PatNo){
	runClassMethod("web.DHCEMDisAmbMan","GetPatBaseInfo",{"PatientNo":PatNo,"LgHospID":LgHospID},function(jsonString){
		var jsonObject = jsonString;
	        if(jsonObject.ErrCode<0){
			$.messager.alert('提示',""+jsonObject.ErrMsg);
			return;		
		}
		if (JSON.stringify(jsonObject) != '{}'){
			$('.td-span-m').each(function(){
				$(this).val(jsonObject[this.id]);
			})
			$("#EpisodeID").text(jsonObject["EpisodeID"])
		}else{
			$.messager.alert('错误提示',"病人信息不存在或病人非留观病人，请核实后重试！");
			return;	
		}
	},'json',false)
}
///补0病人登记号
function GetWholePatNo(EmPatNo){

	///  判断登记号是否为空
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  登记号长度值
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatRegNoLen",{},function(jsonString){

		var patLen = jsonString;
		var plen = EmPatNo.length;
		if (EmPatNo.length > patLen){
			$.messager.alert('错误提示',"登记号输入错误！");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;

}


/// 保存急诊科院前登记数据
function SaveHosReg(){
	
	
	var RegID=$("#RegID").text(); /// 登记ID
	var EpisodeID=$('#EpisodeID').text(); /// 就诊ID
	var ArrDate = $HUI.datebox("#ArrDate").getValue();			/// 到达日期
	var ArrTime = $("#ArrTime").val(); 							/// 到达时间
	var BackDate = $HUI.datebox("#BackDate").getValue();		/// 返院日期
	var BackTime = $("#BackTime").val(); 						/// 返院时间
	var DepartDate = $HUI.datebox("#DepartDate").getValue();	/// 出诊日期
	var DepartTime = $("#DepartTime").val(); 					/// 出诊时间
		
	var CrateUser = LgUserID  // $('#CrateUser').val();    		/// 登记人
	var CrateDate = $HUI.datebox("#CrateDate").getValue();    	/// 登记日期
	var CrateTime = $("#CrateTime").val();  	/// 登记时间
	///             主信息
	var mListData = EpisodeID +"^"+ CrateUser +"^"+ MaID+"^"+ PhvID
    
    if(ArrDate!=""){ /// 到达日期
	   ArrDate="ArrDate"+"^"+ArrDate  
	}
	if(ArrTime!=""){ /// 到达时间
	   ArrTime="ArrTime"+"^"+ArrTime  
	}
	
	if(DepartDate!=""){ /// 出诊日期
	   DepartDate="DepartDate"+"^"+DepartDate  
	}
	if(DepartTime!=""){ /// 出诊时间
	   DepartTime="DepartTime"+"^"+DepartTime  
	}
	if(BackDate!=""){ /// 返院时间
	   BackDate="BackDate"+"^"+BackDate  
	}
	if(BackTime!=""){ /// 返院日期
	   BackTime="BackTime"+"^"+BackTime  
	}
	
    
    var ItemData= ArrDate +"@"+ ArrTime +"@"+ DepartDate +"@"+ DepartTime +"@"+ BackDate +"@"+ BackTime
    var mListData=mListData +del+ ItemData
	/// 保存
	runClassMethod("web.DHCEMPreHosReg","Insert",{"RegID":RegID, "mListData":mListData},function(jsonString){
		if (jsonString < 0){
			if(jsonString=="-1001"){
				$.messager.alert("提示:","保存失败，到达时间不能大于当前时间！");	
			}else if(jsonString=="-1002"){
				$.messager.alert("提示:","保存失败，返回时间不能大于当前时间！");	
			}else if(jsonString=="-1003"){
				$.messager.alert("提示:","保存失败，返回时间不能早于到达时间！");	
			}else{
				$.messager.alert("提示:","保存失败，失败原因:"+jsonString,"warning");
			}
		}else{
			RegID=jsonString
			$.messager.alert("提示:","保存成功！","info",function(){
				window.location.reload();
				if (window.opener){
					window.opener.QryDisAmbMan()
					CancelHosReg() //关闭
				}	
			});
		}
	},'',false)
}


/// 急诊院前登记
function GetPreHosRegInfo(MaID){
	runClassMethod("web.DHCEMPreHosReg","GetPreHosRegInfo",{"MaID":MaID},function(jsonString){
		var jsonObject = jsonString;
		if (jsonObject != null){
			
			$HUI.datebox("#DepartDate").setValue(jsonObject.DepartDate);	/// 出诊日期
			$("#DepartTime").val(jsonObject.DepartTime); 					/// 出诊时间
			
			$HUI.datebox("#ArrDate").setValue(jsonObject.ArrDate);			/// 到达日期
			$("#ArrTime").val(jsonObject.ArrTime); 							/// 到达时间
			
			$HUI.datebox("#BackDate").setValue(jsonObject.BackDate);		/// 返院日期
			$("#BackTime").val(jsonObject.BackTime); 						/// 返院时间	
				
			$('#CrateUser').val(jsonObject.CreateUser);    					/// 登记人
			$HUI.datebox("#CrateDate").setValue(jsonObject.CreateDate);    	/// 登记日期
			$("#CrateTime").val(jsonObject.CreateTime);  					/// 登记时间
			$("#RegID").text(jsonObject.RegID)
		}
	},'json',false)
}

/// 急诊院前出诊记录
function GetPreHosVisInfo(VisID){
	runClassMethod("web.DHCEMPreHosVis","GetPreHosVisInfo",{"VisID":VisID},function(jsonString){
		var jsonObject = jsonString;
		if (jsonObject != null){
			$('#PatNo').val(jsonObject.PatNo);
			$('#PatName').val(jsonObject.PatName);  						/// 病人姓名
			$('#PatSex').val(jsonObject.PatSex);  							/// 性别
			$('#PatAge').val(jsonObject.PatAge); 							/// 年龄
			if(jsonObject.PatNo!=""){
				$('#PatNo').attr("disabled", true);
			}else{
				$('#PatNo').attr("disabled", false);	
			}	
		}
	},'json',false)
}

//取消关联
function CancelRelReg(){
	
	runClassMethod("web.DHCEMPreHosReg","CancelRelAdm",{"RegID":RegID},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示:","取消关联失败，失败原因！"+jsonString,"warning");
			return;
		}
		if (jsonString == 0){
			$.messager.alert("提示:","取消关联成功！","info",function(){
				window.location.reload();
				if (window.opener){
					window.opener.QryDisAmbMan()
					CancelHosReg() //关闭
				}	
			});
		}
		
	},'',false)	
	
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
			$HUI.datebox("#ArrDate").setValue(jsonObject["SystemDate"]); /// 出诊日期
			$("#ArrTime").val(jsonObject["SystemTime"]); /// 出诊时间
			$HUI.datebox("#DepartDate").setValue(jsonObject["SystemDate"]); /// 到达日期
			$("#DepartTime").val(jsonObject["SystemTime"]); /// 到达时间
			$HUI.datebox("#BackDate").setValue(jsonObject["SystemDate"]); /// 返回日期
			$("#BackTime").val(jsonObject["SystemTime"]); /// 返回时间
			
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
function CancelHosReg(){
	window.close();
}

/// 内容为 undefined 显示空
function txtUtil(txt){
	
	return (typeof txt == "undefined")?"":txt;
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
