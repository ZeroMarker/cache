//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2020-12-25
// 描述:	   知识库审核插件JS
//===========================================================================================

var areaObj = "", // 区域对象
	rowsObj = "", // 行对象
	textObj = ""; // 元素对象
var FormID = "";  // 表单ID
var o,  // 捕获到的事件
    X,  // box水平宽度
    Y;  // box垂直高度
var ItemTypeArr = [{"value":"monHead","text":'标题域'}, {"value":"monBody","text":'目录域'}, {"value":"monDeta","text":'详情域'}, {"value":"monBase","text":'数据域'}];
var LineTypeArr = [{"value":"startLine","text":'首行'}, {"value":"endLine","text":'尾行'}];
/// 页面初始化函数
function initPageDefault(){
		
	/// 页面响应事件
	InitPageEvent();
	
	/// 页面DataGrid
	InitBmDetList();
	
	/// 页面元素
	InitComponent();
}

/// 页面元素
function InitComponent(){
	
	/// 目录类型
	$HUI.combobox("#labelType").disable();
}

/// 页面响应事件
function InitPageEvent(){
	
	/// 插入元素
	$(".itemarea").on("click",".btntexts",function (){
		insHtml($(this).attr("data-val"), $(this).attr("data-txt"), $(this).attr("data-css"), $(this).attr("data-type"));
	});
	
	/// 行事件
	$(".form").on("click",".row",function (e){
		//$(".temp-area div").removeClass("area-select");
		//$(".row").removeClass("row-select");
		//$(this).addClass('row-select');
		$(this).parent().addClass("area-select").siblings().removeClass("area-select");
		$(this).parent().siblings().find(".row").removeClass("row-select");
		rowsObj = this;
		e.stopPropagation();
	});
	
	/// 区域事件
	$(".form").on("click",".temp-area .area",function (e){
		$(this).addClass("area-select").siblings().removeClass("area-select");
		areaObj = this;
		e.stopPropagation();
	});
	
	/// 元素拖动
	$(".form").on("mousedown",".draggable",function (e){
		getObject($(this),e||event);       //box捕获事件并处理  e-->FF  window.event-->IE
	});
	
	/// 元素属性值
	$(".form").on("mousedown",".itemlabel",function (e){
		$("#width").val($(this).width());
		$("#height").val($(this).height());
		$("#content").val($(this).text());
		$("#topmargin").val(parseInt($(this).css("margin-top")));
		$("#leftmargin").val(parseInt($(this).css("margin-left")));
		
		$HUI.combobox("#locLine").setValue($(this).attr("data-valloc")||"");
		
		$(".itemlabel").removeClass("itemlabel-select");
		$(this).addClass('itemlabel-select'); /// .siblings().removeClass("itemlabel-select");
		textObj = this;
		e.stopPropagation();
	});
	
	/// 设置区域属性
	$(".form").on('click',".area",function(){
	
		if (typeof $(this).attr("data-area") != "undefined"){
			$HUI.combobox("#area").setValue($(this).attr("data-area"));
			GetRevPluElement($(this).attr("data-area")); /// 加载表单元素
		}else{
			$HUI.combobox("#area").setValue("");
		}
		
		if ($(this).attr("data-area") == "monBody"){
			/// 目录类型
			$HUI.combobox("#labelType").enable();
			$HUI.combobox("#labelType").setValue($(this).attr("data-areatype"));
		}else{
			$HUI.combobox("#labelType").setValue("");
			$HUI.combobox("#labelType").disable();
		}

	})
	
	/// 元素属性
	$("input[name='grpname']").on('keydown keyup',function(){
		if (this.id == "width"){
			$(textObj).width(this.value);
		}
		if (this.id == "height"){
			$(textObj).width(this.value);
		}
		if (this.id == "content"){
			$(textObj).find('label').text(this.value);
		}
		if (this.id == "topmargin"){
			$(textObj).css("margin-top",this.value +"px");
		}
		if (this.id == "leftmargin"){
			$(textObj).css("margin-left",this.value +"px");
		}
	})
	
	/// 区域 Combobox
	$HUI.combobox("#area",{
		data:ItemTypeArr,
		valueField:'value',
		textField:'text',
		panelHeight:'auto',
		onSelect:function(option){
			
			if (areaObj){
				$(areaObj).attr("data-area", option.value);
			}else{
				$.messager.alert("提示:","请先选择区域！","info");
				$HUI.combobox("#area").setValue("");
				return;
			}
			
			if (option.value == "monBody"){
				/// 目录类型
				$HUI.combobox("#labelType").enable();
			}
			
			GetRevPluElement(option.value); /// 加载表单元素
	    }	
	})
	
	/// 目录类型 Combobox
	$HUI.combobox("#labelType",{
		url:$URL+"?ClassName=web.DHCCKBRevPlugin&MethodName=JsGetRevLibArr",
		valueField:'value',
		textField:'text',
		//panelHeight:'auto',
		onSelect:function(option){
			if (areaObj && ($(areaObj).attr("data-area") == "monBody")){
				$(areaObj).attr("data-areatype", option.value);
			}else{
				$.messager.alert("提示:","请先选择目录区！","info");
				$HUI.combobox("#labelType").setValue("");
			}
	    }	
	})
	
	/// 赋值位置 Combobox
	$HUI.combobox("#locLine",{
		data:LineTypeArr,
		valueField:'value',
		textField:'text',
		panelHeight:'auto',
		onSelect:function(option){
			if (textObj && ($(textObj).attr("data-valloc") != "")){
				$(textObj).attr("data-valloc", option.value);
			}else{
				$.messager.alert("提示:","请先选择元素！","info");
				$HUI.combobox("#locLine").setValue("");
			}
	    }	
	})
}

