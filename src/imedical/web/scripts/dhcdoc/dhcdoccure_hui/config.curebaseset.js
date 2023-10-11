/// Descript: config.curebaseset.js
///治疗分类设置
var PageBaseSetObj={
	editRow:undefined,
	ArcCatID:"",
	editCatRow : undefined,
	editMastRow : undefined,
	editLocRow : undefined,
	editPrvTpRow : undefined,
	ArcColumns:[],
	CureLinkLocDataGrid:"",
	CureCarePrvTpDataGrid:"",
	ItmCatObj:{CatDr:"",CatDesc:""},
	ArcUrl : LINK_CSP+'?ClassName=DHCDoc.DHCDocCure.Config&MethodName=QueryArcItmDetail'
}

$(document).ready(function(){
	//Init();
	InitHospList();
	InitEvent();
	//PageHandle();
})

function Init(){
	initArcCatlist();
	initItmCatlist();
	initItmMastlist();
	initItmMastColumns();
}

function InitEvent(){
	InitArcCatEvent();
	InitItemCatEvent();
	InitItemMastEvent();
}

function PageHandle(){
	
}

function InitHospList()
{
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_Cure_BaseConfig",hospStr);
	hospComp.jdata.options.onSelect = function(e,t){
		$.extend(PageBaseSetObj, {
			editRow:undefined,
			ArcCatID:"",
			editCatRow : undefined,
			editMastRow : undefined,
			editLocRow : undefined,
			CureLinkLocDataGrid:"",
			ItmCatObj:{CatDr:"",CatDesc:""}
		});
		//Init();
		//PageHandle();
		findArcCatList();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
		PageHandle();
	}
}

function initItmMastColumns(){
	PageBaseSetObj.ArcColumns = [[
	    {field:'itmDesc',title:'医嘱项名称',width:220},
	    {field:'itmCode',title:'医嘱项代码',width:100},
	    {field:'itmCat',title:'子类',width:80},
	    //{field:'itmPrice',title:'单价',width:60},
		{field:'itmID',title:'itmID',width:80}
	]];
}

function InitArcCatEvent(){
	///  增加治疗分类
	$('#insert').bind("click",insertARCCatRow);
	///  保存治疗分类
	$('#save').bind("click",saveARCCatRow);
	///  删除治疗分类
	$('#delete').bind("click",deleteARCCatRow);
	//同时给代码和描述绑定回车事件
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findArcCatList(); //调用查询
        }
    });
    
     // 查找按钮绑定单击事件
    $('#find').bind('click',function(event){
         findArcCatList(); //调用查询
    });
    $("#tabs").tabs({
	    onSelect:function(title,index){
			if(index==0){
				initItmCatlist();
			}else{
				initItmMastlist();
			}
		 }
	});
}
function InitItemCatEvent(){
	///  增加医嘱子类
	$('#insertcat').bind("click",insertcatRow);
	
	///  保存医嘱子类
	$('#savecat').bind("click",savecatRow);
	
	///  删除医嘱子类
	$('#deletecat').bind("click",deletecatRow);	
	
	$('#LinkItemCatCureLoc').bind("click",LinkLocClickHandle);	
	$('#LinkItemCatCureLoc').bind("mouseover",function(){
		$HUI.popover('#catprop',{title:'配置说明',placement:"top",content:'治疗科室不维护默认取【治疗常规设置-默认治疗科室】维护的科室'});
		$HUI.popover('#catprop').show()		
	});
	$('#LinkItemCatCureLoc').bind("mouseout",function(){
		$HUI.popover('#catprop').hide()		
	})
	$('#ItemCatCfgLimit').click(CfgLimitHandle);
	$("#ItemCatCfgLimit").popover({trigger:'hover',placement:"top",title:'权限设置说明',content:'配置后仅允许相应类型权限(满足任意一个权限即可)进行治疗执行、评估操作.'});
}

function InitItemMastEvent(){
	///  增加医嘱项
	$('#insertarcitm').bind("click",insertArcItmRow);
	
	///  保存医嘱项
	$('#savearcitm').bind("click",saveArcItmRow);
	
	///  删除医嘱项
	$('#deletearcitm').bind("click",deleteArcItmRow);
	
	$('#LinkItemMastCureLoc').bind("click",LinkLocClickHandle);	
	$('#LinkItemMastCureLoc').bind("mouseover",function(){
		$HUI.popover('#itemprop',{title:'配置说明',placement:"top",content:'治疗科室不维护默认取【治疗常规设置-默认治疗科室】维护的科室'});
		$HUI.popover('#itemprop').show()
	});
	$('#LinkItemMastCureLoc').bind("mouseout",function(){
		$HUI.popover('#itemprop').hide()	
	});
	$('#ItemCfgLimit').click(CfgLimitHandle);
	$("#ItemCfgLimit").popover({trigger:'hover',placement:"top",title:'权限设置说明',content:'配置后仅允许相应类型权限(满足任意一个权限即可)进行治疗预约、执行、评估操作.'});

}

///治疗分类 
function initArcCatlist(){
	var textEditor={
		type: 'text',
		options: {
			required: true
		}
	}
	// 定义columns
	var columns=[[
		{field:"catcode",title:'分类代码',width:100,editor:textEditor},
		{field:"catdesc",title:'分类描述',width:150,editor:textEditor},
		{field:"hospdesc",title:'医院',width:230},
		{field:"hospdr",title:'医院ID',width:20,align:'center',hidden:'true',editor:textEditor},
		{field:"acrowid",title:'ID',width:20,hidden:'true',align:'center'}
	]];
	var option = {
		//nowrap:false,
		fitColumns : true,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {
            if (PageBaseSetObj.editRow != undefined) { 
                $("#arccatlist").datagrid('endEdit', PageBaseSetObj.editRow); 
            } 
            $("#arccatlist").datagrid('beginEdit', rowIndex); 
            PageBaseSetObj.editRow = rowIndex; 
        },
        onClickRow:function(rowIndex, rowData){
	        PageBaseSetObj.ArcCatID=rowData.acrowid;
	        
			if(PageBaseSetObj.editRow!=undefined){
				$("#arccatlist").datagrid('endEdit', PageBaseSetObj.editRow);
				PageBaseSetObj.editRow=undefined;
			}
			PageBaseSetObj.editRow = rowIndex; 
			ReloadTab();
	    }
	};
	var hospID=GetSelHospID();
	var uniturl = LINK_CSP+"?ClassName=DHCDoc.DHCDocCure.Config&MethodName=QueryArcCat&params="+"^^"+hospID;
	new ListComponent('arccatlist', columns, uniturl, option).Init(); 
}

function insertARCCatRow(){
	
	if(PageBaseSetObj.editRow!=undefined){
		$("#arccatlist").datagrid('endEdit', PageBaseSetObj.editRow);
	}
	$("#arccatlist").datagrid('clearSelections');
	$("#arccatlist").datagrid('insertRow', {
		index: 0,
		row: {acrowid: '',catcode:'',catdesc: '',hospdesc:'',hospdr:''}
	});
    
	$("#arccatlist").datagrid('beginEdit', 0);
	PageBaseSetObj.editRow=0;
}

function saveARCCatRow(){
	if(PageBaseSetObj.editRow!=undefined){
		$("#arccatlist").datagrid('endEdit', PageBaseSetObj.editRow);
	}

	var rowsData = $("#arccatlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!","info");
		return;
	}
	var findindex=undefined;
	var dataList = [];
	var hospdr=GetSelHospID();
	for(var i=0;i<rowsData.length;i++){
		var rowIndex=$("#arccatlist").datagrid("getRowIndex",rowsData[i]);
		if(rowsData[i].catcode==""){
			$.messager.alert("提示","第"+(rowIndex+1)+"行代码为空！","info"); 
			findindex=rowIndex;
			break;
		}
		if(rowsData[i].catdesc==""){
			$.messager.alert("提示","第"+(rowIndex+1)+"行描述为空！","info"); 
			findindex=rowIndex;
			break;
		}
		/*if(rowsData[i].hospdesc==""){
			$.messager.alert("提示","第"+(rowIndex+1)+"行医院为空！","info"); 
			findindex=rowIndex;
			break;
		}*/
		var tmp=rowsData[i].acrowid +"^"+ rowsData[i].catcode +"^"+ rowsData[i].catdesc +"^"+ hospdr; //rowsData[i].hospdr;
		dataList.push(tmp);
	} 
	if(findindex!=undefined){
		$("#arccatlist").datagrid('beginEdit', findindex);
		PageBaseSetObj.editRow=findindex;
		return false;	
	}
	var params=dataList.join("&&");
	//保存数据
	runClassMethod("DHCDoc.DHCDocCure.Config","SaveArcCat",{"params":params},function(jsonString){
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			return;
		}else{
			$('#arccatlist').datagrid('reload'); //重新加载
			PageBaseSetObj.editRow=undefined;
			PageBaseSetObj.ArcCatID="";
			ReloadTab();
		}
	});
}

/// 删除
function deleteARCCatRow(){
	var rowsData = $("#arccatlist").datagrid('getSelected'); //选中要删除的行
	if ((rowsData != null)&&(rowsData.acrowid!="")) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("DHCDoc.DHCDocCure.Config","DelArcCat",{"params":rowsData.acrowid},function(jsonString){
					if (jsonString=="-5"){
						$.messager.alert('提示','该分类存在关联的医嘱子类，不能删除！','warning');
					}else if ((jsonString=="-1")||(jsonString=="-2")||(jsonString=="-3")||(jsonString=="-4")){
						$.messager.alert('提示','该分类正在使用，不能删除！','warning');
					}else{
						$('#arccatlist').datagrid('reload'); //重新加载
						PageBaseSetObj.editRow=undefined;
						PageBaseSetObj.ArcCatID="";
						ReloadTab();
					}
				})
			}
		});
	}else{
		 if(PageBaseSetObj.editRow!=undefined){
			$("#arccatlist").datagrid('deleteRow', PageBaseSetObj.editRow);
			PageBaseSetObj.editRow=undefined;
		}else{
			$.messager.alert("提示","请选择需要删除的行!","info");
			return;	
		}
	}
}

function ReloadTab(){
	var currTab =$('#tabs').tabs('getSelected'); 
	var index = $('#tabs').tabs('getTabIndex',currTab);
	if(index==0){
		PageBaseSetObj.ItmCatObj={CatDr:"",CatDesc:""}
		initItmCatlist();
	}else{
		initItmMastlist();
	}	
}

// 查询
function findArcCatList()
{
	var hospID=GetSelHospID();
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc+"^"+hospID;
	$('#arccatlist').datagrid('load',{params:params}); 
	PageBaseSetObj.editRow=undefined;
	PageBaseSetObj.ArcCatID="";
	ReloadTab();
}	 
////==========================================医嘱子类关联维护=========================
/// 初始化医嘱子类列表
function initItmCatlist()
{
	var hospID=GetSelHospID();
	var Cateditor={
		type: 'combobox',
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=DHCDoc.DHCDocCure.Config&MethodName=jsonArcItemCat&HospId="+hospID,
			//required:true,
			panelHeight:"280",
			onSelect:function(option){
				var rows=$("#itemCatList").datagrid("selectRow",PageBaseSetObj.editCatRow).datagrid("getSelected");
	            PageBaseSetObj.ItmCatObj.CatDr=option.value;
	            PageBaseSetObj.ItmCatObj.CatDesc=option.text;
				/*var ed=$("#itemCatList").datagrid('getEditor',{index:PageBaseSetObj.editCatRow,field:'CatDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#itemCatList").datagrid('getEditor',{index:PageBaseSetObj.editCatRow,field:'CatDr'});
				$(ed.target).val(option.value);*/
			},
			onChange:function(newValue, oldValue){
				if (newValue==""){
					var rows=$("#itemCatList").datagrid("selectRow",PageBaseSetObj.editCatRow).datagrid("getSelected");
                    PageBaseSetObj.ItmCatObj.CatDr="";
                    PageBaseSetObj.ItmCatObj.CatDesc="";
				}
			},
			onHidePanel:function(){
				var rows=$("#itemCatList").datagrid("selectRow",PageBaseSetObj.editCatRow).datagrid("getSelected");
				if (!$.isNumeric($(this).combobox('getValue'))) return;
				PageBaseSetObj.ItmCatObj.CatDr=$(this).combobox('getValue');
			}
		}
	}
	var columns=[[
		{field:"CatDesc",title:'医嘱子类',width:300,editor:Cateditor},
		{field:"CatDr",title:'子类ID',width:150,align:'center',hidden:'true'},
		{field:"CatLinkID",title:'ItmID',width:150,align:'center',hidden:'true'}
	]];
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {
            if (PageBaseSetObj.editCatRow != undefined) { 
                $("#itemCatList").datagrid('endEdit', PageBaseSetObj.editCatRow); 
            } 
            $("#itemCatList").datagrid('beginEdit', rowIndex); 
            PageBaseSetObj.editCatRow = rowIndex; 
        },
        onClickRow:function(rowIndex, rowData){
			if(PageBaseSetObj.editCatRow!=undefined){
				$("#itemCatList").datagrid('endEdit', PageBaseSetObj.editCatRow);
				PageBaseSetObj.editCatRow=undefined;
			}
			PageBaseSetObj.ItmCatObj={CatDr:rowData.CatDr,CatDesc:rowData.CatDesc}
			PageBaseSetObj.editCatRow = rowIndex; 
	    },
	    onAfterEdit:function(rowIndex, rowData, changes){
		    $(this).datagrid('updateRow',{
				index:rowIndex,
				row:PageBaseSetObj.ItmCatObj
			});
			PageBaseSetObj.ItmCatObj={CatDr:"",CatDesc:""}
		    PageBaseSetObj.editCatRow=undefined;
	    },
	    onLoadSuccess:function(data){
		    $("#itemCatList").datagrid('unselectAll');
		    PageBaseSetObj.editCatRow=undefined;
		}
	};
	var uniturl = LINK_CSP+"?ClassName=DHCDoc.DHCDocCure.Config&MethodName=QueryCatLink&CatRowId="+PageBaseSetObj.ArcCatID;
	new ListComponent('itemCatList', columns, uniturl, option).Init();
}
/// 插入医嘱子类
function insertcatRow()
{
	if (PageBaseSetObj.ArcCatID == ""){
		$.messager.alert("提示","请选择一个已保存的分类!","info"); 
		return;	
	}	
	if(PageBaseSetObj.editCatRow!=undefined){
		$("#itemCatList").datagrid('endEdit',PageBaseSetObj.editCatRow);
	}
	$("#itemCatList").datagrid('clearSelections');
	$("#itemCatList").datagrid('insertRow', {
		index: 0, 
		row: {CatDesc: '',CatDr:'',CatLinkID: ''}
	});
	$("#itemCatList").datagrid('beginEdit', 0);	
	PageBaseSetObj.editCatRow=0;
	PageBaseSetObj.ItmCatObj={CatDr:"",CatDesc:""}
}

