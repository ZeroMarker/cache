/// Description: ����ת����� 
/// Creator: congyue
/// CreateDate: 2018-05-07
var EvaRecordId="",LinkRecordId="",WinCode="";
$(document).ready(function(){
	
	EvaRecordId=getParam("recordId");  //������id
	LinkRecordId=getParam("LinkRecordId");  //��������¼ID
	WinCode=getParam("code");  //��������¼code
	reportControl();			// ������  	
	InitButton();				// ��ʼ����ť
});
//��ȡ������Ϣ
function InitPatInfo(){};
// ������
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
	$('#AuditMessage').hide(); //2018-06-12 cy ������Ϣչ��
	$("body").click(function(){
		AllStyle("textarea","",100);
  		InitLabInputText(".lable-input");
	})
	setTimeout(function(){ //��ʱ���body
        $("body").click();
    },500)	
	$(".lable-input").css('width','100px');
	$(".lable-input").css('max-width','100px');
}
//��ť�����뷽����
function InitButton(){
	$("#AsseSaveBut").on("click",function(){
		SavePatOut();
	})
}

//�������۱���
function SavePatOut()
{
	///����ǰ,��ҳ���������м��
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
