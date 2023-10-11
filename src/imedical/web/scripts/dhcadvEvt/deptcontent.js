/// Description: 医务部审核界面
/// Creator: yangyongtao
/// CreateDate: 2019-03-27
var nowDate=formatDate(0); //系统的当前日期
var EvaRecordId="",LinkRecordId="",WinCode=""; //AuditList="",CancelAuditList="",StaFistAuditUser="",StsusGrant="",RepStaus="";
var userName="";
$(document).ready(function(){
	$.messager.defaults = { ok: $g("确定"),cancel: $g("取消")};
	EvaRecordId=getParam("recordId");  //表单类型id
	LinkRecordId=getParam("LinkRecordId");  //关联表单记录ID
	//AuditList=getParam("AuditList");  //审核串
	//CancelAuditList=getParam("CancelAuditList");  //撤销审核串
	//StaFistAuditUser=getParam("StaFistAuditUser");  //第一审批人
	//StsusGrant=getParam("StsusGrant");  //审核标识
	//RepStaus=getParam("RepStaus");  //报告状态
	WinCode=getParam("code");  //关联表单记录code
	$("#AsseSaveBut").on("click",function(){
		SaveAsse();
	})
 
	$("#left-nav").hide();
	$("#anchor").hide();
	$("#gotop").hide();
	$("#gologin").hide();
	$("#footer").hide();
	$("#assefooter").show();
	$("#from").css({
		"margin-left":"20px",
		"margin-right":"20px"
	});
	
	getInfo(0);

});
//报告评价保存
function SaveAsse(flag)
{
	 ///保存前,对页面必填项进行检查
	if(!(checkRequired())){
		return;
	} 
	
	var msg=checkTableRequired();
	if(msg!=""){
		return;
	}
	runClassMethod("web.DHCADVFormRecord","SaveRecord",
		{'user':LgUserID,
		 'formId':$("#formId").val(),
		 'formVersion':$("#formVersion").val(),
		 'par':loopStr("#from"),
		 'recordId':EvaRecordId,
		 'linkRecordId':LinkRecordId
		 },
		function(datalist){ 
			var data=datalist.replace(/(^\s*)|(\s*$)/g,"").split("^");
			if (data[0]=="0") {
				window.parent.closeDeptConWindow();

			}else{
				$.messager.alert($g("提示:"),$g("保存失败"));
				return;
			}
		},"text")
			
}
//增加
function add_event(){
	getInfo(1);
}

//获取当前登录用户和日期
function getInfo(flag){
	// 获取登录人 信息
	runClassMethod("web.DHCADVCOMMONPART","GetRepUserInfo",{'UserID':LgUserID,'LocID':LgCtLocID,'HospID':LgHospID,'GroupID':LgGroupID},
	function(Data){ 
		LgUserName=Data.User;
	},"json",false);
	if(EvaRecordId!="")	{
		//现场工作评价  不可编辑
		$("[id^='DeptContent-3979-']").each(function(){
			if ((this.value!="")){
				var rowid=this.id.split(".")[0];
				var rownum=this.id.split(".")[1];
				$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				$("input[id^='DeptContent-3979-3986']").datebox({"disabled":true});
				if(flag==0){
					$('a:contains('+$g("删除")+')').parent().hide();
				}
			}
		})		
	}	
	$("#DeptContent").next().find("tbody>tr").each(function(j,obj){
		if($(obj).find("input[id^='DeptContent-3979-3985.']").val()==""){
		  $(obj).find("input[id^='DeptContent-3979-3985.']").val(LgUserName);
		  $(obj).find("input[id^='DeptContent-3979-3985.']").attr("readonly",'readonly');
		}
		if($(obj).find("input[id^='DeptContent-3979-3986.']").val()==""){
		  $(obj).find("input[id^='DeptContent-3979-3986.']").datebox({"disabled":true});
		  $(obj).find("input[id^='DeptContent-3979-3986.']").datebox("setValue",nowDate);
		}
	})
	
}

function checkTableRequired(){
	var errMsg="",lenflag="";
	
	$("#DeptContent").next().find("tbody tr").each(function(i){
		if(lenflag==""){
							
			var rowMsg="";
			// 追踪内容
			var str1=$(this).children('td').eq(0).find("textarea").val();
			if(str1.length==0){
				rowMsg=rowMsg+$g("持续追踪内容")+",";
			}
			if(str1.length>2000){
				lenflag="-1";
				$.messager.alert($g("提示:"),$g("追踪内容过多，保存失败"));
				return;
			}
			// 追踪人
			var str2=$(this).children('td').eq(1).find("input").val();
			if(str2.length==0){
				rowMsg=rowMsg+$g("追踪人")+",";
			}
			//追踪日期
			//var str3=$(this).children('td').eq(2).find("datebox").getValue() //getValue() //("datebox").val()
			//if(str3.length==0){
			  // rowMsg=rowMsg+"追踪日期,"
			//}
			
			
			if(rowMsg!=""){
				errMsg=errMsg+"\n"+rowMsg+$g("不能为空")+".";
			}
		}
			
				
	})
	if(errMsg!=""){
		$("html,body").stop(true);$("html,body").animate({scrollTop: $("#DeptContent").offset().top}, 0);
		$.messager.alert($g("提示:"),errMsg);
	}
	if(lenflag!=""){
		errMsg=lenflag;
	}
	return errMsg;
}
