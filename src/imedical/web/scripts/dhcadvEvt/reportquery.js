
/// Creator: congyue
/// CreateDate: 2017-07-28
/// Descript: 不良事件升级 查询界面
var LgParam=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgHospID;
var url = "dhcadv.repaction.csp";
var statShare = [{ "val": "未分享", "text": "未分享" },{ "val": "分享", "text": "分享" }];
var statArray = [{ "val": "Y", "text": "已提交" },{ "val": "N", "text": "未提交" }];
var statReceive = [{ "val": "未接收", "text": "未接收" },{ "val": "1", "text": "接收" },{ "val": "2", "text": "驳回" }];
var statOverTime = [{ "val": "Y", "text": "超时" },{ "val": "N", "text": "未超时" }];
var condArray= [{ "val": "and", "text": "并且" },{ "val": "or", "text": "或者" }]; //逻辑关系
var stateBoxArray= [{ "val": "=", "text": "等于" },{ "val": ">", "text": "大于" },{ "val": ">=", "text": "大于等于" },{ "val": "<=", "text": "小于等于" },{ "val": "<", "text": "小于" }]; //条件
var formNameID="",StrParam="",querytitle="" ,cancelflag="",curCondRow=1; // 表单id, 查询条件串, 查询标题, 作废标识, 高级查询条件 行数
var StDate="";   //一周前的日期   2018-01-26 修改，默认开始日期为上线使用日期，即2018-01-01
var EndDate=formatDate(0); //系统的当前日期
var ColSort="",ColOrder=""; // 排序列 , 排序标志:desc 降序   asc 升序
$(function(){ 
	InitPageComponent(); 	  /// 初始化界面控件内容
	InitPageButton();         /// 界面按钮控制
	InitPageDataGrid();		  /// 初始化页面datagrid
	InitPageStyle();          /// 初始化页面样式	
});
/// 初始化界面控件内容
function InitPageComponent(){
	if(DateFormat=="4"){ //日期格式 4:"DMY" DD/MM/YYYY
		StDate="01"+"/"+"01"+"/"+2018;  //当年开始日期
	}else if(DateFormat=="3"){ //日期格式 3:"YMD" YYYY-MM-DD
		StDate=2018+"-"+"01"+"-"+"01";  //当年开始日期
	}else if(DateFormat=="1"){ //日期格式 1:"MDY" MM/DD/YYYY
		StDate="01"+"/"+"01"+"/"+2018;  //当年开始日期
	}
	//科室
   $('#dept').combobox({ 
		mode:'remote',  //必须设置这个属性
		onShowPanel:function(){ 
			$('#dept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'')
		}
	});
	
	//状态
	$('#status').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:statArray
	});
	//报告类型
	$('#typeevent').combobox({
		url:url+'?action=SelEventbyNew&param='+LgGroupID+"^"+LgCtLocID+"^"+LgUserID,
		onSelect: function(rec){  
			if((rec.text=="管路滑脱报告单")||(rec.text=="用药错误报告单")||(rec.text=="跌倒(坠床)事件报告单")||(rec.text=="压疮报告单")){
	        	$('#Fish').show();
	        }else{
        		$('#Fish').hide();
	        }
		}
	});
	//分享状态
	$('#Share').combobox({
		panelHeight:"auto", 
		data:statShare
	});
	//接收状态
	$('#receive').combobox({
		panelHeight:"auto",
		data:statReceive
	});
	//超时状态
	$('#OverTime').combobox({
		panelHeight:"auto", 
		data:statOverTime
	});
	//逻辑关系
	$('#condCombox').combobox({
		panelHeight:"auto", 
		data:condArray
	});
	//首页 报告管理联动
	StrParam=getParam("StrParam");
	querytitle=getParam("querytitle");
	querytitle=decodeURI(decodeURI(querytitle));
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
		$('#dept').combobox("setValue",LgCtLocID);     //科室ID
		$("#dept").combobox('setText',LgCtLocDesc);
	}
	$('#querytitle').html("报告综合查询"+querytitle);
}
/// 界面按钮控制
function InitPageButton(){
	$('#Refresh').bind("click",Query);  //刷新
	$('#Find').bind("click",Query);  //点击查询 
	$('#Printhtml').bind("click",htmlPrint);  //点击打印  Print 使用html打印
	$('#Export').bind("click",Export);  //点击导出(动态导出)
	$('#ExportAll').bind("click",ExportAll);  //点击导出(全部类型固定数据)
	$('#ExportWord').bind("click",ExportWord);  //点击导出(word导出)	
	$('#RepCancel').bind("click",RepCancel); //作废 
	$('#RepDelete').bind("click",RepDelete); //删除
	$('#Fish').bind("click",fish); //鱼骨图	
	$("#addCondBTN").on('click',addCondition); // 高级查询条件增加
	$("#Print").bind("click",Print);		 //新作的打印
}
/// 初始化页面样式
function InitPageStyle(){
	addCondition(); // 高级查询条件增加
}

