
var unitsUrl = 'dhcpha.comment.query.save.csp';
var QueryStr="";

Ext.onReady(function() {

        Ext.QuickTips.init();// ������Ϣ��ʾ
	    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
        var Request = new Object();
        Request = GetRequest();
        if (Request['QueryStr']){
        	QueryStr= Request['QueryStr'];
        }
        
	
  var commentgridcm = new Ext.grid.ColumnModel({
  
  columns:[
  
        {header:'����',dataIndex:'patage',width:60},
        {header:'���',dataIndex:'diag',width:200},
        {header:'ҩƷ����',dataIndex:'num',width:80},
        {header:'����ҩ����',dataIndex:'bnum',width:60},
        {header:'ע���',dataIndex:'zsjflag',width:60},
        {header:'ͨ����',dataIndex:'generic',width:100},
        {header:'���',dataIndex:'spec',width:80},       
        {header:'����',dataIndex:'qty',width:60},
        {header:'���',dataIndex:'amt',width:80},
        {header:'����',dataIndex:'dosage',width:80},
        {header:'�÷�',dataIndex:'instru',width:80},
        {header:'�������',dataIndex:'totalamt',width:80},
        {header:'������',dataIndex:'prescno',width:100},
        {header:'colorflag',dataIndex:'colorflag',width:60,hidden:true},
        {header:'pid',dataIndex:'pidnum',width:60,hidden:true}
       
          ]   
            
    
    });
 
 
    var commentgridds = new Ext.data.Store({
	proxy: "",	
	autoLoad: false,

        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'patage',
            'diag',
	    'num',
	    'bnum',
	    'zsjflag',
	    'generic',
	    'spec',
	    'qty',
	    'amt',
	    'dosage',
	    'instru',
	    'totalamt',
	    'prescno',
	    'colorflag',
	    'pidnum'
	    
		]),
		
		

    remoteSort: true
});



  var gridcmPagingToolbar = new Ext.PagingToolbar({	//��ҳ����
			store:commentgridds,
			pageSize:400,
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

 
 var commentgrid = new Ext.grid.GridPanel({
        
        region:'center',
        //stripeRows: true,
        width:650,
        height:300,
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
		   
		   
			   if (record.data.colorflag > 0) {
			   
			  

			   return 'x-grid-record-green'; 
			   
			   }
		   
		   }
		    
		    
	    }),
	    
	tbar:[],  
        bbar: gridcmPagingToolbar,
        trackMouseOver:'true'
        

        
    });
    
    
	
    
        QueryData();
    
    
        //�Ҽ��˵� 
	commentgrid.addListener('rowcontextmenu', rightClickFn);//�Ҽ��˵�����ؼ����� 
	var rightClick = new Ext.menu.Menu({ 
	    id:'rightClickCont', 
	    items: [ 
	        { 
	            id: 'ExportXls', 
	            handler: ExportXls, 
	            text: '����Excel' 
	        }, 
	        { 
	            //id: 'rMenu2', 
	            //handler: rMenu2Fn, 
	            //text: '�Ҽ��˵�2' 
	        } 
	    ] 
	}); 
	//�Ҽ��˵�����ؼ����� 
	function rightClickFn(grid,rowindex,e){ 
	    e.preventDefault(); 
	    rightClick.showAt(e.getXY()); 
        }

    
    var port = new Ext.Viewport({

				layout : 'border',

				items : [commentgrid]

			});
    
    
    /// ���Ϊexcel
  function ExportXls()
        {
  		try{
  		
			        var oXL = new ActiveXObject("Excel.Application"); 
			        var oWB = oXL.Workbooks.Add(); 
			        var oSheet = oWB.ActiveSheet; 

		               ///��������ҩ
		        
	                        oSheet.Cells(1,1).value = "����";  
				oSheet.Cells(1,2).value = "���"; 
				oSheet.Cells(1,3).value = "ҩƷ����"; 
				oSheet.Cells(1,4).value = "����ҩ����"; 
				oSheet.Cells(1,5).value = "ע���";  
				oSheet.Cells(1,6).value = "ͨ����"; 
				oSheet.Cells(1,7).value = "���"; 
				oSheet.Cells(1,8).value = "����"; 
				oSheet.Cells(1,9).value = "���";  
				oSheet.Cells(1,10).value = "����";  
				oSheet.Cells(1,11).value = "�÷�";  
				oSheet.Cells(1,12).value = "�������"; 
				oSheet.Cells(1,13).value = "������";  
	
				var rows = commentgrid.getStore().getCount() ; 
				if (rows == 0) { return; }  
				
			        var pid=commentgridds.getAt(0).get("pidnum") ; 
				var cnt=GetImtCnt(pid);
			        var exportdata=ListImtInfo(pid);
				var exportarr=exportdata.split("@");
				for (i=1;i<=cnt;i++)
				{
				   var tmparr=exportarr[i-1].split("^");
			   
				   oSheet.Cells(i+1,1).value = tmparr[0];
				   oSheet.Cells(i+1,2).value = tmparr[1];
				   oSheet.Cells(i+1,3).value = tmparr[2];
				   oSheet.Cells(i+1,4).value = tmparr[3];
				   oSheet.Cells(i+1,5).value = tmparr[4];
				   oSheet.Cells(i+1,6).value = tmparr[5];
				   oSheet.Cells(i+1,7).value = tmparr[6];
				   oSheet.Cells(i+1,8).value = tmparr[7];
				   oSheet.Cells(i+1,9).value = tmparr[8];
				   oSheet.Cells(i+1,10).value = tmparr[9];
				   oSheet.Cells(i+1,11).value = tmparr[10];
				   oSheet.Cells(i+1,12).value = tmparr[11];
				   oSheet.Cells(i+1,13).value = tmparr[12];

				}
				
				
         
		            
		               oXL.DisplayAlerts = false
			       oXL.UserControl = true; 
			       oXL.Save();
			      
			       oXL=null;
			       oSheet=null;
			       oWB.Close(savechanges=false);
			       idTmr = window.setInterval("Cleanup();",1);
  
			
		    }
		    
		 catch(e)
	             {
		             alert(e.message);

	             }
	         finally{
	         

			

	             }

             
             
             
       }
    
    
    ///ˢ��table
    function QueryData()
    {	
       	        commentgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindAudltData&QueryStr='+QueryStr });
	
		commentgridds.load({
		params:{start:0, limit:gridcmPagingToolbar.pageSize},
		callback: function(r, options, success){
 
		         
		         if (success==false){
		                     Ext.Msg.show({title:'ע��',msg:'��ѯʧ�� !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     }
		          }
		
		});
		
    }
    
    
    
    ///��ȡ��¼��
function GetImtCnt(pid)
{
	
	 var myURL = unitsUrl+'?action=GetAudltImtCnt&pid='+pid;
         var cnt=  ExecuteDBSynAccess(myURL);
         return cnt;
}
    
    
   ///��ȡ���ܼ�¼
function ListImtInfo(pid)
{
         var myURL = unitsUrl+'?action=ListAudltImt&pid='+pid;
         var ret=  ExecuteDBSynAccess(myURL);
         return ret;

}
 
    
    
    
});