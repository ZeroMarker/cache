/**
	治疗预约 Version 2.0
	appoint.applyreslist.js
	2022-06-02
*/
var appoint_ResListObj=(function(){
	var PageAppResListObj={
		m_CureAppointListDataGrid:"",
		m_SelectRBASId:"",
		m_InputTimeRange:"",
		cspName:"doccure.applyapplist.hui.csp"
	}
	function Appoint(ASRowID,Title,TRTimeRange){ 
	    var SelRow=PageAppointMainObj.m_CureAppPatientDataGrid.datagrid("getSelected");
		if (!SelRow) {
			$.messager.alert("提示", "请选择一个患者记录!");
			return false;
		}
		var PatientID=SelRow.PatientId;
		var PatName=SelRow.PatientName;
		var HasLong=SelRow.HasLong;
		var DCARowIdStr=SelRow.DCARowIdStr;
	    var mASRowID="",mTitle="";
	    if(ServerObj.ScheuleGridListOrTab==0){
		    var GridId=appList_appResListObj.GetCurrentGrid();
		    var rows = $("#"+GridId).datagrid("getSelections");
		    if (rows.length > 0) {
				var ids = [];
				for (var i = 0; i < rows.length; i++) {
					ids.push(rows[i].Rowid);
					mTitle=rows[i].LocDesc+" "+rows[i].ResourceDesc+" "+rows[i].TimeDesc+" "+rows[i].ServiceGroupDesc;
				}
				mASRowID=ids.join(',');
		    }
	    }
	    if(mASRowID == "" && typeof ASRowID!='undefined'){
		    mASRowID=ASRowID;
		    mTitle=Title;
		}
		var mTRTimeRange = "";
		if ((typeof TRTimeRange != "undefined")&&(TRTimeRange != "")) {
			mTRTimeRange = TRTimeRange;
		}
	    if(mASRowID!=""){
			var ExpStr=_PageCureObj.LogUserID+"^"+_PageCureObj.LogGroupID+"^"+_PageCureObj.LogHospID;
			var InsObj={
				PatientID:PatientID, 
				RBASId:mASRowID, 
				RegType:"0",  //线下预约
				LongFlag:HasLong, 
				TimeRange:mTRTimeRange, 
				DCARowID:DCARowIdStr,
				ExpStr:ExpStr
			};
			var InsJson=JSON.stringify(InsObj);
			var RetObj=$.cm({
				ClassName:"DHCDoc.DHCDocCure.AppointmentV2",
				MethodName:"AppInsertBroker",
				'InsJson':InsJson
			},false);
			var value=RetObj.ret;
			var ErrMsg=RetObj.ErrMsg;
			if(value=="0"){
				$.messager.popover({msg: '预约成功！',type:'success',timeout: 3000});
			}else{
				if(("^-1002^-1003^-1004^").indexOf("^"+value+"^")>-1){
				}
				err="'"+PatName+" '"+$g("预约失败,失败原因")+":"+$g(ErrMsg);
				$.messager.alert("提示", err, "warning");
			}
			RefreshDataGrid();
	    }else{
		    $.messager.alert("提示", "请选择要预约的资源", "warning");
		    return;
		}
	}
	
	function ShowAppointList(id,timeRange){
		PageAppResListObj.m_SelectRBASId=id;
		if(typeof(timeRange) != "undefined"){
			PageAppResListObj.m_InputTimeRange=timeRange;
		}
		var dhwid=$(document.body).width()-50;
		var dhhei=$(document.body).height()-100;
		$("#QryAllFlag").checkbox('setValue',false);
		$('#appointlist-dialog').window('open').window('resize',{width:dhwid,height:dhhei,top: 50,left:45});
		var CureAppointListDataGrid=$('#tabCureAppointList').datagrid({  
			fit : true,
			width : 'auto',
			border : false,
			striped : true,
			singleSelect : true,
			checkOnSelect:false,
			fitColumns : false,
			autoRowHeight : false,
			nowrap: false,
			collapsible:false,
			url : $URL+"?ClassName=DHCDoc.DHCDocCure.AppointmentV2&QueryName=FindAppointmentList&rows=9999",
			loadMsg : '加载中..',  
			pagination : true,
			rownumbers : true,
			idField:"QueId",
			pageSize : 20,
			pageList : [20,50],
			columns :[[ 
			//QueId:%String,QueDept:%String,QueDate:%String,ResDesc:%String,ASDate:%String,TimeRange:%String,SchedStTime:%String,SchedEdTime:%String,DDCRSStatus:%String,QueOperUser:%String,QueStatusDate:%String,DCAAStatus:%String,PatNo:%String,PatName:%String,QueNo:%String
	    			{field:'QueId', title: 'QueId', width: 1, align: 'left',hidden:true}, 
					{field:'PatNo',title:'登记号',width:100,align:'left',hidden:true},   
	    			{field:'PatName',title:'姓名',width:80,align:'left'},  
					{field:'ASDate', title:'预约治疗日期', width: 100, align: 'left', resizable: true  },
					{field:'QueNo',title:'排队序号',width:80,align:'left'},
					{field:'DCAAStatus', title: '预约状态', width: 115, align: 'left',resizable: true
						,formatter:function(value,row,index){
							if (value==$g("已预约")){
								return "<span class='fillspan-fullnum'>"+value+"</span>";
							}else if(value==$g("取消预约")){
								return "<span class='fillspan-xapp'>"+value+"</span>";
							}else{
								return "<span class='fillspan-nonenum'>"+value+"</span>";
							}
						}
					},
					{field:'QueDept', title:'科室', width: 150, align: 'left', resizable: true  
					},
	    			{ field: 'ResDesc', title: '资源', width: 100, align: 'left', resizable: true
					},
					{ field: 'TimeRange', title: '时段', width: 140, align: 'left', resizable: true
					},
					{ field: 'SchedStTime', title: '开始时间', width: 80, align: 'left',resizable: true
					},
					{ field: 'SchedEdTime', title: '结束时间', width: 80, align: 'left',resizable: true
					},
					{ field: 'DDCRSStatus', title: '排班状态', width: 80, align: 'left',resizable: true
					},
					{ field: 'QueOperUser', title: '预约操作人', width: 80, align: 'left',resizable: true
					},
					{ field: 'QueStatusDate', title: '最后操作时间', width: 180, align: 'left',resizable: true
					},
					{field:'Job',title:'',width:1,hidden:true}
			 ]],
			 toolbar : [{
					id:'BtnCall',
					text:'取消预约',
					iconCls:'icon-cancel',
					handler:function(){
						CancelCureAppoint();
					}
			}],
			onBeforeLoad:function(param){
				$(this).datagrid("unselectAll");
				var OnlyApp="Y";
				var QryAllFlag=$HUI.checkbox("#QryAllFlag").getValue();
				if (QryAllFlag){OnlyApp=""};
				var SessionStr=PageAppResListObj.cspName+"^"+com_Util.GetSessionStr();
				var ExpStr=PageAppResListObj.m_InputTimeRange;
				$.extend(param,{OnlyApp:OnlyApp,ResSchduleId:PageAppResListObj.m_SelectRBASId,SessionStr:SessionStr,ExpStr:ExpStr});
			}
		});
		PageAppResListObj.m_CureAppointListDataGrid=CureAppointListDataGrid;
		return CureAppointListDataGrid;
	}
	
	function CancelCureAppoint(){
		var row = PageAppResListObj.m_CureAppointListDataGrid.datagrid("getSelected");
		if(row){
			var QueId=row.QueId;
			var SessionStr=PageAppResListObj.cspName+"^"+com_Util.GetSessionStr();
			$.messager.confirm('确认','是否确认取消预约所选预约记录?',function(r){    
			    if (r){ 
					$.m({
						ClassName:"DHCDoc.DHCDocCure.AppointmentV2",
						MethodName:"AppCancelBatch",
						RowIdStr:QueId,
						UserDR:session['LOGON.USERID'],
						SessionStr:SessionStr
					},function testget(value){
						if(value==""){
							PageAppResListObj.m_CureAppointListDataGrid.datagrid("reload")
							RefreshDataGrid();
							$.messager.popover({msg: '取消预约成功！',type:'success',timeout: 3000})
						}else{
							var msgwid=580;
							var msgleft=(document.body.clientWidth-msgwid)/2+document.body.scrollLeft;   
							$.messager.alert('提示',$g("取消失败")+":"+value,"warning")
							.window({
								width:msgwid,
								left:msgleft
							}).css("overflow","auto");;
						}
					})
			    }
			})
		}else{
			$.messager.alert("提示","请选择一条预约记录","warning");		
		}	
	}
	function CureAppointListDataGridLoad(){
		PageAppResListObj.m_CureAppointListDataGrid.datagrid("reload");	
	}
	
	function ExportAppointListData(){
		try{
			var OnlyApp="Y";
			var QryAllFlag=$HUI.checkbox("#QryAllFlag").getValue();
			if (QryAllFlag){OnlyApp=""};
			var SessionStr=PageAppResListObj.cspName+"^"+com_Util.GetSessionStr();
			
			var RBASInfo=$.cm({
		    	ClassName:"DHCDoc.DHCDocCure.RBCResSchdule",
		    	MethodName:"GetResApptSchuldeInfo",
		    	ASRowID:PageAppResListObj.m_SelectRBASId,
		    	dataType:"text"
		    },false)
		    var RBASInfoArr=RBASInfo.split("^");
		    var myret=RBASInfoArr[4]+RBASInfoArr[1]+RBASInfoArr[3]+RBASInfoArr[6];
			var Title=myret+"治疗预约表";
			var ExpStr=PageAppResListObj.m_InputTimeRange;
			//导出
			//ResultSetType:Excel时需要location.href = rtn这句话，导出时可选路径，但是对于登记号这种前边的0会被省略
			//ResultSetType:ExcelPlugin时不能选保存路径，直接到导出到桌面，会覆盖已存在的文件
			var rtn=$.cm({
				dataType:'text',
				ResultSetType:'ExcelPlugin', //Excel
				ExcelName:Title,
				ClassName:"DHCDoc.DHCDocCure.AppointmentV2",
				QueryName:"FindAppointmentListExport",
				PatientId:"",
				OnlyApp:OnlyApp,
				ResSchduleId:PageAppResListObj.m_SelectRBASId,
				SessionStr:SessionStr,
				ExpStr:ExpStr
			},false);
		}catch(e){
			$.messager.alert("提示",e.message,"error");	
		}
	}
	
	return {
		"Appoint":Appoint,
		"ShowAppointList":ShowAppointList,
		"CureAppointListDataGridLoad":CureAppointListDataGridLoad,
		"ExportAppointListData":ExportAppointListData
	}
})()