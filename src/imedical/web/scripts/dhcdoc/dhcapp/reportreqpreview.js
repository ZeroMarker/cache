
/// ҳ���ʼ������
function initPageDefault(){
	
	var arExaReqID = getParam("arExaReqID");
	var arExaReqNo = getParam("arExaReqNo");
	runClassMethod("web.DHCAPPExaReportQuery","GetExaReqHtmlContent",{"arReqID":arExaReqID,"arExaReqNo":arExaReqNo},function(jsonString){

		if (jsonString != null){
			showHtml(jsonString);
		}
	},'json',false)
}

/// �������뵥html
function showHtml(ExaRepObj){
	
	var arExaReqCode = "";
	if (ExaRepObj.arExaReqCode.indexOf("CT") != "-1"){
		arExaReqCode = "CT";
	}
	if (ExaRepObj.arExaReqCode.indexOf("CS") != "-1"){
		arExaReqCode = "����";
	}
	if (ExaRepObj.arExaReqCode.indexOf("HC") != "-1"){
		arExaReqCode = "�˴�";
	}
	if (ExaRepObj.arExaReqCode.indexOf("WJ") != "-1"){
		arExaReqCode = "θ��";
	}
	if (ExaRepObj.arExaReqCode.indexOf("XD") != "-1"){
		arExaReqCode = "�ĵ�";
	}
	var htmlstr = "";
	htmlstr = htmlstr +"<div style='margin:0 auto; width:950px; height:640px; font-family: "+"����"+";font-size: 16px;'>"
	htmlstr = htmlstr +"<div style='width:100%; text-align:center; '>"
	htmlstr = htmlstr +"<h2 style='padding: 0; margin: 0; line-height: 25px; '>����ʡ����ҽԺ</h2>"
	htmlstr = htmlstr +"<h1 style='padding: 0; margin: 0; line-height: 25px; font-weight: bold; font-size: 30px; font-weight: bold;'>"+arExaReqCode+"&nbsp;������뵥</h1>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"<div style='width:100%;'>"
	htmlstr = htmlstr +"<div style='margin:8px 5px;'>"
	htmlstr = htmlstr +"<span style='width:20%; margin:0px 10px; display:inline-block;'>��&nbsp;��&nbsp;�ţ�<span style='padding-left:10px;'>"+ExaRepObj.PatNo+"</span></span>"
	htmlstr = htmlstr +"<span style='width:20%; margin:0px 45px; display:inline-block;'> ��&nbsp;&nbsp;����<span style='padding-left:10px;'>"+ExaRepObj.PatName+"</span></span>"
	htmlstr = htmlstr +"<span style='width:20%; margin:0px 10px; display:inline-block;'>��&nbsp;&nbsp;�䣺<span style='padding-left:10px;'>"+ExaRepObj.PatAge+"</span></span>"
	htmlstr = htmlstr +"<span style='width:20%; margin:0px 10px; display:inline-block;'>��&nbsp;&nbsp;��&nbsp;&nbsp;�ţ�<span style='padding-left:10px;'></span></span>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"<div style='margin:8px 5px;'>"
	htmlstr = htmlstr +"<span style='width:20%; margin:0px 10px; display:inline-block;'>������ң�<span style='padding-left:10px;'>"+ExaRepObj.PatLoc+"</span></span>"
	htmlstr = htmlstr +"<span style='width:20%; margin:0px 45px; display:inline-block;'>��&nbsp;&nbsp;��<span style='padding-left:10px;'>"+ExaRepObj.PatSex+"</span></span>"
	htmlstr = htmlstr +"<span style='width:20%; margin:0px 10px; display:inline-block;'>ҽ���ֲ�ţ�<span style='padding-left:10px;'></span></span>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"<div style='width:100%; border:1px solid #000;'>"
	htmlstr = htmlstr +"<div style='margin:8px 5px;'>"
	htmlstr = htmlstr +"<div>"
	htmlstr = htmlstr +"<span style='padding-left:20px;'>���ߡ��ٴ�֢״��������ʵ���Ҽ�飺</span>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"<div style='height:65px;padding-left:40px;'>"
	if (ExaRepObj.arExaReqSym != ""){
		ExaRepObj.arExaReqSym = ExaRepObj.arExaReqSym+"��"
	}
	if (ExaRepObj.arHisDesc != ""){
		ExaRepObj.arHisDesc = ExaRepObj.arHisDesc+"��"
	}
	htmlstr = htmlstr +"<p style='margin-top:5px;'>"+ExaRepObj.arExaReqSym+ExaRepObj.arHisDesc+ExaRepObj.arSigDesc+"</p>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"<div style='margin:8px 5px;'>"
	htmlstr = htmlstr +"<div>"
	htmlstr = htmlstr +"<span style='padding-left:20px;'>�ٴ���ϣ�</span>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"<div style='height:30px;padding-left:40px;'>"
	htmlstr = htmlstr +"<p style='margin-top:5px;'>"+ExaRepObj.PatDiag+"</p>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"<div style='margin:8px 5px;'>"
	htmlstr = htmlstr +"<div>"
	htmlstr = htmlstr +"<span style='padding-left:20px;'>�����Ŀ��</span>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"<div style='height:40px;padding-left:40px;'>"
	htmlstr = htmlstr +"<p>"+ExaRepObj.itemdesc+"</p>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"<div style='margin:8px 5px;'>"
	htmlstr = htmlstr +"<div>"
	htmlstr = htmlstr +"<span style='padding-left:20px;'>���ⲡʷ������쳣��</span>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"<div style='height:60px;padding-left:40px;'>"
	
	var OptListData = ExaRepObj.OptListData;
	if (OptListData !="" ){
		var OptArr = OptListData.split("#");
		for (var n=0; n<OptArr.length; n++){
			if (n%4 == 0){
				htmlstr = htmlstr +"<div style='padding-top:5px;padding-bottom:5px;'>";
			}
			htmlstr = htmlstr +"<span style='margin-left:60px;'>"+ OptArr[n] +"</span>";
			if (((n != 0)&((n+1)%4 == 0))||(n == (OptArr.length-1))){
				htmlstr = htmlstr +"</div>";
			}
		}
	}

	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"</div>"
	/*
	htmlstr = htmlstr +"<div style='width:100%; height:25px; padding-top:15px; border:1px solid #000; '>"
	htmlstr = htmlstr +"<span style='width:30%;padding-left:20px;margin:0px 10px; display:inline-block;'>�ϻ���ʦ��<span style='padding-left:10px;'></span></span>"
	htmlstr = htmlstr +"<span style='width:30%;margin:0px 10px; display:inline-block;'>�ϻ�ҽʦ��<span style='padding-left:10px;'></span></span>"
	htmlstr = htmlstr +"<span style='width:20%;margin:0px 10px; display:inline-block;'>���ʱ�䣺<span style='padding-left:10px;'></span></span>"
	htmlstr = htmlstr +"</div>"
	*/
	htmlstr = htmlstr +"<div style='margin:8px 5px;'>"
	htmlstr = htmlstr +"<span style='padding-left:8px;width:30%; margin:0px 10px; display:inline-block;'>���տ��ң�<span style='padding-left:10px;'>"+ExaRepObj.arRepExLoc+"</span></span>"
	htmlstr = htmlstr +"<span style='width:30%; margin:0px 10px; display:inline-block;'>����ʱ�䣺<span style='padding-left:10px;'>"+ExaRepObj.arReqTime+"</span></span>"
	htmlstr = htmlstr +"<span style='width:20%; margin:0px 10px; display:inline-block;'>����ҽ����<span style='padding-left:10px;'>"+ExaRepObj.arUserCode+"</span></span>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"<div style='margin-top:0px; padding-left:20px; font-family: "+"����"+";font-size: 16px;'>"
	
	if (ExaRepObj.arExaReqCode.indexOf("CT") != "-1"){
		htmlstr = htmlstr +"<div><span>��λ������ע�⣺</span></div>";
		htmlstr = htmlstr +"<div><span>1.����CT������ʳ4Сʱ����ǻCT������ӯ���ס�</span></div>";
		htmlstr = htmlstr +"<div><span>2.��ǿ���ǰ���ո��⣬��������������飬ǩ��֪��ͬ���顣</span></div>";
		htmlstr = htmlstr +"<div><span>3.���ʱ��Я��������X��Ƭ(ƽƬ����Ӱ)������������CT�ȼ������</span></div>";
	}
	
	if (ExaRepObj.arExaReqCode.indexOf("WJ") != "-1"){
		htmlstr = htmlstr +"<div><span>��λ������ע�⣺</span></div>";
		htmlstr = htmlstr +"<div><span>1.���ǰ12Сʱ�ڽ�ʳ����ʳ�������ɫҺ��(ˮ������)��</span></div>";
		htmlstr = htmlstr +"<div><span>2.���ǰ��Сʱ������ˮ��</span></div>";
	}
		
	if (ExaRepObj.arExaReqCode.indexOf("HC") != "-1"){
		htmlstr = htmlstr +"<div><span>��λ������ע�⣺</span></div>";
		htmlstr = htmlstr +"<div><span>1.ͷ�������Ļ������ڼ��ǰһ��ϴͷ����Ҫʹ���κλ�����Ʒ�����������(�Ρ������ȡ�Ƣ������ϵ����)���ǰ��ʳ4Сʱ��</span></div>";
		htmlstr = htmlstr +"<div><span>2.���ʱ��Я��������X��Ƭ(ƽƬ����Ӱ)��������CT�ȼ������</span></div>";
		htmlstr = htmlstr +"<div><span>3.������������Ա˵����������ʷ�����޽������������ֲ�����ڣ��������ڽ���������ݡ����Ӷ��ȣ�����ҩ�����ʷ��</span></div>";
		htmlstr = htmlstr +"<div><span>4.���ʱ��Ҫ�����н������ʵ����¿㣬��ȥ������������������������ֱ���ָ�ȣ���ȥ���ϻ�ױƷ����ݡ����ۡ��۾��ȡ�</span></div>";
	}
		
	if (ExaRepObj.arExaReqCode.indexOf("CS") != "-1"){
		htmlstr = htmlstr +"<div><span>��λ������ע�⣺</span></div>";
		htmlstr = htmlstr +"<div><span>1.���ࡢ���ҡ�����ϵͳ�����١��ž���Ѫ�����ȳ������ʱ����ո�(8-12Сʱ)��</span></div>";
		htmlstr = htmlstr +"<div><span>2.����(�ӹ�������)���������С�ǰ��̥�̡����׵Ⱦ����������ʱ����Ҫ��ӯ���ס�</span></div>";
		htmlstr = htmlstr +"<div><span>3.������ϵ��Ӱ��������顢��ǿCT���Ļ��ߣ���3���ո�������������顣��θ���ͳ���ͬһ���飬��������������θ����</span></div>";
		htmlstr = htmlstr +"<div><span>4.���ʱ��Я��������X��Ƭ(ƽƬ����Ӱ)�����������ȼ������</span></div>";
	}
	
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"</div>"
	htmlstr = htmlstr +"</div>";

	$("body").html(htmlstr);
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })