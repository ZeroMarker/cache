///qqa
///2017-11-28
///HISUI检验查看
var PageLogicObj={
	m_selARCIMRowid:"",
	MainSreenFlag:websys_getAppScreenIndex()		//双屏标识
}
$(function (){

	initParam();
	
	//initPatInfo();
	
	initMethod();
	
	initOrderview();
	
	initDateBox();
	
	initDatagrid();
	
	initCombobox();
	
	InitARCItemSearch();
	
	if ((PageLogicObj.MainSreenFlag==0)&&(EpisodeID!="")){
		websys_emit("onSelectIPPatient",{PatientID:PatientID,EpisodeID:EpisodeID,mradm:""});
	}
})

function initCombobox(){
	
	$HUI.combobox("#ordTypeCombo",{
		url:LINK_CSP+"?ClassName=web.DHCAPPSeePatLis&MethodName=JsonListArciCat",
		//panelHeight:"auto",
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       
	    }	
	})	
	
	if($("#admType").length==1){
		$HUI.combobox("#admType",{
			data:[
				{"value":"O","text":$g("门诊")},
				{"value":"E","text":$g("急诊")},
				{"value":"I","text":$g("住院")}
			],
		
			valueField:'value',
			textField:'text',
			onSelect:function(option){
		       searchLisOrd();
		    }	
		})
	}
	
	$HUI.combobox("#ordTypeCombo",{
		url:LINK_CSP+"?ClassName=web.DHCAPPSeePatLis&MethodName=JsonListArciCat",
		//panelHeight:"auto",
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       
	    }	
	})
	$HUI.combobox("#ordResultCombo",{
		data:[
				{"value":"All","text":$g("全部")},
				{"value":"HasRe","text":$g("有结果")},
				{"value":"NoRe","text":$g("无结果")}
			],
		//panelHeight:"auto",
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       
	    }	
	})
}

function thisAdm_CheckChange(value){
	searchLisOrd();	
}

function initParam(){
	DateFormat="";
	showType=0;
	lisOrdRowData="";
	curCheckIndex="";
	ConnectString="";   ///报告打印数据库连接 
	webIP="";
	DateOrder="N";
	Unread="N"
	aIcon0Str=getIconHtmlI("鉴","white","blue");
	aIcon1Str=getIconHtmlI("预","white","blue");
	FindLocID="";
	if(FindByLocFlag=="Y"){
		FindLocID=LgCtLocID;
		$HUI.radio("#radio_week").setValue(true);
	}
	
	var params = OEORIID;
	runClassMethod("web.DHCAPPSeePatLis","GetParams",{Params:params},
		function (rtn){
			rtnArr = rtn.split("^");
			ConnectString=rtnArr[0];
			webIP=rtnArr[1];
			regNolenght=rtnArr[2];
			DateFormat = rtnArr[3];
			ordStDate = rtnArr[4];
		},"text",false
	)

}

function initMethod(){
	$('#search').on('click',searchLisOrd);
	$('#prtViewBtn').on('click',printViewClick);
	$('#prtBtn').on('click',printOutClick);
	$('#focusPrtBtn').on('click',printCentralClick);
	$('#affirmReadBtn').on('click',affirmReadBtnClick);
	$('#seeReadDetail').on('click',seeReadDetail);
	$('#seePrtDetail').on('click',seePrtDetail);
	//$('#seeOpHist').on('click',seeOpHist);
	///登记号
	if($('#patRegNo').length==1){
		$('#patRegNo').on('keypress', regNoKeyPress); 	
	}
	$('#MotherLab').on('click',MotherLabwindow);
	
	$HUI.radio("[name='timeRange']",{
        onChecked:function(e,value){
            upLisDate(e,value);
        }
    });
	$(window).resize(resizeLayout); 
}

function initOrderview(){
	$('#seeOpHist').orderview({ 
		ordGetter:function(){
			var OEOrdItemID="";
			var rowData = $HUI.datagrid("#lisOrdTable").getSelections();
			if(rowData.length!==0){
				OEOrdItemID	= rowData[0].OEOrdItemID;
			}
			return OEOrdItemID;
		},
		winHeight:300
	})
}

function resizeLayout(){
	//$HUI.layout("#center-layout").resize();	
	//$HUI.datagrid('#lisOrdTable').resize();
	//$HUI.datagrid('#lisOrdDetailTable').resize();
}

function regNoKeyPress(){
	if (event.keyCode!=13) return;
	var regNo = $('#patRegNo').val();

	if(regNo==""){
		$.messager.alert("提示","登记号为空");
		return;
	}

	///登记号补0
	for (i=regNo.length;i<regNolenght;i++){
		regNo = "0"+regNo;
	}
	
	runClassMethod("web.DHCEMInComUseMethod","GetPatIDByRegNo",
		{RegNo:regNo},
		function(ret){
			PatientID=ret;
		},"text",false
	) 
	$('#patRegNo').val(regNo);
	searchLisOrd();	
}



function initDateBox(){
	$HUI.datebox("#sel-stDate",{});
	$HUI.datebox("#sel-edDate",{});	
	if(FindByLocFlag=="Y"){
		var defStDate=ordStDate==""?formatDate(-7):ordStDate;
	}else{
		var defStDate=ordStDate==""?formatDate(-30):ordStDate;
	}
	$HUI.datebox("#sel-stDate").setValue(defStDate);
	$HUI.datebox("#sel-edDate").setValue(formatDate(0));
}

function myFormatDate(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	return y+'-'+m+'-'+d;
}

//初始化datagrid
function initDatagrid(){
	var Params=""
	var stDate = $HUI.datebox("#sel-stDate").getValue();
	var edDate = $HUI.datebox("#sel-edDate").getValue();
	
	Params= EpisodeID+"^"+PatientID+"^"+stDate+"^"+edDate+"^^0^^^"+UserId+"^0^^^^Y"+"^^^^"+OEORIID+"^";  //##
	Params= Params+"^"+""+"^"+FindLocID;

	
	var columns=[[
          { field: 'chkReportList', checkbox: true },
          { field: 'AdmBedNO', title: '床号', width: 60, sortable: false, hidden: (FindLocID=="") },
          { field: 'PatNameC', title: '姓名', width: 80, sortable: false, hidden: (FindLocID==""),
          	formatter: function(value, rowData, rowIndex){
				return rowData.PatName;
	        }
          },
          { field: 'PatAge', title: '年龄', width: 50, sortable: false, hidden: (FindLocID=="") },
          { field: 'PatSex', title: '性别', width: 50, sortable: false, hidden: (FindLocID=="") },
          { field: 'LabEpisode', title: '检验号', width: 105, sortable: true, align: 'center' },
          { field: 'OrdItemName', title: '医嘱名称', width: 200, sortable: true, align: 'left' ,formatter:orderviewArci},
          { field: 'AuthDateTime', title: '报告日期', width: 150, sortable: true, align: 'center' },
		  { field: 'ReportStatus', title: '报告状态', width: 200, sortable: false, align: 'center' 
          ,formatter: function(value, rowData, rowIndex){
	          	if (value=="预报告"){
					var btn = '<a href="#"  class="editcls"  onclick="ShowPreWindow(\'' + rowData.ReportUrl + '\')">'+value+'</a>';
				}else{
					var btn =value
				}
				return btn;
	        } 
          },
          { field: 'PatName', title: '姓名', width: 80, sortable: false, hidden: (FindLocID!="") },
          //{ field: 'Order', title: '预报告', width: 55, sortable: false, align: 'center',formatter:FormatOrder},
          //{ field: 'ResultStatus', title: '结果状态', width:100, sortable: false, align: 'center', formatter: ResultIconPrompt },
		  /*{ field: 'PrintFlag', title: '打印', width: 40, sortable: false, align: 'left',
          	formatter: function (value, rowData, rowIndex) {
				if (rowData.ResultStatus != "3") return "";
				if(value=="Y"){
					return '<a href="#" title="打印记录"  onclick="ShowPrintHistory(\''+rowData.VisitNumberReportDR+'\')"><span class="icon-ok" title="已打印">&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>';
				}else if(value=="N"){
					return '<a href="#" title="打印记录"  onclick="ShowPrintHistory(\''+rowData.VisitNumberReportDR+'\')"><span class="icon-undo" title="本人未打印">&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>';
				}
             }
          },*/
          { field: 'ReadFlag', title: '阅读', width: 40, sortable: false, align: 'center',
          	formatter: function(value, rowData, rowIndex){
	          	if (rowData.ResultStatus != "3") return "";
	        	if (value == "1") {
		        	return "<span class='icon-book_open' color='red' title='已阅读')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>";
	        	}else {
		        	return "<span class='icon-book_go' color='red' title='未阅读')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>";
	        	}  	
	        } 
          },
          //{ field: 'WarnComm', title: '危急提示', width: 150, sortable: false, align: 'left',formatter:FormatWarnComm },
          { field: 'OrdSpecimen', title: '标本', width: 150, sortable: false, align: 'left' },
 		  { field: 'ReceiveNotes', title: '标本备注', width: 150, sortable: false, align: 'left' }, 
          { field: 'MajorConclusion', title: '报告评价', width: 150, sortable: false, align: 'left' },
          { field: 'ReqDateTime', title: '申请日期', width: 150, sortable: true, align: 'center' },
          { field: 'SpecDateTime', title: '采集日期', width: 150, sortable: false, align: 'center' },
          { field: 'AdmLoc', title: '就诊科室', width: 150, sortable: false, align: 'center' },
          //{ field: 'RecDateTime', title: '接收日期', width: 150, sortable: false, align: 'center' },
          //旧版知识库的链接，标版停用,等待新版接口{ field: 'InsureList',align: 'center', title: '说明书',formatter:formatterInsureList},
          { field: 'VisitNumberReportDR', title: '报告ID', width: 100, sortable: false, align: 'center' },
          { field: 'OrderNote', title: '医嘱备注', width: 200, sortable: false, align: 'center' },
          { field: 'ARCIMId',align: 'center', title: 'ARCIMId',hidden:'true'},
          { field: 'AdmRowId',align: 'center', title: 'AdmRowId',hidden:'true'}
        ]]

	$HUI.datagrid('#lisOrdTable',{
		url:LINK_CSP+"?ClassName=web.DHCAPPSeePatLis&MethodName=JsonQryOrdListNew&Params="+Params,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:60,  
		pageList:[60], 
		loadMsg: $g('正在加载信息...'),
		//showHeader:false,
		toolbar:[],
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		onSelect:function (rowIndex, rowData){

			var ARCIMId=rowData.ARCIMId
			var VisitNumberReportDR=rowData.VisitNumberReportDR
			var Url=$.m({ 
				ClassName:"DHCDoc.DHCApp.LabReportSet", 
				MethodName:"GetUrl",
				Arcim:ARCIMId, HospId:session['LOGON.HOSPID'], VisitNumberReportDR:VisitNumberReportDR, 
				PatientID:PatientID, UserID:session['LOGON.USERID'],
				dataType:"text"
			},false); 
			if (Url==""){
				$("#lisOrdDetailTable").html('<table style="border:0px" id="lisOrdDetailTable"></table>')
				Initdetailtalbe();
				if(rowData.ResultStatus!="3"){
					reloadOrdDetailTable("");
					$("#detailOrdName").html(rowData.OrdItemName.substring(0,30));
				}
				setTimeout(function() { 
					reloadOrdDetailTable(rowData.VisitNumberReportDR);	   //刷新明细
				},600)
			}else{
				if(typeof websys_writeMWToken=='function') Url=websys_writeMWToken(Url);
				var toolbar=$('#toolbar').html()
				$("#lisOrdDetailTableID").html("")
				$("#lisOrdDetailTableID").html('<iframe id="lisOrdDetailTable" scrolling="yes" width=100% height=100% frameborder="0" src=""></iframe>')	
				$("#lisOrdDetailTable").attr("src", Url)
				$("body").append('<div id="toolbar" class="toolbar"></div>')
				var toolbarhtml='<input id="radio5" class="hisui-radio" checked="checked" type="radio" data-options="label:'+"'查看所有'"+',disable:false,name:'+"'detailType'"+',onCheckChange:function(event,value){upShowType(event,value)}">'
				toolbarhtml=toolbarhtml+'<input id="radio6" class="hisui-radio" type="radio" data-options="label:'+"'只看异常'"+',name:'+"'detailType'"+',disable:false,onCheckChange:function(event,value){upShowType(event,value)}">'
				toolbarhtml=toolbarhtml+'<a href="#" id="affirmReadBtn" class="pb-linkbutton" style="margin-left:0px;display:none"><img src="../scripts/dhcdoc/dhcapp/images/qryd.png">确认阅读</a>'
				toolbarhtml=toolbarhtml+'<a href="#" id="seeReadDetail" class="pb-linkbutton" style="margin-left:0px"><img src="../scripts/dhcdoc/dhcapp/images/ydmx.png">阅读明细</a>'
				//toolbarhtml=toolbarhtml+'<a href="#" id="seeOpHist" class="pb-linkbutton" style="margin-left:0px;display:none"><img src="../scripts/dhcdoc/dhcapp/images/bbzz.png">标本追踪</a>'
				$('#toolbar').html(toolbarhtml)
				$('#affirmReadBtn').on('click',affirmReadBtnClick);
				$('#seeReadDetail').on('click',seeReadDetail);
			    /*$("#radio6").click(function (){
				    $HUI.radio("#radio6").setValue(true);
							    })*/
				$HUI.radio("#radio5",{
					label:"查看所有",
			        onCheckChange:function(event,value){upShowType(event,value)}
			    });
			    $HUI.radio("#radio6",{
					label:"只看异常",
			        onCheckChange:function(event,value){upShowType(event,value)}
			    });
				//$('#seePrtDetail').on('click',seePrtDetail);
				}
			curCheckIndex= rowIndex; //设置全局的选中列号
			lisOrdRowData=rowData;   //设置全局的选中行数据
			$("#radio5").radio("setValue",true);  //默认查询所有
			
			reloadLisLab(rowIndex, rowData);
			hideOrShowReadBtn(rowData);
		}
	});
		
	
	
	var pager = $HUI.datagrid('#lisOrdTable').getPager();
	
	$(pager).pagination({
		showRefresh:false
	});
	
	
}
function Initdetailtalbe(){
	var columns=[[
    	{ field: 'Synonym',align: 'center', title: '缩写',width:45},
        { field: 'TestCodeName',align: 'center', title: '项目名称',width:60},
        { field: 'Result',align: 'center', title: '结果',styler:stylerResult,formatter:formatterResult,width:45},
		{ field: 'ExtraRes',align: 'center', title: '扩展结果'},
		{ field: 'AbFlag',align: 'center', title: '异常提示',width:45,styler: stylerAbFlag},
		{ field: 'HelpDisInfo',align: 'center', title: '辅助诊断',width:65,formatter: formatterHelpDisInfo},
		{ field: 'Units',align: 'center', title: '单位'},
		{ field: 'RefRanges',align: 'center', title: '参考范围',width:49},
		{ field: 'PreResult',align: 'center', title: '历次',width:35,formatter:HistoryIconPrompt,styler: stylerPreRs}, 
		{ field: 'PreAbFlag', align: 'center',title: '前次异常提示',hidden: true},
		{ field: 'ResNoes',align: 'center', title: '结果说明'},
 	]]; 
 	
 	$HUI.datagrid('#lisOrdDetailTable',{
		url:LINK_CSP+"?ClassName=web.DHCAPPSeePatLis&MethodName=JsonQryTSInfo",
		queryParams:{
			ReportDR:"",
			showType:showType 
		},
		fit:true,
		border:false,
		toolbar:'#toolbar',
		rownumbers:false,
		columns:columns,
		fitColumns:true,
		nowrap:false,
		pageSize:10,  
		pageList:[10,15,20], 
	    singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		pagination:false,
		onLoadSuccess: function (data) {
	        ShowDrugAllergy(data);   //显示药敏检验结果内容
        },
        onClickRow:function(rowIndex, rowData){
			var value=rowData.PreResult||"";
			var TestCodeName=rowData.TestCodeName||"";
			if (PageLogicObj.MainSreenFlag==0){
				if ((value=="")||(TestCodeName=="备注")||(rowData.ResultFormat!="N")){
					websys_emit("onSelectIPPatient",{PatientID:"",EpisodeID:lisOrdRowData.AdmNo,mradm:""});
					return false;
				}
				var frameurl="dhcapp.rscurve.csp?VisitNumberReportDR="+lisOrdRowData.VisitNumberReportDR+"&TestCodeDR="+rowData.TestCodeDR;
				//因为不能传递url参数以及对象Json链接参数
				var frameurl=frameurl.replace(/&/g,"!@")
				websys_emit("onOpenDHCDoc",{title:"检验结果曲线图",frameurl:frameurl});
			}
		}
	});	
	}
