$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	initInvoiceInfo();	
	//$('.div-all').empty()
	
}
function initInvoiceInfo()
{
	$.cm({
		ClassName:"web.DHCEQ.Plat.LIBPNotice",
			MethodName:"GetOnePNoticeNew",
	        RowID:getElementValue("RowID"),
	},
	function(jsonData){
		if (jsonData.SQLCODE<0) {$.messager.alert(jsonData.Data);return;}
		createInvoice(jsonData);
	});	
}
function createInvoice(jsonData)
{
	$("#tNoticeList").empty(); //每次加载之前移除样式
		createInvoiceList(jsonData);
		
		
	
}

function createInvoiceList(jsonData)
{
	var Standard=""
	var Source=""
	var Remark=""
	var PublishDept=""
	var Operater=""
	var SubTitle=""
	var Abstract=""
	var Picture=""
	var AppendFile=""
	var RowID=getElementValue("RowID")
	if (jsonData.Data["NStandard"]!="")
	{
		var Standard="国家标准："+jsonData.Data["NStandard"]
	}    
	if (jsonData.Data["NSource"]!="")
	{
		var Source="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;来源："+jsonData.Data["NSource"]
	} 
	if (jsonData.Data["NRemark"]!="")
	{
		var Remark="（"+jsonData.Data["NRemark"]+"）"
	}    
	if (jsonData.Data["NPublishDept"]!="")
	{
		var PublishDept="发布部门："+jsonData.Data["NPublishDept"]
	}    
	if (jsonData.Data["OperateLogUser"]!="")
	{
		var Operater="编辑："+jsonData.Data["OperateLogUser"]
	}    
	if (jsonData.Data["NSubTitle"]!="")
	{
		var SubTitle="&nbsp;——&nbsp;"+jsonData.Data["NSubTitle"]
	}    
	if (jsonData.Data["NAbstract"]!="")
	{
		var Abstract='<div class="news-abstract">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+jsonData.Data["NAbstract"]+'</div>'
	} 
	/* 
	if (jsonData.Data["NContentType"]=="1")
	{
		var Pictureurl='href="#" onclick="javascript:PictureDetail('+RowID+')"';
		var Picture='<a '+Pictureurl+'>相关图片</a>'
	}    
	if (jsonData.Data["NContentType"]=="2")
	{
		var AppendFileurl='href="#" onclick="javascript:AppendFileDetail('+RowID+')"';
		var AppendFile='<a '+AppendFileurl+'>相关文件</a>'
	}    
	*/
	var html=""
	html='<div class="news-view" style="">'+
	'<div class="news-header">'+
	''+
	'<div class="news-title">'+jsonData.Data["NTitle"]+SubTitle+'</div>'+
	Abstract+
	//'<div class="news-abstract">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+jsonData.Data["NAbstract"]+'</div>'+
	'<p><span class="source">'+Standard+Source+'</span></p>'+	
	'<p>'+
	'<span class="operater">'+PublishDept+'&nbsp;&nbsp;'+'</span>'+
	'<span class="date">'+jsonData.Data["NPublishDate"]+"&nbsp;&nbsp;"+jsonData.Data["NPublishUser"]+'</span>'+
	'</p>'+
	'</div>'+
	'<div class="news-main">'+
	
	'<p><span class="news-content">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+jsonData.Data["NContent"]+'</span></p>'+
	
	'<p><span class="news-remark">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+Remark+'</span></p>'+
	
	
	'</div>'+
	'<div class="news-footer">'+
	Picture+AppendFile+
	'<p>'+
	'<span class="operater">'+Operater+'<i> · </i></span>'+
	'<span class="date">'+jsonData.Data["OperateLogDate"]+" "+jsonData.Data["OperateLogTime"]+'</span>'
	
	
	+'</p></div></div>'
	
	
	$("#tNoticeList").append(html);
	
}

function PictureDetail()
{
	var ReadOnly="1"
	var result=getElementValue("RowID");
	if (result<=0) return
	
	//GR0033
	var Status="2";
	var str='dhceq.process.picturemenu.csp?&CurrentSourceType=67&CurrentSourceID='+result+'&Status='+Status+'&ReadOnly='+ReadOnly;
	window.open(str,'_blank','left='+ (screen.availWidth - 1150)/2 +',top='+ ((screen.availHeight>750)?(screen.availHeight-750)/2:0) +',width=1150,height=750,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes')
}

function AppendFileDetail()
{
	
	var result=getElementValue("RowID");
	if (result<=0) return
	
	var Status="2";
	//Modefied by zc0060 20200329 文件上传改造  begin
	//var str='dhceq.process.appendfile.csp?&CurrentSourceType=67&CurrentSourceID='+result+'&Status='+Status
	var str='dhceq.plat.appendfile.csp?&CurrentSourceType=67&CurrentSourceID='+result+'&Status='+Status+'&ReadOnly=';
	//Modefied by zc0060 20200329 文件上传改造  end
	window.open(str,'_blank','left='+ (screen.availWidth - 1150)/2 +',top='+ ((screen.availHeight>750)?(screen.availHeight-750)/2:0) +',width=1150,height=750,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes')
	
}