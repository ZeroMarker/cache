var PageLogicObj={
	m_selectItemRow:"",
	CurePlanDataGrid:"",
	CureAppendItemDataGrid:"",
	CurePartDataGrid:"",
	editRow:undefined,
	m_selectTreeNode:undefined,
	m_LoadTimer:"",
	ArcUrl : LINK_CSP+'?ClassName=DHCDoc.DHCDocCure.Config&MethodName=QueryArcItmDetail'
}

function InitHospList()
{
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_Cure_ItemSet",hospStr);
	hospComp.jdata.options.onSelect = function(e,t){
		SetItemDefaultValue();
		Init();		
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
$(document).ready(function(){ 
	//Init();
	InitHospList();
	InitEvent();
	PageHandle();
	InitCache();
});
function InitCache () {
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function Init(){
	CheckDocCureUseBase();
	//初始化左侧树
	InitCureItemTree("");
	InitCureServiceGroup();
	InitRelateTemp();
	PageLogicObj.CurePlanDataGrid=InitCurePlanDataGrid();
	PageLogicObj.CureAppendItemDataGrid=InitAppendItemDataGrid();
	initItmMastColumns();
	
	//InitCRTType();
	//PageLogicObj.CureCRTDataGrid=InitCureCRTDataGrid();
	
	InitCurePart();
	InitCurePartGrp();
	PageLogicObj.CurePartDataGrid=InitCurePartDataGrid();
}

function InitEvent(){
	//$('#btnFind').bind("click",function(){
	//LoadCureItemDataGrid();	
	//})
	$('#btnSave').bind("click",function(){
		SaveCureItemDetail();	
	})
	$('#btnImport').click(ImportTemplate);
	$('#insertappenditem').bind("click",InsertAppendItemRow);
	$('#saveappenditem').bind("click",SaveCureItemAppendItem);
	$('#deleteappenditem').bind("click",DelAppendItemClickHandle);
	$('#cancelappenditem').bind("click",CancelAppendItemClickHandle);
	$('#btnDownLoad').click(DownLoadClickHandle);
	
	$HUI.radio("[name='PartOrAcupoint']",{
        onCheckChange:function(e,value){
            clearTimeout(PageLogicObj.m_LoadTimer);
	        PageLogicObj.m_LoadTimer=setTimeout(function(){InitCurePart()},100);
        }
    });
    $HUI.radio("[name='PartOrAcupointGrp']",{
        onCheckChange:function(e,value){
            clearTimeout(PageLogicObj.m_LoadTimer);
	        PageLogicObj.m_LoadTimer=setTimeout(function(){InitCurePartGrp()},100);
        }
    });
    
	$(document.body).bind("keydown",BodykeydownHandler)
}

function PageHandle(){
	var planPanelWidth = $("#plan_panel").innerWidth();
	var planPanelHeight = $("#plan_panel").innerHeight();
	var itemPanelHeight = $("#item_panel").innerHeight();
	var itemtextareaHeight=itemPanelHeight*0.13;
	var planItemWidth=planPanelWidth-130;
	var planItemHeight=planPanelHeight*0.45;
	$(".form_table textarea").height(itemtextareaHeight)
	$(".plan_table input,#CRTTitle").width(planItemWidth)
	$(".plan_table textarea").width(planItemWidth)
	//$(".plan_table textarea").height(planItemHeight)
	
	$(".crt_table textarea").width(planItemWidth)
	$(".crt_table textarea").height(planItemHeight)
}

function CheckDocCureUseBase(){
	var UserHospID=Util_GetSelHospID();
	var DocCureUseBase=$.m({
		ClassName:"DHCDoc.DHCDocCure.VersionControl",
		MethodName:"UseBaseControl",
		HospitalId:UserHospID,
		dataType:"text"
	},false);
	if (DocCureUseBase=="1"){
		$('tr.t-hidden-label').addClass("t-hidden");
	}else{
		$('tr.t-hidden-label').removeClass("t-hidden");
	}
}

//-------------治疗申请树开始-------------------------
function InitCureItemTree(url){
	var HospDr=Util_GetSelHospID();
	var para="^^^^"+HospDr+"^^Y^";
	if(url=="")url="doccure.config.data.csp?action=cure&para="+encodeURIComponent(para);
	var tbox=$HUI.tree("#CureItemTree",{
		url:url,
		checkbox:false,
		onlyLeafCheck:true,
		onDblClick:function(node){
			var value=node.eleid.replace(/\^/g,String.fromCharCode(4));
			if ((value=="")||(value==undefined)) return false;
			//CureItemTreeClick(value);//双击节点，加载医嘱信息及绑定医嘱列表
		},
		formatter:function(node){
			if (node.eleid=="") return node.text;
			else {
				if (+node.RealStock=="0"){
					//已配置且未激活为红色
					return '<span style="color:red">'+node.text+'</span>';
				}else if (+node.RealStock=="-1"){
					//未配置为灰色
					return '<span style="color:#808080">'+node.text+'</span>';
				}else{
					return node.text;
				}
			}
		},
		onClick: function(node){
			var isLeaf=$(this).tree('isLeaf',node.target)
			if (!isLeaf){
				$(this).tree('toggle',node.target)
			}else{
				var curId=$(this).tree('getNode',node.target).id;
				var isChecked=false;
				/*var nodes = $(this).tree('getChecked');
				for (var i=0;i<nodes.length;i++){
					if (nodes[i]['id']==curId){
						$(this).tree('uncheck',node.target);
						isChecked=true;
						break;
					}
				}
				if (!isChecked){
					$(this).tree('check',node.target);
				}*/
				var value=node.eleid.replace(/\^/g,String.fromCharCode(4));
				if ((value=="")||(value==undefined)) return false;
				PageLogicObj.m_selectTreeNode=curId;
				CureItemTreeClick(value);//双击节点，加载医嘱信息及绑定医嘱列表
			}
		},onLoadSuccess:function(node,data){  
	        if(PageLogicObj.m_selectTreeNode!=undefined){  
	            var node = $(this).tree('find', PageLogicObj.m_selectTreeNode);  
	            $(this).tree('expandTo', node.target).tree('select', node.target); 
	            var value=node.eleid.replace(/\^/g,String.fromCharCode(4));
				if ((value=="")||(value==undefined)) return false;
				CureItemTreeClick(value);//双击节点，加载医嘱信息及绑定医嘱列表 
	        }  
	    }  
	});
}

///Check_QueryAll switchbox触发
function CheckQueryAll(e,obj){
	var QueryArc=$("#QryArcDesc").searchbox("getValue");
	var allflag="Y";
	if(obj.value){
		allflag="N";	
	}
	ReloadCureItemTree(QueryArc,"",allflag)
}
///搜索框QryArcDesc本身可触发该方法
function ReloadCureItemTree(value,name,allflag){
	var HospDr=Util_GetSelHospID();
	if(typeof(allflag)=="undefined"){
		allflag="Y";
		var QueryAll=$HUI.switchbox("#Check_QueryAll").getValue();
		if(QueryAll){
			allflag="N";	
		}
	}
	if(ClearTree()){
		var para="^^^^"+HospDr+"^"+value+"^Y^"+allflag;
		var myurl="doccure.config.data.csp?action=cure&para="+encodeURIComponent(para);
		$('#CureItemTree').tree('options').url=myurl;
		$HUI.tree("#CureItemTree").reload();
		ClearCureItemDetail();
	}
}

function ClearTree(){
    var tbox=$HUI.tree("#CureItemTree");
    var roots=tbox.getRoots();
    for (var i=roots.length-1;i>=0;i--){
	  var node = tbox.find(roots[i].id);
	  tbox.remove(node.target);
    }
    return true
}
function CureItemTreeClick(value){
	if(value==""){
		$.messager.alert('提示','获取节点信息错误', "error");   
        return false;	
	}
	var arr=value.split(String.fromCharCode(4));
	var ItemRowid=arr[2];
	var Rowid=arr[17];
	loadCureItemDetail(Rowid,ItemRowid);	
}
//-------------治疗申请树结束-------------------------

function InitCureServiceGroup(){
	var HospDr=Util_GetSelHospID();
	//服务组列表
	var CureServiceGroupObj=$HUI.combobox("#ServiceGroup",{
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.RBCServiceGroupSet&QueryName=QueryServiceGroup&HospID="+HospDr+"&ResultSetType=array",
		valueField:'Rowid',
		textField:'Desc',
		onSelect:function(record){
		} 
	});	
}
function InitRelateTemp(){
	$HUI.combobox("#RelateAssTemp",{
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		url:$URL+"?ClassName=web.DHCDocAPPBL&QueryName=FindBLType&MapType=CA&ResultSetType=array",
		valueField:'RowID',
		textField:'BLTypeDesc'
	});	
	$HUI.combobox("#RelateRecordTemp",{
		multiple:false,
		selectOnNavigation:false,
		url:$URL+"?ClassName=web.DHCDocAPPBL&QueryName=FindBLType&MapType=CR&ResultSetType=array",
		valueField:'RowID',
		textField:'BLTypeDesc'
	});	
}

function ClearCureItemDetail(){
	$("#DDCISRowid").val("");
	$("#ItemRowid").val("");
	$("#ArcimCode").val("") //prop("innerText",ArcimCode);
	$("#ArcimDesc").val("") //.prop("innerText",ArcimDesc);
	$("#ShortName").val("");
	$('#ServiceGroup,#RelateAssTemp,#RelateRecordTemp').combobox('setValue',"");
	$("#Effect").val("");
	$("#Indication").val("");
	$("#Avoid").val("");
	$HUI.switchbox("#ManualApply").setValue(false);
	$HUI.switchbox("#ApplyExec").setValue(false);
	$HUI.switchbox("#ActiveFlag").setValue(false);
	$HUI.switchbox("#IPApplyExec").setValue(false);
	LoadCurePlanDataGrid();
	LoadCureAppendItemDataGrid();
}
function loadCureItemDetail(Rowid,ItemRowid)
{
	var HospDr=Util_GetSelHospID();
	$.m({
		ClassName:"DHCDoc.DHCDocCure.CureItemSet",
		MethodName:"GetCureItemSet",
		'DDCISRowid':Rowid,
		'ArcimId':ItemRowid,
		'HospID':HospDr
	},function(objScope){
		if (objScope=="") return;
		var TempArr=objScope.split("^");
		var ArcimCode=TempArr[0];
		var ArcimDesc=TempArr[1];
		var ShortName=TempArr[2];
		var ServiceGroupDR=TempArr[3];
		var AutoAppFlag=TempArr[4];
		var Effect=TempArr[5];
		var Indication=TempArr[6];
		var Avoid=TempArr[7];
		var ManualApplyFlag=TempArr[8];
		var ApplyExecFlag=TempArr[9];
		var ServiceGroupActive=TempArr[10];
		var ActiveFlag=TempArr[11];
		var IPApplyExecFlag=TempArr[12];
		var RelateAssTemp=TempArr[13];
		var RelateRecordTemp=TempArr[14];
		var AutoAppobj=$HUI.checkbox("#AutoApp");
		//var ManualApplyobj=$HUI.checkbox("#ManualApply");
		//var ApplyExecobj=$HUI.checkbox("#ApplyExec");
		var ManualApplyobj=$HUI.switchbox("#ManualApply");
		var ApplyExecobj=$HUI.switchbox("#ApplyExec");
		var ActiveFlagobj=$HUI.switchbox("#ActiveFlag");
		var IPApplyExecobj=$HUI.switchbox("#IPApplyExec");
		
		var AutoApp=(AutoAppFlag=="Y")?true:false;
		var ManualApply=(ManualApplyFlag=="Y")?true:false;
		var ApplyExec=(ApplyExecFlag=="Y")?true:false;
		var IPApplyExec=(IPApplyExecFlag=="Y")?true:false;
		var ActiveFlag=(ActiveFlag=="Y")?true:false;
				
		ManualApplyobj.setValue(ManualApply)
		ApplyExecobj.setValue(ApplyExec);
		IPApplyExecobj.setValue(IPApplyExec)
		ActiveFlagobj.setValue(ActiveFlag);
		$("#DDCISRowid").val(Rowid);
		$("#ItemRowid").val(ItemRowid);
		$("#ArcimCode").val(ArcimCode) //prop("innerText",ArcimCode);
		$("#ArcimDesc").val(ArcimDesc) //.prop("innerText",ArcimDesc);
		$("#ShortName").val(ShortName);
		$('#ServiceGroup').combobox('setValue',ServiceGroupDR);
		var RelateAssTempArr=[];
		if(RelateAssTemp!=""){
			RelateAssTempArr=RelateAssTemp.split(",");
		}
		$('#RelateAssTemp').combobox('setValues',RelateAssTempArr);
		$('#RelateRecordTemp').combobox('setValue',RelateRecordTemp);
		$("#Effect").val(Effect);
		$("#Indication").val(Indication);
		$("#Avoid").val(Avoid);
		if((ServiceGroupActive==0)&&(ServiceGroupDR=="")){
			$.messager.alert("提示", "请注意,该治疗医嘱项对应的服务组已过截止日期,请重新选择", 'error')	
		}
		
		LoadCureAppendItemDataGrid();
		LoadCurePlanDataGrid();
		LoadCureCRTDataGrid();
		LoadCurePartDataGrid();
	});
}

function SetItemDefaultValue(){
	$("#DDCISRowid").val("");
	$("#ItemRowid").val("");
	$("#ArcimCode").val("") //prop("innerText",ArcimCode);
	$("#ArcimDesc").val("") //.prop("innerText",ArcimDesc);
	$("#ShortName").val("");
	$('#ServiceGroup,#RelateAssTemp,#RelateRecordTemp').combobox('setValue',"");
	$("#Effect").val("");
	$("#Indication").val("");
	$("#Avoid").val("");
	var ManualApplyobj=$HUI.switchbox("#ManualApply");
	var ApplyExecobj=$HUI.switchbox("#ApplyExec");
	var ActiveFlagobj=$HUI.switchbox("#ActiveFlag");
	var IPApplyExecobj=$HUI.switchbox("#IPApplyExec");
	ManualApplyobj.setValue(false);
	ApplyExecobj.setValue(false);
	IPApplyExecobj.setValue(false);
	ActiveFlagobj.setValue(false);
	ClearPlanData();
	PageLogicObj.CurePlanDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',{total: 0, rows: []});
	LoadCureAppendItemDataGrid();
}

function CheckData(){
    var ItemRowid=$('#ItemRowid').val();
    var ServiceGroupDR=$('#ServiceGroup').combobox('getValue');
	if(ItemRowid=="")
	{
		$.messager.alert("提示", "代码不能为空", 'warning')
    	return false;
	}
	if(ServiceGroupDR=="")
	{
		$.messager.alert('提示','服务组不能为空', "warning");   
        return false;
	}
	return true;
}
function SaveCureItemDetail()
{
    if(!CheckData()) return false; 
    var DDCISRowid=$('#DDCISRowid').val();
    var ItemRowid=$('#ItemRowid').val();
    var ShortName=$('#ShortName').val();
    var ServiceGroupDR=$('#ServiceGroup').combobox('getValue');
    var AutoAppFlag="";
    if ($("#AutoApp").is(":checked")) {
	         AutoAppFlag="Y";
	}
	var Effect=""; //$("#Effect").val();
	var Indication=""; //$("#Indication").val();
	var Avoid=""; //$("#Avoid").val();
	var ManualApplyFlag="";
	var ApplyExecFlag="";
	var IPApplyExecFlag="";
	var ActiveFlag="N";
	if ($HUI.switchbox("#ManualApply").getValue()) {
		ManualApplyFlag="Y";
	}
	
	if ($HUI.switchbox("#ApplyExec").getValue()) {
		ApplyExecFlag="Y";
	}
	if ($HUI.switchbox("#IPApplyExec").getValue()) {
		IPApplyExecFlag="Y";
	}
	
	if ($HUI.switchbox("#ActiveFlag").getValue()) {
		ActiveFlag="Y";
	}
	var RelateAssTempDR=$('#RelateAssTemp').combobox('getValues');
	var RelateRecordTemp=$('#RelateRecordTemp').combobox('getValue');
	var InputPara=DDCISRowid+"^"+ItemRowid+"^"+ShortName+"^"+ServiceGroupDR+"^"+AutoAppFlag+"^"+Effect+"^"+Indication+"^"+Avoid;
	var InputPara=InputPara+"^"+ManualApplyFlag+"^"+ApplyExecFlag+"^"+ActiveFlag+"^"+IPApplyExecFlag+"^"+RelateAssTempDR+"^"+RelateRecordTemp;
    //alert(InputPara)
    var HospDr=Util_GetSelHospID();
    $.m({
		ClassName:"DHCDoc.DHCDocCure.CureItemSet",
		MethodName:"SaveCureItemSet",
		str:InputPara,
		HospID:HospDr
	},function(value){
		if(value=="0"){
			$.messager.popover({msg:"保存成功",type:"success"});
			//LoadCureItemDataGrid();	
			/*if((typeof(PageLogicObj.m_selectItemRow)!='undefined')&&(_selectItemRow!="")){
				setTimeout(function(){ReloadItemDetail()},500)	
			}*/
			$HUI.tree("#CureItemTree").reload();
		}else if(value==-2){
			$.messager.alert("提示", "请在下拉框中选择服务组", 'warning')
		}else{
			return false;
		}
	});			  
}

function ReloadItemDetail(){
	PageLogicObj.CureItemDataGrid.datagrid('selectRow',PageLogicObj.m_selectItemRow);
	var selected=PageLogicObj.CureItemDataGrid.datagrid('getRows'); 
	var Rowid=selected[PageLogicObj.m_selectItemRow].Rowid;
	var ItemRowid=selected[PageLogicObj.m_selectItemRow].ItemRowid;
	loadCureItemDetail(Rowid,ItemRowid);	
}
function InitCurePlanDataGrid(){
	var toobar=[{
        text: '新增',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    }, {
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {DelClickHandle();}
    }, {
        text: '保存',
        iconCls: 'icon-save',
        handler: function() { UpdateClickHandle();}
    }];
	var  CurePlanColumns=[[
		{ field: 'PlanType', title: '类型', width: 50,  resizable: true  
		},
		{ field: 'PlanTypeVal', title: '类型', width: 50,  hidden: true  
		},
		{ field: 'PlanTitle', title: '标题', width: 100,  resizable: true  
		},
		{ field: 'PlanDetail', title: '内容', width: 200, resizable: true  
		},
		{ field: 'PlanRowID', title: 'PlanRowID', width: 1, sortable: true, resizable: true,hidden:true}	
	 ]];
	var CurePlanDataGrid=$("#tabCurePlan").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		toolbar:toobar,
		loadMsg : '加载中..', 
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.CureItemSet&QueryName=FindCureItemPlan&rows=9999", 
		pagination : true,
		rownumbers : true,
		idField:"PlanRowID",
		pageSize:10,
		pageList : [10,25,50],
		columns :CurePlanColumns,
		onLoadSuccess:function(data){  
		},
		onClickRow:function(rowIndex, rowData){
			ClearPlanData();
			$("#PlanTitle").val(rowData.PlanTitle);
			$HUI.radio("input[value='"+rowData.PlanTypeVal+"']").setValue(true);
			var ret=$.cm({
				ClassName:"DHCDoc.DHCDocCure.CureItemSet",
				MethodName:"GetPlanDetailByID",
				dataType:"text",
				'DDCISPRowid':rowData.PlanRowID,
			},false);
			if(ret!=""){
				$("#PlanDetail").val(ret);
			}
		},onBeforeLoad:function(param){
			$(this).datagrid("clearSelections");
			var DDCISRowid=$('#DDCISRowid').val();
			//ClearPlanData();
			$("#PlanTitle,#PlanDetail").val("");
			$.extend(param,{DDCISRowid:DDCISRowid,Query:"1"});
		}
	});
	return CurePlanDataGrid
}
function LoadCurePlanDataGrid(){
	PageLogicObj.CurePlanDataGrid.datagrid("reload");
}
function CheckPlanData(val){
	if(val=="N"){
		var DDCISPRowid=$('#DDCISRowid').val();
        var ActiveFlag="";
        if ($HUI.switchbox("#ActiveFlag").getValue()) {
			ActiveFlag="Y";
		}
        if((DDCISPRowid=="")){
	    	$.messager.alert("提示","请在左侧树选择一个已保存的治疗医嘱项", "error");
			return false;  
	    }
	}
	if(val=="U"){
	}
	var Type="";
	var checkedRadioJObj = $("input[name='PlanType']:checked");
    if(checkedRadioJObj.length>0){
	    Type=checkedRadioJObj.val();
    }
    if(Type==""){
		$.messager.alert("提示","请选择模板类型!", "warning");	
		return false;	
    }
	var PlanTitle=$("#PlanTitle").val();
	var PlanDetail=$("#PlanDetail").val();
	if(PlanTitle==""){
		$.messager.alert("提示","请填写模板标题!", "warning");	
		return false;	
	}else{
		if(PlanTitle.indexOf("^")>0){
			$.messager.alert("提示","模板标题所含字符'^'为系统保留字符,请修改或者换用其他字符!", "warning");	
			return false;		
		}
		if(PlanTitle.length>50){
			$.messager.alert("提示","模板标题长度过长,建议不超过50字符!", "warning");	
			return false;	
		}	
	}
	if(PlanDetail==""){
		$.messager.alert("提示","请填写模板内容!", "warning");
		return false;	
	}else{
		if(PlanDetail.indexOf("^")>0){
			$.messager.alert("提示","模板内容所含字符'^'为系统保留字符,请修改或者换用其他字符!", "warning");	
			return false;		
		}	
	}
	return true;
}
function ClearPlanData(){
	$HUI.radio("input[value='P']").setValue(true);
	$("#PlanTitle").val("");
	$("#PlanDetail").val("");
}
function AddClickHandle(){
	if(!CheckPlanData("N"))return;
	var DDCISPRowid=$('#DDCISRowid').val();
	var PlanTitle=$("#PlanTitle").val();
	var PlanDetail=$("#PlanDetail").val();
	var checkedRadioJObj = $("input[name='PlanType']:checked");
    if(checkedRadioJObj.length>0){
	    Type=checkedRadioJObj.val();
    }
        
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.CureItemSet",
		MethodName:"SaveCureItemSetPlan",
		DDCISPRowid:DDCISPRowid,
		PlanTitle:PlanTitle,
		PlanDetail:PlanDetail,
		Type:Type
	},function(rtn){
		if (rtn=="0"){
			$.messager.popover({type:"success",msg:"保存成功!"});
			LoadCurePlanDataGrid();
		}else{
			if(rtn=="-100"){rtn="请选择一个已激活的治疗项目!"}
			else if(rtn=="-101"){rtn="保存失败,"+rtn}
			else if(rtn=="-102"){rtn="获取对象失败!"+rtn}
			$.messager.alert("提示",rtn, "error");
			return false;
		}
	});
}
function UpdateClickHandle(){
	if(!CheckPlanData("U"))return;
	var rows = PageLogicObj.CurePlanDataGrid.datagrid('getSelections');
	if (rows.length ==0) {
		$.messager.alert("提示","请选择一条需要更新的模板记录!", "warning");	
		return;
	}
	var checkedRadioJObj = $("input[name='PlanType']:checked");
    if(checkedRadioJObj.length>0){
	    Type=checkedRadioJObj.val();
    }
	var DDCISPRowid=rows[0].PlanRowID;
	var PlanTitle=$("#PlanTitle").val();
	var PlanDetail=$("#PlanDetail").val();
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.CureItemSet",
		MethodName:"SaveCureItemSetPlan",
		DDCISPRowid:DDCISPRowid,
		PlanTitle:PlanTitle,
		PlanDetail:PlanDetail,
		Type:Type
	},function(rtn){
		if (rtn=="0"){
			$.messager.popover({type:"success",msg:"保存成功!"});
			LoadCurePlanDataGrid();
		}else{
			if(rtn=="-100"){rtn="请选择一个已激活的治疗项目!"}
			else if(rtn=="-101"){rtn="保存失败,"+rtn}
			else if(rtn=="-102"){rtn="获取对象失败!"+rtn}
			$.messager.alert("提示",rtn, "error");
			return false;
		}
	});
}
function DelClickHandle(){
	var rows=PageLogicObj.CurePlanDataGrid.datagrid('getSelected');
	if ((!rows)||(rows.length==0)){
		$.messager.alert("提示","请选择需要删除的行!");
		return false;
	}
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.CureItemSet",
		MethodName:"DelCureItemSetPlan",
		DDCISPRowid:rows['PlanRowID'],
	},function(rtn){
		if (rtn=="0"){
			$.messager.popover({type:"success",msg:"删除成功!"});
			LoadCurePlanDataGrid();
		}else{
			$.messager.alert("提示","删除失败!"+rtn, "error");
			return false;
		}
	});
}

function InitAppendItemDataGrid(){
    var textEditor={
		type: 'text',
		options: {
			required: true
		}
	}
	var AdmLoceditor={ 
		type: 'combobox',
		options:{
			mode:"remote",
			url:$URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=FindLocList&desc=&rows=99999",
			valueField:'LocRowId',
			textField:'LocDesc',
			required:true,
			loadFilter: function(data){
				return data['rows'];
			},
			onLoadSuccess:function(){
				var AppendAdmLocRowID="";
				var rows=$("#tabCureAppendItem").datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
				if(rows){
					AppendAdmLocRowID=rows.AppendAdmLocRowID;
				}
				$(this).combobox("setValue",AppendAdmLocRowID)
			},
			onBeforeLoad:function(param){
				if (param['q']) {
					var desc=param['q'];
				}else{
					var desc="";
				}
				param = $.extend(param,{desc:desc});
			},onSelect:function(option){
				///设置类型值
				var ed=$("#tabCureAppendItem").datagrid('getEditor',{index:PageLogicObj.editRow,field:'AppendAdmLoc'});
				$(ed.target).combobox('setValue', option.LocRowId);
				var ed=$("#tabCureAppendItem").datagrid('getEditor',{index:PageLogicObj.editRow,field:'AppendAdmLocRowID'});
				$(ed.target).val(option.LocRowId); 
			} 
		}
	}
	var RecLoceditor={ 
		type: 'combobox',
		options:{
			mode:"local",
			url:'',
			valueField:'CombValue',
			textField:'CombDesc',
			//required:true,
			loadFilter: function(data){
				return data['rows'];
			},filter: function(q, row){
				return ((row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)
				||(row["CombCode"].toUpperCase().indexOf(q.toUpperCase()) >= 0));
			},
			onLoadSuccess:function(data){
				var AppendRecLocRowID="";
				var rows=$("#tabCureAppendItem").datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
				if(rows){
					AppendRecLocRowID=rows.AppendRecLocRowID;
				}
				$(this).combobox("setValue",AppendRecLocRowID)
			},
			onBeforeLoad:function(param){
				/*if (param['q']) {
					var desc=param['q'];
				}else{
					var desc="";
				}
				param = $.extend(param,{Inpute1:AppendItemRowID});*/
			},onSelect:function(option){
				///设置类型值
				var ed=$("#tabCureAppendItem").datagrid('getEditor',{index:PageLogicObj.editRow,field:'AppendRecLoc'});
				$(ed.target).combobox('setValue', option.CombValue);
				var ed=$("#tabCureAppendItem").datagrid('getEditor',{index:PageLogicObj.editRow,field:'AppendRecLocRowID'});
				$(ed.target).val(option.CombValue); 
			}
		}
	}
	// 定义columns
	var CureAppendItemColumns=[[
		{ field: 'AppendItem', title: '医嘱项', width: 200,  resizable: true,editor:textEditor},
		{ field: 'AppendItemRowID', title: 'AppendItemRowID', width: 1, sortable: true, resizable: true,hidden:true,editor:textEditor},
		{ field: 'AppendQty', title: '数量', width: 100, resizable: true,editor:textEditor},
		{ field: 'AppendAdmLoc', title: '就诊科室', width: 150, resizable: true,editor:AdmLoceditor,hidden:true},
		{ field: 'AppendAdmLocRowID', title: 'AppendAdmLocRowID', width: 150, resizable: true,hidden:true,editor:textEditor},
		{ field: 'AppendRecLoc', title: '接收科室', width: 150, resizable: true,editor:RecLoceditor},
		{ field: 'AppendRecLocRowID', title: 'AppendRecLocRowID', width: 150, resizable: true,hidden:true,editor:textEditor},
		/*{ field: 'DefaultFlag',title : '默认',
               editor : {
                    type : 'icheckbox',
                    options : {
                        on : 'Y',
                        off : '',
                        onCheckChange:function(e,value){
                            
                        }
                    }
                }
         },*/
		{ field: 'AppendRowID', title: 'AppendRowID', width: 1, sortable: true, resizable: true,hidden:true,editor:textEditor}		
	]];
	///  定义datagrid  
	var option = {
		rownumbers : true,
		fitColumns : true,
		singleSelect : true,
		pageSize:10,
		pageList : [10,25,50],
	    onDblClickRow: function (rowIndex, rowData) {	/// 双击选择行编辑
	    	if (PageLogicObj.editRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
		        return false;
			}
            if (PageLogicObj.editRow != "") { 
                $("#tabCureAppendItem").datagrid('endEdit', PageLogicObj.editRow); 
            } 
            $("#tabCureAppendItem").datagrid('beginEdit', rowIndex); 
            dataGridBindEnterEvent(rowIndex)
            PageLogicObj.editRow = rowIndex; 
            ReloadItemAppendRecLoc(rowIndex,"");
        },
        onLoadSuccess:function(data){
	    	PageLogicObj.editRow = undefined ;  
	    }
	};
	var DDCISPRowid=$('#DDCISRowid').val();
	new ListComponentWin().RemoveMyDiv();
	var uniturl = LINK_CSP+"?ClassName=DHCDoc.DHCDocCure.CureItemSet&MethodName=QueryAppendItem&DDCIAIRowid="+DDCISPRowid;
	new ListComponent('tabCureAppendItem', CureAppendItemColumns, uniturl, option).Init();
}

