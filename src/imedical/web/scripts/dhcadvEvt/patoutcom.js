/// Description: 患者转归界面 
/// Creator: congyue
/// CreateDate: 2018-05-07
var EvaRecordId="",LinkRecordId="",WinCode="";
$(document).ready(function(){
	
	EvaRecordId=getParam("recordId");  //表单类型id
	LinkRecordId=getParam("LinkRecordId");  //关联表单记录ID
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
		SavePatOut();
	})
}

//报告评价保存
function SavePatOut()
{
	///保存前,对页面必填项进行检查
	if(!(checkRequired())){
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
			EvaRecordId=data[1]
			if (data[0]=="0") {
				window.parent.ClosePatOutWin();
				//window.parent.SetRepInfo(data[1],WinCode);
			}else{
				return;
			}
		},"text")
	
}

function add_event(){
	AllStyle("textarea","",100);
}
