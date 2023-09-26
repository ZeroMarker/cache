
/// Creator:	bianshaui
/// CreateDate: 2016-04-29

var PatientID = "";
var EpisodeID = "";
var selectedRow = "";
var lastitemid = "";
var arItemIdList = "";
$(function(){
	
	EpisodeID = getParam("EpisodeID");

	/// 检查项目
	GetCheckItem();
	
	/// 病人基本信息
	GetPatBaseInfo();
	
	/// 初始化界面默认信息
	InitDefault();
	
	/// 初始化界面按钮事件
	InitElListener();
})

/// 初始化界面默认信息
function InitDefault(){
		
	$("#PS span").live('click',function(){
		///  检查是否创建项目栏
		createCheckItemLabel();
		///  检查是否创建项目明细栏
		isCreateItemLabel();
		///  创建项目标签
		createLabel("PS_"+this.id,$(this).text());
		//alert($(this).text()+"12345");
	})
	LoadCellTip();  ///加载默认提示信息
	
	/// 复选框选择事件
	$("input[type=checkbox]").click(function(){
		var tmpid=this.id;
		if($('#'+tmpid).is(':checked')){
			$("input[type=checkbox][name="+this.name+"]").each(function(){
				if((this.id!=tmpid)&($('#'+this.id).is(':checked'))){
					$('#'+this.id).removeAttr("checked");
				}
			})
		}
	});
	
	/// 注意事项
	LoadArcItemNoteTemp();
	
	/// 设置模板界面选择标签项
	setTempTitleItem();
}

/// 界面元素监听事件
function InitElListener(){
	
	///标签删除事件
	$(".selector-set .ss-item i").live('click',function(){
		$(this).parent().remove();
		///标签id
		var ss_itemdesc = $(this).parent().find("b").text();
		if (ss_itemdesc != "" ){
			$('span:contains("'+ss_itemdesc+'")').parent().css({"background":"","color":""});
		}
	})
	
	///检查项目
	$(".item—list span").live('click',function(){
		//tempSaveOtherOpt(this.id);   ///临时保存其他项目值
		GetCheckPart(this.id);		   ///初始化部位
		GetCheckMethod(this.id);   	   ///初始化检查方法
		GetOtherOpt(this.id);          ///初始化其他项目
		reLoadItemExsitArcOTH(this.id);     ///同时加载已选择医嘱项目对应其他项目列表
		tempSetOtherOpt(this.id);      ///存在其他项目临时值时,设置界面数据
		clearComponentSelect();
		lastitemid = this.id;
	})
	
	///项目标签点击事件
	$(".item—list ul li").live('click',function(){
		$(this).css({"background":"#5994F8","color":"#FFFFFF"})
			.siblings().css({"background":"#D5FAC0","color":""});
		$(this).addClass("ul-li-selected").siblings().removeClass("ul-li-selected");
		selectedRow = "";  /// 切换项目时,选中行变量同时清空
	})
	
	///项目标签点击事件
	$(".ui-div-cell-panel ul li").live('click',function(){
		$(this).css({"background":"#5994F8","color":"#FFFFFF"})
			.siblings().css({"background":"#D5FAC0","color":""});
	})
	
	///检查大部位点击事件
	$("#PA span").live('click',function(){
		GetCheckSubPart(this.id);  ///加载子项目
	})
		
	///检查后处理方法
	$("#AC span").live('click',function(){
		GetCheckPosition(this.id); 	  ///初始化体位
		GetDispMedthod(this.id);      ///初始化后处理方法
		GetArcOtherOpt(this.id,"");   ///初始化其他项目
	})
	
	 ///选中行
	$(".crumbs-nav").live('click',function(){
		$('.crumbs-nav').css({"background":""});
		$(this).css({"background":"#5994F8"});
		selectedRow = $(this).parent().attr("id");
		LoadOtherOpt($(this).parent().attr("id"));  /// 默认加载项目对应其他选项
	})
	
	/// 增加编辑行
	$(".selected_list .icon-plus").live('click',function(){
		createItemLabel(this.id);
	})
	
	/// 删除面板
	$(".selected_list .icon-remove").live('click',function(){
		//delItemPanel(this.id);
		delAppRep(this.id);
		initAppRepItemList();  ///隐藏项目列表区域
	})
	
	/// 添加标签
	$("#AC span,#PO span,#DM span").live('click',function(){
		var itemid = $(this).parent().parent().parent().parent().attr("id");
		createLabel(itemid+"_"+this.id,$(this).text());
	})
	
	/// 按钮
	$("a:contains('打印')").live('click',function(){
		//$.messager.alert("提示:","此功能，正在研发中...；更多精彩请稍后继续！");
		print(arItemIdList);
	})
	
	/// 按钮
	$("a:contains('历史申请')").live('click',function(){
		createHisReqWin(LoadAppHisReq);
	})
	
	/// 按钮
	$("a:contains('常用模板')").live('click',function(){
		createAppArcTempWin(LoadAppArcTemp);
	})
	
	/// 按钮
	$("a:contains('发送')").live('click',function(){
		saveItem();
	})
	
	/// 其他项目点击事件 select
	$('.table-border select').live('change',function(){
		//this.id +"#"+ this.value +"#"+ "Combox"
		insTempOtherOpt(this.id,this.value,"Combox");
	})
	
	/// 其他项目点击事件 text
	$('.table-border input[type=text]').live('change',function(){
		//this.id +"#"+ this.value +"#"+ "Input"
		insTempOtherOpt(this.id,this.value,"Input");
	})
	
	/// 其他项目点击事件 checkbox
	$('.table-border input[type=checkbox]').live('change',function(){
		//this.id +"#"+ "Y" +"#"+ "Check"
		var flag = "N";
		if ($(this).is(':checked')){
			flag = "Y";
		}
		insTempOtherOpt(this.id,flag,"Check");
	})
	
	/// 关闭注意事项窗体
	$('.div-notes-title i').live('click',function(){
		$(".div-notes").css({display:'none'});	
	})
}

