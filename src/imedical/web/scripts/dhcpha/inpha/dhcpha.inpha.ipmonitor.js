///סԺҽ�����������JS
///Creator:LiangQiang
///CreatDate:2012-05-20
///

var unitsUrl = 'dhcpha.outpha.outmonitor.save.csp';
var waitMask;
var InputStr;
var UpRow;
var AppType="IA";
Ext.apply(Ext.form.Field.prototype,{labelSeparator:""});
Ext.onReady(function() {

  Ext.QuickTips.init();// ������Ϣ��ʾ
  Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
  Ext.Ajax.timeout = 900000;
  //StartDaTongDll();  //��ͨ������ҩ�ӿ�
 var oneTbar=new Ext.Toolbar({   

 items:[   
  
	 {xtype: 'tbtext',id:'baseDiag',text:'���:'},
	 {xtype: 'tbtext',id:'baseInfoDiag',width:'650',text:'',cls:'x-panel-header'}
 
 ]  
 
 }); 
 
 

  
  InitPatInfo();
 
	
     //����load Tab,����������
  var HrefRefresh = function (){
         
         
        var adm=PatInfo.adm; 
        var patientID=PatInfo.patientID 
		var p = Ext.getCmp("ToolsTabPanel").getActiveTab();	
		var iframe = p.el.dom.getElementsByTagName("iframe")[0];
		
		if (p.id=="framepaallergy"){
		  iframe.src = p.src + '?PatientID=' + patientID +'&EpisodeID='+ adm ;
		}
		
		if (p.id=="framerisquery"){
		 iframe.src = p.src + '?PatientID=' + patientID +'&EpisodeID='+ adm ;
		}
		
		if (p.id=="framelabquery"){
		  iframe.src = p.src + '?PatientID=' + patientID +'&EpisodeID='+ adm+'&NoReaded='+'1';
		}
		
		if (p.id=="frameprbrowser"){
		  //iframe.src='emr.record.browse.csp?EpisodeID='+ adm;// + '&PatientID=' + adm;
		  var LocID=session['LOGON.CTLOCID'] ;
		  iframe.src=p.src + '?PatientID=' + patientID + '&EpisodeID='+adm+'&EpisodeLocID=' + LocID;
		}	
		
	
		
		//��ϸ
		if (p.id=="frameordquery"){

			 if ((PatInfo.adm==0)&&(PatInfo.wardid==0))return ;
			 var params=GetListInput();
			 if (params==""){return;}
			 var input=PatInfo.adm+"^"+params;
             FindOrdDetailData(input);

		}
		

		//����ҽ��
		if (p.id=="frameadmordquery"){
		  iframe.src=p.src + '?EpisodeID=' + adm ;
		}
		
		//��Ժǰҩ˵��
		if (p.id=="frameothmedquery"){
		  iframe.src=p.src + '?EpisodeID=' + adm ;
		}
		
   }
 	////////////////////////////////////////////////////////////////////////////////////
	
	////////***********************  �������ұ�����        *********************** 
	
	/////////////////////////////////////////////////////////////////////////////////////  
                       
  var OkButton = new Ext.Button({
             width : 65,
             id:"OkButton",
             text: 'ͨ��',
             icon:"../scripts/dhcpha/img/update.png",
             listeners:{
                          "click":function(){   
                             
                              CommontOk();
                              
                              }   
             }
             
             
             })
             
  var BadButton = new Ext.Button({
             width : 65,
             id:"BadButton",
             text: '�ܾ�',
             icon:"../scripts/dhcpha/img/cancel.png",
             listeners:{
                        "click":function(){
                            EditReason();
                        }
             }
             
             })
             
         

       
             
   var ListLogButton = new Ext.Button({
             width : 65,
             id:"ListLogBtn",
             text: '�鿴��־',
             icon:"../scripts/dhcpha/img/multiref.gif",
             listeners:{
                          "click":function(){   
                             
                              ListLogBtnClick();
                              
                              }   
             }
             
             
             })
             
     var DaTongYDTSButton = new Ext.Button({
             width : 65,
             id:"DaTongYDTSBtn",
             text: 'Ҫ����ʾ',
             icon:"../scripts/dhcpha/img/multiref.gif",
             listeners:{
                          "click":function(){   
                             
                              DaTongYDTSBtnClick();
                              
                              }   
             }
             
             
    })
    // ������ؼ�
	var StkLocGrpStore = new Ext.data.Store({
		autoLoad: true,
		proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=GetLocGrpDs',
			method : 'POST'
		}),
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'RowId'},['Description','RowId'])
				
	}); 

	var ConditionLocGField = new Ext.form.ComboBox({
	    id:'ConditionLocG',
	    fieldLabel:'������',
	    anchor:'90%',
	    width:150,
	    listWidth:250,
	    allowBlank:true,
	    store:StkLocGrpStore,
	    valueField:'RowId',
	    displayField:'Description',
	    emptyText:'ѡ�������...',
	    mode: 'local'
	});

       var DaTongAnalyseButton = new Ext.Button({
             width : 65,
             id:"DaTongAnalyseBtn",
             text: '��������',
             icon:"../scripts/dhcpha/img/multiref.gif",
             listeners:{
                          "click":function(){   
                             
                              //DaTongPrescAnalyse();
                              //MKPrescAnalyse();
							   Ext.Msg.show({title:'ע��',msg:'��͵�����������ҩ����ӿ�,��δ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								
                              
                              }   
             }
             
             
    })          
    
  ///ҽ����ϸ����table 
  var sm = new Ext.grid.CheckboxSelectionModel(); 
  var nm = new Ext.grid.RowNumberer();
  var orddetailgridcm = new Ext.grid.ColumnModel([nm,sm,
  
        {header:'������ҩ',dataIndex:'druguse',width: 80,menuDisabled :'false',renderer:showMKHMTL},
        {header:'��˽��',dataIndex:'result',width:80},
        {header:'�ǼǺ�',dataIndex:'patid',width: 90,menuDisabled :'false'},
        {header:'����',dataIndex:'patname',width: 75,menuDisabled :'false'},
        {header:'adm',dataIndex:'adm',hidden:'true',ortable:'false'},
        {header:'ҩƷ����',dataIndex:'incidesc',width:250},
        {header:'����',dataIndex:'qty',width:40},
        {header:'��λ',dataIndex:'uomdesc',width:60},
        {header:'����',dataIndex:'dosage',width:60},
        {header:'Ƶ��',dataIndex:'freq',width:40},
        {header:'���',dataIndex:'spec',width:80},
        {header:'�÷�',dataIndex:'instruc',width:80},
        {header:'����',dataIndex:'form',width:80},
        {header:'ҽ�����ȼ�',dataIndex:'ordpri',width:80},
        {header:'����ҩ��',dataIndex:'basflag',width:50},
        {header:'ҽ��',dataIndex:'doctor',width:60},
        {header:'ҽ����������',dataIndex:'orddate',width:120},
        {header:'ҽ����ע',dataIndex:'remark',width:60},
        {header:'����',dataIndex:'manf',width:150},
        {header:'����',dataIndex:'price',width:60},
        {header:'���',dataIndex:'amt',width:80},
        {header:'orditem',dataIndex:'orditem'},
        {header:'mainflag',dataIndex:'mainflag',hidden:true},
        {header:'colorflag',dataIndex:'colorflag',hidden:true},
        {header:'moeori',dataIndex:'moeori',hidden:true},
        {header:'adm',dataIndex:'adm',hidden:true},
        {header:'papmi',dataIndex:'papmi',hidden:true}
        
   ]);
 
    var orddetailgridds = new Ext.data.Store({
		proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'druguse',
	        'patid',
	        'patname',
		    'adm',
            'incidesc',
            'qty',
		    'uomdesc',
		    'dosage',
		    'freq',
		    'spec',
		    'instruc',
		    'form',
		    'ordpri',
		    'basflag',
		    'doctor',
		    'orddate',
		    'remark',
		    'manf',
		    'price',
		    'amt',
		    'result',
		    'orditem',
		    'mainflag',
		    'colorflag',
		    'moeori',
		    'adm',
		    'papmi'
	    
		]),
		
		

    remoteSort: true
});
   
 var orddetailgridcmPagingToolbar = new Ext.PagingToolbar({	
			store:orddetailgridds,
			pageSize:200,
			//��ʾ���½���Ϣ
			displayInfo:true,
			displayMsg:'��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
		        prevText:"��һҳ",
			nextText:"��һҳ",
			refreshText:"ˢ��",
			lastText:"���ҳ",
			firstText:"��һҳ",
			beforePageText:"��ǰҳ",
			afterPageText:"��{0}ҳ",
    		        emptyMsg: "û������"
	});
 
 
 var orddetailgrid = new Ext.grid.GridPanel({
        
        stripeRows: true,
        region:'center',
        margins:'3 3 3 3', 
        enableColumnMove : false,
	    trackMouseOver: true,
	    stripeRows: true,
        id:'orddetailtbl',
        ds: orddetailgridds,
        cm: orddetailgridcm,
        sm : sm,
        //tbar:[OkButton,"-",BadButton,'-',ListLogButton,'-',DaTongAnalyseButton,'-',DaTongYDTSButton],
        tbar:[OkButton,"-",BadButton,'-',ListLogButton,'-',DaTongAnalyseButton],
        bbar: orddetailgridcmPagingToolbar,
        trackMouseOver:'true'
        

        
    });
  
    orddetailgrid.on('cellclick',OrddetailGridCellClick)  //��ͨ������ҩ
    //orddetailgrid.on('mouseup',OrddetailMouseUpClick)  //����������ҩ
    //orddetailgrid.on('celldblclick',OrddetailGridCellDblClick) //����������ҩ
	
	
    orddetailgrid.on('rowclick',function(grid,rowIndex,e){

        var selectedRow = orddetailgridds.data.items[rowIndex];
		var adm = selectedRow.data["adm"];  
		var papmi= selectedRow.data["papmi"];  
        PatInfo.adm=adm;
		PatInfo.patientID=papmi;
		
		
    });
    
    orddetailgridds.on('beforeload',autoCheckGridHead)
    
	
     ///�ұߵ�Form

	
     var toolform = new Ext.TabPanel({
        id:'ToolsTabPanel',
	    region: 'center',
	    margins:'3 3 0 3', 
	    frame:false,
	    activeTab: 0,
            items:[{
            	title: 'ҽ����ϸ',	
		id:'frameordquery',
		layout:'border',
		items: [orddetailgrid]
	    },{
	        		title: '������¼',	
					frameName: 'framepaallergy',
					html: '<iframe id="paallergyFrame" width=100% height=100% src=dhcpha.comment.paallergy.csp></iframe>',		
					src: 'dhcpha.comment.paallergy.csp',
					id:'framepaallergy'
	
	    },{
	          		title: '����¼',
	          		frameName: 'framerisquery',
	          		html: '<iframe id="framerisquery" width=100% height=100% src=dhcpha.comment.risquery.csp></iframe>',		
		  			src: 'dhcpha.comment.risquery.csp',
		  			id:'framerisquery'
	       
	
	    },{
	          		title: '�����¼',
	          		frameName: 'framelabquery',
	          		//html: '<iframe id="framelabquery" width=100% height=100% src=dhcpha.comment.labquery.csp></iframe>',		
		  			//src: 'dhcpha.comment.labquery.csp',
		  			html: '<iframe id="framelabquery" width=100% height=100% src=jquery.easyui.dhclaborder.csp></iframe>',		
		  			src: 'jquery.easyui.dhclaborder.csp',
		  			id:'framelabquery'
	       
	
	    },{
	          		title: '�������',
	          		frameName: 'frameprbrowser',
	          		//html: '<iframe id="frameprbrowser" width=100% height=100% src=emr.record.browse.csp></iframe>',		
		  			//src: 'emr.record.browse.csp',
		  			//html: '<iframe id="frmeprbrowser" width=100% height=100% src=emr.interface.browse.category.csp></iframe>',		
		  			//src: 'emr.interface.browse.category.csp',  //�°�
		  			html: '<iframe id="frmeprbrowser" width=100% height=100% src=emr.interface.browse.episode.csp></iframe>',		
		  			src: 'emr.interface.browse.episode.csp', //����		  			
		  			id:'frameprbrowser'
	       
	
	    },{
	          		title: '����ҽ��',
	          		frameName: 'frameadmordquery',
	          		html: '<iframe id="frameadmordquery" width=100% height=100% src=dhcpha.comment.admordquery.csp></iframe>',		
		  			src: 'dhcpha.comment.queryorditemds.csp',
		  			id:'frameadmordquery'
	       
	
	    },{
	          		title: '��Ժǰ��ҩ',
	          		frameName: 'frameothmedquery',
	          		html: '<iframe id="frameothmedquery" width=100% height=100% src=dhcpha.comment.othmedquery.csp></iframe>',		
		  			src: 'dhcpha.comment.othmedquery.csp',
		  			id:'frameothmedquery'
	       
	
	    }],

	    
	    listeners:{ 
                              tabchange:function(tp,p){ 
                                          HrefRefresh() ;
                                    } 
                                
                      } 

	    
	    
	  
	    
	    
	});
	


	


    toolform.on('afterlayout',function(view,layout){   
	  
	    
	    //toolform.setHeight(document.body.clientHeight)

	    
	},this);
	


	
	////////////////////////////////////////////////////////////////////////////////////
	
	////////***********************  �������������        *********************** 
	
	/////////////////////////////////////////////////////////////////////////////////////
	
	
	   //ˢ��
   var  RefreshButton = new Ext.Button({
             width : 70,
             id:"RefreshBtn",
             text: '��ѯ',
             icon:"../scripts/dhcpha/img/find.gif",
             listeners:{
                          "click":function(){   
                             
                                 FindList();
                              	 autoCheckGridHead();
                              }   
             }
             
             
   })
   
   

   //�Զ�ˢ��
   var AutoRefreshChkbox=new Ext.form.Checkbox({
        
		boxLabel : '�Զ�ˢ��',
		id : 'AutoRefreshChk',
		inputValue : '1',
		checked : false,
		listeners:{
					'check': function(){
						
						if (Ext.getCmp("AutoRefreshChk").getValue())
						{
							StartAutoLoadTree();
						}
					        else{
					       
					               StopAutoLoadTree();
	
						}
					}
	}
    })
    
    
   //����Ժ��ҩ
   var OnlyOutChkbox=new Ext.form.Checkbox({
        
		boxLabel : '����Ժ��ҩ',
		id : 'OnlyOutChk',
		inputValue : '1',
		checked : false,
		listeners:{
					'check': function(){
	
					}
		}
    })
    
    
   //�����
   var OnlyAdtChkbox=new Ext.form.Checkbox({
        
		boxLabel : '������',
		id : 'OnlyAdtChk',
		inputValue : '1',
		checked : false,
		listeners:{
			'check': function(){
				Ext.getCmp('OnlyRefuseBox').setValue("false");
			}
		}
    })
    
	///���ܾ�
	var OnlyRefuseBox=new Ext.form.Checkbox({
		boxLabel : '���ܾ�',
		id : 'OnlyRefuseBox',
		inputValue : '1',
		checked : false,
		listeners:{
			'check': function(){
				Ext.getCmp('OnlyAdtChk').setValue("false");
			}
		}
	})

	
	 ///�����ؼ�
	var WardDs = new Ext.data.Store({
		autoLoad: true,
		proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=GetWardDs',
			method : 'POST'
		}),
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['warddesc','rowId'])
				
	});
	
    
    //����tbar 
    var WardDescSelecter = new Ext.form.ComboBox({
				  id:'WardDescCombox',
				  fieldLabel:'����',
				  store: WardDs,
				  valueField:'rowId',
				  displayField:'warddesc',
				  width : 150,
				  listWidth:250,
				  emptyText:'ѡ����...',
				  mode: 'local'
	
				  
				  		  
				  
	});  
	



	
	 //ҩ�����ҿؼ�
	
	var phlocInfo = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['phlocdesc','rowId'])
				
	});
	
	phlocInfo.on(
		'beforeload',
		function(ds, o){
		    var grpdr=session['LOGON.GROUPID'] ;
			ds.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=GetStockPhlocDs&GrpDr='+grpdr, method:'GET'});
		
		}
	);
	
	 
	 
	 var PhaLocSelecter = new Ext.form.ComboBox({
				  id:'PhaLocSelecter',
				  fieldLabel:'ҩ������',
				  store: phlocInfo,
				  valueField:'rowId',
				  displayField:'phlocdesc',
				  width : 150,
				  listWidth:250,
				  emptyText:'ѡ��ҩ������...',
		                  allowBlank: false,
				  name:'PhaLocSelecter',
				  mode: 'local',
				      listeners:{      
                                     'select':function(combo){
                                //alert(Ext.get("DocLocSelecter").dom.value);   //��ȡidΪcombo��ֵ
                                  StkLocGrpStore.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=GetLocGrpDs&LocId='+Ext.getCmp("PhaLocSelecter").getValue(), method:'POST'});  
                                  StkLocGrpStore.load();

                                              }
				      }
				  
				  		  
				  
	});
	
	
		
	//��ʼ��ҩ��//����
	phlocInfo.on("load",function(store,record,opts){ setDefaultLoc(); });
	
	
    //���˵ǼǺŲ�ѯ����
	patientQueryBar = new  Ext.Toolbar({
		//hidden:true,
		items: ["�ǼǺ�:", new Ext.form.TwinTriggerField({
			width:160,id:'patientNoTF',enableKeyEvents:true,
			trigger1Class: 'x-form-clear-trigger',
			trigger2Class: 'x-form-search-trigger',
			onTrigger1Click: function(e){
				this.setValue("");
			}
			//onTrigger2Click: findPatientTree
		})]
	});

	
	function hideQueryBar (){
		patientQueryBar.hide();

	}
	
	function showQueryBar(){
		patientQueryBar.show();

	}
	
	
 


			
	//������ѯ����
	wardQueryBar = new  Ext.Toolbar({
		hidden:true,
		items: ['����:',WardDescSelecter]

	});
	
	function hidewardQueryBar (){
		wardQueryBar.hide();
	}
	
	function showwardQueryBar (){
		wardQueryBar.show();
		
	}
	
	
   //չ���ؼ�
   var MoreQuery=new Ext.form.Checkbox({
        
		boxLabel : '����',
		id : 'MoreQueryChk',
		inputValue : '1',
		checked : false,
		listeners:{
					'check': function(){
						ClearMore();
                        if (Ext.getCmp("MoreQueryChk").getValue())
                        {
                        	showwardQueryBar();
                        }
                        else
                        {
                        	hidewardQueryBar();
                        }
					}
		}
    })


   
  var stdatef=new Ext.form.DateField ({
                width : 150,
                xtype: 'datefield',
                fieldLabel: '��ʼ����',
                name: 'startdt',
                id: 'startdt',
                invalidText:'��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
                value:new Date
            })	
            
            
            
  var enddatef=new Ext.form.DateField ({
  	        width : 150,
            fieldLabel: '��ֹ����',
	        name: 'enddt',
	        id: 'enddt',
	        invalidText:'��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
	        value:new Date
            })
    
        var InputStr=GetListInput();
        
        
     //���Ҳ����б�ؼ�
	
    var patlistst = new Ext.data.Store({
	    proxy: "",
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	        }, [
	            'patid',
		    'patloc',
		    'bedno',
		    'adm',
		    'papmi'
			]),
	    // turn on remote sorting
	    remoteSort: true
	});
	    
	  
	  
	  var patlistcm = new Ext.grid.ColumnModel({
	
	    columns: [

	        {header:'�ǼǺ�',dataIndex:'patid',width: 90,menuDisabled :'false'},
	        {header:'����',dataIndex:'patloc',width: 160,menuDisabled :'false'},
	        {header:'����',dataIndex:'bedno',width: 80,menuDisabled :'false'},
	         {header:'adm',dataIndex:'adm',hidden:'true',ortable:'false'},
	         {header:'papmi',dataIndex:'papmi',hidden:'true',ortable:'false'}
	       ]
	    });
	    
	 var patlistgridPagingToolbar = new Ext.PagingToolbar({	
				store:patlistst,
				pageSize:200,
				//��ʾ���½���Ϣ
				displayInfo:true,
				displayMsg:'��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
			    prevText:"��һҳ",
				nextText:"��һҳ",
				refreshText:"ˢ��",
				lastText:"���ҳ",
				firstText:"��һҳ",
				beforePageText:"��ǰҳ",
				afterPageText:"��{0}ҳ",
	    		emptyMsg: "û������"
		});
	  
	  var patlistgrid = new Ext.grid.GridPanel({
	        region:'center',
			margins:'0 0 0 0', 
	        enableColumnMove : false,
	        height:480,
	        trackMouseOver: true,
	        stripeRows: true,
	        ds: patlistst,
	        cm: patlistcm,
	        tbar:[],
	        bbar:[patlistgridPagingToolbar],
	        view: new Ext.ux.grid.BufferView({
			    rowHeight: 25,
			    scrollDelay: false
		    
		    }),
	        listeners:{
					'render': function(){
						wardQueryBar.render(patlistgrid.tbar);			
					}
					
					
					
				}
	    });


	///�����б�grid �������¼�

    patlistgrid.on('rowclick',function(grid,rowIndex,e){

        var selectedRow = patlistst.data.items[rowIndex];
		var adm = selectedRow.data["adm"];   
		var papmi  = selectedRow.data["papmi"];   
        ClearWindow();
        PatInfo.adm=adm;
        PatInfo.patientID=papmi;
        PatInfo.allOrd=1;
        HrefRefresh();	
    });   
    
    
    
         //���Ҳ����б�ؼ�
	
    var wardlistst = new Ext.data.Store({
	    proxy: "",
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	        }, [
		    'warddesc',
		    'wardid'
			]),
	    // turn on remote sorting
	    remoteSort: true
	});
	    
	  
	  
	  var wardlistcm = new Ext.grid.ColumnModel({
	
	    columns: [

	        {header:'����',dataIndex:'warddesc',width: 200,menuDisabled :'false'},
	         {header:'wardid',dataIndex:'wardid',hidden:'true',ortable:'false'}
	       ]
	    });
	    
	 var wardlistgridPagingToolbar = new Ext.PagingToolbar({	
				store:wardlistst,
				pageSize:200,
				//��ʾ���½���Ϣ
				displayInfo:true,
				displayMsg:'��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
			    prevText:"��һҳ",
				nextText:"��һҳ",
				refreshText:"ˢ��",
				lastText:"���ҳ",
				firstText:"��һҳ",
				beforePageText:"��ǰҳ",
				afterPageText:"��{0}ҳ",
	    		emptyMsg: "û������"
		});
	  
	  var wardlistgrid = new Ext.grid.GridPanel({
	        region:'center',
			margins:'0 0 0 0', 
	        enableColumnMove : false,
	        height:480,
	        trackMouseOver: true,
	        stripeRows: true,
	        ds: wardlistst,
	        cm: wardlistcm,
	        view: new Ext.ux.grid.BufferView({
			    rowHeight: 25,
			    scrollDelay: false
		    
		    })
	    });
	    
   		///����grid �������¼�

    wardlistgrid.on('rowclick',function(grid,rowIndex,e){

        var selectedRow = wardlistst.data.items[rowIndex];
		var wardid = selectedRow.data["wardid"];
        ClearWindow();
        PatInfo.wardid=wardid;
        HrefRefresh();
        
		
		
    }); 
    
    
	//���ǼǺŲ�ؼ�
	
    var patinfost = new Ext.data.Store({
	    proxy: "",
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	        }, [
	            'adm',
		    'admloc',
		    'admdate',
		    'currward',
		    'currbed',
		    'currdoc',
		    'papmi'
			]),
	    // turn on remote sorting
	    remoteSort: true
	});
	    
	     				      
	  
	  var patinfocm = new Ext.grid.ColumnModel({
	
	    columns: [
	
	        {header:'adm',dataIndex:'adm',hidden:'true',ortable:'false'},
	        {header:'����ʱ��',dataIndex:'admdate',width: 80,menuDisabled :'false'},
	        {header:'�������',dataIndex:'admloc',width: 120,menuDisabled :'false'},
	        {header:'����',dataIndex:'currward',width: 120,menuDisabled :'false'},
	        {header:'����',dataIndex:'currbed',width: 40,menuDisabled :'false'},
	        {header:'ҽ��',dataIndex:'currdoc',width: 60,menuDisabled :'false'},
	        {header:'papmi',dataIndex:'papmi',hidden:'true'}
	       ]
	    });
	 
		
	     //���˵ǼǺŲ�ѯ����
	var patientTwin =  new Ext.form.TwinTriggerField({
			width:160,id:'patientNoTF',enableKeyEvents:true,
			trigger1Class: 'x-form-clear-trigger',
			trigger2Class: 'x-form-search-trigger',
			onTrigger1Click: function(e){
				this.setValue("");
				ClearWindow();
			},
			onTrigger2Click: function(e){
				if(this.getValue()!=""){
				GetAdmDs(this.getValue());}
			},
			listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                if(this.getValue()!=""){
                                GetAdmDs(this.getValue());
                                }
                            }
                        }
                    }
	});
	  
	  
	  var patinfogrid = new Ext.grid.GridPanel({
	  
	        enableColumnMove : false,
	        height:480,
	        trackMouseOver: true,
	        stripeRows: true,
	        ds: patinfost,
	        cm: patinfocm,
	        tbar:['�ǼǺ�:',patientTwin]
	    });


	///�����б�grid �������¼�

    patinfogrid.on('rowclick',function(grid,rowIndex,e){

        var selectedRow = patinfost.data.items[rowIndex];
		var adm = selectedRow.data["adm"];
		var papmi = selectedRow.data["papmi"];
                
        ClearWindow();
        //GetInPatInfo(adm);
        PatInfo.adm=adm;
        PatInfo.patientID=papmi;
        PatInfo.allOrd=0;
        HrefRefresh();
		
		
    });   
    
    
		
	//���tab�ؼ�
	var ListTabPanel = new Ext.TabPanel({
        id:'ListTab',
	    frame:false,
	    activeTab: 0,
	    region:'center',
        margins:'0 0 0 0',
	    items:[{
                    title:'�����б�',
					id:'wardlisttab',
					layout:'border', 
					items: [wardlistgrid]
	
	    },{
                    title:'����/�����б�',
					id:'wardpatlisttab',
					layout:'border', 
					items: [patlistgrid]
	
	    },{
	    	        title:'���ǼǺŲ�',
	       			id:'patlisttab',
					items: [patinfogrid]
	    }]
	    
	})
	
	
	
	var DatePanel = new Ext.Panel({ 
         frame:true,
         layout:'form' ,
         autoHeight:true,
         labelAlign : 'right',
         labelWidth: 75,
         region:'center',
         buttonAlign:'center',
         margins:'0 0 0 0',
         items : [{
					layout : "column",
					items : [{
					            labelAlign : 'right',
								columnWidth : 1,
								layout : "form",
								items : [ PhaLocSelecter ]
							 }]
								   
								   
								   
								   
					},{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : 1,
										layout : "form",
										items : [  stdatef  ]
									 }]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : 1,
										layout : "form",
										items : [  enddatef  ]
									 }]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : 1,
										layout : "form",
										items : [  WardDescSelecter  ]
									 }]
					  },{
					      layout : "column",
					     items : [{ 
					     labelAlign : 'right',
					     columnWidth : 1,
					      layout : "form",
					      items : [ConditionLocGField]
				             }]
				             } ,{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : .33,
										layout: {
			                                type: 'hbox',
			                                align: 'middle ',
			                                pack: 'center'
			                            },
										items : [  AutoRefreshChkbox  ]
									 },{ 
							            labelAlign : 'right',
										columnWidth : .33,
										layout: {
			                                type: 'hbox',
			                                align: 'middle ',
			                                pack: 'center'
			                            },
										items : [  OnlyOutChkbox  ]
									 },{ 
							            labelAlign : 'right',
										columnWidth : .33,
										layout: {
			                                type: 'hbox',
			                                align: 'middle ',
			                                pack: 'center'
			                            },
										buttons: [RefreshButton] 
									 }]
					  },{
					      layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : .295,
										layout: {
			                                type: 'hbox',
			                                align: 'middle ',
			                                pack: 'center'
			                            },
										items : [  OnlyRefuseBox  ]
									 },{ 
							            labelAlign : 'right',
										columnWidth : .33,
										layout: {
			                                type: 'hbox',
			                                align: 'middle ',
			                                pack: 'center'
			                            },
										items : [  OnlyAdtChkbox  ]
									 },{ 
							            labelAlign : 'right',
										columnWidth : .33,
										layout: {
			                                type: 'hbox',
			                                align: 'middle ',
			                                pack: 'center'
			                            },
										items : [    ]
									 }]
					  }
					
		 ]
					

         
 
         });
         
   
     var westPanel = new Ext.Panel({
         region: 'west', 
		 split:true,
         title: 'סԺҽ�����',
         frame:true,
         collapsible: true,
         labelAlign : 'right',
         labelWidth: 75,
         buttonAlign:'center',
	 	 width:310,
	 	 layout:{  
	        type:'vbox', 
	        align: 'stretch',  
	        pack: 'start'  
	     }, 
	     items: [{         
         	  flex: 1.2,
         	  layout:'border',
         	  items:[DatePanel]  
         	 },{   
         	  flex: 2 ,
         	  layout:'border',
         	  items:[ListTabPanel]    
               }]
 
         });
    


      var port = new Ext.Viewport({

				layout : 'border',
				items : [westPanel,toolform]

			});



			
	////////////////////////////////////////////////////////////////////////////////////
	
	////////***********************  ������Events����        *********************** 
	
	/////////////////////////////////////////////////////////////////////////////////////



 

