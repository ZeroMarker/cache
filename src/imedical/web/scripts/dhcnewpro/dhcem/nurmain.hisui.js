var CARDNO="";
var ADM="";
var ALLGRYFLAG="";
var PAPMIDR="";
var REGNO="";
var PatCardNo="";
var serverName="";
var StartDate = new Date();
StartDate.setDate(StartDate.getDate()-parseInt(DEFORDDAY));   //默认当天
StartDate = StartDate.Format(DateFormat);
var EndDate=new Date().Format(DateFormat);

$(function(){
	initPage();
	initValue();
	showSetBtn();	///显示右上角状态改变按钮
	initMethod();   ///Dom元素绑定方法
	initTable();
	initTab();
	initBTN();
	initCSS(); 
	setInterval('checkPatTestTime()',5000);
	
})
function initPage(){
	if(!$("#leftAccordion").accordion("panels").length){
		$('#nurMainLayout').layout('hidden','west');
	}
	return;
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
		$("#EpisodeID").val(frm.EpisodeID.value)
		$("#ParEpisodeID").val(frm.EpisodeID.value)
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
			var tab = $('#chartTab').tabs('getTab',title);
			url=tab.attr("data-url")+"?RegNo="+REGNO+"&EpisodeID="+$("#EpisodeID").val()+"&Allgryflag="+ALLGRYFLAG+"&PatientID="+PAPMIDR
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
		    	},
			    onClickRow:function(index,row){
				    $("#nuraddorder-iframe").attr("src","dhcem.nuraddorder.csp"+"?EpisodeID="+$("#EpisodeID").val()+"&DISPLAY=NONE") //hxy 2017-03-27
				    $("#EpisodeID").val(row.EpisodeID)
				    setPatInfo(row);
					loadFrame(row);
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
							    var htmlstr =  '<div class="celllabels"><span class="CardName " table-data-id="patTestTable" onClick="CallPat(this)">'+ rowData.PatName +'</span><span class="patInfo"><span>'+ rowData.TestStartTime +"/"+rowData.TestTime+'</span></span><br>';
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
								if((row.ToObserveTime=="0秒")||(row.ToObserveTime=="")){
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
					title="皮试("+total+")"
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
							htmlstr = htmlstr + '<div class="patID" style="float:left">排队号:'+ rowData.QueueNo +'</div>';
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
			        title="输液("+total+")";
			        setAccordionTitle("#patSYTableAccordion",title);
		    	},
			    onClickRow:function(index,row){
				    $("#nuraddorder-iframe").attr("src","dhcem.nuraddorder.csp"+"?EpisodeID="+$("#EpisodeID").val()+"&DISPLAY=NONE") //hxy 2017-03-27
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
							htmlstr = htmlstr + '<div class="patID" style="float:left">排队号:'+ rowData.QueueNo +'</div>';
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
			        title="治疗("+total+")";
			        setAccordionTitle("#patTreatTableAccordion",title);
				    $("#serverDesc").html(serverDesc.split("^")[0])

		    	},
			    onClickRow:function(index,row){
				    $("#nuraddorder-iframe").attr("src","dhcem.nuraddorder.csp"+"?EpisodeID="+$("#EpisodeID").val()+"&DISPLAY=NONE") //hxy 2017-03-27
				    $("#EpisodeID").val(row.EpisodeID)
				    selectTest(row.EpisodeID)
				}
			})
		}
		//格式化datagrid的pagination//
		pageFormater('patTable^patSYTable^patTestTable^patTreatTable');
		/*hxy 2018-11-02注释 因为改为下拉的了，不忍心地注释掉吧 /转换科室列表
		$HUI.datagrid('#changeLocDatagrid',{
			columns:[[
				{
					field: 'locName',
					title: '名称',
					width:200
				},
				{
					field: 'locId',
					hidden:true
				}
			]],
			url:'dhcapp.broker.csp?ClassName=web.DHCEMChangeLoc&MethodName=QueryLoc',
			singleSelect:true,
			autoSizeColumn:false,
			fitColumns: true,
			fit:true,
			border:false,
			onClickRow:function(index,row){
				$("#Loc").val(row.locId)
				$("#ParEpisodeID").val('')
				queryPatList();  
				$HUI.dialog('#changeLocDialog').close()
			}
		})	*/	
}		


function cellFormat(value,rowData){
	var Allgryflag="";//2016-10-25 congyue
	var htmlstr =  '<div class="celllabels" ><span class="CardName">'+ rowData.PatName +'</span><span class="patInfo" ><span>'+ rowData.Sex +'/'+ rowData.Age +'</span></span><br>';
	
	htmlstr = htmlstr + '<div class="patID">ID:'+ rowData.CardNo +'</div><div style="float:right">';
	level="";
	levelflag="0"
	if(rowData.NurseLevel>0){
		levelflag="1"
		level=rowData.NurseLevel+"级";
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
			Allgryflag="敏";
			htmlstr = htmlstr+'<div style="float:left;margin-top:3px;margin-right:5px"><span class="badger sensBar" ><div class="sensText"><a style="cursor:pointer;color:#FFFBFB;margin-left:-1px" "id="allery" onclick="gotoAllery('+rowData.CardNo+','+rowData.EpisodeID+')">'+Allgryflag+'</a></div></span></div></div>'; //hxy 2018-06-20
		}else{
			htmlstr = htmlstr+'<div style="float:left;margin: 5px 3px 0px 36px;"><span class="badger sensBar" style="margin-right: 26px"><div class="sensText"><a style="cursor:pointer;color:#FFFBFB;margin-left:-1px" "id="allery" onclick="gotoAllery('+rowData.CardNo+','+rowData.EpisodeID+')">'+"敏"+'</a></div></span></div></div>';
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
	$("#patTable").datagrid('reload');
} 
function searchPatTest(){
	$("#patTestTable").datagrid('reload');	
}
function searchPatTreat(){
	$("#patTreatTable").datagrid('reload');	
}
function searchPatSY(){
	$("#patSYTable").datagrid('reload');	
}
function treatFormater(value,rowData){
		var htmlstr =  '<div class="celllabels"><span class="CardName " onClick="CallPat(this)">'+ rowData.PatName +'</span><span class="patInfo"><span>'+ rowData.QueueState +"/"+rowData.QueuePrior+'</span></span><br>';
		htmlstr = htmlstr + '<div class="patID" style="float:left">排队号:'+ rowData.QueueNo +'</div>';
		classstyle="color: #18bc9c";
		level=rowData.ClientName
		htmlstr = htmlstr +'<div style="float:right;"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+level+'</span></div></div>';
		return htmlstr;
}


function gotoAllery(CardNo,EpisodeID){
	$('#chartTab').tabs('select','过敏记录');
}
function loadFrame(row){
	
	var tab = $('#chartTab').tabs('getSelected');
	url=tab.attr("data-url");
	adm=row.EpisodeID
	if($("#patTableAccordion").length>0){
		if(getAccordionTitle("#patTableAccordion").indexOf("座位")>-1){
			$("#EpisodeID").val("");
			//adm="";
		}
	}
	//设置全局变量
	if(row.PatCardNo!=undefined){
		PatCardNo=row.PatCardNo;
	}else{
		PatCardNo="";
	}
	REGNO=row.CardNo;
	ADM=adm;
	ALLGRYFLAG=row.Allgryflag;
	PAPMIDR=row.Papmidr
	
	url=url+"?RegNo="+REGNO+"&EpisodeID="+ADM+"&Allgryflag="+ALLGRYFLAG+"&PatientID="+PAPMIDR+"&PatCardNo="+PatCardNo;
	tab.find('iframe').attr('src', url);
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
	var AdmDr = row.EpisodeID;
	if(StayFlag==0) AdmDr="";   //输液室患者不需要显示跟就诊有关信息
	$.m({ClassName:"web.DHCDoc.OP.AjaxInterface",MethodName:"GetOPInfoBar",CONTEXT:"",EpisodeID:AdmDr,PatientID:row.Papmidr},function(html){
		if (html!=""){
			$("#patInfo").html(reservedToHtml(html));
			$("#patInfo").mouseover(function(){
				html=reservedToHtml(html).replace(/color:#589DDA/g, "");
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
			$("#patInfo").html("获取病人信息失败。请检查【患者信息展示】配置。");
		}
	});
	
	try{
		
		var frm=window.parent.document.forms["fEPRMENU"];
		if(frm.EpisodeID){
			frm.EpisodeID.value=row.EpisodeID;
			frm.PatientID.value=row.Papmidr
			if(getAccordionTitle("#patTableAccordion").indexOf("座位")>-1){
				frm.EpisodeID.value="";
				frm.PatientID.value=="";
			}
			if(flag==1){
				frm.EpisodeID.value="";
				frm.PatientID.value=="";
			}
		}
		
	}catch(e){
		//alert(e.message)
	}
	
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
		var  foldBtn = "<div class='panel-tool' style='right:-20px'><a href='javascript:foldOpBtn()' id='foldNurBtn' class='layout-nurbtn-right'></a></div>";
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
	str='确认把'
	str=str+'<span style="color:red">'+patName+'</span>';
	str=str+'转到';
	str=str+'<span style="color:red">'+xx+'</span>';
	str=str+'吗？';
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
		if(datas[i].QueueState!="呼叫"){
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
				
				if((QueueState!="完成")&&(QueueState!="呼叫"))
				{
					var PatName="",QueNo="",TreatId=""
					var TreatId=Obj.TreatId;
					PatName=Obj.PatName;
					QueNo=Obj.QueueNo;
					if(QueNo!="")
					{
						var State="Ready"
						if(QueueState=="等候")
						{
							var retStr=updateTreatQue(TreatId,"",State)
							if(ReadyPat=="") ReadyPat=QueNo+"号,"+PatName	
							else  ReadyPat=ReadyPat+"!"+QueNo+"号,"+PatName
						}
						if(WaitPat=="") WaitPat=QueNo+"号,"+PatName	
						else  WaitPat=WaitPat+"!"+QueNo+"号,"+PatName	
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
	  $.ajax({
	     type: "POST",
	     url: LINK_CSP,
	     data: {
				'ClassName':'web.DHCEMSkinTest',
				'MethodName':'GetSkinTestPat',
				'limit':999,'offset':0
		 },
	     dataType: "json",
	     success: function(data){
		     		
		     		changePatTestTableAccordion(data);
		     		
					html="";
					count=0
					html=html+"<table class='table table-hover table-vcenter'>"
					html=html+"	<tbody>"
					$.each(data.rows,function(n,value){
						if((value.ToObserveTime=="0秒")||(value.ToObserveTime=="")){
							count=count+1;
							html=html+"<tr onClick='selectTest("+value.EpisodeID+")'><td>"+value.PatName+"</td></tr>"
						}
					})
					html=html+"	</tbody>"
					html=html+"</table>"

					if(count==0){
						return;
					}
					$.messager.show({
						title:'皮试提醒',
						msg:html,
						timeout:5000,
						showType:'slide'
					});
	     }
	 }); 

}

function changePatTestTableAccordion(data){
	var skinTableRowIndex="";
	var skinTableDatas=$("#patTestTable").datagrid("getData").rows;
	
	$.each(data.rows,function(n,value){
		if((value.ToObserveTime=="0秒")||(value.ToObserveTime=="")){
			
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
	if((frm.EpisodeID)&&(frm.EpisodeID.value!="")){
		$("#EpisodeID").val(frm.EpisodeID.value);
		$cm({
			ClassName:"web.DHCEMPat",
			MethodName:"GetPatInfo",
			EpisodeID:frm.EpisodeID.value,
			PatientID:frm.PatientID.value
		},function(jsonData){
			setPatInfo(jsonData);
			loadFrame(jsonData);
		});
	}else{
		$("#EpisodeID").val(data.rows[0].EpisodeID)
    	setPatInfo(data.rows[0]);   ///Adm and PatientID
		loadFrame(data.rows[0]);    ///	
	}
}

function emPatChange(){
	
	var frm=window.parent.document.forms["fEPRMENU"]; 
	var EpisodeID = frm.EpisodeID.value;
	var PatientID = frm.PatientID.value;
	/*var link = "dhcem.visitstat.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID;
	var openCss = 'width=1190,height=400, top=130, left=100, location=no,toolbar=no, menubar=no, scrollbars=yes, resizable=no,status=no'
	window.open(link,'newwindow',openCss);*/
	websys_createWindow("../csp/dhcem.visitstat.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID,"","width=1190,height=400"); //hxy 2020-07-09
	return;
}

function emPatChangeLoc(){
	
	var frm=window.parent.document.forms["fEPRMENU"]; 
	var EpisodeID = frm.EpisodeID.value;
	var PatientID = frm.PatientID.value;
	var lnk = "dhcem.rotatingbed.csp?EpisodeID="+EpisodeID;
	websys_showModal({
		url: lnk,
		iconCls:"icon-w-paper",
		title: '留观患者床位转移',
		closed: true,
		onClose:function(){}
	});
	return;
}

function parentFlash(){
	showSetBtn();
}

//hxy 2020-02-20
function setCellLabel(value,row,index){
	if(value=="1级"){value="Ⅰ级";}
	if(value=="2级"){value="Ⅱ级";}
	if(value=="3级"){value="Ⅲ级";}
	if(value=="4级"){value="Ⅳa级";}
	if(value=="5级"){value="Ⅳb级";}
	return value;
}