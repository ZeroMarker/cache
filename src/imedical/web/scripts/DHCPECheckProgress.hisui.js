
//名称	DHCPECheckProgress.hisui.js
//功能	体检过程查询
//创建	2019.06.24
//创建人  xy

$(function(){
			
	InitCombobox();
	
	InitCheckProgressGrid();  
     
    //查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
    
	 $("#RegNo").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();
			}
			
        });

	 $("#Name").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();
			}
			
        });

    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });
    
    //加项
    $("#BAddItem").click(function() {	
		BAddItem_click();		
        });
    
    //收表
    $("#BRec").click(function() {	
		BRec_click();		
        });
   
    //粘贴
    $("#BSendAudit").click(function() {	
		BSendAudit_click();		
        });
        
    //报告已完成
    $("#BReport").click(function() {	
		BReport_click();		
        });
    
    //取报告
    $("#BFetchReport").click(function() {	
		BFetchReport_click();		
        });
        
    //报告预览
    $("#BReportView").click(function() {	
		BReportView_click();		
        });
    
    //发短信
    $("#BSendMessage").click(function() {	
		BSendMessage_click();		
        });
    
})



//粘贴
function BSendAudit_click(){
	  lnk="dhcpesendaudit.hisui.csp"
	 //websys_lu(lnk,false,'width=1400,height=600,hisui=true,title=粘贴')  
	 var wwidth=1430;
	 var wheight=600;
	 var xposition = 0;
	 var yposition = ((screen.height - wheight) / 2)-10;

	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
}

//报告已完成
 function BReport_click(){
	 //var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPESendReportMessage";
	  var lnk="dhcpesendreportmessage.hiui.csp"
	// websys_lu(lnk,false,'width=1400,height=600,hisui=true,title=报告已完成') 
	 var wwidth=1430;
	var wheight=600;
	var xposition = 0;
	 var yposition = ((screen.height - wheight) / 2)-10;

	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	  
	 
 }
 
//收表
function BRec_click(){
	
	//var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPERecPaper";
	var lnk="dhcperecpaper.hisui.csp";				
	//websys_lu(lnk,false,'width=1400,height=800,hisui=true,title=收表')  
	 var wwidth=1430;
	var wheight=1430;
	var xposition = 0;
	 var yposition = 0;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)  
   
}

//取报告
function BFetchReport_click(){
	  
	var lnk="dhcpefetchreport.hisui.csp";
	//websys_lu(lnk,false,'width=1430,height=600,hisui=true,title=取报告') 
	var wwidth=1430;
	var wheight=600;
	var xposition = 0;
	 var yposition = ((screen.height - wheight) / 2)-10;

	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
}

//发短信
function BSendMessage_click(){
	var Type="PAADM",flag=0;
	var InfoStr=GetSelectId();
	if(InfoStr==""){
			$.messager.alert("提示","请选择待发送短信的人员","info");
			return;
	}
	var Stars=InfoStr.split(";")
	for(var PSort=0;PSort<Stars.length;PSort++)
	{
		var Star=Stars[PSort];
		var ret=tkMakeServerCall("web.DHCPE.SendMessage","SaveMessage",Type,Star);
		if (ret!=0) {var flag=1;}	
	
	}
	BFind_click();
	
}
function GetSelectId() 
{   
	var selectrow = $("#CheckProgressGrid").datagrid("getChecked");//获取的是数组，多行数据
	var SelectIds=""
	var Content=$.trim($("#Content").val());
	if (Content=="") {
			$.messager.alert("提示","短信内容不能为空","info");
			return;
		}
	for(var i=0;i<selectrow.length;i++){
		var ID=selectrow[i].TPAADM;
		var RegNo=selectrow[i].TRegNo;
		var TTel=$.trim(selectrow[i].TTel);
		if (TTel=="") {
			$.messager.alert("提示","电话不能为空","info");
			continue;
		}
		if (!isMoveTel(TTel))
		{
			$.messager.alert("提示","电话号码不正确","info");
			continue;
		}
	
		if (SelectIds=="") {SelectIds=ID+"^"+RegNo+"^"+TTel+"^"+Content;}
			else {SelectIds=SelectIds+";"+ID+"^"+RegNo+"^"+TTel+"^"+Content;}
	
	}
  return SelectIds;
	
}

///判断移动电话
function isMoveTel(elem){
	if (elem=="") return true;
	var pattern=/^0{0,1}13|15|18[0-9]{9}$/;
	if(pattern.test(elem)){
		return true;
	}else{

	return false;
 	}
}


//报告预览
function BReportView_click(){
	var selectrow = $("#CheckProgressGrid").datagrid("getChecked");//获取的是数组，多行数据
	var selectlen=selectrow.length;
	if(selectlen==""){
			$.messager.alert("提示","请选择待预览报告的人员","info");
			return false;
	   }
	if(selectlen>1){
			$.messager.alert("提示","预览报告不能选择多人","info");
			return false;
	   }
	 var PAADM=selectrow[0].TPAADM;

	 var NewVerReportFlag=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",session['LOGON.CTLOCID'],"NewVerReport");
	if(NewVerReportFlag=="Word"){
		calPEReportProtocol("BPrintView",PAADM);	
	}if(NewVerReportFlag=="Lodop"){
		if (PAADM==""){
			$.messager.alert("提示","就诊ID不空","info");
		    return false;
		}else{
			//calPEReportProtocol("BPrintView",PAADM);
			PEPrintReport("V",PAADM,""); //lodop+csp预览体检报告
		} 
		return false;
	}else{
	
	var wwidth=1200;
	var wheight=500;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	
	var repUrl="dhcpeireport.normal.csp?PatientID="+PAADM+"&OnlyRead=Y";
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	var cwin=window.open(repUrl,"_blank",nwin)
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


//加项
function BAddItem_click()
{
	var selectrow = $("#CheckProgressGrid").datagrid("getChecked");//获取的是数组，多行数据
	var selectlen=selectrow.length;
	
	
	if(selectlen==""){
			$.messager.alert("提示","请选择待加项的人员","info");
			return false;
	   }
	if(selectlen>1){
			$.messager.alert("提示","加项不能选择多人","info");
			return false;
	   }
	   
	var PreOrAdd="PRE";
	var GroupFlag=0;
	///如果是团体中的个人当作额外加项
	if(selectrow[0].TGroupDesc!=""){
			PreOrAdd="ADD";
			GroupFlag=1;
	}
	
	var iRowId=selectrow[0].TPreIADM;
	var lnk="dhcpepreitemlist.main.hisui.csp"+"?AdmType=PERSON"
			+"&AdmId="+iRowId+"&PreOrAdd="+PreOrAdd
			;
    
	websys_lu(lnk,false,'width=1400,height=750,hisui=true,title=加项')
}



//查询
function BFind_click(){
	
	var RegNo=$("#RegNo").val();
	if(RegNo!="") {
		var RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo);
		$("#RegNo").val(RegNo)
		}

	var GADMID=$("#GADMDesc").combogrid('getValue');
	if (($("#GADMDesc").combogrid('getValue')==undefined)||($("#GADMDesc").combogrid('getValue')=="")){var GADMID="";} 
	var CheckStatus=$("#CheckStatus").combobox('getValue');
	if (($("#CheckStatus").combobox('getValue')==undefined)||($("#CheckStatus").combobox('getValue')=="")){var CheckStatus="";} 
	
	$("#CheckProgressGrid").datagrid('load',{
			ClassName:"web.DHCPE.Report.DoctorWorkStatistic",
			QueryName:"CheckProgress",
			DateBegin:$("#BeginDate").datebox('getValue'),
			DateEnd:$("#EndDate").datebox('getValue'),
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			SexDR:$("#Sex").combobox('getValue'),
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			GADMID:GADMID,
			DietFlag:$("#DietFlag").combobox('getValue'),
			ReCheck:$("#ReCheck").combobox('getValue'),
			CheckStatus:CheckStatus,
			Depart:$("#Depart").val(),
			});
}


//清屏
function BClear_click(){
	
	$("#BeginDate,#EndDate").datebox('setValue');
	$(".hisui-combobox").combobox('setValue',"");
	$(".hisui-combogrid").combogrid('setValue',"");
	$("#RegNo,#Name,#Content,#Depart").val("");
	
	InitCombobox();
	BFind_click();
}

//未完成项目
function UComItemDetail(PAADM){
	//lnk="dhcpeshowinfo.csp"
     lnk="dhcpenocheckitemdetail.hisui.csp"
          +"?EpisodeID="+PAADM;
	websys_lu(lnk,false,'width=900,height=260,hisui=true,title=未检项目详情') 
   
}

function InitCheckProgressGrid(){
	
		$HUI.datagrid("#CheckProgressGrid",{
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
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Report.DoctorWorkStatistic",
			QueryName:"CheckProgress",

		},
		frozenColumns:[[
			{field: 'Select',width: 70,checkbox:true,title:'选择',},
			{field:'TRegNo',width:100,title:'登记号'},
			{field:'TName',width:100,title:'姓名'},
			{field:'THPNo',width:100,title:'体检号'}
			
		]],
		columns:[[
		
			{field:'TPAADM',title:'PAADM',hidden: true},
			{field:'TPreIADM',title:'PreIADM',hidden: true},
			{field:'TReportID',title:'ReportID',hidden: true},
			{field:'TSex',width:50,title:'性别'},
			{field:'TUnCheckItems',width:100,title:'未完成项目',
			    
				formatter:function(value,rowData,rowIndex){	
					if(value!=""){
						return "<a href='#'  class='grid-td-text' onclick=UComItemDetail("+rowData.TPAADM+"\)>有</a>";
			
					}
					if(value==""){
						return "<a href='#' class='grid-td-text'>无</a>";
					
					}
	
				}},
			{field:'THadRec',width:50,title:'收表',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="1") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"	
					return rvalue;
				
				}},
			
			{field:'TSendAudit',width:50,title:'粘贴',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="1") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"	
					return rvalue;
				
				}},
			{field:'TReportAudit',width:50,title:'初审',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="1") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"	
					return rvalue;
				}},
			{field:'TMainAudit',width:60,title:'复审',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="1") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"	
					return rvalue;
				
				}},
			{field:'TReportPrint',width:80,title:'报告打印',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value!="") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"	
					return rvalue;
				}},
			{field:'TFetchReport',width:60,title:'已取',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="1") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"	
					return rvalue;
				
				}},
			{field:'THadSendMessage',width:100,title:'是否已发送',
			formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="1") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"	
					return rvalue;
				
				}},
			{field:'TAge',width:60,title:'年龄'},
			{field:'PACCardDesc',width:90,title:'证件类型'},
			{field:'IDCard',width:160,title:'证件号'}, 
			{field:'TPosition',width:80,title:'部门'},
			{field:'TTel',width:120,title:'电话'},
			{field:'TVIPLevel',width:80,title:'VIP等级'},
			{field:'TCheckDate',width:100,title:'检查日期'},
			{field:'TGroupDesc',width:120,title:'团体名称'},  
			{field:'TDietFlag',width:60,title:'早餐',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
	   				if (value=="1") {checked="checked=checked"}
					else{checked=""}
					var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"	
					return rvalue;
				
				}},
			
			
			
		]]
			
	})	
}



function InitCombobox(){
	
	
	//VIP等级	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		});
	
	
	//状态
	var CheckStatusObj = $HUI.combobox("#CheckStatus",{
		valueField:'id',
		textField:'text',
		panelHeight:'240',
		data:[
            {id:'1',text:'未收表'},
            {id:'2',text:'未粘贴'},
            {id:'3',text:'未初检'},
            {id:'4',text:'未复检'},
            {id:'5',text:'未打印'},
            {id:'6',text:'未取'},
            {id:'7',text:'已取'},  
        ]

	});	
	
	//复查
	var ReCheckObj = $HUI.combobox("#ReCheck",{
		valueField:'id',
		textField:'text',
		panelHeight:'80',
		data:[
            {id:'0',text:'非复查'},
            {id:'1',text:'复查'},
        ]

	});	
	//早餐
		var DietObj = $HUI.combobox("#DietFlag",{
		valueField:'id',
		textField:'text',
		panelHeight:'80',
		data:[
            {id:'0',text:'无'},
            {id:'1',text:'有'},
        ]

	});
	
	
	//性别
	var SexObj = $HUI.combobox("#Sex",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindSex&ResultSetType=array",
		valueField:'id',
		textField:'sex',
		panelHeight:'130',
	});
	
	
	//团体
	var GADMDescObj = $HUI.combogrid("#GADMDesc",{
		panelWidth:300,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGAdm&QueryName=GADMList",
		mode:'remote',
		delay:200,
		idField:'TRowId',
		textField:'TGDesc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
		},
		onShowPanel:function()
		{
			$('#GADMDesc').combogrid('grid').datagrid('reload');
		},
		columns:[[
			{field:'TRowId',title:'ID',hidden: true},
			{field:'TGDesc',title:'团体名称',width:200},
			{field:'TGStatus',title:'状态',width:100},
			{field:'TAdmDate',title:'时间',width:100},
				
		]]
		});

	
}