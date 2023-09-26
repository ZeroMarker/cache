/*�±���ϸ��ѯ*/
var init = function () {
	var SCGTYPE = 'M';		//��������(��������M,��������O)
	var growid='';
	function GetParamsObj(){
		var ParamsObj=$UI.loopBlock('#StkMonTabConditions');
		return ParamsObj;
	}
	
	var StkMonLocParams=JSON.stringify(addSessionParams({Type:"Login"}));
	var StkMonLocBox = $HUI.combobox('#HistoryStkMonStatLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+StkMonLocParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var StkCatBox = $HUI.combobox('#StkCatBox', {
			valueField: 'RowId',
			textField: 'Description'
	});
	$('#StkGrpId').stkscgcombotree({
		onSelect:function(node){
			$.cm({
				ClassName:'web.DHCSTMHUI.Common.Dicts',
				QueryName:'GetStkCat',
				ResultSetType:'array',
				StkGrpId:node.id
			},function(data){
				StkCatBox.clear();
				StkCatBox.loadData(data);
				})
			}
	})
	var FinancialFlag = $HUI.checkbox('#FinancialFlag',{
		onCheckChange: function(e, value){
			if(value){
				SCGTYPE='O';
			}
		}
	});
	var HandlerParams = function(){
		var ScgId = $('#StkGrpId').combotree('getValue');
		var Locdr = $('#HistoryStkMonStatLoc').combo('getValue');
		var Obj = {StkGrpRowId:ScgId, StkGrpType:'M', Locdr:Locdr};
		return Obj;
	}
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc'));
	$HUI.tabs("#StkMonTab",{
		onSelect:function(title){
			var row = HistoryStkMonStatGrid.getSelected();
			if (isEmpty(row)){return false;}
			growid=row.smRowid;
			var ParamsObj=GetParamsObj();
			var params = JSON.stringify(addSessionParams({smRowid:growid}));
			if (title == "�±��������(���汨��)")
			{
				var groupid=ParamsObj.StkGrpId;
				var params = JSON.stringify(addSessionParams({smRowid:growid,StkGrpId:groupid,ScgType:SCGTYPE}));
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_ReportInIsRpLocCatCross.raq'
					+"&growid="+growid+"&StrParam="+params;
				var reportFrame=document.getElementById("frameReportInIsRpLocCat");
				reportFrame.src=p_URL;
				
			}else if (title == "�±�������(��Ӧ��)")
			{
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_ReportImportVendorSum.raq'
					+"&growid="+growid+"&StrParam="+params;
				var reportFrame=document.getElementById("frameImportVendorSum");
				reportFrame.src=p_URL;
			}else if (title == "�������(����)")
			{
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_ReportDetailSCGRp_Common.raq'
					+"&Type="+0+"&growid="+growid+"&StrParam="+params;
				var reportFrame=document.getElementById("frameDetailSCGRp");
				reportFrame.src=p_URL;
			}else if (title == "�������(�ۼ�)")
			{
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_ReportDetailSCGRp_Common.raq'
					+"&Type="+1+"&growid="+growid+"&StrParam="+params;
				var reportFrame=document.getElementById("frameDetailSCGSp");
				reportFrame.src=p_URL;
			}else if (title == "�༶����")
			{
				var Type=0;
				var params = JSON.stringify(addSessionParams({smRowid:growid,Type:Type,ScgType:SCGTYPE}));
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_ReportMulScg.raq'
					+"&growid="+growid+"&StrParam="+params;
				var reportFrame=document.getElementById("frameMulScgRp");
				reportFrame.src=p_URL;
			}else if (title == "���������")
			{
				var Type=0;
				var params = JSON.stringify(addSessionParams({smRowid:growid,Type:Type,ScgType:SCGTYPE}));
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_ReportStkCatRp.raq'
					+"&growid="+growid+"&StrParam="+params;
				var reportFrame=document.getElementById("frameStkCatRp");
				reportFrame.src=p_URL;
			}else if (title == "��������⽻�����")
			{
				var Type=0;
				var params = JSON.stringify(addSessionParams({smRowid:growid,Type:Type,ScgType:SCGTYPE}));
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_ReportStkCatTransRp.raq'
					+"&growid="+growid+"&StrParam="+params;
				var reportFrame=document.getElementById("frameStkCatTransRp");
				reportFrame.src=p_URL;
			}else if (title == "�±���ϸ(�ۼ�)")
			{
				var Params=JSON.stringify(addSessionParams({smRowid:growid,ScgType:SCGTYPE,stkgrpid:ParamsObj.StkGrpId,stkcatid:ParamsObj.StkCatBox,incdesc:ParamsObj.InciDesc}));
				$UI.setUrl(StkMonStatDetailSpGrid);
				StkMonStatDetailSpGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCStkMonRepQuery',
					QueryName: 'StkMonRepItm',
					Params:Params
				});
			}else if (title == "�±���ϸ(����)")
			{
				var Params=JSON.stringify(addSessionParams({smRowid:growid,ScgType:SCGTYPE,stkgrpid:ParamsObj.StkGrpId,stkcatid:ParamsObj.StkCatBox,incdesc:ParamsObj.InciDesc}));
				$UI.setUrl(StkMonStatDetailRpGrid);
				StkMonStatDetailRpGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCStkMonRepQuery',
					QueryName: 'StkMonRepItmRp',
					Params:Params
				});
			}else if (title == "�±���ϸ����(�ۼ�)")
			{
				var Params=JSON.stringify(addSessionParams({smRowid:growid,ScgType:SCGTYPE,stkgrpid:ParamsObj.StkGrpId,stkcatid:ParamsObj.StkCatBox,incdesc:ParamsObj.InciDesc}));
				$UI.setUrl(StkMonStatDetailLBSpGrid);
				StkMonStatDetailLBSpGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCStkMonReportLB',
					QueryName: 'StkMonRepLcBt',
					Params:Params
				});
			}else if (title == "�±���ϸ����(����)")
			{
				var Params=JSON.stringify(addSessionParams({smRowid:growid,ScgType:SCGTYPE,stkgrpid:ParamsObj.StkGrpId,stkcatid:ParamsObj.StkCatBox,incdesc:ParamsObj.InciDesc}));
				$UI.setUrl(StkMonStatDetailLBRpGrid);
				StkMonStatDetailLBRpGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCStkMonReportLB',
					QueryName: 'StkMonRepLcBt',
					Params:Params
				});
			}		
		}
	});
	var HistoryStkMonStatCm = [[
		{
			title: 'smRowid',
			field: 'smRowid',
			width:100,
			hidden: true
		}, {
        	title: "�·�",
       		field:'mon',
        	width: 100
		}, {
			title : "�±���ʼ����",
			field : 'frDate',
			width : 100
		}, {
	        title:"�±���ֹ����",
	        field:'toDate',
	        width: 100
		}, {
			title : "�±���",
			field : 'StkMonNo',
			width : 100
		}, {
			title: '����',
			field: 'locDesc',
			width: 150
		}, {
			title : "ƾ֤��",
			field : 'AcctVoucherCode',
			width : 100
		}, {
			title : "ƾ֤����",
			field : 'AcctVoucherDate',
			width : 100
		}, {
			title : "ƾ֤����״̬",
			field : 'AcctVoucherStatus',
			width : 100
		}, {
			title : "Pdf�ļ�����",
			field : 'PdfFile',
			width : 100
		}		
	]];
	var HistoryStkMonStatGrid = $UI.datagrid('#HistoryStkMonStatGrid', {
		url:'',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCStkMon',
			QueryName: 'DHCStkMon'
		},
		columns: HistoryStkMonStatCm,
		sortName: 'RowId',  
		sortOrder: 'Desc',
		onSelect:function(index, row){
			$('#StkMonTab').tabs('select','�±��������(���汨��)');
			var smRowid = row.smRowid;
			growid=smRowid;
			var groupid=GetParamsObj().StkGrpId;
			var params = JSON.stringify(addSessionParams({smRowid:smRowid,StkGrpId:groupid,ScgType:SCGTYPE}));
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_ReportInIsRpLocCatCross.raq'
				+"&growid="+smRowid+"&StrParam="+params;
			var reportFrame=document.getElementById("frameReportInIsRpLocCat");
			reportFrame.src=p_URL;
		}
	})
	$UI.linkbutton('#PrintBT',{
		onClick:function(){
			var activeTabtmp=$('#StkMonTab').tabs('getSelected').panel('options').title;
			PrintStkMon(growid,activeTabtmp,SCGTYPE);
		}
	});
	$UI.linkbutton('#SearchBT',{
		onClick:function(){
			QueryHistoryStkMonStat();
		}
	});
	function QueryHistoryStkMonStat(){
		var ParamsObj=$UI.loopBlock('#HistoryStkMonStatConditions');
		if(isEmpty(ParamsObj.HistoryStkMonStatLoc)){
			$UI.msg('alert','���Ҳ���Ϊ��!');
			return false;
		}	
		
		$UI.setUrl(HistoryStkMonStatGrid);
		HistoryStkMonStatGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCStkMon',
			QueryName: 'DHCStkMon',
			loc:ParamsObj.HistoryStkMonStatLoc,
			StartDate:"",
			EndDate:""
		});
	}
	function ClearHistoryStkMonStat(){
		$UI.clearBlock('#HistoryStkMonStatConditions');
		$UI.clear(HistoryStkMonStatGrid);
		///���ó�ʼֵ ����ʹ������
		var Dafult={
					HistoryStkMonStatLoc : gLocObj
					}
		$UI.fillBlock('#HistoryStkMonStatConditions',Dafult);
	}
	
	var StkMonStatDetailCm = [[
		{
			title: 'Rowid',
			field: 'Rowid',
			width:100,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'inciCode',
			width: 230
		}, {
        	title: "��������",
       		field:'inciDesc',
        	width: 100
		}, {
			title : "���",
			field : 'spec',
			width : 100
		}, {
	        title:"��λ",
	        field:'uomDesc',
	        width: 100
		}, {
			title : "���ڽ������",
			field : 'qty',
			width : 100
		}, {
			title : "���ڽ����",
			field : 'amt',
			width : 100
		}, {
			title : "���ڽ������",
			field : 'lastQty',
			width : 100
		}, {
			title : "���ڽ����",
			field : 'lastAmt',
			width : 100
		}, {
			title : "�������",
			field : 'recQty',
			width : 100
		}, {
			title : "�����",
			field : 'recAmt',
			width : 100
		}, {
			title : "�˻�����",
			field : 'retQty',
			width : 100
		}, {
			title : "�˻����",
			field : 'retAmt',
			width : 100
		}, {
			title : "ת������",
			field : 'trOutQty',
			width : 100
		}, {
			title : "ת�����",
			field : 'trOutAmt',
			width : 100
		}, {
			title : "ת������",
			field : 'trInQty',
			width : 100
		}, {
			title : "ת����",
			field : 'trInAmt',
			width : 100
		}, {
			title : "��������",
			field : 'adjQty',
			width : 100
		}, {
			title : "�������",
			field : 'adjAmt',
			width : 100
		}, {
			title : "��������",
			field : 'csmQty',
			width : 100
		}, {
			title : "���Ľ��",
			field : 'csmAmt',
			width : 100
		}, {
			title : "��������",
			field : 'disposeQty',
			width : 100
		}, {
			title : "������",
			field : 'disposeAmt',
			width : 100
		}, {
			title : "��������",
			field : 'aspAmt',
			width : 100
		}, {
			title : "��Ʒ�������",
			field : 'giftRecQty',
			width : 100
		}, {
			title : "��Ʒ�����",
			field : 'giftRecAmt',
			width : 100
		}, {
			title : "��Ʒ��������",
			field : 'giftTrOutQty',
			width : 100
		}, {
			title : "��Ʒ������",
			field : 'giftTrOutAmt',
			width : 100
		}, {
			title : "���ۻ�Ʊ�������",
			field : 'chgRecQty',
			width : 100
		}, {
			title : "���ۻ�Ʊ�����",
			field : 'chgRecAmt',
			width : 100
		}, {
			title : "���ۻ�Ʊ�˻�����",
			field : 'chgRetQty',
			width : 100
		}, {
			title : "���ۻ�Ʊ�˻����",
			field : 'chgRetAmt',
			width : 100
		}, {
			title : "�˻�����(����)",
			field : 'retAspAmt',
			width : 100
		}, {
			title : "ת������(����)",
			field : 'trInAspAmt',
			width : 100
		}, {
			title : "�̵��������",
			field : 'stktkAdjQty',
			width : 100
		}, {
			title : "�̵�������",
			field : 'stktkAdjAmt',
			width : 100
		}, {
			title : "��������",
			field : 'diffQty',
			width : 100
		}, {
			title : "������",
			field : 'diffAmt',
			width : 100
		}		
	]];
	var StkMonStatDetailSpGrid = $UI.datagrid('#StkMonStatDetailSpGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCStkMonRepQuery',
			QueryName: 'StkMonRepItm'
		},
		columns: StkMonStatDetailCm,
		sortName: 'RowId',  
		sortOrder: 'Desc'
	});
	var StkMonStatDetailRpGrid = $UI.datagrid('#StkMonStatDetailRpGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCStkMonRepQuery',
			QueryName: 'StkMonRepItmRp'
		},
		columns: StkMonStatDetailCm,
		sortName: 'RowId',  
		sortOrder: 'Desc'
	});
	var StkMonStatDetailLBRpCm = [[
		{
			title: 'Rowid',
			field: 'Rowid',
			width:100,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'incicode',
			width: 230
		}, {
        	title: "��������",
       		field:'incidesc',
        	width: 100
		}, {
			title : "���",
			field : 'spec',
			width : 100
		}, {
	        title:"����",
	        field:'manf',
	        width: 100
		}, {
	        title:"��λ",
	        field:'puomdesc',
	        width: 100
		}, {
	        title:"����",
	        field:'IBNO',
	        width: 100
		}, {
			title : "���ڽ������",
			field : 'qty',
			width : 100
		}, {
			title : "���ڽ����",
			field : 'coamt',
			width : 100
		}, {
			title : "���ڽ������",
			field : 'lastqty',
			width : 100
		}, {
			title : "���ڽ����",
			field : 'lastcoamt',
			width : 100
		}, {
			title : "�������",
			field : 'recqty',
			width : 100
		}, {
			title : "�����",
			field : 'reccoamt',
			width : 100
		}, {
			title : "�˻�����",
			field : 'retqty',
			width : 100
		}, {
			title : "�˻����",
			field : 'retcoamt',
			width : 100
		}, {
			title : "ת������",
			field : 'trfoqty',
			width : 100
		}, {
			title : "ת�����",
			field : 'trfocoamt',
			width : 100
		}, {
			title : "ת������",
			field : 'trfiqty',
			width : 100
		}, {
			title : "ת����",
			field : 'trficoamt',
			width : 100
		}, {
			title : "��������",
			field : 'adjqty',
			width : 100
		}, {
			title : "�������",
			field : 'adjcoamt',
			width : 100
		}, {
			title : "�̵��������",
			field : 'stkqty',
			width : 100
		}, {
			title : "�̵�������",
			field : 'stkcoamt',
			width : 100
		}, {
			title : "��������",
			field : 'conqty',
			width : 100
		}, {
			title : "������",
			field : 'concoamt',
			width : 100
		}, {
			title : "��������",
			field : 'aspcoamt',
			width : 100
		}, {
			title : "��������",
			field : 'diffQty',
			width : 100
		}, {
			title : "������",
			field : 'diffAmtRp',
			width : 100
		}		
	]];
	var StkMonStatDetailLBRpGrid = $UI.datagrid('#StkMonStatDetailLBRpGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCStkMonReportLB',
			QueryName: 'StkMonRepLcBt'
		},
		columns: StkMonStatDetailLBRpCm,
		sortName: 'RowId',  
		sortOrder: 'Desc'
	});
	var StkMonStatDetailLBCm = [[
		{
			title: 'Rowid',
			field: 'Rowid',
			width:100,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'incicode',
			width: 230
		}, {
        	title: "��������",
       		field:'incidesc',
        	width: 100
		}, {
			title : "���",
			field : 'spec',
			width : 100
		}, {
	        title:"����",
	        field:'manf',
	        width: 100
		}, {
	        title:"��λ",
	        field:'puomdesc',
	        width: 100
		}, {
	        title:"����",
	        field:'IBNO',
	        width: 100
		}, {
			title : "���ڽ������",
			field : 'qty',
			width : 100
		}, {
			title : "���ڽ����",
			field : 'amt',
			width : 100
		}, {
			title : "���ڽ������",
			field : 'lastqty',
			width : 100
		}, {
			title : "���ڽ����",
			field : 'lastamt',
			width : 100
		}, {
			title : "�������",
			field : 'recqty',
			width : 100
		}, {
			title : "�����",
			field : 'recamt',
			width : 100
		}, {
			title : "�˻�����",
			field : 'retqty',
			width : 100
		}, {
			title : "�˻����",
			field : 'retamt',
			width : 100
		}, {
			title : "ת������",
			field : 'trfoqty',
			width : 100
		}, {
			title : "ת�����",
			field : 'trfoamt',
			width : 100
		}, {
			title : "ת������",
			field : 'trfiqty',
			width : 100
		}, {
			title : "ת����",
			field : 'trfiamt',
			width : 100
		}, {
			title : "��������",
			field : 'adjqty',
			width : 100
		}, {
			title : "�������",
			field : 'adjamt',
			width : 100
		}, {
			title : "�̵��������",
			field : 'stkqty',
			width : 100
		}, {
			title : "�̵�������",
			field : 'stkamt',
			width : 100
		}, {
			title : "��������",
			field : 'conqty',
			width : 100
		}, {
			title : "������",
			field : 'conamt',
			width : 100
		}, {
			title : "��������",
			field : 'aspamt',
			width : 100
		}, {
			title : "��������",
			field : 'diffQty',
			width : 100
		}, {
			title : "������",
			field : 'diffAmt',
			width : 100
		}		
	]];
	var StkMonStatDetailLBSpGrid = $UI.datagrid('#StkMonStatDetailLBSpGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCStkMonReportLB',
			QueryName: 'StkMonRepLcBt'
		},
		columns: StkMonStatDetailLBCm,
		sortName: 'RowId',  
		sortOrder: 'Desc'
	});
	
	ClearHistoryStkMonStat();
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			SearchDetail();
		}
	});
	/// ��ϸ�и��ݷ���ɸѡ
	function SearchDetail(){
		var tabtitle=$('#StkMonTab').tabs('getSelected').panel('options').title;
		var ParamsObj=GetParamsObj();
		if (tabtitle=="�±���ϸ(�ۼ�)"){
				var Params=JSON.stringify(addSessionParams({smRowid:growid,ScgType:SCGTYPE,stkgrpid:ParamsObj.StkGrpId,stkcatid:ParamsObj.StkCatBox,incdesc:ParamsObj.InciDesc}));
				$UI.setUrl(StkMonStatDetailSpGrid);
				StkMonStatDetailSpGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCStkMonRepQuery',
					QueryName: 'StkMonRepItm',
					Params:Params
				});
		}else if (tabtitle=="�±���ϸ(����)"){
				var Params=JSON.stringify(addSessionParams({smRowid:growid,ScgType:SCGTYPE,stkgrpid:ParamsObj.StkGrpId,stkcatid:ParamsObj.StkCatBox,incdesc:ParamsObj.InciDesc}));
				$UI.setUrl(StkMonStatDetailRpGrid);
				StkMonStatDetailRpGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCStkMonRepQuery',
					QueryName: 'StkMonRepItmRp',
					Params:Params
				});
		}else if (tabtitle=="�±���ϸ����(����)"){
				var Params=JSON.stringify(addSessionParams({smRowid:growid,ScgType:SCGTYPE,stkgrpid:ParamsObj.StkGrpId,stkcatid:ParamsObj.StkCatBox,incdesc:ParamsObj.InciDesc}));
				$UI.setUrl(StkMonStatDetailLBRpGrid);
				StkMonStatDetailLBRpGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCStkMonReportLB',
					QueryName: 'StkMonRepLcBt',
					Params:Params
				});
		}else if (tabtitle=="�±���ϸ����(�ۼ�)"){
				var Params=JSON.stringify(addSessionParams({smRowid:growid,ScgType:SCGTYPE,stkgrpid:ParamsObj.StkGrpId,stkcatid:ParamsObj.StkCatBox,incdesc:ParamsObj.InciDesc}));
				$UI.setUrl(StkMonStatDetailLBSpGrid);
				StkMonStatDetailLBSpGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCStkMonReportLB',
					QueryName: 'StkMonRepLcBt',
					Params:Params
				});
		}
		
		
	}
	$UI.linkbutton('#SubmitBT',{
		onClick:function(){
			SubmitStkMon();
		}
	});
	function SubmitStkMon(){
		var Row=HistoryStkMonStatGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg("alert",'��ѡ����Ҫ�ύƾ֤���±�!');
				return false;
			}
		var smRowid=Row.smRowid;
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCStkMon',
			MethodName: 'Submit',
			smRowId: smRowid,
			UserId : gUserId 
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				QueryHistoryStkMonStat();
			}else{
				$UI.msg('error',jsonData.msg);		
			}
		});
		
	}
	$UI.linkbutton('#CancelSubmitBT',{
		onClick:function(){
			CancelSubmitStkMon();
		}
	});
	function CancelSubmitStkMon(){
		var Row=HistoryStkMonStatGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg("alert",'��ѡ����Ҫȡ���ύƾ֤���±�!');
				return false;
			}
		var smRowid=Row.smRowid;
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCStkMon',
			MethodName: 'CancelSubmit',
			smRowId: smRowid,
			UserId:gUserId  
		},function(jsonData){
			$UI.msg('alert',jsonData.msg);
			if(jsonData.success==0){
				QueryHistoryStkMonStat();
			}
		});
		
	}
}
$(init);