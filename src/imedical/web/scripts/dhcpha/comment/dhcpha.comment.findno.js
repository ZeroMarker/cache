
var findflag="1";
var LgGrpDesc=session['LOGON.GROUPDESC'];  //��½��ȫ��
FindCommentFun = function(findflag) {
	Ext.QuickTips.init();

	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	if (LgGrpDesc.indexOf('�鳤') > -1) {
		var logonflag='false';
	}else{
		var logonflag='true';
	}
	
   var FindCommentQueryButton = new Ext.Button({
             width : 55,
             id:"FindCommentQueryBtn",
             text: '��ѯ',
             iconCls:"page_find",
             listeners:{   
                          "click":function(){  
              
                           FindCommentNo();
                       
                           
                              }   
                       } 
             
             })		
	

	
	
    var FindCommentOKButton = new Ext.Button({
             width : 55,
             id:"FindCommentOKBtn",
             text: 'ȷ��',
             iconCls:"page_goto",
             listeners:{   
                          "click":function(){  
                          //Ext.getCmp("txt_name").setValue("1111") 
                          

                          
                               FindMainOrdData();
                              
                           
                              }   
                       } 
             
             })	
             
             
     var FindCommentDelButton = new Ext.Button({
             width : 55,
             id:"FindCommentDelBtn",
             text: 'ɾ��',
             iconCls:"page_delete",
             listeners:{   
                          "click":function(){  

                           DelCommnetData();
                         
                           
                              }   
                       } 
             
             })	
	
  	
	
      var FindComStDateField=new Ext.form.DateField ({
               
                xtype: 'datefield',
                //format:'j/m/Y' ,
                fieldLabel: '��ʼ����',
                name: 'FindComStDate',
                id: 'FindComStDate',
                //invalidText:'��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
               // width : 95,
                value:new Date
            })	
            
            
            
        var FindComEndDateField=new Ext.form.DateField ({
                //format:'j/m/Y' ,
                fieldLabel: '��ֹ����',
	        name: 'FindComEndDate',
	        id: 'FindComEndDate',
	        //width : 95,
	        value:new Date
            })
	
 
	 var ResultData=[['���н��','1'],['���޽��','2'],['������','3'],['��������','4'],['��ҽ������','5']];
	 
	 
	 var Resultstore = new Ext.data.SimpleStore({
		fields: ['retdesc', 'retid'],
		data : ResultData
		});

	var ResultCombo = new Ext.form.ComboBox({
		store: Resultstore,
		displayField:'retdesc',
		mode: 'local', 
		width : 95,
		emptyText:'',
		id:'ResultComb',
		valueField : 'retid'
	});
	
	
	
	 ///������ʽ
	
	 var ComBoWayDs = new Ext.data.Store({
		autoLoad: true,
		proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=QueryActiveWayDs&WayType='+findflag,
			method : 'POST'
		}),
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'wayrowid'},['waydesc','wayrowid'])
				
	});
	

	var ComBoWay = new Ext.form.ComboBox({
		store: ComBoWayDs,
		displayField:'waydesc',
		mode: 'local', 
		width : 95,
		id:'waycomb',
		emptyText:'',
		listWidth : 200,
		valueField : 'wayrowid',
		emptyText:'ѡ��ʽ...',
		fieldLabel: '������ʽ'
	}); 
	
	
	//����ҩʦ
	
	 var PhamaDs = new Ext.data.Store({
		autoLoad: true,
		proxy : new Ext.data.HttpProxy({
			url : unitsUrl
					+ '?action=QueryPhamaDs',
			method : 'POST'
	
		}),
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'docrowid'},['docdesc','docrowid'])
				
	});
	

	var Phama = new Ext.form.ComboBox({
		store: PhamaDs,
		displayField:'docdesc',
		mode: 'local', 
		width : 95,
		id:'Phama',
		listWidth : 200,
		valueField : 'docrowid',
		emptyText:'ѡ�����ҩʦ...',
		fieldLabel: '����ҩʦ'
	}); 


	var SubmitData=[['δ����','1'],['������','2'],['���ύ','3']];

	var Submitstore = new Ext.data.SimpleStore({
		fields: ['subdesc', 'subid'],
		data : SubmitData
	});

	var SubmitCombo = new Ext.form.ComboBox({
		store: Submitstore,
		displayField:'subdesc',
		mode: 'local', 
		width : 75,
		emptyText:'',
		id:'SubmitComb',
		valueField : 'subid'
	});
 
	// add by myq 20150601 ����ύ��ť        
	var SubmitButton = new Ext.Button({
		width : 55,
		id:"SubmitBtn",
		text: '�ύ',
		iconCls:"page_add",
		listeners:{   
			"click":function(){  
				SubmitCommnetData();
			}   
		} 
	})
             
	///add by myq 20150601 ���ȡ���ύ��ť        
	var CancleSubButton = new Ext.Button({
		width : 55,
		id:"CancleSubBtn",
		text: 'ȡ���ύ',
		hidden : eval(logonflag) ,
		listeners:{   
			"click":function(){
				CancleSubCommnetData();
			}
		}
	})
             
  var commentgridcm = new Ext.grid.ColumnModel({
  
  columns:[
       
        {header:'����',dataIndex:'comno',width:125},
        {header:'����',dataIndex:'comdate',width:100},
        {header:'ʱ��',dataIndex:'comtime',width:100},
        {header:'�Ƶ���',dataIndex:'comcreator',width:75},
        {header:'����',dataIndex:'comtype',width:75},
        {header:'��ʽ',dataIndex:'comway',width:125},
        {header:'��ѯ����',dataIndex:'comtext',width:400},
        {header:'rowid',dataIndex:'comrowid',width:40,hidden:true},
        {header:'����״̬',dataIndex:'pcntsubmit',width:80}  // add by myq 20150601  
          ]   
            
    
    });
 
 
    var commentgridds = new Ext.data.Store({
	proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'comno',
            'comdate',
	    'comtime',
	    'comcreator',
	    'comtype',
	    'comway',
	    'comtext',
	    'comrowid',
   		'pcntsubmit'  // add by myq 20150601 
	    
		]),
		
		

    remoteSort: true
});


 
 var commentgrid = new Ext.grid.GridPanel({
        
        id:'commentgridtbl', 
        stripeRows: true,
        region:'center',
        width:200,
        height:600,
        autoScroll:true,
	title:"",
        enableHdMenu : false,
        ds: commentgridds,
        cm: commentgridcm,
        enableColumnMove : false,
        view: new Ext.ux.grid.BufferView({
		    // custom row height
		    rowHeight: 25,
		    // render rows as they come into viewable area.
		    scrollDelay: false,
		       
		   getRowClass: function(record, index, rowParams, store) {  
		   
		   
			   if (record.data.pcntsubmit == "���ύ") {
			      return 'x-grid-record-pink'; 
			   }
		   
		   }
		    
		    
	    }),
	    
	tbar:['��ʼ����:',FindComStDateField,"-",'��ֹ����:',FindComEndDateField,'-','������ʽ','-',ComBoWay,'���','-',ResultCombo,'����ҩʦ','-',Phama,'����״̬','-',SubmitCombo,FindCommentQueryButton,"-",FindCommentOKButton,"-",FindCommentDelButton,"-",SubmitButton,"-",CancleSubButton],  
        //bbar: orddetailgridcmPagingToolbar,
        trackMouseOver:'true'
        

        
    });
    
    
    commentgrid.on('rowdblclick',function(grid,rowIndex,e){
    	FindMainOrdData();
    })
    
   ////��ϸtable 
    
 var commentitmgridcm = new Ext.grid.ColumnModel({
  
  columns:[
       
        {header:'��ϸ����',dataIndex:'comno1',width:100},
        {header:'����',dataIndex:'comdate1',width:80},
        {header:'ʱ��',dataIndex:'comtime1',width:60},
        {header:'�Ƶ���',dataIndex:'comcreator1',width:60},
        {header:'����',dataIndex:'comtype1',width:60},
        {header:'��ѯ����',dataIndex:'comtext1',width:300},
        {header:'rowid',dataIndex:'comrowid1',width:40}  
          ]   
            
    
    });
 
 
    var commentitmgridds = new Ext.data.Store({
	proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'comno1',
            'comdate1',
	    'comtime1',
	    'comcreator1',
	    'comtype1',
	    'comtex1t',
	    'comrowid1'
	    
		]),
		
		

    remoteSort: true
});




 
 var commentitmgrid = new Ext.grid.GridPanel({
        
        id:'commentgriditmtbl',
        stripeRows: true,
        region:'center',
        width:150,
        //height:290,
        autoScroll:true,
		title:"",
        enableHdMenu : false,
        ds: commentitmgridds,
        cm: commentitmgridcm,
        enableColumnMove : false,
        view: new Ext.ux.grid.BufferView({
		    // custom row height
		    rowHeight: 25,
		    // render rows as they come into viewable area.
		    scrollDelay: false,
		       
		    getRowClass: function(record, index, rowParams, store) {
			   if (record.data.flag > 0) {
			   	return 'x-grid-record-green'; 
			   }
		   }
	    })
    });   
    
    
	

    
  // define window and show it in desktop
  var FindCommentWindow = new Ext.Window({
    title: '���ҵ�����',
    width: document.body.clientWidth*0.9,
    height:document.body.clientHeight*0.9,
    minWidth:  document.body.clientWidth*0.3,
    minHeight:document.body.clientHeight*0.3,
    layout: 'border',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    items:  [  commentgrid]
   //commentitmgrid

    });

    FindCommentWindow.show();




