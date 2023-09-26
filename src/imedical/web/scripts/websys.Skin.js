
CompObj.cls = "websys.Skin";
CompObj.compName = "websys_Skin";
CompObj.tabelPre = "T";
CompObj.model = ["RowId","MainFontSize","MainFontFamily","MainBGColor","MenuBGColor","MenuSelectedBGColor","TableTHBGColor",
"RowOddBGColor","RowEvenBGColor","ClsRowSelectedBGColor","ActiveFlag","BtnBackgroundColor","SCode","SDesc","TitleBackgroundColor","TableBackgroundColor","TableBorderColor"];
CompObj.modelUi=["","",
	{type:"combobox",
	data:[{Code:"Microsoft Yahei",Desc:"微软雅黑"},
	{Code:"Tahoma",Desc:"Tahoma"},
	{Code:"宋体",Desc:"宋体"},
	{Code:"Times New Roman",Desc:"Times New Roman"},
	{Code:"sans-serif",Desc:"通用字体"}
	]}
	,"","","","",
	"","","",
	{type:"combobox",data:[{Code:"Y",Desc:"激活"},{Code:"N",Desc:"不激活"}]},
	"","","","","",""
];
t["NotFindLessFile"] = "<span style='color:red;'>查询不到skin/default/css/websys.less文件!</span>"+
	"<br><span>1.如果是小机请先mount相应目录.分配权限.</span>"+
	"<br><span>2.确保skin/default/css/websys.less</span>";
t["ActiveNumNotReqiure"]="系统不能同时激活二种皮肤";
t["ActiveNotNull"]="请选择是否激活"
$(function(){
	var fontFamilyColArr = ["TMainFontFamily"];
	var fontSizeColArr = ["TMainFontSize"];
	var bgcolorColArr = ["TClsRowSelectedBGColor","TMainBGColor","TMenuBGColor","TMenuSelectedBGColor","TRowEvenBGColor","TRowOddBGColor","TTableTHBGColor","TBtnBackgroundColor","TSCode","TSDesc","TTitleBackgroundColor","TTableBackgroundColor","TTableBorderColor"];
	var cols = $("#t"+CompObj.compName).datagrid("options").columns[0];
	var colsLen = cols.length;
	for (var i =0; i<colsLen ; i++){
		if(bgcolorColArr.join("^").indexOf(cols[i].field)>-1){
			cols[i].styler=function(value){return 'background-color:'+value+';';};
		}
		if(fontFamilyColArr.join("^").indexOf(cols[i].field)>-1){
			cols[i].styler=function(value){return 'font-family:'+value+';';};
		}
		if(fontSizeColArr.join("^").indexOf(cols[i].field)>-1){
			cols[i].styler=function(value){return 'font-size:'+value+';';};
		}
	}
	initEvent();
	var cpcss = "../scripts_lib/jQuery/colorpicker/css/colorpicker.css";
	var cpjs = "../scripts_lib/jQuery/colorpicker/js/colorpicker.js";
	$("<link"+">"+"</link"+">").attr({href:cpcss,media:'screen',rel:'stylesheet',type:'text/css'}).appendTo($('head'));
	$.getScript(cpjs, function() {
		$('#MainBGColor,#ClsRowSelectedBGColor,#MenuBGColor,#MenuSelectedBGColor,#RowEvenBGColor,#RowOddBGColor,#TableTHBGColor,#BtnBackgroundColor,#TitleBackgroundColor,#TableBackgroundColor,#TableBorderColor').ColorPicker({
			onSubmit: function(hsb, hex, rgb, el) {
				$(el).val("#"+hex).css("color","#"+hex);
				$(el).ColorPickerHide();
			},
			onBeforeShow: function() {
				$(this).ColorPickerSetColor(this.value);
			}
		}).bind('keydown',function(){$(this).ColorPickerSetColor(this.value);});
	});
	$("#SCode,#SDesc").on('keydown',function(e){
		if (e.keyCode==13) $("#Find").click();
	});
	$('#twebsys_Skin').datagrid("options").onBeforeLoad = function(param){
		var c = $("#SCode").val();
		var d = $("#SDesc").val();
		param = $.extend(param,{Code:c||d});
	}
		
})
