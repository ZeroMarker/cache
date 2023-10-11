//phaauxiliaryinfo.js
//辅助信息区
var lisFlag=0;
var pacsFlag=0;
var orderFlag=0;
var diaFlag=0;
var pathology=0
var EpisodeID=4
var orderArr =  [{"value":"genenic+dosage+doseuom+instru+freq+duration","text":"医嘱名称+剂量+剂量单位+服用方法+用药频率+疗程"},{"value":"genenic+dosage+doseuom+instru+freq","text":"医嘱名称+剂量+剂量单位+服用方法+用药频率"},{"value":"genenic+dosage+doseuom","text":"医嘱名称+剂量+剂量单位"}]
var VitalsignsArr = [{"value":"WriteDate+temperature+pulse+breath+sysPressure+diaPressure","text":"采集时间+体温+脉搏+呼吸+收缩压+舒张压"},{"value":"WriteDate+temperature+pulse+breath+sysPressure","text":"采集时间+体温+脉搏+呼吸+收缩压"}]
var LisArr=[{"value":"LabEpisode+OrdItemName+AuthDateTime+PatName+freq","text":"检验号+医嘱名称+报告日期+姓名+申请日期"},{"value":"LabEpisode+OrdItemName+AuthDateTime+PatName","text":"检验号+医嘱名称+报告日期+姓名"}]
var PacsArr=[{"value":"ReqNo+strOrderName+strOrderDate","text":"申请单号+检查名称+申请日期"},{"value":"ReqNo+strOrderName","text":"申请单号+检查名称"}]
var AllergyArr=[{"value":"tag+Allergen+ALGItem+Status+OnsetDateText+LastUpdateUser+LastUpdateDate","text":"过敏类型+过敏源+过敏项目+状态+发作日期+最后更新用户+最后更新日期"},{"value":"tag+Allergen+ALGItem+Status+OnsetDateText","text":"过敏类型+过敏源+过敏项目+状态+发作日期"}]
var ComArr=""   //引用下拉
var comid=""   //引用datagrid id
$(function(){
	var frm = dhcadvdhcsys_getmenuform();
	
		if (frm) {
			frm.EpisodeID.value=4
	        EpisodeID = frm.EpisodeID.value;
	}

	initTab();
	
	//initCombox();
})
function initTab(){
	$('#phaTab').tabs({
	    onSelect:function(title){
			if(title=="检验"){
				initLis();
			}
			if(title=="检查"){
				initPacs();
			}
			if(title=="药物医嘱"){
				initOrder();
			}
			if(title=="生命体征"){
				initVitalsigns();
			}
			if(title=="药敏试验"){
				initAllergy();
			}
	    }
	});
}

///初始化医嘱tab签
function initOrder(){
		$("#OrderDatagrid").css("dispaly","block")
		ComArr=orderArr
		comid="#OrderDatagrid"
		//医嘱引用方式
		$HUI.combobox("#queryOrdType",{
			valueField:'value',
			textField:'text',
			panelHeight:"auto",
			editable:false,
			data:ComArr
		});
		$("#OrderReview").css("display","")
		initOrderDatagrid();
		
}
///初始化检验tab签
function initLis(){
		$("#LisDatagrid").css("dispaly","block")
		ComArr=LisArr
		comid="#LisDatagrid"
		//引用方式
		$HUI.combobox("#queryOrdType",{
			valueField:'value',
			textField:'text',
			panelHeight:"auto",
			editable:false,
			data:ComArr
		});

		$("#OrderReview").css("display","none")
		initLisDatagrid();
		
}
///初始化检查tab签
function initPacs(){
		$("#PacDatagrid").css("dispaly","block")
		ComArr=PacsArr
		comid="#PacDatagrid"
		//引用方式
		$HUI.combobox("#queryOrdType",{
			valueField:'value',
			textField:'text',
			panelHeight:"auto",
			editable:false,
			data:ComArr
		});
		$("#OrderReview").css("display","none")
		initPacDatagrid();
		
}
//生命体征
function initVitalsigns(){
		$("#VitalsignsDatagrid").css("dispaly","block")
		ComArr=VitalsignsArr
		comid="#VitalsignsDatagrid"
		//引用方式
		$HUI.combobox("#queryOrdType",{
			valueField:'value',
			textField:'text',
			panelHeight:"auto",
			editable:false,
			data:ComArr
		});

		$("#OrderReview").css("display","none")
		initVitalsignsDatagrid();
	
	}

//药敏试验
function initAllergy(){
		$("#AllergyDatagrid").css("dispaly","block")
		
		ComArr=AllergyArr
		comid="#VitalsignsDatagrid"
		//引用方式
		$HUI.combobox("#queryOrdType",{
			valueField:'value',
			textField:'text',
			panelHeight:"auto",
			editable:false,
			data:ComArr
		});

		$("#OrderReview").css("display","none")
		initAllergyDatagrid();
	}


///初始化医嘱datagrid
function initOrderDatagrid(){
		$HUI.datagrid('#OrderDatagrid',{
		    url:'dhcapp.broker.csp?ClassName=web.DHCCKBPHAAuxInfo&MethodName=GetAdmOrdList',
		    fit:true,
			autoSizeColumn:false,
			fitColumns:true,
			showFooter:true,			
			onBeforeLoad:function(param){
				var EpisodeIDs=EpisodeID  //$("#EpisodeID").val()
				param.EpisodeID=EpisodeIDs
				return param
			},
			fontSize:12,
		    columns:[[
		    	{field:'ck',title:'sel',checkbox:true,width:42},
		        {field:'startdate',title:'医嘱日期',width:88},
		        {field:'StartTime',title:'医嘱时间',width:78},
		        {field:'genenic',title:'医嘱名称',width:117},
		        {field:'dosage',title:'剂量',width:55},
		        {field:'doseuom',title:'剂量单位',width:78},
		        {field:'instru',title:'服用方法',width:78},
		        {field:'freq',title:'用药频率 ',width:78},
		        {field:'duration',title:'疗程 ',width:34},
		        {field:'orditm',title:'Oeori ',width:100,hidden:true}
		    ]]
		   
		  });	
}
// 查询医嘱
function QueryOrder()
{
	var orderCode = $("#orderCode").val();
	
	$('#OrderDatagrid').datagrid('load',{
		EpisodeID:EpisodeID, 
		orderCode:orderCode,
	}); 
}
//查询生命体征
function QueryVitalsigns(){
	$('#VitalsignsDatagrid').datagrid('load',{
				AEpisodeID:EpisodeID,
				AInterFace:"HIS",
				AItem:"WriteDate^temperature^pulse^breath^sysPressure^diaPressure^EpisodeDate^DeptDesc",
				AStDate:$("#VitalsignsStDate").datebox('getValue'),
				AEdDate:$("#VitalsignsEndDate").datebox('getValue')
	}); 

	}
// 查询检查
function QueryPac()
{
	var stdate= $("#PacStDate").datebox('getValue')	;
	var enddate= $("#PacEndDate").datebox('getValue')	;
	var params = EpisodeID+"^^"+stdate+"^"+enddate;
	$('#PacDatagrid').datagrid('load',{
		Params:params
	}); 
}

// 查询检验
function QueryLis()
{
	var stdate= $("#LisStDate").datebox('getValue')	;
	var enddate= $("#LisEndDate").datebox('getValue')	;
	var params = EpisodeID+"^^"+stdate+"^"+enddate;
	$('#LisDatagrid').datagrid('load',{
		Params:params
	}); 
}

// 查询药敏试验
function QueryAllergy()
{
	var orderCode = $("#AllergyCode").val();
	
	$('#AllergyDatagrid').datagrid('load',{
		EpisodeID:EpisodeID, 
		code:orderCode,
	}); 
}
///初始化检验datagrid
function initLisDatagrid(){
		$HUI.datagrid('#LisDatagrid',{
		    url:'dhcapp.broker.csp?ClassName=web.DHCCKBPHAAuxInfo&MethodName=JsonQryOrdListNew',
		    fit:true,
			autoSizeColumn:false,
			fitColumns:true,
			showFooter:true,			
			onBeforeLoad:function(param){
				var stdate= $("#LisStDate").datebox('getValue')	;
				var enddate= $("#LisEndDate").datebox('getValue')	;
				var params = EpisodeID+"^^"+stdate+"^"+enddate;
				param.Params=params
				return param
			},
			fontSize:12,
		    columns:[[
		    	{field:'ck',title:'sel',checkbox:true,width:42},
		        {field:'LabEpisode',title:'检验号',width:88},
		        {field:'OrdItemName',title:'医嘱名称',width:78},
		        {field:'AuthDateTime',title:'报告日期',width:117},
		        {field:'PatName',title:'姓名',width:55},
		        {field:'freq',title:'申请日期 ',width:78},
		        {field:'ResultStatus',title:'结果状态',width:78,formatter:ResultIconPrompt}
		        ]]
		   
		  });	
}


