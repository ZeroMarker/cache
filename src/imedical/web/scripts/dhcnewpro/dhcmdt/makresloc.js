//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-08-05
// 描述:	   mdt专家组选择界面
//===========================================================================================
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgName = session['LOGON.USERNAME'];  /// 用户ID
var ID = "";       /// 会诊ID
var DisGrpID = ""; /// 病种ID
var objid = "";
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
	Type = getParam("Type");   /// 类型
	if (Type == "G"){
		objid = "LocGrpList";
	}
	if (Type == "E"){
		objid = "OuterExpList";
	}
	_TableDom="";
	///单独安排界面
	if(window.parent.$("#"+objid).length){
		_TableDom=window.parent.$("#"+objid);
	}else{
		var len = window.parent.frames.length
		if(len){
			for (var index=0;index<len;index++){
				var thisUrl = window.parent.frames[index].location.href;
				if(thisUrl.indexOf("dhcmdt.consarrange.csp")!=-1){
					_TableDom= window.parent.frames[index].$("#"+objid);	
				}
			}	
		}	
	}
	
	///父界面弹出
	if(!_TableDom){
		if(window.parent.frames[0]){
			if(window.parent.frames[0].$){
				if(window.parent.frames[0].$("#"+objid).length){
					_TableDom=window.parent.frames[0].$("#"+objid);	
				}
			}
		}
	}
	
	//资料审查安排界面
	if(!_TableDom){
		if(window.parent.frames[2]){
			if(window.parent.frames[2].$){
				if(window.parent.frames[2].$("#"+objid).length){
					_TableDom=window.parent.frames[2].$("#"+objid);
				}
			}
		}
	}
}

/// 页面 Button 绑定事件
function InitBlButton(){
	$("#itemList").on("click",".checkbox",selectItem);
	$(".hisui-checkbox").on("click",selectItem);
}

/// 选中项目
function selectItem(){
	if ($(this).checkbox("getValue")){
		/// 选择科室 科室下专家组全部选中
		if (this.name == "LocArr"){
			$('input[name="ProDoc"][value="'+ this.id +'"]').checkbox("check");
		}
		/// 选择医生
		if (this.name == "ProDoc"){
			if (!$("input[name='LocArr'][id='"+ this.value +"']").is(':checked')){
				
				$("input[name='LocArr'][id='"+ this.value +"']").attr("checked","checked");
				$("input[name='LocArr'][id='"+ this.value +"']").next().attr("class","checkbox checked")
				//$("input[name='LocArr'][id='"+ this.value +"']").checkbox("check");
			}
		}
	}else{
		/// 取消科室 科室下专家组全部取消
		if (this.name == "LocArr"){
			$('input[name="ProDoc"][value="'+ this.id +'"]').checkbox("uncheck");
		}
		/// 选择医生
		if (this.name == "ProDoc"){
			if ($("input[name='ProDoc'][value='"+ this.value +"']:checked").length == 0){
				
				$("input[name='LocArr'][id='"+ this.value +"']").removeAttr("checked");
				$("input[name='LocArr'][id='"+ this.value +"']").next().attr("class","checkbox")
				//$("input[name='LocArr'][id='"+ this.value +"']").checkbox("uncheck");
			}
		}
	}
	
}

/// 初始化病种科室组
function InitDisGrpLocArr(){
	
	runClassMethod("web.DHCMDTConsultQuery","JsGetDisGrpLoc",{"GrpID":DisGrpID, "Type":Type},function(jsonObject){
		
		if (jsonObject != null){
			InsDisLocArea(jsonObject);
		}
	},'json',false)
}

