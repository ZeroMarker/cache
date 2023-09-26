
//名称	DHCPEIAdmItemStatusDetail.js
//组件  DHCPEIAdmItemStatusDetail
//功能	查看预约项目
//创建	2018.09.07
//创建人  xy
//document.body.style.padding="0px 10px 10px 10px"
var onAfterRender = $.fn.datagrid.defaults.view.onAfterRender;
        $.extend($.fn.datagrid.defaults.view, {
            onAfterRender: function(target){
                onAfterRender.call(this, target);
          
               var objtbl = $(target).datagrid('getRows');
	           var rows=objtbl.length
	         for (var j=0;j<rows;j++) {
		        var index=j;
		      	var Status=objtbl[j].TStatus;
		      	
		      	var placerCode=objtbl[j].placerCode;
		      
		        if(placerCode!="") { 
		      		 $(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+"TItemName"+"]").css({"background-color":objtbl[j].placerCode});
		     	 } 
		      
		 	   Status=Status.replace(" ","")
		 	   if(Status=="核实"){
			 	   $(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+"TStatus"+"]").css({"background-color":"yellow"});
			 	  
		 	   }
		 	   if(Status=="执行"){
			 	   $(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+"TStatus"+"]").css({"background-color":"#00CC66"});
			 	  
		 	   }
		 	   if(Status=="谢绝检查"){
			 	   $(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+"TStatus"+"]").css({"background-color":"#FF0000"});
			 	  
		 	   }
		 	    if(Status=="停止"){
			 	   $(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+"TStatus"+"]").css({"background-color":"#FF88FF"});
			 	  
		 	   }
		 	   
		 	   
				
			}

	           
            }
});


$('#tDHCPEIAdmItemStatusDetail').datagrid({
	//单击行结束编辑
	onLoadSuccess:function(data){
			
			alert(22)
			/*
			editIndex = undefined;
			if(PreAdmId)
			{
				var rows = $("#PreItemList").datagrid("getRows");
			
				$("#PreItemList").datagrid("scrollTo",rows.length-1);
			}
			*/
			
		},
	onSelect: function (rowIndex, rowData) {
		
			var isAplyDrug=getCmpColumnValue(rowIndex,"TChecked","DHCPEIAdmItemStatusDetail");
			//alert(isAplyDrug+"isAplyDrug")
			
			if(rowData.TDrugStatus!="已发药") return false;
			
			if(isAplyDrug==0)
			{
			// 申请
			
			
			var BillStatus=rowData.TBillStatus;  //  getCmpColumnValue(rowIndex,"TBillStatus","DHCPEIAdmItemStatusDetail"); //document.getElementById('TBillStatusz'+selectrow)
			
			//alert(BillStatus+"BillStatus")
			//已付费药品请去退费申请界面
			//if(BillStatus !="挂帐")
			if(BillStatus.indexOf("挂帐") == -1 )
			{
				//alert(1)
			alert(t['HadPayed'])
			return false;
			}
			
	var addflag=true;
	//alert(addflag+"addflag")
	
	var feeid="1"+"^"+rowData.TPreItemID  //GetCtlValueById('TPreItemIDz'+selectrow);
	//alert(feeid+"feeid")
	//药品权限控制 如果已退药不允许取消申请
	var enControl=document.getElementById("DrugPermControl");
	if(enControl){
		var encmeth=enControl.value;
	}
	var flag=cspRunServerMethod(encmeth,feeid,"0")
	
	if (flag=="1") 
	{alert(t['HadDropDrug']);
	 return false;}
	var SelectId;
	if (addflag)
	{			
		SelectId=feeid;
		
	}
	else
	{	
		SelectId=""
	}
	//alert(SelectId)
	
	
	//将selectId保存到临时的global中
	
	var encache=document.getElementById("SetApplyDrug");
	if(encache){
		encache=encache.value;
	}
	var oeori=rowData.TId //GetCtlValueById('TIdz'+selectrow);
	var flag=cspRunServerMethod(encache,SelectId,oeori);
	if(flag==1){
		
		alert("申请成功")
		
	}
			// 成功之后再设置状态
			setColumnValue(rowIndex,"TChecked",1)
				
			}
			else
			{
				
				
				
				setColumnValue(rowIndex,"TChecked",0)
				}
			//alert(rowData.TDrugStatus);
			
    }
})

