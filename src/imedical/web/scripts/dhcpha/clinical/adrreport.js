
/// Creator: bianshuai
/// CreateDate: 2014-06-22

var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;font-size:12pt;font-family:华文楷体;color:red;">[双击行即可编辑]</span>';
var titleOpNotes='<span style="font-weight:bold;font-size:12pt;font-family:华文楷体;color:red;">[双击行添加/删除]</span>';
var adrEvtArr = [{"value":"S","text":'严重'}, {"value":"G","text":'一般'}];
var currEditRow="";currEditID="";adrRepID="";PatientID="";EpisodeID="";editFlag="";AdrRepInitStatDR="";currEditOeori="";
var disEditRow="";
///星号标示
var AstSymbol='<span style="color:red;">*</span>';

$(function(){
	PatientID=getParam("PatientID");
	EpisodeID=getParam("EpisodeID");
	adrRepID=getParam("adrRepID");
	editFlag=getParam("editFlag");
	
	//复选框分组
	InitUIStatus();
	
	/* 性别 */
	var patSexCombobox = new ListCombobox("PatSex",url+'?action=SelCTSex','',{panelHeight:"auto"});
	patSexCombobox.init();
	
	/* 民族 */
	var NationCombobox = new ListCombobox("PatNation",url+'?action=selNation','',{});
	NationCombobox.init();
	
	/* 医院 */
	var HospCombobox = new ListCombobox("Hospital",url+'?action=SelCTHospital','',{panelHeight:"auto"});
	HospCombobox.init();

	/* 单位名称 */
	var UnitCombobox = new ListCombobox("adrrRepDeptName",url+'?action=SelCTHospital','',{panelHeight:"auto"});
	UnitCombobox.init();
	
	/* 报告部门 */
	var RepDeptCombobox = new ListCombobox("adrrSignOfRepDept",url+'?action=SelAllLoc','',{});
	RepDeptCombobox.init();
		
	InitPageDatagrid();  ///初始化 怀疑/并用药品datagrid
	
	$('#disfind').click(function(){
		createDisWindow();
	})
	$('#adrEvtFind').click(function(){
		createAdrEvtWindow();
	})
	
	$('#adrrEventHistDesc').click(function(){
		createAdrEvtEHWindow();
	})
	
	$('#adrrEventFamiDesc').click(function(){
		createAdrEvtEFWindow();
	})
	
	//报告类型为严重时,弹出框
	$('#RT11').click(function(){
		if($('#'+this.id).is(':checked')){
			createAdrEvtRetWindow();
			$('#serdesc').val("");
		}else{
			$('#modser').css("display","none");
			$('#serdesc').css("display","none");
			$('#serdesc').val("");
		}
	})
	$('#modser').bind('click',createAdrEvtRetWindow); //修改严重情形描述
	
	if(adrRepID == ""){
		InitPatientInfo(PatientID,EpisodeID);
	}else{
		InitAdrReport(adrRepID);
	}
	
	$('input').live('click',function(){
		$("#"+currEditID).datagrid('endEdit', currEditRow);
	});

	$('#DateOccu').datebox({
		onSelect:function(date){
			if(!compareSelTimeAndCurTime($('#DateOccu').datebox('getValue'))){
				$.messager.alert("提示:","【不良反应/事件发生时间】不能大于当前时间！");
				$('#DateOccu').datebox('setValue',"");
			}
		}
	})
	
	//editFlag状态为0,隐藏提交和暂存按钮
	if(editFlag=="0"){
		$("a:contains('提交')").css("display","none");
		$("a:contains('暂存')").css("display","none");
	}
	
	//不良反应时间控制
	$('#DateOccu').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	
	//死亡时间控制
	$('#adrrEventRDRDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
})

///=====================================怀疑/并用药品datagrid===================================
function InitPageDatagrid(){
	
	//批号
	var serBatNoEditor={  //设置其为可编辑
		type: 'combobox', //设置编辑格式
		options: {
			//required: true, //设置编辑规则属性
			panelHeight:"auto",
			valueField: "value", 
			textField: "text",
			url: url+'?action=getBatNoList',
			onSelect:function(option){
				var ed=$('#'+currEditID).datagrid('getEditor',{index:currEditRow,field:'batnodr'});
				$(ed.target).val(option.value);  //设置科室ID
				var ed=$('#'+currEditID).datagrid('getEditor',{index:currEditRow,field:'batno'});
				$(ed.target).combobox('setValue', option.text);  //设置科室Desc
			},
			onBeforeLoad: function(param){
				/*
				if(currEditID != ""){
					var rows=$('#'+currEditID).datagrid('getRows');//获取所有当前加载的数据行
					param.oeori=rows[currEditRow].orditm;
				}
				*/
				param.oeori=currEditOeori;
			}
		}

	}
	
	//定义columns
	var columns=[[
		{field:"dgID",title:'dgID',width:90,hidden:true},
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
	    {field:'apprdocu',title:'批准文号',width:80},
	    {field:'incidesc',title:'商品名称',width:180},
		{field:'genenic',title:AstSymbol+'通用名称',width:100},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'formdr',title:'formdr',width:80,hidden:true},
		{field:'manf',title:AstSymbol+'生产厂家',width:100},
		{field:'manfdr',title:'manfdr',width:80,hidden:true},
		{field:'batnodr',title:'batnodr',editor:'text',hidden:true},
		{field:'batno',title:AstSymbol+'生产批号',width:80,editor:serBatNoEditor},
		{field:'usemethod',title:AstSymbol+'用法用量',width:140},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'dosqty',title:'dosqty',width:80,hidden:true},
		{field:'starttime',title:AstSymbol+'开始时间',width:80,editor:dateboxditor},
		{field:'endtime',title:AstSymbol+'结束时间',width:80,editor:dateboxditor},
		{field:'usereason',title:AstSymbol+'用药原因',width:100,editor:texteditor},
		{field:'operation',title:'<a href="#" onclick="patOeInfoWindow()"><img style="margin-left:3px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>',width:30,align:'center',
			formatter:SetCellUrl}
	]];
	
	//定义datagrid
	$('#susdrgdg').datagrid({
		title:'怀疑药品'+titleNotes,    
		url:'',
		border:false,
		columns:columns,
	    singleSelect:true,
	    remoteSort:false,
		loadMsg: '正在加载信息...',
	    onDblClickRow: rowhandleClick
	});

	//定义datagrid
	$('#blenddg').datagrid({
		title:'并用药品'+titleNotes,    
		url:'',
		border:false,
		columns:columns,
	    singleSelect:true,
	    remoteSort:false,
		loadMsg: '正在加载信息...',
	    onDblClickRow: rowhandleClick
	});
	
	//初始化显示横向滚动条
	InitdatagridRow('susdrgdg'); 
	InitdatagridRow('blenddg');
	var TipFieldList = "apprdocu^incidesc^genenic^manf^usereason";
	LoadCellTip(TipFieldList);
}

var rowhandleClick=function (rowIndex, rowData) {//双击选择行编辑
	currEditOeori = rowData.orditm;
	if ((currEditRow != "")||(currEditRow == "0")) {
		$("#"+currEditID).datagrid('endEdit', currEditRow);
	} 
	$("#"+this.id).datagrid('beginEdit', rowIndex);

	currEditID=this.id;
	currEditRow=rowIndex;
}

// 插入新行
function insertRow()
{
	$('#susdrgdg').datagrid('appendRow', {//在指定行添加数据，appendRow是在最后一行添加数据
		row: {
			orditm:'', phcdf:'', incidesc:'', genenic:'', 
	    	genenicdr:'', usemethod:'', dosuomID:'',
	    	instrudr:'', freqdr:'', durId:'', apprdocu:'', 
	    	manf:'', manfdr:'', formdr:''}
	});
}

// 删除行
function delRow(datagID,rowIndex)
{
	//行对象
    var rowobj={
		orditm:'', phcdf:'', incidesc:'', genenic:'', 
	    genenicdr:'', usemethod:'', dosuomID:'',
	    instrudr:'', freqdr:'', durId:'', apprdocu:'', 
	    manf:'', manfdr:'', formdr:'',starttime:'',endtime:'',
	    usereason:'',batno:''
	};
	
	//当前行数大于4,则删除，否则清空
	//var selItem=$('#'+datagID).datagrid('getSelected');
	//var rowIndex = $('#'+datagID).datagrid('getRowIndex',selItem);
	if(rowIndex=="-1"){
		$.messager.alert("提示:","请先选择行！");
		return;
	}
	var rows = $('#'+datagID).datagrid('getRows');
	if(rows.length>4){
		 $('#'+datagID).datagrid('deleteRow',rowIndex);
	}else{
		$('#'+datagID).datagrid('updateRow',{
			index: rowIndex, // 行索引
			row: rowobj
		});
	}
	
	// 删除后,重新排序
	$('#'+datagID).datagrid('sort', {	        
		sortName: 'incidesc',
		sortOrder: 'desc'
	});
}

/// 链接
function SetCellUrl(value, rowData, rowIndex)
{	
	var dgID='"'+rowData.dgID+'"';
	return "<a href='#' onclick='delRow("+dgID+","+rowIndex+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
}
///==============================================================================================
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

