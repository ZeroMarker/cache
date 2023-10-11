
//名称	DHCPERecPaper.hisui.js
//功能	收表hisui
//创建	2019.10.15
//创建人  xy

$(function(){
		
	InitCombobox();
	
	//收表记录列表
	InitRecPaperDataGrid();
	
	//就这记录列表
	InitPIADMRecordDataGrid();
            
     //查询
	$("#BFind").click(function() {	
		BFind_click();		
        });  
        
    //打印
	$("#BPrint").click(function() {	
		BPrint_click();		
        });
		
	//延期
    $("#BYQAll").click(function() {
			YQAll_click();	
		});
         
    //收表
	$("#BRecpaper").click(function() {	
		BRecpaper_click();		
        });
   
   $("#RegNo").keydown(function(e) {	
			if(e.keyCode==13){
				BFind_click();
				}
	});
	
	//请确认收表
   	$("#ConfirmRecPaper").keydown(function(e) {
			
			if(e.keyCode==13){
				ConfirmRecPaper_KeyDown();
				}
		});
		
	//默认送达方式
	$("#SendMethod").combobox('setValue',"ZQ");
   
   //默认报告约期
	DefaultReportDate();
	
	//默认查询时间为当天
    Initdate();
    
     $("#ALLPerson").checkbox({
        
      		onCheckChange:function(e,value){
	       	 	if(value) {$("#ALLGroup").checkbox('setValue',false);}
	       	 		        
        	}
        });
		
    $("#ALLGroup").checkbox({
        
      		onCheckChange:function(e,value){
	       	 	if(value) {$("#ALLPerson").checkbox('setValue',false);}
	       	 		        
        	}
        }); 

})
function YQAll_click()
{
	var UserID=session['LOGON.USERID'];
	var today = getDefStDate(0);
	var PAADM=$("#PAADM").val();
	if(PAADM==""){
		$.messager.alert("提示","请选择待延期的人员","info"); 
		return false;
	}

	var YQDate=$("#YQDate").datebox('getValue')
	if(YQDate==""){
		$.messager.alert("提示","请选择延期日期","info");	
		return false;
	}

	var todayLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",today);
	var YQDateLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",YQDate);
	if(YQDateLogical<=todayLogical){
		$.messager.alert("提示","延期日期应大于今天","info");	
		return false;
	}

	var IfComplateAll=$("#IfComplateAll").combobox('getValue');
	if(IfComplateAll==""){
		$.messager.alert("提示","请选择是否做完出总检","info");	
		return false;
	}

	var ret=tkMakeServerCall("web.DHCPE.OrderPostPoned","DelayRecord",$("#PAADM").val(),YQDate,IfComplateAll,"",UserID)
	if((ret>0)||(ret==0)){
		$.messager.alert("提示","延期成功","success");	
	}else{
		$.messager.alert("提示","延期失败","error");	
		return false;
	}
	var RefuseItemYQ=tkMakeServerCall("web.DHCPE.OrderPostPoned","GetHadDelayItems",PAADM);
	
	$("#RefuseItemInfoYQ").text(RefuseItemYQ);
	KeyWordsLoadYQ();
}

