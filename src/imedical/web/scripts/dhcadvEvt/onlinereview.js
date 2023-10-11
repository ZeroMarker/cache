/// Creator: yangyongtao   
/// CreateDate: 2016-5-9
/// Descript:   分享界面

var url="dhcadv.repaction.csp";
var rshStatusArr = [{"val":"","text":$g('全部')}, {"val":"Y","text":$g('完成')}, {"val":"N","text":$g('未完成')}];
var TypeCode="",reportID="";
var ronID = "", shareId="",rshOnlineDr="";
$(function(){ 
	InitPageComponent(); 	  /// 初始化界面控件内容
	InitPageButton();         /// 界面按钮控制
	InitShareList();          /// 初始化分享列表
	InitConBakDetList();      /// 初始化回复列表
	ResizeHeight();          /// 初始化页面样式
})
// 初始化界面控件内容
function InitPageComponent(){
	$.messager.defaults = { ok: $g("确定"),cancel: $g("取消")};
	TypeCode= getParam("TypeCode");
	reportID= getParam("ID");     
	$("#stdate").datebox("setValue", formatDate(-2));  //Init起始日期
	$("#enddate").datebox("setValue", formatDate(0));  //Init结束日期
	/**
	 * 完成状态   
	 */
	var rshStatusCombobox = new ListCombobox("rshStatus",'',rshStatusArr,{panelHeight:"auto"});
	    rshStatusCombobox.init();
	/// 评论 信息控制
	$('#ronContent').bind("focus",function(){
		if(this.value==$g("请输入评论信息...")){
			$('#ronContent').val("");
		}
	});
	$('#ronContent').bind("blur",function(){
		if(this.value==""){
			$('#ronContent').val($g("请输入评论信息..."));
		}
	});
}
// 界面按钮控制
function InitPageButton(){
	// 分享查询
    $('#Find').bind("click",Query);  
    // 评论 保存
	$("#SaveMessage").bind("click",saveConsultDetail);
	// 评论 清空
	$("#ClearMessage").bind("click",clearConsultDetail);
}
//自适应 hxy 2017-08-28
function ResizeHeight(){
	// 在线评论列表 高度
	$("#BakDetList").height($(window).height()-250)
	$("#conBakDetList").datagrid('resize', { 
		height : $(window).height()-250
    }); 
    // 分享列表 高度 
    $("#maindgList").height($(window).height()-270)
	$("#maindg").datagrid('resize', { 
		height : $(window).height()-270
    }); 
}

//分享明细
function InitShareList()
{	
	//定义columns  reportDr
	var columns=[[
        {field:'ID',title:'ID',width:50,hidden:true},//
        {field:'reportDr',title:'reportDr',width:50,hidden:true},
        {field:'Edit',title:$g('详情'),width:50,align:'center',formatter:setCellEditSymbol,hidden:false},  //新版不良事件暂时用不了  yangyongtao  2017-11-23
		{field:'typeEvent',title:$g('报告类型'),width:60,align:'center'},
		{field:'TypeCode',title:$g('报告Code'),width:50,align:'center',hidden:true},
		{field:'rshCreateDate',title:$g('分享日期'),width:80,align:'center'},
		{field:'rshCreateTime',title:$g('分享时间'),width:80,align:'center'}
	]];
	var params=TypeCode+"^"+reportID;
	//定义datagrid
	$('#maindg').datagrid({
		title:'',
		url:url + "?action=getRepShareByID&params="+params,
		fit:true,
		border:false,
		columns:columns,
	    singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		showFooter:true,
		pagination:true,
		onLoadSuccess: function (data) {
		},
		onClickRow:function(rowIndex, rowData){//单击显示评论信息内容
		    shareId=rowData.ID;    ///
		    rshOnlineDr="";//huaxiaoying 2018-02-05
	 		var params=shareId+"^"+LgUserID;
			$('#conBakDetList').datagrid({
				url:url + "?action=QueryRepOnline",	
				queryParams:{
					params:params
				}
			});
			// 评论内容清空
			clearConsultDetail();
	    }
	});
	initScroll("#maindg");//初始化显示横向滚动条
}

