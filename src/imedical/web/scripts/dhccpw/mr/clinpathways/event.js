var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_ER=String.fromCharCode(13)+String.fromCharCode(10);
var separete="&nbsp;";

function InitMainViewportEvent(obj) {
	obj.LoadEvent = function(args){
		obj.InitForm();
		obj.lsvLocClinPathWay.on("click", obj.lsvLocClinPathWay_OnClick, obj);
		obj.PathWayGridPanel.on("rowclick", obj.PathWayGridPanel_OnRowClick, obj);
		obj.btnOutWay.on("click", obj.btnOutWay_OnClick,obj);
		obj.btnFormShow.on("click", obj.btnFormShow_OnClick,obj);
		obj.btnVarRecord.on("click", obj.btnVarRecord_OnClick, obj);
		obj.btnPrintForm.on("click", obj.btnPrintForm_OnClick, obj);
		obj.btnPathWayRst.on("click", obj.btnPathWayRst_OnClick,obj);
		
		obj.InitCPWDetailTabPanel(
					ExtTool.GetParam(window,"CpwVerID"),
					ExtTool.GetParam(window,"CpwDesc")
				);
	};
	
	obj.btnFormShow_OnClick = function(){
		if (!obj.CurrClinPathWay) return;
		FormShowHeader(obj.CurrClinPathWay.Rowid,0,0,0,0,0,0,0);
	}
	
	showCallBack = function(value){
		alert(value);
	}
	
	obj.btnVarRecord_OnClick = function(){
		if ((!obj.CurrClinPathWay)||(!obj.CurrLogon)) return;
		VarianceRecordHeader(obj.CurrClinPathWay.Rowid,obj.CurrLogon.USERID);
	}
	
	obj.btnOutWay_OnClick = function(){
		if ((!obj.CurrClinPathWay)||(!obj.CurrLogon)) return;
		OutPathWayHeader(obj,obj.CurrClinPathWay.Rowid,obj.CurrLogon.USERID);
	}
	
	obj.btnPathWayRst_OnClick = function(){
		var PathWayID="";
		if (!obj.CurrLogon) return;
		if (obj.CurrClinPathWay){
			PathWayID=obj.CurrClinPathWay.Rowid
		}else if (obj.SelClinPathWay){
			PathWayID=obj.SelClinPathWay.Rowid
		}else{
			PathWayID='';
		}
		if (!PathWayID) {
			ExtTool.alert("提示","请选择一个路径记录在操作!");
			return;
		}
		PathWayRstHeader(obj,PathWayID,obj.CurrLogon.USERID);
	}
	
	obj.btnPrintForm_OnClick = function(){
		var PathWayID="",PrintPath="";
		if (obj.CurrClinPathWay){
			PathWayID=obj.CurrClinPathWay.Rowid
		}else if (obj.SelClinPathWay){
			PathWayID=obj.SelClinPathWay.Rowid
		}
		if (!PathWayID) {
			ExtTool.alert("提示","请选择一个路径记录在操作!");
			return;
		}
		var objServer = ExtTool.StaticServerObject("web.DHCCPW.MR.SysBaseSrv");
		if (objServer){
			var serverInfo = objServer.GetServerInfo();
			if (serverInfo) {
				var tmpList = serverInfo.split(CHR_1);
				if (tmpList.length>=7){
					PrintPath = tmpList[4];
				}
			}
		}
		if ((!PathWayID)||(!PrintPath)) return;
		
		var filePath = PrintPath + "\\DHCCPWImplForm.xls";
		
		var title1="",title2="",title3="",title4="";
		var objImplementPrint=ExtTool.StaticServerObject("web.DHCCPW.MR.ImplementPrint");
		var arrSheetList;
		Ext.dhcc.DataToExcelTool.ExcelApp.InitApp();
		var flg=Ext.dhcc.DataToExcelTool.ExcelApp.AddBook(filePath);
		if (flg) {
			arrSheetList=Ext.dhcc.DataToExcelTool.ExcelApp.GetSheetNames();
			if (arrSheetList){
				for (var i=0;i<arrSheetList.length;i++){
					if (arrSheetList[i]=="通用模板"){
						Ext.dhcc.DataToExcelTool.ExcelApp.GetSheet("通用模板");
						
						title1=objImplementPrint.GetTitleInfo(PathWayID,1);
						title2=objImplementPrint.GetTitleInfo(PathWayID,2);
						title3=objImplementPrint.GetTitleInfo(PathWayID,3);
						title4=objImplementPrint.GetTitleInfo(PathWayID,4);
						
						if ((title1)&&(title2)&&(title3)&&(title4)) {
							//表头(名称+准入提示+病人信息+就诊信息)
							Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(1,1,title1);
							Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(2,1,title2);
							Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(3,1,title3);
							Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(4,1,title4);
							
							var row=6,rowStep=0,col=1,len=10;
							var epSteps=objImplementPrint.GetEpSteps(PathWayID);
							if (epSteps){
								var tmpEpStepList=epSteps.split(CHR_1);
								for (var stepInd=0;stepInd<tmpEpStepList.length;stepInd++){
									var epStep=tmpEpStepList[stepInd];
									var tmpEpStepSub=epStep.split(CHR_2);
									if (tmpEpStepSub.length>=2){
										var epStepID=tmpEpStepSub[0];
										var epStepDesc=tmpEpStepSub[1];
										
										//阶段+步骤
										Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,1,epStepDesc);
										Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(row,1,row,4);
										Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeHorizontalAlignment(row,1,row,1,3);
										row++;
										
										//项目明细(主要诊疗工作)
										rowStep=0
										col=1,len=23;
										var tmpItems=objImplementPrint.GetEpStepItems(PathWayID,epStepID,col,len);
										var tmpItemList=tmpItems.split(CHR_1);
										if (tmpItemList.length>rowStep){
											rowStep=tmpItemList.length;
										}
										for (var itemInd=0;itemInd<tmpItemList.length;itemInd++){
											Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row+itemInd,col,tmpItemList[itemInd]);
										}
										
										//项目明细(重要医嘱)
										col=2,len=36;
										var tmpItems=objImplementPrint.GetEpStepItems(PathWayID,epStepID,col,len);
										var tmpItemList=tmpItems.split(CHR_1);
										if (tmpItemList.length>rowStep){
											rowStep=tmpItemList.length;
										}
										for (var itemInd=0;itemInd<tmpItemList.length;itemInd++){
											Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row+itemInd,col,tmpItemList[itemInd]);
										}
										
										//项目明细(主要护理工作)
										col=3,len=24;
										var tmpItems=objImplementPrint.GetEpStepItems(PathWayID,epStepID,col,len);
										var tmpItemList=tmpItems.split(CHR_1);
										if (tmpItemList.length>rowStep){
											rowStep=tmpItemList.length;
										}
										for (var itemInd=0;itemInd<tmpItemList.length;itemInd++){
											Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row+itemInd,col,tmpItemList[itemInd]);
										}
										
										//项目明细(病情变化)
										col=4,len=17;
										var tmpItems=objImplementPrint.GetEpStepItems(PathWayID,epStepID,col,len);
										var tmpItemList=tmpItems.split(CHR_1);
										if (tmpItemList.length>rowStep){
											rowStep=tmpItemList.length;
										}
										for (var itemInd=0;itemInd<tmpItemList.length;itemInd++){
											Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row+itemInd,col,tmpItemList[itemInd]);
										}
										
										//设置下一步骤起始行
										row=row+rowStep;
									}
								}
							}
							//Ext.dhcc.DataToExcelTool.ExcelApp.SaveBook(title1);
							Ext.dhcc.DataToExcelTool.ExcelApp.PrintOut();
							
						}
					}
				}
			}
		}
	    Ext.dhcc.DataToExcelTool.ExcelApp.Close();
	}
	
	obj.InitForm = function(){
		obj.CurrLogon = obj.LoadDHCLogon();
		obj.CurrPaPerson = obj.LoadDHCPaPerson(PatientID);
		obj.CurrPAADM = obj.LoadDHCPAADM(EpisodeID);
		
		obj.lsvLocClinPathWayStore.load({});
		obj.PathWayGridPanelStore.load({});
		obj.CurrClinPathWay = obj.LoadClinPathWay(obj.CurrPAADM.MRAdm);
		if (obj.CurrClinPathWay){
			obj.InitCPWDetailTabPanel(obj.CurrClinPathWay.CPWDR,obj.CurrClinPathWay.CPWDesc);
			obj.btnOutWay.setDisabled(false);
			obj.btnFormShow.setDisabled(false);
			obj.btnVarRecord.setDisabled(false);
		}else{
			obj.btnOutWay.setDisabled(true);
			obj.btnFormShow.setDisabled(true);
			obj.btnVarRecord.setDisabled(true);
		}
		obj.btnPrintForm.setDisabled(true);
		obj.InitFormTitle();
		obj.InitPathWayGridPanel();
		obj.InitCPWSelTabPanelElse();
	}
	
	obj.InitFormTitle = function(){
		var AdmTypeDesc="";
		if ((obj.CurrPAADM)&&(obj.CurrPAADM.AdmType=="O")){
			AdmTypeDesc="门诊病人";
		}else if ((obj.CurrPAADM)&&(obj.CurrPAADM.AdmType=="E")){
			AdmTypeDesc="急诊病人";
		}else if ((obj.CurrPAADM)&&(obj.CurrPAADM.AdmType=="I")){
			AdmTypeDesc="住院病人";
		}else{
			AdmTypeDesc="其他病人";
		}
		var Title = AdmTypeDesc;
		Title = Title + separete + separete + "登记号:"+obj.CurrPaPerson.PapmiNo;
		Title = Title + separete + separete + "姓名:"+obj.CurrPaPerson.PatName;
		Title = Title + separete + separete + "性别:"+obj.CurrPaPerson.PatSex;
		Title = Title + separete + separete + "出生日期:"+obj.CurrPaPerson.BirthDay;
		Title = Title + separete + separete + "就诊日期:"+obj.CurrPAADM.AdmDate;
		Title = Title + separete + separete + "就诊时间:"+obj.CurrPAADM.AdmTime;
		Title = Title + separete + separete + "主管医生:"+obj.CurrPAADM.AdmDoc;
		if (obj.CurrClinPathWay){
			Title = Title + separete + separete + "入院第"+obj.CurrentStep.admDateNo+"日";
			Title = Title + separete + separete + "当前路径:"+obj.CurrClinPathWay.CPWDesc;
			Title = Title + separete + separete + "入径第"+obj.CurrentStep.cpwDateNo+"日";
			Title = Title + separete + separete + "当前步骤:"+obj.CurrentStep.currentStepDesc;
			Title = Title + separete + separete + "当前步骤第"+obj.CurrentStep.currentStepDayNo+"日";
		}
		if(obj.TitlePanel.rendered){
		  obj.TitlePanel.body.update(Title);
		}else{
		  obj.TitlePanel.on("render" , function(){panel.body.update(Title)});
		}
	}
	
	obj.InitPathWayGridPanel = function(){
		obj.PathWayGridPanelStore.load({});
	}
	
	obj.InitCPWSelTabPanelElse = function(){
		//CPWSelTabPanelElse web.DHCCPW.MRC.ClinPathWaysSrv QueryCPWTypeTree
		var objElseTree = new Ext.tree.TreePanel({
			autoScroll : true
			,root : new Ext.tree.AsyncTreeNode({text:'',id:'0'})
			,rootVisible:false
			,autoScroll:true
			,loader : new Ext.tree.TreeLoader({nodeParameter : "Arg1",	dataUrl:ExtToolSetting.TreeQueryPageURL, baseParams : {ClassName:"web.DHCCPW.MRC.ClinPathWaysSrv",	QueryName:"QueryCPWTypeTree" ,ArgCnt:1}})
			,listeners:{
    			"click":function(node,event){
					if (node.isLeaf()){
						obj.InitCPWDetailTabPanel(node.id,node.text);
					}
				}
            }
		});
		Ext.getCmp("CPWSelTabPanelElse").add(objElseTree);
	  	//Ext.getCmp("CPWSelTabPanelElse").doLayout();
	  	//objElseTree.getRootNode().expand();
	}
	
	obj.lsvLocClinPathWay_OnClick = function(v,ind,node,ev){
		if (obj.lsvLocClinPathWay.disabled) return;
		obj.InitCPWDetailTabPanel(node.childNodes[0].innerText,node.childNodes[1].innerText);
	}
	
	obj.menuTreeDetail = new Ext.menu.Menu({
        id:'menuTreeDetail',
        items: [
            {
                id:'menuInPathWay'
                ,text:'入径'
                ,iconCls : 'icon-add'
                ,scope: this
				,disabled : (obj.CurrClinPathWay)
				//,tooltip: '入径'
                ,handler:function(){
                	//update by zf 20101118 控制非住院患者不允许入径
                	/*if (obj.CurrPAADM){
                		if (obj.CurrPAADM.AdmType !="I"){
                			var node = Ext.getCmp('PathWayTree').getSelectionModel().getSelectedNode();
                    		//var node = objPathWayTree.getSelectionModel().getSelectedNode();
                    		obj.munuInPathWay_OnClick(node.id);
                		} else {
                			ExtTool.alert("提示","非住院患者不允许入径,请选择住院记录入径!",Ext.MessageBox.ERROR);
                			return;
                		}
                	}*/
					//Update By NiuCaicai 2011-07-27 FixBug:105  临床应用--出入径管理-已死亡病人仍可进行出入径操作
					if (obj.CurrPaPerson)
					{
						if (obj.CurrPaPerson.PatDeceased=="Y")
						{
							 ExtTool.alert("提示","此患者已经死亡，不能入径!",Ext.MessageBox.ERROR);
							 return;
						}
						else
						{
							 if (obj.CurrPAADM)
								{
									if (obj.CurrPAADM.AdmType=="I") 
									{
									     var node = Ext.getCmp('PathWayTree').getSelectionModel().getSelectedNode();
										 //var node = objPathWayTree.getSelectionModel().getSelectedNode();
										 obj.munuInPathWay_OnClick(node.id);
									} 
									else 
									{
										 ExtTool.alert("提示","非住院患者不允许入径,请选择住院记录入径!",Ext.MessageBox.ERROR);
										 return;
									}					   
								}
						}
					}									                                                     					 
                }
			}
        ]
	});
	
	obj.InitCPWDetailTabPanel = function(cpwRowid,cpwDesc){
		FormShow(obj.CPWFormDetailPanel,null,0,cpwRowid,"",0,0,0,0,0,0,0);
		
	  	var objPathWayTree = new Ext.tree.TreePanel({
			autoScroll : true
			,id : 'PathWayTree'
			,root : new Ext.tree.AsyncTreeNode({text:cpwDesc,id:cpwRowid})
			,region : 'center'
			,rootVisible:(cpwDesc!="")
			,autoScroll:true
			,loader : new Ext.tree.TreeLoader({nodeParameter : "Arg1",	dataUrl:ExtToolSetting.TreeQueryPageURL, baseParams : {ClassName:"web.DHCCPW.MRC.ClinPathWaysSrv",	QueryName:"QueryCPWTree" ,ArgCnt:1}})
			,contextMenu: obj.menuTreeDetail
			,listeners: {
				contextmenu: function(node, e) {
					node.select();
				    var nodeIds=node.attributes.id.split("||");
				    if ((nodeIds.length==3)||(nodeIds.length==1)){
						    var cm = node.getOwnerTree().contextMenu;
							if(!obj.menuTreeDetail){ // create context menu on first right click
					            obj.menuTreeDetail.on('hide', function(){
					            	if(this.ctxNode){
							            this.ctxNode.ui.removeClass('x-node-ctx');
							            this.ctxNode = null;
							        }
							    }, this);
					        }
					        if(node.isLeaf()){
					            this.ctxNode = node;
					            this.ctxNode.ui.addClass('x-node-ctx');
					            this.menu.items.get('load').setDisabled(node.isSelected());
					            this.menu.showAt(e.getXY());
					        }
					        var arr=e.getXY()
					        var menuNum=Ext.getCmp('menuTreeDetail').items.length             //菜单条的个数
					        var mainHeight=Ext.getCmp('PathWayTree').getSize().height         //此treepanel的高度
					        var mainTop=Ext.getCmp('PathWayTree').getPosition()[1]            //此treepanel的Top
					        if(arr[1]+menuNum*25>mainHeight+mainTop){
					        	arr[1]=arr[1]-menuNum*25
					        }
					        obj.menuTreeDetail.showAt(arr);
				    }
				}
			}
		});
		
		obj.CPWTreeDetailPanel.removeAll(true);
		obj.CPWTreeDetailPanel.add(objPathWayTree);
	  	obj.CPWTreeDetailPanel.doLayout();
	  	//objPathWayTree.getRootNode().expand();
	  	//objPathWayTree.expandAll();    //removed by wuqk 2010-05-27
	}
	
	
	obj.PathWayGridPanel_GetDataByRow = function(objTableRow){
		if (objTableRow){
			var objCPW=new ClinicalPathWay();
			objCPW.Rowid = objTableRow.get("Rowid");
			objCPW.MRADMDR = objTableRow.get("CPWMRAdm");
			objCPW.CPWDR = objTableRow.get("CPWDR");
			objCPW.CPWDesc = objTableRow.get("CPWDesc");
			objCPW.CPWEpDR = objTableRow.get("CPWEpDR");
			objCPW.CPWEpDesc = objTableRow.get("CPWEpDesc");
			objCPW.CPWEpStepDR = objTableRow.get("CPWEpStepDR");
			objCPW.CPWEPStepDesc = objTableRow.get("CPWEPStepDesc");
			objCPW.Status = objTableRow.get("Status");
			objCPW.StatusDesc = objTableRow.get("StatusDesc");
			objCPW.InDoctorDR = objTableRow.get("InDoctorDR");
			objCPW.InDoctorDesc = objTableRow.get("InDoctorDesc");
			objCPW.InDate = objTableRow.get("InDate");
			objCPW.InTime = objTableRow.get("InTime");
			objCPW.OutDoctorDR = objTableRow.get("OutDoctorDR");
			objCPW.OutDoctorDesc = objTableRow.get("OutDoctorDesc");
			objCPW.OutDate = objTableRow.get("OutDate");
			objCPW.OutTime = objTableRow.get("OutTime");
			objCPW.OutReasonDR = objTableRow.get("OutReasonDR");
			objCPW.OutReasonDesc = objTableRow.get("OutReasonDesc");
			objCPW.UpdateUserDR = objTableRow.get("UpdateUserDR");
			objCPW.UpdateUserDesc = objTableRow.get("UpdateUserDesc");
			objCPW.UpdateDate = objTableRow.get("UpdateDate");
			objCPW.UpdateTime = objTableRow.get("UpdateTime");
			objCPW.Comments = objTableRow.get("Comments");
			return objCPW;
		}else{
			return null;
		}
	}
	
	obj.PathWayGridPanel_OnRowClick = function(){
		var rowIndex = arguments[1];
		var objRec = obj.PathWayGridPanelStore.getAt(rowIndex);
		var cpwRowid=objRec.get("CPWDR");
		var cpwDesc=objRec.get("CPWDesc");
		if ((cpwRowid)&&(cpwDesc)){
			obj.InitCPWDetailTabPanel(cpwRowid,cpwDesc);
		}
		
		var objSelClinPathWay=obj.PathWayGridPanel_GetDataByRow(objRec);
		if (objSelClinPathWay){
			if ((obj.SelClinPathWay)&&(objSelClinPathWay.Rowid==obj.SelClinPathWay.Rowid)){
				obj.SelClinPathWay = obj.LoadClinPathWay(obj.CurrPAADM.MRAdm);
			}else{
				obj.SelClinPathWay = objSelClinPathWay;
			}
		}
		if (obj.SelClinPathWay){
			obj.btnPrintForm.setDisabled(false);
		}else{
			obj.btnPrintForm.setDisabled(true);
		}
		if(objRec.get("Status") == "O") //Add By LiYang 2011-06-03 FixBug:88 已出径的患者不能够在记录变异记录等信息。
		{
			obj.btnOutWay.disable();
			obj.btnVarRecord.disable();
		}
		else
		{
			obj.btnOutWay.enable();
			obj.btnVarRecord.enable();			
		}
		
	}
	
	obj.LoadClinPathWay = function(argMRAdm){
		var objMRClinicalPathWays = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinicalPathWays");
		if (argMRAdm){
			var ret = objMRClinicalPathWays.GetActiveCPWByadm(argMRAdm,CHR_1);
			obj.CurrentStep = obj.LoadCurrentStep(objMRClinicalPathWays,obj.CurrPAADM.EpisodeID)
		}
		if (ret!=""){
			var arrItems=ret.split(CHR_1);
			var objCPW=new ClinicalPathWay();
			objCPW.Rowid = arrItems[0];
			objCPW.MRADMDR = arrItems[1];
			objCPW.CPWDR = arrItems[2];
			objCPW.CPWDesc = arrItems[3];
			objCPW.CPWEpDR = arrItems[4];
			objCPW.CPWEpDesc = arrItems[5];
			objCPW.CPWEpStepDR = arrItems[6];
			objCPW.CPWEPStepDesc = arrItems[7];
			objCPW.Status = arrItems[8];
			objCPW.StatusDesc = arrItems[9];
			objCPW.InDoctorDR = arrItems[10];
			objCPW.InDoctorDesc = arrItems[11];
			objCPW.InDate = arrItems[12];
			objCPW.InTime = arrItems[13];
			objCPW.OutDoctorDR = arrItems[14];
			objCPW.OutDoctorDesc = arrItems[15];
			objCPW.OutDate = arrItems[16];
			objCPW.OutTime = arrItems[17];
			objCPW.OutReasonDR = arrItems[18];
			objCPW.OutReasonDesc = arrItems[19];
			objCPW.UpdateUserDR = arrItems[20];
			objCPW.UpdateUserDesc = arrItems[21];
			objCPW.UpdateDate = arrItems[22];
			objCPW.UpdateTime = arrItems[23];
			objCPW.Comments = arrItems[24];
			return objCPW;
		}
		return null;
	}
	
	obj.LoadCurrentStep = function(service,EpisodeID){
		var ret = service.GetCurrentStepInfo(EpisodeID,CHR_1)
		if (ret!=""){
			var arrItems=ret.split(CHR_1);
			var objCPW=new CPWStep();
			objCPW.admDateNo = arrItems[0];
			objCPW.cpwDateNo = arrItems[1];
			objCPW.currentStepId = arrItems[2];
			objCPW.currentStepDesc = arrItems[3];
			objCPW.currentStepDayNo = arrItems[4];
			return objCPW;
		}
	}
	
	obj.munuInPathWay_OnClick = function(nodeId){
		
		//1:Rowid 2:MRADMDR 3:PathwayDR 4:PathwayEpStepDR 5:Status 6:InDoctorDR
		//7:InDate 8:InTime 9:OutDoctorDR 10:OutDate 11:OutTime 12:UpdateDate
		//13:UpdateTime 14:OutReasonDR 15:Comments 16:UpdateUserDR
		var objMRClinicalPathWays = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinicalPathWays");
		var ctpcpService = ExtTool.StaticServerObject("web.DHCCPW.MR.CTCareProvSrv");
		var objInPathLogSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWayInPathLogSrv");
		var InputErr="",InputSign="";
		var InDoctor="",InDate="",InTime="";
		var cpwRowid="",cpwStepId="";
		if (obj.CurrClinPathWay){ return;}
		if (nodeId==""){ return;}
		else{
			var cpwArray=nodeId.split("||");
			if (cpwArray.length==3){
				cpwRowid=cpwArray[0];
				cpwStepId=nodeId;
			}
			else{
				cpwRowid=cpwArray[0];
			}
		}
		var docString=ctpcpService.GetCareProvByUserID(obj.CurrLogon.USERID,"^");
		InDoctor=docString.split("^")[0];
		var InputStr="";
		InputStr=InputStr + "^" + obj.CurrPAADM.MRAdm;
		InputStr=InputStr + "^" + cpwRowid; //obj.CurrClinPathWay.CPWDR;
		InputStr=InputStr + "^" + cpwStepId; //obj.CurrClinPathWay.CPWEpStepDR;
		InputStr=InputStr + "^" + "I";
		InputStr=InputStr + "^" + InDoctor;
		InputStr=InputStr + "^" ; //+ InDate;
		InputStr=InputStr + "^" ; //+ InTime;
		InputStr=InputStr + "^";
		InputStr=InputStr + "^";
		InputStr=InputStr + "^";
		InputStr=InputStr + "^";
		InputStr=InputStr + "^";
		InputStr=InputStr + "^";
		InputStr=InputStr + "^"; // + obj.txtaResume.getValue();
		InputStr=InputStr + "^" + obj.CurrLogon.USERID;
		var ret = objMRClinicalPathWays.InPathWay(InputStr);
		if (ret<0){
			ExtTool.alert("提示","入径失败!",Ext.MessageBox.ERROR);
		}else{
			//Modified By LiYang 2011-04-22 记录入径日志
			var logID = ExtTool.GetParam(window,"LogID");
			objInPathLogSrv.UpdateLogResult(logID,ret);
			//tkMakeServerCall("web.DHCCPW.MR.ClinPathWayInPathLogSrv", "UpdateLogResult", logID, ret);
		}
		obj.InitForm();
	}
	
	obj.LoadDHCPaPerson = function(argPatientID){
		var objBasePaPatmasSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.PaPatmasSrv");
		if (argPatientID){
			var ret = objBasePaPatmasSrv.GetPatInfoByID(argPatientID,"",CHR_1);
			if (ret!=""){
				var arrItems=ret.split(CHR_1);
				var objPaPerson=new DHCPaPerson();
				objPaPerson.PatientID = arrItems[0];
				objPaPerson.PapmiNo = arrItems[1];
				objPaPerson.PatName = arrItems[2];
				objPaPerson.PatSex = arrItems[3];
				objPaPerson.BirthDay = arrItems[4];
				objPaPerson.Age = arrItems[5];
				objPaPerson.PatDeceased = arrItems[6];   //Add By NiuCaicai 2011-07-27 FixBug:105  临床应用--出入径管理-已死亡病人仍可进行出入径操作								
				return objPaPerson;
			}
		}
		return null
	}
	
	obj.LoadDHCLogon = function(){
		var objLogon=new DHCLogon();
		objLogon.SITECODE = session['LOGON.SITECODE'];
		objLogon.USERID = session['LOGON.USERID'];
		objLogon.USERCODE = session['LOGON.USERCODE'];
		objLogon.USERNAME = session['LOGON.USERNAME'];
		objLogon.GROUPID = session['LOGON.GROUPID'];
		objLogon.GROUPDESC = session['LOGON.GROUPDESC'];
		objLogon.CTLOCID = session['LOGON.CTLOCID'];
		var objBaseCTCareProvSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.CTCareProvSrv");
		if (objLogon.USERID){
			var ret = objBaseCTCareProvSrv.GetCareProvByUserID(objLogon.USERID,CHR_1);
			if (ret!=""){
				var arrItems=ret.split(CHR_1)
				objLogon.CAREPROVID = arrItems[0];
				objLogon.CAREPROVDesc = arrItems[1];
			}
		}
		return objLogon;
	}
	
	obj.LoadDHCPAADM = function(argEpisodeID){
		var objBasePAADMSrv = ExtTool.StaticServerObject("web.DHCCPW.MR.PAADMSrv");
		if (argEpisodeID){
			var ret = objBasePAADMSrv.GetAdmInfoByID(argEpisodeID,CHR_1);
			if (ret!=""){
				var arrItems=ret.split(CHR_1);
				var objPaadm=new DHCPAADM();
				objPaadm.EpisodeID = arrItems[0];
				objPaadm.AdmType = arrItems[1];
				objPaadm.AdmDate = arrItems[2];
				objPaadm.AdmTime = arrItems[3];
				objPaadm.AdmDoc = arrItems[4];
				objPaadm.AdmLoc = arrItems[5];
				objPaadm.AdmWard = arrItems[6];
				objPaadm.AdmRoom = arrItems[7];
				objPaadm.AdmBed = arrItems[8];
				objPaadm.AdmStatus = arrItems[9];
				objPaadm.DischDate = arrItems[10];
				objPaadm.DischTime = arrItems[11];
				objPaadm.MRAdm = arrItems[12];
				return objPaadm;
			}
		}
		return null;
	}
}

function DHCLogon(){
	var objTMP = new Object();
	objTMP.SITECODE = "";
	objTMP.USERID = "";
	objTMP.USERCODE = "";
	objTMP.USERNAME = "";
	objTMP.GROUPID = "";
	objTMP.GROUPDESC = "";
	objTMP.CTLOCID ="";
	objTMP.CAREPROVID ="";
	objTMP.CAREPROVDesc ="";
	return objTMP;
}

function DHCPaPerson(){
	var objTMP = new Object();
	objTMP.PatientID = "";
	objTMP.PapmiNo = "";
	objTMP.PatName = "";
	objTMP.PatSex = "";
	objTMP.BirthDay = "";
	objTMP.Age = "";
	return objTMP;
}

function DHCPAADM(){
	var objTMP = new Object();
	objTMP.EpisodeID = "";
	objTMP.AdmType = "";
	objTMP.AdmDate = "";
	objTMP.AdmTime = "";
	objTMP.AdmDoc = "";
	objTMP.AdmLoc = "";
	objTMP.AdmWard ="";
	objTMP.AdmRoom ="";
	objTMP.AdmBed ="";
	objTMP.AdmStatus = "";
	objTMP.DischDate = "";
	objTMP.DischTime = "";
	objTMP.MRAdm = "";
	return objTMP;
}

function ClinicalPathWay(){
	var objTMP = new Object();
	objTMP.Rowid = "";
	objTMP.MRADMDR = "";
	objTMP.CPWDR = "";
	objTMP.CPWDesc = "";
	objTMP.CPWEpDR = "";
	objTMP.CPWEpDesc = "";
	objTMP.CPWEpStepDR ="";
	objTMP.CPWEPStepDesc ="";
	objTMP.Status ="";
	objTMP.StatusDesc ="";
	objTMP.InDoctorDR ="";
	objTMP.InDoctorDesc ="";
	objTMP.InDate ="";
	objTMP.InTime ="";
	objTMP.OutDoctorDR ="";
	objTMP.OutDoctorDesc ="";
	objTMP.OutDate ="";
	objTMP.OutTime ="";
	objTMP.OutReasonDR ="";
	objTMP.OutReasonDesc ="";
	objTMP.UpdateUserDR ="";
	objTMP.UpdateUserDesc ="";
	objTMP.UpdateDate ="";
	objTMP.UpdateTime ="";
	objTMP.Comments ="";
	return objTMP;
}

function CPWStep(){
	var objTMP = new Object();
	objTMP.admDateNo = "";
	objTMP.cpwDateNo = "";
	objTMP.currentStepId = "";
	objTMP.currentStepDesc = "";
	objTMP.currentStepDayNo = "";
	return objTMP;
}