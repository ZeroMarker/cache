
///Creator:    bianshuai
///CreateDate: 2016-01-28
///Descript:   药学类咨询

var editRow="";  ///当前编辑行索引
var consultID = 0;
var flag=0
var finiFlag="N"
var url="dhcpha.clinical.action.csp";
$(function(){
	
	$("#startDate").datebox("setValue", formatDate(-2));  //Init起始日期
	$("#endDate").datebox("setValue", formatDate(0));     //Init结束日期
	
	$("a:contains('新建')").bind("click",newCreateConWin);
	$("a:contains('查询')").bind("click",queryConsultDetail);
	$("a:contains('删除')").bind("click",delConsultDetail);
	$("#consPatMedNo").bind('keypress',function(event){
        if(event.keyCode == "13"){
	        SetPatNoLength();
            GetPatEssInfoByPatNo(); //调用查询
        }
    });
	
	/**
	 * 性别
	 */
	var consPatSexCombobox = new ListCombobox("consPatSex",url+'?action=SelCTSex','',{panelHeight:"auto"});
	consPatSexCombobox.init();
	
	/**
	 * 特殊人群
	 */
	var consSpeCrowdCombobox = new ListCombobox("consSpeCrowd",url+'?action=QueryConSpCrowd','',{panelHeight:"auto"});
	consSpeCrowdCombobox.init();
	
	/**
	 * 咨询身份
	 */
	 var consIdenCombobox = new ListCombobox("consIden",url+'?action=QueryConsIdenInfo','',{panelHeight:"auto"});
	consIdenCombobox.init();
	
	/**
	 * 问题类型
	 */
	var quesTypeCombobox = new ListCombobox("consType",url+'?action=QueryQuesType','',{panelHeight:"auto"});
	quesTypeCombobox.init();
	
	/**
	 * 咨询部门
	 */
	//var conDeptCombobox = new ListCombobox("consDept",url+'?action=QueryConDept','',{});
	//conDeptCombobox.init();
	$('#consDept').combobox({
		mode:'remote',		
		onShowPanel:function(){ //qunianpeng 2017/8/14 支持拼音码和汉字
			//$('#consDept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'  ')
			$('#consDept').combobox('reload',url+'?action=SelAllLoc&hospId='+LgHospID);
			//$('#dept').combobox('reload',url+'?action=SelAllLoc&HospID='+HospID)
		}
	}); 
	
	/**
	 * 咨询方式
	 */
	var consWaysCombobox = new ListCombobox("consWays",url+'?action=QueryConsWays','',{panelHeight:"auto"});
	consWaysCombobox.init();
	
	/**
	 * 参考资料
	 */
	var consRefMatCombobox = new ListCombobox("consRefMat",url+'?action=QueryConsBasis','',{panelHeight:"auto"});
	consRefMatCombobox.init();
	
	/**
	 * 服务时间
	 */
	var consDurationCombobox = new ListCombobox("consDuration",url+'?action=QueryConsTime','',{panelHeight:"auto"});
	consDurationCombobox.init();;
	
	InitConsultList();    //初始化咨询信息列表
	
	$('input').live('click',function(){
		if ((editRow != "")||(editRow == "0")) { 
            $("#consDrugItem").datagrid('endEdit', editRow); 
        } 
	});
	
})

//初始化界面默认信息
function InitConsultDefault(){

	$("#consPatientID").val(''); 				//病人ID
	$('#consPatName').val('');  				//患者姓名	
	$('#consPatMedNo').val('');    				//病历号
	$('#consPatSex').combobox('setValue','');   //性别
	$('#consPatAge').val('');    				//年龄
	$('#consContact').val('');    				//联系方式
	$('#consSpeCrowd').combobox('setValue',''); //特殊人群
	$('#consType').combobox('setValue','');     //问题类型
	$('#consDiagDesc').val('');       			//诊断信息
	$('#consWays').combobox('setValue','');     //咨询方式
	$('#consRefMat').combobox('setValue','');   //参考资料
	$('#consDuration').combobox('setValue',''); //服务时间
	$('#consQusDesc').val('');  				//问题描述
	$('#consAnsDesc').val('');  				//回答内容
	$("#consultID").val(''); 					//咨询ID
	
	$('#consName').val(LgUserName);  		    //用户姓名
	$('#consDept').combobox('setValue',LgCtLocID);  //默认科室
	$('#consDept').combobox('setText',LgCtLocDesc);  //默认科室
	$('#consIden').combobox('setValue','');     //咨询身份 

}

//初始化病人列表
function InitConsultList()
{

	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'consultID',title:'consultID',width:80,hidden:true},
		{field:'finiFlag',title:'完成',width:50,align:'center',formatter:SetCellColor},
		{field:'consDate',title:'咨询日期',width:100},
		{field:'consTime',title:'咨询时间',width:90},
		{field:'consQusTypeDesc',title:'问题类型',width:120},
		{field:'consIdenDesc',title:'咨询身份',width:100},
		{field:'consPatName',title:'患者姓名',width:100},
		{field:'consName',title:'记录人',width:100},
		{field:'consContact',title:'联系方式',width:100},
		{field:'consQusDesc',title:'问题描述',width:500},
		{field:'consDet',title:'明细',width:100,align:'center',formatter:SetCellUrl},
		{field:'LkDetial',title:'操作',width:100,align:'center',formatter:SetCellOpUrl}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'咨询明细',
		//nowrap:false,
		singleSelect : true,
		remoteSort:false,
		onLoadSuccess:function(data){
			///提示信息
    		LoadCellTip("consQusDesc");
		},
		onDblClickRow:function(rowIndex, rowData){
			showModifyWin(rowIndex);
		} 
	};
		
	var conDetListComponent = new ListComponent('conDetList', columns, '', option);
	conDetListComponent.Init();

	initScroll("#conDetList");//初始化显示横向滚动条

	queryConsultDetail();
}

/// 咨询药品列表
function InitConsDrugItem(){
	// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}

	//定义columns
	var columns=[[
	    {field:'consDesc',title:'药品名称',width:260,editor:texteditor},
	    {field:'consSpec',title:'规格',width:100,editor:texteditor},
		{field:'consForm',title:'剂型',width:100,editor:texteditor},
		{field:'consManf',title:'厂商',width:100,editor:texteditor},
		{field:'consInstruc',title:'用法',width:100,editor:texteditor},
		{field:'consDosage',title:'剂量',width:100,editor:texteditor},
		{field:'consDuration',title:'疗程',width:100,editor:texteditor},
		{field:'operation',title:'<a href="#" onclick="appendRow()"><img style="margin:5px 0px 0px 0px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>',width:30,align:'center',
			formatter:SetCellImgBtn}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		fit:'',
		//title:'药品明细',
		width:935,
		singleSelect : true,
		pagination : false,
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if ((editRow != "")||(editRow == "0")) { 
                $("#consDrugItem").datagrid('endEdit', editRow); 
            } 
            $("#consDrugItem").datagrid('beginEdit', rowIndex); 
            dataGridBindEnterEvent(rowIndex);  //设置回车事件
            editRow = rowIndex;
        }
	};
	
	var baseurl = url + "?action=QueryConsDrgItmList&consultID="+ consultID;
	var consDrugItemComponent = new ListComponent('consDrugItem', columns, baseurl, option);
	consDrugItemComponent.Init();
	
	//initScroll("#consDrugItem");//初始化显示横向滚动条
	//InitdatagridRow();
}

//初始化列表使用
function InitdatagridRow(){

	for(var k=0;k<4;k++)
	{
		$('#consDrugItem').datagrid('insertRow',{
			index: 0, // 行索引
			row: {
				consDesc:'', consSpec:'', consForm:'', consManf:'', consIntr:'', consDoage:'', consDurat:''
			}
		});
	}	
}

