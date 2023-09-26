var PageLogicObj={
	m_selectItemRow:"",
	//CureItemDataGrid:"",
	CurePlanDataGrid:"",
	CureAppendItemDataGrid:"",
	editRow:undefined,
	m_selectTreeNode:undefined,
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
});

function Init(){
	//InitCureItemCat();
	//初始化左侧树
	InitCureItemTree("");
	InitCureServiceGroup();
	//PageLogicObj.CureItemDataGrid=InitCureItemDataGrid();	
	PageLogicObj.CurePlanDataGrid=InitCurePlanDataGrid();
	PageLogicObj.CureAppendItemDataGrid=InitAppendItemDataGrid();
	//LoadCureItemDataGrid(true);	
	LoadCurePlanDataGrid();
	initItmMastColumns();
}

function InitEvent(){
	//$('#btnFind').bind("click",function(){
	//LoadCureItemDataGrid();	
	//})
	$('#btnSave').bind("click",function(){
		SaveCureItemDetail();	
	})
	
	$('#insertappenditem').bind("click",InsertAppendItemRow);
	$('#saveappenditem').bind("click",SaveCureItemAppendItem);
	$('#deleteappenditem').bind("click",DelAppendItemClickHandle);
	$('#cancelappenditem').bind("click",CancelAppendItemClickHandle);
	
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
	$(".plan_table input").width(planItemWidth)
	$(".plan_table textarea").width(planItemWidth)
	$(".plan_table textarea").height(planItemHeight)
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
		/*onBeforeExpand:function(node){
			var targeteleid=node.eleid;
			if (targeteleid!="") return false;
			var targetId=node.id;
			var targetIdLen=targetId.length;
			var state="closed",defId="",attributes="";
			tbox.append({
				parent: node.target,
			});
			if (defId!=""){
				var node =tbox.find(defId);
				tbox.expand(node.target);
		    }
		},*/
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
		},onLoadSuccess:function(data){  
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
function InitCureItemCat(){
	var CureItemCatObj=$HUI.combobox("#CureItemCat",{
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.CureItemSet&QueryName=FindCureItemCat&ResultSetType=array",
		valueField:'ItemCatId',
		textField:'ItemCatDesc',
		onSelect:function(record){
			LoadCureItemDataGrid();	
		} 
	
	});	
}

function InitCureServiceGroup(){
	var HospDr=Util_GetSelHospID();
	//服务组列表
	var CureServiceGroupObj=$HUI.combobox("#ServiceGroup",{
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.RBCServiceGroupSet&QueryName=QueryServiceGroup&HospID="+HospDr+"&ResultSetType=array",
		valueField:'Rowid',
		textField:'Desc',
		onSelect:function(record){
			//LoadCureItemDataGrid();	
		} 
	
	});	
}
//原来的表格数据加载医嘱项信息，现改为树形结构
function InitCureItemDataGrid(){
	var cureItemColumns=[[
		{ field: 'ArcimDesc', title: '项目名称', width: 300, sortable: true, resizable: true  
		},
		{ field: 'ActiveFlag', title: '是否激活', width: 80, sortable: true, resizable: true  
		},
		{ field: 'ItemRowid', title: 'ItemRowid', width: 1, sortable: true, resizable: true,hidden:true  
		},
		{ field: 'Rowid', title: 'Rowid', width: 1, sortable: true, resizable: true,hidden:true}	
	 ]];
	var CureItemDataGrid=$("#tabCureItemSet").datagrid({ //$HUI.datagrid('#tabCureItemSet',{
		fit : true,
		//width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		//height:100,
		//scrollbarSize : '40px',
		//url : './dhcdoc.cure.query.grid.easyui.csp',
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"ItemRowid",
		pageSize:10,
		pageList : [10,25,50],
		//frozenColumns : FrozenCateColumns,
		columns :cureItemColumns,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onClickRow:function(rowIndex, rowData){
			PageLogicObj.CureItemDataGrid.datagrid('selectRow',rowIndex);
			PageLogicObj.m_selectItemRow=rowIndex;
			var selected=PageLogicObj.CureItemDataGrid.datagrid('getRows'); 
			var Rowid=selected[rowIndex].Rowid;
			var ItemRowid=selected[rowIndex].ItemRowid;
			loadCureItemDetail(Rowid,ItemRowid);
		}
	});
	return CureItemDataGrid;
}

function LoadCureItemDataGrid(init)
{
	var CureItemCat=$('#CureItemCat').combobox('getValue');
	var CureItemDesc=$('#CureItemDesc').val();
	if((CureItemCat=="")&&(!init)){
		$.messager.alert('提示','请选择子类', "error");   
        return false;	
	}
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.CureItemSet",
		QueryName:"FindCureItem",
		'ItemCat':CureItemCat,
		'ItemDesc':CureItemDesc,
		Pagerows:PageLogicObj.CureItemDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.CureItemDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
		//CureItemDataGrid.datagrid('unselectAll');	
		if((typeof(PageLogicObj.m_selectItemRow)!='undefined')&&(PageLogicObj.m_selectItemRow!="")){
			//setTimeout(function(){ReloadItemDetail()},500)	
			ReloadItemDetail();
		}
	})
}
function ClearCureItemDetail(){
	$("#DDCISRowid").val("");
	$("#ItemRowid").val("");
	$("#ArcimCode").val("") //prop("innerText",ArcimCode);
	$("#ArcimDesc").val("") //.prop("innerText",ArcimDesc);
	$("#ShortName").val("");
	$('#ServiceGroup').combobox('setValue',"");
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
		var AutoAppobj=$HUI.checkbox("#AutoApp");
		//var ManualApplyobj=$HUI.checkbox("#ManualApply");
		//var ApplyExecobj=$HUI.checkbox("#ApplyExec");
		var ManualApplyobj=$HUI.switchbox("#ManualApply");
		var ApplyExecobj=$HUI.switchbox("#ApplyExec");
		var ActiveFlagobj=$HUI.switchbox("#ActiveFlag");
		var IPApplyExecobj=$HUI.switchbox("#IPApplyExec");
		if(AutoAppFlag=="Y")
		{
		   var AutoApp=true
		   //AutoAppobj.check();
		}else{
		   var AutoApp=false;
		   //AutoAppobj.uncheck();
		}
		
		if(ManualApplyFlag=="Y")
		{
		   var ManualApply=true
		   //ManualApplyobj.check();
		}else{
		   var ManualApply=false
		   //ManualApplyobj.uncheck();
		}
		ManualApplyobj.setValue(ManualApply)
		if(ApplyExecFlag=="Y")
		{
		   var ApplyExec=true;
		   //ApplyExecobj.check();
		}else{
		   var ApplyExec=false;
		   //ApplyExecobj.uncheck();
		}
		ApplyExecobj.setValue(ApplyExec);
		if(IPApplyExecFlag=="Y")
		{
		   var IPApplyExec=true;
		}else{
		   var IPApplyExec=false;
		}
		IPApplyExecobj.setValue(IPApplyExec)
		if(ActiveFlag=="Y")
		{
		   var ActiveFlag=true
		   //AutoAppobj.check();
		}else{
		   var ActiveFlag=false;
		   //AutoAppobj.uncheck();
		}
		ActiveFlagobj.setValue(ActiveFlag);
		$("#DDCISRowid").val(Rowid);
		$("#ItemRowid").val(ItemRowid);
		$("#ArcimCode").val(ArcimCode) //prop("innerText",ArcimCode);
		$("#ArcimDesc").val(ArcimDesc) //.prop("innerText",ArcimDesc);
		$("#ShortName").val(ShortName);
		$('#ServiceGroup').combobox('setValue',ServiceGroupDR);
		$("#Effect").val(Effect);
		$("#Indication").val(Indication);
		$("#Avoid").val(Avoid);
		if((ServiceGroupActive==0)&&(ServiceGroupDR=="")){
			$.messager.alert("提示", "请注意,该治疗医嘱项对应的服务组已过截止日期,请重新选择", 'error')	
		}
		LoadCurePlanDataGrid();
		LoadCureAppendItemDataGrid();
	});
	
}