/// 保存不良反应事件填写报告
function saveAdrEventReport(flag)
{
	

	///保存前,对页面必填项进行检查
	if((flag)&&(!saveBeforeCheck())){
		return;
	}


	//1、报告优先级
	var adrrPriority="";
    $("input[type=checkbox][name=adrrPriority]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrPriority=this.value;
		}
	})
	
	//2、报告编码
	var adrrRepCode=$('#adrrRepCode').val();
	adrrRepCode=adrrRepCode.replace(/[ ]/g,""); //去掉编码中的空格

	//3、报告类型
	var adrrRepType="",adrrRepTypeNew="",adrrRepTSDesc="";
	if($("#new").is(':checked')){
		adrrRepTypeNew="Y";
	}
    $("input[type=checkbox][name=adrrRepType]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrRepType=this.value;
		}
	})
	
	//4、报告单位类别
	var adrrRepDeptType="";
	var adrrRepDeptTypeDesc="";
    $("input[type=checkbox][name=adrrRepDeptType]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrRepDeptType=this.value;
		}
	})
	adrrRepDeptTypeDesc=$('#RepDeptTypeOther').val();

	//5、病人信息
	var adrrPatID=$('#adrrPatID').val(); //病人ID
	var adrrPatName=$('#PatName').val(); //患者姓名
	var adrrPatSex=$('#PatSex').combobox('getValue');;  //性别
	var adrrPatAge=$('#PatAge').val();  //年龄
	var adrrPatDOB=$('#PatDOB').datebox('getValue');  //出生日期
	var adrrPatNation=$('#PatNation').combobox('getValue');  //民族
	var adrrPatWeight=$('#PatWeight').val();  //体重
	var adrrPatContact=$('#PatContact').val(); //联系方式
	
	//6、原患疾病
	var adrrPatOriginalDis=$('#adrrPatOriginalDis').val();
	
	//7、医院名称
	var adrrHospital=$('#Hospital').combobox('getText');
	
	//8、病历号/门诊号
	var adrrPatMedNo=$('#PatMedNo').val();
	
	//9、既往药品不良反应事件
	var adrrEventHistory="";
	var adrrEventHistoryDesc="";
	$("input[type=checkbox][name=adrrEventHistory]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventHistory=this.value;
		}
	})

	// 有的话取其描述
	if(adrrEventHistory=="10"){
		adrrEventHistoryDesc=$('#adrrEventHistDesc').val();
	}

	//10、家族药品不良反应事件
	var adrrEventFamily="";
	var adrrEventFamilyDesc=""; 
	$("input[type=checkbox][name=adrrEventFamily]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventFamily=this.value;
		}
	})
	// 有的话取其描述
	if(adrrEventFamily=="10"){
		adrrEventFamilyDesc=$('#adrrEventFamiDesc').val();
	}

	//11、事件名称
	var adrrAdrEvent=""; //$('#AdrEvent').val(); //DHC_PHAdrEvent DR

	//12、事件发生日期
	var adrrDateOccu=$('#DateOccu').datebox('getValue');

	//13、事件的结果
	var adrrEventResult="";
	var adrrEventResultDesc=""; //结果描述
	var adrrEventResultDate=""; //死亡日期
	$("input[type=checkbox][name=adrrEventResult]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventResult=this.value;
		}
	})
	// 后疑症表现
	if(adrrEventResult=="13"){
		adrrEventResultDesc=$('#adrrEventRSeqDesc').val();
	}

	// 直接死因
	if(adrrEventResult=="14"){
		adrrEventResultDesc=$('#adrrEventRDRDesc').val();
		adrrEventResultDate=$('#adrrEventRDRDate').datetimebox('getValue'); //死亡/好转日期
	}
	
	//14、好转(死亡)日期 时间
	var adrrEventDateResult="",adrrEventTimeResult="";
	if(adrrEventResultDate!=""){
		adrrEventDateResult=adrrEventResultDate.split(" ")[0];
		adrrEventTimeResult=adrrEventResultDate.split(" ")[1];
	}

	//15、停药后是否减轻
	var adrrEventStopResultt="";
    $("input[type=checkbox][name=adrrEventStopResultt]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventStopResultt=this.value;
		}
	})

	//16、再次使用时是否再次出现同样反应
	var adrrEventTakingAgain="";
    $("input[type=checkbox][name=adrrEventTakingAgain]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventTakingAgain=this.value;
		}
	})

	//17、对原疾病的影响
	var adrrEventEffectOfTreatment="";
    $("input[type=checkbox][name=adrrEventEffectOfTreatment]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventEffectOfTreatment=this.value;
		}
	})

	//18、关联性评价之报告人评价
	var adrrEventCommentOfUser="";
    $("input[type=checkbox][name=adrrEventCommentOfUser]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventCommentOfUser=this.value;
		}
	})

	var adrrEventUserOfReport=$('#adrrEventUserOfReport').val(); //报告人签字

	//19、关联性评价之报告单位评价
	var adrrEventCommentOfDept="";
    $("input[type=checkbox][name=adrrEventCommentOfDept]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventCommentOfDept=this.value;
		}
	})

	var adrrEventDeptOfReport=$('#adrrEventDeptOfReport').val(); //报单位签字

	//20、报告人信息
	var adrrReportUserTel=$('#adrrReportUserTel').val();  //报告人联系电话
	var adrrCareerOfRepUser=""; //报告人职业
	var adrrCareerOfRepUserDesc=""; //报告人职业描述
	$("input[type=checkbox][name=adrrCareerOfRepUser]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrCareerOfRepUser=this.value;
		}
	})
	// 其他
	if(adrrCareerOfRepUser=="99"){
		adrrCareerOfRepUserDesc=$('#adrrCareerOfRepUserOthers').val();
	}
	
	var adrrEmailOfRepUser=$('#adrrEmailOfRepUser').val(); //报告人邮箱
	var adrrSignOfRepUser=$('#adrrSignOfRepUser').val();   //报告人签名
	var adrrSignOfRepDept=$('#adrrSignOfRepDept').combobox('getValue'); //报告部门
	
	//21、报告单位信息
	var adrrRepDeptName=$('#adrrRepDeptName').combobox('getText');       //报告单位
	var adrrRepDeptContacts=$('#adrrRepDeptContacts').val(); //报告单位联系人
	var adrrRepDeptTel=$('#adrrRepDeptTel').val();           //报告单位联系电话
	var adrrRepDate=$('#adrrRepDate').datebox('getValue');   //报告日期
	if(adrrRepDate==""){
		$.messager.alert("提示:","报告日期不能为空！");
		return;
	}
	
	//22、生产企业
	var adrrProCompany="";
	var adrrProCompanyDesc="";
	$("input[type=checkbox][name=adrrProCompany]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrProCompany=this.value;
		}
	})
	// 其他
	if(adrrProCompany=="99"){
		adrrProCompanyDesc=$('#adrrProCompanyDesc').val();
	}

	//23、备注
	var adrrRepRemark=$('#adrrRepRemark').val(); //报告单位联系电话
	
	var adrAudStatusDr="";adrRepAuditList="";
	if(flag==1){
		adrAudStatusDr=AdrRepInitStatDR;  //初始状态
		adrRepAuditList=AdrRepInitStatDR+"^"+LgUserID;
	}
	
	var adrRepDataList=adrrRepCode+"^"+adrrPriority+"^"+adrrRepType+"^"+adrrRepDeptType+"^"+adrrRepDeptTypeDesc+"^"+adrrPatID;
	adrRepDataList=adrRepDataList+"^"+adrrPatName+"^"+adrrPatSex+"^"+adrrPatAge+"^"+adrrPatDOB+"^"+adrrPatNation+"^"+adrrPatWeight+"^"+adrrPatContact;
	adrRepDataList=adrRepDataList+"^"+adrrPatMedNo+"^"+adrrEventHistory+"^"+adrrEventHistoryDesc+"^"+adrrEventFamily+"^"+adrrEventFamilyDesc;
	adrRepDataList=adrRepDataList+"^"+adrrAdrEvent+"^"+adrrDateOccu+"^"+adrrEventResult+"^"+adrrEventResultDesc;
	adrRepDataList=adrRepDataList+"^"+adrrEventDateResult+"^"+adrrEventTimeResult+"^"+adrrEventStopResultt+"^"+adrrEventTakingAgain;
	adrRepDataList=adrRepDataList+"^"+adrrEventEffectOfTreatment+"^"+adrrEventCommentOfUser+"^"+adrrEventUserOfReport+"^"+adrrEventCommentOfDept+"^"+adrrEventDeptOfReport;
	adrRepDataList=adrRepDataList+"^"+adrrReportUserTel+"^"+adrrCareerOfRepUser+"^"+adrrCareerOfRepUserDesc+"^"+adrrEmailOfRepUser;
	adrRepDataList=adrRepDataList+"^"+adrrRepDeptName+"^"+adrrRepDeptContacts+"^"+adrrRepDeptTel+"^"+adrrRepDate+"^"+adrrProCompany+"^"+adrrProCompanyDesc;
	adrRepDataList=adrRepDataList+"^"+adrrRepRemark+"^"+adrrRepTSDesc+"^"+adrrRepTypeNew+"^"+adrAudStatusDr+"^"+adrrSignOfRepDept;
	
	//24、相关重要信息
	var smokhis="",drinhis="",gestper="",hepahis="",nephhis="",allehis="",iiothers="",iiothersdesc="";
    if($("#II10").is(':checked')){smokhis="10";}; //吸烟史
    if($("#II11").is(':checked')){drinhis="11";}; //饮酒史
    if($("#II12").is(':checked')){gestper="12";}; //妊娠期
    if($("#II13").is(':checked')){hepahis="13";}; //肝病史
    if($("#II14").is(':checked')){nephhis="14";}; //肾病史
    if($("#II15").is(':checked')){allehis="15";}; //过敏史
    if($("#II99").is(':checked')){ 	//其他
	    iiothers="99";
	    iiothersdesc=$('#iiothersdesc').val();
	};
	//患者重要信息
	var adrRepImpInfodataList=smokhis+"||"+drinhis+"||"+gestper+"||"+hepahis+"||"+nephhis+"||"+allehis+"||"+iiothers+"^"+iiothersdesc;
	
	//25、药品
	var tmpItmArr=[],phcItmStr="";
	//怀疑药品
	var suspItems = $('#susdrgdg').datagrid('getRows');
	$.each(suspItems, function(index, item){
		if(item.orditm!=""){
		    var tmp="10"+"^"+item.orditm+"^"+item.phcdf+"^"+item.apprdocu+"^"+trSpecialSymbol(item.incidesc)+"^"+item.genenicdr+"^"+
		    item.formdr+"^"+item.manfdr+"^"+trsUndefinedToEmpty(item.batno)+"^"+item.dosqty+"^"+item.dosuomID+"^"+item.instrudr+"^"+
		    item.freqdr+"^"+trsUndefinedToEmpty(item.starttime)+"^"+trsUndefinedToEmpty(item.endtime)+"^"+trsUndefinedToEmpty(item.reasondr)+"^"+
		    trsUndefinedToEmpty(item.usereason);
		    tmpItmArr.push(tmp);
		}
	})
	//并用药品
	var suspItems = $('#blenddg').datagrid('getRows');
	$.each(suspItems, function(index, item){
		if(item.orditm!=""){
		 	var tmp="11"+"^"+item.orditm+"^"+item.phcdf+"^"+item.apprdocu+"^"+trSpecialSymbol(item.incidesc)+"^"+item.genenicdr+"^"+
		  	item.formdr+"^"+item.manfdr+"^"+trsUndefinedToEmpty(item.batno)+"^"+item.dosqty+"^"+item.dosuomID+"^"+item.instrudr+"^"+
		  	item.freqdr+"^"+trsUndefinedToEmpty(item.starttime)+"^"+trsUndefinedToEmpty(item.endtime)+"^"+trsUndefinedToEmpty(item.reasondr)+"^"+
		    trsUndefinedToEmpty(item.usereason);
		  	tmpItmArr.push(tmp);
		 }
	})
	phcItmStr=tmpItmArr.join("!!");

	//26、原患疾病
	var MRCICItms=$('#MRCICItms').val();
	
	//27、不良反应事件
	var adrEvtItems=$('#AdrEventItms').val();
	if(adrEvtItems==""){
		adrEvtItems="^"+$('#AdrEvent').val()+"[]";
	}
	
	//28、不良反应/事件过程描述（包括症状、体征、临床检验等）及处理情况：
	var adrrTherapMeas=""; 	//$('#adrrTherapMeas').val();
	var adrrSymptom=""; 	//$('#adrrSymptom').val();
	var adrrOtherExplanation=""; //$('#adrrOtherExplanation').val();
	var adrrProcessDesc=$('#adrrProcessDesc').val();
	var adrrEvtProcessDesc=adrrTherapMeas+"^"+adrrSymptom+"^"+adrrOtherExplanation+"^"+adrrProcessDesc;

	var param="adrRepID="+adrRepID+"&adrRepDataList="+adrRepDataList+"&ImpInfo="+adrRepImpInfodataList+"&ItmStr="+phcItmStr;
	    param=param+"&MRCICItms="+MRCICItms+"&AdrEvtItems="+adrEvtItems+"&AdrEvtProcessDesc="+adrrEvtProcessDesc+"&adrRepAuditList="+adrRepAuditList; 
    
