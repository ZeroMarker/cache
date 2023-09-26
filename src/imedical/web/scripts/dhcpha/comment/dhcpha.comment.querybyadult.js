
var unitsUrl = 'dhcpha.comment.query.save.csp';
var QueryStr="";

Ext.onReady(function() {

        Ext.QuickTips.init();// 浮动信息提示
	    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
        var Request = new Object();
        Request = GetRequest();
        if (Request['QueryStr']){
        	QueryStr= Request['QueryStr'];
        }
        
	
  var commentgridcm = new Ext.grid.ColumnModel({
  
  columns:[
  
        {header:'年龄',dataIndex:'patage',width:60},
        {header:'诊断',dataIndex:'diag',width:200},
        {header:'药品数量',dataIndex:'num',width:80},
        {header:'基本药数量',dataIndex:'bnum',width:60},
        {header:'注射剂',dataIndex:'zsjflag',width:60},
        {header:'通用名',dataIndex:'generic',width:100},
        {header:'规格',dataIndex:'spec',width:80},       
        {header:'数量',dataIndex:'qty',width:60},
        {header:'金额',dataIndex:'amt',width:80},
        {header:'剂量',dataIndex:'dosage',width:80},
        {header:'用法',dataIndex:'instru',width:80},
        {header:'处方金额',dataIndex:'totalamt',width:80},
        {header:'处方号',dataIndex:'prescno',width:100},
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



  var gridcmPagingToolbar = new Ext.PagingToolbar({	//分页工具
			store:commentgridds,
			pageSize:400,
			//显示右下角信息
			displayInfo:true,
			displayMsg:'当前记录 {0} -- {1} 条 共 {2} 条记录',
		        prevText:"上一页",
			nextText:"下一页",
			refreshText:"刷新",
			lastText:"最后页",
			firstText:"第一页",
			beforePageText:"当前页",
			afterPageText:"共{0}页",
    		        emptyMsg: "没有数据"
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
    
    
        //右键菜单 
	commentgrid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分 
	var rightClick = new Ext.menu.Menu({ 
	    id:'rightClickCont', 
	    items: [ 
	        { 
	            id: 'ExportXls', 
	            handler: ExportXls, 
	            text: '导出Excel' 
	        }, 
	        { 
	            //id: 'rMenu2', 
	            //handler: rMenu2Fn, 
	            //text: '右键菜单2' 
	        } 
	    ] 
	}); 
	//右键菜单代码关键部分 
	function rightClickFn(grid,rowindex,e){ 
	    e.preventDefault(); 
	    rightClick.showAt(e.getXY()); 
        }

    
    var port = new Ext.Viewport({

				layout : 'border',

				items : [commentgrid]

			});
    
    
    /// 另存为excel
  function ExportXls()
        {
  		try{
  		
			        var oXL = new ActiveXObject("Excel.Application"); 
			        var oWB = oXL.Workbooks.Add(); 
			        var oSheet = oWB.ActiveSheet; 

		               ///导出抗菌药
		        
	                        oSheet.Cells(1,1).value = "年龄";  
				oSheet.Cells(1,2).value = "诊断"; 
				oSheet.Cells(1,3).value = "药品数量"; 
				oSheet.Cells(1,4).value = "基本药数量"; 
				oSheet.Cells(1,5).value = "注射剂";  
				oSheet.Cells(1,6).value = "通用名"; 
				oSheet.Cells(1,7).value = "规格"; 
				oSheet.Cells(1,8).value = "数量"; 
				oSheet.Cells(1,9).value = "金额";  
				oSheet.Cells(1,10).value = "剂量";  
				oSheet.Cells(1,11).value = "用法";  
				oSheet.Cells(1,12).value = "处方金额"; 
				oSheet.Cells(1,13).value = "处方号";  
	
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
    
    
    ///刷新table
    function QueryData()
    {	
       	        commentgridds.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=FindAudltData&QueryStr='+QueryStr });
	
		commentgridds.load({
		params:{start:0, limit:gridcmPagingToolbar.pageSize},
		callback: function(r, options, success){
 
		         
		         if (success==false){
		                     Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
		                     }
		          }
		
		});
		
    }
    
    
    
    ///获取记录数
function GetImtCnt(pid)
{
	
	 var myURL = unitsUrl+'?action=GetAudltImtCnt&pid='+pid;
         var cnt=  ExecuteDBSynAccess(myURL);
         return cnt;
}
    
    
   ///获取汇总记录
function ListImtInfo(pid)
{
         var myURL = unitsUrl+'?action=ListAudltImt&pid='+pid;
         var ret=  ExecuteDBSynAccess(myURL);
         return ret;

}
 
    
    
    
});