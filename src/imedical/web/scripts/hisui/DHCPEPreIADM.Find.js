

//名称	DHCPEPreIADM.Find.js
//组件  DHCPEPreIADM.Find
//功能	个人预约查询
//创建	2018.09.07
//创建人  xy
var myItemNameAry=new Array();
var myCombAry=new Array();
//document.write("<object ID='ClsIDCode' WIDTH=0 HEIGHT=0 CLASSID='CLSID:299F3F4E-EEAA-4E8C-937A-C709111AECDC' CODEBASE='../addins/client/ReadPersonInfo.CAB#version=1,0,0,8' VIEWASTEXT>");
//document.write("</object>");


var TFORM="tDHCPEPreIADM_Find";
var CurrentSel=0;
var ReportWin;


/*
var onAfterRender = $.fn.datagrid.defaults.view.onAfterRender;
        $.extend($.fn.datagrid.defaults.view, {
            onAfterRender: function(target){
                onAfterRender.call(this, target);
                //隐藏合计行图标 
               hiddenTableIcon("DHCPEPreIADM_Find","PIADM_RowId","TSeclect");
               hiddenTableIcon("DHCPEPreIADM_Find","PIADM_RowId","TPatItemPrtFlag");
               	            
	           hiddenTableIcon("DHCPEPreIADM_Find","PIADM_RowId","PrintBarCode");  
 	           hiddenTableIcon("DHCPEPreIADM_Find","PIADM_RowId","PIADM_ItemList"); 
			   hiddenTableIcon("DHCPEPreIADM_Find","PIADM_RowId","TItemListNew"); 
			   hiddenTableIcon("DHCPEPreIADM_Find","PIADM_RowId","THMS"); 
 	           hiddenTableIcon("DHCPEPreIADM_Find","PIADM_RowId","PIADM_AsCharged");
 	           hiddenTableIcon("DHCPEPreIADM_Find","PIADM_RowId","TMark"); 
			   hiddenTableIcon("DHCPEPreIADM_Find","PIADM_RowId","TDiet");
			     //列表checkbox元素不可编辑
			   DiaabledTableIcon("DHCPEPreIADM_Find","TPatItemPrtFlag");
			   DiaabledTableIcon("DHCPEPreIADM_Find","TDiet");


            }
});
*/
/*
//增加可编辑列表
var editFlag="undefined";
$('#tDHCPEPreIADM_Find').datagrid({
	//单击行结束编辑
	onSelect: function (rowIndex, rowData) {	
		if (editFlag!="undefined") 
		{
	    	jQuery('#tDHCPEPreIADM_Find').datagrid('endEdit', editFlag);
	    	//EditRowColor();
	    	editFlag="undefined";
	    	var Mark=rowData.TMark;
			var PIADM=rowData.PIADM_RowId;
			
			//alert(PIADM+"^"+Mark)
			if(PIADM!="") {
			var rtn=tkMakeServerCall("web.DHCPE.PreIADM","UpDateMark",PIADM,Mark)
			}
	    }
    },
})

//双击行开始编辑
function DblClickRowHandler(index,rowdata)	{
		
	var Value1=$('#tDHCPEPreIADM_Find').datagrid('getColumnOption','TMark');
	//alert(Value1)
	Value1.editor={type:'validatebox'};
	if (editFlag!="undefined")
	{
    	jQuery('#tDHCPEPreIADM_Find').datagrid('endEdit', editFlag);
    	editFlag="undefined"
	}
    jQuery('#tDHCPEPreIADM_Find').datagrid('beginEdit', index);
    editFlag =index;
}
*/


function BodyLoadHandler() {
 	//alert('s')
 	
	var obj;
	
	//设置按钮大小
	$("#BFind").css({"width":"130px"});
	$("#BModifyTest").css({"width":"130px"});
	$("#BPrint").css({"width":"130px"});
	$("#ReadRegInfo").css({"width":"130px"});
	$("#BReadCard").css({"width":"130px"});
	$("#PrintPayAagin").css({"width":"130px"});
	$("#BPreviewReport").css({"width":"130px"});
	$("#BPrintView").css({"width":"130px"});
	$("#BUpdateVIPLevel").css({"width":"130px"});
	$("#BUpdateDepart").css({"width":"130px"});
	$("#BSaveRemark").css({"width":"130px"});
	
	//$("#BUnArrived").css({"width":"130px","HEIGHT":"30px"," background-color":"yellow"});
	
	//$("#CardTypeDefine").css({"width":"130px","HEIGHT":"30px","class":"hisui-combobox"});
	
	//查询
	obj=document.getElementById("BFind");
	if (obj){ obj.onclick=BFind_click; }
	
	//取消体检
	obj=document.getElementById("CancelPE");
	if (obj){ obj.onclick=CancelPE; }

	//撤销取消体检
	obj=document.getElementById("UnCancelPE");
	if (obj){ obj.onclick=UnCancelPE; }
	
	//到达/取消到达
	obj=document.getElementById("BUnArrived");
	if (obj){ obj.onclick=IAdmAlterStatus; }
	
	//取消/视同收费
	obj=document.getElementById("BAsCharged");
	if (obj){ obj.onclick=UpdateAsCharged; }
	
	//费用
	obj=document.getElementById("BFee");
	if (obj){ obj.onclick=UpdatePreAudit; }
	
    obj=document.getElementById("BUpdateDepart");
	if (obj){ obj.onclick=BUpdateDepart_click; }
	
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }
	
	obj=document.getElementById("RegNo");
	if (obj){ obj.onkeydown=RegNo_KeyDown;
		obj.onblur=RegNo_onblur;
	}
	
	obj=document.getElementById("Name");
	if (obj){ obj.onkeydown=RegNo_KeyDown;}
	
	// 预约
	obj=document.getElementById("Status_PREREG");
	if (obj){ obj.onclick=Status_PREREG_click; }
	
	// 不需审核
	obj=document.getElementById("Status_NOCHECKED");
	if (obj){ obj.onclick=Status_PREREG_NoALL; }
	
	// 需审核
	obj=document.getElementById("Status_UNCHECKED");
	if (obj){ obj.onclick=Status_PREREG_NoALL; }
	
	// 已审核
	obj=document.getElementById("Status_CHECKED");
	if (obj){ obj.onclick=Status_PREREG_NoALL; }
	
	// 修改预约信息
	obj=document.getElementById("Update");
	if (obj){
		obj.onclick=Update_click;
	    websys_disable(obj);
	}
	obj=document.getElementById("BAudit");
	if (obj){
		obj.onclick=BAudit_click;
	
	}
	// 放弃预约
	obj=document.getElementById("CancelADM");
	if (obj){
		obj.onclick=CancelADM_click;
		websys_disable(obj);
	}

	// 预约
	obj=document.getElementById("BPreOver");
	if (obj){
		obj.onclick=CancelADM_click;
		websys_disable(obj);
	}
	
	//修改项目
	$("#BModifyTest").click(function() {
			
			BModifyTest_click();	
			
        });
	
	
	
	obj=document.getElementById("CardNo");
	if (obj) {
		//obj.onchange=CardNo_Change;
		obj.onkeydown=CardNo_keydown;
	}


   //读卡
	obj=document.getElementById("BReadCard");
	//if (obj) {obj.onclick=ReadCard_Click;}
	if (obj) {obj.onclick=ReadCardClickHandler;}

	
	obj=document.getElementById("GroupDesc")
	if (obj) { obj.onchange=GroupDesc_Change; }
	
	obj=document.getElementById("TeamDesc");
	if (obj) { obj.onchange=TeamDesc_Change; }

    //打印
    obj=document.getElementById("BPrint")
    if (obj) {
           obj.onclick=BPrint_click;  
     }
    ///指引单打印预览
    obj=document.getElementById("BPrintView")
    if (obj) {
	       obj.onclick=PatItemPrintXH;  
	 }
	///补打收费条码
	obj=document.getElementById("PrintPayAagin")
	if (obj) {
		   obj.onclick=PrintPayAagin_Click;
	}
	///发送申请单
	obj=document.getElementById("BSendRequest")
	if (obj) obj.onclick=SendRequest_click;

    ///全选
	$('#BSelect').checkbox({
		onCheckChange:function(e,vaule){
			BSelect_change(vaule);
			
			}
			
	});
	
    ///报告预览
	obj=document.getElementById("BPreviewReport")
	if (obj) obj.onclick=PreviewAllReport;
	
   	//读身份证
   	var myobj=document.getElementById("ReadRegInfo");
    if (myobj)
	{
		myobj.onclick=ReadRegInfo_OnClick;
		myobj.onkeydown=Doc_OnKeyDown;
	}
	var obj=document.getElementById("HpNo");
	if (obj){ obj.onkeydown=HpNo_KeyDown;
		obj.onblur=HpNo_onblur;
	}
	
	var obj=document.getElementById("BUpdateVIPLevel");
	if (obj){ obj.onclick=BUpdateVIPLevel_click; } 
	
	//保存备注
	$("#BSaveRemark").click(function() {
			
			BSaveRemark_click();	
			
        });
	iniForm();
	
	//卡类型初始化
	//initialReadCardButton();
	//initButtonWidth();	
	
   	Muilt_LookUp('GroupDesc'+'^'+'TeamDesc');
   	websys_setfocus("RegNo");


	
   	  //隐藏合计行图标
	$("#tDHCPEPreIADM_Find").datagrid('options').view.onAfterRender = function(){
	     	  
	 	      //隐藏合计行图标 
               hiddenTableIcon("DHCPEPreIADM_Find","PIADM_RowId","TSeclect");
               hiddenTableIcon("DHCPEPreIADM_Find","PIADM_RowId","TPatItemPrtFlag");
               	            
	           hiddenTableIcon("DHCPEPreIADM_Find","PIADM_RowId","PrintBarCode"); 
 	           hiddenTableIcon("DHCPEPreIADM_Find","PIADM_RowId","PIADM_ItemList"); 
			   hiddenTableIcon("DHCPEPreIADM_Find","PIADM_RowId","TItemListNew"); 
			   hiddenTableIcon("DHCPEPreIADM_Find","PIADM_RowId","THMS"); 
 	           hiddenTableIcon("DHCPEPreIADM_Find","PIADM_RowId","PIADM_AsCharged");
 	          // hiddenTableIcon("DHCPEPreIADM_Find","PIADM_RowId","TMark"); 
			   hiddenTableIcon("DHCPEPreIADM_Find","PIADM_RowId","TDiet");
			   
			     //列表checkbox元素不可编辑
			  DiaabledTableIcon("DHCPEPreIADM_Find","TPatItemPrtFlag");
			  DiaabledTableIcon("DHCPEPreIADM_Find","TDiet");
			   
			   
			   //重新设置datagrid的高度
			   if ($('#tDHCPEPreIADM_Find').length==0) return ;
				var h = $(window).height();
				var offset = $('#tDHCPEPreIADM_Find').closest('.datagrid').offset();
 				if (!offset) return ;
					$('#tDHCPEPreIADM_Find').datagrid('resize',{height:parseInt(h-offset.top-13)});
 	           
		 } 
   
}
function BSaveRemark_click(){
	
	var iTAdmId="",Remark="";
 	var TAdmIdStr=GetSelectPIADM() ;
	var TAdmIds=TAdmIdStr.split(";")
    var iLRemark=getValueById("LRemark")
    if(iLRemark==""){
		 $.messager.alert("提示","请填写备注","info");
		return false;
		}

	for(var PSort=0;PSort<TAdmIds.length;PSort++)
	{
		var iTAdmId=TAdmIds[PSort]; //paadm
		if (iTAdmId=="") { 
	    	$.messager.alert("提示","您没有选择客户","info");
	   		return false;    
		}
	   if(iTAdmId!=""){
      	var rtn=tkMakeServerCall("web.DHCPE.PreIADM","UpDateMark",iTAdmId,iLRemark)
     }
	
	}
	BFind_click();
	
}