/// 保存临时
function insTempOtherOpt(itemid,val,type){
	
	var axis = $('#'+itemid).parent().parent().attr("axis");
	var id = axis.split("_")[1];
	var otheroptstr = $('#'+id+' .selector-set-othpt').text();
	var otheroptArr = [];flag = 0;
	if (otheroptstr != ""){
		otheroptArr = otheroptstr.split("$");
		for(var l=0;l<otheroptArr.length;l++){
			var otheropt = otheroptArr[l];
			if ((otheropt.split("#")[0] == itemid)&(otheropt.split("#")[2] == type)){
				 otheroptArr[l] = itemid +"#"+ val +"#"+ type;
				 flag = 1;
			}
		}
		if (flag == 0){
			otheroptArr.push(itemid +"#"+ val +"#"+ type);
		}
	}else{
		otheroptArr.push(itemid +"#"+ val +"#"+ type);
	}
	$('#'+id+' .selector-set-othpt').text(otheroptArr.join("$"));
}
/**
 * 	病人就诊信息
 */
function GetPatBaseInfo(){
	runClassMethod("web.DHCAPPComDataUtil","GetPatEssInfo",{"PatientID":PatientID, "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
		})
	},'json',false)
}

/**
 * 	检查分类
 */
function GetCheckItem(){

	var htmlstr = "";
	$('.item—list').append('<div class="ui-div-cell-panel"><ul></ul></div>');
	runClassMethod("web.DHCAPPComDataUtil","GetArcCat",{"HospID":LgHospID},function(jsonString){
		var jsonObjArr = jsonString;

		for (var i=0; i<jsonObjArr.length; i++){
			htmlstr = htmlstr + '<li><span id="'+ jsonObjArr[i].ArcCatID +'">'+ jsonObjArr[i].ArcCatDesc +'</span></li>';
		}
		$('.item—list .ui-div-cell-panel ul').append(htmlstr);
	},'json',false)
}

/**
 * 	检查部位区域
 */
function GetCheckPart(itemCatID){

	var htmlstr = "";
	$('#PA').html('');
	$('#PA').append('<div class="ui-div-cell-panel"><ul></ul></div>');
	runClassMethod("web.DHCAPPComDataUtil","GetCheckPart",{"itemCatID":itemCatID, "HospID":LgHospID},function(jsonString){
		
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				htmlstr = htmlstr + '<li><span id="'+ jsonObjArr[i].PartID +'">'+ jsonObjArr[i].PartDesc +'</span></li>';
			}
			$('#PA ul').append(htmlstr);
			if (!$('#PA').parent().is(":visible")){
				$("#PA").parent().show('fast');
			}
		}else{
			if ($('#PA').parent().is(":visible")){
				$("#PA").parent().hide('fast');
				$("#PS").parent().hide('fast');
			}
		}
	},'json',false)
}

/**
 * 	检查部位二级区域
 */
function GetCheckSubPart(arcCatLPID){

	var htmlstr = "";	
	$('#PS').html('');
	$('#PS').append('<div class="ui-div-cell-panel"><ul></ul></div>');
	runClassMethod("web.DHCAPPComDataUtil","GetCheckSubPart",{"arcCatLPID":arcCatLPID, "HospID":LgHospID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				htmlstr = htmlstr + '<li><span id="'+ jsonObjArr[i].PartID +'">'+ jsonObjArr[i].PartDesc +'</span></li>';
			}
			$('#PS ul').append(htmlstr);
			if (!$('#PS').parent().is(":visible")){
				$("#PS").parent().show('fast');
			}
		}else{
			if ($('#PS').parent().is(":visible")){
				$("#PS").parent().hide('fast');
			}
		}
	},'json',false)
}

/**
 * 	检查方法
 */
function GetCheckMethod(itemCatID){

	var htmlstr = "";

	$('#AC').html('');
	$('#AC').append('<div class="ui-div-cell-panel"><ul></ul></div>');
	runClassMethod("web.DHCAPPComDataUtil","GetCheckMethod",{"itemCatID":itemCatID, "HospID":LgHospID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				htmlstr = htmlstr + '<li><span id="'+ jsonObjArr[i].arcimid +'">'+ jsonObjArr[i].arcitmdesc +'</span></li>';
			}
			$('#AC ul').append(htmlstr);
			if (!$('#AC').parent().is(":visible")){
				$("#AC").parent().show('fast');
			}
		}else{
			if ($('#AC').parent().is(":visible")){
				$("#AC").parent().hide('fast');
			}
		}
	},'json',false)
}

/**
 * 	检查体位
 */
function GetCheckPosition(itmmastid){

	var htmlstr = "";
	//$('#PO').html('');
	if ($("#PO").parent().parent().is(":visible")){
		$("#PO").parent().parent().hide('slow');
	}
	$('#PO').html('');
	$('#PO').append('<div class="ui-div-cell-panel"><ul></ul></div>');
	runClassMethod("web.DHCAPPComDataUtil","GetCheckPosition",{"itmmastid":itmmastid, "HospID":LgHospID},function(jsonString){
		
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				htmlstr = htmlstr + '<li><span id="'+ jsonObjArr[i].PosiID +'">'+ jsonObjArr[i].PosiDesc +'</span></li>';
			}
			$('#PO ul').append(htmlstr);
			$('#PO').parent().css({"display":""});
			$("#PO").parent().parent().show('fast');
		}else{
			$('#PO').parent().css({"display":"none"});
			if (!$('#DM').parent().is(":visible")){
				$("#PO").parent().parent().hide('slow');
			}
		}
	},'json',false)
}

