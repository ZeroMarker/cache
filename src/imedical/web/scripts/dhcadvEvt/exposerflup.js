/// Description: 职业暴露-暴露者随访
/// Creator: 
/// CreateDate: 2019-10-31
var EvaRecordId="",LinkRecordId="",WinCode="",AuditList="",CancelAuditList="",StaFistAuditUser="",StsusGrant="",RepStaus="";
var userName="";
$(document).ready(function(){
	EvaRecordId=getParam("recordId");  //表单类型id
	LinkRecordId=getParam("LinkRecordId");  //关联表单记录ID
	AuditList=getParam("AuditList");  //审核串
	CancelAuditList=getParam("CancelAuditList");  //撤销审核串
	StaFistAuditUser=getParam("StaFistAuditUser");  //第一审批人
	StsusGrant=getParam("StsusGrant");  //审核标识
	RepStaus=getParam("RepStaus");  //报告状态
	WinCode=getParam("code");  //关联表单记录code
	reportControl();			// 表单控制  	
	InitButton();				// 初始化按钮
});
//获取病人信息
function InitPatInfo(){};
// 表单控制
function reportControl(){
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
	$('#AuditMessage').hide(); //2018-06-12 cy 审批信息展现
	if(EvaRecordId!="")	{
		$("[id^='ExposerFlup-']").each(function(){
			if ((this.value!="")){
				var rowid=this.id.split(".")[0];
				//var rownum=this.id.split(".")[1]; [id$='"+rownum+"']
				$("[id^='"+rowid+"']").attr("readonly",'readonly');
			}
		})
	}
	$("body").click(function(){
		AllStyle("textarea","",100);
  		InitLabInputText(".lable-input");
	})
	setTimeout(function(){ //延时点击body
        $("body").click();
    },500)
	$(".lable-input").css('width','100px');
	$(".lable-input").css('max-width','100px');
}
//按钮控制与方法绑定
function InitButton(){
	$("#AsseSaveBut").on("click",function(){
		SaveAsse(0);
	})
}
//报告评价保存
function SaveAsse(flag)
{
	 ///保存前,对页面必填项进行检查
	if(!(checkRequired()&&checkother())){
		return;
	} 
	//alert("formId:"+formId+"par:"+loopStr("#from")+"recordId:"+EvaRecordId+"linkRecordId:"+LinkRecordId);
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
				window.parent.CloseAsseWin();
				window.parent.location.reload();// 2018-11-20 cy 保存报告后，刷新父界面
				if(flag==1){
					//window.parent.SetRepInfo(data[1],WinCode);
					window.parent.parent.CloseWinUpdate();
					window.parent.parent.Query();
				}
				
			}else{
				return;
			}
		},"text")
			
}

//检查界面勾选其他，是否填写输入框
function checkother(){
	
	
	return true;
}

//页面关联设置
function setCheckBoxRelation(id){
}

