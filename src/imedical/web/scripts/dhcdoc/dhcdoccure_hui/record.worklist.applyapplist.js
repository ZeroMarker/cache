var workList_AppListObj=(function(){
	var CureWorkApplyAppDataGrid;
	var TransExpStr=session['LOGON.HOSPID']+ "^" + session['LOGON.LANGID']+ "^" + PageWorkListAllObj.cspName;
	function InitCureApplyAppDataGrid(){
		var cureApplyAppToolBar = [
		/*{
			id:'BtnDetailAdd',
			text:'添加治疗记录', 
			iconCls:'icon-add',  
			handler:function(){
				AddCureRecord();
			}
		},*/{
			id:'BtnDetailAdds',
			text:'添加治疗记录',
			iconCls:'icon-add',
			handler:function(){
				GenAddCureRecord();
			}
		},{
			id:'BtnDetailView',
			text:'浏览治疗记录', 
			iconCls:'icon-funnel-eye',  
			handler:function(){
				DetailView();
			}
		},{
			id:'BtnCancelRecord',
			text:'撤消治疗记录', 
			iconCls:'icon-cancel',  
			handler:function(){
				CancelRecord();
			}
		},"-",
		{
			id:'BtnPrint',
			text:'打印预约治疗凭证',
			iconCls:'icon-print',
			handler:function(){
				BtnPrintApplyClick()
			}
		},{
			id:'BtnUploadPic',
			text:'上传图片', 
			iconCls:'icon-upload-cloud',  
			handler:function(){
				UploadPic();
			}
		}];
		CureWorkApplyAppDataGrid=$('#tabCureWorkApplyApp').datagrid({  
			fit : true,
			width : 'auto',
			border : false,
			striped : true,
			singleSelect : false,
			fitColumns : false,
			autoRowHeight : false,
			loadMsg : '加载中..',  
			pagination : true,
			rownumbers : true,
			idField:"Rowid",
			pageSize:10,
			pageList : [10,25,50],
			columns :[[     
				{field:'Rowid', title: '治疗预约记录ID', width: 1, align: 'left',hidden:true}, 
				{field:'RowCheck',checkbox:true},
				{field:'PatientNo',title:'登记号',width:100,align:'left'},   
				{field:'PatientName',title:'姓名',width:80,align:'left'},  
				{field:'ArcimDesc',title:'治疗项目',width:150,align:'left'},
				{field:'DDCRSDate', title:'日期', width: 100, align: 'left', resizable: true},
				{field:'DCASeqNo',title:'排队序号',width:70,align:'left'},
				{field:'LocDesc', title:'科室', width: 150, align: 'left', resizable: true},
				{field:'ResourceDesc', title: '资源', width: 100, align: 'left', resizable: true},
				{field:'TimeDesc', title: '时段', width: 60, align: 'left', resizable: true},
				{field:'DCAAStatus', title: '治疗状态', width: 80, align: 'left',resizable: true},
				{field:'DCRIsAssess',title:'是否已做评估',width:100, hidden: true} ,
				{field:'DCRTitle',title:'治疗记录标题',width:200},  
				{field:'DCRCreateUser',title:'治疗记录创建人',width:120},
				{field:'DCRCreateDate',title:'治疗记录创建时间',width:150},
				{field:'DCRIsPicture',title:'是否有图片',width:80,
					formatter:function(value,row,index){
						if(value!=""){
							return '<a href="###" id= "'+row["DCRRowId"]+'"'+' onmouseover=workList_RecordListObj.ShowCurePopover(this);'+' onclick=workList_AppListObj.ShowCureRecordPic(\''+row.DCRRowId+'\');>'+$g("查看图片")+"</a>"
						}else{
		        			return "";	
		        		}
					},
					styler:function(value,row){
						return "color:blue;text-decoration: underline;"
					}
				},
				{field: 'DCRTrance', title: '治疗过程追踪', width:100, align: 'center', 
					formatter: function (value, rowData, rowIndex) {
						retStr = "<a href='#' title='治疗过程追踪'  onclick='workList_RecordListObj.ShowReportTrace(\""+rowData.DCRRowId+"\","+"\""+rowData.Rowid+"\")'><span class='icon-track' title='治疗过程追踪')>&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>"
						return retStr;
					}
				},
				{field:'DCRUpdateUser',title:'治疗最后更新人',width:110},
				{field:'DCRUpdateDate',title:'治疗最后更新时间',width:150},
				{field:'DCRRowId',title:'治疗记录ID',width:50,hidden: true},
				{field:'DCAssRowId',title:'治疗评估ID',width:50,hidden: true},
				{field:'OEOREDR',title:'执行记录ID',width:50,hidden: true},
				{field: 'DDCRSStatus', title: '排班状态', width: 80, align: 'left',hidden: true},
				{field: 'StartTime', title: '开始时间', width: 80, align: 'left',hidden: true
				},
				{field: 'EndTime', title: '结束时间', width: 80, align: 'left',hidden: true
				},
				{field: 'ServiceGroupDesc', title: '服务组', width: 80, align: 'left',hidden: true
				},
				{field: 'ReqUser', title: '预约操作人', width: 80, align: 'left',hidden: true
				},
				{field: 'ReqDate', title: '预约操作时间', width: 80, align: 'left',hidden: true
				},
				{field: 'LastUpdateUser', title: '更新人', width: 80, align: 'left',hidden: true
				},
				{field: 'LastUpdateDate', title: '更新时间', width: 80, align: 'left',hidden: true
				} 
			 ]] ,
	    	toolbar : cureApplyAppToolBar,
	    	onDblClickRow: function(index,row) {
				var DCRRowId=GetSelectDCRRowId();
				if (DCRRowId=="") return;
		        if (websys_emit){
			        var OperateType=$('#OperateType').val();
				    var Obj={OperateType:"",DCAARowId:"",DCRRowId:DCRRowId};
					websys_emit("onOpenCureRecordInfo",Obj);
				}
	        }
            
		});
		CureWorkApplyAppDataGridLoad();
	}
	/**
	*治疗记录列表数据加载
	**/
	function CureWorkApplyAppDataGridLoad(){
		var DCARowIdStr=PageWorkListAllObj._WORK_SELECT_DCAROWID; 
		var DCARowId=PageWorkListAllObj._WORK_SELECT_DCAROWID;
		var QueryState="";
		var OperateType=$('#OperateType').val();
		if(OperateType=="ZLYS"){
			QueryState="^I^A^";
		}
		if(DCARowIdStr!="")DCARowId=DCARowIdStr;
		$.cm({
			ClassName:"DHCDoc.DHCDocCure.Appointment",
			QueryName:"FindAppointmentListHUI",
			'DCARowId':DCARowId,
			'QueryState':QueryState,
			'Type':"WORK",
			ExpStr:TransExpStr,
			Pagerows:CureWorkApplyAppDataGrid.datagrid("options").pageSize,
			rows:99999
		},function(GridData){
			CureWorkApplyAppDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
			CureWorkApplyAppDataGrid.datagrid("clearSelections");
			CureWorkApplyAppDataGrid.datagrid("clearChecked");	
		})
	}
	/**
	*治疗记录添加
	**/
	function GenAddCureRecord(){ 
		var rows = CureWorkApplyAppDataGrid.datagrid("getSelections");
		if(rows.length==0){
			$.messager.alert("提示","请选择一条预约记录.","warning");
			return false;
		}
		var selIDAry=new Array();
		for(var i=0;i<rows.length;i++){
			var Rowid=rows[i].Rowid;
			if(Rowid!=""){
				selIDAry.push(Rowid)
			}
		}
		if(selIDAry.length>0){
			var selRowid=selIDAry.join("^");
			if(CheckBeforeSelect(selRowid)){
				OpenCureRecordDiag(selRowid);
			}	
		}
	}
	/**
	*治疗记录添加之前进行部分验证
	**/
	function CheckBeforeSelect(selRowid){
		var ChkMsg=$.cm({
			ClassName:"DHCDoc.DHCDocCure.Record",
			MethodName:"CheckBeforeUpdateBatch",
			DCAARowIdStr:selRowid,
			UserID:session['LOGON.USERID'],
			TransExpStr:TransExpStr,
			dataType:"text"
		},false)
		if(ChkMsg!=""){
			$.messager.alert("提示",ChkMsg, 'warning');
			return false;	
		}
		return true;
	}
	function AddCureRecord(){
		
	}
	/**
	*治疗记录填写窗口弹出
	**/
	function OpenCureRecordDiag(DCAARowId)
	{
		var argObj={
			DHCDocCureRecordLinkPage:ServerObj.DHCDocCureRecordLinkPage,
			DCAARowId:DCAARowId,
			Source:"",
			callback:AfterSaveCureRecord
		}
		com_openwin.ShowCureRecordDiag(argObj);
	}
	function AfterSaveCureRecord(){
		CureWorkApplyAppDataGridLoad();	
		if(ServerObj.LayoutConfig=="1"){
			if(window.frames.parent.CureWorkListDataGrid){
				window.frames.parent.RefreshDataGrid();
			}else{
				RefreshDataGrid();	
			}	
		}
	}
	/**
	*预约凭证打印
	**/
	function BtnPrintApplyClick(){
		DHCP_GetXMLConfig("XMLObject","DHCDocCureAppointPrt"); 
		var OperateType=$('#OperateType').val();
		var SelectIDArr={};
		var rows = CureWorkApplyAppDataGrid.datagrid("getSelections");
		if (rows.length > 0) {
	        for (var i = 0; i < rows.length; i++) {
	            var Rowid=rows[i].Rowid;
	            if(Rowid=="")continue;
	            var DCARowID=Rowid.split("||")[0];
		        var FindFlag=false;
		        for (var key in SelectIDArr) {
			        if (key == DCARowID) {
			            if (SelectIDArr[key].indexOf(Rowid) == -1){
				            if(SelectIDArr[key] == "") {
			                	SelectIDArr[key]=Rowid;
				            }else{
					        	SelectIDArr[key]+="^"+Rowid;
					        }
			            }
			            FindFlag=true;
			        }
			    }
				if(!FindFlag){
					SelectIDArr[DCARowID]=Rowid;
				}

	        }
	        for (var keyVal in SelectIDArr) {
		        var DCAARowIdStr=SelectIDArr[keyVal];
		        if(keyVal=="")continue;
				PrintCureAppXML(keyVal,DCAARowIdStr);
	        }
		}else{
			$.messager.alert("提示","请选择需要打印的患者预约记录", 'error');	
		}	
	}
	/**
	*预约凭证打印
	**/
	function PrintCureAppXML(ID,IDStr)
	{
		var RtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetCureApply",ID)
		if(RtnStr==""){
			$.messager.alert("提示","获取申请单信息错误", 'error')
			return false
		}
		var MyList="";
		var AppointRtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.Appointment","GetAllCureAppointment",ID,IDStr)
		if(AppointRtnStr==""){
			$.messager.alert("提示","未有正常预约的预约纪录,请确认.", 'error')
			return false
		}
		var AppointRtnArr=AppointRtnStr.split("^");
		var RtnStrArry=RtnStr.split(String.fromCharCode(1));
		var PatientArr=RtnStrArry[0].split("^"); //患者基本信息
		var CureApplyArr=RtnStrArry[1].split("^"); //预约单信息		
		var PatID=PatientArr[0]
		var PatNo=PatientArr[1];
		var PatName=PatientArr[2];
		var PatSex=PatientArr[3];
		var PatAge=PatientArr[4];
		//var PatType=PatientArr[6];
		var PatTel=PatientArr[24];
		var PatAddress=PatientArr[10];
		var ApplyUser=CureApplyArr[7]
		var ArcimDesc=CureApplyArr[0]
		var AppReloc=CureApplyArr[4];
		
		var MyPara="";
	    MyPara="PAPMINo"+String.fromCharCode(2)+PatNo;
	    MyPara=MyPara+"^Name"+String.fromCharCode(2)+PatName;
	    MyPara=MyPara+"^Age"+String.fromCharCode(2)+PatAge;
	    MyPara=MyPara+"^Sex"+String.fromCharCode(2)+PatSex;
	    MyPara=MyPara+"^Mobile"+String.fromCharCode(2)+PatTel;
	    MyPara=MyPara+"^RecDep"+String.fromCharCode(2)+AppReloc;
	    MyPara=MyPara+"^ArcimDesc"+String.fromCharCode(2)+ArcimDesc;
	    MyPara=MyPara+"^ApplyDoc"+String.fromCharCode(2)+ApplyUser;
	    MyPara=MyPara+"^PatientCode"+String.fromCharCode(2)+PatNo;
	    
	    var myobj=document.getElementById("ClsBillPrint");
		var LimitRow=6;
		var PrintPage=0;
		var PageTotal=Math.ceil(AppointRtnArr.length/LimitRow);
		var AppointRtnLen=AppointRtnArr.length;
		for(var i=1;i<=AppointRtnLen;i++){
			if(MyList==""){MyList=AppointRtnArr[i-1];}
			else{MyList=MyList+String.fromCharCode(2)+AppointRtnArr[i-1];}
			if ((i>1)&&(i%LimitRow==0)) {
				var PrintPage=PrintPage+1;
				var PrintPageText="第 "+PrintPage+" 页  共 "+PageTotal+" 页"
				//DHCP_PrintFunNew(myobj,MyPara,MyList);
				DHC_PrintByLodop(getLodop(),MyPara,MyList,"","");
				MyList="";
			}
		}
		if((AppointRtnLen%LimitRow)>0){
			var PrintPageText="第 "+PageTotal+" 页  共 "+PageTotal+" 页"
			//DHCP_PrintFunNew(myobj,MyPara,MyList);
			DHC_PrintByLodop(getLodop(),MyPara,MyList,"","");
		}
		
		//打印成功后给患者发送短信
		//var ret=tkMakeServerCall("DHCDoc.DHCDocCure.Appointment","SendMessage",DCARowId,session['LOGON.USERCODE'])
		//if(ret!="0"){
		//	$.messager.alert("提示","短信纪录发送失败,请确认.")
		//	return false
		//}
	}
	
	function GetSelectDCRRowId(MultiFlag){
		var rows = CureWorkApplyAppDataGrid.datagrid("getSelections");
		if (rows.length==0){
			$.messager.alert("提示","请选择一条治疗记录",'warning');
			return "";
		}else if (rows.length>1 && MultiFlag!="Y"){
	 		$.messager.alert("提示","您选择了多个治疗记录！",'warning')
	 		return "";
		}
		var DCRRowId="";
		var selIDAry=new Array();
		for(var i=0;i<rows.length;i++){
			var Rowid=rows[i].DCRRowId;
			if(Rowid!=""){
				selIDAry.push(Rowid)
			}
		}
		if(selIDAry.length>0){
			DCRRowId=selIDAry.join("^");
		}
		if(DCRRowId==""){
			$.messager.alert("提示","仅允许操作已治疗的记录,请确认.",'warning')
	 		return "";
		}
		return DCRRowId;
	}
	/**
	*治疗记录浏览，调用record.worklist.curerecordlist.js方法
	**/
	function DetailView(){
		var DCRRowId=GetSelectDCRRowId()
		if(DCRRowId==""){
			return false;
		}
		workList_RecordListObj.ShowCureRecordDiag(DCRRowId,CureWorkApplyAppDataGridLoad);	
	}
	/**
	*治疗记录撤销，调用record.worklist.curerecordlist.js方法
	**/
	function CancelRecord(){
		var DCRRowIdStr=GetSelectDCRRowId("Y");
		if(DCRRowIdStr==""){
			return false;
		}
		workList_RecordListObj.CancelRecordBatch(DCRRowIdStr,AfterSaveCureRecord)
	}
	/**
	*治疗记录图片上传，调用record.worklist.curerecordlist.js方法
	**/
	function UploadPic(){
		var DCRRowId=GetSelectDCRRowId()
		if(DCRRowId==""){
			return false;
		}
		workList_RecordListObj.UploadPic(DCRRowId,CureWorkApplyAppDataGridLoad);
	}
	/**
	*治疗记录图片浏览，调用record.worklist.curerecordlist.js方法
	**/
	function ShowCureRecordPic(DCRRowId){
		if(DCRRowId=="" || typeof DCRRowId=="undefined"){
			var DCRRowId=GetSelectDCRRowId()
			if(DCRRowId==""){
				return false;
			}
		}
		workList_RecordListObj.ShowCureRecordPic(DCRRowId,CureWorkApplyAppDataGridLoad);
	}
	
	return {
		"InitCureApplyAppDataGrid":InitCureApplyAppDataGrid,
		"ShowCureRecordPic":ShowCureRecordPic,
		"CureWorkApplyAppDataGridLoad":CureWorkApplyAppDataGridLoad
	}
})()
