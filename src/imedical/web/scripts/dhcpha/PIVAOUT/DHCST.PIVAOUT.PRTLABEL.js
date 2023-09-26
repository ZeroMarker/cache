///��Һƿǩ����JS
///Creator:LiangQiang
///CreatDate:2013-05-29
///

var unitsUrl = 'DHCST.PIVAOUT.SAVEURL.csp';
var waitMask;

//����ƿǩ״̬��Ϣ
function showWin(value)
{
	OpenShowStatusWin("",value);
}

//�������˻�����Ϣ
function showPatInfoWin(value)
{
	OpenShowPatInfoWin(value);
}

Ext.onReady(function() {

  Ext.QuickTips.init();// ������Ϣ��ʾ
  Ext.Ajax.timeout = 900000;



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
				  width : 160,
				  listWidth:250,
				  emptyText:'ѡ��ҩ������...',
		          allowBlank: false,
				  name:'PhaLocSelecter',
				  mode: 'local'
				  
				  		  
				  
	});
	

	phlocInfo.on("load",function(store,record,opts){ setDefaultLoc(); });
	
	
  	   //ˢ��
    var  RefreshButton = new Ext.Button({
             width : 70,
             id:"RefreshBtn",
             text: '��ѯ',
             iconCls:'page_query',
             //icon:"../scripts/dhcpha/img/find.gif",
             listeners:{
                          "click":function(){   
                             
                                 FindReqPrtDetail();
                              
                              }   
             }
             
             
   })
  



  var PrtButton = new Ext.Button({
             width : 90,
             id:"PrtButton",
             text: '��ӡ[F8]',
             tooltip:'F8��ݼ�',
             iconCls:'page_print',
             //icon:"../scripts/dhcpha/img/printer.png",
             listeners:{
                          "click":function(){   
                            
                              SavePrtData();

                              }   
             }
             
             
             })
             
    var map = new Ext.KeyMap(Ext.getDoc(), [{
    key: 119,
    fn:function(){SavePrtData();},
    scope: this
    }]
    );   
   //�Զ�ˢ�´�ӡ
   var AutoPrtChkbox=new Ext.form.Checkbox({
        
		boxLabel : '�Զ�ˢ�´�ӡ',
		id : 'AutoPrtChk',
		inputValue : '1',
		checked : false,
		listeners:{
					'check': function(){
						if (Ext.getCmp("AutoPrtChk").getValue())
						{
							StartAutoLoad();
						}
					        else{
					       
					               StopAutoLoad();
	
						}
	
					}
		}
    })
    

 
    //���Ҳ����б�ؼ�
	
    var patlistst = new Ext.data.Store({
	    proxy: "",
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	        }, [
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
				'orditem'
			]),
	    // turn on remote sorting
	    remoteSort: true
	});
	    
	  
	
	  var patlistcm = new Ext.grid.ColumnModel([
	  
	        {header:'�ǼǺ�',dataIndex:'patid',width: 90,menuDisabled :'false'},
	        {header:'����',dataIndex:'patname',width: 60,menuDisabled :'false'},
	        {header:'�Ա�',dataIndex:'patsex',width: 60,menuDisabled :'false'},
	        {header:'����',dataIndex:'patage',width: 60,menuDisabled :'false'},
	        {header:'���',dataIndex:'path',width: 60,menuDisabled :'false'},
	        {header:'����',dataIndex:'patw',width: 60,menuDisabled :'false'},
	        {header:'�ѱ�',dataIndex:'billtype',width: 90,menuDisabled :'false'},
	        {header:'�������',dataIndex:'patloc',width: 90,menuDisabled :'false'},
	        {header:'���',dataIndex:'diag',width: 400,menuDisabled :'false'},
	        {header:'adm',dataIndex:'adm',hidden:'true',ortable:'false'}
	        
	       
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
	       // bbar: patlistgridPagingToolbar,
	        trackMouseOver:'true'
	    });
	    
	///�����б�grid �������¼�

	    

    
         ///ҽ����ϸ����table
  function selectbox(re,params,record,rowIndex){

    return '<input type="checkbox" id="TSelectz'+rowIndex+'" name="TSelectz'+rowIndex+'"  value="'+re+'"  >';

   } 
   
  function showUrl(value, cellmeta, record, rowIndex, colIndex, store) {
    return "<a href='javascript:showWin(\""+record.get("dsprowid")+"\")'/>"+value+"</a>";
  }

  function showPatInfoUrl(value, cellmeta, record, rowIndex, colIndex, store) {
    return "<a href='javascript:showPatInfoWin(\""+record.get("dsprowid")+"\")'/>"+value+"</a>";
  }

  var orddetailgridcm = new Ext.grid.ColumnModel({
  
  columns:[

        {header:'<input type="checkbox" id="TDSelectOrdItm" >',width:40,menuDisabled:true,dataIndex:'select',renderer:selectbox},
        
        {header:'�ǼǺ�',dataIndex:'patid',width:80,renderer:showPatInfoUrl},
        {header:'����',dataIndex:'patname',width:60},
        {header:'��ҩ����',dataIndex:'orddate',width:130},
        {header:'������',dataIndex:'prescno',width:100,renderer:showUrl},
        {header:'������hide',dataIndex:'prescnoT',width:100,hidden:true},
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
        {header:'ҽ����ע',dataIndex:'remark',width:120},
        {header:'selectflag',dataIndex:'selectflag',hidden:true},
        {header:'dsprowid',dataIndex:'dsprowid',hidden:true},
        {header:'���',dataIndex:'packflag',width:60},
        {header:'����״̬',dataIndex:'omflag',width:60}  //ԭ�����н��Ա�ҩ,yunhaibao20151224
        
          ]   
            
    
    });
 
 
    var orddetailgridds = new Ext.data.Store({
		proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'select',
            'patid',
            'patname',
            'orddate',
            'prescno',
            'prescnoT',
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
		    'selectflag',
		    'dsprowid',
		    'packflag',
	    	'omflag'
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
        bbar:orddetailgridcmPagingToolbar,
        trackMouseOver:'true',
		viewConfig:{
		forceFit:true,
		enableRowBody : true,
		getRowClass :function(record,rowIndex,rowParams,store) {
	        var cls="";
	        if(record.data.packflag=="Y"){
                cls = 'x-grid-record-lightgreen';}
	        
            return cls;
            }
		}
        
    });
	

   orddetailgrid.on('cellclick',OrddetailGridCellClick) 
   
   
   orddetailgrid.on('headerclick', function(grid, columnIndex, e) { 
	
   	     
         if (columnIndex==0){
         	selectAllRows();
         };
     
	
	});
	
	
 
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
  
        width:160, 
        id:"patientTxt", 
        fieldLabel:"�ǼǺ�" ,
        listeners: {
                        specialkey: function (textfield, e) {
                            if (e.getKey() == Ext.EventObject.ENTER) {
                                FindReqPrtDetail();
                            }
                        }
                    }
        })
        

   
     var DatePanel = new Ext.Panel({
     	 title:'��Һƿǩ',
         frame : true,
         margins:'1 0 0 0', 
         bbar:[RefreshButton,"-",PrtButton],
         labelWidth:80,
         region:'center',
          items : [{
					layout : "column",
					items : [{
					            labelAlign : 'right',
								columnWidth : .2,
								layout : "form",
								items : [ PhaLocSelecter   ]
							 }, {
							    labelAlign : 'right',
								columnWidth : .2,
								layout : "form",
								items : [  stdatef   ]
							    
								
						        },{
						        
						        labelAlign : 'right',
								columnWidth : .2,
								layout : "form",
								items : [   ]
								
						        } ]
								   
								   
								   
								   
					},{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : .2,
										layout : "form",
										items : [  patientField  ]
									 },{
						        
						        labelAlign : 'right',
								columnWidth : .2,
								layout : "form",
								items : [  enddatef ]
								
						        },{
						        
						        labelAlign : 'right',
								columnWidth : .2,
								layout : "form",
								items : [ AutoPrtChkbox  ]
								
						        }
						        
						        ]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : .2,
										layout : "form",
										items : [    ]
									 }]
					  },{
							layout : "column",
							items : [{ 
							            labelAlign : 'right',
										columnWidth : .2,
										layout : "form",
										items : [    ]
									 }]
					  }
					
					
					]

      
   })
    
    ////
    
     var centerform = new Ext.Panel({
        id:'centerform',
	    region: 'center',
	    margins:'1 0 0 0', 
	    frame : false,
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
         	  flex: 8,
         	  layout:'border',
         	  items:[orddetailgrid]  
         	 }]
		

	    
	});
	


      var port = new Ext.Viewport({

				layout : 'border',
				items : [centerform]

			});
		
	///////////////////////������Events//////////////////
		
	 //����Ĭ�Ͽ���
	function setDefaultLoc()
	{
		
		if (phlocInfo.getTotalCount() > 0){
                PhaLocSelecter.setValue(phlocInfo.getAt(0).data.rowId);
        }

	}
			
			
		 //��������б�ѡ������
	  function GetListInput()
	  {
	  	    sdate=Ext.getCmp("startdt").getRawValue().toString();
	        edate=Ext.getCmp("enddt").getRawValue().toString();
	        phlocdr=Ext.getCmp('PhaLocSelecter').getValue();
	        patid=Ext.getCmp('patientTxt').getValue();

	  	    var listinputstr=sdate+"^"+edate+"^"+phlocdr+"^"+patid ;
	  	    
	  	    return listinputstr
	  }		

			
	function FindReqPrtDetail()
	{
		        var RegNo=Ext.getCmp('patientTxt').getValue();
                var RegNo=GetWholePatID(RegNo);
		var sdate=Ext.getCmp("startdt").getRawValue().toString();
		var edate=Ext.getCmp("enddt").getRawValue().toString();
		var phlocdr=Ext.getCmp('PhaLocSelecter').getValue();
		if (sdate=="") {Ext.Msg.show({title:'ע��',msg:'��ʼ���ڲ���Ϊ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		if (edate=="") {Ext.Msg.show({title:'ע��',msg:'�������ڲ���Ϊ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		if (phlocdr=="") {Ext.Msg.show({title:'ע��',msg:'���Ҳ���Ϊ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		
		        var input=GetListInput();
		        waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ�������,���Ժ�..." }); 
	            waitMask.show();  
                ClearDocument();
				orddetailgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindReqPrtDetail&RegNo='+RegNo+"&Input="+input });		
				orddetailgridds.load({
				params:{start:0, limit:orddetailgridcmPagingToolbar.pageSize},
				callback: function(r, options, success){
				         
				         waitMask.hide();
				         if (success==false){
				                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
				                     }
				                     else{
						               
				          	     }
				          }

				         
				
				});
		   
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
			

  	//�е����¼�
  function OrddetailGridCellClick(grid, rowIndex, columnIndex, e)
  {

        if (columnIndex==0){

					  	  var newmoeori="";
					      var record = orddetailgrid.getStore().getAt(rowIndex);
					  	  var moeori =record.data.selectflag ;
					      var mprescno =record.data.prescnoT ;
						 
					      var view = orddetailgrid.getView();
					      var store = orddetailgrid.getStore();
					      
					      if (document.getElementById("TSelectz"+rowIndex).checked)
					      {
					      	   for (i=0;i<=view.getRows().length-1;i++)
					      	   {
							       if(document.getElementById("TSelectz"+i).checked){       
							          //rsm.deselectRow(i)  
							       }
							       else
							       { 
							         var record = orddetailgrid.getStore().getAt(i);
							  	     var newmoeori =record.data.selectflag ;
							  	     var newprescno =record.data.prescnoT ;
							  	     
							  	     if ((newmoeori==moeori)||(newprescno==mprescno)){
							  	     	 document.getElementById("TSelectz"+i).checked=true;
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
							       if(document.getElementById("TSelectz"+i).checked){       
							         var record = orddetailgrid.getStore().getAt(i);
							  	     var newmoeori =record.data.selectflag ;
							  	     var newprescno =record.data.prescnoT ;
							  	     
							  	     if ((newmoeori==moeori)||(newprescno==mprescno)){
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
  
///����ƿǩ  
function SavePrtData()
{
	var pogidstr="" ;
	var view = orddetailgrid.getView();
	var rows=view.getRows().length-1 ;
	if (rows==-1) return;
	var user=session['LOGON.USERID'] ;
	var h=0;  //ѡ���־
	var m=0;
	var dspstr="";printno="";
	for (i=0;i<=rows;i++)
	{
		var cellselected=document.getElementById("TSelectz"+i).checked
		if (!(cellselected))  continue;
		h=h+1;
		var record = orddetailgrid.getStore().getAt(i);
		var prescno =record.data.prescno;
		var selectflag =record.data.selectflag;
		var dsprowid =record.data.dsprowid;
		if (selectflag!=""){
			if (h==1)
			{	
				var dspstr="";
			}else{
				m=m+1;
				var ret=tkMakeServerCall("web.DHCSTPIVAOUTPRTLABEL", "SavePrtLabelData",printno,dspstr,user,m)
				if (ret.indexOf("^")>=0){
					var tmparr=ret.split("^");
					var rowid=tmparr[0];
					var printno=tmparr[1];
					//��֯��ӡID��
					if (pogidstr==""){
						pogidstr=rowid ;
					}else{
						pogidstr=pogidstr+"^"+rowid ;
						}
				}
				var dspstr="" ; 
				}
		}   

		if (dspstr==""){
			dspstr=dsprowid ;
		}else{
			dspstr=dspstr+","+dsprowid ;
		}                     
	}

	if (dspstr!="") {
		m=m+1;
		var ret=tkMakeServerCall("web.DHCSTPIVAOUTPRTLABEL", "SavePrtLabelData",printno,dspstr,user,m)
		if (ret.indexOf("^")>=0){
			var tmparr=ret.split("^");
			var rowid=tmparr[0];
			var printno=tmparr[1];
			//��֯��ӡID��
			if (pogidstr==""){
				pogidstr=rowid ;
			}else{
				pogidstr=pogidstr+"^"+rowid ;
			}
		}
	}
	///��ӡ
	if (pogidstr!=""){PrintClick(pogidstr)};
	///ˢ��
	FindReqPrtDetail(); 
}	

//��������
function SaveData(dspstr,user)
{
	var ret=tkMakeServerCall("web.DHCSTPIVAOUTPRTLABEL", "SavePrtLabelData",printno,dspstr,user);
	return ret;
}
   
//�Զ���ӡ
function AutoPrintLabel()
{
	var input=GetListInput();
	ClearDocument();
	var user=session['LOGON.USERID'] ;   
	var ret=tkMakeServerCall("web.DHCSTPIVAOUTPRTLABEL","AutoFindPrtLabelData",input,user);	

	if (ret!="")
	{
		PrintClick(ret);
	}


}
	
var task_RealTimeMointor = {
	run : AutoPrintLabel  ,//ִ������ʱִ�еĺ���
	interval : 20000 
	//������������Ϊ��λ��������10��
}

//�����Զ�	
function StartAutoLoad()
{		
	 Ext.TaskMgr.start(task_RealTimeMointor);
 
}

//�ر��Զ�
function StopAutoLoad()
{
     Ext.TaskMgr.stop(task_RealTimeMointor);
         
}
  
//���
function ClearDocument()
{
	orddetailgridds.removeAll();
	document.getElementById("TDSelectOrdItm").checked=false;  

}
    
   //������ӡ
  function PrintClick(pogstr)
  {

	 var tmparr=pogstr.split("^");
         var cnt=tmparr.length;
         for (i=0;i<cnt;i++){
         	var pogid=tmparr[i];
         	PrintLabel(pogid);  //��ӡƿǩ
             
         }
         
         //��ӡ�嵥
         var startNo=2;
         var prtpath=GetPrintPath();
   	     var Template=prtpath+"DHCST_PIVAOUT_PRTDETAIL.xls";
         var xlApp = new ActiveXObject("Excel.Application");		
         var xlBook = xlApp.Workbooks.Add(Template);
         var xlsheet = xlBook.ActiveSheet ;
         xlsheet.Cells(1, 1).Value ="��ҩ�嵥";
         xlsheet.Cells(2, 1).Value =""//
         var h=0;
         
         var cnt=tmparr.length;
         for (i=0;i<cnt;i++){
         	var pogid=tmparr[i];
         	var pogistr=tkMakeServerCall("web.DHCSTPIVAOUTPRTLABEL", "GetPrintDetail",pogid)
       		var tmparritm=pogistr.split("||");
       		var cntitm=tmparritm.length;
       		for (k=0;k<cntitm;k++){
       			
       			  h=h+1;
       			  var tmparrdata=tmparritm[k].split("^");
                       	  var patno=tmparrdata[1];
                       	  var patname=tmparrdata[0];
                       	  var orddate=tmparrdata[2];
                       	  var drugname=tmparrdata[3];
                       	  var dosage=tmparrdata[4];
                       	  var doctor=tmparrdata[5];
                       	  var freq=tmparrdata[6];
                       	  var prescno=tmparrdata[7];
                       	  var qty=tmparrdata[8];
                       	  
                       	  if (k==0){                      	  	
	                       	  	  mergcell(xlsheet,startNo+h,1,8) 
		                       	  xlsheet.Cells(startNo+h, 1).Value ="�ǼǺ�:"+patno+" ����:"+patname+" ������:"+prescno+" ��ҩʱ��:"+orddate+" ҽ��:"+doctor; 
		                       	  h=h+1;
		                       	  xlsheet.Cells(startNo+h, 1).Value ="ҩƷ����"; 
		                       	  xlsheet.Cells(startNo+h, 2).Value ="Ƶ��"; 
		                       	  xlsheet.Cells(startNo+h, 3).Value ="����"; 
		                       	  xlsheet.Cells(startNo+h, 4).Value ="����"; 
		                       	  setBottomLine(xlsheet,startNo+h,1,8);
		                       	  h=h+1;
	                  }
	                  
	                  xlsheet.Cells(startNo+h, 1).Value =drugname; 
       	  		  xlsheet.Cells(startNo+h, 2).Value =freq; 
       	                  xlsheet.Cells(startNo+h, 3).Value =dosage; 
       	                  xlsheet.Cells(startNo+h, 4).Value =qty; 
	                  
       		}
       		
       		h=h+1;//�����н�����һ��

          }
          
          
        xlsheet.printout();
	SetNothing(xlApp,xlBook,xlsheet);
	
			

          	
  	
  }
  
  //��ӡƿǩ
  function PrintLabel(pogid)
  {
  	
  	var Bar=new ActiveXObject("PIVAOutPrint.PIVALabel");
	if (!Bar) return ;
  	var pogstr=tkMakeServerCall("web.DHCSTPIVAOUTPRTLABEL", "GetPrintPog",pogid)
	if (pogstr==""){
		alert("ȡƿǩ�������ݷ�������");
		return ;
	}
	var pogistr=tkMakeServerCall("web.DHCSTPIVAOUTPRTLABEL", "GetPrintPogItm",pogid)
	if (pogistr==""){
		alert("ȡƿǩҩƷ���ݷ�������");
		return ;
	}
	var stype="" ;
	
	Bar.Device="PIVA";
	Bar.PageWidth=130;
	Bar.PageHeight=160;
	Bar.HeadFontSize=12;
	Bar.FontSize=10;
	Bar.Title="��Һ��";
	Bar.HeadType=stype;
	Bar.IfPrintBar="true";
	Bar.BarFontSize=25;
	Bar.BarTop=60;
	Bar.BarLeftMarg=5;
	Bar.PageSpaceItm=2;	
	Bar.ItmFontSize=10;
	Bar.ItmCharNums=30; //ҩ��ÿ����ʾ���ַ���
	Bar.ItmOmit="false";	//ҩƷ�����Ƿ�ȡ��ֻ��ӡһ��
	Bar.PageMainStr=pogstr;	// ��ӡ��ǩҽ����Ϣ
	Bar.PageItmStr=pogistr;	// ��ӡ��ǩҩƷ��Ϣ
	Bar.PageLeftMargine=1;
	Bar.PageSpace = 1;
	Bar.BarWidth=24;
	Bar.BarHeight=8;
	Bar.PrintDPage();
	return true;
  		
  }
  			
});