
///Creator:    bianshuai
///CreateDate: 2016-01-28
///Descript:   药学类咨询

var url="dhcpha.clinical.action.csp";
var TeacherSfArr=[{"value":"Y","text":'正常'}, {"value":"N","text":'不正常'}];
var TeacherTitArr=[{"value":"Y","text":'合格'}, {"value":"N","text":'不合格'}];
var TeacherSexArr=[{"value":"Y","text":'相符'}, {"value":"N","text":'不相符'}];
var bmTEduArr = [{"value":"Y","text":'相符'}, {"value":"N","text":'不相符'}];
$(function(){
	
	$("#startDate").datebox("setValue", formatDate(-2));  //Init起始日期
	$("#endDate").datebox("setValue", formatDate(0));     //Init结束日期
	
	$("a:contains('新建')").bind("click",newCreateWriteWin);
	$("a:contains('查询')").bind("click",querybmTeacherDet);
	$("a:contains('删除')").bind("click",delTeacherDetail);
	///event.keyCode == "13"表示回车
    $('#TeacherCode').bind('keypress',function(event){
        if(event.keyCode == "13"){                            
	        findUserInfo();}
	        
    });
        $('#GiveCode').bind('keypress',function(event){
        if(event.keyCode == "13"){                            
	        findUserInfoz();}
	        
    });
	
	/**
	 * 性别
	 */
	var teacherSexCombobox = new ListCombobox("TeacherSex",'',TeacherSexArr,{panelHeight:"auto"});
	teacherSexCombobox.init();
	
	/**
	 * 学历
	 */
	var teacherEduCombobox = new ListCombobox("TeacherEdu",'',bmTEduArr,{panelHeight:"auto"});
	teacherEduCombobox.init();

	/**
	 * 带教专业
	 */
	var teacherCarCombobox = new ListCombobox("TeacherCar",url+'?action=SelProDirect','',{panelHeight:"auto"});
	teacherCarCombobox.init();

	/**
	 * 职称
	 */
	var teacherTitCombobox = new ListCombobox("TeacherTit",'',TeacherTitArr,{panelHeight:"auto"});
	teacherTitCombobox.init();

	/**
	 * 设施
	 */
	var teacherSfCombobox = new ListCombobox("TeacherSf",'',TeacherSfArr,{panelHeight:"auto"});
	teacherSfCombobox.init();
	/**
	 * 科室
	 */
    var teacherLocCombobox = new ListCombobox("TeacherLoc",url+'?action=QueryConDept','',{});
	teacherLocCombobox.init();
	
    var locIdCombobox = new ListCombobox("LocId",url+'?action=QueryConDept','',{});
	locIdCombobox.init();
	
	
	InitCliTeaList();    //初始化数据列表
	
})