function SetItemDefaultValue(){
	$("#DDCISRowid").val("");
	$("#ItemRowid").val("");
	$("#ArcimCode").val("") //prop("innerText",ArcimCode);
	$("#ArcimDesc").val("") //.prop("innerText",ArcimDesc);
	$("#ShortName").val("");
	$('#ServiceGroup').combobox('setValue',"");
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
		$.messager.alert("错误", "代码不能为空", 'error')
    	return false;
	}
	if(ServiceGroupDR=="")
	{
		$.messager.alert('错误','服务组不能为空', "error");   
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
	var Effect=$("#Effect").val();
	var Indication=$("#Indication").val();
	var Avoid=$("#Avoid").val();
	var ManualApplyFlag="";
	var ApplyExecFlag="";
	var IPApplyExecFlag="";
	var ActiveFlag="N";
    /*if ($("#ManualApply").is(":checked")) {
	         ManualApplyFlag="Y";
	}
    if ($("#ApplyExec").is(":checked")) {
	         ApplyExecFlag="Y";
	}*/
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
	var InputPara=DDCISRowid+"^"+ItemRowid+"^"+ShortName+"^"+ServiceGroupDR+"^"+AutoAppFlag+"^"+Effect+"^"+Indication+"^"+Avoid;
	var InputPara=InputPara+"^"+ManualApplyFlag+"^"+ApplyExecFlag+"^"+ActiveFlag+"^"+IPApplyExecFlag;
    //alert(InputPara)
    var HospDr=Util_GetSelHospID();
    $.m({
		ClassName:"DHCDoc.DHCDocCure.CureItemSet",
		MethodName:"SaveCureItemSet",
		'str':InputPara,
		"HospID":HospDr
	},function(value){
		if(value=="0"){
			$.messager.show({title:"提示",msg:"保存成功"});
			//LoadCureItemDataGrid();	
			/*if((typeof(PageLogicObj.m_selectItemRow)!='undefined')&&(_selectItemRow!="")){
				setTimeout(function(){ReloadItemDetail()},500)	
			}*/
			$HUI.tree("#CureItemTree").reload();
		}else if(value==-2){
			$.messager.alert("错误", "请在下拉框中选择服务组", 'error')
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
	//alert(Rowid+",,,"+ItemRowid)
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
		{ field: 'PlanTitle', title: '方案标题', width: 100,  resizable: true  
		},
		{ field: 'PlanDetail', title: '方案内容', width: 200, resizable: true  
		},
		{ field: 'PlanRowID', title: 'PlanRowID', width: 1, sortable: true, resizable: true,hidden:true}	
	 ]];
     // 列表Grid
	var CurePlanDataGrid=$("#tabCurePlan").datagrid({ //$HUI.datagrid('#tabCureItemSet',{
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		toolbar:toobar,
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"PlanRowID",
		pageSize:10,
		pageList : [10,25,50],
		//frozenColumns : FrozenCateColumns,
		columns :CurePlanColumns,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onClickRow:function(rowIndex, rowData){
			ClearPlanData();
			$("#PlanTitle").val(rowData.PlanTitle);
			var ret=$.cm({
				ClassName:"DHCDoc.DHCDocCure.CureItemSet",
				MethodName:"GetPlanDetailByID",
				dataType:"text",
				'DDCISPRowid':rowData.PlanRowID,
			},false);
			if(ret!=""){
				$("#PlanDetail").val("");
				$("#PlanDetail").val(ret);
			}
		}
	});
	return CurePlanDataGrid
}
function LoadCurePlanDataGrid(){
	ClearPlanData();
	var DDCISPRowid=$('#DDCISRowid').val();
	$.q({
	    ClassName : "DHCDoc.DHCDocCure.CureItemSet",
	    QueryName : "FindCureItemPlan",
	    DDCISRowid : DDCISPRowid,
	    Query : 1,
	    Pagerows:PageLogicObj.CurePlanDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.CurePlanDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	}); 
	PageLogicObj.CurePlanDataGrid.datagrid("clearChecked");
	PageLogicObj.CurePlanDataGrid.datagrid("clearSelections");
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
	var PlanTitle=$("#PlanTitle").val();
	var PlanDetail=$("#PlanDetail").val();
	if(PlanTitle==""){
		$.messager.alert("提示","请填写治疗方案标题!", "error");	
		return false;	
	}else{
		if(PlanTitle.indexOf("^")>0){
			$.messager.alert("提示","方案标题所含字符'^'为系统保留字符,请修改或者换用其他字符!", "error");	
			return false;		
		}
		if(PlanTitle.length>50){
			$.messager.alert("提示","方案标题长度过长,建议不超过50字符!", "error");	
			return false;	
		}	
	}
	if(PlanDetail==""){
		$.messager.alert("提示","请填写治疗方案内容!", "error");
		return false;	
	}else{
		if(PlanDetail.indexOf("^")>0){
			$.messager.alert("提示","方案内容所含字符'^'为系统保留字符,请修改或者换用其他字符!", "error");	
			return false;		
		}	
	}
	return true;
}
function ClearPlanData(){
	$("#PlanTitle").val("");
	$("#PlanDetail").val("");
}
function AddClickHandle(){
	if(!CheckPlanData("N"))return;
	var DDCISPRowid=$('#DDCISRowid').val();
	var PlanTitle=$("#PlanTitle").val();
	var PlanDetail=$("#PlanDetail").val();
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.CureItemSet",
		MethodName:"SaveCureItemSetPlan",
		DDCISPRowid:DDCISPRowid,
		PlanTitle:PlanTitle,
		PlanDetail:PlanDetail,
	},function(rtn){
		if (rtn=="0"){
			$.messager.show({title:"提示",msg:"增加成功!"});
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
		$.messager.alert("提示","请选择一条需要更新的方案记录!", "error");	
		return;
	}
	var DDCISPRowid=rows[0].PlanRowID;
	var PlanTitle=$("#PlanTitle").val();
	var PlanDetail=$("#PlanDetail").val();
	debugger;
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.CureItemSet",
		MethodName:"SaveCureItemSetPlan",
		DDCISPRowid:DDCISPRowid,
		PlanTitle:PlanTitle,
		PlanDetail:PlanDetail,
	},function(rtn){
		if (rtn=="0"){
			$.messager.show({title:"提示",msg:"保存成功!"});
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
			$.messager.show({title:"提示",msg:"删除成功!"});
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
		pageSize:5,
		pageList : [5,10],
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
		$.messager.confirm("提示", "您确定要删除数据吗？", function (res) {
			if (res) {
				runClassMethod("DHCDoc.DHCDocCure.CureItemSet","DelCureItemAppendItem",{"DDCIAIRowid":rowsData.AppendRowID},function(jsonString){
					$('#tabCureAppendItem').datagrid('reload'); 
					PageLogicObj.editRow = undefined;
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}	
}
function CancelAppendItemClickHandle(){
	PageLogicObj.editRow = undefined;
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
			var unitUrl = PageLogicObj.ArcUrl + "&Input="+$(ed.target).val()+"&HospID="+HospDr;
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