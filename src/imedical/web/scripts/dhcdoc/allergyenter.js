/// CreateDate: 2018-02-11
///  Descript: 过敏录入hisui
var TagCode="",CategoryRowId="";selectRowIndex=""
$(document).ready(function() {
	if (IsOnlyShowPAList=="N"){
    	loadCurDate();   //时间控件加载当前时间
	
		initMethod();
		//过敏类型
		$HUI.combobox("#MRCATTagDescription",{
			valueField:'id',
			textField:'text',
			panelHeight:"auto",
			url:LINK_CSP+"?ClassName=web.DHCDocAllergyEnter&MethodName=LookUpByType",
			onSelect:function(option){
				UpdateALLItem();	
			},
			onChange:function(newValue,oldValue){
				if(newValue==undefined){
					$HUI.combobox("#MRCATTagDescription").setValue("");
					UpdateALLItem();
				}	
			}
		});
		 //过敏分类  
		$HUI.combobox("#ALGMRCCat",{
			valueField:'id',
			textField:'text',
			url:LINK_CSP+"?ClassName=web.DHCDocAllergyEnter&MethodName=listAlgMrcCat",
			onSelect:function(option){
				if (option) {
					//分类关联过敏源
					CategoryRowId=option.id;	
					$HUI.combobox("#ALGDescCT",{
		   				url:LINK_CSP+"?ClassName=web.DHCDocAllergyEnter&MethodName=listAlgDescCT&CategoryRowId="+CategoryRowId   
					});
				}
			},
			onChange:function(newValue,oldValue){
				if (newValue==""){
					CategoryRowId="";	
					$HUI.combobox("#ALGDescCT",{
		   				url:LINK_CSP+"?ClassName=web.DHCDocAllergyEnter&MethodName=listAlgDescCT&CategoryRowId="+CategoryRowId   
					});
				}
			},
			onLoadSuccess:function(){
				CategoryRowId="";	
				$HUI.combobox("#ALGDescCT",{
	   				url:LINK_CSP+"?ClassName=web.DHCDocAllergyEnter&MethodName=listAlgDescCT&CategoryRowId="+CategoryRowId   
				});
			}
		}); 
		
		//过敏源
		$HUI.combobox("#ALGDescCT",{
			valueField:'id',
			textField:'text',
			url:LINK_CSP+"?ClassName=web.DHCDocAllergyEnter&MethodName=listAlgDescCT"   
		});  	
	 	//过敏项目
	 	IntALGItemLookUp();
	 	/*
	 	$HUI.combobox("#ALGItem",{
		 	valueField:'id',
			textField:'text',
			enterNullValueClear:false,
			mode:'remote',
			url:LINK_CSP+"?ClassName=web.DHCDocAllergyEnter&MethodName=listAlgItem",
			onSelect:function(option){
				var ARCIMRowid=option.id;	
				runClassMethod( "web.DHCPAAllergy", "GetALGStr", {"ARCIMRowid":ARCIMRowid,"CategoryRowId":"","TagCode":""}, function(data){
				if(data!=""){
					var ALGTypeDR=data.split("^")[6];
					if (ALGTypeDR) {
						$HUI.combobox("#ALGMRCCat").select(ALGTypeDR);
					}else{
						$HUI.combobox("#ALGMRCCat").setValue("");
					}
					setTimeout(function(){
						$HUI.combobox("#ALGDescCT").setValue(data.split("^")[5]);
					},500);
					return;
				}	
				},"text");
			}
		});
		*/
	}
	
	var OrdColumns=[[
      	{field: 'Category',title: $g('分类'),align: 'center',width:150},
		{field: 'Allergen',title: $g('过敏原'),align: 'center',width:250},
		{field: 'ALGItem',title: $g('过敏项目'),align: 'center',width:250},
		{field: 'Comments',title: $g('注释'),align: 'center',width:200},
		{field: 'Status',title: $g('状态'),align: 'center',width:200,formatter:FormStatus},
		//{field: 'ALGCheckConflict',title: $g('冲突检测是否开启'),align: 'center',width:200},
		{field: 'OnsetDateText',title: $g('发作日期'),align: 'center',width:200},
		{field: 'LastUpdateUser',title: $g('最后更新用户'),align: 'center',width:200},
		{field: 'LastUpdateDate',title: $g('最后更新日期'),align: 'center',width:200},
		{field: 'tag',title: $g('过敏类型'),align: 'left'},	///,hidden:true
		{field: 'operation',title: $g('操作'),align: 'center',width:200,formatter:opFormatter}
		]]; 
	var Property={
		fit:true,
	    pagination:true,
	    singleSelect:true,
	    fitColumns:false,
	    title:(IsOnlyShowPAList=="N"?'过敏记录':""), //hxy 2018-10-09 st
		border:(IsOnlyShowPAList=="N"?true:false), 
	    iconCls:'icon-paper',
	    headerCls:'panel-header-gray', //配置项使表格变成灰色
		bodyCls:'panel-body-gray',
        toolbar: [], //配置项toolbar为空时,会在标题与列头产生间距" //hxy ed
        url: 'dhcapp.broker.csp?ClassName=web.DHCDocAllergyEnter&MethodName=QueryAllergyInfoNew&PatientID='+PatientID,
        columns:OrdColumns,
		onSelect:function(rowIndex,rowData){
			
			if((selectRowIndex==="")||((selectRowIndex!=="")&&(selectRowIndex!==rowIndex))){   //选中
				selectRowIndex=rowIndex;
				loadLeftPanel(rowData.RowID);
			}else if(selectRowIndex===rowIndex){    											//取消选中		
				$HUI.datagrid('#allergytb').unselectRow(rowIndex);
				selectRowIndex="";
				clearLeftPanel();
				InitCurDate();
			}
		}
	};
	if (ShowEMRBtn=="Y"){
		$.extend(Property,{
			toolbar:[{
	            text: '引用到病历',
	            iconCls: 'icon-apply-adm',
	            handler: function() {
		            debugger
		            var EMRReturnValue={"UpdateEMR":true,"QueryAllergiesList":""};
		            window.returnValue=$.extend(window.returnValue,EMRReturnValue);
		            
					if (typeof(parent.invokeChartFun) === 'function'){
						if(PAAdmType!="E"){
							parent.invokeChartFun('门诊病历', 'updateEMRInstanceData', "allergic", EMRReturnValue);
						}else{
							parent.invokeChartFun('门急诊病历记录', 'updateEMRInstanceData', "allergic", EMRReturnValue);
						}
					}else if ((typeof(window.opener) !== 'undefined')&&(typeof(window.opener.updateEMRInstanceData) === 'function')){
						window.opener.updateEMRInstanceData("allergic", EMRReturnValue);
					}
					if (typeof(parent.closeDialog) === 'function'){
						parent.closeDialog("dialogLinkAllergic");
					}
					window.close();
				}
	        }]
		})
	}
	//过敏记录表 
    $HUI.datagrid('#allergytb',Property);
    if (IsOnlyShowPAList=="Y"){
	    $HUI.datagrid('#allergytb').hideColumn('operation');
	}
    //$('#clearMRCATTagDescription').on('click',UpdateALLItem);
    //医生站设置->常规设置->过敏冲突检测开启
    if (ALGCheckConflictOpen=="1"){
	    //$("#ALGCheckConflict").checkbox('check');
	}
});	


function IntALGItemLookUp(){
	$("#ALGItem").lookup({
		width:$("#ALGItem").parent().width(),
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'id',
        textField:'text',
        columns:[[  
           {field:'text',title:$g('名称'),width:320,sortable:true},
            {field:'id',title:$g('项目ID'),width:70,sortable:true}
        ]],
        pagination:true,
        width:150,
        panelWidth:400,
        panelHeight:400,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCDocAllergyEnter',QueryName: 'QueryAlgItem'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        if (desc=="") return false;
	        var TagCode=$("#MRCATTagCode").val()	//$("#MRCATTagDescription").combobox('getValue');
	        //过敏源
	        var PACAllergyCode=$("#ALGDescCT").combobox('getValue');
			param = $.extend(param,{ALGItem:desc,TagCode:TagCode,GroupID:session['LOGON.GROUPID'],q:desc,PACAllergyCode:PACAllergyCode});
	    },onSelect:function(ind,item){
		   var ARCIMRowid=item.id;
		   $("#ALGItemRowid").val(ARCIMRowid);
		   $("#MRCATTagCode").val(item.TagCode);
		   	
			runClassMethod( "web.DHCPAAllergy", "GetALGStr", {"ARCIMRowid":ARCIMRowid,"CategoryRowId":"","TagCode":""}, function(data){
			if(data!=""){
				var ALGTypeDR=data.split("^")[6];
				if (ALGTypeDR) {
					$HUI.combobox("#ALGMRCCat").select(ALGTypeDR);
				}else{
					$HUI.combobox("#ALGMRCCat").setValue("");
				}
				setTimeout(function(){
					$HUI.combobox("#ALGDescCT").setValue(data.split("^")[5]);
				},500);
				return;
			}	
			},"text");
		}
    });
}

