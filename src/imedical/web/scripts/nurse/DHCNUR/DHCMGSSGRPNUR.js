/**
 * { //title : "面板", region : "north", height : 0//, //html : "
 * <h1>网站后台管理系统!</h1>" },
 */
 var SSGCmb =CreateComboBoxQ("SSGCmb","Group","ID","安全组","","180","web.DHCNurMgCodeComm","SSGROUP","desc",0,0);

function BodyLoadHandler()
{
	var grid = Ext.getCmp('mygrid');
	grid.on('dblclick', griddblclick);
	var but1=Ext.getCmp("mygridbut1");
	but1.hide();
	var but=Ext.getCmp("mygridbut2");
    but.setText("保存");
    but.setIcon('../images/uiimages/filesave.png');
    but.on("click",Save);
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	tobar.addItem("-","安全组",SSGCmb);
 		// tobar.render(grid.tbar);
	tobar.doLayout();
   var cmb=Ext.getCmp("SSGCmb");
   cmb.on("select",loadgrid);
   grid.store.load({params:{start:0, limit:10}});
 
}
function griddblclick()
{
 	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请选择安全组！");
		return;
	}
		var sgrp=rowObj[0].get("ID");
   			var mould = cspRunServerMethod(getmould);
			var mouldarr = mould.split('^')
			for (i = 0; i < mouldarr.length; i++) {
				itm = mouldarr[i].split('|');
				var ssgrpcheck=cspRunServerMethod(getssgrpcheck,sgrp,itm[0])
				var tree1=Ext.getCmp(itm[0]+"1");
				clearcheckchildnode(tree1.getRootNode());
				if (ssgrpcheck!="")
				{
					var ha = new Hashtable();
					var arr=ssgrpcheck.split("|");
					//alert(arr);
					for (var j=0;j<arr.length;j++)
					{
					   if (arr[j]!="")
						inserthashItm(arr[j],arr[j],ha);
					}
				
					findchildnode(tree1.getRootNode(),ha);//);
				}
           
				
			}
}

function inserthashItm(item,typ,ha)
{
			  if (ha.contains(item)) {
				}
				else {
				ha.add(item, typ)
			    }
} 

function loadgrid()
{
	var cmb=Ext.getCmp("SSGCmb");
	//debugger;
   Ext.getCmp("mygrid").store.load({params:{start:0, limit:10,desc:cmb.lastSelectionText}});
}
function Save()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请选择安全组！");
		return;
	}

	var Sgrp=rowObj[0].get("ID");
   			var mould = cspRunServerMethod(getmould);
			var mouldarr = mould.split('^')
			for (i = 0; i < mouldarr.length; i++) {
				itm = mouldarr[i].split('|');
				//alert(itm+"---itm");
				var checkitms = Ext.getCmp(itm[0]+"1").getChecked("id")
				
 				if (checkitms!="")
				{
				    //alert(checkitms);
					var ret = cspRunServerMethod(SaveLayout,"",Sgrp,"",itm[0]+"|"+checkitms);
				}
			}

}
function clearcheckchildnode(node){
       var childnodes = node.childNodes;
       var nd;
       for(var i=0;i<childnodes.length;i++){  //从节点中取出子节点依次遍历
          nd = childnodes[i];
          nd .getUI().toggleCheck(false);
          //nodevalue += nd.id + ",";
          //alert(nodevalue);
          if(nd.hasChildNodes()){  //判断子节点下是否存在子节点
            clearcheckchildnode(nd);    //如果存在子节点  递归
           }    
       }
   }
function findchildnode(node,ha){
       var childnodes = node.childNodes;
       var nd;
       for(var i=0;i<childnodes.length;i++){  //从节点中取出子节点依次遍历
          nd = childnodes[i];
          if (ha.contains(nd.id))
          {
            //alert(nd.id);
            nd .getUI().toggleCheck(true);
          }
          //nodevalue += nd.id + ",";
          //alert(nodevalue);
          if(nd.hasChildNodes()){  //判断子节点下是否存在子节点
            findchildnode(nd,ha);    //如果存在子节点  递归
           }    
       }
   }
