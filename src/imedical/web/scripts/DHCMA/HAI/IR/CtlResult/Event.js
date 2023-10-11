function InitPatFindWinEvent(obj){
	
	obj.LoadEvent = function(args){
		obj.reloadgridApply();
		//查询按钮
		$("#btnQuery").on('click',function(){
			obj.gridStatLoad();
			obj.reloadgridApply();		
		});
		$("#btnExport").on('click',function(){
			obj.btnExport_click();
		});	
		
		//更多按钮
		$('#btnMore').on('click', function(){ 	
			if ($(this).hasClass('expanded')){  //已经展开 隐藏
				$(this).removeClass('expanded');
				$("#btnMore")[0].innerText=$g("更多");
				$('.MSearchItem').css('display','none');
				$('#gridApply').datagrid('resize');
			}else{
				$(this).addClass('expanded');
				$("#btnMore")[0].innerText=$g("隐藏");
				$('.MSearchItem').css('display','');
				$('.RepeatRule').css('color','#999');
				$('#cboUnSpec').combobox('disable');
				$('#cboUnBact').combobox('disable');
				$('#cboIsUnRepeat').combobox('setValue',2);
				$('#gridApply').datagrid('resize');
			}
		});
	}
	
	obj.MenuEdit = function(index,ResultID,MRBOutLabType,RowID) {
		var e = event || window.event;
		$('#gridApply').datagrid("clearSelections"); //取消所有选中项 
		$('#gridApply').datagrid("selectRow", index); //根据索引选中该行 
		$('#menu').menu({
		    onClick:function(item){
			    if (MRBOutLabType==$g("外院携带")){
				   var ret = $m({
						ClassName:"DHCHAI.IR.OutLabReport",
						MethodName:"UpdateInfType",
						aID:RowID,
						aMakeInfType:item.id
					},false);
					if (parseInt(ret) <= 0) {
						$.messager.alert($g("错误提示"), $g("标记失败!")+"Error=" + flg, 'info');
					}else {
						$.messager.popover({msg: $g('标记成功！'),type:'success',timeout: 1000});
						obj.reloadgridApply(); //刷新当前页
					}
				}else{
			       	var ret = $m({
						ClassName:"DHCHAI.DP.LabVisitRepResult",
						MethodName:"UpdateInfType",
						aID:ResultID,
						aMakeInfType:item.id,
						aIsByHand:1
					},false);
					if (parseInt(ret) <= 0) {
						$.messager.alert($g("错误提示"), $g("标记失败!")+"Error=" + flg, 'info');
					}else {
						$.messager.popover({msg: $g('标记成功！'),type:'success',timeout: 1000});
						obj.reloadgridApply(); //刷新当前页
					}
				}
		    }
		});
		$('#menu').menu('show', { 
			left: e.pageX,   //在鼠标点击处显示菜单 
			top: e.pageY
		});
	}
	

	//感染类型点击标记
	obj.OpenEdit= function(ResultID) {
		obj.layer();
		InfResultID = ResultID;
	}
	//编辑窗体
	obj.SetDiaglog=function(){
		$('#layer').dialog({
			title: $g('感染类型标记'),
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false,
			buttons:[{
				text:'保存',
				handler:function(){
					obj.btnSave_click();
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#layer').close();
				}
			}]
		});
	}
	//配置窗体-初始化
	obj.layer= function(){
		$('#cboMakeInfType').combobox('setValue',"");
		$('#layer').show();
		obj.SetDiaglog();
	}
	
	obj.btnSave_click = function(){
		
		var errinfo = "";
	    var MakeInfType = $('#cboMakeInfType').combobox('getValue');
		if (!MakeInfType) {
			errinfo = errinfo + $g("请选择感染类型!")+"<br>";
		}
		
		if (errinfo) {
			$.messager.alert($g("错误提示"), errinfo, 'info');
			return;
		}
		var ret = $m({
			ClassName:"DHCHAI.DP.LabVisitRepResult",
			MethodName:"UpdateInfType",
			aID:InfResultID,
			aMakeInfType:MakeInfType,
			aIsByHand:1
		},false);
		if (parseInt(ret) <= 0) {
			$.messager.alert($g("错误提示"), $g("标记失败!")+"Error=" + flg, 'info');
		}else {
			$.messager.popover({msg: $g('标记成功！'),type:'success',timeout: 1000});
			$HUI.dialog('#layer').close();
			obj.reloadgridApply(); //刷新当前页
		}
	}
	//打开链接
	obj.OpenReport = function(ReportID,EpisodeID,LabRepID,LabResID) {
        var ParamAdmin= (tDHCMedMenuOper['Admin']==1 ?"Admin" : "")
        var strUrl = './dhcma.hai.ir.mrb.ctlreport.csp?&ReportID='+ReportID+'&EpisodeID='+EpisodeID+'&LabRepID='+LabRepID+'&LabResID='+LabResID+'&ParamAdmin='+ParamAdmin+'&1=1';
		websys_showModal({
			url:strUrl,
			title:$g('多耐细菌报告'),
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:true,
			width:1340,
			height:700,  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.reloadgridApply();  //刷新
			} 
		});
	}
	
	
	//打开链接
	obj.OpenMainView = function(EpisodeID) {
		var LocFlg= (tDHCMedMenuOper['Admin']==1 ? 0:1);
		var strUrl = './dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&PageType=WinOpen'+"&LocFlag="+LocFlg;
		websys_showModal({
            url: strUrl,
            title: $g('医院感染集成视图'),
            iconCls: 'icon-w-paper',
            width: '95%',
            height: '95%'
        });
	}
	//打开疑似筛查
	obj.OpenCCSingle = function(EpisodeID) {
		var LocFlg= (tDHCMedMenuOper['Admin']==1 ? 0:1);
		var strUrl = "./dhcma.hai.ir.patscreening.csp?1=1&EpisodeDr=" + EpisodeID+"&LocFlag="+LocFlg;
		websys_showModal({
			url:strUrl,
			title:$g('疑似病例筛查'),
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:true,
			width:'95%',
			height:'95%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){} 
		});
	}
	obj.OpenReslut = function(ResultID) {
		$('#gridIRDrugSen').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		obj.reloadgridIRDrugSen(ResultID);
		$HUI.dialog('#winProEdit').open();	    
	}
	obj.OpenMBRRepLog = function(RepID) {
		$('#gridMBRRepLog').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		obj.reloadgridMBRRepLog(RepID);
		$HUI.dialog('#LayerMBRRepLog').open();	    
	}
	
	obj.SendMessage = function(ResultID,AdmID,MRBDesc,Bacteria) {
		var MsgType="MBRMsgCode";
		var Msg = $g("多耐分类:")+MRBDesc+","+$g("检出病原体:")+Bacteria
		var InputStr = AdmID +"^"+ MsgType +"^"+ $.LOGON.USERID + "^" + Msg+"^"+ResultID;
		var retval = $m ({
			ClassName:"DHCHAI.IRS.CtlMRBSrv",
			MethodName:"SendHISMRBMsg",
			ResultSetType:"array",
			aInputStr:InputStr
		})
		if(parseInt(retval)== '-1') {
	        $.messager.alert($g("提示"),$g("发送消息的患者不存在！"), 'info');
			return;
        }else if (parseInt(retval)== '-2') {
	        $.messager.alert($g("提示"),$g("HIS多耐消息代码:MBRMsgCode未配置!"), 'info');
			return;  
        }else if (parseInt(retval)== '-3') {
	        $.messager.alert($g("提示"),$g("发送消息用户不存在!"), 'info');
			return;   
        }else if(parseInt(retval)<1) {
	       $.messager.alert($g("提示"),$g("发送消息失败！"), 'info');
			return;    
        }
		$.messager.alert($g("提示"),$g("成功向临床医生发送消息！"), 'info');
		return;
	}
	
	obj.gridStatLoad = function(){
		var HospIDs  = $("#cboHospital").combobox('getValue');
		var DateType = $("#cboDateType").combobox('getValue');
		var DateFrom = $("#dtDateFrom").datebox('getValue');
		var DateTo	 = $("#dtDateTo").datebox('getValue');
		
		obj.gridStat.load({
		    ClassName:"DHCHAI.IRS.CtlMRBSrv",
			QueryName:"StaMRBResult",
			aHospIDs:HospIDs,
			aDateType:DateType,
			aDateFrom:DateFrom,
			aDateTo:DateTo,
			aLocID:obj.LocID
	    });
	}
	obj.ClearItem = function(){
		$("#cboAdmWard").combobox('clear');
		$("#cboLabWard").combobox('clear');
		$('#cboInfType').combobox('clear');
		$("#cboStatus").combobox('clear');
		$("#cboUnSpec").combobox('clear');
		$("#cboUnBact").combobox('clear');
		$("#cboBacteria").combobox('clear');
		$("#cboMRBBact").combobox('clear');
		$("#txtPatName").val('');
		$("#txtPapmiNo").val('');
		$("#txtMrNo").val('');
	}
	obj.gridStat_onSelect = function(){
		var rowData = obj.gridStat.getSelected();
		var LabWardID ="",Bacteria="",RepStatus="";
		if (rowData["DataIndex"] == obj.IndexID) {
			obj.IndexID="";
			obj.gridStat.clearSelections();  //清除选中行
			obj.reloadgridApply();
		} else {
			obj.ClearItem();
			obj.IndexID = rowData["DataIndex"];
			var IndexName = obj.IndexID.split("-")[0];
			var IndexId = obj.IndexID.split("-")[1];
			if ((IndexId)&&(IndexId!="合计")&&(IndexId!="Null")) {
				if (IndexName=="LocStat") {
					LabWardID = IndexId;
				}
				if (IndexName=="BacStat") {
					Bacteria = IndexId;
				}
				if (IndexName=="StatusStat") {
					RepStatus = IndexId;
				}
			}	
			
			$("#gridApply").datagrid("loading");
			$cm ({
				ClassName:"DHCHAI.IRS.CtlMRBSrv",
				QueryName:"QryMRBResult",
				ResultSetType:"array",
				aHospIDs: $("#cboHospital").combobox('getValue'),
				aDateType: $("#cboDateType").combobox('getValue'),
				aDateFrom:$("#dtDateFrom").datebox('getValue'),
				aDateTo:$("#dtDateTo").datebox('getValue'),
				aBactID:Bacteria,
				aWardID:LabWardID,
				aStatus:RepStatus,
				page:1,
				rows:999999
			},function(rs){
				$('#gridApply').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
			});
		}
	}
	
	//登记号补零 length位数
	var length=10;
	obj.PapmiNo=""
	$("#txtPapmiNo").keydown(function(event){
		 if (event.keyCode ==13) {
			obj.PapmiNo = $("#txtPapmiNo").val();
			if(!obj.PapmiNo) return;
			$("#txtPapmiNo").val((Array(length).join('0') + obj.PapmiNo).slice(-length)); 
			obj.reloadgridApply();
		}
	});	
	
	//重新加载表格数据
	obj.reloadgridApply = function(){
		var HospIDs  = $("#cboHospital").combobox('getValue');
		var DateType = $("#cboDateType").combobox('getValue');
		var DateFrom = $("#dtDateFrom").datebox('getValue');
		var DateTo	 = $("#dtDateTo").datebox('getValue');
		var DateFlag = Common_CompareDate(DateFrom,DateTo);
		var IsUnRepeat = $("#cboIsUnRepeat").combobox('getValue');
		var AdmWardID  = $("#cboAdmWard").combobox('getValue');
		var LabWardID  = $("#cboLabWard").combobox('getValue');
		var InfTypeIDs = $('#cboInfType').combobox('getValues').toString();
		var RepStatus  = $("#cboStatus").combobox('getValue');
		var UnSpec     = $("#cboUnSpec").combobox('getValue');
		var UnBact     = $("#cboUnBact").combobox('getValue');
		var Bacteria   = $("#cboBacteria").combobox('getValue');
        var MRBBact    = $("#cboMRBBact").combobox('getValue');
		var PatName    = $("#txtPatName").val();
		var PapmiNo    = $("#txtPapmiNo").val();
		var MrNo 	   = $("#txtMrNo").val();
		var Inputs = PatName+'^'+PapmiNo+'^'+MrNo;
		var ErrorStr="";
		if (HospIDs=="") {
			ErrorStr += $g('请选择院区!')+'<br/>';
		}
		if(DateType==""){
			$.messager.alert($g("提示"),$g("日期类型不能为空！"), 'info');
			return;
		}
		if(DateFrom==""){
			$.messager.alert($g("提示"),$g("开始日期不能为空！"), 'info');
			return;
		}
		if(DateTo==""){
			$.messager.alert($g("提示"),$g("结束日期不能为空！"), 'info');
			return;
		}
		if (DateFlag==1){
			$.messager.alert($g("提示"),$g("开始日期不能大于结束日期！"), 'info');
			return;
		}
		
		if (ErrorStr != '') {
			$.messager.alert($g("错误提示"),ErrorStr, 'info');
			return;
		}else{
			$("#gridApply").datagrid("loading");
			$cm ({
				ClassName:"DHCHAI.IRS.CtlMRBSrv",
				QueryName:"QryMRBResult",
				ResultSetType:"array",
				aHospIDs:HospIDs,
				aDateType:DateType,
				aDateFrom:DateFrom,
				aDateTo:DateTo,
				aLocID:AdmWardID,
				aInfID:InfTypeIDs,
				aBactID:Bacteria,
				aMRBID:MRBBact,
				aSpecID:"",
				aWardID:LabWardID,
				aIsUnRepeat:IsUnRepeat,
				aUnSpec:UnSpec,
				aUnBact:UnBact,
				aStatus:RepStatus,
				aIntputs:Inputs,
				page:1,
				rows:999999
			},function(rs){
				$('#gridApply').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
				$('#gridApply').datagrid('selectRow', obj.rowIndex );				
			});
		
		};
	}
	//加载药敏结果表格
	obj.reloadgridIRDrugSen = function(ResultID){
		$("#gridIRDrugSen").datagrid("loading");
		$cm ({
			ClassName:"DHCHAI.IRS.CtlMRBSrv",
			QueryName:"QryResultSen",
			ResultSetType:"array",
			aResultID:ResultID,
			page:1,
			rows:200
		},function(rs){
			$('#gridIRDrugSen').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
		
	};
	//刷新操作明细
    obj.reloadgridMBRRepLog = function (RepID){
		$("#gridMBRRepLog").datagrid("loading");
		$cm ({
			ClassName:"DHCHAI.IRS.INFMBRSrv",
			QueryName:"QryMBRRepLog",
			ResultSetType:"array",
			aRepID:RepID,
			page:1,
			rows:200
		},function(rs){
			$('#gridMBRRepLog').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
    }	

	obj.btnExport_click = function() {
		var rows=$("#gridApply").datagrid('getRows').length;
		if (rows>0) {
			$('#gridApply').datagrid('toExcel',$g('多重耐药细菌监控')+'.xls');			
		}else {
			$.messager.alert($g("确认"), $g("无数据记录,不允许导出"), 'info');
			return;
		}	
	}
}