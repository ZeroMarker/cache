/**
 * @author Administrator
 */
var grid;
var locdata = new Array();
var loc = session['LOGON.CTLOCID'];
cspRunServerMethod(getloc, loc, 'addloc');
function addloc(a, b) {
	locdata.push({
				loc : a,
				locdes : b
			});
}

var locationdata = new Array();
cspRunServerMethod(getlocation, loc, 'addlocation');
function addlocation(a, b) {
	locationdata.push({
				location : a,
				locationdes : b
				
			});
}

var i = 2;
var storeloc = new Ext.data.JsonStore({
			data : locdata,
			fields : ['loc', 'locdes']
		});
var storelocation = new Ext.data.JsonStore({
			data : locationdata,
			fields : ['location', 'locationdes']
		});
var locField = new Ext.form.ComboBox({
			id : 'locsys',
			hiddenName : 'loc1',
			store : storeloc,
			width : 200,
			editable:false,
			triggerAction:'all',
			fieldLabel : '病区',
			valueField : 'loc',
			displayField : 'locdes',
			allowBlank : true,
			mode : 'local',
			anchor : '100%'
		});
var locationField = new Ext.form.ComboBox({
			id : 'locationsys',
			hiddenName : 'location1',
			store : storelocation,
			width : 200,
			editable:true,
			triggerAction:'all',
			fieldLabel : '科室',
			valueField : 'location',
			displayField : 'locationdes',
			allowBlank : true,
			mode : 'local',
			anchor : '100%'
		});
locField.on('select', function() {
	find();
});
locationField.on('select', function() {
	find();
});
var arrtim=new Array();
function BodyLoadHandler(){
	setsize("mygridpl","gform","mygrid");
	//fm.doLayout(); 
  grid1=Ext.getCmp("mygrid");

	var but1=Ext.getCmp("mygridbut1");
	but1.hide();
	//but1.on('click',additm);
	var but=Ext.getCmp("mygridbut2");
	but.setText("选行保存");
	but.on('click',save);

	Ext.override(Ext.Editor, {
			onSpecialKey : function(field, e) {
				var key = e.getKey();
				this.fireEvent('specialkey', field, e);
			}
		});
	Ext.override(Ext.grid.RowSelectionModel, {
			onEditorKey : function(F, E) {
				var C = E.getKey(), G, D = this.grid, B = D.activeEditor;
				var A = E.shiftKey;
				if (C == E.TAB) {
					E.stopEvent();
					B.completeEdit();
					if (A) {
						G = D.walkCells(B.row, B.col - 1, -1, this.acceptsNav,
								this);
					} else {
						G = D.walkCells(B.row, B.col + 1, 1, this.acceptsNav,
								this);
					}
				} else {
					if (C == E.ENTER) {
						E.stopEvent();
						// alert(B);
						B.completeEdit();
						if (this.moveEditorOnEnter !== false) {
							if (A) {
								// G = D.walkCells(B.row - 1, B.col, -1,
								// this.acceptsNav,this)
								G = D.walkCells(B.row, B.col - 1, -1,
										this.acceptsNav, this);
							} else {
								// G = D.walkCells(B.row + 1, B.col, 1,
								// this.acceptsNav,this)
								G = D.walkCells(B.row, B.col + 1, 1,
										this.acceptsNav, this);
							}
						}
					} else {
						if (C == E.ESC) {
							B.cancelEdit();
						}
					}
				}
				if (G) {
					D.startEditing(G[0], G[1]);
				}
			}
		});
    var sm2 = new Ext.grid.RowSelectionModel({   
        moveEditorOnEnter: true,   
        singleSelect: false,   
        listeners: {   
            //rowselect : function(sm, row, rec) {   
                //centerForm.getForm().loadRecord(rec);   
           // }   
        }   
  
    });
	if (storeloc.getCount()>0) {
			//var firstDsec=storeloc.getAt(0).data.locdes;
			var firstValue=storeloc.getAt(0).data.loc;
			var cmbtim=Ext.getCmp("locsys");
			cmbtim.setValue(firstValue);
		}
	if (storelocation.getCount()>0) {
			//var firstDsec=storeloc.getAt(0).data.locdes;
			var firstValue=session['LOGON.CTLOCID'] //storelocation.getAt(0).data.location;
			var cmbtim=Ext.getCmp("locationsys");
			cmbtim.setValue(firstValue);
		}
  grid=Ext.getCmp('mygrid');
  var mydate=new Date();
  var tobar=grid.getTopToolbar();
  tobar.addButton({
		className: 'new-topic-button',
		text: "全部保存",
		handler:Saveall,
		id:'mygridSch22'
	});
	tobar.addItem('-','病区', locField,'-','科室', locationField,'-','日期',
	{
			xtype:'datefield',
			//format: 'Y-m-d',
			id:'mygridstdate',
			value:(diffDate(new Date(),0))
	});
	tobar.addButton({
		className: 'new-topic-button',
		text: "查询",
		handler:find,
		id:'mygridSch'
	});
 	tobar.addButton({
			//className: 'new-topic-button',
			text: "打印",
			handler:printNurRec,
			id:'PrintBut'
	});
	//tobar.render(grid.tbar);
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
	//if (loc=="") loc=session['LOGON.CTLOCID'];
	grid.addListener('rowcontextmenu', rightClickFn);
	Ext.QuickTips.init();//注意，提示初始化必须要有
	find();
  }

