//===========================================================================================
// 作者：      nk
// 编写日期:   2021-05-21
// 描述:	   评定量表维护页面JS,同新产品 量表维护功能
//===========================================================================================
var PageLogicObj={
	m_CureLocListDataGrid:"",
	m_CureArcimListDataGrid:"",
	editRow:undefined,
	imageSrc:"../scripts/dhcdoc/dhcdoccure_hui/image/assscale/"
}
var grpobj = "";    /// 当前选中组面板
var itemobj = "";   /// 当前选中组元素
var EditFlag = "";  /// 表单编辑标志

var o,   //捕获到的事件
	X,   //box水平宽度
	Y;   //box垂直高度
	
/// JQuery 初始化页面
$(function(){
	Init();
	InitEvent();
})
function Init(){
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("DHC_DocCureAssScale",hospStr);
	hospComp.jdata.options.onSelect = function(e,t){
		AssScaleListDataGridLoad();
		ExportAssScaleListDataGridLoad();
		Clear();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitPageDataGrid(); /// 页面DataGrid初始定义
		InitPageComponents(); /// 初始化界面组件
	}
	$('#RelType').parent().hide();
}

function Clear(){
	$("#EditForm").attr("data-id","");   /// 表单ID
	$("#EditForm").text("");  /// 表单描述
	$("#FormTitle").text("");          /// 表单描述
	$(".form").html("");   /// 表单Html	
}

/// 初始化界面组件
function InitPageComponents(){
	var ComboObj={
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.AssScaleConfig&MethodName=GetAssScaleCat",
		valueField:'value',
		textField:'text',
		mode:'remote'
	}
	$("#ScoreCat").combobox(ComboObj); //新建修改表单时的分类
	$.extend(ComboObj,{
		placeholder:"请选择评定量表分类",
		onSelect:function(option){
			AssScaleListDataGridLoad();
	    },onChange:function(n,o){
			if(n==""){
				$(this).combobox("select","");	
				AssScaleListDataGridLoad();
			}
		}
	});
	$("#ScaleCat").combobox(ComboObj);  //检索时的分类
	$.extend(ComboObj,{
		placeholder:"请选择评定量表分类",
		onSelect:function(option){
			ExportAssScaleListDataGridLoad();
	    },onChange:function(n,o){
			if(n==""){
				$(this).combobox("select","");	
				ExportAssScaleListDataGridLoad();
			}
		}
	});
	$("#EScaleCat").combobox(ComboObj);  //检索时的分类
	
	/// 关联
	$HUI.combobox("#RelType",{
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.AssScaleConfig&MethodName=JsRelType",
		valueField:'value',
		textField:'text',
		mode:'remote',
		editable:false,
		onSelect:function(option){
			InsRelType(option.value);
	    }	
	})
}

