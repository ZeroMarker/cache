//页面Event
function InitCheckQueryWinEvent(obj){	
    
	obj.LoadEvent = function(args){ 
		//查询
		$('#btnQuery').on('click', function(){
			obj.CheckQueryLoad();
		});
		$('#btnAgree').on('click', function(){
			var data=obj.GridCheckQuery.getSelected();
			if(data){
				//if(data["StatusDesc"]!="申请"){$.messager.alert("提示","您已经审核过了"); return};
				obj.btnAgree_click(data);
				
			}else{
			$.messager.alert("错误提示","请先选中一行")	
			}
			
		});
		$('#btnRefuse').on('click', function(){
			var data=obj.GridCheckQuery.getSelected();
			if(data){
				//if(data["StatusDesc"]!="申请") {$.messager.alert("提示","您已经审核过了"); return};
				obj.btnRefuse_click(data);
			}else{
				$.messager.alert("错误提示","请先选中一行")	
			}
		});
		
		//状态选择事件
		$HUI.combobox("#chkStatus", {
			onSelect:function(){
				obj.CheckQueryLoad();
			}
		});
		
		//科室选择事件
		$HUI.combobox("#cboLoc", {
			onSelect:function(){
				obj.CheckQueryLoad();
			}
		});
		
		$HUI.combobox("#cboApplyType", {
			onSelect:function(){
				obj.CheckQueryLoad();
			}
		});
		
		$('#GridCheckQuery').datagrid({
			onDblClickRow: function(index,row){
				var strUrl = "websys.csp?1=1&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&TMENU=54653&PatientID="+row['PatientID']+"&EpisodeID="+row['PaadmID'];
				//"./emr.record.browse.patient.csp?1=1" + 
						//	+"&PatientID=" + row['PatientID'] + "&EpisodeID=" + row['PaadmID'];
					 websys_showModal({
						url:strUrl,
						title:'浏览病历',
						iconCls:'icon-w-edit',  
						//onBeforeClose:function(){alert('close')},
						//dataRow:{ParamRow:obj.ItemRowData},   //？
						originWindow:window,
						width:1300,
						height:600
					});
			}
		});

	}
	$('#btnExport').on('click',function(){
			/*var ExcelTitles="登记号^病案号^患者姓名^性别^年龄^申请科室^申请类型^申请医生^医生电话^状态^路径名称^原因类型^具体原因^申请日期^拒绝原因"
			var ClassName="DHCMA.CPW.CPS.ApplySrv"
			var QueryName="QryApplyInfo"
			var aInArgs ="PapmiNo^MrNo^PatName^PatSex^PatAge^LocDesc^TypeDesc^AppUserDesc^MobilePhone^StatusDesc^CPWDesc^Reason^ApplyTxt^ApplyDate^VerNote"
			var aTypeID =Common_GetValue('cboApplyType');
			var aDateFrom=Common_GetValue('DateFrom');
			var aDateTo=Common_GetValue('DateTo');
			var aStatus=Common_GetValue('chkStatus');
			var aLocID=Common_GetValue('cboLoc');
			var aHospID=Common_GetValue('cboSSHosp');
			var ExcelName="路径申请审核"+aDateFrom.replace(/[-\/]/g,"")+"-"+aDateTo.replace(/[-\/]/g,"")
			
			var rtn=tkMakeServerCall("DHCMA.Util.Test.ExportFileSrv","ToExcel",ExcelName,ExcelTitles,ClassName,QueryName,aInArgs,aTypeID,aDateFrom,aDateTo,aStatus,aHospID,aLocID)
			location.href=rtn;*/
			var rows = obj.GridCheckQuery.getRows().length; 
		
			if (rows>0) {
		   		//ExportCPWGridByCls(obj.GridCheckQuery,'临床路径审核表');
		   		$('#GridCheckQuery').datagrid('toExcel','临床路径审核表.xls');
			}else {
				$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			}
		});
  
	obj.CheckQueryLoad = function(){
		var DateFrom = $('#DateFrom').datebox('getValue');
		var DateTo = $('#DateTo').datebox('getValue');
		if ((DateFrom == '')||(DateTo == '')) {
			$.messager.alert("提示","开始日期、结束日期不允许为空!",'info');
			return;
		}
		if (Common_CompareDate(DateFrom,DateTo)>0) {
			$.messager.alert("提示","开始日期不能大于结束日期!",'info');
			return;
		}	
		/*obj.GridCheckQuery.load({
			ClassName:"DHCMA.CPW.CPS.ApplySrv",
			QueryName:"QryApplyInfo",	
			aTypeID: Common_GetValue('cboApplyType'),
			aDateFrom: Common_GetValue('DateFrom'), 
			aDateTo:Common_GetValue('DateTo'), 
			aStatus: Common_GetValue('chkStatus'),
			aLocID:Common_GetValue('cboLoc'),
			aHospID:Common_GetValue('cboSSHosp'),
			aNotIn:$("#NotInPath").checkbox('getValue')? '1':''	
	    });	*/
		$cm ({
			ClassName:"DHCMA.CPW.CPS.ApplySrv",
			QueryName:"QryApplyInfo",	
			aTypeID: Common_GetValue('cboApplyType'),
			aDateFrom: Common_GetValue('DateFrom'), 
			aDateTo:Common_GetValue('DateTo'), 
			aStatus: Common_GetValue('chkStatus'),
			aLocID:Common_GetValue('cboLoc'),
			aHospID:Common_GetValue('cboSSHosp'),
			aNotIn:$("#NotInPath").checkbox('getValue')? '1':'',
			page:1,
			rows:999
		},function(rs){
			$('#GridCheckQuery').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});	
    }
	obj.btnAgree_click=function(rowData){
		var InputStr=""
		var Separete="^"
		var Parref=rowData["Parref"]
		var ChildID=rowData["SubID"]
		var IsVerify="1"
		var VerNote=""
		var UserID=session['DHCMA.USERID'];
		
		InputStr=Parref;
		InputStr=InputStr+Separete+ChildID;
		InputStr=InputStr+Separete+IsVerify;
		InputStr=InputStr+Separete+VerNote;
		InputStr=InputStr+Separete+UserID;
		var EpisodeID=rowData["EpisodeID"];
				if (rowData["TypeDesc"]=="不入径申请"){
					var Context         = "不入径审核通过";
					var ActionTypeCode  = "1128";
				}else{
					var Context         = "出径申请审核通过";
					var ActionTypeCode  = "1149";
				}
				var FromUserRowId   = UserID;
				var EpisodeId       = EpisodeID;
				var EpisodeId       = EpisodeId.split("!!")[0];
				var FromUserRowId   = FromUserRowId.split("!!")[0];
		
		var flg=$m({
			ClassName:'DHCMA.CPW.CP.PathwayApply',
			MethodName:'Check',
			aInputStr:InputStr,
			aSeparete:Separete
		},false)
	
		if(parseInt(flg)>0){
			$.messager.popover({msg: '审核成功!',type:'success',timeout: 1000});
			var flg=$m({
						ClassName:'DHCMA.Util.IO.FromHisSrv',
						MethodName:'SendMsg',
						aContext:Context,
						aActTypeCode:ActionTypeCode,
						aFromUser:FromUserRowId,
						aEpisodeID:EpisodeId
					},false)
			obj.CheckQueryLoad();
		}else{
			$.messager.popover({msg: '审核失败！',type:'success',timeout: 1000});
		}
	}
	obj.btnRefuse_click=function(rowData){
		$.messager.prompt("提示", "填写拒绝原因：", function (r) {
			if (r) {
				var InputStr=""
				var Separete="^"
				var Parref=rowData["Parref"]
				var ChildID=rowData["SubID"]
				var IsVerify="0"
				var VerNote=""
				var UserID=session['DHCMA.USERID'];
				InputStr=Parref;
				InputStr=InputStr+Separete+ChildID;
				InputStr=InputStr+Separete+IsVerify;
				InputStr=InputStr+Separete+r;
				InputStr=InputStr+Separete+UserID;
				var EpisodeID=rowData["EpisodeID"];
				if (rowData["TypeDesc"]=="不入径申请"){
					var Context         = "不入径审核拒绝："+r;
					var ActionTypeCode  = "1129";
				}else{
					var Context         = "出径申请拒绝："+r;
					var ActionTypeCode  = "1148";
				}
				var FromUserRowId   = UserID;
				var EpisodeId       = EpisodeID;
				var EpisodeId       = EpisodeId.split("!!")[0];
				var FromUserRowId   = FromUserRowId.split("!!")[0];
				
				var flg=$m({
					ClassName:'DHCMA.CPW.CP.PathwayApply',
					MethodName:'Check',
					aInputStr:InputStr,
					aSeparete:Separete
				},false)
				
				if(parseInt(flg)>0){
					$.messager.popover({msg: '审核成功!',type:'success',timeout: 1000});
					var flg=$m({
						ClassName:'websys.DHCMessageInterface',
						MethodName:'Send',
						Context:Context,
						ActionTypeCode:ActionTypeCode,
						FromUserRowId:FromUserRowId,
						EpisodeId:EpisodeId
					},false)
					obj.CheckQueryLoad();
				}else{
					$.messager.popover({msg: '审核失败！',type:'success',timeout: 1000});
				}
			} else {
				if(r==""){
					$.messager.alert("提示", "拒绝原因不允许为空！", "info",function () { 
					var data=obj.GridCheckQuery.getSelected();
					obj.btnRefuse_click(data)
					});
					}
				//$.messager.popover({msg:"点击了【取消】或输入为空"});
			}
		});
	};
}