/**
 * 	后处理字典
 */
function GetDispMedthod(itmmastid){

	var htmlstr = "";

	$('#DM').html('');   ////清空后处理字典项目区域
	$('#DM').append('<div class="ui-div-cell-panel"><ul></ul></div>');
	runClassMethod("web.DHCAPPComDataUtil","GetDispMedthod",{"itmmastid":itmmastid, "HospID":LgHospID},function(jsonString){
		
		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				htmlstr = htmlstr + '<li><span id="'+ jsonObjArr[i].DispMID +'">'+ jsonObjArr[i].DispMDesc +'</span></li>';
			}
			$('#DM ul').append(htmlstr);
			$('#DM').parent().css({"display":""});
			if (!$('#PO').parent().is(":visible")){
				$("#DM").parent().parent().show('fast');
			}
		}else{
			$('#DM').parent().css({"display":"none"});
			if (!$('#PO').parent().is(":visible")){
				$("#DM").parent().parent().hide('slow');
				
			}
		}
	},'json',false)
}

/**
 * 	其他项目
 */
function GetOtherOpt(itemCatID){

	var htmlstr = "";
	var htmlArr = [];
	$('table.table-border tbody').html('');
	runClassMethod("web.DHCAPPComDataUtil","GetOtherOpt",{"itemCatID":itemCatID, "HospID":LgHospID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				htmlstr = htmlstr + '<td align="center">'+ jsonObjArr[i].OptiDesc +'</td>';
				if (jsonObjArr[i].OptiType == "Combox"){
					htmlstr = htmlstr + '<td><select  id="s_'+ jsonObjArr[i].OptiID +'" style="width:100%;height:30px;border:none;">';
						htmlstr = htmlstr + '<option value=""></option>';
						for (var j=0; j<jsonObjArr[i].ChildSubDesc.length; j++){
							htmlstr = htmlstr + '<option value="'+ jsonObjArr[i].ChildSubDesc[j].OptItmID +'">'+ jsonObjArr[i].ChildSubDesc[j].OptItmDesc +'</option>';
						}
					htmlstr = htmlstr + '</select></td>';
				}else if (jsonObjArr[i].OptiType == "Check"){
					htmlstr = htmlstr + '<td align="center"><input id="c_'+ jsonObjArr[i].OptiID +'" type="checkbox"></input></td>';
				}else{
					htmlstr = htmlstr + '<td align="center"><input id="i_'+ jsonObjArr[i].OptiID +'" type="text" style="width:98%;height:22px;background:#FCF5E0;border:none;"></input></td>';
				}
				if ((i+1)%3 == 0){
					htmlArr.push(htmlstr);
					htmlstr = "";
				}
			}
			if (htmlstr != ""){
				htmlstr = htmlstr + (i%3 == 2?"<td></td><td></td>":"<td></td><td></td><td></td><td></td>");
				htmlArr.push(htmlstr);
			}
			htmlstr = '<tr axis="I_'+itemCatID+'">' + htmlArr.join('</tr><tr axis="I_'+itemCatID+'">') + '</tr>';
			$('table.table-border tbody').append(htmlstr);
			$('.table-border').parent().parent().show('fast');
		}else{
			$('.table-border').parent().parent().hide('slow');
		}
	},'json',false)
}

/**
 * 	医嘱项其他项目
 */
function GetArcOtherOpt(itmmastid,itemid){
	
	var htmlstr = "";
	var htmlArr = [];

	if (itemid == ""){
		var itemid = "";
		if ($('.ul-li-selected span').length){
			itemid = $('.ul-li-selected span').attr("id"); ///项目标示
		}
	}
	if ($('.table-border tr[axis="I_'+itemid+'_'+itmmastid+'"]').length){
		return;
	}

	/// 删除医嘱项对应的其他项目列表
	$('.table-border tbody tr[axis^="I"]').each(function(){
		var axis = $(this).attr("axis");
		var itemid = axis.split("_")[2];
		if (typeof itemid != "undefined"){
			if (!$('em:contains("'+ itemid +'")').length){
				$(this).remove();}
		}
	})
	
	runClassMethod("web.DHCAPPComDataUtil","GetArcOtherOpt",{"itmmastid":itmmastid, "HospID":LgHospID},function(jsonString){

		if (jsonString != ""){
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				htmlstr = htmlstr + '<td align="center">'+ jsonObjArr[i].OptiDesc +'</td>';
				
				if (jsonObjArr[i].OptiType == "Combox"){
					htmlstr = htmlstr + '<td><select id="s_'+ jsonObjArr[i].OptiID +'" style="width:100%;height:30px;border:none;">';
						htmlstr = htmlstr + '<option value=""></option>';
						for (var j=0; j<jsonObjArr[i].ChildSubDesc.length; j++){
							htmlstr = htmlstr + '<option value="'+ jsonObjArr[i].ChildSubDesc[j].OptItmID +'">'+ jsonObjArr[i].ChildSubDesc[j].OptItmDesc +'</option>';
						}
					htmlstr = htmlstr + '</select></td>';
				}else if (jsonObjArr[i].OptiType == "Check"){
					htmlstr = htmlstr + '<td align="center"><input id="c_'+ jsonObjArr[i].OptiID +'" type="checkbox"></input></td>';
				}else{
					htmlstr = htmlstr + '<td align="center"><input id="i_'+ jsonObjArr[i].OptiID +'" type="text" style="width:98%;height:22px;background:#FCF5E0;border:none;"></input></td>';
				}
				if ((i+1)%3 == 0){
					htmlArr.push(htmlstr);
					htmlstr = "";
				}
			}
			
			if (htmlstr != ""){
				htmlstr = htmlstr + (i%3 == 2?"<td></td><td></td>":"<td></td><td></td><td></td><td></td>");
				htmlArr.push(htmlstr);
			}
			htmlstr = '<tr axis="I_'+itemid+'_'+itmmastid+'">' + htmlArr.join('</tr><tr axis="I_'+itemid+'_'+itmmastid+'">') + '</tr>';
			//$('table tbody').html('');
			$('table.table-border tbody').append(htmlstr);
			$('.table-border').parent().parent().show('fast');
		}
	},'json',false)	
}