/// 初始化点击事件 
function InitEvent(){
	
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
		InsPropPanel("L");   /// 清空界面属性内容
		if ($(this).find("input").attr("data-reltype") != ""){
			$HUI.combobox("#RelType").setValue($(this).find("input").attr("data-reltype"));
		}
	});
	
	//文本 日期框
	$(".container").on("click",".itemClass",function (e){
		ClrDocElStyle();  /// 删除界面元素样式
		$(".itemClass").removeClass('select-li');
		$(this).addClass('select-li').siblings().removeClass('select-li');
		itemobj = this;
		e.stopPropagation();
		InsPropPanel("E"); /// 清空界面属性内容
	});
	
	//段落
	$(".container").on("click",".item_par",function (e){
		ClrDocElStyle();  /// 删除界面元素样式
		$(".item_par").removeClass('select-li');
		$(this).addClass('select-li').siblings().removeClass('select-li');
		itemobj = this;
		e.stopPropagation();
		InsPropPanel("S"); /// 清空界面属性内容
	});
	
	//图片
	$(".container").on("click",".item_img",function (e){
		ClrDocElStyle();  /// 删除界面元素样式
		$(".item_img").removeClass('select-li');
		$(this).addClass('select-li').siblings().removeClass('select-li');
		itemobj = this;
		e.stopPropagation();
		InsPropPanel("I"); /// 清空界面属性内容
	});
	
	/// table
	$(".container").on("click","td",function (e){
		/// 判断是否按下Ctrl键
		if(!window.event.ctrlKey){
			$("td").removeClass("tb-select");
		}
		$(this).addClass("tb-select");
		$(".list-ul .list-ul-item").removeClass("select-li");
		$("table").removeClass("tb-select-tr");
		var parobj=$(this).parent().parent().parent();
		parobj.addClass("tb-select-tr");
		grpobj = this;
		e.stopPropagation();
		InsPropPanel("T"); /// 清空界面属性内容
		$("#GrpTitle").focus();
	});
	
	/// 组标题
	$('#GrpTitle').on('keydown keyup',function(){
		if (grpobj){
			if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
				if($(grpobj).find('.grp-title').length==0){
					$(grpobj).text(this.value);
				}else{
					$(grpobj).find('.grp-title').text(this.value);
				}
				
			}else{
				$("div.select .list-title label").text(this.value);
			}
		}
		//$("div.select .list-title label").text(this.value);
	})
	
	/// 组面板高度
	$('#GrpHeight').numberbox({
		onChange:function(n,o){
			if(n!=""){
				$("div.select").css("min-height",this.value+"px");
				$("div.select .list-item").css("min-height",this.value+"px");
				$("div.select").css("height",this.value+"px");
				$("div.select .list-item").css("height",this.value+"px");
			}
		}
	})
	/*$('#GrpHeight').on('keydown keyup',function(){
		$("div.select").css("min-height",this.value+"px");
		$("div.select .list-item").css("min-height",this.value+"px");
		$("div.select").css("height",this.value+"px");
		$("div.select .list-item").css("height",this.value+"px");
	})*/
	
	/// 选项
	$('#Question').on('keydown keyup',function(){
		if (itemobj){
			if($(itemobj).prop("tagName")=="IMG"){
				$("img.select-li").attr("title",this.value)
			}
			else if ($(itemobj).prop("outerHTML").indexOf("</p>") != "-1"){
				$(itemobj).html(this.value);
			}else{
				$(".select-li span.item").text(this.value);
			}
		}
	})

	$('#TextWidth').numberbox({
		onChange:function(n,o){
			if((n!="")&&(itemobj)){
				if ($(itemobj).prop("outerHTML").indexOf("<input") != "-1"){
					$(".select-li input[type=text]").css("width",parseFloat(n)+"px");
				}
			}
		}
	})
	/// 图片路径
	$('#ImgSrc').on('keydown keyup',function(){
		$("img.select-li").attr("src",PageLogicObj.imageSrc+this.value);
		$("img.select-li").attr("alt","糟糕,图片丢了");
	})
	
	/// 分值
	$('#Score').numberbox({
		onChange:function(n,o){
			if(n!=""){
				$(".select-li input").attr("value",this.value);
				$(".select-li .item-score").text(this.value != ""?"【"+ this.value+"分】":"");
			}
		}
	})
	/*$('#Score').on('keydown keyup',function(){
		//$("div.select .select-li input").attr("value",this.value);
		$(".select-li input").attr("value",this.value);
		$(".select-li .item-score").text(this.value != ""?"【"+ this.value+"分】":"");
	})*/
	
	/// 行数
	$('#rows').numberbox({
		onChange:function(n,o){
			if(n!=""){
				$("table.tb-select-tr tr td").removeClass("tb-select");
				if ($("table.tb-select-tr tr").length > this.value){
					var rows = $("table.tb-select-tr tr").length - this.value;
					for (var i=$("table.tb-select-tr tr").length; rows > 0; i--, rows--){
						$("table.tb-select-tr tr:nth-child("+ i +")").remove();
					}
				}else{
					var html = $("table.tb-select-tr tr").prop("outerHTML");
					var o = $("table.tb-select-tr tr");
					var rows = this.value - $("table.tb-select-tr tr").length;
					for (var i=0; i<rows; i++){
						$("table.tb-select-tr tbody").append(html);
					}	
				}
			}
		}
	})
	/*$('#rows').on('keydown keyup blur',function(event){
		if((event.keyCode==13)||(event.type=="blur")){
			$("table.tb-select-tr tr td").removeClass("tb-select");
			if ($("table.tb-select-tr tr").length > this.value){
				var rows = $("table.tb-select-tr tr").length - this.value;
				for (var i=$("table.tb-select-tr tr").length; rows > 0; i--, rows--){
					$("table.tb-select-tr tr:nth-child("+ i +")").remove();
				}
			}else{
				var html = $("table.tb-select-tr tr").prop("outerHTML");
				var o = $("table.tb-select-tr tr");
				var rows = this.value - $("table.tb-select-tr tr").length;
				for (var i=0; i<rows; i++){
					$("table.tb-select-tr tbody").append(html);
				}	
			}
		}
	})*/
	
	/// 列数
	$('#cols').numberbox({
		onChange:function(n,o){
			if(n!=""){
				$("table.tb-select-tr tr td").removeClass("tb-select");
				if ($("table.tb-select-tr tr:nth-child(1) td").length > this.value){
					var rows = $("table.tb-select-tr tr:nth-child(1) td").length - this.value;
					for (var i=$("table.tb-select-tr tr:nth-child(1) td").length - 1; rows > 0; i--, rows--){
						$("table.tb-select-tr tr td:nth-child("+ i +")").remove();
					}
				}else{
					var html = $("table.tb-select-tr tr:nth-child(1) td").prop("outerHTML");
					var o = $("table.tb-select-tr tr:nth-child(1) td");
					var rows = this.value - $("table.tb-select-tr tr:nth-child(1) td").length;
					for (var i=0; i<rows; i++){
						$("table.tb-select-tr tbody tr").append(html);
					}	
				}
			}
		}
	})
	/*$('#cols').on('keydown keyup blur',function(event){
		if((event.keyCode==13)||(event.type=="blur")){
			$("table.tb-select-tr tr td").removeClass("tb-select");
			if ($("table.tb-select-tr tr:nth-child(1) td").length > this.value){
				var rows = $("table.tb-select-tr tr:nth-child(1) td").length - this.value;
				for (var i=$("table.tb-select-tr tr:nth-child(1) td").length - 1; rows > 0; i--, rows--){
					$("table.tb-select-tr tr td:nth-child("+ i +")").remove();
				}
			}else{
				var html = $("table.tb-select-tr tr:nth-child(1) td").prop("outerHTML");
				var o = $("table.tb-select-tr tr:nth-child(1) td");
				var rows = this.value - $("table.tb-select-tr tr:nth-child(1) td").length;
				for (var i=0; i<rows; i++){
					$("table.tb-select-tr tbody tr").append(html);
				}	
			}
		}
	})*/

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
	$("#btnHelpMsg").popover({
		title:'',
		content:"1.选择量表,点击当前编辑表单,可修改选择的量表内容;"
		+"<br>2.新增量表时,表单分类在【医生站代码模块数据维护-治疗工作站】下维护【治疗评定量表分类】模块，并在模块下维护具体分类数据;"
		+"<br>3.增加单选、多选、表格等元素时需先增加对应面板,选中面板后再增加需要的元素;"
		+"<br>4.表格需要确定行数、列数后再进行合并行、列操作，否则会出现表格不对应;"
		+"<br>5.表格中每个单元格可添加多个单选框且互斥选择,单元格与单元格之间的单选框不互斥;"
		+"<br>6.表格中每个单元格仅可添加一个复选框,单元格与单元格之间的复选框选择互斥;"
		+"<br>7.表格中的单元格无法添加段落,请填写标题;"
		+"<br>8.图片名称需要首先将需要添加的图片放到scripts/dhcdoc/dhcdoccure_hui/image/assscale文件夹下;"
		
	});
	
	$('#B_GenExport').click(function(){
		GenExportHandle();
	});
	$("#EchkSel").checkbox({
		onCheckChange:function(e,value){
			var data=$('#tabExportAssScaleList').treegrid("getData");
			if(value){
				if(data.length>0){
					for(var i=0;i<data.length;i++){
						$('#tabExportAssScaleList').treegrid('checkNode',data[i].ID);	
					}
				}
			}else{
				if(data.length>0){
					for(var i=0;i<data.length;i++){
						$('#tabExportAssScaleList').treegrid('uncheckNode',data[i].ID);	
					}
				}
			}
		}
	})
}