function savecatRow(){
	if (PageBaseSetObj.ArcCatID == ""){
		$.messager.alert("提示","请选择一个已保存的分类!","info"); 
		return;	
	}
	var CatDr=PageBaseSetObj.ItmCatObj.CatDr;
	if (PageBaseSetObj.editCatRow!=undefined){
		$("#itemCatList").datagrid('endEdit', PageBaseSetObj.editCatRow);
	}
	var rowsData = $("#itemCatList").datagrid('getChanges');  
	if ((rowsData.length==0)&&(CatDr!="")) {
		$("#itemCatList").datagrid("rejectChanges").datagrid("unselectAll");
        return;
	}
	if (rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!","info");
		return;
	}
	//var hospID = $("#arccatlist").datagrid('getSelected').hospdr;  //这里医院ID不能取session中ID，要取左侧列表选中ID
	var hospID=GetSelHospID();
	var findindex=undefined;
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		var rowIndex=$("#itemCatList").datagrid("getRowIndex",rowsData[i]);
		if ((!rowsData[i].CatDr)||(!rowsData[i].CatDesc))
		{
			$.messager.alert("提示","第"+(rowIndex+1)+"行医嘱子类为空!","info");
			findindex=rowIndex;
			break;
		}
		
		var tmp=rowsData[i].CatLinkID +"^"+ PageBaseSetObj.ArcCatID +"^"+ rowsData[i].CatDesc +"^"+ rowsData[i].CatDr +"^"+ hospID;
		dataList.push(tmp);
	} 
	if(findindex!=undefined){
		$("#itemCatList").datagrid('beginEdit', findindex);
		PageBaseSetObj.editCatRow=findindex;
		return false;	
	}
	var params=dataList.join("&&");
	//保存数据
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		MethodName:"SaveLIC",
		params:params,
		dataType:"text"
	},function(ret){
		if (ret == "0"){
			$.messager.popover({msg:"保存成功",type:"success",timeout:3000});
			ClearItemCatObj();
		}else{
			var ErrMsg=ret.split("^")[1];
			$.messager.alert('提示',ErrMsg,"warning");	
		}
	})
}
/// 删除
function deletecatRow(){
	var rowsData = $("#itemCatList").datagrid('getSelected');
	if((rowsData != null)&&(rowsData.CatLinkID!="")){
		$.messager.confirm("提示", "您确定要删除选择的数据吗？", function (res) {
			if (res) {
				runClassMethod("DHCDoc.DHCDocCure.Config","DelCatLink",{"CatLinkId":rowsData.CatLinkID},function(jsonString){
					ClearItemCatObj();
				})
			}
		});
	}else{
		 if(PageBaseSetObj.editCatRow!=undefined){
			$("#itemCatList").datagrid('deleteRow', PageBaseSetObj.editCatRow);
			PageBaseSetObj.editCatRow=undefined;
		}else{
			$.messager.alert("提示","请选择需要删除的子类!","info");
			return;	
		}
	}
}
function ClearItemCatObj(){
	$('#itemCatList').datagrid('reload');
	PageBaseSetObj.editCatRow=undefined;
	PageBaseSetObj.ItmCatObj.CatDr="";
    PageBaseSetObj.ItmCatObj.CatDesc="";
    $("#itemCatList").datagrid('clearSelections');	
}
////==========================================医嘱项关联维护=========================
function initItmMastlist(){
	new ListComponentWin().RemoveMyDiv();
	/// 文本编辑格
	var textEditor={
		type: 'text',
		options: {
			//required: true
		}
	}
	
	///  定义columns
	var columns=[[
		{field:'ArcDr',title:'医嘱项ID',width:100,align:'center',hidden:true,editor:textEditor},
		{field:'ArcCode',title:'医嘱项代码',width:150,align:'center',editor:textEditor},
		{field:'ArcDesc',title:'医嘱项/医嘱套',width:240,align:'center',editor:textEditor},
		{field:"CatLinkID",title:'ID',hidden:true,editor:textEditor}
	]];
	
	var option = {
		rownumbers : true,
		singleSelect : true,
		showPageList : false,
	    onDblClickRow: function (rowIndex, rowData) {
            if ((PageBaseSetObj.editMastRow != "")||(PageBaseSetObj.editMastRow == "0")) { 
                $("#arcItemList").datagrid('endEdit', PageBaseSetObj.editMastRow); 
            } 
            $("#arcItemList").datagrid('beginEdit', rowIndex); 
            dataGridBindEnterEvent(rowIndex);
            PageBaseSetObj.editMastRow = rowIndex;
        },
        onClickRow:function(rowIndex, rowData){
			if(PageBaseSetObj.editMastRow!=undefined){
				$("#arcItemList").datagrid('endEdit', PageBaseSetObj.editMastRow);
				PageBaseSetObj.editMastRow=undefined;
			}
			PageBaseSetObj.editMastRow = rowIndex; 
	    },
	    onLoadSuccess:function(data){
		    $("#arcItemList").datagrid('unselectAll');
		    PageBaseSetObj.editMastRow=undefined;
		}
	};
	var uniturl = LINK_CSP+"?ClassName=DHCDoc.DHCDocCure.Config&MethodName=QueryCatLinkArcItm&ArcCatId="+PageBaseSetObj.ArcCatID;	
	new ListComponent('arcItemList', columns, uniturl, option).Init(); 
}

/// 插入医嘱项
function insertArcItmRow(){
	if (PageBaseSetObj.ArcCatID == ""){
		$.messager.alert("提示","请选择一个已保存的分类!","info"); 
		return;	
	}	
	if(PageBaseSetObj.editMastRow!=undefined){
		$("#arcItemList").datagrid('endEdit', PageBaseSetObj.editMastRow);
	}
	$("#arcItemList").datagrid('clearSelections');
	$("#arcItemList").datagrid('insertRow', {
		index: 0, 
		row: { ArcDr:'', ArcDesc:''}
	});
	$("#arcItemList").datagrid('beginEdit', 0);
	PageBaseSetObj.editMastRow=0;	
	
	var rows = $("#arcItemList").datagrid('getRows');
	if (rows.length != "0"){
		dataGridBindEnterEvent(0);
	}
}

///保存医嘱项
function saveArcItmRow(){
	if (PageBaseSetObj.ArcCatID == ""){
		$.messager.alert("提示","请选择一个已保存的分类!","info"); 
		return;	
	}	
	if(PageBaseSetObj.editMastRow!=undefined){
		$("#arcItemList").datagrid('endEdit', PageBaseSetObj.editMastRow);
	}
	var rowsData = $("#arcItemList").datagrid('getChanges');
	if(rowsData.length<=0){
		//$.messager.alert("提示","没有待保存数据!");
		$('#arcItemList').datagrid('reload');	
		return;
	}
	//var hospID = $("#arccatlist").datagrid('getSelected').hospdr;
	var hospID=GetSelHospID();
	var findindex=undefined;
		
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		var rowIndex=$("#arcItemList").datagrid("getRowIndex",rowsData[i]);
		if ((!rowsData[i].ArcDr)||(!rowsData[i].ArcDr))
		{
			$.messager.alert("提示","第"+(rowIndex+1)+"行医嘱项未选择!","info");
			findindex=rowIndex;
			break;
		} 
		var tmp=rowsData[i].CatLinkID  +"^"+ rowsData[i].ArcDr +"^"+ PageBaseSetObj.ArcCatID+"^"+hospID;
		dataList.push(tmp);
	} 
	if(findindex!=undefined){
		$("#arcItemList").datagrid('beginEdit', findindex);
		PageBaseSetObj.editMastRow=findindex;
		dataGridBindEnterEvent(findindex);
		return false;	
	}
	var params=dataList.join("&&");
	//保存数据
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		MethodName:"SaveLinkArc",
		params:params,
		dataType:"text"
	},function(ret){
		if (ret == "0"){
			$.messager.popover({msg:"保存成功",type:"success",timeout:3000});
			$('#arcItemList').datagrid('reload');	
		}else{
			var ErrMsg=ret.split("^")[1];
			$.messager.alert('提示',ErrMsg,"warning");	
		}
	})
}
/// 删除
function deleteArcItmRow(){
	var rowsData = $("#arcItemList").datagrid('getSelected');
	if((rowsData != null)&&(rowsData.CatLinkID!="")){
		new ListComponentWin().RemoveMyDiv();
		$.messager.confirm("提示", "您确定要删除选择的数据吗？", function (res) {
			if (res) {
				runClassMethod("DHCDoc.DHCDocCure.Config","DelCatLinkArcItm",{"AcRowId":rowsData.CatLinkID},function(jsonString){
					$('#arcItemList').datagrid('reload');
					PageBaseSetObj.editMastRow=undefined;
					$("#arcItemList").datagrid('clearSelections');
				})
			}
		});
	}else{
		 if(PageBaseSetObj.editMastRow!=undefined){
			$("#arcItemList").datagrid('deleteRow', PageBaseSetObj.editMastRow);
			PageBaseSetObj.editMastRow=undefined;
			new ListComponentWin().RemoveMyDiv();
		}else{
			$.messager.alert("提示","请选择需要删除的医嘱项!","info");
			return;	
		}
	}
}

/// 给医嘱项绑定回车事件
function dataGridBindEnterEvent(index){
	var hospID=GetSelHospID();
	var editors = $('#arcItemList').datagrid('getEditors', index);
	var workRateEditor = editors[2];
	workRateEditor.target.focus();
	workRateEditor.target.bind('keydown', function(e){
		if (e.keyCode == 13) {
			var ed=$("#arcItemList").datagrid('getEditor',{index:index, field:'ArcDesc'});		
			var input = $(ed.target).val();
			if (input == ""){return;}
			var unitUrl = PageBaseSetObj.ArcUrl + "&Input="+$(ed.target).val()+"&HospID="+hospID;
			/// 调用医嘱项列表窗口
			new ListComponentWin($(ed.target), input, "500px", "" , unitUrl, PageBaseSetObj.ArcColumns, setCurrEditRowCellVal).init();
		}
	});
}
/// 给当前编辑列赋值(医嘱项目)
function setCurrEditRowCellVal(rowObj){
	if (rowObj == null){
		var editors = $('#arcItemList').datagrid('getEditors', PageBaseSetObj.editMastRow);
		var workRateEditor = editors[1];
		workRateEditor.target.focus().select();
		return;
	}
	/// 项目名称
	var ed=$("#arcItemList").datagrid('getEditor',{index:PageBaseSetObj.editMastRow, field:'ArcDesc'});
	$(ed.target).val(rowObj.itmDesc);
	/// 项目名称ID
	var ed=$("#arcItemList").datagrid('getEditor',{index:PageBaseSetObj.editMastRow, field:'ArcDr'});		
	$(ed.target).val(rowObj.itmID);
	/// 项目代码
	var ed=$("#arcItemList").datagrid('getEditor',{index:PageBaseSetObj.editMastRow, field:'ArcCode'});		
	$(ed.target).val(rowObj.itmCode);
}
//保存其他配置信息
function SaveConfigData()
{
	var LocDataStr=""
	var size = $("#List_DHCDocCureLoc option").size();
	if(size>0){
		$.each($("#List_DHCDocCureLoc  option:selected"), function(i,own){
			var svalue = $(own).val();
			if (LocDataStr=="") LocDataStr=svalue
			else LocDataStr=LocDataStr+"^"+svalue
		})
		LocDataStr="DHCDocCureLocStr"+String.fromCharCode(1)+LocDataStr
	}
	var SwitchDataStr="";
	for( var i=0;i<arrayObj.length;i++) {
		var param1=arrayObj[i][0];
		var param2=arrayObj[i][1];
		var CheckedValue=0;
		//if ($("#"+param1+"").is(":checked")) {
		if ($HUI.switchbox("#"+param1+"").getValue()) {
			CheckedValue=1;
		}
		if(SwitchDataStr=="") SwitchDataStr=param2+String.fromCharCode(1)+CheckedValue;
		else  SwitchDataStr=SwitchDataStr+String.fromCharCode(2)+param2+String.fromCharCode(1)+CheckedValue;		  
	}
	
	var FTPConfigStr="";
	var FTPPassWord="";
	var FTPPassWordC="";
	for( var i=0;i<arrayObj1.length;i++) {
	   	var param1=arrayObj1[i][0];
	   	var param2=arrayObj1[i][1];
	   	var paramval=$("#"+param1).val();
	   	if(param2=="DHCDocCureFTPPassWord"){
		   	FTPPassWord=paramval;
	   	}
	   	else if(param2=="DHCDocCureFTPPassWordC"){
		   	FTPPassWordC=paramval;
		   	//continue;
	   	}else{
			 var paramval=$.trim(paramval);  	
		}
	   	if(FTPConfigStr==""){
		   	FTPConfigStr=param2+String.fromCharCode(1)+paramval;
		}else{
		   	FTPConfigStr=FTPConfigStr+String.fromCharCode(2)+param2+String.fromCharCode(1)+paramval;
		}
	}
	if(FTPPassWord!=FTPPassWordC){
		$.messager.alert('提示',"FTP用户密码与确认密码不一致,请重试.","info");
		return false;	
	}
	
	var DataStr=LocDataStr;
	var DataStr=DataStr+String.fromCharCode(2)+SwitchDataStr;
	var DataStr=DataStr+String.fromCharCode(2)+FTPConfigStr;
	var hospID=GetSelHospID();
	$.m({
		ClassName:"web.DHCDocConfig",
		MethodName:"SaveConfig",
		Coninfo:DataStr,
		HospId:hospID
	},function(value){
		if(value=="0"){
			$.messager.show({title:"提示",msg:"保存成功"});					
		}else{
			$.messager.alert('提示','保存失败！',"warning");	
		}
	});
}

function LinkLocClickHandle(){
	var tblobj="";
	var LinkType="";
	var currTab =$('#tabs').tabs('getSelected'); 
	var index = $('#tabs').tabs('getTabIndex',currTab);
	if(index==0){
		tblobj=$("#itemCatList");
		LinkType="CAT";
	}else{
		tblobj=$("#arcItemList")
		LinkType="ITEM";
	}
	var RowID="";
	var rows = tblobj.datagrid("getSelections");
    if (rows.length > 0) {
		var ids = [];
		for (var i = 0; i < rows.length; i++) {
			ids.push(rows[i].CatLinkID);
		}
		var RowID=ids.join(',')
	}else{
		$.messager.alert('提示',"请选择一条记录!","info");
		return false;
	}
	if(RowID==""){
		$.messager.alert('提示',"获取行信息错误.","info");
		return false;
	}
    $("#dialog_CureLoc").css("display", ""); 
	var dialog = $HUI.dialog("#dialog_CureLoc",{ //$("#dialog-CureLinkLoc").dialog({
		autoOpen: false,
		height: 500,
		width: 400,
		modal: true
	});
	dialog.dialog( "open" );
	InitCureLinkLoc(RowID,LinkType);	
}


