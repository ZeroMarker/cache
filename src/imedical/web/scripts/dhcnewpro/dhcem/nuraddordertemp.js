
var EpisodeID = "";   /// ��ǰ�༭�к�
var LgUserID = session['LOGON.USERID'];    /// �û�ID
var LgGroupID = session['LOGON.GROUPID'];  /// ��ȫ��ID
var LgLocID = session['LOGON.CTLOCID'];    /// ����ID
var LgHospID = session['LOGON.HOSPID'];    /// ҽԺID

/// ����ģ��
function LoadTempItem(ObjectType){
	
	/// ����ģ��
	//$("#itemList tbody").html('<tr style="width:33px"><td style="width:40px;" align="center">ѡ��</td><td>����</td><td style="width:40px;" align="center">ѡ��</td><td>����</td></tr>');
	$("#itemList tbody").html('');
	var QueryParam = {"LgUserID":LgUserID, "LgGroupID":LgGroupID, "LgLocID":LgLocID, "ObjectType":ObjectType, "HospID":LgHospID, "EpisodeID":EpisodeID};
	//var QueryParam = {"LgUserID":"600", "LgGroupID":"184", "LgLocID":"63", "ObjectType":ObjectType, "HospID":LgHospID, "EpisodeID":EpisodeID};
	runClassMethod("web.DHCEMNurAddOrder","JsonQryOrderTemp",QueryParam,function(jsonString){
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InitCheckItemRegion(jsonObjArr);
		}
	},'json',false)
}

/// ��鷽���б�
function InitCheckItemRegion(itemArr){	
	/// ������
	var htmlstr = '';
		//htmlstr = '<tr style="height:30px"><td colspan="4" class=" tb_td_required" style="border:1px solid #ccc;"></td></tr>';

	/// ��Ŀ
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		var itmmaststr = itemArr[j-1].eleid;
		if (itmmaststr.indexOf("ARCIM") != "-1"){
			var itmmastArr = itmmaststr.split("^");
			itmmaststr = itmmastArr[2];
		}
		itemhtmlArr.push('<td style="width:33px"  align="center"><input id="'+ itemArr[j-1].id +'" name="ExaItem" type="checkbox" class="checkbox" value="'+ itmmaststr +'"></input></td><td>'+ itemArr[j-1].name +'</td>');
		if (j % 2 == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}

	if ((j-1) % 2 != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:33px"></td><td></td></tr>';
		itemhtmlArr = [];
	}

	$("#itemList tbody").append(htmlstr+itemhtmlstr)
}

/// ����ģ��
function LoadTempItemCovDet(ID){
	
	/// ����ģ��
	//$("#itemList tbody").html('<tr style="width:33px"><td style="width:40px;" align="center">ѡ��</td><td>����</td><td style="width:40px;" align="center">ѡ��</td><td>����</td></tr>');
	$("#itemList tbody").html('');
	var QueryParam = {"ID":ID, "LgHospID":LgHospID, "EpisodeID":EpisodeID};
	runClassMethod("web.DHCEMNurAddOrder","JsonQryOrderTempCovDet",QueryParam,function(jsonString){
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InitCheckItemRegionCov(jsonObjArr);
		}
	},'json',false)
}

/// ��鷽���б�
function InitCheckItemRegionCov(itemArr){	
	/// ������
	var htmlstr = '';
		//htmlstr = '<tr style="height:30px"><td colspan="4" class=" tb_td_required" style="border:1px solid #ccc;"></td></tr>';

	/// ��Ŀ
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		var itemValue = itemArr[j-1].ItemRowid +"^"+ itemArr[j-1].ItemQty +"^"+ itemArr[j-1].ItemBillUomID +"^"+ itemArr[j-1].ItemBillUOM;
		itemhtmlArr.push('<td style="width:33px"  align="center"><input id="'+ itemArr[j-1].ItemRowid +'" name="ExaItemCov" type="checkbox" class="checkbox" value="'+ itemValue +'"></input></td><td>'+ itemArr[j-1].Item +'</td><td align="center">'+ itemArr[j-1].ItemQty +'</td><td>'+ itemArr[j-1].ItemBillUOM +'</td>');
		if (j % 2 == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}

	if ((j-1) % 2 != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:33px"></td><td></td><td></td><td></td></tr>';
		itemhtmlArr = [];
	}

	$("#itemList tbody").append(htmlstr+itemhtmlstr)
}

