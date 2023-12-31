var CARDNO="";
var CardTypeNew="";
var ADM="";
var ALLGRYFLAG="";
var PAPMIDR="";
var REGNO="";
var PatCardNo="";
var serverName="";
var CurPatientID="";
var StartDate = new Date();
StartDate.setDate(StartDate.getDate()-parseInt(DEFORDDAY));   //默认当天
StartDate = StartDate.Format(DateFormat);
var EndDate=new Date().Format(DateFormat);
var FirstLoad=true;
var TempCheckExecCode="",IsCheckExec="";	///患者清单同步护士执行
var ALLTABLES='patTable^patSYTable^patTestTable^patTreatTable^patJZTable^patBloodTable';
$(function(){
	initPage();
	initValue();
	showSetBtn();	///显示右上角状态改变按钮
	initMethod();   ///Dom元素绑定方法
	initCombobox();
	initTable();
	initTab();
	initBTN();
	initCSS(); 
	initAutoReloadTable();
})
function initPage(){
	if(!$("#leftAccordion").accordion("panels").length){
		$('#nurMainLayout').layout('hidden','west');
	}
	return;
}

function initCombobox(){
	
	if($("#execFormType").length>0){
		$HUI.combobox("#execFormType",{
			url:LINK_CSP+"?ClassName=web.DHCEMInComUseMethod&MethodName=JsonExecFormByGroup&GroupID="+$("#GroupID").val()+"&CTLocID="+$("#CtLocID").val()+"&LgHospID="+LgHospID,
			valueField:'value',
			textField:'text',
			onSelect:function(option){
		       
		    },
		    onLoadSuccess:function(jsonData){
				if(jsonData.length>0){
					if(ADMPATDEFFORMCODE!=""){
						for (k in jsonData){
							var thisItmData=jsonData[k];
							if(thisItmData.value==ADMPATDEFFORMCODE){
								$HUI.combobox("#execFormType").setValue(ADMPATDEFFORMCODE);
								//searchPatJZ()
								return;
							}
						}
					}
					$HUI.combobox("#execFormType").setValue(jsonData[0].value);	///默认第一条
				}
				//searchPatJZ();
			}	
		})
	}
	//$HUI.combobox("#execFormType").setValue("MZQBYZ");
}

function initCSS(){
	$("#leftAccordion .accordion-header:first").css("border-top","none")
}
function initBTN(){
	/*$("#changeLocBTN").on('click',function(){
		$HUI.dialog('#changeLocDialog').open()	
	})hxy 2018-11-02注释*/
	$HUI.combobox("#changeLocBTN",{ //hxy 2018-11-02
		url:LINK_CSP+"?ClassName=web.DHCEMChangeLoc&MethodName=QueryLocCombo",
		valueField:'value',
		textField:'text',
		width:30,
		panelWidth:230,
		panelHeight:'auto',
		onSelect:function(option){
			$("#Loc").val($HUI.combobox("#changeLocBTN").getValue());
			$("#ParEpisodeID").val('');
			queryPatList();  
	    }	
	})

}
function initMethod(){
	$("#redZone").on("click",function(){upload("1")})     //红黄绿三区的人数显示
	//$("#yellowZone").on("click",function(){upload("2")}); //hxy 2020-02-20 st
	//$("#greenZone").on("click",function(){upload("3")});
	$("#orangeZone").on("click",function(){upload("2")});
	$("#yellowZone").on("click",function(){upload("3")});
	$("#greenZone").on("click",function(){upload("4")}); //ed
	$("#MainRegno").next().find(".searchbox-text").on("keyup",flashMainTable)
}

function flashMainTable(){
	var inputVal=$("#MainRegno").next().find(".searchbox-text").val();
	if(inputVal==""){
		$('#MainRegno').searchbox('setValue',"");
		GetCardPatInfoOnMain("");	
	}
	return;
}

function upload(value){
	$("#ParEpisodeID").val();
	$("#Level").val(value);
	$("#patTable").datagrid('load');
	//$HUI.datagrid('#patTable').getPager().pagination().select(1);   //默认选中第一页
	//$HUI.datagrid('#patTable').reload();	
}

function initValue(){
	var frm=window.parent.document.forms["fEPRMENU"];
	if(frm==undefined) frm =window.opener.parent.document.forms["fEPRMENU"];
	if(frm.EpisodeID){
		$("#EpisodeID").val(frm.EpisodeID.value);
		$("#ParEpisodeID").val(frm.EpisodeID.value);
		initOneAdmCombobox(frm.EpisodeID.value,frm.EpisodeID.value); ///第一次加载界面的时候调用
		if(!$("#patTable").length){
			if(((frm.EpisodeID)&&(frm.EpisodeID.value!=""))||((frm.PatientID)&&(frm.PatientID.value!=""))){
				showThisPatient(frm.PatientID.value,frm.EpisodeID.value);
			}
		}
	}
	
	if($("#JZStDate").length>0){
		//$("#JZStDate").datebox('setValue',StartDate);
		$("#JZStDate").datebox('setValue',EndDate);	//速度太慢，只查询一天
		$('#JZStDate').datebox('calendar').calendar({
		    validator: function(date){
		        var now = new Date();
		        var d1 = new Date(now.getFullYear(),now.getMonth(), now.getDate()-14);
		        var d2 = new Date(now.getFullYear(), now.getMonth(), now.getDate());
		        var isValid=(d1<=date && date<=d2);
		        return isValid;
		    }
		});
		
		$('#JZEndDate').datebox({
			onSelect: function(date){
				var myY=date.getFullYear();
				var myM=date.getMonth();
				var myD=date.getDate();
				$('#JZStDate').datebox('calendar').calendar({
				    validator: function(da){
				        var d1 = new Date(myY,myM,myD-14);
				        var d2 = new Date(myY,myM,myD);
				        var isValid=(d1<=da && da<=d2);
				        return isValid;
				    }
				});
			}
		});
		
		$("#JZEndDate").datebox('setValue',EndDate);
		
	}
	
 	serverName=GetComputerIp();
 	
}

 // ComputerIP
function GetComputerIp() 
{
   if(window.ActiveXObject){
		var ipAddr="";
		var locator = new ActiveXObject("WbemScripting.SWbemLocator");
		var service = locator.ConnectServer(".");
		var properties = service.ExecQuery("Select * FROM Win32_NetworkAdapterconfiguration");
		var e = new Enumerator(properties);
		var p=e.item();
		for(;!e.atEnd();e.moveNext())
		{
			var p=e.item();
			ipAddr=p.IPAddress(0);
			if(ipAddr) break;
		}
		return ipAddr;
	}else{
		var ClientIPAddressIInfo = serverCall("User.DHCClientLogin","GetInfo");
		return ClientIPAddressIInfo.split("^")[0];
	}
}

function initTab(){
	$('#chartTab').tabs({
	    border:false,
	    onSelect:function(title){
			REGNO=serverCall("web.DHCEMCommonUtil","GetRegNo",{EpisodeID:$("#EpisodeID").val()}); //2022-10
			var tab = $('#chartTab').tabs('getTab',title);
			url=tab.attr("data-url")+"?RegNo="+REGNO+"&EpisodeID="+$("#EpisodeID").val()+"&Allgryflag="+ALLGRYFLAG+"&PatientID="+PAPMIDR
			if ('undefined'!==typeof websys_getMWToken){
				url += "&MWToken="+websys_getMWToken();
			}
			tab.find('iframe').attr('src', url);
	    }
	});	
}
	
