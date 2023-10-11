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
function BodyLoadHandler() {
	setsize("mygridpl", "gform", "mygrid");
		 //fm.doLayout();
		//but.hide();
		grid = Ext.getCmp('mygrid');
		var len = grid.getColumnModel().getColumnCount();
		for (var i = 0; i < len; i++) {
			if (grid.getColumnModel().getDataIndex(i) == 'par') {
				grid.getColumnModel().setHidden(i, true);
			}
			if (grid.getColumnModel().getDataIndex(i) == 'rw') {
				grid.getColumnModel().setHidden(i, true);
			}
		}
		var but1=Ext.getCmp("mygridbut1");
	  but1.hide()
	  var but=Ext.getCmp("mygridbut2");
	  but.hide()
	  var mydate = new Date();
	  var tobar = grid.getTopToolbar();
	  tobar.addItem('护理诊断',patward,'-');		
      tobar.addItem('名称',
		  {
				xtype : 'textarea',
				id : 'bzcodename',
				width:600,
				height:50,
				fieldLabel : '名称'
			},'-','描述',
		  {
				xtype : 'textarea',
				id : 'bzdesc',
				width:200,
				height:50,
				fieldLabel : 'id'
			},'-','代码',
		  {
				xtype : 'textfield',
				id : 'bzcode',
				width:50,
				fieldLabel : 'id'
			})
		
		 var tbar2=new Ext.Toolbar({	});		
		 tbar2.addItem("-"); 
			tbar2.addButton({
			className : 'new-topic-button',
			text : "增加",
			handler : Add,
			icon:'../images/uiimages/edit_add.png',
			id : 'ADDSAVE'
		});		
		tbar2.addItem("-"); 
		tbar2.addButton({
			className : 'new-topic-button',
			text : "删除",
			handler : typdelete,
			icon:'../images/uiimages/edit_remove.png',
			id : 'mygridDelete3'
		});
     tbar2.addItem("-");   
		 tbar2.addButton({
			text : "修改",
			handler : Add,
			icon:'../images/uiimages/pencil.png',
			id : 'exchange'
		});
		
		tbar2.addItem("-"); 
		tbar2.addButton({
			className : 'new-topic-button',
			text : "查询",
			handler : find,
			icon:'../images/uiimages/search.png',
			id : 'find'
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
	       mygriddate.setValue(rowObj[0].get("Name"));
	       var bzcode = Ext.getCmp("bzcode");
	       bzcode.setValue(rowObj[0].get("Code"));
	        var bzdesc = Ext.getCmp("bzdesc");
	       bzdesc.setValue(rowObj[0].get("Desc"));	
	        var pat = Ext.getCmp("patward");
	       pat.setValue(rowObj[0].get("par"));		   
		     selectid=rowObj[0].get("par")+"||"+rowObj[0].get("rw")
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
    var maincode = Ext.getCmp("patward");
    arrgridnurse = new Array();
	tkMakeServerCall("Nur.NurDiagnosNoc","GetItmList","addmain")
	maincode.store.loadData(arrgridnurse);
	maincode.on('select',find)
  find();
}
function Add()
{
	var bzcodename = Ext.getCmp("bzcodename");
	var bzcode = Ext.getCmp("bzcode");
	var bzdesc = Ext.getCmp("bzdesc");
	var patwardobj = Ext.getCmp("patward");
	if (patwardobj.getValue()=="")
	{
		alert("关联诊断不能为空！")
		return
	}
	if (bzcode.getValue()=="")
	{
		//alert("代码不能为空")
		//return;
		}
		if (bzcodename.getValue()=="")
	{
		alert("名称不能为空")
		return;
		}		
	if (selectid==""){
		var ret=tkMakeServerCall("Nur.NurDiagnosNoc","getid","",bzcodename.getValue());
		if (ret!=""){
		  alert("该分类下ID已经存在")
		  selectid=""
		  var ADDSAVE = Ext.getCmp("ADDSAVE");
		  ADDSAVE.setDisabled(true)
		  return	
			}
	}
	var parr = "Text|"+bzcodename.getValue() + "^Code|" + bzcode.getValue() + "^Desc|" + bzdesc.getValue() + "^Diag|" + patwardobj.getValue() 
	//alert(selectid)
	var a=tkMakeServerCall("Nur.NurDiagnosNoc","Save",parr,selectid);
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
	
    var grid = Ext.getCmp("mygrid");
	var GetQueryData=document.getElementById('GetQueryData2');
	arrgrid=new Array();
	var gdcateobj = Ext.getCmp("patward");  //诊断
	var bzcodenameobj= Ext.getCmp("bzcodename");
	var bzcodeobj= Ext.getCmp("bzcode");
	var parr=gdcateobj.getValue()+"^"+bzcodenameobj.getValue()+"^"+bzcodeobj.getValue()
	//alert(parr)
	//alert(session['LOGON.CTLOCID']);
	/*
	var a = cspRunServerMethod(GetQueryData.value, "Nur.NurDiagnosNoc:CRItem", "parr$"+parr, "AddRec");
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
	 var par=""
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
 
			  par=obj["par"];
			  rw=obj["rw"]
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
	       var id=par+"||"+rw
		   //alert(id)
	       var ee=tkMakeServerCall("Nur.NurDiagnosNoc","QtDelete",id)
		   find()	            
	       }
	        },    
	       animEl: 'newbutton'   
	       });

		
 	
	
}
