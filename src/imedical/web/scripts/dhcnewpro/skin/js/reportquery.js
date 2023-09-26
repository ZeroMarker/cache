
/// Creator: congyue
/// CreateDate: 2017-07-28
/// Descript: 不良事件升级 查询界面
var url = "dhcadv.repaction.csp";
var statShare = [{ "val": "未分享", "text": "未分享" },{ "val": "分享", "text": "分享" }];
var statArray = [{ "val": "Y", "text": "已提交" },{ "val": "N", "text": "未提交" }];
var statReceive = [{ "val": "未接收", "text": "未接收" },{ "val": "1", "text": "接收" },{ "val": "2", "text": "驳回" }];
var statOverTime = [{ "val": "Y", "text": "超时" },{ "val": "N", "text": "未超时" }];
var formNameID="";
var StrParam="";
var StDate="";  //formatDate(-7);  //一周前的日期   2018-01-26 修改，默认开始日期为上线使用日期，即2018-01-01
var EndDate=formatDate(0); //系统的当前日期
var querytitle="" ,cancelflag="";
$(function(){ 
	//var DateFormat="3" ;
	if(DateFormat=="4"){ //日期格式 4:"DMY" DD/MM/YYYY
		StDate="01"+"/"+"01"+"/"+2018;  //当年开始日期
	}else if(DateFormat=="3"){ //日期格式 3:"YMD" YYYY-MM-DD
		StDate=2018+"-"+"01"+"-"+"01";  //当年开始日期
	}else if(DateFormat=="1"){ //日期格式 1:"MDY" MM/DD/YYYY
		StDate="01"+"/"+"01"+"/"+2018;  //当年开始日期
	}
	/*document.onkeydown = function(e){ 
    var ev = document.all ? window.event : e;
    	if(ev.keyCode==13) {
			commonQuery({'datagrid':'#datagrid','formid':'#toolbar'})
     	}
	}*/
	
/* 	//科室
	$('#dept').combobox({
		//panelHeight:"auto",  //设置容器高度自动增长
		url:url+'?action=SelAllLoc'
		
	}); */
   /* $('#dept').combobox({ //  yangyongtao   2017-11-17
		mode:'remote',  //必须设置这个属性
		onShowPanel:function(){ 
			$('#dept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'')
		}
	}); */
	var UserId="";
	if((LgGroupDesc=="护理部")||(LgGroupDesc=="Nursing Manager")){
		UserId="";
	}else{
		UserId=LgUserID;
	}
	$('#dept').combobox({ //  yangyongtao   2017-11-17
		mode:'remote',  //必须设置这个属性
		onShowPanel:function(){ //GetSecuGroupCombox(UserId)
			$('#dept').combobox('reload','dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetSecuGroupCombox&UserId='+UserId+'&GroupId='+LgGroupID+'&LocId='+LgCtLocID+'')
		}
	});
	//$("#dept").combobox('setValue',LgCtLocID);
	//$("#dept").combobox('setText',LgCtLocDesc);
	/* if((LgGroupDesc!="护理部")&&(LgGroupDesc!="Nursing Manager")){
		$('#dept').combobox("setValue",LgCtLocID);     //科室ID
		$("#dept").combobox('setText',LgCtLocDesc);
	} */
	
	if(LgGroupDesc=="住院护士"){
		$('#dept').combobox({disabled:true});;  //科室ID
		$('#dept').combobox("setValue",LgCtLocID);     //科室ID
		$("#dept").combobox('setText',LgCtLocDesc);
	}
	
	//状态
	$('#status').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:statArray
	});
	//报告类型
	$('#typeevent').combobox({
		//panelHeight:"auto",  //设置容器高度自动增长
		url:url+'?action=SelEventbyNew'
		
	});
	//分享状态
	$('#Share').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:statShare
	});
	//接收状态
	$('#receive').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:statReceive
	});
	//超时状态
	$('#OverTime').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:statOverTime
	});
	//首页 报告管理联动
	StrParam=getParam("StrParam");
	querytitle=getParam("querytitle");
	if(StrParam!=""){
		var tmp=StrParam.split("^");
		$("#stdate").datebox("setValue", tmp[0]);  //Init起始日期
		$("#enddate").datebox("setValue", tmp[1]);  //Init结束日期		
		if(tmp[2]!=""){
			$('#dept').combobox({disabled:true});;  //科室ID
			$('#dept').combobox("setValue",tmp[2]);     //科室ID
			$("#dept").combobox('setText',LgCtLocDesc);
		}else{
			$('#dept').combobox("setValue",tmp[2]);     //科室ID
			$("#dept").combobox('setText',"")
		}
		$('#status').combobox("setValue",tmp[7]);  //状态
		$('#typeevent').combobox("setValue",tmp[8]);  //报告类型
		$('#Share').combobox("setValue",tmp[9]);  //分享状态 
	}else{
		$("#stdate").datebox("setValue", StDate);  //Init起始日期
		$("#enddate").datebox("setValue", EndDate);  //Init结束日期
	}
	$('#querytitle').html("报告综合查询"+querytitle);
	cancelflag=getParam("cancelflag");//作废界面标识
	if(cancelflag=="Y"){
		$('#topquerytitle').html("报告其他查询");
		$('#querytitle').html("报告其他查询");
		$('#Print').hide();  //点击打印
		$('#Export').hide();  //点击导出(动态导出)
		$('#ExportAll').hide();
		$('#RepCancel').hide();
		$('#RepDelete').hide();

	}else{
		if((LgGroupDesc=="护理部")||(LgGroupDesc=="Nursing Manager")){
			//$('#ExportWord').show();
			//$('#ExportExcel').show();
			//$('#ExportExcelAll').show();
			//$('#ExportGather').show();
			$('#RepCancel').show();
			$('#RepDelete').show();
		}else{
			//$('#ExportWord').hide();
			//$('#ExportExcel').hide();
			//$('#ExportExcelAll').hide();
			//$('#ExportGather').hide();
			$('#RepCancel').hide();
			$('#RepDelete').hide();
		}
	}
	$('#Refresh').bind("click",Query);  //刷新
	$('#Find').bind("click",Query);  //点击查询 
	$('#Print').bind("click",Print);  //点击打印
	$('#Export').bind("click",Export);  //点击导出(动态导出)
	//$('#ExportWord').bind("click",ExportWord);  //点击导出(卫计委wprd数据)	
	///$('#ExportExcel').bind("click",ExportExcel);  //点击导出(卫计委excel数据)
	//$('#ExportExcelAll').bind("click",ExportExcelAll);  //点击导出(医管局excel数据)
	$('#ExportAll').bind("click",ExportAll);  //点击导出(全部类型固定数据)
	//$('#ExportGather').bind("click",ExportGather);  //点击导出(汇总版)
	$('#RepCancel').bind("click",RepCancel); //作废 
	$('#RepDelete').bind("click",RepDelete); //删除 
	InitPatList();
	
	$("#reqList").height($(window).height()-245)//hxy 08-28 st
	$("#maindg").datagrid('resize', {           
            height : $(window).height()-245
    }); 
    window.onresize=resizeH;                    //hxy 08-28 ed
	
});
//自适应 hxy 2017-08-28
function resizeH(){
	$("#reqList").height($(window).height()-245)
	$("#maindg").datagrid('resize', { 
            height : $(window).height()-245
    }); 
}
//初始化报告列表
function InitPatList()
{
	//定义columns
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:'LkDetial',title:'操作',width:100,align:'center',formatter:SetCellOpUrl,hidden:true},
		{field:"RepID",title:'RepID',width:80,hidden:true},
		{field:"recordID",title:'recordID',width:80,hidden:true},
		{field:'RepShareStatus',title:'分享状态',width:80,align:'center',hidden:true},
		{field:'Edit',title:'查看',width:50,align:'center',formatter:setCellEditSymbol,hidden:false},
		{field:'StatusLast',title:'上一状态',width:100,hidden:true},
		{field:'StatusLastID',title:'上一状态ID',width:100,hidden:true},
		{field:"RepStaus",title:'报告状态',width:100,hidden:false},
		{field:"RepStausDr",title:'报告状态Dr',width:100,hidden:true},
		{field:'Medadrreceive',title:'接收状态',width:100,hidden:true},
		{field:'Medadrreceivedr',title:'接收状态dr',width:80,hidden:true},
		{field:'RepDate',title:'报告日期',width:120},
		{field:'PatID',title:'登记号',width:120,hidden:false},
		{field:'AdmNo',title:'病案号',width:120},
		{field:'PatName',title:'姓名',width:120},
		{field:'RepType',title:'报告类型',width:280},
		{field:'OccurDate',title:'发生日期',width:120},
		{field:'OccurLoc',title:'发生科室',width:150},
		{field:'LocDep',title:'报告系统',width:150},
		{field:'RepLoc',title:'报告科室',width:150},	
		{field:'RepUser',title:'报告人',width:120},
		{field:'RepTypeCode',title:'报告类型代码',width:120,hidden:true},
		{field:'RepImpFlag',title:'重点关注',width:120,hidden:true},
		{field:'RepSubType',title:'报告子类型',width:120,hidden:true},
		{field:'RepLevel',title:'不良事件级别',width:120,hidden:true},
		{field:'RepInjSev',title:'伤害严重度',width:120,hidden:true},
		{field:'RepTypeDr',title:'报告类型Dr',width:120,hidden:true},
		{field:'StaFistAuditUser',title:'被驳回人',width:120,hidden:true},
		{field:'BackAuditUser',title:'驳回操作人',width:120,hidden:true},
		{field:'RepOverTimeflag',title:'填报超时',width:120,hidden:false},
		{field:'AutOverTimeflag',title:'护士长审核超时',width:120,hidden:false},
		{field:'CaseShareLoclist',title:'共享科室',width:120,hidden:false},
		{field:'FileFlag',title:'归档状态',width:80}
		
	]];

	//定义datagrid
	$('#maindg').datagrid({
		toolbar: '#toolbar',//hxy add 08-28
		title:'', //hxy 报告列表
		method:'get',
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryRepList'+'&StrParam='+StrParam,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true,
		height:300,
		nowrap:false,
		rowStyler:function(index,row){    // yangyongtao 2017-11-22
	        /* if ((row.RepStaus).indexOf("驳回") >= 0){  
	            return 'background-color:red;';  
	        } */
	          
	        if ((row.StaFistAuditUser==LgUserName)||(row.BackAuditUser==LgUserName)){  
	            return 'background-color:red;';  
	        } 
    	}
	});
	if(StrParam==""){
		Query();
	}
}
function Query()
{
	//1、清空datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	if((querytitle!="")&&(LgGroupDesc=="住院护士")){
		$('#dept').combobox("setValue",LgCtLocID);     //科室ID
		$("#dept").combobox('setText',LgCtLocDesc);
	}
	//2、查询
	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var LocID=$('#dept').combobox('getValue');     //科室ID
	var status=$('#status').combobox('getValue');  //状态
	var typeevent=$('#typeevent').combobox('getValue');  //报告类型
	var statShare=$('#Share').combobox('getValue');  //分享状态 
	var receive="";  //$('#receive').combobox('getText');  //接收状态 
	var OverTime=$('#OverTime').combobox('getValue');  //接收状态
	if (status==undefined){status="";} 
	if (typeevent==undefined){typeevent="";}
	if (statShare==undefined){statShare="";}
	if (OverTime==undefined){OverTime="";}
	var PatNo=$.trim($("#patno").val());
	var StrParam=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^"+status+"^"+typeevent+"^"+statShare+"^"+receive+"^^^"+"^"+OverTime+"^^"+cancelflag;
	//var StrParam=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+134+"^"+6+"^"+359+"^"+status+"^"+typeevent+"^"+statShare;
	//alert(StrParam);
	$('#maindg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryRepList',	
		queryParams:{
			StrParam:StrParam}
	});
	querytitle="";
	if(cancelflag=="Y"){
		$('#querytitle').html("报告其他查询");
	}else{
		$('#querytitle').html("报告综合查询"+querytitle);
	}
		
	//var Rel='dhcadv.reportquery.csp?StrParam='+StrParam+'&querytitle='+"";
	//location.href=Rel;
}

