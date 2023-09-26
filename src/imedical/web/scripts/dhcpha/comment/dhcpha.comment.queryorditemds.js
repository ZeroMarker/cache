var unitsUrl = 'dhcpha.comment.queryorditemds.save.csp';

Ext.onReady(function() {

	    Ext.QuickTips.init();// ������Ϣ��ʾ	
        Ext.Ajax.timeout = 900000;
        Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;


        var Request = new Object();
        Request = GetRequest();
        var adm = Request['EpisodeID'];
        
        
                 ///���� 
        var PriortyData=[['����ҽ��','1'],['��ʱҽ��','2']];
	 
	 
	var PriortyStore = new Ext.data.SimpleStore({
		fields: ['desc', 'id'],
		data : PriortyData
		});

	var PriortyCombo = new Ext.form.ComboBox({
		store: PriortyStore,
		displayField:'desc',
		mode: 'local', 
		width : 120,
		id:'PriortyCmb',
		emptyText:'',
		valueField : 'id',
		emptyText:'ҽ�����ȼ�...',
		fieldLabel: 'ҽ�����ȼ�'
	});  
	
	
	

	
        
    ///ҽ����ϸ����table
    

  var orddetailgridcm = new Ext.grid.ColumnModel({
  
  columns:[
        {header:'ҽ����������',dataIndex:'orddate',width:120},
        {header:'ҩƷ����',dataIndex:'incidesc',width:250},
        {header:'����',dataIndex:'qty',width:40},
        {header:'��λ',dataIndex:'uomdesc',width:60},
        {header:'����',dataIndex:'dosage',width:60},
        {header:'Ƶ��',dataIndex:'freq',width:40},
        {header:'���',dataIndex:'spec',width:80},
        {header:'�÷�',dataIndex:'instruc',width:80},
        {header:'���ȼ�',dataIndex:'pri',width:80},
        {header:'��ҩ�Ƴ�',dataIndex:'dura',width:60},
        {header:'������',dataIndex:'presc',width:90},
        {header:'����',dataIndex:'form',width:90},
        {header:'����ҩ��',dataIndex:'basflag',width:60},
        {header:'ҽ��',dataIndex:'doctor',width:60},
        {header:'ҽ����ע',dataIndex:'remark',width:90},
        {header:'ҽ��״̬',dataIndex:'ordstatus',width:90}
            
          ]   
            
    
    });
 
 
    var orddetailgridds = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({
			url : unitsUrl+ '?action=GetOrdItmDsByAdm&adm='+adm,

			method : 'POST'
		}),
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
	    'presc',
	    'form',
	    'basflag',
	    'doctor',
	    'orddate',
	    'remark',
	    'pri',
	    'ordstatus'
	    
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
        
        region:'center',
        margins:'0 0 0 0',
        stripeRows: true,
        autoScroll:true,
	title:"����ҽ��",
        enableHdMenu : false,
        ds: orddetailgridds,
        cm: orddetailgridcm,
        enableColumnMove : false,
	tbar:['ҽ�����ȼ�',PriortyCombo],  
        bbar: orddetailgridcmPagingToolbar,
        trackMouseOver:'true'
        

        
    });
       
 	orddetailgridds.load({
		params:{start:0, limit:orddetailgridcmPagingToolbar.pageSize,pri:'',findflag:1},
		callback: function(r, options, success){
   
	    
		           
		          }
		
	});

	PriortyCombo.on(
		"select",
		function(cmb,rec,id ){
		
		        var prival=cmb.getValue();
		 
		      	orddetailgridds.load({
				params:{start:0, limit:orddetailgridcmPagingToolbar.pageSize,pri:prival,findflag:1},
				callback: function(r, options, success){
		   
			    
				           
				          }
				
			});
		}
	);
	
	
	
	var centerpanel = new Ext.Panel({
        region: 'center',        //ָ���ڶ���
        width: 400,
        layout:'fit',
        items : [orddetailgrid]
      });
        ///view

	var por = new Ext.Viewport({

				layout : 'border', // ʹ��border����
                              
				items : [centerpanel]

			});





	


});