/// ҳ���ʼ������
function initPageDefault(){
	
	InitPatEpisodeID();   /// ��ʼ�����ز��˾���ID
	initBlButton();       ///  ҳ��Button���¼�
	LoadUserTemp(); 	  /// ��ʼ�����ظ���ģ��
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	EpisodeID = getParam("EpisodeID");
}

///  ҳ��Button���¼�
function initBlButton(){
	
	$("a:contains('����ģ��')").bind("click",LoadUserTemp);
	$("a:contains('����ģ��')").bind("click",LoadLocTemp);
	$("a:contains('ҽ����')").bind("click",LoadTempCov);
	
	/// �����ѡ���¼�
	$("#itemList").on("click",".checkbox",selectExaItem);
	
	$("#TempCovCK").on("click",TempCovCKItem);
	
	/// ����Ĭ�ϵ�ҽ���׶���
	var initCovObj = LoadTempCovInitObj();

	///  ҽ�������Ʋ�ѯ
	if (typeof initCovObj != "undefined"){
		$('#TempCov').dhccSelect({
			url:LINK_CSP+"?ClassName=web.DHCEMNurAddOrder&MethodName=JsonQryOrderTempCov&LgUserID="+LgUserID+"&LgLocID="+LgLocID+"&LgHospID="+LgHospID,
			data:[{"id": initCovObj.id, "text": initCovObj.text}]
		});
		$("#TempCov").val(initCovObj.id).trigger("change");
	}else{
		$('#TempCov').dhccSelect({
			url:LINK_CSP+"?ClassName=web.DHCEMNurAddOrder&MethodName=JsonQryOrderTempCov&LgUserID="+LgUserID+"&LgLocID="+LgLocID+"&LgHospID="+LgHospID
		});
	}
}

/// ����Ĭ�ϵ�ҽ����
function LoadTempCovInitObj(){
	
	var initCovObj = {};
	/// ҽ�������Ʋ�ѯ
	var QueryParam = {"LgUserID":LgUserID, "LgLocID":LgLocID, "LgHospID":LgHospID};
	runClassMethod("web.DHCEMNurAddOrder","JsonQryOrderTempCov",QueryParam,function(jsonString){

		if (jsonString != null){
			var jsonObjArr = jsonString;
			initCovObj = jsonObjArr[0];
		}
	},'json',false)
	return initCovObj;
}

/// ���ظ���ģ��
function LoadUserTemp(){
	
	$(".template_div .row").hide();
	$("#itemList th:contains('����')").hide();
	$("#itemList th:contains('��λ')").hide();
	LoadTempItem("User.SSUser"); /// ����ģ��
}

/// ���ؿ���ģ��
function LoadLocTemp(){
	
	$(".template_div .row").hide();
	$("#itemList th:contains('����')").hide();
	$("#itemList th:contains('��λ')").hide();
	LoadTempItem("User.CTLoc"); /// ����ģ��
}

/// ����ҽ����ģ��
function LoadTempCov(){
	
	$(".template_div .row").show();
	$("#itemList th:contains('����')").show();
	$("#itemList th:contains('��λ')").show();
	$("#itemList tbody").html('');
	
	/// ��Ŀ����ѡ������ʱ,���²�ѯ
	if ($("#TempCov").val() != null){
		LoadTempItemCovDet($("#TempCov").val());
	}
}

function selectOnchang(obj){
	
	$("#TempCovCK").attr('checked',false);
	
	var value = obj.options[obj.selectedIndex].value;
	LoadTempItemCovDet(value);  /// ����ҽ��������
}