/// 增加行
function row(){
	
	var htmlstr = "";
		htmlstr = htmlstr + '<div class="row"></div>';
	$(areaObj).append(htmlstr)
	
	$(".row").removeClass("row-select");
	$(areaObj).find(".row").addClass("row-select");
}

/// 增加面板
function panel(){
	
	var ID = $("#EditForm").attr("data-id");         /// 表单ID
	if (ID == ""){
		$.messager.alert("提示:","请先新建模板！","info");
		return;
	}
	var htmlstr = "";
		htmlstr = htmlstr + '<div class="area" data-area="" data-areatype=""></div>';
	$(".temp-area").append(htmlstr);
}

/// 删除行
function delrow(){
		
	if (rowsObj){
		$(rowsObj).remove();
	}
}

/// 删除元素
function dellabel(){
	
	if (textObj){
		$(textObj).remove();
	}
}

/// 插入元素
function insHtml(val, txt, css, type){
	
//	var htmlstr = "";
//	htmlstr = htmlstr + '<span class="itemlabel draggable '+ css +'"><label data-id="'+ val +'">'+ txt +'</label></span>';
//	if (rowsObj){
//		$(rowsObj).append(htmlstr);
//	}

	var htmlstr = "";
	if (type == "V"){
		htmlstr = htmlstr + '<span class="itemlabel draggable '+ css +'"><label data-id="'+ val +'">'+ txt +'</label></span>';
	}
	if (type == "K"){
		htmlstr = htmlstr + '<span class="itemlabel draggable '+ css +'"><label data-id="">'+ txt +'：</label></span>';
		htmlstr = htmlstr + '<span class="itemlabel draggable '+ css +'"><label data-id="'+ val +'">'+ txt +'</label></span>';
	}
	if (type == "L"){
		htmlstr = htmlstr + '<span class="itemlabel draggable '+ css +'"><label data-id="">'+ txt +'</label></span>';
	}
	if (rowsObj){
		$(rowsObj).append(htmlstr);
	}
	
}

function getObject(obj,e){    //获取捕获到的对象

	o = obj;
	// document.all（IE）使用setCapture方法绑定；其余比如FF使用Window对象针对事件的捕捉
	document.all?o.setCapture() : window.captureEvents(Event.MOUSEMOVE);  
	X = e.clientX - parseInt(o.css("margin-left"));   //获取宽度，
	//Y = e.clientY - parseInt(o.css("margin-top"));    //获取高度，
}
document.onmousemove = function(dis){    //鼠标移动事件处理
	if(!o){    //如果未获取到相应对象则返回
		return;
	}
	if(!dis){  //事件
		dis = event ;
	//    dis = arguments[0]||window.event;   //如果上面那句在FF下无法获取事件，听说可以通过 arguments[0]获取FF下的事件对象
	}
	o.css('margin-left',dis.clientX - X +"px");     //设定box样式随鼠标移动而改变
	//o.css('margin-top',dis.clientY - Y + "px");
};
document.onmouseup = function(){    //鼠标松开事件处理
	if(!o){   //如果未获取到相应对象则返回
		return;
	}
	// document.all（IE）使用releaseCapture解除绑定；其余比如FF使用window对象针对事件的捕捉
	document.all?o.releaseCapture() : window.releaseEvents(Event.MOUSEMOVE|Event.MOUSEUP)
	o = '';   //还空对象
};

