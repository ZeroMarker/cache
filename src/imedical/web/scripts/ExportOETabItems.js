$(document).ready(function(){
	
	$("#FCTLocName").keydown(FCTLoc_lookuphandler);
	$("#FUserName").keydown(FUser_lookuphandler)
	
	//清空
	$('#resetButton').click(resetCondition);
	//查询
	$('#FindButton').click(FindHandler);
	// Import
	$('#Import').click(ImportOETabItems);
	//Export
	$('#Export').click(ExportOETabItems);
	jQuery('#Template_tabs').tabs({onSelect:function(title,index){RedrawFavourites(index);}});
	
});
window.name="ExportOETabItems"
var LastRadioValue="";
var escapedCTLOC="";
var XCONTEXT="";
var ObjectType="";
var ctlocid="";
var userid="";
var AppKey="";
var lnkFav="oeorder.entry.redrawprefs.other.csp?CTLOC="+escapedCTLOC+"&XCONTEXT="+XCONTEXT+"&OEWIN="+window.name+"&TABIDX=0"+"&ctlocid="+ctlocid+"&userid="+userid+"&AppKey="+AppKey;;

// 请求路径
var URL_CONSTANT={
	URL:{
	}	
}
$.fn.datebox.defaults.formatter = function(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	return y+'-'+m+'-'+d;
}


//科室查询
function FCTLoc_lookuphandler(e) {
	var obj=websys_getSrcElement(e);
	var key=websys_getKey(e);
	var type=websys_getType(e);
	//alert(key+"^"+type);
	ShowFreqLookup=0
	if(key!=13 && type!='click'){
		return;
	}
	var Id="FCTLocName";
	var FCTLocName=$("#FCTLocName").val();
	
	if ((type=='click')||(key==13)){	
				ShowFreqLookup=1
				//FreqName="";			
				PHCFRDesczLookupGrid = new dhcc.icare.Lookup({
				lookupListComponetId: 1872,
				lookupPage: "科室选择",
				lookupName: Id,
				listClassName: 'web.DHCDocPrefTabs',	
				listQueryName: 'LookUpCTLoc',
				listProperties: [FCTLocName],
				listeners:{'selectRow': FCTLocLookUpSelect},
				pageSize: 20
			});	
		}
	return websys_cancel();			
}
function FCTLocLookUpSelect(value){
	//alert(value);
	var Split_Value=value.split("^");
	$("#FCTLocID").val(Split_Value[0]);
	$("#FCTLocName").val(Split_Value[1]);
	//选中科室模版
	$("#Departments").attr("checked",'checked');
	
	$("#FUserID").val("");
	$("#FUserName").val("");

	$('#FindButton').click();
}

//用户查询
function FUser_lookuphandler(e) {
	var obj=websys_getSrcElement(e);
	var key=websys_getKey(e);
	var type=websys_getType(e);
	//alert(key+"^"+type);
	ShowFreqLookup=0
	if(key!=13 && type!='click'){
		return;
	}
	var Id="FUserName";
	var FCTLocName=$("#FUserName").val();
	if ((type=='click')||(key==13)){	
				ShowFreqLookup=1
				//FreqName="";			
				PHCFRDesczLookupGrid = new dhcc.icare.Lookup({
				lookupListComponetId: 1872,
				lookupPage: "科室选择",
				lookupName: Id,
				listClassName: 'web.DHCDocPrefTabs',	
				listQueryName: 'LookUpUser',
				listProperties: [FCTLocName],
				listeners:{'selectRow': FUserLookUpSelect},
				pageSize: 20
			});	
		}
	return websys_cancel();			
}
function FUserLookUpSelect(value){
	//alert(value);
	var Split_Value=value.split("^");
	$("#FUserID").val(Split_Value[0]);
	$("#FUserName").val(Split_Value[1]);
	//选中科室模版
	$("#Personal").attr("checked",'checked');
	
	$("#FCTLocID").val("");
	$("#FCTLocName").val("");
	
	$('#FindButton').click();
}

function FindHandler(){
	var CTLocName=$("#FCTLocName").val();
	var CTLocID=$("#FCTLocID").val();
	var UserName=$("#FUserName").val();
	var UserID=$("#FUserID").val();
	var AppKey=$("#AppKey").val();
	//var Personal=$("#Personal").attr("checked");
	//var Departments=$("#Departments").attr("checked");
	escapedCTLOC="#($zcvt($g("+CTLocName+","+"O"+","+"URL"+"))#";
	if (escapedCTLOC!="") escapedCTLOC=escape(escapedCTLOC);
	XCONTEXT="";
	
	
	var val=$('input:radio[name="Template"]:checked').val();
	if(val==undefined){
		alert("请选择条件");
		return;
	}
	if(val=="Personal"){
		if(UserID==""){
			alert("请选择用户!");return;
		}
		//查询个人模版
		ObjectType="User.SSUser";
		lnkFav="oeorder.entry.redrawprefs.other.csp?CTLOC="+escapedCTLOC+"&XCONTEXT="+XCONTEXT+"&OEWIN="+window.name+"&TABIDX=0"+"&ctlocid="+""+"&userid="+UserID+"&AppKey="+AppKey;
	}else if(val=="Departments"){
		if(CTLocID==""){
			alert("请选择科室!");return;
		}
		//查询科室模版
		ObjectType="User.CTLoc";
		lnkFav="oeorder.entry.redrawprefs.other.csp?CTLOC="+escapedCTLOC+"&XCONTEXT="+XCONTEXT+"&OEWIN="+window.name+"&TABIDX=0"+"&ctlocid="+CTLocID+"&userid="+"&AppKey="+AppKey;;
	}else{
		ObjectType="User.CTHospital";
	}

	//alert(lnkFav);
	websys_createWindow(lnkFav+'&TABIDX=0'+'&ObjectType='+ObjectType+'&PREFTAB=1','TRAK_hidden');
	return;
}

function RedrawFavourites(tabidx,FocusWindowName) {
	//if (currTab==tabidx) return;
	//Log 54451 PeterC 19/08/05
	var obj=jQuery('#Template_tabs');
	var currTab = obj.tabs('getSelected');
	var currTabIndex = obj.tabs('getTabIndex',currTab);
	if (!document.getElementById('ngroup0Z'+tabidx)) {
		for (var groupI=0;groupI < 5;groupI++) {
			currTab.append("<div class='template_div' style='width:200px;height:70%;float:left;margin-left:10px;'><div data-options='fit:true' class='easyui-panel' title=' ' id='ngroup"+groupI+'Z'+tabidx+"'></div></div>");
		}
		jQuery.parser.parse('#Template_tabs');
	}
	var formulary="";
	var obj=document.getElementById("NonFormulary");
	if (obj) {
	 	if (obj.checked) formulary="Y";
		else {formulary="N";}
	}
	
	if (!obj) formulary="";
	if ((FocusWindowName)&&(FocusWindowName!="")) {
		websys_createWindow(lnkFav+'&TABIDX='+tabidx+'&FocusWindowName='+FocusWindowName+'&formulary='+formulary,'TRAK_hidden');
	}else{
		//如果模板内容出不来?有可能窗口出错?可以把第二个参数'TRAK_hidden'设为空?就可以显示弹出窗口
		websys_createWindow(lnkFav+'&TABIDX='+tabidx+'&ObjectType='+ObjectType,'TRAK_hidden');
	}

}


function resetCondition(){

	$("#FCTLocName").val("");
	$("#FCTLocID").val("");
	$("#FUserName").val("");
	$("#FUserID").val("");
	var file=$("#TemplateExcel")
	file.after(file.clone().val(""));   
    file.remove(); 
	
	$("#AppKey").val("");
	
	$("#Personal").attr("checked",false);
	$("#Departments").attr("checked",false);
}

 function PrefAddItemCustom(tabidx,lstcnt,val,desc) {
	var selector='#ngroup'+lstcnt+'Z'+tabidx;
	var lstpanel=jQuery(selector);
	var descarr=desc.split(" - ");
	if (descarr.length>1){desc=descarr[1]};
	val=val+selector;
	if (!document.getElementById(val)) {		
		var OneLabel="<label id=\""+val+"\" class=\"\" onclick=\"templateItemClickHandler(this)\" >"+desc+"</label><br>"
		var OneObj=lstpanel.append(OneLabel);
	}
}
function templateItemClickHandler(e) {
	$(".templateItemSelect").removeClass("templateItemSelect");
	jQuery(e).addClass("templateItemSelect");
}
var componentxml ="\\temp\\excel\\"
var path = tkMakeServerCall("ext.util.String","GetPhysicalPath","",componentxml)
//导出
function ExportOETabItems(){
	var CTLocName=$("#FCTLocName").val();
	var CTLocID=$("#FCTLocID").val();
	var UserName=$("#FUserName").val();
	var UserID=$("#FUserID").val();
	var ObjectType="";
	var ObjectReference="";
	var xlsname="";
	
	var val=$('input:radio[name="Template"]:checked').val();
	if(val==""){
		alert("请选择条件");
		return;
	}
	if(val=="Personal"){
		if(UserID==""){
			alert("请选择用户!");return;
		}
		//查询个人模版
		ObjectReference=UserID;
		ObjectType="User.SSUser";
		//xlsname=UserName+UserID;
		xlsname=UserID;
	}else if(val=="Departments"){
		if(CTLocID==""){
			alert("请选择科室!");return;
		}
		//查询科室模版
		ObjectReference=CTLocID;
		ObjectType="User.CTLoc";
		//xlsname=CTLocName+CTLocID;
		xlsname=CTLocID;
	}else{
		ObjectType="User.CTHospital";
		alert("请选择条件");
		return;
	}
	var AppKey=$("#AppKey").val();
	//后台直接导出
	var ret=tkMakeServerCall("web.DHCDocPrefTabs","ExportXls",ObjectType,ObjectReference,xlsname,AppKey);
	if (ret==1){
		//下载到本地
	    var filename=xlsname+"OrdTemplate.xls";
	    $("#DownLoad").attr("href","dhctt.file.csp?act=download&dirname="+path+"&filename="+filename);
	    //document.getElementById("DownLoad").click();
	    $("#DownLoad")[0].click();
	}else{
		alert("文件导出失败!")
	}
}

