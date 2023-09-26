//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-08-20
// 描述:	   评分表维护页面JS
//===========================================================================================

var grpobj = "";    /// 当前选中组面板
var itemobj = "";   /// 当前选中组元素
var EditFlag = "";  /// 表单编辑标志

var o,   //捕获到的事件
	X,   //box水平宽度
	Y;   //box垂直高度
	
/// 页面初始化函数
function initPageDefault(){
	
	InitDomElEvent();   /// 初始化点击事件 
	InitPageDataGrid(); /// 页面DataGrid初始定义
	InitPageComponents(); /// 初始化界面组件
}

/// 初始化界面组件
function InitPageComponents(){
	
	/// 请会诊科室
	$HUI.combobox("#RelType",{
		url:$URL+"?ClassName=web.DHCEMCScoreTabMain&MethodName=JsRelType",
		valueField:'value',
		textField:'text',
		mode:'remote',
		onSelect:function(option){
			InsRelType(option.value);
	    }	
	})
}

/// 初始化点击事件 
function InitDomElEvent(){
	
	$(".container").on("click",".list-panel",function (){
		ClrDocElStyle();  /// 删除界面元素样式
		$(this).addClass('select').siblings().removeClass('select');
		grpobj = this;
		InsPropPanel("P"); /// 清空界面属性内容
	});
		
	$(".container").on("click",".list-ul-item",function (e){
		ClrDocElStyle();  /// 删除界面元素样式
		$(".list-ul-item").removeClass('select-li');
		$(this).addClass('select-li').siblings().removeClass('select-li');
		itemobj = this;
		e.stopPropagation();
		InsPropPanel("E");   /// 清空界面属性内容
		if ($(this).find("input").attr("data-reltype") != ""){
			$HUI.combobox("#RelType").setValue($(this).find("input").attr("data-reltype"));
		}
	});
	
	$(".container").on("click",".itemClass",function (e){
		ClrDocElStyle();  /// 删除界面元素样式
		$(".itemClass").removeClass('select-li');
		$(this).addClass('select-li').siblings().removeClass('select-li');
		itemobj = this;
		e.stopPropagation();
		InsPropPanel("E"); /// 清空界面属性内容
	});
	
	$(".container").on("click",".item_par",function (e){
		ClrDocElStyle();  /// 删除界面元素样式
		$(".item_par").removeClass('select-li');
		$(this).addClass('select-li').siblings().removeClass('select-li');
		itemobj = this;
		e.stopPropagation();
		InsPropPanel("E"); /// 清空界面属性内容
	});
	
	/// 组标题
	$('#GrpTitle').on('keydown keyup',function(){
		if (grpobj){
			if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
				$(grpobj).text(this.value);
			}else{
				$("div.select .list-title label").text(this.value);
			}
		}
		//$("div.select .list-title label").text(this.value);
	})
	
	/// 组面板高度
	$('#GrpHeight').on('keydown keyup',function(){
		$("div.select .list-item").css("min-height",this.value+"px");
	})
	
	/// 选项
	$('#Question').on('keydown keyup',function(){
		if (itemobj){
			if ($(itemobj).prop("outerHTML").indexOf("</p>") != "-1"){
				$(itemobj).html(this.value);
			}else{
				$(".select-li span.item").text(this.value);
			}
		}
	})
	
	/// 分值
	$('#Score').on('keydown keyup',function(){
		//$("div.select .select-li input").attr("value",this.value);
		$(".select-li input").attr("value",this.value);
		$(".select-li .item-score").text(this.value != ""?"【"+ this.value+"分】":"");
	})
	
	/// 行数
	$('#rows').on('keydown keyup',function(){
		
		if ($("table.tb-select-tr tr").length > this.value){
			var rows = $("table.tb-select-tr tr").length - this.value;
			for (var i=$("table.tb-select-tr tr").length - 1; rows > 0; i--, rows--){
				$("table.tb-select-tr tr:nth-child("+ i +")").remove();
			}
		}else{
			var html = $("table.tb-select-tr tr").prop("outerHTML");
			var rows = this.value - $("table.tb-select-tr tr").length;
			for (var i=0; i<rows; i++){
				$("table.tb-select-tr tbody").append(html);
			}	
		}
	})
	
	/// 列数
	$('#cols').on('keydown keyup',function(){
		
		if ($("table.tb-select-tr tr:nth-child(1) td").length > this.value){
			var rows = $("table.tb-select-tr tr:nth-child(1) td").length - this.value;
			for (var i=$("table.tb-select-tr tr:nth-child(1) td").length - 1; rows > 0; i--, rows--){
				$("table.tb-select-tr tr td:nth-child("+ i +")").remove();
			}
		}else{
			var html = $("table.tb-select-tr tr:nth-child(1) td").prop("outerHTML");
			var rows = this.value - $("table.tb-select-tr tr:nth-child(1) td").length;
			for (var i=0; i<rows; i++){
				$("table.tb-select-tr tbody tr").append(html);
			}	
		}
	})
	
	/// table
	$(".container").on("click","td",function (e){
		/// 判断是否按下Ctrl键
		if(!window.event.ctrlKey){
			$("td").removeClass("tb-select");
		}
		$(this).addClass("tb-select");
		$("table").removeClass("tb-select-tr");
		$(this).parent().parent().parent().addClass("tb-select-tr");
		grpobj = this;
		e.stopPropagation();
		InsPropPanel("T"); /// 清空界面属性内容
	});

	$("#EditForm").bind("click",function (e){
		editScore();  /// 修改
	})
	
	$(".container").on("mousedown",".draggable",function (e){
		getObject($(this),e||event);       //box捕获事件并处理  e-->FF  window.event-->IE
	});
	
	document.onmousemove = function(dis){    //鼠标移动事件处理
		if(!o){    //如果未获取到相应对象则返回
			return;
		}
		if(!dis){  //事件
			dis = event ;
			//    dis = arguments[0]||window.event;   //如果上面那句在FF下无法获取事件，听说可以通过 arguments[0]获取FF下的事件对象
		}
		o.css('left',dis.clientX - X +"px");     //设定box样式随鼠标移动而改变
		o.css('top',dis.clientY - Y + "px");
	};
	document.onmouseup = function(){    //鼠标松开事件处理
		if(!o){   //如果未获取到相应对象则返回
			return;
		}
		// document.all（IE）使用releaseCapture解除绑定；其余比如FF使用window对象针对事件的捕捉
		document.all?o.releaseCapture() : window.releaseEvents(Event.MOUSEMOVE|Event.MOUSEUP)
		o = '';   //还空对象
	};

}

