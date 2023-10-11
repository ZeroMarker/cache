/// Creator: lvpeng 
/// CreateDate: 2018-02-11
///  Descript: 过敏录入hisui
var TagCode="",CategoryRowId="";selectRowIndex=""
$(document).ready(function() {
	
	hosNoPatOpenUrl = getParam("hosNoPatOpenUrl"); //hxy 2023-03-09 st
	hosNoPatOpenUrl?hosOpenPatList(hosNoPatOpenUrl):''; //ed
	
	if(PatientID==""){
		PatientID=serverCall("web.DHCEMCommonUtil","GetPatientID",{EpisodeID:EpisodeID})
	}
	if (IsOnlyShowPAList=="N"){
    	loadCurDate();   //时间控件加载当前时间
	
		initMethod();
		//过敏类型
		$HUI.combobox("#MRCATTagDescription",{
			valueField:'id',
			textField:'text',
			panelHeight:"auto",
			url:LINK_CSP+"?ClassName=web.DHCEMAllergyEnter&MethodName=LookUpByType",
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
			url:LINK_CSP+"?ClassName=web.DHCEMAllergyEnter&MethodName=listAlgMrcCat",
			onSelect:function(option){
				//分类关联过敏源
				CategoryRowId=option.id;	
				$HUI.combobox("#ALGDescCT",{
	   			url:LINK_CSP+"?ClassName=web.DHCEMAllergyEnter&MethodName=listAlgDescCT&CategoryRowId="+CategoryRowId   
			});
			}
		}); 
		
		//过敏源
		$HUI.combobox("#ALGDescCT",{
			valueField:'id',
			textField:'text',
			url:LINK_CSP+"?ClassName=web.DHCEMAllergyEnter&MethodName=listAlgDescCT"   
		});  	
	 	//过敏项目
	 	$HUI.combobox("#ALGItem",{
		 	valueField:'id',
			textField:'text',
			mode:'remote',
			url:LINK_CSP+"?ClassName=web.DHCEMAllergyEnter&MethodName=listAlgItem",
			onSelect:function(option){
				var ARCIMRowid=option.id;	
				runClassMethod( "web.DHCPAAllergy", "GetALGStr", {"ARCIMRowid":ARCIMRowid,"CategoryRowId":"","TagCode":""}, function(data){
				if(data!=""){
					$HUI.combobox("#ALGDescCT").setValue(data.split("^")[5]);
					return;
					}	
				},"text");
			}
		});
	}
	//过敏记录表 
    $HUI.datagrid('#allergytb',{
	    fit:true,
	    pagination:true,
	    singleSelect:true,
	    fitColumns:true,
	    title:$g('过敏记录'), //hxy 2018-10-09 st
	    iconCls:'icon-paper',
	    headerCls:'panel-header-gray', //配置项使表格变成灰色
        toolbar: [], //配置项toolbar为空时,会在标题与列头产生间距" //hxy ed
        url: 'dhcapp.broker.csp?ClassName=web.DHCEMAllergyEnter&MethodName=QueryAllergyInfoNew&PatientID='+PatientID,
        columns:[[
      	{
		field: 'Category',
		title: '分类',
		align: 'center'
		}, {
		field: 'Allergen',
		title: '过敏原',
		align: 'center'
		}, {
		field: 'ALGItem',
		title: '过敏项目',
		align: 'center'
		},  {
		field: 'Comments',
		title: '注释',
		align: 'center'
		}, {
		field: 'Status',
		title: '状态',
		align: 'center',
		formatter:FormStatus
		},{
		field: 'OnsetDateText',
		title: '发作日期',
		align: 'center'
		}, {
		field: 'LastUpdateUser',
		title: '最后更新用户',
		align: 'center'
		}, {
		field: 'LastUpdateDate',
		title: '最后更新日期',
		align: 'center'
		}, {
		field: 'tag',
		title: '过敏类型',
		align: 'center'
		},{
		field: 'operation',
		title: '操作',
		align: 'center'	,
		formatter:opFormatter
		}
		]],
		onSelect:function(rowIndex,rowData){
			
			if((selectRowIndex==="")||((selectRowIndex!=="")&&(selectRowIndex!==rowIndex))){   //选中
				selectRowIndex=rowIndex;
				loadLeftPanel(rowData.RowID);
			}else if(selectRowIndex===rowIndex){    											//取消选中		
				$HUI.datagrid('#allergytb').unselectRow(rowIndex);
				selectRowIndex="";
				clearLeftPanel();
			}
		}
		
    });
    if (IsOnlyShowPAList=="Y"){
	    $HUI.datagrid('#allergytb').hideColumn('operation');
	}
    //$('#clearMRCATTagDescription').on('click',UpdateALLItem);
});	
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
	var MRCATTagDescription=$('#MRCATTagDescription').combobox('getText');
	var MRCATTagDescriptionCode=$('#MRCATTagDescription').combobox('getValue');
	

	//过敏分类
	var ALGMRCCat=$('#ALGMRCCat').combobox('getValue');
	//过敏源
	var ALGDescCT=$('#ALGDescCT').combobox('getValue');
	//过敏项目
	var ALGItem=$.trim($('#ALGItem').combobox('getValue'));
	if ((MRCATTagDescriptionCode=="I")||(MRCATTagDescriptionCode=="P")||(MRCATTagDescriptionCode=="G")){
		//如果选择了过敏类型,过敏项目要从下拉框中选取数据
		if (ALGItem==$.trim($('#ALGItem').combobox('getText'))){
			$.messager.alert("提示","过敏类型不为空时,请在过敏项目下拉框中选择数据!");
		    return;	
		}
	}
	if(ALGItem=="undefined"){
		ALGItem=""
	}
	//过敏情况补充
	var ALGComments=$('#ALGComments').val();
	
	//过敏冲突检测开启  
	var ALGCheckConflict = "";
    $("input[type=checkbox][name=ALGCheckConflict]:checked").each(function(){
		if($(this).is(':checked')){
			ALGCheckConflict =this.value;
		}
	})
	if(ALGDescCT==null){ALGDescCT=""}
	if(ALGItem==null){ALGItem=""}
	if ((ALGDescCT=="")&&(ALGItem==""))
	{
		$.messager.alert("提示","过敏源和过敏项目必须至少填一项!");
		return;
	}
	var id =""
	var rowsData = $("#allergytb").datagrid("getSelections");
	if(rowsData.length=="1"){
		id =rowsData[0].RowID;
	}

	var list=EpisodeID+"!!"+ALGOnsetDate+"!!"+MRCATTagDescription+"!!"+ALGMRCCat+"!!"+ALGDescCT+"!!"+ALGItem+"!!"+ALGComments+"!!"+ALGCheckConflict+"!!"+MRCATTagDescriptionCode+"!!"+LgUserID+"!!"+PatientID+"!!"+""; //2016-10-26
    runClassMethod( "web.DHCEMAllergyEnter", "SaveAllergyInfo", { 'list':list,'id':id}, function(data){
		if(data!=-1){
			clearLeftPanel();
			$.messager.alert("提示","保存成功!");
		}
		$('#allergytb').datagrid('load', {   
    			PatientID:PatientID
			}); 
	},"text");
	
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


//格式换状态字段
function FormStatus	(value){
	if(value=="A"){
		return "Active"
	}
	if(value=="I"){
		return "Inactive"
	}
	if(value==""){
		return ""
	}
	}
 
function UpdateALLItem(){
	TagCode=$e($("#MRCATTagDescription").combobox('getValue'));
	//$('#ALGItem').val(0);
	//过敏项目
	$HUI.combobox('#ALGItem',{
		url:LINK_CSP+"?ClassName=web.DHCEMAllergyEnter&MethodName=listAlgItem&TagCode="+TagCode   
	});
	//$('#ALGMRCCat').val(0);
	$HUI.combobox('#ALGMRCCat',{
		url:LINK_CSP+"?ClassName=web.DHCEMAllergyEnter&MethodName=listAlgMrcCat&tag="+TagCode 
	}); 	  
	}

function $e(value){
	if(value==null) return ""
	return value;
}

///QQA 2017-03-22
///清空左侧面板
function clearLeftPanel(){
	$("#MRCATTagDescription").combobox('clear'); //huaxiaoying 2017-02-06 st
	$("#ALGMRCCat").combobox('clear');
	$("#ALGDescCT").combobox('clear');
	$("#ALGItem").combobox('clear');
	//$("#ALGComments").empty(); //  并不能清空
	$("#ALGComments").val("");   //QQA 2017-03-02
	$("#ALGCheckConflict").checkbox('uncheck'); //hxy 2017-02-06 en
	UpdateALLItem();	
}

