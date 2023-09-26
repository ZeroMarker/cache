/// author:    bianshuai
/// date:      2018-10-20
/// descript:  APACHE II评分列表

var ID = "";
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var ScoreArr = [{"value":"4","text":'4'}, {"value":"3","text":'3'}, {"value":"2","text":'2'}, {"value":"1","text":'1'}, {"value":"0","text":'0'}];
/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化加载病人就诊ID
	InitPatEpisodeID();
	
	//初始化咨询信息列表
	InitMainList();
	
	///初始化界面控件内容
	InitPageComponent();
	
	//初始化界面按钮事件
	InitWidListener();
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	
	PatientID = getParam("PatientID");   /// 就诊ID
	EpisodeID = getParam("EpisodeID");   /// 病人ID
}

/// 界面元素监听事件
function InitWidListener(){
	
	/// 复选框事件
	$HUI.checkbox("[type='checkbox']",{onChecked:function(){
		var TmpID = this.id;
		$("[name='"+this.name+"']").each(function(){
			if (TmpID != this.id){
				$HUI.checkbox("#"+this.id).setValue(false);
			}
		})
		SetApacheScore();  /// 重新计算分值
	}})
	
}

/// 初始化界面控件内容
function InitPageComponent(){
	
//	/// 分值
//	var option = {
//		panelHeight:"auto",
//        onSelect:function(option){
//	        SetApacheScore();  /// 重新计算分值
//	    }
//	};
//	var url = "";
//	
//	for (var i=1; i<=11; i++){
//		new ListCombobox("D_"+i,url,ScoreArr,option).init();
//	}
}

///初始化病人列表
function InitMainList(){
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,align:'center'},
		{field:'Scorce',title:'分值',width:100,align:'center'},
		{field:'CreUser',title:'创建人',width:100,align:'center'},
		{field:'CreDate',title:'创建日期',width:100,align:'center'},
		{field:'CreTime',title:'创建时间',width:100,align:'center'},
		{field:'UpdUser',title:'修改人',width:100,align:'center'},
		{field:'UpdDate',title:'修改日期',width:100,align:'center'},
		{field:'UpdTime',title:'修改时间',width:100,align:'center'}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		singleSelect : true,
        onClickRow:function(rowIndex, rowData){
	       ID = rowData.ID;
	       reLoadApache(rowData.ID);   /// 重新加载
	    }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCEMDocApache&MethodName=QryEmApache&EpisodeID="+EpisodeID+"&mType=APACHE";
	new ListComponent('main', columns, uniturl, option).Init();

}

