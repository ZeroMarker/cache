// /����:��涯����ѯ
// /����: ��涯����ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.16
var gNewCatIdOther="";
var gNewCatId=""
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParam='';
	var gGroupId=session['LOGON.GROUPID'];
	var gUserId=session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	//ͳ�ƿ���
	var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : $g('����'),
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor:'90%',
			groupId:gGroupId,
		        listeners : {
                    'select' : function(e) {
                             var SelLocId=Ext.getCmp('PhaLoc').getValue();//add wyx ����ѡ��Ŀ��Ҷ�̬��������
                             StkGrpType.getStore().removeAll();
                             StkGrpType.getStore().setBaseParam("locId",SelLocId)
                             StkGrpType.getStore().setBaseParam("userId",UserId)
                             StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
                             StkGrpType.getStore().load();
			}
	}
		});
		// ��ʼ����
		var StartDate = new Ext.ux.DateField({
					fieldLabel : $g('��ʼ����'),
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					width : 120,
					value : new Date().add(Date.DAY, - 30)
				});
		var StartTime=new Ext.form.TextField({
			fieldLabel : $g('��ʼʱ��'),
			id : 'StartTime',
			name : 'StartTime',
			anchor : '90%',
			regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
			regexText:$g('ʱ���ʽ������ȷ��ʽhh:mm:ss'),
			width : 120
		});
		// ��ֹ����
		var EndDate = new Ext.ux.DateField({
					fieldLabel : $g('��ֹ����'),
					id : 'EndDate',
					name : 'EndDate',
					anchor : '90%',
					width : 120,
					value : new Date()
				});
		var EndTime=new Ext.form.TextField({
			fieldLabel : $g('��ֹʱ��'),
			id : 'EndTime',
			name : 'EndTime',
			anchor : '90%',
			regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
			regexText:$g('ʱ���ʽ������ȷ��ʽhh:mm:ss'),
			width : 120
		});
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //��ʶ��������
			anchor : '90%',
			UserId:gUserId,
			LocId:gLocId,
			fieldLabel:$g('����')
		}); 

		StkGrpType.on('change', function() {
			Ext.getCmp("DHCStkCatGroup").setValue("");
		});
		var DHCStkCatGroup = new Ext.ux.ComboBox({
					fieldLabel : $g('������'),
					id : 'DHCStkCatGroup',
					name : 'DHCStkCatGroup',
					store : StkCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{StkGrpId:'StkGrpType'}
				});

		// ҩѧ����
		var PhcCat = new Ext.ux.ComboBox({
					fieldLabel : $g('ҩѧ����'),
					id : 'PhcCat',
					name : 'PhcCat',
					anchor : '90%',
					store : PhcCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					filterName:'PhccDesc'
				});
		PhcCat.on('change',function(){
			Ext.getCmp("PhcSubCat").setValue("");
			Ext.getCmp("PhcMinCat").setValue("");
		});

		// ҩѧ����
		var PhcSubCat = new Ext.ux.ComboBox({
					fieldLabel : $g('ҩѧ����'),
					id : 'PhcSubCat',
					name : 'PhcSubCat',
					anchor : '90%',
					store : PhcSubCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{PhcCatId:'PhcCat'}
				});

		PhcSubCat.on('change',function(){
			Ext.getCmp("PhcMinCat").setValue("");
		});

		// ҩѧС��
		var PhcMinCat = new Ext.ux.ComboBox({
					fieldLabel : $g('ҩѧС��'),
					id : 'PhcMinCat',
					name : 'PhcMinCat',
					anchor : '90%',
					store : PhcMinCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{PhcSubCatId:'PhcSubCat'}
				});

	var PHCCATALLOTH = new Ext.form.TextField({
		fieldLabel : $g('ҩѧ����'),
		id : 'PHCCATALLOTH',
		name : 'PHCCATALLOTH',
		//anchor : '90%',
		readOnly : true,
		valueNotFoundText : ''
	});
	function GetAllCatNew(catdescstr,newcatid){
		//if ((catdescstr=="")&&(newcatid=="")) {return;}
		Ext.getCmp("PHCCATALLOTH").setValue(catdescstr);
		gNewCatIdOther=newcatid;
	
	
	}

	var PHCCATALLOTHButton = new Ext.Button({
		id:'PHCCATALLOTHButton',
		text : $g('ҩѧ����'),
		handler : function() {	
	       //var lnk="dhcst.phccatall.csp?gNewCatId="+gNewCatId;
	       //window.open(lnk,"_target","height=600,width=800,menubar=no,status=yes,toolbar=no,resizable=yes") ;
    	/*
	     var retstr=showModalDialog('dhcst.phccatall.csp?gNewCatId='+gNewCatIdOther,'','dialogHeight:600px;dialogWidth:1000px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no')
	       if (!(retstr)){
	          return;
	        }
        
	        if (retstr==""){
	          return;
	        }
     
		var phacstr=retstr.split("^")
		GetAllCatNew(phacstr[0],phacstr[1])
		*/
		PhcCatNewSelect(gNewCatId,GetAllCatNew)
	    }
	});

		// ��ѯ��ť
		var SearchBT = new Ext.Toolbar.Button({
					text : $g('��ѯ'),
					tooltip :$g('�����ѯ'),
					iconCls : 'page_find',
					width : 70,
					height : 30,
					handler : function() {
						searchData();
					}
				});

		/**
		 * ��ѯ����
		 */
		function searchData() {
			// ��ѡ����
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			if (phaLoc == null || phaLoc.length <= 0) {
				Msg.info("warning", $g("���Ҳ���Ϊ�գ�"));
				Ext.getCmp("PhaLoc").focus();
				return;
			}
			var startDate = Ext.getCmp("StartDate").getRawValue();
			var endDate = Ext.getCmp("EndDate").getRawValue();
			if (startDate == undefined || startDate.length <= 0) {
				Msg.info("warning", $g("��ѡ��ʼ����!"));
				return;
			}
			if (endDate == undefined || endDate.length <= 0) {
				Msg.info("warning", $g("��ѡ���ֹ����!"));
				return;
			}
			var startTime=Ext.getCmp("StartTime").getRawValue();
			var endTime=Ext.getCmp("EndTime").getRawValue();
			if(startDate ==endDate && startTime>endTime){
				Msg.info("warning", $g("��ʼʱ����ڽ�ֹʱ�䣡"));
				return;
			}
			var stkGrpId=Ext.getCmp("StkGrpType").getValue();
			var stkCatId=Ext.getCmp("DHCStkCatGroup").getValue();
			var phcCatId=Ext.getCmp("PhcCat").getValue();
			var phcSubCatId=Ext.getCmp("PhcSubCat").getValue();
			var phcMinCatId=Ext.getCmp("PhcMinCat").getValue();
			var phcCatStr=phcCatId+','+phcSubCatId+','+phcMinCatId
			gStrParam=phaLoc+"^"+startDate+"^"+startTime+"^"+endDate+"^"+endTime
			+"^"+stkGrpId+"^"+stkCatId+"^"+phcCatStr+"^"+gNewCatIdOther;
			
			var pageSize=StatuTabPagingToolbar.pageSize;
			StockQtyStore.setBaseParam("Params",gStrParam);
			StockQtyStore.load({params:{start:0,limit:pageSize}});

		}
			// ��水ť
		var SaveAsBT = new Ext.Toolbar.Button({
					text : $g('���'),
					tooltip : $g('���ΪExcel'),
					iconCls : 'page_excel',
					width : 70,
					height : 30,
					handler : function() {
						ExportAllToExcel(StockQtyGrid);

					}
				});			
		// ��հ�ť
		var RefreshBT = new Ext.Toolbar.Button({
					text : $g('����'),
					tooltip : $g('�������'),
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
			Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 30));
			Ext.getCmp("EndDate").setValue(new Date());
			Ext.getCmp("StartTime").setValue('');
			Ext.getCmp("EndTime").setValue('');
			Ext.getCmp("StkGrpType").setValue('');
			Ext.getCmp("DHCStkCatGroup").setValue('');
			Ext.getCmp("PhcCat").setValue('');
			Ext.getCmp("PhcSubCat").setValue('');
			Ext.getCmp("PhcMinCat").setValue('');
			Ext.getCmp("PHCCATALLOTH").setValue("");
			gNewCatIdOther=""
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
		}
		
		
		
		var nm = new Ext.grid.RowNumberer();
		var sm = new Ext.grid.CheckboxSelectionModel();
		var StockQtyCm = new Ext.grid.ColumnModel([nm,  {
					header : "incil",
					dataIndex : 'incil',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : $g('����'),
					dataIndex : 'code',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header :$g( "����"),
					dataIndex : 'desc',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : $g("���"),
					dataIndex : 'spec',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : $g("��λ"),
					dataIndex : 'pUomDesc',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g("�����"),
					dataIndex : 'currStkQty',
					width : 100,
					align : 'right',
					sortable : true,
					renderer:SetNumber
				}, {
					header : $g("������"),
					dataIndex : 'OutQty',
					width : 100,
					align : 'right',
					sortable : true,
					renderer:SetNumber
				}, {
					header : $g("������"),
					dataIndex : 'InQty',
					width : 100,
					align : 'right',
					sortable : true,
					renderer:SetNumber
				}, {
					header : $g("�����"),
					dataIndex : 'sumOutAmt',
					width : 60,
					align : 'right',
				
					sortable : true,
					renderer:SetNumber
				}, {
					header : $g("�����۽��"),
					dataIndex : 'sumOutRpAmt',
					width : 60,
					align : 'right',
					
					sortable : true,
					renderer:SetNumber
				}, {
					header : $g("����"),
					dataIndex : 'sumInAmt',
					width : 100,
					align : 'right',
					
					sortable : true,
					renderer:SetNumber
				}, {
					header :$g("����۽��"),
					dataIndex : 'sumInRpAmt',
					width : 100,
					align : 'right',
					
					sortable : true,
					renderer:SetNumber
				}, {
					header : $g("������ҵ"),
					dataIndex : 'manf',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : $g("��λ"),
					dataIndex : 'sbDesc',
					width : 150,
					align : 'left',
					sortable : true
				}]);
		StockQtyCm.defaultSortable = true;

		// ����·��
		var DspPhaUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=jsLocItmMoveInfo&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["incil","code", "desc","spec", "manf", "OutQty","pUomDesc","sumOutAmt","sumOutRpAmt",
				"InQty", "sumInAmt", "sumInRpAmt", "sbDesc","currStkQty"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "incil",
					fields : fields
				});
		// ���ݼ�
		var StockQtyStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader,
					remoteSort:true
				});

		var StatuTabPagingToolbar = new Ext.PagingToolbar({
					store : StockQtyStore,
					pageSize : PageSize,
					displayInfo : true,
					displayMsg : $g('��ǰ��¼ {0} -- {1} �� �� {2} ����¼'),
					emptyMsg : "No results to display",
					prevText :$g( "��һҳ"),
					nextText : $g("��һҳ"),
					refreshText : $g("ˢ��"),
					lastText :$g( "���ҳ"),
					firstText : $g("��һҳ"),
					beforePageText : $g("��ǰҳ"),
					afterPageText : $g("��{0}ҳ"),
					emptyMsg : $g("û������")//,
					//doLoad:function(C){
						//var B={},
						//A=this.getParams();
						//B[A.start]=C;
						//B[A.limit]=this.pageSize;
						//B[A.sort]='desc';
						//B[A.dir]='ASC';
						
						//B['Params']=gStrParam;
						//if(this.fireEvent("beforechange",this,B)!==false){
						//	this.store.load({params:B});
						//}
					//}
				});

		var StockQtyGrid = new Ext.grid.GridPanel({
					id:'StockQtyGrid',
					region : 'center',
					cm : StockQtyCm,
					store : StockQtyStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : sm,
					loadMask : true,
					bbar : StatuTabPagingToolbar
            	
		});
		
	var HisListTab = new Ext.form.FormPanel({
			labelWidth : 60,
			region : 'north',
			title:$g("��涯����ѯ"),
			autoHeight:true,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			tbar : [SearchBT,'-', RefreshBT, '-',SaveAsBT],	
			items:[{
				layout : 'column',
			    defaults: { border:false},	
			    xtype: 'fieldset',
			    title:$g('��ѯ����'),
			    style:DHCSTFormStyle.FrmPaddingV,
			    items:[{
					columnWidth:0.25,
					xtype: 'fieldset',									
					items : [PhaLoc,StkGrpType]
				  },{
					columnWidth:0.2,
					xtype: 'fieldset',									
					items : [StartDate,StartTime]
				  },{
					columnWidth:0.2,
					xtype: 'fieldset',									
					items : [EndDate,EndTime]
				  },{
					columnWidth:0.25,
					xtype: 'fieldset',						
					items : [{xtype:'compositefield',items:[PHCCATALLOTH,PHCCATALLOTHButton]},DHCStkCatGroup]
				  }]	
			}]				
			
		});

		// 5.2.ҳ�沼��
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [ 
						{
			                region: 'north',
			                height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
			                layout: 'fit', // specify layout manager for items
			                items:HisListTab
			            }, {
			                region: 'center',
			                title: $g('��ϸ'),			               
			                layout: 'fit', // specify layout manager for items
			                items: StockQtyGrid       
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
	
})