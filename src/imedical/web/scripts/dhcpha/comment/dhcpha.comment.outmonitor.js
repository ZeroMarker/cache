///��������������JS
///Creator:LiangQiang
///CreatDate:2012-05-20
///

var unitsUrl = 'dhcpha.comment.outmonitor.save.csp';
var waitMask;
var InputStr;
var RightMenuRow;  //�Ҽ��˵�������




Ext.onReady(function() {

  Ext.QuickTips.init();// ������Ϣ��ʾ
  Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
  Ext.Ajax.timeout = 900000;
  //StartDaTongDll();
  
  PatInfo =  {
	adm: 0,
        patientID:0,
        episodeID:0,
        admType:"I",
        prescno:0,
        orditem:0,
        zcyflag:0
  };
  
       //����load Tab,����������
  var HrefRefresh = function (){
         
         
        var adm=PatInfo.adm; 
        var prescno=PatInfo.prescno ;
        var zcyflag=PatInfo.zcyflag;
    
	        
		var p = Ext.getCmp("ToolsTabPanel").getActiveTab();	
		var iframe = p.el.dom.getElementsByTagName("iframe")[0];
		
		if (p.id=="framepaallergy"){
		  iframe.src = p.src + '?PatientID=' + adm +'&EpisodeID='+ adm ;
		}
		
		if (p.id=="framerisquery"){
		 iframe.src = p.src + '?PatientID=' + adm +'&EpisodeID='+ adm ;
		}
		
		if (p.id=="framelabquery"){
		  iframe.src = p.src + '?PatientID=' + adm +'&EpisodeID='+ adm ;
		}
		
		if (p.id=="frameprbrowser"){
		  iframe.src='dhc.epr.public.episodebrowser.csp?EpisodeID='+ adm;
		}	
		
	
		
		//��ϸ
		if (p.id=="frameordquery"){
		
			 if (adm==0) return;
                         FindOrdDetailData(prescno);

		}
		

		//����ҽ��
		if (p.id=="frameadmordquery"){
		  iframe.src=p.src + '?EpisodeID=' + adm ;
		}
		
		//����Ԥ��
		if (p.id=="prescriptioninfo"){			
		
			  if (zcyflag==0)
			  {
			  	iframe.src='dhcpha.comment.prescriptioninfo.csp' + '?PrescNo=' + prescno +'&EpisodeID='+ adm ;				
						
			  }else{
			  	
			  	iframe.src='dhcpha.comment.cyprescriptioninfo.csp' + '?PrescNo=' + prescno +'&EpisodeID='+ adm ;
			  }
		  
		  
		}	
		

		
   }
   
  
  	   //ˢ��
   var  RefreshButton = new Ext.Button({
             width : 70,
             id:"RefreshBtn",
             text: '��ѯ',
             icon:"../scripts/dhcpha/img/find.gif",
             listeners:{
                          "click":function(){   
                             
                                 FindWardList();
                              
                              }   
             }
             
             
   })
  
   
   	   //����
   var  ReadCardButton = new Ext.Button({
             width : 70,
             id:"ReadCardBtn",
             text: '����',
             icon:"../scripts/dhcpha/img/menuopera.gif",
             listeners:{
                          "click":function(){   
                             
                                 BtnReadCardHandler();
                              
                              }   
             }
             
             
   })


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
    
    
    var DaTongAnalyseButton = new Ext.Button({
             width : 65,
             id:"DaTongAnalyseBtn",
             text: '��������',
             icon:"../scripts/dhcpha/img/multiref.gif",
             listeners:{
                          "click":function(){   
                             
                              DaTongPrescAnalyse();
                              
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
        
    
   //�����
   var OnlyAdtChkbox=new Ext.form.Checkbox({
        
		boxLabel : '������',
		id : 'OnlyAdtChk',
		inputValue : '1',
		checked : false,
		listeners:{
					'check': function(){
	
					}
		}
    })
    
    CardTypeStore = eval("(" + CardTypeArray + ')');
    
    var CardTypeComBo = new Ext.form.ComboBox({
			fieldLabel:'������',
			width : 120,
			typeAhead : true,
			height : 100,
			//renderTo:'LocListDiv',
			triggerAction : 'all',
			store : new Ext.data.ArrayStore({
				autoDestroy : true,
				fields : ['desc', 'value'],
				data : CardTypeStore
				
			}),
			mode : 'local',
			valueField : 'value',
			displayField : 'desc',
			listeners : {
				//change: LocChangeHandler
			}
		});
		
 
    //���Ҳ����б�ؼ�
	
    var patlistst = new Ext.data.Store({
	    proxy: "",
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	        }, ['result',
	            'druguse',
	            'patid',
	            'patname',
	            'patsex',
	            'patage',
	            'path',
	            'patw',
	            'billtype',
	            'prescno',
		    'patloc',
		    'diag',
		    'adm',
		    'orditem',
		    'zcyflag'
			]),
	    // turn on remote sorting
	    remoteSort: true
	});
	    
	  
	  var sm = new Ext.grid.CheckboxSelectionModel(); 
	  var nm = new Ext.grid.RowNumberer();
	  var patlistcm = new Ext.grid.ColumnModel([nm,sm,
	  
	        {header:'���',dataIndex:'result',width: 60,menuDisabled :'false'},
                {header:'������ҩ',dataIndex:'druguse',width: 60,menuDisabled :'false'},
	        {header:'�ǼǺ�',dataIndex:'patid',width: 90,menuDisabled :'false'},
	        {header:'����',dataIndex:'patname',width: 60,menuDisabled :'false'},
	        {header:'�Ա�',dataIndex:'patsex',width: 60,menuDisabled :'false'},
	        {header:'����',dataIndex:'patage',width: 60,menuDisabled :'false'},
	        {header:'���',dataIndex:'path',width: 60,menuDisabled :'false'},
	        {header:'����',dataIndex:'patw',width: 60,menuDisabled :'false'},
	        {header:'�ѱ�',dataIndex:'billtype',width: 90,menuDisabled :'false'},
	        {header:'������',dataIndex:'prescno',width: 120,menuDisabled :'false'},
	        {header:'�������',dataIndex:'patloc',width: 90,menuDisabled :'false'},
	        {header:'���',dataIndex:'diag',width: 400,menuDisabled :'false'},
	        {header:'adm',dataIndex:'adm',hidden:'true',ortable:'false'},
	        {header:'orditem',dataIndex:'orditem',width: 90,hidden:'true'},
	        {header:'zcyflag',dataIndex:'zcyflag',width: 90,hidden:'true'}
	       
	       ]);
	    
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
	        id:'patlisttbl',
		region:'center',
                margins:'3 3 3 3', 
	        enableColumnMove : false,
	        trackMouseOver: true,
	        stripeRows: true,
	        ds: patlistst,
	        cm: patlistcm,
	        sm : sm,
	        bbar: patlistgridPagingToolbar,
	        trackMouseOver:'true'
	    });
	    
	///�����б�grid �������¼�

	    patlistgrid.on('rowclick',function(grid,rowIndex,e){
	
	        var selectedRow = patlistst.data.items[rowIndex];
		var adm = selectedRow.data["adm"];
	        var prescno = selectedRow.data["prescno"];
	        var zcyflag = selectedRow.data["zcyflag"];
	        
	        ClearWindow();
	        PatInfo.adm=adm;
	        PatInfo.prescno =prescno;
	        PatInfo.zcyflag=zcyflag;

	        HrefRefresh(); 
	
			
			
	    });  
	    
	    
	    patlistgrid.on('cellclick',PatListGridCellClick)
	    
    
         ///ҽ����ϸ����table
    

  var orddetailgridcm = new Ext.grid.ColumnModel({
  
  columns:[

        {header:'ҩƷ����',dataIndex:'incidesc',width:150},
        {header:'����',dataIndex:'qty',width:40},
        {header:'��λ',dataIndex:'uomdesc',width:60},
        {header:'����',dataIndex:'dosage',width:60},
        {header:'Ƶ��',dataIndex:'freq',width:40},
        {header:'���',dataIndex:'spec',width:80},
        {header:'�÷�',dataIndex:'instruc',width:80},
        {header:'��ҩ�Ƴ�',dataIndex:'dura',width:60},
        {header:'ʵ���Ƴ�',dataIndex:'realdura',width:60},
        {header:'����',dataIndex:'form',width:80},
        {header:'����ҩ��',dataIndex:'basflag',width:50},
        {header:'ҽ��',dataIndex:'doctor',width:60},
        {header:'ҽ����������',dataIndex:'orddate',width:120},
        {header:'ҽ����ע',dataIndex:'remark',width:60},
        {header:'����',dataIndex:'manf',width:150},
        {header:'rowid',dataIndex:'orditm',hidden:true}
        
        
          ]   
            
    
    });
 
 
    var orddetailgridds = new Ext.data.Store({
		proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            
            'incidesc',
            'qty',
		    'uomdesc',
		    'dosage',
		    'freq',
		    'spec',
		    'instruc',
		    'dura',
		    'realdura',
		    'form',
		    'basflag',
		    'doctor',
		    'orddate',
		    'remark',
		    'manf',
		    'orditm'
	    
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
        autoScroll:true,
        id:'orddetailtbl',
        enableHdMenu : false,
        ds: orddetailgridds,
        cm: orddetailgridcm,
        enableColumnMove : false,
        
        
        trackMouseOver:'true'
        

        
    });
	
	
	 //ҩ���󷽴��ڿؼ�

	
	var adtwinds = new Ext.data.Store({
		autoLoad: true,
		//proxy:"",
		url:unitsUrl+'?action=GetAdtWinDs&CTlocDr='+session['LOGON.CTLOCID'],
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['windesc','rowId'])
				
	});
	
	 
	 
	 var adtwinSelecter = new Ext.form.ComboBox({
				  id:'adtwinSelect',
				  fieldLabel:'�󷽴���',
				  width : 120,
				  store: adtwinds,
				  valueField:'rowId',
				  displayField:'windesc',
				  listWidth:250,
				  emptyText:'ѡ���󷽴���...',
		                  //allowBlank: false,
				  name:'adtwinSelect',
				  mode: 'local'
				  
				  		  
				  
	});
	
	
      
    	 //ҩ�����ҿؼ�

	
	var phlocInfo = new Ext.data.Store({
		autoLoad: true,
		//proxy:"",
		url:unitsUrl+'?action=GetStockPhlocDs&GrpDr='+session['LOGON.GROUPID'],
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['phlocdesc','rowId'])
				
	});
	
	 
	 
	 var PhaLocSelecter = new Ext.form.ComboBox({
				  id:'PhaLocSelecter',
				  fieldLabel:'ҩ������',
				  width : 120,
				  store: phlocInfo,
				  valueField:'rowId',
				  displayField:'phlocdesc',
				  listWidth:250,
				  emptyText:'ѡ��ҩ������...',
		                  allowBlank: false,
				  name:'PhaLocSelecter',
				  mode: 'local'
				  
				  		  
				  
	});
	
 //��ʼ��ҩ������
 //phlocInfo.on("load",function(store,record,opts){ setDefaultLoc(); });
	phlocInfo.on('load', function() {   
    	PhaLocSelecter.setValue(session['LOGON.CTLOCID'].toString());   
    }); 
 
 	PhaLocSelecter.on(
	'select',
	function(){		
		adtwinds.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=GetAdtWinDs&CTlocDr='+Ext.getCmp("PhaLocSelecter").getValue(), method:'GET'});
	        adtwinds.load();
		}
  	);
 
 //��ʼ����
	
  var stdatef=new Ext.form.DateField ({
               
  	            width : 120,
                xtype: 'datefield',
                format:'j/m/Y' ,
                fieldLabel: '��ʼ����',
                name: 'startdt',
                id: 'startdt',
                invalidText:'��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
                value:new Date
            })	
            
            
            
   var enddatef=new Ext.form.DateField ({
  	            width : 120,
                format:'j/m/Y' ,
                fieldLabel: '��ֹ����',
	        name: 'enddt',
	        id: 'enddt',
	        invalidText:'��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
	        value:new Date
            })
    
  
     
        
        
     //���˵ǼǺŲ�ѯ����

	
	var patientField=new Ext.form.TextField({
  
        width:120, 
        id:"patientTxt", 
        fieldLabel:"�ǼǺ�" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                FindWardList();
                            }
                        }
                    }
        })
        

   
     var DatePanel = new Ext.Panel({
         frame : true,
         bbar:[RefreshButton,'-',ReadCardButton,"-",OkButton,"-",BadButton,'-',ListLogButton,DaTongAnalyseButton,DaTongYDTSButton ],
         labelWidth:80,
         region:'center',
          items : [{
					layout : "column",
					items : [{
					            labelAlign : 'right',
								columnWidth : .3,
								layout : "form",
								items : [ PhaLocSelecter   ]
							 }, {
							    labelAlign : 'right',
								columnWidth : .3,
								layout : "form",
								items : [  stdatef   ]
							    
								
						        },{
						        
						        labelAlign : 'right',
								columnWidth : .3,
								layout : "form",
								items : [  enddatef ]
								
						        } ]
								   
								   
								   
								   
					},{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : .3,
										layout : "form",
										items : [  patientField  ]
									 },{
						        
						        labelAlign : 'right',
								columnWidth : .3,
								layout : "form",
								items : [  CardTypeComBo ]
								
						        },{
						        
						        labelAlign : 'right',
								columnWidth : .3,
								layout : "form",
								items : [  OnlyAdtChkbox ]
								
						        }
						        
						        ]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : .3,
										layout : "form",
										items : [ adtwinSelecter   ]
									 }]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : .3,
										layout : "form",
										items : [    ]
									 }]
					  }
					
					
					]

      
   })
    
    ////
    
     var toolform = new Ext.TabPanel({
        id:'ToolsTabPanel',
	    region: 'center',
	    margins:'3 3 0 3', 
	    frame : false,
	    activeTab: 0,
        items:[{
        title: '���ﴦ�����',	
		id:'frameordquery',
		layout:{  
		        type:'vbox', 
		        align: 'stretch',  
		        pack: 'start'  
		}, 
		items: [{           
         	  flex: 2,
         	  layout:'border',
         	  items:[DatePanel]  
         	 },{           
         	  flex: 4,
         	  layout:'border',
         	  items:[patlistgrid]  
         	 },{           
         	  flex: 3,
         	  layout:'border',
         	  items:[orddetailgrid]  
         	 }]
		
		
	    },{
	    			title: '����Ԥ��',	
					frameName: 'prescriptioninfo',
					html: '<iframe id="prescription" width=100% height=100% src= ></iframe>',		
					id:'prescriptioninfo'
					
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
	          		html: '<iframe id="framelabquery" width=100% height=100% src=dhcpha.comment.labquery.csp></iframe>',		
		  			src: 'dhcpha.comment.labquery.csp',
		  			id:'framelabquery'
	       
	
	    },{
	          		title: '�������',
	          		frameName: 'frameprbrowser',
	          		html: '<iframe id="frmeprbrowser" width=100% height=100% src=epr.newfw.episodelistuvpanel.csp></iframe>',		
		  			src: 'epr.newfw.episodelistuvpanel.csp',
		  			id:'frameprbrowser'
	       
	
	    },{
	          		title: '����ҽ��',
	          		frameName: 'frameadmordquery',
	          		html: '<iframe id="frameadmordquery" width=100% height=100% src=dhcpha.comment.admordquery.csp></iframe>',		
		  			src: 'dhcpha.comment.queryorditemds.csp',
		  			id:'frameadmordquery'
	       
	
	    }],
	    
	    listeners:{ 
                              tabchange:function(tp,p){ 
                                          HrefRefresh() ;
                                    }  ,
			      'render' : function(){   
					           //oneTbar.render(this.tbar); //add one tbar   
					           //BtnTbar.render(this.tbar); 
					    
					          }
                                
                      } 
	    
	    
	  
	    
	    
	});
	


      var port = new Ext.Viewport({

				layout : 'border',
				items : [toolform]

			});



			
	////////////////////////////////////////////////////////////////////////////////////
	
	////////***********************  ������Events����        *********************** 
	
	/////////////////////////////////////////////////////////////////////////////////////


	///����
	
	function ClearWindow()
	{
	
			orddetailgridds.removeAll();
			
			
			
	}
	
	
      //��������б�ѡ������
  function GetListInput()
  {
  	    sdate=Ext.getCmp("startdt").getRawValue().toString();
        edate=Ext.getCmp("enddt").getRawValue().toString();
        phlocdr=Ext.getCmp('PhaLocSelecter').getValue();
        patid=Ext.getCmp('patientTxt').getValue();
        onlyadt=Ext.getCmp('OnlyAdtChk').getValue();
        adtwin=Ext.getCmp('adtwinSelect').getValue();

  	    var listinputstr=sdate+"^"+edate+"^"+phlocdr+"^"+patid+"^"+onlyadt+"^"+adtwin ;
  	    
  	    return listinputstr
  }
		
	
   ///��0���˵ǼǺ�
  function GetWholePatID(RegNo)
	{    
	     if (RegNo=="") {
	        return RegNo;
	     }
	     
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
	    
	 	 Ext.getCmp('patientTxt').setValue(RegNo);
	 	
	 	 return RegNo;
	
	}
	
	//ȡ������
	function GetCardTypeRowId() 
	{
		var CardTypeRowId = "";
		var CardTypeValue = CardTypeComBo.getValue();
		
		if (CardTypeValue != "") {
			var CardTypeArr = CardTypeValue.split("^");
			CardTypeRowId = CardTypeArr[0];
		}
		return CardTypeRowId;
    }

	//����
   function BtnReadCardHandler()
   {
		var CardTypeRowId = GetCardTypeRowId();
		var myoptval = CardTypeComBo.getValue();
		var myrtn;
		//if(CardTypeComBo.getRawValue()=="���￨"){
		//myrtn=DHCACC_GetAccInfo("","")
		//}
		//else{
		myrtn = DHCACC_GetAccInfo(CardTypeRowId, myoptval);
		//}
		
		if (myrtn==-200){ //����Ч
				Ext.Msg.show({title:'����',msg:'����Ч!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
		}
	
		var myary = myrtn.split("^");
		var rtn = myary[0];
		
		switch (rtn) {
		case "0":
			//����Ч
			PatientID = myary[4];
			var PatientNo = myary[5];
			var CardNo = myary[1]
			var NewCardTypeRowId = myary[8];
			Ext.getCmp('patientTxt').setValue(PatientNo);
		    FindWardList();
			break;
		case "-200":
			//����Ч
			Ext.Msg.show({title:'����',msg:'����Ч!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			break;
		case "-201":
			//�ֽ�
			PatientID = myary[4];
			var PatientNo = myary[5];
			var CardNo = myary[1]
			var NewCardTypeRowId = myary[8];
	        Ext.getCmp('patientTxt').setValue(PatientNo);
		    FindWardList();
			break;
		 default:
	 
	}
	
  }
  

    //�񵽲����б�
   function FindWardList()
   {
      
         ClearWindow();
         var RegNo=Ext.getCmp('patientTxt').getValue();
         var RegNo=GetWholePatID(RegNo);
      	 InputStr=GetListInput();
         patlistst.removeAll() ;
		 waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݡA���Ժ�..." }); 
	     waitMask.show();
	                
		 patlistst.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=GetAdmPrescList&input='+InputStr  });		
						patlistst.load({
						params:{start:0, limit:patlistgridPagingToolbar.pageSize},
						callback: function(r, options, success){
		 
				        waitMask.hide();
				        if (success==false){
				                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		     		                     }else{
		     		                     	//DaTongPrescAnalyse();
                                                    if(r.length>0){ //�ж��Ƿ�������

                                                           Ext.getCmp("patlisttbl").getSelectionModel().selectRow(0);//ѡ�е�һ��
                                                           orddetailgrid.getView().focusRow(0);//��ȡ����
	                                                   var currow = patlistgrid.getSelectionModel().getSelected();
                                                           var prescno=currow.get("prescno") ;
							   var adm = currow.get("adm") ;
							   var zcyflag = currow.get("zcyflag") ;

						           PatInfo.adm=adm;
						           PatInfo.prescno =prescno;
	                                                   PatInfo.zcyflag=zcyflag;
	                                                   
                                                           FindOrdDetailData(prescno); 
                                                        }

		     		                     }
		      }
		     
		
		   });

	 
   }

/// �鿴ҽ����ϸ

function FindOrdDetailData(prescno)  
{
                //waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݡA���Ժ�..." }); 
                //waitMask.show();
                var onlyadt=Ext.getCmp('OnlyAdtChk').getValue();
                var input=onlyadt;
                orddetailgridds.removeAll();
				orddetailgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindOrdDetailData&PrescNo='+prescno+"&Input="+input });		
				orddetailgridds.load({
				params:{start:0, limit:orddetailgridcmPagingToolbar.pageSize},
				callback: function(r, options, success){
		 
				         
				         //waitMask.hide() ;
				         if (success==false){
				                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
				                     }
				          }

				         
				
				});
		
				
		
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
	 
	 
	 
	 var rows = Ext.getCmp("patlisttbl").getSelectionModel().getSelections(); 
	 var totalnum=rows.length;
	 
	 if (totalnum==0){
	    return;
	 }

	 for(var i=0;i<totalnum;i++){
		      
		        var row = rows[i];
		        var orditem=row.get("orditem") ;
		        var input=ret+"^"+User+"^"+advicetxt+"^"+factxt+"^"+phnote+"^"+grpdr+"^"+orditem;
		   
		        SaveCommontResult(reasondr,input)
	 }
		
		
	 
	 

     
     
     
 
}



///���ϸ�

function EditReason()
{
       
       var totalnum =orddetailgrid.getStore().getCount() ;
	   if (totalnum==0){
		    return;
		 }
        
       var orditm=orddetailgridds.getAt(0).get("orditm") ;
       
       var waycode = "8";
       
    
       var retstr=showModalDialog('dhcpha.comment.selectreason.csp?orditm='+orditm+'&waycode='+waycode,'','dialogHeight:600px;dialogWidth:1000px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no')
        
 
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
		
		
		var input=ret+"^"+User+"^"+advicetxt+"^"+factxt+"^"+phnote+"^"+grpdr+"^"+orditm;
		
		if (reasondr.indexOf("$$$")=="-1")
		{
			//reasondr=reasondr+"$$$"+orditm ;
		}
		
		
		SaveCommontResult(reasondr,input) 
       

}


///����������

function SaveCommontResult(reasondr,input)
{
        //var currow = ordgrid.getSelectionModel().getSelected();
        //var curdetail=orddetailgrid.getSelectionModel().getSelected();
   
        //var User=session['LOGON.USERID'] ;

        //alert(currow);
        //alert(orditm)
        //alert(reasondr)
        //alert(advicetxt)
        //alert(factxt)
        //
        
        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݡA���Ժ�..." ,removeMask: true}); 
        waitMask.show();
            
  		Ext.Ajax.request({

	        url:unitsUrl+'?action=SaveOPAuditResult&Input='+input+'&ReasonDr='+reasondr ,
			failure: function(result, request) {
				waitMask.hide() ;
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
			success: function(result, request) {
	            waitMask.hide() ;
				var jsonData = Ext.util.JSON.decode( result.responseText );
				  		
				//alert(jsonData.retvalue)
				//alert(jsonData.retinfo)	
				
				if (jsonData.retvalue==0){
	
	                               ReloadAfterSave();
				  
				}else{
				    msgtxt=jsonData.retinfo;

				    Ext.Msg.show({title:'��ʾ',msg:msgtxt,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}			  	 
	  		
	  		

		},
		
			scope: this
		});

    
}

  function ReloadAfterSave()
  {
  	FindWardList();
  }

	///��ʼ��Ĭ�Ͽ���
  
  function setDefaultLoc()
   { 

     var locdr=session['LOGON.CTLOCID'].toString();
     PhaLocSelecter.setValue(locdr) ;
    
   }  



 ///�鿴��־	
 function ListLogBtnClick()
 {

       
     	var rows = Ext.getCmp("patlisttbl").getSelectionModel().getSelections(); 
	var totalnum=rows.length;
	 
	if (totalnum==0){
	    return;
	 }
       
       var currow = patlistgrid.getSelectionModel().getSelected();
       var orditem=currow.get("orditem") ;
       
       FindItmLog(orditem);
 }

  ///��ͨҩ����ʾ
  function DaTongYDTSBtnClick()
  {		  
       	 var rows = Ext.getCmp("patlisttbl").getSelectionModel().getSelections(); 
		 var totalnum=rows.length;
		 
		 if (totalnum==0){
		    return;
		 }
		  var currow = orddetailgrid.getSelectionModel().getSelected();
		  var orditm =currow.get("orditm") ;

		  dtywzxUI(3,0,"");
		  var myPrescXML=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDTYDTS", orditm);

		  myrtn=dtywzxUI(12,0,myPrescXML);
  
  }
  
  //��ͨ��������
  function DaTongPrescAnalyse()
  {	

	 var totalnum =patlistgrid.getStore().getCount() ;
	 if (totalnum==0){
	    return;
	 }

	 for(var i=0;i<totalnum;i++){
		      
	 	        dtywzxUI(3,0,"");
		        var record = patlistgrid.getStore().getAt(i); 
		        var orditem =record.data.orditem ;
		        var myPrescXML=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDaTongOutPresInfo", orditem);
		        myrtn=dtywzxUI(28676,1,myPrescXML);
		        if (myrtn==0) {var imgname="greenlight.gif";}
				if (myrtn==1) {var imgname="yellowlight.gif";}
			    if (myrtn==2) {var imgname="blacklight.gif";}
			    
                var str="<img id='DrugUseImg"+i +"'"+" src='../scripts/dhcpha/img/"+imgname+"'>";
			    patlistgrid.getView().getCell(i,2).innerHTML=str
	 }
	 
  	
  }
  

	//�е���¼�
	function PatListGridCellClick(grid, rowIndex, columnIndex, e)
	{
              
		if (columnIndex==2){
               
		  dtywzxUI(3,0,"");
		  var record = patlistgrid.getStore().getAt(rowIndex); 
		  var orditem =record.data.orditem ;
		  var myPrescXML=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDaTongOutPresInfo", orditem);
		  myrtn=dtywzxUI(28676,1,myPrescXML);

		  
		  
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




});