/**
 * 	接收科室
 */
function GetCatRecLoc(itemCatID){
	var htmlstr = '';
	runClassMethod("web.DHCAPPComDataUtil","GetCatRecLoc",{"EpisodeID":EpisodeID,"arItemCatID":itemCatID},function(jsonString){
		var jsonObjArr = jsonString;
		for (var i=0; i<jsonObjArr.length; i++){
			htmlstr = htmlstr + '<option value="'+ jsonObjArr[i].LocID +'">'+ jsonObjArr[i].LocDesc +'</option>';
		}
	},'json',false)
	$('#'+itemCatID+' .select').html('').append(htmlstr);
}

///创建检查项目栏
function createCheckItemLabel(){
	
	var id = ""; desc="";	 ///项目标示
	if ($('.ul-li-selected span').length){
		id = $('.ul-li-selected span').attr("id");
		desc = $('.ul-li-selected span').text();		
		/// 创建检查项目面板
		LoadCheckItemLabel(id, desc);		
		/// 加载接收科室
		GetCatRecLoc(id);
	}
}

///创建检查项目栏
function LoadCheckItemLabel(id, desc){
	
	if ($('div#'+id).length){
		//$.messager.alert("提示:","已有选择项目!");
		return;
	}
	
	var left="";
	var Len = desc.replace(/[^x00-xFF]/g,'**').length;
	left = 100 - 7*Len;  //sufan 2016年7月11日
	var htmlstr = '';
	htmlstr = htmlstr + '<div id="'+ id +'" class="ui-div-m-l5-r0 select-list-panel" data-id="">';
	htmlstr = htmlstr + '	<div style="padding-top:5px;">';
	htmlstr = htmlstr + '		<span class="select-title">' +desc+'</span>';
	htmlstr = htmlstr +	'		<select class="select" style="margin-left:'+ left +'px;">';
	htmlstr = htmlstr +	'		</select>';
	htmlstr = htmlstr + '		<a href="#" title="新增检查记录"><i id="'+ id +'" class="icon-plus"></i></a>';
	htmlstr = htmlstr + '		<a href="#" title="清空全部检查记录"><i id="'+ id +'" class="icon-remove"></i></a>';
	htmlstr = htmlstr + '		<span class="selector-set-othpt"></span>';
	htmlstr = htmlstr + '	</div>';
	htmlstr = htmlstr + '	<div class="select-list-row">';
	htmlstr = htmlstr + '	</div>';
	htmlstr = htmlstr + '</div>';

	$('.selected_list').append(htmlstr);
}

/// 创建检查项列表标签
function createItemLabel(id){

	var isExsItmmast = "";
	$('#'+id+' .clearfix:last .selector-set span').each(function(){
		if ($(this).find("em").text().indexOf("AC") != "-1"){isExsItmmast=1;}
	})
	if (($('#'+id+' .clearfix').length > 0)&(isExsItmmast != 1)){
		$.messager.alert("提示:","最后一项缺少检查方法不能增加新行,请核实！");
		return;
	}
	/*
	var id = ""; 	 ///项目标示
	if ($('.ul-li-selected span').length){
		id = $('.ul-li-selected span').attr("id");
	}
	*/

	var rowNum = ""; ///行号
	rowNum = $('#'+ id +' .clearfix').length + 1;
	
	var rowid = id +'_row_'+ rowNum;

	var htmlstr = '';
		htmlstr = htmlstr + '<div id="'+ id +'_row_'+ rowNum +'" class="clearfix">';
		htmlstr = htmlstr + '	 <div class="crumbs-nav">';
		htmlstr = htmlstr + '	 	 <div class="crumbs-nav-item">';
		htmlstr = htmlstr + '	 		<div class="sl-v-list">';
		htmlstr = htmlstr + '	 			<ul>';
		htmlstr = htmlstr + '	 				<li><a href="#" id="'+id +'_row_'+ rowNum+'"><i class="icon-warn"></i></a></li>';
		htmlstr = htmlstr + '	 				<li><a href="#" title="保存模板" onclick="newCreateSaveForWin(\''+ rowid +'\')"><i class="icon-save"></i></a></li>';
		htmlstr = htmlstr + '	 				<li><a href="#" title="删除" onclick="delItemLabel(\''+ rowid +'\')"><i class="icon-cross"></i></a></li>';
		htmlstr = htmlstr + '	 			</ul>';
		htmlstr = htmlstr + '	 		</div>';
		htmlstr = htmlstr + '	 	 </div>';
		htmlstr = htmlstr + '	 	 <div class="crumbs-nav-item">';
		htmlstr = htmlstr + '	 	 	<div class="selector-set">';
		htmlstr = htmlstr + '	 	 	</div>';
		htmlstr = htmlstr + '	 	 </div>';
		htmlstr = htmlstr + '	 </div>';
		htmlstr = htmlstr + '</div>';

		$('#'+ id +' .select-list-row').append(htmlstr);
		$('.crumbs-nav').css({"background":""});
		$('#'+ (id +'_row_'+ rowNum + ' .crumbs-nav')).css({"background":"#5994F8"});
		
		selectedRow = id +'_row_'+ rowNum;
}

