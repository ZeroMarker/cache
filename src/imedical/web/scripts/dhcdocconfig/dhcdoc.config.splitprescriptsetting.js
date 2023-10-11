var SplitPrescTypeEditRow; 

$(function(){
	InitHospList();
	$("#Save").click(SaveDetailsClickHandle);	
});
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_SplitPrescriptSetting");
	hospComp.jdata.options.onSelect = function(e,t){
		LoadSplitPrescTypeDetail("");
		$('#tabSplitPrescType').datagrid('reload');
		//初始化右侧界面
		InitPrescTypeDetail("");
		LoadPrompt();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitOther();
		InitCache();
	}
}
function InitOther(){
	//初始化处方类型列表
	InittabSplitPrescType();
	//初始化右侧界面
	InitPrescTypeDetail("");
	LoadPrompt();
}
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function SaveDetailsClickHandle(){
	var rows = SplitPrescTypeDataGrid.datagrid("getSelections");
	if (rows.length ==0) {
		$.messager.alert("提示","请选择需要保存的处方类型!");
		return
	}
	var SplitPrescTypeCode=rows[rows.length-1].Code;

	var SplitPrescTypeItemCat="";
	var size = $("#List_SplitPrescTypeItemCat"+ " option").size();
	if(size>0){
		$.each($("#List_SplitPrescTypeItemCat"+" option:selected"), function(i,own){
			var svalue = $(own).val();
			if (SplitPrescTypeItemCat=="") SplitPrescTypeItemCat=svalue
			else SplitPrescTypeItemCat=SplitPrescTypeItemCat+"^"+svalue
		})
	}
	
	var SplitPrescTypePOList="";
	var size = $("#List_SplitPrescTypePOList"+ " option").size();
	if(size>0){
		$.each($("#List_SplitPrescTypePOList"+" option:selected"), function(i,own){
			var svalue = $(own).val();
			if (SplitPrescTypePOList=="") SplitPrescTypePOList=svalue
			else SplitPrescTypePOList=SplitPrescTypePOList+"^"+svalue
		})
	}
	
	var GroupSum=$("#Txt_GroupSum").val();
	var Single=0;
	if ($("#Check_Single").is(":checked")) {
		 Single=1
	}
	var SingleB=0;
	if ($("#Check_SingleB").is(":checked")) {
		 SingleB=1
	}
	var MajorAttr=0;
	if ($("#Check_MajorAttr").is(":checked")) {
		 MajorAttr=1
	}
	var DMJPrescNo=0;
	if ($("#Check_DMJPrescNo").is(":checked")) {
		 DMJPrescNo=1
	}
	var OPLinkDiag=$("#Check_OPLinkDiag").checkbox('getValue')?1:0;
	var EPLinkDiag=$("#Check_EPLinkDiag").checkbox('getValue')?1:0;
	var IPOneAndOutLinkDiag=$("#Check_IPOneAndOutLinkDiag").checkbox('getValue')?1:0;
	var IPNotOneAndOutLinkDiag=$("#Check_IPNotOneAndOutLinkDiag").checkbox('getValue')?1:0;
	var LinkDiagNumber=$("#LinkDiagNumber").val();
	var PrescNoLinkDiag= OPLinkDiag+"^"+EPLinkDiag+"^"+IPOneAndOutLinkDiag+"^"+IPNotOneAndOutLinkDiag+"^"+LinkDiagNumber;
	
	var spit=String.fromCharCode(1)
	var OtherInfo=GroupSum+"^"+Single+"^"+MajorAttr+"^"+DMJPrescNo+"^"+SingleB;
	var SaveStr=SplitPrescTypeItemCat+spit+OtherInfo+spit+SplitPrescTypePOList+spit+PrescNoLinkDiag;
	var value=$.m({
		 ClassName:"DHCDoc.DHCDocConfig.SplitPrescriptSetting",
		 MethodName:"SaveSplitPrescTypeDetails",
		 Code:SplitPrescTypeCode,
		 Info:SaveStr,
		 HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	if (value!="0"){
		$.messager.alert("提示","保存失败,无效的处方类型代码");
		return
	}
	$.messager.alert("提示", "保存成功", 'success');
}
function LoadSplitPrescTypeDetail(Code){
	var value=tkMakeServerCall("DHCDoc.DHCDocConfig.SplitPrescriptSetting","GetSplitPrescTypeDetails",Code,$HUI.combogrid('#_HospList').getValue());		 
	var ValArr=value.split(String.fromCharCode(1));
	var SelItemCat=ValArr[0];
	var DetailsArr=ValArr[1].split("^");
	var GroupSum=DetailsArr[0];
	var Single=DetailsArr[1];
	var MajorAttr=DetailsArr[2];
	var DMJPrescNo=DetailsArr[3];
	var SingleB=DetailsArr[4];
	var POList=ValArr[2];
	var PrescNoLinkDiag=ValArr[3];
	$("#Txt_GroupSum").val(GroupSum);
	SetSelList("List_SplitPrescTypeItemCat",SelItemCat);
	SetCheckFlag("Check_Single",Single);
	SetCheckFlag("Check_MajorAttr",MajorAttr);
	SetCheckFlag("Check_DMJPrescNo",DMJPrescNo);
	SetCheckFlag("Check_SingleB",SingleB);
	SetSelList("List_SplitPrescTypePOList",POList);
	
	var PrescNoLinkDiag=PrescNoLinkDiag.split("^");
	SetCheckFlag("Check_OPLinkDiag",PrescNoLinkDiag[0]);
	SetCheckFlag("Check_EPLinkDiag",PrescNoLinkDiag[1]);
	SetCheckFlag("Check_IPOneAndOutLinkDiag",PrescNoLinkDiag[2]);
	SetCheckFlag("Check_IPNotOneAndOutLinkDiag",PrescNoLinkDiag[3]);
	$("#LinkDiagNumber").val(PrescNoLinkDiag[4]);
	LoadPrompt();
}
function LoadPrompt(){
	var value=tkMakeServerCall("DHCDoc.DHCDocConfig.SplitPrescriptSetting","GetUnSplitPrescript",$HUI.combogrid('#_HospList').getValue());
	$("#Prompt").text(value);
}
function InitPrescTypeDetail(){
	///初始化下拉列表
	LoadListData("List_SplitPrescTypeItemCat","");
	LoadListData1("List_SplitPrescTypePOList","");
}

function InittabSplitPrescType(){
	var SplitPrescTypeToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
                //var EditRows=getEditRowIndex(SplitPrescTypeDataGrid);
                if (!isNaN(SplitPrescTypeEditRow)){
	            	$.messager.alert("提示","请先保存")
	            	return false
	            }
                
                SplitPrescTypeEditRow=0;
                SplitPrescTypeDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {}
                });
                SplitPrescTypeDataGrid.datagrid("beginEdit", 0);
            }
        },{
            text: '删除',
            disabled: true,
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = SplitPrescTypeDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "此项操作将严重影响业务,您可以选择新建处方类型,转移配置的子类或药学分类,请您再三核实确定要删除吗?",
                    function(r) {
                        if (r) {
							var Code=rows[rows.length-1].Code;
							var value=$.m({
								 ClassName:"DHCDoc.DHCDocConfig.SplitPrescriptSetting",
								 MethodName:"DelSplitPrescType",
								 Code:Code
							},false);
							SplitPrescTypeDataGrid.datagrid("reload");
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				if (isNaN(SplitPrescTypeEditRow)){
	            	$.messager.alert("提示","请先添加");
	            	return false;
	            }
				var row=SplitPrescTypeDataGrid.datagrid("getEditors",SplitPrescTypeEditRow);
				var Code=row[0].target.val();
				var Desc=row[1].target.val();
				if (Code=="" || Desc==""){
					$.messager.alert("提示","无效数据");
	            	return false;
				}
				var value=$.m({
					 ClassName:"DHCDoc.DHCDocConfig.SplitPrescriptSetting",
					 MethodName:"SaveSplitPrescType",
					 Code:Code,
					 Desc:Desc,
					 HospId:$HUI.combogrid('#_HospList').getValue()
				},false);
   				if (value=="-1"){
       				$.messager.alert("提示","保存失败：该代码已存在，请重新输入"+value);
   				}else if (value=="-2"){
       				$.messager.alert("提示","保存失败：该代码已被系统占用，请重新输入。"+value);
       			}else{
	       			SplitPrescTypeEditRow=undefined;
	       			SplitPrescTypeDataGrid.datagrid("reload");
	       		}
			}
		}];
    SplitPrescTypeColumns=[[    
                    { field: 'Code', title: '代码', width: 180,
					   editor : {type : 'text',options : {}}
					},
        			{ field: 'Desc', title: '名称', width: 120,
					  editor : {type : 'text',options : {}}
					}
    			 ]];
	SplitPrescTypeDataGrid=$('#tabSplitPrescType').datagrid({  
		fit : true,
		width : '50',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.SplitPrescriptSetting&QueryName=FindSplitPrescType&HospId="+$HUI.combogrid('#_HospList').getValue(),
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : false,  //
		idField:"Code",
		columns :SplitPrescTypeColumns,
		toolbar :SplitPrescTypeToolBar,
		onSelect : function(rowIndex, rowData) {
			var Code=rowData.Code;
			LoadSplitPrescTypeDetail(Code);
		},
		onLoadSuccess:function(data){
			SplitPrescTypeEditRow=undefined;
		},
		onBeforeLoad:function(param){
		   SplitPrescTypeEditRow=undefined;
		   $('#tabSplitPrescType').datagrid('unselectAll');
	   }
	});
}
function LoadListData(param1,param2){
	$("#"+param1+"").find("option").remove();
	var objScope=$.cm({
		 ClassName:"DHCDoc.DHCDocConfig.SubCatContral",
		 QueryName:"FindCatList",
		 value:param2,
		 HospId:$HUI.combogrid('#_HospList').getValue(),
		 rows:99999
	},false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
		    selectlist=selectlist+"^"+n.selected
            vlist += "<option value=" + n.ARCICRowId + ">" + n.ARCICDesc + "</option>"; 
   });
   $("#"+param1+"").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
			if(selectlist.split("^")[j]=="true"){
				$("#"+param1+"").get(0).options[j-1].selected = true;
			}
	}
} 
function LoadListData1(param1,param2){
	$("#"+param1+"").find("option").remove();
	var objScope=$.cm({
		 ClassName:"DHCDoc.DHCDocConfig.SplitPrescriptSetting",
		 QueryName:"FindPHCPOList",
		 rows:99999
	},false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
		    selectlist=selectlist+"^"+n.selected
            vlist += "<option value=" + n.PORowId + ">" + n.PODesc + "</option>"; 
   });
   $("#"+param1+"").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
			if(selectlist.split("^")[j]=="true"){
				$("#"+param1+"").get(0).options[j-1].selected = true;
			}
	}
} 
function SetSelList(Param,SelStr){
	for (var j=0;j<$("#"+Param+"").get(0).length;j++){
		var optionValue=$("#"+Param+"").get(0)[j].value;
		if(("^"+SelStr+"^").indexOf("^"+optionValue+"^")>=0){
			$("#"+Param+"").get(0).options[j].selected = true;
		}else{
			$("#"+Param+"").get(0).options[j].selected = false;
		}
	}
	return;
}

function SetCheckFlag(Param,CheckFlag){
	if (CheckFlag=="1"){
		$("#"+Param+"").checkbox('check');
	}else{
		$("#"+Param+"").checkbox('uncheck');
	}
	return
}
function SingleChange(e,value){
	if (value) {
		$("#Check_SingleB").checkbox('uncheck');
	}
}
function SingleBChange(e,value){
	if (value) {
		$("#Check_Single").checkbox('uncheck');
	}
}