function initTable(){
		if($("#patTable").length>0){
			//病人列表
			$HUI.datagrid('#patTable',{
				columns:[[
					{
						field: 'EpisodeID',
						formatter:cellFormat,
						width:235
	            	}
				]],
				url:'dhcapp.broker.csp?ClassName=web.DHCEMPat&MethodName=QueryPat',
				singleSelect:true,
				autoSizeColumn:false,
				fitColumns: true,
				fit:true,
				border:false,
				pagination:true,
				toolbar:'#PatToolbar',
				onBeforeLoad:function(param){
					param.Loc=$("#Loc").val();
			 		param.adm=$("#ParEpisodeID").val(),  //留观室就诊id不要传
			 		param.EmPatNo=$('#MainRegno').searchbox('getValue'),
			 		param.Level=$("#Level").val(),
					param.offset=(param.page-1)*param.rows,
					param.limit=param.rows
					return param;
				},
				onLoadSuccess:function(data){
			        initLevNumAndTitle(data);
					showFrmOrListFirt(data);
					
					if (typeof data.rows != "undefined"){
						var row = data.rows[0];
						nurIndexPopWin(row.CardNo, row.Papmidr, row.EpisodeID);  /// 护士执行 页面加载时，自动打开副屏；用户大会使用 bianshuai 2022-10-12
					}
		    	},
			    onClickRow:function(index,row){
					var linkurl="dhcem.nuraddorder.csp"+"?EpisodeID="+$("#EpisodeID").val()+"&DISPLAY=NONE";
					if ('undefined'!==typeof websys_getMWToken){
						linkurl += "&MWToken="+websys_getMWToken();
					}
				    $("#nuraddorder-iframe").attr("src",linkurl) //hxy 2017-03-27
				    $("#EpisodeID").val(row.EpisodeID)
				    setPatInfo(row);
					loadFrame(row);
					
					nurIndexPopWin(row.CardNo, row.Papmidr, row.EpisodeID);  /// 护士执行 页面加载时，自动打开副屏；用户大会使用 bianshuai 2022-10-12
				}
			})
		}
		if($("#patTestTable").length>0){
			
			//皮试列表
			$HUI.datagrid('#patTestTable',{
				columns:[[
					{
						field: 'EpisodeID',
						formatter:function(value,rowData){
								var skinTimeList=rowData.TestStartTime;
								if(rowData.TestTime!=""){
									skinTimeList=skinTimeList +"/"+rowData.TestTime;
								}
							    var htmlstr =  '<div class="celllabels"><span class="CardName " table-data-id="patTestTable" onClick="CallPat(this)">'+ rowData.PatName +'</span><span class="patInfo"><span>'+ skinTimeList+'</span></span><br>';
								htmlstr = htmlstr + '<div class="patID" style="float:left">ID:'+ rowData.RegNo +'</div';
								classstyle="color: #18bc9c";
								level=rowData.ToObserveTime
								htmlstr = htmlstr +'<div style="float:right"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+level+'</span></div></div>';
								return htmlstr;
						},
						styler:function(value,row,index){
								opt="";
								if(row.CurStat=='Call'){
									opt="background-color:green"
								}
								if((row.ToObserveTime==$g("0秒"))||(row.ToObserveTime=="")){
									opt="background-color:red"
								}
								return opt
						},
						width:235
	            	}
				]],
				url:'dhcapp.broker.csp?ClassName=web.DHCEMSkinTest&MethodName=GetSkinTestPat',
				singleSelect:true,
				autoSizeColumn:false,
				fitColumns: true,
				fit:true,
				border:false,
				pagination:true,
				toolbar:'#TestToolbar',
				onBeforeLoad:function(param){
					param.offset=(param.page-1)*param.rows,
					param.limit=param.rows
					return param
				},
				onLoadSuccess:function(data){
			        total=data.total
					title=$g("皮试")+"("+total+")"
					setAccordionTitle("#patTestTableAccordion",title);
		    	},
			    onClickRow:function(index,row){
				    $("#EpisodeID").val(row.EpisodeID)
					selectTest(row.EpisodeID)
				}
			})
		}
		serverDesc = GetServerDesc(serverName);   //qqa 2017-09-08 获取数字媒体信息
		if($("#patSYTable").length>0){
			//输液列表
			$HUI.datagrid('#patSYTable',{
				columns:[[
					{
						field: 'EpisodeID',
						formatter:function(value,rowData){
							var htmlstr =  '<div class="celllabels"><span class="CardName " table-data-id="patSYTable" onClick="CallPat(this)">'+ rowData.PatName +'</span><span class="patInfo"><span>'+ rowData.QueueState +"/"+rowData.QueuePrior+'</span></span><br>';
							htmlstr = htmlstr + '<div class="patID" style="float:left">'+$g('排队号')+':'+ rowData.QueueNo +'</div>';
							classstyle="color: #18bc9c";
							level=rowData.ClientName
							htmlstr = htmlstr +'<div style="float:right;"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+level+'</span></div></div>';
							return htmlstr;
						},
						width:235
	            	}
				]],
				url:'dhcapp.broker.csp?ClassName=web.DHCNurTreatQueue&MethodName=FindTreatPat&serverIP='+serverName+"&ifSYCall=1&IsQuery=Y&seatFlag=3",
				singleSelect:true,
				autoSizeColumn:false,
				fitColumns: true,
				fit:true,
				border:false,
				pagination:true,
				toolbar:'#SYToolbar',
				onBeforeLoad:function(param){
					param.offset=(param.page-1)*param.rows,
					param.limit=param.rows
					return param
				},
				onLoadSuccess:function(data){
			        total=data.total;
			        title=$g("输液")+"("+total+")";
			        setAccordionTitle("#patSYTableAccordion",title);
		    	},
			    onClickRow:function(index,row){
					var linkurl="dhcem.nuraddorder.csp"+"?EpisodeID="+$("#EpisodeID").val()+"&DISPLAY=NONE";
					if ('undefined'!==typeof websys_getMWToken){
						linkurl += "&MWToken="+websys_getMWToken();
					}
				    $("#nuraddorder-iframe").attr("src",linkurl) //hxy 2017-03-27
				    $("#EpisodeID").val(row.EpisodeID)
				    selectTest(row.EpisodeID)
				}
			})
		}
		if($("#patTreatTable").length>0){
			//治疗列表
			$HUI.datagrid('#patTreatTable',{
				columns:[[
					{
						field: 'QueueNo',
						formatter:function(value,rowData){
							var htmlstr =  '<div class="celllabels"><span class="CardName "  table-data-id="patTreatTable" onClick="CallPat(this)">'+ rowData.PatName +'</span><span class="patInfo"><span>'+ rowData.QueueState +"/"+rowData.QueuePrior+'</span></span><br>';
							htmlstr = htmlstr + '<div class="patID" style="float:left">'+$g('排队号')+':'+ rowData.QueueNo +'</div>';
							classstyle="color: #18bc9c";
							level=rowData.ClientName
							htmlstr = htmlstr +'<div style="float:right;"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+level+'</span></div></div>';
							return htmlstr;
						},
						width:235
	            	}
				]],
				url:'dhcapp.broker.csp?ClassName=web.DHCNurTreatQueue&MethodName=FindTreatPat&IsQuery=Y&seatFlag=2&serverIP='+encodeURI(serverName),
				singleSelect:true,
				autoSizeColumn:false,
				fitColumns: true,
				fit:true,
				border:false,
				pagination:true,
				toolbar:'#TreatToolbar',
				onBeforeLoad:function(param){
					param.offset=(param.page-1)*param.rows,
					param.limit=param.rows
					return param
				},
				onLoadSuccess:function(data){
			        total=data.total;
			        title=$g("治疗")+"("+total+")";
			        setAccordionTitle("#patTreatTableAccordion",title);
				    $("#serverDesc").html(serverDesc.split("^")[0])

		    	},
			    onClickRow:function(index,row){
					var linkurl="dhcem.nuraddorder.csp"+"?EpisodeID="+$("#EpisodeID").val()+"&DISPLAY=NONE";
					if ('undefined'!==typeof websys_getMWToken){
						linkurl += "&MWToken="+websys_getMWToken();
					}
				    $("#nuraddorder-iframe").attr("src",linkurl) //hxy 2017-03-27
				    $("#EpisodeID").val(row.EpisodeID)
				    selectTest(row.EpisodeID)
				}
			})
		}
		
		if($("#patJZTable").length>0){
			//就诊列表
			$HUI.datagrid('#patJZTable',{
			columns:[[
				{
					field: 'EpisodeID',
					formatter:cellFormat,
					width:235
            	}
			]],
			url:'dhcapp.broker.csp?ClassName=web.DHCEMPat&MethodName=QueryPat',
			singleSelect:true,
			autoSizeColumn:false,
			fitColumns: true,
			fit:true,
			border:false,
			pagination:true,
			toolbar:'#JZToolbar',
			onBeforeLoad:function(param){
				param.IsAdmList="Y";
				param.offset=(param.page-1)*param.rows;
				param.limit=param.rows;
				return param;
			},
			onLoadSuccess:function(data){
		        
	    	},
		    onClickRow:function(index,row){
			    StartDate=$HUI.datebox("#JZStDate").getValue();
			    EndDate=$HUI.datebox("#JZEndDate").getValue();
			    TempCheckExecCode=$("#execFormType").combobox("getValue");
			    IsCheckExec=$HUI.checkbox("#onlyHasExeRadio").getValue();
				patTableOnClickRow(row);
			}
		})
	}
	
	if($("#patBloodTable").length>0){
		//采血列表
		$HUI.datagrid('#patBloodTable',{
			columns:[[
				{
					field: 'QueueNo',
					formatter:function(value,rowData){
						var htmlstr =  '<div class="celllabels"><span class="CardName "  table-data-id="patTreatTable" onClick="CallPat(this)">'+ rowData.PatName +'</span><span class="patInfo"><span>'+ rowData.QueueState+'</span></span><br>';
						htmlstr = htmlstr + '<div class="patID" style="float:left">'+$g('排队号')+':'+ rowData.QueueNo +'</div>';
						classstyle="color: #18bc9c";
						level=rowData.ClientName
						htmlstr = htmlstr +'<div style="float:right;"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+level+'</span></div></div>';
						return htmlstr;
					},
					width:235
            	}
			]],
			url:'dhcapp.broker.csp?ClassName=web.DHCNurTreatQueue&MethodName=QueryBloodPat',
			singleSelect:true,
			autoSizeColumn:false,
			fitColumns: true,
			fit:true,
			border:false,
			pagination:true,
			toolbar:'#BloodToolbar',
			onBeforeLoad:function(param){
				param.IsQuery="Y",
				param.StDate="",
				param.EndDate="",
				param.ClientIp=encodeURI(serverName),
				param.offset=(param.page-1)*param.rows,
				param.limit=param.rows
				return param
			},
			onLoadSuccess:function(data){
		        total=data.total;
		        //showJhWaitNumber(data);
		        //initSelectRow(data);
		        //showTotalWaitNumber();
	    	},
		    onClickRow:function(index,row){
				var linkurl="dhcem.nuraddorder.csp"+"?EpisodeID="+$("#EpisodeID").val()+"&DISPLAY=NONE";
				if ('undefined'!==typeof websys_getMWToken){
					linkurl += "&MWToken="+websys_getMWToken();
				}
			    $("#nuraddorder-iframe").attr("src",linkurl) //hxy 2017-03-27
			    $("#EpisodeID").val(row.EpisodeID)
			    selectTest(row.EpisodeID)
			}
		})
	}
	
	//格式化datagrid的pagination//
	pageFormater(ALLTABLES);
	
}		


function showJhWaitNumber(data){
	var waitNumber=0;
    if(data.rows.length!=0){
    	var datas= data.rows;
    	for (var i in datas){
	    	var itmData=datas[i];
	    	if(itmData.QueueState!=$g("呼叫")){
		    	waitNumber++;
		    }	
	    }
    }
   	$("#waitnum").html(waitNumber);	
}

function CallNextNew(tableId){
	var ret="" ;
	if(tableId=="patBloodTable"){
		ret=serverCall("web.DHCVISQueueManage","BloodQueueCall",{LocID:$("#CtLocID").val(),UserID:LgUserID,IPAddress:GetComputerIp()});
		var retArr=ret.split("^");
		if(retArr[0]==0) {
			$.messager.alert("提示", retArr[1]);
			searchPatBlood();
		}else{
			$.messager.alert("提示", "呼叫失败，失败信息"+retArr[1]);
		}
	}
	
	return;
}


function cellFormat(value,rowData){
	var Allgryflag="";//2016-10-25 congyue
	var htmlstr =  '<div class="celllabels" ><span class="CardName">'+ rowData.PatName +'</span><span class="patInfo" ><span>'+ rowData.Sex +'/'+ rowData.Age +'</span></span><br>';
	
	htmlstr = htmlstr + '<div class="patID">ID:'+ rowData.CardNo +'</div><div style="float:right">';
	level="";
	levelflag="0"
	if(rowData.NurseLevel>0){
		levelflag="1"
		level=rowData.NurseLevel+$g("级");
		level=setCellLabel(level);//hxy 2020-02-20
		classstyle="color: #18bc9c";
		if(rowData.NurseLevel==3) {classstyle="color: #f9bf3b"};
		if(rowData.NurseLevel==1) {classstyle="color: #f22613"};
		if(rowData.NurseLevel==2) {classstyle="color: orange"}; //hxy 2020-02-20 原：#f22613
		htmlstr = htmlstr +'<div style="float:right;font-size:14px;margin-top: -1px;margin-right: 2px;"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px;">'+level+'</span></div>';
	}
	if(rowData.Allgryflag==1)//2016-10-25 congyue 
	{
		if(levelflag=="1"){
			Allgryflag=$g("敏");
			htmlstr = htmlstr+'<div style="float:left;margin-top:3px;margin-right:5px"><span class="badger sensBar" ><div class="sensText"><a style="cursor:pointer;color:#FFFBFB;margin-left:-1px" "id="allery" onclick="gotoAllery('+rowData.CardNo+','+rowData.EpisodeID+')">'+Allgryflag+'</a></div></span></div></div>'; //hxy 2018-06-20
		}else{
			htmlstr = htmlstr+'<div style="float:left;margin: 5px 3px 0px 36px;"><span class="badger sensBar" style="margin-right: 26px"><div class="sensText"><a style="cursor:pointer;color:#FFFBFB;margin-left:-1px" "id="allery" onclick="gotoAllery('+rowData.CardNo+','+rowData.EpisodeID+')">'+$g("敏")+'</a></div></span></div></div>';
		}
	} 
	htmlstr = htmlstr+'</div></div>'
	return htmlstr;
}

