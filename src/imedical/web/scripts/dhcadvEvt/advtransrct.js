/// Description:输液反应专项报告单
/// Creator:lvpeng
/// CreateDate: 2017-12-18
var drugname="";
var url="dhcadv.repaction.csp";
var RepDate=formatDate(0); //系统的当前日期
$(document).ready(function(){
	InitButton();				// 初始化按钮
	ReportControl();			// 表单控制
	InitCheckRadio();
	CheckTimeorNum();  //时间校验
	InitReport(recordId);
	
})
function InitButton(){
	
	// 保存
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	
	// 提交
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
	})	
	/*$('#MedBut').on("click",function(){  //sufan 2019-06-24  标库要求格式统一,回车加载药品列表
		initMedModal();
	})*/
	
	$("input[id^='TransRctDrugInfo-']").live('keydown',function(e)
	{
		if(e.keyCode==13)
		{
			drugname=$(this).attr("name")
			initMedModal(this.id);
		}
	})
	if (RepStaus!=""){
		$("#PatOutcomBut").show(); //显示转归按钮		
		if(winflag==2){
			if(LocHeadNurEvaFlag=="1"){
				$("#LocHeadNurEvaBut").show(); // 根据配置显示评价按钮 2019-07-25 cy
			}
			if(NurDepEvaFlag=="1"){
				$("#NurDepEvaBut").show(); // 根据配置显示评价按钮 2019-07-25 cy
			}
		} 
	}
	var LocHeadNurEvaId=GetAssessRecordID("LocHeaNurEvaluate"); 
	if(LocHeadNurEvaId!=""){
		$("#LocHeadNurEvaBut").show();
	}
   	$("#LocHeadNurEvaBut").on("click",function(){ 
		showAssessmentWin("LocHeaNurEvaluate",LocHeadNurEvaId);
	})
	// 护理部评价
	var NurDepEvaId=GetAssessRecordID("NurDepEvaluate");  
	if(NurDepEvaId!=""){
		$("#NurDepEvaBut").show();
	}
	$("#NurDepEvaBut").on("click",function(){ 
		showAssessmentWin("NurDepEvaluate",NurDepEvaId);
	})
	/// 转归界面
	$("#PatOutcomBut").on("click",function(){ 
		showPatOutcomWin("PatOutcomform");
	})
}
// 表单控制
function ReportControl(){
	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	//单选框按钮事件
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	// 输注日期控制
	chkdate("TransRctLiqInfuDate","TransRctLiqInfuTime");
	// 穿刺日期控制
	chkdate("TransRctPunDate");

	// 药业培养送检部门时间 控制
	chkdate("TransRctMedDepDate","TransRctMedDepTime");
	
	// 导管尖端培养送检部门 时间控制
	chkdate("TransRctCatheterDate","TransRctCatheterTime");
}
//页面初始加载checkbox,radio控制子元素不可以填写
function InitCheckRadio(){
	// 患者的临床表现 皮疹 勾选 无
	if($('#TransRctCliniMan-94148-94149').is(':checked')){
		$('#TransRctCliniMan-94148-94150-94153').nextAll(".lable-input").val("");
		$('#TransRctCliniMan-94148-94150-94153').nextAll(".lable-input").hide();
	}
	// 药液培养送检部门 是否勾选
	if($('#TransRctLiqMedDep-94242').is(':checked')){
		RepSetRead("TransRctMedDepDate","datebox",0);
		RepSetRead("TransRctMedDepTime","input",0);
	}else{
		RepSetRead("TransRctMedDepDate","datebox",1);
		RepSetValue("TransRctMedDepDate","datebox","");
		RepSetValue("TransRctMedDepTime","input","");
		RepSetRead("TransRctMedDepTime","input",1);
	}
	// 导管尖端培养送检部门  是否勾选
	if($('#TransRctCatheterDep-94246').is(':checked')){
		RepSetRead("TransRctCatheterDate","datebox",0);
		RepSetRead("TransRctCatheterTime","input",0);
	}else{
		RepSetRead("TransRctCatheterDate","datebox",1);
		RepSetValue("TransRctCatheterDate","datebox","");
		RepSetValue("TransRctCatheterTime","input","");
		RepSetRead("TransRctCatheterTime","input",1);
	}
	
	
}

//初始化液体配制窗口
function initMedModal(id){
    if(EpisodeID==""){
	   $.messager.alert('Warning',$g('请先选择患者就诊记录！'));
	   return;
	}
	var gridTotalId=$('#TransRctDrugInfo').next().attr("id");
	var $tr=$("#"+gridTotalId).find("ul > li >div >table >tbody").children("tr");
	if($tr.length==0){
	   $.messager.alert('Warning',$g('请先点击【药品信息】里【增加】按钮添加一行！'));
	   return;	
	}
	GetGridMedWin(id);	 //"admnogridMed"
}

function GetGridMedWin(id){
	var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
	var mycols=[[
		{field:"orditm",title:'orditm',width:90,hidden:false},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'incidesc',title:$g('名称'),width:140},
		{field:'genenic',title:$g('通用名'),width:140},
	    {field:'batno',title:$g('生产批号'),width:70,hidden:false},
	    {field:'staDate',title:$g('开始日期'),width:60,hidden:true},
	    {field:'endDate',title:$g('结束日期'),width:60,hidden:false},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'dosage',title:$g('剂量'),width:60},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'instru',title:$g('用法'),width:80},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freq',title:$g('频次'),width:40},//priorty
		{field:'priorty',title:$g('优先级'),width:60},//priorty
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'duration',title:$g('疗程'),width:40},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'apprdocu',title:$g('批准文号'),width:140},
		{field:'manf',title:$g('厂家'),width:140},
		{field:'manfdr',title:'manfdr',width:80,hidden:true},
		{field:'form',title:$g('剂型'),width:80},
		{field:'formdr',title:'formdr',width:80,hidden:true}
	]];
	var mydgs = {
		url:'dhcadv.repaction.csp'+'?action=GetPatOEInfo'+'&params='+EpisodeID+'&instrutype='+'DZ' ,
		columns: mycols,  //列信息
		pagesize:10,  //一页显示记录数
		table: "#admnogridmed", //grid ID
		field:'orditm', //记录唯一标识
		params:null,  // 请求字段,空为null
		tbar:null, //上工具栏,空为null
	}
	var rownum=id.split(".")[1];
	var win=new CreatMyDiv(input,$("input[id^='TransRctDrugInfo-'][id$='."+rownum+"']"),"drugsfollower","1000px","335px","admnogridmed",mycols,mydgs,"","",addDrgTest);	
	win.init();	
}

