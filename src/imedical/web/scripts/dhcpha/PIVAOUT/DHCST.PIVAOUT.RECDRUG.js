///������Һ�Ա�ҩ����JS
///Creator:LiangQiang
///CreatDate:2013-05-21
///

var unitsUrl = 'DHCST.PIVAOUT.SAVEURL.csp';
var waitMask;
var InputStr;


Ext.onReady(function() {

   Ext.QuickTips.init();// ������Ϣ��ʾ
   Ext.Ajax.timeout = 900000;

   
   
    //��ʼ����
	
  var stdatef=new Ext.form.DateField ({
               
  	            width : 150,
                xtype: 'datefield',
                format:'j/m/Y' ,
                fieldLabel: '��ʼ����',
                name: 'startdt',
                id: 'startdt',
                invalidText:'��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
                value:new Date
            })	
            
            
            
   var enddatef=new Ext.form.DateField ({
  	            width : 150,
                format:'j/m/Y' ,
                fieldLabel: '��ֹ����',
	        name: 'enddt',
	        id: 'enddt',
	        invalidText:'��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
	        value:new Date
            })
    
            
            
	 //ҩ�����ҿؼ�
	
	var phlocInfo = new Ext.data.Store({
		autoLoad: true,
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
				  mode: 'local'
				  
				  		  
				  
	});
	

	phlocInfo.on("load",function(store,record,opts){ setDefaultLoc(); });
	
	
	//���ۿ���
	var EmAreaInfo = new Ext.data.Store({
		autoLoad: false,
		proxy:"",
		reader: new Ext.data.JsonReader({
			totalProperty:"results",root:'rows',id: 'rowId'},['locdesc','rowId'])
	});

	EmAreaInfo.on('beforeload',function(ds,o){
		ds.proxy = new Ext.data.HttpProxy({
			url:unitsUrl+'?action=GetGetLgAreaDs', method:'GET'});
		}
	);
	
	 
	 
	///����
	var EmAreaSelecter = new Ext.form.ComboBox({
		id:'EmAreaSelecter',
		fieldLabel:'������',
		store: EmAreaInfo,
		valueField:'rowId',
		displayField:'locdesc',
		width : 150,
		listWidth:250,
		emptyText:'ѡ�����ۿ���...',
		//allowBlank: false,
		name:'EmAreaSelecter',
		mode: 'local'
	});
	
	EmAreaInfo.load();
	
	
  	   //ˢ��
   var  RefreshButton = new Ext.Button({
             width : 70,
             id:"RefreshBtn",
             text: '��ѯ',
             icon:"../scripts/dhcpha/img/find.gif",
             listeners:{
                          "click":function(){   
                             
                                 FindPatList("1");
                              
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
             text: '����',
             icon:"../scripts/dhcpha/img/accept.png",
             listeners:{
                          "click":function(){   
                                var view = orddetailgrid.getView();
	  	                        var rows=view.getRows().length-1 ;
	  	                       if (rows!=-1) {
                              SaveRecData("REC");
	  	                       }
                              
                              }   
             }
             
             
             })
             

    
    var RevokeButton = new Ext.Button({
             width : 65,
             id:"RevokeBtn",
             text: '����',
             icon:"../scripts/dhcpha/img/cancel.png",
             listeners:{
                          "click":function(){   
                                                             var view = orddetailgrid.getView();
	  	                        var rows=view.getRows().length-1 ;
	  	                       if (rows!=-1) {
                              SaveRecData("REF");
	  	                       }
                              
                              }   
             }
             
             
    })
    

        
    
   //�ѽ���
   var OnlyRecChkbox=new Ext.form.Checkbox({
        
		boxLabel : '�ѽ���',
		id : 'OnlyRecChk',
		inputValue : '1',
		checked : false,
		listeners:{
					'check': function(){
	
					}
		}
    })
    
    CardTypeStore = eval("(" + CardTypeArray + ')');
    
    var CardTypeDs= new Ext.data.ArrayStore({
				autoDestroy : true,
				fields : ['desc', 'value'],
				data : CardTypeStore
				
			})
    
    var CardTypeComBo = new Ext.form.ComboBox({
			fieldLabel:'������',
			width : 150,
			typeAhead : true,
			height : 100,
			//renderTo:'LocListDiv',
			triggerAction : 'all',
			store : CardTypeDs,
			mode : 'local',
			valueField : 'value',
			displayField : 'desc',
			listeners : {
				//change: LocChangeHandler
			}
		});
		
    setDefaultCardType();
		
	//���Ҳ����б�ؼ�
	
    var patlistst = new Ext.data.Store({
	    proxy: "",
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	        }, [
	            'patid',
	            'patname',
	            'patsex',
	            'patage',
	            'adm'
			]),
	    // turn on remote sorting
	    remoteSort: true
	});

	  var patlistcm = new Ext.grid.ColumnModel([
	  
	        {header:'�ǼǺ�',dataIndex:'patid',width: 80,menuDisabled :'false'},
	        {header:'����',dataIndex:'patname',width: 60,menuDisabled :'false'},
	        {header:'�Ա�',dataIndex:'patsex',width: 60,menuDisabled :'false'},
	        {header:'����',dataIndex:'patage',width: 60,menuDisabled :'false'},
	        {header:'adm',dataIndex:'adm',width: 60,menuDisabled :'false',hidden:true}
	        
	       
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
	        enableColumnMove : false,
	        trackMouseOver: true,
	        stripeRows: true,
	        ds: patlistst,
	        cm: patlistcm,
	        bbar: patlistgridPagingToolbar,
	        trackMouseOver:'true'
	    });
	
	    
		///�����б�grid �������¼�

	    patlistgrid.on('rowclick',function(grid,rowIndex,e){
	
	        var selectedRow = patlistst.data.items[rowIndex];
		    var RegNo = selectedRow.data["patid"];
                     orddetailgridds.removeAll();
			FindOrdDetailData(RegNo);
	    }); 
	    


   function selectbox(re,params,record,rowIndex){

    return '<input type="checkbox" id="TSelectz'+rowIndex+'" name="TSelectz'+rowIndex+'"  value="'+re+'"  >';

   }
    
  var sm = new Ext.grid.CheckboxSelectionModel();
  var orddetailgridcm = new Ext.grid.ColumnModel([

        {header:'<input type="checkbox" id="TDSelectOrdItm" >',width:40,menuDisabled:true,dataIndex:'select',renderer:selectbox},
        {header:'��ҩ����',dataIndex:'orddate',width:130},
        {header:'������',dataIndex:'prescno',width:100},
        {header:'ҩƷ����',dataIndex:'incidesc',width:200},
        {header:'����',dataIndex:'qty',width:40},
        {header:'��λ',dataIndex:'uomdesc',width:60},
        {header:'����',dataIndex:'dosage',width:80},
        {header:'Ƶ��',dataIndex:'freq',width:60},
        {header:'���',dataIndex:'spec',width:80},
        {header:'�÷�',dataIndex:'instruc',width:80},
        {header:'��ҩ�Ƴ�',dataIndex:'dura',width:60},
        {header:'����',dataIndex:'form',width:80},
        {header:'ҽ��',dataIndex:'doctor',width:60},
        {header:'ҽ����ע',dataIndex:'remark',width:60},
        {header:'orditm',dataIndex:'orditm',hidden:true},
        {header:'selectflag',dataIndex:'selectflag',hidden:true},
        {header:'����״̬',dataIndex:'recstatus',width:60},
        {header:'������',dataIndex:'recuser',width:60},
        {header:'����ʱ��',dataIndex:'recdate',width:130},
        {header:'pdisstring',dataIndex:'pdisstring',width:60}
        

    
       ]);
 
 
    var orddetailgridds = new Ext.data.Store({
		proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [

            'select',
            'orddate',
            'prescno',
            'incidesc',
            'qty',
		    'uomdesc',
		    'dosage',
		    'freq',
		    'spec',
		    'instruc',
		    'dura',
		    'form',
		    'doctor',
		    'remark',
		    'orditm',
		    'selectflag',
		    'pdisstring',
		    'recstatus',
		    'recuser',
		    'recdate'
	    
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
 
 
 var orddetailgrid = new Ext.grid.EditorGridPanel({
        
        stripeRows: true,
        region:'center',
        margins:'0 0 3 3', 
        autoScroll:true,
        id:'orddetailtbl',
        enableHdMenu : false,
        ds: orddetailgridds,
        cm: orddetailgridcm,
        enableColumnMove : false,
        tbar:[OkButton,'-',RevokeButton],
        clicksToEdit: 1,
        trackMouseOver:'true'


        

        
    });
	
   orddetailgrid.on('cellclick',OrddetailGridCellClick) 
   
   
   orddetailgrid.on('headerclick', function(grid, columnIndex, e) { 
	
   	     
         if (columnIndex==0){
         	selectAllRows();
         };
     
	
	});
	
  
     //���˵ǼǺŲ�ѯ����

	
	var patientField=new Ext.form.TextField({
  
        width:150, 
        id:"patientTxt", 
        fieldLabel:"�ǼǺ�" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                FindPatInfo();
                            }
                        }
                    }
        })
        

   
     var datePanel = new Ext.Panel({
         frame : true,
         bbar:[RefreshButton,'-',ReadCardButton],
         labelWidth:60,
         buttonAlign:'center',
         items : [{
					layout : "column",
					items : [{
					            labelAlign : 'right',
								columnWidth : 1,
								layout : "form",
								items : [ PhaLocSelecter   ]
							 } ]
	   
								   
					},{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : 1,
										layout : "form",
										items : [   stdatef ]
									 }]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : 1,
										layout : "form",
										items : [   enddatef ]
									 }]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : 1,
										layout : "form",
										items : [   EmAreaSelecter ]
									 }]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : 1,
										layout : "form",
										items : [   patientField ]
									 }]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : 1,
										layout : "form",
										items : [ CardTypeComBo  ]
									 }]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : 1,
										layout : "form",
										items : [ OnlyRecChkbox   ]
									 }]
					  }]

      
   })
    

         
     var westPanel = new Ext.Panel({  
         title: '�����Ա�ҩ',
         region:'west',
         collapsible: true,
         margins:'0 3 0 0',
         width:300,
         frame : true,
         layout:{  
	        type:'vbox', 
	        align: 'stretch',  
	        pack: 'start'  
         },
	 items: [{         
	 	  flex: 3.5,
	 	  layout:'fit',
	 	  items:[datePanel]  
	 	 },{   
	 	  flex: 5 ,
	 	  layout:'fit',
	 	  items:[patlistgrid]    
	       }]  
     });   
   
    ////
    
     var centerPanel = new Ext.Panel({
        id:'centerform',
	    region: 'center',
	    margins:'3 3 0 3', 
	    frame : false,
		layout:{  
		        type:'vbox', 
		        align: 'stretch',  
		        pack: 'start'  
		}, 
		items: [{           
         	  flex: 1,
         	  layout:'border',
         	  items:[orddetailgrid]  
         	 }]

	    
	});
	
  

      var port = new Ext.Viewport({

				layout : 'border',
				items : [westPanel,centerPanel]

			});
			
  ///////  Event      ///////////////////////

    //����Ĭ�Ͽ���
	function setDefaultLoc()
	{
		
		if (phlocInfo.getTotalCount() > 0){
                PhaLocSelecter.setValue(phlocInfo.getAt(0).data.rowId);
        }

	}
	
	//����Ĭ�Ͽ�����
	function setDefaultCardType()
	{
		if (CardTypeDs.getTotalCount() > 0){
                CardTypeComBo.setValue(CardTypeDs.getAt(0).data.value);
        }

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
	
	
	///����
	function ClearWindow()
	{
			orddetailgridds.removeAll();
			patlistst.removeAll();
	
	}
	
	//��ѯ������Ϣ
   function FindPatInfo()
	{
		 ClearWindow();
         var RegNo=Ext.getCmp('patientTxt').getValue();
         if (RegNo==""){Ext.Msg.alert("��ʾ", "������ǼǺ�!"); return;}
         var RegNo=GetWholePatID(RegNo);
		var sdate=Ext.getCmp("startdt").getRawValue().toString();
		var edate=Ext.getCmp("enddt").getRawValue().toString();
		var phlocdr=Ext.getCmp('PhaLocSelecter').getValue();
		if (sdate=="") {Ext.Msg.show({title:'ע��',msg:'��ʼ���ڲ���Ϊ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		if (edate=="") {Ext.Msg.show({title:'ע��',msg:'�������ڲ���Ϊ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		if (phlocdr=="") {Ext.Msg.show({title:'ע��',msg:'���Ҳ���Ϊ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		  
          
          
         waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ�������,���Ժ�..." }); 
	     waitMask.show();          
		 patlistst.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=GetPatInfo&RegNo='+RegNo  });		
						patlistst.load({
						params:{start:0, limit:200},
						callback: function(r, options, success){
		 
				        waitMask.hide();
				        if (success==false){
				                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                              }else{
		                              	    if(r.length>0){ //�ж��Ƿ�������

                                                          Ext.getCmp("patlisttbl").getSelectionModel().selectRow(0);//ѡ�е�һ��
                                                          //orddetailgrid.getView().focusRow(0);//��ȡ����
	                                                      //var currow = patlistgrid.getSelectionModel().getSelected();
		                                                  //var prescno=currow.get("prescno") ;
                                                          //FindOrdDetailData(prescno); 
                                                    }
		                              }
						}
		     
		
		   });
		   
		   
		   
	}
	
	 //��������б�ѡ������
	  function GetListInput()
	  {
	  	    sdate=Ext.getCmp("startdt").getRawValue().toString();
	        edate=Ext.getCmp("enddt").getRawValue().toString();
	        phlocdr=Ext.getCmp('PhaLocSelecter').getValue();
	        patid=Ext.getCmp('patientTxt').getValue();
	        onlyrec=Ext.getCmp('OnlyRecChk').getValue();
	        var emlocdr=Ext.getCmp('EmAreaSelecter').getValue();
	  	    var listinputstr=sdate+"^"+edate+"^"+phlocdr+"^"+patid+"^"+onlyrec+"^"+emlocdr ;
	  	    
	  	    return listinputstr
	  }
	
	  //��ѯ�����б�
	  function FindPatList(inputflag)
	  {
		  	
		  	if (inputflag==1){
		  	   FindPatInfo();
		  	}
		  	if (inputflag==2){
		  	   //FindPatInfo();
		  	}
	  	
	  }
	  
	 
	function FindOrdDetailData(RegNo)
	{
		    var sdate=Ext.getCmp("startdt").getRawValue().toString();
	        var edate=Ext.getCmp("enddt").getRawValue().toString();
	        var phlocdr=Ext.getCmp('PhaLocSelecter').getValue();
		if (sdate=="") {Ext.Msg.show({title:'ע��',msg:'��ʼ���ڲ���Ϊ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		if (edate=="") {Ext.Msg.show({title:'ע��',msg:'�������ڲ���Ϊ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		if (phlocdr=="") {Ext.Msg.show({title:'ע��',msg:'���Ҳ���Ϊ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		
		
		        var input=GetListInput();
		        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ�������,���Ժ�..." }); 
	            waitMask.show();  
                orddetailgridds.removeAll();
                document.getElementById("TDSelectOrdItm").checked=false;
				orddetailgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindReqDetailData&RegNo='+RegNo+"&Input="+input });		
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
	 
	
	
	//�е����¼�
  function OrddetailGridCellClick(grid, rowIndex, columnIndex, e)
  {

        if (columnIndex==0){

					  	  var newmoeori="";
					      var record = orddetailgrid.getStore().getAt(rowIndex);
					  	  var moeori =record.data.selectflag ;
					      
						 
					      var view = orddetailgrid.getView();
					      var store = orddetailgrid.getStore();
					      
					      if (document.getElementById("TSelectz"+rowIndex).checked)
					      {
					      	   for (i=1;i<=view.getRows().length-1;i++)
					      	   {
							       if(document.getElementById("TSelectz"+i).checked){       
							          //rsm.deselectRow(i)  
							       }
							       else
							       { 
							         var record = orddetailgrid.getStore().getAt(i);
							  	     var newmoeori =record.data.selectflag ;
							  	     
							  	     if (newmoeori==moeori){
							  	     	 document.getElementById("TSelectz"+i).checked=true;
							  	     }
							  	     else
							  	     {
							  	     	if (i>rowIndex) break;
							  	     }
							       	
							
							       }
					       
					           }
					
					      }else{
					      	   
					      	   for (i=1;i<=view.getRows().length-1;i++)
					      	   {
							       if(document.getElementById("TSelectz"+i).checked){       
							         var record = orddetailgrid.getStore().getAt(i);
							  	     var newmoeori =record.data.selectflag ;
							  	     
							  	     if (newmoeori==moeori){
							  	     	 document.getElementById("TSelectz"+i).checked=false;
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
		   
    
          
  }

  
  
 
  
  //ȫѡ/ȫ���¼�
  function selectAllRows()
  {
  	       var cellselected=document.getElementById("TDSelectOrdItm").checked ;
  	       var view = orddetailgrid.getView();
  	       var rows=view.getRows().length ;
  	       if (rows==0) return;
	       for (i=0;i<=rows-1;i++)
      	   {
      	   	   if (cellselected){
      	   	   	  document.getElementById("TSelectz"+i).checked=true;
      	   	   }else{
      	   	   	  document.getElementById("TSelectz"+i).checked=false;
      	   	   }
      	   	   

       
           }
  	
  }
  


  function SaveRecData(opflag)
  {
  	       try{
  	       	       var view = orddetailgrid.getView();
	  	       var rows=view.getRows().length-1 ;
	  	       if (rows==-1) return;
	  	         var rets=CheckSelect();
           if(rets==0) return;   
	  	   if(CheckDataBeforeSave()==true){ 
		       for (i=0;i<=rows;i++)
	      	       {
	      	       	   var cellselected=document.getElementById("TSelectz"+i).checked
	      	   	   if (cellselected){
	      	   	   	  var record = orddetailgrid.getStore().getAt(i);
	                          var pdisstring =record.data.pdisstring ;
	                          
	                          SaveData(i,pdisstring,opflag);
	                          //alert(i)
	      	   	   	 
	      	   	   }
	       
	          	}
	          	FindOrdDetailData(RegNo);
	  	    }
	  	     
  	       }finally { 
	  	       	 var selectedRow = patlistgrid.getSelectionModel().getSelected(); 
			 var RegNo = selectedRow.data["patid"];
			
  	       }


	        
	       
   }
   	 function CheckSelect()
	 {          
	     var view = orddetailgrid.getView();
  	       var rows=view.getRows().length ;
  	       var retflag=0
	 	       for (i=0;i<=rows-1;i++)
      	       { 
      	        var cellselected=document.getElementById("TSelectz"+i).checked
      	   	   	if (cellselected){
                    retflag=1
      	   	   	}
      	      if (retflag==1)
      	       {break;}
      	      }
	  return retflag
	 }			
function CheckDataBeforeSave()
 {
           var view = orddetailgrid.getView();
  	       var rows=view.getRows().length ;
  	       var retflag=0
	 	       for (i=0;i<=rows-1;i++)
      	       { 
      	        var cellselected=document.getElementById("TSelectz"+i).checked
      	   	   	if (cellselected){
	      	      var record = orddetailgrid.getStore().getAt(i);
                  var resulted =record.data.recstatus;
                  
                 if(resulted!=""){
	                 var retflag=1
	      	       Ext.Msg.show({title:'����',msg:'�Ѵ������ݲ����ظ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	 	 	       return false;
      	           }
      	   	   	}
      	   	   if (retflag==1)
      	       {break;}
      	      }

	return true;  	  
	 
 }


 function SaveData(i,pdisstring,opflag)
 {
 	        ///���ݿ⽻��
	        var recuser=session['LOGON.USERID'] ;
                
	        var ret=tkMakeServerCall("web.DHCSTPIVAOUTRECDRUG", "ReceiveDrug",pdisstring,recuser,opflag);

	        if  (ret==0){
	        	 //orddetailgrid.getStore().removeAt(i); 
	        }
	        else{
	                 if (ret=="-2"){
	                	 //Ext.Msg.alert("��ʾ", "�����ظ�����");
	                	 //alert("��ʾ,�����ظ�����")	
	                	 //Ext.Msg.alert('','',function(){alert(1)}) 
                	         alert("��ʾ,�����ظ�����")
	                	 return;
	                 }
	                 if (ret=="-1"){
	                	 Ext.Msg.alert("��ʾ", "�ѳ�������,���ܽ���");	
	                	 return;
	                 }
	                 Ext.Msg.alert("��ʾ", "����ʧ��!����ֵ: "+ret);
	        }
	
  } 
	  







});