function GetCardPatInfoOnMain(value,name){
	 	var Regno = GetWholePatNo(value);///  登记号补0
		$("#ParEpisodeID").val('')
		$("#Level").val('')
	 	queryPatList(Regno);
		
}
///补0病人登记号 add by Ylp
function GetWholePatNo(EmPatNo){

	///  判断登记号是否为空
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return "";    //qqa 改变原来不存在返回值
	}
	///  登记号长度值
	var patLen = $cm({
		ClassName:"web.DHCEMPatCheckLevCom",
		MethodName:"GetPatRegNoLen"
	},false);
	var plen = EmPatNo.length;
	if (EmPatNo.length > patLen){
		$.messager.alert("提示", "登记号输入错误,请重新输入！", 'info');
		EmPatNo="";
	}
	for (var i=1;i<=patLen-plen;i++){
		EmPatNo="0"+EmPatNo;  
	}
	$('#MainRegno').searchbox('setValue',EmPatNo);
	return EmPatNo;
}


function queryPatList(){
	if($("#patTable").length){
		$("#patTable").datagrid('reload');	
	}
} 
function searchPatTest(){	
	if($("#patTestTable").length){
		$("#patTestTable").datagrid('reload');	
	}
}
function searchPatTreat(){
	if($("#patTreatTable").length){
		$("#patTreatTable").datagrid('reload');	
	}
}
function searchPatSY(){
	if($("#patSYTable").length){
		$("#patSYTable").datagrid('reload');	
	}
}

function searchPatJZ(){
	if($("#patJZTable").length){
		//$("#patJZTable").datagrid('reload');	
		
		var regNo = ""; //$('#MainRegno').searchbox('getValue');
		var schRegNo = $('#SearchRegNo').searchbox('getValue');
		if (schRegNo!="") regNo = schRegNo;
		var execFormType = $("#execFormType").combobox("getValue");
		var stDate = $HUI.datebox("#JZStDate").getValue();
		var endDate = $HUI.datebox("#JZEndDate").getValue();
		var hasExeRadio = $HUI.checkbox("#onlyHasExeRadio").getValue();
		var hasUnExeRadio = $HUI.checkbox("#onlyHasUnExeRadio").getValue()
		var selectType=$HUI.checkbox("#checkTypeAdm").getValue()?"Adm":"Ord";
		
		var admListParams=""
		if($("#execFormType").length>0){
			admListParams=execFormType+"^"+stDate+"^"+endDate+"^"+hasExeRadio+"^"+hasUnExeRadio+"^"+selectType;
		}
		
		$HUI.datagrid('#patJZTable').load({
			Loc:$("#Loc").val(),
	 		adm:$("#ParEpisodeID").val(),  
	 		EmPatNo:regNo,
	 		Level:$("#Level").val(),
	 		IsAdmList:"Y",
	 		AdmListParams:admListParams
		})
		
	}
}

function searchPatBlood(){
	if($("#patBloodTable").length){
		$("#patBloodTable").datagrid('reload');	
	}
}

function searchPatJZRegNo()
{
	///  判断登记号是否为空
	var SearchRegNo = $('#SearchRegNo').searchbox('getValue');
	SearchRegNo = $.trim(SearchRegNo);
	if (SearchRegNo != ""){
		///  登记号长度值
		var patLen = $cm({
			ClassName:"web.DHCEMPatCheckLevCom",
			MethodName:"GetPatRegNoLen"
		},false);
		var plen = SearchRegNo.length;
		if (plen > patLen){
			$.messager.alert("提示", "登记号输入错误,请重新输入！", 'info');
			$('#SearchRegNo').searchbox('setValue',"");
			return;
		}
		for (var i=1;i<=patLen-plen;i++){
			SearchRegNo="0"+SearchRegNo;  
		}
		$('#SearchRegNo').searchbox('setValue',SearchRegNo);
	}
	searchPatJZ();
}


function treatFormater(value,rowData){
		var htmlstr =  '<div class="celllabels"><span class="CardName " onClick="CallPat(this)">'+ rowData.PatName +'</span><span class="patInfo"><span>'+ rowData.QueueState +"/"+rowData.QueuePrior+'</span></span><br>';
		htmlstr = htmlstr + '<div class="patID" style="float:left">'+$g('排队号')+':'+ rowData.QueueNo +'</div>';
		classstyle="color: #18bc9c";
		level=rowData.ClientName
		htmlstr = htmlstr +'<div style="float:right;"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+level+'</span></div></div>';
		return htmlstr;
}


function gotoAllery(CardNo,EpisodeID){
	$('#chartTab').tabs('select',$g('过敏记录'));
}
function loadFrame(row){
	
	var tab = $('#chartTab').tabs('getSelected');
	url=tab.attr("data-url");
	adm=row.EpisodeID
	if($("#patTableAccordion").length>0){
		if(getAccordionTitle("#patTableAccordion").indexOf($g("座位"))>-1){
			//$("#EpisodeID").val("");
			//adm="";
		}
	}
	//设置全局变量
	if(row.PatCardNo!=undefined){
		PatCardNo=row.PatCardNo;
	}else{
		PatCardNo="";
	}
	if(row.CardTypeNew!=undefined){
		CardTypeNew=row.CardTypeNew;
	}else{
		CardTypeNew="";
	}
	if(JSON.stringify(row)!=='{}'){
		REGNO=row.CardNo;
		ADM=adm;
		ALLGRYFLAG=row.Allgryflag;
		PAPMIDR=row.Papmidr
		
		url=url+"?RegNo="+REGNO+"&EpisodeID="+ADM+"&Allgryflag="+ALLGRYFLAG+"&PatientID="+PAPMIDR+"&PatCardNo="+PatCardNo;
		if ('undefined'!==typeof websys_getMWToken){
			url += "&MWToken="+websys_getMWToken();
		}
		tab.find('iframe').attr('src', url);
	}
	return;
} 

//格式化datagrid的pagination
function pageFormater(ids){
	
	var id = ids.split('^')
	for(var i=0;i<id.length;i++){
		if($("#"+id[i]).length >0){
			var p = $("#"+id[i]).datagrid('getPager');  
		    if (p){  
		           $(p).pagination({  
		 				showPageList:false,
		 				displayMsg:''    
		           });  
		     } 	
		}

	}
}

