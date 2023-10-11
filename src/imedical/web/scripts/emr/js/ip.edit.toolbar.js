///////////////////////////////工具栏操作////////////////////////////////////////////////////
var mainpage = parent;
var frameNav = mainpage.navPage;
var hidePersonalCategoryID = getHidePersonalCategoryID();
var ShowCreateRecordCategoryID = getShowCreateRecordCategoryID();
//屏蔽工具栏的右键(右键刷新会导致按钮状态不对)
document.oncontextmenu = function(){
	return false;
}
function initToolBarTitle(){
	$("#save").attr("title",emrTrans("保存"));
	$("#print").attr("title",emrTrans("打印"));
	$("#autoprint").attr("title",emrTrans("自动续打"));
	$("#printView").attr("title",emrTrans("开启预览"));
	$("#printOne").attr("title",emrTrans("单独打印"));
	$("#batchprint").attr("title",emrTrans("批量打印"));
	$("#verifySigned").attr("title",emrTrans("验证CA签名"));
	$("#unLock").attr("title",emrTrans("手工解锁"));
	$("#applyedit").attr("title",emrTrans("申请编辑病历"));
	$("#reference").attr("title",emrTrans("病历参考"));
	$("#binddatareload").attr("title",emrTrans("更新数据"));
	$("#loadRecord").attr("title",emrTrans("加载全部病程"));
	$("#personalTemplate").attr("title",emrTrans("个人模板管理"));
	$("#createTemplateBtn").attr("title",emrTrans("创建病程"));
	$("#rtnnav").attr("title",emrTrans("返回到导航页面"));
	$("#fontsizepackage").attr("title",emrTrans("字号"));
	$("#cut").attr("title",emrTrans("剪切"));
	$("#copy").attr("title",emrTrans("拷贝"));
	$("#paste").attr("title",emrTrans("粘贴"));
	$("#clipboard").attr("title",emrTrans("剪贴板"));
	$("#undo").attr("title",emrTrans("撤销"));
	$("#redo").attr("title",emrTrans("重做"));
	$("#fontcolor").attr("title",emrTrans("字体颜色"));
	$("#bold").attr("title",emrTrans("粗体"));
	$("#italic").attr("title",emrTrans("斜体"));
	$("#underline").attr("title",emrTrans("下划线"));
	$("#strike").attr("title",emrTrans("删除线"));
	$("#super").attr("title",emrTrans("上标"));
	$("#sub").attr("title",emrTrans("下标"));
	$("#alignjustify").attr("title",emrTrans("两端对齐"));
	$("#alignleft").attr("title",emrTrans("左对齐"));
	$("#aligncenter").attr("title",emrTrans("居中对齐"));
	$("#alignright").attr("title",emrTrans("右对齐"));
	$("#indent").attr("title",emrTrans("增加缩进量"));
	$("#unindent").attr("title",emrTrans("减少缩进量"));
	$("#recording").attr("title",emrTrans("开启语音录入"));
	$("#silverLocation").attr("title",emrTrans("定位到上次书写位置"));
	$("#tooth").attr("title",emrTrans("牙位图"));
	$("#spechars").attr("title",emrTrans("特殊符号"));
	$("#image").attr("title",emrTrans("图库"));
	$("#math-combox").attr("placeholder",emrTrans("请选择插入的医学公式"));
	$("#confirmRecordCompleted").attr("title",emrTrans("病历提交"));
	$("#recordtransfer").attr("title",emrTrans("病历转移"));
	$("#authRequest").attr("title",emrTrans("申请权限"));
	$("#setDiseases").attr("title",emrTrans("设置病种"));
	$("#favoritesPlus").attr("title",emrTrans("添加收藏"));
	$("#favorites").attr("title",emrTrans("收藏夹"));
	$("#insertTable").attr("title",emrTrans("插入表格"));
	$("#deleteTable").attr("title",emrTrans("删除表格"));
	$("#insertRow").attr("title",emrTrans("插入行"));
	$("#insertCol").attr("title",emrTrans("插入列"));
	$("#deleteRow").attr("title",emrTrans("删除行"));
	$("#deleteCol").attr("title",emrTrans("删除列"));
	$("#splitCells").attr("title",emrTrans("拆分单元格"));
	$("#addDiagRow").attr("title",emrTrans("增加诊断行"));
	$("#addOperRow").attr("title",emrTrans("增加手术行"));
	$("#export").attr("title",emrTrans("病历导出"));
	$("#delete").attr("title",emrTrans("删除"));
	$("#save-tab").attr("title",emrTrans("保存"));
	$("#print-tab").attr("title",emrTrans("打印"));
	$("#unLock-tab").attr("title",emrTrans("手工解锁"));
	$("#rtnnav-tab").attr("title",emrTrans("返回到导航页面"));
}
function initRecordToolbar()
{
	initToolBarTitle();
	///显示隐藏工具栏///////////////////////
	$('#toolbar').tabs({
		onSelect:function(title,index){
			if ($("#toolbar").height() <=36)
			{
				$("#toolbar").height("auto");
				hideToolbar("show");
			}
		}
	});
	$(".fold").click(function(){
		if ($("#toolbar").height() <=35)
		{
			$("#toolbar").height("auto");
			hideToolbar("show");
			$("#toolbar .fold").removeClass("down");
			$("#toolbar .fold").addClass("up");
		}
		else
		{
			$("#toolbar").height("35px");
			hideToolbar("hide");
			$("#toolbar .fold").removeClass("up");
			$("#toolbar .fold").addClass("down");
		}
	});		
	
	//控制工具栏字体段落格式等按钮的显示和隐藏
	setToolBarFontView();

	//设置下拉字号框
	setFontSizeData();
	//设置医学表达式选择框
	setMathSelect();
	setToolBarStatus("disable");
	setOtherButtonPrivilege();
    if ((loadDocMode.TitleCode != "")||(loadDocMode.RecordConfig != "")){
        $('#loadRecord').css('display','block');
    }
	if (isOpenEvent == "Y")
	{
		getEvent();
		window.setInterval("getEvent()",600000);
	}
	bindClick();
}

//设置字体数据源
function setFontData()
{
	var json=[{"value":"宋体","name":emrTrans("宋体")},
	          {"value":"仿宋","name":emrTrans("仿宋")},
	          {"value":"楷体","name":emrTrans("楷体")},
	          {"value":"黑体","name":emrTrans("黑体")}
	         ]
	$('#font').combobox({
		data : json ,                       
		valueField:'value',                        
		textField:'name'
	});	
	$('#font').combobox('setValue',json[0].value)     
}
//设置字体大小数据源
function setFontSizeData()
{
	var json=[{"value":"12pt","name":emrTrans("小四号"),"selected":"true"},
	          {"value":"10.5pt","name":emrTrans("五号")},
		  {"value":"42pt","name":emrTrans("初号")},
		  {"value":"36pt","name":emrTrans("小初号")},
	          {"value":"31.5pt","name":emrTrans("大一号")},
	          {"value":"28pt","name":emrTrans("一号")},
	          {"value":"21pt","name":emrTrans("二号")},
	          {"value":"18pt","name":emrTrans("小二号")},
	          {"value":"16pt","name":emrTrans("三号")},
	          {"value":"14pt","name":emrTrans("四号")},
	          {"value":"9pt","name":emrTrans("小五号")},
	          {"value":"8pt","name":emrTrans("六号")},
	          {"value":"6.875pt","name":emrTrans("小六号")},
	          {"value":"5.25pt","name":emrTrans("七号")},
	          {"value":"4.5pt","name":emrTrans("八号")},
	          {"value":"5pt","name":"5"},
	          {"value":"5.5pt","name":"5.5"},
	          {"value":"6.5pt","name":"6.5"},
	          {"value":"7.5pt","name":"7.5"},
	          {"value":"8.5pt","name":"8.5"},
	          {"value":"9.5pt","name":"9.5"},
	          {"value":"10pt","name":"10"},
	          {"value":"11pt","name":"11"}
	         ]
	var fontsize=$HUI.combobox("#fontsize",{
		valueField:"value",
		textField:"name",
		editable:true,
		selectOnNavigation:true,
		enterNullValueClear:false,
		panelHeight:'96',
		data:json
	});
	var oldValue = "";
	$('#fontsize').combobox({
		onSelect:function(record){
			oldValue = "";
			strJson = {action:"FONT_SIZE",args:record.value};
			doExecute(strJson);
			},
	    	onShowPanel:function(){
	    		//不支持onclick方法，2023-03-15,下拉时清除值，未做改变时还原值
		    	oldValue = $(this).combobox("getValue");	
		    	$(this).combobox("setValue","")
		    	},
		    onHidePanel:function(){
			    if(oldValue!==""){
				    $(this).combobox("setValue",oldValue)
				    }
			    }
		});
	//解决combobox被ActiveX控件遮挡问题
	$(".combo-panel").prepend('<iframe frameborder="0" scrolling="no" style="background-color:transparent; position: absolute; z-index: -1; width: 100%; height: 100%; top: 0; left:0;"></iframe>');
}
//设置医学表达式选择框
function setMathSelect(){
	var mathOptions = [
	{value:'toothMath',text:emrTrans('牙位图')},
	{value:'mensesMath',text:emrTrans('月经生育史')},
	{value:'ACDMath',text:emrTrans('前房深度公式')},
	{value:'HeartMath',text:'胎心位置'}
	]
	if (DisableDeleteMacro=="Y")
	{
		mathOptions.splice(1, 1);
	
	}
	$HUI.combobox('#math-combox',{
		textField:'text',
		valueField:'value',
		editable:false,
		allowNull:false,
		data:mathOptions,
		panelHeight:'100',
		onSelect:function (record) {
			switch(record.value){
				case 'toothMath':{
					var tempFrame = "<iframe id='iframeTooth' scrolling='auto' frameborder='0' src='emr.ip.tool.toothimg.csp?MWToken="+getMWToken()+"' style='width:100%; height:100%;'></iframe>";
					createModalDialog("toothDialog","牙位图","1145","700","iframeTooth",tempFrame,toothCallBack,"");
					clearComBox();			
					break;
				}
				
				case 'mensesMath':{
					var tempFrame = "<iframe id='iframeMenses' scrolling='auto' frameborder='0' src='emr.ip.menses.math.csp?MWToken="+getMWToken()+"' style='width:100%;height:100%'></iframe>"
					var text = {"action":"APPEND_ELEMENT","args":{"Code":"","ElemType":"MIMacroObject","DisplayName":"月经史","Description":"月经史表达式","MacroType":"macro_menstrual_history","Macros": [{"Name": "menarche","Prefix": "初潮:","Suffix": "岁","Value": "+14+"},{"Name": "menstruation_period","Prefix": "行经期:","Suffix": "天","Value": "5"},{"Name": "menstrual_cycle","Prefix": "周期天数:","Suffix": "天","Value": "29"},{"Name": "last_menstrual","Prefix": "末次时间:","Suffix": "号","Value": "30"}]}};
					cmdDoExecute(text);
					clearComBox();
				break;
				}
				case 'ACDMath':{
 					var strJson = {action:"APPEND_ELEMENT",args:{"Code":"","ElemType":"MIMacroObject","DisplayName":"深度公式","Description":"深度公式","MacroType":"macro_eye_deep_grade"}}
 					doExecute(strJson);	
					clearComBox();
				break;
				}
				case 'HeartMath':{
					var strJson = {"action":"INSERT_HEART_IMAGE","args":{"InstanceID":"","Intireplace":[{"HeartValue":"0"}],"UpLeftHeart":[{"HeartValue":"1"}],"UpRightHeart":[],"DownLeftHeart":[],"DownRightHeart":[],"MiddleHeart":[]}};
					doExecute(strJson);	
					clearComBox();					
				break;
				}
				default:
				break;
			}
		}
	});
	$(".combo-panel").prepend('<iframe style="width:100%;height:100%;position:absolute;z-index:-1;"></iframe>');
}
function clearComBox(){
	$('#math-combox').combobox('clear');
}
//设置工具条状态
function setToolBarStatus(flag)
{
	setSaveStatus(flag);
	setPrintStatus(flag);
	setDeleteStatus(flag);
	setExportDocumnet(flag);
	setReference(flag);
	setApplyeditDocumnet(flag);
	//setUnLockStatus(flag);
	setRevisionStatus(flag);
    setPersonalTemplateStatus(flag);
    setCreateTemplateBtnStatus(flag);
}
//设置病历无关按钮状态
function setOtherButtonPrivilege()
{
	var toolbarPrivilege = getPrivilege("","ToolbarPrivilege",episodeID,patientID);
	if (toolbarPrivilege.canCommit == "0")
	{
		setCommitStatus('disable');
		$('#confirmRecordCompleted').attr('reason',toolbarPrivilege.cantCommitReason);
	}
	else
	{
		setCommitStatus('enable');
		$('#confirmRecordCompleted').attr('reason','');
	}
	initConfirmRecord();
	if (toolbarPrivilege.canTransfer == "0")
	{
		setTransferStatus('disable');
		$('#recordtransfer').attr('reason',toolbarPrivilege.cantTransferReason);
	}
	else
	{
		setTransferStatus('enable');
		$('#recordtransfer').attr('reason','');
	}
}

///设置操作权限
function setActionPrivilege(commandParam)
{
	if(!commandParam) return;
	if(commandParam.canSave == 1)
	{
		setSaveStatus('enable');
		$('#save').attr('reason','');
		$('#save-tab').attr('reason','');
	}
	else
	{
		setSaveStatus('disable');
		$('#save').attr('reason',commandParam.cantSaveReason);
		$('#save-tab').attr('reason',commandParam.cantSaveReason);
	}
	if(commandParam.canPrint == 1)
	{
		setPrintStatus('enable');
		$('#print').attr('reason','');
		$('#print-tab').attr('reason','');
        $('#printOne').attr('reason','');
        $('#batchprint').attr('reason','');
	}
	else
	{
		setPrintStatus('disable');
		$('#print').attr('reason',commandParam.cantPrintReason);
		$('#print-tab').attr('reason',commandParam.cantPrintReason);
        $('#printOne').attr('reason',commandParam.cantPrintReason);
        $('#batchprint').attr('reason',commandParam.cantPrintReason);
	}
	if(commandParam.canDelete == 1)
	{
		setDeleteStatus('enable');
		$('#delete').attr('reason','');
	}
	else
	{
		setDeleteStatus('disable');
		$('#delete').attr('reason',commandParam.cantDeleteReason);
	}
	
	if(commandParam.canReference == 1)
	{
		setReference('enable');
		$('#reference').attr('reason','');
	}
	else
	{
		setReference('disable');
		$('#reference').attr('reason',commandParam.cantReferenceReason);
	}
	if(commandParam.canExport == 1)
	{
		setExportDocumnet('enable');
		$('#export').attr('reason','');
	}
	else
	{
		setExportDocumnet('disable');
		$('#export').attr('reason',commandParam.cantExportReason);
	}	
	if(commandParam.canApplyEdit == 1)
	{
		setApplyeditDocumnet('enable');
		$('#applyedit').attr('reason','');
	}
	else
	{
		setApplyeditDocumnet('disable');
		$('#applyedit').attr('reason',commandParam.cantApplyEditReason);
	}
	if(commandParam.canViewRevise == 1)
	{
		setRevisionStatus('enable');
		$('#revision').attr('reason','');
	}
	else
	{
		setRevisionStatus('disable');
		$('#revision').attr('reason',commandParam.cantViewReviseReason);
	}	
	if(commandParam.canUnLock == 1)
	{
		setUnLockStatus('enable');
		$('#unLock').attr('reason','');
		$('#unLock-tab').attr('reason','');
	}
	else
	{
		setUnLockStatus('disable');
		$('#unLock').attr('reason',commandParam.cantUnLockReason);
		$('#unLock-tab').attr('reason',commandParam.cantUnLockReason);
	}
	//Desc:是否可使用个人模板管理（知情告知和病案首页不可使用）
	if ($.inArray(param.categoryId,hidePersonalCategoryID)>-1)
	{
		$('#personalTemplate').hide();
	}
	else
	{
        setPersonalTemplateStatus('enable');
		$('#personalTemplate').show();
	}
	if (param.categoryId == ShowCreateRecordCategoryID)
	{
		setCreateTemplateBtnStatus('enable');
		$('#createTemplateBtn').show();
	}
	else
	{
		$('#createTemplateBtn').hide();
	}
	initConfirmRecord();
}

///Desc:是否可编辑
function setSaveStatus(flag)
{
	$('#font').combobox(flag);
	$('#fontsize').combobox(flag);
	$('#bold').linkbutton(flag);
	$('#italic').linkbutton(flag);
	$('#underline').linkbutton(flag);
	$('#strike').linkbutton(flag);
	$('#super').linkbutton(flag);
	$('#sub').linkbutton(flag);
	$('#alignjustify').linkbutton(flag);
	$('#alignleft').linkbutton(flag);
	$('#aligncenter').linkbutton(flag);
	$('#alignright').linkbutton(flag);
	$('#indent').linkbutton(flag);
	$('#unindent').linkbutton(flag);
	$('#cut').linkbutton(flag);
	$('#paste').linkbutton(flag);
	$('#undo').linkbutton(flag);
	$('#redo').linkbutton(flag);	
	$('#save').linkbutton(flag);
	$('#save-tab').linkbutton(flag);
	$('#binddatareload').linkbutton(flag);
	$('#spechars').linkbutton(flag);
	$('#clipboard').linkbutton(flag);
	$('#fontcolor').linkbutton(flag);
	$('#recording').linkbutton(flag);
	$('#silverLocation').linkbutton(flag);
	$('#image').linkbutton(flag);
	$('#tooth').linkbutton(flag);
	$('#math-combox').combobox(flag);
	
	$('#insertTable').linkbutton(flag);
	$('#deleteTable').linkbutton(flag);
	$('#insertRow').linkbutton(flag);
	$('#insertCol').linkbutton(flag);
	$('#deleteRow').linkbutton(flag);
	$('#deleteCol').linkbutton(flag);
	$('#splitCells').linkbutton(flag);
	//根据插件类型 隐藏或显示对应的按钮
	if(pluginType == "GRID"){
		$("#insertTable").css('display','none');
		$("#deleteTable").css('display','none');
		$("#insertRow").css('display','none');
		$("#insertCol").css('display','none');
		$("#deleteRow").css('display','none');
		$("#deleteCol").css('display','none');
		$("#splitCells").css('display','none');
		$("#eye").css('display','none');
	}else{
		$("#insertTable").css('display','block');
		$("#deleteTable").css('display','block');
		$("#insertRow").css('display','block');
		$("#insertCol").css('display','block');
		$("#deleteRow").css('display','block');
		$("#deleteCol").css('display','block');
		$("#splitCells").css('display','block');
		$("#eye").css('display','block');
	}
	$('#loadRecord').linkbutton(flag);
	$('#eye').linkbutton(flag);
}
///Desc:是否可打印
function setPrintStatus(flag)
{
	$('#print').linkbutton(flag);
	$('#print-tab').linkbutton(flag);
	$('#printView').linkbutton(flag);
	$('#autoprint').linkbutton(flag);
    $('#printOne').linkbutton(flag);
    $('#batchprint').linkbutton(flag);
}
///Desc:是否可删除
function setDeleteStatus(flag)
{
	$('#delete').linkbutton(flag);
}
///书写对比
function setReference(flag)
{
	$('#reference').linkbutton(flag);
}
///是否可导出
function setExportDocumnet(flag)
{
	$('#export').linkbutton(flag);	
}

///Desc:是否可提交病历
function setCommitStatus(flag)
{
	$('#confirmRecordCompleted').linkbutton(flag);
}

//设置病历转移状态(原来在代码中的只有主管医师可用放到脚本中处理)
function setTransferStatus(flag)
{
	$('#recordtransfer').linkbutton(flag);
}

//设置查看留痕按钮状态
function setRevisionStatus(flag)
{
	$('#revision').linkbutton(flag);
}

//设置个人模板按钮状态
function setPersonalTemplateStatus(flag)
{
    $('#personalTemplate').linkbutton(flag);
}

//设置创建病程按钮状态
function setCreateTemplateBtnStatus(flag)
{
    $('#createTemplateBtn').linkbutton(flag);
}
//文档对照
document.getElementById("reference").onclick = function(){
	var instanceID= "";
    if(param != "")
	{
		 instanceID = param.id;
	}
	var url= "emr.ip.tool.reference.csp?EpisodeID="+episodeID+"&InstanceID="+ instanceID+"&MWToken="+getMWToken();
	if(setRecordReferencePresentation == "Y"){
	    var reference = "<iframe id='framReference'  frameborder='0' src='"+url+"' style='width:100%; height:100%;scrolling:no;'></iframe>" ;
	    addTabs("tabreference","病历参考",reference,true); 
	}
	else
	{
		var xpwidth=window.screen.width-10;
		var xpheight=window.screen.height-75;
		window.open(url,'tabreference','width='+xpwidth+',height='+xpheight+',top=0,left=0'); 
	}
};

//添加收藏
document.getElementById("favoritesPlus").onclick = function(){
	//病历操作记录需要数据 start
	var categoryId = "";
	var templateId = "";
	if (param != "")
	{
		categoryId = param.categoryId;
		templateId = param.templateId;
	}
	//病历操作记录需要数据 end
	//记录用户(收藏病历)行为
    AddActionLog(userID,userLocID,"FavoritesAdd",""); 
    var arr = {"userId":userID,"userLocId":userLocID};
	var tempFrame = "<iframe id='iframeFavAdd' scrolling='auto' frameborder='0' src='emr.fav.add.csp?EpisodeID="+episodeID+"&InstanceID="+ param.id+"&categoryId="+categoryId+"&templateId="+templateId+"&MWToken="+getMWToken()+"' style='width:450px; height:450px; display:block;'></iframe>";
	createModalDialog("dialogFavAdd","添加收藏","454","490","iframeFavAdd",tempFrame,favAddCallback,arr);
};
//添加收藏回调记录日志
function favAddCallback(returnValue,arr)
{
	var UserID = arr.userId;
	var UserLocID = arr.userLocId;
    //记录用户(收藏病历.取消)行为
    if (returnValue == "FavoritesAdd.Cancel")
    AddActionLog(UserID,UserLocID,"FavoritesAdd.Cancel",""); 
    else if (returnValue == "FavoritesAdd.Commit")
    AddActionLog(UserID,UserLocID,"FavoritesAdd.Commit","");
}

//病历收藏夹
document.getElementById("favorites").onclick = function(){
	
	//记录用户(整理收藏)行为
    AddActionLog(userID,userLocID,"FavoritesView",""); 
	setFavoritesLog();
	var xpwidth=window.screen.width-300;
	var xpheight=window.screen.height-340;
	var arr = {"userId":userID,"userLocId":userLocID};
	//window.showModalDialog("emr.fav.favorite.csp","","dialogHeight:"+xpheight+"px ;dialogWidth:"+xpwidth+"px ;resizable:yes;center:yes;status:no");
	var tempFrame = "<iframe id='iframeFavorite' scrolling='auto' frameborder='0' src='emr.fav.favorite.csp?MWToken="+getMWToken()+"' style='width:100%; height:100%; display:block;'></iframe>";
	createModalDialog("dialogFavorite","收藏夹",xpwidth+4,xpheight+40,"iframeFavorite",tempFrame,favoriteCallback,arr,true,false);
};
//收藏夹回调记录日志
function favoriteCallback(returnValue,arr)
{
	var userId = arr.userId;
	var userLocId = arr.userLocId;
    //记录用户(整理收藏.页面关闭)行为
    AddActionLog(userId,userLocId,"FavoritesView.Page.Close","");
}
//手工解锁
document.getElementById("unLock").onclick = function(){
	btnUnLock();
};
//手工解锁-tab
document.getElementById("unLock-tab").onclick = function(){
	btnUnLock();
};
//字体
$('#font').combobox({
	onSelect: function (record) {
		strJson = {action:"FONT_FAMILY",args:record.value};
		doExecute(strJson);		
	}
});

//字号
$('#fontSize').combobox({
	onSelect: function(record){
		strJson = {action:"FONT_SIZE",args:record.value};
		doExecute(strJson);		
	}
});

//设置字体颜色   start
$("#fontcolor").colorpicker({
});
//打开/关闭颜色选择器
document.getElementById("fontcolor").onclick = function(){
	if (colorpanelshow == "1")
	{
		$("#colorpanel").hide();
		colorpanelshow = "0";
	}
	else if (colorpanelshow == "0")
	{
		$("#colorpanel").show();
		colorpanelshow = "1";
	}
};
//将字体颜色传给编辑器
function setFontColor(color){
	strJson = {action:"FONT_COLOR",args:color}; 
 	doExecute(strJson);	
};
//设置字体颜色   end

//设置粗体
document.getElementById("bold").onclick = function(){
 	strJson = {action:"BOLD",args:{path:""}}; 
 	doExecute(strJson);	
};

//设置斜体
document.getElementById("italic").onclick = function(){
 	strJson = {action:"ITALIC",args:""}; 
 	doExecute(strJson);	
};

//设置下划线
document.getElementById("underline").onclick = function(){
 	strJson = {action:"UNDER_LINE",args:""};
 	doExecute(strJson);	
};

//删除线
document.getElementById("strike").onclick = function(){
 	strJson = {action:"STRIKE",args:""};
 	doExecute(strJson);	
};

//设置上标
document.getElementById("super").onclick = function(){
 	strJson = {action:"SUPER",args:""};
 	doExecute(strJson);	
};

//设置下标
document.getElementById("sub").onclick = function(){
 	strJson = {action:"SUB",args:""};
 	doExecute(strJson);	
};

//设置两端对齐
document.getElementById("alignjustify").onclick = function(){
 	strJson = {action:"ALIGN_JUSTIFY",args:""}; 
 	doExecute(strJson);	
};

//设置左对齐
document.getElementById("alignleft").onclick = function(){
 	strJson = {action:"ALIGN_LEFT",args:""}; 
 	doExecute(strJson);	
};

//设置居中对齐
document.getElementById("aligncenter").onclick = function(){
 	strJson = {action:"ALIGN_CENTER",args:""}; 
 	doExecute(strJson);	
};

//设置右对齐
document.getElementById("alignright").onclick = function(){
 	strJson = {action:"ALIGN_RIGHT",args:""}; 
 	doExecute(strJson);	
};

//设置缩进
document.getElementById("indent").onclick = function(){
 	strJson = {action:"INDENT",args:""};
 	doExecute(strJson);	
};

//设置反缩进
document.getElementById("unindent").onclick = function(){
 	strJson = {action:"UNINDENT",args:""};  
 	doExecute(strJson);	
};

//剪切
document.getElementById("cut").onclick = function(){
 	strJson = {action:"CUT",args:""};  
 	doExecute(strJson);	
};

//复制
document.getElementById("copy").onclick = function(){
 	strJson = {action:"COPY",args:""};  
 	doExecute(strJson);	
};

//粘贴
document.getElementById("paste").onclick = function(){
 	strJson = {action:"PASTE",args:""};  
 	doExecute(strJson);	
};

//撤销
document.getElementById("undo").onclick = function(){
 	strJson = {action:"UNDO",args:""}; 
 	doExecute(strJson);	
};

//重做
document.getElementById("redo").onclick = function(){
 	strJson = {action:"REDO",args:""}; 
 	doExecute(strJson);	
};

//特殊字符
document.getElementById("spechars").onclick = function(){
	var tempFrame = "<iframe id='iframeSpechars' scrolling='auto' frameborder='0' src='emr.ip.tool.spechars.csp?MWToken="+getMWToken()+"' style='width:510px; height:428px; display:block;'></iframe>";
	createModalDialog("dialogSpechars","特殊字符","514","468","iframeSpechars",tempFrame,insertStyleText,"");
};

//牙位图
document.getElementById("tooth").onclick = function(){
	var tempFrame = "<iframe id='iframeTooth' scrolling='auto' frameborder='0' src='emr.ip.tool.tooth.csp?MWToken="+getMWToken()+"' style='width:1040px; height:438px; display:block;'></iframe>";
	createModalDialog("toothDialog","牙位图","1060","475","iframeTooth",tempFrame,toothCallBack,"");
};

//牙位图回调
function toothCallBack(returnValue,arr)
{
   if(returnValue!=="") insertTooth("new",returnValue); 
}

//保存
document.getElementById("save").onclick = function(){
	saveDocument(); 
};
//保存-tab
document.getElementById("save-tab").onclick = function(){
	saveDocument(); 
};
//打印
document.getElementById("print").onclick = function(){
	printDocument();	
};
//打印-tab
document.getElementById("print-tab").onclick = function(){
	printDocument();	
};
//自动续打
document.getElementById("autoprint").onclick = function(){
	autoPrintDocument();	
}

//单独打印
document.getElementById("printOne").onclick = function(){
	printOneDocument();	
};

//批量打印
document.getElementById("batchprint").onclick = function(){
    var xpwidth = window.screen.availWidth - 250;
    var xpheight = window.screen.availHeight - 250;
    createModalDialog("batchPrintDialog","批量打印",xpwidth,xpheight,"iframeBatchPrint","<iframe id='iframeBatchPrint' scrolling='auto' frameborder='0' src='emr.ip.batchprint.csp?EpisodeID=" + episodeID + "&PatientID=" + patientID + "&IPAddress=" + ipAddress +"&MWToken="+getMWToken()+"' style='width:100%;height:100%;display:block;'></iframe>","","");
};

//删除文档
document.getElementById("delete").onclick = function(){
	deleteDocument();
}

//刷新绑定数据
document.getElementById("binddatareload").onclick = function(){
	//获取当前活动文档的instanceID
	var instanceID = getDocumentContext().InstanceID; 						
	refreshReferenceData(instanceID,"false"); 
}

//导出病历
document.getElementById("export").onclick = function(){
	exportDocument(); 
}

//剪贴板
document.getElementById("clipboard").onclick = function(){
	var clipboard = "<iframe id='framclipboard' src='emr.ip.tool.clipboard.csp?MWToken="+getMWToken()+"' style='width:100%; height:100%;border:0;scrolling:no;margin:0px;padding:0;overflow:hidden;'></iframe>"				
	addTabs("clipboard","剪贴板",clipboard,true); 

};

//语音录入病历
document.getElementById("recording").onclick = function(){
	if ($("#recording").attr("flag") && $("#recording").attr("flag")=="false")	
	{
		$("#recording").attr("flag",true);
		$("#recording").attr("title","开启语音录入");
		setASRVoiceStatus(false,productName);
	}
	else
	{
		$("#recording").attr("flag",false);
		$("#recording").attr("title","关闭语音录入");
		setASRVoiceStatus(true,productName);
	}	 
}

//打开病历转移窗口
function doRecordTransfer()
{
	var tempFrame = "<iframe id='iframeRecordTransfer' scrolling='auto' frameborder='0' src='emr.ip.recordtransfer.csp?EpisodeID="+episodeID+ "&MWToken="+getMWToken()+"' style='width:352px; height:470px; display:block;'></iframe>";
	createModalDialog("dialogRecordTransfer","病历转移","354","510","iframeRecordTransfer",tempFrame,"","");
}

//执行命令
function doExecute(strJson)
{
	cmdDoExecute(strJson); 	
}

//控制工具栏字体段落格式等按钮的显示和隐藏
function setToolBarFontView()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLSysOption",
			"Method":"GetOptionValueByName2",
			"p1":"DisableFont",
			"p2":""
		},
		success: function(d){
			if (d == "") return;
			strs = d.split(","); //字符分割
			for (i=0;i<strs.length;i++ )
			{
				if (document.getElementById(strs[i]) != null)
				{
					if (strs[i] == "font")
					{
						document.getElementById("fontSpan").style.display="none";
					}
					else
					{
						document.getElementById(strs[i]).style.display="none";
					}
				}	
			} 	
		},
		error: function(d){alert("error");}
	});
}

//定位到上次书写位置
document.getElementById("silverLocation").onclick = function(){
	strJson = {"action":"GOTO_LAST_MODIFY_POSITION","args":""}; 
 	doExecute(strJson);	
}

//打印预览
document.getElementById("printView").onclick = function(){
	if (getModifyStatus("").Modified == "True")
	{
		var text = '文档正在编辑，请保存后开启预览，是否保存？';
		mainpage.$.messager.confirm("操作提示", text, function (data) { 
			if(data) {
				eventSave();
			}else {
				return;
			}
		});
		return "";
	} 
    //病案首页采集页预览
    var collectMedicalRecordConfig = isMedicalRecord(param.emrDocId);
    if (collectMedicalRecordConfig){
        createModalDialog("printViewDialog","打印预览",window.screen.width-1000,window.screen.height-300,"iframePrintView","<iframe id='iframePrintView' scrolling='auto' frameborder='0' src='emr.ip.collectmedicalrecord.csp?DialogID=printViewDialog&Action=printView&CollectMedicalRecordConfig="+collectMedicalRecordConfig+"' style='width:100%;height:100%;display:block;'></iframe>","","");
    }else{
        if ($("#printView").attr("flag") && $("#printView").attr("flag")=="false")	
        {
            $("#printView").attr("flag",true);
            $("#printView").attr("title",emrTrans("开启打印预览"));
            $("#printView span .l-btn-text").text(emrTrans("预览"));
            setPreviewDocumentState(false);	
            //$("#printView").css("background","url('../scripts/emr/image/toolbar/printView.png') no-repeat center center");
			
			//取文档信息
			var documentContext = getDocumentContext("");
			//设置当前文档操作权限
			setPrivelege(documentContext);
        }
        else
        {
            $("#printView").attr("flag",false);
            $("#printView").attr("title","关闭打印预览");
            $("#printView span .l-btn-text").text(emrTrans("关闭预览"));
            setPreviewDocumentState(true);
            //$("#printView").css("background","url('../scripts/emr/image/toolbar/printViewClose.jpg') no-repeat center center");	
        }	
    }
}

///提交病历/////////////////////////////////////////////////////////////
//初始化提交病历状态
function initConfirmRecord()
{
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLAdmRecordStatus",
					"Method":"GetAdmRecordStatus",			
					"p1":episodeID
				},
			success: function (data){
				if (data == "1")
				{ 
					$("#confirmRecordCompleted span .l-btn-icon").removeClass("icon-big-book-arrow-rt");
					$("#confirmRecordCompleted span .l-btn-icon").addClass("icon-big-book-arrow-ok");
				}
				else
				{
					$("#confirmRecordCompleted span .l-btn-icon").removeClass("icon-big-book-arrow-ok");
					$("#confirmRecordCompleted span .l-btn-icon").addClass("icon-big-book-arrow-rt");
				}
			}
		});	
}

//送病案室点击事件
function changeRecordFinishedStatus()
{
	var xpwidth = 1000;
	var xpheight = 340;
	var tempFrame = "<iframe id='iframeConfirm' scrolling='auto' frameborder='0' src='emr.ip.confirmadmrecord.csp?EpisodeID="+episodeID+"&MWToken="+getMWToken()+"' style='width:"+xpwidth+"px; height:"+xpheight+"px; display:block;'></iframe>";
	createModalDialog("ConfirmDialog","提交病历",xpwidth+4,xpheight+40,"iframeConfirm",tempFrame,confirmRecordCallBack,"");
}

//提交病历回调
function confirmRecordCallBack(returnValue,arr)
{
	if (returnValue == "confirm")
	{
		confirmRecordFinished();
	}
	else if(returnValue == "revoke")
	{
		revokeConfirmRecord();
	}
}

//提交病历
function confirmRecordFinished()
{
	//有修改必须保存后，才可确认病历全部完成
	var result = savePrompt("");
	if ((result != "")&&(result != "save"))
	{
		resetModifyState(param.id,"false");
	}
	
	var qualityResult = qualityConfirmDocument();
	if (qualityResult) return; 
	
	var tipMsg = "提交病历后将无法修改病历，是否确认提交?";
	mainpage.$.messager.confirm("提示",tipMsg, function (r) {
		if (!r) return;
		submitRemarks();
		//获取提交病历是否成功
		getCompleteResult();
		getNav();
	});
}

//提交病历
function getCompleteResult()
{
	var result = false;
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLAdmRecordStatus",
					"Method":"ConfirmRecordFinished",			
					"p1":episodeID,
					"p2":userID,
					"p3":getIpAddress(),
					"p4":"EMR",
					"p5":""
				},
			success: function (data){
				
				var result = data;
				if (result == "1") 
				{
					$("#confirmRecordCompleted span .l-btn-icon").removeClass("icon-big-book-arrow-rt");
					$("#confirmRecordCompleted span .l-btn-icon").addClass("icon-big-book-arrow-ok");
					parent.$.messager.alert("提示信息", "提交病历成功", 'info');
					window.location.reload();				
				}
				else
				{
					if (result.substring(2)!= "")
					{
						parent.$.messager.alert("提示信息", emrTrans(result.substring(2)));	
					}
					else
					{
						parent.$.messager.alert("提示信息", "提交病历失败");
					}
				}
				
			}
		});	
	return result;
}


//撤销提交病历
function revokeConfirmRecord()
{
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLAdmRecordStatus",
					"Method":"RevokeConfirmRecord",			
					"p1":episodeID,
					"p2":userID,
					"p3":getIpAddress(),
					"p4":"EMR",
					"p5":"",
					"p6":"Revoke"
				},
			success: function (data){
				var result = data;
				if (result == "1") 
				{
					$("#confirmRecordCompleted span .l-btn-icon").removeClass("icon-big-book-arrow-ok");
					$("#confirmRecordCompleted span .l-btn-icon").addClass("icon-big-book-arrow-rt");
					parent.$.messager.alert("提示信息", "撤销提交成功", 'info');
					getNav();
				}
				else
				{
					if (result.substring(2)!= "")
					{
						parent.$.messager.alert("提示信息", emrTrans(result.substring(2)));	
					}
					else
					{
						parent.$.messager.alert("提示信息", "撤销提交失败");
					}
				}
			}
		});	
}

function qualityConfirmDocument()
{
	var result =  false;
	
	if ((confirmAlertType == "2")||(confirmAlertType == "3"))
	{
		var hasData = HasQualityOrWaitSignData();
		if (hasData == "1")
		{
			result = true;
			var quality = "<iframe id='framquality' src='finishdocumentunsignlist.csp?EpisodeID="+episodeID+"&MWToken="+getMWToken()+"' style='width:98%; height:98%;border:0;margin:0px;padding:5px;overflow:hidden;' scrolling=no></iframe>"			
			framRecord.addTabs("quality","质控提示",quality,true);
			mainpage.$("#nav").css("display","none");
			mainpage.$("#editor").css("display","block");
		}
	}
	else
	{
		//病历质控
		var eventType = "ConfirmRecord^" + ssgroupID + "^" + userLocID; 
		var qualityData = qualityCheck(episodeID,"","",eventType)
		if (qualityData.total > 0)
		{
			var controlType = qualityData.ControlType;
			var quality = "<iframe id='framquality' src='dhc.emr.quality.runtimequalitylist.csp?EpisodeID="+episodeID+"&EventType="+eventType+"&TemplateID=&key="+qualityData.key+"&MWToken="+getMWToken()+"' style='width:98%; height:98%;border:0;margin:0px;padding:5px;overflow:hidden;' scrolling=no></iframe>"			
			addTabs("quality","质控提示",quality,true); 
			if (controlType == "0") 
			{
				result = true;
				mainpage.$("#nav").css("display","none");
				mainpage.$("#editor").css("display","block");
				return result;
			}
		}
	}
	if ((qualityData != "")&&(typeof(qualityData) == "string"))
	{
		result = true;
	}
	return result;
}

//质控
function qualityCheck(episodeId,instanceId,templateId,eventType)
{
	var result = "";
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"Stream",
					"Class":"EMRservice.HISInterface.QualityInterface",
					"Method":"QualityInterfaceCheck",			
					"p1":episodeId,
					"p2":eventType,
					"p3":templateId,
					"p4":instanceId
				},
			success: function(d) {
					if (d != "")
					{
						result = jQuery.parseJSON(d);
					}
			},
			error : function(d) { 
					result = "调用质控方法出错，请重新操作！";
					alert(result);
			}
		});	
	return result;	
}

//打开图库窗口
document.getElementById("image").onclick = function(){
	var xpwidth = window.screen.width-400;
	var xpheight = window.screen.height-400;
	//showDialogImage("图库",xpwidth+4,xpheight+40,"<iframe id='iframeImage' scrolling='auto' frameborder='0' src='emr.ip.tool.image.csp' style='width:"+xpwidth+"px; height:"+xpheight+"px; display:block;'></iframe>")
	var tempFrame = "<iframe id='iframeImage' scrolling='auto' frameborder='0' src='emr.ip.tool.image.csp?MWToken="+getMWToken()+"' style='width:"+xpwidth+"px; height:"+xpheight+"px; display:block;'></iframe>";
	createModalDialog("dialogImage","图库",xpwidth+4,xpheight+40,"iframeImage",tempFrame,imageCallBack,"");
}
//图库回调
function imageCallBack(returnValue,arr)
{
	if (returnValue) insertIMG(returnValue); 
}

///事件助手消息
function getEvent()
{
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.eventData.cls",
		async: true,
		data: {
			"EpisodeID": episodeID,
			"Action": "GetMessage"
		},
		success: function(d) {
			if (d != "")
			{
				if(moveText == "Y")
				{
					var d = eval(d);
					var text = '<marquee onmouseover="this.stop()" onmouseout="this.start()" scrollamount="2">';
					for (var i=0;i<d.length;i++)
					{
						text = text + '<div class="eventList"  id='+d[i].EventType+'><img src="../scripts/emr/image/icon/'+d[i].EventType+'.png"/>';	
						text = text + '<span class="helper">'+emrTrans(d[i].PromptMessage)+'</span></div>';
						
					}
					text = text + '</marquee>';
					$("#event").html(text);		
				}
				else
				{
					var d = eval(d);
					var text = '<div id="wrap" style="margin-top:4px">';
					for (var i=0;i<d.length;i++)
					{
						text = text + '<a class="eventList hisui-linkbutton" href="#" title="'+emrTrans(d[i].PromptMessage)+'" onmouseenter="topCenter(this)" onmouseleave="topDel(this)" id="'+d[i].EventType+'"><img src="../scripts/emr/image/icon/'+d[i].EventType+'.png"/>';	
					}
					text = text + '</a>';
					$("#event").html(text);	
				}
			}
		},
		error : function(d) { alert(" error");}
	});
}
function sendCopyCutData(content)
{
	if (!window.frames["framclipboard"]) return;
	window.frames["framclipboard"].setContent(content);
}

$("#event").on('click',".eventList",function(){
	var eventType = $(this)[0].id;
	
	//有修改必须保存后，才可点击事件
	var result = savePrompt("");
	if ((result != "")&&(result != "save"))
	{
		resetModifyState(param.id,"false");
	}

	var returnValues = "";
	if (eventType!="")
	{
		var tempFrame = "<iframe id='iframeEvent' scrolling='auto' frameborder='0' src='emr.ip.event.csp?EpisodeID="+episodeID+"&EventType="+eventType+"&MWToken="+getMWToken()+"' style='width:100%; height:100%; display:block;'></iframe>";
		createModalDialog("dialogEvent","事件弹窗","614","520","iframeEvent",tempFrame,eventCallBack,"");
	}
});
//事件回调函数
function eventCallBack(returnValue,arr)
{
	if (typeof(returnValue) != "undefined" && returnValue != "")
	{
		var values = eval("("+returnValue+")");
		if (values.length <=0) return;
		mainpage.operateRecord(values);
	}
	getEvent();
}

///是否可申请自动审批
function setApplyeditDocumnet(flag)
{
	$('#applyedit').linkbutton(flag);	
}

//申请自动审批
function applyeditOnclick()
{
	applyedit();
}

///Desc:是否可手工解锁
function setUnLockStatus(flag)
{
	$('#unLock').linkbutton(flag);
	$('#unLock-tab').linkbutton(flag);
}

//插入表格
document.getElementById("insertTable").onclick = function(){
 	strJson = {action:"TOOL_BAR_INSERT_TABLE",args:{path:""}}; 
 	doExecute(strJson);	
};

//删除表格
document.getElementById("deleteTable").onclick = function(){
 	strJson = {action:"TOOL_BAR_DELETE_TABLE",args:{path:""}}; 
 	doExecute(strJson);	
};


//插入行
document.getElementById("insertRow").onclick = function(){
 	strJson = {action:"TOOL_BAR_INSERT_ROW",args:{path:""}}; 
 	doExecute(strJson);	
};

//删除行
document.getElementById("deleteRow").onclick = function(){
 	strJson = {action:"TOOL_BAR_DELETE_ROW",args:{path:""}}; 
 	doExecute(strJson);	
};

//插入列
document.getElementById("insertCol").onclick = function(){
 	strJson = {action:"TOOL_BAR_INSERT_COL",args:{path:""}}; 
 	doExecute(strJson);	
};

//删除列
document.getElementById("deleteCol").onclick = function(){
 	strJson = {action:"TOOL_BAR_DELETE_COL",args:{path:""}}; 
 	doExecute(strJson);	
};

//拆分单元格
document.getElementById("splitCells").onclick = function(){
 	strJson = {action:"TOOL_BAR_SPLIT_CELLS",args:{path:""}}; 
 	doExecute(strJson);	
};

//开启关闭留痕
document.getElementById("revision").onclick = function(){
	setRevision();	
};


//设置书写状态
function setNoteState(status)
{
	strJson = {action:"SET_NOTE_STATE",args:status};
	doExecute(strJson);	
}

//回到导航
function getNav()
{
	mainpage.gotoNav();
}

///初始化工栏状态
function initToolbarStatus()
{
	//非可重复式连续显示模板创建的病历实例去掉加载全部病程、自动续打按钮
	if (pluginType && param){
		if((pluginType == "DOC")&&(param.isLeadframe == "1")){
			$("#autoprint").css('display','block');
			if ((loadDocMode.TitleCode != "")||(loadDocMode.RecordConfig != "")){
				$("#loadRecord").css('display','block');
			}else{
				$("#loadRecord").css('display','none');
			}
		}else{
			$("#autoprint").css('display','none');
			$("#loadRecord").css('display','none');
		}
	}
	
	//初始化语音录入
	$("#recording").attr("flag",true);
	$("#recording").attr("title","开启语音录入");
	
	//初始化打印预览
	$("#printView").attr("flag",true);
	$("#printView").attr("title",emrTrans("开启打印预览"));
    $("#printView span .l-btn-text").text(emrTrans("预览"));
		
    //初始化留痕信息
    initRevision();
	if (!plugin()) return;
	setPreviewDocumentState(false);
	setASRVoiceStatus(false,productName);
}

///初始化留痕信息
function initRevision()
{
	setRevisionStatus('enable');
	var status = false;
	var text = "显示留痕";
    var icon = "icon-big-open-eye";
	var value = getUserConfigData(userID,userLocID,"Revision");
	$("#revision span .l-btn-icon").removeClass("icon-big-close-eye");
    if (value == "TRUE")
	{
		text = "隐藏留痕";
		status = true; 
		icon = "icon-big-close-eye";
		$("#revision span .l-btn-icon").removeClass("icon-big-open-eye");		
	}
 	$("#revision span .l-btn-text").text(emrTrans(text));
 	$("#revision span .l-btn-icon").addClass(icon);
 	viewRevision(status);	
}

///显示关闭留痕
function setRevision()
{
	var value = "FALSE";
	var status = false;
	var text = "显示留痕";
	var icon = "icon-big-open-eye";
	$("#revision span .l-btn-icon").removeClass("icon-big-close-eye");
 	if ($("#revision span .l-btn-text").text() != emrTrans("隐藏留痕"))
	{
		text = "隐藏留痕";
		status = true;
		value = "TRUE";
		icon = "icon-big-close-eye";
		$("#revision span .l-btn-icon").removeClass("icon-big-open-eye");
	}
 	$("#revision span .l-btn-text").text(emrTrans(text));
 	$("#revision span .l-btn-icon").addClass(icon);
 	viewRevision(status);	
 	//用户个人设置开启关闭留痕
 	if (isSaveUserConfig == "Y"){
	 	addUserConfigData(userID,userLocID,"Revision",value) 	
	}
}

//打开申请权限窗口
document.getElementById("authRequest").onclick = function(){
	var tempFrame = "<iframe id='iframeRequest' scrolling='auto' frameborder='0' src='emr.auth.request.csp?EpisodeID="+ episodeID + "&PatientID=" + patientID + "&MWToken="+getMWToken()+"' style='width:1100px; height:575px; display:block;'></iframe>";
	createModalDialog("dialogAuthRequest","申请授权","1104","615","iframeRequest",tempFrame,"","");
}

function showDiaglog(title,width,height,content)
{
	mainpage.showDiaglog(title,width,height,content);
}
var messageObj="";
var titleText ="";
function topCenter(obj){
	if ((typeof($('#'+ obj.id).attr('reason')) == "undefined")||($('#'+ obj.id).attr('reason')== "")) return;
	if (typeof(obj) == "undefined") return;
	if (messageObj!=""){
		window.document.body.removeChild(messageObj);
		messageObj="";
	}
	var pos = obj.getBoundingClientRect();
	var right = pos.right
	var top = pos.top
	titleText = $('#'+ obj.id).attr('title');
	$('#'+ obj.id).attr('title',"");
	var message = $('#'+ obj.id).attr('reason');
	messageObj=document.createElement("DIV")
	messageObj.innerText=message;
	messageObj.id="messageText";
	messageObj.style.top=top+"px";
	messageObj.style.left=right+"px";
	window.document.body.appendChild(messageObj);
}
function topDel(obj){
	if (typeof(obj) == "undefined") return;
	if(titleText!=""){
		$('#'+ obj.id).attr('title',titleText);
		titleText="";
	}
	if(messageObj!=""){
		window.document.body.removeChild(messageObj);
		messageObj="";
	}
}
//调用归档统计扫描项目数目页面
function submitRemarks()
{
	if (isSubmitRemarks != "Y") return;
	var tempFrame = "<iframe id='iframeSubmitRemarks' scrolling='auto' frameborder='0' src='../csp/dhc.epr.fs.submitremarks.csp?EpisodeID=" + episodeID + "&MWToken="+getMWToken()+"' style='width:460px; height:540px; display:block;'></iframe>";
	createModalDialog("dialogSubmitRemarks","","464","580","iframeSubmitRemarks",tempFrame,"","");
}

//增加诊断行(GRID编辑器)
document.getElementById("addDiagRow").onclick = function(){
 	strJson = {action:"ADD_GRID_ROW",args:{"RowType":"Diag"}}; 
 	doExecute(strJson);	
};

//增加手术行(GRID编辑器)
document.getElementById("addOperRow").onclick = function(){
 	strJson = {action:"ADD_GRID_ROW",args:{"RowType":"Oper"}}; 
 	doExecute(strJson);	
};