/// 页面DataGrid
function InitBmDetList(){
	
	///  定义columns
	var columns=[[
		{field:'itemId',title:'ID',width:100,hidden:true},
		{field:'itemCode',title:'Code',width:175,align:'center',hidden:true},
		{field:'itemDesc',title:'模板',width:175,align:'center'}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader : false,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		onClickRow: function (rowIndex, rowData) {
			
			InsEditForm(rowData.itemId);      /// 加载当前表单
			GetRevPluginHtml(rowData.itemId); /// 取模板Html
        },
		onLoadSuccess:function(data){
			
			if (FormID == "") return;
			$.each(data.rows,function(index, item){
          		if (item.itemId == FormID){
	          		$('#bmDetList').datagrid("selectRow", index);
	          		return false;
	          	}
  			})
  			InsEditForm(FormID);      /// 加载当前表单
			GetRevPluginHtml(FormID); /// 取模板Html
			FormID = "";
		}
	};
	/// 就诊类型
	var param = "";
	var uniturl = $URL+"?ClassName=web.DHCCKBRevPlugin&MethodName=JsGetRevPlugin&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// 差异分析
function setCellLabel(value, rowData, rowIndex){
	
	var html = "";
	return html;
}

/// 保存
function savePTemp(){
	
	$(".temp-area div").removeClass("row-select");   /// 清除区域样式
	$(".row").removeClass("row-select");             /// 清除行样式
	$(".itemlabel").removeClass("itemlabel-select"); /// 清除元素样式
		
	var ID = $("#EditForm").attr("data-id");         /// 表单ID
	var Html = $(".form .list-item").html();

	runClassMethod("web.DHCCKBRevPlugin","InsHtml",{"_headers":{"X_ACCEPT_TAG":1}, "ID":ID, "Html":Html},function(jsonString){
		if (jsonString == 0){
			$.messager.alert("提示:","保存成功！","info");
			$("#bmDetList").datagrid("reload");
		}
	},'',false)
}

/// 删除
function delPTemp(){
	
	var ID = $("#EditForm").attr("data-id");       /// 表单ID
	runClassMethod("web.DHCCKBRevPlugin","delRevPlugin",{"ID":ID},function(jsonString){
		if (jsonString == 0){
			$.messager.alert("提示:","删除成功！","info");
			$("#bmDetList").datagrid("reload");
			$(".form .temp-area div").html("");   /// 表单Html
		}else{
			$.messager.alert("提示:","删除失败！","error");
		}
	},'',false)
}

/// 预览
function review(){
	
	var ID = $("#EditForm").attr("data-id");       /// 表单ID
	var Link = "dhcckb.review.csp?ID="+ ID;
	window.open (Link, '_blank', 'height=500, width=1000, top=150, left=200, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=n o, status=no') //这句要写成一行
}

/// 新建
function newPTemp(){
	
	EditFlag = 1;   /// 表单编辑标志
	commonShowWin({
		url:"dhcckb.newplugin.csp",
		title:"新建",
		width:400,
		height:230
	})
    $(".form .temp-area div").html("");   /// 表单Html
}

/// 加载当前表单
function InsEditForm(ID){
	
	runClassMethod("web.DHCCKBRevPlugin","GetRevPluObj",{"ID":ID},function(jsonObj){

		if (jsonObj != ""){
			$("#EditForm").attr("data-id",jsonObj.ID);   /// 表单ID
			$("#EditForm").text(jsonObj.Code +"-"+ jsonObj.Desc);  /// 表单描述
		}
	},'json',false)
}

/// 取模板Html
function GetRevPluginHtml(ID){
	
	$(".form .temp-area div").html("");   /// 表单Html
	runClassMethod("web.DHCCKBRevPlugin","GetRevPluHtml",{"ID":ID},function(jsonString){

		if (jsonString != ""){
			$(".form .list-item").html(jsonString);   /// 表单Html
		}else{
			$(".form .list-item").html('<div class="temp-area"></div>');   /// 表单Html
		}
	},'',false)
}

/// 刷新列表
function refresh(ID){
	
	FormID = ID;
	$("#bmDetList").datagrid("reload");   /// 刷新列表
}

/// 加载表单元素
function GetRevPluElement(area){
	
	runClassMethod("web.DHCCKBRevPlugin","JsGetRevPluElement",{"area":area},function(jsonObj){

		if (jsonObj){
			InsItemArea(jsonObj);  // 插入元素
		}
	},'json',false)
}

/// 插入元素
function InsItemArea(jsonObjArr){
	
	var htmlstr = '';

	/// 项目
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=jsonObjArr.length; j++){
		
		itemhtmlArr.push('<td><div class="btntexts" data-val="'+ jsonObjArr[j-1].itemCode +'" data-txt="'+ jsonObjArr[j-1].itemDesc +'" data-css="'+ jsonObjArr[j-1].itemCss +'"  data-type="'+ jsonObjArr[j-1].showType +'">'+ jsonObjArr[j-1].itemDesc +'</div></td>');
		if (j % 3 == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
	if ((j-1) % 3 != 0){
		
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td></td></tr>';
		itemhtmlArr = [];
	}
	$(".itemarea table").html(itemhtmlstr);
}
			
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
