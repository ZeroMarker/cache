/*���ɸ����±�*/
var init = function () {
	var PayMonLocParams=JSON.stringify(addSessionParams({Type:"Login"}));
	var PayMonLocBox = $HUI.combobox('#HistoryPayMonLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PayMonLocParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var PayMonCm = [[
		{	field: 'check',
			checkbox: true
		},{
			title: 'lastPayMonRowid',
			field: 'lastPayMonRowid', 
			width:100,
			hidden: true
		}, {
			title: 'LocId',
			field: 'LocId',
			width: 80,
			hidden: true
		}, {
			title: '����',
			field: 'LocDesc',
			width: 230
		}, {
        	title: "�����·�",
       		field:'lastMonth',
        	width: 100
		}, {
			title : "������ʼ����",
			field : 'lastFrDate',
			width : 100
		}, {
			title : "���ڽ�ֹ����",
			field : 'lastToDate',
			width : 100
		}, {
			title : "�����·�",
			field : 'CurMonth',
			width : 100,
			editor:{
				type:'text',
				options:{
					required:true
					}
				}
		}, {
			title : "���ڿ�ʼ����",
			field : 'CurStartDate',
			width : 100,
			editor:{
				type:'datebox',
				options:{
					required:true
					}
				}
		}, {
			title : "���ڽ�ֹ����",
			field : 'CurEndDate',
			width : 100,
			editor:{
				type:'datebox',
				options:{
					required:true
					}
				}
		}		
	]];
	function CheckBeforeCreate() {
		var RowData = PayMonGrid.getChecked();
		var flag=true;
		for (var i = 0; i < RowData.length; i++) {
			var LocDesc=RowData[i].LocDesc;
			var CurEndDate = RowData[i].CurEndDate;
			var Today=DateFormatter(new Date());
			var NowTime=new Date().format('H:i:s');
			if (FormatDate(CurEndDate)>=FormatDate(Today))
			{
				$UI.msg('alert', LocDesc+'���ڽ�ֹ���ڲ��ܳ�����ǰ����!');
				flag=false;
			}
		}
		return flag;
	}
	var PayMonGrid = $UI.datagrid('#PayMonGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPayMon',
			QueryName: 'jsGrpLocForPayMon'
		},
		singleSelect:false,
		checkOnSelect: false,
		columns: PayMonCm,
		toolbar:[{
			id:'SaveBT',
			text: '���ɸ����±�',
			iconCls: 'icon-save',
			handler: function () {
				PayMonGrid.endEditing();
				if(CheckBeforeCreate()){
				CreatePayMon();
				}
			}
		}],
		idField: 'LocId',
		sortName: 'RowId',  
		sortOrder: 'Desc',   
		onClickCell: function(index, field ,value){	
			var Row = PayMonGrid.getRows()[index];
			if ((field == 'CurStartDate')&&(Row.lastPayMonRowid!="")) {
				return false;
			}
			PayMonGrid.commonClickCell(index,field,value)
		},
		onEndEdit:function(index, row, changes){
			var Editors = $(this).datagrid('getEditors', index);
		    for(var i=0;i<Editors.length;i++){
				var Editor = Editors[i];
				var Today=DateFormatter(new Date());
				var NowTime=new Date().format('H:i:s');
				if(Editor.field=='CurEndDate'){
					var CurEndDate=row.CurEndDate;
					if (FormatDate(CurEndDate)>=FormatDate(Today))
					{
						$UI.msg('alert', '���ڽ�ֹ���ڲ��ܳ�����ǰ����!');
						PayMonGrid.checked=false;
						return false;
					}
					var FormatCurEndDate=FormatDate(CurEndDate);
					var NewCurEndDate = FormatCurEndDate.getFullYear()+'-'+(FormatCurEndDate.getMonth()+1);
					row.CurMonth=NewCurEndDate;
				}else 
				if (Editor.field=='CurEndTime'){
					var CurEndTime=row.CurEndTime
					if (CurEndTime>NowTime)
					{
						$UI.msg('alert', '���ڽ�ֹʱ�䲻�ܳ�����ǰʱ��!');
						PayMonGrid.checked=false;
						return false;
					}
				}
				
		    }
		}
	})
	function CreatePayMon(){
		var RowData=PayMonGrid.getChecked();
		if(isEmpty(RowData)){
			$UI.msg('alert','ѡ����Ҫ���ɸ����±��Ŀ���!');
			return false;
		}
		var RowData=JSON.stringify(RowData);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCPayMon',
			MethodName: 'CreatePayReports',
			MainParams: RowData,
			UserId:gUserId  
		},function(jsonData){
			hideMask();
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				QueryPayMon();
				QueryHistoryPayMon();
			}else{
				$UI.msg('error',jsonData.msg);		
			}
		});
		
	}
	var HistoryPayMonCm = [[
		{
			title: 'pmRowid',
			field: 'pmRowid',
			width:100,
			hidden: true
		}, {
			title: '����',
			field: 'locDesc',
			width: 230
		}, {
		title: "�·�",
		field:'MonthDate',
		width: 100
		}, {
			title : "���ڽ�����",
			field : 'LastRpAmt',
			align : 'right',
			width : 100
		}, {
			title : "�������ӽ��",
			field : 'ArrearRpAmt',
			align : 'right',
			width : 100
		}, {
			title : "���ڸ�����",
			field : 'PayedRpAmt',
			align : 'right',
			width : 100
		}, {
			title : "���ڽ�����",
			field : 'EndRpAmt',
			align : 'right',
			width : 100
		}, {
	        title: "�����±���ʼ����",
	        field: 'frDate',
	        width: 130 
		}, {
	        title: "�����±���ֹ����",
	        field: 'toDate',
	        width: 130 
		}		
	]];
	var HistoryPayMonGrid = $UI.datagrid('#HistoryPayMonGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPayMon',
			QueryName: 'DHCPayMon'
		},
		columns: HistoryPayMonCm,
		sortName: 'RowId',  
		sortOrder: 'Desc',   
		onClickCell: function(index, field ,value){	
			HistoryPayMonGrid.commonClickCell(index,field,value)
		}
	})
	$UI.linkbutton('#SearchBT',{
		onClick:function(){
			QueryHistoryPayMon();
		}
	});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			ClearHistoryPayMon();
		}
	});
	$UI.linkbutton('#DeleteBT',{
		onClick:function(){
			var Row=HistoryPayMonGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert', "��ѡ��Ҫɾ������ʷ�����±�!");
				return false;
			}
			var LocDesc=Row.locDesc;
			var curMon=Row.MonthDate;
			$UI.confirm("�Ƿ�ȷ��ɾ��"+LocDesc+curMon+"�·ݵĸ����±�", "warning", "", DeleteHistoryPayMon, "", "", "����", false);
		}
	});
	function ClearHistoryPayMon(){
		$UI.clearBlock('#HistoryPayMonConditions');
		$UI.clear(HistoryPayMonGrid);
		///���ó�ʼֵ ����ʹ������
		var Dafult={
					HistoryPayMonLoc : gLocObj
					}
		$UI.fillBlock('#HistoryPayMonConditions',Dafult);
	}
	function QueryHistoryPayMon(){
		var ParamsObj=$UI.loopBlock('#HistoryPayMonConditions');
		if(isEmpty(ParamsObj.HistoryPayMonLoc)){
			$UI.msg('alert', "���Ҳ���Ϊ��!");
			return false;
		}	
		var StYear=ParamsObj.StYear;
		var StMonth=ParamsObj.StMonth;
		var EdYear=ParamsObj.EdYear;
		var EdMonth=ParamsObj.EdMonth;
		var StartDate="";
		var EndDate="";
		if ((!isEmpty(StYear))&&(!isEmpty(StMonth))&&(!isEmpty(EdYear))&&(!isEmpty(EdMonth)))
		{
			var StartDate=StYear+'-'+StMonth+'-'+'01';
			var EndDate=EdYear+'-'+EdMonth+'-'+'01';
		}
		
		$UI.setUrl(HistoryPayMonGrid);
		HistoryPayMonGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCPayMon',
			QueryName: 'DHCPayMon',
			loc:ParamsObj.HistoryPayMonLoc,
			StartDate:StartDate,
			EndDate:EndDate
		});
	
	}
	function DeleteHistoryPayMon(){
		var Row=HistoryPayMonGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert', 'ѡ����Ҫɾ���ļ�¼!');
				return false;
			}
			var Rowid=Row.pmRowid;
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCPayMon',
			MethodName: 'Delete',
			pm: Rowid  
		},function(jsonData){
			hideMask();
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				QueryPayMon();
				QueryHistoryPayMon();
			}else{
				$UI.msg('error',jsonData.msg);		
			}
		});
		
	}
	function QueryPayMon(){
		$UI.setUrl(PayMonGrid);
		PayMonGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCPayMon',
			QueryName: 'jsGrpLocForPayMon',
			gGroupId: gGroupId,
			Params:JSON.stringify(addSessionParams())
		});
	
	}
	ClearHistoryPayMon();
	QueryPayMon();

}
$(init);