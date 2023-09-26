
/// Creator: congyue
/// CreateDate: 2017-07-28
/// Descript: 不良事件升级 作废查询界面
var url = "dhcadv.repaction.csp";
var formNameID="";
var StrParam="";
var StDate="";  //formatDate(-7);  //一周前的日期   2018-01-26 修改，默认开始日期为上线使用日期，即2018-01-01
var EndDate=formatDate(0); //系统的当前日期
var querytitle="" ;
var LgParam=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgHospID;
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
	$("#stdate").datebox("setValue",StDate);  //Init起始日期
	$("#enddate").datebox("setValue",EndDate);  //Init结束日期
	//科室
   $('#dept').combobox({ //  yangyongtao   2017-11-17
		mode:'remote',  //必须设置这个属性
		onShowPanel:function(){ 
			$('#dept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'')
		}
	});
	if(LgGroupDesc!="护理部"){
		$('#dept').combobox("setValue",LgCtLocID);     //科室ID
		$("#dept").combobox('setText',LgCtLocDesc);
	}
	//报告类型
	$('#typeevent').combobox({
		url:url+'?action=SelEventbyNew&param='+LgGroupID+"^"+LgCtLocID+"^"+LgUserID
	});
}	
/// 界面按钮控制
function InitPageButton(){
	$('#Refresh').bind("click",Query);  //刷新
	$('#Find').bind("click",Query);  //点击查询 
	$('#Printhtml').bind("click",htmlPrint);  //点击打印 //hxy 2020-03-18 Print->htmlPrint
	$("#Print").bind("click",Print);		 //新作的打印
	$('#Export').bind("click",Export);  //点击导出(动态导出)
}
/// 初始化页面样式
function InitPageStyle(){
	$("#reqList").height($(window).height()-245)//hxy 08-28 st
	$("#maindg").datagrid('resize', {           
            height : $(window).height()-245
    }); 
    window.onresize=resizeH;                    //hxy 08-28 ed
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
		{field:"RepID",title:'RepID',width:80,hidden:true},
		{field:"recordID",title:'recordID',width:80,hidden:true},
		{field:'RepShareStatus',title:'分享状态',width:80,align:'center',hidden:true},
		{field:'Edit',title:'查看',width:50,align:'center',formatter:setCellEditSymbol,hidden:false},
		{field:'StatusLast',title:'上一状态',width:100,hidden:true},
		{field:'StatusLastID',title:'上一状态ID',width:100,hidden:true},
		{field:"RepStaus",title:'报告状态',width:100,hidden:false},
		{field:'Medadrreceive',title:'接收状态',width:100,hidden:true},
		{field:'Medadrreceivedr',title:'接收状态dr',width:80,hidden:true},
		{field:'RepDate',title:'报告日期',width:120,sortable:true},
		{field:'PatID',title:'登记号',width:120,hidden:true},
		{field:'AdmNo',title:'病案号',width:120},
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
		{field:'RepOverTimeflag',title:'填报超时',width:120,hidden:true},
		{field:'AutOverTimeflag',title:'护士长审核超时',width:120,hidden:true},
		{field:'FileFlag',title:'归档状态',width:80,hidden:true}
		
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
		nowrap:false,
		rowStyler:function(index,row){    // yangyongtao 2017-11-22
	        if ((row.RepStaus).indexOf("驳回") >= 0){  
	            return 'background-color:red;';  
	        }  
    	},
		onSortColumn:function (sort,order){
			ColSort=sort;
			ColOrder=order;
			Query();
 		}
	});
	Query();
}
function Query()
{
	//1、清空datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	//2、查询
	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var LocID=$('#dept').combobox('getValue');     //科室ID
	var status="";  //状态
	var typeevent=$('#typeevent').combobox('getValue');  //报告类型
	var statShare="";  //分享状态 
	var receive="";  //$('#receive').combobox('getText');  //接收状态 
	var OverTime="";  //接收状态
	if (status==undefined){status="";} 
	if (typeevent==undefined){typeevent="";}
	if (statShare==undefined){statShare="";}
	if (OverTime==undefined){OverTime="";}
	var PatNo=$.trim($("#patno").val());
	var Cancelflag="Y";
	var StrParam=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^"+status+"^"+typeevent+"^"+statShare+"^"+receive+"^^^"+"^"+OverTime+"^"+""+"^"+Cancelflag;
	var ColParam=ColSort+"^"+ColOrder;
	$('#maindg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryRepList',	
		queryParams:{
			StrParam:StrParam,
			LgParam:LgParam,
			ParStr:"",
			ColParam:ColParam}
	});
	querytitle="";
	$('#querytitle').html("报告作废查询"+querytitle);	
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
		var RepID=escape(rowData.RepID);               //报告ID   yangyongtao 2017-11-24
		var RepStaus=escape(rowData.RepStaus);         //表单状态
		if (RepStaus=="未提交"){
			RepStaus=""; //报告为未提交，传参为空
		}
		var RepTypeDr=escape(rowData.RepTypeDr);         //报告类型Dr
		var RepTypeCode=escape(rowData.RepTypeCode); //报告类型代码
		var RepType=escape(rowData.RepType); //报告类型
		var StatusLast=escape(rowData.StatusLast); //报告上一状态
		var RepUser=escape(rowData.RepUser); //报告人
		var editFlag=-1;  //修改标志  1可以修改 -1不可以修改   如果上一状态为空并且接收状态是驳回（接收状态dr为2）则可以修改
		if((StatusLast!="")&&(RepStaus.indexOf("驳回") < 0)&&(RepUser!=LgUserName)){
			editFlag=-1;
		}
		var adrReceive=escape(rowData.Medadrreceivedr); //接收状态dr
		
		return "<a href='#' onclick=\"showEditWin('"+recordID+"','"+RepStaus+"','"+RepTypeDr+"','"+RepTypeCode+"','"+RepType+"','"+editFlag+"','"+RepID+"','"+adrReceive+"','"+RepUser+"')\"><img src='../scripts/dhcnewpro/images/adv_sel_8.png' border=0/></a>";
}

//编辑窗体
function showEditWin(recordID,RepStaus,RepTypeDr,RepTypeCode,RepType,editFlag,RepID,adrReceive,RepUser)
{
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:'报告编辑',
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		width:screen.availWidth-100,    ///2017-11-23  cy  修改弹出窗体大小 1250
		height:screen.availHeight-100
	});
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layoutform.csp?recordId='+recordID+'&RepStaus='+RepStaus+'&RepTypeDr='+RepTypeDr+'&code='+RepTypeCode+'&desc='+RepType+'&editFlag='+editFlag+'&RepID='+RepID+'&adrReceive='+adrReceive+'&RepUser='+RepUser+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
	//window.open("formrecorditmedit.csp?recordId="+rowsData.ID)
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

// 导出(动态)
function Export()
{
	var typeevent=$('#typeevent').combobox('getValue');  //报告类型
	if((typeevent=="")||(typeevent=="全部")){
		$.messager.alert("提示:","请选择具体报告类型！","error");
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
		initDatagrid();
		//$("#setItmTable").datagrid("loadData",{total:0,rows:[]})
		return;
	} 
	$('#ExportWin').window({
		title:'导出',
		collapsible:false,
		minimizable:false,
		maximizable:false,
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
	var filePath=""		//browseFolder();
	ExportData(StDate,EndDate,RepType,TitleList,DescList,filePath,TabFieldList,TabDescList);
	//if (typeof filePath=="undefined"){
	//	$.messager.alert("提示:","<font style='color:red;font-weight:bold;font-size:20px;'>请选择路径后,重试！</font>","error");
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