/// 删除界面元素样式
function ClrDocElStyle(){	
	//$("table").removeClass("tb-select-tr");
	//$("td").removeClass("tb-select");
		
	$('.select').removeClass('select');
	$('.select-li').removeClass('select-li');
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
	//$('#GrpTitle,#GrpHeight,#Question,#ImgSrc,#Score,#rows,#cols').val("").removeAttr("disabled");
	$("div.propdiv input").val("").removeAttr("disabled");
	var _$label = $("label[for='Score']");
	if (_$label.length > 0){
	   $(_$label[0]).html("选项分值");
	}
	if (FlagCode == "P"){
		//面板
		$('#GrpTitle').parent().show();
		$('#GrpHeight').parent().show();
		$('#Question').parent().hide();
		$('#TextWidth').parent().hide();
		$('#ImgSrc').parent().hide();
		$('#Score').parent().hide();
		$('#rows').parent().hide();
		$('#cols').parent().hide();
		$HUI.combobox("#RelType").disable();
		$('#GrpTitle').val($("div.select .list-title label").text());       /// 组标题
		$('#GrpHeight').val(parseFloat($("div.select").css("height")).toFixed(2));
	}
	else if (FlagCode == "E" || FlagCode == "L"){
		//，列表/文本
		$('#GrpTitle').parent().hide();
		$('#GrpHeight').parent().hide();
		$('#Question').parent().show();
		if(FlagCode=="E"){
			$('#TextWidth').parent().show();
			$('#TextWidth').val(parseFloat($(".select-li input[type=text]").css("width")).toFixed(2));
		}else{
			$('#TextWidth').parent().hide();
		}
		$('#ImgSrc').parent().hide();
		$('#rows').parent().hide();
		$('#cols').parent().hide();
		$('#Question').val($(".select-li span").text());       /// 选项
		if ($(itemobj).hasClass("validatebox")){
			$('#Score').parent().show();
			$('#Score').val($(".select-li input").attr("value"));  /// 分值
			var _$label = $("label[for='Score']");
			if (_$label.length > 0){
			   $(_$label[0]).html("默认内容");
			}
		}else if ($(itemobj).hasClass("datebox")){
			$('#Score').parent().hide();
		}else{
			$('#Score').parent().show();
			$('#Score').val($(".select-li input").attr("value"));	
		}
		$HUI.combobox("#RelType").enable();
	}else if (FlagCode == "I"){
		//图片
		$('#GrpTitle').parent().hide();
		$('#GrpHeight').parent().hide();
		$('#Question').parent().show();
		$('#TextWidth').parent().hide();
		$('#ImgSrc').parent().show();
		$('#Score').parent().hide();
		$('#rows').parent().hide();
		$('#cols').parent().hide();
		$('#Question').val($(".select-li").text());       /// 选项
		$HUI.combobox("#RelType").disable();
		$('#Question').val($("img.select-li").attr("title"));       /// 选项
		var ImgSrc=$("img.select-li").attr("src");
		var reg=new RegExp(PageLogicObj.imageSrc,"g"); //创建正则RegExp对象   
		var ImgSrc=ImgSrc.replace(reg,"");
		$('#ImgSrc').val(ImgSrc); 
	}
	else if (FlagCode == "S"){
		//段落
		$('#GrpTitle').parent().hide();
		$('#GrpHeight').parent().hide();
		$('#Question').parent().show();
		$('#TextWidth').parent().hide();
		$('#ImgSrc').parent().hide();
		$('#Score').parent().hide();
		$('#rows').parent().hide();
		$('#cols').parent().hide();
		$('#Question').val($(".select-li").text());       /// 选项
		$HUI.combobox("#RelType").disable();
	}
	else if (FlagCode == "T"){
		//表格
		$('#GrpTitle').parent().show();
		$('#GrpHeight').parent().hide();
		$('#Question').parent().hide();
		$('#TextWidth').parent().hide();
		$('#ImgSrc').parent().hide();
		$('#Score').parent().hide();
		$('#Score').parent().hide();
		$('#rows').parent().show();
		$('#cols').parent().show();
		$HUI.combobox("#RelType").disable();
		$('#GrpTitle').val($(grpobj).text());       /// 组标题
	}else{
		$('#GrpTitle').parent().show();
		$('#GrpHeight').parent().show();
		$('#Question').parent().show();
		$('#TextWidth').parent().show();
		$('#ImgSrc').parent().hide();
		$('#Score').parent().show();
		$('#rows').parent().show();
		$('#cols').parent().show();
		$HUI.combobox("#RelType").disable();
		//$('#GrpTitle,#GrpHeight,#Question,#ImgSrc,#Score,#rows,#cols').attr("disabled","disabled");
		$("div.propdiv input").attr("disabled","disabled");
	}
	$HUI.combobox("#RelType").setValue("");
	$('#RelType').parent().hide();
}