/// 重新加载已选择的医嘱项目对应其他项目列表
function reLoadItemExsitArcOTH(id){

	$('#'+id+' em:contains("AC")').each(function(){
		var itmmastid = $(this).text().split("_")[1];
		GetArcOtherOpt(itmmastid, id);
	})
}

/// 检查是否需要创建项目明细栏,需要则创建
function isCreateItemLabel(){
	
	var itemid = ""; 	 ///项目标示
	if ($('.ul-li-selected span').length){
		itemid = $('.ul-li-selected span').attr("id");
	}

	if (!$('#'+ itemid +' .clearfix').length){
		createItemLabel(itemid);
	}
}
/// 创建检查标签
function createLabel(id, desc){
	//alert(desc);
	if (selectedRow == ""){return;}
	/// 已存在改标签,不增加
	if($('#'+ selectedRow +' .selector-set b:contains("'+desc+'")').length){
		return;
	}
	
	var htmlstr = '';
		htmlstr = htmlstr + '<span class="ss-item">';
		//htmlstr = htmlstr + '	 <b>'+ desc +':</b>';
		htmlstr = htmlstr + '	 <b>'+ desc +'</b>';
		htmlstr = htmlstr + '	 <em>'+ id +'</em>';
		htmlstr = htmlstr + '	 <i></i>';
		htmlstr = htmlstr + '</span>';

	//$('#'+ selectedRow +' .selector-set').append(htmlstr);
		
	/// 计算标签插入位置
	/// 子部位(PS)-->检查方法(AC)-->体位(PO)-->后处理方法(DM)
	
	///点击项目类型
	var idType = id.split("_")[0];
	
	///已选子标签数目
	var Len = $('#'+ selectedRow +' .selector-set span').length;
	if (Len == 0){
		$('#'+ selectedRow +' .selector-set').append(htmlstr);
	}else{
		var k = 0;
		/// 循环判断新加标签插入位置
		$('#'+ selectedRow +' .selector-set span').each(function(){
			k = k + 1;
			/// 已存在标签类型
			var tempType = $(this).find("em").text().split("_")[0];
			/// 医嘱项不能重复添加
			if ((idType == "AC")&(tempType == "AC")){
				return false;
			}
			/// 体位不能重复添加
			if ((idType == "PO")&(tempType == "PO")){
				return false;
			}
			/// 子部位
			
			if (idType == "PS"){
				if (tempType != "PS"){
					$(this).before(htmlstr);
					return false;
				}
				
			/// 检查方法
			}else if (idType == "AC"){
				if ((tempType != "PS")&(tempType != "AC")){
					$(this).before(htmlstr);
					return false;
				}
			/// 体位
			}else if (idType == "PO"){
				if (tempType == "DM"){
					$(this).before(htmlstr);
					return false;
				}
			/// 默认插入方式
			}else{
				$('#'+ selectedRow +' .selector-set').append(htmlstr);
				return false;
			}
			/// 不满足上述条件,拼在最后;
			if (Len == k){
				$(this).after(htmlstr);
				return false;
			}
		})
	}
}

///保存模式
function newCreateSaveForWin(id){
	$('#nwtb').css({"display":""});
	var option = {
			buttons:[{
				text:'保存',
				iconCls:'icon-save',
				plain:'true',
				handler:function(){
					var savefor = $('input:checkbox[name=savefor]:checked').attr("id");
					if (typeof savefor == "undefined"){
						$.messager.alert("提示:","请先选择保存模式！");
						return;
					}
					$('#newSaveWin').dialog('close');
					saveItemLabel(id,savefor);
				}
			},{
				text:'取消',
				iconCls:'icon-cancel',
				plain:'true',
				handler:function(){
					$('#newSaveWin').dialog('close');
					}
			}]
		};
	var newConDialogUX = new DialogUX('保存模式', 'newSaveWin', '500', '200', option);
	newConDialogUX.Init();
}

/// 保存已选择列表行[保存模板]
function saveItemLabel(id, savefor){

	var ItemLabelArr = [];
	/// 检查内容项目ID
	$('#'+id+' .selector-set span').each(function(){
		/// 检查内容项目ID
		ItemLabelArr.push($(this).find("em").text());
	})
	if (ItemLabelArr.join(",").indexOf("PS") == "-1"){
		$.messager.alert("提示:","项目缺少部位！");
		return;
	}
	if (ItemLabelArr.join(",").indexOf("AC") == "-1"){
		$.messager.alert("提示:","项目缺少医嘱项目！");
		return;
	}
	var arListData = ItemLabelArr.join("^");
	
	/// 保存模式
	var point = "DHCHEALTH";
	if (savefor == "User"){
		point = LgUserID;
	}else if (savefor == "Loc"){
		point = LgCtLocID;
	}
	var arcItemCatID = id.split("_")[0];
	var mListData = savefor +"^"+ point +"^"+ arcItemCatID;

	/// 保存模板数据
	runClassMethod("web.DHCAppArcTemp","saveArcTemp",{"mListData":mListData,"arListData":arListData},function(jsonString){

		if (jsonString == 0){
			$.messager.alert("提示:","保存成功！");
		}else if(jsonString == -1){
			$.messager.alert("提示:","已存在相同项目,不能添加模板！");
		}else{
			$.messager.alert("提示:","保存失败！");
		}
	})
}

