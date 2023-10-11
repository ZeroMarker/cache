var grid; 

function eachItem1(item,index,length) {   
    if (item.xtype=="datefield") {   
            //修改下拉框的请求地址    
			ret=ret+item.id+"|"+formatDate(item.getValue())+"^";   
	    } 
    if (item.xtype=="timefield") {   
            //修改下拉框的请求地址    
			//debugger;
			ret=  ret+item.id+"|"+item.getValue()+"^";   
      } 
	 if (item.xtype=="combo") {   
            //修改下拉框的请求地址    
			//debugger;
			comboret=  comboret+item.id+"|"+item.getValue()+"!"+item.lastSelectionText+"^";   
      } 
	 if (item.xtype=="textfield") {   
            //修改下拉框的请求地址    
			//debugger;
			ret=  ret+item.id+"|"+item.getValue()+"^";   
      } 
	 if (item.xtype=="textarea") {   
            //修改下拉框的请求地址    
			ret=  ret+item.id+"|"+item.getRawValue()+"^";   
    }
     
	 if (item.xtype=="checkbox") {   
            //修改下拉框的请求地址    
			//debugger;
			if (item.checked==true) checkret=checkret+item.id+"|"+item.boxLabel+"^";
			else {checkret=checkret+item.id+"|"+""+"^";}   
     } 
	  
    if (item.items && item.items.getCount() > 0) {   
       item.items.each(eachItem1, this);   
    }   
} 



function rightClickFn(client, rowIndex, e)  {
          e.preventDefault();
          grid=client;
		  CurrRowIndex=rowIndex;
          rightClick.showAt(e.getXY());
            } 
             
function save()
{
	var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var list = [];
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len==0)
	{
		alert("未选中要保存的记录!");
		return;
	}
	for (var r = 0;r < len; r++) {
		list.push(rowObj[r].data);
	}		
	var grid1=Ext.getCmp('mygrid');
	var rwIndex=grid1.getSelectionModel().last;
	//for (var i = 0; i < store.getCount(); i++) {
	//	list.push(store.getAt(i).data);
	//	//	debugger;
	//}
	var RecSave=document.getElementById('RecSave');
	for (var i = 0; i < list.length; i++) {
	  var obj=list[i];
	  var str="";
	  var CareDate="";
	  var CareTime="";
	  var flag="0";
		for (var p in obj) {
			var aa = formatDate(obj[p]);				
			if (p=="CareDate") CareDate=aa;
			if (p=='CareTime') CareTime=obj[p];
			if (p=="") continue;
			if (aa == "") 
			{
					str = str + p + "|" + DBC2SBC(obj[p]) + '^';
			}else
			{
			  	str = str + p + "|" + aa + '^';	
			}
		}
		if ((str!="")&&(flag=="0"))
		{
			if (str.indexOf("CareDate")==-1)
			{
				str=str+"CareDate|"+CareDate+"^CareTime|"+CareTime;
				//debugger;
			}
			//str=str+"DiagnosDr|"+DiagnosDr;
			//str=str+"^"+CaseMeasureID;
			//alert(str);
			var a=cspRunServerMethod(RecSave.value,EpisodeID,str,session['LOGON.USERID'],"DHCNURANHUI22",session['LOGON.GROUPDESC']);
			if (a!="0")
			{
				alert(a);
				return;
			}
		}
	}
	find();
	window.parent.reloadtree2(EmrCode,"表格");
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


function BodyLoadHandler(){ 
  setsize("mygridpl","gform","mygrid");
  var but1=Ext.getCmp("mygridbut1");
	but1.on('click',additm);
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
				//debugger;
        if (C == E.RIGHT) {
        // alert();
        E.stopEvent();
        B.completeEdit();
        G = D.walkCells(B.row,B.col+1, 1, this.acceptsNav,this);
        }       
        if (C == E.LEFT) {
        // alert();
        E.stopEvent();
        B.completeEdit();
        G = D.walkCells(B.row,B.col-1, 1, this.acceptsNav,this);
        }
       if (C == E.DOWN) {
       // alert();
       E.stopEvent();
       B.completeEdit();
       G = D.walkCells(B.row+1,4, 1, this.acceptsNav,this);
       }      
       if (C == E.UP) {
       // alert();
       E.stopEvent();
       B.completeEdit();
       G = D.walkCells(B.row-1,4, 1, this.acceptsNav,this);
       }        
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
						
						var mygrid = Ext.getCmp('mygrid'); 
            var selModel = mygrid.getSelectionModel(); 
            var rowIndex = mygrid.store.indexOf(mygrid.getSelectionModel().getSelected());
            //var colname = mygrid.getColumnModel().getDataIndex(colIndex);   
            var celldata = grid.getStore().getAt(rowIndex).get("User"); //获取数据 
            var celldata1 = grid.getStore().getAt(rowIndex).get("Item11");
            var objGetUser=document.getElementById('GetUser'); 
            if (objGetUser) {
						 if (celldata!="")
						 {
						 	var a = cspRunServerMethod(objGetUser.value, celldata); 
						  mygrid.store.getAt(rowIndex).set(mygrid.getColumnModel().getDataIndex(11),a);
            }
              if (celldata1!="")
						 { 
             var a = cspRunServerMethod(objGetUser.value, celldata1); 
						 mygrid.store.getAt(rowIndex).set(mygrid.getColumnModel().getDataIndex(12),a);
            }
          }
            						
						//alert("cc");					
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
  	grid=Ext.getCmp('mygrid');
  	grid.setTitle(gethead());
  	var mydate=new Date();
  	var tobar=grid.getTopToolbar(); 
  	tobar.addItem(
            "-");   
    tobar.addButton(
	  {
		className: 'new-topic-button',
		text: "全部保存",
		handler:AllSave,
		id:'mygridbutAllSave'
	  } 
	);	
	tobar.addItem(
	    {
			xtype:'datefield',
			//format: 'Y-m-d',
			id:'mygridstdate',
			value:(diffDate(new Date(),-9))
		},
	    {
			xtype:'timefield',
			width:100,
			format: 'H:i',
			value:'0:00',
			id:'mygridsttime'
		},
	    {
			xtype:'datefield',
			//format: 'Y-m-d',
			id:'mygridenddate',
			value:diffDate(new Date(),1)
		},
	    {
			xtype:'timefield',
			width:100,
			id:'mygridendtime',
			format: 'H:i',
			value:'0:00'
		}
	); 
	tobar.addItem ("-",{
			xtype:'checkbox',
			id:'IfCancelRec',
			checked:false,
			boxLabel:'显示作废记录' 		
	});
	tobar.addItem(
            "-");  	
	tobar.addButton(
	  {
		className: 'new-topic-button',
		text: "查询",
		handler:find,
		id:'mygridSch'
	  }

	); 
   tobar.addItem(
            "-"); 
 tobar.addButton(
		  {
			//className: 'new-topic-button',
			text: "打印",
			handler:function(){printNurCareRec("DHCNurPrnMouldANHUI22Grid")},
			id:'PrintBut'
		  }
	  );
	

 	//tobar.addButton(
	//	  {
	//		//className: 'new-topic-button',
	//		text: "续打印设置",
	//		handler:PrintSet,
	//		id:'XPrintSet'
	//	  }
	//  );
    var bbar = grid.getBottomToolbar ();
	bbar.hide();
	var bbar2 = new Ext.PagingToolbar({
	    pageSize:15,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(grid.bbar);
    tobar.doLayout(); 
	grid = Ext.getCmp('mygrid');
	grid.addListener('rowcontextmenu', rightClickFn);
  grid.on('beforeedit', beforeEditFn);
  grid.addListener('afteredit',cellclick,this);  
   
  find(); 
}

function diffDate(val,addday){
	var year=val.getFullYear();
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
function printNurRec()
{
		var GetPrnSet=document.getElementById('GetPrnSet');
		var GetHead=document.getElementById('GetPatInfo');
		var ret=cspRunServerMethod(GetHead.value,EpisodeID);
		var hh=ret.split("^");
		//alert("ddd");
		//debugger;
		var a=cspRunServerMethod(GetPrnSet.value,"DHCNURANHUI22",EpisodeID); //page, caredattim, prnpos, adm,Typ,user
		if (a=="") return;
		var GetLableRec=document.getElementById('GetLableRec');
		var LabHead=cspRunServerMethod(GetLableRec.value,"DHCNURANHUI22^"+session['LOGON.CTLOCID']);
		var tm=a.split("^");
		var stdate="" //tm[2];
		var stim="" //tm[3];
		var edate="" //tm[4];
		var etim="" //tm[5];
		//PrintComm.RHeadCaption=hh[1];
		//PrintComm.LHeadCaption=hh[0];
		//PrintComm.RFootCaption="第";
		//PrintComm.LFootCaption="页";
		//PrintComm.LFootCaption=hh[2];
		PrintComm.TitleStr=ret;
		PrintComm.SetPreView("1");
		PrintComm.PrnLoc=session['LOGON.CTLOCID'];
		var aa=tm[1].split("&");
		//PrintComm.stPage=aa[0];
		//if (aa.length>1) PrintComm.stRow=aa[1];
		PrintComm.stPage=0;
		PrintComm.stRow=0;
		PrintComm.previewPrint="1"; //是否弹出设置界面
		//PrintComm.stprintpos=tm[0];
		PrintComm.stprintpos=0;
		//alert(PrintComm.Pages);
		PrintComm.SetConnectStr(CacheDB); 
		PrintComm.WebUrl=webIP+"/dthealth/web/DWR.DoctorRound.cls";
		PrintComm.ItmName = "DHCNurPrnMouldANHUI22Grid"; //338155!2010-07-13!0:00!!
		//debugger;
		var parr=EpisodeID+"!"+stdate+"!"+stim+"!"+edate+"!"+etim+"!DHCNURANHUI22";
		PrintComm.ID = "";
		PrintComm.MultID = "";
		//PrintComm.MthArr="web.DHCConsult:getConsultInfo&id:"+myid;
		if(LabHead!="")PrintComm.LabHead=LabHead; 
		//alert(parr);
		PrintComm.SetParrm(parr); // ="EpisodeId" ; //"p1:0^p2:"
		PrintComm.PrintOut();
		
}
  
function Enetrkeydown(obj)
{ 
	//alert("bb");
}

var rightClick = new Ext.menu.Menu(  {
            id : 'rightClickCont',
            items : [ {
                id:'rMenu7',
                text : '作废',
                handler:CancelRecord
            }]
        });


function AllSave()
{
  var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var list = [];
	var rowObj = grid.getSelectionModel().getSelections();
		var len = rowObj.length;
	//	for (var r = 0;r < len; r++) {
	//	list.push(rowObj[r].data);
	//}		
	var grid1=Ext.getCmp('mygrid');
	var rwIndex=grid1.getSelectionModel().last;
	//debugger;
	for (var i = 0; i < store.getCount(); i++) {
		list.push(store.getAt(i).data);
	//	//	debugger;
	}
	var RecSave=document.getElementById('RecSave');
	for (var i = 0; i < list.length; i++) {
	  var obj=list[i];
	  var str="";
	  var CareDate="";
	  var CareTime="";
	  var flag="0";
		for (var p in obj) {
			var aa = formatDate(obj[p]);				
			if (p=="CareDate") CareDate=aa;
			if (p=='CareTime') CareTime=obj[p];
			if (p=="") continue;
		  if (aa == "") 
			{
					str = str + p + "|" + DBC2SBC(obj[p]) + '^';
			}else
			{
			  	str = str + p + "|" + aa + '^';	
			}
		}
		if ((str!="")&&(flag=="0"))
		{
			if (str.indexOf("CareDate")==-1)
			{
				str=str+"CareDate|"+CareDate+"^CareTime|"+CareTime;
				//debugger;
			}
		}
			//alert(str);
			var a=cspRunServerMethod(RecSave.value,EpisodeID,str,session['LOGON.USERID'],"DHCNURANHUI22",session['LOGON.GROUPDESC']);
			if (a!="0")
			{
				alert(a);
				return;
			}
		}
	find();
	window.parent.reloadtree2(EmrCode,"表格");
 
}

//作废
function CancelRecord()
{
	var objCancelRecord=document.getElementById('CancelRecord');
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) 
	{
		alert("请先选择一条护理记录!");
		return;
	} else 
	{
		var flag = confirm("你确定要作废此条记录吗!")
		if (flag) 
		{
			var par=objRow[0].get("par");
					var rw=objRow[0].get("rw");
					//alert(par+","+rw+","+session['LOGON.USERID']+","+session['LOGON.GROUPDESC']);
					if (objCancelRecord) {
						var a = cspRunServerMethod(objCancelRecord.value, par, rw, session['LOGON.USERID'], session['LOGON.GROUPDESC']);
						if (a!=0){
							alert(a);
							return;
						}else{
							find();
						}
					}
		}
	}
}
var selectedindex="" //选中行
function beforeEditFn(e){
	grid.rowIndex = e.row;   //得到当前的行
	grid.columnIndex = e.column;	//得到当前的列
	var mygrid = Ext.getCmp('mygrid'); 
	selectedindex=mygrid.getSelectionModel().getSelected()
}

function cellclick(obj)
{
    
   var r=obj.record; 
   var sum=0;
   var mygrid = Ext.getCmp('mygrid'); 
   var selModel = mygrid.getSelectionModel(); 
   var rowIndex = mygrid.store.indexOf(selectedindex);
   //alert(rowIndex)
   for (colIndex = 2; colIndex < 9; colIndex++) 
    {
      var colname = mygrid.getColumnModel().getDataIndex(colIndex);   
      var celldata = grid.getStore().getAt(rowIndex).get(colname); //获取数据 
      if (celldata==undefined) celldata =0;
	  if (celldata=="") celldata =0;
	  //alert(celldata)
      sum=sum+ parseInt(celldata);     
      //alert(colname+"="+celldata);    
    } 
    mygrid.store.getAt(rowIndex).set(mygrid.getColumnModel().getDataIndex(9),sum);

    //var cell = grid.getSelectionNode().getSelectedCell();
    //得到的cell记录了当前选择的行(cell[0])以及列(cell[1]).可以通过一下语句得到该单元格数据
 
    //Js代码
    //var colname = grid.getColumnModel().getDataIndex(cell[1]); //获取列名 
    //var celldata = grid.getStore().getAt(cell[0]).get(colname); //获取数据
}  

function scoreAdd(obj)
{ 
   //	 alert("11");	 
	 var scorehj=0;
	 var tmp=obj.getValue();	
	 if (isNaN(tmp))
	  {
			alert("评分请录入数字!"); 
			obj.setValue("");
			return;
	  }
	 if ((parseInt(tmp)>4)||(parseInt(tmp)<0))	 
	 {
			alert("评分数值小于4大于0!"); 
			obj.setValue("");
			return;
	 }    
	 switch (obj.getName()) 
	 { 
     case 'Item1': 
           scorehj=parseInt(tmp)+parseInt(Ext.getCmp("Item2").getValue())+parseInt(Ext.getCmp("Item3").getValue())+parseInt(Ext.getCmp("Item4").getValue())+parseInt(Ext.getCmp("Item5").getValue())+parseInt(Ext.getCmp("Item6").getValue())+parseInt(Ext.getCmp("Item7").getValue());
           break;
     case 'Item2':
           scorehj=parseInt(tmp)+parseInt(Ext.getCmp("Item1").getValue())+parseInt(Ext.getCmp("Item3").getValue())+parseInt(Ext.getCmp("Item4").getValue())+parseInt(Ext.getCmp("Item5").getValue())+parseInt(Ext.getCmp("Item6").getValue())+parseInt(Ext.getCmp("Item7").getValue());
           break;     
      case 'Item3':
           scorehj=parseInt(tmp)+parseInt(Ext.getCmp("Item1").getValue())+parseInt(Ext.getCmp("Item2").getValue())+parseInt(Ext.getCmp("Item4").getValue())+parseInt(Ext.getCmp("Item5").getValue())+parseInt(Ext.getCmp("Item6").getValue())+parseInt(Ext.getCmp("Item7").getValue());
           break;     
      case 'Item4':    
           scorehj=parseInt(tmp)+parseInt(Ext.getCmp("Item1").getValue())+parseInt(Ext.getCmp("Item2").getValue())+parseInt(Ext.getCmp("Item3").getValue())+parseInt(Ext.getCmp("Item5").getValue())+parseInt(Ext.getCmp("Item6").getValue())+parseInt(Ext.getCmp("Item7").getValue());
           break;  
      case 'Item5':    
           scorehj=parseInt(tmp)+parseInt(Ext.getCmp("Item1").getValue())+parseInt(Ext.getCmp("Item2").getValue())+parseInt(Ext.getCmp("Item3").getValue())+parseInt(Ext.getCmp("Item4").getValue())+parseInt(Ext.getCmp("Item6").getValue())+parseInt(Ext.getCmp("Item7").getValue());
           break; 
      case 'Item6': 
           scorehj=parseInt(tmp)+parseInt(Ext.getCmp("Item1").getValue())+parseInt(Ext.getCmp("Item2").getValue())+parseInt(Ext.getCmp("Item3").getValue())+parseInt(Ext.getCmp("Item4").getValue())+parseInt(Ext.getCmp("Item5").getValue())+parseInt(Ext.getCmp("Item7").getValue()); 
           break;
      case 'Item7':
           scorehj=parseInt(tmp)+parseInt(Ext.getCmp("Item1").getValue())+parseInt(Ext.getCmp("Item2").getValue())+parseInt(Ext.getCmp("Item3").getValue())+parseInt(Ext.getCmp("Item4").getValue())+parseInt(Ext.getCmp("Item5").getValue())+parseInt(Ext.getCmp("Item6").getValue()); 
           break;    
    }
   var amtsum = Ext.getCmp("Item8"); 
	 //tmp=parseInt(tmp)+parseInt(amtsum.getValue())	 
	 amtsum.setValue(scorehj);
}


function AddRec(str)
{
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	obj.CareDate=getDate(obj.CareDate);
	//obj.PregHPregDate=getDate(obj.PregHPregDate);
	REC.push(obj);
	//debugger;
}



function find(){ 
	MeasureRel = new Hashtable();
  REC = new Array();
	var adm = EpisodeID;
	var StDate = Ext.getCmp("mygridstdate");
	var StTime = Ext.getCmp("mygridsttime");
	var Enddate = Ext.getCmp("mygridenddate");
	var EndTime = Ext.getCmp("mygridendtime");
	var GetQueryData = document.getElementById('GetQueryData');
	var mygrid = Ext.getCmp("mygrid");
	var IfCancelRec=Ext.getCmp("IfCancelRec").getValue();
	var parr = adm + "^" + StDate.value + "^" + StTime.value + "^" + Enddate.value + "^" + EndTime.value + "^"+"DHCNURANHUI22" + "^" + IfCancelRec;
	//alert(parr);
	// debugger;
	//var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurRecComm:GetCareRecComm", "parr$" + parr, "AddRec");
   // mygrid.store.loadData(REC);
    mygrid.store.on("beforeLoad",function(){   
       mygrid.store.baseParams.parr=parr;    //传参数，根据原来的方式修改
    });    
    mygrid.getStore().addListener('load',handleGridLoadEvent); //护理记录表格需要：日期转换及出入量统计行加颜色
    mygrid.store.load({
    	params:{
    		start:0,
    		limit:15
    	}	
   })
}
var prncode=""
//加颜色
 function handleGridLoadEvent(store,records)
  {
	var grid=Ext.getCmp('mygrid');
	var gridcount=0;
  
    var StDate = Ext.getCmp("mygridstdate");
	var StTime = Ext.getCmp("mygridsttime");
	var Enddate = Ext.getCmp("mygridenddate");
	var EndTime = Ext.getCmp("mygridendtime");
	var mygrid = Ext.getCmp("mygrid");
	var params=EpisodeID+"&"+prncode+"&"+ StDate.value + "&" + StTime.value.replace(":","*") + "&" + Enddate.value + "&" + EndTime.value.replace(":","*")
	printinfo=tkMakeServerCall("Nur.DHCNurRecPrint","getprintinfo",params)
    printarr=printinfo.split('&')
    //alert(printarr)
    printinfoST=tkMakeServerCall("Nur.DHCNurRecPrintStPos","getval",EpisodeID+"&"+prncode+"&")
    printarrST=printinfoST.split('^')
    // alert(printarrST)
	  store.each(function(r){	            
                 var rowid=r.get("par")+"||"+r.get("rw")  
             if(r.get('CareDate')!="") //日期格式转换
			 {
			   var date=getDate(r.get('CareDate'));
			   grid.store.getAt(gridcount).set("CareDate",date);			
		    }		
			store.commitChanges()	
                 if (printinfoST!="")
                 {    
                    //alert(printinfoST[0]) 
                    //alert(rowid) 
                    if (rowid!=printarrST[0])   
                    {                            
                      if (printarr[0].indexOf(rowid)>-1) //该条记录已打印
                      {                    
                         grid.getView().getRow(gridcount).style.backgroundColor=printcolor;                      
                      }
                      if (printarr[1].indexOf(rowid)>-1) //该条记录未打印
                      {
                         grid.getView().getRow(gridcount).style.backgroundColor=noprintcolor;
                      }
                      if (printarr[2].indexOf(rowid)>-1) //该条记录有修改
                      {
                         grid.getView().getRow(gridcount).style.backgroundColor=havechangecolor;
                      }   
                    }
                    else  //打印记录索引行
                    {          
                      //alert(printarrST[3])                          
                      var pinfo=tkMakeServerCall("Nur.DHCNurRecPrint","getval",r.get("par")+"&"+r.get("rw")  )   
                      var pprr=pinfo.split('^')   
                     // alert(pprr)                 
                      if (printarrST[3]=="0")
                      {                        
                         grid.getView().getRow(gridcount).style.backgroundColor=Startcolor;
                      }  
                      else if (pprr[4]=="2") //该条有修改
                      {
                      
                         grid.getView().getRow(gridcount).style.backgroundColor=havechangecolor; 
                      }
                      else
                      {
                        grid.getView().getRow(gridcount).style.backgroundColor=printcolor; 
                      }
                    }               
                  }                    
                   gridcount=gridcount+1;           
                 });
 
	
}
function gethead()
{
	var GetHead=document.getElementById('GetHead');
	var ret=cspRunServerMethod(GetHead.value,EpisodeID);
	var hh=ret.split("^");
	return hh[0]+"  "+hh[1];
	//debugger;
}


function additm()
{ 
  var Plant = Ext.data.Record.create([
	{name:'CareDate'}, 
	{name:'CareTime'},
	{name:'Item1'},
	{name:'Item2'},
	{name:'Item3'},
	{name:'Item4'},
	{name:'Item5'},
	{name:'Item6'},
	{name:'Item7'},
	{name:'Item8'},
	{name:'Item9'}, 
	{name:'Item10'},
	{name:'Item11'},
	{name:'Item12'},
	{name:'Item13'},
	{name:'Item14'},
	{name:'Item15'},
	{name:'Item16'},
	{name:'Item17'}, 
	{name:'Item18'},
	{name:'Item19'}, 
	{name:'Item20'},
	{name:'Item21'},
	{name:'Item22'},
	{name:'Item23'},
	{name:'Item24'},
	{name:'Item25'},
	{name:'Item26'},
	{name:'Item27'},
	{name:'Item28'},
	{name:'Item29'},
	{name:'Item30'},
	{name:'Item31'},
	{name:'Item32'},
	{name:'Item33'},
	{name:'Item34'},
	{name:'Item35'},
	{name:'Item36'},
	{name:'Item37'},
	{name:'Item38'},
	{name:'Item39'},
	{name:'Item40'},
	{name:'Item41'},
	{name:'Item42'},
	{name:'Item43'},
	{name:'Item44'},
	{name:'Item45'},
	{name:'Item46'},
	{name:'Item47'}, 
	{name:'Item48'},
	{name:'Item49'},
	{name:'Item50'},
	{name:'CaseMeasure'},
	{name:'User'},
	{name:'rw'},
	{name:'par'}
      ]);
    var count = grid.store.getCount(); 
    var r = new Plant({CareDate:new Date(),CareTime:new Date().dateFormat('H:i')}); 
    grid.store.commitChanges(); 
    grid.store.insert(0,r); 
	return;
}