function showDetail(){
	var rowsData = $("#datagrid").datagrid('getSelected')
	if (rowsData == null) {
		$.messager.alert("提示","请选择表单!");
		return;
	}
	window.open("formrecorditm.csp?recordId="+rowsData.recordID)
}


///设置编辑连接
function setCellEditSymbol(value, rowData, rowIndex)
{
		var recordID=rowData.recordID;         //表单填写记录ID
		var RepID=rowData.RepID                //报告ID   yangyongtao 2017-11-24
		var RepStaus=rowData.RepStaus;         //表单状态
		if (RepStaus=="未提交"){
			RepStaus=""; //报告为未提交，传参为空
		}
		var RepTypeDr=rowData.RepTypeDr;         //报告类型Dr
		var RepTypeCode=rowData.RepTypeCode; //报告类型代码
		var RepType=rowData.RepType; //报告类型
		var StatusLast=rowData.StatusLast; //报告上一状态
		var RepUser=rowData.RepUser //报告人
		var Medadrreceivedr=rowData.Medadrreceivedr //接收状态dr
		var StaFistAuditUser=rowData.StaFistAuditUser  //被驳回人
		var BackAuditUser=rowData.BackAuditUser //驳回操作人
		var editFlag=1;  //修改标志  1可以修改 -1不可以修改   如果上一状态为空并且接收状态是驳回（接收状态dr为2）则可以修改
		/* if((StatusLast!="")&&(RepStaus.indexOf("驳回") < 0)&&(RepUser!=LgUserName)){
			editFlag=-1;
		} */
		
		if(((StatusLast!="")&&(RepStaus.indexOf("驳回") < 0)&&(LgGroupDesc=="住院护士"))){///&&(Medadrreceivedr!=2)
			editFlag=-1;
		}
		if(((StatusLast=="")&&(RepUser!=LgUserName)&&(LgGroupDesc=="住院护士"))){///&&(Medadrreceivedr!=2)
			editFlag=-1;
		}
		if((Medadrreceivedr==2)&&(StaFistAuditUser!=LgUserName)&&(BackAuditUser!=LgUserName)){
			editFlag=-1;
		}
		if(cancelflag=="Y"){
			editFlag=-1;
		}
		
		var adrReceive=rowData.Medadrreceivedr; //接收状态dr
		
		return "<a href='#' onclick=\"showEditWin('"+recordID+"','"+RepStaus+"','"+RepTypeDr+"','"+RepTypeCode+"','"+RepType+"','"+editFlag+"','"+RepID+"','"+adrReceive+"')\"><img src='../scripts/dhcnewpro/images/adv_sel_8.png' border=0/></a>";
}

