﻿//十三项指标Gui
var obj = new Object();
function InitThirteenIndexWin(){
	$("#KeyWords").keywords({
        singleSelect:true,
        items:[
            {text:'医院感染发病(例次)率',id:13,selected:true},
            {text:'医院感染现患(例次)率',id:1},
            {text:'医院感染病例漏报率',id:2},
            {text:'多重耐药菌感染发现率',id:3},
            {text:'多重耐药菌检出率',id:4},
            {text:'医务人员手卫生依从率',id:5},
            {text:'住院患者抗菌药物使用率',id:6},
            {text:'住院患者抗菌药物治疗前病原学送检率',id:7},
            {text:'Ⅰ类切口手术手术部位感染率',id:8},
            {text:'Ⅰ类切口手术抗菌药物预防使用率',id:9},
            {text:'血管导管相关血流感染发病率',id:10},
            {text:'呼吸机相关肺炎发病率',id:11},
            {text:'导尿管相关泌尿道感染发病率',id:12}
        ]
	});
	/*筛选条件1(医院感染发病例次率,医院感染现患例次率,医院感染病例漏报率,多重耐药菌感染发现率,多重耐药菌检出率
			   住院患者抗菌药物使用率,Ⅰ类切口手术手术部位感染率,Ⅰ类切口手术抗菌药物预防使用率,血管导管相关血流感染发病率
			   ,呼吸机相关肺炎发病率,导尿管相关泌尿道感染发病率)*/
	obj.html_1='<table class="search-table">'
			+'	<tr>'
			+'		<td class="r-label">'
			+'			<label for="cboYear">快速选择</label>'
			+'		</td>'
			+'		<td>'
			+'			<input class="hisui-combobox textbox" id="cboYear" style="width:92px" />'
			+'			<input class="hisui-combobox textbox" id="cboMonth" style="width:94px" />'
			+'		</td>'
			+'	</tr>'
			+'	<tr>'
			+'		<td class="r-label">'
			+'			<label for="dtDateFrom">开始日期</label>'
			+'		</td>'
			+'		<td>'
			+'			<input class="hisui-datebox textbox" id="dtDateFrom" style="width:190px"/>'	
			+'		</td>'
			+'	</tr>'
			+'	<tr>'
			+'		<td class="r-label">'
			+'			<label for="dtDateTo">结束日期</label>'
			+'		</td>'
			+'		<td>'
			+'			<input class="hisui-datebox textbox" id="dtDateTo" style="width:190px"/>'
			+'		</td>'
			+'	</tr>'
			+'</table>'
			+'<div style="text-align:center">'
			+'	<a id = "btnSearchTable" href="#" class="hisui-linkbutton" data-options="iconCls:\'icon-w-paper\'">表统计</a>  '
			+'</div>'
	//筛选条件2(医务人员手卫生依从率)
	obj.html_2='<table class="search-table">'
			+'	<tr>'
			+'		<td class="r-label">'
			+'			<label for="cboYear">快速选择</label>'
			+'		</td>'
			+'		<td>'
			+'			<input class="hisui-combobox textbox" id="cboYear" style="width:92px" />'
			+'			<input class="hisui-combobox textbox" id="cboMonth" style="width:93px" />'
			+'		</td>'
			+'	</tr>'
			+'	<tr>'
			+'		<td class="r-label">'
			+'			<label for="dtDateFrom">开始日期</label>'
			+'		</td>'
			+'		<td>'
			+'			<input class="hisui-datebox textbox" id="dtDateFrom" style="width:190px"/>'	
			+'		</td>'
			+'	</tr>'
			+'	<tr>'
			+'		<td class="r-label">'
			+'			<label for="dtDateTo">结束日期</label>'
			+'		</td>'
			+'		<td>'
			+'			<input class="hisui-datebox textbox" id="dtDateTo" style="width:190px"/>'
			+'		</td>'
			+'	</tr>'
			+'	<tr>'
			+'		<td class="r-label">调查方式</td>'
			+'		<td >'
			+'			<input class="textbox" id="cboMethod" style="width:190px" >'
			+'		</td>'
			+'	</tr>'
			+'	<tr>'
			+'		<td class="r-label">职业</td>'
			+'		<td >'
			+'			<input class="textbox" id="cboObsType" style="width:190px" >'
			+'		</td>'
			+'	</tr>'
			+'</table>'
			+'<div style="text-align:center">'
			+'	<a id = "btnSearchTable" href="#" class="hisui-linkbutton" data-options="iconCls:\'icon-w-paper\'">表统计</a>  '
			+'</div>'
	//筛选条件3(住院患者抗菌药物治疗前病原学送检率)
	obj.html_3='<table class="search-table">'
			+'	<tr>'
			+'		<td class="r-label">'
			+'			<label for="cboYear">快速选择</label>'
			+'		</td>'
			+'		<td>'
			+'			<input class="hisui-combobox textbox" id="cboYear" style="width:92px" />'
			+'			<input class="hisui-combobox textbox" id="cboMonth" style="width:93px" />'
			+'		</td>'
			+'	</tr>'
			+'	<tr>'
			+'		<td class="r-label">'
			+'			<label for="dtDateFrom">开始日期</label>'
			+'		</td>'
			+'		<td>'
			+'			<input class="hisui-datebox textbox" id="dtDateFrom" style="width:190px"/>'	
			+'		</td>'
			+'	</tr>'
			+'	<tr>'
			+'		<td class="r-label">'
			+'			<label for="dtDateTo">结束日期</label>'
			+'		</td>'
			+'		<td>'
			+'			<input class="hisui-datebox textbox" id="dtDateTo" style="width:190px"/>'
			+'		</td>'
			+'	</tr>'
			+'	<tr>'
			+'		<td class="r-label">'
			+'			<label for="useSubDateType">用药时间<br>类型设置</label>'
			+'		</td>'
			+'		<td>'
			+'			<input class="hisui-combobox textbox" id="useSubDateType" style="width:190px" />'
			+'		</td>'
			+'	</tr>'
			+'	<tr>'
			+'		<td class="r-label">'
			+'			<label for="cboSubDateType">送检时间<br>类型设置</label>'
			+'		</td>'
			+'		<td>'
			+'			<input class="hisui-combobox textbox" id="cboSubDateType" style="width:190px" />'
			+'		</td>'
			+'	</tr>'
			+'	<tr>'
			+'		<td class="r-label">'
			+'			<label for="cboSubHourType">使用前送<br>检时长</label>'
			+'		</td>'
			+'		<td>'
			+'			<input class="hisui-combobox textbox" id="cboSubHourType" style="width:190px" />'
			+'		</td>'
			+'	</tr>'
			+'</table>'
			+'<div style="text-align:center">'
			+'	<a id = "btnSearchTable" href="#" class="hisui-linkbutton" data-options="iconCls:\'icon-w-paper\'">表统计</a>  '
			+'</div>'
	//默认加载医院感染发病率
	$('#LeftDiv').html(obj.html_1);
	
	$.parser.parse();
	//InitFloatWin(obj);
	InitThirteenIndexWinEvent(obj);
	//默认初始化(1-医院感染发病（例次）率)
	obj.LoadEvent(arguments);
	
	return obj;
}
