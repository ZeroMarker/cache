// /����: ���ҿ�����λ��ά��
// /����: ���ҿ�����λ��ά��
// /��д�ߣ�LiangQiang
// /��д����: 2013.11.12
Ext.onReady(function() {

		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		var gStrParam='';
		var gIncId='';
		var gGroupId=session['LOGON.GROUPID'];
		var gLocId=session['LOGON.CTLOCID'];
		var gUserId=session['LOGON.USERID'];
         //����Ա����Ȩ�����鴮��
         if (gGrantStkGrp==""){
          GetGrantStkGrp();
         }
		//////////// UI  //////////////////

		 var HelpButton = new Ext.Button({
             width : 65,
             id:"HelpButton",
             text: '����',
			 renderTo: Ext.get("tipdiv"),  
			 iconCls : 'page_help'
			 
             
         }) 

��������///����
		var PhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '����',
					id : 'PhaLoc',
					name : 'PhaLoc',
					width : 200,
					anchor:'30%',
					groupId:gGroupId
				});

        
		PhaLoc.on(
			"select",
			function(cmb,rec,id ){
					searchData();
					QueryLocInciDs();
					
					BinInciGrid.store.removeAll(); 
					InciBinGrid.store.removeAll(); 
			}
		);

		// ҩƷ����
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //��ʶ��������
			UserId:gUserId,
			LocId:gLocId,
			anchor : '90%'
		}); 

		///ҩƷ����
		var InciDesc = new Ext.form.TextField({
                fieldLabel : 'ҩƷ����',
                id : 'InciDesc',
                name : 'InciDesc',
				width : 250,
                listeners : {
                    specialkey : function(field, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            var inputDesc=field.getValue();
                            var stkGrp=Ext.getCmp("StkGrpType").getValue();
                            GetPhaOrderInfo(inputDesc,stkGrp);
                        }
                    },
					render : function SetTip(textfield, e){
                             this.getEl().dom.setAttribute("ext:qtip", "¼��ƴ�����Ǵʺ�س�");
                    },
                    blur:function(){
	                   	if (InciDesc.getValue()==""){
		                	gIncId="";
		                }
	                }
                }
            });
	����

        ///��λ
		var StkBinTxt = new Ext.form.TextField({
                fieldLabel : '��λ',
                id : 'StkBinTxt',
                name : 'StkBinTxt',
                width : 180,
                listeners : {
                    specialkey : function(field, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            //var inputDesc=field.getValue().trim('');
                            searchData();
                        }
                    },
					render : function SetTip(textfield, e){
                             this.getEl().dom.setAttribute("ext:qtip", "¼���λ���س�,��ƥ��ģ����ѯ");
                    }
                }
            });
	����
		///ҩƷ����
		var IncCodeTxt = new Ext.form.TextField({
                fieldLabel : 'ҩƷ����',
                id : 'IncCodeTxt',
                name : 'IncCodeTxt',
                width : 120,
                listeners : {
                    specialkey : function(field, e) {
                        if (e.getKey() == Ext.EventObject.ENTER) {
                            QueryLocInciDs();
                        }
                    },
                    
                    render : function SetTip(textfield, e){
                             this.getEl().dom.setAttribute("ext:qtip", "¼��ҩƷ����س�,��ƥ��ģ����ѯ");
                    }
                }
            });

         //�ڶ��й�����
		 var twoTbar=new Ext.Toolbar({   
		 region: 'center',
		 items:[ 'ҩƷ����:',InciDesc]  
		 
		 }); 

        //������Ȩ�����鴮���ؿ����� add wyx 2014-04-28
		var M_StkCat = new Ext.ux.ComboBoxD({
			fieldLabel : '������',
			id : 'M_StkCat',
			name : 'M_StkCat',
			store : StkCatStoreByGrant,
			valueField : 'RowId',
			displayField : 'Description',
			params:{StkGrpIdStr:gGrantStkGrp}
		});
		M_StkCat.on(
			"select",
			function(cmb,rec,id ){
					QueryLocInciDs();
			}
		);

	   ///���һ�λ
		
		var nm = new Ext.grid.RowNumberer();
		var StkBinCm = new Ext.grid.ColumnModel([nm, {
					header : "rowid",
					dataIndex : 'sb',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '����',
					dataIndex : 'code',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "��λ����",
					dataIndex : 'desc',
					width : 400,
					align : 'left',
					sortable : true,
					editor:new Ext.form.TextField({
						allowBlank : false,
						listeners:{
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									addNewRow();
								}
							}
						}
					})
				}]);
		StkBinCm.defaultSortable = true;
		
		// ����·��
		var DspPhaUrl = DictUrl
					+ 'incstkbinaction.csp?actiontype=Query&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["sb", "code", "desc"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "sb",
					fields : fields
				});
		// ���ݼ�
		var StkBinStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});
		
		var GridPagingToolbar = new Ext.PagingToolbar({
			store:StkBinStore,
			pageSize:50,
			displayInfo:true,
			displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
			emptyMsg:"û�м�¼"
		});
		
		var StkBinSm = new Ext.grid.CheckboxSelectionModel({singleSelect : true});
		var StkBinGrid = new Ext.grid.GridPanel({
					id:'StkBinGrid',
					region : 'west',
					cm : StkBinCm,
					store : StkBinStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : StkBinSm, //new Ext.grid.CellSelectionModel({}),
					clicksToEdit : 1,
					loadMask : true,
					tbar:['����:',PhaLoc,'-','��λ:',StkBinTxt],
                    ddGroup: 'secondGridDDGroup',
					enableDragDrop : true,
					bbar:GridPagingToolbar
				});
	


        //���ҿ����
		var locincinm = new Ext.grid.RowNumberer();
		var LocInciCm = new Ext.grid.ColumnModel([locincinm, {
					header : "rowid",
					dataIndex : 'rowid',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '����',
					dataIndex : 'code',
					width : 140

				}, {
					header : "����",
					dataIndex : 'desc',
					width : 400,
					align : 'left'

				}]);

		LocInciCm.defaultSortable = true;
		
		// ����·��
		var LocInciUrl = DictUrl
					+ 'incstkbinaction.csp?actiontype=QueryLocInci&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var LocInciproxy = new Ext.data.HttpProxy({
					url : LocInciUrl,
					method : "POST"
				});
		// ָ���в���
		var LocInciFields = ["rowid", "code", "desc"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var LocInciReader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "rowid",
					fields : LocInciFields
				});
		// ���ݼ�
		var LocInciStore = new Ext.data.Store({
					proxy : LocInciproxy,
					reader : LocInciReader
				});
		
		var LocInciGridPagingToolbar = new Ext.PagingToolbar({
			store:LocInciStore,
			pageSize:50,
			displayInfo:true,
			displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
			emptyMsg:"û�м�¼"
		});
		
		var LocInciGrid = new Ext.grid.GridPanel({
					id:'LocInciGrid',
					region : 'center',
					cm : LocInciCm,
					store : LocInciStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					enableDragDrop : true,
					ddGroup : 'firstGridDDGroup',
					tbar:['ҩƷ����:',IncCodeTxt,'-','������:',M_StkCat,HelpButton],
					bbar:LocInciGridPagingToolbar,
                    listeners:{ 
     
							  'render' : function(){   
									twoTbar.render(this.tbar); //add one tbar   
					          }
                                
                     }

				});



		//����λ��ʾ�����
		
		var BinIncinm = new Ext.grid.RowNumberer();
		var BinInciCm = new Ext.grid.ColumnModel([BinIncinm, {
					header : "rowid",
					dataIndex : 'rowid',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '����',
					dataIndex : 'code',
					width : 80

				}, {
					header : "����",
					dataIndex : 'desc',
					width : 400,
					align : 'left'

				}]);

		BinInciCm.defaultSortable = true;
		
		// ����·��
		var BinInciUrl = DictUrl
					+ 'incstkbinaction.csp?actiontype=QueryLocBinInc&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var BinInciproxy = new Ext.data.HttpProxy({
					url : BinInciUrl,
					method : "POST"
				});
		// ָ���в���
		var BinInciFields = ["rowid", "code", "desc"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var BinInciReader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "rowid",
					fields : BinInciFields
				});
		// ���ݼ�
		var BinInciStore = new Ext.data.Store({
					proxy : BinInciproxy,
					reader : BinInciReader
				});
		

		var BinInciGrid = new Ext.grid.GridPanel({
					id:'BinInciGrid',
					region : 'west',
					cm : BinInciCm,
					title:'��λ�ڷ�ҩƷ(˫��ɾ��)',
					store : BinInciStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true
				});


		//���������ʾ��λ
		
		var InciBinnm = new Ext.grid.RowNumberer();
		var InciBinCm = new Ext.grid.ColumnModel([InciBinnm, {
					header : "rowid",
					dataIndex : 'rowid',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '����',
					dataIndex : 'code',
					width : 80

				}, {
					header : "����",
					dataIndex : 'desc',
					width : 400,
					align : 'left'

				}]);

		InciBinCm.defaultSortable = true;
		
		// ����·��
		var InciBinUrl = DictUrl
					+ 'incstkbinaction.csp?actiontype=QueryLocItmBin&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var InciBinproxy = new Ext.data.HttpProxy({
					url : InciBinUrl,
					method : "POST"
				});
		// ָ���в���
		var InciBinFields = ["rowid", "code", "desc"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var InciBinReader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "rowid",
					fields : InciBinFields
				});
		// ���ݼ�
		var InciBinStore = new Ext.data.Store({
					proxy : InciBinproxy,
					reader : InciBinReader
				});
		

		var InciBinGrid = new Ext.grid.GridPanel({
					id:'InciBinGrid',
					region : 'center',
					cm : InciBinCm,
					title:'ҩƷ��λ(˫��ɾ��)',
					store : InciBinStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					margins:'�� �� �� 3'
				});


