
var mainpanel;
var PanelId="MainPanel";
var selObj=null;
var color;

function tdclick(obj){

}

function mouserout(obj){	
	//obj.style.backgroundColor='#e6f2ff'
	obj.style.backgroundColor=color;
	
}

function mouserover(obj){
	
	color=obj.style.backgroundColor;
	obj.style.backgroundColor='#BDDDFF'
}


function dbtdclick(obj){
	
	if(obj){	
		
		var schduleDr=obj.id;
		var time=obj.innerText.replace(/\s/g,'');
		//alert(">"+time+"<");		
		
		var len=serviceOrderStore.getCount();
		var orderlistSel=""
		for(i=0;i<len;i++)
		{
			//alert(serviceOrderStore.getAt(i).get('oeOrdDr'));
			if ( sm.isSelected(i) )
			{
				if ( orderlistSel=="")
					orderlistSel=serviceOrderStore.getAt(i).get('oeOrdDr');
				else
					orderlistSel=orderlistSel+"@"+serviceOrderStore.getAt(i).get('oeOrdDr');
			}
		}
		
		var orderlistBook="";
		
		//����ѡȡ����ѡ���ҽ����������������б�ѡ��ҽ������ʾ �Ƿ�תԤԼ
		//�������б��е�ҽ�� ԤԼ����մ����ҽ������orderList
		if ( (orderList=="") &&(orderlistSel==""))
		{
			alert("����ѡ��ҽ��!");
			return;
		}
		else if ( (orderList!="") && (orderlistSel!=""))
		{
			if ( confirm("ȷ��תԤԼ�б�ѡ�е�ҽ��?")==false)
			{
				return;
			}
			orderlistBook=orderlistSel;
		}
		else if(orderList!="")
		{
			if ( confirm("�Ƿ�ԤԼ?")==false)
			{
				return;
			}
			orderlistBook=orderList;
		}
		else if(orderlistSel!="")
		{
			if ( confirm("�Ƿ�ԤԼ?")==false)
			{
				return;
			}
			orderlistBook=orderlistSel;
		}
	
		//�ж��Ƿ��Ѿ��ǼǺ�ԤԼ
		var statusRet=tkMakeServerCall("web.DHCRisBookSelSeat","getOrderStatus",orderlistBook);
		//alert(statusRet);
		if (statusRet=="R")
		{
			alert("�Ѿ��Ǽǣ�������ԤԼ!");
			return;
		}
		else if (statusRet=="B")
		{
			//alert("�Ѿ�ԤԼ������ȡ��ԤԼ��ԤԼ!");
			var ret = tkMakeServerCall("web.DHCRisAppointmentDo","DeleteBookInfo",orderlistBook);
			if (ret.split("^")[0]!="0")
			{
				alert("תԤԼʧ��!ret="+ret);
				return;
			}
		}
		
		//�ж��Ƿ�ԤԼʱ���ͻ
		//web.DHCRisResourceApptSchudle.BookedConflict
		/*
	  	var rets=tkMakeServerCall("web.DHCRisResourceApptSchudle","BookedConflict",admSchedule,schduleDr);
	  	alert (rets);
	  	if (rets!="")
	  	{
		    ConFlag=confirm('�ò����� '+rets.split("^")[5]+" "+rets.split("^")[0]+" "+rets.split("^")[1]+' ����ԤԼ,�Ƿ����');
		    if (ConFlag==false){return;}	
		}
		*/
		//331||7^4953^1^^83^358^2015-12-25^687
		
		//alert( admSchedule);
		//alert( orderList);
		//alert( LocId );
		//var bookInfo=orderlistBook+"^"+schduleDr+"^1^^"+LocId+"^"+admSchedule+"^^"+session['LOGON.USERID']+"^^"+time;
		var bookInfo=orderlistBook+"^"+schduleDr+"^1^^"+LocId+"^"+""+"^^"+session['LOGON.USERID']+"^^"+time;
		//alert(bookInfo);
		//(web.DHCRisResourceApptSchudle).InsertBookedInfo
		//var bookRet=tkMakeServerCall("web.DHCRisResourceApptSchudle","InsertBookedInfo",bookInfo);
		alert(bookInfo);
		var bookRet=tkMakeServerCall("web.DHCRisResourceApptSchudle","Book",bookInfo);
		alert(bookRet);
		var bookRetArray=bookRet.split("^");
		if (bookRetArray[0]=="0")
		{
			alert("ԤԼ�ɹ�!");
			if ( orderlistBook==orderList)
			{
				orderList="";
				admSchedule="";
			}
			serviceOrderStore.removeAll();
			clickFind();
			
			OnPrint(orderlistBook);
			//selObj=null;
			//����ԤԼ�ɹ���detail rowid������rowid��ȡobj����ִ��
			/*
			var detailID=tkMakeServerCall("web.DHCRisResourceApptSchudle","getBookDetailRowid",orderlistBook);

			var obj1=document.getElementById(detailID);
			findBookInfo(obj1);
			*/
			
		}
		else if (bookRetArray[0]=="-10055")
		{
			alert("��ʱ���Ѿ���ռ�ã�������ԤԼ��");
			return;
		}
		else
		{
			alert("ԤԼʧ�ܣ�ret="+bookRet);
			return;
		}
		
		
	  	
	}
		
	
}

//������ԤԼ��¼����ѯҽ����Ϣ
function findBookInfo(obj)
{
	//alert(obj.id);
	if( selObj != null)
	{
		selObj.style.backgroundColor=color;
	}
	if ( selObj==obj)
	{
		selObj.style.backgroundColor=color;
		serviceOrderStore.removeAll();
		selObj=null;
		//serviceOrderGrid.load();
		return;
	}
	selObj=obj;
	selObj.style.backgroundColor='#FFFF00';
	//alert(obj.id);
	serviceOrderStoreProxy.on('beforeload',function(objProxy,param){
		
		param.ClassName='web.DHCRisBookSelSeat';
		param.QueryName='QueryBookOrder';
		param.Arg1 = obj.id;
		param.ArgCnt = 1;
	});
	serviceOrderStore.load();
	
	
};

	
//��Դ
var resourceProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
}));

var resourceStore = new Ext.data.Store({
	proxy : resourceProxy,
	reader : new Ext.data.JsonReader({
		root:'record',
		totalProperty:'total',
		idProperty:'Group'
	},
	[
		{name:'ResourceDesc',mapping:'TResDesc'}
		,{name:'ResourceDr',mapping:'TRowid'}
		
	])
});


var resourceCmb = new Ext.form.ComboBox({
 	store:resourceStore,
 	displayField:'ResourceDesc',
 	valueField:'ResourceDr',
    fieldLabel:'��Դ',
    typeAhead : true,
    forceSelection : true,
    anchor:'95%',
	triggerAction:'all',
	id:'resourceCmb',
	selectOnFocus : true,
	//forceSelection : true,
	//enable:false,
	listeners : {
		/*
            'beforequery':function(e){
	            //web.DHCRisCommFunction
	         		 	              
            }            
         */
        }
 });
 
 
 
 var tpl2=new Ext.XTemplate(
			'<table border="0" id="{record}"  class="diytable" cellspacing="1" cellpadding="1" >',
       		'<tpl for="row">',
       		'<tr height=45>',
       		'<td width= 150 bgcolor="#BEBEBE" onselectstart="return false" style="text-align:center"><font color="black" size=2><b>{TimeRange}</b></font></td>',
       		'<tpl for="col">',
       		'<tpl if="Status==1"><td width= 100 onselectstart="return false" class="diytd3" style="text-align:center" onclick=findBookInfo(this) id={info}><font color=blue size=4>{Time}</font><br><font color=blue>{Name}</font></tpl>',
       		'<tpl if="Status==0"><td width= 150 onselectstart="return false" class="diytd3" onmouseover=mouserover(this) TimeRange={Time} onmouseout=mouserout(this) onclick=tdclick(this) ondblclick=dbtdclick(this) style="text-align:center" width=200 id={info}><font color=black size=4>{Time}</font><br><font color=black>&nbsp;{Name}&nbsp;</font></tpl>',
       		'</td>',
       		'</tpl>',
       		'</tr>',
       		'</tpl>',
       		'</table>'
     );
     
var mainpanel=new Ext.Panel({
	id:PanelId,
	title:" ",
	//autoWidth:true,
	//width:"auto",
	frame:true,
	//border:false,
	//height:"atuo",
	autoScroll:true,
	region: 'center',
	//renderTo:"ExtApp",
	collapsible:true,
	//hidden:true,
	tools:[
		/*{
		id:'close',
		handler:function(){
			mainpanel.hide();
		}
	}*/
	]
});
	
var findPanel = new Ext.Panel({
	border:false,
	//height:50,
	//style:'border: 1px solid #8db2e3;',
	layout:'column',
	items:[
		new Ext.Panel({
			width:200,
			layout:'form',
			border:false,
			labelWidth:80,
			labelAlign:'right',
			items:[
				resourceCmb	
			]
		}),
		
		new Ext.Panel({
			width:200,
			layout:'form',
			border:false,
			labelWidth:80,
			labelAlign:'right',
			items:[
				{
					xtype:'datefield',
					id:'bookDate',
					fieldLabel:'����',
					anchor:'95%',
					format:'Y-m-d',
					value:new Date()
					//emptyText:''
				}
			]
		})
		,
		new Ext.Panel({
			width:120,
			layout:'form',
			border:false,
			labelWidth:80,
			
			items:[
				{
					xtype:'button',
					id:'btnFind',
					text:'����' ,
					//anchor:'95%'//,
					width:60
				}
			]
		}),
		new Ext.Panel({
			width:120,
			layout:'form',
			border:false,
			labelWidth:80,
			
			items:[
				{
					xtype:'button',
					id:'btnPrint',
					text:'��ӡԤԼ��',
					//anchor:'95%',
					width:70
				}
			]
		}),
		new Ext.Panel({
			width:120,
			layout:'form',
			border:false,
			labelWidth:80,
			
			items:[
				{
					xtype:'button',
					id:'btnCancel',
					text:'ȡ��ԤԼ',
					//anchor:'95%',
					width:70
				}
			]
		})
		/*,
		new Ext.Panel({
			width:120,
			layout:'form',
			border:false,
			labelWidth:80,
			
			items:[
				{
					xtype:'button',
					id:'btnExport',
					text:'����',
					//anchor:'95%',
					width:70
				}
			]
		})*/
	]
});


var eastRegion = new Ext.FormPanel({
	id:"north",
	height:50,
	//layout:"form",
	//border:false,
	style:'border: 1px solid #8db2e3;',
	region: 'north',
	items:[
		{
				xtype:'panel',
				id:'blank',
				border:false,
				height:15
				
		},		
		findPanel
	]
});


function clickExport()
{
	var resourceid=resourceCmb.getValue();
	
	var date=Ext.getCmp('bookDate').getRawValue();
	
	var ShowInfo=tkMakeServerCall("web.DHCRisBookSelSeat","GetScheduleDetail",resourceid,date);
	
	var orderList=ShowInfo.split("@");
	
	var numOfOrder=orderList.length;
	
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(); //xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	
	//.MergeCells = true
	 xlsheet.Range(xlsheet.Cells(1,2),xlsheet.Cells(1,4)).MergeCells = true;
	 
	xlsheet.cells(1,2).value="ԤԼ����:"+date;
	xlsheet.Range(xlsheet.Cells(1,5),xlsheet.Cells(1,7)).MergeCells = true;
	xlsheet.cells(1,5).value="ԤԼ�豸:"+resourceCmb.getRawValue();
	////�������� ����ϵ�绰��ԤԼ���ں�ʱ�䡢�������Һ�ҽ����ԤԼ�����Ŀ���շѽ��
	xlsheet.cells(2,1).value="����";
    xlsheet.cells(2,2).value="�ǼǺ�";
    xlsheet.cells(2,3).value="�绰";
    xlsheet.cells(2,4).value="ԤԼʱ��";
    xlsheet.cells(2,5).value="��������";
    xlsheet.cells(2,6).value="ҽ��";
    xlsheet.cells(2,7).value="�����Ŀ";
    xlsheet.cells(2,8).value="�շѽ��";
    xlsheet.Columns(1).ColumnWidth =6;
    xlsheet.Columns(2).ColumnWidth = 11;
    xlsheet.Columns(3).ColumnWidth = 12;
    xlsheet.Columns(5).ColumnWidth = 16;
    xlsheet.Columns(6).ColumnWidth = 6;
    xlsheet.Columns(7).ColumnWidth = 16;
    
	for (var i=0;i<numOfOrder;i++)
	{
		if (orderList[i]=="")
		{
			continue;
		}
		var itemInfo=orderList[i].split("^");
		//alert(orderList[i]);
		xlsheet.cells(i+3,1).value=itemInfo[3];
	    xlsheet.cells(i+3,2).value="'"+itemInfo[5];
	    if (itemInfo[6]!="")
	    {
	    	xlsheet.cells(i+3,3).value= "'"+itemInfo[6];
	    }
	   
	    xlsheet.cells(i+3,4).value=itemInfo[2];
	    xlsheet.cells(i+3,5).value=itemInfo[8];
	    xlsheet.cells(i+3,6).value=itemInfo[7];
	    xlsheet.cells(i+3,7).value=itemInfo[4];
	    xlsheet.cells(i+3,8).value=itemInfo[9];
	}
	
	for (var  i=2;i<=numOfOrder+2;i++)
	{
		for(var j=1;j<=8;j++)
		{
			xlsheet.cells(i,j).Borders.Weight = 1;
		}
		xlsheet.cells(i,5).WrapText=true;
		xlsheet.cells(i,7).WrapText=true;
	}
	
	//xlsheet.printout;
	xlApp.Visible = true; //����excel�ɼ�����  
    //var fname = xlApp.Application.GetSaveAsFilename("����.xls", "Excel Spreadsheets (*.xls), *.xls");  
    //xlBook.SaveAs(fname);
	//xlBook.Close (savechanges=false);
	xlsheet=null;
	xlApp=null;
	idTmr = window.setInterval("Cleanup();",1);  
	
}

function Cleanup()
{ 
	window.clearInterval(idTmr); 
	CollectGarbage(); 
} 

function clickFind()
{
	var info="";
	if (orderList!="")
	{
		var ShowInfo=tkMakeServerCall("web.DHCRisBookSelSeat","getOrderInfo",orderList);
	
		var infoList=ShowInfo.split("^");
		
		if (ShowInfo!="")
		{
			info=infoList[0]+" [ "+infoList[1]+" ]";
		}
		if (infoList[2]!="")
		{
			//Ext.getCmp('bookDate').setValue(infoList[4]);
			info=info+" "+infoList[3]+"("+infoList[4]+" "+infoList[5]+")";
		}
	}
	//mainpanel.setVisible(true);
	mainpanel.setTitle(info);
	
	var resourceid=resourceCmb.getValue();
	//alert(resourceid);
	var date=Ext.getCmp('bookDate').getRawValue();
	
	if (( resourceid=="")||(date==""))
	{
		alert("��ѡ����Դ������!");
		return;
	}
	
	mainpanel.setVisible(true);
	mainpanel.expand();
	
	var xdata=tkMakeServerCall("web.DHCRisBookSelSeat","getBookList",LocId,resourceid,date);
	//alert(xdata);
	if(xdata=="")
	{
		//mainpanel.setVisible(false);
		return;
	}
	
	tpl2.compile();
	var xdata=Ext.decode(xdata);
	tpl2.overwrite(mainpanel.body,xdata);
	//alert(tpl2.row);
	if(xdata.row=="") {
		mainpanel.setVisible(false)	
		return ;
		
	}
	//var el1=Ext.get("MainPanel")
	//var AppTimeRange1=document.getElementById("AppTimeRange")
	//newdiv.style.width=AppTimeRange1.offsetWidth
	mainpanel.doLayout();
	//alert("2");
}

function clickCancel()
{

	//alert(selObj.id);
	//serviceOrderStore
	var len=serviceOrderStore.getCount();
	
	var orderlistSel=""
	for(i=0;i<len;i++)
	{
		//alert(serviceOrderStore.getAt(i).get('oeOrdDr'));
		if ( sm.isSelected(i) )
		{
			if ( orderlistSel=="")
				orderlistSel=serviceOrderStore.getAt(i).get('oeOrdDr');
			else
				orderlistSel=orderlistSel+"@"+serviceOrderStore.getAt(i).get('oeOrdDr');
		}
	}
	
	if (orderlistSel=="")
	{
		//�жϴ����ҽ���Ƿ��Ѿ�ԤԼ
		if (orderList!="")
		{
			var hasBook=tkMakeServerCall("web.DHCRisResourceApptSchudle","hasBookOrder",orderList);
			//alert(hasBook);
			if (hasBook=="Y" )
			{
				orderlistSel=orderList;
			}
		}
	}
	
	if ( orderlistSel=="")
	{
		alert("����ѡ��ҽ��!");
		return;
	}
	if ( confirm("ȷ��ȡ��ԤԼ?")==false)
	{
		return;
	}
	
	//�ж��Ƿ��Ѿ��ǼǺ�ԤԼ
	var statusRet=tkMakeServerCall("web.DHCRisBookSelSeat","getOrderStatus",orderlistSel);
	//alert(statusRet);
	if (statusRet=="R")
	{
		alert("�Ѿ��Ǽǣ�������ȡ��ԤԼ!");
		return;
	}
	
	var ret = tkMakeServerCall("web.DHCRisAppointmentDo","DeleteBookInfo",orderlistSel);
	if (ret.split("^")[0]=="0")
	{
		alert("ȡ��ԤԼ�ɹ�!");
		//selObj.style.backgroundColor=color;
		if ( orderlistSel==orderList)
		{
			orderList="";
			admSchedule="";
		}
		serviceOrderStore.removeAll();
		selObj=null;
		clickFind();
		return;
	}
	else
	{
		alert("ȡ��ʧ��!ret="+ret);
		return;
	}
}

