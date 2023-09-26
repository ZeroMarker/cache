//zhangtao
// 2012-12-07
//功能说明:  ICU评分
function InitViewScreen(){
   var obj = new Object();	
   var menuId=getUrlParam("menuId")
   var mainCLCSId=menuId.split("||")[0]
   obj.mainCLSId=menuId.split("||")[1]
   var _DHCCLScore=ExtTool.StaticServerObject('web.DHCCLScore');
   obj.btnCalScore = new Ext.Button({
		id : 'btnCalScore'
		,iconCls : ''
		,text : '计算评分'
   });
  obj.btnPanel1=new Ext.Panel({
   id:'btnPanel1',
   columnWidth:.1,
   layout : 'form',
   items:[obj.btnCalScore]
  })
  obj.btnDelScore = new Ext.Button({
		id : 'btnDelScore'
		,iconCls : ''
		,text : '删除评分'
   });
   obj.btnPanel2=new Ext.Panel({
   id:'btnPanel2',
   columnWidth:.1,
   layout : 'form',
   items:[]
  })
   var mainCLCSStr=_DHCCLScore.GetMainCLCS(mainCLCSId)
   var scoreLabel=mainCLCSStr
  obj.txtScore=new Ext.form.TextField({
		id : 'txtScore'
		,fieldLabel : scoreLabel
		,anchor : '30%'
	});
  obj.txtPanel1=new Ext.Panel({
   id:'txtPanel1',
   columnWidth:.6,
   layout : 'form',
   items:[obj.txtScore]
  })
  obj.northPanel = new Ext.Panel({
		id : 'northPanel'
		,height : 60
		,region : 'north'
		,frame : true
		,title : '评分结果'
		,layout : 'column'
		,items:[
		obj.txtPanel1,
		obj.btnPanel1,
		obj.btnPanel2
		]
	});
	var linkCLCSStr=_DHCCLScore.GetLinkCLCS(mainCLCSId)
	var linkCLCSArr=linkCLCSStr.split("^")
	var count=linkCLCSArr.length
	var cl=1/count
	items=new Array();
	obj.bgElList=new Array();
	for(var i=0;i<count;i++)
	{
	 if(linkCLCSArr[i]=="") return;
	 var linkId=linkCLCSArr[i].split("!")[0]
	 var linkDesc=linkCLCSArr[i].split("!")[1]
	 var radioGroupStr=_DHCCLScore.GetRadioGroup(linkId)
	 var radioGroup=window.eval("("+radioGroupStr+")")
	 obj.bgElList[i]=radioGroup
	 items[i]=new Ext.Panel({
	 id:linkId
	 ,columnWidth:cl
	 ,frame:true
	 ,title:linkDesc
	 ,labelWidth:35
	 ,height:250
	 ,layout:'form'
	 ,items:radioGroup
	 })
	}
	obj.centerPanel=new Ext.Panel({
	id:'centerPanel',
	region:'center',
	frame:true,
	title:'加载项',
	layout:'column',
	items:items
	})
	obj.Viewscreen = new Ext.Viewport({
		id : 'Viewscreen'
		,layout : 'border'
		,items:[
			 obj.northPanel,
			 obj.centerPanel
		]
	});
	InitViewscreenEvent(obj);
	for(var i=0;i<obj.bgElList.length;i++)
	{
	 var txtObj=new Object();
	 var radioObj=new Object();
	 var elTypeCount=obj.bgElList[i].length;
	 if(elTypeCount==1)
	 {
	   txtObj=null;
	   radioObj=obj.bgElList[i][0];
	 }
	 else
	 {
	  txtObj=obj.bgElList[i][0];
	  radioObj=obj.bgElList[i][1];
	 }
	 if(txtObj!=null)
	 {
	  var domTxtEl=Ext.getCmp(txtObj.id)
	  domTxtEl.on("specialkey",obj.txt_specialkey,domTxtEl)
	 }
	 if(radioObj!=null)
	 {
	  //alert(radioObj.id)
	 }
	}
	obj.btnCalScore.on("click",obj.btnCalScore_click,obj)
	obj.LoadEvent(arguments);
    return obj;
 
 function   getUrlParam(name)
 {      
    var   reg   =   new   RegExp("(^|&)"+   name   +"=([^&]*)(&|$)");      
    var   r   =   window.location.search.substr(1).match(reg);      
    if   (r!=null)   return   unescape(r[2]);   return   null;      
 } 
}


