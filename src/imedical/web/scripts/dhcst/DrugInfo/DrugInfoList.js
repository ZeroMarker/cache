// /����: ҩƷ��Ϣά��
// /����: ҩƷ��Ϣά��
// /��д�ߣ�zhangdongmei
// /��д����: 2011.12.16
// /�޸ģ�2012-06-14����������
var drugRowid = "";
var storeConRowId="";
var SaveAsFlag="";
var gNewCatIdOther="";
var changeflag="";
var userId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
if(gParamCommon.length<1){
   GetParamCommon();  //��ʼ�������������� wyx ��������ȡ��������gParamCommon[9]��������ȡ���۹�������gParamCommon[7]
 }
Ext.onReady(function() {		
		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		//============================DrugList.js====================================================================
		//==========����==========================
		/**
		 * ����ҩƷ���岢���ؽ��
		 */
		function GetPhaOrderInfo(item, stktype) {
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "", "0", "",getDrugList);
			}
		}
		
		/**
		 * ���ط���
		 */
		function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			var inciDr = record.get("InciDr");
			var InciCode=record.get("InciCode");
			var InciDesc=record.get("InciDesc");
			Ext.getCmp("M_InciDesc").setValue(InciDesc);
			Ext.getCmp("M_InciCode").setValue(InciCode);
			
			search();
		}
		/*
		//�Ҽ��˵�����ؼ����� 
		function rightClickFn(grid,rowindex,e){ 
			e.preventDefault(); 
			rightClick.showAt(e.getXY()); 
		}
		
		function editIncAliasInfo() {
			var gridSelected =Ext.getCmp("DrugInfoGrid"); 
			var rows=gridSelected.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'����',msg:'��ѡ��Ҫ�༭��ҩƷ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				selectedRow = rows[0];
				var IncRowid = selectedRow.get("InciRowid");
				IncAliasEdit(DrugInfoStore, IncRowid);								
			}
		}
		function editArcAliasInfo() {
			var gridSelected =Ext.getCmp("DrugInfoGrid"); 
			var rows=gridSelected.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'����',msg:'��ѡ��Ҫ�༭��ҩƷ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				selectedRow = rows[0];
				var IncRowid = selectedRow.get("InciRowid");
				OrdAliasEdit(DrugInfoStore, IncRowid);								
			}
		}
		function editDoseEquivInfo() {
			var gridSelected =Ext.getCmp("DrugInfoGrid"); 
			var rows=gridSelected.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'����',msg:'��ѡ��Ҫ�༭��ҩƷ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				selectedRow = rows[0];
				var IncRowid = selectedRow.get("InciRowid");
				DoseEquivEdit(DrugInfoStore, IncRowid);								
			}
		}
		*/

		//==========����==========================
		
		//==========�ؼ�==========================
		// ҩƷ����
		var M_InciCode = new Ext.form.TextField({
			fieldLabel : '<font color=blue>ҩƷ����</font>',
			id : 'M_InciCode',
			name : 'M_InciCode',
			anchor : '90%',
			valueNotFoundText : '',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						search();
					}
				}
			}
		});
		// ҩƷ����
		var M_InciDesc = new Ext.form.TextField({
			fieldLabel : '<font color=blue>ҩƷ����</font>',
			id : 'M_InciDesc',
			name : 'M_InciDesc',
			anchor : '90%',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var stktype = Ext.getCmp("M_StkGrpType").getValue();
						GetPhaOrderInfo(field.getValue(), stktype);
					}
				}
			}
		});
	
		// ҩƷ����
		var M_GeneName = new Ext.form.TextField({
			fieldLabel : '<font color=blue>ҩƷ����</font>',
			id : 'M_GeneName',
			name : 'M_GeneName',
			anchor : '90%',
			valueNotFoundText : '',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						search();
					}
				}
			}
		});

		// ҩƷ����
		var M_StkGrpType=new Ext.ux.StkGrpComboBox({ 
			fieldLabel:'<font color=blue>�ࡡ����</font>',
			id : 'M_StkGrpType',
			name : 'M_StkGrpType',
			StkType:App_StkTypeCode,     //��ʶ��������
			UserId:userId,
			//LocId:gLocId,
			anchor : '90%'
		}); 
		M_StkGrpType.on('change',function(){
			Ext.getCmp("M_StkCat").setValue('');
		});
		
		// ������
		var M_StkCat = new Ext.ux.ComboBox({
			fieldLabel : '<font color=blue>������</font>',
			id : 'M_StkCat',
			name : 'M_StkCat',
			store : StkCatStore,
			valueField : 'RowId',
			displayField : 'Description',
			params:{StkGrpId:'M_StkGrpType'}
		});
		var PHCCATALLOTH = new Ext.form.TextField({
			fieldLabel : 'ҩѧ����',
			id : 'PHCCATALLOTH',
			name : 'PHCCATALLOTH',
			anchor : '90%',
			readOnly : true,
			valueNotFoundText : ''
		});
		function GetAllCatNewList(catdescstr,newcatid){
			//if ((catdescstr=="")&&(newcatid=="")) {return;}
			Ext.getCmp("PHCCATALLOTH").setValue(catdescstr);
			gNewCatIdOther=newcatid;
	
	
		}
		/// ҩѧ����
		var PHCCATALLOTHButton = new Ext.Button({
			id:'PHCCATALLOTHButton',
			text : '...',
			handler : function() {	
				PhcCatNewSelect(gNewCatIdOther,GetAllCatNewList)
		    }
		});

		// ȫ��
		var M_AllFlag = new Ext.form.Checkbox({
			fieldLabel : 'ȫ������',
			id : 'M_AllFlag',
			name : 'M_AllFlag',
			//anchor : '90%',
			checked : false
		});

		// ���Ϊ
		var M_SaveAsFlag = new Ext.form.Checkbox({
			fieldLabel : '������',
			id : 'M_SaveAsFlag',
			name : 'M_SaveAsFlag',
			//anchor : '90%',
			checked : false,
			handler:function(){
				SaveAsFlag=Ext.getCmp("M_SaveAsFlag").getValue();
			}
		});
		//==========�ؼ�==========================
	
		// ����·��
		var DspPhaUrl ='dhcst.druginfomaintainaction.csp?actiontype=GetItm';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
			url:DspPhaUrl,
			method : "POST"
		});
		// ָ���в���
		var fields = ["InciRowid", "InciCode", "InciDesc", "Spec", "Manf","PurUom", "Sp", "BUom", "BillUom", "Form", "GoodName","GenericName", "StkCat","NotUseFlag","PhaCatAllDesc","StkGrpDesc"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			id : "InciRowid",
			fields : fields
		});
	    
		// ���ݼ�
		var DrugInfoStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader,
					remoteSort:true,
					baseParams:{
						Params:''
					}
		});


		// �������ʽ
		DrugInfoStore.setDefaultSort('InciRowid', 'ASC');
	
		// ��ѯ��ť
		var SearchBT = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '�����ѯ',
			iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				DrugInfoGrid.getStore().removeAll();
				DrugInfoGrid.getView().refresh();
				clearData();
				search();
			}
		});

		function search(){
			var inciDesc = Ext.getCmp("M_InciDesc").getValue();
			var inciCode = Ext.getCmp("M_InciCode").getValue();
			var alias = Ext.getCmp("M_GeneName").getValue();
			var stkCatId = Ext.getCmp("M_StkCat").getValue();
			var PhcCatId ="" ;
			var PhcSubCatId = "";
			var PhcMinCatId ="";
			var StkGrpType = Ext.getCmp("M_StkGrpType").getValue();
			if ((inciDesc == "")&&(inciCode == "")&& (alias =="")&& (stkCatId == "")&&(StkGrpType=="")) {
				Msg.info("error", "��ѡ���ѯ����!");
				return false;
			}
			var allFlag = (Ext.getCmp("M_AllFlag").getValue()==true?'Y':'N');
			var others = ""+"^"+""+"^"+""+"^"+StkGrpType+"^"+gNewCatIdOther;
			var strParam=inciDesc+RowDelim+inciCode+RowDelim+alias+RowDelim+stkCatId+RowDelim+allFlag+RowDelim+others
			DrugInfoStore.setBaseParam("Params",strParam);
			// ��ҳ��������
			DrugInfoStore.load({params:{start:0, limit:DrugInfoGridPagingToolbar.pageSize},
				callback : function(r,options, success) {					//Store�쳣��������
				debugger
					if(success==false){ 
						Ext.MessageBox.alert("��ѯ����",this.reader.jsonData.Error); 
     				}else{
	     				var rowCount=DrugInfoStore.getCount()
     					//ֻ��һ����¼�Ļ�ѡ�д˼�¼
     					if(r.length>=1){
     						DrugInfoGrid.getSelectionModel().selectFirstRow();
     						DrugInfoGrid.fireEvent('rowclick',this,0);
     					}
     				}        				
				}
			});
			//=======ͨ�����¼�ѡȡʱ��ȡ����===
			 DrugInfoStore.on('load',function(){
			if (DrugInfoStore.getCount()>0){
		      DrugInfoGrid.getSelectionModel().selectFirstRow();
		      DrugInfoGrid.getView().focusRow(0);
	        }
				})
			//=======ͨ�����¼�ѡȡʱ��ȡ����===
		}
		// ��հ�ť
		var ClearBT = new Ext.Toolbar.Button({
			text : '����',
			tooltip : '�������',
			width : 70,
			height : 30,
			iconCls : 'page_clearscreen',
			handler : function() {
				M_InciCode.setValue("");
				M_InciDesc.setValue("");
				M_StkGrpType.setValue("");
				M_StkCat.setValue("");
				M_StkGrpType.setRawValue("");
				M_StkCat.setRawValue("");
				M_GeneName.setValue("");
				M_AllFlag.setValue(false);
				M_SaveAsFlag.setValue(false);				
				DrugInfoGrid.getStore().removeAll();
				DrugInfoGrid.getView().refresh();
				drugRowid="";
				Ext.getCmp("PHCCATALLOTH").setValue("");
				gNewCatIdOther=""
				clearData();
                DrugInfoStore.setBaseParam('Params',"")
                DrugInfoStore.load({
					params:{start:0,limit:0},			
					callback : function(r,options, success) {					
						if(success==false){
		 					Ext.MessageBox.alert("��ѯ����",DrugInfoStore.reader.jsonData.Error);  
		 				}         				
					}
				});	
			}
		});
		
		var nm = new Ext.grid.RowNumberer();
		/*
		var ColumnNotUseFlag = new Ext.grid.CheckColumn({
			id:'NotUseFlag',
       		header: '������',
       		dataIndex: 'NotUseFlag',
       		sortable : true,
       		disabled:true,
       		width: 45
    	}); */
		
		var DrugInfoCm = new Ext.grid.ColumnModel([nm, 
			{
				header : "�����id",
				dataIndex : 'InciRowid',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			}, {
				header : "����",
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '����',
				dataIndex : 'InciDesc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : "���",
				dataIndex : 'Spec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : '��ⵥλ',
				dataIndex : 'PurUom',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : "�ۼ�(��ⵥλ)",
				dataIndex : 'Sp',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "������λ",
				dataIndex : 'BUom',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "�Ƽ۵�λ",
				dataIndex : 'BillUom',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'Form',
				width : 60,
				align : 'left',
				sortable : true
			}, {
				header : "��Ʒ��",
				dataIndex : 'GoodName',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "ͨ����",
				dataIndex : 'GenericName',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "������",
				dataIndex : 'StkCat',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'StkGrpDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "ҩѧ����",
				dataIndex : 'PhaCatAllDesc',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "������",
				dataIndex : 'NotUseFlag',
				width : 45,
				align : 'center',
				renderer : function(v) {
					if (v == "Y")
						return "<div class='ux-lovcombo-icon-checked ux-lovcombo-icon' style='background-position:0 -13px;'>&nbsp;</div>";
					else
						return "<div class='ux-lovcombo-icon-unchecked ux-lovcombo-icon'>&nbsp;</div>"
				},
				sortable : true
			}
		]);
		DrugInfoCm.defaultSortable = true;
		

		var DrugInfoGridPagingToolbar = new Ext.PagingToolbar({
			store : DrugInfoStore,
			pageSize : 10,
			displayInfo : true,
			displayMsg : '��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
			emptyMsg : "No results to display",
			prevText : "��һҳ",
			nextText : "��һҳ",
			refreshText : "ˢ��",
			lastText : "���ҳ",
			firstText : "��һҳ",
			beforePageText : "��ǰҳ",
			afterPageText : "��{0}ҳ",
			emptyMsg : "û������"
		});

		var DrugInfoGrid = new Ext.grid.GridPanel({
			id:'DrugInfoGrid',
			region:'center',
			//height:420,
			//width : 495,
			autoScroll:true,
			cm:DrugInfoCm,
			store:DrugInfoStore,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask : true,
			//plugins: [ColumnNotUseFlag],
			bbar:[DrugInfoGridPagingToolbar],
			tbar:{items:[{iconCls:'page_gear',text:'������',handler:function(){	GridColSet(DrugInfoGrid,"DHCSTDRUGMAINTAIN");}}]}//,
			/*view: new Ext.ux.grid.BufferView({
			    rowHeight: 30,
			    // forceFit: true,
			    scrollDelay: false
			})*/
		});
		
		var HisListTab = new Ext.form.FormPanel({
			height:DHCSTFormStyle.FrmHeight(4),
			labelWidth: 60,	
			labelAlign : 'right',
			frame : true,
			autoScroll : false,
			region : 'north',	
			autoHeight:true,
			tbar : [SearchBT, '-', ClearBT],
			items:[{
				xtype:'fieldset',
				title:'��ѯ����--<font color=red>���顢�����ࡢҩƷ���롢ҩƷ���ơ�ҩƷ��������ȫ��Ϊ��</font>',
				layout: 'column',    // Specifies that the items will now be arranged in columns
				style:DHCSTFormStyle.FrmPaddingV,
				defaults: {border:false},
				items : [{ 				
					columnWidth: 0.5,
	            	xtype: 'fieldset',	            	
	            	items: [M_InciCode,M_InciDesc,M_StkGrpType,M_StkCat]					
				}, {
					columnWidth: 0.5,
	            	xtype: 'fieldset',
					items : [{xtype:'compositefield',items:[PHCCATALLOTH,PHCCATALLOTHButton]},M_GeneName,M_SaveAsFlag,M_AllFlag]
				}]					
			}]			
		});
		// ��ӱ��ѡȡ���¼�
	DrugInfoGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		var selectedRow = DrugInfoStore.data.items[rowIndex];
			var InciRowid = selectedRow.data['InciRowid'];
			drugRowid = InciRowid;
			//��ѯ��������Ϣ
			if (InciRowid == null || InciRowid.length <= 0 || InciRowid <= 0) {
				return false;
			}
			
			GetDetail(drugRowid);
	});
		//======Grid����¼�===================================
		DrugInfoGrid.on('rowclick',function(grid,rowIndex,e){
			var selectedRow = DrugInfoStore.data.items[rowIndex];
			var InciRowid = selectedRow.data['InciRowid'];
			drugRowid = InciRowid;
			//��ѯ��������Ϣ
			if (InciRowid == null || InciRowid.length <= 0 || InciRowid <= 0) {
				return false;
			}			
			GetDetail(drugRowid);
		});

		
		/***
		**����Ҽ��˵�,zdm,2012-01-04***
		**/
		/*
		DrugInfoGrid.addListener('rowcontextmenu', rightClickFn);//�Ҽ��˵�����ؼ����� 
		var rightClick = new Ext.menu.Menu({ 
			id:'rightClickCont', 
			items: [ 
				{ 
					id: 'mnuInciAlias', 
					handler: editIncAliasInfo, 
					text: '��������' 
				},{ 
					id: 'mnuArcAlias', 
					handler: editArcAliasInfo, 
					text: 'ҽ�������' 
				},{ 
					id: 'mnuDoseEquiv', 
					handler: editDoseEquivInfo, 
					text: '��Ч����' 
				}
			] 
		}); 
		*/
		//======Grid����¼�===================================
		
		RefreshGridColSet(DrugInfoGrid,"DHCSTDRUGMAINTAIN");   //�����Զ�������������������               
		
		var viewport = new Ext.Viewport({
            layout: 'border',
            items: [
			{
                region: 'center',
                title: 'ҩƷ�б�',
                id:'DrugList',
                collapsible: true,
                //split: true,
                margins: '0 5 0 0',
                layout: 'border',                
                items : [HisListTab,DrugInfoGrid]          // this TabPanel is wrapped by another Panel so the title will be applied
           
            },
            {
	            region: 'east',
                split: true,
                width: 775, // give east and west regions a width
                minSize: 300,
                maxSize: 1200,
                margins: '0 5 0 0',
                layout: 'fit',                 
                items : [talPanel] 
       		
       		}]
        });
    InitDetailForm();
})