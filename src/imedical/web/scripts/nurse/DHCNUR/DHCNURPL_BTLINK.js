var grid;
var arrgrid = new Array();
var arrgridnurse = new Array();
var storenurse = new Ext.data.JsonStore({
			data :arrgridnurse,
			fields : ['desc', 'id']
		});
var patward = new Ext.form.ComboBox({
			id : 'patward',
			//hiddenName : 'region1',
			fieldLabel : '标准模板',
			store : storenurse,
			width : 150,
            ///fieldLabel : '区',
			valueField : 'id',
			triggerAction: "all",
			displayField : 'desc',
			value:"",
			allowBlank : true,
			mode : 'local'
		});
function addmain(a, b) {
	//alert(a)
	arrgridnurse.push({
				id : a,
				desc : b
			});
}

var arrgridbt = new Array();
var storebt = new Ext.data.JsonStore({
			data :arrgridbt,
			fields : ['desc', 'id']
		});
var patwardbt = new Ext.form.ComboBox({
			id : 'patwardbt',
			//hiddenName : 'region1',
			fieldLabel : '表头选项',
			store : storebt,
			width : 180,
            ///fieldLabel : '区',
			valueField : 'id',
			triggerAction: "all",
			displayField : 'desc',
			value:"",
			allowBlank : true,
			mode : 'local'
		});
function addmainbt(a, b) {
	//alert(a)
	arrgridbt.push({
				id : a,
				desc : b
			});
}
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
	  tobar.addItem('表头选项',patwardbt,'-');
	  tobar.addItem('标准元素选项',patward,'-');		
     
		
		 var tbar2=new Ext.Toolbar({	});	
		tbar2.addItem("-"); 		 
		tbar2.addButton({
			//className : 'new-topic-button',
			icon:'../images/uiimages/edit_add.png',
			text : "增加",
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
			icon:'../images/uiimages/search.png',
			text : "查询",
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
	     
	    }
	  }
   );
    var maincode = Ext.getCmp("patward");
    arrgridnurse = new Array();
	//tkMakeServerCall("Nur.DHCNurDiagnos","GetItmList","addmain")
	tkMakeServerCall("Nur.DHCNurAssess","GetASSItmList","","addmain") //护理模板元素
	maincode.store.loadData(arrgridnurse);
	maincode.on('select',find)
	 var maincode = Ext.getCmp("patwardbt");
    arrgridbt = new Array();
	//tkMakeServerCall("Nur.DHCNurDiagnos","GetItmList","addmain")
	tkMakeServerCall("Nur.DHCNurHeadKnowledge","GetItmBTList","addmainbt") //护理模板元素
	maincode.store.loadData(arrgridbt);
	maincode.on('select',find)
  find();
}
function Add()
{
	
	var btval = Ext.getCmp("patwardbt").getValue();
	var bzval = Ext.getCmp("patward").getValue();
	if (btval=="")
	{
		alert("表头选项不能为空！")
		return
	}
	if (bzval=="")
	{
		alert("标准元素不能为空")
		return;
		}
		
	//var parr = "Text|"+bzcodename.getValue() + "^Code|" + bzcode.getValue() + "^Desc|" + bzdesc.getValue() + "^Cate|" + patwardobj.getValue() 
	//alert(parr)
	//alert(btval+"*"+bzval)
	var a=tkMakeServerCall("Nur.DHCNurHeadKnowledge","SaveLink",bzval,btval);
	if (a!=0)
	{alert(a)}
    var maincode = Ext.getCmp("patwardbt");
	 arrgridbt = new Array();
	//tkMakeServerCall("Nur.DHCNurDiagnos","GetItmList","addmain")
	tkMakeServerCall("Nur.DHCNurHeadKnowledge","GetItmBTList","addmainbt") //护理模板元素
	maincode.store.loadData(arrgridbt);
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
	
    var grid = Ext.getCmp("mygrid");
	var GetQueryData=document.getElementById('GetQueryData2');
	arrgrid=new Array();
	var gdcateobj = Ext.getCmp("patward");
	var parr="" //gdcateobj.getValue()
	//alert(session['LOGON.CTLOCID']);
	/*
	var a = cspRunServerMethod(GetQueryData.value, "Nur.DHCNurHeadKnowledge:CRItem", "parr$"+parr, "AddRec");
  //alert(a);
   grid.store.loadData(arrgrid);   
  */
   var mygrid = Ext.getCmp("mygrid");
   mygrid.store.on("beforeLoad",function(){   
       mygrid.store.baseParams.parr=parr;    //传参数，根据原来的方式修改
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
	  Ext.Msg.show({    
	       title:'确认一下',    
	       msg: '确定要删除吗？',    
	       buttons:{"ok":"是     ","cancel":"  否"},
	       fn:  function(btn, text){    
	            if (btn == 'ok'){   
	           //alert(rw)
	           tkMakeServerCall("Nur.DHCNurHeadKnowledge","LinkDelete",rw)
		       find()
	            
	            }
		else
	    {     	}
	            
	        },    
	       animEl: 'newbutton'   
	       });

		
 	
	find()
}
