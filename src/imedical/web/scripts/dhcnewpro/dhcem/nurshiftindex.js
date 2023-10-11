//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2022-10-12
// ����:	   ���ｻ�౾ָ����
//===========================================================================================

var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID

/// ҳ���ʼ������
function initPageDefault(){
	
//	/// ��ʼ�����˻�����Ϣ
//	InitPatInfoPanel();
	
	/// ��ʼ��Table�б�
	InitWorkLoadItem();
}

/// ����Table�б�
function InitWorkLoadItem(){
	
	/// ��ʼ����鷽������
	//$("#itemList").html('<tr style="height:0;"><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	// ��ȡ��ʾ����
	runClassMethod("web.DHCEMTriageDailyWordLoad","JsGetTriColumns",{"mCode":"WWL", "HospID":session['LOGON.HOSPID']},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InitCheckItemRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}

/// ��鷽���б�
function InitCheckItemRegion(itemArr){	

	/// ��Ŀ
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		
		itemhtmlArr.push('<td align="right" class="tb_td_bk">'+ itemArr[j-1].title +'</td><td class="tb_td_val"><span data-type="val" id="'+ itemArr[j-1].field +'"></span></td>');
		if (j % 4 == 0){
			itemhtmlstr = itemhtmlstr + '<tr class="tr">' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
	if ((j-1) % 4 != 0){
		var fixhtml = "";
		var remainder = (j-1) % 4;
		if (remainder == 3){fixhtml = "<td></td><td></td>"}
		if (remainder == 2){fixhtml = "<td></td><td></td><td></td><td></td>"}
		if (remainder == 1){fixhtml = "<td></td><td></td><td></td><td></td><td></td><td></td>"}
		itemhtmlstr = itemhtmlstr + '<tr class="tr">' + itemhtmlArr.join("") + fixhtml + '</tr>';
		itemhtmlArr = [];
	}
	$("#itemList").append(itemhtmlstr)
	$.parser.parse($('#itemList'));  /// ���½���
	
	InitWorkLoad();
}

/// ����Table�б�
function InitWorkLoad(){
	
	// ��ȡ��ʾ����
	runClassMethod("web.DHCEMTriageDailyWordLoad","JsGetTriWorkLoad",{"Params":session['LOGON.HOSPID']+"^WWL"},function(jsonString){

		if (jsonString != ""){
			var jsonObj = jsonString;
			GetTriWorkInfo(jsonObj)
		}
	},'json',false)
}

/// ��ȡ������Ϣ
function GetTriWorkInfo(jsonObj){
	
	/// ��д����
	$("#WrDate").text(jsonObj.CrBusDate);
	/// ���
	$("#Schedule").text(jsonObj.Schedule);
	/// ����
	$("#CrLoc").text(jsonObj.CrLoc);
	/// ���
	$("#LgUser").text(jsonObj.CreateUser);
	$("span[data-type='val']").each(function(){
		$(this).text(jsonObj[this.id]||"");
	})
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
