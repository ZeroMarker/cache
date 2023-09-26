function LoadReq(loc)
{
	var subLoc=loc;
	var url = 'dhcstm.indispreqaction.csp';
	var jReq = "";
	var currRow='';
	//��ʼ����
	var startDate = new Ext.ux.DateField({
		id:'startDate',
		//width:210,
		listWidth:210,
		allowBlank:true,
		fieldLabel:'��ʼ����',
		anchor:'90%',
		value:new Date().add(Date.DAY, -7)
	});
	//��ֹ����
	var endDate = new Ext.ux.DateField({
		id:'endDate',
		//width:210,
		listWidth:210,
		allowBlank:true,
		fieldLabel:'��ֹ����',
		anchor:'90%',
		value:new Date()
	});
	
	var LoadINDSToLoc = new Ext.ux.ComboBox({
		id:'LoadINDSToLoc',
		fieldLabel:'���տ���',
		emptyText:'���տ���...',
		triggerAction : 'all',
		store : LeadLocStore,
		valueParams : {groupId : gGroupId},
		filterName : '',
		childCombo : ['UserGrpX']
	});
	var INDSToLocId = Ext.getCmp('INDSToLoc').getValue();
	if(INDSToLocId != ''){
		INDSToLocDesc = Ext.getCmp('INDSToLoc').getRawValue()
		addComboData(LeadLocStore, INDSToLocId, INDSToLocDesc);
		LoadINDSToLoc.setValue(INDSToLocId);
	}
	
	var UserGrpX=new Ext.ux.ComboBox({
		fieldLabel:'רҵ��',	
		id:'UserGrpX',
		anchor : '90%',
		store:UserGroupStore,
		params:{SubLoc:'LoadINDSToLoc'}
	});
	
	var chkStatus=new Ext.form.Checkbox({
		fieldLabel:'����״̬',
		id:'AllStatus'
	});
	
	var NotDisp = new Ext.form.Checkbox({
		fieldLabel : 'δ����',
		id : 'NotDisp',
		name : 'NotDisp',
		//anchor : '90%',
		//width : 100,
		checked : true
	});
	var PartlyDisp = new Ext.form.Checkbox({
		fieldLabel : '���ַ���',
		id : 'PartlyDisp',
		name : 'PartlyDisp',
		//anchor : '90%',
		//width : 100,
		checked : true
	});
	var AllDisp = new Ext.form.Checkbox({
		fieldLabel : 'ȫ������',
		id : 'AllDisp',
		name : 'AllDisp',
		//anchor : '90%',
		checked : false
	});
	
	var startDispButton = new Ext.ux.Button({
		text:'ȷ�Ϸ���',
		tooltip:'ȷ�Ϸ��Ÿ����쵥����Ʒ',
		height:30,
		width:70,
		iconCls:'page_gear',
		handler:function(){
			var record=dsrqGrid.getSelectionModel().getSelected();
			if(record && record.get('status')=="X"){
				Msg.info("warning","��ǰ��ѡ�����쵥�Ѿ�ȡ��, ���ɷ���!");
				return;
			}
			if(record && record.get('status')=="R"){
				Msg.info("warning","��ǰ��ѡ�����쵥�Ѿ��ܾ�, ���ɷ���!");
				return;
			}
			CreateNewDisp();
		}
	});
	
	function CreateNewDisp()
	{
		if ((jReq==null)||(jReq=='') ) return;
		if(IndsRqItmGrid.activeEditor!=null){
			IndsRqItmGrid.activeEditor.completeEdit();
		}
		//׼���ӱ�����	
		var data='';
		var st=IndsRqItmGrid.getStore();
		var rd=xRowDelim();
		var records = IndsRqItmGrid.getSelectionModel().getSelections();
		for(var i=0,len=records.length;i<len;i++){
			rec = records[i];
			var RQI=rec.get('rowid');
			var uom=rec.get('uom');
			var dispQty=rec.get('dispQty');
			var moveStatus = rec.get('moveStatus');
			var rowIndex = st.indexOf(rec)+1;
			if(moveStatus=="X"){
				Msg.info("warning","��"+rowIndex+"����ȡ��,���ɷ���!");
				return;
			}else if(moveStatus=="R"){
				Msg.info("warning","��"+rowIndex+"���Ѿܾ�,���ɷ���!");
				return;
			}
			
			if (dispQty<=0) {	
				Msg.info('warning','��'+rowIndex+'�з�����������ȷ!');
				return;
			}
			if (data==''){
				data =RQI+"^"+ dispQty+"^"+ uom;
			}else{
				data=data+ rd+ RQI+"^"+ dispQty+"^"+ uom;
			}
		}
		
		if (data==''){
			Msg.info('error','û����ϸ���ݣ�');
			return;
		}
		//����
		Ext.Ajax.request({
			url:'dhcstm.indispaction.csp?actiontype=CreateDispByReq',
			params:{dsrq:jReq,userId:session['LOGON.USERID'],detailData:data,DispLoc:subLoc},
			success:function(result,request){
				var jsonData = Ext.util.JSON.decode(result.responseText );
				if (jsonData.success=='true') {
					Msg.info("success","����ɹ�!");
					mainRowId=jsonData.info   //rowid - ����rowid
					select(mainRowId);
					if (findWin) findWin.close();
				}else{
					Msg.info("error","����ʧ��:"+jsonData.info);
				}
			},
			failure:function(){
				Msg.info("failure","����ʧ��!");
			}
		});
	}
	var fB = new Ext.Toolbar.Button({
		text:'��ѯ',
		tooltip:'��ѯ',
		iconCls:'page_find',
		width : 70,
		height : 30,
		handler:function(){
			currRow='';
			var startDate = Ext.getCmp('startDate').getValue();
			if((startDate!="")&&(startDate!=null)){
				startDate = startDate.format(ARG_DATEFORMAT);
			}else{
				Msg.info("error","��ѡ����ʼ����!");
				return false;
			}
			var endDate = Ext.getCmp('endDate').getValue();
			if((endDate!="")&&(endDate!=null)){
				endDate = endDate.format(ARG_DATEFORMAT);
			}else{
				Msg.info("error","��ѡ���ֹ����!");
				return false;
			}
			var frLocId = Ext.getCmp('LoadINDSToLoc').getValue();
			if(Ext.isEmpty(frLocId)){
				var frLocId = tkMakeServerCall("web.DHCSTM.Common.UtilCommon","GetLeadSubLoc",subLoc);
				var frLocArr = frLocId.split("^");
				frLocId = frLocArr.join("%");		//���Ҽ�ʱ֧�������ɵ�id��, %����
			}
			
			var comp='Y';  //���
			var status="O";  //״̬
			
			if (chkStatus.getValue()==true) status="";
			var UserGrp=Ext.getCmp("UserGrpX").getValue();
			var NotDisp = (Ext.getCmp("NotDisp").getValue()==true?'0':'');
			var PartlyDisp = (Ext.getCmp("PartlyDisp").getValue()==true?'1':'');
			var AllDisp = (Ext.getCmp("AllDisp").getValue()==true?'2':'');
			var dispStatus=NotDisp+','+PartlyDisp+','+AllDisp;
			//��ʼ����^��ֹ����^����rowid^�û�rowid^��ɱ�־^רҵ��^����״̬
			var strPar = startDate+"^"+endDate+"^"+frLocId+"^^"+comp+"^"+status+"^"+UserGrp+"^"+dispStatus;
			
			dsrqitmDs.removeAll();
			dsrqDs.removeAll();
			dsrqDs.setBaseParam('sort','');
			dsrqDs.setBaseParam('dir','');
			dsrqDs.setBaseParam('strPar',strPar);
			
			dsrqDs.load({params:{start:0,limit:pagingToolbar3.pageSize}});
		}
	});
	
	var cB = new Ext.Toolbar.Button({
		text:'���',
		tooltip:'���',
		iconCls:'page_clearscreen',
		width : 70,
		height : 30,
		handler:function(){
			dsrqDs.removeAll();
			dsrqitmDs.removeAll();
		}
	});

	var RejectBT = new Ext.Toolbar.Button({
		id:'RejectBT',
		text:'�ܾ�',
		tooltip:'�ܾ����쵥',
		iconCls:'page_delete',
		width : 70,
		height : 30,
		handler:function(){
			if(jReq=="" || jReq==null){
				Msg.info("warning","��ѡ����Ҫ�ܾ������쵥!");
				return;
			}
			var selRecord=dsrqGrid.getSelectionModel().getSelected();
			var status=selRecord.get('status');
			if(status=="C"){
				Msg.info("warning","�õ����Ѵ���, ���ɾܾ�!");
				return;
			}
			Ext.Msg.show({
				title:'�ܾ����쵥',
				msg:'ȷ���ܾ���ǰ���쵥��',
				buttons:Ext.Msg.YESNO,
				icon: Ext.MessageBox.QUESTION,
				fn:RejectInDispReq
			})
		}
	});
	
	function RejectInDispReq(b,txt){
		if(b=="yes"){
			Ext.Ajax.request({
				url:'dhcstm.indispreqaction.csp?actiontype=RejectInDispReq',
				params:{dsrq:jReq},
				success:function(result,request){
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success=='true') {
						Msg.info("success","�ܾ����쵥�ɹ�!");
						IndsRqItmGrid.getStore().removeAll();
						dsrqDs.reload();
					}else{
						if(jsonData.info==-96){
							Msg.info("error","�����쵥�ѷ����Ƶ�,���ɾܾ�!");
						}else{
							Msg.info("error","�ܾ�ʧ��!"+jsonData.info);
						}
					}
				}
			});
		}
	}
	
	var closeB = new Ext.Toolbar.Button({
		iconCls:'page_delete',
		height:30,
		width:70,
		text:'�ر�',
		tooltip:'�ر�',
		handler:function(){
			findWin.close();
		}
	});
	
	var dsrqProxy= new Ext.data.HttpProxy({url:url+'?actiontype=DispReqList',method:'GET'});
	var dsrqDs = new Ext.data.Store({
		proxy:dsrqProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'
		}, [
			{name:'dsrq'},
			{name:'no'},
			{name:'loc'},
			{name:'locDesc'},
			{name:'user'},
			{name:'userName'},
			{name:'reqUserName'},
			{name:'reqGrpDesc'},
			{name:'date'},
			{name:'time'},
			{name:'scg'},
			{name:'scgDesc'},
			{name:'status'},
			{name:'comp'},
			{name:'remark'},
			'loc','locDesc'
		]),
		remoteSort: false,
		listeners:{
			'load':function(ds){
				if (dsrqDs.getCount()>0){
					dsrqGrid.getSelectionModel().selectFirstRow();
					dsrqGrid.getView().focusRow(0);
				}
			}
		}
	});
	
	var dsrqCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{	
			header: 'rowid',
			dataIndex: 'dsrq',
			width: 100,
			hidden:true,
			align: 'left'
		},{
			header: '���쵥��',
			dataIndex: 'no',
			width: 140,
			sortable:true,
			align: 'left'
		},{
			header:'�������',
			dataIndex:'locDesc',
			width:120,
			align:'left'
		},{
			header: "�Ƶ���",
			dataIndex: 'userName',
			width: 100,
			align: 'left',
			sortable: true
		},{
			header: "���쵥����",
			dataIndex: 'date',
			width: 100,
			align: 'left',
			sortable: true
		},{
			header: "���쵥ʱ��",
			dataIndex: 'time',
			width: 100,
			align: 'left',
			sortable: true
		},{
			header:'����',
			width:100,
			dataIndex:'scgDesc'
		},
			{header:'������',dataIndex:'reqUserName'},
			{header:'רҵ��',dataIndex:'reqGrpDesc'},
		{
			header:'���',
			dataIndex:'comp',
			align:'center',
			width:50,
			sortable:true,
			xtype : 'checkcolumn'
		},{
			header: "״̬",
			dataIndex: 'status',
			width: 60,
			align: 'left',
			renderer:function(value){
				var status=value;
				if(value=="C"){
					status="�Ѵ���";
				}else if(value=="O"){
					status="������";
				}else if(value=="X"){
					status="��ȡ��";
				}else if(value=="R"){
					status="�Ѿܾ�";
				}
				return status;
			},
			sortable: true
		},{		 
			header:'��ע',
			dataIndex:'remark',
			width:130,
			align:'left'
		}
	]);
	
	var pagingToolbar3 = new Ext.PagingToolbar({
		store:dsrqDs,
		pageSize:20,
		displayInfo:true
	});

	var dsrqGrid = new Ext.ux.GridPanel({
		id : 'dsrqGrid',
		region:'center',
		store:dsrqDs,
		cm:dsrqCm,
		trackMouseOver: true,
		stripeRows: true,
		split:true,
		sm:new Ext.grid.RowSelectionModel({
			singleSelect:true,
			listeners : {
				'rowselect' : function(sm,rowIndex,rec){
					dsrqitmDs.removeAll();
					currRow=rowIndex;
					jReq = dsrqDs.data.items[rowIndex].data["dsrq"];
					dsrqitmDs.setBaseParam('dsrq',jReq);
					dsrqitmDs.setBaseParam('sort','RowId');
					dsrqitmDs.setBaseParam('dir','desc');
					dsrqitmDs.load({params:{start:0,limit:999}});
				}
			}
		}),
		loadMask: true,
		bbar:pagingToolbar3
	});
	
	var dsrqitmProxy= new Ext.data.HttpProxy({url:url+'?actiontype=SelDispReqItm',method:'GET'});
	var dsrqitmDs = new Ext.data.Store({
		proxy:dsrqitmProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'
		}, [
			{name:'rowid',mapping:'dsrqi'},
			{name:'inci'},
			{name:'code',mapping:'inciCode'},
			{name:'desc',mapping:'inciDesc'},
			{name:'qty'},
			{name:'uom'},
			{name:'uomDesc'},
			{name:'spec'},
			{name:'manf'},
			{name:'remark'},
			{name:'StkQty'},
			{name:'dispMadeQty'},
			{name:'dispedQty'},
			{name:'dispQty'},
			"moveStatus"
		]),
		remoteSort: false
	});
	
	var sm = new Ext.grid.CheckboxSelectionModel({
		checkOnly:true,
		listeners:{
			'rowselect':function(t,ind,rec){
				var reqQty=Number(rec.get('qty'));
				var dispMadeQty=Number(rec.get('dispMadeQty'));
				var leftReqQty=reqQty-dispMadeQty;
				var stkQty=Number(rec.get('StkQty'));
				var dispQty=rec.get('dispQty');
				if(dispQty==""){
					rec.set('dispQty',Math.max(Math.min(leftReqQty,stkQty),0));
				}else{
					rec.set('dispQty',Math.min(stkQty,Number(dispQty)));
				}
			},
			'rowdeselect':function(t,ind,rec){
				rec.set('dispQty','');
			}
		}
	});
	
	var IndsRqDetailCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),sm,
		{
			header: '����',
			dataIndex: 'code',
			width: 72,
			sortable:true,
			align: 'left'
		},{
			header: '����',
			dataIndex: 'desc',
			width: 140,
			sortable:true,
			align: 'left'
		},{
			header:'���',
			dataIndex:'spec',
			align:'left',
			width:80
		},{
			header: "����",
			dataIndex: 'manf',
			width: 80,
			align: 'left',
			sortable: true
		},{
			header: "����",
			dataIndex: 'qty',
			width: 50,
			align: 'right'
		},{
			header: "��λ",
			dataIndex: 'uomDesc',
			width: 72,
			align: 'left'
		},{
			header:'��ע',
			dataIndex:'remark',
			align:'left',
			width:80
		},{
			header:'���',
			dataIndex:'StkQty',
			id:'StkQty',
			align:'right',
			width:80
		},{
			header: "���Ƶ�",
			dataIndex: 'dispMadeQty',
			width: 50,
			align: 'right'
		},{
			header: "�ѷ���",
			dataIndex: 'dispedQty',
			width: 50,
			align: 'right'
		},{
			header:'ȷ�Ϸ�������',
			dataIndex:'dispQty',
			align:'right',
			selectOnFocus:true,
			width:100,
			editor:new Ext.form.NumberField({
				allowNegative : false
			})
		},{
			header : '״̬',
			dataIndex : 'moveStatus',
			align : 'left',
			width : 60,
			renderer : function(value){
				var status="";
				if(value=="G"){
					status="δ����";
				}else if(value=="D"){
					status="�ѷ���";
				}else if(value=="X"){
					status="��ȡ��";
				}else if(value=="R"){
					status="�Ѿܾ�";
				}
				return status;
			}
		}
	]);
	
	var RejectItmBT = new Ext.Toolbar.Button({
		id:'RejectItmBT',
		text:'�ܾ���ϸ',
		tooltip:'�ܾ����쵥��ϸ',
		iconCls:'page_delete',
		width : 70,
		height : 30,
		handler:function(){
			var records = IndsRqItmGrid.getSelectionModel().getSelections();
			if(records == null){
				Msg.info("warning","��ѡ����Ҫ�ܾ�����ϸ!");
				return;
			}
			Ext.Msg.show({
				title:'�ܾ����쵥',
				msg:'ȷ���ܾ���ǰ��ѡ��ϸ?',
				buttons:Ext.Msg.YESNO,
				icon: Ext.MessageBox.QUESTION,
				fn:RejectInDispReqItm
			})
		}
	});
	
	function RejectInDispReqItm(b,txt){
		if(b=="yes"){
			var records = IndsRqItmGrid.getSelectionModel().getSelections();
			Ext.each(records,function(item,index,allItems){
				var dsrqiDesc = item.get('desc');
				var moveStatus = item.get('moveStatus');
				if(moveStatus=="D"){
					Msg.info("warning",dsrqiDesc+"�ѷ��Ŵ���, ���ɾܾ�!");
					return;
				}else if(moveStatus=='R'){
					Msg.info("warning",dsrqiDesc+"�Ѿܾ�, �����ظ�����!");
					return;
				}
				var dsrqi = item.get('rowid');
				var url = 'dhcstm.indispreqaction.csp?actiontype=HandleItm&dsrqi='+dsrqi+'&moveStatus=R';
				var result = ExecuteDBSynAccess(url);
				var jsonData = Ext.util.JSON.decode(result);
				if(jsonData.success=='true'){
					Msg.info("success",dsrqiDesc+"�ܾ��ɹ�!");
					item.set('moveStatus','R');
					item.commit();
				}else{
					var info = jsonData.info;
					if(info==-96){
						Msg.info("warning",dsrqiDesc+"�ѷ����Ƶ�,���ɾܾ�!");
					}else if(info==-95){
						Msg.info("warning","������������,���ɾܾ���ϸ!");
						return false;	//ֹͣ����
					}else if(info==-94){
						Msg.info("warning","�������Ѿܾ�,���ɾܾ���ϸ!");
						return false;	//ֹͣ����
					}else if(info==-93){
						Msg.info("warning",dsrqiDesc+"�ѷ���,���ɾܾ�!");
						return;
					}else if(info==-92){
						Msg.info("warning",dsrqiDesc+"�Ѿܾ�,�����ظ�����!");
						return;
					}else{
						Msg.info("error",dsrqiDesc+"�ܾ�ʧ��:"+jsonData.info);
					}
				}
			});
		}
	}
	
	var IndsRqItmGrid = new Ext.ux.EditorGridPanel({
		id : 'IndsRqItmGrid',
		region:'south',
		height:gGridHeight,
		store:dsrqitmDs,
		cm:IndsRqDetailCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:sm,
		loadMask: true,
		clicksToEdit:1,
		tbar:[RejectItmBT],
		split:true,
		//bbar:pagingToolbar4,		//���ʺ�ʹ�÷�ҳ������
		listeners:{
			afteredit:function(e){
				if(e.field=='dispQty'){
					if(parseFloat(e.value)>parseFloat(e.record.get('StkQty'))){
						e.record.set('dispQty',e.originalValue);
						Msg.info('error','��������������ǰ���!');
					}
				}
			}
		}
	});
	
	var conPanel = new Ext.ux.FormPanel({
		tbar:[fB,'-',startDispButton,'-',RejectBT,'-',closeB],
		bodyStyle:'padding:5px 0 0 0',
		items:[{
			xtype:'fieldset',
			title:'��ѯ����',
			autoHeight:true,
			labelWidth:60,
			layout:'column',
			items:[
				{columnWidth:.25,layout:'form',items:[startDate,endDate]},
				{columnWidth:.3,layout:'form',items:[LoadINDSToLoc,UserGrpX]},
				{columnWidth:.15,layout:'form',items:[NotDisp,chkStatus]},
				{columnWidth:.15,layout:'form',items:[PartlyDisp]},
				{columnWidth:.15,layout:'form',items:[AllDisp]}
			]
		}]
	});
	
	var findWin = new Ext.Window({
		title:'�����Ƶ�--�������쵥',
		width:gWinWidth,	
		height:gWinHeight,
		layout:'border',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items : [conPanel, dsrqGrid, IndsRqItmGrid],
		listeners:{
			'afterrender':function(){
				if (fB) {fB.handler();}
			}
		}
	});

	//��ʾ����
	findWin.show();
	
}