function getObject(obj,e){    //获取捕获到的对象
	o = obj;
	// document.all（IE）使用setCapture方法绑定；其余比如FF使用Window对象针对事件的捕捉
	document.all?o.setCapture() : window.captureEvents(Event.MOUSEMOVE);  
	X = e.clientX - parseInt(o.css("left"));   //获取宽度，
	Y = e.clientY - parseInt(o.css("top"));    //获取高度，
	//    alert(e.clientX+"  -- " + o.style.left+" -- "+ X);
}

/// 更新元素关联类型
function InsRelType(relType){
	
	$(".select-li input").attr("data-reltype",relType);
}

/// 删除界面元素样式
function InsPropPanel(FlagCode){
	
	if (FlagCode == "P"){
		$('#GrpTitle').parent().show();
		$('#GrpHeight').parent().show();
		$('#Question').parent().hide();
		$('#Score').parent().hide();
		$('#rows').parent().hide();
		$('#cols').parent().hide();
		$HUI.combobox("#RelType").disable();
		$('#GrpTitle').val($("div.select .list-title label").text());       /// 组标题
	}
	if (FlagCode == "E"){
		$('#GrpTitle').parent().hide();
		$('#GrpHeight').parent().hide();
		$('#Question').parent().show();
		$('#Score').parent().show();
		$('#rows').parent().hide();
		$('#cols').parent().hide();
		$('#Question').val($(".select-li span").text());       /// 选项
		$('#Score').val($(".select-li input").attr("value"));  /// 分值
		$HUI.combobox("#RelType").enable();
	}
	if (FlagCode == "T"){
		$('#GrpTitle').parent().show();
		$('#GrpHeight').parent().hide();
		$('#Question').parent().hide();
		$('#Score').parent().hide();
		$('#Score').parent().hide();
		$('#rows').parent().show();
		$('#cols').parent().show();
		$HUI.combobox("#RelType").disable();
		$('#GrpTitle').val($(grpobj).text());       /// 组标题
	}
	$HUI.combobox("#RelType").setValue("");
}

