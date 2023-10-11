/**
 * @表格类护理记录
 * @author Administrator
 * @2015-11-11
 * @如果查询一直转圈请在界面模板的T元素的关联公式上加上：web.DHCNurRecComm:GetCareRecComm.RecQuery:parr，然后重新生成js
 */
/*
*/
var DHCNurCheckRecT102=new Ext.data.JsonStore({data:[],fields:['OrdDate','OrdTime','ARCIMDesc','DateEx','TimeEx','CPTEx','ArcimDR','ORW']});
var DHCNurLabRecT103=new Ext.data.JsonStore({data:[],fields:['StDateTime','ARCIMDes','LabEpisodeNo','testcode','LabDate','LabTime','LabCpt','RowId']});
var DHCPatOrdListT103=new Ext.data.JsonStore({data:[],fields:['OrdDate','OrdTime','ARCIMDesc','PriorDes','Meth','PHFreq','Dose','DoseUnit','OrdStat','Doctor','Oew','OrdSub','Sel','SeqNo']});
var DHCNurRelDiagnosT101=new Ext.data.JsonStore({data:[],fields:['DiagNos','RecUser','RecDate','RecTime','rw']});
//var DHCPatOrdListT103=new Ext.data.JsonStore({data:[],fields:['OrdDate','OrdTime','ARCIMDesc','PriorDes','Meth','PHFreq','Dose','DoseUnit','OrdStat','Doctor','Oew','OrdSub','SeqNo']});
var DHCPatOrdListT103=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'OrdDate','mapping':'OrdDate'},{'name':'OrdTime','mapping':'OrdTime'},{'name':'ARCIMDesc','mapping':'ARCIMDesc'},{'name':'PriorDes','mapping':'PriorDes'},{'name':'Meth','mapping':'Meth'},{'name':'PHFreq','mapping':'PHFreq'},{'name':'Dose','mapping':'Dose'},{'name':'DoseUnit','mapping':'DoseUnit'},{'name':'OrdStat','mapping':'OrdStat'},{'name':'Doctor','mapping':'Doctor'},{'name':'Oew','mapping':'Oew'},{'name':'OrdSub','mapping':'OrdSub'},{'name':'SeqNo','mapping':'SeqNo'}]}),baseParams:{className:'web.DHCNUREMR',methodName:'GetPatOrd',type:'Query'}});
var SumInName="";
var SumOutName="";
var SumOutAmount="";
var PartInName="";
var PartInAmount="";
var PartOutName="";
var PartOutAmount="";
var DisplaySumInName="";
var DisplaySumInAmount="";
var DisplaySumOutName="";
var DisplaySumOutAmount="";
var CaseMeasureID=""; //邦定的处置ID
var OrdInName="";
var OrdInAmount="";
var ICountCls="";
var OCountCls="";
var MeasureRel = new Hashtable();
var GetNurseRecSet=document.getElementById('GetNurseRecSet');
if (GetNurseRecSet){
	var ret=cspRunServerMethod(GetNurseRecSet.value,EmrCode);
	var hh=ret.split("^");
	
	SumInName=hh[0].split("&")[0];
	SumInAmount=hh[0].split("&")[1];
	SumOutName=hh[1].split("&")[0];
	SumOutAmount=hh[1].split("&")[1];
	PartInName=hh[2].split("&")[0];
	PartInAmount=hh[2].split("&")[1];
	PartOutName=hh[3].split("&")[0];
	PartOutAmount=hh[3].split("&")[1];
	DisplaySumInName=hh[7].split("&")[0];
	DisplaySumInAmount=hh[7].split("&")[1];
	DisplaySumOutName=hh[8].split("&")[0];
	DisplaySumOutAmount=hh[8].split("&")[1];
	OrdInName=hh[11].split("&")[0];;
    OrdInAmount=hh[11].split("&")[1];;
    if(OrdInName=="")
    {
     	OrdInName=SumInName;
    }
    if (OrdInAmount=="")
    {
    	OrdInAmount=SumInAmount
    }
    if (OrdInName=="")
    {
    	OrdInName="CaseMeasure"
    }
							  
    //alert(OrdInName)
	//debugger;
}
var UserType="";
var GetUserType=document.getElementById('GetUserType');
if (GetUserType){
	UserType=cspRunServerMethod(GetUserType.value,session['LOGON.USERID']);
}
var grid;
var DiagnosDr="";
function gethead()
{
	var GetHead=document.getElementById('GetHead');
	var ret=cspRunServerMethod(GetHead.value,EpisodeID);
	var hh=ret.split("^");
	return hh[0]+"  "+hh[1] +" ----注意:根据护理部要求，只能修改本人签名的记录！";
}
  var StartLock="0" //续打全院开关：1:启用续打，0:不启用续打
  var IfMakePic=""  //是否生成图片
  var WillUpload=""   //是否上传ftp
  var ShowTJ="N"     //是否显示统计
  var ShowMakeHJ="N" //是否显示生成痕迹
  var prnmode=tkMakeServerCall("User.DHCNURMoudelLink","getPrintCode",EmrCode) //根据界面模板获取打印模板
  var prnmcodes=""
  if (prnmode!="")
  {
    var prnarr=prnmode.split('|')
    prnmcodes=prnarr[0]
    IfMakePic=prnarr[3]  //是否生成图片
    WillUpload=prnarr[4]   //是否上传ftp
    //alert(WillUpload)
    if (prnarr[2]=="Y") //启用续打
    {
      StartLock="1"
    }
    else
    {
      StartLock="0"
    }
  }
  if ((StartLock=="1")&&(prnmode==""))
  {
    alert("请关联界面模板和打印模板!")
    StartLock="0" //关闭续打
  }
  var printcolor='#C9C9C9';     //已打印颜色
  var havechangecolor='#FF8247' //有修改颜色
  var noprintcolor='#FFFFF0';   //未打印颜色
  var Startcolor='#1E90FF';     //从该条开始打印的颜色
  var prncode=prnmcodes //打印模板名称
  var Startloc="" //启用续打的科室科室（前提必须是StartLock=1）
  if (prncode=="")
  {
  	//prncode="DHCNurPrnMouldANHUI3"
  }
  //入口
 function BodyLoadHandler(){
	setsize("mygridpl","gform","mygrid");
	var but1=Ext.getCmp("mygridbut1");
	but1.on('click',additm);
	var but=Ext.getCmp("mygridbut2");
	but.setText("保存");
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
  	grid=Ext.getCmp('mygrid');
  	grid.on('rowdblclick',RecMeasureNew);
  	grid.setTitle(gethead());
  	var mydate=new Date();
  	var tobar=grid.getTopToolbar();
  	if (ShowMakeHJ=="Y")
  	{
  	    tobar.addItem ("-")
	    tobar.addItem ("-",{
			xtype:'checkbox',
			id:'hjflag',
			checked:false,
			boxLabel:'' 		
  	    });
  	    tobar.addButton(
	    {
		className: 'new-topic-button',
		text: "生成痕迹",
		handler:function(){makeRechj(prncode)},
		id:'makehj'
	    });
   }
   tobar.addButton(
	{
		className: 'new-topic-button',
		text: "全部保存",
		handler:saveall,
		icon:'../Image/icons/disk_multiple.png',
		id:'saveall'
	});
	tobar.addItem(
	    {
			xtype:'datefield',
			//format: 'Y-m-d',
			id:'mygridstdate',
			icon:'../Image/icons/date_edit.png',
			value:(diffDate(new Date(),-6))
		},
	    {
			xtype:'timefield',
			width:60,
			format: 'H:i',
			value:'0:00',
			id:'mygridsttime'
		},
	    {
			xtype:'datefield',
			//format: 'Y-m-d',
			icon:'../Image/icons/date_edit.png',
			id:'mygridenddate',
			value:diffDate(new Date(),1)
		},
	    {
			xtype:'timefield',
			width:60,
			id:'mygridendtime',
			format: 'H:i',
			value:'0:00'
		}
	);
	tobar.addButton(
	  {
		className: 'new-topic-button',
		text: "查询",
		handler:find,
		icon:'../Image/icons/magnifier.png',
		id:'mygridSch'
	  }

	);
	  tobar.addButton(
	  {
			//className: 'new-topic-button',
			text: "特殊字符",
			handler:SepcialChar,
			icon:'../Image/icons/comment_edit.png',
			id:'SepcialChar1'
		  }
	  );
	
	  tobar.addItem ("-");
	  if (StartLock=="1")
	  {
	     if ((Startloc.indexOf(session['LOGON.CTLOCID'])>-1)||(Startloc==""))
	     {
	       
	       tobar.addButton(
		     {		   
			     text: "打印",
			     handler:function(){printNurCareRecXu(prncode)},
			     icon:'../Image/icons/printer_start.png',
			     id:'PrintButxu'
		      });
		    
		      tobar.addButton(
		     {			
			     text: "全部打印",
			     handler:function(){printNurCareRec(prncode)}, //这个个调用原来的方法,在原来基础上加一句：PrintComm.Xuflag=0
			     icon:'../Image/icons/printer_mono.png',
			     id:'PrintButZK'
		     });
		     tobar.addButton(
		     {			  
			      text: "续打说明新",
			      handler:XuInt,
			      icon:'../Image/icons/page_word.png',
			      id:'XuInt'
		     });
		   }
		   else
		   {
		      tobar.addButton(
		      {
			      text: "全部打印",
			      icon:'../Image/icons/printer_mono.png',
			      handler:function(){printNurCareRec(prncode)},
			      id:'PrintButZK'
		      });
		   }
	  }
	  else
	  {
	    tobar.addButton(
		  {
			  text: "全部打印",
			  handler:function(){printNurCareRec(prncode)},
			  icon:'../Image/icons/printer.png',
			  id:'PrintButZK'
		  });
	  }
   	tobar.addItem ("-",{
			xtype:'checkbox',
			id:'IfCancelRec',
			checked:false,
			boxLabel:'显示作废记录' 		
	});
	tbar2=new Ext.Toolbar({	});	
	if (IfMakePic=="Y")
    {	   
	   tbar2.addButton(
	   {
			    text: "生成所有图片",
			   handler:function(){MakeRecPicture(prncode)},
			   icon:'../Image/icons/pictures.png',			   
			   id:'MakePicture12'
		});  
	   tbar2.render(grid.tbar);
    }
    if (ShowTJ=="Y")
    {
        addtjbut(tbar2);
        tbar2.render(grid.tbar);
    }
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
 	if (UserType=="DOCTOR")
 	{
 		if (but1) but1.hide();
 		if (but) but.hide();		
 	}
 	else
 	{
		grid.addListener('rowcontextmenu', rightClickFn);
		grid.addListener('rowclick', rowClickFn);
		grid.on('beforeedit', beforeEditFn);
 	}
grid.on('mouseover',function(e){//添加mouseover事件
	var index = grid.getView().findRowIndex(e.getTarget());//根据mouse所在的target可以取到列的位置
	if(index!==false){//当取到了正确的列时，（因为如果传入的target列没有取到的时候会返回false）
		var store = grid.getStore();
		var totalRow="";
		if (store.getCount()>0) totalRow=store.getAt(index).get(DisplaySumInName);
		if ((store.getCount()>0)||((totalRow)&&(totalRow.indexOf("入液量")==-1)))  //续打
		{
		  if ((StartLock!="1")||(prnmode==""))
		  {
		    return
		  }
		  else
		  {
		    if ((Startloc.indexOf(session['LOGON.CTLOCID'])==-1)&&(Startloc!="")) return
		  }
		  var rowid=store.getAt(index).get("par")+"||"+store.getAt(index).get("rw")
		  var rowidparr=store.getAt(index).get("par")+"&"+store.getAt(index).get("rw")
		  var STInfo=tkMakeServerCall("Nur.DHCNurRecPrintStPos","getval",EpisodeID+"&"+prncode)
      var STArr=STInfo.split('^')
      var printInfo=tkMakeServerCall("Nur.DHCNurRecPrint","getval",rowidparr)
      var printedarr=printInfo.split('^')
		  if (rowid==STArr[0]) //续打开始行或结束行
		  {
		     var str="<TABLE borderColor=#000000 width='100%' bgColor=#ffffff border=1 cellSpacing=0 cellPadding=0><TBODY>";
		     var text=""
		     var stp=(parseInt(STArr[1])+parseInt(1))
		     var stro=(parseInt(STArr[2])+parseInt(1))
		     var stoo=parseInt(STArr[2])-parseInt(STArr[4])
		   
		     if ((printedarr[4]=="2")&&(STArr[3]=="1"))
		     {
		       text="该条记录打印过后有修改,该记录从第："+stoo+"页,第:"+STArr[2]+"行开始打印,一页可打印:"+STArr[5]+"行"
		     }
		     else if (STArr[3]=="1") //已打印
		     {		            
		       text="该条记录从第:"+stp+"页,第:"+stoo+"行开始打印到第:"+STArr[2]+"行,占用:"+STArr[4]+"行,一页可打印:"+STArr[5]+"行"
		     }
		     else 
		     {
		        text="补打开始位置--该条记录从第:"+stp+"页,第:"+stro+"行开始打印,一页可打印:"+STArr[5]+"行"
		     }
			   str=str+"<TR bgColor=#D2E9FF><TD>打印信息</TD></TR>";
			   str=str+"<TR><TD>"+text+"</TD></TR>";
			   str=str+"</TBODY></TABLE>";
			   var rowEl = Ext.get(e.getTarget());//把target转换成Ext.Element对象
			   rowEl.set({
				    'ext:qtip':str  //设置它的tip属性
			       },false);
		  }
		  else if (printInfo!="")
		  {
		     var str="<TABLE borderColor=#000000 width='100%' bgColor=#ffffff border=1 cellSpacing=0 cellPadding=0><TBODY>";
		     var text=""
		     var stpage=parseInt(printedarr[1])+parseInt(1)
		     var strow =parseInt(printedarr[2])+parseInt(1)
		     var edrow =parseInt(printedarr[2])+parseInt(printedarr[3])
		     var rowh=parseInt(printedarr[3])
		     if (printedarr[4]=="1") //已打印
		     {
		        text="该条记录从第:"+stpage+"页,第:"+strow+"行开始打印到第:"+edrow+"行,占用:"+rowh+"行,一页可打印:"+printedarr[5]+"行"
		     }
		     if (printedarr[4]=="0") //未打印
		     {
		        text="该条记录未打印"
		     }
		     if (printedarr[4]=="2") //有修改
		     {
		        text="该条记录打印过后有修改,该记录从第："+stpage+"页,第:"+strow+"行开始打印,一页可打印:"+printedarr[5]+"行"
		     }
			   str=str+"<TR bgColor=#D2E9FF><TD>打印信息</TD></TR>";
			   str=str+"<TR><TD>"+text+"</TD></TR>";
			   str=str+"</TBODY></TABLE>";
			   var rowEl = Ext.get(e.getTarget());//把target转换成Ext.Element对象
			   rowEl.set({
				    'ext:qtip':str  //设置它的tip属性
			       },false);
		  
		  }
		}
		if ((totalRow)&&(totalRow.indexOf("入液量")>-1))
		{
			//var record = store.getAt(index);//把这列的record取出来
			//var str = Ext.encode(record.data);//组装一个字符串，这个需要你自己来完成，这儿我把他序列化
			var par=store.getAt(index).get("par");
			var rw=store.getAt(index).get("rw");
			var totalRow1,totalRow2,totalRow3,totalRow4;
			if ((par)&&(rw))
			{
				var GetSubInOut=document.getElementById('GetSubInOut');
				if (GetSubInOut)
				{
					var ret=cspRunServerMethod(GetSubInOut.value,par+"^"+rw);
					var retArr=ret.split("@");
					totalRow1=retArr[0];
					totalRow2=retArr[1];
					totalRow3=retArr[2];
					totalRow4=retArr[3];
				}	 	
			}
			else
			{
				totalRow1=store.getAt(index).get(PartInName);
				totalRow2=store.getAt(index).get(PartInAmount);
				totalRow3=store.getAt(index).get(PartOutName);
				totalRow4=store.getAt(index).get(PartOutAmount);
			}
			//var str="<p>"+totalRow1+"</p><p>"+totalRow2+"</p><p>"+totalRow3+"</p><p>"+totalRow4+"</p>";
			var str="<TABLE borderColor=#000000 width='100%' bgColor=#ffffff border=1 cellSpacing=0 cellPadding=0><TBODY>";
			str=str+"<TR bgColor=#D2E9FF><TD></TD><TD>名称</TD><TD>量</TD></TR>";
			var totalRow2Arr=totalRow2.split(";");
			str=str+"<TR><TD bgColor=#D2E9FF rowSpan="+(totalRow2Arr.length-1)+">入液量分项</TD><TD>"+totalRow2Arr[0].replace(":","</TD><TD>")+"</TD></TR>";
			for (var i=1;i<(totalRow2Arr.length-1);i++)
			{
				str=str+"<TR><TD>"+totalRow2Arr[i].replace(":","</TD><TD>")+"</TD></TR>";
			}
			var totalRow4Arr=totalRow4.split(";");
			str=str+"<TR><TD bgColor=#D2E9FF rowSpan="+(totalRow4Arr.length-1)+">出液量分项</TD><TD>"+totalRow4Arr[0].replace(":","</TD><TD>")+"</TD></TR>";
			for (var i=1;i<(totalRow4Arr.length-1);i++)
			{
				str=str+"<TR><TD>"+totalRow4Arr[i].replace(":","</TD><TD>")+"</TD></TR>";
			}
			str=str+"</TBODY></TABLE>";
			var rowEl = Ext.get(e.getTarget());//把target转换成Ext.Element对象
			rowEl.set({
				'ext:qtip':str  //设置它的tip属性
			},false);
	  }
	}
});
Ext.QuickTips.init();//注意，提示初始化必须要有
setTimeout("find()",0)
setcolor(grid);
}

function addtjbut(tobar)
{
    tobar.addItem("-"); 
    tobar.addButton(
		  {
			//className: 'new-topic-button',
			text: "24h统计",
			handler:InOutSumAll,
			icon:'../Image/icons/chart_curve_add.png',
			id:'mygridStat'
		  }
	  );
	   tobar.addItem("-"); 
    tobar.addButton(
		  {
			//className: 'new-topic-button',
			text: "日间小结",
			icon:'../Image/icons/chart_line.png',
			handler:InOutSumNod,
			id:'mygridStat2'
		  }
	  );
	   tobar.addItem("-"); 
    tobar.addButton(
		  {
			//className: 'new-topic-button',
			text: "按时间段统计",
			handler:InOutSumSeg,
			icon:'../Image/icons/chart_bar.png',
			id:'mygridStat3'
		  }
	  );
}

//日间小结
var Timepoint24 = "06:00" ;//24h统计时间点
var Timepoint12 = "18:00" ;//日间小结时间点
var CurrHeadDr=""; //表头
function InOutSumNod()
{	
	//var adm=EpisodeID;
	var StDate=diffDate(new Date(),0)	
	var StTime2 = Timepoint24
	var Enddate = diffDate(new Date(),0)
	var EndTime2 = Timepoint12
	//alert(Timepoint24)
  var aa=tkMakeServerCall("NurEmr.webheadchange","GetInOutAmountCommAndInsert","Nod",EpisodeID,StDate,StTime2,Enddate,EndTime2,EmrCode,session['LOGON.USERID'],session['LOGON.CTLOCID'],CurrHeadDr,"true")
  find()
}
//按时间段统计
function InOutSumSeg()
{	
	//var adm=EpisodeID;
	var StDate= Ext.getCmp("mygridstdate").value;
	var StTime= Ext.getCmp("mygridsttime").value;
	var Enddate= Ext.getCmp("mygridenddate").value;
	var EndTime= Ext.getCmp("mygridendtime").value;
	//alert(Timepoint24)
    var aa=tkMakeServerCall("NurEmr.webheadchange","GetInOutAmountCommAndInsert","Nod",EpisodeID,StDate,StTime,Enddate,EndTime,EmrCode,session['LOGON.USERID'],session['LOGON.CTLOCID'],CurrHeadDr,"true")
    find()
}
//24h统计
function InOutSumAll()
{	
	var adm=EpisodeID;
	var StDate=diffDate(new Date(),-1)	
	var StTime= Timepoint24;
	var Enddate= diffDate(new Date(),0)
	var EndTime= Timepoint24;
    var aa=tkMakeServerCall("NurEmr.webheadchange","GetInOutAmountCommAndInsert","Sum",EpisodeID,StDate,StTime,Enddate,EndTime,EmrCode,session['LOGON.USERID'],session['LOGON.CTLOCID'],CurrHeadDr,"true")
    var flag=tkMakeServerCall("NurEmr.webheadchange","ifexistinoutnew",EpisodeID,Enddate,EndTime,aa);  
    find();
    return; 
 // alert(flag)   
       if (flag!="")
       {   var alertstr="体温单中"+EndTime+"点以下项目值有修改："+flag+"你确定要更新这些值吗"
          var flagaut = confirm(alertstr)
		  if (flagaut) 
		  {
		  	 var id=tkMakeServerCall("NurEmr.webheadchange","InOutResultSave",EpisodeID,aa,session['LOGON.USERID'],"DHCNUR6",session['LOGON.GROUPDESC'],Enddate,EndTime);
                     // alert("完成")
          }
	    }
	    else
	     {
	        
	        var id=tkMakeServerCall("NurEmr.webheadchange","InOutResultSave",EpisodeID,aa,session['LOGON.USERID'],"DHCNUR6",session['LOGON.GROUPDESC'],Enddate,EndTime);
          //alert("完成")
	     }
  
     find()
	
}
function beforeEditFn(e){
	grid.rowIndex = e.row;   //得到当前的行
	grid.columnIndex = e.column;	//得到当前的列
}
var storespechar = new Array();
//特殊字符
function SepcialChar() {
	var gridspchar = new Ext.grid.GridPanel({
		id : 'mygridspecchar',
		name : 'mygridspecchar',
		title : '',
		stripeRows : true,
		height : 350,
		width : 120,
		tbar : [{
					id : 'insertBtn',
					handler:insertSpecChar,
					text : '插入'
				},'-',{
					id : 'replaceBtn',
					handler:replaceSpecChar,
					text : '替换'
				}],
		store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
				'name':'desc',
				'mapping':'desc'
			},{
				'name':'rw',
				'name':'rw'
			}]
		}),
		baseParams:{
			className:'User.DHCTEMPSPECIALCHAR',
			methodName:'CRItem',
			type:'Query'
		}
	}),
		colModel : new Ext.grid.ColumnModel({
			columns : [{
						header : '特殊字符',
						dataIndex : 'desc',
						width : 110
					}, {
						header : 'rw',
						dataIndex : 'rw',
						width : 0
					}],
			rows : [],
			defaultSortable : true
		}),
		enableColumnMove : false,
		readOnly:false,
		viewConfig : {
			forceFit : false
		}
	});
	storespechar = new Array();
	var window = new Ext.Window({
		title: '<span style="font-family:Arial;">特殊字符</span>',
		x:400,
		y:300,
		width: 138,
		height: 350,
		autoScroll: false,
		layout: 'absolute',
		plain: true,
		frame:true,
		//modal: true,
		//bodyStyle: 'padding:5px;',
		///buttonAlign: 'center',
		items : gridspchar,
		listeners:{'close':function(){
			if (Ext.getCmp('mygrid').rowIndex>0) Ext.getCmp('mygrid').startEditing(Ext.getCmp('mygrid').rowIndex , Ext.getCmp('mygrid').columnIndex);
		}}
	});
	window.show();
	Ext.getCmp('mygridspecchar').getColumnModel().setHidden(1,true);//编辑结束隐藏该列
    gridspchar.store.on("beforeLoad",function(){   
       gridspchar.store.baseParams.parr="";    //传参数，根据原来的方式修改
    });    
    //mygrid.getStore().addListener('load',handleGridLoadEvent); //护理记录表格需要：日期转换及出入量统计行加颜色
    gridspchar.store.load({
    	params:{
    		start:0,
    		limit:30
    	}	
   })
}

function SpecCharFn(flag) 
{
		var grid = Ext.getCmp('mygridspecchar');
		//弹出界面中Grid
    var selModel = grid.getSelectionModel();   
    if (selModel.hasSelection()) {  
			var selections = selModel.getSelections();
			
			var rowIndex = grid.store.indexOf(grid.getSelectionModel().getSelected());
			if (rowIndex<0) return;
			var specchardesc=grid.store.getAt(rowIndex).data.desc;
			var mygrid=Ext.getCmp('mygrid');
			if (mygrid.getSelectionModel().hasSelection()){
			}
			else {
				alert("请先选择要插入的位置!");
				return;
			}
			//alert(mygrid.columnIndex)
			var oldStr=mygrid.store.getAt(mygrid.rowIndex).get(mygrid.getColumnModel().getDataIndex(mygrid.columnIndex));
			if (oldStr) {
				if (flag=="I") {
					specchardesc=oldStr+specchardesc;
				}
			}
			mygrid.store.getAt(mygrid.rowIndex).set(mygrid.getColumnModel().getDataIndex(mygrid.columnIndex),specchardesc);
			mygrid.startEditing(mygrid.rowIndex , mygrid.columnIndex);
	}
}
function insertSpecChar() 
{
	SpecCharFn("I"); 
}
function replaceSpecChar()
{
	SpecCharFn("R");
}
var REC=new Array();
//查询
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
	var parr = adm + "^" + StDate.value + "^" + StTime.value + "^" + Enddate.value + "^" + EndTime.value + "^"+EmrCode + "^" + IfCancelRec;
    var mygrid = Ext.getCmp("mygrid");
    mygrid.store.on("beforeLoad",function(){   
       mygrid.store.baseParams.parr=parr;    //传参数，根据原来的方式修改
    });    
    mygrid.getStore().addListener('load',handleGridLoadEvent); //护理记录表格需要：日期转换及出入量统计行加颜色
    mygrid.store.load({
    	params:{
    		start:0,
    		limit:30
    	}	
   })
}
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
//续打设置颜色
function setcolor(grid)
{
  if ((StartLock!="1")||(prnmode=="")) //没有开启续打
  {
    return
  }
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
	grid.getStore().on('load',function(s,records){
          var gridcount=0;
          s.each(function(r){             
                 var rowid=r.get("par")+"||"+r.get("rw")  
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
                 //scope:this
          });
}
function FailChange(val)
{
	if (val>0)
	{
	return '<span style="color:red">' + val + '</span>';
	}
	return val
}
//选行保存
function save()
{
	SaveComm("Y");
} 
//全部保存
function saveall()
{
	SaveComm("N");
} 
//保存公共方法 
//singleflag:Y 选行保存 ；N 全部保存
function SaveComm(singleflag)
{
	var grid1=Ext.getCmp('mygrid');
	var grid=Ext.getCmp('mygrid');
    var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var list = [];
	if (singleflag=="Y")
	{
	    var rowObj = grid.getSelectionModel().getSelections();
		var len = rowObj.length;
		
		for (var r = 0;r < len; r++) {
		     list.push(rowObj[r].data);
	    }	
	}	
	else
	{
	    for (var i = 0; i < store.getCount(); i++) {
		    list.push(store.getAt(i).data);
	    }
	}
	
	var rwIndex=grid1.getSelectionModel().last;
	var CaseMeasureID="CaseMeasureID|";
	//debugger;
	if (MeasureRel.contains(rwIndex))
	{
		var rid=MeasureRel.items(rwIndex);		
		CaseMeasureID=CaseMeasureID+rid;
	}
	var RecSave=document.getElementById('RecSave');	
	var recpar="" //图片
	var recrw=""  //图片	  
	for (var i = 0; i < list.length; i++) {
	  var obj=list[i];
	  var str="";
	  var CareDate="";
	  var CareTime="";
	  var flag="0";
      var isModifiedflag=""
		for (var p in obj) {
			if (singleflag=="N")
			{
			   if (store.getAt(i).isModified(p))
	           {
	      	      isModifiedflag="Y";
	           }
	        }else
	        {
	        	var rowIndex = grid.store.indexOf(grid.getSelectionModel().getSelected());
	        	if (store.getAt(rowIndex).isModified(p))
	            {
	      	      isModifiedflag="Y";
	            }
	        }
			var aa = formatDate(obj[p]);				
			if (p=="CareDate") CareDate=aa;
			if (p=='CareTime') CareTime=obj[p];
			if (p=="par") recpar=obj[p]  //图片
	        if (p=="rw")  recrw=obj[p]   //图片
			if (p=="") continue;
			if ((p == DisplaySumInName) && (obj[p].indexOf("入液量") != -1)) {
				flag = "1";
			}
			if ((p==DisplaySumOutName)&&(obj[p].indexOf("出液量")!= -1))
			{
				flag="1";
			} 
			if (aa == "") 
			{
					str = str + p + "|" + DBC2SBC(obj[p]) + '^';
			}else
			{
			  	str = str + p + "|" + aa + '^';	
			}
		}
		//alert(isModifiedflag)
		if ((str!="")&&(flag=="0")&&(isModifiedflag=="Y"))
		{
			if (str.indexOf("CareDate")==-1)
			{
				str=str+"CareDate|"+CareDate+"^CareTime|"+CareTime;
				//debugger;
			}
			var diaggrid = Ext.getCmp('diaggrid');
			if (diaggrid) {
	  		var selModel=diaggrid.getSelectionModel();
	  		if (selModel.hasSelection()) {   
	  			var objDiagRow = selModel.getSelections();		  			
					DiagnosDr=objDiagRow[0].get("rw");
				}
				else {
					DiagnosDr="";	
				}
			}
			else {
				DiagnosDr="";
			}
			
			str=str+"DiagnosDr|"+DiagnosDr;
			//str=str+"^RecLoc|"+patloc+"^RecNurseLoc|"+session['LOGON.CTLOCID']+"^RecBed|"+bedCode;  //patloc是病人当前科室，如果打印时“科室”希望打印的是科室则用该句；
			str=str+"^"+CaseMeasureID;
			//alert(EpisodeID+";"+str+";"+session['LOGON.USERID']+";"+session['LOGON.GROUPDESC']);
			var a=cspRunServerMethod(RecSave.value,EpisodeID,str,session['LOGON.USERID'],EmrCode,session['LOGON.GROUPDESC']);
			//alert(a);
			var recid=""
			if ((recpar!="")&&(recrw!=""))  //图片
			{
			      recid=recpar+"||"+recrw
			}
			if (i==(list.length-1))
		    {
			     if (IfMakePic=="Y")
				 {
			        var page=tkMakeServerCall("NurEmr.webheadchange","getheadpagerow",EpisodeID,EmrCode,recid,"",CareDate,CareTime)  //图片		   
			        //alert(page)			   
	                //MakePicture(page) //生成图片
	             } 				 
	         }			
			if (a!="0")
			{
				alert(a);
				return;
			}
		}
	}
	if (ShowMakeHJ=="Y")
	{
	   var pinfoval=Ext.getCmp("hjflag").getValue();
	   if (pinfoval)
	   {
		//makehj()
		makeRechj(prncode);
	   }
    }
	setTimeout("find()",0)
	window.parent.reloadtree2(EmrCode,"表格");

}
//Ext.util.Format.dateRenderer
//ext.util.format.date(ext.getcmp("控件id").getvalue(),y-m-d)Y-m-d H:m:s
function gettime()
{
	var a=Ext.util.Format.dateRenderer('h:m');
	return a;
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
 //新建
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
var rightClickXU = new Ext.menu.Menu(  {
            id : 'rightClickContxu',
            items : [ {
                id:'rMenu1',
                text : '病情措施及处理', //新调用
                handler:RecMeasureNew
            }, 
             {
                id:'rMenu2',
                text : '补打设置',
                handler:SetXu
            },
            {
               id:'rMenu3',
               text : '修改关联科室床号',
               handler:ChangLocBed
              },
            {
                id:'rMenu4',
                text : '作废',
                handler:CancelRecord
            }]
        });
var rightClick = new Ext.menu.Menu(  {
            id : 'rightClickCont',
            items : [ {
                id:'rMenu5',
                text : '病情措施及处理', //新调用
                handler:RecMeasureNew
            },            
            {
               id:'rMenu6',
               text : '修改关联科室床号',
               handler:ChangLocBed
              },
            /*
             {
                id:'rMenu4',
                text : '插入出入液量小结',
                handler:InOutNod
            },  {
                id:'rMenu5',
                text : '插入24小时出入液量',
                handler:InOutSum
            },  {
                id:'rMenu6',
                text : '修改关联诊断',
                handler:UpdateRelDiagnos
            },  
            */
            {
                id:'rMenu7',
                text : '作废',
                handler:CancelRecord
            }]
        });
function rightClickFn(client, rowIndex, e)  
{
          e.preventDefault();
          grid=client;
		  CurrRowIndex=rowIndex;
		  //rightClick.showAt(e.getXY());
		  //return;
		  //alert(e.getXY())
		  if ((StartLock!="1")||(prnmode=="")) //没有开启续打
          {
          	rightClick.showAt(e.getXY());
          }else
          {
          	//alert(1)
          	rightClickXU.showAt(e.getXY());
          }
          
 }
function rowClickFn(grid, rowIndex, e)  
{
                //alert('你单击了' + rowIndex);
}


 //修改关联科室           
 function ChangLocBed()
{	 
      grid=Ext.getCmp('mygrid');
	  var selModel = grid.getSelectionModel();  
	  var ret="" ;
      if (selModel.hasSelection()) 
      {   
				  var selections = selModel.getSelections();							
				   Ext.each(selections, function(item) 
				   {
					  var par=item.data.par;
					  var rw=item.data.rw;
					  if (par!=undefined) 
					  {
					     if (ret=="") ret=par+"||"+rw
					     else
					     {
					  		ret=ret+"^"+par+"||"+rw
					  		
					     }
					  }
					  
					 }
					 )
		}		
	 //alert(ret)
    var objRow=grid.getSelectionModel().getSelections();	
    if (objRow.length == 0) 
    { 
    	alert("请先选择一条护理记录!");
        return; 
    }
    if (ret=="") return
    Rowid=ret;
    Prnloctype="W";  //选择病区：W  ; 选择的是科室：L
    var lnk= "DHCNurEmrComm.csp?EmrCode=DHCNURSZZY_LocBedLink"+"&Rowid="+Rowid+"&EpisodeID="+EpisodeID+"&Prnloctype="+Prnloctype //+rowid;
	//注意dhcnuremrcomm.csp大小写，一般是DHCNurEmrComm.csp
    window.open(lnk,"OrdExec1222","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=200,width=530,top=100,left=300");	
}

//续打说明
function XuInt()
{
	var lnk= WebIp+"/dhcmg/续打使用说明.doc" 
	wind22=window.open(lnk,"htmi",'left=10,toolbar=no,location=no,directories=no,resizable=yes,width=1200,height=700');
}


//设置续打起始位置
function SetXu()
{
  if ((StartLock!="1")||(prnmode=="")) //没有开启续打
  {
    return
  }
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length > 0) 
	{			
	}
	else
	{
	  alert("请先选择一条记录!"); 
	  return; 
	}
    var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCNUR_SetXu", EpisodeID, "");
	arr = eval(a);
	var window = new Ext.Window({
		title: '补打设置',
		x:100,
		y:100,
		width: 320,
		height: 200,
		autoScroll: true,
		layout: 'absolute',
		plain: true,
		frame:true,
		//modal: true,
		//bodyStyle: 'padding:5px;',
		///buttonAlign: 'center',
		items: arr
	});	  
	  var idrw = objRow[0].get("rw");
		var idpar = objRow[0].get("par");
		if (idpar==undefined)
    {
            alert("请选择已保存过得记录!");
            find()
						return;
    }
		var User = objRow[0].get("User");
		var CareDate = objRow[0].get("CareDate");
		var CareTime = objRow[0].get("CareTime");
		var select=Ext.getCmp('sel');
		var select2=Ext.getCmp('page')
    var select3=Ext.getCmp('row')
    var hnum=Ext.getCmp('hnum')
    var pflag=Ext.getCmp('pflag')
    pflag.disable()
    hnum.disable()
    select.disable()  
	select.setValue(formatDate(CareDate)+"/"+(CareTime)+"/"+User)
	var but=Ext.getCmp('butSave');
	  but.on('click',SaveSetXu);
	  var but2=Ext.getCmp('Cancel');
	  but2.on('click',Cancel);
	  var id=idpar+"&"+idrw   
	  var info=tkMakeServerCall("Nur.DHCNurRecPrint","getval",id)
	  var infoST=tkMakeServerCall("Nur.DHCNurRecPrintStPos","getval",EpisodeID+"&"+prncode)	
	  var arr 
	  if (infoST!="")
	  {	     	  
	      arr=infoST.split('^') 
	      var nowid=idpar+"||"+idrw   
	      if (arr[0]!=nowid)  //选中行不是续打记录最后一条
	      {
	         if (info!="")
	         {
	           var arr2=info.split('^')  
	           if (arr2[1]!="")   //已打印
	           {
	              var pp2=parseInt(arr2[1])+parseInt(1)
	              var rr2=parseInt(arr2[2])+parseInt(1)     
	              select2.setValue(pp2)
	              select3.setValue(rr2)
	              var hstr=rr2+parseInt(arr2[3])-parseInt(1)+"行(该条记录占"+arr2[3]+"行)"
	              hnum.setValue(hstr)
	              pflag.setValue("已打印")
	           }
	           else
	           {
	              pflag.setValue("未打印")
	           }
	         }
	        else
	        {
	           pflag.setValue("未打印")
	        }
	     }
	    else
	    { 
	      if (arr[3]=="0") //从该条开始打印
	      {
	        var pp=parseInt(arr[1])+parseInt(1)
	        var rr=parseInt(arr[2])+parseInt(1)       
	        select2.setValue(pp)
	        select3.setValue(rr)
	        if (arr[4]!="")
	        {
	          var hstr2=parseInt(arr[2])+parseInt(arr[4])+"行(该条记录占"+arr[4]+"行)"
	          hnum.setValue(hstr2)
	        }
	        pflag.setValue("未打印")
	      }
	      if (arr[3]=="1") //该条已经打印
	      {
	        var pp2=parseInt(arr[1])+parseInt(1)
	        var rr2=parseInt(arr[2])-parseInt(arr[4])+parseInt(1)
	        select2.setValue(pp2)
	        select3.setValue(rr2)
	        var hstr3=arr[2]+"行(该条记录占"+arr[4]+"行)"
	        hnum.setValue(hstr3)
	        pflag.setValue("已打印")
	      }
	    }
	    
	    if (arr[5]!=undefined)
	    {
	      var pstrs=pflag.getValue()+"(每页可打印"+arr[5]+"行)"
	      pflag.setValue(pstrs)
	    }	      
	  }
	  else
	  {
	    pflag.setValue("未打印")
	  }	  
	 window.show();
	 
	 function Cancel()
	 {
	   window.close()
	 }
   function SaveSetXu()
   {
	   
      var pages=select2.getValue()
      var rows=select3.getValue()
      //alert(arr[5])
      if ((pages=="")||(rows==""))
      {
         alert("开始页码和行数都不能为空!");
			   return;
      }
      if (isNaN(pages))
      {
            alert("页码请录入数字!");
						return;
      }
       if (isNaN(rows))
      {
            alert("行数请录入数字!");
						return;
      }
       if ((parseInt(pages)<1)||(parseInt(rows)<1)||(parseInt(rows)>parseInt(arr[5])))
      {
            alert("页码或行数必须大于0!"+"小于等于"+arr[5]+"行");
						return;
      }
      var stpage=parseInt(pages)-parseInt(1)
      var strow=parseInt(rows)-parseInt(1)
      var str=id+"^"+stpage+"^"+strow+"^^^^^"
      var ret=tkMakeServerCall("Nur.DHCNurRecPrintStPos","Save",str,EpisodeID,prncode,"0")
      if (ret=="0")
      {

		var flag = confirm("设置成功! 您要开始续打吗？!")
		if (flag) 
		{
			 printNurRecXu()	  
		}
	     window.close()
	     setTimeout("find()",0)
         //setcolor(grid)       
      }
      //alert(ret)	  
   }
} 
var checkret="";
//病情变化及处理措施新界面 201406
function MeasureNew()
{  
	MeasureRel = new Hashtable();
	var grid1=Ext.getCmp('mygrid');
	var objRow=grid1.getSelectionModel().getSelections();
	if (objRow.length == 0) 
	{
	 alert("请先选择一条护理记录!"); 
	 return; 
	}
	var par=grid1.getSelectionModel().getSelections()[0].get("par"); 
	var rw=grid1.getSelectionModel().getSelections()[0].get("rw"); 
	var rowid=par+"||"+rw;
	if (par==undefined)
	{
		rowid="";
	}
	var parr=EmrCode+"^"+EpisodeID+"^CaseMeasureXml^"+rowid;
    var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCNURMeasure", EpisodeID, "");
	arr = eval(a);
    var emrknowurl="dhcnuremrknow.csp?EmrCode=DHCNurKnowldge&Parr="+parr+"&EpisodeID="+EpisodeID;                  
    var south_item = new Ext.Panel({   
                region: 'south',                
                split: false,   
               	border: false,   
               	// collapsible: true,   
         		autoScroll: false,
                layout: 'absolute',   
                minSize: 100,  
				        height:570, //内层高度（600-30）预留30的高度给确定按钮
  				      frame:true,
                //items: arr 
				        buttons: [ {
						      text: '确定',						     
						      handler: function(){							
							    sureMeasure();
						      }
					        }, {
						      text: '取消',
						      handler: function(){
							    window.close();
						      }
					       }],
				        html: '<iframe id ="southTab" name="ddd" style="width:100%; height:100%" src='+emrknowurl+' ></iframe>'                
                 });   
	    var window = new Ext.Window({ 
		title: '病情措施及处理',
		x:100,
		y:50,
		width: 900,  //宽度
		modal:true,
		height: 600,  //高度
		id:'CaseForm',
		autoScroll: false,
		layout: 'absolute',
		plain: true,
		frame:true,
		items: south_item   
	});
	var mygrid=Ext.getCmp("mygrid");
	var rowObj = mygrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len < 1)
	{
		alert("请选择一条数据!");
		return;
	}
  window.show();
}
function OrdSch()
{         
	// var CurrAdm=selections[rowIndex].get("Adm");
	selections = grid.getSelectionModel().getSelections();
	var arrord = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCPatOrdList", EpisodeID, "");
	arrord = eval(a);
	var window = new Ext.Window({
		title: '医嘱',
		id:'orditmssss',
		x:100,
		y:80,
		width: 670,
		height: 560,
		autoScroll: true,
		layout: 'absolute',
		//plain: true,
		//frame:true,
		//modal: true,
		//bodyStyle: 'padding:5px;',
		///buttonAlign: 'center',
		items: arrord
	});
	
	var mydate=new Date();

	var	grid1=Ext.getCmp("ordgrid");
	var bbar = grid1.getBottomToolbar ();
	//bbar.hide();
	
	//bbarord.render(grid1.bbar);
	tobar=grid1.getTopToolbar();
	tobar.addItem(
	    {
			xtype:'datefield',
			//format: 'Y-m-d',
			id:'ordgridstdate',
			value:(diffDate(new Date(),-1))
		},
	    {
			xtype:'datefield',
			//format: 'Y-m-d',
			id:'ordgridenddate',
			value:new Date()
		}
	);
	tobar.addButton(
	  {
		className: 'new-topic-button',
		text: "查询",
		icon:'../Image/icons/magnifier.png',
		//handler:find,
		id:'ordgridSch'
	  }

	);

	var butin=Ext.getCmp('ordgridbut2');
	butin.hide();
	var butin=Ext.getCmp('ordgridbut1');
	butin.text="确定";
	//debugger;
	butin.on('click',SureIn);
	var butschord=Ext.getCmp('ordgridSch');
	butschord.on('click',SchOrd);
	window.show();
	return ;

}

function SureIn()
 {
	var grid = Ext.getCmp('ordgrid');
	var mygrid=Ext.getCmp('mygrid');
	var store = grid.store;
	var rowCount = store.getCount(); //记录数
	/*var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount(); //列数
	var view = grid.getView();*/
	var num=0;
    var selModel = grid.getSelectionModel();   
    if (selModel.hasSelection()) {   
       	// Ext.Msg.confirm("警告", "确定要删除吗？", function(button) {   
				var selections = selModel.getSelections();
				//var rowIndex = grid.store.indexOf(grid.getSelectionModel().getSelected());
				//grid.getSelectionModel().selectRow(rowIndex);
				//debugger;
				var caredate,caretime;
				Ext.each(selections, function(item) {
					var des=item.data.ARCIMDesc;
					des=des.replace("_____","");
					var ml=item.data.Dose;
					var unit=item.data.DoseUnit;
					if ((unit!="ml")&&(unit!="ML")) ml=0;
					var seqno=item.data.SeqNo;
					var rowIndex = grid.store.indexOf(item);
					for (var i = rowIndex-1; i >=0; i--) {
						var subdes=store.getAt(i).data.ARCIMDesc;
						subdes=subdes.replace("_____","");
						var subml=store.getAt(i).data.Dose;
						var subunit=store.getAt(i).data.DoseUnit;
						if (subunit!="ml") subml=0;
						var subseqno=store.getAt(i).data.SeqNo;
						if (subseqno==seqno)
						{
							des=subdes+","+des;
							ml=eval(ml)+eval(subml);
						}
						else
						{
							break;	
						}
					}
					for (var i = rowIndex+1; i < store.getCount(); i++) {
						var subdes=store.getAt(i).data.ARCIMDesc;
						subdes=subdes.replace("_____","");
						var subml=store.getAt(i).data.Dose;
						var subunit=store.getAt(i).data.DoseUnit;
						if ((subunit!="ml")&&(subunit!="ML")) subml=0;
						var subseqno=store.getAt(i).data.SeqNo;
						if (subseqno==seqno)
						{
							des=des+","+subdes;
							ml=eval(ml)+eval(subml);
						}
						else
						{
							break;	
						}
					}
					if (num == 0) {
						caredate=mygrid.getStore().getAt(0).get("CareDate");
						caretime=mygrid.getStore().getAt(0).get("CareTime");
						var objRow=mygrid.getSelectionModel().getSelections();
						if (objRow.length == 0) { Ext.Msg.alert('提示', "请先选择某行!"); return; }
						else
						{
								objRow[0].set(SumInName, des);
								objRow[0].set(SumInAmount, ml);
						}
					}else{
						additm();
						mygrid.getSelectionModel().selectRow(mygrid.store.getCount()-1);   
						mygrid.getSelectionModel().getSelections()[0].set("CareDate", caredate);
						mygrid.getSelectionModel().getSelections()[0].set("CareTime", caretime);
						mygrid.getSelectionModel().getSelections()[0].set(SumInName, des);
						mygrid.getSelectionModel().getSelections()[0].set(SumInAmount, ml);
					}
					num++;
				});   
     }
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

function sureMeasure()
{
	 var gform=Ext.getCmp("gform");
	var TxtCaseMeasure=Ext.getCmp('TxtCaseMeasure');
	var frm=Ext.getCmp('CaseForm');
	var aa=document.getElementById("southTab");
	var CareCon=Ext.get("southTab").dom.contentWindow.document.getElementById("DesignForm");
	//alert(CareCon.QichTextCon.GetCellText());
	var win=Ext.get("southTab").dom.contentWindow;
   // var parr="DHCNURXH2^"+EpisodeID+"^CaseMeasureXml";
	var ret=southTab.Save();
	var grid1=Ext.getCmp('mygrid');
	CaseMeasureID=ret; 
	var rwIndex=grid1.getSelectionModel().last;
	MeasureRel.add(rwIndex,CaseMeasureID);
	grid.getSelectionModel().getSelections()[0].set("CaseMeasure",CareCon.QichTextCon.GetCellText());
	frm.close();

}
function SchOrd()
{
	condata=new Array();
	var adm=EpisodeID;
	var StDate= Ext.getCmp("ordgridstdate");
	var Enddate= Ext.getCmp("ordgridenddate");
	var GetQueryData=document.getElementById('GetQueryData1');
	var ordgrid=Ext.getCmp("ordgrid");
	var parr=adm+"^"+StDate.value+"^"+Enddate.value;
 	//var a=cspRunServerMethod(GetQueryData.value,"web.DHCNUREMR:GetPatOrd","parr$"+parr,"add");
	// grid.width=document.body.offsetWidth;
	//ordgrid.store.loadData(condata);
    ordgrid.store.on("beforeLoad",function(){   
    	 if (ordgrid.store)
    	 {
    	 	 ordgrid.store.baseParams.parr=parr;    //传参数，根据原来的方式修改
    	 }
      
    });    
    //ordgrid.getStore().addListener('load',handleGridLoadEvent); //护理记录表格需要：日期转换及出入量统计行加颜色
    ordgrid.store.load({
    	params:{
    		start:0,
    		limit:10
    	}	
   })
}
//全部打印
function printNurRecZK()
{	   
	    printcomm(0,1); //转科不续打	
}
//生成每条记录的痕迹
function makehj()
{
	PrintCommPic.Makeprintinfo="Y"
	printcomm(0,1); //转科不续打
}
//打印公共方法
//xuflag:1 续打，0不续打；
//zkflag:1 转科，0不转科
function printcomm(xuflag,zkflag)
{
	    if (prncode=="")
	    {
	    	alert("请在“demo/护士站/界面打印模板关联”中维护该模板的打印模板名称!");
	    	return;
	    }
        var GetPrnSet=document.getElementById('GetPrnSet');
		var GetHead=document.getElementById('GetPatInfo');	
		var ret=cspRunServerMethod(GetHead.value,EpisodeID);
		var hh=ret.split("^");
		var GetLableRec=document.getElementById('GetLableRec');
		var LabHead=cspRunServerMethod(GetLableRec.value,EmrCode+"^"+session['LOGON.CTLOCID']);
		var stdate="" //tm[2];
		var stim="" //tm[3];
		var edate="" //tm[4];
		var etim="" //tm[5];
		//PrintCommPic.RHeadCaption=hh[1];
		//PrintCommPic.LHeadCaption=hh[0];
		PrintCommPic.TitleStr=ret;
		PrintCommPic.SetPreView("1");
		if (zkflag=="1") //转科
		{
		   PrintCommPic.PrnLoc=patloc ;  //转科打印时设置床号 如果没更新转科这句屏蔽
		}
		else
		{
		  PrintCommPic.PrnLoc=session['LOGON.CTLOCID']; 
		}				
		PrintCommPic.PrnBed=bedCode ; //转科打印时设置床号  如果没更新转科这句屏蔽
		PrintCommPic.xuflag=xuflag;   //0 不启用续打，1 启用续打
		PrintCommPic.tranflag=zkflag; //是否启用转科:1 转科，0不转科
		PrintCommPic.SplitPage=zkflag;//转科是否换页:1 换页，0不换页
		PrintCommPic.dxflag="1"       //分割线设置：1一条记录打印一条线 0 一行打印一条线	
		PrintCommPic.WebUrl=WebIp+"/dthealth/web/DWR.DoctorRound.cls";
		PrintCommPic.stPage=0;
		PrintCommPic.stRow=0;
		PrintCommPic.previewPrint="1"; //是否弹出设置界面:0不弹出，1弹出
		if (xuflag=="1")  //续打不弹出设置界面n
		{
           PrintCommPic.previewPrint="0"; //是否弹出设置界面:0不弹出，1弹出
		}
		
		PrintCommPic.stprintpos=0;	
		PrintCommPic.EmrCode=EmrCode;
		PrintCommPic.ItmName = prncode; //338155!2010-07-13!0:00!!
		var parr=EpisodeID+"!"+stdate+"!"+stim+"!"+edate+"!"+etim+"!"+EmrCode+"!";
		PrintCommPic.ID = "";
		PrintCommPic.MultID = "";
		//PrintCommPic.MthArr="web.DHCConsult:getConsultInfo&id:"+myid;
		if(LabHead!="") PrintCommPic.LabHead=LabHead;
		PrintCommPic.SetParrm(parr); // ="EpisodeId" ; //"p1:0^p2:"
		PrintCommPic.PrintOut();	
		setTimeout("find()",0)
}
//续打
function printNurRecXu()
{
	    printcomm(1,1); //转科续打			
}
//生成图片
function MakePicture(page)
         {
	        var typein=typeof page
	        if (typein=="object") page=0
	        var GetHead=document.getElementById('GetPatInfo');
            var ret=cspRunServerMethod(GetHead.value,EpisodeID);
	        PrintCommPic.StartMakePic = "Y";  //图片
            PrintCommPic.SetPreView("1");
            PrintCommPic.WebUrl = WebIp+"/dthealth/web/DWR.DoctorRound.cls";
            PrintCommPic.stPage = 0;
            PrintCommPic.stRow = 0;
            PrintCommPic.TitleStr =ret ; 
            PrintCommPic.previewPrint = "0";      //是否弹出设置界面
            PrintCommPic.stPrintPos = 0;
            PrintCommPic.PrnLoc = session['LOGON.CTLOCID'];           
            PrintComm.Patcurloc = patloc;        //病人当前科室id
            PrintComm.NurseLocHuanYe = "Y";      //Y:转病区换页(按绑定的护士科室id) N:按病人科室换页
            PrintCommPic.PrnBed = bedCode;       //病人当前床号
            PrintCommPic.tranflag = "1";         //转科换页
            PrintCommPic.dxflag = 1;             //1：一条记录打印一条横线；0：一条记录的每一行文字下面都打印一条横线
            PrintCommPic.xuflag = "0";           //0:不启用续打印 ；1 启用续打
            PrintCommPic.SplitPage = "1";        //1:有转科或转病区时新起一页打印
            PrintCommPic.ItmName = prncode;      //打印模板名 请参考printNurRec
            PrintCommPic.EpisodeID = EpisodeID;  //图片
            PrintCommPic.EmrCode = EmrCode;      //图片
            PrintCommPic.MakeTemp = "Y";         //图片  Y:生成图片  ；N:不生成
            if (WillUpload=="Y")
		    {
              PrintCommPic.IfUpload="Y";           //图片是否上传ftp服务器：Y -上传，N-不上传
            }
            else
            {
              PrintCommPic.IfUpload="N";
            }
            PrintCommPic.MakeAllPages = "N";     //图片  Y:生成该病人该模板的所有图片; N:生成最近一页图片
            PrintCommPic.curPages = page;        //图片  开始页码
            PrintCommPic.filepath = WebIp+"/DHCMG/HLBLMakePictureSet.xml";  //图片 ftp服务器配置
            var parr = EpisodeID+"!" + "!" + "!" + "!" + "!"+EmrCode+"!";         
            PrintCommPic.ID = "";
            PrintCommPic.MultID = "";
            PrintCommPic.SetParrm(parr); 
            PrintCommPic.PrintOut();
            PrintCommPic.MakePicture(); //图片	
}
//全部打印 测试
function printNurRecZKTest()
{
	    printcomm(0,1); //转科续打			
} 
function UpdateRelDiagnos()
{
	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCNurRelDiagnos", EpisodeID, "");
	arr = eval(a);
	var window = new Ext.Window({
		title: '关联诊断记录',
		width: 615,
		height: 235,
		autoScroll: true,
		layout: 'absolute',
		plain: true,
		frame:true,
		//modal: true,
		//bodyStyle: 'padding:5px;',
		///buttonAlign: 'center',
		items: arr
	});
	var butin=Ext.getCmp('diaggridbut1');
	butin.text="确定";
	butin.on('click',UpdateDiagnos);
	var but2=Ext.getCmp('diaggridbut2');
	//but2.text="插入小结";
	//but2.on('click',UpdateDiagnos1);
	var diaggrid = Ext.getCmp('diaggrid');
	var diagtobar=diaggrid.getTopToolbar();

	//debugger;
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length > 0) {
		var inname = objRow[0].get(DisplaySumInName);
		var outname = objRow[0].get(DisplaySumOutName);
		if ((inname)&&(outname)&&((inname.indexOf("入液量") != -1) || (outname.indexOf("出液量") != -1))) {
			butin.hide();
		}
		else {
			but2.hide();
			var but3 = Ext.getCmp('diaggridbut3');
			but3.hide();
		}
	}
	SchDiag();
	window.show();
}
function UpdateDiagnos()
{
	var diaggrid=Ext.getCmp("diaggrid");
	var objDiagnosRow=diaggrid.getSelectionModel().getSelections();
	if (objDiagnosRow.length == 0)
	 { 
		alert( "请先选择一条诊断记录!");
	 return;
	  }
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) { 
        alert( "请先选择一条护理记录!");
		return; }
	else
	{
		save();
	}
}
function SchDiag()
{
	condata=new Array();
	var adm=EpisodeID;
	var GetQueryData=document.getElementById('GetQueryData');
	var diaggrid=Ext.getCmp("diaggrid");
	//alert(adm);
 	var a=cspRunServerMethod(GetQueryData.value,"web.DHCNurseRecordComm:GetCopyDiagnos","parr$"+adm,"AddDiag");
  	diaggrid.store.loadData(condata);   
}
function AddDiag(a1,a2,a3,a4,a5)
{
	condata.push({
		DiagNos:a1,
		RecUser:a2,
		RecDate:a3,
		RecTime:a4,
		rw:a5
	});
}
function DBC2SBC(str)   
{
	var result = '';
	if ((str)&&(str.length)) {
		for (var i = 0; i < str.length; i++) {
			var code = str.charCodeAt(i);
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
function additmstat(statenddate,statendtime)
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
    var r = new Plant({CareDate:getDate(statenddate),CareTime:statendtime}); 
    grid.store.commitChanges(); 
    grid.store.insert(count,r); 
   return;
}