//导入
function ImportOETabItems(){
	//$("#UpLoad")[0].click();
	var CTLocName=$("#FCTLocName").val();
	var CTLocID=$("#FCTLocID").val();
	var UserName=$("#FUserName").val();
	var UserID=$("#FUserID").val();
	var ObjectType="";
	var ObjectReference="";
	var AppKey=$("#AppKey").val();
	var val=$('input:radio[name="Template"]:checked').val();
	if ((val=="")||(typeof val=="undefined")){
		alert("请选择条件");
		return;
	}
	if(val=="Personal"){
		if(UserID==""){
			alert("请选择用户!");return;
		}
		//查询个人模版
		ObjectReference=UserID;
		ObjectType="User.SSUser";
	}else if(val=="Departments"){
		if(CTLocID==""){
			alert("请选择科室!");return;
		}
		//查询科室模版
		ObjectReference=CTLocID;
		ObjectType="User.CTLoc";
	}else{
		ObjectType="User.CTHospital";
	}
	var fileName=$("#TemplateExcel").val();
	if(fileName==""){
		alert("请选择模版");
		return;
	}
	//创建操作EXCEL应用程序的实例
	var oXL = new ActiveXObject("Excel.application");  
	//打开指定路径的excel文件  
    var oWB = oXL.Workbooks.open(fileName);  
    //操作第一个sheet(从一开始，而非零)  
    oWB.worksheets(1).select();  
    var oSheet = oWB.ActiveSheet;  
    //使用的行数  
    var rows =  oSheet.usedrange.rows.count
    var ret=1;
    var tempStr=""
    try {  
         for (var i = 2; i <= rows; i++) { 
             var onetempStr=oSheet.Cells(i, 3).value+String.fromCharCode(2)+
                            (oSheet.Cells(i, 4).value==undefined?"":oSheet.Cells(i,4).value)+String.fromCharCode(2)+
                            (oSheet.Cells(i, 5).value==undefined?"":oSheet.Cells(i,5).value)+String.fromCharCode(2)+
                            (oSheet.Cells(i, 6).value==undefined?"":oSheet.Cells(i,6).value)+String.fromCharCode(2)+
                            (oSheet.Cells(i, 7).value==undefined?"":oSheet.Cells(i,7).value)+String.fromCharCode(2)+
                            (oSheet.Cells(i, 8).value==undefined?"":oSheet.Cells(i,8).value);
             if (tempStr=="") tempStr=onetempStr
             else tempStr=tempStr+String.fromCharCode(1)+onetempStr
             
         }  
    } catch(e) {  
    }  
    if (tempStr!=""){
	      ret=tkMakeServerCall("web.DHCDocPrefTabs","ImportXls",ObjectType,ObjectReference,AppKey,tempStr);
	}
   //退出操作excel的实例对象  
   oXL.Application.Quit();  
    //手动调用垃圾收集器  
   //CollectGarbage();
   if(ret==1){
		alert("导入成功");
		$("#TemplateExcel").val("");		
	}else{
		alert(ret)
		return false;
	}
	$('#FindButton').click();
}
