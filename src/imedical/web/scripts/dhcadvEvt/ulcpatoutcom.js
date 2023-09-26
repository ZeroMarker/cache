/// Description: 压疮患者转归界面 
/// Creator: congyue
/// CreateDate: 2018-05-07
var EvaRecordId="",LinkRecordId="",WinCode="";
$(document).ready(function(){
	
	RepID=getParam("RepID");  //报告ID
	EvaRecordId=getParam("recordId");  //表单类型id
	LinkRecordId=getParam("LinkRecordId");  //关联表单记录ID
	WinCode=getParam("code");  //关联表单记录code
	reportControl();			// 表单控制  	
	InitButton();				// 初始化按钮
	UlcPartInfo(RepID,LinkRecordId);
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
	UlcPartInfo(RepID,LinkRecordId);
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
				window.parent.SetRepInfo(data[1],WinCode);
			}else{
				return;
			}
		},"text")
	
}
//加载压疮部位  2018-05-08
function UlcPartInfo(RepID,RecordId)
{	
	var PartList=""
	runClassMethod("web.DHCADVULCPARTINFO","QueryUlcPartList",{'RepDr':RepID,'FormRecordDr':RecordId},
	function(data){ 
		PartList=data;
	},"text",false);
	//转归，压疮部位 例如：&&64772^院内发生^耳廓左^Ⅰ期^1*1*1^^^&&64776^院内发生^肩胛部右^Ⅱ期^2*1*^^^
	var PartListArr=PartList.split("&&")
	var Ulcerlen=PartListArr.length; //压疮部位个数 实际少1
	var num=0,rowid="",rownum="";
	$("input[id^='UlcPatOutcom-94937-94940-94943']").each(function(){
			num=num+1;
	})
	for(var k=1;k<Ulcerlen;k++){
		if(k>num){
			$('a:contains("增加")').click(); //自动添加行数据
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
		if((EvaRecordId!="")&&(Ulcerlen==num)){ //部位计数与转归行数相同时，隐藏最后一行数据
			$("input[id^='"+rowidarr[k]+"']input[id$='"+rownumarr[num]+"']").parent().parent().hide();
		}
		$("input[id^='"+rowidarr[k]+"']input[id$='"+rownumarr[k]+"']").attr('readonly','readonly')
		$('a:contains("增加")').parent().hide();
		$('a:contains("删除")').parent().hide();
	}
	
}

function add_event(){
	AllStyle("textarea","",100);
}