function setCurrEditRowCellVal(rowObj){
	///品名
	var ed=$("#consDrugItem").datagrid('getEditor',{index:editRow, field:'consDesc'});		
	$(ed.target).val(rowObj.InciDesc);
	///规格
	var ed=$("#consDrugItem").datagrid('getEditor',{index:editRow, field:'consSpec'});		
	$(ed.target).val(rowObj.Spec);
	///产地
	var ed=$("#consDrugItem").datagrid('getEditor',{index:editRow, field:'consManf'});		
	$(ed.target).val(rowObj.Manf);
	///剂型
	var ed=$("#consDrugItem").datagrid('getEditor',{index:editRow, field:'consForm'});		
	$(ed.target).val(rowObj.Form);
	
	///用法
	var ed=$("#consDrugItem").datagrid('getEditor',{index:editRow, field:'consInstruc'});		
	$(ed.target).val(rowObj.instru);
	
	///疗程
	var ed=$("#consDrugItem").datagrid('getEditor',{index:editRow, field:'consDuration'});		
	$(ed.target).val(rowObj.duration);
	
}

/// 给datagrid绑定回车事件
function dataGridBindEnterEvent(index){
	
	var editors = $('#consDrugItem').datagrid('getEditors', index);
	var workRateEditor = editors[0];
	workRateEditor.target.focus();  ///设置焦点
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#consDrugItem").datagrid('getEditor',{index:index, field:'consDesc'});		
			var input = $(ed.target).val();
			var mydiv = new UIDivWindow($(ed.target), input,500,500, setCurrEditRowCellVal);   //liyarong 2016-09-28
		    //var mydiv = new UIDivWindow($("#consPatMedNo"));
            mydiv.init();
		}
	});
}

 /**
  * 新建
  */
function newCreateConWin(){
	finiFlag="N"
	consultID = 0;
	newCreateConsult();
}

 /**
  * 新建咨询问题
  */
function newCreateConsult(){
	newCreateConsultWin(); //新建咨询窗口
	InitConsultDefault();  //初始化界面默认信息
}

 /**
  * 新建咨询窗口
  */
function newCreateConsultWin(){
	var option = {
			buttons:[{
				text:'保存',
				iconCls:'icon-save',
				handler:function(){
					saveConsultDetail();
					}
			},{
				text:'关闭',
				iconCls:'icon-cancel',
				handler:function(){
					$('#newConWin').dialog('close');
					$("#win").remove();
					}
			}]			
		};
	if(flag==1){
		var newConDialogUX = new DialogUX('修改药学咨询', 'newConWin', '970', '585', option);
	}
	else{
	    var newConDialogUX = new DialogUX('新建药学咨询', 'newConWin', '970', '585', option);
	}
	newConDialogUX.Init();
	
	///咨询药品明细
	InitConsDrugItem();
	flag=0;
}

 /**
  * 保存咨询数据
  */
