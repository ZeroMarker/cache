function InitViewScreenEvent(obj)
{
	obj._DHCANCInquiry=ExtTool.StaticServerObject('web.DHCANCInquiry');
	obj._DHCANOPStat=ExtTool.StaticServerObject('web.DHCANOPStat');
	obj.isPrintAfterLoad = false;
	obj.selectObj = null;
	obj.checkPrintCols = new Object();
	
	obj.LoadEvent = function(args)
	{
		var url=location.search; 
	    if(url.indexOf("?")!=-1) {         
			var str = url.substr(1)
			strs = str.split("&");        
			for(var i=0;i<strs.length;i++)         
			{               
				obj[strs[i].split("=")[0]]=unescape(strs[i].split("=")[1]);         
			}
			obj.anciId=obj["anciId"];
			obj.displayId=obj["displayId"];
			obj.fieldName=obj["fieldName"];
			ShowStatCellDetailTitle();
			obj.retGridPanelStore.load({});
			LoadPrintCols();
	    }
	};
	function LoadPrintCols()
	{
		var columnModel=obj.retGridPanel.getColumnModel();
		var cols=columnModel.getColumnCount();//显示列数
		for(var j=2;j<cols;j++)
		{
			var colName=columnModel.getDataIndex(j);
			var colVal=columnModel.getColumnHeader(j);
			if(colVal)
			{
				obj.resultColsPrintPanel.add(new Ext.form.Checkbox({
					id : 'chkPrintCol_'+colName
					,anchor : '95%'
					,checked : true
					,boxLabel : colVal
					,listeners :{
						'check':function(){
							var colName = this.id.split("_")[1];
							obj.checkPrintCols[colName]=this.getValue();
						}
					}
				})
				);
				obj.checkPrintCols[colName] = true;
			}
		}
		
		obj.resultColsPrintPanel.doLayout(true);
	}
	obj.retGridPanel_rowclick = function()
	{
		var rowSelectObj=obj.retGridPanel.getSelectionModel().getSelected();
		if(rowSelectObj!=obj.selectObj)
		{
			if(obj.winScreen.isVisible())obj.winScreen.hide();
			obj.selectObj = rowSelectObj;
		}
	}
	function ShowStatCellDetailTitle()
	{
		var detailtitle = obj._DHCANOPStat.GetStatDetailTitle(obj.anciId,obj.displayId,obj.fieldName,obj.historySeq);
		obj.resultPanel.setTitle(obj.resultPanel.title+":  "+detailtitle);
	}
	obj.retGridPanelStore_load=function(args)
	{
		if(obj.isPrintAfterLoad)
		{
			PrintAllAnOpList();
			obj.isPrintAfterLoad = false;
		}
	}
	obj.retGridPanelStore_loadexception=function(args)
	{
		try{
			var errorText = obj.retGridStoreReponseText.split("</font>")[1].split("<ul>")[1].split("</ul>")[0];
			errorText = "<ul>"+errorText+"</ul>";
			Ext.Msg.show({
			   title: '程序运行错误',
			   msg: "<div>"+errorText+"</div>",
			   buttons: Ext.MessageBox.OK,
			   icon: Ext.MessageBox.ERROR,
			   width:600
			});
		}
		catch(ex)
		{}
		obj.SetButtonAbility(true);
	}
	obj.btnPrintResult_click=function(args)
	{
		obj.isPrintAfterLoad = true;
		obj.retGridPanelStore.load({
			params : {
				start:0
				,limit:5000
			}
		});
	}
	obj.btnANMonitor_click=function(args)
	{
		var count=obj.retGridPanelCheckCol.getCount();
		if(count>1)
		{
			alert("只能选择一条手术,请重新选择！");
			return;
		}
		var selectObj = obj.retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
		{
			var status=selectObj.get('status');
			if ((status!='安排')&&(status!='术毕')&&(status!='术中')&&(status!='恢复室')&&(status!='完成'))
			{
				alert("能操作的手术状态为:"+"安排"+","+"术中"+","+"术毕"+",恢复室"+","+"完成");
				return;
			}
			var str="";
			var opaId="";
			opaId=selectObj.get('opaId');
			//var EpisodeID="";
			var Type="AN";
			//var connectStr=obj._DHCCLCom.GetConnectStr();
			//var userCTLOCId=session['LOGON.CTLOCID'];
			//var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANDisplay&icuaId="+opaId+"&connectStr="+connectStr+"&isSuperUser="+false+"&userCTLOCId="+userCTLOCId+"&documentType="+"AN";
			//window.showModalDialog(lnk,"DHCAna","dialogWidth:1280px;dialogHeight:1024px;status:no;menubar:no;");
			
			var lnk= "dhcanrecord.csp?opaId="+opaId+"&documentType="+Type;
			window.open(lnk,"DHC手术麻醉监护信息系统","height=900,width=1366,toolbar=no,menubar=no,resizable=yes");
		}
		else
		{
		  alert("请选择一条手术记录");
		}
	}
	function PrintAllAnOpList()
	{
		var operNum;
		var xlsExcel,xlsBook,xlsSheet;
		var row=1;
		xlsExcel = new ActiveXObject("Excel.Application");
		xlsBook = xlsExcel.Workbooks.Add();
		xlsSheet = xlsBook.ActiveSheet;
		var count=obj.retGridPanelStore.getCount();//数据行数
		var columnModel=obj.retGridPanel.getColumnModel();
		var cols=columnModel.getColumnCount();//显示列数
		var checkColArr=new Array();
		var colnum=0;
		var tmpPrintCols=obj.checkPrintCols;
		for(var j=1;j<cols;j++)
			{
				var colName=columnModel.getDataIndex(j);
				var colVal=columnModel.getColumnHeader(j);
				if(obj.checkPrintCols[colName])
				{
					colnum++;
					checkColArr.push(colName);
					if(colVal)
					{
						xlsSheet.cells(row,colnum)=colVal;
					}
					else xlsSheet.cells(row,colnum)="";
				}
			}
		row=row+1;
		cols = checkColArr.length;
		for (var i=0;i<count;i++)
		{
			var record=obj.retGridPanelStore.getAt(i);
			row=row+1;
			for(var j=0;j<cols;j++)
			{
				var colName=checkColArr[j];
				var colVal=record.get(colName);
				if(colVal && typeof colVal=="string")
				{
					if(colVal.indexOf("ShowOpaInfo")>-1)
					{
						var displayDesc = colVal.split("<")[0];
						colVal = GetOpaInfo(colVal);
						colVal = displayDesc+"\n"+colVal;
					}
					xlsSheet.cells(row,j+1)=colVal;
				}
				else xlsSheet.cells(row,j+1)="";
			}
		}
		xlsExcel.Visible = true;
		//xlsSheet.PrintPreview;
		//xlsSheet.PrintOut(); 
	}
	function GetOpaInfo(link)
	{
		var idStr=link.split("ShowOpaInfo(")[1].split(")")[0];
		var idArr=idStr.split(",");
		if(idArr.length<4) return "";
		return obj._DHCANOPStat.GetOpaInfo(idArr[0],idArr[1],idArr[2],idArr[3]);
	}
}