/// 重新计算分值
function SetApacheScore(){
	
	/// A 年龄
	var A_Key = $("[name='A']:checked").attr('label');
	if (typeof A_Key != "undefined"){
		$("#A").text(A_Key);
	}else{
		A_Key = 0;
	}
	
	/// B．有严重器官系统功能不全或免疫损害
	var B_Key = $("[name='B']:checked").attr('label');
	if (typeof B_Key != "undefined"){
		$("#B").text(B_Key);
	}else{
		B_Key = 0;
	}
	
	/// C．GCS评分
	var C1_Key = $("[name='C-1']:checked").attr('val');
	if (typeof C1_Key == "undefined"){
		C1_Key = 0;
	}
	var C2_Key = $("[name='C-2']:checked").attr('val');
	if (typeof C2_Key == "undefined"){
		C2_Key = 0;
	}
	var C3_Key = $("[name='C-3']:checked").attr('val');
	if (typeof C3_Key == "undefined"){
		C3_Key = 0;
	}
	
	var C_Key = parseInt(C1_Key) + parseInt(C2_Key) + parseInt(C3_Key);
	$("#C1").text(C_Key);        /// GCS 积分=1+2+3
	$("#C2").text(15 - C_Key);   /// 积分=15—GCS
	
//	/// D．生理指标
//	var D_Key = 0;
//	for (var i=1; i<=11; i++){
//		var Key = $HUI.combobox("#D_"+i).getValue();
//		if (Key != ""){
//			D_Key = D_Key + parseInt(Key);
//		}
//	}
	/// D．生理指标
	var D_Key = 0;
	/// 1．体温（腋下℃）
	var D1_Key = $("[name='D-1']:checked").attr('val');
	if (typeof D1_Key == "undefined"){
		D1_Key = 0;
	}
	$("#D_1").text(D1_Key||"");
	D_Key = D_Key + parseInt(D1_Key);
	
	/// 2．平均血压（mmHg）
	var D2_Key = $("[name='D-2']:checked").attr('val');
	if (typeof D2_Key == "undefined"){
		D2_Key = 0;
	}
	$("#D_2").text(D2_Key||"");
	D_Key = D_Key + parseInt(D2_Key);
	
	/// 3.心率（次/分）
	var D3_Key = $("[name='D-3']:checked").attr('val');
	if (typeof D3_Key == "undefined"){
		D3_Key = 0;
	}
	$("#D_3").text(D3_Key||"");
	D_Key = D_Key + parseInt(D3_Key);
	
	/// 4．呼吸频率（次/分）
	var D4_Key = $("[name='D-4']:checked").attr('val');
	if (typeof D4_Key == "undefined"){
		D4_Key = 0;
	}
	$("#D_4").text(D4_Key||"");
	D_Key = D_Key + parseInt(D4_Key);
	
	/// 5．PaO2（mmHg）
	var D5_Key = $("[name='D-5']:checked").attr('val');
	if (typeof D5_Key == "undefined"){
		D5_Key = 0;
	}
	$("#D_5").text(D5_Key||"");
	D_Key = D_Key + parseInt(D5_Key);
	
	/// 6.动脉血 PH
	var D6_Key = $("[name='D-6']:checked").attr('val');
	if (typeof D6_Key == "undefined"){
		D6_Key = 0;
	}
	$("#D_6").text(D6_Key||"");
	D_Key = D_Key + parseInt(D6_Key);
	
	/// 7．血清 Na（mmol/L）
	var D7_Key = $("[name='D-7']:checked").attr('val');
	if (typeof D7_Key == "undefined"){
		D7_Key = 0;
	}
	$("#D_7").text(D7_Key||"");
	D_Key = D_Key + parseInt(D7_Key);
	
	/// 8．血清 K（mmol/L）
	var D8_Key = $("[name='D-8']:checked").attr('val');
	if (typeof D8_Key == "undefined"){
		D8_Key = 0;
	}
	$("#D_8").text(D8_Key||"");
	D_Key = D_Key + parseInt(D8_Key);
	
	/// 9．血清肌酐（mg/dL）
	var D9_Key = $("[name='D-9']:checked").attr('val');
	if (typeof D9_Key == "undefined"){
		D9_Key = 0;
	}
	$("#D_9").text(D9_Key||"");
	D_Key = D_Key + parseInt(D9_Key);
	
	/// 10.血球压积(%)
	var D10_Key = $("[name='D-10']:checked").attr('val');
	if (typeof D10_Key == "undefined"){
		D10_Key = 0;
	}
	$("#D_10").text(D10_Key||"");
	D_Key = D_Key + parseInt(D10_Key);
	
	/// 11.WBC(*1000)
	var D11_Key = $("[name='D-11']:checked").attr('val');
	if (typeof D11_Key == "undefined"){
		D11_Key = 0;
	}
	$("#D_11").text(D11_Key||"");
	D_Key = D_Key + parseInt(D11_Key);
	
	$("#D").text(D_Key);       /// D 积 分
	$("#Total").text(parseInt(A_Key) + parseInt(B_Key) + parseInt(C_Key) + parseInt(D_Key));   /// APACHEⅡ总积分=A+B+C+D
}

