/// Creator: yangyongtao   
/// CreateDate: 2016-5-9
/// Descript:   分享界面

var url="dhcadv.repaction.csp";
var rshStatusArr = [{"val":"","text":'全部'}, {"val":"Y","text":'完成'}, {"val":"N","text":'未完成'}];

var ronID = ""; shareId="";rshOnlineDr="";
$(function(){ 
	 TypeCode= getParam("TypeCode");
	 reportID= getParam("ID");     
	$("#stdate").datebox("setValue", formatDate(-2));  //Init起始日期
	$("#enddate").datebox("setValue", formatDate(0));  //Init结束日期
	
		/**
	 * 完成状态   
	 */
	var rshStatusCombobox = new ListCombobox("rshStatus",'',rshStatusArr,{panelHeight:"auto"});
	    rshStatusCombobox.init();
	
	
    $('#Find').bind("click",Query);  //点击查询
	   InitShareList(); //初始化分享列表
	
	$("a:contains('保存')").bind("click",saveConsultDetail);
	$("a:contains('清空')").bind("click",clearConsultDetail);
	
	InitConBakDetList(); //回复列表
	//1、清空datagrid 
	$('#conBakDetList').datagrid('loadData', {total:0,rows:[]}); 
	InitShareList(); //分享列表
		
	$('#ronContent').bind("focus",function(){
		if(this.value=="请输入评论信息..."){
			$('#ronContent').val("");
		}
	});
	
	$('#ronContent').bind("blur",function(){
		if(this.value==""){
			$('#ronContent').val("请输入评论信息...");
		}
	});
	
 		var params=TypeCode+"^"+reportID;
 		//alert(params)
	    $('#maindg').datagrid({ 
		url:url + "?action=getRepShareByID",	
		queryParams:{
			params:params
		}
		});
})

//查询分享信息
 function Query()
{

	//2、查询
	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var statShare=$('#rshStatus').combobox('getValue');  //完成状态
	var params=StDate+"^"+EndDate+"^"+statShare;
	//alert(params)
	$('#maindg').datagrid({
		url:url+'?action=getRepShareList',	
		queryParams:{
			params:params}
	});

}


//初始化评论列表
function InitConBakDetList()
{
	/**
	 * 定义columns  
	 */
	var columns=[[
		{field:'ronID',title:'ronID',width:50,hidden:true}, //
		{field:'ronUserName',title:'评论人',width:80,align:'center'},
		{field:'ronDate',title:'评论时间',width:150,align:'center'},
		{field:'ronDesc',title:'评论内容',width:240,formatter:setMonLevelShow},
		{field:'ronOkNum',title:'点赞数',width:80,align:'center'},
		{field:'ronAcceptFlag',title:'采纳',width:80,align:'center',hidden:true,formatter:SetCellUrl},
		{field:'ronDetial',title:'采纳操作',width:100,align:'center',formatter:SetCellOpUrl},
		{field:'ronOKflag',title:'点赞标识',width:80,align:'center',hidden:true},
		{field:'ronDetialOKNum',title:'点赞操作',width:60,align:'center',formatter:SetCellOpNumUrl},
		{field:'ronOkNumDetial',title:'点赞详情',width:60,align:'center',formatter:SetCellOkNumList}
	]];

	/**
	 * 定义datagrid
	 */
	/* var option = {
		title:'在线评论列表',
		nowrap:false,
		singleSelect:true
		};
	var conBakDetListComponent = new ListComponent('conBakDetList', columns, '', option);
	conBakDetListComponent.Init(); */
		//定义datagrid
	//$('#conBakDetList').datagrid('loadData', {total:0,rows:[]}); 
	$('#conBakDetList').datagrid({
		title:'在线评论列表',
		url:'',
		fit:true,
		columns:columns,
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		showFooter:true,
		pagination:true,
		onLoadSuccess: function (data) {
		},
		onClickRow:function(rowIndex, rowData){//单击显示评论信息内容
	    rshOnlineDr=rowData.ronID;    ///评论ID
 		//var params=shareId;
        //alert(ronID)
	    }
	});	
	initScroll("#conBakDetList");//初始化显示横向滚动条
}

//分享明细
function InitShareList()
{	
	//定义columns  reportDr
var columns=[[
        {field:'ID',title:'ID',width:50,hidden:true},//
        {field:'reportDr',title:'reportDr',width:50,hidden:true},
        {field:'Edit',title:'详情',width:50,align:'center',formatter:setCellEditSymbol,hidden:false},  //新版不良事件暂时用不了  yangyongtao  2017-11-23
		{field:'typeEvent',title:'报告类型',width:60,align:'center'},
		{field:'TypeCode',title:'报告Code',width:50,align:'center',hidden:true},
		{field:'rshCreateDate',title:'分享日期',width:80,align:'center'},
		{field:'rshCreateTime',title:'分享时间',width:80,align:'center'}
	]];
	//定义datagrid
	$('#maindg').datagrid({
		title:'分享列表',
		url:'',
		fit:true,
		columns:columns,
	    singleSelect:true,
		loadMsg: '正在加载信息...',
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
	    }
	});
	initScroll("#maindg");//初始化显示横向滚动条
	
}


 /**
  * 保存咨询数据
  */
function saveConsultDetail(){
	
	var ronContent = $('#ronContent').val();  ///评论描述
	if (ronContent == "请输入评论信息..."){
		showMsgAlert("评论信息不能为空！");
		return;
	}	
	
	//var lkConsultID = "";  rshOnlineDr
	var ronDataList = LgUserID +"^"+ ronContent +"^"+ rshOnlineDr+"^"+shareId;
	 
	//保存数据
	$.post(url+'?action=saveReviewDetail',{"ronID":ronID,"ronDataList":ronDataList},function(jsonString){
		
		var jsonConsObj = jQuery.parseJSON(jsonString);
		//alert(shareId)
		if ((jsonConsObj.ErrorCode == "0")&&(shareId!="")){
			$('#conBakDetList').datagrid('reload'); //重新加载
			clearConsultDetail();
			$.messager.alert("提示：","保存成功！");
		}else if(shareId==""){
			clearConsultDetail();
			$.messager.alert("提示：","请选择分享报告信息！");
			
		}else{
		   $.messager.alert("提示：","保存失败！");
			}
	});
}

/// 清空重置
function clearConsultDetail(){
	var ErrDesc=""
	$('#ronContent').val("请输入评论信息...");  ///评论描述
}

/// 消息提示窗口
function showMsgAlert(ErrMsg ){
	$.messager.alert("提示：", ErrMsg );
}


function setMonLevelShow(value,rowData,rowIndex)
{
	var html="";
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
		html = "<span style='margin:0px 5px;font-weight:bold;color:red;'>采纳</span>";		
	}else{
		html = "<span style='margin:0px 5px;font-weight:bold;color:green;'>No</span>";
		}
    return html;
}
//点赞操作
function SetCellOpNumUrl(value, rowData, rowIndex)
{    
	var htmlstr = "";
	//htmlstr="<a href='#' onclick='adoptOK("+"\""+rowData.ronID+"\""+")' ><img src='../scripts/dhcadvEvt/images/heart.png' border=0/></a>";
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
        //$.messager.confirm("提示", "您确定要采纳这条评论吗？", function (res) {//提示是否删除	 
	      //if (res) {
	 	   html = "<a href='#' onclick='adoptConsult("+"\""+rowData.ronID+"\""+","+"\"Y\""+")'><img src='../scripts/dhcadvEvt/images/star_grey.png' border=0/></a>";
	     // }    
	   //});    
	}else{    
	//$.messager.confirm("提示", "您确定要取消采纳这条评论吗？", function (res) {//提示是否删除	 
         //if (res) {
		   html = "<a href='#' onclick='adoptConsult("+"\""+rowData.ronID+"\""+","+"\"N\""+")'><img src='../scripts/dhcadvEvt/images/star.png' border=0/></a>";
		   // }
	   //});
		}
    return html;
}

 /// 设置点赞
function adoptOK(ronID,ronOKflag){
	
	var alertOKmessage="";
	if (ronOKflag=="Y"){
		alertOKmessage="点赞" ; 
	}
	if (ronOKflag=="N"){
		alertOKmessage="取消点赞" ; 
	}
	 $.messager.confirm("提示", "您确定要"+alertOKmessage+"这条评论吗？", function (res) {//提示是否采纳	
		if (res) { 
		  	//保存数据 
			$.post(url+'?action=InsRepOnlineAcc',{"ronID":ronID,"LgUserID":LgUserID},function(jsonString){
				var jsonConsObj = jQuery.parseJSON(jsonString);
			    if (jsonConsObj == "0"){						
			     $.messager.alert("提示",alertOKmessage+"成功！");	
					$('#conBakDetList').datagrid('reload'); //重新加载
			   }else{
					$.messager.alert("提示:",alertOKmessage+"失败");
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
		alertmessage="采纳" ; 
	}
	if (ronAcceptFlag=="N"){
		alertmessage="取消采纳" ; 
	}
	$.messager.confirm("提示", "您确定要"+alertmessage+"操作这条评论吗？", function (res) {//提示是否采纳
		if (res){
			$.post(url+'?action=saveAdoptOnline',{"params":params},function(jsonString){	    		      
				var jsonConsObj = jQuery.parseJSON(jsonString);
				if (jsonConsObj == "0"){
					$.messager.alert("提示",alertmessage+"成功！");	
					$('#conBakDetList').datagrid('reload'); //重新加载
				}else if(jsonConsObj == "1"){
					$.messager.alert("提示:","非本报告分享人，无权限"+alertmessage+"！"); //hxy 2018-01-11
				}else{
					$.messager.alert("提示:",alertmessage+"失败！");
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
		var satatusButton=1  //按钮状态
		return "<a href='#' onclick=\"showEditWin('"+reportDr+"','"+TypeCode+"','"+satatusButton+"')\"><img src='../scripts/dhcadvEvt/images/viewlist.png' border=0/></a>";
}

//编辑窗体
function showEditWin(reportDr,TypeCode,satatusButton)
{     
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:'报告详情',
		collapsible:true,
		border:false,
		closed:"true",
		width:1080,
		height:600
	});
	if(TypeCode=="material"){
		
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.matareport.csp?matadrID='+reportDr+'&editFlag='+1+'&satatusButton='+satatusButton+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
	}
	if(TypeCode=="drugerr"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.medsafetyreport.csp?medsrID='+reportDr+'&editFlag='+1+'&satatusButton='+satatusButton+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
		
	}
	if(TypeCode=="blood"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.bloodreport.csp?bldrptID='+reportDr+'&editFlag='+1+'&satatusButton='+satatusButton+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
		
	}	
	if(TypeCode=="med"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.medicalreport.csp?adrRepID='+reportDr+'&editFlag='+1+'&satatusButton='+satatusButton+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
		
	}	
	if(TypeCode=="drug"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.advreport.csp?advdrID='+reportDr+'&editFlag='+1+'&satatusButton='+satatusButton+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
		
	}		
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
		title:'点赞详情',
		collapsible:true,
		border:false,
		closed:"true",
		width:500,
		height:300
	});
	var columns=[[ //,hidden:true
		{field:'ID',title:'ID',align:'center',width:60},  //,hidden:true
		{field:'roaOnlineDr',title:'评论ID',align:'center',width:60},//,hidden:true
		{field:'roaDateTime',title:'点赞日期',align:'center',width:200},
		{field:'roaUserName',title:'点赞人',align:'center',width:80}
	]]; 
	var params=ronID;
	//定义datagrid
	$('#DetailList').datagrid({
		url:url+'?action=GetOkNumDetail&params='+params,
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		pageSize:20,  // 每页显示的记录条数
		pageList:[20,40,60,80],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true 
	});
	$('#OkNumDetail').window('open');
	
}
