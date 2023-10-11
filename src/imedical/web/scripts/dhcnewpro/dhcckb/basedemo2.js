//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-05-15
// ����:	   ֪ʶ����ʾdemo
//===========================================================================================

var pid = 1;
var mDel1 = String.fromCharCode(1);  /// �ָ���
var mDel2 = String.fromCharCode(2);  /// �ָ���
/// ҳ���ʼ������
function initPageDefault(){

	$("input,textarea").bind('change keyup',function(){
		/// ����֪ʶ�⺯����ˢ��֪ʶ������Ϣ
		 Invoke();
	})
	//InsResBody(1);
}

/// ����֪ʶ�⺯����ˢ��֪ʶ������Ϣ
function Invoke(){
   
    /*
    [{"passFlag":"�Ƿ�ͨ����־","manLevel":"������","retMsg":
    	[{"level":"������","geneDesc":"ͨ����or��Ʒ��","oeori":"ҽ��id","arci":"ҽ����id","seqNo":"ҽ�����","pointer":"����/��λ/�걾","PhMRId":"��־��id","chlidren":
	      [{ "labelLevel":"Ŀ¼������","labelDesc":"Ŀ¼����","linkOeori":"����ҽ��id","linkArci":"����ҽ����id","linkOeSeqNo":"����ҽ�����","alertMsg":"��ʾ��Ϣ"}]
	    }]
	}]
	*/
	var checkBaseObj = TakCheckBaseObj();          /// ������
	if (!$.isEmptyObject(checkBaseObj)){
		InsResHeader(checkBaseObj);   	               /// ���ҳ��ͷ��Ϣ
		var ResBodyObj = InvKnowBaseRes(checkBaseObj); /// ����֪ʶ��ӿ�
		if (ResBodyObj != "") InsResBody(ResBodyObj);
	}
	
}

/// ���������������
function InsResBody(ResBodyObj){
	
	var htmlstr = "";
		htmlstr = htmlstr + '<div class="libtitle" style="border-bottom: 1px solid #ccc;padding-top: 3px;">��['+ ResBodyObj.length +']��</div>';
	for(var i=0; i<ResBodyObj.length; i++){
		htmlstr = htmlstr + '<div class="tip_title" style="margin:3px 3px 0 3px;border-bottom: 1px solid #ccc;font-weight:bold;padding: 3px 0 0 10px;background-color:#DDDDDD">��'+ (i+1) +'��</div>';
		htmlstr = htmlstr + '<div style="margin:0 3px 0 3px;">';
		htmlstr = htmlstr + '	<table cellpadding="0" cellspacing="0" class="medicontTb">';
		htmlstr = htmlstr + '		<tr>';
		htmlstr = htmlstr + '		  <td style="background-color:#F6F6F6;width:120px">��'+ ResBodyObj[i].ItmKey +'��</td>';
		htmlstr = htmlstr + '		  <td colspan="2"  style="border-right:solid #E3E3E3 1px">'+ ResBodyObj[i].ItemVal +'</td>';
		htmlstr = htmlstr + '		</tr>';
		htmlstr = htmlstr + '		<tr>';
		htmlstr = htmlstr + '		  <td style="background-color:#F6F6F6;width:120px">��'+ ResBodyObj[i].PropKey +'��</td>';
		htmlstr = htmlstr + '		  <td style="border-right:solid #E3E3E3 1px" colspan="2">'+ ResBodyObj[i].PropValue +'</td>';
		htmlstr = htmlstr + '		</tr>';
		htmlstr = htmlstr + '	</table>';
		htmlstr = htmlstr + '</div>';
	}
	$(".res-body").html(htmlstr);
}

/// ������鲡����Ϣ������
function InsResHeader(jsonObject){
	
	$('.ui-span-m').each(function(){
		if (this.id == "PatDiags"){
			$(this).text((jsonObject[this.id].length <= 20)?jsonObject[this.id]:jsonObject[this.id].substring(0,20)+"....");
		}else{
			$(this).text(jsonObject[this.id]);
		}
		if (jsonObject.PatSex == "��"){
			$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/boy.png");
		}else{
			$("#PatPhoto").attr("src","../scripts/dhcnewpro/images/girl.png");
		}
	})
}

/// �������������
function TakCheckBaseObj(){
	
	var itemObj = {
		PatNo : $("#PatNo").val(),
		PatName : $("#PatName").val(),
		PatAge : $("#PatAge").val(), /// ��Ȼ��
		PatAgeUnit : $('#PatAgeUnit option:selected').val(), // (��|��|��|��|Сʱ)
		PatSex : $('input[name="PatSex"]:checked').val()||"",
		PreFlag : $('input[name="PreFlag"]:checked').val()||"",
		PatPhone : $("#PatTelH").val(), // (11λ1��ͷ��Ȼ��)
		PatAddr : $("#PatAddress").val(), // סַ
		PatDiags : $("#Diags").val()
	}
	/// ����ҩƷ�б�
	var prescriptionArr = [];
	var items = $("#itemMedi").val();
	if (items != ""){
		var itemArr = items.split(",");
		for(var i=0;i<itemArr.length;i++){
			var itemName = itemArr[i];

			var itemObj = {
					//#-- ҩ�����ƣ��ǿգ�--
					PhDesc: itemName,
					//#-- ��ҩ��ʽ --
					Instr : "",
					//#-- ��ҩƵ�� �C-
					Freq: "",
					//#-- ��ҩ�Ƴ� �C-
					Duration :"",
					//#-- ���μ��� �C-
					DoseQty : "",
					//#-- ������λ �C-
					DoseUom : ""
			}
			prescriptionArr.push(itemObj);
		}
	}
	itemObj.Prescriptions = prescriptionArr;
	return itemObj;
}

/// ����֪ʶ��ӿ�
function InvKnowBaseRes(jsParamObj){

	var baseObject = "";
	runClassMethod("web.DHCCKBBaseDemo","InvKnowBaseRes",{"jsParamObj":JSON.stringify(jsParamObj)},function(jsonObject){
		if (jsonObject != null){
			baseObject = jsonObject;
		}
	},'json',false)
	return baseObject;
}

/// ɾ����ʱglobal
function killTmpGlobal(){

	runClassMethod("web.DHCCKBBaseDemo","killTmpGlobal",{"pid":pid},function(jsonString){},'',false)
}

/// ҳ��ر�֮ǰ����
function onbeforeunload_handler() {
    //killTmpGlobal();  /// �����ʱglobal
}

window.onbeforeunload = onbeforeunload_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })