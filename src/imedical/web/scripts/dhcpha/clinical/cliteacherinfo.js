
///Creator:    bianshuai
///CreateDate: 2016-01-28
///Descript:   教师信息列表
var flag=0;
var url="dhcpha.clinical.action.csp";
var bmTEduArr = [{"value":"1","text":$g('博士及以上')}, {"value":"2","text":$g('硕士')}, {"value":"3","text":$g('本科')}, {"value":"4","text":$g('大专')}];
$(function(){
	
	$("#startDate").datebox("setValue", formatDate(-2));  //Init起始日期
	$("#endDate").datebox("setValue", formatDate(0));     //Init结束日期
	
	$("a:contains("+$g('新增')+")").bind("click",newCreateWriteWin);
	$("a:contains("+$g('查询')+")").bind("click",querybmTeacherDet);
	$("a:contains("+$g('删除')+")").bind("click",delTeacherDetail);
    $('#TeacherCode').bind('keypress',function(event){
        if(event.keyCode == "13"){
	        findUserInfo();}
    });
	
	/**
	 * 性别
	 */
	var teacherSexCombobox = new ListCombobox("TeacherSex",url+'?action=SelCTSex','',{panelHeight:"auto"});
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
	var teacherTitCombobox = new ListCombobox("TeacherTit",url+'?action=QueryConsIden','',{});
	teacherTitCombobox.init();

	/**
	 * 科室
	 */
	  $('#TeacherLoc').combobox({
		mode:'remote',		
		onShowPanel:function(){ //qunianpeng 2017/8/14 支持拼音码和汉字
			$('#TeacherLoc').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'  ')
			//$('#dept').combobox('reload',url+'?action=SelAllLoc&HospID='+HospID)
		},
			onHidePanel: function() { //lbb 2020.2.26 增加检索内容和下拉数据匹配
            var valueField = $(this).combobox("options").valueField;
            var val = $(this).combobox("getValue");  //当前combobox的值
            var allData = $(this).combobox("getData");   //获取combobox所有数据
            var result = true;      //为true说明输入的值在下拉框数据中不存在
            for (var i = 0; i < allData.length; i++) {
                if (val == allData[i][valueField]) {
                    result = false;
                }
            }
            if (result) {
                $(this).combobox("clear");
            }

        }
	}); 
	//var teacherLocCombobox = new ListCombobox("TeacherLoc",url+'?action=QueryConDept','',{});
	//teacherLocCombobox.init();

	InitCliTeaList();    //初始化数据列表
	
})