function GetSelectIdNew() 
{ 
	var objtbl = $("#tDHCPEPreIADM_Find").datagrid('getRows');
    var rows=objtbl.length;
   	var IDs="";
	for (var i=0;i<rows;i++)
	{
		var TSelect=getCmpColumnValue(i,"TSeclect","DHCPEPreIADM_Find");
		var PIADM=objtbl[i].PIADM_RowId;
		if(PIADM==""){
			break;
		}
 
	    if (TSelect=="1"){
		    var OneID=objtbl[i].PIADM_RowId;
			if (IDs==""){
				IDs=OneID+";"+i;
			}else{
				IDs=IDs+"^"+OneID+";"+i;
			}

	 }
	}
	
    return IDs;
}

function GetSelectId() 
{   
	var vals="",val="";
	var objtbl = $("#tDHCPEPreIADM_Find").datagrid('getRows');
    var rows=objtbl.length
    for (var i=0;i<rows;i++)
	{

		var TSelect=getCmpColumnValue(i,"TSeclect","DHCPEPreIADM_Find")
	    if (TSelect=="1"){
			var val=objtbl[i].TAdmIdPIDM;
			if (val==" ") continue;
			if (vals=="") {vals=val;}
			else {vals=vals+";"+val;}
		 
	   }
	}
	//if (""==vals) { alert("未选择受检人,操作中止!"); }
	return vals;
}
function GetSelectPIADM() 
{   
	var vals="",val="";
	var objtbl = $("#tDHCPEPreIADM_Find").datagrid('getRows');
    var rows=objtbl.length
    for (var i=0;i<rows;i++)
	{

		var TSelect=getCmpColumnValue(i,"TSeclect","DHCPEPreIADM_Find")
	    if (TSelect=="1"){
			var val=objtbl[i].PIADM_RowId;
			if ((val==" ")||(val=="")) continue;
			if (vals=="") {vals=val;}
			else {vals=vals+";"+val;}
		 
	   }
	}
	return vals;
}
function BUpdateVIPLevel_click()
{
	
	var iTAdmId="",iVIP="";
	//var TAdmIdStr=GetSelectId() ;
 var TAdmIdStr=GetSelectPIADM() ;
	var TAdmIds=TAdmIdStr.split(";")
    var iVIP=getValueById("VIPLevel")
    if(iVIP==""){
		 $.messager.alert("提示","请选择VIP等级后再更新","info");
		return false;}
	for(var PSort=0;PSort<TAdmIds.length;PSort++)
	{
		var iTAdmId=TAdmIds[PSort]; //paadm
		if (iTAdmId=="") { 
	    	$.messager.alert("提示","您没有选择客户","info");
			websys_setfocus("RegNo");
	   		return false;    
		}
	   if(iTAdmId!=""){
         var flag=tkMakeServerCall("web.DHCPE.PreItemListEx","ChangeVipLevel",iTAdmId,iVIP);
        //if(flag==0){location.reload();}
     }
	
	}
	BFind_click();
	//location.reload();
	
}
function Doc_OnKeyDown()
   { 
	  
	   if (event.keyCode==115)
       {
		ReadRegInfo_OnClick();
       }
   }
function ReadRegInfo_OnClick()
  {
	 
	//var myInfo=ClsIDCode.ReadPersonInfo();
   	
	var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
	var rtn=tkMakeServerCall("DHCDoc.Interface.Inside.Service","GetIECreat")
	var myHCTypeDR=rtn.split("^")[0];
	var myInfo=DHCWCOM_PersonInfoRead(myHCTypeDR);
    var myary=myInfo.split("^");

     if (myary[0]=="0")
     { 
     
      SetPatInfoByXML(myary[1]); 
      var mySexobj=document.getElementById("Sex");
	  var myBirobj=document.getElementById("Birth");
	  var mycredobj=document.getElementById("CredNo");
	  var myidobj=document.getElementById('IDCard');
		if ((mycredobj)&&(myidobj)){
			myidobj.value=mycredobj.value;
		} 
     }
   
     
	 var RegNo=tkMakeServerCall("web.DHCPE.PreIBaseInfo","GetRegNoByIDCard",mycredobj.value);
	 if (RegNo==""){
		return false;
	}
	var obj=document.getElementById("RegNo");
	if (obj){
		obj.value=RegNo;
		BFind_click();
	}
     
   }

function SetPatInfoByXML(XMLStr)
{
	XMLStr = "<?xml version='1.0' encoding='gb2312'?>" + XMLStr
	var xmlDoc=DHCDOM_CreateXMLDOMNew(XMLStr);
	if (!xmlDoc) return;
	
	//var xmlDoc=DHCDOM_CreateXMLDOM();
	//xmlDoc.async = false;
	//xmlDoc.loadXML(XMLStr);
	/*
	if(xmlDoc.parseError.errorCode != 0) 
	{    
		$.messager.alert("提示",xmlDoc.parseError.reason,"info");
		return; 
	}
	*/
	var nodes = xmlDoc.documentElement.childNodes;
	if (nodes.length<=0){return;}
	for (var i = 0; i < nodes.length; i++) {

		
		//var myItemName=nodes(i).nodeName;
		//var myItemValue= nodes(i).text;
		
		var myItemName = getNodeName(nodes,i);
		
		var myItemValue = getNodeValue(nodes,i);
		
	   if(myItemName=="Name") $("#Name").val(myItemValue);
	  
		
		
		if (myCombAry[myItemName]){
			myCombAry[myItemName].setComboValue(myItemValue);

		}else{
			DHCWebD_SetObjValueXMLTrans(myItemName, myItemValue);
		}
	}
	delete(xmlDoc);
}

function HpNo_KeyDown(e){
	
	var Key=websys_getKey(e);
	if ((13==Key)) {
		obj=document.getElementById("HpNo");
		if(obj) var HpNo=obj.value
		var RegNo=tkMakeServerCall("web.DHCPE.PreIBaseInfo","GetRegNoByHpNo",HpNo);
	 	if (RegNo==""){
		return false;
		}
		var obj=document.getElementById("RegNo");
		if (obj){
		obj.value=RegNo;
		}
		BFind_click();
	}
}
function HpNo_onblur()
{
	var Src=window.event.srcElement;
	Src.value=Src.value;
	//Src.selection.empty();
}