///显示药敏检验内容
function ShowDrugAllergy(data){
	var selectedRow=$('#lisOrdTable').datagrid('getSelected');
	if (!selectedRow) return;
	var ManualState=selectedRow["ManualState"];
	var data=data["rows"];
	
    var TSNames={};
    //菌落计数
    var ClonyNum={};
    //菌落形态
    var ClonyForms={};
    //备注
    var ResNoes={};
    //非药可以查看异常
    $("#radio6").radio("enable");
    for(var i=0;i<data.length;i++) {
	    var dataItm = data[i];
        if(dataItm["ResultFormat"] == "M" && dataItm["Result"].length > 0) {
	        //$("#radio6").radio("disable");   		//药敏的检验不能查看异常
            TSNames[dataItm["ReportResultDR"]] = dataItm["Result"];
            ClonyForms[dataItm["ReportResultDR"]]=dataItm["ClonyForm"];
            ClonyNum[dataItm["ReportResultDR"]]=dataItm["ClonyNum"];
            ResNoes[dataItm["ReportResultDR"]]=dataItm["ResNoes"];
            if (ManualState!="") {
	            var TestCodeName=dataItm["TestCodeName"];
				//交费才能看药敏
				var htmlStr="<table><tr><td><span style='color:red;font-weight:bold'>"+$g("项目: ")+TestCodeName+$g(" 的药敏试验医嘱未缴费,不能看药敏结果")+"</span></td></tr></table>";
				$('#lisOrdDetailTable').prev().children(".datagrid-body").append(htmlStr);
			}else{
	            //查询药敏结果
	            $.ajax({
		             url:'jquery.easyui.dhclabclassjson.csp',
		             async: false,
					 data: { 
						 ClassName:"web.DHCENS.STBLL.Method.PostReportInfo",
						 QueryName:"QryReportResultSen",
						 FunModul:"JSON",
						 P0:dataItm["ReportResultDR"],
						 MWToken:(typeof websys_getMWToken=='function')?websys_getMWToken():""
					 },
			         success: function (retData) {
			         	var htmlStr="";
				         retData = jQuery.parseJSON(retData)
				         if(retData["rows"] != undefined && retData["rows"].length >0){
					        htmlStr+="<table style='font-size:12px;padding-top:10;width:430'>";
					        htmlStr+="<tr><td colspan='5'><span style='color:red;font-weight:bold'>"+TSNames[retData["rows"][0]["VisitNumberReportResultDR"]]
					        if(ClonyNum[retData["rows"][0]["VisitNumberReportResultDR"]] != undefined && ClonyNum[retData["rows"][0]["VisitNumberReportResultDR"]].length > 0)
					        	htmlStr+="</span>----<span style='font-weight:bold'>"+$g("菌落计数：")+"</span>"+ClonyNum[retData["rows"][0]["VisitNumberReportResultDR"]];
					        	if(ClonyForms[retData["rows"][0]["VisitNumberReportResultDR"]] != undefined && ClonyForms[retData["rows"][0]["VisitNumberReportResultDR"]].length > 0)
					        htmlStr+="</span>----<span style='font-weight:bold'>"+$g("菌落形态：")+"</span>"+ClonyForms[retData["rows"][0]["VisitNumberReportResultDR"]];
					        htmlStr+="</td></tr>";
					        if(ResNoes[retData["rows"][0]["VisitNumberReportResultDR"]] != undefined && ResNoes[retData["rows"][0]["VisitNumberReportResultDR"]].length > 0)
					        	htmlStr+="<tr><td colspan='5'><span style='font-weight:bold'>"+$g("备注：")+"</span>"+ResNoes[retData["rows"][0]["VisitNumberReportResultDR"]]+"</td></tr>";
							htmlStr+="<tr style='font-weight:bold'>";
							htmlStr+="<td>"+$g("抗生素名称")+"</td>";
							htmlStr+="<td>"+$g("缩写")+"</td>";
							htmlStr+="<td>KB(mm)</td>";
							htmlStr+="<td>MIC(ug/ml)</td>";
							htmlStr+="<td>"+$g("结果")+"</td>";
							htmlStr+="</tr>";
							var kb=""
							var mic=""
							for(var index=0;index<retData["rows"].length;index++) {
								  htmlStr+="<tr>";
								  htmlStr+="<td>"+retData["rows"][index]["AntibioticsName"]+"</td>";
									htmlStr+="<td>"+retData["rows"][index]["SName"]+"</td>";

									if (retData["rows"][index]["SenMethod"] == "KB") {
										kb=retData["rows"][index]["SenValue"];
										mic="&nbsp"
									} else {
										mic=retData["rows"][index]["SenValue"];
										kb="&nbsp";
									}
									htmlStr+="<td>"+kb+"</td>";
									htmlStr+="<td>"+mic+"</td>";
									htmlStr+="<td>"+retData["rows"][index]["SensitivityName"]+"</td>";
									htmlStr+="</tr>";
							 }
							 htmlStr+="</table>";
					         $('#lisOrdDetailTable').prev().children(".datagrid-body").append(htmlStr);
					         
				         }
			         }
	            })
            }
            //查询耐药机制结果
            $.ajax({
	             url:'jquery.easyui.dhclabclassjson.csp',
	             async: false,
				 data: { 
					 ClassName:"web.DHCENS.STBLL.Method.PostReportInfo",
					 QueryName:"QryReportResultRst",
					 FunModul:"JSON",
					 P0:dataItm["ReportResultDR"],
					 P1:dataItm["ReportDR"],
					 P2:dataItm["TestCodeDR"],
					 MWToken:(typeof websys_getMWToken=='function')?websys_getMWToken():""
				 },
		         success: function (retData) {
			         var htmlStr="";
			         try{
			         	retData = jQuery.parseJSON(retData)
			         }catch(e){
				     	return;
				     }
			         if(retData["rows"] != undefined && retData["rows"].length >0){
				        htmlStr+="<table style='font-size:12px;padding-top:10;width:430'>";
				        htmlStr+="<tr><td><b>"+$g("耐药机制")+"</b></td></tr>";
						for(var index=0;index<retData["rows"].length;index++) {
							  htmlStr+="<tr>";
							  	htmlStr+="<td>"+retData["rows"][index]["ResistanceItemName"]+"</td>";
								var resItem=retData["rows"][index]["ResItem"];
								var result=retData["rows"][index]["Result"];
								if(resItem.length>0)
								{
									for(var i=0;i<resItem.length;i++)
									{
										if(resItem[i].id==result)
										{
											result=resItem[i].text;
											break;
										}
									}
								}
								htmlStr+="<td>"+result+"</td>";
							  htmlStr+="</tr>";
						 }
						 htmlStr+="</table>";
				         $('#lisOrdDetailTable').prev().children(".datagrid-body").append(htmlStr);
			         }
		         }
            })
        }  
    }
    var selectedRow=$('#lisOrdTable').datagrid('getSelected');
    if (selectedRow==null) return;
    if(selectedRow.MajorConclusion != undefined &&selectedRow.MajorConclusion.length>0){
       var TSMemostring ='<table style="width:100%"><tr><td style="width:75px"><b>'+$g("报告评价：")+'</b></td> <td> <div style="border:1px solid #000">'+selectedRow.MajorConclusion+'</div> </td></tr></table>';
        $('#lisOrdDetailTable').prev().children(".datagrid-body").append(TSMemostring); 
    }	
}