function LoadCureAppendItemDataGrid(){
	InitAppendItemDataGrid();
	$("#tabCureAppendItem").datagrid("clearChecked");
	$("#tabCureAppendItem").datagrid("clearSelections");	
}

function InsertAppendItemRow(){
	var DDCISPRowid=$('#DDCISRowid').val();
    var ActiveFlag="";
    if ($HUI.switchbox("#ActiveFlag").getValue()) {
		ActiveFlag="Y";
	}
    //if((DDCISPRowid=="")||(ActiveFlag!="Y")){
	if((DDCISPRowid=="")){
    	$.messager.alert("提示","请在左侧树选择一个已保存的治疗医嘱项", "error");
		return false;  
    }
	if(PageLogicObj.editRow!=undefined){
		$.messager.alert("提示","有正在编辑的行,请先保存或取消编辑", "error");
		return;
	}
			 
	$("#tabCureAppendItem").datagrid('insertRow', {
		index: 0,
		row: {AppendItem: '',AppendItemRowID:'',AppendQty: '',AppendAdmLoc:'',AppendAdmLocRowID:'',AppendRecLoc:'',AppendRecLocRowID:'',AppendRowID:""}
	});
    
	$("#tabCureAppendItem").datagrid('beginEdit', 0);
	PageLogicObj.editRow=0;  
	
	var rows = $("#tabCureAppendItem").datagrid('getRows');
	if (rows.length != "0"){
		dataGridBindEnterEvent(0); 
	}	
}
function SaveCureItemAppendItem(){	
	var rows=$("#tabCureAppendItem").datagrid("selectRow",PageLogicObj.editRow).datagrid("getSelected");
	var editors = $("#tabCureAppendItem").datagrid('getEditors', PageLogicObj.editRow);  	
	var AppendItemRowID =  editors[1].target.val();
	if (AppendItemRowID=="")
	{
		$.messager.alert("提示","请选择医嘱项!", "error");
		return false;
	} 
	var AppendQty=$.trim(editors[2].target.val());
	if (AppendQty!=""){
		var r = /^\+?[1-9][0-9]*$/;
		if(!r.test(AppendQty)){
			$.messager.alert('提示',"数量请填写有效数字!", "error");
			return false;
		}
	}else{
		$.messager.alert('提示',"请填写数量!", "error");
		return false;	
	}
	var AppendAdmLocRowID =  editors[3].target.combobox("getValue"); //editors[4].target.val();
	var AppendRecLocRowID =  editors[5].target.combobox("getValue"); //editors[6].target.val();
	if(typeof(AppendRecLocRowID)=="undefined"){
		AppendRecLocRowID="";	
	}
	if (AppendRecLocRowID=="")
	{
		//$.messager.alert("提示","请选择接收科室!", "error");
		//return false;
	} 
	var AppendRowID =  editors[7].target.val();
	if(AppendRowID==""){
		AppendRowID=$('#DDCISRowid').val();	
	}
	var params=AppendRowID+"^"+ AppendItemRowID  +"^"+ AppendQty +"^"+ AppendAdmLocRowID+"^"+ AppendRecLocRowID;
	//保存数据
	runClassMethod("DHCDoc.DHCDocCure.CureItemSet","SaveCureItemAppendItem",{"params":params},function(jsonString){
		if (jsonString == "0"){
			//$.messager.alert('提示','保存成功！');
			$.messager.show({title:"提示",msg:"保存成功"});	
			$('#tabCureAppendItem').datagrid('reload'); 
			PageLogicObj.editRow = undefined;
		}else if (jsonString=="-11")
		{
			$.messager.alert('提示','该绑定医嘱项已存在！', "error");
		}
	});
}

function DelAppendItemClickHandle(){
	var rowsData = $("#tabCureAppendItem").datagrid('getSelected');
	if (rowsData != null) {
		new ListComponentWin().RemoveMyDiv();
		$.messager.confirm("提示", "您确定要删除数据吗？", function (res) {
			if (res) {
				runClassMethod("DHCDoc.DHCDocCure.CureItemSet","DelCureItemAppendItem",{"DDCIAIRowid":rowsData.AppendRowID},function(jsonString){
					$('#tabCureAppendItem').datagrid('reload'); 
					PageLogicObj.editRow = undefined;
				})
			}
		});
	}else{
		if(PageLogicObj.editRow!=undefined){
			$("#tabCureAppendItem").datagrid('deleteRow', PageLogicObj.editRow);
			PageLogicObj.editRow=undefined;
			new ListComponentWin().RemoveMyDiv();
		}else{
			$.messager.alert('提示','请选择要删除的项','warning');
			return;
		}
	}	
}
function CancelAppendItemClickHandle(){
	PageLogicObj.editRow = undefined;
	new ListComponentWin().RemoveMyDiv();
    $("#tabCureAppendItem").datagrid("rejectChanges");
    $("#tabCureAppendItem").datagrid("unselectAll");
}

function dataGridBindEnterEvent(index){
	var HospDr=Util_GetSelHospID();
	var editors = $('#tabCureAppendItem').datagrid('getEditors', index);
	var workRateEditor = editors[0];
	workRateEditor.target.focus();
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#tabCureAppendItem").datagrid('getEditor',{index:index, field:'AppendItem'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var unitUrl = PageLogicObj.ArcUrl + "&Input="+$(ed.target).val()+"&HospID="+HospDr+"&NotShowARCOS=Y";
			/// 调用医嘱项列表窗口
			new ListComponentWin($(ed.target), input, "500px", "" , unitUrl, PageLogicObj.ArcColumns, setCurrEditRowCellVal).init();
		}
	});
}
/// 给当前编辑列赋值(医嘱项目)
function setCurrEditRowCellVal(rowObj){
	if (rowObj == null){
		var editors = $('#tabCureAppendItem').datagrid('getEditors', PageLogicObj.editRow);
		var workRateEditor = editors[0];
		workRateEditor.target.focus().select();
		return;
	}
	var ed=$("#tabCureAppendItem").datagrid('getEditor',{index:PageLogicObj.editRow, field:'AppendItem'});
	$(ed.target).val(rowObj.itmDesc);
	var ed=$("#tabCureAppendItem").datagrid('getEditor',{index:PageLogicObj.editRow, field:'AppendItemRowID'});		
	$(ed.target).val(rowObj.itmID);
	ReloadItemAppendRecLoc(PageLogicObj.editRow,rowObj.itmID);
}

function initItmMastColumns(){
	PageLogicObj.ArcColumns = [[
	    {field:'itmDesc',title:'医嘱项名称',width:220},
	    {field:'itmCode',title:'医嘱项代码',width:100},
	    //{field:'itmCat',title:'子类',width:80},
	    {field:'itmPrice',title:'单价',width:60},
		{field:'itmID',title:'itmID',width:80}
	]];
}

function ReloadItemAppendRecLoc(index,itemid){
	if(itemid==""){
		var rows=$("#tabCureAppendItem").datagrid("selectRow",index).datagrid("getSelected");
		if(rows){
			itemid=rows.AppendItemRowID;
		}
	}
    var unitUrl=$URL+"?ClassName=DHCDoc.DHCDocCure.Apply&QueryName=CombListFind&CombName=AppendItemRecLoc"+"&Inpute1="+itemid+"&Inpute2="+""+"&Inpute3="+0+"&Inpute4="+""+"&Inpute5="+session['LOGON.CTLOCID']+"&rows=99999";
    var editors=$('#tabCureAppendItem').datagrid('getEditor',{index:index,field:'AppendRecLoc'});
	$(editors.target).combobox('reload',unitUrl);
}

function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
   //浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        //e.preventDefault(); 
        return false;  
    }  
}

function InitCRTType(){
	var ret=$.cm({
		ClassName:"DHCDoc.DHCDocCure.CureItemSet",
		MethodName:"GetCRTTypeStr",
		dataType:"text"	
	},false)
	var DataArr=new Array();
	if(ret!=""){
		var retArr=ret.split("^");
		for(var i=0;i<retArr.length;i++){
			var aretArr=retArr[i].split(String.fromCharCode(1))
			var code=aretArr[0];	
			var desc=aretArr[1];	
			var one={"id":code,"desc":desc};
			DataArr.push(one);
		}
	}
	$HUI.combobox("#CRTType",{
		editable:false,
		valueField:"id",
		textField:"desc",
		data:DataArr
	})	
}

