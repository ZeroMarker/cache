var grid;
var arrgrid = new Array();

function BodyLoadHandler() {
	setsize("mygridpl", "gform", "mygrid");
		 //fm.doLayout();
		//but.hide();
		grid = Ext.getCmp('mygrid');
		var but1=Ext.getCmp("mygridbut1");
	  but1.hide()
	  var but=Ext.getCmp("mygridbut2");
	  but.hide()
		var mydate = new Date();
		var tobar = grid.getTopToolbar();
    tobar.addItem('分类名称',
		  {
				xtype : 'textfield',
				id : 'bzcodename',
				width:100,
				fieldLabel : '名称'
			},'-','分类代码',
		  {
				xtype : 'textfield',
				id : 'bzcode',
				width:80,
				fieldLabel : 'id'
			},'-','描述',
		  {
				xtype : 'textfield',
				id : 'bzdesc',
				width:350,
				fieldLabel : 'id'
			})
		
		 var tbar2=new Ext.Toolbar({	});	
	tbar2.addItem("-");   		 
			tbar2.addButton({
			//className : 'new-topic-button',
			text : "增加",
			icon:'../images/uiimages/edit_add.png',
			handler : Add,
			id : 'ADDSAVE'
		});		
     
		tbar2.addItem("-"); 
		tbar2.addButton({
			//className : 'new-topic-button',
			icon:'../images/uiimages/edit_remove.png',
			text : "删除",
			handler : typdelete,
			id : 'mygridDelete3'
		});
		tbar2.addItem("-"); 
		tbar2.addButton({
			//className : 'new-topic-button',
			text : "查询",
			icon:'../images/uiimages/search.png',
			handler : find,
			id : 'find'
		});
		tbar2.addItem("-");   
		 tbar2.addButton({
			text : "修改",
			icon:'../images/uiimages/pencil.png',
			handler : Add,
			id : 'exchange'
		});
		tbar2.addItem("-");   
	  tbar2.render(grid.tbar);  
	    var bbar = grid.getBottomToolbar ();
	  bbar.hide();
	  var bbar2 = new Ext.PagingToolbar({
		pageSize:30,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(grid.bbar);
		tobar.doLayout();
    grid.addListener('rowclick', function()
    {
   	  var grid = Ext.getCmp('mygrid');
   	  var objRow=grid.getSelectionModel().getSelections();
	    if (objRow.length == 0) {
		     return;
	    }
	    else{		
	       var grid = Ext.getCmp("mygrid");
	       var rowObj = grid.getSelectionModel().getSelections();
	       var mygriddate = Ext.getCmp("bzcodename");
	       mygriddate.setValue(rowObj[0].get("CatName"));
	       var bzcode = Ext.getCmp("bzcode");
	       bzcode.setValue(rowObj[0].get("CatCode"));
	        var bzdesc = Ext.getCmp("bzdesc");
	       bzdesc.setValue(rowObj[0].get("CatDesc"));		   
		     selectid=rowObj[0].get("par")
		     var ADDSAVE = Ext.getCmp("ADDSAVE");
		     ADDSAVE.setDisabled(true)
		     var exchange = Ext.getCmp("exchange");
		     exchange.setDisabled(false)
		     //如果已经关联过了不允许删除及修改id
		     var ret=tkMakeServerCall("NurEmr.BLSJSBInterface","getid",rowObj[0].get("Code"),"")
		     //alert(ret)
		     if (ret!=""){
		     	 var mygridDelete3 = Ext.getCmp("mygridDelete3");
		       mygridDelete3.setDisabled(true)
		     	 bzcode.setDisabled(true)
		     	 HLCode.setDisabled(true)
		     	}else{
		     			 var mygridDelete3 = Ext.getCmp("mygridDelete3");
		          mygridDelete3.setDisabled(false)
		     	}
	    }
	  }
   );
  find();
}
function Add()
{
	var bzcodename = Ext.getCmp("bzcodename");
	var bzcode = Ext.getCmp("bzcode");
	var bzdesc = Ext.getCmp("bzdesc");
	if (bzcode.getValue()=="")
	{
		alert("分类代码不能为空")
		return;
		}
		if (bzcodename.getValue()=="")
	{
		alert("分类名称不能为空")
		return;
		}		
	if (selectid==""){
		var ret=tkMakeServerCall("NurEmr.EmrCodeDic","getid",bzcode.getValue());
		if (ret!=""){
		  alert("该标准模板ID已经存在")
		  selectid=""
		  var ADDSAVE = Ext.getCmp("ADDSAVE");
		  ADDSAVE.setDisabled(true)
		  return	
			}
	}
	var parr = "Text|"+bzcodename.getValue() + "^Code|" + bzcode.getValue() + "^Desc|" + bzdesc.getValue() 
	var a=tkMakeServerCall("Nur.DHCNurGordon","Save",parr,selectid);
	if (a!=0)
	{alert(a)}
	
	clearinfo()
	find()
	///mygrid.store.loadData(REC);
	
}
function clearinfo() {
	var typ = Ext.getCmp("bzcodename");
	if (typ) typ.setValue("");
	var typ = Ext.getCmp("bzcode");
	if (typ) typ.setValue("");
	var typ = Ext.getCmp("bzdesc");
	if (typ) typ.setValue("");
}
function find()
{	
	/*
    var grid = Ext.getCmp("mygrid");
	var GetQueryData=document.getElementById('GetQueryData2');
	arrgrid=new Array();
	//alert(session['LOGON.CTLOCID']);
	var a = cspRunServerMethod(GetQueryData.value, "Nur.DHCNurGordon:CRItem", "parr$", "AddRec");
  //alert(a);
   grid.store.loadData(arrgrid);   
  */
     var mygrid = Ext.getCmp("mygrid");
   mygrid.store.on("beforeLoad",function(){   
       mygrid.store.baseParams.parr="";    //传参数，根据原来的方式修改
   });    
   //mygrid.getStore().addListener('load',handleGridLoadEvent); //护理记录表格需要：日期转换及出入量统计行加颜色
   mygrid.store.load({
    	params:{
    		start:0,
    		limit:30
    	}	
   })

   var ADDSAVE = Ext.getCmp("ADDSAVE");
	 ADDSAVE.setDisabled(false)
	 selectid=""
	 var exchange = Ext.getCmp("exchange");
	exchange.setDisabled(true)
	       var mygriddate = Ext.getCmp("bzcodename");
	       mygriddate.setValue("");
	       var bzcode = Ext.getCmp("bzcode");
	       bzcode.setValue("");	
	       var HLCode = Ext.getCmp("bzdesc");
	        bzcode.setDisabled(false)
	         HLCode.setDisabled(false)
	       HLCode.setValue("");	
	      
		     selectid=""
		     var ADDSAVE = Ext.getCmp("ADDSAVE");
		    // ADDSAVE.setDisabled(true)
		     var exchange = Ext.getCmp("exchange");
}
function AddRec(str)
{
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
	//debugger;
}
function typdelete() {
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var list = [];
 
	 var rw=""
	if (len == 0) {
		Ext.Msg.alert('提示', "请先选择一行!");
		return;
	};
	for (var r = 0;r < len; r++) 
{
			list.push(rowObj[r].data);
}
 
for (var i = 0; i < list.length; i++) 
{
			  var obj=list[i];
 
			  rw=obj["par"];
}
 

if (rw==undefined) 
	{
		Ext.Msg.alert('提示', "请先选择有效行!");
		return;
	};
	    //alert(rw)
		var ee=tkMakeServerCall("Nur.DHCNurGordon","QtDelete",rw)
		if (ee != "0") {
			alert(ee);
			return;
		}
 	
	find()
}