//初始化评论列表
function InitConBakDetList()
{
	/**
	 * 定义columns  
	 */
	var columns=[[
		{field:'ronID',title:'ronID',width:50,hidden:true}, //
		{field:'ronUserName',title:$g('评论人'),width:80,align:'center'},
		{field:'ronDate',title:$g('评论时间'),width:150,align:'center'},
		{field:'ronDesc',title:$g('评论内容'),width:300,formatter:setMonLevelShow},
		{field:'ronOkNum',title:$g('点赞数'),width:80,align:'center'},
		{field:'ronAcceptFlag',title:$g('采纳'),width:80,align:'center',hidden:true,formatter:SetCellUrl},
		{field:'ronDetial',title:$g('采纳操作'),width:100,align:'center',formatter:SetCellOpUrl},
		{field:'ronOKflag',title:$g('点赞标识'),width:80,align:'center',hidden:true},
		{field:'ronDetialOKNum',title:$g('点赞操作'),width:60,align:'center',formatter:SetCellOpNumUrl},
		{field:'ronOkNumDetial',title:$g('点赞详情'),width:60,align:'center',formatter:SetCellOkNumList}
	]];

	/**
	 * 定义datagrid
	 */
	$('#conBakDetList').datagrid({
		url:'',
		fit:true,
		columns:columns,
	    singleSelect:false,
		loadMsg: $g('正在加载信息...'),
		showFooter:true,
		pagination:true,
		fitColumns:true,
		singleSelect:true,
		border:false,
		nowrap:false,
		onLoadSuccess: function (data) {
		},
		onClickRow:function(rowIndex, rowData){//单击显示评论信息内容
	    	rshOnlineDr=rowData.ronID;    ///评论ID
	    }
	});	
	initScroll("#conBakDetList");//初始化显示横向滚动条
	$("#conBakDetList").datagrid('loadData',{total:0,rows:[]});
}
// 查询分享信息
function Query()
{
	//2、查询
	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var statShare=$('#rshStatus').combobox('getValue');  //完成状态
	var params=StDate+"^"+EndDate+"^"+statShare;

	$('#maindg').datagrid({
		url:url+'?action=getRepShareList',	
		queryParams:{
			params:params}
	});
	// 在线评论列表与评论内容清空
	$('#conBakDetList').datagrid('loadData', {total:0,rows:[]}); 
	clearConsultDetail();
}

 /**
  * 保存咨询数据
  */
function saveConsultDetail(){
	
	var ronContent = $('#ronContent').val();  ///评论描述
	if (ronContent == $g("请输入评论信息...")){
		showMsgAlert($g("评论信息不能为空！"));
		return;
	}	
	if(ronContent.length>2000){
		$.messager.alert($g("提示："),$g("评论信息过多，保存失败"));
		return;
	}
	ronContent =$_TrsSymbolToTxt(ronContent);
	ronContent = ronContent.replace(/\r\n/g,"<br>"); 
	ronContent = ronContent.replace(/\t\n/g,"<br>");
	ronContent = ronContent.replace(/\n/g,"<br>");
	var ronDataList = LgUserID +"^"+ ronContent +"^"+ rshOnlineDr+"^"+shareId;
	 
	//保存数据
	$.post(url+'?action=saveReviewDetail',{"ronID":ronID,"ronDataList":ronDataList},function(jsonString){
		
		var jsonConsObj = jQuery.parseJSON(jsonString);
		if ((jsonConsObj.ErrorCode == "0")&&(shareId!="")){
			$('#conBakDetList').datagrid('reload'); //重新加载
			clearConsultDetail();
			$.messager.alert($g("提示："),$g("保存成功！"));
		}else if(shareId==""){
			clearConsultDetail();
			$.messager.alert($g("提示："),$g("请选择分享报告信息！"));
		}else{
		   $.messager.alert($g("提示："),$g("保存失败！"));
		}
	});
}

/// 清空重置
function clearConsultDetail(){
	var ErrDesc=""
	$('#ronContent').val($g("请输入评论信息..."));  ///评论描述
}