function saveConsultDetail(){
	
	 if(finiFlag=="Y"){
		alert("请先取消完成后再进行修改!!!");
		return;
	 }
	
	/// 结束行编辑状态
	if ((editRow != "")||(editRow == "0")) { 
        $("#consDrugItem").datagrid('endEdit', editRow); 
    }
    
    //咨询身份
	var consIden=$('#consIden').combobox('getValue');
	if ((consIden == "")||(consIden == undefined)){
		showMsgAlert("错误提示:","咨询身份不能为空！");
		return;
	}
	
	//咨询部门
	var consDept=$('#consDept').combobox('getValue');
	if (consDept == ""){
		showMsgAlert("错误提示:","咨询部门不能为空！");
		return;
	}
	
	//患者ID
	var consPatientID = $("#consPatientID").val();
    
    //患者姓名
	var consPatName=$('#consPatName').val();
	if (consPatName == ""){
		showMsgAlert("错误提示:","患者姓名不能为空！");
		return;
	}

    //病历号
	var consPatMedNo=$('#consPatMedNo').val();

    //性别
	var consPatSex=$('#consPatSex').combobox('getValue');
	if (consPatSex == ""){
		showMsgAlert("错误提示:","性别不能为空！");
		return;
	}

    //年龄
	var consPatAge=$('#consPatAge').val();
	if (consPatAge == ""){
		showMsgAlert("错误提示:","年龄不能为空！");
		return;
	}
	
    //联系方式
	var consContact=$('#consContact').val();
	if (consContact == ""){
		showMsgAlert("错误提示:","联系方式不能为空！");
		return;
	}

   //特殊人群
	var consSpeCrowd=$('#consSpeCrowd').combobox('getValue'); 
	if((consSpeCrowd == "")||(consSpeCrowd == undefined)||(consSpeCrowd ==0)){
	    consSpeCrowd="";
	    }
    
    //问题类型
	var consType=$('#consType').combobox('getValue');
	if ((consType == "")||(consType == undefined)||(consType ==0)){
		showMsgAlert("错误提示:","问题类型不能为空！");
		return;
	}
	
    //诊断信息
	var consDiagDesc=$('#consDiagDesc').val();
	if (consDiagDesc == ""){
		showMsgAlert("错误提示:","诊断信息不能为空！");
		return;
	}
	
    //咨询方式
	var consWays=$('#consWays').combobox('getValue');
	if (consWays == ""){
		showMsgAlert("错误提示:","咨询方式不能为空！");
		return;
	}
	
    //参考资料
	var consRefMat=$('#consRefMat').combobox('getValue');
	if (consRefMat == ""){
		showMsgAlert("错误提示:","参考资料不能为空！");
		return;
	}
	
    //服务时间
	var consDuration=$('#consDuration').combobox('getValue');
	if (consDuration == ""){
		showMsgAlert("错误提示:","服务时间不能为空！");
		return;
	}
	
	//问题描述
	var consQusDesc=$('#consQusDesc').val(); 
	if (consQusDesc == ""){
		showMsgAlert("错误提示:","问题描述不能为空！");
		return;
	}
	if($('#consQusDesc').val().length>800){
			showMsgAlert("错误提示:","问题描述不能超过800字！");
			return;
			}
	//回答内容
	var consAnsDesc=$('#consAnsDesc').val(); 
	/*if (consAnsDesc == ""){
		showMsgAlert("错误提示:","回答内容不能为空！");
		return;
	}
	*/
	if($('#consAnsDesc').val().length>800){
			showMsgAlert("错误提示:","回答内容不能超过800字！");
			return;
			}
	var consultID = $("#consultID").val();
	
	
	var consDataList = consPatientID +"^"+ consPatName +"^"+ consPatSex +"^"+ consPatAge +"^"+ consContact +"^"+ consSpeCrowd +"^"+ consType +"^"+ consDiagDesc;
		consDataList = consDataList +"^"+ consWays +"^"+ consRefMat +"^"+ consDuration +"^"+ consQusDesc +"^"+ consAnsDesc +"^"+ "";
		consDataList = consDataList +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ "" +"^"+ LgUserID +"^"+ consIden +"^"+ consDept+"^"+ "PHC";

	/// 咨询药品列表
	var itemListData = drugListData();
	
	//保存数据
	$.post(url+'?action=savePatConsult',{"consultID":consultID,"consDataList":consDataList,"consDrgItmList":itemListData},function(jsonString){
		var jsonConsObj = jQuery.parseJSON(jsonString);
		if (jsonConsObj.ErrorCode == "0"){
			$('#newConWin').dialog('close');     //关闭窗体
			$('#conDetList').datagrid('reload'); //重新加载
		}else{
			$.messager.alert("提示:","提交失败,错误原因："+jsonConsObj.ErrorMessage);
		}
	});
}

 /**
  * 查询咨询数据
  */
function queryConsultDetail(){
	
	//1、清空datagrid 
	$('#conDetList').datagrid('loadData', {total:0,rows:[]});
	
	//2、查询
	var startDate=$('#startDate').datebox('getValue');   //起始日期
	var endDate=$('#endDate').datebox('getValue');       //截止日期

	var consDesc=$('#inConsDesc').val();    //咨询描述
	
	var params=startDate +"^"+ endDate +"^"+ LgUserID + "^" + consDesc +"^"+ "" +"^"+ "PHC" +"^"+LgHospID;

	$('#conDetList').datagrid({
		url:url + "?action=QueryPatConsult",	
		queryParams:{
			params:params}
	});
	
	//按照添加的顺序排序
	$("#conDetList").datagrid('sort', {     //qunianpeng  2016-09-12
		sortName: 'consultID', 
		sortOrder: 'asc'
	});
}

