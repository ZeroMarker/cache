// /����: ���ҹ���ά��
// /����: ���ҹ���ά��
// /��д�ߣ�caoting
// /��д����: 2014.04.24
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParam='';	
	var groupId=session['LOGON.GROUPID'];
	var gLocId=null;
	var gLocManId=null;
	var gLocCode=null;
	
			
	// ��ѯ��ť
	var SearchBT = new Ext.Toolbar.Button({
				text : '��ѯ',
				tooltip : '�����ѯ',
				iconCls : 'page_find',
				width : 70,
				height : 30,
				handler : function() {
					Query();
				}
			});
    function GetLocList(record) {
		if (record == null || record == "") {
			return false;
		}
		RowId = record.get("RowId");
		var cell = RecLocGrid.getSelectionModel().getSelectedCell();
		// ѡ����
		var row = cell[0];
		var rowData = RecLocGrid.getStore().getAt(row);
		if (gLocCode==record.get("Code"))
		{
			Msg.info("warning","�����빩��������ͬ!");
			rowData.set("RowId","");
			rowData.set("Code","");
			
			return false;
		} 
		rowData.set("RowId",RowId);
		rowData.set("Code",record.get("Code"));
		rowData.set("Desc",record.get("Desc"));
    }
		/**
		 * ��ѯ����
		 */
		function Query() {
			// ��ѡ����
			var Code = Ext.getCmp("LocCode").getValue();
			var Desc = Ext.getCmp("LocDesc").getValue();
			
			
			ProLocGrid.store.removeAll();
			RecLocGrid.store.removeAll();
			InciDetailGrid.store.removeAll();
		
			gStrParam=Code+"^"+Desc;
			var PageSize=LocPagingToolbar.pageSize;
			LocStore.load({
				params:{
					start:0,
					limit:PageSize,
					StrParam:gStrParam,
					GroupId:groupId
				}});

		}
		
		// ��հ�ť
		var RefreshBT = new Ext.Toolbar.Button({
					text : '���',
					tooltip : '������',
					iconCls : 'page_clearscreen',
					width : 70,
					height : 30,
					handler : function() {
						clearData();
					}
				});

		/**
		 * ��շ���
		 */
		function clearData() {
			gStrParam='';	
			Ext.getCmp("LocCode").setValue('');
			Ext.getCmp("LocDesc").setValue('');
		
			ProLocGrid.store.removeAll();
			RecLocGrid.store.removeAll();
			InciDetailGrid.store.removeAll();
			ProLocGrid.store.reload();
			//ProLocGrid.getView().refresh();
		}
		
		//�½�
		var AddBT=new Ext.Toolbar.Button({
			id:'AddBT',
			text:'����',
			tooltip:'�������',
			width:70,
			height:30,
			iconCls:'page_add',
			handler:function(){
				
				if(gLocId==null || gLocId.length<1){
					Msg.info("warning","����ѡ�񹩸�����!");
					return;
				}
				
				AddNewRow();
			}
		});
		
		function AddNewRow(){
			var record=Ext.data.Record.create([{name:'Rowid'},{name:'Code'},{name:'Desc'}]);
			var newRecord=new Ext.data.Record({
				Rowid:'',
				Code:'',
				Desc:'',
				Type:'R'
			});
			
			RecLocStore.add(newRecord);
			var lastRow=RecLocStore.getCount()-1;
			RecLocGrid.startEditing(lastRow,3);
		}
		// ���水ť
		var SaveBT = new Ext.Toolbar.Button({
					id : "SaveBT",
					text : '����',
					tooltip : '�������',
					width : 70,
					height : 30,
					iconCls : 'page_save',
					handler : function() {

						// ������ҿ�������Ϣ					
						save();						
					}
				});
		function save(){
			if(gLocId==null || gLocId.length<1){
				Msg.info("warning","���Ҳ���Ϊ��!")
				return;
			}
			var ListDetail="";
			var rowCount = RecLocGrid.getStore().getCount();
			
			for (var i = 0; i < rowCount; i++) {
				var rowData = RecLocStore.getAt(i);	
				//���������ݷ����仯ʱִ����������
				if(rowData.data.newRecord || rowData.dirty){
					var RelRowid = rowData.get("RelRowId");
					if (RelRowid==undefined){RelRowid=""}
					var Rowid=rowData.get("RowId");
					var Code = rowData.get("Code").trim();
					var Desc=rowData.get("Desc").trim();
					var Type=rowData.get("Type").trim();
					if (Type==""){var Type="R"}
					if(Code!="" && Desc!=""){
						var str = Rowid + "^" + Code+"^"+Desc+"^"+Type+"^"+RelRowid;	
						if(ListDetail==""){
							ListDetail=str;
						}
						else{
							ListDetail=ListDetail+xRowDelim()+str;
						}
					}
				}
			}
			if(ListDetail==""){
				Msg.info("warning","û���޸Ļ����������!");
				return false;
			}
			var url = DictUrl
					+ "locrelaction.csp?actiontype=Save";
			var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
			Ext.Ajax.request({
						url : url,
						params: {LocId:gLocId,Detail:ListDetail},
						method : 'POST',
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
						    mask.hide();
							if (jsonData.success == 'true') {
								 
								Msg.info("success", "����ɹ�!");
								// ˢ�½���
								RecLocStore.load({params:{LocId:gLocId}});

							} else {
								var ret=jsonData.info;
								if(ret==-1){
									Msg.info("error", "û����Ҫ���������!");
								}else {
									var errMsg=ret;
									if (errMsg.indexOf(":")>=0){
										errMsg=errMsg.split(":")[1];
									}
									Msg.info("error", "������ϸ���治�ɹ�"+errMsg);
								}
								
							}
						},
						scope : this
					});

		}
	
	var DeleteBT=new Ext.Toolbar.Button({
		id:'DeleteBT',
		text:'ɾ��',
		width:'70',
		height:'30',
		tooltip:'���ɾ��',
		iconCls:'page_delete',
		handler: function(){
			Delete();
		}
	});
	
	function Delete(){
		var cell=RecLocGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","��ѡ��Ҫɾ���ļ�¼��");
			return;
		}
		var row=cell[0];
		var record=RecLocStore.getAt(row);
		var rowid=record.get("RelRowId");
		if(rowid==null || rowid.length<1){
			Msg.info("warning","��ѡ��¼��δ���棬����ɾ��!");
			return;
		}else {
				Ext.MessageBox.show({
							title : '��ʾ',
							msg : '�Ƿ�ȷ��ɾ���ÿ��ҹ�����Ϣ',
							buttons : Ext.MessageBox.YESNO,
							fn : showResult,
							icon : Ext.MessageBox.QUESTION
						});

		}
		
		function showResult(btn) {
			if (btn == "yes") {
				var url = DictUrl+"locrelaction.csp?actiontype=Delete";
				var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
				Ext.Ajax.request({
					url:url,
					method:'POST',
					waitMsg:'������...',
					params:{Rowid:rowid},
					success: function(response,opts){			 
						var jsonData=Ext.util.JSON.decode(response.responseText);
						mask.hide();
						if (jsonData.success=='true'){
							Msg.info("success","ɾ���ɹ�!");
							RecLocStore.load({params:{LocId:gLocId}});
							InciDetailStore.removeAll();
							InciDetailStore.load({params:{ProLoc:gLocId,RecLoc:gLocManId}});
						}else {
							Msg.info("error","ɾ��ʧ��!");
						}
			
					}
				});
			}
		}}
	//��������Դ
	var locUrl =DictUrl+'locmangrpaction.csp?actiontype=QueryLoc';
	var LocGridProxy= new Ext.data.HttpProxy({url:locUrl,method:'POST'});
	var LocStore = new Ext.data.Store({
		proxy:LocGridProxy,
	    reader:new Ext.data.JsonReader({
			totalProperty:'results',
	        root:'rows'
	    }, [
			{name:'Rowid'},
			{name:'Code'},
			{name:'Desc'}
		]),
	    remoteSort:true
	});
	
	//ģ��
	var LocGridCm = new Ext.grid.ColumnModel([
		 new Ext.grid.RowNumberer(),
		 {
	        header:"����",
	        dataIndex:'Code',
	        width:100,
	        align:'left',
	        sortable:true,
	        hidden:true
	    },{
	        header:"����",
	        dataIndex:'Desc',
	        width:250,
	        align:'left',
	        sortable:true
	    }
	]);
	//��ʼ��Ĭ��������
	LocGridCm.defaultSortable = true;
	var LocPagingToolbar = new Ext.PagingToolbar({
	    store:LocStore,
		pageSize:PageSize,
	    displayInfo:true,
	    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
	    emptyMsg:"û�м�¼",
		doLoad:function(C){
			var B={},
			A=this.getParams();
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B[A.sort]='Rowid';
			B[A.dir]='desc';
			B['StrParam']=gStrParam;
			B['GroupId']=groupId;
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});
	
	var LocCode=new Ext.form.TextField({
		id:'LocCode',
		name:'LocCode',
		width:100,
		hidden:true
	});
	
	var LocDesc=new Ext.form.TextField({
		id:'LocDesc',
		name:'LocDesc',
		width:100
	});
	
	//���
	ProLocGrid = new Ext.grid.GridPanel({
		region:'west',
		title:'��������',
		store:LocStore,
		cm:LocGridCm,
		trackMouseOver:true,
		width:420,
		height:300,
		stripeRows:true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask:true,
		bbar:LocPagingToolbar,
		tbar:[LocCode,'����:',LocDesc,'-',SearchBT,'-',RefreshBT]
	});

	ProLocGrid.addListener("rowclick",function(grid,rowindex,e){
		//LocUserManGrpGridDs.removeAll(); //�����Ա���
		var selectRow=LocStore.getAt(rowindex);
		gLocId=selectRow.get("Rowid");
		gLocCode=selectRow.get("Code");
		RecLocStore.load({params:{LocId:gLocId}});
		InciDetailStore.removeAll();
	});
		var RecLocTypeStore = new Ext.data.SimpleStore({
				fields : ['RowId', 'Description'],
				data : [['R', '���¼�'], ['T', 'ͬ��']]
			});
		var nm = new Ext.grid.RowNumberer();
		var RecLocCm = new Ext.grid.ColumnModel([nm, {
					header : "RelRowId",
					dataIndex : 'RelRowId',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				},  {
					header : "RowId",
					dataIndex : 'RowId',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '����',
					dataIndex : 'Code',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "����",
					dataIndex : 'Desc',
					width : 225,
					align : 'left',
					sortable : true,
					editor:new Ext.form.TextField({
			         id:'descField',
                    allowBlank:false,
			        listeners:{
				       specialKey:function(field, e) {
					   if (e.getKey() == Ext.EventObject.ENTER) {
						  GetLocInfoWindow(Ext.getCmp('descField').getValue(),GetLocList);
					}
				}
			}
        })
			},{
					header : "����",
					dataIndex : 'Type',
					width : 90,
					align : 'left',
					sortable : true,
			        renderer:function(v, p, record){
			            if(v=="R")
			                return "���¼�";
			            if(v=="T")
			                return "ͬ��";
			        },
			        editor: new Ext.form.ComboBox({
			            id:'RecLocTypeField',
			            width:200,
			            listWidth:200,
			            allowBlank:true,
			            store:RecLocTypeStore,
			            value:'R', // Ĭ��ֵ"ͬ��ҩ��"
			            valueField:'RowId',
			            displayField:'Description',
			            emptyText:'',
			            triggerAction:'all',
			            emptyText:'',
			            minChars:1,
			            mode:'local',
			            selectOnFocus:true,
			            forceSelection:true,
			            editable:true
			        })

				}
					]);
		RecLocCm.defaultSortable = true;

		// ����·��
		var LocRelUrl = DictUrl
					+ 'locrelaction.csp?actiontype=Query&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : LocRelUrl,
					method : "POST"
				});
		// ָ���в���
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "RowId",
					fields : ["RowId","Code","Desc","RelRowId","Type"]
				});
		// ���ݼ�
		var RecLocStore = new Ext.data.Store({
					pruneModifiedRecords:true,
					proxy : proxy,
					reader : reader
				});
		var RecLocGrid = new Ext.grid.EditorGridPanel({
			        region:'center',
					title:'���տ���<Ĭ��ά��Ϊ���¼�>',
					id:'RecLocGrid',
					cm : RecLocCm,
					store : RecLocStore,
					trackMouseOver : true,
					stripeRows : true,
					width:330,  //add by myq 20141104
					height:300,
					sm : new Ext.grid.CellSelectionModel({}),
					clicksToEdit : 1,
					tbar:[AddBT,'-',SaveBT,'-',DeleteBT],
					loadMask : true
				});

		RecLocGrid.addListener("rowclick",function(grid,rowindex,e){
			var selectRow=RecLocStore.getAt(rowindex);  // 20141104 myq  �ſ�ע��
			gLocManId=selectRow.get("RowId");   // 20141104 myq  �ſ�ע��
			//QueryLocUserManGrp();
			//alert("gLocId:"+gLocId+"gLocManId:"+gLocManId)
			InciDetailStore.load({params:{ProLoc:gLocId,RecLoc:gLocManId}});  // add by myq 20141104
		});
		
		
		//---------------------add by myq 20141104 ����������ҩƷ��ά��
		/*  */
		
		var nm = new Ext.grid.RowNumberer();
		var InciDetailCm = new Ext.grid.ColumnModel([nm, {
					header : "LreliRowid",
					dataIndex : 'LreliRowid',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : 'Inci',
					dataIndex : 'Inci',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
					
				}, {
					header : 'ҩƷ����',
					dataIndex : 'InciCode',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : false
					
				}, {
					header : "ҩƷ����",
					dataIndex : 'InciDesc',
					width : 200,
					align : 'left',
					sortable : true,
					editor : new Ext.grid.GridEditor(new Ext.form.TextField({
								selectOnFocus : true,
								allowBlank : false,
								listeners : {
									
									specialkey : function(field, e) {
									
										if (e.getKey() == Ext.EventObject.ENTER) {
											//var group = Ext.getCmp("StkGrpType").getValue();
											GetPhaOrderInfo(field.getValue(),"");
										}
									}
								}	
							})	 
						)
			}
					]);
		InciDetailCm.defaultSortable = true;
		
		// ����·��
		var InciDetailUrl = DictUrl
					+ 'locrelaction.csp?actiontype=QueryInciDetail&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : InciDetailUrl,
					method : "POST"
				});
		// ָ���в���
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "LreliRowid",
					fields : ["LreliRowid","Inci","InciCode","InciDesc"]
				});
		// ���ݼ�
		var InciDetailStore = new Ext.data.Store({
					pruneModifiedRecords:true,
					proxy : proxy,
					reader : reader
				});
	
	/**
		 * ����ҩƷ���岢���ؽ��
		 */
		function GetPhaOrderInfo(item, group) {
						
			if (item != null && item.length > 0) {
				
				GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",getDrugList);
			}
		}
		
       function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			var inciDr = record.get("InciDr");
			var inciCode=record.get("InciCode");
			var TRinciCode=record.get("TRInciCode");
			var inciDesc=record.get("InciDesc");
			var cell = InciDetailGrid.getSelectionModel().getSelectedCell();
			// ѡ����
			var row = cell[0];
			var rowData = InciDetailGrid.getStore().getAt(row);
			rowData.set("Inci",inciDr);
			rowData.set("InciCode",inciCode);
			rowData.set("InciDesc",inciDesc);
			AddNewInciRow();	
       }
       
	//�½�
		var AddInciBT=new Ext.Toolbar.Button({
			id:'AddInciBT',
			text:'����',
			tooltip:'�������',
			width:70,
			height:30,
			iconCls:'page_add',
			handler:function(){
			     if(gLocManId==null || gLocManId.length<1){
					Msg.info("warning","����ѡ����տ���!");
					return;
				}
				AddNewInciRow();
			}
		});
		
		function AddNewInciRow(){
			var record=Ext.data.Record.create([{name:'LreliRowid'},{name:'Inci'},{name:'InciCode'},{name:'InciDesc'}]);
			var newRecord=new Ext.data.Record({
				LreliRowid:'',
				Inci:'',
				InciCode:'',
				InciDesc:''
			});
			
			InciDetailStore.add(newRecord);
			var lastRow=InciDetailStore.getCount()-1;
			var newcolIndex=GetColIndex(InciDetailGrid,'InciDesc');
			InciDetailGrid.startEditing(lastRow,newcolIndex);
		}
		// ���水ť
		var SaveInciBT = new Ext.Toolbar.Button({
					id : "SaveInciBT",
					text : '����',
					tooltip : '�������',
					width : 70,
					height : 30,
					iconCls : 'page_save',
					handler : function() {

						// �����������ҩƷ					
						saveinci();						
					}
				});
   function saveinci(){
	    
	    if(gLocId==null || gLocId.length<1){
				Msg.info("warning","�������Ҳ���Ϊ��!")
				return;
			}
			
		if(gLocManId==null || gLocManId.length<1){
				Msg.info("warning","���տ��Ҳ���Ϊ��!")
				return;
			}
				
	  var ListDetail="";
			var rowCount = InciDetailGrid.getStore().getCount();
			
			for (var i = 0; i < rowCount; i++) {
				var rowData = InciDetailStore.getAt(i);	
				//���������ݷ����仯ʱִ����������
				if(rowData.data.newRecord || rowData.dirty){
					var LreliRowid = rowData.get("LreliRowid");
					var Inci = rowData.get("Inci");
					var InciCode = rowData.get("InciCode").trim();
					var InciDesc=rowData.get("InciDesc").trim();

					if(InciCode!="" && InciDesc!=""){
						var str = LreliRowid +"^"+Inci + "^" + InciCode+"^"+InciDesc;	
						if(ListDetail==""){
							ListDetail=str;
						}
						else{
							ListDetail=ListDetail+xRowDelim()+str;
						}
					}
				}
			}
			if(ListDetail==""){
				Msg.info("warning","û���޸Ļ����������!");
				return false;
			}
			var url = DictUrl
					+ "locrelaction.csp?actiontype=SaveInci";
			var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
			Ext.Ajax.request({
						url : url,
						params: {ProLoc:gLocId,RecLoc:gLocManId,Detail:ListDetail},
						method : 'POST',
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
						    mask.hide();
							if (jsonData.success == 'true') {
								 
								Msg.info("success", "����ɹ�!");
								// ˢ�½���
								InciDetailStore.load({params:{ProLoc:gLocId,RecLoc:gLocManId}});

							} else {
								var ret=jsonData.info;
								if(ret==-1){
									Msg.info("error", "û����Ҫ���������!");
								}
								else if(ret==-2){
									Msg.info("error", "�����ظ����ҩƷ!");
								}else {
									Msg.info("error", "������ϸ���治�ɹ���"+ret);
								}
								
							}
						},
						scope : this
					});
			

		}
	
	var DeleteInciBT=new Ext.Toolbar.Button({
		id:'DeleteInciBT',
		text:'ɾ��',
		width:'70',
		height:'30',
		tooltip:'���ɾ��',
		iconCls:'page_delete',
		handler: function(){
			DeleteInci();
		}
	});
  
  function DeleteInci(){
			var cell=InciDetailGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","��ѡ��Ҫɾ���ļ�¼��");
			return;
		}
		var row=cell[0];
		var record=InciDetailStore.getAt(row);
		var LreliRowid=record.get("LreliRowid");
		if(LreliRowid==null || LreliRowid.length<1){
			Msg.info("warning","��ѡ��¼��δ���棬����ɾ��!");
			return;
		}else {
				Ext.MessageBox.show({
							title : '��ʾ',
							msg : '�Ƿ�ȷ��ɾ����ҩƷ��Ϣ',
							buttons : Ext.MessageBox.YESNO,
							fn : showResult,
							icon : Ext.MessageBox.QUESTION
						});

			}
		
		function showResult(btn) {
			if (btn == "yes") {
		var url = DictUrl	+ "locrelaction.csp?actiontype=DeleteInci";
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
			url:url,
			method:'post',
			waitMsg:'������...',
			params:{Rowid:LreliRowid},
			success: function(response,opts){	
		 
				var jsonData=Ext.util.JSON.decode(response.responseText);
				  mask.hide();
				if (jsonData.success=='true'){
					Msg.info("success","ɾ���ɹ�!");
					InciDetailStore.load({params:{ProLoc:gLocId,RecLoc:gLocManId}});
				}else {
					Msg.info("error","ɾ��ʧ��!");
				}
			
			}
		});
		
	}}

		}
  
		
		var InciDetailGrid = new Ext.grid.EditorGridPanel({
			        region:'east',
					title:'����ҩƷ',
					id:'InciDetailGrid',
					cm : InciDetailCm ,
					store : InciDetailStore,
					trackMouseOver : true,
					stripeRows : true,
					width:350,
					height:300,
					sm : new Ext.grid.CellSelectionModel({}),
					clicksToEdit : 1,
					tbar:[AddInciBT,'-',SaveInciBT,'-',DeleteInciBT],
					loadMask : true
				});
     

      //---------------------add by myq 20141104 ����������ҩƷ��ά��

        //���ñ༭��
		var ActiveField = new Ext.grid.CheckColumn({
			header:'�Ƿ���Ч',
			dataIndex:'Active',
			width:100,
			sortable:true,
			renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
		});

        //����
		var AddLocUserManGrp = new Ext.Toolbar.Button({
			text:'�½�',
			tooltip:'�½�',
			iconCls:'page_add',
			width : 70,
			height : 30,
			handler:function(){
				AddLocUserNewRow();
			}
		});

��������//������Ա
		var SaveLocUserManGrp = new Ext.Toolbar.Button({
			text:'����',
			tooltip:'����',
			width : 70,
			height : 30,
			iconCls:'page_save',
			handler:function(){

				SaveLocUserMan();
			}
		});

��������//��Ա����
		var UStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
				url:'dhcst.orgutil.csp?actiontype=StkLocUserCatGrp'
			}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Description', 'RowId'])
		});

		var UCG = new Ext.form.ComboBox({
			fieldLabel : '����',
			id : 'UCG',
			name : 'UCG',
			anchor : '90%',
			width : 120,
			store : UStore,
			valueField : 'RowId',
			displayField : 'Description',
			allowBlank : false,
			triggerAction : 'all',
			emptyText : '����...',
			selectOnFocus : true,
			forceSelection : true,
			minChars : 1,
			pageSize : 10,
			listWidth : 250,
			valueNotFoundText : '',
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						//addNewRow();
					}
				}
			}
		});

		UCG.on('beforequery', function(e) {
		UStore.removeAll();
		UStore.setBaseParam('name',Ext.getCmp('UCG').getRawValue());
		UStore.setBaseParam('locId',gLocId);
		var pageSize=Ext.getCmp("UCG").pageSize;
		UStore.load({params:{start:0,limit:pageSize}});
	  });

		//��������Դ
		//����·��
		var gridUrl = DictUrl
					+ 'locmangrpaction.csp?actiontype=QueryLocUserMan&start=0&limit=200';
		var LocUserManGrpGridProxy= new Ext.data.HttpProxy({url:gridUrl,method:'GET'});
		var LocUserManGrpGridDs = new Ext.data.Store({
			proxy:LocUserManGrpGridProxy,
			reader:new Ext.data.JsonReader({
				root:'rows'
			}, [
				{name:'Rowid'},
				{name:'UserId'},
				{name:'Code'},
				{name:'Name'},
				{name:'Active'}
			]),
			pruneModifiedRecords:true,
			remoteSort:false
		});

		//ģ��
		var LocUserManGrpGridCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),{
				header:"Rowid",
				dataIndex:'Rowid',
				width:200,
				align:'left',
				sortable:true,
				hidden:true
			},{
				header:"����",
				dataIndex:'Code',
				width:200,
				align:'left',
				sortable:true
			},{
				header:"����",
				dataIndex:'UserId',
				width:200,
				align:'left',
				sortable:true,
				renderer:��Ext.util.Format.comboRenderer2(UCG,"UserId","Name"),
				editor:new Ext.grid.GridEditor(UCG)
			},ActiveField
		]);

		 

		//��ʼ��Ĭ��������
		LocUserManGrpGridCm.defaultSortable = true;

		var LocUserManGrpGridPagingToolbar = new Ext.PagingToolbar({
		store:LocUserManGrpGridDs,
		pageSize:30,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼",
		doLoad:function(C){
			var B={},
			A=this.getParams();
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B[A.sort]='Rowid';
			B[A.dir]='desc';
			B['locGrpId']=LocGrpId;
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
				}
			}
		});

		//���˷�����
		LocUserManGrpGrid = new Ext.grid.EditorGridPanel({
			store:LocUserManGrpGridDs,
			cm:LocUserManGrpGridCm,
			trackMouseOver:true,
			height:370,
			plugins:[ActiveField],
			stripeRows:true,
			//sm:new Ext.grid.CellSelectionModel({}),
			sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask:true,
			clicksToEdit:2,
			tbar:[AddLocUserManGrp,'-',SaveLocUserManGrp],
			bbar:LocUserManGrpGridPagingToolbar
		});
		LocUserManGrpGrid.on('beforeedit',function(e){
			if(e.field=="UserId"){
				//addComboData(UCG.getStore(),e.record.get("UserId"),e.record.get("Name"));
			}
		})
		
		var LocUserManGroupPanel = new Ext.Panel({
			region:'south',
			deferredRender : true,
			title:'��Աά��',
			activeTab: 0,
			height:300,
			layout:'fit',
			split:true,
			collapsible:true,
			items:[LocUserManGrpGrid]                                 
		});

		var HospPanel = InitHospCombo('PHA-IN-LocRequest',function(combo, record, index){
			HospId = this.value; 
			Query();
			RecLocStore.removeAll();
			RecLocStore.load({params:{ProLoc:gLocId,RecLoc:gLocManId}});
			InciDetailStore.removeAll();
			InciDetailStore.load({params:{ProLoc:gLocId,RecLoc:gLocManId}});
			
		});


		// 5.2.ҳ�沼��
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [ HospPanel,ProLocGrid, RecLocGrid, InciDetailGrid ]  ,       // create instance immediately
					renderTo : 'mainPanel'
				});
	    //-----------------------------Events----------------------//
	    Query();

        //������
		function AddLocUserNewRow(){

			if(gLocId==null || gLocId.length<1){
				Msg.info("warning","����ѡ�����!");
				return;
			}

			if(gLocManId==null || gLocManId.length<1){
				Msg.info("warning","����ѡ�������!");
				return;
			}


			var record = Ext.data.Record.create([
				{
					name : 'Rowid',
					type : 'int'
				},{
					name : 'UserId',
					type : 'int'
				}, {
					name : 'Code',
					type : 'string'
				}, {
					name : 'Name',
					type : 'string'
				}, {
					name : 'Active',
					type : 'string'
				}
			]);
							
			var rec = new record({
				Rowid:'',
				UserId:'',
				Code:'',
				Name:'',
				Default:'Y',
				Active:'Y'
			});
			LocUserManGrpGridDs.add(rec);
			LocUserManGrpGrid.startEditing(LocUserManGrpGridDs.getCount() - 1, 2);

		}



     //������Ա������
     function SaveLocUserMan()
	 {
		    //��ȡ���е��¼�¼
			var mr=LocUserManGrpGridDs.getModifiedRecords();
			var data="";
			var nameflag="";
			for(var i=0;i<mr.length;i++){
				var RowId = mr[i].data["Rowid"];
				var userId = mr[i].data["UserId"];
				var active = mr[i].data["Active"];
				var name = mr[i].data["Name"];

				if(RowId!=""){
					var dataRow = RowId+"^"+userId+"^"+active+"^"+name;
					if(data==""){
						data = dataRow;
						nameflag=nameflag+userId
					}else{
						data = data+xRowDelim()+dataRow;
						nameflag=nameflag+userId
					}
				}else{
					var dataRow = "^"+userId+"^"+active+"^"+name;
					if(data==""){
						data = dataRow;
						nameflag=nameflag+userId
					}else{
						data = data+xRowDelim()+dataRow;
						nameflag=nameflag+userId
					}
				}
			}
			
			if(nameflag==""){	Msg.info("error","û����Ҫ���������!");	return false;;}
			
			if(data!=""){
				Ext.Ajax.request({
					url: DictUrl+'locmangrpaction.csp?actiontype=SaveLocUserMan',
					params: {Detail:data,locGrpId:gLocManId},
					failure: function(result, request) {
						Msg.info("error", "������������!");
					},
					success: function(result, request) {
						data="";
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Msg.info("success", "����ɹ�!");
							QueryLocUserManGrp();
						}else{
							var info=jsonData.info
							var infoarr=info.split(",");
							var infovalue=infoarr[0];
							var infodesc=infoarr[1];
							if(infovalue==-99){
								Msg.info("error","��Ա�����ظ�����!"+infodesc);
							}else{
								Msg.info("error", "����ʧ��"+infodesc);
							}
						}

						
					},
					scope: this
				});
			}
       
	 }

    //ˢ�±��
	function QueryLocUserManGrp()
	{   
		LocUserManGrpGridDs.removeAll();
		LocUserManGrpGridDs.load({params:{locGrpId:gLocManId}});
	}


})