
///Creator:    bianshuai
///CreateDate: 2016-01-28
///Descript:   学员信息表
var flag=0;
var url="dhcpha.clinical.action.csp";
var OutProFlagArr = [{"value":"1","text":$g('是')}, {"value":"2","text":$g('否')}];
var bmSEduArr = [{"value":"1","text":$g('博士及以上')}, {"value":"2","text":$g('硕士')}, {"value":"3","text":$g('本科')}, {"value":"4","text":$g('大专')}];
var bmSProArr = [{"value":"1","text":$g('临床药学')}, {"value":"2","text":$g('药学')}, {"value":"3","text":$g('药物制剂')}, {"value":"4","text":$g('药物分析')}, {"value":"5","text":$g('药物化学')},{"value":"6","text":$g('药理学')},{"value":"7","text":$g('药剂学')}, {"value":"8","text":$g('中药学及其他')}];
var bmSHigEduArr = [{"value":"1","text":$g('博士及以上')}, {"value":"2","text":$g('硕士')}, {"value":"3","text":$g('本科')}, {"value":"4","text":$g('大专')}];
var bmSTopProArr = [{"value":"1","text":$g('临床药学')}, {"value":"2","text":$g('药学')}, {"value":"3","text":$g('药物制剂')}, {"value":"4","text":$g('药物分析')}, {"value":"5","text":$g('药物化学')},{"value":"6","text":$g('药理学')},{"value":"7","text":$g('药剂学')}, {"value":"8","text":$g('中药学及其他')}];
var IsAssessment = [{"value":"0","text":'否'}, {"value":"1","text":'是'}];
$(function(){
	
	$("#startDate").datebox("setValue", formatDate(-2));  //Init起始日期
	$("#endDate").datebox("setValue", formatDate(0));     //Init结束日期
	
	$("a:contains("+$g('新增')+")").bind("click",newCreateWriteWin);
	$("a:contains("+$g('查询')+")").bind("click",querybmSeacherDet);
	$("a:contains("+$g('删除')+")").bind("click",delbmSeacherDet);
	
	/**
	 * 性别
	 */
	var bmSSexCombobox = new ListCombobox("bmSSex",url+'?action=SelCTSex','',{panelHeight:"auto"});
	bmSSexCombobox.init();
	

	/**
	 * 培训专业
	 */
	var bmSCareerCombobox = new ListCombobox("Career",url+'?action=SelProDirect','',{panelHeight:"auto"});
	bmSCareerCombobox.init();

	/**
	 * 培训专业
	 */
	var bmSCareerCombobox = new ListCombobox("bmSCareer",url+'?action=SelProDirect','',{panelHeight:"auto"});
	bmSCareerCombobox.init();

	/**
	 * 职称
	 */
	var bmSCarPrvTpCombobox = new ListCombobox("bmSCarPrvTp",url+'?action=QueryConsIden','');
	bmSCarPrvTpCombobox.init();

	/**
	 * 是否省外
	 */
	var bmSOutProFlagCombobox = new ListCombobox("bmSOutProFlag",'',OutProFlagArr,{panelHeight:"auto"});
	bmSOutProFlagCombobox.init();
	
	/**
	 * 第一学历
	 */
	var bmSEduCombobox = new ListCombobox("bmSEdu",'',bmSEduArr,{panelHeight:"auto"});
	bmSEduCombobox.init();
	/**
	 * 专业
	 */
    var bmSProCombobox = new ListCombobox("bmSProfession",'',bmSProArr,{panelHeight:"auto"});
	bmSProCombobox.init();
    
    /**
	 * 最高学历
	 */
	var bmSHigEduCombobox = new ListCombobox("bmSHigEdu",'',bmSHigEduArr,{panelHeight:"auto"});
	bmSHigEduCombobox.init();
	/**
	 * 专业
	 */
    var bmSTopProCombobox = new ListCombobox("bmSTopProfession",'',bmSTopProArr,{panelHeight:"auto"});
	bmSTopProCombobox.init();
	
	/**
	 * 是否通过考核
	 */
	var bmSIsAssessmentCombobox = new ListCombobox("bmSIsAssessment",'',IsAssessment,{panelHeight:"auto"});
	bmSIsAssessmentCombobox.init();
	
	//用户
	//var bmSTeacherCombobox = new ListCombobox("bmSTeacher",url+'?action=jsonGetSSUser');
	//bmSTeacherCombobox.init();
	
	$("#bmSBegEduDate").datebox("setValue", formatDate(0));  //开学日期
	$("#bmSEndEduDate").datebox("setValue", formatDate(0));  //毕业日期
	//用户
	$("#bmSTeacher").combobox({
		mode:'remote',
		onShowPanel:function(){
			$('#bmSTeacher').combobox('reload',url+'?action=jsonGetSSUser')
		}
	}); 
	
	
	InitCliTeaList();    //初始化数据列表
	
})

