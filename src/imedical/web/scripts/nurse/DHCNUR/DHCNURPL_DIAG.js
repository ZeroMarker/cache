var grid;
var arrgrid = new Array();
var arrgridnurse = new Array();
var selectid=""
var storenurse = new Ext.data.JsonStore({
			data :arrgridnurse,
			fields : ['desc', 'id']
		});
var patward = new Ext.form.ComboBox({
			id : 'patward',
			//hiddenName : 'region1',
			fieldLabel : '标准模板',
			store : storenurse,
			width : 120,
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
			if (grid.getColumnModel().getDataIndex(i) == 'gdcode') {
				grid.getColumnModel().setHidden(i, true);
			}
		}
		var but1=Ext.getCmp("mygridbut1");
	  but1.hide()
	  var but=Ext.getCmp("mygridbut2");
	  but.hide()
	  var mydate = new Date();
	  var tobar = grid.getTopToolbar();
	 		
      tobar.addItem('护理结局','-',
		    {
				xtype : 'textarea',
				id : 'result',
				width:200,
				height:180,
				fieldLabel : 'id'
			},'护理措施','-',
		    {
				xtype : 'textarea',
				id : 'case',
				width:250,
				height:180,
				fieldLabel : 'id'
			},'描述','-',
		    {
				xtype : 'textarea',
				id : 'bzdesc',
				width:800,
				height:180,
				fieldLabel : 'id'
			})
		  var tbar1=new Ext.Toolbar({	});	
		  tbar1.addItem('版本',CreateComboBox("version","desc","rw","版本","V1",60,"Nur.DHCNurDiagnos","getversion","parr","",""),'-');	
          tbar1.addItem('病区',CreateComboBox("ctloc","desc","rw","病区","",200,"Nur.DHCNurDiagnos","getloc","parr","",""),'-');	
	  
	      tbar1.addItem('戈登分类',patward,'-');		  
		  tbar1.addItem('护理诊断或疾病名称',
		  {
				xtype : 'textarea',
				id : 'bzcodename',
				width:250,
				height:50,
				fieldLabel : '名称'
			},'-','子诊断',
	        {
				xtype : 'textarea',
				id : 'subdiag',
				width:250,
				height:50,
				fieldLabel : 'id'
			},'-','代码',
		  {
				xtype : 'textfield',
				id : 'bzcode',
				width:100,
				fieldLabel : 'id'
			})
		
		 tbar1.render(grid.tbar); 
		 
		 var tbar2=new Ext.Toolbar({	});	
		tbar2.addItem("-");   		 
			tbar2.addButton({
			//className : 'new-topic-button',
			text : "增加",
			handler : Add,
			icon:'../images/uiimages/edit_add.png',
			id : 'ADDSAVE'
		});		
		tbar2.addItem("-"); 
		tbar2.addButton({
			//className : 'new-topic-button',
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
			//className : 'new-topic-button',
			text : "查询",
			handler : find,
			icon:'../images/uiimages/search.png',
			id : 'find'
		});
		tbar2.addItem("-"); 
		tbar2.addButton({
			//className : 'new-topic-button',
			text : "清屏",
			handler : clearinfo,
			icon:'../images/uiimages/clearscreen.png',
			id : 'clear'
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
	grid.on('cellclicksddd', function(grid,row,col,e)
    {
		var grid = Ext.getCmp('mygrid');
   	    var objRow=grid.getSelectionModel().getSelections();
        var sel=objRow[0].get("par")
		var cellwin =new Ext.Window({
				    id:'desccs',
				    width:350,
				    closable:false,
				    constrain:true,
				    resizable:false,
				    draggable:false,
			    	hideBorders:true,
					x:e.xy[0],y:e.xy[1],
			    	layout:'absolute',
				    autoScroll : true,				    
				    buttonAlign: 'center',
				    height:350,
				    items:[{xtype:'textarea',
					  id:'ms',
					  x:5,
					  y:5,
					  width:310,
					  height:310
					  
					}],
				    buttons : [{
							text : '确定',
							id:'sure',
							x:5,
							width:20,
							handler : function() {
								
								var textval = Ext.getCmp('ms').getValue();
								//alert(textval)
								var ret=tkMakeServerCall("Nur.DHCNurDiagnos","SaveDesc",textval,sel)
								cellwin.close();
								find()
							}
					},{
							text : '关闭',
							id:'close',
							width:20,
							handler : function() {
								cellwin.close();
							}
						}]
			   }).show();
			   if (sel!="")
			   {
				   var ret=tkMakeServerCall("Nur.DHCNurDiagnos","getDesc",sel)
				   Ext.getCmp('ms').setValue(ret)
			   }
	})
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
		    var obj = Ext.getCmp("subdiag");
	       obj.setValue(rowObj[0].get("subdiag"));
           var obj = Ext.getCmp("result");
	       obj.setValue(rowObj[0].get("Result"));
           var obj = Ext.getCmp("case");
	       obj.setValue(rowObj[0].get("CaseMeasure"));		   
	        var pat = Ext.getCmp("patward");
	       pat.setValue(rowObj[0].get("gdcode"));	
           var obj = Ext.getCmp("ctloc");
	       obj.setValue(rowObj[0].get("locid"));
           var objStore=obj.getStore();
           objStore.on('load',function(polityStore,records,options){
		      obj.selectText();
		      obj.setValue(obj.getValue());
	       });		   
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
   grid.addListener('rowcontextmenu', rightClickFn);
    var maincode = Ext.getCmp("patward");
    arrgridnurse = new Array();
	tkMakeServerCall("Nur.DHCNurDiagnos","GetItmList","addmain")
	maincode.store.loadData(arrgridnurse);
	maincode.on('select',find)
	var obj=Ext.getCmp("ctloc")
	obj.on('select',find)	
	Ext.getCmp("ctloc").store.on("beforeLoad",function(){	
  	  //alert(session['LOGON.CTLOCID'])   	
  	  var parr=Ext.getCmp("ctloc").lastQuery 
      if (parr==undefined)
	  {
		  parr="";
	  }		  
	  //alert(parr)
      obj.store.baseParams.parr=parr;        
    });
    obj.store.load({params:{start:0,limit:20},callback:function(){	
    }})
	var obj=Ext.getCmp("version")
	obj.on('select',find)
    find();
}
var rightClick = new Ext.menu.Menu(  {
            id : 'rightClickCont',
            items : [ ]
        });
function rightClickFn(client, rowIndex, e)  
{
          e.preventDefault();
          grid=client;
		  
          
 }
function Add()
{
	var bzcodename = Ext.getCmp("bzcodename");
	var bzcode = Ext.getCmp("bzcode");
	var bzdesc = Ext.getCmp("bzdesc");
	var patwardobj = Ext.getCmp("patward");
	var versionobj = Ext.getCmp("version");
	var ctlocobj = Ext.getCmp("ctloc");
	var subdiagobj = Ext.getCmp("subdiag"); //子诊断
	var resultobj = Ext.getCmp("result");  //护理结局
	var caseobj = Ext.getCmp("case");       //护理措施
	if (patwardobj.getValue()=="")
	{
		//alert("戈登分类不能为空！")
		//return
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
		/*
		var ret=tkMakeServerCall("Nur.DHCNurDiagnos","getid",patwardobj.getValue(),bzcodename.getValue());
		if (ret!=""){
		  alert("该分类下ID已经存在")
		  selectid=""
		  var ADDSAVE = Ext.getCmp("ADDSAVE");
		  ADDSAVE.setDisabled(true)
		  return	
			}
			*/
	}
	var parr = "Text|"+bzcodename.getValue() + "^Desc|" + bzdesc.getValue() + "^Cate|" + patwardobj.getValue() + "^Version|" + versionobj.getValue() + "^Loc|" + ctlocobj.getValue()+ "^subdiag|" + subdiagobj.getValue()  
	parr=parr+"^Result|"+resultobj.getValue()+"^CaseMeasure|"+caseobj.getValue()
	//alert(parr)
	var a=tkMakeServerCall("Nur.DHCNurDiagnos","Save",parr,selectid);
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
	Ext.getCmp("patward").setValue("")
	Ext.getCmp("ctloc").setValue("")
	Ext.getCmp("subdiag").setValue("")
	Ext.getCmp("result").setValue("")
	Ext.getCmp("case").setValue("")
	selectid="";
}
function find()
{	
  
	 if (selectid!="") 
	{return;
	}
   
	
    var grid = Ext.getCmp("mygrid");
	var GetQueryData=document.getElementById('GetQueryData2');
	arrgrid=new Array();
	var versionobj = Ext.getCmp("version");
	var ctlocobj = Ext.getCmp("ctloc");
	var gdcateobj = Ext.getCmp("patward");
	var parr=versionobj.getValue()+"^"+ctlocobj.getValue()+"^"+gdcateobj.getValue()
	//alert(session['LOGON.CTLOCID']);
	/*
	var a = cspRunServerMethod(GetQueryData.value, "Nur.DHCNurDiagnos:CRItem", "parr$"+parr, "AddRec");
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
	var grid=Ext.getCmp('mygrid');
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) 
	{
		alert("请先选择一条记录!");
		return;
	} else 
	{
		var flag = confirm("你确定要删除此条记录吗？删除后不可恢复！")
		if (flag) 
		{
			 var par = objRow[0].get("par");
			 //alert(par)
			 var ret=tkMakeServerCall("Nur.DHCNurDiagnos","QtDelete",par)
			 //alert(ret)
			 selectid=""
			 find()
		}
	}
	
}