�������� //���panel
		 var westPanel = new Ext.Panel({  
			 id:'westform',
			 title:'����ҩƷ��λά��',
			 region:'west',
			 collapsible: false,
			 margins:'0 3 0 0',
			 width:500,
			 frame : true,
			 layout:{  
				type:'vbox', 
				align: 'stretch',  
				pack: 'start'  
			 },
		 items: [{         
			  flex: 6,
			  layout:'fit',
			  items:[StkBinGrid]  
			 },{   
			  flex: 2 ,
			  layout:'fit',
			  items:[BinInciGrid]    
			   }]  
		 });

����������//�м�panel
		��centerPanel = new Ext.Panel({
		��id:'centerform',
		  title:'����ҩƷ',
		��region: 'center',
		��margins:'0 3 0 1', 
		��frame : true,
		��layout:{  
					type:'vbox', 
					align: 'stretch',  
					pack: 'start'  
			}, 
		  items: [{           
				  flex: 6,
				  layout:'border',
				  items:[LocInciGrid]  
				 },{   
				  flex: 2 ,
				  layout:'fit',
				  items:[InciBinGrid]    
			   }]

			
		});

		// ҳ�沼��
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [ westPanel,centerPanel ],
					renderTo : 'mainPanel'
				});



//	  //--------Events-------------------------//
//	  	initHosp({
//			grids:[StkBinGrid,BinInciGrid,LocInciGrid,InciBinGrid],
//			selHandler : function(){
//				PhaLoc.setValue('');
//				StkBinTxt.setValue('');
//				IncCodeTxt.setValue('');
//				M_StkCat.setValue('');
//				InciDesc.setValue('');
//			},
//			movepanel:['westform','centerform']		  	
//		});


		// ��¼����Ĭ��ֵ
		SetLogInDept(PhaLoc.getStore(), "PhaLoc");
		searchData();
		QueryLocInciDs();
		
	
	   var firstGridDropTargetEl =  StkBinGrid.getView().scroller.dom;;
	  
	    var firstGridDropTarget = new Ext.dd.DropTarget(firstGridDropTargetEl, {
			ddGroup    : 'firstGridDDGroup',
			notifyDrop : function(ddSource, e, data){
                    var records =  ddSource.dragData.selections;
					//alert(records[0].data.code)
					//var index = ddSource.getDragData(e).rowIndex;
					
					var target = Ext.lib.Event.getTarget(e);
					var rindex = StkBinGrid.getView().findRowIndex(target); 
					var stkbindr=StkBinStore.getAt(rindex).get("sb");
					Ext.getCmp("StkBinGrid").getSelectionModel().selectRow(rindex);
                    
					for (var i = 0; i < records.length; i++) {
						//alert(LocInciGrid.getSelectionModel().getSelections()[i].data.code)
						var incil=LocInciGrid.getSelectionModel().getSelections()[i].data.rowid ;
						var savestr=incil+"^"+stkbindr;
						//alert(rindex+":"+savestr)
						save(savestr);
					}

					
					return true;
					
					
			}
	    });


		 /**
		 * ��ѯ����
		 */
		function searchData() {
			// ��ѡ����
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			if (phaLoc == null || phaLoc.length <= 0) {
				Msg.info("warning", "���Ҳ���Ϊ�գ�");
				Ext.getCmp("PhaLoc").focus();
				return;
			}

			gStrParam=phaLoc;
			var pagesize=GridPagingToolbar.pageSize;
			StkBinStore.removeAll();
			StkBinStore.setBaseParam('LocId',gStrParam);
			StkBinStore.setBaseParam('sbDesc',Ext.getCmp("StkBinTxt").getValue().trim(''));
			StkBinStore.load({params:{start:0,limit:50}});

			
		}

        //�����Ҳ�ѯ������б�
		function QueryLocInciDs()
		{
				LocInciStore.removeAll();
				var phalocrowid=Ext.getCmp("PhaLoc").getValue();
                var inccode=Ext.getCmp("IncCodeTxt").getValue().trim('');
				var stkcatrowid=Ext.getCmp("M_StkCat").getValue();
				var StrPar=phalocrowid+"^"+gIncId+"^"+inccode+"^"+stkcatrowid ;
                
				LocInciStore.setBaseParam('StrPar',StrPar);
				Ext.getCmp("StkBinTxt").getValue().trim('')
				LocInciStore.load({
				params:{start:0, limit:LocInciGridPagingToolbar.pageSize},
				callback: function(r, options, success){

					   if (success==false){
							Msg.info("error", "��ѯ����ҩƷ����");
						 } else{
							   
						 }         
						   
					   }
				
				});

		}
	
         ///����ҩƷ���λ
		function save(savestr){
			PhaLocId=Ext.getCmp('PhaLoc').getValue();
			if(PhaLocId==null||PhaLocId.length<1){
				Msg.info("warning", "���Ҳ���Ϊ��!");
				return;
			}
		    var savestr=savestr+"^"+PhaLocId;
			var url = DictUrl
					+ "incstkbinaction.csp?actiontype=SaveLocItmBin";
            var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params: {savestr:savestr},
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							mask.hide();

							//ˢ�������б�
							var TmpArr = savestr.split("^");
							QueryLocInciBinDs(TmpArr[0]);
							QueryLocBinIncDs(TmpArr[1]);

							if (jsonData.success == 'true') {


							} else {
								var ret=(jsonData.info).split(':')[1];
								Msg.info("error", "����ʧ�ܣ�"+ret);

							}
						},
						scope : this
					});

		}

��
����///����ҩƷ�б�
    function GetPhaOrderInfo(item, stktype) {
       var phaLoc = Ext.getCmp("PhaLoc").getValue();
        if (item != null && item.length > 0) {
            GetPhaOrderWindow(item, "", App_StkTypeCode, phaLoc, "N", "0", "",getDrugList);
        }else{
			gIncId="";
			QueryLocInciDs();
		}
		
    }
    /**
     * ���ط���
     */
    function getDrugList(record) {
        if (record == null || record == "") {
            return;
        }
        gIncId = record.get("InciDr");
        var incDesc=record.get("InciDesc");
        Ext.getCmp("InciDesc").setValue(incDesc);
		QueryLocInciDs();
    }


	    //�����ҿ�����ѯ��λ�б�
		function QueryLocInciBinDs(incil)
		{
				InciBinStore.removeAll();
				var StrPar=incil ;
                
				InciBinStore.setBaseParam('StrPar',StrPar);
				InciBinStore.load({
				params:{start:0, limit:9999},
				callback: function(r, options, success){

					   if (success==false){
							Msg.info("error", "��ѯ����ҩƷ��λ����");
						 } else{

							 
							 var totalnum =InciBinGrid.getStore().getCount()-1;
							 Ext.getCmp("InciBinGrid").getSelectionModel().selectRow(totalnum);
							 InciBinGrid.getView().focusRow(totalnum);
							   
						 }         
						   
					   }
				
				});

		}



		 ///LocInciGrid �������¼�

		 LocInciGrid.on('rowclick',function(grid,rowIndex,e){
		   
				var selectedRow = LocInciStore.data.items[rowIndex];
				var incil = selectedRow.data["rowid"];
				QueryLocInciBinDs(incil); 
				
				
			}); 


		 ///StkBinGrid �������¼�

		 StkBinGrid.on('rowclick',function(grid,rowIndex,e){
		   
				var selectedRow = StkBinStore.data.items[rowIndex];
				var stkbindr = selectedRow.data["sb"];
				QueryLocBinIncDs(stkbindr); 
				
				
			});


		//����λ��ѯ���ҿ�����б�
		function QueryLocBinIncDs(stkbindr)
		{
				BinInciStore.removeAll();
				var StrPar=stkbindr ;
                
				BinInciStore.setBaseParam('StrPar',StrPar);
				BinInciStore.load({
				params:{start:0, limit:9999},
				callback: function(r, options, success){

					   if (success==false){
							Msg.info("error", "��ѯ��λ����ҩƷ����");
						 } else{
							 var totalnum =BinInciGrid.getStore().getCount()-1;
							 Ext.getCmp("BinInciGrid").getSelectionModel().selectRow(totalnum);
							 BinInciGrid.getView().focusRow(totalnum); 
						 }         
						   
					   }
				
				});

		}

     //��λ�����˫���¼�
	 BinInciGrid.on('rowdblclick',function(grid,rowIndex,e){
		   
				//var selectedRow = BinInciStore.data.items[rowIndex];
				Ext.MessageBox.confirm('ע��', 'ȷ��Ҫɾ���� ? ',DeleteBinInciData);
				
				
			});

	function DeleteBinInciData(btn)
	{
		if (btn=="no"){ return ;}
		var selectedRow = BinInciGrid.getSelectionModel().getSelected();
		var incilb = selectedRow.data["rowid"];
        var ParStr=incilb;
		var rowIndex = BinInciStore.indexOfId(selectedRow.id);//�к�

		var url = DictUrl
					+ "incstkbinaction.csp?actiontype=DelBinInci";
        var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
						url : url,
						method : 'POST',
						params: {ParStr:ParStr},
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							mask.hide();

							if (jsonData.success == 'true') {

								//ˢ�������б�
								BinInciStore.removeAt( rowIndex );
								BinInciStore.reload();
								InciBinStore.reload();

							} else {
								var ret=jsonData.info;
								Msg.info("error", "ɾ��ʧ�ܣ�"+ret);

							}
						},
						scope : this
					});

	}



    //������λ˫���¼�
	InciBinGrid.on('rowdblclick',function(grid,rowIndex,e){
		   
				Ext.MessageBox.confirm('ע��', 'ȷ��Ҫɾ���� ? ',DeleteInciBinData);
				
				
			});

	function DeleteInciBinData(btn)
	{
		if (btn=="no"){ return ;}
		var selectedRow = InciBinGrid.getSelectionModel().getSelected();
		var incilb = selectedRow.data["rowid"];
        var ParStr=incilb;
		var rowIndex = InciBinStore.indexOfId(selectedRow.id);//�к�

		var url = DictUrl
					+ "incstkbinaction.csp?actiontype=DelBinInci";
        var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
						url : url,
						method : 'POST',
						params: {ParStr:ParStr},
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							mask.hide();

							if (jsonData.success == 'true') {

								//ˢ�������б�
								InciBinStore.removeAt( rowIndex );
								InciBinStore.reload();
								BinInciStore.reload();

							} else {
								var ret=jsonData.info;
								Msg.info("error", "ɾ��ʧ�ܣ�"+ret);

							}
						},
						scope : this
					});

	}


   /*��������ť����tip��ʾ
   * LiangQiang
   */
   new Ext.ToolTip({
        target: 'HelpButton',
        anchor: 'right',
        width: 400,
        anchorOffset: 5,
		hideDelay : 8000,
        html: "<font size=3 color='#5E88B6'><b>ѡ��ҩƷ����ק����߻�λ��,��ɹ���<b></font>"
    });



})