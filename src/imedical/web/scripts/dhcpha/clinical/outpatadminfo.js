var url="dhcpha.clinical.action.csp";
var PcntItmID="";var EpisodeID="";
$(function(){
	EpisodeID=getParam("EpisodeID");
	PcntItmID=getParam("PcntItmID");
	$('input[name=type]').bind('click',function(){
		
		///加载医嘱信息
		$('#drggrid').datagrid({url:url+'?action=GetPatOrdItmDetail',	
			queryParams:{
				EpisodeID:EpisodeID,
				Type:this.value}
		})
	})
	
	/// 不可用
	$('input[name=res]').bind('click',function(){
		SetElementEnable(this.value);
	})
	
	InitPageDataGrid();
	InitPagePatAdmInfo();
	LoadPCommentRes();
	
	$('a:contains("保存点评")').bind('click',SaveCommentRet);
	$('a:contains("重新点评")').bind('click',reSaveCommentRet);
	$('a:contains("上一例")').bind('click',LastSample);
	$('a:contains("下一例")').bind('click',NextSample);
	$('a:contains("添加不合理问题类型")').bind('click',creUnCommentReason);
	
	$('#resdesc').bind("focus",function(){
		if(this.value=="请输入评价意见..."){
			$('#resdesc').val("");
		}
	});
	
	$('#resdesc').bind("blur",function(){
		if(this.value==""){
			$('#resdesc').val("请输入评价意见...");
		}
	});
})

///初始化页面dagagrid
function InitPageDataGrid()
{
	//定义columns
	var columns=[[
	    {field:'basflag',title:'基',width:40,align:'center',formatter:SetCellColor},
	    {field:'antflag',title:'抗',width:40,align:'center',formatter:SetCellColor},
	    {field:'arcitmdesc',title:'药品名称',width:180,align:'left'},
	    {field:'form',title:'剂型',width:80,align:'left'},
	    {field:'spec',title:'规格',width:80,align:'left'},
	    {field:'instru',title:'给药途径',width:80,align:'left'},
	    {field:'dosage',title:'剂量',width:60,align:'left'},
	    {field:'uomdesc',title:'给药单位',width:60,align:'left'},
	    {field:'qty',title:'开具数量',width:60,align:'left'},
	    {field:'freq',title:'频次',width:40,align:'left'},
	    {field:'doctor',title:'医生',width:60,align:'left'},
	    {field:'spamt',title:'医嘱费用[元]',width:80,align:'left'},
	    {field:'ordtime',title:'医嘱时间',width:130,align:'left'},
	    {field:'purpose',title:'用药目的',width:90,align:'left',formatter:SetCellColor},
	    {field:'prescno',title:'处方号',width:90,align:'left'},
	    {field:'pyuser',title:'调配药师',width:70,align:'left'},
	    {field:'fyuser',title:'发药药师',width:70,align:'left'}
	]];
	
	//定义datagrid
	$('#drggrid').datagrid({
		title:'医嘱列表',    
		url:'',
		border:false,
		rownumbers:true,
		columns:columns,
	    singleSelect:true,
	    pageSize:8,
		pageList:[8,16],
		loadMsg: '正在加载信息...',
		pagination:true,
	    onDblClickRow: rowhandleClick
	});
	
	InitdatagridRow();
}

//初始化列表使用
function InitdatagridRow()
{
	for(var k=0;k<10;k++)
	{
		$('#drggrid').datagrid('insertRow',{
			index: 0, // 行索引
			row: {
				orditm:'', phcdf:'', incidesc:'', genenic:''
			}
		});
	}
}

///dagagrid 双击事件
function rowhandleClick()
{
	
}

///加载页面病人就诊信息
function InitPagePatAdmInfo()
{
 	//请求数据
	$.post(url,{ action:"GetPatEssInfo", "EpisodeID":EpisodeID},function(data){
		var data=eval('('+data+')');
		$('.btn-ui-span input').each(function(){
			$(this).val(data[this.id]);
		})
		///加载医嘱信息
		$('#drggrid').datagrid({
			url:url+'?action=GetPatOrdItmDetail',	
			queryParams:{
				EpisodeID:EpisodeID}
		})
	});
	SetElementEnable("Y");
}

/// 保存点评结果
function SaveCommentRet(){
	if(PcntItmID == ""){
		$.messager.alert("提示:","点评单明细ID不能为空！");
		return false;
	}
	if(!$("input[type='radio'][name='res']:checked").length){
		$.messager.alert("提示:","药物治疗性使用是否合理结果不能为空！");
		return false;
	}
	var resflag = $("input[type='radio'][name='res']:checked").val();  /// 药物治疗性使用评价结果
	
	if((resflag == "N")&($('#resdesc').val()=="请输入评价意见...")){
		$.messager.alert("提示:","请填写点评结果描述！");
		return false;
	}
	var resdesc = "";
	if(resflag == "N"){
		resdesc = $('#resdesc').val();					 /// 药物治疗性使用评价结果描述
	}
	var otherparam = PcntItmID;
	//保存数据
	$.post(url+'?action=SaveCommentRet',{"userid":LgUserID,"resflag":resflag,"resdesc":resdesc,"otherparam":otherparam},function(jsonString){
		var resobj = jQuery.parseJSON(jsonString);
		if(resobj.ErrCode != "0"){
			$.messager.alert("提示:","错误原因:"+resobj.ErrMsg);
			return false;
		}
		$.messager.alert("提示:","点评成功!");
	});
}

