//页面Event
function InitWinEvent(obj){
	obj.RecPRowID=""
	obj.LoadEvent=function() {
		$m({
			ClassName:"DHCMA.Util.BT.Config",
			MethodName:"GetValueByCode",
			aCode:"SDDateRange"
		},function(str){
			var xsdate=	str.split('~')[0].split('T')[1]
			var xedate=	str.split('~')[1].split('T')[1]
			var date=new Date();			
			var date2=new Date()
			date2.setDate(date2.getDate()+parseInt(xsdate))
			date.setDate(date.getDate()+parseInt(xedate))
			var SDate=Common_GetDate(date2)
			var EDate=Common_GetDate(date)
			Common_SetValue('SDate',SDate);
			Common_SetValue('EDate',EDate);	
			obj.RefreshMrList()
		})
	}
	$('#MrNo').on('keydown',function (e) {
                if (e.keyCode == 13) {
	                var aMrNo=Common_GetValue('MrNo')
					/*var MrNoLen=$m({
						ClassName:"DHCMA.Util.BT.Config",
						MethodName:"GetValueByCode",
						aCode:"WMRLen"
						},false)
					var MrNoLen=parseInt(MrNoLen)
					var aMrNo=(Array(MrNoLen).join('0') + aMrNo).slice(-MrNoLen)
					Common_SetValue('MrNo',aMrNo);*/
                   obj.RefreshMrList();
                }
            });
    var length=10;
    $('#RegNo').on('keydown',function (e) {
                if (e.keyCode == 13) {
	                obj.RegNo = $("#RegNo").val();
					if(!obj.RegNo) return;
					$("#RegNo").val((Array(length).join('0') + obj.RegNo).slice(-length)); 
                   obj.RefreshMrList();
                }
            });
    $('#PatName').on('keydown',function (e) {
                if (e.keyCode == 13) {
	                
                    obj.RefreshMrList();
                }
            });
	$('#search').on('click',function(){obj.RefreshMrList()});
	obj.RefreshMrList=function(){
		var hosType=$('input:radio[name="hosType"]:checked').val();	
		if (Common_GetValue('Hospital')!=""){
			obj.HospID=Common_GetValue('Hospital')
		}
		obj.gridQCMrList.reload({
				ClassName:"DHCMA.CPW.SDS.QCMrListSrv",
				QueryName:"QryPatientByDate",
				aDateFrom:Common_GetValue('SDate'),
				aDateTo	:Common_GetValue('EDate'),
				aLoc 	:Common_GetValue('DishLoc'),
				aHospID :obj.HospID,
				aMrNo	:Common_GetValue('MrNo'),
				aRegNo	:Common_GetValue('RegNo'),
				aPatName:Common_GetValue('PatName'),
				StaType	:hosType
			})	
		}
	obj.layer=function(rowindx){
		obj.gridQCMrList.selectRow(rowindx);
		var rd=obj.gridQCMrList.getSelected()
		title="<div id ='CurrStatus'>"+$g("病种名称")+"："+rd.QCEntityDesc+" /"+$g("病案号")+"："+rd.MrNo+" /"+$g("姓名")+"："+rd.PatName+" /"+$g("出院日期")+"："+rd.DisDate+" /"+$g("报告状态")+"："+$g(rd.QCCurrStatus)+"</div>";
		url="./dhcma.cpw.sd.qcformshow.csp?MrListID=" + rd.MrListID + "&random="+Math.random();
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
					aMrListID:rd.MrListID
				},false)
				//实现状态更新
				var RowIndex=$('#gridQCMrList').datagrid('getRowIndex',rd)
				$("#gridQCMrList").datagrid("updateRow",{  
            	       index:RowIndex, //行索引  
                	   row:{  
                    		QCCurrStatus:StatusStr.split('^')[1]
                    	  }  
     		 		})	
			}
		});
	}
	obj.CreatSDRule=function(QCID){
			if (QCID>0) {
				Common_CheckboxToSDRule("RuleDic",QCID,1,1);
			}
		}
	obj.InSDManager=function(rowindx){
		obj.gridQCMrList.selectRow(rowindx);
		var rd=obj.gridQCMrList.getSelected()
		//弹窗填写入组理由
		$('#RuleDic').html("")
		Common_SetValue("RuleResume","");
		obj.LocID=rd.AdmLoc
		 $("#QCDic").combobox({
			url:$URL+'?ClassName=DHCMA.CPW.SDS.QCEntitySrv&QueryName=QryQCEntity&ResultSetType=Array&aLocOID='+obj.LocID,
			valueField:'BTID',
			textField:'BTDesc',
			defaultFilter:2
			 ,onSelect: function () {
				 var DicID=Common_GetValue('QCDic');
				 obj.CreatSDRule(DicID);
			 }
		 })
		obj.EpisodeID=rd.EpisodeID
		obj.value="I";
		$HUI.dialog('#winConfirmInfo').open();	
	}
	$('#SaveRule').on('click',function () {
				if (session['DHCMA.CTLOCID']==undefined) {
					var InLocID=session['LOGON.CTLOCID']
				}else{
					var InLocID=session['DHCMA.CTLOCID']
				}
				if (session['DHCMA.USERID']==undefined) {
					var InUserID=session['LOGON.USERID']
				}else{
					var InUserID=session['DHCMA.USERID']
				}
				if (Common_GetValue('QCDic')=="") {
					$.messager.alert($g("错误提示"),$g("请选择入组病种"), 'error');
					return;
				}
				var RuleStr=Common_CheckboxValue('RuleDic')
				var Resume=$('#RuleResume').val()
				if ((RuleStr=="")&&(Resume=="")) {
						$.messager.alert($g("错误提示"),$g("入组原因和备注最少填写一项"), 'info');
						return;
					}
				var MInputStr=obj.EpisodeID+"^^"+Common_GetValue('QCDic')+"^"+InUserID+"^"+InLocID
				var Mflg = $m({
							ClassName :"DHCMA.CPW.SDS.QCMrListSrv",
							MethodName:"InQCEntity",
							aInputStr :MInputStr
						},false);
				if (parseInt(Mflg)<1) {
						$.messager.alert($g("错误提示"),$g("入单病种失败")+":" + Mflg, 'info');	
					 	return; //如果主记录保存失败  退出
				}
				var RuleInputStr=Mflg+"^I^"+session['LOGON.USERID']+"^"+RuleStr+"^"+Resume
				var flg = $m({
							ClassName:"DHCMA.CPW.SDS.QCMrListStateSrv",
							MethodName:"ChangeMrlistSatus",
							aInput:RuleInputStr
						},false);
						if (parseInt(flg) < 0) {
							$.messager.alert($g("错误提示"),$g("操作失败")+":" + flg, 'info');	
						} else {
							$.messager.popover({msg: $g('操作成功'),type:'success',timeout: 1000});
							$('#gridQCMrList').datagrid('reload');
							
						}
					$HUI.dialog('#winConfirmInfo').close();
					obj.gridQCMrList.reload();
				})
	$('#CanCelRule').on('click',function(){$HUI.dialog('#winConfirmInfo').close();})
	/**
	obj.DisplayEPRView=function(EpisodeID,PatientID)
		{
		if (!EpisodeID) return;
		
		var strUrl = "./emr.browse.csp?EpisodeID=" + EpisodeID + "&PatientID=" + PatientID + "&2=2";
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
	//病历浏览新界面
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
}