//结果图标显示
function ResultIconPrompt(value, rowData, rowIndex) {
	///(1登记，2初审，3审核，4复查，5取消审核，6作废，O其他)
    var mcStr="";
    if (value == "3") {
	    var paramList=rowData.VisitNumberReportDR;
	    if (rowData.TSResultAnomaly == "3") {
        	mcStr+="<a style='text-decoration:none;color:#FF83FA;' href='javascript:void(ReportView(\"" + rowData.PortUrl + "\"))';><span class='icon-absurb' color='red' title='荒诞结果')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>报告结果</a>";
	    }
	    if (rowData.TSResultAnomaly == "2") {
        	mcStr+="<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(\"" + rowData.PortUrl + "\"))';><span class='icon-panic' color='red' title='危急值结果')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>报告结果</a>";
	    }
	    if (rowData.TSResultAnomaly == "1") {
        	mcStr+="<a style='text-decoration:none;color:#FF7F00;' href='javascript:void(ReportView(\"" + rowData.PortUrl + "\"))';><span class='icon-abnormal' color='red' title='异常结果')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>报告结果</a>";
	    }
	    if (rowData.TSResultAnomaly == "0") {
        	mcStr+="<a style='text-decoration:none;color:blue' href='javascript:void(ReportView(\"" + rowData.PortUrl + "\"))';><span class='icon-normal' color='red' title='报告结果')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>报告结果</a>";
		}
    }
    
    if(rowData.HasBic=="1")
	{
		mcStr="<span style='color:red;'>菌</span>"+mcStr;
	}

    return mcStr;
}

///初始化检查datagrid
function initPacDatagrid(){
		$HUI.datagrid('#PacDatagrid',{
		    url:'dhcapp.broker.csp?ClassName=web.DHCCKBPHAAuxInfo&MethodName=GetLisInspectOrdNew',
		    fit:true,
			autoSizeColumn:false,
			fitColumns:true,
			showFooter:true,			
			onBeforeLoad:function(param){
				var stdate= $("#PacStDate").datebox('getValue')	;
				var enddate= $("#PacEndDate").datebox('getValue')	;
				var params = EpisodeID+"^^"+stdate+"^"+enddate;
				param.Params=params;
				return param
			},
			fontSize:12,
		    columns:[[
		    	{field:'ck',title:'sel',checkbox:true,width:42},
		    	{field:'lx',title:'类型',width:60,formatter:formatterlx},
		        {field:'ReqNo',title:'申请单号',width:88},
		        {field:'strOrderName',title:'检查名称',width:78},
		        {field:'strOrderDate',title:'申请日期',width:117},
		        {field:'Report',title:'报告',width:55,formatter:formatterPort},
		        {field:'Image',title:'图像',width:78,formatter:formatterImg},
		   		{ field: 'BlMorePort',align: 'center', title: '病理报告',formatter:formatterBlMorePort},
		        ]]
		   
		  });	
}
function ReportView(url) {
	window.open (url, "newwindow", "height=500, width=900, toolbar =no,top=100,left=200,, menubar=no, scrollbars=no, resizable=no, location=no, status=no") ;
	return false;
}

function formatterImg(value,rowData){	
	retStr = "<a href='#' title='' onclick='showImg(\""+rowData.ImgUrl+"\")'>"+value+"</span></a>"
	return retStr;	
}
///阅读图像
function showImg(url){
	if(url===""){
		$.messager.alert("提示","RIS报告平台没有配置图像阅读路径");	
		return false;
	}

	window.open (url, "newwindow", "height=550, width=950, toolbar =no,top=100,left=300,menubar=no, scrollbars=no, resizable=yes, location=no,status=no");
	return false;	
}

///阅读报告
function showReport(url){
	if(url===""){
		$.messager.alert("提示","RIS报告平台没有配置图像阅读路径");	
		return false;
	}
	
	//打开报告
	window.open (url, "newwindow", "height=550, width=950, toolbar =no,top=100,left=300,menubar=no, scrollbars=yes, resizable=yes, location=no,status=no");
	return false;
}

function formatterPort(value,rowData){
	var url="",params="";
	if(rowData.BLOrJC==0){}
	if(rowData.BLOrJC==1){}
	url=rowData.PortUrl
	if(rowData.PortUrl===""){
		url="";
	}
	retStr = "<a href='#' title='' onclick='showReport(\""+url+"\")'>"+value+"</span></a>"
	return retStr;	
}

function formatterlx(value,rowData){
	if(rowData.BLOrJC==0){
		return "检查";
	}
	
	if(rowData.BLOrJC==1){
		return "病理";
	}
}

function formatterBlMorePort(value,rowData){
	var url = rowData.PortUrl;
	url = url.replace("Rpt=1","Rpt=");  //病理查看多份报告
	retStr = "<a href='#' title='' onclick='showReport(\""+url+"\")'>"+value+"</span></a>"
	return retStr;	
}