//设置病种
document.getElementById("setDiseases").onclick = function(){
 	setPatDiseases();
 	
};
function setPatDiseases()
{
	
	var tempFrame = "<iframe id='iframeAdmPatType' scrolling='auto' frameborder='0' src='emr.ip.admpattype.csp?LocID="+userLocID+"&EpisodeID="+episodeID + "&MWToken="+getMWToken()+"' style='width:100%; height:100%; display:block;'></iframe>";
	createModalDialog("admPatType","设置患者病种","320","300","iframeAdmPatType",tempFrame,"","",true,false);

}

//判断该次就诊送病案室时有没有触犯质控条目和待签数据
function HasQualityOrWaitSignData()
{
	var result = "0"
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.InterfaceService.WaitSign",
					"Method":"HasQualityOrWaitSignData",			
					"p1":episodeID
				},
			success: function (data){
				if (data == "1") 
				{
					result = "1";
				}
			}
		});
			
	return result;
}

//加载全部病程
function loadAllRecord()
{
    if (param != "")
    {
        if (checkLoadDocMode())
        {
            var returnValues = savePrompt(param.id,"sync");
            if ((returnValues == "unsave")||(!returnValues))
            {
                resetModifyState(param.id,"false");
                reloadAllRecord();
            }
            
        }
    }
}

//增加前房深度公式
document.getElementById("eye").onclick = function(){
 	strJson = {action:"APPEND_ELEMENT",args:{"Code":"","ElemType":"MIMacroObject","DisplayName":"深度公式","Description":"深度公式","MacroType":"macro_eye_deep_grade"}}
 	doExecute(strJson);	
};

//个人模板管理
document.getElementById("personalTemplate").onclick = function(){
    if(pluginType == "GRID") {
        parent.$.messager.alert("提示信息", "表格型病历不允许维护个人模板！", 'info');
        return;
    }
	/*if (getModifyStatus("").Modified == "True")
	{
		var text = '文档正在编辑，请保存后再打开管理页面，是否保存？';
		top.$.messager.confirm("操作提示", text, function (data) { 
			if(data) {
				saveDocument();
				managePersonalTemplate();
			}else {
				return;
			}
		});
	} 
	else
	{
		managePersonalTemplate();
	}*/
	managePersonalTemplate();
    
};

function managePersonalTemplate()
{
	var insID= "";
    if(param != "")
	{
		 insID = param.id;
	}	
	if (insID == "") return;
    
    var content = '<iframe id="managePersonalWinFrame" scrolling="auto" frameborder="0" src="emr.ip.managepersonal.csp?IstanceID=' + insID + '&UserID=' + userID + '&UserLocID=' + userLocID +'&MWToken='+getMWToken()+'" style="width:100%;height:100%;display:block;"></iframe>';
	createModalDialog('managePersonalWin','管理个人模版',400,630,"managePersonalWinFrame",content,"","");
}

//保存个人模板-个人模板需要传给编辑器章节code，过滤header与footer、未绑定知识库的章节
function savePersonalTemplate(argParams)
{
	var metaDataTree = getMetadataTree();
    var items = [];

    for(var i=0;i<metaDataTree.items.length;i++)
    {
        if ((metaDataTree.items[i].Code == "Header")||(metaDataTree.items[i].Code == "Footer"))
            continue;
        var relation = "REPLACE";
        if ((metaDataTree.items[i].BindKBBaseID == "undefined")||(metaDataTree.items[i].BindKBBaseID == ""))
            relation = "REFERENCE";
        items.push({
            "SectionCode":metaDataTree.items[i].Code,
            "SectionStatus":relation
        });
    }
    var argJson = {
        action: 'SAVE_SECTION',
        args: {
            Items:items,
            params: {
                CategoryID: argParams.CategoryID,
                UserID: argParams.UserID,
                Name: argParams.Name,
                action: 'SAVE_PERSONAL_SECTION'
            }
        }
    };
    return cmdSyncExecute(argJson);
}

function getMetadataTree()
{
	var argJson = {"action":"GET_METADATA_TREE","args":{}};
	return cmdSyncExecute(argJson);
}

//获取知情告知和病案首页的categoryID
function getHidePersonalCategoryID()
{
	var categoryID = new Array();
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLSysOption",
			"Method":"GetOptionValueByName",
			"p1":"SearchAcrossDepartment"
		},
		success: function(d) {
			if (d != "") 
			{
				var strXml = convertToXml(d);
			    $(strXml).find("item").each(function(){
				    var code = $(this).find("code").text();
				    categoryID.push(code);
			    });	
			    if (medRecordCategoryID != "")
			    {
				    categoryID.push(medRecordCategoryID);
			    }	
			}
		},
		error : function(d) { 
			alert("getHidePersonalCategoryID error");
		}
	});
	
    return categoryID;
}

//患者端CA签名；显示待签二维码
if (document.getElementById("patPushSignQR") != undefined) {
	document.getElementById("patPushSignQR").onclick = function(){
		getPatPushSignQR();						
	};
}

//患者端CA签名；同步患者推送签名结果
if (document.getElementById("patPushSignResult") != undefined) {
	document.getElementById("patPushSignResult").onclick = function(){
		fetchPatPushSignResult();
	};
}

//患者端CA签名：作废已签名PDF\患者重新签名
if (document.getElementById("invalidPatSignPDF") != undefined) {
	document.getElementById("invalidPatSignPDF").onclick = function(){
		invalidPatSignedPDF();	
	};
}

//验签
if (document.getElementById("verifySigned") != undefined) {
	document.getElementById("verifySigned").onclick = function(){
		verifySigned();
	}
}

//获取病程记录categoryID
function getShowCreateRecordCategoryID()
{
	var categoryID = "";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLSysOption",
			"Method":"GetOptionValueByName",
			"p1":"ShowCreateRecordBtn"
		},
		success: function(d) {
			if (d != "") 
			{
				var strXml = convertToXml(d);
			    $(strXml).find("item").each(function(){
				    var code = $(this).find("code").text();
				    categoryID = code;
			    });		
			}
		},
		error : function(d) { 
			alert("getHidePersonalCategoryID error");
		}
	});
	
    return categoryID;
}

function bindClick()
{
	var tabs = $("#toolbar").tabs().tabs('tabs');
	var title = "";
	for (var i = 0; i < tabs.length; i++) 
	{
		///以下代码是为页签动态绑定单击事件
		tabs[i].panel('options').tab.unbind().bind('click', { index: i }, function (e) {
			title = ($(this).find(".tabs-title").html());
			//if (title != "操作") return;
			if ($("#toolbar").height() <=35)
			{
				$("#toolbar").height("auto");
				hideToolbar("show");
				$("#toolbar .fold").removeClass("down");
				$("#toolbar .fold").addClass("up");
			}
			else
			{
				$("#toolbar").height("35px");
				hideToolbar("hide");
				$("#toolbar .fold").removeClass("up");
				$("#toolbar .fold").addClass("down");
			}
		})

	}
}

function openResource()
{
	var length = $('#newMain').layout('panel','east').length;
	if(length>0)
	{
		$("#newMain").layout('remove','east');
		var width = $('#imagediv').width();
		$("#main").layout('panel','center').panel('resize',{width:width});
    	$('#main').layout('resize');
	}
	else
	{
		var options = {border:false,split:true,id:'resRegion',region:'east'};
		options.width=400;
		$('#newMain').layout('add', options);
		$("#resRegion").append('<iframe id="framResource" src="" frameborder="0" style="width:100%; height:100%;margin:0;padding:0;overflow:hidden"></iframe>')
		initResource();
		resource = document.getElementById("framResource").contentWindow;
	}
}
