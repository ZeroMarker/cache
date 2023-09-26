
///Creator:    bianshuai
///CreateDate: 2016-01-28
///Descript:   学员信息表
var flag=0;
var url="dhcpha.clinical.action.csp";
var bmSEduArr = [{"value":"1","text":'博士研究生'}, {"value":"2","text":'硕士研究生'}, {"value":"3","text":'本科'}, {"value":"4","text":'专科'}];
var OutProFlagArr = [{"value":"1","text":'是'}, {"value":"2","text":'否'}];

$(function(){
	
	$("#startDate").datebox("setValue", formatDate(-2));  //Init起始日期
	$("#endDate").datebox("setValue", formatDate(0));     //Init结束日期
	
	$("a:contains('新增')").bind("click",newCreateWriteWin);
	$("a:contains('查询')").bind("click",querybmSeacherDet);
	$("a:contains('删除')").bind("click",delbmSeacherDet);
	
	/**
	 * 性别
	 */
	var bmSSexCombobox = new ListCombobox("bmSSex",url+'?action=SelCTSex','',{panelHeight:"auto"});
	bmSSexCombobox.init();
	
	/**
	 * 学历
	 */
	var bmSEduCombobox = new ListCombobox("bmSEdu",'',bmSEduArr,{panelHeight:"auto"});
	bmSEduCombobox.init();

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
	
	$("#bmSBegEduDate").datebox("setValue", formatDate(0));  //开学日期
	$("#bmSEndEduDate").datebox("setValue", formatDate(0));  //毕业日期
	
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
		{field:'bmSCareerDesc',title:'培训专业',width:100,rowspan:2},
		{title:'<span style="font-weight:bold">学员情况</span>',align:'center',colspan:12}
	],[
		{field:'bmSName',title:'姓名',width:100},
		{field:'bmSSex',title:'性别',width:80},
		{field:'bmSAge',title:'年龄',width:80},
		{field:'bmSEducaDesc',title:'学历',width:100},
		{field:'bmSCarePrvTP',title:'职称',width:100},
		{field:'bmSBegEduDate',title:'开学时间',width:100},
		{field:'bmSEndEduDate',title:'毕业时间',width:100},
		{field:'bmSWorkUnit',title:'工作单位',width:160},
		{field:'bmSOutProFlagDesc',title:'省外',width:40},
		{field:'LinkModify',title:'修改信息',width:100,align:'center',formatter:SetCellOpUrl},
		{field:'bmSAddDate',title:'日期',width:100},
		{field:'bmSAddTime',title:'时间',width:90,hidden:true},
		{field:'bmSRemark',title:'备注',width:200}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'基地学员明细',
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
				text:'保存',
				iconCls:'icon-save',
				handler:function(){
					saveTeaDetail();
					}
			},{
				text:'关闭',
				iconCls:'icon-cancel',
				handler:function(){
					$('#newWrWin').dialog('close');
					}
			}]
		};
	if(flag==1){
		var newWrDialogUX = new DialogUX('修改学员信息', 'newWrWin', '730', '385', option); //lbb 2019-03-12
	}
	else{
	    var newWrDialogUX = new DialogUX('增加学员信息', 'newWrWin', '730', '385', option);
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
		showMsgAlert("错误提示:","学历不能为空！");
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
		showMsgAlert("错误提示:","开学或毕业日期不能为空！");
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
	
	var bmSDataList = bmSName +"^"+ bmSSex +"^"+ bmSAge +"^"+ bmSEdu +"^"+ bmSCarPrvTp +"^"+ bmSWorkUnit +"^"+ bmSBegEduDate
	bmSDataList = bmSDataList +"^"+ bmSEndEduDate +"^"+ bmSCareer +"^"+ bmSOutProFlag +"^"+ bmSRemark;
	
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
	
	var params=startDate +"^"+ endDate +"^"+ userName;

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
}

/// 消息提示窗口
function showMsgAlert(ErrMsg , ErrDesc){
	$.messager.alert("提示:","<font style=''>" + ErrMsg + "</font><font style='color:red;'>" + ErrDesc + "</font>");
}