function initVitalsignsDatagrid(){
	$HUI.datagrid('#VitalsignsDatagrid',{
		    url:'dhcapp.broker.csp?ClassName=web.DHCCKBPHAAuxInfo&MethodName=GetVitalsigns',
		    fit:true,
			autoSizeColumn:false,
			fitColumns:true,
			showFooter:true,			
			onBeforeLoad:function(param){
				param.AEpisodeID=EpisodeID;
				param.AInterFace="HIS";
				param.AItem="WriteDate^temperature^pulse^breath^sysPressure^diaPressure^EpisodeDate^DeptDesc"
				return param;
			},
			fontSize:12,
		    columns:[[
		    	{field:'ck',title:'sel',checkbox:true,width:42},
		    	{field:'WriteDate',title:'采集时间',width:130},
		        {field:'temperature',title:'体温',width:80},
		        {field:'pulse',title:'脉搏',width:80},
		        {field:'breath',title:'呼吸',width:80},
		        {field:'sysPressure',title:'收缩压',width:80},
		        {field:'diaPressure',title:'舒张压',width:80},
		        ]]
		   
		  });
	}
	
function initAllergyDatagrid(){
		$HUI.datagrid('#AllergyDatagrid',{
		    url:'dhcapp.broker.csp?ClassName=web.DHCCKBPHAAuxInfo&MethodName=QueryAllergyInfo',
		    fit:true,
			autoSizeColumn:false,
			fitColumns:true,
			showFooter:true,			
			onBeforeLoad:function(param){
				param.EpisodeID=EpisodeID;
				param.code="";
				return param;
			},
			fontSize:12,
		    columns:[[
		    	{field:'ck',title:'sel',checkbox:true,width:42},
		        {field:'Allergen',title:'过敏源',width:80},
		        {field:'ALGItem',title:'过敏项目',width:80},
		        {field:'Comments',title:'注释',width:80},
		        {field:'Status',title:'状态',width:80},
		        {field:'OnsetDateText',title:'发作日期',width:80},
		        {field:'LastUpdateUser',title:'最后更新用户',width:80},
		        {field:'LastUpdateDate',title:'最后更新日期',width:80},
		        {field:'tag',title:'过敏类型',width:80},
		        ]]
		   
		  });

	}
//医嘱引用
function getOrder(){
	var OrdType= $("#queryOrdType").combobox("getValue")
	var OrdTypeText= $("#queryOrdType").combobox("getText")
	if (OrdType=="") {
		$.messager.alert("提示","请选择引用方式!");
		return;	
	} 

	OrdType=OrdType.split("+")
	OrdTypeText=OrdTypeText.split("+")
	var rowsData = $(comid).datagrid('getSelections')
	if (rowsData.length=="0") {
		$.messager.alert("提示","请选择一条记录!");
		return;	
	} 
	var info="";
	for(var i=0;i<rowsData.length;i++){
		var lineInfo = "" // 行数据
		for(var j =0;j<OrdType.length;j++){
			var colume=OrdType[j]
			if(lineInfo==""){	
				lineInfo=OrdTypeText[j]+":"+rowsData[i][colume];
			}else{
				lineInfo=lineInfo+","+OrdTypeText[j]+":"+rowsData[i][colume];
				}
			
		}	
		if(info==""){
			info=lineInfo;
			}else{
			info=info+";"+lineInfo;
			
			}
	}
	window.clipboardData.setData('Text',info);
	$.messager.alert("提示","已引用，粘贴既可！");
}

//医嘱审核
function ipmonitor(){
	var url = "dhcpha.inpha.ipmonitor.csp"
	window.open (url, "newwindow", "height=550, width=950, toolbar =no,top=100,left=300,menubar=no, scrollbars=yes, resizable=yes, location=no,status=no");

	}
/// 添加获取病人菜单信息方法
function dhcadvdhcsys_getmenuform(){
	var frm = null;
	try{
		var win=top.frames['eprmenu'];
		if (win) {
			frm = win.document.forms['fEPRMENU'];
			if(frm) return frm;
		}
		//在新窗口打开的界面
		win = opener;
		if (win) {
			frm = win.document.forms['fEPRMENU'];
			if (frm) return frm;
		}
		win = parent.frames[0];
		if (win){
			frm = win.document.forms["fEPRMENU"];
			if (frm) return frm;
		}
		if (top){
			frm =top.document.forms["fEPRMENU"];
			if(frm) return frm
		}
	}catch(e){}
	return frm;
}