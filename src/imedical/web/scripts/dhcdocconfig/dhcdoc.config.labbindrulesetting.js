var PageLogicObj={
	m_planTabDataGrid:"",
	editRow1:undefined, //方案编辑行索引
	m_LimitOrdTabDataGrid:"",
	editRow2:undefined, //限定医嘱编辑行索引
	m_unifyBloodFeeTabDataGrid:"",
	editRow3:undefined, //统一采血费维护编辑行索引
	m_SpecOrContainerListTabGrid:"",
	editRow4:undefined, //容器/标本编辑行索引
	m_tabSpecOrContainerItemListGrid:"",
	editRow5:undefined, //容器/标本关联费用索引
	m_LabPlanLimitLoc:"",
	m_BloodFlagTabDataGrid:"", //取血类型维护表格
	editRow6:undefined, //取血类型维护编辑行
	m_selLocStr:"",
	m_CopyToHospDr:"",
	m_BloodSugarOrdTabDataGrid:"",
	editRow7:undefined, //血糖医嘱维护编辑行,
	m_BloodSugarTabDataGrid:"",
	editRow8:undefined, //血糖分组维护编辑行,
}
$(function(){ 
    //初始化
	Init()
	InitEvent();
	//事件初始化
	//LoabAllLoc();
	InitTip();
});
function InitEvent(){
	$("#BPlanConfig").click(BPlanConfigClick);
	$('#tabs').tabs({    
	    onSelect:function(title,index){
		    //切换tab至方案费用维护,先调用保存方案规则限制
		    if (index==1) {
			    if (!SaveLabPlanLimit(false)) {
				    $('#tabs').tabs("select",0);
				}
			}
		}  
	});
	$("#O,#I,#E,#H").checkbox({
		onCheckChange:function(e,val){
			AdmTypeCheckChang();
		}
	});
	document.onkeydown = DocumentOnKeyDown;
}
function DocumentOnKeyDown(e){
   //防止在空白处敲退格键，界面自动回退到上一个界面
   if (!websys_cancelBackspace(e)) return false;
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
        e.preventDefault();   
    }  
}
function Init(){
	var hospComp = GenHospComp("Doc_BaseConfig_LabBindRuleSetting");
	hospComp.jdata.options.onSelect = function(e,t){
		$('#tabs').tabs("select",0);
        $("#PlanList").combobox('select',"").combobox('reload');
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitPlanList();
	}
	InitLabPlanAlgorithms();
}
function InitPlanList(){
	$("#PlanList").combobox({
    	valueField:'RowID',   
    	textField:'PlanName',
    	url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LabBindRuleSetting&QueryName=QueryLabPlan",
		editable:false,
		onBeforeLoad:function(param){
			param.HospId=GetHospId();
		},
		onSelect:function(record){
			if (record) {
				LoadLabPlanDetail(record["RowID"]);
				setTimeout(function(){
					var tab = $('#tabs').tabs('getSelected');
					var index = $('#tabs').tabs('getTabIndex',tab);
					if (index==1) {
						if (!SaveLabPlanLimit(false)) {
						    $('#tabs').tabs("select",0);
						}
					}
				},10000)
			}
		},
		loadFilter:function(data){
			return data['rows'];
		},
		onChange:function(newValue,oldValue){
			if (!newValue) {
				LoadLabPlanDetail("");
			}
		}
	});
}
function InitLabPlanAlgorithms(){
	$("#LabPlanAlgorithms").combobox({   
		valueField:'id',   
		textField:'text',
		editable:false,
		data:[{    
			    "id":1,    
			    "text":"通用算法",
			    "selected":true 
			}/*,{    
			    "id":2,    
			    "text":"血糖算法"   
			}*/]
	})
}
function InitplanTabDataGrid(){
	var toolbar=[
		{
			iconCls: 'icon-add ',
			text:'增加',
			handler: function(){
				PlanAddClick();
			}
		},{
			iconCls: 'icon-cancel',
			text:'删除',
			handler: function(){
				DeletePlan();
			}
		},{
			iconCls: 'icon-save',
			text:'保存',
			handler: function(){
				SaveLabPlan();
			}
		},{
			iconCls: 'icon-arrow-right-top',
			text:'取消编辑',
			handler: function(){
				CancelPanTabEdit();
			}
		},'-',{
			iconCls: 'icon-copy',
			text:'复制',
			handler: function(){
				ShowCopyLabPlanWin();
			}
		}
    ];
	var Columns=[[    
		{field:'PlanName',title:'方案名称',width:300,
			editor : {type : 'text'}
		}/*,
		{field:'PlanHosp',title:'所属院区',width:190,
			editor:{
				type:'combobox',  
				options:{
					//url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LocalConfig&QueryName=QryHosptial",
					url:$URL+"?ClassName=DHCDoc.Common.Hospital&QueryName=GetHospDataForCloud&tablename=Doc_BaseConfig_LabBindRuleSetting",
					valueField:'HOSPRowId', //hospID
					textField:'HOSPDesc', //hospDesc
					loadFilter:function(data){
					    return data['rows'];
					},
					onSelect:function(rec){
						var rows=PageLogicObj.m_planTabDataGrid.datagrid("selectRow",PageLogicObj.editRow1).datagrid("getSelected");
                        rows.PlanHospDr=rec.HOSPRowId;
					},
					onChange:function(newValue, oldValue){
						if (newValue==""){
							var rows=PageLogicObj.m_planTabDataGrid.datagrid("selectRow",PageLogicObj.editRow1).datagrid("getSelected");
                            rows.PlanHospDr="";
						}
					},
					onHidePanel:function(){
						var rows=PageLogicObj.m_planTabDataGrid.datagrid("selectRow",PageLogicObj.editRow1).datagrid("getSelected");
						if (!$.isNumeric($(this).combobox('getValue'))) return;
						rows.PlanHospDr=$(this).combobox('getValue');
					}
				 }
			}
		}*/
	]];
	var dataGrid=$("#planTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 20,
		pageList:[20,50,100],
		idField:'RowID',
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LabBindRuleSetting&QueryName=QueryLabPlan",
		columns :Columns,
		toolbar:toolbar,
		onBeforeLoad:function(param){
			param.HospId=GetHospId();
		},
		onLoadSuccess:function(data){
			PageLogicObj.m_selLocStr="";
			PageLogicObj.editRow1 = undefined;
			PageLogicObj.m_planTabDataGrid.datagrid('unselectAll');
		}/*,
		onSelect:function(index, row){
			LoadLabPlanDetail(row["RowID"]);
			setTimeout(function(){
				var tab = $('#tabs').tabs('getSelected');
				var index = $('#tabs').tabs('getTabIndex',tab);
				if (index==1) {
					if (!SaveLabPlanLimit(false)) {
					    $('#tabs').tabs("select",0);
					}
				}
			},10000)
		},
		onUnselect:function(index, row){
			LoadLabPlanDetail("");
		}*/,
		onDblClickRow:function(index, row){
			if ((PageLogicObj.editRow1!=undefined)&&(PageLogicObj.editRow1!=index)){
				$.messager.alert('提示',"只允许编辑一行数据");
				return
			}
			PageLogicObj.editRow1=index;
			PageLogicObj.m_planTabDataGrid.datagrid("beginEdit", index);
			var PlanNameObj=PageLogicObj.m_planTabDataGrid.datagrid('getEditor', {index:index,field:'PlanName'});
			$(PlanNameObj).focus();
		}
	});
	return dataGrid;
}
function PlanAddClick(){
	if ((PageLogicObj.editRow1!=="")&&(typeof PageLogicObj.editRow1!="undefined")){
		$.messager.alert("提示","存在未保存方案,请先保存!");
		return;
	}
	PageLogicObj.editRow1 = undefined;
    PageLogicObj.m_planTabDataGrid.datagrid('unselectAll');
    if (PageLogicObj.editRow1 != undefined) {
        return;
    }else{
        PageLogicObj.editRow1 = 0;
        PageLogicObj.m_planTabDataGrid.datagrid("insertRow", {
            index: 0,
            row: {RowID:""}
        });
        PageLogicObj.m_planTabDataGrid.datagrid("beginEdit", 0);
        var PlanNameObj=PageLogicObj.m_planTabDataGrid.datagrid('getEditor', {index:PageLogicObj.editRow1,field:'PlanName'});
		PlanNameObj.target.focus();
    }
}
function DeletePlan(){
	var rows = PageLogicObj.m_planTabDataGrid.datagrid("getSelections");
    if (rows.length > 0) {
	    $.messager.confirm("提示", "你确定要删除本方案吗?",
           function(r) {
                if (r) {
					var ids = [];
                    for (var i = 0; i < rows.length; i++) {
                        ids.push(rows[i].RowID);
                    }
                    var ID=ids.join(',');
                    var value=$.cm({
						ClassName:"DHCDoc.DHCDocConfig.LabBindRuleSetting",
						MethodName:"DeletePlan",
					   	Rowid:ID,
						dataType:"text"
					},false)
					if((value=="0")||(value=="100")){
				       $.messager.show({title:"提示",msg:"删除成功"});
				       PageLogicObj.m_planTabDataGrid.datagrid('unselectAll');
				       PageLogicObj.m_planTabDataGrid.datagrid("reload");
			        }else{
				       $.messager.alert('提示',"删除失败:"+value);
			        }
                }
         });
    }else {
        $.messager.alert("提示", "请选择要删除的方案!");
    }
}
function CancelPanTabEdit(){
	if ((PageLogicObj.editRow1!=="")&&(typeof PageLogicObj.editRow1 !="undefined")){
    	PageLogicObj.m_planTabDataGrid.datagrid("rejectChanges");
    	PageLogicObj.m_planTabDataGrid.datagrid("unselectAll");
    	PageLogicObj.editRow1 = undefined;
    }
}
function SaveLabPlan(){
	if (PageLogicObj.editRow1 == undefined){
		$.messager.alert("提示", "没有需要保存的方案!");
    	return false
    }
    var editors = PageLogicObj.m_planTabDataGrid.datagrid('getEditors', PageLogicObj.editRow1); 
	var rows = PageLogicObj.m_planTabDataGrid.datagrid("selectRow",PageLogicObj.editRow1).datagrid("getSelected");
	var Rowid=rows.RowID;
	if (Rowid==undefined){Rowid=""};
	var LabPlanName=editors[0].target.val();
	if (LabPlanName=="") {
		$.messager.alert('提示',"请填写方案名称!");
		return false;
	}
	var LabPlanHospDr=GetHospId();
	var saveStr=Rowid+"^"+LabPlanName+"^"+LabPlanHospDr;
	var value=$.cm({
		ClassName:"DHCDoc.DHCDocConfig.LabBindRuleSetting",
		MethodName:"SavePlan",
	   	saveStr:saveStr,
		dataType:"text"
	},false)
	if(value.split("^")[0]=="0"){
		$.messager.popover({msg: '保存成功！',type:'success'});
		PageLogicObj.m_planTabDataGrid.datagrid("reload");
	}else if(value.split("^")[0]=="-101"){
		$.messager.alert('提示',"保存失败,记录重复!");
		return false;
	}else{
		$.messager.alert('提示',"保存失败:"+value);
		return false;
	}
}
function LoadLabPlanDetail(PlanRowId)
{
	LoadLabPlanLimit(PlanRowId);
	if (PageLogicObj.m_LimitOrdTabDataGrid=="") {
		PageLogicObj.m_LimitOrdTabDataGrid=InitLabPlanLimitDataGrid()
	}else{
		LoadLimitOrdTabDataGrid(PlanRowId);
	}
	InitComboBloodFlag();
	if (PageLogicObj.m_unifyBloodFeeTabDataGrid==""){
		PageLogicObj.m_unifyBloodFeeTabDataGrid=InitunifyBloodFeeTabDataGrid();
	}else{
		PageLogicObj.m_unifyBloodFeeTabDataGrid.datagrid("reload");
	}
	if (PageLogicObj.m_SpecOrContainerListTabGrid=="") {
		PageLogicObj.m_SpecOrContainerListTabGrid=InitSpecOrContainerListTabGrid();
	}else{
		PageLogicObj.m_SpecOrContainerListTabGrid.datagrid("reload");
	}
}
function InitLabPlanLimitLoc(){
	return $('#LabPlanLimitLoc').datagrid({
		autoRowHeight:false,
		border:false,
	    url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LabBindRuleSetting&QueryName=LookUpAllLoc", 
	    idField:'rowid',
	    columns:[[    
	    	{field:'rowid',title:'',checkbox:true},    
	        {field:'Desc',title:'科室名称',width:230}    
	    ]],
	    onBeforeLoad:function(param){
		    $('#LabPlanLimitLoc').datagrid("uncheckAll");
			var LabPlanHospId=GetHospId();
			var AdmTypeStr="";
			for (var i=0;i<$(".admtype").length;i++) {
				var AdmType=$(".admtype")[i].id;
				var checked=$("#"+AdmType).checkbox("getValue");
				if (checked) {
					if (AdmTypeStr=="") AdmTypeStr=AdmType;
					else   AdmTypeStr=AdmTypeStr+"^"+AdmType;
				}
			}
			param = $.extend(param,{curHospId:LabPlanHospId,AdmTypeStr:AdmTypeStr,rows:99999});
		},
		onLoadSuccess:function(data){
			for (var i=0;i<PageLogicObj.m_selLocStr.split("^").length;i++) {
				var LocId=PageLogicObj.m_selLocStr.split("^")[i];
				if (LocId=="") continue;
				var index=PageLogicObj.m_LabPlanLimitLoc.datagrid('getRowIndex',LocId);
				if (index>=0) {
					PageLogicObj.m_LabPlanLimitLoc.datagrid('selectRow',index);
				}
			}
		}
	});
}
function LoadLabPlanLimit(PlanRowId){
	$(".admtype").checkbox("setValue",false);
	$("input[id$='sex']").checkbox("uncheck");
	if (PlanRowId=="") {
		$("#AgeFrom,#AgeTo").val("");
		return;
	}
	$.m({
		ClassName:"DHCDoc.DHCDocConfig.LabBindRuleSetting",
		MethodName:"GetLabPlanLimitStr",
		PlanRowId:PlanRowId
	},function(data){
		var dataArr=data.split(String.fromCharCode(1));
		var LimitLocStr=dataArr[0];
		PageLogicObj.m_selLocStr=LimitLocStr;
		if (LimitLocStr!="") {
			var LimitAdmTypeStr=dataArr[1];
			var LimitAgeFrom=dataArr[2];
			var LimitAgeTo=dataArr[3];
			var LimitSexStr=dataArr[4];
			var LabPlanAlgorithms=dataArr[5];
			if (LabPlanAlgorithms=="") {
				LabPlanAlgorithms=1;
			}
			$("#LabPlanAlgorithms").combobox('select',LabPlanAlgorithms);
			$("#AgeFrom").val(LimitAgeFrom);
			$("#AgeTo").val(LimitAgeTo);
			for (var i=0;i<LimitAdmTypeStr.split("^").length;i++) {
				var AdmType=LimitAdmTypeStr.split("^")[i];
				if (AdmType=="") continue;
				$("#"+AdmType).checkbox("setValue",true);
			}
			for (var i=0;i<LimitSexStr.split("^").length;i++) {
				var SexId=LimitSexStr.split("^")[i];
				if (SexId=="") continue;
				$("#"+SexId+"_sex").checkbox("check");
			}
			/*var data=PageLogicObj.m_LabPlanLimitLoc.datagrid('getRows');
			for (var i=0;i<LimitLocStr.split("^").length;i++) {
				var LocId=LimitLocStr.split("^")[i];
				if (LocId=="") continue;
				var index=PageLogicObj.m_LabPlanLimitLoc.datagrid('getRowIndex',LocId);
				PageLogicObj.m_LabPlanLimitLoc.datagrid('selectRow',index);
			}*/
			AdmTypeCheckChang();
		}else{
			$("input[id$='sex']").checkbox("check");
			$("#AgeFrom").val(0);
			$("#AgeTo").val(176);
		}
	})
}
/*function LocSelChange(e) {
	var id=e.target.id;
	if ($("#"+id).hasClass("li-active")) {
		$("#"+id).removeClass("li-active");
	}else{
		$("#"+id).addClass("li-active");
	}
}*/
function SaveLabPlanLimit(alertFlag){
	if (typeof alertFlag=="undefined") alertFlag=true;
	var PlanRowId=$("#PlanList").combobox('getValue');
	if (PlanRowId=="") {
		$.messager.alert('提示',"请先选择方案!");
		return false;
	}
	var AdmTypeStr="";
	for (var i=0;i<$(".admtype").length;i++) {
		var AdmType=$(".admtype")[i].id;
		var checked=$("#"+AdmType).checkbox("getValue");
		if (checked) {
			if (AdmTypeStr=="") AdmTypeStr=AdmType;
			else   AdmTypeStr=AdmTypeStr+"^"+AdmType;
		}
	}
	if (AdmTypeStr=="") {
		$.messager.alert('提示',"请勾选限定【就诊类型】!");
		return false;
	}
	var SexStr="";
	var _$sex=$("input[id$='sex']");
	for (var i=0;i<_$sex.length;i++) {
		var id=_$sex[i].id;
		var checked=$("#"+id).checkbox("getValue");
		if (checked) {
			var sexDr=id.split("_")[0];
			if (SexStr=="") SexStr=sexDr;
			else   SexStr=SexStr+"^"+sexDr;
		}
	}
	if (SexStr=="") {
		$.messager.alert('提示',"请勾选限定【性别】!");
		return false;
	}
	var LimitAgeFrom=$("#AgeFrom").val();
	if (LimitAgeFrom=="") {
		$.messager.alert('提示',"请输入最小限制年龄!","info",function(){
			$("#AgeFrom").focus();
		});
		return false;
	}
	var LimitAgeTo=$("#AgeTo").val();
	if (LimitAgeTo=="") {
		$.messager.alert('提示',"请输入最大限制年龄!","info",function(){
			$("#AgeTo").focus();
		});
		return false;
	}
	var r = /^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/;
	if ((LimitAgeFrom!="")&&(!r.test(LimitAgeFrom))){
		$.messager.alert('提示',"最小年龄应为大于0的数字!");
		return false;
	}
	if ((LimitAgeTo!="")&&(!r.test(LimitAgeTo))){
		$.messager.alert('提示',"最大年龄应为大于0的数字!");
		return false;
	}
	if ((+LimitAgeFrom>176)||(+LimitAgeTo>176)){
		$.messager.alert('提示',"年龄最大值不能超过176!");
		return false;
	}
	var LocStr="";
	/*var _$loc=$(".li-active");
	for (var i=0;i<_$loc.length;i++) {
		var id=_$loc[i].id;
		var LocDr=id.split("_")[0];
		if (LocStr=="") LocStr=LocDr;
		else   LocStr=LocStr+"^"+LocDr;
	}*/
	var rows=PageLogicObj.m_LabPlanLimitLoc.datagrid("getSelections");
	for (var i=0;i<rows.length;i++){
		var LocDr=rows[i].rowid;
		if (LocStr=="") LocStr=LocDr;
		else   LocStr=LocStr+"^"+LocDr;
	}
	if (LocStr=="") {
		$.messager.alert('提示',"请选择限定开单科室!");
		return false;
	}
	var LabPlanAlgorithms=$("#LabPlanAlgorithms").combobox('getValue');
	var saveStr=LocStr+String.fromCharCode(1)+AdmTypeStr+String.fromCharCode(1)+LimitAgeFrom+String.fromCharCode(1)+LimitAgeTo+String.fromCharCode(1)+SexStr+String.fromCharCode(1)+LabPlanAlgorithms;
	var saveLimitOrdStr="";
	if (PageLogicObj.editRow2 != undefined){
		var editors = PageLogicObj.m_LimitOrdTabDataGrid.datagrid('getEditors', PageLogicObj.editRow2); 
		var rows = PageLogicObj.m_LimitOrdTabDataGrid.datagrid("selectRow",PageLogicObj.editRow2).datagrid("getSelected");
		var Rowid=rows.RowID;
		if (Rowid==undefined){Rowid=""};
		var ARCIMDR=rows.ARCIMDR;
		if (ARCIMDR==undefined){ARCIMDR=""};
		if (ARCIMDR=="") {
			$.messager.alert('提示',"请选择检验医嘱项!");
			return false;
		}
		var saveLimitOrdStr=Rowid+"^"+ARCIMDR;
    }
	var rtn=$.m({
		ClassName:"DHCDoc.DHCDocConfig.LabBindRuleSetting",
		MethodName:"SaveLabPlanLimit",
		PlanRowId:PlanRowId,
		saveStr:saveStr,
		saveLimitOrdStr:saveLimitOrdStr
	},false)
	if (rtn==0) {
		if (alertFlag==true) {
			$.messager.popover({msg: '保存成功!',type:'success'});
		}
		PageLogicObj.m_LimitOrdTabDataGrid.datagrid("reload");
	}else if(rtn.split("^")[0]=="101"){
		$.messager.alert("提示", "保存失败!此方案和方案【"+rtn.split("^")[1]+"】中的绑定限定规则冲突!请核实后再操作!");
		return false;
	}else{
		$.messager.alert("提示", "方案限定规则保存失败!"+rtn);
		return false;
	}
	return true;
}
function InitLabPlanLimitDataGrid(){
	var toolbar=[
		{
			iconCls: 'icon-add ',
			text:'增加',
			handler: function(){
				AddLimitOrd();
			}
		},{
			iconCls: 'icon-cancel',
			text:'删除',
			handler: function(){
				DeleteLimitOrd();
			}
		}/*,{
			iconCls: 'icon-save',
			text:'保存',
			handler: function(){
				SaveLimitOrd();
			}
		}*/,{
			iconCls: 'icon-arrow-right-top',
			text:'取消编辑',
			handler: function(){
				CancelLimitOrdTabEdit();
			}
		}
    ];
	var Columns=[[    
		{field:'ArcimDesc',title:'医嘱名称',width:230,
			editor:{
          		type:'combogrid',
                options:{
                    enterNullValueClear:false,
					panelWidth:450,
					panelHeight:350,
					delay:500,
					idField:'ArcimRowID',
					textField:'ArcimDesc',
					value:'',//缺省值 
					mode:'remote',
					pagination : true,//是否分页   
					rownumbers:true,//序号   
					collapsible:false,//是否可折叠的   
					fit: true,//自动大小   
					pageSize: 10,//每页显示的记录条数，默认为10   
					pageList: [10],//可以设置每页记录条数的列表  
					url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem&TYPE=L", //PUBLIC_CONSTANT.URL.QUERY_GRID_URL
                    columns:[[
                        {field:'ArcimDesc',title:'名称',width:310,sortable:true},
		                {field:'ArcimRowID',title:'ID',width:100,sortable:true},
		                {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
                     ]],
					onSelect: function (rowIndex, rowData){
						var rows=PageLogicObj.m_LimitOrdTabDataGrid.datagrid("selectRow",PageLogicObj.editRow2).datagrid("getSelected");
						rows.ARCIMDR=rowData.ArcimRowID
					},
					onClickRow: function (rowIndex, rowData){
						var rows=PageLogicObj.m_LimitOrdTabDataGrid.datagrid("selectRow",PageLogicObj.editRow2).datagrid("getSelected");
						rows.ARCIMDR=rowData.ArcimRowID
					},
					onLoadSuccess:function(data){
						var CurrentOrdName=$(this).combogrid('getValue');
						if(CurrentOrdName!=""){
							if (CurrentOrdName.indexOf("||")>=0){
								$(this).combogrid("setValue","");
								$(this).combo("setText", "")
							}
						}
						$(this).next('span').find('input').focus();
					},
					onBeforeLoad:function(param){
						if (param['q']) {
							var desc=param['q'];
						}
						var LabPlanHospId=GetHospId();
						param = $.extend(param,{Alias:desc,HospId:LabPlanHospId});
					}
        		}
			  }
		}/*,
		{field:'LimitThisPlan',title:'仅限使用此方案',width:110,
			editor:{
				type:'icheckbox',  
				options:{
					 on : 'Y',
                     off : ''
				}
			},
			styler: function(value,row,index){
 				if (value=="Y"){
	 				return 'color:#21ba45;';
	 			}else{
		 			return 'color:#f16e57;';
		 		}
		   },
 		   formatter:function(value,record){
	 			if (value=="Y") return "是";
	 			else  return "否";
	 	   }
		}*/
	]];
	var dataGrid=$("#LimitOrdTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 20,
		pageList:[20,50,100],
		idField:'RowID',
		columns :Columns,
		toolbar:toolbar,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LabBindRuleSetting&QueryName=QueryLabPlanOrdLimit",
		onLoadSuccess:function(data){
			PageLogicObj.editRow2 = undefined;
			PageLogicObj.m_LimitOrdTabDataGrid.datagrid('unselectAll');
		},
		onBeforeLoad:function(param){
			var PlanRowId=$("#PlanList").combobox('getValue');
			param = $.extend(param,{PlanRowId:PlanRowId});
		},
		onDblClickRow:function(index, row){
			if ((PageLogicObj.editRow2!=undefined)&&(PageLogicObj.editRow2!=index)){
				$.messager.alert('提示',"只允许编辑一行数据");
				return
			}
			PageLogicObj.editRow2=index;
			PageLogicObj.m_LimitOrdTabDataGrid.datagrid("beginEdit", index);
			var ArcimDescObj=PageLogicObj.m_LimitOrdTabDataGrid.datagrid('getEditor', {index:index,field:'ArcimDesc'});
			$(ArcimDescObj).next('span').find('input').focus();
		}
	});
	return dataGrid;
}
function LoadLimitOrdTabDataGrid(){
	PageLogicObj.m_LimitOrdTabDataGrid.datagrid("reload");
}
function CancelLimitOrdTabEdit(){
	if ((PageLogicObj.editRow2!=="")&&(typeof PageLogicObj.editRow2 !="undefined")){
    	PageLogicObj.m_LimitOrdTabDataGrid.datagrid("rejectChanges");
    	PageLogicObj.m_LimitOrdTabDataGrid.datagrid("unselectAll");
    	PageLogicObj.editRow2 = undefined;
    }
}
function AddLimitOrd(){
	if ((PageLogicObj.editRow2!=="")&&(typeof PageLogicObj.editRow2!="undefined")){
		$.messager.alert("提示","存在未保存医嘱,请先保存!");
		return;
	}
	PageLogicObj.editRow2 = undefined;
    PageLogicObj.m_LimitOrdTabDataGrid.datagrid('unselectAll');
    if (PageLogicObj.editRow2 != undefined) {
        return;
    }else{
        PageLogicObj.editRow2 = 0;
        PageLogicObj.m_LimitOrdTabDataGrid.datagrid("insertRow", {
            index: 0,
            row: {}
        });
        PageLogicObj.m_LimitOrdTabDataGrid.datagrid("beginEdit", 0);
        var ArcimDescObj=PageLogicObj.m_LimitOrdTabDataGrid.datagrid('getEditor', {index:PageLogicObj.editRow2,field:'ArcimDesc'});
		$(ArcimDescObj).next('span').find('input').focus();
    }
}
function DeleteLimitOrd(){
	var rows = PageLogicObj.m_LimitOrdTabDataGrid.datagrid("getSelections");
    if (rows.length > 0) {
	    $.messager.confirm("提示", "你确定要删除本医嘱吗?",
           function(r) {
                if (r) {
					var ids = [];
                    for (var i = 0; i < rows.length; i++) {
                        ids.push(rows[i].RowID);
                    }
                    var ID=ids.join(',');
                    if (ID==""){
	                    CancelLimitOrdTabEdit();
	                    return;
	                }
                    var value=$.cm({
						ClassName:"DHCDoc.DHCDocConfig.LabBindRuleSetting",
						MethodName:"DelLabPlanOrdLimit",
					   	rowId:ID,
						dataType:"text"
					},false)
					if((value=="0")||(value=="-100")){
				       $.messager.show({title:"提示",msg:"删除成功"});
				       PageLogicObj.m_LimitOrdTabDataGrid.datagrid('unselectAll');
				       PageLogicObj.m_LimitOrdTabDataGrid.datagrid("reload");
			        }else if(+value=="101"){
				        $.messager.alert('提示',"删除失败!此方案和方案【"+rtn.split("^")[1]+"】中的绑定限定规则冲突!请核实后再操作!");
				    }else{
				       $.messager.alert('提示',"删除失败!"+value);
			        }
                }
         });
    }else {
        $.messager.alert("提示", "请选择要删除的医嘱!");
    }
}
function SaveLimitOrd(){
	var rows = PageLogicObj.m_planTabDataGrid.datagrid("getSelections");
    if (rows.length > 0) {
	    var PlanRowId=rows[0]["RowID"];
		if (PlanRowId=="") {
			$.messager.alert('提示',"请选择已保存方案!");
			return false;
		}
	}else{
		$.messager.alert("提示", "请先选择方案!");
    	return false
	}
	if (PageLogicObj.editRow2 == undefined){
		$.messager.alert("提示", "没有需要保存的医嘱!");
    	return false
    }
    var editors = PageLogicObj.m_LimitOrdTabDataGrid.datagrid('getEditors', PageLogicObj.editRow2); 
	var rows = PageLogicObj.m_LimitOrdTabDataGrid.datagrid("selectRow",PageLogicObj.editRow2).datagrid("getSelected");
	var Rowid=rows.RowID;
	if (Rowid==undefined){Rowid=""};
	var ARCIMDR=rows.ARCIMDR;
	if (ARCIMDR==undefined){ARCIMDR=""};
	if (ARCIMDR=="") {
		$.messager.alert('提示',"请选择检验医嘱项!");
		return false;
	}
	//var LimitPlanFlag=editors[1].target.is(':checked')?"Y":"";
	var saveStr=Rowid+"^"+ARCIMDR; //+"^"+LimitPlanFlag;
	var value=$.cm({
		ClassName:"DHCDoc.DHCDocConfig.LabBindRuleSetting",
		MethodName:"SaveLabPlanOrdLimit",
		PlanRowId:PlanRowId,
	   	saveStr:saveStr,
		dataType:"text"
	},false)
	if(value.split("^")[0]=="0"){
		$.messager.popover({msg: '保存成功！',type:'success'});
		PageLogicObj.m_LimitOrdTabDataGrid.datagrid("reload");
	}else if(value.split("^")[0]=="-101"){
		$.messager.alert('提示',"保存失败,记录重复!");
		return false;
	}else{
		$.messager.alert('提示',"保存失败:"+value);
		return false;
	}
}
function InitunifyBloodFeeTabDataGrid(){
	var toolbar=[
		{
			iconCls: 'icon-add ',
			text:'增加',
			handler: function(){
				AddInifyBloodFee();
			}
		},{
			iconCls: 'icon-cancel',
			text:'删除',
			handler: function(){
				DeleteUnifyBloodFeeOrd();
			}
		},{
			iconCls: 'icon-save',
			text:'保存',
			handler: function(){
				SaveUnifyBloodFeeOrd();
			}
		},{
			iconCls: 'icon-arrow-right-top',
			text:'取消编辑',
			handler: function(){
				CancelInifyBloodFeeTabEdit();
			}
		}/*,'-',{
			iconCls: 'icon-batch-cfg',
			text:'取血类型维护',
			handler: function(){
				BloodFlagOpen();
			}
		}*/
    ];
	var Columns=[[    
		{field:'ArcimDesc',title:'医嘱名称',width:220,
			editor:{
          		type:'combogrid',
                options:{
                    enterNullValueClear:false,
					panelWidth:450,
					panelHeight:350,
					delay:500,
					idField:'ArcimRowID',
					textField:'ArcimDesc',
					value:'',//缺省值 
					mode:'remote',
					pagination : true,//是否分页   
					rownumbers:true,//序号   
					collapsible:false,//是否可折叠的   
					fit: true,//自动大小   
					pageSize: 10,//每页显示的记录条数，默认为10   
					pageList: [10],//可以设置每页记录条数的列表  
					url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
                    columns:[[
                        {field:'ArcimDesc',title:'名称',width:310,sortable:true},
		                {field:'ArcimRowID',title:'ID',width:100,sortable:true},
		                {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
                     ]],
					onSelect: function (rowIndex, rowData){
						var rows=PageLogicObj.m_unifyBloodFeeTabDataGrid.datagrid("selectRow",PageLogicObj.editRow3).datagrid("getSelected");
						rows.ARCIMDR=rowData.ArcimRowID
					},
					onClickRow: function (rowIndex, rowData){
						var rows=PageLogicObj.m_unifyBloodFeeTabDataGrid.datagrid("selectRow",PageLogicObj.editRow3).datagrid("getSelected");
						rows.ARCIMDR=rowData.ArcimRowID
					},
					onLoadSuccess:function(data){
						var CurrentOrdName=$(this).combogrid('getValue');
						if(CurrentOrdName!=""){
							if (CurrentOrdName.indexOf("||")>=0){
								$(this).combogrid("setValue","");
								$(this).combo("setText", "")
							}
						}
						$(this).next('span').find('input').focus();
					},
					onBeforeLoad:function(param){
						if (param['q']) {
							var desc=param['q'];
						}else{
							//return false;
						}
						var LabPlanHospId=GetHospId();
						param = $.extend(param,{Alias:desc,HospId:LabPlanHospId});
					}
        		}
			  }
		},
		{field:'Qty',title:'数量',width:110,
			editor:{
				type:'text',  
				options:{
				}
			}
		},
		{field:'IsRepeatAdd',title:'是否重复加收',width:110,
			editor:{
				type:'icheckbox',  
				options:{
					 on : 'Y',
                     off : ''
				}
			},
			styler: function(value,row,index){
 				if (value=="Y"){
	 				return 'color:#21ba45;';
	 			}else{
		 			return 'color:#f16e57;';
		 		}
		   },
 		   formatter:function(value,record){
	 			if (value=="Y") return "是";
	 			else  return "否";
	 	   }
		}
	]];
	var dataGrid=$("#unifyBloodFee").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 20,
		pageList:[20,50,100],
		idField:'RowID',
		columns :Columns,
		toolbar:toolbar,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LabBindRuleSetting&QueryName=QueryLabPlanBindOrdFee",
		onLoadSuccess:function(data){
			PageLogicObj.editRow3 = undefined;
			PageLogicObj.m_unifyBloodFeeTabDataGrid.datagrid('unselectAll');
		},
		onBeforeLoad:function(param){
			var PlanRowId=$("#PlanList").combobox('getValue');
			var LabPlanBindType=$("#Combo_BloodFlag").combobox('getValue');
			LabPlanBindType="BloodType_"+LabPlanBindType;
			param = $.extend(param,{PlanRowId:PlanRowId,LabPlanBindType:LabPlanBindType});
		},
		onDblClickRow:function(index, row){
			if ((PageLogicObj.editRow3!=undefined)&&(PageLogicObj.editRow3!=index)){
				$.messager.alert('提示',"只允许编辑一行数据");
				return
			}
			PageLogicObj.editRow3=index;
			PageLogicObj.m_unifyBloodFeeTabDataGrid.datagrid("beginEdit", index);
			var ArcimDescObj=PageLogicObj.m_unifyBloodFeeTabDataGrid.datagrid('getEditor', {index:index,field:'ArcimDesc'});
			$(ArcimDescObj).next('span').find('input').focus();
		}
	});
	return dataGrid;
}
function CancelInifyBloodFeeTabEdit(){
	if ((PageLogicObj.editRow3!=="")&&(typeof PageLogicObj.editRow3 !="undefined")){
    	PageLogicObj.m_unifyBloodFeeTabDataGrid.datagrid("rejectChanges");
    	PageLogicObj.m_unifyBloodFeeTabDataGrid.datagrid("unselectAll");
    	PageLogicObj.editRow3 = undefined;
    }
}
function AddInifyBloodFee(){
	var LabPlanBindType=$("#Combo_BloodFlag").combobox('getValue');
	if (LabPlanBindType=="") {
		$.messager.alert("提示", "请先选择取血类型!");
    	return false
	}
	if ((PageLogicObj.editRow3!=="")&&(typeof PageLogicObj.editRow3!="undefined")){
		$.messager.alert("提示","存在未保存医嘱,请先保存!");
		return;
	}
	PageLogicObj.editRow3 = undefined;
    PageLogicObj.m_unifyBloodFeeTabDataGrid.datagrid('unselectAll');
    if (PageLogicObj.editRow3 != undefined) {
        return;
    }else{
        PageLogicObj.editRow3 = 0;
        PageLogicObj.m_unifyBloodFeeTabDataGrid.datagrid("insertRow", {
            index: 0,
            row: {}
        });
        PageLogicObj.m_unifyBloodFeeTabDataGrid.datagrid("beginEdit", 0);
        var ArcimDescObj=PageLogicObj.m_unifyBloodFeeTabDataGrid.datagrid('getEditor', {index:PageLogicObj.editRow3,field:'ArcimDesc'});
		$(ArcimDescObj).next('span').find('input').focus();
    }
}
function DeleteUnifyBloodFeeOrd(){
	var rows = PageLogicObj.m_unifyBloodFeeTabDataGrid.datagrid("getSelections");
    if (rows.length > 0) {
	    $.messager.confirm("提示", "你确定要删除本医嘱吗?",
           function(r) {
                if (r) {
					var ids = [];
                    for (var i = 0; i < rows.length; i++) {
                        ids.push(rows[i].RowID);
                    }
                    var ID=ids.join(',');
                    if (ID==""){
	                    CancelInifyBloodFeeTabEdit();
	                    return;
	                }
                    var value=$.cm({
						ClassName:"DHCDoc.DHCDocConfig.LabBindRuleSetting",
						MethodName:"DelLabPlanBindOrdFee",
					   	rowId:ID,
						dataType:"text"
					},false)
					if((value=="0")||(value=="-100")){
				       $.messager.show({title:"提示",msg:"删除成功"});
				       PageLogicObj.m_unifyBloodFeeTabDataGrid.datagrid('unselectAll');
				       PageLogicObj.m_unifyBloodFeeTabDataGrid.datagrid("reload");
			        }else{
				       $.messager.alert('提示',"删除失败:"+value);
			        }
                }
         });
    }else {
        $.messager.alert("提示", "请选择要删除的医嘱!");
    }
}
function SaveUnifyBloodFeeOrd(){
	var PlanRowId=$("#PlanList").combobox('getValue');
	if (PlanRowId==""){
		$.messager.alert("提示", "请先选择方案!");
    	return false
	}
	var LabPlanBindType=$("#Combo_BloodFlag").combobox('getValue');
	if (LabPlanBindType=="") {
		$.messager.alert("提示", "请先选择取血类型!");
    	return false
	}
	LabPlanBindType="BloodType_"+LabPlanBindType;
			
	if (PageLogicObj.editRow3 == undefined){
		$.messager.alert("提示", "没有需要保存的医嘱!");
    	return false
    }
    var editors = PageLogicObj.m_unifyBloodFeeTabDataGrid.datagrid('getEditors', PageLogicObj.editRow3); 
	var rows = PageLogicObj.m_unifyBloodFeeTabDataGrid.datagrid("selectRow",PageLogicObj.editRow3).datagrid("getSelected");
	var Rowid=rows.RowID;
	if (Rowid==undefined){Rowid=""};
	var ARCIMDR=rows.ARCIMDR;
	if (ARCIMDR==undefined){ARCIMDR=""};
	if (ARCIMDR=="") {
		$.messager.alert('提示',"请选择医嘱项!");
		return false;
	}
	var Qty=editors[1].target.val();
	if (Qty==""){
		$.messager.alert('提示',"请填写数量!");
		return false;
	}
	var r = /^\+?[1-9][0-9]*$/;
	if(!r.test(Qty)){
		$.messager.alert('提示',"数量只能为正整数!");
		return false;
	}
	var IsRepeatAdd=editors[2].target.is(':checked')?"Y":"N";
	var saveStr=Rowid+"^"+ARCIMDR+"^"+Qty+"^"+LabPlanBindType+"^"+IsRepeatAdd;
	var value=$.cm({
		ClassName:"DHCDoc.DHCDocConfig.LabBindRuleSetting",
		MethodName:"SaveLabPlanBindOrdFee",
		PlanRowId:PlanRowId,
	   	saveStr:saveStr,
		dataType:"text"
	},false)
	if(value.split("^")[0]=="0"){
		$.messager.popover({msg: '保存成功！',type:'success'});
		PageLogicObj.m_unifyBloodFeeTabDataGrid.datagrid("reload");
	}else if(value.split("^")[0]=="-101"){
		$.messager.alert('提示',"保存失败,记录重复!");
		return false;
	}else{
		$.messager.alert('提示',"保存失败:"+value);
		return false;
	}
}
function InitSpecOrContainerListTabGrid(){
	var toolbar=[
		{
			iconCls: 'icon-save',
			text:'保存',
			handler: function(){
				SaveBloodFlag();
			}
		},{
			iconCls: 'icon-arrow-right-top',
			text:'取消编辑',
			handler: function(){
				if ((PageLogicObj.editRow4!=="")&&(typeof PageLogicObj.editRow4 !="undefined")){
			    	PageLogicObj.m_SpecOrContainerListTabGrid.datagrid("rejectChanges");
			    	PageLogicObj.m_SpecOrContainerListTabGrid.datagrid("unselectAll");
			    	PageLogicObj.editRow4 = undefined;
			    	if (PageLogicObj.m_tabSpecOrContainerItemListGrid!="") {
						PageLogicObj.m_tabSpecOrContainerItemListGrid.datagrid("reload");
					}
			    }
			}
		}
    ];
	var Columns=[[    
		{field:'Desc',title:'容器/标本',width:120},
		{field:'BloodFlagDesc',title:'取血类型',width:110,
			editor:{
				type:'text',  
				type:'combobox',  
					options:{
						valueField:'rowid',
						textField:'Desc',
						url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LabBindRuleSetting&QueryName=FindBloodType&paraActive=Y",
						loadFilter:function(data){
							return data['rows'];
						},
						onSelect:function(rec){
							var rows=PageLogicObj.m_SpecOrContainerListTabGrid.datagrid("selectRow",PageLogicObj.editRow4).datagrid("getSelected");
                            rows.BloodFlag=rec.rowid;
						},
						onChange:function(newValue, oldValue){
							if (newValue==""){
								var rows=PageLogicObj.m_SpecOrContainerListTabGrid.datagrid("selectRow",PageLogicObj.editRow4).datagrid("getSelected");
                                rows.BloodFlag="";
							}
						},
						onHidePanel:function(){
							var rows=PageLogicObj.m_SpecOrContainerListTabGrid.datagrid("selectRow",PageLogicObj.editRow4).datagrid("getSelected");
							if (!$.isNumeric($(this).combobox('getValue'))) return;
							rows.BloodFlag=$(this).combobox('getValue');
						}
				}
			},
			formatter: function(value,row,index){
				if (row.BloodActive !="Y"){
					return "<span style='color:red;'>已禁用</span>"+value; //'background-color:#ffee00;color:red;';
				}
				return value;
			}

		}
	]];
	var dataGrid=$("#SpecOrContainerListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 20,
		pageList:[20,50,100],
		idField:'Code',
		columns :Columns,
		toolbar:toolbar,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LabBindRuleSetting&QueryName=SpecOrContainerList",
		onLoadSuccess:function(data){
			PageLogicObj.editRow4 = undefined;
			PageLogicObj.m_SpecOrContainerListTabGrid.datagrid('unselectAll');
			LoadSpecOrContainerLinkItem();
		},
		onBeforeLoad:function(param){
			var PlanRowId=$("#PlanList").combobox('getValue');
			var LabPlanHospId=GetHospId();
			param = $.extend(param,{PlanRowId:PlanRowId,LabPlanHospId:LabPlanHospId});
		},
		onDblClickRow:function(index, row){
			if ((PageLogicObj.editRow4!=undefined)&&(PageLogicObj.editRow4!=index)){
				$.messager.alert('提示',"只允许编辑一行数据");
				return
			}
			PageLogicObj.editRow4=index;
			PageLogicObj.m_SpecOrContainerListTabGrid.datagrid("beginEdit", index);
			var BloodFlagDescObj=PageLogicObj.m_SpecOrContainerListTabGrid.datagrid('getEditor', {index:index,field:'BloodFlagDesc'});
			$(BloodFlagDescObj).next('span').find('input').focus();
		},
		onSelect:function(index, row){
			LoadSpecOrContainerLinkItem();
		}
	});
	return dataGrid;
}
function SaveBloodFlag(){
	var PlanRowId=$("#PlanList").combobox('getValue');
	if (PlanRowId=="") {
		$.messager.alert('提示',"请先选择方案!");
		return false;
	}
	if (PageLogicObj.editRow4==undefined) {
		$.messager.alert('提示',"没有需要保存的数据!");
		return false;
	}
	var rows = PageLogicObj.m_SpecOrContainerListTabGrid.datagrid("selectRow",PageLogicObj.editRow4).datagrid("getSelected");
	var value=$.cm({
		ClassName:"DHCDoc.DHCDocConfig.LabBindRuleSetting",
		MethodName:"SaveLabPlanBloodFlag",
		PlanRowId:PlanRowId,
	   	TypeCode:rows["Code"], BloodFlag:rows["BloodFlag"],
		dataType:"text"
	},false)
	if(value.split("^")[0]=="0"){
		$.messager.popover({msg: '保存成功！',type:'success'});
		PageLogicObj.m_SpecOrContainerListTabGrid.datagrid("reload");
		LoadSpecOrContainerLinkItem();
	}else{
		$.messager.alert('提示',"保存失败:"+value);
		return false;
	}
}
function LoadSpecOrContainerLinkItem(){
	if (PageLogicObj.m_tabSpecOrContainerItemListGrid=="") {
		PageLogicObj.m_tabSpecOrContainerItemListGrid=InittabSpecOrContainerItemListGrid();
	}else{
		PageLogicObj.m_tabSpecOrContainerItemListGrid.datagrid("reload");
	}
}
function InittabSpecOrContainerItemListGrid(){
	var toolbar=[
		{
			iconCls: 'icon-add ',
			text:'增加',
			handler: function(){
				AddItem();
			}
		},{
			iconCls: 'icon-cancel',
			text:'删除',
			handler: function(){
				DeleteItem();
			}
		},{
			iconCls: 'icon-save',
			text:'保存',
			handler: function(){
				SaveItem();
			}
		},{
			iconCls: 'icon-arrow-right-top',
			text:'取消编辑',
			handler: function(){
				CancelItemEdit();
			}
		}
    ];
	var Columns=[[    
		{field:'ArcimDesc',title:'医嘱名称',width:220,
			editor:{
          		type:'combogrid',
                options:{
                    enterNullValueClear:false,
					panelWidth:450,
					panelHeight:350,
					delay:500,
					idField:'ArcimRowID',
					textField:'ArcimDesc',
					value:'',//缺省值 
					mode:'remote',
					pagination : true,//是否分页   
					rownumbers:true,//序号   
					collapsible:false,//是否可折叠的   
					fit: true,//自动大小   
					pageSize: 10,//每页显示的记录条数，默认为10   
					pageList: [10],//可以设置每页记录条数的列表  
					url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
                    columns:[[
                        {field:'ArcimDesc',title:'名称',width:310,sortable:true},
		                {field:'ArcimRowID',title:'ID',width:100,sortable:true},
		                {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
                     ]],
					onSelect: function (rowIndex, rowData){
						var rows=PageLogicObj.m_tabSpecOrContainerItemListGrid.datagrid("selectRow",PageLogicObj.editRow5).datagrid("getSelected");
						rows.ARCIMDR=rowData.ArcimRowID
					},
					onClickRow: function (rowIndex, rowData){
						var rows=PageLogicObj.m_tabSpecOrContainerItemListGrid.datagrid("selectRow",PageLogicObj.editRow5).datagrid("getSelected");
						rows.ARCIMDR=rowData.ArcimRowID
					},
					onLoadSuccess:function(data){
						var CurrentOrdName=$(this).combogrid('getValue');
						if(CurrentOrdName!=""){
							if (CurrentOrdName.indexOf("||")>=0){
								$(this).combogrid("setValue","");
								$(this).combo("setText", "")
							}
						}
						$(this).next('span').find('input').focus();
					},
					onBeforeLoad:function(param){
						if (param['q']) {
							var desc=param['q'];
						}else{
							//return false;
						}
						var LabPlanHospId=GetHospId();
						param = $.extend(param,{Alias:desc,HospId:LabPlanHospId});
					}
        		}
			  }
		},
		{field:'Qty',title:'数量',width:60,
			editor:{
				type:'text',  
				options:{
				}
			}
		}
	]];
	var dataGrid=$("#tabSpecOrContainerItemList").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 20,
		pageList:[20,50,100],
		idField:'RowID',
		columns :Columns,
		toolbar:toolbar,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LabBindRuleSetting&QueryName=QueryLabPlanBindOrdFee",
		onLoadSuccess:function(data){
			PageLogicObj.editRow5 = undefined;
			PageLogicObj.m_tabSpecOrContainerItemListGrid.datagrid('unselectAll');
		},
		onBeforeLoad:function(param){
			var PlanRowId=$("#PlanList").combobox('getValue');
			var rows = PageLogicObj.m_SpecOrContainerListTabGrid.datagrid("getSelections");
		    if (rows.length > 0) {
			    var LabPlanBindType=rows[0]["Code"]
			}else{
				var LabPlanBindType="";
			}
			param = $.extend(param,{PlanRowId:PlanRowId,LabPlanBindType:LabPlanBindType});
		},
		onDblClickRow:function(index, row){
			if ((PageLogicObj.editRow5!=undefined)&&(PageLogicObj.editRow5!=index)){
				$.messager.alert('提示',"只允许编辑一行数据");
				return
			}
			PageLogicObj.editRow5=index;
			PageLogicObj.m_tabSpecOrContainerItemListGrid.datagrid("beginEdit", index);
			var ArcimDescObj=PageLogicObj.m_tabSpecOrContainerItemListGrid.datagrid('getEditor', {index:index,field:'ArcimDesc'});
			$(ArcimDescObj).next('span').find('input').focus();
		}
	});
	return dataGrid;
}
function CancelItemEdit(){
	if ((PageLogicObj.editRow5!=="")&&(typeof PageLogicObj.editRow5 !="undefined")){
    	PageLogicObj.m_tabSpecOrContainerItemListGrid.datagrid("rejectChanges");
    	PageLogicObj.m_tabSpecOrContainerItemListGrid.datagrid("unselectAll");
    	PageLogicObj.editRow5 = undefined;
    }
}
function AddItem(){
	if ((PageLogicObj.editRow5!=="")&&(typeof PageLogicObj.editRow5!="undefined")){
		$.messager.alert("提示","存在未保存医嘱,请先保存!");
		return;
	}
	PageLogicObj.editRow5 = undefined;
    PageLogicObj.m_tabSpecOrContainerItemListGrid.datagrid('unselectAll');
    if (PageLogicObj.editRow5 != undefined) {
        return;
    }else{
        PageLogicObj.editRow5 = 0;
        PageLogicObj.m_tabSpecOrContainerItemListGrid.datagrid("insertRow", {
            index: 0,
            row: {}
        });
        PageLogicObj.m_tabSpecOrContainerItemListGrid.datagrid("beginEdit", 0);
        var ArcimDescObj=PageLogicObj.m_tabSpecOrContainerItemListGrid.datagrid('getEditor', {index:PageLogicObj.editRow5,field:'ArcimDesc'});
		$(ArcimDescObj).next('span').find('input').focus();
    }
}
function DeleteItem(){
	var rows = PageLogicObj.m_tabSpecOrContainerItemListGrid.datagrid("getSelections");
    if (rows.length > 0) {
	    $.messager.confirm("提示", "你确定要删除本医嘱吗?",
           function(r) {
                if (r) {
					var ids = [];
                    for (var i = 0; i < rows.length; i++) {
                        ids.push(rows[i].RowID);
                    }
                    var ID=ids.join(',');
                    if (ID==""){
	                    CancelItemEdit();
	                    return;
	                }
                    var value=$.cm({
						ClassName:"DHCDoc.DHCDocConfig.LabBindRuleSetting",
						MethodName:"DelLabPlanBindOrdFee",
					   	rowId:ID,
						dataType:"text"
					},false)
					if((value=="0")||(value=="-100")){
				       $.messager.show({title:"提示",msg:"删除成功"});
				       PageLogicObj.m_tabSpecOrContainerItemListGrid.datagrid('unselectAll');
				       PageLogicObj.m_tabSpecOrContainerItemListGrid.datagrid("reload");
			        }else{
				       $.messager.alert('提示',"删除失败:"+value);
			        }
                }
         });
    }else {
        $.messager.alert("提示", "请选择要删除的医嘱!");
    }
}
function SaveItem(){
	if (PageLogicObj.editRow5 == undefined){
		$.messager.alert("提示", "没有需要保存的医嘱!");
    	return false
    }
    var PlanRowId=$("#PlanList").combobox('getValue');
    if (PlanRowId=="") {
		$.messager.alert('提示',"请选择方案!");
		return false;
	}
	var rows = PageLogicObj.m_SpecOrContainerListTabGrid.datagrid("getSelections");
    if (rows.length > 0) {
	    var Code=rows[0]["Code"];
		if (Code=="") {
			$.messager.alert('提示',"请选择容器/标本!");
			return false;
		}
	}else{
		$.messager.alert("提示", "请选择容器/标本!");
    	return false
	}
			
    var editors = PageLogicObj.m_tabSpecOrContainerItemListGrid.datagrid('getEditors', PageLogicObj.editRow5); 
	var rows = PageLogicObj.m_tabSpecOrContainerItemListGrid.datagrid("selectRow",PageLogicObj.editRow5).datagrid("getSelected");
	var Rowid=rows.RowID;
	if (Rowid==undefined){Rowid=""};
	var ARCIMDR=rows.ARCIMDR;
	if (ARCIMDR==undefined){ARCIMDR=""};
	if (ARCIMDR=="") {
		$.messager.alert('提示',"请选择医嘱项!");
		return false;
	}
	var Qty=editors[1].target.val();
	if (Qty==""){
		$.messager.alert('提示',"请填写数量!");
		return false;
	}
	var r = /^\+?[1-9][0-9]*$/;
	if(!r.test(Qty)){
		$.messager.alert('提示',"数量只能为正整数!");
		return false;
	}
	var saveStr=Rowid+"^"+ARCIMDR+"^"+Qty+"^"+Code+"^Y";
	var value=$.cm({
		ClassName:"DHCDoc.DHCDocConfig.LabBindRuleSetting",
		MethodName:"SaveLabPlanBindOrdFee",
		PlanRowId:PlanRowId,
	   	saveStr:saveStr,
		dataType:"text"
	},false)
	if(value.split("^")[0]=="0"){
		$.messager.popover({msg: '保存成功！',type:'success'});
		PageLogicObj.m_tabSpecOrContainerItemListGrid.datagrid("reload");
	}else if(value.split("^")[0]=="-101"){
		$.messager.alert('提示',"保存失败,记录重复!");
		return false;
	}else{
		$.messager.alert('提示',"保存失败:"+value);
		return false;
	}
}
function BloodFlagOpen(){
	$("#BloodFlag-dialog").dialog("open");
	if (PageLogicObj.m_BloodFlagTabDataGrid=="") {
		PageLogicObj.m_BloodFlagTabDataGrid=InitBloodFlagTabDataGrid();
	}else{
		PageLogicObj.m_BloodFlagTabDataGrid.datagrid("reload");
	}
}
function InitBloodFlagTabDataGrid(){
	var Columns=[[ 
		{ field: 'Code', title: '代码', width: 160,editor : {type : 'text',options : {}}
		},
		{ field: 'Desc', title: '名称', width: 160,editor : {type : 'text',options : {}}},
		{ field: 'Active', title: '有效标志', width: 70}
    ]]
    var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() { 
        	if (!isNaN(PageLogicObj.editRow6)){
            	$.messager.alert("提示","请先保存")
            	return false
            }
            
            PageLogicObj.editRow6=0;
            PageLogicObj.m_BloodFlagTabDataGrid.datagrid("insertRow", {
                index: 0,
                row: {
	                rowid:""
	            }
            });
            PageLogicObj.m_BloodFlagTabDataGrid.datagrid("beginEdit", 0);
	        var CodeObj=PageLogicObj.m_BloodFlagTabDataGrid.datagrid('getEditor', {index:0,field:'Code'});
			CodeObj.target.focus();
        }
    },{
        text: '启用/禁用',
        iconCls: 'icon-remove',
        handler: function() {
	        var rows = PageLogicObj.m_BloodFlagTabDataGrid.datagrid("getSelections");
            if (rows.length > 0) {
				var rowid=rows[rows.length-1].rowid;
				var value=$.m({
					ClassName:"DHCDoc.DHCDocConfig.LabBindRuleSetting",
					MethodName:"UpdateBloodTypeActive",
				   	rowid:rowid
				},false);
				PageLogicObj.m_BloodFlagTabDataGrid.datagrid("reload");
				$("#Combo_BloodFlag").combobox("select","").combobox("reload");
            } else {
                $.messager.alert("提示", "请选择操作行", "error");
            }
	    }
    },{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() {
	        if (isNaN(PageLogicObj.editRow6)){
            	$.messager.alert("提示","请先添加");
            	return false;
            }
            var rows = PageLogicObj.m_BloodFlagTabDataGrid.datagrid("selectRow",PageLogicObj.editRow6).datagrid("getSelected");
			var Rowid=rows.rowid;
			var row=PageLogicObj.m_BloodFlagTabDataGrid.datagrid("getEditors",PageLogicObj.editRow6);
			var Code=row[0].target.val();
			var Desc=row[1].target.val();
			if (Code=="" || Desc==""){
				$.messager.alert("提示","无效数据");
            	return false;
			}
			var saveStr=Code+"^"+Desc+"^Y"
			var value=$.m({
				ClassName:"DHCDoc.DHCDocConfig.LabBindRuleSetting",
				MethodName:"SaveBloodType",
			   	saveStr:saveStr,
			   	Rowid:Rowid
			},false);
			if (value=="-1"){
   				$.messager.alert("提示","保存失败：该代码已存在，请重新输入"+value);
			}else if (value=="-2"){
   				$.messager.alert("提示","保存失败：该代码已被系统占用，请重新输入。"+value);
   			}else{
       			PageLogicObj.editRow6=undefined;
       			PageLogicObj.m_BloodFlagTabDataGrid.datagrid("reload");
       			$("#Combo_BloodFlag").combobox("reload");
       		}
	    }
    }];
	BloodFlagTabDataGrid=$('#BloodFlagTab').datagrid({  
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LabBindRuleSetting&QueryName=FindBloodType",
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : false,  //
		idField:"rowid",
		columns :Columns,
		toolbar :toobar,
		onLoadSuccess:function(data){
			PageLogicObj.editRow6=undefined;
			PageLogicObj.m_BloodFlagTabDataGrid.datagrid("unselectAll");
		},
		onDblClickRow:function(index, row){
			if ((PageLogicObj.editRow6!=undefined)&&(PageLogicObj.editRow6!=index)){
				$.messager.alert('提示',"只允许编辑一行数据");
				return
			}
			PageLogicObj.editRow6=index;
			PageLogicObj.m_BloodFlagTabDataGrid.datagrid("beginEdit", index);
			var CodeObj=PageLogicObj.m_BloodFlagTabDataGrid.datagrid('getEditor', {index:index,field:'Code'});
			$(CodeObj).focus();
		}
	});
	return BloodFlagTabDataGrid;	
}
function InitComboBloodFlag(){
	$("#Combo_BloodFlag").combobox({
    	valueField:'rowid',   
    	textField:'Desc',
    	url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LabBindRuleSetting&QueryName=FindBloodType&paraActive=Y",
		editable:false,
		onSelect:function(record){
			if (PageLogicObj.m_unifyBloodFeeTabDataGrid==""){
				PageLogicObj.m_unifyBloodFeeTabDataGrid=InitunifyBloodFeeTabDataGrid();
			}else{
				PageLogicObj.m_unifyBloodFeeTabDataGrid.datagrid("reload");
			}
		},
		loadFilter:function(data){
			return data['rows'];
		}
	});
}
function AdmTypeCheckChang(){
	if (PageLogicObj.m_LabPlanLimitLoc=="") {
		PageLogicObj.m_LabPlanLimitLoc=InitLabPlanLimitLoc();
	}else{
		PageLogicObj.m_LabPlanLimitLoc.datagrid("reload");
	}
}
function ShowCopyLabPlanWin(){
	if (PageLogicObj.m_planTabDataGrid=="") return;
	var rows = PageLogicObj.m_planTabDataGrid.datagrid("getSelections");
    if (rows.length == 0) {
	    $.messager.alert('提示',"请先选择方案!");
		return false;
	}
	var PlanRowId=rows[0]["RowID"];
	if (PlanRowId=="") {
		$.messager.alert('提示',"请选择已保存方案!");
		return false;
	}
	$("#CopyLabPlan-dialog").dialog("open");
	$("#CopyToName").val("").focus();
}
function CopyLabPlan(){
	var CopyToName=$("#CopyToName").val();
	if (CopyToName=="") {
		$.messager.alert('提示',"请填写复制到方案名称!","info",function(){
			$("#CopyToName").focus();
		});
		return false;
	}
	var rows = PageLogicObj.m_planTabDataGrid.datagrid("getSelections");
	var CopyFromLabPlan=rows[0]["RowID"];
	var value=$.cm({
		ClassName:"DHCDoc.DHCDocConfig.LabBindRuleSetting",
		MethodName:"CopyPlan",
	   	CopyFromLabPlan:CopyFromLabPlan,
	   	CopyToLabPlanName:CopyToName,
	   	CopyToLabPlanHospDr:rows[0]["PlanHospDr"],
		dataType:"text"
	},false)
	if(value.split("^")[0]=="0"){
		$.messager.popover({msg: '复制成功！',type:'success'});
		$("#CopyLabPlan-dialog").dialog("close");
		PageLogicObj.m_planTabDataGrid.datagrid("reload");
		var tab = $('#tabs').tabs('getSelected');
		var index = $('#tabs').tabs('getTabIndex',tab);
		if (index==1) {
			$('#tabs').tabs('select',0);
		}
	}else if(value.split("^")[0]=="-101"){
		$.messager.alert('提示',"复制失败,方案重复!");
		return false;
	}else{
		$.messager.alert('提示',"复制失败:"+value);
		return false;
	}
}
function InitCopyToHospDr(){
	$("#CopyToHospDr").combobox({   
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LocalConfig&QueryName=QryHosptial",
		valueField:'hospID',
		textField:'hospDesc',
		loadFilter:function(data){
		    return data['rows'];
		},
		onSelect:function(rec){
			PageLogicObj.m_CopyToHospDr=rec.hospID;
		},
		onChange:function(newValue, oldValue){
			if (newValue==""){
				PageLogicObj.m_CopyToHospDr="";
			}
		}
	})
}
function InitTip(){
	var _content = "<ul class='tip_class'><li style='font-weight:bold'>检验绑定规则使用说明</li>" + 
		"<li style='color:#008FF0;'>一、方案维护</li>" + 
		"<li>1、新增方案后选择方案维护该方案的绑定限制条件(就诊类型、性别、年龄、使用科室，限定医嘱)，方案之间规则不可重叠。</li>" +
		"<li>2、多个方案的限制规则除限定医嘱外全部相同时，业务使用时以限定医嘱的方案优先级最高。</li>" + 
		"<li>3、可进行方案复制。方案复制仅复制方案费用，方案限制规则需在复制后维护，否则复制后的方案无效。</li>" + 
		
		"<li style='color:#008FF0;'>二、取血类型对应采血费维护</li>" + 
		"<li>1、方案只有维护有效的绑定限制规则后方可进行该方案的费用绑定。</li>" + 
		"<li>2、可在取血类型维护页面维护通用的取血类型(适用所有方案)。</li>"+
		"<li>3、选择方案和取血类型后可维护该方案该取血类型的采血费，不同方案相同取血类型可维护不同的采血费。</li>" +
		"<li>4、重复加收:不同标本号重复绑定。不重复加收,不同标本号只绑定一次,若已经绑定的费用已收费则会再次绑定。</li>" +
		
		"<li style='color:#008FF0;'>三、容器/标本绑定费用</li>" + 
		"<li>1、容器/标本列表根据【常规设置->按容器关联医嘱/不选则默认按标本配置】显示容器列表或标本列表。</li>" +
		"<li>2、不同方案相同容器/标本可维护不同取血类型，右侧容器/标本绑定医嘱按照不同标本号重复绑定规则进行绑定。</li>"+
		
		"<li style='color:#008FF0;'>四、血糖医嘱维护</li>" + 
		"<li>1、该维护针对类似血糖0.5h、血糖1h等同时开立但需要多次抽血的医嘱项。</li>" +
		"<li>2、分组同类排斥。即血糖0.5h、血糖1h属于血糖分组，皮质醇4pm、皮质醇8pm属于皮质醇分组，在医嘱同时开立时，血糖医嘱标本号不同，但血糖0.5h和皮质醇4pm在其它合管条件成立时会生成相同标本号。</li>"
		
	$("#tip").popover({
		width:700,
		height:500,
		trigger:'hover',
		content:_content
	});
}
function BloodSugarOrdOpen(){
	$("#BloodSugarOrd-dialog").dialog("open");
	if (PageLogicObj.m_BloodSugarOrdTabDataGrid=="") {
		PageLogicObj.m_BloodSugarOrdTabDataGrid=InitBloodSugarOrdTabDataGrid();
	}else{
		PageLogicObj.m_BloodSugarOrdTabDataGrid.datagrid("reload");
	}
}
function InitBloodSugarOrdTabDataGrid(){
	var Columns=[[ 
		{field:'ARCIMDR',hidden:true},
		{ field: 'ArcimDesc', title: '医嘱项名称',  align: 'left', sortable: true, width:300,
			editor:{
          		type:'combogrid',
                options:{
                    enterNullValueClear:false,
					required: true,
					panelWidth:450,
					panelHeight:350,
					delay:500,
					idField:'ArcimRowID',
					textField:'ArcimDesc',
					value:'',//缺省值 
					mode:'remote',
					pagination : true,//是否分页   
					rownumbers:true,//序号   
					collapsible:false,//是否可折叠的   
					fit: true,//自动大小   
					pageSize: 10,//每页显示的记录条数，默认为10   
					pageList: [10],//可以设置每页记录条数的列表  
					url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem", //PUBLIC_CONSTANT.URL.QUERY_GRID_URL
                    columns:[[
                        {field:'ArcimDesc',title:'名称',width:310,sortable:true},
		                {field:'ArcimRowID',title:'ID',width:100,sortable:true},
		                {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
                     ]],
					onSelect: function (rowIndex, rowData){
						var rows=PageLogicObj.m_BloodSugarOrdTabDataGrid.datagrid("selectRow",PageLogicObj.editRow7).datagrid("getSelected");
						rows.ARCIMDR=rowData.ArcimRowID;
						
					},
					onClickRow: function (rowIndex, rowData){
						var rows=PageLogicObj.m_BloodSugarOrdTabDataGrid.datagrid("selectRow",PageLogicObj.editRow7).datagrid("getSelected");
						rows.ARCIMDR=rowData.ArcimRowID;
					},
					onLoadSuccess:function(data){
						var CurrentOrdName=$(this).combogrid('getValue');
						if(CurrentOrdName!=""){
							if (CurrentOrdName.indexOf("||")>=0){
								$(this).combogrid("setValue","");
								$(this).combo("setText", "")
							}
						}
						$(this).next('span').find('input').focus();
					},
					onBeforeLoad:function(param){
						if (param['q']) {
							var desc=param['q'];
						}
						param = $.extend(param,{Alias:desc,HospId:GetHospId()});
					}
        		}
			  }
		},
		{field:'BloodSugarGroupDR',hidden:true},
		{field:'BloodSugarGroup',title:'分组',width:150,editor:{
				type:'combobox',  
				options:{
					url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LabBindRuleSetting&QueryName=FindBloodSugarGroup",//PUBLIC_CONSTANT.URL.QUERY_COMBO_URL,
					valueField:'BloodSugarGroupDR',
					textField:'BloodSugarGroup',
					required:true,
					editable:false,
					loadFilter:function(data){
					    return data['rows'];
					},
					onSelect:function(rec){
						var rows=PageLogicObj.m_BloodSugarOrdTabDataGrid.datagrid("selectRow",PageLogicObj.editRow7).datagrid("getSelected");
                        rows.BloodSugarGroupDR=rec.BloodSugarGroupDR;
					},
					onChange:function(newValue, oldValue){
						if (!newValue) newValue="";
						if (newValue==""){
							var rows=PageLogicObj.m_BloodSugarOrdTabDataGrid.datagrid("selectRow",PageLogicObj.editRow7).datagrid("getSelected");
                            rows.BloodSugarGroupDR="";
						}
					},
					onHidePanel:function(){
						var rows=PageLogicObj.m_BloodSugarOrdTabDataGrid.datagrid("selectRow",PageLogicObj.editRow7).datagrid("getSelected");
						if (!$.isNumeric($(this).combobox('getValue'))) return;
						rows.BloodSugarGroupDR=$(this).combobox('getValue');
					}
				  }
			  },
			  formatter:function(value, record){
				  return record.BloodSugarGroup;
			  }
		}
    ]]
    var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {
        	if (!isNaN(PageLogicObj.editRow7)){
            	$.messager.alert("提示","请先保存")
            	return false
            }
            
            PageLogicObj.editRow7=0;
            PageLogicObj.m_BloodSugarOrdTabDataGrid.datagrid("insertRow", {
                index: 0,
                row: {
	                rowid:""
	            }
            });
            PageLogicObj.m_BloodSugarOrdTabDataGrid.datagrid("beginEdit", 0);
        }
    },{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {
	        var rows = PageLogicObj.m_BloodSugarOrdTabDataGrid.datagrid("getSelections");
            if (rows.length > 0) {
				var rowid=rows[rows.length-1].id;
				if (!rowid) {
					PageLogicObj.m_BloodSugarOrdTabDataGrid.datagrid("rejectChanges");
			    	PageLogicObj.m_BloodSugarOrdTabDataGrid.datagrid("unselectAll");
			    	PageLogicObj.editRow7 = undefined;
			    	return;
				}
				var value=$.m({
					ClassName:"DHCDoc.DHCDocConfig.LabBindRuleSetting",
					MethodName:"DeleteLabOrdBloodSugarGroup",
				   	Rowid:rowid
				},false);
				PageLogicObj.m_BloodSugarOrdTabDataGrid.datagrid("reload");
            } else {
                $.messager.alert("提示", "请选择操作行", "error");
            }
	    }
    },{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() {
	        if (isNaN(PageLogicObj.editRow7)){
            	$.messager.alert("提示","请先添加");
            	return false;
            }
            var rows = PageLogicObj.m_BloodSugarOrdTabDataGrid.datagrid("selectRow",PageLogicObj.editRow7).datagrid("getSelected");
			var Rowid=rows.id;
			if (!Rowid) Rowid="";
			var ARCIMDR=rows.ARCIMDR;
			if (!ARCIMDR) {
				$.messager.alert("提示","请选择医嘱项!");
            	return false;
			}
			var BloodSugarGroupDR=rows.BloodSugarGroupDR;
			if (!BloodSugarGroupDR) {
				$.messager.alert("提示","请选择分组!");
            	return false;
			}
			var value=$.m({
				ClassName:"DHCDoc.DHCDocConfig.LabBindRuleSetting",
				MethodName:"SaveLabOrdBloodSugarGroup",
			   	Rowid:Rowid,
			   	ARCIMDR:ARCIMDR,
			   	BloodSugarGroupDR:BloodSugarGroupDR,
			   	HospDr:GetHospId()
			},false);
			if (value==0){
				PageLogicObj.editRow7=undefined;
       			PageLogicObj.m_BloodSugarOrdTabDataGrid.datagrid("reload");
			}else {
   				$.messager.alert("提示","保存失败!"+value);
   			}
	    }
    },{
        text: '取消编辑',
        iconCls: 'icon-arrow-right-top',
        handler: function() {
	        if ((PageLogicObj.editRow7!=="")&&(typeof PageLogicObj.editRow7 !="undefined")){
		    	PageLogicObj.m_BloodSugarOrdTabDataGrid.datagrid("rejectChanges");
		    	PageLogicObj.m_BloodSugarOrdTabDataGrid.datagrid("unselectAll");
		    	PageLogicObj.editRow7 = undefined;
		    }
	    }
    },'-',{
        text: '血糖分组维护',
        iconCls: 'icon-batch-cfg',
        handler: function() {
	        $("#BloodSugar-dialog").dialog("open");
			if (PageLogicObj.m_BloodSugarTabDataGrid=="") {
				PageLogicObj.m_BloodSugarTabDataGrid=InitBloodSugarTabDataGrid();
			}else{
				PageLogicObj.m_BloodSugarTabDataGrid.datagrid("reload");
			}
	    }
    }];
	BloodSugarOrdTabDataGrid=$('#BloodSugarOrdTab').datagrid({  
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LabBindRuleSetting&QueryName=FindOrdBloodSugarGroup",
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		pageSize: 20,
		pageList:[20,50,100],
		idField:"id",
		columns :Columns,
		toolbar :toobar,
		onBeforeLoad:function(param){
			param.HospDr=GetHospId();
		},
		onLoadSuccess:function(data){
			PageLogicObj.editRow7=undefined;
			PageLogicObj.m_BloodSugarOrdTabDataGrid.datagrid("unselectAll");
		},
		onDblClickRow:function(index, row){
			if ((PageLogicObj.editRow7!=undefined)&&(PageLogicObj.editRow7!=index)){
				$.messager.alert('提示',"只允许编辑一行数据");
				return
			}
			PageLogicObj.editRow7=index;
			PageLogicObj.m_BloodSugarOrdTabDataGrid.datagrid("beginEdit", index);
			var CodeObj=PageLogicObj.m_BloodSugarOrdTabDataGrid.datagrid('getEditor', {index:index,field:'Code'});
			$(CodeObj).focus();
		}
	});
	return BloodSugarOrdTabDataGrid;
}
function InitBloodSugarTabDataGrid(){
	var Columns=[[ 
		{ field: 'BloodSugarGroupCode', title: '代码', width: 160,editor : {type : 'text',options : {}}
		},
		{ field: 'BloodSugarGroup', title: '名称', width: 160,editor : {type : 'text',options : {}}}
    ]]
    var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() { 
        	if (!isNaN(PageLogicObj.editRow8)){
            	$.messager.alert("提示","请先保存")
            	return false
            }
            
            PageLogicObj.editRow8=0;
            PageLogicObj.m_BloodSugarTabDataGrid.datagrid("insertRow", {
                index: 0,
                row: {
	                rowid:""
	            }
            });
            PageLogicObj.m_BloodSugarTabDataGrid.datagrid("beginEdit", 0);
	        var CodeObj=PageLogicObj.m_BloodSugarTabDataGrid.datagrid('getEditor', {index:0,field:'BloodSugarGroupCode'});
			CodeObj.target.focus();
        }
    },{
        text: '删除',
        iconCls: 'icon-remove',
        handler: function() {
	        var rows = PageLogicObj.m_BloodSugarTabDataGrid.datagrid("getSelections");
            if (rows.length > 0) {
				var rowid=rows[rows.length-1].BloodSugarGroupDR;
				if (!rowid) {
					PageLogicObj.m_BloodSugarTabDataGrid.datagrid("rejectChanges");
			    	PageLogicObj.m_BloodSugarTabDataGrid
			    	return;
				}
				$.m({
					ClassName:"DHCDoc.DHCDocConfig.LabBindRuleSetting",
					MethodName:"ChkOrdBloodSugar",
				   	GroupDr:rowid,
				   	HospDr:GetHospId()
				},function(rtn){
					if (rtn>0) {
						$.messager.confirm("提示", "该分组已有医嘱项维护,继续删除将删除对应的医嘱项分组记录,是否继续?",
				           function(r) {
				                if (r) {
									var value=$.m({
										ClassName:"DHCDoc.DHCDocConfig.LabBindRuleSetting",
										MethodName:"DeleteLabBloodSugarGroup",
									   	Rowid:rowid,
									   	HospDr:GetHospId()
									},false);
									PageLogicObj.m_BloodSugarTabDataGrid.datagrid("reload")
									PageLogicObj.m_BloodSugarOrdTabDataGrid.datagrid("reload");
				                }
				       	});
					}else{
						var value=$.m({
							ClassName:"DHCDoc.DHCDocConfig.LabBindRuleSetting",
							MethodName:"DeleteLabBloodSugarGroup",
						   	Rowid:rowid,
						   	HospDr:GetHospId()
						},false);
						PageLogicObj.m_BloodSugarTabDataGrid.datagrid("reload");
					}
				});
				
            } else {
                $.messager.alert("提示", "请选择操作行", "error");
            }
	    }
    },{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() {
	        if (isNaN(PageLogicObj.editRow8)){
            	$.messager.alert("提示","请先添加");
            	return false;
            }
            var rows = PageLogicObj.m_BloodSugarTabDataGrid.datagrid("selectRow",PageLogicObj.editRow8).datagrid("getSelected");
			var Rowid=rows.BloodSugarGroupDR;
			if (!Rowid) Rowid="";
			var row=PageLogicObj.m_BloodSugarTabDataGrid.datagrid("getEditors",PageLogicObj.editRow8);
			var Code=row[0].target.val();
			var Desc=row[1].target.val();
			if (Code=="" || Desc==""){
				$.messager.alert("提示","无效数据");
            	return false;
			}
			var value=$.m({
				ClassName:"DHCDoc.DHCDocConfig.LabBindRuleSetting",
				MethodName:"SaveLabBloodSugarGroup",
			   	Code:Code,
			   	Name:Desc,
			   	Rowid:Rowid
			},false);
			if (value==0){
   				PageLogicObj.editRow8=undefined;
       			PageLogicObj.m_BloodSugarTabDataGrid.datagrid("reload");
			}else{
   				$.messager.alert("提示","保存失败!"+value);
   			}
	    }
    },{
        text: '取消编辑',
        iconCls: 'icon-arrow-right-top',
        handler: function() {
	        if ((PageLogicObj.editRow8!=="")&&(typeof PageLogicObj.editRow8 !="undefined")){
		    	PageLogicObj.m_BloodSugarTabDataGrid.datagrid("rejectChanges");
		    	PageLogicObj.m_BloodSugarTabDataGrid.datagrid("unselectAll");
		    	PageLogicObj.editRow8 = undefined;
		    }
	    }
    }];
	BloodSugarTabDataGrid=$('#BloodSugarTab').datagrid({  
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LabBindRuleSetting&QueryName=FindBloodSugarGroup",
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : false,  //
		idField:"BloodSugarGroupDR",
		columns :Columns,
		toolbar :toobar,
		onLoadSuccess:function(data){
			PageLogicObj.editRow8=undefined;
			PageLogicObj.m_BloodSugarTabDataGrid.datagrid("unselectAll");
		},
		onDblClickRow:function(index, row){
			if ((PageLogicObj.editRow8!=undefined)&&(PageLogicObj.editRow8!=index)){
				$.messager.alert('提示',"只允许编辑一行数据");
				return
			}
			PageLogicObj.editRow8=index;
			PageLogicObj.m_BloodSugarTabDataGrid.datagrid("beginEdit", index);
			var CodeObj=PageLogicObj.m_BloodSugarTabDataGrid.datagrid('getEditor', {index:index,field:'BloodSugarGroupCode'});
			$(CodeObj).focus();
		}
	});
	return BloodSugarTabDataGrid;
}
function BPlanConfigClick(){
	$("#Plan-dialog").dialog({
        onClose:function(){
	        $("#PlanList").combobox('select',"").combobox('reload');
	    }
    }).dialog("open");
	$("#Plan-dialog").dialog("open");
	if (PageLogicObj.m_planTabDataGrid=="") {
		PageLogicObj.m_planTabDataGrid=InitplanTabDataGrid();
	}else{
		PageLogicObj.m_planTabDataGrid.datagrid("reload");
	}
}
function GetHospId(){
	return $HUI.combogrid('#_HospList').getValue();
}