/// 病种科室组
function InsDisLocArea(itemObjArr){
		
	var isdefaultflag = 1;
	var rowData = _TableDom.datagrid("getRows");
	
	if ((rowData)&&(rowData[0].LocID == "")) isdefaultflag = 0;
	/// 标题行
	var htmlstr = '<tr><td style="width:30px" class="center"></td><td style="width:150px" class="center"></td><td></td><td style="width:150px" class="center"></td><td></td><td style="width:150px" class="center"></td><td></td><td style="width:30px" class="center"></td><td></td>';
	for (var i=0; i<itemObjArr.length; i++){
		//htmlstr = htmlstr + '<tr><td colspan=8><input data-options="onChecked:function(event,val){checkfunc('+ itemObjArr[i].id +',\'LocArr\',\'\')},onUnchecked:function(event,val){uncheckfunc('+ itemObjArr[i].id +',\'LocArr\',\'\')}" id="'+ itemObjArr[i].id +'" name="LocArr" type="checkbox" class="hisui-checkbox" value="" label = "'+ (i + 1) + "、" + itemObjArr[i].text +'"></input></td><td></td></tr>';
		htmlstr = htmlstr + '<tr><td colspan=8><input id="'+ itemObjArr[i].id +'" name="LocArr" type="checkbox" class="hisui-checkbox" value="" label = "'+ (i + 1) + "、" + itemObjArr[i].text +'"></input></td><td></td></tr>';

		/// 项目
		var itemArr = itemObjArr[i].items;
		var itemhtmlArr = []; itemhtmlstr = "";
		for (var j=1; j<=itemArr.length; j++){
			if((itemArr[j-1].text==LgName)&(isdefaultflag == 0)){
			  itemhtmlArr.push('<td><input  id="'+ itemArr[j-1].value +'" name="ProDoc" type="checkbox" checked="checked" class="hisui-checkbox" data-id="" value="'+ itemObjArr[i].id +'" label = "'+  itemArr[j-1].text+'"></input></td><td></td>');
			  //itemhtmlArr.push('<td><input  data-options="onChecked:function(event,val){checkfunc('+ itemArr[j-1].value +',\'ProDoc\','+itemObjArr[i].id+')},onUnchecked:function(event,val){uncheckfunc('+ itemArr[j-1].value +',\'ProDoc\','+itemObjArr[i].id+')}"  id="'+ itemArr[j-1].value +'" name="ProDoc" type="checkbox" checked="checked" class="hisui-checkbox" data-id="" value="'+ itemObjArr[i].id +'" label = "'+  itemArr[j-1].text+'"></input></td><td></td>');

			}else{
				//itemhtmlArr.push('<td><input data-options="onChecked:function(event,val){checkfunc('+ itemArr[j-1].value +',\'ProDoc\','+itemObjArr[i].id+')},onUnchecked:function(event,val){uncheckfunc('+ itemArr[j-1].value +',\'ProDoc\','+itemObjArr[i].id+')}" id="'+ itemArr[j-1].value +'" name="ProDoc" type="checkbox" class="hisui-checkbox" data-id="" value="'+ itemObjArr[i].id +'" label = "'+  itemArr[j-1].text+'"></input></td></td><td></td>');
				itemhtmlArr.push('<td><input  id="'+ itemArr[j-1].value +'" name="ProDoc" type="checkbox" class="hisui-checkbox" data-id="" value="'+ itemObjArr[i].id +'" label = "'+  itemArr[j-1].text+'"></input></td></td><td></td>');

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
	$.parser.parse("#itemList");
}

/// 关闭弹出窗口
function TakClsWin(){

	$("#itemList").html("");
	if(window.parent.$("#mdtWin").length){
		if(window.parent.$("#mdtWin").attr("class")){
			if(window.parent.$("#mdtWin").hasClass("window-body")) window.parent.$("#mdtWin").window("close");        /// 关闭弹出窗口
		}
	}
	
	if(window.parent.$('#CommonWinArrange').length){
		commonParentCloseWinById('CommonWinArrange');
	}else{
		commonParentCloseWin();
	}
}

/// 获取选择的科室
function TakPreLoc(){
	
	var LocArr = [];
	var LocObjArr = $("input[name='ProDoc']:checked");
	for (var n=0; n<LocObjArr.length; n++){
		LocArr.push(LocObjArr[n].value +"^"+ LocObjArr[n].id +"^"+ $(LocObjArr[n]).attr("data-id"));
	}
	
	 _TableDom.datagrid("reload",{Params:LocArr.join("#")});

	TakClsWin(); /// 关闭弹出窗口
}

/// 初始化页面选中项
function InitLocSelect(){
	
	var rowData = _TableDom.datagrid('getRows');
	
	$.each(rowData, function(index, item){
		
		if(trim(item.LocDesc) != ""){
			if (!$("input[name='LocArr'][id='"+ item.LocID +"']").is(':checked')){
				$("input[name='LocArr'][id='"+ item.LocID +"']").attr("checked","checked");
				$("input[name='LocArr'][id='"+ item.LocID +"']").next().attr("class","checkbox checked")
				//$("input[name='LocArr'][id='"+ item.LocID +"']").checkbox("check");
			}
			if (!$("input[name='ProDoc'][id='"+ item.UserID +"']").is(':checked')){
				$("input[name='ProDoc'][id='"+ item.UserID +"']").checkbox("check");
			}
			
			$("input[name='ProDoc'][id='"+ item.UserID +"']").attr("data-id",item.itmID);
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