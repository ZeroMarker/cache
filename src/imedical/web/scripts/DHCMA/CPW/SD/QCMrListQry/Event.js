//页面Event
function InitWinEvent(obj){
	obj.RecRowID=""
	obj.LoadEvent=function() {
		var date=new Date();
		var EDate=Common_GetDate(date)
		var date2=new Date()
		date2.setDate(date2.getDate()-7)
		var SDate=Common_GetDate(date2)
		Common_SetValue('SDate',SDate);
		Common_SetValue('EDate',EDate);
		$('#search').on('click',function () {
			var StatusStr=$('#Status').combobox('getValues').join(',');
			$('#gridQCMrList').datagrid('load',{
		    		ClassName:"DHCMA.CPW.SDS.QCMrListSrv",
					QueryName:"QryQCMrListByDate",	
					aHospID:Common_GetValue('Hospital'),			
					aLocID:Common_GetValue('LocDic'),
					aDocID:Common_GetValue('DocDic'), 
					aQCEntity:Common_GetValue('QCDic'),
					aStatus:StatusStr,
					aDateFrom:Common_GetValue('SDate'),
					aDateTo:Common_GetValue('EDate'),
					aMrNo:Common_GetValue('MrNo')
				});		
		})
	}
	$('#winConfirmInfo').dialog({
		title: '',
		iconCls:"icon-w-edit",
		closed: true,
		modal: true,
		isTopZindex:true	
	});	
	obj.gridQCMrList_onDbselect = function(rd) {
		title="<div id ='CurrStatus'>"+"病种名称："+rd.QCEntityDesc+" /病案号："+rd.MrNo+" /姓名："+rd.PatName+" /出院日期："+rd.DisDate+" /报告状态："+rd.QCCurrStatusDesc+"</div>";
		url="./dhcma.cpw.sd.qcformshow.csp?MrListID=" + rd.RowID + "&random="+Math.random();
		websys_showModal({
			url:url,
			title:title,
			iconCls:'icon-w-epr',
			originWindow:window,
			isTopZindex:true,
			onBeforeClose:function(){ //关闭窗口时调用查询方法实现状态更新
				$('#search').click();
			}
		});
		}
		
	obj.StatusToggle=function(value,ID,QCID)
		{
			var saveRet=0
			if(value=="I") {
				$.messager.confirm("提示", "是否取消确认选中数据记录?", function (r) {				
				if (r) {	
					//弹窗选择取消确认理由，或填写备注	
					//弹窗填写取消排除备注	
					Common_CheckboxToSDRule("RuleDic",QCID,2,1);	
					$('#winConfirmInfo').dialog({
						title: '排除单病种【信息录入】',
						height: 450
					})
					obj.ID=ID;
					obj.value="O";
					$HUI.dialog('#winConfirmInfo').open();	
				} 
				});
			}else if(value=="O") {
				$.messager.confirm("提示", "是否取消排除选中数据记录?", function (r) {				
				if (r) {	
					//弹窗填写取消排除备注	
					Common_CheckboxToSDRule("RuleDic",QCID,1,1);	
					$('#winConfirmInfo').dialog({
						title: '确认单病种【信息录入】',
						height: 300  
					})
					obj.ID=ID;
					obj.value="I";
					$HUI.dialog('#winConfirmInfo').open();	
					
					} 
				});
				}
		}
		
		$('#SaveRule').on('click',function () {
				var RuleStr=Common_CheckboxValue('RuleDic')
				var Resume=$('#RuleResume').val()
				if ((RuleStr=="")&&(Resume=="")) {
						$.messager.alert("错误提示","请选择准入准出规则或者填写备注！", 'info');
						return
				}else{
					var RuleInputStr=obj.ID+"^"+obj.value+"^"+session['LOGON.USERID']+"^"+RuleStr+"^"+Resume
					var flg = $m({
								ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
								MethodName:"ChangeMrlistSatus",
								aInput:RuleInputStr
							},false);
							if (parseInt(flg) < 0) {
								$.messager.alert("错误提示","操作失败!Error=" + flg, 'info');	
							} else {
								$.messager.popover({msg: '操作成功！',type:'success',timeout: 1000});
								$('#gridQCMrList').datagrid('reload');
								
							}
						$HUI.dialog('#winConfirmInfo').close();
					}
				})
	$('#CanCelRule').on('click',function(){$HUI.dialog('#winConfirmInfo').close();})
	/**旧版调用病历
	obj.DisplayEPRView=function(EpisodeID,PatientID)
		{
		if (!EpisodeID) return;
		
		//var strUrl = 'http://139.168.1.47:9080/htweb/ShowInpatientInfo.jsp?ipid=' + EpisodeID;
		var strUrl = "./emr.record.browse.csp?EpisodeID=" + EpisodeID + "&PatientID=" + PatientID + "&2=2";
		var r_width = window.screen.availWidth-50;
		var r_height = window.screen.availHeight-100;
		var v_left = (window.screen.availWidth - 10 - r_width) / 2;		// 获得窗口的水平位置;
		var v_top = (window.screen.availHeight - 30 - r_height) / 2;	// 获得窗口的垂直位置;
		var r_params = "left=" + v_left +
						",top=" + v_top + 
						",width=" + r_width + 
						",height=" + r_height + 
						",status=yes,toolbar=no,menubar=no,location=no";
		window.open(strUrl, "_blank", r_params);
	}
	**/
	obj.DisplayEPRView=function(EpisodeID,PatientID)
		{
		if (!EpisodeID) return;
		
		//var strUrl = "./emr.browse.csp?EpisodeID=" + EpisodeID + "&PatientID=" + PatientID + "&2=2";
		var strUrl = cspUrl+"&PatientID=" + PatientID+"&EpisodeID="+EpisodeID + "&2=2";
		websys_showModal({
			url:strUrl,
			title:'病历浏览',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:'98%',
			height:'98%'
		});
	}
	obj.UpForm=function(MrListID)
	{
		$.messager.progress({
				title: "提示",
				msg: '正在上传数据',
				text: '上传中....'
		});
		$m({
		ClassName:'DHCMA.CPW.SDS.QCInterface',
		MethodName:'Upload',
		aMRListID:MrListID	
		},function(UpRet){
			$.messager.progress("close")
			if (parseInt(UpRet)==1) {
				$.messager.popover({msg: '上传成功！',type:'success',timeout: 1000})
				//改变表单状态
				var StateStr=MrListID+"^Up^"+session['LOGON.USERID']
				ErrInfo=$m({
							ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
							MethodName:"ChangeMrlistSatus",
							aInput:StateStr
					},false)
					if (ErrInfo){
							$.messager.alert("错误提示", "表单状态更新错误!Error=" + ErrInfo, 'info');
						}else{
						//刷新列表
						$('#gridQCMrList').datagrid('reload');
					}
				
				}else if(UpRet.indexOf('病案号重复')>0){					
					//改变表单状态
					var StateStr=MrListID+"^Up^"+session['LOGON.USERID']
					ErrInfo=$m({
								ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
								MethodName:"ChangeMrlistSatus",
								aInput:StateStr
						},false)
					if (ErrInfo){
							$.messager.popover({msg: '已存在上传记录，更新上传状态错误'+ErrInfo+'！',type:'success',timeout: 3000})
						}else{
							$.messager.popover({msg: '已存在上传记录，更新上传状态成功！',type:'success',timeout: 3000})
							//刷新列表
							$('#gridQCMrList').datagrid('reload');
					}
					
				}else{
					$.messager.alert('错误信息',UpRet, 'error');
					}
		})
	}
}
HISUIHtml =function(){
	$HUI.tooltip("a.grid-tips",{position:'right'})
}