/// 页面DataGrid初始定义
function InitPageDataGrid(){
	
	///  定义columns
	var columns=[[
		{field:'ID',title:'ID',width:100,align:'center',hidden:true},
		//{field:'DCASCat',title:'评定量表分类',width:100},
		{field:'DCASDesc',title:'评定量表',width:190},
		{field:'DCASCode',title:'评定量表代码',width:100}
	]];
	$HUI.treegrid("#tabAssScaleList",{
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : true,
		url : $URL+"?ClassName=DHCDoc.DHCDocCure.AssScaleConfig&QueryName=QryAssScaleTree&rows=99999",
		loadMsg : '加载中..',  
		pagination : false,  
		pageSize : 20,
		pageList : [10,20,50],
		rownumbers : false, 
		idField:"ID",
		treeField:'DCASDesc',
		columns :columns,
		onClickRow:function(rowIndex, rowData){
			if(rowData._parentId!=""){
				InsPropPanel();
				InsEditForm(rowData.ID, "");      /// 初始化加载当前评定量表表单
				GetScoreTabHtml(rowData.ID, "");  /// 取评定量表维护表Html
			}
	    },
		onBeforeLoad:function(row,param){
			var ScaleCat=$HUI.combobox("#ScaleCat").getValue();
			var hospID=Util_GetSelHospID();
			var ScaleDesc=$("#ScaleDesc").searchbox("getValue");
			$.extend(param,{Desc:ScaleDesc,HospID:hospID,ScaleCat:ScaleCat});
			$HUI.treegrid("#tabAssScaleList").unselectAll();
		}
	});
	
	var EColumns=[[
		{field:'ID',title:'ID',width:100,align:'center',hidden:true},
		//{field:'DCASCat',title:'评定量表分类',width:100},
		{field:'DCASDesc',title:'评定量表',width:190},
		{field:'DCASCode',title:'评定量表代码',width:100}
	]];
	$HUI.treegrid("#tabExportAssScaleList",{
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		checkbox:true,
		fitColumns : true,
		autoRowHeight : true,
		url : $URL+"?ClassName=DHCDoc.DHCDocCure.AssScaleConfig&QueryName=QryAssScaleTree&rows=99999",
		loadMsg : '加载中..',  
		pagination : false,  
		pageSize : 20,
		pageList : [10,20,50],
		rownumbers : false, 
		idField:"ID",
		treeField:'DCASDesc',
		columns :EColumns,
		onBeforeLoad:function(row,param){
			var ScaleCat=$HUI.combobox("#EScaleCat").getValue();
			var hospID=Util_GetSelHospID();
			var ScaleDesc=$("#EScaleDesc").searchbox("getValue");
			$.extend(param,{Desc:ScaleDesc,HospID:hospID,ScaleCat:ScaleCat});
			$HUI.treegrid("#tabExportAssScaleList").unselectAll();
		}
	});
}

function AssScaleListDataGridLoad(){
	$HUI.treegrid("#tabAssScaleList").reload();
}
function ExportAssScaleListDataGridLoad(){
	$HUI.treegrid("#tabExportAssScaleList").reload();
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
	var ScoreID = $("#EditForm").attr("data-id");   /// 表单ID
	if (ScoreID == ""){
		$.messager.popover({msg: '请选择需要编辑评定量表！',type:'alert',timeout: 1000});
		return;
	}
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
		htmlstr = htmlstr + '		<ul class="list-ul list-ul-panel">';
		htmlstr = htmlstr + '		</ul>';
		htmlstr = htmlstr + '	</div>';
		htmlstr = htmlstr + '</div>';
	$(".form").append(htmlstr);
}

function addItem(className){
	var ScoreID = $("#EditForm").attr("data-id");   /// 表单ID
	if (ScoreID == ""){
		$.messager.popover({msg: '请选择需要编辑评定量表！',type:'alert',timeout: 1000});
		return;
	}
	
	if(className=="par"){
		var css = "";
		var htmlstr = "";
		htmlstr = htmlstr + '<p class="item_par">段落文本</p>';
		if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
			// $(grpobj).html(htmlstr);
		}else{
			$(grpobj).find('.list-item .list-ul').before(htmlstr);
		}
	}else if(className=="img"){
		var css = "";
		var htmlstr = "";
		htmlstr = htmlstr + '<img class="item_img" />';
		if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
			$(grpobj).html(htmlstr);
		}else{
			$(grpobj).find('.list-item .list-ul').before(htmlstr);
		}
	}else{
		var css = "";
		if ($(grpobj).find('.list-ul-item').hasClass('sort-x')){
			css = 'sort-x';
		}
		var grpname = $(grpobj).attr("id");  /// 组号
		var ScoreID = $("#EditForm").attr("data-id");   /// 表单ID
		var id = GetFormEleID(ScoreID);      /// 自动生成表单元素ID
		if((grpname=="")||(typeof grpname=="undefined")){
			if($(grpobj).hasClass('tb-select')){
				var rowIndex=$(grpobj).parent().parent().find("tr").index($(grpobj).parent()[0]);
				var colIndex=$(grpobj).index();
				grpname="grp-table-row"+rowIndex+"-col"+colIndex;
			}else{
				grpname="grp-"+className;
			}
		}
		var css = "";
		var htmlstr = "";
		if((className=="validatebox")||(className=="datebox")){
			if (grpobj){
				if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
					css = className;
				}else{
					css = "draggable"+" "+className;
				}
			}
			
			htmlstr = htmlstr + '<div class="itemClass '+ css +'"><span class="item"></span><input id="'+ className+"-"+id +'" type="text" class="hisui-'+ className+'" /></div>';
		}else{
			htmlstr = htmlstr + '<li class="list-ul-item"><label><input id="'+ className+"-"+id +'" name="'+ grpname +'" type="'+className+'" value="" /><span class="item">待选项</span><span class="item-score"></span></label></li>'; //+'" class="hisui-'+ className 	
		}
		
		if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
			if ($(grpobj).hasClass("tb-select")){
				if((className=="radio")){//||(className=="checkbox")
					if($(grpobj).find('.list-ul').length==0){
						htmlstr='<ul class="list-ul list-ul-tab">'+htmlstr+'</ul>'
						$(grpobj).html(htmlstr);
						//$(grpobj).find('.tb-select').append(htmlstr);		
					}else{
						$(grpobj).find('.list-ul').append(htmlstr);
					}
				}else{
					$(grpobj).html(htmlstr);
				}
			}else{
				$(grpobj).find('.list-item .list-ul-panel').append(htmlstr);
			}
		}else{
			$(grpobj).find('.list-item .list-ul').append(htmlstr);
		}
	}
	//$.parser.parse($(".list-ul"));
	//$.parser.parse(".list-ul-item");
}