//编辑窗体
function showEditWin(recordID,RepStaus,RepTypeDr,RepTypeCode,RepType,editFlag,RepID,adrReceive)
{
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:'报告编辑',
		collapsible:true,
		border:false,
		closed:"true",
		width:1350,    ///2017-11-23  cy  修改弹出窗体大小 1250  项目1550
		height:600
	});
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layoutform.csp?recordId='+recordID+'&RepStaus='+RepStaus+'&RepTypeDr='+RepTypeDr+'&code='+RepTypeCode+'&desc='+RepType+'&editFlag='+editFlag+'&RepID='+RepID+'&adrReceive='+adrReceive+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
	//window.open("formrecorditmedit.csp?recordId="+rowsData.ID)
}

//操作  评论
function SetCellOpUrl(value, rowData, rowIndex)
{   var RepID=rowData.RepID;         //报表ID
	var RepTypeCode=rowData.RepTypeCode; //报告类型代码
	var RepShareStatus=rowData.RepShareStatus  //分享状态
	var html = "";
	if (RepShareStatus == "分享"){
		html = "<a href='#' onclick=\"newCreateConsultWin('"+RepID+"','"+RepTypeCode+"')\" style='margin:0px 5px;font-weight:bold;color:red;text-decoration:none;'>查看回复列表</a>";
	}else{
		  html = "<a href='#' onclick=\"newCreateConsultWin('"+RepID+"','"+RepTypeCode+"')\">查看回复列表</a>";
		}
    return html;
}