function BUpdateDepart_click()
{

	var objtbl = $("#tDHCPEPreIADM_Find").datagrid('getRows');
    var rows=objtbl.length;
   var IDs=""
	for (var i=0;i<rows;i++)
	{
		var TSelect=getCmpColumnValue(i,"TSeclect","DHCPEPreIADM_Find");
		var PIADM=objtbl[i].PIADM_RowId;
		if(PIADM==""){
			break;
		}

	    if (TSelect=="1"){
		    var OneID=objtbl[i].PIADM_RowId;
			if (IDs==""){
				IDs=OneID;
			}else{
				IDs=IDs+"^"+OneID;
			}

	 }
	}
	
	if (IDs=="") {
		$.messager.alert("提示","请选择人员","info");
		return;
		} 
		
	var obj,encmeth="",DepartName="";
	obj=document.getElementById("DepartClass");
	if (obj) encmeth=obj.value;
	DepartName=getValueById("DepartName");
	
	var AdmIdStr=IDs.split("^");
    
    for(i=0;i<AdmIdStr.length;i++)
 	{ 
 		var AdmId=AdmIdStr[i]
 		//alert(AdmId)
	    var Info=cspRunServerMethod(encmeth,AdmId,DepartName);
 	}
	
	$.messager.alert("提示","设置完成","success");
	BFind_click();
	//location.reload();
}





function BSelect_change(value)
{

	if (value==true) 
	{
		var SelectAll=1;
	}
	else
	{ 
		var SelectAll=0;
	}
	var objtbl = $("#tDHCPEPreIADM_Find").datagrid('getRows');
    var rows=objtbl.length
	for (var i=0;i<rows;i++)
	{   
		setColumnValue(i,"TSeclect",SelectAll)
	
	}	
}

/*
function PreviewAllReport()
{
	var iReportName="",iEpisodeID="";
	obj=document.getElementById("ReportNameBox");
	if (obj) { iReportName=obj.value; }
	var TAdmIdStr=GetSelectId() ;
	var TAdmIds=TAdmIdStr.split(";")
	for(var PSort=0;PSort<TAdmIds.length;PSort++)
	{
		var iTAdmId=TAdmIds[PSort];
		
		if (iTAdmId=="") { 
	    	$.messager.alert("提示","您没有选择客户,或者没有登记","info");
			websys_setfocus("RegNo");
	   		return false;    
		}
	
		var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no'
			+',left=0'
			+',top=0'
			+',width='+window.screen.availWidth
			+',height='+(window.screen.availHeight-40)
			;
		var lnk=iReportName+"?PatientID="+iTAdmId;
		if (ReportWin) ReportWin.close();
		ReportWin=window.open(lnk,"ReportWin",nwin)
	}
}
*/
document.write("<script language='javascript' src='../SCRIPTS/DHCPEPrintReportCommon.js'></script>")
function PreviewAllReport()
{
		var iReportName=""; 
	var NewVerReportFlag=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",session['LOGON.CTLOCID'],"NewVerReport");
	obj=document.getElementById("ReportNameBox");
	if (obj) { iReportName=obj.value; }
	if(selectrow=="-1"){
		$.messager.alert("提示","您没有选择客户","info");
		return false;
		}
	var objtbl = $("#tDHCPEPreIADM_Find").datagrid('getRows');
  	PAADM=objtbl[selectrow].TAdmIdPIDM;
  	
	if (PAADM=="") { 
			$.messager.alert("提示","您没有选择客户,或者没有登记","info");
			websys_setfocus("RegNo");
	   		 return false; 
		}
	    if(NewVerReportFlag=="Lodop"){

			var Flag=tkMakeServerCall("web.DHCPE.PreIADM","IsHaveResultByPAADM",PAADM);
			if(Flag=="0"){
				$.messager.alert("提示","没有体检结果，不能预览","info");
				 return false; 
			}

			//calPEReportProtocol("BPrintView",PAADM);
			PEPrintReport("V",PAADM,""); //lodop+csp预览体检报告
			return false;
		}else if(NewVerReportFlag=="Word"){	
			var Flag=tkMakeServerCall("web.DHCPE.PreIADM","IsHaveResultByPAADM",PAADM);
			if(Flag=="0"){
				$.messager.alert("提示","没有体检结果，不能预览","info");
				 return false; 
			}
			calPEReportProtocol("BPrintView",PAADM);
			return false;
		}else{
			var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no'
			+',left=0'
			+',top=0'
			+',width='+window.screen.availWidth
			+',height='+(window.screen.availHeight-40)
			;
		var lnk=iReportName+"?PatientID="+PAADM;
		if (ReportWin) ReportWin.close();
		ReportWin=window.open(lnk,"ReportWin",nwin)
	}
	
}

function calPEReportProtocol(sourceID,jarPAADM){
	var opType=(sourceID=="BPrint"||sourceID=="NoCoverPrint")?"2":(sourceID=="BPrintView"?"5":"1");
	if(opType=="2"){
		jarPAADM=jarPAADM+"@"+session['LOGON.USERID'];
	}
	var saveType=sourceID=="BExportPDF"?"pdf":(sourceID=="BExportHtml"?"html":"word"); 
	var printType=sourceID=="NoCoverPrint"?"2":"1";
	location.href="PEReport://"+jarPAADM+":"+opType+":"+saveType+":"+printType
}


function RegNo_onblur()
{
	var Src=window.event.srcElement;
	Src.value=Src.value;
	//Src.selection.empty();
}
function SendRequest_click()
{
	var iRowId=""
	//alert(CurrentSel)
	if (CurrentSel==0) return;
	
	obj=document.getElementById("RowId");
	if (obj){ iRowId=obj.value; }
	//alert(iRowId)
	if (iRowId=="") return;
	var obj,encmeth="";
	obj=document.getElementById("GetPAADMID");
	if (obj) encmeth=obj.value;
	var Info=cspRunServerMethod(encmeth,iRowId);
	//alert(Info)
	if (Info=="") return false;
	var Arr=Info.split("^");
	var PAADM=Arr[0];
	var PatID=Arr[1];
	var MRAdm=Arr[2];
	var url="diagnosentry.csp?EpisodeID="+PAADM+"&PatientID="+PatID+"&mradm="+MRAdm;
  	var ret=window.showModalDialog(url, "", "dialogwidth:1000px;dialogheight:600px;center:1"); 
	var url="dhcrisappbill.csp?EpisodeID="+PAADM+"&PatientID="+PatID;
	var wwidth=1250;
	var wheight=650;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = ((screen.height - wheight) / 2)-10;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	window.open(url,"_blank",nwin)
}

function CardNo_keydown(e)
{
	var key=websys_getKey(e);
	if (13==key) {
		CardNo_Change();
	}
}

function CardNo_Change()
{
	var CardNo=$("#CardNo").val();
	if (CardNo==""){
		$("#CardTypeNew").val("");
	}
	if (CardNo=="") return;
		var myrtn=DHCACC_GetAccInfo("",CardNo,"","",CardTypeCallBack);
		return false;
	
	

}

//读卡
function ReadCardClickHandler(){
	var myrtn=DHCACC_GetAccInfo7(CardTypeCallBack);
}

function CardTypeCallBack(myrtn){
   var myary=myrtn.split("^");
   var rtn=myary[0];
	switch (rtn){
		case "0": //卡有效有帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").focus().val(CardNo);
			$("#RegNo").val(PatientNo);
			$("#CardTypeNewID").val(CardTypeNewID);
			BFind_click();
			event.keyCode=13; 
			break;
		case "-200": //卡无效
			$.messager.alert("提示","卡无效","info",function(){$("#CardNo").focus();});
			break;
		case "-201": //卡有效无帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").focus().val(CardNo);
			$("#RegNo").val(PatientNo);
			$("#CardTypeNewID").val(CardTypeNewID);
			BFind_click();
			event.keyCode=13;
			break;
		default:
	}
}