//增加可编辑列表
var editFlag="undefined";


function Ini(){
	//ColorTblColumn();
	//SetChoiceSpecName();
	
	
	$("#Source").attr('disabled',true);
	//更新标本号
	var obj=document.getElementById("BUpdateSpec");
	if (obj) obj.onclick=BUpdateSpec_click;
	
	//报告上不打印
	var obj=document.getElementById("BSaveNoPrint");
	if (obj) {
		obj.onclick=Save_Click;
		obj.ondbclick=Save_Click;
	}
	
	//撤销/谢绝检查
	var obj=document.getElementById("Refuse");
	if (obj) { obj.onclick=Refuse; }
	

	
	//发送消息  
	var obj=document.getElementById("BSend");
	if (obj) obj.onclick=BSend_Click;
	
	//取消发送
	var obj=document.getElementById("BCancelSend");
	if (obj) obj.onclick=BCancelSend_Click;	
	
	iniForm();
	
	initButtonWidth();
	
	//InitListInfo();
	
}

function iniForm(){
	
	//PACS是否是第三方 1 是 0 不是
	var flag=tkMakeServerCall("web.DHCPE.OEOrdItem","ISSendOrder");
	//alert(flag)
	if(flag=="0"){
		var obj=document.getElementById("BSend");
		if (obj){ obj.style.display="none"; }
	
		var obj=document.getElementById("BCancelSend");
		if (obj){ obj.style.display="none"; }
	
		}
}

//撤销/谢绝检查 
function Refuse(){
	
	var OEORIRowIdStr=GetId();

	if(OEORIRowIdStr==""){
		$.messager.alert("提示","请选择医嘱","info");
		return false;
	}
	
    var flag=""
	var flag=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetReportStaus",OEORIRowIdStr);
	if((flag=="已复检")||(flag=="已发送")||(flag=="已打印"))
	{
		if (!confirm("报告状态是："+flag+", 确定要进行该操作吗")) return;
		
	} 
   
	var RefuseCodeStr="";
	var Arr=OEORIRowIdStr.split("^");
	var Length=Arr.length;
	for (var i=0;i<Length;i++)
	{ 
		var OEORIRowId=Arr[i];
		
		var obj=document.getElementById("RefuseReason");
		if (obj){OEORIRowId=OEORIRowId+"^"+obj.value;}
		var RefuseCode=tkMakeServerCall("web.DHCPE.ResultEdit","RefuseCheck",OEORIRowId)
	
	if(RefuseCodeStr==""){var RefuseCodeStr=RefuseCode;}
	else{var RefuseCodeStr=RefuseCodeStr+"^"+RefuseCode;}
	
	}
	
	var RefuseArr=RefuseCodeStr.split("^");
	var RefuseLength=RefuseArr.length;
	var j=0
	for (var ii=0;ii<RefuseLength;ii++)
	{ 
		if(RefuseArr[ii]=="0") {j++;} 
	
	}
	if(ii==j){var flag="0";}
	if(RefuseCodeStr.indexOf("-1")>=0){var flag="-1";}
	if (flag=='0') {
		
		$.messager.alert("提示","修改成功!","success");
		
		}
	else if(flag=="-1")
	{
		
		$.messager.alert("提示","已执行项目不能再进行操作","info");
		
	}else{
		
		$.messager.alert("提示","拒绝失败","info");
   		
}
	$("#RefuseReason").val("");
	 $("#tDHCPEIAdmItemStatusDetail").datagrid('load',{ComponentID:55990,AdmId:$("#AdmId").val()}); 
	
}


function GetId(){
	
	var IDStr="";
	 var objtbl = $("#tDHCPEIAdmItemStatusDetail").datagrid('getRows');
    var rows=objtbl.length
    //alert(rows+"rows")
	for (var i=0;i<rows;i++)
	{ 
		var TSelect=getCmpColumnValue(i,"TSelect","DHCPEIAdmItemStatusDetail");
		//alert(TSelect)
	    if (TSelect=="1"){
		     var ID=objtbl[i].TId;
		     if(IDStr==""){var IDStr=ID;}
			else{var IDStr=IDStr+"^"+ID;}		   
	    } 
		
	}
 
	return IDStr;	
	
}

function BSend_Click()
{
	
	 var objtbl = $("#tDHCPEIAdmItemStatusDetail").datagrid('getRows');
	 if(SelectedRow=="-1"){
		 top.$.messager.alert("提示","请先选择待发送消息的医嘱","info");
		 return false;
	 }
	 var OEORID=objtbl[SelectedRow].TId;	
	 
	var obj,encmeth="";
	obj=document.getElementById("SendInfoClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,OEORID);
	if(ret.split("^")[0]="-1")
	{
		top.$.messager.alert("提示",ret.split("^")[1],"info");
	}
	return false;
}

function BCancelSend_Click()
{
	var objtbl = $("#tDHCPEIAdmItemStatusDetail").datagrid('getRows');
	 if(SelectedRow=="-1"){
		top.$.messager.alert("提示","请先选择待取消发送消息的医嘱","info");
		 return false;
	 }
	 var OEORID=objtbl[SelectedRow].TId;	
	 
	var obj,encmeth="";
	obj=document.getElementById("CancelSendInfoClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,OEORID);
	if(ret.split("^")[0]="-1")
	{
		top.$.messager.alert("提示",ret.split("^")[1],"info");
		
	}
	return false;

}


function BUpdateSpec_click()
{
	var obj,Source="",To="",encemth="";
	obj=document.getElementById("Source");
	if (obj) Source=obj.value;
	obj=document.getElementById("To");
	if (obj) To=obj.value;
	if (Source=="")
	{
		top.$.messager.alert("提示","原标本号不能为空","info");
		return false;
	}
	if (To=="")
	{
		top.$.messager.alert("提示","更新标本号不能为空","info");
		return false;
	}
  if(Source==To){
		$.messager.alert("提示","原标本号和新标本号一样,无需更新","info");
		return false;
	}
	var AdmId=$("#AdmId").val()
	
	var flag=tkMakeServerCall("web.DHCPE.BarPrint","IsUpdateSpec",AdmId,To);
	if(flag!="1"){
		top.$.messager.alert("提示","新标本号不是本人没执行过的标本号,请重新输入","info");
		return false;
		
	}

	//s val=##Class(%CSP.Page).Encrypt($lb("web.DHCPE.BarPrint.UpdateSpec"))

	obj=document.getElementById("UpdateSpecClass");
	if (obj) encemth=obj.value;
	var ret=cspRunServerMethod(encemth,Source,To);
	window.location.reload();
}


var SelectedRow=-1;
function SelectRowHandler(index,rowdata) {
	SelectedRow=index;
	if(index==SelectedRow)
	{	
		 var LabNo=rowdata.TLabNo;
	    setValueById("Source",LabNo);
	    var SourceLabNo=getValueById("Source");
	       var Status=rowdata.TStatus;
		if((Status=="取消体检")||(Status=="谢绝检查")||(Status=="执行")||(LabNo=="")){
			$("#BUpdateSpec").linkbutton('disable');
			$("#To").attr('disabled',true);
		
		}else{
			$("#BUpdateSpec").linkbutton("enable");
			$("#To").attr('disabled',false);
			             
		}


	  	
	}else
	{
		
		SelectedRow=-1;
		
	}
}

function Save_Click()
{ 

	var Strings=GetNotPrintInfo();
	if (Strings=="") return;
	var encmethobj=document.getElementById("NoPrintClass");
	if (encmethobj) var encmeth=encmethobj.value;
	var ReturnStr=cspRunServerMethod(encmeth,Strings);
	if (ReturnStr==0)
	{   
		 $.messager.alert("提示", "保存成功", 'success');
	  $("#tDHCPEIAdmItemStatusDetail").datagrid('load',{ComponentID:55990,AdmId:$("#AdmId").val()}); 

	}
	else
	{
		$.messager.alert("提示", ReturnStr, 'success');
		return
	}
}

function GetNotPrintInfo()
{   var  isPrint=""
	var Strings=""
	var CurRow=-1;
	var objtbl = $("#tDHCPEIAdmItemStatusDetail").datagrid('getRows');
    var rows=objtbl.length;
	for (var j=0;j<rows;j++) {
			
		var sPrint=getCmpColumnValue(j,"TNotPrint","DHCPEIAdmItemStatusDetail");
		if(sPrint=="1"){var isPrint="Y";}
		else{var isPrint="N"; }	
		var strCell=isPrint;
		if (CurRow!=j&&CurRow!="-1") continue;
		if (strCell!=""){
			 var OEID=objtbl[j].TId;
			if (OEID!=""){
				if (Strings==""){Strings=OEID+";"+strCell;}
				else{Strings=Strings+"^"+OEID+";"+strCell;}
			}
		}
	}
	//alert(Strings)
	return Strings;
}



function trim(s) {
	if (""==s) { return "";}
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
    return (m == null) ? "" : m[1];
}

function InitListInfo()
{
	var status,i,objChk;
	
	
	var objtbl = $("#tDHCPEIAdmItemStatusDetail").datagrid('getRows');
	//alert(objtbl+"objtbl")
    var rows=objtbl.length
	//alert(rows+"rows")
	
	
	var objtbl=document.getElementById('tDHCPEIAdmItemStatusDetail');
	if (!objtbl) return;
	
	var rows=objtbl.rows.length; 
	for (i=1;i<=rows;i++)
	{
		
		var statusobj=document.getElementById('TDrugStatusz'+i);
		if(statusobj) status=statusobj.innerText;
		
		if (status=="已发药")
		{
			
			objChk=document.getElementById('TCheckedz'+i);
			if (objChk)
			{
			objChk.disabled=false;
			objChk.onclick=Chk_Click;
			}
		}		
	}	
}


function Chk_Click()
{
	var eSrc = window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var BillStatus;
	
	var BillStatusObj=document.getElementById('TBillStatusz'+selectrow)
	if(BillStatusObj){
		BillStatus=BillStatusObj.innerText;
	}
	//已付费药品请去退费申请界面
	if(BillStatus !="挂帐")
	{
		alert(t['HadPayed'])
		return false;
		
	}
	var addflag=eSrc.checked;
	
	
	var feeid="1"+"^"+GetCtlValueById('TPreItemIDz'+selectrow);
	//药品权限控制 如果已退药不允许取消申请
	var enControl=document.getElementById("DrugPermControl");
	if(enControl){
		var encmeth=enControl.value;
	}
	var flag=cspRunServerMethod(encmeth,feeid,"0")
	
	if (flag=="1") 
	{alert(t['HadDropDrug']);
	 return false;}
	var SelectId;
	if (addflag)
	{			
		SelectId=feeid;
		
	}
	else
	{	
		SelectId=""
	}
	//alert(SelectId)
	
	
	//将selectId保存到临时的global中
	
	var encache=document.getElementById("SetApplyDrug");
	if(encache){
		encache=encache.value;
	}
	var oeori=GetCtlValueById('TIdz'+selectrow);
	var flag=cspRunServerMethod(encache,SelectId,oeori);
	if(flag==1){
		if(addflag)
		alert("申请成功")
		else(alert("取消申请成功"))
	}
	
}
 
function BPrintBChao_Click()
{
	var obj,IAdmId="",OEID="";
	obj=document.getElementById("txtIAdmId");
	if (obj) IAdmId=obj.value;
	OEID=GetId();
	if (OEID==""){
		alert("请选择打印项目")
		return false;
	}
	//alert(IAdmId+"^"+OEID)
	PrintBChaoReport(IAdmId,OEID);
}
document.body.onload = Ini;