/**
  * 新建评论窗口
  */
function newCreateConsultWin(RepID,RepTypeCode){
	if($('#winonline').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="winonline"></div>');
	$('#winonline').window({
		title:'列表',
		collapsible:true,
		border:false,
		closed:"true",
		width:1110,
		height:500
	});
	
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.onlinereview.csp?ID='+RepID+'&TypeCode='+RepTypeCode+'"></iframe>';
		$('#winonline').html(iframe);
		$('#winonline').window('open');
	
}
//打印
function Print(){
	var rowsData = $("#maindg").datagrid('getSelections')
	if (rowsData.length=="0") {
		$.messager.alert("提示","请选择一条记录!");
		return;	
	}
	
	for(i=0;i<rowsData.length;i++){
		var recordId = rowsData[i].recordID;
		var RepID = rowsData[i].RepID;
		var RepTypeCode= rowsData[i].RepTypeCode;
		printRepForm(RepID,RepTypeCode);
		
	}	
	//window.open("formprint.csp?recordId="+rowsData[0].recordID);
}
//congyue 2017-09-06 点击首页图标，返回首页
function Gologin(){
	location.href='dhcadv.homepage.csp';
}
//2016-10-10
function CloseWinUpdate(){
	$('#win').window('close');
}
function cleanInput(){
	
	var StDate=formatDate(-7);  //一周前的日期
	var EndDate=formatDate(0); //系统的当前日期
	$("#stdate").datebox("setValue", StDate);  //Init起始日期
	$("#enddate").datebox("setValue", EndDate);  //Init结束日期
	$('#dept').combobox('setValue',"");     //科室ID
	$("#status").combobox('setValue',"");
	$('#typeevent').combobox('setValue',"");;  //报告类型
	$('#receive').combobox('setValue',"");;  //接收状态
	$('#Share').combobox('setValue',"");;  //分享状态
 	$("#ImpFlag").val("");             //关注状态
	$("#patno").val("");
}
// 导出word 卫计委
function ExportWord()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert('提示',"<font style='color:red;font-weight:bold;font-size:20px;'>请先选择一行记录!</font>","error");
		return;
	}
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>已取消操作！</font>","error");
		return;
	}
   	var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择有效路径后,重试！</font>","error");
		return;
	}

	for(i=0;i<selItems.length;i++){
		var recordId = selItems[i].recordID;
		var RepID = selItems[i].RepID;
		var RepTypeCode= selItems[i].RepTypeCode;
		var RepType= selItems[i].RepType;
		ExportWordData(RepID,RepTypeCode,RepType,filePath);
	}	
	$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出完成！导出目录为:"+filePath+"</font>","info");
}
// 导出Excel 卫计委
function ExportExcel()
{
	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>已取消操作！</font>","error");
		return;
	}
  	var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择有效路径后,重试！</font>","error");
		return;
	}
	var Staticflag=ExportExcelStatic(StDate,EndDate,filePath);
	if(Staticflag==true){
		$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出完成！导出目录为:"+filePath+"</font>","info");
	}else{
		$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出失败！</font>","info");
	}
}
// 导出Excel 医管局
function ExportExcelAll()
{

	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var typeevent=$('#typeevent').combobox('getText');  //报告类型
	if((typeevent=="")||(typeevent=="全部")){
		$.messager.alert("提示:","请选择具体报告类型","error");
		return;
	}
	if((typeevent.indexOf("医疗") >= 0)){
		$.messager.alert("提示:","该类型没有医管局需要数据，请选择其他类型","error");
		return;
	}
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>已取消操作！</font>","error");
		return;
	}
  	var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择有效路径后,重试！</font>","error");
		return;
	}
	var Allflag=ExportExcelAllData(StDate,EndDate,typeevent,filePath);
	if(Allflag==true){
		$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出完成！导出目录为:"+filePath+"</font>","info");
	}else{
		$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出失败！</font>","info");
	}
}

