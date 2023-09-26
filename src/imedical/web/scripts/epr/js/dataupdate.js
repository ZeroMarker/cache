/*
*Desc:调用Ajax方法
*Creater:chenwenjun
*CreatDate:090507
*/
function getFunParams(param)
{
	//增加分页参数_CurrentPage和_PageSize --add by yang 2012-3-27
	var _CurrentPage = 1;
	var _PageSize = defaultPageSize;
	if(Ext.getCmp('inputPage') == null || typeof(Ext.getCmp('inputPage')) == 'undefined')
	{
		_CurrentPage = 1;
	}
	else{
		_CurrentPage = Ext.getCmp('inputPage').getValue();
	}
	if(Ext.getCmp('cbxPageSize') == null || typeof(Ext.getCmp('cbxPageSize')) == 'undefined')
	{
		_PageSize = defaultPageSize;
	}
	else
	{
		_PageSize = Ext.getCmp('cbxPageSize').getValue();
	}
	//--------------------------------------------------
	var lastPage = "true";
	if ((typeof(param) != 'undefined')&&(param == "false")) {
		lastPage = "false";
	}
	else if ((typeof(toLastPage) != 'undefined')) {
		lastPage=toLastPage
	} 
	
	var funparams = {
			PatientID:_PatientID,
			EpisodeID:_EpisodeID,
			ProfileID:_ProfileID,
			CategoryID:_CategoryID,
			IsShowAll: _IsShowAll,
			IsShowSubsequent:_IsShowSubsequent,
			TemplateDocID:_TemplateDocID,
			CurrentPage:_CurrentPage, //add by yang 2012-3-27
			PageSize:_PageSize, 		  //add by yang 2012-3-27
			LastPage:lastPage
			};			
	return funparams;
}

function afterFunOperate(issuc,functiontype, rtnmsg, rtndata)
{
	//document.getElementById("statusbar").innerHTML = "";	
	lastSelectTr = '';
	Ext.get('centerListTab').unmask();	
	if (issuc && functiontype=="html"){document.getElementById("EPRList").innerHTML = rtndata;}
	setPower();		//设置权限			add by zhuj on 2009-12-9
	setPagePara();	//分页 --add by yang 2012-3-27
}

function ajaxAction(param)
{
	//document.getElementById("statusbar").innerHTML = "<img width=16 height=16 src='../scripts/epr/Pics/loading.gif'>载入数据,请稍候...</img>";
	Ext.get('centerListTab').mask('载入数据,请稍候...', 'x-mask-loading');
	callfunction(param);
	if (toLastPage) {
		toLastPage='false';
	}	
}

function callfunction(param)
{
	var funparams = getFunParams(param);
	Ext.Ajax.timeout = 60000;
	Ext.Ajax.request({
		url: funurl, 
		params: funparams, 
		success: function(response, options) {
			if (response == null){afterFunOperate(false,"syserror","返回值无效","");return;}
			var isHtml = (response.responseText.substr(0,1)== '<'?true:false);
			if (isHtml){afterFunOperate(true,'html','',response.responseText);return;}
			else
			{
				var responseObj=Ext.util.JSON.decode(response.responseText);
				afterFunOperate(responseObj.Suc,responseObj.AppMethod,responseObj.RtnMsg,response.RtnData);
			}
			toLastPage="false";
		},
		failure:function(response, options) { 
			alert("服务器在响应请求时失败！请再次登录重试！\n\n" + response.responseText); 
			afterFunOperate(false,"syserror","","");
		}  
	}); 
}

//获取总记录数   add by yang 2012-3-27
function setPagePara(){
	//获取html中隐藏input中总记录数的值
	var totalRowsCount = document.getElementById("totalRowsCount").getAttribute("value");
	var currentPage = document.getElementById("currentPageNum").getAttribute("value");
	var pageSize = Ext.getCmp('cbxPageSize').getValue();
	//总页数是记录数除以每页记录数的上取整
	var totalPages = Math.ceil(totalRowsCount / pageSize);
	//赋给相应控件
	Ext.getCmp('lblCurrentPage').setText(currentPage);
	Ext.getCmp('inputPage').setValue(currentPage);
	Ext.getCmp('lblTotalRows').setText(totalRowsCount);
	Ext.getCmp('lblTotalPages').setText(totalPages);
	
	//根据最页数和当前页设定首页，上一页，下一页，末页按钮是否可用
	if(totalPages == 1){
		//总共一页，则禁用首页，上一页，下一页，末页
		Ext.getCmp('btnFirstPage').disable();
		Ext.getCmp('btnPreviousPage').disable();	
		Ext.getCmp('btnNextPage').disable();
		Ext.getCmp('btnLastPage').disable();
	}
	else{
		//总页数多于一页
		//首页，则禁用首页，上一页，启用下一页，末页
		if(currentPage == 1){
			Ext.getCmp('btnFirstPage').disable();
			Ext.getCmp('btnPreviousPage').disable();
			Ext.getCmp('btnNextPage').enable();
			Ext.getCmp('btnLastPage').enable();
		}
		//介于首页和末页之间，启用所有
		else if (currentPage > 1 && currentPage < totalPages){
			Ext.getCmp('btnFirstPage').enable();
			Ext.getCmp('btnPreviousPage').enable();
			Ext.getCmp('btnNextPage').enable();
			Ext.getCmp('btnLastPage').enable();
		}
		//末页，则禁用末页，下一页，启用上一页，首页
		else if (currentPage == totalPages){
			Ext.getCmp('btnFirstPage').enable();
			Ext.getCmp('btnPreviousPage').enable();
			Ext.getCmp('btnNextPage').disable();
			Ext.getCmp('btnLastPage').disable();
		}
		//输入数据大于末页，在跳转函数已改为末页，按末页处理
		else{
			Ext.getCmp('btnFirstPage').enable();
			Ext.getCmp('btnPreviousPage').enable();
			Ext.getCmp('btnNextPage').disable();
			Ext.getCmp('btnLastPage').disable();
		}
	}
}
