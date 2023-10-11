//var LabLoc = new Ext.form.ComboBox({id:'LabLoc',width:100,store:new Ext.data.SimpleStore({data : [],fields: ['desc', 'id']}), 
//	displayField:'desc',valueField:'id',allowBlank: true,	mode:'local',	value:'',forceSelection : true,triggerAction:'all'});
function BodyLoadHandler()
{
	setsize("mygridpl","gform","mygrid");
	grid=Ext.getCmp('mygrid');
	grid.setTitle("最近接单查询统计");
  
	var but1=Ext.getCmp("mygridbut1");
	but1.hide();
	var but=Ext.getCmp("mygridbut2");
	but.hide();
	var mydate=new Date();
	var tobar=grid.getTopToolbar();
	tobar.addItem("开始日期：",{xtype:'datefield',format: 'Y-m-d',id:'mygridstdate',value:diffDate(new Date(),0)},
								"-",
	    					"结束日期：",{xtype:'datefield',format: 'Y-m-d',id:'mygridenddate',value:diffDate(new Date(),0)});
	
	tobar.addButton({width:80,text: "查询",icon:'../images/uiimages/search.png',handler: find});
	tobar.addButton({width:100,text: "补打信息卡",icon:'../images/uiimages/print.png',handler: printPatInfoCard});
	tobar.addButton({width:100,text: "补打瓶签",icon:'../images/uiimages/print.png',handler: printTPQ});
	tobar.addButton({width:100,text: "打印",icon:'../images/uiimages/print.png',handler: printAll});
	tbar2=new Ext.Toolbar({});
	           	
	tbar2.render(grid.tbar);
	tobar.doLayout();
	grid.getBottomToolbar().pageSize=20;
	grid.store.on("beforeLoad",BeforeLoad);
	grid.addListener("rowdblclick",gridRow_dbclick);

	find();
}

function BeforeLoad()
{
	grid.store.baseParams.locId=session['LOGON.CTLOCID'];
	var stDate = Ext.getCmp("mygridstdate");
	var endDate = Ext.getCmp("mygridenddate");
	grid.store.baseParams.stDate=stDate.value;
	grid.store.baseParams.endDate=endDate.value;
	
	//grid.store.baseParams.status=labstatus;
}

function find()
{
	grid=Ext.getCmp('mygrid');
	grid.store.load({params:{start:0,limit:20}});
}

function printPatInfoCard()
{
		var rowObj = grid.getSelectionModel().getSelections();
		var len = rowObj.length;
		if(len==0)
		{
			alert("请选择一条记录！");
			return;	
		}
		var patIdStr="",patQueueNoStr="",patQueueIdStr="";
		for (var r = 0;r < len; r++) {
			var patId=rowObj[r].data["patId"];
			var patQueue=rowObj[r].data["patQueue"];
			var id=rowObj[r].data["Id"];
			if(patIdStr=="") patIdStr=patId;
			else patIdStr=patIdStr+"^"+patId;
			
			if(patQueueNoStr=="") patQueueNoStr=patQueue;
			else patQueueNoStr=patQueueNoStr+"^"+patQueue;
			
			if(patQueueIdStr=="")patQueueIdStr=id;
			else patQueueIdStr=patQueueIdStr+"^"+id;
	   }
	  DHCCNursePrintComm.showOtherSingleSheet(patIdStr + "$$" + session['LOGON.CTLOCID']+"$"+patQueueNoStr+"$$"+patQueueIdStr,"BedCard",webIP,"NurseOrderOP.xml", "2")

	  }

function printTPQ()
{
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len==0)
	{
		alert("请选择一条记录！");
		return;	
	}
	for (var r = 0;r < len; r++) {
		var queueId=rowObj[r].data["Id"];
		var ordInfoStr=tkMakeServerCall("web.DHCIFWorkLoad","getLinkOrdById",queueId);
		if(ordInfoStr=="") continue;
		var ordIdStr=ordInfoStr.split("#")[0];
		var seqNoStr=ordInfoStr.split("#")[1];
		DHCCNursePrintComm.showNurseExcuteSheetPreview(ordIdStr, seqNoStr, "T", "SYDO", session['LOGON.HOSPID'], true, 1, webIP, "true", 1, "NurseOrderOP.xml");
    }
}

function gridRow_dbclick()
{
	var mygrid=Ext.getCmp("mygrid");
	var rowObj = mygrid.getSelectionModel().getSelections();
	var Id=rowObj[0].get("Id");
	
	var width=(window.screen.width-280)+"px";
	var height=(window.screen.height-280)+"px";
	var lnk ="websys.default.csp?WEBSYS.TCOMPONENT=DHCNurInfusionRegDetail&queueId="+Id; 
	var newWind=window.showModalDialog(lnk, window, "toolbar:no;location:no;directories:no;status:no;menubar:no;scrollbar:no;resizable:no;dialogHeight:"+height+";dialogWidth:"+width);
	
}
function printAll()
{
	PrintCommPic.TitleStr=tkMakeServerCall("web.DHCMGNurComm","PatInfo",EpisodeID);
	PrintCommPic.SetPreView("1");								//打印时是否预览：1预览，0不预览
	PrintCommPic.WebUrl=webIP+"/dthealth/web/DWR.DoctorRound.cls"; //
	PrintCommPic.stPage=0;
	PrintCommPic.stRow=0;
	PrintCommPic.previewPrint="1"; 										//是否弹出设置界面
	PrintCommPic.stprintpos=0;
	PrintCommPic.dxflag = 1; 											//分割线设置：1一条记录打印一条线 0 一行打印一条线
	PrintCommPic.ItmName = "DHCNURMouldPrn_ZJJDCCTJDY"; //打印模板				
	PrintCommPic.previewPrint = "0"; 									//是否弹出设置界面:0不弹出，1弹出   
	var stDate = Ext.getCmp("mygridstdate").value;
	var endDate = Ext.getCmp("mygridenddate").value;
	// 注：加 EpisodeID	和 DHCNURBG_YYRSTJ是为了使调用护理病历打印程序不报错			注意不要少了最后一个！
	// 加载后台数据有用参数就 stDate    endDate   
	var parr = EpisodeID + "!" + stDate + "!" + endDate  + "!" +session['LOGON.CTLOCID']+"!!"+"DHCNURBG_ZJJDJLD" + "!"; 	
	//alert(parr)
	PrintCommPic.ID = "";	
	PrintCommPic.MultID = "";
	PrintCommPic.SetParrm(parr);
	PrintCommPic.PrintOut();
}