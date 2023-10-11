	///chenying 2020-05-09
	/*使用范例：
	///多院区医院下拉框
	var hospComp=GenHospComp("PAC_AdmReason");	  //hospComp.getValue()
	//下拉框选择一条医院记录后执行此函数	
	hospComp.on('select',function (){
		
	});
	*/
	document.write("<style>.button-example {   background: url(../scripts_lib/ext3.2.1/docs/resources/example.gif) left top no-repeat !important;}  </style>")
	document.write("<style>.icon-save {   background-image: url(../scripts/bdp/Framework/icons/save.gif) !important;}  </style>")
	document.write("<style>.icon-close{   background-image: url(../scripts/bdp/Framework/icons/cross.gif) !important;}  </style>")
	
	var HospComboHiddenFlag=(tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPHospAut")=="Y"?false:true);
	function GenHospComp(objectName,SessionStr){
		SessionStr = SessionStr||"";
		var objstore=new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPMappingHOSP&pClassQuery=GetHospDataForCombo"+"&tablename="+objectName+"&SessionStr="+SessionStr}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [ 'HOSPRowId', 'HOSPDesc' ])
		})
		var _HospListobj = new Ext.form.ComboBox({
			id:'_HospList',
			labelSeparator:"",
			DataType:tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetDataType",objectName),  //公有G，私有S，绝对私有A，管控C
			width:250,
			fieldLabel : $g('医院'),
			store : objstore,
			editable:false,
			queryParam : 'desc',
			triggerAction : 'all',
			forceSelection : true,
			selectOnFocus : false,
			listWidth :250,
			valueField : 'HOSPRowId',
			displayField : 'HOSPDesc'
		});
		objstore.load({
		       callback: function () {
			      var thisHospId=tkMakeServerCall("web.DHCBL.BDP.BDPMappingHOSP","GetDefHospIdByTableName",objectName,session['LOGON.HOSPID'])
			       _HospListobj.setValue(thisHospId);   //初始赋值为当前登录科室的院区
			       Ext.getCmp('_HospList').fireEvent('select',Ext.getCmp('_HospList'),Ext.getCmp('_HospList').getStore().getById(thisHospId))  //触发select事件
		        },
		        scope: objstore,
		        add: false
		});
		return _HospListobj
		
	}
	
	function GenHospPanel(_HospListobj){
		//2020-06-15  公有数据不显示医院下拉框。
		var HospComboHiddenFlag=((tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPHospAut")=="Y")&&(_HospListobj.DataType!="G"))?false:true
		var obj={
			frame:true,
			xtype: 'panel',
	        region: 'north',
	        layout:'form',
	        hidden:HospComboHiddenFlag,
	        labelAlign : 'right',
			labelWidth : 30,
			items:[_HospListobj],
	        height: 35,
	        border: false
	    }
		return obj;
	}
	/*使用范例：
	//数据关联医院按钮
    var HospWinButton = GenHospWinButton("PAC_AdmReason");
    //绑定点击事件
    HospWinButton.on("click" , function(){
        GenHospWin(objectName,objectId,callback).show()   
    });
    */
	function GenHospWin(objectName,objectId,callback){
	    var _Hospgridds = new Ext.data.Store({
	                proxy : new Ext.data.HttpProxy({
	                	url : "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPMappingHOSP&pClassQuery=GetHospDataForCloud"+"&tablename="+objectName }),
	                reader : new Ext.data.JsonReader({
	                            totalProperty : 'total',
	                            root : 'data',
	                            successProperty : 'success'
	                        }, [{name : 'LinkFlag', mapping : 'LinkFlag', type : 'string' }, 
	                            {name : 'HOSPRowId',mapping : 'HOSPRowId',type : 'string'},
	                            {name : 'HOSPDesc',mapping : 'HOSPDesc',type : 'string' }, 
	                            {name : 'MappingID',mapping : 'MappingID',type : 'string' } 
	                        ]) 
	     });
	     
	   var gridsm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : false, checkOnly : false, width : 20,
				listeners:{
					rowdeselect : function( e ,  rowIndex , record  ) 
					{ _HospgridObj.getStore().getAt(rowIndex).set("LinkFlag","N") },    //当反选一个行时触发
					rowselect : function(  e ,  rowIndex , record ) 
					{ _HospgridObj.getStore().getAt(rowIndex).set("LinkFlag","Y") }   //当选中一行数据时触发 
				}
		});
		
	    var _HospgridObj = new Ext.grid.GridPanel({
	                region : 'center',
	                width : 550,
	                height : 350,
	                closable : true,
	                store : _Hospgridds,
	                trackMouseOver : true,
	                columnLines : true, //在列分隔处显示分隔符
	                sm:gridsm,
	                columns : [gridsm,
	                       	{header : $g('关联'), width : 40,sortable : true, dataIndex : 'LinkFlag',hidden:true}, 
	                        {header : $g('医院ID'),width : 160, sortable : true, dataIndex : 'HOSPRowId',hidden:true},
	                        {header : $g('医院名称'), width : 160, sortable : true, dataIndex : 'HOSPDesc'}, 
	                        {header : $g('与医院对照ID'), width : 160,  sortable : true,  dataIndex : 'MappingID',hidden:true }],
	                stripeRows : true ,
	                stateful : true,
	                viewConfig : {
	                    forceFit : true
	                }
	            });
	        
		var obj = new Ext.Window({
		        title : $g('数据关联医院（请点击左侧勾选框勾选数据，然后点保存按钮）'),
		        width : 550,
		        height : Ext.getBody().getHeight()*0.85,
		        layout : 'fit',
		        plain : true, 
		        modal : true,
		        frame : true,
		        autoScroll : true,
		        collapsible : true,
		        hideCollapseTool : true,
		        titleCollapse : true,
		        bodyStyle : 'padding:3px',
		        constrain : true,
		        closeAction : 'hide',
		        buttonAlign : 'center',
		        items : [_HospgridObj],
		        buttons : [{
						text : $g('保存'),
						iconCls : 'icon-save',
						handler : function() {	
							var linkstr="";
						    _HospgridObj.getStore().each(function(record){
								if(linkstr!="") linkstr = linkstr+"^";
								linkstr = linkstr+record.get('HOSPRowId')+'$'+record.get('LinkFlag');
						    }, this);
						    Ext.Ajax.request({
								url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPMappingHOSP&pClassMethod=UpdateHOSP",
								method:'POST',
								params:{
									'tableName':objectName,
									'dataid':objectId,
									'HospIDs':linkstr
								},
								callback : function(options, success, response) {
									if (success) {
										if ((response.responseText).indexOf("-1")>-1)
										{
											Ext.Msg.show({
													title : $g('提示'),
													msg : $g('保存失败！')+response.responseText.split("^")[1],
													icon : Ext.Msg.INFO,
													buttons : Ext.Msg.OK,
													fn : function(btn){
														_HospgridObj.getStore().baseParams={tablename : objectName, dataid : objectId };
														_HospgridObj.getStore().load({
																scope: this,
																callback : function(records, options, success) {
																	var records=[];//存放选中记录  
																	for(var i=0;i<_HospgridObj.getStore().getCount();i++){  
																		var record = _HospgridObj.getStore().getAt(i);  
																		if(record.data.LinkFlag=='Y'){ records.push(record);   }  
																	}  
																	gridsm.selectRecords(records);//执行选中已对照的医院记录  
																}
														});    
													}
												});
										
										}
										else
										{
											obj.hide();
											Ext.Msg.show({
														title : $g('提示'),
														msg : $g('保存成功！'),
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK
													});
											if ("function" == typeof callback) callback() //调用回调函数
										}
									} 
									else {
										Ext.Msg.show({
													title : $g('提示'),
													msg : $g('异步通讯失败,请检查网络连接！'),
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								}
							});  
						}
					}, {
						text : $g('关闭'),
						iconCls : 'icon-close',
						handler : function() {
							obj.hide();
						}
				}],
		        listeners : {
                        "show" : function(){
                                _HospgridObj.getStore().baseParams={tablename : objectName, dataid : objectId };
								_HospgridObj.getStore().load({
										scope: this,
										callback : function(records, options, success) {
											var records=[];//存放选中记录  
											for(var i=0;i<_HospgridObj.getStore().getCount();i++){  
												var record = _HospgridObj.getStore().getAt(i);  
												if(record.data.LinkFlag=='Y'){ records.push(record);   }  
											}  
											gridsm.selectRecords(records);//执行选中已对照的医院记录  
										}
								});              
                        }
                    }
		    });
		    return obj;
	}
	
	
	///权限分配按钮
	function GenHospWinButton(objectName){
		var HospWinHiddenFlag=((tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPHospAut")=="Y")&&(tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetDataType",objectName)=="C"))?false:true
		var btnobj = new Ext.Toolbar.Button({
			text : $g('数据关联医院'),
			iconCls : 'button-example',
			hidden:HospWinHiddenFlag   //表定义为”管控”类型才显示此按钮
		});
		return btnobj;
	}
	