function clickPrint()
{
   
	//alert("print");
	var len=serviceOrderStore.getCount();
	
	var orderlistSel=""
	for(i=0;i<len;i++)
	{
		//alert(serviceOrderStore.getAt(i).get('oeOrdDr'));
		if ( sm.isSelected(i) )
		{
			if ( orderlistSel=="")
				orderlistSel=serviceOrderStore.getAt(i).get('oeOrdDr');
			else
				orderlistSel=orderlistSel+"@"+serviceOrderStore.getAt(i).get('oeOrdDr');
		}
	}
	
	if (orderlistSel=="")
	{
		//�жϴ����ҽ���Ƿ��Ѿ�ԤԼ
		if (orderList!="")
		{
			var hasBook=tkMakeServerCall("web.DHCRisResourceApptSchudle","hasBookOrder",orderList);
			//alert(hasBook);
			if (hasBook=="Y" )
			{
				orderlistSel=orderList;
			}
		}
	}
	
	if ( orderlistSel=="")
	{
		alert("����ѡ��ҽ��!");
		return;
	}

   OnPrint(orderlistSel);
}


function OnPrint(OrditemRowid)
{
	var gPrintTemplate=tkMakeServerCall("web.DHCRisResourceApptSchudle","GetLocBookedPrintTemplate",LocId);
   if (gPrintTemplate=="")
   {
	   alert("�������ô�ӡģ��!");
	   return;
   }
   //alert(gPrintTemplate);
   DHCP_GetXMLConfig("InvPrintEncrypt",gPrintTemplate);
   
	if(OrditemRowid!="")
	{
		var UserID=session['LOGON.USERID'];
  
  		//web.DHCRisResourceApptSchudle.GetCheckItemGroup"))
	    //var SameStudyNoFun=document.getElementById("SameItemGroupFun").value;
	    var SameGroup=tkMakeServerCall("web.DHCRisResourceApptSchudle","GetCheckItemGroup",OrditemRowid);
	    var nums=SameGroup.split("^").length;   
	    
        for (var i=0;i<nums;i++)
 	    {
		   var OrditemID=SameGroup.split("^")[i];
		   //web.DHCRisResourceApptSchudle.GetBookedPrintInfo"))
	       var value=tkMakeServerCall("web.DHCRisResourceApptSchudle","GetBookedPrintInfo",OrditemID);
	       
	       if(value=="")
	       {
		       alert("ҽ����Ŀ���ݳ����ܴ�ӡ�I");
		       return;
		   }
		   //alert(value)
	       if (value!="")
	       {
		       Item=value.split("^");
		       RegNo=Item[0];
		       Name=Item[1];
		       strOrderName=Item[2];
		       BookedDate=Item[3];
		       BooketTime=Item[4];
		       LocDesc=Item[5];
		       Address=Item[6];
		       ResourceDesc=Item[7];
		       EqAdress=Item[8];
		       DOB=Item[9];
		       Age=Item[10];
		       SexDesc=Item[11];
		       MedicareNo=Item[12];
		       PinYin=Item[13];
		       WardName=Item[14];
		       BedNo=Item[15];
		       AppLocName=Item[16]
		       Memo=Item[17];
		       ItmDoc=Item[18];
		            
		   }
	       var OEorditemID1=OrditemID.split("||")[0]+"-"+OrditemID.split("||")[1];
	       /*if(Memo!="")
		    { 
	           Memo=Memo.split("@");
		       Memo1=Memo[0];
		       Memo2=Memo[1];
		       Memo3=Memo[2];
		    }*/
	       
		   var MyPara="PatientName"+String.fromCharCode(2)+Name;
		   MyPara=MyPara+"^OEorditemID1"+String.fromCharCode(2)+OEorditemID1;
		   MyPara=MyPara+"^RegNo1"+String.fromCharCode(2)+"*"+RegNo+"*";
		   MyPara=MyPara+"^RegNo"+String.fromCharCode(2)+RegNo;
		   MyPara=MyPara+"^BookedDate"+String.fromCharCode(2)+BookedDate+" "+BooketTime;
		   MyPara=MyPara+"^LocDesc"+String.fromCharCode(2)+LocDesc;
		   MyPara=MyPara+"^OrderName"+String.fromCharCode(2)+strOrderName;
		   MyPara=MyPara+"^Address"+String.fromCharCode(2)+Address;
		   MyPara=MyPara+"^ResourceDesc"+String.fromCharCode(2)+ResourceDesc;
		   MyPara=MyPara+"^EqAdress"+String.fromCharCode(2)+EqAdress;
		   MyPara=MyPara+"^DOB"+String.fromCharCode(2)+DOB;
		   MyPara=MyPara+"^Age"+String.fromCharCode(2)+Age;
		   MyPara=MyPara+"^SexDesc"+String.fromCharCode(2)+SexDesc;
		   MyPara=MyPara+"^MedicareNo"+String.fromCharCode(2)+MedicareNo;
		   MyPara=MyPara+"^PinYin"+String.fromCharCode(2)+PinYin;
		   MyPara=MyPara+"^Memo"+String.fromCharCode(2)+Memo;
		   MyPara=MyPara+"^WardName"+String.fromCharCode(2)+WardName;
		   MyPara=MyPara+"^BedNo"+String.fromCharCode(2)+BedNo;
		   MyPara=MyPara+"^AppLocName"+String.fromCharCode(2)+AppLocName;
		   MyPara=MyPara+"^ItmDoc"+String.fromCharCode(2)+ItmDoc;
		   
		   //alert(MyPara);
		   var myobj=document.getElementById("ClsBillPrint");
		   DHCP_PrintFun(myobj,MyPara,"");		  	
 	    }
	   
	}
	   
}



function loadOrder()
{
	//alert("load");
	//alert(">"+orderList+"<");
	if( orderList=="")
	{	
		var len=serviceOrderStore.getCount();
		//alert(len);
	
		for (var i=0;i<len;i++)
		{
			sm.selectRow(i,true);
		}
	}
}

Ext.getCmp('btnFind').on('click',clickFind);	
Ext.getCmp('btnCancel').on('click',clickCancel);
Ext.getCmp('btnPrint').on('click',clickPrint);
//Ext.getCmp('btnExport').on('click',clickExport);
serviceOrderStore.on('load',loadOrder);

var init = function(){
	
	var Viewport = new Ext.Viewport({
		id:'viewport',
		layout:'border',
		//labelStyle: 'background:#ffc; padding:10px;',
		items:[
			eastRegion,
			mainpanel,
			orderListRegion
		]
	});
};



Ext.onReady(function(){
	//alert( admSchedule);
	//alert( orderList);
	//alert( LocId );

	if ((LocId=="") || (LocId=="undefined" ))
	{
		LocId=session['LOGON.CTLOCID'];
	}
	
	init();
	
	resourceProxy.on('beforeload',function(objProxy,param){
					 	param.ClassName='web.DHCRisBookSelSeat';
						param.QueryName='QueryResource';
						param.Arg1 = LocId;
						param.ArgCnt = 1;	
	});	
	
	//resourceCmb.getStore().load(); 
	//resourceStore.load();
	//
	//ShowTimeRange();
	var info="";
	var infoList="";
	if (orderList!="")
	{
		var ShowInfo=tkMakeServerCall("web.DHCRisBookSelSeat","getOrderInfo",orderList);
		//alert(ShowInfo);
		infoList=ShowInfo.split("^");
	
		if (ShowInfo!="")
		{
			info=infoList[0]+" [ "+infoList[1]+" ]";
		}
		if (infoList[2]!="")
		{
			Ext.getCmp('bookDate').setValue(infoList[4]);
			info=info+" "+infoList[3]+"("+infoList[4]+" "+infoList[5]+")";
			//alert("1");
			resourceStore.on('load', function(){

					resourceCmb.setRawValue(infoList[3]);
					resourceCmb.setValue(infoList[2]);
					Ext.getCmp('btnFind').fireEvent('click');
			});
			resourceStore.load();
		}
		

	}
	
		
	//resourceStore.load();
	mainpanel.setVisible(true);
	mainpanel.setTitle(info);
	

});