/// 插入Check
function check(){
	addItem("checkbox");
}

/// 插入Radio
function radio(){
	addItem("radio");
}

/// 插入Input
function input(){
	addItem("validatebox");
}

/// 插入Input
function datebox(){
	addItem("datebox");
}

/// 插入p 段落
function ins_p(){
	addItem("par");
}

/// 插入 图片
function ins_img(){
	addItem("img");
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
	var ScoreID = $("#EditForm").attr("data-id");   /// 表单ID
	if (ScoreID == ""){
		$.messager.popover({msg: '请选择需要编辑评定量表！',type:'alert',timeout: 1000});
		return;
	}
	
	var htmlstr = "";
	htmlstr = htmlstr + ' <table id="itemList" border="1" cellspacing="0" cellpadding="1" class="form-table">';
	htmlstr = htmlstr + ' <tr><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
	htmlstr = htmlstr + ' <tr><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
	htmlstr = htmlstr + ' <tr><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
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
				
/// 评定量表预览
function review(){
	
	var ScoreID = $("#EditForm").attr("data-id");   /// 表单ID
	if (ScoreID == ""){
		$.messager.alert("提示:","请选择需要预览的评定量表！","warning");
		return;
	}
	var link = "doccure.assscale.view.hui.csp?AssScaleID="+ ScoreID +"&AssScaleCode=" +"&EditFlag=0";
	if(typeof websys_writeMWToken=='function') link=websys_writeMWToken(link);
	window.open(link, '_blank', 'height=500, width=1200, top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// 保存评定量表
function InsScoreTabMain(){
	
	var ScoreCode = $("#ScoreCode").val();  /// 代码
	var ScoreDesc = $("#ScoreDesc").val();  /// 描述
	var ScoreCat = $("#ScoreCat").combobox("getValue");  /// 描述
	if (ScoreCode == ""){
		$.messager.alert("提示:","表单代码不能为空！","warning");
		return;
	}
	if (ScoreDesc == ""){
		$.messager.alert("提示:","表单名称不能为空！","warning");
		return;
	}
	if (ScoreCat == ""){
		$.messager.alert("提示:","请选择量表分类！","warning");
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
	var hospID=Util_GetSelHospID();
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.AssScaleConfig",
		MethodName:"Insert",
		ID:ScoreID,
		Code:ScoreCode,
		Desc:ScoreDesc,
		Cat:ScoreCat,
		HospID:hospID,
		dataType:"text"
	},function(ret){
		if (ret < 0){
			if(ret=="-1"){
				$.messager.alert("提示:","表单代码不能重复！","warning");
			}else if(ret=="-2"){
				$.messager.alert("提示:","表单名称不能重复！","warning");
			}else{ //ed
				$.messager.alert("提示:","保存失败！","warning");
			}
		}else{
			$.messager.popover({msg: '保存成功!',type:'success',timeout: 1000});
			CloseWin();    /// 关闭方法
			AssScaleListDataGridLoad();
			InsEditForm(ret);              /// 初始化加载当前表单
		}	
	})
}

/// 保存评定量表Html
function InsScoreTabHtml(){
	
	ClrDocElStyle();  /// 删除界面元素样式
		
	var ID = $("#EditForm").attr("data-id");   /// 表单ID
	if (ID == ""){
		$.messager.alert("提示:","表单为空！","warning");
		return;
	}

	var Html = $(".container").html(); /// 表单Html
	
	/// 评定量表详情
	var itemArr = [];
	var items = $("input[name^='grp']");
	for (var i=0; i<items.length; i++){
		itemArr.push(items[i].id +"^"+ $("#"+items[i].id).next().text() +"^"+ items[i].type);
	}
	
	var FormEls = itemArr.join("@"); /// 表单元素
	var hospID=Util_GetSelHospID();
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.AssScaleConfig",
		MethodName:"InsHtml",
		_headers:{'X-Accept-Tag':1},
		ID:ID,
		Html:Html,
		FormEls:FormEls,
		HospID:hospID,
		dataType:"text"
	},function(ret){
		if (ret != 0){
			$.messager.alert("提示:","保存失败！错误代码:"+ret,"warning");
		}else{
			$.messager.popover({msg: '保存成功!',type:'success',timeout: 1000});
		}
	})
}

/// 初始化加载当前表单
function InsEditForm(ScoreID, ScoreCode){
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.AssScaleConfig",
		MethodName:"GetAssScale",
		ID:ScoreID,
		dataType:"text"
	},function(ret){
		if (ret !="" ){
			var retArr=ret.split("^");
			$("#EditForm").attr("data-id",retArr[0]);   /// 表单ID
			$("#EditForm").text(retArr[5] +"-"+ retArr[1] +"-"+ retArr[2]);  /// 表单描述
			$("#FormTitle").text(retArr[2]);          /// 表单描述
			if (EditFlag == 1) $(".form").html("");   /// 表单Html
		}else{
			$.messager.alert("提示:","获取量表信息错误！","warning");
		}	
	})
}

/// 取评定量表Html
function GetScoreTabHtml(ID, Code){
	grpobj = ""
	$(".form").html("");   /// 表单Html
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.AssScaleConfig",
		MethodName:"GetAssScaleTabHtml",
		ID:ID,
		ScaleCode:Code,
		dataType:"text"
	},function(ret){
		if (ret !="" ){
			$(".container").html(ret);
		}	
	})
}