/// 删除已选择列表行
function delItemLabel(id){
	$('#'+id).remove();
	clearSelectStyle(); ///初始化界面样式
}

/// 删除面板
function delItemPanel(id){
	$('#'+id).remove();
	clearSelectStyle(); ///初始化界面样式
}

/// 选中一行
function selectItemLabel(id){
	
	$('#'+id+' .crumbs-nav').css({"background":"#5994F8"});
}

/// 清除选中样式
function clearComponentSelect(){
	
	$('.crumbs-nav').css({"background":""});  ///取消选中行样式
	///隐藏二级部位
	if ($('#PS').parent().is(":visible")){
		$("#PS").parent().hide('fast');
	}
	
	$('#PO').html('');   ////清空后体位项目区域
	$('#DM').html('');   ////清空后处理字典项目区域
	$("#PO").parent().parent().hide('fast');
}

/// 删除按钮清除样式
function clearSelectStyle(){
	
	$('.crumbs-nav').css({"background":""});  ///取消选中行样式
	
	///隐藏二级部位
	if ($('#PS').parent().is(":visible")){
		$("#PS").parent().hide('fast');
	}
	
	///项目样式
	$("ul li").each(function(){
		$(this).css({"background":"#D5FAC0","color":""});
	})
}

/// 加载提示消息
function LoadCellTip(){
	
	var html='<div id="tip" style="border-radius:5px; display:none; border:1px solid #000; padding:10px;position: absolute; background-color: #000;color:#FFF;"></div>';
	$('body').append(html);

	$(".ui-div-cell-panel ul li span").live('mousemove',function(){
		
		var tleft=($(this).offset().left + 20);
		if(($(this).offset().left+300)>document.body.offsetWidth){
			tleft=$(this).offset().left-20;
		}
		if ($(this).text().length <= "6"){
			return;
		}
		$("#tip").css({
			display : 'block',
			top : ($(this).parent().offset().top + $(this).outerHeight() + 10) + 'px',   
			left : tleft + 'px',
			'z-index' : 9999,
			opacity: 0.7
		}).text($(this).text());
	}).live('mouseout',function(){
		$("#tip").css({display : 'none'});
	})
}

/// 保存
function saveItem(){

	var arDisHis = $('#arDisHis').val();      ///现病史
	if (arDisHis == "请输入现病史描述！"){
		arDisHis = "";
	}
	var arPurpose = $('#arPurpose').val();    ///检查目的
	if (arPurpose == "请输入检查目的！"){
		arPurpose = "";
	}
	var arPhySigns = $('#arPhySigns').val();  ///体征
	if (arPhySigns == "请输入体征信息！"){
		arPhySigns = "";
	}
	var arEmgFlag = $('#arEmgFlag').is(':checked')? "Y":"N";
	var ListData = "";  /// 待保存数据列表
	
	/// 检查项目列表
	var quitflag = 0; 
	$('.select-list-panel').each(function(){
		var itemid = this.id;
		var arReqID = $(this).attr("data-id");
		var ItemRowLabelArr = [];
		var arListData = "";  ///医嘱项目数据
		var arExecLocID = $("#" +itemid+ " select").val();  ///执行科室
		if (arExecLocID == ""){
			$.messager.alert("提示:","执行科室不能为空！");
			quitflag = 1;
			return false;
		}
		/// 检查项目行列表
		$('#'+itemid+' .clearfix').each(function(){
			var itemrowid = this.id;
			var ItemLabelArr = [];
			/// 检查内容项目ID
			$('#'+itemrowid+' .selector-set span').each(function(){
				/// 检查内容项目ID
				ItemLabelArr.push($(this).find("em").text());
			})
			if (ItemLabelArr.join(",").indexOf("PS") == "-1"){
				$.messager.alert("提示:","项目缺少部位！");
				quitflag = 1;
				return false;
			}
			if (ItemLabelArr.join(",").indexOf("AC") == "-1"){
				$.messager.alert("提示:","项目缺少医嘱项目！");
				quitflag = 1;
				return false;
			}
			/*
			if (ItemLabelArr.join(",").indexOf("PO") == "-1"){
				$.messager.alert("提示:","项目缺少体位！");
				quitflag = 1;
				return false;
			}
			if (ItemLabelArr.join(",").indexOf("DM") == "-1"){
				$.messager.alert("提示:","项目缺少后处理方法！");
				quitflag = 1;
				return false;
			}
			*/
			ItemRowLabelArr.push(ItemLabelArr.join("^"));
		})
		arListData = ItemRowLabelArr.join("&&");

		///申请主信息
		var mListData = itemid +"^"+ EpisodeID +"^"+ arExecLocID +"^"+ arEmgFlag +"^"+ LgUserID +"^"+ LgCtLocID;
		mListData =  mListData +"^"+ arPurpose +"^"+ arDisHis +"^"+ arPhySigns;
		
		/// 其他项目
		var othListData = $('#'+ itemid +' .selector-set-othpt').text();
		/*
		var othOptListData = getJsonOtherOpt(itemid);
		if ((othListData != othOptListData)&(othOptListData != "")){
			othListData = othOptListData;
		}
		*/
		if (ListData == ""){
			ListData = arReqID +"!!"+ mListData +"!!"+ arListData +"!!"+ othListData;
		}else{
			ListData = ListData + String.fromCharCode(1) + arReqID +"!!"+ mListData +"!!"+ arListData +"!!"+ othListData;
		}
	})

	if (quitflag == 1){return;}
	if (ListData == ""){
		$.messager.alert("提示:","请先增加项目,然后点击发送！");
		return;
	}
	/// 保存模板数据
	runClassMethod("web.DHCAPPReport","save",{"ListData":ListData},function(jsonString){
		if (jsonString < 0){
			$.messager.alert("提示:","发送失败！");
		}else{
			$('.selected_list').html('');   ///情况项目列表
			initAppRepItemList();  ///隐藏项目列表区域
			$.messager.alert("提示:","发送成功！");
			arItemIdList = jsonString;       ///暂存界面已保存项目ID
			var arReqIDArr = jsonString.split("^");
			for (var q=0;q<arReqIDArr.length;q++){
				setHisReq(arReqIDArr[q]);
			}
		}
	},'',false)
}

