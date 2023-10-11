//model.js
//不良事件报表子报表
//zhouxin
//2019-07-15
var modelId="",st="",ed="",parStr="",pid=0;
var LgParam=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgHospID;
$(function(){
	InitControl();
	initPagination();
	query(1);
});
/// 初始化
function InitControl()
{
	modelId=getParam("modelId");
	st=getParam("st");  
	ed=getParam("ed");
	parStr=getParam("parStr");  
	// 获取 pid
	// 获取模板id 与 pid
	if(modelId!=""){
		runClassMethod("web.DHCADVModel","GetModelInfo",{'model':modelId},
		function(data){
			pid=data.split("$$")[1];
			$("#tbhead").html(data);
		},"text",false);
	}
}

function query(page){
	runClassMethod("web.DHCADVModel","listData",
	{
		model:modelId,
		pid:pid,
		page:page,
		rows:15,
		st:st,
		ed:ed,
		parStr:parStr,
		params:LgParam
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
					var yValue=titleStrArr[i-1];
					console.error(titleDicArr[i]);
					///if((ret.subModel>0)&&(trArr[0].indexOf("(百分比%)")<0)){
					///	html+="<td style=display:";
					///	html+=hidden;
					///	html+="><a  data-y='"+titleDicArr[i]+"' data-y-type='"+titleTypeArr[i]+"' data-y-value='"+yValue+"' data-x='"+titleDicArr[0]+"' data-x-value='"+trArr[0]+"' data-x-type='"+titleTypeArr[0]+"' data-submodel="+ret.subModel+" onClick='openSubModel(this)' style='cursor: pointer'>"+trArr[i]+"</a></td>";
					///}else{
						html+="<td style=display:";
						html+=hidden;
						html+=">"+trArr[i]+"</td>";	
					///}
					
				}
				html+="</tr>";
			})
			$("#tableData").html(html);
		var totalPage=Math.ceil(ret.total/15);
		$("#pagination").pagination("setPage", page, totalPage);

	},'json');	
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
	var linkmodelId=$(obj).attr("data-submodel");
	var x=$(obj).attr("data-x");
	var xType=$(obj).attr("data-x-type");
	var xValue=$(obj).attr("data-x-value");
	var y=$(obj).attr("data-y");
	var yType=$(obj).attr("data-y-type");
	var yValue=$(obj).attr("data-y-value");
	
	var del=String.fromCharCode(1);
	var linkparStr="",condType=2;
	if(xType=="dateRange"){
		condType=1;
	}
	linkparStr+=parStr;
	linkparStr+="^"+condType+del+x+del+xValue+del+xType;
	linkparStr+="^1"+del+y+del+yValue+del+yType;
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:$g('报告编辑'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		width:screen.availWidth-210,    ///2017-11-23  cy  修改弹出窗体大小 1250
		height:screen.availHeight-210
	});
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.model.report.sub.csp?modelId='+linkmodelId+"&st="+st+"&ed="+ed+"&parStr="+escape(linkparStr)+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
	//window.open("dhcadv.model.report.sub.csp?modelId="+linkmodelId+"&st="+st+"&ed="+ed+"&parStr="+escape(linkparStr))	
}