/*
function ReadCard_Click()
{
	ReadCardApp("RegNo","BFind_click()","CardNo");
	
}
*/
function BAudit_click()
{
	var iRowId=""
	if (CurrentSel==0) return;
	obj=document.getElementById("RowId");
	if (obj){ iRowId=obj.value; }
	if (iRowId=="") return;
	var Ins=document.getElementById('AuditClass');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,iRowId)
	if (flag==0)
	{
		alert("更新成功")
	}
}
function iniForm(){
	var obj;
	obj=document.getElementById("Status");
	if (obj) { SetStatus(obj.value); }
	
	var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSendPisFBWay");
	if(flag!="B"){
		/*obj=document.getElementById("PrintPisRequest");
		if(obj){ obj.style.display="none";}
		*/
		/*
		$("#PrintPisRequest").parent(".hischeckbox_square-blue").css("display","none");
		obj=document.getElementById("cPrintPisRequest");
		if(obj){ obj.style.display="none";}
		*/
		$("#PrintPisRequest").checkbox("disable");
	}
	
	var UserDR=session['LOGON.USERID'];
	var OPflag=tkMakeServerCall("web.DHCPE.ChargeLimit","GetOPChargeLimitInfo",UserDR); 
	var OPflagOne=OPflag.split("^");
	//alert(OPflag)
	if(OPflagOne[1]=="0"){
		DisableBElement("BAsCharged",true);

		}
	if(OPflagOne[0]=="0"){
		DisableBElement("BFee",true);
		
		}
	//ShowCurRecord(0);
	document.onkeydown=Doc_keyDown;
}
function Doc_keyDown()
{
	var Key=websys_getKey(e);
	if ((117==Key)){
		BPrint_click();
	}
}
function RegNo_KeyDown(e){
	
	var Key=websys_getKey(e);
	if ((13==Key)) {
		BFind_click();
	}
}
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];

}
function   getURL(url)
{
	var   xmlhttp   =   new   ActiveXObject("Microsoft.XMLHTTP");
	xmlhttp.open("GET",url,false);
	xmlhttp.send();
	if   (xmlhttp.readyState==4)
	{
		if(xmlhttp.Status!=200){
			alert("不存在");
			return true;
		}
	}
	alert("存在")
	return   false;
} 
function BFind_click() {
	
	$("#BModifyTest,#BPrint,#BPrintView,#PrintPayAagin,#BPreviewReport,#BUpdateVIPLevel,#BUpdateDepart").linkbutton("enable");
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	iRegNo=getValueById("RegNo");
	if (iRegNo.length<RegNoLength&&iRegNo.length>0) { 
		iRegNo=RegNoMask(iRegNo);
		$("#RegNo").val(iRegNo);
	}

	var iCardTypeNew=getValueById("CardTypeNew");
	var iCardNo=getValueById("CardNo");
	
	var iName=getValueById("Name");
	iName=trim(iName);
	
	var iPEDate=getValueById("PEStDate");
	
	var iPETime=getValueById("PETime");
	
    var iVIP=getValueById("VIPLevel");
   
	iStatus=GetStatus();
	
	iChargedStatus=getValueById("ChargeStatus");

	iCheckedStatus=GetCheckedStatus();
	if (""!=iCheckedStatus) { iStatus=iStatus+"^PREREG"; }
	
	var iPEEndDate=getValueById("EndDate");
	
	var iGroupID=getValueById("GroupID");
	
    var iTeamID=getValueById("TeamID");
    
    var iDepartName=getValueById("DepartName");
	
	var ReCheck=getValueById("ReCheck");
    
    var iSex=getValueById("SexDR");

	var iRoomPlace=getValueById("RoomPlace");
  
 	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEPreIADM.Find"
			+"&RegNo="+iRegNo
			+"&Name="+iName
			+"&PEStDate="+iPEDate
			+"&PETime="+iPETime
			+"&Status="+iStatus
			+"&ChargedStatus="+iChargedStatus
			+"&CheckedStatus="+iCheckedStatus
			+"&EndDate="+iPEEndDate
			+"&GroupID="+iGroupID
			+"&TeamID="+iTeamID
			+"&DepartName="+iDepartName
			+"&VIPLevel="+iVIP
			+"&RoomPlace="+iRoomPlace
			+"&ReCheck="+ReCheck
			+"&RFind=1"
			+"&SexDR="+iSex
			+"&CardNo="+iCardNo
			+"&CardTypeNew="+iCardTypeNew
	;
	//alert(lnk)
 var HospID=session['LOGON.HOSPID']
$("#tDHCPEPreIADM_Find").datagrid('load',{ComponentID:getValueById("GetComponentID"),RegNo:iRegNo,Name:iName,PEStDate:iPEDate,PETime:iPETime,Status:iStatus,ChargedStatus:iChargedStatus,CheckedStatus:iCheckedStatus,EndDate:iPEEndDate,GroupID:iGroupID,TeamID:iTeamID,DepartName:iDepartName,VIPLevel:iVIP,RoomPlace:iRoomPlace,ReCheck:ReCheck,RFind:"1",SexDR:iSex,CardNo:iCardNo,CardTypeNew:iCardTypeNew,HospID:HospID});
	
	//location.href=lnk;
}
function SelectGruop(value)
{
	if (value=="") return;
	var ValueArr=value.split("^");
	var obj=document.getElementById("GroupDesc");
	if (obj) obj.value=ValueArr[0];
	var obj=document.getElementById("GroupID");
	if (obj) obj.value=ValueArr[1];
}
function SelectTeam(value)
{
	if (value=="") return;
	var ValueArr=value.split("^");
	var obj=document.getElementById("TeamDesc");
	if (obj) obj.value=ValueArr[0];
	var obj=document.getElementById("TeamID");
	if (obj) obj.value=ValueArr[1];
}
function GroupDesc_Change()
{
	var obj=document.getElementById("GroupID");
	if (obj) obj.value="";
	var obj=document.getElementById("TeamID");
	if (obj) obj.value="";
	var obj=document.getElementById("TeamDesc");
	if (obj) obj.value="";
}
function TeamDesc_Change()
{
	var obj=document.getElementById("TeamID");
	if (obj) obj.value="";
}


function Update_click() {

	var obj;
	
	obj=document.getElementById("Update");
	if (obj && obj.disabled){ return false; }
	
	var iRowId="";
	
	obj=document.getElementById("RowId");
	if (obj){ iRowId=obj.value; }
		
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreIADM.Edit"
			+"&ID="+iRowId
	var lnk="dhcpepreiadm.main.csp?ID="+iRowId		
			
	//var PreOrAdd="PRE"
	//var lnk="dhcpepreitemlist.main.csp"+"?AdmType=PERSON"
	//		+"&AdmId="+iRowId+"&PreOrAdd="+PreOrAdd
	//;
	var wwidth=1250;
	var wheight=650;
	
	
	var xposition = (screen.width - wwidth) / 2;
	var yposition = ((screen.height - wheight) / 2)-10;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;

}