/// 保存临时数据到项目标签
function tempSaveOtherOpt(itemid){
	
	if ((lastitemid != "")&(lastitemid != itemid)){
		var othoptstr = getJsonOtherOpt(lastitemid); /// 其他项目选项值
		$('#'+ lastitemid +' .selector-set-othpt').text(othoptstr);
	}
}

/// 获取其他项目
function getJsonOtherOpt(itemid){
	
	var tempstr = [];
	$('.table-border select').each(function(){
		if (this.value != ""){
			tempstr.push(this.id +"#"+ this.value +"#"+ "Combox");
		}
	})

	$('.table-border input[type=checkbox]').each(function(){
		if ($(this).is(':checked')){
			tempstr.push(this.id +"#"+ "Y" +"#"+ "Check");
		}
	})
	
	$('.table-border input[type=text]').each(function(){
		if (this.value != ""){
			tempstr.push(this.id +"#"+ this.value +"#"+ "Input");
		}
	})

	return tempstr.join("$");
}

/// 设置其他项目
function tempSetOtherOpt(itemid){
	
	var otherOptList = $('#'+ itemid +' .selector-set-othpt').text();
	if (otherOptList == ""){ return; }
	var otherOptArr = otherOptList.split("$");
	for (var i=0; i<otherOptArr.length; i++){
		var type = otherOptArr[i].split("#")[2];
		switch(type){
			case "Combox":
				$("#"+otherOptArr[i].split("#")[0]).val(otherOptArr[i].split("#")[1]); 
				break;
			case "Input":
				$("#"+otherOptArr[i].split("#")[0]).val(otherOptArr[i].split("#")[1]); 
				break;
			case "Check":
				$("#"+otherOptArr[i].split("#")[0]).attr("checked",'true');
				break;
		}
	}
	return true;
}

/// 加载历史申请
function LoadAppHisReq(arReqID){
	$('.selected_list').html('');
	initAppRepItemList();  ///隐藏项目列表区域
	arItemIdList = arReqID;
	setHisReq(arReqID);
}

/// 重新设置申请界面
function setHisReq(arReqID){
	
	if (arReqID == ""){ return; }
	
	/// 查询数据
	runClassMethod("web.DHCAPPComDataUtil","GetPatReqDetail",{"arReqID":arReqID},function(jsonString){

		if (jsonString != null){
			var jsonObject = jsonString;
			/// 病人就诊信息
			$('.ui-span-m').each(function(){
				$(this).text(jsonObject[this.id]);
			})
			
			/// 现病史、体征、检查目的
			$('textarea').each(function(){
				$('#'+this.id).text(jsonObject[this.id]);
				$(this).css({"color":'#000'})
			})
			
			lastitemid = jsonObject['arItemCatID'];
			
			/// 创建检查项目面板
			LoadCheckItemLabel(jsonObject['arItemCatID'],jsonObject['arItemCat']);
			
			$('#'+jsonObject['arItemCatID']).attr("data-id",arReqID);  ///设置项目ID
			$('#'+jsonObject['arItemCatID'] +' .selector-set-othpt').text(jsonObject['arReqOtherOpt']);
			
			/// 加载接收科室
			GetCatRecLoc(jsonObject['arItemCatID']);
			
			/// 设置接收科室
			$('#'+jsonObject['arItemCatID']+' .select').val(jsonObject['repExLocID']);
			
			runClassMethod("web.DHCAPPComDataUtil","GetPatRepArc",{"arReqID":arReqID},function(jsonString){

				if (jsonString != null){
					var arArcItemListArr = jsonString.split("!!");
					for(var m=0;m<arArcItemListArr.length;m++){
						/// 添加项目列表
						createItemLabel(jsonObject['arItemCatID']);
						var arArcItemArr = arArcItemListArr[m].split("$$");
						for(var n=0;n<arArcItemArr.length;n++){
							if (typeof arArcItemArr[n].split("^")[1] != "undefined"){
								createLabel(arArcItemArr[n].split("^")[0],arArcItemArr[n].split("^")[1]);
							}
						}
					}
				}
			},'',false)
			GetOtherOpt(jsonObject['arItemCatID']);        		  ///初始化其他项目
			reLoadItemExsitArcOTH(jsonObject['arItemCatID']);     ///同时加载已选择医嘱项目对应其他项目列表
			tempSetOtherOpt(jsonObject['arItemCatID']);   		  ///存在其他项目临时值时,设置界面数据
		}
	},'json',false)
}

/// 删除报告
function delAppRep(id){
	
	var arReqID = $('#'+id).attr("data-id");  ///项目ID
	if (arReqID != ""){
		runClassMethod("web.DHCAPPReport","delAppRep",{"arReqID":arReqID},function(jsonString){

			if (jsonString != null){
				if (jsonString != 0){
					$.messager.alert("提示:","删除失败！");
				}else{
					delItemPanel(id);  ///删除成功之后，删除面板
				}
			}
		},'',false)
	}else{
		delItemPanel(id);  ///删除成功之后，删除面板
	}
}

