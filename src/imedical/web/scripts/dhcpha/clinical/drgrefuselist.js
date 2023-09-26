// 描述:医生反馈
// 编写日期:2015-05-27
// 作者:bianshuai

//门诊根据医生ID及科室ID过滤出对应信息
var doctorID = getParam("Doctor");
var docLocID = getParam("docLocID");
//住院根据病人ADM
var EpisodeID=getParam("EpisodeID");
var monitorID=getParam("monitorID");
//弹出窗体大小
window.resizeTo(1065,630); 

var url="dhcpha.clinical.action.csp";
$(function(){
	if (monitorID != ""){
		addPatRefusePanel(1,monitorID);
	}else{
		$.post(url,{action:"getPatRefuseList", "DoctorID":doctorID, "EpisodeID":EpisodeID},function(res){
			//var monArr=[2143,2142] //res.split("^");
			if (res==0){return;}
			var monArr=res.replace(/(^\s*)|(\s*$)/g,"").split("^");
		
			//$('div.panel-title').append('<span style="font-weight:bold;font-size:12pt;font-family:华文楷体;color:red;">[当前待处理病人数：<span style="font-size:16pt;padding:0px 5px 0px 5px;">'+monArr.length+'</span>]</span>');
		
			for(var i=0;i<monArr.length;i++){
				addPatRefusePanel(i+1,monArr[i]);
			}
		});
	}
	$('textarea').live("focus",function(){
		if(this.value=="请输入反馈理由..."){
			$(this).val("");
		}
	});
	
	$('textarea').live("blur",function(){
		if(this.value==""){
			$(this).val("请输入反馈理由...");
		}
	});
	
	$('a:contains("维护模板")').live("click",function(){
		medAdvTemp();
	});
	
	$('a:contains("个人模板")').live("click",function(){
		var MonitorID = this.id.split("_")[1];
		createSuggestWin(MonitorID);
		//$.messager.alert("提示","引用模板功能,暂不可使用！");
	});
	
	$('a:contains("反馈")').live("click",function(){
		var MonitorID = this.id.split("_")[1];
		Meth_Appeal(MonitorID);
	});
	
	$('a:contains("接受")').live("click",function(){
		var MonitorID = this.id.split("_")[1];
		Meth_Agree(MonitorID);
	});
})