/// 保存APACHE II评分表
function SaveApache(){
	
	var ScArr = [];
	/// A 年龄
	var A_ID = $("[name='A']:checked").attr('id');
	if (typeof A_ID != "undefined"){
		ScArr.push("A"+":"+A_ID);
	}
	
	/// B．有严重器官系统功能不全或免疫损害
	var B_ID = $("[name='B']:checked").attr('id');
	if (typeof B_ID != "undefined"){
		ScArr.push("B"+":"+B_ID);
	}
	
	/// C．GCS评分
	var C_ID = $("[name='C-1']:checked").attr('id');
	if (typeof C_ID != "undefined"){
		ScArr.push("C-1"+":"+C_ID);
	}
	var C_ID = $("[name='C-2']:checked").attr('id');
	if (typeof C_ID != "undefined"){
		ScArr.push("C-2"+":"+C_ID);
	}
	var C_ID = $("[name='C-3']:checked").attr('id');
	if (typeof C_ID != "undefined"){
		ScArr.push("C-3"+":"+C_ID);
	}
	
	/// D．生理指标
//	for (var i=1; i<=11; i++){
//		var value = $HUI.combobox("#D_"+i).getValue();
//		ScArr.push("D_"+i+":"+value);
//	}
	/// 1．体温（腋下℃）
	var D1_ID = $("[name='D-1']:checked").attr('id');
	if (typeof D1_ID != "undefined"){
		ScArr.push("D-1"+":"+D1_ID);
	}
	
	/// 2．平均血压（mmHg）
	var D2_ID = $("[name='D-2']:checked").attr('id');
	if (typeof D2_ID != "undefined"){
		ScArr.push("D-2"+":"+D2_ID);
	}
	
	/// 3.心率（次/分）
	var D3_ID = $("[name='D-3']:checked").attr('id');
	if (typeof D3_ID != "undefined"){
		ScArr.push("D-3"+":"+D3_ID);
	}
	
	/// 4．呼吸频率（次/分）
	var D4_ID = $("[name='D-4']:checked").attr('id');
	if (typeof D4_ID != "undefined"){
		ScArr.push("D-4"+":"+D4_ID);
	}
	
	/// 5．PaO2（mmHg）
	var D5_ID = $("[name='D-5']:checked").attr('id');
	if (typeof D5_ID != "undefined"){
		ScArr.push("D-5"+":"+D5_ID);
	}
	
	/// 6.动脉血 PH
	var D6_ID = $("[name='D-6']:checked").attr('id');
	if (typeof D6_ID != "undefined"){
		ScArr.push("D-6"+":"+D6_ID);
	}
	
	/// 7．血清 Na（mmol/L）
	var D7_ID = $("[name='D-7']:checked").attr('id');
	if (typeof D7_ID != "undefined"){
		ScArr.push("D-7"+":"+D7_ID);
	}
	
	/// 8．血清 K（mmol/L）
	var D8_ID = $("[name='D-8']:checked").attr('id');
	if (typeof D8_ID != "undefined"){
		ScArr.push("D-8"+":"+D8_ID);
	}
	
	/// 9．血清肌酐（mg/dL）
	var D9_ID = $("[name='D-9']:checked").attr('id');
	if (typeof D9_ID != "undefined"){
		ScArr.push("D-9"+":"+D9_ID);
	}
	
	/// 10.血球压积(%)
	var D10_ID = $("[name='D-10']:checked").attr('id');
	if (typeof D10_ID != "undefined"){
		ScArr.push("D-10"+":"+D10_ID);
	}
	
	/// 11.WBC(*1000)
	var D11_ID = $("[name='D-11']:checked").attr('id');
	if (typeof D11_ID != "undefined"){
		ScArr.push("D-11"+":"+D11_ID);
	}
	
	/// 总分
	var Total = $("#Total").text();
	
	var mListData = EpisodeID +"^"+ LgUserID +"^"+ Total +"^"+ "APACHE" +"^"+ ScArr.join("#");

	//保存数据
	runClassMethod("web.DHCEMDocApache","Insert",{"ID":ID, "mListData":mListData},function(jsonString){

		if (jsonString <= 0){
			$.messager.alert('提示','保存失败！','warning');
			return;	
		}
		if (jsonString > 0){
			$.messager.alert('提示','保存成功！','warning');
			$('#main').datagrid('reload'); //重新加载
			return;	
		}
	},'',false)	
}

/// 重新加载
function reLoadApache(ApaID){
	
	/// 清空界面checkbox
	$HUI.checkbox("[type='checkbox']").setValue(false);
	var mListData = GetDocApache(ApaID);
	var ApaArr = mListData.split("#");
	for(var m=0; m< ApaArr.length; m++){
		var MapArr = ApaArr[m].split(":");
		$HUI.checkbox("#"+MapArr[1]).setValue(true);
//		if (MapArr[0].indexOf("D") == "-1"){
//			$HUI.checkbox("#"+MapArr[1]).setValue(true);
//		}else{
//			
//			$HUI.combobox("#"+MapArr[0]).setValue(MapArr[1]);
//		}
	}
	SetApacheScore();  /// 重新计算分值
}

/// 提起APACHE II评分内容
function GetDocApache(ID){
	
	var DocApache = "";
	runClassMethod("web.DHCEMDocApache","GetDocApache",{"ID":ID},function(jsonString){

		if (jsonString != ""){
			DocApache = jsonString;
		}
	},'',false)
	return DocApache;
}

/// 删除选中行
function deleteRow(){
	
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除该条数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCEMDocApache","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('提示','删除失败！','warning');
					}else{
						NewApache()	
					}
					ID = "";
					$('#main').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

/// 新建
function NewApache(){
	
	ID = "";
	/// 清空界面checkbox
	$HUI.checkbox("[type='checkbox']").setValue(false);
	
	/// D．生理指标
	for (var i=1; i<=11; i++){
		//$HUI.combobox("#D_"+i).setValue("");
		$("#D_"+i).text("");
	}
	
	$("#A").text("");
    $("#B").text("");
	$("#C1").text("");      /// GCS 积分=1+2+3
	$("#C2").text("");      /// 积分=15—GCS
	$("#D").text("");       /// D 积 分
	$("#Total").text("");   /// APACHEⅡ总积分=A+B+C+D
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })