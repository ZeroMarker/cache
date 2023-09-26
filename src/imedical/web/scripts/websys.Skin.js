
CompObj.cls = "websys.Skin";
CompObj.compName = "websys_Skin";
CompObj.tabelPre = "T";
CompObj.model = ["RowId","MainFontSize","MainFontFamily","MainBGColor","MenuBGColor","MenuSelectedBGColor","TableTHBGColor",
"RowOddBGColor","RowEvenBGColor","ClsRowSelectedBGColor","ActiveFlag","BtnBackgroundColor","SCode","SDesc","TitleBackgroundColor","TableBackgroundColor","TableBorderColor"];
CompObj.modelUi=["","",
	{type:"combobox",
	data:[{Code:"Microsoft Yahei",Desc:"΢���ź�"},
	{Code:"Tahoma",Desc:"Tahoma"},
	{Code:"����",Desc:"����"},
	{Code:"Times New Roman",Desc:"Times New Roman"},
	{Code:"sans-serif",Desc:"ͨ������"}
	]}
	,"","","","",
	"","","",
	{type:"combobox",data:[{Code:"Y",Desc:"����"},{Code:"N",Desc:"������"}]},
	"","","","","",""
];
t["NotFindLessFile"] = "<span style='color:red;'>��ѯ����skin/default/css/websys.less�ļ�!</span>"+
	"<br><span>1.�����С������mount��ӦĿ¼.����Ȩ��.</span>"+
	"<br><span>2.ȷ��skin/default/css/websys.less</span>";
t["ActiveNumNotReqiure"]="ϵͳ����ͬʱ�������Ƥ��";
t["ActiveNotNull"]="��ѡ���Ƿ񼤻�"
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
