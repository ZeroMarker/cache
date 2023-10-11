//model.report.js
//不良事件统计
//zhouxin
//2019-05-30
var Code="",Quoteflag="",ModelID="",pid=0;
var curCondRow=1;
var LgParam=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgHospID;
var condArray= [{ "val": "and", "text": $g("并且") },{ "val": "or", "text": $g("或者") }]; //逻辑关系
var stateBoxArray= [{ "val": "=", "text": $g("等于") },{ "val": ">", "text": $g("大于") },{ "val": ">=", "text": $g("大于等于") },{ "val": "<=", "text": $g("小于等于") },{ "val": "<", "text": $g("小于") }]; //条件
$(function(){ 
	InitControl();
	InitCombobox();			
	initValue();
	initBTN();
	initPagination();
	initInput();
	addCondition();
	
});
/// 初始化
function InitControl()
{
	Code=getParam("Code");
	Quoteflag=getParam("Quoteflag");  // 配置进入传值 空， 首页进入传值 1
	if(Quoteflag=="1"){
		$("#statempTd").show(); // 首页进入 显示主题统计下拉框
		$("#gologin").show();
		$("#tableform").css({width:'90%',margin:'10px 100px 0 100px'})
	}else{
		$("#nourthlayout").hide();
		$("#tableform").css({width:'97%',margin:'10px 10px 0 10px'});
		$("#centerlayout").css({height:'auto'});
		$(".layout-panel").css({'position':'static'});
	}
	
	// 获取模板id 与 pid
	if(Code!=""){
		runClassMethod("web.DHCADVModel","GetModelInfo",{'code':Code},
		function(data){
			ModelID=data.split("$$")[2];
			pid=data.split("$$")[1];
			$("#tbhead").html(data);
		},"text",false);
	}
	
}
///初始化下拉框数据
function InitCombobox()
{
	// 统计主题
	$('#statemp').combobox({
		url:$URL+"?ClassName=web.DHCADVCOMMONPART&MethodName=QueryStaTemp&HospDr="+LgHospID,
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		onSelect:function(option){
		// 获取模板id 与 pid
		if(option.code!=""){
			runClassMethod("web.DHCADVModel","GetModelInfo",{'code':option.code},
			function(data){
				ModelID=data.split("$$")[2];
				pid=data.split("$$")[1];
				$("#tbhead").html(data);
				$("#tableData").html("");
			},"text",false);
		}

		}
	})
	//逻辑关系
	$('#condCombox').combobox({
		panelHeight:"auto", 
		data:condArray
	});
}

function initInput(){
	$(".lookup-text").on("input propertychange",function(event){
       if($(this).val()==""){
	      $(this).attr("data-id","");
	   }
	});
}

function initValue(){
	runClassMethod("web.DHCADVCOMMON","GetStaEndDate",{'LgParam':LgParam},function(data){
		var tmp=data.split("^"); 
		$('#querySt').datebox('setValue',tmp[0]);
		$('#queryEd').datebox('setValue',tmp[1]);
	},'',false)
}

function initBTN(){
	$("#queryBTN").on('click',function(){query(1);});
	$("#exportBTN").on('click',function(){exportData();});
	$("#addCondBTN").on('click',function(){addCondition();});
	$("#printBTN").on('click',function(){printData();});
}