function BRecpaper_click()
{	
	
	var PAADM=$("#PAADM").val();
	if(PAADM==""){
			$.messager.alert("提示","请选择待收表的就诊记录","info");
		   return false;
		}
		
		
	/*	
	// 患者签名begin
	var rtn=tkMakeServerCall("web.DHCPE.ResultEdit","GetRefuseItems",PAADM);
	var items=rtn.split(";")[0]
	if(items!=""){
		var isSigned = false;
		if (!handSignInterface && !handSignInterface.checkStatus()) {
			alert('请配置手写签名设备');
			return true;
		}
			//alert(2)
			try {
			// 获取图片
			//debugger;
			var evidenceData = handSignInterface.getEvidenceData();
			
			if (typeof evidenceData === 'undefined')
				return;
			//evidenceData = $.parseJSON(evidenceData);
			var PatInfos=tkMakeServerCall("web.DHCPE.CA.HandSign","GetCRMADMAndNameByPAADM",ipaadm);
			var CRM=PatInfos.split("^")[0];
			var Name=PatInfos.split("^")[1];
			//// DHCPEHandSignMassage 的Code
			var TypeCode="02";
			var signLevel = 'Patient';
			var signUserId = handSignInterface.getUsrID(evidenceData);
			var userName = 'Patient';
			var actionType = 'Append';
			var description = '患者';
			var img = handSignInterface.getSignScript(evidenceData);
			var headerImage = handSignInterface.getSignPhoto(evidenceData);
            var fingerImage = handSignInterface.getSignFingerprint(evidenceData);
			// 获取编辑器hash
			var signinfo=tkMakeServerCall("web.DHCPE.CA.HandSign","GetInfoByCode",TypeCode,Name,items)
			//alert("signinfo"+signinfo)
			var record=tkMakeServerCall("web.DHCPE.CA.HandSign","RecordInfo",CRM,signinfo)
			var signInfo = HashData(signinfo);
				isSigned = true;
				// 签名
				var signValue = handSignInterface.getSignDataValue(evidenceData.Hash, signInfo);
				if ('' == signValue)
					return;
				signValue = $.parseJSON(signValue);
				//debugger;
				// 向后台保存
				
				
				var argsData = {
					Action: 'SaveSign',
					CRM: CRM,
					Code:TypeCode,
					Algorithm: handSignInterface.getAlgorithm(signValue),
					BioFeature: handSignInterface.getBioFeature(signValue),
					EventCert: handSignInterface.getEventCert(signValue),
					SigValue: handSignInterface.getSigValue(signValue),
					TSValue: handSignInterface.getTSValue(signValue),
					Version: handSignInterface.getVersion(signValue),
					SignScript: img,
					HeaderImage: headerImage,
					Fingerprint: fingerImage,
					PlainText: signInfo
				};
				
				$.ajax({
					
					type: 'POST',
					dataType: 'text',
					url: '../web.DHCPE.CA.HandSign.cls',
					async: true,
					cache: false,
					data: argsData,
					success: function (ret) {
						//alert("11ret"+ret)
						ret = $.parseJSON(ret);
						//alert("ret"+ret)
						if (ret.Err || false) {
							throw {
								message : 'SaveSignInfo 失败！' + ret.Err
							};
						} else {
							if ('-1' == ret.Value) {
								throw {
									message : 'SaveSignInfo 失败！'
								};
							} else {
								var signId = ret.Value;
								//parEditor.saveSignedDocument(parEditor.instanceId, signUserId, signLevel, signId, signInfo.Digest, 'AnySign', signInfo.Path, actionType);
							}
						}
					},
					error: function (err) {
						throw {
							message : 'SaveSignInfo error:' + err
						}; 
					}
				});
				} catch (err) {
			//debugger
			if (err.message === '用户取消签名,错误码：61') {
				return;
			}
			else if (isSigned) {
				//parEditor.unSignedDocument();
			}
			//alert(err.message);
		}
		
		
		
		
		
		}
	// 患者签名end
	*/
	
	var iReportDate=$("#ReportDate").datebox('getValue')
	var iSendMethod=$("#SendMethod").combobox("getValue"); 
	if (($("#SendMethod").combobox("getValue")==undefined)||($("#SendMethod").combobox("getValue")=="")){var iSendMethod="";}
	
	if(iReportDate==""){
		$.messager.alert("提示","请选择报告约期","info");
		   return false;
		}
	if(iSendMethod==""){
		$.messager.alert("提示","请选择送达方式","info");
		   return false;
		}
	var iRemark=$("#Remark").val();
	var Return=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetRecPaperNew",PAADM,iReportDate,iSendMethod,iRemark);
	var ret=Return.split("#");
	if (ret[0]!=0)
	{ 
		$.messager.alert("提示",ret[0],"info");
    }else{
	    	$.messager.alert("提示","收表成功","success");
	    	var flag=tkMakeServerCall("web.DHCPE.TransResult","TransMain",PAADM);
	    	if(ret[1]=="Y"){
		    	var value=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetBaseInfo",PAADM,iReportDate);
		    	if(value!=""){PrintGetReportPT(value); }//打印取报告凭条
	    	}
	    	
	    }
	  
	  
	  //刷新收表区域
     BFind_click();
    
	 if($("#ConfirmRecPaper").val()!=""){
		//刷新就诊记录区域
		var PADM="";
		 var PADMS=tkMakeServerCall("web.DHCPE.PreIADMEx","GetNoRecPaperRecord",$("#ConfirmRecPaper").val());
		if (PADMS.split("^")[0]!="0"){
			alert(PADMS.split("^")[1]);
			return false;
		}
		var PADM=PADMS.split("^")[1];
		 loadPIADMRecord(PADM);
     }
     //清除数据
     BClear();
}

