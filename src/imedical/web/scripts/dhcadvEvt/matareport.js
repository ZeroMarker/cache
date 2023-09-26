
/// Creator: congyue
/// CreateDate: 2015-09-22
///  Descript: 器械不良反应报告

var url="dhcadv.repaction.csp";
var patSexArr = [{ "val": "1", "text": "男" }, { "val": "2", "text": "女" },{ "val": "3", "text": "不详" }];
var editRow="";matadrID="";patientID="";EpisodeID="";editFlag="";adrDataList="",assessID="";
var MatadrInitStatDR="";mataReportType="";matadrCurStatusDR="";
var medadrNextLoc="";medadrLocAdvice="";medadrReceive="";
var CurRepCode="material"; ImpFlag="", patIDlog="";
var frmflag=0; //是否获取病人列表标志 0 获取，1 不获取
var winflag=0; //窗口标志 0 填报窗口  1 修改窗口 2016-10-10
document.write('<script type="text/javascript" src="../scripts/dhcadvEvt/cmcommon.js"></script>');
$(function(){
	patientID=getParam("PatientID");
	EpisodeID=getParam("EpisodeID");
	matadrID=getParam("matadrID");
	editFlag=getParam("editFlag");
	adrDataList=getParam("adrDataList");
	satatusButton=getParam("satatusButton");
    frmflag=getParam("frmflag");
    assessID=getParam("assessID"); //评估id
	if ((adrDataList=="")&&(matadrID=="")&&(frmflag==0)){
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
	        getMataRepPatInfo(papmi,adm);//获取病人信息
	        if((papmi!="")&(adm!="")){
				$('#PatNo').attr("disabled","true");  ///2017-07-20 bianshuai 设置病人ID不可编辑
	        }
		}
	}
    //判断按钮是否隐藏
	var buttondiv=document.getElementById("buttondiv");
	if (satatusButton==1) {
	  buttondiv.style.display='none';
	}
	//判断输入的病人ID是否为数字 2016-10-10
	 $('#PatNo').bind("blur",function(){
	   var	matadrPatNo=$('#PatNo').val();
	   if(isNaN(matadrPatNo)){
		    $.messager.alert("提示:","请输入数字！");
	    }
	})
	//病人登记号回车事件
	$('#PatNo').bind('keydown',function(event){
		 if(event.keyCode == "13")    
		 {
			 var matadrPatNo=$('#PatNo').val();
			 if (matadrPatNo=="")
			 {
				 	$.messager.alert("提示:","病人id不能为空！");
					return;
			 }
			 var matadrPatNo=getRegNo(matadrPatNo);
			if ((patIDlog!="")&(patIDlog!=matadrPatNo)&(matadrID=="")){
				$.messager.confirm("提示", "信息未保存,是否继续操作", function (res) {//提示是否删除
					if (res) {
						//location.reload();
						//window.location.href="dhcadv.matareport.csp?adrDataList='+''";//刷新传参adrDataList为空
						ReloadJs();//刷新传参adrDataList为空
					}else{
						$('#PatNo').val(patIDlog);
					$('#admdsgrid').datagrid({
						url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+patIDlog 
					})				
					}
				})
			}
			if ((patIDlog!="")&(patIDlog!=matadrPatNo)&(matadrID!="")){
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
				 url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+matadrPatNo ,
				 columns: mycols,  //列信息
				 pagesize:10,  //一页显示记录数
				 table: '#admdsgrid', //grid ID
				 field:'Adm', //记录唯一标识
				 params:null,  // 请求字段,空为null
				 tbar:null //上工具栏,空为null
				}
			 var win=new CreatMyDiv(input,$("#PatNo"),"drugsfollower","650px","335px","admdsgrid",mycols,mydgs,"","",SetAdmTxtVal);	
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
	 
	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			setCheckBoxRelation(this.id);
		});
	});
	
	//复选框分组
	InitUIStatus();
	//当事件结果为死亡时，显示隐藏的时间框
	
	 $("input[type=checkbox][name=matadrResult]").click(function(){
		if($(this).is(':checked')){
			var matadrResult=this.value;
			var matadrEventResultDate=document.getElementById("deathdate");
			if (matadrResult==10) {
				matadrEventResultDate.style.display='inline';
			} else {
				matadrEventResultDate.style.display='none';
			}  
		}
	})
	$('#TR10').click(function(){
		var matadrEventResultDate=document.getElementById("deathdate");
		
		if ($(this).is(':checked')) {
			matadrEventResultDate.style.display='inline';
		} else {
			matadrEventResultDate.style.display='none';
		}   
	}); 
	InitMataReport(matadrID);  //获取报告信息
	InitPatientInfo(matadrID,adrDataList);//获取页面默认信息
	getMataRepPatInfo(patientID,EpisodeID);//获取病人信息
	
	//editFlag状态为0,隐藏提交和暂存按钮
	if(editFlag=="0"){
		$("a:contains('提交')").css("display","none");
		$("a:contains('暂存')").css("display","none");
	}
	
})

// 文本编辑格
var texteditor={
	type: 'text',//设置编辑格式
	options: {
		required: true //设置编辑规则属性
	}
}

// 日期编辑格
var dateboxditor={
	type: 'datebox',//设置编辑格式
	options: {
		//required: true //设置编辑规则属性
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

/// 保存可疑医疗器械不良事件报告表
function saveMataEventReport(flag)
{

	///保存前,对页面必填项进行检查
	if((flag)&&(!saveBeforeCheck())){
		return;
	}
	
	//1、报告日期
	var matadrCreateDate=$('#matadrCreateDate').datetimebox('getValue');   
	var matadrCreateDateResult="",matadrCreateTimeResult="";
	if(matadrCreateDate!=""){
		matadrCreateDateResult=matadrCreateDate.split(" ")[0];  //报告日期
		matadrCreateTimeResult=matadrCreateDate.split(" ")[1];  //报告时间
	}
	//2、报告编码
	var matadrNo=$('#matadrNo').val();
	matadrNo=matadrNo.replace(/[ ]/g,""); //去掉编码中的空格
	//A、病人信息
	//病人ID
	var matadrPatID=$('#PatID').val();
	
	//病人登记号
	var matadrPatNo=$('#PatNo').val();
	if(matadrPatNo==""){
		$.messager.alert("提示:","【病人登记号】不能为空！");
		return;
	}
	//病人姓名
	var matadrName=$('#PatName').val();
	if(matadrName==""){
	  $.messager.alert("提示:","请输入患者ID,选择相应就诊");
		return;
	}
    //病人性别
	var matadrSex=$('#PatSex').combobox('getValue');
    //病人年龄
	var matadrAge=$('#PatAge').val();  
	//预期治疗疾病或作用
	var matadrExpectEff=$('#matadrExpectEff').val();  
	//诊疗日期
	var matadrAdmDate=$('#matadrAdmDate').datetimebox('getValue');   
	var matadrAdmDateResult="",matadrAdmTimeResult="";
	if(matadrAdmDate!=""){
		matadrAdmDateResult=matadrAdmDate.split(" ")[0];  //诊疗日期
		matadrAdmTimeResult=matadrAdmDate.split(" ")[1];  //诊疗时间
	}
	
	//B.不良事件情况
	var matadrMainExp=$('#matadrMainExp').val();  //事件主要表现
	//1.事件发生日期
	var matadrAdrDate=$('#matadrAdrDate').datebox('getValue');   
	//2.发现或者知悉时间
	var matadrDiscDate=$('#matadrDiscDate').datebox('getValue');   
	//3.医疗器械实际使用场所
	var matadrUsePlace="";
	var matadrUsePlaceOth="";
    $("input[type=checkbox][name=matadrUsePlace]").each(function(){
		if($(this).is(':checked')){
			matadrUsePlace=this.value;
		}
	})
	matadrUsePlaceOth=$('#matadrUsePlaceOth').val();
	//4.事件后果
	var matadrResult="";
	var matadrEventResultDate="";
	var matadrDeathDate="",matadrDeathTime="";
     $("input[type=checkbox][name=matadrResult]").each(function(){
		if($(this).is(':checked')){
			matadrResult=this.value;
		}
	})
	if(matadrResult=="10"){
		matadrEventResultDate=$('#matadrEventResultDate').datetimebox('getValue'); 
		if(matadrEventResultDate==""){
			$.messager.alert("提示:","事件后果为【死亡】,请填写死亡时间！");
			return ;
		}else{
			matadrDeathDate=matadrEventResultDate.split(" ")[0];  //死亡日期
			matadrDeathTime=matadrEventResultDate.split(" ")[1];  //死亡时间
		}
	}		
	
	//5.事件陈述
	var matadrEventDesc=$('#matadrEventDesc').val();
	
	//C.医疗器械情况
	var matadrProName=$('#matadrProName').val();  //产品名称
	var matadrInciName=$('#matadrInciName').val();  //商品名称
	var matadrRegNo=$('#matadrRegNo').val();  //注册证号
	var matadrManf=$('#matadrManf').val();  //生产企业名称
	var matadrManfAddress=$('#matadrManfAddress').val();  //生产企业地址
	var matadrManfTel=$('#matadrManfTel').val();  //企业联系电话
	var matadrSpec=$('#matadrSpec').val();  //型号规格
	var matadrProCode=$('#matadrProCode').val();  //产品编号
	var matadrProBatNo=$('#matadrProBatNo').val();  //产品批号

	//1.操作人
	var matadrOperator="";
	var matadrOperatorOth="";
    $("input[type=checkbox][name=matadrOperator]").each(function(){
		if($(this).is(':checked')){
			matadrOperator=this.value;
		}
	})
	matadrOperatorOth=$('#matadrOperatorOth').val();
	//2.生产日期
	var matadrProDate=$('#matadrProDate').datebox('getValue');   
	//3.有效期至
	var matadrExpDate=$('#matadrExpDate').datebox('getValue');   
	//4.植入日期(若植入)
	var matadrUseDate=$('#matadrUseDate').datebox('getValue');   
	//5.停用日期
	var matadrDisDate=$('#matadrDisDate').datebox('getValue');   
	//6.事件发生初步原因分析
	var matadrReasonDesc=$('#matadrReasonDesc').val();
	//7.事件初步处理情况
	var matadrHandInfo=$('#matadrHandInfo').val();	
	//8.事件报告状态
	var matadrHandStatus="";
    $("input[type=checkbox][name=matadrHandStatus]").each(function(){
		if($(this).is(':checked')){
			matadrHandStatus=this.value;
		}
	})	
	//D. 不良事件评价 
	//1.省级监测技术机构评价意见
	var matadrProAdvice=$('#matadrProAdvice').val();	
	//2.国家监测技术机构评价意见
	var matadrCountryAdvice=$('#matadrCountryAdvice').val();	
	//3.报告人职称
	var matadrCarPrvTp="";
    $("input[type=checkbox][name=matadrCarPrvTp]").each(function(){
		if($(this).is(':checked')){
			matadrCarPrvTp=this.value;
		}
	})
	//报告人
	var matadrRepName=$('#matadrRepNameID').val();
	//报告人科室
	var matadrRepLocDr=$('#matadrRepLocID').val();
	var matadrRepTel=$('#matadrRepTel').val();   //报告人联系电话
	var matadrRepEmail=$('#matadrRepEmail').val();   //报告人邮箱
	var matadrRepImpFlag="N"; //重点关注
	if(ImpFlag==""){
		matadrRepImpFlag=matadrRepImpFlag;
	}else{ 
		matadrRepImpFlag=ImpFlag;
	}
	var matadrAdmNo=EpisodeID; //就诊ID
	if(flag==1){
		matadrCurStatusDR=MatadrInitStatDR;  //初始状态
		
	}
	
	// 使用医疗器械与已发生/可能发生的伤害事件之间是否具有合理的先后顺序
	var matadrIfReaOrder="";
    $("input[type=checkbox][name=matadrIfReaOrder]").each(function(){
		if($(this).is(':checked')){
			matadrIfReaOrder=this.value;
		}
	})
	// 发生/可能发生的伤害事件是否属于所使用医疗器械可能导致的伤害类型
	var matadrIfDamageType="";
    $("input[type=checkbox][name=matadrIfDamageType]").each(function(){
		if($(this).is(':checked')){
			matadrIfDamageType=this.value;
		}
	})
	// 已发生/可能发生的伤害事件是否可以用合并用药的作用、患者病情或其他非医疗器械因素来解释
	var matadrIfReasonable="";
    $("input[type=checkbox][name=matadrIfReasonable]").each(function(){
		if($(this).is(':checked')){
			matadrIfReasonable=this.value;
		}
	})
	// 关联性评价结果
	var matadrRelEvaluation="";
    $("input[type=checkbox][name=matadrRelEvaluation]").each(function(){
		if($(this).is(':checked')){
			matadrRelEvaluation=this.value;
		}
	})
	
	var matadrDataList=matadrNo+"^"+matadrSex+"^"+matadrAge+"^"+matadrName+"^"+matadrPatNo+"^"+matadrExpectEff+"^"+matadrAdmDateResult;
	matadrDataList=matadrDataList+"^"+matadrAdmTimeResult+"^"+matadrMainExp+"^"+matadrAdrDate+"^"+matadrDiscDate;
	matadrDataList=matadrDataList+"^"+matadrUsePlace+"^"+matadrUsePlaceOth+"^"+matadrResult+"^"+matadrDeathDate;
	matadrDataList=matadrDataList+"^"+matadrDeathTime+"^"+matadrEventDesc+"^"+matadrProName+"^"+matadrInciName+"^"+matadrRegNo;
	matadrDataList=matadrDataList+"^"+matadrManf+"^"+matadrManfAddress+"^"+matadrManfTel+"^"+matadrSpec+"^"+matadrProCode;
	matadrDataList=matadrDataList+"^"+matadrProBatNo+"^"+matadrOperator+"^"+matadrOperatorOth+"^"+matadrExpDate+"^"+matadrProDate;
	matadrDataList=matadrDataList+"^"+matadrDisDate+"^"+matadrUseDate+"^"+matadrReasonDesc+"^"+matadrHandInfo+"^"+matadrHandStatus;
	matadrDataList=matadrDataList+"^"+matadrProAdvice+"^"+matadrCountryAdvice+"^"+matadrCarPrvTp+"^"+matadrRepName+"^"+matadrRepLocDr;
	matadrDataList=matadrDataList+"^"+matadrRepTel+"^"+matadrRepEmail+"^"+matadrCreateDateResult+"^"+matadrCreateTimeResult;
	matadrDataList=matadrDataList+"^"+matadrCurStatusDR+"^"+mataReportType+"^"+matadrRepImpFlag+"^"+matadrAdmNo;
	matadrDataList=matadrDataList+"^"+matadrIfReaOrder+"^"+matadrIfDamageType+"^"+matadrIfReasonable+"^"+matadrRelEvaluation; //新增 判断内容
	//var matadrRepAuditList="";
	//if(flag==1){
	var matadrRepAuditList=matadrCurStatusDR+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+medadrNextLoc+"^"+medadrLocAdvice+"^"+medadrReceive+"^"+mataReportType;
	//}
	
	var param="matadrID="+matadrID+"&matadrDataList="+matadrDataList+"&matadrRepAuditList="+matadrRepAuditList+"&flag="+flag ; 
	//alert(param);
	//数据保存/提交
	var  mesageShow=""
	if(flag==0){
		mesageShow="保存"
	}
	if(flag==1){		
		mesageShow="提交"		
	}
	$.messager.confirm("提示", "是否进行"+mesageShow+"数据", function (res) {//提示是否删除
		if (res) {
			$.ajax({
   	   			type: "POST",
      			url: url,
       			data: "action=saveMataReport&"+param,
       			success: function(val){
	      			var mataArr=val.replace(/(^\s*)|(\s*$)/g,"").split("^");
	      			if (mataArr[0]=="0") {
	      	 			$.messager.alert("提示:",mesageShow+"成功!");
			 			matadrID=mataArr[1];
			 			if(winflag==0){
						 	if (((adrDataList!="") ||((adrDataList=="")&&(frmflag==1)) )&&(flag==1)){
			  					window.parent.CloseWin();
					  		}
					 	}else if(winflag==1){
							window.parent.CloseWinUpdate();
			  			}
			 				if(adrDataList=="")  //wangxuejian 2016/10/18
                                               {
			 			InitMataReport(matadrID);  //获取报告信息(获取编码信息) qunianpeng 16/09/29 update
			 			winflag=0;
                                                }
			 			ID=matadrID;
			 			if(flag==1){
							//$("a:contains('提交')").attr("disabled",true);
							//$("a:contains('暂存')").attr("disabled",true);
							var buttondiv=document.getElementById("buttondiv");
							buttondiv.style.display='none';
						}
						if(editFlag!=0){
							window.parent.Query();
						}
	      			}else
	      			{
		  	 			if(val==-1){
							$.messager.alert("提示:","无权限");	
						}else if(val==-2){
							$.messager.alert("提示:","已是最后一个权限");	
						}else if(val==-3){
							$.messager.alert("提示:","无授权工作流");	
						}else if(val==-4){
							$.messager.alert("提示:","无配置子项");	
						}else{
							$.messager.alert("提示:","出错");
						}
		  			
		  			}
       			},
       			error: function(){
	       			alert('链接出错');
	       			return;
	   			}
    		});
		}
	});
	//保存
   /*  $.ajax({
   	   type: "POST",
       url: url,
       data: "action=saveMataReport&"+param,
       success: function(val){
	      var mataArr=val.replace(/(^\s*)|(\s*$)/g,"").split("^");
	      if (mataArr[0]=="0") {
	      	 $.messager.alert("提示:","保存成功!");
			 matadrID=mataArr[1];
	      }else{
		  	 $.messager.alert("提示:",val);
		  }
       },
       error: function(){
	       alert('链接出错');
	       return;
	   }
    }); */
    
}
//填写模板
function Mould()
{
	    $('#MouldTable').window({
		title:'填写模板',
		collapsible:false,
		border:false,
		closed:"true",
		minimizable:false,
		maximizable:false,
		resizable:false,
		width:430,
		height:520
	}); 
		$('#MouldTable').window('open');
		//$('#matadrEventDesc').val();
		$('#MT1').datebox("setValue","");;   
		$('#MT2').val("");
		$('#MT3').val("");
		$('#MT4').val("");
		$('#MT5').val("");
		$('#MT6').val("");
		$('#MT7').datebox("setValue","");
		$('#MT8').val("");
		$('#MT9').datebox("setValue","");
		$('#MT10').val("");
		$('#MT11').val("");

}
function saveMouldTable(){
	var EventDesc=$('#matadrEventDesc').val()
	var MT1=$('#MT1').datebox('getValue');   
	var MT2=$('#MT2').val();
	var MT3=$('#MT3').val();
	var MT4=$('#MT4').val();
	var MT5=$('#MT5').val();
	var MT6=$('#MT6').val();
	var MT7=$('#MT7').datebox('getValue');
	var MT8=$('#MT8').val();
	var MT9=$('#MT9').datebox('getValue');
	var MT10=$('#MT10').val();
	var MT11=$('#MT11').val();
	var Str1="",Str2="",Str3="",Str4="",Str5="",Str6="",Str7="",Str8="",Str9="",Str10="",Str11="";
	if (MT1!==""){
		if(!compareSelTimeAndCurTime(MT1)){
			$.messager.alert("提示:","【器械使用时间】不能大于当前时间！");
			return false;	
		}
		Str1="器械使用时间:"+MT1+"；";
	}
	if (MT2!==""){
		Str2="使用目的:"+MT2+"；";
	}
	if (MT3!==""){
		Str3="使用依据:"+MT3+"；";
	}
	if (MT4!==""){
		Str4="使用情况:"+MT4+"；";
	}
	if (MT5!==""){
		Str5="不良事件情况:"+MT5+"；";
	}
	if (MT6!==""){
		Str6="对受害者影响:"+MT6+"；";
	}
	if (MT7!==""){
		if(!compareSelTimeAndCurTime(MT7)){
			$.messager.alert("提示:","【采取治疗措施时间】不能大于当前时间！");
			return false;	
		}
		Str7="采取治疗措施时间:"+MT7+"；";
	}
	if (MT8!==""){
		Str8="采取治疗措施:"+MT8+"；";
	}
	if (MT9!==""){
		if(!compareSelTimeAndCurTime(MT9)){
			$.messager.alert("提示:","【不良事件好转时间】不能大于当前时间！");
			return false;	
		}
		Str9="不良事件好转时间:"+MT9+"；";
	}
	if (MT10!==""){
		Str10="器械联合使用情况:"+MT10+"；";
	}
	if (MT11!==""){
		Str11="事件发生医院:"+MT11+"；";
	}
	var EventDesc=EventDesc+Str1+Str2+Str3+Str4+Str5+Str6+Str7+Str8+Str9+Str10+Str11;
	$('#matadrEventDesc').val(EventDesc);
	$('#MouldTable').window('close');
}
//血常规检测
function BloodCheck()
{
	$('body').append('<div id="BloodCheck"><table id="BClist"></table></div>');
		$('#BloodCheck').window({
		title:'血常规检测',
		collapsible:false,
		border:false,
		closed:"true",
		minimizable:false,
		maximizable:false,
		resizable:false,
		width:500,
		height:360
	}); 
	$('#BloodCheck').window('open');
	BloodCheckPanel();
}
function BloodCheckPanel()
{
	//单位
	var uomEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selUom',
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#BClist").datagrid('getEditor',{index:editRow,field:'ItemUom'});
				$(ed.target).combobox('setValue', option.text);  
			} 
		}
	}
	//类别
	var typeEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selType',
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#BClist").datagrid('getEditor',{index:editRow,field:'Type'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	// 定义columns
	var columns=[[
	
		{field:"MataID",title:'ID',width:100,hidden:true},
		{field:"ItemCode",title:'代码',width:150,align:'center',editor:texteditor,hidden:true},
		{field:'ItemDesc',title:'属性名称',width:130,align:'center',editor:texteditor},
		{field:'ItemVal',title:'数据内容',width:150,align:'center',editor:texteditor},
		{field:'ItemUom',title:'单位',width:150,align:'center',editor:uomEditor},
		{field:"Type",title:'类别',width:150,align:'center',editor:typeEditor,hidden:true}
		
	]];
	//定义datagrid
	$('#BClist').datagrid({
		url:'',
		fit:true,
		//border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  // 每页显示的记录条数
		pageList:[15,30,45],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
		toolbar: [{
			text:'保存',
			iconCls: 'icon-save',
			handler: function(){
				SaveBloodCheck();
			}
		},{
			text:'确认',
			iconCls: 'icon-ok',
			handler: function(){
				BloodCheckOK();
			}
		},{
			text:'取消',
			iconCls: 'icon-cancel',
			handler: function(){
				$('#BloodCheck').window('close');
			}
		}],
		onClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((editRow != "")||(editRow == "0")) {
            	$("#BClist").datagrid('endEdit', editRow);
			}
            $("#BClist").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 			
        }
	});
	$('#BClist').datagrid({
		url:url+'?action=QueryMataEventType',	
		queryParams:{
			params:"血常规"}
	});
}
//保存修改数据
function SaveBloodCheck(){
	if(editRow>="0"){
		$("#BClist").datagrid('endEdit', editRow);
	}
	var rows = $("#BClist").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].ItemDesc=="")){
			$.messager.alert("提示","属性名称不能为空!"); 
			return false;
		}
		var tmp=rows[i].MataID+"^"+rows[i].ItemCode+"^"+rows[i].ItemDesc+"^"+rows[i].ItemVal+"^"+rows[i].ItemUom+"^"+rows[i].ItemActiveFlag+"^"+rows[i].Type;
		dataList.push(tmp);
	}  
	var rowstr=dataList.join("||");
	$.post(url+'?action=SaveEvent',{"params":rowstr},function(data){
			$('#BClist').datagrid('reload'); //重新加载
	});
	
}
//确认，将表的数据写到对应的文本域中
function BloodCheckOK(){
	var EventDesc=$('#matadrEventDesc').val();
	var tbdata= $('#BClist').datagrid('getRows');
	$.each(tbdata, function(index, data){
		var row = $('#BClist').datagrid('getRowIndex',data); 
		$('#BClist').datagrid('endEdit',row); 
		if(data.ItemVal!=""){
			EventDesc=EventDesc+data.ItemDesc+":"+data.ItemVal+data.ItemUom+"；";
		}
	})
	$('#matadrEventDesc').val(EventDesc);
	$('#BloodCheck').window('close');
}		

//肾功能检测
function RenalCheck()
{
	$('body').append('<div id="RenalCheck"><table id="RClist"></table></div>');
	$('#RenalCheck').window({
		title:'肾功能检测',
		collapsible:false,
		border:false,
		closed:"true",
		minimizable:false,
		maximizable:false,
		resizable:false,
		width:500,
		height:360
	}); 
	$('#RenalCheck').window('open');
	RenalCheckPanel();
}
function RenalCheckPanel()
{
	//单位
	var uomEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selUom',
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#RClist").datagrid('getEditor',{index:editRow,field:'ItemUom'});
				$(ed.target).combobox('setValue', option.text);  
			} 
		}
	}
	//类别
	var typeEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selType',
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#RClist").datagrid('getEditor',{index:editRow,field:'Type'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	// 定义columns
	var columns=[[
		{field:"MataID",title:'ID',width:100,hidden:true},
		{field:"ItemCode",title:'代码',width:150,align:'center',editor:texteditor,hidden:true},
		{field:'ItemDesc',title:'属性名称',width:130,align:'center',editor:texteditor},
		{field:'ItemVal',title:'数据内容',width:150,align:'center',editor:texteditor},
		{field:'ItemUom',title:'单位',width:150,align:'center',editor:uomEditor},
		{field:"Type",title:'类别',width:150,align:'center',editor:typeEditor,hidden:true}
		
	]];
	//定义datagrid
	$('#RClist').datagrid({
		url:'',
		fit:true,
		//border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  // 每页显示的记录条数
		pageList:[15,30,45],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
		toolbar: [{
			text:'保存',
			iconCls: 'icon-save',
			handler: function(){
				SaveRenalCheck();
			}
		},{
			text:'确认',
			iconCls: 'icon-ok',
			handler: function(){
				RenalCheckOK();
			}
		},{
			text:'取消',
			iconCls: 'icon-cancel',
			handler: function(){
				$('#RenalCheck').window('close')
			}
		}],
		onClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((editRow != "")||(editRow == "0")) {
            	$("#RClist").datagrid('endEdit', editRow);
			}
            $("#RClist").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 			
        }
	});
	$('#RClist').datagrid({
		url:url+'?action=QueryMataEventType',	
		queryParams:{
			params:"肾功能"}
	});
}
//保存修改数据
function SaveRenalCheck(){
	if(editRow>="0"){
		$("#RClist").datagrid('endEdit', editRow);
	}
	var rows = $("#RClist").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].ItemDesc=="")){
			$.messager.alert("提示","属性名称不能为空!"); 
			return false;
		}
		var tmp=rows[i].MataID+"^"+rows[i].ItemCode+"^"+rows[i].ItemDesc+"^"+rows[i].ItemVal+"^"+rows[i].ItemUom+"^"+rows[i].ItemActiveFlag+"^"+rows[i].Type;
		dataList.push(tmp);
	}  
	var rowstr=dataList.join("||");
	$.post(url+'?action=SaveEvent',{"params":rowstr},function(data){
		$('#RClist').datagrid('reload'); //重新加载
	});
	
}
//确认，将表的数据写到对应的文本域中
function RenalCheckOK(){
	var EventDesc=$('#matadrEventDesc').val();
	var tbdata= $('#RClist').datagrid('getRows');
	$.each(tbdata, function(index, data){
		var row = $('#RClist').datagrid('getRowIndex',data); 
		$('#RClist').datagrid('endEdit',row); 
		if(data.ItemVal!=""){
			EventDesc=EventDesc+data.ItemDesc+":"+data.ItemVal+data.ItemUom+"；";
		}
	})
	$('#matadrEventDesc').val(EventDesc);
	$('#RenalCheck').window('close');
}		
//血脂分析模板 BloodLipid
function BloodLipid()
{
	$('body').append('<div id="BloodLipid"><table id="BLlist"></table></div>');
	$('#BloodLipid').window({
		title:'血脂分析',
		collapsible:false,
		border:false,
		closed:"true",
		minimizable:false,
		maximizable:false,
		resizable:false,
		width:500,
		height:360
	}); 
	$('#BloodLipid').window('open');
	BloodLipidPanel();
}
function BloodLipidPanel()
{
	//单位
	var uomEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selUom',
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#BLlist").datagrid('getEditor',{index:editRow,field:'ItemUom'});
				$(ed.target).combobox('setValue', option.text);  
			} 
		}
	}
	//类别
	var typeEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selType',
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#BLlist").datagrid('getEditor',{index:editRow,field:'Type'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	// 定义columns
	var columns=[[
		{field:"MataID",title:'ID',width:100,hidden:true},
		{field:"ItemCode",title:'代码',width:150,align:'center',editor:texteditor,hidden:true},
		{field:'ItemDesc',title:'属性名称',width:130,align:'center',editor:texteditor},
		{field:'ItemVal',title:'数据内容',width:150,align:'center',editor:texteditor},
		{field:'ItemUom',title:'单位',width:150,align:'center',editor:uomEditor},
		{field:"Type",title:'类别',width:150,align:'center',editor:typeEditor,hidden:true}
	]];
	//定义datagrid
	$('#BLlist').datagrid({
		url:'',
		fit:true,
		//border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  // 每页显示的记录条数
		pageList:[15,30,45],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
		toolbar: [{
			text:'保存',
			iconCls: 'icon-save',
			handler: function(){
				SaveBloodLipid();
			}
		},{
			text:'确认',
			iconCls: 'icon-ok',
			handler: function(){
				BloodLipidOK();
			}
		},{
			text:'取消',
			iconCls: 'icon-cancel',
			handler: function(){
				$('#BloodLipid').window('close');
			}
		}],		
		onClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((editRow != "")||(editRow == "0")) {
            	$("#BLlist").datagrid('endEdit', editRow); 
			}
            $("#BLlist").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 			
        }
	});
	$('#BLlist').datagrid({
		url:url+'?action=QueryMataEventType',	
		queryParams:{
			params:"血脂分析"}
	});
}
//保存修改数据
function SaveBloodLipid(){
	if(editRow>="0"){
		$("#BLlist").datagrid('endEdit', editRow);
	}
	var rows = $("#BLlist").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].ItemDesc=="")){
			$.messager.alert("提示","属性名称不能为空!"); 
			return false;
		}
		var tmp=rows[i].MataID+"^"+rows[i].ItemCode+"^"+rows[i].ItemDesc+"^"+rows[i].ItemVal+"^"+rows[i].ItemUom+"^"+rows[i].ItemActiveFlag+"^"+rows[i].Type;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");
	$.post(url+'?action=SaveEvent',{"params":rowstr},function(data){
		$('#BLlist').datagrid('reload'); //重新加载
	});
}
//确认，将表的数据写到对应的文本域中
function BloodLipidOK(){
	var EventDesc=$('#matadrEventDesc').val();
	var tbdata= $('#BLlist').datagrid('getRows');
	$.each(tbdata, function(index, data){
		var row = $('#BLlist').datagrid('getRowIndex',data); 
		$('#BLlist').datagrid('endEdit',row); 
		if(data.ItemVal!=""){
			EventDesc=EventDesc+data.ItemDesc+":"+data.ItemVal+data.ItemUom+"；";
		}
	})
	$('#matadrEventDesc').val(EventDesc);
	$('#BloodLipid').window('close');
}
//生命体征  VitalSigns
function VitalSigns()
{
	$('body').append('<div id="VitalSigns"><table id="VSlist"></table></div>');
	$('#VitalSigns').window({
		title:'生命体征',
		collapsible:false,
		border:false,
		closed:"true",
		minimizable:false,
		maximizable:false,
		resizable:false,
		width:500,
		height:360
	}); 
	$('#VitalSigns').window('open');
	VitalSignsPanel();
}
function VitalSignsPanel()
{
	//单位
	var uomEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selUom',
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#VSlist").datagrid('getEditor',{index:editRow,field:'ItemUom'});
				$(ed.target).combobox('setValue', option.text);  
			} 
		}
	}
	//类别
	var typeEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selType',
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#VSlist").datagrid('getEditor',{index:editRow,field:'Type'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	// 定义columns
	var columns=[[
		{field:"MataID",title:'ID',width:100,hidden:true},
		{field:"ItemCode",title:'代码',width:150,align:'center',editor:texteditor,hidden:true},
		{field:'ItemDesc',title:'属性名称',width:130,align:'center',editor:texteditor},
		{field:'ItemVal',title:'数据内容',width:150,align:'center',editor:texteditor},
		{field:'ItemUom',title:'单位',width:150,align:'center',editor:uomEditor},
		{field:"Type",title:'类别',width:150,align:'center',editor:typeEditor,hidden:true}
	]];
	//定义datagrid
	$('#VSlist').datagrid({
		url:'',
		fit:true,
		//border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  // 每页显示的记录条数
		pageList:[15,30,45],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
		toolbar: [{
			text:'保存',
			iconCls: 'icon-save',
			handler: function(){
				SaveVitalSigns();
			}
		},{
			text:'确认',
			iconCls: 'icon-ok',
			handler: function(){
				VitalSignsOK();
			}
		},{
			text:'取消',
			iconCls: 'icon-cancel',
			handler: function(){
				$('#VitalSigns').window('close');
			}
		}],
		onClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((editRow != "")||(editRow == "0")) {
            	$("#VSlist").datagrid('endEdit', editRow); 
			}
            $("#VSlist").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 			
        }
	});
	$('#VSlist').datagrid({
		url:url+'?action=QueryMataEventType',	
		queryParams:{
			params:"生命体征"}
	});
}
//保存修改数据
function SaveVitalSigns(){
	if(editRow>="0"){
		$("#VSlist").datagrid('endEdit', editRow);
	}
	var rows = $("#VSlist").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].ItemDesc=="")){
			$.messager.alert("提示","属性名称不能为空!"); 
			return false;
		}
		var tmp=rows[i].MataID+"^"+rows[i].ItemCode+"^"+rows[i].ItemDesc+"^"+rows[i].ItemVal+"^"+rows[i].ItemUom+"^"+rows[i].ItemActiveFlag+"^"+rows[i].Type;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");
	$.post(url+'?action=SaveEvent',{"params":rowstr},function(data){
		$('#VSlist').datagrid('reload'); //重新加载
	});
}
//确认，将表的数据写到对应的文本域中
function VitalSignsOK(){
	var EventDesc=$('#matadrEventDesc').val();
	var tbdata= $('#VSlist').datagrid('getRows');
	$.each(tbdata, function(index, data){
		var row = $('#VSlist').datagrid('getRowIndex',data); 
		$('#VSlist').datagrid('endEdit',row); 
		if(data.ItemVal!=""){
			EventDesc=EventDesc+data.ItemDesc+":"+data.ItemVal+data.ItemUom+"；";
		}
	})
	$('#matadrEventDesc').val(EventDesc);
	$('#VitalSigns').window('close');
}
//血气模板  BloodGas
function BloodGas()
{
	$('body').append('<div id="BloodGas"><table id="BGlist"></table></div>');
	$('#BloodGas').window({
		title:'血气模板',
		collapsible:false,
		border:false,
		resizable:false,
		closed:"true",
		minimizable:false,
		maximizable:false,
		width:500,
		height:360
	}); 
	$('#BloodGas').window('open');
	BloodGasPanel();
}
function BloodGasPanel()
{
	//单位
	var uomEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selUom',
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#BGlist").datagrid('getEditor',{index:editRow,field:'ItemUom'});
				$(ed.target).combobox('setValue', option.text);  
			} 
		}
	}
	//类别
	var typeEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selType',
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#BGlist").datagrid('getEditor',{index:editRow,field:'Type'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	// 定义columns
	var columns=[[
		{field:"MataID",title:'ID',width:100,hidden:true},
		{field:"ItemCode",title:'代码',width:150,align:'center',editor:texteditor,hidden:true},
		{field:'ItemDesc',title:'属性名称',width:130,align:'center',editor:texteditor},
		{field:'ItemVal',title:'数据内容',width:150,align:'center',editor:texteditor},
		{field:'ItemUom',title:'单位',width:150,align:'center',editor:uomEditor},
		{field:"Type",title:'类别',width:150,align:'center',editor:typeEditor,hidden:true}
	]];
	//定义datagrid
	$('#BGlist').datagrid({
		url:'',
		fit:true,
		//border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  // 每页显示的记录条数
		pageList:[15,30,45],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
		toolbar: [{
			text:'保存',
			iconCls: 'icon-save',
			handler: function(){
				SaveBloodGas();
			}
		},{
			text:'确认',
			iconCls: 'icon-ok',
			handler: function(){
				BloodGasOK();
			}
		},{
			text:'取消',
			iconCls: 'icon-cancel',
			handler: function(){
				$('#BloodGas').window('close');
			}
		}],
		onClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((editRow != "")||(editRow == "0")) {
            	$("#BGlist").datagrid('endEdit', editRow); 
			}
            $("#BGlist").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 			
        }
	});
	$('#BGlist').datagrid({
		url:url+'?action=QueryMataEventType',	
		queryParams:{
			params:"血气"}
	});
}
//保存修改数据
function SaveBloodGas(){
	if(editRow>="0"){
		$("#BGlist").datagrid('endEdit', editRow);
	}
	var rows = $("#BGlist").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].ItemDesc=="")){
			$.messager.alert("提示","属性名称不能为空!"); 
			return false;
		}
		var tmp=rows[i].MataID+"^"+rows[i].ItemCode+"^"+rows[i].ItemDesc+"^"+rows[i].ItemVal+"^"+rows[i].ItemUom+"^"+rows[i].ItemActiveFlag+"^"+rows[i].Type;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");
	$.post(url+'?action=SaveEvent',{"params":rowstr},function(data){
		$('#BGlist').datagrid('reload'); //重新加载
	});
}
//确认，将表的数据写到对应的文本域中
function BloodGasOK(){
	var EventDesc=$('#matadrEventDesc').val();
	var tbdata= $('#BGlist').datagrid('getRows');
	$.each(tbdata, function(index, data){
		var row = $('#BGlist').datagrid('getRowIndex',data); 
		$('#BGlist').datagrid('endEdit',row); 
		if(data.ItemVal!=""){
			EventDesc=EventDesc+data.ItemDesc+":"+data.ItemVal+data.ItemUom+"；";
		}
	})
	$('#matadrEventDesc').val(EventDesc);
	$('#BloodGas').window('close');
}
//肝功能 LiverFunction
function LiverFunction()
{
	$('body').append('<div id="LiverFunction"><table id="LFlist"></table></div>');
	$('#LiverFunction').window({
		title:'肝功能',
		collapsible:false,
		border:false,
		closed:"true",
		minimizable:false,
		maximizable:false,
		resizable:false,
		width:500,
		height:360
	}); 
	$('#LiverFunction').window('open');
	LiverFunctionPanel();
}
function LiverFunctionPanel()
{
	//单位
	var uomEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selUom',
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#LFlist").datagrid('getEditor',{index:editRow,field:'ItemUom'});
				$(ed.target).combobox('setValue', option.text);  
			} 
		}
	}
	//类别
	var typeEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selType',
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#LFlist").datagrid('getEditor',{index:editRow,field:'Type'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	// 定义columns
	var columns=[[
		{field:"MataID",title:'ID',width:100,hidden:true},
		{field:"ItemCode",title:'代码',width:150,align:'center',editor:texteditor,hidden:true},
		{field:'ItemDesc',title:'属性名称',width:130,align:'center',editor:texteditor},
		{field:'ItemVal',title:'数据内容',width:150,align:'center',editor:texteditor},
		{field:'ItemUom',title:'单位',width:150,align:'center',editor:uomEditor},
		{field:"Type",title:'类别',width:150,align:'center',editor:typeEditor,hidden:true}
	]];
	//定义datagrid
	$('#LFlist').datagrid({
		url:'',
		fit:true,
		//border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  // 每页显示的记录条数
		pageList:[15,30,45],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
		toolbar: [{
			text:'保存',
			iconCls: 'icon-save',
			handler: function(){
				SaveLiverFunction();
			}
		},{
			text:'确认',
			iconCls: 'icon-ok',
			handler: function(){
				LiverFunctionOK();
			}
		},{
			text:'取消',
			iconCls: 'icon-cancel',
			handler: function(){
				$('#LiverFunction').window('close');
			}
		}],
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
         	if ((editRow != "")||(editRow == "0")) {
            	$("#LFlist").datagrid('endEdit', editRow); 
			}
         	$("#LFlist").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 			
        }
	});
	$('#LFlist').datagrid({
		url:url+'?action=QueryMataEventType',	
		queryParams:{
			params:"肝功能"}
	});
}
//保存修改数据
function SaveLiverFunction()
{
	if(editRow>="0"){
		$("#LFlist").datagrid('endEdit', editRow);
	}
	var rows = $("#LFlist").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].ItemDesc=="")){
			$.messager.alert("提示","属性名称不能为空!"); 
			return false;
		}
		var tmp=rows[i].MataID+"^"+rows[i].ItemCode+"^"+rows[i].ItemDesc+"^"+rows[i].ItemVal+"^"+rows[i].ItemUom+"^"+rows[i].ItemActiveFlag+"^"+rows[i].Type;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");
	$.post(url+'?action=SaveEvent',{"params":rowstr},function(data){
		$('#LFlist').datagrid('reload'); //重新加载
	});
}
//确认，将表的数据写到对应的文本域中
function LiverFunctionOK(){
	var EventDesc=$('#matadrEventDesc').val();
	var tbdata= $('#LFlist').datagrid('getRows');
	$.each(tbdata, function(index, data){
		var row = $('#LFlist').datagrid('getRowIndex',data); 
		$('#LFlist').datagrid('endEdit',row); 
		if(data.ItemVal!=""){
			EventDesc=EventDesc+data.ItemDesc+":"+data.ItemVal+data.ItemUom+"；";
		}
	})
	$('#matadrEventDesc').val(EventDesc);
	$('#LiverFunction').window('close');
}
//替换特殊符号 2015-10-25 congyue
function trSpecialSymbol(str)
{
	if(str.indexOf("%")){
		var str=str.replace("%","%25");
	}
	if(str.indexOf("&")){
		var str=str.replace("&","%26");
	}
	if(str.indexOf("+")){
		var str=str.replace("+","%2B");
	}
	return str;
}
//加载报表信息
function InitMataReport(matadrID)
{
	if(matadrID==""){return;}
   	var params=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+CurRepCode;
	var matadrDataList="";
	winflag=1; //2016-10-10
	//获取报表信息
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=getMataRepInfo&matadrID="+matadrID+"&params="+params,
       //dataType: "json",
       success: function(val){
	      	 matadrDataList=val;
	      	    var tmp=matadrDataList.split("!");
				$('#matadrID').val(tmp[0]);    //报表ID
				$('#matadrCreateDate').datetimebox({disabled:true});
				$('#matadrCreateDate').datetimebox("setValue",tmp[43]+" "+tmp[44]);   //报告日期
				$('#matadrNo').val(tmp[1]);    //报告编码
				$('#matadrNo').attr("disabled","true");
				//病人信息
				$('#PatSex').combobox('setValue',tmp[2]);     //性别
				$('#PatAge').val(tmp[3]);    //年龄
				$('#PatName').val(tmp[4]);    //患者姓名
				$('#PatNo').val(tmp[5]);    //病人登记号
				$('#PatNo').attr("disabled","true");  ///2017-07-20 bianshuai 设置病人ID不可编辑
				$('#matadrExpectEff').val(tmp[6]);    //预期治疗疾病或作用
				if(tmp[7]!=""||tmp[8]!=""){
					$('#matadrAdmDate').datetimebox("setValue",tmp[7]+" "+tmp[8]);   //诊疗日期				
				}				
				$('#matadrMainExp').val(tmp[9]);    //事件主要表现
				$('#matadrAdrDate').datebox("setValue",tmp[10]);   //事件发生日期
				$('#matadrDiscDate').datebox("setValue",tmp[11]);   //发现或者知悉时间
				//医疗器械实际使用场所
				$('#UP'+tmp[12]).attr("checked",true);
				$('#matadrUsePlaceOth').val(tmp[13]);
				if(tmp[12]=="99"){
					$('#matadrUsePlaceOth').attr("disabled",false);
				}
				//事件后果
				$('#TR'+tmp[14]).attr("checked",true);
				$('#matadrEventResultDate').datetimebox("setValue",tmp[15]+" "+tmp[16]);
				var deathdatetime=tmp[14];
				if(deathdatetime==10){
					var matadrEventResultDate=document.getElementById("deathdate");
					matadrEventResultDate.style.display='inline';
		
				}
				
				$('#matadrEventDesc').val(tmp[17]);    //事件陈述
				//C.医疗器械情况
				$('#matadrProName').val(tmp[18]);    //产品名称
				$('#matadrInciName').val(tmp[19]);    //商品名称
				$('#matadrRegNo').val(tmp[20]);    //注册证号
				$('#matadrManf').val(tmp[21]);    //生产企业名称
				$('#matadrManfAddress').val(tmp[22]);    //生产企业地址
				$('#matadrManfTel').val(tmp[23]);    //企业联系电话
				$('#matadrSpec').val(tmp[24]);    //型号规格
				$('#matadrProCode').val(tmp[25]);    //产品编号
				$('#matadrProBatNo').val(tmp[26]);    //产品批号
				//操作人
				$('#OP'+tmp[27]).attr("checked",true);
				$('#matadrOperatorOth').val(tmp[28]);
				if(tmp[27]=="99"){
					$('#matadrOperatorOth').attr("disabled",false);
				}
				$('#matadrExpDate').datebox("setValue",tmp[29]);   //有效期至
				$('#matadrProDate').datebox("setValue",tmp[30]);   //生产日期
				$('#matadrDisDate').datebox("setValue",tmp[31]);   //停用日期
				$('#matadrUseDate').datebox("setValue",tmp[32]);   //植入日期(若植入)
				$('#matadrReasonDesc').val(tmp[33]);    //事件发生初步原因分
				$('#matadrHandInfo').val(tmp[34]);    //事件初步处理情况
				//事件报告状态
				$('#HS'+tmp[35]).attr("checked",true);				
				//D. 不良事件评价
				$('#matadrProAdvice').val(tmp[36]);    //省级监测技术机构评价意见
				$('#matadrCountryAdvice').val(tmp[37]);    //国家监测技术机构评价意见
				//报告人职称
				$('#CP'+tmp[38]).attr("checked",true);
				$('#matadrRepNameID').val(tmp[39]);    //报告人
				$('#matadrRepName').val(tmp[48]);    //报告人
				$('#matadrRepName').attr("disabled","true");
				$('#matadrRepLocID').val(tmp[40]);    //报告人科室
				$('#matadrRepLocDr').val(tmp[47]);    //报告人科室
				$('#matadrRepLocDr').attr("disabled","true");
				$('#matadrRepTel').val(tmp[41]);    //报告人联系电话
				$('#matadrRepEmail').val(tmp[42]);    //报告人邮箱
				mataReportType=tmp[49];
				medadrNextLoc=tmp[50]
				medadrLocAdvice=tmp[51]
				medadrReceive=tmp[52];
				ImpFlag=tmp[53]; //重要标记
				EpisodeID=tmp[54]; //就诊ID
				MatadrInitStatDR=tmp[45];
				//editFlag状态为0,提交和暂存按钮不可用
				matadrCurStatusDR=tmp[46];
				if (matadrCurStatusDR=="")
				{
					matadrCurStatusDR=matadrCurStatusDR;
					medadrReceive="";
				}
				else
				{
					MatadrInitStatDR=tmp[46];
					//medadrReceive="1";
					if(((UserDr==LgUserID)&&(medadrReceive=="2"))||(UserDr!=LgUserID)){
						medadrReceive="1";
					}
				}
				//2017-06-12 报告已评估，不可修改
				if(assessID!=""){
					$("#savebt").hide();
					$("#submitdiv").hide();
				}
				if (tmp[46]!=""){  //如果有提交状态
					$('#submitdiv').hide();//隐藏提交按钮
					//获取评估权限标志 2016-10-19
					var Assessflag=GetAssessAuthority(matadrID,params);
					if (Assessflag=="Y"){
						$('#assessment').show(); //显示评估按钮 
					}
				}
				
				// 是否具有合理的先后顺序
				$('#IRO'+tmp[55]).attr("checked",true);
				// 是否属于所使用医疗器械可能导致的伤害类型
				$('#IDT'+tmp[56]).attr("checked",true);
				// 是否可以用合并用药的作用、患者病情或其他非医疗器械因素来解释
				$('#IR'+tmp[57]).attr("checked",true);
				// 关联性评价结果
				$('#RE'+tmp[58]).attr("checked",true);

				$('#clearbt').hide();//隐藏清空按钮	
     },
       error: function(){
	       alert('链接出错');
	       return;
	   }
    });   
}
//加载报表默认信息
function InitPatientInfo(matadrID,adrDataList)
{
   if(matadrID!=""){return;}
   if(adrDataList==""){
   		adrDataList=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+CurRepCode;
   }
   //var params=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+CurRepCode;
   $.ajax({
   type: "POST",
   url: url,
   data:"action=getMataInfo&params="+adrDataList,
   success: function(val){
		if(val==-1){
			$.messager.alert("提示:","请先配置工作流与权限,然后填报！");
			return;
		}else{
			var tmp=val.split("^");
			$('#matadrCreateDate').datetimebox({disabled:true});
			$('#matadrCreateDate').datetimebox("setValue",tmp[0]);   //报告日期
			MatadrInitStatDR=tmp[1];  //报表的初始化,状态 
			mataReportType=tmp[2];
			//$('#matadrNo').val(tmp[3]);                //报告编码
			$('#matadrNo').attr("disabled","true");
			$('#matadrRepNameID').val(tmp[4]);	//报告人id
			$('#matadrRepName').val(tmp[5]);    //报告人
			$('#matadrRepName').attr("disabled","true");
			$('#matadrRepLocID').val(tmp[6]);    //报告人科室id
			$('#matadrRepLocDr').val(tmp[7]);    //报告人科室
			$('#matadrRepLocDr').attr("disabled","true");
		}
   }})
}
//获取病人信息
function getMataRepPatInfo(patientID,EpisodeID){
	//var matadrPatNo=$('#PatNo').val();
	//var matadrPatNo=getRegNo(matadrPatNo);
	if(patientID==""||EpisodeID==""){return;}
	//获取报表信息
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=getRepPatInfo&PatNo="+patientID+"&EpisodeID="+EpisodeID,
       //dataType: "json",
       success: function(val){
	       
	    var mataRepPatInfo=val;
	    var tmp=mataRepPatInfo.split("^");
	      
		$('#PatNo').val(tmp[0]); //登记号
		$('#PatName').val(tmp[1]); //病人名字 
		$('#PatName').attr("disabled","true");
		$('#PatSex').combobox({disabled:true});
		$('#PatSex').combobox('setValue',tmp[2]);  //性别
		$('#PatAge').val(tmp[4]);  //年龄
		$('#PatAge').attr("disabled","true");
		if ((tmp[8]!="")&(tmp[9]!="")){
			$('#matadrAdmDate').datetimebox({disabled:true}); //诊疗日期    wangxuejian 2016-10-08 
		}
		$('#matadrAdmDate').datetimebox("setValue",tmp[8]+" "+tmp[9]);   //报告日期
		patIDlog=$('#PatNo').val();
       }
    })

	
}
//未填项默认为空
function trsUndefinedToEmpty(str)
{
	if(typeof str=="undefined"){
		str="";
	}
	return str;
}
//保存前,进行数据完成性检查
function saveBeforeCheck()
{
	//1、报告日期
	var matadrCreateDate=$('#matadrCreateDate').datetimebox('getValue');
	if(matadrCreateDate==""){
		$.messager.alert("提示:","【报告日期】不能为空！");
		return false;
	}
	var matadrCreateDateResult=matadrCreateDate.split(" ")[0];
	if(!compareSelTimeAndCurTime(matadrCreateDateResult)){
		$.messager.alert("提示:","【报告时间】不能大于当前时间！");
		return false;	
	}
	
	//2、报告编码
	var matadrNo=$('#matadrNo').val();
	/* if(matadrNo==""){
		$.messager.alert("提示:","【报告编码】不能为空！");
		return false;
	} */
	matadrNo=matadrNo.replace(/[ ]/g,""); //去掉编码中的空格
	//病人登记号
	var matadrPatNo=$('#PatNo').val();
	if(matadrPatNo==""){
		$.messager.alert("提示:","【病人登记号】不能为空！");
		return false;
	}
	//病人姓名
	var matadrName=$('#PatName').val();
	if(matadrName==""){
		$.messager.alert("提示:","【病人姓名】不能为空！");
		return false;
	}
    //病人性别
	var matadrSex=$('#PatSex').combobox('getValue');
	if(matadrSex==""){
		$.messager.alert("提示:","【病人性别】不能为空！");
		return false;
	}
    //病人年龄
	var matadrAge=$('#PatAge').val();  
	if(matadrAge==""){
		$.messager.alert("提示:","【病人年龄】不能为空！");
		return false;
	}
	//预期治疗疾病或作用
	var matadrExpectEff=$('#matadrExpectEff').val();  
	if(matadrExpectEff==""){
		$.messager.alert("提示:","【预期治疗疾病或作用】不能为空！");
		return false;
	}
	//诊疗日期
	var matadrAdmDate=$('#matadrAdmDate').datetimebox('getValue');   
	if(matadrAdmDate==""){
		$.messager.alert("提示:","【诊疗日期】不能为空！");
		return false;
	}
	var matadrAdmDateResult=matadrAdmDate.split(" ")[0];
	if(!compareSelTimeAndCurTime(matadrAdmDateResult)){
		$.messager.alert("提示:","【诊疗日期】不能大于当前时间！");
		return false;	
	} 
	
	//事件主要表现
	var matadrMainExp=$('#matadrMainExp').val();  
	if(matadrMainExp==""){
		$.messager.alert("提示:","【事件主要表现】不能为空！");
		return false;
	}	
	//3.事件发生日期
	var matadrAdrDate=$('#matadrAdrDate').datebox('getValue');   
	if(matadrAdrDate==""){
		$.messager.alert("提示:","【事件发生日期】不能为空！");
		return false;
	}
	if(!compareSelTimeAndCurTime(matadrAdrDate)){
		$.messager.alert("提示:","【事件发生日期】不能大于当前时间！");
		return false;	
	} 
	
	//4.发现或者知悉时间
	var matadrDiscDate=$('#matadrDiscDate').datebox('getValue');   
	if(matadrDiscDate==""){
		$.messager.alert("提示:","【发现或者知悉时间】不能为空！");
		return false;
	}
	if(!compareSelTimeAndCurTime(matadrDiscDate)){
		$.messager.alert("提示:","【发现或者知悉时间】不能大于当前时间！");
		return false;	
	} 
	//5.医疗器械实际使用场所
	var matadrUsePlace="";
	var matadrUsePlaceOth="";
    $("input[type=checkbox][name=matadrUsePlace]").each(function(){
		if($(this).is(':checked')){
			matadrUsePlace=this.value;
		}
	})
	matadrUsePlaceOth=$('#matadrUsePlaceOth').val();
	if(matadrUsePlace==""){
		$.messager.alert("提示:","【医疗器械实际使用场所】不能为空！");
		return false;
	}
	//6.事件后果
	var matadrResult="";
	var matadrDeathDate="",matadrDeathTime="";
     $("input[type=checkbox][name=matadrResult]").each(function(){
		if($(this).is(':checked')){
			matadrResult=this.value;
		}
	})
	if(matadrResult==""){
		$.messager.alert("提示:","【事件后果】不能为空！");
		return false;
	}
	if(matadrResult=="10"){
		var matadrEventResultDate=$('#matadrEventResultDate').datetimebox('getValue'); 
		if(matadrEventResultDate==""){
			$.messager.alert("提示:","事件后果为【死亡】,请填写死亡时间！");
			return false;
		}else{
		matadrDeathDate=matadrEventResultDate.split(" ")[0];  //死亡日期
		matadrDeathTime=matadrEventResultDate.split(" ")[1];  //死亡时间
	}
	
	if(!compareSelTimeAndCurTime(matadrDeathDate)){
		$.messager.alert("提示:","事件后果为【死亡】的【死亡时间】不能大于当前时间！");
		return false;	
	} 
	}	
	//7.事件陈述
	var matadrEventDesc=$('#matadrEventDesc').val();
	if(matadrEventDesc==""){
		$.messager.alert("提示:","【事件陈述】不能为空！");
		return false;
	}
	//报告人
	if($('#matadrRepName').val()==""){
		$.messager.alert("提示:","【报告人】不能为空！");
		return false;
	}
    
	//报告人科室	
	if($('#matadrRepLocDr').val()==""){
		$.messager.alert("提示:","【报告人科室】不能为空！");
		return false;
	}
	//产品名称    wangxuejian 2016-10-08
	if($('#matadrProName').val()==""){
		$.messager.alert("提示:","【产品名称】不能为空！");
		return false;
	}
	if((LgGroupDesc.indexOf("器材")>=0)||(LgGroupDesc.indexOf("固定资产")>=0)||(LgCtLocDesc.indexOf("器材")>=0)||(LgCtLocDesc.indexOf("器械")>=0)||(LgCtLocDesc.indexOf("设备")>=0)){  //器材处（医疗设备科）必填项
		//注册证号    wangxuejian 2016-10-08
		if($('#matadrRegNo').val()==""){
			$.messager.alert("提示:","【注册证号】不能为空！");
			return false;
		}
		//生产企业名称    wangxuejian 2016-10-08
		if($('#matadrManf').val()==""){
			$.messager.alert("提示:","【生产企业名称】不能为空！");
			return false;
		}
		//企业联系电话    wangxuejian 2016-10-08
		if($('#matadrManfTel').val()==""){
			$.messager.alert("提示:","【企业联系电话】不能为空！");
			return false;
		}
		//事件初步处理情况    wangxuejian 2016-10-08
		if($('#matadrHandInfo').val()==""){
			$.messager.alert("提示:","【事件初步处理情况】不能为空！");
			return false;
		}
	}
	//生产日期
	var matadrProDate=$('#matadrProDate').datebox('getValue');   
	if(!compareSelTimeAndCurTime(matadrProDate)){
		$.messager.alert("提示:","【生产日期】不能大于当前时间！");
		return false;	
	}
	
	//有效期至
	var matadrExpDate=$('#matadrExpDate').datebox('getValue');
	
	if(matadrExpDate==""){
		
	}else if(!compareSelTowTime(matadrProDate,matadrExpDate)){
		$.messager.alert("提示:","【生产日期】不能大于【有效日期】！")
		return false;
	}
	
	//植入日期(若植入)
	var matadrUseDate=$('#matadrUseDate').datebox('getValue');   
	if(!compareSelTimeAndCurTime(matadrUseDate)){
		$.messager.alert("提示:","【植入日期】不能大于当前时间！");
		return false;	
	}else if(matadrUseDate=="")
	{

	} else if(!compareSelTowTime(matadrProDate,matadrUseDate)){
		$.messager.alert("提示:","【生产日期】不能大于【植入日期】！")
		return false;
	}
	
	//停用日期
	var matadrDisDate=$('#matadrDisDate').datebox('getValue');
	if(matadrUseDate==""||matadrDisDate==""){
			
	}else if(!compareSelTowTime(matadrUseDate,matadrDisDate)){
		$.messager.alert("提示:","【植入日期】不能大于【停用日期】！");
		return false;	
	}
	else if(!compareSelTowTime(matadrProDate,matadrDisDate)){
		$.messager.alert("提示:","【生产日期】不能大于【停用日期】！")
		return false;
	}
	
	var MT1=$('#MT1').datebox('getValue');  
	if(!compareSelTimeAndCurTime(MT1)){
		$.messager.alert("提示:","【事件陈述】中【器械使用时间】不能大于当前时间！");
		return false;	
	} 
	var MT7=$('#MT7').datebox('getValue');
	if(!compareSelTimeAndCurTime(MT7)){
		$.messager.alert("提示:","【事件陈述】中【采取治疗措施时间】不能大于当前时间！");
		return false;	
	} 
	var MT9=$('#MT9').datebox('getValue');
	if(!compareSelTimeAndCurTime(MT9)){
		$.messager.alert("提示:","【事件陈述】中【不良事件好转时间】不能大于当前时间！");
		return false;	
	} 
	// 使用医疗器械与已发生/可能发生的伤害事件之间是否具有合理的先后顺序
	var matadrIfReaOrder="";
    $("input[type=checkbox][name=matadrIfReaOrder]").each(function(){
		if($(this).is(':checked')){
			matadrIfReaOrder=this.value;
		}
	})
	if(matadrIfReaOrder==""){
		$.messager.alert("提示:","【使用医疗器械与已发生/可能发生的伤害事件之间是否具有合理的先后顺序】不能为空！");
		return false;
	}
	// 发生/可能发生的伤害事件是否属于所使用医疗器械可能导致的伤害类型
	var matadrIfDamageType="";
    $("input[type=checkbox][name=matadrIfDamageType]").each(function(){
		if($(this).is(':checked')){
			matadrIfDamageType=this.value;
		}
	})
	if(matadrIfDamageType==""){
		$.messager.alert("提示:","【发生/可能发生的伤害事件是否属于所使用医疗器械可能导致的伤害类型】不能为空！");
		return false;
	}
	// 已发生/可能发生的伤害事件是否可以用合并用药的作用、患者病情或其他非医疗器械因素来解释
	var matadrIfReasonable="";
    $("input[type=checkbox][name=matadrIfReasonable]").each(function(){
		if($(this).is(':checked')){
			matadrIfReasonable=this.value;
		}
	})
	if(matadrIfReasonable==""){
		$.messager.alert("提示:","【已发生/可能发生的伤害事件是否可以用合并用药的作用、患者病情或其他非医疗器械因素来解释】不能为空！");
		return false;
	}
	
		
	return true;
}

//页面关联设置
function setCheckBoxRelation(id){
	if($('#'+id).is(':checked')){
		///医疗器械实际使用场所
		if(id=="UP99"){
			$('#matadrUsePlaceOth').attr("disabled",false);
		}		
		///事件后果
		if(id=="TR10"){
			//$('#matadrEventResult').attr("disabled",false);
			$('#matadrEventResultDate').datetimebox({disabled:false});
		}
	    ///操作人
		if(id=="OP99"){
			$('#matadrOperatorOth').attr("disabled",false);
		}    
	}else{
		///取消医疗器械实际使用场所
		if(id=="UP99"){
			$('#matadrUsePlaceOth').val("");
			$('#matadrUsePlaceOth').attr("disabled","true");
		}
		///取消事件后果
		if(id=="TR10"){
			//$('#matadrEventResult').val("");
			//$('#matadrEventResult').attr("disabled","true")
			$('#matadrEventResultDate').datetimebox('setValue',"");

		}	
	    ///操作人
		if(id=="OP99"){
			$('#matadrOperatorOth').val("");
			$('#matadrOperatorOth').attr("disabled","true");
		}    
	}
}
//在.js中新增function
function SetAdmTxtVal(rowData)
{
	EpisodeID=rowData.Adm;
	if(EpisodeID==undefined){
		EpisodeID=""
	}
	var matadrPatNo=$('#PatNo').val();
	var matadrPatNo=getRegNo(matadrPatNo);

	getMataRepPatInfo(matadrPatNo,EpisodeID);
}
//编辑窗体  zhaowuqiang  2016-09-22
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
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.repmanage.csp?RepID='+matadrID+'&RepType='+mataReportType+'"></iframe>';
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
//判断报告编码是否存在
function RepNoRepet(){
	var IDflag=0;
	if (matadrID==""){
		IDflag=0; 
	}else{
		IDflag=1; 
	}
	$('#repnoflag',window.parent.document).val(IDflag); //给父界面元素赋值
	/* //报告编码
	var matadrNo=$('#matadrNo').val();
	matadrNo=matadrNo.replace(/[ ]/g,""); //去掉编码中的空格
	$.ajax({
		type: "POST",// 请求方式
    	url: url,
    	data: "action=SeaMataRepNo&matadrNo="+matadrNo,
		async: false, //同步
		success: function(data){
			$('#repnoflag',window.parent.document).val(data); //给父界面元素赋值
		}
	}); */
}
//刷新界面 2016-09-26
function ReloadJs(){
	if ((adrDataList!="")||(frmflag==1)){
		frmflag=1;
	}else{
		frmflag=2;
	}
	window.location.href="dhcadv.matareport.csp?adrDataList="+""+"&frmflag="+frmflag;//刷新传参adrDataList为空
}