//保存
    $.ajax({
   	   type: "POST",
       url: url,
	   data: "action=saveAdrReport&"+param,
       success: function(jsonString){
	      var retObj = jQuery.parseJSON(jsonString);
	      if (retObj.ErrCode == "0") {      	
			 adrRepID=retObj.AdrRepID;
			 $('#adrrRepCode').val(retObj.AdrRepCode); //编号
			 if(flag==1){
				  $.messager.alert("提示:","提交成功！");	                 //liyarong 2016-10-09
				  $("a:contains('提交')").linkbutton('disable');
				  $("a:contains('暂存')").linkbutton('disable');
			}else if(flag==0){
				  $.messager.alert("提示:","暂存成功！");
			  }			 
	      }else{
		  	 $.messager.alert("提示:",val);
		  }
       },
       error: function(){
	       alert('链接出错');
	       return;
	   }
    });
}

/// 病人药品窗口
function patOeInfoWindow()
{
	$('#mwin').window({
		title:'病人用药列表',
		collapsible:true,
		border:false,
		closed:"true",
		width:1000,
		height:520
	}); 

	$('#mwin').window('open');
	InitPatMedGrid();
}

//初始化病人用药列表
function InitPatMedGrid()
{
	//定义columns
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'priorty',title:'优先级',width:80},
		{field:'StartDate',title:'开始日期',width:80},
		{field:'EndDate',title:'结束日期',width:80},
		{field:'incidesc',title:'名称',width:280},
		{field:'genenic',title:'通用名',width:160},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'dosage',title:'剂量',width:60},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'instru',title:'用法',width:80},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freq',title:'频次',width:40},
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'duration',title:'疗程',width:40},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'apprdocu',title:'批准文号',width:80},
		{field:'manf',title:'厂家',width:80},
		{field:'manfdr',title:'manfdr',width:80,hidden:true},
		{field:'form',title:'剂型',width:80},
		{field:'formdr',title:'formdr',width:80,hidden:true}
	]];

	/// 初始化 datagrid
	var option = {queryParams:{action:'GetPatOEInfo',params:EpisodeID}};
	var medListComponent = new ListComponent('medInfo', columns, url, option);
	medListComponent.Init();
}

//添加怀疑药品
function addSuspectDrg()
{
	///判断药品是否重复添加
    if(!AppBeforeCheck("susdrgdg")){return false;}
    
	//用药列表
	var rows = $('#susdrgdg').datagrid('getRows');
	for(var i=0;i<rows.length;i++){
		if(rows[i].orditm==""){
			break;
		}
	}
	
	var checkedItems = $('#medInfo').datagrid('getChecked');
	if(checkedItems.length==0){
		$.messager.alert("提示:","请选择待添加药品！");
		return;
	}
    $.each(checkedItems, function(index, item){
	    var rowobj={
			orditm:item.orditm, phcdf:item.phcdf, incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		    genenicdr:item.genenicdr, usemethod:item.dosage+"/"+item.instru+"/"+item.freq, dosuomID:item.dosuomID,
		    instrudr:item.instrudr, freqdr:item.freqdr, durId:item.durId, apprdocu:item.apprdocu,starttime:item.startdate,
		    endtime:item.enddate,manf:item.manf, manfdr:item.manfdr, formdr:item.formdr,dosqty:item.dosage,dgID:'susdrgdg'
		}

	    if((i>3)||(rows.length<=i)){
			$("#susdrgdg").datagrid('appendRow',rowobj);
		}else{
			$("#susdrgdg").datagrid('updateRow',{	//在指定行添加数据，appendRow是在最后一行添加数据
				index: i, // 行数从0开始计算
				row: rowobj
			});
		}
		i=i+1;
    })
    $.messager.alert("提示:","添加成功！");
    clsDrgWin();
}

//添加并用药品
function addMergeDrg()
{
	///判断药品是否重复添加
    if(!AppBeforeCheck("blenddg")){return false;}
	
	//用药列表
	var rows = $('#blenddg').datagrid('getRows');
	for(var i=0;i<rows.length;i++)
	{
		if(rows[i].orditm==""){
			break;
		}
	}
	
	var checkedItems = $('#medInfo').datagrid('getChecked');
	if(checkedItems.length==0){
		$.messager.alert("提示:","请选择待添加药品！");
		return;
	}
    $.each(checkedItems, function(index, item){
	    var rowobj={
			orditm:item.orditm, phcdf:item.phcdf, incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		    genenicdr:item.genenicdr, usemethod:item.dosage+"/"+item.instru+"/"+item.freq, dosuomID:item.dosuomID,
		    instrudr:item.instrudr, freqdr:item.freqdr, durId:item.durId, apprdocu:item.apprdocu,starttime:item.startdate, 
		    endtime:item.enddate,manf:item.manf, manfdr:item.manfdr, formdr:item.formdr,dosqty:item.dosage,dgID:'blenddg'
		}
	    if((i>3)||(rows.length<=i)){
			$("#blenddg").datagrid('appendRow',rowobj);
		}else{
			$("#blenddg").datagrid('updateRow',{	//在指定行添加数据，appendRow是在最后一行添加数据
				index: i, // 行数从0开始计算
				row: rowobj
			});
		}
		i=i+1;
    })
    $.messager.alert("提示:","添加成功！");
    clsDrgWin();
}