///QQA 2017-03-22
///加载左侧面板数据
function loadLeftPanel(allRowId){
	runClassMethod("web.DHCEMAllergyEnter","GetAllergenDetails",
		{ID:allRowId},
		function(data){
			$("#ALGOnsetDate").datebox('setValue',data.ALGDate);  //开始日期
			$("#MRCATTagDescription").combobox('setValue',data.TagCode);  //过敏类型
			
			if (data.CategoryRowId==0) data.CategoryRowId=""

			//过敏项目
			$HUI.combobox('#ALGItem',{
				url:LINK_CSP+"?ClassName=web.DHCEMAllergyEnter&MethodName=listAlgItem&TagCode="+data.TagCode+"&q="+encodeURI(data.ALGItem.substring(0,5)) 
			});				
						
			$HUI.combobox('#ALGMRCCat',{
				url:LINK_CSP+"?ClassName=web.DHCEMAllergyEnter&MethodName=listAlgMrcCat&tag="+data.TagCode 
			}); 
			$("#ALGMRCCat").combobox('setValue',data.CategoryRowId);        			//过敏分类
			$("#ALGDescCT").combobox('setValue',data.AllergenRowId);					//过敏源
			
			$("#ALGItem").combobox('setValue',data.ALGItemRowId);						//过敏项目
			$("#ALGComments").val(data.Comments);										//过敏情况补充
			if(data.ALGCheckConflict=="on"){
				$("#ALGCheckConflict").checkbox('check');	
			}else{
				$("#ALGCheckConflict").checkbox('uncheck');	
			}
			
		})
}

///删除按钮
function opFormatter(value, rowData){
	//return "<a href='#' style='background: red;border: 1px solid;color: white;box-sizing: border-box;' class='hisui-linkbutton' iconCls='icon-remove'  onclick='delAllergy(this);' data-Id='"+rowData.RowID+"'  ><img style='margin-left:3px;position:relative;top: 4px;' src='../scripts/dhcadvEvt/jQuery/themes/icons/cancel.png' border=0/>删除</a>" 
	return "<a href='#' class='hisui-linkbutton' iconCls='icon-cancel'  onclick='delAllergy(this);' data-Id='"+rowData.RowID+"'  ><img src='../scripts/dhcnewpro/images/cancel.png' border=0/></a>"  //hxy 2018-10-23 change
}	

function delAllergy(thisObj){
	//删除操作
	//重新加载表格
	var id = $(thisObj).attr("data-id");
	 runClassMethod( "web.DHCEMAllergyEnter", "DeleteAllergen", { 'EpisodeID':EpisodeID,'id':id}, function(data){
		if(data!=-1){
			clearLeftPanel();
			$.messager.alert("提示","删除成功!");
		}
		$('#allergytb').datagrid('load', {   
			    RegNo:RegNo 
			}); 
	},"text");
	
	return false;
}

function loadCurDate(){
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
		
	$('#ALGOnsetDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});

}

function initMethod(){
	
}
