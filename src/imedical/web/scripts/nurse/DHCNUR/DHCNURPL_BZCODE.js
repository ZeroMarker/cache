/**
 * @author Administrator
 */
var grid;
var arrgrid = new Array();
	var arrgridM = new Array();
	var KNurseNameStore = new Ext.data.JsonStore({
			data :arrgridM,
			fields : ['id', 'desc']		
		});
var arrtim=new Array();
var GetQueryData = document.getElementById('GetQueryData');
var a = cspRunServerMethod(GetQueryData.value, "Nur.DHCNurLinkAss.GetModel", "" , "AddTim");
var storetim = new Ext.data.JsonStore({
			data : arrtim,
			fields : ['idv', 'des']
		});
function AddTim(str)
{
	var obj = eval('(' + str + ')');
	arrtim.push(obj);
}
var HLEmrCode = new Ext.form.ComboBox({
			id : 'HLCode',
			//hiddenName : 'region1',
			store : storetim,
			width : 300,
			fieldLabel : '根目录名',
			valueField : 'idv',
			value:"",
			displayField : 'des',
			triggerAction: "all",
			allowBlank : true,
			mode : 'local'
		});
var modeldata=[['BG','普通表格'],['PGD','评估单'],['TEM','体温单'],['QDPGD','青岛评估单'],['SBNEW','不良事件新'],['SBOLD','不良事件旧'],['HH','混合单']];
var storenurse1 = new Ext.data.SimpleStore({			
			fields : ['id', 'desc'],
			data :modeldata
		});
var Type = new Ext.form.ComboBox({
			id : 'Type',
			store : storenurse1,
			width : 100,
			fieldLabel : '模板类型',
			triggerAction: "all",
			valueField : 'id',
			value:"",
			displayField : 'desc',
			allowBlank : true,
			mode : 'local'
		});
		
var sourcestoredata=[['B','普通表格'],['SP','单次评估'],['MP','多次评估'],['H','混合单']];
var sourcestore = new Ext.data.SimpleStore({			
			fields : ['id', 'desc'],
			data :sourcestoredata
		});
var Source = new Ext.form.ComboBox({
			id : 'Source',
			store : sourcestore,
			width : 250,
			fieldLabel : '模板类型',
			triggerAction: "all",
			valueField : 'id',
			value:"",
			displayField : 'desc',
			allowBlank : true,
			mode : 'local'
		});

//标准模板
var arraybzmb= new Array();
function addbzmb(a, b) {
	 arraybzmb.push({
				idv : a,
				desc : b
			});
		}
var BzmbStore = new Ext.data.JsonStore({
			data :arraybzmb,
			fields : ['idv', 'desc']			
		});
var Bzmb = new Ext.form.ComboBox({
			id : 'Bzmb',
			store : BzmbStore,
			width : 170,
			fieldLabel : '标准模板',
			valueField : 'idv',
			triggerAction: "all",
			value:"",
			displayField : 'desc',
			allowBlank : true,
			mode : 'local'
		});
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
	  //tobar.addItem('标准模板',Bzmb)
      tobar.addItem('护理模板',HLEmrCode)		
	  var tbar2=new Ext.Toolbar({	});		
	  //tbar2.addItem('模板类型',Type)
	  //tbar2.addItem('-','数据绑定',Source)
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
			text : "删除",
			icon:'../images/uiimages/edit_remove.png',
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
		/*
		tbar2.addItem("-"); 
		tbar2.addButton({
			className : 'new-topic-button',
			text : "数据源维护",
			handler : source,
			id : 'source'
		});
*/
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
	       var bzcode = Ext.getCmp("Bzmb");
	       bzcode.setValue(rowObj[0].get("Code"));	
	       var HLCode = Ext.getCmp("HLCode");
	       HLCode.setValue(rowObj[0].get("LinkCode"));	
	       var typ = Ext.getCmp("Type");
	       typ.setValue(rowObj[0].get("Type"));
		     selectid=rowObj[0].get("rw")
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
  var Sourceobj = Ext.getCmp("Bzmb");
  Sourceobj.on('select',find)
  //alert(Sourceobj)
  arraybzmb= new Array();
  //tkMakeServerCall("NurEmr.EmrCodeDic","GetItmList","addbzmb")
  //Sourceobj.store.loadData(arraybzmb); 
  find();
}