function query(page){
	if(ModelID==""){
		$.messager.alert('提示','请选择统计主题');
	}
	runClassMethod("web.DHCADVModel","listData",
		{
			model:ModelID,
			pid:pid,
			page:page,
			rows:15,
			st:$('#querySt').datebox('getValue'),
			ed:$('#queryEd').datebox('getValue'),
			parStr:getParStr(),
			params:LgParam //hxy 2020-02-26
		},function(ret){
			initHead(ret);
			var html="";
			var titleStrArr=ret.titleStr.split("^");
			var titleDicArr=ret.titleDicStr.split("^");
			var titleTypeArr=ret.titleTypeStr.split("^");
			var titleHiddenArr=ret.titleHidden.split("^");
			//console.log(ret.titleDicStr)
			$.each(ret.rows,function(index,itm){
				html+="<tr>";
				var trArr=itm.value.split("^")
				for(var i=0;i<trArr.length;i++){
					var hidden=titleHiddenArr[i]
					hidden=(hidden=="y")?"none":"";
					var yValue=(titleTypeArr[i]=="dateRange")?titleStrArr[i-1]:trArr[i];
					console.error(titleDicArr[i]);
					if((ret.subModel>0)&&(trArr[0].indexOf("(百分比%)")<0)){
						html+="<td style=display:";
						html+=hidden;
						html+="><a  data-y='"+titleDicArr[i]+"' data-y-type='"+titleTypeArr[i]+"' data-y-value='"+yValue+"' data-x='"+titleDicArr[0]+"' data-x-value='"+trArr[0]+"' data-x-type='"+titleTypeArr[0]+"' data-submodel="+ret.subModel+" onClick='openSubModel(this)' style='cursor: pointer'>"+trArr[i]+"</a></td>";
					}else{
						html+="<td style=display:";
						html+=hidden;
						html+=">"+trArr[i]+"</td>";	
					}
					
				}
				html+="</tr>";
			})
			$("#tableData").html(html);
			var totalPage=Math.ceil(ret.total/15);
			$("#pagination").pagination("setPage", page, totalPage);
			initChart(ret);
			initPie(ret);
			initLine(ret);
		},'json'
	);	
}
function initHead(ret){
	if(ret.titleHtml!=""){
		$(".dhc-table").find("tr").remove();
		var colspan=ret.titleStr.split("^").length+1;
		var html="<tr><th colspan="+colspan+"><h2>"+ret.reportName+"</h2></th></tr>";
		html+="<tr>"+ret.titleHtml+"</tr>";
		$(".dhc-table").find("thead").append(html);		
	}

}
function openSubModel(obj){
	var st=$('#querySt').datebox('getValue');
	var ed=$('#queryEd').datebox('getValue');
	var modelId=$(obj).attr("data-submodel");
	var x=$(obj).attr("data-x");
	var xType=$(obj).attr("data-x-type");
	var xValue=$(obj).attr("data-x-value");
	var y=$(obj).attr("data-y");
	var yType=$(obj).attr("data-y-type");
	var yValue=$(obj).attr("data-y-value");
	
	var del=String.fromCharCode(1);
	var parStr="",condType=2;
	if(xType=="dateRange"){
		condType=1;
	}
	parStr+=condType+del+x+del+xValue+del+xType;
	parStr+="^1"+del+y+del+yValue+del+yType;
	
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:$g('报告编辑'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		width:screen.availWidth-200,    ///2017-11-23  cy  修改弹出窗体大小 1250
		height:screen.availHeight-200
	});
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.model.report.sub.csp?modelId='+modelId+"&st="+st+"&ed="+ed+"&parStr="+escape(parStr)+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
	//window.open("dhcadv.model.report.sub.csp?modelId="+modelId+"&st="+st+"&ed="+ed+"&parStr="+escape(parStr))	

}
function initPagination(){
		$("#pagination").pagination({
			currentPage: 0,
			totalPage: 0,
			isShow: true,
			homePageText: "首页",
			endPageText: "尾页",
			prevPageText: "上一页",
			nextPageText: "下一页",
			callback: function(current) {
				query(current);
			}
		});	
}

function exportData(){
		runClassMethod("web.DHCADVModel","listData",
		{
			model:ModelID,
			pid:pid,
			pageFlag:1,
			st:$('#querySt').datebox('getValue'),
			ed:$('#queryEd').datebox('getValue'),
			params:LgParam //hxy 2020-02-26
		},function(ret){
			var filename=(new Date()).Format("yyyy-MM-dd hh:mm:ss.S");
			exportExcel(ret.rows,filename);
		},'json');
}


function onKeyPress(e,obj){

	if(e.which)
        keyCode = e.which;
    else if(e.keyCode)
        keyCode = e.keyCode;
	if(keyCode == 13) {
		var key=$(obj).attr("data-key");
		var input=$(obj).val();
		openDiv(input,key)
	}
}