/// 删除界面元素样式
function ClrDocElStyle(){
	
	$('.select').removeClass('select');
	$('.select-li').removeClass('select-li');
}

/// 页面DataGrid初始定义
function InitPageDataGrid(){
	
	///  定义columns
	var columns=[[
		{field:'ID',title:'ID',width:100,align:'center',hidden:true},
		{field:'Code',title:'评分表代码',width:205,align:'center',hidden:true},
		{field:'Desc',title:'评分表',width:190}
	]];
	
	///  定义datagrid
	var option = {
		showHeader:false,
		rownumbers : false,
		singleSelect : true,
        onClickRow:function(rowIndex, rowData){
			InsEditForm(rowData.ID, "");      /// 初始化加载当前表单
			GetScoreTabHtml(rowData.ID, "");  /// 取评分维护表Html
	    },
		onLoadSuccess:function(data){
			///  隐藏分页图标
            $('.pagination-page-list').hide();
            $('.pagination-info').hide();
		}
	};

	var params = "";
	var uniturl = $URL+"?ClassName=web.DHCEMCScoreTabMain&MethodName=QryScoreScale";
	new ListComponent('ScoreList', columns, uniturl, option).Init();
	
	///  隐藏刷新按钮
	$('#ScoreList').datagrid('getPager').pagination({ showRefresh: false});
	
	///  隐藏分页图标
    var panel = $("#ScoreList").datagrid('getPanel').panel('panel');
    panel.find('.pagination-page-list').hide();
    panel.find('.pagination-info').hide();
}

/// 排序
function sort(){
	
	if (grpobj == ""){
		$.messager.alert("提示:","请先选中待排序的分组！","warning");
		return;
	}
	if (!$(grpobj).find('.list-ul-item').hasClass('sort-x')){
		$(grpobj).find('.list-ul-item').addClass('sort-x');
	}else{
		$(grpobj).find('.list-ul-item').removeClass('sort-x');
	}
}

function html(){
	alert($(".form").html());
}

function add(){
	
	var grpno = $(".form .list-panel").length + 1;
	var htmlstr = "";
		htmlstr = htmlstr + '<div class="list-panel" id="grp-'+ grpno +'">';
		htmlstr = htmlstr + '	<div class="list-title">';
		htmlstr = htmlstr + '		<div class="list-icon">';
		//htmlstr = htmlstr + '	 		<img src="images/infomation.png" border=0/>';
		htmlstr = htmlstr + '	 	</div>';
		htmlstr = htmlstr + '   	<label class="grp-title">'+ grpno +'、组标题</label>';
		htmlstr = htmlstr + '	 	<div class="list-tools">';
		htmlstr = htmlstr + '		</div>';
		htmlstr = htmlstr + '	</div>';
		htmlstr = htmlstr + '	<div class="list-item">';
		htmlstr = htmlstr + '		<ul class="list-ul">';
		htmlstr = htmlstr + '		</ul>';
		htmlstr = htmlstr + '	</div>';
		htmlstr = htmlstr + '</div>';
	$(".form").append(htmlstr);
}

/// 插入Check
function check(){
	
	var css = "";
	if ($(grpobj).find('.list-ul-item').hasClass('sort-x')){
		css = 'sort-x';
	}
	var grpname = $(grpobj).attr("id");  /// 组号
	var ScoreID = $("#EditForm").attr("data-id");   /// 表单ID
	var id = GetFormEleID(ScoreID);      /// 自动生成表单元素ID
	var htmlstr = "";
	htmlstr = htmlstr + '<li class="list-ul-item '+ css +'"><label><input id="'+ id +'" name="'+ grpname +'" type="checkbox" value="" /><span class="item">待选项</span><span class="item-score"></span></label></li>';
	if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
		$(grpobj).html(htmlstr);
	}else{
		$(grpobj).find('.list-item .list-ul').append(htmlstr);
	}
}

