var init = function() {
	//=======================������ʼ��start==================
	var UseItmTrack=GetAppPropValue('DHCITMTRACKM').UseItmTrack;
	//����
	var SupLocParams=JSON.stringify(addSessionParams({Type:"LinkLoc"}));
	var SupLocBox = $HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onChange:function(e){
			init(e)
		}
	});
	//����  ����������
	$('#ScgStk').stkscgcombotree({
		onSelect:function(node){
			$.cm({
				ClassName:'web.DHCSTMHUI.Common.Dicts',
				QueryName:'GetStkCat',
				ResultSetType:'array',
				StkGrpId:node.id
			},function(data){
				StkCatBox.loadData(data);
			});
		}
	})
	//������
	var StkCatBox = $HUI.combobox('#StkCatBox', {
			valueField: 'RowId',
			textField: 'Description'
		});
	var HVFlagParams=JSON.stringify(addSessionParams());
	var HVFlag = $HUI.combobox('#HVFlag', {
			url:$URL + '?ClassName=web.DHCSTMHUI.INStkTk&QueryName=GetHVflag&ResultSetType=array&HVFlagParams='+HVFlagParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	
	function init(LocId){
		var LocManGrpBox = $HUI.combobox('#LocManGrp', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocManGrp&ResultSetType=array&LocId='+LocId,
			valueField: 'RowId',
			textField: 'Description',
			multiple:true,
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:false,
			formatter:function(row){  
				var opts;
				if(row.selected==true){
					opts = row.Description+"<span id='i"+row.RowId+"' class='icon icon-ok'></span>";
				}else{
					opts = row.Description+"<span id='i"+row.RowId+"' class='icon'></span>";
				}
				return opts;
			},
			onSelect:function(rec) {
				var obji =  document.getElementById("i"+rec.RowId);
				$(obji).addClass('icon-ok');
			},
			onUnselect:function(rec){
				var obji =  document.getElementById("i"+rec.RowId);
				$(obji).removeClass('icon-ok');
			}
		});
			//��ʼ��λ
		var StartLocStkBinParams=JSON.stringify(addSessionParams({LocDr:LocId}));
		var StartLocStkBinBox = $HUI.combobox('#StartLocStkBin', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocStkBin&ResultSetType=array&Params='+StartLocStkBinParams,
			valueField: 'RowId',
			textField: 'Description'
		});
		//��ֹ��λ
		var StartLocStkBinParams=JSON.stringify(addSessionParams({LocDr:LocId}));
		var StartLocStkBinBox = $HUI.combobox('#EndLocStkBin', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocStkBin&ResultSetType=array&Params='+StartLocStkBinParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	}
	
	//===========================������ʼend===========================
	// ======================tbar�����¼�start=========================
	//��ѯ
	$UI.linkbutton('#QueryBT',{ 
		onClick:function(){
			FindWin(query);
		}
	});
	var query = function query(Params){ 
		if(isEmpty(Params.FStartDate)){
			Params.FStartDate=DateFormatter(new Date())
		}
		if(isEmpty(Params.FEndDate)){
			Params.FEndDate=DateFormatter(new Date())
		}
		if(isEmpty(Params.FLocId)){
			var loc=$('#SupLoc').combobox('getValue');
			Params.FLocId=loc;
		}
		var Params=JSON.stringify(Params)
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk',
			sort:"instNo",
			order:"desc",
			Params: Params
		});
	}
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear();
		}
	});
	function Clear(){
		$UI.clearBlock('#MainConditions');
		$UI.clear(MasterGrid);
		$UI.clear(DetailGrid);
		var Dafult={
				SupLoc:gLocObj,
				InstNo:"",
				InstDate:"",
				InstTime:"",
				Comp:"",
				Remark:"",
				StartLocStkBin:"",
				ScgStk:"",
				StkCatBox:"",
				MinRp:"",
				MaxRp:"",
				EndLocStkBin:"",
				RandomNum:"",
				NotUseFlag:"",
				HVFlag:UseItmTrack=="Y"?2:0,
				TkUom:"1",
				ManageDrugFlag:""
			}
		$UI.fillBlock('#MainConditions',Dafult)
		DetailGrid.setFooterInfo();
	}
	//�����̵��
	$UI.linkbutton('#SaveBT',{
		onClick:function(){
			var MainObj=$UI.loopBlock('#MainConditions');
			MainObj.LocManGrp = MainObj.LocManGrp.join(',');
			var LocId = MainObj['SupLoc'];
			if(isEmpty(LocId)){
				$UI.msg('alert', '��ѡȡ����!');
				return;
			}
			var HVFlag=MainObj.HVFlag;
			if(isEmpty(HVFlag)){
				$UI.msg('alert','��ֵ��־����Ϊ��');
				return;
			}
			var CheckParams = {LocId : LocId};
			var CheckRet = $.m({
				ClassName: 'web.DHCSTMHUI.Common.UtilCommon',
				MethodName: 'CheckBeforeInstk',
				Params: JSON.stringify(CheckParams)
			},false);
			if(!isEmpty(CheckRet)){
				$UI.msg('alert', CheckRet);
				return;
			}
			var Main=JSON.stringify(MainObj);
			$.cm({
				ClassName: 'web.DHCSTMHUI.INStkTk',
				MethodName: 'jsCreateInStktk',
				Main: Main
			},function(jsonData){
				if(jsonData.success>=0){
					$UI.msg('success',jsonData.msg);
					var ParamsObj=$UI.loopBlock('#FindWin');
					query(ParamsObj)
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
	
	//���
	var Comp= function(){
		var row = $('#MasterGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert','��ѡ��������!');
			return false;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			MethodName: 'jsSetComplete',
			inst: row.inst
		},function(jsonData){
			if(jsonData.success>=0){
				var ParamsObj=$UI.loopBlock('#FindWin');
				query(ParamsObj)
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}
	//ȡ�����
	var SetUnComplete= function(){
		var row = $('#MasterGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert','��ѡ��������!');
			return false;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			MethodName: 'jsSetUnComplete',
			inst: row.inst
		},function(jsonData){
			if(jsonData.success>=0){
				$UI.msg('success',jsonData.msg);
				var ParamsObj=$UI.loopBlock('#FindWin');
				query(ParamsObj);
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}
	//ɾ��
	var Delete = function(){
		var row = $('#MasterGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert','��ѡ��������!');
			return false;
		}
		if (row.comp=="Y") {
			$UI.msg('alert','����ȡ����ɺ���ɾ������!');
			return false;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			MethodName: 'jsDelete',
			inst: row.inst
		},function(jsonData){
			if(jsonData.success>=0){
				$UI.msg('success',jsonData.msg);
				var ParamsObj=$UI.loopBlock('#FindWin');
				Clear();
				query(ParamsObj);
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	}
	function Select(){
		$UI.clearBlock('#MainConditions');
		var row = $('#MasterGrid').datagrid('getSelected');
		if(isEmpty(row)){
			$UI.msg('alert','��ѡ������!');
			return;
		}
		if(isEmpty(row.inst)){
			$UI.msg('alert','��������!');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			MethodName: 'jsSelect',
			inst: row.inst
		}, function(jsonData){
			$UI.fillBlock('#MainConditions',jsonData);
			$("#LocManGrp").combobox("setValues",jsonData.InStkGrpId.split(','));
			//��ť����
			if($HUI.checkbox("#Comp").getValue()){
				//setEditDisable();
			}else{
				//setEditEnable();
			}
		});
	}
	//������ϸ
	function loadDetailGrid(){
		var row = $('#MasterGrid').datagrid('getSelected');
		if(isEmpty(row)){
			$UI.msg('alert','��ѡ������!');
			return;
		}
		if(isEmpty(row.inst)){
			$UI.msg('alert','��������!');
			return;
		}
		var ParamsObj=$UI.loopBlock('DetailConditions');
		var Params = JSON.stringify(ParamsObj);
		DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INStkTkItm',
				QueryName: 'jsDHCSTInStkTkItm',
				Inst: row.inst,
				Others:"",
				qPar:"",
				totalFooter:'"code":"�ϼ�"',
				totalFields:'freQty,freezeRpAmt'
			});
	}
	//��ӡ
	function print(type){
		var row = $('#MasterGrid').datagrid('getSelected');
		if(isEmpty(row)){
			$UI.msg('alert','��ѡ������!');
			return;
		}
		if(isEmpty(row.inst)){
			$UI.msg('alert','��������!');
			return;
		}
		var ret = tkMakeServerCall("web.DHCSTMHUI.INStkTk", "UpPrintFlag", row.inst);
		PrintINStk(row.inst, type);
	}
	//======================tbar�����¼�end============================
	
	var MasterGridCm = [[ {
			title: 'inst',
			field: 'inst',
			hidden: true
		},{
			title: '�̵㵥��',
			field: 'instNo',
			width:200
		}, {
			title:"����",
			field:'date',
			width:100,
			align:'left'
		}, {
			title:"ʱ��",
			field:'time',
			width:70,
			align:'left'
		}, {
			title:"�̵���rowid",
			field:'user',
			hidden: true
		}, {
			title:"�̵���",
			field:'userName',
			width:70,
			align:'left'
		}, {
			title:"״̬",
			field:'status',
			width:70,
			align:'left',
			hidden: true
		},  {
			title:"����rowid",
			field:'loc',
			hidden:true
		},  {
			title:"����",
			field:'locDesc',
			width:100,
			align:'left'
		}, {
			title:"�̵����",
			field:'comp',
			width:70,
			align:'left',
			formatter: function(value,row,index){
				if (row.comp=="Y"){
					return "�����";
				} else {
					return "δ���";
				}
			}
		}, {
			title:"ʵ��¼�����",
			field:'stktkComp',
			width:70,
			align:'left',
			hidden: true
		}, {
			title:"�������",
			field:'adjComp',
			width:70,
			align:'left',
			hidden: true
		}, {
			title:"adj",
			field:'adj',
			hidden:true
		}, {
			title:"manFlag",
			field:'manFlag',
			width:70,
			align:'left',
			hidden: true
		}, {
			title:"���̵�λ",
			field:'freezeUom',
			width:70,
			align:'left',
			formatter: function(value,row,index){
				if (row.freezeUom==1){
					return "��ⵥλ";
				} else {
					return "������λ";
				}
			}
		}, {
			title:"���̽��۽��",
			field:'SumFreezeRpAmt',
			width:100,
			align:'right'
		}, {
			title:"�����ۼ۽��",
			field:'SumFreezeSpAmt',
			width:100,
			align:'right'
		}, {
			title:"����������",
			field:'includeNotUse',
			width:100,
			align:'left'
		}, {
			title:"��������",
			field:'onlyNotUse',
			width:70,
			align:'left'
		}, {
			title:"����rowid",
			field:'scg',
			hidden:true
		}, {
			title:"����",
			field:'scgDesc',
			width:70,
			align:'left'
		}, {
			title:"������rowid",
			field:'sc',
			hidden:true
		}, {
			title:"������",
			field:'scDesc',
			width:70,
			align:'left'
		}, {
			title:"��ʼ��λ",
			field:'frSb',
			width:70,
			align:'left'
		}, {
			title:"������λ",
			field:'toSb',
			width:70,
			align:'left'
		}, {
			title:"¼������",
			field:'InputType',
			width:70,
			align:'left',
			hidden: true
		}, {
			title:"��ӡ��־",
			field:'printflag',
			width:70,
			align:'left'
		}, {
			title:"��ͽ���",
			field:'MinRp',
			width:70,
			align:'right'
		}, {
			title:"��߽���",
			field:'MaxRp',
			width:70,
			align:'right'
		}, {
			title:"�����",
			field:'RandomNum',
			width:70,
			align:'right'
		}, {
			title:"��ֵ��־",
	        	field:'HighValue',
			width:70,
			align:'left'
		}
	]];
	var MasterGrid = $UI.datagrid('#MasterGrid',{
		url : $URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk'
		},
		columns: MasterGridCm,
		showBar: true,
		toolbar:[{
				text: '���',
				iconCls: 'icon-ok',
				handler: function () {
					Comp();
				}},{
				text: 'ȡ�����',
				iconCls: 'icon-no',
				handler: function () {
					SetUnComplete();
				}},{
				text: 'ɾ��',
				iconCls: 'icon-cancel',
				handler: function () {
					Delete();
				}},{
				text: '�����δ�ӡ',
				iconCls: 'icon-print',
				handler: function () {
					var type = 1;
					print(type);
				}},{
				text: '��Ʒ�ִ�ӡ',
				iconCls: 'icon-print',
				handler: function () {
					var type = 2;
					print(type);
				}}],
		onSelect:function(index, row){
			loadDetailGrid();
			Select();
		},
		onLoadSuccess:function(data){
			if(data.rows.length>0){
				$('#MasterGrid').datagrid("selectRow", 0)
				loadDetailGrid();
				Select();
			}
		}
	})
	var DetailGridCm = [[{
			title: 'rowid',
			field: 'rowid',
			hidden: true
		}, {
			title: 'inclb',
			field: 'inclb',
			hidden: true
		}, {
			title: 'inci',
			field: 'inci',
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'code',
			width:120
		}, {
			title: '��������',
			field: 'desc',
			width:150
		}, {
			title: "���",
			field:'spec',
			width:100
		}, {
			title:"����",
			field:'manf',
			width:100
		}, {
			title:"����",
			field:'barcode',
			width:100,
			align:'left'
		}, {
			title:"��������",
			field:'freQty',
			width:100,
			align:'right'
		}, {
			title:"��������",
			field:'freDate',
			width:100
		}, {
			title:"����ʱ��",
			field:'freTime',
			width:100,
			align:'left'
		}, {
			title:"ʵ������",
			field:'countQty',
			width:100,
			align:'right',
			hidden:true
		}, {
			title:"ʵ������",
			field:'countDate',
			width:100,
			hidden:true
		}, {
			title:"ʵ��ʱ��",
			field:'countTime',
			width:80,
			align:'left',
			hidden:true
		}, {
			title:"ʵ����",
			field:'countPerson',
			hidden: true,
			align:'left',
			hidden:true
		}, {
			title:"ʵ����",
			field:'countPersonName',
			width:100,
			align:'left',
			hidden:true
		}, {
			title:"dd",
			field:'variance',
			width:100,
			align:'left',
			hidden:true
		}, {
			title:"��ע",
			field:'remark',
			width:60,
			align:'left',
			hidden:true
		}, {
			title:"״̬",
			field:'status',
			width:60,
			align:'left'
		}, {
			title:"��λ",
			field:'uom',
			hidden: true,
			align:'left',
			hidden:true
		}, {
			title:"��λ",
			field:'uomDesc',
			width:60,
			align:'left'
		}, {
			title:"����",
			field:'batchNo',
			width:100,
			align:'left'
		}, {
			title:"��Ч��",
			field:'expDate',
			width:100,
			align:'left'
		}, {
			title:"������",
			field:'specdesc',
			width:100,
			align:'left'
		}, {
			title:"������־",
			field:'adjFlag',
			width:60,
			align:'left',
			hidden:true
		}, {
			title:"��λ��",
			field:'sbDesc',
			width:100,
			align:'left'
		}, {
			title:"dd",
			field:'inadi',
			hidden: true,
			align:'left',
			hidden:true
		}, {
			title:"�ۼ�",
			field:'sp',
			width:60,
			align:'right',
			hidden:true
		}, {
			title:"����",
			field:'rp',
			width:60,
			align:'right'
		}, {
			title:"�����ۼ۽��",
			field:'freezeSpAmt',
			width:60,
			align:'right',
			hidden:true
		}, {
			title:"���̽��۽��",
			field:'freezeRpAmt',
			width:100,
			align:'right'
		}, {
			title:"ʵ���ۼ۽��",
			field:'countSpAmt',
			width:60,
			align:'right',
			hidden:true
		}, {
			title:"ʵ�̽��۽��",
			field:'countRpAmt',
			width:60,
			align:'right',
			hidden:true
		}, {
			title:"�����ۼ۽��",
			field:'varianceSpAmt',
			width:60,
			align:'right',
			hidden:true
		}, {
			title:"������۽��",
			field:'varianceRpAmt',
			width:60,
			align:'right',
			hidden:true
		}, {
			title:"dd",
			field:'trueQty',
			width:60,
			align:'right',
			hidden:true
		}, {
			title:"����",
			field:'scgDesc',
			width:100,
			align:'left'
		}, {
			title:"��Ӧ��",
			field:'vendor',
			width:100,
			align:'left'
		}, {
			title:"������",
			field:'incscdesc',
			width:100,
			align:'left'
		}, {
			title:"dd",
			field:'freeBarCode',
			width:60,
			align:'left',
			hidden:true
		}, {
			title:"dd",
			field:'countBarCode',
			width:60,
			align:'left',
			hidden:true
		}, {
			title:"dd",
			field:'varianceBarCode',
			width:60,
			align:'left',
			hidden:true
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid',{
		queryParams : {
			ClassName: 'web.DHCSTMHUI.INStkTkItm',
			QueryName: 'jsDHCSTInStkTkItm'
		},
		columns : DetailGridCm,
		showBar: true,
		totalFooter:'"code":"�ϼ�"',
		totalFields:'freQty,freezeRpAmt'
	})
	Clear();
}
$(init);