///----------------Events----------------




///��ѯĳ��ʱ���ڵĵ�����

function FindCommentNo()
{
                commentgridds.removeAll();  
                sdate=Ext.getCmp("FindComStDate").getRawValue();       
                edate=Ext.getCmp("FindComEndDate").getRawValue();
                //findflag="1" //����
                way=Ext.getCmp("waycomb").getValue(); 
                var submit=Ext.getCmp("SubmitComb").getValue();  //ad by myq 20150601   
                var phamaid=Ext.getCmp("Phama").getValue();  //ҩʦ  
                var retflag=Ext.getCmp("ResultComb").getValue();  //���
                parstr=way+"^"+submit+"^"+phamaid+"^"+retflag //������ѯ����
                var LogonLocId;
                LogonLocId = session['LOGON.CTLOCID'];
				//commentgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindCommentNo&StDate='+sdate+'&EndDate='+edate+'&ParStr='+parstr+'&FindFlag='+findflag});
				 commentgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindCommentNo&StDate='+sdate+'&EndDate='+edate+'&ParStr='+parstr+'&FindFlag='+findflag+'&LogonLocId='+LogonLocId});
				commentgridds.load({
				
				callback: function(r, options, success){
		 
				         
				         if (success==false){
				                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
				                     }
				          }
				
				});
}


