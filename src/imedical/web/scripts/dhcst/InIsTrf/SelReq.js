// /����: ����ת�������Ƶ�
// /����: ����ת�������Ƶ�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.10.12
// /yunhaibao20151229,���HideFlag,Ĭ�ϼ��ش˽���ʱ,����޿��������Զ��ر�
var SelReq=function(SupplyLocId,Fn,HideFlag) {
	if(HideFlag==undefined){HideFlag=""}
	var userId = session['LOGON.USERID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	// ������
	var RequestPhaLocS = new Ext.ux.LocComboBox({
		fieldLabel : $g('������'),
		id : 'RequestPhaLocS',
		name : 'RequestPhaLocS',
		emptyText:$g('������'),
		anchor : '90%',
		width : 120,
		defaultLoc:{}
	}); 
	
	// ��ʼ����
	var StartDateS = new Ext.ux.DateField({
				fieldLabel : $g('��ʼ����'),
				id : 'StartDateS',
				name : 'StartDate',
				anchor : '90%',
				width : 120,
				value : DefaultStDate()
			});
	// ��ֹ����
	var EndDateS = new Ext.ux.DateField({
				fieldLabel : $g('��ֹ����'),
				id : 'EndDateS',
				name : 'EndDate',
				anchor : '90%',
				width : 120,
				value : DefaultEdDate()
			});
	
	// ��������ת��
	var PartlyStatusS = new Ext.form.Checkbox({
				boxLabel : $g('��������ת��'),
				id : 'PartlyStatusS',
				name : 'PartlyStatus',
				anchor : '90%',
				checked : false,
				disabled : false
			});
	
	// ��ʾ�����ת�Ƶ�������ϸ
	var ShowTransfered = new Ext.form.Checkbox({
				boxLabel : $g('��ʾת�����ҩƷ'),
				id : 'ShowTransfered',
				name : 'ShowTransfered',
				anchor : '90%',
				checked : false,
				disabled : false
			});
			
	var ReqStatus = new Ext.ux.form.LovCombo({
		id : 'ReqStatus',
		name : 'ReqStatus',
		fieldLabel : $g('����״̬'),
		//listWidth : 400,
		anchor: '90%',
		//labelStyle : "text-align:right;width:100;",
		labelSeparator : '',
		separator:',',	
		hideOnSelect : false,
		maxHeight : 300,
		editable:false,
		store : GetReqStatusStore ,
		valueField : 'RowId',
		displayField : 'Description',
		triggerAction : 'all'
	});
				
		// ȫѡ
		var AllBT = new Ext.form.Checkbox({
					boxLabel : $g('����ȫѡ'),
					id : 'AllBT',
					name : 'AllBT',
					anchor : '90%',
					checked : false,
					handler : function() {
						AllBTSel();
					}
				});
		function AllBTSel(){
			var AllValue=Ext.getCmp("AllBT").getValue();
			var rowCount = DetailGridS.getStore().getCount();
			if (AllValue==true){
			    for (var i = 0; i < rowCount; i++) {
				  DetailStore.getAt(i).set("cancel",1);
				}  
			     }
			if (AllValue==false){
			    for (var i = 0; i < rowCount; i++) {
				   DetailStore.getAt(i).set("cancel",0);
			}
		}
	    
      /*function AllBTSel(){
	   var AllValue=Ext.getCmp("AllBT").getValue();
	   var rowCount = DetailGridS.getStore().getCount();
	   var reqItmString="";
	   if (AllValue==true){
		    for (var i = 0; i < rowCount; i++) {
			  DetailStore.getAt(i).set("cancel",1);
			  if (reqItmString==""){
				 reqItmString=DetailStore.getAt(i).get("rowid");
			  }else{
			  	 reqItmString=reqItmString+"^"+DetailStore.getAt(i).get("rowid");
			  }
			}
			CancelDetailsAction(reqItmString,"Y"); 
		}
	   if (AllValue==false){
		    for (var i = 0; i < rowCount; i++) {
			   DetailStore.getAt(i).set("cancel",0);
			   if (reqItmString==""){
				 reqItmString=DetailStore.getAt(i).get("rowid");
			   }else{
			  	 reqItmString=reqItmString+"^"+DetailStore.getAt(i).get("rowid");
			   }
			}
			CancelDetailsAction(reqItmString,"N"); 
		 }*/
	  }
	
	// 3�رհ�ť
	var closeBTS = new Ext.Toolbar.Button({
				text : $g('�ر�'),
				tooltip :$g( '�رս���'),
				iconCls : 'page_delete',
				width : 70,
				height : 30,
				handler : function() {
					findWin.close();
				}
			});
			
	// ��ѯ���󵥰�ť
	var SearchBTS = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : $g('��ѯ'),
				tooltip : $g('�����ѯ����'),
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					HideFlag="";
					Query();
				}
			});


	// ��հ�ť
	var ClearBTS = new Ext.Toolbar.Button({
				id : "ClearBTSR",
				text : $g('����'),
				tooltip :$g( '�������'),
				width : 70,
				height : 30,
				iconCls : 'page_clearscreen',
				handler : function() {
					clearData();
				}
			});
	/**
	 * ��շ���
	 */
	function clearData() {
		Ext.getCmp("RequestPhaLocS").setValue("");
		Ext.getCmp("StartDateS").setValue(DefaultStDate());
		Ext.getCmp("EndDateS").setValue(DefaultEdDate());
		Ext.getCmp("PartlyStatusS").setValue(false);
		Ext.getCmp("ShowTransfered").setValue(false);
		Ext.getCmp("ReqStatus").setValue("");
		MasterGridS.store.removeAll();
		MasterGridS.getView().refresh();
		DetailGridS.store.removeAll();
		DetailGridS.getView().refresh();		
	}

	// ���水ť
	var SaveBTS = new Ext.Toolbar.Button({
				id : "SaveBTS",
				text : $g('ѡȡ'),
				tooltip : $g('ѡȡ'),
				width : 70,
				height : 30,
				iconCls : 'page_goto',
				handler : function() {

					// ����ת�Ƶ�
					if(CheckDataBeforeSave()==true){
						save();
					}
				}
			});
			
	/**
	 * ������ⵥǰ���ݼ��
	 */		
	function CheckDataBeforeSave() {
				
		var requestphaLoc = Ext.getCmp("RequestPhaLocS")
				.getValue();
		if (requestphaLoc == null || requestphaLoc.length <= 0) {
			Msg.info("warning", $g("��ѡ��������!"));
			return false;
		}
		
		if (SupplyLocId == null || SupplyLocId.length <= 0) {
			Msg.info("warning", $g("��رմ��ڣ�ѡ��Ӧ����!"));
			return false;
		}
		if (requestphaLoc == SupplyLocId) {
			Msg.info("warning", $g("�����ź͹�Ӧ���Ų�����ͬ!"));
			return false;
		}
		var selectRow=MasterGridS.getSelectionModel().getSelected();
		if(selectRow==null){
			Msg.info("warning", $g("��ѡ��Ҫ���������!"));
			return false;
		}
		return true;
	}
	

	/**
	 * ����ת�Ƶ�
	 */
	function save() {
		//��Ӧ����RowId^�������RowId^�Ƶ���RowId
		var InitRowid="";
		var supplyPhaLoc =SupplyLocId;
		var requestPhaLoc = Ext.getCmp("RequestPhaLocS").getValue();
		var selectRow=MasterGridS.getSelectionModel().getSelected();
		var reqid=selectRow.get("req");
		if(reqid==null || reqid==""){
			Msg.info("warning",$g("��ѡ��Ҫ���������!"));
			return;
		}
		if (DetailStore.getCount()<1)
		{
			Msg.info("warning",$g("û����Ҫת�Ƶ���ϸ����!"))
			return;
		}
		var mask=ShowLoadMask('findWin',$g("�������ɳ��ⵥ..."));
		var MainInfo = supplyPhaLoc + "^" + requestPhaLoc + "^" + userId ;		
		var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=CreateTransferByReq&MainInfo=" + MainInfo+"&ReqId="+reqid;
		var responsetext=ExecuteDBSynAccess(url);
		var jsonData = Ext.util.JSON.decode(responsetext);
		mask.hide();
		if (jsonData.success == 'true') {
			// ˢ�½���
			InitRowid = jsonData.info;
			//Msg.info("success", "���ɳ��ⵥ�ɹ�!");
			findWin.close();
			Fn(InitRowid);
			
			// ��ת�������Ƶ�����
			//window.location.href='dhcst.dhcinistrf.csp?Rowid='+InitRowid+'&QueryFlag=1';

		} else {
			var ret=jsonData.info;
			if(ret==-99){
				Msg.info("error", $g("����ʧ��,�������ɳ��ⵥ!"));
			}else if(ret==-2){
				Msg.info("error", $g("���ɳ��ⵥ��ʧ��!"));
			}else if(ret==-1){
				Msg.info("error", $g("���ɳ��ⵥʧ��!"));
			}else if(ret==-5){
				Msg.info("error", $g("���ɳ��ⵥ��ϸʧ��!"));
			}else if(ret==-7){
				Msg.info("warning", $g("��ϸ���ݿ��ÿ�治��!"));
			}else if(ret==-8){
				Msg.info("warning",$g( "������Ч������ȫ������!"));
			}else {
				Msg.info("error", $g("���ɳ��ⵥʧ�ܣ�")+ret);
			}
			
		}
		
	}

	// ��ʾ��������
	function Query() {
		var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();  //SupplyLocId;
		if (supplyphaLoc =='' || supplyphaLoc.length <= 0) {
			Msg.info("warning",$g( "��ѡ��Ӧ����!"));
			return;
		}
		var requestphaLoc = Ext.getCmp("RequestPhaLocS").getValue();
		var startDate = Ext.getCmp("StartDateS").getRawValue();
		var endDate = Ext.getCmp("EndDateS").getRawValue();
		var partlyStatus = (Ext.getCmp("PartlyStatusS").getValue()==true?1:0);
		var allStatus = (Ext.getCmp("ShowTransfered").getValue()==true?1:0);
		var ReqStatus = Ext.getCmp("ReqStatus").getValue();
		
		var ListParam=startDate+'^'+endDate+'^'+supplyphaLoc+'^'+requestphaLoc+'^'+ReqStatus+'^'+allStatus;  //partlyStatus
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam('ParamStr',ListParam);
		MasterStore.removeAll();
		MasterStore.load({
			params:{start:0, limit:Page},
			callback : function(r,options, success){
					if(success==false){
	     				Msg.info("error", $g("��ѯ������鿴��־!"));
	     			}else{
	     				if(r.length>0){
		     				MasterGridS.getSelectionModel().selectFirstRow();
		     				MasterGridS.getSelectionModel().fireEvent('rowselect',this,0);
		     				MasterGridS.getView().focusRow(0);
	     				}
	     				else if(r.length==0){
						    if (HideFlag=="1"){
								findWin.close();
							}
		     			}
	     			}
				}
		});
		DetailGridS.store.removeAll();
		DetailGridS.getView().refresh();

	}

	// ����·��
	var MasterUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=QueryReq';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["req", "reqNo", "toLoc","toLocDesc", "frLocDesc", "date","time", "comp", 
	"userName","status","transferStatus"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "req",
				fields : fields
			});
	// ���ݼ�
	var MasterStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var MasterCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'req',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("���󵥺�"),
				dataIndex : 'reqNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("������"),
				dataIndex : 'toLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("��������"),
				dataIndex : 'frLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("��������"),
				dataIndex : 'date',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : $g("��������"),
				dataIndex : 'status',
				width : 120,
				align : 'left',
				renderer: renderReqType,
				sortable : true
			}, {
				header : $g("�Ƶ���"),
				dataIndex : 'userName',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : $g("����״̬"),
				dataIndex : 'transferStatus',
				width : 160,
				align : 'left',
				//renderer: renderStatus,
				sortable : true
			}]);
	MasterCm.defaultSortable = true;
	
	function renderStatus(value){
		var InstrfStatus='';
		if(value==0){
			InstrfStatus=$g('δת��');			
		}else if(value==1){
			InstrfStatus=$g('����ת��');
		}else if(value==2){
			InstrfStatus=$g('ȫ��ת��');
		}
		return InstrfStatus;
	}
	function renderReqType(value){
		var ReqType='';
		if(value=='O'){
			ReqType=$g('���쵥');
		}else if(value=='C'){
			ReqType=$g('����ƻ�');
		}
		return ReqType;
	}
	
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:$g('�� {0} ���� {1}�� ��һ�� {2} ��'),
		emptyMsg:$g("û�м�¼")
	});
	var MasterGridS = new Ext.grid.GridPanel({
				title : '',
				height : 170,
				cm : MasterCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : MasterStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:GridPagingToolbar
			});

	// ��ӱ�񵥻����¼�
	MasterGridS.getSelectionModel().on('rowselect', function(sm, rowIndex, r)  {
		var ReqId = MasterStore.getAt(rowIndex).get("req");
		var ReqLocDesc=MasterStore.getAt(rowIndex).get("toLocDesc");
		var ReqLocId=MasterStore.getAt(rowIndex).get("toLoc");
		addComboData(RequestPhaLocS.getStore(),ReqLocId,ReqLocDesc);
		Ext.getCmp("RequestPhaLocS").setValue(ReqLocId);
		var show=(Ext.getCmp("ShowTransfered").getValue()==true?1:0);
		DetailStore.removeAll();
		DetailStore.setBaseParam('req',ReqId);
		DetailStore.setBaseParam('TransferedFlag',show);
		
		DetailStore.load({params:{start:0,limit:GridDetailPagingToolbar.pageSize,sort:'req',dir:'Desc'}});
	});
	
	// ������ϸ
	// ����·��
	var DetailUrl =DictUrl+
		'inrequestaction.csp?actiontype=queryDetail';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	
	// ָ���в���
	var fields = ["cancel","rowid", "inci", "code","desc","qty", "uom", "uomDesc", "spec",
			 "manf", "sp", "spAmt","generic","drugForm", "remark","transQty","NotTransQty","prvqty"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "rowid",
				fields : fields
			});
	// ���ݼ�
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});


	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm,{
		              header :$g( "����"),
		              width : 50,
		              sortable: false,             
		              dataIndex: 'cancel',//����Դ�е�״̬��             
		              renderer: function (v) {
		                       return '<input type="checkbox"'+(v=="1"?"checked":"")+'/>';  //����ֵ����checkbox�Ƿ�ѡ    
		                       },
		              listeners : {
			              'click':function(e,b,row){
				              if (DetailStore.getAt(row).get("cancel")==""||DetailStore.getAt(row).get("cancel")==0){
					              DetailStore.getAt(row).set("cancel",1);				              
					              CancelDetailsAction(DetailStore.getAt(row).get("rowid"),"Y");					               
				              }
				              else{
					              DetailStore.getAt(row).set("cancel",0);
					              CancelDetailsAction(DetailStore.getAt(row).get("rowid"),"N"); 
				              } 	
								DetailStore.getAt(row).dirty=false;
								DetailStore.getAt(row).commit(); 			               
				            }
			              },
			        hidden:(gParam[9]=='Y'?false:true)
			             
		                     
		        },{
				header : $g("������ϸRowId"),
				dataIndex : 'rowid',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("ҩƷRowId"),
				dataIndex : 'inci',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g('ҩƷ����'),
				dataIndex : 'code',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g('ҩƷ����'),
				dataIndex : 'desc',
				width : 230,
				align : 'left',
				sortable : true
			}, {
				header : $g("��Ӧ�����"),
				dataIndex : 'prvqty',
				width : 80,
				align : 'right',
				sortable : true				
			}, {
				header : $g("��������"),
				dataIndex : 'qty',
				width : 80,
				align : 'right',
				sortable : true				
			}, {
				header : $g("��ת������"),
				dataIndex : 'transQty',
				width : 80,
				align : 'right',
				sortable : true				
			}, {
				header : $g("δת������"),
				dataIndex : 'NotTransQty',
				width : 80,
				align : 'right',
				sortable : true				
			}, {
				header :$g( "��λ"),
				dataIndex : 'uomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g("�ۼ�"),
				dataIndex : 'sp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : $g("������ҵ"),
				dataIndex : 'manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : $g("���"),
				dataIndex : 'spec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("����ͨ����"),
				dataIndex : 'generic',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("����"),
				dataIndex : 'drugForm',
				width : 100,
				align : 'left',
				sortable : true
			}]);
 var GridDetailPagingToolbar = new Ext.PagingToolbar({
		store:DetailStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:$g('�� {0} ���� {1}�� ��һ�� {2} ��'),
		emptyMsg:$g("û�м�¼")
	});

	var DetailGridS = new Ext.grid.GridPanel({
				id : 'DetailGridS',
				region : 'center',
				title : '',
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:GridDetailPagingToolbar,
				sm :new Ext.grid.RowSelectionModel({singleSelect:true}),
				//sm : new Ext.grid.CellSelectionModel({}),
				viewConfig:{getRowClass : function(record,rowIndex,rowParams,store){ 
						var stkQty=parseInt(record.get("stkQty"));
						var reqQty=parseInt(record.get("qty"));
						if(stkQty<reqQty){
							return 'classRed';
						}
					}
				}
			});

	 
	 function QueryListDetailID(){
	      //var sm=DetailGridS.getSelectionModel()
	      //var records=sm.getSelections()  //���ص���Ext.data.Record��������
	      //var count=records.length
	      var rowCount = DetailGridS.getStore().getCount();
	      var listdata=""
            for (var i=0;i<rowCount;i++) {
	         if (DetailStore.getAt(i).get("cancel")==true && listdata==""){
	            
	              listdata=DetailStore.getAt(i).get("rowid");
	         }
	         else if(DetailStore.getAt(i).get("cancel")==true && listdata!=""){
		       listdata=listdata+"^"+DetailStore.getAt(i).get("rowid");
		      }
	       } 
		return  listdata;   
	   }

	 //��������ѡ����� wyx 2014-06-23
	 function CancelDetailsAction(ListDetailID,CancelFlag){
		    	// ����·��
	         var url =DictUrl+
		        'inrequestaction.csp?actiontype=CancelReqItm';
			var loadMask=ShowLoadMask(Ext.getBody(),$g("������..."));
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{ListDetailID:ListDetailID,CancelFlag:CancelFlag},
						waitMsg : $g('������...'),
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								if (CancelFlag=="N"){
									Msg.info("success", $g("ȡ�����ϳɹ�!"));
								}else{
									Msg.info("success",$g("���ϳɹ�!"));
								}
								// ���¼�������
								DetailGridS.getView().refresh();

							} else {
								//var ret=jsonData.info;
								Msg.info("error", $g("����ʧ��!"));
							}
						},
						scope : this
					});
			loadMask.hide();		
		}
	
		function CancelSelectAll(){
			var toggleselect=(Ext.getCmp("AllBT").getValue()==false) ? true : false;
			Ext.getCmp("AllBT").setValue(toggleselect);

		}
		function CancelDetails() {
         // �û��Ի���
                   Ext.Msg.show({
	                 title:$g('��������ѡ����'),
	                 msg:$g('ȷ����������ѡ���'),
	                 scope: this,
	                 buttons: Ext.Msg.OKCANCEL,
	                 icon:Ext.MessageBox.QUESTION,
                     fn: function(id){
	                     if (id=='ok'){
		                    var ListDetailID=QueryListDetailID();
		                    if (ListDetailID=="") {Msg.info("warning",$g("û�й�ѡ������!"));}
		                    if (ListDetailID!=""){
		                        CancelDetailsAction(ListDetailID,"Y"); 
		                       }
		                      
		                     }
                        
	                     }

	                 });
		}	
		
			/***
		**����Ҽ��˵�,wyx,2014-06-23***
		**/
		//�Ҽ��˵�����ؼ����� 
		function rightClickFn(grid,rowindex,e){
			grid.getSelectionModel().selectRow(rowindex);
			e.preventDefault(); 
			rightClick.showAt(e.getXY()); //��ȡ����
           
		}
		if(gParam[9]=='Y'){
		   DetailGridS.addListener('rowcontextmenu', rightClickFn);//�Ҽ��˵�����ؼ�����
		}
		var rightClick = new Ext.menu.Menu({ 
			id:'rightClickCont', 
			items: [ 
				{ 
					id: 'mncancelSelectAll', 
					handler: CancelSelectAll, 
					text: $g('ȫѡ������'),
					click:true
					 
				},{ 
					id: 'mncancelDetails', 
					handler: CancelDetails, 
					text: $g('��������'),
					click:true,
					hidden:(gParam[9]=='Y'?false:true)
					 
				}
				]
		})
	// ˫���¼�
	MasterGridS.on('rowdblclick', function() {			
			// ����ת�Ƶ�
		if(CheckDataBeforeSave()==true){
			save();
			
		}		
	});
	var HisListTab = new Ext.form.FormPanel({
		labelWidth : 60,
		labelAlign : 'right',
		tbar : [SearchBTS, '-',  ClearBTS, '-', SaveBTS, '-', closeBTS],
		frame : true,
		autoScroll : false,		
		items:[{
			xtype:'fieldset',
			title:$g('��ѯ����'),
			defaults: {border:false}, 
			style:DHCSTFormStyle.FrmPaddingV,
			layout: 'column',    // Specifies that the items will now be arranged in columns
			items : [{ 				
				columnWidth: 0.3,
	        	xtype: 'fieldset',
	        	defaults: {width: 220},    // Default config options for child items
	        	defaultType: 'textfield',
	        	items: [RequestPhaLocS]
				
			},{ 				
				columnWidth: 0.25,
	        	xtype: 'fieldset',
	        	defaults: {width: 140},    // Default config options for child items
	        	defaultType: 'textfield',
	        	items: [StartDateS,EndDateS]
				
			},{ 				
				columnWidth: 0.25,
	        	xtype: 'fieldset',
	        	defaults: {width: 140},    // Default config options for child items
	        	defaultType: 'textfield',
	        	items: [ReqStatus,ShowTransfered]
				
			}
			/*,{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',
	        	border: false,
	        	labelWidth:60,
	        	//defaults: {width: 140,labelWidth : 10},    // Default config options for child items
	        	items: [ShowTransfered,PartlyStatusS]
				
			}*//*,{ 				
				columnWidth: 0.24,
	        	xtype: 'fieldset',
	        	border: false,
	        	//defaults: {width: 140,labelWidth : 10},    // Default config options for child items
	        	items: [AllBT]
				
			}*/]
		}]		
	});
	var findWin = new Ext.Window({
		title:$g('ѡȡ����'),
		id:'findWin',
		width:document.body.clientWidth*0.9,
		height:document.body.clientHeight*0.9,
		minWidth:1000, 
		minHeight:620,
		plain:true,
		modal:true,
		layout : 'border',
		items : [            // create instance immediately
	        {
	            region: 'north',
	            height: DHCSTFormStyle.FrmHeight(1), // give north and south regions a height
	            layout: 'fit', // specify layout manager for items
	            items:HisListTab
	        }, {
	            region: 'west',
	            title: $g('����'),
	            collapsible: true,
	            split: true,
	            width: document.body.clientWidth*0.88*0.32,
	            minSize: 175,
	            maxSize: 400,
	            margins: '0 5 0 0',
	            layout: 'fit', // specify layout manager for items
	            items: MasterGridS       
	           
	        }, {
	            region: 'center',
	            title: $g('������ϸ'),
	            layout: 'fit', // specify layout manager for items
	            items: DetailGridS       
	           
	        }
		]
		
	});
		
	//��ʾ����
	findWin.show();
	Query();		
}