//model.report.js
//不良事件统计
//zhouxin
//2019-05-30

var curCondRow=1;
$(function(){ 
	initValue();
	initBTN();
	initPagination();
	initInput();
	addCondition()
	
});

function initInput(){
	$(".lookup-text").on("input propertychange",function(event){
       if($(this).val()==""){
	      $(this).attr("data-id","")
	   }
	});
}

function initValue(){
	var date=(new Date()).Format("yyyy-M-d")
	$('#querySt').datebox('setValue',date)
	$('#queryEd').datebox('setValue',date)
}

function initBTN(){
	$("#queryBTN").on('click',function(){query(1);})
	$("#exportBTN").on('click',function(){exportData();})
	$("#addCondBTN").on('click',function(){addCondition();})
	$("#printBTN").on('click',function(){printData();})
	if($("#quoteflag").val()==1)
	{
		$("#gologin").show();
	}
}

function query(page){
	runClassMethod("web.DHCADVModel","listData",
		{
			model:$("#modelId").val(),
			pid:pid,
			page:page,
			rows:15,
			st:$('#querySt').datebox('getValue'),
			ed:$('#queryEd').datebox('getValue'),
			parStr:getParStr(),
			params:LgHospID+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID //hxy 2020-02-26
		},function(ret){
			initHead(ret);
			var html="";
			var titleStrArr=ret.titleStr.split("^");
			var titleDicArr=ret.titleDicStr.split("^");
			var titleTypeArr=ret.titleTypeStr.split("^");
			var titleHiddenArr=ret.titleHidden.split("^");
			console.log(ret.titleDicStr)
			$.each(ret.rows,function(index,itm){
				html+="<tr>";
				var trArr=itm.value.split("^")
				for(var i=0;i<trArr.length;i++){
					var hidden=titleHiddenArr[i]
					hidden=(hidden=="y")?"none":"";
					var yValue=(titleTypeArr[i]=="dateRange")?titleStrArr[i-1]:trArr[i];
					console.error(titleDicArr[i]);
					if((ret.subModel>0)&&(trArr[0].indexOf("(百分比%)")<0)){
						html+="<td style=display:"
						html+=hidden
						html+="><a  data-y='"+titleDicArr[i]+"' data-y-type='"+titleTypeArr[i]+"' data-y-value='"+yValue+"' data-x='"+titleDicArr[0]+"' data-x-value='"+trArr[0]+"' data-x-type='"+titleTypeArr[0]+"' data-submodel="+ret.subModel+" onClick='openSubModel(this)' style='cursor: pointer'>"+trArr[i]+"</a></td>";
					}else{
						html+="<td style=display:"
						html+=hidden
						html+=">"+trArr[i]+"</td>";	
					}
					
				}
				html+="</tr>";
			})
			$("#tableData").html(html);
			var totalPage=Math.ceil(ret.total/15)
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
		var colspan=ret.titleStr.split("^").length+1
		var html="<tr><th colspan="+colspan+"><h2>"+ret.reportName+"</h2></th></tr>";
		html+="<tr>"+ret.titleHtml+"</tr>";
		$(".dhc-table").find("thead").append(html)		
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
	//alert(parStr)
	window.open("dhcadv.model.report.sub.csp?modelId="+modelId+"&st="+st+"&ed="+ed+"&parStr="+parStr)	
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
				query(current)
			}
		});	
}

function exportData(){
		runClassMethod("web.DHCADVModel","listData",
		{
			model:$("#modelId").val(),
			pid:pid,
			pageFlag:1,
			st:$('#querySt').datebox('getValue'),
			ed:$('#queryEd').datebox('getValue'),
			params:LgHospID+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID //hxy 2020-02-26
		},function(ret){
			var filename=(new Date()).Format("yyyy-MM-dd hh:mm:ss.S");
			exportExcel(ret.rows,filename)
		},'json'
	);
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
	
	input=encodeURIComponent(input)
	var url="dhcadv.model.report.pop.csp?input="+input+"&key="+key+"&type="+type+"&dic="+dic
	var content = '<iframe src="' + url + '" width="100%" height="100%" frameborder="0" scrolling="yes"></iframe>';
    $('#dicDia').dialog({
                content: content,
                maximized: false,//默认最大化
                modal: true
	});
	$('#dicDia').dialog('open')
}
function closeDiv(){
	$('#dicDia').dialog('close')
}
function addCondition(){
	
	curCondRow=curCondRow+1;
	var html=""
	html+='<tr id="'+curCondRow+'Tr"><td><b style="padding-right:5px">查询条件</b>';
	
	html+=getLookUpHtml(curCondRow,1);
	html+=getSelectHtml(curCondRow);
	html+=getLookUpHtml(curCondRow,2);
	html+='</td><td style="padding-left:40px"><b style="padding-right:5px">查询条件</b>';
	html+=getLookUpHtml(curCondRow,3);
	html+=getSelectHtml(curCondRow);
	html+=getLookUpHtml(curCondRow,4);
	html+='</td><td style="padding-left:20px"><span style="cursor: pointer" onclick="addCondition()"><span  class="icon icon-add" >&nbsp;&nbsp;&nbsp;&nbsp;</span>增加行</span></td>>';
	html+='</td><td style="padding-left:20px"><span style="cursor: pointer" onclick="removeCond('+curCondRow+')"><span  class="icon icon-remove" >&nbsp;&nbsp;&nbsp;&nbsp;</span>删除行</span></td></tr>';
	$("#condTable").append(html);
	//initInput();
}
function removeCond(row){
	$("#"+row+"Tr").remove();
}


function getSelectHtml(){
	var html=""
	html+='	<select id="stateBox" class="combox" >'
	html+='		<option value="=">等于</option>'
	html+='		<option value=">">大于</option>'
	html+='		<option value=">=">大于等于</option>'
	html+='		<option value="<=">小于等于</option>'
	html+='		<option value="<">小于</option>'
	html+='	</select>'
	return html;
}

function getLookUpHtml(row,column){
	var html="";
	var key=row+"-"+column
	html+='<span class="lookup" >'
	html+='		<input data-id="" class="textbox lookup-text validatebox-text"  style="width: 118px; height: 28px; line-height: 28px;" id="'+key+'" onkeypress="return onKeyPress(event,this)" data-key='+key+' type="text" >'
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
			model:$("#modelId").val(),
			pid:pid,
			pageFlag:1,
			st:$('#querySt').datebox('getValue'),
			ed:$('#queryEd').datebox('getValue'),
			params:LgHospID+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID //hxy 2020-02-26
		},function(ret){
			var filename=(new Date()).Format("yyyy-MM-dd hh:mm:ss.S");
			printHtml(ret.rows)
		},'json'
	);
}

function toggleExecInfo(obj){
	
	if($(obj).hasClass("expanded")){
		$(obj).removeClass("expanded");
		$(obj).html("高级查询");
		$("#condTable").hide();
		$("#dashline").hide();
		$("#condTd").hide();
		
	}else{
		$(obj).addClass("expanded");
		$(obj).html("隐藏");
		$("#condTable").show();
		$("#dashline").show();
		$("#condTd").show();
	}
}