/// 插入Radio
function radio(){
	
	var css = "";
	if ($(grpobj).find('.list-ul-item').hasClass('sort-x')){
		css = 'sort-x';
	}
	var grpname = $(grpobj).attr("id");  /// 组号
	var ScoreID = $("#EditForm").attr("data-id");   /// 表单ID
	var id = GetFormEleID(ScoreID);      /// 自动生成表单元素ID
	var htmlstr = "";
	htmlstr = htmlstr + '<li class="list-ul-item '+ css +'"><label><input id="'+ id +'" type="radio" name="'+ grpname +'" value=""/><span class="item">待选项</span><span class="item-score"></span></label></li>';
	if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
		$(grpobj).html(htmlstr);
	}else{
		$(grpobj).find('.list-item .list-ul').append(htmlstr);
	}
}

/// 插入Input
function input(){
	
	var css = "";
	if ($(grpobj).find('.list-ul-item').hasClass('sort-x')){
		css = 'sort-x';
	}
	var grpname = $(grpobj).attr("id");  /// 组号
	var ScoreID = $("#EditForm").attr("data-id");   /// 表单ID
	var id = GetFormEleID(ScoreID);      /// 自动生成表单元素ID
	var css = "";
	if (grpobj){
		if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
			css = "";
		}else{
			css = "draggable";
		}
	}
	var htmlstr = "";
	htmlstr = htmlstr + '<div class="itemClass '+ css +'"><span>待选项</span><input id="'+ id +'" type="text" name="'+ grpname +'"/></div>';
	if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
		$(grpobj).html(htmlstr);
	}else{
		$(grpobj).find('.list-item').append(htmlstr);
	}
}

/// 插入Textarea
function textarea(){
	
	var htmlstr = "";
	//htmlstr = htmlstr + '<div class="itemLabel"><label>测试</label></div>';
	var ScoreID = $("#EditForm").attr("data-id");   /// 表单ID
	var id = GetFormEleID(ScoreID);                 /// 自动生成表单元素ID
	htmlstr = htmlstr + '<div style="height:120px;"><textarea id="'+ id +'" style="width:100%;height:112px;resize:none;"></textarea></div>';
	if (grpobj){
		$(grpobj).find('.list-item').append(htmlstr);
	}
}

/// 插入table
function table(){
	var htmlstr = "";
	htmlstr = htmlstr + ' <table id="itemList" border="1" cellspacing="0" cellpadding="1" class="form-table">';
	htmlstr = htmlstr + ' <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
	htmlstr = htmlstr + ' <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
	htmlstr = htmlstr + ' <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
	htmlstr = htmlstr + ' </table>';
	if (grpobj){
		$(grpobj).find('.list-item').append(htmlstr);
	}
}

/// 插入label
function label(){

	var htmlstr = "";
	htmlstr = htmlstr + '<label></label>';
	if (grpobj){
		$(grpobj).append(htmlstr);
	}
}

/// 插入p
function ins_p(){
	
	var css = "";
	var htmlstr = "";
	htmlstr = htmlstr + '<p class="item_par">段落文本</p>';
	if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
		// $(grpobj).html(htmlstr);
	}else{
		$(grpobj).find('.list-item .list-ul').before(htmlstr);
	}
}
				
