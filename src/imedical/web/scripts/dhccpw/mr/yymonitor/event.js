
function InitMonitorViewportEvent(obj)
{
	obj.LoadEvent = function(args)
	{
		obj.btnQuery.on("click", obj.btnQuery_OnClick, obj);
		obj.cboLoc.on("expand", obj.cboLoc_OnExpand, obj);
		obj.cboWard.on("expand", obj.cboWard_OnExpand, obj);
		obj.ResultGridPanel.on("rowclick", obj.ResultGridPanel_OnRowClick, obj);
		obj.btnFromShow.on("click", obj.btnFromShow_OnClick, obj);
		obj.btnVarRecord.on("click", obj.btnVarRecord_OnClick, obj);
		obj.btnOeordItem.on("click", obj.btnOeordItem_OnClick, obj);
		obj.btnMonitorRst.on("click", obj.btnMonitorRst_OnClick, obj);
		obj.btnExport.on("click", obj.btnExport_OnClick, obj);
		obj.btnPrintForm.on("click", obj.btnPrintForm_OnClick, obj);
		obj.InitForm();
	}
	obj.InitForm = function()
	{
		//var QueryPower = ExtTool.GetParam(window,"QueryPower");
		//if (QueryPower=='Loc'){
		//tDHCMedMenuOper['Admin']=1;  //����Ա
    //tDHCMedMenuOper['Loc']=0;  //����
		if (typeof tDHCMedMenuOper=='undefined') {obj.btnQuery.setDisabled(true);ExtTool.alert('��ʾ','����ȷ����Ȩ��');}
		else{
			if ((tDHCMedMenuOper['Loc']==0) & (tDHCMedMenuOper['Admin']==0)) {obj.btnQuery.setDisabled(true);ExtTool.alert('��ʾ','����ȷ����Ȩ��');}
			else if (tDHCMedMenuOper['Loc']==1){
				var LoadLocID=session['LOGON.CTLOCID'];
				var objLoadLoc=ExtTool.StaticServerObject("web.DHCCPW.MR.SysBaseSrv");
				if ((objLoadLoc)&&(LoadLocID!=="")) {
					var ret = objLoadLoc.GetLocByID(LoadLocID,"^");
					if (ret){
						var tmpList=ret.split("^");
						if (tmpList[3]=="W"){
							obj.cboWard.setValue(tmpList[0]);
							obj.cboWard.setRawValue(tmpList[2]);
							obj.cboWard.setDisabled(true);
						} else {
							obj.cboLoc.setValue(tmpList[0]);
							obj.cboLoc.setRawValue(tmpList[2]);
							obj.cboLoc.setDisabled(true);
						}
					}
				}
			}
		}
	}
	obj.btnQuery_OnClick = function()
	{
		obj.ResultGridPanelStore.load({params : {start : 0,limit : 100}});
	}
	obj.cboLoc_OnExpand = function(){
		obj.cboLocStore.load({});
	}
	obj.cboWard_OnExpand = function(){
		obj.cboWardStore.load({});
	}
	obj.ResultGridPanel_OnRowClick = function(){
		var rowIndex = arguments[1];
		var objRec = obj.ResultGridPanelStore.getAt(rowIndex);
		obj.PathWayID = objRec.get("Rowid");
		obj.CPWID = objRec.get("PathwayDR");
		obj.UserID = session['LOGON.USERID'];
		obj.EpisodeID = objRec.get("Paadm");
	}
	obj.btnVarRecord_OnClick = function(){
		if ((!obj.PathWayID)||(!obj.UserID)) return;
		VarianceRecordHeader(obj.PathWayID,obj.UserID);
	}
	obj.btnOeordItem_OnClick = function(){
		if (!obj.EpisodeID) return;
		OeordItemLookUpHeader(obj.EpisodeID);
	}
	obj.btnMonitorRst_OnClick = function(){
		if ((!obj.PathWayID)||(!obj.UserID)) return;
		MonitorRstLookUpHeader(obj.PathWayID,obj.UserID);
	}
	obj.btnFromShow_OnClick = function(){
		var SelRow=obj.ResultGridPanel.getSelectionModel();
		obj.PathWayID="";
		if (SelRow){
			  if (typeof SelRow.selections.items[0]!="undefined"){
				   obj.PathWayID = SelRow.selections.items[0].data.Rowid;
		       obj.CPWID =SelRow.selections.items[0].data.PathwayDR;
		       obj.UserID = session['LOGON.USERID'];
		       obj.EpisodeID = SelRow.selections.items[0].data.Paadm;
		    }else{
		    	  alert("��ѡ��һ�����뾶��¼��");
		    	 return ;	
		    }
		   FormShowHeader(obj.PathWayID,0,0,0,0,0,0,0);
		}
		else{
			alert("��ѡ��һ�����뾶��¼��");
		}
		obj.chkSelect.enable(true); // add by zhoubo 2014-12-23 fixbug
	}
	obj.btnExport_OnClick = function(){
		//var strFileName="���뾶���߼�¼(�뾶��ѯ)";
		//var objExcelTool=Ext.dhcc.DataToExcelTool;
		//objExcelTool.ExprotGrid(obj.ResultGridPanel,strFileName);
		
		if (obj.ResultGridPanel.getStore().getCount() < 1) {
			ExtTool.alert("��ʾ", "�����ݼ�¼����������!");
			return;
		}
		var strFileName = "���뾶��ϸ�б�";
		ExportGridByCls(obj.ResultGridPanel, strFileName);
	}
	obj.btnPrintForm_OnClick = function(){
		var PathWayID="",PrintPath="";
		var SelRow=obj.ResultGridPanel.getSelectionModel();
		obj.PathWayID="";
		if (SelRow){
			  if (typeof SelRow.selections.items[0]!="undefined"){
				   obj.PathWayID = SelRow.selections.items[0].data.Rowid;
		       obj.CPWID =SelRow.selections.items[0].data.PathwayDR;
		       obj.UserID = session['LOGON.USERID'];
		       obj.EpisodeID = SelRow.selections.items[0].data.Paadm;
		    }else{
		    	  alert("��ѡ��һ�����뾶��¼��");
		    	 return ;	
		    }
		}
		else{
			alert("��ѡ��һ�����뾶��¼��");
			return ;
		}
		//PathWayID=obj.CPWID;
		PathWayID=obj.PathWayID; //Modified By LiYang 2011-03-05 FixBug:43 ��ѯͳ��--���뾶��ϸ��ѯ-��ӡ����ӡ���Ĳ���ѡ�е���Ϣ
		PrintPathWayForm(PathWayID);
		/*
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
		
		//var filePath = PrintPath + "\\DHCCPWImplForm.xls";
		var filePath = PrintPath + "/DHCCPWImplForm.xls"; //Modified By LiYang 2011-03-02 ��Http������,ʹ��"/"���ָ�Ŀ¼

		var title1="",title2="",title3="",title4="";
		var objImplementPrint=ExtTool.StaticServerObject("web.DHCCPW.MR.ImplementPrint");
		var arrSheetList;
		Ext.dhcc.DataToExcelTool.ExcelApp.InitApp();
		var flg=Ext.dhcc.DataToExcelTool.ExcelApp.AddBook(filePath);
		if (flg) {
			arrSheetList=Ext.dhcc.DataToExcelTool.ExcelApp.GetSheetNames();
			if (arrSheetList){
				for (var i=0;i<arrSheetList.length;i++){
					if (arrSheetList[i]=="ͨ��ģ��"){
						Ext.dhcc.DataToExcelTool.ExcelApp.GetSheet("ͨ��ģ��");
						
						title1=objImplementPrint.GetTitleInfo(PathWayID,1);
						title2=objImplementPrint.GetTitleInfo(PathWayID,2);
						title3=objImplementPrint.GetTitleInfo(PathWayID,3);
						title4=objImplementPrint.GetTitleInfo(PathWayID,4);
						
						if ((title1)&&(title2)&&(title3)&&(title4)) {
							//��ͷ(����+׼����ʾ+������Ϣ+������Ϣ)
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
										
										//�׶�+����
										Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,1,epStepDesc);
										Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(row,1,row,4);
										Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeHorizontalAlignment(row,1,row,1,3);
										row++;
										
										//��Ŀ��ϸ(��Ҫ���ƹ���)
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
										
										//��Ŀ��ϸ(��Ҫҽ��)
										col=2,len=36;
										var tmpItems=objImplementPrint.GetEpStepItems(PathWayID,epStepID,col,len);
										var tmpItemList=tmpItems.split(CHR_1);
										if (tmpItemList.length>rowStep){
											rowStep=tmpItemList.length;
										}
										for (var itemInd=0;itemInd<tmpItemList.length;itemInd++){
											Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row+itemInd,col,tmpItemList[itemInd]);
										}
										
										//��Ŀ��ϸ(��Ҫ������)
										col=3,len=24;
										var tmpItems=objImplementPrint.GetEpStepItems(PathWayID,epStepID,col,len);
										var tmpItemList=tmpItems.split(CHR_1);
										if (tmpItemList.length>rowStep){
											rowStep=tmpItemList.length;
										}
										for (var itemInd=0;itemInd<tmpItemList.length;itemInd++){
											Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row+itemInd,col,tmpItemList[itemInd]);
										}
										
										//��Ŀ��ϸ(����仯)
										col=4,len=17;
										var tmpItems=objImplementPrint.GetEpStepItems(PathWayID,epStepID,col,len);
										var tmpItemList=tmpItems.split(CHR_1);
										if (tmpItemList.length>rowStep){
											rowStep=tmpItemList.length;
										}
										for (var itemInd=0;itemInd<tmpItemList.length;itemInd++){
											Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row+itemInd,col,tmpItemList[itemInd]);
										}
										
										//������һ������ʼ��
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
	    */
	}
}


