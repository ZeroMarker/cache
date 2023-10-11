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
		$('#Export').on('click',function () {
			var rows=$("#gridQCMrList").datagrid('getRows').length;
			if (rows>0) {
				$('#gridQCMrList').datagrid('toExcel',$g('病种数据')+'.xls');	
			}else {
				$.messager.alert($g("确认"), $g("无数据记录")+","+$g("不允许导出"), 'info');
				return;
			}	
		})
		$('#search').on('click',function () {
			$('#gridQCMrList').datagrid('loading');
			$('#gridQCMrList').datagrid('clearSelections');
			var StatusStr=$('#Status').combobox('getValues').join(',');
			$cm ({
			    ClassName:"DHCMA.CPW.SDS.QCMrListSrv",
				QueryName:"QryQCMrListByDate",
				aHospID:Common_GetValue('Hospital'),			
				aLocID:Common_GetValue('LocDic'),
				aDocID:Common_GetValue('DocDic'), 
				aQCEntity:$('#QCDic').combobox('getValues').join(','),
				aStatus:StatusStr,
				aDateFrom:Common_GetValue('SDate'),
				aDateTo:Common_GetValue('EDate'),
				aDateType:Common_GetValue('DateType'),
				aMrNo:Common_GetValue('MrNo'),
				rows:99999
			},function(rs){
				//这种加载方式 导出才能导出全部记录
				$('#gridQCMrList').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
				
			});
		})
		$('#MrNo').on('keydown',function (e) {
            if (e.keyCode == 13) {
               $('#search').click();
            }
        });
        $('#updoAll').on('click',function () {
            var rows=$("#gridQCMrList").datagrid('getChecked')
            var rowlen=rows.length;
			//校验批量上传时  表单状态是否合法（只允许提交/审核/上报失败的病例直接上传）
            var checkError=""
            for (var i=0;i<rowlen;i++) {
					var Status=rows[i].QCCurrStatus
					if ((Status!="Submit")&&(Status!="tUp")&&(Status!="Check")) {
						var checkError=checkError+"【"+rows[i].PatName+"】"+$g("当前状态不允许上传")+"！<br>"
					}
            }
            if (checkError!="") {
	            $.messager.alert($g('错误信息'),checkError, 'error');	
	            return;
	        }
            var UpInfo=$g("上传失败病例信息")+":<br>",UpCount=0,UpSuInfo=""
            //记录已上传个数
            ucount=0
			if (rowlen>0) {
				$.messager.progress({
					title: $g("提示"),
					msg: $g('正在上传数据'),
					text: $g('上传中')+'....'
				});
				for (var i=0;i<rowlen;i++) {
					var MrListID=rows[i].RowID
					var UpRet=$m({
						ClassName:'DHCMA.CPW.SDS.QCInterface',
						MethodName:'Upload',
						aMRListID:MrListID
					},false)
					var MrNo=rows[i].MrNo,PatName=rows[i].PatName;
					ucount=ucount+1
					var UpRetArr=UpRet.split('^')
					if (UpRetArr[0]==1) {
						var statusCode="Up"
						if (UpRetArr[1]=="") {
							var statusCode="tUp";
						}
						UpCount=UpCount+1
						//改变表单状态
						var StateStr=MrListID+"^"+statusCode+"^"+session['LOGON.USERID']
						ErrInfo=$m({
									ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
									MethodName:"ChangeMrlistSatus",
									aInput:StateStr
							},false)
					}else{
						UpInfo=UpInfo+PatName+"["+MrNo+"]:"+UpRet+'<br>'	
					}
					if (ucount==rowlen) {
						$.messager.progress("close")
						if (UpCount>0) {
							UpSuInfo=$g("成功上传病例")+UpCount+$g("份")+"<br><hr/>"
						}
						$.messager.alert($g('提示信息'),UpSuInfo+UpInfo, 'info');	
					}
					
				}					
			}else {
				$.messager.alert($g("确认"), $g("请选中需要上传的病历")+"！", 'info');
				return;
			}
        });
	}
	$('#winConfirmInfo').dialog({
		title: '',
		iconCls:"icon-w-edit",
		closed: true,
		modal: true,
		isTopZindex:true	
	});	
	obj.gridQCMrList_onDbselect = function(rd) {
		title="<div id ='CurrStatus'>"+$g("病种名称")+"："+rd.QCEntityDesc+" /"+$g("病案号")+"："+rd.MrNo+" /"+$g("姓名")+"："+rd.PatName+" /"+$g("出院日期")+"："+rd.DisDate+" /"+$g("报告状态")+"："+$g(rd.QCCurrStatus)+"</div>";
		url="./dhcma.cpw.sd.qcformshow.csp?MrListID=" + rd.RowID + "&random="+Math.random();
		websys_showModal({
			url:url,
			title:title,
			iconCls:'icon-w-epr',
			originWindow:window,
			isTopZindex:true,
			onBeforeClose:function(){ 
				//获取病例当前状态信息
				var StatusStr=$m({
					ClassName:'DHCMA.CPW.SDS.QCMrListSrv',
					MethodName:'GetStatusByMrListID',
					aMrListID:rd.RowID
				},false)
				//实现状态更新
				var RowIndex=$('#gridQCMrList').datagrid('getRowIndex',rd)
				$("#gridQCMrList").datagrid("updateRow",{  
            	       index:RowIndex, //行索引  
                	   row:{  
                    		QCCurrStatus:StatusStr.split('^')[0],
                    		QCCurrStatusDesc:StatusStr.split('^')[1]
                    	  }  
     		 		})	
			}
		});
		}
		
	obj.StatusToggle=function(value,ID,QCID)
		{
			var saveRet=0
			if(value=="I") {
				$.messager.confirm($g("提示"), $g("是否取消确认选中数据记录")+"?", function (r) {				
				if (r) {	
					//弹窗选择取消确认理由，或填写备注	
					//弹窗填写取消排除备注	
					Common_CheckboxToSDRule("RuleDic",QCID,2,1);	
					$('#winConfirmInfo').dialog({
						title: $g('排除单病种'),
						height: 450
					})
					obj.ID=ID;
					obj.value="O";
					$HUI.dialog('#winConfirmInfo').open();	
				} 
				});
			}else if(value=="O") {
				$.messager.confirm($g("提示"), $g("是否取消排除选中数据记录")+"?", function (r) {				
				if (r) {	
					//弹窗填写取消排除备注	
					Common_CheckboxToSDRule("RuleDic",QCID,1,1);	
					$('#winConfirmInfo').dialog({
						title: $g('入组单病种'),
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
						$.messager.alert($g("错误提示"),$g("请选择准入准出规则或者填写备注")+"！", 'info');
						return
				}else{
					var RuleInputStr=obj.ID+"^"+obj.value+"^"+session['LOGON.USERID']+"^"+RuleStr+"^"+Resume
					var flg = $m({
								ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
								MethodName:"ChangeMrlistSatus",
								aInput:RuleInputStr
							},false);
							if (parseInt(flg) < 0) {
								$.messager.alert($g("错误提示"),$g("操作失败")+"!Error=" + flg, 'info');	
							} else {
								$.messager.popover({msg: $g('操作成功')+'！',type:'success',timeout: 1000});
								//获取病例当前状态信息
								var StatusStr=$m({
									ClassName:'DHCMA.CPW.SDS.QCMrListSrv',
									MethodName:'GetStatusByMrListID',
									aMrListID:obj.ID
								},false)
								//实现状态更新
								var RowIndex=$('#gridQCMrList').datagrid('getRowIndex',obj.ID)
								$("#gridQCMrList").datagrid("updateRow",{  
				            	       index:RowIndex, //行索引  
				                	   row:{  
				                    		QCCurrStatus:StatusStr.split('^')[0],
				                    		QCCurrStatusDesc:StatusStr.split('^')[1]
				                    	  }  
				     		 	})
								
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
			title:$g('病历浏览'),
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:'98%',
			height:'98%'
		});
	}
	obj.UpForm=function(MrListID)
	{
		var msginfo=""
		$.messager.progress({
				title: $g("提示"),
				msg: $g('正在上传数据'),
				text: $g('上传中')+'....'
		});
		$m({
			ClassName:'DHCMA.CPW.SDS.QCInterface',
			MethodName:'Upload',
			aMRListID:MrListID	
		},function(UpRet){
			$.messager.progress("close")
			var UpRetArr=UpRet.split('^')
			if (UpRetArr[0]==1) {
				var msginfo=$g("已正式上传至国家平台")+"！",statusDesc=$g("正式上传"),statusCode="Up"
				if (UpRetArr[1]=="") {
					var msginfo=$g("测试上传成功，请联系信息中心正式对接平台")+"！";
					var statusCode="tUp";
					var statusDesc=$g("测试上传");
				}
				$.messager.popover({msg: msginfo,type:'success',timeout: 1000})
				//改变表单状态
				var StateStr=MrListID+"^"+statusCode+"^"+session['LOGON.USERID']
				ErrInfo=$m({
							ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
							MethodName:"ChangeMrlistSatus",
							aInput:StateStr
					},false)
				if (ErrInfo){
						$.messager.alert($g("错误提示"), $g("表单状态更新错误")+"!Error=" + ErrInfo, 'info');
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
						$.messager.popover({msg: $g('已存在上传记录，更新上传状态错误')+ErrInfo+'！',type:'success',timeout: 3000})
					}else{
						$.messager.popover({msg: $g('已存在上传记录，更新上传状态成功')+'！',type:'success',timeout: 3000})
						//刷新列表
						$('#gridQCMrList').datagrid('reload');
				}
				
			}else{
				$.messager.alert($g('错误信息'),UpRet, 'error');
				}
		})
	}
}
HISUIHtml =function(){
	$HUI.tooltip("a.grid-tips",{position:'right'})
}