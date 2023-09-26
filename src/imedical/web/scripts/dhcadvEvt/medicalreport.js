/// Creator: LiangQiang congyue(修改)
/// CreateDate: 2015-09-06
/// Description:医疗不良事件报告
var url="dhcadv.repaction.csp";
var patSexArr = [{ "value": "1", "text": "男" }, { "value": "2", "text": "女" },{ "value": "3", "text": "不详" }];
var adrRepID="",EpisodeID="",patientID="",editFlag="",ID="",assessID="";
var adrCurStatusDR="",adrInitStatDR="";
var ReportTypeCode="med" ;
var adrNextLoc="";adrLocAdvice="";adrReceive="";
var LocDr="";UserDr="";ImpFlag="", patIDlog="";
var adrDataList="",RepUser="",RepDept="";
var frmflag=0;//是否获取病人列表标志 0 获取，1 不获取
var winflag=0; //窗口标志 0 填报窗口  1 修改窗口 2016-10-10
document.write('<script type="text/javascript" src="../scripts/dhcadvEvt/cmcommon.js"></script>');
$(function(){
	patientID=getParam("patientID");
	EpisodeID=getParam("EpisodeID");
    adrRepID=getParam("adrRepID");
	editFlag=getParam("editFlag");
    satatusButton=getParam("satatusButton");
    frmflag=getParam("frmflag"); //2016-09-28
    assessID=getParam("assessID"); //评估id
	if ((adrRepID=="")&&(frmflag==0)){
	    var frm = dhcsys_getmenuform();
		if (frm) {
			var papmi = frm.PatientID.value;		
	        var adm = frm.EpisodeID.value;
		    //var papmi=getRegNo(papmi);
	        $.ajax({
		   	   type: "POST",
		       url: url,
		       async: false, //同步
		       data: "action=getPatNo&patID="+papmi,
		       success: function(val){
			      	 papmi=val;
		       }
		    });	    
		    EpisodeID=adm;
		    patientID=papmi;
	        InitPatientInfo(papmi,adm);//获取病人信息
	        if((papmi!="")&(adm!="")){
				$('#PatID').attr("disabled","true");  ///2017-07-20 bianshuai 设置病人ID不可编辑
	        }

		}
	}
	//判断输入的病人ID是否为数字 2016-10-10
	$('#PatID').bind("blur",function(){
	   var	PatID=$('#PatID').val()	
	   if(isNaN(PatID)){
		    $.messager.alert("提示:","请输入数字！");
		   }
	})
    $('#PatID').bind('keydown',function(event){

		 if(event.keyCode == "13")    
		 {
			 var medrptPatID=$('#PatID').val();
			 if (medrptPatID=="")
			 {
				 	$.messager.alert("提示:","病人id不能为空！");
					return;
			 }
			 var medrptPatID=getRegNo(medrptPatID);
			if ((patIDlog!="")&(patIDlog!=medrptPatID)&(adrRepID=="")){
				$.messager.confirm("提示", "信息未保存,是否继续操作", function (res) {//提示是否删除
					if (res) {
						//location.reload();
						//window.location.href="dhcadv.medicalreport.csp?adrDataList='+''";//刷新传参adrDataList为空
						ReloadJs();//刷新传参adrDataList为空
					}else{
						$('#PatID').val(patIDlog);
					$('#admdsgrid').datagrid({
						url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+patIDlog 
					})				
					}
				})
			}
			if ((patIDlog!="")&(patIDlog!=medrptPatID)&(adrRepID!="")){
				ReloadJs();//刷新传参adrDataList为空
			}
			 var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
			 var mycols = [[
			 	{field:'Adm',title:'Adm',width:60}, 
			 	{field:'AdmLoc',title:'就诊科室',width:220}, 
			 	{field:'AdmDate',title:'就诊日期',width:80},
			 	{field:'AdmTime',title:'就诊时间',width:80},
			 	{field:'RegNo',title:'病人id',width:80}
			 ]];
			 var mydgs = {
				 url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+medrptPatID ,
				 columns: mycols,  //列信息
				 pagesize:10,  //一页显示记录数
				 table: '#admdsgrid', //grid ID
				 field:'Adm', //记录唯一标识
				 params:null,  // 请求字段,空为null
				 tbar:null //上工具栏,空为null
				}
			 var win=new CreatMyDiv(input,$("#PatID"),"drugsfollower","650px","335px","admdsgrid",mycols,mydgs,"","",SetAdmTxtVal);	
			 win.init();
		}
	});

	//性别
	$('#PatSex').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		editable:false,
		//data:patSexArr
		url:url+'?action=SelSex'
	});
	//病区 2017-08-01 cy 修改 下拉框传递参数检索
	$('#PatWard').combobox({
		//panelHeight:"auto",  //设置容器高度自动增长
		mode:'remote',  //必须设置这个属性
		onShowPanel:function(){ 
			$('#PatWard').combobox('reload',url+'?action=SelwardDesc')
		}
		
	});
	
	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
		});
	});

	//复选框分组
	InitUIStatus();
	
	
	//当  事件报告类型为医疗时，显示隐藏的暂存提交按钮
	$('#RT10').click(function(){
		var buttondiv=document.getElementById("buttondiv");
		if ($(this).is(':checked')) {
			buttondiv.style.display='inline';
		} else {
			buttondiv.style.display='none';
		}   
	});	
	//当  事件报告类型为输血不良事件时，显示隐藏的暂存提交按钮
	$('#RT15').click(function(){
		var buttondiv=document.getElementById("buttondiv");
		if ($(this).is(':checked')) {
			buttondiv.style.display='inline';
		} else {
			buttondiv.style.display='none';
		}   
	});	

	InitAdrInfo(adrRepID);
	InitAdrReport(adrRepID);
	InitPatientInfo(patientID,EpisodeID);
	
	$('#AF1').click(function(){  //非上报人不能操作匿名  qunianpeng 2016/11/15 
		var checkStaus=$(this).is(':checked');
		if(adrRepID==""){
			 CheckUser(checkStaus);
		}else if(RepUser == LgUserName){  
				 CheckUser(checkStaus);
		}else{
			$.messager.alert("提示:","非上报人不能修改匿名");
			$("#AF1").attr("checked",!checkStaus);
		}			
	});  
})


///当选中匿名时，隐藏报告人和报告部门	qunianpeng 2016/11/15 
function CheckUser(checkStaus){
	if(checkStaus) {
		$("#adrRepUser").val(""); 
		$("#adrRepDept").val(""); 
	}else{
		$("#adrRepUser").val(RepUser); 
		$("#adrRepDept").val(RepDept); 
	}  
}

///初始化界面复选框事件
function InitUIStatus()
{
	var tmpid="";
	$("input[type=checkbox]").click(function(){
		tmpid=this.id;
		if($('#'+tmpid).is(':checked')){
			$("input[type=checkbox][name="+this.name+"]").each(function(){
				if((this.id!=tmpid)&($('#'+this.id).is(':checked'))){
					$('#'+this.id).removeAttr("checked");
					setCheckBoxRelation(this.id);
				}
			})
		}
		setCheckBoxRelation(this.id);
	});
}

/// 保存不良事件报告
function saveAdrEventReport(flag)
{

	///保存前,对页面必填项进行检查
	if((flag)&&(!saveBeforeCheck())){
		return;
	}
	//事件报告类别
	var adrRepType="";
    $("input[type=checkbox][name=adrRepType]").each(function(){
		if($(this).is(':checked')){
			adrRepType=this.value;
		}
	})
	if(adrRepType==""){
		$.messager.alert("提示:","【事件报告类别】不能为空！");
		return;
	}
	ReportTypeCode=adrRepType;
	GetStatus(adrRepID,ReportTypeCode); //获取初始状态
	var adrNo=$('#adrNo').val();		//报告编码
	var adrPatSex=$('#PatSex').combobox('getValue');	//性别
	var  PatName=$('#PatName').val();	//姓名
	if(PatName==""){
	  $.messager.alert("提示:","请输入患者ID,选择相应就诊");
		return;
	}
	var adrPatAge=$('#PatAge').val();	//年龄
	var adrPatJob=""	//职别
	var adrAdmDate=""	//诊疗日期
	var adrAdmTime=""	//诊疗时间
	var adrLiveLoc=""	//现场相关科室
	var adrResult=""	//不良后果
	var adrResultDesc=""	//不良后果描述
	//事件过程描述
	var adrProcDesc=$('#adrProcessDesc').val();
	var adrLevel="";//事件等级
	//存在隐患
	var adrReason=$('#adrReason').val();
	//改进建议  处理情况
	var AdrHandInfo=$('#adrHandInfo').val();
	var adrAdvice=""	//处理意见
	var adrImprovie=""	//改进情况
	
	var adrRepUserCareer=""	//报告人职业
    //上报人职业类别
	var adrPartyType="";
	$("input[type=checkbox][name=reppepletype]").each(function(){
		if($(this).is(':checked')){
			adrPartyType=this.value;
		}
	})
	//上报人职称
    var adrCarPrvTp="";
	$("input[type=checkbox][name=repCarPrv]").each(function(){
		if($(this).is(':checked')){
			adrCarPrvTp=this.value;
		}
	})
	//报告人姓名
	var adrRepUser=$('#adrRepUser').val();
    adrRepUser=UserDr;

	//报告人部门
	var adrRepDept=$('#adrRepDept').val();
	adrRepDept=LocDr;
    //联系电话
	var adrRepTel=$('#ReportUserTel').val();

	//联系邮箱
	var adrEmail=$('#ReportUserEml').val();
	
	//病人ID
	var adrPatID=$('#PatID').val();
	if (adrPatID != patientID.replace(/[\'\"\\\/\b\f\n\r\t]/g, '')){
		$.messager.alert("提示:","【病人ID】和页面病人信息不符,请核实后重试！");
		return;
	}
	if(adrPatID==""){
		$.messager.alert("提示:","【病人ID】不能为空！");
		return;
	}
    //事件发生地点
	var adrPlace="";
    $("input[type=checkbox][name=adrplace]").each(function(){
		if($(this).is(':checked')){
			adrPlace=this.value;
		}
	})
	
	//报告时间  adrRepDate
	var adrCreateDatetime=$('#adrRepDate').datetimebox('getValue');  
	var adrCreateDate="",adrCreateTime="";
	if(adrCreateDatetime!=""){
		adrCreateDate=adrCreateDatetime.split(" ")[0];  //报告日期
		adrCreateTime=adrCreateDatetime.split(" ")[1];  //报告时间
	}
	if(!compareSelTimeAndCurTime(adrCreateDate)){
		$.messager.alert("提示:","【报告时间】不能大于当前时间！");
		return false;	
	}
	//var adrCurStatusDR=""	//当前状态
	var adrRemark=""	//备注
	
	//事件发生地点其它
	var adrPlaceOth=$('#adrPlaceOth').val(); 
	//匿名标志	
	var adrAnonymFlag="";
    $("input[type=checkbox][name=adrAnonymFlag]").each(function(){
		if($(this).is(':checked')){
			adrAnonymFlag=this.value;
		}
	})
	
	//事件发生日期
	var adrTimeDateOccu=$('#adrOccDate').datetimebox('getValue');
	var adrDateOccu="",adrTimeOccu="";
	if(adrTimeDateOccu!=""){
		adrDateOccu=adrTimeDateOccu.split(" ")[0];  //事件发生日期
		adrTimeOccu=adrTimeDateOccu.split(" ")[1];  //事件发生时间
	}
	if(!compareSelTimeAndCurTime(adrDateOccu)){
		$.messager.alert("提示:","【发生日期】不能大于当前时间！");
		return false;	
	}  
	var adrRepImpFlag="N"; //重点关注
	if(ImpFlag==""){ 
		adrRepImpFlag=adrRepImpFlag;
	}else{
		adrRepImpFlag=ImpFlag;
	}
	var adrAdmNo=EpisodeID;
	if(flag==1){
		adrCurStatusDR=adrInitStatDR;  //初始状态
	}
    //var adrRepAuditList="" ;
	//if(flag==1){
	var adrRepAuditList=adrCurStatusDR+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+adrNextLoc+"^"+adrLocAdvice+"^"+adrReceive+"^"+ReportTypeCode;
	//}
	var repdatalist=adrNo+"^"+adrPatSex+"^"+adrPatAge+"^"+adrPatJob+"^"+adrAdmDate+"^"+adrAdmTime+"^"+adrLiveLoc;
	var repdatalist=repdatalist+"^"+adrResult+"^"+adrResultDesc+"^"+adrProcDesc+"^"+adrLevel+"^"+adrReason;
	var repdatalist=repdatalist+"^"+AdrHandInfo+"^"+adrAdvice+"^"+adrImprovie+"^"+adrRepUserCareer+"^"+adrPartyType;
	var repdatalist=repdatalist+"^"+adrCarPrvTp+"^"+adrRepUser+"^"+adrRepDept+"^"+adrRepTel+"^"+adrEmail;
	var repdatalist=repdatalist+"^"+adrPatID+"^"+adrPlace+"^"+adrCreateDate+"^"+adrCreateTime+"^"+adrCurStatusDR;
	var repdatalist=repdatalist+"^"+ReportTypeCode+"^"+adrRemark+"^"+adrPlaceOth+"^"+adrAnonymFlag+"^"+adrRepImpFlag+"^"+adrAdmNo+"^"+adrDateOccu+"^"+adrTimeOccu;
	
	var param="adrRepID="+adrRepID+"&adrRepDataList="+repdatalist+"&adrRepAuditList="+adrRepAuditList+"&flag="+flag ;
	//alert(param);
	//数据保存/提交
	var  mesageShow=""
	if(flag==0){
		mesageShow="保存"
	}
	if(flag==1){		
		mesageShow="提交"		
	}
	$.messager.confirm("提示", "是否进行"+mesageShow+"数据", function (res) {//提示是否保存
		if (res) {
    		$.ajax({
   	   			type: "POST",
       			url: url,
       			data: "action=saveMedReport&"+param,
       			success: function(val){
					var medrArr=val.replace(/(^\s*)|(\s*$)/g,"").split("^");
					if (medrArr[0]=="0") {
						$.messager.alert("提示:",mesageShow+"成功!");
						adrRepID=medrArr[1];
						if(winflag==1){
							 window.parent.CloseWinUpdate();
						}
						InitAdrReport(adrRepID);//获取编码信息  qunianpeng 16/09/29 Update
						winflag=0; //2017-05-24
						var adrRepType="";
					    $("input[type=checkbox][name=adrRepType]").each(function(){
							if($(this).is(':checked')){
								adrRepType=this.value;
							}
						})
						if(adrRepType=="bldevent"){
							var rflag=confirm('如该不良事件同时伴发输血不良反应，请再填写输血不良反应报告表')
				    		if (rflag==true){ 
				    			adrRepType="blood";
								showRepTypeWin(adrRepType);   
				       			 return true;   
				    		}
						}
						if(flag==1){
							$("[name=adrRepType]:checkbox").attr("disabled",true);//报告类型不可勾选
							$("#buttondiv").hide(); //2017-05-24
						}
						if(editFlag!=0){
							window.parent.Query();
						}
					}else{
		  	 			if(val==-1){
							$.messager.alert("提示:","无权限");	
						}else if(val==-2){
							$.messager.alert("提示:","已是最后一个权限");	
						}else if(val==-3){
							$.messager.alert("提示:","无授权工作流");	
						}else if(val==-4){
							$.messager.alert("提示:","无配置子项");	
						}else{
							$.messager.alert("提示:","出错"+val);
						}
		  			}
				},
				error: function(val){
					alert('链接出错');
					return;
				}
			});
		}
	});
}

//加载报表信息
function InitAdrReport(adrRepID)
{

	if(adrRepID==""){return;}
	//var assessment=document.getElementById("assessment");
	//assessment.style.display='inline';  //评估按钮显示
	//assessment.style.display=''; 
   	var params=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+ReportTypeCode;
	winflag=1; //2016-10-10
	//获取报表信息
 	$.ajax({
   	   type: "POST",
       url: url,
       async: false, //同步 2017-05-24
       data: "action=GetMedRepInfo&adrRepID="+adrRepID+"&params="+params,
       success: function(val){
	        var tmp=val.split("!");
			$('#adrNo').val(tmp[0]);    //报告编码
			$('#adrNo').attr("disabled","true");
			$('#PatSex').combobox('setValue',tmp[1]);     //性别
			$('#PatAge').val(tmp[2]);    //年龄
		    $('#PatAge').attr("disabled","true");
			//$('#PatJob').val(tmp[3]);    //职业
			//$('#PatAdmDate').datetimebox("setValue",tmp[4]+" "+tmp[5]); //就诊日期
			//$('#RepLiveLoc').val(tmp[6]); //在场相关人员 
            //$('#ret'+tmp[7]).attr("checked",true); //不良结果
			//if(tmp[7]=="11"){
				//$('#adrresultdesc').val(tmp[8]);  //不良结果描述
				//$('#adrresultdesc').attr("disabled",false);
			//}
			$('#adrProcessDesc').val(tmp[9]);    //事件过程描述
			$('#adrlevel'+tmp[10]).attr("checked",true);  //不良事件等级
			$('#adrReason').val(tmp[11]);    //存在隐患  导致事件的可能原因
			$('#adrHandInfo').val(tmp[12]);    //改进建议  事件处理情况
	
            //$('#adrAdvice').val(tmp[13]); //意见陈述
            //$('#adrImprovie').val(tmp[14]); //改进措施
			//$('#ty'+tmp[15]).attr("checked",true); //报告人职业
			$('#ty'+tmp[16]).attr("checked",true);   //上报人职业类别
            $('#prv'+tmp[17]).attr("checked",true); //上报人职称
	
			$('#adrRepUser').val(tmp[18]);    //报告人姓名
			RepUser=tmp[18];
			$('#adrRepUser').attr("disabled","true");
            $('#adrRepDept').val(tmp[19]); //报告部门
            RepDept=tmp[19];
            $('#adrRepDept').attr("disabled","true");
			$('#ReportUserTel').val(tmp[20]); //联系电话
            $('#ReportUserEml').val(tmp[21]); //联系email
	      	$('#PatID').val(tmp[22]);    //病人ID
			patientID = tmp[22];
			$('#adrRepDate').datetimebox({disabled:true});
			if(tmp[24]!=""||tmp[25]!=""){
				$('#adrRepDate').datetimebox("setValue",tmp[24]+" "+tmp[25]); //报告日期
			}
			ReportTypeCode=tmp[27];
			adrCurStatusDR=tmp[26]
			//$('#adrRepRemark').val(tmp[28]); //备注
            $('#PL'+tmp[23]).attr("checked",true); //事件发生地点
			$('#adrPlaceOth').val(tmp[29]); //事件发生场所 其它 
			if(tmp[23]=="15"){
				$('#adrPlaceOth').attr("disabled",false);
			}
						
			$('#PatDiag').val(tmp[30]); //临床诊断 
			$('#PatNo').val(tmp[31]); //病案号 
			$('#PatName').val(tmp[36]); //病人姓名 
			
			adrInitStatDR=tmp[32];
			adrNextLoc=tmp[33];
			adrLocAdvice=tmp[34];
			adrReceive=tmp[35];
			UserDr=tmp[37];
			LocDr=tmp[38];
			ImpFlag=tmp[42];//重要标记
			EpisodeID=tmp[43];//就诊ID	
			if(tmp[44]!=""||tmp[45]!=""){
				$('#adrOccDate').datetimebox('setValue',tmp[44]+" "+tmp[45]); //事件发生日期
			}
			$('#AF'+tmp[39]).attr("checked",true);  //匿名
			if(tmp[39]=="1"){
				$('#adrRepUser').val("");    //报告人姓名
            	$('#adrRepDept').val(""); //报告部门
			}
			$('#PatWard').combobox('setValue',tmp[40]);     //病区ID
			$('#PatWard').combobox('setText',tmp[46]);     //病区描述
			//报告类别
			if (tmp[41]=="med"){
            	$('#RT'+"10").attr("checked",true); 
            	var buttondiv=document.getElementById("buttondiv");
				buttondiv.style.display='inline';
				//判断按钮是否隐藏
				if (satatusButton==1) {
					buttondiv.style.display='none';
	            }
            }
			if (tmp[41]=="bldevent"){
            	$('#RT'+"15").attr("checked",true); //报告类别
            	var buttondiv=document.getElementById("buttondiv");
				buttondiv.style.display='inline';
				//判断按钮是否隐藏
				if (satatusButton==1) {
					buttondiv.style.display='none';
	            }
            }
			$("[name=adrRepType]:checkbox").attr("disabled",true);//报告类型不可勾选
            
            
         
			if (adrCurStatusDR==""){
				adrCurStatusDR=adrCurStatusDR;
				adrReceive="";
			}else{
				adrInitStatDR=tmp[26];
				//adrReceive="1";
				if(((UserDr==LgUserID)&&(adrReceive=="2"))||(UserDr!=LgUserID)){
					adrReceive="1";
				}
			}
			//2017-06-12 报告已评估，不可修改
			if(assessID!=""){
				$("#savebt").hide();
				$("#submitdiv").hide();
			}
			if (tmp[26]!=""){  //如果有提交状态
				$('#submitdiv').hide();//隐藏提交按钮
				//获取评估权限标志 2016-10-19
				var Assessflag=GetAssessAuthority(adrRepID,params);
				if (Assessflag=="Y"){
					$('#assessment').show(); //显示评估按钮 
				}
			}
			$('#clearbt').hide();//隐藏清空按钮
			
	   } ,
       error: function(){
	       alert('链接出错');
	       return;
	   }
	});
}

//加载报表默认信息
function InitAdrInfo(adrRepID)
{
   if(adrRepID!=""){return;}
   var params=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+ReportTypeCode;
   $.ajax({
   type: "POST",
   url: url,
   data:"action=getMedInfo&params="+params,
   success: function(val){
		if(val==-1){
			$.messager.alert("提示:","请先配置工作流与权限,然后填报！");
	       return;
		}else{
			var tmp=val.split("^");
			//$('#adrNo').val(tmp[0]);    //报告编码
			$('#adrNo').attr("disabled","true");
			$('#adrRepDate').datetimebox({disabled:true});
			$('#adrRepDate').datetimebox("setValue",tmp[1]);   //报告日期
			//adrInitStatDR=tmp[2];  //报表的初始化,状态 
			//ReportTypeCode=tmp[3];  // 报告填报类型
			$('#adrRepUser').val(LgUserName);    //报告人姓名
			$('#adrRepUser').attr("disabled","true");
			$('#adrRepDept').val(tmp[4]);     //报告人部门
			$('#adrRepDept').attr("disabled","true");
	
			LocDr=LgCtLocID;
			UserDr=LgUserID;
			RepUser=LgUserName;
		    RepDept=tmp[4];
	   }
   }})
}

function GetStatus(adrRepID,ReportTypeCode)
{
	if(adrRepID!=""){return;}
	var params=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+ReportTypeCode;
	$.ajax({
		type: "POST",
		url: url,
		async: false, //同步
		data:"action=getMedInfo&params="+params,
		success: function(val){
			var tmp=val.split("^");
			adrInitStatDR=tmp[2];  //报表的初始化,状态 
			ReportTypeCode=tmp[3];  // 报告填报类型
		}
	})
}
//加载报表病人信息
function InitPatientInfo(patientID,EpisodeID)
{
	if((patientID=="")||(EpisodeID=="")){return;}
	$.ajax({
		type: "POST",
		url: url,
		data: "action=getRepPatInfo&PatNo="+patientID+"&EpisodeID="+EpisodeID,
		success: function(val){
	    	var tmp=val.split("^");
			//病人信息
			$('#PatID').val(tmp[0]); //病人ID
			$('#PatName').val(tmp[1]); //病人姓名
			$('#PatName').attr("disabled","true");
			$('#PatSex').combobox({disabled:true});
			$('#PatSex').combobox('setValue',tmp[2]);  //性别
			$('#PatAge').val(tmp[4]);  //年龄
			$('#PatAge').attr("disabled","true");
			$('#PatNo').val(tmp[5]); //病案号
			$('#PatNo').attr("disabled","true");
			//$('#PatAdmDate').datebox({disabled:'true'});
			//$('#PatAdmDate').datebox("setValue",tmp[24]);  //诊疗日期
			//$('#PatAdmDate').datetimebox({disabled:'true'});
			//$('#PatAdmDate').datetimebox("setValue",tmp[24]+" "+tmp[23]);  //诊疗日期
           	$('#PatDiag').val(tmp[10]);  //诊断
			$('#PatDiag').attr("disabled","true");
           	$('#PatWard').combobox('setValue',tmp[12]);  //病区ID
           	$('#PatWard').combobox('setText',tmp[11]);  //病区描述
			patIDlog=$('#PatID').val();
		}
	})
}

//在.js中新增function
function SetAdmTxtVal(rowData)
{
	EpisodeID=rowData.Adm;
	if(EpisodeID==undefined){
		EpisodeID=""
	}
	patientID=$('#PatID').val();
	patientID=getRegNo(patientID);
	InitPatientInfo(patientID,EpisodeID);
	
	//InitPatientInfo(EpisodeID);
}
//保存前,进行数据完成性检查
function saveBeforeCheck()
{
	//事件报告类别
	var adrRepType="";
    $("input[type=checkbox][name=adrRepType]").each(function(){
		if($(this).is(':checked')){
			adrRepType=this.value;
		}
	})
	if(adrRepType==""){
		$.messager.alert("提示:","【事件报告类别】不能为空！");
		return false;
	}
	var adrNo=$('#adrNo').val();		//报告编码
	var adrPatSex=$('#PatSex').combobox('getValue');	//性别
	if(adrPatSex==""){
		$.messager.alert("提示:","【病人性别】不能为空！");
		return false;
	}
	var adrPatAge=$('#PatAge').val();	//年龄
	if(adrPatAge==""){
		$.messager.alert("提示:","【病人年龄】不能为空！");
		return false;
	}
	//事件过程描述
	var adrProcDesc=$('#adrProcessDesc').val();
	if(adrProcDesc==""){
		$.messager.alert("提示:","【事件过程描述】不能为空！");
		return false;
	}else if(adrProcDesc.length>300){
		var beyond=adrProcDesc.length-300;
		$.messager.alert("提示","【事件过程描述】超出"+beyond+"个字");
		return false;
	}
	
	//存在隐患
	var adrReason=$('#adrReason').val();
	if(adrReason==""){
		$.messager.alert("提示:","【存在隐患】不能为空！");
		return;
	}else if(adrReason.length>300){
		var beyond=adrReason.length-300;
		$.messager.alert("提示","【存在隐患】超出"+beyond+"个字");
		return false;
	}
	//改进建议  处理情况
	var AdrHandInfo=$('#adrHandInfo').val();
	if(AdrHandInfo==""){
		$.messager.alert("提示:","【改进建议】不能为空！");
		return false;
	}else if(AdrHandInfo.length>300){
		var beyond=AdrHandInfo.length-300;
		$.messager.alert("提示","【改进建议】超出"+beyond+"个字");
		return false;
	}
	
	//病人ID
	var adrPatID=$('#PatID').val();
	if(adrPatID==""){
		$.messager.alert("提示:","【病人ID】不能为空！");
		return false;
	}
	return true;
}

//页面关联设置
function setCheckBoxRelation(id){
	
	if($('#'+id).is(':checked')){	
		//事件发生地点其他
		if(id=="PL15"){
			$('#adrPlaceOth').attr("disabled",false);
		}
		//事件报告类型
		if(id=="RT11"||id=="RT12"||id=="RT13"||id=="RT14"){
			var adrRepType="";
			var buttondiv=document.getElementById("buttondiv");
			var medhidinfo=document.getElementById("medhidinfo");
			$("input[type=checkbox][name=adrRepType]").each(function(){
				if($(this).is(':checked')){
					adrRepType=this.value;
					buttondiv.style.display='none';
					medhidinfo.style.display='none';
				}
			})
			if ((patientID!="")&(EpisodeID!="")){
				showRepTypeWin(adrRepType);	
			}else{
	      	 	$.messager.alert("提示:","病人id不能为空!");
				$("[name=adrRepType]:checkbox").prop("checked",false);
	       		return;
			}

		}
		//事件报告类型
		if(id=="RT10"||id=="RT15"){
			var adrRepType="";
			var buttondiv=document.getElementById("buttondiv");
			var medhidinfo=document.getElementById("medhidinfo");
			$("input[type=checkbox][name=adrRepType]").each(function(){
				if($(this).is(':checked')){
					adrRepType=this.value;
					buttondiv.style.display='inline';
					medhidinfo.style.display='inline';
				}
			})
		}
		//匿名
		if(id=="AF1"){ //注释 qunianpeng 2016/11/15
		//	$("#adrRepUser").val(""); 
		//	$("#adrRepDept").val(""); 
		}
	}else{
		//取消事件发生地点其他
		if(id=="PL15"){
			$('#adrPlaceOth').val("");
			$('#adrPlaceOth').attr("disabled",true);
		}

	}
}

//编辑窗体(评估)
 function assessmentRep()
{
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:'报告评估',
		collapsible:true,
		border:false,
		closed:"true",
		width:900,
		height:500
	});
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.repmanage.csp?RepID='+adrRepID+'&RepType='+ReportTypeCode+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
}
function closeRepWindow(assessID)   //wangxuejian 2016-10-09      关闭评估窗口
{   
	//2017-06-12 报告已评估，不可修改
	if(assessID!=""){
		$("#savebt").hide();
		$("#submitdiv").hide();
	}
	$('#win').window('close');
}
	
//编辑窗体
function showRepTypeWin(adrRepType)
{
	if($('#winds').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="winds"></div>');
	$('#winds').window({
		title:'不良事件报告',
		collapsible:true,
		border:false,
		closed:"true",
		width:1300,
		height:600,
		onBeforeClose:function(){
			child.window.RepNoRepet();
			var repnoflag=$('#repnoflag').val();
			if (repnoflag==0){	
	 			var rflag=confirm('未保存，确认关闭窗口吗？')
	    		if (rflag==true){    
	       			 return true;   
	    		}else{
		    		return false;
		    	}
	    	} 
		}
	});
		
	adrDataList=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+adrRepType;
 	if(adrRepType=="material"){
		var iframe='<iframe name="child" scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.matareport.csp?patientID='+patientID+'&EpisodeID='+EpisodeID+'&adrDataList='+adrDataList+'"></iframe>';
		$('#winds').html(iframe);
		$('#winds').window('open');
	}
	if(adrRepType=="drugerr"){
		var iframe='<iframe name="child" scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.medsafetyreport.csp?patientID='+patientID+'&EpisodeID='+EpisodeID+'&adrDataList='+adrDataList+'"></iframe>';
		$('#winds').html(iframe);
		$('#winds').window('open');
 	} 
	if(adrRepType=="blood"){
		var iframe='<iframe name="child" scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.bloodreport.csp?patientID='+patientID+'&EpisodeID='+EpisodeID+'&adrDataList='+adrDataList+'"></iframe>';
		$('#winds').html(iframe);
		$('#winds').window('open');
	}
	if(adrRepType=="drug"){
		var iframe='<iframe name="child" scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.advreport.csp?patientID='+patientID+'&EpisodeID='+EpisodeID+'&adrDataList='+adrDataList+'"></iframe>';
		$('#winds').html(iframe);
		$('#winds').window('open');
	}
}
//2016-10-10
function CloseWin(){
		$('#winds').window('close');
}
//刷新界面 2016-09-26
function ReloadJs(){
	window.location.href="dhcadv.medicalreport.csp?frmflag="+"1";//刷新传参adrDataList为空
}			