///���´���(�����ѯ����)
function OpenMoreFindWindow()
{

   MoreFindFun();
   

   
}




/// ����Adm�鿴ҽ����ϸ

function FindOrdDetailData(input)  
{
                waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݣ����Ժ�..." }); 
                waitMask.show();
                orddetailgridds.removeAll();
				orddetailgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindIPOrdDetailDs&input='+input  });		
				orddetailgridds.load({
				params:{start:0, limit:orddetailgridcmPagingToolbar.pageSize},
				callback: function(r, options, success){
 
		         
		         waitMask.hide();
		         if (success==false){
		                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     }
		          }
		         
		
		});
		
				
		
} 


///��PatInfo
function ClearPatInfo()
{
	PatInfo.adm=0;

	Ext.getCmp("baseInfoIPNo").setText('');
	Ext.getCmp("baseInfoName").setText('');
	Ext.getCmp("baseInfoSex").setText('');
	Ext.getCmp("baseInfoAge").setText('');
	Ext.getCmp("baseInfoType").setText('');
	Ext.getCmp("baseInfoLoc").setText('');
	Ext.getCmp("baseInfoWeight").setText('');
	Ext.getCmp("baseInfoDiag").setText('');

		
		
}



///����

function ClearWindow()
{
        
		orddetailgridds.removeAll();
		//ClearPatInfo();
        InitPatInfo();
}

function InitPatInfo()
{
		PatInfo =  {
		    adm: 0,
	        patientID:0,
	        episodeID:0,
	        admType:"I",
	        prescno:0,
	        orditem:0,
	        wardid:0
		  }
		
}

///�ϸ�

function CommontOk()
{

     var orditm = "";
     var ret="Y";
     var reasondr="";
     var advicetxt="";
     var factxt="";
     var phnote="";
     var User=session['LOGON.USERID'] ;
	 var grpdr=session['LOGON.GROUPID'] ;
	 

	 var selRecords = Ext.getCmp("orddetailtbl").getSelectionModel().getSelections(); 
	 var totalnum=selRecords.length;

	 if (totalnum==0){
	    return;
	 }

	for(var i = 0; i < totalnum; i++){
		orditm = selRecords[i].get("orditem");
		var input=ret+"^"+User+"^"+advicetxt+"^"+factxt+"^"+phnote+"^"+grpdr+"^"+orditm+"^"+AppType;
		SaveCommontResult(reasondr,input)
	}


     
 
}



///���ϸ�

function EditReason()
{
       
       var detailrow = Ext.getCmp("orddetailtbl").getSelectionModel().getSelections(); 
       if (!(detailrow)){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("��ʾ", "δѡ��ҩƷ��¼!");
           return;
       }
       if (detailrow==0){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("��ʾ", "δѡ��ҩƷ��¼!");
           return;
       }
       
        
       var orditmstr =""; 
       var iaresult="";
       var canrefuse="";
       var morditm=detailrow[0].data.moeori;
       for (var detaili=0;detaili<detailrow.length;detaili++){
	   		var tmpmorditm=detailrow[detaili].data.moeori;
	   		if (morditm!=tmpmorditm){continue;}
	   		var orditm=detailrow[detaili].data.orditem;
	   		if (orditmstr==""){
		   		orditmstr=orditm
		   	}
	   		else{
		   		orditmstr=orditmstr+"^"+orditm
		   	}
		   	iaresult=detailrow[detaili].data.result;
		   	if (iaresult=="<font color=red>�ܾ�</font>"){
				canrefuse="1"
				break;
			}
	   }
	   if (canrefuse==1){
	       Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("��ʾ", "��ѡ��ļ�¼�Ѿܾ�!");
           return;
	   }
       var waycode = InPhaWay;
       
    
       var retstr=showModalDialog('dhcpha.comment.selectreason.csp?orditm='+orditmstr+'&waycode='+waycode,'','dialogHeight:600px;dialogWidth:1000px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no')
        
 
       if (!(retstr)){
          return;
        }
        
        if (retstr==""){
          return;
        }
        
        retarr=retstr.split("@");

        var ret="N";
		var reasondr=retarr[0];
		var advicetxt=retarr[2];
		var factxt=retarr[1];
		var phnote=retarr[3];
		var User=session['LOGON.USERID'] ;
		var grpdr=session['LOGON.GROUPID'] ;
		
		
		var input=ret+"^"+User+"^"+advicetxt+"^"+factxt+"^"+phnote+"^"+grpdr+"^"+orditm+"^"+AppType;
		
		if (reasondr.indexOf("$$$")=="-1")
		{
			reasondr=reasondr+"$$$"+orditm ;
		}
		
		
		SaveCommontResult(reasondr,input) 
       

}