function source()
{  
	 var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCNURIF_SOURCE&EpisodeID="  ;//"&DtId="+DtId+"&ExamId="+ExamId
	 //alert(lnk)
	 var wind22455=window.open(lnk,"htmsource",'left=200,top=100,toolbar=no,location=no,directories=no,resizable=yes,width=800,height=500');
}
var selectid=""
function moudsave(){
	
	}
function addmain(a, b) {
	arrgridM.push({
				id : a,
				desc : b
			});
}
function clearinfo(){
	     
	       var HLCode = Ext.getCmp("HLCode");
	       HLCode.setValue("");	
	     
		     selectid=""
		     var ADDSAVE = Ext.getCmp("ADDSAVE");
		     ADDSAVE.setDisabled(false)
		     var exchange = Ext.getCmp("exchange");
		     exchange.setDisabled(true)	  
		     var mygridDelete3 = Ext.getCmp("mygridDelete3");
		     mygridDelete3.setDisabled(true)
		     
	}
function additm()
{
	   var grid=Ext.getCmp('mygrid');
	var Plant = Ext.data.Record.create([
         
      ]);
   	            var count = grid.store.getCount(); 
                var r = new Plant(); 
                grid.store.commitChanges(); 
                grid.store.insert(count,r); 
                return;

}

function Add()
{
	//var bzcodename = Ext.getCmp("Bzmb");
	var CodeObj = Ext.getCmp("HLCode");	
    if (CodeObj.getValue()=="")
	{
		alert("关联护理模板不能为空")
		return;
		}
	
	//alert(selectid)
	if (selectid==""){
		var ret=tkMakeServerCall("Nur.DHCNurLinkCode","getid",CodeObj.getValue());
		if (ret!=""){
		  alert("该模板ID已经存在")
		  selectid=""
		  var ADDSAVE = Ext.getCmp("ADDSAVE");
		  ADDSAVE.setDisabled(true)
		  return	
	    }
	}
	var parr = "Text|" + "^Code|" +  "^LinkCode|" + CodeObj.getValue() + "^LinkName|" + CodeObj.lastSelectionText + "^Type|" +  "^TypeDesc|"  
	//alert(parr)
	//alert(selectid);
	//debugger;
	var a=tkMakeServerCall("Nur.DHCNurLinkCode","Save",parr,selectid);
	find()
	if (a!=0)
	{alert(a)}
	
	clearinfo()
	find()
	///mygrid.store.loadData(REC);
	
}
function find()
{	
	
    var grid = Ext.getCmp("mygrid");
	var GetQueryData=document.getElementById('GetQueryData2');
	arrgrid=new Array();
	var mbobj = Ext.getCmp("Bzmb");
	var parr=mbobj.getValue()
	//alert(parr)
	//alert(GetQueryData.value);
	/*
	var a = cspRunServerMethod(GetQueryData.value, "Nur.DHCNurLinkCode:CRItem", "parr$"+parr, "AddRec");
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
	       //var mygriddate = Ext.getCmp("Bzmb");
	       //mygriddate.setValue("");	       
	       var HLCode = Ext.getCmp("HLCode");
	        //bzcode.setDisabled(false)
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
function find2()
{	
    var grid = Ext.getCmp("mygrid");
	var GetQueryData=document.getElementById('GetQueryData');
	arrgrid=new Array();
	//alert(session['LOGON.CTLOCID']);
	var a = cspRunServerMethod(GetQueryData.value, "User.DHCNURMenu:CRItem2", "parr$", "AddRec2");
  //alert(a);
  grid.store.loadData(arrgrid);   
}
function AddRec2(str)
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
 
			  rw=obj["rw"];
}
 
if (rw==undefined) 
	{
		Ext.Msg.alert('提示', "请先选择有效行!");
		return;
	};
		var ee=tkMakeServerCall("Nur.DHCNurLinkCode","QtDelete",rw)
		if (ee != "0") {
			alert(ee);
			return;
		}
 	
	find()
}
function clearscreen() {
	var typ = Ext.getCmp("typsys");
	if (typ) typ.setValue("");
}
function diffDate(val,addday){
	var year=val.getYear();
	var mon=val.getMonth();
	var dat=val.getDate()+addday;
	var datt=new Date(year,mon,dat);
	return formatDate(datt);
}
function getDate(val)
{
	var a=val.split('-');
	var dt=new Date(a[0],a[1]-1,a[2]);
	return dt;
}
function formatDate(value){
  	try
	{
	   return value ? value.dateFormat('Y-m-d') : '';
	}
	catch(err)
	{
	   return '';
	}
 };