///ѡȡ������,��������������


function FindMainOrdData()
{

                   var row = Ext.getCmp("commentgridtbl").getSelectionModel().getSelections();   //getCmp("gridid")   

			       if (row.length == 0) {  
				      
				      Ext.Msg.show({title:'��ʾ',msg:'δѡ�м�¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				      return;  
			       }  
				
			       var rowid = row[0].data.comrowid;
			       var comno= row[0].data.comno;
			       var comtext= row[0].data.comtext;
                   var maintitle="��������    ��ǰ��������:"+comno+"����:"+comtext ;
                   var retflag=Ext.getCmp("ResultComb").getValue();
                   var phama=Ext.getCmp("Phama").getValue();
                   QueryCommontItm(rowid,maintitle,retflag,phama);
                   
                   FindCommentWindow.close();

}


///ɾ��������

function  DelCommnetData()
    {
	    var row = Ext.getCmp("commentgridtbl").getSelectionModel().getSelections();   //getCmp("gridid")   
	    if (row.length == 0) {  
		      Ext.Msg.show({title:'��ʾ',msg:'δѡ�м�¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		      return;  
	    }  
	    Ext.MessageBox.confirm('ע��', 'ȷ��Ҫɾ���� ? ',ShowDelResult);
	
    }

///ɾ��ȷ�϶���
function  ShowDelResult(btn)
 {
           if (btn=="no"){ return ;}
           var row = Ext.getCmp("commentgridtbl").getSelectionModel().getSelections();   //getCmp("gridid")
	       var commontno = row[0].data.comno;
	       
	       ///���ݿ⽻��ɾ��
	    
		Ext.Ajax.request({
	
	        url:unitsUrl+'?action=DelCommentNo&CommontNo='+commontno,
	
		waitMsg:'ɾ����...',
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
	  	        if (jsonData.success==0) {
	  		       FindCommentNo();
	  		}
	  		else{
	  		       Ext.Msg.alert("��ʾ", "ɾ��ʧ��!����ֵ: "+jsonData.success);
	  		    
	  		}
		},
		
			scope: this
		});
		  
    }
          
          
/// add by myq 20150601
///�ύ������
function  SubmitCommnetData(){
    var row = Ext.getCmp("commentgridtbl").getSelectionModel().getSelections();   //getCmp("gridid")
	if (row.length == 0) {  
		Ext.Msg.show({title:'��ʾ',msg:'δѡ�м�¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return;  
	}  
    Ext.MessageBox.confirm('ע��', 'ȷ��Ҫ�ύ�� ? ',ShowSubmitResult);
}

///�ύȷ�϶���
function  ShowSubmitResult(btn){
	if (btn=="no"){ return ;}
	var row = Ext.getCmp("commentgridtbl").getSelectionModel().getSelections();   //getCmp("gridid")
	var commontno = row[0].data.comno;

	///���ݿ⽻���ύ
	Ext.Ajax.request({
		url:unitsUrl+'?action=SubmitCommentNo&CommontNo='+commontno,
		waitMsg:'�ύ��...',
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success==0) {
				Ext.Msg.alert("��ʾ", "�ύ�ɹ���");
				FindCommentNo();
			}
			else if (jsonData.success==-2){
				Ext.Msg.alert("��ʾ", "�õ������Ѿ��ύ!");
				return;
			}
			else{
				Ext.Msg.alert("��ʾ", "�ύʧ��!����ֵ: "+jsonData.success);
				return;
			}
		},
		scope: this
	});  
} 


/// add by myq 20150601
///ȡ���ύ������
function  CancleSubCommnetData(){
	var row = Ext.getCmp("commentgridtbl").getSelectionModel().getSelections();   //getCmp("gridid")   
	if (row.length == 0) {  
		Ext.Msg.show({title:'��ʾ',msg:'δѡ�м�¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return;  
	}
    Ext.MessageBox.confirm('ע��', 'ȷ��Ҫȡ���ύ�� ? ',ShowCancleSubResult);
}

///ȡ��ȷ�϶���
function  ShowCancleSubResult(btn){
	if (btn=="no"){ return ;}                        
	var row = Ext.getCmp("commentgridtbl").getSelectionModel().getSelections();   //getCmp("gridid")   
	var commontno = row[0].data.comno;
	///���ݿ⽻���ύ
	Ext.Ajax.request({
		url:unitsUrl+'?action=CancleSubCommentNo&CommontNo='+commontno,
		waitMsg:'ȡ����...',
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success==0) {
				Ext.Msg.alert("��ʾ", "ȡ���ɹ���");
				FindCommentNo();
			}
			else if (jsonData.success==-2){
				Ext.Msg.alert("��ʾ", "�õ�������δ�ύ!");
				return;
			}
			else{
				Ext.Msg.alert("��ʾ", "ȡ��ʧ��!����ֵ: "+jsonData.success);
				return;
			}
		},
	scope: this
	});

}   



};