//初始化列表使用
function InitdatagridRow(id)
{
	for(var k=0;k<4;k++)
	{
		$('#'+id).datagrid('insertRow',{
			index: 0, // 行索引
			row: {
				orditm:'', phcdf:'', incidesc:'', genenic:'', 
			    genenicdr:'', usemethod:'', dosuomID:'',
			    instrudr:'', freqdr:'', durId:'', apprdocu:'', 
			    manf:'', manfdr:'', formdr:'',dgID:id
			}
		});
	}
}

//关闭病人用药窗口
function clsDrgWin()
{
	$('#mwin').window('close');
}

//疾病录入
function createDisWindow()
{
	$('#diswin').window({
		title:'疾病项目列表'+titleOpNotes,
		collapsible:true,
		border:false,
		closed:"true",
		width:860,
		height:520
	}); 

	$('#diswin').window('open');
	InitDisWinPanel();
	//清空datagrid
    $('#dislist').datagrid('loadData', {total:0,rows:[]});
    $('#seldislist').datagrid('loadData', {total:0,rows:[]});
}

///初始化疾病项目窗口
function InitDisWinPanel()
{
	var columns=[[
		 {field:'MRCID',title:'MRCID',width:40},   
		 {field:'MRCDesc',title:'描述',width:300,editor:texteditor}
	]];
  
  	/// 初始化原患疾病 datagrid
	var option = {onDblClickRow:disListClick,singleSelect:true};
	var disListComponent = new ListComponent('dislist', columns, '', option);
	disListComponent.Init();

  	/// 初始化原患疾病已选 datagrid
	var option = {
		singleSelect:true,
		toolbar: [{
			text:'确认',
			iconCls: 'icon-ok',
			handler: function(){
				var disItemArr=[],disItemDescArr=[],disItems="";
				var items = $('#seldislist').datagrid('getRows');
				$.each(items, function(index, item){
					var row = $('#seldislist').datagrid('getRowIndex',item); 
					$('#seldislist').datagrid('endEdit',row); 
					if(item.MRCDesc!=""){
						disItemArr.push(item.MRCID+"^"+item.MRCDesc);
						disItemDescArr.push(item.MRCDesc);
					}
				})
				disItems=disItemArr.join("||");
				$('#adrrPatOriginalDis').val(disItemDescArr.join(","));
				$('#MRCICItms').val(disItems);
				$('#diswin').window('close');
			}
		},{
			text:'添加空行',
			iconCls: 'icon-add',
			handler: function(){
				if(disEditRow>="0"){
					$("#seldislist").datagrid('endEdit', disEditRow);//结束编辑，传入之前编辑的行
				}
				$("#seldislist").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
					index: 0, // 行数从0开始计算
					row: {MRCID: '',MRCDesc:''}
				});
				$("#seldislist").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
				disEditRow=0;
			}
		}],
		onDblClickRow:function(rowIndex, rowData){
			 $('#seldislist').datagrid('deleteRow',rowIndex);
		}
	};
	var selDisListComponent = new ListComponent('seldislist', columns, '', option);
	selDisListComponent.Init();
    //将疾病名称文本框清空
	$('#textAlise').val('');
	//疾病名称回车事件
	$('#textAlise').bind('keypress',function(event){
		if(event.keyCode == "13"){
			var input=$.trim($("#textAlise").val());
			if (input!=""){
				$('#dislist').datagrid({
                                        pageNumber:1,  //赵武强  使每次查询都从第一页开始
					url:url+'?action=GetMRCICDDx',	
					queryParams:{
						params:input
					}
				});
			}	
		}
	});
	modAdrDisList(); //加载已经存在的原患疾病列表
}

/// 添加input数据到datagrid
function modAdrDisList()
{
	if($('#MRCICItms').val()==""){return;}
	var MRCICItms=$('#MRCICItms').val(); //获取已存在不良反应名称
	var MRCICItmsArr=MRCICItms.split("||");
	var tempArr=[];
	for(var i=0;i<MRCICItmsArr.length;i++){
		var MRCItmArr=MRCICItmsArr[i].split("^");
		tempArr.push("{\"MRCID\":\""+MRCItmArr[0]+"\",\"MRCDesc\":\""+MRCItmArr[1]+"\"}");		
	}
	var jsdata = '{"total":'+MRCICItmsArr.length+',"rows":['+tempArr.join(",")+']}';
	var data = $.parseJSON(jsdata);
	$('#seldislist').datagrid("loadData",data);//将数据绑定到DataGrid中
}

/// 点击事件
function disListClick(rowIndex, rowData)
{
	if(disEditRow>="0"){
		$("#seldislist").datagrid('endEdit', disEditRow);//结束编辑，传入之前编辑的行
	}

	var tmpMRCID=rowData.MRCID;
	var tmpMRCDesc=rowData.MRCDesc;

	 $('#seldislist').datagrid('insertRow',{
		 index: 0,	// index start with 0
		 row: {
			MRCDesc: tmpMRCDesc,
			MRCID: tmpMRCID
		}
     });	
}

//不良反应事件
function createAdrEvtWindow()
{
	$('#AdrEvtWin').window({
		title:'不良反应事件'+titleOpNotes,
		collapsible:true,
		border:false,
		closed:"true",
		width:860,
		height:520
	}); 

	$('#AdrEvtWin').window('open');
	InitAdreEvtwinWinPanel();
	 $('#seladrevtlist').datagrid('loadData', {total:0,rows:[]});
}

///初始化不良反应事件窗口
function InitAdreEvtwinWinPanel()
{
	var adrEvtEditRow=""; //当前编辑行
	var columns=[[
		{field:'AdrEvtID',title:'AdrEvtID',width:40},   
		{field:'AdrEvtDesc',title:'不良反应名称',width:300,editor:texteditor}
	]];
  
    /// 初始化不良反应 datagrid
	var option = {onDblClickRow:function(rowIndex, rowData){ 
			if(adrEvtEditRow>="0"){
				$("#seladrevtlist").datagrid('endEdit', adrEvtEditRow);//结束编辑，传入之前编辑的行
			}
			var tmpAdrEvtID=rowData.AdrEvtID;
			var tmpAdrEvtDesc=rowData.AdrEvtDesc;
			 //zhaowuqiang  2016-09-13
			var items = $('#seladrevtlist').datagrid('getRows');
			var quitflag=0;
			$.each(items, function(index, item){
					if(typeof item.AdrEvtSerLvID=="undefined"){
						$.messager.alert("提示:","不良反应严重程度不能为空！");
						quitflag=1;
						return;
					}		
			})
			if(quitflag==0){
				var temp=$('#seladrevtlist').datagrid('insertRow',{
				index: 0,	// index start with 0
				 row: {AdrEvtDesc: tmpAdrEvtDesc,AdrEvtID: tmpAdrEvtID}
	         		}).datagrid('getRows').length;
	         	$("#seladrevtlist").datagrid('beginEdit',temp)
			}
		},singleSelect:true
	};
	var tmpurl=url+'?action=GetAdrEvent'
	var adrEvtListComponent = new ListComponent('adrevtlist', columns, tmpurl, option);
	adrEvtListComponent.Init();
    $('#adrevtlist').datagrid('load',{params:""}); 
	//严重级别
	var serLvEditor={  //设置其为可编辑
		type: 'combobox',//设置编辑格式
		options: {
			data:adrEvtArr,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#seladrevtlist").datagrid('getEditor',{index:adrEvtEditRow,field:'AdrEvtSerLvID'});
				$(ed.target).val(option.value);  //设置科室ID
				var ed=$("#seladrevtlist").datagrid('getEditor',{index:adrEvtEditRow,field:'AdrEvtSerLvDesc'});
				$(ed.target).combobox('setValue', option.text);  //设置科室Desc
			} 
		}
	}
	var columns=[[
		{field:'AdrEvtID',title:'AdrEvtID',width:40},   
		{field:'AdrEvtDesc',title:'不良反应名称',width:300,editor:texteditor},
		{field:'AdrEvtSerLvID',title:'AdrEvtSerLvID',width:60,editor:texteditor},
		{field:'AdrEvtSerLvDesc',title:'严重程度',width:100,editor:serLvEditor}
	]];
	
	var option = {	
        singleSelect:true,
		toolbar: [{
			text:'确认',
			iconCls: 'icon-ok',
			handler: function(){
				var adrEvtItemArr=[],adrEvtItmDescArr=[],adrEvtItems="";
				var items = $('#seladrevtlist').datagrid('getRows');
				var quitflag=0;
				$.each(items, function(index, item){
					var row = $('#seladrevtlist').datagrid('getRowIndex',item); 
					$('#seladrevtlist').datagrid('endEdit',row);
					
					if(typeof item.AdrEvtSerLvID=="undefined"){
						$.messager.alert("提示:","不良反应严重程度不能为空！");
						quitflag=1;
						return;
					}
					if(item.AdrEvtDesc!=""){
						adrEvtItemArr.push(item.AdrEvtID+"^"+item.AdrEvtDesc+"["+item.AdrEvtSerLvDesc+"]");
						adrEvtItmDescArr.push(item.AdrEvtDesc+"["+item.AdrEvtSerLvDesc+"]");
					}
				})
				if(quitflag==1){return;}
				adrEvtItems=adrEvtItemArr.join("||");
				$('#AdrEvent').val(adrEvtItmDescArr.join(","));
				$('#AdrEventItms').val(adrEvtItems);
				$('#AdrEvtWin').window('close');
			}
		},{
			text:'添加空行',
			iconCls: 'icon-add',
			handler: function(){
				if(adrEvtEditRow>="0"){
					$("#seladrevtlist").datagrid('endEdit', adrEvtEditRow);//结束编辑，传入之前编辑的行
				}
				//zhaowuqiang 2016-09-13
				var items = $('#seladrevtlist').datagrid('getRows');
				var quitflag=0;
				$.each(items, function(index, item){
					if(typeof item.AdrEvtSerLvID=="undefined"){
						$.messager.alert("提示:","不良反应严重程度不能为空！");
						quitflag=1;
						return;
					}		
				})
				if(quitflag==0){
						var temp=$("#seladrevtlist").datagrid('insertRow',{//在指定行添加数据，appendRow是在最后一行添加数据
						index: 0, // 行数从0开始计算
						row: {AdrEvtID: '',AdrEvtDesc:''}
						}).datagrid('getRows').length-items.length;
						$('#seladrevtlist').datagrid('beginEdit',temp)

						adrEvtEditRow=0;
				}
			}
		}],
		onDblClickRow:function(rowIndex, rowData){
			 $('#seladrevtlist').datagrid('deleteRow',rowIndex);
		},
		onClickRow:function(rowIndex, rowData){
			if(adrEvtEditRow==""){
				$("#seladrevtlist").datagrid('endEdit', adrEvtEditRow);  //赵武强  2016-09-09
				}
			if (adrEvtEditRow !="") {
				$("#seladrevtlist").datagrid('endEdit', adrEvtEditRow); 
				var rows = $("#seladrevtlist").datagrid('getSelections');
				if(rows[adrEvtEditRow].AdrEvtSerLvID==undefined){
					alert("严重程度  不可为空");
					return ;
				}
			}
			 $("#seladrevtlist").datagrid('beginEdit',rowIndex);//开启编辑并传入要编辑的行
			 adrEvtEditRow=rowIndex;
		}
	}
	
	var selAdrEvtListComponent = new ListComponent('seladrevtlist', columns, '', option);
	selAdrEvtListComponent.Init();
 
  $('#textAdrEvtAlise').val("");
	//不良反应/事件名称回车事件
	$('#textAdrEvtAlise').bind('keypress',function(event){
		if(event.keyCode == "13"){
			var input=$.trim($("#textAdrEvtAlise").val());
			if (input!=""){
				$('#adrevtlist').datagrid({
					url:url+'?action=GetAdrEvent',	
					queryParams:{
						params:input
					}
				});
			}	
		}
	});
	modAdrEvtList(); //加载已经选择的反应信息
}

/// 加载已经选择的反应信息
function modAdrEvtList()
{
	if($('#AdrEventItms').val()==""){return;}
	var adrEventItms=$('#AdrEventItms').val(); //获取已存在不良反应名称
	var adrEventItmArr=adrEventItms.split("||");
	var tempArr=[];
	for(var i=0;i<adrEventItmArr.length;i++){
		var adrEvtItmArr=adrEventItmArr[i].split("^");
		var adrEvtItmDesc=adrEvtItmArr[1].split("[")[0];
		var adrEvtItmSerLvDesc=adrEvtItmArr[1].split("[")[1].replace(/]$/gi,"");
        AdrEvtSerLvID="G"
		if (adrEvtItmSerLvDesc=="严重")
		{
			AdrEvtSerLvID="S";
		}
		tempArr.push("{\"AdrEvtID\":\""+adrEvtItmArr[0]+"\",\"AdrEvtDesc\":\""+adrEvtItmDesc+"\",\"AdrEvtSerLvID\":\""+AdrEvtSerLvID+"\",\"AdrEvtSerLvDesc\":\""+adrEvtItmSerLvDesc+"\"}");		
	}
	var jsdata = '{"total":'+adrEventItmArr.length+',"rows":['+tempArr.join(",")+']}';
	var data = $.parseJSON(jsdata);
	$('#seladrevtlist').datagrid("loadData",data);//将数据绑定到DataGrid中
}

/// 严重药品不良反应的损害情形窗口
function createAdrEvtRetWindow()
{
	$('#AdrEvtRetWin').window({
		title:'严重药品不良反应的损害情形',
		collapsible:false,
		border:false,
		closed:false,
		width:500,
		height:300,
		onClose:function(){
			$("input[type=checkbox]").each(function(){
				if($('#'+this.id).is(':checked')){
					$('#serdesc').val($('#'+this.id+"S").html());
					$('#modser').css("display","");
					$('#serdesc').css("display","");
				}
			});

			if($('#serdesc').val()==""){
				$.messager.alert("提示:","选择严重时,必须勾选严重情形!");
				return false;
			}
		}
	}); 

	$('#AdrEvtRetWin').window('open');
}

//加载报表信息
function InitAdrReport(adrRepID)
{
	if(adrRepID==""){return;}
		
	var adrRepDataList="";
	//获取报表信息
	$.ajax({
   	    type: "POST",
        url: url,
	    data: {action:'getAdrRepInfo',adrRepID:adrRepID},
        success: function(jsonString){
	        var adrRepObj = jQuery.parseJSON(jsonString);
		    $('#adrRepID').val(adrRepObj.adrRepID);    //报表ID
		    $('#adrrRepCode').val(adrRepObj.adrRepNo); //编号
			if (adrRepObj.adrRepPri == "10"){             //优先级
				$('#firrep').attr("checked",'true');
			}
			if(adrRepObj.adrRepPri == "11"){
				$('#trarep').attr("checked",'true'); 
			}
	
			//是否新的
			if(adrRepObj.adrRepNew == "Y"){
				$('#new').attr("checked",'true'); 
			}
			
			//报告类型
			$('#RT'+adrRepObj.adrRepType).attr("checked",'true'); 
			if(adrRepObj.adrRepType == "11"){  //严重情形描述
				$('#modser').css("display","");
				$('#serdesc').css("display","");
				$('#serdesc').val(adrRepObj.adrrRepTSDesc); 
			}
				
			//报告单位类别
			$('#RD'+adrRepObj.adrrDeptType).attr("checked",'true'); 
			$('#RepDeptTypeOther').val(adrRepObj.adrrDeptElse);
			if(adrRepObj.adrrDeptType == "99"){
				$('#RepDeptTypeOther').attr("disabled",false);
			}
			
			//病人信息
			$('#adrrPatID').val(adrRepObj.adrrPatID); //病人ID
			$('#PatName').val(adrRepObj.adrrPatName);   //患者姓名
			$('#PatSex').combobox('setValue',adrRepObj.adrrPatSex);     //性别
			$('#PatAge').val(adrRepObj.adrrPatAge);  //年龄
			$('#PatDOB').datebox("setValue",adrRepObj.adrrPatDOB);      //出生日期
			$('#PatNation').combobox('setValue',adrRepObj.adrrPatNation);  //民族
			$('#PatWeight').val(adrRepObj.adrrPatWeight);  //体重
			$('#PatContact').val(adrRepObj.adrrPatContact); //联系方式
			$('#PatMedNo').val(adrRepObj.adrrPatMedNo);   //病历号
			
			//既往药品不良事件
			$('#EH'+adrRepObj.adrrEvtHis).attr("checked",'true'); 
			$('#adrrEventHistDesc').val(adrRepObj.adrrEvtHisDesc); 
			if(adrRepObj.adrrEvtHis == "10"){
				$('#adrrEventHistDesc').attr("disabled",false);
			}
			
			//家族药品不良事件
			$('#EF'+adrRepObj.adrrEvtFam).attr("checked",'true'); 
			$('#adrrEventFamiDesc').val(adrRepObj.adrrEvtFamDesc); 
			if(adrRepObj.adrrEvtFam == "10"){
				$('#adrrEventFamiDesc').attr("disabled",false);
			}
			
			//事件结果
			$('#DateOccu').datebox("setValue",adrRepObj.adrrEvtDateOcc);
			$('#RR'+adrRepObj.adrrEvtRes).attr("checked",'true'); 
			if(adrRepObj.adrrEvtRes == "13"){
				$('#adrrEventRSeqDesc').val(adrRepObj.adrrEvtResDesc);
				$('#adrrEventRSeqDesc').attr("disabled",false);
			}else if(adrRepObj.adrrEvtRes == "14"){
				$('#adrrEventRDRDesc').val(adrRepObj.adrrEvtResDesc);
				$('#adrrEventRDRDesc').attr("disabled",false);
				$('#adrrEventRDRDate').datebox({disabled:false});
				//死亡时间
				$('#adrrEventRDRDate').datetimebox('setValue',adrRepObj.adrrEvtDRes+" "+adrRepObj.adrrEvtTRes);
			};
				
			//停药或减量后，反应/事件是否消失或减轻
			$('#ES'+adrRepObj.adrrEvtSRes).attr("checked",'true'); 
			
			//再次使用可疑药品后是否再次出现同样反应/事件
			$('#ET'+adrRepObj.adrrEvtTakAg).attr("checked",'true'); 
			
			//对原患疾病的影响
			$('#RE'+adrRepObj.adrrEvtEff).attr("checked",'true'); 
			
			//填报人评价
			$('#ECU'+adrRepObj.adrrEvtCUser).attr("checked",'true'); 
			$('#adrrEventUserOfReport').val(adrRepObj.adrrEvtRepUser);
				
			//报告单位评价
			$('#ECD'+adrRepObj.adrrEvtCDept).attr("checked",'true'); 
			$('#adrrEventDeptOfReport').val(adrRepObj.adrrEvtRepDept);
				
			//报告人信息
			$('#adrrReportUserTel').val(adrRepObj.adrrEvtUserOfRepTel);
			$('#RU'+adrRepObj.adrrEvtCarOfRepUser).attr("checked",'true'); 
			$('#adrrCareerOfRepUserOthers').val(adrRepObj.adrrEvtCarOfRepElse);
			$('#adrrEmailOfRepUser').val(adrRepObj.adrrEvtEOfRepUser);
			$('#adrrSignOfRepUser').val(adrRepObj.adrrEvtProDeptCon);
			$('#adrrSignOfRepDept').combobox('setValue',adrRepObj.adrrEvtProDeptID);
			if(adrRepObj.adrrEvtCarOfRepUser == "99"){
				$('#adrrCareerOfRepUserOthers').attr("disabled",false);
			} 
				
			//报告单位
			$('#adrrRepDeptName').combobox('setValue',adrRepObj.HospID);
			$('#adrrRepDeptContacts').val(adrRepObj.adrrEvtProDeptCon);
			$('#adrrRepDeptTel').val(adrRepObj.adrrEvtProDeptTel);
			
			$('#adrrRepRemark').val(adrRepObj.adrrEvtRemark);//备注
			$('#adrrRepDate').datebox("setValue",adrRepObj.adrRepDate); 	 //报告日期
			EpisodeID=adrRepObj.adrRepPaAdm; //病人ADM
			
			//医院名称
			$('#Hospital').combobox('setValue',adrRepObj.HospID);
			AdrRepInitStatDR=adrRepObj.adrrEvtInitStatDR;
			//editFlag状态为0,提交和暂存按钮不可用
			var adrRepCurStatDR=adrRepObj.adrrEvtCurStatDR;
			if(adrRepCurStatDR!=""){
				//$("a:contains('提交')").attr("disabled",true);
				$("a:contains('暂存')").attr("disabled",true);
			}
				
			//原患疾病
			$('#adrrPatOriginalDis').val(adrRepObj.adrRepDiagDesc);
			$('#MRCICItms').val(adrRepObj.adrRepDiagList);
			
			//不良反应
			$('#AdrEvent').val(adrRepObj.adrRepEvtDesc);
			$('#AdrEventItms').val(adrRepObj.adrRepEvtList);
				
			var adrRepImpInfo=adrRepObj.adrRepImpInfo;
			adrRepImpInfoArr=adrRepImpInfo.split("||");
			for(var k=0;k<adrRepImpInfoArr.length;k++){
				var tmpstr=adrRepImpInfoArr[k].split("^");
				$('#II'+tmpstr[0]).attr("checked",'true'); 
				if(tmpstr[0]=="99"){
					$('#iiothersdesc').val(tmpstr[1]);
					$('#iiothersdesc').attr("disabled",false);
				}
			}
			
			//不良反应过程描述
			var adrRepProcDesc=adrRepObj.adrRepProcDesc;
			var adrRepProcArr=adrRepProcDesc.split("^");
			$('#adrrProcessDesc').val(adrRepProcArr[3]);

       },
       error: function(){
	       alert('链接出错');
	       return;
	   }
    });
    
    //怀疑和并用考虑合并在一起,暂时先分开取数据
	$('#susdrgdg').datagrid({
		url:url+'?action=getAdrRepDrgItm&adrRepID='+adrRepID,	
		queryParams:{
			params:10
		}
	});
	
	//并用
	$('#blenddg').datagrid({
		url:url+'?action=getAdrRepDrgItm&adrRepID='+adrRepID,	
		queryParams:{
			params:11
		}
	});
}

//加载报表默认信息
function InitPatientInfo(PatientID,EpisodeID)
{
	if(EpisodeID==""){return;}
		$.ajax({
			type: "POST",
			url: url+'?action=GetPatEssInfo',
			data: {PatientID:PatientID,EpisodeID:EpisodeID},
			success: function(jsonString){

				var PatientInfoObj = jQuery.parseJSON(jsonString);
				//病人信息
				$('#adrrPatID').val(PatientInfoObj.PatientID); //病人ID
				$('#PatName').val(PatientInfoObj.patname); //患者姓名
				$('#PatSex').combobox('setValue',PatientInfoObj.sexId);  //性别
				$('#PatAge').val(PatientInfoObj.patage);  //年龄
				$('#PatDOB').datebox("setValue",PatientInfoObj.patdob);  //出生日期
				$('#adrrPatOriginalDis').val(PatientInfoObj.patdiag);  	 //原患疾病
				var patdiagArrList = [];
				var patdiagArr = PatientInfoObj.patdiag.split(",");
				for(var k=0; k<patdiagArr.length; k++){
					patdiagArrList.push("^"+patdiagArr[k]);
				}
				$('#MRCICItms').val(patdiagArrList.join("||"));
				$('#PatNation').combobox('setValue',PatientInfoObj.nationdr);  //民族
				$('#PatMedNo').val(PatientInfoObj.patno); //病历号
				$('#PatWeight').val(PatientInfoObj.weight);  //体重
				$('#PatContact').val(PatientInfoObj.modphone); //联系方式
				$('#Hospital').combobox('setValue',LgHospID);   //医院名称
				$('#adrrRepDeptName').combobox('setValue',LgHospID); //报告单位
				$('#adrrRepDate').datebox("setValue",PatientInfoObj.sysdate); //报告日期
				$('#adrrEventUserOfReport').val(LgUserName);   //报告人评价
				$('#adrrSignOfRepUser').val(LgUserName);       //报告人信息
				$('#adrrRepDeptContacts').val(LgUserName);     //联系人
				$('#adrrSignOfRepDept').combobox('setValue',LgCtLocID);     //报告部门
				$('#adrrEventRDRDate').datebox({disabled:true}); //死亡时间
				AdrRepInitStatDR = PatientInfoObj.adrrEvtInitStatDR;
				$('#RD10').attr("checked",'true');  //报告单位类别默认为医疗机构
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

///保存前,进行数据完成性检查
function saveBeforeCheck()
{
	if(currEditRow >= 0){
		$("#"+currEditID).datagrid('endEdit', currEditRow);
	}
	//1、报告优先级
	var adrrPriority="";
    $("input[type=checkbox][name=adrrPriority]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrPriority=this.value;
		}
	})
	if(adrrPriority==""){
		$.messager.alert("提示:","【报告优先级】不能为空！");
		return false;
	}
	
	//2、报告编码
	var adrrRepCode=$('#adrrRepCode').val();
	if(adrrRepCode==""){
		//$.messager.alert("提示:","【报告编码】不能为空！");
		//return false;
	}
	adrrRepCode=adrrRepCode.replace(/[ ]/g,""); //去掉编码中的空格

	//3、报告类型
	var adrrRepType="",adrrRepTSDesc="",adrrRepTypeNew="";
    $("input[type=checkbox][name=adrrRepType]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrRepType=this.value;
		}
	})
	if($("#new").is(':checked')){
		adrrRepTypeNew="Y"; 
	}
	if((adrrRepType=="")&&(adrrRepTypeNew=="")){
		$.messager.alert("提示:","【报告类型】不能为空！");
		return false;
	}else if(adrrRepType=="11"){
		adrrRepTSDesc=$("#serdesc").val();  //类型为严重时,获取损害情形
	}
	if((adrrRepTSDesc=="")&(adrrRepType=="11")){
		$.messager.alert("提示:","【报告类型】为严重时,请选择严重情形描述！");
		return false;
	}
	
	//4、报告单位类别
	var adrrRepDeptType="";
	var adrrRepDeptTypeDesc="";
    $("input[type=checkbox][name=adrrRepDeptType]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrRepDeptType=this.value;
		}
	})
	adrrRepDeptTypeDesc=$('#RepDeptTypeOther').val();
	if(adrrRepDeptType==""){
		$.messager.alert("提示:","【报告单位类别】不能为空！");
		return false;
	}
	
	//5、联系方式
	if($('#PatContact').val()==""){
		$.messager.alert("提示:","【联系方式】不能为空！");
		return false;
	}
	
	//6、原患疾病
	if($('#adrrPatOriginalDis').val()==""){
		$.messager.alert("提示:","【原患疾病】不能为空！");
		return false;
	}
	
	//7、既往药品不良反应/事件
	if($('#EH10').is(':checked')){
		if($('#adrrEventHistDesc').val()==""){
			$.messager.alert("提示:","请填写【既往药品不良反应/事件】！");
			return false;
		}
	}
	
	//8、家族药品不良反应/事件
	if($('#EF10').is(':checked')){
		if($('#adrrEventFamiDesc').val()==""){
			$.messager.alert("提示:","请填写【家族药品不良反应/事件】！");
			return false;
		}
	}
	
	//9、不良反应/事件名称
	//if($('#AdrEvent').val()=="")
	if ($('#AdrEventItms').val()==""){
		$.messager.alert("提示:","【不良反应/事件名称】不能为空！");
		return false;
	}
	
	//10、不良反应/事件发生时间
	if($('#DateOccu').datebox('getValue')==""){
		$.messager.alert("提示:","【不良反应/事件发生时间】不能为空！");
		return false;
	}
	
	//11、不良反应/事件过程描述
	if($('#adrrProcessDesc').val()==""){
		$.messager.alert("提示:","【不良反应/事件过程描述】不能为空！");
		return false;
	}
	
	//12、不良反应/事件的结果
	var adrrEventResult="";
	$("input[type=checkbox][name=adrrEventResult]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventResult=this.value;
		}
	})
	if(adrrEventResult==""){
		$.messager.alert("提示:","【不良反应/事件的结果】不能为空！");
		return false;
	}
	if(adrrEventResult=="13"){
		if($('#adrrEventRSeqDesc').val()==""){
			$.messager.alert("提示:","【不良反应/事件的结果为有后遗症】,请填写【具体表现】！");
			return false;
		}
	}
	if(adrrEventResult=="14"){
		if($('#adrrEventRDRDesc').val()==""){
			$.messager.alert("提示:","【不良反应/事件的结果为死亡】,请填写【直接死因】！");
			return false;
		}
		var adrrEventResultDate=$('#adrrEventRDRDate').datetimebox('getValue');
		if(adrrEventResultDate==""){
			$.messager.alert("提示:","【不良反应/事件的结果为死亡】,请填写【死亡时间】！");
			return false;
		}
		var adrrEventDateResult=adrrEventResultDate.split(" ")[0];
		if(!compareSelTimeAndCurTime(adrrEventDateResult)){
			$.messager.alert("提示:","【死亡时间】不能大于当前时间！");
			return false;	
		}
	}
	
	//13、停药后是否减轻
	var adrrEventStopResultt="";
    $("input[type=checkbox][name=adrrEventStopResultt]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventStopResultt=this.value;
		}
	})
	if(adrrEventStopResultt==""){
		$.messager.alert("提示:","请填写【停药后病人病情是否减轻】！");
		return false;
	}
	
	//14、再次使用可疑药品后是否再次出现同样反应/事件
	var adrrEventTakingAgain="";
    $("input[type=checkbox][name=adrrEventTakingAgain]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventTakingAgain=this.value;
		}
	})
	if(adrrEventTakingAgain==""){
		$.messager.alert("提示:","请填写【再次使用可疑药品后病人病情】！");
		return false;
	}
	
	//15、对原患疾病的影响
	var adrrEventEffectOfTreatment="";
    $("input[type=checkbox][name=adrrEventEffectOfTreatment]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventEffectOfTreatment=this.value;
		}
	})
	if(adrrEventEffectOfTreatment==""){
		$.messager.alert("提示:","请填写【发生不良反应对原患疾病的影响】！");
		return false;
	}
	
	//16、关联性评价
	var adrrEventCommentOfUser="";
    $("input[type=checkbox][name=adrrEventCommentOfUser]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrEventCommentOfUser=this.value;
		}
	})
	if(adrrEventCommentOfUser==""){
		$.messager.alert("提示:","报告《关联性评价之报告人评价》不能为空！");
		return false;
	}
	
	if($('#adrrEventUserOfReport').val()==""){ //报告人签字
		$.messager.alert("提示:","【报告人签字】不能为空！");
		return false;
	}
	
	//17、报告人联系电话
	if($('#adrrReportUserTel').val()==""){
		$.messager.alert("提示:","【报告人联系电话】不能为空！");
		return false;
	}
	
	//19、电子邮箱
	if($('#adrrEmailOfRepUser').val()==""){
		$.messager.alert("提示:","【报告人电子邮箱】不能为空！");
		return false;
	}
	
	//20、签名
	if($('#adrrSignOfRepUser').val()==""){
		$.messager.alert("提示:","【报告人签名】不能为空！");
		return false;
	}
	
	//21、报告部门
	if($('#adrrSignOfRepDept').combobox('getValue')==""){
		$.messager.alert("提示:","【报告部门】不能为空！");
		return false;
	}
	
	//22、报告人职业
	var adrrCareerOfRepUser="";
	$("input[type=checkbox][name=adrrCareerOfRepUser]").each(function(){
		if($('#'+this.id).is(':checked')){
			adrrCareerOfRepUser=this.value;
		}
	})
	if(adrrCareerOfRepUser==""){
		$.messager.alert("提示:","【报告人职业】不能为空！");
		return false;
	}
	// 其他
	if(adrrCareerOfRepUser=="99"){
		if($('#adrrCareerOfRepUserOthers').val()==""){
			$.messager.alert("提示:","请填写【报告人职业其他描述】！");
			return false;	
		}
	}
	
	//23、怀疑药品
	var quitflag=0;semptyflag=0;bemptyflag=0;
	var suspItems = $('#susdrgdg').datagrid('getRows');
	$.each(suspItems, function(index, item){
		if(item.orditm!=""){
			semptyflag = 1;
			if(trsUndefinedToEmpty(item.batno)==""){
				$.messager.alert("提示:","怀疑药品列表【批号】不能为空！");
				quitflag=1;
				return false;
			}
			if(trsUndefinedToEmpty(item.starttime)==""){
				$.messager.alert("提示:","怀疑药品列表【开始时间】不能为空！");
				quitflag=1;
				return false;
			}
			if(trsUndefinedToEmpty(item.endtime)==""){
				$.messager.alert("提示:","怀疑药品列表【结束时间】不能为空！");
				quitflag=1;
				return false;
			}
			if(trsUndefinedToEmpty(item.usereason)==""){
				$.messager.alert("提示:","怀疑药品列表【用药原因】不能为空！");
				quitflag=1;
				return false;
			}
		}
	})
	if(quitflag==1){return false;}
	//24、并用药品
	var suspItems = $('#blenddg').datagrid('getRows');
	$.each(suspItems, function(index, item){
		if(item.orditm!=""){
			bemptyflag = 1;
			if(trsUndefinedToEmpty(item.batno)==""){
				$.messager.alert("提示:","并用药品列表【批号】不能为空！");
				quitflag=1;
				return false;
			}
			if(trsUndefinedToEmpty(item.starttime)==""){
				$.messager.alert("提示:","并用药品列表【开始时间】不能为空！");
				quitflag=1;
				return false;
			}
			if(trsUndefinedToEmpty(item.endtime)==""){
				$.messager.alert("提示:","并用药品列表【结束时间】不能为空！");
				quitflag=1;
				return false;
			}
			if(trsUndefinedToEmpty(item.usereason)==""){
				$.messager.alert("提示:","并用药品列表【用药原因】不能为空！");
				quitflag=1;
				return false;
			}
		}
	})
	if(quitflag==1){return false;}
	if((semptyflag==0)&(bemptyflag==0)){
		$.messager.alert("提示:","怀疑和并用药品列表不能同时为空！");
		return false;
		}
	return true;
}