/// 自动生成表单元素ID
function GetFormEleID(ID){
	
	var EleID = "";
	EleID=$.cm({
		ClassName:"DHCDoc.DHCDocCure.AssScaleConfig",
		MethodName:"GetFormEleID",
		ID:ID,
		dataType:"text"
	},false)
	
	return EleID;
}

/// 新建
function newScore(){
	
	EditFlag = 1;   /// 表单编辑标志
	mdtPopWin('新建评定量表');
	$("#ScoreCat").combobox("setValue","");
	$("#ScoreCode").val("");   /// 表单代码
	$("#ScoreDesc").val("");   /// 表单描述
}

/// 修改
function editScore(){
	
	EditFlag = 2;  /// 表单编辑标志
	mdtPopWin('修改评定量表');
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

/// 保存评定量表表单
function TakScore(){
	
	InsScoreTabMain(); 
}

/// 删除表格
function del_table(){
	if (grpobj){
		if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
			$.messager.confirm("提示", "是否确认删除表格?",function(r) {
				if (r) {
					if ($(grpobj).hasClass("tb-select")){
						$(grpobj).parent().parent().parent().remove();
					}else{
						var grplist=$(grpobj).find('table');
						grplist.remove();
					}
				}
			})
		}else{
			$.messager.popover({msg: '当前选择面板无表格',type:'alert',timeout: 3000});
		}
	}else{
		$.messager.popover({msg: '要删除什么?',type:'alert',timeout: 3000});
	}
}

/// 删除
function del(){
	if((!grpobj)&&($(".select-li").length==0)){
		$.messager.popover({msg: '要删除什么?',type:'alert',timeout: 3000});
		return;
	}
	$.messager.confirm("提示", "是否确认删除?",function(r) {
		if (r) {
			if (grpobj){
				if ($(grpobj).prop("outerHTML").indexOf("td") != "-1"){
					if ($(grpobj).hasClass("tb-select")){
						$(grpobj).empty();
					}else{
						$(grpobj).remove();
					}
				}else{
					var grplist=$(grpobj).find('.list-item .list-ul');
					if(grplist.length>0){
						var grpchild=$(grplist[0]).children(".select-li");
						if(grpchild.length>0){
							$(grpchild).remove();
						}else{
							$(grpobj).remove();
						}
					}else{
						$(grpobj).remove();
					}
				}
			}
			$(".select-li").remove();
		}
	})
}

/// 初始化加载评定量表表单代码和描述
function initScore(){
	
	var ScoreID = $("#EditForm").attr("data-id");   /// 表单ID
	if (ScoreID == ""){
		$.messager.alert("提示:","表单为空！","warning");
		return;
	}
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.AssScaleConfig",
		MethodName:"GetAssScale",
		ID:ScoreID,
		dataType:"text"
	},function(ret){
		if (ret !="" ){
			var retArr=ret.split("^");
			$("#ScoreCat").combobox("setValue",retArr[4]);
			$("#ScoreCode").val(retArr[1]);   /// 表单代码
			$("#ScoreDesc").val(retArr[2]);   /// 表单描述
		}else{
			$.messager.alert("提示:","获取评定量表信息错误！","warning");
		}	
	})
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

