
var EpisodeID = "";   /// 当前编辑行号
var LgUserID = session['LOGON.USERID'];    /// 用户ID
var LgGroupID = session['LOGON.GROUPID'];  /// 安全组ID
var LgLocID = session['LOGON.CTLOCID'];    /// 科室ID
var LgHospID = session['LOGON.HOSPID'];    /// 医院ID

/// 加载模板
function LoadTempItem(ObjectType){
	
	/// 加载模板
	//$("#itemList tbody").html('<tr style="width:33px"><td style="width:40px;" align="center">选择</td><td>名称</td><td style="width:40px;" align="center">选择</td><td>名称</td></tr>');
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

/// 检查方法列表
function InitCheckItemRegion(itemArr){	
	/// 标题行
	var htmlstr = '';
		//htmlstr = '<tr style="height:30px"><td colspan="4" class=" tb_td_required" style="border:1px solid #ccc;"></td></tr>';

	/// 项目
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

/// 加载模板
function LoadTempItemCovDet(ID){
	
	/// 加载模板
	//$("#itemList tbody").html('<tr style="width:33px"><td style="width:40px;" align="center">选择</td><td>名称</td><td style="width:40px;" align="center">选择</td><td>名称</td></tr>');
	$("#itemList tbody").html('');
	var QueryParam = {"ID":ID, "LgHospID":LgHospID, "EpisodeID":EpisodeID};
	runClassMethod("web.DHCEMNurAddOrder","JsonQryOrderTempCovDet",QueryParam,function(jsonString){
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			InitCheckItemRegionCov(jsonObjArr);
		}
	},'json',false)
}

/// 检查方法列表
function InitCheckItemRegionCov(itemArr){	
	/// 标题行
	var htmlstr = '';
		//htmlstr = '<tr style="height:30px"><td colspan="4" class=" tb_td_required" style="border:1px solid #ccc;"></td></tr>';

	/// 项目
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

/// 页面初始化函数
function initPageDefault(){
	
	InitPatEpisodeID();   /// 初始化加载病人就诊ID
	initBlButton();       ///  页面Button绑定事件
	LoadUserTemp(); 	  /// 初始化加载个人模板
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	EpisodeID = getParam("EpisodeID");
}

///  页面Button绑定事件
function initBlButton(){
	
	$("a:contains('个人模板')").bind("click",LoadUserTemp);
	$("a:contains('科室模板')").bind("click",LoadLocTemp);
	$("a:contains('医嘱套')").bind("click",LoadTempCov);
	
	/// 点击复选框事件
	$("#itemList").on("click",".checkbox",selectExaItem);
	
	$("#TempCovCK").on("click",TempCovCKItem);
	
	/// 加载默认的医嘱套对象
	var initCovObj = LoadTempCovInitObj();

	///  医嘱套名称查询
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

/// 加载默认的医嘱套
function LoadTempCovInitObj(){
	
	var initCovObj = {};
	/// 医嘱套名称查询
	var QueryParam = {"LgUserID":LgUserID, "LgLocID":LgLocID, "LgHospID":LgHospID};
	runClassMethod("web.DHCEMNurAddOrder","JsonQryOrderTempCov",QueryParam,function(jsonString){

		if (jsonString != null){
			var jsonObjArr = jsonString;
			initCovObj = jsonObjArr[0];
		}
	},'json',false)
	return initCovObj;
}

/// 加载个人模板
function LoadUserTemp(){
	
	$(".template_div .row").hide();
	$("#itemList th:contains('数量')").hide();
	$("#itemList th:contains('单位')").hide();
	LoadTempItem("User.SSUser"); /// 加载模板
}

/// 加载科室模板
function LoadLocTemp(){
	
	$(".template_div .row").hide();
	$("#itemList th:contains('数量')").hide();
	$("#itemList th:contains('单位')").hide();
	LoadTempItem("User.CTLoc"); /// 加载模板
}

/// 加载医嘱套模板
function LoadTempCov(){
	
	$(".template_div .row").show();
	$("#itemList th:contains('数量')").show();
	$("#itemList th:contains('单位')").show();
	$("#itemList tbody").html('');
	
	/// 项目包含选择内容时,重新查询
	if ($("#TempCov").val() != null){
		LoadTempItemCovDet($("#TempCov").val());
	}
}

function selectOnchang(obj){
	
	$("#TempCovCK").attr('checked',false);
	
	var value = obj.options[obj.selectedIndex].value;
	LoadTempItemCovDet(value);  /// 加载医嘱套内容
}

function selectExaItem(){
	
	/// 检查方法【医嘱项ID、医嘱项名称】
	var arcitmid = ""; var tempitmCov = "";
	var itmmaststr = this.value;    /// 项目数据串
	if (itmmaststr == "") return;
		
	if ($(this).is(':checked')){
		/// 选中调用
		if (this.name == "ExaItemCov"){
			var itmmastArr = itmmaststr.split("^");
			arcitmid = itmmastArr[0];
			tempitmCov = itmmaststr;
		}else{
			if (itmmaststr.indexOf("ARCOS") != "-1"){
				var itmmastArr = itmmaststr.split("^");
				GetOrderTempCov(itmmastArr[2],1);  /// 取医嘱套明细项目
				return;
			}else{
				arcitmid = itmmaststr;
			}
		}
		$(this).attr('checked',false); /// 获取项目后,复选框取消选中状态
		parent.addRowByTemp(arcitmid, tempitmCov);
	}
	/*else{
		if (this.name == "ExaItemCov"){
			var itmmastArr = itmmaststr.split("^");
			arcitmid = itmmastArr[0];
		}else{
			/// 取消选中调用
			if (itmmaststr.indexOf("ARCOS") != "-1"){
				var itmmastArr = itmmaststr.split("^");
				GetOrderTempCov(itmmastArr[2],0);  /// 取医嘱套明细项目
				return;
			}else{
				arcitmid = itmmaststr;
			}
		}
		parent.delRowByTemp(arcitmid);
	}
	*/
}

/// 取医嘱套明细项目
function GetOrderTempCov(arccosid, flag){
	
	/// 加载模板
	var QueryParam = {"ID":arccosid, "LgHospID":LgHospID};
	runClassMethod("web.DHCEMNurAddOrder","JsonQryOrderTempCovDet",QueryParam,function(jsonString){
		if ((jsonString != null)&(jsonString !="")){
			var jsonObjArr = jsonString;
			InsItemCovDet(jsonObjArr, flag);
		}else{
			//$.messager.alert("提示","医嘱套对应医嘱明细为空,请核实后再试！");
			parent.alertMsg("医嘱套对应医嘱明细为空,请核实后再试！");
		}
	},'json',false)
}

/// 插入医嘱套明细内容
function InsItemCovDet(itemArr, flag){
	
	/// 项目
	for (var j=1; j<=itemArr.length; j++){
		if (flag == 1){
			var tempitmCov = itemArr[j-1].ItemRowid +"^"+ itemArr[j-1].ItemQty +"^"+ itemArr[j-1].ItemBillUomID +"^"+ itemArr[j-1].ItemBillUOM;
			parent.addRowByTemp(itemArr[j-1].ItemRowid, tempitmCov);
		}else{
			parent.delRowByTemp(itemArr[j-1].ItemRowid);
		}
	}
}

/// 全选/全销
function TempCovCKItem(){
	
	var TempCovCKFlag = false;
	if ($(this).is(':checked')){
		TempCovCKFlag = true;
	}
	//$(this).attr('checked',false);
	
	/// 选中或取消医嘱套对应明细项目
	$("input[name='ExaItemCov']").each(function(){
		$(this).attr('checked',TempCovCKFlag);
		
		/// 检查方法【医嘱项ID、医嘱项名称】
		var arcitmid = ""; var tempitmCov = "";
		var itmmaststr = this.value;    /// 项目数据串
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

/// JQuery 初始化页面
$(function(){ initPageDefault(); })