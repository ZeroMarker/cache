/// Description: ѹ������ת����� 
/// Creator: congyue
/// CreateDate: 2018-05-07
var EvaRecordId="",LinkRecordId="",WinCode="";
$(document).ready(function(){
	
	RepID=getParam("RepID");  //����ID
	EvaRecordId=getParam("recordId");  //������id
	LinkRecordId=getParam("LinkRecordId");  //��������¼ID
	WinCode=getParam("code");  //��������¼code
	reportControl();			// ������  	
	InitButton();				// ��ʼ����ť
	UlcPartInfo(RepID,LinkRecordId);
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
	UlcPartInfo(RepID,LinkRecordId);
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
				window.parent.SetRepInfo(data[1],WinCode);
			}else{
				return;
			}
		},"text")
	
}
//����ѹ����λ  2018-05-08
function UlcPartInfo(RepID,RecordId)
{	
	var PartList=""
	runClassMethod("web.DHCADVULCPARTINFO","QueryUlcPartList",{'RepDr':RepID,'FormRecordDr':RecordId},
	function(data){ 
		PartList=data;
	},"text",false);
	//ת�飬ѹ����λ ���磺&&64772^Ժ�ڷ���^������^����^1*1*1^^^&&64776^Ժ�ڷ���^���β���^����^2*1*^^^
	var PartListArr=PartList.split("&&")
	var Ulcerlen=PartListArr.length; //ѹ����λ���� ʵ����1
	var num=0,rowid="",rownum="";
	$("input[id^='UlcPatOutcom-94937-94940-94943']").each(function(){
			num=num+1;
	})
	for(var k=1;k<Ulcerlen;k++){
		if(k>num){
			$('a:contains("����")').click(); //�Զ����������
		}
	}
	$("input[id^='UlcPatOutcom-94937-94940-94943']").each(function(){
			rowid=rowid+"^"+this.id.split(".")[0];
			rownum=rownum+"^"+this.id.split(".")[1];
	})
	for(var k=1;k<Ulcerlen;k++){
		var part=PartListArr[k].split("^")[2];
		var rowidarr=rowid.split("^"),rownumarr=rownum.split("^");
		var value=$("input[id^='"+rowidarr[k]+"']input[id$='"+rownumarr[k]+"']").val();
		if(value==""){
			$("input[id^='"+rowidarr[k]+"']input[id$='"+rownumarr[k]+"']").val(part);
		}
		if((EvaRecordId!="")&&(Ulcerlen==num)){ //��λ������ת��������ͬʱ���������һ������
			$("input[id^='"+rowidarr[k]+"']input[id$='"+rownumarr[num]+"']").parent().parent().hide();
		}
		$("input[id^='"+rowidarr[k]+"']input[id$='"+rownumarr[k]+"']").attr('readonly','readonly')
		$('a:contains("����")').parent().hide();
		$('a:contains("ɾ��")').parent().hide();
	}
	
}

function add_event(){
	AllStyle("textarea","",100);
}