//自适应 hxy 2017-08-28
function resizeH(){
	$("#reqList").height($(window).height()-245)
	$("#maindg").datagrid('resize', { 
            height : $(window).height()-245
    }); 
}
//初始化页面datagrid
function InitPageDataGrid()
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
		{field:"RepStaus",title:'报告状态',hidden:false},
		{field:"RepStausDr",title:'报告状态Dr',width:100,hidden:true},
		{field:'Medadrreceive',title:'接收状态',width:100,hidden:true},
		{field:'Medadrreceivedr',title:'接收状态dr',width:80,hidden:true},
		{field:'RepDate',title:'报告日期',width:120,sortable:true},
		{field:'PatID',title:'登记号',width:120,hidden:false},
		{field:'AdmNo',title:'病案号',width:120,formatter:setPatientRecord},
		{field:'PatName',title:'姓名',width:120},
		{field:'RepType',title:'报告类型',width:280},
		{field:'OccurDate',title:'发生日期',width:120},
		{field:'OccurLoc',title:'发生科室',width:150},
		{field:'LocDep',title:'报告系统',width:150,hidden:true},
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
		{field:'AutOverTimeflag',title:'受理超时',width:120,hidden:false},
		{field:'CaseShareLoclist',title:'共享科室',width:120,hidden:false},
		{field:'FileFlag',title:'归档状态',width:80},
		{field:'AdmID',title:'就诊ID',width:80,hidden:true}
		
	]];

	//定义datagrid
	$('#maindg').datagrid({
		toolbar: '#toolbar',//hxy add 08-28
		title:'', //hxy 报告列表
		method:'get',
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryRepList'+'&StrParam='+StrParam+'&LgParam='+LgParam+'&ParStr='+"",
		fit:true,
		rownumbers:true,
		columns:columns,
		remoteSort:false,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true,
		height:300,
		nowrap:true,
		rowStyler:function(index,row){    // yangyongtao 2017-11-22
	        /* if ((row.RepStaus).indexOf("驳回") >= 0){  
	            return 'background-color:red;';  
	        } */
	          
	        if ((row.StaFistAuditUser==LgUserName)||(row.BackAuditUser==LgUserName)){  
	            return 'background-color:red;';  
	        } 
    	},
        onSelect:function(rowIndex, rowData){
	        ButtonInfo();
        },
        onUnselect:function(rowIndex, rowData){ 
        	ButtonInfo();
		},
		onSortColumn:function (sort,order){
			ColSort=sort;
			ColOrder=order;
			Query();
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
	var ColParam=ColSort+"^"+ColOrder;
	$('#maindg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryRepList',	
		queryParams:{
			StrParam:StrParam,
			LgParam:LgParam,
			ParStr:getParStr(),
			ColParam:ColParam}
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
		var recordID=escape(rowData.recordID);         //表单填写记录ID
		var RepID=escape(rowData.RepID);                //报告ID   yangyongtao 2017-11-24
		var RepStaus=escape(rowData.RepStaus);         //表单状态
		if (RepStaus=="未提交"){
			RepStaus=""; //报告为未提交，传参为空
		}
		var RepTypeDr=escape(rowData.RepTypeDr);         //报告类型Dr
		var RepTypeCode=escape(rowData.RepTypeCode); //报告类型代码
		var RepType=escape(rowData.RepType); //报告类型
		var StatusLast=escape(rowData.StatusLast); //报告上一状态
		var RepUser=rowData.RepUser; //报告人
		var Medadrreceivedr=escape(rowData.Medadrreceivedr); //接收状态dr
		var StaFistAuditUser=escape(rowData.StaFistAuditUser);  //被驳回人
		var BackAuditUser=escape(rowData.BackAuditUser); //驳回操作人
		var FileFlag=rowData.FileFlag;  			//归档标识
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
		if(((RepStaus=="")&&((RepUser!="匿名")&&(RepUser!=LgUserName)))){///&&(Medadrreceivedr!=2)  //sufan 20200420 匿名报告会导致不能保存提交
			editFlag=-1;
		}
		if((Medadrreceivedr==2)&&(StaFistAuditUser!=LgUserName)&&(BackAuditUser!=LgUserName)){
			editFlag=-1;
		}
		if(cancelflag=="Y"){
			editFlag=-1;
		}
		if((FileFlag!="未归档")&&(FileFlag!="撤销归档")){
			editFlag=-1;
		}
		var adrReceive=escape(rowData.Medadrreceivedr); //接收状态dr
		RepUser=escape(RepUser); 
		FileFlag=escape(FileFlag);  			//归档标识
		return "<a href='#' onclick=\"showEditWin('"+recordID+"','"+RepStaus+"','"+RepTypeDr+"','"+RepTypeCode+"','"+RepType+"','"+editFlag+"','"+RepID+"','"+adrReceive+"','"+RepUser+"','"+FileFlag+"')\"><img src='../scripts/dhcadvEvt/images/adv_sel_8.png' border=0/></a>";
}

//编辑窗体
function showEditWin(recordID,RepStaus,RepTypeDr,RepTypeCode,RepType,editFlag,RepID,adrReceive,RepUser,FileFlag)
{
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:'报告编辑',
		border:false,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closed:"true",
		width:screen.availWidth-100,    ///2017-11-23  cy  修改弹出窗体大小 1250  项目1550
		height:screen.availHeight-100
	});
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layoutform.csp?recordId='+recordID+'&RepStaus='+RepStaus+'&RepTypeDr='+RepTypeDr+'&code='+RepTypeCode+'&desc='+RepType+'&editFlag='+editFlag+'&RepID='+RepID+'&adrReceive='+adrReceive+'&winflag='+1+'&RepUser='+RepUser+'&FileFlag='+FileFlag+'"></iframe>'; 
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
		border:false,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closed:"true",
		width:1110,
		height:500
	});
	
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.onlinereview.csp?ID='+RepID+'&TypeCode='+RepTypeCode+'"></iframe>';
		$('#winonline').html(iframe);
		$('#winonline').window('open');
	
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
/*// 导出word 卫计委
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
}*/
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
	}/*else{
		$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出失败！</font>","info");
	}*/
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
	}/*else{
		$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出失败！</font>","info");
	}*/
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
		border:false,
		collapsible:false,
		minimizable:false,
		maximizable:false,
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
	var filePath="";
	ExportData(StDate,EndDate,RepType,TitleList,DescList,filePath,TabFieldList,TabDescList);
	//var filePath=browseFolder();
	//if (typeof filePath=="undefined"){
	//	$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>已取消操作！</font>","error");
	//	return;
	//}
  	//var re=/[a-zA-Z]:\\/;     //wangxuejian 2016-10-10
	//if ((filePath.match(re)=="")||(filePath.match(re)==null)){
	//	$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择有效路径后,重试！</font>","error");
	//	return;
	//}
	//var Allflag=ExportData(StDate,EndDate,RepType,TitleList,DescList,filePath,TabFieldList,TabDescList);
	//if(Allflag==true){
	//	$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出完成！导出目录为:"+filePath+"</font>","info");
	//	$('#ExportWin').window('close');
	//}else{
	//	$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出失败！</font>","info");
	//} 
	
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
	ExportAllData(StDate,EndDate,typeevent);
	//var filePath=browseFolder();
	//if (typeof filePath=="undefined"){
	//	$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>已取消操作！</font>","error");
	//	return;
	//}
  	//var re=/[a-zA-Z]:\\/;     
	//if ((filePath.match(re)=="")||(filePath.match(re)==null)){
	//	$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择有效路径后,重试！</font>","error");
	//	return;
	//}
	//var Allflag=ExportAllData(StDate,EndDate,typeevent,filePath);
	//if(Allflag==true){
	//	$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出完成！导出目录为:"+filePath+"</font>","info");
	//}else{
	//	$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出失败！</font>","info");
	//
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
	}/*else{
		$.messager.alert("提示:","<font style='color:green;font-weight:bold;font-size:20px;'>导出失败！</font>","info");
	}*/
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
	var RepFileFlag=""; //归档状态 2018-01-23
	$.each(selItems, function(index, item){
		var FileFlag=item.FileFlag; //归档状态 2018-01-23
		if (FileFlag=="已归档"){
			RepFileFlag="-1";
		}
	})
	if (RepFileFlag=="-1"){
		$.messager.alert("提示:","所选报告存在已归档报告，不能作废！");
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
//鱼骨图 cy 2018-08-03
function fish(){
	var selItems = $('#maindg').datagrid('getSelections');
	/*if (selItems.length>1){
		$.messager.alert("提示:","请选中一条数据！");
		return;
	}*/
	var RepID="",RepTypeCode=""
	if(selItems.length==1){
		RepID=selItems[0].RepID;//报告ID
		RepTypeCode=selItems[0].RepTypeCode;//报告类型代码/表单名称Code
	}
	var RepType=$('#typeevent').combobox('getValue');  //报告类型
	if (((RepTypeCode=="")||(RepTypeCode==undefined))&&((RepType=="")||(RepType==undefined))){
		$.messager.alert("提示:","请选中一条数据或者选择具体类型重试！");
		return;
	}
	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	
	var StrParam=StDate+"^"+EndDate+"^"+RepTypeCode+"^"+RepType
	if($('#fishwin').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="fishwin"></div>');
	$('#fishwin').window({
		title:'鱼骨图',
		border:false,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closed:"true",
		width:1200,
		height:620
	});
	
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.fishbone.csp?RepID='+RepID+'&StrParam='+StrParam+'"></iframe>';
	$('#fishwin').html(iframe);
	$('#fishwin').window('open');
}
//操作  病历
function setPatientRecord(value, rowData, rowIndex)
{   
	var RepID=rowData.RepID;         //报表ID
	var RepTypeCode=rowData.RepTypeCode; //报告类型代码
	var Adm=rowData.AdmID
	var PatNo=rowData.AdmNo  //分享状态
	html = "<a href='#' onclick=\"LoadPatientRecord('"+rowData.PatID+"','"+Adm+"')\">"+PatNo+"</a>";
    return html;
   // return "<a href='#' mce_href='#' onclick='LoadPatientRecord("+rowData.PatID+","+Adm+");'>"+PatNo+"</a>";  
    
}
/// 病历查看
function LoadPatientRecord(PatID,Adm){
	//createPatInfoWin(Adm,PatID);
	
	if($('#winlode').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="winlode"></div>');
	$('#winlode').window({
		title:'病历浏览列表',
		border:false,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closed:"true",
		width:document.body.offsetWidth-100,
		height:document.body.offsetHeight-100
	});
	var frm=window.parent.document.forms["fEPRMENU"];
	if(frm.EpisodeID){
		frm.EpisodeID.value=Adm;
	}
	//var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="websys.chartbook.hisui.csp?ChartBookName='+"DHC.inpatient.Doctor.DHCEMRbrowse"+"&PatientListPage="+ "inpatientlist.csp"+"&EpisodeID="+Adm+'"></iframe>';
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="websys.chartbook.hisui.csp?ChartBookName='+"DHC.Doctor.DHCEMRbrowse"+"&PatientListPage="+ "emr.browse.patientlist.csp"+"&SwitchSysPat=N"+"&EpisodeID="+Adm+'"></iframe>';
	$('#winlode').html(iframe);
	$('#winlode').window('open'); 
}
window.onbeforeunload = onbeforeunload_handler;
/// 页面关闭之前调用
function onbeforeunload_handler() {
    var frm=window.parent.document.forms["fEPRMENU"];
	if(frm.EpisodeID){
		frm.EpisodeID.value="";
	}
}
//html打印
function htmlPrint(){

	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	if (selItems.length>1){
		$.messager.alert("提示:","请选中一条数据！");
		return;
	}
	var RepID=selItems[0].RepID;//报告ID
	var RepTypeCode=selItems[0].RepTypeCode;//报告类型代码/表单名称Code
	var recordID=selItems[0].recordID;//表单记录IDrecordID
	var url="dhcadv.htmlprint.csp?RepID="+RepID+"&RepTypeCode="+RepTypeCode+"&recordID="+recordID+"&prtOrExp="+this.id
	//return;
	window.open(url,"_blank");
}
//判断登录人是否有操作按钮的权限来控制按钮显示与隐藏
function ButtonInfo(){
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$('#RepDelete').hide();
		$('#RepCancel').hide();
		$('#Fish').hide();
		return;
	}
	var DeleteOperSec="",CancelOperSec="",FishOperSec="";
	$.each(selItems, function(index, item){
		var RepTypeCode=item.RepTypeCode; //报告类型代码
		if((RepTypeCode=="advPipeOff")||(RepTypeCode=="advDrugUseErr")||(RepTypeCode=="advFallDownFill")||(RepTypeCode=="advSkinUlcer")){
        	FishOperSec="Y";
        }
		var OperSecparams=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+RepTypeCode;
		runClassMethod("web.DHCADVCOMMON","GetOperSecAll",{'params':OperSecparams},
		function(data){
			var tmp=data.split("^"); 
	        //删除权限
			if((tmp[4]=="Y")&&(DeleteOperSec!="N")){
				DeleteOperSec="Y";
	        }else{
		        DeleteOperSec="N";
		    }
	        //作废权限
			if((tmp[5]=="Y")&&(CancelOperSec!="N")){
				CancelOperSec="Y";
	        }else{
		        CancelOperSec="N";
		    }
		   
		},"text",false);
		
	})
    //删除权限
    if(DeleteOperSec=="N"){
		$('#RepDelete').hide();
    }else{
		$('#RepDelete').show();
    }
    //作废权限
    if(CancelOperSec=="N"){
		$('#RepCancel').hide();
    }else{
		$('#RepCancel').show();
    }
    //鱼骨图权限
	if(FishOperSec=="Y"){
		$('#Fish').show();
    }else{
		$('#Fish').hide();
    }
}

/////////////////////////////////////高级查询条件////////////////////////////////////////
// 增加行
function addCondition(){
	
	curCondRow=curCondRow+1;
	var html=""
	html+='<tr id="'+curCondRow+'Tr"><td><b style="padding-left:30px">查询条件</b>';
	html+=getLookUpHtml(curCondRow,1);
	html+=getSelectHtml(curCondRow,1);
	html+='<span style="padding-left:20px;"><input class="dhcc-input" id="QueCond"'+curCondRow+"-"+1+' style="width:120"/></span>';
	html+='</td><td style="padding-left:60px"><b style="padding-left:30px">查询条件</b>';
	html+=getLookUpHtml(curCondRow,2);
	html+=getSelectHtml(curCondRow,2);
	html+='<span style="padding-left:20px;"><input class="dhcc-input" id="QueCond"'+curCondRow+"-"+2+' style="width:120"/></span>';
	html+='</td><td style="padding-left:20px"><span style="cursor: pointer" onclick="addCondition()"><span  class="icon icon-add" >&nbsp;&nbsp;&nbsp;&nbsp;</span>增加行</span></td>>';
	if(curCondRow>2){
		html+='</td><td style="padding-left:20px"><span style="cursor: pointer" onclick="removeCond('+curCondRow+')"><span  class="icon icon-remove" >&nbsp;&nbsp;&nbsp;&nbsp;</span>删除行</span></td></tr>';
	}
	$("#condTable").append(html);
	//条件
	$("input[id^=stateBox"+curCondRow+"-]").combobox({
		panelHeight:"auto", 
		data:stateBoxArray
	});
	// 查询条件列
	$("input[id^=LookUp"+curCondRow+"-]").combobox({
		data:GetFrozeData()
	});
	setHeight();
}
// 删除行
function removeCond(row){
	$("#"+row+"Tr").remove();
	setHeight();
}
function setHeight(){
    var tableHeight=$('#condTable')[0].offsetHeight
    var divHeight=tableHeight+150;
    var centertop=divHeight+50;
    var maindgHeight=$(window).height()-divHeight-120;
    if(maindgHeight<400){
	    maindgHeight='auto';
	}
    $('#northdiv').css({
        height:divHeight+'px'
    });
    $('#nourthlayot').panel('resize', {
        height:'auto'
    });
    $('#centerlayout').panel('resize', {
        top:centertop+'px',
        height:'auto'
    });
    $("#reqList").css({
	    height:maindgHeight
	})
	$("#maindg").datagrid('resize', {           
        height:maindgHeight
    }); 

}
// 条件语句
function getSelectHtml(row,column){
	var key=row+"-"+column;
	var html='<span style="padding-left:20px;">';
	html+='<input  id="stateBox'+key+'" style="width:80;" class="easyui-combobox" data-options="valueField:\'val\',textField:\'text\'"/>'
	html+='</span>'
	return html;
}
// 查询条件 输入框加载
function getLookUpHtml(row,column){
	var html="";
	var key=row+"-"+column;
	html+='<span class="lookup" style="padding-left:20px;">'
	//html+='		<input data-id="" class="textbox lookup-text validatebox-text"  style="width: 118px; height: 28px; line-height: 28px;" id="'+key+'" onkeypress="return onKeyPress(event,this)" data-key='+key+' type="text" >'
	//html+='		<span class="lookup-arrow" style="height: 28px;" onclick="showDic(this)" data-key='+key+'></span>'
	html+='<input id="LookUp'+key+'" style="width:120" class="easyui-combobox" data-options="valueField:\'val\',textField:\'text\'"/>'	
	html+='</span>'
	return html;
}
// 点击事件
function toggleExecInfo(obj){
	if($(obj).hasClass("expanded")){
		$(obj).removeClass("expanded");
		$(obj).html("高级查询");
		$("#condTable").hide();
		$("#dashline").hide();
		$("#condTd").hide();
		
	}else{
		$(obj).addClass("expanded");
		$(obj).html("隐藏");
		$("#condTable").show();
		$("#dashline").show();
		$("#condTd").show();
	}
	setHeight();
}
// 获取表格显示列（作为查询条件下拉数据）
function GetFrozeData(){
	//获取所有未冻结列数据
     var cols = $("#maindg").datagrid('getColumnFields');
     var array = [];
     for (var i=0;i<cols.length;i++) {     
         //获取每一列的列名对象
         var col = $("#maindg").datagrid("getColumnOption", cols[i]);
         //声明对象
         var obj = new Object();
         if((cols[i]!="ck")&&(cols[i]!="Edit")&&(col.hidden!=true)){
         	obj["val"] = cols[i];
         	obj["text"] = col.title.trim();
         	//追加对象
         	array.push(obj);
         }
     }   
     return array;
}

// 获取查询条件字符串
function getParStr(){
	var retArr=[];
	var cond=$("#condCombox").combobox('getValue');
	$("#condTable").find("td").each(function(index,obj){
		if($(obj).children().length<3){
			return true;
		}
		// 条件下拉值（列名 代码）
		var column=$(obj).children().eq(1).find("input")[2];
		if(column!=undefined){
			column=column.value;
		}else{
			column="";
		}
		if(column==""){
			return true;	
		}
		// 判断条件 下拉值（大于，小于）
		var op=$(obj).children().eq(2).find("input")[2];
		if(op!=undefined){
			op=op.value;
		}else{
			op="";
		}
		// 输入判断值 （具体的数据）
		var columnValue=$(obj).children().eq(3).find("input")[0].value;
		if(columnValue==""){
			return true;
		}

		// 列_$c(1)_值_$c(1)_判断条件_$c(1)_逻辑关系
		var par=column;
		par+=String.fromCharCode(1)+columnValue;
		par+=String.fromCharCode(1)+op;
		par+=String.fromCharCode(1)+cond;
		retArr.push(par);
	})
	return retArr.join("^");
}
/////////////////////////////////////新作打印与导出////////////////////////////////////////
///新作的打印
function Print()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	if (selItems.length>1){
		$.messager.alert("提示:","请选中一条数据！");
		return;
	}
	var RepID=selItems[0].RepID;//报告ID
	var RepTypeCode=selItems[0].RepTypeCode;//报告类型代码/表单名称Code
	runClassMethod("web.DHCADVRepPrint","GetPrintData",{"AdvMasterDr":RepID,"PrintUserId":LgUserID,"LgHospID":LgHospID},function(ret){
		dhcprtPrint(RepTypeCode,ret,"print");
	},"json");
}
///导出word格式
function ExportWord()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("提示:","请选中行,重试！");
		return;
	}
	if (selItems.length>1){
		$.messager.alert("提示:","请选中一条数据！");
		return;
	}
	var RepID=selItems[0].RepID;//报告ID
	var RepTypeCode=selItems[0].RepTypeCode;//报告类型代码/表单名称Code
	runClassMethod("web.DHCADVRepPrint","GetPrintData",{"AdvMasterDr":RepID,"PrintUserId":LgUserID,"LgHospID":LgHospID},function(ret){
		exportword(RepTypeCode,ret);
	},"json");
}