function AssScaleSet(){
	var ScoreID = $("#EditForm").attr("data-id");   /// 表单ID
	if (ScoreID == ""){
		$.messager.alert("提示:","请选择需要设置的评定量表！","warning");
		return;
	}
	var dhwid=$(document.body).width()-400;
	var dhhei=$(document.body).height()-100;
	$('#set-dialog').window('open').window('resize',{
		width:dhwid,
		height:dhhei,
		top: 50,
		left:200
	});
	InitCureLocListDataGrid();
	InitCureArcimListDataGrid();
	
	function InitCureLocListDataGrid(){
		var CureLocListDataGrid=$('#tabCureLocList').datagrid({  
			fit : true,
			width : 'auto',
			border : false,
			striped : true,
			singleSelect : false,
			checkOnSelect:true,
			selectOnCheck:true,
			fitColumns : true,
			autoRowHeight : false,
			nowrap: false,
			collapsible:false,
			url : $URL+"?ClassName=DHCDoc.DHCDocCure.AssScaleConfig&QueryName=FindLoc&rows=99999",
			loadMsg : '加载中..',  
			pagination : false,
			rownumbers : true,
			idField:"LocRowID",
			pageSize : 20,
			pageList : [20,50],
			columns :[[ 
	    			{ field: 'LocRowID', title: 'ID', width: 1, align: 'left', sortable: true,hidden:true}, 
	    			{ field: 'RowCheck',checkbox:true},     
					{ field: 'LocDesc', title:'治疗科室', width: 120, align: 'left', sortable: true},
					{ field: 'selected', title:'', width: 20, align: 'left', hidden: true}
			 ]],
			onBeforeLoad: function(param){
				var hospID=Util_GetSelHospID();
				$.extend(param,{Hospital:hospID,AssScaleID:ScoreID});
				$("#tabCureLocList").datagrid("unselectAll");
			},onLoadSuccess: function(data){
				var rows=data.rows;
				for(var i=0;i<rows.length;i++){
					if(rows[i].selected==1){
						$("#tabCureLocList").datagrid("selectRow",i);
					}	
				}
			},
			 toolbar : [{
				id:'BtnSaveAssScaleLoc',
				text:'保存',
				iconCls:'icon-ok',
				handler:function(){
					SaveAssScaleLoc();
				}
			}]
		});
		PageLogicObj.m_CureLocListDataGrid=CureLocListDataGrid;
	}
	function InitCureArcimListDataGrid(){
		var CureArcimListDataGrid=$('#tabCureArcimList').datagrid({  
			fit : true,
			width : 'auto',
			border : false,
			striped : true,
			singleSelect : true,
			fitColumns : false,
			autoRowHeight : false,
			nowrap: false,
			collapsible:false,
			url : $URL+"?ClassName=DHCDoc.DHCDocCure.AssScaleConfig&QueryName=FindArcim&rows=99999",
			loadMsg : '加载中..',  
			pagination : true,
			rownumbers : true,
			idField:"ID",
			pageSize : 20,
			pageList : [20,50],
			columns :[[ 
	    			{ field: 'ID', title: 'ID', width: 10, align: 'left',hidden:true}, 
	    			{ field: 'ArcimID', title:'ArcimID', width: 10, align: 'left',hidden:true},
	    			{ field: 'arcitmcode', title:'医嘱项代码', width: 150, align: 'left'},
					{ field: 'arcitmdesc', title:'医嘱项名称', width: 300, align: 'left',
						editor:{
							type:'combogrid',
							options:{
								required: true,
								panelWidth:450,
								panelHeight:350,
								idField:'ArcimRowID',
								textField:'ArcimDesc',
								value:'',//缺省值 
								mode:'remote',
								pagination : true,//是否分页   
								rownumbers:true,//序号   
								collapsible:false,//是否可折叠的   
								fit: true,//自动大小   
								pageSize: 10,//每页显示的记录条数，默认为10   
								pageList: [10],//可以设置每页记录条数的列表  
								delay: 500,
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
								columns:[[
									{field:'ArcimDesc',title:'名称',width:400,sortable:true},
									{field:'ArcimRowID',title:'ID',width:120,sortable:true},
									{field:'selected',title:'ID',width:120,sortable:true,hidden:true}
								]],
								onSelect: function (rowIndex, rowData){
									var rows=PageLogicObj.m_CureArcimListDataGrid.datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
									rows.ArcimID=rowData.ArcimRowID;
								},
								onBeforeLoad:function(param){
									var desc=param['q'];
									param = $.extend(param,{Alias:param["q"],HospId:$HUI.combogrid('#_HospList').getValue()});
								}
							}
		        		}},
					{ field: 'arcitmprice', title:'医嘱项价格', width: 150, align: 'left'}
			 ]],
			onBeforeLoad: function(param){
				var hospID=Util_GetSelHospID();
				$.extend(param,{Hospital:hospID,AssScaleID:ScoreID});
				$("#tabCureArcimList").datagrid("unselectAll");
			},onLoadSuccess: function(data){
				PageLogicObj.editRow = undefined;
			},
			toolbar : [{
	            text: '增加',
	            iconCls: 'icon-add',
	            handler: function() { 
	            	if (PageLogicObj.editRow != undefined) {
		            	$.messager.confirm("提示", "存在正在编辑的行,确定将重置当前编辑行.",function(r) {
				            if (r) {
					            PageLogicObj.m_CureArcimListDataGrid.datagrid("rejectChanges");
								PageLogicObj.m_CureArcimListDataGrid.datagrid('unselectAll');
								InsertEditRow();
				            }
				        })
	            	}else{
		            	InsertEditRow();
		            }
	            }
	        },{
	            text: '删除',
	            iconCls: 'icon-cancel',
	            handler: function() {
	                DeleArcim();
	            }
	        },{
	            text: '取消编辑',
	            iconCls: 'icon-redo',
	            handler: function() {
	                PageLogicObj.editRow = undefined;
	                PageLogicObj.m_CureArcimListDataGrid.datagrid("rejectChanges");
	                PageLogicObj.m_CureArcimListDataGrid.datagrid("unselectAll");
	            }
	        },{
				text: '保存',
				iconCls: 'icon-save',
				handler: function() {
					SaveArcim();
				}
			}]
		});
		PageLogicObj.m_CureArcimListDataGrid=CureArcimListDataGrid;
	}
}

function InsertEditRow(){
	PageLogicObj.m_CureArcimListDataGrid.datagrid("insertRow", {
	    index: 0,
	    row: {}
	});
	PageLogicObj.m_CureArcimListDataGrid.datagrid("beginEdit", 0);
	PageLogicObj.editRow = 0;
}

function SaveArcim(){
	if(PageLogicObj.editRow==undefined){
		return;	
	}
	var ScoreID = $("#EditForm").attr("data-id");   /// 表单ID
	if (ScoreID == ""){
		$.messager.alert("提示:","请选择需要设置的评定量表！","warning");
		return;
	}
	var rows=PageLogicObj.m_CureArcimListDataGrid.datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
	if(rows){
		var editors = PageLogicObj.m_CureArcimListDataGrid.datagrid('getEditors', PageLogicObj.editRow);
		var arcrowid = rows.ArcimID;
		if(typeof(arcrowid)=="undefined"){
			arcrowid=""
		}
		if(arcrowid==""){
			$.messager.alert('提示',"请正确选择医嘱项目.","warning");
			return false;
		}
		
		SaveSet(ScoreID,"ARCIM",arcrowid,PageLogicObj.m_CureArcimListDataGrid);
	}
}

function DeleArcim(){
	var rows = PageLogicObj.m_CureArcimListDataGrid.datagrid("getSelections");
    if (rows.length > 0) {
        $.messager.confirm("提示", "确定要删除吗?",
        function(r) {
            if (r) {
				var ids = [];
                for (var i = 0; i < rows.length; i++) {
                    ids.push(rows[i].ID);
                }
                var IndexS=ids.join(',');
                if (IndexS==""){
                    PageLogicObj.editRow = undefined;
	                PageLogicObj.m_CureArcimListDataGrid.datagrid("rejectChanges");
	                PageLogicObj.m_CureArcimListDataGrid.datagrid("unselectAll");
	                return;
                }
                var value=$.m({
					 ClassName:"DHCDoc.DHCDocCure.AssScaleConfig",
					 MethodName:"DelAssScaleSet",
					 ID:IndexS
				},false);
		        if(value=="0"){
			       PageLogicObj.m_CureArcimListDataGrid.datagrid('reload');
			       PageLogicObj.m_CureArcimListDataGrid.datagrid('unselectAll');
			      $.messager.popover({msg: '"删除成功!',type:'success',timeout: 1000});
		        }else{
			       $.messager.alert('提示',"删除失败:"+value);
				   return false;
		        }
		        PageLogicObj.editRow = undefined;
            }
        });
    } else {
        $.messager.alert("提示", "请选择要删除的行", "warning");
    }	
}