function showDic(obj){
	var key=$(obj).attr("data-key");
	var input=$(obj).prev().val();
	openDiv(input,key)
}
function openDiv(input,key){
	
	var keyArr=key.split("-");
	var type=(keyArr[1]%2 ==0) ?"tree":"datagrid";
	var dic=0;
	if(type=="tree"){
		var tmpKey=keyArr[0]+"-"+(keyArr[1]-1);
		dic=$("#"+tmpKey).attr("data-id");
	}
	
	input=encodeURIComponent(input);
	var url="dhcadv.model.report.pop.csp?input="+input+"&key="+key+"&type="+type+"&dic="+dic;
	var content = '<iframe src="' + url + '" width="90%" height="100%" frameborder="0" scrolling="yes"></iframe>';
    $('#dicDia').dialog({
        content: content,
        maximized: false,//默认最大化
        modal: true
	});
	$('#dicDia').dialog('open');
}
function closeDiv(){
	$('#dicDia').dialog('close');
}
/////////////////////////////////////高级查询条件////////////////////////////////////////
// 增加行
function addCondition(){
	
	curCondRow=curCondRow+1;
	var html=""
	html+='<tr id="'+curCondRow+'Tr"><td><b style="padding-left:30px">'+$g("查询条件")+'</b>';
	html+=getLookUpHtml(curCondRow,1);
	html+=getSelectHtml(curCondRow,1);
	html+='<span style="padding-left:20px;"><input class="dhcc-input" id="QueCond"'+curCondRow+"-"+1+' style="width:120"/></span>';
	html+='</td><td style="padding-left:60px"><b style="padding-left:30px">'+$g("查询条件")+'</b>';
	html+=getLookUpHtml(curCondRow,2);
	html+=getSelectHtml(curCondRow,2);
	html+='<span style="padding-left:20px;"><input class="dhcc-input" id="QueCond"'+curCondRow+"-"+2+' style="width:120"/></span>';
	html+='</td><td style="padding-left:20px"><span style="cursor: pointer" onclick="addCondition()"><span  class="icon icon-add" >&nbsp;&nbsp;&nbsp;&nbsp;</span>'+$g("增加行")+'</span></td>>';
	if(curCondRow>2){
		html+='</td><td style="padding-left:20px"><span style="cursor: pointer" onclick="removeCond('+curCondRow+')"><span  class="icon icon-remove" >&nbsp;&nbsp;&nbsp;&nbsp;</span>'+$g("删除行")+'</span></td></tr>';
	}
	$("#condTable").append(html);
	//条件
	$("input[id^=stateBox"+curCondRow+"-]").combobox({
		panelHeight:"auto", 
		data:stateBoxArray
	});
	
}
// 删除行
function removeCond(row){
	$("#"+row+"Tr").remove();
}
// 条件语句
function getSelectHtml(row,column){
	var key=row+"-"+column;
	var html='<span style="padding-left:20px;">';
	html+='<input  id="stateBox'+key+'" style="width:80;" class="easyui-combobox" data-options="valueField:\'val\',textField:\'text\'"/>'
	html+='</span>'
	return html;
}
// 查询条件 输入框加载
function getLookUpHtml(row,column){
	var html="";
	var key=row+"-"+column
	html+='<span class="lookup" style="padding-left:20px;">'
	html+='		<input class="dhcc-input" class="textbox lookup-text validatebox-text"  style="width: 120px;" id="'+key+'" onkeypress="return onKeyPress(event,this)" data-key='+key+' type="text" >'
	html+='		<span class="lookup-arrow" style="height: 28px;" onclick="showDic(this)" data-key='+key+'></span>'
	html+='</span>'
	return html;
}

