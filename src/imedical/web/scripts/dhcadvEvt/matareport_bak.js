
/// Creator: congyue
/// CreateDate: 2015-09-22

var url="dhcadv.repaction.csp";
var patSexArr = [{ "val": "1", "text": "男" }, { "val": "2", "text": "女" },{ "val": "3", "text": "不详" }];
var editRow="";currEditID="";matadrID="";patientID="";EpisodeID="";editFlag="";MatadrInitStatDR="";mataReportType="";medadrReceive="";matadrCurStatusDR="";
var AstSymbol='<span style="color:red;">*</span>';  ///星号标示
$(function(){
	patientID=getParam("PatientID");
	EpisodeID=getParam("EpisodeID");
	matadrID=getParam("matadrID");
	editFlag=getParam("editFlag");
	
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
			 //var matadrPatNo=getRegNo(matadrPatNo)
			 getMataRepPatInfo(matadrPatNo);
		 }
	});
	//性别
	$('#PatSex').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:patSexArr
	});
	 
	//复选框按钮事件
	$("div[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).toggleClass('cb_active');
			setCheckBoxRelation(this.id);
		});
	});
	
	//复选框分组
	InitUIStatus();
	
	//当事件结果为死亡时，显示隐藏的时间框
	$('#TR10').click(function(){
		var matadrEventResultDate=document.getElementById("deathdate");
		
		if ($(this).hasClass('cb_active')) {
			matadrEventResultDate.style.display='inline';
		} else {
			matadrEventResultDate.style.display='none';
		}   
	});
	InitMataReport(matadrID);
	InitPatientInfo(matadrID);
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
	$("div[type=checkbox]").click(function(){
		tmpid=this.id;
		if($('#'+tmpid).hasClass('cb_active')){
			$("div[type=checkbox][name="+this.name+"]").each(function(){
				if((this.id!=tmpid)&($(this).hasClass('cb_active'))){
					$(this).toggleClass('cb_active');
					setCheckBoxRelation(this.id);
				}
			})
		}
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
	if(matadrCreateDate==""){
		$.messager.alert("提示:","报告日期不能为空！");
		return;
	}else{
		matadrCreateDateResult=matadrCreateDate.split(" ")[0];  //报告日期
		matadrCreateTimeResult=matadrCreateDate.split(" ")[1];  //报告时间
	}
	//2、报告编码
	var matadrNo=$('#matadrNo').val();
	if(matadrNo==""){
		$.messager.alert("提示:","报告编码不能为空！");
		return;
	}
	matadrNo=matadrNo.replace(/[ ]/g,""); //去掉编码中的空格
	//A、病人信息
	//病人ID
	var matadrPatID=$('#PatID').val();
	
	//病人登记号
	var matadrPatNo=$('#PatNo').val();
	if(matadrPatNo==""){
		$.messager.alert("提示:","病人登记号不能为空！");
		return;
	}
	//病人姓名
	var matadrName=$('#PatName').val();
	if(matadrName==""){
		$.messager.alert("提示:","病人姓名不能为空！");
		return;
	}
    //病人性别
	var matadrSex=$('#PatSex').combobox('getValue');
	if(matadrSex==""){
		$.messager.alert("提示:","病人性别不能为空！");
		return;
	}
    //病人年龄
	var matadrAge=$('#PatAge').val();  
	if(matadrAge==""){
		$.messager.alert("提示:","病人年龄不能为空！");
		return;
	}
	//预期治疗疾病或作用
	var matadrExpectEff=$('#matadrExpectEff').val();  
	if(matadrExpectEff==""){
		$.messager.alert("提示:","预期治疗疾病或作用不能为空！");
		return;
	}
	//诊疗日期
	var matadrAdmDate=$('#matadrAdmDate').datetimebox('getValue');   
	if(matadrAdmDate==""){
		$.messager.alert("提示:","诊疗日期不能为空！");
		return;
	}else{
		matadrAdmDateResult=matadrAdmDate.split(" ")[0];  //诊疗日期
		matadrAdmTimeResult=matadrAdmDate.split(" ")[1];  //诊疗时间
	}
	
	//B.不良事件情况
	var matadrMainExp=$('#matadrMainExp').val();  //事件主要表现
	if(matadrMainExp==""){
		$.messager.alert("提示:","事件主要表现不能为空！");
		return;
	}
	//1.事件发生日期
	var matadrAdrDate=$('#matadrAdrDate').datebox('getValue');   
	if(matadrAdrDate==""){
		$.messager.alert("提示:","事件发生日期不能为空！");
		return;
	}	
	//2.发现或者知悉时间
	var matadrDiscDate=$('#matadrDiscDate').datebox('getValue');   
	if(matadrDiscDate==""){
		$.messager.alert("提示:","发现或者知悉时间不能为空！");
		return;
	}
	//3.医疗器械实际使用场所
	var matadrUsePlace="";
	var matadrUsePlaceOth="";
    $("div[type=checkbox][name=matadrUsePlace]").each(function(){
		if($(this).hasClass('cb_active')){
			matadrUsePlace=this.val;
		}
	})
	matadrUsePlaceOth=$('#matadrUsePlaceOth').val();
	if(matadrUsePlace==""){
		$.messager.alert("提示:","医疗器械实际使用场所不能为空！");
		return ;
	}
	//4.事件后果
	var matadrResult="";
	var matadrEventResultDate="";
	var matadrDeathDate="";matadrDeathTime="";
    $("div[type=checkbox][name=matadrResult]").each(function(){
		if($(this).hasClass('cb_active')){
			matadrResult=this.val;
		}
	})
	if(matadrResult==""){
		$.messager.alert("提示:","事件后果不能为空！");
		return ;
	}
	
	// 事件结果为死亡
	if(matadrResult=="10"){
		matadrEventResultDate=$('#matadrEventResultDate').datetimebox('getValue'); 
		if(matadrEventResultDate==""){
			$.messager.alert("提示:","事件后果为【死亡】,请填写死亡时间！");
			return false;
		}else{
		 matadrDeathDate=matadrEventResultDate.split(" ")[0];  //死亡日期
		 matadrDeathTime=matadrEventResultDate.split(" ")[1];  //死亡时间
	}
	}
	
	
	//5.事件陈述
	var matadrEventDesc=$('#matadrEventDesc').val();
	if(matadrEventDesc==""){
		$.messager.alert("提示:","事件陈述不能为空！");
		return ;
	}
	
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
    $("div[type=checkbox][name=matadrOperator]").each(function(){
		if($(this).hasClass('cb_active')){
			matadrOperator=this.val;
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
    $("div[type=checkbox][name=matadrHandStatus]").each(function(){
		if($(this).hasClass('cb_active')){
			matadrHandStatus=this.val;
		}
	})	
	//D. 不良事件评价 
	//1.省级监测技术机构评价意见
	var matadrProAdvice=$('#matadrProAdvice').val();	
	//2.国家监测技术机构评价意见
	var matadrCountryAdvice=$('#matadrCountryAdvice').val();	
	//3.报告人职称
	var matadrCarPrvTp="";
    $("div[type=checkbox][name=matadrCarPrvTp]").each(function(){
		if($(this).hasClass('cb_active')){
			matadrCarPrvTp=this.val;
		}
	})
	//报告人
	var matadrRepName=$('#matadrRepNameID').val();
	if(matadrRepName==""){
		$.messager.alert("提示:","报告人不能为空！");
		return;
	}
	//报告人科室
	var matadrRepLocDr=$('#matadrRepLocID').val();
	if(matadrRepLocDr==""){
		$.messager.alert("提示:","报告人科室不能为空！");
		return;
	}
	var matadrRepTel=$('#matadrRepTel').val();   //报告人联系电话
	var matadrRepEmail=$('#matadrRepEmail').val();   //报告人邮箱
	if(flag==1){
		matadrCurStatusDR=MatadrInitStatDR;  //初始状态
		
	}
	var matadrDataList=matadrNo+"^"+matadrSex+"^"+matadrAge+"^"+matadrName+"^"+matadrPatNo+"^"+matadrExpectEff+"^"+matadrAdmDateResult;
	matadrDataList=matadrDataList+"^"+matadrAdmTimeResult+"^"+matadrMainExp+"^"+matadrAdrDate+"^"+matadrDiscDate;
	matadrDataList=matadrDataList+"^"+matadrUsePlace+"^"+matadrUsePlaceOth+"^"+matadrResult+"^"+matadrDeathDate;
	matadrDataList=matadrDataList+"^"+matadrDeathTime+"^"+matadrEventDesc+"^"+matadrProName+"^"+matadrInciName+"^"+matadrRegNo;
	matadrDataList=matadrDataList+"^"+matadrManf+"^"+matadrManfAddress+"^"+matadrManfTel+"^"+matadrSpec+"^"+matadrProCode;
	matadrDataList=matadrDataList+"^"+matadrProBatNo+"^"+matadrOperator+"^"+matadrOperatorOth+"^"+matadrExpDate+"^"+matadrProDate;
	matadrDataList=matadrDataList+"^"+matadrDisDate+"^"+matadrUseDate+"^"+matadrReasonDesc+"^"+matadrHandInfo+"^"+matadrHandStatus;
	matadrDataList=matadrDataList+"^"+matadrProAdvice+"^"+matadrCountryAdvice+"^"+matadrCarPrvTp+"^"+matadrRepName+"^"+matadrRepLocDr;
	matadrDataList=matadrDataList+"^"+matadrRepTel+"^"+matadrRepEmail+"^"+matadrCreateDateResult+"^"+matadrCreateTimeResult+"^"+matadrCurStatusDR;
	var matadrNextLoc="";
	var matadrLocAdvice="";
	var matadrRepAuditList="";
	if(flag==1){
		matadrRepAuditList=matadrCurStatusDR+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+matadrNextLoc+"^"+matadrLocAdvice+"^"+medadrReceive+"^"+mataReportType;
	}
	
	var param="matadrID="+matadrID+"&matadrDataList="+matadrDataList+"&matadrRepAuditList="+matadrRepAuditList; 
	//alert(matadrRepAuditList);
	//保存
    $.ajax({
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
    });
}
//填写模板
function Mould()
{
	$('#MouldTable').window({
		title:'填写模板',
		collapsible:false,
		border:false,
		closed:false,
		width:430,
		height:520
	}); 
	$('#MouldTable').window('open');
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
		Str7="采取治疗措施时间:"+MT7+"；";
	}
	if (MT8!==""){
		Str8="采取治疗措施:"+MT8+"；";
	}
	if (MT9!==""){
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
	$('#BloodCheck').window({
		title:'血常规检测',
		collapsible:false,
		border:false,
		closed:"true",
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
		onClickRow: function (rowIndex, rowData) {//双击选择行编辑
			if (editRow!="") { 
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
	$('#RenalCheck').window({
		title:'肾功能检测',
		collapsible:false,
		border:false,
		closed:"true",
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
		onClickRow: function (rowIndex, rowData) {//双击选择行编辑
			if (editRow!="") { 
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
	$('#BloodLipid').window({
		title:'血脂分析',
		collapsible:false,
		border:false,
		closed:"true",
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
		onClickRow: function (rowIndex, rowData) {//双击选择行编辑
			if (editRow!="") { 
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
	$('#VitalSigns').window({
		title:'生命体征',
		collapsible:false,
		border:false,
		closed:"true",
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
		onClickRow: function (rowIndex, rowData) {//双击选择行编辑
			if (editRow!="") { 
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
	$('#BloodGas').window({
		title:'血气模板',
		collapsible:false,
		border:false,
		closed:"true",
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
		onClickRow: function (rowIndex, rowData) {//双击选择行编辑
			if (editRow!="") { 
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
	$('#LiverFunction').window({
		title:'肝功能',
		collapsible:false,
		border:false,
		closed:"true",
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
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
			if (editRow!="") { 
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
   	var params=""+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+"器械填报";
	var matadrDataList="";
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
				$('#matadrCreateDate').datetimebox("setValue",tmp[43]+" "+tmp[44]);   //报告日期
				$('#matadrNo').val(tmp[1]);    //报告编码
				//病人信息
				$('#PatSex').combobox('setValue',tmp[2]);     //性别
				$('#PatAge').val(tmp[3]);    //年龄
				$('#PatName').val(tmp[4]);    //患者姓名
				$('#PatNo').val(tmp[5]);    //病人登记号
				$('#matadrExpectEff').val(tmp[6]);    //预期治疗疾病或作用
				$('#matadrAdmDate').datetimebox("setValue",tmp[7]+" "+tmp[8]);   //诊疗日期				
				$('#matadrMainExp').val(tmp[9]);    //事件主要表现
				$('#matadrAdrDate').datebox("setValue",tmp[10]);   //事件发生日期
				$('#matadrDiscDate').datebox("setValue",tmp[11]);   //发现或者知悉时间
				//医疗器械实际使用场所
				$('#UP'+tmp[12]).toggleClass('cb_active');
				$('#matadrUsePlaceOth').val(tmp[13]);
				if(tmp[12]=="99"){
					$('#matadrUsePlaceOth').attr("disabled",false);
				}
				//事件后果
				$('#TR'+tmp[14]).toggleClass('cb_active');
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
				$('#OP'+tmp[27]).toggleClass('cb_active');
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
				$('#HS'+tmp[35]).toggleClass('cb_active');				
				//D. 不良事件评价
				$('#matadrProAdvice').val(tmp[36]);    //省级监测技术机构评价意见
				$('#matadrCountryAdvice').val(tmp[37]);    //国家监测技术机构评价意见
				//报告人职称
				$('#CP'+tmp[38]).toggleClass('cb_active');
				$('#matadrRepNameID').val(tmp[39]);    //报告人
				$('#matadrRepName').val(tmp[48]);    //报告人

				$('#matadrRepLocID').val(tmp[40]);    //报告人科室
				$('#matadrRepLocDr').val(tmp[47]);    //报告人科室

				$('#matadrRepTel').val(tmp[41]);    //报告人联系电话
				$('#matadrRepEmail').val(tmp[42]);    //报告人邮箱
				//InitPatientInfo(tmp[5],'')
				mataReportType=tmp[49];
				medadrReceive=tmp[50];
				MatadrInitStatDR=tmp[46];
				//editFlag状态为0,提交和暂存按钮不可用
				matadrCurStatusDR=tmp[46];
			
     },
       error: function(){
	       alert('链接出错');
	       return;
	   }
    });   
}
//加载报表默认信息
function InitPatientInfo(matadrID)
{
   if(matadrID!=""){return;}
   var params=""+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+"器械填报";
   $.ajax({
   type: "POST",
   url: url,
   data:"action=getMataInfo&params="+params,
   success: function(val){
		var tmp=val.split("^");
		$('#matadrCreateDate').datetimebox({disabled:true});
		$('#matadrCreateDate').datetimebox("setValue",tmp[1]);   //报告日期
		$('#matadrNo').val(tmp[0]);                //报告编码
		$('#matadrNo').attr("disabled","true");
		
		$('#matadrRepName').val(LgUserName);    //报告人
		$('#matadrRepName').attr("disabled","true");
		$('#matadrRepNameID').val(LgUserID);	//报告人id
		$('#matadrRepLocDr').val(tmp[4]);    //报告人科室
		$('#matadrRepLocDr').attr("disabled","true");
		$('#matadrRepLocID').val(LgCtLocID);    //报告人科室id
		
		MatadrInitStatDR=tmp[2];  //报表的初始化,状态 
		mataReportType=tmp[3];
   }})
}
//获取病人信息
function getMataRepPatInfo(matadrPatNo){
	if(matadrPatNo==""){return;}

	//获取报表信息
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=getRepPatInfo&PatNo="+matadrPatNo,
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
	if(matadrNo==""){
		$.messager.alert("提示:","【报告编码】不能为空！");
		return false;
	}
	matadrNo=matadrNo.replace(/[ ]/g,""); //去掉编码中的空格
	//病人ID
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
	//4.发现或者知悉时间
	var matadrDiscDate=$('#matadrDiscDate').datebox('getValue');   
	if(matadrDiscDate==""){
		$.messager.alert("提示:","【发现或者知悉时间】不能为空！");
		return false;
	}
	//5.医疗器械实际使用场所
	var matadrUsePlace="";
	var matadrUsePlaceOth="";
    $("div[type=checkbox][name=matadrUsePlace]").each(function(){
		if($(this).hasClass('cb_active')){
			matadrUsePlace=this.val;
		}
	})
	matadrUsePlaceOth=$('#matadrUsePlaceOth').val();
	if(matadrUsePlace==""){
		$.messager.alert("提示:","【医疗器械实际使用场所】不能为空！");
		return false;
	}
	//6.事件后果
	var matadrResult="";
     $("div[type=checkbox][name=matadrResult]").each(function(){
		if($(this).hasClass('cb_active')){
			matadrResult=this.val;
		}
	})
	if(matadrResult==""){
		$.messager.alert("提示:","【事件后果】不能为空！");
		return ;
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
    //matadrRepName=LgUserID;
    

	//报告人科室	
	if($('#matadrRepLocDr').val()==""){
		$.messager.alert("提示:","【报告部门科室】不能为空！");
		return false;
	}
	return true;
}
function getRegNo(regno)
{
	var len=regno.length;
	var  reglen=10
	var zerolen=reglen-len
	var zero=""
	for (var i=1;i<=zerolen;i++)
	{zero=zero+"0" ;
		}
	return zero+regno ;
}
//页面关联设置
function setCheckBoxRelation(id){
	if($('#'+id).hasClass('cb_active')){
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