function selectExaItem(){
	
	/// ��鷽����ҽ����ID��ҽ�������ơ�
	var arcitmid = ""; var tempitmCov = "";
	var itmmaststr = this.value;    /// ��Ŀ���ݴ�
	if (itmmaststr == "") return;
		
	if ($(this).is(':checked')){
		/// ѡ�е���
		if (this.name == "ExaItemCov"){
			var itmmastArr = itmmaststr.split("^");
			arcitmid = itmmastArr[0];
			tempitmCov = itmmaststr;
		}else{
			if (itmmaststr.indexOf("ARCOS") != "-1"){
				var itmmastArr = itmmaststr.split("^");
				GetOrderTempCov(itmmastArr[2],1);  /// ȡҽ������ϸ��Ŀ
				return;
			}else{
				arcitmid = itmmaststr;
			}
		}
		$(this).attr('checked',false); /// ��ȡ��Ŀ��,��ѡ��ȡ��ѡ��״̬
		parent.addRowByTemp(arcitmid, tempitmCov);
	}
	/*else{
		if (this.name == "ExaItemCov"){
			var itmmastArr = itmmaststr.split("^");
			arcitmid = itmmastArr[0];
		}else{
			/// ȡ��ѡ�е���
			if (itmmaststr.indexOf("ARCOS") != "-1"){
				var itmmastArr = itmmaststr.split("^");
				GetOrderTempCov(itmmastArr[2],0);  /// ȡҽ������ϸ��Ŀ
				return;
			}else{
				arcitmid = itmmaststr;
			}
		}
		parent.delRowByTemp(arcitmid);
	}
	*/
}

/// ȡҽ������ϸ��Ŀ
function GetOrderTempCov(arccosid, flag){
	
	/// ����ģ��
	var QueryParam = {"ID":arccosid, "LgHospID":LgHospID};
	runClassMethod("web.DHCEMNurAddOrder","JsonQryOrderTempCovDet",QueryParam,function(jsonString){
		if ((jsonString != null)&(jsonString !="")){
			var jsonObjArr = jsonString;
			InsItemCovDet(jsonObjArr, flag);
		}else{
			//$.messager.alert("��ʾ","ҽ���׶�Ӧҽ����ϸΪ��,���ʵ�����ԣ�");
			parent.alertMsg("ҽ���׶�Ӧҽ����ϸΪ��,���ʵ�����ԣ�");
		}
	},'json',false)
}

/// ����ҽ������ϸ����
function InsItemCovDet(itemArr, flag){
	
	/// ��Ŀ
	for (var j=1; j<=itemArr.length; j++){
		if (flag == 1){
			var tempitmCov = itemArr[j-1].ItemRowid +"^"+ itemArr[j-1].ItemQty +"^"+ itemArr[j-1].ItemBillUomID +"^"+ itemArr[j-1].ItemBillUOM;
			parent.addRowByTemp(itemArr[j-1].ItemRowid, tempitmCov);
		}else{
			parent.delRowByTemp(itemArr[j-1].ItemRowid);
		}
	}
}

/// ȫѡ/ȫ��
function TempCovCKItem(){
	
	var TempCovCKFlag = false;
	if ($(this).is(':checked')){
		TempCovCKFlag = true;
	}
	//$(this).attr('checked',false);
	
	/// ѡ�л�ȡ��ҽ���׶�Ӧ��ϸ��Ŀ
	$("input[name='ExaItemCov']").each(function(){
		$(this).attr('checked',TempCovCKFlag);
		
		/// ��鷽����ҽ����ID��ҽ�������ơ�
		var arcitmid = ""; var tempitmCov = "";
		var itmmaststr = this.value;    /// ��Ŀ���ݴ�
		if (itmmaststr == "") return;
		var itmmastArr = itmmaststr.split("^");
		arcitmid = itmmastArr[0];
		tempitmCov = itmmaststr;
		if (TempCovCKFlag == true){
			parent.addRowByTemp(arcitmid, tempitmCov);
		}else{
			//parent.delRowByTemp(arcitmid);
		}
		$(this).attr('checked',false);
	})
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })