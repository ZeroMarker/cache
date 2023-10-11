/*
 * @author Administrator
 */
/*
 grid.store.on('load', function() {
    grid.el.select("table[class=x-grid3-row-table]").each(function(x) {
        x.addClass('x-grid3-cell-text-visible');
    });
});

grid.getStore().on('load',function(s,records){
          var girdcount=0;
          s.each(function(r){
              if(r.get('10')=='数据错误'){
                    grid.getView().getRow(girdcount).style.backgroundColor='#F7FE2E';
              }
              girdcount=girdcount+1;
          });
       //scope:this
       });
*/

var locdatabox = new Array();
cspRunServerMethod(getloc, 'addlocbox');
function addlocbox(a, b) {
	locdatabox.push({
				loc : a,
				locdes : b
			});
}
var storelocbox = new Ext.data.JsonStore({
			data : locdatabox,
			fields : ['loc', 'locdes']
		});
var LocBox = new Ext.form.ComboBox({
			id : 'locbox',
			hiddenName : 'loc12222',
			store : storelocbox,
			width : 300,
			fieldLabel : '科室',
			valueField : 'loc',
			 triggerAction : 'all',
			displayField : 'locdes',
			allowBlank : true,
			mode : 'local',
			anchor : '100%'
		});

var arrgrid = new Array();
var KNurseName = new Ext.data.JsonStore({
			data :[],
			fields : ['id', 'desc']
			
		});
var KNurseName = new Ext.form.ComboBox({
			id : 'KNurseName',
			//hiddenName : 'region1',
			store : KNurseName,
			width : 80,
			fieldLabel : '根目录名',
		    triggerAction : 'all',
			valueField : 'id',
			value:"",
			displayField : 'desc',
			allowBlank : true,
			mode : 'local'
		});
KNurseName.on('select', function() 
    {
	        var KNurseName = Ext.getCmp("KNurseName");
			var id=KNurseName.getValue()
			var Getval=document.getElementById('Getval');
	        if (Getval) 
	        {
	        }
            var KNurseobj = Ext.getCmp("mygridmodle");
			KNurseobj.setValue("")
				 var KNurseobj = Ext.getCmp("xsname");
			KNurseobj.setValue("")
			find()
   });
var modledata = new Array();
var GetModel = document.getElementById('GetModel');
if (GetModel) {
	cspRunServerMethod(GetModel.value, 'addmodel');
}

function addmodel(a, b) {
	modledata.push({
				modle : a,
				modledesc : b
			});
}
var modlestore = new Ext.data.JsonStore({
			data : modledata,
			fields : ['modle', 'modledesc']
		});
var combo = new Ext.form.ComboBox({
			id : 'mygridmodle',
			store : modlestore,
			valueField : 'modle',
			displayField : 'modledesc',
			typeAhead : true,
			mode : 'local',
			triggerAction : 'all',
			// emptyText:'按模版查询...',
			selectOnFocus : true,
			width : 200,
			listeners : {
				select : function(combo, record, index) {					
				}
			}
		});
combo.on('select', function() {
	     Ext.getCmp("xsname").setValue("");
	     Ext.getCmp("xsname").setDisabled(true)
		find()
		});
LocBox.on('select', function() {
		  Ext.getCmp("name").setValue("");
	     Ext.getCmp("ifshow").setValue(false)
		setTimeout("find()",0)
});
function BodyLoadHandler(){

	if (typeof(arr[0].items)!="undefined") arr[0].items[0].getBottomToolbar().hide();
	setsize("mygridpl", "gform", "mygrid");
	var but1 = Ext.getCmp("mygridbut1");
	but1.hide();
	var but = Ext.getCmp("mygridbut2");
	but.hide();
	var grid = Ext.getCmp('mygrid');
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	tobar.addItem('病区',LocBox),	

    tbar2=new Ext.Toolbar({	});		
    tbar2.addItem( '名称', {
				xtype : 'textfield',
				width:200,
				id : 'name',
				fieldLabel : '模板名称'
			}),		
			tbar2.addItem( '是否显示', {
				xtype : 'checkbox',
				//width:50,
				id : 'ifshow',
				fieldLabel : '是否显示'
			}),		
	tbar2.addItem("-");
	tbar2.addButton({
		className: 'new-topic-button',
		text: "保存",
		handler:Save,
		id: 'update'
	});
	tbar2.addButton({
		className: 'new-topic-button',
		text: "查询",
		handler: find,
		id: 'mygridSch'
	});

	
 
   tbar2.render(grid.tbar);	
   tobar.doLayout(); 
   grid.addListener('rowclick', function()
   { 
     var grid = Ext.getCmp('mygrid');
   	 var objRow=grid.getSelectionModel().getSelections();
	 if (objRow.length == 0) {
		return;
	 }
	 else {		
	   var grid = Ext.getCmp("mygrid");
	   var rowObj = grid.getSelectionModel().getSelections();
	   var rwval=Ext.getCmp("locbox").getValue();
	   if (rwval!="")
	   {
	      var mygridtime = Ext.getCmp("name");
	      mygridtime.setValue(rowObj[0].get("Name"));
	      var showobj = Ext.getCmp("ifshow");
	      var showval = rowObj[0].get("Ifshow");
	      if (showval=="Y")
	      {
	         showobj.setValue(true);
	      }else{
	         showobj.setValue(false)	
	      }
	      Ext.getCmp("update").setDisabled(false)		
	   }else{
	   	  Ext.getCmp("update").setDisabled(true)		
	   }
	}}
   );
    Ext.getCmp("name").setDisabled(true)
   grid.addListener('rowcontextmenu', rightClickFn);
   setTimeout("find()",0)
  
 
//alert();
//debugger;
}
//使用全院配置
function deleteloc()
{
	  var locboxobj = Ext.getCmp("locbox");  //科室
	  if (locboxobj.getValue()!="")
	  {
	  Ext.Msg.show({    
	       title:'确认一下',    
	       msg: '您将删除本病区配置信息，删除后将使用全院默认配置！确定删除？',    
	       buttons:{"ok":"是     ","cancel":"  否"},
	       fn:  function(btn, text){    
	            if (btn == 'ok'){   
	
	         	      var a=tkMakeServerCall("User.DHCNURMenuSub","deleteloc",locboxobj.getValue())	
	                  Ext.getCmp("deleteloc").setDisabled(true)
                      find();						  
	            }
				else
	            {   
      			}
	            
	        },    
	       animEl: 'newbutton'   
	       });
	  }
}
function additm()
{
	var modle = Ext.getCmp("mygridmodle"); //模板
	var locboxobj = Ext.getCmp("locbox");  //科室
	var Name = Ext.getCmp("KNurseName");  //根目录
	var mygrid = Ext.getCmp("mygrid");
	//alert(Name.getValue())
	if (modle.getValue()=="")
	{
		alert("模板不能为空");
		return;
	}
	if (Name.getValue()=="")
	{
		alert("根目录不能为空");
		return;
	}
	//alert(Name.getValue())
	var modelname = Ext.getCmp("mygridmodle").lastSelectionText;
	var gname = Ext.getCmp("KNurseName").lastSelectionText;
	//alert(gname)
	var parr =Name.getValue() + "^" + modle.getValue() +"^"+locboxobj.getValue()+"^"+modelname+"^"+gname
	//alert(parr);
	var a=tkMakeServerCall("User.DHCNURMenuSub","Additm",parr)	
	if (a!=0)
	{alert(a)}
    Ext.getCmp("mygridmodle").setValue("")
	find()
}
function clearall()
{
	Ext.getCmp("mygridmodle").setValue("");
	Ext.getCmp("xsname").setValue("");
	Ext.getCmp("KNurseName").setValue("");
	Ext.getCmp("xsname").setDisabled(true)
	Ext.getCmp("mygridSch").setDisabled(false)
	Ext.getCmp("delete").setDisabled(true)
	find()
}
function clearall2()
{
	Ext.getCmp("mygridmodle").setValue("");
	Ext.getCmp("xsname").setValue("");
	Ext.getCmp("xsname").setDisabled(true)
	Ext.getCmp("mygridSch").setDisabled(false)
	Ext.getCmp("delete").setDisabled(true)
	//Ext.getCmp("KNurseName").setValue("");
	find()
}
var rightClick = new Ext.menu.Menu(  {
            id : 'rightClickCont',
            items : [  {
                id:'rMenu1',
                text : '上移',
                handler:up
            },  {
                id:'rMenu2',
                text : '下移',
                handler:down
            }]
        });
function rightClickFn(client, rowIndex, e)  {
          e.preventDefault();
          grid=client;
		      CurrRowIndex=rowIndex;
          rightClick.showAt(e.getXY());
     }
function up()
{
  var grid=Ext.getCmp("mygrid");
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		return;
	}
	else {	   
		 var rw = objRow[0].get("rw");
		 var chl = objRow[0].get("par");
		  var locs = objRow[0].get("loc");
		if (rw!="")
		{
			 var a=tkMakeServerCall("User.DHCNURMenuSub","upordown",locs,rw,chl,-1)
             find2()
		}else{
			alert("请先保存")
		}
       
   }
}
function down()
{
   var grid=Ext.getCmp("mygrid");
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		return;
	}
	else {	   
		 var rw = objRow[0].get("rw");
		 var chl = objRow[0].get("par");
		 var locs = objRow[0].get("loc");
		 if (rw!="")
		 {
            var a=tkMakeServerCall("User.DHCNURMenuSub","upordown",locs,rw,chl,1)
            find2()
		 }else{
			alert("请先保存")
		}
   }
}
function rowClickFn(grid, rowIndex, e)  {
               // alert('你单击了' + rowIndex);
                //var grid=Ext.getCmp("mygrid");
	
		//var rw = objRow[0].get("rw");
		//var chl = objRow[0].get("par");
		//var par = objRow[0].get("par");
		//var id=rw+"||"+chl;
		//alert(par);
		//var a = cspRunServerMethod(SetStatus.value,id);
		//find()
	}
	
            
function delete1()
{
	var grid=Ext.getCmp("mygrid");
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		return;
	}
	else {
	   var SetStatus=document.getElementById('delete');
		var rw = objRow[0].get("rw");
		var chl = objRow[0].get("par");
		var id=rw+"^"+chl;
		//alert(par);
		var a = cspRunServerMethod(SetStatus.value,id);

	}
			clearall2()
	}
function Save()
{  
    var grid=Ext.getCmp("mygrid");
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) 
	{
	  
	}
	else 
	{
	
		var loc =  Ext.getCmp("locbox").getValue();
		var ifshow =  Ext.getCmp("ifshow").getValue();
		if (ifshow)
		{
		  ifshow="Y"
		}else{
		  ifshow="N"	
		}
		var nameval = objRow[0].get("Name");
		var codeval = objRow[0].get("Code");
		var rw = objRow[0].get("rw");
    var parr=loc+"^"+codeval+"^"+nameval+"^"+ifshow
    //alert(parr)
		var a = tkMakeServerCall("User.DHCNURMenuFilter","Save",parr,rw)
	  if(a!=0)
		{alert(a);}
	  setTimeout("find()",0)
	}	
}
function Saveback()
{ var modle = Ext.getCmp("mygridmodle");
	var locboxobj = Ext.getCmp("locbox");
	var Name = Ext.getCmp("KNurseName");
	var RecSave = document.getElementById('Save');
	var mygrid = Ext.getCmp("mygrid");
	if (locboxobj.getValue()=="")
	{
		//alert("科室不能为空")
	   //	return;
	}
	var modelname = Ext.getCmp("mygridmodle").lastSelectionText;
	var gname = Ext.getCmp("KNurseName").lastSelectionText;
	var parr =Name.getValue() + "^" + modle.getValue() +"^"+locboxobj.getvalue()+"^"+modelname+"^"+gname
	alert(parr);
	var a = cspRunServerMethod(RecSave.value, parr,"");
	if (a!=0)
	{alert(a)}
	find()
	
}


function inidata(cmbname,desc,quer,parr)
{
	var cmb=Ext.getCmp(cmbname);
	var querymth=document.getElementById('GetQueryCombox');
	if (cmb!=null)	
	{
 	 arrgrid=new Array();
	 var a = cspRunServerMethod(querymth.value, quer, parr , "AddRec",desc);
     cmb.store.loadData(arrgrid);
	}

}

var REC=new Array();

//查询
function find()
{
	REC = new Array();
	var locId = Ext.getCmp("locbox").getValue();
	//alert(locId)
	tkMakeServerCall("User.DHCNURMenuSub","GetDepModelSetAll",locId,"adddepmodel")
  var mygrid1 = Ext.getCmp("mygrid");
	mygrid1.store.loadData(REC);
	mygrid1.getStore().on('load',function(s,records){
          var girdcount=0;
          s.each(function(r){
              if (r.get("Ifshow")=="Y"){
                    mygrid1.getView().getCell(girdcount,1).style.backgroundColor="#B0C4DE"	
              }
             else{
                    //grid1.getView().getRow(girdcount).style.backgroundColor='#F7FE2E';
                    mygrid1.getView().getCell(girdcount,1).style.backgroundColor="#FF0000"	
              }
               
              girdcount=girdcount+1;
          });
       //scope:this
       });  

}
//普通
function adddepmodel(a1,a2,a3,a4,a5)
{
	REC.push({
		Name:a1,
		Ifshow:a2,
		Code:a3,
		loc:a4,
		rw:a5	
	});
}
function find2()
{
	var xsname = Ext.getCmp("xsname");
	var mode = Ext.getCmp("mygridmodle");
	var subtype = Ext.getCmp("KNurseName");
	var locsel = Ext.getCmp("locbox");
	var mygrid = Ext.getCmp("mygrid");
	var parr = "^" + subtype.getValue() + "^" + "^" +  "^" +locsel.getValue()
	var GetQueryData=document.getElementById('GetQueryData');
	arrgrid=new Array();
	var grid = Ext.getCmp("mygrid");
	var a = cspRunServerMethod(GetQueryData.value, "User.DHCNURMenuSub:CRItem", "parr$"+parr, "AddRec");
    grid.store.loadData(arrgrid);   
	Ext.getCmp("add").setDisabled(false)
	Ext.getCmp("mygridmodle").setDisabled(false)
	
	Ext.getCmp("delete").setDisabled(true)
	var locselect = Ext.getCmp("locbox").lastSelectionText;
	if (locselect=="")
	{
		locselect="默认"
	}
	//mygrid.setTitle("子目录维护 ->"+locselect)
	
}

function AddRec(str)
{
	//var a=new Object(eval(str));
	//alert(str);
	str=str.replace(/\t+/g,"").replace(/\n+/g,"").replace(/\r+/g,"").replace(/\s+/g,"");  //去除字符串中空格
	var obj = eval('(' + str + ')');
	
	//obj.CareDate=getDate(obj.CareDate);
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	arrgrid.push(obj);
	//debugger;
}


function(record,rowIndex,rowParams,store)
 {   
                    //禁用数据显示红色   
 if(record.data.pstate!=0)
 { 
    return 'x-grid-record-red';   
 }
 else
 { 
   return '';   
  }   
                       
} //end for getRowClass  


//Ext.util.Format.dateRenderer
//ext.util.format.date(ext.getcmp("控件id").getvalue(),y-m-d)Y-m-d H:m:s
function gettime()
{
	var a=Ext.util.Format.dateRenderer('h:m');
	return a;
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


var checkret="";

function add(a1, a2){
	attenitm.push({
		xtype:'panel',
		id: a1,
		title: a2,
		region:'center',
		height:1000,
		layout:'fit',
		closable:true,
		items:[]
	})
}


var condata=new Array();
function add(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o)
{ //OrdDate,OrdTime,ARCIMDesc,PriorDes,Meth,PHFreq,Dose,PhQtyOrd,OrdStat,Doctor,Oew,OrdSub,Sel,SeqNo
 	condata.push({
		OrdDate: a,
		OrdTime: b,
		ARCIMDesc: c,
		PriorDes: d,
		Meth: e,
		PHFreq: f,
		Dose: g,
		DoseUnit: h,
		PhQtyOrd: i,
		OrdStat: j,
		Doctor: k,
		Oew: l,
		OrdSub: m,
		SeqNo: o
	});
}
function DBC2SBC(str)   
{
	var result = '';
	if ((str)&&(str.length)) {
		for (i = 0; i < str.length; i++) {
			code = str.charCodeAt(i);
			if (code >= 65281 && code <= 65373) {
				result += String.fromCharCode(str.charCodeAt(i) - 65248);
			}
			else {
				if (code == 12288) {
					result += String.fromCharCode(str.charCodeAt(i) - 12288 + 32);
				}
				else {
					result += str.charAt(i);
				}
			}
		}
	}
	else{
		result=str;
	}  
	return result;   
}

