//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-08-05
// 描述:	   mdt专家组选择界面
//===========================================================================================
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgName = session['LOGON.USERNAME'];  /// 用户ID
var ID = "";       /// 会诊ID
var DisGrpID = ""; /// 病种ID
/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化加载ID
	InitPatEpisodeID(); 
	
	/// 初始化病种科室组
	InitDisGrpLocArr();
	
	/// 页面Button绑定事件
	InitBlButton();
	
	/// 初始化页面选中项
	InitLocSelect();
	
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){

	ID = getParam("ID");               /// 会诊ID
	DisGrpID = getParam("DisGrpID");   /// 病种ID
}

/// 页面 Button 绑定事件
function InitBlButton(){

	$("#itemList").on("click",".checkbox",selectItem);
}

/// 选中项目
function selectItem(){
	
	if ($(this).is(':checked')){
		/// 选择科室 科室下专家组全部选中
		if (this.name == "LocArr"){
			$('[name="ProDoc"][value="'+ this.id +'"]').prop("checked",true);
		}
		/// 选择医生
		if (this.name == "ProDoc"){
			if (!$("input[name='LocArr'][id='"+ this.value +"']").is(':checked')){
				$("input[name='LocArr'][id='"+ this.value +"']").prop("checked",true);	
			}
		}
	}else{
		/// 取消科室 科室下专家组全部取消
		if (this.name == "LocArr"){
			$('[name="ProDoc"][value="'+ this.id +'"]').prop("checked",false);
		}
		/// 选择医生
		if (this.name == "ProDoc"){
			if ($("input[name='ProDoc'][value='"+ this.value +"']:checked").length == 0){
				$("input[name='LocArr'][id='"+ this.value +"']").prop("checked",false);	
			}
		}
	}
	
}

/// 初始化病种科室组
function InitDisGrpLocArr(offset){
	
	runClassMethod("web.DHCMDTConsultQuery","JsGetDisGrpLoc",{"GrpID":DisGrpID},function(jsonObject){
		
		if (jsonObject != null){
			InsDisLocArea(jsonObject);
		}
	},'json',false)
}

/// 病种科室组
function InsDisLocArea(itemObjArr){
	/// 标题行
	var htmlstr = '<tr><td style="width:30px" class="center"></td><td style="width:30px" class="center"></td><td></td><td style="width:30px" class="center"></td><td></td><td style="width:30px" class="center"></td><td></td><td style="width:30px" class="center"></td><td></td>';
	for (var i=0; i<itemObjArr.length; i++){
		htmlstr = htmlstr + '<tr><td><input id="'+ itemObjArr[i].id +'" name="LocArr" type="checkbox" class="checkbox" value=""></input></td><td colspan="8" class="tb_td_required" style="border:1px dotted #ccc;">'+ (i + 1) + "、" + itemObjArr[i].text +'</td></tr>';

		/// 项目
		var itemArr = itemObjArr[i].items;
		var itemhtmlArr = []; itemhtmlstr = "";
		for (var j=1; j<=itemArr.length; j++){
			if(itemArr[j-1].text==LgName){
			  itemhtmlArr.push('<td><input id="'+ itemArr[j-1].value +'" name="ProDoc" type="checkbox" checked="checked" class="checkbox" value="'+ itemObjArr[i].id +'"></input></td><td>'+ itemArr[j-1].text +'</td>');
			}else{
				itemhtmlArr.push('<td><input id="'+ itemArr[j-1].value +'" name="ProDoc" type="checkbox" class="checkbox" value="'+ itemObjArr[i].id +'"></input></td><td>'+ itemArr[j-1].text +'</td>');
				}
			
			if (j % 4 == 0){
				itemhtmlstr = itemhtmlstr + '<tr><td></td>' + itemhtmlArr.join("") + '</tr>';
				itemhtmlArr = [];
			}
		}
		if ((j-1) % 4 != 0){
			var itemfixArr = [];
			var Len = (j-1) % 4;
			for (var m=4; m>Len; m--){
				itemfixArr.push("<td></td><td></td>"); 
			}
			itemhtmlstr = itemhtmlstr + '<tr><td></td>' + itemhtmlArr.join("") + itemfixArr.join("") +'</tr>';
			itemhtmlArr = [];
		}
		htmlstr = htmlstr + itemhtmlstr;
	}
	$("#itemList").append(htmlstr);
}

/// 关闭弹出窗口
function TakClsWin(){

	$("#itemList").html("");
	window.parent.$("#mdtWin").window("close");        /// 关闭弹出窗口
}

/// 获取选择的科室
function TakPreLoc(){
	
	var LocArr = [];
	var LocObjArr = $("input[name='ProDoc']:checked");
	for (var n=0; n<LocObjArr.length; n++){
		LocArr.push(LocObjArr[n].value +"^"+ LocObjArr[n].id);
	}
	
	window.parent.$("#LocGrpList").datagrid("reload",{Params:LocArr.join("#")});
	TakClsWin(); /// 关闭弹出窗口
}

/// 初始化页面选中项
function InitLocSelect(){
	
	var rowData = window.parent.$("#LocGrpList").datagrid('getRows');
	$.each(rowData, function(index, item){
		if(trim(item.LocDesc) != ""){
			if (!$("input[name='LocArr'][id='"+ item.LocID +"']").is(':checked')){
				$("input[name='LocArr'][id='"+ item.LocID +"']").attr("checked",true);
			}
			if (!$("input[name='ProDoc'][id='"+ item.UserID +"']").is(':checked')){
				$("input[name='ProDoc'][id='"+ item.UserID +"']").attr("checked",true);
			}
		}
	})
}

/// 自动设置图片展示区分布
function onresize_handler(){
	
	var Width = document.body.offsetWidth;
	var Height = document.body.scrollHeight;
}

/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {
	
	/// 自动分布
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })