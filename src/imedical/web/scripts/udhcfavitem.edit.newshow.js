var UDHCFavOrderSetsEditDataGrid; //医嘱套DataGride
var UDHCARCOrderSetItemEditDataGrid; //医嘱套详情DataGride
var ARCOSRowid=""; //医嘱套ID
var SelectRow1="-1"; //选中医嘱套行 -1表示未选中
var DfaultCatID="" //医嘱大类默认值
var ForQueryLoc="" //选中的科室模板赋值科室ID 另存为个人时需判断
var FavEditLay="Y" //跟踪医嘱套模板展开状态 Y展开N没有展开
var ItemEditLay="Y" //跟踪医嘱详细信息展开状态 Y展开N没有展开
//var DelHospARCOSAuthority=tkMakeServerCall("web.DHCDocConfig","GetConfigNode1","DelHospARCOSAuthority",session['LOGON.GROUPID']);
var ARCOSToolBar,ARCOSItemToolBar;
var ModifyHospArcosFlag=1;
var CNFreqArr="",CNDurationArr="",CNInstrArr="",CNPrescTypeArr=""
var DescchangeTime;
$(function(){
	//初始化加载医嘱套模板datagrid
	LoadDataForFav();	
});

function BodyLoadHandler(){
	Resizetab();
	//初始化Comb相关数据
	CombListCreat()
	//初始化定义按钮事件
	ButtonFunction()
	//医嘱套面板折叠后修改医嘱套明细布局---
	$('#UDHCFavOrderSetsEditLay').panel({onCollapse:UDHCFavStyle,onExpand:UDHCFavStyle})
}
//按钮事件定义
function ButtonFunction(){
	//医嘱套
	$('#Search1').click(LoadUDHCFavOrderSetsEditDataGrid); //查询
	$('#ClearFind').click(function(){
		ClearARCOSInfo(true);
		
    }); 
    $("#Desc").change(function (e){
		clearTimeout(DescchangeTime);
        DescchangeTime = setTimeout(function() { AutoSetAlias(e);}, 250);
	});
	$("#Desc").keydown(function(e){
		var keycode = websys_getKey(e);
		if ((keycode==9||keycode==13)){
			AutoSetAlias(e);
		}
	});
	$('#CNSaveBtn').click(function(){
        CNSaveClickHandler();
    });
    $('#main').layout('panel', 'east').panel({
        onBeforeExpand: function() {
	        var rowData=UDHCFavOrderSetsEditDataGrid.datagrid('getSelected');
			if(!rowData){
				$.messager.alert('提示','未选择草药医嘱套!');
				return false;
			}
			if(rowData) ARCOSOrdSubCatDR=rowData.ARCOSOrdSubCatDR;
			if(CNMedItemCatStr.indexOf("^"+ARCOSOrdSubCatDR+"^")<0){
				$.messager.alert('提示','请选择草药医嘱套!');
				return false;
			}
        }
    });
    $("#BSaveARCLocAuthorize").click(BSaveARCLocAuthorize);
}
function Resizetab(){
    var width=$(window).width()-48;
    $('#main').layout('panel', 'center').panel('resize',{width:width})
    $("#UDHCFavOrderSetsEdit").datagrid("resize");
}

function AutoSetAlias(e) {
	var Desc=$("#Desc").val();
	if (Desc==""){return true;}
	if (Desc.indexOf("-")>=0){
		Desc=Desc.split("-").slice(1).join("-");
	}
	var Spell=tkMakeServerCall("ext.util.String","ToChineseSpell",Desc);
	var Alias=$("#Alias").val();
	if ((Alias!="")&&(Alias!=Spell)){
		if (dhcsys_confirm("是否将别名替换为"+Spell+"?")){
			$("#Alias").val(Spell);
		}
	}else{
		$("#Alias").val(Spell);
	}
}
//删除医嘱套明细
function LDeleteClickHandler()
{
	var rowdata=$('#UDHCARCOrderSetItemEdit').datagrid('getSelections')
	if (rowdata){
		if (rowdata.length==0){
			$.messager.alert('提示','请选择需要删除的医嘱!');
			return false;
		}
		for (var i=0;i<rowdata.length;i++){
			var ARCOSItemRowid=rowdata[i].ARCOSItemRowid;
			var ARCIMDesc=rowdata[i].ARCIMDesc;
			var ARCIMRowid=rowdata[i].ARCIMRowid;
			if (ARCOSItemRowid!=""){
				var ReturnValue=$.cm({
					ClassName:"web.DHCARCOrdSets",
					MethodName:"DeleteItem",
					ARCOSItemRowid:ARCOSItemRowid, 
					ARCIMRowid:ARCIMRowid,
					dataType:"text"
				},false);
				if (ReturnValue=="-1"){
					$.messager.alert('提示',ARCIMDesc+'删除失败');
					return false;
				}
			}
		}
		LoadUDHCARCOrderSetItemEditDataGrid()
	}
}
// 新增医嘱套项目
function LAddClickHandler(){
	OpenArcosEditWindow(ARCOSRowid,"")
}

//修改医嘱套明细-内容
function LUpdateClickHandler(){
	var rowdata=$('#UDHCARCOrderSetItemEdit').datagrid('getSelections')
	if (rowdata){
		if (rowdata.length==0){
			$.messager.alert('提示','请选择需要修改的项目!');
			return false;
		}
		if (rowdata.length>1){
			$.messager.alert('提示','请选择一条有效的医嘱信息进行更新');
			return false;
		}
		var ARCOSItemRowid=rowdata[0].ARCOSItemRowid;
		var ARCIMRowid=rowdata[0].ARCIMRowid;
		OpenArcosEditWindow(ARCOSRowid,ARCOSItemRowid,ARCIMRowid)
	}
}
//打开医嘱套明细编辑窗口
function OpenArcosEditWindow(EditARCOSRowid,ARCOSItemRowid,ARCIMRowid){
if (EditARCOSRowid==""){
	   $.messager.alert('提示','请选择相应的医嘱套');
	   return false;
   }
   var src="udhcfavitem.edit.newedit.csp?&ARCOSItemRowid="+ARCOSItemRowid+"&ARCOSRowid="+EditARCOSRowid+"&ARCIMRowid="+ARCIMRowid;   
   if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
   var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
   createModalDialog("ARCOSEdit","医嘱套明细维护",490 , 560,"icon-w-edit","",$code,"");
}
//新增新的医嘱套
function AddClickHandler(SaveType)
{
	var Contions=getValue("Conditiones"); //$('#Conditiones').combobox('getValue')
	if ((Contions=="")&&(SaveType!="SaveToUser")){
		$.messager.alert('提示','条件为必选项,请选择!');
		return false;
	}
	var UserID=session['LOGON.USERID']
	var UserCode=session["LOGON.USERCODE"];
	var GroupID=session['LOGON.GROUPID'];
	var	CTLOCID=session['LOGON.CTLOCID'];
	var HospID=""
	var ARCOSCode="" //$("#Code").val().replace(/(^\s*)|(\s*$)/g,'');
	var ARCOSDesc=$("#Desc").val().replace(/(^\s*)|(\s*$)/g,'');
	var ARCOSAlias=$("#Alias").val().replace(/(^\s*)|(\s*$)/g,'');
	var ARCOSCatID=$('#Category').combobox('getValue');
	var ARCOSSubCatID=$('#SubCategory').combobox('getValue')
	var Data=$('#SubCategory').combobox("getData");
	if ($('#CelerType').checkbox("getValue")){
		var CelerType="Y";
	}else{
		var CelerType="N";
	}
	if((CNMedItemCatStr.indexOf("^"+ARCOSSubCatID+"^")>=0)&&(CelerType=="Y")){
		$.messager.alert('提示','草药医嘱套暂不支持快速录入！'); 
		return;
	}
	if ((CMFlag=="Y")&&(CNMedItemCatStr.indexOf("^"+ARCOSSubCatID+"^")<0)) {
		$.messager.alert('提示','请选择草药相关的医嘱套子类!'); 
		return;
	}
	if ((CMFlag=="N")&&(CNMedItemCatStr.indexOf("^"+ARCOSSubCatID+"^")>=0)) {
		$.messager.alert('提示','请选择西药相关的医嘱套子类!'); 
		return;
	}
	var ARCOSSubCatID1=""
	for (var i=0;i<Data.length;i++) {
		if (Data[i] && Data[i].CombValue==ARCOSSubCatID) {
    	    ARCOSSubCatID1=Data[i] && Data[i].CombValue
		}
	}
	ARCOSSubCatID=ARCOSSubCatID1
	var ARCOSEffDateFrom=NowDate
	var FavDepList=CTLOCID;
	var DocMedUnit=""
	if (ARCOSDesc==""){
		$.messager.alert('提示','医嘱套名称不能为空,请填写名称!'); 
		return;
	}
	if (ARCOSAlias==""){
		$.messager.alert('提示','医嘱套别名不能为空,请填写别名!'); 
		return;
	}
	/*if (ARCOSCode=='') {
		$.messager.alert('提示','医嘱套代码不能为空,请填写代码!');
		return;
	}*/
	if (UserID==""){
		$.messager.alert('提示','缺少用户信息,请刷新界面或从新登陆后再次尝试!'); 
		return;
	}
	if (ARCOSCatID==""){
		$.messager.alert('提示','请选择相应的医嘱套大类!'); 
		return;
	}
	if (ARCOSSubCatID==""){
		$.messager.alert('提示','请选择相应的医嘱套子类!'); 
		return;
	}
	//取组
	var DocMedUnit=tkMakeServerCall("web.DHCUserFavItems","GetMedUnit",UserID,CTLOCID);
	var FavDepList="";
	var InUser=UserID;
	if(SaveType=="SaveToUser"){
		Contions=1
	}
	//条件判断设置相关值
	if (Contions=="1"){
		FavDepList="";DocMedUnit="";
		//医嘱套的名字要加上Code
		if (ARCOSDesc.indexOf("-")<0){
			ARCOSDesc=UserCode+"-"+ARCOSDesc;
		}
	}else if (Contions=="2"){
		InUser="";FavDepList=CTLOCID;DocMedUnit=""
	}else if(Contions=="3"){
		InUser="";FavDepList="";DocMedUnit="";
		HospID=session['LOGON.HOSPID']
	}else if(Contions=="4"){
		FavDepList="";
		if (DocMedUnit==''){
			$.messager.alert('提示','您没有被加入到登陆科室有效的组内,不能进行该条件保存');
			return;
		}
	}
	var ret="";
	if (SaveType=="SaveToUser"){	
		//另存为个人模板
		if (ForQueryLoc==""){
			$.messager.alert('提示','非科室模板不能保存为个人');
			return
		}
		if (ARCOSRowid==""){
			$.messager.alert('提示','请选择需要保存为个人模板的科室模板');
			return
		}
		FavDepList="";DocMedUnit="";
		var ARCOSCode=$("#Code").val().replace(/(^\s*)|(\s*$)/g,'');
		ret=tkMakeServerCall("web.DHCUserFavItems","SaveAsUser",ARCOSRowid,InUser,ARCOSCode+"RS",ARCOSDesc,ARCOSCatID,ARCOSSubCatID,ARCOSEffDateFrom,ARCOSAlias,UserID,FavDepList,DocMedUnit,HospID,CelerType,session['LOGON.HOSPID']);
	}else{
		//保存医嘱套
		ret=tkMakeServerCall("web.DHCUserFavItems","InsertUserARCOS",InUser,ARCOSCode,ARCOSDesc,ARCOSCatID,ARCOSSubCatID,ARCOSEffDateFrom,ARCOSAlias,UserID,FavDepList,DocMedUnit,HospID,CelerType,session['LOGON.HOSPID'])
	}
	if (ret=='-1') {
		$.messager.alert('提示',"保存医嘱套失败您可能填写了已经使用的代码!");
		return;
	}else{
		if (SaveType=="SaveToUser") {
			var FavRowid=ret;
		}else {
			var FavRowid=ret.split(String.fromCharCode(1))[0];
			var ARCOSRowidGet=ret.split(String.fromCharCode(1))[1];
			var ARCOSCode=ret.split(String.fromCharCode(1))[2];
			$("#Code").val(ARCOSCode);
		}
		FavRowid=FavRowid.replace(/(^\s*)|(\s*$)/g,'')
		if (FavRowid==""){
	      $.messager.alert('提示'," 您可能填写了已经使用的代码");
		  return;
		}
  }
  $.messager.popover({msg: '保存成功！',type:'success'});
  CloseWindow(ARCOSRowidGet,ARCOSSubCatID,SaveType=="SaveToUser"?"":"A");
  
  LoadUDHCFavOrderSetsEditDataGrid();	
}
//医嘱套删除
function DeleteClickHandler(){
	if (SelectRow1!="-1"){
		var rowdata=$('#UDHCFavOrderSetsEdit').datagrid('getSelections')
		if (rowdata){
			var FavRowid=rowdata[0].FavRowid;
			var ReturnValue=tkMakeServerCall("web.DHCUserFavItems","DeleteUserARCOS",FavRowid);
			if (ReturnValue=='-1') {
				$.messager.alert('提示','删除医嘱套失败.');  
			}else{
				$.messager.popover({msg: '删除医嘱套成功!',type:'success'});
				//需要先清空查询条件
				ClearARCOSInfo(true);
				LoadUDHCFavOrderSetsEditDataGrid();
			}
		}
	}else{
		$.messager.alert('提示','请选择需要删除的医嘱套');    
	}	
}
//医嘱套更新
function UpdateClickHandler()
{
	if ((ARCOSRowid=="")||(SelectRow1=="-1")){
		$.messager.alert('提示','请选择需要更新的医嘱套!');
		return;
	}
	//确保是选择状态再去取值
	var Contions=getValue("Conditiones"); //$('#Conditiones').combobox('getValue')
	if ((Contions=="")&&(SaveType!="SaveToUser")){
		$.messager.alert('提示','条件为必选项,请选择!');
		return false;
	}
	var UserID=session['LOGON.USERID']
	var UserCode=session["LOGON.USERCODE"];
	var GroupID=session['LOGON.GROUPID'];
	var	CTLOCID=session['LOGON.CTLOCID'];
	var HospID=""
	var ARCOSCode=$("#Code").val().replace(/(^\s*)|(\s*$)/g,'');
	var ARCOSDesc=$("#Desc").val().replace(/(^\s*)|(\s*$)/g,'');
	var ARCOSAlias=$("#Alias").val().replace(/(^\s*)|(\s*$)/g,'');
	var ARCOSCatID=$('#Category').combobox('getValue');
	var ARCOSSubCatID=$('#SubCategory').combobox('getValue')
	var Data=$('#SubCategory').combobox("getData");
	var ARCOSSubCatID1=""
	for (var i=0;i<Data.length;i++) {
		if (Data[i] && Data[i].CombValue==ARCOSSubCatID) {
    	    ARCOSSubCatID1=Data[i] && Data[i].CombValue
		}
	}
	ARCOSSubCatID=ARCOSSubCatID1
	var rowdata=$('#UDHCFavOrderSetsEdit').datagrid('getSelected');
	var FavRowid=rowdata['FavRowid'] //$("#FavRowid").val();
	if ((FavRowid!="")&&(FavRowid!=undefined)){
		FavRowid=FavRowid.replace(/(^\s*)|(\s*$)/g,'');
	}
	var ARCOSEffDateFrom=NowDate
	var FavDepList=CTLOCID;
	var DocMedUnit="";
	if ($('#CelerType').checkbox("getValue")){
		var CelerType="Y";
	}else{
		var CelerType="N";
	}
	if((CNMedItemCatStr.indexOf("^"+ARCOSSubCatID+"^")>=0)&&(CelerType=="Y")){
		$.messager.alert('提示','草药医嘱套暂不支持快速录入！'); 
		return;
	}
	if ((CMFlag=="Y")&&(CNMedItemCatStr.indexOf("^"+ARCOSSubCatID+"^")<0)) {
		$.messager.alert('提示','请选择草药相关的医嘱套子类!'); 
		return;
	}
	if ((CMFlag=="N")&&(CNMedItemCatStr.indexOf("^"+ARCOSSubCatID+"^")>=0)) {
		$.messager.alert('提示','请选择西药相关的医嘱套子类!'); 
		return;
	}
	if (FavRowid==""){
		$.messager.alert('提示','没有取得个人医嘱套Rowid!'); 
		return;
	}
	if (ARCOSDesc==""){
		$.messager.alert('提示','医嘱套名称不能为空,请添加名称!'); 
		return;
	}
	if (ARCOSAlias==""){
		$.messager.alert('提示','医嘱套别名不能为空,请添加别名!'); 
		return;
	}
	if (ARCOSCode=='') {
		$.messager.alert('提示','医嘱套代码不能为空,请填写代码!');
		return;
	}
	if (UserID==""){
		$.messager.alert('提示','缺少用户信息,请刷新界面或从新登陆后再次尝试!'); 
		return;
	}
	if (ARCOSCatID==""){
		$.messager.alert('提示','请选择相应的医嘱套大类!'); 
		return;
	}
	if (ARCOSSubCatID==""){
		$.messager.alert('提示','请选择相应的医嘱套子类!'); 
		return;
	}
	
	//取组
	var DocMedUnit=tkMakeServerCall("web.DHCUserFavItems","GetMedUnit",UserID,CTLOCID);
	var FavDepList="";
	var InUser=UserID;
	//条件判断设置相关值
	if (Contions=="1"){
		FavDepList="";DocMedUnit="";
		//医嘱套的名字要加上Code
		if (ARCOSDesc.indexOf("-")<0){
			ARCOSDesc=UserCode+"-"+ARCOSDesc;
		}
	}else if (Contions=="2"){
		InUser="";FavDepList=CTLOCID;DocMedUnit=""
	}else if(Contions=="3"){
		InUser="";FavDepList="";DocMedUnit="";
		HospID=session['LOGON.HOSPID']
	}else if(Contions=="4"){
		FavDepList="";
		if (DocMedUnit==''){
			$.messager.alert('提示','您没有被加入到登陆科室有效的组内,不能进行该条件保存');
			return;
		}
	}
	var Desc=ARCOSDesc;
	if (ARCOSDesc.indexOf("-")>=0){
		Desc=ARCOSDesc.split("-").slice(1).join("-");
	}
	var Spell=tkMakeServerCall("ext.util.String","ToChineseSpell",Desc);
	if ((ARCOSAlias!="")&&(ARCOSAlias!=Spell)){
		if (dhcsys_confirm("是否将别名替换为"+Spell+"?")){
			$("#Alias").val(Spell);
			ARCOSAlias=Spell;
		}
	}
	
	var Err=tkMakeServerCall("web.DHCUserFavItems","UpdateUserARCOS",FavRowid,ARCOSCode,ARCOSDesc,ARCOSCatID,ARCOSSubCatID,ARCOSEffDateFrom,ARCOSAlias,FavDepList,DocMedUnit,InUser,HospID,CelerType)
	if (Err=='-1') {
		$.messager.alert('提示','更新失败');
		return;
	}else if (Err=='-2') {
		$.messager.alert('提示','您可能填写了已经使用的代码');
		return;
	}else if (Err=='-3') {
		$.messager.alert('提示','原医嘱套已维护处方剂型或已维护明细数据不能修改为非草药医嘱套!');
		return;
	}else if (Err=='-4') {
		$.messager.alert('提示','原医嘱套已维护明细数据不能修改为草药医嘱套!');
		return;
	}else{
		$.messager.popover({msg: '更新成功!',type:'success'});
		CloseWindow(ARCOSRowid);
		
		LoadUDHCFavOrderSetsEditDataGrid();	
	}
}
function SaveAsUserClickHandler(e){
	if (SelectRow1!="-1"){
		if (ForQueryLoc==""){
			$.messager.alert('提示','非科室模板不能保存为个人');
			return
		}
		AddClickHandler("SaveToUser")
	}else{
		$.messager.alert('提示','请选择医嘱套');    
	}
	
}
//初始化Comb
function CombListCreat(){
	//大类Comb
	CategoryCombCreat()
	//初始化条件
	ConditionesCombCreat()
}
function ConditionesCombCreat(){
	var GridData=$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"Conditiones", 
		rows:99999
	},false);
	var cbox = $HUI.combobox("#Conditiones", {
			valueField: 'CombValue',
			textField: 'CombDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},onLoadSuccess:function(data){
				$(this).combobox('select',data[0]['CombValue']);
			},onSelect:function(record){
				//条件为全院 且没有权限修改全院医嘱套
				if ((record["CombValue"]=="3")&&(HospARCOSAuthority!="1")){
					UDHCFavOrderSetsEditDataGrid.datagrid({toolbar:[]});
					UDHCARCOrderSetItemEditDataGrid.datagrid({toolbar:[]});
					ModifyHospArcosFlag=0;
				}else{
					UDHCFavOrderSetsEditDataGrid.datagrid({toolbar:ARCOSToolBar});
					UDHCARCOrderSetItemEditDataGrid.datagrid({toolbar:ARCOSItemToolBar});
					ModifyHospArcosFlag=1;
				}
				LoadUDHCFavOrderSetsEditDataGrid();
			}
	 });
}
//初始化大类
function CategoryCombCreat(){
	var GridData=$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"Category", 
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#Category", {
			valueField: 'CombValue',
			textField: 'CombDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},onLoadSuccess:function(data){
				for (var i=0;i<data.length;i++){
			        if (data[i]['CombDesc'].indexOf("医嘱套")>=0){
				        $('#Category').combobox('select',data[i]['CombValue']);
				        break;
				    }
			    }
		       //大类加载完毕之后
		       SubCategoryCombCreat()
		       var Category=$('#Category').combobox('getText');
			   if (Category.indexOf("医嘱套")>=0){
				   	$('#Category').combobox('disable')
				   	DfaultCatID=$('#Category').combobox('getValue');
			   }
			},onSelect:function(record){
				//选择大类  
           		SubCategoryCombCreat()
			}
		 });
	});
	
}
//初始化子类
function SubCategoryCombCreat()
{
	var CategoryID=$('#Category').combobox('getValue');
	var GridData=$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"SubCategory",Inpute1:CategoryID,
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#SubCategory", {
			valueField: 'CombValue',
			textField: 'CombDesc', 
			editable:true,
			data: GridData["rows"]
	   });
	});
	
}
//选中医嘱套---
function SelectARCOSDataFromRow(){	
	var ARCOSCode="",ARCOSDesc="",ARCOSAlias="";ARCOSOrdSubCatDR="",ARCOSOrdCatDR=DfaultCatID,ForQueryLoc="",FavUserDr="",FavDepDr="",MedUnit="",CelerType="N"
	var FavRowid=""
	if (SelectRow1!="-1"){
		//医嘱套只允许单选情况rowdata[0]
		var rowdata=$('#UDHCFavOrderSetsEdit').datagrid('getSelections')
		if (rowdata){
			ARCOSCode=rowdata[0].ARCOSCode;
			ARCOSDesc=rowdata[0].ARCOSDesc;
			ARCOSAlias=rowdata[0].ARCOSAlias;
			ARCOSOrdSubCatDR=rowdata[0].ARCOSOrdSubCatDR;
			ARCOSOrdCatDR=rowdata[0].ARCOSOrdCatDR;
			ForQueryLoc=rowdata[0].FavDepDr;
			FavRowid=rowdata[0].FavRowid;
			FavUserDr=rowdata[0].FavUserDr;
			FavDepDr=rowdata[0].FavDepDr;
			MedUnit=rowdata[0].MedUnit;
			CelerType=rowdata[0].CelerType;
		}
	}
	if ((ARCOSOrdSubCatDR!="")&&(CNMedItemCatStr.indexOf("^"+ARCOSOrdSubCatDR+"^")>-1)){
		$HUI.checkbox('#CelerType').disable();
	}else{
		$HUI.checkbox('#CelerType').enable();
	}
	$("#Code").val(ARCOSCode);
	$("#Desc").val(ARCOSDesc);
	$("#Alias").val(ARCOSAlias);
	$('#SubCategory').combobox('setValue',ARCOSOrdSubCatDR);
	$('#Category').combobox('setValue',ARCOSOrdCatDR);
	$("#FavRowid").val(FavRowid);
	if (CelerType=="Y"){
		$("#CelerType").checkbox('check');
	}else{
		$("#CelerType").checkbox('uncheck');
	}
	if(SelectRow1=="-1"){
		$('#Conditiones').combobox('setValue','');
		$('div.datagrid-toolbar a').eq(1).show();
		$('div.datagrid-toolbar div').eq(1).show();
	}else{
		if(FavUserDr!=""){
		  $('#Conditiones').combobox('setValue',1);
	    }
	    if(FavDepDr!=""){
		  $('#Conditiones').combobox('setValue',2);
	    }
	    if((MedUnit!="")||((FavDepDr=="")&&(FavUserDr=="")&&(MedUnit==""))){
		  $('#Conditiones').combobox('setValue',3);
	    }
	}
}
function LoadDataForFav(){
	ARCOSToolBar = [{
            text: '新增',
            iconCls: 'icon-add',
            handler: function() { 
               AddClickHandler();
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
               DeleteClickHandler();
            }
        },{
            text: '修改',
            iconCls: 'icon-edit',
            handler: function() {
			  UpdateClickHandler();
            }
        },
        '-', {
            text: '另存为个人医嘱套',
            iconCls: 'icon-save',
            handler: function() {
                SaveAsUserClickHandler();
            }
        },
        '-', {
            text: '包装价格',
            iconCls: 'icon-mnypaper-cfg',
            handler: function() {
	            if(window){
					  var obj =window.dialogArguments
					  if(obj){
						  $.messager.alert('提示','模态窗口不支持,请到对应功能菜单下处理!');
			              return
					  } 
				}
                OrdSetPriceClickHandler();
            }
        },'-', {
            text: '别名维护',
            iconCls: 'icon-tip',
            handler: function() {
	            if(window){
					  var obj =window.dialogArguments
					  if(obj){
						  $.messager.alert('提示','模态窗口不支持,请到对应功能菜单下处理!');
			              return
					  } 
				}
                OtherARCAlias();
            }
        },'-', {
            text: '授权可引用科室',
            iconCls: 'icon-batch-cfg',
            handler: function() {
	            if(window){
					  var obj =window.dialogArguments
					  if(obj){
						  $.messager.alert('提示','模态窗口不支持,请到对应功能菜单下处理!');
			              return
					  } 
				}
                AuthorizeSetWinClick();
            }
        },{
            text: '引用医嘱套',
            iconCls: 'icon-copy',
            handler: function() {
	            if(window){
					  var obj =window.dialogArguments
					  if(obj){
						  $.messager.alert('提示','模态窗口不支持,请到对应功能菜单下处理!');
			              return
					  } 
				}
                websys_showModal({
					url:"udhcfavitem.copy.csp",
					title:'引用医嘱套',
					width:'90%',height:'90%',
					onClose:function(){
						LoadUDHCFavOrderSetsEditDataGrid();
					}
				})
            }
        },'-',{
	        text: '保存到医嘱模板',
            iconCls: 'icon-save',
            handler: function() {
	            if (!ARCOSRowid) {
		            $.messager.alert("提示","请选择需要保存到医嘱模板的医嘱套！");
		            return false;
		        }
		        var Type="西药";
		        var index = $('#UDHCFavOrderSetsEdit').datagrid('getRowIndex', ARCOSRowid);
		        var rows = $('#UDHCFavOrderSetsEdit').datagrid('getRows');
				var ARCOSOrdSubCatDR=rows[index].ARCOSOrdSubCatDR;
				if(CNMedItemCatStr.indexOf("^"+ARCOSOrdSubCatDR+"^")>-1){	//是中草药医嘱套
					Type="草药";
				}
				OpenOrdTemplateWin(Type,ARCOSRowid);
            }
	    }/*,
        '-', {
            text: '保存到个人医嘱模板',
            iconCls: 'icon-save',
            handler: function() {
                SaveToUserFavClick();
            }
        }*/
		];
	//医嘱套
	UDHCFavOrderSetsEditDataGrid=$('#UDHCFavOrderSetsEdit').datagrid({  
		width : 'auto',
		fit:true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : true,
		url:$URL+"?ClassName=web.DHCUserFavItems&QueryName=FindUserOrderSet",
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"ARCOSRowid",
		pageSize:10,
		pageList : [10,50,100],
		toolbar :ARCOSToolBar,
		//frozenColumns : FrozenCateColumns,
		columns :[[
			{field:'CheckArcos',title:'选择',hidden:true},
			{field:'ARCOSOrdCat',title:'大类',width:80,align:'left'},
			{field:'ARCOSOrdSubCat',title:'子类',width:100,sortable:true,
				sorter:function(a,b){  
					debugger;
				}
			},
			{field:'ARCOSCode',title:'代码',width:100,sortable:true},   
			{field:'ARCOSDesc',title:'名称',width:150,sortable:true},   
			{field:'ARCOSAlias',title:'别名',width:100,sortable:true},
			{field:'CelerType',title:'快速',width:50,sortable:true},
			{field:'FavUserDesc',title:'用户',width:80,sortable:true},
			{field:'FavDepDesc',title:'使用科室',width:100,sortable:true},
			{field:'ARCOSAddUser',title:'创建人',width:80,sortable:true},
			{field:'ARCOSAddDate',title:'创建时间',width:115,sortable:true},
			{field:'MedUnitDesc',title:'组名',width:100,hidden:true},
			
			{field:'ARCOSRowid',title:'ARCOSRowid',width:100,hidden:true},   
			{field:'ARCOSOrdSubCatDR',title:'ARCOSOrdSubCatDR',width:100,hidden:true}, 
			{field:'ARCOSEffDateFrom',title:'生效日期',width:100,hidden:true}, 
			{field:'FavRowid',title:'FavRowid',width:100,hidden:true}, 
			{field:'ARCOSOrdCatDR',title:'ARCOSOrdCatDR',width:100,hidden:true}, 
			{field:'FavUserDr',title:'用户ID',width:100,hidden:true}, 
			{field:'FavDepDr',title:'科室ID',width:100,hidden:true}, 
			{field:'MedUnit',title:'组',width:100,hidden:true},
			{field:'PrescTypeCode',hidden:true},
	        {field:'DuratId',hidden:true},
	        {field:'FreqId',hidden:true},
	        {field:'InstrId',hidden:true},
	        {field:'DosageId',hidden:true},
	        {field:'Notes',hidden:true}
		 ]],
		onSelect:function(rowid,RowData){
    		//选择医嘱套赋值
			if (SelectRow1==rowid){
				SelectRow1="-1"
				ARCOSRowid=""
				$(this).datagrid('unselectRow', rowid); 
				ModifyHospArcosFlag=1;
				/*UDHCFavOrderSetsEditDataGrid.datagrid({toolbar:ARCOSToolBar});
		        UDHCARCOrderSetItemEditDataGrid.datagrid({toolbar:ARCOSItemToolBar});*/
		        $(".datagrid-toolbar").show();
				ControlPanel();
			}else{
				ARCOSRowid=RowData.ARCOSRowid;
				SelectRow1=rowid;
				if (HospARCOSAuthority=="1"){
					if ((RowData.FavUserDr==session['LOGON.USERID'])||(RowData.FavDepDr==session['LOGON.CTLOCID'])||(RowData.FavUserDr=="" && RowData.FavDepDr=="")){
						ModifyHospArcosFlag=1;
						$(".datagrid-toolbar").show();
					}else{
						ModifyHospArcosFlag=0;
						$(".datagrid-toolbar").hide();
					}
				}else{
					if (((RowData.FavUserDr=="")&&(RowData.FavDepDr=="")&&(RowData.MedUnit==""))&&(HospARCOSAuthority!="1")) {
						ModifyHospArcosFlag=0;
						$(".datagrid-toolbar").hide();
						/*UDHCFavOrderSetsEditDataGrid.datagrid({toolbar:[]});
						UDHCARCOrderSetItemEditDataGrid.datagrid({toolbar:[]});*/
					}else{
						ModifyHospArcosFlag=1;
						$(".datagrid-toolbar").show();
						/*UDHCFavOrderSetsEditDataGrid.datagrid({toolbar:ARCOSToolBar});
				        UDHCARCOrderSetItemEditDataGrid.datagrid({toolbar:ARCOSItemToolBar});*/
					}
				}
				ControlPanel(rowid, RowData);
			}
			SelectARCOSDataFromRow()
			LoadUDHCARCOrderSetItemEditDataGrid();
		},
		onBeforeLoad:function(param){
			$('#UDHCFavOrderSetsEdit').datagrid("uncheckAll");
			//加载之前清空选中信息
			ARCOSRowid=""; //医嘱套ID
			SelectRow1="-1"; //选中医嘱套行 -1表示未选中
			var data=$('#Conditiones').combobox('getData');
			if (data.length==0) return false;
			var Contions=$('#Conditiones').combobox('getValue');
			if (Contions==undefined) Contions="";
			var ARCOSCode=$("#Code").val().replace(/(^\s*)|(\s*$)/g,'');
			var ARCOSSubCatID=$('#SubCategory').combobox('getValue');
			var ARCOSCode=$("#Code").val().replace(/(^\s*)|(\s*$)/g,'');
			var ARCOSDesc=$("#Desc").val().replace(/(^\s*)|(\s*$)/g,'');
			var ARCOSAlias=$("#Alias").val().replace(/(^\s*)|(\s*$)/g,'');
			var ARCOSCatID=$('#Category').combobox('getValue');
			var ARCOSSubCatID=$('#SubCategory').combobox('getValue')
			var ARCOSEffDateFrom=NowDate
			var FavDepList=session['LOGON.CTLOCID'];
			var DocMedUnit=""
			if ((Contions=="")&&(ARCOSDesc=="")&&(ARCOSAlias=="")&&(HospARCOSAuthority==0)){
				$.messager.alert("提示","条件为空时,描述和别名不能同时为空!","info",function(){
					$("#Desc").focus();
				})
				return false;
			}
			var CelerType=$("#CelerType").checkbox('getValue')?"Y":"N";
			$.extend(param,{
				UserID:session['LOGON.USERID'],
				QueryFlag:"",ForQueryUserID:"",ForQueryLocID:"",status:"",
				Conditiones:Contions,
				DocMedUnit:"",
				subCatID:ARCOSSubCatID, Code:ARCOSCode, 
				Desc:ARCOSDesc, Alias:ARCOSAlias,
				LogonHospID:session['LOGON.HOSPID'],
				HospARCOSAuthority:HospARCOSAuthority,
			    paraCelerType:CelerType
			});
		},
		onLoadSuccess:function(data){
			LoadUDHCARCOrderSetItemEditDataGrid();
			ControlPanel();
		}
	})//.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter});	
	ARCOSItemToolBar = [{
            text: '新增',
            iconCls: 'icon-add',
            handler: function() { 
               LAddClickHandler();
            }
        }, {
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
               LDeleteClickHandler();
            }
        },{
            text: '修改',
            iconCls: 'icon-edit',
            handler: function() {
			  LUpdateClickHandler();
            }
        },
        '-', {
            text: '上移',
            iconCls: 'icon-arrow-top',
            handler: function() {
                upClick();
            }
        },{
            text: '下移',
            iconCls: 'icon-arrow-bottom',
            handler: function() {
                dwClick();
            }
        }];
	//医嘱套详细信息
	UDHCARCOrderSetItemEditDataGrid=$('#UDHCARCOrderSetItemEdit').datagrid({  
		width : 'auto',
		fit:true,
		//height: $("#UDHCARCOrderSetItemEditLay").height()-420,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : true,
		//url : '',
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : false,  //
		idField:"NO", //ARCOSItemRowid
		pageSize:6,
		pageList : [6,15,50,100],
		toolbar :ARCOSItemToolBar,
		style:{
			"border-top":"1px solid #ccc"
		},
		//frozenColumns : FrozenCateColumns,
		columns :[[
			{field:'NO',title:'序号',width:50},
			{field:'ARCIMDesc',title:'名称',width:300,align:'left'}, 
			{field:'ARCOSItemDoseQty',title:'剂量',width:100},
			{field:'ARCOSItemUOM',title:'剂量单位',width:100},
			{field:'ARCOSItemFrequence',title:'频次',width:100},
			{field:'ARCOSItemInstruction',title:'用法',width:100},
			{field:'ARCOSItemDuration',title:'疗程',width:50},  
			{field:'ARCOSItemQty',title:'数量',width:60},   
			{field:'ARCOSItemBillUOM',title:'单位',width:50},
			{field:'ARCOSItmLinkDoctor',title:'关联',width:50},
			{field:'Tremark',title:'备注',width:150},
			{field:'ARCOSDHCDocOrderType',title:'医嘱类型',width:100},
			{field:'SampleDesc',title:'标本',width:100},
			{field:'OrderPriorRemarks',title:'附加说明',width:100},
			{field:'DHCDocOrdRecLoc',title:'接收科室',width:200},
			{field:'DHCDocOrdStage',title:'医嘱阶段',width:150},
			{field:'DHCMustEnter',title:'必开项',width:80},
			{field:'SpeedFlowRate',title:'输液流速',width:80},
			{field:'FlowRateUnit',title:'流速单位',width:85},
			{field:'ARCOSItemRowid',title:'ARCOSItemRowid',width:100,hidden:true},   
			{field:'ARCIMRowid',title:'ARCIMRowid',width:100,hidden:true}, 
			{field:'ARCOSItemUOMDR',title:'ARCOSItemUOMDR',width:100,hidden:true}, 
			{field:'ARCOSItemFrequenceDR',title:'ARCOSItemFrequenceDR',width:100,hidden:true}, 
			{field:'ARCOSItemDurationDR',title:'ARCOSItemDurationDR',width:100,hidden:true}, 
			{field:'ARCOSItemInstructionDR',title:'ARCOSItemInstructionDR',width:100,hidden:true}, 
			{field:'ARCOSDHCDocOrderTypeDR',title:'ARCOSDHCDocOrderTypeDR',width:100,hidden:true}, 
			{field:'SampleID',title:'SampleID',width:100,hidden:true}, 
			{field:'ITMSerialNo',title:'ITMSerialNo',width:100,hidden:true}, 
			{field:'OrderPriorRemarksDR',title:'OrderPriorRemarksDR',width:100,hidden:true}
		
		 ]],
    	onDblClickRow:function(rowid,RowData){
    	    if (ModifyHospArcosFlag=="0") return false;
    		//定义双击编辑事件
    		var EARCOSItemRowid=RowData.ARCOSItemRowid;
    		if (EARCOSItemRowid!=""){
	    		var ARCIMRowid=RowData.ARCIMRowid;
				OpenArcosEditWindow(ARCOSRowid,EARCOSItemRowid,ARCIMRowid);
    		}
		}
	});	
}
//加载医嘱套Data
function LoadUDHCFavOrderSetsEditDataGrid(){
	$('#UDHCFavOrderSetsEdit').datagrid("reload");
	return;
	//加载之前清空选中信息
	ARCOSRowid=""; //医嘱套ID
	SelectRow1="-1"; //选中医嘱套行 -1表示未选中
	var Contions=$('#Conditiones').combobox('getValue');
	if (Contions==undefined) Contions="";
	var UserID=session['LOGON.USERID']
	var UserCode=session["LOGON.USERCODE"];
	var GroupID=session['LOGON.GROUPID'];
	var	CTLOCID=session['LOGON.CTLOCID'];
	var ARCOSCode=$("#Code").val().replace(/(^\s*)|(\s*$)/g,'');
	var ARCOSDesc=$("#Desc").val().replace(/(^\s*)|(\s*$)/g,'');
	var ARCOSAlias=$("#Alias").val().replace(/(^\s*)|(\s*$)/g,'');
	var ARCOSCatID=$('#Category').combobox('getValue');
	var ARCOSSubCatID=$('#SubCategory').combobox('getValue')
	var ARCOSEffDateFrom=NowDate
	var FavDepList=CTLOCID;
	var DocMedUnit=""
	if ((Contions=="")&&(ARCOSDesc=="")&&(ARCOSAlias=="")&&(HospARCOSAuthority==0)){
		$.messager.alert("提示","条件为空时,描述和别名不能同时为空!","info",function(){
			$("#Desc").focus();
		})
		return false;
	}
	var CelerType=$("#CelerType").checkbox('getValue')?"Y":"N";
	$.cm({
	    ClassName : "web.DHCUserFavItems",
	    QueryName : "FindUserOrderSet",
	    UserID:UserID, QueryFlag:"", ForQueryUserID:"", 
	    ForQueryLocID:"", status:"", Conditiones:Contions, 
	    DocMedUnit:"", subCatID:ARCOSSubCatID, Code:ARCOSCode, 
	    Desc:ARCOSDesc, Alias:ARCOSAlias, LogonHospID:session['LOGON.HOSPID'], HospARCOSAuthority:HospARCOSAuthority,
	    paraCelerType:CelerType,
	    Pagerows:UDHCFavOrderSetsEditDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		UDHCFavOrderSetsEditDataGrid.datagrid("uncheckAll").datagrid('loadData',GridData);
		LoadUDHCARCOrderSetItemEditDataGrid();
		ControlPanel();
	})
}
//加载医嘱套详细信息
function LoadUDHCARCOrderSetItemEditDataGrid(type)
{
	if($('#UDHCARCOrderSetItemEdit').length<=0){return}
	
	if (typeof(type) == "undefined") type="";
	UDHCARCOrderSetItemEditDataGrid.datagrid('unselectAll');
	var QueryFlag=""
	if (ARCOSRowid!=""){QueryFlag=1}
	$.cm({
	    ClassName : "web.DHCARCOrdSets",
	    QueryName : "FindOSItem",
	    ARCOSRowid:ARCOSRowid, QueryFlag:QueryFlag,
	    Pagerows:UDHCARCOrderSetItemEditDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		UDHCARCOrderSetItemEditDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		//如果是医嘱明细维护界面新增的明细，则自动跳转到最后一页的最后一条记录
		if (type!=""){
			var total=parseInt(UDHCARCOrderSetItemEditDataGrid.datagrid('getData').total);
			var pageSize=parseInt(UDHCARCOrderSetItemEditDataGrid.datagrid("options").pageSize);
			var LastPage=Math.ceil(total/pageSize);
			if (LastPage>1){
				UDHCARCOrderSetItemEditDataGrid.datagrid('getPager').pagination('select',LastPage); //跳转到最后一页
				var LastPageData=UDHCARCOrderSetItemEditDataGrid.datagrid('getData');
				UDHCARCOrderSetItemEditDataGrid.datagrid("scrollTo",LastPageData.rows.length-1)
			}else{
				UDHCARCOrderSetItemEditDataGrid.datagrid("scrollTo",total-1);
			}
		}
	})
}
//医嘱套明细折叠
function ItemEditLayStyle(){
	if (ItemEditLay=="Y"){ItemEditLay="N"}else{ItemEditLay="Y"}
	if (ItemEditLay=="N"){
		//重新定义分页加载数据
		UDHCARCOrderSetItemEditDataGrid=$('#UDHCFavOrderSetsEdit').datagrid({pageList:[20]})
		LoadUDHCFavOrderSetsEditDataGrid()
	}else{
		UDHCARCOrderSetItemEditDataGrid=$('#UDHCFavOrderSetsEdit').datagrid({pageList:[10]})
		LoadUDHCFavOrderSetsEditDataGrid()
	}
}
//医嘱套折叠
function UDHCFavStyle()
{
	//设置面板折叠状态
	if (FavEditLay=="Y"){FavEditLay="N"}else{FavEditLay="Y"}
	if (FavEditLay=="N"){
		//重新定义分页加载数据
		UDHCARCOrderSetItemEditDataGrid=$('#UDHCARCOrderSetItemEdit').datagrid({pageList:[20]})
		LoadUDHCARCOrderSetItemEditDataGrid()
	}else{
		UDHCARCOrderSetItemEditDataGrid=$('#UDHCARCOrderSetItemEdit').datagrid({pageList:[6]})
		LoadUDHCARCOrderSetItemEditDataGrid()
	}
	
}
//RowID的所选选中行--支持单行翻页选中
function SetSelectRow(RowID)
{
	var pageObj=$('#UDHCARCOrderSetItemEdit').datagrid('getPager');
	var Options=$(pageObj).pagination('options')
	var Total=Options.total; //总数据
	var pageSize=Options.pageSize; //每页数据
	var pageNumber=Options.pageNumber; //当前页
	var PageNum=Math.ceil(Total/pageSize) //向上取整
	var FindPage=""
	$(pageObj).pagination({
		onSelectPage:function(pageNumber, pageSize){
			//alert(pageSize)
			//return true
		}
	});

	for (var KPage=1;KPage<=PageNum;KPage++){
		if (FindPage!=""){break}
	}
}
function upClick(){
	Mouvw("up")
}
function dwClick(){
	Mouvw("dw")
}
function Mouvw(Type){
	var row = UDHCARCOrderSetItemEditDataGrid.datagrid('getSelected');
    var index = UDHCARCOrderSetItemEditDataGrid.datagrid('getRowIndex', row);
    var rows = UDHCARCOrderSetItemEditDataGrid.datagrid('getRows').length;
	if (Type=="up"){
		if (index != 0) {
			var toup = UDHCARCOrderSetItemEditDataGrid.datagrid('getData').rows[index];
            var todown = UDHCARCOrderSetItemEditDataGrid.datagrid('getData').rows[index - 1];
            
            var TopNO=toup.NO; 
            var TopARCOSItemNO=toup.ITMSerialNo; 
            
            var DwNO=todown.NO;
            var DwARCOSItemNO=todown.ITMSerialNo;
            
            todown.NO=TopNO;
            todown.ITMSerialNo=TopARCOSItemNO;
            
            toup.ITMSerialNo=DwARCOSItemNO;
            toup.NO=DwNO;
            
            UDHCARCOrderSetItemEditDataGrid.datagrid('getData').rows[index] = todown;
            UDHCARCOrderSetItemEditDataGrid.datagrid('getData').rows[index - 1] = toup;
            UDHCARCOrderSetItemEditDataGrid.datagrid('refreshRow', index);
            UDHCARCOrderSetItemEditDataGrid.datagrid('refreshRow', index - 1);
            UDHCARCOrderSetItemEditDataGrid.datagrid('selectRow', index - 1);
            var rtn=UpdateSerialNO(todown.ARCOSItemRowid,todown.ITMSerialNo,todown.ARCIMRowid)
            var rtn=UpdateSerialNO(toup.ARCOSItemRowid,toup.ITMSerialNo,toup.ARCIMRowid)
		}
	}else if (Type=="dw"){
		  if (index != rows - 1){
			var todown = UDHCARCOrderSetItemEditDataGrid.datagrid('getData').rows[index];
            var toup = UDHCARCOrderSetItemEditDataGrid.datagrid('getData').rows[index + 1];
            var TopNO=toup.NO; 
            var TopARCOSItemNO=toup.ITMSerialNo;
            
            var DwARCOSItemNO=todown.ITMSerialNo;
            var DwNO=todown.NO;
            
            todown.NO=TopNO;;
            todown.ITMSerialNo=TopARCOSItemNO;
            
            toup.NO=DwNO;
            toup.ITMSerialNo=DwARCOSItemNO;
         
            UDHCARCOrderSetItemEditDataGrid.datagrid('getData').rows[index + 1] = todown;
            UDHCARCOrderSetItemEditDataGrid.datagrid('getData').rows[index] = toup;
            UDHCARCOrderSetItemEditDataGrid.datagrid('refreshRow', index);
            UDHCARCOrderSetItemEditDataGrid.datagrid('refreshRow', index + 1);
            UDHCARCOrderSetItemEditDataGrid.datagrid('selectRow', index + 1);
            var rtn=UpdateSerialNO(todown.ARCOSItemRowid,todown.ITMSerialNo,todown.ARCIMRowid)
            var rtn=UpdateSerialNO(toup.ARCOSItemRowid,toup.ITMSerialNo,toup.ARCIMRowid)
		}
	}	
}
///更新序列
function UpdateSerialNO(ARCOSItemRowid,SerNO,arcimid){	
	 var rtn=tkMakeServerCall("web.DHCARCOrdSets","UpdateItemSerialNo",ARCOSItemRowid,SerNO,arcimid)
	 return rtn	
}
//清空医嘱套查询条件
function ClearARCOSInfo(IsClearList){
	if (IsClearList) {
		$('#SubCategory').combobox('setValue','');
		//$('#Category').combobox('setValue','');
		$('#Conditiones').combobox('select','1');
	}
	$("#Code").val("");
	$("#Desc").val("");
	$("#Alias").val("");
	$("#FavRowid").val("");
	$("#CelerType").checkbox('uncheck');
	$HUI.checkbox('#CelerType').enable();
}
//包装价格
function OrdSetPriceClickHandler() {
	var rowdata=$('#UDHCFavOrderSetsEdit').datagrid('getSelections')
	if ((rowdata)&&(rowdata.length!=0)){
		ARCOSRowid=rowdata[0].ARCOSRowid;
		var src="doc.favitemprice.hui.csp?ARCOSRowid="+ARCOSRowid;   
		if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
		var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
		createModalDialog("ARCOSEdit","包装价格维护", 1130, 500,"icon-w-inv","",$code,"")
	}else{
		$.messager.alert('提示','请选择一条医嘱套!');
	}
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        setTimeout(function(){destroyDialog(id);});
	    }
    });
}
function destroyDialog(id){
   //移除存在的Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}
function ControlPanel(rowIndex, rowData)
{
	var ARCOSOrdSubCatDR="";
	if(rowData) ARCOSOrdSubCatDR=rowData.ARCOSOrdSubCatDR;
	var jqPanle=$('#main').layout('panel','east');
	if(CNMedItemCatStr.indexOf("^"+ARCOSOrdSubCatDR+"^")>-1){	//是中草药医嘱套
		if(jqPanle.panel("options").collapsed){
			$('#main').layout('expand','east');
		}
		InitOSCNInfo(rowData);	//初始化中草药处方信息 后续联动处理参考dhcdoc.ordsets.edit.js
	}else{
		if(!jqPanle.panel("options").collapsed){
			$('#main').layout('collapse','east');
		}
	}
}
function InitOSCNInfo(rowData)
{
	var PrescTypeCode=rowData.PrescTypeCode;
    var DurRowid=rowData.DuratId;
    var FreqRowid=rowData.FreqId;
    var QtyID=rowData.DosageId;
    var InstrRowid=rowData.InstrId;
    var Notes=rowData.Notes;
    var SyndromeCICDDesc=rowData.SyndromeCICDDesc;
	var SyndromeCICDRowid=rowData.SyndromeCICDRowid;
	if (CNPrescTypeArr==""){
		InitCMCombo();
	}
	//只加载子类能选择的处方类型
	var newCNPrescTypeArr=[];
    for(var i=0;i<CNPrescTypeArr.length;i++){
        var CatStr=CNPrescTypeArr[i].id.split("#")[5];
        if(("^"+CatStr+"^").indexOf("^"+rowData.ARCOSOrdSubCatDR+"^")>-1){
	    	newCNPrescTypeArr[newCNPrescTypeArr.length]=CNPrescTypeArr[i];
	    }
    }
    $("#PrescTypeComb").combobox('loadData',newCNPrescTypeArr);
    var PrescTypeCodeId="" //newCNPrescTypeArr[0].id;
    if(PrescTypeCode!=""){
	    for(var i=0;i<newCNPrescTypeArr.length;i++){
		    if(newCNPrescTypeArr[i].id.split("#")[0]==PrescTypeCode){
			    PrescTypeCodeId=newCNPrescTypeArr[i].id;
			}
		}
	}
    if((DurRowid!="")||(FreqRowid!="")||(InstrRowid!="")||(QtyID!="")){
	    $("#PrescTypeComb").combobox('setValue',PrescTypeCodeId);
    	SetCMInfo(DurRowid,FreqRowid,InstrRowid,QtyID)
    }else{
	     //PrescTypeChange();
	     $("#PrescTypeComb").combobox('select',PrescTypeCodeId);
	}
	InitPrescNotes();
    $('#CNNote').val(Notes);
}
function InitCMCombo(){
    InitSingleCombo('DoseQtyComb','Code','Desc','DHCDoc.DHCDocConfig.CMDocConfig','FindInstrLinkOrderQty')
    if (CNFreqArr==""){
	    CNFreqArr=$.cm({
			ClassName:"DHCDoc.DHCDocConfig.OrdSets",
			MethodName:"WriteQueryJson",
			className:"web.DHCDocOrderEntryCM", queryName:"LookUpFrequence", IdCol:5, TextCol:1, CodeCol:2
		},false);
	    InitLocalCombo('FreqComb',CNFreqArr);
	    CNDurationArr=$.cm({
			ClassName:"DHCDoc.DHCDocConfig.OrdSets",
			MethodName:"WriteQueryJson",
			className:"web.DHCDocOrderEntryCM", queryName:"LookUpDuration", IdCol:1, TextCol:2, CodeCol:4
		},false);
	    InitLocalCombo('DurationComb',CNDurationArr);
	    CNInstrArr=$.cm({
			ClassName:"DHCDoc.DHCDocConfig.OrdSets",
			MethodName:"WriteQueryJson",
			className:"web.DHCDocOrderEntryCM", queryName:"LookUpInstr", IdCol:1, TextCol:2, CodeCol:3
		},false);
	    InitLocalCombo('InstrComb',CNInstrArr);
	    InitLocalCombo('PrescTypeComb',[]);
	    CNPrescTypeArr=$.cm({
			ClassName:"DHCDoc.DHCDocConfig.OrdSets",
			MethodName:"WriteCNPrescType"
		},false);
    }
}
function InitSingleCombo(id,valueField,textField,ClassName,QueryName)
{
	var ComboObj={
		editable:false,
		multiple:false,
		selectOnNavigation:true,
	  	valueField:valueField,   
	  	textField:textField,
	  	url:$URL+'?ClassName='+ClassName+'&QueryName='+QueryName
	};
	if(id=='DoseQtyComb'){
	    $.extend(ComboObj,{ 
	    	editable:false, 
		    panelHeight:'auto',
            onBeforeLoad:function(param){
	            var InstrucRowId=$('#InstrComb').combobox('getValue');
	            param = $.extend(param,{InstrucRowId:InstrucRowId});
            },
            loadFilter:function(data){
	            return data['rows'];
	        }
        });
	}
	$("#"+id).combobox(ComboObj);
}
function InitLocalCombo(id,data)
{
    var ComboObj={
		editable:false,
		panelHeight:'auto',
		multiple:false,
		selectOnNavigation:true,
	  	valueField:'id',   
        textField:'text',
        data:data,
        filter: function(q, row){
			var opts = $(this).combobox('options');
			return ("-"+row[opts.textField]).toUpperCase().indexOf("-"+q.toUpperCase()) >-1;
		}
    };
    if(id=='PrescTypeComb'){
	    $.extend(ComboObj,{
		    onSelect:function(){
			    PrescTypeChange();
			}
		})
	}else if(id=='InstrComb'){
		$.extend(ComboObj,{
		    onSelect:function(){
			    $('#DoseQtyComb').combobox('select',"")
			    $('#DoseQtyComb').combobox('reload');
			    SetCMDoseQty($('#DoseQtyComb').combobox('getValue'));
			}
		})
	}
    $("#"+id).combobox(ComboObj);
}
function PrescTypeChange()
{
	//选择处方类型后初始化用法用量等信息
	 var PrescTypeInfo=$("#PrescTypeComb").combobox('getValue');
	 var CNInfoArr="",FreqRowid="",InstrRowid="",DurRowid="",DefaultQtyID=""
	 if(PrescTypeInfo!=''){
		 CNInfoArr=PrescTypeInfo.split("#");
		 FreqRowid=CNInfoArr[1].split("!")[0];
		 InstrRowid=CNInfoArr[2].split("!")[0];
		 DurRowid=CNInfoArr[3].split("!")[0];
		 DefaultQtyID=CNInfoArr[4].split("!")[0];
		 $('#DoseQtyComb').combobox('select',"");
	 }
	 SetCMInfo(DurRowid,FreqRowid,InstrRowid,DefaultQtyID);
}
function SetCMInfo(DurRowid,FreqRowid,InstrRowid,QtyID)
{
	$('#DurationComb').combobox('select',DurRowid);
	$('#FreqComb').combobox('select',FreqRowid);
	$('#InstrComb').combobox('select',InstrRowid);
	setTimeout(function(){SetCMDoseQty(QtyID);},1000);
}
function SetCMDoseQty(QtyID)
{
	$('#DoseQtyComb').combobox('setValue','');
	var DoseQtyArr=$('#DoseQtyComb').combobox('getData');
	for(var i=0;i<DoseQtyArr.length;i++){
		if(DoseQtyArr[i].Code==QtyID){
			$('#DoseQtyComb').combobox('setValue',QtyID);
			break;
		}
	}
}
function CNSaveClickHandler()
{
	var SelectedRow=UDHCFavOrderSetsEditDataGrid.datagrid('getSelected');
	if(!SelectedRow){
		$.messager.alert('提示','未选择医嘱套!');
		return false;
	}
	var OSRowid=SelectedRow.ARCOSRowid
	var PrescTypeCode=getCombValue("PrescTypeComb","id") //$("#PrescTypeComb").combobox('getValue').split("#")[0];
	if (PrescTypeCode!=""){
		PrescTypeCode=PrescTypeCode.split("#")[0];
	}else{
		$.messager.alert('提示','请选择处方类型!');
		return false;
	}
	var DuratId=getCombValue("DurationComb","id") //$('#DurationComb').combobox('getValue');
	var FreqId=getCombValue("FreqComb","id") //$('#FreqComb').combobox('getValue');
	var InstrId=getCombValue("InstrComb","id") //$('#InstrComb').combobox('getValue');
	var DoseQtyId=getCombValue("DoseQtyComb","Code") //$('#DoseQtyComb').combobox('getValue');
	var Notes=$('#CNNote').val();
	$.cm({
		ClassName:"DHCDoc.DHCDocConfig.OrdSets",
		MethodName:"SaveOSCNInfo",
		OSRowid:OSRowid, PrescTypeCode:PrescTypeCode, DoseQtyId:DoseQtyId, DuratId:DuratId, FreqId:FreqId, InstrId:InstrId, Notes:Notes,
		dataType:"text"
	},function(ret){
		if(ret=='0'){
			$.messager.popover({msg: '保存中药医嘱套信息成功!',type:'success'});
			var rowIndex=UDHCFavOrderSetsEditDataGrid.datagrid('getRowIndex',SelectedRow);
	        UDHCFavOrderSetsEditDataGrid.datagrid('updateRow',{
				index: rowIndex,
				row: {PrescTypeCode:PrescTypeCode,DuratId:DuratId,DosageId:DoseQtyId,FreqId:FreqId,InstrId:InstrId,Notes:Notes}
			});
		}else{
			$.messager.alert('提示','保存中药医嘱套信息失败:'+ret);
		}
	});
	
}
function getCombValue(id,valueField){
	var Find=0;
	var selId=$('#'+id).combobox('getValue');
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
		 var CombValue=Data[i][valueField];
		  if(selId==CombValue){
			  selId=CombValue;
			  Find=1;
			  break;
	      }
	  }
	  if (Find=="1") return selId
	  return "";
}
function InitPrescNotes(){
	$("#CNNote").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'Code',
        textField:'Desc',
        columns:[[  
			{field:'Desc',title:'名称',width:350,sortable:true},
			{field:'Code',hidden:true}
        ]],
        pagination:true,
        panelWidth:500,
        panelHeight:370,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.PilotProject.DHCDocPilotProject',QueryName: 'FindDefineData',MDesc:"医嘱录入字典",DDesc:"草药录入备注"},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        //if (desc=="") return false;
			param = $.extend(param,{Alias:desc});
	    },onSelect:function(ind,item){
		    $("#CNNote").val(item.Desc);
		}
    });
}
function getValue(id){
	var className=$("#"+id).attr("class")
	if(typeof className =="undefined"){
		return $("#"+id).val()
	}
	if(className.indexOf("hisui-lookup")>=0){
		var txt=$("#"+id).lookup("getText")
		//如果放大镜文本框的值为空,则返回空值
		if(txt!=""){ 
			var val=$("#"+id).val()
		}else{
			var val=""
			$("#"+id+"Id").val("")
		}
		return val
	}else if(className.indexOf("hisui-combobox")>=0){
		var val=$("#"+id).combobox("getValue")
		if(typeof val =="undefined") val=""
		return val
	}else if(className.indexOf("hisui-datebox")>=0){
		return $("#"+id).datebox("getValue")
	}else{
		return $("#"+id).val()
	}
	return ""
}
//医嘱套其他别名项目
function OtherARCAlias()
{
	var rowdata=$('#UDHCFavOrderSetsEdit').datagrid('getSelections')
	if ((rowdata)&&(rowdata.length!=0)){
		ARCOSRowid=rowdata[0].ARCOSRowid;
		var src="dhcdoc.arcosoteralias.hui.csp?ARCOSRowid="+ARCOSRowid;   
		if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
		var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
		createModalDialog("ARCOSEdit","医嘱套别名维护", 500, 500,"icon-w-inv","",$code,"")
	}else{
		$.messager.alert('提示','请选择一条医嘱套!');
	}
}
function AuthorizeSetWinClick(){
	if (SelectRow1=="-1"){
		$.messager.alert('提示','请选择需要授权的医嘱套!');
		return;
	}
	$("#List_OrderDept").empty();
	//授权科室列表
	LoadOrderDept("List_OrderDept");
	$("#FindDept").searchbox("setValue","");
	if ($("#RecSetWin").hasClass('window-body')){
		$('#RecSetWin').window('open');
	}else{
		ShowHolidaysRecSetWin();
	}
	$("#FindDept").next('span').find('input').focus();
}
function LoadOrderDept(param1){
	var rowdata=$('#UDHCFavOrderSetsEdit').datagrid('getSelections');
	var ARCOSRowid=rowdata[0]["ARCOSRowid"];
	$.cm({
		ClassName:"web.DHCARCOrdSetsAuthorize",
		QueryName:"FindDep",
		ARCOSRowId:ARCOSRowid,
		rows:"99999",
	},function(objScope){
	   var vlist = ""; 
	   var selectlist="";
	   jQuery.each(objScope.rows, function(i, n) { 
		    selectlist=selectlist+"^"+n.selected
            vlist += "<option value=" + n.CTLOCRowID + " alias=" + n.alias + ">" + n.CTLOCDesc + "</option>"; 
       });
       $("#"+param1+"").append(vlist); 
	   for (var j=1;j<=selectlist.split("^").length;j++){
			if(selectlist.split("^")[j]=="true"){
				$("#"+param1+"").get(0).options[j-1].selected = true;
			}
		}
	});
}
function ShowHolidaysRecSetWin(){
	$('#AuthorizeSetWin').window({
		title: '医嘱套授权',
		zIndex:9999,
		iconCls:'icon-w-edit',
		inline:false,
		minimizable: false,
		maximizable: false,
		collapsible: false,
		closable:true
	});
}
function BSaveARCLocAuthorize(){
	var rowdata=$('#UDHCFavOrderSetsEdit').datagrid('getSelections');
	var ARCOSRowid=rowdata[0]["ARCOSRowid"];
	var LocStr="";
	var obj=$("#List_OrderDept").find("option:selected");
	for (var i=0;i<obj.length;i++){
		var LocID=obj[i].value;
		if (LocStr=="") LocStr=LocID;
		else LocStr=LocStr+"^"+LocID;
	}
	var rtn=$.cm({
		ClassName:"web.DHCARCOrdSetsAuthorize",
		MethodName:"SaveARCLocAuthorize",
		ARCOSRowId:ARCOSRowid,
		LocStr:LocStr,
		dataType:"text"
	},false);
	$("#AuthorizeSetWin").window('close');
}
function FindDeptChange(value){
	value=value.toUpperCase();
	var matchIndexArr=new Array();
	var _$selOptions=$("#List_OrderDept option");
	var Obj=document.getElementById('List_OrderDept');
	for (var i=0;i<Obj.length;i++){
		$(_$selOptions[i]).show();
		var DepDesc=Obj[i].text;
		var DepArr=DepDesc.split("-");
		var selText=DepArr[0].toUpperCase();
		var selCode="";
		if (DepArr[1]) {
			selCode=DepArr[1].toUpperCase();
		}
		if ((selText.indexOf(value)>=0)||(selCode.indexOf(value)>=0)){
			matchIndexArr.push(i);
		}else{
			$(_$selOptions[i]).hide();
		}
	}
	if ((matchIndexArr.length>=1)&&(value!="")){
		Obj.selectedIndex=matchIndexArr[0];
	}
}

function CloseWindow(ARCOSRowidGet,ARCOSSubCatID,SaveType){
	if(window){
	  var obj =window.dialogArguments
	  if(obj){
		  window.returnValue=ARCOSRowidGet;
		  window.close();
	  } 
      if (websys_showModal('options')) {
	      websys_showModal("hide");
	      if (websys_showModal('options').SaveItemToARCOS) {
		      websys_showModal('options').SaveItemToARCOS(ARCOSRowidGet);
		  }
		  if (websys_showModal('options').CallBackFunc) {
		      websys_showModal('options').CallBackFunc(ARCOSRowidGet);
		  }
	      websys_showModal("close");
	  }
	}
	if((SaveType=="A")&&(ARCOSRowidGet)&&(!websys_showModal('options'))){
		$.messager.confirm("确认对话框", "是否将医嘱套【"+$("#Desc").val()+"】保存到医嘱模板？", function (r) {
			if (r) {
				var Type="西药";
			    var index = $('#UDHCFavOrderSetsEdit').datagrid('getRowIndex', ARCOSRowid);
			    var rows = $('#UDHCFavOrderSetsEdit').datagrid('getRows');
				if(CNMedItemCatStr.indexOf("^"+ARCOSSubCatID+"^")>-1){	//是中草药医嘱套
					Type="草药";
				}
			    OpenOrdTemplateWin(Type,ARCOSRowidGet);
			}
		});
	 }
}
function OpenOrdTemplateWin(Type,ARCOSRowid)
{
	websys_showModal({
		url:"doc.arcossavetotemplate.hui.csp?Type="+Type,
		title:'保存到医嘱模板',
		paraObj:{name:ARCOSRowid},
		width:'500px',height:'420px'
	})
}