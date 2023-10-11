//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-05-15
// 描述:	   知识库演示demo
//===========================================================================================

var pid = 1;
var mDel1 = String.fromCharCode(1);  /// 分隔符
var mDel2 = String.fromCharCode(2);  /// 分隔符
/// 页面初始化函数
function initPageDefault(){

	$("input,textarea").bind('change keyup',function(){
		/// 调用知识库函数，刷新知识库检测信息
		 Invoke();
	})
	//InsResBody(1);
}

/// 调用知识库函数，刷新知识库检测信息
function Invoke(){
   
    /*
    [{"passFlag":"是否通过标志","manLevel":"管理级别","retMsg":
    	[{"level":"管理级别","geneDesc":"通用名or商品名","oeori":"医嘱id","arci":"医嘱项id","seqNo":"医嘱序号","pointer":"剂型/部位/标本","PhMRId":"日志表id","chlidren":
	      [{ "labelLevel":"目录管理级别","labelDesc":"目录描述","linkOeori":"关联医嘱id","linkArci":"关联医嘱项id","linkOeSeqNo":"关联医嘱序号","alertMsg":"提示信息"}]
	    }]
	}]
	*/
	var checkBaseObj = TakCheckBaseObj();          /// 审查对象
	if (!$.isEmptyObject(checkBaseObj)){
		InsResHeader(checkBaseObj);   	               /// 审查页面头信息
		var ResBodyObj = InvKnowBaseRes(checkBaseObj); /// 调用知识库接口
		if (ResBodyObj != "") InsResBody(ResBodyObj);
	}
	
}

/// 更新审查结果到界面
function InsResBody(ResBodyObj){
	
	var htmlstr = "";
		htmlstr = htmlstr + '<div class="libtitle" style="border-bottom: 1px solid #ccc;padding-top: 3px;">共['+ ResBodyObj.length +']条</div>';
	for(var i=0; i<ResBodyObj.length; i++){
		htmlstr = htmlstr + '<div class="tip_title" style="margin:3px 3px 0 3px;border-bottom: 1px solid #ccc;font-weight:bold;padding: 3px 0 0 10px;background-color:#DDDDDD">第'+ (i+1) +'条</div>';
		htmlstr = htmlstr + '<div style="margin:0 3px 0 3px;">';
		htmlstr = htmlstr + '	<table cellpadding="0" cellspacing="0" class="medicontTb">';
		htmlstr = htmlstr + '		<tr>';
		htmlstr = htmlstr + '		  <td style="background-color:#F6F6F6;width:120px">〖'+ ResBodyObj[i].ItmKey +'〗</td>';
		htmlstr = htmlstr + '		  <td colspan="2"  style="border-right:solid #E3E3E3 1px">'+ ResBodyObj[i].ItemVal +'</td>';
		htmlstr = htmlstr + '		</tr>';
		htmlstr = htmlstr + '		<tr>';
		htmlstr = htmlstr + '		  <td style="background-color:#F6F6F6;width:120px">〖'+ ResBodyObj[i].PropKey +'〗</td>';
		htmlstr = htmlstr + '		  <td style="border-right:solid #E3E3E3 1px" colspan="2">'+ ResBodyObj[i].PropValue +'</td>';
		htmlstr = htmlstr + '		</tr>';
		htmlstr = htmlstr + '	</table>';
		htmlstr = htmlstr + '</div>';
	}
	$(".res-body").html(htmlstr);
}

/// 更新审查病人信息到界面
function InsResHeader(jsonObject){
	
	$('.ui-span-m').each(function(){
		if (this.id == "PatDiags"){
			$(this).text((jsonObject[this.id].length <= 20)?jsonObject[this.id]:jsonObject[this.id].substring(0,20)+"....");
		}else{
			$(this).text(jsonObject[this.id]);
		}
		if (jsonObject.PatSex == "男"){
			$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/boy.png");
		}else{
			$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/girl.png");
		}
	})
}

/// 整理病人审查数据
function TakCheckBaseObj(){
	
	var itemObj = {
		PatNo : $("#PatNo").val(),
		PatName : $("#PatName").val(),
		PatAge : $("#PatAge").val(), /// 自然数
		PatAgeUnit : $('#PatAgeUnit option:selected').val(), // (岁|月|周|天|小时)
		PatSex : $('input[name="PatSex"]:checked').val()||"",
		PreFlag : $('input[name="PreFlag"]:checked').val()||"",
		PatPhone : $("#PatTelH").val(), // (11位1开头自然数)
		PatAddr : $("#PatAddress").val(), // 住址
		PatDiags : $("#Diags").val()
	}
	/// 病人药品列表
	var prescriptionArr = [];
	var items = $("#itemMedi").val();
	if (items != ""){
		var itemArr = items.split(",");
		for(var i=0;i<itemArr.length;i++){
			var itemName = itemArr[i];

			var itemObj = {
					//#-- 药物名称（非空）--
					PhDesc: itemName,
					//#-- 给药方式 --
					Instr : "",
					//#-- 给药频次 –-
					Freq: "",
					//#-- 给药疗程 –-
					Duration :"",
					//#-- 单次剂量 –-
					DoseQty : "",
					//#-- 剂量单位 –-
					DoseUom : ""
			}
			prescriptionArr.push(itemObj);
		}
	}
	itemObj.Prescriptions = prescriptionArr;
	return itemObj;
}

/// 调用知识库接口
function InvKnowBaseRes(jsParamObj){

	var baseObject = "";
	runClassMethod("web.DHCCKBBaseDemo","InvKnowBaseRes",{"jsParamObj":JSON.stringify(jsParamObj)},function(jsonObject){
		if (jsonObject != null){
			baseObject = jsonObject;
		}
	},'json',false)
	return baseObject;
}

/// 删除临时global
function killTmpGlobal(){

	runClassMethod("web.DHCCKBBaseDemo","killTmpGlobal",{"pid":pid},function(jsonString){},'',false)
}

/// 页面关闭之前调用
function onbeforeunload_handler() {
    //killTmpGlobal();  /// 清除临时global
}

window.onbeforeunload = onbeforeunload_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })