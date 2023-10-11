
/**
*Description:	输血不良反应报告单
*Creator: 	cy	
*CreDate: 	2021-07-15	
**/
var RepDate=formatDate(0);			// 系统的当前日期
$(document).ready(function(){
	InitButton();					// 初始化按钮
	ReportControl();				// 表单控制 
	InitCheckRadio(); 	
	InitReport(recordId);			// 加载页面信息
	add_event();
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
	
}

// 表单控制
function ReportControl(){
	
	// 复选框按钮事件
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

	// 输血不良反应时间控制
	chkdate("AdvBloodSereaOccTime");

	/* 2018-06-06 有删除增加的table类型*/
	$(".dhc-table>tbody td>input").css({"margin-left":"-4px"})
	//输血开始日期控制
	$("input[id^='BloodGiveList-97701-97708-97715']").datetimebox().datetimebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	//输血结束日期控制
	$("input[id^='BloodGiveList-97701-97709-97716']").datetimebox().datetimebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
	///孕产史控制  sufan 2019-11-14
	// 孕 没有怀孕过即没有生产过
	$('input[id^="isPregnancy"][type="radio"]').click(function(){
		if($(this).val()=="否"){
			$('input[id^="isGive"][value="否"]').attr('checked','true');
		}
	})
	/// 产 生产过即怀孕过
	$('input[id^="isGive"][type="radio"]').click(function(){
		if($(this).val()=="是"){
			$('input[id^="isPregnancy"][value="是"]').attr('checked','true');
		}
	})
	TableControl();
	/// 受血者生命体征变化情况 测定时间 cy 2021-07-15
	chktime("BRVitSigns-99969-99987-99988","AdvBloodSereaOccTime");
	chktime("BRVitSigns-99970-100001-100009","AdvBloodSereaOccTime");
	chktime("BRVitSigns-99971-100017-100025","AdvBloodSereaOccTime");
	chktime("BRVitSigns-99972-100033-100041","AdvBloodSereaOccTime");
	chktime("BRVitSigns-99973-100049-100057","AdvBloodSereaOccTime");	
	
	/// 受血者生命体征变化情况 体温（℃） cy 2021-07-15
	chknum("BRVitSigns-99969-99989-99990",1,34,43);
	chknum("BRVitSigns-99970-100002-100010",1,34,43);
	chknum("BRVitSigns-99971-100018-100026",1,34,43);
	chknum("BRVitSigns-99972-100034-100042",1,34,43);
	chknum("BRVitSigns-99973-100050-100058",1,34,43);
	
	/// 受血者生命体征变化情况 呼吸（次/分） cy 2021-07-15
	chknum("BRVitSigns-99969-99991-99992",0,10,50);
	chknum("BRVitSigns-99970-100003-100011",0,10,50);
	chknum("BRVitSigns-99971-100019-100027",0,10,50);
	chknum("BRVitSigns-99972-100035-100043",0,10,50);
	chknum("BRVitSigns-99973-100051-100059",0,10,50);
	/// 受血者生命体征变化情况 脉搏（次/分） cy 2021-07-15
	chknum("BRVitSigns-99969-99993-99996",0,50,180);
	chknum("BRVitSigns-99970-100004-100012",0,50,180);
	chknum("BRVitSigns-99971-100020-100028",0,50,180);
	chknum("BRVitSigns-99972-100036-100044",0,50,180);
	chknum("BRVitSigns-99973-100052-100060",0,50,180);
	/// 受血者生命体征变化情况 血压（mmHg） cy 2021-07-15
	checkBP("BRVitSigns-99969-99994-99997");
	checkBP("BRVitSigns-99970-100005-100013");
	checkBP("BRVitSigns-99971-100021-100029");
	checkBP("BRVitSigns-99972-100037-100045");
	checkBP("BRVitSigns-99973-100053-100061");
	/// 受血者生命体征变化情况 血氧饱和度（%） cy 2021-07-15
	chknum("BRVitSigns-99969-99995-99998",0,68,100);
	chknum("BRVitSigns-99970-100006-100014",0,68,100);
	chknum("BRVitSigns-99971-100022-100030",0,68,100);
	chknum("BRVitSigns-99972-100038-100046",0,68,100);
	chknum("BRVitSigns-99973-100054-100062",0,68,100);

	// 症状缓解日期
	chkdate("SymRelDate");
	/// 症状发现时间
	chktime("SymDisTime","AdvBloodSereaOccTime");
	/// 实际输入量(ml)
	chknum("InputQuantity",0);
	/// 残余量(ml)
	chknum("Surplus",0);
	/// 事件发生时在岗责任护士人数
	chknum("OccuChaNurNum",0);
	/// 事件发生时病区在院患者人数
	chknum("OccuWardPatNum",0);
	
	
}

// 加载报表信息
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
		$.messager.alert($g("提示:"),$g("患者姓名为空，请输入登记号/病案号回车选择记录录入患者信息！"));	
		return false;
	}
	///保存前,对页面必填项进行检查
	if(!(checkother()&&checkRequired())){
		return;
	}
	SaveReportCom(flag);
}

//病人信息赋值（回车事件）
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
  	$("#from").form('validate'); 
}
function add_event(){
	//ReportControl();
	/* 2018-06-06 有删除增加的table类型*/
	$(".dhc-table>tbody td>input").css({"margin-left":"-4px"})
	 //日期
	 $("input[id^='BloodGiveList-97701-97708-97715']").each(function(){
		if((this.id.split("-").length==4)){
			var BloodDate=$("input[id^='"+this.id+"']").datebox("getValue");
			if (BloodDate!=""){
				$("#"+this.id).datebox("setValue",BloodDate);
			}else{
				$("input[id^='"+this.id+"']").datebox().datebox('calendar').calendar({
				validator: function(date){
					var now = new Date();
					return date<=now;
					}
				});
			}
		}
	}) 
	//发现日期
	 $("input[id^='BloodGiveList-97701-97709-97716']").each(function(){
		if((this.id.split("-").length==4)){
			var BloodDate=$("input[id^='"+this.id+"']").datebox("getValue");
			if (BloodDate!=""){
				$("#"+this.id).datebox("setValue",BloodDate);
			}else{
				$("input[id^='"+this.id+"']").datebox().datebox('calendar').calendar({
				validator: function(date){
					var now = new Date();
					return date<=now;
					}
				});
			}
		}
	}) 
	
	
	$("input[id^='BloodGiveList-97701-97703-97710']").live('keydown',function(event){	
		if(event.keyCode == "13"){
			if(EpisodeID==""){
				$.messager.alert($g('提示:'),$g('请先选择患者就诊记录！'));
				return;
			}
			ShowBldWin()
		}
    });
    TableControl();
	
}
function ShowBldWin(){
	
	$('#bldwin').show();
	$('#bldwin').window({
		title:$g('输血单列表'),
		collapsible:true,
		closed:"true",
		modal:true,
		minimizable: false, 
		maximizable: false,
		resizable: false,
		width:600,
		height:400
	}); 

	$('#bldwin').window('open');
	SetBldTxtVal(this.id);
}
//输血单 2016-10-25
function SetBldTxtVal(BloodGiveListID)
{
	
	var columns = [[
		{field:'issueId',title:$g('输血单ID'),width:60,hidden:true}, 
		{field:'issFormNo',title:$g('申请单号'),width:60,hidden:false}, 
		{field:'issueDate',title:$g('发放日期'),width:80}, 
		{field:'issueTime',title:$g('发放时间'),width:80},
		{field:'IsTransBlood',title:$g('是否有既往输血史'),width:80},
		{field:'IsReaction',title:$g('是否有输血反应史'),width:80},
		{field:'Parity',title:$g('孕次'),width:80},
		{field:'Gravidity',title:$g('产次'),width:80}
	]];
	//定义datagrid
	$('#bldgrid').datagrid({
		url:'dhcadv.repaction.csp'+'?action=GetPatBldRecordNew&EpisodeID='+EpisodeID,	
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:200,  // 每页显示的记录条数
		pageList:[200,400],   // 可以设置每页记录条数的列表
	    singleSelect:false,
		loadMsg: $g('正在加载信息...'),
		pagination:true,
		onDblClickRow: function (rowIndex, rowData) 
		{
			var issueId=rowData.issueId; //输血单id
			if((issueId!="")&&(issueId!=undefined)){
				$('#BB'+rowData.IsTransBlood).attr("checked",true); 	//继往输血史 BloodtransfusionHistory-label-97440
				if((rowData.IsTransBlood!="否")&&(rowData.Parity!=undefined)){
					$('#BloodtransfusionHistory-label-97440').attr("checked",true);//既往输血史 有
					$('#BloodtransfusionHistory-label-97440').nextAll(".lable-input").show();
				}else{
					$('#BloodtransfusionHistory-label-97443').attr("checked",true);//既往输血史 无
					$('#BloodtransfusionHistory-label-97440').nextAll(".lable-input").val("");
					$('#BloodtransfusionHistory-label-97440').nextAll(".lable-input").hide();
				}
				if((rowData.Parity!="0")&&(rowData.Parity!=undefined)){
					$('#isPregnancy-97293').attr("checked",true);//孕史 是
				}else{
					$('#isPregnancy-97294').attr("checked",true);//孕史 否
				}
				if ((rowData.Gravidity!="0")&&(rowData.Gravidity!=undefined)){
					$('#isGive-97307').attr("checked",true);//产史 是
				}else{
					$('#isGive-97308').attr("checked",true);//产史 否
				}
				
				GetbldBldTypedgInfo(issueId,BloodGiveListID);
			}
  			$('#bldwin').window('close');
		}
	});		 
	
}
			
//获取输血单信息初始化输血信息列表  2016-10-27
function GetbldBldTypedgInfo(issueId,BloodGiveListID)
{  
	var BldList="";
	//	血袋信息(血袋编号 ^ 血袋描述(血产品)^血型^配血方法^血袋血量)  若多条数据，以 $$ 进行分割
	runClassMethod("web.DHCADVINTERFACE","GetPatBldRecordPacksList",{'BldRecordId':issueId},
		function(val){ 
			BldList=val;
		},"text",false)
	if(BldList==""){
		$.messager.alert($g('提示:'),$g('该输血单无血袋信息，请重新选择！'));
		return;
	}
	var BldListArr=BldList.split("$$")
	var Bldlen=BldListArr.length; //输血记录个数 实际少1
	
	var num=0,rowid="",rownum="";
	$("input[id^='BloodGiveList-97701-97703-97710']").each(function(){
			num=num+1;
			if(num!=1){
				$(this).parent().parent().remove(); /// 删除之前的数据（第一行除外，第一行会被数据替换）
			}
			
	})
	for(var k=1;k<=Bldlen;k++){
		if(k>1){  // k>num
			$('a:contains("增加")').click(); //自动添加行数据
		}
	}
	$("input[id^='BloodGiveList-97701-97703-97710']").each(function(){
		if(rowid==""){
			rowid=this.id.split(".")[0];
		}else{
			rowid=rowid+"^"+this.id.split(".")[0];
		}
		if(rownum==""){
			rownum=this.id.split(".")[1];
		}else{
			rownum=rownum+"^"+this.id.split(".")[1];
		}
	})
	for(var k=0;k<Bldlen;k++){
		var BldpackID=BldListArr[k].split("^")[0]; //血袋编号
		var BloodProductName=BldListArr[k].split("^")[1]; //血袋描述(血产品)
		var BDType=BldListArr[k].split("^")[2].split("型")[0]+"型"; //血型
		var BDTypeHD=BldListArr[k].split("^")[2].split("型")[1]; //阴阳性
		var packVolumn=BldListArr[k].split("^")[4]; //血袋血量
		var rowidarr=rowid.split("^"),rownumarr=rownum.split("^");
		var value=$("input[id^='BloodGiveList-97701-97703-97710']input[id$='"+rownumarr[k]+"']").val();
		
		//if(value==""){
			$("input[id^='BloodGiveList-97701-97703-97710']input[id$='"+rownumarr[k]+"']").val(BldpackID);
			$("input[id^='BloodGiveList-97701-97704-97711']input[id$='"+rownumarr[k]+"']").val(BloodProductName);
			$("input[id^='BloodGiveList-97701-97705-97712']input[id$='"+rownumarr[k]+"']").val(BDType);
			$("input[id^='BloodGiveList-97701-97706-97713']input[id$='"+rownumarr[k]+"']").val(BDTypeHD);
			$("input[id^='BloodGiveList-97701-97707-97714']input[id$='"+rownumarr[k]+"']").val(packVolumn);
		//}
		if((BldList!="")&&(Bldlen==num)){ //部位计数与转归行数相同时，隐藏最后一行数据
			//$("input[id^='BloodGiveList-97701-97703-97710']input[id$='"+rownumarr[num]+"']").parent().parent().hide();
		}
		$("input[id^='"+rowidarr[k]+"']input[id$='"+rownumarr[k]+"']").attr('readonly','readonly')
		//$('a:contains("增加")').parent().hide();
		//$('a:contains("删除")').parent().hide();
	}
	TableControl();
			
}
function TableControl(){
	// 根据 是否允许手工输入医嘱 控制
	    $("[id^='BloodGiveList-97701-']").each(function(){
			var rowid=this.id.split(".")[0];
			var rownum=this.id.split(".")[1];
			if ((this.value=="")){
				if ((MKIOrdFlag!="1")&&(rowid!="BloodGiveList-97701-97703-97710")){
					$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				}else{
					$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",false);
				}
			}else{
				$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
			}
		})
		
}

//页面初始加载checkbox,radio控制子元素不可以填写
function InitCheckRadio(){
	//是否输血不良反应
	if($("input[type=radio][id='AdvBloodsereactions-97445']").is(':checked')){
		var DeathDate=$('#AdvBloodSereaOccTime').datebox('getValue');
		RepSetRead("AdvBloodSereaOccTime","datebox",0);
		RepSetValue("AdvBloodSereaOccTime","datebox",DeathDate); 	//输血不良反应时间
	}else{
		RepSetRead("AdvBloodSereaOccTime","datebox",1);
		$("#AdvBloodSereaOccTime").datebox("setValue","");  //并将值设置为空
	}
	// 输血不良反应发生时 - 是否检测  是 / 否
	if($("input[type=radio][id^='BRVitSigns-99969-99983-99985']").is(':checked')){
		$("input[type=input][id^='BRVitSigns-99969-']").attr("readonly",false);

	}else{
		$("input[type=input][id^='BRVitSigns-99969-']").val("");
		$("input[type=input][id^='BRVitSigns-99969-']").attr("readonly","readonly");
	}
	// 输血前最近一次 - 是否检测  是 / 否
	if($("input[type=radio][id^='BRVitSigns-99970-100000-100007']").is(':checked')){
		$("input[type=input][id^='BRVitSigns-99970-']").attr("readonly",false);

	}else{
		$("input[type=input][id^='BRVitSigns-99970-']").val("");
		$("input[type=input][id^='BRVitSigns-99970-']").attr("readonly","readonly");
	}
	// 输血开始15分钟内 - 是否检测  是 / 否
	if($("input[type=radio][id^='BRVitSigns-99971-100016-100023']").is(':checked')){
		$("input[type=input][id^='BRVitSigns-99971-']").attr("readonly",false);

	}else{
		$("input[type=input][id^='BRVitSigns-99971-']").val("");
		$("input[type=input][id^='BRVitSigns-99971-']").attr("readonly","readonly");
	}
	// 输血开始4小时内 - 是否检测  是 / 否
	if($("input[type=radio][id^='BRVitSigns-99972-100032-100039']").is(':checked')){
		$("input[type=input][id^='BRVitSigns-99972-']").attr("readonly",false);

	}else{
		$("input[type=input][id^='BRVitSigns-99972-']").val("");
		$("input[type=input][id^='BRVitSigns-99972-']").attr("readonly","readonly");
	}
	// 输血开始4小时后 - 是否检测  是 / 否
	if($("input[type=radio][id^='BRVitSigns-99973-100048-100055']").is(':checked')){
		$("input[type=input][id^='BRVitSigns-99973-']").attr("readonly",false);

	}else{
		$("input[type=input][id^='BRVitSigns-99973-']").val("");
		$("input[type=input][id^='BRVitSigns-99973-']").attr("readonly","readonly");
	}
	
	
	//体温-发热症状处理
	if($("#BRRctCliniMan-5324-5326").is(':checked')){
		$("label[id^='BRTreFever'").css("display","inline-block");
		$("label[id^='lableBRTreFever'").css("display","inline-block");
	}else{
		$("label[id^='lableBRTreFever'").css("display","none");
		$("label[id^='BRTreFever'").css("display","none");
	}

	
	//皮肤-过敏症状处理
	if($("#BRRctCliniMan-5325-5329").is(':checked')||$("#BRRctCliniMan-5325-5331").is(':checked')||$("#BRRctCliniMan-5325-5330").is(':checked')||$("#BRRctCliniMan-5325-5332").is(':checked')||$("#BRRctCliniMan-5325-5334").is(':checked')){
		$("label[id^='BRTreSkinAllergy'").css("display","inline-block");
	}else{
		$("label[id^='BRTreSkinAllergy'").css("display","none");
	}	
	
	//BRRctCliniMan-5325-5337 紫癜
	if($("#BRRctCliniMan-5325-5337").is(':checked')){
		$("label[id^='BRTreSkinPurpura'").css("display","inline-block");
	}else{
		$("label[id^='BRTreSkinPurpura'").css("display","none");
	}	
	//呼吸困难  BRRctCliniMan-5338-5339
	if($("#BRRctCliniMan-5338-5339").is(':checked')){
		$("label[id^='BRTreBreathing'").css("display","inline-block");
		$("label[id='BRTreBreathing-5397-5398-5400'").css("display","none");
	}else{
		$("label[id^='BRTreBreathing'").css("display","none");
	}
	
	
	//溶血症状 
	if($("#BRRctCliniMan-5371-5372").is(':checked')||$("#BRRctCliniMan-5371-5373").is(':checked')||$("#BRRctCliniMan-5371-5374").is(':checked')||$("#BRRctCliniMan-5371-5375").is(':checked')||$("#BRRctCliniMan-5371-5376").is(':checked')){
		$("label[id^='BRTreHemolysis'").css("display","inline-block");
	}else{
		$("label[id^='BRTreHemolysis'").css("display","none");
	}
	//特殊检查 BRStrarttype-5320
	if($("#BRStrarttype-5320").is(':checked')){
		$("label[id^='BRSpeInspection'").css("display","inline-block");
	}else{
		$("label[id^='BRSpeInspection'").css("display","none");
	}
	if($("#BRTreBreathing-5397-5398").is(':checked')){
		$("label[id='BRTreBreathing-5397-5398-5400'").css("display","inline-block");
	}else{
		$("label[id='BRTreBreathing-5397-5398-5400'").css("display","none");
	}
	
	/// 呼吸-呼吸困难处理-患者出现呼吸困难，请先对发生原因进行初步判断--类别1:TACO TRALI TAD 患者有无急性肺损伤危险因子 无 取消非 无 的勾选项的勾选
	if($("input[type=checkbox][id^='BRTreBreathing-5397-5398-5400-5403-").is(':checked')){
		if(id=="BRTreBreathing-5397-5398-5400-5403-5429"){
			$("input:not([id='BRTreBreathing-5397-5398-5400-5403-5429'])input[type=checkbox][id^='BRTreBreathing-5397-5398-5400-5403-']").removeAttr("checked");
		}else{
			$("#BRTreBreathing-5397-5398-5400-5403-5429").removeAttr("checked");
		}
	}
	/// 相关临床表现-皮肤
	if($("input[type=checkbox][id^='BRRctCliniMan-5325-").is(':checked')){
		/// 局部皮疹
		if(id=="BRRctCliniMan-5325-5331"){
			$("#BRRctCliniMan-5325-5332").removeAttr("checked");
		}
		/// 全身皮疹
		if(id=="BRRctCliniMan-5325-5332"){
			$("#BRRctCliniMan-5325-5331").removeAttr("checked");
		}
	}
	/// 相关临床表现-心血管
	if($("input[type=checkbox][id^='BRRctCliniMan-5362-").is(':checked')){
		/// 血压明显异常降低
		if(id=="BRRctCliniMan-5362-5365"){
			$("#BRRctCliniMan-5362-5364").removeAttr("checked");
		}
		/// 血压明显异常降高
		if(id=="BRRctCliniMan-5362-5364"){
			$("#BRRctCliniMan-5362-5365").removeAttr("checked");
		}
	}

}
///判断输血列表是否为空 sufan 2019-11-14
function checkother()
{
	//控制输血列表不能为空
	var ret=1
	$("input[id^='BloodGiveList-97701-97704-97711']").each(function(){
			if($(this).val()=="")
			{
				return true;
			}else{
				ret=0
			}
			
	})
	if(ret==1){
		if(MKIOrdFlag!="1"){
			$.messager.alert($g("提示:"),$g("请维护输血记录！（列表手动输入输血信息无效，需回车选择输血单）！"));
		}else{
			$.messager.alert($g("提示:"),$g("请维护输血记录！（列表输入输血信息少，需补充信息）！"));
		}
		return false;
		
	}
	///控制输血列表输血开始日期和结束日期
	var num=0,rowid="",rownum="";
	$("input[id^='BloodGiveList-97701-97703-97710']").each(function(){
			num=num+1;
	})
	$("input[id^='BloodGiveList-97701-97703-97710']").each(function(){
		if(rowid==""){
			rowid=this.id.split(".")[0];
		}else{
			rowid=rowid+"^"+this.id.split(".")[0];
		}
		if(rownum==""){
			rownum=this.id.split(".")[1];
		}else{
			rownum=rownum+"^"+this.id.split(".")[1];
		}
	})
	rownumarr=rownum.split("^");
	var clorec=0;
	for(var i=0;i<num;i++){
		var stDateTime=$("input[id^='BloodGiveList-97701-97708-97715'][id$='"+rownumarr[i]+"']").datetimebox('getValue');
		var endDateTime=$("input[id^='BloodGiveList-97701-97709-97716'][id$='"+rownumarr[i]+"']").datetimebox('getValue');
		if(!DateTimecontrast(stDateTime,endDateTime)){
			clorec=i+1;
			break;
		}
	}
	if(clorec>0){
		$.messager.alert($g("提示:"),$g("输血列表第")+clorec+$g("行输血开始时间大于输血结束时间！"));
		return false;
	}
	return true;
}
function DateTimecontrast(stDateTime,endDateTime)
{
	var ret=1;
	var reg = new RegExp(":","g")
	var stDate=stDateTime.split(" ")[0];
	var stTime=stDateTime.split(" ")[1]==undefined?"":stDateTime.split(" ")[1].replace(reg,"");
	var endDate=endDateTime.split(" ")[0];
	var endTime=endDateTime.split(" ")[1]==undefined?"":endDateTime.split(" ")[1].replace(reg,"");
	if(!compareSelTowTime(stDate,endDate)){
		ret=0;
	}else if((stDate==endDate)&&(stTime>endTime)){
		ret=0
	}else{
		ret=1;
	}
	return ret;
}