/// 删除咨询明细
function delConsultDetail(){
	showMsgAlert("错误原因:" , "删除功能暂时不可用！");
}

/// 添加咨询药品
function addConsultDrug(){
	//$("#consDrugItem").parent().parent().css({display:"block"})	
}

//链接设置formatter="SetCellUrl"
function SetCellUrl(value, rowData, rowIndex)
{
	return "<a href='#' onclick='showModifyWin("+rowIndex+")'>修改明细</a>";
	
}

//链接设置formatter="SetCellUrl"
function SetCellColor(value, rowData, rowIndex)
{
	var html = "";
	if (value == "Y"){
		html = "<span style='margin:0px 5px;font-weight:bold;color:red;'>完成</span>";		
	}else{
		html = "<span style='margin:0px 5px;font-weight:bold;color:green;'>No</span>";
		}
    return html;}


//操作
function SetCellOpUrl(value, rowData, rowIndex)
{
	var html = "";
	if (rowData.finiFlag != "Y"){
		html = "<a href='#' onclick='setConsultComplete("+"\""+rowData.consultID+"\""+","+"\"Y\""+")'>设置完成</a>";
	}else{
		html = "<a href='#' onclick='setConsultComplete("+"\""+rowData.consultID+"\""+","+"\"N\""+")'>取消完成</a>";
	}
    return html;
}


/// 设置完成状态
function setConsultComplete(consultID, consComFlag){

	//保存数据
	$.post(url+'?action=setConsultComplete',{"consultID":consultID, "consComFlag":consComFlag},function(jsonString){

		var jsonConsObj = jQuery.parseJSON(jsonString);
		if (jsonConsObj.ErrorCode == "0"){
			showMsgAlert("","设置成功！");
			$('#conDetList').datagrid('reload'); //重新加载
		}else{
			$.messager.alert("提示:","设置失败,错误原因："+jsonConsObj.ErrorMessage);
		}
	});
}

 /**
  * 修改窗体
  */
function showModifyWin(index){
    flag=1;
	var rowData = $('#conDetList').datagrid('getData').rows[index];
	consultID = rowData.consultID;
	finiFlag=rowData.finiFlag   //lbb  2019/11/18  取完成状态，完成后不能修改保存，只允许浏览
	newCreateConsult();  //新建填写窗口
	
	$("#consPatientID").val(rowData.consPatientID); 	        //病人ID
	$('#consPatName').val(rowData.consPatName);  				//患者姓名	
	$('#consPatMedNo').val(rowData.consPatNo);	    			//病历号
	$('#consPatSex').combobox('setValue',rowData.consPatSex);   //性别
	$('#consPatAge').val(rowData.consPatAge);    				//年龄
	$('#consContact').val(rowData.consContact);    				//联系方式
	$('#consSpeCrowd').combobox('setValue',rowData.consSpeCrowd); //特殊人群
	$('#consType').combobox('setValue',rowData.consQusT);         //问题类型
	$('#consDiagDesc').val(rowData.consDiagDesc);       		  //诊断信息
	$('#consWays').combobox('setValue',rowData.consWays);         //咨询方式
	$('#consRefMat').combobox('setValue',rowData.consRefMat);     //参考资料
	$('#consDuration').combobox('setValue',rowData.consDuration); //服务时间
	$('#consQusDesc').val(rowData.consQusDesc);  				  //问题描述
	$('#consAnsDesc').val(rowData.consAnsDesc);  				  //回答内容
	$("#consultID").val(rowData.consultID); 					  //咨询ID
	$("#consName").val(rowData.consName); 					      //咨询人
	$("#consIden").combobox('setValue',rowData.consIden); 		  //咨询身份
	$("#consDept").combobox('setValue',rowData.consDept); 		  //咨询部门
	$("#consDept").combobox('setText',rowData.consDeptDesc); 	  //咨询部门
}

