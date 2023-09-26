// 描述:医生反馈
// 编写日期:2015-05-27
// 作者:bianshuai

//住院根据病人ADM
var EpisodeID=getParam("EpisodeID");
var medAdvID=getParam("medAdvID");
//弹出窗体大小
window.resizeTo(1065,630); 

var url="dhcpha.clinical.action.csp";
$(function(){
	if (medAdvID != ""){
		addPatMedAdv(1,medAdvID);
	}else{
		$.post(url,{action:"jsonPatMedAdvList", "EpisodeID":EpisodeID},function(jsonString){
			var medAdvListObj = jQuery.parseJSON(jsonString);
			if(medAdvListObj.medAdvIDList==""){return;}
			var medAdvArr=medAdvListObj.medAdvIDList.split("||");
				
			for(var i=0;i<medAdvArr.length;i++){
				addPatMedAdv(i+1,medAdvArr[i]);
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
	
	/*$('button:contains("维护模板")').live("click",function(){
		medAdvTemp();
	});
	
	$('button:contains("个人模板")').live("click",function(){
		var medAdvID = this.id.split("_")[1];
		createSuggestWin(medAdvID);
		//$.messager.alert("提示","引用模板功能,暂不可使用！");
	});*/
	
	$('button:contains("反馈")').live("click",function(){
		var medAdvID = this.id.split("_")[1];
		Meth_Appeal(medAdvID);
	});
	
	$('button:contains("接受")').live("click",function(){
		var medAdvID = this.id.split("_")[1];
		Meth_Agree(medAdvID);
	});
})

/// 反馈panel列表
function addPatMedAdv(i,medAdvID)
{
	addPatMedAdvPanel(i,medAdvID)
	
	///设置datagrid
	InitPageDataGrid(medAdvID);
	
	///加载信息
	LoadPagePatRefuseInfo(medAdvID);

}

///加载页面病人就诊信息
function LoadPagePatRefuseInfo(medAdvID)
{
 	//请求数据
	$.post("dhcpha.clinical.action.csp",{action:"jsonMedAdvPatAdmInfo", "medAdvID":medAdvID},function(data){
		var jsonObject = eval('('+data+')');
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			if (jsonObject.patsex == "男"){
				$("#PatPhoto").attr("src","../scripts/dhcpha/jQuery/themes/gray/images/boy.png");
			}else{
				$("#PatPhoto").attr("src","../scripts/dhcpha/jQuery/themes/gray/images/girl.png");
			}
		});
	})

	//提取医嘱信息
	$('#dg'+medAdvID).datagrid({
		url:url+'?action=jsonMedAdvDrgItm',
		queryParams:{
			medAdvID:medAdvID}
	})

	//提取用药建议
	$.post("dhcpha.clinical.action.csp",{action:"jsonPHMedAdvInDet", "medAdvID":medAdvID},function(jsonString){
		var medAdvListObj = jQuery.parseJSON(jsonString);
		var htmlstr = "";
		for(var i=0;i<medAdvListObj.length;i++){
			var htmlstr = htmlstr + '	<div class="btn-ui-div">';
				htmlstr = htmlstr + '		<span style="font-weight:bold;">'+medAdvListObj[i].medAdvuser+':</span><br><span style="border-bottom:1px solid #95B8E7;width:900px;margin-left:35px;">'+medAdvListObj[i].medAdvCon+'</span>';
				htmlstr = htmlstr + '	</div>';
		}
		$('#medA_'+medAdvID+'').html(htmlstr);
	});
}

function InitPageDataGrid(medAdvID)
{
	//定义columns
	var columns=[[
		{field:'priorty',title:'优先级',width:80},
	    {field:'inciDesc',title:'药品名称',width:230},
	    {field:'form',title:'剂型',width:128},
	    {field:'instru',title:'给药途径',width:80},
	    {field:'dosage',title:'剂量',width:72},
	    //{field:'uomdesc',title:'单位',width:40},
	    //{field:'qty',title:'数量',width:40},
	    {field:'freq',title:'频次',width:40},
	    {field:'duration',title:'疗程',width:40},
	    {field:'presc',title:'处方号',width:120},
	    {field:'doctor',title:'医生',width:60},
	    {field:'ordtime',title:'医嘱时间',width:90}
	]];

	//定义datagrid
	$('#dg'+medAdvID).datagrid({
		//title:'2、医嘱列表',    
		url:'',
		rownumbers:true,
		columns:columns,
	    singleSelect:true,
		loadMsg: '正在加载信息...'//,
	});
}

///接受
function Meth_Agree(medAdvID)
{
	var curStatus="30";  //医生同意为30
	$.post(url,{action:"agrPatMedAdv",medAdvID:medAdvID,curStatus:curStatus},function(data,status){
		var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		if(retVal=="0"){
			$.messager.alert("提示","操作成功！");
			$('#rf_'+medAdvID+'').remove();   ///删除操作成功的项目
			if($.trim($('#r_list').html())==""){
				  window.close(); 
				}
		}else{
			$.messager.alert("提示","操作失败！");
		}
	});
}

///反馈
function Meth_Appeal(medAdvID)
{
	var medAdvDetList = $('#textarea_'+medAdvID+'').val();
	if (medAdvDetList=="请输入反馈理由..."){
		$.messager.alert("提示","请输入反馈理由后,重试！");
		return;
	}
	
	var curStatus="20";  //申诉状态
	var medAdvMasList= LgUserID+"^"+curStatus+"^"+medAdvDetList.replace(/(^\s*)|(\s*$)/g,""); //去掉标示字符
	$.post(url,{action:"SaveMedAdvDetail", "AdvID":medAdvID, "dataList":medAdvMasList},function(data){
		var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		if(retVal!="0"){
			$.messager.alert("提示","更新失败！","info");
		}else{
			$.messager.alert("提示","反馈成功！");
			$('#rf_'+medAdvID+'').remove();   ///删除操作成功的项目
			if($.trim($('#r_list').html())==""){
				  window.close(); 
				}
		}
	});
}

// 建议引用窗口
function createSuggestWin(medAdvID)
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
			if($('#textarea_'+medAdvID).val()=="请输入反馈理由..."){
				$('#textarea_'+medAdvID).val(tmpDesc);
			}else{
				$('#textarea_'+medAdvID).val($('#textarea_'+medAdvID).val()+","+tmpDesc);
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