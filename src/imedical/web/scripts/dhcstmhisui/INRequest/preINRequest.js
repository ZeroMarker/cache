var ReqTemplateFlag = false;
var gHVInRequest = '';
var init = function() {
	 ///���ÿɱ༭�����disabled����
	function setEditDisable(){
		$HUI.combobox("#ReqLoc").disable();
		$HUI.combobox("#ScgStk").disable();
	}
	///�ſ��ɱ༭�����disabled����
	function setEditEnable(){
		$HUI.combobox("#ReqLoc").enable();
		$HUI.combobox("#ScgStk").enable();
	}
	var ClearMain=function(){
		$UI.clearBlock('#MainConditions');
		$UI.clear(InRequestGrid);
		var Dafult={
			ReqLoc:gLocObj,
			ReqType:'C'
		};
		$UI.fillBlock('#MainConditions',Dafult);
		ChangeButtonEnable({'#DelBT':false,'#PrintBT':false,'#ComBT':false,'#CanComBT':false,'#SaveBT':true});
	}
	//Grid �� comboxData
	var UomCombox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required:true,
			mode:'remote',
			editable:false,
			onBeforeLoad:function(param){
				var rows =InRequestGrid.getRows();
				var row = rows[InRequestGrid.editIndex];
				if(!isEmpty(row)){
					param.Inci =row.Inci;
				}
			},
			onSelect:function(record){
				var rows =InRequestGrid.getRows();
				var row = rows[InRequestGrid.editIndex];
				row.UomDesc=record.Description;
				var Uom=record.RowId;
				var Inci=row.Inci;
				var LocId=$HUI.combobox("#ReqLoc").getValue();
				var FrLoc ="";
				var Params=gGroupId+"^"+LocId+"^"+gUserId+"^"+Uom+"^"+FrLoc;
				GetItmInfo(Inci,Params,row,InRequestGrid.editIndex);
			}
		}
	};
	function GetItmInfo(Inci,Params,Row,index){
		var Data=tkMakeServerCall('web.DHCSTMHUI.INRequest','GetItmInfo',Inci,Params);
		var ArrData=Data.split("^");
		var ManfId = ArrData[0];
		var ManfDesc = ArrData[1];
		Row.Manf=ManfDesc,
		Row.Rp=ArrData[4];
		Row.Sp=ArrData[5];
		if(!isEmpty(Row.Qty)){
			Row.SpAmt=accMul(Number(Row.Qty),Number(Row.Sp));
			Row.RpAmt=accMul(Number(Row.Qty),Number(Row.Rp));
		}
		Row.RepLev=ArrData[10];
		setTimeout(function(){
			InRequestGrid.refreshRow();
			InRequestGrid.startEditingNext('Description');
		},0);
	}
	var SpecDescParams=JSON.stringify(sessionObj)
	var SpecDescbox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSpecDesc&ResultSetType=array&Params='+SpecDescParams,
			valueField: 'Description',
			textField: 'Description',
			mode:'remote',
			onBeforeLoad:function(param){
				var rows =InRequestGrid.getRows();
				var row = rows[InRequestGrid.editIndex];
				if(!isEmpty(row)){
					param.Inci =row.Inci;
				}
			}
		}
	};
	var ReqLocParams=JSON.stringify(addSessionParams({Type:INREQUEST_LOCTYPE}));
	var ReqLocBox = $HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	var UserBox = $HUI.combobox('#User', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetUser&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			FindWin(Select);
		}
	});
	$UI.linkbutton('#SaveBT',{
		onClick:function(){
			Save();
		}
	});		
	var Save=function(){
		var MainObj=$UI.loopBlock('#MainConditions');
		MainObj['SupLoc'] = MainObj['ReqLoc'];
		var IsChange=$UI.isChangeBlock('#MainConditions');
		var Main=JSON.stringify(MainObj);
		//ͨ��ģ���Ƶ�
		var Req=$('#RowId').val();
		if(ReqTemplateFlag && isEmpty(Req)){
			DetailObj=InRequestGrid.getRowsData();
		}else{
			DetailObj=InRequestGrid.getChangesData('Inci');
		}
		if (DetailObj === false) {
			return;
		} else if (DetailObj.length == 0 && IsChange == false) {
			$UI.msg('alert', 'û����Ҫ���������!');
			return;
		}
		var Detail=JSON.stringify(DetailObj)
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INRequest',
			MethodName: 'Save',
			Main: Main,
			Detail: Detail
		},function(jsonData){
			hideMask();
			if(jsonData.success === 0){
				$UI.msg('success',jsonData.msg);
				Select(jsonData.rowid);
				ReqTemplateFlag = false;
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#DelBT',{
		onClick:function(){
			var Req=$('#RowId' ).val();
			if(isEmpty(Req)){return;}
			function del(){
				$.cm({
					ClassName: 'web.DHCSTMHUI.INRequest',
					MethodName: 'Delete',
					Req: Req
				},function(jsonData){
					if(jsonData.success === 0){
						$UI.msg('success',jsonData.msg);
						ClearMain();
						setEditEnable();
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
			}
			$UI.confirm('ȷ��Ҫɾ����?','','', del);
		}
	});
	
	// ���ǰ�ض��ж���ʾ
	function CheckDataBeforeComplete() {
		var MainObj = $UI.loopBlock('#MainConditions')
		var Req = MainObj.RowId;
		if (isEmpty(Req)) {
			$UI.msg('alert', '����Ҫ����ĵ���');
			return false;
		}
		var ToLocid=MainObj.ReqLoc;
		var rowData=InRequestGrid.getRows();
		var rowCount=rowData.length;
		var whiteColor = '#FFFFFF';
		var yellowColor = '#FFFF00';
		for (var i = 0; i < rowCount; i++) {
			SetGridBgColor(InRequestGrid,i,'RowId',whiteColor);
		}
		var count1=0;
		var count2=0;
		for (var i = 0; i < rowCount; i++) {
			var Inci = rowData[i].Inci;
			var Qty = rowData[i].Qty;
			var UomId = rowData[i].Uom;
			var LimitQtyStr=tkMakeServerCall("web.DHCSTMHUI.LocLimitAmt","GetLimitQty",ToLocid,Inci,UomId);
			var OnceReqQty=Number(LimitQtyStr.split("^")[0]);
			var AddReqQty=Number(LimitQtyStr.split("^")[1]);
			var AllReqQty=Number(LimitQtyStr.split("^")[2]);
			if ((OnceReqQty>0)&&(Qty>OnceReqQty)){
				SetGridBgColor(InRequestGrid,i,'RowId',yellowColor);
				count1=count1+1;
			}
			if ((AllReqQty>0)&&((AllReqQty-AddReqQty)<Qty)){
				SetGridBgColor(InRequestGrid,i,'RowId',yellowColor);
				count2=count2+1;
			}
		}
		if (count1>0){
			$UI.msg("alert","��������������������"+OnceReqQty);
			return false;
		}
		if (count2>0){
			$UI.msg("alert","��ʱ�����������������������"+AllReqQty+";����������"+(AllReqQty-AddReqQty));
			return false;
		}
		return true;
	}
	function Complete(){
			var MainObj=$UI.loopBlock('#MainConditions')
			var Req=MainObj.RowId;
			if(isEmpty(Req)){
				$UI.msg("alert","��ѡ�����뵥")
				return false;
			}
			var Main=JSON.stringify(addSessionParams({RowId:Req}));
			$.cm({
				ClassName: 'web.DHCSTMHUI.INRequest',
				MethodName: 'jsSetComp',
				Params:Main
			},function(jsonData){
				if(jsonData.success === 0){
					$UI.msg('success',jsonData.msg);
					Select(jsonData.rowid);
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
	}
	$UI.linkbutton('#ComBT',{
		onClick:function(){
			if(InRequestParamObj.UseLocLimitQty=="Y"){
				if (CheckDataBeforeComplete()){Complete();}
			}else{Complete();}	
		}
	});
	$UI.linkbutton('#CanComBT',{
		onClick:function(){
			var Req=$('#RowId').val()
			if(isEmpty(Req)){return;}
			$.cm({
				ClassName: 'web.DHCSTMHUI.INRequest',
				MethodName: 'jsCancelComp',
				Req: Req
			},function(jsonData){
				if(jsonData.success === 0){
					$UI.msg('success',jsonData.msg);
					Select(jsonData.rowid);
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			ClearMain();
			setEditEnable();
		}
	});
	$UI.linkbutton('#PrintBT',{
		onClick:function(){
			if(isEmpty($('#RowId' ).val())){
				$UI.msg("alert","û����Ҫ��ӡ������!");
				return;
			}
			if(InRequestParamObj.PrintNoComplete!='Y'&&!$HUI.checkbox("#Comp").getValue()){
				$UI.msg("alert","δ��ɲ��ܴ�ӡ!");
				return false;
			}
			PrintINRequest($('#RowId' ).val());
		}
	});
	$UI.linkbutton('#FindTemBT',{
		onClick:function(){
			findReqTemplateWin('C',Select,TemSelect);
		}
	});

	var Select=function(Req){
		$UI.clearBlock('#MainConditions');
		$UI.clear(InRequestGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.INRequest',
			MethodName: 'Select',
			Req: Req
		}, function(jsonData){
			$UI.fillBlock('#MainConditions',jsonData);
			setEditDisable();
			//��ť����
			if($HUI.checkbox("#Comp").getValue()){
				ChangeButtonEnable({'#DelBT':false,'#PrintBT':true,'#ComBT':false,'#CanComBT':true,'#SaveBT':false});
			}else{
				ChangeButtonEnable({'#DelBT':true,'#PrintBT':true,'#ComBT':true,'#CanComBT':false,'#SaveBT':true});
			}
		});
		var ParamsObj={RefuseFlag:1};
		var Params=JSON.stringify(addSessionParams(ParamsObj));
		InRequestGrid.load({
			ClassName: 'web.DHCSTMHUI.INReqItm',
			QueryName: 'INReqD',
			Req: Req,
			Params:Params,
			rows:99999
		});

	}
	var TemSelect=function(Req, ReqDetailIdStr){
		ClearMain();
		ReqTemplateFlag = true;
		$.cm({
			ClassName: 'web.DHCSTMHUI.INRequest',
			MethodName: 'Select',
			Req: Req
		}, function (jsonData) {
			$("#ScgStk").combotree('setValue', jsonData.ScgStk);
			$("#ReqLoc").combobox('setValue', jsonData.ReqLocId);
		});
		var ParamsObj = {
			RefuseFlag: 1,
			ReqDetailIdStr: ReqDetailIdStr
		};
		var Params=JSON.stringify(addSessionParams(ParamsObj));
		InRequestGrid.load({
			ClassName: 'web.DHCSTMHUI.INReqItm',
			QueryName: 'INReqD',
			Req: Req,
			Params:Params,
			rows:99999
		});
	}
	var HandlerParams=function(){
		var ReqLoc=$("#ReqLoc").combo('getValue');
		var QtyFlag = (InRequestParamObj.QtyFlag && InRequestParamObj.QtyFlag =='Y') ? '1' : '0';
		var Obj={StkGrpType:"M",NotUseFlag:"N",QtyFlag:QtyFlag,
			ToLoc:ReqLoc,ReqModeLimited:"C",NoLocReq:"N",RequestNoStock:InRequestParamObj.IsRequestNoStock};
		return Obj;
	}

	var SelectRow=function(row){
		var Rows =InRequestGrid.getRows();
		var Row = Rows[InRequestGrid.editIndex];
		InRequestGrid.updateRow({
			index:InRequestGrid.editIndex,
			row: {
				Inci:row.InciDr,
				Code:row.InciCode,
				Uom:row.PUomDr,
				UomDesc:row.PUomDesc,
				Sp:row.PSp,
				Description:row.InciDesc,
				Spec:row.Spec,
				StkQty:row.PUomQty,
				ReqPuomQty:row.ReqPuomQty,
				InciRemarks:row.Remarks,
				ProvLoc:row.ProvLoc,
				ProvLocId:row.ProvLocId,
				ZeroStkFlag:row.ZeroStkFlag,
				HVFlag:row.HVFlag
			}
		});
		var LocId=$HUI.combobox("#ReqLoc").getValue();
		var FrLoc ='';
		var Params=gGroupId+"^"+LocId+"^"+gUserId+"^"+row.PUomDr+"^"+FrLoc;
		GetItmInfo(row.InciDr,Params,Row,InRequestGrid.editIndex);
		//setTimeout(function(){InRequestGrid.refreshRow();},0);
	}
	var InRequestCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width:100,
			hidden: true
		}, {
			title: '����RowId',
			field: 'Inci',
			width:100,
			hidden: true
		}, {
			title: '����',
			field: 'Code',
			width:100
		}, {
			title: '����',
			field: 'Description',
			width:150,
			editor:InciEditor(HandlerParams,SelectRow)
		}, {
			title: "���",
			field:'Spec',
			width:100
		}, {
			title:"����",
			field:'Manf',
			width:150
		}, {
			title:"�������",
			field:'RepLev',
			width:100,
			align:'right'
		}, {
			title:"��������",
			field:'Qty',
			width:100,
			necessary:true,
			align:'right',
			editor:{
				type:'numberbox',
				options:{
					required:true
				}
			}
		}, {
			title:"���۵���",
			field:'Sp',
			width:100,
			align:'right'
		}, {
			title:"�ۼ۽��",
			field:'SpAmt',
			width:100,
			align:'right'
		},{
			title:"��λ",
			field:'Uom',
			width:100,
			necessary:true,
			formatter: CommonFormatter(UomCombox,'Uom','UomDesc'),
			editor:UomCombox
		},{
			title:"����ע",
			field:'ReqRemarks',
			width:200,
			align:'left',
			editor:{
				type:'validatebox'
			}
		},{
			title:"���ʱ�ע",
			field:'InciRemarks',
			width:200
		},{
			title:"������",
			field:'SpecDesc',
			width:100,
			align:'left',
			sortable:true,
			formatter: CommonFormatter(SpecDescbox, 'SpecDesc', 'SpecDesc'),
			editor:SpecDescbox
		},{
			title:"�����ҿ����",
			field:'ReqPuomQty',
			width:100,
			align:'right'
		},{
			title:"��ֵ��־",
			field:'HVFlag',
			width:80,
			align:'center',
			formatter: BoolFormatter
		},{
			title:"�����־",
			field:'ZeroStkFlag',
			width:80,
			align:'center',
			formatter: BoolFormatter
		},{
			title:"��Ӧ�ֿ�",
			field:'ProvLoc',
			width:150
		},{
			title:"��Ӧ�ֿ�id",
			field:'ProvLocId',
			hidden:true
		}
	]];

	var InRequestGrid = $UI.datagrid('#InRequestGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INReqItm',
			QueryName: 'INReqD',
			rows:99999
		},
		deleteRowParams:{
			ClassName:'web.DHCSTMHUI.INReqItm',
			MethodName:'Delete'
		},
		columns: InRequestCm,
		singleSelect:false,
		showBar:true,
		showAddDelItems:true,
		remoteSort: false,
		pagination: false,
		onClickCell: function(index, filed ,value){
			if($HUI.checkbox("#Comp").getValue()){
				return false;
			}
			InRequestGrid.commonClickCell(index,filed,value);
		},
		onEndEdit:function(index, row, changes){
			if(isEmpty(row.ProvLocId)){
				$UI.msg("alert","��Ӧ�ֿⲻ��Ϊ��!");
				InRequestGrid.checked=false;
				return false;
			}
			var Editors = $(this).datagrid('getEditors', index);
			for(var i=0;i<Editors.length;i++){
				var Editor = Editors[i];
				if(Editor.field=='Qty'){
					var RepLev=row.RepLev;
					var Qty=row.Qty;
					if(!isEmpty(Qty)){
						row.SpAmt=accMul(Number(row.Qty),Number(row.Sp));
						row.RpAmt=accMul(Number(row.Qty),Number(row.Rp));
					}
					var StkQty=row.StkQty;
					if (!isEmpty(RepLev)&RepLev!=0){RepLev=Qty%RepLev;}
					if ((!isEmpty(RepLev)&RepLev!=0)&&(InRequestParamObj.IfAllowReqBQtyUsed=="Y")){
						$UI.msg("alert","����������Ҫ�����������������!");
						InRequestGrid.checked=false;
						return false;
					}
				}
			}
		},
		onBeforeEdit:function(index,row){
			if($HUI.checkbox("#Comp").getValue()){
				return false;
			}
		},
		beforeDelFn:function(){
			if($HUI.checkbox("#Comp").getValue()){
				$UI.msg("alert","�Ѿ���ɣ�����ɾ��ѡ����!");
				return false;
			}
		},
		beforeAddFn:function(){
			if($HUI.checkbox("#Comp").getValue()){
				$UI.msg("alert","�Ѿ���ɣ���������һ��!");
				return false;
			}
			if(isEmpty($HUI.combobox("#ReqLoc").getValue())){
				$UI.msg("alert","������Ҳ���Ϊ��!");
				return false;
			}
			setEditDisable();
		},
		onLoadSuccess: function (data) {
			var Req = $('#RowId').val();
			if (isEmpty(Req)) {
				for (var i = 0; i < data.rows.length; i++) {
					$(this).datagrid('updateRow', {
						index: i,
						row: {RowId : ''}
					});
				}
			}
		}
	});

	ClearMain();
}
$(init);