function InitCureLinkLoc(Rowid,Type)
{
	var CureLinkToolBar = [{
	    text: '增加',
	    iconCls: 'icon-add',
	    handler: function() {
		    //PageBaseSetObj.editLocRow = undefined;
	        //PageBaseSetObj.CureLinkLocDataGrid.datagrid("unselectAll");
	        if (PageBaseSetObj.editLocRow != undefined) {
	            $.messager.alert("提示", "有正在编辑的行，请先点击保存", "info");
	            //PageBaseSetObj.CureLinkLocDataGrid.datagrid("endEdit", PageBaseSetObj.editLocRow);
	            return;
	        }else{
		        if(PageBaseSetObj.CureLinkLocDataGrid.datagrid("getRows").length == 0 ){
					PageBaseSetObj.CureLinkLocDataGrid.datagrid("options").pageNumber = 1;
				}
	            PageBaseSetObj.CureLinkLocDataGrid.datagrid("insertRow", {
	                index: 0,
	                row: {
						RowID:"",
						CureLocRowID:"",
						LocDesc:"",						
					}
	            });
	            PageBaseSetObj.CureLinkLocDataGrid.datagrid("beginEdit", 0);
	            PageBaseSetObj.editLocRow = 0;
	        }
	      
	    }
	},{
	    text: '保存',
	    iconCls: 'icon-save',
	    handler: function() {
	        if(PageBaseSetObj.editLocRow==undefined){
				return false;
		  	}
	        var rows = PageBaseSetObj.CureLinkLocDataGrid.datagrid("getRows");
			if (rows.length > 0){
			   for (var i = 0; i < rows.length; i++) {
				   if(PageBaseSetObj.editLocRow==i){
					   var rows=PageBaseSetObj.CureLinkLocDataGrid.datagrid("selectRow",PageBaseSetObj.editLocRow).datagrid("getSelected");  
					   var editors = PageBaseSetObj.CureLinkLocDataGrid.datagrid('getEditors', PageBaseSetObj.editLocRow); 
					   var CureLocRowID=editors[0].target.combobox('getValue');
					   if ((!CureLocRowID)||(rows.CureLocRowID=="")){
							$.messager.alert('提示',"请选择科室!","info");
							return false;
			            }
						$.m({
							ClassName:"DHCDoc.DHCDocCure.Config",
							MethodName:"insertArcCatLoc",
							'MainID':Rowid,
							'CureLocRowID':CureLocRowID,
							'Type':Type
						},function testget(value){
							if(value=="0"){
								PageBaseSetObj.CureLinkLocDataGrid.datagrid("endEdit", PageBaseSetObj.editLocRow);
								PageBaseSetObj.editLocRow = undefined;
								CureLinkLocDataGridLoad(Type,Rowid);
								PageBaseSetObj.CureLinkLocDataGrid.datagrid('unselectAll');
								$.messager.show({title:"提示",msg:"保存成功"});
							}else if(value=="-1"){
								$.messager.alert('提示',"保存失败,该记录已存在","warning");
								return false;
							}else if(value=="-2"){
								$.messager.alert('提示',"保存失败,请正确选择科室","warning");
								return false;
							}else{
								$.messager.alert('提示',"保存失败:"+value,"warning");
								return false;
							}
							PageBaseSetObj.editLocRow = undefined;
							
						});
				   }
			   }
			}

	    }
	}, {
	    text: '取消编辑',
	    iconCls: 'icon-redo',
	    handler: function() {
	        PageBaseSetObj.editLocRow = undefined;
	        PageBaseSetObj.CureLinkLocDataGrid.datagrid("rejectChanges");
	        PageBaseSetObj.CureLinkLocDataGrid.datagrid("unselectAll");
	    }
	},
	{
	    text: '删除',
	    iconCls: 'icon-remove',
	    handler: function() {
	        //删除时先获取选择行
	        var rows = PageBaseSetObj.CureLinkLocDataGrid.datagrid("getSelections");
	        //选择要删除的行
	        if (rows.length > 0) {
	            $.messager.confirm("提示", "你确定要删除吗?",
	            function(r) {
	                if (r) {
	                    var ids = [];
	                    for (var i = 0; i < rows.length; i++) {
	                        ids.push(rows[i].RowID);
	                    }
	                    var RowID=ids.join(',');
	                    if (RowID==""){
	                        PageBaseSetObj.editLocRow = undefined;
			                PageBaseSetObj.CureLinkLocDataGrid.datagrid("rejectChanges");
			                PageBaseSetObj.CureLinkLocDataGrid.datagrid("unselectAll");
			                return;
	                    }
	                    $.m({
	                        ClassName:"DHCDoc.DHCDocCure.Config",
	                        MethodName:"deleteArcCatLoc",
	                        'RowID':RowID,
	                        'Type':Type
	                    },function testget(value){
							if(value=="0"){
								//PageBaseSetObj.CureLinkLocDataGrid.datagrid('load');
								CureLinkLocDataGridLoad(Type,Rowid);
	           					PageBaseSetObj.CureLinkLocDataGrid.datagrid('unselectAll');
	           					$.messager.show({title:"提示",msg:"删除成功"});
							}else{
								$.messager.alert('提示',"删除失败:"+value,"warning");
							}
							PageBaseSetObj.editLocRow = undefined;
						});
	                }
	            });
	        } else {
	            $.messager.alert("提示", "请选择要删除的行", "info");
	        }
	     
	    }
	}];
	var CureLinkColumns=[[    
		{ field: 'RowID', title: '', width: 1, align: 'center', sortable: true,hidden:true
		},
		{ field: 'CureLocRowID', title: '', width: 1, align: 'center', sortable: true,hidden:true
		},
		{ field: 'LocDesc', title: '治疗科室名称', width: 300, align: 'center', sortable: true,
		  editor:{
				type:'combogrid',
				options:{
					//required: true,
					panelWidth:300,
					panelHeight:350,
					idField:'LocRowID',
					textField:'LocDesc',
					value:'',
					mode:'remote',
					pagination : true,
					rownumbers:true,
					collapsible:false,  
					fit: true,
					pageSize: 10,
					pageList: [10],
					//url:PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
					columns:[[
                        {field:'LocDesc',title:'名称',width:250,sortable:true},
	                    {field:'LocRowID',title:'LocRowID',width:120,sortable:true,hidden:true},
	                    {field:'selected',title:'LocRowID',width:120,sortable:true,hidden:true}
                     ]],
                     onShowPanel:function(){
                        var trObj = $HUI.combogrid(this);
						var object1 = trObj.grid();
                     	LoadItemData("",object1,Type,Rowid)
                     },
					 onSelect:function(rowIndex, rowData){
						 var rows=PageBaseSetObj.CureLinkLocDataGrid.datagrid("selectRow",PageBaseSetObj.editLocRow).datagrid("getSelected");
						 rows.CureLocRowID=rowData.LocRowID
					 },
					 onChange:function(Value,oldValue){
                		if (!Value) {
                    		 var rows=PageBaseSetObj.CureLinkLocDataGrid.datagrid("selectRow",PageBaseSetObj.editLocRow).datagrid("getSelected");
						 	 rows.CureLocRowID="";
                    	}
                	},
					 keyHandler:{
						up: function () {
			                //取得选中行
			                var selected = $(this).combogrid('grid').datagrid('getSelected');
			                if (selected) {
			                    //取得选中行的rowIndex
			                    var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
			                    //向上移动到第一行为止
			                    if (index > 0) {
			                        $(this).combogrid('grid').datagrid('selectRow', index - 1);
			                    }
			                } else {
			                    var rows = $(this).combogrid('grid').datagrid('getRows');
			                    $(this).combogrid('grid').datagrid('selectRow', rows.length - 1);
			                }
			             },
			             down: function () {
			               //取得选中行
			                var selected = $(this).combogrid('grid').datagrid('getSelected');
			                if (selected) {
			                    //取得选中行的rowIndex
			                    var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
			                    //向下移动到当页最后一行为止
			                    if (index < $(this).combogrid('grid').datagrid('getData').rows.length - 1) {
			                        $(this).combogrid('grid').datagrid('selectRow', index + 1);
			                    }
			                } else {
			                    $(this).combogrid('grid').datagrid('selectRow', 0);
			                }
			            },
						left: function () {
							return false;
			            },
						right: function () {
							return false;
			            },            
						enter: function () { 
						  //文本框的内容为选中行的的字段内容
			                var selected = $(this).combogrid('grid').datagrid('getSelected');  
						    if (selected) { 
						      $(this).combogrid("options").value=selected.ArcimDesc;
						      var rows=PageBaseSetObj.CureLinkLocDataGrid.datagrid("selectRow",PageBaseSetObj.editLocRow).datagrid("getSelected");
                              rows.CureLocRowID=selected.LocRowID
						    }
						    //
			                //选中后让下拉表格消失
			                $(this).combogrid('hidePanel');
							$(this).focus();
			            },
						query:function(q){
							var object1=new Object();
							object1=$(this)
							var trObj = $HUI.combogrid(this);
							var object1 = trObj.grid();

							if (this.AutoSearchTimeOut) {
								window.clearTimeout(this.AutoSearchTimeOut)
								this.AutoSearchTimeOut=window.setTimeout(function(){ LoadItemData(q,object1,Type,Rowid);},400); 
							}else{
								this.AutoSearchTimeOut=window.setTimeout(function(){ LoadItemData(q,object1,Type,Rowid);},400); 
							}
							$(this).combogrid("setValue",q);
						}
        			}
        		}
			 }
		  
		}
	 ]];
	PageBaseSetObj.CureLinkLocDataGrid=$('#tabCureLinkLoc').datagrid({  
		fit : true,
		//width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		//url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=FindArcCatCureLoc",
		loadMsg : '加载中..',  
		pagination : true,
		rownumbers : true,
		idField:"RowID",
		pageSize:10,
		pageList : [10,20],
		columns :CureLinkColumns,
		toolbar :CureLinkToolBar,
		onBeforeLoad:function(param){
			PageBaseSetObj.editLocRow = undefined;
			$('#tabCureLinkLoc').datagrid("unselectAll")
			param = $.extend(param,{Type:Type,RowID:Rowid});
		}
	});
	//CureLinkLocDataGridLoad(Type,Rowid)
}

function CureLinkLocDataGridLoad(Type,Rowid)
{
	PageBaseSetObj.CureLinkLocDataGrid.datagrid('reload');
	/*if(Rowid=="")return;
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		QueryName:"FindArcCatCureLoc",
		'Type':Type,
		'RowID':Rowid,
		Pagerows:PageBaseSetObj.CureLinkLocDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageBaseSetObj.CureLinkLocDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
		PageBaseSetObj.editLocRow = undefined;
	})*/
};
function LoadItemData(q,obj,Type,Val){
	var hospID=GetSelHospID();
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Config",
		QueryName:"FindLoc",
		'Loc':q,
		'CureFlag':"1",
		'Hospital':hospID,
		'Type':Type,
		'Val':Val,
		'OpenForAllHosp':"1",
		Pagerows:obj.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		obj.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
}

function GetSelHospID(){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if ((!HospID)||(HospID=="")) {
		HospID=session['LOGON.HOSPID'];
	}
	return HospID;
}

function CfgLimitHandle()
{
	var tblobj="";
	var LinkType="";
	var currTab =$('#tabs').tabs('getSelected'); 
	var index = $('#tabs').tabs('getTabIndex',currTab);
	if(index==0){
		tblobj=$("#itemCatList");
		LinkType="CAT";
	}else{
		tblobj=$("#arcItemList")
		LinkType="ITEM";
	}
	var RowID="";
	var rows = tblobj.datagrid("getSelections");
    if (rows.length > 0) {
		var ids = [];
		for (var i = 0; i < rows.length; i++) {
			ids.push(rows[i].CatLinkID);
		}
		var RowID=ids.join(',')
	}else{
		$.messager.alert('提示',"请选择一条记录!","info");
		return false;
	}
	if(RowID==""){
		$.messager.alert('提示',"获取行信息错误.","info");
		return false;
	}
    $("#dialog_CureCarePrvTp").css("display", ""); 
	var dialog = $HUI.dialog("#dialog_CureCarePrvTp",{ 
		autoOpen: false,
		height: 500,
		width: 400,
		modal: true
	});
	dialog.dialog( "open" );
	InitCarePrvTp(RowID,LinkType);	
}

function InitCarePrvTp(Rowid,Type){
		
	var CureLinkToolBar = [{
	    text: '增加',
	    iconCls: 'icon-add',
	    handler: function() {
	        if (PageBaseSetObj.editPrvTpRow != undefined) {
	            $.messager.alert("提示", "有正在编辑的行，请先点击保存", "info");
	            return;
	        }else{
		        if(PageBaseSetObj.CureCarePrvTpDataGrid.datagrid("getRows").length == 0 ){
					PageBaseSetObj.CureCarePrvTpDataGrid.datagrid("options").pageNumber = 1;
				}
	            PageBaseSetObj.CureCarePrvTpDataGrid.datagrid("insertRow", {
	                index: 0,
	                row: {
						RowID:"",
						TypeCode:"",
						TypeDesc:"",	
						CfgValue:"",
						CfgDesc:""						
					}
	            });
	            PageBaseSetObj.CureCarePrvTpDataGrid.datagrid("beginEdit", 0);
	            PageBaseSetObj.editPrvTpRow = 0;
	        }
	      
	    }
	},{
	    text: '保存',
	    iconCls: 'icon-save',
	    handler: function() {
	        if(PageBaseSetObj.editPrvTpRow==undefined){
				return false;
		  	}
	        var rows = PageBaseSetObj.CureCarePrvTpDataGrid.datagrid("getRows");
			if (rows.length > 0){
			   for (var i = 0; i < rows.length; i++) {
				   if(PageBaseSetObj.editPrvTpRow==i){
					   var rows=PageBaseSetObj.CureCarePrvTpDataGrid.datagrid("selectRow",PageBaseSetObj.editPrvTpRow).datagrid("getSelected");  
					   var editors = PageBaseSetObj.CureCarePrvTpDataGrid.datagrid('getEditors', PageBaseSetObj.editPrvTpRow); 
					   var CfgType=editors[0].target.combobox('getValue');
					   if ((!CfgType)||(rows.TypeCode=="")){
							$.messager.alert('提示',"请选择权限类型!","warning");
							return false;
			           }
					   var CfgValue=editors[1].target.combobox('getValue');
					   if ((!CfgValue)||(rows.CfgValue=="")){
							$.messager.alert('提示',"请选择权限名称!","warning");
							return false;
			            }
						$.m({
							ClassName:"DHCDoc.DHCDocCure.Config",
							MethodName:"insertCfg",
							MainID:Rowid,
							CfgType:CfgType,
							CfgValue:CfgValue,
							Type:Type
						},function testget(value){
							if(value=="0"){
								PageBaseSetObj.CureCarePrvTpDataGrid.datagrid("endEdit", PageBaseSetObj.editPrvTpRow);
								PageBaseSetObj.editPrvTpRow = undefined;
								PageBaseSetObj.CureCarePrvTpDataGrid.datagrid('reload').datagrid('unselectAll');
								$.messager.popover({type:"success",title:"提示",msg:"保存成功"});
							}else if(value=="-1"){
								$.messager.alert('提示',"保存失败,该记录已存在","warning");
								return false;
							}else if(value=="-2"){
								$.messager.alert('提示',"保存失败,请正确选择权限名称","warning");
								return false;
							}else{
								$.messager.alert('提示',"保存失败:"+value,"warning");
								return false;
							}
							PageBaseSetObj.editPrvTpRow = undefined;
							
						});
				   }
			   }
			}

	    }
	}, {
	    text: '取消编辑',
	    iconCls: 'icon-redo',
	    handler: function() {
	        PageBaseSetObj.editPrvTpRow = undefined;
	        PageBaseSetObj.CureCarePrvTpDataGrid.datagrid("rejectChanges");
	        PageBaseSetObj.CureCarePrvTpDataGrid.datagrid("unselectAll");
	    }
	},
	{
	    text: '删除',
	    iconCls: 'icon-remove',
	    handler: function() {
	        var rows = PageBaseSetObj.CureCarePrvTpDataGrid.datagrid("getSelections");
	        if (rows.length > 0) {
	            $.messager.confirm("提示", "你确定要删除吗?",
	            function(r) {
	                if (r) {
	                    var ids = [];
	                    for (var i = 0; i < rows.length; i++) {
	                        ids.push(rows[i].RowID);
	                    }
	                    var RowID=ids.join(',');
	                    if (RowID==""){
	                        PageBaseSetObj.editPrvTpRow = undefined;
			                PageBaseSetObj.CureCarePrvTpDataGrid.datagrid("rejectChanges");
			                PageBaseSetObj.CureCarePrvTpDataGrid.datagrid("unselectAll");
			                return;
	                    }
	                    $.m({
	                        ClassName:"DHCDoc.DHCDocCure.Config",
	                        MethodName:"deleteArcCatLoc",
	                        'RowID':RowID,
	                        'Type':Type
	                    },function testget(value){
							if(value=="0"){
								PageBaseSetObj.CureCarePrvTpDataGrid.datagrid('reload');
	           					PageBaseSetObj.CureCarePrvTpDataGrid.datagrid('unselectAll');
	           					$.messager.popover({type:"success",title:"提示",msg:"删除成功"});
							}else{
								$.messager.alert('提示',"删除失败:"+value,"warning");
							}
							PageBaseSetObj.editPrvTpRow = undefined;
						});
	                }
	            });
	        } else {
	            $.messager.alert("提示", "请选择要删除的行", "info");
	        }
	     
	    }
	}];
	var CureLinkColumns=[[    
		{ field: 'RowID', title: '', width: 1, align: 'center',hidden:true},
		{ field: 'TypeCode', title:'', width: 1,align: 'left', hidden:true},
		{ field: 'TypeDesc', title: '权限类型',width:120,  align: 'left', resizable: true,
			editor:{
				type:'combobox',
				options:{
					valueField:'Code',
					textField:'Desc',
					required:true,
					editable:false,
					panelHeight:'150',
					data:[{Code:"CP",Desc:"医护人员类型"},{Code:"U",Desc:"用户"}],
					onSelect:function(rowData){
						var rows=PageBaseSetObj.CureCarePrvTpDataGrid.datagrid("selectRow",PageBaseSetObj.editPrvTpRow).datagrid("getSelected");
						rows.TypeCode=rowData.Code;
						var obj=PageBaseSetObj.CureCarePrvTpDataGrid.datagrid('getEditor',{index:PageBaseSetObj.editPrvTpRow,field:'CfgDesc'})
						if(obj){
							var CareTarget=obj.target;
							CareTarget.combobox('clear');
							var url=$URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=FindCfgVal&Type="+rowData.Code+"&ResultSetType=array";
							CareTarget.combobox('reload',url);
							CareTarget.combobox("select","");
							rows.CfgValue="";
						}
					},
					onChange:function(newValue,oldValue){
						if (!newValue){
							var rows=PageBaseSetObj.CureCarePrvTpDataGrid.datagrid("selectRow",PageBaseSetObj.editPrvTpRow).datagrid("getSelected");
							rows.TypeCode="";
						}
					}
				}
			}
		},
		{ field: 'CfgValue', title: '', width: 1, align: 'center', hidden:true},
		{ field: 'CfgDesc', title: '权限类型名称', width: 200, align: 'center',
		  editor:{
				type:'combobox',
				options:{
					valueField:'RowId',
					textField:'Desc',
					required:true,
					editable:true,
					panelHeight:'300',
					url:$URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=FindCfgVal&ResultSetType=array&HospitalId="+GetSelHospID(),
					onBeforeLoad:function(param){
						param.HospitalId=GetSelHospID();
					},
					onSelect:function(rowData){
						var rows=PageBaseSetObj.CureCarePrvTpDataGrid.datagrid("selectRow",PageBaseSetObj.editPrvTpRow).datagrid("getSelected");
						if(typeof rowData !="undefined"){
							rows.CfgValue=rowData.RowId;
						}else{
							rows.CfgValue="";	
						}
					},
					filter: function(q, row){
						return (row["Desc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["Code"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
					},
					onChange:function(newValue,oldValue){
						if (!newValue){
							var rows=PageBaseSetObj.CureCarePrvTpDataGrid.datagrid("selectRow",PageBaseSetObj.editPrvTpRow).datagrid("getSelected");
							rows.CfgValue="";
						}
					}
				}
			}
		}
	 ]];
	PageBaseSetObj.CureCarePrvTpDataGrid=$('#tabCureCarePrvTp').datagrid({  
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=FindCfgInfo",
		loadMsg : '加载中..',  
		pagination : true,
		rownumbers : true,
		idField:"RowID",
		pageSize:10,
		pageList : [10,20],
		columns :CureLinkColumns,
		toolbar :CureLinkToolBar,
		onBeforeLoad:function(param){
			PageBaseSetObj.editPrvTpRow = undefined;
			$('#tabCureCarePrvTp').datagrid("unselectAll")
			param = $.extend(param,{Type:Type,RowID:Rowid,CfgType:"CP^U"});
		}
	});

}
function LoadCarePrvTpData(q,obj){
	obj.datagrid('reload');
}