/// 保存点评结果【重新点评】 实际为撤销点评结果
function reSaveCommentRet(){
	if(PcntItmID == ""){
		$.messager.alert("提示:","点评单明细ID不能为空！");
		return false;
	}

	//保存数据
	$.post(url+'?action=reSaveCommentRet',{"PcntItmID":PcntItmID},function(jsonString){
		var resobj = jQuery.parseJSON(jsonString);
		if(resobj.ErrCode != "0"){
			$.messager.alert("提示:","错误原因:"+resobj.ErrMsg);
			return false;
		}
		$.messager.alert("提示:","撤销点评结果成功!");
	});

	ClrUIComponent(); ///清空界面组件
	SetElementEnable("Y");
}

/// 样例切换【下一例】
function NextSample(){
	$.post(url+'?action=getCommentItm',{"PcntItmID":PcntItmID,"SortDir":"1"},function(jsonString){
		var resobj = jQuery.parseJSON(jsonString);
		if(resobj.ErrCode != "0"){
			$.messager.alert("提示:","提取点评明细错误:"+resobj.ErrMsg);
			return false;
		}
		if(resobj.ErrCode == "0"){
			ClrUIComponent(); ///清空界面组件
			EpisodeID=resobj.EpisodeID;
			PcntItmID=resobj.PcntItmID;
			window.parent.refreshTabs(resobj.EpisodeID,"Out",resobj.PcntItmID,resobj.PatName);
			InitPagePatAdmInfo();
			LoadPCommentRes(); ///加载点评结果
		}
	});
}

/// 样例切换【上一例】
function LastSample(){
	$.post(url+'?action=getCommentItm',{"PcntItmID":PcntItmID,"SortDir":"-1"},function(jsonString){
		var resobj = jQuery.parseJSON(jsonString);
		if(resobj.ErrCode != "0"){
			$.messager.alert("提示:","提取点评明细错误:"+resobj.ErrMsg);
			return false;
		}
		if(resobj.ErrCode == "0"){
			ClrUIComponent(); ///清空界面组件
			EpisodeID=resobj.EpisodeID;
			PcntItmID=resobj.PcntItmID;
			window.parent.refreshTabs(resobj.EpisodeID,"Out",resobj.PcntItmID,resobj.PatName);
			InitPagePatAdmInfo();
			LoadPCommentRes(); ///加载点评结果
		}
	});
}

/// 保存选中的原因于评价意见
function setSelectedUnCmtRea(UnReasonDesc){
	$('#resdesc').val(UnReasonDesc);
}

/// 创建不合理原因窗口
function creUnCommentReason(){
	
	if($('#unrwin').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="unrwin"></div>');
	$('#unrwin').append('<div id="unrcmtdg"></div>');
	
	$('#unrwin').window({
		title:'查找点评单',
		collapsible:true,
		border:true,
		closed:"true",
		width:1100,
		height:450
	});
        
	// 定义columns
	var columns=[[
		{field:"id",title:'id',width:120,hidden:true},
		{field:"text",title:'描述',width:980},
		{field:"_parentId",title:'_parentId',width:70,hidden:true}
	]];

	$('#unrcmtdg').treegrid({    
	    url: url+'?action=jsonQueryUnCmtReason',  
	    idField:'id', 
	    treeField:'text',
	    rownumbers:true,
	    fit:true,
	    queryParams:{WayCode:"P"},
	    columns:columns,
	    onDblClickRow:function(rowData){
		    var UnReasonDesc=rowData.text;
		    setSelectedUnCmtRea(UnReasonDesc)
			$('#unrwin').window('close');
	    }   
	});

	$('#unrwin').window('open');
}

/// 设置指定元素的可用状态
function SetElementEnable(EnableFlag){
	if(EnableFlag == "N"){
		$("a:contains('添加不合理问题类型')").attr("disabled",false);
		$("#resdesc").attr("disabled",false);
	}else{
		$("a:contains('添加不合理问题类型')").attr("disabled",true);
		$("#resdesc").attr("disabled",true);
	}
}

/// 加载点评结果
function LoadPCommentRes(){
	$.post(url+'?action=LoadPCommentRes',{"PcntItmID":PcntItmID},function(jsonString){
		var resobj = jQuery.parseJSON(jsonString);
		if(resobj.ErrCode != "0"){
			$.messager.alert("提示:","提取点评结果明细错误:"+resobj.ErrMsg);
			return false;
		}
		if(resobj.ErrCode == "0"){
			if(resobj.PcntCntRes == "Y"){
				$("input[type='radio'][name='res'][value='Y']").attr("checked",true); ///取消复选框
			}
			if(resobj.PcntCntRes == "N"){
				SetElementEnable("N");
				$("input[type='radio'][name='res'][value='N']").attr("checked",true); ///取消复选框
				$("#resdesc").val(resobj.PcntResDesc);
			}
		}
	});
}

/// 清空界面元素
function ClrUIComponent(){
	$("input[type='radio'][name='res']:checked").attr("checked",false); ///取消复选框
	$("#resdesc").val("请输入评价意见...");
}

/// 设置列颜色
function SetCellColor(value,rowData,rowIndex){
	return '<span style="color:red;font-weight:bold;">'+value+'</span>';
}