function BClear()
{
	$("#PAADM").val("");
	$("#NoSummitStationInfo").text("");
	$("#RefuseItemInfo").text("");
	$("#Remark").val("");

	//默认报告约期
	DefaultReportDate();

	 KeyWordsLoad();
	 KeyWordsLoadYQ();
}

function ConfirmRecPaper_KeyDown()
{
	
	var iReportDate="",iRegNo="";
	
	var iRegNo=$("#ConfirmRecPaper").val(); 
	if(iRegNo!="") {
	 	var iRegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":iRegNo
		}, false);
		
			$("#ConfirmRecPaper").val(iRegNo)
		}	
	if (iRegNo=="") 
	   {
			$.messager.popover({msg: "请输入登记号", type: "info"});
		   //$.messager.alert("提示","请输入登记号","info");
		   return false;
	   }
		var PADMS=tkMakeServerCall("web.DHCPE.PreIADMEx","GetNoRecPaperRecord",iRegNo);
		if (PADMS.split("^")[0]!="0"){
			//alert(PADMS.split("^")[1]);
			$.messager.popover({msg: PADMS.split("^")[1], type: "info"});
			return false;
		}
		var PADM=PADMS.split("^")[1];
		if (PADM==""){
			//$.messager.alert("提示","没有要收表的记录","info");
			$.messager.popover({msg: "没有要收表的记录", type: "info"});
			return false;
			}
		var PADMArr=PADM.split("$");
		
		loadPIADMRecord(PADM);
		if (PADMArr.length>2){
           
   
		}
		else{
		var PAADM=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetPAADMbyPreIADM",PADMArr[0]); 
		var Flag=""
		if (PAADM!="")
		{
			var Flag=tkMakeServerCall("web.DHCPE.ResultEdit","GetUnAppedItems","",PAADM,"1","0");
		
       if(Flag!=""){
	       		var RefuseItem="",NoSummitStation="";
		       //未提交站点
				var NoSummitStationStr=tkMakeServerCall("web.DHCPE.ResultDiagnosis","StationSHadSubmit",PAADM);
				var NoSummitStation=NoSummitStationStr.split("^")[1];
				$("#NoSummitStationInfo").text(NoSummitStation)
				//谢绝检查项目
	            var RefuseItem=tkMakeServerCall("web.DHCPE.ResultEdit","GetRefuseItems",PAADM);
	            $("#RefuseItemInfo").text(RefuseItem)
	            //谢绝检查关键字列表动态显示
	            $("#PAADM").val(PAADM);
				var RefuseItemYQ=tkMakeServerCall("web.DHCPE.OrderPostPoned","GetHadDelayItems",PAADM);
	            	
	            $("#RefuseItemInfoYQ").text(RefuseItemYQ)
	            
	            //谢绝检查关键字列表动态显示
	            $("#PAADM").val(PAADM);
	            KeyWordsLoad();
				KeyWordsLoadYQ();
				
	       
       		}
		}
		
		}
	
			
	
}