// 导出(动态)
function Export()
{
	var typeevent=$('#typeevent').combobox('getValue');  //报告类型
	if((typeevent=="")||(typeevent=="全部")){
		$.messager.alert("提示:","请选择具体报告类型","error");
		return;
	}
	//formNameID==##class(web.DHCADVCOMMONPART).GetFormNameID
	runClassMethod("web.DHCADVCOMMONPART","GetFormNameID",{"AdrEvtDr":typeevent},
	function(ret){
		formNameID=ret
	},'text',false);
	//窗体处在打开状态,退出
	if(!$('#ExportWin').is(":visible")){
		$('#ExportWin').window('open');
		//initDatagrid();
		reloadAllItmTable(formNameID);
		$('#setItmTable').datagrid('loadData', {total:0,rows:[]}); 
		return;
	} 
	$('#ExportWin').window({
		title:'导出',
		collapsible:false,
		border:false,
		closed:false,
		width:800,
		height:480
	});
	$('#ExportWin').window('open');
	initDatagrid();
	$("a:contains('添加元素')").bind('click',addItm);
    $("a:contains('删除元素')").bind('click',delItm);
    $("a:contains('全部选中')").bind('click',selAllItm);
    $("a:contains('取消选中')").bind('click',unSelAllItm);
    $("a:contains('全部删除')").bind('click',delAllItm);

}