//初始化列表
function InitCliTeaList()
{
	
	var columns=[[
		{field:'bmTeaID',title:'bmTeaID',width:80,hidden:true,rowspan:2},
		{field:'bmTCareer',title:$g('带教专业Code'),width:100,hidden:true,rowspan:2},
		{field:'bmTCareerDesc',title:$g('带教专业'),width:100,rowspan:2},
		{title:'<span style="font-weight:bold">'+$g("带教老师情况")+'</span>',align:'center',colspan:9}
	],[
		{field:'bmTUserID',title:$g('用户ID'),width:100,hidden:true},
		{field:'bmTUserCode',title:$g('工号'),width:80},
		{field:'bmTUserName',title:$g('姓名'),width:80},
		{field:'bmTSexID',title:$g('性别ID'),width:60,hidden:true},
		{field:'bmTSex',title:$g('性别'),width:60},
		{field:'bmTAge',title:$g('年龄'),width:60},
		{field:'bmTEduca',title:$g('学历Code'),width:100,hidden:true},
		{field:'bmTEducaDesc',title:$g('学历'),width:120},
		{field:'bmTCarePrvID',title:$g('职称ID'),width:100,hidden:true},
		{field:'bmTCarePrvTP',title:$g('职称'),width:100},
		{field:'bmTLocID',title:$g('科室ID'),width:160,hidden:true},
		{field:'bmTLoc',title:$g('科室'),width:200},
		{field:'bmTDate',title:$g('日期'),width:100},
		{field:'bmTTime',title:$g('时间'),width:90,hidden:true},
		{field:'bmTClinicalDate',title:$g('临床药师证书时间'),width:150},
		{field:'bmTTeacherDate',title:$g('临床药师师资证书时间'),width:150},
		{field:'bmSNameStr',title:$g('带教学员'),width:150},
		{field:'bmTRemark',title:$g('备注'),width:200},
		{field:'LinkModify',title:$g('修改信息'),width:100,align:'center',formatter:SetCellOpUrl},

	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:$g('带教老师明细'),
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
		var newWrDialogUX = new DialogUX($g('修改带教教师信息'), 'newWrWin', '730', '400', option); //lbb 2019-03-12
	}
	else{
	    var newWrDialogUX = new DialogUX($g('增加带教教师信息'), 'newWrWin', '730', '400', option)
	}
	newWrDialogUX.Init();
	flag=0;
}

 /**
  * 保存带教老师信息
  */
function saveTeaDetail(){
	
	var teaUserID=$('#TeaUserID').val();    //用户ID
	if (teaUserID == ""){
		showMsgAlert("错误提示:","姓名不能为空！");
		return;
	}
		
	var teacherSex=$('#TeacherSex').combobox('getValue');    //性别
	if (teacherSex == ""){
		showMsgAlert("错误提示:","性别不能为空！");
		return;
	}

	var teacherEdu=$('#TeacherEdu').combobox('getValue');    //学历
	if (teacherEdu == ""){
		showMsgAlert("错误提示:","学历不能为空！");
		return;
	}
	
	var teacherTit=$('#TeacherTit').combobox('getValue');    //职称
	if (teacherTit == ""){
		showMsgAlert("错误提示:","职称不能为空！");
		return;
	}
	
	var teacherLoc=$('#TeacherLoc').combobox('getValue');    //科室
	if (teacherLoc == ""){
		showMsgAlert("错误提示:","科室不能为空！");
		return;
	}

	var teacherCar=$('#TeacherCar').combobox('getValue');    //带教专业
	if (teacherCar == ""){
		showMsgAlert("错误提示:","带教专业不能为空！");
		return;
	}
	var teacherAge=$('#TeacherAge').val();    //年龄
	if (teacherAge == ""){
		showMsgAlert("错误提示:","年龄不能为空！");
		return;
	}
	var ClinicalDate=$('#ClinicalDate').datebox('getValue')
    if (ClinicalDate == ""){
		showMsgAlert("错误提示:","取得临床药师证书时间不能为空！");
		return;
	}
	var TeacherDate=$('#TeacherDate').datebox('getValue')
    if (TeacherDate == ""){
		showMsgAlert("错误提示:","取得临床药师师资证书时间不能为空！");
		return;
	}
    var teacherDesc = $("#TeacherDesc").val();   //描述信息

	var bmTeacherID = $("#TeacherID").val();
	
	var bmTDataList = teaUserID +"^"+ teacherSex +"^"+ teacherEdu +"^"+ teacherLoc +"^"+ teacherCar +"^"+ teacherTit +"^"+ teacherDesc+"^"+teacherAge+"^"+ClinicalDate+"^"+TeacherDate;

	//保存数据
	$.post(url+'?action=SaveBasManTeacher',{"bmTeacherID":bmTeacherID,"bmTDataList":bmTDataList},function(jsonString){

		var jsonConsObj = jQuery.parseJSON(jsonString);
		if (jsonConsObj.ErrorCode == "0"){
			$('#newWrWin').dialog('close');     //关闭窗体
			$('#bmTDetList').datagrid('reload'); //重新加载
		}else if(jsonConsObj.ErrorCode==""){
			$.messager.alert("提示:","提交失败,错误原因：此教师已存在，请重新维护工号")
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

	var userCode=$('#userCode').val();    //工号
	var userName=$('#userName').val();
	var params=startDate +"^"+ endDate +"^"+ userCode+"^"+LgHospID+"^"+userName;
	$('#bmTDetList').datagrid({
		url:url + "?action=QuerybmTeaList",	
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
    
    flag=1;
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
	$("#TeacherLoc").combobox('setText',rowData.bmTLoc);     //科室
	$("#TeacherCar").combobox('setValue',rowData.bmTCareer);    //带教专业
	$("#TeacherAge").val(rowData.bmTAge); //年龄
	$("#ClinicalDate").datebox("setValue",rowData.bmTClinicalDate)
	$("#TeacherDate").datebox("setValue",rowData.bmTTeacherDate)
	$("#TeacherDesc").val(rowData.bmTRemark);   //备注
}

/// 初始化带教老师填写界面
function initbmTWrOrEdWin(){
	$("#TeacherID").val("");     //DHC_PHBasManTeacher ID
	$("#TeaUserID").val("");     //用户ID
	$("#TeacherName").val("");   //姓名
	$("#TeacherCode").val("");   //工号
	$("#TeacherSex").combobox('setValue',"");     //性别
	$("#TeacherEdu").combobox('setValue',"");     //学历
	$("#TeacherTit").combobox('setValue',"");     //职称
	$("#TeacherLoc").combobox('setValue',"");     //科室
	$("#TeacherCar").combobox('setValue',"");     //带教专业
	$("#TeacherDesc").val("");   //备注
	$("#ClinicalDate").datebox("setValue","")
	$("#TeacherDate").datebox("setValue","")
	$("#TeacherAge").val("");
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
		/* if (resobj.bmTUserGroup != LgGroupID){
			showMsgAlert("错误原因:" , "不是登录的安全组人员工号");
			$("#TeaUserID").val("")
			$("#TeacherCode").val("");    //工号
		    $("#TeacherName").val("");
			return;
		} */
		$("#TeaUserID").val(resobj.bmTUserID);    //用户ID
		$("#TeacherCode").val(resobj.bmTUserCode);    //工号
		$("#TeacherName").val(resobj.bmTUserName);    //姓名
	});
}

/// 消息提示窗口
function showMsgAlert(ErrMsg , ErrDesc){
	$.messager.alert("提示:","<font style=''>" + ErrMsg + "</font><font style='color:red;'>" + ErrDesc + "</font>");
}