function UpdateOnClick()
{  
    //过敏日期
    var ALGOnsetDate=$('#ALGOnsetDate').datebox('getValue');
    if (ALGOnsetDate==""){$.messager.alert("提示","请选择过敏日期!");return}
    if(!compareSelTimeAndCurTime(ALGOnsetDate)){
		$.messager.alert("提示","请重新选择有效的过敏日期!");
		return;	
	}
	//过敏类型
	var MRCATTagDescription=""	//$('#MRCATTagDescription').combobox('getText');
	var MRCATTagDescriptionCode=""	//$('#MRCATTagDescription').combobox('getValue');
	var MRCATTagDescriptionCode=$("#MRCATTagCode").val();

	//过敏分类
	var ALGMRCCat=$('#ALGMRCCat').combobox('getValue');
	//过敏源
	var ALGDescCT=$('#ALGDescCT').combobox('getValue');
	//过敏项目
	//var ALGItem=$.trim($('#ALGItem').combobox('getValue'));
	var ALGItem=$("#ALGItemRowid").val();
	var ALGItemDesc=$("#ALGItem").lookup("getText");
	if (ALGItemDesc=="") ALGItem="";
	/*
	if ((MRCATTagDescriptionCode=="I")||(MRCATTagDescriptionCode=="P")||(MRCATTagDescriptionCode=="G")){
		//如果选择了过敏类型,过敏项目要从下拉框中选取数据
		if (ALGItem==$.trim($('#ALGItem').combobox('getText'))){
			$.messager.alert("提示","过敏类型不为空时,请在过敏项目下拉框中选择数据!");
		    return;	
		}
	}*/
	
	if(ALGItem=="undefined"){
		ALGItem=""
	}
	if ((ALGItem=="")&&(ALGItemDesc!="")){
		$.messager.alert("提示","请在过敏项目下拉框中选择数据!");
	    return;	
	}
	//过敏情况补充
	var ALGComments=$('#ALGComments').val();
	
	//过敏冲突检测开启  
	var ALGCheckConflict =  ""	//$("#ALGCheckConflict").checkbox('getValue')?"on":"";
    /*$("input[type=checkbox][name=ALGCheckConflict]:checked").each(function(){
		if($(this).is(':checked')){
			ALGCheckConflict =this.value;
		}
	})*/
	if(ALGDescCT==null){ALGDescCT=""}
	if(ALGItem==null){ALGItem=""}
	//过敏原补充
	var ALGDescAdd=$('#ALGDescAdd').val();
	if ((ALGDescCT=="")&&(ALGItem=="")&&(ALGDescAdd==""))
	{
		$.messager.alert("提示","过敏原和过敏项目、过敏原补充至少填一项!");
		return;
	}
	var id =""
	var rowsData = $("#allergytb").datagrid("getSelections");
	if(rowsData.length=="1"){
		id =rowsData[0].RowID;
	}
	
	var list=EpisodeID+"!!"+ALGOnsetDate+"!!"+MRCATTagDescription+"!!"+ALGMRCCat+"!!"+ALGDescCT+"!!"+ALGItem+"!!"+ALGComments+"!!"+ALGCheckConflict+"!!"+MRCATTagDescriptionCode+"!!"+LgUserID+"!!"+PatientID+"!!"+"" +"!!"+ALGDescAdd; //2016-10-26
    runClassMethod( "web.DHCDocAllergyEnter", "SaveAllergyInfo", { 'list':list,'id':id}, function(data){
		if(data!=-1){
			clearLeftPanel();
			$.messager.popover({msg: '保存成功！',type:'success'});
			InitCurDate();
			RefreshTabsTitleAndStyle();
			if(CDSSObj) CDSSObj.SynAllergy(EpisodeID);
			selectRowIndex="";
		}
		$('#allergytb').datagrid('load', {   
    			PatientID:PatientID
			}); 
	},"text");
	
}
//选择时间与当前时间比较
function compareSelTimeAndCurTime(SelDate)
{
	if (SelDate.indexOf("-")>=0) {
		var SelDateArr=SelDate.split("-");
		var SelYear=SelDateArr[0];
		var SelMonth=parseInt(SelDateArr[1]);
		var SelDate=parseInt(SelDateArr[2]);
	}else{
		var SelDateArr=SelDate.split("/");
		var SelYear=SelDateArr[2];
		var SelMonth=parseInt(SelDateArr[1]);
		var SelDate=parseInt(SelDateArr[0]);
	}
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


//格式换状态字段
function FormStatus	(value){
	if(value=="A"){
		return $g("有效")
	}
	if(value=="I"){
		return $g("无效")
	}
	if(value==""){
		return ""
	}
	}
 
function UpdateALLItem(){
	TagCode=""	//$g($("#MRCATTagDescription").combobox('getValue'));
	//$('#ALGItem').val(0);
	//过敏项目
	/*
	$HUI.combobox('#ALGItem',{
		url:LINK_CSP+"?ClassName=web.DHCDocAllergyEnter&MethodName=listAlgItem&TagCode="+TagCode   
	});
	*/
	$("#ALGItemRowid").val("");
	$("#ALGItem").lookup("setText","");
	
	//$('#ALGMRCCat').val(0);
	$HUI.combobox('#ALGMRCCat',{
		url:LINK_CSP+"?ClassName=web.DHCDocAllergyEnter&MethodName=listAlgMrcCat&tag="+TagCode 
	}); 	  
}

/*function $g(value){
	if(value==null) return ""
	return value;
}*/

///QQA 2017-03-22
///清空左侧面板
function clearLeftPanel(){
	//$("#MRCATTagDescription").combobox('clear'); //huaxiaoying 2017-02-06 st
	$("#MRCATTagCode").val("");
	$("#ALGMRCCat").combobox('clear');
	$("#ALGDescCT").combobox('clear');
	//$("#ALGItem").combobox('clear');
	$("#ALGItemRowid").val("");
	$("#ALGDescAdd").val("");
	$("#ALGItem").lookup("setText","");
	//$("#ALGComments").empty(); //  并不能清空
	$("#ALGComments").val("");   //QQA 2017-03-02
	//$("#ALGCheckConflict").checkbox('uncheck'); //hxy 2017-02-06 en
	/* 	if(ALGCheckConflictOpen=="1"){
		$("#ALGCheckConflict").checkbox('check');	
	}else{
		$("#ALGCheckConflict").checkbox('uncheck');	
	} */
	UpdateALLItem();	
}

///QQA 2017-03-22
///加载左侧面板数据
function loadLeftPanel(allRowId){
	runClassMethod("web.DHCDocAllergyEnter","GetAllergenDetails",
		{ID:allRowId},
		function(data){
			var data=eval('(' + data + ')'); 
			$("#ALGOnsetDate").datebox('setValue',data.ALGDate);  //开始日期
			//$("#MRCATTagDescription").combobox('setValue',data.TagCode);  //过敏类型
			$("#MRCATTagCode").val(data.TagCode);
			if (data.CategoryRowId==0) data.CategoryRowId=""

			//过敏项目
			/*
			$HUI.combobox('#ALGItem',{
				url:LINK_CSP+"?ClassName=web.DHCDocAllergyEnter&MethodName=listAlgItem&TagCode="+data.TagCode+"&q="+encodeURI(data.ALGItem.substring(0,5)) 
			});	
			$("#ALGItem").combobox('setValue',data.ALGItemRowId);
			*/				
			$("#ALGItemRowid").val(data.ALGItemRowId);
			$("#ALGItem").lookup("setText",data.ALGItem);		
			/*$HUI.combobox('#ALGMRCCat',{
				url:LINK_CSP+"?ClassName=web.DHCDocAllergyEnter&MethodName=listAlgMrcCat&tag="+data.TagCode 
			});*/ 
			$("#ALGMRCCat").combobox('select',data.CategoryRowId);        			//过敏分类
			$("#ALGDescAdd").val(data.ALGDescAdd);
								//过敏项目
			$("#ALGComments").val(data.Comments);										//过敏情况补充
			/* 			if(data.ALGCheckConflict=="on"){
				$("#ALGCheckConflict").checkbox('check');	
			}else{
				$("#ALGCheckConflict").checkbox('uncheck');	
			} */
			setTimeout(function(){
				$("#ALGDescCT").combobox('setValue',data.AllergenRowId);					//过敏源
			},500)
		},"text")
}

///删除按钮
function opFormatter(value, rowData){
	if (rowData.Status=="I") return;
	//return "<a href='#' class='hisui-linkbutton' iconCls='icon-cancel'  onclick='delAllergy(this);' data-Id='"+rowData.RowID+"'  ><img src='../scripts/dhcnewpro/images/cancel.png' border=0/></a>"  //hxy 2018-10-23 change
	//return "<a href='#' class='hisui-linkbutton' iconCls='icon-cancel'  onclick='cancelAllergy(this);' data-Id='"+rowData.RowID+"' ><img src='../scripts/dhcnewpro/images/cancel.png' border=0/></a>"  //hxy 2018-10-23 change
	return "<a href='#'  onclick='cancelAllergy(this);' data-Id='"+rowData.RowID+"' ><div class='icon icon-cancel' style='height:16px;width:auto;text-aglin:center'></div></a>"  //hxy 2018-10-23 change
}	
function cancelAllergy(thisObj){
	var id = $(thisObj).attr("data-id");
	 runClassMethod( "web.DHCDocAllergyEnter", "CancelPatAllergy", {'id':id,'UserID':session['LOGON.USERID']}, function(data){
		if(data==0){
			clearLeftPanel();
			if(CDSSObj) CDSSObj.SynAllergy(EpisodeID);
			$.messager.popover({msg: '取消成功!',type:'success',timeout: 1000});
		}
		$('#allergytb').datagrid('load', {   
		    RegNo:RegNo 
		}); 
	},"text");
	
	return false;
}
function delAllergy(thisObj){
	//删除操作
	//重新加载表格
	var id = $(thisObj).attr("data-id");
	 runClassMethod( "web.DHCDocAllergyEnter", "DeleteAllergen", { 'EpisodeID':EpisodeID,'id':id}, function(data){
		if(data!=-1){
			clearLeftPanel();
			$.messager.popover({msg: '删除成功!',type:'success',timeout: 1000});
			RefreshTabsTitleAndStyle();
			if(CDSSObj) CDSSObj.SynAllergy(EpisodeID);
		}
		$('#allergytb').datagrid('load', {   
		    RegNo:RegNo 
		}); 
	},"text");
	
	return false;
}
function InitCurDate(){
	runClassMethod("web.DHCEMCommonUtil","DateFormat",{},  //hxy 2017-03-07 日期格式走配置
	function(data){
		if(data==3){
			$("#ALGOnsetDate").datebox('setValue',new Date().Format("yyyy-MM-dd"))
	    }else if(data==4){
		    $("#ALGOnsetDate").datebox('setValue',new Date().Format("dd/MM/yyyy"))
		}else{
			return;
		}
	});
}
function loadCurDate(){
	InitCurDate();
	$('#ALGOnsetDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});

}

function initMethod(){
	
}
function RefreshTabsTitleAndStyle(){
	/*
	s val=##class(websys.DHCChartStyle).GetAllergyStyle($G(%request.Data("PatientID",1)),$G(%request.Data("EpisodeID",1)),$G(%request.Data("mradm",1)))
	*/
	if (parent.refreshTabsTitleAndStyle){
		/*var options=parent.$('#tabsReg').tabs("getSelected").panel('options');
		var title=options.title.split("(")[0];
		var code=options.id;
		var RetJson=$.cm({
			ClassName:"websys.DHCChartStyle",
			MethodName:"GetAllergyStyle",
			PatientID:"", EpisodeID:EpisodeID, mradm:"",
			dataType:"text"
		},false)
		if (RetJson!=""){
			var RetJson=eval('(' + RetJson + ')');
			var count=RetJson.count;
			var className=RetJson.className;
		}else{
			var count=0;
			var className="";
		}
		var newJsonArr = new Array();
		var newJson={};
		var childArr=new Array();
		childArr.push({"code":code,"text":title,"count":count,"className":className});
		newJson.children=childArr;
		newJsonArr.push(newJson);
		parent.refreshTabsTitleAndStyle(newJsonArr);*/
		parent.reloadMenu();
		parent.refreshBar();
	}else{
		if (parent.refreshBar){
			parent.refreshBar();
		}
	}
}
function ClearOnClick(){
	clearLeftPanel();
	InitCurDate();
	$('#allergytb').datagrid('load', {   
		PatientID:PatientID
	}); 
}
