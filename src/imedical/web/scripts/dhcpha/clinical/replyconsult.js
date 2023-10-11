/// Creator:    bianshuai
/// CreateDate: 2015-01-29
/// Descript:   咨询回复界面

var url="dhcpha.clinical.action.csp";
if ("undefined"!==typeof(websys_getMWToken)){
	url += "?MWToken="+websys_getMWToken()
	}
var consultID = "";
var rowIndex = "";	// qunianpeng 2016/10/31
$(function(){
	
	consultID = getParam("consultID");
	rowIndex = getParam("rowIndex");	// qunianpeng 2016/10/31
		
	InitConBakDetList(); //回复列表
	QyConsultDetail();   //查询回复明细
	
	
	$('#consDetDesc').bind("focus",function(){
		if(this.value==$g("请输入评论信息...")){
			$('#consDetDesc').val("");
		}
	});
	
	$('#consDetDesc').bind("blur",function(){
		if(this.value==""){
			$('#consDetDesc').val($g("请输入评论信息..."));
		}
	});
})

//初始化病人列表
function InitConBakDetList()
{
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'consItmID',title:'consItmID',width:100,hidden:true},
		{field:'consDDate',title:$g('回复日期'),width:140},
		{field:'consDName',title:$g('回复人'),width:70},
		{field:'consDDesc',title:$g('问题解答'),width:700,
			  	    formatter:setMonLevelShow},
		{field:'consDOkFlag',title:$g('满意度'),width:90,align:'center',formatter:SetCellUrl},
		{field:'LkBkDetial',title:$g('操作'),width:100,align:'center',formatter:SetCellOpUrl}
	]];

	/**
	 * 定义datagrid
	 */
	var option = {
		title:$g('咨询答复列表'),
		nowrap:false,
		singleSelect:true
		};
	var conBakDetListComponent = new ListComponent('conBakDetList', columns, '', option);
	conBakDetListComponent.Init();
	
	initScroll("#conBakDetList");//初始化显示横向滚动条
    $('#conBakDetList').datagrid('loadData', {total:0,rows:[]});
}

/// 查询问题明细
function QyConsultDetail(){

	$.post(url+'&action=QyConsultDetail',{"consultID":consultID},function(jsonString){

		var resobj = jQuery.parseJSON(jsonString);
				
		$("#consName").val(resobj.consName);    //姓名
		$("#consTele").val(resobj.consTele);    //联系电话
		$('#consIden').val(resobj.consIdenDesc);    //咨询身份
		$('#consType').val(resobj.quesTypeDesc);    //问题类型
		$('#consDate').val(resobj.consDate);    //咨询日期
		$('#consDesc').text(resobj.consDesc);   //咨询描述
	});
	
	///咨询答复明细
	$('#conBakDetList').datagrid({
		url:url + "&action=QueryConsultBakDet",	
		queryParams:{
			consultID:consultID}
	});
}

 /**
  * 保存咨询数据
  */
function saveConsultDetail(){
	
	var consDetDesc = $('#consDetDesc').val();  ///评论描述
	if (consDetDesc == $g("请输入评论信息...")){
		showMsgAlert("","评论信息不能为空！");
		return;
	}	
	if($('#consDetDesc').val().length>800){
		showMsgAlert("","评论信息不能超过800字！");
		return;
		}
	var lkConsultID = "";
	var conDataList = LgUserID +"^"+ consDetDesc +"^"+ lkConsultID;
	var $deptListdatagrid = parent.$("#conDetList");
	if ($deptListdatagrid.length > 0){
		var rows = $deptListdatagrid.datagrid('getSelections');  //nisijia 2016-09-30
		var rowvalue=rows[0].finiFlag;
		var newAnsCount=rows[0].ansCount;	// qunianpeng 2016/10/31
		if (rowvalue=="Y"){
			showMsgAlert("","已完成的记录不可以再回复！");
			clearConsultDetail();
			return;		
		}
	}
	//保存数据
	$.post(url+'&action=saveConsultDDetail',{"consultID":consultID,"conDataList":conDataList},function(jsonString){
		
		var jsonConsObj = jQuery.parseJSON(jsonString);
		if (jsonConsObj.ErrorCode == "0"){
			$('#conBakDetList').datagrid('reload'); //重新加载
			clearConsultDetail();
			$.messager.alert("提示","保存成功！");
		}else{
			$.messager.alert("提示:","提交失败,错误原因："+jsonConsObj.ErrorMessage);
		}
	});
}

/// 清空重置
function clearConsultDetail(){
	$('#consDetDesc').val($g("请输入评论信息..."));  ///评论描述
}

/// 消息提示窗口
function showMsgAlert(ErrMsg , ErrDesc){
	$.messager.alert("提示:","<font >" + ErrMsg + "</font><font style='color:red;'>" + ErrDesc + "</font>");
}


function setMonLevelShow(value,rowData,rowIndex)
{
	var html="";
	if(value != ""){
		html='<p style="line-height:1.2;text-indet:2em;letter-spacimg:3.2;">'+value+'</p>';
	}
	return html;
}

//操作
function SetCellUrl(value, rowData, rowIndex)
{
	var html = "";
	if (value == "Y"){
		html = "<span style='margin:0px 5px;font-weight:bold;color:red;'>"+$g("满意")+"</span>";		
	}else{
		html = "<span style='margin:0px 5px;font-weight:bold;color:green;'>No</span>";
		}
    return html;
}

//操作
function SetCellOpUrl(value, rowData, rowIndex)
{
	var html = "";
	if (rowData.consDOkFlag != "Y"){
		html = "<a href='#' onclick='adoptConsult("+"\""+rowData.consItmID+"\""+","+"\"Y\""+","+"\""+rowData.consDName+"\""+")' style='margin:0px 5px;text-decoration:none;'>"+$g("评价")+"</a>";
	}else{
		html = "<a href='#' onclick='adoptConsult("+"\""+rowData.consItmID+"\""+","+"\"N\""+","+"\""+rowData.consDName+"\""+")' style='margin:0px 5px;text-decoration:none;'>"+$g("取消评价")+"</a>";
		}
    return html;
}

/// 设置采纳标准意见
function adoptConsult(consItmID, consOkFlag,consDName){
	//alert(consDName)
	//alert(LgUserName)
	//保存数据
	if(LgUserName!=consDName){
		showMsgAlert("","无权修改别人的满意度！");    //hezg 2018-7-13
		}
		else{
	$.post(url+'&action=saveAdoptConsult',{"consItmID":consItmID, "consOkFlag":consOkFlag},function(jsonString){

		var jsonConsObj = jQuery.parseJSON(jsonString);
		if (jsonConsObj.ErrorCode == "0"){
			if(consOkFlag=="Y"){
			showMsgAlert("","评价成功！");
			$('#conBakDetList').datagrid('reload'); //重新加载
			}
			else{
			showMsgAlert("","取消评价！");
			$('#conBakDetList').datagrid('reload'); //重新加载	
				}
		}else{
			$.messager.alert("提示:","设置失败,错误原因："+jsonConsObj.ErrorMessage);
		}
	});
		}
}