//��ӡҽʦ���ٴ�·����
function PrintPathWayForm(PathWayID){
	var PrintPath="";
	if (!PathWayID) {
		ExtTool.alert("��ʾ","��ѡ��һ�����뾶��¼�ٴ�ӡ!");
		return;
	}
	
	// update by zf 2012-07-18
	var objMRClinPathWaysResult = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWaysResult");
	if (objMRClinPathWaysResult){
		var flg=objMRClinPathWaysResult.IsSaveResult(PathWayID);
		if (flg!='1') {
			ExtTool.alert("��ʾ","����д��Ч������¼�ٴ�ӡ!");
			return;
		}
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
				if (arrSheetList[i]=="ͨ��ģ��"){
					Ext.dhcc.DataToExcelTool.ExcelApp.GetSheet("ͨ��ģ��");
					
					title1=objImplementPrint.GetTitleInfo(PathWayID,1);
					title2=objImplementPrint.GetTitleInfo(PathWayID,2);
					title3=objImplementPrint.GetTitleInfo(PathWayID,3);
					title4=objImplementPrint.GetTitleInfo(PathWayID,4);
					
					if ((title1)&&(title2)&&(title3)&&(title4)) {
						//��ͷ(����+׼����ʾ+������Ϣ+������Ϣ)
						
						Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(1,1,title1);
						var title2ls=title2.split(CHR_1);
						Ext.dhcc.DataToExcelTool.ExcelApp.SetCellsRowHeigthByRow(2,15*title2ls[0]);
						Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(2,1,title2ls[1]);
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
									var epStepSign=tmpEpStepSub[2];
									
									//�׶�+����
									Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,1,epStepDesc);
									Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(row,1,row,4);
									Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeHorizontalAlignment(row,1,row,1,3);
									row++;
									
									//ǩ����Ϣ
									Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row,1,epStepSign);
									Ext.dhcc.DataToExcelTool.ExcelApp.MergeCells(row,1,row,4);
									Ext.dhcc.DataToExcelTool.ExcelApp.SetRangeHorizontalAlignment(row,1,row,1,3);
									row++;
									
									//��Ŀ��ϸ(��Ҫ���ƹ���)
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
									
									//��Ŀ��ϸ(��Ҫҽ��)
									col=2,len=36;
									var tmpItems=objImplementPrint.GetEpStepItems(PathWayID,epStepID,col,len);
									var tmpItemList=tmpItems.split(CHR_1);
									if (tmpItemList.length>rowStep){
										rowStep=tmpItemList.length;
									}
									for (var itemInd=0;itemInd<tmpItemList.length;itemInd++){
										Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row+itemInd,col,tmpItemList[itemInd]);
									}
									
									//��Ŀ��ϸ(��Ҫ������)
									col=3,len=24;
									var tmpItems=objImplementPrint.GetEpStepItems(PathWayID,epStepID,col,len);
									var tmpItemList=tmpItems.split(CHR_1);
									if (tmpItemList.length>rowStep){
										rowStep=tmpItemList.length;
									}
									for (var itemInd=0;itemInd<tmpItemList.length;itemInd++){
										Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row+itemInd,col,tmpItemList[itemInd]);
									}
									
									//��Ŀ��ϸ(����仯)
									col=4,len=17;
									var tmpItems=objImplementPrint.GetEpStepItems(PathWayID,epStepID,col,len);
									var tmpItemList=tmpItems.split(CHR_1);
									if (tmpItemList.length>rowStep){
										rowStep=tmpItemList.length;
									}
									for (var itemInd=0;itemInd<tmpItemList.length;itemInd++){
										Ext.dhcc.DataToExcelTool.ExcelApp.WriteData(row+itemInd,col,tmpItemList[itemInd]);
									}
									
									//������һ������ʼ��
									row=row+rowStep;
								}
							}
						}
						//ֱ�ӱ���
						//Ext.dhcc.DataToExcelTool.ExcelApp.SaveBook(title1);
						//ֱ�Ӵ�ӡ
						//Ext.dhcc.DataToExcelTool.ExcelApp.PrintOut();
						//��ӡԤ��
						Ext.dhcc.DataToExcelTool.ExcelApp.SetVisible(true);
						Ext.dhcc.DataToExcelTool.ExcelApp.PrintOut(true);
					}
				}
			}
		}
	}
	//ֱ�ӱ���+ֱ�Ӵ�ӡ Close
    //Ext.dhcc.DataToExcelTool.ExcelApp.Close();
    //��ӡԤ�� Close
    Ext.dhcc.DataToExcelTool.ExcelApp.Close(true);
}
