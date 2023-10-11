/**
 * @author Administrator
 */
/**
 * @author Qse
 */
var  DATAINDEX //列
 Ext.onReady(function(){   
            
		
		    var Loc = session['LOGON.CTLOCID'];
		   //创建数据源[数组数据源]
			var dataStr=iniLocData();
			dataStr=eval(dataStr);
			var KNurseNamestore = new Ext.data.ArrayStore({
			fields : ['id', 'desc'],
			data :dataStr			
		     });
		    //创建Combobox
             KNurseName  = new Ext.form.ComboBox({
			id : 'KNurseName',
			store : KNurseNamestore,
			width : 170,
			fieldLabel : '科室',
			valueField : 'id',
			value:"",
			displayField : 'desc',
			allowBlank : true,
			mode : 'local'
		  });
		   //Combobox获取值
           KNurseName.on('select', function() 
          { 
			 Loc=KNurseName.getValue();
				ClearTree();
				iniTree(Loc);
		    });		
			
        
            //设置树形面板   
            //定义树的跟节点  
            var east_item = new Ext.Panel({               
                region: 'east',                   
              //  el: 'center-center',                   
                title: '知识库',       
                split: true,   
                collapsible: true,   
                titlebar: true,   
                collapsedTitle: '内容',   
                height: 600,   
                width: 170,   
                minSize: 100,   
                maxSize: 400, 
				x: '82%',
                y: 0,
				collapsed :true,
				layout: "anchor",   
                layoutConfig: {   
                    animate: true   
                },	
				 items: [KNurseName,
		     	{   
				    id:'gxb',
                    title: '',   
                    html: '<div id="zsktree"></div>'   
                }]
			
            });     
            new Ext.Viewport({   
               layout: "absolute",   
			 // layout: "border",
                items: [east_item]   
            }); 			
           iniTree(Loc);
		   insrtCurrentId="" //全局变量，界面选择textfeild会改变
		   var grid1=Ext.getCmp('mygrid');
	       if (grid1!=null) 
		   {
				grid1.on('beforeedit', beforeEditFn22);
		   }

});   

//插入
function DblClick_Insert(e)
{
	var zsktxt=tkMakeServerCall("web.DHCNURZSKOnPage","GetKnowledge",e.id);
    if(insrtCurrentId!="")
	{
	var insertObj=Ext.getCmp(insrtCurrentId);
	var itemValue=insertObj.getValue();
	insertObj.setValue(itemValue+zsktxt);
	}
	else{
	var grid1=Ext.getCmp('mygrid');
    if (grid1==null) return;
	var objRow=grid1.getSelectionModel().getSelections();
	if (objRow.length == 0) { Ext.Msg.alert('提示', "请先选择一条护理记录!"); return; }
	var itemValue=grid1.getSelectionModel().getSelections()[0].get(DATAINDEX);
	if (itemValue!=null)
	  {
	     grid1.getSelectionModel().getSelections()[0].set(DATAINDEX,(itemValue+zsktxt));
      }
	else 
	  {
	     grid1.getSelectionModel().getSelections()[0].set(DATAINDEX,zsktxt);
	  }
	}	
}
//替换
function RightClick_Insert()
{
	var zsktxt=tkMakeServerCall("web.DHCNURZSKOnPage","GetKnowledge",ZSKNODE.id);
    if(insrtCurrentId!="")
	{
	var insertObj=Ext.getCmp(insrtCurrentId);
	insertObj.setValue(zsktxt);
	}
	else{
	var grid1=Ext.getCmp('mygrid');
	if (grid1==null) return;
	var objRow=grid1.getSelectionModel().getSelections();
	if (objRow.length == 0) { Ext.Msg.alert('提示', "请先选择一条护理记录!"); return; }
	grid1.getSelectionModel().getSelections()[0].set(DATAINDEX,zsktxt);
	}
	
}
function iniLocData()
{
   var dataStr=tkMakeServerCall("web.DHCNURZSKOnPage","GetListAllLoc");
   return dataStr;
}
function iniTree(Loc)
{
            Ext.QuickTips.init();
 	/*****************************创建知识库的树**********************************/
			
             var ZSKTree = Ext.tree;
	         var zsktreeLoader = new ZSKTree.TreeLoader( {dataUrl : "../web.DHCNURZSKOnPage.cls?&Loc="+Loc+ "&ActionType=0"});
             var zsktree = new ZSKTree.TreePanel({
		     el:'zsktree',
		     rootVisible: false,
		     autoScroll:true,
		     //trackMouseOver:false,
		     animate:true,
		     containerScroll:true,
			// renderTo:ZSKrootNode, 
		     //bodyStyle:'padding:5px 1px 0',
		     lines:true, 
		     //checkModel:'cascade',
		     //autoHeight:true,
		     height:600,
		     width: 170,  
		     border:true,
		     loader : zsktreeLoader,
		     id:"zsktree1"			 
	        });
			 //抛出异常时的处理				
            zsktreeLoader.on("loadexception", function(zsktree, node, response) {
	        var obj = response.responseText;
	       // alert(obj);
            });
            var rootStr=tkMakeServerCall("web.DHCNURZSKOnPage","GetLocDesc",Loc);
			var moudleNums=tkMakeServerCall("web.DHCNURZSKOnPage","GetMoudleNums",Loc);
			ZSKrootNode = new ZSKTree.AsyncTreeNode( {
		    text : rootStr,
		    nodeType: 'async',
		    draggable : 'true',
		    id : "ZSKroot"
            });	
			 zsktree.setRootNode(ZSKrootNode);
			 if (moudleNums==1){
			 	ZSKrootNode.expand(true); //只有一个模板的时候展开树
			 }
			 if(moudleNums!=0){
			 	zsktree.render('zsktree');
             	zsktree.doLayout();
			 }

             
        /******************************************************************************/
	//定义右键菜单
     var rightClick = new Ext.menu.Menu({
        id :'rightClickCont',
        items : [{
            id:'rMenu1',
            text : '替换',
            //增加菜单点击事件
            handler:RightClick_Insert
			}]
     });
	 //增加右键点击事件
     zsktree.on('contextmenu',function(node,event){//声明菜单类型
          event.preventDefault();
          rightClick.showAt(event.getXY());//取得鼠标点击坐标，展示菜单
		  ZSKNODE=node;//全局变量
     });  	
	 //双击事件
	 zsktree.on('dblclick',DblClick_Insert);
}
function ClearTree()
{
var ss=Ext.getCmp('zsktree1');
ss.beforeDestroy();

}
function beforeEditFn22(e)
{
 DATAINDEX=e.field; //全局变量
}