function InitPIADMRecordDataGrid()
{
	$HUI.datagrid("#PIADMRecordQueryTab",{
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
		singleSelect: true,
		selectOnCheck: true,
		toolbar: [], //配置项toolbar为空时,会在标题与列头产生间距"
		queryParams:{
			ClassName:"web.DHCPE.PreIADMEx",
			QueryName:"SearchPreIADM",	
		},
		frozenColumns:[[
			{field:'PIBIPAPMINo',width:100,title:'登记号'},
		]],
		columns:[[
	
		    {field:'id',title:'id',hidden: true},
		    {field:'PIADMPIBIDR',title:'PIADMPIBIDR',hidden: true}, 
			{field:'PIADMPIBIDRName',width:100,title:'姓名'},
			{field:'PIADMPGADMDRName',width:200,title:'团体名称'},
			{field:'PIADMPGTeamDRName',width:120,title:'分组名称'},
			{field:'PIADMPEDateBegin',width:100,title:'体检日期'},
			{field:'PIADMOldHPNo',width:120,title:'体检号'},	
		]],
		onSelect: function (rowIndex, rowData) {
			var PatNo=rowData.PIBIPAPMINo;
			var PIADM=rowData.id;
			
			var PAADM=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetPAADMbyPreIADM",PIADM);
			$("#PAADM").val(PAADM);
			var Flag=""
			if (PAADM!="")
			{
				var Flag=tkMakeServerCall("web.DHCPE.ResultEdit","GetUnAppedItems","",PAADM,"1","0");
			}
		       var RefuseItem="",NoSummitStationSt="";
		       //未提交站点
				var NoSummitStationStr=tkMakeServerCall("web.DHCPE.ResultDiagnosis","StationSHadSubmit",PAADM);
				$("#NoSummitStationInfo").text("");
				$("#RefuseItemInfo").text("");
				if(NoSummitStationStr.indexOf("^")!="-1"){
					var NoSummitStation=NoSummitStationStr.split("^")[1];
					$("#NoSummitStationInfo").text(NoSummitStation);
				}

				//谢绝检查项目
	            var RefuseItem=tkMakeServerCall("web.DHCPE.ResultEdit","GetRefuseItems",PAADM);
	            $("#RefuseItemInfo").text(RefuseItem)
	             //延期检查项目
	            var RefuseItemYQ=tkMakeServerCall("web.DHCPE.OrderPostPoned","GetHadDelayItems",PAADM);
	            $("#RefuseItemInfoYQ").text(RefuseItemYQ)
	            //谢绝检查关键字列表动态显示
				KeyWordsLoad();
				//可延期未检项目关键字列表动态显示
				KeyWordsLoadYQ();
				$('#YQDate').datebox('setValue','');
				$("#Remark").val("");
				DefaultReportDate();
			
		},
		onLoadSuccess: function (data) {
	        
	        $("#PIADMRecordQueryTab").datagrid("selectRow",0); //默认选中第一行 
			
		}
	
	})
}

function loadPIADMRecord(PIADMs) {
	
	$('#PIADMRecordQueryTab').datagrid('load', {
		ClassName: 'web.DHCPE.PreIADMEx',
		QueryName: 'SearchPreIADM',
		PIADMs: PIADMs,
		
	});
		
}

//谢绝检查关键字列表动态显示
function KeyWordsLoad()
{	
	var UserID=session['LOGON.USERID'];

		$.cm({	
			ClassName: 'web.DHCPE.ResultEdit',
			MethodName: 'GetUnAppedItemsHisui',
			EpisodeID:$("#PAADM").val(),
			StationID:"",
			OEFlag:"1",
			LabRecFlag:"1",
		},function(data){
			$('#keywords').keywords({
    				items:data,
   				 	onSelect:function(v){
	   				 
	   				 $.messager.confirm("确认", "确实要放弃'"+v.text+"'吗", function(r){
					if (r){
						var OEID=v.id;
						var OEID=OEID.replace('-', '||');
						var ret=tkMakeServerCall("web.DHCPE.ResultEdit","RefuseCheck",OEID,"",UserID);
						 var RefuseItem=tkMakeServerCall("web.DHCPE.ResultEdit","GetRefuseItems",$("#PAADM").val());
	            		$("#RefuseItemInfo").text(RefuseItem);
						 //未提交站点
	            		var NoSummitStationStr=""
						var NoSummitStationStr=tkMakeServerCall("web.DHCPE.ResultDiagnosis","StationSHadSubmit",$("#PAADM").val());
						$("#NoSummitStationInfo").text("");
						if(NoSummitStationStr.indexOf("^")!="-1"){
								var NoSummitStation=NoSummitStationStr.split("^")[1];
								$("#NoSummitStationInfo").text(NoSummitStation);
						}
	            		KeyWordsLoad();
	            		var RefuseItemYQ=tkMakeServerCall("web.DHCPE.OrderPostPoned","GetHadDelayItems",$("#PAADM").val());
						//debugger; ///  
						$("#RefuseItemInfoYQ").text(RefuseItemYQ);
						KeyWordsLoadYQ();
			
					
						}
					});
	   				 	
   				 	}	 
			});
		});
		
		
}
//延期检查关键字列表动态显示
function KeyWordsLoadYQ()
{	

		$.cm({	
			ClassName: 'web.DHCPE.OrderPostPoned',
			MethodName: 'GetDelayItems',
			PAADM:$("#PAADM").val()	
		},function(data){
	
			$('#keywordsYQ').keywords({
				
    				items:data,
   				 	onSelect:function(v){
	   			
						var OEID=v.id;
						var OEID=OEID.replace('-', '||');
						var YQDate=$("#YQDate").datebox('getValue')
						if(YQDate==""){
							$.messager.alert("提示","请选择延期日期","info");	
							return false;
						}
						var today = getDefStDate(0);
						var todayLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",today);
						var YQDateLogical=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",YQDate);
						if(YQDateLogical<=todayLogical){
							$.messager.alert("提示","延期日期应大于今天！","info");	
							return false;
						}
						
						var IfComplateAll=$("#IfComplateAll").combobox('getValue');
						if(IfComplateAll==""){
							$.messager.alert("提示","请选择是否做完出总检！","info");	
							return false;
						}
						var UserID=session['LOGON.USERID'];
						var ret=tkMakeServerCall("web.DHCPE.OrderPostPoned","DelayRecord",$("#PAADM").val(),YQDate,IfComplateAll,OEID,UserID);
						
						 var RefuseItemYQ=tkMakeServerCall("web.DHCPE.OrderPostPoned","GetHadDelayItems",$("#PAADM").val());
						
	            		$("#RefuseItemInfoYQ").text(RefuseItemYQ);
	            		
	            		KeyWordsLoadYQ();
			
				
	   				 	
   				 	}	 
			});
		});
		
		
}

function CancelPaper(PIADM)
{
	
	if (PIADM=="")	{
		$.messager.alert("提示","请选择待取消收表的客户！","info");
		return false
	} 
	else{ 
		$.messager.confirm("确认", "确定要取消吗？", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.DHCPEIAdm", MethodName:"CancelRecPaper",PIADM:PIADM},function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("提示","取消收表失败！"+flag,"error");  
				}else{
					$.messager.popover({msg: '取消收表成功！',type:'success',timeout: 1000});
					BFind_click();
     
				}
			});	
		}
	});
	}
		

}



//查询
function BFind_click(){
	
	var iRegNo=$("#RegNo").val(); 
	if(iRegNo!="") {
	 	var iRegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":iRegNo
		}, false);
		
			$("#RegNo").val(iRegNo)
		}
	 var HospID=session['LOGON.HOSPID'];
	$("#RecPaperQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.DHCPEIAdm",
			QueryName:"SearchGPaperByRecDate",
			RecBegDate:$("#RecBegDate").datebox('getValue'),
			RecEndDate:$("#RecEndDate").datebox('getValue'),
			txtRegNo:$("#RegNo").val(),
			ArrivedFlag:$HUI.checkbox('#ArrivedFlag').getValue() ? "on" : "",
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			ALLGroup:$HUI.checkbox('#ALLGroup').getValue() ? "on" : "",
			ALLPerson:$HUI.checkbox('#ALLPerson').getValue() ? "on" : "",
			HospID:HospID
			})
	
}

function InitRecPaperDataGrid()
{
	var HospID=session['LOGON.HOSPID'];
	$HUI.datagrid("#RecPaperQueryTab",{
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
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.DHCPEIAdm",
			QueryName:"SearchGPaperByRecDate",
			RecBegDate:$("#RecBegDate").datebox('getValue'),
			RecEndDate:$("#RecEndDate").datebox('getValue'),
			txtRegNo:$("#RegNo").val(),
			ArrivedFlag:$HUI.checkbox('#ArrivedFlag').getValue() ? "on" : "",
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			ALLGroup:$HUI.checkbox('#ALLGroup').getValue() ? "on" : "",
			ALLPerson:$HUI.checkbox('#ALLPerson').getValue() ? "on" : "",
			HospID:HospID
		},
		frozenColumns:[[
			{field:'CancelPaper',title:'取消收表',width:'80',align:'center',
				formatter:function(value,rowData,rowIndex){
					if((rowData.PIADM!="")&&(rowData.TReceiver!="")){
						return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"  title="取消收表" border="0" onclick="CancelPaper('+rowData.PIADM+')"></a>';
					
					}
				}},
			{field:'TAdmNo',width:100,title:'登记号'},
			{field:'TPatNAME',width:80,title:'姓名'},
		]],
		columns:[[
	
		    {field:'PIADM',title:'PIADM',hidden: true},
		   
			{field:'TSex',width:45,title:'性别'},
			{field:'TReceiver',width:80,title:'收表人'},
			{field:'TReceivedDate',width:100,title:'收表日期'},
			{field:'TAge',width:45,title:'年龄',align:'center'},
			{field:'TGDesc',width:200,title:'团体名称'},
			{field:'TPosition',width:80,title:'部门'},
			{field:'TTel',width:120,title:'联系方式'},
			{field:'TReportDate',width:100,title:'报告约期'},
			{field:'TVip',width:80,title:'VIP等级'},
			{field:'TSendMethod',width:80,title:'发送方式'},
			{field:'TOrdSet',width:160,title:'套餐名称'},
			{field:'TAmount',width:90,title:'应收金额',align:'right'},
			{field:'TRemark',width:320,title:'备注'}
			
		]],
		onSelect: function (rowIndex, rowData) {
			  						
		}
		
			
	})

}


function InitCombobox()
{
	  // VIP等级	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
		valueField:'id',
		textField:'desc'
	})
	
	// 是否做完出总检
	var IfComplateAll = $HUI.combobox("#IfComplateAll",{
		valueField:'id',
		textField:'text',
		panelHeight:'140',
		data:[
            {id:'Y',text:$g('是')},
            {id:'N',text:$g('否')}
            
           
        ]

	});
	
	//送达方式
	var SendMethodObj = $HUI.combobox("#SendMethod",{
		valueField:'id',
		textField:'text',
		panelHeight:'140',
		data:[
            {id:'ZQ',text:$g('自取')},
            {id:'TQ',text:$g('统取')},
            {id:'KD',text:$g('快递')},
            {id:'DY',text:$g('电邮')},
            {id:'DZB',text:$g('电子版')}
           
        ]

	});
		
	
}

//默认报告约期
function DefaultReportDate()
{
	var mydate = new Date();
	var CurMonth=mydate.getMonth()+1;
	if((CurMonth<=9)&&(CurMonth>=0)){var CurMonth="0"+CurMonth;}
	var CurDate=mydate.getFullYear()+"-"+CurMonth+"-"+ mydate.getDate(); 
	var CurDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",CurDate);
	var CurDate=tkMakeServerCall("websys.Conversions","DateLogicalToHtml",parseInt(CurDate)+7);
   	$("#ReportDate").datebox('setValue',CurDate);
	 //默认送达方式
	$("#SendMethod").combobox('setValue',"DZB");
	//默认全部做完再总检
	$("#IfComplateAll").combobox('setValue',"Y");
}

//设置默认时间为当天
function Initdate()
{
	var today = getDefStDate(0);
	$("#RecBegDate").datebox('setValue', today);
	$("#RecEndDate").datebox('setValue', today);
}


function BPrintNew_click(){
	
		var RowsLen=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetRowLength");  
		if(RowsLen==0){
			$.messager.alert("提示","此次查询结果为空","info");	
	   		return;
		} 
	var iArrivedFlag="收表";
	var ArrivedFlag=$("#ArrivedFlag").checkbox('getValue');
	if(ArrivedFlag) {iArrivedFlag="未收表";}
	var BegDate=$("#RecBegDate").datebox('getValue')
	var EndDate=$("#RecEndDate").datebox('getValue')


	var HosName=""
	var HOSPID=session['LOGON.HOSPID']
    var HosName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",HOSPID);
    
	   var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	   var Templatefilepath=prnpath+'DHCPERecPaper.xls';
		var Str = "(function test(x){"+
		"var xlApp = new ActiveXObject('Excel.Application');"+
         "var xlBook = xlApp.Workbooks.Add('"+Templatefilepath+"');"+
         "var xlSheet = xlBook.ActiveSheet;"+
		 "xlSheet.Cells(1,1)='"+HosName+" "+BegDate+"--"+EndDate+iArrivedFlag+"统计数据';"
    
	 var ret=""
	var k=3
	for(var i=1;i<=RowsLen;i++)
	{  
		var DataStr=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetRowData",i); 
		var tempcol=DataStr.split("^"); 
		if(ret==""){
			k=k+1;
			 ret="xlSheet.Cells("+k+",1).Value='"+tempcol[0]+"';"+  
			 	"xlSheet.Cells("+k+",2).Value='"+tempcol[1]+"';"+  
			 	"xlSheet.Cells("+k+",3).Value='"+tempcol[2]+"';"+  
			 	"xlSheet.Cells("+k+",4).Value='"+tempcol[3]+"';"+
			 	"xlSheet.Cells("+k+",5).Value='"+tempcol[4]+"';"+  
			 	"xlSheet.Cells("+k+",6).Value='"+tempcol[5]+"';"+  
			 	"xlSheet.Cells("+k+",7).Value='"+tempcol[6]+"';"+  
			 	"xlSheet.Cells("+k+",8).Value='"+tempcol[7]+"';"+  
			 	"xlSheet.Cells("+k+",9).Value='"+tempcol[8]+"';"+  
			 	"xlSheet.Cells("+k+",10).Value='"+tempcol[9]+"';"+  
			 	"xlSheet.Cells("+k+",11).Value='"+tempcol[10]+"';" 
		}else{
			k=k+1;
			ret=ret+"xlSheet.Cells("+k+",1).Value='"+tempcol[0]+"';"+  
			 	"xlSheet.Cells("+k+",2).Value='"+tempcol[1]+"';"+  
			 	"xlSheet.Cells("+k+",3).Value='"+tempcol[2]+"';"+  
			 	"xlSheet.Cells("+k+",4).Value='"+tempcol[3]+"';"+
			 	"xlSheet.Cells("+k+",5).Value='"+tempcol[4]+"';"+  
			 	"xlSheet.Cells("+k+",6).Value='"+tempcol[5]+"';"+  
			 	"xlSheet.Cells("+k+",7).Value='"+tempcol[6]+"';"+  
			 	"xlSheet.Cells("+k+",8).Value='"+tempcol[7]+"';"+  
			 	"xlSheet.Cells("+k+",9).Value='"+tempcol[8]+"';"+  
			 	"xlSheet.Cells("+k+",10).Value='"+tempcol[9]+"';"+  
			 	"xlSheet.Cells("+k+",11).Value='"+tempcol[10]+"';" 
		}
		
		
	}  
	
	var Str=Str+ret+
		   "xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells("+k+",11)).Borders.LineStyle='1';"+
             "xlSheet.PrintOut();"+
          	"xlBook.Close(savechanges=false);"+
            "xlApp.Quit();"+
            "xlApp=null;"+
             "xlSheet=null;"+
            "return 1;}());";
           //alert(Str)
      //以上为拼接Excel打印代码为字符串
       CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
		var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
		return ; 
	
}
//打印
function BPrint_click()
{  
if (("undefined"==typeof EnableLocalWeb)||(0==EnableLocalWeb )){
    try{
	   var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	   var Templatefilepath=prnpath+'DHCPERecPaper.xls';
	
		xlApp = new ActiveXObject("Excel.Application");  //固定
		xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
		xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称
     
 
	var RowsLen=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetRowLength");  
	if(RowsLen==0){		
		alert("此次查询结果为空")
	   	return;
	} 
	var iArrivedFlag="收表";
	var ArrivedFlag=$("#ArrivedFlag").checkbox('getValue');
	if(ArrivedFlag) {iArrivedFlag="未收表";}
	var BegDate=$("#RecBegDate").datebox('getValue')
	var EndDate=$("#RecEndDate").datebox('getValue')


	var HosName=""
	var HOSPID=session['LOGON.HOSPID']
    var HosName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",HOSPID)

	xlsheet.cells(1,1)=HosName+" "+BegDate+"--"+EndDate+iArrivedFlag+"统计数据"

	var k=3
	for(var i=1;i<=RowsLen;i++)
	{  
		var DataStr=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetRowData",i); 
		var tempcol=DataStr.split("^"); 
		k=k+1;
		xlsheet.Rows(k).insert(); 
		xlsheet.cells(k,1)=tempcol[0];
		xlsheet.cells(k,2)=tempcol[1];
		xlsheet.cells(k,3)=tempcol[2];
		xlsheet.cells(k,4)=tempcol[3];
		xlsheet.cells(k,5)=tempcol[4];
		xlsheet.cells(k,6)=tempcol[5];
		xlsheet.cells(k,7)=tempcol[6];
		xlsheet.cells(k,8)=tempcol[7]; 
		xlsheet.cells(k,9)=tempcol[8];
		xlsheet.cells(k,10)=tempcol[9]; 
		xlsheet.cells(k,11)=tempcol[10];

		
	}   
	///删除最后的空行
	xlsheet.Rows(k+1).Delete;

    xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null

	idTmr   =   window.setInterval("Cleanup();",1); 
	 
}
catch(e)
	{
		alert(e+"^"+e.message);
	}
}else{
	BPrintNew_click()
}
}