/// 消息提示窗口
function showMsgAlert(ErrMsg ){
	$.messager.alert($g("提示："), ErrMsg );
}
function setMonLevelShow(value,rowData,rowIndex)
{
	var html="";
	value =$_TrsTxtToSymbol(value);
	if(value != ""){
		html='<p style="line-height:1.2;text-indet:2em;letter-spacimg:3.2;">'+value+'</p>';
	}
	return html;
}

//操作(采纳状态) SetNumUrl
function SetCellUrl(value, rowData, rowIndex)
{
	var html = "";
	if (value == "Y"){
		html = "<span style='margin:0px 5px;font-weight:bold;color:red;'>"+$g("采纳")+"</span>";		
	}else{
		html = "<span style='margin:0px 5px;font-weight:bold;color:green;'>No</span>";
		}
    return html;
}
//点赞操作
function SetCellOpNumUrl(value, rowData, rowIndex)
{    
	var htmlstr = "";
	if (rowData.ronOKflag != "Y"){
		htmlstr = "<a href='#' onclick='adoptOK("+"\""+rowData.ronID+"\""+","+"\"Y\""+")'><img src='../scripts/dhcadvEvt/images/heart_add.png' border=0/></a>";
	}else{    
		htmlstr = "<a href='#' onclick='adoptOK("+"\""+rowData.ronID+"\""+","+"\"N\""+")'><img src='../scripts/dhcadvEvt/images/heart_delete.png' border=0/></a>";
	}
    return htmlstr;
}
//操作(采纳状态)  SetCellOpNumUrl
function SetCellOpUrl(value, rowData, rowIndex)
{    
	
	var html = "";
	if (rowData.ronAcceptFlag != "Y"){
		html = "<a href='#' onclick='adoptConsult("+"\""+rowData.ronID+"\""+","+"\"Y\""+")'><img src='../scripts/dhcadvEvt/images/star_grey.png' border=0/></a>";
	}else{    
		html = "<a href='#' onclick='adoptConsult("+"\""+rowData.ronID+"\""+","+"\"N\""+")'><img src='../scripts/dhcadvEvt/images/star.png' border=0/></a>";
	}
    return html;
}

 /// 设置点赞
function adoptOK(ronID,ronOKflag){
	
	var alertOKmessage="";
	if (ronOKflag=="Y"){
		alertOKmessage=$g("点赞"); 
	}
	if (ronOKflag=="N"){
		alertOKmessage=$g("取消点赞") ; 
	}
	 $.messager.confirm($g("提示"), $g("您确定要")+alertOKmessage+$g("这条评论吗？"), function (res) {//提示是否采纳	
		if (res) { 
		  	//保存数据 
			$.post(url+'?action=InsRepOnlineAcc',{"ronID":ronID,"LgUserID":LgUserID},function(jsonString){
				var jsonConsObj = jQuery.parseJSON(jsonString);
			    if (jsonConsObj == "0"){						
			    	$.messager.alert($g("提示"),alertOKmessage+$g("成功！"));	
					$('#conBakDetList').datagrid('reload'); //重新加载
			   }else{
					$.messager.alert($g("提示:"),alertOKmessage+$g("失败"));
			   }				
			})
		}
	})										
}       

/// 设置采纳标准意见
function adoptConsult(ronID, ronAcceptFlag){
	//保存数据
	params=ronID+"^"+ronAcceptFlag+"^"+LgUserID+"^"+shareId;
	var alertmessage="";
	if (ronAcceptFlag=="Y"){
		alertmessage=$g("采纳") ; 
	}
	if (ronAcceptFlag=="N"){
		alertmessage=$g("取消采纳") ; 
	}
	$.messager.confirm($g("提示"), $g("您确定要")+alertmessage+$g("操作这条评论吗？"), function (res) {//提示是否采纳
		if (res){
			$.post(url+'?action=saveAdoptOnline',{"params":params},function(jsonString){	    		      
				var jsonConsObj = jQuery.parseJSON(jsonString);
				if (jsonConsObj == "0"){
			    	$.messager.alert($g("提示"),alertmessage+$g("成功！"));	
					$('#conBakDetList').datagrid('reload'); //重新加载
				}else if(jsonConsObj == "1"){
					$.messager.alert($g("提示"),$g("非本报告分享人，无权限")+alertmessage+"！"); //hxy 2018-01-11
				}else{
			    	$.messager.alert($g("提示"),alertmessage+$g("失败！"));	
					//$('#conBakDetList').datagrid('reload'); //重新加载
				} 
			})
		}
	});
}

