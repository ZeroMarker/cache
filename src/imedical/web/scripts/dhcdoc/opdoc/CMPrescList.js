var CMPrescListDataGrid;
var tableGridParams={
	"ClassName":"web.UDHCPrescriptQueryCM","QueryName":"search",
	"EpisodeID":ServerObj.EpisodeID,"loc":"",
	"strdate":ServerObj.defStartDate,"enddate":ServerObj.CurrentDate,"PatientID":"","SearchFlag":""
};
$(window).load(function() {
	if (ServerObj.EpisodeID!="") {
		$.m({
		    ClassName:"web.UDHCPrescriptQueryCM",
		    MethodName:"getname",
		    EpisodeID:ServerObj.EpisodeID
		},function(PatInfo){ 
			if (PatInfo!="") {
				var PatInfoAry=PatInfo.split("^");
				//加入病案号
				var MdeNo=PatInfoAry[18];
				$("#Patmed").val(MdeNo);
				var PatientID=PatInfoAry[0];
				var PatientNo=PatInfoAry[1];
				SetPatientInfo(PatientNo,"",PatientID);
			}
		});
	}else{
		LoadOutPatientDataGrid();
	}
	$HUI.datebox('#StartDate').setValue(ServerObj.defStartDate);
	$HUI.datebox('#EndDate').setValue(ServerObj.CurrentDate);
	$("#CardNo").focus();
});
function Init(){
	$HUI.combobox('#LocList',{      
    	valueField:'ksrowid',   
    	textField:'ksdesc',
    	mode:'remote',
    	method:"Get",
    	url:$URL+"?ClassName=web.UDHCPrescriptQueryCM&QueryName=ks",
    	onSelect:function(record){
				tableGridParams['loc']=record['ksrowid'];
				LoadOutPatientDataGrid();
		},
		onChange:function(newValue,oldValue){
			if (!newValue){
				tableGridParams['loc']="";
				LoadOutPatientDataGrid();
			}
		},
		onBeforeLoad:function(param){
			 var desc=param['q'];
			param = $.extend(param,{ks:desc});
		},
		loadFilter:function(data){
		    return data['rows'];
		}
	});
	InitCMPrescListDataGrid();
	InitEvent();
}
function InitEvent(){
	$("#CopyOrd").click(CopyClickHandler);
	$("#BFind").click(LoadOutPatientDataGrid);
	$("#UpdateCookMode").click(OpenCookModeWin);
	$("#SaveCookMode").click(UpdatePrescNoCookMode);
	$(document.body).bind("keydown",BodykeydownHandler);
	$HUI.checkbox("#selAllPresno",{
	   onChecked:function(event,value){
		   var $check=$("input[id*='checkOnePrescAll_']"); 
		   for (var i=0;i<$check.length;i++){
			   $("#checkOnePrescAll_"+i).prop("checked",true);
			   for (var j=1;j<=4;j++){
			       $("#"+"check"+j+"_"+i+"").prop("checked",true).attr("disabled", true);
			   }
		   }
   	   },
   	   onUnchecked:function(){
	   	   var Data=CMPrescListDataGrid.datagrid('getData'); 
	   	   var $check=$("input[id*='checkOnePrescAll_']"); 
		   for (var i=0;i<$check.length;i++){
			   $("#checkOnePrescAll_"+i).prop("checked",false);
			   for (var j=1;j<=4;j++){
			       $("#"+"check"+j+"_"+i+"").prop("checked",false).attr("disabled", false);
			       var HidddenPara=Data.rows[i]["HiddenPara"+j];
				   if (HidddenPara!=""){
					   var ARCIMARCOSRowid=HidddenPara.split("!")[4];
					   var IsARCOSFormula = $.cm({
							ClassName:"web.UDHCPrescript",
							MethodName:"IsARCOSFormula",
							dataType:"text",
							ARCOSRowid:ARCIMARCOSRowid
					    },false);
					    if (IsARCOSFormula=="1"){
						    $("#"+"check"+j+"_"+i+"").attr("disabled", true);
						}
				   }
				   
			   }
		   }
   	   }
   });
   $("#ReadCard").click(ReadCardClickHandler);
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
	if (keyCode==13) {
		if ((SrcObj.tagName=="A")||(SrcObj.tagName=="INPUT")) {
			if (SrcObj.id=="CardNo"){
				CardNoKeydownHandler(e);
				return false;
			}else if(SrcObj.id=="PatNo"){
				PatNoKeydownHandler(e);
				return false;
			}else if(SrcObj.id=="Patmed"){
				PatMedKeydownHandler(e);
				return false;
			}
			return true;
		}
	}
}
function CardNoKeydownHandler(e){
	var key=websys_getKey(e);
	if (key==13) {
		 var CardNo=$("#CardNo").val();
		 if (CardNo=="") return;
		 var myrtn=DHCACC_GetAccInfo("",CardNo,"","PatInfo",CardTypeCallBack);
	}
}
function PatNoKeydownHandler(e){
	var key=websys_getKey(e);
	if (key==13) {
		var CardNo=$("#CardNo").val();
		var PatientID=$("#PatientID").val();
		var PatientNo=$("#PatientNo").val(); 
		if(PatientNo!=""){
			PatientNo=FormatPatNo();
			$.m({
			    ClassName:"web.DHCOPCashierIF",
			    MethodName:"GetPAPMIByNo",
			    PAPMINo:PatientNo,
			    ExpStr:""
			},function(PatientID){ 
				if (PatientID=="") {
					$.messager.alert("提示","此患者ID不存在!","info",function(){
						$("#PatientNo").focus();
					})
				}
				SetPatientInfo(PatientNo,"",PatientID);
			});
		}
	}
}
function PatMedKeydownHandler(e){
	var key=websys_getKey(e);
	if (key==13) {
		var CardNo=$("#CardNo").val();
		var PatientID=tableGridParams["PatientID"];
		var PatientNo=$("#PatNo").val(); 
		var PatMed=$("#Patmed").val();
		if(PatMed!=""){
			var Ret = $.cm({
				ClassName:"web.DHCDocOrderEntryCM",
				MethodName:"GetPatIDByInMedNo",
				PatMed:PatMed,
				dataType:"text"
			},false);
			if(Ret==""){
				$.messager.alert("提示",$g("病案号【")+PatMed+ $g("】对应患者不存在!"),"info",function(){
					$("#Patmed").focus();
				});
			}else{
			 	tableGridParams["PatientID"]=Ret.split("^")[0]
			 	$("#PatNo").val(Ret.split("^")[1]);
				SetPatientInfo(PatientNo,CardNo,PatientID);
			}
		}
	}
}
function FormatPatNo(){
	var PatNo=$("#PatNo").val();
	if (PatNo!='') {
		if ((PatNo.length<10)) {
			for (var i=(10-CardNo.length-1); i>=0; i--) {
				PatNo="0"+PatNo;
			}
		}
	}
	return PatNo
}
function CardTypeCallBack(myrtn){
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0": //卡有效有帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").val(CardNo);
			SetPatientInfo(PatientNo,CardNo,PatientID);
			event.keyCode=13;			
			break;
		case "-200": //卡无效
			$.messager.alert("提示","卡无效!","info",function(){
				$("#CardNo").focus();
			})
			break;
		case "-201": //卡有效无帐户
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").val(CardNo);
			SetPatientInfo(PatientNo,CardNo,PatientID);
			event.keyCode=13;
			break;
		default:
	}
}
function InitCMPrescListDataGrid(){
	var Columns=[[
		/*
		选择	处方号	选择1	药品名称	数量	选择2	药品名称	数量	选择3	药品名称	数量	选择4	药品名称	数量
		*/
		{field:'prescno',title:'选择',align:'center',width:50,
			formatter: function(value,row,index){
				return "<input class='row-checkbox' type='checkbox' name='PrescCheck' id='"+"checkOnePrescAll_"+index+"'>";
			}
		},
		{field:'b1',title:'处方号',width:400},
		{field:'HiddenPara1',title:'选择',align:'center',width:50,
			formatter: function(value,row,index){
				return "<input class='row-checkbox' type='checkbox' id='"+"check1_"+index+"'>";
			}
		},
		{field:'c1',title:'药品名称',width:150},
		{field:'c2',title:'数量',width:70},
		{field:'HiddenPara2',title:'选择',align:'center',width:50,
			formatter: function(value,row,index){
				return "<input class='row-checkbox' type='checkbox' id='"+"check2_"+index+"'>";
			}
		},
		{field:'c5',title:'药品名称',align:'center',width:150},
		{field:'c6',title:'数量',align:'center',width:70},
		{field:'HiddenPara3',title:'选择',align:'center',width:50,
			formatter: function(value,row,index){
				return "<input class='row-checkbox' type='checkbox' id='"+"check3_"+index+"'>";
			}
		},
		{field:'c9',title:'药品名称',align:'center',width:150},
		{field:'c10',title:'数量',align:'center',width:70},
		{field:'HiddenPara4',title:'选择',align:'center',width:50,
			formatter: function(value,row,index){
				return "<input class='row-checkbox' type='checkbox' id='"+"check4_"+index+"'>";
			}
		},
		{field:'c13',title:'药品名称',align:'center',width:150},
		{field:'c14',title:'数量',align:'center',width:70},
		{ field: "c7",hidden:true},
		{ field: "c11" ,hidden:true},
		{ field: "c15",hidden:true},
		{ field: "je5" ,hidden:true},
		{ field: "b2",hidden:true },
		{ field: "EpisodeID" ,hidden:true},
		{ field: "stopflag1" ,hidden:true},
		{ field: "stopflag2",hidden:true },
		{ field: "stopflag3" ,hidden:true},
		{ field: "stopflag4",hidden:true }
		
   ]]
	CMPrescListDataGrid=$("#CMPrescListTable").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		autoSizeColumn : false,
		rownumbers:false,
		//pagination : true,  //
		rownumbers : false,  //
		pageSize:10,
		pageList:[10,50,100],
		idField:'EpisodeID',
		columns :Columns,
		rowStyler:function(rowIndex, rowData){
		},
		onDblClickRow:function(rowIndex, rowData){
		},
		onLoadSuccess:function(data){
			$(".row-checkbox").change(function(e) { 
				var id=e.target.id;
				var selectedIndex=id.split("_")[1];
				var selectedPrescNo=data.rows[selectedIndex].prescno;
				var b1=data.rows[selectedIndex].b1;
				if (id.split("_")[0]=="checkOnePrescAll"){
					for (var i=selectedIndex;i<data.rows.length;i++){
						var rowPrescNo=data.rows[i].prescno;
						if (rowPrescNo!=selectedPrescNo) {continue;}
						if ($("#"+id+"").is(':checked')){
							for (var j=1;j<=4;j++){
								var HidddenPara=Data.rows[i]["HiddenPara"+j];
								if (HidddenPara!=""){
									var ARCIMARCOSRowid=HidddenPara.split("!")[4];
									var IsARCOSFormula = $.cm({
										ClassName:"web.UDHCPrescript",
										MethodName:"IsARCOSFormula",
										dataType:"text",
										ARCOSRowid:ARCIMARCOSRowid
									},false);
									if ((IsARCOSFormula!="1")||(b1!="")){
										$("#"+"check"+j+"_"+i+"").prop("checked",true).attr("disabled", true);
									}
								}else{
										$("#"+"check"+j+"_"+i+"").prop("checked",true).attr("disabled", true);
									}
							}
						}else{
							for (var j=1;j<=4;j++){
								var HidddenPara=Data.rows[i]["HiddenPara"+j];
								if (HidddenPara!=""){
									var ARCIMARCOSRowid=HidddenPara.split("!")[4];
									var IsARCOSFormula = $.cm({
										ClassName:"web.UDHCPrescript",
										MethodName:"IsARCOSFormula",
										dataType:"text",
										ARCOSRowid:ARCIMARCOSRowid
									},false);
									if (IsARCOSFormula=="1"){
										$("#"+"check"+j+"_"+i+"").prop("checked",false).attr("disabled", true);
										}else{
										$("#"+"check"+j+"_"+i+"").prop("checked",false).attr("disabled", false);	
										}
								}else {
								$("#"+"check"+j+"_"+i+"").prop("checked",false).attr("disabled", false);}
							}
						}
					}
				}
			});
			var Data=CMPrescListDataGrid.datagrid('getData');        
			for (var i=0;i<Data.rows.length;i++){
				for (var j=1;j<=4;j++){		
					var HidddenPara=Data.rows[i]["HiddenPara"+j];
					if (HidddenPara!=""){
						var ARCIMARCOSRowid=HidddenPara.split("!")[4];
						var IsARCOSFormula = $.cm({
							ClassName:"web.UDHCPrescript",
							MethodName:"IsARCOSFormula",
							dataType:"text",
							ARCOSRowid:ARCIMARCOSRowid
						},false);
						if (IsARCOSFormula=="1"){
							$("#"+"check"+j+"_"+i+"").attr("disabled", true);
							}
					}
							
				}
			}
		}
	})
}
function LoadOutPatientDataGrid(){
	if (tableGridParams.PatientID=="") return;
	var StartDate=$HUI.datebox('#StartDate').getValue();
	if (StartDate==""){StartDate=tableGridParams.strdate}
	var EndDate=$HUI.datebox('#EndDate').getValue();
	if (EndDate==""){EndDate=tableGridParams.enddate}
   	$.q({
	    ClassName : tableGridParams.ClassName,
	    QueryName : tableGridParams.QueryName,
	    EpisodeID: tableGridParams.EpisodeID,
	    loc: tableGridParams.loc,
	    strdate: StartDate,
	    enddate: EndDate,
	    PatientID: tableGridParams.PatientID,
	    SurName: tableGridParams.SurName,
	    SearchFlag: tableGridParams.SearchFlag,
	    Pagerows:CMPrescListDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		CMPrescListDataGrid.datagrid('loadData',GridData);  //.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter})
	}); 
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(ServerObj.sysDateFormat=="4"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
function SetPatientInfo(PatientNo,CardNo,PatientID){
	$("#CardNo").val(CardNo);
	if (PatientID!=""){
		$.m({
		    ClassName:"web.DHCDocOrderEntry",
		    MethodName:"GetPatientByRowid",
		    PapmiRowid:PatientID,
		    EpisodeID:""
		},function(PatInfo){ 
			if (PatInfo!="") {
				var tempArr=PatInfo.split("^");
				var PatName=tempArr[2];
				var PatSex=tempArr[3];
				var PatNo=tempArr[1];
				$("#PatName").val(PatName);
				$("#PatSex").val(PatSex);
				$("#PatNo").val(PatNo);
			}
			if (PatientID!=""){
				if ((tableGridParams["PatientID"]!="")&&(tableGridParams["PatientID"]!=PatientID)){
					$("#Patmed").val('');
				}
				tableGridParams["PatientID"]=PatientID;
			}
			LoadOutPatientDataGrid();
		});
		$.m({
		    ClassName:"web.DHCBL.CARD.UCardPaPatMasInfo",
		    MethodName:"GetPatEncryptLevel",
		    PAPMIRowId :PatientID,ErrMsg:""
		},function(PatEncryptLevel){ 
			if (PatEncryptLevel!="") {
				var PatEncryptLevelArr=PatEncryptLevel.split("^");
				$("#PoliticalLevel").val(PatEncryptLevelArr[1]);
				$("#SecretLevel").val(PatEncryptLevelArr[3]);
			}else{
				$("#PoliticalLevel").val('');
				$("#SecretLevel").val('');
			}
		})
	}
}
function CopyClickHandler(){
	var ARCOSFormulaExistFlag=0,NotARCOSFormulaFlag=0;
	var Copyary=new Array();
	var Data=CMPrescListDataGrid.datagrid('getData');        
	for (var i=0;i<Data.rows.length;i++){
		for (var j=1;j<=4;j++){
			if ($("#"+"check"+j+"_"+i+"").is(':checked')){
				var HidddenPara=Data.rows[i]["HiddenPara"+j];
				if (HidddenPara!=""){
					var arcim=HidddenPara.split("!")[0];
					var ARCOSRowId=HidddenPara.split("!")[4];
					if (ARCOSRowId!=""){
						var IsARCOSFormula=$.cm({
							ClassName:"web.UDHCPrescript",
							MethodName:"IsARCOSFormula",
							dataType:"text",
							ARCOSRowid:ARCOSRowId
						},false);
						if (IsARCOSFormula=="1") ARCOSFormulaExistFlag=1;
						else NotARCOSFormulaFlag=1;
					}else{
						NotARCOSFormulaFlag=1;
					}
					var ret = $.cm({
						ClassName:"web.DHCDocOrderEntryCM",
						MethodName:"CheckArcimActiveDate",
						ArcimRowid:arcim,
						dataType:"text"
					},false);
					if (ret!=0){
						if (ARCOSFormulaExistFlag=="1") {
							dhcsys_alert("提示",ret.split("^")[1]);
							return false;
						}else{
							if (dhcsys_confirm(ret.split("^")[1]+$g(",是否继续复制?"))) {
								continue
							}else{
								return false;
							}
						}
					}
					Copyary[Copyary.length]=HidddenPara;
				}
			}
		}
	}
	if (Copyary.length==0) {
		$.messager.alert("提示","请选择需要复制的医嘱!");
		return false;
	}
	if ((ARCOSFormulaExistFlag=="1")&&(NotARCOSFormulaFlag=="1")&&(ServerObj.FormulaCanAppendItem=="0")){
		$.messager.alert("提示","协定处方不可与其他医嘱一起复制!");
		return false;
	}
	var PrescArr=new Array();
	$('input[name=PrescCheck]:checked').each(function(){
		var index=$(this).attr('id').split('_')[1];
		var PrescNo=Data.rows[index]["b1"].split(':')[1].split(' ')[0];
		if(!PrescNo) return true;
		if(PrescArr.indexOf(PrescNo)==-1) PrescArr.push(PrescNo);
	});
    var MainSreenFlag=websys_getAppScreenIndex();
	if(PrescArr.length==1){
		$.messager.confirm('提示','是否复制处方用法用量信息?',function(r){
			if(MainSreenFlag!=0){
				if(r){
					websys_emit("onPrescListChange",{"PrescInfo":PrescArr[0],copyFlag:true});
				}else{
					websys_emit("onCopyCMPresc",Copyary);
				}
			}else{
                websys_showModal('hide');
                if(r){
                    websys_showModal('options').PrescListChange(PrescArr[0],true);
                }else{
                    websys_showModal('options').AddCopyItemToListFromQuery(Copyary);
                }
                websys_showModal("close");
            }
		});
		return;
	}
    if(MainSreenFlag!=0){
		websys_emit("onCopyCMPresc",Copyary);
	}else{
        websys_showModal('hide');
        websys_showModal('options').AddCopyItemToListFromQuery(Copyary);
        websys_showModal("close");
    }
}
function ReadCardClickHandler(){
	var myrtn=DHCACC_GetAccInfo7(CardTypeCallBack);
}
function OpenCookModeWin(){
	var cookmode="";
	var selPrescArr=new Array();
	/*var rows=CMPrescListDataGrid.datagrid('getSelections');        
	for (var i=0;i<rows.length;i++){
		var prescno=rows[i].prescno;
		if (!prescno) continue;
		if (("^"+selPrescArr.join("^")+"^").indexOf("^"+prescno+"^")>=0) continue;
		selPrescArr.push(prescno);
		cookmode=rows[i].cookmode;
	}*/
   var rows=CMPrescListDataGrid.datagrid('getRows');
   var $check=$("input[id*='checkOnePrescAll_']"); 
   for (var i=0;i<$check.length;i++){
	   if($("#checkOnePrescAll_"+i).is(':checked')) {
		   var prescno=rows[i].prescno;
		   if (!prescno) continue;
		   if (("^"+selPrescArr.join("^")+"^").indexOf("^"+prescno+"^")>=0) continue;
		   selPrescArr.push(prescno);
		   cookmode=rows[i].cookmode;
	   }
   }
	var selPrescStr=selPrescArr.join("^");
	if (selPrescStr =="") {
		$.messager.alert("提示","请选择需要修改煎药方式的处方!");
		return false;
	}else if(selPrescArr.length >1){
		$.messager.alert("提示","请选择单条处方!");
		return false;
	}
	var rtnValue = $.cm({
		ClassName:"web.UDHCPrescriptQueryCM",
		MethodName:"CheckBeforeUpdateCookMode",
		dataType:"text",
		PrescNo:selPrescArr.join("^"),
		dataType:"text"
    },false);
	if (rtnValue !="") {
		$.messager.alert("提示",rtnValue);
		return false;
	}
	InitCookType(cookmode,prescno);
	$("#cookModeDialog").window("open");
}
//初始化煎药类型
function InitCookType(cookType,prescno){
	$.cm({
		ClassName:'DHCDoc.OPDoc.CMOrderEntry',
		MethodName:'GetCMComList',
		ComboName:'CookMode',
		ExpStr:ServerObj.EpisodeID+'^^'+prescno
	},function(data){
		var newData=new Array();
		$.each(data,function(){
			if(this.Desc!=cookType){
				newData.push(this);
			}
		});
		$('#CookModelist').combobox({
	    	valueField:'RowID',   
			textField:'Desc',
			editable:false,
			data:newData
		});
	});
}
function UpdatePrescNoCookMode(){
	var NewCookMode=$("#CookModelist").combobox('getText');
	var NewCookModeDr=$("#CookModelist").combobox('getValue');
	if (!NewCookModeDr) NewCookModeDr="",NewCookMode="";
	var cookmode="";
	var selPrescArr=new Array();
	/*var rows=CMPrescListDataGrid.datagrid('getSelections');        
	for (var i=0;i<rows.length;i++){
		var prescno=rows[i].prescno;
		if (!prescno) continue;
		if (("^"+selPrescArr.join("^")+"^").indexOf("^"+prescno+"^")>=0) continue;
		selPrescArr.push(prescno);
		cookmode=rows[i].cookmode;
	}*/
	var rows=CMPrescListDataGrid.datagrid('getRows');
    var $check=$("input[id*='checkOnePrescAll_']"); 
    for (var i=0;i<$check.length;i++){
	   if($("#checkOnePrescAll_"+i).is(':checked')) {
		   var prescno=rows[i].prescno;
		   if (!prescno) continue;
		   if (("^"+selPrescArr.join("^")+"^").indexOf("^"+prescno+"^")>=0) continue;
		   selPrescArr.push(prescno);
		   cookmode=rows[i].cookmode;
	   }
    }
	var PrescNo=selPrescArr.join("^");
	$.messager.confirm("确认对话框", $g("是否确定将处方")+"<font color=red>"+PrescNo+"</font>"+$g("原煎药方式：")+"<font color=red>"+cookmode+"</font> "+$g("修改为：")+"<font color=red>"+NewCookMode+"</font>？", function (r) {
		if (r) {
			var LogonInfo=session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.USERID']+"^"+session['LOGON.HOSPID'];
			var rtn = $.cm({
				ClassName:"web.UDHCPrescriptQueryCM",
				MethodName:"UpdateCookMode",
				dataType:"text",
				PrescNo:PrescNo,
				NewCookModeDr:NewCookModeDr,
				LogonInfo:LogonInfo,
				dataType:"text"
		    },false);
		    if (rtn.split("^")[0] ==0) {
			    $.messager.alert("提示","煎药费申请成功！如果之前已经缴纳了煎药费请到收费处退费，然后再缴纳新的煎药费!","info",function(){
					$("#cookModeDialog").window("close");
					LoadOutPatientDataGrid();
				});
			}else{
				$.messager.alert("提示",$g("修改煎药费失败！")+rtn.split("^")[1]);
			}
		}
	});
	
}