function GetServerDesc(serverName){
	ret=""
	$.ajax({ 
          type : "post", 
          url : "websys.Broker.cls", 
          data : {ClassName:"web.DHCEMNurExe",MethodName:"GetClintServerNameByIP",clientIP:serverName}, 
          async : false, 
          success : function(data){ 
             ret=data
          } 
    }); 
    return ret
  //return $cm({ClassName:"web.DHCEMNurExe",MethodName:"GetClintServerNameByIP",clientIP:"serverName"},false)
}
function setPatInfo(row,flag){
	showSetBtn();   //重新显示右上角按钮
	var AdmDr = row.EpisodeID;
	initOneAdmCombobox(row.Papmidr,AdmDr);
	showPatBar(row.Papmidr,AdmDr);
	if(StayFlag==0) AdmDr="";   //输液室患者不需要显示跟就诊有关信息
	if(!AdmDr&&!row.Papmidr) return;
	showPatBar(row.Papmidr,AdmDr);
	
	
	var frm=window.parent.document.forms["fEPRMENU"];
	if(frm.EpisodeID){
		frm.EpisodeID.value=row.EpisodeID;
		frm.PatientID.value=row.Papmidr
		if($("#patTableAccordion").length>0){
		if(getAccordionTitle("#patTableAccordion").indexOf($g("座位"))>-1){
			//frm.EpisodeID.value="";
			//frm.PatientID.value=="";
		}
		}
		if(flag==1){
			frm.EpisodeID.value="";
			frm.PatientID.value=="";
		}
	}
		

	
	/*
	$("#patInfo-diagnos a").html("");
	var str='<div style="float:left;padding-left: 12px;"><a style="padding-left: 10px;padding-right: 0px;color:#333;cursor:pointer" id="tooltip" class="tooltip-show"  data-placement="bottom" title="' +row.diagnos+'">'
	if(row.Sex=="男")
	{
		str=str+'<img style="width:30px;heigth:30px;border-radius:50%;margin:3px 15px 5px -2px;background-color:#EEEEEE;" src="../scripts/dhcnewpro/images/nursemano.png" />'
	}else if(row.Sex=="女")
	{
		str=str+'<img style="width:30px;heigth:30px;border-radius:50%;margin:3px 15px 5px -2px;background-color:#EEEEEE;border:0;" src="../scripts/dhcnewpro/images/nursewomano.png" />'
	}else{
		str=str+'<img style="width:30px;heigth:30px;border-radius:50%;margin:3px 15px 5px -2px;background-color:#EEEEEE;border:0;" src="../scripts/dhcnewpro/images/nurseunmano.png" />'
		}
	str=str+'</a></div><div style="padding-top:4px;font-size:16px;color:#000;margin-top:5px;float:left;margin-right:8px;overflow:hidden;text-overflow:ellipsis; -o-text-overflow:ellipsis;white-space:nowrap;width:65px;">'+row.PatName+'</div>' //
	$("#patInfo-name ").html(str)
	var levelstr="",lev="未分"
	classstyle="color: #18bc9c";
	classtext="未分"
	if(row.NurseLevel==3) {classstyle="color: #ffb746";classtext="黄区";lev=3};
	if(row.NurseLevel==1) {classstyle="color: #ff6248";classtext="红区";lev=1};
	if(row.NurseLevel==2) {classstyle="color: #ff6248";classtext="红区";lev=2};
	if(row.NurseLevel==4) {classstyle="color: #2ab66a";classtext="绿区";lev=4};
	
	levelstr=levelstr+'<div class="badge " style="float:left;background-'+classstyle+'; border-radius: 5px;"><span style="margin-left:0px">'+classtext+'</span></div>' //

	levelstr=levelstr+'<div style="margin-left:10px;float:left"><span style="'+classstyle+';">'+lev+"级 / "+row.SeatNo+'</span></div>'
	$("#patInfo-lev a").html(levelstr)
	htmlStrDiv='<div style="margin-top:4px;margin-left:5px;float:left; min-width: 300px;padding-bottom: 5px;;color:#333">'+row.Sex+'<span class="patother">/</span>' //
	htmlStrDiv=htmlStrDiv+row.Age+'<span class="patother">/</span>'
	htmlStrDiv=htmlStrDiv+"ID:"+row.CardNo+'<span class="patother">/</span>'
	htmlStrDiv=htmlStrDiv+row.admreason+'<span class="patother">/</span>'
	htmlStrDiv=htmlStrDiv+"余额:"+row.Deposit+'<span class="patother">/</span>'
	htmlStrDiv=htmlStrDiv+row.UpdateDate+'<span class="patother">/</span>'
	htmlStrDiv=htmlStrDiv+row.UpdateTime+'</div>'
	var htmlStrDivDiagnos=""
	if(row.diagnos!=""){
		htmlStrDivDiagnos=htmlStrDivDiagnos+'<span class="patother" style="padding-left: 2px; margin-top: 0px; margin-bottom: -20px; float: left;">|</span><div style="margin-left: 5px;float:left;padding-left: 9px;overflow:hidden;text-overflow:ellipsis; -o-text-overflow:ellipsis;white-space:nowrap;width:90px;;margin-top:2px;"><a id="tooltip" class="tooltip-show"  data-placement="bottom" title="'+row.diagnos+'" style="color:#333;cursor:pointer">'+row.diagnos+'</a></div>' //
	}
	
	if (row.Allgryflag){
		htmlStrDiv=htmlStrDiv+'<div style="float:left;left: 5px;top: 6px;position:relative;"><span class="badger sensBar"><div class="sensText"><a style="cursor:pointer;color:#FFFBFB;margin-left:-1px" "id="allery" onclick="gotoAllery()">敏</a></div></span></div>'
	}
	*/
}
function showPatBar(Papmidr,AdmDr){
//	InitPatInfoBanner(AdmDr);  //为何不用这种：只提供了就诊号入参，输液座位需要患者入参
//	return;
	if(!Papmidr&&!AdmDr) return;
	$.m({ClassName:"web.DHCDoc.OP.AjaxInterface",MethodName:"GetOPInfoBar",CONTEXT:"",EpisodeID:AdmDr,PatientID:Papmidr},function(html){
		if (html!=""){
			var TopBtnWid=$(".top-btn").width()+50; //hxy 2023-01-09
			var patInfoWi=$("#patInfo").width();
			var whiteBaWi=$("#whiteBar").width()-50;
			if(patInfoWi>whiteBaWi){
				var Ellipsis='<div class="Ellipsis" style="width:'+TopBtnWid+'px;">...</div>';
				$("#patInfo").html(reservedToHtml(html)+Ellipsis);
			}else{
				$("#patInfo").html(reservedToHtml(html));
			}
			//$("#patInfo").html(reservedToHtml(html)); //ed
			$("#patInfo").mouseover(function(){
				html=reservedToHtml(html).replace(/color:#589DDA/g, "");
				html="<div id='patInfoT'>"+html+"</div>"
				layer.tips(html, '#patInfo', {
    				tips: [1, '#3595CC'],
    				area: ['800px', 'auto'],
    				time: 0
				});
			});
			$("#patInfo").mouseout(function(){
				layer.closeAll()
			});
		}else{
			$("#patInfo").html($g("获取病人信息失败。请检查【患者信息展示】配置。"));
		}
	});	
}



/**
* @author wanghc
* @date 2012/5/18
* @param {String} str
* @return {HTMLString} html html片段
*/
function reservedToHtml(str){	
	var replacements = {"&lt;":"<", "&#60;":"<", "&gt;":">", "&#62;":">", "&quot;":"\"", "&#34;":"\"", "&apos;":"'",
	"&#39;":"'", "&amp;":"&", "&#38;":"&"};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,function(v){
		return replacements[v];		
	});
}

function showSetBtn(){
	var params = $("#GroupID").val()+"^"+$("#UserID").val()+"^"+$("#EpisodeID").val()+"^"+$("#CtLocID").val();
	runClassMethod("web.DHCEMColumn","writeTopBtnNew",{"Params":params},function(ret){
		$(".top-btn").html("");
		$(".top-btn").append(ret);
		$.parser.parse('.top-btn');
		var  foldBtn = "<div class='panel-tool' style='right:-20px'><a href='javascript:foldOpBtn()' id='foldNurBtn' class='layout-nurbtn-right' style='width:18px'></a></div>";
		if(ret!=="") $(".top-btn").append(foldBtn);
	},'text')	
}

//获取accordion的title
function getAccordionTitle(id){
	return $(id).parent().find(".panel-title").html()
}
//设置accordion的title
function setAccordionTitle(id,title){
	$(id).parent().find(".panel-title").html(title)
}