//页面关联设置
function setCheckBoxRelation(id){
	if($('#'+id).is(':checked')){
		///报告单位类别
		if(id=="RD99"){
			$('#RepDeptTypeOther').attr("disabled",false);
		}		
		///取消后遗症
		if(id=="RR13"){
			$('#adrrEventRSeqDesc').attr("disabled",false);
		}
		///取消直接死因
		if(id=="RR14"){
			$('#adrrEventRDRDesc').attr("disabled",false);
			$('#adrrEventRDRDate').datebox({disabled:false});
		}
	    ///报告人职业
		if(id=="RU99"){
			$('#adrrCareerOfRepUserOthers').attr("disabled",false);
		}    
		///报告单位类别
		if(id=="RD99"){
			$('#RepDeptTypeOther').attr("disabled",false);
		}
		///既往药品不良反应/事件
		if(id=="EH10"){
			$('#adrrEventHistDesc').attr("disabled",false);
			createAdrEvtEHWindow();
		}
		///家族药品不良反应/事件
		if(id=="EF10"){
			$('#adrrEventFamiDesc').attr("disabled",false);
			createAdrEvtEFWindow();
		}
		///相关重要信息
		if(id=="II99"){
			$('#iiothersdesc').attr("disabled",false);
		}
	}else{
		///取消后遗症
		if(id=="RR13"){
			$('#adrrEventRSeqDesc').val("");
			$('#adrrEventRSeqDesc').attr("disabled","true");
		}
		///取消直接死因
		if(id=="RR14"){
			$('#adrrEventRDRDesc').val("");
			$('#adrrEventRDRDesc').attr("disabled","true")
			$('#adrrEventRDRDate').datetimebox('setValue',"");
			$('#adrrEventRDRDate').datebox({disabled:true});
		}	
	    ///报告人职业
		if(id=="RU99"){
			$('#adrrCareerOfRepUserOthers').val("");
			$('#adrrCareerOfRepUserOthers').attr("disabled","true");
		}    
		///报告单位类别
		if(id=="RD99"){
			$('#RepDeptTypeOther').val("");
			$('#RepDeptTypeOther').attr("disabled","true");
		}
		///既往药品不良反应/事件
		if(id=="EH10"){
			$('#adrrEventHistDesc').val("");
			$('#adrrEventHistDesc').attr("disabled","true");
		}
		///家族药品不良反应/事件
		if(id=="EF10"){
			$('#adrrEventFamiDesc').val("");
			$('#adrrEventFamiDesc').attr("disabled","true");
		}
		///相关重要信息
		if(id=="II99"){
			$('#iiothersdesc').val("");
			$('#iiothersdesc').attr("disabled","true");
		}
	}
}