function reloadLisLab(rowIndex, rowData){
	var retStr = "<a href='#' title='' onclick='showHistory(\""+rowData.OEOrdItemID+"\")'>"+$g("历次数据")+"</span></a>"
	$("#lisLab").html(rowData.LabEpisode);				   //刷新Lab
	$("#lisStatus").html(rowData.StatusDesc);
	var lisRsHtml = ResultIconPrompt(rowIndex, rowData);
	$("#lisResult").html(lisRsHtml);
	var htmlStr="";
	htmlStr = $g("申请时间:")+rowData.ReqDateTime
	htmlStr =  htmlStr + "&nbsp;&nbsp;"+$g("报告时间:")+rowData.AuthDateTime
	//$("#lisOrdInfo").html(htmlStr);  //qqa不显示申请时间和接受时间
	//$("#detailOrdName").html(rowData.OrdItemName.substring(0,30)+"("+retStr+")");
	$("#detailOrdName").html(rowData.OrdItemName.substring(0,30));
}

function showHistory(OEOrdItemID){
	var url='dhcapp.seepatlishist.csp?OEORIID='+OEOrdItemID;
	if(typeof websys_writeMWToken=='function') url=websys_writeMWToken(url);
	window.open (url, "newwindow", "height=450, width=650, toolbar =no,top=100,left=300,, menubar=no, scrollbars=no, resizable=yes, location=no, status=no") ;
	return false;

}

//
function hideOrShowReadBtn(rowData){
	if((rowData.ResultStatus==3)&&(rowData.ReadFlag!=1)){
		$(".affirmReadBtn").show();	
	}else{
		$(".affirmReadBtn").hide();	
	}
}

///初始化病人信息
function initPatInfo(){
	
	runClassMethod("web.DHCAPPSeePatLis","GetAdmInfoByAdm",{EpisodeID:1370},
	   function(data){
		  $("#patName").html(data.PatName);
		  $("#patSex").html(data.PatSex);
		  $("#patAge").html(data.PatAge);
		  $("#regNo").html(data.PatNo);
		  $("#cardNo").html(data.PatCardNo);
		  $("#MRDiagnos").html(data.MRDiagnos);
		  $("#patLoc").html(data.QueDepDesc);
		  $("#patDoc").html(data.QueDocDesc);
		  $("#patWard").html(data.WardDesc);
		  DateFormat = data.DateSetting;
		  //$("#lisLab").html(data.PatSex);   //检验号在点击左侧列表时加载
	   },"json",false
	);
}

function reloadOrdDetailTable(portId){
	
	$HUI.datagrid('#lisOrdDetailTable').load({
		ReportDR:portId,
		showType:showType
	})
}

///病人检验医嘱加载
function setCellLabel(value, rowData, rowIndex){
	var reportRsStatus="",lisOrdStatus="";
    var value= rowData.ResultStatus;
    var imgHtm="",imgUrl="";

	if (value == "3") {
		var paramList=rowData.VisitNumberReportDR;
		if (rowData.TSResultAnomaly == "3") {
			reportRsStatus = "../scripts/dhcnewpro/images/absurd.png"; //荒
		}
		if (rowData.TSResultAnomaly == "2") {
			reportRsStatus = "../scripts/dhcnewpro/images/crisis.png"; //危
		}
		if (rowData.TSResultAnomaly == "1") {
			reportRsStatus = "../scripts/dhcnewpro/images/abnormal.png"; //异
		}
		if (rowData.TSResultAnomaly == "0") {
			reportRsStatus = ""; //正常
		}
		
		imgUrl = "../scripts/dhcnewpro/images/yetgo.png";

		if (rowData.ReadFlag == "1") {
    		imgUrl = "../scripts/dhcnewpro/images/yetread.png";
		}  
		
		lisOrdStatus = "background-image: url("+imgUrl+");";  //这个表示已经出报告
		

		lisOrdStatus =lisOrdStatus +" background-position-x: 135px;";
		lisOrdStatus =lisOrdStatus +" background-position-y: 7px;";
		lisOrdStatus =lisOrdStatus +" background-repeat-y: no-repeat;";
		lisOrdStatus =lisOrdStatus +" background-repeat-x: no-repeat;";
		lisOrdStatus =lisOrdStatus +" background-repeat: no-repeat;";
	}   
	
	if(reportRsStatus!=""){
		imgHtm='<IMG align="top" style="width:24px;float:right;margin-top:-5px" SRC=\"'+reportRsStatus+'\" title="" border=0/>';
	}else{
		imgHtm="";
	}
	var retHtml=""
	retHtml = 		  '<div style="'+lisOrdStatus+'" title="'+rowData.OrdItemName+'" class="hisui-tooltip" style="width:230px">'
	retHtml= retHtml+ 	'<h1 style="font-weight: normal;line-height:12px">'+rowData.OrdItemName.substring(0,17)+'</h1>'
	retHtml= retHtml+ 	'<h1 style="font-weight: normal;line-height:12px">'+$g("标本号:")+rowData.LabEpisode+'</h1>'
	retHtml= retHtml+ 	'<h1 style="font-weight: normal;line-height:12px">'+rowData.ReqDateTime+imgHtm+'</h1>'
	retHtml= retHtml+'</div>'
	return retHtml;
}


///历史结果图标
function HistoryIconPrompt(value, rowData, rowIndex) {

   var retHtml = "";
   var iconHtml ="",inconUrl="../scripts/dhcnewpro/images/curve-chart1.png";
   iconHtml = '<IMG align="top" style="width:16px;float:right;" SRC=\"'+inconUrl+'\" title="" border=0/>';
   if (value != "" && rowData.TestCodeName != $g("备注")) {
	    if (rowData.ResultFormat == "N"){
       		retHtml ="<a style='text-decoration:none;' href=\"javascript:void(ShowHistoryResult('"+lisOrdRowData.VisitNumberReportDR+"','"+rowData.TestCodeDR+"'));\">"+value+iconHtml+"</a>";
	    }else{ 
       		retHtml=value
	    }
    }
    return retHtml;
}

/////结果曲线图
function ShowHistoryResult(VisitNumberReportDR,TestCodeDR) {
	window.open ('dhcapp.rscurve.csp?VisitNumberReportDR='+VisitNumberReportDR+'&TestCodeDR='+TestCodeDR+"&MWToken="+websys_getMWToken(), "newwindow", "height=450, width=650, toolbar =no,top=100,left=300,, menubar=no, scrollbars=no, resizable=no, location=no, status=no") ;
	return false;
}

function stylerResult(value, row, index){
	var colStyle="color:black";
    if(value!="") {
        if (!isNaN(value)) {   ///数字类型
            if (row.AbFlag == "L") { colStyle = "color:blue"};
            if (row.AbFlag == "H") { colStyle = "color:red"};
            if (row.AbFlag == "PL") { colStyle = "background-color:red;color:blue"};
            if (row.AbFlag == "PH") { colStyle = "background-color:red;color:#ffee00"};
            if (row.AbFlag == "UL") { colStyle = "background-color:red;color:blue"};
            if (row.AbFlag == "UH") { colStyle = "background-color:red;color:#ffee00" };
            if (row.AbFlag == "S") { colStyle = "background-color:red;color:#ffee00"};
        }
    } 
    return colStyle;	
}

function formatterResult(value, row, index){

	if(row.ResultFormat=="M"){
	  //return '<a href="#" onClick="ShowMicReport(\''+row.TestCodeDR+'\');">'+value+'</a>';
	    return value;
	}else{
	  	return value;
	}
}

function formatterHelpDisInfo(value, row, index){
	value = value.replace(/\!/g,"\n\n");
	value = value.replace(/\@/g,"\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
	value = value.replace(/\^/g,"\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
	
	var rs=""
	if(value!=""){
		rs=$g("辅助");
	}
	var btn = '<a href="#" id ="HelpDis'+row.TestCodeDR +'"title="'+value+'" class="hisui-tooltip" onmouseover="HelpDisInfoonmouse(\'' + row.TestCodeDR+ '\') " ">'+rs+'</a>';
	return btn;
	//return "<a href='#' title='"+value+"' class='hisui-tooltip' data-options='position:right'>"+rs+"</a>";
}
function HelpDisInfoonmouse(TestCodeDR){
	$HUI.tooltip("#HelpDis"+TestCodeDR,{position:'top'}).show();
	}
function stylerAbFlag(value, row, index) {
	 var colStyle="color:black";
	 if (value) {  
	    if (value.trim() == "L") { colStyle = "color:blue"};
	    if (value.trim() == "H") { colStyle = "color:red"};
	    if (value.trim() == "A") { colStyle = 'color:red;' };
	    if (value.trim() == "PL") { colStyle = "background-color:red;color:blue"};
	    if (value.trim() == "PH") { colStyle = "background-color:red;color:#ffee00"};
	    if (value.trim() == "UL") { colStyle = "background-color:red;color:blue"};
	    if (value.trim() == "UH") { colStyle = "background-color:red;color:#ffee00"};
	    if (value.trim() == "S") { colStyle = "background-color:red;color:#ffee00"};
	 }
	return colStyle;
}


function stylerPreRs(value, row, index) {
    var colStyle="color:black";
    if (value != "") {
        if (!isNaN(value)) {   ///数字类型
            if (row.PreAbFlag == "L") { colStyle = "color:blue"};
    		if (row.PreAbFlag == "H") { colStyle = "color:red"};
   			if (row.PreAbFlag == "PL") { colStyle = "background-color:red;color:blue" };
    		if (row.PreAbFlag == "PH") { colStyle = "background-color:red;color:#ffee00" };
    		if (row.PreAbFlag == "UL") { colStyle = "background-color:red;color:blue"};
   			if (row.PreAbFlag == "UH") { colStyle = "background-color:red;color:#ffee00"};                 
        }
    
    }
    return colStyle;
}

function FormatOrder(value, rowData, rowIndex){
	var mcStr="";
	if(rowData.HasMC=="1"&&rowData.VisitNumberReportDR!="")
	{
	    mcStr+="<a style='text-decoration:none;color:red;' href='javascript:void(ReportMCView(" + rowData.VisitNumberReportDR + "))';>"+aIcon0Str+"</a>";
	}
	if(rowData.HasMid=="1"&&rowData.VisitNumberReportDR!="")
	{
	    mcStr+="<a style='text-decoration:none;color:red;' href='javascript:void(ReportMIDView(" + rowData.VisitNumberReportDR + "))';>"+aIcon1Str+"</a>";
	}
	return mcStr;
}

function orderviewArci(value, rowData, rowIndex){
	return "<a style='text-decoration:none;color:#017bce;' href='javascript:void(showOrderview(\"" + rowData.OEOrdItemID.replace(/,/g,"^") + "\"))';>"+value+"</a>";;
}

function showOrderview(ord){

	$.orderview.show(ord);
	return;
}

///危急提示 未审核的报告不让查看
function FormatWarnComm(value, rowData, rowIndex){
	var rs="";
	if(rowData.ResultStatus=="3"){
		rs=value;
	}
	return rs;
}

//结果图标显示
function ResultIconPrompt(value, rowData, rowIndex) {
	///(1登记，2初审，3审核，4复查，5取消审核，6作废，O其他)
    var mcStr="";
    if (value == "3") {
	    var paramList=rowData.VisitNumberReportDR;
	    if (rowData.TSResultAnomaly == "3") {
        	mcStr+="<a style='text-decoration:none;color:#FF83FA;' href='javascript:void(ReportView(\"" + rowData.PortUrl + "\"))';><span class='icon-absurb' color='red' title='荒诞结果')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>报告结果</a>";
	    }
	    if (rowData.TSResultAnomaly == "2") {
        	mcStr+="<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(\"" + rowData.PortUrl + "\"))';><span class='icon-panic' color='red' title='危急值结果')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>报告结果</a>";
	    }
	    if (rowData.TSResultAnomaly == "1") {
        	mcStr+="<a style='text-decoration:none;color:#FF7F00;' href='javascript:void(ReportView(\"" + rowData.PortUrl + "\"))';><span class='icon-abnormal' color='red' title='异常结果')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>报告结果</a>";
	    }
	    if (rowData.TSResultAnomaly == "0") {
        	mcStr+="<a style='text-decoration:none;color:blue' href='javascript:void(ReportView(\"" + rowData.PortUrl + "\"))';><span class='icon-normal' color='red' title='报告结果')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>报告结果</a>";
		}
    }
    
    if(rowData.HasBic=="1")
	{
		mcStr="<span style='color:red;'>"+$g("菌")+"</span>"+mcStr;
	}

    return mcStr;
}

function ResultIconPrompt1(rowIndex, rowData) {
	///(1登记，2初审，3审核，4复查，5取消审核，6作废，O其他)
	var value= rowData.ResultStatus
	if (value == "3") {
		var paramList=rowData.VisitNumberReportDR;
		if (rowData.TSResultAnomaly == "3") {
			return "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(" + rowData.PortUrl + "))';><img class='flo-left' style='width:24px' src='../scripts/dhcnewpro/images/absurd.png'/></span><span class='flo-left'>报告</span></a>";
		}
		if (rowData.TSResultAnomaly == "2") {
			return "<a style='text-decoration:none;color:red;' href='javascript:void(ReportView(" + rowData.PortUrl + "))';><img class='flo-left' style='width:24px' src='../scripts/dhcnewpro/images/crisis.png'/></span><span class='flo-left'>报告</span></a>";
		}
		if (rowData.TSResultAnomaly == "1") {
			return "<a style='text-decoration:none;color:orange;' href='javascript:void(ReportView(" + rowData.PortUrl + "))';><img class='flo-left' style='width:24px' src='../scripts/dhcnewpro/images/abnormal.png'/></span><span class='flo-left'>报告</span></a>";
		}
		if (rowData.TSResultAnomaly == "0") {
			return "<a style='text-decoration:none;' href='javascript:void(ReportView(" + rowData.PortUrl + "))';><span class='' color='red' title='报告结果')></span>报告结果</a>";
		}
	}   
}

function upLisDate(event,value){	
	if(value){
		switch ($(event.target).attr("id")){
			case "radio1":
				$HUI.datebox("#sel-stDate").setValue(formatDate(0));
				$HUI.datebox("#sel-edDate").setValue(formatDate(0));
				break;
			case "radio_week":
				$HUI.datebox("#sel-stDate").setValue(formatDate(-7));
				$HUI.datebox("#sel-edDate").setValue(formatDate(0));
				break;
			case "radio2":
				$HUI.datebox("#sel-stDate").setValue(formatDate(-30));
				$HUI.datebox("#sel-edDate").setValue(formatDate(0));
				break;
			case "radio3":
				$HUI.datebox("#sel-stDate").setValue(formatDate(-180));
				$HUI.datebox("#sel-edDate").setValue(formatDate(0));
				break;
			case "radio4":
				$HUI.datebox("#sel-stDate").setValue("");
				$HUI.datebox("#sel-edDate").setValue("");
				break;
		}
		searchLisOrd();
	}
}

function ReportView(url) {
	/*window.open (url, "newwindow", "height=500, width=900, toolbar =no,top=100,left=200,, menubar=no, scrollbars=no, resizable=no, location=no, status=no") ;
	return false;*/
	websys_showModal({
		url:url,
		title:'检验结果',
		width:900,height:500,
		CallBackFunc:function(){
		   var selectedRow=$('#lisOrdTable').datagrid("getSelected");
	   	   if(selectedRow!=null){
		   	    var index=$('#lisOrdTable').datagrid("getRowIndex",selectedRow);
		   	    $('#lisOrdTable').datagrid('updateRow',{
					index:index,
					row: {
						ReadFlag: '1'
					}
				});
                $('.affirmReadBtn').hide();
		   }
		}
	})
}

function searchLisOrd(){
	var Params=""
	var stDate = $HUI.datebox("#sel-stDate").getValue();
	var edDate = $HUI.datebox("#sel-edDate").getValue();
	var ARCICatDr = $HUI.combobox("#ordTypeCombo").getValue();
	var admTypeDesc= "";
	if($("#admType").length==1){
		//admTypeDesc = $HUI.combobox("#admType").getValue();
	}

	ARCICatDr=ARCICatDr==undefined?"":ARCICatDr;
	admTypeDesc=admTypeDesc==undefined?"":admTypeDesc;
	dataOrderVal = DateOrder=="Y"?1:-1;
	var ordResult = $HUI.combobox("#ordResultCombo").getValue();
	$("#detailOrdName").html($g("检验名称"));
	$("#lisOrdInfo").html("");
	var thisAdm="N";
	if($("#thisAdm").length>0){
		thisAdm=$("#thisAdm").checkbox("getValue")?"Y":"N";	
	}
	
	if ($("#ARCItemSearch").lookup('getText')=="") PageLogicObj.m_selARCIMRowid="";
	var ItemRowid=PageLogicObj.m_selARCIMRowid;
	if (typeof ItemRowid =="undefined" || ItemRowid==undefined) {ItemRowid="";}
	if ((ItemRowid.indexOf("||")==-1)&&(ItemRowid!="")){
		ItemRowid=ItemRowid+"||1";
	}
	var bedNo="";
	if($("#bedNo").length>0){
		bedNo=$("#bedNo").val();
	}
	Params=(thisAdm==="Y"?EpisodeID:"")+"^"+PatientID+"^"+stDate+"^"+edDate+"^^0^^^"+UserId+"^"+Unread+"^^^^Y"+"^"+ARCICatDr+"^"+admTypeDesc+"^"+dataOrderVal+"^"+""+"^"+ordResult;
	Params=Params+"^"+ItemRowid+"^"+FindLocID+"^"+bedNo;
	/*if ($HUI.datagrid('#lisOrdDetailTable')){
		$HUI.datagrid('#lisOrdDetailTable').load({
			ReportDR:"",
			showType:showType
		})
	}*/
	$("#lisOrdDetailTable").html('<table id="lisOrdDetailTable"></table>')
	
	$HUI.datagrid('#lisOrdTable').load({
		Params:Params
	})
}

function upShowType(event,value){
	var rowData = $HUI.datagrid("#lisOrdTable").getSelections();
	if(rowData.length===0) return;
	if(value){
		switch($(event.target).attr("id")){
			case "radio5" :   //全部
				showType=0;
				break;
			case "radio6" :   //异常
				showType=1;
				break;
		}
		
		if(rowData[0].ResultStatus=="3"){
			reloadOrdDetailTable(rowData[0].VisitNumberReportDR);
			return;
		}
	}
}

//报告打印浏览
function printViewClick() {
	var checkedRows = $HUI.datagrid("#lisOrdTable").getChecked();
	if(checkedRows.length===0){
		$.messager.alert("提示","没有选中数据！");
		return ;
	}
	var reportDRs = "";
	for (var i in checkedRows) {
		if (checkedRows[i].ResultStatus!= "3") {
			$.messager.alert("提示",'报告'+checkedRows[i].OrdItemName+"未出报告，不能进行打印预览！");
			return ;
		}
		if (reportDRs.length > 0)
			reportDRs = reportDRs+"^"+checkedRows[i].VisitNumberReportDR;
		else 
			reportDRs = checkedRows[i].VisitNumberReportDR
	}
	param="DOCTOR"
	connectString=ConnectString
	var UserParam=UserId + "^" + HospID;
	
	var printFlag = "0";
    var rowids = reportDRs;
    var userCode = UserParam;
    var paramList = param;
    var connectString = ConnectString;
    var printType = "PrintPreview";
    var clsName = "HIS.DHCReportPrint";
    var funName = "QueryPrintData";
	var Param = printFlag + "@" + connectString + "@" + reportDRs + "@" + UserParam + "@" + printType + "@" + paramList;
	PrintCommon(Param);
}

//报告打印
function printOutClick() {
	var checkedRows=$HUI.datagrid("#lisOrdTable").getChecked();
	if(checkedRows.length===0){
		$.messager.alert("提示","没有选中数据！");
		return ;
	}
	var reportDRs = "",rowIndexs="";
	for (var i in checkedRows) {
		if (checkedRows[i].ResultStatus != "3") {
			$.messager.alert("提示",'报告'+checkedRows[i].OrdItemName+"未出报告，不能打印！");
			return ;
		}
		
		if (reportDRs.length > 0) {
			reportDRs = reportDRs+"^"+checkedRows[i].VisitNumberReportDR;
			rowIndexs = rowIndexs+"^"+$HUI.datagrid("#lisOrdTable").getRowIndex(checkedRows[i]);
		}
		else {
			reportDRs = checkedRows[i].VisitNumberReportDR;
			rowIndexs = $HUI.datagrid("#lisOrdTable").getRowIndex(checkedRows[i]);
		}
	}
	rowIndexs = rowIndexs.toString();

	for(j=0;j<rowIndexs.split("^").length;j++){
		var index = rowIndexs.split("^")[j];
		$HUI.datagrid("#lisOrdTable").updateRow({
			index:index,
			row:{
				PrintFlag:"Y"	
			}
		})
		
		$HUI.datagrid("#lisOrdTable").checkRow(index);
	}
	
	param="DOCTOR"
	connectString=ConnectString;
	var UserParam=UserId  //+ "^" + HospID;
	var printFlag = "0";
    var rowids = reportDRs;
    var userCode = UserParam;
    var paramList = param;
    var paramList = "DOCTOR";
    var connectString = ConnectString;
    var printType = "PrintOut";
    var clsName = ""; //HIS.DHCReportPrint
    var funName = "QueryPrintData";
    
	//var Param = printFlag + "@" + connectString + "@" + reportDRs + "@" + UserParam + "@" + printType + "@" + paramList;
	var Param = printFlag + "@@" + reportDRs + "@" + UserParam + "@" + printType + "@"+paramList+"@@"+funName;
	//PrintCommon(Param);
	HISBasePrint(Param);	
   
}

function affirmReadBtnClick(){
	//$.messager.confirm("确认","是否阅读?",function (ret){
	//	if(ret){
	//		readPort();
	//	}	
	//})
	
	var selectedRow=$("#lisOrdTable").datagrid("getSelections");
	if (selectedRow.length==0) {
		$.messager.alert("提示","没有数据");	
	}
	
	readPort(selectedRow[0]);
	
}


function readPort(selectedRow){
	if(selectedRow.ResultStatus!="3"){
		$.messager.alert("提示","报告"+selectedRow.OrdItemName+"未出,不能阅读！");
		return;
	}
	
	var OrderID = selectedRow.OEOrdItemID;
	var VisitNumberReportDR = selectedRow.VisitNumberReportDR;
	var LabEpisode = selectedRow.LabEpisode;
	var params = OrderID+"^"+LabEpisode+"^"+LgCtLocID+"^"+UserId+"^"+VisitNumberReportDR;
	/*var ret = runClassMethod("DHCLIS.DHCReportControl","AddViewLog",{'UserId':UserId,'VisitNumberReportDRs':VisitNumberReportDR,'HospID':HospID,'OrderIDs':OrderID});	
	if(ret>0){
		$.messager.alert("提示","保存阅读记录异常！");
	}else{
		$.messager.alert("提示","阅读成功！");	
		$("#affirmReadBtn").hide();
		updateRowReadFlag();
	}
	return;*/
	runClassMethod("web.DHCAPPInterface","ClinicRecordSet",
		{
			Model:"R",
		 	Params:params
		},function(ret){
			if(ret!=0){
				$.messager.alert("提示","保存阅读记录异常！");
			}else{
				$.messager.popover({msg:"阅读成功！",type:'success'});
				$(".affirmReadBtn").hide();
				updateRowReadFlag();
			}	
		},"text"
	)		
}

function updateRowReadFlag(){
	var rowData = $HUI.datagrid("#lisOrdTable").getSelected();
	var index = $HUI.datagrid("#lisOrdTable").getRowIndex(rowData);
	$HUI.datagrid("#lisOrdTable").updateRow({
		index:index, //行索引
		row:{
			ReadFlag:1 
		}
	})
}

///查看阅读明细
function seeReadDetail(){
	var rowData = $HUI.datagrid("#lisOrdTable").getSelections();

	if(rowData.length===0){
		$.messager.alert("提示","未选中数据！");
		return;
	}
	
	var reportDR = rowData[0].VisitNumberReportDR;
	var ordItmId = rowData[0].OEOrdItemID;
	var params= ordItmId+"^^";
	if(reportDR==""){
		$.messager.alert("提示","未出报告！");
		return;
	}
	
	var columns=[[
		{field:'ReadDoctorName',title:'阅读人',width:110},
		{field:'ReadDate',title:'阅读日期',width:122},
		{field:'ReadTime',title:'阅读时间',width:122}
	]];

	$HUI.datagrid('#readDetailTable',{
		url:LINK_CSP+"?ClassName=web.DHCAPPSeePatLis&MethodName=ReadDetailByParams&Params="+params,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:6,  
		pageList:[6], 
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		showHeader:true,
		pagination:true
	});

	$HUI.window("#readDetailWin").open();
}

///查看打印明细
function seePrtDetail(){
	var rowData = $HUI.datagrid("#lisOrdTable").getSelections();

	if(rowData.length===0){
		$.messager.alert("提示","未选中数据！");
		return;
	}
	
	var reportDR = rowData[0].VisitNumberReportDR;
	
	if(reportDR==""){
		$.messager.alert("提示","未出报告！");
		return;
	}

	var columns=[[
		{field:'PrtDoctorName',title:'打印人',width:110},
		{field:'PrtDate',title:'打印日期',width:110},
		{field:'PrtTime',title:'打印时间',width:110}
	]];

	$HUI.datagrid('#prtDetailTable',{
		url:LINK_CSP+"?ClassName=web.DHCAPPSeePatLis&MethodName=JsonGetPrtRecord&ReportDR="+reportDR,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:6,  
		pageList:[6], 
	    singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		showHeader:true,
		pagination:true
	});

	$HUI.window("#prtDetailWin").open();
}

function seeOpHist(){
	var rowData = $HUI.datagrid("#lisOrdTable").getSelections();
	if(!rowData.length){
		$.messager.alert("提示","未选择数据！");
		return;	
	}

	showTraceDetail(rowData[0].OEOrdItemID);
}

function PrintCommon(Param) {
	var printUrl="http://"+ webIP +"/imedicallis/lisprint/print2HIS/ResultPrintForHis.application?Param="+Param;
	if(typeof websys_writeMWToken=='function') printUrl=websys_writeMWToken(printUrl);
	document.location.href=printUrl;
}

function showTraceDetail(OEOrdItemID){
	//var url = 'jquery.easyui.dhclabreporttrace.csp?LabNo='+LabNo;
	var url = 'dhc.orderview.csp?ord='+OEOrdItemID;
	var openCss = 'width='+(window.screen.availWidth-100)+',height='+(window.screen.availHeight-380)+ ', top=150, left=50, location=no,toolbar=no, menubar=no, scrollbars=no, resizable=no,status=no'
	if(typeof websys_writeMWToken=='function') url=websys_writeMWToken(url);
	window.open(url,'newwindow',openCss) 	
}

//微生物报告浏览
function ShowMicReport(TestCodeDR) {
	var url = "http://192.168.200.11//iMedicalLIS/facade/ui/frmMicReporstPrint.aspx?reportDRs="+lisOrdRowData.VisitNumberReportDR+"&TestCodeDR="+TestCodeDR;
	var openCss = 'width='+(window.screen.availWidth-100)+',height='+(window.screen.availHeight-550)+ ', top=250, left=50, location=no,toolbar=no, menubar=no, scrollbars=no, resizable=no,status=no'
	window.open(url,'newwindow',openCss) ;
	return false;
}


///显示打印记录
function ShowPrintHistory(ReportDR) {
	if(ReportDR=="") return;
	if(ReportDR.split(",").length > 1) ReportDR = ReportDR.split(",")[0];
	 $HUI.window("#printHistory").open();
    $HUI.datagrid('#printHistoryTable',{
        url: "jquery.easyui.dhclabclassjson.csp",
        queryParams: { 
			ClassName:"LIS.WS.BLL.DHCRPVisitNumberReportPrint",
			QueryName:"QryReportPintHistoryList",
			FunModul:"JSON",
			P0:ReportDR
		},
        fit: true,
        rownumbers: true,
        columns: [[
	        {
	            field: 'PrintDT', title: '打印时间', width: 150, align: 'left',
	            formatter: function (value, row, index) {
	                return row["PrintDate"] + "&nbsp;&nbsp;" + row["PrintTime"];
	            }
	        },
	        { field: 'PrintedUserName', title: '打印者', width: 100, align: 'center' },
	        {
	            field: 'ModuleID', title: '打印类型', width: 100, align: 'center',
	            formatter: function (value, row, index) {
	                if (value == "LIS") {
	                    return $g("检验科打印");
	                }
	                if (value == "DOCTOR") {
	                    return $g("医生打印");
	                }
	            }
	        }
        ]]
    });
}

function initShowThisAdmCheck(){
	if(EpisodeID===""){
		$("#thisAdm").hide();
	}	
}


//Desc图标文字
function getIconHtmlI(Desc, Color, BackGroundColor) {
    if (Color == undefined || Color.length == 0 || Color == null) Color = '#FFF';
    if (BackGroundColor == undefined || BackGroundColor.length == 0 || BackGroundColor == null) BackGroundColor = '#fd5454';
    var retHtml = '<div style=" background-color:' + BackGroundColor + ';display:inline-block;border-radius:4px;width:16px;height:16px;text-align:center" ';
    retHtml += '><span style="color:' + Color + ';font-size:10px;text-align:center">' + Desc + '</span></div>';
    return retHtml;
}



//报告鉴定过程浏览
function ReportMCView(VisitNumberReportDR) {
	var url='jquery.easyui.dhcMCProcess.csp?VisitNumberReportDR='+VisitNumberReportDR;
	if(typeof websys_writeMWToken=='function') url=websys_writeMWToken(url);
	window.open (url, "newwindow", "height=450, width=650, toolbar =no,top=100,left=300,, menubar=no, scrollbars=no, resizable=yes, location=no, status=no") ;
	return false;
}


//报告中间报告浏览
function ReportMIDView(VisitNumberReportDR) {
	var url='jquery.easyui.dhclabmidreport.csp?VisitNumberReportDR='+VisitNumberReportDR;
	if(typeof websys_writeMWToken=='function') url=websys_writeMWToken(url);
	window.open (url, "newwindow", "height=450, width=650, toolbar =no,top=100,left=300,, menubar=no, scrollbars=no, resizable=yes, location=no, status=no") ;
	return false;
}

//集中打印
function printCentralClick() {
	if(FindByLocFlag=="Y"){
		var checkedRows = $HUI.datagrid("#lisOrdTable").getChecked();
		if(checkedRows.length===0){
			$.messager.alert("提示","没有勾选选中数据！");
			return ;
		}
		var admNoAry = [];
		for (var i in checkedRows) {
			var AdmRowId=checkedRows[i].AdmRowId;
			admNoAry.push(AdmRowId);
		}
		if(admNoAry.length===0){
			$.messager.alert("提示","没有勾选选中数据！");
			return ;
		}
		for(var i=0;i<admNoAry.length;i++){
			print(admNoAry[i]);
		}
	}else{
		var admNo = EpisodeID;
		if(admNo==""){
			$.messager.alert("提示","没有当前就诊信息,不能集中打印！","warning");
			return;
		}
		print(admNo);
	}
	function print(admNo){
		param="DOCTOR"
		connectString=ConnectString
		var UserParam=UserId //+ "^" + HospID
		var printFlag = "0";       ///0:打印所有报告 1:循环打印每一份报告
	    var printType = "PrintOut";    ///PrintOut:打印  PrintPreview打印预览
	    var paramList = "LIS";               ///1:报告处理打印 2:自助打印 3:医生打印
	    var clsName = "HIS.DHCCentralPrint";
	    var funName = "QueryPrintData";
		//var Param = printFlag + "@" + connectString + "@" + admNo + "@" + UserParam + "@" + printType + "@" + paramList +"@"+clsName+"@"+funName;
		var Param = printFlag + "@@" + admNo + "@" + UserParam + "@" + printType + "@"+paramList+"@"+clsName+"@"+funName;
		HISBasePrint(Param);	
		//PrintCommon(Param);
		return;
	}
}
function formatterInsureList(value, rowData, rowIndex){
	return "<a style='text-decoration:none;color:#017bce;' href='javascript:void(showInsureListview(\"" + rowData.ARCIMId + "\",\"" + rowData.OrdSpecimenCode + "\"))';>"+$g("说明书")+"</a>";
	/*
	if (rowData.InsureListviewFlag==1){
		return "<a style='text-decoration:none;color:#017bce;' href='javascript:void(showInsureListview(\"" + rowData.ARCIMId + "\",\"" + rowData.OrdSpecimenCode + "\"))';>"+$g("说明书")+"</a>";
	}else{
		return ""
	}*/
}

/// Modify  20230322
/// 旧版知识库的链接，标版停用。药品说明书使用新产品组合理用药，检查检验等将使用基础数据平台
function showInsureListview(ARCIMId,OrderLabSpecRowid){
	var itemHtml = "";
	if(Common_ControlObj.LibPhaFunc.ZSKOpenFlag=="Y"){
		itemHtml = GetItemInstr(ARCIMId, "", OrderLabSpecRowid);
	}
	if (itemHtml == "") {
		$.messager.alert("提示","未启用或未维护相应说明书!","warning");
		return;
	}
	$("#itro_content").html(itemHtml); 
	$HUI.window("#readInter").open();
}
/// 提取检查项目说明书
/// 此方法需与医嘱录入统一。待新版检查检验知识库说明书
function GetItemInstr(itmmastid, itemPartID, OrderLabSpecRowid){
	var html = '';
	// 获取显示数据
	runClassMethod("web.DHCAPPExaReportQuery","GetItemInstr",{"itmmastid":itmmastid, "itemPartID":itemPartID,"OrderLabSpecRowid":OrderLabSpecRowid},function(jsonString){

		if (jsonString != ""){
			var jsonObject = jsonString;
			html = initMedIntrTip(jsonObject);
		}else{
			html = "";
		}
	},'json',false)
	return html;
}
/// 初始化知识库信息描述
function initMedIntrTip(itmArr){
	
	var htmlstr = '';
	for(var i=0; i<itmArr.length; i++){
		
		htmlstr = htmlstr + "<table  cellpadding='0' cellspacing='0' class='itro_content'>" //<tr><td style='background-color:#F6F6F6;width:120px' >〖检查项目〗</td><td colspan='2'  style='border-right:solid #E3E3E3 1px'>"+itmArr[i].geneDesc+"["+itmArr[i].pointer+"]</td></tr>";
		htmlstr = htmlstr + "<tr><td style='background-color:#F6F6F6;font-weight:bold; font-size:14px;'>"+itmArr[i].itemTile+"</td></tr>";
		htmlstr = htmlstr + "<tr><td style='font-size:14px; padding-left: 10px;'>"+itmArr[i].itemContent+"</td></tr>";
		htmlstr = htmlstr + "</table>";
	}

   return htmlstr;
}
function ShowPreWindow(url){
	websys_showModal({
		url:url,
		title:'检验中间报告',
		width:900,height:500,
		CallBackFunc:function(){
		   var selectedRow=$('#lisOrdTable').datagrid("getSelected");
	   	   if(selectedRow!=null){
		   	    var index=$('#lisOrdTable').datagrid("getRowIndex",selectedRow);
		   	    $('#lisOrdTable').datagrid('updateRow',{
					index:index,
					row: {
						ReadFlag: '1'
					}
				});
                $('.affirmReadBtn').hide();
		   }
		}
	})
	
	}
//tanjishan
//2020-09-22
//考虑到目前该界面的应用场景，只做了界面数据刷新，并未实现切换患者的功能
function xhrRefresh(refreshArgs){
	$("#search").click()
	if ((PageLogicObj.MainSreenFlag==0)&&(EpisodeID!="")){
		websys_emit("onSelectIPPatient",{PatientID:PatientID,EpisodeID:EpisodeID,mradm:""});
	}
}
function MotherLabwindow(){
	var scremwidth=$(window).width()-40
	var scremheight=$(window).height()-80
	var src="dhcapp.seepatlis.csp?&PatientID="+MotherPatientID+"&EpisodeID="+MotherAdmDR+"&mradm="+MotherMradm
	if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Motherlabwindow","母亲检验结果", scremwidth, scremheight,"icon-w-edit","",$code,"");
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
	        destroyDialog(id);
	        if (_title=="预交金充值"){
		        PatientNo=$("#PatientNo").val();
		        if (PatientNo!=""){
					CheckPatientNo();
					PageLogicObj.m_PreCardNo=$("#CardNo").val();
					PageLogicObj.m_PreCardType=$("#CardTypeNew").val();
					PageLogicObj.m_PreCardLeaving=$("#CardLeaving").val();
		        }
		    }
	    }
    });
}

function InitARCItemSearch(){
		$("#ARCItemSearch").lookup({
	        url:$URL,
	        mode:'remote',
	        method:"Get",
	        idField:'ArcimRowID',
	        textField:'ArcimDesc',
	        columns:[[  
				{field:'ArcimDesc',title:'名称',width:350,sortable:true},
				{field:'ArcimRowID',title:'ID',width:120,sortable:true},
				{field:'selected',title:'ID',width:120,sortable:true,hidden:true}
	        ]],
	        pagination:true,
	        panelWidth:500,
	        panelHeight:400,
	        isCombo:true,
	        minQueryLen:2,
	        delay:'500',
	        queryOnSameQueryString:true,
	        queryParams:{ClassName: 'DHCDoc.DHCDocConfig.ArcItemConfig',QueryName: 'FindAllItem'},
	        onBeforeLoad:function(param){
		        var desc=param['q'];
		        if (desc=="") return false;
				param = $.extend(param,{Alias:desc});
		    },onSelect:function(ind,item){
			    PageLogicObj.m_selARCIMRowid=item['ArcimRowID'];
			}
	    });
	    return false;
}