/***
 * ┌───┐   ┌───┬───┬───┬───┐ ┌───┬───┬───┬───┐ ┌───┬───┬───┬───┐ ┌───┬───┬───┐
 * │Esc│   │ F1│ F2│ F3│ F4│ │ F5│ F6│ F7│ F8│ │ F9│F10│F11│F12│ │P/S│S L│P/B│  ┌┐    ┌┐    ┌┐
 * └───┘   └───┴───┴───┴───┘ └───┴───┴───┴───┘ └───┴───┴───┴───┘ └───┴───┴───┘  └┘    └┘    └┘
 * ┌───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───────┐ ┌───┬───┬───┐ ┌───┬───┬───┬───┐
 * │~ `│! 1│@ 2│# 3│$ 4│% 5│^ 6│& 7│* 8│( 9│) 0│_ -│+ =│ BacSp │ │Ins│Hom│PUp│ │N L│ / │ * │ - │
 * ├───┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─────┤ ├───┼───┼───┤ ├───┼───┼───┼───┤
 * │ Tab │ Q │ W │ E │ R │ T │ Y │ U │ I │ O │ P │{ [│} ]│ | \ │ │Del│End│PDn│ │ 7 │ 8 │ 9 │   │
 * ├─────┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴─────┤ └───┴───┴───┘ ├───┼───┼───┤ + │
 * │ Caps │ A │ S │ D │ F │ G │ H │ J │ K │ L │: ;│" '│ Enter  │               │ 4 │ 5 │ 6 │   │
 * ├──────┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴────────┤     ┌───┐     ├───┼───┼───┼───┤
 * │ Shift  │ Z │ X │ C │ V │ B │ N │ M │< ,│> .│? /│  Shift   │     │ ↑ │     │ 1 │ 2 │ 3 │   │
 * ├─────┬──┴─┬─┴──┬┴───┴───┴───┴───┴───┴──┬┴───┼───┴┬────┬────┤ ┌───┼───┼───┐ ├───┴───┼───┤ E││
 * │ Ctrl│    │Alt │         Space         │ Alt│    │    │Ctrl│ │ ← │ ↓ │ → │ │   0   │ . │←─┘│
 * └─────┴────┴────┴───────────────────────┴────┴────┴────┴────┘ └───┴───┴───┘ └───────┴───┴───┘
 */
function getParStr(){
	var retArr=[];
	var cond=$("#condCombox").val();
	$("#condTable").find("td").each(function(index,obj){
		if($(obj).children().length<3){
			return true;
		}
		var column=$(obj).children().eq(1).find("input").attr("data-id")
		if(column==""){
			return true;	
		}
		var columnDic=$(obj).children().eq(3).find("input").attr("data-id")
		var columnValue=$(obj).children().eq(3).find("input").val()
		var op=$(obj).children().eq(2).val()
		if(columnValue==""){
			return true;
		}
		
		var columType="dic";
		if(columnDic==""){
			type=2;
			value=$.trim(columnValue);
		}else{
			type=1;
			value=columnValue;
			column=columnDic;
		}
		
		//比较类型_$c(1)_列_$c(1)_值_$c(1)_columType_$c(1)_逻辑关系
		var par=type;
		par+=String.fromCharCode(1)+column;
		par+=String.fromCharCode(1)+value;
		par+=String.fromCharCode(1)+columType;
		par+=String.fromCharCode(1)+op;
		par+=String.fromCharCode(1)+cond;
		retArr.push(par);
	})
	return retArr.join("^")
}
///打印
function printData()
{
	runClassMethod("web.DHCADVModel","listData",
		{
			model:ModelID,
			pid:pid,
			pageFlag:1,
			st:$('#querySt').datebox('getValue'),
			ed:$('#queryEd').datebox('getValue'),
			params:LgParam //hxy 2020-02-26
		},function(ret){
			var filename=(new Date()).Format("yyyy-MM-dd hh:mm:ss.S");
			printHtml(ret.rows)
		},'json'
	);
}

function toggleExecInfo(obj){
	
	if($(obj).hasClass("expanded")){
		$(obj).removeClass("expanded");
		$(obj).html($g("高级查询"));
		$("#condTable").hide();
		$("#dashline").hide();
		$("#condTd").hide();
		
	}else{
		$(obj).addClass("expanded");
		$(obj).html($g("隐藏"));
		$("#condTable").show();
		$("#dashline").show();
		$("#condTd").show();
	}
}
///回首页
function Gologin(){
	location.href='dhcadv.homepage.csp';
}