function SaveAssScaleLoc(){
	var ScoreID = $("#EditForm").attr("data-id");   /// 表单ID
	if (ScoreID == ""){
		$.messager.alert("提示:","请选择需要设置的评定量表！","warning");
		return;
	}
	var ConfigIdStr="";
	var rows=$("#tabCureLocList").datagrid("getChecked");
	for (var i=0;i<rows.length;i++){
		if (ConfigIdStr=="") ConfigIdStr=rows[i].LocRowID;
		else ConfigIdStr=ConfigIdStr+"^"+rows[i].LocRowID;
	}
	
	if(ConfigIdStr==""){
		$.messager.confirm('提示',"未选择科室,确定将取消所有关联,是否继续?",function(r){
			if(r){
				SaveSet(ScoreID,"CTLOC",ConfigIdStr,PageLogicObj.m_CureLocListDataGrid);
			}else{
				PageLogicObj.m_CureLocListDataGrid.datagrid("reload");
			}
		});
	}else{
		SaveSet(ScoreID,"CTLOC",ConfigIdStr,PageLogicObj.m_CureLocListDataGrid);
	}
	
}

function SaveSet(ID,key,ConfigIdStr,Grid){
	var hospID=Util_GetSelHospID();
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.AssScaleConfig",
		MethodName:"SaveAssScaleSet",
		ID:ID,
		Key:key,
		ConfigIdStr:ConfigIdStr,
		HospID:hospID,
		dataType:"text"
	},function(value){
		if (value != 0){
			var ErrorMsg=value;
			if(value=="-100"){
				ErrorMsg="量表ID为空"
			}else if(value=="-101"){
				ErrorMsg="重置数据失败"
			}else if(value=="-102"){
				ErrorMsg="保存数据失败"
			}else if(value=="-103"){
				ErrorMsg="存在重复的医嘱项"
			}
			$.messager.alert('提示',"保存失败:"+ErrorMsg,"error");
			return;
		}else{
			$.messager.popover({msg: '保存成功!',type:'success',timeout: 1000});
			Grid.datagrid("reload"); 
			if(key=="ARCIM"){
		       	PageLogicObj.m_CureArcimListDataGrid.datagrid('unselectAll');
		        PageLogicObj.editRow = undefined;
			}
		}	
	})
}

function CopyToHosp(){
	var ScoreID = $("#EditForm").attr("data-id");   /// 表单ID
	if (ScoreID == ""){
		$.messager.alert("提示:","请选择需要授权的评定量表！","warning");
		return;
	}
	
	var GenHospObj=GenHospWin("DHC_DocCureAssScale",ScoreID);
	$HUI.dialog("#_HospListWin",{
		onClose:function(){
			AssScaleListDataGridLoad();
		}
	})
	return;
	
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.AssScaleConfig",
		MethodName:"CopyAssScaleToHosp",
		ID:ID,
		HospID:HospID,
		dataType:"text"
	},function(value){
		if (value != 0){
			var ErrorMsg=value;
			if(value=="-100"){
				ErrorMsg="量表ID为空"
			}else if(value=="-101"){
				ErrorMsg="重置数据失败"
			}else if(value=="-102"){
				ErrorMsg="保存数据失败"
			}
			$.messager.alert('提示',"保存失败:"+ErrorMsg,"error");
			return;
		}else{
			$.messager.popover({msg: '保存成功!',type:'success',timeout: 1000});
		}	
	})
}

//量表导出
function B_Exoport(){
	var dhhei=$(document.body).height()-100;
	$('#Export-dialog').dialog('open').dialog('resize',{
		width:500,
		height:dhhei,
		top: 50,
		left:($(document.body).width()-500)/2
	});
	$('#tabExportAssScaleList').treegrid("unselectAll");
	var data=$('#tabExportAssScaleList').treegrid("getData");
	if(data.length>0){
		for(var i=0;i<data.length;i++){
			$('#tabExportAssScaleList').treegrid('uncheckNode',data[i].ID);	
		}
	}

}

function GenExportHandle(){	
/*  	var rtn = $cm({
		dataType:'text',
		ResultSetType:'Excel',
		ExcelName:"治疗评定量表导出",
		ClassName:"DHCDoc.DHCDocCure.AssScaleConfig",
		QueryName:"QryAssScaleToExcel",
		HospID:""
	}, false);
	location.href = rtn;
	return  */
	var ExportIDArr=[];
	var CheckedNodes =$('#tabExportAssScaleList').treegrid('getCheckedNodes','checked');
	if(CheckedNodes.length>0){
		for(var i=0;i<CheckedNodes.length;i++){
			var rowData=CheckedNodes[i];
			if(rowData._parentId==""){
				continue;
			} 
			ExportIDArr.push(rowData.ID);
		}
		
	}
	if(ExportIDArr.length==0){
		$.messager.alert("提示","请选择要导出的量表","warning");
		return;
	}
	$cm({
		ResultSetType:'ExcelPlugin',
		ExcelName:"DHCCureAssScaleToExcel",
		ClassName:"DHCDoc.DHCDocCure.AssScaleConfig",
		QueryName:"QryAssScaleToExcel",
		ExportID:ExportIDArr.join("^"),
		HospID:""
	});
	return;
}
//量表导入
function B_Import(){
	var src="doccure.rbcresplan.import.hui.csp?mClassName=DHCDoc.DHCDocCure.AssScaleConfig&mMethodName=ImportTotalExcel&SplitCount=1&NotShowDetail=Y";
	if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
	var $code ="<iframe width='100%' height='96%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	com_Util.createModalDialog("importDiag","导入", 600, 240,"icon-w-import","",$code,"");
}