//选择时间与当前时间比较
function compareSelTimeAndCurTime(SelDate)
{
	var SelDateArr=SelDate.split("-");
	var SelYear=SelDateArr[0];
	var SelMonth=parseInt(SelDateArr[1]);
	var SelDate=parseInt(SelDateArr[2]);
	
	var myDate=new Date();
	var curYear=myDate.getFullYear();
	if(SelYear>curYear){
		return false;
	}
	var curMonth=myDate.getMonth()+1;
	if((SelYear==curYear)&(SelMonth>curMonth)){
		return false;
	}
	var curDate=myDate.getDate();
	if((SelYear==curYear)&(SelMonth==curMonth)&(SelDate>curDate)){
		return false;
	}
	return true;
}

//既往药品不良反应/事件窗口
function createAdrEvtEHWindow()
{
	$('#AdrEvtEHWin').window({
		title:'既往药品不良反应/事件',
		collapsible:true,
		border:false,
		closed:"true",
		width:700,
		height:400
	}); 

	$('#AdrEvtEHWin').window('open');
	InitAdrEvtEHWinPanel();
}

///初始化既往药品不良反应/事件窗口
function InitAdrEvtEHWinPanel()
{
	var adrEvtEHEditRow=""; //当前编辑行
	var columns=[[
		{field:'AdrEvtEHDrug',title:'药品名称',width:200,editor:texteditor},
		{field:'AdrEvtEHDesc',title:'不良反应名称',width:120,editor:texteditor}
	]];
  
  	var option = {
	  	toolbar: [{
			text:'确认',
			iconCls: 'icon-ok',
			handler: function(){
				var adrEvtEHItemArr=[];adrEvtEHItems="";
				if(adrEvtEHEditRow>="0"){
					$("#adrEvtEHList").datagrid('endEdit', adrEvtEHEditRow);//结束编辑，传入之前编辑的行
				}
				var items = $('#adrEvtEHList').datagrid('getRows');
				$.each(items, function(index, item){
					if(item.AdrEvtEHDrug!=""){
						adrEvtEHItemArr.push(item.AdrEvtEHDrug+"_"+item.AdrEvtEHDesc);
					}
				})
				adrEvtEHItems=adrEvtEHItemArr.join(",");
				$('#adrrEventHistDesc').val(adrEvtEHItems);
				$('#AdrEvtEHWin').window('close');
			}
		},{
			text:'添加空行',
			iconCls: 'icon-add',
			handler: function(){
				if(adrEvtEHEditRow>="0"){
					$("#adrEvtEHList").datagrid('endEdit', adrEvtEHEditRow);//结束编辑，传入之前编辑的行
				}
				$("#adrEvtEHList").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
					index: 0, // 行数从0开始计算
					row: {AdrEvtEHDrug:'',AdrEvtEHDesc:''}
				});
				$("#adrEvtEHList").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
				adrEvtEHEditRow=0;
			}
		}],
		onDblClickRow:function(rowIndex, rowData){
			 $('#adrEvtEHList').datagrid('deleteRow',rowIndex);
		}
	};
  	var adrEvtEHListComponent = new ListComponent('adrEvtEHList', columns, '', option);
	adrEvtEHListComponent.Init();
	
	///加载页面数据到列表中
	if($('#adrrEventHistDesc').val()!=""){
		var adrrEventHistDesc=$('#adrrEventHistDesc').val();
		var adrrEventHistDescArr=adrrEventHistDesc.split(",");
		var tempArr=[];
		for(var k=0;k<adrrEventHistDescArr.length;k++){
			tempArr.push("{\"AdrEvtEHDrug\":\""+adrrEventHistDescArr[k].split("_")[0]+"\",\"AdrEvtEHDesc\":\""+adrrEventHistDescArr[k].split("_")[1]+"\"}");
		}
		var jsdata = '{"total":'+adrrEventHistDescArr.length+',"rows":['+tempArr.join(",")+']}';
		var data = $.parseJSON(jsdata);
		$('#adrEvtEHList').datagrid("loadData",data);//将数据绑定到DataGrid中
	}
}

//既往药品不良反应/事件窗口
function createAdrEvtEFWindow()
{
	$('#AdrEvtEFWin').window({
		title:'家族药品不良反应/事件',
		collapsible:true,
		border:false,
		closed:"true",
		width:700,
		height:400
	}); 

	$('#AdrEvtEFWin').window('open');
	InitAdrEvtEFWinPanel();
}

///初始化家族既往药品不良反应/事件窗口
function InitAdrEvtEFWinPanel()
{
	var adrEvtEFEditRow=""; //当前编辑行
	var columns=[[
		{field:'AdrEvtEFDrug',title:'药品名称',width:200,editor:texteditor},
		{field:'AdrEvtEFDesc',title:'不良反应名称',width:120,editor:texteditor}
	]];

	var option = {
		toolbar: [{
			text:'确认',
			iconCls: 'icon-ok',
			handler: function(){
				var adrEvtEFItemArr=[];adrEvtEFItems="";
				if(adrEvtEFEditRow>="0"){
					$("#adrEvtEFList").datagrid('endEdit', adrEvtEFEditRow);//结束编辑，传入之前编辑的行
				}
				var items = $('#adrEvtEFList').datagrid('getRows');
				$.each(items, function(index, item){
					if(item.AdrEvtEFDrug!=""){
						adrEvtEFItemArr.push(item.AdrEvtEFDrug+"_"+item.AdrEvtEFDesc);
					}
				})
				adrEvtEFItems=adrEvtEFItemArr.join(",");
				$('#adrrEventFamiDesc').val(adrEvtEFItems);
				$('#AdrEvtEFWin').window('close');
			}
		},{
			text:'添加空行',
			iconCls: 'icon-add',
			handler: function(){
				if(adrEvtEFEditRow>="0"){
					$("#adrEvtEFList").datagrid('endEdit', adrEvtEFEditRow);//结束编辑，传入之前编辑的行
				}
				$("#adrEvtEFList").datagrid('insertRow', {//在指定行添加数据，appendRow是在最后一行添加数据
					index: 0, // 行数从0开始计算
					row: {AdrEvtEFDrug:'',AdrEvtEFDesc:''}
				});
				$("#adrEvtEFList").datagrid('beginEdit', 0);//开启编辑并传入要编辑的行
				adrEvtEFEditRow=0;
			}
		}],
		onDblClickRow:function(rowIndex, rowData){
			 $('#adrEvtEFList').datagrid('deleteRow',rowIndex);
		}
	};
  	var adrEvtEFListComponent = new ListComponent('adrEvtEFList', columns, '', option);
	adrEvtEFListComponent.Init();
	
	///加载页面数据到列表中
	if($('#adrrEventFamiDesc').val()!=""){
		var adrrEventFamiDesc=$('#adrrEventFamiDesc').val();
		var adrrEventFamiDescArr=adrrEventFamiDesc.split(",");
		var tempArr=[];
		for(var k=0;k<adrrEventFamiDescArr.length;k++){
			tempArr.push("{\"AdrEvtEFDrug\":\""+adrrEventFamiDescArr[k].split("_")[0]+"\",\"AdrEvtEFDesc\":\""+adrrEventFamiDescArr[k].split("_")[1]+"\"}");
		}
		var jsdata = '{"total":'+adrrEventFamiDescArr.length+',"rows":['+tempArr.join(",")+']}';
		var data = $.parseJSON(jsdata);
		$('#adrEvtEFList').datagrid("loadData",data);//将数据绑定到DataGrid中
	}
}

/// 添加前检查
function AppBeforeCheck(drgdgid)
{
	var quitflag = 0;
	var checkedItems = $('#medInfo').datagrid('getChecked');
    $.each(checkedItems, function(index, item){
	    if(!checkSusAndBleIfRepApp(drgdgid,item.incidesc)){
		    quitflag = 1;
		    return false;
		}
    })
    if(quitflag==1){return false;}
    return true;
}
/// 判断怀疑和并用药品是否重复添加
function checkSusAndBleIfRepApp(drgdgid,phcdesc)
{
	var quitflag = 0; message = "";
	
	/// 1、怀疑
	var suspItems = $('#susdrgdg').datagrid('getRows');
	$.each(suspItems, function(index, item){

		if(item.incidesc!=""){
			if(item.incidesc == phcdesc){
				if(drgdgid == "susdrgdg"){
					message = "该药品已添加,不能重复添加！";
				}else{
					message = "该药品已为怀疑药品,不可同时为并用药品！";
				}
				$.messager.alert("提示:",message);
				quitflag=1;
				return false;
			}
		}
	})
	if(quitflag==1){return false;}
	
	/// 2、并用
	var suspItems = $('#blenddg').datagrid('getRows');
	$.each(suspItems, function(index, item){

		if(item.incidesc!=""){
			if(item.incidesc == phcdesc){
				if(drgdgid == "blenddg"){
					message = "该药品已添加,不能重复添加！";
				}else{
					message = "该药品已为并用药品,不可同时为怀疑药品！";
				}
				$.messager.alert("提示:",message);
				quitflag=1;
				return false;
			}
		}
	})
	if(quitflag==1){return false;}
	
	return true;
}