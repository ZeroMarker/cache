//DHCPEIReport.hisui.js
//功能	个人报告	
//创建	2019.04.02
//创建人  xy

$(function(){
	 
	InitCombobox();
	
	InitIReportDataGrid();
	
	//查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
        
    //清屏 
    $("#BClear").click(function() {	
		 BClear_click();		
        }); 
 	
	$("#RegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				RegNoOnChange();
			}
			
        }); 
         	
    
     //导出结论
    $("#BExportED").click(function() {	
		BExportED_click();		
        });  
    
	Init();
   

})


function Init()
{
	 var NewVerReportFlag=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",session['LOGON.CTLOCID'],"NewVerReport");
    if(NewVerReportFlag=="Lodop"){
	     $("#BExport").css('display','none');//隐藏 
    }else{
	     $("#BExport").css('display','block');//显示
    }
}

function RegNoOnChange()
{
	
	var RegNo=$("#RegNo").val();	
 	if(RegNo!="") {
	 	var RegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":RegNo
		}, false);
		
			$("#RegNo").val(RegNo)
		}

	if (RegNo=="") return false;
	BFind_click();
		
}

//查询
function BFind_click(){
	var iSTatus=""
	
	//未审核
	var iSTatusNA=$("#STatusIsNoAudit").checkbox('getValue');
	if(iSTatusNA) {iSTatus=iSTatus+"^"+"NA";}
	
	//已审核
	var iSTatusA=$("#STatusIsCheched").checkbox('getValue');
	if(iSTatusA) {iSTatus=iSTatus+"^"+"A";}
	
	//已完成
	var iSTatusC=$("#HadCompete").checkbox('getValue');
	if(iSTatusC) {iSTatus=iSTatus+"^"+"C";}
	
	//已打印
	var iSTatusP=$("#STatusIsPrint").checkbox('getValue');
	if(iSTatusP) {iSTatus=iSTatus+"^"+"P";}
	
	//已取报告
	var iSTatusS=$("#STatusIsSend").checkbox('getValue');
	if(iSTatusS) {iSTatus=iSTatus+"^"+"S"; }
	
	//是否发送短信
	//var iSTatusS=$("#IsSendMessage").checkbox('getValue');
	//if(iSTatusS) {iSTatus=iSTatus+"^"+"S"; }

	
	$("#IReportQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.Report",
			QueryName:"SearchIReport",
	        RegNo:$("#RegNo").val(),
			PatName:$("#PatName").val(),
			DepartName:$("#DepartName").val(), 
			DateFrom:$("#DateFrom").datebox('getValue'),
			DateTo:$("#DateTo").datebox('getValue'),
			AuditDateFrom:$("#AuditDateFrom").datebox('getValue'),
			AuditDateEnd:$("#AuditDateEnd").datebox('getValue'),
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			GroupID:$("#GroupName").combogrid('getValue'),
			TeamID:$("#TeamName").combogrid('getValue'),
			IsSecret:IsSecret,
			DocDR:$("#DocName").combogrid('getValue'),
			ReportStatus:iSTatus,
			HospID:session['LOGON.HOSPID']
			})
	
}

//清屏 
function BClear_click(){
	$("#RegNo,#PatName,#DepartName").val("");
	$(".hisui-combobox").combobox('setValue',"");
	$(".hisui-combogrid").combogrid('setValue',"");
	$(".hisui-checkbox").checkbox('setValue',false);
	$("#DateFrom,#DateTo,#AuditDateFrom,#AuditDateEnd").datebox('setValue',"")
		InitCombobox();
		BFind_click()
	
}

//导出结论
function BExportED_cmdshell()
{
	var iPAADMDRStr=""
	var selectrow = $("#IReportQueryTab").datagrid("getChecked");//获取的是数组，多行数据
	for(var i=0;i<selectrow.length;i++){
		
     	var iPAADMDR=selectrow[i].RPT_PAADM_DR;
		if(iPAADMDRStr=""){iPAADMDRStr=iPAADMDR;}
		else{iPAADMDRStr=iPAADMDRStr+"^"+iPAADMDR;}		
		
	}
	
	if(iPAADMDRStr==""){
		$.messager.alert("提示","请选择待导出结论的人员","info");
		return false;
	}
	
	
	var wdCharacter=1;	
	var Str = "(function test(x){"+
		"var WordApp=new ActiveXObject('Word.Application'); "+

		"var wdOrientLandscape = 1;"+ 
		"WordApp.Application.Visible=true;"+ //执行完成之后是否弹出已经生成的word 
		"var myDoc=WordApp.Documents.Add();"+//创建新的空文档 
		//WordApp.ActiveDocument.PageSetup.Orientation = wdOrientLandscape//页面方向设置为横向 
		"WordApp.Selection.ParagraphFormat.Alignment=0;"+ //1居中对齐,0为居右 
		"WordApp.Selection.Font.Bold=false;"+ 
		"WordApp.Selection.Font.Size=20;"+ 
		"WordApp.Selection.TypeText('建议结果汇总');"+ 
		"WordApp.Selection.MoveRight("+wdCharacter+");"+　　　　//光标右移字符 
		"WordApp.Selection.TypeParagraph();"+ //插入段落 
		"WordApp.Selection.Font.Size=8;"+ 
		"WordApp.Selection.TypeParagraph();"+ //插入段落 
		"var myTable=myDoc.Tables.Add(WordApp.Selection.Range,1,3);"+ //1行7列的表格 
		"myTable.Style='网格型';"+ 
		//设置列宽
		"myTable.Columns(1).Width=45;"+
		"myTable.Columns(2).Width=35;"+
		"myTable.Columns(3).Width=380;"+
		//输出表头信息
		"myTable.Cell(1,1).Range.Text ='ID号';"+
		"myTable.Cell(1,2).Range.Text ='姓名';"+
		"myTable.Cell(1,3).Range.Text ='建议';";
		var appendStr="";	
		var iPAADMDR="",RegNo="",Name="";
		var Row=1;
		for(var i=0;i<selectrow.length;i++){
			
	     	    var iPAADMDR=selectrow[i].RPT_PAADM_DR;
				var Info=tkMakeServerCall("web.DHCPE.ReportGetInfor","GetGeneralAdviceByAdmJS",iPAADMDR);
				appendStr="myTable.Rows.add();";//新增行
				Row=Row+1;
				appendStr=appendStr+"myTable.Cell("+Row+",3).Range.Text='"+Info+"';";
				RegNo=selectrow[i].RPT_RegNo;
				appendStr=appendStr+"myTable.Cell("+Row+",1).Range.Text='"+RegNo+"';";;
				Name=selectrow[i].RPT_IADM_DR_Name;
				appendStr=appendStr+"myTable.Cell("+Row+",2).Range.Text='"+Name+"';";;
			
		}	        
        Str=Str+appendStr+"return 1;}());";
		CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
		var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
}
//导出结论
function BExportED_click()
{
	if(EnableLocalWeb==1){
		return BExportED_cmdshell();
	}
	var iPAADMDRStr=""
	var selectrow = $("#IReportQueryTab").datagrid("getChecked");//获取的是数组，多行数据
	for(var i=0;i<selectrow.length;i++){
		
     	var iPAADMDR=selectrow[i].RPT_PAADM_DR;
		if(iPAADMDRStr=""){iPAADMDRStr=iPAADMDR;}
		else{iPAADMDRStr=iPAADMDRStr+"^"+iPAADMDR;}		
		
	}
	
	if(iPAADMDRStr==""){
		$.messager.alert("提示","请选择待导出结论的人员","info");
		return false;
	}
	
	
	var WordApp=new ActiveXObject("Word.Application"); 
	var wdCharacter=1 
	var wdOrientLandscape = 1 
	WordApp.Application.Visible=true; //执行完成之后是否弹出已经生成的word 
	var myDoc=WordApp.Documents.Add();//创建新的空文档 
	//WordApp.ActiveDocument.PageSetup.Orientation = wdOrientLandscape//页面方向设置为横向 
	WordApp. Selection.ParagraphFormat.Alignment=0 //1居中对齐,0为居右 
	WordApp. Selection.Font.Bold=false; 
	WordApp. Selection.Font.Size=20 
	WordApp. Selection.TypeText("建议结果汇总"); 
	WordApp. Selection.MoveRight(wdCharacter);　　　　//光标右移字符 
	WordApp.Selection.TypeParagraph() //插入段落 
	WordApp. Selection.Font.Size=8 
	WordApp.Selection.TypeParagraph() //插入段落 
	var myTable=myDoc.Tables.Add (WordApp.Selection.Range,1,3) //1行7列的表格 
	myTable.Style="网格型" 
	var TableRange;
	//设置列宽
	myTable.Columns(1).Width=45;
	myTable.Columns(2).Width=35;
	myTable.Columns(3).Width=380;
	//输出表头信息
	myTable.Cell(1,1).Range.Text ="ID号";
	myTable.Cell(1,2).Range.Text ="姓名";
	myTable.Cell(1,3).Range.Text ="建议";
		
	var iPAADMDR="",RegNo="",Name="";
	var Row=1;
	for(var i=0;i<selectrow.length;i++){
		
     	    var iPAADMDR=selectrow[i].RPT_PAADM_DR;
			var Info=tkMakeServerCall("web.DHCPE.ReportGetInfor","GetGeneralAdviceByAdm",iPAADMDR);
			myTable.Rows.add();//新增行
			Row=Row+1;
			myTable.Cell(Row,3).Range.Text=Info;
			RegNo=selectrow[i].RPT_RegNo;
			myTable.Cell(Row,1).Range.Text=RegNo;
			Name=selectrow[i].RPT_IADM_DR_Name;
			myTable.Cell(Row,2).Range.Text=Name;
		
	}
	
}

function BPrintViewLodop(e){
	
	var selectrow = $("#IReportQueryTab").datagrid("getChecked");//获取的是数组，多行数据
	for(var i=0;i<selectrow.length;i++){
			var iPAADMDR=selectrow[i].RPT_PAADM_DR;
			var printerName=tkMakeServerCall("web.DHCPE.Report","GetVirtualPrinter");
			if (e.id=="BPrint"){//打印报告
				PEPrintReport("P",iPAADMDR,printerName);
			}else if (e.id=="BPrintView"){//打印预览
				PEPrintReport("V",iPAADMDR,printerName);
			}else if (e.id=="BPrintYGReport") {  // 乙肝报告
				var YGItemFlag = tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetYGItemFlag",iPAADMDR,"PAADM");
				if (YGItemFlag != "3") {
					if (YGItemFlag == "0") $.messager.alert("提示","无乙肝项目！","info");
					else if (YGItemFlag == "2") $.messager.alert("提示","乙肝项目已弃检！","info");
					else $.messager.alert("提示","乙肝项目无结果！","info");
					return false;
				}
				PEPrintOneFormatReport("P",iPAADMDR,printerName,"YGReport");
			}else{//导出报告
				PEPrintReport("E",iPAADMDR,printerName);
			} 
	}
	
	return false

}


function BPrintView(e){
	
	var iPAADMStr="", iRowID="",jarPAADM="",statusStr="";
	var selectrow = $("#IReportQueryTab").datagrid("getChecked");//获取的是数组，多行数据
	for(var i=0;i<selectrow.length;i++){
		
		var iPAADMDR=selectrow[i].RPT_PAADM_DR;
		if(jarPAADM=="") jarPAADM=iPAADMDR;
		else jarPAADM=jarPAADM+"#"+iPAADMDR;
		var Template=tkMakeServerCall("web.DHCPE.Report","GetTemplateName",iPAADMDR);
			if (Template!=""){
				if (iPAADMStr==""){iPAADMStr=iPAADMDR+";"+Template;}
				else{iPAADMStr=iPAADMStr+"^"+iPAADMDR+";"+Template;}
			}else{
				var RowID=selectrow[i].RPT_RowId;
				 if (iRowID==""){iRowID=RowID;}
				 else{ iRowID=iRowID+"^"+RowID;}
			}
			
	}
	
	
    var NewVerReportFlag=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",session['LOGON.CTLOCID'],"NewVerReport");
    //alert(NewVerReportFlag)
	//if(NewVerReportFlag=="Y"){
	if(NewVerReportFlag=="Word"){	
	
		if(e.id=="BExport"||e.id=="BPrint"||e.id=="BExportPDF"||e.id=="NoCoverPrint"||e.id=="BExportHtml"||e.id=="BPrintView"){
			if (jarPAADM==""){
				$.messager.alert("提示","请选择待打印报告","info");
			}else if(statusStr.indexOf("未")>0){
				$.messager.alert("提示","未初检，请核实报告状态","info");
			}else if(e.id=="BPrintView"&&jarPAADM.split("#").length>1){
				$.messager.alert("提示","不可批量预览，请重新选择！","info");
				
			}else{	
				calPEReportProtocol(e.id,jarPAADM);
			}		
			return false;
		} else if(e.id=="BPrintYGReport") {  // 乙肝报告只打印CSP模板
			BPrintViewLodop(e);	
		}
	
	}else if(NewVerReportFlag=="Lodop"){
		BPrintViewLodop(e);
		
	}else{
		
		if ((iRowID!="")||(iPAADMStr!="")){
			//alert(iRowID+"  @@iPAADMStr"+iPAADMStr);
			ShowPrintWindows(iRowID,iPAADMStr,e);
		}else{
			$.messager.alert("提示","请选择待打印报告！","info");
		}
	}
	return false;
}



//外部协议打开体检报告程序 
function calPEReportProtocol(sourceID,jarPAADM){

	var opType=(sourceID=="BPrint"||sourceID=="NoCoverPrint")?"2":(sourceID=="BPrintView"?"5":"1");
	if(opType=="2"){
		jarPAADM=jarPAADM+"@"+session['LOGON.USERID'];
	}
	var saveType=sourceID=="BExportPDF"?"pdf":(sourceID=="BExportHtml"?"html":"word"); 
	var printType=sourceID=="NoCoverPrint"?"2":"1";
	location.href="PEReport://"+jarPAADM+":"+opType+":"+saveType+":"+printType
}

//旧版打印报告
function ShowPrintWindows(iRowID,iPAADMStr,e) {
	var iPAADMDR='',iPAPMIDR="",iReportID="",iprnpath="",VipReturn="1",IsSendMessage="N"
	//alert(e.id)
	obj=document.getElementById("PAADMDR");
	if (obj){ iPAADMDR=obj.value; }
	obj=document.getElementById("PAPMIDR");
	if (obj){ iPAPMIDR=obj.value; }	
	obj=document.getElementById("GetIReportStatus");
	if (obj) var encmeth=obj.value;
	
	obj=document.getElementById("IsSendMessage");
	if (obj&&obj.checked) IsSendMessage="Y";
	
	var flag=cspRunServerMethod(encmeth,iPAPMIDR,"I");
	if (flag!=0)
	{	var eSrc=window.event.srcElement;
		if (eSrc.id!="BPrintView")
		{
			
			if (!confirm(t[flag])) {
			return false;
			}
		}
	}
	var Type="Export",OnlyAdvice="";
	var eSrc=window.event.srcElement;
	//alert(eSrc.id)
	if (eSrc.id=="BPrintView"){
		Type="View"
	}else if(eSrc.id=="BPrint"){
		Type="Print"
		var CoverFlag="0"
	}else if(eSrc.id=="BExportHtml"){
		Type="ExportHTML"
	}else if(eSrc.id=="SimPrint"){
		Type="Print"
		OnlyAdvice="N";
		var CoverFlag="0"
	}else if(eSrc.id=="NoCoverPrint"){
		Type="Print"
		var CoverFlag="1"
	}else if (eSrc.id=="BExportPDF"){
		Type="ExportPDF";
	}
	
	//alert(Type);
	obj=document.getElementById("prnpath");
	if (obj){ iprnpath=obj.value; }
	//alert(iPAADMStr);
	
	if (iPAADMStr!=""){
		PrintTemplateReport(iPAADMStr);
	}
	
	if (iRowID=="") return true;
	obj=document.getElementById("ReportNameBox");
	if (obj) { var iReportName=obj.value; }
	var width=screen.width-60;
	var height=screen.height-10;
	var nwin='toolbar=no,alwaysLowered=yes,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width='+width+',height='+height+',left=30,top=5';
 	
 	if ((Type=="Print")||((Type=="ExportPDF"))){
		
		var Arr=iRowID.split("^");
		
		var Length=Arr.length;
		for (var i=0;i<Length;i++)
		{
			var OneID=Arr[i]
			var lnk=iReportName+"?PatientID="+iPAADMDR+"&ReportID="+OneID+"&prnpath="+iprnpath+"&Type="+Type+"&OnlyAdvice="+OnlyAdvice+"&CoverFlag="+CoverFlag+"&IsSendMessage="+IsSendMessage;
			var ret=window.showModalDialog(lnk, "", "dialogwidth:800px;dialogheight:600px;center:1"); 
			//open(lnk,"_blank",nwin);
		}
	}else{
		
		var lnk=iReportName+"?PatientID="+iPAADMDR+"&ReportID="+iRowID+"&prnpath="+iprnpath+"&Type="+Type+"&OnlyAdvice="+OnlyAdvice+"&CoverFlag="+CoverFlag;
		open(lnk,"_blank",nwin);
	}
 	return false;
 
}
function InitIReportDataGrid(){
	
	$HUI.datagrid("#IReportQueryTab",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: false,
		checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Report",
			QueryName:"SearchIReport",
			RegNo:$("#RegNo").val(),
			PatName:$("#PatName").val(),
			DepartName:$("#DepartName").val(), 
			DateFrom:$("#DateFrom").datebox('getValue'),
			DateTo:$("#DateTo").datebox('getValue'),
			AuditDateFrom:$("#AuditDateFrom").datebox('getValue'),
			AuditDateEnd:$("#AuditDateEnd").datebox('getValue'),
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			GroupID:$("#GroupName").combogrid('getValue'),
			TeamID:$("#TeamName").combogrid('getValue'),
			ReportStatus:"",
			IsSecret:IsSecret,
			DocDR:$("#DocName").combogrid('getValue'),
			HospID:session['LOGON.HOSPID']
		},
		frozenColumns:[[
			{title: '选择',field: 'Select',width: 60,checkbox:true},
			{field:'RPT_RegNo',width:'100',title:'登记号'},
		]],
		columns:[[
			
			{field:'RPT_RowId',title:'RPT_RowId',hidden: true},
			{field:'RPT_IADM_DR',title:'RPT_IADM_DR',hidden: true},
			{field:'RPT_PAADM_DR',title:'RPT_PAADM_DR',hidden: true},
			{field:'RPT_IADM_DR_Name',width:'100',title:'姓名'},
			{field:'RPT_IADM_Sex',width:'60',title:'性别'},
			{field:'RPT_Age',width:'60',title:'年龄'},
			{field:'TDepartName',width:'100',title:'部门'},
			{field:'Tel',width:'110',title:'联系电话'},
			{field:'TVIPLevel',width:'60',title:'VIP等级'},
			{field:'RPT_AduitUser_DR_Name',width:'100',title:'审核人'},
			{field:'RPT_AduitDate',width:'100',title:'审核日期 '},
			{field:'RPT_PrintUser_DR_Name',width:'100',title:'打印人'},
			{field:'RPT_PrintDate',width:'100',title:'打印日期'},
			{field:'RPT_Status_Name',width:'100',title:'报告状态'},
			{field:'FetchReportUser',width:'100',title:'取报告人'},
			{field:'FetchReportDate',width:'100',title:'取报告时间'},
			{field:'RPT_SendUser_DR',width:'100',title:'发送人',hidden: true},
			{field:'RPT_SendDate',width:'100',title:'发送时间',hidden: true},
			{field:'UnAppedItems',width:'200',title:'未完成项目'},
			{field:'RPT_IADM_RegDate',width:'100',title:'到达日期'},
			{field:'THPNo',width:'100',title:'体检号'},
			{field:'RPT_GADM_DR_Name',width:'200',title:'团体'},
			{field:'TeamDRName',width:'100',title:'分组'},
			{field:'TPhotoFlag',width:'60',title:'片子'},
			{field:'PACCardDesc',width:'90',title:'证件类型'},
			{field:'IDCard',width:'180',title:'证件号'},

					
		]]
			
	})
		
}



	
function InitCombobox()
{
	// VIP等级	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		
		})
	
	//团体
	var GroupNameObj = $HUI.combogrid("#GroupName",{
		panelWidth:450,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGAdm&QueryName=GADMList",
		mode:'remote',
		delay:200,
		idField:'TRowId',
		textField:'TGDesc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
			param.ShowPersonGroup="1";
		},
		onChange:function()
		{
			TeamNameObj.clear();
			
		},
		columns:[[
			{field:'TRowId',title:'团体ID',width:80},
			{field:'TGDesc',title:'团体名称',width:140},
			{field:'TGStatus',title:'状态',width:100},
			{field:'TAdmDate',title:'日期',width:100}
			
			
			
		]]
		})
		
		//分组
		var TeamNameObj = $HUI.combogrid("#TeamName",{
		panelWidth:250,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGAdm&QueryName=DHCPEGItemList",
		mode:'remote',
		delay:200,
		idField:'GT_RowId',
		textField:'GT_Desc',
		onBeforeLoad:function(param){
			
			var PreGId=$("#GroupName").combogrid("getValue");
			param.GID = PreGId;
		},
		onShowPanel:function()
		{
			$('#TeamName').combogrid('grid').datagrid('reload');
		},
		columns:[[
			{field:'GT_Desc',title:'分组名称',width:140},
			{field:'GT_RowId',title:'分组ID',width:80}
			
		]]
	});
		
		
	//医生
	var DocNameObj = $HUI.combogrid("#DocName",{
		panelWidth:270,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUserNew&Type=GAuditStationS^JGAUDITSTATIONS^GMainAuditStationS^KGMAINAUDITSTATIONS",
		mode:'remote',
		delay:200,
		idField:'DocDr',
		textField:'DocName',
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		columns:[[
		    {field:'DocDr',title:'ID',width:60},
			{field:'DocName',title:'姓名',width:150}
				
		]]
	});
		
}