var REC=new Array();
function find(){
	REC = new Array();
	var StDate = formatDate(Ext.getCmp("mygridstdate").getValue());
	var StTime = "08:00:00"; 
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	var loc = Ext.get("loc1").dom.value;
	if (loc=="") loc=session['LOGON.CTLOCID'];
	var location=Ext.get("location1").dom.value;
	var parr =loc+"^"+StDate+"^"+StTime+"^"+location;
	// debugger;
	//alert("Parr$" + parr);
	//var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurShiftExchage:FindCurWardPat", "Parr$" + parr, "AddRec");
	//mygrid.store.loadData(REC);
	//alert(parr)
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
}
function AddRec(str)
{
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	REC.push(obj);
	//debugger;
}
function save()
{
		var store = grid.store;
		var rowCount = store.getCount(); //记录数
		var cm = grid.getColumnModel();
		var colCount = cm.getColumnCount(); 
		var StDate = formatDate(Ext.getCmp("mygridstdate").getValue());
		var StTime="08:00:00";
		//var StTime = Ext.getCmp("mygridttime").lastSelectionText;
    //if ((StTime=="")||(StTime==undefined)) return;
		var list = [];
		var rowObj = grid.getSelectionModel().getSelections();
		var len = rowObj.length;
		for (var r = 0;r < len; r++) {
				list.push(rowObj[r].data);
	  }
		//for (var i = 0; i < store.getCount(); i++) {
		//	list.push(store.getAt(i).data);
			//	debugger;
		//}
    var RecSave=document.getElementById('RecSave');
		for (var i = 0; i < list.length; i++) {
			  var obj=list[i];
			  var str="";
			  var CareDate="";
			  var CareTime="";
			  var flag="0";
				for (var p in obj) {			
						if (p=="Adm") EpisodeID=obj[p];
						if (p=="") continue;
						str = str + p + "|" + DBC2SBC(obj[p]) + '^';
				}
				if (str!="") {
					  //alert(RecSave.value+","+EpisodeID+","+str+","+StDate+","+StTime);
						var a=cspRunServerMethod(RecSave.value,EpisodeID,str,session['LOGON.USERID'],StDate,StTime,session['LOGON.GROUPDESC']);
						if (a!="0") {
							alert(a);
							return;
						}
				}
		}
		find();
}
function DBC2SBC(str)   
{
	var result = '';
	if ((str)&&(str.length)) 
	{
		for (i = 0; i < str.length; i++) {
			code = str.charCodeAt(i);
		 // alert(code)
			if (code >= 65281 && code <= 65373) {
				result += String.fromCharCode(str.charCodeAt(i) - 65248);
			}
			else {
				if (code == 12288) {
					result += String.fromCharCode(str.charCodeAt(i) - 12288 + 32);
				}
				else {
					if ((code==39 )||(code==92))
			    {//alert(code)
			    }
			    else
			     {
			     
					result += str.charAt(i);
					 //alert(result)
					}
				}
			}
		}
	}
	else
	{
		result=str;
	}  
	//alert(result)
	return result;   
}
function Saveall()
{
		var store = grid.store;
		var rowCount = store.getCount(); //记录数
		var cm = grid.getColumnModel();
		var colCount = cm.getColumnCount(); 
		var StDate = formatDate(Ext.getCmp("mygridstdate").getValue());
		var StTime="08:00:00";
		//var StTime = Ext.getCmp("mygridttime").lastSelectionText;
    //if ((StTime=="")||(StTime==undefined)) return;
		var list = [];
		//var rowObj = grid.getSelectionModel().getSelections();
		//var len = rowObj.length;
		//for (var r = 0;r < len; r++) {
		//		list.push(rowObj[r].data);
	 // }
		for (var i = 0; i < store.getCount(); i++) {
			list.push(store.getAt(i).data);
			//	debugger;
		}
    var RecSave=document.getElementById('RecSave');
		for (var i = 0; i < list.length; i++) {
			  var obj=list[i];
			  var str="";
			  var CareDate="";
			  var CareTime="";
			  var flag="0";
				for (var p in obj) {			
						if (p=="Adm") EpisodeID=obj[p];
						if (p=="") continue;
						str = str + p + "|" + obj[p] + '^';
				}
				if (str!="") {
					  //alert(RecSave.value+","+EpisodeID+","+str+","+StDate+","+StTime);
						var a=cspRunServerMethod(RecSave.value,EpisodeID,str,session['LOGON.USERID'],StDate,StTime,session['LOGON.GROUPDESC']);
						if (a!="0") {
							alert(a);
							return;
						}
				}
		}
		find();
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
 
function rightClickFn(client, rowIndex, e)  {
          e.preventDefault();
          grid=client;
		  CurrRowIndex=rowIndex;
          rightClick.showAt(e.getXY());
            }
var rightClick = new Ext.menu.Menu(  {
    id : 'rightClickCont',
    items : [  {
        id:'rMenu0',
        text : '全部记录',
        handler:PatDataDetail
    }]
});
function printNurRec()
{
	var StDate = formatDate(Ext.getCmp("mygridstdate").getValue());
	var StTime = "08#00#00";
	var loc = Ext.get("loc1").dom.value;
	if (loc=="") loc=session['LOGON.CTLOCID'];
	var LogLocDesc=cspRunServerMethod(LogLoc,loc);
	var location=Ext.get("location1").dom.value;
	var parr =loc+"!"+StDate+"!"+StTime+"!"+session['LOGON.CTLOCID']+"!"+location;
	PrintComm.LHeadCaption="科室: "+LogLocDesc+"    日期: "+StDate;
	//PrintComm.RHeadCaption="";
	//PrintComm.RFootCaption="";
	//PrintComm.LFootCaption="";
	PrintComm.SetPreView("1");
	PrintComm.PrnLoc=session['LOGON.CTLOCID'];
	PrintComm.stPage=0;
	PrintComm.stRow=0;
	PrintComm.previewPrint="1"; //是否弹出设置界面
	PrintComm.stprintpos=0;
	PrintComm.SetConnectStr(CacheDB);
	PrintComm.ItmName = "DHCDOCSHIFTEXCHAGEPrnMould";
	PrintComm.ID = "";
	PrintComm.MultID = ""; 
	PrintComm.MthArr="";
	PrintComm.LabHead="";
	//alert(parr);
	PrintComm.SetParrm(parr);
	PrintComm.WebUrl=WebIp+"/dthealth/web/DWR.DoctorRound.cls";
	//debugger;
	PrintComm.PrintOut();
}
function eachItem(item,index,length) {   
 	 if (item.xtype=="checkbox") {   
            //修改下拉框的请求地址    
			//debugger;
			if (item.checked==true) checkret=checkret+item.id+"|"+item.boxLabel+"^";
    } 
	  
    if (item.items && item.items.getCount() > 0) {   
       item.items.each(eachItem, this);   
    }   
}
function PatDataDetail()
{         
	var rowObj = grid1.getSelectionModel().getSelections();
	if (rowObj.length == 0) { Ext.Msg.alert('提示', "请先选择一条记录!"); return; }
	var Adm=rowObj[0].get("Adm");
	var lnk= "DHCNurEmrComm.csp?"+"&EmrCode=DHCDOCSHIFTEXCHAGEDetail"+"&EpisodeID="+Adm;
	window.open(lnk,"htm",'toolbar=no,location=no,directories=no,resizable=yes,width=900,height=600,left=50,top=90');
}