//初始化列表
function InitCliTeaList()
{

	/**
	 * 定义columns
	 */
	
	var columns=[[
		{field:'bmStuID',title:'bmStuID',width:80,hidden:true,rowspan:2},
		{field:'bmSCareerDesc',title:$g('培训专业'),width:100,rowspan:2},
		{title:'<span style="font-weight:bold">'+$g("学员情况")+'</span>',align:'center',colspan:12}
	],[
		{field:'bmSName',title:$g('姓名'),width:100},
		{field:'bmSSex',title:$g('性别'),width:80},
		{field:'bmSAge',title:$g('年龄'),width:80},
		{field:'bmSCarePrvTP',title:$g('职称'),width:100},
		{field:'bmSBegEduDate',title:$g('开学时间'),width:100},
		{field:'bmSEndEduDate',title:$g('毕业时间'),width:100},
		{field:'bmSWorkUnit',title:$g('工作单位'),width:160},
		{field:'bmSOutProFlagDesc',title:$g('省外'),width:40},
		{field:'bmSAddDate',title:$g('日期'),width:100},
		{field:'bmSEducaDesc',title:$g('第一学历'),width:100},
		{field:'bmSProfessionDesc',title:$g('第一专业'),width:100},
		{field:'bmSHigEduDesc',title:$g('最高学历'),width:100},
		{field:'bmSTopProfessionDesc',title:$g('最高专业'),width:100},
		{field:'bmSTeacherDesc',title:$g('带教老师'),width:100},
		{field:'bmSTrainDate',title:$g('培训时间'),width:100},
		{field:'bmSIsAssessmentDesc',title:$g('是否通过考核'),width:50},
		{field:'bmSAddTime',title:$g('时间'),width:90,hidden:true},
		{field:'bmSRemark',title:$g('备注'),width:200},
		{field:'LinkModify',title:$g('修改信息'),width:100,align:'center',formatter:SetCellOpUrl},

	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:$g('基地学员明细'),
		//nowrap:false,
		singleSelect : true,
		onDblClickRow:function(rowIndex, rowData){
		  	showModifyWin(rowIndex);
		},
		onLoadSuccess:function(data){
			var rows = $("#bmSDetList").datagrid('getRows');
			var rowcount=rows.length ;			   
			if (rowcount==0) return;
			var rowData = $('#bmSDetList').datagrid('getData').rows[0];
			var TmpbmSCareerDesc = rowData.bmSCareerDesc;
			var mergerows=0;
			for (var i=1;i<rows.length;i++){
				mergerows = mergerows + 1;
				if (TmpbmSCareerDesc != rows[i].bmSCareerDesc){
					$('#bmSDetList').datagrid('mergeCells',{
				       index:(i - mergerows),
				       field:'bmSCareerDesc',
				       rowspan:mergerows
				    });
				    mergerows=0;
				    TmpbmSCareerDesc = rows[i].bmSCareerDesc;
				}
			}
			if(i == rows.length){
				mergerows = mergerows + 1;
				$('#bmSDetList').datagrid('mergeCells',{
				       index:(i - mergerows),
				       field:'bmSCareerDesc',
				       rowspan:mergerows
				    });
			}
		}
	};
		
	var bmSDetListComponent = new ListComponent('bmSDetList', columns, '', option);
	bmSDetListComponent.Init();

	initScroll("#bmSDetList");//初始化显示横向滚动条

	querybmSeacherDet();
}

 /**
  * 新建填写窗口
  */
function newCreateWriteWin(){
	newCreateWrOrEdWin();  //新建填写窗口
	initbmSWrOrEdWin();
}

 /**
  * 新建填写窗口
  */
function newCreateWrOrEdWin(){
	var option = {
			buttons:[{
				text:$g('保存'),
				iconCls:'icon-save',
				handler:function(){
					saveTeaDetail();
					}
			},{
				text:$g('关闭'),
				iconCls:'icon-cancel',
				handler:function(){
					$('#newWrWin').dialog('close');
					}
			}]
		};
	if(flag==1){
		var newWrDialogUX = new DialogUX($g('修改学员信息'), 'newWrWin', '730', '480', option); //lbb 2019-03-12
	}
	else{
	    var newWrDialogUX = new DialogUX($g('增加学员信息'), 'newWrWin', '730', '480', option);
	}
	newWrDialogUX.Init();
	flag=0;
}

 /**
  * 保存带教老师信息
  */
function saveTeaDetail(){
	
    //姓名
	var bmSName=$('#bmSName').val();
	if (bmSName == ""){
		showMsgAlert("错误提示:","姓名不能为空！");
		return;
	}
	
    //性别
	var bmSSex=$('#bmSSex').combobox('getValue');
	if (bmSSex == ""){
		showMsgAlert("错误提示:","性别不能为空！");
		return;
	}

    //年龄
	var bmSAge=$('#bmSAge').val();
	if (bmSAge == ""){
		showMsgAlert("错误提示:","年龄不能为空！");
		return;
	}

	//学历
	var bmSEdu=$('#bmSEdu').combobox('getValue');
	if (bmSEdu == ""){
		showMsgAlert("错误提示:","第一学历不能为空！");
		return;
	}
	
	//职称
	var bmSCarPrvTp=$('#bmSCarPrvTp').combobox('getValue');
	if (bmSCarPrvTp == ""){
		showMsgAlert("错误提示:","职称不能为空！");
		return;
	}
	
    //工作单位
	var bmSWorkUnit=$('#bmSWorkUnit').val();
	if (bmSWorkUnit == ""){
		showMsgAlert("错误提示:","工作单位不能为空！");
		return;
	}
	
    //开学日期
	var bmSBegEduDate=$('#bmSBegEduDate').datebox('getValue');
		
    //毕业日期
	var bmSEndEduDate=$('#bmSEndEduDate').datebox('getValue');

	//开学和毕业日期为必填项   qunianpeng  2016-09-14
	if((bmSBegEduDate=="")||(bmSEndEduDate=="")){      
		showMsgAlert("错误提示:","开学日期和毕业日期都不能为空！");
		return;
	}

    //培训专业
	var bmSCareer=$('#bmSCareer').combobox('getValue');
	if (bmSCareer == ""){
		showMsgAlert("错误提示:","培训专业不能为空！");
		return;
	}
			
    //是否省外
	var bmSOutProFlag=$('#bmSOutProFlag').combobox('getValue');
	if (bmSOutProFlag == ""){
		showMsgAlert("错误提示:","是否省外不能为空！");
		return;
	}
    var bmSRemark = $("#bmSRemark").val();   //描述信息

	var bmStudentID = $("#bmStudentID").val();
	
	//第一专业
	var bmSProfession=$('#bmSProfession').combobox('getValue');
	if (bmSProfession == ""){
		showMsgAlert("错误提示:","第一专业不能为空！");
		return;
	}
	
	//最高学历
	var bmSHigEdu=$('#bmSHigEdu').combobox('getValue');
	if (bmSHigEdu == ""){
		showMsgAlert("错误提示:","最高学历不能为空！");
		return;
	}
	
	var bmSTopProfession=$('#bmSTopProfession').combobox('getValue');
	if (bmSTopProfession == ""){
		showMsgAlert("错误提示:","最高专业不能为空！");
		return;
	}
	var bmSTeacher=$('#bmSTeacher').combobox('getValue');
	if (bmSTeacher == ""){
		showMsgAlert("错误提示:","指导教师不能为空！");
		return;
	}
	
	var bmSTrainDate=$('#bmSTrainDate').datebox('getValue');
	if (bmSTrainDate == ""){
		showMsgAlert("错误提示:","培训时间不能为空！");
		return;
	}
	
	var bmSIsAssessment=$('#bmSIsAssessment').combobox('getValue');
	if (bmSIsAssessment == ""){
		showMsgAlert("错误提示:","是否通过考核不能为空！");
		return;
	}
	var bmSDataList = bmSName +"^"+ bmSSex +"^"+ bmSAge +"^"+ bmSEdu +"^"+ bmSCarPrvTp +"^"+ bmSWorkUnit +"^"+ bmSBegEduDate
	bmSDataList = bmSDataList +"^"+ bmSEndEduDate +"^"+ bmSCareer +"^"+ bmSOutProFlag +"^"+ bmSRemark+"^"+bmSProfession+"^"+bmSHigEdu+"^"+bmSTopProfession+"^"+ bmSTeacher+"^"+ bmSTrainDate+"^"+ bmSIsAssessment;
	//保存数据
	$.post(url+'?action=SaveBasManStudent',{"bmStudentID":bmStudentID,"bmSDataList":bmSDataList},function(jsonString){

		var jsonConsObj = jQuery.parseJSON(jsonString);
		if (jsonConsObj.ErrorCode == "0"){
			$('#newWrWin').dialog('close');     //关闭窗体
			$('#bmSDetList').datagrid('reload'); //重新加载
		}else{
			$.messager.alert("提示:","提交失败,错误原因："+jsonConsObj.ErrorMessage);
		}
	});
}

 /**
  * 查询咨询数据
  */
function querybmSeacherDet(){
	
	//1、清空datagrid 
	$('#bmSDetList').datagrid('loadData', {total:0,rows:[]});
	
	//2、查询
	var startDate=$('#startDate').datebox('getValue');   //起始日期
	var endDate=$('#endDate').datebox('getValue');       //截止日期

	var userName=$('#userName').val();    //姓名
	var CareerID=$('#Career').combobox('getValue')
	if($('#Career').combobox('getText')=="")
	{
		var CareerID="";
	}
	var TrainstartDate=$("#TrainstartDate").datebox('getValue');   
	var TrainendDate=$("#TrainendDate").datebox('getValue'); 
	
	var params=startDate +"^"+ endDate +"^"+ userName+"^"+CareerID+"^"+TrainstartDate+"^"+TrainendDate;

	$('#bmSDetList').datagrid({
		url:url + "?action=QuerybmStudentList",	
		queryParams:{
			params:params}
	});
}

/// 删除咨询明细
function delbmSeacherDet(){
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

	flag=1;
	newCreateWrOrEdWin();  //新建填写窗口
	
	var rowData = $('#bmSDetList').datagrid('getData').rows[index];

	$("#bmStudentID").val(rowData.bmStuID); ///学员表ID
	$("#bmSName").val(rowData.bmSName);  	///姓名
	$("#bmSSex").combobox('setValue',rowData.bmSSexID);  	///性别
	$("#bmSAge").val(rowData.bmSAge);       ///年龄
	$("#bmSEdu").combobox('setValue',rowData.bmSEdu);    	///学历
	$("#bmSCarPrvTp").combobox('setValue',rowData.bmSCarePrvID);  	 ///职称
	$("#bmSWorkUnit").val(rowData.bmSWorkUnit);  	 ///工作单位
	$("#bmSBegEduDate").datebox("setValue", rowData.bmSBegEduDate);  ///开学日期
	$("#bmSEndEduDate").datebox("setValue", rowData.bmSEndEduDate);  ///毕业日期
	$("#bmSCareer").combobox('setValue',rowData.bmSCareer);  		 ///培训专业
	$("#bmSOutProFlag").combobox('setValue',rowData.bmSOutProFlag);  ///是否省外
	$("#bmSRemark").val(rowData.bmSRemark);  		 ///备注
	$('#bmSProfession').combobox('setValue',rowData.bmSProfession);
	$('#bmSHigEdu').combobox('setValue',rowData.bmSHigEdu);
	$('#bmSTopProfession').combobox('setValue',rowData.bmSTopProfession);
	$("#bmSTeacher").combobox('setValue',rowData.bmSTeacher);
	$('#bmSTrainDate').datebox('setValue',rowData.bmSTrainDate);
	$('#bmSIsAssessment').combobox('setValue',rowData.bmSIsAssessment);

}

/// 初始化带教老师填写界面
function initbmSWrOrEdWin(){
	$("#bmStudentID").val("");  ///学员表ID
	$("#bmSName").val("");  	///姓名
	$("#bmSSex").combobox('setValue',"");  		  ///性别
	$("#bmSAge").val("");       ///年龄
	$("#bmSEdu").combobox('setValue',"");    	  ///学历
	$("#bmSCarPrvTp").combobox('setValue',"");    ///职称
	$("#bmSWorkUnit").val("");  	 			  ///工作单位
	$("#bmSBegEduDate").datebox("setValue", "");  ///开学日期
	$("#bmSEndEduDate").datebox("setValue", "");  ///毕业日期
	$("#bmSCareer").combobox('setValue',"");  	  ///培训专业
	$("#bmSOutProFlag").combobox('setValue',"");  ///是否省外
	$("#bmSRemark").val("");  		 			  ///备注
    $('#bmSProfession').combobox('setValue',"");
	$('#bmSHigEdu').combobox('setValue',"");
	$('#bmSTopProfession').combobox('setValue',"");
	$('#bmSTeacher').combobox('setValue',"");
	$('#bmSTrainDate').datebox('setValue',"");
	$('#bmSIsAssessment').combobox('setValue',"");
}

/// 消息提示窗口
function showMsgAlert(ErrMsg , ErrDesc){
	$.messager.alert("提示:","<font style=''>" + ErrMsg + "</font><font style='color:red;'>" + ErrDesc + "</font>");
}