/// 反馈panel列表
function addPatRefusePanel(i,monitorID)
{
	//var htmlstr = '<div id="rf_'+monitorID+'" class="btn-ui-div" style="border:2px solid #95B8E7;width:1000px;margin-left:auto;margin-right:auto;">';
	var htmlstr = '<div id="rf_'+monitorID+'" class="btn-ui-div" style="border:2px solid #95B8E7;width:1000px;margin-left:20px;">';
	////<!--患者信息-->
	var htmlstr = htmlstr + '<div>';
	var htmlstr = htmlstr + '	<div class="btn-ui-div">';
	var htmlstr = htmlstr + '		<span style="font-weight:bold;font-size:20px;">序列号:'+i+'</span>';
	var htmlstr = htmlstr + '	</div>';
	var htmlstr = htmlstr + '	<div class="btn-ui-div">';
	var htmlstr = htmlstr + '		<span style="font-weight:bold;font-size:13px;">1、患者信息</span>';
	var htmlstr = htmlstr + '	</div>';
	var htmlstr = htmlstr + '	<div class="btn-ui-div">';
	var htmlstr = htmlstr + '		<span class="btn-ui-span">登记号：<input name="patno" class="btn-ui-input" readonly></input></span>';
	var htmlstr = htmlstr + '		<span class="btn-ui-span">姓名：<input name="patname" class="btn-ui-input" readonly></input></span>';
	var htmlstr = htmlstr + '		<span class="btn-ui-span">性别：<input name="patsex" class="btn-ui-input btn-ui-width1" readonly></input></span>';
	var htmlstr = htmlstr + '		<span class="btn-ui-span">出生日期：<input name="patdob" class="btn-ui-input" readonly></input></span>';
	var htmlstr = htmlstr + '		<span class="btn-ui-span">年龄：<input name="patage" class="btn-ui-input btn-ui-width1" readonly></input></span>';
	var htmlstr = htmlstr + '		<span class="btn-ui-span">身高(cm)：<input name="height" class="btn-ui-input" readonly></input></span>';
	var htmlstr = htmlstr + '	</div>';
	var htmlstr = htmlstr + '	<div class="btn-ui-div">';
	var htmlstr = htmlstr + '		<span class="btn-ui-span">体重(kg)：<input name="weight" class="btn-ui-input" readonly></input></span>';
	var htmlstr = htmlstr + '		<span class="btn-ui-span">就诊日期：<input name="admdate" class="btn-ui-input btn-ui-width2" readonly></input></span>';
	var htmlstr = htmlstr + '		<span class="btn-ui-span">就诊科室：<input name="admloc" class="btn-ui-input btn-ui-width2" readonly></input></span>';
	var htmlstr = htmlstr + '		<span class="btn-ui-span">医师：<input name="doctor" class="btn-ui-input" readonly></input></span>';
	var htmlstr = htmlstr + '	</div>';
	var htmlstr = htmlstr + '	<div class="btn-ui-div">';
	var htmlstr = htmlstr + '		<span class="btn-ui-span">诊断：<input name="patdiag" class="btn-ui-input btn-ui-width3" readonly></input></span>';
	var htmlstr = htmlstr + '	</div>';
	var htmlstr = htmlstr + '	<div class="btn-ui-div">';
	var htmlstr = htmlstr + '		<span class="btn-ui-span">过敏史：<input name="allergy" class="btn-ui-input btn-ui-width3" readonly></input></span>';
	var htmlstr = htmlstr + '	</div>';
	var htmlstr = htmlstr + '</div>';
	////<!--处方用药-->
	var htmlstr = htmlstr + '<div>';
	var htmlstr = htmlstr + '	<div class="btn-ui-div">';
	var htmlstr = htmlstr + '		<span style="font-weight:bold;font-size:13px;">2、医嘱列表</span>';
	var htmlstr = htmlstr + '	</div>';
	var htmlstr = htmlstr + '	<div style="border-top:1px solid #95B8E7;border-bottom:1px solid #95B8E7;">';
	var htmlstr = htmlstr + '		<table id="dg'+monitorID+'"></table>';
	var htmlstr = htmlstr + '	</div>';
	var htmlstr = htmlstr + '</div>';
	////<!--建议-->
	var htmlstr = htmlstr + '<div class="btn-ui-div">';
	var htmlstr = htmlstr + '	<div>';
	var htmlstr = htmlstr + '		<div><span style="font-weight:bold;font-size:13px;">3、用药建议：</span></div>';
	var htmlstr = htmlstr + '		<div id="medA_'+monitorID+'" style="margin-left:40px;margin-top:10px;font-size:20px;color:red;">一级不适宜处方：按处方管理办法规定请您进一步确认或重新开具处方方能调配药品。</div>';
	var htmlstr = htmlstr + '   </div>';
	var htmlstr = htmlstr + '</div>';
	////<!--button-->
	var htmlstr = htmlstr + '<div class="btn-ui-div">';
	var htmlstr = htmlstr + '	<span style="margin-left:512px;margin-top:10px;" class="btn-ui">';
	var htmlstr = htmlstr + '		<a href="#" class="yanshi defualt-bk1" id="btnq_'+monitorID+'">维护模板</a>';
	var htmlstr = htmlstr + '		<a href="#" class="yanshi defualt-bk1" id="btnq_'+monitorID+'">个人模板</a>';
	var htmlstr = htmlstr + '		<a href="#" class="yanshi defualt-bk1" id="btns_'+monitorID+'">反馈</a>';
	var htmlstr = htmlstr + '		<a href="#" class="yanshi defualt-bk1" id="btnr_'+monitorID+'">接受</a>';
	var htmlstr = htmlstr + '	</span>';
	var htmlstr = htmlstr + '</div>';
	////<!--反馈-->
	var htmlstr = htmlstr + '<div class="btn-ui-div">';
	var htmlstr = htmlstr + '	<textarea id="textarea_'+monitorID+'" style="width:970px;height:85px;font-size:20px;margin-left:5px;border: 1px solid #95B8E7;">请输入反馈理由...</textarea>';
	var htmlstr = htmlstr + '</div>';

	$('#r_list').append(htmlstr);
	
	///设置datagrid
	InitPageDataGrid(monitorID);
	
	///加载信息
	LoadPagePatRefuseInfo(monitorID);
}

///加载页面病人就诊信息
function LoadPagePatRefuseInfo(monitorID)
{
 	//请求数据
	$.post("dhcpha.clinical.action.csp",{action:"getRefPatAdmInfo", "monitorID":monitorID},function(data){
		var data = eval('('+data+')');
		$('#rf_'+monitorID+' div div .btn-ui-span input').each(function(){
			$(this).val(data[this.name]);
		})
	});
	
	//提取医嘱信息
	$('#dg'+monitorID).datagrid({
		url:url+'?action=getMonitorDrgItm',
		queryParams:{
			monitorID:monitorID}
	})
	
	//提取用药建议
	$.post("dhcpha.clinical.action.csp",{action:"getRefPatAdvise", "monitorID":monitorID},function(data){
		$('#medA_'+monitorID+'').text(data);
	});
}