//添加药品
function addDrgTest(rowData)
{   

	if(rowData==""){
		return;	
	}
    var row = rowData;
    var gridTotalId=$('#TransRctDrugInfo').next().attr("id");
      var $tr =$("#"+gridTotalId).find("ul > li >div >table >tbody").children("tr");
      if($tr.length>=1){
	      var num=0;
	      var flag=0; //判断是否有空行
	      $.each($tr,function(index){drugname
			  //var $td =$("#"+gridTotalId).find("ul > li >div >table >tbody >tr:eq("+index+")").children("td"); //为了给默认的第一行赋值  //sufan 2019-6-25 改成用name定位到具体行，这样不能修改已添加行数据
			   var $td =$("input[name='"+drugname+"'][type=input]").parent().parent().children('td'); 
			  //if(GetIfNullFlag()==0){
					//$.messager.alert('Warning','请添加一行用来存放数据！');
	   				//return false;		  
			  //}
			  
			  //if(($td.eq(0).find("input").val()=="")){ //sufan 2019-06-24 去掉该判断
				  $td.eq(0).find("input").val(row.genenic+"/["+row.form+"]"); //通用名称（含剂型）
			      $td.eq(1).find("input").val(row.dosage+"/"+row.instru+"/"+row.freq); //用法用量
			      $td.eq(2).find("input").val(row.manf);  //生产厂家
			      $td.eq(3).find("input").val(row.batno);
			      $td.eq(4).find(".combo-value").val(row.endDate); //结束日期
			      $td.eq(4).find(".combo-text").val(row.endDate); //结束日期  
			      num=1;
			      //return false;
			  //}
			   
    
		  })
	  }  
}

function GetIfNullFlag(){
	var flag=0;
	var gridTotalId=$('#TransRctDrugInfo').next().attr("id");
	var $tr =$("#"+gridTotalId).find("ul > li >div >table >tbody").children("tr");	
	 if($tr.length>=1){
		$.each($tr,function(index){
			var $td =$("#"+gridTotalId).find("ul > li >div >table >tbody >tr:eq("+index+")").children("td"); //为了给默认的第一行赋值
			if($td.eq(0).find("input").val()==""){
				flag=1;	
			}	
		})	 
	}
	return flag;
}

//加载报表病人信息
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
	$("#from").form('validate'); 
	InitCheckRadio();

}
//加载报表默认信息
function InitReport(recordId)
{    
   InitReportCom(recordId);
	if((recordId=="")||(recordId==undefined)){
	}else{
		//病人信息
    	$("#from").form('validate');			
	} 
}

//报告保存
function SaveReport(flag)
{
	if($('#PatName').val()==""){
		$.messager.alert($g("提示:"),$g("患者姓名为空，请输入登记号或病案号回车选择记录录入患者信息！"));	
		return false;
	}
	///保存前,对页面必填项进行检查
	if(!(checkRequired())){
		return;
	}
	var msg=checkTableRequired();
	if(msg!=""){
		return;
	}
	SaveReportCom(flag);
}



//分类显示
function doOther(obj){
}

//时间 数字校验
function CheckTimeorNum(){
	//时间输入校验
	//液体输注时间
	chktime("TransRctLiqInfuTime","TransRctLiqInfuDate");
	//药液培养送检部门时间
	chktime("TransRctMedDepTime","TransRctMedDepDate");
	//导管尖端培养送检部门时间
	chktime("TransRctCatheterTime","TransRctCatheterDate");	
	
	// 数字输入校验
	// 液体输注过程
	chknum("TransRctLiqConfig",1,1);
	// P 脉搏
	chknum("PatientStatus-94856-94858-94863",0);
	chknum("PatientStatus-94856-94871-94877",0);
	// R 呼吸
	chknum("PatientStatus-94856-94858-94866",0);
	chknum("PatientStatus-94856-94871-94880",0);
	// SpO2
	chknum("PatientStatus-94856-94858-94869",1,1,100);
	chknum("PatientStatus-94856-94871-94883",1,1,100);
	// BP
	checkBP("PatientStatus-94856-94858-94860");
	checkBP("PatientStatus-94856-94871-94874");
	
}
//检查table中的必填
function checkTableRequired(){
	var errMsg=""
	
	$("#TransRctDrugInfo").next().find("tbody tr").each(function(i){
		var rowMsg=""
		// 药物通用名称
		var str=$(this).children('td').eq(0).find("input").val();
		if(str.length==0){
			rowMsg=rowMsg+"药物通用名称,"
		}
		// 用法用量
		var str1=$(this).children('td').eq(1).find("input").val();
		if(str1.length==0){
			rowMsg=rowMsg+"用法用量,"
		}
		
		if(rowMsg!=""){
			errMsg=errMsg+"\n"+rowMsg+"不能为空."
		}	
	
	})
	if(errMsg!=""){
		$.messager.alert($g("提示:"),errMsg);
	}
	return errMsg;
}