//初始化列表
function InitCliTeaList()
{

	
	var columns=[[
		{field:'bmTeaID',title:'bmTeaID',width:80,hidden:true,rowspan:2},
		{field:'bmTDate',title:'日期',width:100},
        {field:'bmTTime',title:'时间',width:100,hidden:true},
        {field:'bmGiveUserName',title:'交班人',width:100},
        {field:'bmTeacherName',title:'接班人',width:100},
        {field:'bmLocName',title:'科室',width:100},
        {field:'bmTeacherSex',title:'药品品规',width:100},
        {field:'bmTeacherEdu',title:'药品数量',width:100},
        {field:'bmTeacherTit',title:'药品质量',width:100},
        {field:'bmTeacherSf',title:'安全设施',width:100},
		{field:'LinkModify',title:'修改信息',width:100,align:'center',formatter:SetCellOpUrl},
		{field:'bmTRemark',title:'备注',width:200}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'麻醉药品交接登记明细',
		//nowrap:false,
		singleSelect : true ,
		onDblClickRow:function(rowIndex, rowData){
		  	showModifyWin(rowIndex);
		},
		onLoadSuccess:function(data){
			var rows = $("#bmTDetList").datagrid('getRows');
			var rowcount=rows.length ;			   
			if (rowcount==0) return;
			var rowData = $('#bmTDetList').datagrid('getData').rows[0];
			var TmpbmTCareerDesc = rowData.bmTCareerDesc;
			var mergerows=0;
			for (var i=1;i<rows.length;i++){
				mergerows = mergerows + 1;
				if (TmpbmTCareerDesc != rows[i].bmTCareerDesc){
					$('#bmTDetList').datagrid('mergeCells',{
				       index:(i - mergerows),
				       field:'bmTCareerDesc',
				       rowspan:mergerows
				    });
				    mergerows=0;
				    TmpbmTCareerDesc = rows[i].bmTCareerDesc;
				}
			}
			if(i == rows.length){
				mergerows = mergerows + 1;
				$('#bmTDetList').datagrid('mergeCells',{
				       index:(i - mergerows),
				       field:'bmTCareerDesc',
				       rowspan:mergerows
				    });
			}
		}
	};
		
	var bmTDetListComponent = new ListComponent('bmTDetList', columns, '', option);
	bmTDetListComponent.Init();

	initScroll("#bmTDetList");//初始化显示横向滚动条

	querybmTeacherDet();
}

 /**
  * 新建填写窗口
  */
function newCreateWriteWin(){
	newCreateWrOrEdWin();  //新建填写窗口
	initbmTWrOrEdWin();
}

 /**
  * 新建填写窗口
  */
function newCreateWrOrEdWin(){
	var option = {
			buttons:[{
				text:'保存',
				iconCls:'icon-save',
				handler:function(){
					saveTeaDetail();
					}
			},{
				text:'取消',
				iconCls:'icon-cancel',
				handler:function(){
					$('#newWrWin').dialog('close');
					}
			}]
		};
	var newWrDialogUX = new DialogUX('增加交接登记信息', 'newWrWin', '730', '415', option);
	newWrDialogUX.Init();
}

 /**
  * 保存带教老师信息
  */
function saveTeaDetail(){
	
	var teaUserID=$('#TeaUserID').val();    //用户ID
	if (teaUserID == ""){
		showMsgAlert("错误提示:","接班人姓名不能为空！");
		return;
	}
	var giveUserID=$('#GiveUserID').val();    //交班人ID
	var teacherSex=$('#TeacherSex').combobox('getValue');    //性别
	if (teacherSex == ""){
		showMsgAlert("错误提示:","药品品规不能为空！");
		return;
	}

	var teacherEdu=$('#TeacherEdu').combobox('getValue');    //学历
	if (teacherEdu == ""){
		showMsgAlert("错误提示:","药品数量不能为空！");
		return;
	}
	
	var teacherTit=$('#TeacherTit').combobox('getValue');    //职称
	if (teacherTit == ""){
		showMsgAlert("错误提示:","药品质量不能为空！");
		return;
	}
	
	var teacherLoc=$('#TeacherLoc').combobox('getValue');    //科室
	if (teacherLoc == ""){
		showMsgAlert("错误提示:","科室不能为空！");
		return;
	}
    var teacherSf=$('#TeacherSf').combobox('getValue');    //设施
	if (teacherSf == ""){
		showMsgAlert("错误提示:","药品设施不能为空！");
		return;
	}
    var teacherDesc = $("#TeacherDesc").val();   //描述信息

	var bmTeacherID = $("#TeacherID").val();
	
	
	var bmTDataList = teaUserID +"^"+giveUserID +"^"+ teacherSex +"^"+ teacherEdu +"^"+ teacherLoc +"^"+ teacherTit +"^"+teacherSf +"^"+ teacherDesc;

	//保存数据
	$.post(url+'?action=SavePhDrugShReg',{"bmTeacherID":bmTeacherID,"bmTDataList":bmTDataList},function(jsonString){
		var jsonConsObj = jQuery.parseJSON(jsonString);
		if (jsonConsObj.ErrorCode == "0"){
			$('#newWrWin').dialog('close');     //关闭窗体
			$('#bmTDetList').datagrid('reload'); //重新加载
		}else{
			$.messager.alert("提示:","提交失败,错误原因："+jsonConsObj.ErrorMessage);
		}
	});
}

 /**
  * 查询咨询数据
  */
function querybmTeacherDet(){
	
	//1、清空datagrid 
	$('#CliTeaList').datagrid('loadData', {total:0,rows:[]});
	
	//2、查询
	var startDate=$('#startDate').datebox('getValue');   //起始日期
	var endDate=$('#endDate').datebox('getValue');       //截止日期

	var LocId=$('#LocId').combobox('getValue');    //工号
	var params=startDate +"^"+ endDate +"^"+ LocId;

	$('#bmTDetList').datagrid({
		url:url + "?action=QuerybmTeaListz",	
		queryParams:{
			params:params}
	});
}

/// 删除咨询明细
function delTeacherDetail(){
	showMsgAlert("错误原因:" , "删除功能暂时不可用！");
}

//操作
function SetCellOpUrl(value, rowData, rowIndex)
{
	var html = "<a href='#' onclick='showModifyWin("+rowIndex+")'>修改数据</a>";
    return html;
}

 /**
  * 修改窗体
  */
function showModifyWin(index){

	newCreateWrOrEdWin();  //新建填写窗口
	
	var rowData = $('#bmTDetList').datagrid('getData').rows[index];
	
	$("#TeacherID").val(rowData.bmTeaID);       //DHC_PHBasManTeacher ID
	$("#TeaUserID").val(rowData.bmTUserID);     //用户ID
	$("#TeacherName").val(rowData.bmTUserName); //姓名
	$("#TeacherCode").val(rowData.bmTUserCode); //工号
	$("#TeacherSex").combobox('setValue',rowData.bmTSexID);     //性别
	$("#TeacherEdu").combobox('setValue',rowData.bmTEduca);     //学历
	$("#TeacherTit").combobox('setValue',rowData.bmTCarePrvID); //职称
	$("#TeacherLoc").combobox('setValue',rowData.bmTLocID);     //科室
	$("#TeacherCar").combobox('setValue',rowData.bmTCareer);    //带教专业
	$("#TeacherDesc").val(rowData.bmTRemark);   //备注
}

/// 初始化带教老师填写界面
function initbmTWrOrEdWin(){
	$("#TeacherID").val("");     //DHC_PHBasManTeacher ID
	$("#TeaUserID").val("");     //用户ID
	$("#TeacherName").val("");   //姓名
	$("#TeacherCode").val("");   //工号
	$("#GiveCode").val("");   //工号
	$("#GiveName").val("");   //
	$("#TeacherDesc").val("");   //备注
	$("#TeacherSex").combobox('setValue',"");     //性别
	$("#TeacherEdu").combobox('setValue',"");     //学历
	$("#TeacherTit").combobox('setValue',"");     //职称
	$("#TeacherLoc").combobox('setValue',"");     //科室  
    $("#TeacherSf").combobox('setValue',""); //设施	
	$("#GiveUserID").val(""); 
	
}

/// 根据用户工号查询用户信息
function findUserInfo(){
	
	var usercode = $('#TeacherCode').val();
	if (usercode == ""){
		showMsgAlert("错误信息","请输入工号后,回车查询！");
		return;
	}
	$.post(url+'?action=QueryUserInfo',{"usercode":usercode},function(jsonString){
	
		var resobj = jQuery.parseJSON(jsonString);
		if (typeof resobj.bmTUserID == "undefined"){
			showMsgAlert("错误原因:" , "'工号'错误，请重试！");
			return;
		}
		$("#TeaUserID").val(resobj.bmTUserID);    //用户ID
		$("#TeacherCode").val(resobj.bmTUserCode);    //工号
		$("#TeacherName").val(resobj.bmTUserName);    //姓名
	});
}
/// 根据用户工号查询用户信息
function findUserInfoz(){
	
	var usercode = $('#GiveCode').val();
	if (usercode == ""){
		showMsgAlert("错误信息","请输入工号后,回车查询！");
		return;
	}
	$.post(url+'?action=QueryUserInfo',{"usercode":usercode},function(jsonString){
	
		var resobj = jQuery.parseJSON(jsonString);
		if (typeof resobj.bmTUserID == "undefined"){
			showMsgAlert("错误原因:" , "'工号'错误，请重试！");
			return;
		}
		$("#GiveUserID").val(resobj.bmTUserID);    //用户ID
		$("#GiveCode").val(resobj.bmTUserCode);    //工号
		$("#GiveName").val(resobj.bmTUserName);    //姓名
	});
}

/// 消息提示窗口
function showMsgAlert(ErrMsg , ErrDesc){
	$.messager.alert("提示:","<font style='font-size:20px;'>" + ErrMsg + "</font><font style='font-size:20px;color:red;'>" + ErrDesc + "</font>");
}