///初始化页面dagagrid
function InitPageDataGrid(monitorID)
{
	//定义columns
	var columns=[[
	    {field:'inciDesc',title:'药品名称',width:220},
	    {field:'form',title:'剂型',width:80},
	    {field:'reasondesc',title:'拒绝理由',width:100,formatter:SetCellColor},
	    {field:'instru',title:'给药途径',width:80},
	    {field:'dosage',title:'剂量',width:60},
	    {field:'uomdesc',title:'单位',width:40},
	    {field:'qty',title:'数量',width:40},
	    {field:'freq',title:'频次',width:40},
	    {field:'prescno',title:'处方号',width:120},
	    {field:'doctor',title:'医生',width:70},
	    {field:'ordtime',title:'医嘱时间',width:100}
	]];

	//定义datagrid
	$('#dg'+monitorID).datagrid({
		//title:'2、医嘱列表',    
		url:'',
		border:false,
		rownumbers:true,
		columns:columns,
	    singleSelect:true,
	    pageSize:8,
		pageList:[8,16],
		loadMsg: '正在加载信息...'//,
		//pagination:true
	});

	//InitdatagridRow(monitorID);
}

//初始化列表使用
function InitdatagridRow(monitorID)
{
	for(var k=0;k<5;k++)
	{
		$('#dg'+monitorID).datagrid('insertRow',{
			index: 0, // 行索引
			row: {
				orditm:'', phcdf:'', incidesc:'', genenic:''
			}
		});
	}
}

///接受
function Meth_Agree(monitorID)
{
	$.post(url,{action:"AgreeRefDrg", "monitorID":monitorID},function(data){
		var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		if(retVal!="0"){
			$.messager.alert("提示","更新失败！","info");
		}else{
			$('#rf_'+monitorID+'').remove();   ///删除操作成功的项目
		}
	});
}

///反馈
function Meth_Appeal(monitorID)
{
	var appReason = $('#textarea_'+monitorID+'').val();
	if (appReason=="请输入反馈理由..."){
		$.messager.alert("提示","请输入反馈理由后,重试！");
		return;
	}
	$.post(url,{action:"AppealRefDrg", "monitorID":monitorID, "appReason":appReason},function(data){
		var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		if(retVal!="0"){
			$.messager.alert("提示","更新失败！","info");
		}else{
			$.messager.alert("提示","反馈成功！");
			$('#rf_'+monitorID+'').remove();   ///删除操作成功的项目
		}
	});
}

// 建议引用窗口
function createSuggestWin(MonitorID)
{
	if($('#medAdvWin').is(":visible")){return;} //窗体处在打开状态,退出

	$('body').append('<div id="medAdvWin"></div>');
	$('#medAdvWin').append('<div id="medAdvdg"></div>');
	
	$('#medAdvWin').window({
		title:'个人模板',    
		collapsible:true,
		border:true,
		closed:"true",
		width:900,
		height:450,
		onClose:function(){
			$('#medAdvWin').remove();  //窗口关闭时移除win的DIV标签
		}
	});

	$('#medAdvWin').window('open');
	
	///定义columns
	var columns=[[
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:'Code',title:'代码',width:100},
		{field:'Desc',title:'描述',width:800},
	]];
	
	///定义datagrid
	$('#medAdvdg').datagrid({  
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,        // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
		onDblClickRow:function(rowIndex, rowData){
			var tmpDesc=rowData.Desc;
			if($('#textarea_'+MonitorID).val()=="请输入反馈理由..."){
				$('#textarea_'+MonitorID).val(tmpDesc);
			}else{
				$('#textarea_'+MonitorID).val($('#textarea_'+MonitorID).val()+","+tmpDesc);
			}
			$('#medAdvWin').window('close');
			$('#medAdvWin').remove();  //窗口关闭时移除win的DIV标签
		}
	});

	///自动加载建议字典
	$('#medAdvdg').datagrid({
		url:url+'?action=QueryMedAdvTemp',
		queryParams:{
			params:LgCtLocID+"^"+LgUserID
		}
	});
}

/// 用药建议模板维护
function medAdvTemp()
{
	if($('#medAdvTempWin').is(":visible")){return;} //窗体处在打开状态,退出
	
	$('body').append('<div id="medAdvTempWin"></div>');
	$('#medAdvTempWin').window({
		title:'用药建议模板维护',    
		collapsible:true,
		border:true,
		closed:"true",
		width:900,
		height:450,
		onClose:function(){
			$('#medAdvTempWin').remove();  //窗口关闭时移除win的DIV标签
		}
	});

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.medadvtemp.csp"></iframe>';
	$('#medAdvTempWin').html(iframe);
	$('#medAdvTempWin').window('open');
}

//formatter="SetCellColor" 
function SetCellColor(value, rowData, rowIndex)
{
	return '<span style="color:red">'+value+'</span>';
}