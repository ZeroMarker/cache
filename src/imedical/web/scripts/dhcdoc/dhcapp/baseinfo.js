var PageLogicObj={
	DHCLocPrintSetTabDataGrid:"",
	DHCWomensetTabDataGrid:"",
	editRow:undefined,
	LocRowID:"",
	Type:"P",
	DHCWomensetTabeditRow:undefined,
	DHCWomensetTabLocRowID:"",
}
$(function(){
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_APP_Baseinfo",hospStr);
	hospComp.jdata.options.onSelect  = function(){
		$HUI.radio(".hisui-radio").setValue(false);
		Init();
		} 
	//初始化
	Init();
	PageLogicObj.DHCLocPrintSetTabDataGrid=InitLocPrintSetTabDataDataGrid();
	PageLogicObj.DHCWomensetTabDataGrid=InitDHCWomensetTabDataGrid();
	//事件初始化
	InitEvent();
});
function Init(){
	LoadDataList();
}
function InitEvent(){
	$("#BSave").click(SaveClickHandler);
	$("#BSave_LocPrintSet").click(function(){LocPrintSet()});
	$("#BSave_TCTWomenSet").click(function(){TCTWomenSet()});
}
function LocPrintSet(){
	var mTitle="病理申请单发送特殊科室打印配置";
	$(".hisui-searchbox").searchbox("setValue","");
	LocPrintSetTabDataGridLoad();
	$('#locprintset-dialog').window({
		title:mTitle
	}).window('open');
}
function TCTWomenSet(){
	var mTitle="妇科TCT申请单性别科室配置";
	$(".hisui-searchbox").searchbox("setValue","");
	DHCWomensetTabDataGridLoad();
	$('#TCTWomenset-dialog').window({
		title:mTitle
	}).window('open');
	LoadSex();
	}
function SaveClickHandler(){
	 var DataList="";
	 var PrintNo = $("input[name='DHCAPP_PrintNo']:checked").val();
	 if (PrintNo==undefined) {PrintNo=""}
	 DataList="PrintNo"+String.fromCharCode(1)+PrintNo;
	 var PrintSet = $("input[name='DHCAPP_PrintSet']:checked").val();
	 if (PrintSet==undefined) {PrintSet=""}
	 DataList=DataList+String.fromCharCode(2)+"PrintSet"+String.fromCharCode(1)+PrintSet;	
	 var PrintStyle = $("input[name='DHCAPP_PrintStyle']:checked").val();
	 if (PrintStyle==undefined) {PrintStyle=""}
	 DataList=DataList+String.fromCharCode(2)+"PrintStyle"+String.fromCharCode(1)+PrintStyle;
	 var SetChangeSpec="0";
     if ($("#DHCAPP_SetChangeSpec").is(":checked")) {
		 SetChangeSpec="1"
     }
	 DataList=DataList+String.fromCharCode(2)+"SetChangeSpec"+String.fromCharCode(1)+SetChangeSpec;
	 var SetSpecBilled="0";
     if ($("#DHCAPP_SetSpecBilled").is(":checked")) {
		 SetSpecBilled="1"
     }
	 DataList=DataList+String.fromCharCode(2)+"SetSpecBilled"+String.fromCharCode(1)+SetSpecBilled;
	 var DocDr="0";
     if ($("#DHCAPP_DocDr").is(":checked")) {
		 DocDr="1"
     }
	 DataList=DataList+String.fromCharCode(2)+"DocDr"+String.fromCharCode(1)+DocDr;	
	 var Spec="0";
     if ($("#DHCAPP_Spec").is(":checked")) {
		 Spec="1"
     }
	 DataList=DataList+String.fromCharCode(2)+"Spec"+String.fromCharCode(1)+Spec;
	 var CellShowType = $("input[name='DHCAPP_CellShowType']:checked").val();
	 if (CellShowType==undefined) {CellShowType=""}
	 DataList=DataList+String.fromCharCode(2)+"CellShowType"+String.fromCharCode(1)+CellShowType;
	 var LIVSetMin = $("#DHCAPP_LIVSetMin").val();
	 if (LIVSetMin==undefined) {LIVSetMin=""}
	 DataList=DataList+String.fromCharCode(2)+"LIVSetMin"+String.fromCharCode(1)+LIVSetMin;
	 var TCTWomen="0";
     if ($("#DHCAPP_TCTWomen").is(":checked")) {
		 TCTWomen="1"
     }
	 DataList=DataList+String.fromCharCode(2)+"TCTWomen"+String.fromCharCode(1)+TCTWomen;
	 var LIVSpecFix="0";
     if ($("#DHCAPP_LIVSpecFix").is(":checked")) {
		 LIVSpecFix="1"
     }
	 DataList=DataList+String.fromCharCode(2)+"LIVSpecFix"+String.fromCharCode(1)+LIVSpecFix;
	 var HospID=$HUI.combogrid('#_HospList').getValue();
	 var value=$.m({
	 	ClassName:"DHCDoc.DHCApp.BasicConfig",
		MethodName:"SavebaseInfo",
	 	DataList:DataList,
	 	HospId:HospID
		},false);
	if (value==0){
		$.messager.popover({msg: '保存成功!',type:'success'});
		LoadDataList();
	}else{
		$.messager.alert("提示", "保存失败"+value, "error");
        return false;	
		}	
}
function LoadDataList(){
	GetCheckValue("SetChangeSpec")
	GetCheckValue("SetSpecBilled")
	GetCheckValue("DocDr")
	GetCheckValue("Spec")
	GetCheckValue("TCTWomen")
	GetCheckValue("LIVSpecFix")
	GetRadioValue("PrintNo")
	GetRadioValue("PrintSet")
	GetRadioValue("PrintStyle")
	GetRadioValue("CellShowType")
	GetTextValue("LIVSetMin")
	GetTextValue("TCTWomen")
}
function GetTextValue(Node){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var value=$.m({
	 	ClassName:"DHCDoc.DHCApp.BasicConfig",
		MethodName:"GetConfigNode",
	 	Node:Node,
	 	HospId:HospID
	},false);
	$("#DHCAPP_"+Node).val(value)
}
function GetCheckValue(Node){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	 var value=$.m({
	 	ClassName:"DHCDoc.DHCApp.BasicConfig",
		MethodName:"GetConfigNode",
	 	Node:Node,
	 	HospId:HospID
	},false);
	if (value=="1"){
		$HUI.checkbox("#DHCAPP_"+Node).setValue(true);
		}else{
		$HUI.checkbox("#DHCAPP_"+Node).setValue(false);
		}
	}
function GetRadioValue(Node){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	var value=$.m({
	 	ClassName:"DHCDoc.DHCApp.BasicConfig",
		MethodName:"GetConfigNode",
	 	Node:Node,
	 	HospId:HospID
	},false);
	if (value!=""){
		$HUI.radio("#"+value).setValue(true);
		}
	}
function InitLocPrintSetTabDataDataGrid(){
	var Columns=[[ 
		{field:'LocRowID',title:'LocRowID',hidden:true,width:10},
		{field:'LocDesc',title:'科室名称',width:400},
		{field:'LocPrintSetPdesc',title:'打印项设置',width:200,align:'center'},
		{field:'LocPrintSetP',title:'打印项设置',width:150,hidden:true}
    ]]
    var LocToolBar = [{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() {
            SaveLocPrtSet();
        }
    }];
	var DHCLocPrintSetTabDataGrid=$("#DHCLocPrintSetTab").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,
		pageSize: 20,
		pageList : [20,100,200],
		idField:'LocRowID',
		columns :Columns,
		toolbar :LocToolBar,
		onLoadSuccess:function(data){
			PageLogicObj.editRow=undefined;
			PageLogicObj.DHCLocPrintSetTabDataGrid.datagrid("unselectAll");
			$HUI.radio("input[name='DHCAPP_LocPrintSet']").uncheck();	
		},
		onClickRow:function(rowIndex, rowData){
			PageLogicObj.editRow=rowIndex;
			PageLogicObj.LocRowID=rowData.LocRowID;
			if(rowData.LocPrintSetP!=""){
				$HUI.radio("#loc_"+rowData.LocPrintSetP).setValue(true);
			}else{
				$HUI.radio("input[name='DHCAPP_LocPrintSet']").uncheck();	
			}
		}
	}); 
	return DHCLocPrintSetTabDataGrid;
}
	
function LocPrintSetTabDataGridLoad(){
	var Loc=$("#desc").searchbox("getValue");
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$.q({
	    ClassName : "DHCDoc.DHCApp.BasicConfig",
	    QueryName : "GetLocPrtConfig",
	    desc : Loc,
	    HospId:HospID,
	    Type:PageLogicObj.Type,
	    Pagerows:PageLogicObj.DHCLocPrintSetTabDataGrid.datagrid("options").pageSize,
	    rows:99999
	},function(GridData){
		PageLogicObj.DHCLocPrintSetTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 	
}

function SaveLocPrtSet(){
	if(PageLogicObj.LocRowID=="" || PageLogicObj.editRow==undefined){
		$.messager.alert("提示", "请选择需要配置的科室", "warning");
		return false;
	}
	var PrintSet = $("input[name='DHCAPP_LocPrintSet']:checked").val();
	if (PrintSet==undefined) {PrintSet=""}
	
	$.m({
		ClassName:"DHCDoc.DHCApp.BasicConfig",
		MethodName:"SaveConfig1",
		Node:"LocPrtSet",
		Node1:PageLogicObj.LocRowID+"_"+PageLogicObj.Type,
		NodeValue:PrintSet
	},function(value){
		if(value=="0"){
			LocPrintSetTabDataGridLoad();
			$.messager.popover({type:"success",msg:"保存成功"});
		}else{
			$.messager.alert('提示',"保存失败:"+value);
			return false;
		}
	});
}
function InitDHCWomensetTabDataGrid(){
	var Columns=[[ 
		{field:'LocRowID',title:'LocRowID',hidden:true,width:10},
		{field:'LocDesc',title:'科室名称',width:300},
		{field:'LocSexInclude',title:'包含性别',width:300,align:'center'},
		{field:'LocSexIncludeDr',width:150,hidden:true},
		{field:'LocWomenset',width:150,hidden:true}
    ]]
    var LocToolBar = [{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() {
            if(PageLogicObj.DHCWomensetTabLocRowID=="" || PageLogicObj.DHCWomensetTabeditRow==undefined){
				$.messager.alert("提示", "请选择需要配置的科室", "warning");
				return false;
			}
			var TCTWomen="0";
		    if ($("#TCTWomenset").is(":checked")) {
				 TCTWomen="1"
		     }
			var TCTWomenSex=$("#TCTWomenSex").combobox("getValues")
			$.m({
				ClassName:"DHCDoc.DHCApp.BasicConfig",
				MethodName:"SaveConfig1",
				Node:"Womenset",
				Node1:PageLogicObj.DHCWomensetTabLocRowID+"_TCT",
				NodeValue:TCTWomen+"^"+TCTWomenSex
			},function(value){
				if(value=="0"){
					DHCWomensetTabDataGridLoad();
					$.messager.popover({type:"success",msg:"保存成功"});
				}else{
					$.messager.alert('提示',"保存失败:"+value);
					return false;
				}
			});
        }
    }];
	var DHCLocPrintSetTabDataGrid=$("#DHCWomensetTab").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,
		pageSize: 20,
		pageList : [20,100,200],
		idField:'LocRowID',
		columns :Columns,
		toolbar :LocToolBar,
		onLoadSuccess:function(data){
			PageLogicObj.DHCWomensetTabeditRow=undefined;
			PageLogicObj.DHCWomensetTabDataGrid.datagrid("unselectAll");
			
		},
		onClickRow:function(rowIndex, rowData){
			PageLogicObj.DHCWomensetTabeditRow=rowIndex;
			PageLogicObj.DHCWomensetTabLocRowID=rowData.LocRowID;
			if (rowData.LocWomenset==1){
				$HUI.checkbox("#TCTWomenset").setValue(true);
			}else{
				$HUI.checkbox("#TCTWomenset").setValue(false);
			}
			for (i=0;i<rowData.LocSexIncludeDr.split(",").length;i++){
				var sbox = $HUI.combobox("#TCTWomenSex");
				if (rowData.LocSexIncludeDr.split(",")[i]!="")  sbox.select(rowData.LocSexIncludeDr.split(",")[i]);
			}
			
		}
	}); 
	return DHCLocPrintSetTabDataGrid;
	
	}
function DHCWomensetTabDataGridLoad(){
	var Loc=$("#TCTWomendesc").searchbox("getValue");
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$.q({
	    ClassName : "DHCDoc.DHCApp.BasicConfig",
	    QueryName : "GetTCTWomenConfig",
	    desc : Loc,
	    HospId:HospID,
	    Pagerows:PageLogicObj.DHCWomensetTabDataGrid.datagrid("options").pageSize,
	    rows:99999
	},function(GridData){
		PageLogicObj.DHCWomensetTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 	
	}
function LoadSex(){
	$.cm({
		ClassName:"web.DHCRBCClinicGroup",
		MethodName:"ReadSex",
		JSFunName:"GetSexToHUIJson",
		ListName:"",
		HospId:$HUI.combogrid('#_HospList').getValue(),
		dataType:"text"
	},function(ret){
		//alert(ret)
		var cbox = $HUI.combobox("#TCTWomenSex", {
			valueField: 'id',
			textField: 'text', 
			blurValidValue:true,
			multiple:true,
			rowStyle:'checkbox', //显示成勾选行形式
			selectOnNavigation:false,
			data: JSON.parse(ret)
		})
	})
	}