/// 评分表预览
function review(){
	
	var ScoreID = $("#EditForm").attr("data-id");   /// 表单ID
	if (ScoreID == ""){
		$.messager.alert("提示:","表单为空！","warning");
		return;
	}
	var link = "dhcemc.scoretabreview.csp?ScoreID="+ ScoreID +"&ScoreCode=" +"&EditFlag=0";;
	window.open(link, '_blank', 'height=500, width=1200, top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// 保存评分表
function InsScoreTabMain(){
	
	var ScoreCode = $("#ScoreCode").val();  /// 代码
	var ScoreDesc = $("#ScoreDesc").val();  /// 描述
	if (ScoreCode == ""){
		$.messager.alert("提示:","表单代码不能为空！","warning");
		return;
	}
	if (ScoreDesc == ""){
		$.messager.alert("提示:","表单名称不能为空！","warning");
		return;
	}
	
	var ScoreID = "";
	if (EditFlag == 2){
		ScoreID = $("#EditForm").attr("data-id");   /// 表单ID
		if (ScoreID == ""){
			$.messager.alert("提示:","表单为空！","warning");
			return;
		}
	}
	
	runClassMethod("web.DHCEMCScoreTabMain","Insert",{"ID":ScoreID, "Code":ScoreCode, "Desc":ScoreDesc},function(jsonString){

		if (jsonString < 0){
			if(jsonString=="-1"){ //hxy 2020-03-04 st
				$.messager.alert("提示:","表单代码不能重复！","warning");
			}else if(jsonString=="-2"){
				$.messager.alert("提示:","表单名称不能重复！","warning");
			}else{ //ed
			$.messager.alert("提示:","保存失败！","warning");
			}
		}else{
			$.messager.alert("提示:","保存成功！","success");
			CloseWin();    /// 关闭方法
			$("#ScoreList").datagrid("reload");   /// 评分列表
			InsEditForm(jsonString);              /// 初始化加载当前表单
		}
	},'',false)
}

/// 保存评分表Html
function InsScoreTabHtml(){
	
	ClrDocElStyle();  /// 删除界面元素样式
		
	var ID = $("#EditForm").attr("data-id");   /// 表单ID
	if (ID == ""){
		$.messager.alert("提示:","表单为空！","warning");
		return;
	}

	var Html = $(".container").html(); /// 表单Html
	
	/// 评分表单详情
	var itemArr = [];
	var items = $("input[name^='grp']");
	for (var i=0; i<items.length; i++){
		itemArr.push(items[i].id +"^"+ $("#"+items[i].id).next().text() +"^"+ items[i].type);
	}
	
	var FormEls = itemArr.join("@"); /// 表单元素
	runClassMethod("web.DHCEMCScoreTabMain","InsHtml",{"ID":ID, "Html":Html, "FormEls":FormEls},function(jsonString){

		if (jsonString != 0){
			$.messager.alert("提示:","保存失败！","warning");
		}else{
			$.messager.alert("提示:","保存成功！","success");
		}
	},'',false)
}

/// 初始化加载当前表单
function InsEditForm(ScoreID, ScoreCode){
	
	runClassMethod("web.DHCEMCScoreTabMain","GetScoreScale",{"ScoreID":ScoreID, "ScoreCode":ScoreCode},function(jsonObj){

		if (jsonObj != ""){
			$("#EditForm").attr("data-id",jsonObj.ScoreID);   /// 表单ID
			$("#EditForm").text(jsonObj.ScoreCode +"-"+ jsonObj.ScoreDesc);  /// 表单描述
			$("#FormTitle").text(jsonObj.ScoreDesc);          /// 表单描述
			if (EditFlag == 1) $(".form").html("");   /// 表单Html
		}
	},'json',false)
}

/// 取评分维护表Html
function GetScoreTabHtml(ScoreID, ScoreCode){
	
	$(".form").html("");   /// 表单Html
	runClassMethod("web.DHCEMCScoreTabMain","GetScoreTabHtml",{"ScoreID":ScoreID, "ScoreCode":ScoreCode},function(jsonString){

		if (jsonString != ""){
			$(".container").html(jsonString);   /// 表单Html
		}
	},'',false)
}

/// 自动生成表单元素ID
function GetFormEleID(ScoreID){
	
	var ID = "";
	runClassMethod("web.DHCEMCScore","GetFormEleID",{"ID":ScoreID},function(jsonString){

		if (jsonString != ""){
			ID = jsonString;   /// 元素ID
		}
	},'',false)
	return ID;
}

/// 新建
function newScore(){
	
	EditFlag = 1;   /// 表单编辑标志
	mdtPopWin('新建评分表单');
	$("#ScoreCode").val("");   /// 表单代码
	$("#ScoreDesc").val("");   /// 表单描述
}

/// 修改
function editScore(){
	
	EditFlag = 2;  /// 表单编辑标志
	mdtPopWin('修改评分表单');
	initScore();
}

/// window窗口
function mdtPopWin(title){
	
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		iconCls:'icon-paper',
		closed:"true"
	};
	new WindowUX(title, 'newWin', 400, 230, option).Init();
}

/// 清空界面属性内容
function ClsPropPanel(){
	
	$('input').val("");
}
				
/// 关闭方法
function CloseWin(){
	
	$("#newWin").window('close');
}

/// 保存评分表单
function TakScore(){
	
	InsScoreTabMain();  /// 保存评分表
}

/// 删除
function del(){
	
	if (grpobj){
		$(grpobj).remove();
	}
	
	$(".select-li").remove();
}

/// 初始化加载评分表单代码和描述
function initScore(){
	
	var ScoreID = $("#EditForm").attr("data-id");   /// 表单ID
	if (ScoreID == ""){
		$.messager.alert("提示:","表单为空！","warning");
		return;
	}
	
	runClassMethod("web.DHCEMCScoreTabMain","GetScoreScale",{"ScoreID":ScoreID},function(jsonObj){
		if (jsonObj != ""){
			$("#ScoreCode").val(jsonObj.ScoreCode);   /// 表单代码
			$("#ScoreDesc").val(jsonObj.ScoreDesc);   /// 表单描述
		}
	},'json',false)
}

/// 合并单元格
function merge(){
	
}

/// 行合并
function merge2() { //可实现合并单元格,上下行来比较
    var totalCols = $("table.tb-select-tr").find("tr:eq(0)").find("td").length;
    var totalRows = $("table.tb-select-tr").find("tr").length;
    for ( var i = totalCols-1; i >= 0; i--) {
        for ( var j = totalRows-1; j >= 0; j--) {
            startCell = $("table.tb-select-tr").find("tr").eq(j).find("td").eq(i);
            targetCell = $("table.tb-select-tr").find("tr").eq(j - 1).find("td").eq(i);
	        if (startCell.hasClass('tb-select') && targetCell.hasClass('tb-select')) {
                targetCell.attr("rowSpan", (startCell.attr("rowSpan")==undefined)?2:(eval(startCell.attr("rowSpan"))+1));
                startCell.remove();
            }
        }
    }
}

///  列合并
function merge3() { //可实现合并单元格,上下行来比较
    var totalCols = $("table.tb-select-tr").find("tr:eq(0)").find("td").length;
    var totalRows = $("table.tb-select-tr").find("tr").length;
    for ( var j = totalRows-1; j >= 0; j--) {
	    for ( var i = totalCols-1; i >= 0; i--) {
            startCell = $("table.tb-select-tr").find("tr").eq(j).find("td").eq(i);
            targetCell = $("table.tb-select-tr").find("tr").eq(j).find("td").eq(i - 1);
	        if (startCell.hasClass('tb-select') && targetCell.hasClass('tb-select')) {
                targetCell.attr("colspan", (startCell.attr("colspan")==undefined)?2:(eval(startCell.attr("colspan"))+1));
                startCell.remove();
            }
	    }
    }
}

/// 拆分单元格
function split(){

	var itemCell = $("table td.tb-select");
	
	var rows = itemCell.attr("rowSpan");
	var cols = itemCell.attr("colspan");
	if ((rows != "")&&(rows > 1)){
		var rowIndex = $("table tr").index(itemCell.parent());
		var cols = $("table tr td.tb-select").parent().find("td");
		var colIndex = cols.index(itemCell);
		var totalRows = $("table.tb-select-tr").find("tr").length;
		for ( var j = rowIndex + 1; j < totalRows-1; j++) {
			if (j <= (parseInt(rows) + parseInt(rowIndex) - 1)){
	        	$("table.tb-select-tr").find("tr").eq(j).find("td").eq(colIndex).before("<td></td>");
			}
	    }
	    itemCell.attr("rowSpan",1);
	}
	
	var cols = itemCell.attr("colspan");
	if ((cols != "")&&(cols > 1)){
		for ( var i = 1; i < cols; i++){
			itemCell.after("<td></td>");
		}
		itemCell.attr("colspan",1);
	}
}

var LINK_CSP="dhcemc.broker.csp";
//当前索引
var editIndex = undefined;
/**
 * 简单运行后台方法
 * @creater zhouxin
 * @param className 类名称
 * @param methodName 方法名
 * @param datas 参数{}
 * @param 回调函数
 * runClassMethod("web.DHCAPPPart","find",{'Id':row.ID,'Name':row.Name},function(data){ alert() },"json")	 
 */
function runClassMethod(className,methodName,datas,successHandler,datatype,sync){
	

	var _options = {
		url : LINK_CSP,
		async : true,
		dataType : "json", // text,html,script,json
		type : "POST",
		data : {
				'ClassName':className,
				'MethodName':methodName
			   }
	};
	$.extend(_options.data, datas);
	var option={dataType:typeof(datatype) == "undefined"?"json":datatype,async:typeof(sync) == "undefined"?_options.async:sync};
	_options=$.extend(_options, option);
	return $.ajax(_options).done(successHandler);
}

/// 自动设置页面布局
function onresize_handler(){

}

/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {

	
	/// 自动设置页面布局
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })