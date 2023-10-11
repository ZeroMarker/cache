function InitPatFindWinEvent(obj){
	
	obj.LoadEvent = function(args){
		obj.reloadgridApply();
		//��ѯ��ť
		$("#btnQuery").on('click',function(){
			obj.gridStatLoad();
			obj.reloadgridApply();		
		});
		$("#btnExport").on('click',function(){
			obj.btnExport_click();
		});	
		
		//���ఴť
		$('#btnMore').on('click', function(){ 	
			if ($(this).hasClass('expanded')){  //�Ѿ�չ�� ����
				$(this).removeClass('expanded');
				$("#btnMore")[0].innerText=$g("����");
				$('.MSearchItem').css('display','none');
				$('#gridApply').datagrid('resize');
			}else{
				$(this).addClass('expanded');
				$("#btnMore")[0].innerText=$g("����");
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
		$('#gridApply').datagrid("clearSelections"); //ȡ������ѡ���� 
		$('#gridApply').datagrid("selectRow", index); //��������ѡ�и��� 
		$('#menu').menu({
		    onClick:function(item){
			    if (MRBOutLabType==$g("��ԺЯ��")){
				   var ret = $m({
						ClassName:"DHCHAI.IR.OutLabReport",
						MethodName:"UpdateInfType",
						aID:RowID,
						aMakeInfType:item.id
					},false);
					if (parseInt(ret) <= 0) {
						$.messager.alert($g("������ʾ"), $g("���ʧ��!")+"Error=" + flg, 'info');
					}else {
						$.messager.popover({msg: $g('��ǳɹ���'),type:'success',timeout: 1000});
						obj.reloadgridApply(); //ˢ�µ�ǰҳ
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
						$.messager.alert($g("������ʾ"), $g("���ʧ��!")+"Error=" + flg, 'info');
					}else {
						$.messager.popover({msg: $g('��ǳɹ���'),type:'success',timeout: 1000});
						obj.reloadgridApply(); //ˢ�µ�ǰҳ
					}
				}
		    }
		});
		$('#menu').menu('show', { 
			left: e.pageX,   //�����������ʾ�˵� 
			top: e.pageY
		});
	}
	

	//��Ⱦ���͵�����
	obj.OpenEdit= function(ResultID) {
		obj.layer();
		InfResultID = ResultID;
	}
	//�༭����
	obj.SetDiaglog=function(){
		$('#layer').dialog({
			title: $g('��Ⱦ���ͱ��'),
			iconCls:"icon-w-paper",
			modal: true,
			isTopZindex:false,
			buttons:[{
				text:'����',
				handler:function(){
					obj.btnSave_click();
				}
			},{
				text:'�ر�',
				handler:function(){
					$HUI.dialog('#layer').close();
				}
			}]
		});
	}
	//���ô���-��ʼ��
	obj.layer= function(){
		$('#cboMakeInfType').combobox('setValue',"");
		$('#layer').show();
		obj.SetDiaglog();
	}
	
	obj.btnSave_click = function(){
		
		var errinfo = "";
	    var MakeInfType = $('#cboMakeInfType').combobox('getValue');
		if (!MakeInfType) {
			errinfo = errinfo + $g("��ѡ���Ⱦ����!")+"<br>";
		}
		
		if (errinfo) {
			$.messager.alert($g("������ʾ"), errinfo, 'info');
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
			$.messager.alert($g("������ʾ"), $g("���ʧ��!")+"Error=" + flg, 'info');
		}else {
			$.messager.popover({msg: $g('��ǳɹ���'),type:'success',timeout: 1000});
			$HUI.dialog('#layer').close();
			obj.reloadgridApply(); //ˢ�µ�ǰҳ
		}
	}
	//������
	obj.OpenReport = function(ReportID,EpisodeID,LabRepID,LabResID) {
        var ParamAdmin= (tDHCMedMenuOper['Admin']==1 ?"Admin" : "")
        var strUrl = './dhcma.hai.ir.mrb.ctlreport.csp?&ReportID='+ReportID+'&EpisodeID='+EpisodeID+'&LabRepID='+LabRepID+'&LabResID='+LabResID+'&ParamAdmin='+ParamAdmin+'&1=1';
		websys_showModal({
			url:strUrl,
			title:$g('����ϸ������'),
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:true,
			width:1340,
			height:700,  //8.2���ϰ汾֧�ְٷֱȣ�8.2���µ��þ������أ���height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.reloadgridApply();  //ˢ��
			} 
		});
	}
	
	
	//������
	obj.OpenMainView = function(EpisodeID) {
		var LocFlg= (tDHCMedMenuOper['Admin']==1 ? 0:1);
		var strUrl = './dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&PageType=WinOpen'+"&LocFlag="+LocFlg;
		websys_showModal({
            url: strUrl,
            title: $g('ҽԺ��Ⱦ������ͼ'),
            iconCls: 'icon-w-paper',
            width: '95%',
            height: '95%'
        });
	}
	//������ɸ��
	obj.OpenCCSingle = function(EpisodeID) {
		var LocFlg= (tDHCMedMenuOper['Admin']==1 ? 0:1);
		var strUrl = "./dhcma.hai.ir.patscreening.csp?1=1&EpisodeDr=" + EpisodeID+"&LocFlag="+LocFlg;
		websys_showModal({
			url:strUrl,
			title:$g('���Ʋ���ɸ��'),
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:true,
			width:'95%',
			height:'95%',  //8.2���ϰ汾֧�ְٷֱȣ�8.2���µ��þ������أ���height:window.screen.availHeight-80,
			onBeforeClose:function(){} 
		});
	}
	obj.OpenReslut = function(ResultID) {
		$('#gridIRDrugSen').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
		obj.reloadgridIRDrugSen(ResultID);
		$HUI.dialog('#winProEdit').open();	    
	}
	obj.OpenMBRRepLog = function(RepID) {
		$('#gridMBRRepLog').datagrid('loadData',{ 'total':'0',rows:[] });  //��ʼ������ʾ��¼Ϊ0
		obj.reloadgridMBRRepLog(RepID);
		$HUI.dialog('#LayerMBRRepLog').open();	    
	}
	
	obj.SendMessage = function(ResultID,AdmID,MRBDesc,Bacteria) {
		var MsgType="MBRMsgCode";
		var Msg = $g("���ͷ���:")+MRBDesc+","+$g("�����ԭ��:")+Bacteria
		var InputStr = AdmID +"^"+ MsgType +"^"+ $.LOGON.USERID + "^" + Msg+"^"+ResultID;
		var retval = $m ({
			ClassName:"DHCHAI.IRS.CtlMRBSrv",
			MethodName:"SendHISMRBMsg",
			ResultSetType:"array",
			aInputStr:InputStr
		})
		if(parseInt(retval)== '-1') {
	        $.messager.alert($g("��ʾ"),$g("������Ϣ�Ļ��߲����ڣ�"), 'info');
			return;
        }else if (parseInt(retval)== '-2') {
	        $.messager.alert($g("��ʾ"),$g("HIS������Ϣ����:MBRMsgCodeδ����!"), 'info');
			return;  
        }else if (parseInt(retval)== '-3') {
	        $.messager.alert($g("��ʾ"),$g("������Ϣ�û�������!"), 'info');
			return;   
        }else if(parseInt(retval)<1) {
	       $.messager.alert($g("��ʾ"),$g("������Ϣʧ�ܣ�"), 'info');
			return;    
        }
		$.messager.alert($g("��ʾ"),$g("�ɹ����ٴ�ҽ��������Ϣ��"), 'info');
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
			obj.gridStat.clearSelections();  //���ѡ����
			obj.reloadgridApply();
		} else {
			obj.ClearItem();
			obj.IndexID = rowData["DataIndex"];
			var IndexName = obj.IndexID.split("-")[0];
			var IndexId = obj.IndexID.split("-")[1];
			if ((IndexId)&&(IndexId!="�ϼ�")&&(IndexId!="Null")) {
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
	
	//�ǼǺŲ��� lengthλ��
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
	
	//���¼��ر������
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
			ErrorStr += $g('��ѡ��Ժ��!')+'<br/>';
		}
		if(DateType==""){
			$.messager.alert($g("��ʾ"),$g("�������Ͳ���Ϊ�գ�"), 'info');
			return;
		}
		if(DateFrom==""){
			$.messager.alert($g("��ʾ"),$g("��ʼ���ڲ���Ϊ�գ�"), 'info');
			return;
		}
		if(DateTo==""){
			$.messager.alert($g("��ʾ"),$g("�������ڲ���Ϊ�գ�"), 'info');
			return;
		}
		if (DateFlag==1){
			$.messager.alert($g("��ʾ"),$g("��ʼ���ڲ��ܴ��ڽ������ڣ�"), 'info');
			return;
		}
		
		if (ErrorStr != '') {
			$.messager.alert($g("������ʾ"),ErrorStr, 'info');
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
	//����ҩ��������
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
	//ˢ�²�����ϸ
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
			$('#gridApply').datagrid('toExcel',$g('������ҩϸ�����')+'.xls');			
		}else {
			$.messager.alert($g("ȷ��"), $g("�����ݼ�¼,��������"), 'info');
			return;
		}	
	}
}