
	var currentMC="";
	var currentSA="";
	var currentMode="";
	var currentVen="";
	var currentVenName="";
	var currentType=""
	
	var clearButton=new Ext.Button({
		text:'���',
		iconCls:'page_clearscreen',
		handler:function()
		{
			currentMC="";
			Ext.getCmp('manfAdd').setValue("");
			MCGrid.getStore().removeAll();
			MCGrid.getView().refresh();
			SAGrid.getStore().removeAll();
			SAGrid.getView().refresh();
			Ext.getCmp('manfAdd').focus();

		}
	});
	
	//�����б���
	function GetColHeader(grid,dataIndex) 
	{
			var colIndex=GetColIndex(grid,dataIndex);		
			if (colIndex=="") return "";
			var colHeader=grid.getColumnModel().getColumnHeader(colIndex);
			return colHeader;					
	}
	
	var saveSaButton=new Ext.Button({
		text:'����',
		iconCls:'page_save',
		handler:function(b,e){
	
			var st=SAGrid.getStore();
			var cnt=st.getCount();
			var data="";
			for (var i=0;i<cnt;i++)
			{	var rec=st.getAt(i);
				if(rec.data.newRecord || rec.dirty)
				{
					var sa=rec.get('sa');
					var v1 = rec.get('v1');
					var lic1=rec.get('lic1');
					var licExp1=rec.get('licExp1');
					licExp1=(licExp1==null)?"":licExp1;
					if ((licExp1!="")&&(licExp1!=null))
					{licExp1=licExp1.format(ARG_DATEFORMAT);}
					var v2 = rec.get('v2');
					var lic2=rec.get('lic2');
					var licExp2=rec.get('licExp2');
					licExp2=(licExp2==null)?"":licExp2;
					if ((licExp2!="")&&(licExp2!=null))
					{licExp2=licExp2.format(ARG_DATEFORMAT);}
					var v3 = rec.get('v3');
					var lic3=rec.get('lic3');
					var licExp3=rec.get('licExp3');
					licExp3=(licExp3==null)?"":licExp3;
					if ((licExp3!="")&&(licExp3!=null))
					{licExp3=licExp3.format(ARG_DATEFORMAT);}
					var v4 = rec.get('v4');
					var lic4=rec.get('lic4');
					var licExp4=rec.get('licExp4');
					licExp4=(licExp4==null)?"":licExp4;
					if ((licExp4!="")&&(licExp4!=null))
					{licExp4=licExp4.format(ARG_DATEFORMAT);}
					var v5 = rec.get('v5');
					var lic5=rec.get('lic5');
					var licExp5=rec.get('licExp5');
					licExp5=(licExp5==null)?"":licExp5;
					if ((licExp5!="")&&(licExp5!=null))
					{licExp5=licExp5.format(ARG_DATEFORMAT);}
					
					//����֤
					if (v1=="") {
						var colIndex=GetColIndex(SAGrid,"v1");
						SAGrid.startEditing(i, colIndex);
						var colHeader=SAGrid.getColumnModel().getColumnHeader(colIndex);
						Msg.info("error","��<"+colHeader  +">����Ϊ��!");
						return ;
					}
					
					if ((v2=="")&&(v3!="")) {
						var colIndex=GetColIndex(SAGrid,"v2");
						SAGrid.startEditing(i, colIndex);
						var colHeader=SAGrid.getColumnModel().getColumnHeader(colIndex);
						Msg.info("error","��<"+colHeader+">����Ϊ��!");
						return ;
					}
					if (v4!="") {
						if(v2==""){
							var colIndex=GetColIndex(SAGrid,"v2");
							SAGrid.startEditing(i, colIndex);
							var colHeader=SAGrid.getColumnModel().getColumnHeader(colIndex);
							Msg.info("error","��<"+colHeader+">����Ϊ��!");
							return;
						}else if(v3==""){
							var colIndex=GetColIndex(SAGrid,"v3");
							SAGrid.startEditing(i, colIndex);
							var colHeader=SAGrid.getColumnModel().getColumnHeader(colIndex);
							Msg.info("error","��<"+colHeader+">����Ϊ��!");
							return;
						}
					}
					if (v5!="") {
						if(v2==""){
							var colIndex=GetColIndex(SAGrid,"v2");
							SAGrid.startEditing(i, colIndex);
							var colHeader=SAGrid.getColumnModel().getColumnHeader(colIndex);
							Msg.info("error","��<"+colHeader+">����Ϊ��!");
							return;
						}else if(v3==""){
							var colIndex=GetColIndex(SAGrid,"v3");
							SAGrid.startEditing(i, colIndex);
							var colHeader=SAGrid.getColumnModel().getColumnHeader(colIndex);
							Msg.info("error","��<"+colHeader+">����Ϊ��!");
							return;
						}else if(v4==""){
							var colIndex=GetColIndex(SAGrid,"v4");
							SAGrid.startEditing(i, colIndex);
							var colHeader=SAGrid.getColumnModel().getColumnHeader(colIndex);
							Msg.info("error","��<"+colHeader+">����Ϊ��!");
							return;
						}
					}
					//�ų���֤
					if (v2!="") 
					{
						if (v1==v2)
						{
							var col1=GetColIndex(SAGrid,"v1");
							var v1header=SAGrid.getColumnModel().getColumnHeader(col1);
							var col2=GetColIndex(SAGrid,"v2");
							var v2header=SAGrid.getColumnModel().getColumnHeader(col2);
							Msg.info('error',"��<"+v1header+">��<"+v2header+'>��ֵ������ͬ!');
							return;
						}						
					}
					if (v3!="")
					{
						if (v3==v1)
						{
							var col1=GetColIndex(SAGrid,"v1");
							var v1header=SAGrid.getColumnModel().getColumnHeader(col1);
							var col3=GetColIndex(SAGrid,"v3");
							var v3header=SAGrid.getColumnModel().getColumnHeader(col3);
						
							Msg.info('error',"��<"+v1header+">��<"+v3header+'>��ֵ������ͬ!');
							return;
						}
						
						if 	(v3==v2)
						{
							var col2=GetColIndex(SAGrid,"v2");
							var v2header=SAGrid.getColumnModel().getColumnHeader(col2);
							var col3=GetColIndex(SAGrid,"v3");
							var v3header=SAGrid.getColumnModel().getColumnHeader(col3);
						
							Msg.info('error',"��<"+v2header+">��<"+v3header+'>��ֵ������ͬ!');
							return;

						}
					}
					if(v4!=""){
						var VendorArr = [v1, v2, v3, v4];
						var tmpArr = [];
						for(var n=0,len=VendorArr.length; n<len; n++){
							Vendor = VendorArr[n];
							if(tmpArr.indexOf(Vendor) < 0){
								tmpArr.push(Vendor);
							}
						}
						var rowIndex = SAGrid.getStore().indexOf(rec);
						if(tmpArr.length !== VendorArr.length){
							Msg.info('error', '�����'+(rowIndex+1)+'�й�Ӧ���ظ�!');
							return false;
						}
					}
					if(v5!=""){
						var VendorArr = [v1, v2, v3, v4,v5];
						var tmpArr = [];
						for(var n=0,len=VendorArr.length; n<len; n++){
							Vendor = VendorArr[n];
							if(tmpArr.indexOf(Vendor) < 0){
								tmpArr.push(Vendor);
							}
						}
						var rowIndex = SAGrid.getStore().indexOf(rec);
						if(tmpArr.length !== VendorArr.length){
							Msg.info('error', '�����'+(rowIndex+1)+'�й�Ӧ���ظ�!');
							return false;
						}
					}
					var thisRow=sa+"!"+v1+"^"+lic1+"^"+licExp1+"^"+v2+"^"+lic2+"^"+licExp2+"^"+v3+"^"+lic3+"^"+licExp3+"^"+v4+"^"+lic4+"^"+licExp4+"^"+v5+"^"+lic5+"^"+licExp5;
					if (data=="")
					{data=thisRow;}
					else
					{
						data=data+xRowDelim()+thisRow ;
					}
				}
			}
			if (data=="")
			{
				Msg.info('warning','û���豣������ݣ�') ;
				return;
			}
			else
			{
				Ext.Ajax.request({
					url:"dhcstm.itmmanfcertsaaction.csp?actiontype=saveSA",
					params:{
						mc:currentMC,
						data:data
					},
					success:function(result)
					{
						var jsonData = Ext.util.JSON.decode(result.responseText.replace(/\r/g,"").replace(/\n/g,"")); 
						var info=jsonData.info;
						if ((info==-10)||(info==-11) )
						{
							Msg.info('error','�����ύ�Ĺ�Ӧ����Ȩ�Ѵ���!');
							return;
						}
						else
						{
							Msg.info('success','����ɹ���');							
						}
							
						SAGrid.getStore().load({params:{'mc':currentMC}}) ;
					},
					failure:function()
					{
					}
				});
			}
			
		}
	});
	
	var cancelButton=new Ext.Toolbar.Button({text:'ȡ��',handler:function(b,e){
		var w =Ext.getCmp('addnewsawin');
		if (w) w.close();
	}});
	
		 //����
	var manfAdd = new Ext.ux.ComboBox({
		fieldLabel : '����',
		id : 'manfAdd',
		name : 'manfAdd',
		 // labelStyle: 'font-weight:bold;',
		anchor:'95%',
		filterName:'PHMNFName',
		store : PhManufacturerStore,
		valueField : 'RowId',
		displayField : 'Description',
		listeners:{
			'select':function(b){
				currentMC="";
				var manf=b.getValue();	
				MCGridStore.load({params:{'manf':manf}});
			}
		}	
	});

	
	var AddMcBT=new Ext.Button({
		text:'����һ��',
		tooltip:'�������',
		iconCls:'page_add',
		handler:function(){
			addMC();
		}
	});
	
	var DelMcBT=new Ext.Button({
		text:'ɾ��һ��',
		tooltip:'',
		iconCls:'page_delete',
		handler:function()
		{
			var sm=Ext.getCmp("MCGrid").getSelectionModel();
			var rec=sm.getSelected();
			if (!rec) return;
			var mc=rec.get('mc');
			// alert(mc);
			if (mc!=="") 		{
			
				Ext.Msg.show({
						title:'��ʾ',
						msg:'�Ƿ�ȷ��ɾ����',
						buttons:Ext.Msg.YESNO,
						icon: Ext.MessageBox.QUESTION,
						fn:function(b,txt){
							if (b=='no')	{return;}
							else 	
							{
								DelMc(mc);
							}
						}
				});
			}			
			else
			{
				Ext.getCmp("MCGrid").getStore().remove(rec);
				
			}	
		}
	});
	
	var mcPicManageButton=new Ext.Button({
		text:'�༭����ͼƬ',
		handler:function()
		{		
			var sm=Ext.getCmp('MCGrid').getSelectionModel();
			var rec=sm.getSelected();
			if (!rec)
			{
			  return;  
			}
			var rowid=rec.get('mc');
			if (rowid=="") 
			{
				Msg.info("warning","���ȱ���!");
				return;	
			}
			// alert(rowid);
			var PicUrl = 'dhcstm.itmmanfcertsaaction.csp?actiontype=MCPic';
			// ͨ��AJAX��ʽ���ú�̨����
			var proxy = new Ext.data.HttpProxy({
				url : PicUrl,
				method : "POST"
			});

			// ָ���в���
			var fields = ["rowid", "manf","manfName", "picsrc","type",'certNo'];
			// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
			var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				// id : "rowid",
				fields : fields
			});
			// ���ݼ�
			var PicStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
			
			var mc=rowid;
			EditMcPic(PicStore,mc)  					
		}
	})	;
	
	function saPic(mode,sa,ven,venName,picType)
	{
		//mode=0,1
		// 0 - �鿴
		// 1 - �༭	
		var PicUrl = 'dhcstm.itmmanfcertsaaction.csp?actiontype=SAPic';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
			url : PicUrl,
			method : "POST"
		});

		// ָ���в���
		var fields = ["rowid", "ven","venName", "picsrc","type"];
		
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			// id : "rowid",
			fields : fields
		});
		// ���ݼ�
		var PicStore = new Ext.data.Store({
			proxy : proxy,
			reader : reader
		});
		
		///ִ����ʾ
		EditSaPic(PicStore,mode,sa,ven,venName,picType);			
		
	}
 
	var saPicManageButton=new Ext.Button({
		text:'�����Ȩ����ͼƬ',
		iconCls:'',
		handler:function()
		{
			var sm=Ext.getCmp('SAGrid').getSelectionModel();
			var rec=sm.getSelected();
			if (!rec)
			{
			  return;  
			}
			var rowid=rec.get('sa');
			if (rowid=="") {
				Msg.info("warning",'���ȱ���!');
				return ;}
			var ven="";
			var venName="";
			var type="";
			saPic(0,rowid,ven,venName,type) ;
		
		}
	})	;	
	
	var addSaOtherPic=new Ext.Button({
		text:'���ӹ�Ӧ������ͼƬ',
		disabled:true,
		id:'addSaOtherPic',
		iconCls:'',
		handler:function()
		{
			var sm=Ext.getCmp('SAGrid').getSelectionModel();
			var rec=sm.getSelected();
			if (!rec)
			{
			  Msg.info("warning",'��ѡ��Ӧ��!');
			  return;  
			}
			var rowid=rec.get('sa');
			if (rowid=="") {
				Msg.info("warning",'���ȱ���!');
				return 
			}
					
			var picType=Ext.getCmp('saOtherPicList').getValue()
			if (picType=="")
			{
				Msg.info('warning','��ѡ����������');
				return;			
			}
			// saPic()
			//alert(picType);
			saPic(1,rowid,"","",picType)
			
		}
	})	;	

	
	var saOtherPicList=new Ext.form.ComboBox({
		fieldLabel:'��Ӧ���������',
		emptyText:'��Ӧ���������...',
		id:'saOtherPicList',
		editable:false,
		mode: 'local',
		 triggerAction: 'all',
		store:new Ext.data.ArrayStore({
	        // id: 0,
			
	        fields: [
	            'typeCode',
	            'typeDesc'
	        ],
	        data: [['hospAllowed','��Ժ��������'],['saOther','��������'],['','..']]  
			}),
		valueField: 'typeCode',
    	displayField: 'typeDesc',			
		listeners:
		{
			'select':function(cb)	{ 
				if (cb.getValue()!=""){
					Ext.getCmp('addSaOtherPic').setDisabled(false) ;}
				else
				{
					Ext.getCmp('addSaOtherPic').setDisabled(true) ;
					}
				}	
		}

	})
	
	 
	
	function DelMc(mc)
	{		
		Ext.Ajax.request({
			url:'dhcstm.itmmanfcertsaaction.csp?actiontype=DelMc',
			params:{mc:mc},
			success:function(result)
			{
				var jsonData = Ext.util.JSON.decode(result.responseText.replace(/\r/g,"").replace(/\n/g,"")); 
				if (jsonData.success=='true')
				{
					Msg.info('success','ɾ���ɹ�.'); 
					Ext.getCmp('MCGrid').getStore().reload();
				}
				else
				{Msg.info('error','ɾ��ʧ��!'); 
			    }
			}
			
		});
	}
	function trim(str) {
	  return str.replace(/(^\s+)|(\s+$)/g, "");
	}
	var saveMcBt=new Ext.Toolbar.Button({
		text:'����',
		iconCls:'page_save',
		handler:function()
		{
			var mcData="";
			
			var st=Ext.getCmp('MCGrid').getStore();
			var cnt=st.getCount();
			
			for (var i=0;i<cnt;i++)
			{
				var rec=st.getAt(i);
				
				if(rec.data.newRecord || rec.dirty)
				{		
					var IMC=rec.get('mc');
					var manf=rec.get('manf');
					var certNo=rec.get('cert');
					var certNoExp=rec.get('certExp');
					
					if (certNoExp==null) certNoExp="";
					if  (certNoExp!='')
					{
						certNoExp=certNoExp.format(ARG_DATEFORMAT);
					}
					//
					certNo=trim(certNo);
					//
					if  ((certNo=="")||(certNo==null))
					{
						Msg.info('error','ע��֤�Ų���Ϊ��');
						var colindex=GetColIndex(Ext.getCmp('MCGrid'),"cert");
						Ext.getCmp('MCGrid').startEditing(i,colindex);
						return ;
					}
					
					if (mcData!='')
					{
						mcData=mcData+xRowDelim()+IMC+"^"+manf+"^"+certNo+"^"+certNoExp;
					}
					else
					{
						mcData=IMC+"^"+manf+"^"+certNo+"^"+certNoExp;
					}
				}
				
			}
			if (mcData!="")
			{
				Ext.Ajax.request({
					url:'dhcstm.itmmanfcertsaaction.csp?actiontype=saveMC',
					params:{mcData:mcData},
					method:'post',
						waitMsg:'������...',
					success:function(result,request)
					{
						var jsonData = Ext.util.JSON.decode(result.responseText.replace(/\r/g,"").replace(/\n/g,""));
						if (jsonData.success == 'true') {
							Msg.info('success','����ɹ�!');
							MCGrid.getStore().reload();
						}
						else
						{
							var info=jsonData.info;
							if ((info==-10)||(info==-11) )
							{
								Msg.info('error','�����ύ��ע��֤�Ѵ���!');return;
							}
							else
							{
								Msg.info('error','����ʧ��!');
							}
						}	
						
					},
					failure:function()
					{}
				})
			}
			else
			{
				Msg.info('warning','û����Ҫ���������!');
				return ;
			}	
			
		}
	})
	
	
	
	MCGridStore=new Ext.data.Store({
		url:'dhcstm.itmmanfcertsaaction.csp?actiontype=QueryMcListByManf',
		reader:new Ext.data.JsonReader(
			{
				root:'rows',
				totalProperty:'results'},['mc','manf','manfName','cert',{name:'certExp',type:'date',dateFormat:DateFormat}]),
		listeners:{
			'load':function()
			{
				var g=Ext.getCmp('SAGrid');
				if (!g) return;
				g.getStore().removeAll();
				g.getView().refresh();
				
			}
			
		}
					
	});
	
	var chkSm=new Ext.grid.CheckboxSelectionModel({
		singleSelect:true,
		listeners:{
			'rowselect':function(sm,i,rec)
			{
				var mc=rec.get("mc") ;
				currentMC=mc ;
				Ext.getCmp('SAGrid').getStore().load({params:{'mc':mc}}) ;
			}
		}
	});
	var MCGrid=new Ext.grid.EditorGridPanel({
		id:'MCGrid',
		store:MCGridStore,
		clicksToEdit:true,
		loadMask:true,
		// stripeRows:true,
		split:true,
		height:210,
		region:'center',
		tbar:[AddMcBT,'-',DelMcBT,'-',saveMcBt,'-',mcPicManageButton],
		sm:chkSm,
		title:'ע��֤',
		cm:new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),chkSm,
		{header:'mc',dataIndex:'mc',hidden:true},
		{header:'manf',dataIndex:'manf',hidden:true},
		{
			header:'��������',
			width:220,
			dataIndex:'manfName'
		},{
			header:'ע��֤��',
			width:220,
			dataIndex:'cert',
			editor:new Ext.form.TextField({})
		},{
			header:'ע��֤Ч��',
			width:120,
			dataIndex:'certExp',
			renderer : Ext.util.Format.dateRenderer(DateFormat),
			editor: new Ext.ux.DateField({
				selectOnFocus : true
			})
			
		}])
		
	});
	var VendorSA = new Ext.ux.VendorComboBox({
		fieldLabel : '��Ӧ��',
		id : 'VendorSA',
		name : 'VendorSA',
		anchor : '90%',
		emptyText : '��Ӧ��...',
		rcFlag:true,
		listWidth : 250,
		// params : {LocId : 'locField',ScgId : 'groupField'},
		listeners:{
			
		}
	});		
	
	var VendorSA2 = new Ext.ux.VendorComboBox({
		fieldLabel : '��Ӧ��',
		id : 'VendorSA2',
		name : 'VendorSA2',
		anchor : '90%',
		emptyText : '��Ӧ��...',
		listWidth : 250,
		// params : {LocId : 'locField',ScgId : 'groupField'},
		listeners:{
		
		}
	});	
	var VendorSA3 = new Ext.ux.VendorComboBox({
		fieldLabel : '��Ӧ��',
		id : 'VendorSA3',
		name : 'VendorSA3',
		anchor : '90%',
		emptyText : '��Ӧ��...',
		listWidth : 250,
		// params : {LocId : 'locField',ScgId : 'groupField'},
		listeners:{
			// specialkey:function(field,e){
				// if (e.getKey() == Ext.EventObject.ENTER) {
					// PlanGrid.addNewRow();
				// }
			// }
		}
	});
	var VendorSA4 = new Ext.ux.VendorComboBox({
		fieldLabel : '��Ӧ��',
		id : 'VendorSA4',
		anchor : '90%',
		emptyText : '��Ӧ��...',
		listWidth : 250
	});	
	var VendorSA5 = new Ext.ux.VendorComboBox({
		fieldLabel : '��Ӧ��',
		id : 'VendorSA5',
		anchor : '90%',
		emptyText : '��Ӧ��...',
		listWidth : 250
	});	
	SAStore=new Ext.data.Store({
		url:'dhcstm.itmmanfcertsaaction.csp?actiontype=querySAByMC',
		reader:new Ext.data.JsonReader(
			{
				root:'rows',
				totalProperty:'results'
			},
			['sa','v1','name1','lic1',{name:'licExp1',type:'date',dateFormat:DateFormat},'v2','name2','lic2',{name:'licExp2',type:'date',dateFormat:DateFormat} ,'v3','name3','lic3',{name:'licExp3',type:'date',dateFormat:DateFormat},
				'v4','name4','lic4',{name:'licExp4',type:'date',dateFormat:DateFormat},'v5','name5','lic5',{name:'licExp5',type:'date',dateFormat:DateFormat}])		
	});


	
	var AddSaBT=new Ext.Button({
		text:'����һ��',
		tooltip:'�������',
		iconCls:'page_add',
		handler:function(){
			addSA();
		}
	});
	
	var DelSaBT=new Ext.Button({
		text:'ɾ��һ��',
		tooltip:'',
		iconCls:'page_delete',
		handler:function()
		{
			var sm=Ext.getCmp("SAGrid").getSelectionModel();
			var rec=sm.getSelected();
			if (!rec) return;
			
			var sa=rec.get('sa');
			// alert(sa);
			if (sa!=="")
			{
				Ext.Msg.show({
					title:'��ʾ',
					msg:'�Ƿ�ȷ��ɾ����',
					buttons:Ext.Msg.YESNO,
					icon: Ext.MessageBox.QUESTION,
					fn:function(b,txt){
						if (b=='no')	{return;}
						else 	
						{
							DelSa(sa);
						}
					}
				});
			}
			else
			{Ext.getCmp("SAGrid").getStore().remove(rec);}	

		}
	})		
	function DelSa(sa)
	{
		
		Ext.Ajax.request({
			url:'dhcstm.itmmanfcertsaaction.csp?actiontype=DelSa',
			params:{sa:sa},
			success:function(result)
			{
				var jsonData = Ext.util.JSON.decode(result.responseText.replace(/\r/g,"").replace(/\n/g,"")); 
				if (jsonData.success=='true')
				{
					Msg.info('success','ɾ���ɹ�.'); 
					Ext.getCmp('SAGrid').getStore().reload();
				}
				else
				{Msg.info('error','ɾ��ʧ��!'); 
			    }
			},
			failure:function()
			{
				Msg.info('error','ɾ��ʧ��!'); return;
			}
		});
		
		
	}
	var chksm1=new Ext.grid.CheckboxSelectionModel({
			singleSelect:true
		});
		
	var SAGrid=new Ext.grid.EditorGridPanel({
		id:'SAGrid',
		clicksToEdit:true,
		autoScroll:true,
		store:SAStore,
		height:250,
		region:'south',
		split:true,
		title:'��Ӧ����Ȩ��',
		// sm:new Ext.grid.CheckboxSelectionModel({
			// singleSelect:true
		// }),
		sm:chksm1,
		tbar:[AddSaBT,'-',DelSaBT,'-',saveSaButton,'-',saPicManageButton,'-',saOtherPicList,addSaOtherPic],
		cm:new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),chksm1,
		{header:'sa',dataIndex:'sa',hidden:true},
		{
			header:'��Ӧ��(һ��)',
			width:160,
			dataIndex:'v1',
			editor : new Ext.grid.GridEditor(VendorSA),
			renderer : Ext.util.Format.comboRenderer2(VendorSA,"v1","name1")
		
		},{
			header:'��Ȩ��(һ��)',
			width:75,
			dataIndex:'lic1',
			editor:new Ext.form.TextField({})
		},{
			header:'',
			width:40,
			tooltip:'����༭',
			 renderer: function (value, meta, record) {  
				 var formatStr = "<button  onclick=addVenPics1() class='order_bit'>..</button>";   
				 var resultStr = String.format(formatStr);  
				 return "<div class='controlBtn'>" + resultStr + "</div>";  
			} .createDelegate(this),  
			css: "text-align:center;height:5"
			
		},{
			header:'��ȨЧ��(һ��)',
			width:100,
			dataIndex:'licExp1',
			 xtype:'datecolumn',
			renderer : Ext.util.Format.dateRenderer(DateFormat),
			editor:new Ext.ux.DateField({
				selectOnFocus : true
				
			})
		},{
			header:'��Ӧ��(����)',
			width:160,
			dataIndex:'v2',
			editor : new Ext.grid.GridEditor(VendorSA2),
			renderer : Ext.util.Format.comboRenderer2(VendorSA2,"v2","name2")
		},{
			header:'��Ȩ��(����)',
			width:75,
			dataIndex:'lic2',
			editor:new Ext.form.TextField({})
		},{
			header:'...',
			width:40,
			 renderer: function (value, meta, record) {  
				 var formatStr = "<button  onclick=addVenPics2() class='order_bit'>..</button>";   
				 var resultStr = String.format(formatStr);  
				 return "<div class='controlBtn'>" + resultStr + "</div>";  
			} .createDelegate(this),  
			css: "text-align:center;height:9"
			
		},{
			header:'��ȨЧ��(����)',
			width:70,
			dataIndex:'licExp2',
			xtype:'datecolumn',
			editor:new Ext.ux.DateField
		},{
			header:'��Ӧ��(����)',
			width:160,
			dataIndex:'v3',
			editor : new Ext.grid.GridEditor(VendorSA3),
			renderer : Ext.util.Format.comboRenderer2(VendorSA3,"v3","name3")
		},{
			header:'��Ȩ��(����)',
			width:75,
			dataIndex:'lic3',
			editor:new Ext.form.TextField({})
		},{
			header:'...',
			width:40,
			 renderer: function (value, meta, record) {  
				 var formatStr = "<button  onclick=addVenPics3() class='order_bit'>..</button>";   
				 var resultStr = String.format(formatStr);  
				 return "<div class='controlBtn'>" + resultStr + "</div>";  
			} .createDelegate(this),  
			css: "text-align:center;height:9"
			
		},{
			header:'��ȨЧ��(����)',
			width:70,
			dataIndex:'licExp3',
			xtype:'datecolumn',
			editor:new Ext.ux.DateField
		},{
			header:'��Ӧ��(�ļ�)',
			width:160,
			dataIndex:'v4',
			editor : new Ext.grid.GridEditor(VendorSA4),
			renderer : Ext.util.Format.comboRenderer2(VendorSA4,"v4","name4")
		},{
			header:'��Ȩ��(�ļ�)',
			width:75,
			dataIndex:'lic4',
			editor:new Ext.form.TextField({})
		},{
			header:'...',
			width:40,
			 renderer: function (value, meta, record) {  
				 var formatStr = "<button  onclick=addVenPics4() class='order_bit'>..</button>";   
				 var resultStr = String.format(formatStr);  
				 return "<div class='controlBtn'>" + resultStr + "</div>";  
			} .createDelegate(this),  
			css: "text-align:center;height:9"
		},{
			header:'��ȨЧ��(�ļ�)',
			width:70,
			dataIndex:'licExp4',
			xtype:'datecolumn',
			editor:new Ext.ux.DateField
		},{
			header:'��Ӧ��(�弶)',
			width:160,
			dataIndex:'v5',
			editor : new Ext.grid.GridEditor(VendorSA5),
			renderer : Ext.util.Format.comboRenderer2(VendorSA5,"v5","name5")
		},{
			header:'��Ȩ��(�弶)',
			width:75,
			dataIndex:'lic5',
			editor:new Ext.form.TextField({})
		},{
			header:'...',
			width:40,
			 renderer: function (value, meta, record) {  
				 var formatStr = "<button  onclick=addVenPics5() class='order_bit'>..</button>";   
				 var resultStr = String.format(formatStr);  
				 return "<div class='controlBtn'>" + resultStr + "</div>";  
			} .createDelegate(this),  
			css: "text-align:center;height:9"
		},{
			header:'��ȨЧ��(�弶)',
			width:70,
			dataIndex:'licExp5',
			xtype:'datecolumn',
			editor:new Ext.ux.DateField
		}
		])
	});
	
	function addVenPics1()
	{
		var sm=Ext.getCmp('SAGrid').getSelectionModel();
		var rec=sm.getSelected();
		var sa=rec.get('sa');
		if (sa=="") return;
		var ven=rec.get('v1');
		var venName=rec.get("name1");
		if (ven=="") return;
		var type='saAuthorizLic';
		saPic(1,sa,ven,venName,type);
		  
	}
	function addVenPics2()
	{
	 var sm=Ext.getCmp('SAGrid').getSelectionModel();
		var rec=sm.getSelected();
		var sa=rec.get('sa');
		if (sa=="") return;
		var ven=rec.get('v2');
		var venName=rec.get("name2");
		if (ven=="") return;
		var type='saAuthorizLic';
		saPic(1,sa,ven,venName,type);
		  
	}
	function addVenPics3()
	{
		var sm=Ext.getCmp('SAGrid').getSelectionModel();
		var rec=sm.getSelected();
		var sa=rec.get('sa');
		if (sa=="") return;
		var ven=rec.get('v3');
		var venName=rec.get("name3");
		if (ven=="") return;
		var type='saAuthorizLic';
		saPic(1,sa,ven,venName,type);		 
	}
	function addVenPics4()
	{
		var sm=Ext.getCmp('SAGrid').getSelectionModel();
		var rec=sm.getSelected();
		var sa=rec.get('sa');
		if (sa=="") return;
		var ven=rec.get('v4');
		var venName=rec.get("name4");
		if (ven=="") return;
		var type='saAuthorizLic';
		saPic(1,sa,ven,venName,type);
	}
	function addVenPics5()
	{
		var sm=Ext.getCmp('SAGrid').getSelectionModel();
		var rec=sm.getSelected();
		var sa=rec.get('sa');
		if (sa=="") return;
		var ven=rec.get('v5');
		var venName=rec.get("name5");
		if (ven=="") return;
		var type='saAuthorizLic';
		saPic(1,sa,ven,venName,type);
	}
	var topP=new Ext.Panel({
		layout:'column',frame:true,
		height:39,
		region:'north',
		items:[	
			 {xtype:'form',labelWidth:60,labelAlign : 'right',columnWidth:.36,items:[manfAdd] }

		]	
		
	});

	 Ext.onReady(function(){
		 
		 var mainPanel = new Ext.ux.Viewport({
			layout:'border',
			items:[topP,MCGrid,SAGrid],
			renderTo:'mainPanel',
			tbar:[clearButton,'-',cancelButton]
		});
	 });

	function addMC()
	{
		var manf=Ext.getCmp('manfAdd').getValue();
		var manfName=Ext.getCmp('manfAdd').getRawValue();
		if (manfName=='') 
		{
			Msg.info('error','��ѡ����!');
			return;			
		}
		
		var record = Ext.data.Record.create([
			{name:'mc'},
				{name:'manf'},
			{name:'manfName'},
			{name:'cert'},
			{name:'certExp'}
		]);
		var NewRecord=new record({
			mc:'',
			manf:manf,
			manfName:manfName,
			cert:'',
			certExp:''
		})
		Ext.getCmp('MCGrid').getStore().add(NewRecord);
		Ext.getCmp('MCGrid').getSelectionModel().selectLastRow();
		
		var colIndex=GetColIndex(MCGrid,"cert");
		if (!MCGrid.getColumnModel().isHidden(colIndex))
		{
			Ext.getCmp('MCGrid').getSelectionModel().selectLastRow();
			Ext.getCmp('MCGrid').startEditing(Ext.getCmp('MCGrid').getStore().getCount() - 1, colIndex);
		}
		
	}
	function addSA()
	{
		if (currentMC=="") 
		{
			Msg.info('error','��ѡ��ע��֤!');
			return;
		}
		var newRec = CreateRecordInstance(SAStore.fields,{});
		SAStore.add(newRec);
		// Ext.getCmp("SAGrid").getSelectionModel().selectLastRow();
		var colIndex=GetColIndex(Ext.getCmp("SAGrid"),"v1");
		if (!Ext.getCmp("SAGrid").getColumnModel().isHidden(colIndex))
		{
			Ext.getCmp("SAGrid").getSelectionModel().selectLastRow();
			Ext.getCmp("SAGrid").startEditing(Ext.getCmp("SAGrid").getStore().getCount() - 1, colIndex);
		}
	}