/// 获取病人就诊信息
function GetPatEssInfoByPatNo(){

	var PatientNo=$('#consPatMedNo').val();    //登记号
	var patFlag=tkMakeServerCall("web.DHCSTPHCMCOMMON", "checkpatFlag",PatientNo,LgHospID)
    if(patFlag==1){
	    InitConsultDefault()
	    $.messager.alert("提示:","该患者不是本院区的患者");
	       return;
    }
	//保存数据
	$.post(url+'?action=GetPatEssInfoByPatNo',{"PatientNo":PatientNo},function(jsonString){
		var jsonConsObj = jQuery.parseJSON(jsonString);
		if (typeof jsonConsObj.PatientID != "undefined"){
			$("#consPatientID").val(jsonConsObj.PatientID); 	        //病人ID
			$('#consPatName').val(jsonConsObj.patname);  			    //患者姓名	
			$('#consPatMedNo').val(jsonConsObj.patno);    			    //病历号
			$('#consPatSex').combobox('setValue',jsonConsObj.sexId);    //性别
			$('#consPatAge').val(jsonConsObj.patage);    			    //年龄
			$('#consDiagDesc').val(jsonConsObj.patdiag);    			//诊断  nisijia 2016-09-29
		}
	});
}

/// 消息提示窗口
function showMsgAlert(ErrMsg , ErrDesc){
	$.messager.alert("提示:","<font >" + ErrMsg + "</font><font style='color:red;'>" + ErrDesc + "</font>");
}


/// 链接
function SetCellImgBtn(value, rowData, rowIndex)
{	
	return "<a href='#' onclick='deleteRow("+rowIndex+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
}

/// 删除行
function deleteRow(rowIndex)
{		
	// 行对象
    var rowobj={
		consDesc:'', consSpec:'', consForm:'', consManf:'', 
	  //  consIntr:'', consDoage:'', consDurat:''     //qunianpeng 2016-08-16
	   consInstruc:'',consDosage:'',consDuration:''
	};
	// 当前行数大于4,则删除，否则清空
	if(rowIndex=="-1"){
		$.messager.alert("提示:","请先选择行！");
		return;
	}
	var rows = $("#consDrugItem").datagrid('getRows');
	if(rows.length>4){
		 $("#consDrugItem").datagrid('deleteRow',rowIndex);
	}else{
		$("#consDrugItem").datagrid('updateRow',{
			index: rowIndex, // 行索引
			row: rowobj
		});
	}
	
	// 删除后,重新排序
	/*
	$("#consDrugItem").datagrid('sort', {
		sortName: 'consDesc', 
		sortOrder: 'desc'
	});
	*/
}

/// 追加行
function appendRow(){
	
	// 行对象
    var rowobj={
		consDesc:'', consSpec:'', consForm:'', consManf:'', 
	    consInstruc:'', consDosage:'', consDuration:''
	};
	$("#consDrugItem").datagrid('appendRow',rowobj);
}

/// 药品列表
function drugListData(){
	
	var tmpItmArr=[];
	//怀疑药品
	var rowsItems = $('#consDrugItem').datagrid('getRows');
	$.each(rowsItems, function(index, item){
		if(item.consDesc!=""){
		    var tmp = item.consDesc +"^"+ trsUndefinedToEmpty(item.consSpec) +"^"+ trsUndefinedToEmpty(item.consForm) +"^"+ trsUndefinedToEmpty(item.consManf);
		    tmp =  tmp +"^"+ trsUndefinedToEmpty(item.consInstruc) +"^"+ trsUndefinedToEmpty(item.consDosage) +"^"+ trsUndefinedToEmpty(item.consDuration);
		    tmpItmArr.push(tmp);
		}
	})
	return tmpItmArr.join("!!");
}

//未填项默认为空
function trsUndefinedToEmpty(str)
{
	if(typeof str=="undefined"){
		str="";
	}
	return str;
}

//登记号位数不足时，补零    qunianpeng 2016-09-12 
function SetPatNoLength(){	
	var PatientNo=$('#consPatMedNo').val();    //登记号
	if(PatientNo!=""){
	var PatLen=PatientNo.length;			
	if(PatLen<10)     //登记号长度为10位
	{
		for (i=1;i<=10-PatLen;i++)
		{
			PatientNo="0"+PatientNo; 
		}
	}
	$('#consPatMedNo').val(PatientNo);
	}
}