function initDatagrid(){
	var columns=[[
		{field:'FormDicID',title:'FormDicID',width:50,hidden:true},
		{field:'DicField',title:'DicField',width:100,hidden:true},
		{field:'DicDesc',title:'全部列',width:200}
	]];
	
	$("#allItmTable").datagrid({
		url:LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=GetSetFiel",
		queryParams:{
			ForNameID:""
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		loadMsg: '正在加载信息...',
		//showHeader:false,
		rownumbers : false,
		pagination:false,
		onSelect:function (rowIndex, rowData){
			
		}
	});	
	
	var setcolumns=[[
		{field:'FormDicID',title:'FormDicID',width:50,hidden:true},
		{field:'DicField',title:'DicField',width:100,hidden:true},
		{field:'DicDesc',title:'导出列',width:200}
	]];

	$("#setItmTable").datagrid({
		url:"",
		fit:true,
		rownumbers:true,
		columns:setcolumns,
		loadMsg: '正在加载信息...',
		//showHeader:false,
		rownumbers : false,
		pagination:false,
		onSelect:function (rowIndex, rowData){
			
		}
	});
	$('#setItmTable').datagrid('loadData', {total:0,rows:[]}); 
	reloadAllItmTable(formNameID);
	reloadSetFielTable(formNameID);
		
}
///添加元素
function addItm(){
	var datas = $("#allItmTable").datagrid("getSelections");
	if(datas.length<1){
		$.messager.alert("提示","未选中左侧数据！");
		return;	    
	}
	for(var i=0;i<datas.length;i++)
	{
		$('#setItmTable').datagrid('insertRow',{
			index:0,
			row:{
				FormDicID:datas[i].FormDicID,
				DicField:datas[i].DicField,
				DicDesc:datas[i].DicDesc
			}
		
		})
		var aindex=$('#allItmTable').datagrid('getRowIndex',datas[i]);
		$('#allItmTable').datagrid('deleteRow',aindex);

	} 

}
function delItm(){
	var datas = $("#setItmTable").datagrid("getSelections");
	if(datas.length<1){
		$.messager.alert("提示","未选中右侧数据！");
		return;	    
	}
	for(var i=0;i<datas.length;i++)
	{
		var aindex=$('#setItmTable').datagrid('getRowIndex',datas[i]);
		$('#setItmTable').datagrid('deleteRow',aindex);
		$('#allItmTable').datagrid('insertRow',{
			index:0,
			row:{
				FormDicID:datas[i].FormDicID,
				DicField:datas[i].DicField,
				DicDesc:datas[i].DicDesc
			}
		})
	}
}

function delAllItm(){
	$("#setItmTable").datagrid("checkAll");
	delItm();
}
function selAllItm(){
	$("#allItmTable").datagrid("checkAll");
}
function unSelAllItm(){
	$("#allItmTable").datagrid("uncheckAll");
}
//reload 左上表
function reloadAllItmTable(value){
	$("#allItmTable").datagrid('load',{
		ForNameID:value
	})
}

function reloadSetFielTable(value){
	$("#setItmTable").datagrid('load',{
		ForNameID:value
	})
}
///刷新 field和fieldVal
function reloadTopTable(){
	reloadSetFielTable(formNameID);
	reloadAllItmTable(formNameID);
}
function ExportOK(){
	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var RepType=$('#typeevent').combobox('getText');  //报告类型
	var datas = $("#setItmTable").datagrid("getRows");
	if(datas.length<1){
		$.messager.alert("提示","导出列为空，请添加导出列！");
		return;	    
	}
	var fieldList = [],descList=[],tablefield=[],tabledesc=[];
	for(var i=0;i<datas.length;i++)
	{
		if (datas[i].DicField.indexOf("UlcerPart")>=0){
			tablefield.push(datas[i].DicField);
			tabledesc.push(datas[i].DicDesc);
		}else{
			fieldList.push(datas[i].DicField);
			descList.push(datas[i].DicDesc);
		}
	} 
	var TitleList=fieldList.join("#");
	var DescList=descList.join("#");
	var TabFieldList=tablefield.join("#");
	var TabDescList=tabledesc.join("#");
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>已取消操作！</font>","error");
		return;
	}
  	var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择有效路径后,重试！</font>","error");
		return;
	}
	var Allflag=ExportData(StDate,EndDate,RepType,TitleList,DescList,filePath,TabFieldList,TabDescList);
	if(Allflag==true){
		$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出完成！导出目录为:"+filePath+"</font>","info");
		$('#ExportWin').window('close');
	}else{
		$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出失败！</font>","info");
	} 
	
}
// 全部导出Excel 
function ExportAll()
{

	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var typeevent=$('#typeevent').combobox('getText');  //报告类型
	/* if((typeevent=="")||(typeevent=="全部")){
		$.messager.alert("提示:","类型条件为空，请选择类型","error");
		return;
	} */
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>已取消操作！</font>","error");
		return;
	}
  	var re=/[a-zA-Z]:\\/;     
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择有效路径后,重试！</font>","error");
		return;
	}
	var Allflag=ExportAllData(StDate,EndDate,typeevent,filePath);
	if(Allflag==true){
		$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出完成！导出目录为:"+filePath+"</font>","info");
	}else{
		$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出失败！</font>","info");
	}
}
// 导出Excel 汇总版
function ExportGather()
{

	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var typeevent=$('#typeevent').combobox('getText');  //报告类型
	/* if((typeevent=="")||(typeevent=="全部")){
		$.messager.alert("提示:","类型条件为空，请选择类型","error");
		return;
	} */
	var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>已取消操作！</font>","error");
		return;
	}
  	var re=/[a-zA-Z]:\\/;     
	if ((filePath.match(re)=="")||(filePath.match(re)==null)){
		$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择有效路径后,重试！</font>","error");
		return;
	}
	var Allflag=ExportGatherData(StDate,EndDate,typeevent,filePath);
	if(Allflag==true){
		$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出完成！导出目录为:"+filePath+"</font>","info");
	}else{
		$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出失败！</font>","info");
	}
}
//作废
function RepCancel()
{
	var NextLoc="";
	var LocAdvice="";
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	$.messager.confirm("提示", "是否进行作废操作", function (res) {//提示是否删除
		if (res) {
			$.each(selItems, function(index, item){
				var RepID=item.RepID;         //关联主表ID
				var RepTypeCode=item.RepTypeCode;         //报告类型代码
				var Medadrreceivedr=item.Medadrreceivedr;//接收状态dr
				var RepStausDr=item.RepStausDr //当前状态id
				var params=RepID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+RepTypeCode+"^"+RepStausDr+"^"+"Y";   //参数串
				var num=$('#maindg').datagrid("getRowIndex",item); //2017-11-23  获取index值 
				var errnum=$('[datagrid-row-index="'+num+'"] .datagrid-cell-rownumber').text(); //2017-11-23 获取行号
				
				runClassMethod("web.DHCADVCOMMONPART","MataRepCancel",{'params':params},
				function(jsonString){ 
					//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  获取行数 区分哪一行操作出错
					if(jsonString.ErrCode < 0){
						$.messager.alert("提示:","作废错误,错误原因:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");  //+"第"+errnum+"条数据"
					}
				},"json",false);
				
			})
			$("#showalert").hide();
			$('#maindg').datagrid('reload'); //重新加载
			$('#maindg').datagrid('unselectAll') //2017-04-06 清除全选
		}
	})
}
//删除
function RepDelete()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	var RepFileFlag=""; //归档状态 2018-01-23
	$.each(selItems, function(index, item){
		var FileFlag=item.FileFlag; //归档状态 2018-01-23
		if (FileFlag=="已归档"){
			RepFileFlag="-1";
		}
	})
	if (RepFileFlag=="-1"){
		$.messager.alert("提示:","所选报告存在已归档报告，不能删除！");
		return;
	}
	$.messager.confirm("提示", "是否进行删除操作", function (res) {//提示是否删除
		if (res) {
			$.each(selItems, function(index, item){
				var RepID=item.RepID;         //关联主表ID
				runClassMethod("web.DHCADVCOMMONPART","DelRepData",{'RepID':RepID},
				function(data){ 
					//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  获取行数 区分哪一行操作出错
					if(data< 0){
						$.messager.alert("提示:","删除失败！");  //+"第"+errnum+"条数据"
					}
				},"",false);
				
			})
			$('#maindg').datagrid('reload'); //重新加载
			$('#maindg').datagrid('unselectAll') //2017-04-06 清除全选
		}
	})
}