///设置编辑连接
function setCellEditSymbol(value, rowData, rowIndex)
{
		var reportDr=rowData.reportDr;         //报表ID
		var TypeCode=rowData.TypeCode; //报告类型代码
		var typeEvent=rowData.typeEvent; //报告类型代码
		var satatusButton=1  //按钮状态
		var recordID=rowData.recordID;         // 表单记录id
		var RepStaus=rowData.RepStaus;         // 报告状态
		var rshTypeDr=rowData.rshTypeDr;         // 报告类型id

		return "<a href='#' onclick=\"showEditWin('"+reportDr+"','"+TypeCode+"','"+satatusButton+"','"+recordID+"','"+RepStaus+"','"+rshTypeDr+"','"+typeEvent+"')\"><img src='../scripts/dhcadvEvt/images/viewlist.png' border=0/></a>";
}

//编辑窗体
function showEditWin(reportDr,TypeCode,satatusButton,recordID,RepStaus,rshTypeDr,typeEvent)
{     
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:$g('报告详情'),
		border:false,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		collapsed:false, 
		resizable:false,
		closed:"true",
		width:screen.availWidth-170,    ///2017-11-23  cy  修改弹出窗体大小 1250  项目1550
		height:screen.availHeight-190
	});
	var iframe="";
	if(TypeCode=="material"){
		iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.matareport.csp?matadrID='+reportDr+'&editFlag='+1+'&satatusButton='+satatusButton+'"></iframe>';
	}else if(TypeCode=="drugerr"){
		iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.medsafetyreport.csp?medsrID='+reportDr+'&editFlag='+1+'&satatusButton='+satatusButton+'"></iframe>';		
	}else if(TypeCode=="blood"){
		iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.bloodreport.csp?bldrptID='+reportDr+'&editFlag='+1+'&satatusButton='+satatusButton+'"></iframe>';
	}else if(TypeCode=="med"){
		iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.medicalreport.csp?adrRepID='+reportDr+'&editFlag='+1+'&satatusButton='+satatusButton+'"></iframe>';
	}else if(TypeCode=="drug"){
		iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.advreport.csp?advdrID='+reportDr+'&editFlag='+1+'&satatusButton='+satatusButton+'"></iframe>';
	}else{
		iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layoutform.csp?recordId='+recordID+'&RepStaus='+RepStaus+'&RepTypeDr='+rshTypeDr+'&code='+TypeCode+'&desc='+typeEvent+'&editFlag=-1'+'&RepID='+reportDr+'"></iframe>';
	}
	$('#win').html(iframe);
	$('#win').window('open');
}

///设置点赞详情连接  2016-05-31
function SetCellOkNumList(value, rowData, rowIndex)
{  
	return "<a href='#' onclick=\"showOkNumListWin('"+rowData.ronID+"')\"><img src='../scripts/dhcadvEvt/images/viewlist.png' border=0/></a>";
}
//编辑窗体
function showOkNumListWin(ronID)
{
	$('#OkNumDetail').window({
		title:$g('点赞详情'),
		border:false,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		collapsed:false, 
		resizable:false,
		modal:true,
		width:500,
		height:300
	});
	var columns=[[ 
		{field:'ID',title:'ID',align:'center',width:60},  //,hidden:true
		{field:'roaOnlineDr',title:$g('评论ID'),align:'center',width:60},//,hidden:true
		{field:'roaDateTime',title:$g('点赞日期'),align:'center',width:200},
		{field:'roaUserName',title:$g('点赞人'),align:'center',width:80}
	]]; 
	var params=ronID;
	//定义datagrid
	$('#DetailList').datagrid({
		url:url+'?action=GetOkNumDetail&params='+params,
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		border:false,
		pageSize:20,  // 每页显示的记录条数
		pageList:[20,40,60,80],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: $g('正在加载信息...'),
		pagination:true 
	});
	$('#OkNumDetail').window('open');
}
