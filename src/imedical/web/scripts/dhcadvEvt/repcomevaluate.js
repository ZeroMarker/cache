/// Description: 报告评价追踪记录单  
/// Creator: congyue
/// CreateDate: 2020-01-10
var EvaRecordId="",LinkRecordId="",WinCode="",AuditList="",CancelAuditList="",StaFistAuditUser="",StsusGrant="",RepStaus="";
var userName="";
var AssessFlag="",LocHeadNurEvaFlag="",NurDepEvaFlag=""; ///评价按钮标识，科护士长评价按钮标识，护理部评价按钮标识
var EvaFlagList=""; /// 评价标识串  评价按钮标识^科护士长评价按钮标识^护理部评价按钮标识 
$(document).ready(function(){
	EvaRecordId=getParam("recordId");  //表单类型id
	LinkRecordId=getParam("LinkRecordId");  //关联表单记录ID
	AuditList=getParam("AuditList");  //审核串
	CancelAuditList=getParam("CancelAuditList");  //撤销审核串
	StaFistAuditUser=getParam("StaFistAuditUser");  //第一审批人
	StsusGrant=getParam("StsusGrant");  //审核标识
	RepStaus=getParam("RepStaus");  //报告状态
	WinCode=getParam("code");  //关联表单记录code
	EvaFlagList=getParam("EvaFlagList");  //评价标识串
	reportControl();			// 表单控制  	
	InitButton();				// 初始化按钮
	CheckTimeornum();  //时间校验
	InitCheckRadio();//加载界面checkboxradio在父元素没有勾选的情况下，子元素不可勾选，填写
});

// 表单控制
function reportControl(){
	$("#left-nav").hide();
	$("#anchor").hide();
	$("#gotop").hide();
	$("#gologin").hide();
	$("#footer").hide();
	$("#assefooter").show();
	$("#from").css({
		"margin-left":"20px",
		"margin-right":"20px"
	});
	$('#AuditMessage').hide(); //2018-06-12 cy 审批信息隐藏
	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			InitCheckRadio();
			setManImprove()
		});
	})
	//单选框按钮事件
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			InitCheckRadio();
			setManImprove()
		});
	});
	// 会议日期控制
	chkdate("MeetDate","MeetTime");
	add_event();
	var Caserow=0
	var CaseList=$('#CaseImprovement').val().split("\n")
	var Caselen=CaseList.length;
	for(i=0;i<Caselen;i++){
		Caserow=Caserow+parseInt(CaseList[i].length/50)+1;
	}
	var Caseheightlen=(Caserow)*18;
	if($('#CaseImprovement').val()!=""){
		$("#CaseImprovement").css({
			"height":Caseheightlen
		});
	}
	//参会人员 
	$('#Participants').css({
		"width":800,
		"max-width":800
	});
	RepSetRead("Participants","input",1);	
	//名称
	$('#ManaImprovement-94378-94951').css({
		"width":300,
		"max-width":300
	});
	//个案改进不可编辑
	$("#CaseImprovement").attr("readonly",'readonly');
	$("body").click(function(){
		AllStyle("textarea","",100);
  		InitLabInputText(".lable-input");
		$(".mytext").bind('input propertychange ',function(){
	    	setManImprove();
	 	});
	 	$(".mytext").blur('input propertychange ',function(){
	    	setManImprove();
	 	});
	})
	 setTimeout(function(){ //延时点击body
        $("body").click();
    },500)	
	$(".lable-input").css('width','100px');
	$(".lable-input").css('max-width','100px');
	var EvaData=EvaFlagList.replace(/(^\s*)|(\s*$)/g,"").split("^");
	AssessFlag=EvaData[0];
	LocHeadNurEvaFlag=EvaData[1];
	NurDepEvaFlag=EvaData[2];
	if(EvaRecordId!=""){ 
		// 添加按钮隐藏 
		$('#ParPantsAddBut').hide();
		//科室不良事件分析 不可编辑
		$("#HeadNurCauseAnalysis-panel input").attr("readonly",'readonly');
		$("#HeadNurCauseAnalysis-panel textarea").attr("readonly",'readonly');
		$("#MeetDate").datebox({"disabled":true});
		$("#HeadNurCauseAnalysis-panel input[type=checkbox]").attr("disabled",true); 
		//整改措施 不可编辑
		$("#Recmeasure-panel input").attr("readonly",'readonly');
		$("#CaseImprovement").attr("readonly",'readonly');
		$("#Recmeasure-panel textarea").attr("readonly",'readonly');
		$("#Recmeasure-panel input[type=checkbox]").attr("disabled",true); 
		//现场工作评价追踪记录  不可编辑
		$("[id^='HeadNurEvaluate-94387-']").each(function(){
			var rowid=this.id.split(".")[0];
			var rownum=this.id.split(".")[1];
			if ((this.value!="")){
				$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				$("input[id^='"+rowid+"'][id$='"+rownum+"']").datebox({"disabled":true});
				$('a:contains('+$g("删除")+')').parent().hide();
			}
			if(AssessFlag!="Y"){
				$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				$("input[id^='"+rowid+"'][id$='"+rownum+"']").datebox({"disabled":true});
				$('a:contains('+$g("增加")+')').parent().hide();
			}
		})	
	}

}
//按钮控制与方法绑定
function InitButton(){
	$("#AsseSaveBut").on("click",function(){
		SaveAsse(0);
	})
	//参会人员 添加按钮事件
	$('#ParPantsAddBut').on("click",function(){
		StaffEnter();
	})
	$('#Find').bind("click",QueryName);   //点击查询
   	$('#Add').bind("click",MemAdd);     //点击添加，将勾选的人员添加到输入框 参会人员
}

function setManImprove()
{
    var list="",PersonFactorCom="",DiviceFactorCom="",GoodsFactorCom="",ManaFactorCom="",EnvirFactorCom="",OthFactorCom="";
    var i=0,j=0,k=0,l=0,h=0,m=0;
    var PersonFactorComlist="",DiviceFactorComlist="",GoodsFactorComlist="",ManaFactorComlist="",EnvirFactorComlist="",OthFactorComlist=""; 
	$("input[id^='PersonFactorCom']").each(function(){  
		if($(this).is(':checked')){                
			if(this.id.indexOf("PersonFactorCom-99762")>=0){ // 患者及家属	
				i=i+1;
				PersonFactorCom=i+"、"+$g("患者及家属")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonFactorComlist=PersonFactorComlist+PersonFactorCom;
			}
			if(this.id.indexOf("PersonFactorCom-99763")>=0){     //护士
				i=i+1;	
				PersonFactorCom=i+"、"+$g("护士")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonFactorComlist=PersonFactorComlist+PersonFactorCom;
			} 
			if(this.id.indexOf("PersonFactorCom-99764")>=0){ //医生因素	
				i=i+1;
				PersonFactorCom=i+"、"+$g("医生因素")+"："+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonFactorComlist=PersonFactorComlist+PersonFactorCom
			}
		}
	});
	if(PersonFactorComlist!=""){
		list=list+"\n"+$g("人：人员因素")+"\n"+PersonFactorComlist;
	}

	$("input[id^='DiviceFactorCom']").each(function(){
		if($(this).is(':checked')){
			j=j+1;
			DiviceFactorCom=j+"、"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			DiviceFactorComlist=DiviceFactorComlist+DiviceFactorCom;
		}
	});	
	if(DiviceFactorComlist!=""){
		list=list+"\n"+$g("机：设备因素")+"\n"+DiviceFactorComlist;
	}
		
	$("input[id^='GoodsFactorCom']").each(function(){
		if($(this).is(':checked')){
			k=k+1;
			GoodsFactorCom=k+"、"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			GoodsFactorComlist=GoodsFactorComlist+GoodsFactorCom;
		}
	});
	if(GoodsFactorComlist!=""){
		list=list+"\n"+$g("物：物品因素")+"\n"+GoodsFactorComlist;
	}
	
	$("input[id^='ManaFactorCom']").each(function(){
		if($(this).is(':checked')){
			l=l+1;
			ManaFactorCom=l+"、"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			ManaFactorComlist=ManaFactorComlist+ManaFactorCom;
		}
	});
	if(ManaFactorComlist!=""){
		list=list+"\n"+$g("法：方法、政策、管理因素")+"\n"+ManaFactorComlist;
	}
	
	$("input[id^='EnvirFactorCom']").each(function(){
		if($(this).is(':checked')){
			h=h+1;
			EnvirFactorCom=h+"、"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			EnvirFactorComlist=EnvirFactorComlist+EnvirFactorCom;
		}
	});
	if(EnvirFactorComlist!=""){
		list=list+"\n"+$g("环：环境因素")+"\n"+EnvirFactorComlist;
	}
	
	$("input[id^='OthFactorCom']").each(function(){
		if($(this).is(':checked')){
			m=m+1;
			OthFactorCom=m+"、"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			OthFactorComlist=OthFactorComlist+OthFactorCom;
		}
	});
	if(OthFactorComlist!=""){
		list=list+"\n"+$g("其他：其他因素")+"\n"+OthFactorComlist;
	}
	var Caserow=0
	var CaseList=list.split("\n")
	var Caselen=CaseList.length;
	for(i=0;i<Caselen;i++){
		Caserow=Caserow+parseInt(CaseList[i].length/50)+1;
	}
	var Caseheightlen=(Caserow)*18;
	$("#CaseImprovement").css({
		"height":Caseheightlen
	});
	$('#CaseImprovement').val(list)
	
}
//报告评价保存
function SaveAsse(flag)
{
	///保存前,对页面必填项进行检查
	if(!(checkRequired()&&checkother())){
		return;
	}
	runClassMethod("web.DHCADVFormRecord","SaveRecord",
		{'user':LgUserID,
		 'formId':$("#formId").val(),
		 'formVersion':$("#formVersion").val(),
		 'par':loopStr("#from"),
		 'recordId':EvaRecordId,
		 'linkRecordId':LinkRecordId
		 },
		function(datalist){ 
			var data=datalist.replace(/(^\s*)|(\s*$)/g,"").split("^");
			EvaRecordId=data[1]
			if (data[0]=="0") {
				window.parent.closeRepWindow();
				window.parent.location.reload();// 2018-11-20 cy 保存报告后，刷新父界面
				if(flag==1){
					window.parent.SetRepInfo(data[1],WinCode);
					window.parent.parent.CloseWinUpdate();
					window.parent.parent.Query();
				}
			}else{
				return;
			}
		},"text")
	
}
//校验
function checkother(){
	
	//管理改进  ManaImprovement-94378-96091
	var ManaImprovementoth=0;
	$("input[type=checkbox][id^='ManaImprovement']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.96082'][class='lable-input']").val()=="")){
				ManaImprovementoth=-1;
			}
			if((this.value==$g("制度、流程及规范制定或修订"))){
				if(!($("#ManaImprovement-94378-94949").is(':checked'))&&!($("#ManaImprovement-94378-94950").is(':checked'))){
					ManaImprovementoth=-2;
				}
				if($("input[id='ManaImprovement-94378-94951']").val()==""){
					ManaImprovementoth=-2;
				}
			}
		}	
	})
	if(ManaImprovementoth==-2){
		$.messager.alert($g("提示:"),"【"+$g("管理改进")+"】"+$g("勾选")+$g('制度、流程及规范制定或修订')+"，"+$g("请勾选和填写内容")+"！");	
		return false;
	}
	if(ManaImprovementoth==-1){
		$.messager.alert($g("提示:"),"【"+$g("管理改进")+"】"+$g("勾选")+$g('其他')+"，"+$g("请填写内容")+"！");	
		return false;
	}
	
	return true;
}
//页面初始加载checkbox,radio控制子元素不可以填写
function InitCheckRadio(){
	
	//管理改进  制度、流程及规范制定或修订  名称  填写名称自动勾选制度、流程及规范制定或修订，取消勾选时，名称为空
	if($("input[type=checkbox][id='ManaImprovement-94378']").is(':checked')){
		if($("#ManaImprovement-94378-94951").val()==""){
			$("#ManaImprovement-94378-94951").attr("readonly",false);
		}
	}else{
		$("#ManaImprovement-94378-94951").val("");
		$("input[type=radio][id^='ManaImprovement-94378-']").removeAttr("checked");
	}
	$("#ManaImprovement-94378-94951").bind("blur",function(){
		if($("#ManaImprovement-94378-94951").val()!=""){
			$("input[type=checkbox][id='ManaImprovement-94378']").prop("checked",true) ;
		}
	})
	if($("input[type=radio][id^='ManaImprovement-94378-']").is(':checked')){
		$("input[type=checkbox][id='ManaImprovement-94378']").prop("checked",true) ;
	}
	
	
}

function add_event(){
	AllStyle("textarea","",100);
	chkTableDate("HeadNurEvaluate-94387-94393-94398");
	//督查时间控制
	/*$("input[id^='HeadNurEvaluate-94387-94393-94398']").each(function(){
		if((this.id.split("-").length==4)){
			var datevalue=$("input[id^='"+this.id+"']").datebox("getValue");
			$("input[id='"+this.id+"']").datebox().datebox('calendar').calendar({
				validator: function(date){
					var now = new Date();
					return date<=now;
				}
			});
			$("input[id^='"+this.id+"']").datebox("setValue",datevalue);
		}
	}) */
	
}

//确认审批  2018-04-24
function FormConfirmAudit()
{	
	if(!(checkRequired()&&checkother())){
		return;
	} 
	runClassMethod("web.DHCADVCOMMONPART","AuditMataReport",{'params':AuditList},
	function(jsonString){ 
		if(jsonString.ErrCode < 0){
			$.messager.alert("提示:","审核错误,错误原因:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"第"+errnum+"条数据"
			return;
		}
		if(jsonString.ErrCode == 0){
			SaveAsse(1);
		}
	},"json",false);
	
}
//撤销审批 2018-04-24
function FormCancelAuditBt()
{	
	if ((StaFistAuditUser!="")&(StaFistAuditUser!=LgUserName)){
		$.messager.alert("提示:","报告为驳回报告，且未驳回给当前登录人，无权限撤销审核！");
		return;
	}
	//保存数据
	runClassMethod("web.DHCADVCOMMONPART","CancelAuditReport",{'params':CancelAuditList},
	function(jsonString){ 
		if(jsonString.ErrCode < 0){
			$.messager.alert("提示:","撤销审核错误,错误原因:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"第"+errnum+"条数据"
			return;
		}
		if(jsonString.ErrCode == 0){
			SaveAsse(1);
		}
	},"json",false);
		
}
//时间 数字校验
function CheckTimeornum(){
	//时间输入校验
	//晨会时间  sufan 2019-06-18 表单统一去掉晨会部分
	/*chktime("MornRepMeetTime");*/
	//会议时间
	chktime("MeetTime","MeetDate");
	
	chkTableDate("LocHeadNurEvaluate"); //hxy 2020-03-19 st
	$("a[onclick*='addRow']").click(function(){
		chkTableDate("LocHeadNurEvaluate");
	}); //ed	
	
}
//人员回车事件加载窗口
function StaffEnter()
{
	$('#staffwin').show();
	$('#staffwin').window({
		title:$g('科室人员信息'),
		collapsible:false, //true, //hxy 2020-03-18 st
		minimizable:false,
		maximizable:false, //ed
		border:false,
		closed:"true",
		modal:true,
		width:500,
		height:400
	}); 
	/*var scrollTop=$('body').scrollTop(); //hxy 2020-03-22 chrome st
	$("body").css("height",scrollTop);
	$('#staffwin').panel('resize',{ 
		top:scrollTop+((screen.availHeight-400)/4)
	}); //ed
	*/
    $('#staffwin').window('open');
    $("#UserNames").val("");
    $('#MonAdd').hide();// 添加晨会人员按钮隐藏
    InitStaffGrid() ;      
}

//初始化科室人员列表
function InitStaffGrid()
{
	//定义columns
	var columns=[[
	     {field:"ck",checkbox:'true',width:40},
		 {field:'userCode',title:$g('用户Code'),width:100},
		 {field:'userName',title:$g('用户姓名'),width:100}
		]];
	
	//定义datagrid
	$('#user').datagrid({
		url:'dhcadv.repaction.csp'+'?action=GetStaff&Input='+LgCtLocID,
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:200,  // 每页显示的记录条数
		pageList:[200,400],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true,
		selectOnCheck:true,
		onUnselect:function(rowIndex, rowData)
		{
			userName=$("#UserNames").val();
			var name =rowData.userName
             if(userName.indexOf(name) != -1)
             {
	             userName=userName.replace(name+"，","")
	             $("#UserNames").val(userName);
             }
		},
		 onSelect:function(rowIndex, rowData)
		 {
	       var userName = rowData.userName
	       MeetMember(userName)
		 },onLoadSuccess:function(data){  
			if(userName!=""){
				for(var i=0;i<data.rows.length;i++){
					var Name = data.rows[i].userName+"，";
					if(userName.indexOf(Name)>=0){
						$("#user").datagrid("selectRow",i);
					}
				}
			}
		}
	});	
	$("#UserNames").val($("#Participants").val()); /// 给弹出的人员窗口里面人员赋值(表单的参会人员)
	$(".datagrid-header-check input[type=checkbox]").on("click",function(){ ///2018-04-13 cy 评价界面
		AllMember();
	})
}
function AllMember(){
	var rows = $("#user").datagrid('getSelections');
	if(rows.length==0){
		$("#UserNames").val("");
	}
	var userNames="";
	for(var i=0;i<rows.length;i++){
		if(userNames==""){
			userNames=rows[i].userName+"，";
		}else{
			userNames=userNames+rows[i].userName+"，";
		}
		
	}
	$("#UserNames").val(userNames);
	//MeetMember(userNames) ;
}
//查询
function QueryName()
{
	//1、清空datagrid 
	$('#user').datagrid('loadData', {total:0,rows:[]}); 
	//2、查询
	var UserName=$("#UserName").val();
	var params=UserName+"^"+LgCtLocID;
	$('#user').datagrid({
		url:'dhcadv.repaction.csp'+'?action=GetStaff',
		queryParams:{
		Input:params}	
	});
}

//添加到参会人员
function MemAdd()
{
  userName=$("#UserNames").val()
  $("#Participants").val(userName)	
  $('#staffwin').window('close');
}
//添加到晨会人员
function MonAdd()
{
  userName=$("#UserNames").val()
  $("#MornRepMeetpants").val(userName)	
  $('#staffwin').window('close');
}
//选择参会人员
function MeetMember(name)
{
	if(name==""){
	  $("#UserNames").val("");
	}
	userName=$("#UserNames").val();
    if(userName.indexOf(name) != -1){
	    return true;  
    }
	if(userName==""){
	  userName=name+"，";
	}else{
	  userName=userName+name+"，";
	}
	$("#UserNames").val(userName);		
}
///处理护理不良事件评价原因分析勾选因素所填写的改进措施   如果input值为改进措施：  则返回""
function getInputValue(id){
	var inputvalue=getHideInputValue(id);
	if(inputvalue=="无"){
		inputvalue="";
	}
	if((inputvalue!="无")&&(inputvalue!="")){
		inputvalue=$g("整改措施：")+inputvalue;
	}
	return inputvalue;
	
}