///����������

function SaveCommontResult(reasondr,input)
{
        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݣ����Ժ�..." ,removeMask: true}); 
        waitMask.show();
            
  		Ext.Ajax.request({

	        url:unitsUrl+'?action=SaveItmResultIPMo&Input='+encodeURI(input)+'&ReasonDr='+reasondr ,
			failure: function(result, request) {
				waitMask.hide() ;
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
			success: function(result, request) {
	            waitMask.hide() ;
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.retvalue==0){
	
                    HrefRefresh();	
				  
				}else{
				    msgtxt=jsonData.retinfo;

				    Ext.Msg.show({title:'��ʾ',msg:msgtxt,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}			  	 
	  		
	  		

		},
		
			scope: this
		});

    
}




///ȡ���˻�����Ϣ

function GetInPatInfo(adm)
{

  		Ext.Ajax.request({

	    url:unitsUrl+'?action=GetInPatInfo&Adm='+adm ,
	
		waitMsg:'������...',
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {

			var jsonData = Ext.util.JSON.decode( result.responseText );
			var str=jsonData.retvalue ;	
            if (str!=""){
            	SetPatInfo(str);
            	
            }
	  		

		},
		
			scope: this
		});

    
}


 function SetPatInfo(str)
 	{
 		
 		tmparr=str.split("^");
 		
 		patno=tmparr[0];
 		patname=tmparr[1];
 		patsex=tmparr[3];
 		patage=tmparr[2];
 		pattype=tmparr[11];
 		ward=tmparr[13];
 		weight=tmparr[5];
 		diag=tmparr[4];
 		
		Ext.getCmp("baseInfoIPNo").setText(patno);
		Ext.getCmp("baseInfoName").setText(patname);
		Ext.getCmp("baseInfoSex").setText(patsex);
		Ext.getCmp("baseInfoAge").setText(patage);
		Ext.getCmp("baseInfoType").setText(pattype);
		Ext.getCmp("baseInfoLoc").setText(ward);
		Ext.getCmp("baseInfoWeight").setText(weight);
		Ext.getCmp("baseInfoDiag").setText(diag);

	}
 ///�鿴��־	
 function ListLogBtnClick()
 {
 	   var detailrow = Ext.getCmp("orddetailtbl").getSelectionModel().getSelections(); 

 	   
       if (!(detailrow)){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("��ʾ", "δѡ��ҩƷ��¼!");
           return;
       }
       if (detailrow==0){
           Ext.Msg.getDialog().setWidth(500); 
           Ext.MessageBox.alert("��ʾ", "δѡ��ҩƷ��¼!");
           return;
       }
       
       
       var adm=PatInfo.adm;
       var orditm = detailrow[0].data.orditem;
       
       FindItmLog(orditm);
 }
 

	
	
   function ClearGrid()
	{
		Ext.getCmp("baseInfoIPNo").setText('');
		Ext.getCmp("baseInfoName").setText('');
		Ext.getCmp("baseInfoSex").setText('');
		Ext.getCmp("baseInfoAge").setText('');
		Ext.getCmp("baseInfoType").setText('');
		Ext.getCmp("baseInfoLoc").setText('');
		Ext.getCmp("baseInfoWeight").setText('');
		Ext.getCmp("baseInfoDiag").setText('');
		
		orddetailgridds.removeAll();
	}
	
	
  var task_RealTimeMointor = {
		run : FindWardList  ,//ִ������ʱִ�еĺ���
		interval : 60000 
		//������������Ϊ��λ��������10��
	}

	
   
  function StartAutoLoadTree()
  {
	
	 Ext.TaskMgr.start(task_RealTimeMointor);

	 
  }
 function StopAutoLoadTree()
 {
         Ext.TaskMgr.stop(task_RealTimeMointor);
         
  }
  
  
  function FindList()
  {
  	wardlistst.removeAll() ;
    patlistst.removeAll() ;
    orddetailgridds.removeAll();
  	InitPatInfo();
  	var p = Ext.getCmp("ListTab").getActiveTab();
  	 if (p.id=="wardlisttab"){
  	 	FindWardList()
  	 }
  	 if (p.id=="wardpatlisttab"){
  	 	FindWardPatList();
  	 }
  	 
  }
   //�񵽲����б�
  function FindWardList()
  {
  	
  	 InputStr=GetListInput();
  	 if (InputStr==""){
	 	return;
	 }
	 waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݣ����Ժ�..." }); 
     waitMask.show();
                
	 wardlistst.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=GetWardListData&input='+InputStr  });		
					wardlistst.load({
					params:{start:0, limit:wardlistgridPagingToolbar.pageSize},
					callback: function(r, options, success){
	 
			        waitMask.hide();
			        if (success==false){
			                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
	     		                     }
	      }
	     
	
	   });
  }

    //�񵽲��������б�
   function FindWardPatList()
   {

     InputStr=GetListInput();
     if (InputStr==""){
	 	return;
	 }
	 waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݣ����Ժ�..." }); 
     waitMask.show();
                
	 patlistst.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=GetAdmTreeData&input='+InputStr  });		
					patlistst.load({
					params:{start:0, limit:patlistgridPagingToolbar.pageSize},
					callback: function(r, options, success){
	 
			        waitMask.hide();
			        if (success==false){
			                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
	     		                     }
	      }
	     
	
	   });
   	
	 

   }
   
   //��ʾ����
  	function StartLoading()
	{
		 //waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݣ����Ժ�..." }); 
         //waitMask.show(); 
	}

	function EndLoading()
	{
         //waitMask.hide(); 
	}
	
	
	
	///��ʼ��Ĭ�Ͽ���
  
  function setDefaultLoc()
   { 

     var locdr=session['LOGON.CTLOCID'].toString();
     var perflag="";
     for (var loci=0;loci<phlocInfo.getCount();loci++){
	   if (phlocInfo.getAt(loci).id==locdr){
		   perflag=1;
		}
	 }
	 if (perflag==""){
		Ext.Msg.show({title:'ע��',msg:'������¼�İ�ȫ���Ĭ�ϵ�¼�����޴�Ȩ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO}); 
		return;
	 }
     PhaLocSelecter.setValue(locdr) ;
     //alert(Ext.get("DocLocSelecter").dom.value);   //��ȡidΪcombo��ֵ
     StkLocGrpStore.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=GetLocGrpDs&LocId='+locdr, method:'POST'});  
      StkLocGrpStore.load();
   }  
	
   //��������б�ѡ������
  function GetListInput()
  {
  	    sdate=Ext.getCmp("startdt").getRawValue().toString();
        edate=Ext.getCmp("enddt").getRawValue().toString();
        phlocdr=Ext.getCmp('PhaLocSelecter').getValue();
        if (phlocdr==""){
			return "";
	    }
        LocGrpid=Ext.getCmp('ConditionLocG').getValue();
        warddr=Ext.getCmp('WardDescCombox').getValue();
        wardid=PatInfo.wardid;
        if (wardid!=0) {warddr=wardid;}
        onlyout=Ext.getCmp('OnlyOutChk').getValue();
        var aduitFlag = "";
        onlyadt = Ext.getCmp('OnlyAdtChk').getValue();
        if (onlyadt){
	    	aduitFlag = 1;
	    	}
        var onlyrefflag=Ext.getCmp('OnlyRefuseBox').getValue();  ///���ܾ�
        if (onlyrefflag){
	    	aduitFlag = "2";
	    	}
        if (PatInfo.allOrd=="undefined"){PatInfo.allOrd=1}
  	    var listinputstr=sdate+"^"+edate+"^"+phlocdr+"^"+warddr+"^"+onlyout+"^"+aduitFlag+"^"+LocGrpid+"^"+PatInfo.allOrd;
  	    return listinputstr
  }
	
  //�����������
  function ClearMore()
  {
  	Ext.getCmp('WardDescCombox').setValue('');
  }
  
  //���ĵ����¼�
  function treeClick(node, e) {
	

                var adm=node.attributes.id;
                ClearWindow();
                GetInPatInfo(adm);
                PatInfo.adm=adm;
		        HrefRefresh(); 


   }
   
    //��ȡ�õǼǺ��µ����о����¼
   function GetAdmDs(RegNo)
   {
   	            patinfost.removeAll();
   	            var patLen = tkMakeServerCall("web.DHCSTCNTSCOMMON", "GetPatRegNoLen");
   	            
   	            var plen=RegNo.length;
			 	if (plen>patLen){
			 		Ext.Msg.show({title:'����',msg:'����ǼǺŴ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			 		return;
			 	}
			 	
				for (i=1;i<=patLen-plen;i++)
			  	{
				 	 RegNo="0"+RegNo;  
			    }
			    patientTwin.setValue(RegNo)
   	  
   	            waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݣ����Ժ�..." }); 
                waitMask.show();
                
				patinfost.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=GetAdmDs&RegNo='+RegNo  });		
				patinfost.load({
				callback: function(r, options, success){
 
		         waitMask.hide();
		         if (success==false){
		                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     }
		          }
		         
		
		});
   	
   }
  
  //////*****************************��ͨ������ҩ�ӿ�����//////// 
   
     ///��ͨҩ����ʾ
  function DaTongYDTSBtnClick()
  {		  
       	 var rows = Ext.getCmp("orddetailtbl").getSelectionModel().getSelections(); 
		 var totalnum=rows.length;
		 
		 if (totalnum==0){
		    return;
		 }
		  var currow = orddetailgrid.getSelectionModel().getSelected();
		  var orditm =currow.get("orditem") ;
		  
		  dtywzxUI(3,0,"");
		  var myPrescXML=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDTYDTS", orditm);

		  myrtn=dtywzxUI(12,0,myPrescXML);
  
  }
   
   //�е����¼�
  function OrddetailGridCellClick(grid, rowIndex, columnIndex, e)
  {
        if (columnIndex==1){

					  	  var newmoeori="";
					      var record = orddetailgrid.getStore().getAt(rowIndex);
					  	  var moeori =record.data.moeori ;
					      
						  var rsm = orddetailgrid.getSelectionModel();
					      var view = orddetailgrid.getView();
					      var store = orddetailgrid.getStore();
					      
					      if (rsm.isSelected(rowIndex))
					      {
					      	   for (i=0;i<=view.getRows().length-1;i++)
					      	   {
							       if(rsm.isSelected(i)){       
							          //rsm.deselectRow(i)  
							       }
							       else
							       { 
							         var record = orddetailgrid.getStore().getAt(i);
							  	     var newmoeori =record.data.moeori ;
							  	     
							  	     if (newmoeori==moeori){
							  	     	 rsm.selectRow(i,true);
							  	     }
							  	     else
							  	     {
							  	     	if (i>rowIndex) break;
							  	     }
							       	
							
							       }
					       
					           }
					
					      }else{
					      	 
					      	   for (i=0;i<=view.getRows().length-1;i++)
					      	   {
							       if(rsm.isSelected(i)){       
							         var record = orddetailgrid.getStore().getAt(i);
							  	     var newmoeori =record.data.moeori ;
							  	     
							  	     if (newmoeori==moeori){
							  	     	 rsm.deselectRow(i);
							  	     }
							  	     else
							  	     {
							  	     	if (i>rowIndex) break;
							  	     }
							       }
							       else
							       { 
					
							       }
					       
					           }
					      	
					      }
			
		   }

     if (columnIndex==2){
     	          //��ͨ������ҩ
     	          /*
		  var record = orddetailgrid.getStore().getAt(rowIndex); 
		  var mainflag =record.data.mainflag ;
		  //if (mainflag!=1)return ; //����ҽ���˳�
		  dtywzxUI(3,0,"");
		  var totalnum =orddetailgrid.getStore().getCount() ;
		  var oldadm="";
		  var ordstr="";
		  for(var i=rowIndex;i<totalnum;i++){
		  	    var record = orddetailgrid.getStore().getAt(i); 
		        var adm =record.data.adm ;
		        var orditem =record.data.orditem ;
		        if (oldadm=="") {
		           ordstr=orditem;
		           oldadm=adm ;
		        }else{
		        	if (oldadm==adm){
		        		if (ordstr==""){
		                	ordstr=orditem ;
		                }else{
		                	ordstr=ordstr+"^"+orditem ;
		                }
		        	}else{
		        		continue;
		        	}
		        }
		       
		        
		        
		  }
		  
		  var myPrescXML=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDaTongPresInfo", ordstr);
		  myrtn=dtywzxUI(28676,1,myPrescXML);
		  */
        }


  }

  //��ͨ��������
  function DaTongPrescAnalyse()
  {	

     
	 var totalnum =orddetailgrid.getStore().getCount() ;
	 if (totalnum==0){
	    return;
	 }


      
	 var lightrow="";
	 var oldadm="";
	 var ordstr="";
        var admnum=0;
	 for(var i=0;i<totalnum;i++){
		      
	 	        dtywzxUI(3,0,"");
		        var record = orddetailgrid.getStore().getAt(i); 
		        var adm =record.data.adm ;
                     var orditem =record.data.orditem ;
                     
		        
		        if (adm!=oldadm){
		             
                            admnum=admnum+1 ;

		        	if (oldadm!=""){
		        	
		        		      
		        		    	var myPrescXML=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDaTongPresInfo", ordstr);
                                           
						        myrtn=dtywzxUI(28676,1,myPrescXML);
						        if (myrtn==0) {var imgname="greenlight.gif";}
								if (myrtn==1) {var imgname="yellowlight.gif";}
							    if (myrtn==2) {var imgname="blacklight.gif";}
							    
				                var str="<img id='DrugUseImg"+i +"'"+" src='../scripts/dhcpha/img/"+imgname+"'>";
							    orddetailgrid.getView().getCell(lightrow,2).innerHTML=str 
							    
		        	}
		             
                           	lightrow=i;
		        	oldadm=adm;
                           ordstr=orditem ;
				    
		            
                            
                    
		        }else{
		        	    if (ordstr==""){
		                	ordstr=orditem ;
		                }else{
		                	ordstr=ordstr+"^"+orditem ;
		                }
		        }

                       
      
		         
	 }
        if (admnum>0){
                              
                	      
		        		    	var myPrescXML=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDaTongPresInfo", ordstr);
                                           
						        myrtn=dtywzxUI(28676,1,myPrescXML);
						        if (myrtn==0) {var imgname="greenlight.gif";}
								if (myrtn==1) {var imgname="yellowlight.gif";}
							    if (myrtn==2) {var imgname="blacklight.gif";}
							    
				                var str="<img id='DrugUseImg"+i +"'"+" src='../scripts/dhcpha/img/"+imgname+"'>";
							    orddetailgrid.getView().getCell(lightrow,2).innerHTML=str 
         }
	 
  	
  }
	    //��ʼ�� 
	function StartDaTongDll()
	{
		
		dtywzxUI(0,0,"");
	}
	
	function dtywzxUI(nCode,lParam,sXML){
	   var result;
	   result = CaesarComponent.dtywzxUI(nCode, lParam,sXML);
	   return result;
	}
	//////*****************************////////////////////////////////
	
	
	
	
	
	
	 
	 
	///////////////����������ҩ�ӿ�����////////
	function showMKHMTL(value, cellmeta, record, rowIndex, colIndex, store) {
		var oeori=record.get("orditem")
		var oeori=oeori.replace("||",".")
		var str="<label id=\""+rowIndex+"\" name=\""+rowIndex+ "\"><div id=\"McRecipeCheckLight_" + oeori + "\" name=\"McRecipeCheckLight\" class=\"DdimRemark_null\"></div>";  	
    	return str;
	}
	    //������������
	function MKPrescAnalyse()
	{	
	  	 var totalnum =orddetailgrid.getStore().getCount() ;
		 if (totalnum==0){
		    return;
		 }
		 MKXHZY(2);
	 }
	//����ҩƷ��Ϣ��ʾ
	function GetDrugQueryInfo()
	{
  
      //alert("GetDrugQueryInfo");
	   var record = orddetailgrid.getStore().getAt(UpRow);   
       var oeori =record.data.orditem ;
       var medinfo=tkMakeServerCall("web.DHCSTPIVAMKInterface", "GetMedicineInfo", oeori);
       //alert("medinfo="+medinfo);
	   var medarr=medinfo.split("^");
	   var OrderARCIMCode=medarr[0];
	   var OrderName=medarr[1];
	   var OrderDoseUOM=medarr[2];
	   var OrderInstrDesc=medarr[3];
	   var OrderInstrCode=medarr[4];
       //alert("OrderInstrCode="+OrderInstrCode);
	   var dqi = new Params_GetDrugQueryInfo_In();
	   
	   dqi.DrugType = "USER_Drug" ;
	   dqi.RouteType = "USER" ;
	   dqi.DrugCode = OrderARCIMCode; 	//ҩƷ����
	   dqi.DrugName = OrderName;		//ҩƷ����
	   dqi.DoseUnit = OrderDoseUOM;		//��ҩ��λ
	   dqi.RouteDesc = OrderInstrDesc;	//��ҩ;������
	   dqi.RouteID  = OrderInstrCode;	//��ҩ;����ź͸�ҩ;������һ��
   
	   McDrugQueryInfoModel = dqi;
	   
	}
	
		///�����໥����
	function MKXHZY(Flag){
		
		
		var totalnum =orddetailgrid.getStore().getCount() ;
		 if (totalnum==0){
		    return;
		}
		var oldadm="";
		var ordstr="";
		var num=0;
		for(var i=0;i<totalnum;i++){

	        var record = orddetailgrid.getStore().getAt(i); 
	        var adm =record.data.adm ;
	     
            var orditem =record.data.orditem ;
            if (oldadm=="") oldadm=adm ;
            if (oldadm==adm){
	            if (ordstr==""){
		            ordstr=orditem
	            }else
	            {
		            ordstr=ordstr+"^"+orditem ;
	            }
            }
            else
            {
	            
	            var retstr=tkMakeServerCall("web.DHCSTPIVAMKInterface", "GetPrescInfo", ordstr);
	            oldadm=adm ;
	            ordstr=orditem;
	            MK(Flag,retstr)
            }
          
            
		}
		
		
		var retstr=tkMakeServerCall("web.DHCSTPIVAMKInterface", "GetPrescInfo", ordstr);
		MK(Flag,retstr)
		
		
		
	}
	
    function MK(Flag,retstr)
    {
	    
	    var TempArr=retstr.split(String.fromCharCode(2));
	    var PatInfo=TempArr[0];
	    var MedCondInfo=TempArr[1];
	    var AllergenInfo=TempArr[2];
	    var OrderInfo=TempArr[3];
		var PatArr=PatInfo.split("^");
		var ppi = new Params_Patient_In();
		ppi.PatID = PatArr[0];			// ���˱���
		ppi.PatName = PatArr[1];		// ��������
		ppi.Sex = PatArr[2];				// �Ա�
		ppi.Birth = PatArr[3];			// ��������
		ppi.UseTime = PatArr[4];		// ʹ��ʱ��
		ppi.Height = PatArr[5];			// ���
		ppi.Weight = PatArr[6];			// ����
		ppi.VisitID = PatArr[7];		// סԺ����
		ppi.Department = PatArr[8];	    // סԺ����
		ppi.Doctor = PatArr[9];			// ҽ��
		ppi.OutTime = PatArr[10];		// ��Ժʱ��
		McPatientModel = ppi;

	    var arrayObj = new Array();
		var pri;
  
	    var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
	    McRecipeCheckLastLightStateArr = new Array();
		for(var i=0; i<OrderInfoArr.length ;i++)
		{   
		    var OrderArr=OrderInfoArr[i].split("^");
		    var oeori=OrderArr[14].replace("||",".")
	        pri = new Params_Recipe_In();
				
			//����core��?������core���ر�Ƶ�Ψһ���?����ĵ�div��idҲӦ�ú���������
	        pri.Index = oeori;
	        pri.DrugCode = OrderArr[1]; 		//ҩƷΨһ��
	        pri.DrugName = OrderArr[2]; 		//ҩƷ����
	        pri.DrugType = "USER_Drug"; 
	        pri.SingleDose = OrderArr[3]; 	//ÿ������
	        pri.DoseUnit = OrderArr[4]; 		//��ҩ��λ
	        pri.Frequency = OrderArr[5]; 	//��ҩƵ��(��/��)
	        pri.StartDate =OrderArr[6]; 	//��ʼʱ��?��ʽyyyy-mm-dd
	        pri.EndDate = OrderArr[7]; 		//����ʱ��?��ʽ?yyyy-mm-dd
	        pri.RouteDesc =OrderArr[8]; 	//��ҩ;������
	        pri.RouteID =OrderArr[9]; 		//��ҩ;�����?ͬ��ҩ;������
	        pri.RouteType = "USER"; 
	        pri.GroupTag = OrderArr[10]; 		//������
	        pri.IsTemporary =OrderArr[11]; //�Ƿ�Ϊ��ʱҽ��  1-��ʱҽ�� 0-����ҽ��
	        pri.Doctor =OrderArr[12]; 			//ҽ������

	        arrayObj[arrayObj.length] = pri;
		}
		McRecipeDataList = arrayObj;
    
    
		var arrayObj = new Array();
		var pai;
	
		var AllergenInfoArr=AllergenInfo.split(String.fromCharCode(1));
		for(var i=0; i<AllergenInfoArr.length ;i++)
		{
			var AllergenArr=AllergenInfoArr[i].split("^");
	        pai = new Params_Allergen_In();
	        pai.Index = i; 						//����Դ����˳����?��0��ʼ��Ψһ������?
	        pai.AllergenCode =AllergenArr[0]; 	//����Դ����
	        pai.AllergenDesc =AllergenArr[1]; 	//����Դ����
	        pai.AllergenType =AllergenArr[2]; 	//����Դ����
	        pai.Reaction =AllergenArr[3]; 			//����֢״

	        arrayObj[arrayObj.length] = pai;
		}
		McAllergenDataList = arrayObj;

		//����״̬������
		var arrayObj = new Array();
		var pmi;
 
	    var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));

		for(var i=0; i<MedCondInfoArr.length ;i++)
		{			
			var MedCondArr=MedCondInfoArr[i].split("^");
	        pmi = new Params_MedCond_In();
	        pmi.Index = i; 	//˳����?��0��ʼ��Ψһ������?
	        pmi.MedCondCode =MedCondArr[0]; 	//��������
	        pmi.MedCondDesc =MedCondArr[1]; 	//��������
	        pmi.MedCondType =MedCondArr[2]; 	//��������
	        pmi.StartDate =MedCondArr[3]; 		//��ʼʱ��
	        pmi.StopDate =MedCondArr[4]; 			//����ʱ��
	        pmi.VocabTypeCode = MedCondArr[5];	//����Vocab���ͱ���
	        arrayObj[arrayObj.length] = pmi;
		}
		McMedCondDataList = arrayObj;
	
		if (Flag==0) FuncSingleRecipeCheck(0);
		if (Flag==1) FuncRecipeCheck(0,2); //��׼���
		if (Flag==2) 
		{	CreatePostHisAllCheckData(-2)
			FuncRecipeCheck(0,1); //���ģʽ���
		}
		if (Flag==3) FuncRecipeCheck(7,2); //���������
		if (Flag==4) FuncRecipeCheck(5,2); //���������

	}

     //�Ҽ�
	function OrddetailMouseUpClick(e)
	{
        var totalnum =orddetailgrid.getStore().getCount() ;
		 if (totalnum==0){
		    return;
		}
		
		var rowIndex = orddetailgrid.getView().findRowIndex(e.getTarget());
		if (rowIndex.toString()=="false") return;
		UpRow=rowIndex;
		//CreatePostHisAllQueryData(1);
		GetDrugQueryInfo();
		OnMouseUpRightMenu(1,-2,"true");
	}
	//˫��
	function OrddetailGridCellDblClick(grid, rowIndex, columnIndex, e)
	{
	    var totalnum =orddetailgrid.getStore().getCount() ;
		 if (totalnum==0){
		    return;
		}
		
        if (columnIndex==2)
        {
                var record = orddetailgrid.getStore().getAt(rowIndex); 
			    var curradm =record.data.adm ;
				var ordstr="";
				var num=0;
				for(var i=0;i<totalnum;i++){

			        var record = orddetailgrid.getStore().getAt(i); 
			        var adm =record.data.adm ;
			        if ((adm!=curradm)&&(i>rowIndex)) break;
	                if (adm!=curradm) continue;
		            var orditem =record.data.orditem ;
	
			            if (ordstr==""){
				            ordstr=orditem
			            }else
			            {
				            ordstr=ordstr+"^"+orditem ;
			            }
	
          
            
				}
		
				var retstr=tkMakeServerCall("web.DHCSTPIVAMKInterface", "GetPrescInfo", ordstr);
                                alert("retstr="+retstr);
				MK(1,retstr)
	        
        }
	}
	 //�Զ��ж��Ƿ�ȫѡ��ѡ�л�ѡ�б�ͷ��checkbox    
 function autoCheckGridHead(){    
	 var hd_checker = orddetailgrid.getEl().select('div.x-grid3-hd-checker');      
     var hd = hd_checker.first();     
     if(hd != null){     
		if(hd.hasClass('x-grid3-hd-checker-on')){    
			hd.removeClass('x-grid3-hd-checker-on');     //x-grid3-hd-checker-on    
			//grid_taskQueryPop.getSelectionModel().clearSelections();    
		}    
    }    
 } 	            
});