/// 初始化界面列表
function initAppRepItemList(){
	
	$(".item—list ul li").css({"background":"#D5FAC0","color":""}); /// 情况项目标签
	$('#PA').html('');   ////清空后大部位项目区域
	$("#PA").parent().hide('fast');
	$('#PS').html('');   ////清空后子部位项目区域
	$("#PS").parent().hide('fast');
	$('#AC').html('');   ////清空后检查方法项目区域
	$("#AC").parent().hide('fast');
	$('#PO').html('');   ////清空后体位项目区域
	$("#PO").parent().hide('fast');
	$('#DM').html('');   ////清空后处理字典项目区域
	$("#DM").parent().hide('fast');
	$('table.table-border tbody').html('');    ////清空后其他项目区域
	$('.table-border').parent().parent().hide('fast');
}

/// 点击选中行时加载其他选项
function LoadOtherOpt(rowid){

	var id = $('#'+rowid).parent().parent().attr("id");
	if (id != lastitemid){
		GetOtherOpt(id);        	   ///初始化其他项目
		reLoadItemExsitArcOTH(id);     ///同时加载已选择医嘱项目对应其他项目列表
		tempSetOtherOpt(id);   		   ///存在其他项目临时值时,设置界面数据
	}
}

/// 加载常用模板
function LoadAppArcTemp(arcTempID){
	
	if (arcTempID == ""){ return; }

	/// 查询数据
	runClassMethod("web.DHCAPPComDataUtil","GetArcTemp",{"arcTempID":arcTempID},function(jsonString){

		if (jsonString != null){
			var jsonObject = jsonString;

			/// 创建检查项目面板
			LoadCheckItemLabel(jsonObject['arItemCatID'],jsonObject['arItemCat']);
			
			/// 加载接收科室
			GetCatRecLoc(jsonObject['arItemCatID']);
			
			runClassMethod("web.DHCAPPComDataUtil","GetArcTempDetail",{"arcTempID":arcTempID},function(jsonString){

				if (jsonString != null){
					var arArcItemListArr = jsonString.split("!!");
					for(var m=0;m<arArcItemListArr.length;m++){
						/// 添加项目列表
						createItemLabel(jsonObject['arItemCatID']);
						var arArcItemArr = arArcItemListArr[m].split("$$");
						for(var n=0;n<arArcItemArr.length;n++){
							if (typeof arArcItemArr[n].split("^")[1] != "undefined"){
								createLabel(arArcItemArr[n].split("^")[0],arArcItemArr[n].split("^")[1]);
							}
						}
					}
				}
			},'',false)
			GetOtherOpt(jsonObject['arItemCatID']);        		  ///初始化其他项目
			reLoadItemExsitArcOTH(jsonObject['arItemCatID']);     ///同时加载已选择医嘱项目对应其他项目列表
		}

	},'json',false)
}

/// 注意事项
function LoadArcItemNoteTemp(){
	
	$(".icon-warn").live('mousemove',function(){//对按钮的处理 
		$(this).removeClass("hover1");
		
		/// 行ID
		var itemrowid = $(this).parent().attr("id");
		/// 医嘱项ID
		var itmmastid = $('#'+itemrowid+' .selector-set em:contains("AC")').text().split("_")[1];
		if(typeof itmmastid == "undefined"){
			return;
		}
		$('.div-notes').html(GetItemmastNotes(itmmastid)); ///注意事项内容
		$(".div-notes").css({
			top : ($(this).parent().offset().top + $(this).outerHeight() - 10) + 'px',   
			left : ($(this).offset().left - 10) + 'px',
			'z-index' : 9999
		}).show();
	}).live('mouseout',function(){ 
		var divThis = $(".div-notes"); 
		setTimeout(function(){ 
			if (divThis.hasClass("hover0")) {//说明没有从按钮进入div
				divThis.hide(); 
			}
	     }, 100); 
		$(this).addClass("hover1");	
	});

	$(".div-notes").hover(function(){//div
		$(this).removeClass("hover0");
	},function(){ 
		$(this).addClass("hover0"); 
		var anniu = $(".icon-warn"); 
		var tthis = $(this); 
		setTimeout(function(){ 
			if(anniu.hasClass("hover1")){//说明没有从div回到按钮
				tthis.hide(); 
			}
		},100); 
	})
}

/// 医嘱项对应注意事项
function GetItemmastNotes(itmmastid){

	var htmlstr = '<h3 class="h3-title">注意事项</h3>';
	// 获取显示数据
	runClassMethod("web.DHCAPPComDataUtil","GetArcNoteTemp",{"itmmastid":itmmastid},function(jsonString){

		if (jsonString != ""){
			var jsonObject = jsonString;
			for(var t=0;t<jsonObject.length;t++){
				htmlstr = htmlstr + '<h5>'+ jsonObject[t].itemTemp +'</h5>';
				htmlstr = htmlstr + '<p>'+ jsonObject[t].itemTempDesc.replace(new RegExp("<br>","g"),"\r\n") +'</p>';
			}
		}else{
			htmlstr = htmlstr + '<p style="font-size:18px;">暂无内容！！！</p>';
		}
	},'json',false)
	return htmlstr;
}

/// 设置模板界面选择标签项
function setTempTitleItem(){
	
	var htmlstr = "";
	$(".item—list span").each(function(){
		htmlstr = htmlstr +'<td align="right" style="padding-left:10px">'+ $(this).text() +'</td>';
		htmlstr = htmlstr +'<td width="30px" align="left"><input id="'+ this.id +'" type="radio" name="itemCat" style="background-image:none;border:none;"/></td>';
		htmlstr = htmlstr +'<td><div class="datagrid-btn-separator"></div></td>';
	})
	
	$("#arctb table tr:first").prepend(htmlstr);
}