function CancelADM_click() {
	var Src=window.event.srcElement;
	//var Src=document.getElementById("CancelADM");
	if (Src.disabled) { return false; }
	Src.disabled=true;
	var obj;
	var iRowId="",iStatus="PREREG",iUpdateUserDR="";
	var Instring="";
	var Type=Src.innerHTML.substr(Src.innerHTML.length-4,4)
	if (Type=="预约完成") iStatus="PREREGED"
	if (Type=="放弃预约") iStatus="CANCELPREREG"
	obj=document.getElementById("RowId");
	if (obj && ""!=obj.value) { iRowId=obj.value; }
	
	iUpdateUserDR==session['LOGON.USERID'];
	
	Instring=iRowId+"^"+iStatus+"^"+iUpdateUserDR;
	
	var Ins=document.getElementById('CancelADMBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)
	if ("NoItem"==flag)
	{
		alert(t[flag]);
		return;
	}else if (('Err 01'==flag)||('100'==flag)) {
		alert(t['Err 01']);
		return;
	}else if ('Err 02'==flag) {
		alert(t['Err 02']);
		return;
	}else if ('Err 03'==flag) {
		alert(t['Err 03']);
		return;
	}else if ('Err 04'==flag) {
		alert(t['Err 04']);
		return;
	}	
	else if ('0'==flag) {
		//alert("Update Success!");
		location.reload();
	}
	
	Src.disabled=false;
	
}
function GetAddItemPerson()
{
	var objtbl = $("#tDHCPEPreIADM_Find").datagrid('getRows');
    var rows=objtbl.length

	var GFlag=0,IFlag=0,IDs="",OneID="",obj,VIPLevel="",LevelNum=1;
	var Total=0
	for (var i=0;i<rows;i++)
	{
		var TSelect=getCmpColumnValue(i,"TSeclect","DHCPEPreIADM_Find");
	    if (TSelect=="1"){
			Total=Total+1;
			if (Total>10) break
			var OneID=objtbl[i].PIADM_RowId;
			if (IDs==""){
				IDs=OneID;
			}else{
				IDs=IDs+"^"+OneID;
			}
			
			
            var PGADM=objtbl[i].PIADM_PGADM_DR;
				if (PGADM!=""){
					GFlag=1;
				}else{
					IFlag=1;
				}
			

			var CurVIPLevel=objtbl[i].TVIPLevel;
				if (VIPLevel==""){
					VIPLevel=CurVIPLevel;
				}else{
					if (VIPLevel!=CurVIPLevel) LevelNum=LevelNum+1;
				}
		}
	}
	if (LevelNum>1){
		alert("选择人员不能包含不同的VIP等级");
		return "$";
	}
	if ((IFlag+GFlag)==2){
		alert("选择人员不能同时包含团体和个人");
		return "$";
	}
	return IDs+"$"+GFlag+"$"+CurVIPLevel;
}
/// 调用项目预约页面
  function BModifyTest_click() {
	if ($("#BModifyTest").linkbutton('options').disabled==true){
		return false;
	}

	var objtbl = $("#tDHCPEPreIADM_Find").datagrid('getRows');
    var rows=objtbl.length;
   var IDs="",GFlag=0,IFlag=0;
	for (var i=0;i<rows;i++)
	{
		var TSelect=getCmpColumnValue(i,"TSeclect","DHCPEPreIADM_Find");
		var PIADM=objtbl[i].PIADM_RowId;
		if(PIADM==""){
			break;
		}

	    if (TSelect=="1"){
		    var OneID=objtbl[i].PIADM_RowId;
			if (IDs==""){
				IDs=OneID;
			}else{
				IDs=IDs+"^"+OneID;
			}
			var PGADM=objtbl[i].PIADM_PGADM_DR;
			if (PGADM!=""){
					GFlag=1;
				}else{
					IFlag=1;
				}
			var VIPLevel=objtbl[i].TVIPLevel;

		    }
	}
	
	var Arr=IDs.split("^");
	var iRowId=Arr[0];

	/*
	if(IDs.split("^").length>1){
		$.messager.alert("提示","修改预约项目,只能选中一人","info");
		return false;
	}
	*/


	if (VIPLevel=="职业病"){
		var VipFlag="dhcpeoccupationaldiseaseinfo.csp"
	}else {
		var VipFlag=""
	}
	
	
	if (iRowId=="") {
		$.messager.alert("提示","请先勾选一个人员","info");
		return false;
	}
    var ret=tkMakeServerCall("web.DHCPE.PreIADM","GetPreFlag",IDs,IFlag,GFlag);
    var Str=ret.split("^");
	var	flag=Str[0];
	if (flag=="1"){
			$.messager.alert("提示","个人和团体不能同时加项","info");
			return false;
	}else if (flag=="2"){
			$.messager.alert("提示","不是同一个团体人员不能同时加项","info");
			return false;
	}else if (flag=="3"){
			$.messager.alert("提示","不是同一个状态不能同时加项","info");
			return false;
	}else if (flag=="4"){
			$.messager.alert("提示","不是同一个VIP等级的不能同时加项","info");
			return false;
	}else if (flag=="5"){
			$.messager.alert("提示",Str[1]+"已收表不允许加项","info");
			return false;
	}else if (flag=="6"){
			$.messager.alert("提示","不是登记或者到达状态，不能同时加项","info");
			return false;
	}
    
    
	var PreOrAdd="PRE";
	
	if (GFlag=="1"){
		var obj=document.getElementById("AddType");
		if (obj&&obj.checked)
		{
			PreOrAdd="PRE";
		}else{
			PreOrAdd="ADD";
		}
		var AddType="自费";
		if (PreOrAdd=="PRE") AddType="公费"
	
	$.messager.confirm("确认", "确实要给选中的人员"+AddType+"加项吗", function(r){
		if (r){
			var lnk="dhcpepreitemlist.main.hisui.csp"+"?AdmType=PERSON"
			+"&AdmId="+IDs+"&PreOrAdd="+PreOrAdd+"&VIPLevel="+VIPLevel
			;
	
	//var wwidth=1250;
	//var wheight=650;
	//var xposition = (screen.width - wwidth) / 2;
	//var yposition = ((screen.height - wheight) / 2)-10;
	var wwidth=1450;
	var wheight=1450;
	var xposition = 0;
	var yposition = 0;

	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
				
		}
	});
	}else{
		var lnk="dhcpepreitemlist.main.hisui.csp"+"?AdmType=PERSON"
			+"&AdmId="+IDs+"&PreOrAdd="+PreOrAdd+"&VIPLevel="+VIPLevel
			;
	
	/*
	var wwidth=1250;
	var wheight=650;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = ((screen.height - wheight) / 2)-10;
	*/
	var wwidth=1450;
	var wheight=1450;
	var xposition = 0;
	var yposition = 0;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	}
	
	
	
	return true;
}
function SetStatus(Status) {
	var obj;
	var values=Status.split(":");
	var value=values[0];
 
	// REGISTERED 到达
	obj=document.getElementById("Status_ARRIVED");
	if (obj) {
		if (value.indexOf("^ARRIVED^")>-1) {setValueById("Status_ARRIVED",true); }
		else { setValueById("Status_ARRIVED",false); }
	}
	
	// REGISTERED 登记
	obj=document.getElementById("Status_REGISTERED");
	if (obj) {
		if (value.indexOf("^REGISTERED^")>-1) {  setValueById("Status_REGISTERED",true);}
		else { setValueById("Status_REGISTERED",false); }
	}

	// CANCELPREREG 取消预约
	obj=document.getElementById("Status_CANCELPREREG");
	if (obj) {
		if (value.indexOf("^CANCELPREREG^")>-1) { setValueById("Status_CANCELPREREG",true); }
		else {  setValueById("Status_CANCELPREREG",false); }
	}
	
	// CANCELArrive 取消到达
	obj=document.getElementById("Status_CANCELArrive");
	if (obj) {
		if (value.indexOf("CANCELARRIVED^")>-1) {  setValueById("Status_CANCELArrive",true); }
		else { setValueById("Status_CANCELArrive",false); }
	}
	
	//CANCELPE  取消体检
	obj=document.getElementById("Status_CANCELPE");
	if (obj) {
		if (value.indexOf("CANCELPE^")>-1) { setValueById("Status_CANCELPE",true); }
		else { setValueById("Status_CANCELPE",false); }
	}
	
	// PREREG 预约
	obj=document.getElementById("Status_PREREG");
	if (obj) {
		if (value.indexOf("^PREREG^")>-1) { setValueById("Status_PREREG",true); }
		else { setValueById("Status_PREREG",false); }
	}
	
	// PREREGED 完成预约
	obj=document.getElementById("Status_PREREGED");
	if (obj){
		if (value.indexOf("^PREREGED^")>-1) { setValueById("Status_PREREGED",true); }
		else { setValueById("Status_PREREGED",false); }
	}
	var value=values[2];
	if (""==value) { return ;}
	// UNCHECKED 未审核
	obj=document.getElementById("Status_UNCHECKED");
	if (obj) {
		if (value.indexOf("^UNCHECKED^")>-1) { setValueById("Status_UNCHECKED",true); }
		else {setValueById("Status_UNCHECKED",false);}
	}
		
	// CHECKED 已审核
	obj=document.getElementById("Status_CHECKED");
	if (obj) {
		if (value.indexOf("^CHECKED^")>-1) { setValueById("Status_CHECKED",true); }
		else { setValueById("Status_CHECKED",false); }
	}
	
	// NOCHECKED 不需审核
	obj=document.getElementById("Status_NOCHECKED");
	if (obj) {
		if (value.indexOf("^NOCHECKED^")>-1) { setValueById("Status_NOCHECKED",true); }
		else { setValueById("Status_NOCHECKED",false); }
	}
	
		
}

function GetChargedStatus()
{
	var iStatus="";
	return iStatus;
}
// 获取 审核状态
function GetCheckedStatus()
{
	var obj;
	var iStatus="";
	obj=document.getElementById("Status_PREREG");
	if (obj && obj.checked){ return ""; }
		
	// UNCHECKED 未审核
	obj=document.getElementById("Status_UNCHECKED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"UNCHECKED"; }
		
	// CHECKED 已审核
	obj=document.getElementById("Status_CHECKED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"CHECKED"; }
	
	// NOCHECKED 不需审核
	obj=document.getElementById("Status_NOCHECKED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"NOCHECKED"; }
	
	return iStatus;
}

function GetStatus() {
	var obj;
	var iStatus="";

	// PREREG 预约
	obj=document.getElementById("Status_PREREG");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"PREREG"; }
	// PREREGED 完成预约
	obj=document.getElementById("Status_PREREGED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"PREREGED"; }
	// REGISTERED 登记
	obj=document.getElementById("Status_REGISTERED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"REGISTERED"; }
	
	// REGISTERED 到达
	obj=document.getElementById("Status_ARRIVED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"ARRIVED"; }

	// CANCELPREREG 取消预约
	obj=document.getElementById("Status_CANCELPREREG");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"CANCELPREREG"; }
	
	// CANCELArrive 取消到达
	obj=document.getElementById("Status_CANCELArrive");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"CANCELARRIVED"; }
	
	//CANCELPE  取消体检
	obj=document.getElementById("Status_CANCELPE");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"CANCELPE"; }
	iStatus=iStatus+"^"

	return iStatus;
}

function Status_PREREG_click() {
	
	obj=document.getElementById("Status_PREREG");
	if (obj && obj.checked){
		// UNCHECKED 未审核
		obj=document.getElementById("Status_UNCHECKED");
		if (obj){  obj.checked=false; }
		
		// CHECKED 已审核
		obj=document.getElementById("Status_CHECKED");
		if (obj){  obj.checked=false; }
		
		// NOCHECKED 不需审核
		obj=document.getElementById("Status_NOCHECKED");
		if (obj){  obj.checked=false; }
	}
}
	
function Status_PREREG_NoALL() {
	var src=window.event.srcElement;
	if (src && src.checked){
		obj=document.getElementById("Status_PREREG");
		if (obj){  obj.checked=false; }
	}
}

function Clear_click() {


}

var selectrow=-1;		
function SelectRowHandler(index,rowdata) {
	
	var eSrc=window.event.srcElement;
	if (eSrc.id.split("PIADM_ChargedStatus_Desc").length>1) return false;
	if (eSrc.id.split("PrintBarCode").length>1) return false;
	if (eSrc.id.split("PEDateBegin").length>1) return false;
	if (eSrc.parentElement.id.split("PIADM_ItemList").length>1) return false;
	
	var objtbl = $("#tDHCPEPreIADM_Find").datagrid('getRows');
    var rows=objtbl.length;
    
    
    
	selectrow=index;
	
	setColumnValue(selectrow,"TSeclect",1)
	
	
	
	
	if(-1==eSrc.id.indexOf("TSeclect"))
	{ //如果单击一行?改变前面的选择框?方法在DHCPE.Toolets.Common.JS
		
		//ChangeCheckStatus("TSeclect");
		
		
	}

	
	
	if(index==selectrow)
	{ 
		
			var Status=rowdata.PIADM_Status_Desc;
		if((Status=="取消体检")||(Status=="")){
			$("#BModifyTest,#BPrint,#BPrintView,#PrintPayAagin,#BPreviewReport,#BUpdateVIPLevel,#BUpdateDepart").linkbutton('disable');
		}else{
			$("#BModifyTest,#BPrint,#BPrintView,#PrintPayAagin,#BPreviewReport,#BUpdateVIPLevel,#BUpdateDepart").linkbutton("enable");
			             
		}

		var GName=rowdata.TGName;
		if(GName==""){
			$("#AddType").checkbox("disable");
		}else{
			$("#AddType").checkbox("enable");
		}

	    var PAdmId=rowdata.PIADM_RowId;
	    setValueById("RowId",PAdmId);
	    
		var AdmId=rowdata.TAdmIdPIDM;
	    setValueById("TAdmId",AdmId);
	    
	    var Status=rowdata.PIADM_Status;
	  
			
	}else
	{
		selectrow=-1;
		
	}

   
	//ShowCurRecord(selectrow);

}


function ShowCurRecord(CurrentSel) {


	
	var SelRowObj;
	var obj;
	var iRowId="";
	var iTAdmId=""
	obj=document.getElementById("BModifyTest");

	if (CurrentSel==0)
	{
		obj=document.getElementById("RowId");
		if (obj) obj.value=iRowId
		obj=document.getElementById("Update");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
		obj=document.getElementById("CancelADM");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
		obj=document.getElementById("BModifyTest");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
		obj=document.getElementById("TAdmId");
		if (obj) obj.value=iTAdmId;
		return false;
	}
	SelRowObj=document.getElementById('PIADM_RowId'+'z'+CurrentSel);
	obj=document.getElementById("RowId");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }
	//addstart20131016
	SelRowObj=document.getElementById('TAdmIdPIDM'+'z'+CurrentSel);
	obj=document.getElementById("TAdmId");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }
	
	var obj=document.getElementById("TSeclectz"+CurrentSel);
	if (obj) obj.checked=true;
	SelRowObj=document.getElementById('PIADM_Status'+'z'+CurrentSel);
	if (SelRowObj) var Status=SelRowObj.value;
	if (Status=="PREREG")
	{
		obj=document.getElementById("CancelADM");
		if (obj){obj.disabled=false;
		obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>放弃预约";
		obj.style.color = "blue";
		}
		obj=document.getElementById("Update");
		if (obj) {obj.disabled=false;
		obj.style.color = "blue";}
		obj=document.getElementById("BModifyTest");
		if (obj) {obj.disabled=false;
		obj.style.color = "blue";}
		obj=document.getElementById("BPreOver");
		if (obj) {obj.disabled=false;
		obj.style.color = "blue";}
	}
	if (Status=="PREREGED")
	{
		obj=document.getElementById("CancelADM");
		if (obj){obj.disabled=false;
		obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>取消完成";
		obj.style.color = "blue";
		}
		obj=document.getElementById("Update");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
		obj=document.getElementById("BModifyTest");
		if (obj) {obj.disabled=false;
		obj.style.color = "blue";}
		obj=document.getElementById("BPreOver");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
	}
	if (Status=="ARRIVED")
	{
		obj=document.getElementById("CancelADM");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
		obj=document.getElementById("Update");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
		obj=document.getElementById("BModifyTest");
		if (obj) {obj.disabled=false;
		obj.style.color = "blue";}
		obj=document.getElementById("BPreOver");
		if (obj){ obj.disabled=true;
		obj.style.color = "gray";}
		
	}
	if (Status=="CANCELPREREG")
	{
		obj=document.getElementById("CancelADM");
		if (obj){obj.disabled=false;
		obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>预约";
		obj.style.color = "blue";}
		obj=document.getElementById("Update");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
		obj=document.getElementById("BModifyTest");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
		obj=document.getElementById("BPreOver");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
	}
	if (Status=="CANCELARRIVED")
	{
		obj=document.getElementById("CancelADM");
		if (obj){obj.disabled=true;
		obj.style.color = "gray";}
		//obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>预约"}
		obj=document.getElementById("Update");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
		obj=document.getElementById("BModifyTest");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
		obj=document.getElementById("BPreOver");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
	}
		if (Status=="REGISTERED")
	{
		obj=document.getElementById("CancelADM");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
		obj=document.getElementById("Update");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
		obj=document.getElementById("BModifyTest");
		if (obj) {obj.disabled=false;
		obj.style.color = "blue";}
		obj=document.getElementById("BPreOver");
		if (obj) {obj.disabled=true;
		obj.style.color = "gray";}
	}
}
// 菜单 查询预约项目
function PreIADMItemList() {

	var iRowId="";

	var obj=document.getElementById("RowId");
	if (obj) { iRowId=obj.value; }
	if (""==iRowId) { return false;}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreItemList.List"
			+"&AdmType=PERSON"
			+"&AdmId="+iRowId
			;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes';
	window.open(lnk,"_blank",nwin)	

	return true;
}
function UpdatePreAudit()
{
	var Type="I";
	var ID=GetSelectIdNew();
	if (ID=="") {
		$.messager.alert("提示","请选择待操作的人员","info");
		return false;
		}
		
	if(ID.split("^").length>1){
		$.messager.alert("提示","只能操作一人","info");
		return false;
		}
	ID=ID.split(";")[0];
	//var lnk="dhcpepreaudit.csp?CRMADM="+ID+"&ADMType="+Type+"&GIADM="+"&RowID=";
	//websys_lu(lnk,false,'width=1280,height=600,hisui=true,title=费用')
	
	var lnk="dhcpepreauditlist.hiui.csp?CRMADM="+ID+"&ADMType="+Type+"&GIADM="+"&RowID=";
	websys_lu(lnk,false,'iconCls=icon-w-edit,width=1400,height=600,hisui=true,title=费用')

	return true;
}


function ModifyDelayDate()
{
	var Type="Pre";
	var obj;
	var obj=document.getElementById("RowId");
	if (obj) { ID=obj.value; }
	if (""==ID) { return false;}
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreModifyDelayDate"
			+"&ID="+ID+"&Type="+Type;
	
	var wwidth=350;
	var wheight=150;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}


function PatItemPrintA4()  
{

	//DHCP_GetXMLConfig("InvPrintEncrypt","OEItemPrintA4");
	var Page="A4"
	obj=document.getElementById("RowId");  
	if (obj){ CRMId=obj.value; }
	if (CRMId=="") return;
	var DietFlag="TRUE"
	var Diet=document.getElementById('DietFlag');
	if (Diet) DietFlag=Diet.checked;
	var Instring=CRMId+"^"+DietFlag+"^CRM"+"^"+Page;

    var Ins=document.getElementById('GetOEOrdItemBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,'','',Instring);

	 Print(value,Page);
}
		
	

function CancelPE()
{

	var Id="";
    var Id=GetSelectIdNew();
	if(Id==""){
			$.messager.alert("提示","未选择人员","info");
		    return false;
		}
	if(Id.split("^").length>1){
		
		$.messager.alert("提示","只能操作一人","info");
		return false;
	} 
	$.messager.confirm("确认", "确定要取消体检吗？", function(r){
		if (r){
			CancelPECommon("I",0,Id.split(";")[0]);
			BFind_click();
			
		}
	});	
	
}

function UnCancelPE()
{
	var Id="";
    var Id=GetSelectIdNew();
	if(Id==""){
			$.messager.alert("提示","未选择人员","info");
		    return false;
		}
	if(Id.split("^").length>1){
		
		$.messager.alert("提示","只能操作一人","info");
		return false;
	} 
		
	var Status="";
	var objtbl=$("#tDHCPEPreIADM_Find").datagrid('getRows');
	var Status=objtbl[Id.split(";")[1]].PIADM_Status_Desc;
	if(Status!="取消体检"){
		$.messager.alert("提示","不是取消体检状态,不能撤销取消体检","info");
		return false;
	}
	var PGADM=objtbl[Id.split(";")[1]].PIADM_PGADM_DR;
	var PIBI=objtbl[Id.split(";")[1]].PIADM_PIBI_DR;
	var ExistFlag=tkMakeServerCall("web.DHCPE.PreIADM","GroupIsExistIADM",PIBI,PGADM)
	if (ExistFlag=="1") {
		$.messager.alert("提示","客户在团体中已存在,不能撤销取消体检","info");
		return false;
	}

	$.messager.confirm("确认", "确定要撤销取消体检吗？", function(r){
		if (r){
				CancelPECommon("I",1,Id.split(";")[0]);
				BFind_click();
			
		}
	});	
	
	
}


function CancelPECommon(Type,DoType,Id){
	
	var obj=document.getElementById("CancelPEClass");
	if (obj)
	{
		var encmeth=obj.value;
	}
	else
	{
		return false;
	}
	var Ret=cspRunServerMethod(encmeth,Id,Type,DoType);
	Ret=Ret.split("^");
   
	$.messager.alert("提示",Ret[1],'success');
}


function UpdateAsCharged()
{
	var Type="I";
	var obj,AsType="",AsRemark="",ID="";
	
	var ID=GetSelectIdNew();
	if (ID=="") {
		$.messager.alert("提示","请先选择待操作的人员","info");
		return false;
	}
	if(ID.split("^").length>1){
		$.messager.alert("提示","只能操作一人","info");
		return false;
		}

	
	var objtbl=$("#tDHCPEPreIADM_Find").datagrid('getRows');
	var Group=""
	var Group=objtbl[ID.split(";")[1]].TGName;
	if ((Group!="")&&(Group!=" "))
	{
		$.messager.alert("提示","团体中的客户,请在团体中操作","info");
		return;
	}
	
	var  AsType=getValueById("AsType");
	var  AsRemark=getValueById("AsRemark");
    ID=ID.split(";")[0];
	ID=ID+"^"+AsType+"^"+AsRemark;

	var Return=tkMakeServerCall("web.DHCPE.PreGADM","UpdateAsCharged",ID,Type)
 
	if (Return=="StatusErr"){
		$.messager.alert("提示","状态错误!","info");
	}else if (Return=="SQLErr"){
		$.messager.alert("提示","更新错误!","info");
	}else if (Return=="MedErr"){
		$.messager.alert("提示","存在发药品的医嘱,不能取消视同收费","info"); 
	}else{
		$.messager.alert("提示","更新成功!","success");
		$("#AsRemark").val(""); 
		$("#AsType").combobox('setValue',"");

		BFind_click();
		//location.reload();
		
	}


}
//打印检查项目信息 2008-06-30
//create by  zhouli
function PrintRisRequest()
{
	var obj=document.getElementById("RowId");  
	if (obj){ PreIADMDR=obj.value; }
	PrintRisRequestApp(PreIADMDR,"","PreIADM");
	return false;
}
function GetRisInfo()
{  
	if (CurrentSel==0) return;
   	var LocID=session['LOGON.CTLOCID']
	var obj=document.getElementById("RowId");  
	if (obj){ PreIADMDR=obj.value; }
	var Ins=document.getElementById('GetRisItemInfo');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,PreIADMDR);
	var String=value.split(";");
	alert(String)
  
		for (var i=0;i<String.length;i++)
		{
			var str=String[i].split("^");
            var ItemDesc=str[0]
            var Regno=str[1]
            var SexDesc=str[2]
            var Age=str[3]
            var Name=str[4]
            var InfoStr=ItemDesc+"^"+Regno+"^"+SexDesc+"^"+Age+"^"+Name
            PrintRisInfo(InfoStr);
	        //if (LocID=="165")  PrintRisInfo(InfoStr);
	    }
			
	}

		
function PrintRisInfo(InfoStr)   
{   
   var LocID=session['LOGON.CTLOCID']
	var Info=InfoStr.split("^")       
    var ItemDesc=Info[0]
    var Regno=Info[1]
    var SexDesc=Info[2]
    var Age=Info[3]
    var Name=Info[4]
	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) 
	{
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintRisItemInfoNew.xls';
	}else
	{
		alert("无效模板路径");
		return;
	}
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Templatefilepath);
    xlsheet = xlBook.WorkSheets("Sheet1") 
    xlsheet.cells(2,1).Value=ItemDesc ;
    //if (LocID=="165"){xlsheet.cells(1,1).Value=Name+"  "+SexDesc+"  医务部体检"; }
	//if (LocID=="579"){xlsheet.cells(2,1).Value="医保查体"+"  "+Regno;} 
	xlsheet.cells(1,1).Value=Name+"  "+SexDesc+"  医务部体检";
	//xlsheet.cells(2,1).Value="医保查体"+"  "+Regno;
	xlsheet.cells(3,1).Value="*"+Regno+"*";
    //if (LocID=="165") {xlsheet.printout(1,1,1,false,"tiaoma");}
    //if (LocID=="579") {xlsheet.printout;}
    xlsheet.printout(1,1,1,false,"tiaoma");
    xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
	}
function PrintRisInfoOld(InfoStr)   
{   
   var LocID=session['LOGON.CTLOCID']
    
    var Info=InfoStr.split("^")       
    var ItemDesc=Info[0]
    var Regno=Info[1]
    var SexDesc=Info[2]
    var Age=Info[3]
    var Name=Info[4]
	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintRisItemInfo.xls';
	}else{
		alert("无效模板路径");
		return;
	}

	xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Templatefilepath);
    xlsheet = xlBook.WorkSheets("Sheet1") 
	
    xlsheet.cells(3,1).Value=ItemDesc ;
    if (LocID=="165"){xlsheet.cells(2,1).Value="医务查体"+"  "+Regno; }
	if (LocID=="579") {xlsheet.cells(2,1).Value="医保查体"+"  "+Regno;} 
    xlsheet.cells(1,1).Value=Name+"  "+SexDesc+"  "+Age ;
    if (LocID=="165") {xlsheet.printout(1,1,1,false,"tiaoma");}
    if (LocID=="579") {xlsheet.printout;}
    //xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
	}

function printBaseInfo(Name,SexDesc)
{   var LocID=session['LOGON.CTLOCID']
	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintRisItemInfo.xls';
	}else{
		alert("无效模板路径");
		return;
	}

	xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Templatefilepath);
    xlsheet = xlBook.WorkSheets("Sheet1") 
	xlsheet.cells(2,1).Value=Name+"   "+SexDesc;
    xlsheet.Rows(2).Font.Size=16;
    if (LocID=="165") {xlsheet.printout(1,1,1,false,"tiaoma");}
    if (LocID=="579") {xlsheet.printout;}
    //xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
}
function PECashier()
{
	var obj=document.getElementById('PIADM_RowId'+'z'+CurrentSel);
	if (!obj) return;
	var PADM=obj.value;
	var obj=document.getElementById('PIADM_PIBI_DR_RegNo'+'z'+CurrentSel);
	if (obj) var RegNo=obj.innerText;
	var sURL="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEAdvancePayment"
				+"&RegNo="+RegNo+"&PADM="+PADM+"&Type=R";
	window.showModalDialog(sURL,"","dialogWidth=600px;dialogHeight=450px");
}
//预约到达日期
function AppointArrivedDate()

{
	
	var obj;
	var obj=document.getElementById("RowId");  
	if (obj) { var ID=obj.value; }
	if (""==ID) { return false;}
	var Type="I"
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEAppointArrivedDate"
			+"&ID="+ID+"&Type="+Type
	
	var wwidth=350;
	var wheight=200;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
	}
	
function PrintCashierNotes()

{
	
	var obj;
	var obj=document.getElementById("RowId");
	if (obj) { var ID=obj.value; }
	if (""==ID) { 
	alert(t["NoRecord"])
	return false;}
	var obj=document.getElementById('PIADM_PIBI_DR_Name'+'z'+CurrentSel);
	if (obj) var Name=obj.innerText;
	var Type="I"
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPrintCashierNotes"
			+"&ID="+ID+"&Name="+Name+"&Type="+Type
	var wwidth=350;
	var wheight=200;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
	}
function CancelCashierNotes()    
{     	
        var obj=""
        obj=document.getElementById('RowId');
		if(obj){
			var PIADM=obj.value
			if (PIADM=="")
			{alert(t["NoRecord"])
			  return;}
			
			}
		
         var Ins=document.getElementById('Cancel');
		 if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
		 var Flag=cspRunServerMethod(encmeth,"I",PIADM,"");
         if (Flag==""){alert(t["CancelSuccess"])}
         if (Flag=="NoCashier"){alert(t["NoCashier"])} 
	
	
	}
 function PrintIOEFeeDetail()   
   {   
   	var obj=document.getElementById("RowId");  
	if (obj){ PreIADMDR=obj.value; }

	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) 
	{
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEGOEFeeDetailPrint.xls';
	}else
	{
		alert("无效模板路径");
		return;
	}

	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("明细")     //Excel下标的名称

   var Ins=document.getElementById('GetIOEFeeDetail');
    if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
  
	var Returnvalue=cspRunServerMethod(encmeth,PreIADMDR);

	if (Returnvalue==""){
		alert("无已交费的个人明细!")
		return;}

	var String=Returnvalue.split("#");
	var PatName=String[0]
	var ARCIMStr=String[1]
	var ARCIM=ARCIMStr.split("$");
	xlsheet.cells(2,1).Value=PatName+""+"体检项目费用明细";
	for(i=0;i<(ARCIM.length);i++)
	{  
	var ARCIMDesc=ARCIM[i].split("^")[0]
	var ARCIMNum=ARCIM[i].split("^")[1]
	var ARCIMAmount=ARCIM[i].split("^")[2]
 
       xlsheet.Range(xlsheet.Cells(3+i,1),xlsheet.Cells(3+i,3)).mergecells=true; //合并单元格
	xlsheet.Range(xlsheet.Cells(3+i,4),xlsheet.Cells(3+i,5)).mergecells=true; //合并单元格
	xlsheet.Range(xlsheet.Cells(3+i,6),xlsheet.Cells(3+i,7)).mergecells=true; //合并单元格
	//xlsheet.Range(xlsheet.Cells(3+i,4),xlsheet.Cells(3+i,5)).HorizontalAlignment =-4108;//居中
       xlsheet.Range(xlsheet.Cells(3+i,1),xlsheet.Cells(3+i,7)).Borders.LineStyle=1;
	 xlsheet.cells(3+i,1).Value=ARCIMDesc
        xlsheet.cells(3+i,4).Value=ARCIMNum
        xlsheet.cells(3+i,6).Value=ARCIMAmount
	 }
 		xlsheet.SaveAs("d:\\"+PatName+"体检项目费用明细.xls");
		//xlBook.Close (savechanges=false);
		//xlApp=null;
		//xlsheet=null;
	   xlApp.Visible = true;
	   xlApp.UserControl = true;
	}
function PrintReportRJ()
{
	var obj=document.getElementById("RowId");  
	if (obj){ PreIADMDR=obj.value; }
	PrintReportRJApp(PreIADMDR,"PreIADM");
}

function PrintTarItemDetail()
{
	var obj=document.getElementById("RowId");  
	if (obj){ PreIADMDR=obj.value; }
	PrintTarItemDetailApp(PreIADMDR,"CRM");
}

///addStart20131015 打印选择框
function BPrint_click()
{
	if ($("#BPrint").linkbutton('options').disabled==true){
		return false;
	}

	var obj;
	var iTAdmId="";
	var iOEOriId="";
	var PrintFlag=1;
	var TAdmIdStr=GetSelectId() ;
	var TAdmIds=TAdmIdStr.split(";")
	for(var PSort=0;PSort<TAdmIds.length;PSort++)
	{
		var iTAdmId=TAdmIds[PSort];
		if (iTAdmId=="") { 
			$.messager.alert("提示","您没有选择客户,或者没有登记","info");
	    	//alert("您没有选择客户,或者没有登记");
			websys_setfocus("RegNo");
	   		return false;    
		}
		PrintAllApp(iTAdmId,"PAADM");	 //DHCPEPrintCommon.js	
	}

	websys_setfocus("RegNo");
}

function CancelArrived()
{
	var obj=document.getElementById("TAdmId");
	if (obj) { iTAdmId=obj.value; }
	if (""==iTAdmId) { 
	    alert("您没有选择客户,或者没有登记")
	    return false;    
	}
	var ret=tkMakeServerCall("web.DHCPE.PreIADMEx","CancelArrived",iTAdmId);
	alert(ret)
	
}
function ReplaceCancelPE()
{
	if (!confirm('确实要对选中人员取消体检吗')) return false;
	var obj=document.getElementById("TAdmId");
	if (obj) { iTAdmId=obj.value; }
	if (""==iTAdmId) { 
	    alert("您没有选择客户,或者没有登记")
	    return false;    
	}
	var UserID=session['LOGON.USERID'];
	var ret=tkMakeServerCall("web.DHCPE.CancelPE","UpdateCancelPEStatus",iTAdmId,UserID);
	alert(ret)
	
}
///addEnd20131015 打印选择框
//指引单打印预览
document.write("<script language='javascript' src='../SCRIPTS/DHCPEPrintDJDCommon.js'></script>")
function PatItemPrintXH()
{
	if ($("#BPrintView").linkbutton('options').disabled==true){
		return false;
	}

	var viewmark=2;
	var NoPrintAmount="N";
	NoPrintAmount=getValueById("NoPrintAmount");
	if(NoPrintAmount==false){
		NoPrintAmount="N"
		}else{
			NoPrintAmount="Y";
			}
	//alert("NoPrintAmount="+NoPrintAmount)
	var obj=document.getElementById("TAdmId");
	if (obj) { iTAdmId=obj.value; }
	if (""==iTAdmId) { 
	    $.messager.alert("提示","您没有选择客户,或者没有登记","info");
	    return false;    
	}
	var PrintFlag=1;
	var PrintView=1;
	var Instring=iTAdmId+"^"+PrintFlag+"^PAADM^"+NoPrintAmount+"Y";	
	var Ins=document.getElementById('GetOEOrdItemBox');	
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,'','',Instring);
	if (value=="NoPayed"){
		$.messager.alert("提示","存在未付费项目，不能预览","info");
		return false;
	}

    PEPrintDJD("V",iTAdmId+"^"+NoPrintAmount,"");//DHCPEPrintDJDCommon.js  lodop打印  增加入参拼串是否打印金额的标记  Y 打不打印，N 打印
	//Print(value,PrintFlag,viewmark);	//DHCPEIAdmItemStatusAdms.PatItemPrint
	
}
///补打收费条码
function PrintPayAagin_Click()
{
	var objtbl = $("#tDHCPEPreIADM_Find").datagrid('getRows');
    var rows=objtbl.length;
    
	for (var i=0;i<rows;i++) {
		var TSelect=getCmpColumnValue(i,"TSeclect","DHCPEPreIADM_Find")
	    if (TSelect=="1"){
			  var IADM=objtbl[i].TAdmIdPIDM;
		    if(IADM=="") continue;
			var PIAdmId=objtbl[i].PIADM_RowId;
			if(PIAdmId=="") continue;
 			var RegNo=objtbl[i].PIADM_PIBI_DR_RegNo;
 			var NewHPNo=objtbl[i].TNewHPNo;
 			//var Name=objtbl[i].PIADM_PIBI_DR_Name; //对于列表找那个的link元素不支持这种写法
 			var Name=tkMakeServerCall("web.DHCPE.HISUICommon","GetNameByRegNo",RegNo)
			var Sex=objtbl[i].PIADMPIBI_DR_SEX;
 			var Age=objtbl[i].TAge+' 【补】';
 			
		var Amount=tkMakeServerCall("web.DHCPE.HandlerPreOrds","IGetAmount4Person",PIAdmId); 
		//var Amount=tkMakeServerCall("web.DHCPE.PrintNewDirect","GetPayedAmt",PIAdmId); 
		var FactAmount=Amount.split('^')[1]+'元';
		var Info=RegNo+"^"+Name+"  "+FactAmount+"^"+"^"+"^"+"^"+Sex+String.fromCharCode(1)+"^"+Age+"^"+RegNo+"^"+NewHPNo;
		//alert(Info)
		PrintBarRis(Info);	
		}
	}
}



function PrintBchao()
{
	var iTAdmId="";
	var TAdmIdStr=GetSelectId() ;
	var TAdmIds=TAdmIdStr.split(";")
	for(var PSort=0;PSort<TAdmIds.length;PSort++)
	{
		var iTAdmId=TAdmIds[PSort]; //paadm
		if (iTAdmId=="") { 
	    	alert("您没有选择客户,或者没有登记");
			websys_setfocus("RegNo");
	   		return false;    
		}
		PrintBChaoReport(iTAdmId,"")
	
	}
}


///到达/取消取达
function IAdmAlterStatus(){	
	var Data=GetSelectId1();
	if (""==Data) { 
	$.messager.alert("提示","请先选择需要操作的人员","info");
	return ; 
	}
	var Datas=Data.split(";");
	for (var iLLoop=0;iLLoop<=Datas.length-1;iLLoop++){
		FData=Datas[iLLoop].split("^");
		if (""!=FData) {
			var paadm=FData[0];
			var iIAdmId=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetIAdmIdByPaadm",paadm);
			var IAdmStatus=FData[1];
			var newStatus=""
			if (IAdmStatus=="ARRIVED") {newStatus="CANCELARRIVED"}
			if (IAdmStatus=="REGISTERED") {newStatus="ARRIVED"}
			//if (IAdmStatus=="CANCELARRIVED") {newStatus="ARRIVED"}
			if (newStatus==""){
				$.messager.alert("提示","选择客人的状态应是到达或登记!","info");
				return false;
			}
			var flag=tkMakeServerCall("web.DHCPE.DHCPEIAdm","ArrivedUpdate",iIAdmId,newStatus);
			if (flag!='0') {
				$.messager.alert("提示","操作失败:"+flag,"info");
				return false;
			}
		}
	}
	//alert("完成操作");
       $.messager.alert("提示","操作完成","info");
	BFind_click();
    //location.reload(0);
}

function GetSelectId1() 
{ 
	 var objtbl = $("#tDHCPEPreIADM_Find").datagrid('getRows');
    var row=objtbl.length;
	var vals="",val="",Status="";
	for (var i=0;i<row;i++) {
		var TSelect=getCmpColumnValue(i,"TSeclect","DHCPEPreIADM_Find");
		var PIADM=objtbl[i].PIADM_RowId;
		if(PIADM==""){
			break;
		}

	    if (TSelect=="1"){
		       var val=objtbl[i].TAdmIdPIDM;
		       var Status=objtbl[i].PIADM_Status;
			if (val==" ") continue;
			if (vals=="") {vals=val+"^"+Status;}
			else {vals=vals+";"+val+"^"+Status;}
		}
	}
	return vals;
}

document.body.onload = BodyLoadHandler;