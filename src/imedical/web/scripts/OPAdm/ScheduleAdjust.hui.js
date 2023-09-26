var PageLogicObj={
	m_searchStr:"",
	m_TalStartDate:"",
	m_ComboJsonCSP:'./dhcdoc.cure.query.combo.easyui.csp',
	m_GridJsonCSP:'./dhcdoc.cure.query.grid.easyui.csp',
	dw:$(window).width()-200,
	dh:$(window).height()-100,
	m_tabAppQtyListDataGrid:"",
	m_EditRow:-1,
	m_CopyScheduleASRowIDStr:"",
	m_tabTRAppMethodInfoNewRows:new Array(),
	m_PreSelExamRowid:""
}
/// ColorSynopsis对象 用于界面右上角颜色说明 --yl
var ColorSynopsis={
	"pink":"停诊",
	"#99CC33":"替诊",
	"#FF9999":"被替诊",
	"purple":"不规则排班"
}
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
})
$(window).load(function() {
    if (ServerObj.sysDateFormat==3){
	    new Kalendae.Input("AdmDate", {
		    format: 'YYYY-MM-DD',
            mode:'multiple'
        });
        new Kalendae.Input("CopyToDate", {
		    format: 'YYYY-MM-DD',
            mode:'multiple'
        });
        new Kalendae.Input("CopyToDate1", {
		    format: 'YYYY-MM-DD',
            mode:'multiple'
        });
	}else{
		new Kalendae.Input("AdmDate", {
		    format: 'DD/MM/YYYY',
            mode:'multiple'
        });
         new Kalendae.Input("CopyToDate", {
		    format: 'DD/MM/YYYY',
            mode:'multiple'
        });
        new Kalendae.Input("CopyToDate1", {
		    format: 'DD/MM/YYYY',
            mode:'multiple'
        });
	}
});
function Init(){
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		$(".tabItem_badge").remove();
		$("#SerchLoc,#SerchDoc").searchbox('setValue',"");
		InitLocDocTree(FindClickHandle);
		InitWinCombo();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitLocDocTree();
		InitScheduleTab('');
		InitWinCombo();
		AddColorSynopsis()
	}
}
function InitEvent(){
	$(".searchbox-text").keyup(function(){ 
		setTimeout(function(){
			findLocData(); 
		},50)
	});
	/*$("#TRFlag").checkbox({
		onCheckChange:function(e,value){
            TRFlag_Click();
			Calc_TRInfo();
        }
	});*/
	$("#PlanSchedule").checkbox({
		onCheckChange:function(e,value){
			PlanScheduleCheckChg();
		}
	})
    $("#Find").click(FindClickHandle);
	$("#BSave").click(SaveClickHandle);
	$("#StopSave").click(StopClickHandle);
	$("#ReplaceSave").click(ReplaceSave);
	$("#CopyOneSchedule").on("click", function(){CopyScheduleSave("ONE")});
	$("#CopyMulSchedule").on("click", function(){CopyScheduleSave("MUL")});
	$("#TRLength").change(TRLengthChange);
	$('#BTRGen').click(TRGenClick);
	$('#BTRTempSave').click(TRTempSaveClick);
	$('#TRTemp').singleCombo({
        valueField:'ID',   
        textField:'Name',
        ClassName:'DHCDoc.OPAdm.TimeRangeTemp',
        QueryName:'QueryTemp',
        loadFilter:function(data){
            for(var i=0;i<data.length;i++){
                data[i].Name=data[i].TimeRange+"-"+data[i].Name;
            }
            return data;
        },
        onBeforeLoad:function(param){
            param.TRRowid=GetElementValue('TimeRange');
            param.SumLoad=$("#PositiveMax").numberbox('getValue'); 	
            param.HospID=$HUI.combogrid('#_HospUserList').getValue();
        }
    });
	$('#TRGenWin').window({onOpen:function(){$('#TRTemp').combobox('setValue','').combobox('reload');}});
	document.onkeydown = Doc_OnKeyDown;
}
function FindClickHandle(){
	var StartDate=$("#StartDate").datebox("getValue"); 
    var tabs = $("#ScheduleTab").tabs("tabs");
    $('#ScheduleTab').tabs({
		onSelect:function (){
		}
	})
	var length = tabs.length;
	for(var i = 0; i < length; i++) {
	    var onetab = tabs[0];
	    var title = onetab.panel('options').tab.text();
	    $("#ScheduleTab").tabs("close", title);
	}
	InitScheduleTab(StartDate) ;
}
function Doc_OnKeyDown(e){
	//防止在空白处敲退格键，界面自动回退到上一个界面
   if (!websys_cancelBackspace(e)) return false;
	//浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;   
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }  
}

function PageHandle(){
}
function InitLocDocTree(callBack){
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	var url = "dhcrbapptschedulequeryrequest.csp?pid=0&userid="+session['LOGON.USERID']+"&groupid="+session['LOGON.GROUPID']+"&HospId="+HospID ;
	$("#LocDocTree").tree({
		url:url,
		multiple:true,
		lines:true,
		onBeforeExpand:function(node,param){
			var url = $("#LocDocTree").tree('options').url = "dhcrbapptschedulequeryrequest.csp?pid="+node.id+"&action=appt"+"&userid="+session['LOGON.USERID']+"&groupid="+session['LOGON.GROUPID']+"&docdesc="+$.trim($('#SerchDoc').searchbox('getValue'))+"&HospId="+HospID ;
			$('#LocDocTree').tree('options').url =encodeURI(url);
		}, 
		onSelect:function(node){
			var id=node.id
			var idArr=id.split("^")
			if(idArr[0]=="Loc"){
				var LocRowid=idArr[1]
					var parentNode=$("#LocDocTree").tree("getParent",node.target) ;
					if (parentNode){
						var parentNodeid=parentNode.id ;
						var parentNodeidArr=parentNodeid.split("^")
						var ExaRowid=parentNodeidArr[1];
					}else{
						var ExaRowid=idArr[2];
					}
                    GetASRoomData(ExaRowid);
					FindScheduleByLoc(LocRowid,"",ExaRowid)
			}else if (idArr[0]=="Doc"){
				    var DocRowid=idArr[1];
					var parentNode=$("#LocDocTree").tree("getParent",node.target) ;
					var parentNodeid=parentNode.id ;
					var parentNodeidArr=parentNodeid.split("^")
					var LocRowid=parentNodeidArr[1];
				    FindScheduleByLoc(LocRowid,DocRowid,"");
				    var grandPaNode = $("#LocDocTree").tree("getParent",parentNode.target);
				    if (grandPaNode){
					    var grandPaNodeid=grandPaNode.id ;
						var grandPaNodeidArr=grandPaNodeid.split("^");
						ExaRowid=grandPaNodeidArr[1];
					}else{
						ExaRowid=parentNodeidArr[2];
					}
				    GetASRoomData(ExaRowid);
			}else{
				var ExaRowid=idArr[1] ;
				FindScheduleByLoc("","",ExaRowid)
				GetASRoomData(ExaRowid);
			}
		},
		onLoadSuccess:function(node, data){
			if (callBack) callBack();
		}
	}); 
}
function InitScheduleTab(StartDate){
	var AdmDateStr=tkMakeServerCall("web.DHCApptScheduleNew","GetAdmDateStr",StartDate)
	var AdmDateStrArr=AdmDateStr.split("^")
	for(var i=0;i<AdmDateStrArr.length;i++){
		var admDate=AdmDateStrArr[i].split(String.fromCharCode(1))[0]
		$("#ScheduleTab").tabs("add",{
			title:admDate,
			content:'Tab Body'
		})
	}
	$('#ScheduleTab').tabs({
		heigth:'auto',
		onSelect: function(title,index){
			var CurrentTabPanel=$('#ScheduleTab').tabs("getSelected");
			var selDataObj=GetLocDocTreeSel();
			var LocRowid=selDataObj.LocRowid;
			var ExaRowid=selDataObj.ExaRowid;
			var DocRowid=selDataObj.DocRowid;
			var TemplateTable=$('<div><table id="ScheduleGrid'+index+'"></table></div>');
			CurrentTabPanel.html(TemplateTable);
			var StartDate=title.split("(")[0]
			PageLogicObj.m_TalStartDate=StartDate ;
			InitScheduleGrid("ScheduleGrid"+index,CurrentTabPanel.height());
			if(LocRowid!=""){
				setTimeout("ScheduleGridLoad('ScheduleGrid"+index+"','"+StartDate+"','"+LocRowid+"','"+DocRowid+"','"+ExaRowid+"')",500)
				return
			}
			if(ExaRowid!=""){
				setTimeout("ScheduleGridLoad('ScheduleGrid"+index+"','"+StartDate+"','"+''+"','','"+ExaRowid+"')",500)
				return
			}
			setTimeout("ScheduleGridLoad('ScheduleGrid"+index+"','"+StartDate+"','"+LocRowid+"','','')",500)
		}
	})
	$("#ScheduleTab").tabs("select",0)
}
function InitScheduleGrid(GridId,height){
	$("#MoreMulit").remove();
	$("#"+GridId).datagrid({
		border:false,
		remoteSort:false,
		width:$(window).width()-290, //258
		striped:true,
		autoRowHeight:false,
		fitColumns : false,
		url:'',
		height:height,
		loadMsg:'正在加载',
		rownumbers:true,
		idField:"ASRowId",
		columns:[[
			{field:'check',title:'',width:120,align:'center',checkbox:true},
			{field:'ASRowId',title:'ASRowId',width:10,hidden:true},
			{field:'LocDesc',title:'出诊科室',width:150,sortable:true},
			{field:'DocDesc',title:'出诊医生',width:100,sortable:true,  
                formatter:function(value,rec){ 
                   var btn = '<a class="editcls" onclick="ApptUpDateLogShow(\'' + rec.ASRowId + '\')">'+value+'</a>';
			       return btn;
                }
            },
            {field:'ASRoom',title:'诊室名称',width:120,sortable:true},
			{field:'ASSessionType',title:'职称',width:100,sortable:true},
			{field:'TimeRange',title:'午别',width:60,sortable:true},
			{field:'ASSessStartTime',title:'开始时间',width:70},
			{field:'ASSessionEndTime',title:'结束时间',width:70},
			{field:'ASLoad',title:'挂号限额',width:70},
			{field:'ASAppLoad',title:'预约限额',width:70},
			{field:'AppStartSeqNo',title:'预约起始号',width:80},
			{field:'ASAddLoad',title:'加号限额',width:70},
			{field:'ASQueueNoCount',title:'合计限额',width:70},
			{field:'RegisterNum',title:'已挂号数',width:70},
			{field:'AppedNum',title:'已预约数',width:70,
			   formatter:function(value,rec){ 
                   var btn = '<a class="editcls" onclick="AppedDataShow(\'' + rec.ASRowId + '\')">'+value+'</a>';
			       return btn;
                }
			},
			{field:'AppedArriveNum',title:'已取号数',width:60},
			{field:'QueueNO',title:'剩号',width:60},
			{field:'ASStatus',title:'状态',width:40,sortable:true
			},
			{field:'ASAuditStatus',title:'排班审批状态',width:140,sortable:true
			},
			{field:'ASAuditStatusAgain',title:'排班再次审批',width:140, 
				formatter:function(value,rec){ 
				   if ((rec.ASAuditStatus.indexOf("已拒绝")>=0)||(rec.ASAuditStatus.indexOf("已撤销")>=0)){
                   var btn = '<a class="editcls" onclick="AuditStatusAgain(\'' + rec.ASRowId + '\')">再次提交审批</a>';
			       return btn;}else{return "";}
                }
			},
			{field:'ReferralUser',title:'替诊人',width:80},
			{field:'ASReason',title:'停替诊原因',width:80},
			{field:'IrregularFlag',title:'异常',width:40}
		]],
		rowStyler:function(index,row){
			if (row.ASStatus=="停诊"){
				return 'background-color:pink;color:blue;';
			}
			if (row.ASStatus=="替诊"){
				return 'background-color:#99CC33;';
			}
			if (row.ASStatus=="被替诊"){
				return 'background-color:#FF9999;';
			}if(row.IrregularFlag=="A"){
				//不规则排班
				return 'background-color:purple;color:white;';
			}
		},
		toolbar :[
			{	
				text: '新增排班',
	            iconCls: 'icon-add',
	            handler: function() {
					SetElementValue("tabAppMethodInfo",[]);
					SetElementValue("tabTRInfo",[]);
					EditAppSchedule("");
					$("#EditWin").window('setTitle','新增排班');
				}
			},{	
				text: '修改单个排班',
	            iconCls: 'icon-write-order',
	            handler: function() {
		            SetElementValue("tabAppMethodInfo",[]);
					SetElementValue("tabTRInfo",[]);
		            UpdateOneSchedule();
				}
			},'-',{	
				text: '复制单个排班',
	            iconCls: 'icon-copy',
	            handler: function() {
		            CopySchedule("ONE");
				}
			},{	
				text: '批量复制排班',
	            iconCls: 'icon-copy',
	            handler: function() {
					CopySchedule("MUL");
				}
			},'-',{	
				text: '替诊',
	            iconCls: 'icon-replace-order',
	            handler: function() {
					ReplaceAppSchedule();
				}
			},'-',{	
				text: '停诊',
	            iconCls: 'icon-abort-order',
	            handler: function() {
					StopAppSchedule();
				}
			},{	
				text: '撤消停诊',
	            iconCls: 'icon-cancel-order',
	            handler: function() {
					CancelStopAppSchedule();
				}
			},'-',{
				text:"更多",
       			id:"MoreMulit"
   			}
		],

		onDblClickRow:function(rowIndex,rowData){
			if (PageLogicObj.m_tabAppQtyListDataGrid==""){
				//PageLogicObj.m_tabAppQtyListDataGrid=InitAppQtyList();
				InitAppMethodGrid();
				InitTRDataGrid();
			}
			EditAppSchedule(rowData.ASRowId);
			LoadApptabAppMethodInfo(rowData.ASRowId)
			LoadtabTRInfo(rowData.ASRowId)
			$("#EditWin").window('setTitle','修改排班 <font color="yellow">'+rowData['LocDesc']+ ' ' +rowData['DocDesc']+'</font>');
		},
		onLoadSuccess:function(data){
			UpdateScheTabStyle(GridId);
		}
	});
	$.ajax("opadm.scheduleadjust.morebtn.csp ", {
		"type" : "GET",
		"dataType" : "html",
		"async": false,
		"success" : function(data, textStatus) {
			$("#MoreMulit_toolbar").remove();
			$("#MoreMulit").append(data);
			$HUI.menubutton($("#MoreMulit_toolbar a"),{});
    		$('#MoreMulit').find("span").eq(0).css("display","none"); 
		}
	});
	$("#ThisWeek,#NextWeek,#OneStopNo").unbind('click');
    $("#ThisWeek").click(function ThisWeek(){
	    var StartDate=GetDateStr(0) ;
        StartDate=tkMakeServerCall("web.DHCApptScheduleNew","GetMonday",StartDate);   // 从周一开始计算
        $("#StartDate").datebox("setValue",StartDate); 
		$('#ScheduleTab').tabs({
			onSelect:function (){
			}
		})
	 	var tabs = $("#ScheduleTab").tabs("tabs");
		var length = tabs.length;
		for(var i = 0; i < length; i++) {
		    var onetab = tabs[0];
		    var title = onetab.panel('options').tab.text();
		    $("#ScheduleTab").tabs("close", title);
		}
		InitScheduleTab(StartDate) ;
	 })
    $("#NextWeek").click(function NextWeek(){
	    var StartDate=GetDateStr(7);
        StartDate=tkMakeServerCall("web.DHCApptScheduleNew","GetMonday",StartDate);	 // 从周一开始计算
        $("#StartDate").datebox("setValue",StartDate); 
		$('#ScheduleTab').tabs({
			onSelect:function (){
			}
		})
	 	var tabs = $("#ScheduleTab").tabs("tabs");
		var length = tabs.length;
		for(var i = 0; i < length; i++) {
		    var onetab = tabs[0];
		    var title = onetab.panel('options').tab.text();
		    $("#ScheduleTab").tabs("close", title);
		}
		InitScheduleTab(StartDate) ;
    })
	$("#OneStopNo").click(function OneStopNo(){
    	StopQueueNo();
    })
}
function ScheduleGridLoad(GridId,StartDate,LocRowid,DocRowid,ExaRowid){
	$("#"+GridId).datagrid("unselectAll");
	var PlanScheduleFlag=$HUI.checkbox('#PlanSchedule').getValue();
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCApptScheduleNew';
	queryParams.QueryName ='GetApptSchedule';
	queryParams.Arg1 =LocRowid;
	queryParams.Arg2 =DocRowid;
	queryParams.Arg3 =StartDate;
	queryParams.Arg4 =StartDate;
	queryParams.Arg5 =session['LOGON.USERID'];
	queryParams.Arg6 =session['LOGON.GROUPID'];
	queryParams.Arg7 ="";	// 资源ID
	queryParams.Arg8 =ExaRowid;
	queryParams.Arg9 ="";
	queryParams.Arg10 =0;
	queryParams.Arg11 =PlanScheduleFlag;
	queryParams.Arg12 ="";
	queryParams.Arg13 ="";
	queryParams.Arg14 =$HUI.combogrid('#_HospUserList').getValue();
	
	queryParams.ArgCnt = 14;
	var opts = $("#"+GridId).datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	$("#"+GridId).datagrid('load', queryParams); 
}
function FindScheduleByLoc(LocRowId,DocrowId,ExaRowId){
	var tab=$('#ScheduleTab').tabs("getSelected");
	var opts=tab.panel("options")
	var index = $('#ScheduleTab').tabs('getTabIndex',tab);
	var title=opts.title
	var StartDate=title.split("(")[0]
	ScheduleGridLoad("ScheduleGrid"+index,StartDate,LocRowId,DocrowId,ExaRowId)
}
function ApptUpDateLogShow(ASRowId){
	websys_showModal({
		url:"DHCApptSchedule.UpdateLog.hui.csp?vRBASID="+ASRowId+"&HospID="+$HUI.combogrid('#_HospUserList').getValue(),
		title:'排班修改日志',
		width:'90%',height:'90%',
		GetHospId:function(){
			return $HUI.combogrid('#_HospUserList').getValue();
		}
	})
}
function AppedDataShow(ASRowId){
	websys_showModal({
		url:"opadm.appcancel.hui.csp?vRBASID="+ASRowId,
		title:'预约记录',
		width:'90%',height:'90%'
	})
}
function GetDateStr(AddDayCount) { 
	var dd = new Date(); 
	dd.setDate(dd.getDate()+AddDayCount);//获取AddDayCount天后的日期 
	var y = dd.getFullYear(); 
	var m = dd.getMonth()+1;//获取当前月份的日期 
	if (Number(m)<10) m="0"+m
	var d = dd.getDate(); 
	if (Number(d)<10) d="0"+d
	if (ServerObj.sysDateFormat==3){
		return y+"-"+m+"-"+d; 
	}
	if (ServerObj.sysDateFormat==4){
		return d+"/"+m+"/"+y; 
	}
} 
function GetASRoomData(ERowid){
	ASRoomData =eval('(' + tkMakeServerCall("web.DhcResEffDateSessionClass","GetConsultingRoomByBoruID",ERowid) + ')'); 
}
function findLocData(){
	var PyCode=$.trim($($(".searchbox-text")[0]).val());
	var DocCode=$.trim($($(".searchbox-text")[1]).val());
	var HospID=$HUI.combogrid('#_HospUserList').getValue();
	var url = $("#LocDocTree").tree('options').url = "dhcrbapptschedulequeryrequest.csp?pid=0"+"&desc="+PyCode+"&userid="+session['LOGON.USERID']+"&groupid="+session['LOGON.GROUPID']+"&docdesc="+DocCode+"&HospId="+HospID ; 
	$('#LocDocTree').tree('options').url =encodeURI(url);
	$(LocDocTree).tree('reload');
}
function EditAppSchedule(ASRowId){
	$("#tips").html("");
	var selDataObj=GetLocDocTreeSel();
	var selExamRowId=selDataObj.ExaRowid;
	var selLocRowId=selDataObj.LocRowid;
	var selLocDesc=selDataObj.LocDesc;
	var selDocRowId=selDataObj.DocRowid;
	var selDocDesc=selDataObj.DocDesc;
	var reloadLocComFlag=false;
	if (selExamRowId!=PageLogicObj.m_PreSelExamRowid) {
		reloadLocComFlag=true;
		PageLogicObj.m_PreSelExamRowid=selExamRowId;
	}
	ClearWinData();
	if (((selLocRowId=="")&&(selDocRowId==""))||(reloadLocComFlag)){
		LoadAdmLoc("",selExamRowId);
		$("#AdmDoc").combobox("loadData",[]);
	}
	if (ASRowId!=""){
		InitWinInfo(ASRowId);
		var GroupDesc=session['LOGON.GROUPDESC'];
		var CTLOCID=session['LOGON.CTLOCID'];
		LimitCombo('disable');
		LimitText(true);
	}else{
		
		if (selLocRowId!=""){
			LoadClinicGroup(selLocRowId)
		}
		setTimeout(function(){
			LimitCombo('enable')
			LimitText(false)
			$("#AdmLoc").combobox("select", selLocRowId);
			$("#AdmDoc").combobox("setValue", selDocRowId);
	        if(selDocRowId!=""){
		        var sessTypeDr = tkMakeServerCall("web.DhcResEffDateSessionClass","GetSessTypeByDocId",selDocRowId,selLocRowId);
				if(sessTypeDr != ""){
					$("#DocSession").combobox("select",sessTypeDr.toString());
				}
				var ret=tkMakeServerCall("web.DHCApptScheduleNew","GetDocResource",selLocRowId,selDocRowId);
				if (ret!=""){
					var Arr1=ret.split("$")[0];
					var Arr2=ret.split("$")[1];
					var Arr3=ret.split("$")[2];
					var Arr=Arr1.split("^");	
					$("#PositiveMax").numberbox('setValue',Arr[2]);
					//$("#ApptMax").numberbox('setValue',Arr[3]);
					if(Arr.length>=18){
					    $("#ClinicGroup").combobox('select',Arr[18]);
					}else{
						$("#ClinicGroup").combobox("select", "");
					}
					//$("#EStartPrefix").numberbox('setValue',Arr[4]);
					$("#AddtionMax").numberbox('setValue',Arr[5]);
					if(Arr3!=""){
						var TRInfoArr=Arr3.split("^");
						var TRFlag=TRInfoArr[0];
						var TRStTime=TRInfoArr[1];
						var TREnTime=TRInfoArr[2];
						var TRLenghth=TRInfoArr[3];
						var TRSDHS=TRInfoArr[4];
						var TRRegNumStr=TRInfoArr[5];
						var TRRegInfoStr=TRInfoArr[6];
						if(TRFlag=="Y"){
							$("#TRFlag").checkbox('check');	
							$("#TRLength").numberbox('setValue',TRLenghth); 
							$("#TRRegNum").numberbox('setValue',TRSDHS);  
							$("#TRSartTime").timespinner('setValue',TRStTime);
							$("#TREndTime").timespinner('setValue',TREnTime);
							$("#TRRegNumStr").val(TRRegNumStr);
							$("#TRRegInfoStr").val(TRRegInfoStr);
						}else{
							$("#TRFlag").checkbox('uncheck');	
							$("#TRLength,#TRRegNum").numberbox('setValue',"");
							$("#TRSartTime,#TREndTime").timespinner('setValue',"");
							$("#TRRegNumStr,#TRRegInfoStr").val("");
						}
					}else{
						$("#TRFlag").checkbox('uncheck');	
						$("#TRLength,#TRRegNum").numberbox('setValue',"");
						$("#TRSartTime,#TREndTime").timespinner('setValue',"");
						$("#TRRegNumStr,#TRRegInfoStr").val("");	
					}
				}
		    }
		    TRFlag_Click();
		},500)	
	}
	$("#EditWin").window("open")
}
function ClearWinData(){
	$("#ASRowID").val('');
	$("#AdmDate").val(PageLogicObj.m_TalStartDate);
	//$("#AdmDate").datebox("setValue",PageLogicObj.m_TalStartDate);  
	$("#AdmLoc,#LocArea,#TimeRange,#AdmDoc,#DocSession,#ClinicGroup").combobox("setValue","");
	$('#StartTime,#EndTime,#TRSartTime,#TREndTime').timespinner('setValue','');
	$("#PositiveMax,#ApptMax,#AddtionMax").numberbox('setValue','');
	$("#TRRegNum,#TRRegNumStr,#TRRegInfoStr,#EStartPrefix").val('');
	$("#TRFlag,#StopRegNoFlag").checkbox('uncheck'); //,#EChkStop
	if (PageLogicObj.m_tabAppQtyListDataGrid!=""){
		$('#tabAppQtyList').datagrid('loadData',{"total":0,"rows":[]});
	}
 }
 function InitWinInfo(ASRowId){
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCRBApptSchedule';
	queryParams.QueryName ='ApptScheduleListQuery';
	queryParams.Arg1 ="";
	queryParams.Arg2 ="";
	queryParams.Arg3 ="";
	queryParams.Arg4 ="";
	queryParams.Arg5 =ASRowId;
	queryParams.Arg6 ="";
	queryParams.ArgCnt = 6;
	$.ajax({
	   type: 'POST',
	   url: "./dhcdoc.cure.query.grid.easyui.csp",
	   data: queryParams,
	   dataType: 'json',
	   async: true,
	   success: function(data, textStatus, jqXHR){
		    $("#ASRowID").val(data.rows[0].ID);
		    $("#AdmLoc").combobox("select", data.rows[0].LocationID);
			setTimeout(function(){
				$("#LocArea").combobox("setValue", data.rows[0].RoomID);
				$("#TimeRange").combobox("setValue", data.rows[0].SessionTimeID);
				$("#AdmDoc").combobox("setValue", data.rows[0].DoctorID);
				$("#DocSession").combobox("setValue", data.rows[0].SessionTypeDr);
				//$("#ClinicGroup").combobox("setValue", data.rows[0].SessionClinicGroupDr);
				var SessionClinicGroupDrStr=data.rows[0].SessionClinicGroupDrStr;
				if((SessionClinicGroupDrStr!="")&&(typeof(SessionClinicGroupDrStr)!="undefined")){
					$("#ClinicGroup").combobox("setValues", SessionClinicGroupDrStr.split(","));
				}else{
					$("#ClinicGroup").combobox("setValue","");
				}
				if (data.rows[0].ScheduleDate!=""){
					var AdmDate=formatdate(data.rows[0].ScheduleDate); 
					//$("#AdmDate").datebox("setValue",AdmDate);  
					$("#AdmDate").val(AdmDate);
				}
				$('#StartTime').timespinner('setValue',data.rows[0].SessionStartTime);
				$('#EndTime').timespinner('setValue',data.rows[0].SessEndTime);
				$('#PositiveMax').numberbox('setValue',data.rows[0].TotalNum);
				$('#ApptMax').numberbox('setValue',data.rows[0].BookNum);
				$('#AddtionMax').numberbox('setValue',data.rows[0].OverBookNum);
				$("#EStartPrefix").numberbox('setValue',data.rows[0].AppStartNo);
				if (data.rows[0].TRInfo!="") {
					var TRInfoNum=data.rows[0].TRInfo.split("^") ;
					var ASTimeRangeFlag=TRInfoNum[0];
					var TRSartTime=formattime(TRInfoNum[1]);
					var TREndTime=formattime(TRInfoNum[2]);
					var TRLength=TRInfoNum[3];
					var TRRegNum=TRInfoNum[4];
					var TRRegNumStr=TRInfoNum[5];
					var TRRegInfoStr=TRInfoNum[6];
					var StopRegNoFlag=TRInfoNum[8];
	                if (ASTimeRangeFlag=="Y"){
		                $("#TRFlag").checkbox('check');
		            }else{
			            $("#TRFlag").checkbox('uncheck');
			        }
			        if (StopRegNoFlag=="Y"){
		                $("#StopRegNoFlag").checkbox('check');
		            }else{
			            $("#StopRegNoFlag").checkbox('uncheck');
			        }
			        $('#TRLength').numberbox('setValue',TRLength);
					$('#TRSartTime').timespinner('setValue',TRSartTime);
					$('#TREndTime').timespinner('setValue',TREndTime);
					$('#TRRegNum').numberbox('setValue',TRRegNum);
					$('#TRRegNumStr').val(TRRegNumStr);
					$('#TRRegInfoStr').val(TRRegInfoStr);
					if ((TRSartTime=="")||(TREndTime=="")){
						TRTimeRangeClick();
					}
				}
			},500);
	   },
	   error: function(XMLHttpRequest, textStatus, errorThrown){
			alert(textStatus+"("+errorThrown+")");
	   }
	}); 
	$('#tabAppQtyList').datagrid('load',{
		ClassName:'web.DHCRBApptScheduleAppQty',
		QueryName:'FindAppQty',
		Arg1:ASRowId,
		ArgCnt:1
	});
 }
 function TRTimeRangeClick(){
	 if($("#TRFlag").checkbox('getValue')){
		 var SessTimeStart=$("#StartTime").val();
		 var SessTimeEnd=$("#EndTime").val();
		 $('#TRSartTime').timespinner('setValue',SessTimeStart);
		 $('#TREndTime').timespinner('setValue',SessTimeEnd);
	 }
 }
function LimitCombo(flag){
	if (flag=="disable") {
		$("#AdmDate").prop("disabled",true);
	}else{
		$("#AdmDate").prop("disabled",false);
	}
	//$("#AdmDate").datebox(flag); 
	$('#AdmLoc,#TimeRange,#AdmDoc,#DocSession').combobox(flag);
}
function LimitText(flag) {
	if (flag){
		$('#TRSartTime,#TREndTime').timespinner("disable");
		//$('#ApptMax,#TRLength,#TRRegNum').numberbox('disable');
	}else{
		//$('#ApptMax,#TRLength,#TRRegNum').numberbox('enable');
	}
	$("#TRRegNumStr,#TRRegInfoStr").attr("disabled",flag);
	//预约限额、预约起始号 根据预约机构限额和起始号反算得到
	//$("#ApptMax,#EStartPrefix").attr("disabled",true);
}
function LoadAdmLoc(q,selExamRowId){
	if (typeof selExamRowId=="undefined"){
		selExamRowId=""
	}
	var desc=q;
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCApptScheduleNew';
	queryParams.QueryName ='FindLoc'; 
	queryParams.Arg1 =desc;
	queryParams.Arg2 =session['LOGON.USERID'];
	queryParams.Arg3 =session['LOGON.GROUPID'];
	queryParams.Arg4 =selExamRowId
	queryParams.Arg5 =$HUI.combogrid('#_HospUserList').getValue();
	queryParams.ArgCnt =5;
	InitComboData('#AdmLoc',queryParams)
}
function InitComboData(ComboID,queryParams){
	var jQueryComboObj = $(ComboID);
	var url=PageLogicObj.m_ComboJsonCSP;
	for ( var oe in queryParams) {
		if (url.indexOf("?")>=0){
			url=url+"&"+oe+"="+queryParams[oe];
		}else{
			url=url+"?"+oe+"="+queryParams[oe];
		}
	}
	jQueryComboObj.combobox('reload',url);
}
function InitSingleCombo(id,valueField,textField,ClassName,Query,exp,multipleField){
	if((typeof(multipleField)=="undefined")||(multipleField=="")){
		multipleField=false
	}
	if (ClassName!=""){
		var url=PageLogicObj.m_ComboJsonCSP+'?ClassName='+ClassName+'&QueryName='+Query+exp;
	}else{
		var url=PageLogicObj.m_ComboJsonCSP;
	}
	var ComboObj={
		editable:true,
		panelHeight:200,
		multiple:multipleField,
		mode:"local",
		method: "GET",
		selectOnNavigation:true,
	  	valueField:valueField,   
	  	textField:textField,
	  	url:url,
	  	filter: function(q, row){
			var opts = $(this).combobox('options');
			if (row['code']){
				return (row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row['code'].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			}else{
				return (row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			}
		}
	};
	if(id=="AdmLoc"){
		$.extend(ComboObj,{
			onSelect:function(record){
				if (record!=undefined){
					 $("#LocArea,#AdmDoc").combobox("select","");
					 $("#ClinicGroup").combobox("setValue","");
					 LoadClinicGroup(record.RowId);
					 LoadAdmDoc(record.RowId);
					 LoadLocArea("");
				}
			},
			onLoadSuccess:function(data){
				var CurrentOrdName=$('#AdmLoc').combobox('getValue');
				if(CurrentOrdName!=""){
					var CheckValue=/^\d+$/;
					if (CheckValue.test(CurrentOrdName)){
						$('#AdmLoc').combogrid("setValue","");
						$('#AdmLoc').combo("setText", "")
					}
				}
				$('#AdmLoc').next('span').find('input').focus();
			}
		});
	}else if(id=="AdmDoc"){
		$.extend(ComboObj,{
			onSelect:function(record){
				if (record!=undefined) { 
					var sessTypeDr = tkMakeServerCall("web.DhcResEffDateSessionClass","GetSessTypeByDocId",record.RowId,$("#AdmLoc").combobox("getValue"));
					if(sessTypeDr != ""){
						$("#DocSession").combobox("select",sessTypeDr.toString());
					}
				    DocSelectFun();
				}
			}
		});
	}else if(id=="ERepDoc"){ 
		$.extend(ComboObj,{
			onSelect:function(record){
				if (record!=undefined){
					 var sessTypeDr = tkMakeServerCall("web.DhcResEffDateSessionClass","GetSessTypeByDocId",record.RowId,$("#ERepLoc").combobox("getValue"));
					 if(sessTypeDr != ""){
						$("#ERepSessionType").combobox("select",sessTypeDr.toString());
					 }
				}
			}
		});
	}else if(id=="ERepLoc"){ 
		$.extend(ComboObj,{
			onSelect:function(record){
				if (record!=undefined){
					 $("#ERepDoc").combobox("select","");
					 LoadERepDoc("");
				}
			}
		});
	}else if(id=="ERepLeader"){
		$.extend(ComboObj,{
			/*onSelect:function(record){
				if (record!=undefined){
					if (record['RowId']==session['LOGON.USERID']){
						$("#ERepPassword,#td-ERepPassword").hide();
					}else{
						$("#ERepPassword,#td-ERepPassword").show();
						$("#ERepPassword").focus();
					}
		 			$("#ERepPassword").val('');
	 			}
			}*/
			onHidePanel:function(){
				var ERepLeaderId=getValue('ERepLeader');	
				if (ERepLeaderId){
					if (ERepLeaderId==session['LOGON.USERID']){
						$("#ERepPassword,#td-ERepPassword").hide();
					}else{
						$("#ERepPassword,#td-ERepPassword").show();
						$("#ERepPassword").focus();
					}
		 			$("#ERepPassword").val('');
		 		}
			},
			mode:"remote",
			onBeforeLoad:function(param){
				if(!param.q){$(this).combobox('loadData',[])};
				if(!param.q) return false;
				if(param.q.length<1) return false;
				param.Arg1='';
				param.Arg2=param.q;
				param.Arg3=$HUI.combogrid('#_HospUserList').getValue();;
				param.ArgCnt=3;
			}
		});
	}else if(id=="ELeader"){
		$.extend(ComboObj,{
			onHidePanel:function(){
				var ELeaderId=getValue('ELeader');	
				if (ELeaderId){
					if (ELeaderId==session['LOGON.USERID']){
						$("#EPassword,#tr-EPassword").hide();
					}else{
						$("#EPassword,#tr-EPassword").show();
						$("#EPassword").focus();
					}
		 			$("#EPassword").val('');
		 		}
			},
			mode:"remote",
			onBeforeLoad:function(param){
				if(!param.q){$(this).combobox('loadData',[])};
				if(!param.q) return false;
				if(param.q.length<1) return false;
				param.Arg1='';
				param.Arg2=param.q;
				param.Arg3=$HUI.combogrid('#_HospUserList').getValue();;
				param.ArgCnt=3;
			}
		});
	}else if(id=="Zone_Search"){
		$.extend(ComboObj,{
			onSelect:function(record){
				SetLocList(record.rowid,"Loc_Search");
				SetDocList("","Doc_Search");
				$('#ScheduleTemplateList').datagrid('reload');
			}
		});
	}else if(id=="TimeRange"){
		$.extend(ComboObj,{
			editable:false,
			onSelect:function(record){
				if (record!=undefined) { 
				    DocSelectFun()
					var ret=tkMakeServerCall("web.DHCRBResSession","GetTRTimeStrByRowId",record.RowId);
					var Arr=ret.split("^");
					var SessTimeStart=Arr[0];
					var SessTimeEnd=Arr[1];
					$('#StartTime').timespinner('setValue',SessTimeStart);
					$('#EndTime').timespinner('setValue',SessTimeEnd);
					$('#TRSartTime').timespinner('setValue',SessTimeStart);
					$('#TREndTime').timespinner('setValue',SessTimeEnd);
				}
			}
		});
	}else if(id=="ClinicGroup"){
		$.extend(ComboObj,{
			rowStyle:'checkbox', //显示成勾选行形式
			selectOnNavigation:false,
			editable:false,
		});
	}
	$("#"+id).combobox(ComboObj);
}

///排班修改窗口初始化
function InitWinCombo(){
	var HospitalDr=$HUI.combogrid('#_HospUserList').getValue();
	InitSingleCombo('AdmLoc','RowId','LocDesc','web.DHCApptScheduleNew','FindLoc',"&Arg1=&Arg2="+session['LOGON.USERID']+"&Arg3="+session['LOGON.GROUPID']+"&Arg4=&Arg5="+HospitalDr+"&ArgCnt=5");
	InitSingleCombo('LocArea','RowId','Desc','','',"");//'web.DHCApptScheduleNew','LookUpRoomByUserNew'
	InitSingleCombo('AdmDoc','RowId','Desc','','',"");//'web.DHCApptScheduleNew','FinNoRegDoc'
	InitSingleCombo('ClinicGroup','CLGRPRowId','CLGRPDesc','','',"",true);
	InitSingleCombo('TimeRange','RowId','Desc','web.DHCApptScheduleNew','LookUpTimeRange',"&Arg1="+ServerObj.CurrDate.split("^")[0]+"&Arg2="+HospitalDr+"&ArgCnt=2");	
	InitSingleCombo('DocSession','ID','Desc','web.DHCBL.BaseReg.BaseDataQuery','RBCSessionTypeQuery',"&Arg1="+HospitalDr+"&ArgCnt=1");
    InitSingleCombo('EReason','RowId','Desc','web.DHCApptScheduleNew','LookUpReasonNotAvail',"&Arg1="+ServerObj.CurrDate.split("^")[0]+"&ArgCnt=1");
	InitSingleCombo('ELeader','RowId','Desc','web.DHCApptScheduleNew','LookUpELeaderNew',"");
	
	InitSingleCombo('ERepSessionType','ID','Desc','web.DHCBL.BaseReg.BaseDataQuery','RBCSessionTypeQuery',"&Arg1="+HospitalDr+"&ArgCnt=1");
	InitSingleCombo('ERepReason','RowId','Desc','web.DHCApptScheduleNew','LookUpReasonNotAvail',"&Arg1="+ServerObj.CurrDate.split("^")[0]+"&ArgCnt=1");	
	InitSingleCombo('ERepLeader','RowId','Desc','web.DHCApptScheduleNew','LookUpELeaderNew',"");
	InitSingleCombo('ERepDoc','RowId','Desc','','',"");
	InitSingleCombo('ERepLoc','RowId','LocDesc','web.DHCApptScheduleNew','FindLoc',"&Arg1=&Arg2="+session['LOGON.USERID']+"&Arg3="+session['LOGON.GROUPID']+"&Arg4=&Arg5="+HospitalDr+"&ArgCnt=5");
}
function LoadClinicGroup(LocRowid){
	var queryParams = new Object();
		queryParams.ClassName = "web.DHCRBResSession";
		queryParams.QueryName = "GetClinicGroupByLocNew";;
		queryParams.Arg1 = LocRowid;
		queryParams.Arg2 = $HUI.combogrid('#_HospUserList').getValue();
		queryParams.ArgCnt = 2;
		InitComboData('#ClinicGroup',queryParams)
}
function LoadAdmDoc(AdmLocID,q){
	if(q==undefined) q="";
	if (AdmLocID=="") return;
	var desc=q;
	var TimeRange=$("#TimeRange").combobox("getValue");
	var AdmDate=$("#AdmDate").val();//$("#AdmDate").datebox("getValue"); 
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCApptScheduleNew';
	queryParams.QueryName ='FinNoRegDoc'; 
	queryParams.Arg1 =AdmDate;
	queryParams.Arg2 =AdmLocID;
	queryParams.Arg3 =TimeRange;
	queryParams.Arg4 =desc;
	queryParams.ArgCnt =4;
	InitComboData('#AdmDoc',queryParams)
} 
///初始化诊室
function LoadLocArea(q) {
	var LocID = $('#AdmLoc').combobox("getValue");
	var desc=q;
	var queryParams = new Object();
	var ClassName = "web.DHCApptScheduleNew";
	var QueryName = "LookUpRoomByUserNew";
	queryParams.ClassName = ClassName;
	queryParams.QueryName = QueryName;
	queryParams.Arg1 = desc;
	queryParams.Arg2 = session['LOGON.USERID'];
	queryParams.Arg3 = LocID //session['LOGON.CTLOCID'];
	queryParams.Arg4 = $HUI.combogrid('#_HospUserList').getValue();
	queryParams.ArgCnt = 4;
	InitComboData('#LocArea',queryParams)
} 
function DocSelectFun(){
	var AdmLoc = $("#AdmLoc").combobox("getValue");	
	var AdmDoc = $("#AdmDoc").combobox("getValue");
	if(AdmDoc=="") return false;
	var TimeRange=$("#TimeRange").combobox("getValue");
	var ret=tkMakeServerCall("web.DHCApptScheduleNew","GetDocResource",AdmLoc,AdmDoc,TimeRange);
	if (ret!=""){
		var Arr1=ret.split("$")[0];
		var Arr2=ret.split("$")[1];
		var Arr3=ret.split("$")[2];
		var Arr=Arr1.split("^");	
		$("#PositiveMax").numberbox('setValue',Arr[2]);
		$("#ApptMax").numberbox('setValue',Arr[3]);
		if(Arr.length>=18){
		    $("#ClinicGroup").combobox('setValue',Arr[18]);
		}else{
			$("#ClinicGroup").combobox("setValue", "");
		}
		$("#EStartPrefix").numberbox('setValue',Arr[4]);
		$("#AddtionMax").numberbox('setValue',Arr[5]);
		var ASRowID=$("#ASRowID").val();
		if (ASRowID==""){
			$("#ApptMax,#EStartPrefix").numberbox('setValue',"");
			Arr3="";
		}
		if(Arr3!=""){
			var TRInfoArr=Arr3.split("^");
			var TRFlag=TRInfoArr[0];
			var TRStTime=TRInfoArr[1];
			var TREnTime=TRInfoArr[2];
			var TRLenghth=TRInfoArr[3];
			var TRSDHS=TRInfoArr[4];
			var TRRegNumStr=TRInfoArr[5];
			var TRRegInfoStr=TRInfoArr[6];
			if(TRFlag=="Y"){
				$("#TRFlag").checkbox('check');	
				$("#TRLength").numberbox('setValue',TRLenghth);
				$("#TRRegNum").numberbox('setValue',TRSDHS);
				$("#TRSartTime").timespinner('setValue',TRStTime);
				$("#TREndTime").timespinner('setValue',TREnTime);
				$("#TRRegNumStr").val(TRRegNumStr);
				$("#TRRegInfoStr").val(TRRegInfoStr);
			}else{
				$("#TRFlag").checkbox('uncheck');	
				$("#TRLength,#TRRegNum").numberbox('setValue',"");
				$("#TRSartTime,#TREndTime").timespinner('setValue',"");
				$("#TRRegNumStr,#TRRegInfoStr").val("");
			}
		}else{
			$("#TRFlag").checkbox('uncheck');	
			$("#TRLength,#TRRegNum").numberbox('setValue',"");
			$("#TRRegNum").numberbox('setValue',"");
			$("#TRSartTime,#TREndTime").timespinner('setValue',"");
			$("#TRRegNumStr,#TRRegInfoStr").val("");
		}
	}
}
function SaveClickHandle(){
	if (!ValidateInput()) return ;
	var ASRowID=$("#ASRowID").val();
	if (ASRowID!=""){
		var ret=UpdateAS(ASRowID);
	}else{
		var ret=SaveNewAS();
	}
}
function SaveNewAS(){
	var scheduleDate=Trim($("#AdmDate").val(),"g"); //$("#AdmDate").datebox("getValue"); 
	if (scheduleDate==""){
		$.messager.alert('提示', "请选择出诊日期","info",function(){
			  $("#AdmDate").focus();
		})
		return false;
	}else{
		scheduleDate=scheduleDate.split(",").join("^");
	}
 	var StatusCode="A";				// 默认加诊
 	//正号限额
 	var total = $("#PositiveMax").numberbox('getValue'); 	
 	//预约限额		
	var book = $("#ApptMax").numberbox('getValue');	
	//加号限额			
	var over = $("#AddtionMax").numberbox('getValue');	
	//预约起始号			
	var startNum = $("#EStartPrefix").numberbox('getValue');		
	if (book==0){startNum=0}
	if (((startNum=="")||(startNum<=0))&(book>0)){
	  $.messager.alert('提示', "预约起始号数量格式不正确!","info",function(){
		  $("#EStartPrefix").focus();
	  })
	  return false;
    }
	var TimeStart = $("#StartTime").timespinner('getValue');		
	var TimeEnd = $("#EndTime").timespinner('getValue');	
	//分时段就诊
	var TRFlag="Y",TRStartTime="",TREndTime="",TRLength="",TRRegNum="",TRRegNumStr="",TRRegInfoStr="",StopRegNoFlag="Y";
	if(!$("#TRFlag").checkbox('getValue')){
		TRFlag = "N";
	}
	if(!$("#StopRegNoFlag").checkbox('getValue')){
		StopRegNoFlag = "";
	}
	/*if (TRFlag=="Y"){
		var TRStartTime=$("#TRSartTime").timespinner('getValue');
		var TREndTime=$("#TREndTime").timespinner('getValue');		
		var TRLength=$("#TRLength").numberbox('getValue'); 		
		var TRRegNum=$("#TRRegNum").numberbox('getValue'); 
		if ((TRRegNum=="")||(TRRegNum==0)){
			$.messager.alert('提示', "分时段时段号数不能为空或0!","info",function(){
				$("#TRRegNum").focus();
			});
			return false;
		}
		if(+TRRegNum>+(total.value)){
			$.messager.alert('提示', "分时段时段号数不能大于正号限额!","info",function(){
				$("#TRRegNum").focus();
			});
			return false;
		}
		if (!TRInfoCalculate(TRStartTime,TREndTime,TRLength,TRRegNum,startNum)) return false;
		TRRegNumStr=$("#TRRegNumStr").val();		
		TRRegInfoStr=$("#TRRegInfoStr").val();	
	}*/
	var AdmLoc = $("#AdmLoc").combobox("getValue");	
	var AdmDoc = $("#AdmDoc").combobox("getValue");	
	var TimeRange = $("#TimeRange").combobox("getValue");	
	var LocArea = $("#LocArea").combobox("getValue");	
	var DocSession = $("#DocSession").combobox("getValue");
	var ClinicGroup	= getValue("ClinicGroup"); //$("#ClinicGroup").combobox("getValue");
	var TimeRangeStr=TRFlag+"^"+TRStartTime+"^"+TREndTime+"^"+TRLength+"^"+TRRegNum+"^"+TRRegNumStr+"^"+TRRegInfoStr;
	var ret1 = cspHttpServerMethod(MNew.value,scheduleDate,AdmDoc,AdmLoc,TimeRange,total,book,over,LocArea,DocSession,ClinicGroup,startNum,TimeStart,TimeEnd,StatusCode,TimeRangeStr,"",StopRegNoFlag,session['LOGON.GROUPID']);
	var temparr=ret1.split("^");
	var ret=temparr[0];
	if (ret){
		if (ret=="0"){
			var ASRowid=temparr[1];
			ASRowid=ASRowid.split(String.fromCharCode(1))[0];
			$('#ASRowID').val(ASRowid);
			var RequestFlag=temparr[2];
			var msg="新增排班记录成功,请根据情况修改限额!"
			if(RequestFlag.indexOf("Y")>=0){
				//var msg="申请新增排班记录成功,请等待相关人员审批后,根据情况修改限额！";
				var msg="申请新增排班记录成功,请等待相关人员审批！";
			}
			$("#AdmDate").val(scheduleDate.split("^")[0]);
			$("#AdmDate").prop("disabled",true);
			$.messager.alert('提示', msg);
			if (PageLogicObj.m_tabAppQtyListDataGrid==""){
				//PageLogicObj.m_tabAppQtyListDataGrid=InitAppQtyList();
				InitAppMethodGrid();
				InitTRDataGrid();
			}
			LoadApptabAppMethodInfo(ASRowid)
			LoadtabTRInfo(ASRowid)
			ReLoadScheduleGrid();
			$('#tabAppQtyList').datagrid('load',{
				ClassName:'web.DHCRBApptScheduleAppQty',
				QueryName:'FindAppQty',
				Arg1:ASRowid,
				ArgCnt:1
			});
			LimitCombo('disable'); LimitText(true);
			TRFlag_Click();
			return true;
		}else{
			switch(ret)	{
				case '-201':
					$.messager.alert('错误', "同一个医生不能在同一天同一时段安排两次！ "+temparr[1]);
					break;
				case '-202':
					$.messager.alert('错误', "此诊室已经在同一天同一时段被安排过！ "+temparr[1]);
					break;
				case '300':
					$.messager.alert('错误', "医生没有安排资源!");
					break;
				case '200':	
					$.messager.alert('错误', "当前医生已经有排班记录!");
					break;
				default:
					$.messager.alert('错误', "新增排班记录失败!！ ");
					break;
			}
		}
	}
}
function UpdateAS(ASRowID){
	var ret=tkMakeServerCall("web.DHCRBApptSchedule","ApptScheduleIsLater",ASRowID)
	if (ret<0){
		$.messager.alert('提示', "操作号源已超过号源可用时间!");
		return false;
	}
	var LockFlag="N";
	//正号限额
	var total = $("#PositiveMax").numberbox('getValue'); 	
	//预约限额		
	var book = $("#ApptMax").numberbox('getValue'); 				
	/*var AppClientNum = tkMakeServerCall("web.DhcResEffDateSessionClass","GetAppClientNum",ASRowID,"RBASSchedule");
	if(+AppClientNum>+book)	{
		$.messager.alert('提示', "预约限额不能小于各个预约机构限额 "+AppClientNum);
		return false;
	}*/
	var AppCheck=tkMakeServerCall("web.DhcResEffDateSessionClass","CheckAppClientNum",ASRowID,"RBASSchedule",+book)
	if (AppCheck==1){
		$.messager.alert('提示', "预约限额不能小于各个预约机构最大预约限额");
		return false;
		}
	if (AppCheck==2){
		$.messager.alert('提示', "预约限额不能小于各个预约机构限保留数总和");
		return false;
	}
	//加号限额
	var over = $("#AddtionMax").numberbox('getValue');		
	//预约起始号		
	var startNum = $("#EStartPrefix").numberbox('getValue');		
	if (book==0){
		startNum=0;
	}
	if (((startNum=="")||(startNum<=0))&(book>0)){
	  $.messager.alert('提示', "预约起始号数量格式不正确!","info",function(){
		  $("#startNum").focus();
	  })
	  return false;
    }	
    var AppedCount=tkMakeServerCall("web.DHCRBApptSchedule","GetAppedSeqNoCount",ASRowID);
    var RegCount=tkMakeServerCall("web.DHCRBApptSchedule","GetRegSeqNoCount",ASRowID);
    var SumRegApp=parseFloat(AppedCount)+parseFloat(RegCount)
    if (SumRegApp>=1){
		if (!(dhcsys_confirm("排班信息已存在预约和挂号记录，如果保存数据会导致号序混乱，是否保存"))) return false;
		}		
	var TimeStart = $("#StartTime").timespinner('getValue');		
	var TimeEnd = $("#EndTime").timespinner('getValue');
	var TimeRange = getValue("TimeRange");
	// 开始时间和结束时间不能超过时段开始时间和结束时间
	var TimeRangstr=TRArr[TimeRange];
	if (TimeRangstr!=""){
		var date = new Date();
		var TimeStratRange=TimeRangstr.split("^")[0];
		var TimeEndRange=TimeRangstr.split("^")[1];
		var TStart=TimeStratRange.split(":")
		var TEnd=TimeEndRange.split(":")
		var NStart=TimeStart.split(":")
		var NEnd=TimeEnd.split(":")
		var TTStart=date.setHours(TStart[0],TStart[1]);
        var TTEnd=date.setHours(TEnd[0],TEnd[1]);
        var NNStart=date.setHours(NStart[0],NStart[1]);
        var NNEnd=date.setHours(NEnd[0],NEnd[1]);
        /*if ((TTStart>NNStart)||(TTEnd<NNEnd)){
	         $.messager.alert('提示', "开始时间和结束时间不能超过时段维护的开始时间和结束时间!","info",function(){
				  $("#StartTime").focus();
			  })
			  return false;
	        }*/
	}
	//分时段就诊
	var TRFlag="Y",TRStartTime="",TREndTime="",TRLength="",TRRegNum="",TRRegNumStr="",TRRegInfoStr="",StopRegNoFlag="Y";
	if(!$("#TRFlag").checkbox('getValue')){
	   TRFlag = "N";
    }
    if(!$("#StopRegNoFlag").checkbox('getValue')){
	   StopRegNoFlag = "";
    }
    /*if (TRFlag=="Y"){
	    var TRStartTime=$("#TRSartTime").timespinner('getValue');
		var TREndTime=$("#TREndTime").timespinner('getValue');		
		var TRLength=$("#TRLength").numberbox('getValue');		
		var TRRegNum=$("#TRRegNum").numberbox('getValue');
		if ((TRRegNum=="")||(TRRegNum==0)){
			$.messager.alert('提示', "分时段时段号数不能为空或0!");
			return false;
		}
		var r = /^[0-9]*[1-9][0-9]*$/
		if (!r.test(TRRegNum)){
			$.messager.alert('提示', "分时段时段号数只能为正整数!","info",function(){
				$("#TRRegNum").focus();
			});
			return false;
	    }	
		if(+TRRegNum>+(total)){
			$.messager.alert('提示', "分时段时段号数不能大于正号限额!","info",function(){
				$("#TRRegNum").focus();
			});
			return false;
		}
		if ((TRRegNum!="")&&(!TRInfoCalculate(TRStartTime,TREndTime,TRLength,TRRegNum,startNum))) return false;
		TRRegNumStr=$("#TRRegNumStr").val() ;		
		TRRegInfoStr=$("#TRRegInfoStr").val() ;	
	}*/
	var AdmLoc = getValue("AdmLoc"); //$("#AdmLoc").combobox("getValue");	
	var AdmDoc = getValue("AdmDoc"); //$("#AdmDoc").combobox("getValue");	
	var TimeRange = getValue("TimeRange"); //$("#TimeRange").combobox("getValue");	
	var LocArea = getValue("LocArea"); //$("#LocArea").combobox("getValue");	
	var DocSession = getValue("DocSession"); //$("#DocSession").combobox("getValue");
	var ClinicGroup	= getValue("ClinicGroup"); //$("#ClinicGroup").combobox("getValue");
	var TimeRangeStr=TRFlag+"^"+TRStartTime+"^"+TREndTime+"^"+TRLength+"^"+TRRegNum+"^"+TRRegNumStr+"^"+TRRegInfoStr;
	if (total  && ASRowID){
		var ret1 = tkMakeServerCall("web.DHCRBApptSchedule","UpdateOneSchedule",ASRowID,LocArea,total,over,book,startNum,ClinicGroup,DocSession,LockFlag,TimeStart,TimeEnd,TimeRangeStr,StopRegNoFlag);
		var temparr=ret1.split("^")
		var ret=temparr[0];
		if (ret == 0) 	{
			$.messager.popover({msg: '修改成功!',type:'success'});
			//如果总和不等于分时段总和需要重新生成，分时段数需要重新生成
			if (TRFlag=="Y"){
				TRInfoTotal=0
				var rows=$('#tabTRInfo').datagrid('getData').originalRows;
                for(var i=0;i<rows.length;i++){
                    var Editors=$('#tabTRInfo').datagrid('getEditors',i);
                    if(Editors.length){
                        rows[i].Load=GetElementValue(Editors[0].target);
                    }
                    TRInfoTotal+=Number(rows[i].Load);
                }
                if (parseFloat(TRInfoTotal)!=parseFloat(total)){
	                 $('#TRGenWin').window('open');
	                 var TRASLoad=$.cm({
				        ClassName:'DHCDoc.OPAdm.Schedule',
				        MethodName:'GetTRASLoad',
				        ASRowID:ASRowID,
				        dataType:"text"
				    },false);
					SetElementValue('TRASLoad',TRASLoad);
					SetElementValue('IntervalTime',"");
					GenWayChecked();
	                }
				}
			ReLoadScheduleGrid();
			return true;
		}else {
			  if (ret=="-201"){$.messager.alert('提示', "同一个医生不能在同一天同一时段安排两次！ "+temparr[1]);return;}
			  if (ret=="-202"){$.messager.alert('提示', "此诊室已经在同一天同一时段被安排过！ "+temparr[1]);return;}
			  if (ret=="-203"){$.messager.alert('提示', "正号限额不能小于已挂出号数! ");return;}
			  if (ret=="-204"){$.messager.alert('提示', "预约限额不能小于已预约数 ");return;}
			  if (ret=="-205"){$.messager.alert('提示', "加号限额不能小于已挂出数 ");return;}
			$.messager.alert('提示', "修改失败! ");
			return false;
		}
	}
}
function TRInfoCalculate(TRStartTime,TREndTime,TRLength,TRRegNum,TRStartNum){
	if (TRStartTime==""){
		$.messager.alert('提示', "分时段开始时间格式不正确!","info",function(){
			$("#TRSartTime").next('span').find('input').focus();
		})
		return false;
	}
	if (TREndTime==""){
		$.messager.alert('提示', "分时段结束时间格式不正确!","info",function(){
			$("#TREndTime").next('span').find('input').focus();
		})
		return false;
	}
	if ((TRLength=="")||(TRLength<0)){
		$.messager.alert('提示', "分时段时间间隔格式不正确!","info",function(){
			$("#TRLength").focus();
		})
		return false;
	}
	if ((TRRegNum=="")||(TRRegNum<0)){
		$.messager.alert('提示', "分时段号源数量格式不正确!","info",function(){
			$("#TRRegNum").focus();
		})
		return false;
	}
	if (parseFloat(TRStartNum)<0){
		$.messager.alert('提示', "预约起始号数量格式不正确!","info",function(){
			$("#EStartPrefix").focus();
		})
		return false;
	}
	var ret=tkMakeServerCall("web.DHCRBResSession","TRInfoCalculate",TRStartTime,TREndTime,TRLength,TRRegNum)
	var arr=ret.split("^");
	if (arr[0]!="0"){
		$.messager.alert('提示', arr[1]);
		return false;
	}else{
		RegNumStr=$("#TRRegNumStr").val() ;
		RegInfoStr=$("#TRRegInfoStr").val() ;		
		if ((RegNumStr!=""&&RegNumStr!=arr[1])||(RegInfoStr!=""&&RegInfoStr!=arr[2])){
			if (!(dhcsys_confirm("旧号段信息"+RegNumStr+"\n新号段信息"+arr[1]+"\n旧时段信息"+RegInfoStr+"\n新时段信息"+arr[2]+"\n是否替换?"))) return false;
		}
		$("#TRRegNumStr").val(arr[1]);
		$("#TRRegInfoStr").val(arr[2]);
		return true;
	}
}
function ValidateInput(){
	var ASDate=getValue("AdmDate");			
	if (ASDate==""){
		$.messager.alert('提示', "出诊日期不能为空!","info",function(){
			$("#AdmDate").next('span').find('input').focus();
		});
		return false;
	}
	var AdmLoc = getValue("AdmLoc");	
	if (AdmLoc==''){
		$.messager.alert('提示', "出诊科室不能为空!","info",function(){
			$("#AdmLoc").next('span').find('input').focus();
		});
		return false;
	}
	var AdmDoc = getValue("AdmDoc");	
	if (AdmDoc==''){
		$.messager.alert('提示', "出诊医生不能为空!","info",function(){
			$("#AdmDoc").next('span').find('input').focus();
		});
		return false;
	}
	var TimeRange = getValue("TimeRange"); 	
	if (TimeRange==''){
		$.messager.alert('提示', "出诊时段不能为空!","info",function(){
			$("#TimeRange").next('span').find('input').focus();
		});
		return false;
	}
	var ESessionType = getValue("DocSession"); 
	if (ESessionType==''){
		$.messager.alert('提示', "挂号职称不能为空!","info",function(){
			$("#DocSession").next('span').find('input').focus();
		});
		return false;
	}	
	//正号限额
	var EPositiveMax = $("#PositiveMax").numberbox('getValue');
	//预约限额 		
	var EApptMax = $("#ApptMax").numberbox('getValue'); 	
	//加号限额			
	var EAddtionMax = $("#AddtionMax").numberbox('getValue');	
	//预约起始号		
	var EStartPrefix = $("#EStartPrefix").numberbox('getValue');		
    if (EPositiveMax==''){
		$.messager.alert('提示', "正号限额不能为空!","info",function(){
			$("#PositiveMax").focus();
		});
		return false;
	}
	if ((parseFloat(EApptMax)>0)&&(EStartPrefix=='')){
		$.messager.alert('提示', "预约起始号不能为空!","info",function(){
			$("#ApptMax").focus();
		});
		return false;
	}
	if ((parseInt(EPositiveMax))<(parseInt(EApptMax))){
		$.messager.alert('提示', "正号限额不能小于预约限额!");
		return false;
	}
	if (parseInt(EApptMax)!=0){
		if ((parseInt(EPositiveMax)-parseInt(EStartPrefix)+1)<(parseInt(EApptMax))){
			$.messager.alert('提示', "正号限额减去预约起始号要大于等于预约限额!");
			return false;
		}
	}
	if (parseInt(EPositiveMax)>999){
		$.messager.alert('错误', "正号限额不能超过999!","info",function(){
			$("#PositiveMax").focus();
		});
		return false;
	}
	return true;	
}
function ReLoadScheduleGrid(){
	var tab = $('#ScheduleTab').tabs('getSelected');
	var index = $('#ScheduleTab').tabs('getTabIndex',tab);
	var GridId="ScheduleGrid"+index
	$("#"+GridId).datagrid('load');
}
function StopAppSchedule(){
	$("#StopASRowIDStr").val("");
	var tab = $('#ScheduleTab').tabs('getSelected');
	var index = $('#ScheduleTab').tabs('getTabIndex',tab);
	var GridId="ScheduleGrid"+index;
	var rows=$("#"+GridId).datagrid("getSelections");
	var idStr="";
	for(var i=0;i<rows.length;i++){
		var status=rows[i].ASStatus
		if((status=="停诊")||(status=="被替诊")||(status=="待审核")) {
			$.messager.alert("提示","已停诊或被替诊或未审核的排班记录不能停诊,请重新选择!")
			return false;
		}
		var AppedCount=tkMakeServerCall("web.DHCRBApptSchedule","GetAppedSeqNoCount",rows[i].ASRowId);
	    if(AppedCount>=1){
		    if (!(dhcsys_confirm(rows[i].LocDesc+" "+rows[i].DocDesc+" "+rows[i].TimeRange+"的排班信息已存在预约记录,是否确认停诊?"))) return false;
		}
		if(idStr==""){
			idStr=rows[i].ASRowId
		}else{
			idStr=idStr+"^"+rows[i].ASRowId
		}
	}
	if(idStr==""){
		$.messager.alert("提示","请选择要停诊的排班记录!")
		return false;
	}
	$("#StopASRowIDStr").val(idStr)
	$("#EReason").combobox("select", '');
	$("#EPassword").val('');
	$("#ELeader").combobox('loadData',[{Desc:session['LOGON.USERNAME'],RowId:session['LOGON.USERID']}]).combobox("select", session['LOGON.USERID']);
	//$("#ELeader").combobox('loadData',[]);
	$("#EPassword,#tr-EPassword").hide();
	$("#EReason").next('span').find('input').focus();
	$("#StopWin").window("open")
}
function cancel(){
	$('#EditWin').window('close', true); 
}
function EditWinBeforeClose(){
	PageLogicObj.m_EditRow=-1;
	if (PageLogicObj.m_tabAppQtyListDataGrid!=""){
		PageLogicObj.m_tabAppQtyListDataGrid.datagrid('rejectChanges').datagrid('unselectAll');
	}
	ReLoadScheduleGrid();
}
function StopClickHandle() {
	$.messager.confirm("提示","请确认停诊信息,是否继续停诊？",function(r){
		if (r) {
			StopClickHandleNew()
		}
	})
}
function StopClickHandleNew(){
	mStopLeaderId=getValue('ELeader');	
	if (mStopLeaderId==""){
		$.messager.alert("提示","请选择批准人","info",function(){
			$("#ELeader").next('span').find('input').focus();
		})
		return false;
	}
	if ((mStopLeaderId!="")&&(mStopLeaderId!=session['LOGON.USERID'])){
		var UserName=$('#ELeader').combobox('getText');	
		var EPassword=$("#EPassword").val();
		if(EPassword==""){
			$.messager.alert("提示","请输入批准人【"+UserName+"】的登陆密码!","info",function(){
				$("#EPassword").focus();
			});
			return false;
		}
		var err=tkMakeServerCall('web.DHCOEOrdItem','PinLogNumberValid',mStopLeaderId,EPassword);
		if (err==-1){
			$.messager.alert("提示","该用户不存在!","info",function(){
				$("#ELeader").next('span').find('input').focus();
			})
			return false;
		}else if(err==-4){
			$.messager.alert("提示","密码错误!","info",function(){
				$("#EPassword").focus();
			})
			return false;
		}
	}
	mStopReasonId=getValue('EReason');
	if (mStopReasonId==""){
		$.messager.alert('提示', '请选择停诊原因!',"info",function(){
				$("#EReason").next('span').find('input').focus();
		});
		return false;
	}	
	var ASRowidStr=$("#StopASRowIDStr").val();
	var RequestLocDesc=""
	var NotRequestLocDesc=""
	for (var i=0;i<ASRowidStr.split("^").length;i++){
		var ret=tkMakeServerCall("web.DHCRBApptSchedule","ApptScheduleIsLater",ASRowidStr.split("^")[i]);
		if (ret<0){ //<0过时了 >0中途停诊 
		   $.messager.alert('提示',t["ApptScheduleIsLater"]);
		   return false;
	    }
	    var StatusCode="S";
		if (ret==1) StatusCode="PS";
		var IsAudit="0";
		if (ret==2) IsAudit="1";
		var RequestRet=tkMakeServerCall("web.DHCRBApptScheduleAudi","GetRBASRequestFlag","S",ASRowidStr.split("^")[i],session['LOGON.GROUPID']);
		var RequestRetArr=RequestRet.split("^");
		var RequestFlag=RequestRetArr[0];
		if(RequestFlag==0)IsAudit="1";
		var ret = tkMakeServerCall("web.DHCRBApptSchedule","StopOneSchedule",ASRowidStr.split("^")[i],mStopReasonId,mStopLeaderId,StatusCode,IsAudit);
		if (ret!= 0) {
			$.messager.alert('提示', '停诊失败!'+ret);
			return false;
		}else{
			if(RequestFlag==0){
				if(NotRequestLocDesc==""){NotRequestLocDesc=RequestRetArr[1];}
				else{NotRequestLocDesc=NotRequestLocDesc+","+RequestRetArr[1];}	
			}else{
				if(RequestLocDesc==""){RequestLocDesc=RequestRetArr[1];}
				else{RequestLocDesc=RequestLocDesc+","+RequestRetArr[1];}	
			}	
		}
	}
	var msg="停诊成功!";
	if(NotRequestLocDesc!=""){msg=NotRequestLocDesc+"停诊成功!"};
	if(RequestLocDesc!=""){
		if(msg!=""){msg=msg+";"+RequestLocDesc+"停诊申请成功!请等待相关人员审核后生效."}
		else{msg=RequestLocDesc+"停诊申请成功!请等待相关人员审核后生效."}	
	}
	$.messager.popover({msg: msg,type:'success'});
	$('#StopWin').window('close', true); 
	ReLoadScheduleGrid();
	return true;
}
function CancelStopAppSchedule(ASRowId){
	$("#StopASRowIDStr").val("");
	var tab = $('#ScheduleTab').tabs('getSelected');
	var index = $('#ScheduleTab').tabs('getTabIndex',tab);
	var GridId="ScheduleGrid"+index
	var rows=$("#"+GridId).datagrid("getSelections")
	var idStr=""
	var rtn=""
	var RequestLocDesc=""
	var NotRequestLocDesc=""
	for(var i=0;i<rows.length;i++){
		var status=rows[i].ASStatus;
		if(status!="停诊") continue;
		if(idStr==""){
			idStr=rows[i].ASRowId;
		}else{
			idStr=idStr+"^"+rows[i].ASRowId;
		}
		var IsAudit="0";
		var RequestRet=tkMakeServerCall("web.DHCRBApptScheduleAudi","GetRBASRequestFlag","SC",rows[i].ASRowId,session['LOGON.GROUPID']);
		var RequestRetArr=RequestRet.split("^");
		var RequestFlag=RequestRetArr[0];
		var IsExistInfo=tkMakeServerCall("web.DHCOPRegHolidayAdjust","CheckRBASInHoliday",rows[i].ASRowId)
		var ExistFlag=IsExistInfo.split("^")[0]
		var ExistFrDate=IsExistInfo.split("^")[1]
		var ExistToDate=IsExistInfo.split("^")[2]
		var AlertStr=""
		if(RequestFlag=="0")IsAudit="1";
		var rtn=tkMakeServerCall("web.DHCRBApptSchedule","CancelStopOneSchedule",rows[i].ASRowId)
		if(rtn!=0){
			var rtnArr=rtn.split("^")
			if(rtnArr[0]=='-201'){
				$.messager.alert("提示","不能撤销停诊,"+rtnArr[1]+"存在相同时段的排班!")
				break;
			}else{
				$.messager.alert("提示","撤销停诊失败!")
				break;
			}
		}else{
			if (ExistFlag==1) AlertStr="(该排班存在于"+ExistFrDate+"至"+ExistToDate+"的长时段停诊中!)"
			if(RequestFlag==0){
				if(NotRequestLocDesc==""){
					NotRequestLocDesc=RequestRetArr[1]+AlertStr;
				}else{
					NotRequestLocDesc=NotRequestLocDesc+","+RequestRetArr[1]+AlertStr;
				}	
			}else{
				if(RequestLocDesc==""){
					RequestLocDesc=RequestRetArr[1]+AlertStr;
				}else{
					RequestLocDesc=RequestLocDesc+","+RequestRetArr[1]+AlertStr;
				}	
			}		
		}
	}
	if(idStr==""){
		$.messager.alert("提示","请选择要撤消停诊的排班记录")
		return false;
	}else{
		if(rtn==0){
			var msg="撤消停诊成功!"
			if(NotRequestLocDesc!=""){msg=NotRequestLocDesc+"撤消停诊成功!"};
			if(RequestLocDesc!=""){
				if(msg!=""){msg=msg+";"+RequestLocDesc+"撤消停诊申请成功!请等待相关人员审核后生效."}
				else{msg=RequestLocDesc+"撤消停诊申请成功!请等待相关人员审核后生效."}	
			}
			$.messager.popover({msg: msg,type:'success'});
			//$.messager.alert("提示",msg)
			//$.messager.popover({msg: '撤消停诊成功!',type:'success'});
			ReLoadScheduleGrid();
		}
	}
}
 function ReplaceAppSchedule(){
	 $("#ReplaceASRowIDStr").val("");
	 var tab = $('#ScheduleTab').tabs('getSelected');
	 var index = $('#ScheduleTab').tabs('getTabIndex',tab);
	 var GridId="ScheduleGrid"+index;
	 var rows=$("#"+GridId).datagrid("getSelections");
	 var idStr="";
	 for(var i=0;i<rows.length;i++){
		if(idStr==""){
			idStr=rows[i].ASRowId;
		}else{
			idStr=idStr+"^"+rows[i].ASRowId;
		}
	 }
	 if(idStr==""){
		$.messager.alert("提示","请选择要替诊的排班记录!");
		return false;
	 }
	 if(idStr.split("^").length>1){
		 $.messager.alert("提示","请选择单个排班进行替诊操作!");
		 return false;
	 }
	 var Status=rows[0].ASStatus;
	 if (Status=="停诊"){
		 $.messager.alert("提示","已经停诊的记录不能替诊!");
		 return false;
	 }else if (Status=="被替诊"){
		 $.messager.alert("提示","已经替诊的记录不能替诊!");
		 return false;
	 }else if (Status=="待审核"){
		  $.messager.alert("提示","未审核的记录不能替诊!");
		 return false;
	 }
	 var selLocDesc=rows[0].LocDesc;
	 $("#ReplaceASRowIDStr").val(idStr);
	 ClearReplaceData();
	 //初始化页面数据
	 var RBResInfo=tkMakeServerCall("web.DHCApptScheduleNew","GetApptScheduleInfo",idStr)
	 $("#ERepLoc").combobox("select", RBResInfo.split("^")[2]);
	 
	 $("#ERepLeader").combobox('loadData',[{Desc:session['LOGON.USERNAME'],RowId:session['LOGON.USERID']}]).combobox("select", session['LOGON.USERID']);
	 //$("#ERepLeader").combobox('loadData',[]);
	 $("#ReplaceWin").window("open");
	 $("#ERepPassword,#td-ERepPassword").hide();
	 $("#ERepDoc").next('span').find('input').focus();
}
function LoadERepDoc(q){
	var AdmLocID=getValue('ERepLoc');
	if (AdmLocID=="") return;
	var ReplaceASRowID=$("#ReplaceASRowIDStr").val();
	var ReplaceASRowIDInfo=tkMakeServerCall("web.DHCApptScheduleNew","GetApptScheduleInfo",ReplaceASRowID);
	var TimeRange=ReplaceASRowIDInfo.split("^")[0]; 
	var AdmDate=ReplaceASRowIDInfo.split("^")[1];
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCApptScheduleNew';
	queryParams.QueryName ='FinNoRegDoc'; 
	queryParams.Arg1 =AdmDate;
	queryParams.Arg2 =AdmLocID;
	queryParams.Arg3 =TimeRange;
	queryParams.Arg4 =q;
	queryParams.ArgCnt =4;
	InitComboData('#ERepDoc',queryParams)
}
function ReplaceSave() {
	$.messager.confirm("提示","请确认替诊信息,是否继续替诊？",function(r){
		if (r) {
			ReplaceSaveNew()
		}
	})
}
function ReplaceSaveNew(){
	var ERepLoc=getValue('ERepLoc');
	 if(ERepLoc==""){
		 $.messager.alert('提示',"请选择替诊科室!","info",function(){
			 $("#ERepLoc").next('span').find('input').focus();
		 })
		 return false;
	 }
	 var ERepDoc=getValue('ERepDoc');
	 if(ERepDoc==""){
		 $.messager.alert('提示',"请选择替诊医生!","info",function(){
			 $("#ERepDoc").next('span').find('input').focus();
		 })
		 return false;
	 }
	 var ERepSessionType=getValue('ERepSessionType');
	 if(ERepSessionType==""){
		 $.messager.alert('提示',"请选择替诊职称!","info",function(){
			 $("#ERepSessionType").next('span').find('input').focus();
		 })
		 return false;
	 }
	 var ERepReason=getValue('ERepReason');
	 if(ERepReason==""){
		 $.messager.alert('提示',"请选择替诊原因!","info",function(){
				$("#ERepReason").next('span').find('input').focus();
		 })
		 return false;
	 }
	 var ERepLeader=getValue('ERepLeader');
	 if (ERepLeader==""){
		$.messager.alert("提示","请选择批准人","info",function(){
			$("#ERepLeader").next('span').find('input').focus();
		})
		return false;
	}
	 if ((ERepLeader!="")&&(ERepLeader!=session['LOGON.USERID'])){
		 var UserName=$("#ERepLeader").combobox("getText");	
		 var ERepPassword=$("#ERepPassword").val();
		 if(ERepPassword==""){
			$.messager.alert('提示', "请输入批准人【"+UserName+"】的登陆密码!","info",function(){
				$("#EPassword").focus();
			});
			return false;
		}
		var err=tkMakeServerCall('web.DHCOEOrdItem','PinLogNumberValid',ERepLeader,ERepPassword);
		if (err==-1){
			$.messager.alert('提示', "该用户不存在!","info",function(){
				$("#ERepLeader").next('span').find('input').focus();
			})
			return false;
		}else if(err==-4){
			$.messager.alert('提示', "密码错误!","info",function(){
				$("#EPassword").focus();
			})
			return false;
		}
	 }
	 var ASRowID=$("#ReplaceASRowIDStr").val();
	 var ret=tkMakeServerCall("web.DHCRBApptSchedule","ApptScheduleIsLater",ASRowID)
	 if (ret<0){
		$.messager.alert('提示', "操作号源已超过号源可用时间! ");
		return false;
	 }
	 var IsAudit=0;
	 var RequestRet=tkMakeServerCall("web.DHCRBApptScheduleAudi","GetRBASRequestFlag","R",ASRowID,session['LOGON.GROUPID']);
	 var RequestRetArr=RequestRet.split("^");
	 var RequestFlag=RequestRetArr[0];
	 if(RequestFlag=="0")IsAudit="1";
	 var ret1 = tkMakeServerCall("web.DHCRBApptSchedule","ReplaceOneSchedule",ASRowID,ERepDoc,ERepLoc,ERepReason,ERepLeader,ERepSessionType,IsAudit);
	 var temparr=ret1.split("^");
	 var ret=temparr[0];
	 if (ret==0){
		 var msg="替诊成功!"
		if(RequestFlag==1){
			var msg="替诊申请成功!请等待相关人员审核后生效.";
		}
		$.messager.popover({msg: msg,type:'success'});
		$('#ReplaceWin').window('close', true); 
	 	ReLoadScheduleGrid();
		return true;
	 }else{
		switch(parseInt(ret))
		{
		case 300:
			$.messager.alert('提示', '医生没有安排资源!');
	 		break;
		case 200:	
			$.messager.alert('提示', '医生已经有排班记录!');
			break;
		case 100:
	  		$.messager.alert('提示', '替诊失败!');
			break;
		case 101:
			$.messager.alert('提示', '复制被替诊医生的预约限额记录失败');		
	  		break;
		default:
			$.messager.alert('提示', ret);
			break;	
 		}
 		return false;
	 }
}
function ClearReplaceData(){
	 $("#ERepLoc,#ERepDoc,#ERepSessionType,#ERepReason").combobox("select", '');
	 $("#ERepPassword").val('');
}
function getValue(id){
	var className=$("#"+id).attr("class")
	if(typeof className =="undefined"){
		return $("#"+id).val()
	}
	if(className.indexOf("hisui-lookup")>=0){
		var txt=$("#"+id).lookup("getText")
		//如果放大镜文本框的值为空,则返回空值
		if(txt!=""){ 
			var val=$("#"+id).val()
		}else{
			var val=""
			$("#"+id+"Id").val("")
		}
		return val
	}else if(className.indexOf("hisui-combobox")>=0){
		var optobj=$("#"+id).combobox("options");
		var mulval=optobj.multiple;
		if(mulval){
			var tmpval=new Array();
			var val=$("#"+id).combobox("getValues");
			for(var i=0;i<val.length;i++){
				if(val[i]!=""){
					tmpval.push(val[i])
				}
			}
			val=tmpval.join(",");
		}else{
			var val=$("#"+id).combobox("getValue");
		}
		if(typeof val =="undefined") val=""
		return val
	}else if(className.indexOf("hisui-datebox")>=0){
		return $("#"+id).datebox("getValue")
	}else{
		return $("#"+id).val()
	}
	return ""
}
function InitAppQtyList(){
	var Cloumns=[[
		{field:'ASQRowId',hidden:true},
		{field:'ApptMethodDr',hidden:true},
		{field:'AppMethodName',title:'预约方式',align:'center',width:190,resizable:true,
			editor: { type: 'combobox', options: {
				editable:false,
				panelHeight:'auto',
				valueField:'Rowid',
				textField:'Desc',
				required: true,
				data:APTMArr,
				loadFilter:function(data){
					var rows=$('#tabAppQtyList').datagrid('getRows');
					var AQMStr="^"
					for(var i=0;i<rows.length;i++){
						if(PageLogicObj.m_EditRow==i) continue;
						var AQMethodDR=rows[i].ApptMethodDr;
						if(AQMethodDR){
							AQMStr+=AQMethodDR+"^";
						}
					}
					if(AQMStr=="^") return data;
					var newData=new Array();
					for(var i in data){
						if(AQMStr.indexOf("^"+data[i].Rowid+"^")==-1){
							newData[newData.length]=data[i];
						}	
					}
					return newData;
				},
				onLoadSuccess:function(data){
					var rows=$('#tabAppQtyList').datagrid('getRows');
					if ((PageLogicObj.m_EditRow>0)&&(rows[PageLogicObj.m_EditRow].ApptMethodDr))
						$(this).combobox('setValue',rows[PageLogicObj.m_EditRow].ApptMethodDr);
				},
				onSelect:function(record){
					if (record!=undefined){
						var rows=$('#tabAppQtyList').datagrid("selectRow",PageLogicObj.m_EditRow).datagrid("getSelected");
						rows['ApptMethodDr']=record['Rowid'];
					}
				},
				onChange:function(newValue, oldValue){
					if (newValue==""){
						var rows=$('#tabAppQtyList').datagrid("selectRow",PageLogicObj.m_EditRow).datagrid("getSelected");
						rows['ApptMethodDr']="";
					}
				}
			}
		}},
		{field:'AppStartNum',title:'起始号',align:'center',width:100,resizable:true,
			/*editor: { 
				type: 'numberbox', 
				options: {
					required: true,
					onChange:function(newValue,oldValue){
						if (newValue>0){
							var editors = $('#tabAppQtyList').datagrid('getEditors', PageLogicObj.m_EditRow); 
							var AppQty=editors[2].target.val();
							var AppStartNum=newValue;
							$($("#datagrid-row-r2-2-"+PageLogicObj.m_EditRow+" td")[8]).children(0)[0].innerHTML=(+AppQty)+(+AppStartNum)-1;
						}
					}
				},
			}*/
			formatter: function(value,row,index){
			   if (value==undefined){value=""}
			   if (row.ASQRowId==undefined){
				 	var ASRowID = $('#ASRowID').val();
				 	var ID=ASRowID+"!"+index+"!"+"2"
			   }else{
			   		var ID=row.ASQRowId+"!"+row.ApptMethodDr+"!"+"2"
			   }
			   return "<input class='textbox' name='AppMethList' id='"+ID+"' value='"+value+"' onkeyup=Appqtykeyup('"+ID+"') style='width:30px'></input>"
			}
		},
		{field:'AppQty',title:'数量',align:'center',width:100,resizable:true,
			/*editor: { 
				type: 'numberbox', 
				options: {
					required: true,
					onChange:function(newValue,oldValue){
						if (newValue>0){
							var editors = $('#tabAppQtyList').datagrid('getEditors', PageLogicObj.m_EditRow); 
							var AppQty=newValue;
							var AppStartNum=editors[1].target.val();
							$($("#datagrid-row-r2-2-"+PageLogicObj.m_EditRow+" td")[8]).children(0)[0].innerHTML=(+AppQty)+(+AppStartNum)-1;
						}
					}
				},
			}*/
			formatter: function(value,row,index){
						 if (value==undefined){value=""}
						 if (row.ASQRowId==undefined){
						 	var ASRowID = $('#ASRowID').val();
						 	var ID=ASRowID+"!"+index+"!"+"1"
						 }else{
						 	var ID=row.ASQRowId+"!"+row.ApptMethodDr+"!"+"1"
						 }
					    return "<input class='textbox' name='AppMethList' id='"+ID+"' value='"+value+"'  onkeyup=Appqtykeyup('"+ID+"') style='width:30px'></input>"
			}
		},
		{field:'AppEndNum',title:'结束号',align:'center',width:100,
			/*formatter: function(value,row,index){
				if (row['AppQty']>0){
					return (+row['AppQty'])+(+row['AppStartNum'])-1;
				}else{
					return "";
				}
			}*/
			formatter: function(value,row,index){
				 if (value==undefined){value=""}
				 if (row.ASQRowId==undefined){
					 	var ASRowID = $('#ASRowID').val();
					 	var ID=ASRowID+"!"+index+"!"+"3"
				 }else{
				  	var ID=row.ASQRowId+"!"+row.ApptMethodDr+"!"+"3"
				 }
				  var endnum=""
				  if ((row.AppStartNum!="")&&(row.AppQty!="")&&(row.AppStartNum!=undefined)&&(row.AppQty!=undefined)){
					  endnum=(parseFloat(row.AppStartNum)+parseFloat(row.AppQty)-1)
				}
				 return "<input class='textbox' name='AppMethList' id='"+ID+"' value='"+endnum+"' disabled='disabled' onkeyup=Appqtykeyup('"+ID+"') style='width:30px' ></input>"
			}
		}
						
	]];
	var ToolBar=[{
			iconCls: 'icon-add',
			text:'新增',
			handler: function(){
				var ASRowID = $('#ASRowID').val();
				if(ASRowID==""){
					$.messager.alert('提示','请先保存排班后再编辑预约方式限额!');
					return false;
				}
				if(PageLogicObj.m_EditRow!=-1){
					$.messager.alert('提示','有正在编辑的行请保存后重试!');
					return false;
				}
				$('#tabAppQtyList').datagrid('appendRow',{});
				var rowArr=$('#tabAppQtyList').datagrid('getRows');
				var rowIndex=rowArr.length-1;
				$('#tabAppQtyList').datagrid("beginEdit", rowIndex);
				PageLogicObj.m_EditRow=rowIndex;
				$($("#datagrid-row-r2-2-"+PageLogicObj.m_EditRow+" td")[8]).children(0)[0].innerHTML='';
			}
		},{
			iconCls: 'icon-cancel',
			text:'删除',
			handler: function(){
				var row=$('#tabAppQtyList').datagrid('getSelected');
				if(!row){
					$.messager.alert('提示','请选择需要删除的行');
					return false;
				}
				$.messager.confirm("提示", "是否删除 <font color=red>"+row['AppMethodName']+" </font>预约方式限额?", function (data){
					if(data){
						var ASQRowId=row.ASQRowId;
						if(ASQRowId){
							var ret=tkMakeServerCall('web.DHCRBApptScheduleAppQty','Delete',ASQRowId);
							if(ret==0){
								$.messager.popover({msg: '删除成功!',type:'success'});
							}else if(ret>0){
								$.messager.alert('提示','删除失败!该预约方式已经存在'+ret+'条预约记录,不能删除!');
								return false;
							}else{
								$.messager.alert('提示','删除失败:'+ret);
								return false;
							}
						}
						$('#tabAppQtyList').datagrid('unselectAll');
						var rowIndex=$('#tabAppQtyList').datagrid("getRowIndex",row);
						$('#tabAppQtyList').datagrid("deleteRow", rowIndex);
						if(PageLogicObj.m_EditRow>rowIndex) PageLogicObj.m_EditRow--;
						else if(PageLogicObj.m_EditRow==rowIndex) PageLogicObj.m_EditRow=-1;
						var rows = $('#tabAppQtyList').datagrid("getRows"); 
						var AppQtySum=0,minEStartPrefix=0;
						for(var i=0;i<rows.length;i++){
							  var oneAppQty =rows[i].AppQty;
							  var oneAppStartNum =rows[i].AppStartNum;
							  var oneAppEndNum =(+oneAppQty)+(+oneAppStartNum)-1;
							  if (oneAppEndNum>AppQtySum) {
								  AppQtySum=+oneAppEndNum;
							  }
						      //AppQtySum=AppQtySum+(+oneAppQty);
							  if (((+oneAppStartNum)<minEStartPrefix)||(minEStartPrefix==0)){
								  if (oneAppStartNum!=""){
								  	  minEStartPrefix=oneAppStartNum;
								  }
							  }
						}
						$("#ApptMax").numberbox('setValue',AppQtySum);
						$("#EStartPrefix").numberbox('setValue',minEStartPrefix);
					}
				});
			}
		},{
			iconCls: 'icon-save',
			text:'保存',
			handler: function(){
				var ErrFind=""
				var ASRowID=$("#ASRowID").val();
				if (ASRowID==""){
					 $.messager.alert("提示","缺少排班信息,不能维护!");
		  			return false;
				}
				//正在编辑的保存
				if(PageLogicObj.m_EditRow!=-1){
					var rtn=SaveAppMetRow(PageLogicObj.m_EditRow)
					if (rtn){
						//$("#tabAppQtyList").datagrid('endEdit',PageLogicObj.m_EditRow);
					}else{
						ErrFind="Y"
						$("#tabAppQtyList").datagrid('beginEdit',PageLogicObj.m_EditRow);
						return false;
					}
				}
				//未编辑的也可以一起保存
				var rows = $('#tabAppQtyList').datagrid("getRows"); 
				var AppQtySum=0,minEStartPrefix=0;
				for(var isave=0;isave<rows.length;isave++){
					if (PageLogicObj.m_EditRow==isave){continue}
					var rtn=SaveAppMetRow(isave)
					if (!rtn){
						ErrFind="Y"	
						return false	
					}else{
						
					}
				}
				
				//保存成功一次性提示
				if (ErrFind==""){
					$.messager.popover({msg: '添加成功!',type:'success'});
					
				}
				
				//保存后重新加载数据
				$('#tabAppQtyList').datagrid('load',{
						ClassName:'web.DHCRBApptScheduleAppQty',
						QueryName:'FindAppQty',
						Arg1:ASRowID,
						ArgCnt:1
				});
				$('#tabAppQtyList').datagrid('unselectAll');
			}
		}];
	var tabAppQtyListDataGrid=$('#tabAppQtyList').datagrid({
		idField:'ASQRowId',
		border:false,
		singleSelect:true,
		columns:Cloumns,
		toolbar:ToolBar,
		fit:true,
		fitColumns:true,
		pagination:false,
		striped:true,
		url : PageLogicObj.m_GridJsonCSP,
		onDblClickRow:function(rowIndex, rowData){
			if (PageLogicObj.m_EditRow==rowIndex){return true} //编辑的是自己不提示
			if(PageLogicObj.m_EditRow!=-1){
				$.messager.alert('提示','有正在编辑的行请保存后重试!');
				return false;
			}
			PageLogicObj.m_EditRow=rowIndex;
			$("#tabAppQtyList").datagrid('beginEdit',rowIndex);
			if (rowData['ApptMethodDr']!=""){
				var et = $("#tabAppQtyList").datagrid('getEditor', {index:rowIndex,field:'AppMethodName'});
				$(et.target).combobox('disable');// 只读
			}
		},
		onAfterEdit:function(rowIndex, rowData, changes){
			
		},
		onLoadSuccess:function(data){
			PageLogicObj.m_EditRow=-1;
		}
		
	});
	return tabAppQtyListDataGrid;
}
function TRFlag_Click(){
	if($("#TRFlag").checkbox('getValue')){
		/*$("#TRSartTime,#TREndTime").timespinner("enable");
		$('#TRLength,#TRRegNum').numberbox('enable');
		$('#TRRegNumStr,#TRRegInfoStr').attr('disabled',false);
		var SessTimeStart=$("#StartTime").timespinner('getValue');
		var SessTimeEnd=$("#EndTime").timespinner('getValue');
		$('#TRSartTime').timespinner('setValue',SessTimeStart);
		$('#TREndTime').timespinner('setValue',SessTimeEnd);*/
		$('#pTREdit').show();
        $("#tabTRInfo,#tabTRAppMethodInfo").datagrid("resize");
        var data=GetElementValue('tabTRInfo');
        if(!data.length){
            $('#TRGenWin').window('open');
            var ASRowID=$("#ASRowID").val();
            var TRASLoad=$.cm({
			        ClassName:'DHCDoc.OPAdm.Schedule',
			        MethodName:'GetTRASLoad',
			        ASRowID:ASRowID,
			        dataType:"text"
			    },false);
			SetElementValue('TRASLoad',TRASLoad);
			SetElementValue('IntervalTime',"");
            GenWayChecked();
        }
	}else{
		 $('#pTREdit').hide();
		/*$("#TRSartTime,#TREndTime").timespinner("disable");
		$('#TRLength,#TRRegNum').numberbox('disable');
		$('#TRRegNumStr,#TRRegInfoStr').attr('disabled',true);*/
	}
	var ASRowID=$("#ASRowID").val();
	if (ASRowID!=""){
		//$('#TRSartTime,#TREndTime').timespinner("disable");
	}
}
function Calc_TRInfo(){
	/*var TRStartTime=$("#TRSartTime").timespinner('getValue');  
	var TREndTime=$("#TREndTime").timespinner('getValue');
	var TRLength=$("#TRLength").numberbox('getValue');
	var TRRegNum=$("#TRRegNum").numberbox('getValue');
	var TRStartNum=$("#EStartPrefix").numberbox('getValue');
	if((TRStartTime!="")&&(TREndTime!="")&&(TRLength!="")&&(TRRegNum!="")&&(TRStartNum!=""))
		TRInfoCalculate(TRStartTime,TREndTime,TRLength,TRRegNum,TRStartNum);*/
}
function formatdate(Date){
	return tkMakeServerCall("web.DHCBatchStopNew","FormatStringToDate",Date,ServerObj.sysDateFormat);
}
function formattime(Time){
	return tkMakeServerCall("web.DHCBatchStopNew","FormatStringToTime",Time);
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
	    }
    });
}
function destroyDialog(id){
   //移除存在的Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}
function AuditStatusAgain(ASRowid){
	var rtn= tkMakeServerCall("web.DHCRBApptScheduleAudi","AuditStatusAgain",ASRowid,session['LOGON.USERID']);
	if (rtn=="0"){
		$.messager.alert('提示','成功提交审批!',function(){
		});
		ReLoadScheduleGrid();
	}else{
		$.messager.alert('提示',rtn,function(){
				ReLoadScheduleGrid();
			});
	}
}
function Trim(str,is_global){
    var result;
    result = str.replace(/(^\s+)|(\s+$)/g,"");
    if(is_global.toLowerCase()=="g"){
        result = result.replace(/\s/g,"");
    }
    return result;
}
///lxz 预约限额联动触发
function Appqtykeyup(idinput)
{
	var idstr=idinput.split("!")
	var id=idstr[0]
	var meth=idstr[1]
	var sx=idstr[2]
	var value1=""
	var obj=document.getElementById(idinput);
	if (obj){
		value1=obj.value
		if (value1==""){return}
		if (isNaN(value1)){
			$.messager.alert("提示","请输入有效数字!","info",function(){
				obj.value=""
			});
		}
		var ot=""
		if (sx==1){
				var ot=2
				var otid=id+"!"+meth+"!"+ot
				var value2=""
				var obj3=document.getElementById(otid);
				if (obj3){value2=obj3.value}
				if (value2!=""){
					var num=""
					var num=(parseFloat(value2)+parseFloat(value1)-1)
					if (num<0){num=0}
					var obj1=document.getElementById(id+"!"+meth+"!"+3);	
					if(obj1){obj1.value=num}
				}
		
			}else if(sx==2) {
				ot=1
				var otid=id+"!"+meth+"!"+ot
				var value2=""
				var obj2=document.getElementById(otid);
				if (obj2){value2=obj2.value}
				if (value2!=""){
					var num=""
					var num=(parseFloat(value1)+parseFloat(value2)-1)
					if (num<0){num=0}
					var obj1=document.getElementById(id+"!"+meth+"!"+3);	
					if(obj1){obj1.value=num}
				}
		}
	}	
}
///保存一行预约方式下的数据
function SaveAppMetRow(rowSave){	
	var reg = /^[1-9]\d*$/;
	var row=$('#tabAppQtyList').datagrid("selectRow",rowSave).datagrid("getSelected");
	var ApptMethodDr=row['ApptMethodDr'];
	var ASQRowId=row['ASQRowId'];
	if (ASQRowId==undefined){
		var ASRowID = $('#ASRowID').val();
		var idfget=ASRowID+"!"+rowSave
	}else{
		var idfget=ASQRowId+"!"+ApptMethodDr
	}

	//lxz 获取数量 
	var id1=idfget+"!"+1 //预约数量
	var id2=idfget+"!"+2 //开始号
	var id3=idfget+"!"+3 //结束号

	var AppQty =  document.getElementById(id1).value
	var AppStartNum= document.getElementById(id2).value
	if (!reg.test(AppQty)&&(AppQty!=0)){
		$.messager.alert('提示','预约限额只能为正整数!');
		return false;
	}
	if (!reg.test(AppStartNum)&&(AppQty!=0)){
		$.messager.alert('提示','预约起始号只能为正整数!');
		return false;
	}

	if (ASQRowId==undefined){ASQRowId="";}
	var ASRowID = $('#ASRowID').val();
	var tab = $('#ScheduleTab').tabs('getSelected');
	var scheduleindex = $('#ScheduleTab').tabs('getTabIndex',tab);
	var GridId="ScheduleGrid"+scheduleindex
	var scheduleindex=$("#"+GridId).datagrid('getRowIndex',ASRowID);
	var scheduleRow=$("#"+GridId).datagrid('getData')['rows'][scheduleindex];
	if (scheduleRow){
		var ASLoad=scheduleRow['ASLoad']; //正号限额
	}else{
		var ASLoad=tkMakeServerCall("web.DHCRBApptScheduleAppQty","GetASLoad",ASRowID);
	}
	var rows = $('#tabAppQtyList').datagrid("getRows"); 
	var AppQtySum=0,minEStartPrefix=0;
	for(var i=0;i<rows.length;i++){
		  var oneAppQty =rows[i].AppQty;
		  var oneASQRowId=rows[i].ASQRowId;
		  var oneApptMethodDr=rows[i].ApptMethodDr;
		  if (!oneApptMethodDr){
			  $.messager.alert("提示","请选择预约方式!");
			  return false;
		  }
		  if (oneASQRowId!=undefined){
			  var oneidfget=oneASQRowId+"!"+oneApptMethodDr
		  }else{
			  var oneidfget=ASRowID+"!"+i
		  }
		  var oneid1=oneidfget+"!"+1 //预约数量
		  var oneid2=oneidfget+"!"+2 //开始号
		  var oneid3=oneidfget+"!"+3 //结束号
		  
		  var AppEndNum = document.getElementById(oneid3).value
		  var oneAppStartNum=document.getElementById(oneid2).value
		  
	      if (AppEndNum>(+ASLoad)){
			  $.messager.alert("提示","预约方式结束号"+AppEndNum+"不能大于正号限额:"+ASLoad+",请修改预约起始号或数量!");
			  return false;
		  }
	      //AppQtySum=AppQtySum+(+oneAppQty);
	      if (AppEndNum>AppQtySum){
		      AppQtySum=+AppEndNum
		  }
		  if (((+oneAppStartNum)<minEStartPrefix)||(minEStartPrefix==0)){
			   if (oneAppStartNum!=""){
			  		minEStartPrefix=oneAppStartNum;
			   }
		  }
	}
	if (AppQtySum>ASLoad){
		 $.messager.alert('提示', "预约限额不能大于正号限额: "+ASLoad);
		  return false;
	}
	if(!ASQRowId){
		if(ASRowID==""){
			$.messager.alert('提示','请先保存排班后再编辑预约方式限额!');
			return false;
		}
		var ret=tkMakeServerCall('web.DHCRBApptScheduleAppQty','NewAppMethod',ASRowID,ApptMethodDr,AppQty,AppStartNum);
		var retArr=ret.split("^");
		if(retArr[0]==0){
			$("#ApptMax").numberbox('setValue',AppQtySum);
			$("#EStartPrefix").numberbox('setValue',minEStartPrefix);
		}else{
			$.messager.alert('提示','添加失败:'+ret,function(){
				$('#tabAppQtyList').datagrid("beginEdit", PageLogicObj.m_EditRow);
			});
			return false;
		}
	}else{
		if (ASRowID==""){
			var ASQRowIdArr=ASQRowId.split("||");
		    var ASRowID=ASQRowIdArr[0]+"||"+ASQRowIdArr[1];
			$("#ASRowID").val(ASRowID);
		}
		var Para=ASQRowId+"^"+ApptMethodDr+"^"+AppQty+"^"+AppStartNum;
		var ret=tkMakeServerCall('web.DHCRBApptScheduleAppQty','Update',ASRowID,Para);
		if(ret==0){
			$("#ApptMax").numberbox('setValue',AppQtySum);
			$("#EStartPrefix").numberbox('setValue',minEStartPrefix);
		}else if(ret==100){
			$.messager.alert('提示','该预约方式已预约数量大于维护的限额'+AppQty);
			return false;
		}else{
			$.messager.alert('提示','更新失败:'+ret);
			return false;
		}
	}
	return true;	
}
function CopySchedule(type){
	PageLogicObj.m_CopyScheduleASRowIDStr="";
	var tab = $('#ScheduleTab').tabs('getSelected');
	 var index = $('#ScheduleTab').tabs('getTabIndex',tab);
	 var GridId="ScheduleGrid"+index;
	 var rows=$("#"+GridId).datagrid("getSelections");
	 var idStr="";
	 for(var i=0;i<rows.length;i++){
		if(idStr==""){
			idStr=rows[i].ASRowId;
		}else{
			idStr=idStr+"^"+rows[i].ASRowId;
		}
	 }
	 if(idStr==""){
		$.messager.alert("提示","请选择要复制的排班记录!");
		return false;
	 }
	 if (type=="ONE"){
		 if(idStr.split("^").length>1){
			 $.messager.alert("提示","请选择单个排班进行复制操作!");
			 return false;
		 }
		 ClearCopyOneScheduleData();
		 //初始化页面数据
	 	 InitCopyOneScheduleData();
	 }else{
		 //$("#CopyToDate").datebox('setValue','');
	 }
	 $("#CopyToDate,#CopyToDate1").val('');
	 PageLogicObj.m_CopyScheduleASRowIDStr=idStr;
	 if (type=="ONE"){
	 	$("#CopyOneScheduleWin").window("open");
	 }else{
	 	$("#CopyMulScheduleWin").window("open");
	 }
	 //$("#CopyToDate").next('span').find('input').focus();
}
function ClearCopyOneScheduleData(){
	$("#CopyToLoc").val("");
	$("#CopyToDoc,#CopyToTimeRange").combobox('select','');
	//$("#CopyToDate").datebox('setValue','');
	$("#CopyToDate").val("");
}
function InitCopyOneScheduleData(){
	var HospitalDr=$HUI.combogrid('#_HospUserList').getValue();
	var tab = $('#ScheduleTab').tabs('getSelected');
	var index = $('#ScheduleTab').tabs('getTabIndex',tab);
	var GridId="ScheduleGrid"+index;
	var rows=$("#"+GridId).datagrid("getSelections");
	$("#CopyToLoc").val(rows[0]['LocDesc']);
	InitSingleCombo('CopyToDoc','RowId','Desc','','',"");
	InitSingleCombo('CopyToTimeRange','RowId','Desc','web.DHCApptScheduleNew','LookUpTimeRange',"&Arg1="+ServerObj.CurrDate.split("^")[0]+"&Arg2="+HospitalDr+"&ArgCnt=2");
	InitCopyToDoc(rows[0]['LocDr']);
}
function CopyScheduleSave(type){
	if (type=="ONE"){
		var CopyToDate=Trim($("#CopyToDate").val(),"g"); //.datebox('getValue');
		if (CopyToDate==""){
			$.messager.alert("提示","请选择复制到日期!","info",function(){
				$("#CopyToDate").focus(); //.next('span').find('input').focus();
			});
			return false;
		}
		var CopyToDoc=$("#CopyToDoc").combobox("getValue");
		if (!CopyToDoc) {
			$.messager.alert("提示","请选择复制到医生!","info",function(){
				$("#CopyToDoc").next('span').find('input').focus();
			});
			return false;
		}	
		var CopyToTimeRange = $("#CopyToTimeRange").combobox("getValue");
		if (!CopyToTimeRange) {
			$.messager.alert("提示","请选择复制到时段!","info",function(){
				$("#CopyToTimeRange").next('span').find('input').focus();
			});
			return false;
		}
	}else{
		var CopyToDate=Trim($("#CopyToDate1").val(),"g"); //$("#CopyToDate1").datebox('getValue');
		if (CopyToDate==""){
			$.messager.alert("提示","请选择复制到日期!","info",function(){
				$("#CopyToDate1").focus(); //.next('span').find('input').focus();
			});
			return false;
		}
		var CopyToDoc="",CopyToTimeRange="";
	}
	var Ret=$.cm({
	    ClassName : "web.DHCRBApptSchedule",
	    MethodName : "CopyScheduleNew",
	    CopyFromRBASIdStr:PageLogicObj.m_CopyScheduleASRowIDStr,
	    CopyToDateStr:CopyToDate,
	    CopyToDocDr:CopyToDoc,
	    CopyToTimeRangeDr:CopyToTimeRange,
	    ExpStr:session['LOGON.GROUPID']+"^"+session['LOGON.USERID'],
	    dataType:"text"
	},false);	
	var temparr=Ret.split("^");
	var ret=temparr[0];
	if (ret=="0"){
		var RequestFlag=temparr[2];
		var msg="复制排班记录成功,请根据情况修改限额!"
		if(RequestFlag.indexOf("Y")>=0){
			var msg="复制排班记录成功,请等待相关人员审批!";
		}
		$.messager.alert('提示', msg,"info",function(){
			if (type=="ONE"){
				PageLogicObj.m_CopyScheduleASRowIDStr="";
				$("#CopyOneScheduleWin").window("close");
				var tabs=$('#ScheduleTab').tabs('tabs');
				var newSelIndex="";
				for (var i=0;i<tabs.length;i++){
					var title=tabs[i].panel("options").title;
					if (title.indexOf(CopyToDate)>=0){
						newSelIndex=i;
						break;
					}
				}
				if (newSelIndex!==""){
					var ASRowid=temparr[1];
					ASRowid=ASRowid.split(String.fromCharCode(1))[0];
					var tab = $('#ScheduleTab').tabs('getSelected');
					var index = $('#ScheduleTab').tabs('getTabIndex',tab);
					
					//var TreeSelStr=GetLocDocTreeSel();
					//var TreeSelStrArr=TreeSelStr.split("!");
					//var LocRowid=TreeSelStrArr[0],ExaRowid=TreeSelStrArr[1],DocRowid=TreeSelStrArr[2];
					var selDataObj=GetLocDocTreeSel();
					var LocRowid=selDataObj.LocRowid;
					var ExaRowid=selDataObj.ExaRowid;
					var DocRowid=selDataObj.DocRowid;
					if (index==newSelIndex){
						var GridId="ScheduleGrid"+index;
						if (DocRowid!=""){
							var node = $('#LocDocTree').tree('find', "Doc^"+CopyToDoc);
							$('#LocDocTree').tree('select', node.target);
						}else{
							$("#"+GridId).datagrid('uncheckAll').datagrid('load');
						}
					}else{
						$('#ScheduleTab').tabs('select',newSelIndex);
						var GridId="ScheduleGrid"+newSelIndex;
						setTimeout(function(){
							if (DocRowid!=""){
								var node = $('#LocDocTree').tree('find', "Doc^"+CopyToDoc);
								$('#LocDocTree').tree('select', node.target);
							}
						},1000)
					}
					setTimeout(function(){
						var GridIndex=$("#"+GridId).datagrid('uncheckAll').datagrid("getRowIndex",ASRowid);
						if (GridIndex>=0) {
							$("#"+GridId).datagrid("checkRow",GridIndex);
							UpdateOneSchedule(); 
						}
					},1000);
				}
			}else{
				$("#CopyMulScheduleWin").window("close");
			}
		});
		return true;
	}else{
		$.messager.alert('提示', "复制失败!"+temparr[0]);
	}
}
function InitCopyToDoc(LocDr){
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCApptScheduleNew';
	queryParams.QueryName ='FinNoRegDoc'; 
	queryParams.Arg1 ="";
	queryParams.Arg2 =LocDr;
	queryParams.Arg3 ="";
	queryParams.Arg4 ="";
	queryParams.ArgCnt =4;
	InitComboData('#CopyToDoc',queryParams)
}
function UpdateOneSchedule(){
	var tab = $('#ScheduleTab').tabs('getSelected');
	var index = $('#ScheduleTab').tabs('getTabIndex',tab);
	var GridId="ScheduleGrid"+index;
	var rows=$("#"+GridId).datagrid("getSelections");
	var idStr="";
	for(var i=0;i<rows.length;i++){
		if(idStr==""){
			idStr=rows[i].ASRowId;
		}else{
			idStr=idStr+"^"+rows[i].ASRowId;
		}
	}
	if(idStr==""){
		$.messager.alert("提示","请选择要修改排班的排班记录!");
		return false;
	}
	if(idStr.split("^").length>1){
	   $.messager.alert("提示","请选择单个排班进行修改排班操作!");
	   return false;
	}
	var Status=rows[0].ASStatus;
	if (PageLogicObj.m_tabAppQtyListDataGrid==""){
		//PageLogicObj.m_tabAppQtyListDataGrid=InitAppQtyList();
		//PageLogicObj.m_tabAppQtyListDataGrid=InitAppMethodGrid();
		InitAppMethodGrid();
		InitTRDataGrid();
	}
	EditAppSchedule(rows[0].ASRowId);
	LoadApptabAppMethodInfo(rows[0].ASRowId)
	LoadtabTRInfo(rows[0].ASRowId)
	$("#EditWin").window('setTitle','修改排班 <font color="yellow">'+rows[0].LocDesc+ ' ' +rows[0].DocDesc+'</font>');
}
/*function GetLocDocTreeSel(){
	var LocRowid="",ExaRowid="",DocRowid="";
	var selObj=$("#LocDocTree").tree("getSelected")
	if(selObj){
		var idStr=selObj.id
		var idStrArr=idStr.split("^")
		if(idStrArr[0]=="Loc"){
			LocRowid=idStrArr[1]
			var parentObj=$("#LocDocTree").tree("getParent",selObj.target)
			if (parentObj){
				var idStr=parentObj.id;
		        var idStrArr=idStr.split("^");
		        ExaRowid=idStrArr[1];
			}else{
				ExaRowid=idStrArr[2];
			}
		}else{
			if(idStrArr[0]=="Exa"){
				ExaRowid=idStrArr[1]
			}
			if(idStrArr[0]=="Doc"){
				var DocRowid=idStrArr[1];
				var parentNode=$("#LocDocTree").tree("getParent",selObj.target) ;
				var parentNodeid=parentNode.id ;
				var parentNodeidArr=parentNodeid.split("^")
				var LocRowid=parentNodeidArr[1];
			}
		}
	}
	return ExaRowid+"!"+LocRowid+"!"+DocRowid;
}*/
function TRLengthChange(){
	var TRStartTime=$("#TRSartTime").timespinner('getValue');  
	var TREndTime=$("#TREndTime").timespinner('getValue');
	var TRLength=$("#TRLength").val(); //.numberbox('getValue')
	if ((TRStartTime=="")||(TREndTime=="")||(TRLength=="")){
		$("#tips").html("");
	}else{
		var Min=getMinute(TRStartTime,TREndTime);
		$("#tips").html("为保证时段内有号,最小时段号数为"+Math.ceil(Min/TRLength));
	}
}
function getMinute(s1, s2) {
    var reDate = /\d{4}-\d{1,2}-\d{1,2} /;
    s1 = new Date((reDate.test(s1) ? s1 : '2017-1-1 ' + s1).replace(/-/g, '/'));
    s2 = new Date((reDate.test(s2) ? s2 : '2017-1-1 ' + s2).replace(/-/g, '/'));
    var ms = s2.getTime() - s1.getTime();
    if (ms < 0) return 0;
    return Math.ceil(ms / 1000 / 60);
}
function GetLocDocTreeSel(){
	var selDataObj={
		LocRowid:"",LocDesc:"",
		ExaRowid:"",
		DocRowid:"",DocDesc:"",
	};
	//判断科室有没有被选中的
	var selObj=$("#LocDocTree").tree("getSelected")
	if(selObj){
		var idStr=selObj.id
		var idStrArr=idStr.split("^")
		if(idStrArr[0]=="Loc"){
			selDataObj.LocRowid=idStrArr[1];
			selDataObj.LocDesc=selObj.text;
			var parentObj=$("#LocDocTree").tree("getParent",selObj.target)
			if (parentObj){
				var idStr=parentObj.id;
		        var idStrArr=idStr.split("^");
		        selDataObj.ExaRowid=idStrArr[1];
			}else{
				selDataObj.ExaRowid=idStrArr[2];
			}
		}else{
			if(idStrArr[0]=="Exa"){
				selDataObj.ExaRowid=idStrArr[1]
			}
			if(idStrArr[0]=="Doc"){
				selDataObj.DocRowid=idStrArr[1];
				selDataObj.DocDesc=selObj.text;
				var parentNode=$("#LocDocTree").tree("getParent",selObj.target) ;
				var parentNodeid=parentNode.id ;
				var parentNodeidArr=parentNodeid.split("^")
				selDataObj.LocRowid=parentNodeidArr[1];
				selDataObj.LocDesc=parentNode.text;
			}
		}
	}
	return selDataObj;
}
function UpdateScheTabStyle(tabId){
	$(".tabItem_badge").remove();
	var opts=$("#"+tabId).datagrid("options");
	var queryParams=opts.queryParams;
	if ((queryParams.Arg1!="")||(queryParams.Arg2!="")){
		var ArgCnt=queryParams.ArgCnt;
		var obj={};
		for (var i=0;i<ArgCnt;i++) {
			var ArgN="Arg"+(i+1);
			obj[ArgN]=queryParams[ArgN];
		}
		obj["Arg10"]=2;
		obj["Arg14"]=$HUI.combogrid('#_HospUserList').getValue();;
		var FirstTab = $('#ScheduleTab').tabs('getTab',0);
		var FirstTabTitle=FirstTab.panel("options").title;
		var FirstTabDate=FirstTabTitle.split("(")[0];
		var AdmDateStr=tkMakeServerCall("web.DHCApptScheduleNew","GetAdmDateStr",FirstTabDate,JSON.stringify(obj))
		var AdmDateStrArr=AdmDateStr.split("^")
		for(var i=0;i<AdmDateStrArr.length;i++){
			var admDate=AdmDateStrArr[i].split(String.fromCharCode(1))[0];
			var ExistScheduleFlag=AdmDateStrArr[i].split(String.fromCharCode(1))[1];
			if (ExistScheduleFlag==1){
				$($(".tabs li a")[i]).append('<sup class="tabItem_badge"></sup>');
			}
		}
	}
}
function PlanScheduleCheckChg(){
	var tab = $('#ScheduleTab').tabs('getSelected');
	var index = $('#ScheduleTab').tabs('getTabIndex',tab);
	var tabId="ScheduleGrid"+index;
	var opts=$("#"+tabId).datagrid("options");
	var queryParams=opts.queryParams; 
	$.extend(queryParams, { Arg11:$("#PlanSchedule").checkbox("getValue")});
	$("#"+tabId).datagrid("reload",queryParams);
}

///新的预约号修改代码
function InitAppMethodGrid()
{
    $('#tabAppMethodInfo').datagrid({
        url:'',
        fit : true,
		border : false,
		striped : true,
		rownumbers:false,
		fitColumns : true,
		autoRowHeight : false,
		pagination : true, 
		idField:"ASAMRowid",   
		singleSelect:true,
		pageSize: 15,
		pageList : [15,100,200],
        columns:[[
            {field:'ASAMRowid',hidden:true},
            {field:'AppMethodID',hidden:true},
            {field:'AppMethod',title:'预约方式',align:'center',width:170,
                editor:{
                    type:'combobox',
                    options:{
	                    editable:false,  //不能编辑
                        onBeforeLoad:function(param){
                            param.ClassName='DHCDoc.OPAdm.Schedule';
                            param.QueryName='QueryAppMethod';
                            param.ArgCnt=0;
                        }
                    }
                }
            },
            {field:'MaxQty',title:'最大预约数',align:'center',width:100,
                editor:{type:'numberbox',options:{min:0,
                    onChange:function(val,oldVal){
                        QtyChange('tabAppMethodInfo',this);
                    }
                }
            }
            },
            {field:'ReserveQty',title:'保留数',align:'center',width:100,
                editor:{type:'numberbox',options:{min:0,
                    onChange:function(val,oldVal){
                        QtyChange('tabAppMethodInfo',this);
                    }
                }
            }
            }
        ]],
        toolbar:[{
            text:'增加',
            iconCls:'icon-add',
            handler:function(){
                $('#tabAppMethodInfo').datagrid('appendRow',{});
                var rows=$('#tabAppMethodInfo').datagrid('getRows');
                $('#tabAppMethodInfo').datagrid('beginEdit',rows.length-1);
            }
        },{
            text:'删除',
            iconCls:'icon-remove',
            handler:function(){
                var AMData=GetElementValue('tabAppMethodInfo');
                var oldAMData=new Array();
                for(var i=0;i<AMData.length;i++){
                    if(!AMData[i].AppMethodID) continue;
                    oldAMData.push($.extend({},$.extend({},AMData[i])));
                }
                var Selected=$('#tabAppMethodInfo').datagrid('getSelected');
                if(!Selected){
                    $.messager.popover({msg:"请选择需要删除的行!",type:'alert'});
                    return;
                }
                var index=$('#tabAppMethodInfo').datagrid('getRowIndex',Selected);
                $('#tabAppMethodInfo').datagrid('deleteRow',index);
                if(!AppMethodQtySave()){
                    SetElementValue('tabAppMethodInfo',oldAMData);
                }
            }
        },{
            text:'保存',
            iconCls:'icon-save',
            handler:function(){
	            var rows=$('#tabAppMethodInfo').datagrid('getRows');
			    if (rows.length==0) {
				    $.messager.alert('提示', "没有需要保存的数据!");
					return false;
				}
                AppMethodQtySave();
            }
        }],
        onDblClickRow:function(index,row){
	        $(this).datagrid("selectRow",index).datagrid('beginEdit',index);
        },
        onBeginEdit:function(index, row){
            var ed = $(this).datagrid('getEditor', {index:index,field:'AppMethod'});
            SetElementValue(ed.target,row.AppMethodID);
            AddDGTBSaveTip('tabAppMethodInfo');
        }
    });
    var ASRowID=$("#ASRowID").val();
	if (ASRowID!=""){
    	LoadApptabAppMethodInfo(ASRowID)
	}
}
function InitTRDataGrid()
{
    $('#tabTRInfo').datagrid({
        url:'',
        singleSelect:true,
        fit : true,
		border : false,
		striped : true,
		rownumbers:true,
		fitColumns : true,
		autoRowHeight : false,
		pagination : true,
		pageSize: 15,
		pageList : [15,100,200],
        columns:[[
            {field:'ASTRRowid',hidden:true},
            {field:'SttTime',title:'开始时间',align:'center',width:150},
            {field:'EndTime',title:'结束时间',align:'center',width:150},
            {field:'Load',title:'数量',align:'center',width:100,
                editor:{type:'numberbox',options:{min:1}}
            },
            {field:'tabTRAppMethodInfo',hidden:true}
        ]],
        toolbar:[{
            text:'保存',
            iconCls:'icon-save',
            handler:function(){
	            var ASRowID=$("#ASRowID").val();
				if (ASRowID==""){
					$.messager.alert('提示', "请先保存排班信息","info",function(){
						$("#BSave").focus();
					});
					return false;
				}
	            if(CheckGridEditing('tabTRAppMethodInfo')){
                    $.messager.popover({msg:"请先保存分时段预约方式后再进行分时段操作",type:'alert'});
                    return false;
                }
                var AppedCount=tkMakeServerCall("web.DHCRBApptSchedule","GetAppedSeqNoCount",ASRowID);
                var RegCount=tkMakeServerCall("web.DHCRBApptSchedule","GetRegSeqNoCount",ASRowID);
                var SumRegApp=parseFloat(AppedCount)+parseFloat(RegCount)
                if (SumRegApp>=1){
					    if (!(dhcsys_confirm("排班信息已存在预约和挂号记录，如果生成分时段数据会导致号序混乱，是否保存"))) return false;
					}
                var total=0;
                var rows=$('#tabTRInfo').datagrid('getData').originalRows;
                for(var i=0;i<rows.length;i++){
                    var Editors=$('#tabTRInfo').datagrid('getEditors',i);
                    if(Editors.length){
                        rows[i].Load=GetElementValue(Editors[0].target);
                    }
                    if(rows[i].Load==""){
                        $.messager.popover({msg:'分时段限额不能为空',type:'error'});
                        return;
                    }
                    total+=Number(rows[i].Load);
                    if (rows[i].tabTRAppMethodInfo){
	                    var ResverNum=0,MaxQty=0;
	                    for (var j=0;j<rows[i].tabTRAppMethodInfo.length;j++){
		                    var OneReserveQty= rows[i].tabTRAppMethodInfo[j].ReserveQty;
		                    var OneMaxQty= rows[i].tabTRAppMethodInfo[j].MaxQty;
		                    ResverNum=parseFloat(ResverNum)+parseFloat(OneReserveQty);
		                    if (OneMaxQty>MaxQty) {
			                    MaxQty=OneMaxQty;
			                }
		                }
	                    if (parseFloat(ResverNum)>parseFloat(rows[i].Load)){
		                    $.messager.popover({msg:'分时段限额中预约方式的总保留数应该小于分时段限额',type:'error'});
	                        return;
		                }
		                if (parseFloat(MaxQty)>parseFloat(rows[i].Load)){
			                $.messager.popover({msg:'分时段限额中预约方式的最大预约数应该小于分时段限额',type:'error'});
	                        return;
			            }
                    }
                }
                var PositiveMaxLoad=$("#PositiveMax").numberbox('getValue');
                if (PositiveMaxLoad!=total){
					$.messager.popover({msg:"正号限额不等于分时段数量总和",type:'error'});
			        return false;
			    }
                SetElementValue('tabTRInfo',rows);
                AddSaveTip($('#BUpdate').find('.l-btn-text'));
                ScheduleObj=GetElementValue('tabTRInfo');
                var retJson=$.cm({
			        ClassName:'DHCDoc.OPAdm.Schedule',
			        MethodName:'UpdateTRInfoNew',
			        ASRowid:ASRowID,
			        TRInfoObjStr:JSON.stringify(ScheduleObj),
			        dataType:"json"
			    },false);
			    if (retJson=="0"){
				    $.messager.popover({msg:"保存成功!",type:'success'});
				    LoadtabTRInfo(ASRowID)
				}
            }
        },'-',{
            text:'重新生成',
            iconCls:'icon-init',
            handler:function(){
	            var ASRowID=$("#ASRowID").val();
	            if (ASRowID=="") return;
                if(CheckGridEditing('tabAppMethodInfo')){
                    $.messager.popover({msg:"请先保存预约方式后再进行分时段操作",type:'alert'});
                    return false;
                }
                
                var AppedCount=tkMakeServerCall("web.DHCRBApptSchedule","GetAppedSeqNoCount",ASRowID);
                var RegCount=tkMakeServerCall("web.DHCRBApptSchedule","GetRegSeqNoCount",ASRowID);
                var SumRegApp=parseFloat(AppedCount)+parseFloat(RegCount)
                if (SumRegApp>=1){
					    if (!(dhcsys_confirm("排班信息已存在预约和挂号记录，如果生成分时段数据会导致号序混乱，是否生成"))) return false;
					}
                $('#TRGenWin').window('open');
                 var TRASLoad=$.cm({
			        ClassName:'DHCDoc.OPAdm.Schedule',
			        MethodName:'GetTRASLoad',
			        ASRowID:ASRowID,
			        dataType:"text"
			    },false);
				SetElementValue('TRASLoad',TRASLoad);
				SetElementValue('IntervalTime',"");
				GenWayChecked();
            }
        },'-',{
            text:'另存为模板',
            iconCls:'icon-save-to',
            handler:function(){
                var Data=GetElementValue('tabTRInfo');
                if(!Data.length){
                    $.messager.alert('提示','没有时段数据不能保存');
                }else{
                    $('#TRTempSaveWin').window('open');
                    $("#TempName").val("").focus();
                    GenWayChecked()
                }
            }
        }],
        onDblClickRow:function(index,row){
            $(this).datagrid('beginEdit',index);
        },
        onBeforeSelect:function(index,row){
            if(CheckGridEditing('tabAppMethodInfo')){
                $.messager.popover({msg:"请先保存预约方式后再进行分时段操作",type:'alert'});
                return false;
            }
            if(CheckGridEditing('tabTRAppMethodInfo')){
                var UnsaveFlag=confirm('有未保存的分时段预约方式信息,是否继续:');
                if (UnsaveFlag==false){
	               return UnsaveFlag;
	            }else{
		           return CheckBeforAppMedthod();
		        }
            }
            return true;
        },
        onSelect:function(index,row){
            var tabTRAppMethodInfo=row.tabTRAppMethodInfo;
            if(!tabTRAppMethodInfo) tabTRAppMethodInfo=[];
            if(typeof(tabTRAppMethodInfo)=='string'){
                tabTRAppMethodInfo=JSON.parse(tabTRAppMethodInfo);
            }
            SetElementValue('tabTRAppMethodInfo',tabTRAppMethodInfo);
        },
        onLoadSuccess:function(data){
            $(this).datagrid('unselectAll');
            SetElementValue('tabTRAppMethodInfo',[]);
            if(GetElementValue('TRFlag')){
                ResetASLoad();
            }
            DeleteDGTBSaveTip('tabTRInfo');
        },
        onBeginEdit:function(){
            AddDGTBSaveTip('tabTRInfo');
        },
        onAfterEdit:function(index, row, changes){
            ResetASLoad();
        }
    }).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter});
    var ASRowID=$("#ASRowID").val();
    if (ASRowID!=""){
    	LoadtabTRInfo(ASRowID)
    }
	var tabTRAppMethodInfoEditRow=""
    function ResetASLoad()
    {
        var ASLoad=0;
        var rows=GetElementValue('tabTRInfo');
        for(var i=0;i<rows.length;i++){
            ASLoad+=Number(rows[i].Load);
        }
        SetElementValue('ASLoad',ASLoad);
        //ASQtyChange("",'#ASLoad');
    }
    $('#tabTRAppMethodInfo').datagrid({
        url:'',
        fit : true,
		border : false,
		striped : true,
		rownumbers:true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
        columns:[[
            {field:'TRAMRowid',hidden:true},
            {field:'AppMethodID',hidden:true},
            {field:'AppMethod',title:'预约方式',align:'center',width:250,
                editor:{
                    type:'combobox',
                    editable:false,  //不能编辑
                    options:{
                        onBeforeLoad:function(param){
                            param.ClassName='DHCDoc.OPAdm.Schedule';
                            param.QueryName='QueryAppMethod';
                            param.ArgCnt=0;
                        }
                    }
                }
            },
            {field:'MaxQty',title:'最大预约数量',align:'center',width:100,
                editor:{type:'numberbox',options:{min:0,
                    onChange:function(val,oldVal){
                        QtyChange('tabTRAppMethodInfo',this);
                    }
                }
            }
            },
            {field:'ReserveQty',title:'保留数量',align:'center',width:100,
                editor:{type:'numberbox',options:{min:0,
                    onChange:function(val,oldVal){
                        QtyChange('tabTRAppMethodInfo',this);
                    }
                }
            }
            }
        ]],
        toolbar:[{
            text:'增加',
            iconCls:'icon-add',
            handler:function(){
                var TRInfoSelected=$('#tabTRInfo').datagrid('getSelected');
                if(!TRInfoSelected){
                    $.messager.popover({msg:'请选择时段后再维护时段预约方式',type:'error'});
                    return;
                }
                $('#tabTRAppMethodInfo').datagrid('appendRow',{});
                var rows=$('#tabTRAppMethodInfo').datagrid('getRows');
                $('#tabTRAppMethodInfo').datagrid('beginEdit',rows.length-1);
                tabTRAppMethodInfoEditRow=rows.length-1
            }
        },{
            text:'删除',
            iconCls:'icon-remove',
            handler:function(){
                var Selected=$('#tabTRAppMethodInfo').datagrid('getSelected');
                if((!Selected)&&(tabTRAppMethodInfoEditRow!="")){
                    $.messager.popover({msg:'请选择需要删除的行',type:'alert'});
                    return;
                }
                if (Selected){
               		var index=$('#tabTRAppMethodInfo').datagrid('getRowIndex',Selected);
               	}else{
	                var index=tabTRAppMethodInfoEditRow
	               }
                $('#tabTRAppMethodInfo').datagrid('deleteRow',index);
                AddDGTBSaveTip('tabTRAppMethodInfo');
                //$('#tabTRAppMethodInfo').datagrid('options').toolbar[4].handler();
            }
        },{
            text:'保存',
            iconCls:'icon-save',
            handler:function(){
                var CheckFlag=CheckBeforAppMedthod()
                if (CheckFlag==false) return;
                SetElementValue('tabTRAppMethodInfo',PageLogicObj.m_tabTRAppMethodInfoNewRows);
                var TRInfoSelected=$('#tabTRInfo').datagrid('getSelected');
	            var TRInfoIndex=$('#tabTRInfo').datagrid('getRowIndex',TRInfoSelected);
                TRInfoSelected.tabTRAppMethodInfo=PageLogicObj.m_tabTRAppMethodInfoNewRows;
                var Editors=$('#tabTRInfo').datagrid('getEditors',TRInfoIndex);
                if(Editors.length){
                    TRInfoSelected.Load=GetElementValue(Editors[0].target);
                }
                $('#tabTRInfo').datagrid('updateRow',{index:TRInfoIndex,row:TRInfoSelected});
                AddDGTBSaveTip('tabTRInfo');
            }
        }],
        onDblClickRow:function(index,row){
            $(this).datagrid('beginEdit',index);
            tabTRAppMethodInfoEditRow=index
        },
        onLoadSuccess:function(){
            DeleteDGTBSaveTip('tabTRAppMethodInfo');
        },
        onBeginEdit:function(index, row){
            var ed = $(this).datagrid('getEditor', {index:index,field:'AppMethod'});
            SetElementValue(ed.target,row.AppMethodID);
            AddDGTBSaveTip('tabTRAppMethodInfo');
        }
    });
}
function CheckBeforAppMedthod(){
	var TRInfoSelected=$('#tabTRInfo').datagrid('getSelected');
    if(!TRInfoSelected){
        $.messager.popover({msg:'请选择时段后再维护时段预约方式',type:'error'});
        return false;
    }
    PageLogicObj.m_tabTRAppMethodInfoNewRows=new Array();
	var newRows=new Array();
    var AMArr=new Array();
    var ReserveQtySum=0;
    var TRLoad=Number(GetElementValue('ApptMax'));
    var TRInfoIndex=$('#tabTRInfo').datagrid('getRowIndex',TRInfoSelected);
    var ed = $('#tabTRInfo').datagrid('getEditor', {index:TRInfoIndex,field:'Load'});
    if(ed) TRLoad=GetElementValue(ed.target);
    else TRLoad=TRInfoSelected.Load;
    var TRRows=GetElementValue('tabTRInfo');
    var AppStartNo=Number(GetElementValue('AppStartNo'));
    var LoadSum=0
    for(var i=0;i<TRInfoIndex;i++){ //考虑起始号,才是实际可用号
        var Load=TRRows[i].Load;
        var ed = $('#tabTRInfo').datagrid('getEditor', {index:i,field:'Load'});
        if(ed) Load=GetElementValue(ed.target);
        else Load=TRInfoSelected.Load;
        LoadSum+=Number(Load);
    }
    if(LoadSum<AppStartNo){
        TRLoad=Number(TRLoad)+LoadSum-AppStartNo+1
        if(TRLoad<0) TRLoad=0;
    }
    var rows=GetElementValue('tabTRAppMethodInfo');
    for(var i=0;i<rows.length;i++){
        var Editors=$('#tabTRAppMethodInfo').datagrid('getEditors',i);
        if(Editors.length){
            rows[i].AppMethodID=GetElementValue(Editors[0].target);
            rows[i].AppMethod=$(Editors[0].target).combobox('getText');
            rows[i].MaxQty=GetElementValue(Editors[1].target);
            rows[i].ReserveQty=GetElementValue(Editors[2].target);
        }
        if(rows[i].AppMethodID){
	        if (rows[i].AppMethodID==""){
				 $.messager.alert("提示","请维护预约方式");
                return false;
			}
            if(AMArr[rows[i].AppMethodID]){
	            $.messager.alert("提示",rows[i].AppMethod+"方式重复维护!");
                return false;
            }
            if(rows[i].MaxQty==""){
                $.messager.alert("提示",rows[i].AppMethod+" 最大预约数不能为空!");
                return false;
            }
            if(Number(rows[i].ReserveQty)>Number(rows[i].MaxQty)){
	            $.messager.alert("提示",rows[i].AppMethod+" 方式保留数量不能大于最大预约数量!");
                return false;
            }
            if(Number(rows[i].MaxQty)>Number(TRLoad)){
                $.messager.alert("提示",rows[i].AppMethod+"方式最大预约数量不能超过时段总数:"+TRLoad+"!");
                return false;
            }
            ReserveQtySum+=Number(rows[i].ReserveQty);
            newRows.push(rows[i]);
            AMArr[rows[i].AppMethodID]=1
        }else{
	         $.messager.alert("提示","请维护预约方式");
             return false;
	        }
    }
    if(ReserveQtySum>Number(TRLoad)){
	    $.messager.alert("提示","保留数量合计:"+ReserveQtySum+",不能超过时段总数:"+TRLoad+"!");
        return false;
    }
    if(!ReCheckAppMethod()){
        return false;
    }
    PageLogicObj.m_tabTRAppMethodInfoNewRows=newRows;
    return true;
}
function AppMethodQtySave()
{
    var ASRowID=$("#ASRowID").val();
	if (ASRowID==""){
		$.messager.alert('提示', "请先保存排班信息","info",function(){
			$("#BSave").focus();
		});
		return false;
	}
    var data=$.cm({
        ClassName:'web.DHCRBApptSchedule',
        QueryName:'ApptScheduleListQuery',
        LocationName:"", ClinicGroupName:"", 
        DoctorName:"", ScheduleDate:"", ASRowId:ASRowID, UserID:"",
    },false);
    var AvailAppQty=+data.rows[0].BookNum;
    var NewAvailAppQty=Number(GetElementValue('ApptMax'));
    if (NewAvailAppQty!=AvailAppQty) {
		$.messager.alert("提示","请先保存排班信息!","info",function(){
			$("#ApptMax").focus();
		});
		return false;
	}else if ((NewAvailAppQty=="0")&&(AvailAppQty>0)){
		$.messager.alert('提示', "预约限额为0,请先维护预约","info",function(){
			$("#ApptMax").focus();
		});
		return false;
	}
	var newRows=new Array();
    var AMArr=new Array();
    var TotalQty=0;
    var TRAMArr=GetTRAppMethodInfo();
    var rows=$('#tabAppMethodInfo').datagrid('getRows');
    /*if (rows.length==0) {
	    $.messager.alert('提示', "没有需要保存的数据!");
		return false;
	}*/
    for(var i=0;i<rows.length;i++){
        var Editors=$('#tabAppMethodInfo').datagrid('getEditors',i);
        if(Editors.length){
            rows[i].AppMethodID=GetElementValue(Editors[0].target);
            rows[i].AppMethod=$(Editors[0].target).combobox('getText');
            rows[i].MaxQty=GetElementValue(Editors[1].target);
            rows[i].ReserveQty=GetElementValue(Editors[2].target);
        }
        if(rows[i].AppMethodID){
            if(AMArr[rows[i].AppMethodID]){
                $.messager.popover({msg:rows[i].AppMethod+"方式重复维护!",type:'error'});
                return false;
            }
            if(Number(rows[i].ReserveQty)>Number(rows[i].MaxQty)){
                $.messager.popover({msg:rows[i].AppMethod+" 最大数量不能小于保留数量!",type:'error'});
                return false;
            }
            if(rows[i].MaxQty>AvailAppQty){
                $.messager.popover({msg:'预约方式最大预约数:'+rows[i].MaxQty+',超过可预约的总数量:'+AvailAppQty,type:'error'});
                return false;
            }
            TotalQty+=Number(rows[i].ReserveQty);
            if(TotalQty>AvailAppQty){
                $.messager.popover({msg:'预约方式保留合计:'+TotalQty+',超过可预约的总数量:'+AvailAppQty,type:'error'});
                return false;
            }
            if(TRAMArr[rows[i].AppMethodID]){
                if(Number(TRAMArr[rows[i].AppMethodID].MaxQty)>Number(rows[i].MaxQty)){
                    $.messager.popover({
                        msg:rows[i].AppMethod+'分时段最大预约合计:'+TRAMArr[rows[i].AppMethodID].MaxQty+"大于预约合计:"+rows[i].MaxQty,
                        type:'error'
                    });
                    return false;
                }
                if(Number(TRAMArr[rows[i].AppMethodID].ReserveQty)>Number(rows[i].ReserveQty)){
                    $.messager.popover({
                        msg:rows[i].AppMethod+'分时段保留合计:'+TRAMArr[rows[i].AppMethodID].ReserveQty+"大于保留合计:"+rows[i].ReserveQty,
                        type:'error'
                    });
                    return false;
                }
                delete TRAMArr[rows[i].AppMethodID];
            }
            newRows.push(rows[i]);
            AMArr[rows[i].AppMethodID]=1

        }
    }
    for(var AppMethodID in TRAMArr){
        $.messager.popover({msg:TRAMArr[AppMethodID].AppMethod+'分时段存在维护数据,请先删除分时段预约方式',type:'error'});
        return false;
    }
    SetElementValue('tabAppMethodInfo',newRows);
    DeleteDGTBSaveTip('tabAppMethodInfo');
    //AddSaveTip($('#BUpdate').find('.l-btn-text'));
    
    ScheduleObj=GetElementValue('tabAppMethodInfo');
    var retJson=$.cm({
        ClassName:'DHCDoc.OPAdm.Schedule',
        MethodName:'UpdateAppMethodQtyNew',
        ASRowid:ASRowID,
        ASAppQtyObjStr:JSON.stringify(ScheduleObj),
        UserID:session['LOGON.USERID'],
        dataType:"json"
    },false);
    if (retJson=="0"){
	    $.messager.popover({msg:"保存成功!",type:'success'});
	    $('#tabAppMethodInfo').datagrid("rejectChanges").datagrid("unselectAll");
	    LoadApptabAppMethodInfo(ASRowID)
	}
    return true;
}
function LoadApptabAppMethodInfo(ASRowID){
	var retJson=$.cm({
        ClassName:'DHCDoc.OPAdm.Schedule',
        MethodName:'GetAppMethodsInfo',
        ASRowid:ASRowID,
        dataType:"json"
    },false);
    SetElementValue("tabAppMethodInfo",retJson);
}
function QtyChange(id,that){
    var index=GetDGEditRowIndex(that);
    var Editors=$('#'+id).datagrid('getEditors',index);
    var MaxQty=GetElementValue(Editors[1].target);
    var ReserveQty=GetElementValue(Editors[2].target);
    if(Number(MaxQty)<Number(ReserveQty)) SetElementValue(Editors[1].target,ReserveQty);
    return true;
}
function GetTRAppMethodInfo()
{
    var TRAMArr=new Array();
    var TRData=GetElementValue('tabTRInfo');
    for(var i=0;i<TRData.length;i++){
        var tabTRAppMethodInfo=TRData[i].tabTRAppMethodInfo;
        if(!tabTRAppMethodInfo) tabTRAppMethodInfo=[];
        if(typeof(tabTRAppMethodInfo)=='string'){
            tabTRAppMethodInfo=JSON.parse(tabTRAppMethodInfo);
        }
       var TRAMData=$.extend({},tabTRAppMethodInfo);
        for(var j in TRAMData){
            var AppMethodID=TRAMData[j].AppMethodID;
            if(!AppMethodID) continue;
            if(TRAMArr[AppMethodID]){
               var ReserveQty=Number(TRAMArr[AppMethodID].ReserveQty);
               TRAMArr[AppMethodID].ReserveQty=ReserveQty+Number(TRAMData[j].ReserveQty);
               var MaxQty=Number(TRAMArr[AppMethodID].MaxQty);
               if(MaxQty>Number(TRAMData[j].MaxQty)) TRAMArr[AppMethodID].MaxQty=MaxQty
               //TRAMArr[AppMethodID].MaxQty=MaxQty+Number(TRAMData[j].MaxQty);
            }else{
               TRAMArr[AppMethodID]=$.extend({},TRAMData[j]);
            }
        }
    }
    return TRAMArr;
}
function SaveSchedule()
{
    if(CheckGridEditing('tabAppMethodInfo')){
        $.messager.popover({msg:"请先保存预约方式后再保存",type:'alert'});
        return false;
    }
    if(CheckGridEditing('tabTRInfo')){
        $.messager.popover({msg:"请先保存分时段信息后再保存",type:'alert'});
        return false;
    }
    if(CheckGridEditing('tabTRAppMethodInfo')){
        $.messager.popover({msg:"请先保存分时段预约方式后再进行分时段操作",type:'alert'});
        return false;
    }
    var ASRowid=""
   	var ASRowid=$("#ASRowID").val();
    var ScheduleObj={ASRowid:ASRowid,UserID:session['LOGON.USERID']};
	var scheduleDate=Trim($("#AdmDate").val(),"g"); //$("#AdmDate").datebox("getValue"); 
	if (scheduleDate==""){
		$.messager.alert('提示', "请选择出诊日期","info",function(){
			  $("#AdmDate").focus();
		})
		return false;
	}else{
		scheduleDate=scheduleDate.split(",").join("^");
	}
	//正号限额
 	var total = $("#PositiveMax").numberbox('getValue'); 	
 	//预约限额		
	var book = $("#ApptMax").numberbox('getValue');	
	//加号限额			
	var over = $("#AddtionMax").numberbox('getValue');	
	//预约起始号			
	var startNum = $("#EStartPrefix").numberbox('getValue');		
	if (book==0){startNum=0}
	if (((startNum=="")||(startNum<=0))&(book>0)){
	  $.messager.alert('提示', "预约起始号数量格式不正确!","info",function(){
		  $("#EStartPrefix").focus();
	  })
	  return false;
    }
	var TRFlag="Y",StopRegNoFlag="Y";
	if(!$("#TRFlag").checkbox('getValue')){
		TRFlag = "N";
	}
	if(!$("#StopRegNoFlag").checkbox('getValue')){
		StopRegNoFlag = "";
	}
	var AdmLoc = $("#AdmLoc").combobox("getValue");	
	var AdmDoc = $("#AdmDoc").combobox("getValue");	
	var TimeRange = $("#TimeRange").combobox("getValue");	
	var LocArea = $("#LocArea").combobox("getValue");	
	var DocSession = $("#DocSession").combobox("getValue");
	var ClinicGroup	= getValue("ClinicGroup"); //$("#ClinicGroup").combobox("getValue");
	var TimeStart = $("#StartTime").timespinner('getValue');		
	var TimeEnd = $("#EndTime").timespinner('getValue');	
	ScheduleObj.Room=LocArea
	ScheduleObj.AdmDoc=AdmDoc
	ScheduleObj.AdmLoc=AdmLoc
	ScheduleObj.TimeRange=TimeRange
	ScheduleObj.ASLoad=total
	ScheduleObj.AppLoad=book
	ScheduleObj.AddLoad=over
	ScheduleObj.SessType=DocSession
	ScheduleObj.ClincGroup=ClinicGroup
	ScheduleObj.AppStartNo=startNum
	ScheduleObj.SttTime=TimeStart
	ScheduleObj.EndTime=TimeEnd
	ScheduleObj.AdmDate=scheduleDate
	ScheduleObj.TRFlag=TRFlag
	ScheduleObj.StopRegNoFlag=StopRegNoFlag;
    ScheduleObj.tabAppMethodInfo=GetElementValue('tabAppMethodInfo');
    ScheduleObj.tabTRInfo=GetElementValue('tabTRInfo');
    var retJson=$.cm({
        ClassName:'DHCDoc.OPAdm.Schedule',
        MethodName:'SaveScheduleInfo',
        InputJson:JSON.stringify(ScheduleObj),
        dataType:"json"
    },false);
    if(retJson.Code==0){
        $.messager.popover({msg:"保存成功!",type:'success'});
        if(ASRowid){
            SetScheduleInfo(ASRowid);
        }else{
            EditSchedule(retJson.ASRowids[0]);
        }
        DeleteSaveTip($('#BUpdate').find('.l-btn-text'));
        return true;
    }else{
        $.messager.alert('保存失败',retJson.msg);
        return false;
    }
}
function GenWayChecked()
{
    var value=$("input[name='GenTRRadio']:checked").val();
    $('.search-table').find('tr[name="'+value+'"]').show();
    $('.search-table').find('tr[name]').not('[name="'+value+'"]').hide();
    if (value=="GenTRTemp") {
	    $('#TRTemp').next('span').find('input').focus();
	}else{
		$("#TRASLoad").attr("disabled",true);
		$("#IntervalTime").focus();
	}
}
function TRGenClick()
{
    var value=$("input[name='GenTRRadio']:checked").val();
    if(value=='GenTRTemp'){
        if(GenTRInfoByTemp()){
            AddSaveTip($('#BUpdate').find('.l-btn-text'));
            $('#TRGenWin').window('close');
            if(ReCheckAppMethod()){
            	$('#tabTRInfo').datagrid('options').toolbar[0].handler();
            }
        }
    }else{
        var SttTime=GetElementValue('StartTime');
        var EndTime=GetElementValue('EndTime');
        var IntervalTime=GetElementValue('IntervalTime');
        var ASLoad=GetElementValue('TRASLoad');
        if(CalculateTRInfo(SttTime,EndTime,IntervalTime,ASLoad)){
            AddSaveTip($('#BUpdate').find('.l-btn-text'));
            $('#TRGenWin').window('close');
            if(ReCheckAppMethod()){
            	$('#tabTRInfo').datagrid('options').toolbar[0].handler();
            }
        }
    }
}
function CalculateTRInfo(SttTime,EndTime,IntervalTime,ASLoad)
{
    if((IntervalTime=="")||(SttTime=="")||(EndTime=="")||(ASLoad=="")) return false;
    var SttMin=TimeToMin(SttTime);
    var EndMin=TimeToMin(EndTime);
    var IntervalTime=Number(IntervalTime);
    var ASLoad=Number(ASLoad);
    var TRLength=EndMin-SttMin;
    if(TRLength%IntervalTime){
        $.messager.popover({msg:"分时段间隔时间不能均分时段!",type:'error'});
        $('#IntervalTime').select();
        return false;
    }
    var DataArr=new Array();
    var TRCount=TRLength/IntervalTime;
    for(var i=1;i<=TRCount;i++){
        var SttTime=SttMin+(i-1)*IntervalTime;
        var EndTime=SttMin+i*IntervalTime;
        var Load=Math.floor(ASLoad/(TRCount-i+1));
        ASLoad-=Load;
        var obj={SttTime:MinToTime(SttTime),EndTime:MinToTime(EndTime),Load:Load};
        DataArr.push(obj);
    }
    SetElementValue('tabTRInfo',DataArr);
    return true;
    function TimeToMin(TimStr)
    {
        return Number(TimStr.split(':')[0])*60+Number(TimStr.split(':')[1]);
    }
    function MinToTime(Mins)
    {
        var hour=Math.floor(Mins/60);
        if(hour<10) hour='0'+hour;
        var min=(Mins%60);
        if(min<10) min='0'+min;
        return hour+":"+min;
    }
}
function GenTRInfoByTemp()
{
    var ID=GetElementValue('TRTemp');
    if(!ID){
        $.messager.popover({msg:"请选择模板!",type:'error'});
        return false;
    }
    var TempData=$('#TRTemp').combobox('getData');
    for(var i=0;i<TempData.length;i++){
        if(TempData[i].ID==ID){
            var Data=TempData[i].Data;
            if(!Data) Data=[];
            if(typeof(Data)=='string'){
                Data=JSON.parse(Data);
            }
            SetElementValue('tabTRInfo',Data);
            return true;
        }
    }
    return false;
}
//分时段预约方式 反算 预约方式数量 JS对象赋值另一个对象用extend
function ReCheckAppMethod()
{
    var AMArr=new Array();
    var AMData=GetElementValue('tabAppMethodInfo');
    var oldAMData=new Array();
    for(var i=0;i<AMData.length;i++){
        if(!AMData[i].AppMethodID) continue;
        AMArr[AMData[i].AppMethodID]=$.extend({},AMData[i]);
        AMArr[AMData[i].AppMethodID].index=i;
        oldAMData.push($.extend({},$.extend({},AMData[i])));
    }
    var TRAMArr=GetTRAppMethodInfo();
    for(var AppMethodID in TRAMArr){
        if(AMArr[AppMethodID]){
            if(Number(TRAMArr[AppMethodID].MaxQty)>Number(AMArr[AppMethodID].MaxQty)){
                AMArr[AppMethodID].MaxQty=TRAMArr[AppMethodID].MaxQty;
            }
            if(Number(TRAMArr[AppMethodID].ReserveQty)>Number(AMArr[AppMethodID].ReserveQty)){
                AMArr[AppMethodID].ReserveQty=TRAMArr[AppMethodID].ReserveQty;
            }
            $('#tabAppMethodInfo').datagrid('updateRow',{index:AMArr[AppMethodID].index,row:AMArr[AppMethodID]});
        }else{
            $('#tabAppMethodInfo').datagrid('appendRow',TRAMArr[AppMethodID]);
        }
    }
    if(!AppMethodQtySave()){    // 预约方式数量保存验证失败,还原预约方式数量
        SetElementValue('tabAppMethodInfo',oldAMData);
        return false;
    }
    return true;
}
function ASQtyChange(oldVal,that)
{
    var TotalQty=0
    var AvailAppQty=Number(GetElementValue('ApptMax'))-Number(GetElementValue('AppStartNo'))+1;
    var AMData=GetElementValue('tabAppMethodInfo');
    for(var i=0;i<AMData.length;i++){
        if(Number(AMData[i].MaxQty)>AvailAppQty){
            $.messager.popover({msg:"可预约总数量:"+AvailAppQty+",小于"+AMData[i].AppMethod+"的预约最大数量:"+Number(AMData[i].MaxQty),type:'error'});
            //SetElementValue('AppStartNo',oldVal);
            $(that).select();
            return false;
        }
        TotalQty+=Number(AMData[i].ReserveQty);
    }
    if(TotalQty>AvailAppQty){
        $.messager.popover({msg:"可预约总数量:"+AvailAppQty+",小于预约方式保留量的总和:"+TotalQty+"!",type:'error'});
        //SetElementValue(that,oldVal);
        $(that).select();
        return false;
    }
    //SetElementValue('AppLoad',AvailAppQty);
    return true;
}
function LoadtabTRInfo(ASRowID){
	var retJson=$.cm({
        ClassName:'DHCDoc.OPAdm.Schedule',
        MethodName:'GetTRInfoNew',
        ASRowid:ASRowID,
        dataType:"json"
    },false);
    SetElementValue("tabTRInfo",retJson);
}
function TRTempSaveClick()
{
    var TempName=$('#TempName').val();
    if(TempName==''){
        $.messager.popover({msg:"请填写模板名称!",type:'alert'});
        return;
    }
    var SaveObj={
        Name:TempName,
        Data:GetElementValue('tabTRInfo'),
        TimeRangeDR:GetElementValue('TimeRange'),
        InsertUserDR:session['LOGON.USERID']
    };
    var SaveArr=new Array(SaveObj);
    var retJson=$.cm({
        ClassName:'DHCDoc.OPAdm.TimeRangeTemp',
        MethodName:'Update',
        InputJson:JSON.stringify(SaveArr),
        HospID:$HUI.combogrid('#_HospUserList').getValue(),
        dataType:"json"
    },false);
    if(retJson.Code==0){
        $.messager.popover({msg:"保存模板成功!",type:'success'});
        $('#TRTempSaveWin').window('close');
        return true;
    }else{
        $.messager.alert('失败',"保存失败:"+retJson.Msg);
        return false;
    }
}
function SetElementValue(target,value)
{
    if(typeof(target)=='string') target='#'+target;
    if(!$(target).size()) return false;
    var className=$(target).attr('class');
    if(!className) className="";
    var childClassName=$(target).children().attr('class');
    if(!childClassName) childClassName="";
    if(className.indexOf('combobox-f')>-1){
        $(target).combobox('select',value);
    }else if(className.indexOf('numberbox-f')>-1){
        $(target).numberbox('setValue',value);
    }else if(className.indexOf('hisui-switchbox')>-1){
        if((value==true)||(value=='Y')) value=true;
        else value=false;
        $(target).switchbox('setValue',value);
    }else if(className.indexOf('timespinner-f')>-1){
        $(target).timespinner('setValue',value);
    }else if(className.indexOf('datagrid-f')>-1){
        $(target).datagrid('loadData',value);
    }else if(className.indexOf('datebox-f')>-1){
        $(target).datebox('setValue',value);
    }else if(childClassName.indexOf('kw-section-list')>-1){
        $(target).keywords('select',value);
    }else if($(target).prop("tagName")=="INPUT"){
        $(target).val(value);
    }else{
        $(target).text(value);
    }
    return true;
}
function GetElementValue(target)
{
    if(typeof(target)=='string') target='#'+target;
    var value="";
    if(!$(target).size()) return value;
    var className=$(target).attr('class');
    if(!className) className="";
    var childClassName=$(target).children().attr('class');
    if(!childClassName) childClassName="";
    if(className.indexOf('combobox-f')>-1){
        var text=$(target).combobox('getText');
        if(text!=""){
            value=$(target).combobox('getValue');
            if(value==text) value="";
        }
    }else if(className.indexOf('numberbox-f')>-1){
        value=$(target).numberbox('getValue');
    }else if(className.indexOf('hisui-switchbox')>-1){
        value=$(target).switchbox('getValue');
    }else if(className.indexOf('timespinner-f')>-1){
        value=$(target).timespinner('getValue');
    }else if(className.indexOf('datagrid-f')>-1){
        var dataGridData=$(target).datagrid('getData');
	    if (dataGridData.originalRows) {
        	value=dataGridData.originalRows;
        }else{
	        value=dataGridData.rows;
	    }
    }else if(className.indexOf('datebox-f')>-1){
        value=$(target).datebox('getValue');
    }else if(childClassName.indexOf('kw-section-list')>-1){
        value=$(target).keywords('getSelected');
    }else if($(target).prop("tagName")=="INPUT"){
        value=$(target).val();
    }else{
        value=$(target).text();
    }
    return value;
}
function ClearTabs(ID){
    var SelectFun=$('#'+ID).tabs('options').onSelect;
    $('#'+ID).tabs('options').onSelect=function(){};
    var length=$('#'+ID).tabs('tabs').length;
	for(var i=length;i>0;i--){
		$('#'+ID).tabs('close',i-1);
	}
    $('#'+ID).tabs('options').onSelect=SelectFun;
}
function CheckGridEditing(target)
{
    if(typeof(target)=='string') target='#'+target;
    var rows=$(target).datagrid('getRows');
    if(!rows) return false;
    for(var i=0;i<rows.length;i++){
        var Editors=$(target).datagrid('getEditors',i);
        if(Editors.length){
            return true;
        }
    }
    return false;
}
function AddSaveTip(target,size)
{
    if(typeof(target)=='string') target='#'+target;
    if(!size) size=9;
    var html="<i style='display:block;background:#f00;border-radius:50%;";
    html+="width:"+size+"px;height:"+size+"px;top:1px;right:1px;position:absolute;'></i>"
    $(target).append(html);
    return true;
}
function DeleteSaveTip(target)
{
    if(typeof(target)=='string') target='#'+target;
    $(target).find('i').remove();
    return true;
}
function AddDGTBSaveTip(id,btnText){
    if(!btnText) btnText="保存"
    var target=$('#'+id).parent().parent().find('.datagrid-toolbar').find('.l-btn-text:contains('+btnText+')');
    AddSaveTip(target);
}
function DeleteDGTBSaveTip(id,btnText)
{
    if(!btnText) btnText="保存"
    var target=$('#'+id).parent().parent().find('.datagrid-toolbar').find('.l-btn-text:contains('+btnText+')');
    DeleteSaveTip(target);
}
function ShowHISUIWindow(title,src,iconCls,width,height)
{
    if(!width) width=900;
    if(!height) height=500;
    if(!$('#ShowMode_Win').size()){
        $("body").append("<div id='ShowMode_Win' class='hisui-window'></div>");
    }
    $('#ShowMode_Win').window({
        iconCls:iconCls,
        width:width,
        height:height,
        title:title,
        collapsible:false,
        maximizable:false,
        minimizable:false,
        modal:true,
        content:"<iframe width='99.5%' height='99%' frameborder='0' src='"+src+"'></iframe>"
    });
}
function CloseHISUIWindow()
{
    if($('#ShowMode_Win').size()){
        $('#ShowMode_Win').window('close');
    }
}
function GetDGEditRowIndex(target)
{
    if(typeof(target)=='string') target='#'+target;
    var EditRow=$(target).parents("[datagrid-row-index]").attr("datagrid-row-index");
    if(typeof(EditRow)==undefined) EditRow="";
    return EditRow;
}
function GetDateAddDays(DateStr,Days)
{
    var date = new Date(DateStr);
    date.setDate(date.getDate()+parseInt(Days));
    var y=date.getFullYear();
    var m=date.getMonth()+1;
    if(m<10) m='0'+m;
    var d=date.getDate();
    if(d<10) d='0'+d;
    return y+'-'+m+'-'+d;
}
function GetDateWeek(DateStr)
{
    var date = new Date(DateStr);
    var Week=date.getDay();
    if(Week==0) Week=7;
    return Week;
}
function GetCurrentDate()
{
    var date = new Date();
    var y=date.getFullYear();
    var m=date.getMonth()+1;
    if(m<10) m='0'+m;
    var d=date.getDate();
    if(d<10) d='0'+d;
    return y+'-'+m+'-'+d;
}
function GetCurrentTime()
{
    var date = new Date();
    var h=date.getHours();
    if(h<10) h='0'+h;
    var m=date.getMinutes();
    if(m<10) m='0'+m;
    var s=date.getSeconds();
    if(s<10) s='0'+s;
    return h+':'+m+':'+s;
}
function CompareDate(s1,s2){
    var d1=new Date(s1);
    var d2=new Date(s2);
    if(d1>d2) return 1;
    if(d1<d2) return -1;
    return 0;
}
function TableToExcel(selector)
{
    try{
        var oXL = new ActiveXObject("Excel.Application");  
        var length=$(selector).size();
        $(selector).each(function(index,element){
            var oWB = oXL.Workbooks.Add();  
            var oSheet = oWB.ActiveSheet;
            var $rows=$(this).children('tbody').children('tr');
            for(var i=0;i<$rows.size();i++){
                var row=i+1
                $cols=$rows.eq(i).children('td');
                for(var j=0;j<$cols.size();j++){
                    var col=j+1;
                    oSheet.Cells(row,col).Value=$cols.eq(j).text();
                }
            }
            if((length-1)==index){
                oXL.Visible = true; 
            }
        });
    }catch(e){
        alert(e.message);
    }
}
$.fn.singleCombo = function(options){
    var ChangeTimer;
    $.extend(options,{
        onChange:function(){
            clearTimeout(ChangeTimer);
            var target=this;
            ChangeTimer=setTimeout(function(){
                if($(target).combobox('panel').find(":visible").size()==1){
                    var index=$(target).combobox('panel').find(":visible").index();
                    var Data=$(target).combobox('getData');
                    var valueField=$(target).combobox('options').valueField;
                    $(target).combobox('select',Data[index][valueField]);
                    $(target).combobox('hidePanel');
                }
            },300);
        }
    },options);
    options.url=options.url||$.fn.combobox.defaults.url;
    options.url+=(options.url.indexOf("?")>-1?'&':'?')+'ClassName='+options.ClassName+"&QueryName="+options.QueryName;
    if(options.queryParams){
        for(var key in options.queryParams){
            options.url+="&"+key+'='+options.queryParams[key];
        }
    }
    $(this).combobox(options);
}
$.extend($.fn.combobox.defaults, {  
    valueField:'id',
    textField:'text', 
    panelHeight:200, 
    mode:"local",
    url:'DHCDoc.Util.QueryToJSON.cls?JSONTYPE=Combo',
    filter: function(q, row){
        var opts = $(this).combobox('options');
        return row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
    },
    onLoadError:function(){
        debugger;
        $.messager.alert('提示','Init Combo Error','error');
    }
});
function AddColorSynopsis() {
	$.each(ColorSynopsis, function(index, key){
		var PorpStr={trigger:'hover',placement:'bottom-left',title:'',content:key}
		var $color=$("<span style='background-color:"+index+"'></span>")
		$("#ColorSynopsis").append($color)
		$("#ColorSynopsis span").popover(PorpStr)
	})
}
function StopQueueNo(){
	var tab = $('#ScheduleTab').tabs('getSelected');
	 var index = $('#ScheduleTab').tabs('getTabIndex',tab);
	 var GridId="ScheduleGrid"+index;
	 var rows=$("#"+GridId).datagrid("getSelections");
	 var idStr="";
	 for(var i=0;i<rows.length;i++){
		if(idStr==""){
			idStr=rows[i].ASRowId;
		}else{
			idStr=idStr+"^"+rows[i].ASRowId;
		}
	 }
	 if(idStr==""){
		$.messager.alert("提示","请选择要停号的排班记录!");
		return false;
	 }
	 if(idStr.split("^").length>1){
		 $.messager.alert("提示","请选择单个排班进行停号操作!");
		 return false;
	 }
	 var src="opadm.schedulestopqueueno.hui.csp?ASRowid="+idStr;
	 var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	 createModalDialog("Project","停号", PageLogicObj.dw, PageLogicObj.dh,"icon-w-list","",$code,"");
	}