function InitCureCRTDataGrid(){
	var toobar=[{
        text: '新增',
        iconCls: 'icon-add',
        handler: function() {AddCRTClickHandle(); }
    }, {
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {DelCRTClickHandle();}
    }, {
        text: '保存',
        iconCls: 'icon-save',
        handler: function() { UpdateCRTClickHandle();}
    }];
	var  CRTColumns=[[
		//{ field: 'CRTType', title: '模板类型', width: 60,  resizable: true  
		//},
		//{ field: 'CRTTypeDr', title: '模板类型ID', width: 40,  hidden: true  
		//},
		{ field: 'CRTTitle', title: '模板标题', width: 150, resizable: true  
		},
		{ field: 'CRTDetail', title: '模板内容', width: 200, resizable: true  
		},
		{ field: 'CRTResponse', title: '治疗反应', width: 200, resizable: true  
		},
		{ field: 'CRTEffect', title: '治疗效果', width: 200, resizable: true  
		},
		{ field: 'CRTRowID', title: 'CRTRowID', width: 1, sortable: true, resizable: true,hidden:true}	
	 ]];
	var CureRecordTempDataGrid=$("#tabCureRecordTemp").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		toolbar:toobar,
		loadMsg : '加载中..',  
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.CureItemSet&QueryName=FindCRT&rows=9999",
		pagination : true,
		rownumbers : true,
		idField:"CRTRowID",
		pageSize:10,
		pageList : [10,25,50],
		columns :CRTColumns,
		onLoadSuccess:function(data){  
		},
		onClickRow:function(rowIndex, rowData){
			ClearCRTData();
			//$("#CRTType").combobox("setValue",rowData.CRTTypeDr);
			$("#CRTTitle").val(rowData.CRTTitle);
			var ret=$.cm({
				ClassName:"DHCDoc.DHCDocCure.CureItemSet",
				MethodName:"GetCRTDetailByID",
				dataType:"text",
				'DDCRTRowid':rowData.CRTRowID,
			},false);
			if(ret!=""){
				var dataArr=ret.split("^")
				$("#CRTDetail").val(dataArr[0]);
				$("#CRTResponse").val(dataArr[1]);
				$("#CRTEffect").val(dataArr[2]);
			}
		},onBeforeLoad:function(param){
			$(this).datagrid("clearSelections");
			var DDCISRowid=$('#DDCISRowid').val();
			ClearCRTData();
			$.extend(param,{DDCISRowid:DDCISRowid,Query:"1"});
		}
	});
	return CureRecordTempDataGrid
}

function ClearCRTData(){
	//$("#CRTType").combobox("setValue","");
	$("#CRTDetail,#CRTTitle,#CRTResponse,#CRTEffect").val("");
}

function AddCRTClickHandle(){
	if(!CheckCRTData("N"))return;
	var DDCRTRowid=$('#DDCISRowid').val();
	var CRTTitle=$("#CRTTitle").val();
	var CRTDetail=$("#CRTDetail").val();
	var CRTResponse=$("#CRTResponse").val();
	var CRTEffect=$("#CRTEffect").val();
	var CRTType=""; //$("#CRTType").combobox("getValue");
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.CureItemSet",
		MethodName:"SaveItemSetRecordTemp",
		DDCRTRowid:DDCRTRowid,
		CRTTitle:CRTTitle,
		CRTDetail:CRTDetail,
		CRTType:CRTType,
		CRTResponse:CRTResponse,
		CRTEffect:CRTEffect
	},function(rtn){
		if (rtn=="0"){
			$.messager.show({title:"提示",msg:"增加成功!"});
			LoadCureCRTDataGrid();
		}else{
			if(rtn=="-100"){rtn="请选择一个已激活的治疗项目!"}
			else if(rtn=="-101"){rtn="保存失败,"+rtn}
			else if(rtn=="-102"){rtn="获取对象失败!"+rtn}
			else if(rtn=="-103"){rtn="已存在相同类型模板"+rtn}
			$.messager.alert("提示",rtn, "error");
			return false;
		}
	});
}
function UpdateCRTClickHandle(){
	if(!CheckCRTData("U"))return;
	var rows = PageLogicObj.CureCRTDataGrid.datagrid('getSelections');
	if (rows.length ==0) {
		$.messager.alert("提示","请选择一条需要更新的模板记录!", "warning");	
		return;
	}
	var DDCRTRowid=rows[0].CRTRowID;
	var CRTTitle=$("#CRTTitle").val();
	var CRTType=""; //$("#CRTType").combobox("getValue");
	var CRTDetail=$("#CRTDetail").val();
	var CRTResponse=$("#CRTResponse").val();
	var CRTEffect=$("#CRTEffect").val();
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.CureItemSet",
		MethodName:"SaveItemSetRecordTemp",
		DDCRTRowid:DDCRTRowid,
		CRTTitle:CRTTitle,
		CRTDetail:CRTDetail,
		CRTType:CRTType,
		CRTResponse:CRTResponse,
		CRTEffect:CRTEffect
	},function(rtn){
		if (rtn=="0"){
			$.messager.show({title:"提示",msg:"保存成功!"});
			LoadCureCRTDataGrid();
		}else{
			if(rtn=="-100"){rtn="请选择一个已激活的治疗项目!"}
			else if(rtn=="-101"){rtn="保存失败,"+rtn}
			else if(rtn=="-102"){rtn="获取对象失败!"+rtn}
			else if(rtn=="-103"){rtn="已存在相同类型模板"+rtn}
			$.messager.alert("提示",rtn, "error");
			return false;
		}
	});
}
function DelCRTClickHandle(){
	var rows=PageLogicObj.CureCRTDataGrid.datagrid('getSelected');
	if ((!rows)||(rows.length==0)){
		$.messager.alert("提示","请选择需要删除的行!");
		return false;
	}
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.CureItemSet",
		MethodName:"DelItemSetRecordTemp",
		DDCRTRowid:rows['CRTRowID']
	},function(rtn){
		if (rtn=="0"){
			$.messager.show({title:"提示",msg:"删除成功!"});
			LoadCureCRTDataGrid();
		}else{
			$.messager.alert("提示","删除失败!"+rtn, "error");
			return false;
		}
	});
}

function LoadCureCRTDataGrid(){
	if(PageLogicObj.CureCRTDataGrid){
		PageLogicObj.CureCRTDataGrid.datagrid("reload");
	}
}

function CheckCRTData(val){
	if(val=="N"){
		var DDCISPRowid=$('#DDCISRowid').val();
        var ActiveFlag="";
        if ($HUI.switchbox("#ActiveFlag").getValue()) {
			ActiveFlag="Y";
		}
        if((DDCISPRowid=="")){
	    	$.messager.alert("提示","请在左侧树选择一个已保存的治疗医嘱项", "error");
			return false;  
	    }
	}
	if(val=="U"){
	}
	var CRTType=""; //$("#CRTType").combobox("getValue");
	var CRTTitle=$("#CRTTitle").val();
	var CRTDetail=$("#CRTDetail").val();
	var CRTResponse=$("#CRTResponse").val();
	var CRTEffect=$("#CRTEffect").val();
	
	if(CRTType==""){
		//$.messager.alert("提示","请选择模板类型!", "error");
		//return false;		
	}
	if(CRTTitle==""){
		//$.messager.alert("提示","请填写治疗记录模板标题!", "error");	
		//return false;	
	}else{
		if(CRTTitle.indexOf("^")>0){
			$.messager.alert("提示","治疗记录模板标题所含字符'^'为系统保留字符,请修改或者换用其他字符!", "error");	
			return false;		
		}
		if(CRTTitle.length>50){
			$.messager.alert("提示","治疗记录模板标题长度过长,建议不超过50字符!", "error");	
			return false;	
		}	
	}
	if(CRTDetail==""){
		$.messager.alert("提示","请填写治疗记录模板内容!", "error");
		return false;	
	}else{
		if(CRTDetail.indexOf("^")>0){
			$.messager.alert("提示","治疗记录模板内容所含字符'^'为系统保留字符,请修改或者换用其他字符!", "error");	
			return false;		
		}	
	}
	if(CRTResponse==""){
		//$.messager.alert("提示","请填写治疗反应模板内容!", "error");
		//return false;	
	}else{
		if(CRTResponse.indexOf("^")>0){
			$.messager.alert("提示","治疗反应模板内容所含字符'^'为系统保留字符,请修改或者换用其他字符!", "error");	
			return false;		
		}	
	}
	if(CRTEffect==""){
		//$.messager.alert("提示","请填写治疗效果模板内容!", "error");
		//return false;	
	}else{
		if(CRTDetail.indexOf("^")>0){
			$.messager.alert("提示","治疗效果模板内容所含字符'^'为系统保留字符,请修改或者换用其他字符!", "error");	
			return false;		
		}	
	}
	return true;
}

function ImportTemplate(){
	var src="doccure.rbcresplan.import.hui.csp?mClassName=DHCDoc.DHCDocCure.OnlineSupport&mMethodName=ImportTotalExcel";
	if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
	var $code ="<iframe width='100%' height='98%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	com_Util.createModalDialog("importDiag","导入", 850, 545,"icon-w-import","",$code,"");
}

function InitCurePartDataGrid(){
	var toobar=[{
        text: '新增',
        iconCls: 'icon-add',
        handler: function() {
	        var HasExpKey="";
	        var rows = PageLogicObj.CurePartDataGrid.datagrid('getRows');
			if (rows.length>0){
				HasExpKey=rows[0].ExpKey;
			}
		
	        var DDCISRowid=$('#DDCISRowid').val();
	        if((DDCISRowid=="")){
		    	$.messager.alert("提示","请在左侧树选择一个已保存的治疗医嘱项", "error");
				return false;  
		    }
			var ExpVal=$HUI.combobox("#CurePart").getValues();
			var GrpExpVal=$HUI.combobox("#CurePartGrp").getValues();
			if(ExpVal=="" && GrpExpVal==""){
				$.messager.alert("提示","请选择需要关联的部位/穴位.", "error");	
				return false;		
			}
			if(ExpVal!=""){
				SaveCureItemSetExpVal("POA",ExpVal);
        	}
			if(GrpExpVal!=""){
				SaveCureItemSetExpVal("POAGRP",GrpExpVal)
			} 
	    }
    }, {
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {
	    	var rows=PageLogicObj.CurePartDataGrid.datagrid('getSelected');
			if ((!rows)||(rows.length==0)){
				$.messager.alert("提示","请选择需要删除的行!");
				return false;
			}
			$.cm({
				ClassName:"DHCDoc.DHCDocCure.CureItemSet",
				MethodName:"DelCureItemSetExpVal",
				DDCExpRowid:rows['ExpRowID'],
				dataType:"text"
			},function(rtn){
				if (rtn=="0"){
					$.messager.popover({type:"success",msg:"删除成功!"});
					LoadCurePartDataGrid();
				}else{
					$.messager.alert("提示","删除失败!"+rtn, "error");
					return false;
				}
			});    
	    }
    }];
	var  CurePartColumns=[[
		{ field: 'ExpKeyDesc', title: '部位/穴位', width: 100,  resizable: true,
			formatter:function(value,row,index){
				if (row.ExpKey == "POAGRP"){
					return "<span class='fillspan'>【组】</span>"+value;
				}else{
					return value;
				}
			}
		},
		{ field: 'ExpValue', title: '部位/穴位值', width: 50,  resizable: true  
		},
		{ field: 'ExpKey', title: 'ExpKey', width: 100,  hidden: true  
		},
		{ field: 'ExpRowID', title: 'ExpRowID', width: 1, sortable: true, resizable: true,hidden:true}	
	 ]];
	var CurePartDataGrid=$("#tabCurePartList").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : true,
		toolbar:toobar,
		loadMsg : '加载中..', 
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.CureItemSet&QueryName=QueryCureItemExp&rows=9999", 
		pagination : true,
		rownumbers : true,
		idField:"ExpRowID",
		pageSize:10,
		pageList : [10,25,50],
		columns :CurePartColumns,
		onLoadSuccess:function(data){  
		},
		onClickRow:function(rowIndex, rowData){
		},onBeforeLoad:function(param){
			$(this).datagrid("clearSelections");
			var DDCISRowid=$('#DDCISRowid').val();
			var HospDr=Util_GetSelHospID();
			$.extend(param,{DDCISRowid:DDCISRowid,Key:"POA^POAGRP",HospId:HospDr});
		}
	});
	return CurePartDataGrid
}
function LoadCurePartDataGrid(){
	PageLogicObj.CurePartDataGrid.datagrid("reload");
}

function SaveCureItemSetExpVal(Key,ExpVal){
	var DDCISRowid=$('#DDCISRowid').val();
	var ExpValStr=ExpVal.join("^");
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.CureItemSet",
		MethodName:"SaveItemSetExpValBatch",
		DDCISRowid:DDCISRowid,
		Key:Key,
		ExpValStr:ExpValStr,
		dataType:"text"
	},function(rtn){
		if (rtn=="0"){
			$.messager.popover({type:"success",msg:"保存成功!"});
			LoadCurePartDataGrid();
			$HUI.combobox("#CurePart").setValue("");
			$HUI.combobox("#CurePartGrp").setValue("");
		}else{
			if(rtn=="-100"){rtn="请选择一个已激活的治疗项目!"}
			else if(rtn=="-101"){rtn="保存失败,"+rtn}
			else if(rtn=="-102"){rtn="获取对象失败!"+rtn}
			else if(rtn=="Repeat"){rtn="数据重复."}
			$.messager.alert("提示",rtn, "error");
			return false;
		}
	});  	
}

function InitCurePart(){
	var HospDr=Util_GetSelHospID();
	var Type="";
	var checkedRadioObj = $("input[name='PartOrAcupoint']:checked");
	if(checkedRadioObj.length>0)Type=checkedRadioObj.val();
	$HUI.combobox("#CurePart",{
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.BodySet&QueryName=QueryPartSetConfig&Type="+Type+"&HospID="+HospDr+"&SActiveFlag=Y&ResultSetType=array",
		valueField:'CPSRowid',
		textField:'CPSDesc',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		filter: function(q, row){
			var q = q.toUpperCase();
			return (row["CPSDesc"].toUpperCase().indexOf(q) >= 0)||(row["CPSAlias"].toUpperCase().indexOf(q) >= 0);
		}
	});	
}
function InitCurePartGrp(){
	var HospDr=Util_GetSelHospID();
	var Type="";
	var checkedRadioObj = $("input[name='PartOrAcupointGrp']:checked");
	if(checkedRadioObj.length>0)Type=checkedRadioObj.val();
	$HUI.combobox("#CurePartGrp",{
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.BodySet&QueryName=QueryPartGrpSet&Type="+Type+"&HospID="+HospDr+"&SActiveFlag=Y&NotCheckKeyFlag=Y&ResultSetType=array",
		valueField:'CPGSRowid',
		textField:'CPGSDesc',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		filter: function(q, row){
			var q = q.toUpperCase();
			return (row["CPGSDesc"].toUpperCase().indexOf(q) >= 0)||(row["CPGSAlias"].toUpperCase().indexOf(q) >= 0);
		}
	});		
}

function DownLoadClickHandle(){
	$cm({
		ResultSetType:"ExcelPlugin", 
		ExcelName:"治疗项目设置数据导入模板",
		PageName:"CureItemSet",
		ClassName:"DHCDoc.DHCDocCure.OnlineSupport",
		QueryName:"QryItemSetTPL"
	},false);
}