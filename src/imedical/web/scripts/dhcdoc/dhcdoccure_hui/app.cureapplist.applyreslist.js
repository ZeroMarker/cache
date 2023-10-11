/**
	治疗预约 Version 2.0
	2022-06-02
*/
var appList_appResListObj=(function(){
	//var CureRBCResSchduleDataGrid;
	var PageAppResListObj={
		m_PrePageNumber:"",
		m_NotReloadAppDataGrid:"",
		m_CureAppointListDataGrid:"",
		m_SelectRBASId:"",
		m_TalStartDate:"",
		m_ScheduleTabIndex:0,
		m_SchduleDataGridLoadTimer:"",
		m_TimeRangeWinTitle:""
	}
	function InitApplyResListEvent(){
		$('#btnSearchApp').click(SearchAppClick);
		$('#btnApp').click(BtnAppClick)
		$('#btnExport').click(btnExportAppClick)
		$HUI.checkbox("#QryAllFlag",{
			onCheckChange:function(e,value){
				CureAppointListDataGridLoad();
			}
		})
		$('#appointlist-dialog').window({
			onClose:function(){
				PageAppResListObj.m_SelectRBASId="";
				if(ServerObj.LayoutConfig=="1"){
					var SELECT_DCAROWID=GetMainID();
					var IDArray=SELECT_DCAROWID.split("!");
					AfterAppoint("Y",IDArray,ReloadResAppDataGrid);
				}
			}	
		})
		$('#appreslist-dialog').window({
			onClose:function(){
				AfterAppoint();
			}	
		})
		
		$("#Apply_StartDate").datebox({
			onChange:function(newValue, oldValue){
				SearchAppClick();
			}
		}).datebox('setValue',ServerObj.CurrentDate);
	}
	function InitDate(){
	    $("#Apply_StartDate").datebox('setValue',ServerObj.CurrentDate);	
	    //$("#Apply_EndDate").datebox('setValue',ServerObj.AppEndDate);		
	}
	
	function SearchAppClick(){
		var StartDate=$("#Apply_StartDate").datebox("getValue"); 
		if(ServerObj.ScheuleGridListOrTab==0){
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
		}else if(ServerObj.ScheuleGridListOrTab==1){
			InitScheduleList(StartDate) ;	
		}
	}
	
	function InitScheduleTab(StartDate){
		if(StartDate=="")return;
		var AdmDateStr=tkMakeServerCall("DHCDoc.DHCDocCure.RBCResSchdule","GetAdmDateStr",StartDate,"","","doccure.cureapplist.hui.csp")
		var AdmDateStrArr=AdmDateStr.split("^")
		for(var i=0;i<AdmDateStrArr.length;i++){
			var admDate=AdmDateStrArr[i].split(String.fromCharCode(1))[0]
			$("#ScheduleTab").tabs("add",{
				title:admDate,
				fit:true,
				content:'Tab Body'
			})
		}
		$('#ScheduleTab').tabs({
			fit:true,
			onSelect: function(title,index){
				SelectScheduleTab(title,index);
			}
		})
	}
	function SelectScheduleTab(title,index){
		if("undefined"==typeof index)index=PageAppResListObj.m_ScheduleTabIndex;
		if("undefined"==typeof title){
			var StartDate=PageAppResListObj.m_TalStartDate;
		}else{
			var StartDate=title.split("(")[0];
		}
		if(ServerObj.ScheuleGridListOrTab==0){
			var CurrentTabPanel=$('#ScheduleTab').tabs("getSelected");
			//var TemplateTable=$('<table id="ScheduleGrid'+index+'"></table>');
			var TemplateTable=$('<div class="c-p-bd-t schegrid-in-div"><table id="ScheduleGrid'+index+'"></table></div>');
			CurrentTabPanel.html(TemplateTable);
			PageAppResListObj.m_TalStartDate=StartDate ;
			InitCureRBCResSchduleDataGrid("ScheduleGrid"+index,CurrentTabPanel.height()-2);
			clearTimeout(PageAppResListObj.m_SchduleDataGridLoadTimer);
			PageAppResListObj.m_SchduleDataGridLoadTimer=setTimeout("appList_appResListObj.CureRBCResSchduleDataGridLoad('ScheduleGrid"+index+"','"+StartDate+"')",100)
			PageAppResListObj.m_ScheduleTabIndex=index;
			//$("#ScheduleTab").tabs("select",PageAppResListObj.m_ScheduleTabIndex)	
		}else if(ServerObj.ScheuleGridListOrTab==1){
			InitScheduleList(StartDate) ;	
			clearTimeout(PageAppResListObj.m_SchduleDataGridLoadTimer);
			PageAppResListObj.m_SchduleDataGridLoadTimer=setTimeout("appList_appResListObj.CureRBCResSchduleDataGridLoad('ScheduleList'"+",'"+StartDate+"')",100)
		}
	}
	function InitCureRBCResSchduleDataGrid(GridId,height)
	{  
		var cureRBCResSchduleColumns=[[    
	            { field: 'Rowid', title: 'ID', width: 1, align: 'left', hidden:true}, 
				{ field: 'DDCRSDate', title:'日期', width: 30, align: 'left', hidden: true},
				{ field: 'LocDesc', title:'科室', width: 130, align: 'left', resizable: true  
				},
				{ field: 'ResourceDesc', title: '资源', width: 80, align: 'left', resizable: true
				},
				{ field: 'TimeDesc', title: '时段', width: 80, align: 'left', resizable: true
				},
				{ field: 'StartTime', title: '开始时间', width: 80, align: 'left', resizable: true
				},
				{ field: 'EndTime', title: '结束时间', width: 80, align: 'left', resizable: true
				},
				{ field: 'AppedLeftNumber', title: '剩余可预约数', width: 100, align: 'left',resizable: true,
					formatter:function(value,row,index){
						value=parseFloat(value)
						var MaxNumber=parseFloat(row.MaxNumber)*0.5;
						if (value ==0){
							return "<span class='fillspan-nonenum'>"+value+"</span>";
						}else if((value >0)&&(value<MaxNumber)){
							return "<span class='fillspan-nofullnum'>"+value+"</span>";
						}else{
							return "<span class='fillspan-fullnum'>"+value+"</span>";
						}
					}
				},
				{ field: 'AppedNumber', title: '已预约数', width: 100, align: 'left', resizable: true
					,formatter: function (value, rowData, rowIndex) {
						var retStr="<span>"+rowData.AppedNumber+"</span>";
						if(rowData.AppedNumber>0){
							retStr = "<a href='#' title='预约列表'  onclick='appList_appResListObj.ShowAppointList(\""+rowData.Rowid+"\")'>"+retStr+"</a>"
						}
						return retStr;
					}
				},
				{ field: 'MaxNumber', title: '最大预约数', width: 100, align: 'left', resizable: true
				},
				{ field: 'EndAppointTime', title: '截止预约时间', width: 100, align: 'left', resizable: true
				},
				{ field: 'ServiceGroupDesc', title: '服务组', width: 100, align: 'left', resizable: true
				},
				{ field: 'DDCRSStatus', title: '资源状态', width: 80, align: 'left', resizable: true
				},
				{ field: 'DDCRSStatusCode', title: '资源状态代码', width: 80, align: 'left', hidden: true
				},
				{ field: 'AutoNumber', title: '自动预约数', width: 80, align: 'left', hidden: true
				},
				{ field: 'ChargeTime', title: '截止缴费时间', width: 80, align: 'left', hidden: true
				},
				{ field: 'AvailPatType', title: '可用类型', width: 80, align: 'left', hidden: true
				},
				{ field: 'AutoAvtiveFlag', title: '自动预约启用开关', width: 80, align: 'left', hidden: true
				}
			 ]];
		//CureRBCResSchduleDataGrid=$('#'+GridId).datagrid({ 
		$('#'+GridId).datagrid({ 
			//fit:true,
			//width:'auto',
			border:false,
			remoteSort:false,
			striped:true,
			singleSelect:true,
			autoRowHeight:true,
			fitColumns : false,
			height:height,
			loadMsg:$g('正在加载'),
			rownumbers:true,
			idField:"Rowid",
			columns :cureRBCResSchduleColumns,
			rowStyler:function(rowIndex, rowData){
	 			if (rowData.DDCRSStatusCode!="N"){
		 			return 'color:#788080;';
		 		}
			},
			onLoadSuccess:function(data){
				UpdateScheTabStyle(GridId);
				//初始化分时段信息窗
				InitTimeRangeWinForTab(GridId);
			}
		});
		//return CureRBCResSchduleDataGrid;
	}
	
	function UpdateScheTabStyle(tabId){
		$(".tabItem_badge").remove();
		var opts=$("#"+tabId).datagrid("options");
		var queryParams=opts.queryParams;
		if ((queryParams.Arg1!="")||(queryParams.Arg3!="")){
			var ArgCnt=queryParams.ArgCnt;
			var obj={};
			var SELECT_DCAROWID=GetMainID();
			for (var i=0;i<ArgCnt;i++) {
				var ArgN="Arg"+(i+1);
				if((i==0)||(i==2)){
					obj[ArgN]=SELECT_DCAROWID;	
				}else{
					obj[ArgN]=queryParams[ArgN];
				}
			}
			var FirstTab = $('#ScheduleTab').tabs('getTab',0);
			var FirstTabTitle=FirstTab.panel("options").title;
			var FirstTabDate=FirstTabTitle.split("(")[0];
			var AdmDateStr=tkMakeServerCall("DHCDoc.DHCDocCure.RBCResSchdule","GetAdmDateStr",FirstTabDate,JSON.stringify(obj),"","doccure.cureapplist.hui.csp")
			var AdmDateStrArr=AdmDateStr.split("^");
			for(var i=0;i<AdmDateStrArr.length;i++){
				var admDate=AdmDateStrArr[i].split(String.fromCharCode(1))[0];
				var ExistScheduleFlag=AdmDateStrArr[i].split(String.fromCharCode(1))[1];
				if (ExistScheduleFlag==1){
					$($("#ScheduleTab .tabs li a")[i]).append('<sup class="tabItem_badge"></sup>');
				}
			}
		}
	}
	function CureRBCResSchduleDataGridLoad(GridId,StartDate)
	{
		if(ServerObj.ScheuleGridListOrTab==1){
			$("#ScheduleList").datagrid("clearSelections").datagrid('reload'); 
		}else{
			if("undefined"==typeof GridId)GridId="ScheduleGrid"+PageAppResListObj.m_ScheduleTabIndex;
			if("undefined"==typeof StartDate)StartDate=PageAppResListObj.m_TalStartDate;
			$("#"+GridId).datagrid("clearSelections");
			var DCARowId="";
			var DCARowIdStr=GetMainID();
			if(DCARowIdStr==""){
				return;	
			}
			var AppStartDate=StartDate;
			var AppEndDate=StartDate;
			var SessionStr=session['LOGON.HOSPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.USERID'];
			
			var queryParams = new Object();
				queryParams.ClassName ='DHCDoc.DHCDocCure.RBCResSchdule';
				queryParams.QueryName ='QueryAvailResApptSchdule';
				queryParams.Arg1 =DCARowIdStr;
				queryParams.Arg2 ="";
				queryParams.Arg3 =DCARowIdStr;
				queryParams.Arg4 =AppStartDate;
				queryParams.Arg5 =AppStartDate;
				queryParams.Arg6 ="";
				queryParams.Arg7 ="";
				queryParams.Arg8 =SessionStr;
				queryParams.ArgCnt = 8;
				
				var opts = $("#"+GridId).datagrid("options");
				opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
				$("#"+GridId).datagrid('load', queryParams); 
		}

	}
	function GetCurrentGrid(){
		var tab = $('#ScheduleTab').tabs('getSelected');
		var index = $('#ScheduleTab').tabs('getTabIndex',tab);
		var GridId="ScheduleGrid"+index;
		return GridId;
	}
	function BtnAppClick(ASRowID,Title,TRTimeRange){
		/**
			转到治疗预约 Version 2.0
			appoint.applyreslist.js
		*/
		if(typeof appoint_ResListObj != "undefined"){
			appoint_ResListObj.Appoint(ASRowID,Title,TRTimeRange);
			return true;
		} 
	    var DCARowId=$('#DCARowId').val();
		var DCARowIdStr=GetMainID();
	    if(DCARowIdStr=="")
	    {
	        $.messager.alert("提示", "请选择一个申请单", 'info')
			return false;
	    }
	    var mASRowID="",mTitle="";
	    if(ServerObj.ScheuleGridListOrTab==0){
		    var GridId=GetCurrentGrid();
		    var rows = $("#"+GridId).datagrid("getSelections");
		    if (rows.length > 0) {
				var ids = [];
				
				for (var i = 0; i < rows.length; i++) {
					ids.push(rows[i].Rowid);
					mTitle=rows[i].LocDesc+" "+rows[i].ResourceDesc+" "+rows[i].TimeDesc+" "+rows[i].ServiceGroupDesc;
				}
				mASRowID=ids.join(',');
		    }
	    }else if(typeof ASRowID!='undefined'){
		    mASRowID=ASRowID;
		    mTitle=Title;
		}
		var mTRTimeRange = "";
		if ((typeof TRTimeRange != "undefined")&&(TRTimeRange != "")) {
			mTRTimeRange = TRTimeRange;
		}
	    if(mASRowID!=""){
			var DCARowIdArr=DCARowIdStr.split("!");
			var SDCARowIdArr=new Array(); //成功预约的申请
			var err="";
			for(var j=0;j<DCARowIdArr.length;j++){	
				var oneDCARowId=DCARowIdArr[j];		
				var CureAppInfo=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetCureApply",oneDCARowId);
				var PatName="",
					ArcimDesc="",
					ApplyNoAppTimes="";
				if(CurePatInfo!=""){
					var CurePatInfo=CureAppInfo.split(String.fromCharCode(1))[0];
					var CureInfo=CureAppInfo.split(String.fromCharCode(1))[1];
					var PatName=CurePatInfo.split("^")[2];
					var ArcimDesc=CureInfo.split("^")[0];
					var ApplyNoAppTimes=CureInfo.split("^")[10];
				}
				/*
				if(ApplyNoAppTimes==1){
					var myerr="'"+PatName+" "+ArcimDesc+"'"+",本次治疗为最后一次可预约";
					$.messager.alert('提示',myerr);
				}
				*/
				var Para=oneDCARowId+"^"+mASRowID+"^"+"M"+"^"+session['LOGON.USERID']+"^"+session['LOGON.HOSPID']+"^"+mTRTimeRange;
				//多人预约，需要进行同步处理
				var ObjScope=$.cm({
					ClassName:"DHCDoc.DHCDocCure.Appointment",
					MethodName:"AppInsertHUI",
					'Para':Para,
					'JSONType':"JSON",
				},false);
				var value=ObjScope.result;
				if(value=="0"){
					SDCARowIdArr.push(oneDCARowId);
				}else{
					var err=value
					if (value==100) err="有参数为空.";
					else if(value==101){
						err="停诊的排班不能预约.";
						SDCARowIdArr.push(oneDCARowId);
					}
					else if(value==1001) err="已撤销的申请不能预约.";
					else if(value==1101) err="系统错误,未获取报到状态代码.";
					else if(value==102){
						err="此排班已经过了预约时间,不能预约."; //当前操作预约时间>资源开始时间
						SDCARowIdArr.push(oneDCARowId);
					}
					else if(value=="-10031") err="该申请单包含的项目数量已经约完."; //医嘱数量-已经预约的数量=0则不可再预约
					else if(value=="-10032") err="该申请单可预约数量不足.";
					else if(value=="-10033") err="当前时段无可预约号序.";
					else if(value=="-10034") err="预约取号失败.";
					else if(value=="-10035") err="您选择的分时段内已无可预约号.";
					else if((value==104)||(value==105)) err="插入执行记录错误.";
					else if(value==106){
						err="此排班已预约完,不能再预约.";
						SDCARowIdArr.push(oneDCARowId);
					}
					else if(value==107) err="该申请存在有效的预约未治疗的记记录,不能重复预约.";
					else if(value==108) err="该申请医嘱未缴费,无法进行预约.";
					else if(value==1081) err="该患者已出院,无法进行预约.";
					else if(value==1082) err="该患者就诊已退号,无法进行预约.";
					else if(value==109) err="该申请医嘱为长期,无法进行预约,请直接执行.";
					else if(value=="202") err="该申请为直接执行治疗医嘱,不可预约.";
					else if(value=="203") err="该申请医嘱已停止,不可预约.";
					err="'"+PatName+" "+ArcimDesc+"'"+$g("预约失败,失败原因")+":"+$g(err);
					//$.messager.alert('提示',"预约失败:"+err,"warning");
					dhcsys_alert($g("预约失败:")+err);
				}
			}
			if(err==""){
				$.messager.popover({msg: '预约成功！',type:'success',timeout: 3000,
					style:{
						top:document.body.scrollTop + document.documentElement.scrollTop+10,
						right:$(window).width()*0.5-50
					}
				});
			}
			if(SDCARowIdArr.length>0){
				if(PageAppListAllObj && PageAppListAllObj.m_CureSingleAppoint=="1"){
					var SELECT_DCAROWID=GetMainID();
					var ApplyNoAppTimes=$.cm({
						ClassName:"DHCDoc.DHCDocCure.Appointment",
						MethodName:"GetAppointLeftCount",
						'DCARowId':SELECT_DCAROWID,
						dataType:"text"
					},false)
					if(ApplyNoAppTimes>0){
						ShowAppResScheduleList(mASRowID,{ApplyNoAppTimes:ApplyNoAppTimes,title:mTitle});
					}else{
						AfterAppoint();
					}
				}else{
					$.messager.confirm("提示", "是否为当前选择的申请单继续预约(无法继续预约的已自动取消选择)?", function(r){
						var NotClearFlag="";
						if(r){
							NotClearFlag="Y";
						}
						if(((NotClearFlag=="")&&(ServerObj.LayoutConfig=="1"))||(NotClearFlag=="Y")){
							new Promise(function(resolve,rejected){
								if(window.frames.parent.CureApplyDataGrid){
									window.frames.parent.RefreshDataGrid(NotClearFlag,SDCARowIdArr,resolve);
								}else{
									RefreshDataGrid(NotClearFlag,SDCARowIdArr,resolve);	
								}
							}).then(function(){
								if(ServerObj.LayoutConfig=="2"){
									appList_appListObj.CureApplyAppDataGridLoad();		
								}
							})
						}else if((NotClearFlag=="")&&(ServerObj.LayoutConfig=="2")){
							$('#apptabs-dialog').window('close');
						}
					});
				}
			}else{
				if(ServerObj.LayoutConfig=="1"){
					AfterAppoint();		
				}else if(ServerObj.LayoutConfig=="2"){
					appList_appListObj.CureApplyAppDataGridLoad();		
				}
			}
			CureRBCResSchduleDataGridLoad();
	    }else{
		    $.messager.alert("提示", "请选择要预约的资源", "error");
		    return;
		}
	}
	
	function ShowAppointList(id){
		/**
			转到治疗预约 Version 2.0
			appoint.applyreslist.js
		*/
		PageAppResListObj.m_SelectRBASId=id;
		if(typeof appoint_ResListObj != "undefined"){
			appoint_ResListObj.ShowAppointList(id);
			return true;
		}else{
			var dhwid=$(document.body).width()-100;
			var dhhei=$(document.body).height()-200;
			$("#QryAllFlag").checkbox('setValue',false);
			$('#appointlist-dialog').window('open').window('resize',{width:dhwid,height:dhhei,top: 50,left:45});
			var CureDetailDataGrid=$('#tabCureAppointList').datagrid({  
				fit : true,
				width : 'auto',
				border : false,
				striped : true,
				singleSelect : true,
				checkOnSelect:false,
				fitColumns : true,
				autoRowHeight : false,
				nowrap: false,
				collapsible:false,
				url : '',
				loadMsg : '加载中..',  
				pagination : true,
				rownumbers : true,
				idField:"Rowid",
				pageSize : 20,
				pageList : [20,50],
				columns :[[ 
		    			{field:'Rowid',title:'',width:1,hidden:true}, 
						{field:'CureApplyNo',title:'申请单号',width:110,align:'left'},   
						{field:'PatientNo',title:'登记号',width:100,align:'left'},   
	        			{field:'PatientName',title:'姓名',width:80,align:'left'},   
						{field:'PatOther',title:'患者其他信息',width:200,align:'left', resizable: true},
						{field:'ArcimDesc',title:'治疗项目',width:200,align:'left', resizable: true},
						{field:'OrderQty',title:'申请数量',width:70,align:'left', resizable: true},
	        			{field:'DCAAStatus',title:'预约状态',width:70,align:'left', resizable: true},
	        			{field:'DCAAQty',title:'治疗数量',width:70,align:'left', resizable: true},
						{field:'DCASeqNo',title:'排队序号',width:80,align:'left'}, 
						{field:'DCAARBASDR',title:'',width:1,hidden:true},
						{field:'Job',title:'',width:1,hidden:true}
				 ]],
				 toolbar : [{
						id:'BtnCall',
						text:'取消预约',
						iconCls:'icon-cancel',
						handler:function(){
							CancelCureAppoint();
						}
					}]
			});
			PageAppResListObj.m_CureAppointListDataGrid=CureDetailDataGrid;
			CureAppointListDataGridLoad();
			return CureDetailDataGrid;	
		}
	}
	
	function CureAppointListDataGridLoad(){
		/**
			转到治疗预约 Version 2.0
			appoint.applyreslist.js
		*/
		if(typeof appoint_ResListObj != "undefined"){
			appoint_ResListObj.CureAppointListDataGridLoad();
		}else{
			var QueryState="^A^I^";
			var QryAllFlag=$HUI.checkbox("#QryAllFlag").getValue();
			if (QryAllFlag){QueryState=""};
			var ExpStr=session['LOGON.USERID']+ "^" + session['LOGON.HOSPID']+ "^" + session['LOGON.LANGID']+ "^" + "doccure.cureapplist.hui.csp";
			$.cm({
				ClassName:"DHCDoc.DHCDocCure.Appointment",
				QueryName:"FindAppointmentList",
				'DCARowId':"",
				'QueryState':QueryState,
				'ResSchduleId':PageAppResListObj.m_SelectRBASId,
				ExpStr:ExpStr,
				Pagerows:PageAppResListObj.m_CureAppointListDataGrid.datagrid("options").pageSize,
				rows:99999
			},function(GridData){
				PageAppResListObj.m_CureAppointListDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
			})
			PageAppResListObj.m_CureAppointListDataGrid.datagrid("clearChecked");
			PageAppResListObj.m_CureAppointListDataGrid.datagrid("clearSelections");
		}
	}
	
	
	function ShowAppResScheduleList(id,obj){
		var ApplyNoAppTimes=obj.ApplyNoAppTimes;
		var mytitle=obj.title;
		if(mytitle==""){mytitle=$g("预约资源");}
		var dhwid=500;
		var dhhei=$(document.body).height()-100;
		var lf=($(document.body).width()-dhwid)/2
		$('#appreslist-dialog').window('open').window('resize',{
			width:dhwid,
			height:dhhei,
			top: 50,
			left:lf,
		}).window('setTitle',mytitle);
		var CureResScheduleListDataGrid=$('#tabCureAppResScheduleList').datagrid({  
			fit : true,
			width : 'auto',
			border : false,
			striped : true,
			singleSelect : false,
			checkOnSelect:true,
			selectOnCheck:true,
			fitColumns : true,
			autoRowHeight : false,
			nowrap: false,
			collapsible:false,
			url : '',
			loadMsg : '加载中..',  
			pagination : true,
			rownumbers : true,
			idField:"Rowid",
			pageSize : 20,
			pageList : [20,50],
			columns :[[ 
	    			{ field: 'Rowid', title: 'ID', width: 1, align: 'left', sortable: true,hidden:true}, 
	    			{ field: 'RowCheck',checkbox:true},     
					{ field: 'DDCRSDate', title:'可选日期', width: 50, align: 'left', sortable: true},
					{ field: 'AppedLeftNumber', title: '剩余可预约数', width: 30, align: 'left', sortable: true,resizable: true,
						formatter:function(value,row,index){
							value=parseFloat(value)
							var MaxNumber=parseFloat(row.MaxNumber)*0.5;
							if (value ==0){
								return "<span class='fillspan-nonenum'>"+value+"</span>";
							}else if((value >0)&&(value<MaxNumber)){
								return "<span class='fillspan-nofullnum'>"+value+"</span>";
							}else{
								return "<span class='fillspan-fullnum'>"+value+"</span>";
							}
						}
					}
			 ]],
			onClickRow: function(rowIndex, rowData){
				var RowObj=$(this).parent().find("div .datagrid-cell-check")
                .children("input[type=\"checkbox\"]");
			    RowObj.each(function(index, el){
			        if (el.style.display == "none") {
			            $('#tabCureAppResScheduleList').datagrid('unselectRow', index);
			        }
			    })
			},onBeforeSelect:function(rowIndex, rowData){
				var rows = $('#tabCureAppResScheduleList').datagrid("getSelections");
				var length=rows.length;
				if(length>=ApplyNoAppTimes){
					$('#tabCureAppResScheduleList').datagrid('unselectRow', rowIndex);
					return false
				}
			},onBeforeCheck:function(rowIndex, rowData){
				var rows = $('#tabCureAppResScheduleList').datagrid("getSelections");
				var length=rows.length;
				if(length>=ApplyNoAppTimes){
					$('#tabCureAppResScheduleList').datagrid('unselectRow', rowIndex);
					return false
				}
			},onLoadSuccess: function(data){
				var headchkobj=$(this).parent().find("div .datagrid-header-check")
                .children("input[type=\"checkbox\"]").eq(0);
            	headchkobj.attr("style", "display:none;");
            	
				var RowObj=$(this).parent().find("div .datagrid-cell-check")
                .children("input[type=\"checkbox\"]");
			    for (var i = 0; i < data.rows.length; i++) {
			        if (data.rows[i].AppedLeftNumber==0) {
			            RowObj.eq(i).attr("style", "display:none");
			        }
			    }
			},
			 toolbar : [{
				id:'BtnBApp',
				text:'预约',
				iconCls:'icon-ok',
				handler:function(){
					BatchAppoint();
				}
			}]
		});
		PageAppResListObj.m_CureAppResScheduleListDataGrid=CureResScheduleListDataGrid;
		//PageAppResListObj.m_SelectRBASId=id;
		CureAppResScheduleListDataGridLoad(id);
		$("#LeftAppCount").prop("innerText",$g("可选天数")+":"+ApplyNoAppTimes);
		return CureResScheduleListDataGrid;	
	}
	
	function BatchAppoint(){
		var rows = PageAppResListObj.m_CureAppResScheduleListDataGrid.datagrid("getSelections");
		var length=rows.length;
		if(length==0){
			$.messager.alert("提示", "请选择要预约的日期", "warning");	
			return false;
		}
		var ids = [];
		for (var i = 0; i < length; i++) {
			ids.push(rows[i].Rowid);
		}
		var ID=ids.join(String.fromCharCode(1));
		var SELECT_DCAROWID=GetMainID();
		var Para=SELECT_DCAROWID+"^"+ID+"^"+"M"+"^"+session['LOGON.USERID']+"^"+session['LOGON.HOSPID'];
		var InsExpStr=session['LOGON.HOSPID']+"^"+session['LOGON.LANGID'];
		var ret=$.cm({
			ClassName:"DHCDoc.DHCDocCure.Appointment",
			MethodName:"AppInsertBroker",
			Para:Para,
			InsExpStr:InsExpStr,
			dataType:"text"
		},false);
		if(ret!=""){
			$.messager.alert("提示", ret, "warning");
			return false;	
		}else{
			$('#appreslist-dialog').window('close');
			AfterAppoint();
		}
	}
	
	function AfterAppoint(NotClearFlag,SDCARowIdArr,CallBackFun){
		if(typeof NotClearFlag=='undefined')NotClearFlag="";
		if(typeof SDCARowIdArr=='undefined'){SDCARowIdArr="";}
		if(window.frames.parent.CureApplyDataGrid){
			window.frames.parent.RefreshDataGrid(NotClearFlag,SDCARowIdArr,CallBackFun);
		}else{
			RefreshDataGrid(NotClearFlag,SDCARowIdArr,CallBackFun);	
		}	
	}
	
	function CureAppResScheduleListDataGridLoad(ScheduleID){
		$.cm({
			ClassName:"DHCDoc.DHCDocCure.RBCResSchdule",
			QueryName:"QueryAvailDate",
			'ScheduleID':ScheduleID,
			Pagerows:PageAppResListObj.m_CureAppResScheduleListDataGrid.datagrid("options").pageSize,
			rows:99999
		},function(GridData){
			PageAppResListObj.m_CureAppResScheduleListDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
			if(GridData.total==0){
				$("#LeftAppCount").prop("innerText",$g("本次预约日期之后暂无预约排程资源"));
			}
		})
		PageAppResListObj.m_CureAppResScheduleListDataGrid.datagrid("clearChecked");
		PageAppResListObj.m_CureAppResScheduleListDataGrid.datagrid("clearSelections");
	}
	
	function CancelCureAppoint(){
	    var selected = PageAppResListObj.m_CureAppointListDataGrid.datagrid("getSelected");
		if (selected){
			if((typeof(selected.Rowid) != "undefined")&&(selected.Rowid!="")){
				var Rowid=selected.Rowid;
				var DCAARBASDR=selected.DCAARBASDR;
				$.m({
					ClassName:"DHCDoc.DHCDocCure.Appointment",
					MethodName:"AppCancelHUI",
					'DCAARowId':Rowid,
					'UserDR':session['LOGON.USERID'],
				},function testget(value){
					if(value=="0"){
						CureAppointListDataGridLoad();
						if(ServerObj.LayoutConfig=="2"){
							ReloadResAppDataGrid();	
						}
						$.messager.popover({msg: '取消成功！',type:'success',timeout: 3000});
					}else{
						if(value=="100")value="入参为空"
						else if(value=="101")value="预约状态不是已预约的记录不能取消"
						$.messager.alert('提示',"取消失败:"+value,"warning");
					}
				});
			}
		}else{
			$.messager.alert("提示","请选择一条预约记录","info");	
		}	
	}
	
	function ReloadResAppDataGrid(){
		CureRBCResSchduleDataGridLoad();
		appList_appListObj.CureApplyAppDataGridLoad();		
	}
	
	function btnExportAppClick(){
		/**
			转到治疗预约 Version 2.0
			appoint.applyreslist.js
		*/
		if(typeof appoint_ResListObj != "undefined"){
			appoint_ResListObj.ExportAppointListData();
			return true;
		}
		
		try{
			var QueryState="^A^I^";
			var QryAllFlag=$HUI.checkbox("#QryAllFlag").getValue();
			if (QryAllFlag){QueryState=""};
			
			var RBASInfo=$.cm({
		    	ClassName:"DHCDoc.DHCDocCure.RBCResSchdule",
		    	MethodName:"GetResApptSchuldeInfo",
		    	ASRowID:PageAppResListObj.m_SelectRBASId,
		    	dataType:"text"
		    },false)
		    var RBASInfoArr=RBASInfo.split("^");
		    var myret=RBASInfoArr[4]+RBASInfoArr[1]+RBASInfoArr[3]+RBASInfoArr[6];
			var Title=myret+"治疗预约表";
			var ExpStr=session['LOGON.USERID']+ "^" + session['LOGON.HOSPID']+ "^" + session['LOGON.LANGID']+ "^" + "doccure.cureapplist.hui.csp";
			//导出
			//ResultSetType:Excel时需要location.href = rtn这句话，导出时可选路径，但是对于登记号这种前边的0会被省略
			//ResultSetType:ExcelPlugin时不能选保存路径，直接到导出到桌面，会覆盖已存在的文件
			var rtn=$.cm({
				dataType:'text',
				ResultSetType:'ExcelPlugin', //Excel
				ExcelName:Title,
				ClassName:"DHCDoc.DHCDocCure.WordReport",
				QueryName:"FindAppointmentListExport",
				'DCARowId':"",
				'QueryState':QueryState,
				'ResSchduleId':PageAppResListObj.m_SelectRBASId,
				ExpStr:ExpStr
			},false);
						
			//不打印-----
			//location.href = rtn;  
			return;
			
			//打印
			var PrintNum = 1; //打印次数
			var IndirPrint = "N"; //是否预览打印
			var TaskName=Title; //打印任务名称
			
			var GridData=$.cm({
				ClassName:"DHCDoc.DHCDocCure.WordReport",
				QueryName:"FindAppointmentListExport",
				'DCARowId':"",
				'QueryState':QueryState,
				'ResSchduleId':PageAppResListObj.m_SelectRBASId,
				Pagerows:PageAppResListObj.m_CureAppointListDataGrid.datagrid("options").pageSize,
				rows:99999
			},false)	
			var DetailData=GridData.rows; //明细信息
			if (DetailData.length==0) {
				$.messager.alert("提示","没有需要打印的数据!");
				return false
			}
			//明细信息展示
			var Cols=[
					{field:'CureApplyNo',title:'申请单号',width:"15%",align:'left'},   
					{field:'PatientNo',title:'登记号',width:"15%",align:'left'},   
        			{field:'PatientName',title:'姓名',width:"10%",align:'left'},   
					//{field:'PatOther',title:'患者其他信息',width:"20%",align:'left', resizable: true},
					{field:'ArcimDesc',title:'治疗项目',width:"20%",align:'left', resizable: true},
					{field:'OrderQty',title:'申请数量',width:"5%",align:'left', resizable: true},
        			{field:'DCAAStatus',title:'预约状态',width:"5%",align:'left', resizable: true},
        			{field:'DCAAQty',title:'治疗数量',width:"5%",align:'left', resizable: true},
					{field:'DCASeqNo',title:'排队序号',width:"5%",align:'left'}
			];	
			PrintDocument(PrintNum,IndirPrint,TaskName,Title,Cols,DetailData)
			return;
		}catch(e){
			$.messager.alert("提示",e.message,"error");	
		}
	}
	
	function InitScheduleList(StartDate){
		if(StartDate=="")return;
		var weekObj={field:'',title:'',align:'center',width:100,resizable:true,
			styler: function(value,row,index){
				var style='cursor:pointer;';
				if(value) {
					var Number=value.split('^')[0];
					var ASStatusCode=value.split('^')[5];
					if(ASStatusCode=="S"){
						style='background-color:#CCC;';
					}else if(Number!='') {
						var AppedLeftNumber=Number.split("/")[0];
						if(AppedLeftNumber=="0"){style +='background-color:#f64c60;'}
					}
					return style;
				}
			},
			formatter:function(value,row,index){
				if(value) {
					var mValue=value.split('^')[0];
					var AppedNumber=value.split('^')[1];
					var ASRowid=value.split('^')[2];
					var AppedNumber=Number(AppedNumber);
					if ((AppedNumber == 0 ||typeof AppedNumber != 'number' || isNaN(AppedNumber))) {
						return "<span>"+mValue+"</span>";
					}else {
						return "<span>"+mValue+"</span>"+"&nbsp;&nbsp;&nbsp;"+"<a href='#' title='预约列表'  onclick='appList_appResListObj.ShowAppointList(\""+ASRowid+"\")'>"+"<span class='fillspan-nosave'>"+AppedNumber+"</span>"+"</a>"
					}
				}
			}
		};
		var ListColumnsArray=[];
	    
		var AdmDateStr=tkMakeServerCall("DHCDoc.DHCDocCure.RBCResSchdule","GetAdmDateStr",StartDate,"","Y","doccure.cureapplist.hui.csp")
		var AdmDateStrArr=AdmDateStr.split("^")
		for(var i=0;i<AdmDateStrArr.length;i++){
			var admDate=AdmDateStrArr[i].split(String.fromCharCode(1))[0];
			var m_i=i+1;
			ListColumnsArray.push($.extend({},weekObj,{field:'admDate'+m_i,title:admDate}))
		}
		ListColumnsArray.push({field:'ServiceGroupDesc',title:'服务组',align:'center',width:90})
		var ListColumns=[ListColumnsArray];
	    var ScheduleTemplateListDataGrid=$("#ScheduleList").datagrid({
			fit : true,
			border:false,
			width : 'auto',
			autoRowHeight : true,
			striped : false,
			singleSelect : true,
			fitColumns : false, 
			nowrap:true,
			url : './dhcdoc.cure.query.grid.easyui.csp',
			loadMsg : '加载中..',
			pagination : true, 
			rownumbers : false, 
			idField:"RowId",
			pageSize:10,
			pageList : [10,20,50],
			frozenColumns : [[
				{field:'ResourceDesc',title:'资源',align:'center',width:180},
				//{field:'ServiceGroupDesc',title:'服务组',align:'center',width:90},
				{field:'TimeDesc',title:'时段',align:'center',width:140},
				{field:'RowId',hidden:true},
				{field:'LocRowid',hidden:true},
				{field:'DocRowid',hidden:true},
				{field:'ServiceGroupID',hidden:true},
				{field:'TimeRangeID',hidden:true}
			]],
			columns :ListColumns,
			onBeforeLoad:function(queryParams){
				var DCARowId="" 
				var DCARowIdStr=GetMainID();
				if(DCARowIdStr==""){
					return;	
				}
				var AppStartDate=StartDate;
				var AppEndDate=StartDate;
				var SessionStr=session['LOGON.HOSPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.USERID']+"^"+session['LOGON.LANGID'];
		
				queryParams.ClassName ='DHCDoc.DHCDocCure.RBCResSchdule';
				queryParams.QueryName ='FindScheduleList';
				queryParams.Arg1 =DCARowIdStr;
				queryParams.Arg2 ="";
				queryParams.Arg3 =DCARowIdStr;
				queryParams.Arg4 =AppStartDate;
				queryParams.Arg5 =AppStartDate;
				queryParams.Arg6 ="";
				queryParams.Arg7 ="";
				queryParams.Arg8 =SessionStr;
				queryParams.ArgCnt = 8;
			},
			onLoadSuccess:function(data){
				MergeCell(data,0,data.rows.length-1,"ResourceDesc");
				InitTimeRangeWinForList(this);
			},
			onDblClickCell:function(rowIndex, field, value){
				if(field.indexOf("admDate")==-1) return;
				var eve = event||window.event;
				var target = eve.target||eve.srcElement;
				var $obj=$(target);
				if(target.nodeName=="DIV") $obj=$(target).parent();
				value=$obj.text();
				if(value.split('/')[0]==0){
					return;	
				}
				var DataArr=$(this).datagrid('getData');
				var FieldValue=DataArr.rows[rowIndex][field];
				if(FieldValue==""||typeof FieldValue=='undefiend'){return}
				var ASRowID=FieldValue.split("^")[2];
				var title=DataArr.rows[rowIndex].ResourceDesc+" "+DataArr.rows[rowIndex].TimeDesc+" "+DataArr.rows[rowIndex].ServiceGroupDesc;
				BtnAppClick(ASRowID,title)
			}
		});
		return ScheduleTemplateListDataGrid;	
	}
	
	function MergeCell(Data,StartIndex,EndIndex,Field){
		if(StartIndex==EndIndex) return;
		var InfoObj={Index:StartIndex,Rows:1,Value:""};
		for(var i=StartIndex;i<=EndIndex;i++){
			var cmd="var value=Data.rows[i]."+Field;
			eval(cmd);
			if(i==StartIndex){
				InfoObj.Value=value;
				continue;
			}
			if((InfoObj.Value==value)&&(EndIndex!=i)){
				InfoObj.Rows+=1;
			}else{
				if((EndIndex==i)&&(InfoObj.Value==value)) InfoObj.Rows+=1;
				if(InfoObj.Rows>1){
					$('#ScheduleList').datagrid('mergeCells',{
						index:InfoObj.Index,
						field:Field,
						rowspan:InfoObj.Rows
					});
					if(Field=="ResourceDesc") 
						MergeCell(Data,InfoObj.Index,InfoObj.Index+InfoObj.Rows-1,'ServiceGroupDesc');
					//else if(Field=="ServiceGroupDesc") 
					//	MergeCell(Data,InfoObj.Index,InfoObj.Index+InfoObj.Rows-1,'ServiceGroup');
				}	
				InfoObj={Index:i,Rows:1,Value:value};
			}
		}
	}
	//周日历列表形式 分时段窗口
	function InitTimeRangeWinForList(that){
		$("#p-ScheduleList td[field^='admDate'] ").mouseover(function(e, value) {
            var eve = event||window.event;
			var target = eve.target||eve.srcElement;
			var $obj=$(target);
			if(target.nodeName=="DIV") $obj=$(target).parent();
			var value=$obj.text();
			if(value=="" || value.split('/')[0]==0){
				return false;	
			}
			var field = $obj.attr("field");
			var rowIndex = $obj.parent().attr("datagrid-row-index");
			var DataArr=$(that).datagrid('getData');
			var mRowData=DataArr.rows[rowIndex];
			if(mRowData==null){
				return false;	
			}
			var FieldValue=mRowData[field];
			if(FieldValue==""||typeof FieldValue=='undefiend'){return}
			var ASRowID=FieldValue.split("^")[2];
			var DDCRSDate=FieldValue.split("^")[3];
			var TRInfo=FieldValue.split("^")[4];
			var TRInfoArr=TRInfo.split("&&");
			var TimeRangeFlag=TRInfoArr[0];
			if(TimeRangeFlag!="Y"){
				return false;	
			}else{
				var TRLength=TRInfoArr[1];
				var TRReservedNum=TRInfoArr[2];
				var TRRegNumStr=TRInfoArr[3];
				var TRRegInfoStr=TRInfoArr[4];
				var TRAvailQtyStr=TRInfoArr[5];
				$.extend(mRowData,{
					Rowid:ASRowID,
					TimeDesc:mRowData.TimeDesc.split(" ")[0],
					TRRegNumStr:TRRegNumStr,
					TRRegInfoStr:TRRegInfoStr,
					TRAvailQtyStr:TRAvailQtyStr,
					DDCRSDate:DDCRSDate
				})
				var trInfo = GetTRInfoHtml(mRowData);
				PageAppResListObj.m_TimeRangeWinTitle=trInfo.title;
	            $(this).popover({
                    width: trInfo.width,
                    height: trInfo.height,
                    title: trInfo.title,
                    content: trInfo.trInfoHtml,
                    closeable: true,
                    arrow:true,
                    trigger: 'hover',
                    placement: 'auto-bottom',
                    onShow:function(){
                        $(".webui-popover").css({
                            'right':'10px'
                        })
                    },onHide:function(){
	                    PageAppResListObj.m_TimeRangeWinTitle="";
	               	}
                })
                $(this).popover('show')
			}
        })
	}
	//页签列表形式 分时段窗口
	function InitTimeRangeWinForTab(GridId){
		$("#ScheduleTab .datagrid-row").mouseover(function(e, value) {
            var mRowid = $(this).children("td").eq(0).text();
            var rows = $("#"+GridId).datagrid('getRows');
            var mRowData = null
            $.each(rows, function(index, row){
                if (row["Rowid"] == mRowid) {
                    mRowData = row
                    return false    // break
                }
            })
            if ((mRowData == null)||(mRowData.TimeRangeFlag != "Y")) {
                return false
            } else {
                var trInfo = GetTRInfoHtml(mRowData);
                PageAppResListObj.m_TimeRangeWinTitle=trInfo.title;
                $("#" + this.id).popover({
                    width: trInfo.width,
                    height: trInfo.height,
                    title: trInfo.title,
                    content: trInfo.trInfoHtml,
                    closeable: true,
                    arrow:true,
                    trigger: 'hover',
                    placement: 'auto-bottom',
                    onShow:function(){
                        $(".webui-popover").css({
                            'right':'10px'
                        })
                    },
                   	onHide:function(){
	                    PageAppResListObj.m_TimeRangeWinTitle="";
	               	}
                })
                $("#"+this.id).popover('show')
            }
        })
	}
	
	function TRCellDBClick(cell) {
		var asRowId = $(cell).attr("trRowId");
		var period = $(cell).attr("period");
		var TRAvailQty = $(cell).attr("td-TRAvailQty");
		var cureApplIdStr = GetMainID();
		if (cureApplIdStr == "") {
			$.messager.alert("提示", "请选中一个治疗申请单", 'warning');
			return false;
		}else{
			if (ServerObj.CureAppVersion=="V1" && cureApplIdStr.split("!").length > TRAvailQty) {
				//$.messager.alert("提示", "分时段预约请选择单个申请单", 'info');
				$.messager.alert("提示", "分时段可用预约号数小于所选的申请单数量,不足以完成预约", 'warning');
				return false;
			}
		}
		var title = "";
		if(ServerObj.ScheuleGridListOrTab=="1"){
	        title=PageAppResListObj.m_TimeRangeWinTitle;
		}
		
		BtnAppClick(asRowId, title, period);
    }
	
	function GetTRInfoHtml(rowData) {
		var trInfoHtml = "<table class='tr-info-table'>"
		var tbTitle = rowData.LocDesc + " " + rowData.ResourceDesc + " " + rowData.TimeDesc+" "+rowData.ServiceGroupDesc;

		var trRowId = rowData.Rowid
		var trRegNumArr = rowData.TRRegNumStr.split(",")
		var trRegInfoArr = rowData.TRRegInfoStr.split(",")
		var trAvailQtyArr = rowData.TRAvailQtyStr.split(",")
		
		var maxCol = 10
		var trNum = trRegNumArr.length
		var rowNum = Math.ceil((trNum / maxCol))
		if (rowNum > 3) {
			maxCol += 2
			rowNum = Math.ceil((trNum / maxCol))
		}
		var ind = 0
		var clickHtml = " ondblclick=appList_appResListObj.TRCellDBClick(this)"
		var noAvailQtyStyle = " class='tr-td-invalid'"
		for (var i = 0; i < rowNum; i++) {
			trInfoHtml += "<tr height='30px;'>";
			for (var j = 0; j < maxCol; j++) {
				if (ind < trNum) {
					var oneTRRegNum = trRegNumArr[ind]
					var oneTRRegInfo = trRegInfoArr[ind]
					var oneTRAvailQty = trAvailQtyArr[ind]
					if (oneTRAvailQty == 0) {
						trInfoHtml += "<td trRowId='" + trRowId + "' td-TRAvailQty='" + oneTRAvailQty + "' period='" + oneTRRegInfo + "'" + noAvailQtyStyle +  ">"
					} else {
						trInfoHtml += "<td class='tr-td' trRowId='" + trRowId + "' td-TRAvailQty='" + oneTRAvailQty + "' period='" + oneTRRegInfo + "'" + clickHtml +  ">"
					}
					trInfoHtml += "<span class='tr-td-seqno'>" + oneTRRegNum + "</span>"
					trInfoHtml += "<span class='tr-td-qty'> #" + oneTRAvailQty + "</span><br>"
					trInfoHtml += "<span class='tr-td-time'>" + oneTRRegInfo + "</span>"
					trInfoHtml += "</td>"
					ind++
				}
			}
			trInfoHtml += "</tr>";
		}
		trInfoHtml += "</table>"

		var width = (maxCol * 85) + 100;
		var height = (rowNum * 50) + 25;

		return {
			"trInfoHtml": trInfoHtml,
			"title": tbTitle,
			"width": width,
			"height": height
		}
	}
	
	function GetMainID(){
		var MainID="";
		if(typeof(PageAppListAllObj) != "undefined"){
			MainID=PageAppListAllObj._SELECT_DCAROWID;
		}else if(typeof(PageAppointMainObj) != "undefined"){
			var SelRow = PageAppointMainObj.m_CureAppPatientDataGrid.datagrid("getSelected");
			if (SelRow){
				MainID = SelRow.DCARowIdStr;
			}
		}
		
		return MainID;
	}
	
	return {
		"InitDate":InitDate,
		"InitApplyResListEvent":InitApplyResListEvent,
		"InitCureRBCResSchduleDataGrid":InitCureRBCResSchduleDataGrid,
		"CureRBCResSchduleDataGridLoad":CureRBCResSchduleDataGridLoad,
		"ShowAppointList":ShowAppointList,
		"GetCurrentGrid":GetCurrentGrid,
		"CureRBCResSchduleDataGridLoad":CureRBCResSchduleDataGridLoad,
		"InitScheduleTab":InitScheduleTab,
		"SelectScheduleTab":SelectScheduleTab,
		"TRCellDBClick":TRCellDBClick
	}
})()