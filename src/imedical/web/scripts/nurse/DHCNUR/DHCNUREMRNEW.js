/**
 * @author Administrator
 */
/**
 * @author Qse
 */
 Ext.onReady(function(){   
			Ext.QuickTips.init();
            //北边，标题栏   
            var north_item = new Ext.Panel({   
                title: '你的公司公司组织架构',   
                region: 'north',   
                //contentEl: 'north-div',   
                split: true,   
                border: true,   
                collapsible: true,   
                height: 50,   
                minSize: 50,   
                maxSize: 120   
            });   
               
            //南边，状态栏   
            var parr="DHCNURXH2^"+EpisodeID+"^CaseMeasureXml^";
            var emrknowurl="" //"dhcnuremrknow.csp?EmrCode=DHCNurKnowldge&Parr="+parr+"&EpisodeID="+EpisodeID;  
            //alert(emrknowurl)
          
               
          
              //下边   知识库
            var south_item = new Ext.Panel({               
                region: 'south',                   
                //  el: 'center-center',                   
                title: '电子病历',       
                split: true,   
                collapsible: false,   
                titlebar: true,   
                collapsedTitle: '内容',   
                html: '<iframe id ="eastbl" name="dzbl" style="width:100%; height:100%" src= ></iframe>', 
                height: 100,   
                width: 300,   
                minSize: 100,   
                maxSize: 800   
            });   
                  
               
            //右边   知识库
            var east_item = new Ext.Panel({               
                region: 'east',                   
              //  el: 'center-center',                   
                title: '知识库',       
                split: true,   
                collapsible: true,   
                titlebar: true,   
                collapsedTitle: '内容',   
                height: 200,   
                width: 200,   
                minSize: 100,   
                maxSize: 400   
            });   
               
               
            //中间的南边,信息列表   
            var center_south_item = new Ext.Panel({   
                region: 'center',   
              //  contentEl: 'center-south',   
 				       html: '<iframe id ="centerTab" style="width:100%; height:100%;" src="" ></iframe>',
                split: true,   
                collapsible: true,   
                //titlebar: true,   
                autoHeight:true,
                collapsedTitle: '内容'   
            });   
               
            //中间   
            var center_item = new Ext.Panel({   
                region: 'center',   
                layout: 'border',   
                autoHeight:true,
                items: [center_south_item]   
            });   
               
               
            //西边，后台管理            
            var west_item = new Ext.Panel({   
               // title: '护理病历',   
                region: 'west',   
              //  contentEl: 'west-div',   
                split: true,   
                border: true,   
                collapsible: true,   
                width: 300,   
                height:200,
                //minSize: 120,   
                //maxSize: 200,   
                layout: "accordion",   
                layoutConfig: {   
                    animate: true   
                },   
                items: [{   
                    title: "护理病历",   
                    html: '<div id="tree"></div>'   
                }]   
            });   
            //设置树形面板   
            //定义树的跟节点   
           var root = new Ext.tree.AsyncTreeNode({   
 
            });   
   //var THeight=window.screen.height-180;   
   var THeight=document.body.offsetHeight-50;
   var TW=document.body.offsetWidth-200;
   //alert(TW)
  // alert(document.body.scrollLeft)
   //alert(THeight+"^"+THeight2)         
 var Tree = Ext.tree;
    var treeLoader = new Tree.TreeLoader( {dataUrl : "../web.DHCNUREMRNEWOnPage.cls?EpisodeID=" + episodeID + "&PatientID=" + patientID + "&ActionType=0"});         
    var tree = new Tree.TreePanel({
		//el:"currentDocs",
		rootVisible: false,
		autoScroll:true,
		//trackMouseOver:false,
		//title:'护理病历',
		animate:true,
		containerScroll:true,
		//bodyStyle:'padding:5px 1px 0',
		lines:true, 
		//checkModel:'cascade',
		//autoHeight:true,
		height:THeight,
		width:400,
		border:true,
		loader : treeLoader,
		id:"myTree"
		//tbar:treeTbar,
		//bbar:treeBbar
	});
	var rootNode = new Tree.AsyncTreeNode( {
		text : '护理病历',
		nodeType: 'async',
		draggable : false,
		id : "RT0"
    });		
    //抛出异常时的处理				
    treeLoader.on("loadexception", function(tree, node, response) {
	    var obj = response.responseText;
    });   
    tree.setRootNode(rootNode);
    rootNode.expand(true); 
    new Ext.Viewport({   
                layout: "border",   
                items: [west_item
                       , 
                       center_item,
                       {
									      xtype : "tabpanel",
									      enableTabScroll : true,
		                                  autoWidth : true,
			                              //scrollIncrement : 500,
									      //tabWidth : 230,
									      minTabWidth : 20,
									      resizeTabs : true,
									      id : "NurTabpanel",
									      region : "center",
									      items : [],
										  listeners: { beforeremove: function(ct,component ) { return true; } } 
								       }]   
      }); 
          //,east_item,south_item
 tree.render('tree');
 tree.doLayout();
 var nurtab = Ext.getCmp("NurTabpanel");
 var tabhljh = nurtab.getComponent("tabhljh"); //护理计划
 var url="../csp/NurPlan/DHCNurPlanPatient.csp?EpisodeID="+EpisodeID 
		if (!tabhljh)  
		{ 
		  var picitm = {
		  id:"tabhljh",
		  title :"护理任务",
		  closable :true,
		  html:'<iframe id="'+"tabpicif"+'" scrolling="auto" frameborder="0" width="100%" height="100%" src="'+ url + '"> </iframe>',	
		  listeners:{  activate: function (tab) { 
									 document.getElementById("tabpicif").src= url
					   },
		               beforeclose:function()
			          {
				         //alert(33)
			          }		  
		            } 
		  }	 
			//nurtab.add(picitm);
			//nurtab.setActiveTab("tabhljh");
		}
tree.on('click',function(node,event){  	
  nodeclick(node, event);
  return
	}); 
var opend=tkMakeServerCall("NurEmr.DHCNurActiveTabs","getval",session['LOGON.CTLOCID'],session['LOGON.USERID'])
//alert(opend)
var arr1=opend.split("$")
if (arr1[0]!="")
{
   var arrs=arr1[0].split("^")
   for (var k=0;k<arrs.length;k++)
   {
	var itm=arrs[k];
	if (itm=="") continue;
	var arrsub=itm.split("|")
	var acode=arrsub[0];
	var atitle=arrsub[1]
	//alert(acode)
	var hlurl="DHCNurEmrComm.csp?EpisodeID="+EpisodeID+"&EmrCode="+acode
	nurtab.add({
		id:"tab"+acode,
		title:atitle,
		tabTip:atitle,
		closable:true,
		html:'<iframe id="'
				+ "tab"+acode
				+ '" scrolling="auto" frameborder="0" width="99%" height="100%" src="'
				+ hlurl + '"> </iframe>',
		listeners:{         activate: function (e) { 
		                         //alert(e.id)
								 var seltab=e.id.replace("tab","")
								 tkMakeServerCall("NurEmr.DHCNurActiveTabs","setactivetab",session['LOGON.CTLOCID'],session['LOGON.USERID'],seltab)  //激活的页签
								 
					        },
							beforeclose:function(e){
								//alert(e.id)
								var seltab=e.id.replace("tab","")
								//alert(seltab)
								tkMakeServerCall("NurEmr.DHCNurActiveTabs","deletetab",session['LOGON.CTLOCID'],session['LOGON.USERID'],seltab)  //保存打开的页签								
							}
			   }
				
	  })
	  //alert(arr1[1])
	
   }
   if (arr1[1]!="")
	{
		
	   var acode="tab" + arr1[1];
	   nurtab.setActiveTab(acode);
	}
	addblurl()
 }
});   
function addblurl()
	{
		//alert(document.getElementById("eastbl").src)
		if (document.getElementById("eastbl"))
		{
		  if (document.getElementById("eastbl").src.indexOf("emr.interface.browse.category.csp")==-1)
		  {
		   //var dzblurl="http://172.20.20.21/dthealth/web/csp/emr.interface.browse.category.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&EpisodeLocID="+patloc
		   //alert(dzblurl)
		   var dzblurl="emr.interface.browse.category.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&EpisodeLocID="+patloc
		   ///alert(dzblurl)
		   document.getElementById("eastbl").src= dzblurl
	      }
		}
	}
function nodeclick(node, e) {
  var nodetype = node.id
  if (nodetype=="RT0")
  {
  	return
  }
	var wardid = node.parentNode.id;
	if (node.leaf == "ture") {
		var nurtab = Ext.getCmp("NurTabpanel");
		var tabpic = nurtab.getComponent("tabpic"); //图片		
		if (!tabpic)  
		{ 
		  var picitm = {};
		  picitm.id = "tabpic";
		  picitm.title = "图片预览";
		  picitm.closable = true;
		  var url="DHCNurEmrComm.csp?EpisodeID="+EpisodeID+"&EmrCode=DHCNUREMRPIC"
		  picitm.html='<iframe id="'+"tabpicif"+'" scrolling="auto" frameborder="0" width="100%" height="100%" src="'+ url + '"> </iframe>'	
		  picitm.listeners={activate: function (tab) { 
									 document.getElementById("tabpicif").src= url
									}}
			//nurtab.add(picitm);
		}
		if ((node.id.indexOf("DHCNURXH_WKHLJL")>-1)||((node.id.indexOf("DHCNURXH2csddd")>-1)))
		{
			var fheight=window.screen.height;
            var fwidth=window.screen.width;
			var params="toolbar=no,location=no,left=10,top=10,directories=no,resizable=yes,width="+fwidth+",height="+fheight
			var lnk= "DHCNurEmrComm.csp?"+"&EmrCode="+node.id+"&EpisodeID="+EpisodeID//""+"&Status="+""  ;//"&DtId="+DtId+"&ExamId="+ExamId
			var paramsmodel="dialogWidth:"+fwidth+"px;dialogHeight:"+fheight+"px;center:yes;resizable:no;status:no;scroll:YES;help:no;edge:raised;"	       
 		        window.open(lnk,"htm2new",params);
			return;
		}
		if (node.id.indexOf("DHCNURPL_PLAN")>-1)
		{
			 var fwidth=window.screen.availWidth-10
	         var fheight=window.screen.availHeight-20
             var lnk= "dhcnurplaninput.csp?"+"&EpisodeID="+EpisodeID  ;//"&DtId="+DtId+"&ExamId="+ExamId
	         //alert(lnk)
	         window.open(lnk,"htmsdd",'left=1,top=1,toolbar=no,location=no,directories=no,resizable=yes,width='+fwidth+',height='+fheight+'');
			return;
		}
		var oItem = {};
		var hlurl="DHCNurEmrComm.csp?EpisodeID="+EpisodeID+"&EmrCode="+node.id
		//var hlurl="dhc.bdp.ext.sys.csp?BDPMENU=780" //+EpisodeID+"&EmrCode="+node.id
		oItem.id = "tab" + node.id;
		oItem.title = node.text;
		oItem.tabTip=node.text;
		oItem.closable = true;
		oItem.listeners={   
		activate: function (e) { 
		
			                     var seltab=e.id.replace("tab","")
								 tkMakeServerCall("NurEmr.DHCNurActiveTabs","setactivetab",session['LOGON.CTLOCID'],session['LOGON.USERID'],seltab)  //激活的页签
					        },
							beforeclose:function(){
								var seltab=node.id.replace("tab","")
								//alert(seltab)
								tkMakeServerCall("NurEmr.DHCNurActiveTabs","deletetab",session['LOGON.CTLOCID'],session['LOGON.USERID'],seltab)  //保存打开的页签
								
							}}
		var frameid = "iframe" + oItem.id;
		oItem.html = '<iframe id="'
				+ frameid
				+ '" scrolling="auto" frameborder="0" width="99%" height="100%" src="'
				+ hlurl + '"> </iframe>'
		nurtab.add(oItem);
		nurtab.setActiveTab("tab" + node.id);
		tkMakeServerCall("NurEmr.DHCNurActiveTabs","Save",session['LOGON.CTLOCID'],session['LOGON.USERID'],node.id+"|"+node.text)  //保存打开的页签
	    savelog(EpisodeID,node.id);
		addblurl()
		
	}

}
//保存日志
function savelog(adm,code)
{ 
    //alert(adm)
	var ModelName="DHC.Query.NurseEmr"
	var Condition = "";
		Condition = Condition + '{"EmrCode":"' + code + '",';
		Condition = Condition + '"episodeID":"' + adm + '",';
		Condition = Condition + '"userName":"' + session['LOGON.USERNAME'] + '",';
		Condition = Condition + '"userID":"' + session['LOGON.USERID'] + '"}';
		var ConditionAndContent = Condition;
		//alert(ConditionAndContent)
	var ret=tkMakeServerCall("web.DHCEventLog","EventLog",ModelName,ConditionAndContent,ConditionAndContent,"","Y")  //保存平台组日志
	//alert(ret)
}
function reloadtree()
{
	var obj=Ext.getCmp("myTree");
	var loader=obj.getLoader()
	//alert(loader)
	var rootnode=obj.getRootNode()
	rootnode.reload()
	rootnode.expand(true,false)
} 
function reloadtree2(EmrCode,type)
{
	//alert(EpisodeID)
	//var flag=tkMakeServerCall("web.DHCNUREMRNEWOnPage","GetModelDataStatus2",EpisodeID,EmrCode)
	//alert(flag)
	//if (flag!=0) return;
	var obj=Ext.getCmp("myTree");
	var loader=obj.getLoader()
	//alert(loader)
	var rootnode=obj.getRootNode()
	rootnode.reload()
	rootnode.expand(true,false)
} 