//转病区
function changeWard(obj){
	ward=$(obj).attr("data-id");
	adm=$("#EpisodeID").val();
	var patName = $("#patInfo-name div:last").text();
	ret=serverCall("web.DHCEMTransfer","CheckBeforeTransfer",{AdmId:adm,PAAdmWard:ward})
	if(ret!=1){
		$.messager.alert('警告',ret);
		return;
	}
	xx=$(obj).find('.menu-text').html()
	str=$g('确认把')
	str=str+'<span style="color:red">'+patName+'</span>';
	str=str+$g('转到');
	str=str+'<span style="color:red">'+xx+'</span>';
	str=str+$g('吗')+'？';
	$.messager.confirm('提示',str,function(r){
		if(r){
			data=serverCall("web.DHCEMTransfer","WardUpdateTransfer",{AdmIdStr:adm,PAAdmWard:ward})
			if(data==0){
				$.messager.alert('提示','修改成功!');
				queryPatList()
			}else{
				$.messager.alert('警告',"操作失败:"+data);
			}
		}
	})
 }
 
 //治疗队列优先
function Prior(tableId){
	TreatId=checkTreatPat(tableId)

	if(TreatId==""){
		return;
	}
	$.messager.confirm('提示','请再次确认是否将病人优先?',function(r){
		if(r){
			updateTreatQue(TreatId,1)
		}	
	})		
}

 //治疗队列重排
function ResetTree(tableId){
	TreatId=checkTreatPat(tableId)

	if(TreatId==""){
		return;
	}


	
	var QueueState = $("#"+tableId).datagrid("getSelections")[0].QueueState;
	if(QueueState!==$g("过号")){
		$.messager.alert('提示','非过号病人，不允许重排!');
		return;	
	}

	$.messager.confirm('提示','请再次确认是否将病人重新排队?',function(r){
		if(r){
			updateTreatQue(TreatId,2,"Wait");
		}	
	})		
}


//治疗队列过号
function SkipNum(tableId)
{
	TreatId=checkTreatPat(tableId)
	if(TreatId==""){
		return;
	}
	
	$.messager.confirm('提示','请再次确认是否将病人过号?',function(r){
		if(r){
			updateTreatQue(TreatId,3,"Skip")
		}	
	})
}


function CallNum(tableId)
{
	TreatId=checkTreatPat(tableId)
	if(TreatId==""){
		return;
	}
	updateTreatQue(TreatId,2,"Call");	
}


//皮试队列撤销
function revocation(){
	
	data=$("#patTestTable").datagrid("getSelections");
	if(data.length==0){
		$.messager.alert('提示','请选择需要撤销的病人!');
		return;
	}
	
	$.messager.confirm('提示','请再次确认是否撤销记录?',function(r){
		if(r){
			ret=serverCall("User.DHCNurSkinTestList","Delete",{id:data[0].ID})
			if(ret){
				$.messager.alert('提示','撤销成功!');
				searchPatTest();  //刷新皮试列表
			}
		}	
	})
	
}


//治疗队列到达
function Arrive(tableId){
	TreatId=checkTreatPat(tableId)
	if(TreatId==""){
		return;
	}
	$.messager.confirm('提示','请再次确认是否将病人到达?',function(r){
		if(r){
			updateTreatQue(TreatId,2,"Finish")
		}	
	})
}
//下一个
function CallNext(tableId){
	
	datas=$("#"+tableId).datagrid("getRows");
	
	for(var i=0;i<datas.length;i++){
		if(datas[i].QueueState!=$g("呼叫")){
			DHCAMSCall(i,tableId);
			break;	
		}
	}
	
}
//叫号
function Call(tableId){
	select=$("#"+tableId).datagrid("getSelections")[0];
	if($("#"+tableId).datagrid("getSelections").length==0){
		$.messager.alert("提示", '请选择病人!');
		return ;
	}
	datas=$("#"+tableId) .datagrid("getRows");
	for(var i=0;i<datas.length;i++){
		if(select.TreatId==datas[i].TreatId){
			DHCAMSCall(i)
			break;
		}
	}	
}

function CallNew(tableId){
	select=$("#"+tableId).datagrid("getSelections")[0];
	if($("#"+tableId).datagrid("getSelections").length==0){
		$.messager.alert("提示", '请选择病人!');
		return ;
	}
	datas=$("#"+tableId) .datagrid("getRows");
	for(var i=0;i<datas.length;i++){
		if(select.TreatId==datas[i].TreatId){
			DHCAMSCall(i,tableId)
			break;
		}
	}
}

function CallPat(obj){
	i=$(obj).parent().parent().parent().parent().attr("datagrid-row-index")
	tableId=$(obj).attr("table-data-id")
	if("patTestTable"==tableId){
		CallTest(i,tableId)
	}else{
		DHCAMSCall(i,tableId)
	}
}
//皮试队列叫号
function CallTest(i,tableId){
	RowData=$("#"+tableId).datagrid("getRows")[i];
	
	waitPatStr="^";
	ret=serverCall("web.DHCVISQueueManage","FrontQueueInsertNewProEm",{EpisodeID:RowData.EpisodeID,LocID:"",UserID:"",IPAddress:serverName})
	if(ret!="0")
	{
		$.messager.alert("提示", ret);
	}
	else
	{	
		obj=new Object(); 
		obj.TestCallFlag="Y";
		obj.ID=RowData.ID;
		serverCall("web.DHCEMNurTreatQueue","saveOrUpdate",{tableName:"User.DHCNurSkinTestList",jsonStr:JSON.stringify(obj)})
	
	}
}
//治疗队列和输液队列叫号
function DHCAMSCall(i,tableId){
	
	RowData=$("#"+tableId).datagrid("getRows")[i];

	var waitPatStr=GetWaitPat(i,tableId)
	var readyPatStr=""
	if(waitPatStr.split("^").length>1)
	{
		readyPatStr=waitPatStr.split("^")[1]
		waitPatStr=waitPatStr.split("^")[0]	
	}
	
	CallNum(tableId);
}
function updateTreatQue(TreatId,Prior,State){
	
	obj=new Object();
	obj.TreatRecUser=LgUserID;
	obj.TreatQuePrior=Prior;
	obj.TreatQueState=State;
	obj.ID=TreatId;
	ret=serverCall("web.DHCEMNurTreatQueue","saveOrUpdate",{tableName:"User.DHCNurTreatQueue",jsonStr:JSON.stringify(obj)})
	if (ret != 0) {
		$.messager.alert("提示", ret);
	}else{
		if(arguments[3]!=1) $.messager.alert("提示", "操作成功!");
		searchPatTreat();
		searchPatSY();
		searchPatBlood();
	}
}
function checkTreatPat(tableId){
	data=$("#"+tableId).datagrid("getSelections");
	if(data.length==0){
		$.messager.alert("提示", "请选择病人!");
		return "";
	}
	return data[0].TreatId
}

function GetWaitPat(selrow,tableId)
{	

	datas=$("#"+tableId).datagrid("getRows");
	var QueType=serverCall("web.DHCVISVoiceSet","GetServerQueType",{IPAddress:serverName})
	if(QueType=="0") return "^"
	
	var WaitPat="",ReadyPat=""
	try
	{
		
		var startIndex=selrow+1
		var waitNum=2
		for(var i=startIndex;i<startIndex+waitNum;i++)
		{
			
			var Obj=datas[i];
			if(Obj)
			{
				var QueueState=Obj.QueueState
				
				if((QueueState!=$g("完成"))&&(QueueState!=$g("呼叫")))
				{
					var PatName="",QueNo="",TreatId=""
					var TreatId=Obj.TreatId;
					PatName=Obj.PatName;
					QueNo=Obj.QueueNo;
					if(QueNo!="")
					{
						var State="Ready"
						if(QueueState==$g("等候"))
						{
							var retStr=updateTreatQue(TreatId,"",State)
							if(ReadyPat=="") ReadyPat=QueNo+$g("号")+","+PatName	
							else  ReadyPat=ReadyPat+"!"+QueNo+$g("号")+","+PatName
						}
						if(WaitPat=="") WaitPat=QueNo+$g("号")+","+PatName	
						else  WaitPat=WaitPat+"!"+QueNo+$g("号")+","+PatName	
					}
				}
				else
				{
					waitNum=waitNum+1
				}
			}
			else
			{
				i=startIndex+waitNum
			}
		}
	}
	catch(e)
	{
		return "^"
	}
	return WaitPat+"^"+ReadyPat;
}
 
function selectTest(EpisodeID,PatientID){
		runClassMethod("web.DHCEMPat",
			"GetPatInfo",
			{
				'EpisodeID':EpisodeID,
				'PatientID':PatientID
			},
			function(data){
				setPatInfo(data);
				loadFrame(data);
			},
			"json")	
	
}
function checkPatTestTime(){
	var linkurl=LINK_CSP+"?";
	if ('undefined'!==typeof websys_getMWToken){
		linkurl += "&MWToken="+websys_getMWToken();
	}
	  $.ajax({
	     type: "POST",
	     url: linkurl,
	     data: {
				'ClassName':'web.DHCEMSkinTest',
				'MethodName':'GetSkinTestPat',
				'limit':999,'offset':0
		 },
	     dataType: "json",
	     error:function(rtn){
		    clearInterval(mainTimeoutIdTestTime); //hxy 2023-05-13
			clearInterval(mainTimeoutIdBlood);
			clearInterval(mainTimeoutIdTest);
			if(typeof mainTimeoutIdTreat!='undefined'){
				clearInterval(mainTimeoutIdTreat);
			}
		    var MWToken="";
		    if ('function'==typeof websys_getMWToken) MWToken=websys_getMWToken();
		    if(MWToken){
			    if ('undefined'!==typeof lockScreenOpt && 'function'==typeof lockScreenOpt.lockScrn) lockScreenOpt.lockScrn();
			}else{
				$.messager.alert("提示", "系统已超时，请关闭界面，重新登录!");
			}			
		 },
	     success: function(data){
		     		
		     		changePatTestTableAccordion(data);
		     		
					html="";
					count=0
					html=html+"<table class='table table-hover table-vcenter TipSkin'>"
					html=html+"	<tbody>"
					$.each(data.rows,function(n,value){
						if((value.ToObserveTime==$g("0秒"))||(value.ToObserveTime=="")){
							count=count+1;
							html=html+"<tr onClick=\"openSkinTestPage(\'"+value.EpisodeID+"\',\'"+value.RegNo+"\',\'"+value.TestOeoreDr+"\',\'"+value.Allgryflag+"\',\'"+value.TestMethod+"\',\'"+value.ObserveTime+"\')\"><td><span class='psPatItem' >"+value.PatName+"</span></td></tr>"
							//html=html+"<tr onClick=\"selectTest(\'"+value.EpisodeID+"\',\'"+value.RegNo+"\,\'"+value.TestOeoreDr+"\,\'"+value.Allgryflag+"\')\"><td>"+value.PatName+"</td></tr>"
						}
					})
					html=html+"	</tbody>"
					html=html+"</table>"

					if(count==0){
						return;
					}
					
					var height="100px";
					if(count>2){
						height=20*count+60+"px";
						parseInt(height)>200?height="200px":"";
					}
					
					$.messager.show({
						title:$g('皮试提醒'),
						msg:html,
						height:height,
						timeout:5000,
						showType:'slide'
					});
					
					SetShadow();
		
	     }
	 }); 

}

function changePatTestTableAccordion(data){
	
	if(!$("#patTestTable").length) return;
	
	var skinTableRowIndex="";
	var skinTableDatas=$("#patTestTable").datagrid("getData").rows;
	
	$.each(data.rows,function(n,value){
		if((value.ToObserveTime==$g("0秒"))||(value.ToObserveTime=="")){
			
			for(i in skinTableDatas){
				var itmData = skinTableDatas[i];
				if(value.EpisodeID==itmData.EpisodeID){
					var rowIndex = $("#patTestTable").datagrid('getRowIndex',itmData);	
					if(skinTableRowIndex===""){
						skinTableRowIndex=rowIndex;
					}else{
						skinTableRowIndex=skinTableRowIndex+"^"+rowIndex;
					}
				}
			}
		}
	})
	
	if(skinTableRowIndex=="") return "";
	skinTableRowIndex=skinTableRowIndex+"";
	var skinTableRowIndexArr=skinTableRowIndex.split("^");
	for(i in skinTableRowIndexArr){
		$('#patTestTable').datagrid('updateRow',{
			index: skinTableRowIndexArr[i],
			row: {
				ToObserveTime: ''
			}
		});
	}
	return "";
}


function foldOpBtn(){

	var thisClass = $("#foldNurBtn").attr("class");
	if(thisClass=="layout-nurbtn-right"){
		$(".top-btn").find(".hisui-linkbutton").each(function(){
			//$(this).css("visibility","hidden");
			$(this).hide();
		})
		$(".top-btn").find(".hisui-menubutton").each(function(){
			//$(this).css("visibility","hidden");	
			$(this).hide();
		})
		$("#foldNurBtn").attr("class","layout-nurbtn-left");
	}else if(thisClass=="layout-nurbtn-left"){
		$(".top-btn").find(".hisui-linkbutton").each(function(){
			//$(this).css("visibility","visible");
			$(this).show();
		})
		$(".top-btn").find(".hisui-menubutton").each(function(){
			//$(this).css("visibility","visible");	
			$(this).show();
		})
		$("#foldNurBtn").attr("class","layout-nurbtn-right");
	}
	return;
}


function initLevNumAndTitle(data){
	total=data.total;
	$("#Loc").val(data.locId)
	$("#redZone").html(data.levelRed)     //红黄绿三区的人数显示
	$("#yellowZone").html(data.levelYellow)
	$("#greenZone").html(data.levelGreen)
	$("#orangeZone").html(data.levelOrange) //hxy 2020-02-20
	title=data.locDesc+"("+total+")"
	setAccordionTitle("#patTableAccordion",title);	
}

function showFrmOrListFirt(data){
	
	var frm=window.parent.document.forms["fEPRMENU"];
	if(frm==undefined) frm =window.opener.parent.document.forms["fEPRMENU"];
	
	if(FirstLoad){
		FirstLoad=false;
		if(((frm.EpisodeID)&&(frm.EpisodeID.value!=""))||((frm.PatientID)&&(frm.PatientID.value!=""))){
			showThisPatient(frm.PatientID.value,frm.EpisodeID.value);
			return;
		}
		return; //默认可能会执行错如果核对不仔细的话，有风险-产品部
		$("#EpisodeID").val(data.rows[0].EpisodeID)
    	setPatInfo(data.rows[0]);
		loadFrame(data.rows[0]);
		$("#patTable").datagrid('selectRow',0);
		return;
	}
	if(data.rows.length==1){
		$("#EpisodeID").val(data.rows[0].EpisodeID)
    	setPatInfo(data.rows[0]);
		loadFrame(data.rows[0]);
		$("#patTable").datagrid('selectRow',0);	
	}
	return;
}
function showThisPatient(PatientID,EpisodeID){
	$("#EpisodeID").val(EpisodeID);
	$cm({
		ClassName:"web.DHCEMPat",
		MethodName:"GetPatInfo",
		EpisodeID:EpisodeID,
		PatientID:PatientID
	},function(jsonData){
		setPatInfo(jsonData);
		loadFrame(jsonData);
	});	
	return;
}

function emPatChange(){
	
	var frm=window.parent.document.forms["fEPRMENU"]; 
	var EpisodeID = frm.EpisodeID.value;
	var PatientID = frm.PatientID.value;
	/*var link = "dhcem.visitstat.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID;
	var openCss = 'width=1190,height=400, top=130, left=100, location=no,toolbar=no, menubar=no, scrollbars=yes, resizable=no,status=no'
	window.open(link,'newwindow',openCss);*/
	//websys_createWindow("../csp/dhcem.visitstat.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID,"","width=1190,height=400"); //hxy 2020-07-09
	var lnk = "dhcem.visitstat.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID;
	websys_showModal({
		url: lnk,
		iconCls:"icon-w-paper",
		title: $g('状态改变'),
		closed: true,
		onClose:function(){}
	});
	return;
	return;
}

function emPatChangeLoc(){
	
	var frm=window.parent.document.forms["fEPRMENU"]; 
	var EpisodeID = frm.EpisodeID.value;
	var PatientID = frm.PatientID.value;
	if(EpisodeID==""){
		$.messager.alert("提示", "请选择患者!");
		return;	
	}
	var lnk = "dhcem.rotatingbed.csp?EpisodeID="+EpisodeID;
	websys_showModal({
		url: lnk,
		iconCls:"icon-w-paper",
		title: $g('留观患者床位转移'),
		closed: true,
		onClose:function(){}
	});
	return;
}

function openSkinTestPage(admID,regNo,oeoreID,Allgryflag,TestMethod,ObserveTime){
	url='dhcem.skinTest.csp?adm='+admID+"&oeoreId="+oeoreID+"&RegNo="+regNo+"&Allgryflag="+Allgryflag+"&TestMethod="+encodeURI(TestMethod)+"&ObserveTime="+ObserveTime;    //iframe的url 2016-10-26 congyue  ' data-Allgryflag='"+Allgryflag+"

	websys_showModal({
		url: url,
		width: window.screen.availWidth-100,
		height: window.screen.availHeight-230,
		title: $g('皮试'),
		closed: true,
		onClose:function(){
			checkPatTestTime();
		}
	});
}

function parentFlash(){
	showSetBtn();
}

//hxy 2020-02-20
function setCellLabel(value,row,index){
	if(value=="1级"){value=$g("Ⅰ级");}
	if(value=="2级"){value=$g("Ⅱ级");}
	if(value=="3级"){value=$g("Ⅲ级");}
	if(value=="4级"){value=$g("Ⅳa级");}
	if(value=="5级"){value=$g("Ⅳb级");}
	return value;
}


function patTableOnClickRow(row){
	var link = "dhcem.nuraddorder.csp"+"?EpisodeID="+$("#EpisodeID").val()+"&DISPLAY=NONE";
	if ('undefined'!==typeof websys_getMWToken){
		link += "&MWToken="+websys_getMWToken();
	}
	$("#nuraddorder-iframe").attr("src",link) //hxy 2017-03-27
	
	if(CurPatientID!=row.Papmidr){
		CurPatientID=row.Papmidr;
		//reloadAdmCombox();  ///重新初始化下拉列表
		//EpisodeIDCombo=row.EpisodeID;		///切换人
	}else{
		if(CurPatientID=="") return;
		//row.EpisodeID=EpisodeIDCombo;	
	}
	
    $("#EpisodeID").val(row.EpisodeID);
    setPatInfo(row);
	loadFrame(row);	
}



function initAutoReloadTable(){
	mainTimeoutIdTestTime=setInterval('checkPatTestTime()',5000);
	mainTimeoutIdBlood=setInterval('searchPatBlood()',30000);
	mainTimeoutIdTest=setInterval('searchPatTest()',30000);
	if(($("#patTreatTable").length>0)&&(TREATINTERVAL>0)){ //hxy 2022-09-08
		mainTimeoutIdTreat=setInterval('searchPatTreat()',(TREATINTERVAL*1000));
	}
}

function changeCheckAdmType(e,value){
	$('#exexFormDiv').hide();
	$("#patJZTable").datagrid("resize");
}

function changeCheckOrdType(e,value){
	$('#exexFormDiv').show();
	$("#patJZTable").datagrid("resize");
}

///刷新过敏标志
function refreshAllergy(ord){
	
	var allgryInfo=serverCall("web.DHCEMNurExe","getAllergData",{ord:ord})
	var patId=allgryInfo.split("^")[0];
	var isAllergy=allgryInfo.split("^")[1];
	if(patId=="") return;
	
	var tabArr =  ALLTABLES.split('^');
	
	for(pos in tabArr){
		var tableId=tabArr[pos];
		if($('#'+tableId).length){
			var datas=$("#"+tableId).datagrid("getRows");
			for(dataIndex in datas){
				if(datas[dataIndex].Papmidr==patId){
					$('#'+tableId).datagrid('updateRow',{
						index: dataIndex,
						row: {
							Allgryflag:isAllergy
						}
					});
				}
			}
		}
	}
}


function initOneAdmCombobox(patId,admId){
	if(ORDEXECADM==1){
		$('#selectAdmArea').show();
		$HUI.combobox('#selectAdm',{
			url:LINK_CSP+"?ClassName=web.DHCEMInComUseMethod&MethodName=JsonAdms&PatID="+patId+'&admId='+admId+'&LgHospID='+LgHospID,
			valueField:'value',
			textField:'text',
			onSelect:function(option){
		        setMainAdm(option.value);
		        showPatBar('',option.value);
		        window.frames[0].search();
		    }
		})
		admId?$HUI.combobox('#selectAdm').setValue(admId):'';
	}else{
		$('#selectAdmArea').hide();	
		$HUI.combobox('#selectAdm').setValue('');
	}
}

function setMainAdm(admId){
	var frm=window.parent.document.forms["fEPRMENU"];	
	if(frm.EpisodeID){
		frm.EpisodeID.value=admId;
	}
	$("#EpisodeID").val(admId);
	ADM=admId;
	return;
}

function SetShadow(){
	setTimeout('$(".TipSkin").parent().parent().css("box-shadow","rgb(102, 102, 102) 2px 3px 10px")',300);
}

/// 护士执行 
function nurIndexPopWin(PatNo, PatientID, EpisodeID){
	IsOpenMoreScreen = isOpenMoreScreen();	///是否多屏幕 2022-03-07 用户大会
	if(!IsOpenMoreScreen)return;
	// openPatEmr(PatientID, EpisodeID, mradm);
	var patientObj = {
		RegNo: PatNo,
		EpisodeID: EpisodeID,
		Allgryflag: ALLGRYFLAG,
		PatientID: PatientID,
		MWToken: websys_getMWToken()
		}
	websys_emit("onNurExec",{"PatientID":PatientID, "EpisodeID":EpisodeID});
}

